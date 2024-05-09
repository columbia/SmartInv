1 pragma solidity ^0.4.2;
2 
3 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
4 /// @title Abstract token contract - Functions to be implemented by token contracts.
5 contract Token {
6     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
7     function totalSupply() constant returns (uint256 supply) {}
8     function balanceOf(address owner) constant returns (uint256 balance);
9     function transfer(address to, uint256 value) returns (bool success);
10     function transferFrom(address from, address to, uint256 value) returns (bool success);
11     function approve(address spender, uint256 value) returns (bool success);
12     function allowance(address owner, address spender) constant returns (uint256 remaining);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 contract HumaniqToken is Token {
19     function issueTokens(address _for, uint tokenCount) payable returns (bool);
20     function changeEmissionContractAddress(address newAddress) returns (bool);
21 }
22 
23 /// @title HumaniqICO contract - Takes funds from users and issues tokens.
24 /// @author Evgeny Yurtaev - <evgeny@etherionlab.com>
25 contract HumaniqICO {
26 
27     /*
28      * External contracts
29      */
30     HumaniqToken public humaniqToken = HumaniqToken(0x9734c136F5c63531b60D02548Bca73a3d72E024D);
31 
32     /*
33      * Crowdfunding parameters
34      */
35     uint constant public CROWDFUNDING_PERIOD = 12 days;
36     // Goal threshold, 10000 ETH
37     uint constant public CROWDSALE_TARGET = 10000 ether;
38 
39     /*
40      *  Storage
41      */
42     address public founder;
43     address public multisig;
44     uint public startDate = 0;
45     uint public icoBalance = 0;
46     uint public baseTokenPrice = 666 szabo; // 0.000666 ETH
47     uint public discountedPrice = baseTokenPrice;
48     bool public isICOActive = false;
49 
50     // participant address => value in Wei
51     mapping (address => uint) public investments;
52 
53     /*
54      *  Modifiers
55      */
56     modifier onlyFounder() {
57         // Only founder is allowed to do this action.
58         if (msg.sender != founder) {
59             throw;
60         }
61         _;
62     }
63 
64     modifier minInvestment() {
65         // User has to send at least the ether value of one token.
66         if (msg.value < baseTokenPrice) {
67             throw;
68         }
69         _;
70     }
71 
72     modifier icoActive() {
73         if (isICOActive == false) {
74             throw;
75         }
76         _;
77     }
78 
79     modifier applyBonus() {
80         uint icoDuration = now - startDate;
81         if (icoDuration >= 248 hours) {
82             discountedPrice = baseTokenPrice;
83         }
84         else if (icoDuration >= 176 hours) {
85             discountedPrice = (baseTokenPrice * 100) / 107;
86         }
87         else if (icoDuration >= 104 hours) {
88             discountedPrice = (baseTokenPrice * 100) / 120;
89         }
90         else if (icoDuration >= 32 hours) {
91             discountedPrice = (baseTokenPrice * 100) / 142;
92         }
93         else if (icoDuration >= 12 hours) {
94             discountedPrice = (baseTokenPrice * 100) / 150;
95         }
96         else {
97             discountedPrice = (baseTokenPrice * 100) / 170;
98         }
99         _;
100     }
101 
102     /// @dev Allows user to create tokens if token creation is still going
103     /// and cap was not reached. Returns token count.
104     function fund()
105         public
106         applyBonus
107         icoActive
108         minInvestment
109         payable
110         returns (uint)
111     {
112         // Token count is rounded down. Sent ETH should be multiples of baseTokenPrice.
113         uint tokenCount = msg.value / discountedPrice;
114         // Ether spent by user.
115         uint investment = tokenCount * discountedPrice;
116         // Send change back to user.
117         if (msg.value > investment && !msg.sender.send(msg.value - investment)) {
118             throw;
119         }
120         // Update fund's and user's balance and total supply of tokens.
121         icoBalance += investment;
122         investments[msg.sender] += investment;
123         // Send funds to founders.
124         if (!multisig.send(investment)) {
125             // Could not send money
126             throw;
127         }
128         if (!humaniqToken.issueTokens(msg.sender, tokenCount)) {
129             // Tokens could not be issued.
130             throw;
131         }
132         return tokenCount;
133     }
134 
135     /// @dev Issues tokens for users who made BTC purchases.
136     /// @param beneficiary Address the tokens will be issued to.
137     /// @param _tokenCount Number of tokens to issue.
138     function fundBTC(address beneficiary, uint _tokenCount)
139         external
140         applyBonus
141         icoActive
142         onlyFounder
143         returns (uint)
144     {
145         // Approximate ether spent.
146         uint investment = _tokenCount * discountedPrice;
147         // Update fund's and user's balance and total supply of tokens.
148         icoBalance += investment;
149         investments[beneficiary] += investment;
150         if (!humaniqToken.issueTokens(beneficiary, _tokenCount)) {
151             // Tokens could not be issued.
152             throw;
153         }
154         return _tokenCount;
155     }
156 
157     /// @dev If ICO has successfully finished sends the money to multisig
158     /// wallet.
159     function finishCrowdsale()
160         external
161         onlyFounder
162         returns (bool)
163     {
164         if (isICOActive == true) {
165             isICOActive = false;
166             // Founders receive 14% of all created tokens.
167             uint founderBonus = ((icoBalance / baseTokenPrice) * 114) / 100;
168             if (!humaniqToken.issueTokens(multisig, founderBonus)) {
169                 // Tokens could not be issued.
170                 throw;
171             }
172         }
173     }
174 
175     /// @dev Sets token value in Wei.
176     /// @param valueInWei New value.
177     function changeBaseTokenPrice(uint valueInWei)
178         external
179         onlyFounder
180         returns (bool)
181     {
182         baseTokenPrice = valueInWei;
183         return true;
184     }
185 
186     /// @dev Function that activates ICO.
187     function startICO()
188         external
189         onlyFounder
190     {
191         if (isICOActive == false && startDate == 0) {
192           // Start ICO
193           isICOActive = true;
194           // Set start-date of token creation
195           startDate = now;
196         }
197     }
198 
199     /// @dev Contract constructor function sets founder and multisig addresses.
200     function HumaniqICO(address _multisig) {
201         // Set founder address
202         founder = msg.sender;
203         // Set multisig address
204         multisig = _multisig;
205     }
206 
207     /// @dev Fallback function. Calls fund() function to create tokens.
208     function () payable {
209         fund();
210     }
211 }