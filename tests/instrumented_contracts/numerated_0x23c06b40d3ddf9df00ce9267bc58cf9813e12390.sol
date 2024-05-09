1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _transferOwnership(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _transferOwnership(newOwner);
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Internal function without access restriction.
164      */
165     function _transferOwnership(address newOwner) internal virtual {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 // File: contracts/PYRstake.sol
173 
174 
175 pragma solidity ^0.8.7;
176 
177 
178 
179 interface IERC20 {
180     function totalSupply() external view returns (uint256);
181     function decimals() external view returns (uint8);
182     function symbol() external view returns (string memory);
183     function name() external view returns (string memory);
184     function getOwner() external view returns (address);
185     function balanceOf(address account) external view returns (uint256);
186     function transfer(address recipient, uint256 amount)
187         external
188         returns (bool);
189     function allowance(address _owner, address spender)
190         external
191         view
192         returns (uint256);
193     function approve(address spender, uint256 amount) external returns (bool);
194     function transferFrom(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) external returns (bool);
199     event Transfer(address indexed from, address indexed to, uint256 value);
200     event Approval(
201         address indexed owner,
202         address indexed spender,
203         uint256 value
204     );
205 }
206 
207 interface IERC721 {
208     function balanceOf(address owner) external view returns (uint256 balance);
209     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
210     function ownerOf(uint256 tokenId) external view returns (address owner);
211     function walletOfOwner(address _owner) external view returns (uint256[] memory);
212 }
213 
214 contract HydraStake is Ownable, ReentrancyGuard {
215     
216     struct user{
217         uint256 id;
218         uint256 totalStakedBalance;
219         uint256 totalClaimedRewards;
220         uint256 createdTime;
221     }
222 
223     struct stakePool{
224         uint256 id;
225         uint256 duration;
226         uint256 multiplier; // Used for dynamic APY
227         uint256 APY; // Used for fixed APY
228         uint256 withdrawalFee;
229         uint256 unstakePenalty;
230         uint256 stakedTokens;
231         uint256 claimedRewards;
232         uint256 status; //1: created, 2: active, 3: cancelled
233         address creator;
234         uint256 createdTime;
235     }
236 
237     stakePool[] public stakePoolArray;
238 
239     struct userStake{
240         uint256 id;
241         uint256 stakePoolId;
242 	    uint256 stakeBalance;
243     	uint256 totalClaimedRewards;
244     	uint256 lastClaimedTime;
245         address tokenAddress;
246         uint256 status; //0 : Unstaked, 1 : Staked
247         address owner;
248     	uint256 createdTime;
249         uint256 unlockTime;
250         uint256 lockDuration;
251     }
252 
253     userStake[] public userStakeArray;
254 
255 
256     mapping (uint256 => stakePool) public stakePoolsById;
257     mapping (uint256 => userStake) public userStakesById;
258 
259     mapping (address => uint256[]) public userStakeIds;
260     mapping (address => userStake[]) userStakeLists;
261    
262     mapping (address => user) users;
263 
264     uint256 public totalStakedBalance;
265     uint256 public totalClaimedBalance;
266     uint256 public magnitude = 100000000;
267 
268     uint256 public userIndex;
269     uint256 public poolIndex;
270     uint256 public stakeIndex;
271 
272     bool public dynamicApy = false;
273     bool public unstakePenalty = true; 
274     bool public isPaused = false;
275 
276     address baseTokenAddress = 0x1165Ce434377D9E0CafF79F9562B6cFC1C3d8Ea3;
277     IERC20 stakeToken = IERC20(baseTokenAddress);
278 
279     address rewardTokensAddress = 0x1165Ce434377D9E0CafF79F9562B6cFC1C3d8Ea3;
280     IERC20 rewardToken = IERC20(rewardTokensAddress);
281     
282 
283     modifier unpaused {
284       require(isPaused == false);
285       _;
286     }
287 
288     modifier paused {
289       require(isPaused == true);
290       _;
291     }
292 
293     constructor() {   
294         
295         addStakePool(
296             1, // Duration in days
297             0, // Multiplier -- applicable for dynamic APY pools only
298             365, // APY % -- applicable for fixed APY pools only
299             0, // Withdrawal Fee %
300             2 // Unstaking Penalty %
301         );
302 
303         
304         addStakePool(
305             7,
306             0, 
307             450,
308             0,
309             2
310         );
311 
312         addStakePool(
313             30,
314             0,
315             550,
316             0,
317             2
318         );
319 
320          addStakePool(
321             90,
322             0,
323             640,
324             0,
325             2
326         );
327         
328     }
329     
330     function addStakePool(uint256 _duration, uint256 _multiplier, uint256 _apy, uint256 _withdrawalFee, uint256 _unstakePenalty ) public onlyOwner returns (bool){
331     
332         stakePool memory stakePoolDetails;
333         
334         stakePoolDetails.id = poolIndex;
335         stakePoolDetails.duration = _duration;
336         stakePoolDetails.multiplier = _multiplier;
337         stakePoolDetails.APY = _apy;
338         stakePoolDetails.withdrawalFee = _withdrawalFee;
339         stakePoolDetails.unstakePenalty = _unstakePenalty;
340         stakePoolDetails.creator = msg.sender;
341         stakePoolDetails.createdTime = block.timestamp;
342        
343         stakePoolArray.push(stakePoolDetails);
344         stakePoolsById[poolIndex++] = stakePoolDetails;
345 
346         return true;
347     }
348 
349     function getFixedAPY(uint256 _stakePoolId) public view returns (uint256){
350         stakePool memory stakePoolDetails = getStakePoolDetailsById(_stakePoolId);
351         return stakePoolDetails.APY;
352     }
353 
354     function getDynamicAPY(uint256 _stakePoolId) public view returns (uint256) {
355         uint256 rewardTokenBalance = rewardToken.balanceOf(address(this));
356         stakePool memory stakePoolDetails = getStakePoolDetailsById(_stakePoolId);
357         uint256 poolMultiplier = stakePoolDetails.multiplier;
358         uint256 totalPoolsAPY = rewardTokenBalance / totalStakedBalance;
359         return (totalPoolsAPY * poolMultiplier);
360     }
361 
362     function getDynamicAPYOfAllPools() public view returns (uint256[] memory) {
363         
364         uint256[] memory allPoolAPY = new uint256[](stakePoolArray.length);
365         uint256 rewardTokenBalance = rewardToken.balanceOf(address(this));
366 
367         stakePool memory stakePoolDetails;
368         uint256 poolMultiplier;
369         uint256 totalPoolsAPY;
370         uint256 stakePoolAPY;
371 
372         for(uint256 i = 0; i < stakePoolArray.length; i++ ){
373             stakePoolDetails = stakePoolArray[i];
374             poolMultiplier = stakePoolDetails.multiplier;
375             totalPoolsAPY = rewardTokenBalance / totalStakedBalance;
376             stakePoolAPY = totalPoolsAPY * poolMultiplier;
377             allPoolAPY[i] = stakePoolAPY;
378         }
379 
380         return (allPoolAPY);
381     }
382 
383     function getDPR(uint256 _stakePoolId) public view returns (uint256){
384         uint256 apy;
385         uint256 dpr;
386 
387         if(dynamicApy == false){
388             apy = getFixedAPY(_stakePoolId);
389             dpr = (apy * magnitude) / 360;
390         }else{
391             apy = getDynamicAPY(_stakePoolId);
392             dpr = (apy * magnitude) / 360;
393         }
394 
395         return dpr;
396     }
397 
398     function getStakePoolDetailsById(uint256 _stakePoolId) public view returns(stakePool memory){
399         return (stakePoolArray[_stakePoolId]);
400     }
401 
402     function getElapsedTime(uint256 _stakeId) public view returns(uint256){
403         userStake memory userStakeDetails = userStakesById[_stakeId];
404         if(userStakeDetails.lastClaimedTime == 0){
405             uint256 lapsedDays = ((block.timestamp - userStakeDetails.createdTime)/3600)/24; //3600 seconds per hour so: lapsed days = lapsed time * (3600seconds /24hrs)
406             return lapsedDays;
407         }else {
408             uint256 lapsedDays = ((block.timestamp - userStakeDetails.lastClaimedTime)/3600)/24; //3600 seconds per hour so: lapsed days = lapsed time * (3600seconds /24hrs)
409             return lapsedDays;
410         }
411     }
412 
413     function stake(uint256 _stakePoolId, uint256 _amount) nonReentrant unpaused external returns (bool) {
414         stakePool memory stakePoolDetails = stakePoolsById[_stakePoolId];
415 
416         require(stakeToken.allowance(msg.sender, address(this)) >= _amount,'Tokens not approved for transfer');
417         
418         bool success = stakeToken.transferFrom(msg.sender, address(this), _amount);
419         require(success, "Token Transfer failed.");
420         
421         userStake memory userStakeDetails;
422 
423         uint256 userStakeid = stakeIndex++;
424         userStakeDetails.id = userStakeid;
425         userStakeDetails.stakePoolId = _stakePoolId;
426         userStakeDetails.stakeBalance = _amount;
427         userStakeDetails.status = 1;
428         userStakeDetails.owner = msg.sender;
429         userStakeDetails.createdTime = block.timestamp;
430         userStakeDetails.unlockTime = block.timestamp + (stakePoolDetails.duration * 86400) ;
431         userStakeDetails.lockDuration = stakePoolDetails.duration;
432         userStakeDetails.lastClaimedTime = block.timestamp;
433         
434         userStakesById[userStakeid] = userStakeDetails;
435         
436         uint256[] storage userStakeIdsArray = userStakeIds[msg.sender];
437         
438         userStakeIdsArray.push(userStakeid);
439         userStakeArray.push(userStakeDetails);
440         
441         userStake[] storage userStakeList = userStakeLists[msg.sender];
442         userStakeList.push(userStakeDetails);
443 
444         user memory userDetails = users[msg.sender];
445 
446         if(userDetails.id == 0){
447             userDetails.id = block.timestamp;
448             userDetails.createdTime = block.timestamp;
449         }
450 
451         userDetails.totalStakedBalance = userDetails.totalStakedBalance + _amount;
452 
453         users[msg.sender] = userDetails;
454 
455         stakePoolDetails.stakedTokens = stakePoolDetails.stakedTokens + _amount;
456         
457         stakePoolsById[_stakePoolId] = stakePoolDetails;
458 
459         totalStakedBalance = totalStakedBalance + _amount;
460 
461         return true;
462     }
463 
464     function unstake(uint256 _stakeId) nonReentrant unpaused external returns (bool){
465         userStake memory userStakeDetails = userStakesById[_stakeId];
466         uint256 stakePoolId = userStakeDetails.stakePoolId;
467         uint256 stakeBalance = userStakeDetails.stakeBalance;
468         
469         require(userStakeDetails.owner == msg.sender,"You don't own this stake");
470         
471         stakePool memory stakePoolDetails = stakePoolsById[stakePoolId];
472 
473         if(isStakeLocked(_stakeId)){
474             stakeBalance = stakeBalance - (stakeBalance * stakePoolDetails.unstakePenalty)/(100);
475         }
476 
477         uint256 unstakableBalance = stakeBalance;
478         userStakeDetails.stakeBalance = 0;
479         userStakeDetails.status = 0;
480 
481         userStakesById[_stakeId] = userStakeDetails;
482 
483         stakePoolDetails.stakedTokens = stakePoolDetails.stakedTokens - stakeBalance;
484 
485         userStakesById[_stakeId] = userStakeDetails;
486 
487         user memory userDetails = users[msg.sender];
488         userDetails.totalStakedBalance =   userDetails.totalStakedBalance - unstakableBalance;
489 
490         users[msg.sender] = userDetails;
491         stakePoolsById[stakePoolId] = stakePoolDetails;
492 
493         totalStakedBalance =  totalStakedBalance - unstakableBalance;
494 
495         require(stakeToken.balanceOf(address(this)) >= unstakableBalance, "Insufficient contract stake token balance");
496         
497         bool success = stakeToken.transfer(msg.sender, unstakableBalance);
498         require(success, "Token Transfer failed.");
499 
500         return true;
501     }
502 
503     function isStakeLocked(uint256 _stakeId) public view returns (bool) {
504         userStake memory userStakeDetails = userStakesById[_stakeId];
505         if(block.timestamp < userStakeDetails.unlockTime){
506             return true;
507         }else{
508             return false;
509         }
510     }
511 
512     function getStakePoolIdByStakeId(uint256 _stakeId) public view returns(uint256){
513         userStake memory userStakeDetails = userStakesById[_stakeId];
514         return userStakeDetails.stakePoolId;
515     }
516 
517     function getUserStakeIds() public view returns(uint256[] memory){
518         return (userStakeIds[msg.sender]);
519     }
520 
521     function getUserStakeIdsByAddress(address _userAddress) public view returns(uint256[] memory){
522          return(userStakeIds[_userAddress]);
523     }
524 
525     function getUserStakeDetailsByStakeId(uint256 _stakeId) public view returns(userStake memory, stakePool memory){ 
526         userStake memory userStakeDetails = userStakeArray[_stakeId];
527         uint256 userStakePoolId = userStakeDetails.stakePoolId;
528         return (userStakeArray[_stakeId], stakePoolArray[userStakePoolId]);
529     }
530 
531     function getUserAllStakeDetails() public view returns(userStake[] memory){
532         return (userStakeLists[msg.sender]);
533     }
534 
535     function getUserAllStakeDetailsByAddress(address _userAddress) public view returns(userStake[] memory){
536         return (userStakeLists[_userAddress]);
537     }
538 
539     function getUserStakeOwner(uint256 _stakeId) public view returns (address){
540         userStake memory userStakeDetails = userStakesById[_stakeId];
541         return userStakeDetails.owner;
542     }
543 
544     function getUserStakeBalance(uint256 _stakeId) public view returns (uint256){
545         userStake memory userStakeDetails = userStakesById[_stakeId];
546         return userStakeDetails.stakeBalance;
547     }
548     
549     function getUnclaimedRewards(uint256 _stakeId) public view returns (uint256){
550         userStake memory userStakeDetails = userStakeArray[_stakeId];
551         uint256 stakePoolId = userStakeDetails.stakePoolId;
552 
553         stakePool memory stakePoolDetails = stakePoolsById[stakePoolId];
554         uint256 stakeApr = getDPR(stakePoolDetails.id);
555 
556         uint applicableRewards = (userStakeDetails.stakeBalance * stakeApr)/(magnitude * 100); //divided by 10000 to handle decimal percentages like 0.1%
557         uint unclaimedRewards = (applicableRewards * getElapsedTime(_stakeId));
558 
559         return unclaimedRewards; 
560     }
561 
562     function getTotalUnclaimedRewards() public view returns (uint256){
563         uint256[] memory stakeIds = getUserStakeIds();
564         uint256 totalUnclaimedRewards;
565         for(uint256 i = 0; i < stakeIds.length; i++) {
566             totalUnclaimedRewards += getUnclaimedRewards(stakeIds[i]);
567         }
568         return totalUnclaimedRewards;
569     }
570 
571     function getTotalUnclaimedRewardsByAddress(address _userAddress) public view returns (uint256){
572         uint256[] memory stakeIds = getUserStakeIdsByAddress(_userAddress);
573         uint256 totalUnclaimedRewards;
574         for(uint256 i = 0; i < stakeIds.length; i++) {
575             totalUnclaimedRewards += getUnclaimedRewards(stakeIds[i]);
576         }
577         return totalUnclaimedRewards;
578     }
579 
580     
581     function getAllPoolDetails() public view returns(stakePool[] memory){
582         return (stakePoolArray);
583     }
584 
585     function claimRewards(uint256 _stakeId) nonReentrant unpaused external returns (bool){
586         address userStakeOwner = getUserStakeOwner(_stakeId);
587         require(userStakeOwner == msg.sender,"You don't own this stake");
588 
589         userStake memory userStakeDetails = userStakesById[_stakeId];
590 
591         require(((block.timestamp - userStakeDetails.lastClaimedTime)/3600) > 24,"You already claimed rewards today");
592         
593         uint256 unclaimedRewards = getUnclaimedRewards(_stakeId);
594         
595         userStakeDetails.totalClaimedRewards = userStakeDetails.totalClaimedRewards + unclaimedRewards;
596         userStakeDetails.lastClaimedTime = block.timestamp;
597         userStakesById[_stakeId] = userStakeDetails;
598 
599         totalClaimedBalance += unclaimedRewards;
600 
601         user memory userDetails = users[msg.sender];
602         userDetails.totalClaimedRewards  +=  unclaimedRewards;
603 
604         users[msg.sender] = userDetails;
605 
606         require(rewardToken.balanceOf(address(this)) >= unclaimedRewards, "Insufficient contract reward token balance");
607 
608         bool success = rewardToken.transfer(msg.sender, unclaimedRewards);
609         require(success, "Token Transfer failed.");
610 
611         return true;
612     }
613 
614     function getUserDetails() external view returns (user memory){
615         user memory userDetails = users[msg.sender];
616         return(userDetails);
617     }
618 
619     function getUserDetailsByAddress(address _userAddress) external view returns (user memory){
620         user memory userDetails = users[_userAddress];
621         return(userDetails);
622     }
623 
624     function pauseStake() public onlyOwner(){
625         isPaused = true;
626     }
627 
628     function unpauseStake() public onlyOwner(){
629         isPaused = false;
630     }
631 
632     function emergencyUnstake() public paused {
633         userStake[] memory userAllStakes = userStakeLists[msg.sender];
634         
635         for (uint256 i = 0; i < userAllStakes.length; i++){
636             uint256 _stakeId = userAllStakes[i].id;
637             userStake memory userStakeDetails = userStakesById[_stakeId];
638             uint256 stakePoolId = userStakeDetails.stakePoolId;
639             uint256 stakeBalance = userStakeDetails.stakeBalance;
640             
641             require(userStakeDetails.owner == msg.sender,"You don't own this stake");
642             
643             stakePool memory stakePoolDetails = stakePoolsById[stakePoolId];
644 
645             uint256 unstakableBalance = stakeBalance;
646             userStakeDetails.stakeBalance = 0;
647             userStakeDetails.status = 0;
648 
649             userStakesById[_stakeId] = userStakeDetails;
650 
651             stakePoolDetails.stakedTokens = stakePoolDetails.stakedTokens - stakeBalance;
652 
653             userStakesById[_stakeId] = userStakeDetails;
654 
655             user memory userDetails = users[msg.sender];
656             userDetails.totalStakedBalance =   userDetails.totalStakedBalance - unstakableBalance;
657 
658             users[msg.sender] = userDetails;
659             stakePoolsById[stakePoolId] = stakePoolDetails;
660 
661             totalStakedBalance =  totalStakedBalance - unstakableBalance;
662 
663             require(stakeToken.balanceOf(address(this)) >= unstakableBalance, "Insufficient contract stake token balance");
664             
665             bool success = stakeToken.transfer(msg.sender, unstakableBalance);
666             require(success, "Token Transfer failed.");
667         }
668 
669     }
670 
671     function withdrawContractETH() public onlyOwner paused returns(bool){
672         (bool success, ) = msg.sender.call{value: address(this).balance}("");
673         require(success, "Transfer failed.");
674 
675         return true;
676     }
677 
678     function withdrawContractRewardTokens() public onlyOwner paused returns(bool){
679         //IERC20 token = IERC20(baseTokenAddress);
680 
681         bool success = rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
682         require(success, "Token Transfer failed.");
683 
684         return true;
685     }
686 
687     receive() external payable {
688     }
689 }