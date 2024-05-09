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
610 
611 
612 /**
613     @dev the BancorConverterExtensions contract is an owned contract that serves as a single point of access
614     to the BancorFormula, BancorGasPriceLimit and BancorQuickConverter contracts from all BancorConverter contract instances.
615     it allows upgrading these contracts without the need to update each and every
616     BancorConverter contract instance individually.
617 */
618 contract BancorConverterExtensions is IBancorConverterExtensions, TokenHolder {
619     IBancorFormula public formula;  // bancor calculation formula contract
620     IBancorGasPriceLimit public gasPriceLimit; // bancor universal gas price limit contract
621     IBancorQuickConverter public quickConverter; // bancor quick converter contract
622 
623     /**
624         @dev constructor
625 
626         @param _formula         address of a bancor formula contract
627         @param _gasPriceLimit   address of a bancor gas price limit contract
628         @param _quickConverter  address of a bancor quick converter contract
629     */
630     function BancorConverterExtensions(IBancorFormula _formula, IBancorGasPriceLimit _gasPriceLimit, IBancorQuickConverter _quickConverter)
631         validAddress(_formula)
632         validAddress(_gasPriceLimit)
633         validAddress(_quickConverter)
634     {
635         formula = _formula;
636         gasPriceLimit = _gasPriceLimit;
637         quickConverter = _quickConverter;
638     }
639 
640     /*
641         @dev allows the owner to update the formula contract address
642 
643         @param _formula    address of a bancor formula contract
644     */
645     function setFormula(IBancorFormula _formula)
646         public
647         ownerOnly
648         validAddress(_formula)
649         notThis(_formula)
650     {
651         formula = _formula;
652     }
653 
654     /*
655         @dev allows the owner to update the gas price limit contract address
656 
657         @param _gasPriceLimit   address of a bancor gas price limit contract
658     */
659     function setGasPriceLimit(IBancorGasPriceLimit _gasPriceLimit)
660         public
661         ownerOnly
662         validAddress(_gasPriceLimit)
663         notThis(_gasPriceLimit)
664     {
665         gasPriceLimit = _gasPriceLimit;
666     }
667 
668     /*
669         @dev allows the owner to update the quick converter contract address
670 
671         @param _quickConverter  address of a bancor quick converter contract
672     */
673     function setQuickConverter(IBancorQuickConverter _quickConverter)
674         public
675         ownerOnly
676         validAddress(_quickConverter)
677         notThis(_quickConverter)
678     {
679         quickConverter = _quickConverter;
680     }
681 }
682 
683 /*
684     Bancor Converter v0.4
685 
686     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
687 
688     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
689     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
690 
691     The converter is upgradable (just like any SmartTokenController).
692 
693     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
694              or with very small numbers because of precision loss
695 
696 
697     Open issues:
698     - Front-running attacks are currently mitigated by the following mechanisms:
699         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
700         - gas price limit prevents users from having control over the order of execution
701       Other potential solutions might include a commit/reveal based schemes
702     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
703 */
704 contract BancorConverter is ITokenConverter, SmartTokenController, Managed {
705     uint32 private constant MAX_WEIGHT = 1000000;
706     uint32 private constant MAX_CONVERSION_FEE = 1000000;
707 
708     struct Connector {
709         uint256 virtualBalance;         // connector virtual balance
710         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
711         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
712         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
713         bool isSet;                     // used to tell if the mapping element is defined
714     }
715 
716     string public version = '0.5';
717     string public converterType = 'bancor';
718 
719     IBancorConverterExtensions public extensions;       // bancor converter extensions contract
720     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
721     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
722     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
723     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
724     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
725     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
726     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
727 
728     // triggered when a conversion between two tokens occurs (TokenConverter event)
729     event Conversion(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
730                      uint256 _currentPriceN, uint256 _currentPriceD);
731 
732     /**
733         @dev constructor
734 
735         @param  _token              smart token governed by the converter
736         @param  _extensions         address of a bancor converter extensions contract
737         @param  _maxConversionFee   maximum conversion fee, represented in ppm
738         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
739         @param  _connectorWeight    optional, weight for the initial connector
740     */
741     function BancorConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight)
742         SmartTokenController(_token)
743         validAddress(_extensions)
744         validMaxConversionFee(_maxConversionFee)
745     {
746         extensions = _extensions;
747         maxConversionFee = _maxConversionFee;
748 
749         if (address(_connectorToken) != 0x0)
750             addConnector(_connectorToken, _connectorWeight, false);
751     }
752 
753     // validates a connector token address - verifies that the address belongs to one of the connector tokens
754     modifier validConnector(IERC20Token _address) {
755         require(connectors[_address].isSet);
756         _;
757     }
758 
759     // validates a token address - verifies that the address belongs to one of the convertible tokens
760     modifier validToken(IERC20Token _address) {
761         require(_address == token || connectors[_address].isSet);
762         _;
763     }
764 
765     // verifies that the gas price is lower than the universal limit
766     modifier validGasPrice() {
767         assert(tx.gasprice <= extensions.gasPriceLimit().gasPrice());
768         _;
769     }
770 
771     // validates maximum conversion fee
772     modifier validMaxConversionFee(uint32 _conversionFee) {
773         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
774         _;
775     }
776 
777     // validates conversion fee
778     modifier validConversionFee(uint32 _conversionFee) {
779         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
780         _;
781     }
782 
783     // validates connector weight range
784     modifier validConnectorWeight(uint32 _weight) {
785         require(_weight > 0 && _weight <= MAX_WEIGHT);
786         _;
787     }
788 
789     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
790     modifier validConversionPath(IERC20Token[] _path) {
791         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
792         _;
793     }
794 
795     // allows execution only when conversions aren't disabled
796     modifier conversionsAllowed {
797         assert(conversionsEnabled);
798         _;
799     }
800 
801     /**
802         @dev returns the number of connector tokens defined
803 
804         @return number of connector tokens
805     */
806     function connectorTokenCount() public constant returns (uint16) {
807         return uint16(connectorTokens.length);
808     }
809 
810     /**
811         @dev returns the number of convertible tokens supported by the contract
812         note that the number of convertible tokens is the number of connector token, plus 1 (that represents the smart token)
813 
814         @return number of convertible tokens
815     */
816     function convertibleTokenCount() public constant returns (uint16) {
817         return connectorTokenCount() + 1;
818     }
819 
820     /**
821         @dev given a convertible token index, returns its contract address
822 
823         @param _tokenIndex  convertible token index
824 
825         @return convertible token address
826     */
827     function convertibleToken(uint16 _tokenIndex) public constant returns (address) {
828         if (_tokenIndex == 0)
829             return token;
830         return connectorTokens[_tokenIndex - 1];
831     }
832 
833     /*
834         @dev allows the owner to update the extensions contract address
835 
836         @param _extensions    address of a bancor converter extensions contract
837     */
838     function setExtensions(IBancorConverterExtensions _extensions)
839         public
840         ownerOnly
841         validAddress(_extensions)
842         notThis(_extensions)
843     {
844         extensions = _extensions;
845     }
846 
847     /*
848         @dev allows the manager to update the quick buy path
849 
850         @param _path    new quick buy path, see conversion path format in the BancorQuickConverter contract
851     */
852     function setQuickBuyPath(IERC20Token[] _path)
853         public
854         ownerOnly
855         validConversionPath(_path)
856     {
857         quickBuyPath = _path;
858     }
859 
860     /*
861         @dev allows the manager to clear the quick buy path
862     */
863     function clearQuickBuyPath() public ownerOnly {
864         quickBuyPath.length = 0;
865     }
866 
867     /**
868         @dev returns the length of the quick buy path array
869 
870         @return quick buy path length
871     */
872     function getQuickBuyPathLength() public constant returns (uint256) {
873         return quickBuyPath.length;
874     }
875 
876     /**
877         @dev disables the entire conversion functionality
878         this is a safety mechanism in case of a emergency
879         can only be called by the manager
880 
881         @param _disable true to disable conversions, false to re-enable them
882     */
883     function disableConversions(bool _disable) public managerOnly {
884         conversionsEnabled = !_disable;
885     }
886 
887     /**
888         @dev updates the current conversion fee
889         can only be called by the manager
890 
891         @param _conversionFee new conversion fee, represented in ppm
892     */
893     function setConversionFee(uint32 _conversionFee)
894         public
895         managerOnly
896         validConversionFee(_conversionFee)
897     {
898         conversionFee = _conversionFee;
899     }
900 
901     /*
902         @dev returns the conversion fee amount for a given return amount
903 
904         @return conversion fee amount
905     */
906     function getConversionFeeAmount(uint256 _amount) public constant returns (uint256) {
907         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
908     }
909 
910     /**
911         @dev defines a new connector for the token
912         can only be called by the owner while the converter is inactive
913 
914         @param _token                  address of the connector token
915         @param _weight                 constant connector weight, represented in ppm, 1-1000000
916         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
917     */
918     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
919         public
920         ownerOnly
921         inactive
922         validAddress(_token)
923         notThis(_token)
924         validConnectorWeight(_weight)
925     {
926         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
927 
928         connectors[_token].virtualBalance = 0;
929         connectors[_token].weight = _weight;
930         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
931         connectors[_token].isPurchaseEnabled = true;
932         connectors[_token].isSet = true;
933         connectorTokens.push(_token);
934         totalConnectorWeight += _weight;
935     }
936 
937     /**
938         @dev updates one of the token connectors
939         can only be called by the owner
940 
941         @param _connectorToken         address of the connector token
942         @param _weight                 constant connector weight, represented in ppm, 1-1000000
943         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
944         @param _virtualBalance         new connector's virtual balance
945     */
946     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
947         public
948         ownerOnly
949         validConnector(_connectorToken)
950         validConnectorWeight(_weight)
951     {
952         Connector storage connector = connectors[_connectorToken];
953         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
954 
955         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
956         connector.weight = _weight;
957         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
958         connector.virtualBalance = _virtualBalance;
959     }
960 
961     /**
962         @dev disables purchasing with the given connector token in case the connector token got compromised
963         can only be called by the owner
964         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
965 
966         @param _connectorToken  connector token contract address
967         @param _disable         true to disable the token, false to re-enable it
968     */
969     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
970         public
971         ownerOnly
972         validConnector(_connectorToken)
973     {
974         connectors[_connectorToken].isPurchaseEnabled = !_disable;
975     }
976 
977     /**
978         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
979 
980         @param _connectorToken  connector token contract address
981 
982         @return connector balance
983     */
984     function getConnectorBalance(IERC20Token _connectorToken)
985         public
986         constant
987         validConnector(_connectorToken)
988         returns (uint256)
989     {
990         Connector storage connector = connectors[_connectorToken];
991         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
992     }
993 
994     /**
995         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
996 
997         @param _fromToken  ERC20 token to convert from
998         @param _toToken    ERC20 token to convert to
999         @param _amount     amount to convert, in fromToken
1000 
1001         @return expected conversion return amount
1002     */
1003     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256) {
1004         require(_fromToken != _toToken); // validate input
1005 
1006         // conversion between the token and one of its connectors
1007         if (_toToken == token)
1008             return getPurchaseReturn(_fromToken, _amount);
1009         else if (_fromToken == token)
1010             return getSaleReturn(_toToken, _amount);
1011 
1012         // conversion between 2 connectors
1013         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
1014         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
1015     }
1016 
1017     /**
1018         @dev returns the expected return for buying the token for a connector token
1019 
1020         @param _connectorToken  connector token contract address
1021         @param _depositAmount   amount to deposit (in the connector token)
1022 
1023         @return expected purchase return amount
1024     */
1025     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
1026         public
1027         constant
1028         active
1029         validConnector(_connectorToken)
1030         returns (uint256)
1031     {
1032         Connector storage connector = connectors[_connectorToken];
1033         require(connector.isPurchaseEnabled); // validate input
1034 
1035         uint256 tokenSupply = token.totalSupply();
1036         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1037         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
1038 
1039         // deduct the fee from the return amount
1040         uint256 feeAmount = getConversionFeeAmount(amount);
1041         return safeSub(amount, feeAmount);
1042     }
1043 
1044     /**
1045         @dev returns the expected return for selling the token for one of its connector tokens
1046 
1047         @param _connectorToken  connector token contract address
1048         @param _sellAmount      amount to sell (in the smart token)
1049 
1050         @return expected sale return amount
1051     */
1052     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount) public constant returns (uint256) {
1053         return getSaleReturn(_connectorToken, _sellAmount, token.totalSupply());
1054     }
1055 
1056     /**
1057         @dev converts a specific amount of _fromToken to _toToken
1058 
1059         @param _fromToken  ERC20 token to convert from
1060         @param _toToken    ERC20 token to convert to
1061         @param _amount     amount to convert, in fromToken
1062         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1063 
1064         @return conversion return amount
1065     */
1066     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1067         require(_fromToken != _toToken); // validate input
1068 
1069         // conversion between the token and one of its connectors
1070         if (_toToken == token)
1071             return buy(_fromToken, _amount, _minReturn);
1072         else if (_fromToken == token)
1073             return sell(_toToken, _amount, _minReturn);
1074 
1075         // conversion between 2 connectors
1076         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
1077         return sell(_toToken, purchaseAmount, _minReturn);
1078     }
1079 
1080     /**
1081         @dev buys the token by depositing one of its connector tokens
1082 
1083         @param _connectorToken  connector token contract address
1084         @param _depositAmount   amount to deposit (in the connector token)
1085         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1086 
1087         @return buy return amount
1088     */
1089     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn)
1090         public
1091         conversionsAllowed
1092         validGasPrice
1093         greaterThanZero(_minReturn)
1094         returns (uint256)
1095     {
1096         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
1097         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
1098 
1099         // update virtual balance if relevant
1100         Connector storage connector = connectors[_connectorToken];
1101         if (connector.isVirtualBalanceEnabled)
1102             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
1103 
1104         // transfer _depositAmount funds from the caller in the connector token
1105         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
1106         // issue new funds to the caller in the smart token
1107         token.issue(msg.sender, amount);
1108 
1109         // calculate the new price using the simple price formula
1110         // price = connector balance / (supply * weight)
1111         // weight is represented in ppm, so multiplying by 1000000
1112         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
1113         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
1114         Conversion(_connectorToken, token, msg.sender, _depositAmount, amount, connectorAmount, tokenAmount);
1115         return amount;
1116     }
1117 
1118     /**
1119         @dev sells the token by withdrawing from one of its connector tokens
1120 
1121         @param _connectorToken  connector token contract address
1122         @param _sellAmount      amount to sell (in the smart token)
1123         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1124 
1125         @return sell return amount
1126     */
1127     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn)
1128         public
1129         conversionsAllowed
1130         validGasPrice
1131         greaterThanZero(_minReturn)
1132         returns (uint256)
1133     {
1134         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1135 
1136         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
1137         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
1138 
1139         uint256 tokenSupply = token.totalSupply();
1140         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1141         // ensure that the trade will only deplete the connector if the total supply is depleted as well
1142         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
1143 
1144         // update virtual balance if relevant
1145         Connector storage connector = connectors[_connectorToken];
1146         if (connector.isVirtualBalanceEnabled)
1147             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
1148 
1149         // destroy _sellAmount from the caller's balance in the smart token
1150         token.destroy(msg.sender, _sellAmount);
1151         // transfer funds to the caller in the connector token
1152         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1153         assert(_connectorToken.transfer(msg.sender, amount));
1154 
1155         // calculate the new price using the simple price formula
1156         // price = connector balance / (supply * weight)
1157         // weight is represented in ppm, so multiplying by 1000000
1158         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
1159         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
1160         Conversion(token, _connectorToken, msg.sender, _sellAmount, amount, tokenAmount, connectorAmount);
1161         return amount;
1162     }
1163 
1164     /**
1165         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1166         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1167 
1168         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
1169         @param _amount      amount to convert from (in the initial source token)
1170         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1171 
1172         @return tokens issued in return
1173     */
1174     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
1175         public
1176         payable
1177         validConversionPath(_path)
1178         returns (uint256)
1179     {
1180         IERC20Token fromToken = _path[0];
1181         IBancorQuickConverter quickConverter = extensions.quickConverter();
1182 
1183         // we need to transfer the source tokens from the caller to the quick converter,
1184         // so it can execute the conversion on behalf of the caller
1185         if (msg.value == 0) {
1186             // not ETH, send the source tokens to the quick converter
1187             // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
1188             if (fromToken == token) {
1189                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1190                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
1191             }
1192             else {
1193                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
1194                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
1195             }
1196         }
1197 
1198         // execute the conversion and pass on the ETH with the call
1199         return quickConverter.convertFor.value(msg.value)(_path, _amount, _minReturn, msg.sender);
1200     }
1201 
1202     // deprecated, backward compatibility
1203     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1204         return convert(_fromToken, _toToken, _amount, _minReturn);
1205     }
1206 
1207     /**
1208         @dev utility, returns the expected return for selling the token for one of its connector tokens, given a total supply override
1209 
1210         @param _connectorToken  connector token contract address
1211         @param _sellAmount      amount to sell (in the smart token)
1212         @param _totalSupply     total token supply, overrides the actual token total supply when calculating the return
1213 
1214         @return sale return amount
1215     */
1216     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _totalSupply)
1217         private
1218         constant
1219         active
1220         validConnector(_connectorToken)
1221         greaterThanZero(_totalSupply)
1222         returns (uint256)
1223     {
1224         Connector storage connector = connectors[_connectorToken];
1225         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1226         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, connectorBalance, connector.weight, _sellAmount);
1227 
1228         // deduct the fee from the return amount
1229         uint256 feeAmount = getConversionFeeAmount(amount);
1230         return safeSub(amount, feeAmount);
1231     }
1232 
1233     /**
1234         @dev fallback, buys the smart token with ETH
1235         note that the purchase will use the price at the time of the purchase
1236     */
1237     function() payable {
1238         quickConvert(quickBuyPath, msg.value, 1);
1239     }
1240 }