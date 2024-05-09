1 // File: contracts\libraries\SafeMath.sol
2 
3 pragma solidity =0.5.16;
4 
5 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
6 // Subject to the MIT license.
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
39      *
40      * Counterpart to Solidity's `+` operator.
41      *
42      * Requirements:
43      * - Addition cannot overflow.
44      */
45     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, errorMessage);
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      * - Subtraction cannot underflow.
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction underflow");
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      * - Subtraction cannot underflow.
71      */
72     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
103      *
104      * Counterpart to Solidity's `*` operator.
105      *
106      * Requirements:
107      * - Multiplication cannot overflow.
108      */
109     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
111         // benefit is lost if 'b' is also tested.
112         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
113         if (a == 0) {
114             return 0;
115         }
116 
117         uint256 c = a * b;
118         require(c / a == b, errorMessage);
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers.
125      * Reverts on division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers.
140      * Reverts with custom message on division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 // File: contracts\ImpermaxERC20.sol
191 
192 pragma solidity =0.5.16;
193 
194 
195 // This contract is basically UniswapV2ERC20 with small modifications
196 // src: https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol
197 
198 contract ImpermaxERC20 {
199 	using SafeMath for uint;
200 	
201 	string public name;
202 	string public symbol;
203 	uint8 public decimals = 18;
204 	uint public totalSupply;
205 	mapping(address => uint) public balanceOf;
206 	mapping(address => mapping(address => uint)) public allowance;
207 	
208 	bytes32 public DOMAIN_SEPARATOR;
209 	mapping(address => uint) public nonces;
210 	
211 	event Transfer(address indexed from, address indexed to, uint value);
212 	event Approval(address indexed owner, address indexed spender, uint value);
213 
214 	constructor() public {}	
215 	
216 	function _setName(string memory _name, string memory _symbol) internal {
217 		name = _name;
218 		symbol = _symbol;
219 		uint chainId;
220 		assembly {
221 			chainId := chainid
222 		}
223 		DOMAIN_SEPARATOR = keccak256(
224 			abi.encode(
225 				keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
226 				keccak256(bytes(_name)),
227 				keccak256(bytes("1")),
228 				chainId,
229 				address(this)
230 			)
231 		);
232 	}
233 
234 	function _mint(address to, uint value) internal {
235 		totalSupply = totalSupply.add(value);
236 		balanceOf[to] = balanceOf[to].add(value);
237 		emit Transfer(address(0), to, value);
238 	}
239 
240 	function _burn(address from, uint value) internal {
241 		balanceOf[from] = balanceOf[from].sub(value);
242 		totalSupply = totalSupply.sub(value);
243 		emit Transfer(from, address(0), value);
244 	}
245 
246 	function _approve(address owner, address spender, uint value) private {
247 		allowance[owner][spender] = value;
248 		emit Approval(owner, spender, value);
249 	}
250 
251 	function _transfer(address from, address to, uint value) internal {
252 		balanceOf[from] = balanceOf[from].sub(value, "Impermax: TRANSFER_TOO_HIGH");
253 		balanceOf[to] = balanceOf[to].add(value);
254 		emit Transfer(from, to, value);
255 	}
256 
257 	function approve(address spender, uint value) external returns (bool) {
258 		_approve(msg.sender, spender, value);
259 		return true;
260 	}
261 
262 	function transfer(address to, uint value) external returns (bool) {
263 		_transfer(msg.sender, to, value);
264 		return true;
265 	}
266 
267 	function transferFrom(address from, address to, uint value) external returns (bool) {
268 		if (allowance[from][msg.sender] != uint(-1)) {
269 			allowance[from][msg.sender] = allowance[from][msg.sender].sub(value, "Impermax: TRANSFER_NOT_ALLOWED");
270 		}
271 		_transfer(from, to, value);
272 		return true;
273 	}
274 	
275 	function _checkSignature(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s, bytes32 typehash) internal {
276 		require(deadline >= block.timestamp, "Impermax: EXPIRED");
277 		bytes32 digest = keccak256(
278 			abi.encodePacked(
279 				'\x19\x01',
280 				DOMAIN_SEPARATOR,
281 				keccak256(abi.encode(typehash, owner, spender, value, nonces[owner]++, deadline))
282 			)
283 		);
284 		address recoveredAddress = ecrecover(digest, v, r, s);
285 		require(recoveredAddress != address(0) && recoveredAddress == owner, "Impermax: INVALID_SIGNATURE");	
286 	}
287 
288 	// keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
289 	bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
290 	function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
291 		_checkSignature(owner, spender, value, deadline, v, r, s, PERMIT_TYPEHASH);
292 		_approve(owner, spender, value);
293 	}
294 }
295 
296 // File: contracts\interfaces\IERC20.sol
297 
298 pragma solidity >=0.5.0;
299 
300 interface IERC20 {
301     event Approval(address indexed owner, address indexed spender, uint value);
302     event Transfer(address indexed from, address indexed to, uint value);
303 
304     function name() external view returns (string memory);
305     function symbol() external view returns (string memory);
306     function decimals() external view returns (uint8);
307     function totalSupply() external view returns (uint);
308     function balanceOf(address owner) external view returns (uint);
309     function allowance(address owner, address spender) external view returns (uint);
310 
311     function approve(address spender, uint value) external returns (bool);
312     function transfer(address to, uint value) external returns (bool);
313     function transferFrom(address from, address to, uint value) external returns (bool);
314 }
315 
316 // File: contracts\interfaces\IPoolToken.sol
317 
318 pragma solidity >=0.5.0;
319 
320 interface IPoolToken {
321 
322 	/*** Impermax ERC20 ***/
323 	
324 	event Transfer(address indexed from, address indexed to, uint value);
325 	event Approval(address indexed owner, address indexed spender, uint value);
326 	
327 	function name() external pure returns (string memory);
328 	function symbol() external pure returns (string memory);
329 	function decimals() external pure returns (uint8);
330 	function totalSupply() external view returns (uint);
331 	function balanceOf(address owner) external view returns (uint);
332 	function allowance(address owner, address spender) external view returns (uint);
333 	function approve(address spender, uint value) external returns (bool);
334 	function transfer(address to, uint value) external returns (bool);
335 	function transferFrom(address from, address to, uint value) external returns (bool);
336 	
337 	function DOMAIN_SEPARATOR() external view returns (bytes32);
338 	function PERMIT_TYPEHASH() external pure returns (bytes32);
339 	function nonces(address owner) external view returns (uint);
340 	function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
341 	
342 	/*** Pool Token ***/
343 	
344 	event Mint(address indexed sender, address indexed minter, uint mintAmount, uint mintTokens);
345 	event Redeem(address indexed sender, address indexed redeemer, uint redeemAmount, uint redeemTokens);
346 	event Sync(uint totalBalance);
347 	
348 	function underlying() external view returns (address);
349 	function factory() external view returns (address);
350 	function totalBalance() external view returns (uint);
351 	function MINIMUM_LIQUIDITY() external pure returns (uint);
352 
353 	function exchangeRate() external returns (uint);
354 	function mint(address minter) external returns (uint mintTokens);
355 	function redeem(address redeemer) external returns (uint redeemAmount);
356 	function skim(address to) external;
357 	function sync() external;
358 	
359 	function _setFactory() external;
360 }
361 
362 // File: contracts\PoolToken.sol
363 
364 pragma solidity =0.5.16;
365 
366 
367 
368 
369 
370 contract PoolToken is IPoolToken, ImpermaxERC20 {
371    	uint internal constant initialExchangeRate = 1e18;
372 	address public underlying;
373 	address public factory;
374 	uint public totalBalance;
375 	uint public constant MINIMUM_LIQUIDITY = 1000;
376 	
377 	event Mint(address indexed sender, address indexed minter, uint mintAmount, uint mintTokens);
378 	event Redeem(address indexed sender, address indexed redeemer, uint redeemAmount, uint redeemTokens);
379 	event Sync(uint totalBalance);
380 	
381 	/*** Initialize ***/
382 	
383 	// called once by the factory
384 	function _setFactory() external {
385 		require(factory == address(0), "Impermax: FACTORY_ALREADY_SET");
386 		factory = msg.sender;
387 	}
388 	
389 	/*** PoolToken ***/
390 	
391 	function _update() internal {
392 		totalBalance = IERC20(underlying).balanceOf(address(this));
393 		emit Sync(totalBalance);
394 	}
395 
396 	function exchangeRate() public returns (uint) 
397 	{
398 		uint _totalSupply = totalSupply; // gas savings
399 		uint _totalBalance = totalBalance; // gas savings
400 		if (_totalSupply == 0 || _totalBalance == 0) return initialExchangeRate;
401 		return _totalBalance.mul(1e18).div(_totalSupply);
402 	}
403 	
404 	// this low-level function should be called from another contract
405 	function mint(address minter) external nonReentrant update returns (uint mintTokens) {
406 		uint balance = IERC20(underlying).balanceOf(address(this));
407 		uint mintAmount = balance.sub(totalBalance);
408 		mintTokens = mintAmount.mul(1e18).div(exchangeRate());
409 
410 		if(totalSupply == 0) {
411 			// permanently lock the first MINIMUM_LIQUIDITY tokens
412 			mintTokens = mintTokens.sub(MINIMUM_LIQUIDITY);
413 			_mint(address(0), MINIMUM_LIQUIDITY);
414 		}
415 		require(mintTokens > 0, "Impermax: MINT_AMOUNT_ZERO");
416 		_mint(minter, mintTokens);
417 		emit Mint(msg.sender, minter, mintAmount, mintTokens);
418 	}
419 
420 	// this low-level function should be called from another contract
421 	function redeem(address redeemer) external nonReentrant update returns (uint redeemAmount) {
422 		uint redeemTokens = balanceOf[address(this)];
423 		redeemAmount = redeemTokens.mul(exchangeRate()).div(1e18);
424 
425 		require(redeemAmount > 0, "Impermax: REDEEM_AMOUNT_ZERO");
426 		require(redeemAmount <= totalBalance, "Impermax: INSUFFICIENT_CASH");
427 		_burn(address(this), redeemTokens);
428 		_safeTransfer(redeemer, redeemAmount);
429 		emit Redeem(msg.sender, redeemer, redeemAmount, redeemTokens);		
430 	}
431 
432 	// force real balance to match totalBalance
433 	function skim(address to) external nonReentrant {
434 		_safeTransfer(to, IERC20(underlying).balanceOf(address(this)).sub(totalBalance));
435 	}
436 
437 	// force totalBalance to match real balance
438 	function sync() external nonReentrant update {}
439 	
440 	/*** Utilities ***/
441 	
442 	// same safe transfer function used by UniSwapV2 (with fixed underlying)
443 	bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
444 	function _safeTransfer(address to, uint amount) internal {
445 		(bool success, bytes memory data) = underlying.call(abi.encodeWithSelector(SELECTOR, to, amount));
446 		require(success && (data.length == 0 || abi.decode(data, (bool))), "Impermax: TRANSFER_FAILED");
447 	}
448 	
449 	// prevents a contract from calling itself, directly or indirectly.
450 	bool internal _notEntered = true;
451 	modifier nonReentrant() {
452 		require(_notEntered, "Impermax: REENTERED");
453 		_notEntered = false;
454 		_;
455 		_notEntered = true;
456 	}
457 	
458 	// update totalBalance with current balance
459 	modifier update() {
460 		_;
461 		_update();
462 	}
463 }
464 
465 // File: contracts\xIMX.sol
466 
467 pragma solidity =0.5.16;
468 
469 
470 contract xIMX is PoolToken {
471 
472 	constructor(address _underlying) public {
473 		factory = msg.sender;
474 		_setName("xIMX", "Staked IMX");
475 		underlying = _underlying;
476 	}
477 	
478 }