1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, January 29, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 // File: contracts/token/interfaces/IERC20Token.sol
8 
9 /*
10     ERC20 Standard Token interface
11 */
12 contract IERC20Token {
13     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
14     function name() public view returns (string) {}
15     function symbol() public view returns (string) {}
16     function decimals() public view returns (uint8) {}
17     function totalSupply() public view returns (uint256) {}
18     function balanceOf(address _owner) public view returns (uint256) { _owner; }
19     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
20 
21     function transfer(address _to, uint256 _value) public returns (bool success);
22     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
23     function approve(address _spender, uint256 _value) public returns (bool success);
24 }
25 
26 // File: contracts/IBancorNetwork.sol
27 
28 /*
29     Bancor Network interface
30 */
31 contract IBancorNetwork {
32     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
33     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
34     
35     function convertForPrioritized3(
36         IERC20Token[] _path,
37         uint256 _amount,
38         uint256 _minReturn,
39         address _for,
40         uint256 _customVal,
41         uint256 _block,
42         uint8 _v,
43         bytes32 _r,
44         bytes32 _s
45     ) public payable returns (uint256);
46     
47     // deprecated, backward compatibility
48     function convertForPrioritized2(
49         IERC20Token[] _path,
50         uint256 _amount,
51         uint256 _minReturn,
52         address _for,
53         uint256 _block,
54         uint8 _v,
55         bytes32 _r,
56         bytes32 _s
57     ) public payable returns (uint256);
58 
59     // deprecated, backward compatibility
60     function convertForPrioritized(
61         IERC20Token[] _path,
62         uint256 _amount,
63         uint256 _minReturn,
64         address _for,
65         uint256 _block,
66         uint256 _nonce,
67         uint8 _v,
68         bytes32 _r,
69         bytes32 _s
70     ) public payable returns (uint256);
71 }
72 
73 // File: contracts/ContractIds.sol
74 
75 /**
76     Id definitions for bancor contracts
77 
78     Can be used in conjunction with the contract registry to get contract addresses
79 */
80 contract ContractIds {
81     // generic
82     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
83     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
84     bytes32 public constant NON_STANDARD_TOKEN_REGISTRY = "NonStandardTokenRegistry";
85 
86     // bancor logic
87     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
88     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
89     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
90     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
91     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
92 
93     // BNT core
94     bytes32 public constant BNT_TOKEN = "BNTToken";
95     bytes32 public constant BNT_CONVERTER = "BNTConverter";
96 
97     // BancorX
98     bytes32 public constant BANCOR_X = "BancorX";
99     bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";
100 }
101 
102 // File: contracts/FeatureIds.sol
103 
104 /**
105     Id definitions for bancor contract features
106 
107     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
108 */
109 contract FeatureIds {
110     // converter features
111     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
112 }
113 
114 // File: contracts/utility/interfaces/IWhitelist.sol
115 
116 /*
117     Whitelist interface
118 */
119 contract IWhitelist {
120     function isWhitelisted(address _address) public view returns (bool);
121 }
122 
123 // File: contracts/converter/interfaces/IBancorConverter.sol
124 
125 /*
126     Bancor Converter interface
127 */
128 contract IBancorConverter {
129     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
130     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
131     function conversionWhitelist() public view returns (IWhitelist) {}
132     function conversionFee() public view returns (uint32) {}
133     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }
134     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
135     function claimTokens(address _from, uint256 _amount) public;
136     // deprecated, backward compatibility
137     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
138 }
139 
140 // File: contracts/converter/interfaces/IBancorFormula.sol
141 
142 /*
143     Bancor Formula interface
144 */
145 contract IBancorFormula {
146     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
147     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
148     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
149 }
150 
151 // File: contracts/converter/interfaces/IBancorGasPriceLimit.sol
152 
153 /*
154     Bancor Gas Price Limit interface
155 */
156 contract IBancorGasPriceLimit {
157     function gasPrice() public view returns (uint256) {}
158     function validateGasPrice(uint256) public view;
159 }
160 
161 // File: contracts/utility/interfaces/IOwned.sol
162 
163 /*
164     Owned contract interface
165 */
166 contract IOwned {
167     // this function isn't abstract since the compiler emits automatically generated getter functions as external
168     function owner() public view returns (address) {}
169 
170     function transferOwnership(address _newOwner) public;
171     function acceptOwnership() public;
172 }
173 
174 // File: contracts/utility/Owned.sol
175 
176 /*
177     Provides support and utilities for contract ownership
178 */
179 contract Owned is IOwned {
180     address public owner;
181     address public newOwner;
182 
183     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
184 
185     /**
186         @dev constructor
187     */
188     constructor() public {
189         owner = msg.sender;
190     }
191 
192     // allows execution by the owner only
193     modifier ownerOnly {
194         require(msg.sender == owner);
195         _;
196     }
197 
198     /**
199         @dev allows transferring the contract ownership
200         the new owner still needs to accept the transfer
201         can only be called by the contract owner
202 
203         @param _newOwner    new contract owner
204     */
205     function transferOwnership(address _newOwner) public ownerOnly {
206         require(_newOwner != owner);
207         newOwner = _newOwner;
208     }
209 
210     /**
211         @dev used by a new owner to accept an ownership transfer
212     */
213     function acceptOwnership() public {
214         require(msg.sender == newOwner);
215         emit OwnerUpdate(owner, newOwner);
216         owner = newOwner;
217         newOwner = address(0);
218     }
219 }
220 
221 // File: contracts/utility/Utils.sol
222 
223 /*
224     Utilities & Common Modifiers
225 */
226 contract Utils {
227     /**
228         constructor
229     */
230     constructor() public {
231     }
232 
233     // verifies that an amount is greater than zero
234     modifier greaterThanZero(uint256 _amount) {
235         require(_amount > 0);
236         _;
237     }
238 
239     // validates an address - currently only checks that it isn't null
240     modifier validAddress(address _address) {
241         require(_address != address(0));
242         _;
243     }
244 
245     // verifies that the address is different than this contract address
246     modifier notThis(address _address) {
247         require(_address != address(this));
248         _;
249     }
250 
251 }
252 
253 // File: contracts/utility/interfaces/ITokenHolder.sol
254 
255 /*
256     Token Holder interface
257 */
258 contract ITokenHolder is IOwned {
259     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
260 }
261 
262 // File: contracts/token/interfaces/INonStandardERC20.sol
263 
264 /*
265     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
266 */
267 contract INonStandardERC20 {
268     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
269     function name() public view returns (string) {}
270     function symbol() public view returns (string) {}
271     function decimals() public view returns (uint8) {}
272     function totalSupply() public view returns (uint256) {}
273     function balanceOf(address _owner) public view returns (uint256) { _owner; }
274     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
275 
276     function transfer(address _to, uint256 _value) public;
277     function transferFrom(address _from, address _to, uint256 _value) public;
278     function approve(address _spender, uint256 _value) public;
279 }
280 
281 // File: contracts/utility/TokenHolder.sol
282 
283 /*
284     We consider every contract to be a 'token holder' since it's currently not possible
285     for a contract to deny receiving tokens.
286 
287     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
288     the owner to send tokens that were sent to the contract by mistake back to their sender.
289 
290     Note that we use the non standard ERC-20 interface which has no return value for transfer
291     in order to support both non standard as well as standard token contracts.
292     see https://github.com/ethereum/solidity/issues/4116
293 */
294 contract TokenHolder is ITokenHolder, Owned, Utils {
295     /**
296         @dev constructor
297     */
298     constructor() public {
299     }
300 
301     /**
302         @dev withdraws tokens held by the contract and sends them to an account
303         can only be called by the owner
304 
305         @param _token   ERC20 token contract address
306         @param _to      account to receive the new amount
307         @param _amount  amount to withdraw
308     */
309     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
310         public
311         ownerOnly
312         validAddress(_token)
313         validAddress(_to)
314         notThis(_to)
315     {
316         INonStandardERC20(_token).transfer(_to, _amount);
317     }
318 }
319 
320 // File: contracts/utility/SafeMath.sol
321 
322 /*
323     Library for basic math operations with overflow/underflow protection
324 */
325 library SafeMath {
326     /**
327         @dev returns the sum of _x and _y, reverts if the calculation overflows
328 
329         @param _x   value 1
330         @param _y   value 2
331 
332         @return sum
333     */
334     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
335         uint256 z = _x + _y;
336         require(z >= _x);
337         return z;
338     }
339 
340     /**
341         @dev returns the difference of _x minus _y, reverts if the calculation underflows
342 
343         @param _x   minuend
344         @param _y   subtrahend
345 
346         @return difference
347     */
348     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
349         require(_x >= _y);
350         return _x - _y;
351     }
352 
353     /**
354         @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
355 
356         @param _x   factor 1
357         @param _y   factor 2
358 
359         @return product
360     */
361     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
362         // gas optimization
363         if (_x == 0)
364             return 0;
365 
366         uint256 z = _x * _y;
367         require(z / _x == _y);
368         return z;
369     }
370 
371       /**
372         @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
373 
374         @param _x   dividend
375         @param _y   divisor
376 
377         @return quotient
378     */
379     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
380         require(_y > 0);
381         uint256 c = _x / _y;
382 
383         return c;
384     }
385 }
386 
387 // File: contracts/utility/interfaces/IContractRegistry.sol
388 
389 /*
390     Contract Registry interface
391 */
392 contract IContractRegistry {
393     function addressOf(bytes32 _contractName) public view returns (address);
394 
395     // deprecated, backward compatibility
396     function getAddress(bytes32 _contractName) public view returns (address);
397 }
398 
399 // File: contracts/utility/interfaces/IContractFeatures.sol
400 
401 /*
402     Contract Features interface
403 */
404 contract IContractFeatures {
405     function isSupported(address _contract, uint256 _features) public view returns (bool);
406     function enableFeatures(uint256 _features, bool _enable) public;
407 }
408 
409 // File: contracts/utility/interfaces/IAddressList.sol
410 
411 /*
412     Address list interface
413 */
414 contract IAddressList {
415     mapping (address => bool) public listedAddresses;
416 }
417 
418 // File: contracts/token/interfaces/IEtherToken.sol
419 
420 /*
421     Ether Token interface
422 */
423 contract IEtherToken is ITokenHolder, IERC20Token {
424     function deposit() public payable;
425     function withdraw(uint256 _amount) public;
426     function withdrawTo(address _to, uint256 _amount) public;
427 }
428 
429 // File: contracts/token/interfaces/ISmartToken.sol
430 
431 /*
432     Smart Token interface
433 */
434 contract ISmartToken is IOwned, IERC20Token {
435     function disableTransfers(bool _disable) public;
436     function issue(address _to, uint256 _amount) public;
437     function destroy(address _from, uint256 _amount) public;
438 }
439 
440 // File: contracts/bancorx/interfaces/IBancorX.sol
441 
442 contract IBancorX {
443     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
444     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
445 }
446 
447 // File: contracts/BancorNetwork.sol
448 
449 /*
450     The BancorNetwork contract is the main entry point for bancor token conversions.
451     It also allows converting between any token in the bancor network to any other token
452     in a single transaction by providing a conversion path.
453 
454     A note on conversion path -
455     Conversion path is a data structure that's used when converting a token to another token in the bancor network
456     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
457     The path defines which converters should be used and what kind of conversion should be done in each step.
458 
459     The path format doesn't include complex structure and instead, it is represented by a single array
460     in which each 'hop' is represented by a 2-tuple - smart token & to token.
461     In addition, the first element is always the source token.
462     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
463 
464     Format:
465     [source token, smart token, to token, smart token, to token...]
466 */
467 contract BancorNetwork is IBancorNetwork, TokenHolder, ContractIds, FeatureIds {
468     using SafeMath for uint256;
469 
470     
471     uint64 private constant MAX_CONVERSION_FEE = 1000000;
472 
473     address public signerAddress = 0x0;         // verified address that allows conversions with higher gas price
474     IContractRegistry public registry;          // contract registry contract address
475 
476     mapping (address => bool) public etherTokens;       // list of all supported ether tokens
477     mapping (bytes32 => bool) public conversionHashes;  // list of conversion hashes, to prevent re-use of the same hash
478 
479     /**
480         @dev constructor
481 
482         @param _registry    address of a contract registry contract
483     */
484     constructor(IContractRegistry _registry) public validAddress(_registry) {
485         registry = _registry;
486     }
487 
488     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
489     modifier validConversionPath(IERC20Token[] _path) {
490         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
491         _;
492     }
493 
494     /*
495         @dev allows the owner to update the contract registry contract address
496 
497         @param _registry   address of a contract registry contract
498     */
499     function setRegistry(IContractRegistry _registry)
500         public
501         ownerOnly
502         validAddress(_registry)
503         notThis(_registry)
504     {
505         registry = _registry;
506     }
507 
508     /*
509         @dev allows the owner to update the signer address
510 
511         @param _signerAddress    new signer address
512     */
513     function setSignerAddress(address _signerAddress)
514         public
515         ownerOnly
516         validAddress(_signerAddress)
517         notThis(_signerAddress)
518     {
519         signerAddress = _signerAddress;
520     }
521 
522     /**
523         @dev allows the owner to register/unregister ether tokens
524 
525         @param _token       ether token contract address
526         @param _register    true to register, false to unregister
527     */
528     function registerEtherToken(IEtherToken _token, bool _register)
529         public
530         ownerOnly
531         validAddress(_token)
532         notThis(_token)
533     {
534         etherTokens[_token] = _register;
535     }
536 
537     /**
538         @dev verifies that the signer address is trusted by recovering 
539         the address associated with the public key from elliptic 
540         curve signature, returns zero on error.
541         notice that the signature is valid only for one conversion
542         and expires after the give block.
543 
544         @return true if the signer is verified
545     */
546     function verifyTrustedSender(IERC20Token[] _path, uint256 _customVal, uint256 _block, address _addr, uint8 _v, bytes32 _r, bytes32 _s) private returns(bool) {
547         bytes32 hash = keccak256(_block, tx.gasprice, _addr, msg.sender, _customVal, _path);
548 
549         // checking that it is the first conversion with the given signature
550         // and that the current block number doesn't exceeded the maximum block
551         // number that's allowed with the current signature
552         require(!conversionHashes[hash] && block.number <= _block);
553 
554         // recovering the signing address and comparing it to the trusted signer
555         // address that was set in the contract
556         bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", hash);
557         bool verified = ecrecover(prefixedHash, _v, _r, _s) == signerAddress;
558 
559         // if the signer is the trusted signer - mark the hash so that it can't
560         // be used multiple times
561         if (verified)
562             conversionHashes[hash] = true;
563         return verified;
564     }
565 
566     /**
567         @dev validates xConvert call by verifying the path format, claiming the callers tokens (if not ETH),
568         and verifying the gas price limit
569 
570         @param _path        conversion path, see conversion path format above
571         @param _amount      amount to convert from (in the initial source token)
572         @param _block       if the current block exceeded the given parameter - it is cancelled
573         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
574         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
575         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
576     */
577     function validateXConversion(
578         IERC20Token[] _path,
579         uint256 _amount,
580         uint256 _block,
581         uint8 _v,
582         bytes32 _r,
583         bytes32 _s
584     ) 
585         private 
586         validConversionPath(_path)    
587     {
588         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
589         IERC20Token fromToken = _path[0];
590         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
591 
592         // require that the dest token is BNT
593         require(_path[_path.length - 1] == registry.addressOf(ContractIds.BNT_TOKEN));
594 
595         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
596         // otherwise, we claim the tokens from the sender
597         if (msg.value > 0) {
598             IEtherToken(fromToken).deposit.value(msg.value)();
599         } else {
600             ensureTransferFrom(fromToken, msg.sender, this, _amount);
601         }
602 
603         // verify gas price limit
604         if (_v == 0x0 && _r == 0x0 && _s == 0x0) {
605             IBancorGasPriceLimit gasPriceLimit = IBancorGasPriceLimit(registry.addressOf(ContractIds.BANCOR_GAS_PRICE_LIMIT));
606             gasPriceLimit.validateGasPrice(tx.gasprice);
607         } else {
608             require(verifyTrustedSender(_path, _amount, _block, msg.sender, _v, _r, _s));
609         }
610     }
611 
612     /**
613         @dev converts the token to any other token in the bancor network by following
614         a predefined conversion path and transfers the result tokens to a target account
615         note that the converter should already own the source tokens
616 
617         @param _path        conversion path, see conversion path format above
618         @param _amount      amount to convert from (in the initial source token)
619         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
620         @param _for         account that will receive the conversion result
621 
622         @return tokens issued in return
623     */
624     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256) {
625         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, 0x0, 0x0, 0x0, 0x0);
626     }
627 
628     /**
629         @dev converts the token to any other token in the bancor network
630         by following a predefined conversion path and transfers the result
631         tokens to a target account.
632         this version of the function also allows the verified signer
633         to bypass the universal gas price limit.
634         note that the converter should already own the source tokens
635 
636         @param _path        conversion path, see conversion path format above
637         @param _amount      amount to convert from (in the initial source token)
638         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
639         @param _for         account that will receive the conversion result
640         @param _customVal   custom value that was signed for prioritized conversion
641         @param _block       if the current block exceeded the given parameter - it is cancelled
642         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
643         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
644         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
645 
646         @return tokens issued in return
647     */
648     function convertForPrioritized3(
649         IERC20Token[] _path,
650         uint256 _amount,
651         uint256 _minReturn,
652         address _for,
653         uint256 _customVal,
654         uint256 _block,
655         uint8 _v,
656         bytes32 _r,
657         bytes32 _s
658     )
659         public
660         payable
661         returns (uint256)
662     {
663         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
664         IERC20Token fromToken = _path[0];
665         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
666 
667         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
668         // otherwise, we assume we already have the tokens
669         if (msg.value > 0)
670             IEtherToken(fromToken).deposit.value(msg.value)();
671 
672         return convertForInternal(_path, _amount, _minReturn, _for, _customVal, _block, _v, _r, _s);
673     }
674 
675     /**
676         @dev converts any other token to BNT in the bancor network
677         by following a predefined conversion path and transfers the resulting
678         tokens to BancorX.
679         note that the network should already have been given allowance of the source token (if not ETH)
680 
681         @param _path             conversion path, see conversion path format above
682         @param _amount           amount to convert from (in the initial source token)
683         @param _minReturn        if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
684         @param _toBlockchain     blockchain BNT will be issued on
685         @param _to               address/account on _toBlockchain to send the BNT to
686         @param _conversionId     pre-determined unique (if non zero) id which refers to this transaction 
687 
688         @return the amount of BNT received from this conversion
689     */
690     function xConvert(
691         IERC20Token[] _path,
692         uint256 _amount,
693         uint256 _minReturn,
694         bytes32 _toBlockchain,
695         bytes32 _to,
696         uint256 _conversionId
697     )
698         public
699         payable
700         returns (uint256)
701     {
702         return xConvertPrioritized(_path, _amount, _minReturn, _toBlockchain, _to, _conversionId, 0x0, 0x0, 0x0, 0x0);
703     }
704 
705     /**
706         @dev converts any other token to BNT in the bancor network
707         by following a predefined conversion path and transfers the resulting
708         tokens to BancorX.
709         this version of the function also allows the verified signer
710         to bypass the universal gas price limit.
711         note that the network should already have been given allowance of the source token (if not ETH)
712 
713         @param _path            conversion path, see conversion path format above
714         @param _amount          amount to convert from (in the initial source token)
715         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
716         @param _toBlockchain    blockchain BNT will be issued on
717         @param _to              address/account on _toBlockchain to send the BNT to
718         @param _conversionId    pre-determined unique (if non zero) id which refers to this transaction 
719         @param _block           if the current block exceeded the given parameter - it is cancelled
720         @param _v               (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
721         @param _r               (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
722         @param _s               (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
723 
724         @return the amount of BNT received from this conversion
725     */
726     function xConvertPrioritized(
727         IERC20Token[] _path,
728         uint256 _amount,
729         uint256 _minReturn,
730         bytes32 _toBlockchain,
731         bytes32 _to,
732         uint256 _conversionId,
733         uint256 _block,
734         uint8 _v,
735         bytes32 _r,
736         bytes32 _s
737     )
738         public
739         payable
740         returns (uint256)
741     {
742         // do a lot of validation and transfers in separate function to work around 16 variable limit
743         validateXConversion(_path, _amount, _block, _v, _r, _s);
744 
745         // convert to BNT and get the resulting amount
746         (, uint256 retAmount) = convertByPath(_path, _amount, _minReturn, _path[0], this);
747 
748         // transfer the resulting amount to BancorX, and return the amount
749         IBancorX(registry.addressOf(ContractIds.BANCOR_X)).xTransfer(_toBlockchain, _to, retAmount, _conversionId);
750 
751         return retAmount;
752     }
753 
754     /**
755         @dev converts token to any other token in the bancor network
756         by following a predefined conversion paths and transfers the result
757         tokens to a target account.
758 
759         @param _path        conversion path, see conversion path format above
760         @param _amount      amount to convert from (in the initial source token)
761         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
762         @param _for         account that will receive the conversion result
763         @param _block       if the current block exceeded the given parameter - it is cancelled
764         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
765         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
766         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
767 
768         @return tokens issued in return
769     */
770     function convertForInternal(
771         IERC20Token[] _path, 
772         uint256 _amount, 
773         uint256 _minReturn, 
774         address _for, 
775         uint256 _customVal,
776         uint256 _block,
777         uint8 _v, 
778         bytes32 _r, 
779         bytes32 _s
780     )
781         private
782         validConversionPath(_path)
783         returns (uint256)
784     {
785         if (_v == 0x0 && _r == 0x0 && _s == 0x0) {
786             IBancorGasPriceLimit gasPriceLimit = IBancorGasPriceLimit(registry.addressOf(ContractIds.BANCOR_GAS_PRICE_LIMIT));
787             gasPriceLimit.validateGasPrice(tx.gasprice);
788         }
789         else {
790             require(verifyTrustedSender(_path, _customVal, _block, _for, _v, _r, _s));
791         }
792 
793         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
794         IERC20Token fromToken = _path[0];
795 
796         IERC20Token toToken;
797         
798         (toToken, _amount) = convertByPath(_path, _amount, _minReturn, fromToken, _for);
799 
800         // finished the conversion, transfer the funds to the target account
801         // if the target token is an ether token, withdraw the tokens and send them as ETH
802         // otherwise, transfer the tokens as is
803         if (etherTokens[toToken])
804             IEtherToken(toToken).withdrawTo(_for, _amount);
805         else
806             ensureTransfer(toToken, _for, _amount);
807 
808         return _amount;
809     }
810 
811     /**
812         @dev executes the actual conversion by following the conversion path
813 
814         @param _path        conversion path, see conversion path format above
815         @param _amount      amount to convert from (in the initial source token)
816         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
817         @param _fromToken   ERC20 token to convert from (the first element in the path)
818         @param _for         account that will receive the conversion result
819 
820         @return ERC20 token to convert to (the last element in the path) & tokens issued in return
821     */
822     function convertByPath(
823         IERC20Token[] _path,
824         uint256 _amount,
825         uint256 _minReturn,
826         IERC20Token _fromToken,
827         address _for
828     ) private returns (IERC20Token, uint256) {
829         ISmartToken smartToken;
830         IERC20Token toToken;
831         IBancorConverter converter;
832 
833         // get the contract features address from the registry
834         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
835 
836         // iterate over the conversion path
837         uint256 pathLength = _path.length;
838         for (uint256 i = 1; i < pathLength; i += 2) {
839             smartToken = ISmartToken(_path[i]);
840             toToken = _path[i + 1];
841             converter = IBancorConverter(smartToken.owner());
842             checkWhitelist(converter, _for, features);
843 
844             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
845             if (smartToken != _fromToken)
846                 ensureAllowance(_fromToken, converter, _amount);
847 
848             // make the conversion - if it's the last one, also provide the minimum return value
849             _amount = converter.change(_fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
850             _fromToken = toToken;
851         }
852         return (toToken, _amount);
853     }
854 
855     /**
856         @dev returns the expected return amount for converting a specific amount by following
857         a given conversion path.
858         notice that there is no support for circular paths.
859 
860         @param _path        conversion path, see conversion path format above
861         @param _amount      amount to convert from (in the initial source token)
862 
863         @return expected conversion return amount and conversion fee
864     */
865     function getReturnByPath(IERC20Token[] _path, uint256 _amount) public returns (uint256, uint256) {
866         IERC20Token fromToken;
867         ISmartToken smartToken; 
868         IERC20Token toToken;
869         IBancorConverter converter;
870         uint256 amount;
871         uint256 fee;
872         uint256 supply;
873         uint256 balance;
874         uint32 weight;
875         ISmartToken prevSmartToken;
876         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
877 
878         amount = _amount;
879         fromToken = _path[0];
880 
881         // iterate over the conversion path
882         for (uint256 i = 1; i < _path.length; i += 2) {
883             smartToken = ISmartToken(_path[i]);
884             toToken = _path[i + 1];
885             converter = IBancorConverter(smartToken.owner());
886 
887             if (toToken == smartToken) { // buy the smart token
888                 // check if the current smart token supply was changed in the previous iteration
889                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
890 
891                 // validate input
892                 require(getConnectorSaleEnabled(converter, fromToken));
893 
894                 // calculate the amount & the conversion fee
895                 balance = converter.getConnectorBalance(fromToken);
896                 weight = getConnectorWeight(converter, fromToken);
897                 amount = formula.calculatePurchaseReturn(supply, balance, weight, amount);
898                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
899                 amount -= fee;
900 
901                 // update the smart token supply for the next iteration
902                 supply = smartToken.totalSupply() + amount;
903             }
904             else if (fromToken == smartToken) { // sell the smart token
905                 // check if the current smart token supply was changed in the previous iteration
906                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
907 
908                 // calculate the amount & the conversion fee
909                 balance = converter.getConnectorBalance(toToken);
910                 weight = getConnectorWeight(converter, toToken);
911                 amount = formula.calculateSaleReturn(supply, balance, weight, amount);
912                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
913                 amount -= fee;
914 
915                 // update the smart token supply for the next iteration
916                 supply = smartToken.totalSupply() - amount;
917             }
918             else { // cross connector conversion
919                 (amount, fee) = converter.getReturn(fromToken, toToken, amount);
920             }
921 
922             prevSmartToken = smartToken;
923             fromToken = toToken;
924         }
925 
926         return (amount, fee);
927     }
928 
929     /**
930         @dev checks whether the given converter supports a whitelist and if so, ensures that
931         the account that should receive the conversion result is actually whitelisted
932 
933         @param _converter   converter to check for whitelist
934         @param _for         account that will receive the conversion result
935         @param _features    contract features contract address
936     */
937     function checkWhitelist(IBancorConverter _converter, address _for, IContractFeatures _features) private view {
938         IWhitelist whitelist;
939 
940         // check if the converter supports the conversion whitelist feature
941         if (!_features.isSupported(_converter, FeatureIds.CONVERTER_CONVERSION_WHITELIST))
942             return;
943 
944         // get the whitelist contract from the converter
945         whitelist = _converter.conversionWhitelist();
946         if (whitelist == address(0))
947             return;
948 
949         // check if the account that should receive the conversion result is actually whitelisted
950         require(whitelist.isWhitelisted(_for));
951     }
952 
953     /**
954         @dev claims the caller's tokens, converts them to any other token in the bancor network
955         by following a predefined conversion path and transfers the result tokens to a target account
956         note that allowance must be set beforehand
957 
958         @param _path        conversion path, see conversion path format above
959         @param _amount      amount to convert from (in the initial source token)
960         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
961         @param _for         account that will receive the conversion result
962 
963         @return tokens issued in return
964     */
965     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
966         // we need to transfer the tokens from the caller to the converter before we follow
967         // the conversion path, to allow it to execute the conversion on behalf of the caller
968         // note: we assume we already have allowance
969         IERC20Token fromToken = _path[0];
970         ensureTransferFrom(fromToken, msg.sender, this, _amount);
971         return convertFor(_path, _amount, _minReturn, _for);
972     }
973 
974     /**
975         @dev converts the token to any other token in the bancor network by following
976         a predefined conversion path and transfers the result tokens back to the sender
977         note that the converter should already own the source tokens
978 
979         @param _path        conversion path, see conversion path format above
980         @param _amount      amount to convert from (in the initial source token)
981         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
982 
983         @return tokens issued in return
984     */
985     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
986         return convertFor(_path, _amount, _minReturn, msg.sender);
987     }
988 
989     /**
990         @dev claims the caller's tokens, converts them to any other token in the bancor network
991         by following a predefined conversion path and transfers the result tokens back to the sender
992         note that allowance must be set beforehand
993 
994         @param _path        conversion path, see conversion path format above
995         @param _amount      amount to convert from (in the initial source token)
996         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
997 
998         @return tokens issued in return
999     */
1000     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1001         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
1002     }
1003 
1004     /**
1005         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1006         true on success but revert on failure instead
1007 
1008         @param _token     the token to transfer
1009         @param _to        the address to transfer the tokens to
1010         @param _amount    the amount to transfer
1011     */
1012     function ensureTransfer(IERC20Token _token, address _to, uint256 _amount) private {
1013         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1014 
1015         if (addressList.listedAddresses(_token)) {
1016             uint256 prevBalance = _token.balanceOf(_to);
1017             // we have to cast the token contract in an interface which has no return value
1018             INonStandardERC20(_token).transfer(_to, _amount);
1019             uint256 postBalance = _token.balanceOf(_to);
1020             assert(postBalance > prevBalance);
1021         } else {
1022             // if the token isn't whitelisted, we assert on transfer
1023             assert(_token.transfer(_to, _amount));
1024         }
1025     }
1026 
1027     /**
1028         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1029         true on success but revert on failure instead
1030 
1031         @param _token     the token to transfer
1032         @param _from      the address to transfer the tokens from
1033         @param _to        the address to transfer the tokens to
1034         @param _amount    the amount to transfer
1035     */
1036     function ensureTransferFrom(IERC20Token _token, address _from, address _to, uint256 _amount) private {
1037         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1038 
1039         if (addressList.listedAddresses(_token)) {
1040             uint256 prevBalance = _token.balanceOf(_to);
1041             // we have to cast the token contract in an interface which has no return value
1042             INonStandardERC20(_token).transferFrom(_from, _to, _amount);
1043             uint256 postBalance = _token.balanceOf(_to);
1044             assert(postBalance > prevBalance);
1045         } else {
1046             // if the token isn't whitelisted, we assert on transfer
1047             assert(_token.transferFrom(_from, _to, _amount));
1048         }
1049     }
1050 
1051     /**
1052         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
1053         Note that we use the non standard erc-20 interface in which `approve` has no return value so that
1054         this function will work for both standard and non standard tokens
1055 
1056         @param _token   token to check the allowance in
1057         @param _spender approved address
1058         @param _value   allowance amount
1059     */
1060     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
1061         // check if allowance for the given amount already exists
1062         if (_token.allowance(this, _spender) >= _value)
1063             return;
1064 
1065         // if the allowance is nonzero, must reset it to 0 first
1066         if (_token.allowance(this, _spender) != 0)
1067             INonStandardERC20(_token).approve(_spender, 0);
1068 
1069         // approve the new allowance
1070         INonStandardERC20(_token).approve(_spender, _value);
1071     }
1072 
1073     /**
1074         @dev returns the connector weight
1075 
1076         @param _converter       converter contract address
1077         @param _connector       connector's address to read from
1078 
1079         @return connector's weight
1080     */
1081     function getConnectorWeight(IBancorConverter _converter, IERC20Token _connector) 
1082         private
1083         view
1084         returns(uint32)
1085     {
1086         uint256 virtualBalance;
1087         uint32 weight;
1088         bool isVirtualBalanceEnabled;
1089         bool isSaleEnabled;
1090         bool isSet;
1091         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1092         return weight;
1093     }
1094 
1095     /**
1096         @dev returns true if connector sale is enabled
1097 
1098         @param _converter       converter contract address
1099         @param _connector       connector's address to read from
1100 
1101         @return true if connector sale is enabled, otherwise - false
1102     */
1103     function getConnectorSaleEnabled(IBancorConverter _converter, IERC20Token _connector) 
1104         private
1105         view
1106         returns(bool)
1107     {
1108         uint256 virtualBalance;
1109         uint32 weight;
1110         bool isVirtualBalanceEnabled;
1111         bool isSaleEnabled;
1112         bool isSet;
1113         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1114         return isSaleEnabled;
1115     }
1116 
1117     // deprecated, backward compatibility
1118     function convertForPrioritized2(
1119         IERC20Token[] _path,
1120         uint256 _amount,
1121         uint256 _minReturn,
1122         address _for,
1123         uint256 _block,
1124         uint8 _v,
1125         bytes32 _r,
1126         bytes32 _s
1127     )
1128         public
1129         payable
1130         returns (uint256)
1131     {
1132         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, _block, _v, _r, _s);
1133     }
1134 
1135     // deprecated, backward compatibility
1136     function convertForPrioritized(
1137         IERC20Token[] _path,
1138         uint256 _amount,
1139         uint256 _minReturn,
1140         address _for,
1141         uint256 _block,
1142         uint256 _nonce,
1143         uint8 _v,
1144         bytes32 _r,
1145         bytes32 _s)
1146         public payable returns (uint256)
1147     {
1148         _nonce;
1149         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, _block, _v, _r, _s);
1150     }
1151 }
1152 
1153 contract MyBancorNetwork is ContractIds {
1154     
1155     using SafeMath for uint256;
1156     
1157     BancorNetwork bancor = BancorNetwork(0x6690819Cb98c1211A8e38790d6cD48316Ed518Db);
1158     uint64 private constant MAX_CONVERSION_FEE = 1000000;
1159 
1160     /**
1161         @dev returns the expected return amount for converting a specific amount by following
1162         a given conversion path.
1163         notice that there is no support for circular paths.
1164 
1165         @param _path        conversion path, see conversion path format above
1166         @param _amount      amount to convert from (in the initial source token)
1167 
1168         @return expected conversion return amount and conversion fee
1169     */
1170     function getReturnByPath(IERC20Token[] _path, uint256 _amount) public view returns (uint256, uint256) {
1171         IERC20Token fromToken;
1172         ISmartToken smartToken; 
1173         IERC20Token toToken;
1174         IBancorConverter converter;
1175         uint256 amount;
1176         uint256 fee;
1177         uint256 supply;
1178         uint256 balance;
1179         uint32 weight;
1180         ISmartToken prevSmartToken;
1181         IBancorFormula formula = IBancorFormula(bancor.registry().getAddress(ContractIds.BANCOR_FORMULA));
1182 
1183         amount = _amount;
1184         fromToken = _path[0];
1185 
1186         // iterate over the conversion path
1187         for (uint256 i = 1; i < _path.length; i += 2) {
1188             smartToken = ISmartToken(_path[i]);
1189             toToken = _path[i + 1];
1190             converter = IBancorConverter(smartToken.owner());
1191 
1192             if (toToken == smartToken) { // buy the smart token
1193                 // check if the current smart token supply was changed in the previous iteration
1194                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
1195 
1196                 // validate input
1197                 require(getConnectorSaleEnabled(converter, fromToken));
1198 
1199                 // calculate the amount & the conversion fee
1200                 balance = converter.getConnectorBalance(fromToken);
1201                 weight = getConnectorWeight(converter, fromToken);
1202                 amount = formula.calculatePurchaseReturn(supply, balance, weight, amount);
1203                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
1204                 amount -= fee;
1205 
1206                 // update the smart token supply for the next iteration
1207                 supply = smartToken.totalSupply() + amount;
1208             }
1209             else if (fromToken == smartToken) { // sell the smart token
1210                 // check if the current smart token supply was changed in the previous iteration
1211                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
1212 
1213                 // calculate the amount & the conversion fee
1214                 balance = converter.getConnectorBalance(toToken);
1215                 weight = getConnectorWeight(converter, toToken);
1216                 amount = formula.calculateSaleReturn(supply, balance, weight, amount);
1217                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
1218                 amount -= fee;
1219 
1220                 // update the smart token supply for the next iteration
1221                 supply = smartToken.totalSupply() - amount;
1222             }
1223             else { // cross connector conversion
1224                 (amount, fee) = fixGetReturn(
1225                     converter,
1226                     abi.encodeWithSelector(
1227                         converter.getReturn.selector,
1228                         fromToken,
1229                         toToken,
1230                         amount
1231                     )
1232                 );
1233             }
1234 
1235             prevSmartToken = smartToken;
1236             fromToken = toToken;
1237         }
1238 
1239         return (amount, fee);
1240     }
1241     
1242     function fixGetReturn(address destination, bytes data) internal returns(uint256 amount, uint256 fee) {
1243         bytes memory ret = new bytes(64);
1244         bool success;
1245         assembly {
1246             success := call(
1247                 sub(gas, 34710),
1248                 destination,
1249                 0,
1250                 add(data, 32),
1251                 mload(data),
1252                 add(ret, 32),
1253                 64
1254             )
1255         }
1256         
1257         if (success) {
1258             assembly {
1259                 amount := mload(add(ret, 32))
1260                 fee := mload(add(ret, 64))
1261             }
1262         }
1263     }
1264     
1265     /**
1266         @dev returns true if connector sale is enabled
1267 
1268         @param _converter       converter contract address
1269         @param _connector       connector's address to read from
1270 
1271         @return true if connector sale is enabled, otherwise - false
1272     */
1273     function getConnectorSaleEnabled(IBancorConverter _converter, IERC20Token _connector) 
1274         private
1275         view
1276         returns(bool)
1277     {
1278         uint256 virtualBalance;
1279         uint32 weight;
1280         bool isVirtualBalanceEnabled;
1281         bool isSaleEnabled;
1282         bool isSet;
1283         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1284         return isSaleEnabled;
1285     }
1286     
1287     /**
1288         @dev returns the connector weight
1289 
1290         @param _converter       converter contract address
1291         @param _connector       connector's address to read from
1292 
1293         @return connector's weight
1294     */
1295     function getConnectorWeight(IBancorConverter _converter, IERC20Token _connector) 
1296         private
1297         view
1298         returns(uint32)
1299     {
1300         uint256 virtualBalance;
1301         uint32 weight;
1302         bool isVirtualBalanceEnabled;
1303         bool isSaleEnabled;
1304         bool isSet;
1305         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1306         return weight;
1307     }
1308 }