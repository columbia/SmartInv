1 pragma solidity ^0.4.18;
2 
3 /*
4     ERC20 Standard Token interface
5 */
6 contract IERC20Token {
7     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
8     function name() public view returns (string) {}
9     function symbol() public view returns (string) {}
10     function decimals() public view returns (uint8) {}
11     function totalSupply() public view returns (uint256) {}
12     function balanceOf(address _owner) public view returns (uint256) { _owner; }
13     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
14 
15     function transfer(address _to, uint256 _value) public returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 }
19 
20 
21 /*
22     Owned contract interface
23 */
24 contract IOwned {
25     // this function isn't abstract since the compiler emits automatically generated getter functions as external
26     function owner() public view returns (address) {}
27 
28     function transferOwnership(address _newOwner) public;
29     function acceptOwnership() public;
30 }
31 
32 
33 /*
34     Bancor Gas Price Limit interface
35 */
36 contract IBancorGasPriceLimit {
37     function gasPrice() public view returns (uint256) {}
38     function validateGasPrice(uint256) public view;
39 }
40 
41 
42 
43 /*
44     EIP228 Token Converter interface
45 */
46 contract ITokenConverter {
47     function convertibleTokenCount() public view returns (uint16);
48     function convertibleToken(uint16 _tokenIndex) public view returns (address);
49     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
50     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
51     // deprecated, backward compatibility
52     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
53 }
54 
55 
56 
57 
58 /*
59     Bancor Quick Converter interface
60 */
61 contract IBancorQuickConverter {
62     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
63     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
64     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);
65 }
66 
67 
68 
69 
70 
71 /*
72     Provides support and utilities for contract ownership
73 */
74 contract Owned is IOwned {
75     address public owner;
76     address public newOwner;
77 
78     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
79 
80     /**
81         @dev constructor
82     */
83     constructor () public {
84         owner = msg.sender;
85     }
86 
87     // allows execution by the owner only
88     modifier ownerOnly {
89         assert(msg.sender == owner);
90         _;
91     }
92 
93     /**
94         @dev allows transferring the contract ownership
95         the new owner still needs to accept the transfer
96         can only be called by the contract owner
97 
98         @param _newOwner    new contract owner
99     */
100     function transferOwnership(address _newOwner) public ownerOnly {
101         require(_newOwner != owner);
102         newOwner = _newOwner;
103     }
104 
105     /**
106         @dev used by a new owner to accept an ownership transfer
107     */
108     function acceptOwnership() public {
109         require(msg.sender == newOwner);
110         emit OwnerUpdate(owner, newOwner);
111         owner = newOwner;
112         newOwner = address(0);
113     }
114 }
115 
116 
117 
118 /*
119     Utilities & Common Modifiers
120 */
121 contract Utils {
122 
123     // verifies that an amount is greater than zero
124     modifier greaterThanZero(uint256 _amount) {
125         require(_amount > 0);
126         _;
127     }
128 
129     // validates an address - currently only checks that it isn't null
130     modifier validAddress(address _address) {
131         require(_address != address(0));
132         _;
133     }
134 
135     // verifies that the address is different than this contract address
136     modifier notThis(address _address) {
137         require(_address != address(this));
138         _;
139     }
140 
141     // Overflow protected math functions
142 
143     /**
144         @dev returns the sum of _x and _y, asserts if the calculation overflows
145 
146         @param _x   value 1
147         @param _y   value 2
148 
149         @return sum
150     */
151     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
152         uint256 z = _x + _y;
153         assert(z >= _x);
154         return z;
155     }
156 
157     /**
158         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
159 
160         @param _x   minuend
161         @param _y   subtrahend
162 
163         @return difference
164     */
165     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
166         assert(_x >= _y);
167         return _x - _y;
168     }
169 
170     /**
171         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
172 
173         @param _x   factor 1
174         @param _y   factor 2
175 
176         @return product
177     */
178     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
179         uint256 z = _x * _y;
180         assert(_x == 0 || z / _x == _y);
181         return z;
182     }
183 }
184 
185 
186 
187 
188 
189 
190 /*
191     Token Holder interface
192 */
193 contract ITokenHolder is IOwned {
194     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
195 }
196 
197 
198 /*
199     We consider every contract to be a 'token holder' since it's currently not possible
200     for a contract to deny receiving tokens.
201 
202     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
203     the owner to send tokens that were sent to the contract by mistake back to their sender.
204 */
205 contract TokenHolder is ITokenHolder, Owned, Utils {
206 
207     /**
208         @dev withdraws tokens held by the contract and sends them to an account
209         can only be called by the owner
210 
211         @param _token   ERC20 token contract address
212         @param _to      account to receive the new amount
213         @param _amount  amount to withdraw
214     */
215     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
216         public
217         ownerOnly
218         validAddress(_token)
219         validAddress(_to)
220         notThis(_to)
221     {
222         assert(_token.transfer(_to, _amount));
223     }
224 }
225 
226 
227 
228 
229 
230 
231 /*
232     Ether Token interface
233 */
234 contract IEtherToken is ITokenHolder, IERC20Token {
235     function deposit() public payable;
236     function withdraw(uint256 _amount) public;
237     function withdrawTo(address _to, uint256 _amount) public;
238 }
239 
240 
241 
242 
243 
244 /*
245     Smart Token interface
246 */
247 contract ISmartToken is IOwned, IERC20Token {
248     function disableTransfers(bool _disable) public;
249     function issue(address _to, uint256 _amount) public;
250     function destroy(address _from, uint256 _amount) public;
251 }
252 
253 
254 
255 /*
256     The BancorQuickConverter contract provides allows converting between any token in the 
257     bancor network in a single transaction.
258 
259     A note on conversion paths -
260     Conversion path is a data structure that's used when converting a token to another token in the bancor network
261     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
262     The path defines which converters should be used and what kind of conversion should be done in each step.
263 
264     The path format doesn't include complex structure and instead, it is represented by a single array
265     in which each 'hop' is represented by a 2-tuple - smart token & to token.
266     In addition, the first element is always the source token.
267     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
268 
269     Format:
270     [source token, smart token, to token, smart token, to token...]
271 */
272 contract BancorQuickConverter is IBancorQuickConverter, TokenHolder {
273     address public signerAddress = 0x0; // verified address that allows conversions with higher gas price
274     IBancorGasPriceLimit public gasPriceLimit; // bancor universal gas price limit contract
275     mapping (address => bool) public etherTokens;   // list of all supported ether tokens
276     mapping (bytes32 => bool) public conversionHashes;
277 
278     /**
279         @dev constructor
280     */
281     function BancorQuickConverter() public {
282     }
283 
284     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
285     modifier validConversionPath(IERC20Token[] _path) {
286         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
287         _;
288     }
289 
290     /*
291         @dev allows the owner to update the gas price limit contract address
292 
293         @param _gasPriceLimit   address of a bancor gas price limit contract
294     */
295     function setGasPriceLimit(IBancorGasPriceLimit _gasPriceLimit)
296         public
297         ownerOnly
298         validAddress(_gasPriceLimit)
299         notThis(_gasPriceLimit)
300     {
301         gasPriceLimit = _gasPriceLimit;
302     }
303 
304     /*
305         @dev allows the owner to update the signer address
306 
307         @param _signerAddress    new signer address
308     */
309     function setSignerAddress(address _signerAddress)
310         public
311         ownerOnly
312         validAddress(_signerAddress)
313         notThis(_signerAddress)
314     {
315         signerAddress = _signerAddress;
316     }
317 
318     /**
319         @dev allows the owner to register/unregister ether tokens
320 
321         @param _token       ether token contract address
322         @param _register    true to register, false to unregister
323     */
324     function registerEtherToken(IEtherToken _token, bool _register)
325         public
326         ownerOnly
327         validAddress(_token)
328         notThis(_token)
329     {
330         etherTokens[_token] = _register;
331     }
332 
333     /**
334         @dev verifies that the signer address is trusted by recovering 
335         the address associated with the public key from elliptic 
336         curve signature, returns zero on error.
337         notice that the signature is valid only for one conversion
338         and expires after the give block.
339 
340         @return true if the signer is verified
341     */
342     function verifyTrustedSender(uint256 _block, address _addr, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) private returns(bool) {
343         bytes32 hash = sha256(_block, tx.gasprice, _addr, _nonce);
344 
345         // checking that it is the first conversion with the given signature
346         // and that the current block number doesn't exceeded the maximum block
347         // number that's allowed with the current signature
348         require(!conversionHashes[hash] && block.number <= _block);
349 
350         // recovering the signing address and comparing it to the trusted signer
351         // address that was set in the contract
352         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
353         bytes32 prefixedHash = keccak256(prefix, hash);
354         bool verified = ecrecover(prefixedHash, _v, _r, _s) == signerAddress;
355 
356         // if the signer is the trusted signer - mark the hash so that it can't
357         // be used multiple times
358         if (verified)
359             conversionHashes[hash] = true;
360         return verified;
361     }
362 
363 /**
364         @dev converts the token to any other token in the bancor network by following
365         a predefined conversion path and transfers the result tokens to a target account
366         note that the converter should already own the source tokens
367 
368         @param _path        conversion path, see conversion path format above
369         @param _amount      amount to convert from (in the initial source token)
370         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
371         @param _for         account that will receive the conversion result
372 
373         @return tokens issued in return
374     */
375     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256) {
376         return convertForPrioritized(_path, _amount, _minReturn, _for, 0x0, 0x0, 0x0, 0x0, 0x0);
377     }
378 
379     /**
380         @dev converts the token to any other token in the bancor network
381         by following a predefined conversion path and transfers the result
382         tokens to a target account.
383         this specific version of the function also allows the verified signer
384         to bypass the universal gas price limit.
385         note that the converter should already own the source tokens
386 
387         @param _path        conversion path, see conversion path format above
388         @param _amount      amount to convert from (in the initial source token)
389         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
390         @param _for         account that will receive the conversion result
391 
392         @return tokens issued in return
393     */
394     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s)
395         public
396         payable
397         validConversionPath(_path)
398         returns (uint256)
399     {
400         if (_v == 0x0 && _r == 0x0 && _s == 0x0)
401             gasPriceLimit.validateGasPrice(tx.gasprice);
402         else
403             require(verifyTrustedSender(_block, _for, _nonce, _v, _r, _s));
404 
405         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
406         IERC20Token fromToken = _path[0];
407         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
408 
409         IERC20Token toToken;
410 
411         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
412         // otherwise, we assume we already have the tokens
413         if (msg.value > 0)
414             IEtherToken(fromToken).deposit.value(msg.value)();
415         
416         (_amount, toToken) = convertByPath(_path, _amount, _minReturn, fromToken);
417 
418         // finished the conversion, transfer the funds to the target account
419         // if the target token is an ether token, withdraw the tokens and send them as ETH
420         // otherwise, transfer the tokens as is
421         if (etherTokens[toToken])
422             IEtherToken(toToken).withdrawTo(_for, _amount);
423         else
424             assert(toToken.transfer(_for, _amount));
425 
426         return _amount;
427     }
428 
429     function convertByPath(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, IERC20Token _fromToken) private returns (uint256, IERC20Token) {
430         ISmartToken smartToken;
431         IERC20Token toToken;
432         ITokenConverter converter;
433 
434         // iterate over the conversion path
435         uint256 pathLength = _path.length;
436 
437         for (uint256 i = 1; i < pathLength; i += 2) {
438             smartToken = ISmartToken(_path[i]);
439             toToken = _path[i + 1];
440             converter = ITokenConverter(smartToken.owner());
441 
442             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
443             if (smartToken != _fromToken)
444                 ensureAllowance(_fromToken, converter, _amount);
445 
446             // make the conversion - if it's the last one, also provide the minimum return value
447             _amount = converter.change(_fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
448             _fromToken = toToken;
449         }
450         return (_amount, toToken);
451     }
452 
453     /**
454         @dev claims the caller's tokens, converts them to any other token in the bancor network
455         by following a predefined conversion path and transfers the result tokens to a target account
456         note that allowance must be set beforehand
457 
458         @param _path        conversion path, see conversion path format above
459         @param _amount      amount to convert from (in the initial source token)
460         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
461         @param _for         account that will receive the conversion result
462 
463         @return tokens issued in return
464     */
465     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
466         // we need to transfer the tokens from the caller to the converter before we follow
467         // the conversion path, to allow it to execute the conversion on behalf of the caller
468         // note: we assume we already have allowance
469         IERC20Token fromToken = _path[0];
470         assert(fromToken.transferFrom(msg.sender, this, _amount));
471         return convertFor(_path, _amount, _minReturn, _for);
472     }
473 
474     /**
475         @dev converts the token to any other token in the bancor network by following
476         a predefined conversion path and transfers the result tokens back to the sender
477         note that the converter should already own the source tokens
478 
479         @param _path        conversion path, see conversion path format above
480         @param _amount      amount to convert from (in the initial source token)
481         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
482 
483         @return tokens issued in return
484     */
485     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
486         return convertFor(_path, _amount, _minReturn, msg.sender);
487     }
488 
489     /**
490         @dev claims the caller's tokens, converts them to any other token in the bancor network
491         by following a predefined conversion path and transfers the result tokens back to the sender
492         note that allowance must be set beforehand
493 
494         @param _path        conversion path, see conversion path format above
495         @param _amount      amount to convert from (in the initial source token)
496         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
497 
498         @return tokens issued in return
499     */
500     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
501         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
502     }
503 
504     /**
505         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
506 
507         @param _token   token to check the allowance in
508         @param _spender approved address
509         @param _value   allowance amount
510     */
511     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
512         // check if allowance for the given amount already exists
513         if (_token.allowance(this, _spender) >= _value)
514             return;
515 
516         // if the allowance is nonzero, must reset it to 0 first
517         if (_token.allowance(this, _spender) != 0)
518             assert(_token.approve(_spender, 0));
519 
520         // approve the new allowance
521         assert(_token.approve(_spender, _value));
522     }
523 }