1 // SPDX-License-Identifier: MIT
2 // 84 71 32 64 84 104 101 71 104 111 115 116 68 101 118 
3 // ASCII
4 
5 pragma solidity ^0.8.0;
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
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
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, with an overflow flag.
108      *
109      * _Available since v3.4._
110      */
111     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
112         uint256 c = a + b;
113         if (c < a) return (false, 0);
114         return (true, c);
115     }
116 
117     /**
118      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         if (b > a) return (false, 0);
124         return (true, a - b);
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
134         // benefit is lost if 'b' is also tested.
135         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
136         if (a == 0) return (true, 0);
137         uint256 c = a * b;
138         if (c / a != b) return (false, 0);
139         return (true, c);
140     }
141 
142     /**
143      * @dev Returns the division of two unsigned integers, with a division by zero flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         if (b == 0) return (false, 0);
149         return (true, a / b);
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         if (b == 0) return (false, 0);
159         return (true, a % b);
160     }
161 
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      *
170      * - Addition cannot overflow.
171      */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a + b;
174         require(c >= a, "SafeMath: addition overflow");
175         return c;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting on
180      * overflow (when the result is negative).
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      *
186      * - Subtraction cannot overflow.
187      */
188     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b <= a, "SafeMath: subtraction overflow");
190         return a - b;
191     }
192 
193     /**
194      * @dev Returns the multiplication of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `*` operator.
198      *
199      * Requirements:
200      *
201      * - Multiplication cannot overflow.
202      */
203     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
204         if (a == 0) return 0;
205         uint256 c = a * b;
206         require(c / a == b, "SafeMath: multiplication overflow");
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers, reverting on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         require(b > 0, "SafeMath: division by zero");
224         return a / b;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * reverting when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         require(b > 0, "SafeMath: modulo by zero");
241         return a % b;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
246      * overflow (when the result is negative).
247      *
248      * CAUTION: This function is deprecated because it requires allocating memory for the error
249      * message unnecessarily. For custom revert reasons use {trySub}.
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      *
255      * - Subtraction cannot overflow.
256      */
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         return a - b;
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
264      * division by zero. The result is rounded towards zero.
265      *
266      * CAUTION: This function is deprecated because it requires allocating memory for the error
267      * message unnecessarily. For custom revert reasons use {tryDiv}.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b > 0, errorMessage);
279         return a / b;
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * reverting with custom message when dividing by zero.
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {tryMod}.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b > 0, errorMessage);
299         return a % b;
300     }
301 }
302 
303 
304 interface IERC20 {
305     function decimals() external view returns (uint8);
306     function totalSupply() external view returns (uint256);
307     function balanceOf(address account) external view returns (uint256);
308     function transfer(address recipient, uint256 amount) external returns (bool);
309     function allowance(address owner, address spender) external view returns (uint256);
310     function approve(address spender, uint256 amount) external returns (bool);
311     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
312     event Transfer(address indexed from, address indexed to, uint256 value);
313     event Approval(address indexed owner, address indexed spender, uint256 value);
314 }
315 
316 contract SwapContract is Ownable {
317     using SafeMath for uint256;
318 
319     IERC20 public tokenOutput;
320 
321     struct TokenInputInfo {
322         address addr;
323         uint256 rateInput;
324         uint256 rateOutput;
325     }
326     mapping (uint256 => TokenInputInfo) public tokenInput;
327 
328     uint256 SEED_CLIFF = 30 days;
329     uint256 SEED_RELEASE_EACH_MONTH = 833; // 8.33%
330     struct VipVesting {
331         uint256 totalBalance;
332         uint256 totalClaimed;
333         uint256 start;
334         uint256 end;
335         uint256 claimedCheckPoint;
336 
337         // To calculate Reward
338         uint256 rewardTokenDebt;
339         uint256 rewardEthDebt;
340     }
341     mapping (address => VipVesting) public vestingList;
342     mapping (address => bool) public isBlacklistWallet;
343 
344     uint256 public totalTokenForSwapping;
345     uint256 public totalTokenForSeed;
346     uint256 public totalTokenForPublic;
347 
348     uint256 public soldAmountSeed        = 0;
349     uint256 public soldAmountPublic      = 0;
350     uint256 public soldTotal             = 0;
351 
352     uint256 public TYPE_SEED = 1;
353     uint256 public TYPE_PUBLIC = 2;
354 
355     uint256 public MONTH = 30 days;
356 
357     bool public swapEnabled;
358 
359     constructor() {}    
360     
361     function startSwap(address outputToken) public onlyOwner{
362         require(swapEnabled == false, "Swap already started");
363         tokenOutput = IERC20(outputToken);
364         swapEnabled = true;
365     }
366 
367     function stopSwap() public onlyOwner {
368         swapEnabled = false;
369     }
370 
371     function addInputTokenForSwap(uint256 _id, address _inputToken, uint256 _inputRate, uint256 _outputRate)public onlyOwner{
372         require(_id < 3);
373         tokenInput[_id].addr = _inputToken;
374         tokenInput[_id].rateInput = _inputRate;
375         tokenInput[_id].rateOutput = _outputRate;
376     }
377 
378     receive() external payable {
379     }
380 
381     function setBlacklistWallet(address account, bool blacklisted) external onlyOwner {
382         isBlacklistWallet[account] = blacklisted;
383     }
384 
385     function addOutputTokenForSwap(uint256 amount) public{    
386         tokenOutput.transferFrom(msg.sender, address(this), amount);
387         totalTokenForSwapping = totalTokenForSwapping.add(amount);
388     }
389 
390     function ownerWithdrawToken(address tokenAddress, uint256 amount) public onlyOwner{    
391         if(tokenAddress == address(tokenOutput)){
392             require(amount < totalTokenForSwapping.sub(soldTotal), "You're trying withdraw an amount that exceed availabe balance");
393             totalTokenForSwapping = totalTokenForSwapping.sub(amount);
394         }
395         IERC20(tokenAddress).transfer(msg.sender, amount);
396     }
397 
398     function getClaimableInVesting(address account) public view returns (uint256){
399         VipVesting memory vestPlan = vestingList[account];
400 
401         //Already withdraw all
402         if(vestPlan.totalClaimed >= vestPlan.totalBalance){
403             return 0;
404         }
405 
406         //No infor
407         if(vestPlan.start == 0 || vestPlan.end == 0 || vestPlan.totalBalance == 0){
408             return 0;
409         }
410         
411         uint256 currentTime = block.timestamp;
412         if(currentTime >= vestPlan.end){
413             return vestPlan.totalBalance.sub(vestPlan.totalClaimed);
414         }else if(currentTime < vestPlan.start + SEED_CLIFF){
415             return 0;
416         }else {
417             uint256 currentCheckPoint = 1 + (currentTime - vestPlan.start - SEED_CLIFF) / MONTH;
418             if(currentCheckPoint > vestPlan.claimedCheckPoint){
419                 uint256 claimable =  ((currentCheckPoint - vestPlan.claimedCheckPoint) * SEED_RELEASE_EACH_MONTH * vestPlan.totalBalance) / 10000;
420                 return claimable;
421             }else
422                 return 0;
423         }
424     }
425 
426     function balanceRemainingInVesting(address account) public view returns(uint256){
427         VipVesting memory vestPlan = vestingList[account];
428         return vestPlan.totalBalance -  vestPlan.totalClaimed;
429     }
430 
431     function withDrawFromVesting() public {
432         VipVesting storage vestPlan = vestingList[msg.sender];
433 
434         uint256 claimableAmount = getClaimableInVesting(msg.sender);
435         require(claimableAmount > 0, "There isn't token in vesting that's claimable at the moment");
436 
437         uint256 currentTime = block.timestamp;
438         if(currentTime > vestPlan.end){
439             currentTime = vestPlan.end;
440         }
441         
442         vestPlan.claimedCheckPoint = 1 + (currentTime - vestPlan.start - SEED_CLIFF) / MONTH;
443         vestPlan.totalClaimed = vestPlan.totalClaimed.add(claimableAmount);
444 
445         tokenOutput.transfer(msg.sender, claimableAmount);
446     }
447 
448     function deposite(uint256 inputTokenId, uint256 inputAmount, uint256 buyType) public payable {
449         require(inputTokenId < 3, "Invalid input token ID");
450         require(isBlacklistWallet[msg.sender] == false, "You're in blacklist");
451         require(swapEnabled, "Swap is not available");
452 
453         IERC20 inputToken = IERC20(tokenInput[inputTokenId].addr);
454 
455         uint256 numOutputToken = inputAmount.mul(tokenInput[inputTokenId].rateOutput).mul(10**tokenOutput.decimals()).div(tokenInput[inputTokenId].rateInput);
456         if(buyType == TYPE_SEED)
457             numOutputToken = numOutputToken.mul(3);
458      
459         require(numOutputToken < totalTokenForSwapping.sub(soldTotal), "Exceed avaialble token");
460 
461         inputToken.transferFrom(msg.sender, address(this), inputAmount.mul(10**inputToken.decimals()));
462         soldTotal = soldTotal.add(numOutputToken);
463         addingVestToken(msg.sender, numOutputToken, buyType);
464     }
465 
466     function addingVestToken(address account, uint256 amount, uint256 vType) private {
467         if(vType == TYPE_SEED){
468             VipVesting storage vestPlan = vestingList[account];
469             soldAmountSeed = soldAmountSeed.add(amount);
470             vestPlan.totalBalance = vestPlan.totalBalance.add(amount);
471             vestPlan.start = vestPlan.start == 0 ? block.timestamp : vestPlan.start;
472             vestPlan.end = vestPlan.end == 0 ? block.timestamp + SEED_CLIFF + (10000 / SEED_RELEASE_EACH_MONTH) * MONTH : vestPlan.end;
473         }else{
474             soldAmountPublic = soldAmountPublic.add(amount);
475             tokenOutput.transfer(account, amount);
476             return;
477         }
478     }
479 
480     /*REWARD FOR VESTING*/
481     address public rewardToken;
482     uint256 public amountTokenForReward;
483     uint256 public amountEthForReward;
484 
485     uint256 public totalRewardEthDistributed;
486     uint256 public totalRewardTokenDistributed;
487 
488     uint256 public rewardTokenPerSecond;
489     uint256 public rewardEthPerSecond;
490 
491     // Accrued token per share
492     uint256 public accTokenPerShare;    
493     // Accrued EHT per share
494     uint256 public accEthPerShare;
495     // The block number of the last pool update
496     uint256 public lastRewardTime;
497     // The precision factor
498     uint256 public PRECISION_FACTOR = 10**12;
499 
500     bool public enableRewardSystem;
501 
502     function startRewardSystem(address _rewardToken) public onlyOwner{
503         enableRewardSystem = true;
504         rewardToken = _rewardToken;
505         rewardTokenPerSecond = 0.05 ether;   // 0.65 token/block
506         rewardEthPerSecond = 0.000004 ether; // 10 eth/month
507         
508         lastRewardTime = block.timestamp;
509     }
510 
511     function setNewRewardToken(address _rewardToken)public onlyOwner{
512         rewardToken = _rewardToken;
513     }
514 
515     function setRewardTokenPerSecond(uint256 _rewardTokenPerSecond) public onlyOwner{
516         rewardTokenPerSecond = _rewardTokenPerSecond;
517     }
518 
519     function setRewardEthPerSecond(uint256 _rewardEthPerSecond) public onlyOwner{
520         rewardEthPerSecond = _rewardEthPerSecond;
521     }
522 
523     function addTokenForReward(uint256 amount) public {
524         IERC20(rewardToken).transferFrom(msg.sender, address(this), amount);
525         amountTokenForReward = amountTokenForReward.add(amount);
526     }
527 
528     function addEthForReward() payable public {
529         amountEthForReward = amountEthForReward.add(msg.value);
530     }
531 
532      
533     /*
534      * Harvest reward
535      */
536     function harvest() public {
537         _updatePool();
538         VipVesting storage user = vestingList[msg.sender];
539 
540         if (user.totalBalance > 0) {
541             uint256 pendingToken = user.totalBalance.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardTokenDebt);
542             uint256 pendingEth = user.totalBalance.mul(accEthPerShare).div(PRECISION_FACTOR).sub(user.rewardEthDebt);
543             if (pendingToken > 0) {
544                 IERC20(rewardToken).transfer( address(msg.sender), pendingToken);
545             }
546             if (pendingEth > 0) {
547                 payable(msg.sender).transfer(pendingEth);
548             }
549         }
550         user.rewardTokenDebt = user.totalBalance.mul(accTokenPerShare).div(PRECISION_FACTOR);
551         user.rewardEthDebt = user.totalBalance.mul(accEthPerShare).div(PRECISION_FACTOR);
552     }
553 
554     /*
555      * @notice View function to see pending reward on frontend.
556      * @param _user: user address
557      * @return Pending reward for a given user
558      */
559     function pendingReward(address _user) external view returns (uint256, uint256) {
560         VipVesting storage user = vestingList[_user];
561         uint256 pendingToken;
562         uint256 pendingEth;
563         
564         if(enableRewardSystem ==  false){
565             return (0, 0);
566         }
567 
568         if (block.timestamp > lastRewardTime && soldAmountSeed != 0) {
569             uint256 multiplier = _getMultiplier(lastRewardTime, block.timestamp);
570 
571             uint256 tokenReward = multiplier.mul(rewardTokenPerSecond);
572             if(tokenReward > amountTokenForReward){
573                 tokenReward = amountTokenForReward;
574             }
575             uint256 adjustedTokenPerShare = accTokenPerShare.add(tokenReward.mul(PRECISION_FACTOR).div(soldAmountSeed));
576 
577             uint256 ethReward = multiplier.mul(rewardEthPerSecond);
578             if(ethReward > amountEthForReward){
579                 ethReward = amountEthForReward;
580             }
581             uint256 adjustedEthPerShare = accEthPerShare.add(ethReward.mul(PRECISION_FACTOR).div(soldAmountSeed));
582 
583             pendingToken =  user.totalBalance.mul(adjustedTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardTokenDebt);
584             pendingEth =  user.totalBalance.mul(adjustedEthPerShare).div(PRECISION_FACTOR).sub(user.rewardEthDebt);
585         } else {
586             pendingToken = user.totalBalance.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardTokenDebt);
587             pendingEth = user.totalBalance.mul(accEthPerShare).div(PRECISION_FACTOR).sub(user.rewardEthDebt);
588         }
589 
590         return (pendingToken, pendingEth);
591     }
592 
593 
594     /*
595      * @notice Update reward variables of the given pool to be up-to-date.
596      */
597     function _updatePool() internal {
598         if (block.timestamp <= lastRewardTime) {
599             return;
600         }
601 
602         if (enableRewardSystem == false || soldAmountSeed == 0) {
603             lastRewardTime = block.timestamp;
604             return;
605         }
606 
607         uint256 multiplier = _getMultiplier(lastRewardTime, block.timestamp);
608 
609         uint256 tokenReward = multiplier.mul(rewardTokenPerSecond);
610         if(tokenReward > amountTokenForReward){
611             tokenReward = amountTokenForReward;
612         }
613         accTokenPerShare = accTokenPerShare.add(tokenReward.mul(PRECISION_FACTOR).div(soldAmountSeed));
614         amountTokenForReward = amountTokenForReward.sub(tokenReward);
615         totalRewardTokenDistributed = totalRewardTokenDistributed.add(tokenReward);
616 
617 
618         uint256 ethReward = multiplier.mul(rewardEthPerSecond);
619         if(ethReward > amountEthForReward){
620             ethReward = amountEthForReward;
621         }
622         accEthPerShare = accEthPerShare.add(ethReward.mul(PRECISION_FACTOR).div(soldAmountSeed));
623         amountEthForReward = amountEthForReward.sub(ethReward);
624         totalRewardEthDistributed = totalRewardEthDistributed.add(ethReward);
625 
626         lastRewardTime = block.timestamp;
627     }
628 
629     /*
630      * @notice Return reward multiplier over the given _from to _to block.
631      * @param _from: block to start
632      * @param _to: block to finish
633      */
634     function _getMultiplier(uint256 _from, uint256 _to) internal pure returns (uint256) {
635             return _to.sub(_from);
636     }
637 
638 
639 }