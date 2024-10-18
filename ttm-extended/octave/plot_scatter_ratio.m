function plot_scatter_ratio(modes, x, y, cmap, ratio, figure_name)
  figure('Name',figure_name);
  for i = modes
    subplot(2, 5, i);
    r = ratio(:,:,i)';
    absr = abs(r(:));
    relr = 100 * absr./max(absr);
    scatter(y,x,100,r(:),'filled');
    ylabel('Tensor Order');
    xlabel('Tensor Size');
    title(['Contraction mode q=', num2str(i)]);
    colormap(cmap);
    caxis([-10 10]);
    ylim([x(1)-1 x(end)+1]);
    yticks((x(1)-1):x(end));
    yticklabels(num2cell(yticks));
    hcb = colorbar;
    title(hcb, '[%]');

  end
end
