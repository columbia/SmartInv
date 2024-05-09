1 // File: nft-ne-fu2/contracts/lib/Init.sol
2 
3 
4 pragma solidity 0.8.4;
5 
6 contract Init {
7     bool public init;
8 
9     constructor(bool _init) {
10         // set true if using a proxy
11         init = _init;
12     }
13 
14     modifier isNotInitialized() {
15         require(!init, "Init: Contract already initialized");
16         init = true;
17         emit Initialized(msg.sender, true);
18         _;
19     }
20 
21     modifier isInitialized() {
22         require(init, "Init: Contract not initialized");
23         _;
24     }
25 
26     event Initialized(address initializer, bool flag);
27 }
28 // File: @openzeppelin/contracts/utils/Address.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
32 
33 pragma solidity ^0.8.1;
34 
35 /**
36  * @dev Collection of functions related to the address type
37  */
38 library Address {
39     /**
40      * @dev Returns true if `account` is a contract.
41      *
42      * [IMPORTANT]
43      * ====
44      * It is unsafe to assume that an address for which this function returns
45      * false is an externally-owned account (EOA) and not a contract.
46      *
47      * Among others, `isContract` will return false for the following
48      * types of addresses:
49      *
50      *  - an externally-owned account
51      *  - a contract in construction
52      *  - an address where a contract will be created
53      *  - an address where a contract lived, but was destroyed
54      * ====
55      *
56      * [IMPORTANT]
57      * ====
58      * You shouldn't rely on `isContract` to protect against flash loan attacks!
59      *
60      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
61      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
62      * constructor.
63      * ====
64      */
65     function isContract(address account) internal view returns (bool) {
66         // This method relies on extcodesize/address.code.length, which returns 0
67         // for contracts in construction, since the code is only stored at the end
68         // of the constructor execution.
69 
70         return account.code.length > 0;
71     }
72 
73     /**
74      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
75      * `recipient`, forwarding all available gas and reverting on errors.
76      *
77      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
78      * of certain opcodes, possibly making contracts go over the 2300 gas limit
79      * imposed by `transfer`, making them unable to receive funds via
80      * `transfer`. {sendValue} removes this limitation.
81      *
82      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
83      *
84      * IMPORTANT: because control is transferred to `recipient`, care must be
85      * taken to not create reentrancy vulnerabilities. Consider using
86      * {ReentrancyGuard} or the
87      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
88      */
89     function sendValue(address payable recipient, uint256 amount) internal {
90         require(address(this).balance >= amount, "Address: insufficient balance");
91 
92         (bool success, ) = recipient.call{value: amount}("");
93         require(success, "Address: unable to send value, recipient may have reverted");
94     }
95 
96     /**
97      * @dev Performs a Solidity function call using a low level `call`. A
98      * plain `call` is an unsafe replacement for a function call: use this
99      * function instead.
100      *
101      * If `target` reverts with a revert reason, it is bubbled up by this
102      * function (like regular Solidity function calls).
103      *
104      * Returns the raw returned data. To convert to the expected return value,
105      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
106      *
107      * Requirements:
108      *
109      * - `target` must be a contract.
110      * - calling `target` with `data` must not revert.
111      *
112      * _Available since v3.1._
113      */
114     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
115         return functionCall(target, data, "Address: low-level call failed");
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
120      * `errorMessage` as a fallback revert reason when `target` reverts.
121      *
122      * _Available since v3.1._
123      */
124     function functionCall(
125         address target,
126         bytes memory data,
127         string memory errorMessage
128     ) internal returns (bytes memory) {
129         return functionCallWithValue(target, data, 0, errorMessage);
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
134      * but also transferring `value` wei to `target`.
135      *
136      * Requirements:
137      *
138      * - the calling contract must have an ETH balance of at least `value`.
139      * - the called Solidity function must be `payable`.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value
147     ) internal returns (bytes memory) {
148         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
153      * with `errorMessage` as a fallback revert reason when `target` reverts.
154      *
155      * _Available since v3.1._
156      */
157     function functionCallWithValue(
158         address target,
159         bytes memory data,
160         uint256 value,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         require(address(this).balance >= value, "Address: insufficient balance for call");
164         require(isContract(target), "Address: call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.call{value: value}(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a static call.
173      *
174      * _Available since v3.3._
175      */
176     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
177         return functionStaticCall(target, data, "Address: low-level static call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a static call.
183      *
184      * _Available since v3.3._
185      */
186     function functionStaticCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal view returns (bytes memory) {
191         require(isContract(target), "Address: static call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.staticcall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but performing a delegate call.
200      *
201      * _Available since v3.4._
202      */
203     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
209      * but performing a delegate call.
210      *
211      * _Available since v3.4._
212      */
213     function functionDelegateCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(isContract(target), "Address: delegate call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.delegatecall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
226      * revert reason using the provided one.
227      *
228      * _Available since v4.3._
229      */
230     function verifyCallResult(
231         bool success,
232         bytes memory returndata,
233         string memory errorMessage
234     ) internal pure returns (bytes memory) {
235         if (success) {
236             return returndata;
237         } else {
238             // Look for revert reason and bubble it up if present
239             if (returndata.length > 0) {
240                 // The easiest way to bubble the revert reason is using memory via assembly
241                 /// @solidity memory-safe-assembly
242                 assembly {
243                     let returndata_size := mload(returndata)
244                     revert(add(32, returndata), returndata_size)
245                 }
246             } else {
247                 revert(errorMessage);
248             }
249         }
250     }
251 }
252 
253 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
254 
255 
256 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
262  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
263  *
264  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
265  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
266  * need to send a transaction, and thus is not required to hold Ether at all.
267  */
268 interface IERC20Permit {
269     /**
270      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
271      * given ``owner``'s signed approval.
272      *
273      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
274      * ordering also apply here.
275      *
276      * Emits an {Approval} event.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      * - `deadline` must be a timestamp in the future.
282      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
283      * over the EIP712-formatted function arguments.
284      * - the signature must use ``owner``'s current nonce (see {nonces}).
285      *
286      * For more information on the signature format, see the
287      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
288      * section].
289      */
290     function permit(
291         address owner,
292         address spender,
293         uint256 value,
294         uint256 deadline,
295         uint8 v,
296         bytes32 r,
297         bytes32 s
298     ) external;
299 
300     /**
301      * @dev Returns the current nonce for `owner`. This value must be
302      * included whenever a signature is generated for {permit}.
303      *
304      * Every successful call to {permit} increases ``owner``'s nonce by one. This
305      * prevents a signature from being used multiple times.
306      */
307     function nonces(address owner) external view returns (uint256);
308 
309     /**
310      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
311      */
312     // solhint-disable-next-line func-name-mixedcase
313     function DOMAIN_SEPARATOR() external view returns (bytes32);
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
317 
318 
319 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Interface of the ERC20 standard as defined in the EIP.
325  */
326 interface IERC20 {
327     /**
328      * @dev Emitted when `value` tokens are moved from one account (`from`) to
329      * another (`to`).
330      *
331      * Note that `value` may be zero.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 value);
334 
335     /**
336      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
337      * a call to {approve}. `value` is the new allowance.
338      */
339     event Approval(address indexed owner, address indexed spender, uint256 value);
340 
341     /**
342      * @dev Returns the amount of tokens in existence.
343      */
344     function totalSupply() external view returns (uint256);
345 
346     /**
347      * @dev Returns the amount of tokens owned by `account`.
348      */
349     function balanceOf(address account) external view returns (uint256);
350 
351     /**
352      * @dev Moves `amount` tokens from the caller's account to `to`.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * Emits a {Transfer} event.
357      */
358     function transfer(address to, uint256 amount) external returns (bool);
359 
360     /**
361      * @dev Returns the remaining number of tokens that `spender` will be
362      * allowed to spend on behalf of `owner` through {transferFrom}. This is
363      * zero by default.
364      *
365      * This value changes when {approve} or {transferFrom} are called.
366      */
367     function allowance(address owner, address spender) external view returns (uint256);
368 
369     /**
370      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * IMPORTANT: Beware that changing an allowance with this method brings the risk
375      * that someone may use both the old and the new allowance by unfortunate
376      * transaction ordering. One possible solution to mitigate this race
377      * condition is to first reduce the spender's allowance to 0 and set the
378      * desired value afterwards:
379      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
380      *
381      * Emits an {Approval} event.
382      */
383     function approve(address spender, uint256 amount) external returns (bool);
384 
385     /**
386      * @dev Moves `amount` tokens from `from` to `to` using the
387      * allowance mechanism. `amount` is then deducted from the caller's
388      * allowance.
389      *
390      * Returns a boolean value indicating whether the operation succeeded.
391      *
392      * Emits a {Transfer} event.
393      */
394     function transferFrom(
395         address from,
396         address to,
397         uint256 amount
398     ) external returns (bool);
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
402 
403 
404 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 
409 
410 
411 /**
412  * @title SafeERC20
413  * @dev Wrappers around ERC20 operations that throw on failure (when the token
414  * contract returns false). Tokens that return no value (and instead revert or
415  * throw on failure) are also supported, non-reverting calls are assumed to be
416  * successful.
417  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
418  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
419  */
420 library SafeERC20 {
421     using Address for address;
422 
423     function safeTransfer(
424         IERC20 token,
425         address to,
426         uint256 value
427     ) internal {
428         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
429     }
430 
431     function safeTransferFrom(
432         IERC20 token,
433         address from,
434         address to,
435         uint256 value
436     ) internal {
437         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
438     }
439 
440     /**
441      * @dev Deprecated. This function has issues similar to the ones found in
442      * {IERC20-approve}, and its usage is discouraged.
443      *
444      * Whenever possible, use {safeIncreaseAllowance} and
445      * {safeDecreaseAllowance} instead.
446      */
447     function safeApprove(
448         IERC20 token,
449         address spender,
450         uint256 value
451     ) internal {
452         // safeApprove should only be called when setting an initial allowance,
453         // or when resetting it to zero. To increase and decrease it, use
454         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
455         require(
456             (value == 0) || (token.allowance(address(this), spender) == 0),
457             "SafeERC20: approve from non-zero to non-zero allowance"
458         );
459         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
460     }
461 
462     function safeIncreaseAllowance(
463         IERC20 token,
464         address spender,
465         uint256 value
466     ) internal {
467         uint256 newAllowance = token.allowance(address(this), spender) + value;
468         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469     }
470 
471     function safeDecreaseAllowance(
472         IERC20 token,
473         address spender,
474         uint256 value
475     ) internal {
476         unchecked {
477             uint256 oldAllowance = token.allowance(address(this), spender);
478             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
479             uint256 newAllowance = oldAllowance - value;
480             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
481         }
482     }
483 
484     function safePermit(
485         IERC20Permit token,
486         address owner,
487         address spender,
488         uint256 value,
489         uint256 deadline,
490         uint8 v,
491         bytes32 r,
492         bytes32 s
493     ) internal {
494         uint256 nonceBefore = token.nonces(owner);
495         token.permit(owner, spender, value, deadline, v, r, s);
496         uint256 nonceAfter = token.nonces(owner);
497         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
498     }
499 
500     /**
501      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
502      * on the return value: the return value is optional (but if data is returned, it must not be false).
503      * @param token The token targeted by the call.
504      * @param data The call data (encoded using abi.encode or one of its variants).
505      */
506     function _callOptionalReturn(IERC20 token, bytes memory data) private {
507         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
508         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
509         // the target address contains contract code and also asserts for success in the low-level call.
510 
511         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
512         if (returndata.length > 0) {
513             // Return data is optional
514             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
515         }
516     }
517 }
518 
519 // File: nft-ne-fu2/contracts/lib/IsOwner.sol
520 
521 
522 pragma solidity 0.8.4;
523 
524 abstract contract IsOwner {
525   function isOwner() internal view virtual returns (bool);
526 }
527 // File: nft-ne-fu2/contracts/lib/ERC20Recovery.sol
528 
529 
530 pragma solidity 0.8.4;
531 
532 
533 
534 interface IERC20Recovery {
535   function balanceOf(address) external view returns(uint256);
536   function safeTransfer(address, uint256) external;
537 }
538 
539 abstract contract ERC20Recovery is IsOwner {
540 
541     using SafeERC20 for IERC20Recovery;
542 
543     function recoverERC20(address _tokenAddress, address _receiver) external {
544         require(isOwner(), "ERC20Recovery: Only the owner can recover ERC20");
545         
546         IERC20Recovery token = IERC20Recovery(_tokenAddress);
547         
548         uint256 amount = token.balanceOf(address(this));
549         token.safeTransfer(_receiver, amount);
550 
551         emit ERC20RecoveryTransfer(
552             _tokenAddress,
553             msg.sender,
554             _receiver,
555             amount
556         );
557     }
558 
559     event ERC20RecoveryTransfer(
560         address indexed token,
561         address indexed sender,
562         address indexed receiver,
563         uint256 amount
564     );
565 }
566 // File: @openzeppelin/contracts/utils/Context.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @dev Provides information about the current execution context, including the
575  * sender of the transaction and its data. While these are generally available
576  * via msg.sender and msg.data, they should not be accessed in such a direct
577  * manner, since when dealing with meta-transactions the account sending and
578  * paying for execution may not be the actual sender (as far as an application
579  * is concerned).
580  *
581  * This contract is only required for intermediate, library-like contracts.
582  */
583 abstract contract Context {
584     function _msgSender() internal view virtual returns (address) {
585         return msg.sender;
586     }
587 
588     function _msgData() internal view virtual returns (bytes calldata) {
589         return msg.data;
590     }
591 }
592 
593 // File: @openzeppelin/contracts/security/Pausable.sol
594 
595 
596 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @dev Contract module which allows children to implement an emergency stop
603  * mechanism that can be triggered by an authorized account.
604  *
605  * This module is used through inheritance. It will make available the
606  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
607  * the functions of your contract. Note that they will not be pausable by
608  * simply including this module, only once the modifiers are put in place.
609  */
610 abstract contract Pausable is Context {
611     /**
612      * @dev Emitted when the pause is triggered by `account`.
613      */
614     event Paused(address account);
615 
616     /**
617      * @dev Emitted when the pause is lifted by `account`.
618      */
619     event Unpaused(address account);
620 
621     bool private _paused;
622 
623     /**
624      * @dev Initializes the contract in unpaused state.
625      */
626     constructor() {
627         _paused = false;
628     }
629 
630     /**
631      * @dev Modifier to make a function callable only when the contract is not paused.
632      *
633      * Requirements:
634      *
635      * - The contract must not be paused.
636      */
637     modifier whenNotPaused() {
638         _requireNotPaused();
639         _;
640     }
641 
642     /**
643      * @dev Modifier to make a function callable only when the contract is paused.
644      *
645      * Requirements:
646      *
647      * - The contract must be paused.
648      */
649     modifier whenPaused() {
650         _requirePaused();
651         _;
652     }
653 
654     /**
655      * @dev Returns true if the contract is paused, and false otherwise.
656      */
657     function paused() public view virtual returns (bool) {
658         return _paused;
659     }
660 
661     /**
662      * @dev Throws if the contract is paused.
663      */
664     function _requireNotPaused() internal view virtual {
665         require(!paused(), "Pausable: paused");
666     }
667 
668     /**
669      * @dev Throws if the contract is not paused.
670      */
671     function _requirePaused() internal view virtual {
672         require(paused(), "Pausable: not paused");
673     }
674 
675     /**
676      * @dev Triggers stopped state.
677      *
678      * Requirements:
679      *
680      * - The contract must not be paused.
681      */
682     function _pause() internal virtual whenNotPaused {
683         _paused = true;
684         emit Paused(_msgSender());
685     }
686 
687     /**
688      * @dev Returns to normal state.
689      *
690      * Requirements:
691      *
692      * - The contract must be paused.
693      */
694     function _unpause() internal virtual whenPaused {
695         _paused = false;
696         emit Unpaused(_msgSender());
697     }
698 }
699 
700 // File: nft-ne-fu2/contracts/lib/Pause.sol
701 
702 
703 pragma solidity 0.8.4;
704 
705 
706 
707 abstract contract Pause is Pausable, IsOwner {
708 
709   function pause() external{
710     require(isOwner(), "Pause: Only the owner can pause");
711     _pause();
712   }
713   function unpause() external {
714     require(isOwner(), "Pause: Only the owner can unpause");
715     _unpause();
716   }
717 }
718 // File: @openzeppelin/contracts/access/Ownable.sol
719 
720 
721 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 
726 /**
727  * @dev Contract module which provides a basic access control mechanism, where
728  * there is an account (an owner) that can be granted exclusive access to
729  * specific functions.
730  *
731  * By default, the owner account will be the one that deploys the contract. This
732  * can later be changed with {transferOwnership}.
733  *
734  * This module is used through inheritance. It will make available the modifier
735  * `onlyOwner`, which can be applied to your functions to restrict their use to
736  * the owner.
737  */
738 abstract contract Ownable is Context {
739     address private _owner;
740 
741     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
742 
743     /**
744      * @dev Initializes the contract setting the deployer as the initial owner.
745      */
746     constructor() {
747         _transferOwnership(_msgSender());
748     }
749 
750     /**
751      * @dev Throws if called by any account other than the owner.
752      */
753     modifier onlyOwner() {
754         _checkOwner();
755         _;
756     }
757 
758     /**
759      * @dev Returns the address of the current owner.
760      */
761     function owner() public view virtual returns (address) {
762         return _owner;
763     }
764 
765     /**
766      * @dev Throws if the sender is not the owner.
767      */
768     function _checkOwner() internal view virtual {
769         require(owner() == _msgSender(), "Ownable: caller is not the owner");
770     }
771 
772     /**
773      * @dev Leaves the contract without owner. It will not be possible to call
774      * `onlyOwner` functions anymore. Can only be called by the current owner.
775      *
776      * NOTE: Renouncing ownership will leave the contract without an owner,
777      * thereby removing any functionality that is only available to the owner.
778      */
779     function renounceOwnership() public virtual onlyOwner {
780         _transferOwnership(address(0));
781     }
782 
783     /**
784      * @dev Transfers ownership of the contract to a new account (`newOwner`).
785      * Can only be called by the current owner.
786      */
787     function transferOwnership(address newOwner) public virtual onlyOwner {
788         require(newOwner != address(0), "Ownable: new owner is the zero address");
789         _transferOwnership(newOwner);
790     }
791 
792     /**
793      * @dev Transfers ownership of the contract to a new account (`newOwner`).
794      * Internal function without access restriction.
795      */
796     function _transferOwnership(address newOwner) internal virtual {
797         address oldOwner = _owner;
798         _owner = newOwner;
799         emit OwnershipTransferred(oldOwner, newOwner);
800     }
801 }
802 
803 // File: nft-ne-fu2/contracts/lib/IERC721A.sol
804 
805 
806 // ERC721A Contracts v4.0.0
807 // Creator: Chiru Labs
808 
809 pragma solidity ^0.8.4;
810 
811 /**
812  * @dev Interface of an ERC721A compliant contract.
813  */
814 interface IERC721A {
815     /**
816      * The caller must own the token or be an approved operator.
817      */
818     error ApprovalCallerNotOwnerNorApproved();
819 
820     /**
821      * The token does not exist.
822      */
823     error ApprovalQueryForNonexistentToken();
824 
825     /**
826      * The caller cannot approve to their own address.
827      */
828     error ApproveToCaller();
829 
830     /**
831      * Cannot query the balance for the zero address.
832      */
833     error BalanceQueryForZeroAddress();
834 
835     /**
836      * Cannot mint to the zero address.
837      */
838     error MintToZeroAddress();
839 
840     /**
841      * The quantity of tokens minted must be more than zero.
842      */
843     error MintZeroQuantity();
844 
845     /**
846      * The token does not exist.
847      */
848     error OwnerQueryForNonexistentToken();
849 
850     /**
851      * The caller must own the token or be an approved operator.
852      */
853     error TransferCallerNotOwnerNorApproved();
854 
855     /**
856      * The token must be owned by `from`.
857      */
858     error TransferFromIncorrectOwner();
859 
860     /**
861      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
862      */
863     error TransferToNonERC721ReceiverImplementer();
864 
865     /**
866      * Cannot transfer to the zero address.
867      */
868     error TransferToZeroAddress();
869 
870     /**
871      * The token does not exist.
872      */
873     error URIQueryForNonexistentToken();
874 
875     struct TokenOwnership {
876         // The address of the owner.
877         address addr;
878         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
879         uint64 startTimestamp;
880         // Whether the token has been burned.
881         bool burned;
882     }
883 
884     /**
885      * @dev Returns the total amount of tokens stored by the contract.
886      *
887      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
888      */
889     function totalSupply() external view returns (uint256);
890 
891     // ==============================
892     //            IERC165
893     // ==============================
894 
895     /**
896      * @dev Returns true if this contract implements the interface defined by
897      * `interfaceId`. See the corresponding
898      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
899      * to learn more about how these ids are created.
900      *
901      * This function call must use less than 30 000 gas.
902      */
903     function supportsInterface(bytes4 interfaceId) external view returns (bool);
904 
905     // ==============================
906     //            IERC721
907     // ==============================
908 
909     /**
910      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
911      */
912     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
913 
914     /**
915      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
916      */
917     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
918 
919     /**
920      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
921      */
922     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
923 
924     /**
925      * @dev Returns the number of tokens in ``owner``'s account.
926      */
927     function balanceOf(address owner) external view returns (uint256 balance);
928 
929     /**
930      * @dev Returns the owner of the `tokenId` token.
931      *
932      * Requirements:
933      *
934      * - `tokenId` must exist.
935      */
936     function ownerOf(uint256 tokenId) external view returns (address owner);
937 
938     /**
939      * @dev Safely transfers `tokenId` token from `from` to `to`.
940      *
941      * Requirements:
942      *
943      * - `from` cannot be the zero address.
944      * - `to` cannot be the zero address.
945      * - `tokenId` token must exist and be owned by `from`.
946      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
947      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
948      *
949      * Emits a {Transfer} event.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes calldata data
956     ) external;
957 
958     /**
959      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
960      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
961      *
962      * Requirements:
963      *
964      * - `from` cannot be the zero address.
965      * - `to` cannot be the zero address.
966      * - `tokenId` token must exist and be owned by `from`.
967      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) external;
977 
978     /**
979      * @dev Transfers `tokenId` token from `from` to `to`.
980      *
981      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
982      *
983      * Requirements:
984      *
985      * - `from` cannot be the zero address.
986      * - `to` cannot be the zero address.
987      * - `tokenId` token must be owned by `from`.
988      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
989      *
990      * Emits a {Transfer} event.
991      */
992     function transferFrom(
993         address from,
994         address to,
995         uint256 tokenId
996     ) external;
997 
998     /**
999      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1000      * The approval is cleared when the token is transferred.
1001      *
1002      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1003      *
1004      * Requirements:
1005      *
1006      * - The caller must own the token or be an approved operator.
1007      * - `tokenId` must exist.
1008      *
1009      * Emits an {Approval} event.
1010      */
1011     function approve(address to, uint256 tokenId) external;
1012 
1013     /**
1014      * @dev Approve or remove `operator` as an operator for the caller.
1015      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1016      *
1017      * Requirements:
1018      *
1019      * - The `operator` cannot be the caller.
1020      *
1021      * Emits an {ApprovalForAll} event.
1022      */
1023     function setApprovalForAll(address operator, bool _approved) external;
1024 
1025     /**
1026      * @dev Returns the account approved for `tokenId` token.
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must exist.
1031      */
1032     function getApproved(uint256 tokenId) external view returns (address operator);
1033 
1034     /**
1035      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1036      *
1037      * See {setApprovalForAll}
1038      */
1039     function isApprovedForAll(address owner, address operator) external view returns (bool);
1040 
1041     // ==============================
1042     //        IERC721Metadata
1043     // ==============================
1044 
1045     /**
1046      * @dev Returns the token collection name.
1047      */
1048     function name() external view returns (string memory);
1049 
1050     /**
1051      * @dev Returns the token collection symbol.
1052      */
1053     function symbol() external view returns (string memory);
1054 
1055     /**
1056      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1057      */
1058     function tokenURI(uint256 tokenId) external view returns (string memory);
1059 }
1060 // File: nft-ne-fu2/contracts/lib/ERC721A.sol
1061 
1062 
1063 // ERC721A Contracts v4.0.0
1064 // Creator: Chiru Labs
1065 
1066 pragma solidity ^0.8.4;
1067 
1068 
1069 /**
1070  * @dev ERC721 token receiver interface.
1071  */
1072 interface ERC721A__IERC721Receiver {
1073     function onERC721Received(
1074         address operator,
1075         address from,
1076         uint256 tokenId,
1077         bytes calldata data
1078     ) external returns (bytes4);
1079 }
1080 
1081 /**
1082  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1083  * the Metadata extension. Built to optimize for lower gas during batch mints.
1084  *
1085  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1086  *
1087  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1088  *
1089  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1090  */
1091 contract ERC721A is IERC721A {
1092     // Mask of an entry in packed address data.
1093     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1094 
1095     // The bit position of `numberMinted` in packed address data.
1096     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1097 
1098     // The bit position of `numberBurned` in packed address data.
1099     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1100 
1101     // The bit position of `aux` in packed address data.
1102     uint256 private constant BITPOS_AUX = 192;
1103 
1104     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1105     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1106 
1107     // The bit position of `startTimestamp` in packed ownership.
1108     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1109 
1110     // The bit mask of the `burned` bit in packed ownership.
1111     uint256 private constant BITMASK_BURNED = 1 << 224;
1112 
1113     // The bit position of the `nextInitialized` bit in packed ownership.
1114     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1115 
1116     // The bit mask of the `nextInitialized` bit in packed ownership.
1117     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1118 
1119     // The tokenId of the next token to be minted.
1120     uint256 private _currentIndex;
1121 
1122     // The number of tokens burned.
1123     uint256 private _burnCounter;
1124 
1125     // Token name
1126     string private _name;
1127 
1128     // Token symbol
1129     string private _symbol;
1130 
1131     // Mapping from token ID to ownership details
1132     // An empty struct value does not necessarily mean the token is unowned.
1133     // See `_packedOwnershipOf` implementation for details.
1134     //
1135     // Bits Layout:
1136     // - [0..159]   `addr`
1137     // - [160..223] `startTimestamp`
1138     // - [224]      `burned`
1139     // - [225]      `nextInitialized`
1140     mapping(uint256 => uint256) private _packedOwnerships;
1141 
1142     // Mapping owner address to address data.
1143     //
1144     // Bits Layout:
1145     // - [0..63]    `balance`
1146     // - [64..127]  `numberMinted`
1147     // - [128..191] `numberBurned`
1148     // - [192..255] `aux`
1149     mapping(address => uint256) private _packedAddressData;
1150 
1151     // Mapping from token ID to approved address.
1152     mapping(uint256 => address) private _tokenApprovals;
1153 
1154     // Mapping from owner to operator approvals
1155     mapping(address => mapping(address => bool)) private _operatorApprovals;
1156 
1157     function __ERC721A_Init(string memory name_, string memory symbol_)
1158         internal
1159     {
1160         _name = name_;
1161         _symbol = symbol_;
1162         _currentIndex = _startTokenId();
1163     }
1164 
1165     /**
1166      * @dev Returns the starting token ID.
1167      * To change the starting token ID, please override this function.
1168      */
1169     function _startTokenId() internal view virtual returns (uint256) {
1170         return 0;
1171     }
1172 
1173     /**
1174      * @dev Returns the next token ID to be minted.
1175      */
1176     function _nextTokenId() internal view returns (uint256) {
1177         return _currentIndex;
1178     }
1179 
1180     /**
1181      * @dev Returns the total number of tokens in existence.
1182      * Burned tokens will reduce the count.
1183      * To get the total number of tokens minted, please see `_totalMinted`.
1184      */
1185     function totalSupply() public view override returns (uint256) {
1186         // Counter underflow is impossible as _burnCounter cannot be incremented
1187         // more than `_currentIndex - _startTokenId()` times.
1188         unchecked {
1189             return _currentIndex - _burnCounter - _startTokenId();
1190         }
1191     }
1192 
1193     /**
1194      * @dev Returns the total amount of tokens minted in the contract.
1195      */
1196     function _totalMinted() internal view returns (uint256) {
1197         // Counter underflow is impossible as _currentIndex does not decrement,
1198         // and it is initialized to `_startTokenId()`
1199         unchecked {
1200             return _currentIndex - _startTokenId();
1201         }
1202     }
1203 
1204     /**
1205      * @dev Returns the total number of tokens burned.
1206      */
1207     function _totalBurned() internal view returns (uint256) {
1208         return _burnCounter;
1209     }
1210 
1211     /**
1212      * @dev See {IERC165-supportsInterface}.
1213      */
1214     function supportsInterface(bytes4 interfaceId)
1215         public
1216         view
1217         virtual
1218         override
1219         returns (bool)
1220     {
1221         // The interface IDs are constants representing the first 4 bytes of the XOR of
1222         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1223         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1224         return
1225             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1226             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1227             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-balanceOf}.
1232      */
1233     function balanceOf(address owner) public view override returns (uint256) {
1234         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
1235         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1236     }
1237 
1238     /**
1239      * Returns the number of tokens minted by `owner`.
1240      */
1241     function _numberMinted(address owner) internal view returns (uint256) {
1242         return
1243             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
1244             BITMASK_ADDRESS_DATA_ENTRY;
1245     }
1246 
1247     /**
1248      * Returns the number of tokens burned by or on behalf of `owner`.
1249      */
1250     function _numberBurned(address owner) internal view returns (uint256) {
1251         return
1252             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
1253             BITMASK_ADDRESS_DATA_ENTRY;
1254     }
1255 
1256     /**
1257      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1258      */
1259     function _getAux(address owner) internal view returns (uint64) {
1260         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1261     }
1262 
1263     /**
1264      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1265      * If there are multiple variables, please pack them into a uint64.
1266      */
1267     function _setAux(address owner, uint64 aux) internal {
1268         uint256 packed = _packedAddressData[owner];
1269         uint256 auxCasted;
1270         assembly {
1271             // Cast aux without masking.
1272             auxCasted := aux
1273         }
1274         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1275         _packedAddressData[owner] = packed;
1276     }
1277 
1278     /**
1279      * Returns the packed ownership data of `tokenId`.
1280      */
1281     function _packedOwnershipOf(uint256 tokenId)
1282         private
1283         view
1284         returns (uint256)
1285     {
1286         uint256 curr = tokenId;
1287 
1288         unchecked {
1289             if (_startTokenId() <= curr)
1290                 if (curr < _currentIndex) {
1291                     uint256 packed = _packedOwnerships[curr];
1292                     // If not burned.
1293                     if (packed & BITMASK_BURNED == 0) {
1294                         // Invariant:
1295                         // There will always be an ownership that has an address and is not burned
1296                         // before an ownership that does not have an address and is not burned.
1297                         // Hence, curr will not underflow.
1298                         //
1299                         // We can directly compare the packed value.
1300                         // If the address is zero, packed is zero.
1301                         while (packed == 0) {
1302                             packed = _packedOwnerships[--curr];
1303                         }
1304                         return packed;
1305                     }
1306                 }
1307         }
1308         revert OwnerQueryForNonexistentToken();
1309     }
1310 
1311     /**
1312      * Returns the unpacked `TokenOwnership` struct from `packed`.
1313      */
1314     function _unpackedOwnership(uint256 packed)
1315         private
1316         pure
1317         returns (TokenOwnership memory ownership)
1318     {
1319         ownership.addr = address(uint160(packed));
1320         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1321         ownership.burned = packed & BITMASK_BURNED != 0;
1322     }
1323 
1324     /**
1325      * Returns the unpacked `TokenOwnership` struct at `index`.
1326      */
1327     function _ownershipAt(uint256 index)
1328         internal
1329         view
1330         returns (TokenOwnership memory)
1331     {
1332         return _unpackedOwnership(_packedOwnerships[index]);
1333     }
1334 
1335     /**
1336      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1337      */
1338     function _initializeOwnershipAt(uint256 index) internal {
1339         if (_packedOwnerships[index] == 0) {
1340             _packedOwnerships[index] = _packedOwnershipOf(index);
1341         }
1342     }
1343 
1344     /**
1345      * Gas spent here starts off proportional to the maximum mint batch size.
1346      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1347      */
1348     function _ownershipOf(uint256 tokenId)
1349         internal
1350         view
1351         returns (TokenOwnership memory)
1352     {
1353         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1354     }
1355 
1356     /**
1357      * @dev See {IERC721-ownerOf}.
1358      */
1359     function ownerOf(uint256 tokenId) public view override returns (address) {
1360         return address(uint160(_packedOwnershipOf(tokenId)));
1361     }
1362 
1363     /**
1364      * @dev See {IERC721Metadata-name}.
1365      */
1366     function name() public view virtual override returns (string memory) {
1367         return _name;
1368     }
1369 
1370     /**
1371      * @dev See {IERC721Metadata-symbol}.
1372      */
1373     function symbol() public view virtual override returns (string memory) {
1374         return _symbol;
1375     }
1376 
1377     /**
1378      * @dev See {IERC721Metadata-tokenURI}.
1379      */
1380     function tokenURI(uint256 tokenId)
1381         public
1382         view
1383         virtual
1384         override
1385         returns (string memory)
1386     {
1387         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1388 
1389         string memory baseURI = _baseURI();
1390         return
1391             bytes(baseURI).length != 0
1392                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
1393                 : "";
1394     }
1395 
1396     /**
1397      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1398      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1399      * by default, can be overriden in child contracts.
1400      */
1401     function _baseURI() internal view virtual returns (string memory) {
1402         return "";
1403     }
1404 
1405     /**
1406      * @dev Casts the address to uint256 without masking.
1407      */
1408     function _addressToUint256(address value)
1409         private
1410         pure
1411         returns (uint256 result)
1412     {
1413         assembly {
1414             result := value
1415         }
1416     }
1417 
1418     /**
1419      * @dev Casts the boolean to uint256 without branching.
1420      */
1421     function _boolToUint256(bool value) private pure returns (uint256 result) {
1422         assembly {
1423             result := value
1424         }
1425     }
1426 
1427     /**
1428      * @dev See {IERC721-approve}.
1429      */
1430     function approve(address to, uint256 tokenId) public override {
1431         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1432 
1433         if (_msgSenderERC721A() != owner)
1434             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1435                 revert ApprovalCallerNotOwnerNorApproved();
1436             }
1437 
1438         _tokenApprovals[tokenId] = to;
1439         emit Approval(owner, to, tokenId);
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-getApproved}.
1444      */
1445     function getApproved(uint256 tokenId)
1446         public
1447         view
1448         override
1449         returns (address)
1450     {
1451         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1452 
1453         return _tokenApprovals[tokenId];
1454     }
1455 
1456     /**
1457      * @dev See {IERC721-setApprovalForAll}.
1458      */
1459     function setApprovalForAll(address operator, bool approved)
1460         public
1461         virtual
1462         override
1463     {
1464         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1465 
1466         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1467         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-isApprovedForAll}.
1472      */
1473     function isApprovedForAll(address owner, address operator)
1474         public
1475         view
1476         virtual
1477         override
1478         returns (bool)
1479     {
1480         return _operatorApprovals[owner][operator];
1481     }
1482 
1483     /**
1484      * @dev See {IERC721-transferFrom}.
1485      */
1486     function transferFrom(
1487         address from,
1488         address to,
1489         uint256 tokenId
1490     ) public virtual override {
1491         _transfer(from, to, tokenId);
1492     }
1493 
1494     /**
1495      * @dev See {IERC721-safeTransferFrom}.
1496      */
1497     function safeTransferFrom(
1498         address from,
1499         address to,
1500         uint256 tokenId
1501     ) public virtual override {
1502         safeTransferFrom(from, to, tokenId, "");
1503     }
1504 
1505     /**
1506      * @dev See {IERC721-safeTransferFrom}.
1507      */
1508     function safeTransferFrom(
1509         address from,
1510         address to,
1511         uint256 tokenId,
1512         bytes memory _data
1513     ) public virtual override {
1514         _transfer(from, to, tokenId);
1515         if (to.code.length != 0)
1516             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1517                 revert TransferToNonERC721ReceiverImplementer();
1518             }
1519     }
1520 
1521     /**
1522      * @dev Returns whether `tokenId` exists.
1523      *
1524      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1525      *
1526      * Tokens start existing when they are minted (`_mint`),
1527      */
1528     function _exists(uint256 tokenId) internal view returns (bool) {
1529         return
1530             _startTokenId() <= tokenId &&
1531             tokenId < _currentIndex && // If within bounds,
1532             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1533     }
1534 
1535     /**
1536      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1537      */
1538     function _safeMint(address to, uint256 quantity) internal {
1539         _safeMint(to, quantity, "");
1540     }
1541 
1542     /**
1543      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1544      *
1545      * Requirements:
1546      *
1547      * - If `to` refers to a smart contract, it must implement
1548      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1549      * - `quantity` must be greater than 0.
1550      *
1551      * Emits a {Transfer} event for each mint.
1552      */
1553     function _safeMint(
1554         address to,
1555         uint256 quantity,
1556         bytes memory _data
1557     ) internal {
1558         _mint(to, quantity);
1559 
1560         unchecked {
1561             if (to.code.length != 0) {
1562                 uint256 end = _currentIndex;
1563                 uint256 index = end - quantity;
1564                 do {
1565                     if (
1566                         !_checkContractOnERC721Received(
1567                             address(0),
1568                             to,
1569                             index++,
1570                             _data
1571                         )
1572                     ) {
1573                         revert TransferToNonERC721ReceiverImplementer();
1574                     }
1575                 } while (index < end);
1576                 // Reentrancy protection.
1577                 if (_currentIndex != end) revert();
1578             }
1579         }
1580     }
1581 
1582     /**
1583      * @dev Mints `quantity` tokens and transfers them to `to`.
1584      *
1585      * Requirements:
1586      *
1587      * - `to` cannot be the zero address.
1588      * - `quantity` must be greater than 0.
1589      *
1590      * Emits a {Transfer} event for each mint.
1591      */
1592     function _mint(address to, uint256 quantity) internal {
1593         uint256 startTokenId = _currentIndex;
1594         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1595         if (quantity == 0) revert MintZeroQuantity();
1596 
1597         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1598 
1599         // Overflows are incredibly unrealistic.
1600         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1601         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1602         unchecked {
1603             // Updates:
1604             // - `balance += quantity`.
1605             // - `numberMinted += quantity`.
1606             //
1607             // We can directly add to the balance and number minted.
1608             _packedAddressData[to] +=
1609                 quantity *
1610                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1611 
1612             // Updates:
1613             // - `address` to the owner.
1614             // - `startTimestamp` to the timestamp of minting.
1615             // - `burned` to `false`.
1616             // - `nextInitialized` to `quantity == 1`.
1617             _packedOwnerships[startTokenId] =
1618                 _addressToUint256(to) |
1619                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1620                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1621 
1622             uint256 offset;
1623             do {
1624                 emit Transfer(address(0), to, startTokenId + offset++);
1625             } while (offset < quantity);
1626 
1627             _currentIndex = startTokenId + quantity;
1628         }
1629         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1630     }
1631 
1632     /**
1633      * @dev Transfers `tokenId` from `from` to `to`.
1634      *
1635      * Requirements:
1636      *
1637      * - `to` cannot be the zero address.
1638      * - `tokenId` token must be owned by `from`.
1639      *
1640      * Emits a {Transfer} event.
1641      */
1642     function _transfer(
1643         address from,
1644         address to,
1645         uint256 tokenId
1646     ) private {
1647         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1648 
1649         if (address(uint160(prevOwnershipPacked)) != from)
1650             revert TransferFromIncorrectOwner();
1651 
1652         address approvedAddress = _tokenApprovals[tokenId];
1653 
1654         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1655             isApprovedForAll(from, _msgSenderERC721A()) ||
1656             approvedAddress == _msgSenderERC721A());
1657 
1658         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1659         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1660 
1661         _beforeTokenTransfers(from, to, tokenId, 1);
1662 
1663         // Clear approvals from the previous owner.
1664         if (_addressToUint256(approvedAddress) != 0) {
1665             delete _tokenApprovals[tokenId];
1666         }
1667 
1668         // Underflow of the sender's balance is impossible because we check for
1669         // ownership above and the recipient's balance can't realistically overflow.
1670         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1671         unchecked {
1672             // We can directly increment and decrement the balances.
1673             --_packedAddressData[from]; // Updates: `balance -= 1`.
1674             ++_packedAddressData[to]; // Updates: `balance += 1`.
1675 
1676             // Updates:
1677             // - `address` to the next owner.
1678             // - `startTimestamp` to the timestamp of transfering.
1679             // - `burned` to `false`.
1680             // - `nextInitialized` to `true`.
1681             _packedOwnerships[tokenId] =
1682                 _addressToUint256(to) |
1683                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1684                 BITMASK_NEXT_INITIALIZED;
1685 
1686             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1687             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1688                 uint256 nextTokenId = tokenId + 1;
1689                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1690                 if (_packedOwnerships[nextTokenId] == 0) {
1691                     // If the next slot is within bounds.
1692                     if (nextTokenId != _currentIndex) {
1693                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1694                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1695                     }
1696                 }
1697             }
1698         }
1699 
1700         emit Transfer(from, to, tokenId);
1701         _afterTokenTransfers(from, to, tokenId, 1);
1702     }
1703 
1704     /**
1705      * @dev Equivalent to `_burn(tokenId, false)`.
1706      */
1707     function _burn(uint256 tokenId) internal virtual {
1708         _burn(tokenId, false);
1709     }
1710 
1711     /**
1712      * @dev Destroys `tokenId`.
1713      * The approval is cleared when the token is burned.
1714      *
1715      * Requirements:
1716      *
1717      * - `tokenId` must exist.
1718      *
1719      * Emits a {Transfer} event.
1720      */
1721     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1722         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1723 
1724         address from = address(uint160(prevOwnershipPacked));
1725         address approvedAddress = _tokenApprovals[tokenId];
1726 
1727         if (approvalCheck) {
1728             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1729                 isApprovedForAll(from, _msgSenderERC721A()) ||
1730                 approvedAddress == _msgSenderERC721A());
1731 
1732             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1733         }
1734 
1735         _beforeTokenTransfers(from, address(0), tokenId, 1);
1736 
1737         // Clear approvals from the previous owner.
1738         if (_addressToUint256(approvedAddress) != 0) {
1739             delete _tokenApprovals[tokenId];
1740         }
1741 
1742         // Underflow of the sender's balance is impossible because we check for
1743         // ownership above and the recipient's balance can't realistically overflow.
1744         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1745         unchecked {
1746             // Updates:
1747             // - `balance -= 1`.
1748             // - `numberBurned += 1`.
1749             //
1750             // We can directly decrement the balance, and increment the number burned.
1751             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1752             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1753 
1754             // Updates:
1755             // - `address` to the last owner.
1756             // - `startTimestamp` to the timestamp of burning.
1757             // - `burned` to `true`.
1758             // - `nextInitialized` to `true`.
1759             _packedOwnerships[tokenId] =
1760                 _addressToUint256(from) |
1761                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1762                 BITMASK_BURNED |
1763                 BITMASK_NEXT_INITIALIZED;
1764 
1765             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1766             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1767                 uint256 nextTokenId = tokenId + 1;
1768                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1769                 if (_packedOwnerships[nextTokenId] == 0) {
1770                     // If the next slot is within bounds.
1771                     if (nextTokenId != _currentIndex) {
1772                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1773                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1774                     }
1775                 }
1776             }
1777         }
1778 
1779         emit Transfer(from, address(0), tokenId);
1780         _afterTokenTransfers(from, address(0), tokenId, 1);
1781 
1782         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1783         unchecked {
1784             _burnCounter++;
1785         }
1786     }
1787 
1788     /**
1789      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1790      *
1791      * @param from address representing the previous owner of the given token ID
1792      * @param to target address that will receive the tokens
1793      * @param tokenId uint256 ID of the token to be transferred
1794      * @param _data bytes optional data to send along with the call
1795      * @return bool whether the call correctly returned the expected magic value
1796      */
1797     function _checkContractOnERC721Received(
1798         address from,
1799         address to,
1800         uint256 tokenId,
1801         bytes memory _data
1802     ) private returns (bool) {
1803         try
1804             ERC721A__IERC721Receiver(to).onERC721Received(
1805                 _msgSenderERC721A(),
1806                 from,
1807                 tokenId,
1808                 _data
1809             )
1810         returns (bytes4 retval) {
1811             return
1812                 retval ==
1813                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1814         } catch (bytes memory reason) {
1815             if (reason.length == 0) {
1816                 revert TransferToNonERC721ReceiverImplementer();
1817             } else {
1818                 assembly {
1819                     revert(add(32, reason), mload(reason))
1820                 }
1821             }
1822         }
1823     }
1824 
1825     /**
1826      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1827      * And also called before burning one token.
1828      *
1829      * startTokenId - the first token id to be transferred
1830      * quantity - the amount to be transferred
1831      *
1832      * Calling conditions:
1833      *
1834      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1835      * transferred to `to`.
1836      * - When `from` is zero, `tokenId` will be minted for `to`.
1837      * - When `to` is zero, `tokenId` will be burned by `from`.
1838      * - `from` and `to` are never both zero.
1839      */
1840     function _beforeTokenTransfers(
1841         address from,
1842         address to,
1843         uint256 startTokenId,
1844         uint256 quantity
1845     ) internal virtual {}
1846 
1847     /**
1848      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1849      * minting.
1850      * And also called after one token has been burned.
1851      *
1852      * startTokenId - the first token id to be transferred
1853      * quantity - the amount to be transferred
1854      *
1855      * Calling conditions:
1856      *
1857      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1858      * transferred to `to`.
1859      * - When `from` is zero, `tokenId` has been minted for `to`.
1860      * - When `to` is zero, `tokenId` has been burned by `from`.
1861      * - `from` and `to` are never both zero.
1862      */
1863     function _afterTokenTransfers(
1864         address from,
1865         address to,
1866         uint256 startTokenId,
1867         uint256 quantity
1868     ) internal virtual {}
1869 
1870     /**
1871      * @dev Returns the message sender (defaults to `msg.sender`).
1872      *
1873      * If you are writing GSN compatible contracts, you need to override this function.
1874      */
1875     function _msgSenderERC721A() internal view virtual returns (address) {
1876         return msg.sender;
1877     }
1878 
1879     /**
1880      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1881      */
1882     function _toString(uint256 value)
1883         internal
1884         pure
1885         returns (string memory ptr)
1886     {
1887         assembly {
1888             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1889             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1890             // We will need 1 32-byte word to store the length,
1891             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1892             ptr := add(mload(0x40), 128)
1893             // Update the free memory pointer to allocate.
1894             mstore(0x40, ptr)
1895 
1896             // Cache the end of the memory to calculate the length later.
1897             let end := ptr
1898 
1899             // We write the string from the rightmost digit to the leftmost digit.
1900             // The following is essentially a do-while loop that also handles the zero case.
1901             // Costs a bit more than early returning for the zero case,
1902             // but cheaper in terms of deployment and overall runtime costs.
1903             for {
1904                 // Initialize and perform the first pass without check.
1905                 let temp := value
1906                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1907                 ptr := sub(ptr, 1)
1908                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1909                 mstore8(ptr, add(48, mod(temp, 10)))
1910                 temp := div(temp, 10)
1911             } temp {
1912                 // Keep dividing `temp` until zero.
1913                 temp := div(temp, 10)
1914             } {
1915                 // Body of the for loop.
1916                 ptr := sub(ptr, 1)
1917                 mstore8(ptr, add(48, mod(temp, 10)))
1918             }
1919 
1920             let length := sub(end, ptr)
1921             // Move the pointer 32 bytes leftwards to make room for the length.
1922             ptr := sub(ptr, 32)
1923             // Store the length.
1924             mstore(ptr, length)
1925         }
1926     }
1927 }
1928 
1929 // File: nft-ne-fu2/contracts/NFT.sol
1930 
1931 
1932 
1933 pragma solidity ^0.8.4;
1934 
1935 
1936 
1937 
1938 
1939 
1940 contract NFT is ERC721A, Ownable, Pause, ERC20Recovery, Init {
1941     mapping(address => bool) mintWhitelist;
1942     mapping(address => bool) giveawayWhitelist;
1943     mapping(address => uint256) mintedFree;
1944     uint256 public maxSupply;
1945     uint256 public preMintPrice;
1946     uint256 public pubMintPrice;
1947     uint256 public maxMintAmount; // max allowed to mint
1948     uint256 public freeMintAmount;
1949     uint256 public giveawayAmountPerUser;
1950     uint256 public preMintStart;
1951     uint256 public publicMintStart;
1952     uint256 public publicMintEnd;
1953     bool public revealed = false;
1954     string public notRevealedUri;
1955     string public baseURI;
1956     string public baseExtension = ".json";
1957 
1958     constructor() Init(false) {}
1959 
1960     function initialize(
1961         string memory _name,
1962         string memory _symbol,
1963         string memory _notRevealedUri,
1964         uint256 _maxMintAmount,
1965         uint256 _freeMintAmount,
1966         uint256 _giveawayAmountPerUser,
1967         uint256 _preMintPrice,
1968         uint256 _pubMintPrice,
1969         uint256 _maxSupply,
1970         uint256 _preMintStart,
1971         uint256 _publicMintStart,
1972         uint256 _publicMintEnd
1973     ) external onlyOwner isNotInitialized {
1974         __ERC721A_Init(_name, _symbol);
1975         notRevealedUri = _notRevealedUri;
1976         maxMintAmount = _maxMintAmount;
1977         preMintPrice = _preMintPrice;
1978         pubMintPrice = _pubMintPrice;
1979         maxSupply = _maxSupply;
1980         freeMintAmount = _freeMintAmount;
1981         giveawayAmountPerUser = _giveawayAmountPerUser;
1982         preMintStart = _preMintStart;
1983         publicMintStart = _publicMintStart;
1984         publicMintEnd = _publicMintEnd;
1985     }
1986 
1987     // ================== modifier ==================
1988 
1989     modifier mintActive() {
1990         require(
1991             block.timestamp >= preMintStart ||
1992                 block.timestamp >= publicMintStart,
1993             "Minting is not active yet"
1994         );
1995         require(block.timestamp <= publicMintEnd, "Minting ended");
1996         _;
1997     }
1998 
1999     // ================== public functions ==================
2000 
2001     function mint(address _to, uint256 _amount)
2002         external
2003         payable
2004         whenNotPaused
2005         isInitialized
2006         mintActive
2007     {
2008         require(
2009             _amount > 0 && _amount <= maxMintAmount,
2010             "Invalid mint amount!"
2011         );
2012         require(totalSupply() + _amount <= maxSupply, "Max supply exceeded!");
2013         require(
2014             balanceOf(msg.sender) + _amount <= maxMintAmount,
2015             "Max mint per wallet exceeded!"
2016         );
2017 
2018         if (block.timestamp <= publicMintStart)
2019             require(mintWhitelist[msg.sender], "Sender not whitelisted");
2020 
2021         uint256 amountToPay;
2022         bool isPreMint = block.timestamp >= preMintStart &&
2023             block.timestamp <= publicMintStart;
2024 
2025         amountToPay = _amount * (isPreMint ? preMintPrice : pubMintPrice);
2026 
2027         require(
2028             msg.value >= amountToPay || msg.sender == owner(),
2029             "Not enough ETH to pay for minting"
2030         );
2031 
2032         _safeMint(_to, _amount);
2033     }
2034 
2035     function claim(uint256 _amount)
2036         external
2037         payable
2038         whenNotPaused
2039         isInitialized
2040     {
2041         require(
2042             block.timestamp >= preMintStart &&
2043                 block.timestamp < publicMintStart,
2044             "Claiming is not active"
2045         );
2046         require(
2047             _amount > 0 && _amount <= freeMintAmount,
2048             "Invalid mint amount!"
2049         );
2050         require(totalSupply() + _amount <= maxSupply, "Max supply exceeded!");
2051         require(
2052             mintedFree[msg.sender] + _amount <= giveawayAmountPerUser,
2053             "Free mint per wallet exceeded!"
2054         );
2055         require(giveawayWhitelist[msg.sender], "Sender not whitelisted");
2056 
2057         freeMintAmount -= _amount;
2058         mintedFree[msg.sender] += _amount;
2059 
2060         _safeMint(msg.sender, _amount);
2061     }
2062 
2063     //todo: implement giveaway mint
2064 
2065     function mintOwner(address _to, uint256 _amount)
2066         external
2067         whenNotPaused
2068         isInitialized
2069         onlyOwner
2070     {
2071         require(_amount > 0, "Invalid mint amount!");
2072         require(totalSupply() + _amount <= maxSupply, "Max supply exceeded!");
2073         _safeMint(_to, _amount);
2074     }
2075 
2076     function burn(uint256 _tokenId) external {
2077         require(
2078             ownerOf(_tokenId) == msg.sender,
2079             "Sender is nor owner of this token"
2080         );
2081         _burn(_tokenId);
2082     }
2083 
2084     // ================== internal functions ==================
2085 
2086     function _setBaseURI(string memory _baseUri) internal {
2087         baseURI = _baseUri;
2088         emit BaseURIChanged(_baseUri);
2089     }
2090 
2091     function _baseURI() internal view virtual override returns (string memory) {
2092         return baseURI;
2093     }
2094 
2095     // ================== view functions ==================
2096 
2097     function tokenURI(uint256 tokenId)
2098         public
2099         view
2100         virtual
2101         override
2102         returns (string memory)
2103     {
2104         require(
2105             _exists(tokenId),
2106             "ERC721Metadata: URI query for nonexistent token"
2107         );
2108 
2109         if (revealed == false) {
2110             return notRevealedUri;
2111         }
2112 
2113         string memory currentBaseURI = _baseURI();
2114         return
2115             bytes(currentBaseURI).length > 0
2116                 ? string(
2117                     abi.encodePacked(
2118                         currentBaseURI,
2119                         _toString(tokenId),
2120                         baseExtension
2121                     )
2122                 )
2123                 : "";
2124     }
2125 
2126     // ================== owner functions ==================
2127 
2128     function setFreeMintAmount(uint256 _freeMintAmount)
2129         external
2130         onlyOwner
2131         isNotInitialized
2132     {
2133         freeMintAmount = _freeMintAmount;
2134         emit FreeMintAmountChanged(_freeMintAmount);
2135     }
2136 
2137     function reveal(string memory _baseUri) external onlyOwner {
2138         _setBaseURI(_baseUri);
2139         setRevealed(true);
2140     }
2141 
2142     function setBaseURI(string memory _baseUri) external onlyOwner {
2143         _setBaseURI(_baseUri);
2144     }
2145 
2146     function addManyToMintWhitelist(address[] memory _addresses)
2147         external
2148         onlyOwner
2149     {
2150         for (uint256 i = 0; i < _addresses.length; i++) {
2151             addToMintWhitelist(_addresses[i]);
2152         }
2153     }
2154 
2155     function removeManyFromMintWhitelist(address[] memory _addresses)
2156         external
2157         onlyOwner
2158     {
2159         for (uint256 i = 0; i < _addresses.length; i++) {
2160             removeFromMintWhitelist(_addresses[i]);
2161         }
2162     }
2163 
2164     function addToMintWhitelist(address _toAdd) public onlyOwner {
2165         mintWhitelist[_toAdd] = true;
2166         emit AddedToMintWhitelist(_toAdd);
2167     }
2168 
2169     function removeFromMintWhitelist(address _toRemove) public onlyOwner {
2170         mintWhitelist[_toRemove] = false;
2171         emit RemovedFromMintWhitelist(_toRemove);
2172     }
2173 
2174     function isWhitelistedMint(address _toCheck) external view returns (bool) {
2175         return mintWhitelist[_toCheck];
2176     }
2177 
2178     function addManyToGiveawayWhitelist(address[] memory _addresses)
2179         external
2180         onlyOwner
2181     {
2182         for (uint256 i = 0; i < _addresses.length; i++) {
2183             addToGiveawayWhitelist(_addresses[i]);
2184         }
2185     }
2186 
2187     function removeManyFromGiveawayWhitelist(address[] memory _addresses)
2188         external
2189         onlyOwner
2190     {
2191         for (uint256 i = 0; i < _addresses.length; i++) {
2192             removeFromGiveawayWhitelist(_addresses[i]);
2193         }
2194     }
2195 
2196     function addToGiveawayWhitelist(address _toAdd) public onlyOwner {
2197         giveawayWhitelist[_toAdd] = true;
2198         emit AddedToGiveawayWhitelist(_toAdd);
2199     }
2200 
2201     function removeFromGiveawayWhitelist(address _toRemove) public onlyOwner {
2202         giveawayWhitelist[_toRemove] = false;
2203         emit RemovedFromGiveawayWhitelist(_toRemove);
2204     }
2205 
2206     function isWhitelistedGiveaway(address _toCheck)
2207         external
2208         view
2209         returns (bool)
2210     {
2211         return giveawayWhitelist[_toCheck];
2212     }
2213 
2214     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
2215         require(
2216             _maxSupply >= totalSupply(),
2217             "Max supply must be equal or greater than totalSupply"
2218         );
2219         maxSupply = _maxSupply;
2220 
2221         emit MaxSupplySet(maxSupply);
2222     }
2223 
2224     function setMaxMintAmount(uint256 _maxMintAmount) external onlyOwner {
2225         require(_maxMintAmount > 0, "Max mint amount must be greater than 0");
2226         maxMintAmount = _maxMintAmount;
2227 
2228         emit MaxMintAmountSet(maxMintAmount);
2229     }
2230 
2231     function setRevealed(bool _revealed) public onlyOwner {
2232         revealed = _revealed;
2233 
2234         emit RevealedSet(revealed);
2235     }
2236 
2237     function setPreMintStart(uint256 _preMintStart) external onlyOwner {
2238         require(_preMintStart > 0, "Pre-mint start must be greater than 0");
2239         preMintStart = _preMintStart;
2240 
2241         emit PreMintStartSet(preMintStart);
2242     }
2243 
2244     function setPublicMintStart(uint256 _publicMintStart) external onlyOwner {
2245         require(
2246             _publicMintStart > 0 && _publicMintStart >= preMintStart,
2247             "Public mint start must be greater than 0"
2248         );
2249         publicMintStart = _publicMintStart;
2250 
2251         emit PublicMintStartSet(publicMintStart);
2252     }
2253 
2254     function setPublicMintEnd(uint256 _publicMintEnd) external onlyOwner {
2255         require(
2256             _publicMintEnd > 0 && _publicMintEnd > publicMintStart,
2257             "Public mint end must be greater than 0"
2258         );
2259         publicMintEnd = _publicMintEnd;
2260 
2261         emit PublicMintEndSet(publicMintEnd);
2262     }
2263 
2264     function setPreMintPrice(uint256 _price) external onlyOwner {
2265         require(_price > 0, "Price must be greater than 0");
2266         preMintPrice = _price;
2267 
2268         emit PreMintPriceSet(_price);
2269     }
2270 
2271     function setPublicMintPrice(uint256 _price) external onlyOwner {
2272         require(_price > 0, "Price must be greater than 0");
2273         pubMintPrice = _price;
2274 
2275         emit PublicMintPriceSet(_price);
2276     }
2277 
2278     function setGiveawayAmountPerUser(uint256 _giveawayAmountPerUser)
2279         external
2280         onlyOwner
2281     {
2282         giveawayAmountPerUser = _giveawayAmountPerUser;
2283 
2284         emit GiveawayAmountPerUserSet(giveawayAmountPerUser);
2285     }
2286 
2287     function withdraw() public onlyOwner {
2288         (bool success, ) = payable(owner()).call{value: address(this).balance}(
2289             ""
2290         );
2291         require(success);
2292     }
2293     
2294  	function getInfo(address _account) external view returns(
2295         bool canMint, uint256 price, uint256 amount, bool canClaim, uint256 claimAmount) {
2296             if(block.timestamp >= preMintStart || block.timestamp >= publicMintStart) {
2297                 if(block.timestamp >= preMintStart && block.timestamp < publicMintStart) {
2298                     if(mintWhitelist[_account]) {
2299                         if(balanceOf(_account) >= maxMintAmount) {
2300                             amount = 0;
2301                             canMint = false;
2302                             price = 0;
2303                         } else {
2304                             amount = maxMintAmount - balanceOf(_account);
2305                             canMint = true;
2306                             price = preMintPrice;
2307                         }
2308                     } else {
2309                         canMint = false;
2310                         price = 0;
2311                         amount = 0;
2312                     }
2313                     if(giveawayWhitelist[_account] && freeMintAmount > 0) {
2314                         if(mintedFree[_account] >= giveawayAmountPerUser) {
2315                             canClaim = false;
2316                             claimAmount = 0;
2317                         } else {
2318                             canClaim = true;
2319                             claimAmount = giveawayAmountPerUser - mintedFree[_account];
2320                             if(claimAmount > freeMintAmount) {
2321                                 claimAmount = freeMintAmount;
2322                                 if(claimAmount == 0) canClaim = false;
2323                             }
2324                         }
2325                     } else {
2326                         canClaim = false;
2327                         claimAmount = 0;
2328                     }
2329                 } else {
2330                     if(balanceOf(_account) >= maxMintAmount) {
2331                         amount = 0;
2332                         canMint = false;
2333                         price = 0;
2334                         canClaim = false;
2335                         claimAmount = 0;
2336                         
2337                     } else {
2338                         amount = maxMintAmount - balanceOf(_account);
2339                         canMint = true;
2340                         price = pubMintPrice;
2341                         canClaim = false;
2342                         claimAmount = 0;
2343                     }
2344                 }
2345             } else {
2346                 canMint = false; 
2347                 price = 0;
2348                 amount = 0;
2349                 canClaim = false;
2350                 claimAmount = 0;
2351             }
2352     }
2353 
2354 
2355     // ================== abstract implementations  ==================
2356 
2357     function isOwner() internal view override returns (bool) {
2358         return msg.sender == owner();
2359     }
2360 
2361     // ================== events ==================
2362 
2363     event MaxSupplySet(uint256 newMaxSupply);
2364     event AddedToMintWhitelist(address newWhitelist);
2365     event RemovedFromMintWhitelist(address removedWhitelist);
2366     event AddedToGiveawayWhitelist(address newWhitelist);
2367     event RemovedFromGiveawayWhitelist(address removedWhitelist);
2368     event MaxMintAmountSet(uint256 newMaxMintAmount);
2369     event RevealedSet(bool newRevealed);
2370     event BaseURIChanged(string newBaseURI);
2371     event FreeMintAmountChanged(uint256 newFreeMintAmount);
2372     event PreMintStartSet(uint256 newPreMintStart);
2373     event PublicMintStartSet(uint256 newPublicMintStart);
2374     event PublicMintEndSet(uint256 newPublicMintEnd);
2375     event PreMintPriceSet(uint256 newPresalePrice);
2376     event PublicMintPriceSet(uint256 newPublicSalePrice);
2377     event GiveawayAmountPerUserSet(uint256 newFreeMintAmount);
2378 }