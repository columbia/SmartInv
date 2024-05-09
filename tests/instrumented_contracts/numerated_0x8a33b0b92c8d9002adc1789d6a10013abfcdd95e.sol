1 pragma solidity ^0.4.16;
2 
3 contract FuckToken { function giveBlockReward(); }
4 
5 contract OldFuckMaker {
6     // real FuckToken is at 0xc63e7b1DEcE63A77eD7E4Aeef5efb3b05C81438D
7     FuckToken fuck;
8     
9     function OldFuckMaker(FuckToken _fuck) {
10         fuck = _fuck;
11     }
12     
13     // this can make OVER 9,000 OLD FUCKS
14     // (just pass in 129)
15     function makeOldFucks(uint32 number) {
16         uint32 i;
17         for (i = 0; i < number; i++) {
18             fuck.giveBlockReward();
19         }
20     }
21 }