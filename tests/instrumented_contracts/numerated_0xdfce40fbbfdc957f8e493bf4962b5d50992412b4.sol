1 // SPDX-License-Identifier: GPL-3.0-or-later Or MIT
2 // File: contracts\SafeMath.sol
3 
4 
5 
6 pragma solidity >=0.6.0 <0.8.0;
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
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      *
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      *
78      * - Multiplication cannot overflow.
79      */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 // File: contracts\IBEP20.sol
165 
166 pragma solidity >=0.6.4;
167 
168 interface IBEP20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the token decimals.
176      */
177     function decimals() external view returns (uint8);
178 
179     /**
180      * @dev Returns the token symbol.
181      */
182     function symbol() external view returns (string memory);
183 
184     /**
185      * @dev Returns the token name.
186      */
187     function name() external view returns (string memory);
188 
189     /**
190      * @dev Returns the bep token owner.
191      */
192     function getOwner() external view returns (address);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through {transferFrom}. This is
211      * zero by default.
212      *
213      * This value changes when {approve} or {transferFrom} are called.
214      */
215     function allowance(address _owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * IMPORTANT: Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address spender, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Moves `amount` tokens from `sender` to `recipient` using the
235      * allowance mechanism. `amount` is then deducted from the caller's
236      * allowance.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to {approve}. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 // File: contracts\Address.sol
260 
261 
262 
263 pragma solidity >=0.6.2 <0.8.0;
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // This method relies on extcodesize, which returns 0 for contracts in
288         // construction, since the code is only stored at the end of the
289         // constructor execution.
290 
291         uint256 size;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { size := extcodesize(account) }
294         return size > 0;
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain`call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
340       return functionCall(target, data, "Address: low-level call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
345      * `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
370      * with `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: value }(data);
380         return _verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
390         return functionStaticCall(target, data, "Address: low-level static call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         // solhint-disable-next-line avoid-low-level-calls
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return _verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414 
415                 // solhint-disable-next-line no-inline-assembly
416                 assembly {
417                     let returndata_size := mload(returndata)
418                     revert(add(32, returndata), returndata_size)
419                 }
420             } else {
421                 revert(errorMessage);
422             }
423         }
424     }
425 }
426 
427 // File: contracts\SafeBEP20.sol
428 
429 
430 
431 pragma solidity >=0.6.0 <0.8.0;
432 
433 
434 
435 
436 /**
437  * @title SafeBEP20
438  * @dev Wrappers around BEP20 operations that throw on failure (when the token
439  * contract returns false). Tokens that return no value (and instead revert or
440  * throw on failure) are also supported, non-reverting calls are assumed to be
441  * successful.
442  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
443  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
444  */
445 library SafeBEP20 {
446     using SafeMath for uint256;
447     using Address for address;
448 
449     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
450         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
451     }
452 
453     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
454         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
455     }
456 
457     /**
458      * @dev Deprecated. This function has issues similar to the ones found in
459      * {IBEP20-approve}, and its usage is discouraged.
460      *
461      * Whenever possible, use {safeIncreaseAllowance} and
462      * {safeDecreaseAllowance} instead.
463      */
464     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
465         // safeApprove should only be called when setting an initial allowance,
466         // or when resetting it to zero. To increase and decrease it, use
467         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
468         // solhint-disable-next-line max-line-length
469         require((value == 0) || (token.allowance(address(this), spender) == 0),
470             "SafeBEP20: approve from non-zero to non-zero allowance"
471         );
472         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
473     }
474 
475     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
476         uint256 newAllowance = token.allowance(address(this), spender).add(value);
477         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
478     }
479 
480     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
481         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
482         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
483     }
484 
485     /**
486      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
487      * on the return value: the return value is optional (but if data is returned, it must not be false).
488      * @param token The token targeted by the call.
489      * @param data The call data (encoded using abi.encode or one of its variants).
490      */
491     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
492         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
493         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
494         // the target address contains contract code and also asserts for success in the low-level call.
495 
496         bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
497         if (returndata.length > 0) { // Return data is optional
498             // solhint-disable-next-line max-line-length
499             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
500         }
501     }
502 }
503 
504 // File: contracts\Context.sol
505 
506 
507 
508 pragma solidity >=0.6.0 <0.8.0;
509 
510 /*
511  * @dev Provides information about the current execution context, including the
512  * sender of the transaction and its data. While these are generally available
513  * via msg.sender and msg.data, they should not be accessed in such a direct
514  * manner, since when dealing with GSN meta-transactions the account sending and
515  * paying for execution may not be the actual sender (as far as an application
516  * is concerned).
517  *
518  * This contract is only required for intermediate, library-like contracts.
519  */
520 abstract contract Context {
521     function _msgSender() internal view virtual returns (address payable) {
522         return msg.sender;
523     }
524 
525     function _msgData() internal view virtual returns (bytes memory) {
526         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
527         return msg.data;
528     }
529 }
530 
531 // File: contracts\Ownable.sol
532 
533 
534 
535 pragma solidity >=0.6.0 <0.8.0;
536 
537 /**
538  * @dev Contract module which provides a basic access control mechanism, where
539  * there is an account (an owner) that can be granted exclusive access to
540  * specific functions.
541  *
542  * By default, the owner account will be the one that deploys the contract. This
543  * can later be changed with {transferOwnership}.
544  *
545  * This module is used through inheritance. It will make available the modifier
546  * `onlyOwner`, which can be applied to your functions to restrict their use to
547  * the owner.
548  */
549 abstract contract Ownable is Context {
550     address private _owner;
551 
552     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
553 
554     /**
555      * @dev Initializes the contract setting the deployer as the initial owner.
556      */
557     constructor () internal {
558         address msgSender = _msgSender();
559         _owner = msgSender;
560         emit OwnershipTransferred(address(0), msgSender);
561     }
562 
563     /**
564      * @dev Returns the address of the current owner.
565      */
566     function owner() public view returns (address) {
567         return _owner;
568     }
569 
570     /**
571      * @dev Throws if called by any account other than the owner.
572      */
573     modifier onlyOwner() {
574         require(_owner == _msgSender(), "Ownable: caller is not the owner");
575         _;
576     }
577 
578     /**
579      * @dev Leaves the contract without owner. It will not be possible to call
580      * `onlyOwner` functions anymore. Can only be called by the current owner.
581      *
582      * NOTE: Renouncing ownership will leave the contract without an owner,
583      * thereby removing any functionality that is only available to the owner.
584      */
585     function renounceOwnership() public virtual onlyOwner {
586         emit OwnershipTransferred(_owner, address(0));
587         _owner = address(0);
588     }
589 
590     /**
591      * @dev Transfers ownership of the contract to a new account (`newOwner`).
592      * Can only be called by the current owner.
593      */
594     function transferOwnership(address newOwner) public virtual onlyOwner {
595         require(newOwner != address(0), "Ownable: new owner is the zero address");
596         emit OwnershipTransferred(_owner, newOwner);
597         _owner = newOwner;
598     }
599 }
600 
601 // File: contracts\IWukongReferral.sol
602 
603 
604 
605 pragma solidity 0.6.12;
606 
607 interface IWukongReferral {
608     /**
609      * @dev Record referral.
610      */
611     function recordReferral(address user, address referrer) external;
612 
613     /**
614      * @dev Record referral commission.
615      */
616     function recordReferralCommission(address referrer, uint256 commission) external;
617 
618     /**
619      * @dev Get the referrer address that referred the user.
620      */
621     function getReferrer(address user) external view returns (address);
622 }
623 
624 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
625 
626 
627 
628 pragma solidity >=0.6.0 <0.8.0;
629 
630 /**
631  * @dev Contract module that helps prevent reentrant calls to a function.
632  *
633  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
634  * available, which can be applied to functions to make sure there are no nested
635  * (reentrant) calls to them.
636  *
637  * Note that because there is a single `nonReentrant` guard, functions marked as
638  * `nonReentrant` may not call one another. This can be worked around by making
639  * those functions `private`, and then adding `external` `nonReentrant` entry
640  * points to them.
641  *
642  * TIP: If you would like to learn more about reentrancy and alternative ways
643  * to protect against it, check out our blog post
644  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
645  */
646 abstract contract ReentrancyGuard {
647     // Booleans are more expensive than uint256 or any type that takes up a full
648     // word because each write operation emits an extra SLOAD to first read the
649     // slot's contents, replace the bits taken up by the boolean, and then write
650     // back. This is the compiler's defense against contract upgrades and
651     // pointer aliasing, and it cannot be disabled.
652 
653     // The values being non-zero value makes deployment a bit more expensive,
654     // but in exchange the refund on every call to nonReentrant will be lower in
655     // amount. Since refunds are capped to a percentage of the total
656     // transaction's gas, it is best to keep them low in cases like this one, to
657     // increase the likelihood of the full refund coming into effect.
658     uint256 private constant _NOT_ENTERED = 1;
659     uint256 private constant _ENTERED = 2;
660 
661     uint256 private _status;
662 
663     constructor () internal {
664         _status = _NOT_ENTERED;
665     }
666 
667     /**
668      * @dev Prevents a contract from calling itself, directly or indirectly.
669      * Calling a `nonReentrant` function from another `nonReentrant`
670      * function is not supported. It is possible to prevent this from happening
671      * by making the `nonReentrant` function external, and make it call a
672      * `private` function that does the actual work.
673      */
674     modifier nonReentrant() {
675         // On the first call to nonReentrant, _notEntered will be true
676         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
677 
678         // Any calls to nonReentrant after this point will fail
679         _status = _ENTERED;
680 
681         _;
682 
683         // By storing the original value once again, a refund is triggered (see
684         // https://eips.ethereum.org/EIPS/eip-2200)
685         _status = _NOT_ENTERED;
686     }
687 }
688 
689 // File: contracts\BEP20.sol
690 
691 
692 
693 pragma solidity >=0.4.0;
694 
695 
696 
697 
698 
699 /**
700  * @dev Implementation of the {IBEP20} interface.
701  *
702  * This implementation is agnostic to the way tokens are created. This means
703  * that a supply mechanism has to be added in a derived contract using {_mint}.
704  * For a generic mechanism see {BEP20PresetMinterPauser}.
705  *
706  * TIP: For a detailed writeup see our guide
707  * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
708  * to implement supply mechanisms].
709  *
710  * We have followed general OpenZeppelin guidelines: functions revert instead
711  * of returning `false` on failure. This behavior is nonetheless conventional
712  * and does not conflict with the expectations of BEP20 applications.
713  *
714  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
715  * This allows applications to reconstruct the allowance for all accounts just
716  * by listening to said events. Other implementations of the EIP may not emit
717  * these events, as it isn't required by the specification.
718  *
719  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
720  * functions have been added to mitigate the well-known issues around setting
721  * allowances. See {IBEP20-approve}.
722  */
723 contract BEP20 is Context, IBEP20, Ownable {
724     using SafeMath for uint256;
725 
726     mapping(address => uint256) private _balances;
727 
728     mapping(address => mapping(address => uint256)) private _allowances;
729 
730     uint256 private _totalSupply;
731 
732     string private _name;
733     string private _symbol;
734     uint8 private _decimals;
735 
736     /**
737      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
738      * a default value of 18.
739      *
740      * To select a different value for {decimals}, use {_setupDecimals}.
741      *
742      * All three of these values are immutable: they can only be set once during
743      * construction.
744      */
745     constructor(string memory name, string memory symbol) public {
746         _name = name;
747         _symbol = symbol;
748         _decimals = 18;
749     }
750 
751     /**
752      * @dev Returns the bep token owner.
753      */
754     function getOwner() external override view returns (address) {
755         return owner();
756     }
757 
758     /**
759      * @dev Returns the name of the token.
760      */
761     function name() public override view returns (string memory) {
762         return _name;
763     }
764 
765     /**
766      * @dev Returns the symbol of the token, usually a shorter version of the
767      * name.
768      */
769     function symbol() public override view returns (string memory) {
770         return _symbol;
771     }
772 
773     /**
774     * @dev Returns the number of decimals used to get its user representation.
775     */
776     function decimals() public override view returns (uint8) {
777         return _decimals;
778     }
779 
780     /**
781      * @dev See {BEP20-totalSupply}.
782      */
783     function totalSupply() public override view returns (uint256) {
784         return _totalSupply;
785     }
786 
787     /**
788      * @dev See {BEP20-balanceOf}.
789      */
790     function balanceOf(address account) public override view returns (uint256) {
791         return _balances[account];
792     }
793 
794     /**
795      * @dev See {BEP20-transfer}.
796      *
797      * Requirements:
798      *
799      * - `recipient` cannot be the zero address.
800      * - the caller must have a balance of at least `amount`.
801      */
802     function transfer(address recipient, uint256 amount) public override returns (bool) {
803         _transfer(_msgSender(), recipient, amount);
804         return true;
805     }
806 
807     /**
808      * @dev See {BEP20-allowance}.
809      */
810     function allowance(address owner, address spender) public override view returns (uint256) {
811         return _allowances[owner][spender];
812     }
813 
814     /**
815      * @dev See {BEP20-approve}.
816      *
817      * Requirements:
818      *
819      * - `spender` cannot be the zero address.
820      */
821     function approve(address spender, uint256 amount) public override returns (bool) {
822         _approve(_msgSender(), spender, amount);
823         return true;
824     }
825 
826     /**
827      * @dev See {BEP20-transferFrom}.
828      *
829      * Emits an {Approval} event indicating the updated allowance. This is not
830      * required by the EIP. See the note at the beginning of {BEP20};
831      *
832      * Requirements:
833      * - `sender` and `recipient` cannot be the zero address.
834      * - `sender` must have a balance of at least `amount`.
835      * - the caller must have allowance for `sender`'s tokens of at least
836      * `amount`.
837      */
838     function transferFrom (address sender, address recipient, uint256 amount) public override returns (bool) {
839         _transfer(sender, recipient, amount);
840         _approve(
841             sender,
842             _msgSender(),
843             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
844         );
845         return true;
846     }
847 
848     /**
849      * @dev Atomically increases the allowance granted to `spender` by the caller.
850      *
851      * This is an alternative to {approve} that can be used as a mitigation for
852      * problems described in {BEP20-approve}.
853      *
854      * Emits an {Approval} event indicating the updated allowance.
855      *
856      * Requirements:
857      *
858      * - `spender` cannot be the zero address.
859      */
860     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
861         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
862         return true;
863     }
864 
865     /**
866      * @dev Atomically decreases the allowance granted to `spender` by the caller.
867      *
868      * This is an alternative to {approve} that can be used as a mitigation for
869      * problems described in {BEP20-approve}.
870      *
871      * Emits an {Approval} event indicating the updated allowance.
872      *
873      * Requirements:
874      *
875      * - `spender` cannot be the zero address.
876      * - `spender` must have allowance for the caller of at least
877      * `subtractedValue`.
878      */
879     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
880         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero'));
881         return true;
882     }
883 
884     /**
885      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
886      * the total supply.
887      *
888      * Requirements
889      *
890      * - `msg.sender` must be the token owner
891      */
892     function mint(uint256 amount) public onlyOwner returns (bool) {
893         _mint(_msgSender(), amount);
894         return true;
895     }
896 
897     /**
898      * @dev Moves tokens `amount` from `sender` to `recipient`.
899      *
900      * This is internal function is equivalent to {transfer}, and can be used to
901      * e.g. implement automatic token fees, slashing mechanisms, etc.
902      *
903      * Emits a {Transfer} event.
904      *
905      * Requirements:
906      *
907      * - `sender` cannot be the zero address.
908      * - `recipient` cannot be the zero address.
909      * - `sender` must have a balance of at least `amount`.
910      */
911     function _transfer (address sender, address recipient, uint256 amount) internal virtual {
912         require(sender != address(0), 'BEP20: transfer from the zero address');
913         require(recipient != address(0), 'BEP20: transfer to the zero address');
914 
915         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
916         _balances[recipient] = _balances[recipient].add(amount);
917         emit Transfer(sender, recipient, amount);
918     }
919 
920     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
921      * the total supply.
922      *
923      * Emits a {Transfer} event with `from` set to the zero address.
924      *
925      * Requirements
926      *
927      * - `to` cannot be the zero address.
928      */
929     function _mint(address account, uint256 amount) internal {
930         require(account != address(0), 'BEP20: mint to the zero address');
931 
932         _totalSupply = _totalSupply.add(amount);
933         _balances[account] = _balances[account].add(amount);
934         emit Transfer(address(0), account, amount);
935     }
936 
937     /**
938      * @dev Destroys `amount` tokens from `account`, reducing the
939      * total supply.
940      *
941      * Emits a {Transfer} event with `to` set to the zero address.
942      *
943      * Requirements
944      *
945      * - `account` cannot be the zero address.
946      * - `account` must have at least `amount` tokens.
947      */
948     function _burn(address account, uint256 amount) internal {
949         require(account != address(0), 'BEP20: burn from the zero address');
950 
951         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
952         _totalSupply = _totalSupply.sub(amount);
953         emit Transfer(account, address(0), amount);
954     }
955 
956     /**
957      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
958      *
959      * This is internal function is equivalent to `approve`, and can be used to
960      * e.g. set automatic allowances for certain subsystems, etc.
961      *
962      * Emits an {Approval} event.
963      *
964      * Requirements:
965      *
966      * - `owner` cannot be the zero address.
967      * - `spender` cannot be the zero address.
968      */
969     function _approve (address owner, address spender, uint256 amount) internal {
970         require(owner != address(0), 'BEP20: approve from the zero address');
971         require(spender != address(0), 'BEP20: approve to the zero address');
972 
973         _allowances[owner][spender] = amount;
974         emit Approval(owner, spender, amount);
975     }
976 
977     /**
978      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
979      * from the caller's allowance.
980      *
981      * See {_burn} and {_approve}.
982      */
983     function _burnFrom(address account, uint256 amount) internal {
984         _burn(account, amount);
985         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance'));
986     }
987 }
988 
989 // File: contracts\IUniswapV2Router01.sol
990 
991 pragma solidity >=0.6.2;
992 
993 interface IUniswapV2Router01 {
994     function factory() external pure returns (address);
995     function WETH() external pure returns (address);
996 
997     function addLiquidity(
998         address tokenA,
999         address tokenB,
1000         uint amountADesired,
1001         uint amountBDesired,
1002         uint amountAMin,
1003         uint amountBMin,
1004         address to,
1005         uint deadline
1006     ) external returns (uint amountA, uint amountB, uint liquidity);
1007     function addLiquidityETH(
1008         address token,
1009         uint amountTokenDesired,
1010         uint amountTokenMin,
1011         uint amountETHMin,
1012         address to,
1013         uint deadline
1014     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1015     function removeLiquidity(
1016         address tokenA,
1017         address tokenB,
1018         uint liquidity,
1019         uint amountAMin,
1020         uint amountBMin,
1021         address to,
1022         uint deadline
1023     ) external returns (uint amountA, uint amountB);
1024     function removeLiquidityETH(
1025         address token,
1026         uint liquidity,
1027         uint amountTokenMin,
1028         uint amountETHMin,
1029         address to,
1030         uint deadline
1031     ) external returns (uint amountToken, uint amountETH);
1032     function removeLiquidityWithPermit(
1033         address tokenA,
1034         address tokenB,
1035         uint liquidity,
1036         uint amountAMin,
1037         uint amountBMin,
1038         address to,
1039         uint deadline,
1040         bool approveMax, uint8 v, bytes32 r, bytes32 s
1041     ) external returns (uint amountA, uint amountB);
1042     function removeLiquidityETHWithPermit(
1043         address token,
1044         uint liquidity,
1045         uint amountTokenMin,
1046         uint amountETHMin,
1047         address to,
1048         uint deadline,
1049         bool approveMax, uint8 v, bytes32 r, bytes32 s
1050     ) external returns (uint amountToken, uint amountETH);
1051     function swapExactTokensForTokens(
1052         uint amountIn,
1053         uint amountOutMin,
1054         address[] calldata path,
1055         address to,
1056         uint deadline
1057     ) external returns (uint[] memory amounts);
1058     function swapTokensForExactTokens(
1059         uint amountOut,
1060         uint amountInMax,
1061         address[] calldata path,
1062         address to,
1063         uint deadline
1064     ) external returns (uint[] memory amounts);
1065     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1066         external
1067         payable
1068         returns (uint[] memory amounts);
1069     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1070         external
1071         returns (uint[] memory amounts);
1072     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1073         external
1074         returns (uint[] memory amounts);
1075     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1076         external
1077         payable
1078         returns (uint[] memory amounts);
1079 
1080     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1081     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1082     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1083     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1084     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1085 }
1086 
1087 // File: contracts\IUniswapV2Router02.sol
1088 
1089 pragma solidity >=0.6.2;
1090 
1091 
1092 interface IUniswapV2Router02 is IUniswapV2Router01 {
1093     function removeLiquidityETHSupportingFeeOnTransferTokens(
1094         address token,
1095         uint liquidity,
1096         uint amountTokenMin,
1097         uint amountETHMin,
1098         address to,
1099         uint deadline
1100     ) external returns (uint amountETH);
1101     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1102         address token,
1103         uint liquidity,
1104         uint amountTokenMin,
1105         uint amountETHMin,
1106         address to,
1107         uint deadline,
1108         bool approveMax, uint8 v, bytes32 r, bytes32 s
1109     ) external returns (uint amountETH);
1110 
1111     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1112         uint amountIn,
1113         uint amountOutMin,
1114         address[] calldata path,
1115         address to,
1116         uint deadline
1117     ) external;
1118     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1119         uint amountOutMin,
1120         address[] calldata path,
1121         address to,
1122         uint deadline
1123     ) external payable;
1124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1125         uint amountIn,
1126         uint amountOutMin,
1127         address[] calldata path,
1128         address to,
1129         uint deadline
1130     ) external;
1131 }
1132 
1133 // File: contracts\IUniswapV2Pair.sol
1134 
1135 pragma solidity >=0.5.0;
1136 
1137 interface IUniswapV2Pair {
1138     event Approval(address indexed owner, address indexed spender, uint value);
1139     event Transfer(address indexed from, address indexed to, uint value);
1140 
1141     function name() external pure returns (string memory);
1142     function symbol() external pure returns (string memory);
1143     function decimals() external pure returns (uint8);
1144     function totalSupply() external view returns (uint);
1145     function balanceOf(address owner) external view returns (uint);
1146     function allowance(address owner, address spender) external view returns (uint);
1147 
1148     function approve(address spender, uint value) external returns (bool);
1149     function transfer(address to, uint value) external returns (bool);
1150     function transferFrom(address from, address to, uint value) external returns (bool);
1151 
1152     function DOMAIN_SEPARATOR() external view returns (bytes32);
1153     function PERMIT_TYPEHASH() external pure returns (bytes32);
1154     function nonces(address owner) external view returns (uint);
1155 
1156     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1157 
1158     event Mint(address indexed sender, uint amount0, uint amount1);
1159     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1160     event Swap(
1161         address indexed sender,
1162         uint amount0In,
1163         uint amount1In,
1164         uint amount0Out,
1165         uint amount1Out,
1166         address indexed to
1167     );
1168     event Sync(uint112 reserve0, uint112 reserve1);
1169 
1170     function MINIMUM_LIQUIDITY() external pure returns (uint);
1171     function factory() external view returns (address);
1172     function token0() external view returns (address);
1173     function token1() external view returns (address);
1174     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1175     function price0CumulativeLast() external view returns (uint);
1176     function price1CumulativeLast() external view returns (uint);
1177     function kLast() external view returns (uint);
1178 
1179     function mint(address to) external returns (uint liquidity);
1180     function burn(address to) external returns (uint amount0, uint amount1);
1181     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1182     function skim(address to) external;
1183     function sync() external;
1184 
1185     function initialize(address, address) external;
1186 }
1187 
1188 // File: contracts\IUniswapV2Factory.sol
1189 
1190 pragma solidity >=0.5.0;
1191 
1192 interface IUniswapV2Factory {
1193     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1194 
1195     function feeTo() external view returns (address);
1196     function feeToSetter() external view returns (address);
1197 
1198     function getPair(address tokenA, address tokenB) external view returns (address pair);
1199     function allPairs(uint) external view returns (address pair);
1200     function allPairsLength() external view returns (uint);
1201 
1202     function createPair(address tokenA, address tokenB) external returns (address pair);
1203 
1204     function setFeeTo(address) external;
1205     function setFeeToSetter(address) external;
1206 }
1207 
1208 // File: contracts\WUKONGToken.sol
1209 
1210 pragma solidity 0.6.12;
1211 
1212 
1213 
1214 
1215 
1216 library EnumerableSet {
1217     // To implement this library for multiple types with as little code
1218     // repetition as possible, we write it in terms of a generic Set type with
1219     // bytes32 values.
1220     // The Set implementation uses private functions, and user-facing
1221     // implementations (such as AddressSet) are just wrappers around the
1222     // underlying Set.
1223     // This means that we can only create new EnumerableSets for types that fit
1224     // in bytes32.
1225 
1226     struct Set {
1227         // Storage of set values
1228         bytes32[] _values;
1229         // Position of the value in the `values` array, plus 1 because index 0
1230         // means a value is not in the set.
1231         mapping(bytes32 => uint256) _indexes;
1232     }
1233 
1234     /**
1235      * @dev Add a value to a set. O(1).
1236      *
1237      * Returns true if the value was added to the set, that is if it was not
1238      * already present.
1239      */
1240     function _add(Set storage set, bytes32 value) private returns (bool) {
1241         if (!_contains(set, value)) {
1242             set._values.push(value);
1243             // The value is stored at length-1, but we add 1 to all indexes
1244             // and use 0 as a sentinel value
1245             set._indexes[value] = set._values.length;
1246             return true;
1247         } else {
1248             return false;
1249         }
1250     }
1251 
1252     /**
1253      * @dev Removes a value from a set. O(1).
1254      *
1255      * Returns true if the value was removed from the set, that is if it was
1256      * present.
1257      */
1258     function _remove(Set storage set, bytes32 value) private returns (bool) {
1259         // We read and store the value's index to prevent multiple reads from the same storage slot
1260         uint256 valueIndex = set._indexes[value];
1261 
1262         if (valueIndex != 0) {
1263             // Equivalent to contains(set, value)
1264             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1265             // the array, and then remove the last element (sometimes called as 'swap and pop').
1266             // This modifies the order of the array, as noted in {at}.
1267 
1268             uint256 toDeleteIndex = valueIndex - 1;
1269             uint256 lastIndex = set._values.length - 1;
1270 
1271             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1272             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1273 
1274             bytes32 lastvalue = set._values[lastIndex];
1275 
1276             // Move the last value to the index where the value to delete is
1277             set._values[toDeleteIndex] = lastvalue;
1278             // Update the index for the moved value
1279             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1280 
1281             // Delete the slot where the moved value was stored
1282             set._values.pop();
1283 
1284             // Delete the index for the deleted slot
1285             delete set._indexes[value];
1286 
1287             return true;
1288         } else {
1289             return false;
1290         }
1291     }
1292 
1293     /**
1294      * @dev Returns true if the value is in the set. O(1).
1295      */
1296     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1297         return set._indexes[value] != 0;
1298     }
1299 
1300     /**
1301      * @dev Returns the number of values on the set. O(1).
1302      */
1303     function _length(Set storage set) private view returns (uint256) {
1304         return set._values.length;
1305     }
1306 
1307     /**
1308      * @dev Returns the value stored at position `index` in the set. O(1).
1309      *
1310      * Note that there are no guarantees on the ordering of values inside the
1311      * array, and it may change when more values are added or removed.
1312      *
1313      * Requirements:
1314      *
1315      * - `index` must be strictly less than {length}.
1316      */
1317     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1318         require(set._values.length > index, 'EnumerableSet: index out of bounds');
1319         return set._values[index];
1320     }
1321 
1322     // AddressSet
1323 
1324     struct AddressSet {
1325         Set _inner;
1326     }
1327 
1328     /**
1329      * @dev Add a value to a set. O(1).
1330      *
1331      * Returns true if the value was added to the set, that is if it was not
1332      * already present.
1333      */
1334     function add(AddressSet storage set, address value) internal returns (bool) {
1335         return _add(set._inner, bytes32(uint256(value)));
1336     }
1337 
1338     /**
1339      * @dev Removes a value from a set. O(1).
1340      *
1341      * Returns true if the value was removed from the set, that is if it was
1342      * present.
1343      */
1344     function remove(AddressSet storage set, address value) internal returns (bool) {
1345         return _remove(set._inner, bytes32(uint256(value)));
1346     }
1347 
1348     /**
1349      * @dev Returns true if the value is in the set. O(1).
1350      */
1351     function contains(AddressSet storage set, address value) internal view returns (bool) {
1352         return _contains(set._inner, bytes32(uint256(value)));
1353     }
1354 
1355     /**
1356      * @dev Returns the number of values in the set. O(1).
1357      */
1358     function length(AddressSet storage set) internal view returns (uint256) {
1359         return _length(set._inner);
1360     }
1361 
1362     /**
1363      * @dev Returns the value stored at position `index` in the set. O(1).
1364      *
1365      * Note that there are no guarantees on the ordering of values inside the
1366      * array, and it may change when more values are added or removed.
1367      *
1368      * Requirements:
1369      *
1370      * - `index` must be strictly less than {length}.
1371      */
1372     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1373         return address(uint256(_at(set._inner, index)));
1374     }
1375 
1376     // UintSet
1377 
1378     struct UintSet {
1379         Set _inner;
1380     }
1381 
1382     /**
1383      * @dev Add a value to a set. O(1).
1384      *
1385      * Returns true if the value was added to the set, that is if it was not
1386      * already present.
1387      */
1388     function add(UintSet storage set, uint256 value) internal returns (bool) {
1389         return _add(set._inner, bytes32(value));
1390     }
1391 
1392     /**
1393      * @dev Removes a value from a set. O(1).
1394      *
1395      * Returns true if the value was removed from the set, that is if it was
1396      * present.
1397      */
1398     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1399         return _remove(set._inner, bytes32(value));
1400     }
1401 
1402     /**
1403      * @dev Returns true if the value is in the set. O(1).
1404      */
1405     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1406         return _contains(set._inner, bytes32(value));
1407     }
1408 
1409     /**
1410      * @dev Returns the number of values on the set. O(1).
1411      */
1412     function length(UintSet storage set) internal view returns (uint256) {
1413         return _length(set._inner);
1414     }
1415 
1416     /**
1417      * @dev Returns the value stored at position `index` in the set. O(1).
1418      *
1419      * Note that there are no guarantees on the ordering of values inside the
1420      * array, and it may change when more values are added or removed.
1421      *
1422      * Requirements:
1423      *
1424      * - `index` must be strictly less than {length}.
1425      */
1426     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1427         return uint256(_at(set._inner, index));
1428     }
1429 }
1430 
1431 // MonkeyKing with Governance.
1432 contract MonkeyKing is BEP20 {
1433     // Transfer tax rate in basis points. (default 1%)
1434     uint16 public transferTaxRate = 100;
1435 
1436     // Burn rate % of transfer tax. (default 20% x 1% = 0.2% of total amount).
1437     uint16 public burnRate = 20;
1438     // Max transfer tax rate: 10%.
1439     uint16 public constant MAXIMUM_TRANSFER_TAX_RATE = 1000;
1440     // Burn address
1441     address public constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
1442 
1443     // Max transfer amount rate in basis points. (default is 0.00012% of total supply)
1444     uint16 public maxTransferAmountRate = 12;
1445     // Addresses that excluded from antiWhale
1446     mapping(address => bool) private _excludedFromAntiWhale;
1447     // Automatic swap and liquify enabled
1448     bool public swapAndLiquifyEnabled = false;    
1449     // Min amount to liquify. (default 500 WUKONGs)
1450     uint256 public minAmountToLiquify = 500 ether;
1451     // The swap router, modifiable. Will be changed to Wukong's router when our own AMM release
1452     IUniswapV2Router02 public wukongRouter;
1453     // The trading pair
1454     address public wukongPair;
1455     // In swap and liquify
1456     bool private _inSwapAndLiquify;
1457 
1458     // The operator can only update the transfer tax rate
1459     address private _operator;
1460 
1461     EnumerableSet.AddressSet private _minters;
1462     EnumerableSet.AddressSet private _blockAddrs;
1463 
1464     // Open Trade
1465     bool public tradingOpen;
1466     // Max Wallet Size
1467     uint256 public _maxWalletSize = 1000000*10**18; //1M
1468 
1469     // Events
1470     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
1471     event TransferTaxRateUpdated(address indexed operator, uint256 previousRate, uint256 newRate);
1472     event BurnRateUpdated(address indexed operator, uint256 previousRate, uint256 newRate);
1473     event MaxTransferAmountRateUpdated(address indexed operator, uint256 previousRate, uint256 newRate);
1474     event SwapAndLiquifyEnabledUpdated(address indexed operator, bool enabled);
1475     event MinAmountToLiquifyUpdated(address indexed operator, uint256 previousAmount, uint256 newAmount);
1476     event WukongRouterUpdated(address indexed operator, address indexed router, address indexed pair);
1477     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
1478 
1479     modifier onlyOperator() {
1480         require(_operator == msg.sender, "operator: caller is not the operator");
1481         _;
1482     }
1483 
1484     //Check all wale activity here
1485     modifier antiWhale(address sender, address recipient, uint256 amount) {
1486         if (
1487             _excludedFromAntiWhale[sender] == false
1488             && _excludedFromAntiWhale[recipient] == false
1489         ) {
1490             //Check Max Transfer
1491             require(amount <= maxTransferAmount(), "WUKONG::antiWhale: Transfer amount exceeds the maxTransferAmount");
1492             
1493             //Check Max Wallet at buy
1494             if(sender == wukongPair && recipient != address(wukongRouter)) {
1495                 require(balanceOf(recipient) + amount < _maxWalletSize, "Balance exceeds wallet size!");
1496             }
1497 
1498             //Check open trade
1499             require(tradingOpen, "Trading is not open");
1500         }
1501         _;
1502     }
1503 
1504     modifier lockTheSwap {
1505         _inSwapAndLiquify = true;
1506         _;
1507         _inSwapAndLiquify = false;
1508     }
1509 
1510     modifier transferTaxFree {
1511         uint16 _transferTaxRate = transferTaxRate;
1512         transferTaxRate = 0;
1513         _;
1514         transferTaxRate = _transferTaxRate;
1515     }
1516 
1517     /**
1518      * @notice Constructs the WUKONG Token contract.
1519      */
1520     constructor() public BEP20("Monkey King", "WUKONG") {
1521         _operator = _msgSender();
1522         emit OperatorTransferred(address(0), _operator);
1523 
1524         _excludedFromAntiWhale[msg.sender] = true;
1525         _excludedFromAntiWhale[address(0)] = true;
1526         _excludedFromAntiWhale[address(this)] = true;
1527         _excludedFromAntiWhale[BURN_ADDRESS] = true;
1528     }
1529 
1530     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1531     function mint(address _to, uint256 _amount) public onlyMinter returns(bool) {
1532         _mint(_to, _amount);
1533         _moveDelegates(address(0), _delegates[_to], _amount);
1534         return true;
1535     }
1536 
1537     /// @dev overrides transfer function to meet tokenomics of WUKONG
1538     function _transfer(address sender, address recipient, uint256 amount) internal virtual override antiWhale(sender, recipient, amount) {
1539         require(sender != address(0), "WUKONG::sender is not valid");
1540 
1541         //Check Block Addr
1542         require(!isBlockAddr(sender), "sender can't be blockaddr");
1543         require(!isBlockAddr(recipient), "recipient can't be blockaddr");
1544 
1545         // swap and liquify
1546         if (
1547             swapAndLiquifyEnabled == true
1548             && _inSwapAndLiquify == false
1549             && address(wukongRouter) != address(0)
1550             && wukongPair != address(0)
1551             && sender != wukongPair
1552             && sender != owner()
1553         ) {
1554             swapAndLiquify();
1555         }
1556 
1557         if (recipient == BURN_ADDRESS || transferTaxRate == 0) {
1558             super._transfer(sender, recipient, amount);
1559             if (recipient != BURN_ADDRESS) {
1560                 _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1561             }
1562         } else {
1563             // default tax is 5% of every transfer
1564             uint256 taxAmount = amount.mul(transferTaxRate).div(10000);
1565             uint256 burnAmount = taxAmount.mul(burnRate).div(100);
1566             uint256 liquidityAmount = taxAmount.sub(burnAmount);
1567             require(taxAmount == burnAmount + liquidityAmount, "WUKONG::transfer: Burn value invalid");
1568 
1569             // default 95% of transfer sent to recipient
1570             uint256 sendAmount = amount.sub(taxAmount);
1571             require(amount == sendAmount + taxAmount, "WUKONG::transfer: Tax value invalid");
1572 
1573             super._transfer(sender, BURN_ADDRESS, burnAmount);
1574             super._transfer(sender, address(this), liquidityAmount);
1575             super._transfer(sender, recipient, sendAmount);
1576             _moveDelegates(_delegates[sender], _delegates[recipient], sendAmount);
1577             amount = sendAmount;
1578         }
1579     }
1580 
1581     /// @dev Swap and liquify
1582     function swapAndLiquify() private lockTheSwap transferTaxFree {
1583         uint256 contractTokenBalance = balanceOf(address(this));
1584         uint256 maxTransferAmount = maxTransferAmount();
1585         contractTokenBalance = contractTokenBalance > maxTransferAmount ? maxTransferAmount : contractTokenBalance;
1586 
1587         if (contractTokenBalance >= minAmountToLiquify) {
1588             // only min amount to liquify
1589             uint256 liquifyAmount = minAmountToLiquify;
1590 
1591             // split the liquify amount into halves
1592             uint256 half = liquifyAmount.div(2);
1593             uint256 otherHalf = liquifyAmount.sub(half);
1594 
1595             // capture the contract's current ETH balance.
1596             // this is so that we can capture exactly the amount of ETH that the
1597             // swap creates, and not make the liquidity event include any ETH that
1598             // has been manually sent to the contract
1599             uint256 initialBalance = address(this).balance;
1600 
1601             // swap tokens for ETH
1602             swapTokensForEth(half);
1603 
1604             // how much ETH did we just swap into?
1605             uint256 newBalance = address(this).balance.sub(initialBalance);
1606 
1607             // add liquidity
1608             addLiquidity(otherHalf, newBalance);
1609 
1610             emit SwapAndLiquify(half, newBalance, otherHalf);
1611         }
1612     }
1613 
1614     /// @dev Swap tokens for eth
1615     function swapTokensForEth(uint256 tokenAmount) private {
1616         // generate the wukong pair path of token -> weth
1617         address[] memory path = new address[](2);
1618         path[0] = address(this);
1619         path[1] = wukongRouter.WETH();
1620 
1621         _approve(address(this), address(wukongRouter), tokenAmount);
1622 
1623         // make the swap
1624         wukongRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1625             tokenAmount,
1626             0, // accept any amount of ETH
1627             path,
1628             address(this),
1629             block.timestamp
1630         );
1631     }
1632 
1633     /// @dev Add liquidity
1634     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1635         // approve token transfer to cover all possible scenarios
1636         _approve(address(this), address(wukongRouter), tokenAmount);
1637 
1638         // add the liquidity
1639         wukongRouter.addLiquidityETH{value: ethAmount}(
1640             address(this),
1641             tokenAmount,
1642             0, // slippage is unavoidable
1643             0, // slippage is unavoidable
1644             operator(),
1645             block.timestamp
1646         );
1647     }
1648 
1649     /**
1650      * @dev Returns the max transfer amount.
1651      */
1652     function maxTransferAmount() public view returns (uint256) {
1653         return totalSupply().mul(maxTransferAmountRate).div(10000000);
1654     }
1655 
1656     /**
1657      * @dev Returns the address is excluded from antiWhale or not.
1658      */
1659     function isExcludedFromAntiWhale(address _account) public view returns (bool) {
1660         return _excludedFromAntiWhale[_account];
1661     }
1662 
1663     // To receive BNB from wukongRouter when swapping
1664     receive() external payable {}
1665 
1666     /**
1667      * @dev Update the transfer tax rate.
1668      * Can only be called by the current operator.
1669      */
1670     function updateTransferTaxRate(uint16 _transferTaxRate) public onlyOperator {
1671         require(_transferTaxRate <= MAXIMUM_TRANSFER_TAX_RATE, "WUKONG::updateTransferTaxRate: Transfer tax rate must not exceed the maximum rate.");
1672         emit TransferTaxRateUpdated(msg.sender, transferTaxRate, _transferTaxRate);
1673         transferTaxRate = _transferTaxRate;
1674     }
1675 
1676     /**
1677      * @dev Update the burn rate.
1678      * Can only be called by the current operator.
1679      */
1680     function updateBurnRate(uint16 _burnRate) public onlyOperator {
1681         require(_burnRate <= 100, "WUKONG::updateBurnRate: Burn rate must not exceed the maximum rate.");
1682         emit BurnRateUpdated(msg.sender, burnRate, _burnRate);
1683         burnRate = _burnRate;
1684     }
1685 
1686     /**
1687      * @dev Update the max transfer amount rate.
1688      * Can only be called by the current operator.
1689      */
1690     function updateMaxTransferAmountRate(uint16 _maxTransferAmountRate) public onlyOperator {
1691         require(_maxTransferAmountRate <= 10000, "WUKONG::updateMaxTransferAmountRate: Max transfer amount rate must not exceed the maximum rate.");
1692         emit MaxTransferAmountRateUpdated(msg.sender, maxTransferAmountRate, _maxTransferAmountRate);
1693         maxTransferAmountRate = _maxTransferAmountRate;
1694     }
1695 
1696     /**
1697      * @dev Update the min amount to liquify.
1698      * Can only be called by the current operator.
1699      */
1700     function updateMinAmountToLiquify(uint256 _minAmount) public onlyOperator {
1701         emit MinAmountToLiquifyUpdated(msg.sender, minAmountToLiquify, _minAmount);
1702         minAmountToLiquify = _minAmount;
1703     }
1704 
1705     /**
1706      * @dev Exclude or include an address from antiWhale.
1707      * Can only be called by the current operator.
1708      */
1709     function setExcludedFromAntiWhale(address _account, bool _excluded) public onlyOperator {
1710         _excludedFromAntiWhale[_account] = _excluded;
1711     }
1712 
1713     /**
1714      * @dev Update the swapAndLiquifyEnabled.
1715      * Can only be called by the current operator.
1716      */
1717     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOperator {
1718         emit SwapAndLiquifyEnabledUpdated(msg.sender, _enabled);
1719         swapAndLiquifyEnabled = _enabled;
1720     }
1721 
1722     /**
1723      * @dev Update the swap router.
1724      * Can only be called by the current operator.
1725      */
1726     function updateWukongRouter(address _router) public onlyOperator {
1727         wukongRouter = IUniswapV2Router02(_router);
1728         wukongPair = IUniswapV2Factory(wukongRouter.factory()).getPair(address(this), wukongRouter.WETH());
1729         require(wukongPair != address(0), "WUKONG::updateWukongRouter: Invalid pair address.");
1730         emit WukongRouterUpdated(msg.sender, address(wukongRouter), wukongPair);
1731     }
1732 
1733     /**
1734      * @dev Returns the address of the current operator.
1735      */
1736     function operator() public view returns (address) {
1737         return _operator;
1738     }
1739 
1740     /**
1741      * @dev Transfers operator of the contract to a new account (`newOperator`).
1742      * Can only be called by the current operator.
1743      */
1744     function transferOperator(address newOperator) public onlyOperator {
1745         require(newOperator != address(0), "WUKONG::transferOperator: new operator is the zero address");
1746         emit OperatorTransferred(_operator, newOperator);
1747         _operator = newOperator;
1748     }
1749 
1750     // Copied and modified from YAM code:
1751     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1752     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1753     // Which is copied and modified from COMPOUND:
1754     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1755 
1756     /// @dev A record of each accounts delegate
1757     mapping (address => address) internal _delegates;
1758 
1759     /// @notice A checkpoint for marking number of votes from a given block
1760     struct Checkpoint {
1761         uint32 fromBlock;
1762         uint256 votes;
1763     }
1764 
1765     /// @notice A record of votes checkpoints for each account, by index
1766     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1767 
1768     /// @notice The number of checkpoints for each account
1769     mapping (address => uint32) public numCheckpoints;
1770 
1771     /// @notice The EIP-712 typehash for the contract's domain
1772     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1773 
1774     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1775     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1776 
1777     /// @notice A record of states for signing / validating signatures
1778     mapping (address => uint) public nonces;
1779 
1780       /// @notice An event thats emitted when an account changes its delegate
1781     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1782 
1783     /// @notice An event thats emitted when a delegate account's vote balance changes
1784     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1785 
1786     /**
1787      * @notice Delegate votes from `msg.sender` to `delegatee`
1788      * @param delegator The address to get delegatee for
1789      */
1790     function delegates(address delegator)
1791         external
1792         view
1793         returns (address)
1794     {
1795         return _delegates[delegator];
1796     }
1797 
1798    /**
1799     * @notice Delegate votes from `msg.sender` to `delegatee`
1800     * @param delegatee The address to delegate votes to
1801     */
1802     function delegate(address delegatee) external {
1803         return _delegate(msg.sender, delegatee);
1804     }
1805 
1806     /**
1807      * @notice Delegates votes from signatory to `delegatee`
1808      * @param delegatee The address to delegate votes to
1809      * @param nonce The contract state required to match the signature
1810      * @param expiry The time at which to expire the signature
1811      * @param v The recovery byte of the signature
1812      * @param r Half of the ECDSA signature pair
1813      * @param s Half of the ECDSA signature pair
1814      */
1815     function delegateBySig(
1816         address delegatee,
1817         uint nonce,
1818         uint expiry,
1819         uint8 v,
1820         bytes32 r,
1821         bytes32 s
1822     )
1823         external
1824     {
1825         bytes32 domainSeparator = keccak256(
1826             abi.encode(
1827                 DOMAIN_TYPEHASH,
1828                 keccak256(bytes(name())),
1829                 getChainId(),
1830                 address(this)
1831             )
1832         );
1833 
1834         bytes32 structHash = keccak256(
1835             abi.encode(
1836                 DELEGATION_TYPEHASH,
1837                 delegatee,
1838                 nonce,
1839                 expiry
1840             )
1841         );
1842 
1843         bytes32 digest = keccak256(
1844             abi.encodePacked(
1845                 "\x19\x01",
1846                 domainSeparator,
1847                 structHash
1848             )
1849         );
1850 
1851         address signatory = ecrecover(digest, v, r, s);
1852         require(signatory != address(0), "WUKONG::delegateBySig: invalid signature");
1853         require(nonce == nonces[signatory]++, "WUKONG::delegateBySig: invalid nonce");
1854         require(now <= expiry, "WUKONG::delegateBySig: signature expired");
1855         return _delegate(signatory, delegatee);
1856     }
1857 
1858     /**
1859      * @notice Gets the current votes balance for `account`
1860      * @param account The address to get votes balance
1861      * @return The number of current votes for `account`
1862      */
1863     function getCurrentVotes(address account)
1864         external
1865         view
1866         returns (uint256)
1867     {
1868         uint32 nCheckpoints = numCheckpoints[account];
1869         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1870     }
1871 
1872     /**
1873      * @notice Determine the prior number of votes for an account as of a block number
1874      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1875      * @param account The address of the account to check
1876      * @param blockNumber The block number to get the vote balance at
1877      * @return The number of votes the account had as of the given block
1878      */
1879     function getPriorVotes(address account, uint blockNumber)
1880         external
1881         view
1882         returns (uint256)
1883     {
1884         require(blockNumber < block.number, "WUKONG::getPriorVotes: not yet determined");
1885 
1886         uint32 nCheckpoints = numCheckpoints[account];
1887         if (nCheckpoints == 0) {
1888             return 0;
1889         }
1890 
1891         // First check most recent balance
1892         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1893             return checkpoints[account][nCheckpoints - 1].votes;
1894         }
1895 
1896         // Next check implicit zero balance
1897         if (checkpoints[account][0].fromBlock > blockNumber) {
1898             return 0;
1899         }
1900 
1901         uint32 lower = 0;
1902         uint32 upper = nCheckpoints - 1;
1903         while (upper > lower) {
1904             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1905             Checkpoint memory cp = checkpoints[account][center];
1906             if (cp.fromBlock == blockNumber) {
1907                 return cp.votes;
1908             } else if (cp.fromBlock < blockNumber) {
1909                 lower = center;
1910             } else {
1911                 upper = center - 1;
1912             }
1913         }
1914         return checkpoints[account][lower].votes;
1915     }
1916 
1917     function _delegate(address delegator, address delegatee)
1918         internal
1919     {
1920         address currentDelegate = _delegates[delegator];
1921         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying WUKONGs (not scaled);
1922         _delegates[delegator] = delegatee;
1923 
1924         emit DelegateChanged(delegator, currentDelegate, delegatee);
1925 
1926         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1927     }
1928 
1929     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1930         if (srcRep != dstRep && amount > 0) {
1931             if (srcRep != address(0)) {
1932                 // decrease old representative
1933                 uint32 srcRepNum = numCheckpoints[srcRep];
1934                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1935                 uint256 srcRepNew = srcRepOld.sub(amount);
1936                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1937             }
1938 
1939             if (dstRep != address(0)) {
1940                 // increase new representative
1941                 uint32 dstRepNum = numCheckpoints[dstRep];
1942                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1943                 uint256 dstRepNew = dstRepOld.add(amount);
1944                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1945             }
1946         }
1947     }
1948 
1949     function _writeCheckpoint(
1950         address delegatee,
1951         uint32 nCheckpoints,
1952         uint256 oldVotes,
1953         uint256 newVotes
1954     )
1955         internal
1956     {
1957         uint32 blockNumber = safe32(block.number, "WUKONG::_writeCheckpoint: block number exceeds 32 bits");
1958 
1959         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1960             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1961         } else {
1962             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1963             numCheckpoints[delegatee] = nCheckpoints + 1;
1964         }
1965 
1966         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1967     }
1968 
1969     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1970         require(n < 2**32, errorMessage);
1971         return uint32(n);
1972     }
1973 
1974     function getChainId() internal pure returns (uint) {
1975         uint256 chainId;
1976         assembly { chainId := chainid() }
1977         return chainId;
1978     }
1979 
1980     function addMinter(address _addMinter) public onlyOwner returns (bool) {
1981         require(_addMinter != address(0), "WUKONG: _addMinter is the zero address");
1982         return EnumerableSet.add(_minters, _addMinter);
1983     }
1984 
1985     function delMinter(address _delMinter) public onlyOwner returns (bool) {
1986         require(_delMinter != address(0), "WUKONG: _delMinter is the zero address");
1987         return EnumerableSet.remove(_minters, _delMinter);
1988     }
1989 
1990     function getMinterLength() public view returns (uint256) {
1991         return EnumerableSet.length(_minters);
1992     }
1993 
1994     function isMinter(address account) public view returns (bool) {
1995         return EnumerableSet.contains(_minters, account);
1996     }
1997 
1998     function getMinter(uint256 _index) public view onlyOwner returns (address){
1999         require(_index <= getMinterLength() - 1, "WUKONG: index out of bounds");
2000         return EnumerableSet.at(_minters, _index);
2001     }
2002 
2003     // modifier for mint function
2004     modifier onlyMinter() {
2005         require(isMinter(msg.sender), "caller is not the minter");
2006         _;
2007     }
2008     
2009     function addBlockAddr(address _addBlockAddr) public onlyOwner returns (bool) {
2010         require(_addBlockAddr != address(0), "WUKONG: _addBlockAddr is the zero address");
2011         return EnumerableSet.add(_blockAddrs, _addBlockAddr);
2012     }
2013 
2014     function delBlockAddr(address _delblockAddr) public onlyOwner returns (bool) {
2015         require(_delblockAddr != address(0), "WUKONG: _delblockAddr is the zero address");
2016         return EnumerableSet.remove(_blockAddrs, _delblockAddr);
2017     }
2018 
2019     function getBlockAddrLength() public view returns (uint256) {
2020         return EnumerableSet.length(_blockAddrs);
2021     }
2022 
2023     function isBlockAddr(address account) public view returns (bool) {
2024         return EnumerableSet.contains(_blockAddrs, account);
2025     }
2026 
2027     function getBlockAddr(uint256 _index) public view onlyOwner returns (address){
2028         require(_index <= getBlockAddrLength() - 1, "WUKONG: index out of bounds");
2029         return EnumerableSet.at(_blockAddrs, _index);
2030     }
2031 
2032     // Set trading
2033     function setTrading(bool _tradingOpen) public onlyOwner {
2034         tradingOpen = _tradingOpen;
2035     }
2036 
2037     function setMaxWalletAmount(uint256 maxWalletSize) public onlyOwner() {
2038         _maxWalletSize = maxWalletSize;
2039     }
2040 
2041     // Airdrop
2042     function multiSend(address[] calldata addresses, uint256[] calldata amounts) external {
2043         require(addresses.length == amounts.length, "Must be the same length");
2044         for(uint256 i = 0; i < addresses.length; i++){
2045             _transfer(_msgSender(), addresses[i], amounts[i] * 10**18);
2046         }
2047     }
2048 
2049 }
2050 
2051 // File: contracts\WUKONGMasterChef.sol
2052 
2053 
2054 
2055 pragma solidity 0.6.12;
2056 
2057 
2058 
2059 
2060 
2061 
2062 
2063 
2064 // MasterChef is the master of Wukong. He can make Wukong and he is a fair guy.
2065 //
2066 // Note that it's ownable and the owner wields tremendous power. The ownership
2067 // will be transferred to a governance smart contract once WUKONG is sufficiently
2068 // distributed and the community can show to govern itself.
2069 //
2070 // Have fun reading it. Hopefully it's bug-free. God bless.
2071 contract MasterChef is Ownable, ReentrancyGuard {
2072     using SafeMath for uint256;
2073     using SafeBEP20 for IBEP20;
2074 
2075     // Info of each user.
2076     struct UserInfo {
2077         uint256 amount;         // How many LP tokens the user has provided.
2078         uint256 rewardDebt;     // Reward debt. See explanation below.
2079         uint256 rewardLockedUp;  // Reward locked up.
2080         //
2081         // We do some fancy math here. Basically, any point in time, the amount of WUKONGs
2082         // entitled to a user but is pending to be distributed is:
2083         //
2084         //   pending reward = (user.amount * pool.accWukongPerShare) - user.rewardDebt
2085         //
2086         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
2087         //   1. The pool's `accWukongPerShare` (and `lastRewardBlock`) gets updated.
2088         //   2. User receives the pending reward sent to his/her address.
2089         //   3. User's `amount` gets updated.
2090         //   4. User's `rewardDebt` gets updated.
2091     }
2092 
2093     // Info of each pool.
2094     struct PoolInfo {
2095         IBEP20 lpToken;           // Address of LP token contract.
2096         uint256 allocPoint;       // How many allocation points assigned to this pool. WUKONGs to distribute per block.
2097         uint256 lastRewardBlock;  // Last block number that WUKONGs distribution occurs.
2098         uint256 accWukongPerShare;   // Accumulated WUKONGs per share, times 1e12. See below.
2099         uint16 depositFeeBP;      // Deposit fee in basis points
2100     }
2101 
2102     // The WUKONG TOKEN!
2103     MonkeyKing public wukong;
2104     // Team address.
2105     address public teamAddr;
2106     // Deposit Fee address
2107     address public feeAddress;
2108     // WUKONG tokens created per block.
2109     uint256 public wukongPerBlock;
2110     // Bonus muliplier for early wukong makers.
2111     uint256 public constant BONUS_MULTIPLIER = 1;
2112     // Max harvest interval: 14 days.
2113     uint256 public constant MAXIMUM_HARVEST_INTERVAL = 14 days;
2114 
2115     // Info of each pool.
2116     PoolInfo[] public poolInfo;
2117     // Info of each user that stakes LP tokens.
2118     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
2119     // Total allocation points. Must be the sum of all allocation points in all pools.
2120     uint256 public totalAllocPoint = 0;
2121     // The block number when WUKONG mining starts.
2122     uint256 public startBlock;
2123     // Deposited amount WUKONG in MasterChef
2124     uint256 public depositedWukong;
2125     // Total locked up rewards
2126     uint256 public totalLockedUpRewards;
2127 
2128     // Wukong referral contract address.
2129     IWukongReferral public wukongReferral;
2130     // Referral commission rate in basis points.
2131     uint16 public referralCommissionRate = 100;
2132     // Max referral commission rate: 10%.
2133     uint16 public constant MAXIMUM_REFERRAL_COMMISSION_RATE = 1000;
2134 
2135     uint256 public weekLockStartTime = 1663200000;
2136     uint256 public constant WEEK_DURATION = 7 days;
2137     uint256 public constant DAY_DURATION = 1 days;
2138 
2139     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
2140     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2141     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
2142     event EmissionRateUpdated(address indexed caller, uint256 previousAmount, uint256 newAmount);
2143     event ReferralCommissionPaid(address indexed user, address indexed referrer, uint256 commissionAmount);
2144     event RewardLockedUp(address indexed user, uint256 indexed pid, uint256 amountLockedUp);
2145 
2146     constructor(
2147         MonkeyKing _wukong,
2148         address _teamAddr,
2149         address _feeAddress,
2150         uint256 _wukongPerBlock,
2151         uint256 _startBlock
2152     ) public {
2153         wukong = _wukong;
2154         teamAddr = _teamAddr;
2155         feeAddress = _feeAddress;
2156         wukongPerBlock = _wukongPerBlock;
2157         startBlock = _startBlock;
2158     }
2159 
2160     function poolLength() external view returns (uint256) {
2161         return poolInfo.length;
2162     }
2163 
2164     // Add a new lp to the pool. Can only be called by the owner.
2165     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
2166     function add(uint256 _allocPoint, IBEP20 _lpToken, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
2167         require(_depositFeeBP <= 10000, "add: invalid deposit fee basis points");
2168         if (_withUpdate) {
2169             massUpdatePools();
2170         }
2171         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
2172         totalAllocPoint = totalAllocPoint.add(_allocPoint);
2173         poolInfo.push(PoolInfo({
2174             lpToken: _lpToken,
2175             allocPoint: _allocPoint,
2176             lastRewardBlock: lastRewardBlock,
2177             accWukongPerShare: 0,
2178             depositFeeBP: _depositFeeBP
2179         }));
2180     }
2181 
2182     // Update the given pool's WUKONG allocation point and deposit fee. Can only be called by the owner.
2183     function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
2184         require(_depositFeeBP <= 10000, "set: invalid deposit fee basis points");
2185         if (_withUpdate) {
2186             massUpdatePools();
2187         }
2188         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
2189         poolInfo[_pid].allocPoint = _allocPoint;
2190         poolInfo[_pid].depositFeeBP = _depositFeeBP;
2191     }
2192 
2193     // Return reward multiplier over the given _from to _to block.
2194     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
2195         return _to.sub(_from).mul(BONUS_MULTIPLIER);
2196     }
2197 
2198     // View function to see pending WUKONGs on frontend.
2199     function pendingWukong(uint256 _pid, address _user) external view returns (uint256) {
2200         PoolInfo storage pool = poolInfo[_pid];
2201         UserInfo storage user = userInfo[_pid][_user];
2202         uint256 accWukongPerShare = pool.accWukongPerShare;
2203         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2204         if (_pid == 0){
2205             lpSupply = depositedWukong;
2206         }
2207         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
2208             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
2209             uint256 wukongReward = multiplier.mul(wukongPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
2210             accWukongPerShare = accWukongPerShare.add(wukongReward.mul(1e12).div(lpSupply));
2211         }
2212         uint256 pending = user.amount.mul(accWukongPerShare).div(1e12).sub(user.rewardDebt);
2213         return pending.add(user.rewardLockedUp);
2214     }
2215 
2216     // View function to see if user can harvest WUKONGs.
2217     function canHarvest() public view returns (bool) {
2218         if (block.timestamp < weekLockStartTime) 
2219             return false;
2220 
2221         uint256 weeksSec = block.timestamp.sub(weekLockStartTime).div(WEEK_DURATION).mul(WEEK_DURATION);
2222         return block.timestamp.sub(weekLockStartTime).sub(weeksSec) < DAY_DURATION;
2223     }
2224 
2225     // Update reward variables for all pools. Be careful of gas spending!
2226     function massUpdatePools() public {
2227         uint256 length = poolInfo.length;
2228         for (uint256 pid = 0; pid < length; ++pid) {
2229             updatePool(pid);
2230         }
2231     }
2232 
2233     // Update reward variables of the given pool to be up-to-date.
2234     function updatePool(uint256 _pid) public {
2235         PoolInfo storage pool = poolInfo[_pid];
2236         if (block.number <= pool.lastRewardBlock) {
2237             return;
2238         }
2239         uint256 lpSupply = pool.lpToken.balanceOf(address(this));        
2240         if (_pid == 0){
2241             lpSupply = depositedWukong;
2242         }
2243         if (lpSupply <= 0 || pool.allocPoint == 0) {
2244             pool.lastRewardBlock = block.number;
2245             return;
2246         }
2247         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
2248         uint256 wukongReward = multiplier.mul(wukongPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
2249         wukong.mint(teamAddr, wukongReward.div(10));
2250         wukong.mint(address(this), wukongReward);
2251         pool.accWukongPerShare = pool.accWukongPerShare.add(wukongReward.mul(1e12).div(lpSupply));
2252         pool.lastRewardBlock = block.number;
2253     }
2254 
2255     // Deposit LP tokens to MasterChef for WUKONG allocation.
2256     function deposit(uint256 _pid, uint256 _amount, address _referrer) public nonReentrant {
2257         require (_pid != 0, 'deposit WUKONG by staking');
2258 
2259         PoolInfo storage pool = poolInfo[_pid];
2260         UserInfo storage user = userInfo[_pid][msg.sender];
2261         updatePool(_pid);
2262         if (_amount > 0 && address(wukongReferral) != address(0) && _referrer != address(0) && _referrer != msg.sender) {
2263             wukongReferral.recordReferral(msg.sender, _referrer);
2264         }
2265         payOrLockupPendingWukong(_pid);
2266         if (_amount > 0) {
2267             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
2268             if (address(pool.lpToken) == address(wukong)) {
2269                 uint256 transferTax = _amount.mul(wukong.transferTaxRate()).div(10000);
2270                 _amount = _amount.sub(transferTax);
2271             }
2272             if (pool.depositFeeBP > 0) {
2273                 uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
2274                 pool.lpToken.safeTransfer(feeAddress, depositFee);
2275                 user.amount = user.amount.add(_amount).sub(depositFee);
2276             }else{
2277                 user.amount = user.amount.add(_amount);
2278             }
2279         }
2280         user.rewardDebt = user.amount.mul(pool.accWukongPerShare).div(1e12);
2281         emit Deposit(msg.sender, _pid, _amount);
2282     }
2283 
2284     // Withdraw LP tokens from MasterChef.
2285     function withdraw(uint256 _pid, uint256 _amount) public nonReentrant {
2286         require (_pid != 0, 'withdraw WUKONG by unstaking');
2287 
2288         PoolInfo storage pool = poolInfo[_pid];
2289         UserInfo storage user = userInfo[_pid][msg.sender];
2290         require(user.amount >= _amount, "withdraw: not good");
2291         updatePool(_pid);
2292         payOrLockupPendingWukong(_pid);
2293         if (_amount > 0) {
2294             user.amount = user.amount.sub(_amount);
2295             pool.lpToken.safeTransfer(address(msg.sender), _amount);
2296         }
2297         user.rewardDebt = user.amount.mul(pool.accWukongPerShare).div(1e12);
2298         emit Withdraw(msg.sender, _pid, _amount);
2299     }
2300 
2301     // Deposit LP tokens to MasterChef for WUKONG allocation.
2302     function enterStaking(uint256 _amount, address _referrer) public nonReentrant {
2303         PoolInfo storage pool = poolInfo[0];
2304         UserInfo storage user = userInfo[0][msg.sender];
2305         updatePool(0);
2306         if (_amount > 0 && address(wukongReferral) != address(0) && _referrer != address(0) && _referrer != msg.sender) {
2307             wukongReferral.recordReferral(msg.sender, _referrer);
2308         }
2309         payOrLockupPendingWukong(0);
2310         if (_amount > 0) {
2311             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
2312             if (address(pool.lpToken) == address(wukong)) {
2313                 uint256 transferTax = _amount.mul(wukong.transferTaxRate()).div(10000);
2314                 _amount = _amount.sub(transferTax);
2315             }
2316             user.amount = user.amount.add(_amount);
2317             depositedWukong = depositedWukong.add(_amount);
2318         }
2319         user.rewardDebt = user.amount.mul(pool.accWukongPerShare).div(1e12);
2320         emit Deposit(msg.sender, 0, _amount);
2321     }
2322 
2323     // Withdraw LP tokens from MasterChef.
2324     function leaveStaking(uint256 _amount) public nonReentrant {
2325         PoolInfo storage pool = poolInfo[0];
2326         UserInfo storage user = userInfo[0][msg.sender];
2327         require(user.amount >= _amount, "withdraw: not good");
2328         updatePool(0);
2329         payOrLockupPendingWukong(0);
2330         if (_amount > 0) {
2331             user.amount = user.amount.sub(_amount);
2332             pool.lpToken.safeTransfer(address(msg.sender), _amount);
2333             depositedWukong = depositedWukong.sub(_amount);
2334         }
2335         user.rewardDebt = user.amount.mul(pool.accWukongPerShare).div(1e12);
2336         emit Withdraw(msg.sender, 0, _amount);
2337     }
2338 
2339     // Withdraw without caring about rewards. EMERGENCY ONLY.
2340     function emergencyWithdraw(uint256 _pid) public nonReentrant {
2341         PoolInfo storage pool = poolInfo[_pid];
2342         UserInfo storage user = userInfo[_pid][msg.sender];
2343         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
2344         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
2345         user.amount = 0;
2346         user.rewardDebt = 0;
2347         user.rewardLockedUp = 0;
2348     }
2349 
2350     function _weekHarvestTimeFromNow() private view returns (uint256) {
2351         if (block.timestamp <= weekLockStartTime) 
2352             return weekLockStartTime;
2353 
2354         uint256 weeks1 = block.timestamp.sub(weekLockStartTime).div(WEEK_DURATION).add(1);
2355         return weeks1.mul(WEEK_DURATION).add(weekLockStartTime);
2356     }
2357 
2358     // Pay or lockup pending WUKONGs.
2359     function payOrLockupPendingWukong(uint256 _pid) internal {
2360         PoolInfo storage pool = poolInfo[_pid];
2361         UserInfo storage user = userInfo[_pid][msg.sender];
2362 
2363         uint256 pending = user.amount.mul(pool.accWukongPerShare).div(1e12).sub(user.rewardDebt);
2364         if (canHarvest()) {
2365             if (pending > 0 || user.rewardLockedUp > 0) {
2366                 uint256 totalRewards = pending.add(user.rewardLockedUp);
2367 
2368                 // reset lockup
2369                 totalLockedUpRewards = totalLockedUpRewards.sub(user.rewardLockedUp);
2370                 user.rewardLockedUp = 0;
2371 
2372                 // send rewards
2373                 safeWukongTransfer(msg.sender, totalRewards);
2374                 payReferralCommission(msg.sender, totalRewards);
2375             }
2376         } else if (pending > 0) {
2377             user.rewardLockedUp = user.rewardLockedUp.add(pending);
2378             totalLockedUpRewards = totalLockedUpRewards.add(pending);
2379             emit RewardLockedUp(msg.sender, _pid, pending);
2380         }
2381     }
2382     // Safe wukong transfer function, just in case if rounding error causes pool to not have enough WUKONGs.
2383     function safeWukongTransfer(address _to, uint256 _amount) internal {
2384         uint256 wukongBal = wukong.balanceOf(address(this));
2385         if (_amount > wukongBal) {
2386             wukong.transfer(_to, wukongBal);
2387         } else {
2388             wukong.transfer(_to, _amount);
2389         }
2390     }
2391 
2392     // Update team address by the previous team address.
2393     function setTeamAddress(address _teamAddress) public {
2394         require(msg.sender == teamAddr, "team: FORBIDDEN");
2395         require(_teamAddress != address(0), "team: ZERO");
2396         teamAddr = _teamAddress;
2397     }
2398 
2399     function setFeeAddress(address _feeAddress) public{
2400         require(msg.sender == feeAddress, "setFeeAddress: FORBIDDEN");
2401         require(_feeAddress != address(0), "setFeeAddress: ZERO");
2402         feeAddress = _feeAddress;
2403     }
2404 
2405     //Pancake has to add hidden dummy pools inorder to alter the emission, here we make it simple and transparent to all.
2406     function updateEmissionRate(uint256 _wukongPerBlock) public onlyOwner {
2407         massUpdatePools();
2408         emit EmissionRateUpdated(msg.sender, wukongPerBlock, _wukongPerBlock);
2409         wukongPerBlock = _wukongPerBlock;
2410     }
2411 
2412     // Update the wukong referral contract address by the owner
2413     function setWukongReferral(IWukongReferral _wukongReferral) public onlyOwner {
2414         wukongReferral = _wukongReferral;
2415     }
2416 
2417     // Update referral commission rate by the owner
2418     function setReferralCommissionRate(uint16 _referralCommissionRate) public onlyOwner {
2419         require(_referralCommissionRate <= MAXIMUM_REFERRAL_COMMISSION_RATE, "setReferralCommissionRate: invalid referral commission rate basis points");
2420         referralCommissionRate = _referralCommissionRate;
2421     }
2422 
2423     function setStartBlock(uint256 _startBlock) public onlyOwner {
2424         uint256 length = poolInfo.length;
2425         for (uint256 pid = 0; pid < length; ++pid) {            
2426             PoolInfo storage pool = poolInfo[pid];
2427             if (pool.lastRewardBlock <= _startBlock) {
2428                 pool.lastRewardBlock = _startBlock;
2429             }
2430         }
2431 
2432         startBlock = _startBlock;
2433     }
2434 
2435     // Pay referral commission to the referrer who referred this user.
2436     function payReferralCommission(address _user, uint256 _pending) internal {
2437         if (address(wukongReferral) != address(0) && referralCommissionRate > 0) {
2438             address referrer = wukongReferral.getReferrer(_user);
2439             uint256 commissionAmount = _pending.mul(referralCommissionRate).div(10000);
2440 
2441             if (referrer != address(0) && commissionAmount > 0) {
2442                 wukong.mint(referrer, commissionAmount);
2443                 wukongReferral.recordReferralCommission(referrer, commissionAmount);
2444                 emit ReferralCommissionPaid(_user, referrer, commissionAmount);
2445             }
2446         }
2447     }
2448 
2449     // Update weekLockStartTime by the owner
2450     function setWeekLockStartTime(uint256 _weekLockStartTime) public onlyOwner {
2451         weekLockStartTime = _weekLockStartTime;
2452     }
2453 }