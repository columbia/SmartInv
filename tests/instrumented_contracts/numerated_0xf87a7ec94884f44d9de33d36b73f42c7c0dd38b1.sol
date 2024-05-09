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
75 /*
76     Owned contract interface
77 */
78 contract IOwned {
79     // this function isn't abstract since the compiler emits automatically generated getter functions as external
80     function owner() public constant returns (address) {}
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
93     event OwnerUpdate(address _prevOwner, address _newOwner);
94 
95     /**
96         @dev constructor
97     */
98     function Owned() {
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
125         OwnerUpdate(owner, newOwner);
126         owner = newOwner;
127         newOwner = 0x0;
128     }
129 }
130 
131 /*
132     ERC20 Standard Token interface
133 */
134 contract IERC20Token {
135     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
136     function name() public constant returns (string) {}
137     function symbol() public constant returns (string) {}
138     function decimals() public constant returns (uint8) {}
139     function totalSupply() public constant returns (uint256) {}
140     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
141     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
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
158     Token Holder interface
159 */
160 contract ITokenHolder is IOwned {
161     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
162 }
163 
164 /*
165     We consider every contract to be a 'token holder' since it's currently not possible
166     for a contract to deny receiving tokens.
167 
168     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
169     the owner to send tokens that were sent to the contract by mistake back to their sender.
170 */
171 contract TokenHolder is ITokenHolder, Owned, Utils {
172     /**
173         @dev constructor
174     */
175     function TokenHolder() {
176     }
177 
178     /**
179         @dev withdraws tokens held by the contract and sends them to an account
180         can only be called by the owner
181 
182         @param _token   ERC20 token contract address
183         @param _to      account to receive the new amount
184         @param _amount  amount to withdraw
185     */
186     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
187         public
188         ownerOnly
189         validAddress(_token)
190         validAddress(_to)
191         notThis(_to)
192     {
193         assert(_token.transfer(_to, _amount));
194     }
195 }
196 
197 /*
198     Ether Token interface
199 */
200 contract IEtherToken is ITokenHolder, IERC20Token {
201     function deposit() public payable;
202     function withdraw(uint256 _amount) public;
203     function withdrawTo(address _to, uint256 _amount);
204 }
205 
206 /*
207     EIP228 Token Converter interface
208 */
209 contract ITokenConverter {
210     function convertibleTokenCount() public constant returns (uint16);
211     function convertibleToken(uint16 _tokenIndex) public constant returns (address);
212     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256);
213     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
214     // deprecated, backward compatibility
215     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
216 }
217 
218 /*
219     Bancor Quick Converter interface
220 */
221 contract IBancorQuickConverter {
222     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
223     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
224 }
225 
226 /*
227     The BancorQuickConverter contract provides allows converting between any token in the 
228     bancor network in a single transaction.
229 
230     A note on conversion paths -
231     Conversion path is a data structure that's used when converting a token to another token in the bancor network
232     when the conversion cannot necessarily be done by single converter and might require multiple 'hops'.
233     The path defines which converters should be used and what kind of conversion should be done in each step.
234 
235     The path format doesn't include complex structure and instead, it is represented by a single array
236     in which each 'hop' is represented by a 2-tuple - smart token & to token.
237     In addition, the first element is always the source token.
238     The smart token is only used as a pointer to a converter (since converter addresses are more likely to change).
239 
240     Format:
241     [source token, smart token, to token, smart token, to token...]
242 */
243 contract BancorQuickConverter is IBancorQuickConverter, TokenHolder {
244     mapping (address => bool) public etherTokens;   // list of all supported ether tokens
245 
246     /**
247         @dev constructor
248     */
249     function BancorQuickConverter() {
250     }
251 
252     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
253     modifier validConversionPath(IERC20Token[] _path) {
254         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
255         _;
256     }
257 
258     /**
259         @dev allows the owner to register/unregister ether tokens
260 
261         @param _token       ether token contract address
262         @param _register    true to register, false to unregister
263     */
264     function registerEtherToken(IEtherToken _token, bool _register)
265         public
266         ownerOnly
267         validAddress(_token)
268         notThis(_token)
269     {
270         etherTokens[_token] = _register;
271     }
272 
273     /**
274         @dev converts the token to any other token in the bancor network by following
275         a predefined conversion path and transfers the result tokens to a target account
276         note that the converter should already own the source tokens
277 
278         @param _path        conversion path, see conversion path format above
279         @param _amount      amount to convert from (in the initial source token)
280         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
281         @param _for         account that will receive the conversion result
282 
283         @return tokens issued in return
284     */
285     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for)
286         public
287         payable
288         validConversionPath(_path)
289         returns (uint256)
290     {
291         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
292         IERC20Token fromToken = _path[0];
293         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
294 
295         ISmartToken smartToken;
296         IERC20Token toToken;
297         ITokenConverter converter;
298         uint256 pathLength = _path.length;
299 
300         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
301         // otherwise, we assume we already have the tokens
302         if (msg.value > 0)
303             IEtherToken(fromToken).deposit.value(msg.value)();
304 
305         // iterate over the conversion path
306         for (uint256 i = 1; i < pathLength; i += 2) {
307             smartToken = ISmartToken(_path[i]);
308             toToken = _path[i + 1];
309             converter = ITokenConverter(smartToken.owner());
310 
311             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
312             if (smartToken != fromToken)
313                 ensureAllowance(fromToken, converter, _amount);
314 
315             // make the conversion - if it's the last one, also provide the minimum return value
316             _amount = converter.change(fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
317             fromToken = toToken;
318         }
319 
320         // finished the conversion, transfer the funds to the target account
321         // if the target token is an ether token, withdraw the tokens and send them as ETH
322         // otherwise, transfer the tokens as is
323         if (etherTokens[toToken])
324             IEtherToken(toToken).withdrawTo(_for, _amount);
325         else
326             assert(toToken.transfer(_for, _amount));
327 
328         return _amount;
329     }
330 
331     /**
332         @dev claims the caller's tokens, converts them to any other token in the bancor network
333         by following a predefined conversion path and transfers the result tokens to a target account
334         note that allowance must be set beforehand
335 
336         @param _path        conversion path, see conversion path format above
337         @param _amount      amount to convert from (in the initial source token)
338         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
339         @param _for         account that will receive the conversion result
340 
341         @return tokens issued in return
342     */
343     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
344         // we need to transfer the tokens from the caller to the converter before we follow
345         // the conversion path, to allow it to execute the conversion on behalf of the caller
346         // note: we assume we already have allowance
347         IERC20Token fromToken = _path[0];
348         assert(fromToken.transferFrom(msg.sender, this, _amount));
349         return convertFor(_path, _amount, _minReturn, _for);
350     }
351 
352     /**
353         @dev converts the token to any other token in the bancor network by following
354         a predefined conversion path and transfers the result tokens back to the sender
355         note that the converter should already own the source tokens
356 
357         @param _path        conversion path, see conversion path format above
358         @param _amount      amount to convert from (in the initial source token)
359         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
360 
361         @return tokens issued in return
362     */
363     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
364         return convertFor(_path, _amount, _minReturn, msg.sender);
365     }
366 
367     /**
368         @dev claims the caller's tokens, converts them to any other token in the bancor network
369         by following a predefined conversion path and transfers the result tokens back to the sender
370         note that allowance must be set beforehand
371 
372         @param _path        conversion path, see conversion path format above
373         @param _amount      amount to convert from (in the initial source token)
374         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
375 
376         @return tokens issued in return
377     */
378     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
379         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
380     }
381 
382     /**
383         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
384 
385         @param _token   token to check the allowance in
386         @param _spender approved address
387         @param _value   allowance amount
388     */
389     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
390         // check if allowance for the given amount already exists
391         if (_token.allowance(this, _spender) >= _value)
392             return;
393 
394         // if the allowance is nonzero, must reset it to 0 first
395         if (_token.allowance(this, _spender) != 0)
396             assert(_token.approve(_spender, 0));
397 
398         // approve the new allowance
399         assert(_token.approve(_spender, _value));
400     }
401 }