`include "ALU.v"
module ALUtb;
	reg [31:0]a;			
	reg [31:0]b;
	
	wire [31:0]c1;			//Output of Add
	wire [31:0]c2;			//Output of Mul
	wire [31:0]c3;			//Output of Div
	
	integer fo, i;
	
	reg [63:0]fi [0:1000];
	
	Add add(a, b, c1);
	Mul mul(a, b, c2);
	Div div(a, b, c3);
	
	initial begin
		
		$dumpfile("ALUtb.vcd");
		$dumpvars;
		
		fo = $fopen("Output.txt", "w");
		$readmemb("Inputs.mem", fi);
		for(i=1; i<=fi[0][61:0]; i = i + 1) begin
			a = fi[i][63:32];
			b = fi[i][31:0];
			#1
			$fdisplay(fo,"%b%b%b", c1, c2, c3);	//Giving back to Python in cascaded formate
		end
		$fclose(fo);
		$finish;
	end	
endmodule
