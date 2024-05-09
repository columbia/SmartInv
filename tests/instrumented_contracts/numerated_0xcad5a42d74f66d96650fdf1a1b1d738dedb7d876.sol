1 // File: @openzeppelin\contracts\math\SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.6.12;
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
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
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      *
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      *
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
163 
164 
165 /**
166  * @dev Interface of the ERC20 standard as defined in the EIP.
167  */
168 interface IERC20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address recipient, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 
240 
241 
242 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
243 
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies in extcodesize, which returns 0 for contracts in
268         // construction, since the code is only stored at the end of the
269         // constructor execution.
270 
271         uint256 size;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { size := extcodesize(account) }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
384 
385 
386 
387 
388 
389 /**
390  * @title SafeERC20
391  * @dev Wrappers around ERC20 operations that throw on failure (when the token
392  * contract returns false). Tokens that return no value (and instead revert or
393  * throw on failure) are also supported, non-reverting calls are assumed to be
394  * successful.
395  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
396  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
397  */
398 library SafeERC20 {
399     using SafeMath for uint256;
400     using Address for address;
401 
402     function safeTransfer(IERC20 token, address to, uint256 value) internal {
403         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
404     }
405 
406     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
407         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
408     }
409 
410     /**
411      * @dev Deprecated. This function has issues similar to the ones found in
412      * {IERC20-approve}, and its usage is discouraged.
413      *
414      * Whenever possible, use {safeIncreaseAllowance} and
415      * {safeDecreaseAllowance} instead.
416      */
417     function safeApprove(IERC20 token, address spender, uint256 value) internal {
418         // safeApprove should only be called when setting an initial allowance,
419         // or when resetting it to zero. To increase and decrease it, use
420         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
421         // solhint-disable-next-line max-line-length
422         require((value == 0) || (token.allowance(address(this), spender) == 0),
423             "SafeERC20: approve from non-zero to non-zero allowance"
424         );
425         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
426     }
427 
428     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
429         uint256 newAllowance = token.allowance(address(this), spender).add(value);
430         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
431     }
432 
433     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
434         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
436     }
437 
438     /**
439      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
440      * on the return value: the return value is optional (but if data is returned, it must not be false).
441      * @param token The token targeted by the call.
442      * @param data The call data (encoded using abi.encode or one of its variants).
443      */
444     function _callOptionalReturn(IERC20 token, bytes memory data) private {
445         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
446         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
447         // the target address contains contract code and also asserts for success in the low-level call.
448 
449         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
450         if (returndata.length > 0) { // Return data is optional
451             // solhint-disable-next-line max-line-length
452             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
453         }
454     }
455 }
456 
457 
458 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
459 
460 
461 
462 /*
463  * @dev Provides information about the current execution context, including the
464  * sender of the transaction and its data. While these are generally available
465  * via msg.sender and msg.data, they should not be accessed in such a direct
466  * manner, since when dealing with GSN meta-transactions the account sending and
467  * paying for execution may not be the actual sender (as far as an application
468  * is concerned).
469  *
470  * This contract is only required for intermediate, library-like contracts.
471  */
472 abstract contract Context {
473     function _msgSender() internal view virtual returns (address payable) {
474         return msg.sender;
475     }
476 
477     function _msgData() internal view virtual returns (bytes memory) {
478         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
479         return msg.data;
480     }
481 }
482 
483 // File: @openzeppelin\contracts\utils\Pausable.sol
484 
485 
486 
487 /**
488  * @dev Contract module which allows children to implement an emergency stop
489  * mechanism that can be triggered by an authorized account.
490  *
491  * This module is used through inheritance. It will make available the
492  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
493  * the functions of your contract. Note that they will not be pausable by
494  * simply including this module, only once the modifiers are put in place.
495  */
496 contract Pausable is Context {
497     /**
498      * @dev Emitted when the pause is triggered by `account`.
499      */
500     event Paused(address account);
501 
502     /**
503      * @dev Emitted when the pause is lifted by `account`.
504      */
505     event Unpaused(address account);
506 
507     bool private _paused;
508 
509     /**
510      * @dev Initializes the contract in unpaused state.
511      */
512     constructor () internal {
513         _paused = false;
514     }
515 
516     /**
517      * @dev Returns true if the contract is paused, and false otherwise.
518      */
519     function paused() public view returns (bool) {
520         return _paused;
521     }
522 
523     /**
524      * @dev Modifier to make a function callable only when the contract is not paused.
525      *
526      * Requirements:
527      *
528      * - The contract must not be paused.
529      */
530     modifier whenNotPaused() {
531         require(!_paused, "Pausable: paused");
532         _;
533     }
534 
535     /**
536      * @dev Modifier to make a function callable only when the contract is paused.
537      *
538      * Requirements:
539      *
540      * - The contract must be paused.
541      */
542     modifier whenPaused() {
543         require(_paused, "Pausable: not paused");
544         _;
545     }
546 
547     /**
548      * @dev Triggers stopped state.
549      *
550      * Requirements:
551      *
552      * - The contract must not be paused.
553      */
554     function _pause() internal virtual whenNotPaused {
555         _paused = true;
556         emit Paused(_msgSender());
557     }
558 
559     /**
560      * @dev Returns to normal state.
561      *
562      * Requirements:
563      *
564      * - The contract must be paused.
565      */
566     function _unpause() internal virtual whenPaused {
567         _paused = false;
568         emit Unpaused(_msgSender());
569     }
570 }
571 
572 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
573 
574 
575 
576 /**
577  * @dev Contract module that helps prevent reentrant calls to a function.
578  *
579  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
580  * available, which can be applied to functions to make sure there are no nested
581  * (reentrant) calls to them.
582  *
583  * Note that because there is a single `nonReentrant` guard, functions marked as
584  * `nonReentrant` may not call one another. This can be worked around by making
585  * those functions `private`, and then adding `external` `nonReentrant` entry
586  * points to them.
587  *
588  * TIP: If you would like to learn more about reentrancy and alternative ways
589  * to protect against it, check out our blog post
590  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
591  */
592 contract ReentrancyGuard {
593     // Booleans are more expensive than uint256 or any type that takes up a full
594     // word because each write operation emits an extra SLOAD to first read the
595     // slot's contents, replace the bits taken up by the boolean, and then write
596     // back. This is the compiler's defense against contract upgrades and
597     // pointer aliasing, and it cannot be disabled.
598 
599     // The values being non-zero value makes deployment a bit more expensive,
600     // but in exchange the refund on every call to nonReentrant will be lower in
601     // amount. Since refunds are capped to a percentage of the total
602     // transaction's gas, it is best to keep them low in cases like this one, to
603     // increase the likelihood of the full refund coming into effect.
604     uint256 private constant _NOT_ENTERED = 1;
605     uint256 private constant _ENTERED = 2;
606 
607     uint256 private _status;
608 
609     constructor () internal {
610         _status = _NOT_ENTERED;
611     }
612 
613     /**
614      * @dev Prevents a contract from calling itself, directly or indirectly.
615      * Calling a `nonReentrant` function from another `nonReentrant`
616      * function is not supported. It is possible to prevent this from happening
617      * by making the `nonReentrant` function external, and make it call a
618      * `private` function that does the actual work.
619      */
620     modifier nonReentrant() {
621         // On the first call to nonReentrant, _notEntered will be true
622         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
623 
624         // Any calls to nonReentrant after this point will fail
625         _status = _ENTERED;
626 
627         _;
628 
629         // By storing the original value once again, a refund is triggered (see
630         // https://eips.ethereum.org/EIPS/eip-2200)
631         _status = _NOT_ENTERED;
632     }
633 }
634 
635 // File: @openzeppelin\contracts\access\Ownable.sol
636 
637 
638 
639 /**
640  * @dev Contract module which provides a basic access control mechanism, where
641  * there is an account (an owner) that can be granted exclusive access to
642  * specific functions.
643  *
644  * By default, the owner account will be the one that deploys the contract. This
645  * can later be changed with {transferOwnership}.
646  *
647  * This module is used through inheritance. It will make available the modifier
648  * `onlyOwner`, which can be applied to your functions to restrict their use to
649  * the owner.
650  */
651 contract Ownable is Context {
652     address private _owner;
653 
654     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
655 
656     /**
657      * @dev Initializes the contract setting the deployer as the initial owner.
658      */
659     constructor () internal {
660         address msgSender = _msgSender();
661         _owner = msgSender;
662         emit OwnershipTransferred(address(0), msgSender);
663     }
664 
665     /**
666      * @dev Returns the address of the current owner.
667      */
668     function owner() public view returns (address) {
669         return _owner;
670     }
671 
672     /**
673      * @dev Throws if called by any account other than the owner.
674      */
675     modifier onlyOwner() {
676         require(_owner == _msgSender(), "Ownable: caller is not the owner");
677         _;
678     }
679 
680     /**
681      * @dev Leaves the contract without owner. It will not be possible to call
682      * `onlyOwner` functions anymore. Can only be called by the current owner.
683      *
684      * NOTE: Renouncing ownership will leave the contract without an owner,
685      * thereby removing any functionality that is only available to the owner.
686      */
687     function renounceOwnership() public virtual onlyOwner {
688         emit OwnershipTransferred(_owner, address(0));
689         _owner = address(0);
690     }
691 
692     /**
693      * @dev Transfers ownership of the contract to a new account (`newOwner`).
694      * Can only be called by the current owner.
695      */
696     function transferOwnership(address newOwner) public virtual onlyOwner {
697         require(newOwner != address(0), "Ownable: new owner is the zero address");
698         emit OwnershipTransferred(_owner, newOwner);
699         _owner = newOwner;
700     }
701     
702     /**
703      * @dev Internal function that forces an ownership change. Can be used to
704      * implement custom ownership management logic in childs contracts.
705      */
706     function _setOwner(address newOwner) internal virtual {
707         emit OwnershipTransferred(_owner, newOwner);
708         _owner = newOwner;
709     }
710 }
711 
712 // File: @openzeppelin\contracts\proxy\Initializable.sol
713 
714 
715 
716 /**
717  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
718  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
719  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
720  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
721  * 
722  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
723  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
724  * 
725  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
726  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
727  */
728 abstract contract Initializable {
729 
730     /**
731      * @dev Indicates that the contract has been initialized.
732      */
733     bool private _initialized;
734 
735     /**
736      * @dev Indicates that the contract is in the process of being initialized.
737      */
738     bool private _initializing;
739 
740     /**
741      * @dev Modifier to protect an initializer function from being invoked twice.
742      */
743     modifier initializer() {
744         require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");
745 
746         bool isTopLevelCall = !_initializing;
747         if (isTopLevelCall) {
748             _initializing = true;
749             _initialized = true;
750         }
751 
752         _;
753 
754         if (isTopLevelCall) {
755             _initializing = false;
756         }
757     }
758 
759     /// @dev Returns true if and only if the function is running in the constructor
760     function _isConstructor() private view returns (bool) {
761         // extcodesize checks the size of the code stored in an address, and
762         // address returns the current address. Since the code is still not
763         // deployed when running a constructor, any checks on its code size will
764         // yield zero, making it an effective way to detect if a contract is
765         // under construction or not.
766         address self = address(this);
767         uint256 cs;
768         // solhint-disable-next-line no-inline-assembly
769         assembly { cs := extcodesize(self) }
770         return cs == 0;
771     }
772 }
773 
774 
775 
776 // File: node_modules\@openzeppelin\contracts\proxy\Proxy.sol
777 
778 
779 /**
780  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
781  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
782  * be specified by overriding the virtual {_implementation} function.
783  * 
784  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
785  * different contract through the {_delegate} function.
786  * 
787  * The success and return data of the delegated call will be returned back to the caller of the proxy.
788  */
789 abstract contract Proxy {
790     /**
791      * @dev Delegates the current call to `implementation`.
792      * 
793      * This function does not return to its internall call site, it will return directly to the external caller.
794      */
795     function _delegate(address implementation) internal {
796         // solhint-disable-next-line no-inline-assembly
797         assembly {
798             // Copy msg.data. We take full control of memory in this inline assembly
799             // block because it will not return to Solidity code. We overwrite the
800             // Solidity scratch pad at memory position 0.
801             calldatacopy(0, 0, calldatasize())
802 
803             // Call the implementation.
804             // out and outsize are 0 because we don't know the size yet.
805             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
806 
807             // Copy the returned data.
808             returndatacopy(0, 0, returndatasize())
809 
810             switch result
811             // delegatecall returns 0 on error.
812             case 0 { revert(0, returndatasize()) }
813             default { return(0, returndatasize()) }
814         }
815     }
816 
817     /**
818      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
819      * and {_fallback} should delegate.
820      */
821     function _implementation() internal virtual view returns (address);
822 
823     /**
824      * @dev Delegates the current call to the address returned by `_implementation()`.
825      * 
826      * This function does not return to its internall call site, it will return directly to the external caller.
827      */
828     function _fallback() internal {
829         _beforeFallback();
830         _delegate(_implementation());
831     }
832 
833     /**
834      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
835      * function in the contract matches the call data.
836      */
837     fallback () payable external {
838         _fallback();
839     }
840 
841     /**
842      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
843      * is empty.
844      */
845     receive () payable external {
846         _fallback();
847     }
848 
849     /**
850      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
851      * call, or as part of the Solidity `fallback` or `receive` functions.
852      * 
853      * If overriden should call `super._beforeFallback()`.
854      */
855     function _beforeFallback() internal virtual {
856     }
857 }
858 
859 // File: node_modules\@openzeppelin\contracts\proxy\UpgradeableProxy.sol
860 
861 
862 
863 
864 /**
865  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
866  * implementation address that can be changed. This address is stored in storage in the location specified by
867  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
868  * implementation behind the proxy.
869  * 
870  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
871  * {TransparentUpgradeableProxy}.
872  */
873 contract UpgradeableProxy is Proxy {
874     /**
875      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
876      * 
877      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
878      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
879      */
880     constructor(address _logic, bytes memory _data) public payable {
881         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
882         _setImplementation(_logic);
883         if(_data.length > 0) {
884             // solhint-disable-next-line avoid-low-level-calls
885             (bool success,) = _logic.delegatecall(_data);
886             require(success);
887         }
888     }
889 
890     /**
891      * @dev Emitted when the implementation is upgraded.
892      */
893     event Upgraded(address indexed implementation);
894 
895     /**
896      * @dev Storage slot with the address of the current implementation.
897      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
898      * validated in the constructor.
899      */
900     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
901 
902     /**
903      * @dev Returns the current implementation address.
904      */
905     function _implementation() internal override view returns (address impl) {
906         bytes32 slot = _IMPLEMENTATION_SLOT;
907         // solhint-disable-next-line no-inline-assembly
908         assembly {
909             impl := sload(slot)
910         }
911     }
912 
913     /**
914      * @dev Upgrades the proxy to a new implementation.
915      * 
916      * Emits an {Upgraded} event.
917      */
918     function _upgradeTo(address newImplementation) internal {
919         _setImplementation(newImplementation);
920         emit Upgraded(newImplementation);
921     }
922 
923     /**
924      * @dev Stores a new address in the EIP1967 implementation slot.
925      */
926     function _setImplementation(address newImplementation) private {
927         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
928 
929         bytes32 slot = _IMPLEMENTATION_SLOT;
930 
931         // solhint-disable-next-line no-inline-assembly
932         assembly {
933             sstore(slot, newImplementation)
934         }
935     }
936 }
937 
938 // File: node_modules\@openzeppelin\contracts\proxy\TransparentUpgradeableProxy.sol
939 
940 
941 
942 /**
943  * @dev This contract implements a proxy that is upgradeable by an admin.
944  * 
945  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
946  * clashing], which can potentially be used in an attack, this contract uses the
947  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
948  * things that go hand in hand:
949  * 
950  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
951  * that call matches one of the admin functions exposed by the proxy itself.
952  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
953  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
954  * "admin cannot fallback to proxy target".
955  * 
956  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
957  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
958  * to sudden errors when trying to call a function from the proxy implementation.
959  * 
960  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
961  * you should think of the `ProxyAdmin` instance as the real administrative inerface of your proxy.
962  */
963 contract TransparentUpgradeableProxy is UpgradeableProxy {
964     /**
965      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
966      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
967      */
968     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
969         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
970         _setAdmin(_admin);
971     }
972 
973     /**
974      * @dev Emitted when the admin account has changed.
975      */
976     event AdminChanged(address previousAdmin, address newAdmin);
977 
978     /**
979      * @dev Storage slot with the admin of the contract.
980      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
981      * validated in the constructor.
982      */
983     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
984 
985     /**
986      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
987      */
988     modifier ifAdmin() {
989         if (msg.sender == _admin()) {
990             _;
991         } else {
992             _fallback();
993         }
994     }
995 
996     /**
997      * @dev Returns the current admin.
998      * 
999      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
1000      * 
1001      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
1002      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
1003      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
1004      */
1005     function admin() external ifAdmin returns (address) {
1006         return _admin();
1007     }
1008 
1009     /**
1010      * @dev Returns the current implementation.
1011      * 
1012      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
1013      * 
1014      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
1015      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
1016      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
1017      */
1018     function implementation() external ifAdmin returns (address) {
1019         return _implementation();
1020     }
1021 
1022     /**
1023      * @dev Changes the admin of the proxy.
1024      * 
1025      * Emits an {AdminChanged} event.
1026      * 
1027      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
1028      */
1029     function changeAdmin(address newAdmin) external ifAdmin {
1030         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
1031         emit AdminChanged(_admin(), newAdmin);
1032         _setAdmin(newAdmin);
1033     }
1034 
1035     /**
1036      * @dev Upgrade the implementation of the proxy.
1037      * 
1038      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
1039      */
1040     function upgradeTo(address newImplementation) external ifAdmin {
1041         _upgradeTo(newImplementation);
1042     }
1043 
1044     /**
1045      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
1046      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
1047      * proxied contract.
1048      * 
1049      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
1050      */
1051     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
1052         _upgradeTo(newImplementation);
1053         // solhint-disable-next-line avoid-low-level-calls
1054         (bool success,) = newImplementation.delegatecall(data);
1055         require(success);
1056     }
1057 
1058     /**
1059      * @dev Returns the current admin.
1060      */
1061     function _admin() internal view returns (address adm) {
1062         bytes32 slot = _ADMIN_SLOT;
1063         // solhint-disable-next-line no-inline-assembly
1064         assembly {
1065             adm := sload(slot)
1066         }
1067     }
1068 
1069     /**
1070      * @dev Stores a new address in the EIP1967 admin slot.
1071      */
1072     function _setAdmin(address newAdmin) private {
1073         bytes32 slot = _ADMIN_SLOT;
1074 
1075         // solhint-disable-next-line no-inline-assembly
1076         assembly {
1077             sstore(slot, newAdmin)
1078         }
1079     }
1080 
1081     /**
1082      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
1083      */
1084     function _beforeFallback() internal override virtual {
1085         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
1086         super._beforeFallback();
1087     }
1088 }
1089 
1090 // File: @openzeppelin\contracts\proxy\ProxyAdmin.sol
1091 
1092 
1093 
1094 
1095 /**
1096  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
1097  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
1098  */
1099 contract ProxyAdmin is Ownable {
1100 
1101     /**
1102      * @dev Returns the current implementation of `proxy`.
1103      * 
1104      * Requirements:
1105      * 
1106      * - This contract must be the admin of `proxy`.
1107      */
1108     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view returns (address) {
1109         // We need to manually run the static call since the getter cannot be flagged as view
1110         // bytes4(keccak256("implementation()")) == 0x5c60da1b
1111         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
1112         require(success);
1113         return abi.decode(returndata, (address));
1114     }
1115 
1116     /**
1117      * @dev Returns the current admin of `proxy`.
1118      * 
1119      * Requirements:
1120      * 
1121      * - This contract must be the admin of `proxy`.
1122      */
1123     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view returns (address) {
1124         // We need to manually run the static call since the getter cannot be flagged as view
1125         // bytes4(keccak256("admin()")) == 0xf851a440
1126         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
1127         require(success);
1128         return abi.decode(returndata, (address));
1129     }
1130 
1131     /**
1132      * @dev Changes the admin of `proxy` to `newAdmin`.
1133      * 
1134      * Requirements:
1135      * 
1136      * - This contract must be the current admin of `proxy`.
1137      */
1138     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public onlyOwner {
1139         proxy.changeAdmin(newAdmin);
1140     }
1141 
1142     /**
1143      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
1144      * 
1145      * Requirements:
1146      * 
1147      * - This contract must be the admin of `proxy`.
1148      */
1149     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public onlyOwner {
1150         proxy.upgradeTo(implementation);
1151     }
1152 
1153     /**
1154      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
1155      * {TransparentUpgradeableProxy-upgradeToAndCall}.
1156      * 
1157      * Requirements:
1158      * 
1159      * - This contract must be the admin of `proxy`.
1160      */
1161     function upgradeAndCall(TransparentUpgradeableProxy proxy, address implementation, bytes memory data) public payable onlyOwner {
1162         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
1163     }
1164 }
1165 
1166 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
1167 
1168 
1169 
1170 
1171 
1172 
1173 /**
1174  * @dev Implementation of the {IERC20} interface.
1175  *
1176  * This implementation is agnostic to the way tokens are created. This means
1177  * that a supply mechanism has to be added in a derived contract using {_mint}.
1178  * For a generic mechanism see {ERC20PresetMinterPauser}.
1179  *
1180  * TIP: For a detailed writeup see our guide
1181  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1182  * to implement supply mechanisms].
1183  *
1184  * We have followed general OpenZeppelin guidelines: functions revert instead
1185  * of returning `false` on failure. This behavior is nonetheless conventional
1186  * and does not conflict with the expectations of ERC20 applications.
1187  *
1188  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1189  * This allows applications to reconstruct the allowance for all accounts just
1190  * by listening to said events. Other implementations of the EIP may not emit
1191  * these events, as it isn't required by the specification.
1192  *
1193  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1194  * functions have been added to mitigate the well-known issues around setting
1195  * allowances. See {IERC20-approve}.
1196  */
1197 contract ERC20 is Context, IERC20 {
1198     using SafeMath for uint256;
1199     using Address for address;
1200 
1201     mapping (address => uint256) private _balances;
1202 
1203     mapping (address => mapping (address => uint256)) private _allowances;
1204 
1205     uint256 private _totalSupply;
1206 
1207     string private _name;
1208     string private _symbol;
1209     uint8 private _decimals;
1210 
1211     /**
1212      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1213      * a default value of 18.
1214      *
1215      * To select a different value for {decimals}, use {_setupDecimals}.
1216      *
1217      * All three of these values are immutable: they can only be set once during
1218      * construction.
1219      */
1220     constructor (string memory name, string memory symbol) public {
1221         _name = name;
1222         _symbol = symbol;
1223         _decimals = 18;
1224     }
1225 
1226     /**
1227      * @dev Returns the name of the token.
1228      */
1229     function name() public view returns (string memory) {
1230         return _name;
1231     }
1232 
1233     /**
1234      * @dev Returns the symbol of the token, usually a shorter version of the
1235      * name.
1236      */
1237     function symbol() public view returns (string memory) {
1238         return _symbol;
1239     }
1240 
1241     /**
1242      * @dev Returns the number of decimals used to get its user representation.
1243      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1244      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1245      *
1246      * Tokens usually opt for a value of 18, imitating the relationship between
1247      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1248      * called.
1249      *
1250      * NOTE: This information is only used for _display_ purposes: it in
1251      * no way affects any of the arithmetic of the contract, including
1252      * {IERC20-balanceOf} and {IERC20-transfer}.
1253      */
1254     function decimals() public view returns (uint8) {
1255         return _decimals;
1256     }
1257 
1258     /**
1259      * @dev See {IERC20-totalSupply}.
1260      */
1261     function totalSupply() public view override returns (uint256) {
1262         return _totalSupply;
1263     }
1264 
1265     /**
1266      * @dev See {IERC20-balanceOf}.
1267      */
1268     function balanceOf(address account) public view override returns (uint256) {
1269         return _balances[account];
1270     }
1271 
1272     /**
1273      * @dev See {IERC20-transfer}.
1274      *
1275      * Requirements:
1276      *
1277      * - `recipient` cannot be the zero address.
1278      * - the caller must have a balance of at least `amount`.
1279      */
1280     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1281         _transfer(_msgSender(), recipient, amount);
1282         return true;
1283     }
1284 
1285     /**
1286      * @dev See {IERC20-allowance}.
1287      */
1288     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1289         return _allowances[owner][spender];
1290     }
1291 
1292     /**
1293      * @dev See {IERC20-approve}.
1294      *
1295      * Requirements:
1296      *
1297      * - `spender` cannot be the zero address.
1298      */
1299     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1300         _approve(_msgSender(), spender, amount);
1301         return true;
1302     }
1303 
1304     /**
1305      * @dev See {IERC20-transferFrom}.
1306      *
1307      * Emits an {Approval} event indicating the updated allowance. This is not
1308      * required by the EIP. See the note at the beginning of {ERC20};
1309      *
1310      * Requirements:
1311      * - `sender` and `recipient` cannot be the zero address.
1312      * - `sender` must have a balance of at least `amount`.
1313      * - the caller must have allowance for ``sender``'s tokens of at least
1314      * `amount`.
1315      */
1316     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1317         _transfer(sender, recipient, amount);
1318         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1319         return true;
1320     }
1321 
1322     /**
1323      * @dev Atomically increases the allowance granted to `spender` by the caller.
1324      *
1325      * This is an alternative to {approve} that can be used as a mitigation for
1326      * problems described in {IERC20-approve}.
1327      *
1328      * Emits an {Approval} event indicating the updated allowance.
1329      *
1330      * Requirements:
1331      *
1332      * - `spender` cannot be the zero address.
1333      */
1334     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1335         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1336         return true;
1337     }
1338 
1339     /**
1340      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1341      *
1342      * This is an alternative to {approve} that can be used as a mitigation for
1343      * problems described in {IERC20-approve}.
1344      *
1345      * Emits an {Approval} event indicating the updated allowance.
1346      *
1347      * Requirements:
1348      *
1349      * - `spender` cannot be the zero address.
1350      * - `spender` must have allowance for the caller of at least
1351      * `subtractedValue`.
1352      */
1353     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1354         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1355         return true;
1356     }
1357 
1358     /**
1359      * @dev Moves tokens `amount` from `sender` to `recipient`.
1360      *
1361      * This is internal function is equivalent to {transfer}, and can be used to
1362      * e.g. implement automatic token fees, slashing mechanisms, etc.
1363      *
1364      * Emits a {Transfer} event.
1365      *
1366      * Requirements:
1367      *
1368      * - `sender` cannot be the zero address.
1369      * - `recipient` cannot be the zero address.
1370      * - `sender` must have a balance of at least `amount`.
1371      */
1372     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1373         require(sender != address(0), "ERC20: transfer from the zero address");
1374         require(recipient != address(0), "ERC20: transfer to the zero address");
1375 
1376         _beforeTokenTransfer(sender, recipient, amount);
1377 
1378         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1379         _balances[recipient] = _balances[recipient].add(amount);
1380         emit Transfer(sender, recipient, amount);
1381     }
1382 
1383     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1384      * the total supply.
1385      *
1386      * Emits a {Transfer} event with `from` set to the zero address.
1387      *
1388      * Requirements
1389      *
1390      * - `to` cannot be the zero address.
1391      */
1392     function _mint(address account, uint256 amount) internal virtual {
1393         require(account != address(0), "ERC20: mint to the zero address");
1394 
1395         _beforeTokenTransfer(address(0), account, amount);
1396 
1397         _totalSupply = _totalSupply.add(amount);
1398         _balances[account] = _balances[account].add(amount);
1399         emit Transfer(address(0), account, amount);
1400     }
1401 
1402     /**
1403      * @dev Destroys `amount` tokens from `account`, reducing the
1404      * total supply.
1405      *
1406      * Emits a {Transfer} event with `to` set to the zero address.
1407      *
1408      * Requirements
1409      *
1410      * - `account` cannot be the zero address.
1411      * - `account` must have at least `amount` tokens.
1412      */
1413     function _burn(address account, uint256 amount) internal virtual {
1414         require(account != address(0), "ERC20: burn from the zero address");
1415 
1416         _beforeTokenTransfer(account, address(0), amount);
1417 
1418         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1419         _totalSupply = _totalSupply.sub(amount);
1420         emit Transfer(account, address(0), amount);
1421     }
1422 
1423     /**
1424      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1425      *
1426      * This internal function is equivalent to `approve`, and can be used to
1427      * e.g. set automatic allowances for certain subsystems, etc.
1428      *
1429      * Emits an {Approval} event.
1430      *
1431      * Requirements:
1432      *
1433      * - `owner` cannot be the zero address.
1434      * - `spender` cannot be the zero address.
1435      */
1436     function _approve(address owner, address spender, uint256 amount) internal virtual {
1437         require(owner != address(0), "ERC20: approve from the zero address");
1438         require(spender != address(0), "ERC20: approve to the zero address");
1439 
1440         _allowances[owner][spender] = amount;
1441         emit Approval(owner, spender, amount);
1442     }
1443 
1444     /**
1445      * @dev Sets {decimals} to a value other than the default one of 18.
1446      *
1447      * WARNING: This function should only be called from the constructor. Most
1448      * applications that interact with token contracts will not expect
1449      * {decimals} to ever change, and may work incorrectly if it does.
1450      */
1451     function _setupDecimals(uint8 decimals_) internal {
1452         _decimals = decimals_;
1453     }
1454 
1455     /**
1456      * @dev Hook that is called before any transfer of tokens. This includes
1457      * minting and burning.
1458      *
1459      * Calling conditions:
1460      *
1461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1462      * will be to transferred to `to`.
1463      * - when `from` is zero, `amount` tokens will be minted for `to`.
1464      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1465      * - `from` and `to` are never both zero.
1466      *
1467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1468      */
1469     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1470 }
1471 
1472 // File: contracts\SeeleToken.sol
1473 
1474 
1475 
1476 contract SeeleERC20 is ERC20 {
1477     uint256 MAX_UINT = 2**256 - 1;
1478 
1479     constructor(
1480         address bridgeAddress_,
1481         string memory name_,
1482         string memory symbol_,
1483         uint8 decimals_
1484     ) public ERC20(name_, symbol_) {
1485         _setupDecimals(decimals_);
1486         _mint(bridgeAddress_, MAX_UINT);
1487     }
1488 }
1489 
1490 // File: contracts\SeeleBridge.sol
1491 
1492 
1493 
1494 
1495 
1496 pragma experimental ABIEncoderV2;
1497 
1498 // This is being used purely to avoid stack too deep errors
1499 struct LogicCallArgs {
1500     // Transfers out to the logic contract
1501     uint256[] transferAmounts;
1502     address[] transferTokenContracts;
1503     // The fees (transferred to msg.sender)
1504     uint256[] feeAmounts;
1505     address[] feeTokenContracts;
1506     // The arbitrary logic call
1507     address logicContractAddress;
1508     bytes payload;
1509     // Invalidation metadata
1510     uint256 timeOut;
1511     bytes32 invalidationId;
1512     uint256 invalidationNonce;
1513 }
1514 
1515 contract SeeleBridge is Initializable, Pausable, Ownable, ReentrancyGuard {
1516     using SafeMath for uint256;
1517     using SafeERC20 for IERC20;
1518 
1519     // These are updated often
1520     bytes32 public state_lastValsetCheckpoint;
1521     mapping(address => uint256) public state_lastBatchNonces;
1522     mapping(bytes32 => uint256) public state_invalidationMapping;
1523     uint256 public state_lastValsetNonce = 0;
1524     // event nonce zero is reserved by the bridge module as a special
1525     // value indicating that no events have yet been submitted
1526     uint256 public state_lastEventNonce = 1;
1527 
1528     // These are set once at initialization
1529     bytes32 public state_bridgeId;
1530     uint256 public state_powerThreshold;
1531 
1532     /*
1533      * @notice mapping to keep track of whitelisted tokens
1534      */
1535     mapping(address => bool) private _ethereumTokenWhiteList;
1536 
1537     event WhiteListUpdateEvent(address _token, bool _value);
1538     // TransactionBatchExecutedEvent and SendToSeeleEvent both include the field _eventNonce.
1539     // This is incremented every time one of these events is emitted. It is checked by the
1540     // bridge module to ensure that all events are received in order, and that none are lost.
1541     //
1542     // ValsetUpdatedEvent does not include the field _eventNonce because it is never submitted to the Bridge
1543     // module. It is purely for the use of relayers to allow them to successfully submit batches.
1544     event TransactionBatchExecutedEvent(
1545         uint256 indexed _batchNonce,
1546         address indexed _token,
1547         uint256 _eventNonce
1548     );
1549     event SendToSeeleEvent(
1550         address indexed _tokenContract,
1551         address indexed _sender,
1552         address indexed _destination,
1553         uint256 _amount,
1554         uint256 _eventNonce
1555     );
1556     event ERC20DeployedEvent(
1557         // FYI: Can't index on a string without doing a bunch of weird stuff
1558         string _seeleDenom,
1559         address indexed _tokenContract,
1560         string _name,
1561         string _symbol,
1562         uint8 _decimals,
1563         uint256 _eventNonce
1564     );
1565     event ValsetUpdatedEvent(
1566         uint256 indexed _newValsetNonce,
1567         uint256 _eventNonce,
1568         address[] _validators,
1569         uint256[] _powers
1570     );
1571     event LogicCallEvent(
1572         bytes32 _invalidationId,
1573         uint256 _invalidationNonce,
1574         bytes _returnData,
1575         uint256 _eventNonce
1576     );
1577 
1578     function initialize() external initializer {
1579         _setOwner(msg.sender);
1580     }
1581     
1582     function initialize(
1583         // A unique identifier for this bridge instance to use in signatures
1584         bytes32 _bridgeId,
1585         // How much voting power is needed to approve operations
1586         uint256 _powerThreshold,
1587         // The validator set, not in valset args format since many of it's
1588         // arguments would never be used in this case
1589         address[] calldata _validators,
1590         uint256[] memory _powers
1591     ) external onlyOwner {
1592         // CHECKS
1593 
1594         // Check that validators, powers, and signatures (v,r,s) set is well-formed
1595         require(
1596             _validators.length == _powers.length,
1597             "Malformed current validator set"
1598         );
1599 
1600         // Check cumulative power to ensure the contract has sufficient power to actually
1601         // pass a vote
1602         uint256 cumulativePower = 0;
1603         for (uint256 i = 0; i < _powers.length; i++) {
1604             cumulativePower = cumulativePower + _powers[i];
1605             if (cumulativePower > _powerThreshold) {
1606                 break;
1607             }
1608         }
1609 
1610         require(
1611             cumulativePower > _powerThreshold,
1612             "Submitted validator set signatures do not have enough power."
1613         );
1614 
1615         bytes32 newCheckpoint = makeCheckpoint(
1616             _validators,
1617             _powers,
1618             0,
1619             _bridgeId
1620         );
1621 
1622         // ACTIONS
1623 
1624         state_bridgeId = _bridgeId;
1625         state_powerThreshold = _powerThreshold;
1626         state_lastValsetCheckpoint = newCheckpoint;
1627         //_ethereumTokenWhiteList[address(0)] = true;
1628         // LOGS
1629 
1630         emit ValsetUpdatedEvent(
1631             state_lastValsetNonce,
1632             state_lastEventNonce,
1633             _validators,
1634             _powers
1635         );
1636     }
1637 
1638     function lastBatchNonce(address _erc20Address)
1639         public
1640         view
1641         returns (uint256)
1642     {
1643         return state_lastBatchNonces[_erc20Address];
1644     }
1645 
1646     function lastLogicCallNonce(bytes32 _invalidation_id)
1647         public
1648         view
1649         returns (uint256)
1650     {
1651         return state_invalidationMapping[_invalidation_id];
1652     }
1653 
1654     // Utility function to verify geth style signatures
1655     function verifySig(
1656         address _signer,
1657         bytes32 _theHash,
1658         uint8 _v,
1659         bytes32 _r,
1660         bytes32 _s
1661     ) private pure returns (bool) {
1662         bytes32 messageDigest = keccak256(
1663             abi.encodePacked("\x19Ethereum Signed Message:\n32", _theHash)
1664         );
1665         return _signer == ecrecover(messageDigest, _v, _r, _s);
1666     }
1667 
1668     // Make a new checkpoint from the supplied validator set
1669     // A checkpoint is a hash of all relevant information about the valset. This is stored by the contract,
1670     // instead of storing the information directly. This saves on storage and gas.
1671     // The format of the checkpoint is:
1672     // h(gravityId, "checkpoint", valsetNonce, validators[], powers[])
1673     // Where h is the keccak256 hash function.
1674     // The validator powers must be decreasing or equal. This is important for checking the signatures on the
1675     // next valset, since it allows the caller to stop verifying signatures once a quorum of signatures have been verified.
1676     function makeCheckpoint(
1677         address[] memory _validators,
1678         uint256[] memory _powers,
1679         uint256 _valsetNonce,
1680         bytes32 _gravityId
1681     ) private pure returns (bytes32) {
1682         // bytes32 encoding of the string "checkpoint"
1683         bytes32 methodName = 0x636865636b706f696e7400000000000000000000000000000000000000000000;
1684 
1685         bytes32 checkpoint = keccak256(
1686             abi.encode(
1687                 _gravityId,
1688                 methodName,
1689                 _valsetNonce,
1690                 _validators,
1691                 _powers
1692             )
1693         );
1694 
1695         return checkpoint;
1696     }
1697 
1698     function checkValidatorSignatures(
1699         // The current validator set and their powers
1700         address[] memory _currentValidators,
1701         uint256[] memory _currentPowers,
1702         // The current validator's signatures
1703         uint8[] memory _v,
1704         bytes32[] memory _r,
1705         bytes32[] memory _s,
1706         // This is what we are checking they have signed
1707         bytes32 _theHash,
1708         uint256 _powerThreshold
1709     ) private pure {
1710         uint256 cumulativePower = 0;
1711 
1712         for (uint256 i = 0; i < _currentValidators.length; i++) {
1713             // If v is set to 0, this signifies that it was not possible to get a signature from this validator and we skip evaluation
1714             // (In a valid signature, it is either 27 or 28)
1715             if (_v[i] != 0) {
1716                 // Check that the current validator has signed off on the hash
1717                 require(
1718                     verifySig(
1719                         _currentValidators[i],
1720                         _theHash,
1721                         _v[i],
1722                         _r[i],
1723                         _s[i]
1724                     ),
1725                     "Validator signature does not match."
1726                 );
1727 
1728                 // Sum up cumulative power
1729                 cumulativePower = cumulativePower + _currentPowers[i];
1730 
1731                 // Break early to avoid wasting gas
1732                 if (cumulativePower > _powerThreshold) {
1733                     break;
1734                 }
1735             }
1736         }
1737 
1738         // Check that there was enough power
1739         require(
1740             cumulativePower > _powerThreshold,
1741             "Submitted validator set signatures do not have enough power."
1742         );
1743         // Success
1744     }
1745 
1746     // This updates the valset by checking that the validators in the current valset have signed off on the
1747     // new valset. The signatures supplied are the signatures of the current valset over the checkpoint hash
1748     // generated from the new valset.
1749     // Anyone can call this function, but they must supply valid signatures of state_powerThreshold of the current valset over
1750     // the new valset.
1751     function updateValset(
1752         // The new version of the validator set
1753         address[] memory _newValidators,
1754         uint256[] memory _newPowers,
1755         uint256 _newValsetNonce,
1756         // The current validators that approve the change
1757         address[] memory _currentValidators,
1758         uint256[] memory _currentPowers,
1759         uint256 _currentValsetNonce,
1760         // These are arrays of the parts of the current validator's signatures
1761         uint8[] memory _v,
1762         bytes32[] memory _r,
1763         bytes32[] memory _s
1764     ) external whenNotPaused nonReentrant {
1765         // CHECKS
1766 
1767         // Check that the valset nonce is greater than the old one
1768         require(
1769             _newValsetNonce > _currentValsetNonce,
1770             "New valset nonce must be greater than the current nonce"
1771         );
1772 
1773         // Check that new validators and powers set is well-formed
1774         require(
1775             _newValidators.length == _newPowers.length,
1776             "Malformed new validator set"
1777         );
1778 
1779         // Check that current validators, powers, and signatures (v,r,s) set is well-formed
1780         require(
1781             _currentValidators.length == _currentPowers.length &&
1782                 _currentValidators.length == _v.length &&
1783                 _currentValidators.length == _r.length &&
1784                 _currentValidators.length == _s.length,
1785             "Malformed current validator set"
1786         );
1787 
1788         // Check that the supplied current validator set matches the saved checkpoint
1789         require(
1790             makeCheckpoint(
1791                 _currentValidators,
1792                 _currentPowers,
1793                 _currentValsetNonce,
1794                 state_bridgeId
1795             ) == state_lastValsetCheckpoint,
1796             "Supplied current validators and powers do not match checkpoint."
1797         );
1798 
1799         // Check that enough current validators have signed off on the new validator set
1800         bytes32 newCheckpoint = makeCheckpoint(
1801             _newValidators,
1802             _newPowers,
1803             _newValsetNonce,
1804             state_bridgeId
1805         );
1806 
1807         checkValidatorSignatures(
1808             _currentValidators,
1809             _currentPowers,
1810             _v,
1811             _r,
1812             _s,
1813             newCheckpoint,
1814             state_powerThreshold
1815         );
1816 
1817         // ACTIONS
1818 
1819         // Stored to be used next time to validate that the valset
1820         // supplied by the caller is correct.
1821         state_lastValsetCheckpoint = newCheckpoint;
1822 
1823         // Store new nonce
1824         state_lastValsetNonce = _newValsetNonce;
1825 
1826         // LOGS
1827         state_lastEventNonce = state_lastEventNonce.add(1);
1828         emit ValsetUpdatedEvent(
1829             _newValsetNonce,
1830             state_lastEventNonce,
1831             _newValidators,
1832             _newPowers
1833         );
1834     }
1835 
1836     // submitBatch processes a batch of Seele -> Ethereum transactions by sending the tokens in the transactions
1837     // to the destination addresses. It is approved by the current Seele validator set.
1838     // Anyone can call this function, but they must supply valid signatures of state_powerThreshold of the current valset over
1839     // the batch.
1840     function submitBatch(
1841         // The validators that approve the batch
1842         address[] memory _currentValidators,
1843         uint256[] memory _currentPowers,
1844         uint256 _currentValsetNonce,
1845         // These are arrays of the parts of the validators signatures
1846         uint8[] memory _v,
1847         bytes32[] memory _r,
1848         bytes32[] memory _s,
1849         // The batch of transactions
1850         uint256[] memory _amounts,
1851         address payable[] memory _destinations,
1852         uint256[] memory _fees,
1853         uint256 _batchNonce,
1854         address _tokenContract,
1855         // a block height beyond which this batch is not valid
1856         // used to provide a fee-free timeout
1857         uint256 _batchTimeout
1858     ) external nonReentrant whenNotPaused {
1859         // CHECKS scoped to reduce stack depth
1860         {
1861             // Check that the batch nonce is higher than the last nonce for this token
1862             require(
1863                 state_lastBatchNonces[_tokenContract] < _batchNonce,
1864                 "New batch nonce must be greater than the current nonce"
1865             );
1866 
1867             // Check that the block height is less than the timeout height
1868             require(
1869                 block.number < _batchTimeout,
1870                 "Batch timeout must be greater than the current block height"
1871             );
1872 
1873             // Check that current validators, powers, and signatures (v,r,s) set is well-formed
1874             require(
1875                 _currentValidators.length == _currentPowers.length &&
1876                     _currentValidators.length == _v.length &&
1877                     _currentValidators.length == _r.length &&
1878                     _currentValidators.length == _s.length,
1879                 "Malformed current validator set"
1880             );
1881 
1882             // Check that the supplied current validator set matches the saved checkpoint
1883             require(
1884                 makeCheckpoint(
1885                     _currentValidators,
1886                     _currentPowers,
1887                     _currentValsetNonce,
1888                     state_bridgeId
1889                 ) == state_lastValsetCheckpoint,
1890                 "Supplied current validators and powers do not match checkpoint."
1891             );
1892 
1893             // Check that the transaction batch is well-formed
1894             require(
1895                 _amounts.length == _destinations.length &&
1896                     _amounts.length == _fees.length,
1897                 "Malformed batch of transactions"
1898             );
1899 
1900             // Check that enough current validators have signed off on the transaction batch and valset
1901             checkValidatorSignatures(
1902                 _currentValidators,
1903                 _currentPowers,
1904                 _v,
1905                 _r,
1906                 _s,
1907                 // Get hash of the transaction batch and checkpoint
1908                 keccak256(
1909                     abi.encode(
1910                         state_bridgeId,
1911                         // bytes32 encoding of "transactionBatch"
1912                         0x7472616e73616374696f6e426174636800000000000000000000000000000000,
1913                         _amounts,
1914                         _destinations,
1915                         _fees,
1916                         _batchNonce,
1917                         _tokenContract,
1918                         _batchTimeout
1919                     )
1920                 ),
1921                 state_powerThreshold
1922             );
1923 
1924             // ACTIONS
1925 
1926             // Store batch nonce
1927             state_lastBatchNonces[_tokenContract] = _batchNonce;
1928 
1929             {
1930                 // Send transaction amounts to destinations
1931                 uint256 totalFee;
1932                 for (uint256 i = 0; i < _amounts.length; i++) {
1933                     if (_tokenContract == address(0)) {
1934                         (bool success, ) = _destinations[i].call{
1935                             value: _amounts[i],
1936                             gas: 60000
1937                         }("");
1938                         require(success, "error sending ether");
1939                     } else {
1940                         IERC20(_tokenContract).safeTransfer(
1941                             _destinations[i],
1942                             _amounts[i]
1943                         );
1944                     }
1945                     totalFee = totalFee.add(_fees[i]);
1946                 }
1947 
1948                 // Send transaction fees to msg.sender
1949                 if (totalFee > 0) {
1950                     if (_tokenContract == address(0)) {
1951                         (bool success, ) = msg.sender.call{
1952                             value: totalFee,
1953                             gas: 60000
1954                         }("");
1955                         require(success, "error sending ether");
1956                     } else {
1957                         IERC20(_tokenContract).safeTransfer(
1958                             msg.sender,
1959                             totalFee
1960                         );
1961                     }
1962                 }
1963             }
1964         }
1965 
1966         // LOGS scoped to reduce stack depth
1967         {
1968             state_lastEventNonce = state_lastEventNonce.add(1);
1969             emit TransactionBatchExecutedEvent(
1970                 _batchNonce,
1971                 _tokenContract,
1972                 state_lastEventNonce
1973             );
1974         }
1975     }
1976 
1977     // This makes calls to contracts that execute arbitrary logic
1978     // First, it gives the logic contract some tokens
1979     // Then, it gives msg.senders tokens for fees
1980     // Then, it calls an arbitrary function on the logic contract
1981     // invalidationId and invalidationNonce are used for replay prevention.
1982     // They can be used to implement a per-token nonce by setting the token
1983     // address as the invalidationId and incrementing the nonce each call.
1984     // They can be used for nonce-free replay prevention by using a different invalidationId
1985     // for each call.
1986     function submitLogicCall(
1987         // The validators that approve the call
1988         address[] memory _currentValidators,
1989         uint256[] memory _currentPowers,
1990         uint256 _currentValsetNonce,
1991         // These are arrays of the parts of the validators signatures
1992         uint8[] memory _v,
1993         bytes32[] memory _r,
1994         bytes32[] memory _s,
1995         LogicCallArgs memory _args
1996     ) public nonReentrant {
1997         // CHECKS scoped to reduce stack depth
1998         {
1999             // Check that the call has not timed out
2000             require(block.number < _args.timeOut, "Timed out");
2001 
2002             // Check that the invalidation nonce is higher than the last nonce for this invalidation Id
2003             require(
2004                 state_invalidationMapping[_args.invalidationId] <
2005                     _args.invalidationNonce,
2006                 "New invalidation nonce must be greater than the current nonce"
2007             );
2008 
2009             // Check that current validators, powers, and signatures (v,r,s) set is well-formed
2010             require(
2011                 _currentValidators.length == _currentPowers.length &&
2012                     _currentValidators.length == _v.length &&
2013                     _currentValidators.length == _r.length &&
2014                     _currentValidators.length == _s.length,
2015                 "Malformed current validator set"
2016             );
2017 
2018             // Check that the supplied current validator set matches the saved checkpoint
2019             require(
2020                 makeCheckpoint(
2021                     _currentValidators,
2022                     _currentPowers,
2023                     _currentValsetNonce,
2024                     state_bridgeId
2025                 ) == state_lastValsetCheckpoint,
2026                 "Supplied current validators and powers do not match checkpoint."
2027             );
2028 
2029             // Check that the token transfer list is well-formed
2030             require(
2031                 _args.transferAmounts.length ==
2032                     _args.transferTokenContracts.length,
2033                 "Malformed list of token transfers"
2034             );
2035 
2036             // Check that the fee list is well-formed
2037             require(
2038                 _args.feeAmounts.length == _args.feeTokenContracts.length,
2039                 "Malformed list of fees"
2040             );
2041         }
2042 
2043         bytes32 argsHash = keccak256(
2044             abi.encode(
2045                 state_bridgeId,
2046                 // bytes32 encoding of "logicCall"
2047                 0x6c6f67696343616c6c0000000000000000000000000000000000000000000000,
2048                 _args.transferAmounts,
2049                 _args.transferTokenContracts,
2050                 _args.feeAmounts,
2051                 _args.feeTokenContracts,
2052                 _args.logicContractAddress,
2053                 _args.payload,
2054                 _args.timeOut,
2055                 _args.invalidationId,
2056                 _args.invalidationNonce
2057             )
2058         );
2059 
2060         {
2061             // Check that enough current validators have signed off on the transaction batch and valset
2062             checkValidatorSignatures(
2063                 _currentValidators,
2064                 _currentPowers,
2065                 _v,
2066                 _r,
2067                 _s,
2068                 // Get hash of the transaction batch and checkpoint
2069                 argsHash,
2070                 state_powerThreshold
2071             );
2072         }
2073 
2074         // ACTIONS
2075 
2076         // Update invaldiation nonce
2077         state_invalidationMapping[_args.invalidationId] = _args
2078             .invalidationNonce;
2079 
2080         // Send tokens to the logic contract
2081         for (uint256 i = 0; i < _args.transferAmounts.length; i++) {
2082             IERC20(_args.transferTokenContracts[i]).safeTransfer(
2083                 _args.logicContractAddress,
2084                 _args.transferAmounts[i]
2085             );
2086         }
2087 
2088         // Make call to logic contract
2089         bytes memory returnData = Address.functionCall(
2090             _args.logicContractAddress,
2091             _args.payload
2092         );
2093 
2094         // Send fees to msg.sender
2095         for (uint256 i = 0; i < _args.feeAmounts.length; i++) {
2096             IERC20(_args.feeTokenContracts[i]).safeTransfer(
2097                 msg.sender,
2098                 _args.feeAmounts[i]
2099             );
2100         }
2101 
2102         // LOGS scoped to reduce stack depth
2103         {
2104             state_lastEventNonce = state_lastEventNonce.add(1);
2105             emit LogicCallEvent(
2106                 _args.invalidationId,
2107                 _args.invalidationNonce,
2108                 returnData,
2109                 state_lastEventNonce
2110             );
2111         }
2112     }
2113 
2114     function sendToSeele(
2115         address _tokenContract,
2116         address _destination,
2117         uint256 _amount
2118     )
2119         external
2120         payable
2121         onlyEthTokenWhiteList(_tokenContract)
2122         whenNotPaused
2123         nonReentrant
2124     {
2125         require(_amount > 0, "incorrect amount");
2126         if (msg.value > 0) {
2127             // Ethereum deposit
2128             require(_tokenContract == address(0), "!address(0)");
2129             require(msg.value == _amount, "incorrect eth amount");
2130         } else {
2131             // ERC20 deposit
2132             IERC20(_tokenContract).safeTransferFrom(
2133                 msg.sender,
2134                 address(this),
2135                 _amount
2136             );
2137         }
2138         state_lastEventNonce = state_lastEventNonce.add(1);
2139         emit SendToSeeleEvent(
2140             _tokenContract,
2141             msg.sender,
2142             _destination,
2143             _amount,
2144             state_lastEventNonce
2145         );
2146     }
2147 
2148     function deployERC20(
2149         string calldata _seeleDenom,
2150         string calldata _name,
2151         string calldata _symbol,
2152         uint8 _decimals
2153     ) external onlyOwner {
2154         // Deploy an ERC20 with entire supply granted to SeeleBridge.sol
2155         SeeleERC20 erc20 = new SeeleERC20(
2156             address(this),
2157             _name,
2158             _symbol,
2159             _decimals
2160         );
2161 
2162         // Fire an event to let the Bridge module know
2163         state_lastEventNonce = state_lastEventNonce.add(1);
2164         emit ERC20DeployedEvent(
2165             _seeleDenom,
2166             address(erc20),
2167             _name,
2168             _symbol,
2169             _decimals,
2170             state_lastEventNonce
2171         );
2172     }
2173 
2174     function emergencyPause() external onlyOwner {
2175         _pause();
2176     }
2177 
2178     function emergencyUnpause() external onlyOwner {
2179         _unpause();
2180     }
2181 
2182     /*
2183      * @dev: Modifier to restrict erc20 can be locked
2184      */
2185     modifier onlyEthTokenWhiteList(address _token) {
2186         require(
2187             getTokenInEthWhiteList(_token),
2188             "Only token in whitelist can be transferred to cosmos"
2189         );
2190         _;
2191     }
2192 
2193     /*
2194      * @dev: Set the token address in whitelist
2195      *
2196      * @param _token: ERC 20's address
2197      * @param _inList: set the _token in list or not
2198      */
2199     function setTokenInEthWhiteList(address _token, bool _inList)
2200         external
2201         onlyOwner
2202     {
2203         _ethereumTokenWhiteList[_token] = _inList;
2204         emit WhiteListUpdateEvent(_token, _inList);
2205     }
2206 
2207     /*
2208      * @dev: Get if the token in whitelist
2209      *
2210      * @param _token: ERC 20's address
2211      * @return: if _token in whitelist
2212      */
2213     function getTokenInEthWhiteList(address _token) public view returns (bool) {
2214         return _ethereumTokenWhiteList[_token];
2215     }
2216 }