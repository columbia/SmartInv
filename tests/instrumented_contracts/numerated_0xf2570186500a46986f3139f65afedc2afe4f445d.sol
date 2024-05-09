1 pragma solidity ^0.4.16;
2 
3 contract RealOldFuckMaker {
4     address fuck = 0xc63e7b1DEcE63A77eD7E4Aeef5efb3b05C81438D;
5     
6     // this can make OVER 9,000 OLD FUCKS
7     // (just pass in 129)
8     function makeOldFucks(uint32 number) {
9         uint32 i;
10         for (i = 0; i < number; i++) {
11             fuck.call(bytes4(sha3("giveBlockReward()")));
12         }
13     }
14 }