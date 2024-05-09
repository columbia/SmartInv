1 /*
2  *  Crowdsale for Lympo Tokens.
3  *  Raised Ether will be stored safely at the wallet and returned to the ICO in case the funding
4  *  goal is not reached, allowing the token holders to withdraw their funds.
5  *  Author: Justas Kregždė
6  */
7  
8 pragma solidity ^0.4.19;
9 
10 contract token {
11     function transferFrom(address sender, address receiver, uint amount) returns(bool success) {}
12     function burn() {}
13 }
14 
15 library SafeMath {
16     function mul(uint a, uint b) internal returns (uint) {
17         uint c = a * b;
18         assert(a == 0 || c / a == b);
19         return c;
20     }
21 
22     function sub(uint a, uint b) internal returns (uint) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint a, uint b) internal returns (uint) {
28         uint c = a + b;
29         assert(c >= a && c >= b);
30         return c;
31     }
32 }
33 
34 contract LympoICO {
35     using SafeMath for uint;
36 
37     // pre-ICO
38     // The maximum amount of tokens to be sold during pre-ICO
39     uint constant public pre_maxGoal = 265000000e18; // 265 Million LYM Tokens
40     // There are different prices and amount available in each period
41     uint[2] public pre_prices = [60000, 50000];
42     uint[1] public pre_amount_stages = [90000000e18]; // the amount available in each stage
43     // The start date of the pre-ICO crowdsale
44     uint constant public pre_start = 1516618800; // Monday, 22 January 2018 11:00:00 GMT
45     // The end date of the pre-ICO crowdsale
46     uint constant public pre_end = 1517655600; // Saturday, 3 February 2018 11:00:00 GMT
47     // The number of tokens already sold during pre-ICO
48     uint public pre_tokensSold = 0;
49 
50     // ICO
51     // The maximum amount of tokens to be sold
52     uint constant public maxGoal = 385000000e18; // 385 Million LYM Tokens
53     // There are different prices and amount available in each period
54     uint[1] public prices = [40000];
55     // The start date of the crowdsale
56     uint constant public start = 1518865200; // Saturday, 17 February 2018 11:00:00 GMT
57     // The end date of the crowdsale
58     uint constant public end = 1519815600; // Wednesday, 28 February 2018 11:00:00 GMT
59     // The number of tokens already sold during ICO
60     uint public tokensSold = 0;
61 
62     // If the funding goal is not reached, token holders may withdraw their funds
63     uint constant public fundingGoal = 150000000e18; // 15%
64     // How much has been raised by crowdale (in ETH)
65     uint public amountRaised;
66     // The balances (in ETH) of all token holders
67     mapping(address => uint) public balances;
68     // Indicates if the crowdsale has been ended already
69     bool public crowdsaleEnded = false;
70     // Tokens will be transfered from this address
71     address public tokenOwner;
72     // The address of the token contract
73     token public tokenReward;
74     // The wallet on which the funds will be stored
75     address wallet;
76     // Notifying transfers and the success of the crowdsale
77     event GoalReached(address _tokenOwner, uint _amountRaised);
78     event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);
79 
80     // Constructor/initialization
81     function LympoICO(address tokenAddr, address walletAddr, address tokenOwnerAddr) {
82         tokenReward = token(tokenAddr);
83         wallet = walletAddr;
84         tokenOwner = tokenOwnerAddr;
85     }
86     
87     // Exchange by sending ether to the contract.
88     function() payable {
89         if (msg.sender != wallet) // Do not trigger exchange if the wallet is returning the funds
90             exchange(msg.sender);
91     }
92     
93     // Make an exchanegment. Only callable if the crowdsale started and hasn't been ended, also the maxGoal wasn't reached yet.
94     // The current token price is looked up by available amount. Bought tokens is transfered to the receiver.
95     // The sent value is directly forwarded to a safe wallet.
96     function exchange(address receiver) payable {
97         uint amount = msg.value;
98         uint price = getPrice();
99         uint numTokens = amount.mul(price);
100 
101         bool isPreICO = (now >= pre_start && now <= pre_end);
102         bool isICO = (now >= start && now <= end);
103 
104         require(isPreICO || isICO);
105         require(numTokens > 0);
106         if (isPreICO)
107         {
108             require(!crowdsaleEnded && pre_tokensSold.add(numTokens) <= pre_maxGoal);
109             if (pre_tokensSold < pre_amount_stages[0])
110                 require(numTokens <= 6000000e18); // max threshold for pre-ICO: 6mil LYM tokens for stage-I
111             else
112                 require(numTokens <= 12500000e18); // max threshold for pre-ICO: 12.5mil LYM tokens for stage-II
113         }
114         if (isICO)
115         {
116             require(!crowdsaleEnded && tokensSold.add(numTokens) <= maxGoal);
117         }
118 
119         wallet.transfer(amount);
120         balances[receiver] = balances[receiver].add(amount);
121         
122         // Calculate how much raised and tokens sold
123         amountRaised = amountRaised.add(amount);
124 
125         if (isPreICO)
126             pre_tokensSold = pre_tokensSold.add(numTokens);
127         if (isICO)
128             tokensSold = tokensSold.add(numTokens);
129 
130         assert(tokenReward.transferFrom(tokenOwner, receiver, numTokens));
131         FundTransfer(receiver, amount, true, amountRaised);
132     }
133 
134     // Looks up the current token price
135     function getPrice() constant returns (uint price) {
136         // pre-ICO prices
137         if (now >= pre_start && now <= pre_end)
138         {
139             for(uint i = 0; i < pre_amount_stages.length; i++) {
140                 if(pre_tokensSold < pre_amount_stages[i])
141                     return pre_prices[i];
142             }
143             return pre_prices[pre_prices.length-1];
144         }
145         // ICO prices
146         return prices[prices.length-1];
147     }
148 
149     modifier afterDeadline() { if (now >= end) _; }
150 
151     // Checks if the goal or time limit has been reached and ends the campaign
152     function checkGoalReached() afterDeadline {
153         if (pre_tokensSold.add(tokensSold) >= fundingGoal){
154             tokenReward.burn(); // Burn remaining tokens but the reserved ones
155             GoalReached(tokenOwner, amountRaised);
156         }
157         crowdsaleEnded = true;
158     }
159 
160     // Allows the funders to withdraw their funds if the goal has not been reached.
161     // Only works after funds have been returned from the wallet.
162     function safeWithdrawal() afterDeadline {
163         uint amount = balances[msg.sender];
164         if (address(this).balance >= amount) {
165             balances[msg.sender] = 0;
166             if (amount > 0) {
167                 msg.sender.transfer(amount);
168                 FundTransfer(msg.sender, amount, false, amountRaised);
169             }
170         }
171     }
172 }