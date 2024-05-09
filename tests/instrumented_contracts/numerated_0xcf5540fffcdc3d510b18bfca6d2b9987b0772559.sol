1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.8;
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         _checkOwner();
57         _;
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if the sender is not the owner.
69      */
70     function _checkOwner() internal view virtual {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
106 
107 /**
108  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
109  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
110  *
111  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
112  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
113  * need to send a transaction, and thus is not required to hold Ether at all.
114  */
115 interface IERC20Permit {
116     /**
117      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
118      * given ``owner``'s signed approval.
119      *
120      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
121      * ordering also apply here.
122      *
123      * Emits an {Approval} event.
124      *
125      * Requirements:
126      *
127      * - `spender` cannot be the zero address.
128      * - `deadline` must be a timestamp in the future.
129      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
130      * over the EIP712-formatted function arguments.
131      * - the signature must use ``owner``'s current nonce (see {nonces}).
132      *
133      * For more information on the signature format, see the
134      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
135      * section].
136      */
137     function permit(
138         address owner,
139         address spender,
140         uint256 value,
141         uint256 deadline,
142         uint8 v,
143         bytes32 r,
144         bytes32 s
145     ) external;
146 
147     /**
148      * @dev Returns the current nonce for `owner`. This value must be
149      * included whenever a signature is generated for {permit}.
150      *
151      * Every successful call to {permit} increases ``owner``'s nonce by one. This
152      * prevents a signature from being used multiple times.
153      */
154     function nonces(address owner) external view returns (uint256);
155 
156     /**
157      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
158      */
159     // solhint-disable-next-line func-name-mixedcase
160     function DOMAIN_SEPARATOR() external view returns (bytes32);
161 }
162 
163 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
164 
165 /**
166  * @dev Collection of functions related to the address type
167  */
168 library Address {
169     /**
170      * @dev Returns true if `account` is a contract.
171      *
172      * [IMPORTANT]
173      * ====
174      * It is unsafe to assume that an address for which this function returns
175      * false is an externally-owned account (EOA) and not a contract.
176      *
177      * Among others, `isContract` will return false for the following
178      * types of addresses:
179      *
180      *  - an externally-owned account
181      *  - a contract in construction
182      *  - an address where a contract will be created
183      *  - an address where a contract lived, but was destroyed
184      * ====
185      *
186      * [IMPORTANT]
187      * ====
188      * You shouldn't rely on `isContract` to protect against flash loan attacks!
189      *
190      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
191      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
192      * constructor.
193      * ====
194      */
195     function isContract(address account) internal view returns (bool) {
196         // This method relies on extcodesize/address.code.length, which returns 0
197         // for contracts in construction, since the code is only stored at the end
198         // of the constructor execution.
199 
200         return account.code.length > 0;
201     }
202 
203     /**
204      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
205      * `recipient`, forwarding all available gas and reverting on errors.
206      *
207      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
208      * of certain opcodes, possibly making contracts go over the 2300 gas limit
209      * imposed by `transfer`, making them unable to receive funds via
210      * `transfer`. {sendValue} removes this limitation.
211      *
212      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
213      *
214      * IMPORTANT: because control is transferred to `recipient`, care must be
215      * taken to not create reentrancy vulnerabilities. Consider using
216      * {ReentrancyGuard} or the
217      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
218      */
219     function sendValue(address payable recipient, uint256 amount) internal {
220         require(address(this).balance >= amount, "Address: insufficient balance");
221 
222         (bool success, ) = recipient.call{value: amount}("");
223         require(success, "Address: unable to send value, recipient may have reverted");
224     }
225 
226     /**
227      * @dev Performs a Solidity function call using a low level `call`. A
228      * plain `call` is an unsafe replacement for a function call: use this
229      * function instead.
230      *
231      * If `target` reverts with a revert reason, it is bubbled up by this
232      * function (like regular Solidity function calls).
233      *
234      * Returns the raw returned data. To convert to the expected return value,
235      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
236      *
237      * Requirements:
238      *
239      * - `target` must be a contract.
240      * - calling `target` with `data` must not revert.
241      *
242      * _Available since v3.1._
243      */
244     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
245         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
250      * `errorMessage` as a fallback revert reason when `target` reverts.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         return functionCallWithValue(target, data, 0, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but also transferring `value` wei to `target`.
265      *
266      * Requirements:
267      *
268      * - the calling contract must have an ETH balance of at least `value`.
269      * - the called Solidity function must be `payable`.
270      *
271      * _Available since v3.1._
272      */
273     function functionCallWithValue(
274         address target,
275         bytes memory data,
276         uint256 value
277     ) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
283      * with `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCallWithValue(
288         address target,
289         bytes memory data,
290         uint256 value,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         require(address(this).balance >= value, "Address: insufficient balance for call");
294         (bool success, bytes memory returndata) = target.call{value: value}(data);
295         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
305         return functionStaticCall(target, data, "Address: low-level static call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a static call.
311      *
312      * _Available since v3.3._
313      */
314     function functionStaticCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal view returns (bytes memory) {
319         (bool success, bytes memory returndata) = target.staticcall(data);
320         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a delegate call.
326      *
327      * _Available since v3.4._
328      */
329     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
330         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a delegate call.
336      *
337      * _Available since v3.4._
338      */
339     function functionDelegateCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         (bool success, bytes memory returndata) = target.delegatecall(data);
345         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
350      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
351      *
352      * _Available since v4.8._
353      */
354     function verifyCallResultFromTarget(
355         address target,
356         bool success,
357         bytes memory returndata,
358         string memory errorMessage
359     ) internal view returns (bytes memory) {
360         if (success) {
361             if (returndata.length == 0) {
362                 // only check isContract if the call was successful and the return data is empty
363                 // otherwise we already know that it was a contract
364                 require(isContract(target), "Address: call to non-contract");
365             }
366             return returndata;
367         } else {
368             _revert(returndata, errorMessage);
369         }
370     }
371 
372     /**
373      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason or using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             _revert(returndata, errorMessage);
387         }
388     }
389 
390     function _revert(bytes memory returndata, string memory errorMessage) private pure {
391         // Look for revert reason and bubble it up if present
392         if (returndata.length > 0) {
393             // The easiest way to bubble the revert reason is using memory via assembly
394             /// @solidity memory-safe-assembly
395             assembly {
396                 let returndata_size := mload(returndata)
397                 revert(add(32, returndata), returndata_size)
398             }
399         } else {
400             revert(errorMessage);
401         }
402     }
403 }
404 
405 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
406 
407 /**
408  * @title SafeERC20
409  * @dev Wrappers around ERC20 operations that throw on failure (when the token
410  * contract returns false). Tokens that return no value (and instead revert or
411  * throw on failure) are also supported, non-reverting calls are assumed to be
412  * successful.
413  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
414  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
415  */
416 library SafeERC20 {
417     using Address for address;
418 
419     function safeTransfer(
420         IERC20 token,
421         address to,
422         uint256 value
423     ) internal {
424         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
425     }
426 
427     function safeTransferFrom(
428         IERC20 token,
429         address from,
430         address to,
431         uint256 value
432     ) internal {
433         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
434     }
435 
436     /**
437      * @dev Deprecated. This function has issues similar to the ones found in
438      * {IERC20-approve}, and its usage is discouraged.
439      *
440      * Whenever possible, use {safeIncreaseAllowance} and
441      * {safeDecreaseAllowance} instead.
442      */
443     function safeApprove(
444         IERC20 token,
445         address spender,
446         uint256 value
447     ) internal {
448         // safeApprove should only be called when setting an initial allowance,
449         // or when resetting it to zero. To increase and decrease it, use
450         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
451         require(
452             (value == 0) || (token.allowance(address(this), spender) == 0),
453             "SafeERC20: approve from non-zero to non-zero allowance"
454         );
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
456     }
457 
458     function safeIncreaseAllowance(
459         IERC20 token,
460         address spender,
461         uint256 value
462     ) internal {
463         uint256 newAllowance = token.allowance(address(this), spender) + value;
464         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
465     }
466 
467     function safeDecreaseAllowance(
468         IERC20 token,
469         address spender,
470         uint256 value
471     ) internal {
472         unchecked {
473             uint256 oldAllowance = token.allowance(address(this), spender);
474             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
475             uint256 newAllowance = oldAllowance - value;
476             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
477         }
478     }
479 
480     function safePermit(
481         IERC20Permit token,
482         address owner,
483         address spender,
484         uint256 value,
485         uint256 deadline,
486         uint8 v,
487         bytes32 r,
488         bytes32 s
489     ) internal {
490         uint256 nonceBefore = token.nonces(owner);
491         token.permit(owner, spender, value, deadline, v, r, s);
492         uint256 nonceAfter = token.nonces(owner);
493         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
494     }
495 
496     /**
497      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
498      * on the return value: the return value is optional (but if data is returned, it must not be false).
499      * @param token The token targeted by the call.
500      * @param data The call data (encoded using abi.encode or one of its variants).
501      */
502     function _callOptionalReturn(IERC20 token, bytes memory data) private {
503         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
504         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
505         // the target address contains contract code and also asserts for success in the low-level call.
506 
507         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
508         if (returndata.length > 0) {
509             // Return data is optional
510             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
511         }
512     }
513 }
514 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
515 
516 /**
517  * @dev Interface of the ERC20 standard as defined in the EIP.
518  */
519 interface IERC20 {
520     /**
521      * @dev Emitted when `value` tokens are moved from one account (`from`) to
522      * another (`to`).
523      *
524      * Note that `value` may be zero.
525      */
526     event Transfer(address indexed from, address indexed to, uint256 value);
527 
528     /**
529      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
530      * a call to {approve}. `value` is the new allowance.
531      */
532     event Approval(address indexed owner, address indexed spender, uint256 value);
533 
534     /**
535      * @dev Returns the amount of tokens in existence.
536      */
537     function totalSupply() external view returns (uint256);
538 
539     /**
540      * @dev Returns the amount of tokens owned by `account`.
541      */
542     function balanceOf(address account) external view returns (uint256);
543 
544     /**
545      * @dev Moves `amount` tokens from the caller's account to `to`.
546      *
547      * Returns a boolean value indicating whether the operation succeeded.
548      *
549      * Emits a {Transfer} event.
550      */
551     function transfer(address to, uint256 amount) external returns (bool);
552 
553     /**
554      * @dev Returns the remaining number of tokens that `spender` will be
555      * allowed to spend on behalf of `owner` through {transferFrom}. This is
556      * zero by default.
557      *
558      * This value changes when {approve} or {transferFrom} are called.
559      */
560     function allowance(address owner, address spender) external view returns (uint256);
561 
562     /**
563      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
564      *
565      * Returns a boolean value indicating whether the operation succeeded.
566      *
567      * IMPORTANT: Beware that changing an allowance with this method brings the risk
568      * that someone may use both the old and the new allowance by unfortunate
569      * transaction ordering. One possible solution to mitigate this race
570      * condition is to first reduce the spender's allowance to 0 and set the
571      * desired value afterwards:
572      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
573      *
574      * Emits an {Approval} event.
575      */
576     function approve(address spender, uint256 amount) external returns (bool);
577 
578     /**
579      * @dev Moves `amount` tokens from `from` to `to` using the
580      * allowance mechanism. `amount` is then deducted from the caller's
581      * allowance.
582      *
583      * Returns a boolean value indicating whether the operation succeeded.
584      *
585      * Emits a {Transfer} event.
586      */
587     function transferFrom(
588         address from,
589         address to,
590         uint256 amount
591     ) external returns (bool);
592 }
593 
594 // https://github.com/Uniswap/permit2
595 
596 /// @title SignatureTransfer
597 /// @notice Handles ERC20 token transfers through signature based actions
598 /// @dev Requires user's token approval on the Permit2 contract
599 interface ISignatureTransfer {
600 
601     /// @notice The token and amount details for a transfer signed in the permit transfer signature
602     struct TokenPermissions {
603         // ERC20 token address
604         address token;
605         // the maximum amount that can be spent
606         uint256 amount;
607     }
608 
609     /// @notice The signed permit message for a single token transfer
610     struct PermitTransferFrom {
611         TokenPermissions permitted;
612         // a unique value for every token owner's signature to prevent signature replays
613         uint256 nonce;
614         // deadline on the permit signature
615         uint256 deadline;
616     }
617 
618     /// @notice Specifies the recipient address and amount for batched transfers.
619     /// @dev Recipients and amounts correspond to the index of the signed token permissions array.
620     /// @dev Reverts if the requested amount is greater than the permitted signed amount.
621     struct SignatureTransferDetails {
622         // recipient address
623         address to;
624         // spender requested amount
625         uint256 requestedAmount;
626     }
627 
628     /// @notice Used to reconstruct the signed permit message for multiple token transfers
629     /// @dev Do not need to pass in spender address as it is required that it is msg.sender
630     /// @dev Note that a user still signs over a spender address
631     struct PermitBatchTransferFrom {
632         // the tokens and corresponding amounts permitted for a transfer
633         TokenPermissions[] permitted;
634         // a unique value for every token owner's signature to prevent signature replays
635         uint256 nonce;
636         // deadline on the permit signature
637         uint256 deadline;
638     }
639     /// @notice Transfers a token using a signed permit message
640     /// @dev Reverts if the requested amount is greater than the permitted signed amount
641     /// @param permit The permit data signed over by the owner
642     /// @param owner The owner of the tokens to transfer
643     /// @param transferDetails The spender's requested transfer details for the permitted token
644     /// @param signature The signature to verify
645     function permitTransferFrom(
646         PermitTransferFrom memory permit,
647         SignatureTransferDetails calldata transferDetails,
648         address owner,
649         bytes calldata signature
650     ) external;
651 
652     /// @notice Transfers multiple tokens using a signed permit message
653     /// @param permit The permit data signed over by the owner
654     /// @param owner The owner of the tokens to transfer
655     /// @param transferDetails Specifies the recipient and requested amount for the token transfer
656     /// @param signature The signature to verify
657     function permitTransferFrom(
658         PermitBatchTransferFrom memory permit,
659         SignatureTransferDetails[] calldata transferDetails,
660         address owner,
661         bytes calldata signature
662     ) external;
663 }
664 
665 // @dev interface for interacting with an Odos executor
666 interface IOdosExecutor {
667   function executePath (
668     bytes calldata bytecode,
669     uint256[] memory inputAmount,
670     address msgSender
671   ) external payable;
672 }
673 
674 /// @title Routing contract for Odos SOR
675 /// @author Semiotic AI
676 /// @notice Wrapper with security gaurentees around execution of arbitrary operations on user tokens
677 contract OdosRouterV2 is Ownable {
678   using SafeERC20 for IERC20;
679 
680   /// @dev The zero address is uniquely used to represent eth since it is already
681   /// recognized as an invalid ERC20, and due to its gas efficiency
682   address constant _ETH = address(0);
683 
684   /// @dev Address list where addresses can be cached for use when reading from storage is cheaper
685   // than reading from calldata. addressListStart is the storage slot of the first dynamic array element
686   uint256 private constant addressListStart = 
687     80084422859880547211683076133703299733277748156566366325829078699459944778998;
688   address[] public addressList;
689 
690   // @dev constants for managing referrals and fees
691   uint256 public constant REFERRAL_WITH_FEE_THRESHOLD = 1 << 31;
692   uint256 public constant FEE_DENOM = 1e18;
693 
694   // @dev fee taken on multi-input and multi-output swaps instead of positive slippage
695   uint256 public swapMultiFee;
696 
697   /// @dev Contains all information needed to describe the input and output for a swap
698   struct permit2Info {
699     address contractAddress;
700     uint256 nonce;
701     uint256 deadline;
702     bytes signature;
703   }
704   /// @dev Contains all information needed to describe the input and output for a swap
705   struct swapTokenInfo {
706     address inputToken;
707     uint256 inputAmount;
708     address inputReceiver;
709     address outputToken;
710     uint256 outputQuote;
711     uint256 outputMin;
712     address outputReceiver;
713   }
714   /// @dev Contains all information needed to describe an intput token for swapMulti
715   struct inputTokenInfo {
716     address tokenAddress;
717     uint256 amountIn;
718     address receiver;
719   }
720   /// @dev Contains all information needed to describe an output token for swapMulti
721   struct outputTokenInfo {
722     address tokenAddress;
723     uint256 relativeValue;
724     address receiver;
725   }
726   // @dev event for swapping one token for another
727   event Swap(
728     address sender,
729     uint256 inputAmount,
730     address inputToken,
731     uint256 amountOut,
732     address outputToken,
733     int256 slippage,
734     uint32 referralCode
735   );
736   /// @dev event for swapping multiple input and/or output tokens
737   event SwapMulti(
738     address sender,
739     uint256[] amountsIn,
740     address[] tokensIn,
741     uint256[] amountsOut,
742     address[] tokensOut,
743     uint32 referralCode
744   );
745   /// @dev Holds all information for a given referral
746   struct referralInfo {
747     uint64 referralFee;
748     address beneficiary;
749     bool registered;
750   }
751   /// @dev Register referral fee and information
752   mapping(uint32 => referralInfo) public referralLookup;
753 
754   /// @dev Set the null referralCode as "Unregistered" with no additional fee
755   constructor() {
756     referralLookup[0].referralFee = 0;
757     referralLookup[0].beneficiary = address(0);
758     referralLookup[0].registered = true;
759 
760     swapMultiFee = 5e14;
761   }
762   /// @dev Must exist in order for contract to receive eth
763   receive() external payable { }
764 
765   /// @notice Custom decoder to swap with compact calldata for efficient execution on L2s
766   function swapCompact() 
767     external
768     payable
769     returns (uint256)
770   {
771     swapTokenInfo memory tokenInfo;
772 
773     address executor;
774     uint32 referralCode;
775     bytes calldata pathDefinition;
776     {
777       address msgSender = msg.sender;
778 
779       assembly {
780         // Define function to load in token address, either from calldata or from storage
781         function getAddress(currPos) -> result, newPos {
782           let inputPos := shr(240, calldataload(currPos))
783 
784           switch inputPos
785           // Reserve the null address as a special case that can be specified with 2 null bytes
786           case 0x0000 {
787             newPos := add(currPos, 2)
788           }
789           // This case means that the address is encoded in the calldata directly following the code
790           case 0x0001 {
791             result := and(shr(80, calldataload(currPos)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
792             newPos := add(currPos, 22)
793           }
794           // Otherwise we use the case to load in from the cached address list
795           default {
796             result := sload(add(addressListStart, sub(inputPos, 2)))
797             newPos := add(currPos, 2)
798           }
799         }
800         let result := 0
801         let pos := 4
802 
803         // Load in the input and output token addresses
804         result, pos := getAddress(pos)
805         mstore(tokenInfo, result)
806 
807         result, pos := getAddress(pos)
808         mstore(add(tokenInfo, 0x60), result)
809 
810         // Load in the input amount - a 0 byte means the full balance is to be used
811         let inputAmountLength := shr(248, calldataload(pos))
812         pos := add(pos, 1)
813 
814         if inputAmountLength {
815           mstore(add(tokenInfo, 0x20), shr(mul(sub(32, inputAmountLength), 8), calldataload(pos)))
816           pos := add(pos, inputAmountLength)
817         }
818 
819         // Load in the quoted output amount
820         let quoteAmountLength := shr(248, calldataload(pos))
821         pos := add(pos, 1)
822 
823         let outputQuote := shr(mul(sub(32, quoteAmountLength), 8), calldataload(pos))
824         mstore(add(tokenInfo, 0x80), outputQuote)
825         pos := add(pos, quoteAmountLength)
826 
827         // Load the slippage tolerance and use to get the minimum output amount
828         {
829           let slippageTolerance := shr(232, calldataload(pos))
830           mstore(add(tokenInfo, 0xA0), div(mul(outputQuote, sub(0xFFFFFF, slippageTolerance)), 0xFFFFFF))
831         }
832         pos := add(pos, 3)
833 
834         // Load in the executor address
835         executor, pos := getAddress(pos)
836 
837         // Load in the destination to send the input to - Zero denotes the executor
838         result, pos := getAddress(pos)
839         if eq(result, 0) { result := executor }
840         mstore(add(tokenInfo, 0x40), result)
841 
842         // Load in the destination to send the output to - Zero denotes msg.sender
843         result, pos := getAddress(pos)
844         if eq(result, 0) { result := msgSender }
845         mstore(add(tokenInfo, 0xC0), result)
846 
847         // Load in the referralCode
848         referralCode := shr(224, calldataload(pos))
849         pos := add(pos, 4)
850 
851         // Set the offset and size for the pathDefinition portion of the msg.data
852         pathDefinition.length := mul(shr(248, calldataload(pos)), 32)
853         pathDefinition.offset := add(pos, 1)
854       }
855     }
856     return _swapApproval(
857       tokenInfo,
858       pathDefinition,
859       executor,
860       referralCode
861     );
862   }
863   /// @notice Externally facing interface for swapping two tokens
864   /// @param tokenInfo All information about the tokens being swapped
865   /// @param pathDefinition Encoded path definition for executor
866   /// @param executor Address of contract that will execute the path
867   /// @param referralCode referral code to specify the source of the swap
868   function swap(
869     swapTokenInfo memory tokenInfo,
870     bytes calldata pathDefinition,
871     address executor,
872     uint32 referralCode
873   )
874     external
875     payable
876     returns (uint256 amountOut)
877   {
878     return _swapApproval(
879       tokenInfo,
880       pathDefinition,
881       executor,
882       referralCode
883     );
884   }
885 
886   /// @notice Internal function for initiating approval transfers
887   /// @param tokenInfo All information about the tokens being swapped
888   /// @param pathDefinition Encoded path definition for executor
889   /// @param executor Address of contract that will execute the path
890   /// @param referralCode referral code to specify the source of the swap
891   function _swapApproval(
892     swapTokenInfo memory tokenInfo,
893     bytes calldata pathDefinition,
894     address executor,
895     uint32 referralCode
896   )
897     internal
898     returns (uint256 amountOut)
899   {
900     if (tokenInfo.inputToken == _ETH) {
901       // Support rebasing tokens by allowing the user to trade the entire balance
902       if (tokenInfo.inputAmount == 0) {
903         tokenInfo.inputAmount = msg.value;
904       } else {
905         require(msg.value == tokenInfo.inputAmount, "Wrong msg.value");
906       }
907     }
908     else {
909       // Support rebasing tokens by allowing the user to trade the entire balance
910       if (tokenInfo.inputAmount == 0) {
911         tokenInfo.inputAmount = IERC20(tokenInfo.inputToken).balanceOf(msg.sender);
912       }
913       IERC20(tokenInfo.inputToken).safeTransferFrom(
914         msg.sender,
915         tokenInfo.inputReceiver,
916         tokenInfo.inputAmount
917       );
918     }
919     return _swap(
920       tokenInfo,
921       pathDefinition,
922       executor,
923       referralCode
924     );
925   }
926 
927   /// @notice Externally facing interface for swapping two tokens
928   /// @param permit2 All additional info for Permit2 transfers
929   /// @param tokenInfo All information about the tokens being swapped
930   /// @param pathDefinition Encoded path definition for executor
931   /// @param executor Address of contract that will execute the path
932   /// @param referralCode referral code to specify the source of the swap
933   function swapPermit2(
934     permit2Info memory permit2,
935     swapTokenInfo memory tokenInfo,
936     bytes calldata pathDefinition,
937     address executor,
938     uint32 referralCode
939   )
940     external
941     returns (uint256 amountOut)
942   {
943     ISignatureTransfer(permit2.contractAddress).permitTransferFrom(
944       ISignatureTransfer.PermitTransferFrom(
945         ISignatureTransfer.TokenPermissions(
946           tokenInfo.inputToken,
947           tokenInfo.inputAmount
948         ),
949         permit2.nonce,
950         permit2.deadline
951       ),
952       ISignatureTransfer.SignatureTransferDetails(
953         tokenInfo.inputReceiver,
954         tokenInfo.inputAmount
955       ),
956       msg.sender,
957       permit2.signature
958     );
959     return _swap(
960       tokenInfo,
961       pathDefinition,
962       executor,
963       referralCode
964     );
965   }
966 
967   /// @notice contains the main logic for swapping one token for another
968   /// Assumes input tokens have already been sent to their destinations and
969   /// that msg.value is set to expected ETH input value, or 0 for ERC20 input
970   /// @param tokenInfo All information about the tokens being swapped
971   /// @param pathDefinition Encoded path definition for executor
972   /// @param executor Address of contract that will execute the path
973   /// @param referralCode referral code to specify the source of the swap
974   function _swap(
975     swapTokenInfo memory tokenInfo,
976     bytes calldata pathDefinition,
977     address executor,
978     uint32 referralCode
979   )
980     internal
981     returns (uint256 amountOut)
982   {
983     // Check for valid output specifications
984     require(tokenInfo.outputMin <= tokenInfo.outputQuote, "Minimum greater than quote");
985     require(tokenInfo.outputMin > 0, "Slippage limit too low");
986     require(tokenInfo.inputToken != tokenInfo.outputToken, "Arbitrage not supported");
987 
988     uint256 balanceBefore = _universalBalance(tokenInfo.outputToken);
989 
990     // Delegate the execution of the path to the specified Odos Executor
991     uint256[] memory amountsIn = new uint256[](1);
992     amountsIn[0] = tokenInfo.inputAmount;
993 
994     IOdosExecutor(executor).executePath{value: msg.value}(pathDefinition, amountsIn, msg.sender);
995 
996     amountOut = _universalBalance(tokenInfo.outputToken) - balanceBefore;
997 
998     if (referralCode > REFERRAL_WITH_FEE_THRESHOLD) {
999       referralInfo memory thisReferralInfo = referralLookup[referralCode];
1000 
1001       _universalTransfer(
1002         tokenInfo.outputToken,
1003         thisReferralInfo.beneficiary,
1004         amountOut * thisReferralInfo.referralFee * 8 / (FEE_DENOM * 10)
1005       );
1006       amountOut = amountOut * (FEE_DENOM - thisReferralInfo.referralFee) / FEE_DENOM;
1007     }
1008     int256 slippage = int256(amountOut) - int256(tokenInfo.outputQuote);
1009     if (slippage > 0) {
1010       amountOut = tokenInfo.outputQuote;
1011     }
1012     require(amountOut >= tokenInfo.outputMin, "Slippage Limit Exceeded");
1013 
1014     // Transfer out the final output to the end user
1015     _universalTransfer(tokenInfo.outputToken, tokenInfo.outputReceiver, amountOut);
1016 
1017     emit Swap(
1018       msg.sender,
1019       tokenInfo.inputAmount,
1020       tokenInfo.inputToken,
1021       amountOut,
1022       tokenInfo.outputToken,
1023       slippage,
1024       referralCode
1025     );
1026   }
1027 
1028   /// @notice Custom decoder to swapMulti with compact calldata for efficient execution on L2s
1029   function swapMultiCompact() 
1030     external
1031     payable
1032     returns (uint256[] memory amountsOut)
1033   {
1034     address executor;
1035     uint256 valueOutMin;
1036 
1037     inputTokenInfo[] memory inputs;
1038     outputTokenInfo[] memory outputs;
1039 
1040     uint256 pos = 6;
1041     {
1042       address msgSender = msg.sender;
1043 
1044       uint256 numInputs;
1045       uint256 numOutputs;
1046 
1047       assembly {
1048         numInputs := shr(248, calldataload(4))
1049         numOutputs := shr(248, calldataload(5))
1050       }
1051       inputs = new inputTokenInfo[](numInputs);
1052       outputs = new outputTokenInfo[](numOutputs);
1053 
1054       assembly {
1055         // Define function to load in token address, either from calldata or from storage
1056         function getAddress(currPos) -> result, newPos {
1057           let inputPos := shr(240, calldataload(currPos))
1058 
1059           switch inputPos
1060           // Reserve the null address as a special case that can be specified with 2 null bytes
1061           case 0x0000 {
1062             newPos := add(currPos, 2)
1063           }
1064           // This case means that the address is encoded in the calldata directly following the code
1065           case 0x0001 {
1066             result := and(shr(80, calldataload(currPos)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1067             newPos := add(currPos, 22)
1068           }
1069           // Otherwise we use the case to load in from the cached address list
1070           default {
1071             result := sload(add(addressListStart, sub(inputPos, 2)))
1072             newPos := add(currPos, 2)
1073           }
1074         }
1075         executor, pos := getAddress(pos)
1076 
1077         // Load in the quoted output amount
1078         let outputMinAmountLength := shr(248, calldataload(pos))
1079         pos := add(pos, 1)
1080 
1081         valueOutMin := shr(mul(sub(32, outputMinAmountLength), 8), calldataload(pos))
1082         pos := add(pos, outputMinAmountLength)
1083 
1084         let result := 0
1085         let memPos := 0
1086 
1087         for { let element := 0 } lt(element, numInputs) { element := add(element, 1) }
1088         {
1089           memPos := mload(add(inputs, add(mul(element, 0x20), 0x20)))
1090 
1091           // Load in the token address
1092           result, pos := getAddress(pos)
1093           mstore(memPos, result)
1094 
1095           // Load in the input amount - a 0 byte means the full balance is to be used
1096           let inputAmountLength := shr(248, calldataload(pos))
1097           pos := add(pos, 1)
1098 
1099           if inputAmountLength {
1100              mstore(add(memPos, 0x20), shr(mul(sub(32, inputAmountLength), 8), calldataload(pos)))
1101             pos := add(pos, inputAmountLength)
1102           }
1103           result, pos := getAddress(pos)
1104           if eq(result, 0) { result := executor }
1105 
1106           mstore(add(memPos, 0x40), result)
1107         }
1108         for { let element := 0 } lt(element, numOutputs) { element := add(element, 1) }
1109         {
1110           memPos := mload(add(outputs, add(mul(element, 0x20), 0x20)))
1111 
1112           // Load in the token address
1113           result, pos := getAddress(pos)
1114           mstore(memPos, result)
1115 
1116           // Load in the quoted output amount
1117           let outputAmountLength := shr(248, calldataload(pos))
1118           pos := add(pos, 1)
1119 
1120           mstore(add(memPos, 0x20), shr(mul(sub(32, outputAmountLength), 8), calldataload(pos)))
1121           pos := add(pos, outputAmountLength)
1122 
1123           result, pos := getAddress(pos)
1124           if eq(result, 0) { result := msgSender }
1125 
1126           mstore(add(memPos, 0x40), result)
1127         }
1128       }
1129     }
1130     uint32 referralCode;
1131     bytes calldata pathDefinition;
1132 
1133     assembly {
1134       // Load in the referralCode
1135       referralCode := shr(224, calldataload(pos))
1136       pos := add(pos, 4)
1137 
1138       // Set the offset and size for the pathDefinition portion of the msg.data
1139       pathDefinition.length := mul(shr(248, calldataload(pos)), 32)
1140       pathDefinition.offset := add(pos, 1)
1141     }
1142     return _swapMultiApproval(
1143       inputs,
1144       outputs,
1145       valueOutMin,
1146       pathDefinition,
1147       executor,
1148       referralCode
1149     );
1150   }
1151 
1152   /// @notice Externally facing interface for swapping between two sets of tokens
1153   /// @param inputs list of input token structs for the path being executed
1154   /// @param outputs list of output token structs for the path being executed
1155   /// @param valueOutMin minimum amount of value out the user will accept
1156   /// @param pathDefinition Encoded path definition for executor
1157   /// @param executor Address of contract that will execute the path
1158   /// @param referralCode referral code to specify the source of the swap
1159   function swapMulti(
1160     inputTokenInfo[] memory inputs,
1161     outputTokenInfo[] memory outputs,
1162     uint256 valueOutMin,
1163     bytes calldata pathDefinition,
1164     address executor,
1165     uint32 referralCode
1166   )
1167     external
1168     payable
1169     returns (uint256[] memory amountsOut)
1170   {
1171     return _swapMultiApproval(
1172       inputs,
1173       outputs,
1174       valueOutMin,
1175       pathDefinition,
1176       executor,
1177       referralCode
1178     );
1179   }
1180 
1181   /// @notice Internal logic for swapping between two sets of tokens with approvals
1182   /// @param inputs list of input token structs for the path being executed
1183   /// @param outputs list of output token structs for the path being executed
1184   /// @param valueOutMin minimum amount of value out the user will accept
1185   /// @param pathDefinition Encoded path definition for executor
1186   /// @param executor Address of contract that will execute the path
1187   /// @param referralCode referral code to specify the source of the swap
1188   function _swapMultiApproval(
1189     inputTokenInfo[] memory inputs,
1190     outputTokenInfo[] memory outputs,
1191     uint256 valueOutMin,
1192     bytes calldata pathDefinition,
1193     address executor,
1194     uint32 referralCode
1195   )
1196     internal
1197     returns (uint256[] memory amountsOut)
1198   {
1199     // If input amount is still 0 then that means the maximum possible input is to be used
1200     uint256 expected_msg_value = 0;
1201 
1202     for (uint256 i = 0; i < inputs.length; i++) {
1203       if (inputs[i].tokenAddress == _ETH) {
1204         if (inputs[i].amountIn == 0) {
1205           inputs[i].amountIn = msg.value;
1206         }
1207         expected_msg_value = inputs[i].amountIn;
1208       } 
1209       else {
1210         if (inputs[i].amountIn == 0) {
1211           inputs[i].amountIn = IERC20(inputs[i].tokenAddress).balanceOf(msg.sender);
1212         }
1213         IERC20(inputs[i].tokenAddress).safeTransferFrom(
1214           msg.sender,
1215           inputs[i].receiver,
1216           inputs[i].amountIn
1217         );
1218       }
1219     }
1220     require(msg.value == expected_msg_value, "Wrong msg.value");
1221 
1222     return _swapMulti(
1223       inputs,
1224       outputs,
1225       valueOutMin,
1226       pathDefinition,
1227       executor,
1228       referralCode
1229     );
1230   }
1231 
1232   /// @notice Externally facing interface for swapping between two sets of tokens with Permit2
1233   /// @param permit2 All additional info for Permit2 transfers
1234   /// @param inputs list of input token structs for the path being executed
1235   /// @param outputs list of output token structs for the path being executed
1236   /// @param valueOutMin minimum amount of value out the user will accept
1237   /// @param pathDefinition Encoded path definition for executor
1238   /// @param executor Address of contract that will execute the path
1239   /// @param referralCode referral code to specify the source of the swap
1240   function swapMultiPermit2(
1241     permit2Info memory permit2,
1242     inputTokenInfo[] memory inputs,
1243     outputTokenInfo[] memory outputs,
1244     uint256 valueOutMin,
1245     bytes calldata pathDefinition,
1246     address executor,
1247     uint32 referralCode
1248   )
1249     external
1250     payable
1251     returns (uint256[] memory amountsOut)
1252   {
1253     ISignatureTransfer.PermitBatchTransferFrom memory permit;
1254     ISignatureTransfer.SignatureTransferDetails[] memory transferDetails;
1255     {
1256       uint256 permit_length = msg.value > 0 ? inputs.length - 1 : inputs.length;
1257 
1258       permit = ISignatureTransfer.PermitBatchTransferFrom(
1259         new ISignatureTransfer.TokenPermissions[](permit_length),
1260         permit2.nonce,
1261         permit2.deadline
1262       );
1263       transferDetails = 
1264         new ISignatureTransfer.SignatureTransferDetails[](permit_length);
1265     }
1266     {
1267       uint256 expected_msg_value = 0;
1268       for (uint256 i = 0; i < inputs.length; i++) {
1269 
1270         if (inputs[i].tokenAddress == _ETH) {
1271           if (inputs[i].amountIn == 0) {
1272             inputs[i].amountIn = msg.value;
1273           }
1274           expected_msg_value = inputs[i].amountIn;
1275         }
1276         else {
1277           if (inputs[i].amountIn == 0) {
1278             inputs[i].amountIn = IERC20(inputs[i].tokenAddress).balanceOf(msg.sender);
1279           }
1280           uint256 permit_index = expected_msg_value == 0 ? i : i - 1;
1281 
1282           permit.permitted[permit_index].token = inputs[i].tokenAddress;
1283           permit.permitted[permit_index].amount = inputs[i].amountIn;
1284 
1285           transferDetails[permit_index].to = inputs[i].receiver;
1286           transferDetails[permit_index].requestedAmount = inputs[i].amountIn;
1287         }
1288       }
1289       require(msg.value == expected_msg_value, "Wrong msg.value");
1290     }
1291     ISignatureTransfer(permit2.contractAddress).permitTransferFrom(
1292       permit,
1293       transferDetails,
1294       msg.sender,
1295       permit2.signature
1296     );
1297     return _swapMulti(
1298       inputs,
1299       outputs,
1300       valueOutMin,
1301       pathDefinition,
1302       executor,
1303       referralCode
1304     );
1305   }
1306 
1307   /// @notice contains the main logic for swapping between two sets of tokens
1308   /// assumes that inputs have already been sent to the right location and msg.value
1309   /// is set correctly to be 0 for no native input and match native inpuit otherwise
1310   /// @param inputs list of input token structs for the path being executed
1311   /// @param outputs list of output token structs for the path being executed
1312   /// @param valueOutMin minimum amount of value out the user will accept
1313   /// @param pathDefinition Encoded path definition for executor
1314   /// @param executor Address of contract that will execute the path
1315   /// @param referralCode referral code to specify the source of the swap
1316   function _swapMulti(
1317     inputTokenInfo[] memory inputs,
1318     outputTokenInfo[] memory outputs,
1319     uint256 valueOutMin,
1320     bytes calldata pathDefinition,
1321     address executor,
1322     uint32 referralCode
1323   )
1324     internal
1325     returns (uint256[] memory amountsOut)
1326   {
1327     // Check for valid output specifications
1328     require(valueOutMin > 0, "Slippage limit too low");
1329 
1330     // Extract arrays of input amount values and tokens from the inputs struct list
1331     uint256[] memory amountsIn = new uint256[](inputs.length);
1332     address[] memory tokensIn = new address[](inputs.length);
1333 
1334     // Check input specification validity and transfer input tokens to executor
1335     {
1336       for (uint256 i = 0; i < inputs.length; i++) {
1337 
1338         amountsIn[i] = inputs[i].amountIn;
1339         tokensIn[i] = inputs[i].tokenAddress;
1340 
1341         for (uint256 j = 0; j < i; j++) {
1342           require(
1343             inputs[i].tokenAddress != inputs[j].tokenAddress,
1344             "Duplicate source tokens"
1345           );
1346         }
1347         for (uint256 j = 0; j < outputs.length; j++) {
1348           require(
1349             inputs[i].tokenAddress != outputs[j].tokenAddress,
1350             "Arbitrage not supported"
1351           );
1352         }
1353       }
1354     }
1355     // Check outputs for duplicates and record balances before swap
1356     uint256[] memory balancesBefore = new uint256[](outputs.length);
1357     for (uint256 i = 0; i < outputs.length; i++) {
1358       for (uint256 j = 0; j < i; j++) {
1359         require(
1360           outputs[i].tokenAddress != outputs[j].tokenAddress,
1361           "Duplicate destination tokens"
1362         );
1363       }
1364       balancesBefore[i] = _universalBalance(outputs[i].tokenAddress);
1365     }
1366     // Delegate the execution of the path to the specified Odos Executor
1367     IOdosExecutor(executor).executePath{value: msg.value}(pathDefinition, amountsIn, msg.sender);
1368 
1369     referralInfo memory thisReferralInfo;
1370     if (referralCode > REFERRAL_WITH_FEE_THRESHOLD) {
1371       thisReferralInfo = referralLookup[referralCode];
1372     }
1373 
1374     {
1375       uint256 valueOut;
1376       uint256 _swapMultiFee = swapMultiFee;
1377       amountsOut = new uint256[](outputs.length);
1378 
1379       for (uint256 i = 0; i < outputs.length; i++) {
1380         // Record the destination token balance before the path is executed
1381         amountsOut[i] = _universalBalance(outputs[i].tokenAddress) - balancesBefore[i];
1382 
1383         // Remove the swapMulti Fee (taken instead of positive slippage)
1384         amountsOut[i] = amountsOut[i] * (FEE_DENOM - _swapMultiFee) / FEE_DENOM;
1385 
1386         if (referralCode > REFERRAL_WITH_FEE_THRESHOLD) {
1387           _universalTransfer(
1388             outputs[i].tokenAddress,
1389             thisReferralInfo.beneficiary,
1390             amountsOut[i] * thisReferralInfo.referralFee * 8 / (FEE_DENOM * 10)
1391           );
1392           amountsOut[i] = amountsOut[i] * (FEE_DENOM - thisReferralInfo.referralFee) / FEE_DENOM;
1393         }
1394         _universalTransfer(
1395           outputs[i].tokenAddress,
1396           outputs[i].receiver,
1397           amountsOut[i]
1398         );
1399         // Add the amount out sent to the user to the total value of output
1400         valueOut += amountsOut[i] * outputs[i].relativeValue;
1401       }
1402       require(valueOut >= valueOutMin, "Slippage Limit Exceeded");
1403     }
1404     address[] memory tokensOut = new address[](outputs.length);
1405     for (uint256 i = 0; i < outputs.length; i++) {
1406         tokensOut[i] = outputs[i].tokenAddress;
1407     }
1408     emit SwapMulti(
1409       msg.sender,
1410       amountsIn,
1411       tokensIn,
1412       amountsOut,
1413       tokensOut,
1414       referralCode
1415     );
1416   }
1417 
1418   /// @notice Register a new referrer, optionally with an additional swap fee
1419   /// @param _referralCode the referral code to use for the new referral
1420   /// @param _referralFee the additional fee to add to each swap using this code
1421   /// @param _beneficiary the address to send the referral's share of fees to
1422   function registerReferralCode(
1423     uint32 _referralCode,
1424     uint64 _referralFee,
1425     address _beneficiary
1426   )
1427     external
1428   {
1429     // Do not allow for any overwriting of referral codes
1430     require(!referralLookup[_referralCode].registered, "Code in use");
1431 
1432     // Maximum additional fee a referral can set is 2%
1433     require(_referralFee <= FEE_DENOM / 50, "Fee too high");
1434 
1435     // Reserve the lower half of referral codes to be informative only
1436     if (_referralCode <= REFERRAL_WITH_FEE_THRESHOLD) {
1437       require(_referralFee == 0, "Invalid fee for code");
1438     } else {
1439       require(_referralFee > 0, "Invalid fee for code");
1440 
1441       // Make sure the beneficiary is not the null address if there is a fee
1442       require(_beneficiary != address(0), "Null beneficiary");
1443     }
1444     referralLookup[_referralCode].referralFee = _referralFee;
1445     referralLookup[_referralCode].beneficiary = _beneficiary;
1446     referralLookup[_referralCode].registered = true;
1447   }
1448 
1449   /// @notice Set the fee used for swapMulti
1450   /// @param _swapMultiFee the new fee for swapMulti
1451   function setSwapMultiFee(
1452     uint256 _swapMultiFee
1453   ) 
1454     external
1455     onlyOwner
1456   {
1457     // Maximum swapMultiFee that can be set is 0.5%
1458     require(_swapMultiFee <= FEE_DENOM / 200, "Fee too high");
1459     swapMultiFee = _swapMultiFee;
1460   }
1461 
1462   /// @notice Push new addresses to the cached address list for when storage is cheaper than calldata
1463   /// @param addresses list of addresses to be added to the cached address list
1464   function writeAddressList(
1465     address[] calldata addresses
1466   ) 
1467     external
1468     onlyOwner
1469   {
1470     for (uint256 i = 0; i < addresses.length; i++) {
1471       addressList.push(addresses[i]);
1472     }
1473   }
1474 
1475   /// @notice Allows the owner to transfer funds held by the router contract
1476   /// @param tokens List of token address to be transferred
1477   /// @param amounts List of amounts of each token to be transferred
1478   /// @param dest Address to which the funds should be sent
1479   function transferRouterFunds(
1480     address[] calldata tokens,
1481     uint256[] calldata amounts,
1482     address dest
1483   )
1484     external
1485     onlyOwner
1486   {
1487     require(tokens.length == amounts.length, "Invalid funds transfer");
1488     for (uint256 i = 0; i < tokens.length; i++) {
1489       _universalTransfer(
1490         tokens[i], 
1491         dest, 
1492         amounts[i] == 0 ? _universalBalance(tokens[i]) : amounts[i]
1493       );
1494     }
1495   }
1496   /// @notice Directly swap funds held in router 
1497   /// @param inputs list of input token structs for the path being executed
1498   /// @param outputs list of output token structs for the path being executed
1499   /// @param valueOutMin minimum amount of value out the user will accept
1500   /// @param pathDefinition Encoded path definition for executor
1501   /// @param executor Address of contract that will execute the path
1502   function swapRouterFunds(
1503     inputTokenInfo[] memory inputs,
1504     outputTokenInfo[] memory outputs,
1505     uint256 valueOutMin,
1506     bytes calldata pathDefinition,
1507     address executor
1508   )
1509     external
1510     onlyOwner
1511     returns (uint256[] memory amountsOut)
1512   {
1513     uint256[] memory amountsIn = new uint256[](inputs.length);
1514     address[] memory tokensIn = new address[](inputs.length);
1515 
1516     for (uint256 i = 0; i < inputs.length; i++) {
1517       tokensIn[i] = inputs[i].tokenAddress;
1518 
1519       amountsIn[i] = inputs[i].amountIn == 0 ? 
1520         _universalBalance(tokensIn[i]) : inputs[i].amountIn;
1521 
1522       _universalTransfer(
1523         tokensIn[i],
1524         inputs[i].receiver,
1525         amountsIn[i]
1526       );
1527     }
1528     // Check outputs for duplicates and record balances before swap
1529     uint256[] memory balancesBefore = new uint256[](outputs.length);
1530     address[] memory tokensOut = new address[](outputs.length);
1531     for (uint256 i = 0; i < outputs.length; i++) {
1532       tokensOut[i] = outputs[i].tokenAddress;
1533       balancesBefore[i] = _universalBalance(tokensOut[i]);
1534     }
1535     // Delegate the execution of the path to the specified Odos Executor
1536     IOdosExecutor(executor).executePath{value: 0}(pathDefinition, amountsIn, msg.sender);
1537 
1538     uint256 valueOut;
1539     amountsOut = new uint256[](outputs.length);
1540     for (uint256 i = 0; i < outputs.length; i++) {
1541 
1542       // Record the destination token balance before the path is executed
1543       amountsOut[i] = _universalBalance(tokensOut[i]) - balancesBefore[i];
1544 
1545       _universalTransfer(
1546         outputs[i].tokenAddress,
1547         outputs[i].receiver,
1548         amountsOut[i]
1549       );
1550       // Add the amount out sent to the user to the total value of output
1551       valueOut += amountsOut[i] * outputs[i].relativeValue;
1552     }
1553     require(valueOut >= valueOutMin, "Slippage Limit Exceeded");
1554 
1555     emit SwapMulti(
1556       msg.sender,
1557       amountsIn,
1558       tokensIn,
1559       amountsOut,
1560       tokensOut,
1561       0
1562     );
1563   }
1564   /// @notice helper function to get balance of ERC20 or native coin for this contract
1565   /// @param token address of the token to check, null for native coin
1566   /// @return balance of specified coin or token
1567   function _universalBalance(address token) private view returns(uint256) {
1568     if (token == _ETH) {
1569       return address(this).balance;
1570     } else {
1571       return IERC20(token).balanceOf(address(this));
1572     }
1573   }
1574   /// @notice helper function to transfer ERC20 or native coin
1575   /// @param token address of the token being transferred, null for native coin
1576   /// @param to address to transfer to
1577   /// @param amount to transfer
1578   function _universalTransfer(address token, address to, uint256 amount) private {
1579     if (token == _ETH) {
1580       (bool success,) = payable(to).call{value: amount}("");
1581       require(success, "ETH transfer failed");
1582     } else {
1583       IERC20(token).safeTransfer(to, amount);
1584     }
1585   }
1586 }