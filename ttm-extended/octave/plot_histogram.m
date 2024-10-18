function plot_histogram(modes, ratio, figure_name)
  figure('Name',figure_name);
  for i = modes
    subplot(2, 5, i);
    r = ratio(:,:,i);
    hist(r(:),20);
    xlabel('Ratio');
    ylabel('Occurences');
    title(['Contraction mode q=', num2str(i)]);
  end
end
