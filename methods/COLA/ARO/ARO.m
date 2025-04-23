    %%% Artificial Rabbits Optimization (ARO) for 23 functions %%%
function out = ARO(problem, params)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FunIndex: Index of function.                       %
    % MaxIt: Maximum number of iterations.               %
    % PopSize: Size of population.                       %
    % PopPos: Position of rabbit population.             %
    % PopFit: Fitness of population.                     %
    % Dim: Dimensionality of prloblem.                   %
    % BestX: Best solution found so far.                 %
    % BestF: Best fitness corresponding to BestX.        %
    % HisBestF: History best fitness over iterations.    %
    % Low: Low bound of search space.                    %
    % Up: Up bound of search space.                      %
    % R: Running operator.                               %
    % L:Running length.                                  %
    % A: Energy factor.                                  %
    % H: Hiding parameter.                               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %% Problem Definiton

    CostFunction = problem.CostFunction;  % Cost Function
    nVar = problem.nVar;        % Number of Unknown (Decision) Variables
    VarSize = [1 nVar];         % Matrix Size of Decision Variables
    VarMin = problem.VarMin;	% Lower Bound of Decision Variables
    VarMax = problem.VarMax;    % Upper Bound of Decision Variables

    %% ARO Parameters
    MaxIt = params.MaxIt;   % Maximum Number of Iterations
    nPop = params.nPop;     % Population Size

    Dim = nVar;
    PopPos=zeros(nPop,nVar);
    PopFit=zeros(nPop,1);

    for i=1:nPop
        if isfield(problem,'pos_init')
            if i <= nPop/2
                PopPos(i,:)=problem.pos_init;
            else
                PopPos(i,:)=unifrnd(VarMin, VarMax, VarSize);
            end
        else
            PopPos(i,:)=unifrnd(VarMin, VarMax, VarSize);
        end
        PopFit(i)=CostFunction(PopPos(i,:));
    end

    BestF=inf;
    BestX=[];

    for i=1:nPop
        if PopFit(i)<=BestF
            BestF=PopFit(i);
            BestX=PopPos(i,:);
        end
    end

    HisBestF=zeros(MaxIt,1);

    for It=1:MaxIt
        t2 = tic;
        
        Direct1=zeros(nPop,Dim);
        Direct2=zeros(nPop,Dim);
        theta=2*(1-It/MaxIt);
        for i=1:nPop
            L=(exp(1)-exp(((It-1)/MaxIt)^2))*(sin(2*pi*rand)); %Eq.(3)
            rd=ceil(rand*(Dim));
            Direct1(i,randperm(Dim,rd))=1;
            c=Direct1(i,:); %Eq.(4)
            R=L.*c; %Eq.(2)
            
            
            A=2*log(1/rand)*theta;%Eq.(15)

            if A>1

                K=[1:i-1 i+1:nPop];
                RandInd=K(randi([1 nPop-1]));
                newPopPos=PopPos(RandInd,:)+R.*( PopPos(i,:)-PopPos(RandInd,:))...
                    +round(0.5*(0.05+rand))*randn; %Eq.(1)
            else

                Direct2(i,ceil(rand*Dim))=1;
                gr=Direct2(i,:); %Eq.(12)
                H=((MaxIt-It+1)/MaxIt)*randn; %Eq.(8)
                b=PopPos(i,:)+H*gr.*PopPos(i,:); %Eq.(13)
                newPopPos=PopPos(i,:)+ R.*(rand*b-PopPos(i,:)); %Eq.(11)

            end
            newPopPos=SpaceBound(newPopPos,VarMax,VarMin);
            newPopFit=CostFunction(newPopPos);
            if newPopFit<PopFit(i)
                PopFit(i)=newPopFit;
                PopPos(i,:)=newPopPos;
            end

        end

        for i=1:nPop
            if PopFit(i)<BestF
                BestF=PopFit(i);
                BestX=PopPos(i,:);
            end
        end

        HisBestF(It)=BestF;
        
        time2 = toc(t2);
        disp(['Iteration ' num2str(It) ': Iteration time = ' num2str(time2)]);

    end

    out.pop = PopPos;
    out.BestSol = BestX;
    out.BestCost = BestF;

end

