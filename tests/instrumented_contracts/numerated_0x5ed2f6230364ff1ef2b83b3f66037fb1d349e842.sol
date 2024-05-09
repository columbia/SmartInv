1 pragma solidity ^0.4.11;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     function Utils() {
11     }
12 
13     // verifies that an amount is greater than zero
14     modifier greaterThanZero(uint256 _amount) {
15         require(_amount > 0);
16         _;
17     }
18 
19     // validates an address - currently only checks that it isn't null
20     modifier validAddress(address _address) {
21         require(_address != 0x0);
22         _;
23     }
24 
25     // verifies that the address is different than this contract address
26     modifier notThis(address _address) {
27         require(_address != address(this));
28         _;
29     }
30 
31     // Overflow protected math functions
32 
33     /**
34         @dev returns the sum of _x and _y, asserts if the calculation overflows
35 
36         @param _x   value 1
37         @param _y   value 2
38 
39         @return sum
40     */
41     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
42         uint256 z = _x + _y;
43         assert(z >= _x);
44         return z;
45     }
46 
47     /**
48         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
49 
50         @param _x   minuend
51         @param _y   subtrahend
52 
53         @return difference
54     */
55     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
56         assert(_x >= _y);
57         return _x - _y;
58     }
59 
60     /**
61         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
62 
63         @param _x   factor 1
64         @param _y   factor 2
65 
66         @return product
67     */
68     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 
76 
77 /*
78     Owned contract interface
79 */
80 contract IOwned {
81     // this function isn't abstract since the compiler emits automatically generated getter functions as external
82     function owner() public constant returns (address) {}
83 
84     function transferOwnership(address _newOwner) public;
85     function acceptOwnership() public;
86 }
87 
88 
89 /*
90     Provides support and utilities for contract ownership
91 */
92 contract Owned is IOwned {
93     address public owner;
94     address public newOwner;
95 
96     event OwnerUpdate(address _prevOwner, address _newOwner);
97 
98     /**
99         @dev constructor
100     */
101     function Owned() {
102         owner = msg.sender;
103     }
104 
105     // allows execution by the owner only
106     modifier ownerOnly {
107         assert(msg.sender == owner);
108         _;
109     }
110 
111     /**
112         @dev allows transferring the contract ownership
113         the new owner still needs to accept the transfer
114         can only be called by the contract owner
115 
116         @param _newOwner    new contract owner
117     */
118     function transferOwnership(address _newOwner) public ownerOnly {
119         require(_newOwner != owner);
120         newOwner = _newOwner;
121     }
122 
123     /**
124         @dev used by a new owner to accept an ownership transfer
125     */
126     function acceptOwnership() public {
127         require(msg.sender == newOwner);
128         OwnerUpdate(owner, newOwner);
129         owner = newOwner;
130         newOwner = 0x0;
131     }
132 }
133 
134 
135 
136 /*
137     ERC20 Standard Token interface
138 */
139 contract IERC20Token {
140     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
141     function name() public constant returns (string) {}
142     function symbol() public constant returns (string) {}
143     function decimals() public constant returns (uint8) {}
144     function totalSupply() public constant returns (uint256) {}
145     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
146     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
147 
148     function transfer(address _to, uint256 _value) public returns (bool success);
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
150     function approve(address _spender, uint256 _value) public returns (bool success);
151 }
152 
153 
154 /*
155     Token Holder interface
156 */
157 contract ITokenHolder is IOwned {
158     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
159 }
160 
161 
162 /*
163     We consider every contract to be a 'token holder' since it's currently not possible
164     for a contract to deny receiving tokens.
165 
166     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
167     the owner to send tokens that were sent to the contract by mistake back to their sender.
168 */
169 contract TokenHolder is ITokenHolder, Owned, Utils {
170     /**
171         @dev constructor
172     */
173     function TokenHolder() {
174     }
175 
176     /**
177         @dev withdraws tokens held by the contract and sends them to an account
178         can only be called by the owner
179 
180         @param _token   ERC20 token contract address
181         @param _to      account to receive the new amount
182         @param _amount  amount to withdraw
183     */
184     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
185         public
186         ownerOnly
187         validAddress(_token)
188         validAddress(_to)
189         notThis(_to)
190     {
191         assert(_token.transfer(_to, _amount));
192     }
193 }
194 
195 
196 
197 
198 
199 /*
200     Smart Token interface
201 */
202 contract ISmartToken is IOwned, IERC20Token {
203     function disableTransfers(bool _disable) public;
204     function issue(address _to, uint256 _amount) public;
205     function destroy(address _from, uint256 _amount) public;
206 }
207 
208 
209 /*
210     The smart token controller is an upgradable part of the smart token that allows
211     more functionality as well as fixes for bugs/exploits.
212     Once it accepts ownership of the token, it becomes the token's sole controller
213     that can execute any of its functions.
214 
215     To upgrade the controller, ownership must be transferred to a new controller, along with
216     any relevant data.
217 
218     The smart token must be set on construction and cannot be changed afterwards.
219     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
220 
221     Note that the controller can transfer token ownership to a new controller that
222     doesn't allow executing any function on the token, for a trustless solution.
223     Doing that will also remove the owner's ability to upgrade the controller.
224 */
225 contract SmartTokenController is TokenHolder {
226     ISmartToken public token;   // smart token
227 
228     /**
229         @dev constructor
230     */
231     function SmartTokenController(ISmartToken _token)
232         validAddress(_token)
233     {
234         token = _token;
235     }
236 
237     // ensures that the controller is the token's owner
238     modifier active() {
239         assert(token.owner() == address(this));
240         _;
241     }
242 
243     // ensures that the controller is not the token's owner
244     modifier inactive() {
245         assert(token.owner() != address(this));
246         _;
247     }
248 
249     /**
250         @dev allows transferring the token ownership
251         the new owner still need to accept the transfer
252         can only be called by the contract owner
253 
254         @param _newOwner    new token owner
255     */
256     function transferTokenOwnership(address _newOwner) public ownerOnly {
257         token.transferOwnership(_newOwner);
258     }
259 
260     /**
261         @dev used by a new owner to accept a token ownership transfer
262         can only be called by the contract owner
263     */
264     function acceptTokenOwnership() public ownerOnly {
265         token.acceptOwnership();
266     }
267 
268     /**
269         @dev disables/enables token transfers
270         can only be called by the contract owner
271 
272         @param _disable    true to disable transfers, false to enable them
273     */
274     function disableTokenTransfers(bool _disable) public ownerOnly {
275         token.disableTransfers(_disable);
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
287         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
288     }
289 }
290 
291 
292 /*
293     Provides support and utilities for contract management
294 */
295 contract Managed {
296     address public manager;
297     address public newManager;
298 
299     event ManagerUpdate(address _prevManager, address _newManager);
300 
301     /**
302         @dev constructor
303     */
304     function Managed() {
305         manager = msg.sender;
306     }
307 
308     // allows execution by the manager only
309     modifier managerOnly {
310         assert(msg.sender == manager);
311         _;
312     }
313 
314     /**
315         @dev allows transferring the contract management
316         the new manager still needs to accept the transfer
317         can only be called by the contract manager
318 
319         @param _newManager    new contract manager
320     */
321     function transferManagement(address _newManager) public managerOnly {
322         require(_newManager != manager);
323         newManager = _newManager;
324     }
325 
326     /**
327         @dev used by a new manager to accept a management transfer
328     */
329     function acceptManagement() public {
330         require(msg.sender == newManager);
331         ManagerUpdate(manager, newManager);
332         manager = newManager;
333         newManager = 0x0;
334     }
335 }
336 
337 
338 /*
339     EIP228 Token Converter interface
340 */
341 contract ITokenConverter {
342     function convertibleTokenCount() public constant returns (uint16);
343     function convertibleToken(uint16 _tokenIndex) public constant returns (address);
344     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256);
345     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
346     // deprecated, backward compatibility
347     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
348 }
349 
350 
351 /*
352     Bancor Formula interface
353 */
354 contract IBancorFormula {
355     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public constant returns (uint256);
356     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public constant returns (uint256);
357 }
358 
359 
360 /*
361     Bancor Gas Price Limit interface
362 */
363 contract IBancorGasPriceLimit {
364     function gasPrice() public constant returns (uint256) {}
365 }
366 
367 
368 /*
369     The BancorGasPriceLimit contract serves as an extra front-running attack mitigation mechanism.
370     It sets a maximum gas price on all bancor conversions, which prevents users from "cutting in line"
371     in order to front-run other transactions.
372     The gas price limit is universal to all converters and it can be updated by the owner to be in line
373     with the network's current gas price.
374 */
375 contract BancorGasPriceLimit is IBancorGasPriceLimit, Owned, Utils {
376     uint256 public gasPrice = 0 wei;    // maximum gas price for bancor transactions
377 
378     /**
379         @dev constructor
380 
381         @param _gasPrice    gas price limit
382     */
383     function BancorGasPriceLimit(uint256 _gasPrice)
384         greaterThanZero(_gasPrice)
385     {
386         gasPrice = _gasPrice;
387     }
388 
389     /*
390         @dev allows the owner to update the gas price limit
391 
392         @param _gasPrice    new gas price limit
393     */
394     function setGasPrice(uint256 _gasPrice)
395         public
396         ownerOnly
397         greaterThanZero(_gasPrice)
398     {
399         gasPrice = _gasPrice;
400     }
401 }
402 
403 
404 /*
405     Bancor Quick Converter interface
406 */
407 contract IBancorQuickConverter {
408     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
409     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
410 }
411 
412 
413 /*
414     Bancor Converter Extensions interface
415 */
416 contract IBancorConverterExtensions {
417     function formula() public constant returns (IBancorFormula) {}
418     function gasPriceLimit() public constant returns (IBancorGasPriceLimit) {}
419     function quickConverter() public constant returns (IBancorQuickConverter) {}
420 }
421 
422 
423 
424 /*
425     Ether Token interface
426 */
427 contract IEtherToken is ITokenHolder, IERC20Token {
428     function deposit() public payable;
429     function withdraw(uint256 _amount) public;
430     function withdrawTo(address _to, uint256 _amount);
431 }
432 
433 
434 /*
435     The BancorQuickConverter contract provides allows converting between any token in the 
436     bancor network in a single transaction.
437 
438     A note on conversion paths -
439     Conversion path is a data structure that's used when converting a token to another token in the bancor network
440     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
441     The path defines which converters should be used and what kind of conversion should be done in each step.
442 
443     The path format doesn't include complex structure and instead, it is represented by a single array
444     in which each 'hop' is represented by a 2-tuple - smart token & to token.
445     In addition, the first element is always the source token.
446     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
447 
448     Format:
449     [source token, smart token, to token, smart token, to token...]
450 */
451 contract BancorQuickConverter is IBancorQuickConverter, TokenHolder {
452     mapping (address => bool) public etherTokens;   // list of all supported ether tokens
453 
454     /**
455         @dev constructor
456     */
457     function BancorQuickConverter() {
458     }
459 
460     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
461     modifier validConversionPath(IERC20Token[] _path) {
462         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
463         _;
464     }
465 
466     /**
467         @dev allows the owner to register/unregister ether tokens
468 
469         @param _token       ether token contract address
470         @param _register    true to register, false to unregister
471     */
472     function registerEtherToken(IEtherToken _token, bool _register)
473         public
474         ownerOnly
475         validAddress(_token)
476         notThis(_token)
477     {
478         etherTokens[_token] = _register;
479     }
480 
481     /**
482         @dev converts the token to any other token in the bancor network by following
483         a predefined conversion path and transfers the result tokens to a target account
484         note that the converter should already own the source tokens
485 
486         @param _path        conversion path, see conversion path format above
487         @param _amount      amount to convert from (in the initial source token)
488         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
489         @param _for         account that will receive the conversion result
490 
491         @return tokens issued in return
492     */
493     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for)
494         public
495         payable
496         validConversionPath(_path)
497         returns (uint256)
498     {
499         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
500         IERC20Token fromToken = _path[0];
501         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
502 
503         ISmartToken smartToken;
504         IERC20Token toToken;
505         ITokenConverter converter;
506         uint256 pathLength = _path.length;
507 
508         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
509         // otherwise, we assume we already have the tokens
510         if (msg.value > 0)
511             IEtherToken(fromToken).deposit.value(msg.value)();
512 
513         // iterate over the conversion path
514         for (uint256 i = 1; i < pathLength; i += 2) {
515             smartToken = ISmartToken(_path[i]);
516             toToken = _path[i + 1];
517             converter = ITokenConverter(smartToken.owner());
518 
519             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
520             if (smartToken != fromToken)
521                 ensureAllowance(fromToken, converter, _amount);
522 
523             // make the conversion - if it's the last one, also provide the minimum return value
524             _amount = converter.change(fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
525             fromToken = toToken;
526         }
527 
528         // finished the conversion, transfer the funds to the target account
529         // if the target token is an ether token, withdraw the tokens and send them as ETH
530         // otherwise, transfer the tokens as is
531         if (etherTokens[toToken])
532             IEtherToken(toToken).withdrawTo(_for, _amount);
533         else
534             assert(toToken.transfer(_for, _amount));
535 
536         return _amount;
537     }
538 
539     /**
540         @dev claims the caller's tokens, converts them to any other token in the bancor network
541         by following a predefined conversion path and transfers the result tokens to a target account
542         note that allowance must be set beforehand
543 
544         @param _path        conversion path, see conversion path format above
545         @param _amount      amount to convert from (in the initial source token)
546         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
547         @param _for         account that will receive the conversion result
548 
549         @return tokens issued in return
550     */
551     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
552         // we need to transfer the tokens from the caller to the converter before we follow
553         // the conversion path, to allow it to execute the conversion on behalf of the caller
554         // note: we assume we already have allowance
555         IERC20Token fromToken = _path[0];
556         assert(fromToken.transferFrom(msg.sender, this, _amount));
557         return convertFor(_path, _amount, _minReturn, _for);
558     }
559 
560     /**
561         @dev converts the token to any other token in the bancor network by following
562         a predefined conversion path and transfers the result tokens back to the sender
563         note that the converter should already own the source tokens
564 
565         @param _path        conversion path, see conversion path format above
566         @param _amount      amount to convert from (in the initial source token)
567         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
568 
569         @return tokens issued in return
570     */
571     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
572         return convertFor(_path, _amount, _minReturn, msg.sender);
573     }
574 
575     /**
576         @dev claims the caller's tokens, converts them to any other token in the bancor network
577         by following a predefined conversion path and transfers the result tokens back to the sender
578         note that allowance must be set beforehand
579 
580         @param _path        conversion path, see conversion path format above
581         @param _amount      amount to convert from (in the initial source token)
582         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
583 
584         @return tokens issued in return
585     */
586     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
587         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
588     }
589 
590     /**
591         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
592 
593         @param _token   token to check the allowance in
594         @param _spender approved address
595         @param _value   allowance amount
596     */
597     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
598         // check if allowance for the given amount already exists
599         if (_token.allowance(this, _spender) >= _value)
600             return;
601 
602         // if the allowance is nonzero, must reset it to 0 first
603         if (_token.allowance(this, _spender) != 0)
604             assert(_token.approve(_spender, 0));
605 
606         // approve the new allowance
607         assert(_token.approve(_spender, _value));
608     }
609 }