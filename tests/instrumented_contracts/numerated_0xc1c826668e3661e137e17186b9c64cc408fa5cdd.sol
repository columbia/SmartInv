1 pragma solidity ^0.4.4;
2 
3 contract TimeBasedContract
4 {
5     function TimeBasedContract() public {
6     }
7 
8     function() public payable {
9         uint minutesTime = (now / 60) % 60;
10         require(((minutesTime/10)*10) == minutesTime);
11     }
12 }