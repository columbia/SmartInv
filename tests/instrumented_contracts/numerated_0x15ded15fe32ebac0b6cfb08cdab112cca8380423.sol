1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.8.3;
4 
5 
6 
7 // Part: Address
8 
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      * ====
26      */
27     function isContract(address account) internal view returns (bool) {
28         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
29         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
30         // for accounts without code, i.e. `keccak256('')`
31         bytes32 codehash;
32 
33 
34             bytes32 accountHash
35          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
36         // solhint-disable-next-line no-inline-assembly
37         assembly {
38             codehash := extcodehash(account)
39         }
40         return (codehash != accountHash && codehash != 0x0);
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(
61             address(this).balance >= amount,
62             "Address: insufficient balance"
63         );
64 
65         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
66         (bool success, ) = recipient.call{value: amount}("");
67         require(
68             success,
69             "Address: unable to send value, recipient may have reverted"
70         );
71     }
72 
73     /**
74      * @dev Performs a Solidity function call using a low level `call`. A
75      * plain`call` is an unsafe replacement for a function call: use this
76      * function instead.
77      *
78      * If `target` reverts with a revert reason, it is bubbled up by this
79      * function (like regular Solidity function calls).
80      *
81      * Returns the raw returned data. To convert to the expected return value,
82      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
83      *
84      * Requirements:
85      *
86      * - `target` must be a contract.
87      * - calling `target` with `data` must not revert.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data)
92         internal
93         returns (bytes memory)
94     {
95         return functionCall(target, data, "Address: low-level call failed");
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
100      * `errorMessage` as a fallback revert reason when `target` reverts.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(
105         address target,
106         bytes memory data,
107         string memory errorMessage
108     ) internal returns (bytes memory) {
109         return _functionCallWithValue(target, data, 0, errorMessage);
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
114      * but also transferring `value` wei to `target`.
115      *
116      * Requirements:
117      *
118      * - the calling contract must have an ETH balance of at least `value`.
119      * - the called Solidity function must be `payable`.
120      *
121      * _Available since v3.1._
122      */
123     function functionCallWithValue(
124         address target,
125         bytes memory data,
126         uint256 value
127     ) internal returns (bytes memory) {
128         return
129             functionCallWithValue(
130                 target,
131                 data,
132                 value,
133                 "Address: low-level call with value failed"
134             );
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
139      * with `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(
150             address(this).balance >= value,
151             "Address: insufficient balance for call"
152         );
153         return _functionCallWithValue(target, data, value, errorMessage);
154     }
155 
156     function _functionCallWithValue(
157         address target,
158         bytes memory data,
159         uint256 weiValue,
160         string memory errorMessage
161     ) private returns (bytes memory) {
162         require(isContract(target), "Address: call to non-contract");
163 
164         // solhint-disable-next-line avoid-low-level-calls
165         (bool success, bytes memory returndata) = target.call{value: weiValue}(
166             data
167         );
168         if (success) {
169             return returndata;
170         } else {
171             // Look for revert reason and bubble it up if present
172             if (returndata.length > 0) {
173                 // The easiest way to bubble the revert reason is using memory via assembly
174 
175                 // solhint-disable-next-line no-inline-assembly
176                 assembly {
177                     let returndata_size := mload(returndata)
178                     revert(add(32, returndata), returndata_size)
179                 }
180             } else {
181                 revert(errorMessage);
182             }
183         }
184     }
185 }
186 
187 // Part: IBonusRewards
188 
189 /**
190  * @title Cover Protocol Bonus Token Rewards Interface
191  * @author crypto-pumpkin
192  */
193 interface IBonusRewards {
194     event Deposit(
195         address indexed user,
196         address indexed lpToken,
197         uint256 amount
198     );
199     event Withdraw(
200         address indexed user,
201         address indexed lpToken,
202         uint256 amount
203     );
204 
205     struct Bonus {
206         address bonusTokenAddr; // the external bonus token, like CRV
207         uint48 startTime;
208         uint48 endTime;
209         uint256 weeklyRewards; // total amount to be distributed from start to end
210         uint256 accRewardsPerToken; // accumulated bonus to the lastUpdated Time
211         uint256 remBonus; // remaining bonus in contract
212     }
213 
214     struct Pool {
215         Bonus[] bonuses;
216         uint256 lastUpdatedAt; // last accumulated bonus update timestamp
217         uint256 amount;
218     }
219 
220     struct User {
221         uint256 amount;
222         uint256[] rewardsWriteoffs; // the amount of bonus tokens to write off when calculate rewards from last update
223     }
224 
225     function getPoolList() external view returns (address[] memory);
226 
227     function getResponders() external view returns (address[] memory);
228 
229     function getPool(address _lpToken) external view returns (Pool memory);
230 
231     function getUser(address _lpToken, address _account)
232         external
233         view
234         returns (User memory _user, uint256[] memory _rewards);
235 
236     function getAuthorizers(address _lpToken, address _bonusTokenAddr)
237         external
238         view
239         returns (address[] memory);
240 
241     function viewRewards(address _lpToken, address _user)
242         external
243         view
244         returns (uint256[] memory);
245 
246     function claimRewardsForPools(address[] calldata _lpTokens) external;
247 
248     function deposit(address _lpToken, uint256 _amount) external;
249 
250     function withdraw(address _lpToken, uint256 _amount) external;
251 
252     function emergencyWithdraw(address[] calldata _lpTokens) external;
253 
254     function addBonus(
255         address _lpToken,
256         address _bonusTokenAddr,
257         uint48 _startTime,
258         uint256 _weeklyRewards,
259         uint256 _transferAmount
260     ) external;
261 
262     function extendBonus(
263         address _lpToken,
264         uint256 _poolBonusId,
265         address _bonusTokenAddr,
266         uint256 _transferAmount
267     ) external;
268 
269     function updateBonus(
270         address _lpToken,
271         address _bonusTokenAddr,
272         uint256 _weeklyRewards,
273         uint48 _startTime
274     ) external;
275 
276     // only owner
277     function setResponders(address[] calldata _responders) external;
278 
279     function setPaused(bool _paused) external;
280 
281     function collectDust(
282         address _token,
283         address _lpToken,
284         uint256 _poolBonusId
285     ) external;
286 
287     function addPoolsAndAllowBonus(
288         address[] calldata _lpTokens,
289         address[] calldata _bonusTokenAddrs,
290         address[] calldata _authorizers
291     ) external;
292 }
293 
294 // Part: IERC20
295 
296 /**
297  * @title Interface of the ERC20 standard as defined in the EIP.
298  */
299 interface IERC20 {
300     event Transfer(address indexed from, address indexed to, uint256 value);
301     event Approval(
302         address indexed owner,
303         address indexed spender,
304         uint256 value
305     );
306 
307     function decimals() external view returns (uint8);
308 
309     function balanceOf(address account) external view returns (uint256);
310 
311     function totalSupply() external view returns (uint256);
312 
313     function transfer(address recipient, uint256 amount)
314         external
315         returns (bool);
316 
317     function allowance(address owner, address spender)
318         external
319         view
320         returns (uint256);
321 
322     function approve(address spender, uint256 amount) external returns (bool);
323 
324     function transferFrom(
325         address sender,
326         address recipient,
327         uint256 amount
328     ) external returns (bool);
329 
330     function increaseAllowance(address spender, uint256 addedValue)
331         external
332         returns (bool);
333 
334     function decreaseAllowance(address spender, uint256 subtractedValue)
335         external
336         returns (bool);
337 }
338 
339 // Part: Ownable
340 
341 /**
342  * @dev Contract module which provides a basic access control mechanism, where
343  * there is an account (an owner) that can be granted exclusive access to
344  * specific functions.
345  * @author crypto-pumpkin@github
346  *
347  * By initialization, the owner account will be the one that called initializeOwner. This
348  * can later be changed with {transferOwnership}.
349  */
350 contract Ownable {
351     address private _owner;
352 
353     event OwnershipTransferred(
354         address indexed previousOwner,
355         address indexed newOwner
356     );
357 
358     /**
359      * @dev COVER: Initializes the contract setting the deployer as the initial owner.
360      */
361     constructor() {
362         _owner = msg.sender;
363         emit OwnershipTransferred(address(0), _owner);
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         require(_owner == msg.sender, "Ownable: caller is not the owner");
378         _;
379     }
380 
381     /**
382      * @dev Transfers ownership of the contract to a new account (`newOwner`).
383      * Can only be called by the current owner.
384      */
385     function transferOwnership(address newOwner) public virtual onlyOwner {
386         require(
387             newOwner != address(0),
388             "Ownable: new owner is the zero address"
389         );
390         emit OwnershipTransferred(_owner, newOwner);
391         _owner = newOwner;
392     }
393 }
394 
395 // Part: ReentrancyGuard
396 
397 /**
398  * @dev Contract module that helps prevent reentrant calls to a function.
399  *
400  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
401  * available, which can be applied to functions to make sure there are no nested
402  * (reentrant) calls to them.
403  *
404  * Note that because there is a single `nonReentrant` guard, functions marked as
405  * `nonReentrant` may not call one another. This can be worked around by making
406  * those functions `private`, and then adding `external` `nonReentrant` entry
407  * points to them.
408  *
409  * TIP: If you would like to learn more about reentrancy and alternative ways
410  * to protect against it, check out our blog post
411  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
412  */
413 abstract contract ReentrancyGuard {
414     // Booleans are more expensive than uint256 or any type that takes up a full
415     // word because each write operation emits an extra SLOAD to first read the
416     // slot's contents, replace the bits taken up by the boolean, and then write
417     // back. This is the compiler's defense against contract upgrades and
418     // pointer aliasing, and it cannot be disabled.
419 
420     // The values being non-zero value makes deployment a bit more expensive,
421     // but in exchange the refund on every call to nonReentrant will be lower in
422     // amount. Since refunds are capped to a percentage of the total
423     // transaction's gas, it is best to keep them low in cases like this one, to
424     // increase the likelihood of the full refund coming into effect.
425     uint256 private constant _NOT_ENTERED = 1;
426     uint256 private constant _ENTERED = 2;
427 
428     uint256 private _status;
429 
430     constructor() {
431         _status = _NOT_ENTERED;
432     }
433 
434     /**
435      * @dev Prevents a contract from calling itself, directly or indirectly.
436      * Calling a `nonReentrant` function from another `nonReentrant`
437      * function is not supported. It is possible to prevent this from happening
438      * by making the `nonReentrant` function external, and make it call a
439      * `private` function that does the actual work.
440      */
441     modifier nonReentrant() {
442         // On the first call to nonReentrant, _notEntered will be true
443         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
444 
445         // Any calls to nonReentrant after this point will fail
446         _status = _ENTERED;
447 
448         _;
449 
450         // By storing the original value once again, a refund is triggered (see
451         // https://eips.ethereum.org/EIPS/eip-2200)
452         _status = _NOT_ENTERED;
453     }
454 }
455 
456 // Part: SafeERC20
457 
458 /**
459  * @title SafeERC20
460  * @dev Wrappers around ERC20 operations that throw on failure (when the token
461  * contract returns false). Tokens that return no value (and instead revert or
462  * throw on failure) are also supported, non-reverting calls are assumed to be
463  * successful.
464  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
465  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
466  */
467 library SafeERC20 {
468     using Address for address;
469 
470     function safeTransfer(
471         IERC20 token,
472         address to,
473         uint256 value
474     ) internal {
475         _callOptionalReturn(
476             token,
477             abi.encodeWithSelector(token.transfer.selector, to, value)
478         );
479     }
480 
481     function safeTransferFrom(
482         IERC20 token,
483         address from,
484         address to,
485         uint256 value
486     ) internal {
487         _callOptionalReturn(
488             token,
489             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
490         );
491     }
492 
493     /**
494      * @dev Deprecated. This function has issues similar to the ones found in
495      * {IERC20-approve}, and its usage is discouraged.
496      *
497      * Whenever possible, use {safeIncreaseAllowance} and
498      * {safeDecreaseAllowance} instead.
499      */
500     function safeApprove(
501         IERC20 token,
502         address spender,
503         uint256 value
504     ) internal {
505         // safeApprove should only be called when setting an initial allowance,
506         // or when resetting it to zero. To increase and decrease it, use
507         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
508         // solhint-disable-next-line max-line-length
509         require(
510             (value == 0) || (token.allowance(address(this), spender) == 0),
511             "SafeERC20: approve from non-zero to non-zero allowance"
512         );
513         _callOptionalReturn(
514             token,
515             abi.encodeWithSelector(token.approve.selector, spender, value)
516         );
517     }
518 
519     function safeIncreaseAllowance(
520         IERC20 token,
521         address spender,
522         uint256 value
523     ) internal {
524         uint256 newAllowance = token.allowance(address(this), spender) + value;
525         _callOptionalReturn(
526             token,
527             abi.encodeWithSelector(
528                 token.approve.selector,
529                 spender,
530                 newAllowance
531             )
532         );
533     }
534 
535     function safeDecreaseAllowance(
536         IERC20 token,
537         address spender,
538         uint256 value
539     ) internal {
540         uint256 newAllowance = token.allowance(address(this), spender) - value;
541         _callOptionalReturn(
542             token,
543             abi.encodeWithSelector(
544                 token.approve.selector,
545                 spender,
546                 newAllowance
547             )
548         );
549     }
550 
551     /**
552      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
553      * on the return value: the return value is optional (but if data is returned, it must not be false).
554      * @param token The token targeted by the call.
555      * @param data The call data (encoded using abi.encode or one of its variants).
556      */
557     function _callOptionalReturn(IERC20 token, bytes memory data) private {
558         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
559         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
560         // the target address contains contract code and also asserts for success in the low-level call.
561 
562         bytes memory returndata = address(token).functionCall(
563             data,
564             "SafeERC20: low-level call failed"
565         );
566         if (returndata.length > 0) {
567             // Return data is optional
568             // solhint-disable-next-line max-line-length
569             require(
570                 abi.decode(returndata, (bool)),
571                 "SafeERC20: ERC20 operation did not succeed"
572             );
573         }
574     }
575 }
576 
577 // File: BonusRewards.sol
578 
579 /**
580  * @title Cover Protocol Bonus Token Rewards contract
581  * @author crypto-pumpkin
582  * @notice ETH is not allowed to be an bonus token, use wETH instead
583  * @notice We support multiple bonus tokens for each pool. However, each pool will have 1 bonus token normally, may have 2 in rare cases
584  */
585 contract BonusRewards is IBonusRewards, Ownable, ReentrancyGuard {
586     using SafeERC20 for IERC20;
587 
588     bool public paused;
589     uint256 private constant WEEK = 7 days;
590     // help calculate rewards/bonus PerToken only. 1e12 will allow meaningful $1 deposit in a $1bn pool
591     uint256 private constant CAL_MULTIPLIER = 1e30;
592     // use array to allow convenient replacement. Size of responders should be very small to 0 till a reputable responder multi-sig within DeFi or Yearn ecosystem is established
593     address[] private responders;
594     address[] private poolList;
595     // lpToken => Pool
596     mapping(address => Pool) private pools;
597     // lpToken => User address => User data
598     mapping(address => mapping(address => User)) private users;
599     // use array to allow convenient replacement. Size of Authorizers should be very small (one or two partner addresses for the pool and bonus)
600     // lpToken => bonus token => [] allowed authorizers to add bonus tokens
601     mapping(address => mapping(address => address[]))
602         private allowedTokenAuthorizers;
603     // bonusTokenAddr => 1, used to avoid collecting bonus token when not ready
604     mapping(address => uint8) private bonusTokenAddrMap;
605 
606     modifier notPaused() {
607         require(!paused, "BonusRewards: paused");
608         _;
609     }
610 
611     function claimRewardsForPools(address[] calldata _lpTokens)
612         external
613         override
614         nonReentrant
615         notPaused
616     {
617         for (uint256 i = 0; i < _lpTokens.length; i++) {
618             address lpToken = _lpTokens[i];
619             User memory user = users[lpToken][msg.sender];
620             if (user.amount == 0) continue;
621             _updatePool(lpToken);
622             _claimRewards(lpToken, user);
623             _updateUserWriteoffs(lpToken);
624         }
625     }
626 
627     function deposit(address _lpToken, uint256 _amount)
628         external
629         override
630         nonReentrant
631         notPaused
632     {
633         require(
634             pools[_lpToken].lastUpdatedAt > 0,
635             "Blacksmith: pool does not exists"
636         );
637         require(
638             IERC20(_lpToken).balanceOf(msg.sender) >= _amount,
639             "Blacksmith: insufficient balance"
640         );
641 
642         _updatePool(_lpToken);
643         User storage user = users[_lpToken][msg.sender];
644         _claimRewards(_lpToken, user);
645 
646         IERC20 token = IERC20(_lpToken);
647         uint256 balanceBefore = token.balanceOf(address(this));
648         token.safeTransferFrom(msg.sender, address(this), _amount);
649         uint256 received = token.balanceOf(address(this)) - balanceBefore;
650 
651         user.amount = user.amount + received;
652         pools[_lpToken].amount = pools[_lpToken].amount + received;
653         _updateUserWriteoffs(_lpToken);
654         emit Deposit(msg.sender, _lpToken, received);
655     }
656 
657     /// @notice withdraw up to all user deposited
658     function withdraw(address _lpToken, uint256 _amount)
659         external
660         override
661         nonReentrant
662         notPaused
663     {
664         require(
665             pools[_lpToken].lastUpdatedAt > 0,
666             "Blacksmith: pool does not exists"
667         );
668         _updatePool(_lpToken);
669 
670         User storage user = users[_lpToken][msg.sender];
671         _claimRewards(_lpToken, user);
672         uint256 amount = user.amount > _amount ? _amount : user.amount;
673         user.amount = user.amount - amount;
674         pools[_lpToken].amount = pools[_lpToken].amount - amount;
675         _updateUserWriteoffs(_lpToken);
676 
677         _safeTransfer(_lpToken, amount);
678         emit Withdraw(msg.sender, _lpToken, amount);
679     }
680 
681     /// @notice withdraw all without rewards
682     function emergencyWithdraw(address[] calldata _lpTokens)
683         external
684         override
685         nonReentrant
686     {
687         for (uint256 i = 0; i < _lpTokens.length; i++) {
688             User storage user = users[_lpTokens[i]][msg.sender];
689             uint256 amount = user.amount;
690             user.amount = 0;
691             pools[_lpTokens[i]].amount = pools[_lpTokens[i]].amount - amount;
692             _safeTransfer(_lpTokens[i], amount);
693             emit Withdraw(msg.sender, _lpTokens[i], amount);
694         }
695     }
696 
697     /// @notice called by authorizers only
698     function addBonus(
699         address _lpToken,
700         address _bonusTokenAddr,
701         uint48 _startTime,
702         uint256 _weeklyRewards,
703         uint256 _transferAmount
704     ) external override nonReentrant notPaused {
705         require(
706             _isAuthorized(allowedTokenAuthorizers[_lpToken][_bonusTokenAddr]),
707             "BonusRewards: not authorized caller"
708         );
709         require(
710             _startTime >= block.timestamp,
711             "BonusRewards: startTime in the past"
712         );
713 
714         // make sure the pool is in the right state (exist with no active bonus at the moment) to add new bonus tokens
715         Pool memory pool = pools[_lpToken];
716         require(pool.lastUpdatedAt > 0, "BonusRewards: pool does not exist");
717         Bonus[] memory bonuses = pool.bonuses;
718         for (uint256 i = 0; i < bonuses.length; i++) {
719             if (bonuses[i].bonusTokenAddr == _bonusTokenAddr) {
720                 // when there is alreay a bonus program with the same bonus token, make sure the program has ended properly
721                 require(
722                     bonuses[i].endTime + WEEK < block.timestamp,
723                     "BonusRewards: last bonus period hasn't ended"
724                 );
725                 require(
726                     bonuses[i].remBonus == 0,
727                     "BonusRewards: last bonus not all claimed"
728                 );
729             }
730         }
731 
732         IERC20 bonusTokenAddr = IERC20(_bonusTokenAddr);
733         uint256 balanceBefore = bonusTokenAddr.balanceOf(address(this));
734         bonusTokenAddr.safeTransferFrom(
735             msg.sender,
736             address(this),
737             _transferAmount
738         );
739         uint256 received = bonusTokenAddr.balanceOf(address(this)) -
740             balanceBefore;
741         // endTime is based on how much tokens transfered v.s. planned weekly rewards
742         uint48 endTime = uint48(
743             (received * WEEK) / _weeklyRewards + _startTime
744         );
745 
746         pools[_lpToken].bonuses.push(
747             Bonus({
748                 bonusTokenAddr: _bonusTokenAddr,
749                 startTime: _startTime,
750                 endTime: endTime,
751                 weeklyRewards: _weeklyRewards,
752                 accRewardsPerToken: 0,
753                 remBonus: received
754             })
755         );
756     }
757 
758     /// @notice called by authorizers only, update weeklyRewards (if not ended), or update startTime (only if rewards not started, 0 is ignored)
759     function updateBonus(
760         address _lpToken,
761         address _bonusTokenAddr,
762         uint256 _weeklyRewards,
763         uint48 _startTime
764     ) external override nonReentrant notPaused {
765         require(
766             _isAuthorized(allowedTokenAuthorizers[_lpToken][_bonusTokenAddr]),
767             "BonusRewards: not authorized caller"
768         );
769         require(
770             _startTime == 0 || _startTime > block.timestamp,
771             "BonusRewards: startTime in the past"
772         );
773 
774         // make sure the pool is in the right state (exist with no active bonus at the moment) to add new bonus tokens
775         Pool memory pool = pools[_lpToken];
776         require(pool.lastUpdatedAt > 0, "BonusRewards: pool does not exist");
777         Bonus[] memory bonuses = pool.bonuses;
778         for (uint256 i = 0; i < bonuses.length; i++) {
779             if (
780                 bonuses[i].bonusTokenAddr == _bonusTokenAddr &&
781                 bonuses[i].endTime > block.timestamp
782             ) {
783                 Bonus storage bonus = pools[_lpToken].bonuses[i];
784                 _updatePool(_lpToken); // update pool with old weeklyReward to this block
785                 if (bonus.startTime >= block.timestamp) {
786                     // only honor new start time, if program has not started
787                     if (_startTime >= block.timestamp) {
788                         bonus.startTime = _startTime;
789                     }
790                     bonus.endTime = uint48(
791                         (bonus.remBonus * WEEK) /
792                             _weeklyRewards +
793                             bonus.startTime
794                     );
795                 } else {
796                     // remaining bonus to distribute * week
797                     uint256 remBonusToDistribute = (bonus.endTime -
798                         block.timestamp) * bonus.weeklyRewards;
799                     bonus.endTime = uint48(
800                         remBonusToDistribute / _weeklyRewards + block.timestamp
801                     );
802                 }
803                 bonus.weeklyRewards = _weeklyRewards;
804             }
805         }
806     }
807 
808     /// @notice extend the current bonus program, the program has to be active (endTime is in the future)
809     function extendBonus(
810         address _lpToken,
811         uint256 _poolBonusId,
812         address _bonusTokenAddr,
813         uint256 _transferAmount
814     ) external override nonReentrant notPaused {
815         require(
816             _isAuthorized(allowedTokenAuthorizers[_lpToken][_bonusTokenAddr]),
817             "BonusRewards: not authorized caller"
818         );
819 
820         Bonus memory bonus = pools[_lpToken].bonuses[_poolBonusId];
821         require(
822             bonus.bonusTokenAddr == _bonusTokenAddr,
823             "BonusRewards: bonus and id dont match"
824         );
825         require(
826             bonus.endTime > block.timestamp,
827             "BonusRewards: bonus program ended, please start a new one"
828         );
829 
830         IERC20 bonusTokenAddr = IERC20(_bonusTokenAddr);
831         uint256 balanceBefore = bonusTokenAddr.balanceOf(address(this));
832         bonusTokenAddr.safeTransferFrom(
833             msg.sender,
834             address(this),
835             _transferAmount
836         );
837         uint256 received = bonusTokenAddr.balanceOf(address(this)) -
838             balanceBefore;
839         // endTime is based on how much tokens transfered v.s. planned weekly rewards
840         uint48 endTime = uint48(
841             (received * WEEK) / bonus.weeklyRewards + bonus.endTime
842         );
843 
844         pools[_lpToken].bonuses[_poolBonusId].endTime = endTime;
845         pools[_lpToken].bonuses[_poolBonusId].remBonus =
846             bonus.remBonus +
847             received;
848     }
849 
850     /// @notice add pools and authorizers to add bonus tokens for pools, combine two calls into one. Only reason we add pools is when bonus tokens will be added
851     function addPoolsAndAllowBonus(
852         address[] calldata _lpTokens,
853         address[] calldata _bonusTokenAddrs,
854         address[] calldata _authorizers
855     ) external override onlyOwner notPaused {
856         // add pools
857         uint256 currentTime = block.timestamp;
858         for (uint256 i = 0; i < _lpTokens.length; i++) {
859             address _lpToken = _lpTokens[i];
860             require(
861                 IERC20(_lpToken).decimals() <= 18,
862                 "BonusRewards: lptoken decimals > 18"
863             );
864             if (pools[_lpToken].lastUpdatedAt == 0) {
865                 pools[_lpToken].lastUpdatedAt = currentTime;
866                 poolList.push(_lpToken);
867             }
868 
869             // add bonus tokens and their authorizers (who are allowed to add the token to pool)
870             for (uint256 j = 0; j < _bonusTokenAddrs.length; j++) {
871                 address _bonusTokenAddr = _bonusTokenAddrs[j];
872                 allowedTokenAuthorizers[_lpToken][
873                     _bonusTokenAddr
874                 ] = _authorizers;
875                 bonusTokenAddrMap[_bonusTokenAddr] = 1;
876             }
877         }
878     }
879 
880     /// @notice collect bonus token dust to treasury
881     function collectDust(
882         address _token,
883         address _lpToken,
884         uint256 _poolBonusId
885     ) external override onlyOwner {
886         require(
887             pools[_token].lastUpdatedAt == 0,
888             "BonusRewards: lpToken, not allowed"
889         );
890 
891         if (_token == address(0)) {
892             // token address(0) = ETH
893             payable(owner()).transfer(address(this).balance);
894         } else {
895             uint256 balance = IERC20(_token).balanceOf(address(this));
896             if (bonusTokenAddrMap[_token] == 1) {
897                 // bonus token
898                 Bonus memory bonus = pools[_lpToken].bonuses[_poolBonusId];
899                 require(
900                     bonus.bonusTokenAddr == _token,
901                     "BonusRewards: wrong pool"
902                 );
903                 require(
904                     bonus.endTime + WEEK < block.timestamp,
905                     "BonusRewards: not ready"
906                 );
907                 balance = bonus.remBonus;
908                 pools[_lpToken].bonuses[_poolBonusId].remBonus = 0;
909             }
910 
911             IERC20(_token).transfer(owner(), balance);
912         }
913     }
914 
915     function setResponders(address[] calldata _responders)
916         external
917         override
918         onlyOwner
919     {
920         responders = _responders;
921     }
922 
923     function setPaused(bool _paused) external override {
924         require(
925             _isAuthorized(responders),
926             "BonusRewards: caller not responder"
927         );
928         paused = _paused;
929     }
930 
931     function getPool(address _lpToken)
932         external
933         view
934         override
935         returns (Pool memory)
936     {
937         return pools[_lpToken];
938     }
939 
940     function getUser(address _lpToken, address _account)
941         external
942         view
943         override
944         returns (User memory, uint256[] memory)
945     {
946         return (users[_lpToken][_account], viewRewards(_lpToken, _account));
947     }
948 
949     function getAuthorizers(address _lpToken, address _bonusTokenAddr)
950         external
951         view
952         override
953         returns (address[] memory)
954     {
955         return allowedTokenAuthorizers[_lpToken][_bonusTokenAddr];
956     }
957 
958     function getResponders() external view override returns (address[] memory) {
959         return responders;
960     }
961 
962     function viewRewards(address _lpToken, address _user)
963         public
964         view
965         override
966         returns (uint256[] memory)
967     {
968         Pool memory pool = pools[_lpToken];
969         User memory user = users[_lpToken][_user];
970         uint256[] memory rewards = new uint256[](pool.bonuses.length);
971         if (user.amount <= 0) return rewards;
972 
973         uint256 rewardsWriteoffsLen = user.rewardsWriteoffs.length;
974         for (uint256 i = 0; i < rewards.length; i++) {
975             Bonus memory bonus = pool.bonuses[i];
976             if (bonus.startTime < block.timestamp && bonus.remBonus > 0) {
977                 uint256 lpTotal = pool.amount;
978                 uint256 bonusForTime = _calRewardsForTime(
979                     bonus,
980                     pool.lastUpdatedAt
981                 );
982                 uint256 bonusPerToken = bonus.accRewardsPerToken +
983                     bonusForTime /
984                     lpTotal;
985                 uint256 rewardsWriteoff = rewardsWriteoffsLen <= i
986                     ? 0
987                     : user.rewardsWriteoffs[i];
988                 uint256 reward = (user.amount * bonusPerToken) /
989                     CAL_MULTIPLIER -
990                     rewardsWriteoff;
991                 rewards[i] = reward < bonus.remBonus ? reward : bonus.remBonus;
992             }
993         }
994         return rewards;
995     }
996 
997     function getPoolList() external view override returns (address[] memory) {
998         return poolList;
999     }
1000 
1001     /// @notice update pool's bonus per staked token till current block timestamp, do nothing if pool does not exist
1002     function _updatePool(address _lpToken) private {
1003         Pool storage pool = pools[_lpToken];
1004         uint256 poolLastUpdatedAt = pool.lastUpdatedAt;
1005         if (poolLastUpdatedAt == 0 || block.timestamp <= poolLastUpdatedAt)
1006             return;
1007         pool.lastUpdatedAt = block.timestamp;
1008         uint256 lpTotal = pool.amount;
1009         if (lpTotal == 0) return;
1010 
1011         for (uint256 i = 0; i < pool.bonuses.length; i++) {
1012             Bonus storage bonus = pool.bonuses[i];
1013             if (
1014                 poolLastUpdatedAt < bonus.endTime &&
1015                 bonus.startTime < block.timestamp
1016             ) {
1017                 uint256 bonusForTime = _calRewardsForTime(
1018                     bonus,
1019                     poolLastUpdatedAt
1020                 );
1021                 bonus.accRewardsPerToken =
1022                     bonus.accRewardsPerToken +
1023                     bonusForTime /
1024                     lpTotal;
1025             }
1026         }
1027     }
1028 
1029     function _updateUserWriteoffs(address _lpToken) private {
1030         Bonus[] memory bonuses = pools[_lpToken].bonuses;
1031         User storage user = users[_lpToken][msg.sender];
1032         for (uint256 i = 0; i < bonuses.length; i++) {
1033             // update writeoff to match current acc rewards per token
1034             if (user.rewardsWriteoffs.length == i) {
1035                 user.rewardsWriteoffs.push(
1036                     (user.amount * bonuses[i].accRewardsPerToken) /
1037                         CAL_MULTIPLIER
1038                 );
1039             } else {
1040                 user.rewardsWriteoffs[i] =
1041                     (user.amount * bonuses[i].accRewardsPerToken) /
1042                     CAL_MULTIPLIER;
1043             }
1044         }
1045     }
1046 
1047     /// @notice transfer upto what the contract has
1048     function _safeTransfer(address _token, uint256 _amount)
1049         private
1050         returns (uint256 _transferred)
1051     {
1052         IERC20 token = IERC20(_token);
1053         uint256 balance = token.balanceOf(address(this));
1054         if (balance > _amount) {
1055             token.safeTransfer(msg.sender, _amount);
1056             _transferred = _amount;
1057         } else if (balance > 0) {
1058             token.safeTransfer(msg.sender, balance);
1059             _transferred = balance;
1060         }
1061     }
1062 
1063     function _calRewardsForTime(Bonus memory _bonus, uint256 _lastUpdatedAt)
1064         internal
1065         view
1066         returns (uint256)
1067     {
1068         if (_bonus.endTime <= _lastUpdatedAt) return 0;
1069 
1070         uint256 calEndTime = block.timestamp > _bonus.endTime
1071             ? _bonus.endTime
1072             : block.timestamp;
1073         uint256 calStartTime = _lastUpdatedAt > _bonus.startTime
1074             ? _lastUpdatedAt
1075             : _bonus.startTime;
1076         uint256 timePassed = calEndTime - calStartTime;
1077         return (_bonus.weeklyRewards * CAL_MULTIPLIER * timePassed) / WEEK;
1078     }
1079 
1080     function _claimRewards(address _lpToken, User memory _user) private {
1081         // only claim if user has deposited before
1082         if (_user.amount == 0) return;
1083         uint256 rewardsWriteoffsLen = _user.rewardsWriteoffs.length;
1084         Bonus[] memory bonuses = pools[_lpToken].bonuses;
1085         for (uint256 i = 0; i < bonuses.length; i++) {
1086             uint256 rewardsWriteoff = rewardsWriteoffsLen <= i
1087                 ? 0
1088                 : _user.rewardsWriteoffs[i];
1089             uint256 bonusSinceLastUpdate = (_user.amount *
1090                 bonuses[i].accRewardsPerToken) /
1091                 CAL_MULTIPLIER -
1092                 rewardsWriteoff;
1093             uint256 toTransfer = bonuses[i].remBonus < bonusSinceLastUpdate
1094                 ? bonuses[i].remBonus
1095                 : bonusSinceLastUpdate;
1096             if (toTransfer == 0) continue;
1097             uint256 transferred = _safeTransfer(
1098                 bonuses[i].bonusTokenAddr,
1099                 toTransfer
1100             );
1101             pools[_lpToken].bonuses[i].remBonus =
1102                 bonuses[i].remBonus -
1103                 transferred;
1104         }
1105     }
1106 
1107     // only owner or authorized users from list
1108     function _isAuthorized(address[] memory checkList)
1109         private
1110         view
1111         returns (bool)
1112     {
1113         if (msg.sender == owner()) return true;
1114 
1115         for (uint256 i = 0; i < checkList.length; i++) {
1116             if (msg.sender == checkList[i]) {
1117                 return true;
1118             }
1119         }
1120         return false;
1121     }
1122 }
