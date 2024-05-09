1 // Sources flattened with hardhat v2.0.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
32 
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () internal {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 
101 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
102 
103 
104 pragma solidity >=0.6.0 <0.8.0;
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 
181 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
182 
183 
184 pragma solidity >=0.6.0 <0.8.0;
185 
186 /**
187  * @dev Wrappers over Solidity's arithmetic operations with added overflow
188  * checks.
189  *
190  * Arithmetic operations in Solidity wrap on overflow. This can easily result
191  * in bugs, because programmers usually assume that an overflow raises an
192  * error, which is the standard behavior in high level programming languages.
193  * `SafeMath` restores this intuition by reverting the transaction when an
194  * operation overflows.
195  *
196  * Using this library instead of the unchecked operations eliminates an entire
197  * class of bugs, so it's recommended to use it always.
198  */
199 library SafeMath {
200     /**
201      * @dev Returns the addition of two unsigned integers, with an overflow flag.
202      *
203      * _Available since v3.4._
204      */
205     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
206         uint256 c = a + b;
207         if (c < a) return (false, 0);
208         return (true, c);
209     }
210 
211     /**
212      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
213      *
214      * _Available since v3.4._
215      */
216     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
217         if (b > a) return (false, 0);
218         return (true, a - b);
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
223      *
224      * _Available since v3.4._
225      */
226     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
228         // benefit is lost if 'b' is also tested.
229         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
230         if (a == 0) return (true, 0);
231         uint256 c = a * b;
232         if (c / a != b) return (false, 0);
233         return (true, c);
234     }
235 
236     /**
237      * @dev Returns the division of two unsigned integers, with a division by zero flag.
238      *
239      * _Available since v3.4._
240      */
241     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         if (b == 0) return (false, 0);
243         return (true, a / b);
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
248      *
249      * _Available since v3.4._
250      */
251     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         if (b == 0) return (false, 0);
253         return (true, a % b);
254     }
255 
256     /**
257      * @dev Returns the addition of two unsigned integers, reverting on
258      * overflow.
259      *
260      * Counterpart to Solidity's `+` operator.
261      *
262      * Requirements:
263      *
264      * - Addition cannot overflow.
265      */
266     function add(uint256 a, uint256 b) internal pure returns (uint256) {
267         uint256 c = a + b;
268         require(c >= a, "SafeMath: addition overflow");
269         return c;
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting on
274      * overflow (when the result is negative).
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283         require(b <= a, "SafeMath: subtraction overflow");
284         return a - b;
285     }
286 
287     /**
288      * @dev Returns the multiplication of two unsigned integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `*` operator.
292      *
293      * Requirements:
294      *
295      * - Multiplication cannot overflow.
296      */
297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298         if (a == 0) return 0;
299         uint256 c = a * b;
300         require(c / a == b, "SafeMath: multiplication overflow");
301         return c;
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers, reverting on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function div(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b > 0, "SafeMath: division by zero");
318         return a / b;
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * reverting when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
334         require(b > 0, "SafeMath: modulo by zero");
335         return a % b;
336     }
337 
338     /**
339      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
340      * overflow (when the result is negative).
341      *
342      * CAUTION: This function is deprecated because it requires allocating memory for the error
343      * message unnecessarily. For custom revert reasons use {trySub}.
344      *
345      * Counterpart to Solidity's `-` operator.
346      *
347      * Requirements:
348      *
349      * - Subtraction cannot overflow.
350      */
351     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         require(b <= a, errorMessage);
353         return a - b;
354     }
355 
356     /**
357      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
358      * division by zero. The result is rounded towards zero.
359      *
360      * CAUTION: This function is deprecated because it requires allocating memory for the error
361      * message unnecessarily. For custom revert reasons use {tryDiv}.
362      *
363      * Counterpart to Solidity's `/` operator. Note: this function uses a
364      * `revert` opcode (which leaves remaining gas untouched) while Solidity
365      * uses an invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b > 0, errorMessage);
373         return a / b;
374     }
375 
376     /**
377      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
378      * reverting with custom message when dividing by zero.
379      *
380      * CAUTION: This function is deprecated because it requires allocating memory for the error
381      * message unnecessarily. For custom revert reasons use {tryMod}.
382      *
383      * Counterpart to Solidity's `%` operator. This function uses a `revert`
384      * opcode (which leaves remaining gas untouched) while Solidity uses an
385      * invalid opcode to revert (consuming all remaining gas).
386      *
387      * Requirements:
388      *
389      * - The divisor cannot be zero.
390      */
391     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
392         require(b > 0, errorMessage);
393         return a % b;
394     }
395 }
396 
397 
398 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
399 
400 
401 pragma solidity >=0.6.2 <0.8.0;
402 
403 /**
404  * @dev Collection of functions related to the address type
405  */
406 library Address {
407     /**
408      * @dev Returns true if `account` is a contract.
409      *
410      * [IMPORTANT]
411      * ====
412      * It is unsafe to assume that an address for which this function returns
413      * false is an externally-owned account (EOA) and not a contract.
414      *
415      * Among others, `isContract` will return false for the following
416      * types of addresses:
417      *
418      *  - an externally-owned account
419      *  - a contract in construction
420      *  - an address where a contract will be created
421      *  - an address where a contract lived, but was destroyed
422      * ====
423      */
424     function isContract(address account) internal view returns (bool) {
425         // This method relies on extcodesize, which returns 0 for contracts in
426         // construction, since the code is only stored at the end of the
427         // constructor execution.
428 
429         uint256 size;
430         // solhint-disable-next-line no-inline-assembly
431         assembly { size := extcodesize(account) }
432         return size > 0;
433     }
434 
435     /**
436      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
437      * `recipient`, forwarding all available gas and reverting on errors.
438      *
439      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
440      * of certain opcodes, possibly making contracts go over the 2300 gas limit
441      * imposed by `transfer`, making them unable to receive funds via
442      * `transfer`. {sendValue} removes this limitation.
443      *
444      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
445      *
446      * IMPORTANT: because control is transferred to `recipient`, care must be
447      * taken to not create reentrancy vulnerabilities. Consider using
448      * {ReentrancyGuard} or the
449      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
450      */
451     function sendValue(address payable recipient, uint256 amount) internal {
452         require(address(this).balance >= amount, "Address: insufficient balance");
453 
454         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
455         (bool success, ) = recipient.call{ value: amount }("");
456         require(success, "Address: unable to send value, recipient may have reverted");
457     }
458 
459     /**
460      * @dev Performs a Solidity function call using a low level `call`. A
461      * plain`call` is an unsafe replacement for a function call: use this
462      * function instead.
463      *
464      * If `target` reverts with a revert reason, it is bubbled up by this
465      * function (like regular Solidity function calls).
466      *
467      * Returns the raw returned data. To convert to the expected return value,
468      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
469      *
470      * Requirements:
471      *
472      * - `target` must be a contract.
473      * - calling `target` with `data` must not revert.
474      *
475      * _Available since v3.1._
476      */
477     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
478       return functionCall(target, data, "Address: low-level call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
483      * `errorMessage` as a fallback revert reason when `target` reverts.
484      *
485      * _Available since v3.1._
486      */
487     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
488         return functionCallWithValue(target, data, 0, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but also transferring `value` wei to `target`.
494      *
495      * Requirements:
496      *
497      * - the calling contract must have an ETH balance of at least `value`.
498      * - the called Solidity function must be `payable`.
499      *
500      * _Available since v3.1._
501      */
502     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
508      * with `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
513         require(address(this).balance >= value, "Address: insufficient balance for call");
514         require(isContract(target), "Address: call to non-contract");
515 
516         // solhint-disable-next-line avoid-low-level-calls
517         (bool success, bytes memory returndata) = target.call{ value: value }(data);
518         return _verifyCallResult(success, returndata, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but performing a static call.
524      *
525      * _Available since v3.3._
526      */
527     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
528         return functionStaticCall(target, data, "Address: low-level static call failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
533      * but performing a static call.
534      *
535      * _Available since v3.3._
536      */
537     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
538         require(isContract(target), "Address: static call to non-contract");
539 
540         // solhint-disable-next-line avoid-low-level-calls
541         (bool success, bytes memory returndata) = target.staticcall(data);
542         return _verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a delegate call.
548      *
549      * _Available since v3.4._
550      */
551     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
552         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
562         require(isContract(target), "Address: delegate call to non-contract");
563 
564         // solhint-disable-next-line avoid-low-level-calls
565         (bool success, bytes memory returndata) = target.delegatecall(data);
566         return _verifyCallResult(success, returndata, errorMessage);
567     }
568 
569     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
570         if (success) {
571             return returndata;
572         } else {
573             // Look for revert reason and bubble it up if present
574             if (returndata.length > 0) {
575                 // The easiest way to bubble the revert reason is using memory via assembly
576 
577                 // solhint-disable-next-line no-inline-assembly
578                 assembly {
579                     let returndata_size := mload(returndata)
580                     revert(add(32, returndata), returndata_size)
581                 }
582             } else {
583                 revert(errorMessage);
584             }
585         }
586     }
587 }
588 
589 
590 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
591 
592 
593 pragma solidity >=0.6.0 <0.8.0;
594 
595 
596 
597 /**
598  * @title SafeERC20
599  * @dev Wrappers around ERC20 operations that throw on failure (when the token
600  * contract returns false). Tokens that return no value (and instead revert or
601  * throw on failure) are also supported, non-reverting calls are assumed to be
602  * successful.
603  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
604  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
605  */
606 library SafeERC20 {
607     using SafeMath for uint256;
608     using Address for address;
609 
610     function safeTransfer(IERC20 token, address to, uint256 value) internal {
611         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
612     }
613 
614     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
615         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
616     }
617 
618     /**
619      * @dev Deprecated. This function has issues similar to the ones found in
620      * {IERC20-approve}, and its usage is discouraged.
621      *
622      * Whenever possible, use {safeIncreaseAllowance} and
623      * {safeDecreaseAllowance} instead.
624      */
625     function safeApprove(IERC20 token, address spender, uint256 value) internal {
626         // safeApprove should only be called when setting an initial allowance,
627         // or when resetting it to zero. To increase and decrease it, use
628         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
629         // solhint-disable-next-line max-line-length
630         require((value == 0) || (token.allowance(address(this), spender) == 0),
631             "SafeERC20: approve from non-zero to non-zero allowance"
632         );
633         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
634     }
635 
636     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
637         uint256 newAllowance = token.allowance(address(this), spender).add(value);
638         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
639     }
640 
641     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
642         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
643         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
644     }
645 
646     /**
647      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
648      * on the return value: the return value is optional (but if data is returned, it must not be false).
649      * @param token The token targeted by the call.
650      * @param data The call data (encoded using abi.encode or one of its variants).
651      */
652     function _callOptionalReturn(IERC20 token, bytes memory data) private {
653         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
654         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
655         // the target address contains contract code and also asserts for success in the low-level call.
656 
657         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
658         if (returndata.length > 0) { // Return data is optional
659             // solhint-disable-next-line max-line-length
660             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
661         }
662     }
663 }
664 
665 
666 // File contracts/HubCommon.sol
667 
668 pragma solidity 0.6.12;
669 pragma experimental ABIEncoderV2;
670 abstract contract AuthHub is Ownable {
671     using SafeERC20 for IERC20;
672     using Address for address;
673     using SafeMath for uint256;
674     // controller 合约地址
675     address public controller;
676     // 冶理地址
677     address public governance;
678     //自动触发收益匹配
679     bool public paused = false; 
680 
681     constructor() public {
682         governance = msg.sender;
683     }
684 
685     modifier notPause() {
686         require(paused == false, "Mining has been suspended");
687         _;
688     }
689 
690     function checkGovernance() virtual public view {
691         require(msg.sender == owner() || msg.sender == governance, 'not allow');
692     }
693 
694     function checkController() public view {
695         require(governance != address(0) && controller != address(0), 'not allow');
696         require( msg.sender == governance || msg.sender == controller, 'not allow');
697     }
698 
699     // 设置权限控制合约
700     function setGovernance(address _governance) public {
701         require(address(0) != _governance, "governance address is zero");
702         checkGovernance();
703         governance = _governance;
704     }
705 
706     function setController(address _controller) public {
707         require(_controller != address(0), "controller is the zero address");
708         checkGovernance();
709         controller = _controller;
710     }
711 
712     function setPause() public  {
713         require(msg.sender == owner() || msg.sender == governance, 'not allow');
714         paused = !paused;
715     }
716 
717     // 提现转任意erc20
718     function inCaseTokensGetStuck(address account, address _token, uint _amount) public  {
719         require(address(0) != account, "account address is zero");
720         checkGovernance();
721         IERC20(_token).safeTransfer(account, _amount);
722     }
723 }
724 
725 // Info of each user.
726 struct UserInfo {
727     // 用户本金
728     uint256 amount;     
729     // 用户负债
730     uint256 mdxDebt; 
731     // cow负债
732     uint cowDebt;
733     //用户最大收益 0 不限制
734     uint256 mdxProfit;
735     uint256 cowProfit;
736     //用户未提收益
737     uint256 mdxReward;
738     uint256 cowReward;
739 }
740 
741 // 每个池子的信息
742 struct PoolInfo {
743     // 用户质押币种
744     IERC20 token;     
745     // 上一次结算收益的块高    
746     uint256 lastRewardBlock;  
747     // 上一次结算的用户总收益占比
748     uint256 accMdxPerShare;  
749     // 上一次结算累计的mdx收益
750     uint256 accMdxShare;
751     // 所有用户质押总数量
752     uint256 totalAmount;    
753     // 所有用户质押总数量上限，0表示不限
754     uint256 totalAmountLimit; 
755     //cow 收益数据
756     uint256 accCowPerShare;
757     // cow累计收益
758     uint256 accCowShare;
759     //每个块奖励cow
760     uint256 blockCowReward;
761     //每个块奖励mdx
762     uint256 blockMdxReward;
763     // 预留备付金
764     uint256 earnLowerlimit;
765 }
766 
767 interface IERC20Full is IERC20 {
768     function decimals() external view returns (uint8);
769 }
770 
771 interface IHubPoolExtend {
772     function deposit(uint _pid, uint _amount, address user) external;
773     function withdraw(uint _pid, uint _amount, address user) external returns (uint);
774     function emergencyWithdraw(uint _pid, uint _amount, address user) external returns (uint);
775 }
776 
777 interface IStrategy {
778     function balanceOf() external view returns (uint);
779     function balanceOfToken(address token) external view returns (uint);
780     function paused() external returns(bool);
781     function want() external view returns (address, address);
782     function contain(address) external view returns (bool);
783     function deposit() external;
784     function withdraw(address, uint) external returns (uint);
785     function withdrawAll() external returns (uint);
786     function withdrawMDXReward() external returns (uint, uint);
787     function governance()external view returns (address) ;
788     function owner()external view returns (address) ;
789     function pid()external view returns (uint);
790     function strategyName() external view returns (string memory) ;
791     function burnNFTToken() external;
792     function mitNFTToken(uint24 fee, int24 tickLower, int24 tickUpper) external;
793     function mitNFTTokenWithPriceA(uint24 fee, uint priceLower, uint priceUpper) external;
794     function getAmount() external view returns (uint128, uint, uint);
795     function historyRewardA() external view returns (uint);
796     function historyRewardB() external view returns (uint);
797     function getPool() external view returns (address);
798     function positionManager() external view returns (address);
799 }
800 
801 
802 interface IHubPool {
803     function earn(address token) external;
804     function poolLength() external view returns (uint256);
805     function poolInfo(uint index) view external returns (PoolInfo memory);
806     function TokenOfPid(address token) view external returns (uint);
807     function controller() view external returns (address);
808     function governance() view external returns (address) ;
809     function owner()external view returns (address) ;
810     function getPoolId(address token) external view returns (uint256) ;
811     function pending(uint256 _pid, address _user) external view returns (uint256, uint256);
812     function pendingCow(uint256 _pid, address _user) external view returns (uint256);
813     function getMdxBlockReward(address token) external view returns (uint256);
814     function userInfo(uint pid, address user) external view returns (UserInfo memory);
815     function withdraw(address token, uint amount) external ;
816     function deposit(address token, uint amount) external ;
817     function available(address token) view external returns (uint);
818     function withdrawAll(address token) external;
819     function depositAll(address token) external;
820     function withdrawWithPid(uint256 pid, uint256 amount) external;
821     function getApy(address token) external view returns (uint256);
822     function getCowApy(address token) external view returns (uint256);
823     function userTotalCowProfit() external view returns (uint256);
824     function userTotalProfit() external view returns (uint256);
825     function getBlockReward (uint pid) external view returns (uint256, uint256);
826 }
827 
828 interface IController {
829     // 释放投资本金，用于提现 
830     function withdrawLp(address token, uint _amount) external;
831     // 触发投资
832     function earn(address token) external;
833     // 触发发收益
834     function withdrawPending(address token, address user, uint256 userPending, uint256 govPending) external;
835     // 获取策略
836     function strategyLength() external view returns (uint) ;
837     function strategieList(uint id) external view returns (address) ;
838     function governance() external view returns (address) ;
839     function mdxToken() external view returns (address) ;
840     function owner() external view returns (address) ;
841     function vaults() external view returns (address) ;
842     function rewardAccount() external view returns (address) ;
843     function sid(address _strategy) external view returns (uint);
844 }
845 
846 
847 // File contracts/HubPool.sol
848 
849 pragma solidity 0.6.12;
850 contract HubPool is AuthHub {
851     using SafeMath for uint256;
852     using SafeERC20 for IERC20;
853 
854     modifier checkToken(address token) {
855          require(token != address(0) && address(poolInfo[TokenOfPid[token]].token) == token, "token not exists");
856         _;
857     }
858 
859     // 池子信息列表
860     PoolInfo[] public poolInfo;
861     // token对应的 poolInfo索引
862     mapping(address => uint256) public TokenOfPid;
863     // 每个池子的用户数量
864     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
865 
866     // 扩展合约，预留
867     address public hupPoolExtend;
868 
869     constructor() public {
870         controller = address(0x4613e2eD453EbC8b7A03B071C5CE7Cb092499D6C);
871         governance =address(0x601e4b30bD70B78DC28dE9e663Dc8D2dC8323C87);
872     }
873 
874     // 设置扩展合约
875     function setHupPoolExtend(address _hupPoolExtend) external  {
876         checkGovernance();
877         hupPoolExtend = _hupPoolExtend;
878     }
879 
880     function poolLength() public view returns (uint256) {
881         return poolInfo.length;
882     } 
883 
884     function getPoolInfo(address token) internal view checkToken(token) returns(PoolInfo storage) {
885         return poolInfo[TokenOfPid[token]];
886     }
887 
888     function getPoolId(address token) public view checkToken(token) returns (uint256){
889         return TokenOfPid[token];
890     } 
891 
892     function getBlockReward (uint pid) public view returns (uint256, uint256) {
893         return (poolInfo[pid].blockMdxReward, poolInfo[pid].blockCowReward);
894     }
895 
896     function setTotalAmountLimit(address token, uint256 _limit) public  {
897         checkGovernance();
898         PoolInfo storage pool = getPoolInfo(token);
899         pool.totalAmountLimit = _limit;
900     }
901 
902     // 更新cow用户收益率
903     function setCowBlockReward(address token, uint256 _reward, bool _withUpdate) public {
904         checkGovernance();
905         PoolInfo storage pool = getPoolInfo(token);
906         if (_withUpdate) {
907             massUpdatePools();
908         }
909         pool.blockCowReward = _reward;
910     }
911 
912     // 更新cow用户收益率
913     function setMdxBlockReward(address token, uint256 _reward, bool _withUpdate) public {
914         checkGovernance();
915         PoolInfo storage pool = getPoolInfo(token);
916         if (_withUpdate) {
917             massUpdatePools();
918         }
919         pool.blockMdxReward = _reward;
920     }
921 
922     // 设置单个用户分成比例
923     function setUserProfit(address token, address _user, bool _mdxProfit, bool _cowProfit) public {
924         checkGovernance();
925         uint _pid = getPoolId(token);
926         
927         updatePool(_pid);
928         UserInfo storage user = userInfo[_pid][_user];
929 
930         if(_mdxProfit){
931             //开启用户收益
932             user.mdxProfit = 0;
933         }else{
934             // 关闭用户收益
935             PoolInfo storage pool = poolInfo[_pid];
936             user.mdxProfit = pool.accMdxPerShare;
937         }
938 
939         if(_cowProfit){
940             //开启用户收益
941             user.cowProfit = 0;
942         }else{
943             // 关闭用户收益
944             PoolInfo storage pool = poolInfo[_pid];
945             user.cowProfit = pool.accCowPerShare;
946         }
947     }
948 
949     // 设置单个用户分成比例
950     function setUserAllProfit(address _user, bool _mdxProfit, bool _cowProfit) public {
951         checkGovernance();
952         for(uint _pid=0; _pid < poolInfo.length; _pid++){
953             PoolInfo storage pool = poolInfo[_pid];
954             setUserProfit(address(pool.token), _user, _mdxProfit, _cowProfit);
955         }
956     }
957 
958     function setEarnLowerlimit(address token, uint256 _earnLowerlimit) public  {
959         checkGovernance();
960         PoolInfo storage pool = getPoolInfo(token);
961         pool.earnLowerlimit = _earnLowerlimit;
962     }
963 
964     // 给controller授权
965     function approveCtr(address token) public {
966         // 授权
967         IERC20(token).safeApprove(controller, uint256(0));
968         IERC20(token).safeApprove(controller, uint256(-1));
969     } 
970 
971     // 添加token到池子，不能重复添加同一个token, 重复添加将会导致用户收益错乱
972     function add(IERC20 _token, uint256, uint256 _earnLowerlimit, uint256, bool _withUpdate) public  {
973         require(address(_token) != address(0), "token is the zero address");
974         checkGovernance();
975 
976         if (_withUpdate) {
977             massUpdatePools();
978         }
979         
980         poolInfo.push(PoolInfo({
981             token : _token, 
982             lastRewardBlock : block.number,
983             accMdxPerShare : 0,
984             accMdxShare : 0,
985             totalAmount : 0,
986             totalAmountLimit : 0,
987             accCowPerShare : 0,
988             accCowShare : 0,
989             blockMdxReward : 0,
990             blockCowReward : 0,
991             earnLowerlimit : _earnLowerlimit
992         }));
993         TokenOfPid[address(_token)] = poolLength() - 1;
994     }
995 
996     // 结算所有币种的收益
997     function massUpdatePools() public {
998         uint256 length = poolInfo.length;
999         for (uint256 pid = 0; pid < length; ++pid) {
1000             updatePool(pid);
1001         }
1002     }
1003 
1004     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1005     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1006     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1007 
1008     // 用户总收益
1009     uint256 public userTotalProfit;
1010     // 用户已发放收益
1011     uint256 public userTotalSendProfit;
1012 
1013     // 用户总cow收益
1014     uint256 public userTotalCowProfit;
1015     // 用户已发放cow收益
1016     uint256 public userTotalSendCowProfit;
1017 
1018     function updatePool(uint256 _pid) public {
1019         PoolInfo storage pool = poolInfo[_pid];
1020         if (block.number <= pool.lastRewardBlock) {
1021             return;
1022         }
1023         updatePoolInfo(pool);
1024         updateCowInfo(pool);
1025         pool.lastRewardBlock = block.number;
1026     }
1027 
1028     // 结算单个币种的收益
1029     function updatePoolInfo(PoolInfo storage pool) internal {
1030         if(pool.blockMdxReward <= 0 || pool.totalAmount == 0){
1031             return;
1032         }
1033 
1034         uint256 blockReward = pool.blockMdxReward.mul(block.number.sub(pool.lastRewardBlock));
1035         // 所有池子用户总收益
1036         userTotalProfit = userTotalProfit.add(blockReward);
1037         // 单池子用户总收益
1038         pool.accMdxShare = pool.accMdxShare.add(blockReward);
1039         // 每个质押量 获取收益
1040         pool.accMdxPerShare = blockReward.mul(1e18).div(pool.totalAmount).add(pool.accMdxPerShare);
1041     }
1042 
1043     //结算cow
1044     function updateCowInfo(PoolInfo storage pool) internal {
1045         if(pool.blockCowReward <= 0 || pool.totalAmount == 0){
1046             return;
1047         }
1048 
1049         uint256 blockReward = pool.blockCowReward.mul(block.number.sub(pool.lastRewardBlock));
1050         // 所有池子用户总收益
1051         userTotalCowProfit = userTotalCowProfit.add(blockReward);
1052         // 单池子用户总收益
1053         pool.accCowShare = pool.accCowShare.add(blockReward);
1054         // 每个质押量 获取收益
1055         pool.accCowPerShare = blockReward.mul(1e18).div(pool.totalAmount).add(pool.accCowPerShare);
1056     }
1057 
1058     // 查询用户收益，返回用户收益,本金
1059     function pending(uint256 _pid, address _user) public view returns (uint256, uint256) {
1060         UserInfo storage user = userInfo[_pid][_user];
1061         PoolInfo storage pool = poolInfo[_pid];
1062         if (user.amount == 0 || pool.totalAmount == 0 ) {
1063             return (0, 0);
1064         } 
1065 
1066         // 增量收益
1067         uint256 blockReward = pool.blockMdxReward.mul(block.number.sub(pool.lastRewardBlock));
1068         uint256 reward = countPending(pool, user, blockReward.mul(1e18).div(pool.totalAmount));
1069         return (reward, user.amount);
1070     }
1071 
1072     // 查询用户收益，返回用户收益,本金
1073     function pendingCow(uint256 _pid, address _user) public view returns (uint256) {
1074         UserInfo storage user = userInfo[_pid][_user];
1075         PoolInfo storage pool = poolInfo[_pid];
1076         if (user.amount == 0 || pool.totalAmount == 0 ) {
1077             return 0;
1078         }
1079 
1080         // 增量收益
1081         uint256 blockReward = pool.blockCowReward.mul(block.number.sub(pool.lastRewardBlock));
1082         return countCowPending(pool, user, blockReward.mul(1e18).div(pool.totalAmount));
1083     }
1084 
1085     // 计算用户的cow收益
1086     function countCowPending(PoolInfo storage pool, UserInfo storage user, uint blockReward) internal view returns (uint) {
1087         uint256 accCowPerShare;
1088         if(user.cowProfit > 0){
1089             //用户已禁止收益
1090             accCowPerShare = user.cowProfit;
1091         }else{
1092             accCowPerShare = pool.accCowPerShare.add(blockReward);
1093         }
1094 
1095         uint pendingCowAmount = 0;
1096         uint256 totalDebt =  user.amount.mul(accCowPerShare).div(1e18);
1097         if(totalDebt > user.cowDebt){
1098             pendingCowAmount = totalDebt.sub(user.cowDebt);
1099         }
1100         return pendingCowAmount.add(user.cowReward);
1101     }
1102 
1103     // 计算用户的mdx收益
1104     function countPending(PoolInfo storage pool, UserInfo storage user, uint blockReward) internal view returns (uint) {
1105         uint256 accMdxPerShare;
1106         if(user.mdxProfit > 0) {
1107             //用户已禁止收益
1108             accMdxPerShare = user.mdxProfit;
1109         }else{
1110             // 每个质押量 获取收益
1111             accMdxPerShare = pool.accMdxPerShare.add(blockReward);
1112         }
1113 
1114         uint pendingAmount = 0;
1115         uint256 totalDebt =  user.amount.mul(accMdxPerShare).div(1e18);
1116         if(totalDebt > user.mdxDebt){
1117             pendingAmount = totalDebt.sub(user.mdxDebt);
1118         }
1119         return pendingAmount.add(user.mdxReward);
1120     }
1121 
1122     // 用户充值，当amount为0 时只是提取用户收益
1123     function depositWithPid(uint256 _pid, uint256 _amount) public notPause {
1124         require(_amount >= 0, "deposit: not good");
1125         PoolInfo storage pool = poolInfo[_pid];
1126         UserInfo storage user = userInfo[_pid][msg.sender];
1127 
1128         if(pool.totalAmountLimit > 0 ){
1129             //限制投资总量
1130             require(pool.totalAmountLimit >= (pool.totalAmount.add(_amount)), "deposit amount limit");
1131         }
1132 
1133         updatePool(_pid);
1134         if(hupPoolExtend != address(0)){
1135             IHubPoolExtend(hupPoolExtend).deposit(_pid, _amount, msg.sender);
1136         }
1137 
1138         // 先结算用户先前的投资
1139         if (user.amount > 0) {
1140             // 给用户发放收益与平台分润
1141             uint256 pendingAmount = countPending(pool, user, uint(0));
1142             uint256 pendingCowAmount = countCowPending(pool, user, uint(0));
1143 
1144             // 记录未提收益
1145             //safeMdxTransfer(address(pool.token), msg.sender, pendingAmount, pendingCowAmount);
1146             user.mdxReward = pendingAmount;
1147             user.cowReward = pendingCowAmount;
1148         }
1149 
1150         // 执行扣用户的token
1151         if (_amount > 0) {
1152             uint256 beforeToken = pool.token.balanceOf(address(this));
1153             pool.token.safeTransferFrom(msg.sender, address(this), _amount);
1154             uint256 afterToken = pool.token.balanceOf(address(this));
1155             _amount = afterToken.sub(beforeToken);
1156 
1157             if(_amount > 0) {
1158                 user.amount = user.amount.add(_amount);
1159                 pool.totalAmount = pool.totalAmount.add(_amount);
1160             }
1161         }
1162 
1163         // 重新触发投资
1164         earn(address(pool.token));
1165 
1166         // 更新用户负债
1167         user.cowDebt = user.amount.mul(pool.accCowPerShare).div(1e18);
1168         user.mdxDebt = user.amount.mul(pool.accMdxPerShare).div(1e18);
1169         emit Deposit(msg.sender, _pid, _amount);
1170     }
1171 
1172     // 提现本金，默认触发提现收益，传0只提现收益
1173     function withdrawWithPid(uint256 _pid, uint256 _amount) public notPause {
1174         require(_amount >= 0, "withdraw: not good");
1175         PoolInfo storage pool = poolInfo[_pid];
1176         UserInfo storage user = userInfo[_pid][msg.sender];
1177         require(user.amount >= _amount, "withdraw: Insufficient balance");
1178         updatePool(_pid);
1179 
1180         uint256 transferAmount = _amount;
1181         if(hupPoolExtend != address(0)){
1182             transferAmount = IHubPoolExtend(hupPoolExtend).withdraw(_pid, _amount, msg.sender);
1183         }
1184 
1185         if(user.amount > 0){
1186             // 给用户发放收益与平台分润
1187             uint256 pendingAmount = countPending(pool, user, uint(0));
1188             uint256 pendingCowAmount = countCowPending(pool, user, uint(0));
1189             user.mdxReward = 0;
1190             user.cowReward = 0;
1191             safeMdxTransfer(address(pool.token), msg.sender, pendingAmount, pendingCowAmount);
1192         }
1193 
1194         // 提现本金
1195         if (_amount > 0) {
1196             uint256 poolBalance = pool.token.balanceOf(address(this));
1197             if(poolBalance < _amount) {
1198                 // 当前合约余额不足，调用上游释放投资
1199                 IController(controller).withdrawLp(address(pool.token), _amount.sub(poolBalance));
1200                 poolBalance = pool.token.balanceOf(address(this));
1201                 //上游资金不足 需要对冲
1202                 require(poolBalance >= _amount, "withdraw: need hedge");
1203             }
1204 
1205             user.amount = user.amount.sub(_amount);
1206             pool.totalAmount = pool.totalAmount.sub(_amount);
1207             pool.token.safeTransfer(msg.sender, transferAmount);
1208         }
1209 
1210         // 重新触发投资
1211         earn(address(pool.token));
1212 
1213         // 更新用户负债
1214         user.cowDebt = user.amount.mul(pool.accCowPerShare).div(1e18);
1215         user.mdxDebt = user.amount.mul(pool.accMdxPerShare).div(1e18);
1216         emit Withdraw(msg.sender, _pid, _amount);
1217     }
1218 
1219     // 用户紧急提现，放弃收益
1220     function emergencyWithdraw(uint256 _pid) public notPause {
1221         PoolInfo storage pool = poolInfo[_pid];
1222         UserInfo storage user = userInfo[_pid][msg.sender];
1223         uint256 amount = user.amount;
1224         uint256 transferAmount = amount;
1225 
1226         if(hupPoolExtend != address(0)){
1227             transferAmount = IHubPoolExtend(hupPoolExtend).emergencyWithdraw(_pid, amount, msg.sender);
1228         }
1229 
1230         uint256 poolBalance = pool.token.balanceOf(address(this));
1231         if(poolBalance < amount){
1232             // 当前合约余额不足，调用上游释放投资
1233             IController(controller).withdrawLp(address(pool.token), amount.sub(poolBalance));
1234 
1235             poolBalance = pool.token.balanceOf(address(this));
1236             // 上游资金不足 需要对冲
1237             require(poolBalance >= amount, "withdraw: need hedge");
1238         }
1239 
1240         user.amount = 0;
1241         user.mdxDebt = 0;
1242         user.cowDebt = 0;
1243         user.mdxReward = 0;
1244         user.cowReward = 0;
1245 
1246         pool.token.safeTransfer(msg.sender, transferAmount);
1247         pool.totalAmount = pool.totalAmount.sub(amount);
1248         emit EmergencyWithdraw(msg.sender, _pid, amount);
1249     }
1250 
1251     // 给用户发放收益与平台分润
1252     function safeMdxTransfer(address _token, address _to, uint256 _userPendingAmount, uint256 _userCowPendingAmount) private {
1253         if(_userPendingAmount > 0 || _userCowPendingAmount > 0) {
1254             userTotalSendProfit = userTotalSendProfit.add(_userPendingAmount);
1255             userTotalSendCowProfit = userTotalSendCowProfit.add(_userCowPendingAmount);
1256             IController(controller).withdrawPending(_token, _to, _userPendingAmount, _userCowPendingAmount);
1257         }
1258     }
1259 
1260     // 获取token累计的mdx收益，调用controller获取
1261     function getMdxBlockReward(address token) public view returns (uint256) {
1262         PoolInfo storage pool = getPoolInfo(token);
1263         return pool.accMdxShare;
1264     }
1265 
1266     // 触发投资，调用controller获取
1267     function earn(address token) public {
1268         approveCtr(token);
1269         IController(controller).earn(token);
1270     }
1271     
1272     // 计算用于投资的金额
1273     function available(address token) public view returns (uint256) {
1274         PoolInfo storage pool = getPoolInfo(token);
1275         uint b = pool.token.balanceOf(address(this)); 
1276         if(pool.earnLowerlimit >= b){
1277             return uint(0);
1278         }
1279         return b;
1280     }
1281 
1282     /*********************** 封装给web3j调用的接口 ********************/
1283     // 查询币种对应年化收益率
1284     function getApy(address token) external view returns (uint256) {
1285         PoolInfo storage pool = getPoolInfo(token);
1286         //计算年化利率万分比，按10秒一个块算 *86400*365/10
1287         return pool.blockMdxReward.mul(10000).mul(3153600).div(pool.totalAmount.add(1));
1288     }
1289 
1290     // 查询币种对应年化收益率
1291     function getCowApy(address token) external view returns (uint256) {
1292         PoolInfo storage pool = getPoolInfo(token);
1293         //计算年化利率万分比，按10秒一个块算 *86400*365/10
1294         return pool.blockCowReward.mul(10000).mul(3153600).div(pool.totalAmount.add(1));
1295     }
1296 
1297     // 查询用户已收益
1298     function earned(address token, address userAddress) external view returns (uint256) {
1299         (uint256 reward,) = pending(getPoolId(token), userAddress);
1300         return reward;
1301     }
1302 
1303     // 查询用户已存入资金
1304     function getDepositAsset(address token, address userAddress) external view returns (uint256) {
1305         UserInfo storage user = userInfo[getPoolId(token)][userAddress];
1306         return user.amount;
1307     }
1308 
1309     // 用户存入操作
1310     function deposit(address token, uint256 _amount) external {
1311         uint _pid = getPoolId(token);
1312         return depositWithPid(_pid, _amount);
1313     }
1314 
1315     // 用户存所有
1316     function depositAll(address token) external {
1317         uint _pid = getPoolId(token);
1318         return depositWithPid(_pid, IERC20(token).balanceOf(msg.sender));
1319     }
1320 
1321     // 用户提现操作
1322     function withdraw(address token, uint256 _amount) external {
1323         uint _pid = getPoolId(token);
1324         return withdrawWithPid(_pid, _amount);
1325     }
1326 
1327     // 用户提现所有
1328     function withdrawAll(address token) external {
1329         uint _pid = getPoolId(token);
1330         UserInfo storage user = userInfo[_pid][msg.sender];
1331         return withdrawWithPid(_pid, user.amount);
1332     }
1333 }