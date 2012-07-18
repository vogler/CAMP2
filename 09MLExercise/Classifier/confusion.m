function [ precision, recall, fmeasure ] = confusion( p, y, positiveLabel )
    p = p==positiveLabel;
    y = y==positiveLabel;
    tp = sum( p &  y);
%     tn = sum(~p & ~y);
    fp = sum( p & ~y);
    fn = sum(~p &  y);
    
    precision = tp/(tp+fp);
    recall    = tp/(tp+fn);
    fmeasure  = 2 * precision * recall / (precision + recall);
end