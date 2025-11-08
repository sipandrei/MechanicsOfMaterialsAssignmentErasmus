data = open('./data.txt','r')
csvData = open('./data.csv','w')
csvData.truncate(0)
line = data.readline()
info = line.split()
if info != []:
    csvData.write(f"{info[0]},{info[1]}\n")
while  line:
  line = data.readline()
  info = line.split()
  if info != []:
    csvData.write(f"{info[0]},{info[1]}\n")


