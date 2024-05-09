1 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * // importANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
83 
84 
85 // pragma solidity >=0.6.0 <0.8.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 
244 // Dependency file: @openzeppelin/contracts/utils/Address.sol
245 
246 
247 // pragma solidity >=0.6.2 <0.8.0;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [// importANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * // importANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: value }(data);
364         return _verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
374         return functionStaticCall(target, data, "Address: low-level static call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 // solhint-disable-next-line no-inline-assembly
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 
412 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
413 
414 
415 // pragma solidity >=0.6.0 <0.8.0;
416 
417 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
418 // import "@openzeppelin/contracts/math/SafeMath.sol";
419 // import "@openzeppelin/contracts/utils/Address.sol";
420 
421 /**
422  * @title SafeERC20
423  * @dev Wrappers around ERC20 operations that throw on failure (when the token
424  * contract returns false). Tokens that return no value (and instead revert or
425  * throw on failure) are also supported, non-reverting calls are assumed to be
426  * successful.
427  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
428  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
429  */
430 library SafeERC20 {
431     using SafeMath for uint256;
432     using Address for address;
433 
434     function safeTransfer(IERC20 token, address to, uint256 value) internal {
435         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
436     }
437 
438     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
439         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
440     }
441 
442     /**
443      * @dev Deprecated. This function has issues similar to the ones found in
444      * {IERC20-approve}, and its usage is discouraged.
445      *
446      * Whenever possible, use {safeIncreaseAllowance} and
447      * {safeDecreaseAllowance} instead.
448      */
449     function safeApprove(IERC20 token, address spender, uint256 value) internal {
450         // safeApprove should only be called when setting an initial allowance,
451         // or when resetting it to zero. To increase and decrease it, use
452         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
453         // solhint-disable-next-line max-line-length
454         require((value == 0) || (token.allowance(address(this), spender) == 0),
455             "SafeERC20: approve from non-zero to non-zero allowance"
456         );
457         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
458     }
459 
460     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).add(value);
462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
467         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     /**
471      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
472      * on the return value: the return value is optional (but if data is returned, it must not be false).
473      * @param token The token targeted by the call.
474      * @param data The call data (encoded using abi.encode or one of its variants).
475      */
476     function _callOptionalReturn(IERC20 token, bytes memory data) private {
477         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
478         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
479         // the target address contains contract code and also asserts for success in the low-level call.
480 
481         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
482         if (returndata.length > 0) { // Return data is optional
483             // solhint-disable-next-line max-line-length
484             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
485         }
486     }
487 }
488 
489 
490 // Dependency file: contracts/interfaces/IDePayRouterV1Plugin.sol
491 
492 
493 // pragma solidity >=0.7.5 <0.8.0;
494 pragma abicoder v2;
495 
496 interface IDePayRouterV1Plugin {
497 
498   function execute(
499     address[] calldata path,
500     uint[] calldata amounts,
501     address[] calldata addresses,
502     string[] calldata data
503   ) external payable returns(bool);
504 
505   function delegate() external returns(bool);
506 }
507 
508 
509 // Dependency file: contracts/libraries/Helper.sol
510 
511 // Helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
512 library Helper {
513   function safeApprove(
514     address token,
515     address to,
516     uint256 value
517   ) internal {
518     // bytes4(keccak256(bytes('approve(address,uint256)')));
519     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
520     require(
521       success && (data.length == 0 || abi.decode(data, (bool))),
522       'Helper::safeApprove: approve failed'
523     );
524   }
525 
526   function safeTransfer(
527     address token,
528     address to,
529     uint256 value
530   ) internal {
531     // bytes4(keccak256(bytes('transfer(address,uint256)')));
532     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
533     require(
534       success && (data.length == 0 || abi.decode(data, (bool))),
535       'Helper::safeTransfer: transfer failed'
536     );
537   }
538 
539   function safeTransferFrom(
540     address token,
541     address from,
542     address to,
543     uint256 value
544   ) internal {
545     // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
546     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
547     require(
548       success && (data.length == 0 || abi.decode(data, (bool))),
549       'Helper::transferFrom: transferFrom failed'
550     );
551   }
552 
553   function safeTransferETH(address to, uint256 value) internal {
554     (bool success, ) = to.call{value: value}(new bytes(0));
555     require(success, 'Helper::safeTransferETH: ETH transfer failed');
556   }
557 }
558 
559 
560 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
561 
562 
563 // pragma solidity >=0.6.0 <0.8.0;
564 
565 /*
566  * @dev Provides information about the current execution context, including the
567  * sender of the transaction and its data. While these are generally available
568  * via msg.sender and msg.data, they should not be accessed in such a direct
569  * manner, since when dealing with GSN meta-transactions the account sending and
570  * paying for execution may not be the actual sender (as far as an application
571  * is concerned).
572  *
573  * This contract is only required for intermediate, library-like contracts.
574  */
575 abstract contract Context {
576     function _msgSender() internal view virtual returns (address payable) {
577         return msg.sender;
578     }
579 
580     function _msgData() internal view virtual returns (bytes memory) {
581         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
582         return msg.data;
583     }
584 }
585 
586 
587 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
588 
589 
590 // pragma solidity >=0.6.0 <0.8.0;
591 
592 // import "@openzeppelin/contracts/GSN/Context.sol";
593 /**
594  * @dev Contract module which provides a basic access control mechanism, where
595  * there is an account (an owner) that can be granted exclusive access to
596  * specific functions.
597  *
598  * By default, the owner account will be the one that deploys the contract. This
599  * can later be changed with {transferOwnership}.
600  *
601  * This module is used through inheritance. It will make available the modifier
602  * `onlyOwner`, which can be applied to your functions to restrict their use to
603  * the owner.
604  */
605 abstract contract Ownable is Context {
606     address private _owner;
607 
608     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
609 
610     /**
611      * @dev Initializes the contract setting the deployer as the initial owner.
612      */
613     constructor () internal {
614         address msgSender = _msgSender();
615         _owner = msgSender;
616         emit OwnershipTransferred(address(0), msgSender);
617     }
618 
619     /**
620      * @dev Returns the address of the current owner.
621      */
622     function owner() public view returns (address) {
623         return _owner;
624     }
625 
626     /**
627      * @dev Throws if called by any account other than the owner.
628      */
629     modifier onlyOwner() {
630         require(_owner == _msgSender(), "Ownable: caller is not the owner");
631         _;
632     }
633 
634     /**
635      * @dev Leaves the contract without owner. It will not be possible to call
636      * `onlyOwner` functions anymore. Can only be called by the current owner.
637      *
638      * NOTE: Renouncing ownership will leave the contract without an owner,
639      * thereby removing any functionality that is only available to the owner.
640      */
641     function renounceOwnership() public virtual onlyOwner {
642         emit OwnershipTransferred(_owner, address(0));
643         _owner = address(0);
644     }
645 
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Can only be called by the current owner.
649      */
650     function transferOwnership(address newOwner) public virtual onlyOwner {
651         require(newOwner != address(0), "Ownable: new owner is the zero address");
652         emit OwnershipTransferred(_owner, newOwner);
653         _owner = newOwner;
654     }
655 }
656 
657 
658 // Dependency file: contracts/DePayRouterV1Configuration.sol
659 
660 
661 // pragma solidity >=0.7.5 <0.8.0;
662 
663 // import "@openzeppelin/contracts/access/Ownable.sol";
664 
665 // Prevents unwanted access to configuration in DePayRouterV1
666 // Potentially occuring through delegatecall(ing) plugins.
667 contract DePayRouterV1Configuration is Ownable {
668   
669   // List of approved plugins. Use approvePlugin to add new plugins.
670   mapping (address => address) public approvedPlugins;
671 
672   // Approves the provided plugin.
673   function approvePlugin(address plugin) external onlyOwner returns(bool) {
674     approvedPlugins[plugin] = plugin;
675     emit PluginApproved(plugin);
676     return true;
677   }
678 
679   // Event to emit newly approved plugin.
680   event PluginApproved(
681     address indexed pluginAddress
682   );
683 
684   // Disapproves the provided plugin.
685   function disapprovePlugin(address plugin) external onlyOwner returns(bool) {
686     approvedPlugins[plugin] = address(0);
687     emit PluginDisapproved(plugin);
688     return true;
689   }
690 
691   // Event to emit disapproved plugin.
692   event PluginDisapproved(
693     address indexed pluginAddress
694   );
695 }
696 
697 
698 // Root file: contracts/DePayRouterV1.sol
699 
700 
701 pragma solidity >=0.7.5 <0.8.0;
702 
703 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
704 // import "@openzeppelin/contracts/math/SafeMath.sol";
705 // import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
706 // import 'contracts/interfaces/IDePayRouterV1Plugin.sol';
707 // import 'contracts/libraries/Helper.sol';
708 // import 'contracts/DePayRouterV1Configuration.sol';
709 
710 contract DePayRouterV1 {
711   
712   using SafeMath for uint;
713   using SafeERC20 for IERC20;
714 
715   // Address representating ETH (e.g. in payment routing paths)
716   address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
717 
718   // Instance of DePayRouterV1Configuration
719   DePayRouterV1Configuration public immutable configuration;
720 
721   // Pass immutable instance to configuration.
722   // This protects from potential delegatecall and access overlay attacks:
723   // https://github.com/DePayFi/depay-ethereum-payments/blob/master/docs/Audit3.md#H02
724   constructor (
725     address _configuration
726   ) public {
727     configuration = DePayRouterV1Configuration(_configuration);
728   }
729 
730   // Proxy modifier to DePayRouterV1Configuration
731   modifier onlyOwner() {
732     require(configuration.owner() == msg.sender, "Ownable: caller is not the owner");
733     _;
734   }
735 
736   receive() external payable {
737     // Accepts ETH payments which is require in order
738     // to swap from and to ETH
739     // especially unwrapping WETH as part of token swaps.
740   }
741 
742   // The main function to route transactions.
743   function route(
744     // The path of the token conversion.
745     address[] calldata path,
746     // Amounts passed to proccessors:
747     // e.g. [amountIn, amountOut, deadline]
748     uint[] calldata amounts,
749     // Addresses passed to plugins:
750     // e.g. [receiver]
751     address[] calldata addresses,
752     // List and order of plugins to be executed for this payment:
753     // e.g. [Uniswap,paymentPlugin] to swap and pay
754     address[] calldata plugins,
755     // Data passed to plugins:
756     // e.g. ["signatureOfSmartContractFunction(address,uint)"] receiving the payment
757     string[] calldata data
758   ) external payable returns(bool) {
759     uint balanceBefore = _balanceBefore(path[path.length-1]);
760     _ensureTransferIn(path[0], amounts[0]);
761     _execute(path, amounts, addresses, plugins, data);
762     _ensureBalance(path[path.length-1], balanceBefore);
763     return true;
764   }
765 
766   // Returns the balance for a token (or ETH) before the payment is executed.
767   // In case of ETH we need to deduct what has been payed in as part of the transaction itself.
768   function _balanceBefore(address token) private returns (uint balance) {
769     balance = _balance(token);
770     if(token == ETH) { balance -= msg.value; }
771   }
772 
773   // This makes sure that the sender has payed in the token (or ETH)
774   // required to perform the payment.
775   function _ensureTransferIn(address tokenIn, uint amountIn) private {
776     if(tokenIn == ETH) { 
777       require(msg.value >= amountIn, 'DePay: Insufficient ETH amount payed in!'); 
778     } else {
779       Helper.safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
780     }
781   }
782 
783   // Executes plugins in the given order.
784   function _execute(
785     address[] calldata path,
786     uint[] calldata amounts,
787     address[] calldata addresses,
788     address[] calldata plugins,
789     string[] calldata data
790   ) internal {
791     for (uint i = 0; i < plugins.length; i++) {
792       require(_isApproved(plugins[i]), 'DePay: Plugin not approved!');
793       
794       IDePayRouterV1Plugin plugin = IDePayRouterV1Plugin(configuration.approvedPlugins(plugins[i]));
795 
796       if(plugin.delegate()) {
797         (bool success, bytes memory returnData) = address(plugin).delegatecall(abi.encodeWithSelector(
798             plugin.execute.selector, path, amounts, addresses, data
799         ));
800         require(success, string(returnData));
801       } else {
802         (bool success, bytes memory returnData) = address(plugin).call(abi.encodeWithSelector(
803             plugin.execute.selector, path, amounts, addresses, data
804         ));
805         require(success, string(returnData));
806       }
807     }
808   }
809 
810   // This makes sure that the balance after the payment not less than before.
811   // Prevents draining of the contract.
812   function _ensureBalance(address tokenOut, uint balanceBefore) private view {
813     require(_balance(tokenOut) >= balanceBefore, 'DePay: Insufficient balance after payment!');
814   }
815 
816   // Returns the balance of the payment plugin contract for a token (or ETH).
817   function _balance(address token) private view returns(uint) {
818     if(token == ETH) {
819         return address(this).balance;
820     } else {
821         return IERC20(token).balanceOf(address(this));
822     }
823   }
824 
825   // Function to check if a plugin address is approved.
826   function isApproved(
827     address pluginAddress
828   ) external view returns(bool){
829     return _isApproved(pluginAddress);
830   }
831 
832   // Internal function to check if a plugin address is approved.
833   function _isApproved(
834     address pluginAddress
835   ) internal view returns(bool) {
836     return (configuration.approvedPlugins(pluginAddress) != address(0));
837   }
838   
839   // Allows to withdraw accidentally sent ETH or tokens.
840   function withdraw(
841     address token,
842     uint amount
843   ) external onlyOwner returns(bool) {
844     if(token == ETH) {
845       Helper.safeTransferETH(payable(configuration.owner()), amount);
846     } else {
847       Helper.safeTransfer(token, payable(configuration.owner()), amount);
848     }
849     return true;
850   }
851 }