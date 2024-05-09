1 // File: interfaces/IVault.sol
2 
3 
4 pragma solidity ^0.8.6;
5 
6 /**
7  * @title Vault Interface
8  */
9 interface IVault {
10     /**
11      * @dev External function to get vidya rate.
12      */
13     function rewardRate() external view returns (uint256);
14 
15     /**
16      * @dev External function to get total priority.
17      */
18     function totalPriority() external view returns (uint256);
19 
20     /**
21      * @dev External function to get teller priority.
22      * @param tellerId Teller Id
23      */
24     function tellerPriority(address tellerId) external view returns (uint256);
25 
26     /**
27      * @dev External function to add the teller. This function can be called by only owner.
28      * @param teller Address of teller
29      * @param priority Priority of teller
30      */
31     function addTeller(address teller, uint256 priority) external;
32 
33     /**
34      * @dev External function to change the priority of teller. This function can be called by only owner.
35      * @param teller Address of teller
36      * @param newPriority New priority of teller
37      */
38     function changePriority(address teller, uint256 newPriority) external;
39 
40     /**
41      * @dev External function to pay the Vidya token to investors. This function can be called by only teller.
42      * @param provider Address of provider
43      * @param providerTimeWeight Weight time of provider
44      * @param totalWeight Sum of provider weight
45      */
46     function payProvider(
47         address provider,
48         uint256 providerTimeWeight,
49         uint256 totalWeight
50     ) external;
51 
52     /**
53      * @dev External function to calculate the Vidya Rate.
54      */
55     function calculateRateExternal() external;
56 }
57 // File: @openzeppelin/contracts/utils/Address.sol
58 
59 
60 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
61 
62 pragma solidity ^0.8.1;
63 
64 /**
65  * @dev Collection of functions related to the address type
66  */
67 library Address {
68     /**
69      * @dev Returns true if `account` is a contract.
70      *
71      * [IMPORTANT]
72      * ====
73      * It is unsafe to assume that an address for which this function returns
74      * false is an externally-owned account (EOA) and not a contract.
75      *
76      * Among others, `isContract` will return false for the following
77      * types of addresses:
78      *
79      *  - an externally-owned account
80      *  - a contract in construction
81      *  - an address where a contract will be created
82      *  - an address where a contract lived, but was destroyed
83      * ====
84      *
85      * [IMPORTANT]
86      * ====
87      * You shouldn't rely on `isContract` to protect against flash loan attacks!
88      *
89      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
90      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
91      * constructor.
92      * ====
93      */
94     function isContract(address account) internal view returns (bool) {
95         // This method relies on extcodesize/address.code.length, which returns 0
96         // for contracts in construction, since the code is only stored at the end
97         // of the constructor execution.
98 
99         return account.code.length > 0;
100     }
101 
102     /**
103      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
104      * `recipient`, forwarding all available gas and reverting on errors.
105      *
106      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
107      * of certain opcodes, possibly making contracts go over the 2300 gas limit
108      * imposed by `transfer`, making them unable to receive funds via
109      * `transfer`. {sendValue} removes this limitation.
110      *
111      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
112      *
113      * IMPORTANT: because control is transferred to `recipient`, care must be
114      * taken to not create reentrancy vulnerabilities. Consider using
115      * {ReentrancyGuard} or the
116      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
117      */
118     function sendValue(address payable recipient, uint256 amount) internal {
119         require(address(this).balance >= amount, "Address: insufficient balance");
120 
121         (bool success, ) = recipient.call{value: amount}("");
122         require(success, "Address: unable to send value, recipient may have reverted");
123     }
124 
125     /**
126      * @dev Performs a Solidity function call using a low level `call`. A
127      * plain `call` is an unsafe replacement for a function call: use this
128      * function instead.
129      *
130      * If `target` reverts with a revert reason, it is bubbled up by this
131      * function (like regular Solidity function calls).
132      *
133      * Returns the raw returned data. To convert to the expected return value,
134      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
135      *
136      * Requirements:
137      *
138      * - `target` must be a contract.
139      * - calling `target` with `data` must not revert.
140      *
141      * _Available since v3.1._
142      */
143     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
144         return functionCall(target, data, "Address: low-level call failed");
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
149      * `errorMessage` as a fallback revert reason when `target` reverts.
150      *
151      * _Available since v3.1._
152      */
153     function functionCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal returns (bytes memory) {
158         return functionCallWithValue(target, data, 0, errorMessage);
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
163      * but also transferring `value` wei to `target`.
164      *
165      * Requirements:
166      *
167      * - the calling contract must have an ETH balance of at least `value`.
168      * - the called Solidity function must be `payable`.
169      *
170      * _Available since v3.1._
171      */
172     function functionCallWithValue(
173         address target,
174         bytes memory data,
175         uint256 value
176     ) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
182      * with `errorMessage` as a fallback revert reason when `target` reverts.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(address(this).balance >= value, "Address: insufficient balance for call");
193         require(isContract(target), "Address: call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.call{value: value}(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
201      * but performing a static call.
202      *
203      * _Available since v3.3._
204      */
205     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
206         return functionStaticCall(target, data, "Address: low-level static call failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
211      * but performing a static call.
212      *
213      * _Available since v3.3._
214      */
215     function functionStaticCall(
216         address target,
217         bytes memory data,
218         string memory errorMessage
219     ) internal view returns (bytes memory) {
220         require(isContract(target), "Address: static call to non-contract");
221 
222         (bool success, bytes memory returndata) = target.staticcall(data);
223         return verifyCallResult(success, returndata, errorMessage);
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
228      * but performing a delegate call.
229      *
230      * _Available since v3.4._
231      */
232     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
233         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
238      * but performing a delegate call.
239      *
240      * _Available since v3.4._
241      */
242     function functionDelegateCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         require(isContract(target), "Address: delegate call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.delegatecall(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
255      * revert reason using the provided one.
256      *
257      * _Available since v4.3._
258      */
259     function verifyCallResult(
260         bool success,
261         bytes memory returndata,
262         string memory errorMessage
263     ) internal pure returns (bytes memory) {
264         if (success) {
265             return returndata;
266         } else {
267             // Look for revert reason and bubble it up if present
268             if (returndata.length > 0) {
269                 // The easiest way to bubble the revert reason is using memory via assembly
270 
271                 assembly {
272                     let returndata_size := mload(returndata)
273                     revert(add(32, returndata), returndata_size)
274                 }
275             } else {
276                 revert(errorMessage);
277             }
278         }
279     }
280 }
281 
282 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
283 
284 
285 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev Contract module that helps prevent reentrant calls to a function.
291  *
292  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
293  * available, which can be applied to functions to make sure there are no nested
294  * (reentrant) calls to them.
295  *
296  * Note that because there is a single `nonReentrant` guard, functions marked as
297  * `nonReentrant` may not call one another. This can be worked around by making
298  * those functions `private`, and then adding `external` `nonReentrant` entry
299  * points to them.
300  *
301  * TIP: If you would like to learn more about reentrancy and alternative ways
302  * to protect against it, check out our blog post
303  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
304  */
305 abstract contract ReentrancyGuard {
306     // Booleans are more expensive than uint256 or any type that takes up a full
307     // word because each write operation emits an extra SLOAD to first read the
308     // slot's contents, replace the bits taken up by the boolean, and then write
309     // back. This is the compiler's defense against contract upgrades and
310     // pointer aliasing, and it cannot be disabled.
311 
312     // The values being non-zero value makes deployment a bit more expensive,
313     // but in exchange the refund on every call to nonReentrant will be lower in
314     // amount. Since refunds are capped to a percentage of the total
315     // transaction's gas, it is best to keep them low in cases like this one, to
316     // increase the likelihood of the full refund coming into effect.
317     uint256 private constant _NOT_ENTERED = 1;
318     uint256 private constant _ENTERED = 2;
319 
320     uint256 private _status;
321 
322     constructor() {
323         _status = _NOT_ENTERED;
324     }
325 
326     /**
327      * @dev Prevents a contract from calling itself, directly or indirectly.
328      * Calling a `nonReentrant` function from another `nonReentrant`
329      * function is not supported. It is possible to prevent this from happening
330      * by making the `nonReentrant` function external, and making it call a
331      * `private` function that does the actual work.
332      */
333     modifier nonReentrant() {
334         // On the first call to nonReentrant, _notEntered will be true
335         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
336 
337         // Any calls to nonReentrant after this point will fail
338         _status = _ENTERED;
339 
340         _;
341 
342         // By storing the original value once again, a refund is triggered (see
343         // https://eips.ethereum.org/EIPS/eip-2200)
344         _status = _NOT_ENTERED;
345     }
346 }
347 
348 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
349 
350 
351 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev Interface of the ERC20 standard as defined in the EIP.
357  */
358 interface IERC20 {
359     /**
360      * @dev Returns the amount of tokens in existence.
361      */
362     function totalSupply() external view returns (uint256);
363 
364     /**
365      * @dev Returns the amount of tokens owned by `account`.
366      */
367     function balanceOf(address account) external view returns (uint256);
368 
369     /**
370      * @dev Moves `amount` tokens from the caller's account to `to`.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transfer(address to, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Returns the remaining number of tokens that `spender` will be
380      * allowed to spend on behalf of `owner` through {transferFrom}. This is
381      * zero by default.
382      *
383      * This value changes when {approve} or {transferFrom} are called.
384      */
385     function allowance(address owner, address spender) external view returns (uint256);
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
389      *
390      * Returns a boolean value indicating whether the operation succeeded.
391      *
392      * IMPORTANT: Beware that changing an allowance with this method brings the risk
393      * that someone may use both the old and the new allowance by unfortunate
394      * transaction ordering. One possible solution to mitigate this race
395      * condition is to first reduce the spender's allowance to 0 and set the
396      * desired value afterwards:
397      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
398      *
399      * Emits an {Approval} event.
400      */
401     function approve(address spender, uint256 amount) external returns (bool);
402 
403     /**
404      * @dev Moves `amount` tokens from `from` to `to` using the
405      * allowance mechanism. `amount` is then deducted from the caller's
406      * allowance.
407      *
408      * Returns a boolean value indicating whether the operation succeeded.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transferFrom(
413         address from,
414         address to,
415         uint256 amount
416     ) external returns (bool);
417 
418     /**
419      * @dev Emitted when `value` tokens are moved from one account (`from`) to
420      * another (`to`).
421      *
422      * Note that `value` may be zero.
423      */
424     event Transfer(address indexed from, address indexed to, uint256 value);
425 
426     /**
427      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
428      * a call to {approve}. `value` is the new allowance.
429      */
430     event Approval(address indexed owner, address indexed spender, uint256 value);
431 }
432 
433 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 
441 
442 /**
443  * @title SafeERC20
444  * @dev Wrappers around ERC20 operations that throw on failure (when the token
445  * contract returns false). Tokens that return no value (and instead revert or
446  * throw on failure) are also supported, non-reverting calls are assumed to be
447  * successful.
448  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
449  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
450  */
451 library SafeERC20 {
452     using Address for address;
453 
454     function safeTransfer(
455         IERC20 token,
456         address to,
457         uint256 value
458     ) internal {
459         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
460     }
461 
462     function safeTransferFrom(
463         IERC20 token,
464         address from,
465         address to,
466         uint256 value
467     ) internal {
468         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
469     }
470 
471     /**
472      * @dev Deprecated. This function has issues similar to the ones found in
473      * {IERC20-approve}, and its usage is discouraged.
474      *
475      * Whenever possible, use {safeIncreaseAllowance} and
476      * {safeDecreaseAllowance} instead.
477      */
478     function safeApprove(
479         IERC20 token,
480         address spender,
481         uint256 value
482     ) internal {
483         // safeApprove should only be called when setting an initial allowance,
484         // or when resetting it to zero. To increase and decrease it, use
485         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
486         require(
487             (value == 0) || (token.allowance(address(this), spender) == 0),
488             "SafeERC20: approve from non-zero to non-zero allowance"
489         );
490         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
491     }
492 
493     function safeIncreaseAllowance(
494         IERC20 token,
495         address spender,
496         uint256 value
497     ) internal {
498         uint256 newAllowance = token.allowance(address(this), spender) + value;
499         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
500     }
501 
502     function safeDecreaseAllowance(
503         IERC20 token,
504         address spender,
505         uint256 value
506     ) internal {
507         unchecked {
508             uint256 oldAllowance = token.allowance(address(this), spender);
509             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
510             uint256 newAllowance = oldAllowance - value;
511             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
512         }
513     }
514 
515     /**
516      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
517      * on the return value: the return value is optional (but if data is returned, it must not be false).
518      * @param token The token targeted by the call.
519      * @param data The call data (encoded using abi.encode or one of its variants).
520      */
521     function _callOptionalReturn(IERC20 token, bytes memory data) private {
522         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
523         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
524         // the target address contains contract code and also asserts for success in the low-level call.
525 
526         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
527         if (returndata.length > 0) {
528             // Return data is optional
529             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
530         }
531     }
532 }
533 
534 // File: @openzeppelin/contracts/utils/Context.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Provides information about the current execution context, including the
543  * sender of the transaction and its data. While these are generally available
544  * via msg.sender and msg.data, they should not be accessed in such a direct
545  * manner, since when dealing with meta-transactions the account sending and
546  * paying for execution may not be the actual sender (as far as an application
547  * is concerned).
548  *
549  * This contract is only required for intermediate, library-like contracts.
550  */
551 abstract contract Context {
552     function _msgSender() internal view virtual returns (address) {
553         return msg.sender;
554     }
555 
556     function _msgData() internal view virtual returns (bytes calldata) {
557         return msg.data;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/access/Ownable.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @dev Contract module which provides a basic access control mechanism, where
571  * there is an account (an owner) that can be granted exclusive access to
572  * specific functions.
573  *
574  * By default, the owner account will be the one that deploys the contract. This
575  * can later be changed with {transferOwnership}.
576  *
577  * This module is used through inheritance. It will make available the modifier
578  * `onlyOwner`, which can be applied to your functions to restrict their use to
579  * the owner.
580  */
581 abstract contract Ownable is Context {
582     address private _owner;
583 
584     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
585 
586     /**
587      * @dev Initializes the contract setting the deployer as the initial owner.
588      */
589     constructor() {
590         _transferOwnership(_msgSender());
591     }
592 
593     /**
594      * @dev Returns the address of the current owner.
595      */
596     function owner() public view virtual returns (address) {
597         return _owner;
598     }
599 
600     /**
601      * @dev Throws if called by any account other than the owner.
602      */
603     modifier onlyOwner() {
604         require(owner() == _msgSender(), "Ownable: caller is not the owner");
605         _;
606     }
607 
608     /**
609      * @dev Leaves the contract without owner. It will not be possible to call
610      * `onlyOwner` functions anymore. Can only be called by the current owner.
611      *
612      * NOTE: Renouncing ownership will leave the contract without an owner,
613      * thereby removing any functionality that is only available to the owner.
614      */
615     function renounceOwnership() public virtual onlyOwner {
616         _transferOwnership(address(0));
617     }
618 
619     /**
620      * @dev Transfers ownership of the contract to a new account (`newOwner`).
621      * Can only be called by the current owner.
622      */
623     function transferOwnership(address newOwner) public virtual onlyOwner {
624         require(newOwner != address(0), "Ownable: new owner is the zero address");
625         _transferOwnership(newOwner);
626     }
627 
628     /**
629      * @dev Transfers ownership of the contract to a new account (`newOwner`).
630      * Internal function without access restriction.
631      */
632     function _transferOwnership(address newOwner) internal virtual {
633         address oldOwner = _owner;
634         _owner = newOwner;
635         emit OwnershipTransferred(oldOwner, newOwner);
636     }
637 }
638 
639 // File: Teller.sol
640 
641 
642 pragma solidity ^0.8.6;
643 
644 
645 
646 
647 
648 
649 
650 /**
651  * @title Teller Contract
652  */
653 contract Teller is Ownable, ReentrancyGuard {
654     using Address for address;
655     using SafeERC20 for IERC20;
656 
657     /// @notice Event emitted on construction.
658     event TellerDeployed();
659 
660     /// @notice Event emitted when teller status is toggled.
661     event TellerToggled(address teller, bool status);
662 
663     /// @notice Event emitted when new commitment is added.
664     event NewCommitmentAdded(
665         uint256 bonus,
666         uint256 time,
667         uint256 penalty,
668         uint256 deciAdjustment
669     );
670 
671     /// @notice Event emitted when commitment status is toggled.
672     event CommitmentToggled(uint256 index, bool status);
673 
674     /// @notice Event emitted when owner sets the dev address to get the break commitment fees.
675     event PurposeSet(address devAddress, bool purposeStatus);
676 
677     /// @notice Event emitted when a provider deposits lp tokens.
678     event LpDeposited(address indexed provider, uint256 indexed amount);
679 
680     /// @notice Event emitted when a provider withdraws lp tokens.
681     event Withdrew(address indexed provider, uint256 indexed amount);
682 
683     /// @notice Event emitted when a provider commits lp tokens.
684     event Commited(address indexed provider, uint256 indexed commitedAmount);
685 
686     /// @notice Event emitted when a provider breaks the commitment.
687     event CommitmentBroke(address indexed provider, uint256 indexed tokenSentAmount);
688 
689     /// @notice Event emitted when provider claimed rewards.
690     event Claimed(address indexed provider, bool indexed success);
691 
692     struct Provider {
693         uint256 LPDepositedRatio;
694         uint256 userWeight;
695         uint256 lastClaimedTime;
696         uint256 commitmentIndex;
697         uint256 committedAmount;
698         uint256 commitmentEndTime;
699     }
700 
701     struct Commitment {
702         uint256 bonus;
703         uint256 duration;
704         uint256 penalty;
705         uint256 deciAdjustment;
706         bool isActive;
707     }
708 
709     IVault public Vault;
710     IERC20 public LpToken;
711 
712     uint256 public totalLP;
713     uint256 public totalWeight;
714     uint256 public tellerClosedTime;
715 
716     bool public tellerOpen;
717     bool public purpose;
718 
719     address public devAddress;
720 
721     Commitment[] public commitmentInfo;
722 
723     mapping(address => Provider) public providerInfo;
724 
725     modifier isTellerOpen() {
726         require(tellerOpen, "Teller: Teller is not open.");
727         _;
728     }
729 
730     modifier isProvider() {
731         require(
732             providerInfo[msg.sender].LPDepositedRatio != 0,
733             "Teller: Caller is not a provider."
734         );
735         _;
736     }
737 
738     modifier isTellerClosed() {
739         require(!tellerOpen, "Teller: Teller is still active.");
740         _;
741     }
742 
743     /**
744      * @dev Constructor function
745      * @param _LpToken Interface of LP token
746      * @param _Vault Interface of Vault
747      */
748     constructor(IERC20 _LpToken, IVault _Vault) {
749         LpToken = _LpToken;
750         Vault = _Vault;
751         commitmentInfo.push();
752 
753         emit TellerDeployed();
754     }
755 
756     /**
757      * @dev External function to toggle the teller. This function can be called only by the owner.
758      */
759     function toggleTeller() external onlyOwner {
760         tellerOpen = !tellerOpen;
761         tellerClosedTime = block.timestamp;
762         emit TellerToggled(address(this), tellerOpen);
763     }
764 
765     /**
766      * @dev External function to add a commitment option. This function can be called only by the owner.
767      * @param _bonus Amount of bonus
768      * @param _days Commitment duration in days
769      * @param _penalty The penalty
770      * @param _deciAdjustment Decimal percentage
771      */
772     function addCommitment(
773         uint256 _bonus,
774         uint256 _days,
775         uint256 _penalty,
776         uint256 _deciAdjustment
777     ) external onlyOwner {
778         Commitment memory holder;
779 
780         holder.bonus = _bonus;
781         holder.duration = _days * 1 days;
782         holder.penalty = _penalty;
783         holder.deciAdjustment = _deciAdjustment;
784         holder.isActive = true;
785 
786         commitmentInfo.push(holder);
787 
788         emit NewCommitmentAdded(_bonus, _days, _penalty, _deciAdjustment);
789     }
790 
791     /**
792      * @dev External function to toggle the commitment. This function can be called only by the owner.
793      * @param _index Commitment index
794      */
795     function toggleCommitment(uint256 _index) external onlyOwner {
796         require(
797             0 < _index && _index < commitmentInfo.length,
798             "Teller: Current index is not listed in the commitment array."
799         );
800         commitmentInfo[_index].isActive = !commitmentInfo[_index].isActive;
801 
802         emit CommitmentToggled(_index, commitmentInfo[_index].isActive);
803     }
804 
805     /**
806      * @dev External function to set the dev address to give that address the break commitment fees. This function can be called only by the owner.
807      * @param _address Dev address
808      * @param _status If purpose is active or not
809      */
810     function setPurpose(address _address, bool _status) external onlyOwner {
811         purpose = _status;
812         devAddress = _address;
813 
814         emit PurposeSet(devAddress, purpose);
815     }
816 
817     /**
818      * @dev External function for providers to deposit lp tokens. Teller must be open.
819      * @param _amount LP token amount
820      */
821     function depositLP(uint256 _amount) external isTellerOpen {
822         uint256 contractBalance = LpToken.balanceOf(address(this));
823         LpToken.safeTransferFrom(msg.sender, address(this), _amount);
824 
825         Provider storage user = providerInfo[msg.sender];
826         if (user.LPDepositedRatio != 0) {
827             commitmentFinished();
828             claim();
829         } else {
830             user.lastClaimedTime = block.timestamp;
831         }
832         if (contractBalance == totalLP || totalLP == 0) {
833             user.LPDepositedRatio += _amount;
834             totalLP += _amount;
835         } else {
836             uint256 _adjustedAmount = (_amount * totalLP) / contractBalance;
837             user.LPDepositedRatio += _adjustedAmount;
838             totalLP += _adjustedAmount;
839         }
840 
841         user.userWeight += _amount;
842         totalWeight += _amount;
843 
844         emit LpDeposited(msg.sender, _amount);
845     }
846 
847     /**
848      * @dev External function to withdraw lp token from the teller. This function can be called only by a provider.
849      * @param _amount LP token amount
850      */
851     function withdraw(uint256 _amount) external isProvider nonReentrant {
852         Provider storage user = providerInfo[msg.sender];
853         uint256 contractBalance = LpToken.balanceOf(address(this));
854         commitmentFinished();
855         uint256 userTokens = (user.LPDepositedRatio * contractBalance) /
856             totalLP;
857         require(
858             userTokens - user.committedAmount >= _amount,
859             "Teller: Provider hasn't got enough deposited LP tokens to withdraw."
860         );
861 
862         claim();
863 
864         uint256 _weightChange = (_amount * user.userWeight) / userTokens;
865         user.userWeight -= _weightChange;
866         totalWeight -= _weightChange;
867 
868         uint256 ratioChange = _amount * totalLP/contractBalance;
869         user.LPDepositedRatio -= ratioChange;
870         totalLP -= ratioChange;
871 
872 
873         LpToken.safeTransfer(msg.sender, _amount);
874 
875         emit Withdrew(msg.sender, _amount);
876     }
877 
878     /**
879      * @dev External function to withdraw lp token when teller is closed. This function can be called only by a provider.
880      */
881     function tellerClosedWithdraw() external isTellerClosed isProvider {
882         uint256 contractBalance = LpToken.balanceOf(address(this));
883         require(contractBalance != 0, "Teller: Contract balance is zero.");
884 
885         claim();
886 
887         Provider memory user = providerInfo[msg.sender];
888 
889         uint256 userTokens = (user.LPDepositedRatio * contractBalance) /
890             totalLP;
891         totalLP -= user.LPDepositedRatio;
892         totalWeight -= user.userWeight;
893 
894         providerInfo[msg.sender] = Provider(0, 0, 0, 0, 0, 0);
895 
896         LpToken.safeTransfer(msg.sender, userTokens);
897 
898         emit Withdrew(msg.sender, userTokens);
899     }
900 
901     /**
902      * @dev External function to commit lp token to gain a minor advantage for a selected period of time. This function can be called only by a provider.
903      * @param _amount LP token amount
904      * @param _commitmentIndex Index of commitment array
905      */
906     function commit(uint256 _amount, uint256 _commitmentIndex)
907         external
908         nonReentrant
909         isProvider
910     {
911         require(
912             commitmentInfo[_commitmentIndex].isActive,
913             "Teller: Current commitment is not active."
914         );
915 
916         Provider storage user = providerInfo[msg.sender];
917         commitmentFinished();
918         uint256 contractBalance = LpToken.balanceOf(address(this));
919         uint256 userTokens = (user.LPDepositedRatio * contractBalance) /
920             totalLP;
921 
922         require(
923             userTokens - user.committedAmount >= _amount,
924             "Teller: Provider hasn't got enough deposited LP tokens to commit."
925         );
926 
927         if (user.committedAmount != 0) {
928             require(
929                 _commitmentIndex == user.commitmentIndex,
930                 "Teller: Commitment index is not the same as providers'."
931             );
932         }
933 
934         uint256 newEndTime;
935 
936         if (
937             user.commitmentEndTime >= block.timestamp &&
938             user.committedAmount != 0
939         ) {
940             newEndTime = calculateNewEndTime(
941                 user.committedAmount,
942                 _amount,
943                 user.commitmentEndTime,
944                 _commitmentIndex
945             );
946         } else {
947             newEndTime =
948                 block.timestamp +
949                 commitmentInfo[_commitmentIndex].duration;
950         }
951 
952         uint256 weightToGain = (_amount * user.userWeight) / userTokens;
953         uint256 bonusCredit = commitBonus(_commitmentIndex, weightToGain);
954 
955         claim();
956 
957         user.commitmentIndex = _commitmentIndex;
958         user.committedAmount += _amount;
959         user.commitmentEndTime = newEndTime;
960         user.userWeight += bonusCredit;
961         totalWeight += bonusCredit;
962 
963         emit Commited(msg.sender, _amount);
964     }
965 
966     /**
967      * @dev External function to break the commitment. This function can be called only by a provider.
968      */
969     function breakCommitment() external nonReentrant isProvider {
970         Provider memory user = providerInfo[msg.sender];
971 
972         require(
973             user.commitmentEndTime > block.timestamp,
974             "Teller: No commitment to break."
975         );
976 
977         uint256 contractBalance = LpToken.balanceOf(address(this));
978 
979         uint256 tokenToReceive = (user.LPDepositedRatio * contractBalance) /
980             totalLP;
981 
982         Commitment memory currentCommit = commitmentInfo[user.commitmentIndex];
983         
984         //fee for breaking the commitment
985         uint256 fee = (user.committedAmount * currentCommit.penalty) /
986             currentCommit.deciAdjustment;
987             
988         //fee reduced from provider and left in teller
989         tokenToReceive -= fee;
990 
991         totalLP -= user.LPDepositedRatio;
992 
993         totalWeight -= user.userWeight;
994 
995         providerInfo[msg.sender] = Provider(0, 0, 0, 0, 0, 0);
996         
997         //if a devloper purpose is set then transfer to address
998         if (purpose) {
999             LpToken.safeTransfer(devAddress, fee / 10);
1000         }
1001         
1002         //Fee is not lost it is dispersed to remaining providers. 
1003         LpToken.safeTransfer(msg.sender, tokenToReceive);
1004 
1005         emit CommitmentBroke(msg.sender, tokenToReceive);
1006     }
1007 
1008     /**
1009      * @dev Internal function to claim rewards.
1010      */
1011     function claim() internal {
1012         Provider storage user = providerInfo[msg.sender];
1013         uint256 timeGap = block.timestamp - user.lastClaimedTime;
1014 
1015         if (!tellerOpen) {
1016             timeGap = tellerClosedTime - user.lastClaimedTime;
1017         }
1018 
1019         if (timeGap > 365 * 1 days) {
1020             timeGap = 365 * 1 days;
1021         }
1022 
1023         uint256 timeWeight = timeGap * user.userWeight;
1024 
1025         user.lastClaimedTime = block.timestamp;
1026 
1027         Vault.payProvider(msg.sender, timeWeight, totalWeight);
1028 
1029         emit Claimed(msg.sender, true);
1030     }
1031 
1032     /**
1033      * @dev Internal function to return commit bonus.
1034      * @param _commitmentIndex Index of commitment array
1035      * @param _amount Commitment token amount
1036      */
1037     function commitBonus(uint256 _commitmentIndex, uint256 _amount)
1038         internal
1039         view
1040         returns (uint256)
1041     {
1042         if (commitmentInfo[_commitmentIndex].isActive) {
1043             return
1044                 (commitmentInfo[_commitmentIndex].bonus * _amount) /
1045                 commitmentInfo[_commitmentIndex].deciAdjustment;
1046         }
1047         return 0;
1048     }
1049 
1050     /**
1051      * @dev Internal function to calculate the new ending time when the current end time is overflown.
1052      * @param _oldAmount Commitment lp token amount which provider has
1053      * @param _extraAmount Lp token amount which user wants to commit
1054      * @param _oldEndTime Previous commitment ending time
1055      * @param _commitmentIndex Index of commitment array
1056      */
1057     function calculateNewEndTime(
1058         uint256 _oldAmount,
1059         uint256 _extraAmount,
1060         uint256 _oldEndTime,
1061         uint256 _commitmentIndex
1062     ) internal view returns (uint256) {
1063         uint256 extraEndTIme = commitmentInfo[_commitmentIndex].duration +
1064             block.timestamp;
1065         uint256 newEndTime = ((_oldAmount * _oldEndTime) +
1066             (_extraAmount * extraEndTIme)) / (_oldAmount + _extraAmount);
1067 
1068         return newEndTime;
1069     }
1070 
1071     /**
1072      * @dev Internal function to finish a commitment when it has ended.
1073      */
1074     function commitmentFinished() internal {
1075         Provider storage user = providerInfo[msg.sender];
1076         if (user.commitmentEndTime <= block.timestamp) {
1077             user.committedAmount = 0;
1078             user.commitmentIndex = 0;
1079         }
1080     }
1081 
1082     /**
1083      * @dev External function to claim the reward token. This function can be called only by a provider and teller must be open.
1084      */
1085     function claimExternal() external isTellerOpen isProvider nonReentrant {
1086         commitmentFinished();
1087         claim();
1088     }
1089 
1090     /**
1091      * @dev External function to get User info. This function can be called from a msg.sender with active deposits.
1092      * @return Time of rest committed time
1093      * @return Committed amount
1094      * @return Committed Index
1095      * @return Amount to Claim
1096      * @return Total LP deposited
1097      */
1098     function getUserInfo(address _user)
1099         external
1100         view
1101         returns (
1102             uint256,
1103             uint256,
1104             uint256,
1105             uint256,
1106             uint256
1107         )
1108     {
1109         Provider memory user = providerInfo[_user];
1110 
1111         if (user.LPDepositedRatio > 0) {
1112             uint256 claimAmount = (Vault.rewardRate() *
1113                 Vault.tellerPriority(address(this)) *
1114                 (block.timestamp - user.lastClaimedTime) *
1115                 user.userWeight) / (totalWeight * Vault.totalPriority());
1116 
1117             uint256 totalLPDeposited = (providerInfo[_user]
1118                 .LPDepositedRatio * LpToken.balanceOf(address(this))) / totalLP;
1119 
1120             if (user.commitmentEndTime > block.timestamp) {
1121                 return (
1122                     user.commitmentEndTime - block.timestamp,
1123                     user.committedAmount,
1124                     user.commitmentIndex,
1125                     claimAmount,
1126                     totalLPDeposited
1127                 );
1128             } else {
1129                 return (0, 0, 0, claimAmount, totalLPDeposited);
1130             }
1131         } else {
1132             return (0, 0, 0, 0, 0);
1133         }
1134     }
1135 }