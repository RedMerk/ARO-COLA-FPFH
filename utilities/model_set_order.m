function model = model_set_order(model_input,H)
	% model_set_order Apply an isometric transformation H (Rotation and translation) 
	% into the Model set. 
	%
	% Inputs: model_input - Matrix with dimesions 3-N
	%         H - Isometric Transformation in Shape [R,t;O(1x3),1].
	%
	% Output: model - Transformed Model based on transformation H.

	Yh = [model_input ; ones(1,size(model_input,2))];
	Xh = H*Yh;
	model = Xh(1:3,:);
end
