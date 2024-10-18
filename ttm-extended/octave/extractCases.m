% dataY = order x size x modes
function [d2,d3,d6,d7,d8] = extractCases(dataY)
  % order x size x mode
  d  = squeeze(dataY(:,:,:));
  %size(d)
  d2 = squeeze(d(1    ,:,1    )); % p=2, q=1
  d3 = squeeze(d(1    ,:,2:end)); % p=2, q=2,...,p
  d6 = squeeze(d(2:end,:,1    )); % p>2, q=1
  d7 = [];
  d8 = [];
  for p = 3:(size(d,1)+1) % order
    for q = p:size(d,3) % c.mode
      d7 = [d7;d(p-1,:,q)]; % p>2, q=p
    end
  end
  for p = 3:(size(d,1)+1) % order , p=3,...,7
    for q = 2:(p-1) % c.mode , q=2
      d8 = [d8; d(p-1,:,q)]; % p>2, 1<q<p
    end
  end
end % function extractCases(dataY)
