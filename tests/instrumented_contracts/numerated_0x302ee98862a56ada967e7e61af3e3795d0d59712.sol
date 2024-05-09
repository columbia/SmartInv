1 pragma solidity ^0.4.2;
2 
3 contract SOCToken {
4     /* This creates an array with all balances */
5     mapping (address => uint256) public balanceOf;
6 
7     /* Initializes contract with initial supply tokens to the creator of the contract */
8     function SOCToken(
9         uint256 initialSupply
10         ) {
11         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
12     }
13 
14     /* Send coins */
15     function transfer(address _to, uint256 _value) {
16         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
17         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
18         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
19         balanceOf[_to] += _value;                            // Add the same to the recipient
20     }
21 }
22 
23 
24 contract SOCTokenSale {
25     address public beneficiary;
26     uint public fundingGoal; 
27 	uint public amountRaised; 
28 	uint public deadline; 
29 	uint public price;
30     SOCToken public tokenReward;
31     mapping(address => uint256) public balanceOf;
32     bool fundingGoalReached = false;
33     uint softMarketingLimit = 25 * 1 ether;	
34     event GoalReached(address beneficiary, uint amountRaised);
35     event FundTransfer(address backer, uint amount, bool isContribution);
36     bool crowdsaleClosed = false;
37 
38     /* data structure to hold information about campaign contributors */
39 
40     /*  at initialization, setup the owner */
41     function SOCTokenSale(
42         address ifSuccessfulSendTo,
43         uint fundingGoalInEthers,
44         uint durationInMinutes,
45         uint pricePerEther,
46         SOCToken addressOfTokenUsedAsReward
47     ) {
48         beneficiary = ifSuccessfulSendTo;
49         fundingGoal = fundingGoalInEthers * 1 ether;
50         deadline = now + durationInMinutes * 1 minutes;
51         price = 1 ether / pricePerEther;
52         tokenReward = SOCToken(addressOfTokenUsedAsReward);
53     }
54 
55     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
56     function () payable {
57         if (crowdsaleClosed) throw;
58         uint amount = msg.value;
59         balanceOf[msg.sender] = amount;
60         amountRaised += amount;
61         tokenReward.transfer(msg.sender, amount / price);
62         FundTransfer(msg.sender, amount, true);
63     }
64 
65     modifier afterDeadline() { if (now >= deadline) _; }
66 
67     /* checks if the goal or time limit has been reached and ends the campaign */
68     function checkGoalReached() afterDeadline {
69         if (amountRaised >= fundingGoal){
70             fundingGoalReached = true;
71             GoalReached(beneficiary, amountRaised);
72         }
73         crowdsaleClosed = true;
74     }
75 
76 
77     function withdrawal(uint amount) {
78         if (msg.sender == beneficiary) {
79             if (beneficiary.send(amount * 1 finney)) {
80     			FundTransfer(beneficiary, amount * 1 finney, false);
81             }
82         }
83     }	
84 	
85     function safeWithdrawal() afterDeadline {
86         if (amountRaised < softMarketingLimit) {
87             uint amount = balanceOf[msg.sender];
88             balanceOf[msg.sender] = 0;
89             if (amount > 0) {
90                 if (msg.sender.send(amount)) {
91                     FundTransfer(msg.sender, amount, false);
92                 } else {
93                     balanceOf[msg.sender] = amount;
94                 }
95             }
96         }
97 
98         if (fundingGoalReached && beneficiary == msg.sender) {
99             if (beneficiary.send(this.balance)) {
100                 FundTransfer(beneficiary, this.balance, false);
101             } else {
102                 fundingGoalReached = false;
103             }
104         }
105     }
106 }