1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5     /*
6         @return sum of a and b
7     */
8     function ADD (uint256 a, uint256 b) pure internal returns (uint256) {
9         uint256 c = a + b;
10         assert(c >= a);
11         return c;
12     }
13 
14     /*
15         @return difference of a and b
16     */
17     function SUB (uint256 a, uint256 b) pure internal returns (uint256) {
18         assert(a >= b);
19         return a - b;
20     }
21     
22 }
23 
24 interface token {
25     function transfer(address receiver, uint amount) external;
26     function burn(uint256 _value) external;
27 }
28 
29 contract Crowdsale {
30 
31     using SafeMath for uint256;
32 
33     address public beneficiary = 0x8b7426A552AE68EbB8cb1C30295551B8D5A05304;
34     address addressOfTokenUsedAsReward = 0x77A4A5b3007EFa19B5D049B914a1271367E27FE4;
35     uint256 public constant hardCapInTokens = 20160000000000000; 
36     uint256 public fundingGoal = 800;       								 //SoftCap
37     uint256 public amountRaised;
38     uint256 public deadline = now + 60720 minutes; 
39     uint256 public price;
40     token public tokenReward;
41     uint256 public soldTokens;  								//Count Outing Tokens sold
42     uint256 public restTokens = (hardCapInTokens - soldTokens);
43     
44     uint256 public constant MIN_ETHER = 0.1 ether;     //Min amount of Ether 
45     uint256 public constant MAX_ETHER = 90 ether;              //Max amount of Ether
46 
47     uint256 public START = now;                        //Start crowdsale
48 
49     uint256 public TIER2 = now + 20400 minutes;        //Start + 14 days
50 
51     uint256 public TIER3 = now + 40560 minutes;        //Start + 28 days ( 14 days + 14 days)
52 
53     uint256 public TIER4 = now + 50640 minutes;        //Start + 35 days ( 14 days + 14 days + 7 days)
54 
55 
56     uint256 public constant TIER1_PRICE = 627000;      //Price in 1st tier
57     uint256 public constant TIER2_PRICE = 716600;      //Price in 2nd tier
58     uint256 public constant TIER3_PRICE = 806200;      //Price in 3rd tier
59     uint256 public constant TIER4_PRICE = 895700;      //Price in 4th tier
60 
61 
62     mapping(address => uint256) public balanceOf;
63     bool fundingGoalReached = false;
64     bool crowdsaleClosed = false;
65 
66     event GoalReached(address recipient, uint totalAmountRaised);
67     event FundTransfer(address backer, uint amount, bool isContribution);
68 
69     function Crowdsale ()
70     public
71     {
72         price = getPrice();
73         tokenReward = token(addressOfTokenUsedAsReward);
74     }
75 
76     function () public payable {
77         require(!crowdsaleClosed);
78         uint amount = msg.value;
79         require(amount >= MIN_ETHER);
80         require (amount <= MAX_ETHER);
81         balanceOf[msg.sender] += amount;
82         amountRaised += amount;
83         soldTokens += amount / price;
84         tokenReward.transfer(msg.sender, amount / price);
85         FundTransfer(msg.sender, amount, true);
86 
87     }
88 
89     modifier afterDeadline() { if (now >= deadline) _; }
90 
91     /**
92      * Check if goal was reached
93      *
94      * Checks if the goal or time limit has been reached and ends the campaign
95      */
96     function checkGoalReached() afterDeadline public {
97         if (amountRaised >= fundingGoal){
98             fundingGoalReached = true;
99             GoalReached(beneficiary, amountRaised);
100         }
101 
102        	 if (soldTokens >= hardCapInTokens)   {
103         crowdsaleClosed = true;
104 
105         tokenReward.burn(hardCapInTokens - soldTokens);
106 
107         	}
108     }
109 
110         /* Change tier taking block numbers as time */
111     function getPrice()
112         internal
113         constant
114         returns (uint256)
115     {
116         if (now <= TIER2) {
117             return TIER1_PRICE;
118         } else if (now < TIER3) {
119             return TIER2_PRICE;
120         } else if (now < TIER4) {
121             return TIER3_PRICE;
122         }
123         return TIER4_PRICE;
124     }
125 
126 
127     /**
128      * Withdraw the funds
129      *
130      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
131      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
132      * the amount they contributed.
133      */
134     function safeWithdrawal() afterDeadline public {
135         if (!fundingGoalReached) {
136             uint amount = balanceOf[msg.sender];
137             balanceOf[msg.sender] = 0;
138             if (amount > 0) {
139                 if (msg.sender.send(amount)) {
140                     FundTransfer(msg.sender, amount, false);
141                 } else {
142                     balanceOf[msg.sender] = amount;
143                 }
144             }
145         }
146 
147         if (fundingGoalReached && beneficiary == msg.sender) {
148             if (beneficiary.send(amountRaised)) {
149                 FundTransfer(beneficiary, amountRaised, false);
150             } else {
151                 //If we fail to send the funds to beneficiary, unlock funders balance
152                 fundingGoalReached = false;
153             }
154         }
155     }
156 }