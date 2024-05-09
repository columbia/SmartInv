1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
98 
99 
100 pragma solidity ^0.6.0;
101 
102 /**
103  * @dev Interface of the ERC20 standard as defined in the EIP.
104  */
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: @openzeppelin/contracts/math/SafeMath.sol
177 
178 
179 pragma solidity ^0.6.0;
180 
181 /**
182  * @dev Wrappers over Solidity's arithmetic operations with added overflow
183  * checks.
184  *
185  * Arithmetic operations in Solidity wrap on overflow. This can easily result
186  * in bugs, because programmers usually assume that an overflow raises an
187  * error, which is the standard behavior in high level programming languages.
188  * `SafeMath` restores this intuition by reverting the transaction when an
189  * operation overflows.
190  *
191  * Using this library instead of the unchecked operations eliminates an entire
192  * class of bugs, so it's recommended to use it always.
193  */
194 library SafeMath {
195     /**
196      * @dev Returns the addition of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `+` operator.
200      *
201      * Requirements:
202      *
203      * - Addition cannot overflow.
204      */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         require(c >= a, "SafeMath: addition overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return sub(a, b, "SafeMath: subtraction overflow");
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      *
234      * - Subtraction cannot overflow.
235      */
236     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b <= a, errorMessage);
238         uint256 c = a - b;
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the multiplication of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `*` operator.
248      *
249      * Requirements:
250      *
251      * - Multiplication cannot overflow.
252      */
253     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
254         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
255         // benefit is lost if 'b' is also tested.
256         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
257         if (a == 0) {
258             return 0;
259         }
260 
261         uint256 c = a * b;
262         require(c / a == b, "SafeMath: multiplication overflow");
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers. Reverts on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function div(uint256 a, uint256 b) internal pure returns (uint256) {
280         return div(a, b, "SafeMath: division by zero");
281     }
282 
283     /**
284      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
285      * division by zero. The result is rounded towards zero.
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         uint256 c = a / b;
298         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * Reverts when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
316         return mod(a, b, "SafeMath: modulo by zero");
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321      * Reverts with custom message when dividing by zero.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b != 0, errorMessage);
333         return a % b;
334     }
335 }
336 
337 // File: @openzeppelin/contracts/utils/Address.sol
338 
339 
340 pragma solidity ^0.6.2;
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * [IMPORTANT]
350      * ====
351      * It is unsafe to assume that an address for which this function returns
352      * false is an externally-owned account (EOA) and not a contract.
353      *
354      * Among others, `isContract` will return false for the following
355      * types of addresses:
356      *
357      *  - an externally-owned account
358      *  - a contract in construction
359      *  - an address where a contract will be created
360      *  - an address where a contract lived, but was destroyed
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
365         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
366         // for accounts without code, i.e. `keccak256('')`
367         bytes32 codehash;
368         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
369         // solhint-disable-next-line no-inline-assembly
370         assembly { codehash := extcodehash(account) }
371         return (codehash != accountHash && codehash != 0x0);
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      */
390     function sendValue(address payable recipient, uint256 amount) internal {
391         require(address(this).balance >= amount, "Address: insufficient balance");
392 
393         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
394         (bool success, ) = recipient.call{ value: amount }("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain`call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417       return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
427         return _functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
447      * with `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
452         require(address(this).balance >= value, "Address: insufficient balance for call");
453         return _functionCallWithValue(target, data, value, errorMessage);
454     }
455 
456     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
457         require(isContract(target), "Address: call to non-contract");
458 
459         // solhint-disable-next-line avoid-low-level-calls
460         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 // solhint-disable-next-line no-inline-assembly
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
481 
482 
483 pragma solidity ^0.6.0;
484 
485 
486 
487 
488 /**
489  * @title SafeERC20
490  * @dev Wrappers around ERC20 operations that throw on failure (when the token
491  * contract returns false). Tokens that return no value (and instead revert or
492  * throw on failure) are also supported, non-reverting calls are assumed to be
493  * successful.
494  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
495  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
496  */
497 library SafeERC20 {
498     using SafeMath for uint256;
499     using Address for address;
500 
501     function safeTransfer(IERC20 token, address to, uint256 value) internal {
502         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
503     }
504 
505     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
506         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
507     }
508 
509     /**
510      * @dev Deprecated. This function has issues similar to the ones found in
511      * {IERC20-approve}, and its usage is discouraged.
512      *
513      * Whenever possible, use {safeIncreaseAllowance} and
514      * {safeDecreaseAllowance} instead.
515      */
516     function safeApprove(IERC20 token, address spender, uint256 value) internal {
517         // safeApprove should only be called when setting an initial allowance,
518         // or when resetting it to zero. To increase and decrease it, use
519         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
520         // solhint-disable-next-line max-line-length
521         require((value == 0) || (token.allowance(address(this), spender) == 0),
522             "SafeERC20: approve from non-zero to non-zero allowance"
523         );
524         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
525     }
526 
527     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).add(value);
529         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
530     }
531 
532     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
533         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
534         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
535     }
536 
537     /**
538      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
539      * on the return value: the return value is optional (but if data is returned, it must not be false).
540      * @param token The token targeted by the call.
541      * @param data The call data (encoded using abi.encode or one of its variants).
542      */
543     function _callOptionalReturn(IERC20 token, bytes memory data) private {
544         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
545         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
546         // the target address contains contract code and also asserts for success in the low-level call.
547 
548         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
549         if (returndata.length > 0) { // Return data is optional
550             // solhint-disable-next-line max-line-length
551             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
552         }
553     }
554 }
555 
556 // File: @openzeppelin/contracts/utils/Pausable.sol
557 
558 
559 pragma solidity ^0.6.0;
560 
561 
562 /**
563  * @dev Contract module which allows children to implement an emergency stop
564  * mechanism that can be triggered by an authorized account.
565  *
566  * This module is used through inheritance. It will make available the
567  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
568  * the functions of your contract. Note that they will not be pausable by
569  * simply including this module, only once the modifiers are put in place.
570  */
571 contract Pausable is Context {
572     /**
573      * @dev Emitted when the pause is triggered by `account`.
574      */
575     event Paused(address account);
576 
577     /**
578      * @dev Emitted when the pause is lifted by `account`.
579      */
580     event Unpaused(address account);
581 
582     bool private _paused;
583 
584     /**
585      * @dev Initializes the contract in unpaused state.
586      */
587     constructor () internal {
588         _paused = false;
589     }
590 
591     /**
592      * @dev Returns true if the contract is paused, and false otherwise.
593      */
594     function paused() public view returns (bool) {
595         return _paused;
596     }
597 
598     /**
599      * @dev Modifier to make a function callable only when the contract is not paused.
600      *
601      * Requirements:
602      *
603      * - The contract must not be paused.
604      */
605     modifier whenNotPaused() {
606         require(!_paused, "Pausable: paused");
607         _;
608     }
609 
610     /**
611      * @dev Modifier to make a function callable only when the contract is paused.
612      *
613      * Requirements:
614      *
615      * - The contract must be paused.
616      */
617     modifier whenPaused() {
618         require(_paused, "Pausable: not paused");
619         _;
620     }
621 
622     /**
623      * @dev Triggers stopped state.
624      *
625      * Requirements:
626      *
627      * - The contract must not be paused.
628      */
629     function _pause() internal virtual whenNotPaused {
630         _paused = true;
631         emit Paused(_msgSender());
632     }
633 
634     /**
635      * @dev Returns to normal state.
636      *
637      * Requirements:
638      *
639      * - The contract must be paused.
640      */
641     function _unpause() internal virtual whenPaused {
642         _paused = false;
643         emit Unpaused(_msgSender());
644     }
645 }
646 
647 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
648 
649 
650 pragma solidity ^0.6.0;
651 
652 /**
653  * @dev Contract module that helps prevent reentrant calls to a function.
654  *
655  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
656  * available, which can be applied to functions to make sure there are no nested
657  * (reentrant) calls to them.
658  *
659  * Note that because there is a single `nonReentrant` guard, functions marked as
660  * `nonReentrant` may not call one another. This can be worked around by making
661  * those functions `private`, and then adding `external` `nonReentrant` entry
662  * points to them.
663  *
664  * TIP: If you would like to learn more about reentrancy and alternative ways
665  * to protect against it, check out our blog post
666  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
667  */
668 contract ReentrancyGuard {
669     // Booleans are more expensive than uint256 or any type that takes up a full
670     // word because each write operation emits an extra SLOAD to first read the
671     // slot's contents, replace the bits taken up by the boolean, and then write
672     // back. This is the compiler's defense against contract upgrades and
673     // pointer aliasing, and it cannot be disabled.
674 
675     // The values being non-zero value makes deployment a bit more expensive,
676     // but in exchange the refund on every call to nonReentrant will be lower in
677     // amount. Since refunds are capped to a percentage of the total
678     // transaction's gas, it is best to keep them low in cases like this one, to
679     // increase the likelihood of the full refund coming into effect.
680     uint256 private constant _NOT_ENTERED = 1;
681     uint256 private constant _ENTERED = 2;
682 
683     uint256 private _status;
684 
685     constructor () internal {
686         _status = _NOT_ENTERED;
687     }
688 
689     /**
690      * @dev Prevents a contract from calling itself, directly or indirectly.
691      * Calling a `nonReentrant` function from another `nonReentrant`
692      * function is not supported. It is possible to prevent this from happening
693      * by making the `nonReentrant` function external, and make it call a
694      * `private` function that does the actual work.
695      */
696     modifier nonReentrant() {
697         // On the first call to nonReentrant, _notEntered will be true
698         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
699 
700         // Any calls to nonReentrant after this point will fail
701         _status = _ENTERED;
702 
703         _;
704 
705         // By storing the original value once again, a refund is triggered (see
706         // https://eips.ethereum.org/EIPS/eip-2200)
707         _status = _NOT_ENTERED;
708     }
709 }
710 
711 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
712 
713 
714 pragma solidity ^0.6.0;
715 
716 /**
717  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
718  *
719  * These functions can be used to verify that a message was signed by the holder
720  * of the private keys of a given address.
721  */
722 library ECDSA {
723     /**
724      * @dev Returns the address that signed a hashed message (`hash`) with
725      * `signature`. This address can then be used for verification purposes.
726      *
727      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
728      * this function rejects them by requiring the `s` value to be in the lower
729      * half order, and the `v` value to be either 27 or 28.
730      *
731      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
732      * verification to be secure: it is possible to craft signatures that
733      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
734      * this is by receiving a hash of the original message (which may otherwise
735      * be too long), and then calling {toEthSignedMessageHash} on it.
736      */
737     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
738         // Check the signature length
739         if (signature.length != 65) {
740             revert("ECDSA: invalid signature length");
741         }
742 
743         // Divide the signature in r, s and v variables
744         bytes32 r;
745         bytes32 s;
746         uint8 v;
747 
748         // ecrecover takes the signature parameters, and the only way to get them
749         // currently is to use assembly.
750         // solhint-disable-next-line no-inline-assembly
751         assembly {
752             r := mload(add(signature, 0x20))
753             s := mload(add(signature, 0x40))
754             v := byte(0, mload(add(signature, 0x60)))
755         }
756 
757         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
758         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
759         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
760         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
761         //
762         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
763         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
764         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
765         // these malleable signatures as well.
766         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
767             revert("ECDSA: invalid signature 's' value");
768         }
769 
770         if (v != 27 && v != 28) {
771             revert("ECDSA: invalid signature 'v' value");
772         }
773 
774         // If the signature is valid (and not malleable), return the signer address
775         address signer = ecrecover(hash, v, r, s);
776         require(signer != address(0), "ECDSA: invalid signature");
777 
778         return signer;
779     }
780 
781     /**
782      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
783      * replicates the behavior of the
784      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
785      * JSON-RPC method.
786      *
787      * See {recover}.
788      */
789     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
790         // 32 is the length in bytes of hash,
791         // enforced by the type signature above
792         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
793     }
794 }
795 
796 // File: contracts/SplTokenSwap.sol
797 
798 
799 pragma solidity ^0.6.0;
800 
801 
802 
803 
804 
805 
806 
807 contract SplTokenSwap is Ownable, Pausable, ReentrancyGuard {
808     using SafeERC20 for IERC20;
809 
810     event Swap(address indexed token, string recipient, uint amount);
811     event Withdraw(address indexed token, address indexed recipient, uint amount);
812     event NonceUsed(uint indexed nonce, bytes signature);
813 
814     mapping(uint256 => bool) usedNonces;
815 
816     function swapErc20(IERC20 token, string calldata recipient, uint amount) external nonReentrant whenNotPaused {
817         require(amount > 0, "Swap amount must be positive");
818         require(token.allowance(msg.sender, address(this)) >= amount, "Swap amount exceeds allowance");
819 
820         token.safeTransferFrom(msg.sender, address(this), amount);
821 
822         emit Swap(address(token), recipient, amount);
823     }
824 
825     function swapEth(string calldata recipient) external payable nonReentrant whenNotPaused {
826         uint amount = msg.value;
827         require(amount > 0, "Swap amount must be positive");
828 
829         emit Swap(address(0), recipient, amount);
830     }
831 
832     function withdrawErc20(IERC20 token, address recipient, uint amount, uint nonce, bytes calldata signature) external nonReentrant whenNotPaused {
833         bytes32 message = keccak256(abi.encodePacked("withdrawErc20", this, address(token), recipient, amount, nonce));
834         bytes32 hash = ECDSA.toEthSignedMessageHash(message);
835         address signer = ECDSA.recover(hash, signature);
836         require(signer == this.owner(), "Invalid signature");
837 
838         require(!usedNonces[nonce], "Duplicate nonce");
839         usedNonces[nonce] = true;
840         emit NonceUsed(nonce, signature);
841 
842         token.safeTransfer(recipient, amount);
843         emit Withdraw(address(token), recipient, amount);
844     }
845 
846     function withdrawEth(address payable recipient, uint amount, uint nonce, bytes calldata signature) external nonReentrant whenNotPaused {
847         bytes32 message = keccak256(abi.encodePacked("withdrawEth", this, recipient, amount, nonce));
848         bytes32 hash = ECDSA.toEthSignedMessageHash(message);
849         address signer = ECDSA.recover(hash, signature);
850         require(signer == this.owner(), "Invalid signature");
851 
852         require(!usedNonces[nonce], "Duplicate nonce");
853         usedNonces[nonce] = true;
854         emit NonceUsed(nonce, signature);
855 
856         recipient.transfer(amount);
857         emit Withdraw(address(0), recipient, amount);
858     }
859 
860     function pause() external onlyOwner {
861         _pause();
862     }
863 
864     function unpause() external onlyOwner {
865         _unpause();
866     }
867 
868     function ownerWithdrawErc20(IERC20 token, uint amount) external onlyOwner {
869         token.safeTransfer(msg.sender, amount);
870         emit Withdraw(address(token), msg.sender, amount);
871     }
872 
873     function ownerWithdrawEth(uint amount) external onlyOwner {
874         msg.sender.transfer(amount);
875         emit Withdraw(address(0), msg.sender, amount);
876     }
877 }