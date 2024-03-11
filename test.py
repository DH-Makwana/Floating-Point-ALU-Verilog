from BinaryFun import *
from matplotlib import pyplot as plt
import numpy as np
import os

l = 100							#Number of test cases
a = 2*np.sin(4*np.pi*np.arange(l)/l)			#input-1
b = 2*np.cos(4*np.pi*np.arange(l)/l)			#input-2

#a[int(l/3)] = 0.0
#b[int(l/2)] = 0.0

a[l-1] = 0.0
b[l-1] = 1.0


#Writing the input file
fi = open("Inputs.mem", "w")		
fi.write(f"{l:064b}\n")					#First line is the number of inputs
for i in range(l):
	fi.write(RealToBits32(a[i]) + RealToBits32(b[i]) + "\n")	#Writting the inputs to mem in formate of {a(32bit), b(32bit)}
fi.close()

#Executing the Testbench
os.system("iverilog ALUtb.v")
os.system("vvp a.out")
os.system("rm a.out")

"""
#To get the Report of CodeCoverage reports comment "include", "fopen", "fdisplay" in the test-bench
#And then run
$covered score -t ALUtb -v ALUtb.v -v ALU.v -vcd ALUtb.vcd -o ALUtb.cdd
$covered report -d s ALUtb.cdd

"""
#displaing the diffrence in results with the plot if more then 10 cases.

fo = open("Output.txt", "r")
def rnd(x): return round(x, 3)

O_act0 = []
O_act1 = []
O_act2 = []

for i in range(l):
	x = fo.readline()
	O_act0.append(Bits32ToReal(x[0:32]))
	O_act1.append(Bits32ToReal(x[32:64]))
	O_act2.append(Bits32ToReal(x[64:96]))

fo.close()


O_exp0 = a + b
O_exp1 = a * b
O_exp2 = a / b
if l < 10 :
	for i in range(l):
		print(f"{rnd(a[i])} & {rnd(b[i])}")
		print(f"+ : {rnd(O_exp0[i])} = {rnd(O_act0[i])}")
		print(f"* : {rnd(O_exp1[i])} = {rnd(O_act1[i])}")
		print(f"/ : {rnd(O_exp2[i])} = {rnd(O_act2[i])}")

fig = plt.figure();
if l > 10:
	fig.add_subplot(321)
	plt.plot(range(l), (O_exp0-O_act0)/O_exp0)
	plt.legend(["Error(f), {f(x, y) = x + y"])
	plt.grid()
	fig.add_subplot(322)
	plt.plot(range(l), O_exp0, color="green")
	plt.plot(range(l), O_act0, color="black", linestyle=":")
	plt.grid()
	plt.legend(["f(x, y) = x + y"])
	
	fig.add_subplot(323)
	plt.plot(range(l), (O_exp1-O_act1)/O_exp1, color="red")
	plt.grid()
	plt.legend(["Error(f), {f(x, y) = x * y"])
	fig.add_subplot(324)
	plt.plot(range(l), O_exp1, color="red")
	plt.plot(range(l), O_act1, color="black", linestyle=":")
	plt.grid()
	plt.legend(["f(x, y) = x * y"])
	
	fig.add_subplot(325)
	plt.plot(range(l), (O_exp2-O_act2)/O_exp2, color="green")
	plt.grid()
	plt.legend(["Error(f), {f(x, y) = x / y"])
	fig.add_subplot(326)
	plt.plot(range(l), O_exp2, color="green")
	plt.plot(range(l), O_act2, color="black", linestyle=":")
	plt.grid()
	plt.legend(["f(x, y) = x / y"])
	plt.show()
