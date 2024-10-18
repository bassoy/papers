function ratio_new = compute_ratio(nom, denom)
  ratio  = nom  ./ denom;
  less_than_one = ratio<1;
  greater_than_one = ratio>1;
  ratio_new = zeros(size(ratio));
  ratio_new(less_than_one) = (1./ratio(less_than_one));
  ratio_new(greater_than_one) = -ratio(greater_than_one);
end
