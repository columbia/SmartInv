1 pragma solidity 0.4.26;
2 
3 // File: contracts/token/interfaces/IERC20Token.sol
4 
5 /*
6     ERC20 Standard Token interface
7 */
8 contract IERC20Token {
9     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
10     function name() public view returns (string) {this;}
11     function symbol() public view returns (string) {this;}
12     function decimals() public view returns (uint8) {this;}
13     function totalSupply() public view returns (uint256) {this;}
14     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
15     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
16 
17     function transfer(address _to, uint256 _value) public returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 }
21 
22 // File: contracts/utility/Utils.sol
23 
24 /**
25   * @dev Utilities & Common Modifiers
26 */
27 contract Utils {
28     /**
29       * constructor
30     */
31     constructor() public {
32     }
33 
34     // verifies that an amount is greater than zero
35     modifier greaterThanZero(uint256 _amount) {
36         require(_amount > 0);
37         _;
38     }
39 
40     // validates an address - currently only checks that it isn't null
41     modifier validAddress(address _address) {
42         require(_address != address(0));
43         _;
44     }
45 
46     // verifies that the address is different than this contract address
47     modifier notThis(address _address) {
48         require(_address != address(this));
49         _;
50     }
51 
52 }
53 
54 // File: contracts/utility/SafeMath.sol
55 
56 /**
57   * @dev Library for basic math operations with overflow/underflow protection
58 */
59 library SafeMath {
60     /**
61       * @dev returns the sum of _x and _y, reverts if the calculation overflows
62       * 
63       * @param _x   value 1
64       * @param _y   value 2
65       * 
66       * @return sum
67     */
68     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
69         uint256 z = _x + _y;
70         require(z >= _x);
71         return z;
72     }
73 
74     /**
75       * @dev returns the difference of _x minus _y, reverts if the calculation underflows
76       * 
77       * @param _x   minuend
78       * @param _y   subtrahend
79       * 
80       * @return difference
81     */
82     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
83         require(_x >= _y);
84         return _x - _y;
85     }
86 
87     /**
88       * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
89       * 
90       * @param _x   factor 1
91       * @param _y   factor 2
92       * 
93       * @return product
94     */
95     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
96         // gas optimization
97         if (_x == 0)
98             return 0;
99 
100         uint256 z = _x * _y;
101         require(z / _x == _y);
102         return z;
103     }
104 
105       /**
106         * ev Integer division of two numbers truncating the quotient, reverts on division by zero.
107         * 
108         * aram _x   dividend
109         * aram _y   divisor
110         * 
111         * eturn quotient
112     */
113     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
114         require(_y > 0);
115         uint256 c = _x / _y;
116 
117         return c;
118     }
119 }
120 
121 // File: contracts/token/ERC20Token.sol
122 
123 /**
124   * @dev ERC20 Standard Token implementation
125 */
126 contract ERC20Token is IERC20Token, Utils {
127     using SafeMath for uint256;
128 
129 
130     string public name;
131     string public symbol;
132     uint8 public decimals;
133     uint256 public totalSupply;
134     mapping (address => uint256) public balanceOf;
135     mapping (address => mapping (address => uint256)) public allowance;
136 
137     /**
138       * @dev triggered when tokens are transferred between wallets
139       * 
140       * @param _from    source address
141       * @param _to      target address
142       * @param _value   transfer amount
143     */
144     event Transfer(address indexed _from, address indexed _to, uint256 _value);
145 
146     /**
147       * @dev triggered when a wallet allows another wallet to transfer tokens from on its behalf
148       * 
149       * @param _owner   wallet that approves the allowance
150       * @param _spender wallet that receives the allowance
151       * @param _value   allowance amount
152     */
153     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
154 
155     /**
156       * @dev initializes a new ERC20Token instance
157       * 
158       * @param _name        token name
159       * @param _symbol      token symbol
160       * @param _decimals    decimal points, for display purposes
161       * @param _totalSupply total supply of token units
162     */
163     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
164         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
165 
166         name = _name;
167         symbol = _symbol;
168         decimals = _decimals;
169         totalSupply = _totalSupply;
170         balanceOf[msg.sender] = _totalSupply;
171     }
172 
173     /**
174       * @dev send coins
175       * throws on any error rather then return a false flag to minimize user errors
176       * 
177       * @param _to      target address
178       * @param _value   transfer amount
179       * 
180       * @return true if the transfer was successful, false if it wasn't
181     */
182     function transfer(address _to, uint256 _value)
183         public
184         validAddress(_to)
185         returns (bool success)
186     {
187         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
188         balanceOf[_to] = balanceOf[_to].add(_value);
189         emit Transfer(msg.sender, _to, _value);
190         return true;
191     }
192 
193     /**
194       * @dev an account/contract attempts to get the coins
195       * throws on any error rather then return a false flag to minimize user errors
196       * 
197       * @param _from    source address
198       * @param _to      target address
199       * @param _value   transfer amount
200       * 
201       * @return true if the transfer was successful, false if it wasn't
202     */
203     function transferFrom(address _from, address _to, uint256 _value)
204         public
205         validAddress(_from)
206         validAddress(_to)
207         returns (bool success)
208     {
209         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
210         balanceOf[_from] = balanceOf[_from].sub(_value);
211         balanceOf[_to] = balanceOf[_to].add(_value);
212         emit Transfer(_from, _to, _value);
213         return true;
214     }
215 
216     /**
217       * @dev allow another account/contract to spend some tokens on your behalf
218       * throws on any error rather then return a false flag to minimize user errors
219       * 
220       * also, to minimize the risk of the approve/transferFrom attack vector
221       * (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
222       * in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
223       * 
224       * @param _spender approved address
225       * @param _value   allowance amount
226       * 
227       * @return true if the approval was successful, false if it wasn't
228     */
229     function approve(address _spender, uint256 _value)
230         public
231         validAddress(_spender)
232         returns (bool success)
233     {
234         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
235         require(_value == 0 || allowance[msg.sender][_spender] == 0);
236 
237         allowance[msg.sender][_spender] = _value;
238         emit Approval(msg.sender, _spender, _value);
239         return true;
240     }
241 }
242 
243 // File: contracts/utility/interfaces/IOwned.sol
244 
245 /*
246     Owned contract interface
247 */
248 contract IOwned {
249     // this function isn't abstract since the compiler emits automatically generated getter functions as external
250     function owner() public view returns (address) {this;}
251 
252     function transferOwnership(address _newOwner) public;
253     function acceptOwnership() public;
254 }
255 
256 // File: contracts/token/interfaces/ISmartToken.sol
257 
258 /*
259     Smart Token interface
260 */
261 contract ISmartToken is IOwned, IERC20Token {
262     function disableTransfers(bool _disable) public;
263     function issue(address _to, uint256 _amount) public;
264     function destroy(address _from, uint256 _amount) public;
265 }
266 
267 // File: contracts/utility/Owned.sol
268 
269 /**
270   * @dev Provides support and utilities for contract ownership
271 */
272 contract Owned is IOwned {
273     address public owner;
274     address public newOwner;
275 
276     /**
277       * @dev triggered when the owner is updated
278       * 
279       * @param _prevOwner previous owner
280       * @param _newOwner  new owner
281     */
282     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
283 
284     /**
285       * @dev initializes a new Owned instance
286     */
287     constructor() public {
288         owner = msg.sender;
289     }
290 
291     // allows execution by the owner only
292     modifier ownerOnly {
293         require(msg.sender == owner);
294         _;
295     }
296 
297     /**
298       * @dev allows transferring the contract ownership
299       * the new owner still needs to accept the transfer
300       * can only be called by the contract owner
301       * 
302       * @param _newOwner    new contract owner
303     */
304     function transferOwnership(address _newOwner) public ownerOnly {
305         require(_newOwner != owner);
306         newOwner = _newOwner;
307     }
308 
309     /**
310       * @dev used by a new owner to accept an ownership transfer
311     */
312     function acceptOwnership() public {
313         require(msg.sender == newOwner);
314         emit OwnerUpdate(owner, newOwner);
315         owner = newOwner;
316         newOwner = address(0);
317     }
318 }
319 
320 // File: contracts/utility/interfaces/ITokenHolder.sol
321 
322 /*
323     Token Holder interface
324 */
325 contract ITokenHolder is IOwned {
326     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
327 }
328 
329 // File: contracts/token/interfaces/INonStandardERC20.sol
330 
331 /*
332     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
333 */
334 contract INonStandardERC20 {
335     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
336     function name() public view returns (string) {this;}
337     function symbol() public view returns (string) {this;}
338     function decimals() public view returns (uint8) {this;}
339     function totalSupply() public view returns (uint256) {this;}
340     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
341     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
342 
343     function transfer(address _to, uint256 _value) public;
344     function transferFrom(address _from, address _to, uint256 _value) public;
345     function approve(address _spender, uint256 _value) public;
346 }
347 
348 // File: contracts/utility/TokenHolder.sol
349 
350 /**
351   * @dev We consider every contract to be a 'token holder' since it's currently not possible
352   * for a contract to deny receiving tokens.
353   * 
354   * The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
355   * the owner to send tokens that were sent to the contract by mistake back to their sender.
356   * 
357   * Note that we use the non standard ERC-20 interface which has no return value for transfer
358   * in order to support both non standard as well as standard token contracts.
359   * see https://github.com/ethereum/solidity/issues/4116
360 */
361 contract TokenHolder is ITokenHolder, Owned, Utils {
362     /**
363       * @dev initializes a new TokenHolder instance
364     */
365     constructor() public {
366     }
367 
368     /**
369       * @dev withdraws tokens held by the contract and sends them to an account
370       * can only be called by the owner
371       * 
372       * @param _token   ERC20 token contract address
373       * @param _to      account to receive the new amount
374       * @param _amount  amount to withdraw
375     */
376     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
377         public
378         ownerOnly
379         validAddress(_token)
380         validAddress(_to)
381         notThis(_to)
382     {
383         INonStandardERC20(_token).transfer(_to, _amount);
384     }
385 }
386 
387 // File: contracts/token/SmartToken.sol
388 
389 /**
390   * @dev Smart Token
391   * 
392   * 'Owned' is specified here for readability reasons
393 */
394 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
395     using SafeMath for uint256;
396 
397 
398     string public version = '0.3';
399 
400     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
401 
402     /**
403       * @dev triggered when a smart token is deployed
404       * the _token address is defined for forward compatibility, in case the event is trigger by a factory
405       * 
406       * @param _token  new smart token address
407     */
408     event NewSmartToken(address _token);
409 
410     /**
411       * @dev triggered when the total supply is increased
412       * 
413       * @param _amount  amount that gets added to the supply
414     */
415     event Issuance(uint256 _amount);
416 
417     /**
418       * @dev triggered when the total supply is decreased
419       * 
420       * @param _amount  amount that gets removed from the supply
421     */
422     event Destruction(uint256 _amount);
423 
424     /**
425       * @dev initializes a new SmartToken instance
426       * 
427       * @param _name       token name
428       * @param _symbol     token short symbol, minimum 1 character
429       * @param _decimals   for display purposes only
430     */
431     constructor(string _name, string _symbol, uint8 _decimals)
432         public
433         ERC20Token(_name, _symbol, _decimals, 0)
434     {
435         emit NewSmartToken(address(this));
436     }
437 
438     // allows execution only when transfers aren't disabled
439     modifier transfersAllowed {
440         assert(transfersEnabled);
441         _;
442     }
443 
444     /**
445       * @dev disables/enables transfers
446       * can only be called by the contract owner
447       * 
448       * @param _disable    true to disable transfers, false to enable them
449     */
450     function disableTransfers(bool _disable) public ownerOnly {
451         transfersEnabled = !_disable;
452     }
453 
454     /**
455       * @dev increases the token supply and sends the new tokens to an account
456       * can only be called by the contract owner
457       * 
458       * @param _to         account to receive the new amount
459       * @param _amount     amount to increase the supply by
460     */
461     function issue(address _to, uint256 _amount)
462         public
463         ownerOnly
464         validAddress(_to)
465         notThis(_to)
466     {
467         totalSupply = totalSupply.add(_amount);
468         balanceOf[_to] = balanceOf[_to].add(_amount);
469 
470         emit Issuance(_amount);
471         emit Transfer(this, _to, _amount);
472     }
473 
474     /**
475       * @dev removes tokens from an account and decreases the token supply
476       * can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
477       * 
478       * @param _from       account to remove the amount from
479       * @param _amount     amount to decrease the supply by
480     */
481     function destroy(address _from, uint256 _amount) public {
482         require(msg.sender == _from || msg.sender == owner); // validate input
483 
484         balanceOf[_from] = balanceOf[_from].sub(_amount);
485         totalSupply = totalSupply.sub(_amount);
486 
487         emit Transfer(_from, this, _amount);
488         emit Destruction(_amount);
489     }
490 
491     // ERC20 standard method overrides with some extra functionality
492 
493     /**
494       * @dev send coins
495       * throws on any error rather then return a false flag to minimize user errors
496       * in addition to the standard checks, the function throws if transfers are disabled
497       * 
498       * @param _to      target address
499       * @param _value   transfer amount
500       * 
501       * @return true if the transfer was successful, false if it wasn't
502     */
503     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
504         assert(super.transfer(_to, _value));
505         return true;
506     }
507 
508     /**
509       * @dev an account/contract attempts to get the coins
510       * throws on any error rather then return a false flag to minimize user errors
511       * in addition to the standard checks, the function throws if transfers are disabled
512       * 
513       * @param _from    source address
514       * @param _to      target address
515       * @param _value   transfer amount
516       * 
517       * @return true if the transfer was successful, false if it wasn't
518     */
519     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
520         assert(super.transferFrom(_from, _to, _value));
521         return true;
522     }
523 }
