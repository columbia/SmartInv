1 pragma solidity ^0.4.21;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public view returns (address) {}
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     ERC20 Standard Token interface
16 */
17 contract IERC20Token {
18     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
19     function name() public view returns (string) {}
20     function symbol() public view returns (string) {}
21     function decimals() public view returns (uint8) {}
22     function totalSupply() public view returns (uint256) {}
23     function balanceOf(address _owner) public view returns (uint256) { _owner; }
24     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
25 
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 }
30 
31 /*
32     Contract Registry interface
33 */
34 contract IContractRegistry {
35     function getAddress(bytes32 _contractName) public view returns (address);
36 }
37 
38 /*
39     Contract Features interface
40 */
41 contract IContractFeatures {
42     function isSupported(address _contract, uint256 _features) public view returns (bool);
43     function enableFeatures(uint256 _features, bool _enable) public;
44 }
45 
46 /*
47     Whitelist interface
48 */
49 contract IWhitelist {
50     function isWhitelisted(address _address) public view returns (bool);
51 }
52 
53 /*
54     Token Holder interface
55 */
56 contract ITokenHolder is IOwned {
57     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
58 }
59 
60 /*
61     Ether Token interface
62 */
63 contract IEtherToken is ITokenHolder, IERC20Token {
64     function deposit() public payable;
65     function withdraw(uint256 _amount) public;
66     function withdrawTo(address _to, uint256 _amount) public;
67 }
68 
69 /*
70     Smart Token interface
71 */
72 contract ISmartToken is IOwned, IERC20Token {
73     function disableTransfers(bool _disable) public;
74     function issue(address _to, uint256 _amount) public;
75     function destroy(address _from, uint256 _amount) public;
76 }
77 
78 /*
79     Bancor Gas Price Limit interface
80 */
81 contract IBancorGasPriceLimit {
82     function gasPrice() public view returns (uint256) {}
83     function validateGasPrice(uint256) public view;
84 }
85 
86 /*
87     Bancor Converter interface
88 */
89 contract IBancorConverter {
90     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
91     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
92     function conversionWhitelist() public view returns (IWhitelist) {}
93     // deprecated, backward compatibility
94     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
95 }
96 
97 /*
98     Bancor Network interface
99 */
100 contract IBancorNetwork {
101     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
102     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
103     function convertForPrioritized2(
104         IERC20Token[] _path,
105         uint256 _amount,
106         uint256 _minReturn,
107         address _for,
108         uint256 _block,
109         uint8 _v,
110         bytes32 _r,
111         bytes32 _s)
112         public payable returns (uint256);
113 
114     // deprecated, backward compatibility
115     function convertForPrioritized(
116         IERC20Token[] _path,
117         uint256 _amount,
118         uint256 _minReturn,
119         address _for,
120         uint256 _block,
121         uint256 _nonce,
122         uint8 _v,
123         bytes32 _r,
124         bytes32 _s)
125         public payable returns (uint256);
126 }
127 
128 /*
129     Utilities & Common Modifiers
130 */
131 contract Utils {
132     /**
133         constructor
134     */
135     function Utils() public {
136     }
137 
138     // verifies that an amount is greater than zero
139     modifier greaterThanZero(uint256 _amount) {
140         require(_amount > 0);
141         _;
142     }
143 
144     // validates an address - currently only checks that it isn't null
145     modifier validAddress(address _address) {
146         require(_address != address(0));
147         _;
148     }
149 
150     // verifies that the address is different than this contract address
151     modifier notThis(address _address) {
152         require(_address != address(this));
153         _;
154     }
155 
156     // Overflow protected math functions
157 
158     /**
159         @dev returns the sum of _x and _y, asserts if the calculation overflows
160 
161         @param _x   value 1
162         @param _y   value 2
163 
164         @return sum
165     */
166     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
167         uint256 z = _x + _y;
168         assert(z >= _x);
169         return z;
170     }
171 
172     /**
173         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
174 
175         @param _x   minuend
176         @param _y   subtrahend
177 
178         @return difference
179     */
180     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
181         assert(_x >= _y);
182         return _x - _y;
183     }
184 
185     /**
186         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
187 
188         @param _x   factor 1
189         @param _y   factor 2
190 
191         @return product
192     */
193     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
194         uint256 z = _x * _y;
195         assert(_x == 0 || z / _x == _y);
196         return z;
197     }
198 }
199 
200 /*
201     Provides support and utilities for contract ownership
202 */
203 contract Owned is IOwned {
204     address public owner;
205     address public newOwner;
206 
207     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
208 
209     /**
210         @dev constructor
211     */
212     function Owned() public {
213         owner = msg.sender;
214     }
215 
216     // allows execution by the owner only
217     modifier ownerOnly {
218         assert(msg.sender == owner);
219         _;
220     }
221 
222     /**
223         @dev allows transferring the contract ownership
224         the new owner still needs to accept the transfer
225         can only be called by the contract owner
226 
227         @param _newOwner    new contract owner
228     */
229     function transferOwnership(address _newOwner) public ownerOnly {
230         require(_newOwner != owner);
231         newOwner = _newOwner;
232     }
233 
234     /**
235         @dev used by a new owner to accept an ownership transfer
236     */
237     function acceptOwnership() public {
238         require(msg.sender == newOwner);
239         emit OwnerUpdate(owner, newOwner);
240         owner = newOwner;
241         newOwner = address(0);
242     }
243 }
244 
245 /**
246     Id definitions for bancor contracts
247 
248     Can be used in conjunction with the contract registry to get contract addresses
249 */
250 contract ContractIds {
251     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
252     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
253     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
254 }
255 
256 /**
257     Id definitions for bancor contract features
258 
259     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
260 */
261 contract FeatureIds {
262     // converter features
263     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
264 }
265 
266 /*
267     We consider every contract to be a 'token holder' since it's currently not possible
268     for a contract to deny receiving tokens.
269 
270     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
271     the owner to send tokens that were sent to the contract by mistake back to their sender.
272 */
273 contract TokenHolder is ITokenHolder, Owned, Utils {
274     /**
275         @dev constructor
276     */
277     function TokenHolder() public {
278     }
279 
280     /**
281         @dev withdraws tokens held by the contract and sends them to an account
282         can only be called by the owner
283 
284         @param _token   ERC20 token contract address
285         @param _to      account to receive the new amount
286         @param _amount  amount to withdraw
287     */
288     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
289         public
290         ownerOnly
291         validAddress(_token)
292         validAddress(_to)
293         notThis(_to)
294     {
295         assert(_token.transfer(_to, _amount));
296     }
297 }
298 
299 /*
300     The BancorNetwork contract is the main entry point for bancor token conversions.
301     It also allows converting between any token in the bancor network to any other token
302     in a single transaction by providing a conversion path.
303 
304     A note on conversion path -
305     Conversion path is a data structure that's used when converting a token to another token in the bancor network
306     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
307     The path defines which converters should be used and what kind of conversion should be done in each step.
308 
309     The path format doesn't include complex structure and instead, it is represented by a single array
310     in which each 'hop' is represented by a 2-tuple - smart token & to token.
311     In addition, the first element is always the source token.
312     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
313 
314     Format:
315     [source token, smart token, to token, smart token, to token...]
316 */
317 contract BancorNetwork is IBancorNetwork, TokenHolder, ContractIds, FeatureIds {
318     address public signerAddress = 0x0;         // verified address that allows conversions with higher gas price
319     IContractRegistry public registry;          // contract registry contract address
320     IBancorGasPriceLimit public gasPriceLimit;  // bancor universal gas price limit contract
321 
322     mapping (address => bool) public etherTokens;       // list of all supported ether tokens
323     mapping (bytes32 => bool) public conversionHashes;  // list of conversion hashes, to prevent re-use of the same hash
324 
325     /**
326         @dev constructor
327 
328         @param _registry    address of a contract registry contract
329     */
330     function BancorNetwork(IContractRegistry _registry) public validAddress(_registry) {
331         registry = _registry;
332     }
333 
334     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
335     modifier validConversionPath(IERC20Token[] _path) {
336         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
337         _;
338     }
339 
340     /*
341         @dev allows the owner to update the contract registry contract address
342 
343         @param _registry   address of a contract registry contract
344     */
345     function setContractRegistry(IContractRegistry _registry)
346         public
347         ownerOnly
348         validAddress(_registry)
349         notThis(_registry)
350     {
351         registry = _registry;
352     }
353 
354     /*
355         @dev allows the owner to update the gas price limit contract address
356 
357         @param _gasPriceLimit   address of a bancor gas price limit contract
358     */
359     function setGasPriceLimit(IBancorGasPriceLimit _gasPriceLimit)
360         public
361         ownerOnly
362         validAddress(_gasPriceLimit)
363         notThis(_gasPriceLimit)
364     {
365         gasPriceLimit = _gasPriceLimit;
366     }
367 
368     /*
369         @dev allows the owner to update the signer address
370 
371         @param _signerAddress    new signer address
372     */
373     function setSignerAddress(address _signerAddress)
374         public
375         ownerOnly
376         validAddress(_signerAddress)
377         notThis(_signerAddress)
378     {
379         signerAddress = _signerAddress;
380     }
381 
382     /**
383         @dev allows the owner to register/unregister ether tokens
384 
385         @param _token       ether token contract address
386         @param _register    true to register, false to unregister
387     */
388     function registerEtherToken(IEtherToken _token, bool _register)
389         public
390         ownerOnly
391         validAddress(_token)
392         notThis(_token)
393     {
394         etherTokens[_token] = _register;
395     }
396 
397     /**
398         @dev verifies that the signer address is trusted by recovering 
399         the address associated with the public key from elliptic 
400         curve signature, returns zero on error.
401         notice that the signature is valid only for one conversion
402         and expires after the give block.
403 
404         @return true if the signer is verified
405     */
406     function verifyTrustedSender(IERC20Token[] _path, uint256 _amount, uint256 _block, address _addr, uint8 _v, bytes32 _r, bytes32 _s) private returns(bool) {
407         bytes32 hash = keccak256(_block, tx.gasprice, _addr, msg.sender, _amount, _path);
408 
409         // checking that it is the first conversion with the given signature
410         // and that the current block number doesn't exceeded the maximum block
411         // number that's allowed with the current signature
412         require(!conversionHashes[hash] && block.number <= _block);
413 
414         // recovering the signing address and comparing it to the trusted signer
415         // address that was set in the contract
416         bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", hash);
417         bool verified = ecrecover(prefixedHash, _v, _r, _s) == signerAddress;
418 
419         // if the signer is the trusted signer - mark the hash so that it can't
420         // be used multiple times
421         if (verified)
422             conversionHashes[hash] = true;
423         return verified;
424     }
425 
426     /**
427         @dev converts the token to any other token in the bancor network by following
428         a predefined conversion path and transfers the result tokens to a target account
429         note that the converter should already own the source tokens
430 
431         @param _path        conversion path, see conversion path format above
432         @param _amount      amount to convert from (in the initial source token)
433         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
434         @param _for         account that will receive the conversion result
435 
436         @return tokens issued in return
437     */
438     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256) {
439         return convertForPrioritized2(_path, _amount, _minReturn, _for, 0x0, 0x0, 0x0, 0x0);
440     }
441 
442     /**
443         @dev converts the token to any other token in the bancor network
444         by following a predefined conversion path and transfers the result
445         tokens to a target account.
446         this version of the function also allows the verified signer
447         to bypass the universal gas price limit.
448         note that the converter should already own the source tokens
449 
450         @param _path        conversion path, see conversion path format above
451         @param _amount      amount to convert from (in the initial source token)
452         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
453         @param _for         account that will receive the conversion result
454 
455         @return tokens issued in return
456     */
457     function convertForPrioritized2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
458         public
459         payable
460         validConversionPath(_path)
461         returns (uint256)
462     {
463         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
464         IERC20Token fromToken = _path[0];
465         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
466 
467         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
468         // otherwise, we assume we already have the tokens
469         if (msg.value > 0)
470             IEtherToken(fromToken).deposit.value(msg.value)();
471 
472         return convertForInternal(_path, _amount, _minReturn, _for, _block, _v, _r, _s);
473     }
474 
475     /**
476         @dev converts token to any other token in the bancor network
477         by following the predefined conversion paths and transfers the result
478         tokens to a targeted account.
479         this version of the function also allows multiple conversions
480         in a single atomic transaction.
481         note that the converter should already own the source tokens
482 
483         @param _paths           merged conversion paths, i.e. [path1, path2, ...]. see conversion path format above
484         @param _pathStartIndex  each item in the array is the start index of the nth path in _paths
485         @param _amounts         amount to convert from (in the initial source token) for each path
486         @param _minReturns      minimum return for each path. if the conversion results in an amount 
487                                 smaller than the minimum return - it is cancelled, must be nonzero
488         @param _for             account that will receive the conversions result
489 
490         @return amount of conversion result for each path
491     */
492     function convertForMultiple(IERC20Token[] _paths, uint256[] _pathStartIndex, uint256[] _amounts, uint256[] _minReturns, address _for)
493         public
494         payable
495         returns (uint256[])
496     {
497         // if ETH is provided, ensure that the total amount was converted into other tokens
498         uint256 convertedValue = 0;
499         uint256 pathEndIndex;
500         
501         // iterate over the conversion paths
502         for (uint256 i = 0; i < _pathStartIndex.length; i += 1) {
503             pathEndIndex = i == (_pathStartIndex.length - 1) ? _paths.length : _pathStartIndex[i + 1];
504 
505             // copy a single path from _paths into an array
506             IERC20Token[] memory path = new IERC20Token[](pathEndIndex - _pathStartIndex[i]);
507             for (uint256 j = _pathStartIndex[i]; j < pathEndIndex; j += 1) {
508                 path[j - _pathStartIndex[i]] = _paths[j];
509             }
510 
511             // if ETH is provided, ensure that the amount is lower than the path amount and
512             // verify that the source token is an ether token. otherwise ensure that 
513             // the source is not an ether token
514             IERC20Token fromToken = path[0];
515             require(msg.value == 0 || (_amounts[i] <= msg.value && etherTokens[fromToken]) || !etherTokens[fromToken]);
516 
517             // if ETH was sent with the call, the source is an ether token - deposit the ETH path amount in it.
518             // otherwise, we assume we already have the tokens
519             if (msg.value > 0 && etherTokens[fromToken]) {
520                 IEtherToken(fromToken).deposit.value(_amounts[i])();
521                 convertedValue += _amounts[i];
522             }
523             _amounts[i] = convertForInternal(path, _amounts[i], _minReturns[i], _for, 0x0, 0x0, 0x0, 0x0);
524         }
525 
526         // if ETH was provided, ensure that the full amount was converted
527         require(convertedValue == msg.value);
528 
529         return _amounts;
530     }
531 
532     /**
533         @dev converts token to any other token in the bancor network
534         by following a predefined conversion paths and transfers the result
535         tokens to a target account.
536 
537         @param _path        conversion path, see conversion path format above
538         @param _amount      amount to convert from (in the initial source token)
539         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
540         @param _for         account that will receive the conversion result
541         @param _block       if the current block exceeded the given parameter - it is cancelled
542         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
543         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
544         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
545 
546         @return tokens issued in return
547     */
548     function convertForInternal(
549         IERC20Token[] _path, 
550         uint256 _amount, 
551         uint256 _minReturn, 
552         address _for, 
553         uint256 _block, 
554         uint8 _v, 
555         bytes32 _r, 
556         bytes32 _s
557     )
558         private
559         validConversionPath(_path)
560         returns (uint256)
561     {
562         if (_v == 0x0 && _r == 0x0 && _s == 0x0)
563             gasPriceLimit.validateGasPrice(tx.gasprice);
564         else
565             require(verifyTrustedSender(_path, _amount, _block, _for, _v, _r, _s));
566 
567         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
568         IERC20Token fromToken = _path[0];
569 
570         IERC20Token toToken;
571         
572         (toToken, _amount) = convertByPath(_path, _amount, _minReturn, fromToken, _for);
573 
574         // finished the conversion, transfer the funds to the target account
575         // if the target token is an ether token, withdraw the tokens and send them as ETH
576         // otherwise, transfer the tokens as is
577         if (etherTokens[toToken])
578             IEtherToken(toToken).withdrawTo(_for, _amount);
579         else
580             assert(toToken.transfer(_for, _amount));
581 
582         return _amount;
583     }
584 
585     /**
586         @dev executes the actual conversion by following the conversion path
587 
588         @param _path        conversion path, see conversion path format above
589         @param _amount      amount to convert from (in the initial source token)
590         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
591         @param _fromToken   ERC20 token to convert from (the first element in the path)
592         @param _for         account that will receive the conversion result
593 
594         @return ERC20 token to convert to (the last element in the path) & tokens issued in return
595     */
596     function convertByPath(
597         IERC20Token[] _path,
598         uint256 _amount,
599         uint256 _minReturn,
600         IERC20Token _fromToken,
601         address _for
602     ) private returns (IERC20Token, uint256) {
603         ISmartToken smartToken;
604         IERC20Token toToken;
605         IBancorConverter converter;
606 
607         // get the contract features address from the registry
608         IContractFeatures features = IContractFeatures(registry.getAddress(ContractIds.CONTRACT_FEATURES));
609 
610         // iterate over the conversion path
611         uint256 pathLength = _path.length;
612         for (uint256 i = 1; i < pathLength; i += 2) {
613             smartToken = ISmartToken(_path[i]);
614             toToken = _path[i + 1];
615             converter = IBancorConverter(smartToken.owner());
616             checkWhitelist(converter, _for, features);
617 
618             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
619             if (smartToken != _fromToken)
620                 ensureAllowance(_fromToken, converter, _amount);
621 
622             // make the conversion - if it's the last one, also provide the minimum return value
623             _amount = converter.change(_fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
624             _fromToken = toToken;
625         }
626         return (toToken, _amount);
627     }
628 
629     /**
630         @dev checks whether the given converter supports a whitelist and if so, ensures that
631         the account that should receive the conversion result is actually whitelisted
632 
633         @param _converter   converter to check for whitelist
634         @param _for         account that will receive the conversion result
635         @param _features    contract features contract address
636     */
637     function checkWhitelist(IBancorConverter _converter, address _for, IContractFeatures _features) private view {
638         IWhitelist whitelist;
639 
640         // check if the converter supports the conversion whitelist feature
641         if (!_features.isSupported(_converter, FeatureIds.CONVERTER_CONVERSION_WHITELIST))
642             return;
643 
644         // get the whitelist contract from the converter
645         whitelist = _converter.conversionWhitelist();
646         if (whitelist == address(0))
647             return;
648 
649         // check if the account that should receive the conversion result is actually whitelisted
650         require(whitelist.isWhitelisted(_for));
651     }
652 
653     /**
654         @dev claims the caller's tokens, converts them to any other token in the bancor network
655         by following a predefined conversion path and transfers the result tokens to a target account
656         note that allowance must be set beforehand
657 
658         @param _path        conversion path, see conversion path format above
659         @param _amount      amount to convert from (in the initial source token)
660         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
661         @param _for         account that will receive the conversion result
662 
663         @return tokens issued in return
664     */
665     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
666         // we need to transfer the tokens from the caller to the converter before we follow
667         // the conversion path, to allow it to execute the conversion on behalf of the caller
668         // note: we assume we already have allowance
669         IERC20Token fromToken = _path[0];
670         assert(fromToken.transferFrom(msg.sender, this, _amount));
671         return convertFor(_path, _amount, _minReturn, _for);
672     }
673 
674     /**
675         @dev converts the token to any other token in the bancor network by following
676         a predefined conversion path and transfers the result tokens back to the sender
677         note that the converter should already own the source tokens
678 
679         @param _path        conversion path, see conversion path format above
680         @param _amount      amount to convert from (in the initial source token)
681         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
682 
683         @return tokens issued in return
684     */
685     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
686         return convertFor(_path, _amount, _minReturn, msg.sender);
687     }
688 
689     /**
690         @dev claims the caller's tokens, converts them to any other token in the bancor network
691         by following a predefined conversion path and transfers the result tokens back to the sender
692         note that allowance must be set beforehand
693 
694         @param _path        conversion path, see conversion path format above
695         @param _amount      amount to convert from (in the initial source token)
696         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
697 
698         @return tokens issued in return
699     */
700     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
701         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
702     }
703 
704     /**
705         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
706 
707         @param _token   token to check the allowance in
708         @param _spender approved address
709         @param _value   allowance amount
710     */
711     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
712         // check if allowance for the given amount already exists
713         if (_token.allowance(this, _spender) >= _value)
714             return;
715 
716         // if the allowance is nonzero, must reset it to 0 first
717         if (_token.allowance(this, _spender) != 0)
718             assert(_token.approve(_spender, 0));
719 
720         // approve the new allowance
721         assert(_token.approve(_spender, _value));
722     }
723 
724     // deprecated, backward compatibility
725     function convertForPrioritized(
726         IERC20Token[] _path,
727         uint256 _amount,
728         uint256 _minReturn,
729         address _for,
730         uint256 _block,
731         uint256 _nonce,
732         uint8 _v,
733         bytes32 _r,
734         bytes32 _s)
735         public payable returns (uint256)
736     {
737         convertForPrioritized2(_path, _amount, _minReturn, _for, _block, _v, _r, _s);
738     }
739 }