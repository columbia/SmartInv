1 // File: contracts/interfaces/IERC20Token.sol
2 
3 pragma solidity ^0.4.23;
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
22 // File: contracts/library/Utils.sol
23 
24 pragma solidity ^0.4.23;
25 
26 /*
27     Utilities & Common Modifiers
28 */
29 contract Utils {
30 
31     // verifies that an amount is greater than zero
32     modifier greaterThanZero(uint256 _amount) {
33         require(_amount > 0);
34         _;
35     }
36 
37     // validates an address - currently only checks that it isn't null
38     modifier validAddress(address _address) {
39         require(_address != 0x0);
40         _;
41     }
42 
43     // verifies that the address is different than this contract address
44     modifier notThis(address _address) {
45         require(_address != address(this));
46         _;
47     }
48 
49     // Overflow protected math functions
50 
51     /**
52         @dev returns the sum of _x and _y, asserts if the calculation overflows
53 
54         @param _x   value 1
55         @param _y   value 2
56 
57         @return sum
58     */
59     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
60         uint256 z = _x + _y;
61         assert(z >= _x);
62         return z;
63     }
64 
65     /**
66         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
67 
68         @param _x   minuend
69         @param _y   subtrahend
70 
71         @return difference
72     */
73     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
74         assert(_x >= _y);
75         return _x - _y;
76     }
77 
78     /**
79         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
80 
81         @param _x   factor 1
82         @param _y   factor 2
83 
84         @return product
85     */
86     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
87         uint256 z = _x * _y;
88         assert(_x == 0 || z / _x == _y);
89         return z;
90     }
91 }
92 
93 // File: contracts/library/SafeMath.sol
94 
95 pragma solidity ^0.4.23;
96 
97 library SafeMath {
98     function plus(uint256 _a, uint256 _b) internal pure returns (uint256) {
99         uint256 c = _a + _b;
100         assert(c >= _a);
101         return c;
102     }
103 
104     function plus(int256 _a, int256 _b) internal pure returns (int256) {
105         int256 c = _a + _b;
106         assert((_b >= 0 && c >= _a) || (_b < 0 && c < _a));
107         return c;
108     }
109 
110     function minus(uint256 _a, uint256 _b) internal pure returns (uint256) {
111         assert(_a >= _b);
112         return _a - _b;
113     }
114 
115     function minus(int256 _a, int256 _b) internal pure returns (int256) {
116         int256 c = _a - _b;
117         assert((_b >= 0 && c <= _a) || (_b < 0 && c > _a));
118         return c;
119     }
120 
121     function times(uint256 _a, uint256 _b) internal pure returns (uint256) {
122         if (_a == 0) {
123             return 0;
124         }
125         uint256 c = _a * _b;
126         assert(c / _a == _b);
127         return c;
128     }
129 
130     function times(int256 _a, int256 _b) internal pure returns (int256) {
131         if (_a == 0) {
132             return 0;
133         }
134         int256 c = _a * _b;
135         assert(c / _a == _b);
136         return c;
137     }
138 
139     function toInt256(uint256 _a) internal pure returns (int256) {
140         assert(_a <= 2 ** 255);
141         return int256(_a);
142     }
143 
144     function toUint256(int256 _a) internal pure returns (uint256) {
145         assert(_a >= 0);
146         return uint256(_a);
147     }
148 
149     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
150         return _a / _b;
151     }
152 
153     function div(int256 _a, int256 _b) internal pure returns (int256) {
154         return _a / _b;
155     }
156 }
157 
158 // File: contracts/library/ERC20Token.sol
159 
160 pragma solidity ^0.4.23;
161 
162 
163 
164 
165 /**
166     ERC20 Standard Token implementation
167 */
168 contract ERC20Token is IERC20Token, Utils {
169     using SafeMath for uint256;
170 
171 
172     string public standard = 'Token 0.1';
173     string public name = '';
174     string public symbol = '';
175     uint8 public decimals = 0;
176     uint256 public totalSupply = 0;
177     mapping (address => uint256) public balanceOf;
178     mapping (address => mapping (address => uint256)) public allowance;
179 
180     event Transfer(address indexed _from, address indexed _to, uint256 _value);
181     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
182 
183     /**
184         @dev constructor
185 
186         @param _name        token name
187         @param _symbol      token symbol
188         @param _decimals    decimal points, for display purposes
189     */
190     constructor(string _name, string _symbol, uint8 _decimals) public {
191         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
192 
193         name = _name;
194         symbol = _symbol;
195         decimals = _decimals;
196     }
197 
198     /**
199         @dev send coins
200         throws on any error rather then return a false flag to minimize user errors
201 
202         @param _to      target address
203         @param _value   transfer amount
204 
205         @return true if the transfer was successful, false if it wasn't
206     */
207     function transfer(address _to, uint256 _value)
208         public
209         validAddress(_to)
210         returns (bool success)
211     {
212         balanceOf[msg.sender] = balanceOf[msg.sender].minus(_value);
213         balanceOf[_to] = balanceOf[_to].plus(_value);
214         emit Transfer(msg.sender, _to, _value);
215         return true;
216     }
217 
218     /**
219         @dev an account/contract attempts to get the coins
220         throws on any error rather then return a false flag to minimize user errors
221 
222         @param _from    source address
223         @param _to      target address
224         @param _value   transfer amount
225 
226         @return true if the transfer was successful, false if it wasn't
227     */
228     function transferFrom(address _from, address _to, uint256 _value)
229         public
230         validAddress(_from)
231         validAddress(_to)
232         returns (bool success)
233     {
234         allowance[_from][msg.sender] = allowance[_from][msg.sender].minus(_value);
235         balanceOf[_from] = balanceOf[_from].minus(_value);
236         balanceOf[_to] = balanceOf[_to].plus(_value);
237         emit Transfer(_from, _to, _value);
238         return true;
239     }
240 
241     /**
242         @dev allow another account/contract to spend some tokens on your behalf
243         throws on any error rather then return a false flag to minimize user errors
244 
245         also, to minimize the risk of the approve/transferFrom attack vector
246         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
247         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
248 
249         @param _spender approved address
250         @param _value   allowance amount
251 
252         @return true if the approval was successful, false if it wasn't
253     */
254     function approve(address _spender, uint256 _value)
255         public
256         validAddress(_spender)
257         returns (bool success)
258     {
259         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
260         require(_value == 0 || allowance[msg.sender][_spender] == 0);
261 
262         allowance[msg.sender][_spender] = _value;
263         emit Approval(msg.sender, _spender, _value);
264         return true;
265     }
266 }
267 
268 // File: contracts/interfaces/IOwned.sol
269 
270 pragma solidity ^0.4.23;
271 
272 /*
273     Owned contract interface
274 */
275 contract IOwned {
276     // this function isn't abstract since the compiler emits automatically generated getter functions as external
277     function owner() public view returns (address) {}
278 
279     function transferOwnership(address _newOwner) public;
280     function acceptOwnership() public;
281     function setOwner(address _newOwner) public;
282 }
283 
284 // File: contracts/interfaces/ISmartToken.sol
285 
286 pragma solidity ^0.4.23;
287 
288 
289 
290 /*
291     Smart Token interface
292 */
293 contract ISmartToken is IOwned, IERC20Token {
294     function disableTransfers(bool _disable) public;
295     function issue(address _to, uint256 _amount) public;
296     function destroy(address _from, uint256 _amount) public;
297 }
298 
299 // File: contracts/library/Owned.sol
300 
301 pragma solidity ^0.4.23;
302 
303 contract Owned {
304     address public owner;
305     address public newOwner;
306 
307     event OwnerUpdate(address _prevOwner, address _newOwner);
308 
309     constructor () public { owner = msg.sender; }
310 
311     modifier ownerOnly {
312         assert(msg.sender == owner);
313         _;
314     }
315 
316     function setOwner(address _newOwner) public ownerOnly {
317         require(_newOwner != owner && _newOwner != address(0));
318         emit OwnerUpdate(owner, _newOwner);
319         owner = _newOwner;
320         newOwner = address(0);
321     }
322 
323     function transferOwnership(address _newOwner) public ownerOnly {
324         require(_newOwner != owner);
325         newOwner = _newOwner;
326     }
327 
328     function acceptOwnership() public {
329         require(msg.sender == newOwner);
330         emit OwnerUpdate(owner, newOwner);
331         owner = newOwner;
332         newOwner = 0x0;
333     }
334 }
335 
336 // File: contracts/interfaces/ITokenHolder.sol
337 
338 pragma solidity ^0.4.23;
339 
340 
341 
342 /*
343     Token Holder interface
344 */
345 contract ITokenHolder is IOwned {
346     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
347 }
348 
349 // File: contracts/library/TokenHolder.sol
350 
351 pragma solidity ^0.4.23;
352 
353 
354 
355 
356 
357 /*
358     We consider every contract to be a 'token holder' since it's currently not possible
359     for a contract to deny receiving tokens.
360 
361     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
362     the owner to send tokens that were sent to the contract by mistake back to their sender.
363 */
364 contract TokenHolder is ITokenHolder, Owned, Utils {
365     /**
366         @dev constructor
367     */
368     constructor() public {
369     }
370 
371     /**
372         @dev withdraws tokens held by the contract and sends them to an account
373         can only be called by the owner
374 
375         @param _token   ERC20 token contract address
376         @param _to      account to receive the new amount
377         @param _amount  amount to withdraw
378     */
379     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
380         public
381         ownerOnly
382         validAddress(_token)
383         validAddress(_to)
384         notThis(_to)
385     {
386         assert(_token.transfer(_to, _amount));
387     }
388 }
389 
390 // File: contracts/interfaces/IContractRegistry.sol
391 
392 pragma solidity ^0.4.23;
393 
394 /*
395     Contract Registry interface
396 */
397 contract IContractRegistry {
398     function addressOf(bytes32 _contractName) public view returns (address);
399 }
400 
401 // File: contracts/interfaces/IPegSettings.sol
402 
403 pragma solidity ^0.4.23;
404 
405 
406 contract IPegSettings {
407 
408     function authorized(address _address) public view returns (bool) { _address; }
409     
410     function authorize(address _address, bool _auth) public;
411     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public;
412 
413 }
414 
415 // File: contracts/ContractIds.sol
416 
417 pragma solidity ^0.4.23;
418 
419 contract ContractIds {
420     bytes32 public constant STABLE_TOKEN = "StableToken";
421     bytes32 public constant COLLATERAL_TOKEN = "CollateralToken";
422 
423     bytes32 public constant PEGUSD_TOKEN = "PEGUSD";
424 
425     bytes32 public constant VAULT_A = "VaultA";
426     bytes32 public constant VAULT_B = "VaultB";
427 
428     bytes32 public constant PEG_LOGIC = "PegLogic";
429     bytes32 public constant PEG_LOGIC_ACTIONS = "LogicActions";
430     bytes32 public constant AUCTION_ACTIONS = "AuctionActions";
431 
432     bytes32 public constant PEG_SETTINGS = "PegSettings";
433     bytes32 public constant ORACLE = "Oracle";
434     bytes32 public constant FEE_RECIPIENT = "StabilityFeeRecipient";
435 }
436 
437 // File: contracts/library/SmartToken.sol
438 
439 pragma solidity ^0.4.23;
440 
441 
442 
443 
444 
445 
446 
447 
448 /*
449     Smart Token v0.3
450 
451     'Owned' is specified here for readability reasons
452 */
453 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder, ContractIds {
454     string public version = '0.3';
455     IContractRegistry public registry;
456 
457     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
458 
459     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
460     event NewSmartToken(address _token);
461     // triggered when the total supply is increased
462     event Issuance(uint256 _amount);
463     // triggered when the total supply is decreased
464     event Destruction(uint256 _amount);
465 
466     /**
467         @dev constructor
468 
469         @param _name       token name
470         @param _symbol     token short symbol, minimum 1 character
471         @param _decimals   for display purposes only
472     */
473     constructor(string _name, string _symbol, uint8 _decimals, IContractRegistry _registry)
474         public
475         ERC20Token(_name, _symbol, _decimals)
476     {
477         registry = _registry;
478         emit NewSmartToken(address(this));
479     }
480 
481     function isAuth() internal returns(bool) {
482         IPegSettings pegSettings = IPegSettings(registry.addressOf(ContractIds.PEG_SETTINGS));
483         return (pegSettings.authorized(msg.sender) || msg.sender == owner);
484     }
485 
486     modifier authOnly() {
487         require(isAuth(), "Forbidden");
488         _;
489     }
490 
491     // allows execution only when transfers aren't disabled
492     modifier transfersAllowed {
493         assert(transfersEnabled);
494         _;
495     }
496 
497     /**
498         @dev disables/enables transfers
499         can only be called by the contract owner
500 
501         @param _disable    true to disable transfers, false to enable them
502     */
503     function disableTransfers(bool _disable) public ownerOnly {
504         transfersEnabled = !_disable;
505     }
506 
507     /**
508         @dev increases the token supply and sends the new tokens to an account
509         can only be called by the contract owner
510 
511         @param _to         account to receive the new amount
512         @param _amount     amount to increase the supply by
513     */
514     function issue(address _to, uint256 _amount)
515         public
516         authOnly
517         validAddress(_to)
518         notThis(_to)
519     {
520         totalSupply = safeAdd(totalSupply, _amount);
521         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
522 
523         emit Issuance(_amount);
524         emit Transfer(this, _to, _amount);
525     }
526 
527     /**
528         @dev removes tokens from an account and decreases the token supply
529         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
530 
531         @param _from       account to remove the amount from
532         @param _amount     amount to decrease the supply by
533     */
534     function destroy(address _from, uint256 _amount) public {
535         require(msg.sender == _from || isAuth()); // validate input
536 
537         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
538         totalSupply = safeSub(totalSupply, _amount);
539 
540         emit Transfer(_from, this, _amount);
541         emit Destruction(_amount);
542     }
543 
544     // ERC20 standard method overrides with some extra functionality
545 
546     /**
547         @dev send coins
548         throws on any error rather then return a false flag to minimize user errors
549         in addition to the standard checks, the function throws if transfers are disabled
550 
551         @param _to      target address
552         @param _value   transfer amount
553 
554         @return true if the transfer was successful, false if it wasn't
555     */
556     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
557         assert(super.transfer(_to, _value));
558         return true;
559     }
560 
561     /**
562         @dev an account/contract attempts to get the coins
563         throws on any error rather then return a false flag to minimize user errors
564         in addition to the standard checks, the function throws if transfers are disabled
565 
566         @param _from    source address
567         @param _to      target address
568         @param _value   transfer amount
569 
570         @return true if the transfer was successful, false if it wasn't
571     */
572     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
573         assert(super.transferFrom(_from, _to, _value));
574         return true;
575     }
576 
577     function setSymbol(string _symbol) public ownerOnly {
578         symbol = _symbol;
579     }
580 
581     function setName(string _name) public ownerOnly {
582         name = _name;
583     }
584 }