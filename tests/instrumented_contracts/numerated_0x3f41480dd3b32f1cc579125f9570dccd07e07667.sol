1 // SPDX-License-Identifier: GPL-3.0-or-later
2 // Sources flattened with hardhat v2.9.3 https://hardhat.org
3 
4 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `to`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address to, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `from` to `to` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address from,
69         address to,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
90 
91 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
92 
93 pragma solidity ^0.8.1;
94 
95 /**
96  * @dev Collection of functions related to the address type
97  */
98 library Address {
99     /**
100      * @dev Returns true if `account` is a contract.
101      *
102      * [IMPORTANT]
103      * ====
104      * It is unsafe to assume that an address for which this function returns
105      * false is an externally-owned account (EOA) and not a contract.
106      *
107      * Among others, `isContract` will return false for the following
108      * types of addresses:
109      *
110      *  - an externally-owned account
111      *  - a contract in construction
112      *  - an address where a contract will be created
113      *  - an address where a contract lived, but was destroyed
114      * ====
115      *
116      * [IMPORTANT]
117      * ====
118      * You shouldn't rely on `isContract` to protect against flash loan attacks!
119      *
120      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
121      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
122      * constructor.
123      * ====
124      */
125     function isContract(address account) internal view returns (bool) {
126         // This method relies on extcodesize/address.code.length, which returns 0
127         // for contracts in construction, since the code is only stored at the end
128         // of the constructor execution.
129 
130         return account.code.length > 0;
131     }
132 
133     /**
134      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
135      * `recipient`, forwarding all available gas and reverting on errors.
136      *
137      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
138      * of certain opcodes, possibly making contracts go over the 2300 gas limit
139      * imposed by `transfer`, making them unable to receive funds via
140      * `transfer`. {sendValue} removes this limitation.
141      *
142      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
143      *
144      * IMPORTANT: because control is transferred to `recipient`, care must be
145      * taken to not create reentrancy vulnerabilities. Consider using
146      * {ReentrancyGuard} or the
147      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
148      */
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(address(this).balance >= amount, "Address: insufficient balance");
151 
152         (bool success, ) = recipient.call{value: amount}("");
153         require(success, "Address: unable to send value, recipient may have reverted");
154     }
155 
156     /**
157      * @dev Performs a Solidity function call using a low level `call`. A
158      * plain `call` is an unsafe replacement for a function call: use this
159      * function instead.
160      *
161      * If `target` reverts with a revert reason, it is bubbled up by this
162      * function (like regular Solidity function calls).
163      *
164      * Returns the raw returned data. To convert to the expected return value,
165      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
166      *
167      * Requirements:
168      *
169      * - `target` must be a contract.
170      * - calling `target` with `data` must not revert.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionCall(target, data, "Address: low-level call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
180      * `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but also transferring `value` wei to `target`.
195      *
196      * Requirements:
197      *
198      * - the calling contract must have an ETH balance of at least `value`.
199      * - the called Solidity function must be `payable`.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
213      * with `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value,
221         string memory errorMessage
222     ) internal returns (bytes memory) {
223         require(address(this).balance >= value, "Address: insufficient balance for call");
224         require(isContract(target), "Address: call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.call{value: value}(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
237         return functionStaticCall(target, data, "Address: low-level static call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal view returns (bytes memory) {
251         require(isContract(target), "Address: static call to non-contract");
252 
253         (bool success, bytes memory returndata) = target.staticcall(data);
254         return verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         require(isContract(target), "Address: delegate call to non-contract");
279 
280         (bool success, bytes memory returndata) = target.delegatecall(data);
281         return verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
286      * revert reason using the provided one.
287      *
288      * _Available since v4.3._
289      */
290     function verifyCallResult(
291         bool success,
292         bytes memory returndata,
293         string memory errorMessage
294     ) internal pure returns (bytes memory) {
295         if (success) {
296             return returndata;
297         } else {
298             // Look for revert reason and bubble it up if present
299             if (returndata.length > 0) {
300                 // The easiest way to bubble the revert reason is using memory via assembly
301 
302                 assembly {
303                     let returndata_size := mload(returndata)
304                     revert(add(32, returndata), returndata_size)
305                 }
306             } else {
307                 revert(errorMessage);
308             }
309         }
310     }
311 }
312 
313 
314 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
315 
316 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 
321 /**
322  * @title SafeERC20
323  * @dev Wrappers around ERC20 operations that throw on failure (when the token
324  * contract returns false). Tokens that return no value (and instead revert or
325  * throw on failure) are also supported, non-reverting calls are assumed to be
326  * successful.
327  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
328  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
329  */
330 library SafeERC20 {
331     using Address for address;
332 
333     function safeTransfer(
334         IERC20 token,
335         address to,
336         uint256 value
337     ) internal {
338         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
339     }
340 
341     function safeTransferFrom(
342         IERC20 token,
343         address from,
344         address to,
345         uint256 value
346     ) internal {
347         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
348     }
349 
350     /**
351      * @dev Deprecated. This function has issues similar to the ones found in
352      * {IERC20-approve}, and its usage is discouraged.
353      *
354      * Whenever possible, use {safeIncreaseAllowance} and
355      * {safeDecreaseAllowance} instead.
356      */
357     function safeApprove(
358         IERC20 token,
359         address spender,
360         uint256 value
361     ) internal {
362         // safeApprove should only be called when setting an initial allowance,
363         // or when resetting it to zero. To increase and decrease it, use
364         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
365         require(
366             (value == 0) || (token.allowance(address(this), spender) == 0),
367             "SafeERC20: approve from non-zero to non-zero allowance"
368         );
369         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
370     }
371 
372     function safeIncreaseAllowance(
373         IERC20 token,
374         address spender,
375         uint256 value
376     ) internal {
377         uint256 newAllowance = token.allowance(address(this), spender) + value;
378         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
379     }
380 
381     function safeDecreaseAllowance(
382         IERC20 token,
383         address spender,
384         uint256 value
385     ) internal {
386         unchecked {
387             uint256 oldAllowance = token.allowance(address(this), spender);
388             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
389             uint256 newAllowance = oldAllowance - value;
390             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
391         }
392     }
393 
394     /**
395      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
396      * on the return value: the return value is optional (but if data is returned, it must not be false).
397      * @param token The token targeted by the call.
398      * @param data The call data (encoded using abi.encode or one of its variants).
399      */
400     function _callOptionalReturn(IERC20 token, bytes memory data) private {
401         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
402         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
403         // the target address contains contract code and also asserts for success in the low-level call.
404 
405         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
406         if (returndata.length > 0) {
407             // Return data is optional
408             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
409         }
410     }
411 }
412 
413 
414 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
415 
416 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 /**
421  * @dev Provides information about the current execution context, including the
422  * sender of the transaction and its data. While these are generally available
423  * via msg.sender and msg.data, they should not be accessed in such a direct
424  * manner, since when dealing with meta-transactions the account sending and
425  * paying for execution may not be the actual sender (as far as an application
426  * is concerned).
427  *
428  * This contract is only required for intermediate, library-like contracts.
429  */
430 abstract contract Context {
431     function _msgSender() internal view virtual returns (address) {
432         return msg.sender;
433     }
434 
435     function _msgData() internal view virtual returns (bytes calldata) {
436         return msg.data;
437     }
438 }
439 
440 
441 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
442 
443 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @dev Contract module which provides a basic access control mechanism, where
449  * there is an account (an owner) that can be granted exclusive access to
450  * specific functions.
451  *
452  * By default, the owner account will be the one that deploys the contract. This
453  * can later be changed with {transferOwnership}.
454  *
455  * This module is used through inheritance. It will make available the modifier
456  * `onlyOwner`, which can be applied to your functions to restrict their use to
457  * the owner.
458  */
459 abstract contract Ownable is Context {
460     address private _owner;
461 
462     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
463 
464     /**
465      * @dev Initializes the contract setting the deployer as the initial owner.
466      */
467     constructor() {
468         _transferOwnership(_msgSender());
469     }
470 
471     /**
472      * @dev Returns the address of the current owner.
473      */
474     function owner() public view virtual returns (address) {
475         return _owner;
476     }
477 
478     /**
479      * @dev Throws if called by any account other than the owner.
480      */
481     modifier onlyOwner() {
482         require(owner() == _msgSender(), "Ownable: caller is not the owner");
483         _;
484     }
485 
486     /**
487      * @dev Leaves the contract without owner. It will not be possible to call
488      * `onlyOwner` functions anymore. Can only be called by the current owner.
489      *
490      * NOTE: Renouncing ownership will leave the contract without an owner,
491      * thereby removing any functionality that is only available to the owner.
492      */
493     function renounceOwnership() public virtual onlyOwner {
494         _transferOwnership(address(0));
495     }
496 
497     /**
498      * @dev Transfers ownership of the contract to a new account (`newOwner`).
499      * Can only be called by the current owner.
500      */
501     function transferOwnership(address newOwner) public virtual onlyOwner {
502         require(newOwner != address(0), "Ownable: new owner is the zero address");
503         _transferOwnership(newOwner);
504     }
505 
506     /**
507      * @dev Transfers ownership of the contract to a new account (`newOwner`).
508      * Internal function without access restriction.
509      */
510     function _transferOwnership(address newOwner) internal virtual {
511         address oldOwner = _owner;
512         _owner = newOwner;
513         emit OwnershipTransferred(oldOwner, newOwner);
514     }
515 }
516 
517 
518 // File interfaces/tokenomics/ICNCToken.sol
519 
520 pragma solidity ^0.8.13;
521 
522 interface ICNCToken is IERC20 {
523     event MinterAdded(address minter);
524     event MinterRemoved(address minter);
525     event InitialDistributionMinted(uint256 amount);
526     event AirdropMinted(uint256 amount);
527     event AMMRewardsMinted(uint256 amount);
528     event TreasuryRewardsMinted(uint256 amount);
529     event SeedShareMinted(uint256 amount);
530 
531     /// @notice mints the initial distribution amount to the distribution contract
532     function mintInitialDistribution(address distribution) external;
533 
534     /// @notice mints the airdrop amount to the airdrop contract
535     function mintAirdrop(address airdropHandler) external;
536 
537     /// @notice mints the amm rewards
538     function mintAMMRewards(address ammGauge) external;
539 
540     /// @notice mints `amount` to `account`
541     function mint(address account, uint256 amount) external returns (uint256);
542 
543     /// @notice returns a list of all authorized minters
544     function listMinters() external view returns (address[] memory);
545 
546     /// @notice returns the ratio of inflation already minted
547     function inflationMintedRatio() external view returns (uint256);
548 }
549 
550 
551 // File interfaces/tokenomics/ICNCVoteLocker.sol
552 
553 pragma solidity ^0.8.13;
554 
555 interface ICNCVoteLocker {
556     event Locked(
557         address indexed account,
558         uint256 amount,
559         uint256 unlockTime,
560         bool relocked
561     );
562     event UnlockExecuted(address indexed account, uint256 amount);
563 
564     function lock(uint256 amount) external;
565 
566     function lock(uint256 amount, bool relock) external;
567 
568     function shutDown() external;
569 
570     function recoverToken(address token) external;
571 
572     function executeAvailableUnlocks() external returns (uint256);
573 
574     function balanceOf(address user) external view returns (uint256);
575 
576     function unlockableBalance(address user) external view returns (uint256);
577 }
578 
579 
580 // File contracts/tokenomics/CNCVoteLocker.sol
581 
582 pragma solidity ^0.8.13;
583 
584 
585 
586 contract CNCVoteLocker is ICNCVoteLocker, Ownable {
587     using SafeERC20 for ICNCToken;
588     using SafeERC20 for IERC20;
589     struct VoteLock {
590         uint256 amount;
591         uint256 unlockTime;
592     }
593 
594     uint256 public constant UNLOCK_DELAY = 120 days;
595 
596     ICNCToken public immutable cncToken;
597 
598     mapping(address => uint256) public lockedBalance;
599     mapping(address => VoteLock[]) public voteLocks;
600     uint256 public totalLocked;
601     bool public isShutdown;
602     address public immutable treasury;
603 
604     constructor(address _cncToken, address _treasury) Ownable() {
605         cncToken = ICNCToken(_cncToken);
606         treasury = _treasury;
607     }
608 
609     function lock(uint256 amount) external override {
610         lock(amount, true);
611     }
612 
613     function lock(uint256 amount, bool relock) public override {
614         require(!isShutdown, "Locker suspended");
615         cncToken.safeTransferFrom(msg.sender, address(this), amount);
616         uint256 unlockTime = block.timestamp + UNLOCK_DELAY;
617 
618         if (relock) {
619             delete voteLocks[msg.sender];
620             voteLocks[msg.sender].push(VoteLock(lockedBalance[msg.sender] + amount, unlockTime));
621         } else {
622             voteLocks[msg.sender].push(VoteLock(amount, unlockTime));
623         }
624         totalLocked += amount;
625         lockedBalance[msg.sender] += amount;
626         emit Locked(msg.sender, amount, unlockTime, relock);
627     }
628 
629     function shutDown() external override onlyOwner {
630         require(!isShutdown, "Locker already suspended");
631         isShutdown = true;
632     }
633 
634     function recoverToken(address token) external override {
635         require(token != address(cncToken), "Cannot withdraw CNC token");
636         IERC20 _token = IERC20(token);
637         _token.safeTransfer(treasury, _token.balanceOf(address(this)));
638     }
639 
640     function executeAvailableUnlocks() external override returns (uint256) {
641         uint256 sumUnlockable = 0;
642         VoteLock[] storage _pending = voteLocks[msg.sender];
643         uint256 i = _pending.length;
644         while (i > 0) {
645             i = i - 1;
646             if (_pending[i].unlockTime <= block.timestamp) {
647                 sumUnlockable += _pending[i].amount;
648 
649                 _pending[i] = _pending[_pending.length - 1];
650 
651                 _pending.pop();
652             }
653         }
654         totalLocked -= sumUnlockable;
655         lockedBalance[msg.sender] -= sumUnlockable;
656         cncToken.safeTransfer(msg.sender, sumUnlockable);
657         emit UnlockExecuted(msg.sender, sumUnlockable);
658         return sumUnlockable;
659     }
660 
661     function unlockableBalance(address user) public view override returns (uint256) {
662         uint256 sumUnlockable = 0;
663         VoteLock[] storage _pending = voteLocks[user];
664         uint256 length = _pending.length;
665         uint256 i = length;
666         while (i > 0) {
667             i = i - 1;
668             if (_pending[i].unlockTime <= block.timestamp) {
669                 sumUnlockable += _pending[i].amount;
670             }
671         }
672         return sumUnlockable;
673     }
674 
675     function balanceOf(address user) external view override returns (uint256) {
676         return lockedBalance[user] - unlockableBalance(user);
677     }
678 }