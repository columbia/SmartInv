1 pragma solidity ^0.4.18;
2 
3 /**
4  *
5  * @author  <newtwist@protonmail.com>
6  *
7  * Version G
8  *
9  * Overview:
10  * This contract implements a blind auction for burnable tokens. Each secret bid consists
11  * of a hashed bid-tuple, (`price`, `quantity`, `salt`), where price is the maximum amount
12  * of ether (in szabo) a user is willing to pay per token, quantity is the number of tokens
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
36  * each time a new bid is included; but the token price is reduced. At each step the total
37  * raise (token-price times quantity-of-tokens-sold) is computed. And the process ends
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
49  * This rule was adopted (as opposed to refunding un-revealed bids) to prevent users from placing
50  * several bids, and only revealing one of them. With this rule, all bids must be executed.
51  *
52  */
53 
54 
55 //import './iBurnableToken.sol';
56 pragma solidity ^0.4.15;
57 
58 //Burnable Token interface
59 
60 //import './iERC20Token.sol';
61 pragma solidity ^0.4.15;
62 
63 // Token standard API
64 // https://github.com/ethereum/EIPs/issues/20
65 
66 contract iERC20Token {
67   function totalSupply() public constant returns (uint supply);
68   function balanceOf( address who ) public constant returns (uint value);
69   function allowance( address owner, address spender ) public constant returns (uint remaining);
70 
71   function transfer( address to, uint value) public returns (bool ok);
72   function transferFrom( address from, address to, uint value) public returns (bool ok);
73   function approve( address spender, uint value ) public returns (bool ok);
74 
75   event Transfer( address indexed from, address indexed to, uint value);
76   event Approval( address indexed owner, address indexed spender, uint value);
77 }
78 
79 contract iBurnableToken is iERC20Token {
80   function burnTokens(uint _burnCount) public;
81   function unPaidBurnTokens(uint _burnCount) public;
82 }
83 
84 //import './SafeMath.sol';
85 pragma solidity ^0.4.11;
86 
87 /*
88     Overflow protected math functions
89 */
90 contract SafeMath {
91     /**
92         constructor
93     */
94     function SafeMath() public {
95     }
96 
97     /**
98         @dev returns the sum of _x and _y, asserts if the calculation overflows
99 
100         @param _x   value 1
101         @param _y   value 2
102 
103         @return sum
104     */
105     function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
106         uint256 z = _x + _y;
107         assert(z >= _x);
108         return z;
109     }
110 
111     /**
112         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
113 
114         @param _x   minuend
115         @param _y   subtrahend
116 
117         @return difference
118     */
119     function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
120         assert(_x >= _y);
121         return _x - _y;
122     }
123 
124     /**
125         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
126 
127         @param _x   factor 1
128         @param _y   factor 2
129 
130         @return product
131     */
132     function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
133         uint256 z = _x * _y;
134         assert(_x == 0 || z / _x == _y);
135         return z;
136     }
137 }
138 
139 
140 contract TokenAuction is SafeMath {
141 
142   struct SecretBid {
143     bool disqualified;     // flag set if hash does not match encrypted bid
144     uint deposit;          // funds deposited by bidder
145     uint refund;           // funds to be returned to bidder
146     uint tokens;           // structure has been allocated
147     bytes32 hash;          // hash of price, quantity, secret
148   }
149   uint constant  AUCTION_START_EVENT = 0x01;
150   uint constant  AUCTION_END_EVENT   = 0x02;
151   uint constant  SALE_START_EVENT    = 0x04;
152   uint constant  SALE_END_EVENT      = 0x08;
153 
154   event SecretBidEvent(uint indexed batch, address indexed bidder, uint deposit, bytes32 hash, bytes message);
155   event ExecuteEvent(uint indexed batch, address indexed bidder, uint cost, uint refund);
156   event ExpireEvent(uint indexed batch, address indexed bidder, uint cost, uint refund);
157   event BizarreEvent(address indexed addr, string message, uint val);
158   event BidDisqualifiedEvent(address indexed bidder, bytes32 hash);
159   event StateChangeEvent(uint mask);
160   //
161   //event MessageEvent(string message);
162   //event MessageUintEvent(string message, uint val);
163   //event MessageAddrEvent(string message, address val);
164   //event MessageBytes32Event(string message, bytes32 val);
165 
166   bool public isLocked;
167   uint public stateMask;
168   address public owner;
169   address public developers;
170   address public underwriter;
171   iBurnableToken public token;
172   uint public proceeds;
173   uint public strikePrice;
174   uint public strikePricePctX10;
175   uint public decimalMultiplier;
176   uint public developerReserve;
177   uint public developerPctX10K;
178   uint public purchasedCount;
179   uint public secretBidCount;
180   uint public executedCount;
181   uint public expiredCount;
182   uint public saleDuration;
183   uint public auctionStart;
184   uint public auctionEnd;
185   uint public saleEnd;
186   mapping (address => SecretBid) public secretBids;
187 
188   //
189   //tunables
190   uint batchSize = 4;
191   uint contractSendGas = 100000;
192 
193   modifier ownerOnly {
194     require(msg.sender == owner);
195     _;
196   }
197 
198   modifier unlockedOnly {
199     require(!isLocked);
200     _;
201   }
202 
203   modifier duringAuction {
204     require((stateMask & (AUCTION_START_EVENT | AUCTION_END_EVENT)) == AUCTION_START_EVENT);
205     _;
206   }
207 
208   modifier afterAuction {
209     require((stateMask & AUCTION_END_EVENT) != 0);
210     _;
211   }
212 
213   modifier duringSale {
214     require((stateMask & (SALE_START_EVENT | SALE_END_EVENT)) == SALE_START_EVENT);
215     _;
216   }
217 
218   modifier afterSale {
219     require((stateMask & SALE_END_EVENT) != 0);
220     _;
221   }
222 
223 
224   //
225   //constructor
226   //
227   function TokenAuction() public {
228     owner = msg.sender;
229   }
230 
231   function lock() public ownerOnly {
232     isLocked = true;
233   }
234 
235   function setToken(iBurnableToken _token, uint _decimalMultiplier, address _underwriter) public ownerOnly unlockedOnly {
236     token = _token;
237     decimalMultiplier = _decimalMultiplier;
238     underwriter = _underwriter;
239   }
240 
241   function setAuctionParms(uint _auctionStart, uint _auctionDuration, uint _saleDuration) public ownerOnly unlockedOnly {
242     auctionStart = _auctionStart;
243     auctionEnd = safeAdd(_auctionStart, _auctionDuration);
244     saleDuration = _saleDuration;
245     if (stateMask != 0) {
246       //handy for debug
247       stateMask = 0;
248       strikePrice = 0;
249       executedCount = 0;
250       houseKeep();
251     }
252   }
253 
254 
255   function reserveDeveloperTokens(address _developers, uint _developerPctX10K) public ownerOnly unlockedOnly {
256     require(developerPctX10K < 1000000);
257     developers = _developers;
258     developerPctX10K = _developerPctX10K;
259     uint _tokenCount = token.balanceOf(this);
260     developerReserve = safeMul(_tokenCount, developerPctX10K) / 1000000;
261   }
262 
263   function tune(uint _batchSize, uint _contractSendGas) public ownerOnly {
264     batchSize = _batchSize;
265     contractSendGas = _contractSendGas;
266   }
267 
268 
269   //
270   //called by owner (or any other concerned party) to generate a SatateChangeEvent
271   //
272   function houseKeep() public {
273     uint _oldMask = stateMask;
274     if (now >= auctionStart) {
275       stateMask |= AUCTION_START_EVENT;
276       if (now >= auctionEnd) {
277         stateMask |= AUCTION_END_EVENT;
278         if (strikePrice > 0) {
279           stateMask |= SALE_START_EVENT;
280           if (now >= saleEnd)
281             stateMask |= SALE_END_EVENT;
282         }
283       }
284     }
285     if (stateMask != _oldMask)
286       StateChangeEvent(stateMask);
287   }
288 
289 
290 
291   //
292   // setting the strike price starts the sale period, during which bidders must call executeBid.
293   // the strike price should only be set once.... at any rate it cannot be changed once anyone has executed a bid.
294   // strikePricePctX10 specifies what percentage (x10) of requested tokens should be awarded to each bidder that
295   // bid exactly equal to the strike price.
296   //
297   // note: strikePrice is the price of whole tokens (in wei)
298   //
299   function setStrikePrice(uint _strikePrice, uint _strikePricePctX10) public ownerOnly afterAuction {
300     require(executedCount == 0);
301     strikePrice = _strikePrice;
302     strikePricePctX10 = _strikePricePctX10;
303     saleEnd = safeAdd(now, saleDuration);
304     houseKeep();
305   }
306 
307 
308   //
309   // nobody should be sending funds via this function.... bizarre...
310   // the fact that we adjust proceeds here means that this fcn will OOG if called with a send or transfer. that's
311   // probably good, cuz it prevents the caller from losing their funds.
312   //
313   function () public payable {
314     proceeds = safeAdd(proceeds, msg.value);
315     BizarreEvent(msg.sender, "bizarre payment", msg.value);
316   }
317 
318 
319   function depositSecretBid(bytes32 _hash, bytes _message) public duringAuction payable {
320     //each address can only submit one bid -- and once a bid is submitted it is imutable
321     //for testing, an exception is made for the owner -- but only while the contract is unlocked
322     if (!(msg.sender == owner && !isLocked) &&
323          (_hash == 0 || secretBids[msg.sender].hash != 0) )
324         revert();
325     secretBids[msg.sender].hash = _hash;
326     secretBids[msg.sender].deposit = msg.value;
327     secretBids[msg.sender].disqualified = false;
328     secretBidCount += 1;
329     uint _batch = secretBidCount / batchSize;
330     SecretBidEvent(_batch, msg.sender, msg.value, _hash, _message);
331   }
332 
333 
334   //
335   // the owner may disqualify a bid if it is bogus. for example if the hash does not correspond
336   // to the hash that is generated from the encyrpted bid tuple. when a disqualified bid is
337   // executed all the deposited funds will be returned to the bidder, as if the bid was below
338   // the strike-price.
339   //
340   function disqualifyBid(address _from, bool _doRefund) public ownerOnly duringAuction {
341     secretBids[_from].disqualified = true;
342     BidDisqualifiedEvent(_from, secretBids[_from].hash);
343     if (_doRefund == true) {
344       uint _amount = secretBids[_from].deposit;
345       secretBids[_from].hash = bytes32(0);
346       secretBids[_from].deposit = 0;
347       secretBidCount = safeSub(secretBidCount, 1);
348       if (_amount > 0)
349         _from.transfer(_amount);
350     }
351   }
352 
353 
354   //
355   // execute a bid.
356   // * purchases tokens if the specified price is above the strike price
357   // * refunds whatever remains of the deposit
358   //
359   // call only during the sale period (strikePrice > 0)
360   // note: _quantity is the number of whole tokens; that is low-level-tokens * decimalMultiplier
361   // similarly _price is the price of whole tokens; that is low-level-token price / decimalMultiplier
362   //
363   function executeBid(uint256 _secret, uint256 _price, uint256 _quantity) public duringSale {
364     executeBidFor(msg.sender, _secret, _price, _quantity);
365   }
366   function executeBidFor(address _addr, uint256 _secret, uint256 _price, uint256 _quantity) public duringSale {
367     bytes32 computedHash = keccak256(_secret, _price, _quantity);
368     //MessageBytes32Event("computedHash", computedHash);
369     require(secretBids[_addr].hash == computedHash);
370     //
371     if (secretBids[_addr].deposit > 0) {
372       uint _cost = 0;
373       uint _refund = 0;
374       uint _priceWei = safeMul(_price, 1 szabo);
375       if (_priceWei >= strikePrice && !secretBids[_addr].disqualified) {
376          //up till now all prices and quantities and referred to whole tokens (including strike price); now that we are about
377          //to actually do the transfer, convert to low-level tokens
378          uint _lowLevelQuantity = safeMul(_quantity, decimalMultiplier);
379          uint _lowLevelPrice = strikePrice / decimalMultiplier;
380          uint256 _purchaseCount = (_priceWei > strikePrice) ? _lowLevelQuantity : (safeMul(strikePricePctX10, _lowLevelQuantity) / 1000);
381          var _maxPurchase = safeSub(token.balanceOf(this), developerReserve);
382          if (_purchaseCount > _maxPurchase)
383            _purchaseCount = _maxPurchase;
384          _cost = safeMul(_purchaseCount, _lowLevelPrice);
385          if (secretBids[_addr].deposit >= _cost) {
386            secretBids[_addr].deposit -= _cost;
387            proceeds = safeAdd(proceeds, _cost);
388            secretBids[_addr].tokens += _purchaseCount;
389            purchasedCount += _purchaseCount;
390            //transfer tokens to this bidder
391            if (!token.transfer(_addr, _purchaseCount))
392              revert();
393          }
394       }
395       //refund whatever remains
396       //use pull here, to prevent any bidder from reverting their purchase
397       if (secretBids[_addr].deposit > 0) {
398         _refund = secretBids[_addr].deposit;
399         secretBids[_addr].refund += _refund;
400         secretBids[_addr].deposit = 0;
401       }
402       executedCount += 1;
403       uint _batch = executedCount / batchSize;
404       ExecuteEvent(_batch, _addr, _cost, _refund);
405     }
406   }
407 
408 
409   //
410   // expireBid
411   // if a bid is not executed during the sale period, then the owner can mark the bid as expired. in this case:
412   // * the bidder gets a refund of half of his deposit
413   // * the bidder forfeits the other half of his deposit
414   // * the bidder does not receive an tokens
415   //
416   function expireBid(address _addr) public ownerOnly afterSale {
417     if (secretBids[_addr].deposit > 0) {
418       uint _forfeit = secretBids[_addr].deposit / 2;
419       proceeds = safeAdd(proceeds, _forfeit);
420       //refund whatever remains
421       uint _refund = safeSub(secretBids[_addr].deposit, _forfeit);
422       //use pull here, to prevent any bidder from reverting the expire
423       secretBids[msg.sender].refund += _refund;
424       secretBids[_addr].deposit = 0;
425       expiredCount += 1;
426       uint _batch = expiredCount / batchSize;
427       ExpireEvent(_batch, _addr, _forfeit, _refund);
428     }
429   }
430 
431 
432   //
433   // bidder withdraw excess funds (or all funds if bid was too low)
434   //
435   function withdrawRefund() public {
436     uint _amount = secretBids[msg.sender].refund;
437     secretBids[msg.sender].refund = 0;
438     msg.sender.transfer(_amount);
439   }
440 
441 
442   //
443   // grant developer tokens, equal to a percentage of purchased tokens.
444   // once called, any remaining tokens will be burned.
445   //
446   function doDeveloperGrant() public afterSale {
447     uint _quantity = safeMul(purchasedCount, developerPctX10K) / 1000000;
448     uint _tokensLeft = token.balanceOf(this);
449     if (_quantity > _tokensLeft)
450       _quantity = _tokensLeft;
451     if (_quantity > 0) {
452       //transfer pct tokens to developers
453       _tokensLeft -= _quantity;
454       if (!token.transfer(developers, _quantity))
455         revert();
456     }
457     //and burn everthing that remains
458     token.unPaidBurnTokens(_tokensLeft);
459   }
460 
461 
462   //
463   // pay auction proceeds to the underwriter
464   // may be called by underwriter or owner (fbo underwriter)
465   //
466   function payUnderwriter() public {
467     require(msg.sender == owner || msg.sender == underwriter);
468     uint _amount = proceeds;
469     proceeds = 0;
470     if (!underwriter.call.gas(contractSendGas).value(_amount)())
471       revert();
472   }
473 
474 
475   //for debug
476   //only available before the contract is locked
477   function haraKiri() public ownerOnly unlockedOnly {
478     selfdestruct(owner);
479   }
480 }