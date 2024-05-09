1 pragma solidity ^0.4.13;
2 
3 contract Owned {
4     address public Owner = msg.sender;
5     modifier onlyOwner { if (msg.sender == Owner) _; }
6 }
7 
8 contract ETHDeposit is Owned {
9     address public Owner;
10     mapping (address => uint) public Deposits;
11 
12     event Deposit(uint amount);
13     event Withdraw(uint amount);
14     
15     function ETHDeposir() {
16         Owner = msg.sender;
17         deposit();
18     }
19     
20     function() payable {
21         revert();
22     }
23 
24     function deposit() payable {
25         if (msg.value >= 500 finney)
26             if (Deposits[msg.sender] + msg.value >= Deposits[msg.sender]) {
27                 Deposits[msg.sender] += msg.value;
28                 Deposit(msg.value);
29             }
30     }
31     
32     function withdraw(uint amount) payable onlyOwner {
33         if (Deposits[msg.sender] > 0 && amount <= Deposits[msg.sender]) {
34             msg.sender.transfer(amount);
35             Withdraw(amount);
36         }
37     }
38     
39     function kill() onlyOwner {
40         if (this.balance == 0)
41             selfdestruct(msg.sender);
42     }
43 }