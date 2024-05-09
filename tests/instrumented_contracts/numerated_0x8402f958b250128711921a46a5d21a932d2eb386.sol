1 pragma solidity ^0.4.11;
2 
3 contract Incrementer {
4 
5     event LogWinner(address winner, uint amount);
6     
7     uint c = 0;
8 
9     function ticket() payable {
10         
11         uint ethrebuts = msg.value;
12         if (ethrebuts != 10) {
13             throw;
14         }
15         c++;
16         
17         if (c==3) {
18             LogWinner(msg.sender,this.balance);
19             msg.sender.transfer(this.balance);
20             c=0;
21         }
22     }
23 }