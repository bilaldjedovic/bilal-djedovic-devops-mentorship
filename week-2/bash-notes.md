# Komande korištene za kompleitranje TASK-2

## Kreiranje novog brancha

###### Korištena komanda:

`git checkout -b week-2-bandit-labs`

## Kreiranje novog direktorija `week-2` i kreiranje novog fajla `bash-notes.md` u direktoriju `week-2`

###### Komande korištene:

```
mkdir week-2
cd week-2
touch bash-notes.md

```

## Level 0

###### Komande korištene za prolazak levela 0:

`$ ssh bandit0@bandit.labs.overthewire.org -p 2220` - ovu komandu koristimo da bi se konektovali na server **_bandit.labs.ovethewire.org_** sa imenom usera **_bandit0_** na portu **_2220_**, **_-p_** specificira broj porta

```
$ ls -la - izlistava nam informacije o fajlovima
$ ls - izlistava nam kontent koji se nalazi u direktoriju
$ file - definise nam vrstu fajla
$ cd - komandom cd mijenjamo radni direktorij
$ cat - ispisujemo sadrzaj fajla
$ du - procjenjuje koliko prostora koriste datoteke
$ find - pretrazuje datoteku u hierarhiji direktorija
$ exit - za izlazak sa servera

```

## Level 1

###### Komande korištene za prolazak levela 1:

Nakon konektovanja na server komande koje su korištene za prolazak levela su:

```
$ ssh bandit1@bandit.labs.overthewire.org -p 2220
$ ls - izlistava nam kontent koji se nalazi u direktoriju
$ ls -la - izlistava nam informacije o fajlovima
$ cat ./- - komanda korištena kako bi pročitali fajl naziva "-"
```

## Level 2

###### Komande korištene za prolazak levela 2:

```
$ ssh bandit2@bandit.labs.overthewire.org -p 2220
$ ls -la - izlistava nam informacije o fajlovima
$ find "spaces in this filename" - pronalazk fajla "spaces in this filename"
$ cat "spaces in this filename" - čitanje iz fajla "spaces in this filename"
```

## Level 3

###### Komande korištene za prolazak levela 3:

```
$ ssh bandit3@bandit.labs.overthewire.org -p 2220
$ ls -la - izlistava nam informacije o fajlovima
$ cd inhere - prelazak na direktorij inhere
$ cat .hidden - citanje iz fajla .hidden
```

## Level 4

###### Komande korištene za prolazak levela 4:

```
$ ssh bandit4@bandit.labs.overthewire.org -p 2220
$ ls -la - izlistava nam informacije o fajlovima
$ cd inhere - prelazak na direktorij inhere
$ file ./* - pretrazujemo sve fajlove kako bi pronasli fajl koji mozemo procitati ASCII text
$ cat ./-file07 - citanje iz fajla -file07
```

## Level 5

###### Komande korištene za prolazak levela 5:

```
$ ssh bandit5@bandit.labs.overthewire.org -p 2220
$ ls -la - izlistava nam informacije o fajlovima
$ cd inhere - prelazak na direktorij inhere
$ find . -type f -readable -size 1033c ! -executable - trazimo fajl sa predefinisanim karakteristikama
$ cd maybehere07 - prelazimo u direktorij maybehere07 gdje se nalazi nas fajl
$ cat .file2 - citanje iz fajla .file2
```

## Level 6

###### Komande korištene za prolazak levela 6:

```
$ ssh bandit6@bandit.labs.overthewire.org -p 2220
$ find / -user bandit7 -group bandit6 -siye 33c -type f 2>/dev/null - trazimo fajl sa predefinisanim karakteristikama
$ cat /var/lib/dpkg/info/bandit7.password - nakon komande find dobijamo path do passworda za sljedeci level te iz tog patha citamo
```

## Level 7

###### Komande korištene za prolazak levela 7:

```
$ ssh bandit7@bandit.labs.overthewire.org -p 2220
$ grep "millionth" data.txt - pronalazimo rijec millionth pored koje se nalazi password
```

## Level 8

###### Komande korištene za prolazak levela 8:

```
$ ssh bandit8@bandit.labs.overthewire.org -p 2220
$ ls -la - ispis fajlova
$ sort data.txt | uniq -u - trazimo unutar data.txt liniju koja se ponavljuje jednom
```

## Level 9

###### Komande korištene za prolazak levela 9:

```
$ ssh bandit9@bandit.labs.overthewire.org -p 2220
$ ls -la - ispis fajlova
$ strings data.txt | grep "=" - ovom komandom citamo datoteku data.txt, komandom strings izdvajamo stringove koje mozemo procitati a komandom grep izdvajamo linije koje sadrze znak "="
```

## Level 10

###### Komande korištene za prolazak levela 10:

```
$ ssh bandit10@bandit.labs.overthewire.org -p 2220
$ ls -la - ispis fajlova
$ base64 -d data.txt - ovu komandu koristimo da dekodiramo base64 enkodiranu datoteku
```
