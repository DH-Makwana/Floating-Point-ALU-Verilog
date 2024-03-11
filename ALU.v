module Mul(x, y, o);
	input [31:0] x;
	input [31:0] y;
	output reg [31:0] o;
	
	reg [9:0]eo;	
	reg [48:0] mo;
	
	always @ (x, y) begin
		
		eo = x[30:23] + y[30:23];		//Exponant
		mo = {1'b1, x[22:0]}*{1'b1, y[22:0]};
		
		o[31] = x[31] ^ y[31];			//Sign Bit
		
		//$display("%b", mo);
		
		if(mo[47]) begin			//If : ans is (11.XX) => (1.1XX)
			o[22:0] = mo[46 -: 23];
			o[30:23] = eo - 9'd126;
		end else begin				//Else : ans is (01.XX)
			o[22:0] = mo[45 -: 23];
			o[30:23] = eo - 8'd127;
		end
		if(x==0 | y==0) o = 32'b0;
	end
endmodule


module Div(x, y, o);
	input [31:0] x;
	input [31:0] y;
	output reg [31:0] o;
	
	reg [7:0]eo;
	reg [47:0]mx;
	reg [23:0]my;
	reg [47:0]mo;
	
	reg [47:0]tmpM;
	integer i;
	
	always @(x, y) begin
		if(x == 32'b0) o = 32'b0;			//Checking for the x/y == 0
		
		else begin					//If not hen procced
			eo = x[30:23] - y[30:23] + 8'd127;	//Subtracting the exponants
			
			mx = {1'b1, x[22:0], 24'b0};		//Padding 0s at the end of X
			my = {1'b1, y[22:0]};		
					
			if (y[22:0] != 0) begin			//Checking for Y=1
				tmpM = 48'b0;
				for(i=47; i>=0; i=i-1) begin	//Division of Mantisa
					if(tmpM < my) begin
						mo[i] = 1'b0;
					end else begin
						mo[i] = 1'b1;
						tmpM = tmpM-my;
					end
					tmpM = {tmpM, mx[i]};
				end
			end else mo = mx;
			if(y == 32'b0) eo = 8'b11111111;	//Here the infinity = +/- 2^128
			if(~mo[23]) begin			//CHecking for the 0.1XXXXX ans
				mo = mo << 1'b1;
				eo = eo - 1'b1;
			end
			o = {x[31]^y[31], eo, mo[22:0]};	
		end
	end	
endmodule


module Add(x, y, o);
	input [31:0] x;
	input [31:0] y;
	output reg [31:0] o;
	
	reg [9:0]eo;	
	reg [25:0] mo;
	reg [24:0] mx;
	reg [24:0] my;
	
	integer df, i, j;
	
	function [59:0] setExponant;				//Fuction to set the mantisa to right place
		input [31:0] x;
		input [31:0] y;
		begin
			df = x[30:23] - y[30:23];
			//$display("%d", df);
			eo = x[30:23];
			mx = {2'b01, x[22:0]};
			my = {2'b01, y[22:0]};
			for(i=0; i<25; i = i + 1) begin		//Shift the lower exponant to higher
				if(i+df < 24)
					my[i] = my[i+df];
				else
					my[i] = 1'b0;
			end
			setExponant = {eo, mx, my};
		end
	endfunction
	
	always @(x, y) begin
		if(x[30:23] > y[30:23]) begin			//Which one has bigger exponant
			{eo, mx, my} = setExponant(x, y);
		end else begin
			{eo, my, mx} = setExponant(y, x);
		end
		
		if(~(x[31] ^ y[31])) begin			//If (+a, +b) or (-a, -b)
			mo = mx + my;
			o[31] = (x[31])?1'b1:1'b0;
			if (~mo[23] | mo[24]) begin		//for (11.XXX) => (1.1XX * 2)
				eo = eo + 1;
				mo = mo >> 1'b1;
			end
		end else begin					//If (+a, -b) or (-a, +b)
		if((mx != my) | (x[30:23] != y[30:23])) begin	//If : is |a| != |b|
			
			mo = x[31] ? (my - mx) : (mx - my);
			o[31] = mo[25];
			mo = mo[25]? (~mo + 1'b1) : mo;		//If ans is -ve
			
//			if (mo[25] & ~mo[23]) begin		//If : is (1X0.XXX) => (1X.0XX * 2)
//				eo = eo + 1;
//				mo = mo >> 1'b1;
//			end else begin				//Else : not 1X0.XXX
				for(i=0; i<23; i=i+1) begin
				if (~mo[23]) begin			//for (0.00..01XX) => (1.XXX)*2^n
					eo = eo - 1;
					mo = mo << 1'b1;
				end else mo = mo;
				end
				if (mo[24] & mo[23]) begin	//for (11.XX) => (1.1XX)
					eo = eo + 1;
					mo = mo >> 1'b1;
				end
//			end
		end else begin					//Else : not |a| != |b|
			eo = 0;
			mo = 0;
			o[31] = 0;
		end			
		end
		o = {o[31], eo[7:0], mo[22:0]};
				
	end
	
endmodule
