1 pragma solidity ^0.4.22;
2 contract LoeriadeNabidaz{
3     uint public c;
4     
5     function pay() payable public {
6         require(msg.value==0.0001 ether);
7         c = c+1;
8         if(c==2) {
9             msg.sender.transfer(this.balance);
10             c = 0;
11         }
12     }
13 }