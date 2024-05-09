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
72     @dev Id definitions for bancor contracts
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
101     @dev Id definitions for bancor contract features
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
172 /**
173     @dev Provides support and utilities for contract ownership
174 */
175 contract Owned is IOwned {
176     address public owner;
177     address public newOwner;
178 
179     /**
180         @dev triggered when the owner is updated
181 
182         @param _prevOwner previous owner
183         @param _newOwner  new owner
184     */
185     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
186 
187     /**
188         @dev initializes a new Owned instance
189     */
190     constructor() public {
191         owner = msg.sender;
192     }
193 
194     // allows execution by the owner only
195     modifier ownerOnly {
196         require(msg.sender == owner);
197         _;
198     }
199 
200     /**
201         @dev allows transferring the contract ownership
202         the new owner still needs to accept the transfer
203         can only be called by the contract owner
204 
205         @param _newOwner    new contract owner
206     */
207     function transferOwnership(address _newOwner) public ownerOnly {
208         require(_newOwner != owner);
209         newOwner = _newOwner;
210     }
211 
212     /**
213         @dev used by a new owner to accept an ownership transfer
214     */
215     function acceptOwnership() public {
216         require(msg.sender == newOwner);
217         emit OwnerUpdate(owner, newOwner);
218         owner = newOwner;
219         newOwner = address(0);
220     }
221 }
222 
223 // File: contracts/utility/Utils.sol
224 
225 /**
226     @dev Utilities & Common Modifiers
227 */
228 contract Utils {
229     /**
230         constructor
231     */
232     constructor() public {
233     }
234 
235     // verifies that an amount is greater than zero
236     modifier greaterThanZero(uint256 _amount) {
237         require(_amount > 0);
238         _;
239     }
240 
241     // validates an address - currently only checks that it isn't null
242     modifier validAddress(address _address) {
243         require(_address != address(0));
244         _;
245     }
246 
247     // verifies that the address is different than this contract address
248     modifier notThis(address _address) {
249         require(_address != address(this));
250         _;
251     }
252 
253 }
254 
255 // File: contracts/utility/interfaces/ITokenHolder.sol
256 
257 /*
258     Token Holder interface
259 */
260 contract ITokenHolder is IOwned {
261     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
262 }
263 
264 // File: contracts/token/interfaces/INonStandardERC20.sol
265 
266 /*
267     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
268 */
269 contract INonStandardERC20 {
270     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
271     function name() public view returns (string) {}
272     function symbol() public view returns (string) {}
273     function decimals() public view returns (uint8) {}
274     function totalSupply() public view returns (uint256) {}
275     function balanceOf(address _owner) public view returns (uint256) { _owner; }
276     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
277 
278     function transfer(address _to, uint256 _value) public;
279     function transferFrom(address _from, address _to, uint256 _value) public;
280     function approve(address _spender, uint256 _value) public;
281 }
282 
283 // File: contracts/utility/TokenHolder.sol
284 
285 /**
286     @dev We consider every contract to be a 'token holder' since it's currently not possible
287     for a contract to deny receiving tokens.
288 
289     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
290     the owner to send tokens that were sent to the contract by mistake back to their sender.
291 
292     Note that we use the non standard ERC-20 interface which has no return value for transfer
293     in order to support both non standard as well as standard token contracts.
294     see https://github.com/ethereum/solidity/issues/4116
295 */
296 contract TokenHolder is ITokenHolder, Owned, Utils {
297     /**
298         @dev initializes a new TokenHolder instance
299     */
300     constructor() public {
301     }
302 
303     /**
304         @dev withdraws tokens held by the contract and sends them to an account
305         can only be called by the owner
306 
307         @param _token   ERC20 token contract address
308         @param _to      account to receive the new amount
309         @param _amount  amount to withdraw
310     */
311     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
312         public
313         ownerOnly
314         validAddress(_token)
315         validAddress(_to)
316         notThis(_to)
317     {
318         INonStandardERC20(_token).transfer(_to, _amount);
319     }
320 }
321 
322 // File: contracts/utility/SafeMath.sol
323 
324 /**
325     @dev Library for basic math operations with overflow/underflow protection
326 */
327 library SafeMath {
328     /**
329         @dev returns the sum of _x and _y, reverts if the calculation overflows
330 
331         @param _x   value 1
332         @param _y   value 2
333 
334         @return sum
335     */
336     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
337         uint256 z = _x + _y;
338         require(z >= _x);
339         return z;
340     }
341 
342     /**
343         @dev returns the difference of _x minus _y, reverts if the calculation underflows
344 
345         @param _x   minuend
346         @param _y   subtrahend
347 
348         @return difference
349     */
350     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
351         require(_x >= _y);
352         return _x - _y;
353     }
354 
355     /**
356         @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
357 
358         @param _x   factor 1
359         @param _y   factor 2
360 
361         @return product
362     */
363     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
364         // gas optimization
365         if (_x == 0)
366             return 0;
367 
368         uint256 z = _x * _y;
369         require(z / _x == _y);
370         return z;
371     }
372 
373       /**
374         @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
375 
376         @param _x   dividend
377         @param _y   divisor
378 
379         @return quotient
380     */
381     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
382         require(_y > 0);
383         uint256 c = _x / _y;
384 
385         return c;
386     }
387 }
388 
389 // File: contracts/utility/interfaces/IContractRegistry.sol
390 
391 /*
392     Contract Registry interface
393 */
394 contract IContractRegistry {
395     function addressOf(bytes32 _contractName) public view returns (address);
396 
397     // deprecated, backward compatibility
398     function getAddress(bytes32 _contractName) public view returns (address);
399 }
400 
401 // File: contracts/utility/interfaces/IContractFeatures.sol
402 
403 /*
404     Contract Features interface
405 */
406 contract IContractFeatures {
407     function isSupported(address _contract, uint256 _features) public view returns (bool);
408     function enableFeatures(uint256 _features, bool _enable) public;
409 }
410 
411 // File: contracts/utility/interfaces/IAddressList.sol
412 
413 /*
414     Address list interface
415 */
416 contract IAddressList {
417     mapping (address => bool) public listedAddresses;
418 }
419 
420 // File: contracts/token/interfaces/IEtherToken.sol
421 
422 /*
423     Ether Token interface
424 */
425 contract IEtherToken is ITokenHolder, IERC20Token {
426     function deposit() public payable;
427     function withdraw(uint256 _amount) public;
428     function withdrawTo(address _to, uint256 _amount) public;
429 }
430 
431 // File: contracts/token/interfaces/ISmartToken.sol
432 
433 /*
434     Smart Token interface
435 */
436 contract ISmartToken is IOwned, IERC20Token {
437     function disableTransfers(bool _disable) public;
438     function issue(address _to, uint256 _amount) public;
439     function destroy(address _from, uint256 _amount) public;
440 }
441 
442 // File: contracts/bancorx/interfaces/IBancorX.sol
443 
444 contract IBancorX {
445     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
446     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
447 }
448 
449 // File: contracts/BancorNetwork.sol
450 
451 /**
452     @dev The BancorNetwork contract is the main entry point for bancor token conversions.
453     It also allows converting between any token in the bancor network to any other token
454     in a single transaction by providing a conversion path.
455 
456     A note on conversion path -
457     Conversion path is a data structure that's used when converting a token to another token in the bancor network
458     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
459     The path defines which converters should be used and what kind of conversion should be done in each step.
460 
461     The path format doesn't include complex structure and instead, it is represented by a single array
462     in which each 'hop' is represented by a 2-tuple - smart token & to token.
463     In addition, the first element is always the source token.
464     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
465 
466     Format:
467     [source token, smart token, to token, smart token, to token...]
468 */
469 contract BancorNetwork is IBancorNetwork, TokenHolder, ContractIds, FeatureIds {
470     using SafeMath for uint256;
471 
472     uint64 private constant MAX_CONVERSION_FEE = 1000000;
473 
474     address public signerAddress = 0x0;         // verified address that allows conversions with higher gas price
475     IContractRegistry public registry;          // contract registry contract address
476 
477     mapping (address => bool) public etherTokens;       // list of all supported ether tokens
478     mapping (bytes32 => bool) public conversionHashes;  // list of conversion hashes, to prevent re-use of the same hash
479 
480     /**
481         @dev initializes a new BancorNetwork instance
482 
483         @param _registry    address of a contract registry contract
484     */
485     constructor(IContractRegistry _registry) public validAddress(_registry) {
486         registry = _registry;
487     }
488 
489     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
490     modifier validConversionPath(IERC20Token[] _path) {
491         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
492         _;
493     }
494 
495     /**
496         @dev allows the owner to update the contract registry contract address
497 
498         @param _registry   address of a contract registry contract
499     */
500     function setRegistry(IContractRegistry _registry)
501         public
502         ownerOnly
503         validAddress(_registry)
504         notThis(_registry)
505     {
506         registry = _registry;
507     }
508 
509     /**
510         @dev allows the owner to update the signer address
511 
512         @param _signerAddress    new signer address
513     */
514     function setSignerAddress(address _signerAddress)
515         public
516         ownerOnly
517         validAddress(_signerAddress)
518         notThis(_signerAddress)
519     {
520         signerAddress = _signerAddress;
521     }
522 
523     /**
524         @dev allows the owner to register/unregister ether tokens
525 
526         @param _token       ether token contract address
527         @param _register    true to register, false to unregister
528     */
529     function registerEtherToken(IEtherToken _token, bool _register)
530         public
531         ownerOnly
532         validAddress(_token)
533         notThis(_token)
534     {
535         etherTokens[_token] = _register;
536     }
537 
538     /**
539         @dev verifies that the signer address is trusted by recovering 
540         the address associated with the public key from elliptic 
541         curve signature, returns zero on error.
542         notice that the signature is valid only for one conversion
543         and expires after the give block.
544 
545         @return true if the signer is verified
546     */
547     function verifyTrustedSender(IERC20Token[] _path, uint256 _customVal, uint256 _block, address _addr, uint8 _v, bytes32 _r, bytes32 _s) private returns(bool) {
548         bytes32 hash = keccak256(abi.encodePacked(_block, tx.gasprice, _addr, msg.sender, _customVal, _path));
549 
550         // checking that it is the first conversion with the given signature
551         // and that the current block number doesn't exceeded the maximum block
552         // number that's allowed with the current signature
553         require(!conversionHashes[hash] && block.number <= _block);
554 
555         // recovering the signing address and comparing it to the trusted signer
556         // address that was set in the contract
557         bytes32 prefixedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
558         bool verified = ecrecover(prefixedHash, _v, _r, _s) == signerAddress;
559 
560         // if the signer is the trusted signer - mark the hash so that it can't
561         // be used multiple times
562         if (verified)
563             conversionHashes[hash] = true;
564         return verified;
565     }
566 
567     /**
568         @dev validates xConvert call by verifying the path format, claiming the callers tokens (if not ETH),
569         and verifying the gas price limit
570 
571         @param _path        conversion path, see conversion path format above
572         @param _amount      amount to convert from (in the initial source token)
573         @param _block       if the current block exceeded the given parameter - it is cancelled
574         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
575         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
576         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
577     */
578     function validateXConversion(
579         IERC20Token[] _path,
580         uint256 _amount,
581         uint256 _block,
582         uint8 _v,
583         bytes32 _r,
584         bytes32 _s
585     ) 
586         private 
587         validConversionPath(_path)    
588     {
589         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
590         IERC20Token fromToken = _path[0];
591         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
592 
593         // require that the dest token is BNT
594         require(_path[_path.length - 1] == registry.addressOf(ContractIds.BNT_TOKEN));
595 
596         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
597         // otherwise, we claim the tokens from the sender
598         if (msg.value > 0) {
599             IEtherToken(fromToken).deposit.value(msg.value)();
600         } else {
601             ensureTransferFrom(fromToken, msg.sender, this, _amount);
602         }
603 
604         // verify gas price limit
605         if (_v == 0x0 && _r == 0x0 && _s == 0x0) {
606             IBancorGasPriceLimit gasPriceLimit = IBancorGasPriceLimit(registry.addressOf(ContractIds.BANCOR_GAS_PRICE_LIMIT));
607             gasPriceLimit.validateGasPrice(tx.gasprice);
608         } else {
609             require(verifyTrustedSender(_path, _amount, _block, msg.sender, _v, _r, _s));
610         }
611     }
612 
613     /**
614         @dev converts the token to any other token in the bancor network by following
615         a predefined conversion path and transfers the result tokens to a target account
616         note that the converter should already own the source tokens
617 
618         @param _path        conversion path, see conversion path format above
619         @param _amount      amount to convert from (in the initial source token)
620         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
621         @param _for         account that will receive the conversion result
622 
623         @return tokens issued in return
624     */
625     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256) {
626         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, 0x0, 0x0, 0x0, 0x0);
627     }
628 
629     /**
630         @dev converts the token to any other token in the bancor network
631         by following a predefined conversion path and transfers the result
632         tokens to a target account.
633         this version of the function also allows the verified signer
634         to bypass the universal gas price limit.
635         note that the converter should already own the source tokens
636 
637         @param _path        conversion path, see conversion path format above
638         @param _amount      amount to convert from (in the initial source token)
639         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
640         @param _for         account that will receive the conversion result
641         @param _customVal   custom value that was signed for prioritized conversion
642         @param _block       if the current block exceeded the given parameter - it is cancelled
643         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
644         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
645         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
646 
647         @return tokens issued in return
648     */
649     function convertForPrioritized3(
650         IERC20Token[] _path,
651         uint256 _amount,
652         uint256 _minReturn,
653         address _for,
654         uint256 _customVal,
655         uint256 _block,
656         uint8 _v,
657         bytes32 _r,
658         bytes32 _s
659     )
660         public
661         payable
662         returns (uint256)
663     {
664         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
665         IERC20Token fromToken = _path[0];
666         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
667 
668         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
669         // otherwise, we assume we already have the tokens
670         if (msg.value > 0)
671             IEtherToken(fromToken).deposit.value(msg.value)();
672 
673         return convertForInternal(_path, _amount, _minReturn, _for, _customVal, _block, _v, _r, _s);
674     }
675 
676     /**
677         @dev converts any other token to BNT in the bancor network
678         by following a predefined conversion path and transfers the resulting
679         tokens to BancorX.
680         note that the network should already have been given allowance of the source token (if not ETH)
681 
682         @param _path             conversion path, see conversion path format above
683         @param _amount           amount to convert from (in the initial source token)
684         @param _minReturn        if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
685         @param _toBlockchain     blockchain BNT will be issued on
686         @param _to               address/account on _toBlockchain to send the BNT to
687         @param _conversionId     pre-determined unique (if non zero) id which refers to this transaction 
688 
689         @return the amount of BNT received from this conversion
690     */
691     function xConvert(
692         IERC20Token[] _path,
693         uint256 _amount,
694         uint256 _minReturn,
695         bytes32 _toBlockchain,
696         bytes32 _to,
697         uint256 _conversionId
698     )
699         public
700         payable
701         returns (uint256)
702     {
703         return xConvertPrioritized(_path, _amount, _minReturn, _toBlockchain, _to, _conversionId, 0x0, 0x0, 0x0, 0x0);
704     }
705 
706     /**
707         @dev converts any other token to BNT in the bancor network
708         by following a predefined conversion path and transfers the resulting
709         tokens to BancorX.
710         this version of the function also allows the verified signer
711         to bypass the universal gas price limit.
712         note that the network should already have been given allowance of the source token (if not ETH)
713 
714         @param _path            conversion path, see conversion path format above
715         @param _amount          amount to convert from (in the initial source token)
716         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
717         @param _toBlockchain    blockchain BNT will be issued on
718         @param _to              address/account on _toBlockchain to send the BNT to
719         @param _conversionId    pre-determined unique (if non zero) id which refers to this transaction 
720         @param _block           if the current block exceeded the given parameter - it is cancelled
721         @param _v               (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
722         @param _r               (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
723         @param _s               (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
724 
725         @return the amount of BNT received from this conversion
726     */
727     function xConvertPrioritized(
728         IERC20Token[] _path,
729         uint256 _amount,
730         uint256 _minReturn,
731         bytes32 _toBlockchain,
732         bytes32 _to,
733         uint256 _conversionId,
734         uint256 _block,
735         uint8 _v,
736         bytes32 _r,
737         bytes32 _s
738     )
739         public
740         payable
741         returns (uint256)
742     {
743         // do a lot of validation and transfers in separate function to work around 16 variable limit
744         validateXConversion(_path, _amount, _block, _v, _r, _s);
745 
746         // convert to BNT and get the resulting amount
747         (, uint256 retAmount) = convertByPath(_path, _amount, _minReturn, _path[0], this);
748 
749         // transfer the resulting amount to BancorX, and return the amount
750         IBancorX(registry.addressOf(ContractIds.BANCOR_X)).xTransfer(_toBlockchain, _to, retAmount, _conversionId);
751 
752         return retAmount;
753     }
754 
755     /**
756         @dev converts token to any other token in the bancor network
757         by following a predefined conversion paths and transfers the result
758         tokens to a target account.
759 
760         @param _path        conversion path, see conversion path format above
761         @param _amount      amount to convert from (in the initial source token)
762         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
763         @param _for         account that will receive the conversion result
764         @param _block       if the current block exceeded the given parameter - it is cancelled
765         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
766         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
767         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
768 
769         @return tokens issued in return
770     */
771     function convertForInternal(
772         IERC20Token[] _path, 
773         uint256 _amount, 
774         uint256 _minReturn, 
775         address _for, 
776         uint256 _customVal,
777         uint256 _block,
778         uint8 _v, 
779         bytes32 _r, 
780         bytes32 _s
781     )
782         private
783         validConversionPath(_path)
784         returns (uint256)
785     {
786         if (_v == 0x0 && _r == 0x0 && _s == 0x0) {
787             IBancorGasPriceLimit gasPriceLimit = IBancorGasPriceLimit(registry.addressOf(ContractIds.BANCOR_GAS_PRICE_LIMIT));
788             gasPriceLimit.validateGasPrice(tx.gasprice);
789         }
790         else {
791             require(verifyTrustedSender(_path, _customVal, _block, _for, _v, _r, _s));
792         }
793 
794         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
795         IERC20Token fromToken = _path[0];
796 
797         IERC20Token toToken;
798         
799         (toToken, _amount) = convertByPath(_path, _amount, _minReturn, fromToken, _for);
800 
801         // finished the conversion, transfer the funds to the target account
802         // if the target token is an ether token, withdraw the tokens and send them as ETH
803         // otherwise, transfer the tokens as is
804         if (etherTokens[toToken])
805             IEtherToken(toToken).withdrawTo(_for, _amount);
806         else
807             ensureTransfer(toToken, _for, _amount);
808 
809         return _amount;
810     }
811 
812     /**
813         @dev executes the actual conversion by following the conversion path
814 
815         @param _path        conversion path, see conversion path format above
816         @param _amount      amount to convert from (in the initial source token)
817         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
818         @param _fromToken   ERC20 token to convert from (the first element in the path)
819         @param _for         account that will receive the conversion result
820 
821         @return ERC20 token to convert to (the last element in the path) & tokens issued in return
822     */
823     function convertByPath(
824         IERC20Token[] _path,
825         uint256 _amount,
826         uint256 _minReturn,
827         IERC20Token _fromToken,
828         address _for
829     ) private returns (IERC20Token, uint256) {
830         ISmartToken smartToken;
831         IERC20Token toToken;
832         IBancorConverter converter;
833 
834         // get the contract features address from the registry
835         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
836 
837         // iterate over the conversion path
838         uint256 pathLength = _path.length;
839         for (uint256 i = 1; i < pathLength; i += 2) {
840             smartToken = ISmartToken(_path[i]);
841             toToken = _path[i + 1];
842             converter = IBancorConverter(smartToken.owner());
843             checkWhitelist(converter, _for, features);
844 
845             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
846             if (smartToken != _fromToken)
847                 ensureAllowance(_fromToken, converter, _amount);
848 
849             // make the conversion - if it's the last one, also provide the minimum return value
850             _amount = converter.change(_fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
851             _fromToken = toToken;
852         }
853         return (toToken, _amount);
854     }
855 
856     bytes4 private constant GET_RETURN_FUNC_SELECTOR = bytes4(uint256(keccak256("getReturn(address,address,uint256)") >> (256 - 4 * 8)));
857 
858     function getReturn(address _dest, address _fromToken, address _toToken, uint256 _amount) internal view returns (uint256, uint256) {
859         uint256[2] memory ret;
860         bytes memory data = abi.encodeWithSelector(GET_RETURN_FUNC_SELECTOR, _fromToken, _toToken, _amount);
861 
862         assembly {
863             let success := staticcall(
864                 gas,           // gas remaining
865                 _dest,         // destination address
866                 add(data, 32), // input buffer (starts after the first 32 bytes in the `data` array)
867                 mload(data),   // input length (loaded from the first 32 bytes in the `data` array)
868                 ret,           // output buffer
869                 64             // output length
870             )
871             if iszero(success) {
872                 revert(0, 0)
873             }
874         }
875 
876         return (ret[0], ret[1]);
877     }
878 
879     /**
880         @dev returns the expected return amount for converting a specific amount by following
881         a given conversion path.
882         notice that there is no support for circular paths.
883 
884         @param _path        conversion path, see conversion path format above
885         @param _amount      amount to convert from (in the initial source token)
886 
887         @return expected conversion return amount and conversion fee
888     */
889     function getReturnByPath(IERC20Token[] _path, uint256 _amount) public view returns (uint256, uint256) {
890         IERC20Token fromToken;
891         ISmartToken smartToken; 
892         IERC20Token toToken;
893         IBancorConverter converter;
894         uint256 amount;
895         uint256 fee;
896         uint256 supply;
897         uint256 balance;
898         uint32 weight;
899         ISmartToken prevSmartToken;
900         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
901 
902         amount = _amount;
903         fromToken = _path[0];
904 
905         // iterate over the conversion path
906         for (uint256 i = 1; i < _path.length; i += 2) {
907             smartToken = ISmartToken(_path[i]);
908             toToken = _path[i + 1];
909             converter = IBancorConverter(smartToken.owner());
910 
911             if (toToken == smartToken) { // buy the smart token
912                 // check if the current smart token supply was changed in the previous iteration
913                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
914 
915                 // validate input
916                 require(getConnectorSaleEnabled(converter, fromToken));
917 
918                 // calculate the amount & the conversion fee
919                 balance = converter.getConnectorBalance(fromToken);
920                 weight = getConnectorWeight(converter, fromToken);
921                 amount = formula.calculatePurchaseReturn(supply, balance, weight, amount);
922                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
923                 amount -= fee;
924 
925                 // update the smart token supply for the next iteration
926                 supply = smartToken.totalSupply() + amount;
927             }
928             else if (fromToken == smartToken) { // sell the smart token
929                 // check if the current smart token supply was changed in the previous iteration
930                 supply = smartToken == prevSmartToken ? supply : smartToken.totalSupply();
931 
932                 // calculate the amount & the conversion fee
933                 balance = converter.getConnectorBalance(toToken);
934                 weight = getConnectorWeight(converter, toToken);
935                 amount = formula.calculateSaleReturn(supply, balance, weight, amount);
936                 fee = amount.mul(converter.conversionFee()).div(MAX_CONVERSION_FEE);
937                 amount -= fee;
938 
939                 // update the smart token supply for the next iteration
940                 supply = smartToken.totalSupply() - amount;
941             }
942             else { // cross connector conversion
943                 (amount, fee) = getReturn(converter, fromToken, toToken, amount);
944             }
945 
946             prevSmartToken = smartToken;
947             fromToken = toToken;
948         }
949 
950         return (amount, fee);
951     }
952 
953     /**
954         @dev checks whether the given converter supports a whitelist and if so, ensures that
955         the account that should receive the conversion result is actually whitelisted
956 
957         @param _converter   converter to check for whitelist
958         @param _for         account that will receive the conversion result
959         @param _features    contract features contract address
960     */
961     function checkWhitelist(IBancorConverter _converter, address _for, IContractFeatures _features) private view {
962         IWhitelist whitelist;
963 
964         // check if the converter supports the conversion whitelist feature
965         if (!_features.isSupported(_converter, FeatureIds.CONVERTER_CONVERSION_WHITELIST))
966             return;
967 
968         // get the whitelist contract from the converter
969         whitelist = _converter.conversionWhitelist();
970         if (whitelist == address(0))
971             return;
972 
973         // check if the account that should receive the conversion result is actually whitelisted
974         require(whitelist.isWhitelisted(_for));
975     }
976 
977     /**
978         @dev claims the caller's tokens, converts them to any other token in the bancor network
979         by following a predefined conversion path and transfers the result tokens to a target account
980         note that allowance must be set beforehand
981 
982         @param _path        conversion path, see conversion path format above
983         @param _amount      amount to convert from (in the initial source token)
984         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
985         @param _for         account that will receive the conversion result
986 
987         @return tokens issued in return
988     */
989     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
990         // we need to transfer the tokens from the caller to the converter before we follow
991         // the conversion path, to allow it to execute the conversion on behalf of the caller
992         // note: we assume we already have allowance
993         IERC20Token fromToken = _path[0];
994         ensureTransferFrom(fromToken, msg.sender, this, _amount);
995         return convertFor(_path, _amount, _minReturn, _for);
996     }
997 
998     /**
999         @dev converts the token to any other token in the bancor network by following
1000         a predefined conversion path and transfers the result tokens back to the sender
1001         note that the converter should already own the source tokens
1002 
1003         @param _path        conversion path, see conversion path format above
1004         @param _amount      amount to convert from (in the initial source token)
1005         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1006 
1007         @return tokens issued in return
1008     */
1009     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
1010         return convertFor(_path, _amount, _minReturn, msg.sender);
1011     }
1012 
1013     /**
1014         @dev claims the caller's tokens, converts them to any other token in the bancor network
1015         by following a predefined conversion path and transfers the result tokens back to the sender
1016         note that allowance must be set beforehand
1017 
1018         @param _path        conversion path, see conversion path format above
1019         @param _amount      amount to convert from (in the initial source token)
1020         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1021 
1022         @return tokens issued in return
1023     */
1024     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1025         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
1026     }
1027 
1028     /**
1029         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1030         true on success but revert on failure instead
1031 
1032         @param _token     the token to transfer
1033         @param _to        the address to transfer the tokens to
1034         @param _amount    the amount to transfer
1035     */
1036     function ensureTransfer(IERC20Token _token, address _to, uint256 _amount) private {
1037         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1038 
1039         if (addressList.listedAddresses(_token)) {
1040             uint256 prevBalance = _token.balanceOf(_to);
1041             // we have to cast the token contract in an interface which has no return value
1042             INonStandardERC20(_token).transfer(_to, _amount);
1043             uint256 postBalance = _token.balanceOf(_to);
1044             assert(postBalance > prevBalance);
1045         } else {
1046             // if the token isn't whitelisted, we assert on transfer
1047             assert(_token.transfer(_to, _amount));
1048         }
1049     }
1050 
1051     /**
1052         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1053         true on success but revert on failure instead
1054 
1055         @param _token     the token to transfer
1056         @param _from      the address to transfer the tokens from
1057         @param _to        the address to transfer the tokens to
1058         @param _amount    the amount to transfer
1059     */
1060     function ensureTransferFrom(IERC20Token _token, address _from, address _to, uint256 _amount) private {
1061         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1062 
1063         if (addressList.listedAddresses(_token)) {
1064             uint256 prevBalance = _token.balanceOf(_to);
1065             // we have to cast the token contract in an interface which has no return value
1066             INonStandardERC20(_token).transferFrom(_from, _to, _amount);
1067             uint256 postBalance = _token.balanceOf(_to);
1068             assert(postBalance > prevBalance);
1069         } else {
1070             // if the token isn't whitelisted, we assert on transfer
1071             assert(_token.transferFrom(_from, _to, _amount));
1072         }
1073     }
1074 
1075     /**
1076         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
1077         Note that we use the non standard erc-20 interface in which `approve` has no return value so that
1078         this function will work for both standard and non standard tokens
1079 
1080         @param _token   token to check the allowance in
1081         @param _spender approved address
1082         @param _value   allowance amount
1083     */
1084     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
1085         // check if allowance for the given amount already exists
1086         if (_token.allowance(this, _spender) >= _value)
1087             return;
1088 
1089         // if the allowance is nonzero, must reset it to 0 first
1090         if (_token.allowance(this, _spender) != 0)
1091             INonStandardERC20(_token).approve(_spender, 0);
1092 
1093         // approve the new allowance
1094         INonStandardERC20(_token).approve(_spender, _value);
1095     }
1096 
1097     /**
1098         @dev returns the connector weight
1099 
1100         @param _converter       converter contract address
1101         @param _connector       connector's address to read from
1102 
1103         @return connector's weight
1104     */
1105     function getConnectorWeight(IBancorConverter _converter, IERC20Token _connector) 
1106         private
1107         view
1108         returns(uint32)
1109     {
1110         uint256 virtualBalance;
1111         uint32 weight;
1112         bool isVirtualBalanceEnabled;
1113         bool isSaleEnabled;
1114         bool isSet;
1115         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1116         return weight;
1117     }
1118 
1119     /**
1120         @dev returns true if connector sale is enabled
1121 
1122         @param _converter       converter contract address
1123         @param _connector       connector's address to read from
1124 
1125         @return true if connector sale is enabled, otherwise - false
1126     */
1127     function getConnectorSaleEnabled(IBancorConverter _converter, IERC20Token _connector) 
1128         private
1129         view
1130         returns(bool)
1131     {
1132         uint256 virtualBalance;
1133         uint32 weight;
1134         bool isVirtualBalanceEnabled;
1135         bool isSaleEnabled;
1136         bool isSet;
1137         (virtualBalance, weight, isVirtualBalanceEnabled, isSaleEnabled, isSet) = _converter.connectors(_connector);
1138         return isSaleEnabled;
1139     }
1140 
1141     /**
1142         @dev deprecated, backward compatibility
1143     */
1144     function convertForPrioritized2(
1145         IERC20Token[] _path,
1146         uint256 _amount,
1147         uint256 _minReturn,
1148         address _for,
1149         uint256 _block,
1150         uint8 _v,
1151         bytes32 _r,
1152         bytes32 _s
1153     )
1154         public
1155         payable
1156         returns (uint256)
1157     {
1158         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, _block, _v, _r, _s);
1159     }
1160 
1161     /**
1162         @dev deprecated, backward compatibility
1163     */
1164     function convertForPrioritized(
1165         IERC20Token[] _path,
1166         uint256 _amount,
1167         uint256 _minReturn,
1168         address _for,
1169         uint256 _block,
1170         uint256 _nonce,
1171         uint8 _v,
1172         bytes32 _r,
1173         bytes32 _s)
1174         public payable returns (uint256)
1175     {
1176         _nonce;
1177         return convertForPrioritized3(_path, _amount, _minReturn, _for, _amount, _block, _v, _r, _s);
1178     }
1179 }
