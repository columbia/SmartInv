1 pragma solidity ^0.6.0;
2 
3 
4 // 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 // 
92 /**
93  * @dev Standard math utilities missing in the Solidity language.
94  */
95 library Math {
96     /**
97      * @dev Returns the largest of two numbers.
98      */
99     function max(uint256 a, uint256 b) internal pure returns (uint256) {
100         return a >= b ? a : b;
101     }
102 
103     /**
104      * @dev Returns the smallest of two numbers.
105      */
106     function min(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a < b ? a : b;
108     }
109 
110     /**
111      * @dev Returns the average of two numbers. The result is rounded towards
112      * zero.
113      */
114     function average(uint256 a, uint256 b) internal pure returns (uint256) {
115         // (a + b) / 2 can overflow, so we distribute
116         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
117     }
118 }
119 
120 // 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Returns the amount of tokens in existence.
127      */
128     function totalSupply() external view returns (uint256);
129 
130     /**
131      * @dev Returns the amount of tokens owned by `account`.
132      */
133     function balanceOf(address account) external view returns (uint256);
134 
135     /**
136      * @dev Moves `amount` tokens from the caller's account to `recipient`.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transfer(address recipient, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Returns the remaining number of tokens that `spender` will be
146      * allowed to spend on behalf of `owner` through {transferFrom}. This is
147      * zero by default.
148      *
149      * This value changes when {approve} or {transferFrom} are called.
150      */
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     /**
154      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * IMPORTANT: Beware that changing an allowance with this method brings the risk
159      * that someone may use both the old and the new allowance by unfortunate
160      * transaction ordering. One possible solution to mitigate this race
161      * condition is to first reduce the spender's allowance to 0 and set the
162      * desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      *
165      * Emits an {Approval} event.
166      */
167     function approve(address spender, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Moves `amount` tokens from `sender` to `recipient` using the
171      * allowance mechanism. `amount` is then deducted from the caller's
172      * allowance.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Emitted when `value` tokens are moved from one account (`from`) to
182      * another (`to`).
183      *
184      * Note that `value` may be zero.
185      */
186     event Transfer(address indexed from, address indexed to, uint256 value);
187 
188     /**
189      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
190      * a call to {approve}. `value` is the new allowance.
191      */
192     event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 // 
196 /**
197  * @dev Wrappers over Solidity's arithmetic operations with added overflow
198  * checks.
199  *
200  * Arithmetic operations in Solidity wrap on overflow. This can easily result
201  * in bugs, because programmers usually assume that an overflow raises an
202  * error, which is the standard behavior in high level programming languages.
203  * `SafeMath` restores this intuition by reverting the transaction when an
204  * operation overflows.
205  *
206  * Using this library instead of the unchecked operations eliminates an entire
207  * class of bugs, so it's recommended to use it always.
208  */
209 library SafeMath {
210     /**
211      * @dev Returns the addition of two unsigned integers, reverting on
212      * overflow.
213      *
214      * Counterpart to Solidity's `+` operator.
215      *
216      * Requirements:
217      *
218      * - Addition cannot overflow.
219      */
220     function add(uint256 a, uint256 b) internal pure returns (uint256) {
221         uint256 c = a + b;
222         require(c >= a, "SafeMath: addition overflow");
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the subtraction of two unsigned integers, reverting on
229      * overflow (when the result is negative).
230      *
231      * Counterpart to Solidity's `-` operator.
232      *
233      * Requirements:
234      *
235      * - Subtraction cannot overflow.
236      */
237     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238         return sub(a, b, "SafeMath: subtraction overflow");
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
243      * overflow (when the result is negative).
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b <= a, errorMessage);
253         uint256 c = a - b;
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the multiplication of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `*` operator.
263      *
264      * Requirements:
265      *
266      * - Multiplication cannot overflow.
267      */
268     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
270         // benefit is lost if 'b' is also tested.
271         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
272         if (a == 0) {
273             return 0;
274         }
275 
276         uint256 c = a * b;
277         require(c / a == b, "SafeMath: multiplication overflow");
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers. Reverts on
284      * division by zero. The result is rounded towards zero.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function div(uint256 a, uint256 b) internal pure returns (uint256) {
295         return div(a, b, "SafeMath: division by zero");
296     }
297 
298     /**
299      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
300      * division by zero. The result is rounded towards zero.
301      *
302      * Counterpart to Solidity's `/` operator. Note: this function uses a
303      * `revert` opcode (which leaves remaining gas untouched) while Solidity
304      * uses an invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      *
308      * - The divisor cannot be zero.
309      */
310     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
311         require(b > 0, errorMessage);
312         uint256 c = a / b;
313         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
314 
315         return c;
316     }
317 
318     /**
319      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
320      * Reverts when dividing by zero.
321      *
322      * Counterpart to Solidity's `%` operator. This function uses a `revert`
323      * opcode (which leaves remaining gas untouched) while Solidity uses an
324      * invalid opcode to revert (consuming all remaining gas).
325      *
326      * Requirements:
327      *
328      * - The divisor cannot be zero.
329      */
330     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
331         return mod(a, b, "SafeMath: modulo by zero");
332     }
333 
334     /**
335      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
336      * Reverts with custom message when dividing by zero.
337      *
338      * Counterpart to Solidity's `%` operator. This function uses a `revert`
339      * opcode (which leaves remaining gas untouched) while Solidity uses an
340      * invalid opcode to revert (consuming all remaining gas).
341      *
342      * Requirements:
343      *
344      * - The divisor cannot be zero.
345      */
346     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
347         require(b != 0, errorMessage);
348         return a % b;
349     }
350 }
351 
352 // 
353 /**
354  * @dev Collection of functions related to the address type
355  */
356 library Address {
357     /**
358      * @dev Returns true if `account` is a contract.
359      *
360      * [IMPORTANT]
361      * ====
362      * It is unsafe to assume that an address for which this function returns
363      * false is an externally-owned account (EOA) and not a contract.
364      *
365      * Among others, `isContract` will return false for the following
366      * types of addresses:
367      *
368      *  - an externally-owned account
369      *  - a contract in construction
370      *  - an address where a contract will be created
371      *  - an address where a contract lived, but was destroyed
372      * ====
373      */
374     function isContract(address account) internal view returns (bool) {
375         // This method relies in extcodesize, which returns 0 for contracts in
376         // construction, since the code is only stored at the end of the
377         // constructor execution.
378 
379         uint256 size;
380         // solhint-disable-next-line no-inline-assembly
381         assembly { size := extcodesize(account) }
382         return size > 0;
383     }
384 
385     /**
386      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
387      * `recipient`, forwarding all available gas and reverting on errors.
388      *
389      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
390      * of certain opcodes, possibly making contracts go over the 2300 gas limit
391      * imposed by `transfer`, making them unable to receive funds via
392      * `transfer`. {sendValue} removes this limitation.
393      *
394      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
395      *
396      * IMPORTANT: because control is transferred to `recipient`, care must be
397      * taken to not create reentrancy vulnerabilities. Consider using
398      * {ReentrancyGuard} or the
399      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
400      */
401     function sendValue(address payable recipient, uint256 amount) internal {
402         require(address(this).balance >= amount, "Address: insufficient balance");
403 
404         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
405         (bool success, ) = recipient.call{ value: amount }("");
406         require(success, "Address: unable to send value, recipient may have reverted");
407     }
408 
409     /**
410      * @dev Performs a Solidity function call using a low level `call`. A
411      * plain`call` is an unsafe replacement for a function call: use this
412      * function instead.
413      *
414      * If `target` reverts with a revert reason, it is bubbled up by this
415      * function (like regular Solidity function calls).
416      *
417      * Returns the raw returned data. To convert to the expected return value,
418      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
419      *
420      * Requirements:
421      *
422      * - `target` must be a contract.
423      * - calling `target` with `data` must not revert.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
428       return functionCall(target, data, "Address: low-level call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
433      * `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
438         return _functionCallWithValue(target, data, 0, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but also transferring `value` wei to `target`.
444      *
445      * Requirements:
446      *
447      * - the calling contract must have an ETH balance of at least `value`.
448      * - the called Solidity function must be `payable`.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
458      * with `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
463         require(address(this).balance >= value, "Address: insufficient balance for call");
464         return _functionCallWithValue(target, data, value, errorMessage);
465     }
466 
467     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
468         require(isContract(target), "Address: call to non-contract");
469 
470         // solhint-disable-next-line avoid-low-level-calls
471         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 // solhint-disable-next-line no-inline-assembly
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 // 
492 /**
493  * @title SafeERC20
494  * @dev Wrappers around ERC20 operations that throw on failure (when the token
495  * contract returns false). Tokens that return no value (and instead revert or
496  * throw on failure) are also supported, non-reverting calls are assumed to be
497  * successful.
498  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
499  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
500  */
501 library SafeERC20 {
502     using SafeMath for uint256;
503     using Address for address;
504 
505     function safeTransfer(IERC20 token, address to, uint256 value) internal {
506         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
507     }
508 
509     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
510         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
511     }
512 
513     /**
514      * @dev Deprecated. This function has issues similar to the ones found in
515      * {IERC20-approve}, and its usage is discouraged.
516      *
517      * Whenever possible, use {safeIncreaseAllowance} and
518      * {safeDecreaseAllowance} instead.
519      */
520     function safeApprove(IERC20 token, address spender, uint256 value) internal {
521         // safeApprove should only be called when setting an initial allowance,
522         // or when resetting it to zero. To increase and decrease it, use
523         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
524         // solhint-disable-next-line max-line-length
525         require((value == 0) || (token.allowance(address(this), spender) == 0),
526             "SafeERC20: approve from non-zero to non-zero allowance"
527         );
528         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
529     }
530 
531     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
532         uint256 newAllowance = token.allowance(address(this), spender).add(value);
533         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
534     }
535 
536     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
537         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
538         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
539     }
540 
541     /**
542      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
543      * on the return value: the return value is optional (but if data is returned, it must not be false).
544      * @param token The token targeted by the call.
545      * @param data The call data (encoded using abi.encode or one of its variants).
546      */
547     function _callOptionalReturn(IERC20 token, bytes memory data) private {
548         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
549         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
550         // the target address contains contract code and also asserts for success in the low-level call.
551 
552         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
553         if (returndata.length > 0) { // Return data is optional
554             // solhint-disable-next-line max-line-length
555             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
556         }
557     }
558 }
559 
560 // 
561 /**
562  * @dev Contract module which allows children to implement an emergency stop
563  * mechanism that can be triggered by an authorized account.
564  *
565  * This module is used through inheritance. It will make available the
566  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
567  * the functions of your contract. Note that they will not be pausable by
568  * simply including this module, only once the modifiers are put in place.
569  */
570 contract Pausable is Context {
571     /**
572      * @dev Emitted when the pause is triggered by `account`.
573      */
574     event Paused(address account);
575 
576     /**
577      * @dev Emitted when the pause is lifted by `account`.
578      */
579     event Unpaused(address account);
580 
581     bool private _paused;
582 
583     /**
584      * @dev Initializes the contract in unpaused state.
585      */
586     constructor () internal {
587         _paused = false;
588     }
589 
590     /**
591      * @dev Returns true if the contract is paused, and false otherwise.
592      */
593     function paused() public view returns (bool) {
594         return _paused;
595     }
596 
597     /**
598      * @dev Modifier to make a function callable only when the contract is not paused.
599      *
600      * Requirements:
601      *
602      * - The contract must not be paused.
603      */
604     modifier whenNotPaused() {
605         require(!_paused, "Pausable: paused");
606         _;
607     }
608 
609     /**
610      * @dev Modifier to make a function callable only when the contract is paused.
611      *
612      * Requirements:
613      *
614      * - The contract must be paused.
615      */
616     modifier whenPaused() {
617         require(_paused, "Pausable: not paused");
618         _;
619     }
620 
621     /**
622      * @dev Triggers stopped state.
623      *
624      * Requirements:
625      *
626      * - The contract must not be paused.
627      */
628     function _pause() internal virtual whenNotPaused {
629         _paused = true;
630         emit Paused(_msgSender());
631     }
632 
633     /**
634      * @dev Returns to normal state.
635      *
636      * Requirements:
637      *
638      * - The contract must be paused.
639      */
640     function _unpause() internal virtual whenPaused {
641         _paused = false;
642         emit Unpaused(_msgSender());
643     }
644 }
645 
646 // 
647 /**
648  * @dev Contract module that helps prevent reentrant calls to a function.
649  *
650  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
651  * available, which can be applied to functions to make sure there are no nested
652  * (reentrant) calls to them.
653  *
654  * Note that because there is a single `nonReentrant` guard, functions marked as
655  * `nonReentrant` may not call one another. This can be worked around by making
656  * those functions `private`, and then adding `external` `nonReentrant` entry
657  * points to them.
658  *
659  * TIP: If you would like to learn more about reentrancy and alternative ways
660  * to protect against it, check out our blog post
661  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
662  */
663 contract ReentrancyGuard {
664     // Booleans are more expensive than uint256 or any type that takes up a full
665     // word because each write operation emits an extra SLOAD to first read the
666     // slot's contents, replace the bits taken up by the boolean, and then write
667     // back. This is the compiler's defense against contract upgrades and
668     // pointer aliasing, and it cannot be disabled.
669 
670     // The values being non-zero value makes deployment a bit more expensive,
671     // but in exchange the refund on every call to nonReentrant will be lower in
672     // amount. Since refunds are capped to a percentage of the total
673     // transaction's gas, it is best to keep them low in cases like this one, to
674     // increase the likelihood of the full refund coming into effect.
675     uint256 private constant _NOT_ENTERED = 1;
676     uint256 private constant _ENTERED = 2;
677 
678     uint256 private _status;
679 
680     constructor () internal {
681         _status = _NOT_ENTERED;
682     }
683 
684     /**
685      * @dev Prevents a contract from calling itself, directly or indirectly.
686      * Calling a `nonReentrant` function from another `nonReentrant`
687      * function is not supported. It is possible to prevent this from happening
688      * by making the `nonReentrant` function external, and make it call a
689      * `private` function that does the actual work.
690      */
691     modifier nonReentrant() {
692         // On the first call to nonReentrant, _notEntered will be true
693         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
694 
695         // Any calls to nonReentrant after this point will fail
696         _status = _ENTERED;
697 
698         _;
699 
700         // By storing the original value once again, a refund is triggered (see
701         // https://eips.ethereum.org/EIPS/eip-2200)
702         _status = _NOT_ENTERED;
703     }
704 }
705 
706 contract VeggieFarm is ReentrancyGuard, Pausable, Ownable {
707     using SafeMath for uint256;
708     using SafeERC20 for IERC20;
709 
710     IERC20 public rewardsToken;
711     IERC20 public stakingToken;
712     uint256 public periodFinish;
713     uint256 public rewardRate;
714     uint256 public rewardsDuration = 7 days;
715     uint256 public lastUpdateTime;
716     uint256 public rewardPerTokenStored;
717 
718     mapping(address => uint) public locks;
719     uint256 public lpLockDays = 3 days;
720 
721     mapping(address => uint256) public userRewardPerTokenPaid;
722     mapping(address => uint256) public rewards;
723 
724     uint256 private _totalSupply;
725     mapping(address => uint256) private _balances;
726 
727     constructor(address _rewardsToken, address _stakingToken)
728     public
729     Ownable() {
730         rewardsToken = IERC20(_rewardsToken);
731         stakingToken = IERC20(_stakingToken);
732         _pause();
733     }
734 
735     function totalSupply() external view returns (uint256) {
736         return _totalSupply;
737     }
738 
739     function balanceOf(address account) external view returns (uint256) {
740         return _balances[account];
741     }
742 
743     function lastTimeRewardApplicable() public view returns (uint256) {
744         return Math.min(block.timestamp, periodFinish);
745     }
746 
747     function rewardPerToken() public view returns (uint256) {
748         if (_totalSupply == 0) {
749             return rewardPerTokenStored;
750         }
751         return
752             rewardPerTokenStored.add(
753                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
754             );
755     }
756 
757     function earned(address account) public view returns (uint256) {
758         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
759     }
760 
761     function getRewardForDuration() external view returns (uint256) {
762         return rewardRate.mul(rewardsDuration);
763     }
764 
765     function stake(uint256 amount) external nonReentrant whenNotPaused updateReward(msg.sender) {
766         require(amount > 0, "Cannot stake 0");
767         _totalSupply = _totalSupply.add(amount);
768         _balances[msg.sender] = _balances[msg.sender].add(amount);
769         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
770         locks[msg.sender] = block.timestamp + lpLockDays;
771         emit Staked(msg.sender, amount);
772     }
773 
774     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
775         require(amount > 0, "Cannot withdraw 0");
776         require(stakingToken.balanceOf(msg.sender) >= 1 * 1e18, "must have 1 veggie in balance");
777         require(locks[msg.sender] < now, "locked");
778         _totalSupply = _totalSupply.sub(amount);
779         _balances[msg.sender] = _balances[msg.sender].sub(amount);
780         stakingToken.safeTransfer(msg.sender, amount);
781         emit Withdrawn(msg.sender, amount);
782     }
783 
784     function getReward() public nonReentrant updateReward(msg.sender) {
785         uint256 reward = rewards[msg.sender];
786         if (reward > 0) {
787             rewards[msg.sender] = 0;
788             rewardsToken.safeTransfer(msg.sender, reward);
789             emit RewardPaid(msg.sender, reward);
790         }
791     }
792 
793     function exit() external {
794         withdraw(_balances[msg.sender]);
795         getReward();
796     }
797 
798     function unpause() external onlyOwner {
799         super._unpause();
800     }
801 
802     function notifyRewardAmount(uint256 reward) external onlyOwner updateReward(address(0)) {
803         if (block.timestamp >= periodFinish) {
804             rewardRate = reward.div(rewardsDuration);
805         } else {
806             uint256 remaining = periodFinish.sub(block.timestamp);
807             uint256 leftover = remaining.mul(rewardRate);
808             rewardRate = reward.add(leftover).div(rewardsDuration);
809         }
810 
811         // Ensure the provided reward amount is not more than the balance in the contract.
812         // This keeps the reward rate in the right range, preventing overflows due to
813         // very high values of rewardRate in the earned and rewardsPerToken functions;
814         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
815         uint balance = rewardsToken.balanceOf(address(this));
816         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
817 
818         lastUpdateTime = block.timestamp;
819         periodFinish = block.timestamp.add(rewardsDuration);
820         emit RewardAdded(reward);
821     }
822 
823     // Added to support recovering LP Rewards from other systems to be distributed to holders
824     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
825         // Cannot recover the staking token or the rewards token
826         require(
827             tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken),
828             "Cannot withdraw the staking or rewards tokens"
829         );
830         IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
831         emit Recovered(tokenAddress, tokenAmount);
832     }
833 
834     modifier updateReward(address account) {
835         rewardPerTokenStored = rewardPerToken();
836         lastUpdateTime = lastTimeRewardApplicable();
837         if (account != address(0)) {
838             rewards[account] = earned(account);
839             userRewardPerTokenPaid[account] = rewardPerTokenStored;
840         }
841         _;
842     }
843 
844     event RewardAdded(uint256 reward);
845     event Staked(address indexed user, uint256 amount);
846     event Withdrawn(address indexed user, uint256 amount);
847     event RewardPaid(address indexed user, uint256 reward);
848     event Recovered(address token, uint256 amount);
849 }