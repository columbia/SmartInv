1 pragma solidity ^0.4.18;
2 
3 /*************************/
4 /* Blocksquare Seed Sale */
5 /*************************/
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract owned {
35     address public owner;
36 
37     function owned() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function tranferOwnership(address _newOwner) public onlyOwner() {
47         owner = _newOwner;
48     }
49 }
50 
51 contract Token {
52     function mintTokens(address _atAddress, uint256 _amount) public;
53 }
54 
55 /****************************************/
56 /* BLOCKSQUARE SEED SALE IMPLEMENTATION */
57 /****************************************/
58 
59 contract BlocksquareSeedSale is owned {
60     using SafeMath for uint256;
61 
62     /** Events **/
63     event Received(address indexed _from, uint256 _amount);
64     event FundsReturned(address indexed _to, uint256 _amount);
65     event TokensGiven(address indexed _to, uint256 _amount);
66     event ErrorReturningEth(address _to, uint256 _amount);
67 
68     /** Public variables **/
69     uint256 public currentAmountRaised;
70     uint256 public valueInUSD;
71     uint256 public startTime;
72     address public recipient;
73 
74     /** Private variables **/
75     uint256 nextParticipantIndex;
76     uint256 currentAmountOfTokens;
77     bool icoHasStarted;
78     bool icoHasClosed;
79     Token reward;
80 
81     /** Constants **/
82     uint256[] tokensInTranch = [250000 * 10**18, 500000 * 10**18, 1000000 * 10**18, 1500000 * 10**18, 2000000 * 10**18, 3000000 * 10**18, 4000000 * 10**18, 5500000 * 10**18, 7000000 * 10**18, 10000000 * 10**18];
83     uint256[] priceOfTokenInUSD = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
84     uint256 maxAmountOfTokens = 10000000 * 10 ** 18;
85     uint256 DAY = 60 * 60 * 24;
86     uint256 MAXIMUM = 152 ether;
87     uint256 MAXIMUM24H = 2 ether;
88 
89     /** Mappings **/
90     mapping(address => uint256) contributed;
91     mapping(uint256 => address) participantIndex;
92     mapping(address => bool) canRecieveTokens;
93 
94     /**
95     * Constructor function
96     *
97     * Initializes contract.
98     **/
99     function BlocksquareSeedSale() public {
100         owner = msg.sender;
101         recipient = msg.sender;
102         reward = Token(0x509A38b7a1cC0dcd83Aa9d06214663D9eC7c7F4a);
103     }
104 
105     /**
106     * Basic payment
107     *
108     *
109     **/
110     function () payable public {
111         require(reward != address(0));
112         require(msg.value > 0);
113         require(icoHasStarted);
114         require(!icoHasClosed);
115         require(valueInUSD != 0);
116         require(canRecieveTokens[msg.sender]);
117         if(block.timestamp < startTime.add(DAY)) {
118             require(contributed[msg.sender].add(msg.value) <= MAXIMUM24H);
119         }
120         else {
121             require(contributed[msg.sender].add(msg.value) <= MAXIMUM);
122         }
123 
124         if(contributed[msg.sender] == 0) {
125             participantIndex[nextParticipantIndex] = msg.sender;
126             nextParticipantIndex += 1;
127         }
128 
129         contributed[msg.sender] = contributed[msg.sender].add(msg.value);
130         currentAmountRaised = currentAmountRaised.add(msg.value);
131         uint256 tokens = tokensToMint(msg.value);
132 
133         if(currentAmountOfTokens.add(tokens) >= maxAmountOfTokens) {
134             icoHasClosed = true;
135         }
136 
137         reward.mintTokens(msg.sender, tokens);
138         currentAmountOfTokens = currentAmountOfTokens.add(tokens);
139         Received(msg.sender, msg.value);
140         TokensGiven(msg.sender, tokens);
141 
142         if(this.balance >= 100 ether) {
143             if(!recipient.send(this.balance)) {
144                 ErrorReturningEth(recipient, this.balance);
145             }
146         }
147     }
148 
149     /**
150     * Calculate tokens to mint.
151     *
152     * Calculets how much tokens sender will get based on _amountOfWei he sent.
153     *
154     * @param _amountOfWei Amount of wei sender has sent to the contract.
155     * @return Number of tokens sender will recieve.
156     **/
157     function tokensToMint(uint256 _amountOfWei) private returns (uint256) {
158         uint256 raisedTokens = currentAmountOfTokens;
159         uint256 left = _amountOfWei;
160         uint256 rewardAmount = 0;
161         for(uint8 i = 0; i < tokensInTranch.length; i++) {
162             if (tokensInTranch[i] >= raisedTokens) {
163                 uint256 tokensPerEth = valueInUSD.div(priceOfTokenInUSD[i]);
164                 uint256 tokensLeft = tokensPerEth.mul(left);
165                 if((raisedTokens.add(tokensLeft)) <= tokensInTranch[i]) {
166                     rewardAmount = rewardAmount.add(tokensLeft);
167                     left = 0;
168                     break;
169                 }
170                 else {
171                     uint256 toNext = tokensInTranch[i].sub(raisedTokens);
172                     uint256 WeiCost = toNext.div(tokensPerEth);
173                     rewardAmount = rewardAmount.add(toNext);
174                     raisedTokens = raisedTokens.add(toNext);
175                     left = left.sub(WeiCost);
176                 }
177             }
178         }
179         if(left != 0) {
180             if(msg.sender.send(left)) {
181                 FundsReturned(msg.sender, left);
182                 currentAmountRaised = currentAmountRaised.sub(left);
183                 contributed[msg.sender] = contributed[msg.sender].sub(left);
184             }else {
185                 ErrorReturningEth(msg.sender, left);
186             }
187         }
188         return rewardAmount;
189     }
190 
191     /**
192     * Start Presale
193     *
194     * Starts presale and sets value of ETH in USD.
195     *
196     * @param _value Value of ETH in USD.
197     **/
198     function startICO(uint256 _value) public onlyOwner {
199         require(!icoHasStarted);
200         valueInUSD = _value;
201         startTime = block.timestamp;
202         icoHasStarted = true;
203     }
204 
205     /**
206     * Close presale
207     *
208     * Closes presale.
209     **/
210     function closeICO() public onlyOwner {
211         require(icoHasStarted);
212         icoHasClosed = true;
213     }
214 
215     /**
216     * Add to whitelist
217     *
218     * Adds address to whitelist so they can send ETH.
219     *
220     * @param _addresses Array of addresses to add to whitelist.
221     **/
222     function addAllowanceToRecieveToken(address[] _addresses) public onlyOwner {
223         for(uint256 i = 0; i < _addresses.length; i++) {
224             canRecieveTokens[_addresses[i]] = true;
225         }
226     }
227 
228     /**
229     * Withdraw Ether
230     *
231     * Withdraw Ether from contract.
232     **/
233     function withdrawEther() public onlyOwner {
234         if(!recipient.send(this.balance)) {
235             ErrorReturningEth(recipient, this.balance);
236         }
237     }
238 
239     /** Getters functions for info **/
240     function getToken() constant public returns (address _tokenAddress) {
241         return address(reward);
242     }
243 
244     function isCrowdsaleOpen() constant public returns (bool _isOpened) {
245         return (!icoHasClosed && icoHasStarted);
246     }
247 
248     function hasCrowdsaleStarted() constant public returns (bool _hasStarted) {
249         return icoHasStarted;
250     }
251 
252     function amountContributed(address _contributor) constant public returns(uint256 _contributedUntilNow){
253         return contributed[_contributor];
254     }
255 
256     function numberOfContributors() constant public returns(uint256 _numOfContributors){
257         return nextParticipantIndex;
258     }
259 
260     function numberOfTokens() constant public returns(uint256) {
261         return currentAmountOfTokens;
262     }
263 
264     function hasAllowanceToRecieveTokens(address _address) constant public returns(bool) {
265         return canRecieveTokens[_address];
266     }
267 
268     function endOf24H() constant public returns(uint256) {
269         return startTime.add(DAY);
270     }
271 }