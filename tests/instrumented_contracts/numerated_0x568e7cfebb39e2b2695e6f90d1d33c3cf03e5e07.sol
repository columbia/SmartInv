1 pragma solidity ^0.4.21;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     function Utils() public {
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
21         require(_address != address(0));
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
41     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
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
55     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
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
68     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 /*
76     Owned contract interface
77 */
78 contract IOwned {
79     // this function isn't abstract since the compiler emits automatically generated getter functions as external
80     function owner() public view returns (address) {}
81 
82     function transferOwnership(address _newOwner) public;
83     function acceptOwnership() public;
84 }
85 
86 /*
87     Provides support and utilities for contract ownership
88 */
89 contract Owned is IOwned {
90     address public owner;
91     address public newOwner;
92 
93     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
94 
95     /**
96         @dev constructor
97     */
98     function Owned() public {
99         owner = msg.sender;
100     }
101 
102     // allows execution by the owner only
103     modifier ownerOnly {
104         assert(msg.sender == owner);
105         _;
106     }
107 
108     /**
109         @dev allows transferring the contract ownership
110         the new owner still needs to accept the transfer
111         can only be called by the contract owner
112 
113         @param _newOwner    new contract owner
114     */
115     function transferOwnership(address _newOwner) public ownerOnly {
116         require(_newOwner != owner);
117         newOwner = _newOwner;
118     }
119 
120     /**
121         @dev used by a new owner to accept an ownership transfer
122     */
123     function acceptOwnership() public {
124         require(msg.sender == newOwner);
125         emit OwnerUpdate(owner, newOwner);
126         owner = newOwner;
127         newOwner = address(0);
128     }
129 }
130 
131 /*
132     ERC20 Standard Token interface
133 */
134 contract IERC20Token {
135     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
136     function name() public view returns (string) {}
137     function symbol() public view returns (string) {}
138     function decimals() public view returns (uint8) {}
139     function totalSupply() public view returns (uint256) {}
140     function balanceOf(address _owner) public view returns (uint256) { _owner; }
141     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
142 
143     function transfer(address _to, uint256 _value) public returns (bool success);
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
145     function approve(address _spender, uint256 _value) public returns (bool success);
146 }
147 
148 /*
149     Smart Token interface
150 */
151 contract ISmartToken is IOwned, IERC20Token {
152     function disableTransfers(bool _disable) public;
153     function issue(address _to, uint256 _amount) public;
154     function destroy(address _from, uint256 _amount) public;
155 }
156 
157 /*
158     Contract Registry interface
159 */
160 contract IContractRegistry {
161     function getAddress(bytes32 _contractName) public view returns (address);
162 }
163 
164 /*
165     Contract Features interface
166 */
167 contract IContractFeatures {
168     function isSupported(address _contract, uint256 _features) public view returns (bool);
169     function enableFeatures(uint256 _features, bool _enable) public;
170 }
171 
172 /*
173     Bancor Gas Price Limit interface
174 */
175 contract IBancorGasPriceLimit {
176     function gasPrice() public view returns (uint256) {}
177     function validateGasPrice(uint256) public view;
178 }
179 
180 /*
181     Whitelist interface
182 */
183 contract IWhitelist {
184     function isWhitelisted(address _address) public view returns (bool);
185 }
186 
187 /**
188     Id definitions for bancor contracts
189 
190     Can be used in conjunction with the contract registry to get contract addresses
191 */
192 contract ContractIds {
193     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
194     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
195     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
196 }
197 
198 /**
199     Id definitions for bancor contract features
200 
201     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
202 */
203 contract FeatureIds {
204     // converter features
205     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
206 }
207 
208 /*
209     Token Holder interface
210 */
211 contract ITokenHolder is IOwned {
212     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
213 }
214 
215 /*
216     We consider every contract to be a 'token holder' since it's currently not possible
217     for a contract to deny receiving tokens.
218 
219     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
220     the owner to send tokens that were sent to the contract by mistake back to their sender.
221 */
222 contract TokenHolder is ITokenHolder, Owned, Utils {
223     /**
224         @dev constructor
225     */
226     function TokenHolder() public {
227     }
228 
229     /**
230         @dev withdraws tokens held by the contract and sends them to an account
231         can only be called by the owner
232 
233         @param _token   ERC20 token contract address
234         @param _to      account to receive the new amount
235         @param _amount  amount to withdraw
236     */
237     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
238         public
239         ownerOnly
240         validAddress(_token)
241         validAddress(_to)
242         notThis(_to)
243     {
244         assert(_token.transfer(_to, _amount));
245     }
246 }
247 
248 /*
249     Ether Token interface
250 */
251 contract IEtherToken is ITokenHolder, IERC20Token {
252     function deposit() public payable;
253     function withdraw(uint256 _amount) public;
254     function withdrawTo(address _to, uint256 _amount) public;
255 }
256 
257 /*
258     Bancor Converter interface
259 */
260 contract IBancorConverter {
261     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
262     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
263     function conversionWhitelist() public view returns (IWhitelist) {}
264     // deprecated, backward compatibility
265     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
266 }
267 
268 /*
269     Bancor Network interface
270 */
271 contract IBancorNetwork {
272     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
273     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
274     function convertForPrioritized(
275         IERC20Token[] _path,
276         uint256 _amount,
277         uint256 _minReturn,
278         address _for,
279         uint256 _block,
280         uint8 _v,
281         bytes32 _r,
282         bytes32 _s)
283         public payable returns (uint256);
284 }
285 
286 /*
287     The BancorNetwork contract is the main entry point for bancor token conversions.
288     It also allows converting between any token in the bancor network to any other token
289     in a single transaction by providing a conversion path.
290 
291     A note on conversion path -
292     Conversion path is a data structure that's used when converting a token to another token in the bancor network
293     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
294     The path defines which converters should be used and what kind of conversion should be done in each step.
295 
296     The path format doesn't include complex structure and instead, it is represented by a single array
297     in which each 'hop' is represented by a 2-tuple - smart token & to token.
298     In addition, the first element is always the source token.
299     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
300 
301     Format:
302     [source token, smart token, to token, smart token, to token...]
303 */
304 contract BancorNetwork is IBancorNetwork, TokenHolder, ContractIds, FeatureIds {
305     address public signerAddress = 0x0;         // verified address that allows conversions with higher gas price
306     IContractRegistry public registry;          // contract registry contract address
307     IBancorGasPriceLimit public gasPriceLimit;  // bancor universal gas price limit contract
308 
309     mapping (address => bool) public etherTokens;       // list of all supported ether tokens
310     mapping (bytes32 => bool) public conversionHashes;  // list of conversion hashes, to prevent re-use of the same hash
311 
312     /**
313         @dev constructor
314 
315         @param _registry    address of a contract registry contract
316     */
317     function BancorNetwork(IContractRegistry _registry) public validAddress(_registry) {
318         registry = _registry;
319     }
320 
321     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
322     modifier validConversionPath(IERC20Token[] _path) {
323         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
324         _;
325     }
326 
327     /*
328         @dev allows the owner to update the contract registry contract address
329 
330         @param _registry   address of a contract registry contract
331     */
332     function setContractRegistry(IContractRegistry _registry)
333         public
334         ownerOnly
335         validAddress(_registry)
336         notThis(_registry)
337     {
338         registry = _registry;
339     }
340 
341     /*
342         @dev allows the owner to update the gas price limit contract address
343 
344         @param _gasPriceLimit   address of a bancor gas price limit contract
345     */
346     function setGasPriceLimit(IBancorGasPriceLimit _gasPriceLimit)
347         public
348         ownerOnly
349         validAddress(_gasPriceLimit)
350         notThis(_gasPriceLimit)
351     {
352         gasPriceLimit = _gasPriceLimit;
353     }
354 
355     /*
356         @dev allows the owner to update the signer address
357 
358         @param _signerAddress    new signer address
359     */
360     function setSignerAddress(address _signerAddress)
361         public
362         ownerOnly
363         validAddress(_signerAddress)
364         notThis(_signerAddress)
365     {
366         signerAddress = _signerAddress;
367     }
368 
369     /**
370         @dev allows the owner to register/unregister ether tokens
371 
372         @param _token       ether token contract address
373         @param _register    true to register, false to unregister
374     */
375     function registerEtherToken(IEtherToken _token, bool _register)
376         public
377         ownerOnly
378         validAddress(_token)
379         notThis(_token)
380     {
381         etherTokens[_token] = _register;
382     }
383 
384     /**
385         @dev verifies that the signer address is trusted by recovering 
386         the address associated with the public key from elliptic 
387         curve signature, returns zero on error.
388         notice that the signature is valid only for one conversion
389         and expires after the give block.
390 
391         @return true if the signer is verified
392     */
393     function verifyTrustedSender(IERC20Token[] _path, uint256 _amount, uint256 _block, address _addr, uint8 _v, bytes32 _r, bytes32 _s) private returns(bool) {
394         bytes32 hash = keccak256(_block, tx.gasprice, _addr, msg.sender, _amount, _path);
395 
396         // checking that it is the first conversion with the given signature
397         // and that the current block number doesn't exceeded the maximum block
398         // number that's allowed with the current signature
399         require(!conversionHashes[hash] && block.number <= _block);
400 
401         // recovering the signing address and comparing it to the trusted signer
402         // address that was set in the contract
403         bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", hash);
404         bool verified = ecrecover(prefixedHash, _v, _r, _s) == signerAddress;
405 
406         // if the signer is the trusted signer - mark the hash so that it can't
407         // be used multiple times
408         if (verified)
409             conversionHashes[hash] = true;
410         return verified;
411     }
412 
413     /**
414         @dev converts the token to any other token in the bancor network by following
415         a predefined conversion path and transfers the result tokens to a target account
416         note that the converter should already own the source tokens
417 
418         @param _path        conversion path, see conversion path format above
419         @param _amount      amount to convert from (in the initial source token)
420         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
421         @param _for         account that will receive the conversion result
422 
423         @return tokens issued in return
424     */
425     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256) {
426         return convertForPrioritized(_path, _amount, _minReturn, _for, 0x0, 0x0, 0x0, 0x0);
427     }
428 
429     /**
430         @dev converts the token to any other token in the bancor network
431         by following a predefined conversion path and transfers the result
432         tokens to a target account.
433         this version of the function also allows the verified signer
434         to bypass the universal gas price limit.
435         note that the converter should already own the source tokens
436 
437         @param _path        conversion path, see conversion path format above
438         @param _amount      amount to convert from (in the initial source token)
439         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
440         @param _for         account that will receive the conversion result
441 
442         @return tokens issued in return
443     */
444     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
445         public
446         payable
447         validConversionPath(_path)
448         returns (uint256)
449     {
450         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
451         IERC20Token fromToken = _path[0];
452         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
453 
454         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
455         // otherwise, we assume we already have the tokens
456         if (msg.value > 0)
457             IEtherToken(fromToken).deposit.value(msg.value)();
458 
459         return convertForInternal(_path, _amount, _minReturn, _for, _block, _v, _r, _s);
460     }
461 
462     /**
463         @dev converts token to any other token in the bancor network
464         by following the predefined conversion paths and transfers the result
465         tokens to a targeted account.
466         this version of the function also allows multiple conversions
467         in a single atomic transaction.
468         note that the converter should already own the source tokens
469 
470         @param _paths           merged conversion paths, i.e. [path1, path2, ...]. see conversion path format above
471         @param _pathStartIndex  each item in the array is the start index of the nth path in _paths
472         @param _amounts         amount to convert from (in the initial source token) for each path
473         @param _minReturns      minimum return for each path. if the conversion results in an amount 
474                                 smaller than the minimum return - it is cancelled, must be nonzero
475         @param _for             account that will receive the conversions result
476 
477         @return amount of conversion result for each path
478     */
479     function convertForMultiple(IERC20Token[] _paths, uint256[] _pathStartIndex, uint256[] _amounts, uint256[] _minReturns, address _for)
480         public
481         payable
482         returns (uint256[])
483     {
484         // if ETH is provided, ensure that the total amount was converted into other tokens
485         uint256 convertedValue = 0;
486         uint256 pathEndIndex;
487         
488         // iterate over the conversion paths
489         for (uint256 i = 0; i < _pathStartIndex.length; i += 1) {
490             pathEndIndex = i == (_pathStartIndex.length - 1) ? _paths.length : _pathStartIndex[i + 1];
491 
492             // copy a single path from _paths into an array
493             IERC20Token[] memory path = new IERC20Token[](pathEndIndex - _pathStartIndex[i]);
494             for (uint256 j = _pathStartIndex[i]; j < pathEndIndex; j += 1) {
495                 path[j - _pathStartIndex[i]] = _paths[j];
496             }
497 
498             // if ETH is provided, ensure that the amount is lower than the path amount and
499             // verify that the source token is an ether token. otherwise ensure that 
500             // the source is not an ether token
501             IERC20Token fromToken = path[0];
502             require(msg.value == 0 || (_amounts[i] <= msg.value && etherTokens[fromToken]) || !etherTokens[fromToken]);
503 
504             // if ETH was sent with the call, the source is an ether token - deposit the ETH path amount in it.
505             // otherwise, we assume we already have the tokens
506             if (msg.value > 0 && etherTokens[fromToken]) {
507                 IEtherToken(fromToken).deposit.value(_amounts[i])();
508                 convertedValue += _amounts[i];
509             }
510             _amounts[i] = convertForInternal(path, _amounts[i], _minReturns[i], _for, 0x0, 0x0, 0x0, 0x0);
511         }
512 
513         // if ETH was provided, ensure that the full amount was converted
514         require(convertedValue == msg.value);
515 
516         return _amounts;
517     }
518 
519     /**
520         @dev converts token to any other token in the bancor network
521         by following a predefined conversion paths and transfers the result
522         tokens to a target account.
523 
524         @param _path        conversion path, see conversion path format above
525         @param _amount      amount to convert from (in the initial source token)
526         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
527         @param _for         account that will receive the conversion result
528         @param _block       if the current block exceeded the given parameter - it is cancelled
529         @param _v           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
530         @param _r           (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
531         @param _s           (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
532 
533         @return tokens issued in return
534     */
535     function convertForInternal(
536         IERC20Token[] _path, 
537         uint256 _amount, 
538         uint256 _minReturn, 
539         address _for, 
540         uint256 _block, 
541         uint8 _v, 
542         bytes32 _r, 
543         bytes32 _s
544     )
545         private
546         validConversionPath(_path)
547         returns (uint256)
548     {
549         if (_v == 0x0 && _r == 0x0 && _s == 0x0)
550             gasPriceLimit.validateGasPrice(tx.gasprice);
551         else
552             require(verifyTrustedSender(_path, _amount, _block, _for, _v, _r, _s));
553 
554         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
555         IERC20Token fromToken = _path[0];
556 
557         IERC20Token toToken;
558         
559         (toToken, _amount) = convertByPath(_path, _amount, _minReturn, fromToken, _for);
560 
561         // finished the conversion, transfer the funds to the target account
562         // if the target token is an ether token, withdraw the tokens and send them as ETH
563         // otherwise, transfer the tokens as is
564         if (etherTokens[toToken])
565             IEtherToken(toToken).withdrawTo(_for, _amount);
566         else
567             assert(toToken.transfer(_for, _amount));
568 
569         return _amount;
570     }
571 
572     /**
573         @dev executes the actual conversion by following the conversion path
574 
575         @param _path        conversion path, see conversion path format above
576         @param _amount      amount to convert from (in the initial source token)
577         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
578         @param _fromToken   ERC20 token to convert from (the first element in the path)
579         @param _for         account that will receive the conversion result
580 
581         @return ERC20 token to convert to (the last element in the path) & tokens issued in return
582     */
583     function convertByPath(
584         IERC20Token[] _path,
585         uint256 _amount,
586         uint256 _minReturn,
587         IERC20Token _fromToken,
588         address _for
589     ) private returns (IERC20Token, uint256) {
590         ISmartToken smartToken;
591         IERC20Token toToken;
592         IBancorConverter converter;
593 
594         // get the contract features address from the registry
595         IContractFeatures features = IContractFeatures(registry.getAddress(ContractIds.CONTRACT_FEATURES));
596 
597         // iterate over the conversion path
598         uint256 pathLength = _path.length;
599         for (uint256 i = 1; i < pathLength; i += 2) {
600             smartToken = ISmartToken(_path[i]);
601             toToken = _path[i + 1];
602             converter = IBancorConverter(smartToken.owner());
603             checkWhitelist(converter, _for, features);
604 
605             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
606             if (smartToken != _fromToken)
607                 ensureAllowance(_fromToken, converter, _amount);
608 
609             // make the conversion - if it's the last one, also provide the minimum return value
610             _amount = converter.change(_fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
611             _fromToken = toToken;
612         }
613         return (toToken, _amount);
614     }
615 
616     /**
617         @dev checks whether the given converter supports a whitelist and if so, ensures that
618         the account that should receive the conversion result is actually whitelisted
619 
620         @param _converter   converter to check for whitelist
621         @param _for         account that will receive the conversion result
622         @param _features    contract features contract address
623     */
624     function checkWhitelist(IBancorConverter _converter, address _for, IContractFeatures _features) private view {
625         IWhitelist whitelist;
626 
627         // check if the converter supports the conversion whitelist feature
628         if (!_features.isSupported(_converter, FeatureIds.CONVERTER_CONVERSION_WHITELIST))
629             return;
630 
631         // get the whitelist contract from the converter
632         whitelist = _converter.conversionWhitelist();
633         if (whitelist == address(0))
634             return;
635 
636         // check if the account that should receive the conversion result is actually whitelisted
637         require(whitelist.isWhitelisted(_for));
638     }
639 
640     /**
641         @dev claims the caller's tokens, converts them to any other token in the bancor network
642         by following a predefined conversion path and transfers the result tokens to a target account
643         note that allowance must be set beforehand
644 
645         @param _path        conversion path, see conversion path format above
646         @param _amount      amount to convert from (in the initial source token)
647         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
648         @param _for         account that will receive the conversion result
649 
650         @return tokens issued in return
651     */
652     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
653         // we need to transfer the tokens from the caller to the converter before we follow
654         // the conversion path, to allow it to execute the conversion on behalf of the caller
655         // note: we assume we already have allowance
656         IERC20Token fromToken = _path[0];
657         assert(fromToken.transferFrom(msg.sender, this, _amount));
658         return convertFor(_path, _amount, _minReturn, _for);
659     }
660 
661     /**
662         @dev converts the token to any other token in the bancor network by following
663         a predefined conversion path and transfers the result tokens back to the sender
664         note that the converter should already own the source tokens
665 
666         @param _path        conversion path, see conversion path format above
667         @param _amount      amount to convert from (in the initial source token)
668         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
669 
670         @return tokens issued in return
671     */
672     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
673         return convertFor(_path, _amount, _minReturn, msg.sender);
674     }
675 
676     /**
677         @dev claims the caller's tokens, converts them to any other token in the bancor network
678         by following a predefined conversion path and transfers the result tokens back to the sender
679         note that allowance must be set beforehand
680 
681         @param _path        conversion path, see conversion path format above
682         @param _amount      amount to convert from (in the initial source token)
683         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
684 
685         @return tokens issued in return
686     */
687     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
688         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
689     }
690 
691     /**
692         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
693 
694         @param _token   token to check the allowance in
695         @param _spender approved address
696         @param _value   allowance amount
697     */
698     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
699         // check if allowance for the given amount already exists
700         if (_token.allowance(this, _spender) >= _value)
701             return;
702 
703         // if the allowance is nonzero, must reset it to 0 first
704         if (_token.allowance(this, _spender) != 0)
705             assert(_token.approve(_spender, 0));
706 
707         // approve the new allowance
708         assert(_token.approve(_spender, _value));
709     }
710 }