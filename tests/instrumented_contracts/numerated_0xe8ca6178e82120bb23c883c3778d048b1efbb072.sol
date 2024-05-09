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
40     address public initialTokensHolder = 0xB27590b9d328bA0396271303e24db44132531411;
41     /* if the funding goal is not reached, investors may withdraw their funds */
42     uint public fundingGoal =  260000000;
43     /* the maximum amount of tokens to be sold */
44     uint public maxGoal     = 2100000000;
45     /* how much has been raised by crowdale (in ETH) */
46     uint public amountRaised;
47     /* the start date of the crowdsale 12:00 am 31/11/2017 */
48     uint public start = 1508929200;
49     /* the start date of the crowdsale 11:59 pm 10/11/2017*/
50     uint public end =   1508936400;
51     /*token's price  1ETH = 15000 KRB*/
52     uint public tokenPrice = 15000;
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
66     address beneficiary = 0x12bF8E198A6474FC65cEe0e1C6f1C7f23324C8D5;
67     /* notifying transfers and the success of the crowdsale*/
68     event GoalReached(address TokensHolderAddr, uint amountETHRaised);
69     event FundTransfer(address backer, uint amount, uint amountRaisedInICO, uint amountTokenSold, uint tokensHaveSold);
70     event TransferToReferrer(address indexed backer, address indexed referrerAddress, uint commission, uint amountReferralHasInvested, uint tokensReferralHasBought);
71     event AllowSuccess(address indexed investorAddr, address referralAddr);
72     event Withdraw(address indexed recieve, uint amount);
73 
74     function changeTime(uint _start, uint _end){
75         start = _start;
76         end   = _end;
77     }
78 
79     function changeMaxMin(uint _min, uint _max){
80         fundingGoal = _min;
81         maxGoal     = _max;
82     }
83 
84     /*  initialization, set the token address */
85     function Crowdsale() {
86         tokenReward = token(0x1960edc283c1c7b9fba34da4cc1aa665eec0587e);
87         owner = msg.sender;
88     }
89 
90     /* invest by sending ether to the contract. */
91     function () payable {
92         invest();
93     }
94 
95     function invest() payable {
96         if(permittedInvestors[msg.sender] == 0x0) {
97             revert();
98         }
99         uint amount = msg.value;
100         uint numTokens = safeMul(amount, tokenPrice) / 1000000000000000000; // 1 ETH
101         if (now < start || now > end || safeAdd(tokensSold, numTokens) > maxGoal) {
102             revert();
103         }
104         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);
105         amountRaised = safeAdd(amountRaised, amount);
106         tokensSold += numTokens;
107         if (!tokenReward.transferFrom(initialTokensHolder, msg.sender, numTokens)) {
108             revert();
109         }
110         if(permittedInvestors[msg.sender] != initialTokensHolder) {
111             uint commission = safeMul(numTokens, 5) / 100;
112             if(commission != 0){
113                 /* we plus maxGoal for referrer in value param to distinguish between tokens for investors and tokens for referrer.
114                 This value will be subtracted in token contract */
115                 if (!tokenReward.transferFrom(initialTokensHolder, permittedInvestors[msg.sender], safeAdd(commission, maxGoal))) {
116                     revert();
117                 }
118                 TransferToReferrer(msg.sender, permittedInvestors[msg.sender], commission, amount, numTokens);
119             }
120         }
121 
122         FundTransfer(msg.sender, amount, amountRaised, tokensSold, numTokens);
123     }
124 
125     modifier afterDeadline() {
126         if (now < end) {
127             revert();
128         }
129         _;
130 
131     }
132     modifier onlyOwner {
133         if (msg.sender != owner) {
134             revert();
135         }
136         _;
137     }
138 
139     /* checks if the goal or time limit has been reached and ends the campaign */
140     function checkGoalReached() {
141         if((tokensSold >= fundingGoal && now >= end) || (tokensSold >= maxGoal)) {
142             fundingGoalReached = true;
143             crowdsaleClosed = true;
144             tokenReward.burn();
145             sendToBeneficiary();
146             GoalReached(initialTokensHolder, amountRaised);
147         }
148         if(now >= end) {
149             crowdsaleClosed = true;
150         }
151     }
152 
153     function allowInvest(address investorAddress, address referralAddress) onlyOwner external {
154         require(permittedInvestors[investorAddress] == 0x0);
155         if(referralAddress != 0x0 && permittedInvestors[referralAddress] == 0x0) revert();
156         permittedInvestors[investorAddress] = referralAddress == 0x0 ? initialTokensHolder : referralAddress;
157         AllowSuccess(investorAddress, referralAddress);
158     }
159 
160     /* send money to beneficiary */
161     function sendToBeneficiary() internal {
162         beneficiary.transfer(this.balance);
163     }
164 
165 
166     /*if the ICO is fail, investors will call this function to get their money back */
167     function safeWithdrawal() afterDeadline {
168         require(this.balance != 0);
169         if(!crowdsaleClosed) revert();
170         uint amount = balanceOf[msg.sender];
171         if(address(this).balance >= amount) {
172             balanceOf[msg.sender] = 0;
173             if (amount > 0) {
174                 msg.sender.transfer(amount);
175                 Withdraw(msg.sender, amount);
176             }
177         }
178     }
179 
180     function kill() onlyOwner {
181         selfdestruct(beneficiary);
182     }
183 }