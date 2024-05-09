1 pragma solidity 0.4.10;
2 
3 
4 /// @title Abstract token contract - Functions to be implemented by token contracts.
5 contract Token {
6     function transfer(address to, uint256 value) returns (bool success);
7     function transferFrom(address from, address to, uint256 value) returns (bool success);
8     function approve(address spender, uint256 value) returns (bool success);
9 
10     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions.
11     function totalSupply() constant returns (uint256 supply) {}
12     function balanceOf(address owner) constant returns (uint256 balance);
13     function allowance(address owner, address spender) constant returns (uint256 remaining);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 
20 /// @title Dutch auction contract - distribution of Gnosis tokens using an auction.
21 /// @author Stefan George - <stefan.george@consensys.net>
22 contract DutchAuction {
23 
24     /*
25      *  Events
26      */
27     event BidSubmission(address indexed sender, uint256 amount);
28 
29     /*
30      *  Constants
31      */
32     uint constant public MAX_TOKENS_SOLD = 9000000 * 10**18; // 9M
33     uint constant public WAITING_PERIOD = 7 days;
34 
35     /*
36      *  Storage
37      */
38     Token public gnosisToken;
39     address public wallet;
40     address public owner;
41     uint public ceiling;
42     uint public priceFactor;
43     uint public startBlock;
44     uint public endTime;
45     uint public totalReceived;
46     uint public finalPrice;
47     mapping (address => uint) public bids;
48     Stages public stage;
49 
50     /*
51      *  Enums
52      */
53     enum Stages {
54         AuctionDeployed,
55         AuctionSetUp,
56         AuctionStarted,
57         AuctionEnded,
58         TradingStarted
59     }
60 
61     /*
62      *  Modifiers
63      */
64     modifier atStage(Stages _stage) {
65         if (stage != _stage)
66             // Contract not in expected state
67             throw;
68         _;
69     }
70 
71     modifier isOwner() {
72         if (msg.sender != owner)
73             // Only owner is allowed to proceed
74             throw;
75         _;
76     }
77 
78     modifier isWallet() {
79         if (msg.sender != wallet)
80             // Only wallet is allowed to proceed
81             throw;
82         _;
83     }
84 
85     modifier isValidPayload() {
86         if (msg.data.length != 4 && msg.data.length != 36)
87             throw;
88         _;
89     }
90 
91     modifier timedTransitions() {
92         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
93             finalizeAuction();
94         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
95             stage = Stages.TradingStarted;
96         _;
97     }
98 
99     /*
100      *  Public functions
101      */
102     /// @dev Contract constructor function sets owner.
103     /// @param _wallet Gnosis wallet.
104     /// @param _ceiling Auction ceiling.
105     /// @param _priceFactor Auction price factor.
106     function DutchAuction(address _wallet, uint _ceiling, uint _priceFactor)
107         public
108     {
109         if (_wallet == 0 || _ceiling == 0 || _priceFactor == 0)
110             // Arguments are null.
111             throw;
112         owner = msg.sender;
113         wallet = _wallet;
114         ceiling = _ceiling;
115         priceFactor = _priceFactor;
116         stage = Stages.AuctionDeployed;
117     }
118 
119     /// @dev Setup function sets external contracts' addresses.
120     /// @param _gnosisToken Gnosis token address.
121     function setup(address _gnosisToken)
122         public
123         isOwner
124         atStage(Stages.AuctionDeployed)
125     {
126         if (_gnosisToken == 0)
127             // Argument is null.
128             throw;
129         gnosisToken = Token(_gnosisToken);
130         // Validate token balance
131         if (gnosisToken.balanceOf(this) != MAX_TOKENS_SOLD)
132             throw;
133         stage = Stages.AuctionSetUp;
134     }
135 
136     /// @dev Starts auction and sets startBlock.
137     function startAuction()
138         public
139         isWallet
140         atStage(Stages.AuctionSetUp)
141     {
142         stage = Stages.AuctionStarted;
143         startBlock = block.number;
144     }
145 
146     /// @dev Changes auction ceiling and start price factor before auction is started.
147     /// @param _ceiling Updated auction ceiling.
148     /// @param _priceFactor Updated start price factor.
149     function changeSettings(uint _ceiling, uint _priceFactor)
150         public
151         isWallet
152         atStage(Stages.AuctionSetUp)
153     {
154         ceiling = _ceiling;
155         priceFactor = _priceFactor;
156     }
157 
158     /// @dev Calculates current token price.
159     /// @return Returns token price.
160     function calcCurrentTokenPrice()
161         public
162         timedTransitions
163         returns (uint)
164     {
165         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
166             return finalPrice;
167         return calcTokenPrice();
168     }
169 
170     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
171     /// @return Returns current auction stage.
172     function updateStage()
173         public
174         timedTransitions
175         returns (Stages)
176     {
177         return stage;
178     }
179 
180     /// @dev Allows to send a bid to the auction.
181     /// @param receiver Bid will be assigned to this address if set.
182     function bid(address receiver)
183         public
184         payable
185         isValidPayload
186         timedTransitions
187         atStage(Stages.AuctionStarted)
188         returns (uint amount)
189     {
190         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
191         if (receiver == 0)
192             receiver = msg.sender;
193         amount = msg.value;
194         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
195         uint maxWei = (MAX_TOKENS_SOLD / 10**18) * calcTokenPrice() - totalReceived;
196         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
197         if (maxWeiBasedOnTotalReceived < maxWei)
198             maxWei = maxWeiBasedOnTotalReceived;
199         // Only invest maximum possible amount.
200         if (amount > maxWei) {
201             amount = maxWei;
202             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
203             if (!receiver.send(msg.value - amount))
204                 // Sending failed
205                 throw;
206         }
207         // Forward funding to ether wallet
208         if (amount == 0 || !wallet.send(amount))
209             // No amount sent or sending failed
210             throw;
211         bids[receiver] += amount;
212         totalReceived += amount;
213         if (maxWei == amount)
214             // When maxWei is equal to the big amount the auction is ended and finalizeAuction is triggered.
215             finalizeAuction();
216         BidSubmission(receiver, amount);
217     }
218 
219     /// @dev Claims tokens for bidder after auction.
220     /// @param receiver Tokens will be assigned to this address if set.
221     function claimTokens(address receiver)
222         public
223         isValidPayload
224         timedTransitions
225         atStage(Stages.TradingStarted)
226     {
227         if (receiver == 0)
228             receiver = msg.sender;
229         uint tokenCount = bids[receiver] * 10**18 / finalPrice;
230         bids[receiver] = 0;
231         gnosisToken.transfer(receiver, tokenCount);
232     }
233 
234     /// @dev Calculates stop price.
235     /// @return Returns stop price.
236     function calcStopPrice()
237         constant
238         public
239         returns (uint)
240     {
241         return totalReceived * 10**18 / MAX_TOKENS_SOLD + 1;
242     }
243 
244     /// @dev Calculates token price.
245     /// @return Returns token price.
246     function calcTokenPrice()
247         constant
248         public
249         returns (uint)
250     {
251         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
252     }
253 
254     /*
255      *  Private functions
256      */
257     function finalizeAuction()
258         private
259     {
260         stage = Stages.AuctionEnded;
261         if (totalReceived == ceiling)
262             finalPrice = calcTokenPrice();
263         else
264             finalPrice = calcStopPrice();
265         uint soldTokens = totalReceived * 10**18 / finalPrice;
266         // Auction contract transfers all unsold tokens to Gnosis inventory multisig
267         gnosisToken.transfer(wallet, MAX_TOKENS_SOLD - soldTokens);
268         endTime = now;
269     }
270 }