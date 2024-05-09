1 pragma solidity ^0.4.15;
2 
3 /**
4  *
5  * @author  <newtwist@protonmail.com>
6  *
7  * Version E
8  *
9  * Overview:
10  * This contract impliments a blind auction for burnable tokens. Each secret bid consists
11  * of a hashed bid-tuple, (`price`, `quantity`, `salt`), where price is the maximum amount
12  * of ether (in wei) a user is willing to pay per token, quantity is the number of tokens
13  * the user wants to buy, and salt is an arbitrary value. Together with the hashed bid-tuple,
14  * the user includes an encrypted bid tuple, using the public key of the party running the
15  * auction, and of course a deposit sufficient to pay for the bid.
16  *
17  * At the end of the bidding period, the party running the auction sets a 'strike price',
18  * thereby signaling the start of the sale period. During this period all bidders must
19  * execute their bids. To execute a bid a user reveals their bid-tuple. All bids with a
20  * price at least as high as the strike price are filled, and all bids under the strike
21  * price are returned. Bids that are exactly equal to the strike price are partially filled,
22  * so that the maximum number of tokens generated does not exceed the total supply.
23  *
24  * Strike Price:
25  * The strike price is calculated offchain by the party running the auction. When each
26  * secret bid is submitted an event is generated, which includes the sender address, hashed
27  * bid-tuple, encrypted bid-tuple and deposit amount. the party running the auction decrypts
28  * the encrypted bid-tuple, and regenerates the hash. If the regenerated hash does not match
29  * the hash that was submitted with the secret bid, or if the desposited funds are not
30  * sufficient to cover the bid, then the bid is disqualified. (presumably disqualifying
31  * invalid bids will be cheaper than validating all the valid bids).
32  *
33  * The auction is structured with a fixed maximum number of tokens. So to raise the maximum
34  * funds the bids are sorted, highest to lowest. Starting the strike-price at the highest
35  * bid, it is reduced, bid by bid, to include more bids. The quantity of tokens sold increases
36  * each time a new bid is included; but the the token price is reduced. At each step the
37  * total raise (token-price times quantity-of-tokens-sold) is computed. And the process ends
38  * whenever the total raise decreases, or when the total number of tokens exceeds the total
39  * supply.
40  *
41  * Notes:
42  * The `salt` is included in the bid-tuple to discourage brute-force attacks on the inputs
43  * to the secret bid.
44  *
45  * A user cannot submit multiple bids from the same Ether account.
46  *
47  * Users are required to execute their bids. If a user fails to execute their bid before the
48  * end of the sale period, then they forfeit half of their deposit, and receive no tokens.
49  * This rule was adopted to prevent users from placing several bids, and only revealing one
50  * of them. With this rule, all bids must be executed.
51  *
52  */
53 // Token standard API
54 // https://github.com/ethereum/EIPs/issues/20
55 
56 contract iERC20Token {
57   function totalSupply() constant returns (uint supply);
58   function balanceOf( address who ) constant returns (uint value);
59   function allowance( address owner, address spender ) constant returns (uint remaining);
60 
61   function transfer( address to, uint value) returns (bool ok);
62   function transferFrom( address from, address to, uint value) returns (bool ok);
63   function approve( address spender, uint value ) returns (bool ok);
64 
65   event Transfer( address indexed from, address indexed to, uint value);
66   event Approval( address indexed owner, address indexed spender, uint value);
67 }
68 
69 contract iBurnableToken is iERC20Token {
70   function burnTokens(uint _burnCount) public;
71   function unPaidBurnTokens(uint _burnCount) public;
72 }
73 
74 /*
75     Overflow protected math functions
76 */
77 contract SafeMath {
78     /**
79         constructor
80     */
81     function SafeMath() {
82     }
83 
84     /**
85         @dev returns the sum of _x and _y, asserts if the calculation overflows
86 
87         @param _x   value 1
88         @param _y   value 2
89 
90         @return sum
91     */
92     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
93         uint256 z = _x + _y;
94         assert(z >= _x);
95         return z;
96     }
97 
98     /**
99         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
100 
101         @param _x   minuend
102         @param _y   subtrahend
103 
104         @return difference
105     */
106     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
107         assert(_x >= _y);
108         return _x - _y;
109     }
110 
111     /**
112         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
113 
114         @param _x   factor 1
115         @param _y   factor 2
116 
117         @return product
118     */
119     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
120         uint256 z = _x * _y;
121         assert(_x == 0 || z / _x == _y);
122         return z;
123     }
124 }
125 
126 
127 contract TokenAuction is SafeMath {
128 
129   struct SecretBid {
130     bool disqualified;     // flag set if hash does not match encrypted bid
131     uint deposit;          // funds deposited by bidder
132     uint refund;           // funds to be returned to bidder
133     uint tokens;           // structure has been allocated
134     bytes32 hash;          // hash of price, quantity, secret
135   }
136   uint constant  AUCTION_START_EVENT = 0x01;
137   uint constant  AUCTION_END_EVENT   = 0x02;
138   uint constant  SALE_START_EVENT    = 0x04;
139   uint constant  SALE_END_EVENT      = 0x08;
140 
141   event SecretBidEvent(uint indexed batch, address indexed bidder, uint deposit, bytes32 hash, bytes message);
142   event ExecuteEvent(uint indexed batch, address indexed bidder, uint cost, uint refund);
143   event ExpireEvent(uint indexed batch, address indexed bidder, uint cost, uint refund);
144   event BizarreEvent(address indexed addr, string message, uint val);
145   event StateChangeEvent(uint mask);
146   //
147   //event MessageEvent(string message);
148   //event MessageUintEvent(string message, uint val);
149   //event MessageAddrEvent(string message, address val);
150   //event MessageBytes32Event(string message, bytes32 val);
151 
152   bool public isLocked;
153   uint public stateMask;
154   address public owner;
155   address public developers;
156   address public underwriter;
157   iBurnableToken public token;
158   uint public proceeds;
159   uint public strikePrice;
160   uint public strikePricePctX10;
161   uint public developerReserve;
162   uint public developerPctX10;
163   uint public purchasedCount;
164   uint public secretBidCount;
165   uint public executedCount;
166   uint public expiredCount;
167   uint public saleDuration;
168   uint public auctionStart;
169   uint public auctionEnd;
170   uint public saleEnd;
171   mapping (address => SecretBid) public secretBids;
172 
173   //
174   //tunables
175   uint batchSize = 4;
176   uint contractSendGas = 100000;
177 
178   modifier ownerOnly {
179     require(msg.sender == owner);
180     _;
181   }
182 
183   modifier unlockedOnly {
184     require(!isLocked);
185     _;
186   }
187 
188   modifier duringAuction {
189     require((stateMask & (AUCTION_START_EVENT | AUCTION_END_EVENT)) == AUCTION_START_EVENT);
190     _;
191   }
192 
193   modifier afterAuction {
194     require((stateMask & AUCTION_END_EVENT) != 0);
195     _;
196   }
197 
198   modifier duringSale {
199     require((stateMask & (SALE_START_EVENT | SALE_END_EVENT)) == SALE_START_EVENT);
200     _;
201   }
202 
203   modifier afterSale {
204     require((stateMask & SALE_END_EVENT) != 0);
205     _;
206   }
207 
208 
209   //
210   //constructor
211   //
212   function TokenAuction() {
213     owner = msg.sender;
214   }
215 
216   function lock() public ownerOnly {
217     isLocked = true;
218   }
219 
220   function setAuctionParms(iBurnableToken _token, address _underwriter, uint _auctionStart, uint _auctionDuration, uint _saleDuration) public ownerOnly unlockedOnly {
221     token = _token;
222     underwriter = _underwriter;
223     auctionStart = _auctionStart;
224     auctionEnd = safeAdd(_auctionStart, _auctionDuration);
225     saleDuration = _saleDuration;
226     if (stateMask != 0) {
227       //handy for debug
228       stateMask = 0;
229       strikePrice = 0;
230       purchasedCount = 0;
231       houseKeep();
232     }
233   }
234 
235   function reserveDeveloperTokens(address _developers, uint _developerPctX10) public ownerOnly unlockedOnly {
236     developers = _developers;
237     developerPctX10 = _developerPctX10;
238     uint _tokenCount = token.balanceOf(this);
239     developerReserve = (safeMul(_tokenCount, developerPctX10) / 1000);
240   }
241 
242   function tune(uint _batchSize, uint _contractSendGas) public ownerOnly {
243     batchSize = _batchSize;
244     contractSendGas = _contractSendGas;
245   }
246 
247 
248   //
249   //called by owner (or any other concerned party) to generate a SatateChangeEvent
250   //
251   function houseKeep() public {
252     uint _oldMask = stateMask;
253     if (now >= auctionStart) {
254       stateMask |= AUCTION_START_EVENT;
255       if (now >= auctionEnd) {
256         stateMask |= AUCTION_END_EVENT;
257         if (strikePrice > 0) {
258           stateMask |= SALE_START_EVENT;
259           if (now >= saleEnd)
260             stateMask |= SALE_END_EVENT;
261         }
262       }
263     }
264     if (stateMask != _oldMask)
265       StateChangeEvent(stateMask);
266   }
267 
268 
269 
270   //
271   //setting the strike price starts the sale period, during which bidders must call executeBid.
272   //the strike price should only be set once.... at any rate it cannot be changed once anyone has executed a bid.
273   //strikePricePctX10 specifies what percentage (x10) of requested tokens should be awarded to each bidder that
274   //bid exactly equal to the strike price.
275   //
276   function setStrikePrice(uint _strikePrice, uint _strikePricePctX10) public ownerOnly afterAuction {
277     require(executedCount == 0);
278     strikePrice = _strikePrice;
279     strikePricePctX10 = _strikePricePctX10;
280     saleEnd = safeAdd(now, saleDuration);
281     houseKeep();
282   }
283 
284 
285   //
286   // nobody should be sending funds via this function.... bizarre...
287   // the fact that we adjust proceeds here means that this fcn will OOG if called with a send or transfer. that's
288   // probably good, cuz it prevents the caller from losing their funds.
289   //
290   function () payable {
291     proceeds = safeAdd(proceeds, msg.value);
292     BizarreEvent(msg.sender, "bizarre payment", msg.value);
293   }
294 
295 
296   function depositSecretBid(bytes32 _hash, bytes _message) public duringAuction payable {
297     //each address can only submit one bid -- and once a bid is submitted it is imutable
298     //for testing, an exception is made for the owner -- but only while the contract is unlocked
299     if (!(msg.sender == owner && !isLocked) &&
300          (_hash == 0 || secretBids[msg.sender].hash != 0) )
301         revert();
302     secretBids[msg.sender].hash = _hash;
303     secretBids[msg.sender].deposit = msg.value;
304     secretBidCount += 1;
305     uint _batch = secretBidCount / batchSize;
306     SecretBidEvent(_batch, msg.sender, msg.value, _hash, _message);
307   }
308 
309 
310   //
311   // the owner may disqualify a bid if it is bogus. for example if the hash does not correspond
312   // to the hash that is generated from the encyrpted bid tuple. when a disqualified bid is
313   // executed all the deposited funds will be returned to the bidder, as if the bid was below
314   // the strike-price.
315   //
316   function disqualifyBid(address _from) public ownerOnly duringAuction {
317     secretBids[_from].disqualified = true;
318   }
319 
320 
321   //
322   // execute a bid.
323   // * purchases tokens if the specified price is above the strike price
324   // * refunds whatever remains of the deposit
325   //
326   // call only during the sale period (strikePrice > 0)
327   //
328   function executeBid(uint256 _secret, uint256 _price, uint256 _quantity) public duringSale {
329     executeBidFor(msg.sender, _secret, _price, _quantity);
330   }
331   function executeBidFor(address _addr, uint256 _secret, uint256 _price, uint256 _quantity) public duringSale {
332     bytes32 computedHash = keccak256(_secret, _price, _quantity);
333     //MessageBytes32Event("computedHash", computedHash);
334     require(secretBids[_addr].hash == computedHash);
335     //
336     if (secretBids[_addr].deposit > 0) {
337       uint _cost = 0;
338       uint _refund = 0;
339       uint _priceWei = safeMul(_price, 1 szabo);
340       if (_priceWei >= strikePrice && !secretBids[_addr].disqualified) {
341         uint256 _purchaseCount = (_priceWei > strikePrice) ? _quantity : (safeMul(strikePricePctX10, _quantity) / 1000);
342         var _maxPurchase = token.balanceOf(this) - developerReserve;
343         if (_purchaseCount > _maxPurchase)
344           _purchaseCount = _maxPurchase;
345         _cost = safeMul(_purchaseCount, strikePrice);
346         if (secretBids[_addr].deposit >= _cost) {
347           secretBids[_addr].deposit -= _cost;
348           proceeds = safeAdd(proceeds, _cost);
349           secretBids[_addr].tokens += _purchaseCount;
350           purchasedCount += _purchaseCount;
351           //transfer tokens to this bidder
352           if (!token.transfer(_addr, _purchaseCount))
353             revert();
354         }
355       }
356       //refund whatever remains
357       //use pull here, to prevent any bidder from reverting their purchase
358       if (secretBids[_addr].deposit > 0) {
359         _refund = secretBids[_addr].deposit;
360         secretBids[_addr].refund += _refund;
361         secretBids[_addr].deposit = 0;
362       }
363       executedCount += 1;
364       uint _batch = executedCount / batchSize;
365       ExecuteEvent(_batch, _addr, _cost, _refund);
366     }
367   }
368 
369 
370   //
371   // expireBid
372   // if a bid is not executed during the sale period, then the owner can mark the bid as expired. in this case:
373   // * the bidder gets a refund of half of his deposit
374   // * the bidder forfeits the other half of his deposit
375   // * the bidder does not receive an tokens
376   //
377   function expireBid(address _addr) public ownerOnly afterSale {
378     if (secretBids[_addr].deposit > 0) {
379       uint _forfeit = secretBids[_addr].deposit / 2;
380       proceeds = safeAdd(proceeds, _forfeit);
381       //refund whatever remains
382       uint _refund = safeSub(secretBids[_addr].deposit, _forfeit);
383       //use pull here, to prevent any bidder from reverting the expire
384       secretBids[msg.sender].refund += _refund;
385       secretBids[_addr].deposit = 0;
386       expiredCount += 1;
387       uint _batch = expiredCount / batchSize;
388       ExpireEvent(_batch, _addr, _forfeit, _refund);
389     }
390   }
391 
392 
393   //
394   // bidder withdraw excess funds (or all funds if bid was too low)
395   //
396   function withdrawRefund() public {
397     uint _amount = secretBids[msg.sender].refund;
398     secretBids[msg.sender].refund = 0;
399     msg.sender.transfer(_amount);
400   }
401 
402 
403   //
404   // grant developer tokens, equal to a percentage of purchased tokens.
405   // once called, any remaining tokens will be burned.
406   //
407   function doDeveloperGrant() public afterSale {
408     uint _quantity = purchasedCount * developerPctX10 / 1000;
409     var _tokensLeft = token.balanceOf(this);
410     if (_quantity > _tokensLeft)
411       _quantity = _tokensLeft;
412     if (_quantity > 0) {
413       //transfer pct tokens to developers
414       _tokensLeft -= _quantity;
415       if (!token.transfer(developers, _quantity))
416         revert();
417     }
418     //and burn everthing that remains
419     token.unPaidBurnTokens(_tokensLeft);
420   }
421 
422 
423   //
424   // pay auction proceeds to the underwriter
425   // may be called by underwriter or owner (fbo underwriter)
426   //
427   function payUnderwriter() public {
428     require(msg.sender == owner || msg.sender == underwriter);
429     uint _amount = proceeds;
430     proceeds = 0;
431     if (!underwriter.call.gas(contractSendGas).value(_amount)())
432       revert();
433   }
434 
435 
436   //for debug
437   //only available before the contract is locked
438   function haraKiri() ownerOnly unlockedOnly {
439     selfdestruct(owner);
440   }
441 }