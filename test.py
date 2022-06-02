f = open("filter.txt", "r")
output = open("afterfilter.txt", "a")
for line in f:
    arr = line.replace("0AH", "0xA")
    output.write(arr)

