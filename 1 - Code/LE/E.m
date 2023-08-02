function [E] = E(x)
cos = fresnelc(x);
sen = fresnels(x);
E = cos - 1i*sen;
end

