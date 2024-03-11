# This file contains the functions for the testing the 32bit binary as per IEEE-754 standard
def RealToBits32(x):
    ans = "0"*32
    if x == 0:
        ans = "0"*32
    else:
        if x >= 0:
            ans = "0" + ans[1:]
        else:
            ans = "1" + ans[1:]
            x = -x

        E = 0
        while x >= 2:
            x = x/2
            E += 1
        while x < 1:
            E -= 1
            x = x*2

        E += 127
        ans = ans[0] + f"{E:08b}" + ans[9:]

        M = 0
        if x >= 1:
            x -= 1
        for i in range(0, 23):
            if (x-(2**(-i))) >= 0:
                #print(x)
                M += 2**(23-i)
                x -= 2**(-i)

        ans = ans[:9] + f"{M:023b}"
    return ans

def Bits32ToReal(x):
	#print(x)
	ans = 1.0
	e = 0
	if(x == "0"*32):
		ans = 0.0
	else:	
		for i in range(8):
			if x[1+i] == '1':
				e += 2**(7-i)
		m = 0
		for i in range(1, 24):
			if x[8+i] == '1':
				#print(2**(-i))
				m += 2**(-i)	
		ans = (ans+m)*(2**(e-127))
		if x[0] == "1":
			ans *= -1
	return ans
	

