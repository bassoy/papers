disp("")
implementation="combined"
blas="mkl"
format="rm"

lower_whisker(1) = 0.222311; lower_quartile(1) = 1.062817; median(1) = 2.095423; upper_quartile(1) = 2.445500; upper_whisker(1) = 6.630949;
lower_whisker(2) = 0.245183; lower_quartile(2) = 1.163115; median(2) = 2.066062; upper_quartile(2) = 2.514304; upper_whisker(2) = 4.921195;
lower_whisker(3) = 0.235031; lower_quartile(3) = 1.195775; median(3) = 2.095329; upper_quartile(3) = 2.645421; upper_whisker(3) = 6.517069;
lower_whisker(4) = 0.223277; lower_quartile(4) = 1.025390; median(4) = 2.138559; upper_quartile(4) = 2.454309; upper_whisker(4) = 4.802512;
lower_whisker(5) = 0.224844; lower_quartile(5) = 1.051605; median(5) = 2.117759; upper_quartile(5) = 2.482665; upper_whisker(5) = 4.752532;
lower_whisker(6) = 0.215008; lower_quartile(6) = 1.179416; median(6) = 2.117941; upper_quartile(6) = 2.470308; upper_whisker(6) = 6.787822;
lower_whisker(7) = 0.215662; lower_quartile(7) = 1.080059; median(7) = 1.980501; upper_quartile(7) = 2.410754; upper_whisker(7) = 6.431995;

lower_whisker_rsd   = 100* ( std(lower_whisker) /mean(lower_whisker) )
lower_quartile_rsd  = 100* ( std(lower_quartile)/mean(lower_quartile) )
upper_quartile_rsd  = 100* ( std(upper_quartile)/mean(upper_quartile) )
upper_whisker_rsd   = 100* ( std(upper_whisker) /mean(upper_whisker) )
median_rsd          = 100* ( std(median)        /mean(median) )
inter_quartile_range_rsd  = 100* ( std(upper_quartile-lower_quartile)/mean(upper_quartile-lower_quartile) )

disp("")
disp("")

implementation="combined"
blas="mkl"
format="cm"

lower_whisker(1) = 0.211438; lower_quartile(1) = 1.157492; median(1) = 2.169335; upper_quartile(1) = 2.574061; upper_whisker(1) = 7.382679;
lower_whisker(2) = 0.253487; lower_quartile(2) = 1.339416; median(2) = 2.200520; upper_quartile(2) = 2.714294; upper_whisker(2) = 6.801558;
lower_whisker(3) = 0.247239; lower_quartile(3) = 1.307572; median(3) = 2.178256; upper_quartile(3) = 2.450358; upper_whisker(3) = 7.147759;
lower_whisker(4) = 0.250218; lower_quartile(4) = 1.196322; median(4) = 2.155946; upper_quartile(4) = 2.466837; upper_whisker(4) = 6.800138;
lower_whisker(5) = 0.253739; lower_quartile(5) = 1.305761; median(5) = 2.197693; upper_quartile(5) = 2.575710; upper_whisker(5) = 7.810185;
lower_whisker(6) = 0.208201; lower_quartile(6) = 1.166692; median(6) = 2.179619; upper_quartile(6) = 2.514617; upper_whisker(6) = 7.605348;
lower_whisker(7) = 0.173366; lower_quartile(7) = 1.161815; median(7) = 2.193905; upper_quartile(7) = 2.501870; upper_whisker(7) = 7.191211;

lower_whisker_rsd   = 100* ( std(lower_whisker) /mean(lower_whisker) )
lower_quartile_rsd  = 100* ( std(lower_quartile)/mean(lower_quartile) )
upper_quartile_rsd  = 100* ( std(upper_quartile)/mean(upper_quartile) )
upper_whisker_rsd   = 100* ( std(upper_whisker) /mean(upper_whisker) )
median_rsd          = 100* ( std(median)        /mean(median) )
inter_quartile_range_rsd  = 100* ( std(upper_quartile-lower_quartile)/mean(upper_quartile-lower_quartile) )





