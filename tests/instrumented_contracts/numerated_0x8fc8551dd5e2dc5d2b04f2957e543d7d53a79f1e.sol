1 // Sources flattened with hardhat v2.0.7 https://hardhat.org
2 
3 // File contracts/utils/Ownable.sol
4 
5 // SPDX-License-Identifier: None
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module which provides a basic access control mechanism, where
11  * there is an account (an owner) that can be granted exclusive access to
12  * specific functions.
13  * @author crypto-pumpkin@github
14  *
15  * By initialization, the owner account will be the one that called initializeOwner. This
16  * can later be changed with {transferOwnership}.
17  */
18 contract Ownable {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev COVER: Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor () {
27         _owner = msg.sender;
28         emit OwnershipTransferred(address(0), _owner);
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(_owner == msg.sender, "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Transfers ownership of the contract to a new account (`newOwner`).
48      * Can only be called by the current owner.
49      */
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         emit OwnershipTransferred(_owner, newOwner);
53         _owner = newOwner;
54     }
55 }
56 
57 
58 // File contracts/utils/ReentrancyGuard.sol
59 
60 pragma solidity ^0.8.0;
61 
62 /**
63  * @dev Contract module that helps prevent reentrant calls to a function.
64  *
65  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
66  * available, which can be applied to functions to make sure there are no nested
67  * (reentrant) calls to them.
68  *
69  * Note that because there is a single `nonReentrant` guard, functions marked as
70  * `nonReentrant` may not call one another. This can be worked around by making
71  * those functions `private`, and then adding `external` `nonReentrant` entry
72  * points to them.
73  *
74  * TIP: If you would like to learn more about reentrancy and alternative ways
75  * to protect against it, check out our blog post
76  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
77  */
78 abstract contract ReentrancyGuard {
79     // Booleans are more expensive than uint256 or any type that takes up a full
80     // word because each write operation emits an extra SLOAD to first read the
81     // slot's contents, replace the bits taken up by the boolean, and then write
82     // back. This is the compiler's defense against contract upgrades and
83     // pointer aliasing, and it cannot be disabled.
84 
85     // The values being non-zero value makes deployment a bit more expensive,
86     // but in exchange the refund on every call to nonReentrant will be lower in
87     // amount. Since refunds are capped to a percentage of the total
88     // transaction's gas, it is best to keep them low in cases like this one, to
89     // increase the likelihood of the full refund coming into effect.
90     uint256 private constant _NOT_ENTERED = 1;
91     uint256 private constant _ENTERED = 2;
92 
93     uint256 private _status;
94 
95     constructor () {
96         _status = _NOT_ENTERED;
97     }
98 
99     /**
100      * @dev Prevents a contract from calling itself, directly or indirectly.
101      * Calling a `nonReentrant` function from another `nonReentrant`
102      * function is not supported. It is possible to prevent this from happening
103      * by making the `nonReentrant` function external, and make it call a
104      * `private` function that does the actual work.
105      */
106     modifier nonReentrant() {
107         // On the first call to nonReentrant, _notEntered will be true
108         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
109 
110         // Any calls to nonReentrant after this point will fail
111         _status = _ENTERED;
112 
113         _;
114 
115         // By storing the original value once again, a refund is triggered (see
116         // https://eips.ethereum.org/EIPS/eip-2200)
117         _status = _NOT_ENTERED;
118     }
119 }
120 
121 
122 // File contracts/interfaces/IERC20.sol
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @title Interface of the ERC20 standard as defined in the EIP.
128  */
129 interface IERC20 {
130     event Transfer(address indexed from, address indexed to, uint256 value);
131     event Approval(address indexed owner, address indexed spender, uint256 value);
132 
133     function decimals() external view returns (uint8);
134     function balanceOf(address account) external view returns (uint256);
135     function totalSupply() external view returns (uint256);
136     function transfer(address recipient, uint256 amount) external returns (bool);
137     function allowance(address owner, address spender) external view returns (uint256);
138     function approve(address spender, uint256 amount) external returns (bool);
139     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
140 
141     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
142     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
143 }
144 
145 
146 // File contracts/utils/Address.sol
147 
148 pragma solidity ^0.8.0;
149 
150 library Address {
151     /**
152      * @dev Returns true if `account` is a contract.
153      *
154      * [IMPORTANT]
155      * ====
156      * It is unsafe to assume that an address for which this function returns
157      * false is an externally-owned account (EOA) and not a contract.
158      *
159      * Among others, `isContract` will return false for the following
160      * types of addresses:
161      *
162      *  - an externally-owned account
163      *  - a contract in construction
164      *  - an address where a contract will be created
165      *  - an address where a contract lived, but was destroyed
166      * ====
167      */
168     function isContract(address account) internal view returns (bool) {
169         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
170         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
171         // for accounts without code, i.e. `keccak256('')`
172         bytes32 codehash;
173         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
174         // solhint-disable-next-line no-inline-assembly
175         assembly { codehash := extcodehash(account) }
176         return (codehash != accountHash && codehash != 0x0);
177     }
178 
179     /**
180      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
181      * `recipient`, forwarding all available gas and reverting on errors.
182      *
183      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
184      * of certain opcodes, possibly making contracts go over the 2300 gas limit
185      * imposed by `transfer`, making them unable to receive funds via
186      * `transfer`. {sendValue} removes this limitation.
187      *
188      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
189      *
190      * IMPORTANT: because control is transferred to `recipient`, care must be
191      * taken to not create reentrancy vulnerabilities. Consider using
192      * {ReentrancyGuard} or the
193      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
194      */
195     function sendValue(address payable recipient, uint256 amount) internal {
196         require(address(this).balance >= amount, "Address: insufficient balance");
197 
198         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
199         (bool success, ) = recipient.call{ value: amount }("");
200         require(success, "Address: unable to send value, recipient may have reverted");
201     }
202 
203     /**
204      * @dev Performs a Solidity function call using a low level `call`. A
205      * plain`call` is an unsafe replacement for a function call: use this
206      * function instead.
207      *
208      * If `target` reverts with a revert reason, it is bubbled up by this
209      * function (like regular Solidity function calls).
210      *
211      * Returns the raw returned data. To convert to the expected return value,
212      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
213      *
214      * Requirements:
215      *
216      * - `target` must be a contract.
217      * - calling `target` with `data` must not revert.
218      *
219      * _Available since v3.1._
220      */
221     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
222       return functionCall(target, data, "Address: low-level call failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
227      * `errorMessage` as a fallback revert reason when `target` reverts.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
232         return _functionCallWithValue(target, data, 0, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but also transferring `value` wei to `target`.
238      *
239      * Requirements:
240      *
241      * - the calling contract must have an ETH balance of at least `value`.
242      * - the called Solidity function must be `payable`.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
252      * with `errorMessage` as a fallback revert reason when `target` reverts.
253      *
254      * _Available since v3.1._
255      */
256     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
257         require(address(this).balance >= value, "Address: insufficient balance for call");
258         return _functionCallWithValue(target, data, value, errorMessage);
259     }
260 
261     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
262         require(isContract(target), "Address: call to non-contract");
263 
264         // solhint-disable-next-line avoid-low-level-calls
265         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
266         if (success) {
267             return returndata;
268         } else {
269             // Look for revert reason and bubble it up if present
270             if (returndata.length > 0) {
271                 // The easiest way to bubble the revert reason is using memory via assembly
272 
273                 // solhint-disable-next-line no-inline-assembly
274                 assembly {
275                     let returndata_size := mload(returndata)
276                     revert(add(32, returndata), returndata_size)
277                 }
278             } else {
279                 revert(errorMessage);
280             }
281         }
282     }
283 }
284 
285 
286 // File contracts/utils/SafeERC20.sol
287 
288 pragma solidity ^0.8.0;
289 
290 
291 /**
292  * @title SafeERC20
293  * @dev Wrappers around ERC20 operations that throw on failure (when the token
294  * contract returns false). Tokens that return no value (and instead revert or
295  * throw on failure) are also supported, non-reverting calls are assumed to be
296  * successful.
297  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
298  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
299  */
300 library SafeERC20 {
301     using Address for address;
302 
303     function safeTransfer(IERC20 token, address to, uint256 value) internal {
304         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
305     }
306 
307     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
308         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
309     }
310 
311     /**
312      * @dev Deprecated. This function has issues similar to the ones found in
313      * {IERC20-approve}, and its usage is discouraged.
314      *
315      * Whenever possible, use {safeIncreaseAllowance} and
316      * {safeDecreaseAllowance} instead.
317      */
318     function safeApprove(IERC20 token, address spender, uint256 value) internal {
319         // safeApprove should only be called when setting an initial allowance,
320         // or when resetting it to zero. To increase and decrease it, use
321         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
322         // solhint-disable-next-line max-line-length
323         require((value == 0) || (token.allowance(address(this), spender) == 0),
324             "SafeERC20: approve from non-zero to non-zero allowance"
325         );
326         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
327     }
328 
329     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
330         uint256 newAllowance = token.allowance(address(this), spender) + value;
331         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
332     }
333 
334     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
335         uint256 newAllowance = token.allowance(address(this), spender) - value;
336         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
337     }
338 
339     /**
340      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
341      * on the return value: the return value is optional (but if data is returned, it must not be false).
342      * @param token The token targeted by the call.
343      * @param data The call data (encoded using abi.encode or one of its variants).
344      */
345     function _callOptionalReturn(IERC20 token, bytes memory data) private {
346         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
347         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
348         // the target address contains contract code and also asserts for success in the low-level call.
349 
350         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
351         if (returndata.length > 0) { // Return data is optional
352             // solhint-disable-next-line max-line-length
353             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
354         }
355     }
356 }
357 
358 
359 // File contracts/interfaces/IBonusRewards.sol
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @title Cover Protocol Bonus Token Rewards Interface
365  * @author crypto-pumpkin
366  */
367 interface IBonusRewards {
368   event Deposit(address indexed user, address indexed lpToken, uint256 amount);
369   event Withdraw(address indexed user, address indexed lpToken, uint256 amount);
370 
371   struct Bonus {
372     address bonusTokenAddr; // the external bonus token, like CRV
373     uint48 startTime;
374     uint48 endTime;
375     uint256 weeklyRewards; // total amount to be distributed from start to end
376     uint256 accRewardsPerToken; // accumulated bonus to the lastUpdated Time
377     uint256 remBonus; // remaining bonus in contract
378   }
379 
380   struct Pool {
381     Bonus[] bonuses;
382     uint256 lastUpdatedAt; // last accumulated bonus update timestamp
383   }
384 
385   struct User {
386     uint256 amount;
387     uint256[] rewardsWriteoffs; // the amount of bonus tokens to write off when calculate rewards from last update
388   }
389 
390   function getPoolList() external view returns (address[] memory);
391   function getResponders() external view returns (address[] memory);
392   function getPool(address _lpToken) external view returns (Pool memory);
393   function getUser(address _lpToken, address _account) external view returns (User memory _user, uint256[] memory _rewards);
394   function getAuthorizers(address _lpToken, address _bonusTokenAddr) external view returns (address[] memory);
395   function viewRewards(address _lpToken, address _user) external view  returns (uint256[] memory);
396 
397   function claimRewardsForPools(address[] calldata _lpTokens) external;
398   function deposit(address _lpToken, uint256 _amount) external;
399   function withdraw(address _lpToken, uint256 _amount) external;
400   function emergencyWithdraw(address[] calldata _lpTokens) external;
401   function addBonus(
402     address _lpToken,
403     address _bonusTokenAddr,
404     uint48 _startTime,
405     uint256 _weeklyRewards,
406     uint256 _transferAmount
407   ) external;
408   function extendBonus(
409     address _lpToken,
410     uint256 _poolBonusId,
411     address _bonusTokenAddr,
412     uint256 _transferAmount
413   ) external;
414   function updateBonus(
415     address _lpToken,
416     address _bonusTokenAddr,
417     uint256 _weeklyRewards,
418     uint48 _startTime
419   ) external;
420 
421   // only owner
422   function setResponders(address[] calldata _responders) external;
423   function setPaused(bool _paused) external;
424   function collectDust(address _token, address _lpToken, uint256 _poolBonusId) external;
425   function addPoolsAndAllowBonus(
426     address[] calldata _lpTokens,
427     address[] calldata _bonusTokenAddrs,
428     address[] calldata _authorizers
429   ) external;
430 }
431 
432 
433 // File contracts/BonusRewards.sol
434 
435 pragma solidity ^0.8.0;
436 
437 
438 
439 
440 /**
441  * @title Cover Protocol Bonus Token Rewards contract
442  * @author crypto-pumpkin
443  * @notice ETH is not allowed to be an bonus token, use wETH instead
444  * @notice We support multiple bonus tokens for each pool. However, each pool will have 1 bonus token normally, may have 2 in rare cases
445  */
446 contract BonusRewards is IBonusRewards, Ownable, ReentrancyGuard {
447   using SafeERC20 for IERC20;
448 
449   bool public paused;
450   uint256 private constant WEEK = 7 days;
451   // help calculate rewards/bonus PerToken only. 1e12 will allow meaningful $1 deposit in a $1bn pool  
452   uint256 private constant CAL_MULTIPLIER = 1e30;
453   // use array to allow convinient replacement. Size of responders should be very small to 0 till a reputible responder multi-sig within DeFi or Yearn ecosystem is established
454   address[] private responders;
455   address[] private poolList;
456   // lpToken => Pool
457   mapping(address => Pool) private pools;
458   // lpToken => User address => User data
459   mapping(address => mapping(address => User)) private users;
460   // use array to allow convinient replacement. Size of Authorizers should be very small (one or two partner addresses for the pool and bonus)
461   // lpToken => bonus token => [] allowed authorizers to add bonus tokens
462   mapping(address => mapping(address => address[])) private allowedTokenAuthorizers;
463   // bonusTokenAddr => 1, used to avoid collecting bonus token when not ready
464   mapping(address => uint8) private bonusTokenAddrMap;
465 
466   modifier notPaused() {
467     require(!paused, "BonusRewards: paused");
468     _;
469   }
470 
471   function claimRewardsForPools(address[] calldata _lpTokens) external override nonReentrant notPaused {
472     for (uint256 i = 0; i < _lpTokens.length; i++) {
473       address lpToken = _lpTokens[i];
474       User memory user = users[lpToken][msg.sender];
475       if (user.amount == 0) continue;
476       _updatePool(lpToken);
477       _claimRewards(lpToken, user);
478       _updateUserWriteoffs(lpToken);
479     }
480   }
481 
482   function deposit(address _lpToken, uint256 _amount) external override nonReentrant notPaused {
483     require(pools[_lpToken].lastUpdatedAt > 0, "Blacksmith: pool does not exists");
484     require(IERC20(_lpToken).balanceOf(msg.sender) >= _amount, "Blacksmith: insufficient balance");
485 
486     _updatePool(_lpToken);
487     User storage user = users[_lpToken][msg.sender];
488     _claimRewards(_lpToken, user);
489 
490     IERC20 token = IERC20(_lpToken);
491     uint256 balanceBefore = token.balanceOf(address(this));
492     token.safeTransferFrom(msg.sender, address(this), _amount);
493     uint256 received = token.balanceOf(address(this)) - balanceBefore;
494 
495     user.amount = user.amount + received;
496     _updateUserWriteoffs(_lpToken);
497     emit Deposit(msg.sender, _lpToken, received);
498   }
499 
500   /// @notice withdraw up to all user deposited
501   function withdraw(address _lpToken, uint256 _amount) external override nonReentrant notPaused {
502     require(pools[_lpToken].lastUpdatedAt > 0, "Blacksmith: pool does not exists");
503     _updatePool(_lpToken);
504 
505     User storage user = users[_lpToken][msg.sender];
506     _claimRewards(_lpToken, user);
507     uint256 amount = user.amount > _amount ? _amount : user.amount;
508     user.amount = user.amount - amount;
509     _updateUserWriteoffs(_lpToken);
510 
511     _safeTransfer(_lpToken, amount);
512     emit Withdraw(msg.sender, _lpToken, amount);
513   }
514 
515   /// @notice withdraw all without rewards
516   function emergencyWithdraw(address[] calldata _lpTokens) external override nonReentrant {
517     for (uint256 i = 0; i < _lpTokens.length; i++) {
518       User storage user = users[_lpTokens[i]][msg.sender];
519       uint256 amount = user.amount;
520       user.amount = 0;
521       _safeTransfer(_lpTokens[i], amount);
522       emit Withdraw(msg.sender, _lpTokens[i], amount);
523     }
524   }
525 
526   /// @notice called by authorizers only
527   function addBonus(
528     address _lpToken,
529     address _bonusTokenAddr,
530     uint48 _startTime,
531     uint256 _weeklyRewards,
532     uint256 _transferAmount
533   ) external override nonReentrant notPaused {
534     require(_isAuthorized(allowedTokenAuthorizers[_lpToken][_bonusTokenAddr]), "BonusRewards: not authorized caller");
535     require(_startTime >= block.timestamp, "BonusRewards: startTime in the past");
536 
537     // make sure the pool is in the right state (exist with no active bonus at the moment) to add new bonus tokens
538     Pool memory pool = pools[_lpToken];
539     require(pool.lastUpdatedAt > 0, "BonusRewards: pool does not exist");
540     Bonus[] memory bonuses = pool.bonuses;
541     for (uint256 i = 0; i < bonuses.length; i++) {
542       if (bonuses[i].bonusTokenAddr == _bonusTokenAddr) {
543         // when there is alreay a bonus program with the same bonus token, make sure the program has ended properly
544         require(bonuses[i].endTime + WEEK < block.timestamp, "BonusRewards: last bonus period hasn't ended");
545         require(bonuses[i].remBonus == 0, "BonusRewards: last bonus not all claimed");
546       }
547     }
548 
549     IERC20 bonusTokenAddr = IERC20(_bonusTokenAddr);
550     uint256 balanceBefore = bonusTokenAddr.balanceOf(address(this));
551     bonusTokenAddr.safeTransferFrom(msg.sender, address(this), _transferAmount);
552     uint256 received = bonusTokenAddr.balanceOf(address(this)) - balanceBefore;
553     // endTime is based on how much tokens transfered v.s. planned weekly rewards
554     uint48 endTime = uint48(received * WEEK / _weeklyRewards + _startTime);
555 
556     pools[_lpToken].bonuses.push(Bonus({
557       bonusTokenAddr: _bonusTokenAddr,
558       startTime: _startTime,
559       endTime: endTime,
560       weeklyRewards: _weeklyRewards,
561       accRewardsPerToken: 0,
562       remBonus: received
563     }));
564   }
565 
566   /// @notice called by authorizers only, update weeklyRewards (if not ended), or update startTime (only if rewards not started, 0 is ignored)
567   function updateBonus(
568     address _lpToken,
569     address _bonusTokenAddr,
570     uint256 _weeklyRewards,
571     uint48 _startTime
572   ) external override nonReentrant notPaused {
573     require(_isAuthorized(allowedTokenAuthorizers[_lpToken][_bonusTokenAddr]), "BonusRewards: not authorized caller");
574     require(_startTime == 0 || _startTime > block.timestamp, "BonusRewards: startTime in the past");
575 
576     // make sure the pool is in the right state (exist with no active bonus at the moment) to add new bonus tokens
577     Pool memory pool = pools[_lpToken];
578     require(pool.lastUpdatedAt > 0, "BonusRewards: pool does not exist");
579     Bonus[] memory bonuses = pool.bonuses;
580     for (uint256 i = 0; i < bonuses.length; i++) {
581       if (bonuses[i].bonusTokenAddr == _bonusTokenAddr && bonuses[i].endTime > block.timestamp) {
582         Bonus storage bonus = pools[_lpToken].bonuses[i];
583         _updatePool(_lpToken); // update pool with old weeklyReward to this block
584         if (bonus.startTime >= block.timestamp) {
585           // only honor new start time, if program has not started
586           if (_startTime >= block.timestamp) {
587             bonus.startTime = _startTime;
588           }
589           bonus.endTime = uint48(bonus.remBonus * WEEK / _weeklyRewards + bonus.startTime);
590         } else {
591           uint256 remBonusToDistribute = (bonus.endTime - block.timestamp) * bonus.weeklyRewards / WEEK;
592           bonus.endTime = uint48(remBonusToDistribute * WEEK / _weeklyRewards + block.timestamp);
593         }
594         bonus.weeklyRewards = _weeklyRewards;
595       }
596     }
597   }
598 
599   /// @notice extend the current bonus program, the program has to be active (endTime is in the future)
600   function extendBonus(
601     address _lpToken,
602     uint256 _poolBonusId,
603     address _bonusTokenAddr,
604     uint256 _transferAmount
605   ) external override nonReentrant notPaused {
606     require(_isAuthorized(allowedTokenAuthorizers[_lpToken][_bonusTokenAddr]), "BonusRewards: not authorized caller");
607 
608     Bonus memory bonus = pools[_lpToken].bonuses[_poolBonusId];
609     require(bonus.bonusTokenAddr == _bonusTokenAddr, "BonusRewards: bonus and id dont match");
610     require(bonus.endTime > block.timestamp, "BonusRewards: bonus program ended, please start a new one");
611 
612     IERC20 bonusTokenAddr = IERC20(_bonusTokenAddr);
613     uint256 balanceBefore = bonusTokenAddr.balanceOf(address(this));
614     bonusTokenAddr.safeTransferFrom(msg.sender, address(this), _transferAmount);
615     uint256 received = bonusTokenAddr.balanceOf(address(this)) - balanceBefore;
616     // endTime is based on how much tokens transfered v.s. planned weekly rewards
617     uint48 endTime = uint48(received * WEEK / bonus.weeklyRewards + bonus.endTime);
618 
619     pools[_lpToken].bonuses[_poolBonusId].endTime = endTime;
620     pools[_lpToken].bonuses[_poolBonusId].remBonus = bonus.remBonus + received;
621   }
622 
623   /// @notice add pools and authorizers to add bonus tokens for pools, combine two calls into one. Only reason we add pools is when bonus tokens will be added
624   function addPoolsAndAllowBonus(
625     address[] calldata _lpTokens,
626     address[] calldata _bonusTokenAddrs,
627     address[] calldata _authorizers
628   ) external override onlyOwner notPaused {
629     // add pools
630     uint256 currentTime = block.timestamp;
631     for (uint256 i = 0; i < _lpTokens.length; i++) {
632       address _lpToken = _lpTokens[i];
633       require(IERC20(_lpToken).decimals() <= 18, "BonusRewards: lptoken decimals > 18");
634       if (pools[_lpToken].lastUpdatedAt == 0) {
635         pools[_lpToken].lastUpdatedAt = currentTime;
636         poolList.push(_lpToken);
637       }
638 
639       // add bonus tokens and their authorizers (who are allowed to add the token to pool)
640       for (uint256 j = 0; j < _bonusTokenAddrs.length; j++) {
641         address _bonusTokenAddr = _bonusTokenAddrs[j];
642         require(pools[_bonusTokenAddr].lastUpdatedAt == 0, "BonusRewards: lpToken, not allowed");
643         allowedTokenAuthorizers[_lpToken][_bonusTokenAddr] = _authorizers;
644         bonusTokenAddrMap[_bonusTokenAddr] = 1;
645       }
646     }
647   }
648 
649   /// @notice collect bonus token dust to treasury
650   function collectDust(address _token, address _lpToken, uint256 _poolBonusId) external override onlyOwner {
651     require(pools[_token].lastUpdatedAt == 0, "BonusRewards: lpToken, not allowed");
652 
653     if (_token == address(0)) { // token address(0) = ETH
654       payable(owner()).transfer(address(this).balance);
655     } else {
656       uint256 balance = IERC20(_token).balanceOf(address(this));
657       if (bonusTokenAddrMap[_token] == 1) {
658         // bonus token
659         Bonus memory bonus = pools[_lpToken].bonuses[_poolBonusId];
660         require(bonus.bonusTokenAddr == _token, "BonusRewards: wrong pool");
661         require(bonus.endTime + WEEK < block.timestamp, "BonusRewards: not ready");
662         balance = bonus.remBonus;
663         pools[_lpToken].bonuses[_poolBonusId].remBonus = 0;
664       }
665 
666       IERC20(_token).transfer(owner(), balance);
667     }
668   }
669 
670   function setResponders(address[] calldata _responders) external override onlyOwner {
671     responders = _responders;
672   }
673 
674   function setPaused(bool _paused) external override {
675     require(_isAuthorized(responders), "BonusRewards: caller not responder");
676     paused = _paused;
677   }
678 
679   function getPool(address _lpToken) external view override returns (Pool memory) {
680     return pools[_lpToken];
681   }
682 
683   function getUser(address _lpToken, address _account) external view override returns (User memory, uint256[] memory) {
684     return (users[_lpToken][_account], viewRewards(_lpToken, _account));
685   }
686 
687   function getAuthorizers(address _lpToken, address _bonusTokenAddr) external view override returns (address[] memory) {
688     return allowedTokenAuthorizers[_lpToken][_bonusTokenAddr];
689   }
690 
691   function getResponders() external view override returns (address[] memory) {
692     return responders;
693   }
694 
695   function viewRewards(address _lpToken, address _user) public view override returns (uint256[] memory) {
696     Pool memory pool = pools[_lpToken];
697     User memory user = users[_lpToken][_user];
698     uint256[] memory rewards = new uint256[](pool.bonuses.length);
699     if (user.amount <= 0) return rewards;
700 
701     uint256 rewardsWriteoffsLen = user.rewardsWriteoffs.length;
702     for (uint256 i = 0; i < rewards.length; i ++) {
703       Bonus memory bonus = pool.bonuses[i];
704       if (bonus.startTime < block.timestamp && bonus.remBonus > 0) {
705         uint256 lpTotal = IERC20(_lpToken).balanceOf(address(this));
706         uint256 bonusForTime = _calRewardsForTime(bonus, pool.lastUpdatedAt);
707         uint256 bonusPerToken = bonus.accRewardsPerToken + bonusForTime / lpTotal;
708         uint256 rewardsWriteoff = rewardsWriteoffsLen <= i ? 0 : user.rewardsWriteoffs[i];
709         uint256 reward = user.amount * bonusPerToken / CAL_MULTIPLIER - rewardsWriteoff;
710         rewards[i] = reward < bonus.remBonus ? reward : bonus.remBonus;
711       }
712     }
713     return rewards;
714   }
715 
716 
717   function getPoolList() external view override returns (address[] memory) {
718     return poolList;
719   }
720 
721   /// @notice update pool's bonus per staked token till current block timestamp, do nothing if pool does not exist
722   function _updatePool(address _lpToken) private {
723     Pool storage pool = pools[_lpToken];
724     uint256 poolLastUpdatedAt = pool.lastUpdatedAt;
725     if (poolLastUpdatedAt == 0 || block.timestamp <= poolLastUpdatedAt) return;
726     pool.lastUpdatedAt = block.timestamp;
727     uint256 lpTotal = IERC20(_lpToken).balanceOf(address(this));
728     if (lpTotal == 0) return;
729 
730     for (uint256 i = 0; i < pool.bonuses.length; i ++) {
731       Bonus storage bonus = pool.bonuses[i];
732       if (poolLastUpdatedAt < bonus.endTime && bonus.startTime < block.timestamp) {
733         uint256 bonusForTime = _calRewardsForTime(bonus, poolLastUpdatedAt);
734         bonus.accRewardsPerToken = bonus.accRewardsPerToken + bonusForTime / lpTotal;
735       }
736     }
737   }
738 
739   function _updateUserWriteoffs(address _lpToken) private {
740     Bonus[] memory bonuses = pools[_lpToken].bonuses;
741     User storage user = users[_lpToken][msg.sender];
742     for (uint256 i = 0; i < bonuses.length; i++) {
743       // update writeoff to match current acc rewards per token
744       if (user.rewardsWriteoffs.length == i) {
745         user.rewardsWriteoffs.push(user.amount * bonuses[i].accRewardsPerToken / CAL_MULTIPLIER);
746       } else {
747         user.rewardsWriteoffs[i] = user.amount * bonuses[i].accRewardsPerToken / CAL_MULTIPLIER;
748       }
749     }
750   }
751 
752   /// @notice tranfer upto what the contract has
753   function _safeTransfer(address _token, uint256 _amount) private returns (uint256 _transferred) {
754     IERC20 token = IERC20(_token);
755     uint256 balance = token.balanceOf(address(this));
756     if (balance > _amount) {
757       token.safeTransfer(msg.sender, _amount);
758       _transferred = _amount;
759     } else if (balance > 0) {
760       token.safeTransfer(msg.sender, balance);
761       _transferred = balance;
762     }
763   }
764 
765   function _calRewardsForTime(Bonus memory _bonus, uint256 _lastUpdatedAt) internal view returns (uint256) {
766     if (_bonus.endTime <= _lastUpdatedAt) return 0;
767 
768     uint256 calEndTime = block.timestamp > _bonus.endTime ? _bonus.endTime : block.timestamp;
769     uint256 calStartTime = _lastUpdatedAt > _bonus.startTime ? _lastUpdatedAt : _bonus.startTime;
770     uint256 timePassed = calEndTime - calStartTime;
771     return _bonus.weeklyRewards * CAL_MULTIPLIER * timePassed / WEEK;
772   }
773 
774   function _claimRewards(address _lpToken, User memory _user) private {
775     // only claim if user has deposited before
776     if (_user.amount == 0) return;
777     uint256 rewardsWriteoffsLen = _user.rewardsWriteoffs.length;
778     Bonus[] memory bonuses = pools[_lpToken].bonuses;
779     for (uint256 i = 0; i < bonuses.length; i++) {
780       uint256 rewardsWriteoff = rewardsWriteoffsLen <= i ? 0 : _user.rewardsWriteoffs[i];
781       uint256 bonusSinceLastUpdate = _user.amount * bonuses[i].accRewardsPerToken / CAL_MULTIPLIER - rewardsWriteoff;
782       uint256 toTransfer = bonuses[i].remBonus < bonusSinceLastUpdate ? bonuses[i].remBonus : bonusSinceLastUpdate;
783       if (toTransfer == 0) continue;
784       uint256 transferred = _safeTransfer(bonuses[i].bonusTokenAddr, toTransfer);
785       pools[_lpToken].bonuses[i].remBonus = bonuses[i].remBonus - transferred;
786     }
787   }
788 
789   // only owner or authorized users from list
790   function _isAuthorized(address[] memory checkList) private view returns (bool) {
791     if (msg.sender == owner()) return true;
792 
793     for (uint256 i = 0; i < checkList.length; i++) {
794       if (msg.sender == checkList[i]) {
795         return true;
796       }
797     }
798     return false;
799   }
800 }