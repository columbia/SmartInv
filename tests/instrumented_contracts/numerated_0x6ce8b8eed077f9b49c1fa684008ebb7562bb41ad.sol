1 pragma solidity ^0.4.1;
2 
3 contract LeanFund {
4 
5   // Poloniex Exchange Rate 2017-08-06: 266 USD / ETH
6   uint8 constant public version = 2;
7 
8   address public beneficiary;
9 
10   // These are for Ethereum backers only
11   mapping (address => uint) public contributionsETH;
12   mapping (address => uint) public payoutsETH;
13 
14   uint public fundingGoal;     // in wei, the amount we're aiming for
15   uint public payoutETH;       // in wei, the amount withdrawn as fee
16   uint public amountRaised;    // in wei, the total amount raised
17 
18   address public owner;
19   uint    public fee; // the contract fee is 1.5k USD, or ~5.63 ETH
20   uint    public feeWithdrawn; // in wei
21 
22   uint public creationTime;
23   uint public deadlineBlockNumber;
24   bool public open;            // has the funding period started, and contract initialized
25 
26   function LeanFund() {
27     owner = msg.sender;
28     creationTime = now;
29     open = false;
30   }
31 
32   // We can only initialize once, but don't add beforeDeadline guard or check deadline
33   function initialize(uint _fundingGoalInWei, address _beneficiary, uint _deadlineBlockNumber) {
34     if (open || msg.sender != owner) throw; // we can only initialize once
35     if (_deadlineBlockNumber < block.number + 40) throw; // deadlines must be at least ten minutes hence
36     beneficiary = _beneficiary;
37     payoutETH = 0;
38     amountRaised = 0;
39     fee = 0;
40     feeWithdrawn = 0;
41     fundingGoal = _fundingGoalInWei;
42 
43     // If we pass in a deadline in the past, set it to be 10 minutes from now.
44     deadlineBlockNumber = _deadlineBlockNumber;
45     open = true;
46   }
47 
48   modifier beforeDeadline() { if ((block.number < deadlineBlockNumber) && open) _; else throw; }
49   modifier afterDeadline() { if ((block.number >= deadlineBlockNumber) && open) _; else throw; }
50 
51   // Normal pay-in function, where msg.sender is the contributor
52   function() payable beforeDeadline {
53     if (msg.value != 1 ether) { throw; } // only accept payments of 1 ETH exactly
54     if (payoutsETH[msg.sender] == 0) { // defend against re-entrancy
55         contributionsETH[msg.sender] += msg.value; // allow multiple contributions
56         amountRaised += msg.value;
57     }
58   }
59 
60   function getContribution() constant returns (uint retVal) {
61     return contributionsETH[msg.sender];
62   }
63 
64   /* As a safeguard, if we were able to pay into account without being a contributor
65      allow contract owner to clean it up. */
66   function safeKill() afterDeadline {
67     if ((msg.sender == owner) && (this.balance > amountRaised)) {
68       uint amount = this.balance - amountRaised;
69       if (owner.send(amount)) {
70         open = false; // make this resettable to make testing easier
71       }
72     }
73   }
74 
75   /* Each backer is responsible for their own safe withdrawal, because it costs gas */
76   function safeWithdrawal() afterDeadline {
77     uint amount = 0;
78     if (amountRaised < fundingGoal && payoutsETH[msg.sender] == 0) {
79       // Ethereum backers can only withdraw the full amount they put in, and only once
80       amount = contributionsETH[msg.sender];
81       payoutsETH[msg.sender] += amount;
82       contributionsETH[msg.sender] = 0;
83       if (!msg.sender.send(amount)) {
84         payoutsETH[msg.sender] = 0;
85         contributionsETH[msg.sender] = amount;
86       }
87     } else if (payoutETH == 0) {
88       // anyone can withdraw the crowdfunded amount to the beneficiary after the deadline
89       fee = amountRaised * 563 / 10000; // 5.63% fee, only after beneficiary has received payment
90       amount = amountRaised - fee;
91       payoutETH += amount;
92       if (!beneficiary.send(amount)) {
93         payoutETH = 0;
94       }
95     } else if (msg.sender == owner && feeWithdrawn == 0) {
96       // only the owner can withdraw the fee and any excess funds (rounding errors)
97       feeWithdrawn += fee;
98       selfdestruct(owner);
99     }
100   }
101 
102 }