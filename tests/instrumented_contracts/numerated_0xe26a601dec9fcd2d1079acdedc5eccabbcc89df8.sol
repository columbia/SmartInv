1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 
72     /**
73      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
74      * `nonReentrant` function in the call stack.
75      */
76     function _reentrancyGuardEntered() internal view returns (bool) {
77         return _status == _ENTERED;
78     }
79 }
80 
81 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Interface of the ERC20 standard as defined in the EIP.
90  */
91 interface IERC20 {
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `to`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address to, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `from` to `to` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address from, address to, uint256 amount) external returns (bool);
160 }
161 
162 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 
170 /**
171  * @dev Interface for the optional metadata functions from the ERC20 standard.
172  *
173  * _Available since v4.1._
174  */
175 interface IERC20Metadata is IERC20 {
176     /**
177      * @dev Returns the name of the token.
178      */
179     function name() external view returns (string memory);
180 
181     /**
182      * @dev Returns the symbol of the token.
183      */
184     function symbol() external view returns (string memory);
185 
186     /**
187      * @dev Returns the decimals places of the token.
188      */
189     function decimals() external view returns (uint8);
190 }
191 
192 // File: @openzeppelin/contracts/utils/Context.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Provides information about the current execution context, including the
201  * sender of the transaction and its data. While these are generally available
202  * via msg.sender and msg.data, they should not be accessed in such a direct
203  * manner, since when dealing with meta-transactions the account sending and
204  * paying for execution may not be the actual sender (as far as an application
205  * is concerned).
206  *
207  * This contract is only required for intermediate, library-like contracts.
208  */
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view virtual returns (bytes calldata) {
215         return msg.data;
216     }
217 }
218 
219 // File: @openzeppelin/contracts/access/Ownable.sol
220 
221 
222 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 
227 /**
228  * @dev Contract module which provides a basic access control mechanism, where
229  * there is an account (an owner) that can be granted exclusive access to
230  * specific functions.
231  *
232  * By default, the owner account will be the one that deploys the contract. This
233  * can later be changed with {transferOwnership}.
234  *
235  * This module is used through inheritance. It will make available the modifier
236  * `onlyOwner`, which can be applied to your functions to restrict their use to
237  * the owner.
238  */
239 abstract contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor() {
248         _transferOwnership(_msgSender());
249     }
250 
251     /**
252      * @dev Throws if called by any account other than the owner.
253      */
254     modifier onlyOwner() {
255         _checkOwner();
256         _;
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if the sender is not the owner.
268      */
269     function _checkOwner() internal view virtual {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby disabling any functionality that is only available to the owner.
279      */
280     function renounceOwnership() public virtual onlyOwner {
281         _transferOwnership(address(0));
282     }
283 
284     /**
285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
286      * Can only be called by the current owner.
287      */
288     function transferOwnership(address newOwner) public virtual onlyOwner {
289         require(newOwner != address(0), "Ownable: new owner is the zero address");
290         _transferOwnership(newOwner);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Internal function without access restriction.
296      */
297     function _transferOwnership(address newOwner) internal virtual {
298         address oldOwner = _owner;
299         _owner = newOwner;
300         emit OwnershipTransferred(oldOwner, newOwner);
301     }
302 }
303 
304 // File: contracts/elmo_staking_v2.sol
305 
306 //SPDX-License-Identifier: MIT
307 
308 pragma solidity 0.8.19;
309 
310 
311 
312 
313 interface IBurn {
314     function publicBurn(uint256 amount) external;
315 }
316 interface IBalanceOf721 {
317     function balanceOf(address owner) external view returns (uint256 balance);
318 }
319 
320 contract Staking is Ownable, ReentrancyGuard {
321 //constant
322     uint256 public constant BURN_OPTION_ONE = 25;
323     uint256 public constant BURN_OPTION_TWO = 50;
324     uint256 public constant BURN_OPTION_THREE = 75;
325     uint256 public constant DELAY_WITHDRAW = 14 days;
326     uint256 public constant EMERGENCY_FEE = 10;
327     uint256 public immutable MAX_DEPOSIT_LIMIT; 
328     uint256 public immutable PRECISION_FACTOR;
329     uint256 public immutable TOKEN_DECIMALS;
330     
331 // bool
332     bool public hasUserLimit;
333     bool public isInitialized;
334     bool public poolIsOnline;
335     bool public depositEnabled = true;
336     bool public compoundEnabled = true;
337 //address
338     address public nftContractAddress;
339 // uint
340     uint256 public totalUsersInStaking;
341     uint256 public poolTotalReward;
342     uint256 public accTokenPerShare;
343     uint256 public startBlock;
344     uint256 public lastRewardBlock;
345     uint256 public rewardPerBlock;
346     uint256 public totalBurned;
347     uint256 public totalUsersStake;
348     uint256 public totalUsersRewards;
349     uint256 public nftBoostPercentage;
350     
351 // staking tokens
352     IERC20Metadata public rewardToken;
353 
354 // mapping
355     mapping(address => UserInfo) public userInfo;
356     mapping(uint => uint) public optionToBurn; //0=None 1=25% 2=50% 3=75%
357 // struct
358     struct UserInfo {
359         uint256 amount; // How many staked tokens the user has provided
360         uint256 rewardDebt; // Reward debt
361         uint256 withdrawInitTime; // // init the cooldown timer to withdraw, save block.timestamp
362         uint256 burnChosen; // burn option  
363         uint256 amountToWithdraw; // amount to withdraw
364     }
365 
366 // event
367     event Deposit(address indexed user, uint256 amount);
368     event EmergencyWithdraw(address indexed user, uint256 amount);
369     event Withdraw(address indexed user, uint256 amount);
370     event PoolFunded(uint256 amount);
371     event Compound(address indexed user, uint256 amount);
372     event ClaimReward(address indexed user, uint256 amount);
373     event UserCompoundUpdated(address indexed user, bool onDeposit, bool onWithdraw);
374     event WithdrawInitiated(address indexed user, uint256 amount, uint256 burnedAmount);
375     event PoolStateUpdated(bool poolIsOnline, bool depositEnabled, bool compoundEnabled);
376     event NftBoostUpdated(uint256 percentage);
377     event TokenRecovered(address indexed tokenAddress, uint256 tokenAmount);
378     event BlockRewardUpdated(uint256 rewardPerBlock);
379     event PoolStarted(uint256 startBlock, uint256 rewardPerBlock);
380 
381 //constructor
382     /// @notice Contract constructor that initializes the Smart Contract.
383     /// @param _rewardToken The address of the ERC20 token used as a reward.
384     /// @param _nftContractAddress The address of the NFT contract used as reward boost.
385     constructor(IERC20Metadata _rewardToken, address _nftContractAddress) {
386         rewardToken = _rewardToken;
387         TOKEN_DECIMALS = uint256(rewardToken.decimals());
388         require(TOKEN_DECIMALS < 30, "Must be inferior to 30");
389         MAX_DEPOSIT_LIMIT= 2000000*10**TOKEN_DECIMALS;
390         PRECISION_FACTOR = uint256(10**(uint256(30) - TOKEN_DECIMALS));
391         optionToBurn[1] = BURN_OPTION_ONE;
392         optionToBurn[2] = BURN_OPTION_TWO;
393         optionToBurn[3] = BURN_OPTION_THREE;
394         nftContractAddress = _nftContractAddress;
395     }
396 
397 //owner function
398     /// @notice Allows the contract owner to set the state of the pool.
399     /// @param _poolIsOnline Enable or disable the pool.
400     /// @param _depositEnabled Enable or disable user deposits.
401     /// @param _compoundEnabled Enable or disable user compound functionality.
402     function setPoolState(bool _poolIsOnline, bool _depositEnabled, bool _compoundEnabled) external onlyOwner {
403         poolIsOnline = _poolIsOnline;
404         depositEnabled = _depositEnabled;
405         compoundEnabled = _compoundEnabled; 
406         emit PoolStateUpdated(_poolIsOnline, _depositEnabled, _compoundEnabled);
407     }
408 
409     /// @notice Allows the contract owner to set the NFT boost percentage.
410     /// @param _percentage The new NFT boost percentage to be set.
411     function setNftBoostPercentage(uint256 _percentage) external onlyOwner {
412         nftBoostPercentage = _percentage;
413         emit NftBoostUpdated(_percentage);
414     }
415 
416     /// @notice Allows the contract owner to recover wrongly sent tokens to the contract.
417     /// @param _tokenAddress The address of the token to be recovered.
418     /// @param _tokenAmount The amount of tokens to be recovered.
419     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner { //@msg NOT Withdraw any tokens from the contract
420         require(_tokenAddress != address(rewardToken), "Cannot be staked or reward tokens");
421         IERC20Metadata(_tokenAddress).transfer(address(msg.sender), _tokenAmount);
422         emit TokenRecovered(_tokenAddress, _tokenAmount);
423     }
424 
425     /// @notice Allows the contract owner to update the reward rate per block.
426     /// @param _rewardPerBlock The new token amount per block to be set.
427     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner { //@msg Update APY
428         require(_rewardPerBlock > 0, "Reward per block should be greater than 0");
429         rewardPerBlock = _rewardPerBlock;
430         emit BlockRewardUpdated(_rewardPerBlock);
431     }
432 
433     /// @notice Initializes the staking pool with the provided reward rate per block.
434     /// @param _rewardPerBlock The reward rate per block to be set for the staking pool.
435     function istart(uint256 _rewardPerBlock) external onlyOwner {
436         require(!isInitialized, "Already initialized");
437         isInitialized = true;
438         rewardPerBlock = _rewardPerBlock;
439         startBlock = block.number;
440         poolIsOnline = true;
441         lastRewardBlock = startBlock;
442         emit PoolStarted(startBlock, _rewardPerBlock);
443     }
444 
445 //modifier
446     /// @notice Modifier to check if the staking pool is online and available for certain actions.
447     /// @param actionType The type of action: 0 for deposit, 1 for compound.
448     modifier isPoolOnline(uint8 actionType) {
449         require(poolIsOnline || msg.sender == owner(),"staking platform not available now.");
450         if (actionType == 0) {
451             require(depositEnabled || msg.sender == owner(),"deposits not available now.");
452         }
453         else if (actionType == 1) {
454             require(compoundEnabled || msg.sender == owner(),"compounds not available now.");
455         } 
456         _;
457     }
458 
459 
460 // user functions
461     /// @notice Allows users to top up the staking pool with additional reward tokens.
462     /// @param amount The amount of reward tokens to be added to the pool.
463     function fundPool(uint256 amount) external {
464         poolTotalReward += amount;
465         rewardToken.transferFrom(address(msg.sender), address(this), amount);
466         emit PoolFunded(amount);
467     }
468 
469     /// @notice Allows users to deposit tokens into the staking pool.
470     /// @param _amount The amount of reward tokens to be deposited into the staking pool.
471     /// @param _burnOption The chosen burn option (1-25%, 2-50%, 3-75%) for the user's rewards.
472     function deposit(uint256 _amount, uint256 _burnOption) external isPoolOnline(0) nonReentrant {
473         require(_burnOption == 1 || _burnOption == 2 || _burnOption == 3, "invalid burn option");
474         require(userInfo[msg.sender].withdrawInitTime < block.timestamp, "cooldown not passed");
475         UserInfo storage user = userInfo[msg.sender];
476         uint userAmountBefore = user.amount;
477         require(_amount + userAmountBefore <= MAX_DEPOSIT_LIMIT, "User amount above limit");
478         if (_amount != 0) {
479             user.amount = userAmountBefore + _amount;
480             totalUsersStake += _amount;
481             rewardToken.transferFrom(address(msg.sender), address(this), _amount);
482         }else{
483             revert("can't deposit 0 tokens");
484         }
485         if (userAmountBefore == 0) {
486             totalUsersInStaking += 1;
487             user.burnChosen = _burnOption;
488         }
489 
490         _updatePool();
491 
492         user.rewardDebt = user.amount * accTokenPerShare / PRECISION_FACTOR;
493 
494         emit Deposit(msg.sender, _amount);
495     }
496 
497     /// @notice Initiates the withdrawal process for the staked reward tokens.
498     function initWithdraw() external nonReentrant {// unstack init
499         UserInfo storage user = userInfo[msg.sender];
500         uint userAmnt = user.amount;
501         require(userAmnt != 0, "No amount stacked");
502         require(user.amountToWithdraw == 0, "Withdraw already initiated");
503         _updatePool();
504         uint burnAmnout;
505         uint256 pending =_internalPendingCalc(userAmnt, accTokenPerShare, user.rewardDebt); 
506         if (pending != 0) {
507             totalUsersRewards += pending;
508             poolTotalReward -= pending;
509             burnAmnout = pending * optionToBurn[user.burnChosen] / 100;
510             totalBurned += burnAmnout;
511             user.amountToWithdraw = userAmnt + (pending - burnAmnout);
512             IBurn(address(rewardToken)).publicBurn(burnAmnout);
513             emit ClaimReward(msg.sender,pending - burnAmnout);
514         }else{
515             user.amountToWithdraw = userAmnt;
516         }
517         totalUsersInStaking -= 1;
518         totalUsersStake -= userAmnt;
519         user.withdrawInitTime = block.timestamp;
520         user.rewardDebt = userAmnt * accTokenPerShare / PRECISION_FACTOR;
521         emit WithdrawInitiated(msg.sender, userAmnt + (pending - burnAmnout), burnAmnout);
522     }
523 
524     /// @notice Allows users to withdraw their pending rewards from the staking pool.
525     function withdrawReward() external nonReentrant{ 
526         UserInfo storage user = userInfo[msg.sender];
527         require(user.amountToWithdraw == 0, "Cant have rewards if withdraw initiated");
528         uint userAmnt = user.amount;
529         require(userAmnt != 0, "0 stacked");
530         _updatePool();
531 
532         uint256 pending = _internalPendingCalc(userAmnt, accTokenPerShare, user.rewardDebt); 
533         if (pending > 0) {
534             totalUsersRewards += pending;
535             poolTotalReward -= pending;
536             uint burnAmnout = pending * optionToBurn[user.burnChosen] / 100;
537             totalBurned += burnAmnout;
538             IBurn(address(rewardToken)).publicBurn(burnAmnout);
539             rewardToken.transfer(address(msg.sender), pending-burnAmnout);
540             emit ClaimReward(msg.sender,pending - burnAmnout);
541         }
542         user.rewardDebt = userAmnt * accTokenPerShare / PRECISION_FACTOR;
543     }
544 
545     /// @notice Allows users to withdraw their staked reward tokens after the lock time has passed.
546     function withdraw() external nonReentrant {// unstack
547         UserInfo storage user = userInfo[msg.sender];
548         uint256 amountToWithdraw = user.amountToWithdraw;
549         require(amountToWithdraw != 0, "No amount to withdraw");
550         require(user.withdrawInitTime + DELAY_WITHDRAW <= block.timestamp, "Minimum lock time not reached");
551         
552         delete userInfo[msg.sender];
553         rewardToken.transfer(address(msg.sender), amountToWithdraw);
554         
555         emit Withdraw(msg.sender, amountToWithdraw);
556     }
557 
558 
559     /// @notice Allows users to compound their pending rewards by adding them to their staked amount.
560     function compound() external isPoolOnline(1) nonReentrant {
561         UserInfo storage user = userInfo[msg.sender];
562         uint userAmnt = user.amount;
563         require(userAmnt != 0, "No amount stacked");
564         require(user.amountToWithdraw == 0, "Cant compound if withdraw initiated");
565         if(userAmnt != 0) {
566             _updatePool();
567             uint pending = _internalPendingCalc(userAmnt, accTokenPerShare, user.rewardDebt);
568             if(pending != 0) {
569                 totalUsersRewards += pending;
570                 poolTotalReward -= pending;
571                 uint burnAmnout = pending * optionToBurn[user.burnChosen] / 100;
572                 uint effectivePending = pending - burnAmnout;
573                 totalBurned += burnAmnout;
574                 totalUsersStake += effectivePending;
575                 user.amount = user.amount + effectivePending;
576                 user.rewardDebt = user.amount * accTokenPerShare / PRECISION_FACTOR;
577                 IBurn(address(rewardToken)).publicBurn(burnAmnout);
578                 emit Compound(msg.sender, effectivePending);
579             }
580         } else {
581             revert("nothing to compound");
582         }
583     }
584 
585     // @notice Allows users to perform an emergency withdrawal from the staking pool.
586     function emergencyWithdraw() external nonReentrant {
587         UserInfo storage user = userInfo[msg.sender];
588         uint256 amountToWithdraw = user.amount;
589         require(amountToWithdraw != 0, "No amount to withdraw");
590         totalUsersStake -= amountToWithdraw;
591         uint256 feePart = (amountToWithdraw * EMERGENCY_FEE / 100);
592         amountToWithdraw = amountToWithdraw - feePart; //fee back to pool
593         poolTotalReward += feePart;
594         totalUsersInStaking -= 1;
595         delete userInfo[msg.sender];
596         rewardToken.transfer(address(msg.sender), amountToWithdraw);
597         emit EmergencyWithdraw(msg.sender, amountToWithdraw);
598     }
599 
600 
601 
602     /// @notice Calculates the pending rewards for a user's staked amount, considering the NFT boost.
603     /// @param amnt The user's staked amount for which the pending rewards are calculated.
604     /// @param accTokenShare The accumulated token share in the staking pool at the time of calculation.
605     /// @param debt The user's reward debt at the time of calculation.
606     /// @return pending The calculated pending rewards for the user's staked amount, considering the NFT boost.
607     function _internalPendingCalc(uint amnt, uint accTokenShare, uint debt) internal view returns(uint256 pending) { 
608         pending = amnt * accTokenShare / PRECISION_FACTOR - debt;
609         uint hasNft = IBalanceOf721(nftContractAddress).balanceOf(msg.sender); 
610         if(hasNft != 0) {
611             pending = pending+(pending * nftBoostPercentage / 100);
612         }
613         return pending;
614     }
615 
616 
617     /// @notice Calculates the pending and effective pending rewards for a specific user, considering the NFT boost(if applicable).
618     /// @param _user The address of the user for whom the rewards are to be calculated.
619     /// @return pending The total pending rewards for the user's staked amount, including the NFT boost if applicable.
620     /// @return effectivePending The effective pending rewards after considering the burn option (if any) and NFT boost (if applicable).
621     function pendingReward(address _user) external view returns (uint256 pending, uint256 effectivePending) {
622         UserInfo storage user = userInfo[_user];
623         if(user.amountToWithdraw != 0){
624             pending = 0;
625             effectivePending = user.amountToWithdraw;
626         } else {
627             if (block.number > lastRewardBlock && totalUsersStake != 0) {
628                 uint256 multiplier = block.number - lastRewardBlock;
629                 uint256 cakeReward = multiplier * rewardPerBlock;
630                 uint256 adjustedTokenPerShare = accTokenPerShare + (cakeReward * PRECISION_FACTOR / totalUsersStake);
631                 pending = user.amount * adjustedTokenPerShare / PRECISION_FACTOR - user.rewardDebt;
632 
633             } else {
634                 pending = user.amount * accTokenPerShare / PRECISION_FACTOR - user.rewardDebt;
635             }
636             uint hasNft = IBalanceOf721(nftContractAddress).balanceOf(_user); 
637             if(hasNft != 0) {
638                 pending = pending + (pending * nftBoostPercentage / 100);
639             }
640             uint burnAmnout = pending * optionToBurn[user.burnChosen] / 100;
641             effectivePending = pending - burnAmnout;
642         }
643     }
644 
645     /// @notice Updates the staking pool by calculating and accumulating the reward tokens (cakeReward) per share of staked tokens.
646     function _updatePool() internal {
647         if (block.number <= lastRewardBlock) {
648             return;
649         }
650         uint256 stakedTokenSupply = totalUsersStake;
651         if (stakedTokenSupply == 0) {
652             lastRewardBlock = block.number;
653             return;
654         }
655         uint256 multiplier = block.number - lastRewardBlock;
656         uint256 cakeReward = multiplier * rewardPerBlock;
657         accTokenPerShare = accTokenPerShare + (cakeReward * PRECISION_FACTOR / stakedTokenSupply);
658         lastRewardBlock = block.number;
659     }
660 
661     /// @notice Get the available balance of the staking pool.
662     /// @return calc The available balance of the staking pool (total reward tokens available for distribution).
663     function getPoolEffectiveBalance() external view returns(uint256 calc){
664         calc = rewardToken.balanceOf(address(this)) - totalUsersStake;
665         return calc;
666     }
667 
668     /// @notice Calculate the Annual Percentage Yield (APY) for the staking pool.
669     /// @return calculatedApr The calculated Annual Percentage Yield (APY) for the staking pool.
670     function calculateAPR() external view returns (uint256 calculatedApr, uint256 aprWithNft) {
671         uint blockPerYear = (86400/12)*365; 
672         if (totalUsersStake == 0 || poolTotalReward == 0) {
673             calculatedApr = 0;
674             aprWithNft = 0;
675         }else{
676             calculatedApr = (rewardPerBlock * blockPerYear) / totalUsersStake;
677             uint blockBoosted = rewardPerBlock + (rewardPerBlock * nftBoostPercentage / 100);
678             aprWithNft = (blockBoosted * blockPerYear) / totalUsersStake;
679         }
680         
681     }
682 
683 }