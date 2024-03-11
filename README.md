# Floating-Point-ALU-Verilog
Here, I have showcased how we can use a python environment to control our Verilog modules and testbenches. The idea is to generate the encoded data here and let it be processed in the same form without worrying about the input and output encoding/decoding.
## Here's how the data flows in the whole environment:

<img src="https://github.com/DH-Makwana/Floating-Point-ALU-Verilog/assets/107695582/76f92868-e650-4fb6-81a2-ac17c47c1447" width="350">

## Files:

**test.py :** It evokes all the other files using Python's **os** library and [**Iverilog**'](https://github.com/steveicarus/iverilog) as a simulator for Verilog files.

**tb.v :** It's the main testbench for the ALU, and selects the operation out of the three(ADD, MUL, DIV) in the ALU.v.

**ALU.v :** The DUT element of the whole environment.

**BinaryFun.py :** The encoding function for Python to generate the test cases.

**CodeCoverage_report.log :** using [Covered](https://github.com/chiphackers/covered)shows the usage of each conditional operators in the **ALU.v file**.

## Errors:


<img src="https://github.com/DH-Makwana/Floating-Point-ALU-Verilog/assets/107695582/bf877f34-0a20-4b07-a4f4-8864bd9244c8">
