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
80     bytes32 public constant NON_STANDARD_TOKEN_REGISTRY = "NonStandardTokenRegistry";
81 
82     // bancor logic
83     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
84     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
85     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
86     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
87     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
88 
89     // BNT core
90     bytes32 public constant BNT_TOKEN = "BNTToken";
91     bytes32 public constant BNT_CONVERTER = "BNTConverter";
92 
93     // BancorX
94     bytes32 public constant BANCOR_X = "BancorX";
95     bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";
96 }
97 
98 // File: contracts/FeatureIds.sol
99 
100 /**
101     Id definitions for bancor contract features
102 
103     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
104 */
105 contract FeatureIds {
106     // converter features
107     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
108 }
109 
110 // File: contracts/utility/interfaces/IWhitelist.sol
111 
112 /*
113     Whitelist interface
114 */
115 contract IWhitelist {
116     function isWhitelisted(address _address) public view returns (bool);
117 }
118 
119 // File: contracts/converter/interfaces/IBancorConverter.sol
120 
121 /*
122     Bancor Converter interface
123 */
124 contract IBancorConverter {
125     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
126     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
127     function conversionWhitelist() public view returns (IWhitelist) {}
128     function conversionFee() public view returns (uint32) {}
129     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }
130     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
131     function claimTokens(address _from, uint256 _amount) public;
132     // deprecated, backward compatibility
133     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
134 }
135 
136 // File: contracts/converter/interfaces/IBancorFormula.sol
137 
138 /*
139     Bancor Formula interface
140 */
141 contract IBancorFormula {
142     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
143     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
144     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
145 }
146 
147 // File: contracts/converter/interfaces/IBancorGasPriceLimit.sol
148 
149 /*
150     Bancor Gas Price Limit interface
151 */
152 contract IBancorGasPriceLimit {
153     function gasPrice() public view returns (uint256) {}
154     function validateGasPrice(uint256) public view;
155 }
156 
157 // File: contracts/utility/interfaces/IOwned.sol
158 
159 /*
160     Owned contract interface
161 */
162 contract IOwned {
163     // this function isn't abstract since the compiler emits automatically generated getter functions as external
164     function owner() public view returns (address) {}
165 
166     function transferOwnership(address _newOwner) public;
167     function acceptOwnership() public;
168 }
169 
170 // File: contracts/utility/Owned.sol
171 
172 /*
173     Provides support and utilities for contract ownership
174 */
175 contract Owned is IOwned {
176     address public owner;
177     address public newOwner;
178 
179     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
180 
181     /**
182         @dev constructor
183     */
184     constructor() public {
185         owner = msg.sender;
186     }
187 
188     // allows execution by the owner only
189     modifier ownerOnly {
190         require(msg.sender == owner);
191         _;
192     }
193 
194     /**
195         @dev allows transferring the contract ownership
196         the new owner still needs to accept the transfer
197         can only be called by the contract owner
198 
199         @param _newOwner    new contract owner
200     */
201     function transferOwnership(address _newOwner) public ownerOnly {
202         require(_newOwner != owner);
203         newOwner = _newOwner;
204     }
205 
206     /**
207         @dev used by a new owner to accept an ownership transfer
208     */
209     function acceptOwnership() public {
210         require(msg.sender == newOwner);
211         emit OwnerUpdate(owner, newOwner);
212         owner = newOwner;
213         newOwner = address(0);
214     }
215 }
216 
217 // File: contracts/utility/Utils.sol
218 
219 /*
220     Utilities & Common Modifiers
221 */
222 contract Utils {
223     /**
224         constructor
225     */
226     constructor() public {
227     }
228 
229     // verifies that an amount is greater than zero
230     modifier greaterThanZero(uint256 _amount) {
231         require(_amount > 0);
232         _;
233     }
234 
235     // validates an address - currently only checks that it isn't null
236     modifier validAddress(address _address) {
237         require(_address != address(0));
238         _;
239     }
240 
241     // verifies that the address is different than this contract address
242     modifier notThis(address _address) {
243         require(_address != address(this));
244         _;
245     }
246 
247 }
248 
249 // File: contracts/utility/interfaces/ITokenHolder.sol
250 
251 /*
252     Token Holder interface
253 */
254 contract ITokenHolder is IOwned {
255     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
256 }
257 
258 // File: contracts/token/interfaces/INonStandardERC20.sol
259 
260 /*
261     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
262 */
263 contract INonStandardERC20 {
264     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
265     function name() public view returns (string) {}
266     function symbol() public view returns (string) {}
267     function decimals() public view returns (uint8) {}
268     function totalSupply() public view returns (uint256) {}
269     function balanceOf(address _owner) public view returns (uint256) { _owner; }
270     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
271 
272     function transfer(address _to, uint256 _value) public;
273     function transferFrom(address _from, address _to, uint256 _value) public;
274     function approve(address _spender, uint256 _value) public;
275 }
276 
277 // File: contracts/utility/TokenHolder.sol
278 
279 /*
280     We consider every contract to be a 'token holder' since it's currently not possible
281     for a contract to deny receiving tokens.
282 
283     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
284     the owner to send tokens that were sent to the contract by mistake back to their sender.
285 
286     Note that we use the non standard ERC-20 interface which has no return value for transfer
287     in order to support both non standard as well as standard token contracts.
288     see https://github.com/ethereum/solidity/issues/4116
289 */
290 contract TokenHolder is ITokenHolder, Owned, Utils {
291     /**
292         @dev constructor
293     */
294     constructor() public {
295     }
296 
297     /**
298         @dev withdraws tokens held by the contract and sends them to an account
299         can only be called by the owner
300 
301         @param _token   ERC20 token contract address
302         @param _to      account to receive the new amount
303         @param _amount  amount to withdraw
304     */
305     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
306         public
307         ownerOnly
308         validAddress(_token)
309         validAddress(_to)
310         notThis(_to)
311     {
312         INonStandardERC20(_token).transfer(_to, _amount);
313     }
314 }
315 
316 // File: contracts/utility/SafeMath.sol
317 
318 /*
319     Library for basic math operations with overflow/underflow protection
320 */
321 library SafeMath {
322     /**
323         @dev returns the sum of _x and _y, reverts if the calculation overflows
324 
325         @param _x   value 1
326         @param _y   value 2
327 
328         @return sum
329     */
330     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
331         uint256 z = _x + _y;
332         require(z >= _x);
333         return z;
334     }
335 
336     /**
337         @dev returns the difference of _x minus _y, reverts if the calculation underflows
338 
339         @param _x   minuend
340         @param _y   subtrahend
341 
342         @return difference
343     */
344     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
345         require(_x >= _y);
346         return _x - _y;
347     }
348 
349     /**
350         @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
351 
352         @param _x   factor 1
353         @param _y   factor 2
354 
355         @return product
356     */
357     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
358         // gas optimization
359         if (_x == 0)
360             return 0;
361 
362         uint256 z = _x * _y;
363         require(z / _x == _y);
364         return z;
365     }
366 
367       /**
368         @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
369 
370         @param _x   dividend
371         @param _y   divisor
372 
373         @return quotient
374     */
375     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
376         require(_y > 0);
377         uint256 c = _x / _y;
378 
379         return c;
380     }
381 }
382 
383 // File: contracts/utility/interfaces/IContractRegistry.sol
384 
385 /*
386     Contract Registry interface
387 */
388 contract IContractRegistry {
389     function addressOf(bytes32 _contractName) public view returns (address);
390 
391     // deprecated, backward compatibility
392     function getAddress(bytes32 _contractName) public view returns (address);
393 }
394 
395 // File: contracts/utility/interfaces/IContractFeatures.sol
396 
397 /*
398     Contract Features interface
399 */
400 contract IContractFeatures {
401     function isSupported(address _contract, uint256 _features) public view returns (bool);
402     function enableFeatures(uint256 _features, bool _enable) public;
403 }
404 
405 // File: contracts/utility/interfaces/IAddressList.sol
406 
407 /*
408     Address list interface
409 */
410 contract IAddressList {
411     mapping (address => bool) public listedAddresses;
412 }
413 
414 // File: contracts/token/interfaces/IEtherToken.sol
415 
416 /*
417     Ether Token interface
418 */
419 contract IEtherToken is ITokenHolder, IERC20Token {
420     function deposit() public payable;
421     function withdraw(uint256 _amount) public;
422     function withdrawTo(address _to, uint256 _amount) public;
423 }
424 
425 // File: contracts/token/interfaces/ISmartToken.sol
426 
427 /*
428     Smart Token interface
429 */
430 contract ISmartToken is IOwned, IERC20Token {
431     function disableTransfers(bool _disable) public;
432     function issue(address _to, uint256 _amount) public;
433     function destroy(address _from, uint256 _amount) public;
434 }
435 
436 // File: contracts/bancorx/interfaces/IBancorX.sol
437 
438 contract IBancorX {
439     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
440     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
441 }
442 
443 // File: contracts/BancorNetwork.sol
444 
445 /*
446     The BancorNetwork contract is the main entry point for bancor token conversions.
447     It also allows converting between any token in the bancor network to any other token
448     in a single transaction by providing a conversion path.
449 
450     A note on conversion path -
451     Conversion path is a data structure that's used when converting a token to another token in the bancor network
452     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
453     The path defines which converters should be used and what kind of conversion should be done in each step.
454 
455     The path format doesn't include complex structure and instead, it is represented by a single array
456     in which each 'hop' is represented by a 2-tuple - smart token & to token.
457     In addition, the first element is always the source token.
458     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
459 
460     Format:
461     [source token, smart token, to token, smart token, to token...]
462 */
463 contract BancorNetwork is IBancorNetwork, TokenHolder, ContractIds, FeatureIds {
464     using SafeMath for uint256;
465 
466     
467     uint64 private constant MAX_CONVERSION_FEE = 1000000;
468 
469     address public signerAddress = 0x0;         // verified address that allows conversions with higher gas price
470     IContractRegistry public registry;          // contract registry contract address
471 
472     mapping (address => bool) public etherTokens;       // list of all supported ether tokens
473     mapping (bytes32 => bool) public conversionHashes;  // list of conversion hashes, to prevent re-use of the same hash
474 
475     /**
476         @dev constructor
477 
478         @param _registry    address of a contract registry contract
479     */
480     constructor(IContractRegistry _registry) public validAddress(_registry) {
481         registry = _registry;
482     }
483 
484     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
485     modifier validConversionPath(IERC20Token[] _path) {
486         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
487         _;
488     }
489 
490     /*
491         @dev allows the owner to update the contract registry contract address
492 
493         @param _registry   address of a contract registry contract
494     */
495     function setRegistry(IContractRegistry _registry)
496         public
497         ownerOnly
498         validAddress(_registry)
499         notThis(_registry)
500     {
501         registry = _registry;
502     }
503 
504     /*
505         @dev allows the owner to update the signer address
506 
507         @param _signerAddress    new signer address
508     */
509     function setSignerAddress(address _signerAddress)
510         public
511         ownerOnly
512         validAddress(_signerAddress)
513         notThis(_signerAddress)
514     {
515         signerAddress = _signerAddress;
516     }
517 
518     /**
519         @dev allows the owner to register/unregister ether tokens
520 
521         @param _token       ether token contract address
522         @param _register    true to register, false to unregister
523     */
524     function registerEtherToken(IEtherToken _token, bool _register)
525         public
526         ownerOnly
527         validAddress(_token)
528         notThis(_token)
529     {
530         etherTokens[_token] = _register;
531     }
532 
533     /**
534         @dev verifies that the signer address is trusted by recovering 
535         the address associated with the public key from elliptic 
536         curve signature, returns zero on error.
537         notice that the signature is valid only for one conversion
538         and expires after the give block.
539 
540         @return true if the signer is verified
541     */
542     function verifyTrustedSender(IERC20Token[] _path, uint256 _customVal, uint256 _block, address _addr, uint8 _v, bytes32 _r, bytes32 _s) private returns(bool) {
543         bytes32 hash = keccak256(_block, tx.gasprice, _addr, msg.sender, _customVal, _path);
544 
545         // checking that it is the first conversion with the given signature
546         // and that the current block number doesn't exceeded the maximum block
547         // number that's allowed with the current signature
548         require(!conversionHashes[hash] && block.number <= _block);
549 
550         // recovering the signing address and comparing it to the trusted signer
551         // address that was set in the contract
552         bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", hash);
553         bool verified = ecrecover(prefixedHash, _v, _r, _s) == signerAddress;
554 
555         // if the signer is the trusted signer - mark the hash so that it can't
556         // be used multiple times
557         if (verified)
558             conversionHashes[hash] = true;
559         return verified;
560     }
561 
562     /**
563         @dev validates xConvert call by verifying the path format, claiming the callers tokens (if not ETH),
564         and verifying the gas price limit
565 
566         @param _path        conversion path, see conversion path format above
567         @param _amount      amount to convert from (in the initial source token)
568         @param _block       if the current block exceeded the given parameter - it is cancelled
569         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
570         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
571         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
572     */
573     function validateXConversion(
574         IERC20Token[] _path,
575         uint256 _amount,
576         uint256 _block,
577         uint8 _v,
578         bytes32 _r,
579         bytes32 _s
580     ) 
581         private 
582         validConversionPath(_path)    
583     {
584         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
585         IERC20Token fromToken = _path[0];
586         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
587 
588         // require that the dest token is BNT
589         require(_path[_path.length - 1] == registry.addressOf(ContractIds.BNT_TOKEN));
590 
591         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
592         // otherwise, we claim the tokens from the sender
593         if (msg.value > 0) {
594             IEtherToken(fromToken).deposit.value(msg.value)();
595         } else {
596             ensureTransferFrom(fromToken, msg.sender, this, _amount);
597         }
598 
599         // verify gas price limit
600         if (_v == 0x0 && _r == 0x0 && _s == 0x0) {
601             IBancorGasPriceLimit gasPriceLimit = IBancorGasPriceLimit(registry.addressOf(ContractIds.BANCOR_GAS_PRICE_LIMIT));
602             gasPriceLimit.validateGasPrice(tx.gasprice);
603         } else {
604             require(verifyTrustedSender(_path, _amount, _block, msg.sender, _v, _r, _s));
605         }
606     }
607 
608     /**
609         @dev converts the token to any other token in the bancor network by following
610         a predefined conversion path and transfers the result tokens to a target account
611         note that the converter should already own the source tokens
612 
613         @param _path        conversion path, see conversion path format above
614         @param _amount      amount to convert from (in the initial source token)
615         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
616         @param _for         account that will receive the conversion result
617 
618         @return tokens issued in return
619     */
620     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256) {
621         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, 0x0, 0x0, 0x0, 0x0);
622     }
623 
624     /**
625         @dev converts the token to any other token in the bancor network
626         by following a predefined conversion path and transfers the result
627         tokens to a target account.
628         this version of the function also allows the verified signer
629         to bypass the universal gas price limit.
630         note that the converter should already own the source tokens
631 
632         @param _path        conversion path, see conversion path format above
633         @param _amount      amount to convert from (in the initial source token)
634         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
635         @param _for         account that will receive the conversion result
636         @param _customVal   custom value that was signed for prioritized conversion
637         @param _block       if the current block exceeded the given parameter - it is cancelled
638         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
639         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
640         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
641 
642         @return tokens issued in return
643     */
644     function convertForPrioritized3(
645         IERC20Token[] _path,
646         uint256 _amount,
647         uint256 _minReturn,
648         address _for,
649         uint256 _customVal,
650         uint256 _block,
651         uint8 _v,
652         bytes32 _r,
653         bytes32 _s
654     )
655         public
656         payable
657         returns (uint256)
658     {
659         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
660         IERC20Token fromToken = _path[0];
661         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
662 
663         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
664         // otherwise, we assume we already have the tokens
665         if (msg.value > 0)
666             IEtherToken(fromToken).deposit.value(msg.value)();
667 
668         return convertForInternal(_path, _amount, _minReturn, _for, _customVal, _block, _v, _r, _s);
669     }
670 
671     /**
672         @dev converts any other token to BNT in the bancor network
673         by following a predefined conversion path and transfers the resulting
674         tokens to BancorX.
675         note that the network should already have been given allowance of the source token (if not ETH)
676 
677         @param _path             conversion path, see conversion path format above
678         @param _amount           amount to convert from (in the initial source token)
679         @param _minReturn        if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
680         @param _toBlockchain     blockchain BNT will be issued on
681         @param _to               address/account on _toBlockchain to send the BNT to
682         @param _conversionId     pre-determined unique (if non zero) id which refers to this transaction 
683 
684         @return the amount of BNT received from this conversion
685     */
686     function xConvert(
687         IERC20Token[] _path,
688         uint256 _amount,
689         uint256 _minReturn,
690         bytes32 _toBlockchain,
691         bytes32 _to,
692         uint256 _conversionId
693     )
694         public
695         payable
696         returns (uint256)
697     {
698         return xConvertPrioritized(_path, _amount, _minReturn, _toBlockchain, _to, _conversionId, 0x0, 0x0, 0x0, 0x0);
699     }
700 
701     /**
702         @dev converts any other token to BNT in the bancor network
703         by following a predefined conversion path and transfers the resulting
704         tokens to BancorX.
705         this version of the function also allows the verified signer
706         to bypass the universal gas price limit.
707         note that the network should already have been given allowance of the source token (if not ETH)
708 
709         @param _path            conversion path, see conversion path format above
710         @param _amount          amount to convert from (in the initial source token)
711         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
712         @param _toBlockchain    blockchain BNT will be issued on
713         @param _to              address/account on _toBlockchain to send the BNT to
714         @param _conversionId    pre-determined unique (if non zero) id which refers to this transaction 
715         @param _block           if the current block exceeded the given parameter - it is cancelled
716         @param _v               (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
717         @param _r               (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
718         @param _s               (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
719 
720         @return the amount of BNT received from this conversion
721     */
722     function xConvertPrioritized(
723         IERC20Token[] _path,
724         uint256 _amount,
725         uint256 _minReturn,
726         bytes32 _toBlockchain,
727         bytes32 _to,
728         uint256 _conversionId,
729         uint256 _block,
730         uint8 _v,
731         bytes32 _r,
732         bytes32 _s
733     )
734         public
735         payable
736         returns (uint256)
737     {
738         // do a lot of validation and transfers in separate function to work around 16 variable limit
739         validateXConversion(_path, _amount, _block, _v, _r, _s);
740 
741         // convert to BNT and get the resulting amount
742         (, uint256 retAmount) = convertByPath(_path, _amount, _minReturn, _path[0], this);
743 
744         // transfer the resulting amount to BancorX, and return the amount
745         IBancorX(registry.addressOf(ContractIds.BANCOR_X)).xTransfer(_toBlockchain, _to, retAmount, _conversionId);
746 
747         return retAmount;
748     }
749 
750     /**
751         @dev converts token to any other token in the bancor network
752         by following a predefined conversion paths and transfers the result
753         tokens to a target account.
754 
755         @param _path        conversion path, see conversion path format above
756         @param _amount      amount to convert from (in the initial source token)
757         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
758         @param _for         account that will receive the conversion result
759         @param _block       if the current block exceeded the given parameter - it is cancelled
760         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
761         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
762         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
763 
764         @return tokens issued in return
765     */
766     function convertForInternal(
767         IERC20Token[] _path, 
768         uint256 _amount, 
769         uint256 _minReturn, 
770         address _for, 
771         uint256 _customVal,
772         uint256 _block,
773         uint8 _v, 
774         bytes32 _r, 
775         bytes32 _s
776     )
777         private
778         validConversionPath(_path)
779         returns (uint256)
780     {
781         if (_v == 0x0 && _r == 0x0 && _s == 0x0) {
782             IBancorGasPriceLimit gasPriceLimit = IBancorGasPriceLimit(registry.addressOf(ContractIds.BANCOR_GAS_PRICE_LIMIT));
783             gasPriceLimit.validateGasPrice(tx.gasprice);
784         }
785         else {
786             require(verifyTrustedSender(_path, _customVal, _block, _for, _v, _r, _s));
787         }
788 
789         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
790         IERC20Token fromToken = _path[0];
791 
792         IERC20Token toToken;
793         
794         (toToken, _amount) = convertByPath(_path, _amount, _minReturn, fromToken, _for);
795 
796         // finished the conversion, transfer the funds to the target account
797         // if the target token is an ether token, withdraw the tokens and send them as ETH
798         // otherwise, transfer the tokens as is
799         if (etherTokens[toToken])
800             IEtherToken(toToken).withdrawTo(_for, _amount);
801         else
802             ensureTransfer(toToken, _for, _amount);
803 
804         return _amount;
805     }
806 
807     /**
808         @dev executes the actual conversion by following the conversion path
809 
810         @param _path        conversion path, see conversion path format above
811         @param _amount      amount to convert from (in the initial source token)
812         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
813         @param _fromToken   ERC20 token to convert from (the first element in the path)
814         @param _for         account that will receive the conversion result
815 
816         @return ERC20 token to convert to (the last element in the path) & tokens issued in return
817     */
818     function convertByPath(
819         IERC20Token[] _path,
820         uint256 _amount,
821         uint256 _minReturn,
822         IERC20Token _fromToken,
823         address _for
824     ) private returns (IERC20Token, uint256) {
825         ISmartToken smartToken;
826         IERC20Token toToken;
827         IBancorConverter converter;
828 
829         // get the contract features address from the registry
830         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
831 
832         // iterate over the conversion path
833         uint256 pathLength = _path.length;
834         for (uint256 i = 1; i < pathLength; i += 2) {
835             smartToken = ISmartToken(_path[i]);
836             toToken = _path[i + 1];
837             converter = IBancorConverter(smartToken.owner());
838             checkWhitelist(converter, _for, features);
839 
840             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
841             if (smartToken != _fromToken)
842                 ensureAllowance(_fromToken, converter, _amount);
843 
844             // make the conversion - if it's the last one, also provide the minimum return value
845             _amount = converter.change(_fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
846             _fromToken = toToken;
847         }
848         return (toToken, _amount);
849     }
850 
851     /**
852         @dev returns the expected return amount for converting a specific amount by following
853         a given conversion path.
854         notice that there is no support for circular paths.
855 
856         @param _path        conversion path, see conversion path format above
857         @param _amount      amount to convert from (in the initial source token)
858 
859         @return expected conversion return amount and conversion fee
860     */
861     function getReturnByPath(IERC20Token[] _path, uint256 _amount) public view returns (uint256, uint256) {
862         IERC20Token fromToken;
863         ISmartToken smartToken; 
864         IERC20Token toToken;
865         IBancorConverter converter;
866         uint256 amount;
867         uint256 fee;
868         uint256 supply;
869         uint256 balance;
870         uint32 weight;
871         ISmartToken prevSmartToken;
872         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
873 
874         amount = _amount;
875         fromToken = _path[0];
876 
877         // iterate over the conversion path
878         for (uint256 i = 1; i < _path.length; i += 2) {
879             smartToken = ISmartToken(_path[i]);
880             toToken = _path[i + 1];
881             converter = IBancorConverter(smartToken.owner());
882 
883             if (toToken == smartToken) { // buy the smart token
884                 // check if the current smart token supply was changed in the previous iteration
885                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
886 
887                 // validate input
888                 require(getConnectorSaleEnabled(converter, fromToken));
889 
890                 // calculate the amount & the conversion fee
891                 balance = converter.getConnectorBalance(fromToken);
892                 weight = getConnectorWeight(converter, fromToken);
893                 amount = formula.calculatePurchaseReturn(supply, balance, weight, amount);
894                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
895                 amount -= fee;
896 
897                 // update the smart token supply for the next iteration
898                 supply = smartToken.totalSupply() + amount;
899             }
900             else if (fromToken == smartToken) { // sell the smart token
901                 // check if the current smart token supply was changed in the previous iteration
902                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
903 
904                 // calculate the amount & the conversion fee
905                 balance = converter.getConnectorBalance(toToken);
906                 weight = getConnectorWeight(converter, toToken);
907                 amount = formula.calculateSaleReturn(supply, balance, weight, amount);
908                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
909                 amount -= fee;
910 
911                 // update the smart token supply for the next iteration
912                 supply = smartToken.totalSupply() - amount;
913             }
914             else { // cross connector conversion
915                 (amount, fee) = converter.getReturn(fromToken, toToken, amount);
916             }
917 
918             prevSmartToken = smartToken;
919             fromToken = toToken;
920         }
921 
922         return (amount, fee);
923     }
924 
925     /**
926         @dev checks whether the given converter supports a whitelist and if so, ensures that
927         the account that should receive the conversion result is actually whitelisted
928 
929         @param _converter   converter to check for whitelist
930         @param _for         account that will receive the conversion result
931         @param _features    contract features contract address
932     */
933     function checkWhitelist(IBancorConverter _converter, address _for, IContractFeatures _features) private view {
934         IWhitelist whitelist;
935 
936         // check if the converter supports the conversion whitelist feature
937         if (!_features.isSupported(_converter, FeatureIds.CONVERTER_CONVERSION_WHITELIST))
938             return;
939 
940         // get the whitelist contract from the converter
941         whitelist = _converter.conversionWhitelist();
942         if (whitelist == address(0))
943             return;
944 
945         // check if the account that should receive the conversion result is actually whitelisted
946         require(whitelist.isWhitelisted(_for));
947     }
948 
949     /**
950         @dev claims the caller's tokens, converts them to any other token in the bancor network
951         by following a predefined conversion path and transfers the result tokens to a target account
952         note that allowance must be set beforehand
953 
954         @param _path        conversion path, see conversion path format above
955         @param _amount      amount to convert from (in the initial source token)
956         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
957         @param _for         account that will receive the conversion result
958 
959         @return tokens issued in return
960     */
961     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
962         // we need to transfer the tokens from the caller to the converter before we follow
963         // the conversion path, to allow it to execute the conversion on behalf of the caller
964         // note: we assume we already have allowance
965         IERC20Token fromToken = _path[0];
966         ensureTransferFrom(fromToken, msg.sender, this, _amount);
967         return convertFor(_path, _amount, _minReturn, _for);
968     }
969 
970     /**
971         @dev converts the token to any other token in the bancor network by following
972         a predefined conversion path and transfers the result tokens back to the sender
973         note that the converter should already own the source tokens
974 
975         @param _path        conversion path, see conversion path format above
976         @param _amount      amount to convert from (in the initial source token)
977         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
978 
979         @return tokens issued in return
980     */
981     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
982         return convertFor(_path, _amount, _minReturn, msg.sender);
983     }
984 
985     /**
986         @dev claims the caller's tokens, converts them to any other token in the bancor network
987         by following a predefined conversion path and transfers the result tokens back to the sender
988         note that allowance must be set beforehand
989 
990         @param _path        conversion path, see conversion path format above
991         @param _amount      amount to convert from (in the initial source token)
992         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
993 
994         @return tokens issued in return
995     */
996     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
997         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
998     }
999 
1000     /**
1001         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1002         true on success but revert on failure instead
1003 
1004         @param _token     the token to transfer
1005         @param _to        the address to transfer the tokens to
1006         @param _amount    the amount to transfer
1007     */
1008     function ensureTransfer(IERC20Token _token, address _to, uint256 _amount) private {
1009         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1010 
1011         if (addressList.listedAddresses(_token)) {
1012             uint256 prevBalance = _token.balanceOf(_to);
1013             // we have to cast the token contract in an interface which has no return value
1014             INonStandardERC20(_token).transfer(_to, _amount);
1015             uint256 postBalance = _token.balanceOf(_to);
1016             assert(postBalance > prevBalance);
1017         } else {
1018             // if the token isn't whitelisted, we assert on transfer
1019             assert(_token.transfer(_to, _amount));
1020         }
1021     }
1022 
1023     /**
1024         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1025         true on success but revert on failure instead
1026 
1027         @param _token     the token to transfer
1028         @param _from      the address to transfer the tokens from
1029         @param _to        the address to transfer the tokens to
1030         @param _amount    the amount to transfer
1031     */
1032     function ensureTransferFrom(IERC20Token _token, address _from, address _to, uint256 _amount) private {
1033         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1034 
1035         if (addressList.listedAddresses(_token)) {
1036             uint256 prevBalance = _token.balanceOf(_to);
1037             // we have to cast the token contract in an interface which has no return value
1038             INonStandardERC20(_token).transferFrom(_from, _to, _amount);
1039             uint256 postBalance = _token.balanceOf(_to);
1040             assert(postBalance > prevBalance);
1041         } else {
1042             // if the token isn't whitelisted, we assert on transfer
1043             assert(_token.transferFrom(_from, _to, _amount));
1044         }
1045     }
1046 
1047     /**
1048         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
1049         Note that we use the non standard erc-20 interface in which `approve` has no return value so that
1050         this function will work for both standard and non standard tokens
1051 
1052         @param _token   token to check the allowance in
1053         @param _spender approved address
1054         @param _value   allowance amount
1055     */
1056     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
1057         // check if allowance for the given amount already exists
1058         if (_token.allowance(this, _spender) >= _value)
1059             return;
1060 
1061         // if the allowance is nonzero, must reset it to 0 first
1062         if (_token.allowance(this, _spender) != 0)
1063             INonStandardERC20(_token).approve(_spender, 0);
1064 
1065         // approve the new allowance
1066         INonStandardERC20(_token).approve(_spender, _value);
1067     }
1068 
1069     /**
1070         @dev returns the connector weight
1071 
1072         @param _converter       converter contract address
1073         @param _connector       connector's address to read from
1074 
1075         @return connector's weight
1076     */
1077     function getConnectorWeight(IBancorConverter _converter, IERC20Token _connector) 
1078         private
1079         view
1080         returns(uint32)
1081     {
1082         uint256 virtualBalance;
1083         uint32 weight;
1084         bool isVirtualBalanceEnabled;
1085         bool isSaleEnabled;
1086         bool isSet;
1087         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1088         return weight;
1089     }
1090 
1091     /**
1092         @dev returns true if connector sale is enabled
1093 
1094         @param _converter       converter contract address
1095         @param _connector       connector's address to read from
1096 
1097         @return true if connector sale is enabled, otherwise - false
1098     */
1099     function getConnectorSaleEnabled(IBancorConverter _converter, IERC20Token _connector) 
1100         private
1101         view
1102         returns(bool)
1103     {
1104         uint256 virtualBalance;
1105         uint32 weight;
1106         bool isVirtualBalanceEnabled;
1107         bool isSaleEnabled;
1108         bool isSet;
1109         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1110         return isSaleEnabled;
1111     }
1112 
1113     // deprecated, backward compatibility
1114     function convertForPrioritized2(
1115         IERC20Token[] _path,
1116         uint256 _amount,
1117         uint256 _minReturn,
1118         address _for,
1119         uint256 _block,
1120         uint8 _v,
1121         bytes32 _r,
1122         bytes32 _s
1123     )
1124         public
1125         payable
1126         returns (uint256)
1127     {
1128         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, _block, _v, _r, _s);
1129     }
1130 
1131     // deprecated, backward compatibility
1132     function convertForPrioritized(
1133         IERC20Token[] _path,
1134         uint256 _amount,
1135         uint256 _minReturn,
1136         address _for,
1137         uint256 _block,
1138         uint256 _nonce,
1139         uint8 _v,
1140         bytes32 _r,
1141         bytes32 _s)
1142         public payable returns (uint256)
1143     {
1144         _nonce;
1145         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, _block, _v, _r, _s);
1146     }
1147 }