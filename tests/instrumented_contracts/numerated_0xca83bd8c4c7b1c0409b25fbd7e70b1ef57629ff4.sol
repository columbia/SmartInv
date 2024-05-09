1 pragma solidity ^0.4.11;
2 
3 /*
4     Overflow protected math functions
5 */
6 contract SafeMath {
7     /**
8         constructor
9     */
10     function SafeMath() {
11     }
12 
13     /**
14         @dev returns the sum of _x and _y, asserts if the calculation overflows
15 
16         @param _x   value 1
17         @param _y   value 2
18 
19         @return sum
20     */
21     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
22         uint256 z = _x + _y;
23         assert(z >= _x);
24         return z;
25     }
26 
27     /**
28         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
29 
30         @param _x   minuend
31         @param _y   subtrahend
32 
33         @return difference
34     */
35     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
36         assert(_x >= _y);
37         return _x - _y;
38     }
39 
40     /**
41         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
42 
43         @param _x   factor 1
44         @param _y   factor 2
45 
46         @return product
47     */
48     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
49         uint256 z = _x * _y;
50         assert(_x == 0 || z / _x == _y);
51         return z;
52     }
53 }
54 
55 /*
56     Owned contract interface
57 */
58 contract IOwned {
59     // this function isn't abstract since the compiler emits automatically generated getter functions as external
60     function owner() public constant returns (address owner) { owner; }
61 
62     function transferOwnership(address _newOwner) public;
63     function acceptOwnership() public;
64 }
65 
66 /*
67     Provides support and utilities for contract ownership
68 */
69 contract Owned is IOwned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnerUpdate(address _prevOwner, address _newOwner);
74 
75     /**
76         @dev constructor
77     */
78     function Owned() {
79         owner = msg.sender;
80     }
81 
82     // allows execution by the owner only
83     modifier ownerOnly {
84         assert(msg.sender == owner);
85         _;
86     }
87 
88     /**
89         @dev allows transferring the contract ownership
90         the new owner still need to accept the transfer
91         can only be called by the contract owner
92 
93         @param _newOwner    new contract owner
94     */
95     function transferOwnership(address _newOwner) public ownerOnly {
96         require(_newOwner != owner);
97         newOwner = _newOwner;
98     }
99 
100     /**
101         @dev used by a new owner to accept an ownership transfer
102     */
103     function acceptOwnership() public {
104         require(msg.sender == newOwner);
105         OwnerUpdate(owner, newOwner);
106         owner = newOwner;
107         newOwner = 0x0;
108     }
109 }
110 
111 /*
112     ERC20 Standard Token interface
113 */
114 contract IERC20Token {
115     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
116     function name() public constant returns (string name) { name; }
117     function symbol() public constant returns (string symbol) { symbol; }
118     function decimals() public constant returns (uint8 decimals) { decimals; }
119     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
120     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
121     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
122 
123     function transfer(address _to, uint256 _value) public returns (bool success);
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
125     function approve(address _spender, uint256 _value) public returns (bool success);
126 }
127 
128 /*
129     Token Holder interface
130 */
131 contract ITokenHolder is IOwned {
132     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
133 }
134 
135 /*
136     We consider every contract to be a 'token holder' since it's currently not possible
137     for a contract to deny receiving tokens.
138 
139     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
140     the owner to send tokens that were sent to the contract by mistake back to their sender.
141 */
142 contract TokenHolder is ITokenHolder, Owned {
143     /**
144         @dev constructor
145     */
146     function TokenHolder() {
147     }
148 
149     // validates an address - currently only checks that it isn't null
150     modifier validAddress(address _address) {
151         require(_address != 0x0);
152         _;
153     }
154 
155     // verifies that the address is different than this contract address
156     modifier notThis(address _address) {
157         require(_address != address(this));
158         _;
159     }
160 
161     /**
162         @dev withdraws tokens held by the contract and sends them to an account
163         can only be called by the owner
164 
165         @param _token   ERC20 token contract address
166         @param _to      account to receive the new amount
167         @param _amount  amount to withdraw
168     */
169     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
170         public
171         ownerOnly
172         validAddress(_token)
173         validAddress(_to)
174         notThis(_to)
175     {
176         assert(_token.transfer(_to, _amount));
177     }
178 }
179 
180 /*
181     Smart Token interface
182 */
183 contract ISmartToken is ITokenHolder, IERC20Token {
184     function disableTransfers(bool _disable) public;
185     function issue(address _to, uint256 _amount) public;
186     function destroy(address _from, uint256 _amount) public;
187 }
188 
189 /*
190     The smart token controller is an upgradable part of the smart token that allows
191     more functionality as well as fixes for bugs/exploits.
192     Once it accepts ownership of the token, it becomes the token's sole controller
193     that can execute any of its functions.
194 
195     To upgrade the controller, ownership must be transferred to a new controller, along with
196     any relevant data.
197 
198     The smart token must be set on construction and cannot be changed afterwards.
199     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
200 
201     Note that the controller can transfer token ownership to a new controller that
202     doesn't allow executing any function on the token, for a trustless solution.
203     Doing that will also remove the owner's ability to upgrade the controller.
204 */
205 contract SmartTokenController is TokenHolder {
206     ISmartToken public token;   // smart token
207 
208     /**
209         @dev constructor
210     */
211     function SmartTokenController(ISmartToken _token)
212         validAddress(_token)
213     {
214         token = _token;
215     }
216 
217     // ensures that the controller is the token's owner
218     modifier active() {
219         assert(token.owner() == address(this));
220         _;
221     }
222 
223     // ensures that the controller is not the token's owner
224     modifier inactive() {
225         assert(token.owner() != address(this));
226         _;
227     }
228 
229     /**
230         @dev allows transferring the token ownership
231         the new owner still need to accept the transfer
232         can only be called by the contract owner
233 
234         @param _newOwner    new token owner
235     */
236     function transferTokenOwnership(address _newOwner) public ownerOnly {
237         token.transferOwnership(_newOwner);
238     }
239 
240     /**
241         @dev used by a new owner to accept a token ownership transfer
242         can only be called by the contract owner
243     */
244     function acceptTokenOwnership() public ownerOnly {
245         token.acceptOwnership();
246     }
247 
248     /**
249         @dev disables/enables token transfers
250         can only be called by the contract owner
251 
252         @param _disable    true to disable transfers, false to enable them
253     */
254     function disableTokenTransfers(bool _disable) public ownerOnly {
255         token.disableTransfers(_disable);
256     }
257 
258     /**
259         @dev allows the owner to execute the token's issue function
260 
261         @param _to         account to receive the new amount
262         @param _amount     amount to increase the supply by
263     */
264     function issueTokens(address _to, uint256 _amount) public ownerOnly {
265         token.issue(_to, _amount);
266     }
267 
268     /**
269         @dev allows the owner to execute the token's destroy function
270 
271         @param _from       account to remove the amount from
272         @param _amount     amount to decrease the supply by
273     */
274     function destroyTokens(address _from, uint256 _amount) public ownerOnly {
275         token.destroy(_from, _amount);
276     }
277 
278     /**
279         @dev withdraws tokens held by the token and sends them to an account
280         can only be called by the owner
281 
282         @param _token   ERC20 token contract address
283         @param _to      account to receive the new amount
284         @param _amount  amount to withdraw
285     */
286     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
287         token.withdrawTokens(_token, _to, _amount);
288     }
289 }
290 
291 /*
292     Bancor Formula interface
293 */
294 contract IBancorFormula {
295     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint16 _reserveRatio, uint256 _depositAmount) public constant returns (uint256);
296     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint16 _reserveRatio, uint256 _sellAmount) public constant returns (uint256);
297 }
298 
299 /*
300     EIP228 Token Changer interface
301 */
302 contract ITokenChanger {
303     function changeableTokenCount() public constant returns (uint16 count);
304     function changeableToken(uint16 _tokenIndex) public constant returns (address tokenAddress);
305     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256 amount);
306     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 amount);
307 }
308 
309 /*
310     Open issues:
311     - Add miner front-running attack protection. The issue is somewhat mitigated by the use of _minReturn when changing
312     - Possibly add getters for reserve fields so that the client won't need to rely on the order in the struct
313 */
314 
315 /*
316     Bancor Changer v0.1
317 
318     The Bancor version of the token changer, allows changing between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
319 
320     ERC20 reserve token balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
321     the actual reserve balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
322 
323     The changer is upgradable (just like any SmartTokenController).
324 
325     WARNING: It is NOT RECOMMENDED to use the changer with Smart Tokens that have less than 8 decimal digits
326              or with very small numbers because of precision loss
327 */
328 contract BancorChanger is ITokenChanger, SmartTokenController, SafeMath {
329     struct Reserve {
330         uint256 virtualBalance;         // virtual balance
331         uint8 ratio;                    // constant reserve ratio (CRR), 1-100
332         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
333         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the reserve, can be set by the token owner
334         bool isSet;                     // used to tell if the mapping element is defined
335     }
336 
337     string public version = '0.1';
338     string public changerType = 'bancor';
339 
340     IBancorFormula public formula;                  // bancor calculation formula contract
341     address[] public reserveTokens;                 // ERC20 standard token addresses
342     mapping (address => Reserve) public reserves;   // reserve token addresses -> reserve data
343     uint8 private totalReserveRatio = 0;            // used to prevent increasing the total reserve ratio above 100% efficiently
344 
345     // triggered when a change between two tokens occurs
346     event Change(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return);
347 
348     /**
349         @dev constructor
350 
351         @param _token      smart token governed by the changer
352         @param _formula    address of a bancor formula contract
353     */
354     function BancorChanger(ISmartToken _token, IBancorFormula _formula, IERC20Token _reserveToken, uint8 _reserveRatio)
355         SmartTokenController(_token)
356         validAddress(_formula)
357     {
358         formula = _formula;
359 
360         if (address(_reserveToken) != 0x0)
361             addReserve(_reserveToken, _reserveRatio, false);
362     }
363 
364     // verifies that an amount is greater than zero
365     modifier validAmount(uint256 _amount) {
366         require(_amount > 0);
367         _;
368     }
369 
370     // validates a reserve token address - verifies that the address belongs to one of the reserve tokens
371     modifier validReserve(address _address) {
372         require(reserves[_address].isSet);
373         _;
374     }
375 
376     // validates a token address - verifies that the address belongs to one of the changeable tokens
377     modifier validToken(address _address) {
378         require(_address == address(token) || reserves[_address].isSet);
379         _;
380     }
381 
382     // validates reserve ratio range
383     modifier validReserveRatio(uint8 _ratio) {
384         require(_ratio > 0 && _ratio <= 100);
385         _;
386     }
387 
388     /**
389         @dev returns the number of reserve tokens defined
390 
391         @return number of reserve tokens
392     */
393     function reserveTokenCount() public constant returns (uint16 count) {
394         return uint16(reserveTokens.length);
395     }
396 
397     /**
398         @dev returns the number of changeable tokens supported by the contract
399         note that the number of changeable tokens is the number of reserve token, plus 1 (that represents the smart token)
400 
401         @return number of changeable tokens
402     */
403     function changeableTokenCount() public constant returns (uint16 count) {
404         return reserveTokenCount() + 1;
405     }
406 
407     /**
408         @dev given a changeable token index, returns the changeable token contract address
409 
410         @param _tokenIndex  changeable token index
411 
412         @return number of changeable tokens
413     */
414     function changeableToken(uint16 _tokenIndex) public constant returns (address tokenAddress) {
415         if (_tokenIndex == 0)
416             return token;
417         return reserveTokens[_tokenIndex - 1];
418     }
419 
420     /*
421         @dev allows the owner to update the formula contract address
422 
423         @param _formula    address of a bancor formula contract
424     */
425     function setFormula(IBancorFormula _formula)
426         public
427         ownerOnly
428         validAddress(_formula)
429         notThis(_formula)
430     {
431         require(_formula != formula); // validate input
432         formula = _formula;
433     }
434 
435     /**
436         @dev defines a new reserve for the token
437         can only be called by the token owner while the changer is inactive
438 
439         @param _token                  address of the reserve token
440         @param _ratio                  constant reserve ratio, 1-100
441         @param _enableVirtualBalance   true to enable virtual balance for the reserve, false to disable it
442     */
443     function addReserve(IERC20Token _token, uint8 _ratio, bool _enableVirtualBalance)
444         public
445         ownerOnly
446         inactive
447         validAddress(_token)
448         notThis(_token)
449         validReserveRatio(_ratio)
450     {
451         require(_token != address(token) && !reserves[_token].isSet && totalReserveRatio + _ratio <= 100); // validate input
452 
453         reserves[_token].virtualBalance = 0;
454         reserves[_token].ratio = _ratio;
455         reserves[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
456         reserves[_token].isPurchaseEnabled = true;
457         reserves[_token].isSet = true;
458         reserveTokens.push(_token);
459         totalReserveRatio += _ratio;
460     }
461 
462     /**
463         @dev updates one of the token reserves
464         can only be called by the token owner
465 
466         @param _reserveToken           address of the reserve token
467         @param _ratio                  constant reserve ratio, 1-100
468         @param _enableVirtualBalance   true to enable virtual balance for the reserve, false to disable it
469         @param _virtualBalance         new reserve's virtual balance
470     */
471     function updateReserve(IERC20Token _reserveToken, uint8 _ratio, bool _enableVirtualBalance, uint256 _virtualBalance)
472         public
473         ownerOnly
474         validReserve(_reserveToken)
475         validReserveRatio(_ratio)
476     {
477         Reserve reserve = reserves[_reserveToken];
478         require(totalReserveRatio - reserve.ratio + _ratio <= 100); // validate input
479 
480         totalReserveRatio = totalReserveRatio - reserve.ratio + _ratio;
481         reserve.ratio = _ratio;
482         reserve.isVirtualBalanceEnabled = _enableVirtualBalance;
483         reserve.virtualBalance = _virtualBalance;
484     }
485 
486     /**
487         @dev disables purchasing with the given reserve token in case the reserve token got compromised
488         can only be called by the token owner
489         note that selling is still enabled regardless of this flag and it cannot be disabled by the token owner
490 
491         @param _reserveToken    reserve token contract address
492         @param _disable         true to disable the token, false to re-enable it
493     */
494     function disableReservePurchases(IERC20Token _reserveToken, bool _disable)
495         public
496         ownerOnly
497         validReserve(_reserveToken)
498     {
499         reserves[_reserveToken].isPurchaseEnabled = !_disable;
500     }
501 
502     /**
503         @dev returns the reserve's virtual balance if one is defined, otherwise returns the actual balance
504 
505         @param _reserveToken    reserve token contract address
506 
507         @return reserve balance
508     */
509     function getReserveBalance(IERC20Token _reserveToken)
510         public
511         constant
512         validReserve(_reserveToken)
513         returns (uint256 balance)
514     {
515         Reserve reserve = reserves[_reserveToken];
516         return reserve.isVirtualBalanceEnabled ? reserve.virtualBalance : _reserveToken.balanceOf(this);
517     }
518 
519     /**
520         @dev returns the expected return for changing a specific amount of _fromToken to _toToken
521 
522         @param _fromToken  ERC20 token to change from
523         @param _toToken    ERC20 token to change to
524         @param _amount     amount to change, in fromToken
525 
526         @return expected change return amount
527     */
528     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount)
529         public
530         constant
531         validToken(_fromToken)
532         validToken(_toToken)
533         returns (uint256 amount)
534     {
535         require(_fromToken != _toToken); // validate input
536 
537         // change between the token and one of its reserves
538         if (_toToken == token)
539             return getPurchaseReturn(_fromToken, _amount);
540         else if (_fromToken == token)
541             return getSaleReturn(_toToken, _amount);
542 
543         // change between 2 reserves
544         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
545         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
546     }
547 
548     /**
549         @dev returns the expected return for buying the token for a reserve token
550 
551         @param _reserveToken   reserve token contract address
552         @param _depositAmount  amount to deposit (in the reserve token)
553 
554         @return expected purchase return amount
555     */
556     function getPurchaseReturn(IERC20Token _reserveToken, uint256 _depositAmount)
557         public
558         constant
559         active
560         validReserve(_reserveToken)
561         returns (uint256 amount)
562     {
563         Reserve reserve = reserves[_reserveToken];
564         require(reserve.isPurchaseEnabled); // validate input
565 
566         uint256 tokenSupply = token.totalSupply();
567         uint256 reserveBalance = getReserveBalance(_reserveToken);
568         return formula.calculatePurchaseReturn(tokenSupply, reserveBalance, reserve.ratio, _depositAmount);
569     }
570 
571     /**
572         @dev returns the expected return for selling the token for one of its reserve tokens
573 
574         @param _reserveToken   reserve token contract address
575         @param _sellAmount     amount to sell (in the smart token)
576 
577         @return expected sale return amount
578     */
579     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount) public constant returns (uint256 amount) {
580         return getSaleReturn(_reserveToken, _sellAmount, token.totalSupply());
581     }
582 
583     /**
584         @dev changes a specific amount of _fromToken to _toToken
585 
586         @param _fromToken  ERC20 token to change from
587         @param _toToken    ERC20 token to change to
588         @param _amount     amount to change, in fromToken
589         @param _minReturn  if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
590 
591         @return change return amount
592     */
593     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
594         public
595         validToken(_fromToken)
596         validToken(_toToken)
597         returns (uint256 amount)
598     {
599         require(_fromToken != _toToken); // validate input
600 
601         // change between the token and one of its reserves
602         if (_toToken == token)
603             return buy(_fromToken, _amount, _minReturn);
604         else if (_fromToken == token)
605             return sell(_toToken, _amount, _minReturn);
606 
607         // change between 2 reserves
608         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
609         return sell(_toToken, purchaseAmount, _minReturn);
610     }
611 
612     /**
613         @dev buys the token by depositing one of its reserve tokens
614 
615         @param _reserveToken   reserve token contract address
616         @param _depositAmount  amount to deposit (in the reserve token)
617         @param _minReturn      if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
618 
619         @return buy return amount
620     */
621     function buy(IERC20Token _reserveToken, uint256 _depositAmount, uint256 _minReturn)
622         public
623         validAmount(_minReturn)
624         returns (uint256 amount) {
625         amount = getPurchaseReturn(_reserveToken, _depositAmount);
626         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
627 
628         // update virtual balance if relevant
629         Reserve reserve = reserves[_reserveToken];
630         if (reserve.isVirtualBalanceEnabled)
631             reserve.virtualBalance = safeAdd(reserve.virtualBalance, _depositAmount);
632 
633         assert(_reserveToken.transferFrom(msg.sender, this, _depositAmount)); // transfer _depositAmount funds from the caller in the reserve token
634         token.issue(msg.sender, amount); // issue new funds to the caller in the smart token
635 
636         Change(_reserveToken, token, msg.sender, _depositAmount, amount);
637         return amount;
638     }
639 
640     /**
641         @dev sells the token by withdrawing from one of its reserve tokens
642 
643         @param _reserveToken   reserve token contract address
644         @param _sellAmount     amount to sell (in the smart token)
645         @param _minReturn      if the change results in an amount smaller the minimum return - it is cancelled, must be nonzero
646 
647         @return sell return amount
648     */
649     function sell(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _minReturn)
650         public
651         validAmount(_minReturn)
652         returns (uint256 amount) {
653         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
654 
655         amount = getSaleReturn(_reserveToken, _sellAmount);
656         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
657 
658         uint256 reserveBalance = getReserveBalance(_reserveToken);
659         assert(amount <= reserveBalance); // ensure that the trade won't result in negative reserve
660 
661         uint256 tokenSupply = token.totalSupply();
662         assert(amount < reserveBalance || _sellAmount == tokenSupply); // ensure that the trade will only deplete the reserve if the total supply is depleted as well
663 
664         // update virtual balance if relevant
665         Reserve reserve = reserves[_reserveToken];
666         if (reserve.isVirtualBalanceEnabled)
667             reserve.virtualBalance = safeSub(reserve.virtualBalance, amount);
668 
669         token.destroy(msg.sender, _sellAmount); // destroy _sellAmount from the caller's balance in the smart token
670         assert(_reserveToken.transfer(msg.sender, amount)); // transfer funds to the caller in the reserve token
671                                                             // note that it might fail if the actual reserve balance is smaller than the virtual balance
672         Change(token, _reserveToken, msg.sender, _sellAmount, amount);
673         return amount;
674     }
675 
676     /**
677         @dev utility, returns the expected return for selling the token for one of its reserve tokens, given a total supply override
678 
679         @param _reserveToken   reserve token contract address
680         @param _sellAmount     amount to sell (in the smart token)
681         @param _totalSupply    total token supply, overrides the actual token total supply when calculating the return
682 
683         @return sale return amount
684     */
685     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _totalSupply)
686         private
687         constant
688         active
689         validReserve(_reserveToken)
690         validAmount(_totalSupply)
691         returns (uint256 amount)
692     {
693         Reserve reserve = reserves[_reserveToken];
694         uint256 reserveBalance = getReserveBalance(_reserveToken);
695         return formula.calculateSaleReturn(_totalSupply, reserveBalance, reserve.ratio, _sellAmount);
696     }
697 }