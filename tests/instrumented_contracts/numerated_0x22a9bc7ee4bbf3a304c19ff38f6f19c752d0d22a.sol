1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/math/SafeMath.sol
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
219 
220 pragma solidity >=0.6.0 <0.8.0;
221 
222 /**
223  * @dev Interface of the ERC20 standard as defined in the EIP.
224  */
225 interface IERC20 {
226     /**
227      * @dev Returns the amount of tokens in existence.
228      */
229     function totalSupply() external view returns (uint256);
230 
231     /**
232      * @dev Returns the amount of tokens owned by `account`.
233      */
234     function balanceOf(address account) external view returns (uint256);
235 
236     /**
237      * @dev Moves `amount` tokens from the caller's account to `recipient`.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transfer(address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Returns the remaining number of tokens that `spender` will be
247      * allowed to spend on behalf of `owner` through {transferFrom}. This is
248      * zero by default.
249      *
250      * This value changes when {approve} or {transferFrom} are called.
251      */
252     function allowance(address owner, address spender) external view returns (uint256);
253 
254     /**
255      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
256      *
257      * Returns a boolean value indicating whether the operation succeeded.
258      *
259      * IMPORTANT: Beware that changing an allowance with this method brings the risk
260      * that someone may use both the old and the new allowance by unfortunate
261      * transaction ordering. One possible solution to mitigate this race
262      * condition is to first reduce the spender's allowance to 0 and set the
263      * desired value afterwards:
264      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address spender, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Moves `amount` tokens from `sender` to `recipient` using the
272      * allowance mechanism. `amount` is then deducted from the caller's
273      * allowance.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
280 
281     /**
282      * @dev Emitted when `value` tokens are moved from one account (`from`) to
283      * another (`to`).
284      *
285      * Note that `value` may be zero.
286      */
287     event Transfer(address indexed from, address indexed to, uint256 value);
288 
289     /**
290      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
291      * a call to {approve}. `value` is the new allowance.
292      */
293     event Approval(address indexed owner, address indexed spender, uint256 value);
294 }
295 
296 // File: @openzeppelin/contracts/utils/Address.sol
297 
298 pragma solidity >=0.6.2 <0.8.0;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // This method relies on extcodesize, which returns 0 for contracts in
323         // construction, since the code is only stored at the end of the
324         // constructor execution.
325 
326         uint256 size;
327         // solhint-disable-next-line no-inline-assembly
328         assembly { size := extcodesize(account) }
329         return size > 0;
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
352         (bool success, ) = recipient.call{ value: amount }("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain`call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375       return functionCall(target, data, "Address: low-level call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
405      * with `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
410         require(address(this).balance >= value, "Address: insufficient balance for call");
411         require(isContract(target), "Address: call to non-contract");
412 
413         // solhint-disable-next-line avoid-low-level-calls
414         (bool success, bytes memory returndata) = target.call{ value: value }(data);
415         return _verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but performing a static call.
421      *
422      * _Available since v3.3._
423      */
424     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
425         return functionStaticCall(target, data, "Address: low-level static call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
435         require(isContract(target), "Address: static call to non-contract");
436 
437         // solhint-disable-next-line avoid-low-level-calls
438         (bool success, bytes memory returndata) = target.staticcall(data);
439         return _verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         // solhint-disable-next-line avoid-low-level-calls
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return _verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
467         if (success) {
468             return returndata;
469         } else {
470             // Look for revert reason and bubble it up if present
471             if (returndata.length > 0) {
472                 // The easiest way to bubble the revert reason is using memory via assembly
473 
474                 // solhint-disable-next-line no-inline-assembly
475                 assembly {
476                     let returndata_size := mload(returndata)
477                     revert(add(32, returndata), returndata_size)
478                 }
479             } else {
480                 revert(errorMessage);
481             }
482         }
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
487 
488 pragma solidity >=0.6.0 <0.8.0;
489 
490 
491 
492 
493 /**
494  * @title SafeERC20
495  * @dev Wrappers around ERC20 operations that throw on failure (when the token
496  * contract returns false). Tokens that return no value (and instead revert or
497  * throw on failure) are also supported, non-reverting calls are assumed to be
498  * successful.
499  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
500  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
501  */
502 library SafeERC20 {
503     using SafeMath for uint256;
504     using Address for address;
505 
506     function safeTransfer(IERC20 token, address to, uint256 value) internal {
507         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
508     }
509 
510     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
511         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
512     }
513 
514     /**
515      * @dev Deprecated. This function has issues similar to the ones found in
516      * {IERC20-approve}, and its usage is discouraged.
517      *
518      * Whenever possible, use {safeIncreaseAllowance} and
519      * {safeDecreaseAllowance} instead.
520      */
521     function safeApprove(IERC20 token, address spender, uint256 value) internal {
522         // safeApprove should only be called when setting an initial allowance,
523         // or when resetting it to zero. To increase and decrease it, use
524         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
525         // solhint-disable-next-line max-line-length
526         require((value == 0) || (token.allowance(address(this), spender) == 0),
527             "SafeERC20: approve from non-zero to non-zero allowance"
528         );
529         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
530     }
531 
532     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
533         uint256 newAllowance = token.allowance(address(this), spender).add(value);
534         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
535     }
536 
537     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
538         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
539         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
540     }
541 
542     /**
543      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
544      * on the return value: the return value is optional (but if data is returned, it must not be false).
545      * @param token The token targeted by the call.
546      * @param data The call data (encoded using abi.encode or one of its variants).
547      */
548     function _callOptionalReturn(IERC20 token, bytes memory data) private {
549         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
550         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
551         // the target address contains contract code and also asserts for success in the low-level call.
552 
553         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
554         if (returndata.length > 0) { // Return data is optional
555             // solhint-disable-next-line max-line-length
556             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
557         }
558     }
559 }
560 
561 // File: @openzeppelin/contracts/utils/Context.sol
562 
563 pragma solidity >=0.6.0 <0.8.0;
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
586 // File: @openzeppelin/contracts/access/Ownable.sol
587 
588 pragma solidity >=0.6.0 <0.8.0;
589 
590 /**
591  * @dev Contract module which provides a basic access control mechanism, where
592  * there is an account (an owner) that can be granted exclusive access to
593  * specific functions.
594  *
595  * By default, the owner account will be the one that deploys the contract. This
596  * can later be changed with {transferOwnership}.
597  *
598  * This module is used through inheritance. It will make available the modifier
599  * `onlyOwner`, which can be applied to your functions to restrict their use to
600  * the owner.
601  */
602 abstract contract Ownable is Context {
603     address private _owner;
604 
605     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
606 
607     /**
608      * @dev Initializes the contract setting the deployer as the initial owner.
609      */
610     constructor () internal {
611         address msgSender = _msgSender();
612         _owner = msgSender;
613         emit OwnershipTransferred(address(0), msgSender);
614     }
615 
616     /**
617      * @dev Returns the address of the current owner.
618      */
619     function owner() public view virtual returns (address) {
620         return _owner;
621     }
622 
623     /**
624      * @dev Throws if called by any account other than the owner.
625      */
626     modifier onlyOwner() {
627         require(owner() == _msgSender(), "Ownable: caller is not the owner");
628         _;
629     }
630 
631     /**
632      * @dev Leaves the contract without owner. It will not be possible to call
633      * `onlyOwner` functions anymore. Can only be called by the current owner.
634      *
635      * NOTE: Renouncing ownership will leave the contract without an owner,
636      * thereby removing any functionality that is only available to the owner.
637      */
638     function renounceOwnership() public virtual onlyOwner {
639         emit OwnershipTransferred(_owner, address(0));
640         _owner = address(0);
641     }
642 
643     /**
644      * @dev Transfers ownership of the contract to a new account (`newOwner`).
645      * Can only be called by the current owner.
646      */
647     function transferOwnership(address newOwner) public virtual onlyOwner {
648         require(newOwner != address(0), "Ownable: new owner is the zero address");
649         emit OwnershipTransferred(_owner, newOwner);
650         _owner = newOwner;
651     }
652 }
653 
654 // File: @openzeppelin/contracts/utils/Pausable.sol
655 
656 pragma solidity >=0.6.0 <0.8.0;
657 
658 
659 /**
660  * @dev Contract module which allows children to implement an emergency stop
661  * mechanism that can be triggered by an authorized account.
662  *
663  * This module is used through inheritance. It will make available the
664  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
665  * the functions of your contract. Note that they will not be pausable by
666  * simply including this module, only once the modifiers are put in place.
667  */
668 abstract contract Pausable is Context {
669     /**
670      * @dev Emitted when the pause is triggered by `account`.
671      */
672     event Paused(address account);
673 
674     /**
675      * @dev Emitted when the pause is lifted by `account`.
676      */
677     event Unpaused(address account);
678 
679     bool private _paused;
680 
681     /**
682      * @dev Initializes the contract in unpaused state.
683      */
684     constructor () internal {
685         _paused = false;
686     }
687 
688     /**
689      * @dev Returns true if the contract is paused, and false otherwise.
690      */
691     function paused() public view virtual returns (bool) {
692         return _paused;
693     }
694 
695     /**
696      * @dev Modifier to make a function callable only when the contract is not paused.
697      *
698      * Requirements:
699      *
700      * - The contract must not be paused.
701      */
702     modifier whenNotPaused() {
703         require(!paused(), "Pausable: paused");
704         _;
705     }
706 
707     /**
708      * @dev Modifier to make a function callable only when the contract is paused.
709      *
710      * Requirements:
711      *
712      * - The contract must be paused.
713      */
714     modifier whenPaused() {
715         require(paused(), "Pausable: not paused");
716         _;
717     }
718 
719     /**
720      * @dev Triggers stopped state.
721      *
722      * Requirements:
723      *
724      * - The contract must not be paused.
725      */
726     function _pause() internal virtual whenNotPaused {
727         _paused = true;
728         emit Paused(_msgSender());
729     }
730 
731     /**
732      * @dev Returns to normal state.
733      *
734      * Requirements:
735      *
736      * - The contract must be paused.
737      */
738     function _unpause() internal virtual whenPaused {
739         _paused = false;
740         emit Unpaused(_msgSender());
741     }
742 }
743 
744 // File: contracts/VestingTimelock.sol
745 
746 pragma solidity >=0.6.2 <0.8.0;
747 
748 
749 
750 
751 
752 contract VestingTimelock is Ownable, Pausable {
753   using SafeMath for uint256;
754   using SafeERC20 for IERC20;
755 
756   IERC20 private _token;
757 
758   mapping (address => uint256) private _balances;
759   mapping (address => uint256) private _claims;
760 
761   uint256 private _totalBalance;
762   uint256 private _totalClaimed;
763 
764   uint256 private _startTime;
765   uint256 private _endTime;
766 
767   event Claimed(address indexed to, uint256 value, uint256 progress);
768 
769   constructor (IERC20 token_, uint256 startTime_, uint256 endTime_) public {
770       require(endTime_ > currentTime(), "VestingTimelock: end before current time");
771       require(endTime_ > startTime_, "VestingTimelock: end before start time");
772 
773       _token = token_;
774       _endTime = endTime_;
775       _startTime = startTime_;
776       if (_startTime == 0)
777         _startTime = currentTime();
778   }
779 
780 
781   /**************************
782    View Functions
783    **************************/
784 
785   function token() public view virtual returns (IERC20) {
786       return _token;
787   }
788 
789   function currentTime() public view virtual returns (uint256) {
790     // solhint-disable-next-line not-rely-on-time
791     return block.timestamp;
792   }
793 
794   function totalBalance() public view virtual returns (uint256) {
795       return _totalBalance;
796   }
797 
798   function totalClaimed() public view virtual returns (uint256) {
799       return _totalClaimed;
800   }
801 
802   function totalVested() public view virtual returns (uint256) {
803       return totalBalance().mul(getProgress()).div(1e18);
804   }
805 
806   function totalAvailable() public view virtual returns (uint256) {
807       return totalVested().sub(totalClaimed());
808   }
809 
810   function startTime() public view virtual returns (uint256) {
811       return _startTime;
812   }
813 
814   function endTime() public view virtual returns (uint256) {
815       return _endTime;
816   }
817 
818   function getProgress() public view returns (uint256) {
819     if (currentTime() > _endTime)
820       return 1e18;
821     else if (currentTime() < _startTime)
822       return 0;
823     else
824       return currentTime().sub(_startTime).mul(1e18).div(_endTime.sub(_startTime));
825   }
826 
827   function balanceOf(address account) public view virtual returns (uint256) {
828       return _balances[account];
829   }
830 
831   function claimedOf(address account) public view virtual returns (uint256) {
832       return _claims[account];
833   }
834 
835   function vestedOf(address account) public view virtual returns (uint256) {
836       return _balances[account].mul(getProgress()).div(1e18);
837   }
838 
839   function availableOf(address account) public view virtual returns (uint256) {
840       return vestedOf(account).sub(claimedOf(account));
841   }
842 
843 
844   /**************************
845    Public Functions
846    **************************/
847 
848   function claim() public virtual whenNotPaused {
849       uint256 amount = availableOf(msg.sender);
850       require(amount > 0, "VestingTimelock: no tokens vested yet");
851 
852       _claims[msg.sender] = _claims[msg.sender].add(amount);
853       _totalClaimed = _totalClaimed.add(amount);
854 
855       token().safeTransfer(msg.sender, amount);
856 
857       emit Claimed(msg.sender, amount, getProgress());
858   }
859 
860   /**************************
861    Owner Functions
862    **************************/
863 
864   function pause() public virtual onlyOwner {
865     _pause();
866   }
867 
868   function unpause() public virtual onlyOwner {
869     unpause();
870   }
871 
872   function recover() public virtual onlyOwner {
873     token().safeTransfer(msg.sender, token().balanceOf(address(this)));
874   }
875 
876   function replaceAddress(address account1, address account2) external onlyOwner {
877     require(_balances[account1] > 0, "replacement address has no balance");
878     require(_balances[account2] == 0, "replacement address has balance");
879 
880     _balances[account2] = _balances[account1];
881     _claims[account2] = _claims[account1];
882 
883     _balances[account1] = 0;
884     _claims[account1] = 0;
885   }
886 
887   function setClaimed(address account, uint256 value) external onlyOwner {
888     require(value <= _balances[account], "balance cannot be less than claimed");
889     _totalClaimed = _totalClaimed.add(value).sub(_claims[account]);
890     _claims[account] = value;
891   }
892 
893   function setBalance(address account, uint256 value) external onlyOwner {
894     require(value >= _claims[account], "balance cannot be less than claimed");
895     _totalBalance = _totalBalance.add(value).sub(_balances[account]);
896     _balances[account] = value;
897   }
898 
899   function setBalances(address[] calldata recipients, uint256[] calldata values) external onlyOwner {
900     require(recipients.length > 0 && recipients.length == values.length, "values and recipient parameters have different lengths or their length is zero");
901 
902     for (uint256 i = 0; i < recipients.length; i++) {
903       _totalBalance = _totalBalance.add(values[i]).sub(_balances[recipients[i]]);
904       _balances[recipients[i]] = values[i];
905     }
906   }
907 
908   function addBalances(address[] calldata recipients, uint256[] calldata values) external onlyOwner {
909     require(recipients.length > 0 && recipients.length == values.length, "values and recipient parameters have different lengths or their length is zero");
910 
911     for (uint256 i = 0; i < recipients.length; i++) {
912       _totalBalance = _totalBalance.add(values[i]);
913       _balances[recipients[i]] = _balances[recipients[i]].add(values[i]);
914     }
915   }
916 
917   function setClaims(address[] calldata recipients, uint256[] calldata values) external onlyOwner {
918     require(recipients.length > 0 && recipients.length == values.length, "values and recipient parameters have different lengths or their length is zero");
919 
920     for (uint256 i = 0; i < recipients.length; i++) {
921       _totalClaimed = _totalClaimed.add(values[i]);
922       _claims[recipients[i]] = values[i];
923     }
924   }
925 }