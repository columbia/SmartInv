1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.3;
4 
5 contract BridgeDeposit {
6     address private owner;
7     uint256 private maxDepositAmount;
8     uint256 private maxBalance;
9     bool private canReceiveDeposit;
10 
11     constructor(
12         uint256 _maxDepositAmount,
13         uint256 _maxBalance,
14         bool _canReceiveDeposit
15     ) {
16         owner = msg.sender;
17         maxDepositAmount = _maxDepositAmount;
18         maxBalance = _maxBalance;
19         canReceiveDeposit = _canReceiveDeposit;
20         emit OwnerSet(address(0), msg.sender);
21         emit MaxDepositAmountSet(0, _maxDepositAmount);
22         emit MaxBalanceSet(0, _maxBalance);
23         emit CanReceiveDepositSet(_canReceiveDeposit);
24     }
25 
26     // Send the contract's balance to the owner
27     function withdrawBalance() public isOwner {
28         uint256 balance = address(this).balance;
29         payable(owner).transfer(balance);
30         emit BalanceWithdrawn(owner, balance);
31     }
32 
33     function destroy() public isOwner {
34         emit Destructed(owner, address(this).balance);
35         selfdestruct(payable(owner));
36     }
37 
38     // Receive function which reverts if amount > maxDepositAmount and canReceiveDeposit = false
39     receive() external payable isLowerThanMaxDepositAmount canReceive isLowerThanMaxBalance {
40         emit EtherReceived(msg.sender, msg.value);
41     }
42 
43     // Setters
44     function setMaxAmount(uint256 _maxDepositAmount) public isOwner {
45         emit MaxDepositAmountSet(maxDepositAmount, _maxDepositAmount);
46         maxDepositAmount = _maxDepositAmount;
47     }
48 
49     function setOwner(address newOwner) public isOwner {
50         emit OwnerSet(owner, newOwner);
51         owner = newOwner;
52     }
53 
54     function setCanReceiveDeposit(bool _canReceiveDeposit) public isOwner {
55         emit CanReceiveDepositSet(_canReceiveDeposit);
56         canReceiveDeposit = _canReceiveDeposit;
57     }
58 
59     function setMaxBalance(uint256 _maxBalance) public isOwner {
60         emit MaxBalanceSet(maxBalance, _maxBalance);
61         maxBalance = _maxBalance;
62     }
63 
64     // Getters
65     function getMaxDepositAmount() external view returns (uint256) {
66         return maxDepositAmount;
67     }
68 
69     function getMaxBalance() external view returns (uint256) {
70         return maxBalance;
71     }
72 
73     function getOwner() external view returns (address) {
74         return owner;
75     }
76 
77     function getCanReceiveDeposit() external view returns (bool) {
78         return canReceiveDeposit;
79     }
80 
81     // Modifiers
82     modifier isLowerThanMaxDepositAmount() {
83         require(msg.value <= maxDepositAmount, "Deposit amount is too big");
84         _;
85     }
86     modifier isOwner() {
87         require(msg.sender == owner, "Caller is not owner");
88         _;
89     }
90     modifier canReceive() {
91         require(canReceiveDeposit == true, "Contract is not allowed to receive ether");
92         _;
93     }
94     modifier isLowerThanMaxBalance() {
95         require(address(this).balance <= maxBalance, "Contract reached the max balance allowed");
96         _;
97     }
98 
99     // Events
100     event OwnerSet(address indexed oldOwner, address indexed newOwner);
101     event MaxDepositAmountSet(uint256 previousAmount, uint256 newAmount);
102     event CanReceiveDepositSet(bool canReceiveDeposit);
103     event MaxBalanceSet(uint256 previousBalance, uint256 newBalance);
104     event BalanceWithdrawn(address indexed owner, uint256 balance);
105     event EtherReceived(address indexed emitter, uint256 amount);
106     event Destructed(address indexed owner, uint256 amount);
107 }