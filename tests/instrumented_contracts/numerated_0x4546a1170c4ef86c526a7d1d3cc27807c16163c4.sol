1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-20
3 */
4 
5 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Contract module that helps prevent reentrant calls to a function.
14  *
15  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
16  * available, which can be applied to functions to make sure there are no nested
17  * (reentrant) calls to them.
18  *
19  * Note that because there is a single `nonReentrant` guard, functions marked as
20  * `nonReentrant` may not call one another. This can be worked around by making
21  * those functions `private`, and then adding `external` `nonReentrant` entry
22  * points to them.
23  *
24  * TIP: If you would like to learn more about reentrancy and alternative ways
25  * to protect against it, check out our blog post
26  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
27  */
28 abstract contract ReentrancyGuard {
29     // Booleans are more expensive than uint256 or any type that takes up a full
30     // word because each write operation emits an extra SLOAD to first read the
31     // slot's contents, replace the bits taken up by the boolean, and then write
32     // back. This is the compiler's defense against contract upgrades and
33     // pointer aliasing, and it cannot be disabled.
34 
35     // The values being non-zero value makes deployment a bit more expensive,
36     // but in exchange the refund on every call to nonReentrant will be lower in
37     // amount. Since refunds are capped to a percentage of the total
38     // transaction's gas, it is best to keep them low in cases like this one, to
39     // increase the likelihood of the full refund coming into effect.
40     uint256 private constant _NOT_ENTERED = 1;
41     uint256 private constant _ENTERED = 2;
42 
43     uint256 private _status;
44 
45     constructor() {
46         _status = _NOT_ENTERED;
47     }
48 
49     /**
50      * @dev Prevents a contract from calling itself, directly or indirectly.
51      * Calling a `nonReentrant` function from another `nonReentrant`
52      * function is not supported. It is possible to prevent this from happening
53      * by making the `nonReentrant` function external, and making it call a
54      * `private` function that does the actual work.
55      */
56     modifier nonReentrant() {
57         _nonReentrantBefore();
58         _;
59         _nonReentrantAfter();
60     }
61 
62     function _nonReentrantBefore() private {
63         // On the first call to nonReentrant, _status will be _NOT_ENTERED
64         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
65 
66         // Any calls to nonReentrant after this point will fail
67         _status = _ENTERED;
68     }
69 
70     function _nonReentrantAfter() private {
71         // By storing the original value once again, a refund is triggered (see
72         // https://eips.ethereum.org/EIPS/eip-2200)
73         _status = _NOT_ENTERED;
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Address.sol
78 
79 
80 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
81 
82 pragma solidity ^0.8.1;
83 
84 /**
85  * @dev Collection of functions related to the address type
86  */
87 library Address {
88     /**
89      * @dev Returns true if `account` is a contract.
90      *
91      * [IMPORTANT]
92      * ====
93      * It is unsafe to assume that an address for which this function returns
94      * false is an externally-owned account (EOA) and not a contract.
95      *
96      * Among others, `isContract` will return false for the following
97      * types of addresses:
98      *
99      *  - an externally-owned account
100      *  - a contract in construction
101      *  - an address where a contract will be created
102      *  - an address where a contract lived, but was destroyed
103      * ====
104      *
105      * [IMPORTANT]
106      * ====
107      * You shouldn't rely on `isContract` to protect against flash loan attacks!
108      *
109      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
110      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
111      * constructor.
112      * ====
113      */
114     function isContract(address account) internal view returns (bool) {
115         // This method relies on extcodesize/address.code.length, which returns 0
116         // for contracts in construction, since the code is only stored at the end
117         // of the constructor execution.
118 
119         return account.code.length > 0;
120     }
121 
122     /**
123      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
124      * `recipient`, forwarding all available gas and reverting on errors.
125      *
126      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
127      * of certain opcodes, possibly making contracts go over the 2300 gas limit
128      * imposed by `transfer`, making them unable to receive funds via
129      * `transfer`. {sendValue} removes this limitation.
130      *
131      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
132      *
133      * IMPORTANT: because control is transferred to `recipient`, care must be
134      * taken to not create reentrancy vulnerabilities. Consider using
135      * {ReentrancyGuard} or the
136      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
137      */
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         (bool success, ) = recipient.call{value: amount}("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145     /**
146      * @dev Performs a Solidity function call using a low level `call`. A
147      * plain `call` is an unsafe replacement for a function call: use this
148      * function instead.
149      *
150      * If `target` reverts with a revert reason, it is bubbled up by this
151      * function (like regular Solidity function calls).
152      *
153      * Returns the raw returned data. To convert to the expected return value,
154      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
155      *
156      * Requirements:
157      *
158      * - `target` must be a contract.
159      * - calling `target` with `data` must not revert.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but also transferring `value` wei to `target`.
184      *
185      * Requirements:
186      *
187      * - the calling contract must have an ETH balance of at least `value`.
188      * - the called Solidity function must be `payable`.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
202      * with `errorMessage` as a fallback revert reason when `target` reverts.
203      *
204      * _Available since v3.1._
205      */
206     function functionCallWithValue(
207         address target,
208         bytes memory data,
209         uint256 value,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         require(address(this).balance >= value, "Address: insufficient balance for call");
213         (bool success, bytes memory returndata) = target.call{value: value}(data);
214         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
224         return functionStaticCall(target, data, "Address: low-level static call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal view returns (bytes memory) {
238         (bool success, bytes memory returndata) = target.staticcall(data);
239         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
249         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
269      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
270      *
271      * _Available since v4.8._
272      */
273     function verifyCallResultFromTarget(
274         address target,
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) internal view returns (bytes memory) {
279         if (success) {
280             if (returndata.length == 0) {
281                 // only check isContract if the call was successful and the return data is empty
282                 // otherwise we already know that it was a contract
283                 require(isContract(target), "Address: call to non-contract");
284             }
285             return returndata;
286         } else {
287             _revert(returndata, errorMessage);
288         }
289     }
290 
291     /**
292      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
293      * revert reason or using the provided one.
294      *
295      * _Available since v4.3._
296      */
297     function verifyCallResult(
298         bool success,
299         bytes memory returndata,
300         string memory errorMessage
301     ) internal pure returns (bytes memory) {
302         if (success) {
303             return returndata;
304         } else {
305             _revert(returndata, errorMessage);
306         }
307     }
308 
309     function _revert(bytes memory returndata, string memory errorMessage) private pure {
310         // Look for revert reason and bubble it up if present
311         if (returndata.length > 0) {
312             // The easiest way to bubble the revert reason is using memory via assembly
313             /// @solidity memory-safe-assembly
314             assembly {
315                 let returndata_size := mload(returndata)
316                 revert(add(32, returndata), returndata_size)
317             }
318         } else {
319             revert(errorMessage);
320         }
321     }
322 }
323 
324 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
333  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
334  *
335  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
336  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
337  * need to send a transaction, and thus is not required to hold Ether at all.
338  */
339 interface IERC20Permit {
340     /**
341      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
342      * given ``owner``'s signed approval.
343      *
344      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
345      * ordering also apply here.
346      *
347      * Emits an {Approval} event.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      * - `deadline` must be a timestamp in the future.
353      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
354      * over the EIP712-formatted function arguments.
355      * - the signature must use ``owner``'s current nonce (see {nonces}).
356      *
357      * For more information on the signature format, see the
358      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
359      * section].
360      */
361     function permit(
362         address owner,
363         address spender,
364         uint256 value,
365         uint256 deadline,
366         uint8 v,
367         bytes32 r,
368         bytes32 s
369     ) external;
370 
371     /**
372      * @dev Returns the current nonce for `owner`. This value must be
373      * included whenever a signature is generated for {permit}.
374      *
375      * Every successful call to {permit} increases ``owner``'s nonce by one. This
376      * prevents a signature from being used multiple times.
377      */
378     function nonces(address owner) external view returns (uint256);
379 
380     /**
381      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
382      */
383     // solhint-disable-next-line func-name-mixedcase
384     function DOMAIN_SEPARATOR() external view returns (bytes32);
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Interface of the ERC20 standard as defined in the EIP.
396  */
397 interface IERC20 {
398     /**
399      * @dev Emitted when `value` tokens are moved from one account (`from`) to
400      * another (`to`).
401      *
402      * Note that `value` may be zero.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 value);
405 
406     /**
407      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
408      * a call to {approve}. `value` is the new allowance.
409      */
410     event Approval(address indexed owner, address indexed spender, uint256 value);
411 
412     /**
413      * @dev Returns the amount of tokens in existence.
414      */
415     function totalSupply() external view returns (uint256);
416 
417     /**
418      * @dev Returns the amount of tokens owned by `account`.
419      */
420     function balanceOf(address account) external view returns (uint256);
421 
422     /**
423      * @dev Moves `amount` tokens from the caller's account to `to`.
424      *
425      * Returns a boolean value indicating whether the operation succeeded.
426      *
427      * Emits a {Transfer} event.
428      */
429     function transfer(address to, uint256 amount) external returns (bool);
430 
431     /**
432      * @dev Returns the remaining number of tokens that `spender` will be
433      * allowed to spend on behalf of `owner` through {transferFrom}. This is
434      * zero by default.
435      *
436      * This value changes when {approve} or {transferFrom} are called.
437      */
438     function allowance(address owner, address spender) external view returns (uint256);
439 
440     /**
441      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
442      *
443      * Returns a boolean value indicating whether the operation succeeded.
444      *
445      * IMPORTANT: Beware that changing an allowance with this method brings the risk
446      * that someone may use both the old and the new allowance by unfortunate
447      * transaction ordering. One possible solution to mitigate this race
448      * condition is to first reduce the spender's allowance to 0 and set the
449      * desired value afterwards:
450      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
451      *
452      * Emits an {Approval} event.
453      */
454     function approve(address spender, uint256 amount) external returns (bool);
455 
456     /**
457      * @dev Moves `amount` tokens from `from` to `to` using the
458      * allowance mechanism. `amount` is then deducted from the caller's
459      * allowance.
460      *
461      * Returns a boolean value indicating whether the operation succeeded.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transferFrom(
466         address from,
467         address to,
468         uint256 amount
469     ) external returns (bool);
470 }
471 
472 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
473 
474 
475 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 
480 
481 
482 /**
483  * @title SafeERC20
484  * @dev Wrappers around ERC20 operations that throw on failure (when the token
485  * contract returns false). Tokens that return no value (and instead revert or
486  * throw on failure) are also supported, non-reverting calls are assumed to be
487  * successful.
488  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
489  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
490  */
491 library SafeERC20 {
492     using Address for address;
493 
494     function safeTransfer(
495         IERC20 token,
496         address to,
497         uint256 value
498     ) internal {
499         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
500     }
501 
502     function safeTransferFrom(
503         IERC20 token,
504         address from,
505         address to,
506         uint256 value
507     ) internal {
508         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
509     }
510 
511     /**
512      * @dev Deprecated. This function has issues similar to the ones found in
513      * {IERC20-approve}, and its usage is discouraged.
514      *
515      * Whenever possible, use {safeIncreaseAllowance} and
516      * {safeDecreaseAllowance} instead.
517      */
518     function safeApprove(
519         IERC20 token,
520         address spender,
521         uint256 value
522     ) internal {
523         // safeApprove should only be called when setting an initial allowance,
524         // or when resetting it to zero. To increase and decrease it, use
525         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
526         require(
527             (value == 0) || (token.allowance(address(this), spender) == 0),
528             "SafeERC20: approve from non-zero to non-zero allowance"
529         );
530         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
531     }
532 
533     function safeIncreaseAllowance(
534         IERC20 token,
535         address spender,
536         uint256 value
537     ) internal {
538         uint256 newAllowance = token.allowance(address(this), spender) + value;
539         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
540     }
541 
542     function safeDecreaseAllowance(
543         IERC20 token,
544         address spender,
545         uint256 value
546     ) internal {
547         unchecked {
548             uint256 oldAllowance = token.allowance(address(this), spender);
549             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
550             uint256 newAllowance = oldAllowance - value;
551             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
552         }
553     }
554 
555     function safePermit(
556         IERC20Permit token,
557         address owner,
558         address spender,
559         uint256 value,
560         uint256 deadline,
561         uint8 v,
562         bytes32 r,
563         bytes32 s
564     ) internal {
565         uint256 nonceBefore = token.nonces(owner);
566         token.permit(owner, spender, value, deadline, v, r, s);
567         uint256 nonceAfter = token.nonces(owner);
568         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
569     }
570 
571     /**
572      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
573      * on the return value: the return value is optional (but if data is returned, it must not be false).
574      * @param token The token targeted by the call.
575      * @param data The call data (encoded using abi.encode or one of its variants).
576      */
577     function _callOptionalReturn(IERC20 token, bytes memory data) private {
578         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
579         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
580         // the target address contains contract code and also asserts for success in the low-level call.
581 
582         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
583         if (returndata.length > 0) {
584             // Return data is optional
585             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
586         }
587     }
588 }
589 
590 // File: @openzeppelin/contracts/utils/Context.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Provides information about the current execution context, including the
599  * sender of the transaction and its data. While these are generally available
600  * via msg.sender and msg.data, they should not be accessed in such a direct
601  * manner, since when dealing with meta-transactions the account sending and
602  * paying for execution may not be the actual sender (as far as an application
603  * is concerned).
604  *
605  * This contract is only required for intermediate, library-like contracts.
606  */
607 abstract contract Context {
608     function _msgSender() internal view virtual returns (address) {
609         return msg.sender;
610     }
611 
612     function _msgData() internal view virtual returns (bytes calldata) {
613         return msg.data;
614     }
615 }
616 
617 // File: @openzeppelin/contracts/access/Ownable.sol
618 
619 
620 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 
625 /**
626  * @dev Contract module which provides a basic access control mechanism, where
627  * there is an account (an owner) that can be granted exclusive access to
628  * specific functions.
629  *
630  * By default, the owner account will be the one that deploys the contract. This
631  * can later be changed with {transferOwnership}.
632  *
633  * This module is used through inheritance. It will make available the modifier
634  * `onlyOwner`, which can be applied to your functions to restrict their use to
635  * the owner.
636  */
637 abstract contract Ownable is Context {
638     address private _owner;
639 
640     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
641 
642     /**
643      * @dev Initializes the contract setting the deployer as the initial owner.
644      */
645     constructor() {
646         _transferOwnership(_msgSender());
647     }
648 
649     /**
650      * @dev Throws if called by any account other than the owner.
651      */
652     modifier onlyOwner() {
653         _checkOwner();
654         _;
655     }
656 
657     /**
658      * @dev Returns the address of the current owner.
659      */
660     function owner() public view virtual returns (address) {
661         return _owner;
662     }
663 
664     /**
665      * @dev Throws if the sender is not the owner.
666      */
667     function _checkOwner() internal view virtual {
668         require(owner() == _msgSender(), "Ownable: caller is not the owner");
669     }
670 
671     /**
672      * @dev Leaves the contract without owner. It will not be possible to call
673      * `onlyOwner` functions anymore. Can only be called by the current owner.
674      *
675      * NOTE: Renouncing ownership will leave the contract without an owner,
676      * thereby removing any functionality that is only available to the owner.
677      */
678     function renounceOwnership() public virtual onlyOwner {
679         _transferOwnership(address(0));
680     }
681 
682     /**
683      * @dev Transfers ownership of the contract to a new account (`newOwner`).
684      * Can only be called by the current owner.
685      */
686     function transferOwnership(address newOwner) public virtual onlyOwner {
687         require(newOwner != address(0), "Ownable: new owner is the zero address");
688         _transferOwnership(newOwner);
689     }
690 
691     /**
692      * @dev Transfers ownership of the contract to a new account (`newOwner`).
693      * Internal function without access restriction.
694      */
695     function _transferOwnership(address newOwner) internal virtual {
696         address oldOwner = _owner;
697         _owner = newOwner;
698         emit OwnershipTransferred(oldOwner, newOwner);
699     }
700 }
701 
702 // File: contracts/STAKING/IStaking.sol
703 
704 
705 pragma solidity =0.8.10;
706 
707 /// @author RetreebInc
708 /// @title Interface Staking Platform with fixed APY and lockup
709 interface IStaking {
710     /**
711      * @notice function that start the staking
712      * @dev set `startPeriod` to the current current `block.timestamp`
713      * set `lockupPeriod` which is `block.timestamp` + `lockupDuration`
714      * and `endPeriod` which is `startPeriod` + `stakingDuration`
715      */
716     function startStaking() external;
717 
718     /**
719      * @notice function that allows a user to deposit tokens
720      * @dev user must first approve the amount to deposit before calling this function,
721      * cannot exceed the `maxAmountStaked`
722      * @param amount, the amount to be deposited
723      * @dev `endPeriod` to equal 0 (Staking didn't started yet),
724      * or `endPeriod` more than current `block.timestamp` (staking not finished yet)
725      * @dev `totalStaked + amount` must be less than `stakingMax`
726      * @dev that the amount deposited should greater than 0
727      */
728     function deposit(uint amount) external;
729 
730     /**
731      * @notice function that allows a user to withdraw its initial deposit
732      * @dev must be called only when `block.timestamp` >= `endPeriod`
733      * @dev `block.timestamp` higher than `lockupPeriod` (lockupPeriod finished)
734      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
735      * if rewards to claim
736      */
737     function withdrawAll() external;
738 
739     /**
740      * @notice function that allows a user to withdraw its initial deposit
741      * @param amount, amount to withdraw
742      * @dev `block.timestamp` must be higher than `lockupPeriod` (lockupPeriod finished)
743      * @dev `amount` must be higher than `0`
744      * @dev `amount` must be lower or equal to the amount staked
745      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
746      * if rewards to claim
747      */
748     function withdraw(uint amount) external;
749 
750     /**
751      * @notice function that returns the amount of total Staked tokens
752      * for a specific user
753      * @param stakeHolder, address of the user to check
754      * @return uint amount of the total deposited Tokens by the caller
755      */
756     function amountStaked(address stakeHolder) external view returns (uint);
757 
758     /**
759      * @notice function that returns the amount of total Staked tokens
760      * on the smart contract
761      * @return uint amount of the total deposited Tokens
762      */
763     function totalDeposited() external view returns (uint);
764 
765     /**
766      * @notice function that returns the amount of pending rewards
767      * that can be claimed by the user
768      * @param stakeHolder, address of the user to be checked
769      * @return uint amount of claimable rewards
770      */
771     function rewardOf(address stakeHolder) external view returns (uint);
772 
773     /**
774      * @notice function that claims pending rewards
775      * @dev transfer the pending rewards to the `msg.sender`
776      */
777     function claimRewards() external;
778 
779     /**
780      * @dev Emitted when `amount` tokens are deposited into
781      * staking platform
782      */
783     event Deposit(address indexed owner, uint amount);
784 
785     /**
786      * @dev Emitted when user withdraw deposited `amount`
787      */
788     event Withdraw(address indexed owner, uint amount);
789 
790     /**
791      * @dev Emitted when `stakeHolder` claim rewards
792      */
793     event Claim(address indexed stakeHolder, uint amount);
794 
795     /**
796      * @dev Emitted when staking has started
797      */
798     event StartStaking(uint startPeriod, uint lockupPeriod, uint endingPeriod);
799 }
800 // File: contracts/STAKING/Staking.sol
801 
802 
803 pragma solidity =0.8.10;
804 
805 
806 
807 
808 
809 
810 /// @title Staking Platform with fixed APY and lockup
811 contract Staking is IStaking, Ownable, ReentrancyGuard {
812     using SafeERC20 for IERC20;
813 
814     IERC20 public immutable token;
815 
816     uint8 public immutable fixedAPY;
817 
818     uint public immutable stakingDuration;
819     uint public immutable lockupDuration;
820     uint public immutable stakingMax;
821 
822     uint public startPeriod;
823     uint public lockupPeriod;
824     uint public endPeriod;
825 
826     uint private _totalStaked;
827     uint internal _precision = 1E6;
828 
829     mapping(address => uint) public staked;
830     mapping(address => uint) private _rewardsToClaim;
831     mapping(address => uint) private _userStartTime;
832 
833     /**
834      * @notice constructor contains all the parameters of the staking platform
835      * @dev all parameters are immutable
836      */
837     constructor(
838         address _token,
839         uint8 _fixedAPY,
840         uint _durationInDays,
841         uint _lockDurationInDays,
842         uint _maxAmountStaked
843     ) {
844         stakingDuration = _durationInDays * 1 days;
845         lockupDuration = _lockDurationInDays * 1 days;
846         token = IERC20(_token);
847         fixedAPY = _fixedAPY;
848         stakingMax = _maxAmountStaked;
849     }
850 
851     /**
852      * @notice function that start the staking
853      * @dev set `startPeriod` to the current current `block.timestamp`
854      * set `lockupPeriod` which is `block.timestamp` + `lockupDuration`
855      * and `endPeriod` which is `startPeriod` + `stakingDuration`
856      */
857     function startStaking() external override onlyOwner {
858         require(startPeriod == 0, "Staking has already started");
859         startPeriod = block.timestamp;
860         lockupPeriod = block.timestamp + lockupDuration;
861         endPeriod = block.timestamp + stakingDuration;
862         emit StartStaking(startPeriod, lockupDuration, endPeriod);
863     }
864 
865     /**
866      * @notice function that allows a user to deposit tokens
867      * @dev user must first approve the amount to deposit before calling this function,
868      * cannot exceed the `maxAmountStaked`
869      * @param amount, the amount to be deposited
870      * @dev `endPeriod` to equal 0 (Staking didn't started yet),
871      * or `endPeriod` more than current `block.timestamp` (staking not finished yet)
872      * @dev `totalStaked + amount` must be less than `stakingMax`
873      * @dev that the amount deposited should greater than 0
874      */
875     function deposit(uint amount) external override {
876         require(
877             endPeriod == 0 || endPeriod > block.timestamp,
878             "Staking period ended"
879         );
880         require(
881             _totalStaked + amount <= stakingMax,
882             "Amount staked exceeds MaxStake"
883         );
884         require(amount > 0, "Amount must be greater than 0");
885 
886         if (_userStartTime[_msgSender()] == 0) {
887             _userStartTime[_msgSender()] = block.timestamp;
888         }
889 
890         _updateRewards();
891 
892         staked[_msgSender()] += amount;
893         _totalStaked += amount;
894         token.safeTransferFrom(_msgSender(), address(this), amount);
895         emit Deposit(_msgSender(), amount);
896     }
897 
898     /**
899      * @notice function that allows a user to withdraw its initial deposit
900      * @param amount, amount to withdraw
901      * @dev `amount` must be higher than `0`
902      * @dev `amount` must be lower or equal to the amount staked
903      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
904      * if rewards to claim
905      */
906     function withdraw(uint amount) external nonReentrant override {
907 
908         require(amount > 0, "Amount must be greater than 0");
909         require(
910             amount <= staked[_msgSender()],
911             "Amount higher than stakedAmount"
912         );
913 
914         _updateRewards();
915         if (_rewardsToClaim[_msgSender()] > 0) {
916             _claimRewards();
917         }
918         _totalStaked -= amount;
919         staked[_msgSender()] -= amount;
920         token.safeTransfer(_msgSender(), amount);
921 
922         emit Withdraw(_msgSender(), amount);
923     }
924 
925     /**
926      * @notice function that allows a user to withdraw its initial deposit
927      * @dev `block.timestamp` higher than `lockupPeriod` (lockupPeriod finished)
928      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
929      * if rewards to claim
930      */
931     function withdrawAll() external nonReentrant override {
932 
933         _updateRewards();
934         if (_rewardsToClaim[_msgSender()] > 0) {
935             _claimRewards();
936         }
937 
938         _userStartTime[_msgSender()] = 0;
939         _totalStaked -= staked[_msgSender()];
940         uint stakedBalance = staked[_msgSender()];
941         staked[_msgSender()] = 0;
942         token.safeTransfer(_msgSender(), stakedBalance);
943 
944         emit Withdraw(_msgSender(), stakedBalance);
945     }
946 
947     /**
948      * @notice claim all remaining balance on the contract
949      * Residual balance is all the remaining tokens that have not been distributed
950      * (e.g, in case the number of stakeholders is not sufficient)
951      * Cannot claim initial stakeholders deposit
952      */
953     function withdrawResidualBalance() external onlyOwner {
954 
955         uint balance = token.balanceOf(address(this));
956         uint residualBalance = balance - (_totalStaked);
957         require(residualBalance > 0, "No residual Balance to withdraw");
958         token.safeTransfer(owner(), residualBalance);
959     }
960 
961     /**
962      * @notice function that returns the amount of total Staked tokens
963      * for a specific user
964      * @param stakeHolder, address of the user to check
965      * @return uint amount of the total deposited Tokens by the caller
966      */
967     function amountStaked(address stakeHolder)
968         external
969         view
970         override
971         returns (uint)
972     {
973         return staked[stakeHolder];
974     }
975 
976     /**
977      * @notice function that returns the amount of total Staked tokens
978      * on the smart contract
979      * @return uint amount of the total deposited Tokens
980      */
981     function totalDeposited() external view override returns (uint) {
982         return _totalStaked;
983     }
984 
985     /**
986      * @notice function that returns the amount of pending rewards
987      * that can be claimed by the user
988      * @param stakeHolder, address of the user to be checked
989      * @return uint amount of claimable rewards
990      */
991     function rewardOf(address stakeHolder)
992         external
993         view
994         override
995         returns (uint)
996     {
997         return _calculateRewards(stakeHolder);
998     }
999 
1000     /**
1001      * @notice function that claims pending rewards
1002      * @dev transfer the pending rewards to the `msg.sender`
1003      */
1004     function claimRewards() external override {
1005         _claimRewards();
1006     }
1007 
1008     /**
1009      * @notice calculate rewards based on the `fixedAPY`, `_percentageTimeRemaining()`
1010      * @dev the higher is the precision and the more the time remaining will be precise
1011      * @param stakeHolder, address of the user to be checked
1012      * @return uint amount of claimable tokens of the specified address
1013      */
1014     function _calculateRewards(address stakeHolder)
1015         internal
1016         view
1017         returns (uint)
1018     {
1019         if (startPeriod == 0 || staked[stakeHolder] == 0) {
1020             return 0;
1021         }
1022 
1023         return
1024             (((staked[stakeHolder] * fixedAPY) *
1025                 _percentageTimeRemaining(stakeHolder)) / (_precision * 100)) +
1026             _rewardsToClaim[stakeHolder];
1027     }
1028 
1029     /**
1030      * @notice function that returns the remaining time in seconds of the staking period
1031      * @dev the higher is the precision and the more the time remaining will be precise
1032      * @param stakeHolder, address of the user to be checked
1033      * @return uint percentage of time remaining * precision
1034      */
1035     function _percentageTimeRemaining(address stakeHolder)
1036         internal
1037         view
1038         returns (uint)
1039     {
1040         bool early = startPeriod > _userStartTime[stakeHolder];
1041         uint startTime;
1042         if (endPeriod > block.timestamp) {
1043             startTime = early ? startPeriod : _userStartTime[stakeHolder];
1044             uint timeRemaining = stakingDuration -
1045                 (block.timestamp - startTime);
1046             return
1047                 (_precision * (stakingDuration - timeRemaining)) /
1048                 stakingDuration;
1049         }
1050         startTime = early
1051             ? 0
1052             : stakingDuration - (endPeriod - _userStartTime[stakeHolder]);
1053         return (_precision * (stakingDuration - startTime)) / stakingDuration;
1054     }
1055 
1056     /**
1057      * @notice internal function that claims pending rewards
1058      * @dev transfer the pending rewards to the user address
1059      */
1060     function _claimRewards() private {
1061         _updateRewards();
1062 
1063         uint rewardsToClaim = _rewardsToClaim[_msgSender()];
1064         require(rewardsToClaim > 0, "Nothing to claim");
1065 
1066         _rewardsToClaim[_msgSender()] = 0;
1067         token.safeTransfer(_msgSender(), rewardsToClaim);
1068         emit Claim(_msgSender(), rewardsToClaim);
1069     }
1070 
1071     /**
1072      * @notice function that update pending rewards
1073      * and shift them to rewardsToClaim
1074      * @dev update rewards claimable
1075      * and check the time spent since deposit for the `msg.sender`
1076      */
1077     function _updateRewards() private {
1078         _rewardsToClaim[_msgSender()] = _calculateRewards(_msgSender());
1079         _userStartTime[_msgSender()] = (block.timestamp >= endPeriod)
1080             ? endPeriod
1081             : block.timestamp;
1082     }
1083 }