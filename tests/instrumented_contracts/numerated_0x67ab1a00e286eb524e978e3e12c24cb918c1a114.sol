1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Emitted when `value` tokens are moved from one account (`from`) to
9      * another (`to`).
10      *
11      * Note that `value` may be zero.
12      */
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     /**
16      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
17      * a call to {approve}. `value` is the new allowance.
18      */
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `to`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address to, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `from` to `to` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address from,
76         address to,
77         uint256 amount
78     ) external returns (bool);
79 }
80 
81 
82 
83 
84 
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Provides information about the current execution context, including the
90  * sender of the transaction and its data. While these are generally available
91  * via msg.sender and msg.data, they should not be accessed in such a direct
92  * manner, since when dealing with meta-transactions the account sending and
93  * paying for execution may not be the actual sender (as far as an application
94  * is concerned).
95  *
96  * This contract is only required for intermediate, library-like contracts.
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes calldata) {
104         return msg.data;
105     }
106 }
107 
108 
109 
110 
111 
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * By default, the owner account will be the one that deploys the contract. This
121  * can later be changed with {transferOwnership}.
122  *
123  * This module is used through inheritance. It will make available the modifier
124  * `onlyOwner`, which can be applied to your functions to restrict their use to
125  * the owner.
126  */
127 abstract contract Ownable is Context {
128     address private _owner;
129 
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     /**
133      * @dev Initializes the contract setting the deployer as the initial owner.
134      */
135     constructor() {
136         _transferOwnership(_msgSender());
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         _checkOwner();
144         _;
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if the sender is not the owner.
156      */
157     function _checkOwner() internal view virtual {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159     }
160 
161     /**
162      * @dev Leaves the contract without owner. It will not be possible to call
163      * `onlyOwner` functions anymore. Can only be called by the current owner.
164      *
165      * NOTE: Renouncing ownership will leave the contract without an owner,
166      * thereby removing any functionality that is only available to the owner.
167      */
168     function renounceOwnership() public virtual onlyOwner {
169         _transferOwnership(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _transferOwnership(newOwner);
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Internal function without access restriction.
184      */
185     function _transferOwnership(address newOwner) internal virtual {
186         address oldOwner = _owner;
187         _owner = newOwner;
188         emit OwnershipTransferred(oldOwner, newOwner);
189     }
190 }
191 
192 
193 
194 
195 
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
201  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
202  *
203  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
204  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
205  * need to send a transaction, and thus is not required to hold Ether at all.
206  */
207 interface IERC20Permit {
208     /**
209      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
210      * given ``owner``'s signed approval.
211      *
212      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
213      * ordering also apply here.
214      *
215      * Emits an {Approval} event.
216      *
217      * Requirements:
218      *
219      * - `spender` cannot be the zero address.
220      * - `deadline` must be a timestamp in the future.
221      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
222      * over the EIP712-formatted function arguments.
223      * - the signature must use ``owner``'s current nonce (see {nonces}).
224      *
225      * For more information on the signature format, see the
226      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
227      * section].
228      */
229     function permit(
230         address owner,
231         address spender,
232         uint256 value,
233         uint256 deadline,
234         uint8 v,
235         bytes32 r,
236         bytes32 s
237     ) external;
238 
239     /**
240      * @dev Returns the current nonce for `owner`. This value must be
241      * included whenever a signature is generated for {permit}.
242      *
243      * Every successful call to {permit} increases ``owner``'s nonce by one. This
244      * prevents a signature from being used multiple times.
245      */
246     function nonces(address owner) external view returns (uint256);
247 
248     /**
249      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
250      */
251     // solhint-disable-next-line func-name-mixedcase
252     function DOMAIN_SEPARATOR() external view returns (bytes32);
253 }
254 
255 
256 
257 
258 
259 
260 pragma solidity ^0.8.1;
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      *
283      * [IMPORTANT]
284      * ====
285      * You shouldn't rely on `isContract` to protect against flash loan attacks!
286      *
287      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
288      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
289      * constructor.
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // This method relies on extcodesize/address.code.length, which returns 0
294         // for contracts in construction, since the code is only stored at the end
295         // of the constructor execution.
296 
297         return account.code.length > 0;
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         (bool success, ) = recipient.call{value: amount}("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 
323     /**
324      * @dev Performs a Solidity function call using a low level `call`. A
325      * plain `call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         require(isContract(target), "Address: call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.call{value: value}(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
404         return functionStaticCall(target, data, "Address: low-level static call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(isContract(target), "Address: delegate call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.delegatecall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
453      * revert reason using the provided one.
454      *
455      * _Available since v4.3._
456      */
457     function verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) internal pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468                 /// @solidity memory-safe-assembly
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 
481 
482 
483 
484 
485 pragma solidity ^0.8.0;
486 
487 
488 
489 /**
490  * @title SafeERC20
491  * @dev Wrappers around ERC20 operations that throw on failure (when the token
492  * contract returns false). Tokens that return no value (and instead revert or
493  * throw on failure) are also supported, non-reverting calls are assumed to be
494  * successful.
495  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
496  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
497  */
498 library SafeERC20 {
499     using Address for address;
500 
501     function safeTransfer(
502         IERC20 token,
503         address to,
504         uint256 value
505     ) internal {
506         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
507     }
508 
509     function safeTransferFrom(
510         IERC20 token,
511         address from,
512         address to,
513         uint256 value
514     ) internal {
515         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
516     }
517 
518     /**
519      * @dev Deprecated. This function has issues similar to the ones found in
520      * {IERC20-approve}, and its usage is discouraged.
521      *
522      * Whenever possible, use {safeIncreaseAllowance} and
523      * {safeDecreaseAllowance} instead.
524      */
525     function safeApprove(
526         IERC20 token,
527         address spender,
528         uint256 value
529     ) internal {
530         // safeApprove should only be called when setting an initial allowance,
531         // or when resetting it to zero. To increase and decrease it, use
532         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
533         require(
534             (value == 0) || (token.allowance(address(this), spender) == 0),
535             "SafeERC20: approve from non-zero to non-zero allowance"
536         );
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
538     }
539 
540     function safeIncreaseAllowance(
541         IERC20 token,
542         address spender,
543         uint256 value
544     ) internal {
545         uint256 newAllowance = token.allowance(address(this), spender) + value;
546         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
547     }
548 
549     function safeDecreaseAllowance(
550         IERC20 token,
551         address spender,
552         uint256 value
553     ) internal {
554         unchecked {
555             uint256 oldAllowance = token.allowance(address(this), spender);
556             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
557             uint256 newAllowance = oldAllowance - value;
558             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
559         }
560     }
561 
562     function safePermit(
563         IERC20Permit token,
564         address owner,
565         address spender,
566         uint256 value,
567         uint256 deadline,
568         uint8 v,
569         bytes32 r,
570         bytes32 s
571     ) internal {
572         uint256 nonceBefore = token.nonces(owner);
573         token.permit(owner, spender, value, deadline, v, r, s);
574         uint256 nonceAfter = token.nonces(owner);
575         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
576     }
577 
578     /**
579      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
580      * on the return value: the return value is optional (but if data is returned, it must not be false).
581      * @param token The token targeted by the call.
582      * @param data The call data (encoded using abi.encode or one of its variants).
583      */
584     function _callOptionalReturn(IERC20 token, bytes memory data) private {
585         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
586         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
587         // the target address contains contract code and also asserts for success in the low-level call.
588 
589         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
590         if (returndata.length > 0) {
591             // Return data is optional
592             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
593         }
594     }
595 }
596 
597 
598 
599 
600 
601 
602 pragma solidity ^0.8.0;
603 
604 /**
605  * @dev Contract module that helps prevent reentrant calls to a function.
606  *
607  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
608  * available, which can be applied to functions to make sure there are no nested
609  * (reentrant) calls to them.
610  *
611  * Note that because there is a single `nonReentrant` guard, functions marked as
612  * `nonReentrant` may not call one another. This can be worked around by making
613  * those functions `private`, and then adding `external` `nonReentrant` entry
614  * points to them.
615  *
616  * TIP: If you would like to learn more about reentrancy and alternative ways
617  * to protect against it, check out our blog post
618  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
619  */
620 abstract contract ReentrancyGuard {
621     // Booleans are more expensive than uint256 or any type that takes up a full
622     // word because each write operation emits an extra SLOAD to first read the
623     // slot's contents, replace the bits taken up by the boolean, and then write
624     // back. This is the compiler's defense against contract upgrades and
625     // pointer aliasing, and it cannot be disabled.
626 
627     // The values being non-zero value makes deployment a bit more expensive,
628     // but in exchange the refund on every call to nonReentrant will be lower in
629     // amount. Since refunds are capped to a percentage of the total
630     // transaction's gas, it is best to keep them low in cases like this one, to
631     // increase the likelihood of the full refund coming into effect.
632     uint256 private constant _NOT_ENTERED = 1;
633     uint256 private constant _ENTERED = 2;
634 
635     uint256 private _status;
636 
637     constructor() {
638         _status = _NOT_ENTERED;
639     }
640 
641     /**
642      * @dev Prevents a contract from calling itself, directly or indirectly.
643      * Calling a `nonReentrant` function from another `nonReentrant`
644      * function is not supported. It is possible to prevent this from happening
645      * by making the `nonReentrant` function external, and making it call a
646      * `private` function that does the actual work.
647      */
648     modifier nonReentrant() {
649         // On the first call to nonReentrant, _notEntered will be true
650         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
651 
652         // Any calls to nonReentrant after this point will fail
653         _status = _ENTERED;
654 
655         _;
656 
657         // By storing the original value once again, a refund is triggered (see
658         // https://eips.ethereum.org/EIPS/eip-2200)
659         _status = _NOT_ENTERED;
660     }
661 }
662 
663 
664 
665 
666 contract Staking is Ownable, ReentrancyGuard {
667     using SafeERC20 for IERC20;
668 
669     // Info of each user.
670     struct UserInfo {
671         uint256 amount;     // How many tokens the user has provided.
672         uint256 rewardDebt; // Reward debt. See explanation below.
673         uint256 rewardCredit; // Amount of rewards the user has not yet claimed
674         uint256 lastDepositTime; // latest timestamp of the user's deposit
675     }
676 
677     // Info of each pool.
678     struct PoolInfo {
679         IERC20 lpToken;
680         uint256 allocPoint;
681         uint256 lastRewardBlock;
682         uint256 accRewardsPerShare;
683     }
684 
685     IERC20 public rewardToken;
686 
687     uint256 public rewardsPerBlock;
688 
689     // Info of each pool.
690     PoolInfo public poolInfo;
691     // Info of each user that stakes LP tokens.
692     mapping(address => UserInfo) public userInfo;
693     // Total allocation points. Must be the sum of all allocation points in all pools.
694     uint256 public totalAllocPoint = 0;
695     uint256 public startBlock;
696 
697     uint256 public endBlock;
698     uint256 public constant blockPerSecond = 12;
699     uint256 public minimumStakeDuration = 1 days;
700     uint256 public maxStakeAmount = 0;
701     uint256 public maxTotalStaked = 1e9 ether;
702     address public rewardDistributor;
703     address public tokensReceiver = 0x000000000000000000000000000000000000dEaD;
704     bool public isPoolOpen = true;
705 
706     event Deposit(address indexed user, uint256 amount);
707     event Withdraw(address indexed user, uint256 amount);
708     event EmergencyWithdraw(address indexed user, uint256 amount);
709 
710     constructor(
711         IERC20 _rewardToken,
712         IERC20 depositToken,
713         uint256 _rewardsPerBlock,
714         uint256 _startBlock,
715         uint256 _poolDuration,
716         address _rewardDistributor
717     ) public {
718         rewardToken = _rewardToken;
719         rewardsPerBlock = _rewardsPerBlock;
720         startBlock = _startBlock;
721 
722         endBlock = startBlock + _poolDuration / blockPerSecond;
723         rewardDistributor = _rewardDistributor;
724         // staking pool
725         poolInfo = PoolInfo({
726         lpToken : depositToken,
727         allocPoint : 1000,
728         lastRewardBlock : startBlock,
729         accRewardsPerShare : 0
730         });
731 
732         totalAllocPoint = 1000;
733     }
734 
735     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
736         updatePool();
737         rewardsPerBlock = _rewardPerBlock;
738     }
739 
740     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
741         if (_to > endBlock) {
742             _to = endBlock;
743         }
744         if (_from > endBlock) {
745             _from = endBlock;
746         }
747         return _to - (_from);
748     }
749 
750     function pendingRewards(address _user) external view returns (uint256) {
751         PoolInfo storage pool = poolInfo;
752         UserInfo storage user = userInfo[_user];
753         uint256 accRewardsPerShare = pool.accRewardsPerShare;
754         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
755 
756         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
757             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
758             uint256 rewards = multiplier * (rewardsPerBlock) * (pool.allocPoint) / (totalAllocPoint);
759             accRewardsPerShare += (rewards * (1e12) / (lpSupply));
760         }
761         return (user.amount * (accRewardsPerShare) / (1e12)) - (user.rewardDebt) + user.rewardCredit;
762     }
763 
764     function updatePool() public {
765         PoolInfo storage pool = poolInfo;
766         if (block.number <= pool.lastRewardBlock) {
767             return;
768         }
769         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
770         if (lpSupply == 0) {
771             pool.lastRewardBlock = block.number;
772             return;
773         }
774         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
775         uint256 rewards = multiplier * (rewardsPerBlock) * (pool.allocPoint) / (totalAllocPoint);
776         pool.accRewardsPerShare = pool.accRewardsPerShare + (rewards * 1e12 / lpSupply);
777         pool.lastRewardBlock = block.number;
778     }
779 
780     function deposit(uint256 _amount) public nonReentrant isStakingOpen(_amount) {
781         require(block.number > startBlock && block.number < endBlock, "Pool time: out of range");
782 
783         PoolInfo storage pool = poolInfo;
784         UserInfo storage user = userInfo[msg.sender];
785         updatePool();
786         require(maxStakeAmount == 0 || user.amount + _amount <= maxStakeAmount, "can't stake more than maximum amount");
787         if (user.amount > 0) {
788             uint256 pending = user.amount * (pool.accRewardsPerShare) / (1e12) - (user.rewardDebt);
789             if (pending > 0) {
790                 user.rewardCredit += pending;
791             }
792         }
793         if (_amount > 0) {
794             uint256 tokenBalanceBefore = pool.lpToken.balanceOf(address(this));
795             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
796             uint256 tokenBalanceAfter = pool.lpToken.balanceOf(address(this));
797             require(tokenBalanceAfter - tokenBalanceBefore == _amount, "Staking: need to exclude from fees");
798 
799             user.amount = user.amount + (_amount);
800         }
801         user.rewardDebt = user.amount * (pool.accRewardsPerShare) / (1e12);
802         user.lastDepositTime = block.timestamp;
803         emit Deposit(msg.sender, _amount);
804     }
805 
806     function claimRewards() public nonReentrant {
807         PoolInfo storage pool = poolInfo;
808         UserInfo storage user = userInfo[msg.sender];
809         require(user.amount > 0, "claim rewards: user is not staking");
810         updatePool();
811         uint256 pending = user.amount * (pool.accRewardsPerShare) / (1e12) - (user.rewardDebt) + user.rewardCredit;
812         require(pending > 0, "claim rewards: no rewards to claim");
813         user.rewardDebt = user.amount * (pool.accRewardsPerShare) / (1e12);
814         user.rewardCredit = 0;
815         _claimRewards(pool, user, pending);
816     }
817 
818     function withdraw(uint256 _amount) public nonReentrant {
819         PoolInfo storage pool = poolInfo;
820         UserInfo storage user = userInfo[msg.sender];
821         require(user.amount >= _amount, "withdraw: invalid amount");
822         updatePool();
823         uint256 pending = user.amount * (pool.accRewardsPerShare) / (1e12) - (user.rewardDebt) + user.rewardCredit;
824 
825         if (_amount > 0) {
826             user.amount = user.amount - (_amount);
827             pool.lpToken.safeTransfer(address(msg.sender), _amount);
828         }
829 
830         user.rewardDebt = user.amount * (pool.accRewardsPerShare) / (1e12);
831         user.rewardCredit = 0;
832         _claimRewards(pool, user, pending);
833         emit Withdraw(msg.sender, _amount);
834     }
835 
836     function emergencyWithdraw() public nonReentrant {
837         PoolInfo storage pool = poolInfo;
838         UserInfo storage user = userInfo[msg.sender];
839         uint256 amount = user.amount;
840         require(amount > 0, "no tokens to withdraw");
841 
842         user.amount = 0;
843         user.rewardDebt = 0;
844         user.rewardCredit = 0;
845 
846         pool.lpToken.safeTransfer(address(msg.sender), amount);
847         emit EmergencyWithdraw(msg.sender, amount);
848     }
849 
850     function _sendRewards(address to, uint256 amount) internal {
851         rewardToken.safeTransferFrom(rewardDistributor, to, amount);
852     }
853 
854     function _claimRewards(PoolInfo memory pool, UserInfo memory user, uint256 pending) internal {
855         if (pending > 0) {
856             address to = msg.sender;
857             if (block.timestamp < user.lastDepositTime + minimumStakeDuration) {
858                 // burn tokens if user didn't stake for min time
859                 to = tokensReceiver;
860             }
861             _sendRewards(to, pending);
862         }
863     }
864 
865     function setMinimumStakeDuration(uint256 _seconds) external onlyOwner {
866         require(_seconds < 30 days, "minimum too long");
867         minimumStakeDuration = _seconds;
868     }
869 
870     function setStartBlock(uint256 _blockNumber) external onlyOwner {
871         require(startBlock > block.number, "pool has already started");
872         require(_blockNumber > block.number, "pool should start in the future");
873 
874         startBlock = _blockNumber;
875         PoolInfo storage pool = poolInfo;
876         pool.lastRewardBlock = startBlock;
877     }
878 
879     function setEndBlock(uint256 _blockNumber) external onlyOwner {
880         require(endBlock > block.number, "pool is already over");
881         require(_blockNumber > block.number, "pool should end in the future");
882 
883         endBlock = _blockNumber;
884     }
885 
886     function setRewardDistributor(address a) external onlyOwner {
887         rewardDistributor = a;
888     }
889 
890     function setMaxStakeAmount(uint256 amount) external onlyOwner {
891         maxStakeAmount = amount;
892     }
893 
894     function setMaxTotalStaked(uint256 amount) external onlyOwner {
895         maxTotalStaked = amount;
896     }
897 
898     function setTokensReceiver(address to) external onlyOwner {
899         tokensReceiver = to;
900     }
901 
902     function setPoolStatus(bool status) external onlyOwner {
903         isPoolOpen = status;
904     }
905 
906     function isPoolOpened_() external view returns (bool) {
907         PoolInfo storage pool = poolInfo;
908         uint256 supply = pool.lpToken.balanceOf(address(this));
909         return supply <= maxTotalStaked && isPoolOpen && (block.number > startBlock && block.number < endBlock);
910     }
911 
912     modifier isStakingOpen(uint256 depositAmount) {
913         PoolInfo storage pool = poolInfo;
914         uint256 supply = pool.lpToken.balanceOf(address(this)) + depositAmount;
915         require(isPoolOpen, 'Pool is closed');
916         require(supply <= maxTotalStaked, "Pool is currently full");
917         _;
918     }
919 
920 }