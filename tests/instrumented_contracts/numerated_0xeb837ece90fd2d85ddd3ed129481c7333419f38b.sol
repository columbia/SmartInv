1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Address.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(isContract(target), "Address: delegate call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
200      * revert reason using the provided one.
201      *
202      * _Available since v4.3._
203      */
204     function verifyCallResult(
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal pure returns (bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215 
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/Context.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes calldata) {
250         return msg.data;
251     }
252 }
253 
254 // File: @openzeppelin/contracts/access/Ownable.sol
255 
256 
257 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * By default, the owner account will be the one that deploys the contract. This
268  * can later be changed with {transferOwnership}.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 abstract contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor() {
283         _transferOwnership(_msgSender());
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view virtual returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
298         _;
299     }
300 
301     /**
302      * @dev Leaves the contract without owner. It will not be possible to call
303      * `onlyOwner` functions anymore. Can only be called by the current owner.
304      *
305      * NOTE: Renouncing ownership will leave the contract without an owner,
306      * thereby removing any functionality that is only available to the owner.
307      */
308     function renounceOwnership() public virtual onlyOwner {
309         _transferOwnership(address(0));
310     }
311 
312     /**
313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
314      * Can only be called by the current owner.
315      */
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(newOwner != address(0), "Ownable: new owner is the zero address");
318         _transferOwnership(newOwner);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Internal function without access restriction.
324      */
325     function _transferOwnership(address newOwner) internal virtual {
326         address oldOwner = _owner;
327         _owner = newOwner;
328         emit OwnershipTransferred(oldOwner, newOwner);
329     }
330 }
331 
332 // File: @openzeppelin/contracts/security/Pausable.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 
340 /**
341  * @dev Contract module which allows children to implement an emergency stop
342  * mechanism that can be triggered by an authorized account.
343  *
344  * This module is used through inheritance. It will make available the
345  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
346  * the functions of your contract. Note that they will not be pausable by
347  * simply including this module, only once the modifiers are put in place.
348  */
349 abstract contract Pausable is Context {
350     /**
351      * @dev Emitted when the pause is triggered by `account`.
352      */
353     event Paused(address account);
354 
355     /**
356      * @dev Emitted when the pause is lifted by `account`.
357      */
358     event Unpaused(address account);
359 
360     bool private _paused;
361 
362     /**
363      * @dev Initializes the contract in unpaused state.
364      */
365     constructor() {
366         _paused = false;
367     }
368 
369     /**
370      * @dev Returns true if the contract is paused, and false otherwise.
371      */
372     function paused() public view virtual returns (bool) {
373         return _paused;
374     }
375 
376     /**
377      * @dev Modifier to make a function callable only when the contract is not paused.
378      *
379      * Requirements:
380      *
381      * - The contract must not be paused.
382      */
383     modifier whenNotPaused() {
384         require(!paused(), "Pausable: paused");
385         _;
386     }
387 
388     /**
389      * @dev Modifier to make a function callable only when the contract is paused.
390      *
391      * Requirements:
392      *
393      * - The contract must be paused.
394      */
395     modifier whenPaused() {
396         require(paused(), "Pausable: not paused");
397         _;
398     }
399 
400     /**
401      * @dev Triggers stopped state.
402      *
403      * Requirements:
404      *
405      * - The contract must not be paused.
406      */
407     function _pause() internal virtual whenNotPaused {
408         _paused = true;
409         emit Paused(_msgSender());
410     }
411 
412     /**
413      * @dev Returns to normal state.
414      *
415      * Requirements:
416      *
417      * - The contract must be paused.
418      */
419     function _unpause() internal virtual whenPaused {
420         _paused = false;
421         emit Unpaused(_msgSender());
422     }
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
426 
427 
428 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Interface of the ERC20 standard as defined in the EIP.
434  */
435 interface IERC20 {
436     /**
437      * @dev Returns the amount of tokens in existence.
438      */
439     function totalSupply() external view returns (uint256);
440 
441     /**
442      * @dev Returns the amount of tokens owned by `account`.
443      */
444     function balanceOf(address account) external view returns (uint256);
445 
446     /**
447      * @dev Moves `amount` tokens from the caller's account to `to`.
448      *
449      * Returns a boolean value indicating whether the operation succeeded.
450      *
451      * Emits a {Transfer} event.
452      */
453     function transfer(address to, uint256 amount) external returns (bool);
454 
455     /**
456      * @dev Returns the remaining number of tokens that `spender` will be
457      * allowed to spend on behalf of `owner` through {transferFrom}. This is
458      * zero by default.
459      *
460      * This value changes when {approve} or {transferFrom} are called.
461      */
462     function allowance(address owner, address spender) external view returns (uint256);
463 
464     /**
465      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
466      *
467      * Returns a boolean value indicating whether the operation succeeded.
468      *
469      * IMPORTANT: Beware that changing an allowance with this method brings the risk
470      * that someone may use both the old and the new allowance by unfortunate
471      * transaction ordering. One possible solution to mitigate this race
472      * condition is to first reduce the spender's allowance to 0 and set the
473      * desired value afterwards:
474      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
475      *
476      * Emits an {Approval} event.
477      */
478     function approve(address spender, uint256 amount) external returns (bool);
479 
480     /**
481      * @dev Moves `amount` tokens from `from` to `to` using the
482      * allowance mechanism. `amount` is then deducted from the caller's
483      * allowance.
484      *
485      * Returns a boolean value indicating whether the operation succeeded.
486      *
487      * Emits a {Transfer} event.
488      */
489     function transferFrom(
490         address from,
491         address to,
492         uint256 amount
493     ) external returns (bool);
494 
495     /**
496      * @dev Emitted when `value` tokens are moved from one account (`from`) to
497      * another (`to`).
498      *
499      * Note that `value` may be zero.
500      */
501     event Transfer(address indexed from, address indexed to, uint256 value);
502 
503     /**
504      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
505      * a call to {approve}. `value` is the new allowance.
506      */
507     event Approval(address indexed owner, address indexed spender, uint256 value);
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 
519 /**
520  * @title SafeERC20
521  * @dev Wrappers around ERC20 operations that throw on failure (when the token
522  * contract returns false). Tokens that return no value (and instead revert or
523  * throw on failure) are also supported, non-reverting calls are assumed to be
524  * successful.
525  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
526  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
527  */
528 library SafeERC20 {
529     using Address for address;
530 
531     function safeTransfer(
532         IERC20 token,
533         address to,
534         uint256 value
535     ) internal {
536         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
537     }
538 
539     function safeTransferFrom(
540         IERC20 token,
541         address from,
542         address to,
543         uint256 value
544     ) internal {
545         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
546     }
547 
548     /**
549      * @dev Deprecated. This function has issues similar to the ones found in
550      * {IERC20-approve}, and its usage is discouraged.
551      *
552      * Whenever possible, use {safeIncreaseAllowance} and
553      * {safeDecreaseAllowance} instead.
554      */
555     function safeApprove(
556         IERC20 token,
557         address spender,
558         uint256 value
559     ) internal {
560         // safeApprove should only be called when setting an initial allowance,
561         // or when resetting it to zero. To increase and decrease it, use
562         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
563         require(
564             (value == 0) || (token.allowance(address(this), spender) == 0),
565             "SafeERC20: approve from non-zero to non-zero allowance"
566         );
567         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
568     }
569 
570     function safeIncreaseAllowance(
571         IERC20 token,
572         address spender,
573         uint256 value
574     ) internal {
575         uint256 newAllowance = token.allowance(address(this), spender) + value;
576         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
577     }
578 
579     function safeDecreaseAllowance(
580         IERC20 token,
581         address spender,
582         uint256 value
583     ) internal {
584         unchecked {
585             uint256 oldAllowance = token.allowance(address(this), spender);
586             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
587             uint256 newAllowance = oldAllowance - value;
588             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
589         }
590     }
591 
592     /**
593      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
594      * on the return value: the return value is optional (but if data is returned, it must not be false).
595      * @param token The token targeted by the call.
596      * @param data The call data (encoded using abi.encode or one of its variants).
597      */
598     function _callOptionalReturn(IERC20 token, bytes memory data) private {
599         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
600         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
601         // the target address contains contract code and also asserts for success in the low-level call.
602 
603         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
604         if (returndata.length > 0) {
605             // Return data is optional
606             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
607         }
608     }
609 }
610 
611 // File: @openzeppelin/contracts/token/ERC20/utils/TokenTimelock.sol
612 
613 
614 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/utils/TokenTimelock.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 
619 /**
620  * @dev A token holder contract that will allow a beneficiary to extract the
621  * tokens after a given release time.
622  *
623  * Useful for simple vesting schedules like "advisors get all of their tokens
624  * after 1 year".
625  */
626 contract TokenTimelock {
627     using SafeERC20 for IERC20;
628 
629     // ERC20 basic token contract being held
630     IERC20 private immutable _token;
631 
632     // beneficiary of tokens after they are released
633     address private immutable _beneficiary;
634 
635     // timestamp when token release is enabled
636     uint256 private immutable _releaseTime;
637 
638     /**
639      * @dev Deploys a timelock instance that is able to hold the token specified, and will only release it to
640      * `beneficiary_` when {release} is invoked after `releaseTime_`. The release time is specified as a Unix timestamp
641      * (in seconds).
642      */
643     constructor(
644         IERC20 token_,
645         address beneficiary_,
646         uint256 releaseTime_
647     ) {
648         require(releaseTime_ > block.timestamp, "TokenTimelock: release time is before current time");
649         _token = token_;
650         _beneficiary = beneficiary_;
651         _releaseTime = releaseTime_;
652     }
653 
654     /**
655      * @dev Returns the token being held.
656      */
657     function token() public view virtual returns (IERC20) {
658         return _token;
659     }
660 
661     /**
662      * @dev Returns the beneficiary that will receive the tokens.
663      */
664     function beneficiary() public view virtual returns (address) {
665         return _beneficiary;
666     }
667 
668     /**
669      * @dev Returns the time when the tokens are released in seconds since Unix epoch (i.e. Unix timestamp).
670      */
671     function releaseTime() public view virtual returns (uint256) {
672         return _releaseTime;
673     }
674 
675     /**
676      * @dev Transfers tokens held by the timelock to the beneficiary. Will only succeed if invoked after the release
677      * time.
678      */
679     function release() public virtual {
680         require(block.timestamp >= releaseTime(), "TokenTimelock: current time is before release time");
681 
682         uint256 amount = token().balanceOf(address(this));
683         require(amount > 0, "TokenTimelock: no tokens to release");
684 
685         token().safeTransfer(beneficiary(), amount);
686     }
687 }
688 
689 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @dev Interface for the optional metadata functions from the ERC20 standard.
699  *
700  * _Available since v4.1._
701  */
702 interface IERC20Metadata is IERC20 {
703     /**
704      * @dev Returns the name of the token.
705      */
706     function name() external view returns (string memory);
707 
708     /**
709      * @dev Returns the symbol of the token.
710      */
711     function symbol() external view returns (string memory);
712 
713     /**
714      * @dev Returns the decimals places of the token.
715      */
716     function decimals() external view returns (uint8);
717 }
718 
719 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
720 
721 
722 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 
727 
728 
729 /**
730  * @dev Implementation of the {IERC20} interface.
731  *
732  * This implementation is agnostic to the way tokens are created. This means
733  * that a supply mechanism has to be added in a derived contract using {_mint}.
734  * For a generic mechanism see {ERC20PresetMinterPauser}.
735  *
736  * TIP: For a detailed writeup see our guide
737  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
738  * to implement supply mechanisms].
739  *
740  * We have followed general OpenZeppelin Contracts guidelines: functions revert
741  * instead returning `false` on failure. This behavior is nonetheless
742  * conventional and does not conflict with the expectations of ERC20
743  * applications.
744  *
745  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
746  * This allows applications to reconstruct the allowance for all accounts just
747  * by listening to said events. Other implementations of the EIP may not emit
748  * these events, as it isn't required by the specification.
749  *
750  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
751  * functions have been added to mitigate the well-known issues around setting
752  * allowances. See {IERC20-approve}.
753  */
754 contract ERC20 is Context, IERC20, IERC20Metadata {
755     mapping(address => uint256) private _balances;
756 
757     mapping(address => mapping(address => uint256)) private _allowances;
758 
759     uint256 private _totalSupply;
760 
761     string private _name;
762     string private _symbol;
763 
764     /**
765      * @dev Sets the values for {name} and {symbol}.
766      *
767      * The default value of {decimals} is 18. To select a different value for
768      * {decimals} you should overload it.
769      *
770      * All two of these values are immutable: they can only be set once during
771      * construction.
772      */
773     constructor(string memory name_, string memory symbol_) {
774         _name = name_;
775         _symbol = symbol_;
776     }
777 
778     /**
779      * @dev Returns the name of the token.
780      */
781     function name() public view virtual override returns (string memory) {
782         return _name;
783     }
784 
785     /**
786      * @dev Returns the symbol of the token, usually a shorter version of the
787      * name.
788      */
789     function symbol() public view virtual override returns (string memory) {
790         return _symbol;
791     }
792 
793     /**
794      * @dev Returns the number of decimals used to get its user representation.
795      * For example, if `decimals` equals `2`, a balance of `505` tokens should
796      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
797      *
798      * Tokens usually opt for a value of 18, imitating the relationship between
799      * Ether and Wei. This is the value {ERC20} uses, unless this function is
800      * overridden;
801      *
802      * NOTE: This information is only used for _display_ purposes: it in
803      * no way affects any of the arithmetic of the contract, including
804      * {IERC20-balanceOf} and {IERC20-transfer}.
805      */
806     function decimals() public view virtual override returns (uint8) {
807         return 18;
808     }
809 
810     /**
811      * @dev See {IERC20-totalSupply}.
812      */
813     function totalSupply() public view virtual override returns (uint256) {
814         return _totalSupply;
815     }
816 
817     /**
818      * @dev See {IERC20-balanceOf}.
819      */
820     function balanceOf(address account) public view virtual override returns (uint256) {
821         return _balances[account];
822     }
823 
824     /**
825      * @dev See {IERC20-transfer}.
826      *
827      * Requirements:
828      *
829      * - `to` cannot be the zero address.
830      * - the caller must have a balance of at least `amount`.
831      */
832     function transfer(address to, uint256 amount) public virtual override returns (bool) {
833         address owner = _msgSender();
834         _transfer(owner, to, amount);
835         return true;
836     }
837 
838     /**
839      * @dev See {IERC20-allowance}.
840      */
841     function allowance(address owner, address spender) public view virtual override returns (uint256) {
842         return _allowances[owner][spender];
843     }
844 
845     /**
846      * @dev See {IERC20-approve}.
847      *
848      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
849      * `transferFrom`. This is semantically equivalent to an infinite approval.
850      *
851      * Requirements:
852      *
853      * - `spender` cannot be the zero address.
854      */
855     function approve(address spender, uint256 amount) public virtual override returns (bool) {
856         address owner = _msgSender();
857         _approve(owner, spender, amount);
858         return true;
859     }
860 
861     /**
862      * @dev See {IERC20-transferFrom}.
863      *
864      * Emits an {Approval} event indicating the updated allowance. This is not
865      * required by the EIP. See the note at the beginning of {ERC20}.
866      *
867      * NOTE: Does not update the allowance if the current allowance
868      * is the maximum `uint256`.
869      *
870      * Requirements:
871      *
872      * - `from` and `to` cannot be the zero address.
873      * - `from` must have a balance of at least `amount`.
874      * - the caller must have allowance for ``from``'s tokens of at least
875      * `amount`.
876      */
877     function transferFrom(
878         address from,
879         address to,
880         uint256 amount
881     ) public virtual override returns (bool) {
882         address spender = _msgSender();
883         _spendAllowance(from, spender, amount);
884         _transfer(from, to, amount);
885         return true;
886     }
887 
888     /**
889      * @dev Atomically increases the allowance granted to `spender` by the caller.
890      *
891      * This is an alternative to {approve} that can be used as a mitigation for
892      * problems described in {IERC20-approve}.
893      *
894      * Emits an {Approval} event indicating the updated allowance.
895      *
896      * Requirements:
897      *
898      * - `spender` cannot be the zero address.
899      */
900     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
901         address owner = _msgSender();
902         _approve(owner, spender, _allowances[owner][spender] + addedValue);
903         return true;
904     }
905 
906     /**
907      * @dev Atomically decreases the allowance granted to `spender` by the caller.
908      *
909      * This is an alternative to {approve} that can be used as a mitigation for
910      * problems described in {IERC20-approve}.
911      *
912      * Emits an {Approval} event indicating the updated allowance.
913      *
914      * Requirements:
915      *
916      * - `spender` cannot be the zero address.
917      * - `spender` must have allowance for the caller of at least
918      * `subtractedValue`.
919      */
920     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
921         address owner = _msgSender();
922         uint256 currentAllowance = _allowances[owner][spender];
923         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
924         unchecked {
925             _approve(owner, spender, currentAllowance - subtractedValue);
926         }
927 
928         return true;
929     }
930 
931     /**
932      * @dev Moves `amount` of tokens from `sender` to `recipient`.
933      *
934      * This internal function is equivalent to {transfer}, and can be used to
935      * e.g. implement automatic token fees, slashing mechanisms, etc.
936      *
937      * Emits a {Transfer} event.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `from` must have a balance of at least `amount`.
944      */
945     function _transfer(
946         address from,
947         address to,
948         uint256 amount
949     ) internal virtual {
950         require(from != address(0), "ERC20: transfer from the zero address");
951         require(to != address(0), "ERC20: transfer to the zero address");
952 
953         _beforeTokenTransfer(from, to, amount);
954 
955         uint256 fromBalance = _balances[from];
956         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
957         unchecked {
958             _balances[from] = fromBalance - amount;
959         }
960         _balances[to] += amount;
961 
962         emit Transfer(from, to, amount);
963 
964         _afterTokenTransfer(from, to, amount);
965     }
966 
967     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
968      * the total supply.
969      *
970      * Emits a {Transfer} event with `from` set to the zero address.
971      *
972      * Requirements:
973      *
974      * - `account` cannot be the zero address.
975      */
976     function _mint(address account, uint256 amount) internal virtual {
977         require(account != address(0), "ERC20: mint to the zero address");
978 
979         _beforeTokenTransfer(address(0), account, amount);
980 
981         _totalSupply += amount;
982         _balances[account] += amount;
983         emit Transfer(address(0), account, amount);
984 
985         _afterTokenTransfer(address(0), account, amount);
986     }
987 
988     /**
989      * @dev Destroys `amount` tokens from `account`, reducing the
990      * total supply.
991      *
992      * Emits a {Transfer} event with `to` set to the zero address.
993      *
994      * Requirements:
995      *
996      * - `account` cannot be the zero address.
997      * - `account` must have at least `amount` tokens.
998      */
999     function _burn(address account, uint256 amount) internal virtual {
1000         require(account != address(0), "ERC20: burn from the zero address");
1001 
1002         _beforeTokenTransfer(account, address(0), amount);
1003 
1004         uint256 accountBalance = _balances[account];
1005         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1006         unchecked {
1007             _balances[account] = accountBalance - amount;
1008         }
1009         _totalSupply -= amount;
1010 
1011         emit Transfer(account, address(0), amount);
1012 
1013         _afterTokenTransfer(account, address(0), amount);
1014     }
1015 
1016     /**
1017      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1018      *
1019      * This internal function is equivalent to `approve`, and can be used to
1020      * e.g. set automatic allowances for certain subsystems, etc.
1021      *
1022      * Emits an {Approval} event.
1023      *
1024      * Requirements:
1025      *
1026      * - `owner` cannot be the zero address.
1027      * - `spender` cannot be the zero address.
1028      */
1029     function _approve(
1030         address owner,
1031         address spender,
1032         uint256 amount
1033     ) internal virtual {
1034         require(owner != address(0), "ERC20: approve from the zero address");
1035         require(spender != address(0), "ERC20: approve to the zero address");
1036 
1037         _allowances[owner][spender] = amount;
1038         emit Approval(owner, spender, amount);
1039     }
1040 
1041     /**
1042      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1043      *
1044      * Does not update the allowance amount in case of infinite allowance.
1045      * Revert if not enough allowance is available.
1046      *
1047      * Might emit an {Approval} event.
1048      */
1049     function _spendAllowance(
1050         address owner,
1051         address spender,
1052         uint256 amount
1053     ) internal virtual {
1054         uint256 currentAllowance = allowance(owner, spender);
1055         if (currentAllowance != type(uint256).max) {
1056             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1057             unchecked {
1058                 _approve(owner, spender, currentAllowance - amount);
1059             }
1060         }
1061     }
1062 
1063     /**
1064      * @dev Hook that is called before any transfer of tokens. This includes
1065      * minting and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1070      * will be transferred to `to`.
1071      * - when `from` is zero, `amount` tokens will be minted for `to`.
1072      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1073      * - `from` and `to` are never both zero.
1074      *
1075      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1076      */
1077     function _beforeTokenTransfer(
1078         address from,
1079         address to,
1080         uint256 amount
1081     ) internal virtual {}
1082 
1083     /**
1084      * @dev Hook that is called after any transfer of tokens. This includes
1085      * minting and burning.
1086      *
1087      * Calling conditions:
1088      *
1089      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1090      * has been transferred to `to`.
1091      * - when `from` is zero, `amount` tokens have been minted for `to`.
1092      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1093      * - `from` and `to` are never both zero.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _afterTokenTransfer(
1098         address from,
1099         address to,
1100         uint256 amount
1101     ) internal virtual {}
1102 }
1103 
1104 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
1105 
1106 
1107 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Pausable.sol)
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 
1112 
1113 /**
1114  * @dev ERC20 token with pausable token transfers, minting and burning.
1115  *
1116  * Useful for scenarios such as preventing trades until the end of an evaluation
1117  * period, or having an emergency switch for freezing all token transfers in the
1118  * event of a large bug.
1119  */
1120 abstract contract ERC20Pausable is ERC20, Pausable {
1121     /**
1122      * @dev See {ERC20-_beforeTokenTransfer}.
1123      *
1124      * Requirements:
1125      *
1126      * - the contract must not be paused.
1127      */
1128     function _beforeTokenTransfer(
1129         address from,
1130         address to,
1131         uint256 amount
1132     ) internal virtual override {
1133         super._beforeTokenTransfer(from, to, amount);
1134 
1135         require(!paused(), "ERC20Pausable: token transfer while paused");
1136     }
1137 }
1138 
1139 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1140 
1141 
1142 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1143 
1144 pragma solidity ^0.8.0;
1145 
1146 
1147 
1148 /**
1149  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1150  * tokens and those that they have an allowance for, in a way that can be
1151  * recognized off-chain (via event analysis).
1152  */
1153 abstract contract ERC20Burnable is Context, ERC20 {
1154     /**
1155      * @dev Destroys `amount` tokens from the caller.
1156      *
1157      * See {ERC20-_burn}.
1158      */
1159     function burn(uint256 amount) public virtual {
1160         _burn(_msgSender(), amount);
1161     }
1162 
1163     /**
1164      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1165      * allowance.
1166      *
1167      * See {ERC20-_burn} and {ERC20-allowance}.
1168      *
1169      * Requirements:
1170      *
1171      * - the caller must have allowance for ``accounts``'s tokens of at least
1172      * `amount`.
1173      */
1174     function burnFrom(address account, uint256 amount) public virtual {
1175         _spendAllowance(account, _msgSender(), amount);
1176         _burn(account, amount);
1177     }
1178 }
1179 
1180 // File: contracts/ROL.sol
1181 
1182 
1183 pragma solidity ^0.8.0;
1184 
1185 
1186 
1187 
1188 
1189 
1190 
1191 contract ROL is ERC20, ERC20Burnable, ERC20Pausable, Ownable{
1192     mapping (address => bool) public frozenAccount;
1193 
1194     event Freeze(address indexed holder);
1195     event Unfreeze(address indexed holder);
1196 
1197     modifier notFrozen(address _holder) {
1198         require(!frozenAccount[_holder]);
1199         _;
1200     }
1201 
1202     constructor(uint256 initialSupply) ERC20("Rims Of Legend", "ROL"){
1203         _mint(msg.sender, initialSupply);
1204     }
1205     
1206     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) {
1207         super._beforeTokenTransfer(from, to, amount);
1208     }
1209 
1210     function mint(address to, uint256 amount) public onlyOwner {
1211          _mint(to, amount);
1212     }
1213 
1214     function transfer(address to, uint256 value) public notFrozen(msg.sender) override returns (bool) {
1215         return super.transfer(to, value);
1216     }
1217 
1218     function transferFrom(address from, address to, uint256 value) public notFrozen(from) override returns (bool) {
1219         return super.transferFrom(from, to, value);
1220     }
1221 
1222     function freezeAccount(address holder) public onlyOwner returns (bool) {
1223         require(!frozenAccount[holder]);
1224         frozenAccount[holder] = true;
1225         emit Freeze(holder);
1226         return true;
1227     }
1228 
1229     function unfreezeAccount(address holder) public onlyOwner returns (bool) {
1230         require(frozenAccount[holder]);
1231         frozenAccount[holder] = false;
1232         emit Unfreeze(holder);
1233         return true;
1234     }
1235 
1236     function puase() public onlyOwner {
1237         _pause();
1238     }
1239 
1240     function unpause() public onlyOwner {
1241         _unpause();
1242     }
1243 
1244 }