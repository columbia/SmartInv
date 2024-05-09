1 // SPDX-License-Identifier: MIT
2 
3 // FULL PROTEC EGGS AT ALL COST.
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 // File: @openzeppelin/contracts/utils/Address.sol
116 
117 
118 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
119 
120 pragma solidity ^0.8.1;
121 
122 /**
123  * @dev Collection of functions related to the address type
124  */
125 library Address {
126     /**
127      * @dev Returns true if `account` is a contract.
128      *
129      * [IMPORTANT]
130      * ====
131      * It is unsafe to assume that an address for which this function returns
132      * false is an externally-owned account (EOA) and not a contract.
133      *
134      * Among others, `isContract` will return false for the following
135      * types of addresses:
136      *
137      *  - an externally-owned account
138      *  - a contract in construction
139      *  - an address where a contract will be created
140      *  - an address where a contract lived, but was destroyed
141      * ====
142      *
143      * [IMPORTANT]
144      * ====
145      * You shouldn't rely on `isContract` to protect against flash loan attacks!
146      *
147      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
148      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
149      * constructor.
150      * ====
151      */
152     function isContract(address account) internal view returns (bool) {
153         // This method relies on extcodesize/address.code.length, which returns 0
154         // for contracts in construction, since the code is only stored at the end
155         // of the constructor execution.
156 
157         return account.code.length > 0;
158     }
159 
160     /**
161      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
162      * `recipient`, forwarding all available gas and reverting on errors.
163      *
164      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
165      * of certain opcodes, possibly making contracts go over the 2300 gas limit
166      * imposed by `transfer`, making them unable to receive funds via
167      * `transfer`. {sendValue} removes this limitation.
168      *
169      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
170      *
171      * IMPORTANT: because control is transferred to `recipient`, care must be
172      * taken to not create reentrancy vulnerabilities. Consider using
173      * {ReentrancyGuard} or the
174      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
175      */
176     function sendValue(address payable recipient, uint256 amount) internal {
177         require(address(this).balance >= amount, "Address: insufficient balance");
178 
179         (bool success, ) = recipient.call{value: amount}("");
180         require(success, "Address: unable to send value, recipient may have reverted");
181     }
182 
183     /**
184      * @dev Performs a Solidity function call using a low level `call`. A
185      * plain `call` is an unsafe replacement for a function call: use this
186      * function instead.
187      *
188      * If `target` reverts with a revert reason, it is bubbled up by this
189      * function (like regular Solidity function calls).
190      *
191      * Returns the raw returned data. To convert to the expected return value,
192      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
193      *
194      * Requirements:
195      *
196      * - `target` must be a contract.
197      * - calling `target` with `data` must not revert.
198      *
199      * _Available since v3.1._
200      */
201     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
207      * `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCall(
212         address target,
213         bytes memory data,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         return functionCallWithValue(target, data, 0, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but also transferring `value` wei to `target`.
222      *
223      * Requirements:
224      *
225      * - the calling contract must have an ETH balance of at least `value`.
226      * - the called Solidity function must be `payable`.
227      *
228      * _Available since v3.1._
229      */
230     function functionCallWithValue(
231         address target,
232         bytes memory data,
233         uint256 value
234     ) internal returns (bytes memory) {
235         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
240      * with `errorMessage` as a fallback revert reason when `target` reverts.
241      *
242      * _Available since v3.1._
243      */
244     function functionCallWithValue(
245         address target,
246         bytes memory data,
247         uint256 value,
248         string memory errorMessage
249     ) internal returns (bytes memory) {
250         require(address(this).balance >= value, "Address: insufficient balance for call");
251         (bool success, bytes memory returndata) = target.call{value: value}(data);
252         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
262         return functionStaticCall(target, data, "Address: low-level static call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a static call.
268      *
269      * _Available since v3.3._
270      */
271     function functionStaticCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal view returns (bytes memory) {
276         (bool success, bytes memory returndata) = target.staticcall(data);
277         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a delegate call.
293      *
294      * _Available since v3.4._
295      */
296     function functionDelegateCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         (bool success, bytes memory returndata) = target.delegatecall(data);
302         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
307      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
308      *
309      * _Available since v4.8._
310      */
311     function verifyCallResultFromTarget(
312         address target,
313         bool success,
314         bytes memory returndata,
315         string memory errorMessage
316     ) internal view returns (bytes memory) {
317         if (success) {
318             if (returndata.length == 0) {
319                 // only check isContract if the call was successful and the return data is empty
320                 // otherwise we already know that it was a contract
321                 require(isContract(target), "Address: call to non-contract");
322             }
323             return returndata;
324         } else {
325             _revert(returndata, errorMessage);
326         }
327     }
328 
329     /**
330      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
331      * revert reason or using the provided one.
332      *
333      * _Available since v4.3._
334      */
335     function verifyCallResult(
336         bool success,
337         bytes memory returndata,
338         string memory errorMessage
339     ) internal pure returns (bytes memory) {
340         if (success) {
341             return returndata;
342         } else {
343             _revert(returndata, errorMessage);
344         }
345     }
346 
347     function _revert(bytes memory returndata, string memory errorMessage) private pure {
348         // Look for revert reason and bubble it up if present
349         if (returndata.length > 0) {
350             // The easiest way to bubble the revert reason is using memory via assembly
351             /// @solidity memory-safe-assembly
352             assembly {
353                 let returndata_size := mload(returndata)
354                 revert(add(32, returndata), returndata_size)
355             }
356         } else {
357             revert(errorMessage);
358         }
359     }
360 }
361 
362 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
371  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
372  *
373  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
374  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
375  * need to send a transaction, and thus is not required to hold Ether at all.
376  */
377 interface IERC20Permit {
378     /**
379      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
380      * given ``owner``'s signed approval.
381      *
382      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
383      * ordering also apply here.
384      *
385      * Emits an {Approval} event.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      * - `deadline` must be a timestamp in the future.
391      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
392      * over the EIP712-formatted function arguments.
393      * - the signature must use ``owner``'s current nonce (see {nonces}).
394      *
395      * For more information on the signature format, see the
396      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
397      * section].
398      */
399     function permit(
400         address owner,
401         address spender,
402         uint256 value,
403         uint256 deadline,
404         uint8 v,
405         bytes32 r,
406         bytes32 s
407     ) external;
408 
409     /**
410      * @dev Returns the current nonce for `owner`. This value must be
411      * included whenever a signature is generated for {permit}.
412      *
413      * Every successful call to {permit} increases ``owner``'s nonce by one. This
414      * prevents a signature from being used multiple times.
415      */
416     function nonces(address owner) external view returns (uint256);
417 
418     /**
419      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
420      */
421     // solhint-disable-next-line func-name-mixedcase
422     function DOMAIN_SEPARATOR() external view returns (bytes32);
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
426 
427 
428 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Interface of the ERC20 standard as defined in the EIP.
434  */
435 interface IERC20 {
436     /**
437      * @dev Emitted when `value` tokens are moved from one account (`from`) to
438      * another (`to`).
439      *
440      * Note that `value` may be zero.
441      */
442     event Transfer(address indexed from, address indexed to, uint256 value);
443 
444     /**
445      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
446      * a call to {approve}. `value` is the new allowance.
447      */
448     event Approval(address indexed owner, address indexed spender, uint256 value);
449 
450     /**
451      * @dev Returns the amount of tokens in existence.
452      */
453     function totalSupply() external view returns (uint256);
454 
455     /**
456      * @dev Returns the amount of tokens owned by `account`.
457      */
458     function balanceOf(address account) external view returns (uint256);
459 
460     /**
461      * @dev Moves `amount` tokens from the caller's account to `to`.
462      *
463      * Returns a boolean value indicating whether the operation succeeded.
464      *
465      * Emits a {Transfer} event.
466      */
467     function transfer(address to, uint256 amount) external returns (bool);
468 
469     /**
470      * @dev Returns the remaining number of tokens that `spender` will be
471      * allowed to spend on behalf of `owner` through {transferFrom}. This is
472      * zero by default.
473      *
474      * This value changes when {approve} or {transferFrom} are called.
475      */
476     function allowance(address owner, address spender) external view returns (uint256);
477 
478     /**
479      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
480      *
481      * Returns a boolean value indicating whether the operation succeeded.
482      *
483      * IMPORTANT: Beware that changing an allowance with this method brings the risk
484      * that someone may use both the old and the new allowance by unfortunate
485      * transaction ordering. One possible solution to mitigate this race
486      * condition is to first reduce the spender's allowance to 0 and set the
487      * desired value afterwards:
488      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
489      *
490      * Emits an {Approval} event.
491      */
492     function approve(address spender, uint256 amount) external returns (bool);
493 
494     /**
495      * @dev Moves `amount` tokens from `from` to `to` using the
496      * allowance mechanism. `amount` is then deducted from the caller's
497      * allowance.
498      *
499      * Returns a boolean value indicating whether the operation succeeded.
500      *
501      * Emits a {Transfer} event.
502      */
503     function transferFrom(
504         address from,
505         address to,
506         uint256 amount
507     ) external returns (bool);
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
511 
512 
513 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 
519 
520 /**
521  * @title SafeERC20
522  * @dev Wrappers around ERC20 operations that throw on failure (when the token
523  * contract returns false). Tokens that return no value (and instead revert or
524  * throw on failure) are also supported, non-reverting calls are assumed to be
525  * successful.
526  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
527  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
528  */
529 library SafeERC20 {
530     using Address for address;
531 
532     function safeTransfer(
533         IERC20 token,
534         address to,
535         uint256 value
536     ) internal {
537         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
538     }
539 
540     function safeTransferFrom(
541         IERC20 token,
542         address from,
543         address to,
544         uint256 value
545     ) internal {
546         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
547     }
548 
549     /**
550      * @dev Deprecated. This function has issues similar to the ones found in
551      * {IERC20-approve}, and its usage is discouraged.
552      *
553      * Whenever possible, use {safeIncreaseAllowance} and
554      * {safeDecreaseAllowance} instead.
555      */
556     function safeApprove(
557         IERC20 token,
558         address spender,
559         uint256 value
560     ) internal {
561         // safeApprove should only be called when setting an initial allowance,
562         // or when resetting it to zero. To increase and decrease it, use
563         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
564         require(
565             (value == 0) || (token.allowance(address(this), spender) == 0),
566             "SafeERC20: approve from non-zero to non-zero allowance"
567         );
568         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
569     }
570 
571     function safeIncreaseAllowance(
572         IERC20 token,
573         address spender,
574         uint256 value
575     ) internal {
576         uint256 newAllowance = token.allowance(address(this), spender) + value;
577         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
578     }
579 
580     function safeDecreaseAllowance(
581         IERC20 token,
582         address spender,
583         uint256 value
584     ) internal {
585         unchecked {
586             uint256 oldAllowance = token.allowance(address(this), spender);
587             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
588             uint256 newAllowance = oldAllowance - value;
589             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
590         }
591     }
592 
593     function safePermit(
594         IERC20Permit token,
595         address owner,
596         address spender,
597         uint256 value,
598         uint256 deadline,
599         uint8 v,
600         bytes32 r,
601         bytes32 s
602     ) internal {
603         uint256 nonceBefore = token.nonces(owner);
604         token.permit(owner, spender, value, deadline, v, r, s);
605         uint256 nonceAfter = token.nonces(owner);
606         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
607     }
608 
609     /**
610      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
611      * on the return value: the return value is optional (but if data is returned, it must not be false).
612      * @param token The token targeted by the call.
613      * @param data The call data (encoded using abi.encode or one of its variants).
614      */
615     function _callOptionalReturn(IERC20 token, bytes memory data) private {
616         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
617         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
618         // the target address contains contract code and also asserts for success in the low-level call.
619 
620         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
621         if (returndata.length > 0) {
622             // Return data is optional
623             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
624         }
625     }
626 }
627 
628 // File: contracts/EggsFullProtec.sol
629 
630 
631 pragma solidity ^0.8.0;
632 
633 interface IEggsToken {
634     function mint(address to, uint256 amount) external;
635     function totalSupply() external view returns (uint256);
636     function transferUnderlying(address to, uint256 value) external returns (bool);
637     function fragmentToEggs(uint256 value) external view returns (uint256);
638     function eggsToFragment(uint256 eggs) external view returns (uint256);
639     function balanceOfUnderlying(address who) external view returns (uint256);
640     function burn(uint256 amount) external;
641 }
642 
643 contract EggsFullProtec is Ownable {
644     using SafeERC20 for IERC20;
645 
646     struct UserInfo {
647         uint256 amount;
648         uint256 lockEndedTimestamp;
649     }
650 
651     IEggsToken public eggs;
652     uint256 public lockDuration;
653     uint256 public totalStaked;
654     bool public depositsEnabled;
655 
656     // Info of each user.
657     mapping(address => UserInfo) public userInfo;
658 
659     // Events
660     event Deposit(address indexed user, uint256 amount);
661     event Withdraw(address indexed user, uint256 amount);
662     event LogSetLockDuration(uint256 lockDuration);
663     event LogSetDepositsEnabled(bool enabled);
664 
665     constructor(IEggsToken _eggs, uint256 _lockDuration, bool _depositsEnabled) {
666         eggs = _eggs;
667         lockDuration = _lockDuration;
668         depositsEnabled = _depositsEnabled;
669     }
670 
671     function setDepositsEnabled(bool _enabled) external onlyOwner {
672         depositsEnabled = _enabled;
673         emit LogSetDepositsEnabled(_enabled);
674     }
675 
676     function setLockDuration(uint256 _lockDuration) external onlyOwner {
677       lockDuration = _lockDuration;
678       emit LogSetLockDuration(_lockDuration);
679     }
680 
681     function deposit(uint256 _amount) external {
682         require(depositsEnabled, "deposits disabled");
683         require(_amount > 0, "invalid amount");
684 
685         UserInfo storage user = userInfo[msg.sender];
686         user.lockEndedTimestamp = block.timestamp + lockDuration;
687         IERC20(address(eggs)).safeTransferFrom(address(msg.sender), address(this), _amount);
688         eggs.burn(_amount);
689 
690         totalStaked += _amount;
691         user.amount += _amount;
692         emit Deposit(msg.sender, _amount);
693     }
694 
695     function withdraw(uint256 _amount) external {
696         require(_amount > 0, "invalid amount");
697 
698         UserInfo storage user = userInfo[msg.sender];
699         require(user.lockEndedTimestamp <= block.timestamp, "still locked");
700         require(user.amount >= _amount, "invalid amount");
701 
702         user.lockEndedTimestamp = block.timestamp + lockDuration;
703         user.amount -= _amount;
704         totalStaked -= _amount;
705         eggs.mint(address(msg.sender), _amount);
706 
707         emit Withdraw(msg.sender, _amount);
708     }
709 }