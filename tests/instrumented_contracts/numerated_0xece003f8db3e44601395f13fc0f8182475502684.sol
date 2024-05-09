1 pragma solidity ^0.5.17;
2 
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
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
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      *
84      * _Available since v2.4.0._
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      *
142      * _Available since v2.4.0._
143      */
144     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         // Solidity only automatically asserts when dividing by 0
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         return mod(a, b, "SafeMath: modulo by zero");
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts with custom message when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      *
179      * _Available since v2.4.0._
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 /**
188  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
189  * the optional functions; to access them see {ERC20Detailed}.
190  */
191 interface IERC20 {
192     /**
193      * @dev Returns the amount of tokens in existence.
194      */
195     function totalSupply() external view returns (uint256);
196 
197     /**
198      * @dev Returns the amount of tokens owned by `account`.
199      */
200     function balanceOf(address account) external view returns (uint256);
201 
202     /**
203      * @dev Moves `amount` tokens from the caller's account to `recipient`.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transfer(address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Returns the remaining number of tokens that `spender` will be
213      * allowed to spend on behalf of `owner` through {transferFrom}. This is
214      * zero by default.
215      *
216      * This value changes when {approve} or {transferFrom} are called.
217      */
218     function allowance(address owner, address spender) external view returns (uint256);
219 
220     /**
221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * IMPORTANT: Beware that changing an allowance with this method brings the risk
226      * that someone may use both the old and the new allowance by unfortunate
227      * transaction ordering. One possible solution to mitigate this race
228      * condition is to first reduce the spender's allowance to 0 and set the
229      * desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address spender, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Moves `amount` tokens from `sender` to `recipient` using the
238      * allowance mechanism. `amount` is then deducted from the caller's
239      * allowance.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Emitted when `value` tokens are moved from one account (`from`) to
249      * another (`to`).
250      *
251      * Note that `value` may be zero.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 value);
254 
255     /**
256      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
257      * a call to {approve}. `value` is the new allowance.
258      */
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 /**
263  * @dev Optional functions from the ERC20 standard.
264  */
265 contract ERC20Detailed is IERC20 {
266     string private _name;
267     string private _symbol;
268     uint8 private _decimals;
269 
270     /**
271      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
272      * these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor (string memory name, string memory symbol, uint8 decimals) public {
276         _name = name;
277         _symbol = symbol;
278         _decimals = decimals;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei.
303      *
304      * NOTE: This information is only used for _display_ purposes: it in
305      * no way affects any of the arithmetic of the contract, including
306      * {IERC20-balanceOf} and {IERC20-transfer}.
307      */
308     function decimals() public view returns (uint8) {
309         return _decimals;
310     }
311 }
312 
313 /**
314  * @dev Collection of functions related to the address type
315  */
316 library Address {
317     /**
318      * @dev Returns true if `account` is a contract.
319      *
320      * [IMPORTANT]
321      * ====
322      * It is unsafe to assume that an address for which this function returns
323      * false is an externally-owned account (EOA) and not a contract.
324      *
325      * Among others, `isContract` will return false for the following 
326      * types of addresses:
327      *
328      *  - an externally-owned account
329      *  - a contract in construction
330      *  - an address where a contract will be created
331      *  - an address where a contract lived, but was destroyed
332      * ====
333      */
334     function isContract(address account) internal view returns (bool) {
335         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
336         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
337         // for accounts without code, i.e. `keccak256('')`
338         bytes32 codehash;
339         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
340         // solhint-disable-next-line no-inline-assembly
341         assembly { codehash := extcodehash(account) }
342         return (codehash != accountHash && codehash != 0x0);
343     }
344 
345     /**
346      * @dev Converts an `address` into `address payable`. Note that this is
347      * simply a type cast: the actual underlying value is not changed.
348      *
349      * _Available since v2.4.0._
350      */
351     function toPayable(address account) internal pure returns (address payable) {
352         return address(uint160(account));
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      *
371      * _Available since v2.4.0._
372      */
373     function sendValue(address payable recipient, uint256 amount) internal {
374         require(address(this).balance >= amount, "Address: insufficient balance");
375 
376         // solhint-disable-next-line avoid-call-value
377         (bool success, ) = recipient.call.value(amount)("");
378         require(success, "Address: unable to send value, recipient may have reverted");
379     }
380 }
381 
382 /**
383  * @title SafeERC20
384  * @dev Wrappers around ERC20 operations that throw on failure (when the token
385  * contract returns false). Tokens that return no value (and instead revert or
386  * throw on failure) are also supported, non-reverting calls are assumed to be
387  * successful.
388  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
389  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
390  */
391 library SafeERC20 {
392     using SafeMath for uint256;
393     using Address for address;
394 
395     function safeTransfer(IERC20 token, address to, uint256 value) internal {
396         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
397     }
398 
399     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
400         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
401     }
402 
403     function safeApprove(IERC20 token, address spender, uint256 value) internal {
404         // safeApprove should only be called when setting an initial allowance,
405         // or when resetting it to zero. To increase and decrease it, use
406         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
407         // solhint-disable-next-line max-line-length
408         require((value == 0) || (token.allowance(address(this), spender) == 0),
409             "SafeERC20: approve from non-zero to non-zero allowance"
410         );
411         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
412     }
413 
414     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
415         uint256 newAllowance = token.allowance(address(this), spender).add(value);
416         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
417     }
418 
419     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
420         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
421         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
422     }
423 
424     /**
425      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
426      * on the return value: the return value is optional (but if data is returned, it must not be false).
427      * @param token The token targeted by the call.
428      * @param data The call data (encoded using abi.encode or one of its variants).
429      */
430     function callOptionalReturn(IERC20 token, bytes memory data) private {
431         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
432         // we're implementing it ourselves.
433 
434         // A Solidity high level call has three parts:
435         //  1. The target address is checked to verify it contains contract code
436         //  2. The call itself is made, and success asserted
437         //  3. The return value is decoded, which in turn checks the size of the returned data.
438         // solhint-disable-next-line max-line-length
439         require(address(token).isContract(), "SafeERC20: call to non-contract");
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = address(token).call(data);
443         require(success, "SafeERC20: low-level call failed");
444 
445         if (returndata.length > 0) { // Return data is optional
446             // solhint-disable-next-line max-line-length
447             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
448         }
449     }
450 }
451 
452 /**
453  * @dev Contract module that helps prevent reentrant calls to a function.
454  *
455  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
456  * available, which can be applied to functions to make sure there are no nested
457  * (reentrant) calls to them.
458  *
459  * Note that because there is a single `nonReentrant` guard, functions marked as
460  * `nonReentrant` may not call one another. This can be worked around by making
461  * those functions `private`, and then adding `external` `nonReentrant` entry
462  * points to them.
463  *
464  * TIP: If you would like to learn more about reentrancy and alternative ways
465  * to protect against it, check out our blog post
466  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
467  *
468  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
469  * metering changes introduced in the Istanbul hardfork.
470  */
471 contract ReentrancyGuard {
472     bool private _notEntered;
473 
474     constructor () internal {
475         // Storing an initial non-zero value makes deployment a bit more
476         // expensive, but in exchange the refund on every call to nonReentrant
477         // will be lower in amount. Since refunds are capped to a percetange of
478         // the total transaction's gas, it is best to keep them low in cases
479         // like this one, to increase the likelihood of the full refund coming
480         // into effect.
481         _notEntered = true;
482     }
483 
484     /**
485      * @dev Prevents a contract from calling itself, directly or indirectly.
486      * Calling a `nonReentrant` function from another `nonReentrant`
487      * function is not supported. It is possible to prevent this from happening
488      * by making the `nonReentrant` function external, and make it call a
489      * `private` function that does the actual work.
490      */
491     modifier nonReentrant() {
492         // On the first call to nonReentrant, _notEntered will be true
493         require(_notEntered, "ReentrancyGuard: reentrant call");
494 
495         // Any calls to nonReentrant after this point will fail
496         _notEntered = false;
497 
498         _;
499 
500         // By storing the original value once again, a refund is triggered (see
501         // https://eips.ethereum.org/EIPS/eip-2200)
502         _notEntered = true;
503     }
504 }
505 
506 interface IUniswapV2Pair {
507     event Approval(address indexed owner, address indexed spender, uint value);
508     event Transfer(address indexed from, address indexed to, uint value);
509 
510     function name() external pure returns (string memory);
511     function symbol() external pure returns (string memory);
512     function decimals() external pure returns (uint8);
513     function totalSupply() external view returns (uint);
514     function balanceOf(address owner) external view returns (uint);
515     function allowance(address owner, address spender) external view returns (uint);
516 
517     function approve(address spender, uint value) external returns (bool);
518     function transfer(address to, uint value) external returns (bool);
519     function transferFrom(address from, address to, uint value) external returns (bool);
520 
521     function DOMAIN_SEPARATOR() external view returns (bytes32);
522     function PERMIT_TYPEHASH() external pure returns (bytes32);
523     function nonces(address owner) external view returns (uint);
524 
525     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
526 
527     event Mint(address indexed sender, uint amount0, uint amount1);
528     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
529     event Swap(
530         address indexed sender,
531         uint amount0In,
532         uint amount1In,
533         uint amount0Out,
534         uint amount1Out,
535         address indexed to
536     );
537     event Sync(uint112 reserve0, uint112 reserve1);
538 
539     function MINIMUM_LIQUIDITY() external pure returns (uint);
540     function factory() external view returns (address);
541     function token0() external view returns (address);
542     function token1() external view returns (address);
543     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
544     function price0CumulativeLast() external view returns (uint);
545     function price1CumulativeLast() external view returns (uint);
546     function kLast() external view returns (uint);
547 
548     function mint(address to) external returns (uint liquidity);
549     function burn(address to) external returns (uint amount0, uint amount1);
550     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
551     function skim(address to) external;
552     function sync() external;
553 
554     function initialize(address, address) external;
555 }
556 
557 library UniswapV2Library {
558     using SafeMath for uint;
559 
560     // returns sorted token addresses, used to handle return values from pairs sorted in this order
561     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
562         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
563         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
564         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
565     }
566 
567     // calculates the CREATE2 address for a pair without making any external calls
568     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
569         (address token0, address token1) = sortTokens(tokenA, tokenB);
570         pair = address(uint(keccak256(abi.encodePacked(
571                 hex'ff',
572                 factory,
573                 keccak256(abi.encodePacked(token0, token1)),
574                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
575             ))));
576     }
577 
578     // fetches and sorts the reserves for a pair
579     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
580         (address token0,) = sortTokens(tokenA, tokenB);
581         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
582         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
583     }
584 
585     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
586     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
587         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
588         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
589         amountB = amountA.mul(reserveB) / reserveA;
590     }
591 }
592 
593 /*
594     Copyright 2019 dYdX Trading Inc.
595 
596     Licensed under the Apache License, Version 2.0 (the "License");
597     you may not use this file except in compliance with the License.
598     You may obtain a copy of the License at
599 
600     http://www.apache.org/licenses/LICENSE-2.0
601 
602     Unless required by applicable law or agreed to in writing, software
603     distributed under the License is distributed on an "AS IS" BASIS,
604     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
605     See the License for the specific language governing permissions and
606     limitations under the License.
607 */
608 /**
609  * @title Require
610  * @author dYdX
611  *
612  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
613  */
614 library Require {
615 
616     // ============ Constants ============
617 
618     uint256 constant ASCII_ZERO = 48; // '0'
619     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
620     uint256 constant ASCII_LOWER_EX = 120; // 'x'
621     bytes2 constant COLON = 0x3a20; // ': '
622     bytes2 constant COMMA = 0x2c20; // ', '
623     bytes2 constant LPAREN = 0x203c; // ' <'
624     byte constant RPAREN = 0x3e; // '>'
625     uint256 constant FOUR_BIT_MASK = 0xf;
626 
627     // ============ Library Functions ============
628 
629     function that(
630         bool must,
631         bytes32 file,
632         bytes32 reason
633     )
634     internal
635     pure
636     {
637         if (!must) {
638             revert(
639                 string(
640                     abi.encodePacked(
641                         stringifyTruncated(file),
642                         COLON,
643                         stringifyTruncated(reason)
644                     )
645                 )
646             );
647         }
648     }
649 
650     function that(
651         bool must,
652         bytes32 file,
653         bytes32 reason,
654         uint256 payloadA
655     )
656     internal
657     pure
658     {
659         if (!must) {
660             revert(
661                 string(
662                     abi.encodePacked(
663                         stringifyTruncated(file),
664                         COLON,
665                         stringifyTruncated(reason),
666                         LPAREN,
667                         stringify(payloadA),
668                         RPAREN
669                     )
670                 )
671             );
672         }
673     }
674 
675     function that(
676         bool must,
677         bytes32 file,
678         bytes32 reason,
679         uint256 payloadA,
680         uint256 payloadB
681     )
682     internal
683     pure
684     {
685         if (!must) {
686             revert(
687                 string(
688                     abi.encodePacked(
689                         stringifyTruncated(file),
690                         COLON,
691                         stringifyTruncated(reason),
692                         LPAREN,
693                         stringify(payloadA),
694                         COMMA,
695                         stringify(payloadB),
696                         RPAREN
697                     )
698                 )
699             );
700         }
701     }
702 
703     function that(
704         bool must,
705         bytes32 file,
706         bytes32 reason,
707         address payloadA
708     )
709     internal
710     pure
711     {
712         if (!must) {
713             revert(
714                 string(
715                     abi.encodePacked(
716                         stringifyTruncated(file),
717                         COLON,
718                         stringifyTruncated(reason),
719                         LPAREN,
720                         stringify(payloadA),
721                         RPAREN
722                     )
723                 )
724             );
725         }
726     }
727 
728     function that(
729         bool must,
730         bytes32 file,
731         bytes32 reason,
732         address payloadA,
733         uint256 payloadB
734     )
735     internal
736     pure
737     {
738         if (!must) {
739             revert(
740                 string(
741                     abi.encodePacked(
742                         stringifyTruncated(file),
743                         COLON,
744                         stringifyTruncated(reason),
745                         LPAREN,
746                         stringify(payloadA),
747                         COMMA,
748                         stringify(payloadB),
749                         RPAREN
750                     )
751                 )
752             );
753         }
754     }
755 
756     function that(
757         bool must,
758         bytes32 file,
759         bytes32 reason,
760         address payloadA,
761         uint256 payloadB,
762         uint256 payloadC
763     )
764     internal
765     pure
766     {
767         if (!must) {
768             revert(
769                 string(
770                     abi.encodePacked(
771                         stringifyTruncated(file),
772                         COLON,
773                         stringifyTruncated(reason),
774                         LPAREN,
775                         stringify(payloadA),
776                         COMMA,
777                         stringify(payloadB),
778                         COMMA,
779                         stringify(payloadC),
780                         RPAREN
781                     )
782                 )
783             );
784         }
785     }
786 
787     function that(
788         bool must,
789         bytes32 file,
790         bytes32 reason,
791         bytes32 payloadA
792     )
793     internal
794     pure
795     {
796         if (!must) {
797             revert(
798                 string(
799                     abi.encodePacked(
800                         stringifyTruncated(file),
801                         COLON,
802                         stringifyTruncated(reason),
803                         LPAREN,
804                         stringify(payloadA),
805                         RPAREN
806                     )
807                 )
808             );
809         }
810     }
811 
812     function that(
813         bool must,
814         bytes32 file,
815         bytes32 reason,
816         bytes32 payloadA,
817         uint256 payloadB,
818         uint256 payloadC
819     )
820     internal
821     pure
822     {
823         if (!must) {
824             revert(
825                 string(
826                     abi.encodePacked(
827                         stringifyTruncated(file),
828                         COLON,
829                         stringifyTruncated(reason),
830                         LPAREN,
831                         stringify(payloadA),
832                         COMMA,
833                         stringify(payloadB),
834                         COMMA,
835                         stringify(payloadC),
836                         RPAREN
837                     )
838                 )
839             );
840         }
841     }
842 
843     // ============ Private Functions ============
844 
845     function stringifyTruncated(
846         bytes32 input
847     )
848     private
849     pure
850     returns (bytes memory)
851     {
852         // put the input bytes into the result
853         bytes memory result = abi.encodePacked(input);
854 
855         // determine the length of the input by finding the location of the last non-zero byte
856         for (uint256 i = 32; i > 0; ) {
857             // reverse-for-loops with unsigned integer
858             /* solium-disable-next-line security/no-modify-for-iter-var */
859             i--;
860 
861             // find the last non-zero byte in order to determine the length
862             if (result[i] != 0) {
863                 uint256 length = i + 1;
864 
865                 /* solium-disable-next-line security/no-inline-assembly */
866                 assembly {
867                     mstore(result, length) // r.length = length;
868                 }
869 
870                 return result;
871             }
872         }
873 
874         // all bytes are zero
875         return new bytes(0);
876     }
877 
878     function stringify(
879         uint256 input
880     )
881     private
882     pure
883     returns (bytes memory)
884     {
885         if (input == 0) {
886             return "0";
887         }
888 
889         // get the final string length
890         uint256 j = input;
891         uint256 length;
892         while (j != 0) {
893             length++;
894             j /= 10;
895         }
896 
897         // allocate the string
898         bytes memory bstr = new bytes(length);
899 
900         // populate the string starting with the least-significant character
901         j = input;
902         for (uint256 i = length; i > 0; ) {
903             // reverse-for-loops with unsigned integer
904             /* solium-disable-next-line security/no-modify-for-iter-var */
905             i--;
906 
907             // take last decimal digit
908             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
909 
910             // remove the last decimal digit
911             j /= 10;
912         }
913 
914         return bstr;
915     }
916 
917     function stringify(
918         address input
919     )
920     private
921     pure
922     returns (bytes memory)
923     {
924         uint256 z = uint256(input);
925 
926         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
927         bytes memory result = new bytes(42);
928 
929         // populate the result with "0x"
930         result[0] = byte(uint8(ASCII_ZERO));
931         result[1] = byte(uint8(ASCII_LOWER_EX));
932 
933         // for each byte (starting from the lowest byte), populate the result with two characters
934         for (uint256 i = 0; i < 20; i++) {
935             // each byte takes two characters
936             uint256 shift = i * 2;
937 
938             // populate the least-significant character
939             result[41 - shift] = char(z & FOUR_BIT_MASK);
940             z = z >> 4;
941 
942             // populate the most-significant character
943             result[40 - shift] = char(z & FOUR_BIT_MASK);
944             z = z >> 4;
945         }
946 
947         return result;
948     }
949 
950     function stringify(
951         bytes32 input
952     )
953     private
954     pure
955     returns (bytes memory)
956     {
957         uint256 z = uint256(input);
958 
959         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
960         bytes memory result = new bytes(66);
961 
962         // populate the result with "0x"
963         result[0] = byte(uint8(ASCII_ZERO));
964         result[1] = byte(uint8(ASCII_LOWER_EX));
965 
966         // for each byte (starting from the lowest byte), populate the result with two characters
967         for (uint256 i = 0; i < 32; i++) {
968             // each byte takes two characters
969             uint256 shift = i * 2;
970 
971             // populate the least-significant character
972             result[65 - shift] = char(z & FOUR_BIT_MASK);
973             z = z >> 4;
974 
975             // populate the most-significant character
976             result[64 - shift] = char(z & FOUR_BIT_MASK);
977             z = z >> 4;
978         }
979 
980         return result;
981     }
982 
983     function char(
984         uint256 input
985     )
986     private
987     pure
988     returns (byte)
989     {
990         // return ASCII digit (0-9)
991         if (input < 10) {
992             return byte(uint8(input + ASCII_ZERO));
993         }
994 
995         // return ASCII letter (a-f)
996         return byte(uint8(input + ASCII_RELATIVE_ZERO));
997     }
998 }
999 
1000 /*
1001     Copyright 2020 Elastic Network, based on the work of Empty Set Squad and Dynamic Dollar Devs <elasticnetwork@protonmail.com>
1002 
1003     Licensed under the Apache License, Version 2.0 (the "License");
1004     you may not use this file except in compliance with the License.
1005     You may obtain a copy of the License at
1006 
1007     http://www.apache.org/licenses/LICENSE-2.0
1008 
1009     Unless required by applicable law or agreed to in writing, software
1010     distributed under the License is distributed on an "AS IS" BASIS,
1011     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1012     See the License for the specific language governing permissions and
1013     limitations under the License.
1014 */
1015 contract IEuro is IERC20 {
1016     function burn(uint256 amount) public;
1017     function burnFrom(address account, uint256 amount) public;
1018     function mint(address account, uint256 amount) public returns (bool);
1019 }
1020 
1021 /*
1022     Copyright 2019 dYdX Trading Inc.
1023     Copyright 2020 Elastic Network, based on the work of Empty Set Squad and Dynamic Dollar Devs <elasticnetwork@protonmail.com>
1024 
1025     Licensed under the Apache License, Version 2.0 (the "License");
1026     you may not use this file except in compliance with the License.
1027     You may obtain a copy of the License at
1028 
1029     http://www.apache.org/licenses/LICENSE-2.0
1030 
1031     Unless required by applicable law or agreed to in writing, software
1032     distributed under the License is distributed on an "AS IS" BASIS,
1033     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1034     See the License for the specific language governing permissions and
1035     limitations under the License.
1036 */
1037 /**
1038  * @title Decimal
1039  * @author dYdX
1040  *
1041  * Library that defines a fixed-point number with 18 decimal places.
1042  */
1043 library Decimal {
1044     using SafeMath for uint256;
1045 
1046     // ============ Constants ============
1047 
1048     uint256 constant BASE = 10**18;
1049 
1050     // ============ Structs ============
1051 
1052 
1053     struct D256 {
1054         uint256 value;
1055     }
1056 
1057     // ============ Static Functions ============
1058 
1059     function zero()
1060     internal
1061     pure
1062     returns (D256 memory)
1063     {
1064         return D256({ value: 0 });
1065     }
1066 
1067     function one()
1068     internal
1069     pure
1070     returns (D256 memory)
1071     {
1072         return D256({ value: BASE });
1073     }
1074 
1075     function from(
1076         uint256 a
1077     )
1078     internal
1079     pure
1080     returns (D256 memory)
1081     {
1082         return D256({ value: a.mul(BASE) });
1083     }
1084 
1085     function ratio(
1086         uint256 a,
1087         uint256 b
1088     )
1089     internal
1090     pure
1091     returns (D256 memory)
1092     {
1093         return D256({ value: getPartial(a, BASE, b) });
1094     }
1095 
1096     // ============ Self Functions ============
1097 
1098     function add(
1099         D256 memory self,
1100         uint256 b
1101     )
1102     internal
1103     pure
1104     returns (D256 memory)
1105     {
1106         return D256({ value: self.value.add(b.mul(BASE)) });
1107     }
1108 
1109     function sub(
1110         D256 memory self,
1111         uint256 b
1112     )
1113     internal
1114     pure
1115     returns (D256 memory)
1116     {
1117         return D256({ value: self.value.sub(b.mul(BASE)) });
1118     }
1119 
1120     function sub(
1121         D256 memory self,
1122         uint256 b,
1123         string memory reason
1124     )
1125     internal
1126     pure
1127     returns (D256 memory)
1128     {
1129         return D256({ value: self.value.sub(b.mul(BASE), reason) });
1130     }
1131 
1132     function mul(
1133         D256 memory self,
1134         uint256 b
1135     )
1136     internal
1137     pure
1138     returns (D256 memory)
1139     {
1140         return D256({ value: self.value.mul(b) });
1141     }
1142 
1143     function div(
1144         D256 memory self,
1145         uint256 b
1146     )
1147     internal
1148     pure
1149     returns (D256 memory)
1150     {
1151         return D256({ value: self.value.div(b) });
1152     }
1153 
1154     function pow(
1155         D256 memory self,
1156         uint256 b
1157     )
1158     internal
1159     pure
1160     returns (D256 memory)
1161     {
1162         if (b == 0) {
1163             return from(1);
1164         }
1165 
1166         D256 memory temp = D256({ value: self.value });
1167         for (uint256 i = 1; i < b; i++) {
1168             temp = mul(temp, self);
1169         }
1170 
1171         return temp;
1172     }
1173 
1174     function add(
1175         D256 memory self,
1176         D256 memory b
1177     )
1178     internal
1179     pure
1180     returns (D256 memory)
1181     {
1182         return D256({ value: self.value.add(b.value) });
1183     }
1184 
1185     function sub(
1186         D256 memory self,
1187         D256 memory b
1188     )
1189     internal
1190     pure
1191     returns (D256 memory)
1192     {
1193         return D256({ value: self.value.sub(b.value) });
1194     }
1195 
1196     function sub(
1197         D256 memory self,
1198         D256 memory b,
1199         string memory reason
1200     )
1201     internal
1202     pure
1203     returns (D256 memory)
1204     {
1205         return D256({ value: self.value.sub(b.value, reason) });
1206     }
1207 
1208     function mul(
1209         D256 memory self,
1210         D256 memory b
1211     )
1212     internal
1213     pure
1214     returns (D256 memory)
1215     {
1216         return D256({ value: getPartial(self.value, b.value, BASE) });
1217     }
1218 
1219     function div(
1220         D256 memory self,
1221         D256 memory b
1222     )
1223     internal
1224     pure
1225     returns (D256 memory)
1226     {
1227         return D256({ value: getPartial(self.value, BASE, b.value) });
1228     }
1229 
1230     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
1231         return self.value == b.value;
1232     }
1233 
1234     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1235         return compareTo(self, b) == 2;
1236     }
1237 
1238     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1239         return compareTo(self, b) == 0;
1240     }
1241 
1242     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1243         return compareTo(self, b) > 0;
1244     }
1245 
1246     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1247         return compareTo(self, b) < 2;
1248     }
1249 
1250     function isZero(D256 memory self) internal pure returns (bool) {
1251         return self.value == 0;
1252     }
1253 
1254     function asUint256(D256 memory self) internal pure returns (uint256) {
1255         return self.value.div(BASE);
1256     }
1257 
1258     // ============ Core Methods ============
1259 
1260     function getPartial(
1261         uint256 target,
1262         uint256 numerator,
1263         uint256 denominator
1264     )
1265     private
1266     pure
1267     returns (uint256)
1268     {
1269         return target.mul(numerator).div(denominator);
1270     }
1271 
1272     function compareTo(
1273         D256 memory a,
1274         D256 memory b
1275     )
1276     private
1277     pure
1278     returns (uint256)
1279     {
1280         if (a.value == b.value) {
1281             return 1;
1282         }
1283         return a.value > b.value ? 2 : 0;
1284     }
1285 }
1286 
1287 /*
1288     Copyright 2020 Elastic Network, based on the work of Empty Set Squad and Dynamic Dollar Devs <elasticnetwork@protonmail.com>
1289 
1290     Licensed under the Apache License, Version 2.0 (the "License");
1291     you may not use this file except in compliance with the License.
1292     You may obtain a copy of the License at
1293 
1294     http://www.apache.org/licenses/LICENSE-2.0
1295 
1296     Unless required by applicable law or agreed to in writing, software
1297     distributed under the License is distributed on an "AS IS" BASIS,
1298     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1299     See the License for the specific language governing permissions and
1300     limitations under the License.
1301 */
1302 library Constants {
1303     /* Chain */
1304     uint256 private constant CHAIN_ID = 1; // Development - 1337, Rinkeby - 4, Mainnet - 1
1305 
1306     /* Bootstrapping */
1307     uint256 private constant BOOTSTRAPPING_PERIOD = 90;
1308     uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // 10% higher
1309     uint256 private constant BOOTSTRAPPING_POOL_REWARD = 100000e18; // 100k eEUR
1310 
1311 
1312     /* Oracle */
1313     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); // mainnet
1314     uint256 private constant ORACLE_RESERVE_MINIMUM = 10000e6; // 10,000 USDC
1315 
1316     /* Bonding */
1317     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 eEUR -> 100M eEURS
1318 
1319     /* Epoch */
1320     struct EpochStrategy {
1321         uint256 offset;
1322         uint256 start;
1323         uint256 period;
1324     }
1325 
1326     uint256 private constant EPOCH_OFFSET = 0;
1327     uint256 private constant EPOCH_START = 1610812800;
1328     uint256 private constant EPOCH_PERIOD = 28800;
1329 
1330     /* Governance */
1331     uint256 private constant GOVERNANCE_PERIOD = 9; // 9 epochs
1332     uint256 private constant GOVERNANCE_EXPIRATION = 2; // 2 + 1 epochs
1333     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
1334     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
1335     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
1336     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
1337 
1338     /* DAO */
1339     uint256 private constant ADVANCE_INCENTIVE = 100e18; // 100 eEUR
1340     uint256 private constant LOW_ADVANCE_INCENTIVE = 10e18; // 10 eEUR
1341     uint256 private constant LOW_ADVANCE_REWARDS_PERIOD = 21; // low rewards for a week
1342     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 15; // 15 epochs fluid
1343 
1344     /* Pool */
1345     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 5; // 5 epochs fluid
1346 
1347     /* Market */
1348     uint256 private constant COUPON_EXPIRATION = 90;
1349     uint256 private constant DEBT_RATIO_CAP = 15e16; // 15%
1350     uint256 private constant INITIAL_COUPON_REDEMPTION_PENALTY = 50e16; // 50%
1351     uint256 private constant COUPON_REDEMPTION_PENALTY_DECAY = 3600; // 1 hour
1352 
1353     /* Regulator */
1354     uint256 private constant SUPPLY_CHANGE_LIMIT = 3e16; // 3%
1355     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%
1356     uint256 private constant ORACLE_POOL_RATIO = 20; // 20%
1357 
1358     uint256 private constant TREASURY_RATIO = 250; // 2.5%
1359 
1360     /* Deployed */
1361     //TODO(laireht): Uncomment and replace with new addresses after first deployment
1362     //    address private constant DAO_ADDRESS = address(0);
1363     //    address private constant DOLLAR_ADDRESS = address(0);
1364     //    address private constant PAIR_ADDRESS = address(0);
1365 
1366     /**
1367      * Getters
1368      */
1369 
1370     function getUsdcAddress() internal pure returns (address) {
1371         return USDC;
1372     }
1373 
1374     function getOracleReserveMinimum() internal pure returns (uint256) {
1375         return ORACLE_RESERVE_MINIMUM;
1376     }
1377 
1378     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
1379         return EpochStrategy({
1380         offset : EPOCH_OFFSET,
1381         start : EPOCH_START,
1382         period : EPOCH_PERIOD
1383         });
1384     }
1385 
1386     function getEpochPeriod() internal pure returns (uint256) {
1387         return EPOCH_PERIOD;
1388     }
1389 
1390     function getInitialStakeMultiple() internal pure returns (uint256) {
1391         return INITIAL_STAKE_MULTIPLE;
1392     }
1393 
1394     function getBootstrappingPeriod() internal pure returns (uint256) {
1395         return BOOTSTRAPPING_PERIOD;
1396     }
1397 
1398     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1399         return Decimal.D256({value : BOOTSTRAPPING_PRICE});
1400     }
1401 
1402     function getBootstrappingPoolReward() internal pure returns (uint256) {
1403         return BOOTSTRAPPING_POOL_REWARD;
1404     }
1405 
1406     function getGovernancePeriod() internal pure returns (uint256) {
1407         return GOVERNANCE_PERIOD;
1408     }
1409 
1410     function getGovernanceExpiration() internal pure returns (uint256) {
1411         return GOVERNANCE_EXPIRATION;
1412     }
1413 
1414     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1415         return Decimal.D256({value : GOVERNANCE_QUORUM});
1416     }
1417 
1418     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
1419         return Decimal.D256({value : GOVERNANCE_PROPOSAL_THRESHOLD});
1420     }
1421 
1422     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1423         return Decimal.D256({value : GOVERNANCE_SUPER_MAJORITY});
1424     }
1425 
1426     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1427         return GOVERNANCE_EMERGENCY_DELAY;
1428     }
1429 
1430     function getAdvanceIncentive() internal pure returns (uint256) {
1431         return ADVANCE_INCENTIVE;
1432     }
1433 
1434     function getLowAdvanceIncentive() internal pure returns (uint256) {
1435         return LOW_ADVANCE_INCENTIVE;
1436     }
1437 
1438     function getLowAdvanceRewardsPeriod()  internal pure returns (uint256) {
1439         return LOW_ADVANCE_REWARDS_PERIOD;
1440     }
1441 
1442     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1443         return DAO_EXIT_LOCKUP_EPOCHS;
1444     }
1445 
1446     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1447         return POOL_EXIT_LOCKUP_EPOCHS;
1448     }
1449 
1450     function getCouponExpiration() internal pure returns (uint256) {
1451         return COUPON_EXPIRATION;
1452     }
1453 
1454     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1455         return Decimal.D256({value : DEBT_RATIO_CAP});
1456     }
1457 
1458     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1459         return Decimal.D256({value : SUPPLY_CHANGE_LIMIT});
1460     }
1461 
1462     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1463         return Decimal.D256({value : COUPON_SUPPLY_CHANGE_LIMIT});
1464     }
1465 
1466     function getOraclePoolRatio() internal pure returns (uint256) {
1467         return ORACLE_POOL_RATIO;
1468     }
1469 
1470     function getTreasuryRatio() internal pure returns (uint256) {
1471         return TREASURY_RATIO;
1472     }
1473 
1474     function getChainId() internal pure returns (uint256) {
1475         return CHAIN_ID;
1476     }
1477 
1478     function getInitialCouponRedemptionPenalty() internal pure returns (Decimal.D256 memory) {
1479         return Decimal.D256({value : INITIAL_COUPON_REDEMPTION_PENALTY});
1480     }
1481 
1482     function getCouponRedemptionPenaltyDecay() internal pure returns (uint256) {
1483         return COUPON_REDEMPTION_PENALTY_DECAY;
1484     }
1485 
1486 
1487 
1488     //    function getDaoAddress() internal pure returns (address) {
1489     //        return DAO_ADDRESS;
1490     //    }
1491     //
1492     //    function getDollarAddress() internal pure returns (address) {
1493     //        return DOLLAR_ADDRESS;
1494     //    }
1495     //
1496     //    function getPairAddress() internal pure returns (address) {
1497     //        return PAIR_ADDRESS;
1498     //    }
1499     //
1500 }
1501 
1502 interface IStakingRewards {
1503     // Views
1504     function lastTimeRewardApplicable() external view returns (uint256);
1505 
1506     function rewardPerToken() external view returns (uint256);
1507 
1508     function earned(address account) external view returns (uint256);
1509 
1510     function getRewardForDuration() external view returns (uint256);
1511 
1512     function totalSupply() external view returns (uint256);
1513 
1514     function balanceOf(address account) external view returns (uint256);
1515 
1516     // Mutative
1517 
1518     function stake(uint256 amount) external;
1519 
1520     function withdraw(uint256 amount) external;
1521 
1522     function getReward() external;
1523 
1524     function exit() external;
1525 }
1526 
1527 // Inheritance
1528 contract StakingRewards is IStakingRewards, ReentrancyGuard {
1529     bytes32 private constant FILE = "BootstrapPool";
1530 
1531     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1532     using SafeMath for uint256;
1533     using SafeERC20 for IERC20;
1534 
1535     /* ========== STATE VARIABLES ========== */
1536     address internal dao;
1537 
1538     IERC20 public rewardsToken;
1539     IERC20 public stakingToken;
1540     uint256 public periodFinish = 0;
1541     uint256 public rewardRate = 0;
1542     uint256 public rewardsDuration = 30 days;
1543     uint256 public lastUpdateTime;
1544     uint256 public rewardPerTokenStored;
1545 
1546     mapping(address => uint256) public userRewardPerTokenPaid;
1547     mapping(address => uint256) public rewards;
1548 
1549     uint256 private _totalSupply;
1550     mapping(address => uint256) private _balances;
1551 
1552     /* ========== CONSTRUCTOR ========== */
1553 
1554     constructor(
1555         address _rewardsToken,
1556         address _stakingToken
1557     ) public {
1558         rewardsToken = IERC20(_rewardsToken);
1559         stakingToken = IERC20(_stakingToken);
1560         dao = msg.sender;
1561     }
1562 
1563     /* ========== VIEWS ========== */
1564 
1565     function totalSupply() external view returns (uint256) {
1566         return _totalSupply;
1567     }
1568 
1569     function balanceOf(address account) external view returns (uint256) {
1570         return _balances[account];
1571     }
1572 
1573     function lastTimeRewardApplicable() public view returns (uint256) {
1574         return Math.min(block.timestamp, periodFinish);
1575     }
1576 
1577     function rewardPerToken() public view returns (uint256) {
1578         if (_totalSupply == 0) {
1579             return rewardPerTokenStored;
1580         }
1581         return
1582         rewardPerTokenStored.add(
1583             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
1584         );
1585     }
1586 
1587     function earned(address account) public view returns (uint256) {
1588         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
1589     }
1590 
1591     function paid(address account) public view returns (uint256) {
1592         return userRewardPerTokenPaid[account];
1593     }
1594 
1595     function getRewardForDuration() external view returns (uint256) {
1596         return rewardRate.mul(rewardsDuration);
1597     }
1598 
1599     /* ========== MUTATIVE FUNCTIONS ========== */
1600 
1601     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
1602         require(amount > 0, "Cannot stake 0");
1603         _totalSupply = _totalSupply.add(amount);
1604         _balances[msg.sender] = _balances[msg.sender].add(amount);
1605 
1606         // permit
1607         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
1608 
1609         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1610         emit Staked(msg.sender, amount);
1611     }
1612 
1613     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
1614         require(amount > 0, "Cannot stake 0");
1615         _totalSupply = _totalSupply.add(amount);
1616         _balances[msg.sender] = _balances[msg.sender].add(amount);
1617         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1618         emit Staked(msg.sender, amount);
1619     }
1620 
1621     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
1622         require(amount > 0, "Cannot withdraw 0");
1623         _totalSupply = _totalSupply.sub(amount);
1624         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1625         stakingToken.safeTransfer(msg.sender, amount);
1626         emit Withdrawn(msg.sender, amount);
1627     }
1628 
1629     function getReward() public nonReentrant updateReward(msg.sender) {
1630         uint256 reward = rewards[msg.sender];
1631         if (reward > 0) {
1632             rewards[msg.sender] = 0;
1633             rewardsToken.safeTransfer(msg.sender, reward);
1634             emit RewardPaid(msg.sender, reward);
1635         }
1636     }
1637 
1638     function exit() external {
1639         withdraw(_balances[msg.sender]);
1640         getReward();
1641     }
1642 
1643     function usdc() public view returns (address) {
1644         return Constants.getUsdcAddress();
1645     }
1646     /* ========== RESTRICTED FUNCTIONS ========== */
1647 
1648     function notifyRewardAmount(uint256 reward) external onlyDao updateReward(address(0)) {
1649         // Ensure the provided reward amount is not more than the balance in the contract.
1650         // This keeps the reward rate in the right range, preventing overflows due to
1651         // very high values of rewardRate in the earned and rewardsPerToken functions;
1652         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1653 
1654         if (block.timestamp >= periodFinish) {
1655             rewardRate = reward.div(rewardsDuration);
1656             uint balance = rewardsToken.balanceOf(address(this));
1657             require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
1658 
1659             lastUpdateTime = block.timestamp;
1660             periodFinish = block.timestamp.add(rewardsDuration);
1661         } else {
1662             uint256 remaining = periodFinish.sub(block.timestamp);
1663             uint256 leftover = remaining.mul(rewardRate);
1664             rewardRate = reward.add(leftover).div(remaining);
1665 
1666             uint balance = rewardsToken.balanceOf(address(this));
1667             require(rewardRate <= balance.div(remaining), "Provided reward too high");
1668         }
1669 
1670         emit RewardAdded(reward);
1671     }
1672 
1673     /* ========== MODIFIERS ========== */
1674 
1675     modifier updateReward(address account) {
1676         rewardPerTokenStored = rewardPerToken();
1677         lastUpdateTime = lastTimeRewardApplicable();
1678         if (account != address(0)) {
1679             rewards[account] = earned(account);
1680             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1681         }
1682         _;
1683     }
1684 
1685     modifier onlyDao() {
1686         Require.that(
1687             msg.sender == dao,
1688             FILE,
1689             "Not dao"
1690         );
1691 
1692         _;
1693     }
1694 
1695     /* ========== EVENTS ========== */
1696 
1697     event RewardAdded(uint256 reward);
1698     event Staked(address indexed user, uint256 amount);
1699     event Withdrawn(address indexed user, uint256 amount);
1700     event RewardPaid(address indexed user, uint256 reward);
1701 }
1702 
1703 interface IUniswapV2ERC20 {
1704     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1705 }