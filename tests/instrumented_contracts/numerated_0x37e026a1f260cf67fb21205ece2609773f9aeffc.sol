1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     address public burner;
10     uint public fundingGoal;
11     uint public amountRaised;
12     uint public deadline;
13 
14     uint public pricePresale = 10000;
15     uint public priceRound1 = 5000;
16     uint public priceRound2 = 4500;
17     uint public priceRound3 = 4000;
18     uint public priceRound4 = 3500;
19 
20     uint public totalSupply = 61200000 * 1 ether;
21     uint public supplyRound1 = 10000000 * 1 ether;
22     uint public supplyRound2 = 10000000 * 1 ether;
23     uint public supplyRound3 = 10000000 * 1 ether;
24     uint public supplyRound4 = 10000000 * 1 ether;
25     uint private suppyLeft;
26 
27     // define amount of tokens to be sent to the funds, in percentages
28     uint public erotixFundMultiplier = 50;
29     uint public foundersFundMultiplier = 3;
30 
31     uint public requestedTokens;
32     uint public amountAvailable;
33 
34     bool round1Open = true;
35     bool round2Open = false;
36     bool round3Open = false;
37     bool round4Open = false;
38     bool soldOut = false;
39 
40     address public erotixFund = 0x1a0cc2B7F7Cb6fFFd3194A2AEBd78A4a072915Be;
41     // Smart contract which releases received ERX on the 1st of March 2019
42     address public foundersFund = 0xaefe05643b613823dBAF6245AFb819Fd56fBdd22;
43 
44     token public tokenReward;
45     mapping(address => uint256) public balanceOf;
46     bool fundingGoalReached = false;
47     bool crowdsaleClosed = false;
48 
49     event GoalReached(address recipient, uint totalAmountRaised);
50     event FundTransfer(address backer, uint amount, bool isContribution);
51 
52     /**
53      * Constructor function
54      *
55      * Setup the owner
56      */
57     function Crowdsale(
58         address ifSuccessfulSendTo,
59         uint fundingGoalInEthers,
60         uint endOfCrowdsale,
61         address addressOfTokenUsedAsReward,
62         address burnAddress
63     ) public {
64         beneficiary = ifSuccessfulSendTo;
65         fundingGoal = fundingGoalInEthers * 1 ether;
66         deadline = endOfCrowdsale;
67         tokenReward = token(addressOfTokenUsedAsReward);
68         burner = burnAddress;
69     }
70 
71     /**
72      * Fallback function
73      *
74      * The function without name is the default function that is called whenever anyone sends funds to a contract
75      */
76     function () payable public {
77         require(!crowdsaleClosed);
78         require(!soldOut);
79         uint amount = msg.value;
80 
81         bool orderFilled = false;
82 
83         while(!orderFilled) {
84             uint orderRate;
85             uint curSupply;
86 
87             if(round1Open) {
88                 orderRate = priceRound1;
89                 curSupply = supplyRound1;
90             } else if(round2Open) {
91                 orderRate = priceRound2;
92                 curSupply = supplyRound2;
93             } else if(round3Open) {
94                 orderRate = priceRound3;
95                 curSupply = supplyRound3;
96             } else if(round4Open) {
97                 orderRate = priceRound4;
98                 curSupply = supplyRound4;
99             }
100 
101             requestedTokens = amount * orderRate;
102 
103             if (requestedTokens <= curSupply) {
104                 balanceOf[msg.sender] += amount;
105                 amountRaised += amount;
106 
107                 //send tokens to investor
108                 tokenReward.transfer(msg.sender, amount * orderRate);
109                 //send tokens to funds
110                 tokenReward.transfer(erotixFund, amount * orderRate * erotixFundMultiplier / 100);
111                 tokenReward.transfer(foundersFund, amount * orderRate * foundersFundMultiplier / 100);
112 
113                 FundTransfer(msg.sender, amount, true);
114 
115                 // update supply
116                 if(round1Open) {
117                     supplyRound1 -= requestedTokens;
118                 } else if(round2Open) {
119                     supplyRound2 -= requestedTokens;
120                 } else if(round3Open) {
121                     supplyRound3 -= requestedTokens;
122                 } else if(round4Open) {
123                     supplyRound4 -= requestedTokens;
124                 }
125 
126                 orderFilled = true;
127             } else {
128                 // Not enough supply left, sell remaining supply
129                 amountAvailable = curSupply / orderRate;
130                 balanceOf[msg.sender] += amountAvailable;
131                 amountRaised += amountAvailable;
132 
133                 //send tokens to investor
134                 tokenReward.transfer(msg.sender, amountAvailable * orderRate);
135                 //send tokens to funds
136                 tokenReward.transfer(erotixFund, amountAvailable * orderRate * erotixFundMultiplier / 100);
137                 tokenReward.transfer(foundersFund, amountAvailable * orderRate * foundersFundMultiplier / 100);
138 
139                 FundTransfer(msg.sender, amountAvailable, true);
140 
141                 // set amount of eth left
142                 amount -= amountAvailable;
143 
144                 // update supply and close round
145                 supplyRound1 = 0;
146 
147                 if(round1Open) {
148                     supplyRound1 = 0;
149                     round1Open = false;
150                     round2Open = true;
151                 } else if(round2Open) {
152                     supplyRound2 = 0;
153                     round2Open = false;
154                     round3Open = true;
155                 } else if(round3Open) {
156                     supplyRound3 = 0;
157                     round3Open = false;
158                     round4Open = true;
159                 } else if(round4Open) {
160                     supplyRound4 = 0;
161                     round4Open = false;
162                     soldOut = true;
163 
164                     // send back remaining eth
165                     msg.sender.send(amount);
166                 }
167             }
168         }
169     }
170 
171     /**
172      * Check if goal was reached
173      *
174      * Checks if the goal or time limit has been reached and ends the campaign
175      */
176     function checkGoalReached() public {
177         if (now >= deadline || soldOut) {
178             if (amountRaised >= fundingGoal){
179                 fundingGoalReached = true;
180                 GoalReached(beneficiary, amountRaised);
181             }
182             crowdsaleClosed = true;
183 
184             suppyLeft = supplyRound1 + supplyRound2 + supplyRound3 + supplyRound4;
185 
186             if (suppyLeft > 0) {
187                 tokenReward.transfer(burner, suppyLeft);
188                 tokenReward.transfer(burner, suppyLeft * erotixFundMultiplier / 100);
189                 tokenReward.transfer(burner, suppyLeft * foundersFundMultiplier / 100);
190             }
191         }
192         
193     }
194 
195 
196     /**
197      * Withdraw the funds
198      *
199      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
200      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
201      * the amount they contributed.
202      */
203     function safeWithdrawal() public {
204         if (now >= deadline) {
205             if (!fundingGoalReached) {
206                 uint amount = balanceOf[msg.sender];
207                 balanceOf[msg.sender] = 0;
208                 if (amount > 0) {
209                     if (msg.sender.send(amount)) {
210                         FundTransfer(msg.sender, amount, false);
211                     } else {
212                         balanceOf[msg.sender] = amount;
213                     }
214                 }
215             }
216         }
217 
218         if (crowdsaleClosed) {
219             if (fundingGoalReached && beneficiary == msg.sender) {
220                 if (beneficiary.send(amountRaised)) {
221                     FundTransfer(beneficiary, amountRaised, false);
222                 }
223             }
224         }
225     }
226 }