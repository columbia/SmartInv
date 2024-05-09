1 // File: contracts/module/safeMath.sol
2 
3 // SPDX-License-Identifier: BSD-3-Clause
4 pragma solidity 0.6.12;
5 
6 /**
7  * @title BiFi's safe-math Contract
8  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
9  */
10 contract safeMathModule {
11     uint256 constant one = 1 ether;
12 
13     function expDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14         return safeDiv( safeMul(a, one), b);
15     }
16     function expMul(uint256 a, uint256 b) internal pure returns (uint256) {
17         return safeDiv( safeMul(a, b), one);
18     }
19     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addtion overflow");
22         return c;
23     }
24     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(a >= b, "SafeMath: subtraction overflow");
26         return a - b;
27     }
28     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if(a == 0) { return 0;}
30         uint256 c = a * b;
31         require( (c/a) == b, "SafeMath: multiplication overflow");
32         return c;
33     }
34     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b > 0, "SafeMath: division by zero");
36         return (a/b);
37     }
38 }
39 
40 // File: contracts/ERC20.sol
41 
42 pragma solidity 0.6.12;
43 
44 /**
45  * @title BiFi's ERC20 Mockup Contract
46  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
47  */
48 contract ERC20 {
49     string symbol;
50     string name;
51     uint8 decimals = 18;
52     uint256 public totalSupply = 1000 * 1e9 * 1e18; // token amount: 1000 Bilions
53 
54     // Owner of this contract
55     address public owner;
56 
57     // Balances for each account
58     mapping(address => uint256) balances;
59 
60     // Owner of account approves the transfer of an amount to another account
61     mapping(address => mapping (address => uint256)) allowed;
62 
63     // Functions with this modifier can only be executed by the owner
64     modifier onlyOwner() {
65         require(msg.sender == owner, "only owner");
66         _;
67     }
68 
69     event Transfer(address, address, uint256);
70     event Approval(address, address, uint256);
71 
72     // Constructor
73     constructor (string memory _name, string memory _symbol) public {
74 
75         owner = msg.sender;
76 
77         name = _name;
78         symbol = _symbol;
79         balances[msg.sender] = totalSupply;
80     }
81 
82     // What is the balance of a particular account?
83     function balanceOf(address _owner) public view returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     // Transfer the balance from owner's account to another account
88     function transfer(address _to, uint256 _amount) public returns (bool success) {
89 
90         require(balances[msg.sender] >= _amount, "insuficient sender's balance");
91         require(_amount > 0, "requested amount must be positive");
92         require(balances[_to] + _amount > balances[_to], "receiver's balance overflows");
93 
94         balances[msg.sender] -= _amount;
95         balances[_to] += _amount;
96         emit Transfer(msg.sender, _to, _amount);
97         return true;
98     }
99 
100     // Send _value amount of tokens from address _from to address _to
101     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
102     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
103     // fees in sub-currencies; the command should fail unless the _from account has
104     // deliberately authorized the sender of the message via some mechanism; we propose
105     // these standardized APIs for approval:
106     function transferFrom(address _from, address _to,uint256 _amount) public returns (bool success) {
107 
108         require(balances[_from] >= _amount, "insuficient sender's balance");
109         require(allowed[_from][msg.sender] >= _amount, "not allowed transfer");
110         require(_amount > 0, "requested amount must be positive");
111         require(balances[_to] + _amount > balances[_to], "receiver's balance overflows");
112 
113         balances[_from] -= _amount;
114         allowed[_from][msg.sender] -= _amount;
115         balances[_to] += _amount;
116         emit Transfer(_from, _to, _amount);
117 
118         return true;
119     }
120 
121     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
122     // If this function is called again it overwrites the current allowance with _value.
123     function approve(address _spender, uint256 _amount) public returns (bool success) {
124         allowed[msg.sender][_spender] = _amount;
125         emit Approval(msg.sender, _spender, _amount);
126         return true;
127     }
128 
129     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
130         return allowed[_owner][_spender];
131     }
132 }
133 
134 contract BFCtoken is ERC20 {
135     constructor() public ERC20 ("Bifrost", "BFC") {}
136 }
137 
138 contract LPtoken is ERC20 {
139     constructor() public ERC20 ("BFC-ETH", "LP") {}
140 }
141 
142 contract BiFitoken is ERC20 {
143     constructor() public ERC20 ("BiFi", "BiFi") {}
144 }
145 
146 // File: contracts/module/storageModule.sol
147 
148 pragma solidity 0.6.12;
149 
150 
151 /**
152  * @title BiFi's Reward Distribution Storage Contract
153  * @notice Define the basic Contract State
154  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
155  */
156 contract storageModule {
157     address public owner;
158     address public pendingOwner;
159 
160     bool public claimLock;
161     bool public withdrawLock;
162 
163     uint256 public rewardPerBlock;
164     uint256 public decrementUnitPerBlock;
165     uint256 public rewardLane;
166 
167     uint256 public lastBlockNum;
168     uint256 public totalDeposited;
169 
170     ERC20 public lpErc; ERC20 public rewardErc;
171 
172     mapping(address => Account) public accounts;
173 
174     uint256 public passedPoint;
175     RewardVelocityPoint[] public registeredPoints;
176 
177     struct Account {
178         uint256 deposited;
179         uint256 pointOnLane;
180         uint256 rewardAmount;
181     }
182 
183     struct RewardVelocityPoint {
184         uint256 blockNumber;
185         uint256 rewardPerBlock;
186         uint256 decrementUnitPerBlock;
187     }
188 
189     struct UpdateRewardLaneModel {
190         uint256 len; uint256 tmpBlockDelta;
191 
192         uint256 memPassedPoint; uint256 tmpPassedPoint;
193 
194         uint256 memThisBlockNum;
195         uint256 memLastBlockNum; uint256 tmpLastBlockNum;
196 
197         uint256 memTotalDeposit;
198 
199         uint256 memRewardLane; uint256 tmpRewardLane;
200         uint256 memRewardPerBlock; uint256 tmpRewardPerBlock;
201 
202         uint256 memDecrementUnitPerBlock; uint256 tmpDecrementUnitPerBlock;
203     }
204 }
205 
206 // File: contracts/module/eventModule.sol
207 
208 pragma solidity 0.6.12;
209 
210 /**
211  * @title BiFi's Reward Distribution Event Contract
212  * @notice Define the service Events
213  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
214  */
215 contract eventModule {
216     /// @dev Events for user actions
217     event Deposit(address userAddr, uint256 amount, uint256 userDeposit, uint256 totalDeposit);
218     event Withdraw(address userAddr, uint256 amount, uint256 userDeposit, uint256 totalDeposit);
219     event Claim(address userAddr, uint256 amount);
220     event UpdateRewardParams(uint256 atBlockNumber, uint256 rewardPerBlock, uint256 decrementUnitPerBlock);
221 
222     /// @dev Events for admin actions below
223 
224     /// @dev Contracts Access Control
225     event ClaimLock(bool lock);
226     event WithdrawLock(bool lock);
227     event OwnershipTransfer(address from, address to);
228 
229     /// @dev Distribution Model Parameter editer
230     event SetRewardParams(uint256 rewardPerBlock, uint256 decrementUnitPerBlock);
231     event RegisterRewardParams(uint256 atBlockNumber, uint256 rewardPerBlock, uint256 decrementUnitPerBlock);
232     event DeleteRegisterRewardParams(uint256 index, uint256 atBlockNumber, uint256 rewardPerBlock, uint256 decrementUnitPerBlock, uint256 arrayLen);
233 }
234 
235 // File: contracts/module/internalModule.sol
236 
237 pragma solidity 0.6.12;
238 
239 
240 
241 
242 /**
243  * @title BiFi's Reward Distribution Internal Contract
244  * @notice Implement the basic functions for staking and reward distribution
245  * @dev All functions are internal.
246  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
247  */
248 contract internalModule is storageModule, eventModule, safeMathModule {
249     /**
250      * @notice Deposit the Contribution Tokens
251      * @param userAddr The user address of the Contribution Tokens
252      * @param amount The amount of the Contribution Tokens
253      */
254     function _deposit(address userAddr, uint256 amount) internal {
255         Account memory user = accounts[userAddr];
256         uint256 totalDeposit = totalDeposited;
257 
258         user.deposited = safeAdd(user.deposited, amount);
259         accounts[userAddr].deposited = user.deposited;
260         totalDeposit = safeAdd(totalDeposited, amount);
261         totalDeposited = totalDeposit;
262 
263         if(amount > 0) {
264             /// @dev transfer the Contribution Toknes to this contract.
265             emit Deposit(userAddr, amount, user.deposited, totalDeposit);
266             require( lpErc.transferFrom(msg.sender, address(this), amount), "token error" );
267         }
268     }
269 
270     /**
271      * @notice Withdraw the Contribution Tokens
272      * @param userAddr The user address of the Contribution Tokens
273      * @param amount The amount of the Contribution Tokens
274      */
275     function _withdraw(address userAddr, uint256 amount) internal {
276         Account memory user = accounts[userAddr];
277         uint256 totalDeposit = totalDeposited;
278         require(user.deposited >= amount, "not enough user Deposit");
279 
280         user.deposited = safeSub(user.deposited, amount);
281         accounts[userAddr].deposited = user.deposited;
282         totalDeposit = safeSub(totalDeposited, amount);
283         totalDeposited = totalDeposit;
284 
285         if(amount > 0) {
286             /// @dev transfer the Contribution Tokens from this contact.
287             emit Withdraw(userAddr, amount, user.deposited, totalDeposit);
288             require( lpErc.transfer(userAddr, amount), "token error" );
289         }
290     }
291 
292     /**
293      * @notice Calculate current reward
294      * @dev This function is called whenever the balance of the Contribution
295        Tokens of the user.
296      * @param userAddr The user address of the Contribution and Reward Tokens
297      */
298     function _redeemAll(address userAddr) internal {
299         Account memory user = accounts[userAddr];
300 
301         uint256 newRewardLane = _updateRewardLane();
302 
303         uint256 distance = safeSub(newRewardLane, user.pointOnLane);
304         uint256 rewardAmount = expMul(user.deposited, distance);
305 
306         if(user.pointOnLane != newRewardLane) accounts[userAddr].pointOnLane = newRewardLane;
307         if(rewardAmount != 0) accounts[userAddr].rewardAmount = safeAdd(user.rewardAmount, rewardAmount);
308     }
309 
310     /**
311      * @notice Claim the Reward Tokens
312      * @dev Transfer all reward the user has earned at once.
313      * @param userAddr The user address of the Reward Tokens
314      */
315     function _rewardClaim(address userAddr) internal {
316         Account memory user = accounts[userAddr];
317 
318         if(user.rewardAmount != 0) {
319             uint256 amount = user.rewardAmount;
320             accounts[userAddr].rewardAmount = 0;
321 
322             /// @dev transfer the Reward Tokens from this contract.
323             emit Claim(userAddr, amount);
324             require(rewardErc.transfer(userAddr, amount), "token error" );
325         }
326     }
327 
328     /**
329      * @notice Update the reward lane value upto ths currnet moment (block)
330      * @dev This function should care the "reward velocity points," at which the
331        parameters of reward distribution are changed.
332      * @return The current (calculated) reward lane value
333      */
334     function _updateRewardLane() internal returns (uint256) {
335         /// @dev Set up memory variables used for calculation temporarily.
336         UpdateRewardLaneModel memory vars;
337 
338         vars.len = registeredPoints.length;
339         vars.memTotalDeposit = totalDeposited;
340 
341         vars.tmpPassedPoint = vars.memPassedPoint = passedPoint;
342 
343         vars.memThisBlockNum = block.number;
344         vars.tmpLastBlockNum = vars.memLastBlockNum = lastBlockNum;
345 
346         vars.tmpRewardLane = vars.memRewardLane = rewardLane;
347         vars.tmpRewardPerBlock = vars.memRewardPerBlock = rewardPerBlock;
348         vars.tmpDecrementUnitPerBlock = vars.memDecrementUnitPerBlock = decrementUnitPerBlock;
349 
350         for(uint256 i=vars.memPassedPoint; i<vars.len; i++) {
351             RewardVelocityPoint memory point = registeredPoints[i];
352 
353             /**
354              * @dev Check whether this reward velocity point is valid and has
355                not applied yet.
356              */
357             if(vars.tmpLastBlockNum < point.blockNumber && point.blockNumber <= vars.memThisBlockNum) {
358                 vars.tmpPassedPoint = i+1;
359                 /// @dev Update the reward lane with the tmp variables
360                 vars.tmpBlockDelta = safeSub(point.blockNumber, vars.tmpLastBlockNum);
361                 (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
362                 _calcNewRewardLane(
363                     vars.tmpRewardLane,
364                     vars.memTotalDeposit,
365                     vars.tmpRewardPerBlock,
366                     vars.tmpDecrementUnitPerBlock,
367                     vars.tmpBlockDelta);
368 
369                 /// @dev Update the tmp variables with this reward velocity point.
370                 vars.tmpLastBlockNum = point.blockNumber;
371                 vars.tmpRewardPerBlock = point.rewardPerBlock;
372                 vars.tmpDecrementUnitPerBlock = point.decrementUnitPerBlock;
373                 /**
374                  * @dev Notify the update of the parameters (by passing the
375                    reward velocity points)
376                  */
377                 emit UpdateRewardParams(point.blockNumber, point.rewardPerBlock, point.decrementUnitPerBlock);
378             } else {
379                 /// @dev sorted array, exit eariler without accessing future points.
380                 break;
381             }
382         }
383 
384         /**
385          * @dev Update the reward lane for the remained period between the
386            latest velocity point and this moment (block)
387          */
388         if( vars.tmpLastBlockNum < vars.memThisBlockNum ) {
389             vars.tmpBlockDelta = safeSub(vars.memThisBlockNum, vars.tmpLastBlockNum);
390             vars.tmpLastBlockNum = vars.memThisBlockNum;
391             (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
392             _calcNewRewardLane(
393                 vars.tmpRewardLane,
394                 vars.memTotalDeposit,
395                 vars.tmpRewardPerBlock,
396                 vars.tmpDecrementUnitPerBlock,
397                 vars.tmpBlockDelta);
398         }
399 
400         /**
401          * @dev Update the reward lane parameters with the tmp variables.
402          */
403         if(vars.memLastBlockNum != vars.tmpLastBlockNum) lastBlockNum = vars.tmpLastBlockNum;
404         if(vars.memPassedPoint != vars.tmpPassedPoint) passedPoint = vars.tmpPassedPoint;
405         if(vars.memRewardLane != vars.tmpRewardLane) rewardLane = vars.tmpRewardLane;
406         if(vars.memRewardPerBlock != vars.tmpRewardPerBlock) rewardPerBlock = vars.tmpRewardPerBlock;
407         if(vars.memDecrementUnitPerBlock != vars.tmpDecrementUnitPerBlock) decrementUnitPerBlock = vars.tmpDecrementUnitPerBlock;
408 
409         return vars.tmpRewardLane;
410     }
411 
412     /**
413      * @notice Calculate a new reward lane value with the given parameters
414      * @param _rewardLane The previous reward lane value
415      * @param _totalDeposit Thte total deposit amount of the Contribution Tokens
416      * @param _rewardPerBlock The reward token amount per a block
417      * @param _decrementUnitPerBlock The decerement amount of the reward token per a block
418      */
419     function _calcNewRewardLane(
420         uint256 _rewardLane,
421         uint256 _totalDeposit,
422         uint256 _rewardPerBlock,
423         uint256 _decrementUnitPerBlock,
424         uint256 delta) internal pure returns (uint256, uint256) {
425             uint256 executableDelta;
426             if(_decrementUnitPerBlock != 0) {
427                 executableDelta = safeDiv(_rewardPerBlock, _decrementUnitPerBlock);
428                 if(delta > executableDelta) delta = executableDelta;
429                 else executableDelta = 0;
430             }
431 
432             uint256 distance;
433             if(_totalDeposit != 0) {
434                 distance = expMul( _sequencePartialSumAverage(_rewardPerBlock, delta, _decrementUnitPerBlock), safeMul( expDiv(one, _totalDeposit), delta) );
435                 _rewardLane = safeAdd(_rewardLane, distance);
436             }
437 
438             if(executableDelta != 0) _rewardPerBlock = 0;
439             else _rewardPerBlock = _getNewRewardPerBlock(_rewardPerBlock, _decrementUnitPerBlock, delta);
440 
441             return (_rewardLane, _rewardPerBlock);
442     }
443 
444     /**
445      * @notice Register a new reward velocity point
446      * @dev We assume that reward velocity points are stored in order of block
447        number. Namely, registerPoints is always a sorted array.
448      * @param _blockNumber The block number for the point.
449      * @param _rewardPerBlock The reward token amount per a block
450      * @param _decrementUnitPerBlock The decerement amount of the reward token per a block
451      */
452     function _registerRewardVelocity(uint256 _blockNumber, uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) internal {
453         RewardVelocityPoint memory varPoint = RewardVelocityPoint(_blockNumber, _rewardPerBlock, _decrementUnitPerBlock);
454         emit RegisterRewardParams(_blockNumber, _rewardPerBlock, _decrementUnitPerBlock);
455         registeredPoints.push(varPoint);
456     }
457 
458     /**
459      * @notice Delete a existing reward velocity point
460      * @dev We assume that reward velocity points are stored in order of block
461        number. Namely, registerPoints is always a sorted array.
462      * @param _index The index number of deleting point in state array.
463      */
464     function _deleteRegisteredRewardVelocity(uint256 _index) internal {
465         uint256 len = registeredPoints.length;
466         require(len != 0 && _index < len, "error: no elements in registeredPoints");
467 
468         RewardVelocityPoint memory point = registeredPoints[_index];
469         emit DeleteRegisterRewardParams(_index, point.blockNumber, point.rewardPerBlock, point.decrementUnitPerBlock, len-1);
470         for(uint256 i=_index; i<len-1; i++) {
471             registeredPoints[i] = registeredPoints[i+1];
472         }
473         registeredPoints.pop();
474      }
475 
476     /**
477      * @notice Set paramaters for the reward distribution
478      * @param _rewardPerBlock The reward token amount per a block
479      * @param _decrementUnitPerBlock The decerement amount of the reward token per a block
480      */
481     function _setParams(uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) internal {
482         emit SetRewardParams(_rewardPerBlock, _decrementUnitPerBlock);
483         rewardPerBlock = _rewardPerBlock;
484         decrementUnitPerBlock = _decrementUnitPerBlock;
485     }
486 
487     /**
488      * @return the avaerage of the RewardLance of the inactive (i.e., no-action)
489        periods.
490     */
491     function _sequencePartialSumAverage(uint256 a, uint256 n, uint256 d) internal pure returns (uint256) {
492         /**
493         @dev return Sn / n,
494                 where Sn = ( (n{2*a + (n-1)d}) / 2 )
495             == ( (2na + (n-1)d) / 2 ) / n
496             caveat: use safeSub() to avoid the case that d is negative
497         */
498         if (n > 0)
499             return safeDiv(safeSub( safeMul(2,a), safeMul( safeSub(n,1), d) ), 2);
500         else
501             return 0;
502     }
503 
504     function _getNewRewardPerBlock(uint256 before, uint256 dec, uint256 delta) internal pure returns (uint256) {
505         return safeSub(before, safeMul(dec, delta));
506     }
507 
508     function _setClaimLock(bool lock) internal {
509         emit ClaimLock(lock);
510         claimLock = lock;
511     }
512 
513     function _setWithdrawLock(bool lock) internal {
514         emit WithdrawLock(lock);
515         withdrawLock = lock;
516     }
517 
518     function _setOwner(address newOwner) internal {
519         require(newOwner != address(0), "owner zero address");
520         emit OwnershipTransfer(owner, newOwner);
521         owner = newOwner;
522     }
523 
524     function _setPendingOwner(address _pendingOwner) internal {
525         require(_pendingOwner != address(0), "pending owner zero address");
526         pendingOwner = _pendingOwner;
527     }
528 }
529 
530 // File: contracts/module/viewModule.sol
531 
532 pragma solidity 0.6.12;
533 
534 
535 /**
536  * @title BiFi's Reward Distribution View Contract
537  * @notice Implements the view functions for support front-end
538  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
539  */
540 contract viewModule is internalModule {
541     function marketInformation(uint256 _fromBlockNumber, uint256 _toBlockNumber) external view returns (
542         uint256 rewardStartBlockNumber,
543         uint256 distributedAmount,
544         uint256 totalDeposit,
545         uint256 poolRate
546         )
547     {
548         if(rewardPerBlock == 0) rewardStartBlockNumber = registeredPoints[0].blockNumber;
549         else rewardStartBlockNumber = registeredPoints[0].blockNumber;
550 
551         distributedAmount = _redeemAllView(address(0));
552 
553         totalDeposit = totalDeposited;
554 
555         poolRate = getPoolRate(address(0), _fromBlockNumber, _toBlockNumber);
556 
557         return (
558             rewardStartBlockNumber,
559             distributedAmount,
560             totalDeposit,
561             poolRate
562         );
563     }
564 
565     function userInformation(address userAddr, uint256 _fromBlockNumber, uint256 _toBlockNumber) external view returns (
566         uint256 stakedTokenAmount,
567         uint256 rewardStartBlockNumber,
568         uint256 claimStartBlockNumber,
569         uint256 earnedTokenAmount,
570         uint256 poolRate
571         )
572     {
573         Account memory user = accounts[userAddr];
574 
575         stakedTokenAmount = user.deposited;
576 
577         if(rewardPerBlock == 0) rewardStartBlockNumber = registeredPoints[0].blockNumber;
578         else rewardStartBlockNumber = registeredPoints[0].blockNumber;
579 
580         earnedTokenAmount = _redeemAllView(userAddr);
581 
582         poolRate = getPoolRate(userAddr, _fromBlockNumber, _toBlockNumber);
583 
584         return (stakedTokenAmount, rewardStartBlockNumber, claimStartBlockNumber, earnedTokenAmount, poolRate);
585     }
586 
587     function modelInfo() external view returns (uint256, uint256, uint256, uint256, uint256) {
588         return (rewardPerBlock, decrementUnitPerBlock, rewardLane, lastBlockNum, totalDeposited);
589     }
590 
591     function getParams() external view returns (uint256, uint256, uint256, uint256) {
592         return (rewardPerBlock, rewardLane, lastBlockNum, totalDeposited);
593     }
594 
595     function getRegisteredPointLength() external view returns (uint256) {
596         return registeredPoints.length;
597     }
598 
599     function getRegisteredPoint(uint256 index) external view returns (uint256, uint256, uint256) {
600         RewardVelocityPoint memory point = registeredPoints[index];
601         return (point.blockNumber, point.rewardPerBlock, point.decrementUnitPerBlock);
602     }
603 
604     function userInfo(address userAddr) external view returns (uint256, uint256, uint256) {
605         Account memory user = accounts[userAddr];
606         uint256 earnedRewardAmount = _redeemAllView(userAddr);
607 
608         return (user.deposited, user.pointOnLane, earnedRewardAmount);
609     }
610 
611     function distributionInfo() external view returns (uint256, uint256, uint256) {
612         uint256 totalDistributedRewardAmount_now = _distributedRewardAmountView();
613         return (rewardPerBlock, decrementUnitPerBlock, totalDistributedRewardAmount_now);
614     }
615 
616     function _distributedRewardAmountView() internal view returns (uint256) {
617         return _redeemAllView( address(0) );
618     }
619 
620     function _redeemAllView(address userAddr) internal view returns (uint256) {
621         Account memory user;
622         uint256 newRewardLane;
623         if( userAddr != address(0) ) {
624             user = accounts[userAddr];
625             newRewardLane = _updateRewardLaneView(lastBlockNum);
626         } else {
627             user = Account(totalDeposited, 0, 0);
628             newRewardLane = _updateRewardLaneView(0);
629         }
630 
631         uint256 distance = safeSub(newRewardLane, user.pointOnLane);
632         uint256 rewardAmount = expMul(user.deposited, distance);
633 
634         return safeAdd(user.rewardAmount, rewardAmount);
635     }
636 
637     function _updateRewardLaneView(uint256 fromBlockNumber) internal view returns (uint256) {
638         /// @dev Set up memory variables used for calculation temporarily.
639         UpdateRewardLaneModel memory vars;
640 
641         vars.len = registeredPoints.length;
642         vars.memTotalDeposit = totalDeposited;
643 
644         if(fromBlockNumber == 0){
645             vars.tmpPassedPoint = vars.memPassedPoint = 0;
646 
647             vars.memThisBlockNum = block.number;
648             vars.tmpLastBlockNum = vars.memLastBlockNum = 0;
649             vars.tmpRewardLane = vars.memRewardLane = 0;
650             vars.tmpRewardPerBlock = vars.memRewardPerBlock = 0;
651             vars.tmpDecrementUnitPerBlock = vars.memDecrementUnitPerBlock = 0;
652         } else {
653             vars.tmpPassedPoint = vars.memPassedPoint = passedPoint;
654             vars.memThisBlockNum = block.number;
655             vars.tmpLastBlockNum = vars.memLastBlockNum = fromBlockNumber;
656 
657             vars.tmpRewardLane = vars.memRewardLane = rewardLane;
658             vars.tmpRewardPerBlock = vars.memRewardPerBlock = rewardPerBlock;
659             vars.tmpDecrementUnitPerBlock = vars.memDecrementUnitPerBlock = decrementUnitPerBlock;
660         }
661 
662         for(uint256 i=vars.memPassedPoint; i<vars.len; i++) {
663             RewardVelocityPoint memory point = registeredPoints[i];
664             /**
665              * @dev Check whether this reward velocity point is valid and has
666                not applied yet.
667              */
668             if(vars.tmpLastBlockNum < point.blockNumber && point.blockNumber <= vars.memThisBlockNum) {
669                 vars.tmpPassedPoint = i+1;
670                 /// @dev Update the reward lane with the tmp variables
671                 vars.tmpBlockDelta = safeSub(point.blockNumber, vars.tmpLastBlockNum);
672                 (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
673                 _calcNewRewardLane(
674                     vars.tmpRewardLane,
675                     vars.memTotalDeposit,
676                     vars.tmpRewardPerBlock,
677                     vars.tmpDecrementUnitPerBlock,
678                     vars.tmpBlockDelta);
679 
680                 /// @dev Update the tmp variables with this reward velocity point.
681                 vars.tmpLastBlockNum = point.blockNumber;
682                 vars.tmpRewardPerBlock = point.rewardPerBlock;
683                 vars.tmpDecrementUnitPerBlock = point.decrementUnitPerBlock;
684                 /**
685                  * @dev Notify the update of the parameters (by passing the
686                    reward velocity points)
687                  */
688             } else {
689                 /// @dev sorted array, exit eariler without accessing future points.
690                 break;
691             }
692         }
693 
694         /**
695          * @dev Update the reward lane for the remained period between the
696            latest velocity point and this moment (block)
697          */
698         if(vars.memThisBlockNum > vars.tmpLastBlockNum) {
699             vars.tmpBlockDelta = safeSub(vars.memThisBlockNum, vars.tmpLastBlockNum);
700             vars.tmpLastBlockNum = vars.memThisBlockNum;
701             (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
702             _calcNewRewardLane(
703                 vars.tmpRewardLane,
704                 vars.memTotalDeposit,
705                 vars.tmpRewardPerBlock,
706                 vars.tmpDecrementUnitPerBlock,
707                 vars.tmpBlockDelta);
708         }
709         return vars.tmpRewardLane;
710     }
711     /**
712      * @notice Get The rewardPerBlock of user in suggested period(see params)
713      * @param userAddr The Address of user, 0 for total
714      * @param fromBlockNumber calculation start block number
715      * @param toBlockNumber calculation end block number
716      * @notice this function calculate based on current contract state
717      */
718     function getPoolRate(address userAddr, uint256 fromBlockNumber, uint256 toBlockNumber) internal view returns (uint256) {
719         UpdateRewardLaneModel memory vars;
720 
721         vars.len = registeredPoints.length;
722         vars.memTotalDeposit = totalDeposited;
723 
724         vars.tmpLastBlockNum = vars.memLastBlockNum = fromBlockNumber;
725         (vars.memPassedPoint, vars.memRewardPerBlock, vars.memDecrementUnitPerBlock) = getParamsByBlockNumber(fromBlockNumber);
726         vars.tmpPassedPoint = vars.memPassedPoint;
727         vars.tmpRewardPerBlock = vars.memRewardPerBlock;
728         vars.tmpDecrementUnitPerBlock = vars.memDecrementUnitPerBlock;
729 
730         vars.memThisBlockNum = toBlockNumber;
731         vars.tmpRewardLane = vars.memRewardLane = 0;
732 
733         for(uint256 i=vars.memPassedPoint; i<vars.len; i++) {
734             RewardVelocityPoint memory point = registeredPoints[i];
735 
736             if(vars.tmpLastBlockNum < point.blockNumber && point.blockNumber <= vars.memThisBlockNum) {
737                 vars.tmpPassedPoint = i+1;
738                 vars.tmpBlockDelta = safeSub(point.blockNumber, vars.tmpLastBlockNum);
739                 (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
740                 _calcNewRewardLane(
741                     vars.tmpRewardLane,
742                     vars.memTotalDeposit,
743                     vars.tmpRewardPerBlock,
744                     vars.tmpDecrementUnitPerBlock,
745                     vars.tmpBlockDelta);
746 
747                 vars.tmpLastBlockNum = point.blockNumber;
748                 vars.tmpRewardPerBlock = point.rewardPerBlock;
749                 vars.tmpDecrementUnitPerBlock = point.decrementUnitPerBlock;
750 
751             } else {
752                 break;
753             }
754         }
755 
756         if(vars.memThisBlockNum > vars.tmpLastBlockNum) {
757             vars.tmpBlockDelta = safeSub(vars.memThisBlockNum, vars.tmpLastBlockNum);
758             vars.tmpLastBlockNum = vars.memThisBlockNum;
759             (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
760             _calcNewRewardLane(
761                 vars.tmpRewardLane,
762                 vars.memTotalDeposit,
763                 vars.tmpRewardPerBlock,
764                 vars.tmpDecrementUnitPerBlock,
765                 vars.tmpBlockDelta);
766         }
767 
768         Account memory user;
769         if( userAddr != address(0) ) user = accounts[userAddr];
770         else user = Account(vars.memTotalDeposit, 0, 0);
771 
772         return safeDiv(expMul(user.deposited, vars.tmpRewardLane), safeSub(toBlockNumber, fromBlockNumber));
773     }
774 
775     function getParamsByBlockNumber(uint256 _blockNumber) internal view returns (uint256, uint256, uint256) {
776         uint256 _rewardPerBlock; uint256 _decrement;
777         uint256 i;
778 
779         uint256 tmpthisPoint;
780 
781         uint256 pointLength = registeredPoints.length;
782         if( pointLength > 0 ) {
783             for(i = 0; i < pointLength; i++) {
784                 RewardVelocityPoint memory point = registeredPoints[i];
785                 if(_blockNumber >= point.blockNumber && 0 != point.blockNumber) {
786                     tmpthisPoint = i;
787                     _rewardPerBlock = point.rewardPerBlock;
788                     _decrement = point.decrementUnitPerBlock;
789                 } else if( 0 == point.blockNumber ) continue;
790                 else break;
791             }
792         }
793         RewardVelocityPoint memory point = registeredPoints[tmpthisPoint];
794         _rewardPerBlock = point.rewardPerBlock;
795         _decrement = point.decrementUnitPerBlock;
796         if(_blockNumber > point.blockNumber) {
797             _rewardPerBlock = safeSub(_rewardPerBlock, safeMul(_decrement, safeSub(_blockNumber, point.blockNumber) ) );
798         }
799         return (i, _rewardPerBlock, _decrement);
800     }
801 
802     function getUserPoolRate(address userAddr, uint256 fromBlockNumber, uint256 toBlockNumber) external view returns (uint256) {
803         return getPoolRate(userAddr, fromBlockNumber, toBlockNumber);
804     }
805 
806     function getModelPoolRate(uint256 fromBlockNumber, uint256 toBlockNumber) external view returns (uint256) {
807         return getPoolRate(address(0), fromBlockNumber, toBlockNumber);
808     }
809 }
810 
811 // File: contracts/module/externalModule.sol
812 
813 pragma solidity 0.6.12;
814 
815 
816 /**
817  * @title BiFi's Reward Distribution External Contract
818  * @notice Implements the service actions.
819  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
820  */
821 contract externalModule is viewModule {
822     modifier onlyOwner() {
823         require(msg.sender == owner, "onlyOwner: external function access control!");
824         _;
825     }
826     modifier checkClaimLocked() {
827         require(!claimLock, "error: claim Locked");
828         _;
829     }
830     modifier checkWithdrawLocked() {
831         require(!withdrawLock, "error: withdraw Locked");
832         _;
833     }
834 
835     /**
836      * @notice Set the Deposit-Token address
837      * @param erc20Addr The address of Deposit Token
838      */
839     function setERC(address erc20Addr) external onlyOwner {
840         lpErc = ERC20(erc20Addr);
841     }
842 
843     /**
844      * @notice Set the Contribution-Token address
845      * @param erc20Addr The address of Contribution Token
846      */
847     function setRE(address erc20Addr) external onlyOwner {
848         rewardErc = ERC20(erc20Addr);
849     }
850 
851     /**
852      * @notice Set the reward distribution parameters instantly
853      */
854     function setParam(uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) onlyOwner external {
855         _setParams(_rewardPerBlock, _decrementUnitPerBlock);
856     }
857 
858     /**
859      * @notice Terminate Contract Distribution
860      */
861     function modelFinish(uint256 amount) external onlyOwner {
862         if( amount != 0) {
863             require( rewardErc.transfer(owner, amount), "token error" );
864         }
865         else {
866             require( rewardErc.transfer(owner, rewardErc.balanceOf(address(this))), "token error" );
867         }
868         delete totalDeposited;
869         delete rewardPerBlock;
870         delete decrementUnitPerBlock;
871         delete rewardLane;
872         delete totalDeposited;
873         delete registeredPoints;
874     }
875 
876     /**
877      * @notice Transfer the Remaining Contribution Tokens
878      */
879     function retrieveRewardAmount(uint256 amount) external onlyOwner {
880         if( amount != 0) {
881             require( rewardErc.transfer(owner, amount), "token error");
882         }
883         else {
884             require( rewardErc.transfer(owner, rewardErc.balanceOf(address(this))), "token error");
885         }
886     }
887 
888     /**
889      * @notice Deposit the Contribution Tokens
890      * @param amount The amount of the Contribution Tokens
891      */
892     function deposit(uint256 amount) external {
893         address userAddr = msg.sender;
894         _redeemAll(userAddr);
895         _deposit(userAddr, amount);
896     }
897 
898     /**
899      * @notice Deposit the Contribution Tokens to target user
900      * @param userAddr The target user
901      * @param amount The amount of the Contribution Tokens
902      */
903     function depositTo(address userAddr, uint256 amount) external {
904         _redeemAll(userAddr);
905         _deposit(userAddr, amount);
906     }
907 
908     /**
909      * @notice Withdraw the Contribution Tokens
910      * @param amount The amount of the Contribution Tokens
911      */
912     function withdraw(uint256 amount) checkWithdrawLocked external {
913         address userAddr = msg.sender;
914         _redeemAll(userAddr);
915         _withdraw(userAddr, amount);
916     }
917 
918     /**
919      * @notice Claim the Reward Tokens
920      * @dev Transfer all reward the user has earned at once.
921      */
922     function rewardClaim() checkClaimLocked external {
923         address userAddr = msg.sender;
924         _redeemAll(userAddr);
925         _rewardClaim(userAddr);
926     }
927     /**
928      * @notice Claim the Reward Tokens
929      * @param userAddr The targetUser
930      * @dev Transfer all reward the target user has earned at once.
931      */
932     function rewardClaimTo(address userAddr) checkClaimLocked external {
933         _redeemAll(userAddr);
934         _rewardClaim(userAddr);
935     }
936 
937     /// @dev Set locks & access control
938     function setClaimLock(bool lock) onlyOwner external {
939         _setClaimLock(lock);
940     }
941     function setWithdrawLock(bool lock) onlyOwner external {
942         _setWithdrawLock(lock);
943     }
944 
945     function ownershipTransfer(address newPendingOwner) onlyOwner external {
946         _setPendingOwner(newPendingOwner);
947     }
948 
949     function acceptOwnership() external {
950         address sender = msg.sender;
951         require(sender == pendingOwner, "msg.sender != pendingOwner");
952         _setOwner(sender);
953     }
954 
955     /**
956      * @notice Register a new future reward velocity point
957      */
958     function registerRewardVelocity(uint256 _blockNumber, uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) onlyOwner public {
959         require(_blockNumber > block.number, "new Reward params should register earlier");
960         require(registeredPoints.length == 0 || _blockNumber > registeredPoints[registeredPoints.length-1].blockNumber, "Earilier velocity points are already set.");
961         _registerRewardVelocity(_blockNumber, _rewardPerBlock, _decrementUnitPerBlock);
962     }
963     function deleteRegisteredRewardVelocity(uint256 _index) onlyOwner external {
964         require(_index >= passedPoint, "Reward velocity point already passed.");
965         _deleteRegisteredRewardVelocity(_index);
966     }
967 
968     /**
969      * @notice Set the reward distribution parameters
970      */
971     function setRewardVelocity(uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) onlyOwner external {
972         _updateRewardLane();
973         _setParams(_rewardPerBlock, _decrementUnitPerBlock);
974     }
975 }
976 
977 // File: contracts/DistributionModelV3.sol
978 
979 pragma solidity 0.6.12;
980 
981 
982 /**
983  * @title BiFi's Reward Distribution Contract
984  * @notice Implements voting process along with vote delegation
985  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
986  */
987 contract DistributionModelV3 is externalModule {
988     constructor(address _owner, address _lpErc, address _rewardErc) public {
989         owner = _owner;
990         lpErc = ERC20(_lpErc);
991         rewardErc = ERC20(_rewardErc);
992         lastBlockNum = block.number;
993     }
994 }
995 
996 contract BFCModel is DistributionModelV3 {
997     constructor(address _owner, address _lpErc, address _rewardErc, uint256 _start)
998     DistributionModelV3(_owner, _lpErc, _rewardErc) public {
999         /*
1000         _start: parameter start block nubmer
1001         0x3935413a1cdd90ff: fixed point(1e18) reward per blocks
1002         0x62e9bea75f: fixed point(1e18) decrement per blocks
1003         */
1004         _registerRewardVelocity(_start, 0x3935413a1cdd90ff, 0x62e9bea75f);
1005     }
1006 }
1007 
1008 contract BFCETHModel is DistributionModelV3 {
1009     constructor(address _owner, address _lpErc, address _rewardErc, uint256 _start)
1010     DistributionModelV3(_owner, _lpErc, _rewardErc) public {
1011         /*
1012         _start: parameter start block nubmer
1013         0xe4d505786b744b3f: fixed point(1e18) reward per blocks
1014         0x18ba6fb966b: fixed point(1e18) decrement per blocks
1015         */
1016         _registerRewardVelocity(_start, 0xe4d505786b744b3f, 0x18ba6fb966b);
1017     }
1018 }
1019 
1020 contract BiFiETHModel is DistributionModelV3 {
1021     constructor(address _owner, address _lpErc, address _rewardErc, uint256 _start)
1022     DistributionModelV3(_owner, _lpErc, _rewardErc) public {
1023         /*
1024         _start: parameter start block nubmer
1025         0x11e0a46e285a68955: fixed point(1e18) reward per blocks
1026         0x1ee90ba90c4: fixed point(1e18) decrement per blocks
1027         */
1028         _registerRewardVelocity(_start, 0x11e0a46e285a68955, 0x1ee90ba90c4);
1029     }
1030 }
1031 
1032 // File: contracts/SRD_SushiSwap.sol
1033 
1034 pragma solidity 0.6.12;
1035 
1036 
1037 contract BFCETHSushiSwapReward is DistributionModelV3 {
1038     constructor(uint256 start, uint256 reward_per_block, uint256 dec_per_block)
1039         DistributionModelV3(
1040             0x359903041dE93c69828F911aeB0BE29CC9ccc58b, //ower
1041             0x281Df7fc89294C84AfA2A21FfEE8f6807F9C9226, //swap_pool_token(BFCETH_Sushi)
1042             0x2791BfD60D232150Bff86b39B7146c0eaAA2BA81  //reward_token(bifi)
1043         ) public {
1044         _registerRewardVelocity(start, reward_per_block, dec_per_block);
1045         pendingOwner = msg.sender;
1046     }
1047 }
1048 
1049 contract BiFiETHSushiSwapReward is DistributionModelV3 {
1050     constructor(uint256 start, uint256 reward_per_block, uint256 dec_per_block)
1051     DistributionModelV3(
1052         0x359903041dE93c69828F911aeB0BE29CC9ccc58b, //owner
1053         0x0beC54c89a7d9F15C4e7fAA8d47ADEdF374462eD, //swap_pool_token(BiFiETH_Sushi)
1054         0x2791BfD60D232150Bff86b39B7146c0eaAA2BA81  //reward_token(bifi)
1055     ) public {
1056         _registerRewardVelocity(start, reward_per_block, dec_per_block);
1057         pendingOwner = msg.sender;
1058     }
1059 }