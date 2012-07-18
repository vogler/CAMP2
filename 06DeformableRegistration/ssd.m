function sim = ssd(src, trg) 
src = src(:); 
trg = trg(:);
sim = (src - trg).*(src - trg);
sim = sum(sim);
sim = sim / size(src,1);
end
    