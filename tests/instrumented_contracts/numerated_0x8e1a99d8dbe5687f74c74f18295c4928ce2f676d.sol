1 pragma solidity ^0.4.15;
2 
3 /**
4  *
5  * @author  David Rosen <kaandoit@mcon.org>
6  *
7  * Version Test-D
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
53 
54 // Token standard API
55 // https://github.com/ethereum/EIPs/issues/20
56 
57 contract iERC20Token {
58   function totalSupply() constant returns (uint supply);
59   function balanceOf( address who ) constant returns (uint value);
60   function allowance( address owner, address spender ) constant returns (uint remaining);
61 
62   function transfer( address to, uint value) returns (bool ok);
63   function transferFrom( address from, address to, uint value) returns (bool ok);
64   function approve( address spender, uint value ) returns (bool ok);
65 
66   event Transfer( address indexed from, address indexed to, uint value);
67   event Approval( address indexed owner, address indexed spender, uint value);
68 }
69 
70 //Burnable Token interface
71 
72 contract iBurnableToken is iERC20Token {
73   function burnTokens(uint _burnCount) public;
74   function unPaidBurnTokens(uint _burnCount) public;
75 }
76 
77 
78 /*
79     Overflow protected math functions
80 */
81 contract SafeMath {
82     /**
83         constructor
84     */
85     function SafeMath() {
86     }
87 
88     /**
89         @dev returns the sum of _x and _y, asserts if the calculation overflows
90 
91         @param _x   value 1
92         @param _y   value 2
93 
94         @return sum
95     */
96     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
97         uint256 z = _x + _y;
98         assert(z >= _x);
99         return z;
100     }
101 
102     /**
103         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
104 
105         @param _x   minuend
106         @param _y   subtrahend
107 
108         @return difference
109     */
110     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
111         assert(_x >= _y);
112         return _x - _y;
113     }
114 
115     /**
116         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
117 
118         @param _x   factor 1
119         @param _y   factor 2
120 
121         @return product
122     */
123     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
124         uint256 z = _x * _y;
125         assert(_x == 0 || z / _x == _y);
126         return z;
127     }
128 }
129 
130 contract TokenAuction is SafeMath {
131 
132   struct SecretBid {
133     bool disqualified;     // flag set if hash does not match encrypted bid
134     uint deposit;          // funds deposited by bidder
135     uint refund;           // funds to be returned to bidder
136     uint tokens;           // structure has been allocated
137     bytes32 hash;          // hash of price, quantity, secret
138   }
139   uint constant  AUCTION_START_EVENT = 0x01;
140   uint constant  AUCTION_END_EVENT   = 0x02;
141   uint constant  SALE_START_EVENT    = 0x04;
142   uint constant  SALE_END_EVENT      = 0x08;
143 
144   event SecretBidEvent(uint indexed batch, address indexed bidder, uint deposit, bytes32 hash, bytes message);
145   event ExecuteEvent(uint indexed batch, address indexed bidder, uint cost, uint refund);
146   event ExpireEvent(uint indexed batch, address indexed bidder, uint cost, uint refund);
147   event BizarreEvent(address indexed addr, string message, uint val);
148   event StateChangeEvent(uint mask);
149   //
150   //event MessageEvent(string message);
151   //event MessageUintEvent(string message, uint val);
152   //event MessageAddrEvent(string message, address val);
153   //event MessageBytes32Event(string message, bytes32 val);
154 
155   bool public isLocked;
156   uint public stateMask;
157   address public owner;
158   address public developers;
159   address public underwriter;
160   iBurnableToken public token;
161   uint public proceeds;
162   uint public strikePrice;
163   uint public strikePricePctX10;
164   uint public developerReserve;
165   uint public developerPctX10;
166   uint public purchasedCount;
167   uint public secretBidCount;
168   uint public executedCount;
169   uint public expiredCount;
170   uint public saleDuration;
171   uint public auctionStart;
172   uint public auctionEnd;
173   uint public saleEnd;
174   mapping (address => SecretBid) public secretBids;
175 
176   //
177   //tunables
178   uint batchSize = 4;
179   uint contractSendGas = 100000;
180 
181   modifier ownerOnly {
182     require(msg.sender == owner);
183     _;
184   }
185 
186   modifier unlockedOnly {
187     require(!isLocked);
188     _;
189   }
190 
191   modifier duringAuction {
192     require((stateMask & (AUCTION_START_EVENT | AUCTION_END_EVENT)) == AUCTION_START_EVENT);
193     _;
194   }
195 
196   modifier afterAuction {
197     require((stateMask & AUCTION_END_EVENT) != 0);
198     _;
199   }
200 
201   modifier duringSale {
202     require((stateMask & (SALE_START_EVENT | SALE_END_EVENT)) == SALE_START_EVENT);
203     _;
204   }
205 
206   modifier afterSale {
207     require((stateMask & SALE_END_EVENT) != 0);
208     _;
209   }
210 
211 
212   //
213   //constructor
214   //
215   function TokenAuction() {
216     owner = msg.sender;
217   }
218 
219   function lock() public ownerOnly {
220     isLocked = true;
221   }
222 
223   function setAuctionParms(iBurnableToken _token, address _underwriter, uint _auctionStart, uint _auctionDuration, uint _saleDuration) public ownerOnly unlockedOnly {
224     token = _token;
225     underwriter = _underwriter;
226     auctionStart = _auctionStart;
227     auctionEnd = safeAdd(_auctionStart, _auctionDuration);
228     saleDuration = _saleDuration;
229     if (stateMask != 0) {
230       //handy for debug
231       stateMask = 0;
232       strikePrice = 0;
233       purchasedCount = 0;
234       houseKeep();
235     }
236   }
237 
238   function reserveDeveloperTokens(address _developers, uint _developerPctX10) public ownerOnly unlockedOnly {
239     developers = _developers;
240     developerPctX10 = _developerPctX10;
241     uint _tokenCount = token.balanceOf(this);
242     developerReserve = (safeMul(_tokenCount, developerPctX10) / 1000);
243   }
244 
245   function tune(uint _batchSize, uint _contractSendGas) public ownerOnly {
246     batchSize = _batchSize;
247     contractSendGas = _contractSendGas;
248   }
249 
250 
251   //
252   //called by owner (or any other concerned party) to generate a SatateChangeEvent
253   //
254   function houseKeep() public {
255     uint _oldMask = stateMask;
256     if (now >= auctionStart) {
257       stateMask |= AUCTION_START_EVENT;
258       if (now >= auctionEnd) {
259         stateMask |= AUCTION_END_EVENT;
260         if (strikePrice > 0) {
261           stateMask |= SALE_START_EVENT;
262           if (now >= saleEnd)
263             stateMask |= SALE_END_EVENT;
264         }
265       }
266     }
267     if (stateMask != _oldMask)
268       StateChangeEvent(stateMask);
269   }
270 
271 
272 
273   //
274   //setting the strike price starts the sale period, during which bidders must call executeBid.
275   //the strike price should only be set once.... at any rate it cannot be changed once anyone has executed a bid.
276   //strikePricePctX10 specifies what percentage (x10) of requested tokens should be awarded to each bidder that
277   //bid exactly equal to the strike price.
278   //
279   function setStrikePrice(uint _strikePrice, uint _strikePricePctX10) public ownerOnly afterAuction {
280     require(executedCount == 0);
281     strikePrice = _strikePrice;
282     strikePricePctX10 = _strikePricePctX10;
283     saleEnd = safeAdd(now, saleDuration);
284     houseKeep();
285   }
286 
287 
288   //
289   // nobody should be sending funds via this function.... bizarre...
290   // the fact that we adjust proceeds here means that this fcn will OOG if called with a send or transfer. that's
291   // probably good, cuz it prevents the caller from losing their funds.
292   //
293   function () payable {
294     proceeds = safeAdd(proceeds, msg.value);
295     BizarreEvent(msg.sender, "bizarre payment", msg.value);
296   }
297 
298 
299   function depositSecretBid(bytes32 _hash, bytes _message) public duringAuction payable {
300     //each address can only submit one bid -- and once a bid is submitted it is imutable
301     //for testing, an exception is made for the owner -- but only while the contract is unlocked
302     if (!(msg.sender == owner && !isLocked) &&
303          (_hash == 0 || secretBids[msg.sender].hash != 0) )
304         revert();
305     secretBids[msg.sender].hash = _hash;
306     secretBids[msg.sender].deposit = msg.value;
307     secretBidCount += 1;
308     uint _batch = secretBidCount / batchSize;
309     SecretBidEvent(_batch, msg.sender, msg.value, _hash, _message);
310   }
311 
312 
313   //
314   // the owner may disqualify a bid if it is bogus. for example if the hash does not correspond
315   // to the hash that is generated from the encyrpted bid tuple. when a disqualified bid is
316   // executed all the deposited funds will be returned to the bidder, as if the bid was below
317   // the strike-price.
318   function disqualifyBid(address _from) public ownerOnly duringAuction {
319     secretBids[msg.sender].disqualified = true;
320   }
321 
322 
323   //
324   // execute a bid.
325   // * purchases tokens if the specified price is above the strike price
326   // * refunds whatever remains of the deposit
327   //
328   // call only during the sale period (strikePrice > 0)
329   //
330   function executeBid(uint256 _secret, uint256 _price, uint256 _quantity) public duringSale {
331     executeBidFor(msg.sender, _secret, _price, _quantity);
332   }
333   function executeBidFor(address _addr, uint256 _secret, uint256 _price, uint256 _quantity) public duringSale {
334     bytes32 computedHash = keccak256(_secret, _price, _quantity);
335     //MessageBytes32Event("computedHash", computedHash);
336     require(secretBids[_addr].hash == computedHash);
337     //
338     if (secretBids[_addr].deposit > 0) {
339       uint _cost = 0;
340       uint _refund = 0;
341       if (_price >= strikePrice && !secretBids[_addr].disqualified) {
342         uint256 _purchaseCount = (_price > strikePrice) ? _quantity : (safeMul(strikePricePctX10, _quantity) / 1000);
343         var _maxPurchase = token.balanceOf(this) - developerReserve;
344         if (_purchaseCount > _maxPurchase)
345           _purchaseCount = _maxPurchase;
346         _cost = safeMul(_purchaseCount, strikePrice);
347         if (secretBids[_addr].deposit >= _cost) {
348           secretBids[_addr].deposit -= _cost;
349           proceeds = safeAdd(proceeds, _cost);
350           secretBids[_addr].tokens += _purchaseCount;
351           purchasedCount += _purchaseCount;
352           //transfer tokens to this bidder
353           if (!token.transfer(_addr, _purchaseCount))
354             revert();
355         }
356       }
357       //refund whatever remains
358       //use pull here, to prevent any bidder from reverting their purchase
359       if (secretBids[_addr].deposit > 0) {
360         _refund = secretBids[_addr].deposit;
361         secretBids[_addr].refund += _refund;
362         secretBids[_addr].deposit = 0;
363       }
364       executedCount += 1;
365       uint _batch = executedCount / batchSize;
366       ExecuteEvent(_batch, _addr, _cost, _refund);
367     }
368   }
369 
370 
371   //
372   // expireBid
373   // if a bid is not executed during the sale period, then the owner can mark the bid as expired. in this case:
374   // * the bidder gets a refund of half of his deposit
375   // * the bidder forfeits the other half of his deposit
376   // * the bidder does not receive an tokens
377   //
378   function expireBid(address _addr) public ownerOnly afterSale {
379     if (secretBids[_addr].deposit > 0) {
380       uint _forfeit = secretBids[_addr].deposit / 2;
381       proceeds = safeAdd(proceeds, _forfeit);
382       //refund whatever remains
383       uint _refund = safeSub(secretBids[_addr].deposit, _forfeit);
384       //use pull here, to prevent any bidder from reverting the expire
385       secretBids[msg.sender].refund += _refund;
386       secretBids[_addr].deposit = 0;
387       expiredCount += 1;
388       uint _batch = expiredCount / batchSize;
389       ExpireEvent(_batch, _addr, _forfeit, _refund);
390     }
391   }
392 
393 
394   //
395   // bidder withdraw excess funds (or all funds if bid was too low)
396   //
397   function withdrawRefund() public {
398     uint _amount = secretBids[msg.sender].refund;
399     secretBids[msg.sender].refund = 0;
400     msg.sender.transfer(_amount);
401   }
402 
403 
404   //
405   // grant developer tokens, equal to a percentage of purchased tokens.
406   // once called, any remaining tokens will be burned.
407   //
408   function doDeveloperGrant() public afterSale {
409     uint _quantity = purchasedCount * developerPctX10 / 1000;
410     var _tokensLeft = token.balanceOf(this);
411     if (_quantity > _tokensLeft)
412       _quantity = _tokensLeft;
413     if (_quantity > 0) {
414       //transfer pct tokens to developers
415       _tokensLeft -= _quantity;
416       if (!token.transfer(developers, _quantity))
417         revert();
418     }
419     //and burn everthing that remains
420     token.unPaidBurnTokens(_tokensLeft);
421   }
422 
423 
424   //
425   // pay auction proceeds to the underwriter
426   // may be called by underwriter or owner (fbo underwriter)
427   //
428   function payUnderwriter() public {
429     require(msg.sender == owner || msg.sender == underwriter);
430     uint _amount = proceeds;
431     proceeds = 0;
432     if (!underwriter.call.gas(contractSendGas).value(_amount)())
433       revert();
434   }
435 
436 
437   //for debug
438   //only available before the contract is locked
439   function haraKiri() ownerOnly unlockedOnly {
440     selfdestruct(owner);
441   }
442 }