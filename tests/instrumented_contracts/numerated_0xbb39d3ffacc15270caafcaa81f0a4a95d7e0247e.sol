1 pragma solidity ^0.4.15;
2 
3 contract token {
4     function transferFrom(address sender, address receiver, uint amount) returns(bool success) {}
5     function burn() {}
6 }
7 
8 library SafeMath {
9     function mul(uint a, uint b) internal returns (uint) {
10         uint c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function sub(uint a, uint b) internal returns (uint) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint a, uint b) internal returns (uint) {
21         uint c = a + b;
22         assert(c >= a && c >= b);
23         return c;
24     }
25 }
26 
27 contract NcICO {
28     using SafeMath for uint;
29     uint public prices;
30     // The start date of the crowdsale
31     uint public start; // Friday, 19 January 2018 10:00:00 GMT
32     // The end date of the crowdsale
33     uint public end; // Friday, 26 January 2018 10:00:00 GMT
34     // The balances (in ETH) of all token holders
35     mapping(address => uint) public balances;
36     // Indicates if the crowdsale has been ended already
37     bool public crowdsaleEnded = false;
38     // Tokens will be transfered from this address
39     address public tokenOwner;
40     // The address of the token contract
41     token public tokenReward;
42     // The wallet on which the funds will be stored
43     address wallet;
44     uint public amountRaised;
45     uint public deadline;
46     //uint public price;
47     // Notifying transfers and the success of the crowdsale
48     event Finalize(address _tokenOwner, uint _amountRaised);
49     event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);
50 
51     // ---- FOR TEST ONLY ----
52     uint _current = 0;
53     function current() public returns (uint) {
54         // Override not in use
55         if(_current == 0) {
56             return now;
57         }
58         return _current;
59     }
60     function setCurrent(uint __current) {
61         _current = __current;
62     }
63     //------------------------
64 
65     // Constructor/initialization
66     function NcICO(
67         address tokenAddr, 
68         address walletAddr, 
69         address tokenOwnerAddr,
70         uint durationInMinutes,
71         uint etherCostOfEachToken
72         //uint startTime,
73         //uint endTime,
74         //uint price
75         ) {
76         tokenReward = token(tokenAddr);
77         wallet = walletAddr;
78         tokenOwner = tokenOwnerAddr;
79         deadline = now + durationInMinutes * 1 minutes;
80         //start = startTime;
81         //end = endTime;
82         prices = etherCostOfEachToken * 0.0000001 ether;
83     }
84 
85     // Exchange CHP by sending ether to the contract.
86     function() payable {
87         //  require(!crowdsaleClosed);
88         // uint amount = msg.value;
89         // balances[msg.sender] += amount;
90         // amountRaised += amount;
91         // tokenReward.transfer(msg.sender, amount / prices);
92         // FundTransfer(msg.sender, amount, true);
93          if (msg.sender != wallet) // Do not trigger exchange if the wallet is returning the funds
94              exchange(msg.sender);
95     }
96 
97     // Make an exchangement. Only callable if the crowdsale started and hasn't been ended, also the maxGoal wasn't reached yet.
98     // The current token price is looked up by available amount. Bought tokens is transfered to the receiver.
99     // The sent value is directly forwarded to a safe wallet.
100     function exchange(address receiver) payable {
101         uint amount = msg.value;
102         uint price = getPrice();
103         uint numTokens = amount.mul(price);
104 
105         require(numTokens > 0);
106         //require(!crowdsaleEnded && current() >= start && current() <= end && tokensSold.add(numTokens) <= maxGoal);
107 
108         wallet.transfer(amount);
109         balances[receiver] = balances[receiver].add(amount);
110 
111         // Calculate how much raised and tokens sold
112         amountRaised = amountRaised.add(amount);
113        //tokensSold = tokensSold.add(numTokens);
114 
115         assert(tokenReward.transferFrom(tokenOwner, receiver, numTokens));
116         FundTransfer(receiver, amount, true, amountRaised);
117     }
118 
119     // Manual exchange tokens for BTC,LTC,Fiat contributions.
120     // @param receiver who tokens will go to.
121     // @param value an amount of tokens.
122     function manualExchange(address receiver, uint value) {
123         require(msg.sender == tokenOwner);
124        // require(tokensSold.add(value) <= maxGoal);
125         //tokensSold = tokensSold.add(value);
126         assert(tokenReward.transferFrom(tokenOwner, receiver, value));
127     }
128 
129     // Looks up the current token price
130     function getPrice() constant returns (uint price) {
131         // for(uint i = 0; i < amount_stages.length; i++) {
132         //     if(tokensSold < amount_stages[i])
133         //         return prices[i];
134         // }
135        // return prices[prices.length-1];
136        
137        return prices;
138     }
139 
140     modifier afterDeadline() { if (current() >= end) _; }
141 
142     // Checks if the goal or time limit has been reached and ends the campaign
143     function finalize() afterDeadline {
144         require(!crowdsaleEnded);
145         tokenReward.burn(); // Burn remaining tokens but the reserved ones
146         Finalize(tokenOwner, amountRaised);
147         crowdsaleEnded = true;
148     }
149 
150     // Allows the funders to withdraw their funds if the goal has not been reached.
151     // Only works after funds have been returned from the wallet.
152     function safeWithdrawal() afterDeadline {
153         uint amount = balances[msg.sender];
154         if (address(this).balance >= amount) {
155             balances[msg.sender] = 0;
156             if (amount > 0) {
157                 msg.sender.transfer(amount);
158                 FundTransfer(msg.sender, amount, false, amountRaised);
159             }
160         }
161     }
162 }