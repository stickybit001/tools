# Simple tool to removing duplicate domains after recon.
with open('domains_.txt', 'r') as f:
	domains = [x.strip() for x in f.read().split('\n')]

domains_ = list(set(domains))

with open('domains.txt', 'w') as f:
	for x in domains_:
		f.write(x+'\n')
