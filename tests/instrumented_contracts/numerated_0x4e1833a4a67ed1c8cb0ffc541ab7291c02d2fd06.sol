1 pragma solidity ^0.4.0;
2 contract countGame {
3 
4     address public best_gamer;
5     uint public count = 0;
6     uint public endTime = 1504969200;
7     
8     function fund() payable {
9         require(now <= endTime);
10     }
11     
12     function (){
13         require(now<=endTime && count<50);
14         best_gamer = msg.sender;
15         count++;
16     }
17     
18     function endGame(){
19         require(now>endTime || count == 50);
20         best_gamer.transfer(this.balance);
21     }
22     
23 }