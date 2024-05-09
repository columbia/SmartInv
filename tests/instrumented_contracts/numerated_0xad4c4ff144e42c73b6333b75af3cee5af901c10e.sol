1 pragma solidity ^0.4.18;
2 
3 /**
4  *
5  * @author  <newtwist@protonmail.com>
6  *
7  * Version F
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
55 pragma solidity ^0.4.15;
56 
57 //Burnable Token interface
58 
59 pragma solidity ^0.4.15;
60 
61 // Token standard API
62 // https://github.com/ethereum/EIPs/issues/20
63 
64 contract iERC20Token {
65   function totalSupply() public constant returns (uint supply);
66   function balanceOf( address who ) public constant returns (uint value);
67   function allowance( address owner, address spender ) public constant returns (uint remaining);
68 
69   function transfer( address to, uint value) public returns (bool ok);
70   function transferFrom( address from, address to, uint value) public returns (bool ok);
71   function approve( address spender, uint value ) public returns (bool ok);
72 
73   event Transfer( address indexed from, address indexed to, uint value);
74   event Approval( address indexed owner, address indexed spender, uint value);
75 }
76 
77 contract iBurnableToken is iERC20Token {
78   function burnTokens(uint _burnCount) public;
79   function unPaidBurnTokens(uint _burnCount) public;
80 }
81 
82 //import './SafeMath.sol';
83 pragma solidity ^0.4.11;
84 
85 /*
86     Overflow protected math functions
87 */
88 contract SafeMath {
89     /**
90         constructor
91     */
92     function SafeMath() public {
93     }
94 
95     /**
96         @dev returns the sum of _x and _y, asserts if the calculation overflows
97 
98         @param _x   value 1
99         @param _y   value 2
100 
101         @return sum
102     */
103     function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
104         uint256 z = _x + _y;
105         assert(z >= _x);
106         return z;
107     }
108 
109     /**
110         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
111 
112         @param _x   minuend
113         @param _y   subtrahend
114 
115         @return difference
116     */
117     function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
118         assert(_x >= _y);
119         return _x - _y;
120     }
121 
122     /**
123         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
124 
125         @param _x   factor 1
126         @param _y   factor 2
127 
128         @return product
129     */
130     function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
131         uint256 z = _x * _y;
132         assert(_x == 0 || z / _x == _y);
133         return z;
134     }
135 }
136 
137 
138 contract TokenAuction is SafeMath {
139 
140   struct SecretBid {
141     bool disqualified;     // flag set if hash does not match encrypted bid
142     uint deposit;          // funds deposited by bidder
143     uint refund;           // funds to be returned to bidder
144     uint tokens;           // structure has been allocated
145     bytes32 hash;          // hash of price, quantity, secret
146   }
147   uint constant  AUCTION_START_EVENT = 0x01;
148   uint constant  AUCTION_END_EVENT   = 0x02;
149   uint constant  SALE_START_EVENT    = 0x04;
150   uint constant  SALE_END_EVENT      = 0x08;
151 
152   event SecretBidEvent(uint indexed batch, address indexed bidder, uint deposit, bytes32 hash, bytes message);
153   event ExecuteEvent(uint indexed batch, address indexed bidder, uint cost, uint refund);
154   event ExpireEvent(uint indexed batch, address indexed bidder, uint cost, uint refund);
155   event BizarreEvent(address indexed addr, string message, uint val);
156   event StateChangeEvent(uint mask);
157   //
158   //event MessageEvent(string message);
159   //event MessageUintEvent(string message, uint val);
160   //event MessageAddrEvent(string message, address val);
161   //event MessageBytes32Event(string message, bytes32 val);
162 
163   bool public isLocked;
164   uint public stateMask;
165   address public owner;
166   address public developers;
167   address public underwriter;
168   iBurnableToken public token;
169   uint public proceeds;
170   uint public strikePrice;
171   uint public strikePricePctX10;
172   uint public decimalMultiplier;
173   uint public developerReserve;
174   uint public developerPctX10K;
175   uint public purchasedCount;
176   uint public secretBidCount;
177   uint public executedCount;
178   uint public expiredCount;
179   uint public saleDuration;
180   uint public auctionStart;
181   uint public auctionEnd;
182   uint public saleEnd;
183   mapping (address => SecretBid) public secretBids;
184 
185   //
186   //tunables
187   uint batchSize = 4;
188   uint contractSendGas = 100000;
189 
190   modifier ownerOnly {
191     require(msg.sender == owner);
192     _;
193   }
194 
195   modifier unlockedOnly {
196     require(!isLocked);
197     _;
198   }
199 
200   modifier duringAuction {
201     require((stateMask & (AUCTION_START_EVENT | AUCTION_END_EVENT)) == AUCTION_START_EVENT);
202     _;
203   }
204 
205   modifier afterAuction {
206     require((stateMask & AUCTION_END_EVENT) != 0);
207     _;
208   }
209 
210   modifier duringSale {
211     require((stateMask & (SALE_START_EVENT | SALE_END_EVENT)) == SALE_START_EVENT);
212     _;
213   }
214 
215   modifier afterSale {
216     require((stateMask & SALE_END_EVENT) != 0);
217     _;
218   }
219 
220 
221   //
222   //constructor
223   //
224   function TokenAuction() public {
225     owner = msg.sender;
226   }
227 
228   function lock() public ownerOnly {
229     isLocked = true;
230   }
231 
232   function setToken(iBurnableToken _token, uint _decimalMultiplier, address _underwriter) public ownerOnly unlockedOnly {
233     token = _token;
234     decimalMultiplier = _decimalMultiplier;
235     underwriter = _underwriter;
236   }
237 
238   function setAuctionParms(uint _auctionStart, uint _auctionDuration, uint _saleDuration) public ownerOnly unlockedOnly {
239     auctionStart = _auctionStart;
240     auctionEnd = safeAdd(_auctionStart, _auctionDuration);
241     saleDuration = _saleDuration;
242     if (stateMask != 0) {
243       //handy for debug
244       stateMask = 0;
245       strikePrice = 0;
246       executedCount = 0;
247       houseKeep();
248     }
249   }
250 
251 
252   function reserveDeveloperTokens(address _developers, uint _developerPctX10K) public ownerOnly unlockedOnly {
253     developers = _developers;
254     developerPctX10K = _developerPctX10K;
255     uint _tokenCount = token.balanceOf(this);
256     developerReserve = safeMul(_tokenCount, developerPctX10K) / 1000000;
257   }
258 
259   function tune(uint _batchSize, uint _contractSendGas) public ownerOnly {
260     batchSize = _batchSize;
261     contractSendGas = _contractSendGas;
262   }
263 
264 
265   //
266   //called by owner (or any other concerned party) to generate a SatateChangeEvent
267   //
268   function houseKeep() public {
269     uint _oldMask = stateMask;
270     if (now >= auctionStart) {
271       stateMask |= AUCTION_START_EVENT;
272       if (now >= auctionEnd) {
273         stateMask |= AUCTION_END_EVENT;
274         if (strikePrice > 0) {
275           stateMask |= SALE_START_EVENT;
276           if (now >= saleEnd)
277             stateMask |= SALE_END_EVENT;
278         }
279       }
280     }
281     if (stateMask != _oldMask)
282       StateChangeEvent(stateMask);
283   }
284 
285 
286 
287   //
288   // setting the strike price starts the sale period, during which bidders must call executeBid.
289   // the strike price should only be set once.... at any rate it cannot be changed once anyone has executed a bid.
290   // strikePricePctX10 specifies what percentage (x10) of requested tokens should be awarded to each bidder that
291   // bid exactly equal to the strike price.
292   //
293   // note: strikePrice is the price of whole tokens (in wei)
294   //
295   function setStrikePrice(uint _strikePrice, uint _strikePricePctX10) public ownerOnly afterAuction {
296     require(executedCount == 0);
297     strikePrice = _strikePrice;
298     strikePricePctX10 = _strikePricePctX10;
299     saleEnd = safeAdd(now, saleDuration);
300     houseKeep();
301   }
302 
303 
304   //
305   // nobody should be sending funds via this function.... bizarre...
306   // the fact that we adjust proceeds here means that this fcn will OOG if called with a send or transfer. that's
307   // probably good, cuz it prevents the caller from losing their funds.
308   //
309   function () public payable {
310     proceeds = safeAdd(proceeds, msg.value);
311     BizarreEvent(msg.sender, "bizarre payment", msg.value);
312   }
313 
314 
315   function depositSecretBid(bytes32 _hash, bytes _message) public duringAuction payable {
316     //each address can only submit one bid -- and once a bid is submitted it is imutable
317     //for testing, an exception is made for the owner -- but only while the contract is unlocked
318     if (!(msg.sender == owner && !isLocked) &&
319          (_hash == 0 || secretBids[msg.sender].hash != 0) )
320         revert();
321     secretBids[msg.sender].hash = _hash;
322     secretBids[msg.sender].deposit = msg.value;
323     secretBidCount += 1;
324     uint _batch = secretBidCount / batchSize;
325     SecretBidEvent(_batch, msg.sender, msg.value, _hash, _message);
326   }
327 
328 
329   //
330   // the owner may disqualify a bid if it is bogus. for example if the hash does not correspond
331   // to the hash that is generated from the encyrpted bid tuple. when a disqualified bid is
332   // executed all the deposited funds will be returned to the bidder, as if the bid was below
333   // the strike-price.
334   //
335   function disqualifyBid(address _from) public ownerOnly duringAuction {
336     secretBids[_from].disqualified = true;
337   }
338 
339 
340   //
341   // execute a bid.
342   // * purchases tokens if the specified price is above the strike price
343   // * refunds whatever remains of the deposit
344   //
345   // call only during the sale period (strikePrice > 0)
346   // note: _quantity is the number of whole tokens; that is low-level-tokens * decimalMultiplier
347   // similarly _price is the price of whole tokens; that is low-level-token price / decimalMultiplier
348   //
349   function executeBid(uint256 _secret, uint256 _price, uint256 _quantity) public duringSale {
350     executeBidFor(msg.sender, _secret, _price, _quantity);
351   }
352   function executeBidFor(address _addr, uint256 _secret, uint256 _price, uint256 _quantity) public duringSale {
353     bytes32 computedHash = keccak256(_secret, _price, _quantity);
354     //MessageBytes32Event("computedHash", computedHash);
355     require(secretBids[_addr].hash == computedHash);
356     //
357     if (secretBids[_addr].deposit > 0) {
358       uint _cost = 0;
359       uint _refund = 0;
360       uint _priceWei = safeMul(_price, 1 szabo);
361       if (_priceWei >= strikePrice && !secretBids[_addr].disqualified) {
362          //up till now all prices and quantities and referred to whole tokens (including strike price); now that we are about
363          //to actually do the transfer, convert to low-level tokens
364          uint _lowLevelQuantity = safeMul(_quantity, decimalMultiplier);
365          uint _lowLevelPrice = strikePrice / decimalMultiplier;
366          uint256 _purchaseCount = (_priceWei > strikePrice) ? _lowLevelQuantity : (safeMul(strikePricePctX10, _lowLevelQuantity) / 1000);
367          var _maxPurchase = token.balanceOf(this) - developerReserve;
368          if (_purchaseCount > _maxPurchase)
369            _purchaseCount = _maxPurchase;
370          _cost = safeMul(_purchaseCount, _lowLevelPrice);
371          if (secretBids[_addr].deposit >= _cost) {
372            secretBids[_addr].deposit -= _cost;
373            proceeds = safeAdd(proceeds, _cost);
374            secretBids[_addr].tokens += _purchaseCount;
375            purchasedCount += _purchaseCount;
376            //transfer tokens to this bidder
377            if (!token.transfer(_addr, _purchaseCount))
378              revert();
379          }
380       }
381       //refund whatever remains
382       //use pull here, to prevent any bidder from reverting their purchase
383       if (secretBids[_addr].deposit > 0) {
384         _refund = secretBids[_addr].deposit;
385         secretBids[_addr].refund += _refund;
386         secretBids[_addr].deposit = 0;
387       }
388       executedCount += 1;
389       uint _batch = executedCount / batchSize;
390       ExecuteEvent(_batch, _addr, _cost, _refund);
391     }
392   }
393 
394 
395   //
396   // expireBid
397   // if a bid is not executed during the sale period, then the owner can mark the bid as expired. in this case:
398   // * the bidder gets a refund of half of his deposit
399   // * the bidder forfeits the other half of his deposit
400   // * the bidder does not receive an tokens
401   //
402   function expireBid(address _addr) public ownerOnly afterSale {
403     if (secretBids[_addr].deposit > 0) {
404       uint _forfeit = secretBids[_addr].deposit / 2;
405       proceeds = safeAdd(proceeds, _forfeit);
406       //refund whatever remains
407       uint _refund = safeSub(secretBids[_addr].deposit, _forfeit);
408       //use pull here, to prevent any bidder from reverting the expire
409       secretBids[msg.sender].refund += _refund;
410       secretBids[_addr].deposit = 0;
411       expiredCount += 1;
412       uint _batch = expiredCount / batchSize;
413       ExpireEvent(_batch, _addr, _forfeit, _refund);
414     }
415   }
416 
417 
418   //
419   // bidder withdraw excess funds (or all funds if bid was too low)
420   //
421   function withdrawRefund() public {
422     uint _amount = secretBids[msg.sender].refund;
423     secretBids[msg.sender].refund = 0;
424     msg.sender.transfer(_amount);
425   }
426 
427 
428   //
429   // grant developer tokens, equal to a percentage of purchased tokens.
430   // once called, any remaining tokens will be burned.
431   //
432   function doDeveloperGrant() public afterSale {
433     uint _quantity = safeMul(purchasedCount, developerPctX10K) / 1000000;
434     uint _tokensLeft = token.balanceOf(this);
435     if (_quantity > _tokensLeft)
436       _quantity = _tokensLeft;
437     if (_quantity > 0) {
438       //transfer pct tokens to developers
439       _tokensLeft -= _quantity;
440       if (!token.transfer(developers, _quantity))
441         revert();
442     }
443     //and burn everthing that remains
444     token.unPaidBurnTokens(_tokensLeft);
445   }
446 
447 
448   //
449   // pay auction proceeds to the underwriter
450   // may be called by underwriter or owner (fbo underwriter)
451   //
452   function payUnderwriter() public {
453     require(msg.sender == owner || msg.sender == underwriter);
454     uint _amount = proceeds;
455     proceeds = 0;
456     if (!underwriter.call.gas(contractSendGas).value(_amount)())
457       revert();
458   }
459 
460 
461   //for debug
462   //only available before the contract is locked
463   function haraKiri() public ownerOnly unlockedOnly {
464     selfdestruct(owner);
465   }
466 }