1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.6.0;
3 
4 // ----------------------------------------------------------------------------
5 // Owned contract
6 // ----------------------------------------------------------------------------
7 contract Owned {
8     address payable public owner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address payable _newOwner) public onlyOwner {
22         owner = _newOwner;
23         emit OwnershipTransferred(msg.sender, _newOwner);
24     }
25 }
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 // ----------------------------------------------------------------------------
31 abstract contract ERC20Interface {
32     function totalSupply() public virtual view returns (uint);
33     function balanceOf(address tokenOwner) public virtual view returns (uint256 balance);
34     function allowance(address tokenOwner, address spender) public virtual view returns (uint256 remaining);
35     function transfer(address to, uint256 tokens) public virtual returns (bool success);
36     function approve(address spender, uint256 tokens) public virtual returns (bool success);
37     function transferFrom(address from, address to, uint256 tokens) public virtual returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint256 tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  *
47 */
48  
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76   
77   function ceil(uint a, uint m) internal pure returns (uint r) {
78     return (a + m - 1) / m * m;
79   }
80 }
81 
82 interface ISYFP{
83    function transferFrom(address from, address to, uint256 tokens) external returns (bool success); 
84    function transfer(address to, uint256 tokens) external returns (bool success);
85    function mint(address to, uint256 _mint_amount) external;
86 }
87 
88 contract SYFP_STAKE_FARM is Owned{
89     
90     using SafeMath for uint256;
91     
92     uint256 public yieldCollectionFee = 0.05 ether;
93     uint256 public stakingPeriod = 2 weeks;
94     uint256 public stakeClaimFee = 0.01 ether;
95     uint256 public totalYield;
96     uint256 public totalRewards;
97     
98     address public SYFP = 0xC11396e14990ebE98a09F8639a082C03Eb9dB55a;
99     
100     struct Tokens{
101         bool exists;
102         uint256 rate;
103         uint256 stakedTokens;
104     }
105     
106     mapping(address => Tokens) public tokens;
107     address[] TokensAddresses;
108     
109     struct DepositedToken{
110         uint256 activeDeposit;
111         uint256 totalDeposits;
112         uint256 startTime;
113         uint256 pendingGains;
114         uint256 lastClaimedDate;
115         uint256 totalGained;
116         uint    rate;
117         uint    period;
118     }
119     
120     mapping(address => mapping(address => DepositedToken)) users;
121     
122     event TokenAdded(address indexed tokenAddress, uint256 indexed APY);
123     event TokenRemoved(address indexed tokenAddress, uint256 indexed APY);
124     event FarmingRateChanged(address indexed tokenAddress, uint256 indexed newAPY);
125     event YieldCollectionFeeChanged(uint256 indexed yieldCollectionFee);
126     event FarmingStarted(address indexed _tokenAddress, uint256 indexed _amount);
127     event YieldCollected(address indexed _tokenAddress, uint256 indexed _yield);
128     event AddedToExistingFarm(address indexed _tokenAddress, uint256 indexed tokens);
129     
130     event Staked(address indexed staker, uint256 indexed tokens);
131     event AddedToExistingStake(address indexed staker, uint256 indexed tokens);
132     event StakingRateChanged(uint256 indexed newAPY);
133     event TokensClaimed(address indexed claimer, uint256 indexed stakedTokens);
134     event RewardClaimed(address indexed claimer, uint256 indexed reward);
135     
136     constructor() public {
137         owner = 0xf64df26Fb32Ce9142393C31f01BB1689Ff7b29f5;
138         // add syfp token to ecosystem
139         _addToken(0xC11396e14990ebE98a09F8639a082C03Eb9dB55a, 4000000); //SYFP
140         _addToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, 14200); // USDT
141         _addToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 14200); // USDC
142         _addToken(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, 5200000); // WETH
143         _addToken(0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e, 297300000); // YFI
144         _addToken(0x45f24BaEef268BB6d63AEe5129015d69702BCDfa, 230000); // YFV
145         _addToken(0x96d62cdCD1cc49cb6eE99c867CB8812bea86B9FA, 300000); // yfp
146         
147     }
148     
149     //#########################################################################################################################################################//
150     //####################################################FARMING EXTERNAL FUNCTIONS###########################################################################//
151     //#########################################################################################################################################################// 
152     
153     // ------------------------------------------------------------------------
154     // Add assets to farm
155     // @param _tokenAddress address of the token asset
156     // @param _amount amount of tokens to deposit
157     // ------------------------------------------------------------------------
158     function Farm(address _tokenAddress, uint256 _amount) external{
159         require(_tokenAddress != SYFP, "Use staking instead"); 
160         
161         // add to farm
162         _newDeposit(_tokenAddress, _amount);
163         
164         // transfer tokens from user to the contract balance
165         require(ISYFP(_tokenAddress).transferFrom(msg.sender, address(this), _amount));
166         
167         emit FarmingStarted(_tokenAddress, _amount);
168     }
169     
170     // ------------------------------------------------------------------------
171     // Add more deposits to already running farm
172     // @param _tokenAddress address of the token asset
173     // @param _amount amount of tokens to deposit
174     // ------------------------------------------------------------------------
175     function AddToFarm(address _tokenAddress, uint256 _amount) external{
176         require(_tokenAddress != SYFP, "use staking instead");
177         _addToExisting(_tokenAddress, _amount);
178         
179         // move the tokens from the caller to the contract address
180         require(ISYFP(_tokenAddress).transferFrom(msg.sender,address(this), _amount));
181         
182         emit AddedToExistingFarm(_tokenAddress, _amount);
183     }
184     
185     // ------------------------------------------------------------------------
186     // Withdraw accumulated yield
187     // @param _tokenAddress address of the token asset
188     // @required must pay yield claim fee
189     // ------------------------------------------------------------------------
190     function Yield(address _tokenAddress) public payable {
191         require(msg.value >= yieldCollectionFee, "should pay exact claim fee");
192         require(PendingYield(_tokenAddress, msg.sender) > 0, "No pending yield");
193         require(tokens[_tokenAddress].exists, "Token doesn't exist");
194         require(_tokenAddress != SYFP, "use staking instead");
195     
196         uint256 _pendingYield = PendingYield(_tokenAddress, msg.sender);
197         
198         // Global stats update
199         totalYield = totalYield.add(_pendingYield);
200         
201         // update the record
202         users[msg.sender][_tokenAddress].totalGained = users[msg.sender][_tokenAddress].totalGained.add(_pendingYield);
203         users[msg.sender][_tokenAddress].lastClaimedDate = now;
204         users[msg.sender][_tokenAddress].pendingGains = 0;
205         
206         // transfer fee to the owner
207         owner.transfer(msg.value);
208         
209         // mint more tokens inside token contract equivalent to _pendingYield
210         ISYFP(SYFP).mint(msg.sender, _pendingYield);
211         
212         emit YieldCollected(_tokenAddress, _pendingYield);
213     }
214     
215     // ------------------------------------------------------------------------
216     // Withdraw any amount of tokens, the contract will update the farming 
217     // @param _tokenAddress address of the token asset
218     // @param _amount amount of tokens to deposit
219     // ------------------------------------------------------------------------
220     function WithdrawFarmedTokens(address _tokenAddress, uint256 _amount) public {
221         require(users[msg.sender][_tokenAddress].activeDeposit >= _amount, "insufficient amount in farming");
222         require(_tokenAddress != SYFP, "use withdraw of staking instead");
223         
224         // update farming stats
225             // check if we have any pending yield, add it to previousYield var
226             users[msg.sender][_tokenAddress].pendingGains = PendingYield(_tokenAddress, msg.sender);
227             
228             tokens[_tokenAddress].stakedTokens = tokens[_tokenAddress].stakedTokens.sub(_amount);
229             
230             // update amount 
231             users[msg.sender][_tokenAddress].activeDeposit = users[msg.sender][_tokenAddress].activeDeposit.sub(_amount);
232             // update farming start time -- new farming will begin from this time onwards
233             users[msg.sender][_tokenAddress].startTime = now;
234             // reset last claimed figure as well -- new farming will begin from this time onwards
235             users[msg.sender][_tokenAddress].lastClaimedDate = now;
236         
237         // withdraw the tokens and move from contract to the caller
238         require(ISYFP(_tokenAddress).transfer(msg.sender, _amount));
239         
240         emit TokensClaimed(msg.sender, _amount);
241     }
242     
243     function yieldWithdraw(address _tokenAddress) external {
244         Yield(_tokenAddress);
245         WithdrawFarmedTokens(_tokenAddress, users[msg.sender][_tokenAddress].activeDeposit);
246         
247     }
248     
249     //#########################################################################################################################################################//
250     //####################################################STAKING EXTERNAL FUNCTIONS###########################################################################//
251     //#########################################################################################################################################################//    
252     
253     // ------------------------------------------------------------------------
254     // Start staking
255     // @param _tokenAddress address of the token asset
256     // @param _amount amount of tokens to deposit
257     // ------------------------------------------------------------------------
258     function Stake(uint256 _amount) external {
259         // add new stake
260         _newDeposit(SYFP, _amount);
261         
262         // transfer tokens from user to the contract balance
263         require(ISYFP(SYFP).transferFrom(msg.sender, address(this), _amount));
264         
265         emit Staked(msg.sender, _amount);
266     }
267     
268     // ------------------------------------------------------------------------
269     // Add more deposits to already running farm
270     // @param _tokenAddress address of the token asset
271     // @param _amount amount of tokens to deposit
272     // ------------------------------------------------------------------------
273     function AddToStake(uint256 _amount) external {
274         require(now - users[msg.sender][SYFP].startTime < users[msg.sender][SYFP].period, "current staking expired");
275         _addToExisting(SYFP, _amount);
276 
277         // move the tokens from the caller to the contract address
278         require(ISYFP(SYFP).transferFrom(msg.sender,address(this), _amount));
279         
280         emit AddedToExistingStake(msg.sender, _amount);
281     }
282     
283     // ------------------------------------------------------------------------
284     // Claim reward and staked tokens
285     // @required user must be a staker
286     // @required must be claimable
287     // ------------------------------------------------------------------------
288     function ClaimStakedTokens() public {
289         require(users[msg.sender][SYFP].activeDeposit > 0, "no running stake");
290         require(users[msg.sender][SYFP].startTime.add(users[msg.sender][SYFP].period) < now, "not claimable before staking period");
291         
292         uint256 _currentDeposit = users[msg.sender][SYFP].activeDeposit;
293         
294         // check if we have any pending reward, add it to pendingGains var
295         users[msg.sender][SYFP].pendingGains = PendingReward(msg.sender);
296         
297         tokens[SYFP].stakedTokens = tokens[SYFP].stakedTokens.sub(users[msg.sender][SYFP].activeDeposit);
298         
299         // update amount 
300         users[msg.sender][SYFP].activeDeposit = 0;
301         
302         // transfer staked tokens
303         require(ISYFP(SYFP).transfer(msg.sender, _currentDeposit));
304         emit TokensClaimed(msg.sender, _currentDeposit);
305         
306         
307     }
308     
309     function ClaimUnStake() external {
310         ClaimReward();
311         ClaimStakedTokens();
312     }
313     
314     // ------------------------------------------------------------------------
315     // Claim reward and staked tokens
316     // @required user must be a staker
317     // @required must be claimable
318     // ------------------------------------------------------------------------
319     function ClaimReward() public payable {
320         require(msg.value >= stakeClaimFee, "should pay exact claim fee");
321         require(PendingReward(msg.sender) > 0, "nothing pending to claim");
322     
323         uint256 _pendingReward = PendingReward(msg.sender);
324         
325         // add claimed reward to global stats
326         totalRewards = totalRewards.add(_pendingReward);
327         // add the reward to total claimed rewards
328         users[msg.sender][SYFP].totalGained = users[msg.sender][SYFP].totalGained.add(_pendingReward);
329         // update lastClaim amount
330         users[msg.sender][SYFP].lastClaimedDate = now;
331         // reset previous rewards
332         users[msg.sender][SYFP].pendingGains = 0;
333         
334         // transfer the claim fee to the owner
335         owner.transfer(msg.value);
336         
337         // mint more tokens inside token contract
338         ISYFP(SYFP).mint(msg.sender, _pendingReward);
339          
340         emit RewardClaimed(msg.sender, _pendingReward);
341     }
342     
343     //#########################################################################################################################################################//
344     //##########################################################FARMING QUERIES################################################################################//
345     //#########################################################################################################################################################//
346     
347     // ------------------------------------------------------------------------
348     // Query to get the pending yield
349     // @param _tokenAddress address of the token asset
350     // ------------------------------------------------------------------------
351     function PendingYield(address _tokenAddress, address _caller) public view returns(uint256 _pendingRewardWeis){
352         uint256 _totalFarmingTime = now.sub(users[_caller][_tokenAddress].lastClaimedDate);
353         
354         uint256 _reward_token_second = ((tokens[_tokenAddress].rate).mul(10 ** 21)).div(365 days); // added extra 10^21
355         
356         uint256 yield = ((users[_caller][_tokenAddress].activeDeposit).mul(_totalFarmingTime.mul(_reward_token_second))).div(10 ** 27); // remove extra 10^21 // 10^2 are for 100 (%)
357         
358         return yield.add(users[_caller][_tokenAddress].pendingGains);
359     }
360     
361     // ------------------------------------------------------------------------
362     // Query to get the active farm of the user
363     // @param farming asset/ token address
364     // ------------------------------------------------------------------------
365     function ActiveFarmDeposit(address _tokenAddress, address _user) external view returns(uint256 _activeDeposit){
366         return users[_user][_tokenAddress].activeDeposit;
367     }
368     
369     // ------------------------------------------------------------------------
370     // Query to get the total farming of the user
371     // @param farming asset/ token address
372     // ------------------------------------------------------------------------
373     function YourTotalFarmingTillToday(address _tokenAddress, address _user) external view returns(uint256 _totalFarming){
374         return users[_user][_tokenAddress].totalDeposits;
375     }
376     
377     // ------------------------------------------------------------------------
378     // Query to get the time of last farming of user
379     // ------------------------------------------------------------------------
380     function LastFarmedOn(address _tokenAddress, address _user) external view returns(uint256 _unixLastFarmedTime){
381         return users[_user][_tokenAddress].startTime;
382     }
383     
384     // ------------------------------------------------------------------------
385     // Query to get total earned rewards from particular farming
386     // @param farming asset/ token address
387     // ------------------------------------------------------------------------
388     function TotalFarmingRewards(address _tokenAddress, address _user) external view returns(uint256 _totalEarned){
389         return users[_user][_tokenAddress].totalGained;
390     }
391     
392     //#########################################################################################################################################################//
393     //####################################################FARMING ONLY OWNER FUNCTIONS#########################################################################//
394     //#########################################################################################################################################################//
395     
396     // ------------------------------------------------------------------------
397     // Add supported tokens
398     // @param _tokenAddress address of the token asset
399     // @param _farmingRate rate applied for farming yield to produce
400     // @required only owner or governance contract
401     // ------------------------------------------------------------------------    
402     function AddToken(address _tokenAddress, uint256 _rate) public onlyOwner {
403         _addToken(_tokenAddress, _rate);
404     }
405     
406     // ------------------------------------------------------------------------
407     // Remove tokens if no longer supported
408     // @param _tokenAddress address of the token asset
409     // @required only owner or governance contract
410     // ------------------------------------------------------------------------  
411     function RemoveToken(address _tokenAddress) public onlyOwner {
412         
413         require(tokens[_tokenAddress].exists, "token doesn't exist");
414         
415         tokens[_tokenAddress].exists = false;
416         
417         emit TokenRemoved(_tokenAddress, tokens[_tokenAddress].rate);
418     }
419     
420     // ------------------------------------------------------------------------
421     // Change farming rate of the supported token
422     // @param _tokenAddress address of the token asset
423     // @param _newFarmingRate new rate applied for farming yield to produce
424     // @required only owner or governance contract
425     // ------------------------------------------------------------------------  
426     function ChangeFarmingRate(address _tokenAddress, uint256 _newFarmingRate) public onlyOwner{
427         
428         require(tokens[_tokenAddress].exists, "token doesn't exist");
429         
430         tokens[_tokenAddress].rate = _newFarmingRate;
431         
432         emit FarmingRateChanged(_tokenAddress, _newFarmingRate);
433     }
434 
435     // ------------------------------------------------------------------------
436     // Change Yield collection fee
437     // @param _fee fee to claim the yield
438     // @required only owner or governance contract
439     // ------------------------------------------------------------------------     
440     function SetYieldCollectionFee(uint256 _fee) public onlyOwner{
441         yieldCollectionFee = _fee;
442         emit YieldCollectionFeeChanged(_fee);
443     }
444     
445     //#########################################################################################################################################################//
446     //####################################################STAKING QUERIES######################################################################################//
447     //#########################################################################################################################################################//
448     
449     // ------------------------------------------------------------------------
450     // Query to get the pending reward
451     // ------------------------------------------------------------------------
452     function PendingReward(address _caller) public view returns(uint256 _pendingReward){
453         uint256 _totalStakedTime = 0;
454         uint256 expiryDate = (users[_caller][SYFP].period).add(users[_caller][SYFP].startTime);
455         
456         if(now < expiryDate)
457             _totalStakedTime = now.sub(users[_caller][SYFP].lastClaimedDate);
458         else{
459             if(users[_caller][SYFP].lastClaimedDate >= expiryDate) // if claimed after expirydate already
460                 _totalStakedTime = 0;
461             else
462                 _totalStakedTime = expiryDate.sub(users[_caller][SYFP].lastClaimedDate);
463         }
464             
465         uint256 _reward_token_second = ((users[_caller][SYFP].rate).mul(10 ** 21)); // added extra 10^21
466         uint256 reward =  ((users[_caller][SYFP].activeDeposit).mul(_totalStakedTime.mul(_reward_token_second))).div(10 ** 27); // remove extra 10^21 // the two extra 10^2 is for 100 (%) // another two extra 10^4 is for decimals to be allowed
467         reward = reward.div(365 days);
468         return (reward.add(users[_caller][SYFP].pendingGains));
469     }
470     
471     // ------------------------------------------------------------------------
472     // Query to get the active stake of the user
473     // ------------------------------------------------------------------------
474     function YourActiveStake(address _user) external view returns(uint256 _activeStake){
475         return users[_user][SYFP].activeDeposit;
476     }
477     
478     // ------------------------------------------------------------------------
479     // Query to get the total stakes of the user
480     // ------------------------------------------------------------------------
481     function YourTotalStakesTillToday(address _user) external view returns(uint256 _totalStakes){
482         return users[_user][SYFP].totalDeposits;
483     }
484     
485     // ------------------------------------------------------------------------
486     // Query to get the time of last stake of user
487     // ------------------------------------------------------------------------
488     function LastStakedOn(address _user) public view returns(uint256 _unixLastStakedTime){
489         return users[_user][SYFP].startTime;
490     }
491     
492     // ------------------------------------------------------------------------
493     // Query to get total earned rewards from stake
494     // ------------------------------------------------------------------------
495     function TotalStakeRewardsClaimedTillToday(address _user) external view returns(uint256 _totalEarned){
496         return users[_user][SYFP].totalGained;
497     }
498     
499     // ------------------------------------------------------------------------
500     // Query to get the staking rate
501     // ------------------------------------------------------------------------
502     function LatestStakingRate() external view returns(uint256 APY){
503         return tokens[SYFP].rate;
504     }
505     
506     // ------------------------------------------------------------------------
507     // Query to get the staking rate you staked at
508     // ------------------------------------------------------------------------
509     function YourStakingRate(address _user) external view returns(uint256 _stakingRate){
510         return users[_user][SYFP].rate;
511     }
512     
513     // ------------------------------------------------------------------------
514     // Query to get the staking period you staked at
515     // ------------------------------------------------------------------------
516     function YourStakingPeriod(address _user) external view returns(uint256 _stakingPeriod){
517         return users[_user][SYFP].period;
518     }
519     
520     // ------------------------------------------------------------------------
521     // Query to get the staking time left
522     // ------------------------------------------------------------------------
523     function StakingTimeLeft(address _user) external view returns(uint256 _secsLeft){
524         uint256 left = 0; 
525         uint256 expiryDate = (users[_user][SYFP].period).add(LastStakedOn(_user));
526         
527         if(now < expiryDate)
528             left = expiryDate.sub(now);
529             
530         return left;
531     }
532     
533     //#########################################################################################################################################################//
534     //####################################################STAKING ONLY OWNER FUNCTION##########################################################################//
535     //#########################################################################################################################################################//
536     
537     // ------------------------------------------------------------------------
538     // Change staking rate
539     // @param _newStakingRate new rate applied for staking
540     // @required only owner or governance contract
541     // ------------------------------------------------------------------------  
542     function ChangeStakingRate(uint256 _newStakingRate) public onlyOwner{
543         
544         tokens[SYFP].rate = _newStakingRate;
545         
546         emit StakingRateChanged(_newStakingRate);
547     }
548     
549     // ------------------------------------------------------------------------
550     // Change the staking period
551     // @param _seconds number of seconds to stake (n days = n*24*60*60)
552     // @required only callable by owner or governance contract
553     // ------------------------------------------------------------------------
554     function SetStakingPeriod(uint256 _seconds) public onlyOwner{
555        stakingPeriod = _seconds;
556     }
557     
558     // ------------------------------------------------------------------------
559     // Change the staking claim fee
560     // @param _fee claim fee in weis
561     // @required only callable by owner or governance contract
562     // ------------------------------------------------------------------------
563     function SetClaimFee(uint256 _fee) public onlyOwner{
564        stakeClaimFee = _fee;
565     }
566     
567     //#########################################################################################################################################################//
568     //################################################################COMMON UTILITIES#########################################################################//
569     //#########################################################################################################################################################//    
570     
571     // ------------------------------------------------------------------------
572     // Internal function to add new deposit
573     // ------------------------------------------------------------------------        
574     function _newDeposit(address _tokenAddress, uint256 _amount) internal{
575         require(users[msg.sender][_tokenAddress].activeDeposit ==  0, "Already running");
576         require(tokens[_tokenAddress].exists, "Token doesn't exist");
577         
578         // add that token into the contract balance
579         // check if we have any pending reward/yield, add it to pendingGains variable
580         if(_tokenAddress == SYFP){
581             users[msg.sender][_tokenAddress].pendingGains = PendingReward(msg.sender);
582             users[msg.sender][_tokenAddress].period = stakingPeriod;
583             users[msg.sender][_tokenAddress].rate = tokens[_tokenAddress].rate; // rate for stakers will be fixed at time of staking
584         }
585         else
586             users[msg.sender][_tokenAddress].pendingGains = PendingYield(_tokenAddress, msg.sender);
587             
588         users[msg.sender][_tokenAddress].activeDeposit = _amount;
589         users[msg.sender][_tokenAddress].totalDeposits = users[msg.sender][_tokenAddress].totalDeposits.add(_amount);
590         users[msg.sender][_tokenAddress].startTime = now;
591         users[msg.sender][_tokenAddress].lastClaimedDate = now;
592         tokens[_tokenAddress].stakedTokens = tokens[_tokenAddress].stakedTokens.add(_amount);
593     }
594 
595     // ------------------------------------------------------------------------
596     // Internal function to add to existing deposit
597     // ------------------------------------------------------------------------        
598     function _addToExisting(address _tokenAddress, uint256 _amount) internal{
599         require(tokens[_tokenAddress].exists, "Token doesn't exist");
600         // require(users[msg.sender][_tokenAddress].running, "no running farming/stake");
601         require(users[msg.sender][_tokenAddress].activeDeposit > 0, "no running farming/stake");
602         // update farming stats
603             // check if we have any pending reward/yield, add it to pendingGains variable
604             if(_tokenAddress == SYFP){
605                 users[msg.sender][_tokenAddress].pendingGains = PendingReward(msg.sender);
606                 users[msg.sender][_tokenAddress].period = stakingPeriod;
607                 users[msg.sender][_tokenAddress].rate = tokens[_tokenAddress].rate; // rate of only staking will be updated when more is added to stake
608             }
609             else
610                 users[msg.sender][_tokenAddress].pendingGains = PendingYield(_tokenAddress, msg.sender);
611             // update current deposited amount 
612             users[msg.sender][_tokenAddress].activeDeposit = users[msg.sender][_tokenAddress].activeDeposit.add(_amount);
613             // update total deposits till today
614             users[msg.sender][_tokenAddress].totalDeposits = users[msg.sender][_tokenAddress].totalDeposits.add(_amount);
615             // update new deposit start time -- new stake/farming will begin from this time onwards
616             users[msg.sender][_tokenAddress].startTime = now;
617             // reset last claimed figure as well -- new stake/farming will begin from this time onwards
618             users[msg.sender][_tokenAddress].lastClaimedDate = now;
619             tokens[_tokenAddress].stakedTokens = tokens[_tokenAddress].stakedTokens.add(_amount);
620             
621             
622     }
623 
624     // ------------------------------------------------------------------------
625     // Internal function to add token
626     // ------------------------------------------------------------------------     
627     function _addToken(address _tokenAddress, uint256 _rate) internal{
628         require(!tokens[_tokenAddress].exists, "token already exists");
629         
630         tokens[_tokenAddress] = Tokens({
631             exists: true,
632             rate: _rate,
633             stakedTokens: 0
634         });
635         
636         TokensAddresses.push(_tokenAddress);
637         emit TokenAdded(_tokenAddress, _rate);
638     }
639 }