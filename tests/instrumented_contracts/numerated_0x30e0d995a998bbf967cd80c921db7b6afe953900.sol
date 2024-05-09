1 pragma solidity ^0.4.18;
2 
3 contract PiggyBank {
4     event Gift(address indexed donor, uint indexed amount);
5     event Lambo(uint indexed amount);
6 
7     uint constant lamboTime = 2058739200; // my niece turns 18
8     address niece = 0x1FC7b94f00C54C89336FEB4BaF617010a6867B40; //address of my niece wallet
9 
10     function() payable {
11         Gift(msg.sender, msg.value);
12     }
13     
14     function buyLambo() {
15         require (block.timestamp > lamboTime && msg.sender == niece);
16         Lambo(this.balance);
17         msg.sender.transfer(this.balance);
18     }
19 }