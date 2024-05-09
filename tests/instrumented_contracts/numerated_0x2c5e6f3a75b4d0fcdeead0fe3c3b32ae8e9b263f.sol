1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/interfaces/IERC20Token.sol
4 
5 /*
6     ERC20 Standard Token interface
7 */
8 contract IERC20Token {
9     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
10     function name() public view returns (string) {}
11     function symbol() public view returns (string) {}
12     function decimals() public view returns (uint8) {}
13     function totalSupply() public view returns (uint256) {}
14     function balanceOf(address _owner) public view returns (uint256) { _owner; }
15     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
16 
17     function transfer(address _to, uint256 _value) public returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 }
21 
22 // File: contracts/IBancorNetwork.sol
23 
24 /*
25     Bancor Network interface
26 */
27 contract IBancorNetwork {
28     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
29     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
30     
31     function convertForPrioritized3(
32         IERC20Token[] _path,
33         uint256 _amount,
34         uint256 _minReturn,
35         address _for,
36         uint256 _customVal,
37         uint256 _block,
38         uint8 _v,
39         bytes32 _r,
40         bytes32 _s
41     ) public payable returns (uint256);
42     
43     // deprecated, backward compatibility
44     function convertForPrioritized2(
45         IERC20Token[] _path,
46         uint256 _amount,
47         uint256 _minReturn,
48         address _for,
49         uint256 _block,
50         uint8 _v,
51         bytes32 _r,
52         bytes32 _s
53     ) public payable returns (uint256);
54 
55     // deprecated, backward compatibility
56     function convertForPrioritized(
57         IERC20Token[] _path,
58         uint256 _amount,
59         uint256 _minReturn,
60         address _for,
61         uint256 _block,
62         uint256 _nonce,
63         uint8 _v,
64         bytes32 _r,
65         bytes32 _s
66     ) public payable returns (uint256);
67 }
68 
69 // File: contracts/ContractIds.sol
70 
71 /**
72     Id definitions for bancor contracts
73 
74     Can be used in conjunction with the contract registry to get contract addresses
75 */
76 contract ContractIds {
77     // generic
78     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
79     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
80 
81     // bancor logic
82     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
83     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
84     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
85     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
86     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
87 
88     // BNT core
89     bytes32 public constant BNT_TOKEN = "BNTToken";
90     bytes32 public constant BNT_CONVERTER = "BNTConverter";
91 
92     // BancorX
93     bytes32 public constant BANCOR_X = "BancorX";
94     bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";
95 }
96 
97 // File: contracts/FeatureIds.sol
98 
99 /**
100     Id definitions for bancor contract features
101 
102     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
103 */
104 contract FeatureIds {
105     // converter features
106     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
107 }
108 
109 // File: contracts/utility/interfaces/IWhitelist.sol
110 
111 /*
112     Whitelist interface
113 */
114 contract IWhitelist {
115     function isWhitelisted(address _address) public view returns (bool);
116 }
117 
118 // File: contracts/converter/interfaces/IBancorConverter.sol
119 
120 /*
121     Bancor Converter interface
122 */
123 contract IBancorConverter {
124     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
125     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
126     function conversionWhitelist() public view returns (IWhitelist) {}
127     function conversionFee() public view returns (uint32) {}
128     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }
129     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
130     function claimTokens(address _from, uint256 _amount) public;
131     // deprecated, backward compatibility
132     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
133 }
134 
135 // File: contracts/converter/interfaces/IBancorFormula.sol
136 
137 /*
138     Bancor Formula interface
139 */
140 contract IBancorFormula {
141     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
142     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
143     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
144 }
145 
146 // File: contracts/converter/interfaces/IBancorGasPriceLimit.sol
147 
148 /*
149     Bancor Gas Price Limit interface
150 */
151 contract IBancorGasPriceLimit {
152     function gasPrice() public view returns (uint256) {}
153     function validateGasPrice(uint256) public view;
154 }
155 
156 // File: contracts/utility/interfaces/IOwned.sol
157 
158 /*
159     Owned contract interface
160 */
161 contract IOwned {
162     // this function isn't abstract since the compiler emits automatically generated getter functions as external
163     function owner() public view returns (address) {}
164 
165     function transferOwnership(address _newOwner) public;
166     function acceptOwnership() public;
167 }
168 
169 // File: contracts/utility/Owned.sol
170 
171 /*
172     Provides support and utilities for contract ownership
173 */
174 contract Owned is IOwned {
175     address public owner;
176     address public newOwner;
177 
178     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
179 
180     /**
181         @dev constructor
182     */
183     constructor() public {
184         owner = msg.sender;
185     }
186 
187     // allows execution by the owner only
188     modifier ownerOnly {
189         require(msg.sender == owner);
190         _;
191     }
192 
193     /**
194         @dev allows transferring the contract ownership
195         the new owner still needs to accept the transfer
196         can only be called by the contract owner
197 
198         @param _newOwner    new contract owner
199     */
200     function transferOwnership(address _newOwner) public ownerOnly {
201         require(_newOwner != owner);
202         newOwner = _newOwner;
203     }
204 
205     /**
206         @dev used by a new owner to accept an ownership transfer
207     */
208     function acceptOwnership() public {
209         require(msg.sender == newOwner);
210         emit OwnerUpdate(owner, newOwner);
211         owner = newOwner;
212         newOwner = address(0);
213     }
214 }
215 
216 // File: contracts/utility/Utils.sol
217 
218 /*
219     Utilities & Common Modifiers
220 */
221 contract Utils {
222     /**
223         constructor
224     */
225     constructor() public {
226     }
227 
228     // verifies that an amount is greater than zero
229     modifier greaterThanZero(uint256 _amount) {
230         require(_amount > 0);
231         _;
232     }
233 
234     // validates an address - currently only checks that it isn't null
235     modifier validAddress(address _address) {
236         require(_address != address(0));
237         _;
238     }
239 
240     // verifies that the address is different than this contract address
241     modifier notThis(address _address) {
242         require(_address != address(this));
243         _;
244     }
245 
246 }
247 
248 // File: contracts/utility/interfaces/ITokenHolder.sol
249 
250 /*
251     Token Holder interface
252 */
253 contract ITokenHolder is IOwned {
254     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
255 }
256 
257 // File: contracts/utility/TokenHolder.sol
258 
259 /*
260     We consider every contract to be a 'token holder' since it's currently not possible
261     for a contract to deny receiving tokens.
262 
263     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
264     the owner to send tokens that were sent to the contract by mistake back to their sender.
265 */
266 contract TokenHolder is ITokenHolder, Owned, Utils {
267     /**
268         @dev constructor
269     */
270     constructor() public {
271     }
272 
273     /**
274         @dev withdraws tokens held by the contract and sends them to an account
275         can only be called by the owner
276 
277         @param _token   ERC20 token contract address
278         @param _to      account to receive the new amount
279         @param _amount  amount to withdraw
280     */
281     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
282         public
283         ownerOnly
284         validAddress(_token)
285         validAddress(_to)
286         notThis(_to)
287     {
288         assert(_token.transfer(_to, _amount));
289     }
290 }
291 
292 // File: contracts/utility/SafeMath.sol
293 
294 /*
295     Library for basic math operations with overflow/underflow protection
296 */
297 library SafeMath {
298     /**
299         @dev returns the sum of _x and _y, reverts if the calculation overflows
300 
301         @param _x   value 1
302         @param _y   value 2
303 
304         @return sum
305     */
306     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
307         uint256 z = _x + _y;
308         require(z >= _x);
309         return z;
310     }
311 
312     /**
313         @dev returns the difference of _x minus _y, reverts if the calculation underflows
314 
315         @param _x   minuend
316         @param _y   subtrahend
317 
318         @return difference
319     */
320     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
321         require(_x >= _y);
322         return _x - _y;
323     }
324 
325     /**
326         @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
327 
328         @param _x   factor 1
329         @param _y   factor 2
330 
331         @return product
332     */
333     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
334         // gas optimization
335         if (_x == 0)
336             return 0;
337 
338         uint256 z = _x * _y;
339         require(z / _x == _y);
340         return z;
341     }
342 
343       /**
344         @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
345 
346         @param _x   dividend
347         @param _y   divisor
348 
349         @return quotient
350     */
351     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
352         require(_y > 0);
353         uint256 c = _x / _y;
354 
355         return c;
356     }
357 }
358 
359 // File: contracts/utility/interfaces/IContractRegistry.sol
360 
361 /*
362     Contract Registry interface
363 */
364 contract IContractRegistry {
365     function addressOf(bytes32 _contractName) public view returns (address);
366 
367     // deprecated, backward compatibility
368     function getAddress(bytes32 _contractName) public view returns (address);
369 }
370 
371 // File: contracts/utility/interfaces/IContractFeatures.sol
372 
373 /*
374     Contract Features interface
375 */
376 contract IContractFeatures {
377     function isSupported(address _contract, uint256 _features) public view returns (bool);
378     function enableFeatures(uint256 _features, bool _enable) public;
379 }
380 
381 // File: contracts/token/interfaces/IEtherToken.sol
382 
383 /*
384     Ether Token interface
385 */
386 contract IEtherToken is ITokenHolder, IERC20Token {
387     function deposit() public payable;
388     function withdraw(uint256 _amount) public;
389     function withdrawTo(address _to, uint256 _amount) public;
390 }
391 
392 // File: contracts/token/interfaces/ISmartToken.sol
393 
394 /*
395     Smart Token interface
396 */
397 contract ISmartToken is IOwned, IERC20Token {
398     function disableTransfers(bool _disable) public;
399     function issue(address _to, uint256 _amount) public;
400     function destroy(address _from, uint256 _amount) public;
401 }
402 
403 // File: contracts/bancorx/interfaces/IBancorX.sol
404 
405 contract IBancorX {
406     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
407     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
408 }
409 
410 // File: contracts/BancorNetwork.sol
411 
412 /*
413     The BancorNetwork contract is the main entry point for bancor token conversions.
414     It also allows converting between any token in the bancor network to any other token
415     in a single transaction by providing a conversion path.
416 
417     A note on conversion path -
418     Conversion path is a data structure that's used when converting a token to another token in the bancor network
419     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
420     The path defines which converters should be used and what kind of conversion should be done in each step.
421 
422     The path format doesn't include complex structure and instead, it is represented by a single array
423     in which each 'hop' is represented by a 2-tuple - smart token & to token.
424     In addition, the first element is always the source token.
425     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
426 
427     Format:
428     [source token, smart token, to token, smart token, to token...]
429 */
430 contract BancorNetwork is IBancorNetwork, TokenHolder, ContractIds, FeatureIds {
431     using SafeMath for uint256;
432 
433     
434     uint64 private constant MAX_CONVERSION_FEE = 1000000;
435 
436     address public signerAddress = 0x0;         // verified address that allows conversions with higher gas price
437     IContractRegistry public registry;          // contract registry contract address
438 
439     mapping (address => bool) public etherTokens;       // list of all supported ether tokens
440     mapping (bytes32 => bool) public conversionHashes;  // list of conversion hashes, to prevent re-use of the same hash
441 
442     /**
443         @dev constructor
444 
445         @param _registry    address of a contract registry contract
446     */
447     constructor(IContractRegistry _registry) public validAddress(_registry) {
448         registry = _registry;
449     }
450 
451     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
452     modifier validConversionPath(IERC20Token[] _path) {
453         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
454         _;
455     }
456 
457     /*
458         @dev allows the owner to update the contract registry contract address
459 
460         @param _registry   address of a contract registry contract
461     */
462     function setRegistry(IContractRegistry _registry)
463         public
464         ownerOnly
465         validAddress(_registry)
466         notThis(_registry)
467     {
468         registry = _registry;
469     }
470 
471     /*
472         @dev allows the owner to update the signer address
473 
474         @param _signerAddress    new signer address
475     */
476     function setSignerAddress(address _signerAddress)
477         public
478         ownerOnly
479         validAddress(_signerAddress)
480         notThis(_signerAddress)
481     {
482         signerAddress = _signerAddress;
483     }
484 
485     /**
486         @dev allows the owner to register/unregister ether tokens
487 
488         @param _token       ether token contract address
489         @param _register    true to register, false to unregister
490     */
491     function registerEtherToken(IEtherToken _token, bool _register)
492         public
493         ownerOnly
494         validAddress(_token)
495         notThis(_token)
496     {
497         etherTokens[_token] = _register;
498     }
499 
500     /**
501         @dev verifies that the signer address is trusted by recovering 
502         the address associated with the public key from elliptic 
503         curve signature, returns zero on error.
504         notice that the signature is valid only for one conversion
505         and expires after the give block.
506 
507         @return true if the signer is verified
508     */
509     function verifyTrustedSender(IERC20Token[] _path, uint256 _customVal, uint256 _block, address _addr, uint8 _v, bytes32 _r, bytes32 _s) private returns(bool) {
510         bytes32 hash = keccak256(_block, tx.gasprice, _addr, msg.sender, _customVal, _path);
511 
512         // checking that it is the first conversion with the given signature
513         // and that the current block number doesn't exceeded the maximum block
514         // number that's allowed with the current signature
515         require(!conversionHashes[hash] && block.number <= _block);
516 
517         // recovering the signing address and comparing it to the trusted signer
518         // address that was set in the contract
519         bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", hash);
520         bool verified = ecrecover(prefixedHash, _v, _r, _s) == signerAddress;
521 
522         // if the signer is the trusted signer - mark the hash so that it can't
523         // be used multiple times
524         if (verified)
525             conversionHashes[hash] = true;
526         return verified;
527     }
528 
529     /**
530         @dev validates xConvert call by verifying the path format, claiming the callers tokens (if not ETH),
531         and verifying the gas price limit
532 
533         @param _path        conversion path, see conversion path format above
534         @param _amount      amount to convert from (in the initial source token)
535         @param _block       if the current block exceeded the given parameter - it is cancelled
536         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
537         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
538         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
539     */
540     function validateXConversion(
541         IERC20Token[] _path,
542         uint256 _amount,
543         uint256 _block,
544         uint8 _v,
545         bytes32 _r,
546         bytes32 _s
547     ) 
548         private 
549         validConversionPath(_path)    
550     {
551         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
552         IERC20Token fromToken = _path[0];
553         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
554 
555         // require that the dest token is BNT
556         require(_path[_path.length - 1] == registry.addressOf(ContractIds.BNT_TOKEN));
557 
558         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
559         // otherwise, we claim the tokens from the sender
560         if (msg.value > 0) {
561             IEtherToken(fromToken).deposit.value(msg.value)();
562         } else {
563             assert(fromToken.transferFrom(msg.sender, this, _amount));
564         }
565 
566         // verify gas price limit
567         if (_v == 0x0 && _r == 0x0 && _s == 0x0) {
568             IBancorGasPriceLimit gasPriceLimit = IBancorGasPriceLimit(registry.addressOf(ContractIds.BANCOR_GAS_PRICE_LIMIT));
569             gasPriceLimit.validateGasPrice(tx.gasprice);
570         } else {
571             require(verifyTrustedSender(_path, _amount, _block, msg.sender, _v, _r, _s));
572         }
573     }
574 
575     /**
576         @dev converts the token to any other token in the bancor network by following
577         a predefined conversion path and transfers the result tokens to a target account
578         note that the converter should already own the source tokens
579 
580         @param _path        conversion path, see conversion path format above
581         @param _amount      amount to convert from (in the initial source token)
582         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
583         @param _for         account that will receive the conversion result
584 
585         @return tokens issued in return
586     */
587     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256) {
588         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, 0x0, 0x0, 0x0, 0x0);
589     }
590 
591     /**
592         @dev converts the token to any other token in the bancor network
593         by following a predefined conversion path and transfers the result
594         tokens to a target account.
595         this version of the function also allows the verified signer
596         to bypass the universal gas price limit.
597         note that the converter should already own the source tokens
598 
599         @param _path        conversion path, see conversion path format above
600         @param _amount      amount to convert from (in the initial source token)
601         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
602         @param _for         account that will receive the conversion result
603         @param _customVal   custom value that was signed for prioritized conversion
604         @param _block       if the current block exceeded the given parameter - it is cancelled
605         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
606         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
607         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
608 
609         @return tokens issued in return
610     */
611     function convertForPrioritized3(
612         IERC20Token[] _path,
613         uint256 _amount,
614         uint256 _minReturn,
615         address _for,
616         uint256 _customVal,
617         uint256 _block,
618         uint8 _v,
619         bytes32 _r,
620         bytes32 _s
621     )
622         public
623         payable
624         returns (uint256)
625     {
626         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
627         IERC20Token fromToken = _path[0];
628         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
629 
630         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
631         // otherwise, we assume we already have the tokens
632         if (msg.value > 0)
633             IEtherToken(fromToken).deposit.value(msg.value)();
634 
635         return convertForInternal(_path, _amount, _minReturn, _for, _customVal, _block, _v, _r, _s);
636     }
637 
638     /**
639         @dev converts any other token to BNT in the bancor network
640         by following a predefined conversion path and transfers the resulting
641         tokens to BancorX.
642         note that the network should already have been given allowance of the source token (if not ETH)
643 
644         @param _path             conversion path, see conversion path format above
645         @param _amount           amount to convert from (in the initial source token)
646         @param _minReturn        if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
647         @param _toBlockchain     blockchain BNT will be issued on
648         @param _to               address/account on _toBlockchain to send the BNT to
649         @param _conversionId     pre-determined unique (if non zero) id which refers to this transaction 
650 
651         @return the amount of BNT received from this conversion
652     */
653     function xConvert(
654         IERC20Token[] _path,
655         uint256 _amount,
656         uint256 _minReturn,
657         bytes32 _toBlockchain,
658         bytes32 _to,
659         uint256 _conversionId
660     )
661         public
662         payable
663         returns (uint256)
664     {
665         return xConvertPrioritized(_path, _amount, _minReturn, _toBlockchain, _to, _conversionId, 0x0, 0x0, 0x0, 0x0);
666     }
667 
668     /**
669         @dev converts any other token to BNT in the bancor network
670         by following a predefined conversion path and transfers the resulting
671         tokens to BancorX.
672         this version of the function also allows the verified signer
673         to bypass the universal gas price limit.
674         note that the network should already have been given allowance of the source token (if not ETH)
675 
676         @param _path            conversion path, see conversion path format above
677         @param _amount          amount to convert from (in the initial source token)
678         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
679         @param _toBlockchain    blockchain BNT will be issued on
680         @param _to              address/account on _toBlockchain to send the BNT to
681         @param _conversionId    pre-determined unique (if non zero) id which refers to this transaction 
682         @param _block           if the current block exceeded the given parameter - it is cancelled
683         @param _v               (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
684         @param _r               (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
685         @param _s               (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
686 
687         @return the amount of BNT received from this conversion
688     */
689     function xConvertPrioritized(
690         IERC20Token[] _path,
691         uint256 _amount,
692         uint256 _minReturn,
693         bytes32 _toBlockchain,
694         bytes32 _to,
695         uint256 _conversionId,
696         uint256 _block,
697         uint8 _v,
698         bytes32 _r,
699         bytes32 _s
700     )
701         public
702         payable
703         returns (uint256)
704     {
705         // do a lot of validation and transfers in separate function to work around 16 variable limit
706         validateXConversion(_path, _amount, _block, _v, _r, _s);
707 
708         // convert to BNT and get the resulting amount
709         (, uint256 retAmount) = convertByPath(_path, _amount, _minReturn, _path[0], this);
710 
711         // transfer the resulting amount to BancorX, and return the amount
712         IBancorX(registry.addressOf(ContractIds.BANCOR_X)).xTransfer(_toBlockchain, _to, retAmount, _conversionId);
713 
714         return retAmount;
715     }
716 
717     /**
718         @dev converts token to any other token in the bancor network
719         by following the predefined conversion paths and transfers the result
720         tokens to a targeted account.
721         this version of the function also allows multiple conversions
722         in a single atomic transaction.
723         note that the converter should already own the source tokens
724 
725         @param _paths           merged conversion paths, i.e. [path1, path2, ...]. see conversion path format above
726         @param _pathStartIndex  each item in the array is the start index of the nth path in _paths
727         @param _amounts         amount to convert from (in the initial source token) for each path
728         @param _minReturns      minimum return for each path. if the conversion results in an amount 
729                                 smaller than the minimum return - it is cancelled, must be nonzero
730         @param _for             account that will receive the conversions result
731 
732         @return amount of conversion result for each path
733     */
734     function convertForMultiple(IERC20Token[] _paths, uint256[] _pathStartIndex, uint256[] _amounts, uint256[] _minReturns, address _for)
735         public
736         payable
737         returns (uint256[])
738     {
739         // if ETH is provided, ensure that the total amount was converted into other tokens
740         uint256 convertedValue = 0;
741         uint256 pathEndIndex;
742         
743         // iterate over the conversion paths
744         for (uint256 i = 0; i < _pathStartIndex.length; i += 1) {
745             pathEndIndex = i == (_pathStartIndex.length - 1) ? _paths.length : _pathStartIndex[i + 1];
746 
747             // copy a single path from _paths into an array
748             IERC20Token[] memory path = new IERC20Token[](pathEndIndex - _pathStartIndex[i]);
749             for (uint256 j = _pathStartIndex[i]; j < pathEndIndex; j += 1) {
750                 path[j - _pathStartIndex[i]] = _paths[j];
751             }
752 
753             // if ETH is provided, ensure that the amount is lower than the path amount and
754             // verify that the source token is an ether token. otherwise ensure that 
755             // the source is not an ether token
756             IERC20Token fromToken = path[0];
757             require(msg.value == 0 || (_amounts[i] <= msg.value && etherTokens[fromToken]) || !etherTokens[fromToken]);
758 
759             // if ETH was sent with the call, the source is an ether token - deposit the ETH path amount in it.
760             // otherwise, we assume we already have the tokens
761             if (msg.value > 0 && etherTokens[fromToken]) {
762                 IEtherToken(fromToken).deposit.value(_amounts[i])();
763                 convertedValue += _amounts[i];
764             }
765             _amounts[i] = convertForInternal(path, _amounts[i], _minReturns[i], _for, 0x0, 0x0, 0x0, 0x0, 0x0);
766         }
767 
768         // if ETH was provided, ensure that the full amount was converted
769         require(convertedValue == msg.value);
770 
771         return _amounts;
772     }
773 
774     /**
775         @dev converts token to any other token in the bancor network
776         by following a predefined conversion paths and transfers the result
777         tokens to a target account.
778 
779         @param _path        conversion path, see conversion path format above
780         @param _amount      amount to convert from (in the initial source token)
781         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
782         @param _for         account that will receive the conversion result
783         @param _block       if the current block exceeded the given parameter - it is cancelled
784         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
785         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
786         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
787 
788         @return tokens issued in return
789     */
790     function convertForInternal(
791         IERC20Token[] _path, 
792         uint256 _amount, 
793         uint256 _minReturn, 
794         address _for, 
795         uint256 _customVal,
796         uint256 _block,
797         uint8 _v, 
798         bytes32 _r, 
799         bytes32 _s
800     )
801         private
802         validConversionPath(_path)
803         returns (uint256)
804     {
805         if (_v == 0x0 && _r == 0x0 && _s == 0x0) {
806             IBancorGasPriceLimit gasPriceLimit = IBancorGasPriceLimit(registry.addressOf(ContractIds.BANCOR_GAS_PRICE_LIMIT));
807             gasPriceLimit.validateGasPrice(tx.gasprice);
808         }
809         else {
810             require(verifyTrustedSender(_path, _customVal, _block, _for, _v, _r, _s));
811         }
812 
813         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
814         IERC20Token fromToken = _path[0];
815 
816         IERC20Token toToken;
817         
818         (toToken, _amount) = convertByPath(_path, _amount, _minReturn, fromToken, _for);
819 
820         // finished the conversion, transfer the funds to the target account
821         // if the target token is an ether token, withdraw the tokens and send them as ETH
822         // otherwise, transfer the tokens as is
823         if (etherTokens[toToken])
824             IEtherToken(toToken).withdrawTo(_for, _amount);
825         else
826             assert(toToken.transfer(_for, _amount));
827 
828         return _amount;
829     }
830 
831     /**
832         @dev executes the actual conversion by following the conversion path
833 
834         @param _path        conversion path, see conversion path format above
835         @param _amount      amount to convert from (in the initial source token)
836         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
837         @param _fromToken   ERC20 token to convert from (the first element in the path)
838         @param _for         account that will receive the conversion result
839 
840         @return ERC20 token to convert to (the last element in the path) & tokens issued in return
841     */
842     function convertByPath(
843         IERC20Token[] _path,
844         uint256 _amount,
845         uint256 _minReturn,
846         IERC20Token _fromToken,
847         address _for
848     ) private returns (IERC20Token, uint256) {
849         ISmartToken smartToken;
850         IERC20Token toToken;
851         IBancorConverter converter;
852 
853         // get the contract features address from the registry
854         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
855 
856         // iterate over the conversion path
857         uint256 pathLength = _path.length;
858         for (uint256 i = 1; i < pathLength; i += 2) {
859             smartToken = ISmartToken(_path[i]);
860             toToken = _path[i + 1];
861             converter = IBancorConverter(smartToken.owner());
862             checkWhitelist(converter, _for, features);
863 
864             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
865             if (smartToken != _fromToken)
866                 ensureAllowance(_fromToken, converter, _amount);
867 
868             // make the conversion - if it's the last one, also provide the minimum return value
869             _amount = converter.change(_fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
870             _fromToken = toToken;
871         }
872         return (toToken, _amount);
873     }
874 
875     /**
876         @dev returns the expected return amount for converting a specific amount by following
877         a given conversion path.
878         notice that there is no support for circular paths.
879 
880         @param _path        conversion path, see conversion path format above
881         @param _amount      amount to convert from (in the initial source token)
882 
883         @return expected conversion return amount and conversion fee
884     */
885     function getReturnByPath(IERC20Token[] _path, uint256 _amount) public view returns (uint256, uint256) {
886         IERC20Token fromToken;
887         ISmartToken smartToken; 
888         IERC20Token toToken;
889         IBancorConverter converter;
890         uint256 amount;
891         uint256 fee;
892         uint256 supply;
893         uint256 balance;
894         uint32 weight;
895         ISmartToken prevSmartToken;
896         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
897 
898         amount = _amount;
899         fromToken = _path[0];
900 
901         // iterate over the conversion path
902         for (uint256 i = 1; i < _path.length; i += 2) {
903             smartToken = ISmartToken(_path[i]);
904             toToken = _path[i + 1];
905             converter = IBancorConverter(smartToken.owner());
906 
907             if (toToken == smartToken) { // buy the smart token
908                 // check if the current smart token supply was changed in the previous iteration
909                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
910 
911                 // validate input
912                 require(getConnectorSaleEnabled(converter, fromToken));
913 
914                 // calculate the amount & the conversion fee
915                 balance = converter.getConnectorBalance(fromToken);
916                 weight = getConnectorWeight(converter, fromToken);
917                 amount = formula.calculatePurchaseReturn(supply, balance, weight, amount);
918                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
919                 amount -= fee;
920 
921                 // update the smart token supply for the next iteration
922                 supply = smartToken.totalSupply() + amount;
923             }
924             else if (fromToken == smartToken) { // sell the smart token
925                 // check if the current smart token supply was changed in the previous iteration
926                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
927 
928                 // calculate the amount & the conversion fee
929                 balance = converter.getConnectorBalance(toToken);
930                 weight = getConnectorWeight(converter, toToken);
931                 amount = formula.calculateSaleReturn(supply, balance, weight, amount);
932                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
933                 amount -= fee;
934 
935                 // update the smart token supply for the next iteration
936                 supply = smartToken.totalSupply() - amount;
937             }
938             else { // cross connector conversion
939                 (amount, fee) = converter.getReturn(fromToken, toToken, amount);
940             }
941 
942             prevSmartToken = smartToken;
943             fromToken = toToken;
944         }
945 
946         return (amount, fee);
947     }
948 
949     /**
950         @dev checks whether the given converter supports a whitelist and if so, ensures that
951         the account that should receive the conversion result is actually whitelisted
952 
953         @param _converter   converter to check for whitelist
954         @param _for         account that will receive the conversion result
955         @param _features    contract features contract address
956     */
957     function checkWhitelist(IBancorConverter _converter, address _for, IContractFeatures _features) private view {
958         IWhitelist whitelist;
959 
960         // check if the converter supports the conversion whitelist feature
961         if (!_features.isSupported(_converter, FeatureIds.CONVERTER_CONVERSION_WHITELIST))
962             return;
963 
964         // get the whitelist contract from the converter
965         whitelist = _converter.conversionWhitelist();
966         if (whitelist == address(0))
967             return;
968 
969         // check if the account that should receive the conversion result is actually whitelisted
970         require(whitelist.isWhitelisted(_for));
971     }
972 
973     /**
974         @dev claims the caller's tokens, converts them to any other token in the bancor network
975         by following a predefined conversion path and transfers the result tokens to a target account
976         note that allowance must be set beforehand
977 
978         @param _path        conversion path, see conversion path format above
979         @param _amount      amount to convert from (in the initial source token)
980         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
981         @param _for         account that will receive the conversion result
982 
983         @return tokens issued in return
984     */
985     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
986         // we need to transfer the tokens from the caller to the converter before we follow
987         // the conversion path, to allow it to execute the conversion on behalf of the caller
988         // note: we assume we already have allowance
989         IERC20Token fromToken = _path[0];
990         assert(fromToken.transferFrom(msg.sender, this, _amount));
991         return convertFor(_path, _amount, _minReturn, _for);
992     }
993 
994     /**
995         @dev converts the token to any other token in the bancor network by following
996         a predefined conversion path and transfers the result tokens back to the sender
997         note that the converter should already own the source tokens
998 
999         @param _path        conversion path, see conversion path format above
1000         @param _amount      amount to convert from (in the initial source token)
1001         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1002 
1003         @return tokens issued in return
1004     */
1005     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
1006         return convertFor(_path, _amount, _minReturn, msg.sender);
1007     }
1008 
1009     /**
1010         @dev claims the caller's tokens, converts them to any other token in the bancor network
1011         by following a predefined conversion path and transfers the result tokens back to the sender
1012         note that allowance must be set beforehand
1013 
1014         @param _path        conversion path, see conversion path format above
1015         @param _amount      amount to convert from (in the initial source token)
1016         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1017 
1018         @return tokens issued in return
1019     */
1020     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1021         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
1022     }
1023 
1024     /**
1025         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
1026 
1027         @param _token   token to check the allowance in
1028         @param _spender approved address
1029         @param _value   allowance amount
1030     */
1031     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
1032         // check if allowance for the given amount already exists
1033         if (_token.allowance(this, _spender) >= _value)
1034             return;
1035 
1036         // if the allowance is nonzero, must reset it to 0 first
1037         if (_token.allowance(this, _spender) != 0)
1038             assert(_token.approve(_spender, 0));
1039 
1040         // approve the new allowance
1041         assert(_token.approve(_spender, _value));
1042     }
1043 
1044     /**
1045         @dev returns the connector weight
1046 
1047         @param _converter       converter contract address
1048         @param _connector       connector's address to read from
1049 
1050         @return connector's weight
1051     */
1052     function getConnectorWeight(IBancorConverter _converter, IERC20Token _connector) 
1053         private
1054         view
1055         returns(uint32)
1056     {
1057         uint256 virtualBalance;
1058         uint32 weight;
1059         bool isVirtualBalanceEnabled;
1060         bool isSaleEnabled;
1061         bool isSet;
1062         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1063         return weight;
1064     }
1065 
1066     /**
1067         @dev returns true if connector sale is enabled
1068 
1069         @param _converter       converter contract address
1070         @param _connector       connector's address to read from
1071 
1072         @return true if connector sale is enabled, otherwise - false
1073     */
1074     function getConnectorSaleEnabled(IBancorConverter _converter, IERC20Token _connector) 
1075         private
1076         view
1077         returns(bool)
1078     {
1079         uint256 virtualBalance;
1080         uint32 weight;
1081         bool isVirtualBalanceEnabled;
1082         bool isSaleEnabled;
1083         bool isSet;
1084         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1085         return isSaleEnabled;
1086     }
1087 
1088     // deprecated, backward compatibility
1089     function convertForPrioritized2(
1090         IERC20Token[] _path,
1091         uint256 _amount,
1092         uint256 _minReturn,
1093         address _for,
1094         uint256 _block,
1095         uint8 _v,
1096         bytes32 _r,
1097         bytes32 _s
1098     )
1099         public
1100         payable
1101         returns (uint256)
1102     {
1103         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, _block, _v, _r, _s);
1104     }
1105 
1106     // deprecated, backward compatibility
1107     function convertForPrioritized(
1108         IERC20Token[] _path,
1109         uint256 _amount,
1110         uint256 _minReturn,
1111         address _for,
1112         uint256 _block,
1113         uint256 _nonce,
1114         uint8 _v,
1115         bytes32 _r,
1116         bytes32 _s)
1117         public payable returns (uint256)
1118     {
1119         _nonce;
1120         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, _block, _v, _r, _s);
1121     }
1122 }