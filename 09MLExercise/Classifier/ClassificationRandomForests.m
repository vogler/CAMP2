% AUTHOR: Olivier Pauly
% EMAIL: pauly@cs.tum.edu

classdef ClassificationRandomForests
    
    %% CLASS PROPERTIES
    properties
       
        TreeNb = 100;   % number of trees in forests
        TreeDepth = 5;  % number of levels in each tree structure
        InputDim        % Input dimensionality
        NbClasses       % Output dimensionality
        Bootstrap = 1   % percentage of datapoints selected from each class for each bootstrap
        Ntry = 10;      % nb of tries during optimization
        Trees           % All the ferns are stored inside
        Labels
        
        
    end
    
    %% CLASS METHODS
    methods
        
        % constructor
        function obj = ClassificationRandomForests(input_dim, nbClasses, treeNb, treeDepth, nTry)
            
            % first check attribute
			if(nargin==0)
				return % return emtpy object
			end
            if(nargin==1)
               error('Constructor error: you need to give at least the number of class and the dimensionality');
            end
            if(nargin==2)
               obj.InputDim = input_dim; 
               obj.NbClasses = nbClasses;
            end
            if(nargin==3)
               obj.InputDim = input_dim; 
               obj.NbClasses = nbClasses;
               obj.TreeNb = treeNb; 
            end
            if(nargin==4)
               obj.InputDim = input_dim; 
               obj.NbClasses = nbClasses;
               obj.TreeNb = treeNb; 
               obj.TreeDepth = treeDepth; 
            end
            if(nargin==5)
               obj.InputDim = input_dim; 
               obj.NbClasses = nbClasses;
               obj.TreeNb = treeNb; 
               obj.TreeDepth = treeDepth;
               obj.Ntry = nTry;
            end
            
            
            
            % create the ensemble structure
            obj.Trees = cell(obj.TreeNb,1);
            
            for i=1:obj.TreeNb
                
                obj.Trees{i,1} = ClassificationRandomTree(obj.InputDim, obj.NbClasses, obj.TreeDepth, obj.Ntry);
                
            end
            
        end
        
        % Regression function
        function obj = performTraining(obj,X,Y)
            
            % determine labels
            obj.Labels = unique(Y);
            
            for i=1:obj.TreeNb    
                % we use the full training set
                obj.Trees{i,1} = performTraining(obj.Trees{i,1},X,Y);
            end
            
        end
        

        % Prediction function
        function Y = computePredictions(obj,X)
            
            Y = zeros(size(X,1),obj.NbClasses,'single');
                
            for i = 1:obj.TreeNb
                    
%                 [pred,p] = computePredictions(obj.Trees{i,1},X);
                [pred,p] = computeFastPredictions(obj.Trees{i,1},X);  % WORKS ONLY WITH 64 BITS
                    
                % combine predictions
                Y = Y + (1/obj.TreeNb).*pred;
            
                    
            end
                        
        end
        
        function saveobj(obj, str)
		
			% first create saving directory
			mkdir(str);
			
			% then go into the directory
			
			cd(str)
			
			% save forest attributes
			TreeNb = obj.TreeNb;
			TreeDepth = obj.TreeDepth; 
			InputDim = obj.InputDim;
			NbClasses = obj.NbClasses;
			Ntry = obj.Ntry;
			
			save('RF.mat', 'TreeNb', 'TreeDepth', 'InputDim', 'NbClasses', 'Ntry');
			
			% then save all trees
			for i=1:TreeNb
			
				saveobj(obj.Trees{i,1},num2str(i));
			
			end
			
			% go back
			cd ..
		
		end
		
		function obj = loadobj(obj,str)
		
			% need as input an empty object
		
			if(nargin==2)
				cd(str)
			end
			
			% first look for the RF.mat file and load forest attributes
			load('RF.mat')
			obj = ClassificationRandomForests(InputDim, NbClasses, TreeNb, TreeDepth, Ntry);
			
			% then load the trees
			for i=1:TreeNb
                tree = ClassificationRandomTree();
				obj.Trees{i,1} = loadobj(tree, num2str(i));
			end
			
			if(nargin==2)
				cd ..
			end
		
		end
        
    end
    
end