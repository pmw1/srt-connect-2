#!/usr/bin/python3

##print ("mess color module running\n")

def printc(color, text):
	if(color=="red"):
		print("\033[1;31;40m" + text + "\033[0;37;40m")
	elif(color=="green"):
		print("\033[1;32;40m" + text + "\033[0;37;40m")
	elif(color=="yellow"):
		print("\033[1;33;40m" + text + "\033[0;37;40m")
	elif(color=="blue"):
		print("\033[1;36;40m" + text + "\033[0;37;40m")




	elif(color=="inversered"):
		print("\033[0;37;41m" + text + "\033[0;37;48m")
	elif(color=="inverseblue"):
		print("\033[0;37;44m" + text + "\033[0;37;48m")
	elif(color=="inversegreen"):
		print("\033[0;37;42m" + text + "\033[0;37;48m")











def labelc(color, label, text):
	if(color=="greenyellow"):
		print ("\033[1;32;40m",label,":\t\t", "\033[1;33;40m", text, "\033[0;37;48m")
	if(color=="yellowred"):
		print ("\033[1;33;40m",label,":\t\t", "\033[1;31;40m", text, "\033[0;37;48m")