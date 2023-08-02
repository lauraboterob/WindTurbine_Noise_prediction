function [val_interp_final] = interp_values_AL(val1,val2,R1,R2,Ra)
a_int = [val1 val2];
b_int = [R1  R2];
val_interp = polyfit(b_int,a_int,1);
val_interp_final = val_interp(1)*Ra + val_interp(2);  
end

