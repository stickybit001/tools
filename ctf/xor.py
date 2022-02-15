import string

blacklist = r'' # i'm here
payload = "system" # payload convert to XOR

valid = string.punctuation + string.digits

if blacklist != '':
	for b in blacklist:
		valid = valid.replace(b, '')

def xor(a, b):
	return chr(ord(a) ^ ord(b))

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
