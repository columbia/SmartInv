1 pragma solidity ^0.4.4;
2 
3 contract FirstContract {
4 
5   bool frozen = false;
6   address owner;
7 
8   function FirstContract() payable {
9     owner = msg.sender;
10   }
11 
12   function freeze() {
13     frozen = true;
14   }
15 
16   //Release balance back to original owner if any
17   function releaseFunds() {
18     owner.transfer(this.balance);
19   }
20 
21   //You can claim current balance if you put the same amount (or more) back in
22   function claimBonus() payable {
23     if ((msg.value >= this.balance) && (frozen == false)) {
24       msg.sender.transfer(this.balance);
25     }
26   }
27 
28 }