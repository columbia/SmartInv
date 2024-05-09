1 pragma solidity ^0.4.11;
2 
3 contract token {
4     function transferFrom(address, address, uint) returns(bool){}
5     function burn() {}
6 }
7 
8 contract SafeMath {
9     //internals
10 
11     function safeMul(uint a, uint b) internal returns (uint) {
12         uint c = a * b;
13         Assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function safeSub(uint a, uint b) internal returns (uint) {
18         Assert(b <= a);
19         return a - b;
20     }
21 
22     function safeAdd(uint a, uint b) internal returns (uint) {
23         uint c = a + b;
24         Assert(c >= a && c >= b);
25         return c;
26     }
27 
28     function Assert(bool assertion) internal {
29         if (!assertion) {
30             revert();
31         }
32     }
33 }
34 
35 
36 contract Crowdsale is SafeMath {
37     /*Owner's address*/
38     address public owner;
39     /* tokens will be transferred from BAP's address */
40     address public initialTokensHolder = 0x084bf76c9ba9106d6114305fae9810fbbdb157d9;
41     /* if the funding goal is not reached, investors may withdraw their funds */
42     uint public fundingGoal =  260000000;
43     /* the maximum amount of tokens to be sold */
44     uint public maxGoal     = 2100000000;
45     /* how much has been raised by crowdale (in ETH) */
46     uint public amountRaised;
47     /* the start date of the crowdsale 12:00 am 31/11/2017 */
48     uint public start = 1509375600;
49     /* the start date of the crowdsale 11:59 pm 10/11/2017*/
50     uint public end =   1510325999;
51     /*token's price  1ETH = 15000 KRB*/
52     uint public tokenPrice = 19000;
53     /* the number of tokens already sold */
54     uint public tokensSold;
55     /* the address of the token contract */
56     token public tokenReward;
57     /* the balances (in ETH) of all investors */
58     mapping(address => uint256) public balanceOf;
59     /*this mapping tracking allowed specific investor to invest and their referral */
60     mapping(address => address) public permittedInvestors;
61     /* indicated if the funding goal has been reached. */
62     bool public fundingGoalReached = false;
63     /* indicates if the crowdsale has been closed already */
64     bool public crowdsaleClosed = false;
65     /* this wallet will store all the fund made by ICO after ICO success*/
66     address beneficiary = 0x94B4776F8331DF237E087Ed548A3c8b4932D131B;
67     /* notifying transfers and the success of the crowdsale*/
68     event GoalReached(address TokensHolderAddr, uint amountETHRaised);
69     event FundTransfer(address backer, uint amount, uint amountRaisedInICO, uint amountTokenSold, uint tokensHaveSold);
70     event TransferToReferrer(address indexed backer, address indexed referrerAddress, uint commission, uint amountReferralHasInvested, uint tokensReferralHasBought);
71     event AllowSuccess(address indexed investorAddr, address referralAddr);
72     event Withdraw(address indexed recieve, uint amount);
73 
74     /*  initialization, set the token address */
75     function Crowdsale() {
76         tokenReward = token(0xd5527579226e4ebc8864906e49d05d4458ccf47f);
77         owner = msg.sender;
78     }
79 
80     /* invest by sending ether to the contract. */
81     function () payable {
82         invest();
83     }
84 
85     function invest() payable {
86         if(permittedInvestors[msg.sender] == 0x0) {
87             revert();
88         }
89         uint amount = msg.value;
90         uint numTokens = safeMul(amount, tokenPrice) / 1000000000000000000; // 1 ETH
91         if (now < start || now > end || safeAdd(tokensSold, numTokens) > maxGoal) {
92             revert();
93         }
94         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);
95         amountRaised = safeAdd(amountRaised, amount);
96         tokensSold += numTokens;
97         if (!tokenReward.transferFrom(initialTokensHolder, msg.sender, numTokens)) {
98             revert();
99         }
100         if(permittedInvestors[msg.sender] != initialTokensHolder) {
101             uint commission = safeMul(numTokens, 5) / 100;
102             if(commission != 0){
103                 /* we plus maxGoal for referrer in value param to distinguish between tokens for investors and tokens for referrer.
104                 This value will be subtracted in token contract */
105                 if (!tokenReward.transferFrom(initialTokensHolder, permittedInvestors[msg.sender], safeAdd(commission, maxGoal))) {
106                     revert();
107                 }
108                 TransferToReferrer(msg.sender, permittedInvestors[msg.sender], commission, amount, numTokens);
109             }
110         }
111 
112         FundTransfer(msg.sender, amount, amountRaised, tokensSold, numTokens);
113     }
114 
115     modifier afterDeadline() {
116         if (now < end) {
117             revert();
118         }
119         _;
120 
121     }
122     modifier onlyOwner {
123         if (msg.sender != owner) {
124             revert();
125         }
126         _;
127     }
128 
129     /* checks if the goal or time limit has been reached and ends the campaign */
130     function checkGoalReached() {
131         if((tokensSold >= fundingGoal && now >= end) || (tokensSold >= maxGoal)) {
132             fundingGoalReached = true;
133             crowdsaleClosed = true;
134             tokenReward.burn();
135             sendToBeneficiary();
136             GoalReached(initialTokensHolder, amountRaised);
137         }
138         if(now >= end) {
139             crowdsaleClosed = true;
140         }
141     }
142 
143     function allowInvest(address investorAddress, address referralAddress) onlyOwner external {
144         require(permittedInvestors[investorAddress] == 0x0);
145         if(referralAddress != 0x0 && permittedInvestors[referralAddress] == 0x0) revert();
146         permittedInvestors[investorAddress] = referralAddress == 0x0 ? initialTokensHolder : referralAddress;
147         AllowSuccess(investorAddress, referralAddress);
148     }
149 
150     /* send money to beneficiary */
151     function sendToBeneficiary() internal {
152         beneficiary.transfer(this.balance);
153     }
154 
155 
156     /*if the ICO is fail, investors will call this function to get their money back */
157     function safeWithdrawal() afterDeadline {
158         require(this.balance != 0);
159         if(!crowdsaleClosed) revert();
160         uint amount = balanceOf[msg.sender];
161         if(address(this).balance >= amount) {
162             balanceOf[msg.sender] = 0;
163             if (amount > 0) {
164                 msg.sender.transfer(amount);
165                 Withdraw(msg.sender, amount);
166             }
167         }
168     }
169 
170     function kill() onlyOwner {
171         selfdestruct(beneficiary);
172     }
173 }