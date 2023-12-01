digit_to_letter=["one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
                 "1", "2", "3", "4", "5", "6", "7", "8", "9"]

sum = 0
with open("input") as f:
    for line in f:
        firstIdx=1000
        firstVal=0
        lastIdx=-1
        lastVal=0
        for i in range(0, len(digit_to_letter)):
            try:
                idx = line.index(digit_to_letter[i])
            except:
                continue
            if idx < firstIdx:
                firstIdx = idx
                if i < 9:
                    firstVal = i + 1
                else:
                    firstVal = eval(digit_to_letter[i])

        for i in range(0, len(digit_to_letter)):
            try:
                idx = line.rindex(digit_to_letter[i])
            except:
                continue
            if idx > lastIdx:
                lastIdx = idx
                if i < 9:
                    lastVal = i + 1
                else:
                    lastVal = eval(digit_to_letter[i])
        sum += firstVal * 10 + lastVal
print(sum)
