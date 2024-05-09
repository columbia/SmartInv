1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 pragma abicoder v2;
4 
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `to`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address to, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `from` to `to` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(
60         address from,
61         address to,
62         uint256 amount
63     ) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 interface IERC20Metadata is IERC20 {
81     /**
82      * @dev Returns the name of the token.
83      */
84     function name() external view returns (string memory);
85 
86     /**
87      * @dev Returns the symbol of the token.
88      */
89     function symbol() external view returns (string memory);
90 
91     /**
92      * @dev Returns the decimals places of the token.
93      */
94     function decimals() external view returns (uint8);
95 }
96 
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      *
115      * [IMPORTANT]
116      * ====
117      * You shouldn't rely on `isContract` to protect against flash loan attacks!
118      *
119      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
120      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
121      * constructor.
122      * ====
123      */
124     function isContract(address account) internal view returns (bool) {
125         // This method relies on extcodesize/address.code.length, which returns 0
126         // for contracts in construction, since the code is only stored at the end
127         // of the constructor execution.
128 
129         return account.code.length > 0;
130     }
131 
132     /**
133      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
134      * `recipient`, forwarding all available gas and reverting on errors.
135      *
136      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
137      * of certain opcodes, possibly making contracts go over the 2300 gas limit
138      * imposed by `transfer`, making them unable to receive funds via
139      * `transfer`. {sendValue} removes this limitation.
140      *
141      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
142      *
143      * IMPORTANT: because control is transferred to `recipient`, care must be
144      * taken to not create reentrancy vulnerabilities. Consider using
145      * {ReentrancyGuard} or the
146      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
147      */
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain `call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         require(isContract(target), "Address: call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.call{value: value}(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
236         return functionStaticCall(target, data, "Address: low-level static call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal view returns (bytes memory) {
250         require(isContract(target), "Address: static call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.staticcall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(isContract(target), "Address: delegate call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
285      * revert reason using the provided one.
286      *
287      * _Available since v4.3._
288      */
289     function verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300 
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 
312 abstract contract Context {
313     function _msgSender() internal view virtual returns (address) {
314         return msg.sender;
315     }
316 
317     function _msgData() internal view virtual returns (bytes calldata) {
318         return msg.data;
319     }
320 }
321 
322 abstract contract Ownable is Context {
323     address private _owner;
324 
325     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
326 
327     /**
328      * @dev Initializes the contract setting the deployer as the initial owner.
329      */
330     constructor() {
331         _transferOwnership(_msgSender());
332     }
333 
334     /**
335      * @dev Returns the address of the current owner.
336      */
337     function owner() public view virtual returns (address) {
338         return _owner;
339     }
340 
341     /**
342      * @dev Throws if called by any account other than the owner.
343      */
344     modifier onlyOwner() {
345         require(owner() == _msgSender(), "Ownable: caller is not the owner");
346         _;
347     }
348 
349     /**
350      * @dev Leaves the contract without owner. It will not be possible to call
351      * `onlyOwner` functions anymore. Can only be called by the current owner.
352      *
353      * NOTE: Renouncing ownership will leave the contract without an owner,
354      * thereby removing any functionality that is only available to the owner.
355      */
356     function renounceOwnership() public virtual onlyOwner {
357         _transferOwnership(address(0));
358     }
359 
360     /**
361      * @dev Transfers ownership of the contract to a new account (`newOwner`).
362      * Can only be called by the current owner.
363      */
364     function transferOwnership(address newOwner) public virtual onlyOwner {
365         require(newOwner != address(0), "Ownable: new owner is the zero address");
366         _transferOwnership(newOwner);
367     }
368 
369     /**
370      * @dev Transfers ownership of the contract to a new account (`newOwner`).
371      * Internal function without access restriction.
372      */
373     function _transferOwnership(address newOwner) internal virtual {
374         address oldOwner = _owner;
375         _owner = newOwner;
376         emit OwnershipTransferred(oldOwner, newOwner);
377     }
378 }
379 
380 abstract contract ReentrancyGuard {
381     // Booleans are more expensive than uint256 or any type that takes up a full
382     // word because each write operation emits an extra SLOAD to first read the
383     // slot's contents, replace the bits taken up by the boolean, and then write
384     // back. This is the compiler's defense against contract upgrades and
385     // pointer aliasing, and it cannot be disabled.
386 
387     // The values being non-zero value makes deployment a bit more expensive,
388     // but in exchange the refund on every call to nonReentrant will be lower in
389     // amount. Since refunds are capped to a percentage of the total
390     // transaction's gas, it is best to keep them low in cases like this one, to
391     // increase the likelihood of the full refund coming into effect.
392     uint256 private constant _NOT_ENTERED = 1;
393     uint256 private constant _ENTERED = 2;
394 
395     uint256 private _status;
396 
397     constructor() {
398         _status = _NOT_ENTERED;
399     }
400 
401     /**
402      * @dev Prevents a contract from calling itself, directly or indirectly.
403      * Calling a `nonReentrant` function from another `nonReentrant`
404      * function is not supported. It is possible to prevent this from happening
405      * by making the `nonReentrant` function external, and making it call a
406      * `private` function that does the actual work.
407      */
408     modifier nonReentrant() {
409         // On the first call to nonReentrant, _notEntered will be true
410         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
411 
412         // Any calls to nonReentrant after this point will fail
413         _status = _ENTERED;
414 
415         _;
416 
417         // By storing the original value once again, a refund is triggered (see
418         // https://eips.ethereum.org/EIPS/eip-2200)
419         _status = _NOT_ENTERED;
420     }
421 }
422 
423 library SafeERC20 {
424     using Address for address;
425 
426     function safeTransfer(
427         IERC20 token,
428         address to,
429         uint256 value
430     ) internal {
431         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
432     }
433 
434     function safeTransferFrom(
435         IERC20 token,
436         address from,
437         address to,
438         uint256 value
439     ) internal {
440         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
441     }
442 
443     /**
444      * @dev Deprecated. This function has issues similar to the ones found in
445      * {IERC20-approve}, and its usage is discouraged.
446      *
447      * Whenever possible, use {safeIncreaseAllowance} and
448      * {safeDecreaseAllowance} instead.
449      */
450     function safeApprove(
451         IERC20 token,
452         address spender,
453         uint256 value
454     ) internal {
455         // safeApprove should only be called when setting an initial allowance,
456         // or when resetting it to zero. To increase and decrease it, use
457         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
458         require(
459             (value == 0) || (token.allowance(address(this), spender) == 0),
460             "SafeERC20: approve from non-zero to non-zero allowance"
461         );
462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
463     }
464 
465     function safeIncreaseAllowance(
466         IERC20 token,
467         address spender,
468         uint256 value
469     ) internal {
470         uint256 newAllowance = token.allowance(address(this), spender) + value;
471         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
472     }
473 
474     function safeDecreaseAllowance(
475         IERC20 token,
476         address spender,
477         uint256 value
478     ) internal {
479     unchecked {
480         uint256 oldAllowance = token.allowance(address(this), spender);
481         require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
482         uint256 newAllowance = oldAllowance - value;
483         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
484     }
485     }
486 
487     /**
488      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
489      * on the return value: the return value is optional (but if data is returned, it must not be false).
490      * @param token The token targeted by the call.
491      * @param data The call data (encoded using abi.encode or one of its variants).
492      */
493     function _callOptionalReturn(IERC20 token, bytes memory data) private {
494         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
495         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
496         // the target address contains contract code and also asserts for success in the low-level call.
497 
498         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
499         if (returndata.length > 0) {
500             // Return data is optional
501             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
502         }
503     }
504 }
505 
506 interface IPancakeProfile {
507     function createProfile(
508         uint256 _teamId,
509         address _nftAddress,
510         uint256 _tokenId
511     ) external;
512 
513     function increaseUserPoints(
514         address _userAddress,
515         uint256 _numberPoints,
516         uint256 _campaignId
517     ) external;
518 
519     function removeUserPoints(address _userAddress, uint256 _numberPoints) external;
520 
521     function addNftAddress(address _nftAddress) external;
522 
523     function addTeam(string calldata _teamName, string calldata _teamDescription) external;
524 
525     function getUserProfile(address _userAddress)
526     external
527     view
528     returns (
529         uint256,
530         uint256,
531         uint256,
532         address,
533         uint256,
534         bool
535     );
536 
537     function getUserStatus(address _userAddress) external view returns (bool);
538 
539     function getTeamProfile(uint256 _teamId)
540     external
541     view
542     returns (
543         string memory,
544         string memory,
545         uint256,
546         uint256,
547         bool
548     );
549 }
550 
551 contract SmartChefInitializable is Ownable, ReentrancyGuard {
552     using SafeERC20 for IERC20Metadata;
553 
554     // The address of the smart chef factory
555     address public immutable SMART_CHEF_FACTORY;
556 
557     // Whether a limit is set for users
558     bool public userLimit;
559 
560     // Whether it is initialized
561     bool public isInitialized;
562 
563     // Accrued token per share
564     uint256 public accTokenPerShare;
565 
566     // The block timestamp when CAKE mining ends
567     uint256 public endTimestamp;
568 
569     // The block timestamp when CAKE mining starts
570     uint256 public startTimestamp;
571 
572     // The block timestamp of the last pool update
573     uint256 public lastRewardTimestamp;
574 
575     // The pool limit (0 if none)
576     uint256 public poolLimitPerUser;
577 
578     // Seconds available for user limit (after start timestamp)
579     uint256 public numberSecondsForUserLimit;
580 
581     // Pancake profile address
582     address public immutable pancakeProfile;
583 
584     // Pancake Profile is requested
585     bool public pancakeProfileIsRequested;
586 
587     // Pancake Profile points threshold
588     uint256 public pancakeProfileThresholdPoints;
589 
590     // CAKE tokens created per second
591     uint256 public rewardPerSecond;
592 
593     // The precision factor
594     uint256 public PRECISION_FACTOR;
595 
596     // The reward token
597     IERC20Metadata public rewardToken;
598 
599     // The staked token
600     IERC20Metadata public stakedToken;
601 
602     // Info of each user that stakes tokens (stakedToken)
603     mapping(address => UserInfo) public userInfo;
604 
605     struct UserInfo {
606         uint256 amount; // How many staked tokens the user has provided
607         uint256 rewardDebt;
608     }
609 
610     event Deposit(address indexed user, uint256 amount);
611     event EmergencyWithdraw(address indexed user, uint256 amount);
612     event NewStartAndEndTimestamp(uint256 startTimestamp, uint256 endTimestamp);
613     event NewRewardPerSecond(uint256 rewardPerSecond);
614     event NewPoolLimit(uint256 poolLimitPerUser);
615     event RewardsStop(uint256 blockNumber);
616     event TokenRecovery(address indexed token, uint256 amount);
617     event Withdraw(address indexed user, uint256 amount);
618     event UpdateProfileAndThresholdPointsRequirement(bool isProfileRequested, uint256 thresholdPoints);
619 
620     /**
621      * @notice Constructor
622      * @param _pancakeProfile: Pancake Profile address
623      * @param _pancakeProfileIsRequested: Pancake Profile is requested
624      * @param _pancakeProfileThresholdPoints: Pancake Profile need threshold points
625      */
626     constructor(
627         address _pancakeProfile,
628         bool _pancakeProfileIsRequested,
629         uint256 _pancakeProfileThresholdPoints
630     ) {
631         SMART_CHEF_FACTORY = msg.sender;
632 
633         pancakeProfile = _pancakeProfile; // It can be empty on Other chain
634 
635         if (_pancakeProfile != address(0)) {
636             IPancakeProfile(_pancakeProfile).getTeamProfile(1);
637 
638             // if pancakeProfile is requested
639             pancakeProfileIsRequested = _pancakeProfileIsRequested;
640 
641             // pancakeProfile threshold points when profile & points are requested
642             pancakeProfileThresholdPoints = _pancakeProfileThresholdPoints;
643         } else {
644             pancakeProfileIsRequested = false;
645             pancakeProfileThresholdPoints = 0;
646         }
647     }
648 
649     /*
650      * @notice Initialize the contract
651      * @param _stakedToken: staked token address
652      * @param _rewardToken: reward token address
653      * @param _rewardPerSecond: reward per second (in rewardToken)
654      * @param _startTimestamp: start block timestamp
655      * @param _endTimestamp: end block timestamp
656      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
657      * @param _numberSecondsForUserLimit: seconds available for user limit (after start timestamp)
658      * @param _admin: admin address with ownership
659      */
660     function initialize(
661         IERC20Metadata _stakedToken,
662         IERC20Metadata _rewardToken,
663         uint256 _rewardPerSecond,
664         uint256 _startTimestamp,
665         uint256 _endTimestamp,
666         uint256 _poolLimitPerUser,
667         uint256 _numberSecondsForUserLimit,
668         address _admin
669     ) external {
670         require(!isInitialized, "Already initialized");
671         require(msg.sender == SMART_CHEF_FACTORY, "Not factory");
672         require(_startTimestamp < _endTimestamp, "New startTimestamp must be lower than new endTimestamp");
673         require(block.timestamp < _startTimestamp, "New startTimestamp must be higher than current block timestamp");
674 
675         // Make this contract initialized
676         isInitialized = true;
677 
678         stakedToken = _stakedToken;
679         rewardToken = _rewardToken;
680         rewardPerSecond = _rewardPerSecond;
681         startTimestamp = _startTimestamp;
682         endTimestamp = _endTimestamp;
683 
684         if (_poolLimitPerUser > 0) {
685             userLimit = true;
686             poolLimitPerUser = _poolLimitPerUser;
687             numberSecondsForUserLimit = _numberSecondsForUserLimit;
688         }
689 
690         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
691         require(decimalsRewardToken < 30, "Must be inferior to 30");
692 
693         PRECISION_FACTOR = uint256(10**(uint256(30) - decimalsRewardToken));
694         require(PRECISION_FACTOR * rewardPerSecond / (10**decimalsRewardToken) >= 100_000_000, "rewardPerSecond must be larger");
695 
696         // Set the lastRewardBlock as the startTimestamp
697         lastRewardTimestamp = startTimestamp;
698 
699         // Transfer ownership to the admin address who becomes owner of the contract
700         transferOwnership(_admin);
701     }
702 
703     /*
704      * @notice Deposit staked tokens and collect reward tokens (if any)
705      * @param _amount: amount to withdraw (in rewardToken)
706      */
707     function deposit(uint256 _amount) external nonReentrant {
708         UserInfo storage user = userInfo[msg.sender];
709 
710         if (pancakeProfile != address(0)) {
711             // Checks whether the user has an active profile
712             require(
713                 (!pancakeProfileIsRequested && pancakeProfileThresholdPoints == 0) ||
714                 IPancakeProfile(pancakeProfile).getUserStatus(msg.sender),
715                 "Deposit: Must have an active profile"
716             );
717 
718             uint256 numberUserPoints = 0;
719 
720             if (pancakeProfileThresholdPoints > 0) {
721                 require(pancakeProfile != address(0), "Deposit: PancakeProfile is not exist");
722                 (, numberUserPoints, , , , ) = IPancakeProfile(pancakeProfile).getUserProfile(msg.sender);
723             }
724 
725             require(
726                 pancakeProfileThresholdPoints == 0 || numberUserPoints >= pancakeProfileThresholdPoints,
727                 "Deposit: User is not get enough user points"
728             );
729         }
730 
731         userLimit = hasUserLimit();
732 
733         require(!userLimit || ((_amount + user.amount) <= poolLimitPerUser), "Deposit: Amount above limit");
734 
735         _updatePool();
736 
737         if (user.amount > 0) {
738             uint256 pending = (user.amount * accTokenPerShare) / PRECISION_FACTOR - user.rewardDebt;
739             if (pending > 0) {
740                 rewardToken.safeTransfer(address(msg.sender), pending);
741             }
742         }
743 
744         if (_amount > 0) {
745             user.amount = user.amount + _amount;
746             stakedToken.safeTransferFrom(address(msg.sender), address(this), _amount);
747         }
748 
749         user.rewardDebt = (user.amount * accTokenPerShare) / PRECISION_FACTOR;
750 
751         emit Deposit(msg.sender, _amount);
752     }
753 
754     /*
755      * @notice Withdraw staked tokens and collect reward tokens
756      * @param _amount: amount to withdraw (in rewardToken)
757      */
758     function withdraw(uint256 _amount) external nonReentrant {
759         UserInfo storage user = userInfo[msg.sender];
760         require(user.amount >= _amount, "Amount to withdraw too high");
761 
762         _updatePool();
763 
764         uint256 pending = (user.amount * accTokenPerShare) / PRECISION_FACTOR - user.rewardDebt;
765 
766         if (_amount > 0) {
767             user.amount = user.amount - _amount;
768             stakedToken.safeTransfer(address(msg.sender), _amount);
769         }
770 
771         if (pending > 0) {
772             rewardToken.safeTransfer(address(msg.sender), pending);
773         }
774 
775         user.rewardDebt = (user.amount * accTokenPerShare) / PRECISION_FACTOR;
776 
777         emit Withdraw(msg.sender, _amount);
778     }
779 
780     /*
781      * @notice Withdraw staked tokens without caring about rewards rewards
782      * @dev Needs to be for emergency.
783      */
784     function emergencyWithdraw() external nonReentrant {
785         UserInfo storage user = userInfo[msg.sender];
786         uint256 amountToTransfer = user.amount;
787         user.amount = 0;
788         user.rewardDebt = 0;
789 
790         if (amountToTransfer > 0) {
791             stakedToken.safeTransfer(address(msg.sender), amountToTransfer);
792         }
793 
794         emit EmergencyWithdraw(msg.sender, user.amount);
795     }
796 
797     /*
798      * @notice Stop rewards
799      * @dev Only callable by owner. Needs to be for emergency.
800      */
801     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
802         rewardToken.safeTransfer(address(msg.sender), _amount);
803     }
804 
805     /**
806     * @notice Allows the owner to recover tokens sent to the contract by mistake
807      * @param _token: token address
808      * @dev Callable by owner
809      */
810     function recoverToken(address _token) external onlyOwner {
811         require(_token != address(stakedToken), "Operations: Cannot recover staked token");
812         require(_token != address(rewardToken), "Operations: Cannot recover reward token");
813 
814         uint256 balance = IERC20Metadata(_token).balanceOf(address(this));
815         require(balance != 0, "Operations: Cannot recover zero balance");
816 
817         IERC20Metadata(_token).safeTransfer(address(msg.sender), balance);
818 
819         emit TokenRecovery(_token, balance);
820     }
821 
822     /*
823      * @notice Stop rewards
824      * @dev Only callable by owner
825      */
826     function stopReward() external onlyOwner {
827         endTimestamp = block.timestamp;
828         emit RewardsStop(endTimestamp);
829     }
830 
831     /*
832      * @notice Update pool limit per user
833      * @dev Only callable by owner.
834      * @param _userLimit: whether the limit remains forced
835      * @param _poolLimitPerUser: new pool limit per user
836      */
837     function updatePoolLimitPerUser(bool _userLimit, uint256 _poolLimitPerUser) external onlyOwner {
838         require(userLimit, "Must be set");
839         if (_userLimit) {
840             require(_poolLimitPerUser > poolLimitPerUser, "New limit must be higher");
841             poolLimitPerUser = _poolLimitPerUser;
842         } else {
843             userLimit = _userLimit;
844             poolLimitPerUser = 0;
845         }
846         emit NewPoolLimit(poolLimitPerUser);
847     }
848 
849     /*
850      * @notice Update reward per block
851      * @dev Only callable by owner.
852      * @param _rewardPerSecond: the reward per second
853      */
854     function updateRewardPerSecond(uint256 _rewardPerSecond) external onlyOwner {
855         require(block.timestamp < startTimestamp, "Pool has started");
856         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
857         require(PRECISION_FACTOR * _rewardPerSecond / (10**decimalsRewardToken) >= 100_000_000, "rewardPerSecond must be larger");
858         rewardPerSecond = _rewardPerSecond;
859         emit NewRewardPerSecond(_rewardPerSecond);
860     }
861 
862     /**
863      * @notice It allows the admin to update start and end blocks
864      * @dev This function is only callable by owner.
865      * @param _startTimestamp: the new start block timestamp
866      * @param _endTimestamp: the new end block timestamp
867      */
868     function updateStartAndEndTimestamp(uint256 _startTimestamp, uint256 _endTimestamp) external onlyOwner {
869         require(block.timestamp < startTimestamp, "Pool has started");
870         require(_startTimestamp < _endTimestamp, "New startTimestamp must be lower than new endTimestamp");
871         require(block.timestamp < _startTimestamp, "New startTimestamp must be higher than current block timestamp");
872 
873         startTimestamp = _startTimestamp;
874         endTimestamp = _endTimestamp;
875 
876         // Set the lastRewardTimestamp as the startTimestamp
877         lastRewardTimestamp = startTimestamp;
878 
879         emit NewStartAndEndTimestamp(_startTimestamp, _endTimestamp);
880     }
881 
882     /**
883      * @notice It allows the admin to update profile and thresholdPoints' requirement.
884      * @dev This function is only callable by owner.
885      * @param _isRequested: the profile is requested
886      * @param _thresholdPoints: the threshold points
887      */
888     function updateProfileAndThresholdPointsRequirement(bool _isRequested, uint256 _thresholdPoints)
889     external
890     onlyOwner
891     {
892         require(pancakeProfile != address(0), "Pancake profile address is null");
893         require(_thresholdPoints >= 0, "Threshold points need to exceed 0");
894         pancakeProfileIsRequested = _isRequested;
895         pancakeProfileThresholdPoints = _thresholdPoints;
896         emit UpdateProfileAndThresholdPointsRequirement(_isRequested, _thresholdPoints);
897     }
898 
899     /*
900      * @notice View function to see pending reward on frontend.
901      * @param _user: user address
902      * @return Pending reward for a given user
903      */
904     function pendingReward(address _user) external view returns (uint256) {
905         UserInfo storage user = userInfo[_user];
906         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
907         if (block.timestamp > lastRewardTimestamp && stakedTokenSupply != 0) {
908             uint256 multiplier = _getMultiplier(lastRewardTimestamp, block.timestamp);
909             uint256 cakeReward = multiplier * rewardPerSecond;
910             uint256 adjustedTokenPerShare = accTokenPerShare + (cakeReward * PRECISION_FACTOR) / stakedTokenSupply;
911             return (user.amount * adjustedTokenPerShare) / PRECISION_FACTOR - user.rewardDebt;
912         } else {
913             return (user.amount * accTokenPerShare) / PRECISION_FACTOR - user.rewardDebt;
914         }
915     }
916 
917     /*
918      * @notice Update reward variables of the given pool to be up-to-date.
919      */
920     function _updatePool() internal {
921         if (block.timestamp <= lastRewardTimestamp) {
922             return;
923         }
924 
925         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
926 
927         if (stakedTokenSupply == 0) {
928             lastRewardTimestamp = block.timestamp;
929             return;
930         }
931 
932         uint256 multiplier = _getMultiplier(lastRewardTimestamp, block.timestamp);
933         uint256 cakeReward = multiplier * rewardPerSecond;
934         accTokenPerShare = accTokenPerShare + (cakeReward * PRECISION_FACTOR) / stakedTokenSupply;
935         lastRewardTimestamp = block.timestamp;
936     }
937 
938     /*
939      * @notice Return reward multiplier over the given _from to _to block.
940      * @param _from: block to start
941      * @param _to: block to finish
942      */
943     function _getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
944         if (_to <= endTimestamp) {
945             return _to - _from;
946         } else if (_from >= endTimestamp) {
947             return 0;
948         } else {
949             return endTimestamp - _from;
950         }
951     }
952 
953     /*
954      * @notice Return user limit is set or zero.
955      */
956     function hasUserLimit() public view returns (bool) {
957         if (!userLimit || (block.timestamp >= (startTimestamp + numberSecondsForUserLimit))) {
958             return false;
959         }
960 
961         return true;
962     }
963 }
964 
965 contract SmartChefFactory is Ownable {
966     event NewSmartChefContract(address indexed smartChef);
967 
968     constructor() {
969         //
970     }
971 
972     /*
973      * @notice Deploy the pool
974      * @param _stakedToken: staked token address
975      * @param _rewardToken: reward token address
976      * @param _rewardPerSecond: reward per second (in rewardToken)
977      * @param _startTimestamp: start block timestamp
978      * @param _endTimestamp: end block timestamp
979      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
980      * @param _numberSecondsForUserLimit: seconds available for user limit (after start block)
981      * @param _pancakeProfile: Pancake Profile address
982      * @param _pancakeProfileIsRequested: Pancake Profile is requested
983      * @param _pancakeProfileThresholdPoints: Pancake Profile need threshold points
984      * @param _admin: admin address with ownership
985      * @return address of new smart chef contract
986      */
987     function deployPool(
988         IERC20Metadata _stakedToken,
989         IERC20Metadata _rewardToken,
990         uint256 _rewardPerSecond,
991         uint256 _startTimestamp,
992         uint256 _endTimestamp,
993         uint256 _poolLimitPerUser,
994         uint256 _numberSecondsForUserLimit,
995         address _pancakeProfile,
996         bool _pancakeProfileIsRequested,
997         uint256 _pancakeProfileThresholdPoints,
998         address _admin
999     ) external onlyOwner {
1000         require(_stakedToken.totalSupply() >= 0);
1001         require(_rewardToken.totalSupply() >= 0);
1002         require(_stakedToken != _rewardToken, "Tokens must be be different");
1003 
1004         bytes memory bytecode = type(SmartChefInitializable).creationCode;
1005         // pass constructor argument
1006         bytecode = abi.encodePacked(
1007             bytecode,
1008             abi.encode(_pancakeProfile, _pancakeProfileIsRequested, _pancakeProfileThresholdPoints)
1009         );
1010         bytes32 salt = keccak256(abi.encodePacked(_stakedToken, _rewardToken, _startTimestamp));
1011         address smartChefAddress;
1012 
1013         assembly {
1014             smartChefAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
1015         }
1016 
1017         SmartChefInitializable(smartChefAddress).initialize(
1018             _stakedToken,
1019             _rewardToken,
1020             _rewardPerSecond,
1021             _startTimestamp,
1022             _endTimestamp,
1023             _poolLimitPerUser,
1024             _numberSecondsForUserLimit,
1025             _admin
1026         );
1027 
1028         emit NewSmartChefContract(smartChefAddress);
1029     }
1030 }