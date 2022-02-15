import string

valid = string.punctuation + string.digits
blacklist = '' # fuzz

def xor(a, b):
	return chr(ord(a) ^ ord(b))

payload = "system" # payload convert to XOR

flag = 0
one = ''
two = ''

for p in payload:
	for a in valid:
		for b in valid:
			if xor(a, b) == p:
				one += a; two += b
				flag = 1
				break
		if flag:
			flag = 0
			break

print(f"('{one}'^'{two}')")
