f = open("adjectives.txt", "rt")
words = f.readlines()
f.close()
for i in range(len(words)):
    word = words[i]
    if word == "":
        continue

    word = word.split("\t")
    word = "|".join(word)
    words[i] = word

f = open("adjectives2.txt", "wt")
f.writelines(words)
f.close()
