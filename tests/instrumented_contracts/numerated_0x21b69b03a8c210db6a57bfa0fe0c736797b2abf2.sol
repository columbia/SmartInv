1 pragma solidity 0.4.4;
2 
3 
4 /// @title Abstract token contract - Functions to be implemented by token contracts.
5 contract Token {
6     function transfer(address to, uint256 value) returns (bool success);
7 }
8 
9 
10 /// @title Dutch auction contract - creation of Gnosis tokens.
11 /// @author Stefan George - <stefan.george@consensys.net>
12 contract DutchAuction {
13 
14     /*
15      *  Events
16      */
17     event BidSubmission(address indexed sender, uint256 amount);
18 
19     /*
20      *  Constants
21      */
22     uint constant public MAX_TOKENS_SOLD = 9000000 * 10**18; // 9M
23     uint constant public WAITING_PERIOD = 7 days;
24 
25     /*
26      *  Storage
27      */
28     Token public gnosisToken;
29     address public wallet;
30     address public owner;
31     uint public ceiling;
32     uint public priceFactor;
33     uint public startBlock;
34     uint public endTime;
35     uint public totalReceived;
36     uint public finalPrice;
37     mapping (address => uint) public bids;
38     Stages public stage;
39 
40     /*
41      *  Enums
42      */
43     enum Stages {
44         AuctionDeployed,
45         AuctionStarted,
46         AuctionEnded,
47         TradingStarted
48     }
49 
50     /*
51      *  Modifiers
52      */
53     modifier atStage(Stages _stage) {
54         if (stage != _stage)
55             // Contract not in expected state
56             throw;
57         _;
58     }
59 
60     modifier isOwner() {
61         if (msg.sender != owner)
62             // Only owner is allowed to proceed
63             throw;
64         _;
65     }
66 
67     modifier isWallet() {
68         if (msg.sender != wallet)
69             // Only owner is allowed to proceed
70             throw;
71         _;
72     }
73 
74     modifier timedTransitions() {
75         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
76             finalizeAuction();
77         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
78             stage = Stages.TradingStarted;
79         _;
80     }
81 
82     /*
83      *  Public functions
84      */
85     /// @dev Contract constructor function sets owner.
86     /// @param _wallet Gnosis wallet.
87     /// @param _ceiling Auction ceiling.
88     /// @param _priceFactor Auction price factor.
89     function DutchAuction(address _wallet, uint _ceiling, uint _priceFactor)
90         public
91     {
92         if (_wallet == 0 || _ceiling == 0 || _priceFactor == 0)
93             // Arguments are null.
94             throw;
95         owner = msg.sender;
96         wallet = _wallet;
97         ceiling = _ceiling;
98         priceFactor = _priceFactor;
99         stage = Stages.AuctionDeployed;
100     }
101 
102     /// @dev Setup function sets external contracts' addresses.
103     /// @param _gnosisToken Gnosis token address.
104     function setup(address _gnosisToken)
105         public
106         isOwner
107     {
108         if (address(gnosisToken) != 0 || _gnosisToken == 0)
109             // Setup was executed already or arguments are null.
110             throw;
111         gnosisToken = Token(_gnosisToken);
112     }
113 
114     /// @dev Starts auction and sets startBlock.
115     function startAuction()
116         public
117         isWallet
118         atStage(Stages.AuctionDeployed)
119     {
120         stage = Stages.AuctionStarted;
121         startBlock = block.number;
122     }
123 
124     /// @dev Changes auction ceiling and start price factor before auction is started.
125     /// @param _ceiling Updated auction ceiling.
126     /// @param _priceFactor Updated start price factor.
127     function changeSettings(uint _ceiling, uint _priceFactor)
128         public
129         isWallet
130         atStage(Stages.AuctionDeployed)
131     {
132         ceiling = _ceiling;
133         priceFactor = _priceFactor;
134     }
135 
136     /// @dev Calculates current token price.
137     /// @return Returns token price.
138     function calcCurrentTokenPrice()
139         public
140         timedTransitions
141         returns (uint)
142     {
143         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
144             return finalPrice;
145         return calcTokenPrice();
146     }
147 
148     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
149     /// @return Returns current auction stage.
150     function updateStage()
151         public
152         timedTransitions
153         returns (Stages)
154     {
155         return stage;
156     }
157 
158     /// @dev Allows to send a bid to the auction.
159     /// @param receiver Bid will be assigned to this address if set.
160     function bid(address receiver)
161         public
162         payable
163         timedTransitions
164         atStage(Stages.AuctionStarted)
165         returns (uint amount)
166     {
167         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
168         if (receiver == 0)
169             receiver = msg.sender;
170         amount = msg.value;
171         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
172         uint maxEther = (MAX_TOKENS_SOLD / 10**18) * calcTokenPrice() - totalReceived;
173         uint maxEtherBasedOnTotalReceived = ceiling - totalReceived;
174         if (maxEtherBasedOnTotalReceived < maxEther)
175             maxEther = maxEtherBasedOnTotalReceived;
176         // Only invest maximum possible amount.
177         if (amount > maxEther) {
178             amount = maxEther;
179             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
180             if (!receiver.send(msg.value - amount))
181                 // Sending failed
182                 throw;
183         }
184         // Forward funding to ether wallet
185         if (amount == 0 || !wallet.send(amount))
186             // No amount sent or sending failed
187             throw;
188         bids[receiver] += amount;
189         totalReceived += amount;
190         if (maxEther == amount)
191             // When maxEther is equal to the big amount the auction is ended and finalizeAuction is triggered.
192             finalizeAuction();
193         BidSubmission(receiver, amount);
194     }
195 
196     /// @dev Claims tokens for bidder after auction.
197     /// @param receiver Tokens will be assigned to this address if set.
198     function claimTokens(address receiver)
199         public
200         timedTransitions
201         atStage(Stages.TradingStarted)
202     {
203         if (receiver == 0)
204             receiver = msg.sender;
205         uint tokenCount = bids[receiver] * 10**18 / finalPrice;
206         bids[receiver] = 0;
207         gnosisToken.transfer(receiver, tokenCount);
208     }
209 
210     /// @dev Calculates stop price.
211     /// @return Returns stop price.
212     function calcStopPrice()
213         constant
214         public
215         returns (uint)
216     {
217         return totalReceived * 10**18 / MAX_TOKENS_SOLD + 1;
218     }
219 
220     /// @dev Calculates token price.
221     /// @return Returns token price.
222     function calcTokenPrice()
223         constant
224         public
225         returns (uint)
226     {
227         return priceFactor * 1 ether / (block.number - startBlock + 7500) + 1;
228     }
229 
230     /*
231      *  Private functions
232      */
233     function finalizeAuction()
234         private
235     {
236         stage = Stages.AuctionEnded;
237         if (totalReceived == ceiling)
238             finalPrice = calcTokenPrice();
239         else
240             finalPrice = calcStopPrice();
241         uint soldTokens = totalReceived * 10**18 / finalPrice;
242         // Auction contract transfers all unsold tokens to Gnosis inventory multisig
243         gnosisToken.transfer(wallet, MAX_TOKENS_SOLD - soldTokens);
244         endTime = now;
245     }
246 }