disp("")
implementation="combined"
blas="aocl"
format="rm"

lower_whisker(1) = 0.017638; lower_quartile(1) = 0.197808; median(1) = 0.700823; upper_quartile(1) = 1.558298; upper_whisker(1) = 5.750793;
lower_whisker(2) = 0.017728; lower_quartile(2) = 0.202116; median(2) = 0.531791; upper_quartile(2) = 1.428076; upper_whisker(2) = 1.791317;
lower_whisker(3) = 0.017811; lower_quartile(3) = 0.328616; median(3) = 0.934536; upper_quartile(3) = 1.546815; upper_whisker(3) = 6.273393;
lower_whisker(4) = 0.017738; lower_quartile(4) = 0.204019; median(4) = 0.522302; upper_quartile(4) = 1.348515; upper_whisker(4) = 1.775661;
lower_whisker(5) = 0.017756; lower_quartile(5) = 0.202238; median(5) = 0.700340; upper_quartile(5) = 1.600296; upper_whisker(5) = 7.185700;
lower_whisker(6) = 0.017760; lower_quartile(6) = 0.200640; median(6) = 0.531063; upper_quartile(6) = 1.402741; upper_whisker(6) = 1.822836;
lower_whisker(7) = 0.017724; lower_quartile(7) = 0.201667; median(7) = 0.481415; upper_quartile(7) = 1.203351; upper_whisker(7) = 1.901511;

lower_whisker_rsd   = 100* ( std(lower_whisker) /mean(lower_whisker) )
lower_quartile_rsd  = 100* ( std(lower_quartile)/mean(lower_quartile) )
upper_quartile_rsd  = 100* ( std(upper_quartile)/mean(upper_quartile) )
upper_whisker_rsd   = 100* ( std(upper_whisker) /mean(upper_whisker) )
median_rsd          = 100* ( std(median)        /mean(median) )
inter_quartile_range_rsd  = 100* ( std(upper_quartile-lower_quartile)/mean(upper_quartile-lower_quartile) )

disp("")
disp("")

implementation="combined"
blas="aocl"
format="cm"

lower_whisker(1) = 0.056610; lower_quartile(1) = 0.355304; median(1) = 1.604772; upper_quartile(1) = 1.854768; upper_whisker(1) = 9.564341;
lower_whisker(2) = 0.053224; lower_quartile(2) = 0.204302; median(2) = 1.015842; upper_quartile(2) = 1.644501; upper_whisker(2) = 2.116184;
lower_whisker(3) = 0.053392; lower_quartile(3) = 0.230051; median(3) = 1.581577; upper_quartile(3) = 1.795145; upper_whisker(3) = 8.407662;
lower_whisker(4) = 0.057285; lower_quartile(4) = 0.203801; median(4) = 0.947029; upper_quartile(4) = 1.617604; upper_whisker(4) = 2.294445;
lower_whisker(5) = 0.054296; lower_quartile(5) = 0.271849; median(5) = 1.586519; upper_quartile(5) = 1.791003; upper_whisker(5) = 9.359328;
lower_whisker(6) = 0.057361; lower_quartile(6) = 0.230950; median(6) = 1.492804; upper_quartile(6) = 1.717333; upper_whisker(6) = 5.833667;
lower_whisker(7) = 0.052985; lower_quartile(7) = 0.229488; median(7) = 1.577828; upper_quartile(7) = 1.827169; upper_whisker(7) = 9.032054;

lower_whisker_rsd   = 100* ( std(lower_whisker) /mean(lower_whisker) )
lower_quartile_rsd  = 100* ( std(lower_quartile)/mean(lower_quartile) )
upper_quartile_rsd  = 100* ( std(upper_quartile)/mean(upper_quartile) )
upper_whisker_rsd   = 100* ( std(upper_whisker) /mean(upper_whisker) )
median_rsd          = 100* ( std(median)        /mean(median) )
inter_quartile_range_rsd  = 100* ( std(upper_quartile-lower_quartile)/mean(upper_quartile-lower_quartile) )
