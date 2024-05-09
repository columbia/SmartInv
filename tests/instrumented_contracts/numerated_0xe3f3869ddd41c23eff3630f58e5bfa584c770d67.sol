1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 
6 
7 /**
8  /$$                           /$$        /$$$$$$                  /$$   /$$             /$$                                       /$$      
9 | $$                          | $$       /$$__  $$                | $$$ | $$            | $$                                      | $$      
10 | $$        /$$$$$$   /$$$$$$$| $$   /$$|__/  \ $$  /$$$$$$       | $$$$| $$  /$$$$$$  /$$$$$$   /$$  /$$  /$$  /$$$$$$   /$$$$$$ | $$   /$$
11 | $$       /$$__  $$ /$$_____/| $$  /$$/   /$$$$$/ /$$__  $$      | $$ $$ $$ /$$__  $$|_  $$_/  | $$ | $$ | $$ /$$__  $$ /$$__  $$| $$  /$$/
12 | $$      | $$  \ $$| $$      | $$$$$$/   |___  $$| $$  \__/      | $$  $$$$| $$$$$$$$  | $$    | $$ | $$ | $$| $$  \ $$| $$  \__/| $$$$$$/ 
13 | $$      | $$  | $$| $$      | $$_  $$  /$$  \ $$| $$            | $$\  $$$| $$_____/  | $$ /$$| $$ | $$ | $$| $$  | $$| $$      | $$_  $$ 
14 | $$$$$$$$|  $$$$$$/|  $$$$$$$| $$ \  $$|  $$$$$$/| $$            | $$ \  $$|  $$$$$$$  |  $$$$/|  $$$$$/$$$$/|  $$$$$$/| $$      | $$ \  $$
15 |________/ \______/  \_______/|__/  \__/ \______/ |__/            |__/  \__/ \_______/   \___/   \_____/\___/  \______/ |__/      |__/  \__/
16 
17  /$$$$$$$$        /$$                                  /$$$$$$                        /$$                                    /$$    
18 |__  $$__/       | $$                                 /$$__  $$                      | $$                                   | $$    
19    | $$  /$$$$$$ | $$   /$$  /$$$$$$  /$$$$$$$       | $$  \__/  /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$  /$$$$$$   /$$$$$$$ /$$$$$$  
20    | $$ /$$__  $$| $$  /$$/ /$$__  $$| $$__  $$      | $$       /$$__  $$| $$__  $$|_  $$_/   /$$__  $$|____  $$ /$$_____/|_  $$_/  
21    | $$| $$  \ $$| $$$$$$/ | $$$$$$$$| $$  \ $$      | $$      | $$  \ $$| $$  \ $$  | $$    | $$  \__/ /$$$$$$$| $$        | $$    
22    | $$| $$  | $$| $$_  $$ | $$_____/| $$  | $$      | $$    $$| $$  | $$| $$  | $$  | $$ /$$| $$      /$$__  $$| $$        | $$ /$$
23    | $$|  $$$$$$/| $$ \  $$|  $$$$$$$| $$  | $$      |  $$$$$$/|  $$$$$$/| $$  | $$  |  $$$$/| $$     |  $$$$$$$|  $$$$$$$  |  $$$$/
24    |__/ \______/ |__/  \__/ \_______/|__/  |__/       \______/  \______/ |__/  |__/   \___/  |__/      \_______/ \_______/   \___/  
25 
26  * 
27 */
28 
29 
30 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
31 // Subject to the MIT license.
32 /**
33  * @dev Wrappers over Solidity's arithmetic operations with added overflow
34  * checks.
35  *
36  * Arithmetic operations in Solidity wrap on overflow. This can easily result
37  * in bugs, because programmers usually assume that an overflow raises an
38  * error, which is the standard behavior in high level programming languages.
39  * `SafeMath` restores this intuition by reverting the transaction when an
40  * operation overflows.
41  *
42  * Using this library instead of the unchecked operations eliminates an entire
43  * class of bugs, so it's recommended to use it always.
44  */
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      * - Addition cannot overflow.
53      */
54     function add(uint a, uint b) internal pure returns (uint) {
55         uint c = a + b;
56         require(c >= a, "add: +");
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
63      *
64      * Counterpart to Solidity's `+` operator.
65      *
66      * Requirements:
67      * - Addition cannot overflow.
68      */
69     function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
70         uint c = a + b;
71         require(c >= a, errorMessage);
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot underflow.
83      */
84     function sub(uint a, uint b) internal pure returns (uint) {
85         return sub(a, b, "sub: -");
86     }
87 
88     /**
89      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      * - Subtraction cannot underflow.
95      */
96     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
97         require(b <= a, errorMessage);
98         uint c = a - b;
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
105      *
106      * Counterpart to Solidity's `*` operator.
107      *
108      * Requirements:
109      * - Multiplication cannot overflow.
110      */
111     function mul(uint a, uint b) internal pure returns (uint) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint c = a * b;
120         require(c / a == b, "mul: *");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint c = a * b;
142         require(c / a == b, errorMessage);
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers.
149      * Reverts on division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint a, uint b) internal pure returns (uint) {
159         return div(a, b, "div: /");
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers.
164      * Reverts with custom message on division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
174         // Solidity only automatically asserts when dividing by 0
175         require(b > 0, errorMessage);
176         uint c = a / b;
177         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * Reverts when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      * - The divisor cannot be zero.
192      */
193     function mod(uint a, uint b) internal pure returns (uint) {
194         return mod(a, b, "mod: %");
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts with custom message when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
209         require(b != 0, errorMessage);
210         return a % b;
211     }
212 }
213 
214 /**
215  * @dev Contract module that helps prevent reentrant calls to a function.
216  *
217  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
218  * available, which can be applied to functions to make sure there are no nested
219  * (reentrant) calls to them.
220  *
221  * Note that because there is a single `nonReentrant` guard, functions marked as
222  * `nonReentrant` may not call one another. This can be worked around by making
223  * those functions `private`, and then adding `external` `nonReentrant` entry
224  * points to them.
225  *
226  * TIP: If you would like to learn more about reentrancy and alternative ways
227  * to protect against it, check out our blog post
228  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
229  */
230 contract ReentrancyGuard {
231     // Booleans are more expensive than uint256 or any type that takes up a full
232     // word because each write operation emits an extra SLOAD to first read the
233     // slot's contents, replace the bits taken up by the boolean, and then write
234     // back. This is the compiler's defense against contract upgrades and
235     // pointer aliasing, and it cannot be disabled.
236 
237     // The values being non-zero value makes deployment a bit more expensive,
238     // but in exchange the refund on every call to nonReentrant will be lower in
239     // amount. Since refunds are capped to a percentage of the total
240     // transaction's gas, it is best to keep them low in cases like this one, to
241     // increase the likelihood of the full refund coming into effect.
242     uint256 private constant _NOT_ENTERED = 1;
243     uint256 private constant _ENTERED = 2;
244 
245     uint256 private _status;
246 
247     constructor () internal {
248         _status = _NOT_ENTERED;
249     }
250 
251     /**
252      * @dev Prevents a contract from calling itself, directly or indirectly.
253      * Calling a `nonReentrant` function from another `nonReentrant`
254      * function is not supported. It is possible to prevent this from happening
255      * by making the `nonReentrant` function external, and make it call a
256      * `private` function that does the actual work.
257      */
258     modifier nonReentrant() {
259         // On the first call to nonReentrant, _notEntered will be true
260         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
261 
262         // Any calls to nonReentrant after this point will fail
263         _status = _ENTERED;
264 
265         _;
266 
267         // By storing the original value once again, a refund is triggered (see
268         // https://eips.ethereum.org/EIPS/eip-2200)
269         _status = _NOT_ENTERED;
270     }
271 }
272 
273 /**
274  * @dev Interface of the ERC20 standard as defined in the EIP.
275  */
276 interface IERC20 {
277     /**
278      * @dev Returns the amount of tokens in existence.
279      */
280     function totalSupply() external view returns (uint256);
281 
282     /**
283      * @dev Returns the amount of tokens owned by `account`.
284      */
285     function balanceOf(address account) external view returns (uint256);
286 
287     /**
288      * @dev Moves `amount` tokens from the caller's account to `recipient`.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transfer(address recipient, uint256 amount) external returns (bool);
295 
296     /**
297      * @dev Returns the remaining number of tokens that `spender` will be
298      * allowed to spend on behalf of `owner` through {transferFrom}. This is
299      * zero by default.
300      *
301      * This value changes when {approve} or {transferFrom} are called.
302      */
303     function allowance(address owner, address spender) external view returns (uint256);
304 
305     /**
306      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
307      *
308      * Returns a boolean value indicating whether the operation succeeded.
309      *
310      * IMPORTANT: Beware that changing an allowance with this method brings the risk
311      * that someone may use both the old and the new allowance by unfortunate
312      * transaction ordering. One possible solution to mitigate this race
313      * condition is to first reduce the spender's allowance to 0 and set the
314      * desired value afterwards:
315      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316      *
317      * Emits an {Approval} event.
318      */
319     function approve(address spender, uint256 amount) external returns (bool);
320 
321     /**
322      * @dev Moves `amount` tokens from `sender` to `recipient` using the
323      * allowance mechanism. `amount` is then deducted from the caller's
324      * allowance.
325      *
326      * Returns a boolean value indicating whether the operation succeeded.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
331 
332     /**
333      * @dev Emitted when `value` tokens are moved from one account (`from`) to
334      * another (`to`).
335      *
336      * Note that `value` may be zero.
337      */
338     event Transfer(address indexed from, address indexed to, uint256 value);
339 
340     /**
341      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
342      * a call to {approve}. `value` is the new allowance.
343      */
344     event Approval(address indexed owner, address indexed spender, uint256 value);
345 }
346 
347 /**
348  * @dev Collection of functions related to the address type
349  */
350 library Address {
351     /**
352      * @dev Returns true if `account` is a contract.
353      *
354      * [IMPORTANT]
355      * ====
356      * It is unsafe to assume that an address for which this function returns
357      * false is an externally-owned account (EOA) and not a contract.
358      *
359      * Among others, `isContract` will return false for the following
360      * types of addresses:
361      *
362      *  - an externally-owned account
363      *  - a contract in construction
364      *  - an address where a contract will be created
365      *  - an address where a contract lived, but was destroyed
366      * ====
367      */
368     function isContract(address account) internal view returns (bool) {
369         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
370         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
371         // for accounts without code, i.e. `keccak256('')`
372         bytes32 codehash;
373         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
374         // solhint-disable-next-line no-inline-assembly
375         assembly { codehash := extcodehash(account) }
376         return (codehash != accountHash && codehash != 0x0);
377     }
378 
379     /**
380      * @dev Converts an `address` into `address payable`. Note that this is
381      * simply a type cast: the actual underlying value is not changed.
382      *
383      * _Available since v2.4.0._
384      */
385     function toPayable(address account) internal pure returns (address payable) {
386         return address(uint160(account));
387     }
388 
389     /**
390      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
391      * `recipient`, forwarding all available gas and reverting on errors.
392      *
393      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
394      * of certain opcodes, possibly making contracts go over the 2300 gas limit
395      * imposed by `transfer`, making them unable to receive funds via
396      * `transfer`. {sendValue} removes this limitation.
397      *
398      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
399      *
400      * IMPORTANT: because control is transferred to `recipient`, care must be
401      * taken to not create reentrancy vulnerabilities. Consider using
402      * {ReentrancyGuard} or the
403      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
404      *
405      * _Available since v2.4.0._
406      */
407     function sendValue(address payable recipient, uint256 amount) internal {
408         require(address(this).balance >= amount, "Address: insufficient");
409 
410         // solhint-disable-next-line avoid-call-value
411         (bool success, ) = recipient.call{value:amount}("");
412         require(success, "Address: reverted");
413     }
414 }
415 
416 /**
417  * @title SafeERC20
418  * @dev Wrappers around ERC20 operations that throw on failure (when the token
419  * contract returns false). Tokens that return no value (and instead revert or
420  * throw on failure) are also supported, non-reverting calls are assumed to be
421  * successful.
422  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
423  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
424  */
425 library SafeERC20 {
426     using SafeMath for uint256;
427     using Address for address;
428 
429     function safeTransfer(IERC20 token, address to, uint256 value) internal {
430         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
431     }
432 
433     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
434         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
435     }
436 
437     function safeApprove(IERC20 token, address spender, uint256 value) internal {
438         // safeApprove should only be called when setting an initial allowance,
439         // or when resetting it to zero. To increase and decrease it, use
440         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
441         // solhint-disable-next-line max-line-length
442         require((value == 0) || (token.allowance(address(this), spender) == 0),
443             "SafeERC20: approve from non-zero to non-zero allowance"
444         );
445         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
446     }
447 
448     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
449         uint256 newAllowance = token.allowance(address(this), spender).add(value);
450         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
451     }
452 
453     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
454         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: < 0");
455         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     /**
459      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
460      * on the return value: the return value is optional (but if data is returned, it must not be false).
461      * @param token The token targeted by the call.
462      * @param data The call data (encoded using abi.encode or one of its variants).
463      */
464     function callOptionalReturn(IERC20 token, bytes memory data) private {
465         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
466         // we're implementing it ourselves.
467 
468         // A Solidity high level call has three parts:
469         //  1. The target address is checked to verify it contains contract code
470         //  2. The call itself is made, and success asserted
471         //  3. The return value is decoded, which in turn checks the size of the returned data.
472         // solhint-disable-next-line max-line-length
473         require(address(token).isContract(), "SafeERC20: !contract");
474 
475         // solhint-disable-next-line avoid-low-level-calls
476         (bool success, bytes memory returndata) = address(token).call(data);
477         require(success, "SafeERC20: low-level call failed");
478 
479         if (returndata.length > 0) { // Return data is optional
480             // solhint-disable-next-line max-line-length
481             require(abi.decode(returndata, (bool)), "SafeERC20: !succeed");
482         }
483     }
484 }
485 
486 library Lock3rV1Library {
487     function getReserve(address pair, address reserve) external view returns (uint) {
488         (uint _r0, uint _r1,) = IUniswapV2Pair(pair).getReserves();
489         if (IUniswapV2Pair(pair).token0() == reserve) {
490             return _r0;
491         } else if (IUniswapV2Pair(pair).token1() == reserve) {
492             return _r1;
493         } else {
494             return 0;
495         }
496     }
497 
498 }
499 
500 interface IUniswapV2Pair {
501     event Approval(address indexed owner, address indexed spender, uint value);
502     event Transfer(address indexed from, address indexed to, uint value);
503 
504     function name() external pure returns (string memory);
505     function symbol() external pure returns (string memory);
506     function decimals() external pure returns (uint8);
507     function totalSupply() external view returns (uint);
508     function balanceOf(address owner) external view returns (uint);
509     function allowance(address owner, address spender) external view returns (uint);
510 
511     function approve(address spender, uint value) external returns (bool);
512     function transfer(address to, uint value) external returns (bool);
513     function transferFrom(address from, address to, uint value) external returns (bool);
514 
515     function DOMAIN_SEPARATOR() external view returns (bytes32);
516     function PERMIT_TYPEHASH() external pure returns (bytes32);
517     function nonces(address owner) external view returns (uint);
518 
519     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
520 
521     event Fund(address indexed sender, uint amount0, uint amount1);
522     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
523     event Swap(
524         address indexed sender,
525         uint amount0In,
526         uint amount1In,
527         uint amount0Out,
528         uint amount1Out,
529         address indexed to
530     );
531     event Sync(uint112 reserve0, uint112 reserve1);
532 
533     function MINIMUM_LIQUIDITY() external pure returns (uint);
534     function factory() external view returns (address);
535     function token0() external view returns (address);
536     function token1() external view returns (address);
537     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
538     function price0CumulativeLast() external view returns (uint);
539     function price1CumulativeLast() external view returns (uint);
540     function kLast() external view returns (uint);
541 
542     function fund(address to) external returns (uint liquidity);
543     function burn(address to) external returns (uint amount0, uint amount1);
544     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
545     function skim(address to) external;
546     function sync() external;
547 
548     function initialize(address, address) external;
549 }
550 
551 interface IGovernance {
552     function proposeJob(address job) external;
553     function slash(address bonded, address locker, uint amount) external;
554 }
555 
556 interface ILock3rV1Helper {
557     function getQuoteLimit(uint gasUsed) external view returns (uint);
558 }
559 
560 contract Lock3r is ReentrancyGuard {
561     using SafeMath for uint;
562     using SafeERC20 for IERC20;
563 
564     /// @notice Lock3r Helper to set max prices for the ecosystem
565     ILock3rV1Helper public LK3RH;
566 
567     /// @notice EIP-20 token name for this token //Joe Biden
568     string public constant name = "Lock3r";
569 
570     /// @notice EIP-20 token symbol for this token // is
571     string public constant symbol = "LK3R";
572 
573     /// @notice EIP-20 token decimals for this token //POTUS - God Bless America
574     uint8 public constant decimals = 18;
575 
576     /// @notice Total number of tokens in circulation
577     uint public totalSupply = 200000e18; // Total Supply = 200,000 - No more can be created/minted thanks to @sosoliditycrew on TG
578 
579     /// @notice A record of each accounts delegate
580     mapping (address => address) public delegates;
581 
582     /// @notice A record of votes checkpoints for each account, by index
583     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
584 
585     /// @notice The number of checkpoints for each account
586     mapping (address => uint32) public numCheckpoints;
587 
588     mapping (address => mapping (address => uint)) internal allowances;
589     mapping (address => uint) internal balances;
590 
591     /// @notice The EIP-712 typehash for the contract's domain
592     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");
593     bytes32 public immutable DOMAINSEPARATOR;
594 
595     /// @notice The EIP-712 typehash for the delegation struct used by the contract
596     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint nonce,uint expiry)");
597 
598     /// @notice The EIP-712 typehash for the permit struct used by the contract
599     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");
600 
601 
602     /// @notice A record of states for signing / validating signatures
603     mapping (address => uint) public nonces;
604 
605     /// @notice An event thats emitted when an account changes its delegate
606     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
607 
608     /// @notice An event thats emitted when a delegate account's vote balance changes
609     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
610 
611     /// @notice A checkpoint for marking number of votes from a given block
612     struct Checkpoint {
613         uint32 fromBlock;
614         uint votes;
615     }
616 
617     /**
618      * @notice Delegate votes from `msg.sender` to `delegatee`
619      * @param delegatee The address to delegate votes to
620      */
621     function delegate(address delegatee) public {
622         _delegate(msg.sender, delegatee);
623     }
624 
625     /**
626      * @notice Delegates votes from signatory to `delegatee`
627      * @param delegatee The address to delegate votes to
628      * @param nonce The contract state required to match the signature
629      * @param expiry The time at which to expire the signature
630      * @param v The recovery byte of the signature
631      * @param r Half of the ECDSA signature pair
632      * @param s Half of the ECDSA signature pair
633      */
634     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
635         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
636         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
637         address signatory = ecrecover(digest, v, r, s);
638         require(signatory != address(0), "delegateBySig: sig");
639         require(nonce == nonces[signatory]++, "delegateBySig: nonce");
640         require(now <= expiry, "delegateBySig: expired");
641         _delegate(signatory, delegatee);
642     }
643 
644     /**
645      * @notice Gets the current votes balance for `account`
646      * @param account The address to get votes balance
647      * @return The number of current votes for `account`
648      */
649     function getCurrentVotes(address account) external view returns (uint) {
650         uint32 nCheckpoints = numCheckpoints[account];
651         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
652     }
653 
654     /**
655      * @notice Determine the prior number of votes for an account as of a block number
656      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
657      * @param account The address of the account to check
658      * @param blockNumber The block number to get the vote balance at
659      * @return The number of votes the account had as of the given block
660      */
661     function getPriorVotes(address account, uint blockNumber) public view returns (uint) {
662         require(blockNumber < block.number, "getPriorVotes:");
663 
664         uint32 nCheckpoints = numCheckpoints[account];
665         if (nCheckpoints == 0) {
666             return 0;
667         }
668 
669         // First check most recent balance
670         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
671             return checkpoints[account][nCheckpoints - 1].votes;
672         }
673 
674         // Next check implicit zero balance
675         if (checkpoints[account][0].fromBlock > blockNumber) {
676             return 0;
677         }
678 
679         uint32 lower = 0;
680         uint32 upper = nCheckpoints - 1;
681         while (upper > lower) {
682             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
683             Checkpoint memory cp = checkpoints[account][center];
684             if (cp.fromBlock == blockNumber) {
685                 return cp.votes;
686             } else if (cp.fromBlock < blockNumber) {
687                 lower = center;
688             } else {
689                 upper = center - 1;
690             }
691         }
692         return checkpoints[account][lower].votes;
693     }
694 
695     function _delegate(address delegator, address delegatee) internal {
696         address currentDelegate = delegates[delegator];
697         uint delegatorBalance = votes[delegator].add(bonds[delegator][address(this)]);
698         delegates[delegator] = delegatee;
699 
700         emit DelegateChanged(delegator, currentDelegate, delegatee);
701 
702         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
703     }
704 
705     function _moveDelegates(address srcRep, address dstRep, uint amount) internal {
706         if (srcRep != dstRep && amount > 0) {
707             if (srcRep != address(0)) {
708                 uint32 srcRepNum = numCheckpoints[srcRep];
709                 uint srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
710                 uint srcRepNew = srcRepOld.sub(amount, "_moveVotes: underflows");
711                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
712             }
713 
714             if (dstRep != address(0)) {
715                 uint32 dstRepNum = numCheckpoints[dstRep];
716                 uint dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
717                 uint dstRepNew = dstRepOld.add(amount);
718                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
719             }
720         }
721     }
722 
723     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint oldVotes, uint newVotes) internal {
724       uint32 blockNumber = safe32(block.number, "_writeCheckpoint: 32 bits");
725 
726       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
727           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
728       } else {
729           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
730           numCheckpoints[delegatee] = nCheckpoints + 1;
731       }
732 
733       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
734     }
735 
736     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
737         require(n < 2**32, errorMessage);
738         return uint32(n);
739     }
740 
741     /// @notice The standard EIP-20 transfer event
742     event Transfer(address indexed from, address indexed to, uint amount);
743 
744     /// @notice The standard EIP-20 approval event
745     event Approval(address indexed owner, address indexed spender, uint amount);
746 
747     /// @notice Submit a job
748     event SubmitJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
749 
750     /// @notice Apply credit to a job
751     event ApplyCredit(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
752 
753     /// @notice Remove credit for a job
754     event RemoveJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
755 
756     /// @notice Unbond credit for a job
757     event UnbondJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
758 
759     /// @notice Added a Job
760     event JobAdded(address indexed job, uint block, address governance);
761 
762     /// @notice Removed a job
763     event JobRemoved(address indexed job, uint block, address governance);
764 
765     /// @notice Worked a job
766     event LockerWorked(address indexed credit, address indexed job, address indexed locker, uint block, uint amount);
767 
768     /// @notice Locker bonding
769     event LockerBonding(address indexed locker, uint block, uint active, uint bond);
770 
771     /// @notice Locker bonded
772     event LockerBonded(address indexed locker, uint block, uint activated, uint bond);
773 
774     /// @notice Locker unbonding
775     event LockerUnbonding(address indexed locker, uint block, uint deactive, uint bond);
776 
777     /// @notice Locker unbound
778     event LockerUnbound(address indexed locker, uint block, uint deactivated, uint bond);
779     
780     /// @notice Locker slashed
781     event LockerSlashed(address indexed locker, address indexed slasher, uint block, uint slash);
782       
783       /// @notice Locker disputed
784     event LockerDispute(address indexed locker, uint block);
785     
786     /// @notice Locker resolved
787     event LockerResolved(address indexed locker, uint block);
788 
789     event AddCredit(address indexed credit, address indexed job, address indexed creditor, uint block, uint amount);
790     
791      /// @notice Locker rights approved to be spent by spender
792     event LockerRightApproval(address indexed owner, address indexed bonding ,address indexed spender, bool allowed);
793 
794     /// @notice Locker right transfered to a new address
795     event LockerRightTransfered(address indexed from, address indexed to, address indexed bond);
796 
797 
798     /// @notice 2 days to bond to become a locker
799     uint public BOND = 2 days;
800     /// @notice 7 days to unbond to remove funds from being a locker
801     uint public UNBOND = 7 days;
802     /// @notice 2 days till liquidity can be bound
803     uint public LIQUIDITYBOND = 2 days;
804 
805     /// @notice direct liquidity fee 0.3% - This can be modified via governance contract
806     uint public FEE = 30;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
807     uint constant public BASE = 10000;
808 
809     /// @notice address used for ETH transfers
810     address constant public ETH = address(0xE);
811 
812     /// @notice tracks all current bondings (time)
813     mapping(address => mapping(address => uint)) public bondings;
814     /// @notice tracks all current unbondings (time)
815     mapping(address => mapping(address => uint)) public unbondings;
816     /// @notice allows for partial unbonding
817     mapping(address => mapping(address => uint)) public partialUnbonding;
818     /// @notice tracks all current pending bonds (amount)
819     mapping(address => mapping(address => uint)) public pendingbonds;
820     /// @notice tracks how much a locker has bonded
821     mapping(address => mapping(address => uint)) public bonds;
822     /// @notice tracks underlying votes (that don't have bond)
823     mapping(address => uint) public votes;
824 
825     /// @notice total bonded (totalSupply for bonds)
826     uint public totalBonded = 0;
827     /// @notice tracks when a locker was first registered
828     mapping(address => uint) public firstSeen;
829     	
830     /// @notice tracks if a locker has a pending dispute
831     mapping(address => bool) public disputes;
832 
833     /// @notice tracks last job performed for a locker
834     mapping(address => uint) public lastJob;
835     /// @notice tracks the total job executions for a locker
836     mapping(address => uint) public workCompleted;
837     /// @notice list of all jobs registered for the locker system
838     mapping(address => bool) public jobs;
839     /// @notice the current credit available for a job
840     mapping(address => mapping(address => uint)) public credits;
841     /// @notice the balances for the liquidity providers
842     mapping(address => mapping(address => mapping(address => uint))) public liquidityProvided;
843     /// @notice liquidity unbonding days
844     mapping(address => mapping(address => mapping(address => uint))) public liquidityUnbonding;
845     /// @notice liquidity unbonding amounts
846     mapping(address => mapping(address => mapping(address => uint))) public liquidityAmountsUnbonding;
847     /// @dev job proposal delay
848     mapping(address => uint) public jobProposalDelay;
849     /// @notice liquidity apply date
850     mapping(address => mapping(address => mapping(address => uint))) public liquidityApplied;
851     /// @notice liquidity amount to apply
852     mapping(address => mapping(address => mapping(address => uint))) public liquidityAmount;
853 
854     /// @notice list of all current lockers
855     mapping(address => bool) public lockers;
856     /// @notice blacklist of lockers not allowed to participate
857     mapping(address => bool) public blacklist;
858     
859     //Allowances of transfer rights of locker rights
860     //first address is user,second is the spender,3rd is the bonding that may be allowed to be spent,finally last is bool if its allowed
861     mapping(address => mapping (address => mapping(address => bool))) internal LockerAllowances;
862 
863     /// @notice traversable array of lockers to make external management easier
864     address[] public lockerList;
865     /// @notice traversable array of jobs to make external management easier
866     address[] public jobList;
867 
868     /// @notice governance address for the governance contract
869     address public governance;
870     address public pendingGovernance;
871     
872      /// @notice treasury address for the treasury contract
873     address public treasury;
874 
875     /// @notice the liquidity token supplied by users paying for jobs
876     mapping(address => bool) public liquidityAccepted;
877 
878     address[] public liquidityPairs;
879 
880     uint internal _gasUsed;
881     
882     // Ethereum 101 - Constructors can only be called once
883     constructor() public {  
884         // Set governance for this token
885         governance = msg.sender;
886         // Set Treasury for this token
887         treasury = msg.sender;
888         balances[msg.sender] = balances[msg.sender].add(totalSupply);
889         // Supply needs to start in the hands of the contract creator
890         emit Transfer (address(0),msg.sender, totalSupply);
891         DOMAINSEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), _getChainId(), address(this)));
892     }
893     
894     
895     modifier onlyGovernance(){
896         require(msg.sender == governance);
897         _;
898     }
899     
900 
901     /**
902      * @notice Add ETH credit to a job to be paid out for work
903      * @param job the job being credited
904      */
905     function addCreditETH(address job) external payable {
906         require(jobs[job], "addCreditETH: !job");
907         uint _fee = msg.value.mul(FEE).div(BASE);
908         credits[job][ETH] = credits[job][ETH].add(msg.value.sub(_fee));
909         payable(governance).transfer(_fee);
910 
911         emit AddCredit(ETH, job, msg.sender, block.number, msg.value);
912     }
913 
914     /**
915      * @notice Add credit to a job to be paid out for work
916      * @param credit the credit being assigned to the job
917      * @param job the job being credited
918      * @param amount the amount of credit being added to the job
919      */
920     function addCredit(address credit, address job, uint amount) external nonReentrant {
921         require(jobs[job], "addCreditETH: !job");
922         uint _before = IERC20(credit).balanceOf(address(this));
923         IERC20(credit).safeTransferFrom(msg.sender, address(this), amount);
924         uint _received = IERC20(credit).balanceOf(address(this)).sub(_before);
925         uint _fee = _received.mul(FEE).div(BASE);
926         credits[job][credit] = credits[job][credit].add(_received.sub(_fee));
927         IERC20(credit).safeTransfer(governance, _fee);
928 
929         emit AddCredit(credit, job, msg.sender, block.number, _received);
930     }
931 
932     /**
933      * @notice Add non transferable votes for governance
934      * @param voter to add the votes to
935      * @param amount of votes to add
936      */
937     function addVotes(address voter, uint amount) external onlyGovernance{
938         _activate(voter, address(this));
939         votes[voter] = votes[voter].add(amount);
940         totalBonded = totalBonded.add(amount);
941         _moveDelegates(address(0), delegates[voter], amount);
942     }
943 
944     /**
945      * @notice Remove non transferable votes for governance
946      * @param voter to subtract the votes
947      * @param amount of votes to remove
948      */
949     function removeVotes(address voter, uint amount) external onlyGovernance{
950         votes[voter] = votes[voter].sub(amount);
951         totalBonded = totalBonded.sub(amount);
952         _moveDelegates(delegates[voter], address(0), amount);
953     }
954 
955     /**
956      * @notice Add credit to a job to be paid out for work
957      * @param job the job being credited
958      * @param amount the amount of credit being added to the job
959      */
960     function addLK3RCredit(address job, uint amount) external onlyGovernance{
961         require(jobs[job], "addLK3RCredit: !job");
962         credits[job][address(this)] = credits[job][address(this)].add(amount);
963         _fund(address(this), amount);
964 
965         emit AddCredit(address(this), job, msg.sender, block.number, amount);
966     }
967 
968     /**
969      * @notice Approve a liquidity pair for being accepted in future
970      * @param liquidity the liquidity no longer accepted
971      */
972     function approveLiquidity(address liquidity) external onlyGovernance{
973         require(!liquidityAccepted[liquidity], "approveLiquidity: !pair");
974         liquidityAccepted[liquidity] = true;
975         liquidityPairs.push(liquidity);
976     }
977 
978     /**
979      * @notice Revoke a liquidity pair from being accepted in future
980      * @param liquidity the liquidity no longer accepted
981      */
982     function revokeLiquidity(address liquidity) external onlyGovernance{
983         liquidityAccepted[liquidity] = false;
984     }
985     
986     /**
987      * @notice Set new liquidity fee from governance
988      * @param newFee the new fee for further liquidity adds
989      */
990     function setLiquidityFee(uint newFee) external onlyGovernance{
991         FEE = newFee;
992     }
993 
994     /**
995      * @notice Set bonding delay from governance
996      * @param newBond the new bonding delay
997      */
998     function setBondingDelay(uint newBond) external onlyGovernance{
999         BOND = newBond;
1000     }
1001 
1002     /**
1003      * @notice Set bonding delay from governance
1004      * @param newUnbond the new unbonding delay
1005      */
1006     function setUnbondingDelay(uint newUnbond) external onlyGovernance{
1007         UNBOND = newUnbond;
1008     }
1009 
1010     /**
1011      * @notice Set liquidity bonding delay from governance
1012      * @param newLiqBond the new liquidity bonding delay
1013      */
1014     function setLiquidityBondingDelay(uint newLiqBond) external onlyGovernance{
1015         LIQUIDITYBOND = newLiqBond;
1016     }
1017 
1018     /**
1019      * @notice Displays all accepted liquidity pairs
1020      */
1021     function pairs() external view returns (address[] memory) {
1022         return liquidityPairs;
1023     }
1024 
1025     /**
1026      * @notice Allows liquidity providers to submit jobs
1027      * @param liquidity the liquidity being added
1028      * @param job the job to assign credit to
1029      * @param amount the amount of liquidity tokens to use
1030      */
1031     function addLiquidityToJob(address liquidity, address job, uint amount) external nonReentrant {
1032         require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
1033         IERC20(liquidity).safeTransferFrom(msg.sender, address(this), amount);
1034         liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].add(amount);
1035 
1036         liquidityApplied[msg.sender][liquidity][job] = now;
1037         liquidityAmount[msg.sender][liquidity][job] = liquidityAmount[msg.sender][liquidity][job].add(amount);
1038 
1039         if (!jobs[job] && jobProposalDelay[job].add(UNBOND) < now) {
1040             IGovernance(governance).proposeJob(job);
1041             jobProposalDelay[job] = now;
1042         }
1043         emit SubmitJob(job, liquidity, msg.sender, block.number, amount);
1044     }
1045 
1046     /**
1047      * @notice Applies the credit provided in addLiquidityToJob to the job
1048      * @param provider the liquidity provider
1049      * @param liquidity the pair being added as liquidity
1050      * @param job the job that is receiving the credit
1051      */
1052     function applyCreditToJob(address provider, address liquidity, address job) external {
1053         require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
1054         require(liquidityApplied[provider][liquidity][job] != 0, "credit: no bond");
1055         require(block.timestamp.sub(liquidityApplied[provider][liquidity][job].add(LIQUIDITYBOND)) >= 0, "credit: bonding");
1056         uint _liquidity = Lock3rV1Library.getReserve(liquidity, address(this));
1057         uint _credit = _liquidity.mul(liquidityAmount[provider][liquidity][job]).div(IERC20(liquidity).totalSupply());
1058         _fund(address(this), _credit);
1059         credits[job][address(this)] = credits[job][address(this)].add(_credit);
1060         liquidityAmount[provider][liquidity][job] = 0;
1061 
1062         emit ApplyCredit(job, liquidity, provider, block.number, _credit);
1063     }
1064 
1065     /**
1066      * @notice Unbond liquidity for a job
1067      * @param liquidity the pair being unbound
1068      * @param job the job being unbound from
1069      * @param amount the amount of liquidity being removed
1070      */
1071     function unbondLiquidityFromJob(address liquidity, address job, uint amount) external {
1072         require(liquidityAmount[msg.sender][liquidity][job] == 0, "credit: pending credit");
1073         liquidityUnbonding[msg.sender][liquidity][job] = now;
1074         liquidityAmountsUnbonding[msg.sender][liquidity][job] = liquidityAmountsUnbonding[msg.sender][liquidity][job].add(amount);
1075         require(liquidityAmountsUnbonding[msg.sender][liquidity][job] <= liquidityProvided[msg.sender][liquidity][job], "unbondLiquidityFromJob: insufficient funds");
1076 
1077         uint _liquidity = Lock3rV1Library.getReserve(liquidity, address(this));
1078         uint _credit = _liquidity.mul(amount).div(IERC20(liquidity).totalSupply());
1079         if (_credit > credits[job][address(this)]) {
1080             _burn(address(this), credits[job][address(this)]);
1081             credits[job][address(this)] = 0;
1082         } else {
1083             _burn(address(this), _credit);
1084             credits[job][address(this)] = credits[job][address(this)].sub(_credit);
1085         }
1086 
1087         emit UnbondJob(job, liquidity, msg.sender, block.number, amount);
1088     }
1089 
1090     /**
1091      * @notice Allows liquidity providers to remove liquidity
1092      * @param liquidity the pair being unbound
1093      * @param job the job being unbound from
1094      */
1095     function removeLiquidityFromJob(address liquidity, address job) external {
1096         require(liquidityUnbonding[msg.sender][liquidity][job] != 0, "removeJob: unbond");
1097         require(block.timestamp.sub(liquidityUnbonding[msg.sender][liquidity][job].add(UNBOND)) >= 0 , "removeJob: unbonding");
1098         uint _amount = liquidityAmountsUnbonding[msg.sender][liquidity][job];
1099         liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].sub(_amount);
1100         liquidityAmountsUnbonding[msg.sender][liquidity][job] = 0;
1101         IERC20(liquidity).safeTransfer(msg.sender, _amount);
1102 
1103         emit RemoveJob(job, liquidity, msg.sender, block.number, _amount);
1104     }
1105 
1106     /**
1107      * @notice Allows treasury to fund new tokens to a job contract
1108      * @param amount the amount of tokens to fund to a job contract
1109      * Only Governance can fund a job contract from the treasury
1110      */
1111     function fund(uint amount) external onlyGovernance{
1112         _fund(treasury, amount);
1113     }
1114 
1115     /**
1116      * @notice burn owned tokens
1117      * @param amount the amount of tokens to burn
1118      */
1119     function burn(uint amount) external {
1120         _burn(msg.sender, amount);
1121     }
1122 
1123     function _fund(address dst, uint amount) internal {
1124         // transfer the amount to the recipient
1125         //Unit test job contracts cannot be funded if the treasury has insufficient funds
1126         require(balances[treasury] >= (amount), "treasury: exceeds balance");
1127         balances[dst] = balances[dst].add(amount);
1128         balances[treasury] = balances[treasury].sub(amount);
1129         emit Transfer(treasury, dst, amount);
1130     }
1131 
1132     function _burn(address dst, uint amount) internal {
1133         require(dst != address(0), "_burn: zero address");
1134         balances[dst] = balances[dst].sub(amount, "_burn: exceeds balance");
1135         totalSupply = totalSupply.sub(amount);
1136         emit Transfer(dst, address(0), amount);
1137     }
1138 
1139     /**
1140      * @notice Implemented by jobs to show that a locker performed work
1141      * @param locker address of the locker that performed the work
1142      */
1143     function worked(address locker) external {
1144         workReceipt(locker, LK3RH.getQuoteLimit(_gasUsed.sub(gasleft())));
1145     }
1146     
1147     /**
1148      * @notice Implemented by jobs to show that a locker performed work and get paid in ETH
1149      * @param locker address of the locker that performed the work
1150      */
1151     function workedETH(address locker) external {
1152         receiptETH(locker, LK3RH.getQuoteLimit(_gasUsed.sub(gasleft())));
1153     }
1154     
1155     /**
1156      * @notice Implemented by jobs to show that a locker performed work
1157      * @param locker address of the locker that performed the work
1158      * @param amount the reward that should be allocated
1159      */
1160     function workReceipt(address locker, uint amount) public {
1161         require(jobs[msg.sender], "workReceipt: !job");
1162         require(amount <= LK3RH.getQuoteLimit(_gasUsed.sub(gasleft())), "workReceipt: max limit");
1163         credits[msg.sender][address(this)] = credits[msg.sender][address(this)].sub(amount, "workReceipt: insuffient funds");
1164         lastJob[locker] = now;
1165         _reward(locker, amount);
1166         workCompleted[locker] = workCompleted[locker].add(amount);
1167         emit LockerWorked(address(this), msg.sender, locker, block.number, amount);
1168     }
1169 
1170     /**
1171      * @notice Implemented by jobs to show that a locker performed work
1172      * @param credit the asset being awarded to the locker
1173      * @param locker address of the locker that performed the work
1174      * @param amount the reward that should be allocated
1175      */
1176     function receipt(address credit, address locker, uint amount) external {
1177         require(jobs[msg.sender], "receipt: !job");
1178         credits[msg.sender][credit] = credits[msg.sender][credit].sub(amount, "workReceipt: insuffient funds");
1179         lastJob[locker] = now;
1180         IERC20(credit).safeTransfer(locker, amount);
1181         emit LockerWorked(credit, msg.sender, locker, block.number, amount);
1182     }
1183 
1184     /**
1185      * @notice Implemented by jobs to show that a locker performed work
1186      * @param locker address of the locker that performed the work
1187      * @param amount the amount of ETH sent to the locker
1188      */
1189     function receiptETH(address locker, uint amount) public {
1190         require(jobs[msg.sender], "receipt: !job");
1191         credits[msg.sender][ETH] = credits[msg.sender][ETH].sub(amount, "workReceipt: insuffient funds");
1192         lastJob[locker] = now;
1193         payable(locker).transfer(amount);
1194         emit LockerWorked(ETH, msg.sender, locker, block.number, amount);
1195     }
1196     
1197     
1198     function _reward(address _from, uint _amount) internal {
1199         bonds[_from][address(this)] = bonds[_from][address(this)].add(_amount);
1200         totalBonded = totalBonded.add(_amount);
1201         _moveDelegates(address(0), delegates[_from], _amount);
1202         emit Transfer(msg.sender, _from, _amount);
1203     }
1204 
1205     function _bond(address bonding, address _from, uint _amount) internal {
1206         bonds[_from][bonding] = bonds[_from][bonding].add(_amount);
1207         if (bonding == address(this)) {
1208             totalBonded = totalBonded.add(_amount);
1209             _moveDelegates(address(0), delegates[_from], _amount);
1210         }
1211     }
1212 
1213     function _unbond(address bonding, address _from, uint _amount) internal {
1214         bonds[_from][bonding] = bonds[_from][bonding].sub(_amount);
1215         if (bonding == address(this)) {
1216             totalBonded = totalBonded.sub(_amount);
1217             _moveDelegates(delegates[_from], address(0), _amount);
1218         }
1219 
1220     }
1221 
1222     /**
1223      * @notice Allows governance to add new job systems
1224      * @param job address of the contract for which work should be performed
1225      */
1226     function addJob(address job) external onlyGovernance{
1227         require(!jobs[job], "addJob: job known");
1228         jobs[job] = true;
1229         jobList.push(job);
1230         emit JobAdded(job, block.number, msg.sender);
1231     }
1232 
1233     /**
1234      * @notice Full listing of all jobs ever added
1235      * @return array blob
1236      */
1237     function getJobs() external view returns (address[] memory) {
1238         return jobList;
1239     }
1240 
1241     /**
1242      * @notice Allows governance to remove a job from the systems
1243      * @param job address of the contract for which work should be performed
1244      */
1245     function removeJob(address job) external onlyGovernance{
1246         jobs[job] = false;
1247         emit JobRemoved(job, block.number, msg.sender);
1248     }
1249 
1250     /**
1251      * @notice Allows governance to change the Lock3rHelper for max spend
1252      * @param _lk3rh new helper address to set
1253      */
1254     function setLock3rHelper(ILock3rV1Helper _lk3rh) external onlyGovernance{
1255         LK3RH = ILock3rV1Helper(_lk3rh);
1256     }
1257 
1258     /**
1259      * @notice Allows governance to change governance (for future upgradability)
1260      * @param _governance new governance address to set
1261      */
1262     function setGovernance(address _governance) external onlyGovernance {
1263         pendingGovernance = _governance;
1264     }
1265 
1266     /**
1267      * @notice Allows pendingGovernance to accept their role as governances(protection pattern)
1268      */
1269     function acceptGovernance() external {
1270         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
1271         governance = pendingGovernance;
1272     }
1273     
1274     /**
1275      * @notice Allows treasury to change treasury(for future upgradability)
1276      * @param _treasury new treasury address to set
1277      */
1278     function setTreasury(address _treasury) external onlyGovernance{
1279         treasury = _treasury;
1280     }
1281 
1282     /**
1283      * @notice confirms if the current locker is registered, can be used for general (non critical) functions
1284      * @param locker the locker being investigated
1285      * @return true/false if the address is a locker
1286      */
1287     function isLocker(address locker) public returns (bool) {
1288         _gasUsed = gasleft();
1289         return lockers[locker];
1290     }
1291 
1292     /**
1293      * @notice confirms if the current locker is registered and has a minimum bond, should be used for protected functions
1294      * @param locker the locker being investigated
1295      * @param minBond the minimum requirement for the asset provided in bond
1296      * @param earned the total funds earned in the lockers lifetime
1297      * @param age the age of the locker in the system
1298      * @return true/false if the address is a locker and has more than the bond
1299      */
1300     function isMinLocker(address locker, uint minBond, uint earned, uint age) external returns (bool) {
1301         _gasUsed = gasleft();
1302         return lockers[locker]
1303                 && bonds[locker][address(this)].add(votes[locker]) >= minBond
1304                 && workCompleted[locker] >= earned
1305                 && now.sub(firstSeen[locker]) >= age;
1306     }
1307 
1308     /**
1309      * @notice confirms if the current locker is registered and has a minimum bond, should be used for protected functions
1310      * @param locker the locker being investigated
1311      * @param bond the bound asset being evaluated
1312      * @param minBond the minimum requirement for the asset provided in bond
1313      * @param earned the total funds earned in the lockers lifetime
1314      * @param age the age of the locker in the system
1315      * @return true/false if the address is a locker and has more than the bond
1316      */
1317     function isBondedLocker(address locker, address bond, uint minBond, uint earned, uint age) external returns (bool) {
1318         _gasUsed = gasleft();
1319         return lockers[locker]
1320                 && bonds[locker][bond] >= minBond
1321                 && workCompleted[locker] >= earned
1322                 && now.sub(firstSeen[locker]) >= age;
1323     }
1324 
1325     /**
1326      * @notice begin the bonding process for a new locker
1327      * @param bonding the asset being bound
1328      * @param amount the amount of bonding asset being bound
1329      */
1330     function bond(address bonding, uint amount) external nonReentrant {
1331         require(!blacklist[msg.sender], "blacklisted");
1332         bondings[msg.sender][bonding] = now;
1333         if (bonding == address(this)) {
1334             _transferTokens(msg.sender, address(this), amount);
1335         } else {
1336             uint _before = IERC20(bonding).balanceOf(address(this));
1337             IERC20(bonding).safeTransferFrom(msg.sender, address(this), amount);
1338             amount = IERC20(bonding).balanceOf(address(this)).sub(_before);
1339         }
1340         pendingbonds[msg.sender][bonding] = pendingbonds[msg.sender][bonding].add(amount);
1341         emit LockerBonding(msg.sender, block.number, bondings[msg.sender][bonding], amount);
1342     }
1343 
1344     /**
1345      * @notice get full list of lockers in the system
1346      */
1347     function getLockers() external view returns (address[] memory) {
1348         return lockerList;
1349     }
1350 
1351    /**
1352      * @notice Does initial data initialization of locker entry
1353      * @param sender the address to init data for
1354      */
1355     function doDataInit(address sender) internal {
1356         if (firstSeen[sender] == 0) {
1357           firstSeen[sender] = now;
1358           lockerList.push(sender);
1359           lastJob[sender] = now;
1360         }
1361     }
1362 
1363     /**
1364      * @notice allows a locker to activate/register themselves after bonding
1365      * @param bonding the asset being activated as bond collateral
1366      */
1367     function activate(address bonding) external {
1368         require(!blacklist[msg.sender], "blacklisted");
1369         //In this part we changed the check of bonding time being lesser than now to check if current time is > bonding time
1370         require(bondings[msg.sender][bonding] != 0 && block.timestamp.sub(bondings[msg.sender][bonding].add(BOND)) >= 0, "bonding");
1371         //Setup initial data
1372         doDataInit(msg.sender);
1373         _activate(msg.sender, bonding);
1374     }
1375 
1376     function _activate(address locker, address bonding) internal {
1377         lockers[locker] = true;
1378         _bond(bonding, locker, pendingbonds[locker][bonding]);
1379         pendingbonds[locker][bonding] = 0;
1380         emit LockerBonded(locker, block.number, block.timestamp, bonds[locker][bonding]);
1381     }
1382 
1383     /**
1384      * @notice allows a locker to transfer their locker rights and bonds to another address
1385      * @param bonding the asset being transfered to new address as bond collateral
1386      * @param from the address locker rights and bonding amount is transfered from
1387      * @param to the address locker rights and bonding amount is transfered to
1388      */
1389     function transferLockerRight(address bonding,address from,address to) public {
1390      
1391         require(isLocker(from));
1392         require(msg.sender == from || LockerAllowances[from][msg.sender][bonding]);
1393         require(bondings[from][bonding] != 0 && block.timestamp.sub(bondings[from][bonding].add(BOND)) >= 0);
1394 
1395         doDataInit(to);
1396 
1397         //Set the user calling locker stat to false
1398         lockers[from] = false;
1399         //Set the to addr locker stat to true
1400         lockers[to] = true;
1401 
1402         //Unbond from sender
1403         uint currentbond = bonds[from][bonding];
1404         _unbond(bonding,from,currentbond);
1405         //Bond to receiver
1406         _bond(bonding,to,currentbond);
1407         //remove rights for this address after transfer is done from caller
1408         LockerAllowances[from][msg.sender][bonding] = false;
1409         emit LockerRightTransfered(from,to,bonding);
1410     }
1411 
1412     /**
1413      * @notice begin the unbonding process to stop being a locker
1414      * @param bonding the asset being unbound
1415      * @param amount allows for partial unbonding
1416      */
1417     function unbond(address bonding, uint amount) external {
1418         unbondings[msg.sender][bonding] = now;
1419         _unbond(bonding, msg.sender, amount);
1420         partialUnbonding[msg.sender][bonding] = partialUnbonding[msg.sender][bonding].add(amount);
1421         emit LockerUnbonding(msg.sender, block.number, unbondings[msg.sender][bonding], amount);
1422     }
1423 
1424     /**
1425      * @notice withdraw funds after unbonding has finished
1426      * @param bonding the asset to withdraw from the bonding pool
1427      */
1428     function withdraw(address bonding) external nonReentrant {
1429         require(unbondings[msg.sender][bonding] != 0 &&block.timestamp.sub(unbondings[msg.sender][bonding].add(UNBOND)) >= 0, "withdraw: unbonding");
1430         require(!disputes[msg.sender], "disputes");
1431 
1432         if (bonding == address(this)) {
1433             _transferTokens(address(this), msg.sender, partialUnbonding[msg.sender][bonding]);
1434         } else {
1435             IERC20(bonding).safeTransfer(msg.sender, partialUnbonding[msg.sender][bonding]);
1436         }
1437         emit LockerUnbound(msg.sender, block.number, block.timestamp, partialUnbonding[msg.sender][bonding]);
1438         partialUnbonding[msg.sender][bonding] = 0;
1439     }
1440     
1441     /**
1442      * @notice blacklists a locker from participating in the network
1443      * @param locker the address being slashed
1444      */
1445     function revoke(address locker) external onlyGovernance{
1446         lockers[locker] = false;
1447         blacklist[locker] = true;
1448         IGovernance(governance).slash(address(this), locker, bonds[locker][address(this)]);
1449     }
1450     
1451 
1452     /**
1453      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
1454      * @param account The address of the account holding the funds
1455      * @param spender The address of the account spending the funds
1456      * @return The number of tokens approved
1457      */
1458     function allowance(address account, address spender) external view returns (uint) {
1459         return allowances[account][spender];
1460     }
1461 
1462     /**
1463      * @notice Approve `spender` to transfer up to `amount` from `src`
1464      * @dev This will overwrite the approval amount for `spender`
1465      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1466      * @param spender The address of the account which may transfer tokens
1467      * @param amount The number of tokens that are approved (2^256-1 means infinite)
1468      * @return Whether or not the approval succeeded
1469      */
1470     function approve(address spender, uint amount) public returns (bool) {
1471         allowances[msg.sender][spender] = amount;
1472 
1473         emit Approval(msg.sender, spender, amount);
1474         return true;
1475     }
1476     
1477     /**
1478      * @notice Approve `spender` to transfer Locker rights
1479      * @param spender The address of the account which may transfer locker rights
1480      * @param fAllow whether this spender should be able to transfer rights
1481      * @return Whether or not the approval succeeded
1482      */
1483     function lockerightapprove(address spender,address bonding,bool fAllow) public returns (bool) {
1484         LockerAllowances[msg.sender][spender][bonding] = fAllow;
1485 
1486         emit LockerRightApproval(msg.sender, bonding,spender, fAllow);
1487         return true;
1488     }
1489 
1490     /**
1491      * @notice Triggers an approval from owner to spends
1492      * @param owner The address to approve from
1493      * @param spender The address to be approved
1494      * @param amount The number of tokens that are approved (2^256-1 means infinite)
1495      * @param deadline The time at which to expire the signature
1496      * @param v The recovery byte of the signature
1497      * @param r Half of the ECDSA signature pair
1498      * @param s Half of the ECDSA signature pair
1499      */
1500     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
1501         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
1502         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
1503         address signatory = ecrecover(digest, v, r, s);
1504         require(signatory != address(0), "permit: signature");
1505         require(signatory == owner, "permit: unauthorized");
1506         require(now <= deadline, "permit: expired");
1507 
1508         allowances[owner][spender] = amount;
1509 
1510         emit Approval(owner, spender, amount);
1511     }
1512 
1513     /**
1514      * @notice Get the number of tokens held by the `account`
1515      * @param account The address of the account to get the balance of
1516      * @return The number of tokens held
1517      */
1518     function balanceOf(address account) external view returns (uint) {
1519         return balances[account];
1520     }
1521 
1522     /**
1523      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1524      * @param dst The address of the destination account
1525      * @param amount The number of tokens to transfer
1526      * @return Whether or not the transfer succeeded
1527      */
1528     function transfer(address dst, uint amount) public returns (bool) {
1529         _transferTokens(msg.sender, dst, amount);
1530         return true;
1531     }
1532 
1533     /**
1534      * @notice Transfer `amount` tokens from `src` to `dst`
1535      * @param src The address of the source account
1536      * @param dst The address of the destination account
1537      * @param amount The number of tokens to transfer
1538      * @return Whether or not the transfer succeeded
1539      */
1540     function transferFrom(address src, address dst, uint amount) external returns (bool) {
1541         address spender = msg.sender;
1542         uint spenderAllowance = allowances[src][spender];
1543 
1544         if (spender != src && spenderAllowance != uint(-1)) {
1545             uint newAllowance = spenderAllowance.sub(amount, "transferFrom: exceeds spender allowance");
1546             allowances[src][spender] = newAllowance;
1547 
1548             emit Approval(src, spender, newAllowance);
1549         }
1550 
1551         _transferTokens(src, dst, amount);
1552         return true;
1553     }
1554 
1555     function _transferTokens(address src, address dst, uint amount) internal {
1556         require(src != address(0), "_transferTokens: zero address");
1557         require(dst != address(0), "_transferTokens: zero address");
1558 
1559         balances[src] = balances[src].sub(amount, "_transferTokens: exceeds balance");
1560         balances[dst] = balances[dst].add(amount, "_transferTokens: overflows");
1561         emit Transfer(src, dst, amount);
1562     }
1563 
1564     function _getChainId() internal pure returns (uint) {
1565         uint chainId;
1566         assembly { chainId := chainid() }
1567         return chainId;
1568     }
1569 }