import json

fileName = "res/verbs"

f = open(fileName + ".txt", "rt")
words = f.readlines()
f.close()

jsonWords = []
for i in range(len(words)):
    word = words[i]
    if word == "":
        continue

    parts = word.split("|")
    for j in range(len(parts)):
        parts[j] = parts[j].strip()

    jsonWords.append({"word": parts[0], "translation": parts[1]})

    # nouns
    # Praise|Das Lob|Das Lob
    # article = parts[1][:3]
    # jsonWords.append(
    #     {"article": article, "word": parts[1][4:], "plural": parts[2], "translation": parts[0]})

f = open(fileName + "_json.txt", "wt")
f.writelines(json.dumps(jsonWords))
f.close()
