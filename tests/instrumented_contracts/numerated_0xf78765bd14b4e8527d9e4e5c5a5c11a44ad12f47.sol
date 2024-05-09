1 // SPDX-License-Identifier: MIT AND Apache-2.0
2 // File: @openzeppelin/contracts/math/SafeMath.sol
3 
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
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: contracts/6/interfaces/IRelayRecipient.sol
164 
165 pragma solidity 0.7.6;
166 
167 /**
168  * a contract must implement this interface in order to support relayed transaction.
169  * It is better to inherit the BaseRelayRecipient as its implementation.
170  */
171 abstract contract IRelayRecipient {
172 
173     /**
174      * return if the forwarder is trusted to forward relayed transactions to us.
175      * the forwarder is required to verify the sender's signature, and verify
176      * the call is not a replay.
177      */
178     function isTrustedForwarder(address forwarder) public virtual view returns(bool);
179 
180     /**
181      * return the sender of this call.
182      * if the call came through our trusted forwarder, then the real sender is appended as the last 20 bytes
183      * of the msg.data.
184      * otherwise, return `msg.sender`
185      * should be used in the contract anywhere instead of msg.sender
186      */
187     function _msgSender() internal virtual view returns (address payable);
188 
189     function versionRecipient() external virtual view returns (string memory);
190 }
191 
192 // File: contracts/6/libs/BaseRelayRecipient.sol
193 
194 pragma solidity 0.7.6;
195 
196 
197 /**
198  * A base contract to be inherited by any contract that want to receive relayed transactions
199  * A subclass must use "_msgSender()" instead of "msg.sender"
200  */
201 abstract contract BaseRelayRecipient is IRelayRecipient {
202 
203     /*
204      * Forwarder singleton we accept calls from
205      */
206     address public trustedForwarder;
207 
208     /*
209      * require a function to be called through GSN only
210      */
211     modifier trustedForwarderOnly() {
212         require(msg.sender == address(trustedForwarder), "Function can only be called through the trusted Forwarder");
213         _;
214     }
215 
216     function isTrustedForwarder(address forwarder) public override view returns(bool) {
217         return forwarder == trustedForwarder;
218     }
219 
220     /**
221      * return the sender of this call.
222      * if the call came through our trusted forwarder, return the original sender.
223      * otherwise, return `msg.sender`.
224      * should be used in the contract anywhere instead of msg.sender
225      */
226     function _msgSender() internal override virtual view returns (address payable ret) {
227         if (msg.data.length >= 24 && isTrustedForwarder(msg.sender)) {
228             // At this point we know that the sender is a trusted forwarder,
229             // so we trust that the last bytes of msg.data are the verified sender address.
230             // extract sender address from the end of msg.data
231             assembly {
232                 ret := shr(96,calldataload(sub(calldatasize(),20)))
233             }
234         } else {
235             return msg.sender;
236         }
237     }
238 }
239 
240 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
241 
242 
243 pragma solidity >=0.6.0 <0.8.0;
244 
245 /**
246  * @dev Interface of the ERC20 standard as defined in the EIP.
247  */
248 interface IERC20 {
249     /**
250      * @dev Returns the amount of tokens in existence.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns the amount of tokens owned by `account`.
256      */
257     function balanceOf(address account) external view returns (uint256);
258 
259     /**
260      * @dev Moves `amount` tokens from the caller's account to `recipient`.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transfer(address recipient, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Returns the remaining number of tokens that `spender` will be
270      * allowed to spend on behalf of `owner` through {transferFrom}. This is
271      * zero by default.
272      *
273      * This value changes when {approve} or {transferFrom} are called.
274      */
275     function allowance(address owner, address spender) external view returns (uint256);
276 
277     /**
278      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * IMPORTANT: Beware that changing an allowance with this method brings the risk
283      * that someone may use both the old and the new allowance by unfortunate
284      * transaction ordering. One possible solution to mitigate this race
285      * condition is to first reduce the spender's allowance to 0 and set the
286      * desired value afterwards:
287      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288      *
289      * Emits an {Approval} event.
290      */
291     function approve(address spender, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Moves `amount` tokens from `sender` to `recipient` using the
295      * allowance mechanism. `amount` is then deducted from the caller's
296      * allowance.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * Emits a {Transfer} event.
301      */
302     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Emitted when `value` tokens are moved from one account (`from`) to
306      * another (`to`).
307      *
308      * Note that `value` may be zero.
309      */
310     event Transfer(address indexed from, address indexed to, uint256 value);
311 
312     /**
313      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
314      * a call to {approve}. `value` is the new allowance.
315      */
316     event Approval(address indexed owner, address indexed spender, uint256 value);
317 }
318 
319 // File: @openzeppelin/contracts/utils/Address.sol
320 
321 
322 pragma solidity >=0.6.2 <0.8.0;
323 
324 /**
325  * @dev Collection of functions related to the address type
326  */
327 library Address {
328     /**
329      * @dev Returns true if `account` is a contract.
330      *
331      * [IMPORTANT]
332      * ====
333      * It is unsafe to assume that an address for which this function returns
334      * false is an externally-owned account (EOA) and not a contract.
335      *
336      * Among others, `isContract` will return false for the following
337      * types of addresses:
338      *
339      *  - an externally-owned account
340      *  - a contract in construction
341      *  - an address where a contract will be created
342      *  - an address where a contract lived, but was destroyed
343      * ====
344      */
345     function isContract(address account) internal view returns (bool) {
346         // This method relies on extcodesize, which returns 0 for contracts in
347         // construction, since the code is only stored at the end of the
348         // constructor execution.
349 
350         uint256 size;
351         // solhint-disable-next-line no-inline-assembly
352         assembly { size := extcodesize(account) }
353         return size > 0;
354     }
355 
356     /**
357      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
358      * `recipient`, forwarding all available gas and reverting on errors.
359      *
360      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
361      * of certain opcodes, possibly making contracts go over the 2300 gas limit
362      * imposed by `transfer`, making them unable to receive funds via
363      * `transfer`. {sendValue} removes this limitation.
364      *
365      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
366      *
367      * IMPORTANT: because control is transferred to `recipient`, care must be
368      * taken to not create reentrancy vulnerabilities. Consider using
369      * {ReentrancyGuard} or the
370      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
371      */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(address(this).balance >= amount, "Address: insufficient balance");
374 
375         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
376         (bool success, ) = recipient.call{ value: amount }("");
377         require(success, "Address: unable to send value, recipient may have reverted");
378     }
379 
380     /**
381      * @dev Performs a Solidity function call using a low level `call`. A
382      * plain`call` is an unsafe replacement for a function call: use this
383      * function instead.
384      *
385      * If `target` reverts with a revert reason, it is bubbled up by this
386      * function (like regular Solidity function calls).
387      *
388      * Returns the raw returned data. To convert to the expected return value,
389      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
390      *
391      * Requirements:
392      *
393      * - `target` must be a contract.
394      * - calling `target` with `data` must not revert.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
399       return functionCall(target, data, "Address: low-level call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
404      * `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, 0, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but also transferring `value` wei to `target`.
415      *
416      * Requirements:
417      *
418      * - the calling contract must have an ETH balance of at least `value`.
419      * - the called Solidity function must be `payable`.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         require(isContract(target), "Address: call to non-contract");
436 
437         // solhint-disable-next-line avoid-low-level-calls
438         (bool success, bytes memory returndata) = target.call{ value: value }(data);
439         return _verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
449         return functionStaticCall(target, data, "Address: low-level static call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
459         require(isContract(target), "Address: static call to non-contract");
460 
461         // solhint-disable-next-line avoid-low-level-calls
462         (bool success, bytes memory returndata) = target.staticcall(data);
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
488 
489 pragma solidity >=0.6.0 <0.8.0;
490 
491 
492 
493 
494 /**
495  * @title SafeERC20
496  * @dev Wrappers around ERC20 operations that throw on failure (when the token
497  * contract returns false). Tokens that return no value (and instead revert or
498  * throw on failure) are also supported, non-reverting calls are assumed to be
499  * successful.
500  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
501  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
502  */
503 library SafeERC20 {
504     using SafeMath for uint256;
505     using Address for address;
506 
507     function safeTransfer(IERC20 token, address to, uint256 value) internal {
508         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
509     }
510 
511     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
512         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
513     }
514 
515     /**
516      * @dev Deprecated. This function has issues similar to the ones found in
517      * {IERC20-approve}, and its usage is discouraged.
518      *
519      * Whenever possible, use {safeIncreaseAllowance} and
520      * {safeDecreaseAllowance} instead.
521      */
522     function safeApprove(IERC20 token, address spender, uint256 value) internal {
523         // safeApprove should only be called when setting an initial allowance,
524         // or when resetting it to zero. To increase and decrease it, use
525         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
526         // solhint-disable-next-line max-line-length
527         require((value == 0) || (token.allowance(address(this), spender) == 0),
528             "SafeERC20: approve from non-zero to non-zero allowance"
529         );
530         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
531     }
532 
533     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).add(value);
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     /**
544      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
545      * on the return value: the return value is optional (but if data is returned, it must not be false).
546      * @param token The token targeted by the call.
547      * @param data The call data (encoded using abi.encode or one of its variants).
548      */
549     function _callOptionalReturn(IERC20 token, bytes memory data) private {
550         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
551         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
552         // the target address contains contract code and also asserts for success in the low-level call.
553 
554         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
555         if (returndata.length > 0) { // Return data is optional
556             // solhint-disable-next-line max-line-length
557             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
558         }
559     }
560 }
561 
562 // File: contracts/6/insta-swaps/ReentrancyGuard.sol
563 
564 
565 pragma solidity 0.7.6;
566 
567 /**
568  * @dev Contract module that helps prevent reentrant calls to a function.
569  *
570  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
571  * available, which can be applied to functions to make sure there are no nested
572  * (reentrant) calls to them.
573  *
574  * Note that because there is a single `nonReentrant` guard, functions marked as
575  * `nonReentrant` may not call one another. This can be worked around by making
576  * those functions `private`, and then adding `external` `nonReentrant` entry
577  * points to them.
578  *
579  * TIP: If you would like to learn more about reentrancy and alternative ways
580  * to protect against it, check out our blog post
581  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
582  */
583 contract ReentrancyGuard {
584     // Booleans are more expensive than uint256 or any type that takes up a full
585     // word because each write operation emits an extra SLOAD to first read the
586     // slot's contents, replace the bits taken up by the boolean, and then write
587     // back. This is the compiler's defense against contract upgrades and
588     // pointer aliasing, and it cannot be disabled.
589 
590     // The values being non-zero value makes deployment a bit more expensive,
591     // but in exchange the refund on every call to nonReentrant will be lower in
592     // amount. Since refunds are capped to a percentage of the total
593     // transaction's gas, it is best to keep them low in cases like this one, to
594     // increase the likelihood of the full refund coming into effect.
595     uint256 private constant _NOT_ENTERED = 1;
596     uint256 private constant _ENTERED = 2;
597 
598     uint256 private _status;
599 
600     constructor() {
601         _status = _NOT_ENTERED;
602     }
603 
604     /**
605      * @dev Prevents a contract from calling itself, directly or indirectly.
606      * Calling a `nonReentrant` function from another `nonReentrant`
607      * function is not supported. It is possible to prevent this from happening
608      * by making the `nonReentrant` function external, and make it call a
609      * `private` function that does the actual work.
610      */
611     modifier nonReentrant() {
612         // On the first call to nonReentrant, _notEntered will be true
613         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
614 
615         // Any calls to nonReentrant after this point will fail
616         _status = _ENTERED;
617 
618         _;
619 
620         // By storing the original value once again, a refund is triggered (see
621         // https://eips.ethereum.org/EIPS/eip-2200)
622         _status = _NOT_ENTERED;
623     }
624 }
625 
626 // File: contracts/6/libs/Pausable.sol
627 
628 
629 pragma solidity >=0.6.0 <0.8.0;
630 
631 // import "../GSN/Context.sol";
632 
633 /**
634  * @dev Contract module which allows children to implement an emergency stop
635  * mechanism that can be triggered by an authorized account.
636  *
637  * This module is used through inheritance. It will make available the
638  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
639  * the functions of your contract. Note that they will not be pausable by
640  * simply including this module, only once the modifiers are put in place.
641  */
642 abstract contract Pausable {
643     /**
644      * @dev Emitted when the pause is triggered by `account`.
645      */
646     event Paused(address account);
647 
648     /**
649      * @dev Emitted when the pause is lifted by `account`.
650      */
651     event Unpaused(address account);
652 
653     event PauserChanged(
654         address indexed previousPauser,
655         address indexed newPauser
656     );
657 
658     bool private _paused;
659     address private _pauser;
660 
661     /**
662      * @dev The pausable constructor sets the original `pauser` of the contract to the sender
663      * account & Initializes the contract in unpaused state..
664      */
665     constructor(address pauser) {
666         require(pauser != address(0), "Pauser Address cannot be 0");
667         _pauser = pauser;
668         _paused = false;
669     }
670 
671     /**
672      * @dev Throws if called by any account other than the pauser.
673      */
674     modifier onlyPauser() {
675         require(
676             isPauser(),
677             "Only pauser is allowed to perform this operation"
678         );
679         _;
680     }
681 
682     /**
683      * @dev Modifier to make a function callable only when the contract is not paused.
684      *
685      * Requirements:
686      *
687      * - The contract must not be paused.
688      */
689     modifier whenNotPaused() {
690         require(!_paused, "Pausable: paused");
691         _;
692     }
693 
694     /**
695      * @dev Modifier to make a function callable only when the contract is paused.
696      *
697      * Requirements:
698      *
699      * - The contract must be paused.
700      */
701     modifier whenPaused() {
702         require(_paused, "Pausable: not paused");
703         _;
704     }
705 
706     /**
707      * @return the address of the owner.
708      */
709     function getPauser() public view returns (address) {
710         return _pauser;
711     }
712 
713     /**
714      * @return true if `msg.sender` is the owner of the contract.
715      */
716     function isPauser() public view returns (bool) {
717         return msg.sender == _pauser;
718     }
719 
720     /**
721      * @dev Returns true if the contract is paused, and false otherwise.
722      */
723     function isPaused() public view returns (bool) {
724         return _paused;
725     }
726 
727     /**
728      * @dev Allows the current pauser to transfer control of the contract to a newPauser.
729      * @param newPauser The address to transfer pauserShip to.
730      */
731     function changePauser(address newPauser) public onlyPauser {
732         _changePauser(newPauser);
733     }
734 
735     /**
736      * @dev Transfers control of the contract to a newPauser.
737      * @param newPauser The address to transfer ownership to.
738      */
739     function _changePauser(address newPauser) internal {
740         require(newPauser != address(0));
741         emit PauserChanged(_pauser, newPauser);
742         _pauser = newPauser;
743     }
744 
745     function renouncePauser() external virtual onlyPauser {
746         emit PauserChanged(_pauser, address(0));
747         _pauser = address(0);
748     }
749     
750     /**
751      * @dev Triggers stopped state.
752      *
753      * Requirements:
754      *
755      * - The contract must not be paused.
756      */
757     function pause() public onlyPauser whenNotPaused {
758         _paused = true;
759         emit Paused(_pauser);
760     }
761 
762     /**
763      * @dev Returns to normal state.
764      *
765      * Requirements:
766      *
767      * - The contract must be paused.
768      */
769     function unpause() public onlyPauser whenPaused {
770         _paused = false;
771         emit Unpaused(_pauser);
772     }
773 }
774 
775 // File: contracts/6/libs/Ownable.sol
776 
777 
778 pragma solidity 0.7.6;
779 
780 /**
781  * @title Ownable
782  * @dev The Ownable contract has an owner address, and provides basic authorization control
783  * functions, this simplifies the implementation of "user permissions".
784  */
785 abstract contract Ownable {
786     address private _owner;
787 
788     event OwnershipTransferred(
789         address indexed previousOwner,
790         address indexed newOwner
791     );
792 
793     /**
794      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
795      * account.
796      */
797     constructor(address owner) {
798         require(owner != address(0), "Owner Address cannot be 0");
799         _owner = owner;
800     }
801 
802     /**
803      * @dev Throws if called by any account other than the owner.
804      */
805     modifier onlyOwner() {
806         require(
807             isOwner(),
808             "Only contract owner is allowed to perform this operation"
809         );
810         _;
811     }
812 
813     /**
814      * @return the address of the owner.
815      */
816     function getOwner() public view returns (address) {
817         return _owner;
818     }
819 
820     /**
821      * @return true if `msg.sender` is the owner of the contract.
822      */
823     function isOwner() public view returns (bool) {
824         return msg.sender == _owner;
825     }
826 
827     /**
828      * @dev Allows the current owner to relinquish control of the contract.
829      * @notice Renouncing to ownership will leave the contract without an owner.
830      * It will not be possible to call the functions with the `onlyOwner`
831      * modifier anymore.
832      */
833     function renounceOwnership() external virtual onlyOwner {
834         emit OwnershipTransferred(_owner, address(0));
835         _owner = address(0);
836     }
837 
838     /**
839      * @dev Allows the current owner to transfer control of the contract to a newOwner.
840      * @param newOwner The address to transfer ownership to.
841      */
842     function transferOwnership(address newOwner) public onlyOwner {
843         _transferOwnership(newOwner);
844     }
845 
846     /**
847      * @dev Transfers control of the contract to a newOwner.
848      * @param newOwner The address to transfer ownership to.
849      */
850     function _transferOwnership(address newOwner) internal {
851         require(newOwner != address(0));
852         emit OwnershipTransferred(_owner, newOwner);
853         _owner = newOwner;
854     }
855 }
856 
857 // File: contracts/6/ExecutorManager.sol
858 
859 
860 pragma solidity 0.7.6;
861 
862 
863 contract ExecutorManager is Ownable {
864     address[] internal executors;
865     mapping(address => bool) internal executorStatus;
866 
867     event ExecutorAdded(address executor, address owner);
868     event ExecutorRemoved(address executor, address owner);
869 
870     // MODIFIERS
871     modifier onlyExecutor() {
872         require(
873             executorStatus[msg.sender],
874             "You are not allowed to perform this operation"
875         );
876         _;
877     }
878 
879     constructor(address owner) Ownable(owner) {
880         require( owner != address(0), "owner cannot be zero");
881     }
882 
883     function getExecutorStatus(address executor)
884         public
885         view
886         returns (bool status)
887     {
888         status = executorStatus[executor];
889     }
890 
891     function getAllExecutors() public view returns (address[] memory) {
892         return executors;
893     }
894 
895     //Register new Executors
896     function addExecutors(address[] calldata executorArray) external onlyOwner {
897         for (uint256 i = 0; i < executorArray.length; i++) {
898             addExecutor(executorArray[i]);
899         }
900     }
901 
902     // Register single executor
903     function addExecutor(address executorAddress) public onlyOwner {
904         require(executorAddress != address(0), "executor address can not be 0");
905         executors.push(executorAddress);
906         executorStatus[executorAddress] = true;
907         emit ExecutorAdded(executorAddress, msg.sender);
908     }
909 
910     //Remove registered Executors
911     function removeExecutors(address[] calldata executorArray) external onlyOwner {
912         for (uint256 i = 0; i < executorArray.length; i++) {
913             removeExecutor(executorArray[i]);
914         }
915     }
916 
917     // Remove Register single executor
918     function removeExecutor(address executorAddress) public onlyOwner {
919         require(executorAddress != address(0), "executor address can not be 0");
920         executorStatus[executorAddress] = false;
921         emit ExecutorRemoved(executorAddress, msg.sender);
922     }
923 }
924 
925 // File: contracts/6/interfaces/IERC20Permit.sol
926 
927 pragma solidity 0.7.6;
928 
929 
930 interface IERC20Detailed is IERC20 {
931   function name() external view returns(string memory);
932   function decimals() external view returns(uint256);
933 }
934 
935 interface IERC20Nonces is IERC20Detailed {
936   function nonces(address holder) external view returns(uint);
937 }
938 
939 interface IERC20Permit is IERC20Nonces {
940   function permit(address holder, address spender, uint256 nonce, uint256 expiry,
941                   bool allowed, uint8 v, bytes32 r, bytes32 s) external;
942 
943   function permit(address holder, address spender, uint256 value, uint256 expiry,
944                   uint8 v, bytes32 r, bytes32 s) external;
945 }
946 
947 // File: contracts/6/insta-swaps/LiquidityPoolManager.sol
948 
949 
950 pragma solidity 0.7.6;
951 pragma abicoder v2;
952 
953 
954 
955 
956 
957 
958 
959 
960 
961 contract LiquidityPoolManager is ReentrancyGuard, Ownable, BaseRelayRecipient, Pausable {
962     using SafeMath for uint256;
963 
964     address private constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
965     uint256 public baseGas;
966     
967     ExecutorManager private executorManager;
968     uint256 public adminFee;
969 
970     struct TokenInfo {
971         uint256 transferOverhead;
972         bool supportedToken;
973         uint256 minCap;
974         uint256 maxCap;
975         uint256 liquidity;
976         mapping(address => uint256) liquidityProvider;
977     }
978 
979      struct PermitRequest {
980         uint256 nonce;
981         uint256 expiry;
982         bool allowed; 
983         uint8 v;
984         bytes32 r; 
985         bytes32 s; 
986     }
987 
988     mapping ( address => TokenInfo ) public tokensInfo;
989     mapping ( bytes32 => bool ) public processedHash;
990     mapping ( address => uint256 ) public gasFeeAccumulatedByToken;
991     mapping ( address => uint256 ) public adminFeeAccumulatedByToken;
992 
993     event AssetSent(address indexed asset, uint256 indexed amount, uint256 indexed transferredAmount, address target, bytes depositHash);
994     event Received(address indexed from, uint256 indexed amount);
995     event Deposit(address indexed from, address indexed tokenAddress, address indexed receiver, uint256 toChainId, uint256 amount);
996     event LiquidityAdded(address indexed from, address indexed tokenAddress, address indexed receiver, uint256 amount);
997     event LiquidityRemoved(address indexed tokenAddress, uint256 indexed amount, address indexed sender);
998     event fundsWithdraw(address indexed tokenAddress, address indexed owner,  uint256 indexed amount);
999     event AdminFeeWithdraw(address indexed tokenAddress, address indexed owner,  uint256 indexed amount);
1000     event GasFeeWithdraw(address indexed tokenAddress, address indexed owner,  uint256 indexed amount);
1001     event AdminFeeChanged(uint256 indexed newAdminFee);
1002     event TrustedForwarderChanged(address indexed forwarderAddress);
1003     event EthReceived(address, uint);
1004 
1005     // MODIFIERS
1006     modifier onlyExecutor() {
1007         require(executorManager.getExecutorStatus(_msgSender()),
1008             "You are not allowed to perform this operation"
1009         );
1010         _;
1011     }
1012 
1013     modifier tokenChecks(address tokenAddress){
1014         require(tokenAddress != address(0), "Token address cannot be 0");
1015         require(tokensInfo[tokenAddress].supportedToken, "Token not supported");
1016 
1017         _;
1018     }
1019 
1020     constructor(address _executorManagerAddress, address owner, address pauser, address _trustedForwarder, uint256 _adminFee) Ownable(owner) Pausable(pauser) {
1021         require(_executorManagerAddress != address(0), "ExecutorManager Contract Address cannot be 0");
1022         require(_trustedForwarder != address(0), "TrustedForwarder Contract Address cannot be 0");
1023         require(_adminFee != 0, "AdminFee cannot be 0");
1024         executorManager = ExecutorManager(_executorManagerAddress);
1025         trustedForwarder = _trustedForwarder;
1026         adminFee = _adminFee;
1027         baseGas = 21000;
1028     }
1029 
1030     function renounceOwnership() external override onlyOwner {
1031         revert ("can't renounceOwnership here"); // not possible within this smart contract
1032     }
1033 
1034     function renouncePauser() external override onlyPauser {
1035         revert ("can't renouncePauser here"); // not possible within this smart contract
1036     }
1037 
1038     function getAdminFee() public view returns (uint256 ) {
1039         return adminFee;
1040     }
1041 
1042     function changeAdminFee(uint256 newAdminFee) external onlyOwner whenNotPaused {
1043         require(newAdminFee != 0, "Admin Fee cannot be 0");
1044         adminFee = newAdminFee;
1045         emit AdminFeeChanged(newAdminFee);
1046     }
1047 
1048     function versionRecipient() external override virtual view returns (string memory){
1049         return "1";
1050     }
1051 
1052     function setBaseGas(uint128 gas) external onlyOwner{
1053         baseGas = gas;
1054     }
1055 
1056     function getExecutorManager() public view returns (address){
1057         return address(executorManager);
1058     }
1059 
1060     function setExecutorManager(address _executorManagerAddress) external onlyOwner {
1061         require(_executorManagerAddress != address(0), "Executor Manager Address cannot be 0");
1062         executorManager = ExecutorManager(_executorManagerAddress);
1063     }
1064 
1065     function setTrustedForwarder( address forwarderAddress ) external onlyOwner {
1066         require(forwarderAddress != address(0), "Forwarder Address cannot be 0");
1067         trustedForwarder = forwarderAddress;
1068         emit TrustedForwarderChanged(forwarderAddress);
1069     }
1070 
1071     function setTokenTransferOverhead( address tokenAddress, uint256 gasOverhead ) external tokenChecks(tokenAddress) onlyOwner {
1072         tokensInfo[tokenAddress].transferOverhead = gasOverhead;
1073     }
1074 
1075     function addSupportedToken( address tokenAddress, uint256 minCapLimit, uint256 maxCapLimit ) external onlyOwner {
1076         require(tokenAddress != address(0), "Token address cannot be 0");  
1077         require(maxCapLimit > minCapLimit, "maxCapLimit cannot be smaller than minCapLimit");        
1078         tokensInfo[tokenAddress].supportedToken = true;
1079         tokensInfo[tokenAddress].minCap = minCapLimit;
1080         tokensInfo[tokenAddress].maxCap = maxCapLimit;
1081     }
1082 
1083     function removeSupportedToken( address tokenAddress ) external tokenChecks(tokenAddress) onlyOwner {
1084         tokensInfo[tokenAddress].supportedToken = false;
1085     }
1086 
1087     function updateTokenCap( address tokenAddress, uint256 minCapLimit, uint256 maxCapLimit ) external tokenChecks(tokenAddress) onlyOwner {
1088         require(maxCapLimit > minCapLimit, "maxCapLimit cannot be smaller than minCapLimit");                
1089         tokensInfo[tokenAddress].minCap = minCapLimit;        
1090         tokensInfo[tokenAddress].maxCap = maxCapLimit;
1091     }
1092 
1093     function addNativeLiquidity() external payable whenNotPaused {
1094         require(msg.value != 0, "Amount cannot be 0");
1095         address payable sender = _msgSender();
1096         tokensInfo[NATIVE].liquidityProvider[sender] = tokensInfo[NATIVE].liquidityProvider[sender].add(msg.value);
1097         tokensInfo[NATIVE].liquidity = tokensInfo[NATIVE].liquidity.add(msg.value);
1098 
1099         emit LiquidityAdded(sender, NATIVE, address(this), msg.value);
1100     }
1101 
1102     function removeNativeLiquidity(uint256 amount) external nonReentrant {
1103         require(amount != 0 , "Amount cannot be 0");
1104         address payable sender = _msgSender();
1105         require(tokensInfo[NATIVE].liquidityProvider[sender] >= amount, "Not enough balance");
1106         tokensInfo[NATIVE].liquidityProvider[sender] = tokensInfo[NATIVE].liquidityProvider[sender].sub(amount);
1107         tokensInfo[NATIVE].liquidity = tokensInfo[NATIVE].liquidity.sub(amount);
1108         
1109         bool success = sender.send(amount);
1110         require(success, "Native Transfer Failed");
1111 
1112         emit LiquidityRemoved( NATIVE, amount, sender);
1113     }
1114 
1115     function addTokenLiquidity( address tokenAddress, uint256 amount ) external tokenChecks(tokenAddress) whenNotPaused {
1116         require(amount != 0, "Amount cannot be 0");
1117         address payable sender = _msgSender();
1118         tokensInfo[tokenAddress].liquidityProvider[sender] = tokensInfo[tokenAddress].liquidityProvider[sender].add(amount);
1119         tokensInfo[tokenAddress].liquidity = tokensInfo[tokenAddress].liquidity.add(amount);
1120         
1121         SafeERC20.safeTransferFrom(IERC20(tokenAddress), sender, address(this), amount);
1122         emit LiquidityAdded(sender, tokenAddress, address(this), amount);
1123     }
1124 
1125     function removeTokenLiquidity( address tokenAddress, uint256 amount ) external tokenChecks(tokenAddress) {
1126         require(amount != 0, "Amount cannot be 0");
1127         address payable sender = _msgSender();
1128         require(tokensInfo[tokenAddress].liquidityProvider[sender] >= amount, "Not enough balance");
1129 
1130         tokensInfo[tokenAddress].liquidityProvider[sender] = tokensInfo[tokenAddress].liquidityProvider[sender].sub(amount);
1131         tokensInfo[tokenAddress].liquidity = tokensInfo[tokenAddress].liquidity.sub(amount);
1132 
1133         SafeERC20.safeTransfer(IERC20(tokenAddress), sender, amount);
1134         emit LiquidityRemoved( tokenAddress, amount, sender);
1135 
1136     }
1137 
1138     function getLiquidity(address liquidityProviderAddress, address tokenAddress) public view returns (uint256 ) {
1139         return tokensInfo[tokenAddress].liquidityProvider[liquidityProviderAddress];
1140     }
1141 
1142     function depositErc20( address tokenAddress, address receiver, uint256 amount, uint256 toChainId ) public tokenChecks(tokenAddress) whenNotPaused {
1143         require(tokensInfo[tokenAddress].minCap <= amount && tokensInfo[tokenAddress].maxCap >= amount, "Deposit amount should be within allowed Cap limits");
1144         require(receiver != address(0), "Receiver address cannot be 0");
1145         require(amount != 0, "Amount cannot be 0");
1146 
1147         address payable sender = _msgSender();
1148 
1149         SafeERC20.safeTransferFrom(IERC20(tokenAddress), sender, address(this),amount);
1150         emit Deposit(sender, tokenAddress, receiver, toChainId, amount);
1151     }
1152 
1153     /** 
1154      * DAI permit and Deposit.
1155      */
1156     function permitAndDepositErc20(
1157         address tokenAddress,
1158         address receiver,
1159         uint256 amount,
1160         uint256 toChainId,
1161         PermitRequest calldata permitOptions
1162         )
1163         external {
1164             IERC20Permit(tokenAddress).permit(_msgSender(), address(this), permitOptions.nonce, permitOptions.expiry, permitOptions.allowed, permitOptions.v, permitOptions.r, permitOptions.s);
1165             depositErc20(tokenAddress, receiver, amount, toChainId);
1166     }
1167 
1168     /** 
1169      * EIP2612 and Deposit.
1170      */
1171     function permitEIP2612AndDepositErc20(
1172         address tokenAddress,
1173         address receiver,
1174         uint256 amount,
1175         uint256 toChainId,
1176         PermitRequest calldata permitOptions
1177         )
1178         external {
1179             IERC20Permit(tokenAddress).permit(_msgSender(), address(this), amount, permitOptions.expiry, permitOptions.v, permitOptions.r, permitOptions.s);
1180             depositErc20(tokenAddress, receiver, amount, toChainId);            
1181     }
1182 
1183     function depositNative( address receiver, uint256 toChainId ) external whenNotPaused payable {
1184         require(tokensInfo[NATIVE].minCap <= msg.value && tokensInfo[NATIVE].maxCap >= msg.value, "Deposit amount should be within allowed Cap limit");
1185         require(receiver != address(0), "Receiver address cannot be 0");
1186         require(msg.value != 0, "Amount cannot be 0");
1187 
1188         emit Deposit(_msgSender(), NATIVE, receiver, toChainId, msg.value);
1189     }
1190 
1191     function sendFundsToUser( address tokenAddress, uint256 amount, address payable receiver, bytes memory depositHash, uint256 tokenGasPrice ) external nonReentrant onlyExecutor tokenChecks(tokenAddress) whenNotPaused {
1192         uint256 initialGas = gasleft();
1193         require(tokensInfo[tokenAddress].minCap <= amount && tokensInfo[tokenAddress].maxCap >= amount, "Withdraw amount should be within allowed Cap limits");
1194         require(receiver != address(0), "Bad receiver address");
1195 
1196         (bytes32 hashSendTransaction, bool status) = checkHashStatus(tokenAddress, amount, receiver, depositHash);
1197 
1198         require(!status, "Already Processed");
1199         processedHash[hashSendTransaction] = true;
1200 
1201         uint256 calculateAdminFee = amount.mul(adminFee).div(10000);
1202 
1203         adminFeeAccumulatedByToken[tokenAddress] = adminFeeAccumulatedByToken[tokenAddress].add(calculateAdminFee); 
1204 
1205         uint256 totalGasUsed = (initialGas.sub(gasleft()));
1206         totalGasUsed = totalGasUsed.add(tokensInfo[tokenAddress].transferOverhead);
1207         totalGasUsed = totalGasUsed.add(baseGas);
1208 
1209         gasFeeAccumulatedByToken[tokenAddress] = gasFeeAccumulatedByToken[tokenAddress].add(totalGasUsed.mul(tokenGasPrice));
1210         uint256 amountToTransfer = amount.sub(calculateAdminFee.add(totalGasUsed.mul(tokenGasPrice)));
1211 
1212         if (tokenAddress == NATIVE) {
1213             require(address(this).balance >= amountToTransfer, "Not Enough Balance");
1214             bool success = receiver.send(amountToTransfer);
1215             require(success, "Native Transfer Failed");
1216         } else {
1217             require(IERC20(tokenAddress).balanceOf(address(this)) >= amountToTransfer, "Not Enough Balance");
1218             SafeERC20.safeTransfer(IERC20(tokenAddress), receiver, amountToTransfer);
1219         }
1220 
1221         emit AssetSent(tokenAddress, amount, amountToTransfer, receiver, depositHash);
1222     }
1223 
1224     function checkHashStatus(address tokenAddress, uint256 amount, address payable receiver, bytes memory depositHash) public view returns(bytes32 hashSendTransaction, bool status){
1225         hashSendTransaction = keccak256(
1226             abi.encode(
1227                 tokenAddress,
1228                 amount,
1229                 receiver,
1230                 keccak256(depositHash)
1231             )
1232         );
1233 
1234         status = processedHash[hashSendTransaction];
1235     }
1236 
1237     function withdrawErc20(address tokenAddress) external onlyOwner whenNotPaused {
1238         uint256 profitEarned = (IERC20(tokenAddress).balanceOf(address(this)))
1239                                 .sub(tokensInfo[tokenAddress].liquidity)
1240                                 .sub(adminFeeAccumulatedByToken[tokenAddress])
1241                                 .sub(gasFeeAccumulatedByToken[tokenAddress]);
1242         require(profitEarned != 0, "Profit earned is 0");
1243         address payable sender = _msgSender();
1244 
1245         SafeERC20.safeTransfer(IERC20(tokenAddress), sender, profitEarned);
1246 
1247         emit fundsWithdraw(tokenAddress, sender,  profitEarned);
1248     }
1249 
1250     function withdrawErc20AdminFee(address tokenAddress, address receiver) external onlyOwner whenNotPaused {
1251         require(tokenAddress != NATIVE, "Use withdrawNativeAdminFee() for native token");
1252         uint256 adminFeeAccumulated = adminFeeAccumulatedByToken[tokenAddress];
1253         require(adminFeeAccumulated != 0, "Admin Fee earned is 0");
1254 
1255         adminFeeAccumulatedByToken[tokenAddress] = 0;
1256 
1257         SafeERC20.safeTransfer(IERC20(tokenAddress), receiver, adminFeeAccumulated);
1258         emit AdminFeeWithdraw(tokenAddress, receiver, adminFeeAccumulated);
1259     }
1260 
1261     function withdrawErc20GasFee(address tokenAddress, address receiver) external onlyOwner whenNotPaused {
1262         require(tokenAddress != NATIVE, "Use withdrawNativeGasFee() for native token");
1263         uint256 gasFeeAccumulated = gasFeeAccumulatedByToken[tokenAddress];
1264         require(gasFeeAccumulated != 0, "Gas Fee earned is 0");
1265 
1266         gasFeeAccumulatedByToken[tokenAddress] = 0;
1267 
1268         SafeERC20.safeTransfer(IERC20(tokenAddress), receiver, gasFeeAccumulated);
1269         emit GasFeeWithdraw(tokenAddress, receiver, gasFeeAccumulated);
1270     }
1271 
1272     function withdrawNative() external onlyOwner whenNotPaused {
1273         uint256 profitEarned = (address(this).balance)
1274                                 .sub(tokensInfo[NATIVE].liquidity)
1275                                 .sub(adminFeeAccumulatedByToken[NATIVE])
1276                                 .sub(gasFeeAccumulatedByToken[NATIVE]);
1277         
1278         require(profitEarned != 0, "Profit earned is 0");
1279 
1280         address payable sender = _msgSender();
1281         bool success = sender.send(profitEarned);
1282         require(success, "Native Transfer Failed");
1283         
1284         emit fundsWithdraw(address(this), sender, profitEarned);
1285     }
1286 
1287     function withdrawNativeAdminFee(address payable receiver) external onlyOwner whenNotPaused {
1288         uint256 adminFeeAccumulated = adminFeeAccumulatedByToken[NATIVE];
1289         require(adminFeeAccumulated != 0, "Admin Fee earned is 0");
1290         adminFeeAccumulatedByToken[NATIVE] = 0;
1291         bool success = receiver.send(adminFeeAccumulated);
1292         require(success, "Native Transfer Failed");
1293         
1294         emit AdminFeeWithdraw(address(this), receiver, adminFeeAccumulated);
1295     }
1296 
1297     function withdrawNativeGasFee(address payable receiver) external onlyOwner whenNotPaused {
1298         uint256 gasFeeAccumulated = gasFeeAccumulatedByToken[NATIVE];
1299         require(gasFeeAccumulated != 0, "Gas Fee earned is 0");
1300         gasFeeAccumulatedByToken[NATIVE] = 0;
1301         bool success = receiver.send(gasFeeAccumulated);
1302         require(success, "Native Transfer Failed");
1303         
1304         emit GasFeeWithdraw(address(this), receiver, gasFeeAccumulated);
1305     }
1306 
1307     receive() external payable {
1308         emit EthReceived(_msgSender(), msg.value);
1309     }
1310 }