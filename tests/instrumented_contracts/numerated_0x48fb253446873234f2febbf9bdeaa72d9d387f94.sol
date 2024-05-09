1 
2 // File: solidity/contracts/token/interfaces/IERC20Token.sol
3 
4 // SPDX-License-Identifier: SEE LICENSE IN LICENSE
5 pragma solidity 0.6.12;
6 
7 /*
8     ERC20 Standard Token interface
9 */
10 interface IERC20Token {
11     function name() external view returns (string memory);
12     function symbol() external view returns (string memory);
13     function decimals() external view returns (uint8);
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address _owner) external view returns (uint256);
16     function allowance(address _owner, address _spender) external view returns (uint256);
17 
18     function transfer(address _to, uint256 _value) external returns (bool);
19     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
20     function approve(address _spender, uint256 _value) external returns (bool);
21 }
22 
23 // File: solidity/contracts/utility/Utils.sol
24 
25 
26 pragma solidity 0.6.12;
27 
28 /**
29   * @dev Utilities & Common Modifiers
30 */
31 contract Utils {
32     // verifies that a value is greater than zero
33     modifier greaterThanZero(uint256 _value) {
34         _greaterThanZero(_value);
35         _;
36     }
37 
38     // error message binary size optimization
39     function _greaterThanZero(uint256 _value) internal pure {
40         require(_value > 0, "ERR_ZERO_VALUE");
41     }
42 
43     // validates an address - currently only checks that it isn't null
44     modifier validAddress(address _address) {
45         _validAddress(_address);
46         _;
47     }
48 
49     // error message binary size optimization
50     function _validAddress(address _address) internal pure {
51         require(_address != address(0), "ERR_INVALID_ADDRESS");
52     }
53 
54     // verifies that the address is different than this contract address
55     modifier notThis(address _address) {
56         _notThis(_address);
57         _;
58     }
59 
60     // error message binary size optimization
61     function _notThis(address _address) internal view {
62         require(_address != address(this), "ERR_ADDRESS_IS_SELF");
63     }
64 }
65 
66 // File: solidity/contracts/utility/SafeMath.sol
67 
68 
69 pragma solidity 0.6.12;
70 
71 /**
72   * @dev Library for basic math operations with overflow/underflow protection
73 */
74 library SafeMath {
75     /**
76       * @dev returns the sum of _x and _y, reverts if the calculation overflows
77       *
78       * @param _x   value 1
79       * @param _y   value 2
80       *
81       * @return sum
82     */
83     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
84         uint256 z = _x + _y;
85         require(z >= _x, "ERR_OVERFLOW");
86         return z;
87     }
88 
89     /**
90       * @dev returns the difference of _x minus _y, reverts if the calculation underflows
91       *
92       * @param _x   minuend
93       * @param _y   subtrahend
94       *
95       * @return difference
96     */
97     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
98         require(_x >= _y, "ERR_UNDERFLOW");
99         return _x - _y;
100     }
101 
102     /**
103       * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
104       *
105       * @param _x   factor 1
106       * @param _y   factor 2
107       *
108       * @return product
109     */
110     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
111         // gas optimization
112         if (_x == 0)
113             return 0;
114 
115         uint256 z = _x * _y;
116         require(z / _x == _y, "ERR_OVERFLOW");
117         return z;
118     }
119 
120     /**
121       * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
122       *
123       * @param _x   dividend
124       * @param _y   divisor
125       *
126       * @return quotient
127     */
128     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
129         require(_y > 0, "ERR_DIVIDE_BY_ZERO");
130         uint256 c = _x / _y;
131         return c;
132     }
133 }
134 
135 // File: solidity/contracts/token/ERC20Token.sol
136 
137 
138 pragma solidity 0.6.12;
139 
140 
141 
142 
143 /**
144   * @dev ERC20 Standard Token implementation
145 */
146 contract ERC20Token is IERC20Token, Utils {
147     using SafeMath for uint256;
148 
149 
150     string public override name;
151     string public override symbol;
152     uint8 public override decimals;
153     uint256 public override totalSupply;
154     mapping (address => uint256) public override balanceOf;
155     mapping (address => mapping (address => uint256)) public override allowance;
156 
157     /**
158       * @dev triggered when tokens are transferred between wallets
159       *
160       * @param _from    source address
161       * @param _to      target address
162       * @param _value   transfer amount
163     */
164     event Transfer(address indexed _from, address indexed _to, uint256 _value);
165 
166     /**
167       * @dev triggered when a wallet allows another wallet to transfer tokens from on its behalf
168       *
169       * @param _owner   wallet that approves the allowance
170       * @param _spender wallet that receives the allowance
171       * @param _value   allowance amount
172     */
173     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
174 
175     /**
176       * @dev initializes a new ERC20Token instance
177       *
178       * @param _name        token name
179       * @param _symbol      token symbol
180       * @param _decimals    decimal points, for display purposes
181       * @param _totalSupply total supply of token units
182     */
183     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public {
184         // validate input
185         require(bytes(_name).length > 0, "ERR_INVALID_NAME");
186         require(bytes(_symbol).length > 0, "ERR_INVALID_SYMBOL");
187 
188         name = _name;
189         symbol = _symbol;
190         decimals = _decimals;
191         totalSupply = _totalSupply;
192         balanceOf[msg.sender] = _totalSupply;
193     }
194 
195     /**
196       * @dev transfers tokens to a given address
197       * throws on any error rather then return a false flag to minimize user errors
198       *
199       * @param _to      target address
200       * @param _value   transfer amount
201       *
202       * @return true if the transfer was successful, false if it wasn't
203     */
204     function transfer(address _to, uint256 _value)
205         public
206         virtual
207         override
208         validAddress(_to)
209         returns (bool)
210     {
211         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
212         balanceOf[_to] = balanceOf[_to].add(_value);
213         emit Transfer(msg.sender, _to, _value);
214         return true;
215     }
216 
217     /**
218       * @dev transfers tokens to a given address on behalf of another address
219       * throws on any error rather then return a false flag to minimize user errors
220       *
221       * @param _from    source address
222       * @param _to      target address
223       * @param _value   transfer amount
224       *
225       * @return true if the transfer was successful, false if it wasn't
226     */
227     function transferFrom(address _from, address _to, uint256 _value)
228         public
229         virtual
230         override
231         validAddress(_from)
232         validAddress(_to)
233         returns (bool)
234     {
235         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
236         balanceOf[_from] = balanceOf[_from].sub(_value);
237         balanceOf[_to] = balanceOf[_to].add(_value);
238         emit Transfer(_from, _to, _value);
239         return true;
240     }
241 
242     /**
243       * @dev allows another account/contract to transfers tokens on behalf of the caller
244       * throws on any error rather then return a false flag to minimize user errors
245       *
246       * @param _spender approved address
247       * @param _value   allowance amount
248       *
249       * @return true if the approval was successful, false if it wasn't
250     */
251     function approve(address _spender, uint256 _value)
252         public
253         virtual
254         override
255         validAddress(_spender)
256         returns (bool)
257     {
258         allowance[msg.sender][_spender] = _value;
259         emit Approval(msg.sender, _spender, _value);
260         return true;
261     }
262 }
263 
264 // File: solidity/contracts/utility/interfaces/IOwned.sol
265 
266 
267 pragma solidity 0.6.12;
268 
269 /*
270     Owned contract interface
271 */
272 interface IOwned {
273     // this function isn't since the compiler emits automatically generated getter functions as external
274     function owner() external view returns (address);
275 
276     function transferOwnership(address _newOwner) external;
277     function acceptOwnership() external;
278 }
279 
280 // File: solidity/contracts/converter/interfaces/IConverterAnchor.sol
281 
282 
283 pragma solidity 0.6.12;
284 
285 
286 /*
287     Converter Anchor interface
288 */
289 interface IConverterAnchor is IOwned {
290 }
291 
292 // File: solidity/contracts/token/interfaces/IDSToken.sol
293 
294 
295 pragma solidity 0.6.12;
296 
297 
298 
299 
300 /*
301     DSToken interface
302 */
303 interface IDSToken is IConverterAnchor, IERC20Token {
304     function issue(address _to, uint256 _amount) external;
305     function destroy(address _from, uint256 _amount) external;
306 }
307 
308 // File: solidity/contracts/utility/Owned.sol
309 
310 
311 pragma solidity 0.6.12;
312 
313 
314 /**
315   * @dev Provides support and utilities for contract ownership
316 */
317 contract Owned is IOwned {
318     address public override owner;
319     address public newOwner;
320 
321     /**
322       * @dev triggered when the owner is updated
323       *
324       * @param _prevOwner previous owner
325       * @param _newOwner  new owner
326     */
327     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
328 
329     /**
330       * @dev initializes a new Owned instance
331     */
332     constructor() public {
333         owner = msg.sender;
334     }
335 
336     // allows execution by the owner only
337     modifier ownerOnly {
338         _ownerOnly();
339         _;
340     }
341 
342     // error message binary size optimization
343     function _ownerOnly() internal view {
344         require(msg.sender == owner, "ERR_ACCESS_DENIED");
345     }
346 
347     /**
348       * @dev allows transferring the contract ownership
349       * the new owner still needs to accept the transfer
350       * can only be called by the contract owner
351       *
352       * @param _newOwner    new contract owner
353     */
354     function transferOwnership(address _newOwner) public override ownerOnly {
355         require(_newOwner != owner, "ERR_SAME_OWNER");
356         newOwner = _newOwner;
357     }
358 
359     /**
360       * @dev used by a new owner to accept an ownership transfer
361     */
362     function acceptOwnership() override public {
363         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
364         emit OwnerUpdate(owner, newOwner);
365         owner = newOwner;
366         newOwner = address(0);
367     }
368 }
369 
370 // File: solidity/contracts/token/DSToken.sol
371 
372 
373 pragma solidity 0.6.12;
374 
375 
376 
377 
378 /**
379   * @dev DSToken represents a token with dynamic supply.
380   * The owner of the token can mint/burn tokens to/from any account.
381   *
382 */
383 contract DSToken is IDSToken, ERC20Token, Owned {
384     using SafeMath for uint256;
385 
386     /**
387       * @dev triggered when the total supply is increased
388       *
389       * @param _amount  amount that gets added to the supply
390     */
391     event Issuance(uint256 _amount);
392 
393     /**
394       * @dev triggered when the total supply is decreased
395       *
396       * @param _amount  amount that gets removed from the supply
397     */
398     event Destruction(uint256 _amount);
399 
400     /**
401       * @dev initializes a new DSToken instance
402       *
403       * @param _name       token name
404       * @param _symbol     token short symbol, minimum 1 character
405       * @param _decimals   for display purposes only
406     */
407     constructor(string memory _name, string memory _symbol, uint8 _decimals)
408         public
409         ERC20Token(_name, _symbol, _decimals, 0)
410     {
411     }
412 
413     /**
414       * @dev increases the token supply and sends the new tokens to the given account
415       * can only be called by the contract owner
416       *
417       * @param _to      account to receive the new amount
418       * @param _amount  amount to increase the supply by
419     */
420     function issue(address _to, uint256 _amount)
421         public
422         override
423         ownerOnly
424         validAddress(_to)
425         notThis(_to)
426     {
427         totalSupply = totalSupply.add(_amount);
428         balanceOf[_to] = balanceOf[_to].add(_amount);
429 
430         emit Issuance(_amount);
431         emit Transfer(address(0), _to, _amount);
432     }
433 
434     /**
435       * @dev removes tokens from the given account and decreases the token supply
436       * can only be called by the contract owner
437       *
438       * @param _from    account to remove the amount from
439       * @param _amount  amount to decrease the supply by
440     */
441     function destroy(address _from, uint256 _amount) public override ownerOnly {
442         balanceOf[_from] = balanceOf[_from].sub(_amount);
443         totalSupply = totalSupply.sub(_amount);
444 
445         emit Transfer(_from, address(0), _amount);
446         emit Destruction(_amount);
447     }
448 
449     // ERC20 standard method overrides with some extra functionality
450 
451     /**
452       * @dev send coins
453       * throws on any error rather then return a false flag to minimize user errors
454       * in addition to the standard checks, the function throws if transfers are disabled
455       *
456       * @param _to      target address
457       * @param _value   transfer amount
458       *
459       * @return true if the transfer was successful, false if it wasn't
460     */
461     function transfer(address _to, uint256 _value)
462         public
463         override(IERC20Token, ERC20Token)
464         returns (bool)
465     {
466         return super.transfer(_to, _value);
467     }
468 
469     /**
470       * @dev an account/contract attempts to get the coins
471       * throws on any error rather then return a false flag to minimize user errors
472       * in addition to the standard checks, the function throws if transfers are disabled
473       *
474       * @param _from    source address
475       * @param _to      target address
476       * @param _value   transfer amount
477       *
478       * @return true if the transfer was successful, false if it wasn't
479     */
480     function transferFrom(address _from, address _to, uint256 _value)
481         public
482         override(IERC20Token, ERC20Token)
483         returns (bool) 
484     {
485         return super.transferFrom(_from, _to, _value);
486     }
487 }
