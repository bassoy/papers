function [ss, iqrd] = getStatistics(d, prctile_bottom, prctile_top)
  prctile_top = 100 - prctile_top; 
	d_prct2 = prctile(d, prctile_bottom);
	d_prct98 = prctile(d, prctile_top);
	d = d(d >= d_prct2);
	d = d(d <  d_prct98);
	ss = statistics (sort(d));
	iqrd = iqr(d);
end
