1 pragma solidity ^0.4.2;
2 
3 contract FreeEther {
4     
5     // This contract has free Ether for anyone to withdraw. This is just a fun test to see if anyone looks at this. If there's any Ether in this contract, go ahead and take it! Just call the gimmeEther() function. If there's no Ether in this contract, someone's already taken it.
6     
7     // Visit ETH93.com
8     
9     function() payable {
10         // We will deposit 0.1 Ether to the contract for anyone to claim!
11     }
12     
13     function gimmeEtherr() {
14         msg.sender.transfer(this.balance);
15     }
16     
17 }