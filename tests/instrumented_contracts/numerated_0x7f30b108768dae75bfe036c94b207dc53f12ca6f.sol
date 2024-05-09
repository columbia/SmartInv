1 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
2 pragma solidity 0.4.15;
3 
4 
5 /// @title Abstract token contract - Functions to be implemented by token contracts.
6 contract Token {
7     function transfer(address to, uint256 value) returns (bool success);
8     function transferFrom(address from, address to, uint256 value) returns (bool success);
9     function approve(address spender, uint256 value) returns (bool success);
10 
11     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions.
12     //function totalSupply() constant returns (uint256 supply) {};
13     function balanceOf(address owner) constant returns (uint256 balance);
14     function allowance(address owner, address spender) constant returns (uint256 remaining);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 contract DutchAuction {
21 
22     /*
23      *  Events
24      */
25     event BidSubmission(address indexed sender, uint256 amount);
26 
27     /*
28      *  Constants
29      */
30     uint constant public MAX_TOKENS_SOLD = 5000000 * 10**18; // 5M
31     uint constant public WAITING_PERIOD = 7 days;
32 
33     /*
34      *  Storage
35      */
36     Token public virtuePlayerPoints;
37     address public wallet;
38     address public owner;
39     uint public ceiling;
40     uint public priceFactor;
41     uint public startBlock;
42     uint public endTime;
43     uint public totalReceived;
44     uint public finalPrice;
45     mapping (address => uint) public bids;
46     Stages public stage;
47     
48     // Bidder whitelist. Entries in the array are whitelisted addresses
49     // Entries in the address-keyed map represent the (array_index+1) of
50     // the key. 
51     
52     address[] public bidderWhitelist; // allows iteration over whitelisted addresses
53     mapping (address => uint ) public whitelistIndexMap;  // allows fast address lookup
54 
55     /*
56      *  Enums
57      */
58     enum Stages {
59         AuctionDeployed,
60         AuctionSetUp,
61         AuctionStarted,
62         AuctionEnded,
63         TradingStarted
64     }
65 
66     /*
67      *  Modifiers
68      */
69     modifier atStage(Stages _stage) {
70         require (stage == _stage);
71             // Contract must be in expected state
72         _;
73     }
74 
75     modifier isOwner() {
76         require (msg.sender == owner);
77             // Only owner is allowed to proceed
78         _;
79     }
80 
81     modifier isWallet() {
82         require (msg.sender == wallet);
83             // Only wallet is allowed to proceed
84         _;
85     }
86 
87     modifier isValidPayload() {
88         require (msg.data.length == 4 || msg.data.length == 36);
89         _;
90     }
91 
92     modifier timedTransitions() {
93         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
94             finalizeAuction();
95         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
96             stage = Stages.TradingStarted;
97         _;
98     }
99 
100     /*
101      *  Public functions
102      */
103     /// @dev Contract constructor function sets owner.
104     /// @param _wallet Multisig wallet for auction proceeds.
105     /// @param _ceiling Auction ceiling.
106     /// @param _priceFactor Auction price factor.
107     function DutchAuction(address _wallet, uint _ceiling, uint _priceFactor)
108         public
109     {
110         require (_wallet != 0);
111         require (_ceiling != 0);
112         require (_priceFactor != 0);
113             // Arguments cannot be null.
114         owner = msg.sender;
115         wallet = _wallet;
116         ceiling = _ceiling;
117         priceFactor = _priceFactor;
118         stage = Stages.AuctionDeployed;
119     }
120 
121     /// @dev Setup function sets external contracts' addresses.
122     /// @param _virtuePlayerPoints token contract address.
123     function setup(address _virtuePlayerPoints)
124         public
125         isOwner
126         atStage(Stages.AuctionDeployed)
127     {
128         require (_virtuePlayerPoints != 0);
129             // Argument cannot be null.
130         virtuePlayerPoints = Token(_virtuePlayerPoints);
131         // Validate token balance
132         require (virtuePlayerPoints.balanceOf(this) == MAX_TOKENS_SOLD);
133 
134         stage = Stages.AuctionSetUp;
135     }
136 
137 
138     /// @dev Add bidder address to whitelist
139     /// @param _bidderAddr Bidder Eth address
140     function addToWhitelist(address _bidderAddr)
141         public
142         isOwner
143         atStage(Stages.AuctionSetUp)
144     {
145         require(_bidderAddr != 0);
146         if (whitelistIndexMap[_bidderAddr] == 0)
147         {
148             uint idxPlusOne = bidderWhitelist.push(_bidderAddr);
149             whitelistIndexMap[_bidderAddr] = idxPlusOne; 
150         }
151     }
152 
153     /// @dev Add multiple bidder addresses to whitelist
154     /// @param _bidderAddrs Array of Bidder Eth addresses
155     function addArrayToWhitelist(address[] _bidderAddrs)
156         public
157         isOwner
158         atStage(Stages.AuctionSetUp)
159     {
160         require(_bidderAddrs.length != 0);
161         for(uint idx = 0; idx<_bidderAddrs.length; idx++) {
162             addToWhitelist(_bidderAddrs[idx]);
163         }
164     }
165 
166     /// @dev Remove bidder address from whitelist
167     /// @param _bidderAddr Bidder Eth address
168     function removeFromWhitelist(address _bidderAddr)
169         public
170         isOwner
171         atStage(Stages.AuctionSetUp)       
172     {
173         require(_bidderAddr != 0);
174         require( whitelistIndexMap[_bidderAddr] != 0); // throw if not in map             
175         uint idx = whitelistIndexMap[_bidderAddr] - 1;
176         bidderWhitelist[idx] = 0;
177         whitelistIndexMap[_bidderAddr] = 0;
178     }
179     
180     /// @dev Is this addres in the whitelist?
181     /// @param _addr Bidder Eth address    
182     function isInWhitelist(address _addr)
183         public
184         constant
185         returns(bool)
186     {
187         return (whitelistIndexMap[_addr] != 0);
188     }
189     
190     /// @dev Number of non-zero entries in whitelist
191     /// @return number of non-zero entries
192     function whitelistCount()
193         public
194         constant
195         returns (uint)        
196     {
197         uint count = 0;
198         for (uint i = 0; i< bidderWhitelist.length; i++) {
199             if (bidderWhitelist[i] != 0)
200                 count++;
201         }
202         return count;
203     }
204     
205     /// @dev Fetch entries in whitelist
206     /// @param _startIdx starting index
207     /// @param _count number to fetch. zero for all.
208     /// @return array of non-zero entries
209     /// Note: because there can be null entries in the bidderWhitelist array,
210     /// indices used in this call are not the same as those in bidderwhiteList
211     function whitelistEntries(uint _startIdx, uint _count)
212         public
213         constant
214         returns (address[])        
215     {
216         uint addrCount = whitelistCount();
217         if (_count == 0)
218             _count = addrCount; 
219         if (_startIdx >= addrCount) {
220             _startIdx = 0;
221             _count = 0;
222         } else if (_startIdx + _count > addrCount) {
223             _count = addrCount - _startIdx;        
224         }
225 
226         address[] memory results = new address[](_count);
227         // skip to startIdx
228         uint dynArrayIdx = 0; 
229         while (_startIdx > 0) {
230             if (bidderWhitelist[dynArrayIdx++] != 0)
231                 _startIdx--;  
232         }   
233         // copy into results
234         uint resultsIdx = 0; 
235         while (resultsIdx < _count) {
236             address addr = bidderWhitelist[dynArrayIdx++];
237             if (addr != 0)
238                 results[resultsIdx++] = addr;      
239         }
240         return results;    
241     }    
242     
243     /// @dev Starts auction and sets startBlock.
244     function startAuction()
245         public
246         isWallet
247         atStage(Stages.AuctionSetUp)
248     {
249         stage = Stages.AuctionStarted;
250         startBlock = block.number;
251     }
252 
253     /// @dev Changes auction ceiling and start price factor before auction is started.
254     /// @param _ceiling Updated auction ceiling.
255     /// @param _priceFactor Updated start price factor.
256     function changeSettings(uint _ceiling, uint _priceFactor)
257         public
258         isWallet
259         atStage(Stages.AuctionSetUp)
260     {
261         ceiling = _ceiling;
262         priceFactor = _priceFactor;
263     }
264 
265     /// @dev Calculates current token price.
266     /// @return Returns token price.
267     function calcCurrentTokenPrice()
268         public
269         timedTransitions
270         returns (uint)
271     {
272         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
273             return finalPrice;
274         return calcTokenPrice();
275     }
276 
277     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
278     /// @return Returns current auction stage.
279     function updateStage()
280         public
281         timedTransitions
282         returns (Stages)
283     {
284         return stage;
285     }
286 
287     /// @dev Allows to send a bid to the auction.
288     /// @param receiver Bid will be assigned to this address if set.
289     function bid(address receiver)
290         public
291         payable
292         isValidPayload
293         timedTransitions
294         atStage(Stages.AuctionStarted)
295         returns (uint amount)
296     {
297         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
298         if (receiver == 0)
299             receiver = msg.sender;
300 
301         require(isInWhitelist(receiver));         
302             
303         amount = msg.value;
304         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
305         uint maxWei = (MAX_TOKENS_SOLD / 10**18) * calcTokenPrice() - totalReceived;
306         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
307         if (maxWeiBasedOnTotalReceived < maxWei)
308             maxWei = maxWeiBasedOnTotalReceived;
309         // Only invest maximum possible amount.
310         if (amount > maxWei) {
311             amount = maxWei;
312             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
313             receiver.transfer(msg.value - amount); // throws on failure
314         }
315         // Forward funding to ether wallet
316         require (amount != 0);
317         wallet.transfer(amount); // throws on failure
318         bids[receiver] += amount;
319         totalReceived += amount;
320         if (maxWei == amount)
321             // When maxWei is equal to the big amount the auction is ended and finalizeAuction is triggered.
322             finalizeAuction();
323         BidSubmission(receiver, amount);
324     }
325 
326     /// @dev Claims tokens for bidder after auction.
327     /// @param receiver Tokens will be assigned to this address if set.
328     function claimTokens(address receiver)
329         public
330         isValidPayload
331         timedTransitions
332         atStage(Stages.TradingStarted)
333     {
334         if (receiver == 0)
335             receiver = msg.sender;
336         uint tokenCount = bids[receiver] * 10**18 / finalPrice;
337         bids[receiver] = 0;
338         virtuePlayerPoints.transfer(receiver, tokenCount);
339     }
340 
341     /// @dev Calculates stop price.
342     /// @return Returns stop price.
343     function calcStopPrice()
344         constant
345         public
346         returns (uint)
347     {
348         return totalReceived * 10**18 / MAX_TOKENS_SOLD + 1;
349     }
350 
351     /// @dev Calculates token price.
352     /// @return Returns token price.
353     function calcTokenPrice()
354         constant
355         public
356         returns (uint)
357     {
358         return priceFactor * 10**18 / (block.number - startBlock + 8000) + 1;
359     }
360 
361     /*
362      *  Private functions
363      */
364     function finalizeAuction()
365         private
366     {
367         stage = Stages.AuctionEnded;
368         if (totalReceived == ceiling)
369             finalPrice = calcTokenPrice();
370         else
371             finalPrice = calcStopPrice();
372         uint soldTokens = totalReceived * 10**18 / finalPrice;
373         // Auction contract transfers all unsold tokens to multisig wallet
374         virtuePlayerPoints.transfer(wallet, MAX_TOKENS_SOLD - soldTokens);
375         endTime = now;
376     }
377 }