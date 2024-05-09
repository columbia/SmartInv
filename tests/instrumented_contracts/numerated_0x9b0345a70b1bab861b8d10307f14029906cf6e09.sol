1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract Presale {
8     address public beneficiary;
9     address public burner;
10     uint public fundingGoal;
11     uint public amountRaised;
12     uint public deadline;
13 
14     uint public pricePresale = 10000;
15 
16     // 4 mill tokens available to investors during pre-ico
17     // 2 mill tokens reserved for erotix fund
18     // 120.000 tokens reserved for founders fund
19     uint public presaleSupply = 6120000 * 1 ether;
20     uint public availableSupply = 4000000 * 1 ether;
21 
22     // define amount of tokens to be sent to the funds, in percentages
23     uint public erotixFundMultiplier = 50;
24     uint public foundersFundMultiplier = 3;
25 
26     // parameters used to check if enough supply available for requested tokens
27     uint public requestedTokens;
28     uint public amountAvailable;
29 
30     address public erotixFund = 0x1a0cc2B7F7Cb6fFFd3194A2AEBd78A4a072915Be;
31     
32     // Smart contract which releases received ERX on the 1st of March 2019
33     address public foundersFund = 0xaefe05643b613823dBAF6245AFb819Fd56fBdd22; 
34 
35     token public tokenReward;
36     mapping(address => uint256) public balanceOf;
37     bool fundingGoalReached = false;
38     bool presaleClosed = false;
39 
40     event GoalReached(address recipient, uint totalAmountRaised);
41     event FundTransfer(address backer, uint amount, bool isContribution);
42 
43     /**
44      * Constructor function
45      *
46      * Setup the owner
47      */
48     function Presale(
49         address ifSuccessfulSendTo,
50         uint fundingGoalInEthers,
51         uint endOfPresale,
52         address addressOfTokenUsedAsReward,
53         address burnAddress
54     ) public {
55         beneficiary = ifSuccessfulSendTo;
56         fundingGoal = fundingGoalInEthers * 1 ether;
57         deadline = endOfPresale;
58         tokenReward = token(addressOfTokenUsedAsReward);
59         burner = burnAddress;
60     }
61 
62     /**
63      * Fallback function
64      *
65      * The function without name is the default function that is called whenever anyone sends funds to a contract
66      */
67     function () payable public {
68         require(!presaleClosed);
69         uint amount = msg.value;
70 
71         // Calculate amount of tokens requested by buyer
72         requestedTokens = amount * pricePresale;
73 
74         // Check if enough supply left to fill order
75         if (requestedTokens <= availableSupply) {
76             balanceOf[msg.sender] += amount;
77             amountRaised += amount;
78 
79             //send tokens to investor
80             tokenReward.transfer(msg.sender, amount * pricePresale);
81             //send tokens to funds
82             tokenReward.transfer(erotixFund, amount * pricePresale * erotixFundMultiplier / 100);
83             tokenReward.transfer(foundersFund, amount * pricePresale * foundersFundMultiplier / 100);
84 
85             FundTransfer(msg.sender, amount, true);
86 
87             // update supply
88             availableSupply -= requestedTokens;
89         } else {
90             // Not enough supply left, sell remaining supply
91             amountAvailable = availableSupply / pricePresale;
92             balanceOf[msg.sender] += amountAvailable;
93             amountRaised += amountAvailable;
94 
95             //send tokens to investor
96             tokenReward.transfer(msg.sender, amountAvailable * pricePresale);
97             //send tokens to funds
98             tokenReward.transfer(erotixFund, amountAvailable * pricePresale * erotixFundMultiplier / 100);
99             tokenReward.transfer(foundersFund, amountAvailable * pricePresale * foundersFundMultiplier / 100);
100 
101             FundTransfer(msg.sender, amountAvailable, true);
102 
103             // update supply
104             availableSupply = 0;
105 
106             // calculate amount of unspent eth and return it
107             amount -= amountAvailable;
108             msg.sender.send(amount);
109 
110             // Sold out. Close presale,
111             presaleClosed = true;
112         }
113     }
114 
115     modifier afterDeadline() { if (now >= deadline) _; }
116 
117     /**
118      * Check if goal was reached
119      *
120      * Checks if the goal or time limit has been reached and ends the campaign
121      */
122     function checkGoalReached() afterDeadline public {
123         if (amountRaised >= fundingGoal){
124             fundingGoalReached = true;
125             GoalReached(beneficiary, amountRaised);
126         }
127         presaleClosed = true;
128 
129         if (availableSupply > 0) {
130             tokenReward.transfer(burner, availableSupply);
131             tokenReward.transfer(burner, availableSupply * erotixFundMultiplier / 100);
132             tokenReward.transfer(burner, availableSupply * foundersFundMultiplier / 100);
133         }
134     }
135 
136 
137     /**
138      * Withdraw the funds
139      *
140      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
141      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
142      * the amount they contributed.
143      */
144     function safeWithdrawal() public {
145         if (now >= deadline) {
146             if (!fundingGoalReached) {
147                 uint amount = balanceOf[msg.sender];
148                 balanceOf[msg.sender] = 0;
149                 if (amount > 0) {
150                     if (msg.sender.send(amount)) {
151                         FundTransfer(msg.sender, amount, false);
152                     } else {
153                         balanceOf[msg.sender] = amount;
154                     }
155                 }
156             }
157         }
158         
159         if (presaleClosed) {
160             if (fundingGoalReached && beneficiary == msg.sender) {
161                 if (beneficiary.send(amountRaised)) {
162                     FundTransfer(beneficiary, amountRaised, false);
163                 } else {
164                     //If we fail to send the funds to beneficiary, unlock funders balance
165                     fundingGoalReached = false;
166                 }
167             }
168         }
169     }
170 }