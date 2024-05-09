1 pragma solidity ^0.4.23;
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
27 contract EphronIndiaCoinICO {
28     using SafeMath for uint;
29     // The maximum amount of tokens to be sold
30     uint constant public maxGoal = 900000; // 275 Milion CoinPoker Tokens
31     // There are different prices and amount available in each period
32     uint public prices = 100000; // 1ETH = 4200CHP, 1ETH = 3500CHP
33     uint public amount_stages = 27500; // the amount stages for different prices
34     // How much has been raised by crowdsale (in ETH)
35     uint public amountRaised;
36     // The number of tokens already sold
37     uint public tokensSold = 0;
38     // The start date of the crowdsale
39     uint constant public start = 1526470200; // Friday, 19 January 2018 10:00:00 GMT
40     // The end date of the crowdsale
41     uint constant public end = 1531675800; // Friday, 26 January 2018 10:00:00 GMT
42     // The balances (in ETH) of all token holders
43     mapping(address => uint) public balances;
44     // Indicates if the crowdsale has been ended already
45     bool public crowdsaleEnded = false;
46     // Tokens will be transfered from this address
47     address public tokenOwner;
48     // The address of the token contract
49     token public tokenReward;
50     // The wallet on which the funds will be stored
51     address wallet;
52     // Notifying transfers and the success of the crowdsale
53     event Finalize(address _tokenOwner, uint _amountRaised);
54     event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);
55 
56     // ---- FOR TEST ONLY ----
57     uint _current = 0;
58     function current() public returns (uint) {
59         // Override not in use
60         if(_current == 0) {
61             return now;
62         }
63         return _current;
64     }
65     function setCurrent(uint __current) {
66         _current = __current;
67     }
68     //------------------------
69 
70     // Constructor/initialization
71     function EphronIndiaCoinICO(address tokenAddr, address walletAddr, address tokenOwnerAddr) {
72         tokenReward = token(tokenAddr);
73         wallet = walletAddr;
74         tokenOwner = tokenOwnerAddr;
75     }
76 
77     // Exchange CHP by sending ether to the contract.
78     function() payable {
79         if (msg.sender != wallet) // Do not trigger exchange if the wallet is returning the funds
80             exchange(msg.sender);
81     }
82 
83     // Make an exchangement. Only callable if the crowdsale started and hasn't been ended, also the maxGoal wasn't reached yet.
84     // The current token price is looked up by available amount. Bought tokens is transfered to the receiver.
85     // The sent value is directly forwarded to a safe wallet.
86     function exchange(address receiver) payable {
87         uint amount = msg.value;
88         uint price = getPrice();
89         uint numTokens = amount.mul(price);
90 
91         require(numTokens > 0);
92         require(!crowdsaleEnded && current() >= start && current() <= end && tokensSold.add(numTokens) <= maxGoal);
93 
94         wallet.transfer(amount);
95         balances[receiver] = balances[receiver].add(amount);
96 
97         // Calculate how much raised and tokens sold
98         amountRaised = amountRaised.add(amount);
99         tokensSold = tokensSold.add(numTokens);
100 
101         assert(tokenReward.transferFrom(tokenOwner, receiver, numTokens));
102         FundTransfer(receiver, amount, true, amountRaised);
103     }
104     
105      // Looks up the current token price
106     function getPrice() constant returns (uint price) {
107         return prices;
108     }
109 
110     // Manual exchange tokens for BTC,LTC,Fiat contributions.
111     // @param receiver who tokens will go to.
112     // @param value an amount of tokens.
113     function manualExchange(address receiver, uint value) {
114         require(msg.sender == tokenOwner);
115         require(tokensSold.add(value) <= maxGoal);
116         tokensSold = tokensSold.add(value);
117         assert(tokenReward.transferFrom(tokenOwner, receiver, value));
118     }
119 
120    
121 
122     modifier afterDeadline() { if (current() >= end) _; }
123 
124     // Checks if the goal or time limit has been reached and ends the campaign
125     function finalize() afterDeadline {
126         require(!crowdsaleEnded);
127         tokenReward.burn(); // Burn remaining tokens but the reserved ones
128         Finalize(tokenOwner, amountRaised);
129         crowdsaleEnded = true;
130     }
131 
132     // Allows the funders to withdraw their funds if the goal has not been reached.
133     // Only works after funds have been returned from the wallet.
134     function safeWithdrawal() afterDeadline {
135         uint amount = balances[msg.sender];
136         if (address(this).balance >= amount) {
137             balances[msg.sender] = 0;
138             if (amount > 0) {
139                 msg.sender.transfer(amount);
140                 FundTransfer(msg.sender, amount, false, amountRaised);
141             }
142         }
143     }
144 }