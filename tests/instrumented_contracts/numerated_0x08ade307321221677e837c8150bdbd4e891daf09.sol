1 pragma solidity ^0.4.15;
2 
3 contract Vault {
4     
5     event Deposit(address indexed depositor, uint amount);
6     event Withdrawal(address indexed to, uint amount);
7     event TransferOwnership(address indexed from, address indexed to);
8     
9     address Owner;
10     mapping (address => uint) public Deposits;
11     uint minDeposit;
12     bool Locked;
13     uint Date;
14 
15     function initVault() isOpen payable {
16         Owner = msg.sender;
17         minDeposit = 0.5 ether;
18         Locked = false;
19         deposit();
20     }
21 
22     function() payable { deposit(); }
23 
24     function deposit() payable addresses {
25         if (msg.value > 0) {
26             if (msg.value >= MinimumDeposit()) Deposits[msg.sender] += msg.value;
27             Deposit(msg.sender, msg.value);
28         }
29     }
30 
31     function withdraw(uint amount) payable onlyOwner { withdrawTo(msg.sender, amount); }
32     
33     function withdrawTo(address to, uint amount) onlyOwner {
34         if (WithdrawalEnabled()) {
35             uint max = Deposits[msg.sender];
36             if (max > 0 && amount <= max) {
37                 Withdrawal(to, amount);
38                 to.transfer(amount);
39             }
40         }
41     }
42 
43     function transferOwnership(address to) onlyOwner { TransferOwnership(Owner, to); Owner = to; }
44     function MinimumDeposit() constant returns (uint) { return minDeposit; }
45     function ReleaseDate() constant returns (uint) { return Date; }
46     function WithdrawalEnabled() internal returns (bool) { return Date > 0 && Date <= now; }
47     function SetReleaseDate(uint NewDate) { Date = NewDate; }
48     function lock() { Locked = true; }
49     modifier onlyOwner { if (msg.sender == Owner) _; }
50     modifier isOpen { if (!Locked) _; }
51     modifier addresses {
52         uint size;
53         assembly { size := extcodesize(caller) }
54         if (size > 0) return;
55         _;
56     }
57 }