1 pragma solidity ^0.4.18;
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
76     ERC20 Standard Token interface
77 */
78 contract IERC20Token {
79     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
80     function name() public view returns (string) {}
81     function symbol() public view returns (string) {}
82     function decimals() public view returns (uint8) {}
83     function totalSupply() public view returns (uint256) {}
84     function balanceOf(address _owner) public view returns (uint256) { _owner; }
85     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
86 
87     function transfer(address _to, uint256 _value) public returns (bool success);
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89     function approve(address _spender, uint256 _value) public returns (bool success);
90 }
91 
92 /*
93     Owned contract interface
94 */
95 contract IOwned {
96     // this function isn't abstract since the compiler emits automatically generated getter functions as external
97     function owner() public view returns (address) {}
98 
99     function transferOwnership(address _newOwner) public;
100     function acceptOwnership() public;
101 }
102 
103 /*
104     Provides support and utilities for contract ownership
105 */
106 contract Owned is IOwned {
107     address public owner;
108     address public newOwner;
109 
110     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
111 
112     /**
113         @dev constructor
114     */
115     function Owned() public {
116         owner = msg.sender;
117     }
118 
119     // allows execution by the owner only
120     modifier ownerOnly {
121         assert(msg.sender == owner);
122         _;
123     }
124 
125     /**
126         @dev allows transferring the contract ownership
127         the new owner still needs to accept the transfer
128         can only be called by the contract owner
129 
130         @param _newOwner    new contract owner
131     */
132     function transferOwnership(address _newOwner) public ownerOnly {
133         require(_newOwner != owner);
134         newOwner = _newOwner;
135     }
136 
137     /**
138         @dev used by a new owner to accept an ownership transfer
139     */
140     function acceptOwnership() public {
141         require(msg.sender == newOwner);
142         OwnerUpdate(owner, newOwner);
143         owner = newOwner;
144         newOwner = address(0);
145     }
146 }
147 
148 /*
149     Token Holder interface
150 */
151 contract ITokenHolder is IOwned {
152     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
153 }
154 
155 /*
156     We consider every contract to be a 'token holder' since it's currently not possible
157     for a contract to deny receiving tokens.
158 
159     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
160     the owner to send tokens that were sent to the contract by mistake back to their sender.
161 */
162 contract TokenHolder is ITokenHolder, Owned, Utils {
163     /**
164         @dev constructor
165     */
166     function TokenHolder() public {
167     }
168 
169     /**
170         @dev withdraws tokens held by the contract and sends them to an account
171         can only be called by the owner
172 
173         @param _token   ERC20 token contract address
174         @param _to      account to receive the new amount
175         @param _amount  amount to withdraw
176     */
177     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
178         public
179         ownerOnly
180         validAddress(_token)
181         validAddress(_to)
182         notThis(_to)
183     {
184         assert(_token.transfer(_to, _amount));
185     }
186 }
187 
188 /*
189     Ether Token interface
190 */
191 contract IEtherToken is ITokenHolder, IERC20Token {
192     function deposit() public payable;
193     function withdraw(uint256 _amount) public;
194     function withdrawTo(address _to, uint256 _amount) public;
195 }
196 
197 /*
198     Smart Token interface
199 */
200 contract ISmartToken is IOwned, IERC20Token {
201     function disableTransfers(bool _disable) public;
202     function issue(address _to, uint256 _amount) public;
203     function destroy(address _from, uint256 _amount) public;
204 }
205 
206 /*
207     EIP228 Token Converter interface
208 */
209 contract ITokenConverter {
210     function convertibleTokenCount() public view returns (uint16);
211     function convertibleToken(uint16 _tokenIndex) public view returns (address);
212     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
213     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
214     // deprecated, backward compatibility
215     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
216 }
217 
218 /*
219     Bancor Gas Price Limit interface
220 */
221 contract IBancorGasPriceLimit {
222     function gasPrice() public view returns (uint256) {}
223     function validateGasPrice(uint256) public view;
224 }
225 
226 /*
227     Bancor Quick Converter interface
228 */
229 contract IBancorQuickConverter {
230     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
231     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
232     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);
233 }
234 
235 /*
236     The BancorQuickConverter contract provides allows converting between any token in the 
237     bancor network in a single transaction.
238 
239     A note on conversion paths -
240     Conversion path is a data structure that's used when converting a token to another token in the bancor network
241     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
242     The path defines which converters should be used and what kind of conversion should be done in each step.
243 
244     The path format doesn't include complex structure and instead, it is represented by a single array
245     in which each 'hop' is represented by a 2-tuple - smart token & to token.
246     In addition, the first element is always the source token.
247     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
248 
249     Format:
250     [source token, smart token, to token, smart token, to token...]
251 */
252 contract BancorQuickConverter is IBancorQuickConverter, TokenHolder {
253     address public signerAddress = 0x0; // verified address that allows conversions with higher gas price
254     IBancorGasPriceLimit public gasPriceLimit; // bancor universal gas price limit contract
255     mapping (address => bool) public etherTokens;   // list of all supported ether tokens
256     mapping (bytes32 => bool) public conversionHashes;
257 
258     /**
259         @dev constructor
260     */
261     function BancorQuickConverter() public {
262     }
263 
264     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
265     modifier validConversionPath(IERC20Token[] _path) {
266         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
267         _;
268     }
269 
270     /*
271         @dev allows the owner to update the gas price limit contract address
272 
273         @param _gasPriceLimit   address of a bancor gas price limit contract
274     */
275     function setGasPriceLimit(IBancorGasPriceLimit _gasPriceLimit)
276         public
277         ownerOnly
278         validAddress(_gasPriceLimit)
279         notThis(_gasPriceLimit)
280     {
281         gasPriceLimit = _gasPriceLimit;
282     }
283 
284     /*
285         @dev allows the owner to update the signer address
286 
287         @param _signerAddress    new signer address
288     */
289     function setSignerAddress(address _signerAddress)
290         public
291         ownerOnly
292         validAddress(_signerAddress)
293         notThis(_signerAddress)
294     {
295         signerAddress = _signerAddress;
296     }
297 
298     /**
299         @dev allows the owner to register/unregister ether tokens
300 
301         @param _token       ether token contract address
302         @param _register    true to register, false to unregister
303     */
304     function registerEtherToken(IEtherToken _token, bool _register)
305         public
306         ownerOnly
307         validAddress(_token)
308         notThis(_token)
309     {
310         etherTokens[_token] = _register;
311     }
312 
313     /**
314         @dev verifies that the signer address is trusted by recovering 
315         the address associated with the public key from elliptic 
316         curve signature, returns zero on error.
317         notice that the signature is valid only for one conversion
318         and expires after the give block.
319 
320         @return true if the signer is verified
321     */
322     function verifyTrustedSender(uint256 _block, address _addr, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) private returns(bool) {
323         bytes32 hash = sha256(_block, tx.gasprice, _addr, _nonce);
324 
325         // checking that it is the first conversion with the given signature
326         // and that the current block number doesn't exceeded the maximum block
327         // number that's allowed with the current signature
328         require(!conversionHashes[hash] && block.number <= _block);
329 
330         // recovering the signing address and comparing it to the trusted signer
331         // address that was set in the contract
332         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
333         bytes32 prefixedHash = keccak256(prefix, hash);
334         bool verified = ecrecover(prefixedHash, _v, _r, _s) == signerAddress;
335 
336         // if the signer is the trusted signer - mark the hash so that it can't
337         // be used multiple times
338         if (verified)
339             conversionHashes[hash] = true;
340         return verified;
341     }
342 
343 /**
344         @dev converts the token to any other token in the bancor network by following
345         a predefined conversion path and transfers the result tokens to a target account
346         note that the converter should already own the source tokens
347 
348         @param _path        conversion path, see conversion path format above
349         @param _amount      amount to convert from (in the initial source token)
350         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
351         @param _for         account that will receive the conversion result
352 
353         @return tokens issued in return
354     */
355     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256) {
356         return convertForPrioritized(_path, _amount, _minReturn, _for, 0x0, 0x0, 0x0, 0x0, 0x0);
357     }
358 
359     /**
360         @dev converts the token to any other token in the bancor network
361         by following a predefined conversion path and transfers the result
362         tokens to a target account.
363         this specific version of the function also allows the verified signer
364         to bypass the universal gas price limit.
365         note that the converter should already own the source tokens
366 
367         @param _path        conversion path, see conversion path format above
368         @param _amount      amount to convert from (in the initial source token)
369         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
370         @param _for         account that will receive the conversion result
371 
372         @return tokens issued in return
373     */
374     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s)
375         public
376         payable
377         validConversionPath(_path)
378         returns (uint256)
379     {
380         if (_v == 0x0 && _r == 0x0 && _s == 0x0)
381             gasPriceLimit.validateGasPrice(tx.gasprice);
382         else
383             require(verifyTrustedSender(_block, _for, _nonce, _v, _r, _s));
384 
385         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
386         IERC20Token fromToken = _path[0];
387         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
388 
389         IERC20Token toToken;
390 
391         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
392         // otherwise, we assume we already have the tokens
393         if (msg.value > 0)
394             IEtherToken(fromToken).deposit.value(msg.value)();
395         
396         (_amount, toToken) = convertByPath(_path, _amount, _minReturn, fromToken);
397 
398         // finished the conversion, transfer the funds to the target account
399         // if the target token is an ether token, withdraw the tokens and send them as ETH
400         // otherwise, transfer the tokens as is
401         if (etherTokens[toToken])
402             IEtherToken(toToken).withdrawTo(_for, _amount);
403         else
404             assert(toToken.transfer(_for, _amount));
405 
406         return _amount;
407     }
408 
409     function convertByPath(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, IERC20Token _fromToken) private returns (uint256, IERC20Token) {
410         ISmartToken smartToken;
411         IERC20Token toToken;
412         ITokenConverter converter;
413 
414         // iterate over the conversion path
415         uint256 pathLength = _path.length;
416 
417         for (uint256 i = 1; i < pathLength; i += 2) {
418             smartToken = ISmartToken(_path[i]);
419             toToken = _path[i + 1];
420             converter = ITokenConverter(smartToken.owner());
421 
422             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
423             if (smartToken != _fromToken)
424                 ensureAllowance(_fromToken, converter, _amount);
425 
426             // make the conversion - if it's the last one, also provide the minimum return value
427             _amount = converter.change(_fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
428             _fromToken = toToken;
429         }
430         return (_amount, toToken);
431     }
432 
433     /**
434         @dev claims the caller's tokens, converts them to any other token in the bancor network
435         by following a predefined conversion path and transfers the result tokens to a target account
436         note that allowance must be set beforehand
437 
438         @param _path        conversion path, see conversion path format above
439         @param _amount      amount to convert from (in the initial source token)
440         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
441         @param _for         account that will receive the conversion result
442 
443         @return tokens issued in return
444     */
445     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
446         // we need to transfer the tokens from the caller to the converter before we follow
447         // the conversion path, to allow it to execute the conversion on behalf of the caller
448         // note: we assume we already have allowance
449         IERC20Token fromToken = _path[0];
450         assert(fromToken.transferFrom(msg.sender, this, _amount));
451         return convertFor(_path, _amount, _minReturn, _for);
452     }
453 
454     /**
455         @dev converts the token to any other token in the bancor network by following
456         a predefined conversion path and transfers the result tokens back to the sender
457         note that the converter should already own the source tokens
458 
459         @param _path        conversion path, see conversion path format above
460         @param _amount      amount to convert from (in the initial source token)
461         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
462 
463         @return tokens issued in return
464     */
465     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
466         return convertFor(_path, _amount, _minReturn, msg.sender);
467     }
468 
469     /**
470         @dev claims the caller's tokens, converts them to any other token in the bancor network
471         by following a predefined conversion path and transfers the result tokens back to the sender
472         note that allowance must be set beforehand
473 
474         @param _path        conversion path, see conversion path format above
475         @param _amount      amount to convert from (in the initial source token)
476         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
477 
478         @return tokens issued in return
479     */
480     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
481         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
482     }
483 
484     /**
485         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
486 
487         @param _token   token to check the allowance in
488         @param _spender approved address
489         @param _value   allowance amount
490     */
491     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
492         // check if allowance for the given amount already exists
493         if (_token.allowance(this, _spender) >= _value)
494             return;
495 
496         // if the allowance is nonzero, must reset it to 0 first
497         if (_token.allowance(this, _spender) != 0)
498             assert(_token.approve(_spender, 0));
499 
500         // approve the new allowance
501         assert(_token.approve(_spender, _value));
502     }
503 }