1 pragma solidity ^0.4.11;
2 
3 contract Vault {
4     
5     event Deposit(address indexed depositor, uint amount);
6     event Withdrawal(address indexed to, uint amount);
7 
8     mapping (address => uint) public deposits;
9     uint minDeposit;
10     bool Locked;
11     address Owner;
12     uint Date;
13 
14     function initVault() isOpen payable {
15         Owner = msg.sender;
16         minDeposit = 0.1 ether;
17         Locked = false;
18     }
19 
20     function() payable { deposit(); }
21 
22     function MinimumDeposit() constant returns (uint) { return minDeposit; }
23     function ReleaseDate() constant returns (uint) { return Date; }
24     function WithdrawalEnabled() internal returns (bool) { return Date > 0 && Date <= now; }
25 
26     function deposit() payable {
27         if (msg.value >= MinimumDeposit()) {
28             deposits[msg.sender] += msg.value;
29         }
30         Deposit(msg.sender, msg.value);
31     }
32 
33     function withdraw(address to, uint amount) onlyOwner {
34         if (WithdrawalEnabled()) {
35             if (deposits[msg.sender] > 0 && amount <= deposits[msg.sender]) {
36                 to.transfer(amount);
37                 Withdrawal(to, amount);
38             }
39         }
40     }
41     
42     function SetReleaseDate(uint NewDate) { Date = NewDate; }
43     modifier onlyOwner { if (msg.sender == Owner) _; }
44     function lock() { Locked = true; }
45     modifier isOpen { if (!Locked) _; }
46     
47 }