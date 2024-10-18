function plot_scatter_gflops(modes, x, y, cmap, gflops, figure_name)
  figure('Name',figure_name);
  for i = modes
    subplot(2, 5, i);
    g = gflops(:,:,i)';
    scatter(y(:), x(:),50, g(:),'filled');
    ylabel('Tensor Order');
    xlabel('Tensor Size');
    title(['C.mode q=', num2str(i)]);
    colormap(cmap);
    caxis([0, 50]);
    hcb = colorbar;
    title(hcb, 'Gflops');
  end
end
