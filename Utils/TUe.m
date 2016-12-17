classdef (Sealed) TUe < HiddenHandle
    % Class which gives access to and caches constants as defined in 
    % SetupConstants.m
    %
    % Syntax:
    % >> MyConstant   = TUe.Constants.dsm.Controller.MyVar
    % >> TUe.Reload(); % flushes the cache and reloads all constants
    %
    % All the Constants will be kept in memory during the entire 
    % matlabsession. When you want to Reload the constants from the
    % files use the TUe.Reload(); syntax.
    %
    % This class is special because it uses a trick to force the existance
    % of only one single instance (object). The trick is described in the
    % matlab help: "Controlling the Number of Instances".
    
    properties (Access=private)
        % The Constants, Settings are saved in the following
        % properties. This is not nessesary but handy. They are private so
        % no outside function can acces them.
        Const
    end
    
    methods (Access=private)
        function obj = TUe()
            % This is the constructor and is called if an instance of the
            % class is needed / created. This method is made private to
            % prevent multiple object existance to be possible.
            obj.Const=TUe.GetConstants();
        end % function obj = TUe()
    end % methods (Access=private)
    
    methods (Static)
        % The static methods do not need an object to be present and are
        % accesable from the outside by calling TUe.StaticMethod()
        
        function struc=Constants()
            % Gives acces to the SetupConstants.
            % First get the database object:
            obj=TUe.GetClassInstance('NoReset');
            % Then set the output-argument to the structure:
            struc=obj.Const;
        end
        function value = Constants_GetField(field)
            % Load value from Constants struct
            if nargin < 1 || ~ischar(field),
                 error('The function %s expects a string as input argument', getfield(dbstack(0), 'name'));
            end
            value = eval(sprintf('TUe.Constants().%s;', field));
        end
        function value = Constants_GetField_Fallback(field, fallback)
            % Load value from Constants struct with fallback to given value
            if nargin < 2 || ~ischar(field),
                 error('The function %s expects two input arguments where the first is a string', getfield(dbstack(0), 'name'));
            end
            try
                value = TUe.Constants_GetField(field);
            catch
                value = fallback;
            end
        end
        function Reload()
            % Reloads the Constants
            TUe.GetClassInstance('Reset');
        end
        function Edit()
            % Helper function to load SetupConstants in editor
            edit(which('SetupConstants'));
            fprintf('Opened the file SetupConstants.m - modify to your needs, save the file and call TUe.Reload() to flush the cached constants\n');
        end
    end % methods (Static)
    
    methods (Static,Access=private, Hidden)
        % This static methods are also private and hidden, so not accesable
        % and not visable from outside the class:
        function Constants = GetConstants()
            % This method is called to get the constants from the
            % SetupConstants file.
            if(exist('SetupConstants.m','file')==2)
                try
                    Constants=SetupConstants();
                catch err
                    extraCause=MException('TUe:TUe:ErrorInSetupConstants',...
                        ['Error during execution of SetupConstants()!!! This function must\n',...
                        'return a single structure.']);
                    NewObj=addCause(extraCause,err);
                    throw(NewObj);
                end
            else
                error(['For the TUe.Constants class to function you must specify a SetupConstants.m \n',...
                       'function on the matlab search path. This function must return a single struct.']);
            end

        end %function Constants = GetConstants();    

        function obj=GetClassInstance(Reset)
            % This is the key method that makes the singleton class
            % possible. It stores the only object that can exist in a
            % persistant variable. 
            persistent localObj;
            % Check if it is the first time, this method is called or if it
            % is called using the "Reset" parameter.
            if(isempty(localObj) || ~isvalid(localObj) || strcmp(Reset,'Reset'))
                % If so, create one instance of the TUe object and store it
                % in the persistant localObj:
                localObj = TUe();
            end
            % Since matlab does not alow output arguments to be persistant,
            % we need to copy (only the handle) here:
            obj=localObj;
        end
        
        function c = MergeStruct(a,b)
            % Override fields existing in a with values of b, return error
            % if a field of b does not exist in a.
            c = a;
            bfn = fieldnames(b);
            for ii = 1:length(bfn),
                if ~isfield(a, bfn{ii}),
                    error(['Trying to override unexisting structure field ''%s''\n',...
                           'All fields specified in the UserConstants must exist in SetupConstants!!'], bfn{ii});
                end
                if isstruct(b.(bfn{ii})),
                    % recursive loop for sublevel structs
                    c.(bfn{ii}) = TUe.MergeStruct(a.(bfn{ii}), b.(bfn{ii}));
                else
                    c.(bfn{ii}) = b.(bfn{ii});
                end
            end
        end
        
    end % methods (Static,Access=private, Hidden)
    
end