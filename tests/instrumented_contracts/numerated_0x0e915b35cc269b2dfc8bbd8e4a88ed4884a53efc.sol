1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public;
5 }
6 
7 contract CrowdSale {
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public amountRaised;
11     uint public startTime;
12     uint public deadline;
13     uint public price;
14     token public tokenReward;
15     mapping(address => uint256) public balanceOf;
16     bool fundingGoalReached = false;
17     bool public crowdsaleClosed = false ;
18 
19     event GoalReached(address recipient, uint totalAmountRaised);
20     event FundTransfer(address backer, uint amount, bool isContribution);
21     event CrowdsaleClose(uint totalAmountRaised, bool fundingGoalReached);
22 
23     /**
24      * Constrctor function
25      *
26      * Setup the owner
27      */
28     function CrowdSale(
29         address ifSuccessfulSendTo,
30         uint fundingGoalInEthers,
31         uint startTimeInSeconds,
32         uint durationInMinutes,
33         uint szaboCostOfEachToken,
34         address addressOfTokenUsedAsReward
35     ) public {
36         beneficiary = ifSuccessfulSendTo;
37         fundingGoal = fundingGoalInEthers * 1 ether;
38         startTime = startTimeInSeconds;
39         deadline = startTimeInSeconds + durationInMinutes * 1 minutes;
40         price = szaboCostOfEachToken * 1 finney;
41         tokenReward = token(addressOfTokenUsedAsReward);
42     }
43 
44     /**
45      * Do purchase process
46      *
47      */
48     function purchase() internal {
49         uint amount = msg.value;
50         balanceOf[msg.sender] += amount;
51         amountRaised += amount;
52         tokenReward.transferFrom(beneficiary, msg.sender, (amount * price) / 1 ether);
53         checkGoalReached();
54         FundTransfer(msg.sender, amount, true);
55     }
56 
57     /**
58      * Fallback function
59      *
60      * The function without name is the default function that is called whenever anyone sends funds to a contract
61      */
62     function()
63     payable
64     isOpen
65     afterStart
66     public {
67         purchase();
68     }
69 
70     /**
71      * The function called only from shiftsale
72      *
73      */
74     function shiftSalePurchase() payable public returns(bool success) {
75         purchase();
76         return true;
77     }
78 
79     modifier afterStart() {
80         require(now >= startTime);
81         _;
82     }
83 
84     modifier afterDeadline() {
85         require(now >= deadline);
86         _;
87     }
88 
89     modifier previousDeadline() {
90         require(now <= deadline);
91         _;
92     }
93 
94     modifier isOwner() {
95         require (msg.sender == beneficiary);
96         _;
97     }
98 
99     modifier isClosed() {
100         require(crowdsaleClosed);
101         _;
102     }
103 
104     modifier isOpen() {
105         require(!crowdsaleClosed);
106         _;
107     }
108 
109     /**
110      * Check if goal was reached
111      *
112      */
113     function checkGoalReached() internal {
114         if (amountRaised >= fundingGoal && !fundingGoalReached) {
115             fundingGoalReached = true;
116             GoalReached(beneficiary, amountRaised);
117         }
118     }
119 
120     /**
121      * Close the crowdsale
122      *
123      */
124     function closeCrowdsale()
125     isOwner
126     public {
127         crowdsaleClosed = true;
128         CrowdsaleClose(amountRaised, fundingGoalReached);
129     }
130 
131 
132     /**
133      * Withdraw the funds
134      *
135      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
136      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
137      * the amount they contributed.
138      */
139     function safeWithdrawal()
140     afterDeadline
141     isClosed
142     public {
143         if (!fundingGoalReached) {
144             uint amount = balanceOf[msg.sender];
145             balanceOf[msg.sender] = 0;
146             if (amount > 0) {
147                 if (msg.sender.send(amount)) {
148                     FundTransfer(msg.sender, amount, false);
149                 } else {
150                     balanceOf[msg.sender] = amount;
151                 }
152             }
153         }
154 
155         if (fundingGoalReached && beneficiary == msg.sender) {
156             if (beneficiary.send(amountRaised)) {
157                 FundTransfer(beneficiary, amountRaised, false);
158             } else {
159                 //If we fail to send the funds to beneficiary, unlock funders balance
160                 fundingGoalReached = false;
161             }
162         }
163     }
164 }