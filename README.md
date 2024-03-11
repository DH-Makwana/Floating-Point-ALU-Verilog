# Floating-Point-ALU-Verilog
Here, I have showcased how we can use a python environment to control our Verilog modules and testbenches. The idea is to generate the encoded data here and let it be processed in the same form without worrying about the input and output encoding/decoding.
### Here's how the data flows in the whole environment:

<img src="https://github.com/DH-Makwana/Floating-Point-ALU-Verilog/assets/107695582/76f92868-e650-4fb6-81a2-ac17c47c1447" width="350">

The main file to be ran is **test.py**, Which evokes all the other files using Python's **os** library and **Iverilog** as a simulator for Verilog files.

The **CodeCoverage_report.log** shows the usage of each conditional operators in the **ALU.v file**.
