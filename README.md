# GNL-Arena-Tester
For warior who seek power --- come and confront yourself to my GNL and more...
![ARENA](arena.jpg)

## HOW TO USE IT


1. git clone https://github.com/LesChats/GNL-Arena-Tester.git
  - you can clone this repo everywhere, by defaut in your own get_next_line directory...

2. **cd** *GNL-Arena-Tester*

3. \(optional) **vim** *bencher.sh*
  - if you need to change the default render directory (where your **get_next_line.c** is) juste edit **MY_GNL** variable
  
4. \(optional) 
- if you don't whant to compete VS my get_next_line (who's gonna blame ya ?) you cant put an other one in *GNL-Arena-Tester/validated-gnls/abaudot*
- 4.1 \(do somthinf like that)
- ```rm -f *.c GNL-Arena-Tester/validated-gnls/abaudot && rm -f *.h GNL-Arena-Tester/validated-gnls/abaudot```
- ```cp -rf ../my_friend_get_next_line GNL-Arena-Tester/validated-gnls/abaudot```

5. ./bencher.sh [x][y]
  - where x is the BUFFER_SIZE (by default BUFFER_SIZE=42)
  - where y is the number of tests (by default y = 100)
  - be carfull the more y is big the more the bench is precise but it may take a lot of time...

## WHAT YOU GET

-**Pride** or **disnonor** ! 
-It can also help to test your get_next_line implementation because it output the biff bettwen my validated GNL and yours ;) 
- please send me a message or mail if you really beat me ;)
  
