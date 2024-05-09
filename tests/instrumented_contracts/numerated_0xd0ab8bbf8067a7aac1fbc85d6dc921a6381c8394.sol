1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.4;
4 
5 
6 
7 // Part: IUniswapV2Pair
8 
9 interface IUniswapV2Pair {
10     event Approval(address indexed owner, address indexed spender, uint value);
11     event Transfer(address indexed from, address indexed to, uint value);
12 
13     function name() external pure returns (string memory);
14     function symbol() external pure returns (string memory);
15     function decimals() external pure returns (uint8);
16     function totalSupply() external view returns (uint);
17     function balanceOf(address owner) external view returns (uint);
18     function allowance(address owner, address spender) external view returns (uint);
19 
20     function approve(address spender, uint value) external returns (bool);
21     function transfer(address to, uint value) external returns (bool);
22     function transferFrom(address from, address to, uint value) external returns (bool);
23 
24     function DOMAIN_SEPARATOR() external view returns (bytes32);
25     function PERMIT_TYPEHASH() external pure returns (bytes32);
26     function nonces(address owner) external view returns (uint);
27 
28     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
29 
30     event Mint(address indexed sender, uint amount0, uint amount1);
31     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
32     event Swap(
33         address indexed sender,
34         uint amount0In,
35         uint amount1In,
36         uint amount0Out,
37         uint amount1Out,
38         address indexed to
39     );
40     event Sync(uint112 reserve0, uint112 reserve1);
41 
42     function MINIMUM_LIQUIDITY() external pure returns (uint);
43     function factory() external view returns (address);
44     function token0() external view returns (address);
45     function token1() external view returns (address);
46     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
47     function price0CumulativeLast() external view returns (uint);
48     function price1CumulativeLast() external view returns (uint);
49     function kLast() external view returns (uint);
50 
51     function mint(address to) external returns (uint liquidity);
52     function burn(address to) external returns (uint amount0, uint amount1);
53     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
54     function skim(address to) external;
55     function sync() external;
56 
57     function initialize(address, address) external;
58 }
59 
60 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Address
61 
62 /**
63  * @dev Collection of functions related to the address type
64  */
65 library Address {
66     /**
67      * @dev Returns true if `account` is a contract.
68      *
69      * [IMPORTANT]
70      * ====
71      * It is unsafe to assume that an address for which this function returns
72      * false is an externally-owned account (EOA) and not a contract.
73      *
74      * Among others, `isContract` will return false for the following
75      * types of addresses:
76      *
77      *  - an externally-owned account
78      *  - a contract in construction
79      *  - an address where a contract will be created
80      *  - an address where a contract lived, but was destroyed
81      * ====
82      */
83     function isContract(address account) internal view returns (bool) {
84         // This method relies on extcodesize, which returns 0 for contracts in
85         // construction, since the code is only stored at the end of the
86         // constructor execution.
87 
88         uint256 size;
89         // solhint-disable-next-line no-inline-assembly
90         assembly { size := extcodesize(account) }
91         return size > 0;
92     }
93 
94     /**
95      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
96      * `recipient`, forwarding all available gas and reverting on errors.
97      *
98      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
99      * of certain opcodes, possibly making contracts go over the 2300 gas limit
100      * imposed by `transfer`, making them unable to receive funds via
101      * `transfer`. {sendValue} removes this limitation.
102      *
103      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
104      *
105      * IMPORTANT: because control is transferred to `recipient`, care must be
106      * taken to not create reentrancy vulnerabilities. Consider using
107      * {ReentrancyGuard} or the
108      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
109      */
110     function sendValue(address payable recipient, uint256 amount) internal {
111         require(address(this).balance >= amount, "Address: insufficient balance");
112 
113         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
114         (bool success, ) = recipient.call{ value: amount }("");
115         require(success, "Address: unable to send value, recipient may have reverted");
116     }
117 
118     /**
119      * @dev Performs a Solidity function call using a low level `call`. A
120      * plain`call` is an unsafe replacement for a function call: use this
121      * function instead.
122      *
123      * If `target` reverts with a revert reason, it is bubbled up by this
124      * function (like regular Solidity function calls).
125      *
126      * Returns the raw returned data. To convert to the expected return value,
127      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
128      *
129      * Requirements:
130      *
131      * - `target` must be a contract.
132      * - calling `target` with `data` must not revert.
133      *
134      * _Available since v3.1._
135      */
136     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
137       return functionCall(target, data, "Address: low-level call failed");
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
142      * `errorMessage` as a fallback revert reason when `target` reverts.
143      *
144      * _Available since v3.1._
145      */
146     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
147         return functionCallWithValue(target, data, 0, errorMessage);
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
152      * but also transferring `value` wei to `target`.
153      *
154      * Requirements:
155      *
156      * - the calling contract must have an ETH balance of at least `value`.
157      * - the called Solidity function must be `payable`.
158      *
159      * _Available since v3.1._
160      */
161     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
162         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
167      * with `errorMessage` as a fallback revert reason when `target` reverts.
168      *
169      * _Available since v3.1._
170      */
171     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
172         require(address(this).balance >= value, "Address: insufficient balance for call");
173         require(isContract(target), "Address: call to non-contract");
174 
175         // solhint-disable-next-line avoid-low-level-calls
176         (bool success, bytes memory returndata) = target.call{ value: value }(data);
177         return _verifyCallResult(success, returndata, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but performing a static call.
183      *
184      * _Available since v3.3._
185      */
186     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
187         return functionStaticCall(target, data, "Address: low-level static call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
192      * but performing a static call.
193      *
194      * _Available since v3.3._
195      */
196     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
197         require(isContract(target), "Address: static call to non-contract");
198 
199         // solhint-disable-next-line avoid-low-level-calls
200         (bool success, bytes memory returndata) = target.staticcall(data);
201         return _verifyCallResult(success, returndata, errorMessage);
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
206      * but performing a delegate call.
207      *
208      * _Available since v3.4._
209      */
210     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
211         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
216      * but performing a delegate call.
217      *
218      * _Available since v3.4._
219      */
220     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
221         require(isContract(target), "Address: delegate call to non-contract");
222 
223         // solhint-disable-next-line avoid-low-level-calls
224         (bool success, bytes memory returndata) = target.delegatecall(data);
225         return _verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
229         if (success) {
230             return returndata;
231         } else {
232             // Look for revert reason and bubble it up if present
233             if (returndata.length > 0) {
234                 // The easiest way to bubble the revert reason is using memory via assembly
235 
236                 // solhint-disable-next-line no-inline-assembly
237                 assembly {
238                     let returndata_size := mload(returndata)
239                     revert(add(32, returndata), returndata_size)
240                 }
241             } else {
242                 revert(errorMessage);
243             }
244         }
245     }
246 }
247 
248 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Context
249 
250 /*
251  * @dev Provides information about the current execution context, including the
252  * sender of the transaction and its data. While these are generally available
253  * via msg.sender and msg.data, they should not be accessed in such a direct
254  * manner, since when dealing with GSN meta-transactions the account sending and
255  * paying for execution may not be the actual sender (as far as an application
256  * is concerned).
257  *
258  * This contract is only required for intermediate, library-like contracts.
259  */
260 abstract contract Context {
261     function _msgSender() internal view virtual returns (address payable) {
262         return msg.sender;
263     }
264 
265     function _msgData() internal view virtual returns (bytes memory) {
266         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
267         return msg.data;
268     }
269 }
270 
271 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC20
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
347 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Math
348 
349 /**
350  * @dev Standard math utilities missing in the Solidity language.
351  */
352 library Math {
353     /**
354      * @dev Returns the largest of two numbers.
355      */
356     function max(uint256 a, uint256 b) internal pure returns (uint256) {
357         return a >= b ? a : b;
358     }
359 
360     /**
361      * @dev Returns the smallest of two numbers.
362      */
363     function min(uint256 a, uint256 b) internal pure returns (uint256) {
364         return a < b ? a : b;
365     }
366 
367     /**
368      * @dev Returns the average of two numbers. The result is rounded towards
369      * zero.
370      */
371     function average(uint256 a, uint256 b) internal pure returns (uint256) {
372         // (a + b) / 2 can overflow, so we distribute
373         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
374     }
375 }
376 
377 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/SafeMath
378 
379 /**
380  * @dev Wrappers over Solidity's arithmetic operations with added overflow
381  * checks.
382  *
383  * Arithmetic operations in Solidity wrap on overflow. This can easily result
384  * in bugs, because programmers usually assume that an overflow raises an
385  * error, which is the standard behavior in high level programming languages.
386  * `SafeMath` restores this intuition by reverting the transaction when an
387  * operation overflows.
388  *
389  * Using this library instead of the unchecked operations eliminates an entire
390  * class of bugs, so it's recommended to use it always.
391  */
392 library SafeMath {
393     /**
394      * @dev Returns the addition of two unsigned integers, with an overflow flag.
395      *
396      * _Available since v3.4._
397      */
398     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
399         uint256 c = a + b;
400         if (c < a) return (false, 0);
401         return (true, c);
402     }
403 
404     /**
405      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
406      *
407      * _Available since v3.4._
408      */
409     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
410         if (b > a) return (false, 0);
411         return (true, a - b);
412     }
413 
414     /**
415      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
416      *
417      * _Available since v3.4._
418      */
419     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
420         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
421         // benefit is lost if 'b' is also tested.
422         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
423         if (a == 0) return (true, 0);
424         uint256 c = a * b;
425         if (c / a != b) return (false, 0);
426         return (true, c);
427     }
428 
429     /**
430      * @dev Returns the division of two unsigned integers, with a division by zero flag.
431      *
432      * _Available since v3.4._
433      */
434     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
435         if (b == 0) return (false, 0);
436         return (true, a / b);
437     }
438 
439     /**
440      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
441      *
442      * _Available since v3.4._
443      */
444     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
445         if (b == 0) return (false, 0);
446         return (true, a % b);
447     }
448 
449     /**
450      * @dev Returns the addition of two unsigned integers, reverting on
451      * overflow.
452      *
453      * Counterpart to Solidity's `+` operator.
454      *
455      * Requirements:
456      *
457      * - Addition cannot overflow.
458      */
459     function add(uint256 a, uint256 b) internal pure returns (uint256) {
460         uint256 c = a + b;
461         require(c >= a, "SafeMath: addition overflow");
462         return c;
463     }
464 
465     /**
466      * @dev Returns the subtraction of two unsigned integers, reverting on
467      * overflow (when the result is negative).
468      *
469      * Counterpart to Solidity's `-` operator.
470      *
471      * Requirements:
472      *
473      * - Subtraction cannot overflow.
474      */
475     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
476         require(b <= a, "SafeMath: subtraction overflow");
477         return a - b;
478     }
479 
480     /**
481      * @dev Returns the multiplication of two unsigned integers, reverting on
482      * overflow.
483      *
484      * Counterpart to Solidity's `*` operator.
485      *
486      * Requirements:
487      *
488      * - Multiplication cannot overflow.
489      */
490     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
491         if (a == 0) return 0;
492         uint256 c = a * b;
493         require(c / a == b, "SafeMath: multiplication overflow");
494         return c;
495     }
496 
497     /**
498      * @dev Returns the integer division of two unsigned integers, reverting on
499      * division by zero. The result is rounded towards zero.
500      *
501      * Counterpart to Solidity's `/` operator. Note: this function uses a
502      * `revert` opcode (which leaves remaining gas untouched) while Solidity
503      * uses an invalid opcode to revert (consuming all remaining gas).
504      *
505      * Requirements:
506      *
507      * - The divisor cannot be zero.
508      */
509     function div(uint256 a, uint256 b) internal pure returns (uint256) {
510         require(b > 0, "SafeMath: division by zero");
511         return a / b;
512     }
513 
514     /**
515      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
516      * reverting when dividing by zero.
517      *
518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
519      * opcode (which leaves remaining gas untouched) while Solidity uses an
520      * invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
527         require(b > 0, "SafeMath: modulo by zero");
528         return a % b;
529     }
530 
531     /**
532      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
533      * overflow (when the result is negative).
534      *
535      * CAUTION: This function is deprecated because it requires allocating memory for the error
536      * message unnecessarily. For custom revert reasons use {trySub}.
537      *
538      * Counterpart to Solidity's `-` operator.
539      *
540      * Requirements:
541      *
542      * - Subtraction cannot overflow.
543      */
544     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
545         require(b <= a, errorMessage);
546         return a - b;
547     }
548 
549     /**
550      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
551      * division by zero. The result is rounded towards zero.
552      *
553      * CAUTION: This function is deprecated because it requires allocating memory for the error
554      * message unnecessarily. For custom revert reasons use {tryDiv}.
555      *
556      * Counterpart to Solidity's `/` operator. Note: this function uses a
557      * `revert` opcode (which leaves remaining gas untouched) while Solidity
558      * uses an invalid opcode to revert (consuming all remaining gas).
559      *
560      * Requirements:
561      *
562      * - The divisor cannot be zero.
563      */
564     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
565         require(b > 0, errorMessage);
566         return a / b;
567     }
568 
569     /**
570      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
571      * reverting with custom message when dividing by zero.
572      *
573      * CAUTION: This function is deprecated because it requires allocating memory for the error
574      * message unnecessarily. For custom revert reasons use {tryMod}.
575      *
576      * Counterpart to Solidity's `%` operator. This function uses a `revert`
577      * opcode (which leaves remaining gas untouched) while Solidity uses an
578      * invalid opcode to revert (consuming all remaining gas).
579      *
580      * Requirements:
581      *
582      * - The divisor cannot be zero.
583      */
584     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
585         require(b > 0, errorMessage);
586         return a % b;
587     }
588 }
589 
590 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Ownable
591 
592 /**
593  * @dev Contract module which provides a basic access control mechanism, where
594  * there is an account (an owner) that can be granted exclusive access to
595  * specific functions.
596  *
597  * By default, the owner account will be the one that deploys the contract. This
598  * can later be changed with {transferOwnership}.
599  *
600  * This module is used through inheritance. It will make available the modifier
601  * `onlyOwner`, which can be applied to your functions to restrict their use to
602  * the owner.
603  */
604 abstract contract Ownable is Context {
605     address private _owner;
606 
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608 
609     /**
610      * @dev Initializes the contract setting the deployer as the initial owner.
611      */
612     constructor () internal {
613         address msgSender = _msgSender();
614         _owner = msgSender;
615         emit OwnershipTransferred(address(0), msgSender);
616     }
617 
618     /**
619      * @dev Returns the address of the current owner.
620      */
621     function owner() public view virtual returns (address) {
622         return _owner;
623     }
624 
625     /**
626      * @dev Throws if called by any account other than the owner.
627      */
628     modifier onlyOwner() {
629         require(owner() == _msgSender(), "Ownable: caller is not the owner");
630         _;
631     }
632 
633     /**
634      * @dev Leaves the contract without owner. It will not be possible to call
635      * `onlyOwner` functions anymore. Can only be called by the current owner.
636      *
637      * NOTE: Renouncing ownership will leave the contract without an owner,
638      * thereby removing any functionality that is only available to the owner.
639      */
640     function renounceOwnership() public virtual onlyOwner {
641         emit OwnershipTransferred(_owner, address(0));
642         _owner = address(0);
643     }
644 
645     /**
646      * @dev Transfers ownership of the contract to a new account (`newOwner`).
647      * Can only be called by the current owner.
648      */
649     function transferOwnership(address newOwner) public virtual onlyOwner {
650         require(newOwner != address(0), "Ownable: new owner is the zero address");
651         emit OwnershipTransferred(_owner, newOwner);
652         _owner = newOwner;
653     }
654 }
655 
656 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/SafeERC20
657 
658 /**
659  * @title SafeERC20
660  * @dev Wrappers around ERC20 operations that throw on failure (when the token
661  * contract returns false). Tokens that return no value (and instead revert or
662  * throw on failure) are also supported, non-reverting calls are assumed to be
663  * successful.
664  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
665  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
666  */
667 library SafeERC20 {
668     using SafeMath for uint256;
669     using Address for address;
670 
671     function safeTransfer(IERC20 token, address to, uint256 value) internal {
672         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
673     }
674 
675     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
676         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
677     }
678 
679     /**
680      * @dev Deprecated. This function has issues similar to the ones found in
681      * {IERC20-approve}, and its usage is discouraged.
682      *
683      * Whenever possible, use {safeIncreaseAllowance} and
684      * {safeDecreaseAllowance} instead.
685      */
686     function safeApprove(IERC20 token, address spender, uint256 value) internal {
687         // safeApprove should only be called when setting an initial allowance,
688         // or when resetting it to zero. To increase and decrease it, use
689         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
690         // solhint-disable-next-line max-line-length
691         require((value == 0) || (token.allowance(address(this), spender) == 0),
692             "SafeERC20: approve from non-zero to non-zero allowance"
693         );
694         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
695     }
696 
697     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
698         uint256 newAllowance = token.allowance(address(this), spender).add(value);
699         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
700     }
701 
702     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
703         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
704         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
705     }
706 
707     /**
708      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
709      * on the return value: the return value is optional (but if data is returned, it must not be false).
710      * @param token The token targeted by the call.
711      * @param data The call data (encoded using abi.encode or one of its variants).
712      */
713     function _callOptionalReturn(IERC20 token, bytes memory data) private {
714         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
715         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
716         // the target address contains contract code and also asserts for success in the low-level call.
717 
718         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
719         if (returndata.length > 0) { // Return data is optional
720             // solhint-disable-next-line max-line-length
721             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
722         }
723     }
724 }
725 
726 // Part: LPTokenWrapper
727 
728 /**
729  * @dev this contract forked from
730  * https://github.com/Synthetixio/Unipool/blob/master/contracts/Unipool.sol
731  *
732 */
733 contract LPTokenWrapper {
734     using SafeMath for uint256;
735     using SafeERC20 for IERC20;
736 
737     IUniswapV2Pair public lptoken;
738 
739     uint256 private _totalSupply;
740     mapping(address => uint256) private _balances;
741 
742     constructor (IUniswapV2Pair token) {
743         lptoken = token;
744     }
745 
746     function totalSupply() public view returns (uint256) {
747         return _totalSupply;
748     }
749 
750     function balanceOf(address account) public view returns (uint256) {
751         return _balances[account];
752     }
753 
754     function stake(uint256 amount) virtual public {
755         _totalSupply = _totalSupply.add(amount);
756         _balances[msg.sender] = _balances[msg.sender].add(amount);
757         lptoken.transferFrom(msg.sender, address(this), amount);
758     }
759 
760     function withdraw(uint256 amount) virtual public {
761         _totalSupply = _totalSupply.sub(amount);
762         _balances[msg.sender] = _balances[msg.sender].sub(amount);
763         lptoken.transfer(msg.sender, amount);
764     }
765 }
766 
767 // File: DungCompost.sol
768 
769 contract DungCompost is LPTokenWrapper, Ownable {
770     using SafeMath for uint256;
771     using SafeERC20 for IERC20;
772 
773     IERC20 public dung;
774     uint256 public constant DURATION = 60 days;
775 
776     uint256 public periodFinish = 0;
777     uint256 public rewardRate = 0;
778     uint256 public lastUpdateTime;
779     uint256 public rewardPerTokenStored;
780 
781     mapping(address => uint256) public userRewardPerTokenPaid;
782     mapping(address => uint256) public rewards;
783 
784     event RewardAdded(uint256 reward);
785     event Staked(address indexed user, uint256 amount);
786     event Withdrawn(address indexed user, uint256 amount);
787     event RewardPaid(address indexed user, uint256 reward);
788     event Harvested(address indexed user);
789 
790     constructor (IERC20 _dung, IUniswapV2Pair _lptoken)
791         LPTokenWrapper(_lptoken)
792     {
793         dung  = _dung;
794     }
795 
796     modifier updateReward(address account) {
797         rewardPerTokenStored = rewardPerToken();
798         lastUpdateTime = lastTimeRewardApplicable();
799         if (account != address(0)) {
800             rewards[account] = earned(account);
801             userRewardPerTokenPaid[account] = rewardPerTokenStored;
802         }
803         _;
804     }
805 
806     function lastTimeRewardApplicable() public view returns (uint256) {
807         return Math.min(block.timestamp, periodFinish);
808     }
809 
810     function rewardPerToken() public view returns (uint256) {
811         if (totalSupply() == 0) {
812             return rewardPerTokenStored;
813         }
814         return
815             rewardPerTokenStored.add(
816                 lastTimeRewardApplicable()
817                 .sub(lastUpdateTime)
818                 .mul(rewardRate)
819                 .mul(1e18)
820                 .div(totalSupply())
821             );
822     }
823 
824     function earned(address account) public view returns (uint256) {
825         return
826             balanceOf(account)
827             .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
828             .div(1e18)
829             .add(rewards[account]);
830     }
831 
832     // stake visibility is public as overriding LPTokenWrapper's stake() function
833     function stake(uint256 amount) public override updateReward(msg.sender) {
834         require(amount > 0, "Cannot stake 0");
835         super.stake(amount);
836         emit Staked(msg.sender, amount);
837     }
838 
839     function withdraw(uint256 amount) public override updateReward(msg.sender) {
840         require(amount > 0, "Cannot withdraw 0");
841         super.withdraw(amount);
842         emit Withdrawn(msg.sender, amount);
843     }
844 
845     function exit() external {
846         withdraw(balanceOf(msg.sender));
847         getReward();
848     }
849 
850     function getReward() public {
851         _getReward();
852         emit Harvested(msg.sender);
853     }
854 
855     function _getReward() internal updateReward(msg.sender) {
856         uint256 reward = earned(msg.sender);
857         if (reward > 0) {
858             rewards[msg.sender] = 0;
859             dung.safeTransfer(msg.sender, reward);
860             emit RewardPaid(msg.sender, reward);
861         }
862     }
863 
864     function notifyRewardAmount(uint256 reward)
865         external
866         onlyOwner
867         updateReward(address(0))
868     {
869         if (block.timestamp >= periodFinish) {
870             rewardRate = reward.div(DURATION);
871         } else {
872             uint256 remaining = periodFinish.sub(block.timestamp);
873             uint256 leftover = remaining.mul(rewardRate);
874             rewardRate = reward.add(leftover).div(DURATION);
875         }
876         lastUpdateTime = block.timestamp;
877         periodFinish = block.timestamp.add(DURATION);
878         emit RewardAdded(reward);
879     }
880 
881     /**
882      * @dev returns calculated APY in current moment
883      *
884      * To get Human readable percent - divide result by 100.
885      * APY means how much DUNG you can earn, if you will stake
886      * LP tokens with total price of 1 DUNG if compost duration
887      * will be 1 year and there will no changes in DUNG price
888      * and staked LP token count.
889     */
890     function apy() external view returns (uint) {
891 
892         if (periodFinish < block.timestamp) {
893             // time is finished - no earnings
894             return 0;
895         }
896 
897         uint stakedLP = totalSupply();
898         if (stakedLP == 0) {
899             // no staked tokens - infinite APY
900             return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
901         }
902 
903         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = lptoken.getReserves();
904         uint256 totalSupplyLP = lptoken.totalSupply();
905 
906         uint DungPerLP; // 1 LP price in ETH currency
907         if (lptoken.token0() == address(dung)) {
908             DungPerLP = 2 ether * (uint256)(reserve0)/totalSupplyLP; // DUNG value + ETH value in 1 LP
909         } else {
910             DungPerLP = 2 ether * (uint256)(reserve1)/totalSupplyLP; // DUNG value + ETH value in 1 LP
911         }
912 
913         uint stakedLpInDung = stakedLP*DungPerLP / 1 ether; // total staked LP token count in DUNG currency
914 
915         uint earnedDungPerYear = rewardRate * 365 days; // total pool earns per year
916         uint earnerDungPerYearForStakedDung = 10000 * earnedDungPerYear / stakedLpInDung;
917 
918         return earnerDungPerYearForStakedDung;
919     }
920 
921 }
