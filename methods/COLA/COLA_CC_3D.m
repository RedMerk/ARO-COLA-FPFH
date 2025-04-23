function cost = COLA_CC_3D(X,Y,c,p,pos)

    parser = inputParser;
    addRequired(parser,'X');
    addRequired(parser,'Y');
    addRequired(parser,'c');
    addRequired(parser,'p');
    addRequired(parser,'pos');
    
    parse(parser,X,Y,c,p,pos)
    X = parser.Results.X;
    Y = parser.Results.Y;
    c = parser.Results.c;
    p = parser.Results.p;
    pos = parser.Results.pos;

    H = pos_2_H(pos);
    Yt= model_set_order(Y,inv(H));
    cost = ospa_dist(X,Yt,c,p);
end

function dist = ospa_dist(X,Y,c,p)
    %
    %B. Vo.  26/08/2007
    %Compute Schumacher distance between two finite sets X and Y
    %as described in the reference
    %[1] D. Schuhmacher, B.-T. Vo, and B.-N. Vo, "A consistent metric for performance evaluation in multi-object 
    %filtering," IEEE Trans. Signal Processing, Vol. 56, No. 8 Part 1, pp. 3447� 3457, 2008.
    %
    %Inputs: X,Y-   matrices of column vectors
    %        c  -   cut-off parameter (see [1] for details)
    %        p  -   p-parameter for the metric (see [1] for details)
    %Output: scalar distance between X and Y
    %Note: the Euclidean 2-norm is used as the "base" distance on the region
    %

    % if nargout ~=1 & nargout ~=3
    %    error('Incorrect number of outputs'); 
    % end

    if isempty(X) && isempty(Y)
        dist = 0; 
        return;
    end

    if isempty(X) || isempty(Y)
        dist = c;   
        return;
    end
    
    %Calculate sizes of the input point patterns
    n = size(X,2);
    m = size(Y,2);

    dist_vector = sqrt(sum((X-Y).^2,1));
    diagonal = min(dist_vector,c).^p;
    cost = sum(diagonal);


    %Calculate final distance
    dist= ( 1/max(m,n)*( c^p*abs(m-n)+ cost ) ) ^(1/p);
end

