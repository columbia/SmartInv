1 // Sources flattened with hardhat v2.11.1 https://hardhat.org
2 
3 // File contracts/Ownable.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.16;
8 
9 abstract contract Ownable {
10 
11     error Unauthorized();
12     error ZeroAddress();
13 
14     event OwnerSet(address indexed newOwner_);
15     event PendingOwnerSet(address indexed pendingOwner_);
16 
17     address public owner;
18     address public pendingOwner;
19 
20     modifier onlyOwner() {
21         if (msg.sender != owner) revert Unauthorized();
22 
23         _;
24     }
25 
26     function setPendingOwner(address pendingOwner_) external onlyOwner {
27         _setPendingOwner(pendingOwner_);
28     }
29 
30     function acceptOwnership() external {
31         if (msg.sender != pendingOwner) revert Unauthorized();
32 
33         _setPendingOwner(address(0));
34         _setOwner(msg.sender);
35     }
36 
37     function _setOwner(address owner_) internal {
38         if (owner_ == address(0)) revert ZeroAddress();
39 
40         emit OwnerSet(owner = owner_);
41     }
42 
43     function _setPendingOwner(address pendingOwner_) internal {
44         emit PendingOwnerSet(pendingOwner = pendingOwner_);
45     }
46 
47 }
48 
49 
50 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
51 
52 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev Interface of the ERC20 standard as defined in the EIP.
58  */
59 interface IERC20 {
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 
74     /**
75      * @dev Returns the amount of tokens in existence.
76      */
77     function totalSupply() external view returns (uint256);
78 
79     /**
80      * @dev Returns the amount of tokens owned by `account`.
81      */
82     function balanceOf(address account) external view returns (uint256);
83 
84     /**
85      * @dev Moves `amount` tokens from the caller's account to `to`.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transfer(address to, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Returns the remaining number of tokens that `spender` will be
95      * allowed to spend on behalf of `owner` through {transferFrom}. This is
96      * zero by default.
97      *
98      * This value changes when {approve} or {transferFrom} are called.
99      */
100     function allowance(address owner, address spender) external view returns (uint256);
101 
102     /**
103      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * IMPORTANT: Beware that changing an allowance with this method brings the risk
108      * that someone may use both the old and the new allowance by unfortunate
109      * transaction ordering. One possible solution to mitigate this race
110      * condition is to first reduce the spender's allowance to 0 and set the
111      * desired value afterwards:
112      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address spender, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Moves `amount` tokens from `from` to `to` using the
120      * allowance mechanism. `amount` is then deducted from the caller's
121      * allowance.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transferFrom(
128         address from,
129         address to,
130         uint256 amount
131     ) external returns (bool);
132 }
133 
134 
135 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.3
136 
137 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
143  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
144  *
145  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
146  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
147  * need to send a transaction, and thus is not required to hold Ether at all.
148  */
149 interface IERC20Permit {
150     /**
151      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
152      * given ``owner``'s signed approval.
153      *
154      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
155      * ordering also apply here.
156      *
157      * Emits an {Approval} event.
158      *
159      * Requirements:
160      *
161      * - `spender` cannot be the zero address.
162      * - `deadline` must be a timestamp in the future.
163      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
164      * over the EIP712-formatted function arguments.
165      * - the signature must use ``owner``'s current nonce (see {nonces}).
166      *
167      * For more information on the signature format, see the
168      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
169      * section].
170      */
171     function permit(
172         address owner,
173         address spender,
174         uint256 value,
175         uint256 deadline,
176         uint8 v,
177         bytes32 r,
178         bytes32 s
179     ) external;
180 
181     /**
182      * @dev Returns the current nonce for `owner`. This value must be
183      * included whenever a signature is generated for {permit}.
184      *
185      * Every successful call to {permit} increases ``owner``'s nonce by one. This
186      * prevents a signature from being used multiple times.
187      */
188     function nonces(address owner) external view returns (uint256);
189 
190     /**
191      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
192      */
193     // solhint-disable-next-line func-name-mixedcase
194     function DOMAIN_SEPARATOR() external view returns (bytes32);
195 }
196 
197 
198 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
199 
200 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
201 
202 pragma solidity ^0.8.1;
203 
204 /**
205  * @dev Collection of functions related to the address type
206  */
207 library Address {
208     /**
209      * @dev Returns true if `account` is a contract.
210      *
211      * [IMPORTANT]
212      * ====
213      * It is unsafe to assume that an address for which this function returns
214      * false is an externally-owned account (EOA) and not a contract.
215      *
216      * Among others, `isContract` will return false for the following
217      * types of addresses:
218      *
219      *  - an externally-owned account
220      *  - a contract in construction
221      *  - an address where a contract will be created
222      *  - an address where a contract lived, but was destroyed
223      * ====
224      *
225      * [IMPORTANT]
226      * ====
227      * You shouldn't rely on `isContract` to protect against flash loan attacks!
228      *
229      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
230      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
231      * constructor.
232      * ====
233      */
234     function isContract(address account) internal view returns (bool) {
235         // This method relies on extcodesize/address.code.length, which returns 0
236         // for contracts in construction, since the code is only stored at the end
237         // of the constructor execution.
238 
239         return account.code.length > 0;
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      */
258     function sendValue(address payable recipient, uint256 amount) internal {
259         require(address(this).balance >= amount, "Address: insufficient balance");
260 
261         (bool success, ) = recipient.call{value: amount}("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 
265     /**
266      * @dev Performs a Solidity function call using a low level `call`. A
267      * plain `call` is an unsafe replacement for a function call: use this
268      * function instead.
269      *
270      * If `target` reverts with a revert reason, it is bubbled up by this
271      * function (like regular Solidity function calls).
272      *
273      * Returns the raw returned data. To convert to the expected return value,
274      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
275      *
276      * Requirements:
277      *
278      * - `target` must be a contract.
279      * - calling `target` with `data` must not revert.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionCall(target, data, "Address: low-level call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
289      * `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, 0, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but also transferring `value` wei to `target`.
304      *
305      * Requirements:
306      *
307      * - the calling contract must have an ETH balance of at least `value`.
308      * - the called Solidity function must be `payable`.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         require(isContract(target), "Address: call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.call{value: value}(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
346         return functionStaticCall(target, data, "Address: low-level static call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal view returns (bytes memory) {
360         require(isContract(target), "Address: static call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.staticcall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
395      * revert reason using the provided one.
396      *
397      * _Available since v4.3._
398      */
399     function verifyCallResult(
400         bool success,
401         bytes memory returndata,
402         string memory errorMessage
403     ) internal pure returns (bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410                 /// @solidity memory-safe-assembly
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 
423 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.3
424 
425 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 
430 
431 /**
432  * @title SafeERC20
433  * @dev Wrappers around ERC20 operations that throw on failure (when the token
434  * contract returns false). Tokens that return no value (and instead revert or
435  * throw on failure) are also supported, non-reverting calls are assumed to be
436  * successful.
437  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
438  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
439  */
440 library SafeERC20 {
441     using Address for address;
442 
443     function safeTransfer(
444         IERC20 token,
445         address to,
446         uint256 value
447     ) internal {
448         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
449     }
450 
451     function safeTransferFrom(
452         IERC20 token,
453         address from,
454         address to,
455         uint256 value
456     ) internal {
457         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
458     }
459 
460     /**
461      * @dev Deprecated. This function has issues similar to the ones found in
462      * {IERC20-approve}, and its usage is discouraged.
463      *
464      * Whenever possible, use {safeIncreaseAllowance} and
465      * {safeDecreaseAllowance} instead.
466      */
467     function safeApprove(
468         IERC20 token,
469         address spender,
470         uint256 value
471     ) internal {
472         // safeApprove should only be called when setting an initial allowance,
473         // or when resetting it to zero. To increase and decrease it, use
474         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
475         require(
476             (value == 0) || (token.allowance(address(this), spender) == 0),
477             "SafeERC20: approve from non-zero to non-zero allowance"
478         );
479         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
480     }
481 
482     function safeIncreaseAllowance(
483         IERC20 token,
484         address spender,
485         uint256 value
486     ) internal {
487         uint256 newAllowance = token.allowance(address(this), spender) + value;
488         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
489     }
490 
491     function safeDecreaseAllowance(
492         IERC20 token,
493         address spender,
494         uint256 value
495     ) internal {
496         unchecked {
497             uint256 oldAllowance = token.allowance(address(this), spender);
498             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
499             uint256 newAllowance = oldAllowance - value;
500             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501         }
502     }
503 
504     function safePermit(
505         IERC20Permit token,
506         address owner,
507         address spender,
508         uint256 value,
509         uint256 deadline,
510         uint8 v,
511         bytes32 r,
512         bytes32 s
513     ) internal {
514         uint256 nonceBefore = token.nonces(owner);
515         token.permit(owner, spender, value, deadline, v, r, s);
516         uint256 nonceAfter = token.nonces(owner);
517         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
518     }
519 
520     /**
521      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
522      * on the return value: the return value is optional (but if data is returned, it must not be false).
523      * @param token The token targeted by the call.
524      * @param data The call data (encoded using abi.encode or one of its variants).
525      */
526     function _callOptionalReturn(IERC20 token, bytes memory data) private {
527         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
528         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
529         // the target address contains contract code and also asserts for success in the low-level call.
530 
531         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
532         if (returndata.length > 0) {
533             // Return data is optional
534             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
535         }
536     }
537 }
538 
539 
540 // File contracts/SwapFeeRouter.sol
541 
542 
543 pragma solidity 0.8.16;
544 
545 // NOTE: There is no non-arbitrary upper-limit for the `feeBasisPoints`, and setting it above 10_000 just pauses the swap functions.
546 
547 contract SwapFeeRouter is Ownable {
548 
549     error ETHTransferFailed(bytes errorData);
550     error FeeBasisPointsNotRespected(uint256 expectedFeeBasisPoints_, uint256 actualFeeBasisPoints_);
551     error ContractNotWhitelisted(address callee);
552     error RenterAttempted();
553     error SwapCallFailed(bytes errorData);
554 
555     event ContractAddedToWhitelist(address indexed contract_);
556     event ContractRemovedFromWhitelist(address indexed contract_);
557     event ETHPulled(address indexed destination_, uint256 amount_);
558     event FeeSet(uint256 feeBasisPoints_);
559     event TokensPulled(address indexed token_, address indexed destination_, uint256 amount_);
560 
561     uint256 internal _locked = 1;
562 
563     uint256 public feeBasisPoints;  // 1 = 0.01%, 100 = 1%, 10_000 = 100%
564 
565     mapping(address => bool) public isWhitelisted;
566 
567     constructor(address owner_, uint256 feeBasisPoints_, address[] memory whitelist_) {
568         _setOwner(owner_);
569         _setFees(feeBasisPoints_);
570         _addToWhitelist(whitelist_);
571     }
572 
573     modifier noRenter() {
574         if (_locked == 2) revert RenterAttempted();
575 
576         _locked = 2;
577 
578         _;
579 
580         _locked = 1;
581     }
582 
583     modifier feeBasisPointsRespected(uint256 feeBasisPoints_) {
584         // Revert if the expected fee is less than the current fee.
585         if (feeBasisPoints_ < feeBasisPoints) revert FeeBasisPointsNotRespected(feeBasisPoints_, feeBasisPoints);
586 
587         _;
588     }
589 
590     function swapWithFeesOnInput(
591         address inAsset_,
592         uint256 swapAmount_,
593         uint256 feeBasisPoints_,
594         address swapContract_,
595         address tokenPuller_,
596         bytes calldata swapCallData_
597     ) public noRenter feeBasisPointsRespected(feeBasisPoints_) {
598         // Pull funds plus fees from caller.
599         // NOTE: Assuming `swapCallData_` is correct, fees will remain in this contract.
600         // NOTE: Worst case, assuming `swapCallData_` is incorrect/malicious, this contract loses nothing, but gains nothing.
601         SafeERC20.safeTransferFrom(IERC20(inAsset_), msg.sender, address(this), getAmountWithFees(swapAmount_, feeBasisPoints));
602 
603         // Perform the swap (set allowance, swap, unset allowance).
604         // NOTE: This assume that the `swapCallData_` instructs the swapContract to send outAsset to correct destination.
605         _performSwap(inAsset_, swapAmount_, swapContract_, tokenPuller_, swapCallData_);
606     }
607 
608     function swapWithFeesOnOutput(
609         address inAsset_,
610         uint256 swapAmount_,
611         address outAsset_,
612         uint256 feeBasisPoints_,
613         address swapContract_,
614         address tokenPuller_,
615         bytes calldata swapCallData_
616     ) external noRenter feeBasisPointsRespected(feeBasisPoints_) {
617         // Track this contract's starting outAsset balance to determine its increase later.
618         uint256 startingOutAssetBalance = IERC20(outAsset_).balanceOf(address(this));
619 
620         // Pull funds from caller.
621         SafeERC20.safeTransferFrom(IERC20(inAsset_), msg.sender, address(this), swapAmount_);
622 
623         // Perform the swap (set allowance, swap, unset allowance).
624         // NOTE: This assume that the `swapCallData_` instructs the swapContract to send outAsset to this contract.
625         _performSwap(inAsset_, swapAmount_, swapContract_, tokenPuller_, swapCallData_);
626 
627         // Send the amount of outAsset the swap produced, minus fees, to the destination.
628         SafeERC20.safeTransfer(
629             IERC20(outAsset_),
630             msg.sender,
631             getAmountWithoutFees(
632                 IERC20(outAsset_).balanceOf(address(this)) - startingOutAssetBalance,
633                 feeBasisPoints
634             )
635         );
636     }
637 
638     function swapFromEthWithFeesOnInput(
639         uint256 feeBasisPoints_,
640         address swapContract_,
641         bytes calldata swapCallData_
642     ) external payable noRenter feeBasisPointsRespected(feeBasisPoints_) {
643         // Perform the swap (attaching ETH minus fees to call).
644         // NOTE: This assume that the `swapCallData_` instructs the swapContract to send outAsset to correct destination.
645         _performSwap(getAmountWithoutFees(msg.value, feeBasisPoints), swapContract_, swapCallData_);
646     }
647 
648     function swapFromEthWithFeesOnOutput(
649         address outAsset_,
650         uint256 feeBasisPoints_,
651         address swapContract_,
652         bytes calldata swapCallData_
653     ) external payable noRenter feeBasisPointsRespected(feeBasisPoints_) {
654         // Track this contract's starting outAsset balance to determine its increase later.
655         uint256 startingOutAssetBalance = IERC20(outAsset_).balanceOf(address(this));
656 
657         // Perform the swap (attaching ETH to call).
658         // NOTE: This assume that the `swapCallData_` instructs the swapContract to send outAsset to this contract.
659         _performSwap(msg.value, swapContract_, swapCallData_);
660 
661         // Send the amount of outAsset the swap produced, minus fees, to the destination.
662         SafeERC20.safeTransfer(
663             IERC20(outAsset_),
664             msg.sender,
665             getAmountWithoutFees(
666                 IERC20(outAsset_).balanceOf(address(this)) - startingOutAssetBalance,
667                 feeBasisPoints
668             )
669         );
670     }
671 
672     function swapToEthWithFeesOnInput(
673         address inAsset_,
674         uint256 swapAmount_,
675         uint256 feeBasisPoints_,
676         address swapContract_,
677         address tokenPuller_,
678         bytes calldata swapCallData_
679     ) external feeBasisPointsRespected(feeBasisPoints_) {
680         // NOTE: Ths is functionally the same as `swapWithFeesOnInput` since the output is irrelevant.
681         // NOTE: No `noRenter` needed since `swapWithFeesOnInput` will check that.
682         swapWithFeesOnInput(inAsset_, swapAmount_, feeBasisPoints_, swapContract_, tokenPuller_, swapCallData_);
683     }
684 
685     function swapToEthWithFeesOnOutput(
686         address inAsset_,
687         uint256 swapAmount_,
688         uint256 feeBasisPoints_,
689         address swapContract_,
690         address tokenPuller_,
691         bytes calldata swapCallData_
692     ) external noRenter feeBasisPointsRespected(feeBasisPoints_) {
693         // Track this contract's starting ETH balance to determine its increase later.
694         uint256 startingETHBalance = address(this).balance;
695 
696         // Pull funds from caller.
697         SafeERC20.safeTransferFrom(IERC20(inAsset_), msg.sender, address(this), swapAmount_);
698 
699         // Perform the swap (set allowance, swap, unset allowance).
700         // NOTE: This assume that the `swapCallData_` instructs the swapContract to send ETH to this contract.
701         _performSwap(inAsset_, swapAmount_, swapContract_, tokenPuller_, swapCallData_);
702 
703         // Send the amount of ETH the swap produced, minus fees, to the destination, and revert if it fails.
704         _transferETH(
705             msg.sender,
706             getAmountWithoutFees(
707                 address(this).balance - startingETHBalance,
708                 feeBasisPoints
709             )
710         );
711     }
712 
713     function addToWhitelist(address[] calldata whitelist_) external onlyOwner {
714         _addToWhitelist(whitelist_);
715     }
716 
717     function removeFromWhitelist(address[] calldata whitelist_) external onlyOwner {
718         _removeFromWhitelist(whitelist_);
719     }
720 
721     function setFee(uint256 feeBasisPoints_) external onlyOwner {
722         _setFees(feeBasisPoints_);
723     }
724 
725     function pullToken(address token_, address destination_) public onlyOwner {
726         if (destination_ == address(0)) revert ZeroAddress();
727 
728         uint256 amount = IERC20(token_).balanceOf(address(this));
729 
730         emit TokensPulled(token_, destination_, amount);
731 
732         SafeERC20.safeTransfer(IERC20(token_), destination_, amount);
733     }
734 
735     function pullTokens(address[] calldata tokens_, address destination_) external onlyOwner {
736         for (uint256 i; i < tokens_.length; ++i) {
737             pullToken(tokens_[i], destination_);
738         }
739     }
740 
741     function pullETH(address destination_) external onlyOwner {
742         if (destination_ == address(0)) revert ZeroAddress();
743 
744         uint256 amount = address(this).balance;
745 
746         emit ETHPulled(destination_, amount);
747 
748         _transferETH(destination_, amount);
749     }
750 
751     function getAmountWithFees(uint256 amountWithoutFees_, uint256 feeBasisPoints_) public pure returns (uint256 amountWithFees_) {
752         amountWithFees_ = (amountWithoutFees_ * (10_000 + feeBasisPoints_)) / 10_000;
753     }
754 
755     function getAmountWithoutFees(uint256 amountWithFees_, uint256 feeBasisPoints_) public pure returns (uint256 amountWithoutFees_) {
756         amountWithoutFees_ = (10_000 * amountWithFees_) / (10_000 + feeBasisPoints_);
757     }
758 
759     function _addToWhitelist(address[] memory whitelist_) internal {
760         for (uint256 i; i < whitelist_.length; ++i) {
761             address account = whitelist_[i];
762             isWhitelisted[whitelist_[i]] = true;
763             emit ContractAddedToWhitelist(account);
764         }
765     }
766 
767     function _performSwap(address inAsset_, uint256 swapAmount_, address swapContract_, address tokenPuller_, bytes calldata swapCallData_) internal {
768         // Prevent calling contracts that are not whitelisted.
769         if (!isWhitelisted[swapContract_]) revert ContractNotWhitelisted(swapContract_);
770 
771         // Approve the contract that will pull inAsset.
772         IERC20(inAsset_).approve(tokenPuller_, swapAmount_);
773 
774         // Call the swap contract as defined by `swapCallData_`, and revert if it fails.
775         ( bool success, bytes memory errorData ) = swapContract_.call(swapCallData_);
776         if (!success) revert SwapCallFailed(errorData);
777 
778         // Un-approve the contract that pulled inAsset.
779         // NOTE: This is important to prevent exploits that rely on allowances to arbitrary swapContracts to be non-zero after swap calls.
780         IERC20(inAsset_).approve(tokenPuller_, 0);
781     }
782 
783     function _performSwap(uint256 swapAmount_, address swapContract_, bytes calldata swapCallData_) internal {
784         // Prevent calling contracts that are not whitelisted.
785         if (!isWhitelisted[swapContract_]) revert ContractNotWhitelisted(swapContract_);
786 
787         // Call the swap contract as defined by `swapCallData_`, and revert if it fails.
788         ( bool success, bytes memory errorData ) = swapContract_.call{ value: swapAmount_ }(swapCallData_);
789         if (!success) revert SwapCallFailed(errorData);
790     }
791 
792     function _removeFromWhitelist(address[] memory whitelist_) internal {
793         for (uint256 i; i < whitelist_.length; ++i) {
794             address account = whitelist_[i];
795             isWhitelisted[whitelist_[i]] = false;
796             emit ContractRemovedFromWhitelist(account);
797         }
798     }
799 
800     function _setFees(uint256 feeBasisPoints_) internal {
801         emit FeeSet(feeBasisPoints = feeBasisPoints_);
802     }
803 
804     function _transferETH(address destination_, uint256 amount_) internal {
805         // NOTE: callers of this function are validating `destination_` to not be zero.
806         ( bool success, bytes memory errorData ) = destination_.call{ value: amount_ }("");
807         if (!success) revert ETHTransferFailed(errorData);
808     }
809 
810     receive() external payable {}
811 
812 }