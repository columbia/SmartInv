1 // File: contracts/module/safeMath.sol
2 
3 // SPDX-License-Identifier: BSD-3-Clause
4 pragma solidity 0.6.12;
5 
6 // from: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
7 // Subject to the MIT license.
8 
9 /**
10  * @title BiFi's safe-math Contract
11  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
12  */
13 contract safeMathModule {
14     uint256 constant one = 1 ether;
15 
16     function expDiv(uint256 a, uint256 b) internal pure returns (uint256) {
17         return safeDiv( safeMul(a, one), b);
18     }
19     function expMul(uint256 a, uint256 b) internal pure returns (uint256) {
20         return safeDiv( safeMul(a, b), one);
21     }
22     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addtion overflow");
25         return c;
26     }
27     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(a >= b, "SafeMath: subtraction overflow");
29         return a - b;
30     }
31     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if(a == 0) { return 0;}
33         uint256 c = a * b;
34         require( (c/a) == b, "SafeMath: multiplication overflow");
35         return c;
36     }
37     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b > 0, "SafeMath: division by zero");
39         return (a/b);
40     }
41 }
42 
43 // File: contracts/ERC20.sol
44 
45 /**
46  * @title BiFi's ERC20 Mockup Contract
47  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
48  */
49 contract ERC20 {
50     string symbol;
51     string name;
52     uint8 decimals = 18;
53     uint256 totalSupply = 1000 * 1e9 * 1e18; // token amount: 1000 Bilions
54 
55     // Owner of this contract
56     address public owner;
57 
58     // Balances for each account
59     mapping(address => uint256) balances;
60 
61     // Owner of account approves the transfer of an amount to another account
62     mapping(address => mapping (address => uint256)) allowed;
63 
64     // Functions with this modifier can only be executed by the owner
65     modifier onlyOwner() {
66         require(msg.sender == owner, "only owner");
67         _;
68     }
69 
70     event Transfer(address, address, uint256);
71     event Approval(address, address, uint256);
72 
73     // Constructor
74     constructor (string memory _name, string memory _symbol) public {
75 
76         owner = msg.sender;
77 
78         name = _name;
79         symbol = _symbol;
80         balances[msg.sender] = totalSupply;
81     }
82 
83     // What is the balance of a particular account?
84     function balanceOf(address _owner) public view returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     // Transfer the balance from owner's account to another account
89     function transfer(address _to, uint256 _amount) public returns (bool success) {
90 
91         require(balances[msg.sender] >= _amount, "insuficient sender's balance");
92         require(_amount > 0, "requested amount must be positive");
93         require(balances[_to] + _amount > balances[_to], "receiver's balance overflows");
94 
95         balances[msg.sender] -= _amount;
96         balances[_to] += _amount;
97         emit Transfer(msg.sender, _to, _amount);
98         return true;
99     }
100 
101     // Send _value amount of tokens from address _from to address _to
102     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
103     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
104     // fees in sub-currencies; the command should fail unless the _from account has
105     // deliberately authorized the sender of the message via some mechanism; we propose
106     // these standardized APIs for approval:
107     function transferFrom(address _from, address _to,uint256 _amount) public returns (bool success) {
108 
109         require(balances[_from] >= _amount, "insuficient sender's balance");
110         require(allowed[_from][msg.sender] >= _amount, "not allowed transfer");
111         require(_amount > 0, "requested amount must be positive");
112         require(balances[_to] + _amount > balances[_to], "receiver's balance overflows");
113 
114         balances[_from] -= _amount;
115         allowed[_from][msg.sender] -= _amount;
116         balances[_to] += _amount;
117         emit Transfer(_from, _to, _amount);
118 
119         return true;
120     }
121 
122     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
123     // If this function is called again it overwrites the current allowance with _value.
124     function approve(address _spender, uint256 _amount) public returns (bool success) {
125         allowed[msg.sender][_spender] = _amount;
126         emit Approval(msg.sender, _spender, _amount);
127         return true;
128     }
129 
130     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
131         return allowed[_owner][_spender];
132     }
133 }
134 
135 contract BFCtoken is ERC20 {
136     constructor() public ERC20 ("Bifrost", "BFC") {}
137 }
138 
139 contract LPtoken is ERC20 {
140     constructor() public ERC20 ("BFC-ETH", "LP") {}
141 }
142 
143 contract BiFitoken is ERC20 {
144     constructor() public ERC20 ("BiFi", "BiFi") {}
145 }
146 
147 // File: contracts/module/storageModule.sol
148 
149 
150 /**
151  * @title BiFi's Reward Distribution Storage Contract
152  * @notice Define the basic Contract State
153  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
154  */
155 contract storageModule {
156     address public owner;
157 
158     bool public claimLock;
159     bool public withdrawLock;
160 
161     uint256 public rewardPerBlock;
162     uint256 public decrementUnitPerBlock;
163     uint256 public rewardLane;
164 
165     uint256 public lastBlockNum;
166     uint256 public totalDeposited;
167 
168     ERC20 public lpErc; ERC20 public rewardErc;
169 
170     mapping(address => Account) public accounts;
171 
172     uint256 public passedPoint;
173     RewardVelocityPoint[] public registeredPoints;
174 
175     struct Account {
176         uint256 deposited;
177         uint256 pointOnLane;
178         uint256 rewardAmount;
179     }
180 
181     struct RewardVelocityPoint {
182         uint256 blockNumber;
183         uint256 rewardPerBlock;
184         uint256 decrementUnitPerBlock;
185     }
186 
187     struct UpdateRewardLaneModel {
188         uint256 len; uint256 tmpBlockDelta;
189 
190         uint256 memPassedPoint; uint256 tmpPassedPoint;
191 
192         uint256 memThisBlockNum;
193         uint256 memLastBlockNum; uint256 tmpLastBlockNum;
194 
195         uint256 memTotalDeposit;
196 
197         uint256 memRewardLane; uint256 tmpRewardLane;
198         uint256 memRewardPerBlock; uint256 tmpRewardPerBlock;
199 
200         uint256 memDecrementUnitPerBlock; uint256 tmpDecrementUnitPerBlock;
201     }
202 }
203 
204 // File: contracts/module/eventModule.sol
205 
206 /**
207  * @title BiFi's Reward Distribution Event Contract
208  * @notice Define the service Events
209  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
210  */
211 contract eventModule {
212     /// @dev Events for user actions
213     event Deposit(address userAddr, uint256 amount, uint256 userDeposit, uint256 totalDeposit);
214     event Withdraw(address userAddr, uint256 amount, uint256 userDeposit, uint256 totalDeposit);
215     event Claim(address userAddr, uint256 amount);
216     event UpdateRewardParams(uint256 atBlockNumber, uint256 rewardPerBlock, uint256 decrementUnitPerBlock);
217 
218     /// @dev Events for admin actions below
219 
220     /// @dev Contracts Access Control
221     event ClaimLock(bool lock);
222     event WithdrawLock(bool lock);
223     event OwnershipTransfer(address from, address to);
224 
225     /// @dev Distribution Model Parameter editer
226     event SetRewardParams(uint256 rewardPerBlock, uint256 decrementUnitPerBlock);
227     event RegisterRewardParams(uint256 atBlockNumber, uint256 rewardPerBlock, uint256 decrementUnitPerBlock);
228     event DeleteRegisterRewardParams(uint256 index, uint256 atBlockNumber, uint256 rewardPerBlock, uint256 decrementUnitPerBlock, uint256 arrayLen);
229 }
230 
231 // File: contracts/module/internalModule.sol
232 
233 
234 
235 
236 /**
237  * @title BiFi's Reward Distribution Internal Contract
238  * @notice Implement the basic functions for staking and reward distribution
239  * @dev All functions are internal.
240  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
241  */
242 contract internalModule is storageModule, eventModule, safeMathModule {
243     /**
244      * @notice Deposit the Contribution Tokens
245      * @param userAddr The user address of the Contribution Tokens
246      * @param amount The amount of the Contribution Tokens
247      */
248     function _deposit(address userAddr, uint256 amount) internal {
249         Account memory user = accounts[userAddr];
250         uint256 totalDeposit = totalDeposited;
251 
252         user.deposited = safeAdd(user.deposited, amount);
253         accounts[userAddr].deposited = user.deposited;
254         totalDeposit = safeAdd(totalDeposited, amount);
255         totalDeposited = totalDeposit;
256 
257         if(amount > 0) {
258             /// @dev transfer the Contribution Toknes to this contract.
259             emit Deposit(userAddr, amount, user.deposited, totalDeposit);
260             require( lpErc.transferFrom(msg.sender, address(this), amount), "token error" );
261         }
262     }
263 
264     /**
265      * @notice Withdraw the Contribution Tokens
266      * @param userAddr The user address of the Contribution Tokens
267      * @param amount The amount of the Contribution Tokens
268      */
269     function _withdraw(address userAddr, uint256 amount) internal {
270         Account memory user = accounts[userAddr];
271         uint256 totalDeposit = totalDeposited;
272         require(user.deposited >= amount, "not enough user Deposit");
273 
274         user.deposited = safeSub(user.deposited, amount);
275         accounts[userAddr].deposited = user.deposited;
276         totalDeposit = safeSub(totalDeposited, amount);
277         totalDeposited = totalDeposit;
278 
279         if(amount > 0) {
280             /// @dev transfer the Contribution Tokens from this contact.
281             emit Withdraw(userAddr, amount, user.deposited, totalDeposit);
282             require( lpErc.transfer(userAddr, amount), "token error" );
283         }
284     }
285 
286     /**
287      * @notice Calculate current reward
288      * @dev This function is called whenever the balance of the Contribution
289        Tokens of the user.
290      * @param userAddr The user address of the Contribution and Reward Tokens
291      */
292     function _redeemAll(address userAddr) internal {
293         Account memory user = accounts[userAddr];
294 
295         uint256 newRewardLane = _updateRewardLane();
296 
297         uint256 distance = safeSub(newRewardLane, user.pointOnLane);
298         uint256 rewardAmount = expMul(user.deposited, distance);
299 
300         if(user.pointOnLane != newRewardLane) accounts[userAddr].pointOnLane = newRewardLane;
301         if(rewardAmount != 0) accounts[userAddr].rewardAmount = safeAdd(user.rewardAmount, rewardAmount);
302     }
303 
304     /**
305      * @notice Claim the Reward Tokens
306      * @dev Transfer all reward the user has earned at once.
307      * @param userAddr The user address of the Reward Tokens
308      */
309     function _rewardClaim(address userAddr) internal {
310         Account memory user = accounts[userAddr];
311 
312         if(user.rewardAmount != 0) {
313             uint256 amount = user.rewardAmount;
314             accounts[userAddr].rewardAmount = 0;
315 
316             /// @dev transfer the Reward Tokens from this contract.
317             emit Claim(userAddr, amount);
318             require(rewardErc.transfer(userAddr, amount), "token error" );
319         }
320     }
321 
322     /**
323      * @notice Update the reward lane value upto ths currnet moment (block)
324      * @dev This function should care the "reward velocity points," at which the
325        parameters of reward distribution are changed.
326      * @return The current (calculated) reward lane value
327      */
328     function _updateRewardLane() internal returns (uint256) {
329         /// @dev Set up memory variables used for calculation temporarily.
330         UpdateRewardLaneModel memory vars;
331 
332         vars.len = registeredPoints.length;
333         vars.memTotalDeposit = totalDeposited;
334 
335         vars.tmpPassedPoint = vars.memPassedPoint = passedPoint;
336 
337         vars.memThisBlockNum = block.number;
338         vars.tmpLastBlockNum = vars.memLastBlockNum = lastBlockNum;
339 
340         vars.tmpRewardLane = vars.memRewardLane = rewardLane;
341         vars.tmpRewardPerBlock = vars.memRewardPerBlock = rewardPerBlock;
342         vars.tmpDecrementUnitPerBlock = vars.memDecrementUnitPerBlock = decrementUnitPerBlock;
343 
344         for(uint256 i=vars.memPassedPoint; i<vars.len; i++) {
345             RewardVelocityPoint memory point = registeredPoints[i];
346 
347             /**
348              * @dev Check whether this reward velocity point is valid and has
349                not applied yet.
350              */
351             if(vars.tmpLastBlockNum < point.blockNumber && point.blockNumber <= vars.memThisBlockNum) {
352                 vars.tmpPassedPoint = i+1;
353                 /// @dev Update the reward lane with the tmp variables
354                 vars.tmpBlockDelta = safeSub(point.blockNumber, vars.tmpLastBlockNum);
355                 (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
356                 _calcNewRewardLane(
357                     vars.tmpRewardLane,
358                     vars.memTotalDeposit,
359                     vars.tmpRewardPerBlock,
360                     vars.tmpDecrementUnitPerBlock,
361                     vars.tmpBlockDelta);
362 
363                 /// @dev Update the tmp variables with this reward velocity point.
364                 vars.tmpLastBlockNum = point.blockNumber;
365                 vars.tmpRewardPerBlock = point.rewardPerBlock;
366                 vars.tmpDecrementUnitPerBlock = point.decrementUnitPerBlock;
367                 /**
368                  * @dev Notify the update of the parameters (by passing the
369                    reward velocity points)
370                  */
371                 emit UpdateRewardParams(point.blockNumber, point.rewardPerBlock, point.decrementUnitPerBlock);
372             } else {
373                 /// @dev sorted array, exit eariler without accessing future points.
374                 break;
375             }
376         }
377 
378         /**
379          * @dev Update the reward lane for the remained period between the
380            latest velocity point and this moment (block)
381          */
382         if( vars.tmpLastBlockNum < vars.memThisBlockNum ) {
383             vars.tmpBlockDelta = safeSub(vars.memThisBlockNum, vars.tmpLastBlockNum);
384             vars.tmpLastBlockNum = vars.memThisBlockNum;
385             (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
386             _calcNewRewardLane(
387                 vars.tmpRewardLane,
388                 vars.memTotalDeposit,
389                 vars.tmpRewardPerBlock,
390                 vars.tmpDecrementUnitPerBlock,
391                 vars.tmpBlockDelta);
392         }
393 
394         /**
395          * @dev Update the reward lane parameters with the tmp variables.
396          */
397         if(vars.memLastBlockNum != vars.tmpLastBlockNum) lastBlockNum = vars.tmpLastBlockNum;
398         if(vars.memPassedPoint != vars.tmpPassedPoint) passedPoint = vars.tmpPassedPoint;
399         if(vars.memRewardLane != vars.tmpRewardLane) rewardLane = vars.tmpRewardLane;
400         if(vars.memRewardPerBlock != vars.tmpRewardPerBlock) rewardPerBlock = vars.tmpRewardPerBlock;
401         if(vars.memDecrementUnitPerBlock != vars.tmpDecrementUnitPerBlock) decrementUnitPerBlock = vars.tmpDecrementUnitPerBlock;
402 
403         return vars.tmpRewardLane;
404     }
405 
406     /**
407      * @notice Calculate a new reward lane value with the given parameters
408      * @param _rewardLane The previous reward lane value
409      * @param _totalDeposit Thte total deposit amount of the Contribution Tokens
410      * @param _rewardPerBlock The reward token amount per a block
411      * @param _decrementUnitPerBlock The decerement amount of the reward token per a block
412      */
413     function _calcNewRewardLane(
414         uint256 _rewardLane,
415         uint256 _totalDeposit,
416         uint256 _rewardPerBlock,
417         uint256 _decrementUnitPerBlock,
418         uint256 delta) internal pure returns (uint256, uint256) {
419             uint256 executableDelta;
420             if(_decrementUnitPerBlock != 0) {
421                 executableDelta = safeDiv(_rewardPerBlock, _decrementUnitPerBlock);
422                 if(delta > executableDelta) delta = executableDelta;
423                 else executableDelta = 0;
424             }
425 
426             uint256 distance;
427             if(_totalDeposit != 0) {
428                 distance = expMul( _sequencePartialSumAverage(_rewardPerBlock, delta, _decrementUnitPerBlock), safeMul( expDiv(one, _totalDeposit), delta) );
429                 _rewardLane = safeAdd(_rewardLane, distance);
430             }
431 
432             if(executableDelta != 0) _rewardPerBlock = 0;
433             else _rewardPerBlock = _getNewRewardPerBlock(_rewardPerBlock, _decrementUnitPerBlock, delta);
434 
435             return (_rewardLane, _rewardPerBlock);
436     }
437 
438     /**
439      * @notice Register a new reward velocity point
440      * @dev We assume that reward velocity points are stored in order of block
441        number. Namely, registerPoints is always a sorted array.
442      * @param _blockNumber The block number for the point.
443      * @param _rewardPerBlock The reward token amount per a block
444      * @param _decrementUnitPerBlock The decerement amount of the reward token per a block
445      */
446     function _registerRewardVelocity(uint256 _blockNumber, uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) internal {
447         RewardVelocityPoint memory varPoint = RewardVelocityPoint(_blockNumber, _rewardPerBlock, _decrementUnitPerBlock);
448         emit RegisterRewardParams(_blockNumber, _rewardPerBlock, _decrementUnitPerBlock);
449         registeredPoints.push(varPoint);
450     }
451 
452     /**
453      * @notice Delete a existing reward velocity point
454      * @dev We assume that reward velocity points are stored in order of block
455        number. Namely, registerPoints is always a sorted array.
456      * @param _index The index number of deleting point in state array.
457      */
458     function _deleteRegisteredRewardVelocity(uint256 _index) internal {
459         uint256 len = registeredPoints.length;
460         require(len != 0 && _index < len, "error: no elements in registeredPoints");
461 
462         RewardVelocityPoint memory point = registeredPoints[_index];
463         emit DeleteRegisterRewardParams(_index, point.blockNumber, point.rewardPerBlock, point.decrementUnitPerBlock, len-1);
464         for(uint256 i=_index; i<len-1; i++) {
465             registeredPoints[i] = registeredPoints[i+1];
466         }
467         registeredPoints.pop();
468      }
469 
470     /**
471      * @notice Set paramaters for the reward distribution
472      * @param _rewardPerBlock The reward token amount per a block
473      * @param _decrementUnitPerBlock The decerement amount of the reward token per a block
474      */
475     function _setParams(uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) internal {
476         emit SetRewardParams(_rewardPerBlock, _decrementUnitPerBlock);
477         rewardPerBlock = _rewardPerBlock;
478         decrementUnitPerBlock = _decrementUnitPerBlock;
479     }
480 
481     /**
482      * @return the avaerage of the RewardLance of the inactive (i.e., no-action)
483        periods.
484     */
485     function _sequencePartialSumAverage(uint256 a, uint256 n, uint256 d) internal pure returns (uint256) {
486         /**
487         @dev return Sn / n,
488                 where Sn = ( (n{2*a + (n-1)d}) / 2 )
489             == ( (2na + (n-1)d) / 2 ) / n
490             caveat: use safeSub() to avoid the case that d is negative
491         */
492         if (n > 0)
493             return safeDiv(safeSub( safeMul(2,a), safeMul( safeSub(n,1), d) ), 2);
494         else
495             return 0;
496     }
497 
498     function _getNewRewardPerBlock(uint256 before, uint256 dec, uint256 delta) internal pure returns (uint256) {
499         return safeSub(before, safeMul(dec, delta));
500     }
501 
502     function _setClaimLock(bool lock) internal {
503         emit ClaimLock(lock);
504         claimLock = lock;
505     }
506 
507     function _setWithdrawLock(bool lock) internal {
508         emit WithdrawLock(lock);
509         withdrawLock = lock;
510     }
511 
512     function _ownershipTransfer(address to) internal {
513         emit OwnershipTransfer(msg.sender, to);
514         owner = to;
515     }
516 }
517 
518 // File: contracts/module/viewModule.sol
519 
520 
521 /**
522  * @title BiFi's Reward Distribution View Contract
523  * @notice Implements the view functions for support front-end
524  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
525  */
526 contract viewModule is internalModule {
527     function marketInformation(uint256 _fromBlockNumber, uint256 _toBlockNumber) external view returns (
528         uint256 rewardStartBlockNumber,
529         uint256 distributedAmount,
530         uint256 totalDeposit,
531         uint256 poolRate
532         )
533     {
534         if(rewardPerBlock == 0) rewardStartBlockNumber = registeredPoints[0].blockNumber;
535         else rewardStartBlockNumber = registeredPoints[0].blockNumber;
536 
537         distributedAmount = _redeemAllView(address(0));
538 
539         totalDeposit = totalDeposited;
540 
541         poolRate = getPoolRate(address(0), _fromBlockNumber, _toBlockNumber);
542 
543         return (
544             rewardStartBlockNumber,
545             distributedAmount,
546             totalDeposit,
547             poolRate
548         );
549     }
550 
551     function userInformation(address userAddr, uint256 _fromBlockNumber, uint256 _toBlockNumber) external view returns (
552         uint256 stakedTokenAmount,
553         uint256 rewardStartBlockNumber,
554         uint256 claimStartBlockNumber,
555         uint256 earnedTokenAmount,
556         uint256 poolRate
557         )
558     {
559         Account memory user = accounts[userAddr];
560 
561         stakedTokenAmount = user.deposited;
562 
563         if(rewardPerBlock == 0) rewardStartBlockNumber = registeredPoints[0].blockNumber;
564         else rewardStartBlockNumber = registeredPoints[0].blockNumber;
565 
566         earnedTokenAmount = _redeemAllView(userAddr);
567 
568         poolRate = getPoolRate(userAddr, _fromBlockNumber, _toBlockNumber);
569 
570         return (stakedTokenAmount, rewardStartBlockNumber, claimStartBlockNumber, earnedTokenAmount, poolRate);
571     }
572 
573     function modelInfo() external view returns (uint256, uint256, uint256, uint256, uint256) {
574         return (rewardPerBlock, decrementUnitPerBlock, rewardLane, lastBlockNum, totalDeposited);
575     }
576 
577     function getParams() external view returns (uint256, uint256, uint256, uint256) {
578         return (rewardPerBlock, rewardLane, lastBlockNum, totalDeposited);
579     }
580 
581     function getRegisteredPointLength() external view returns (uint256) {
582         return registeredPoints.length;
583     }
584 
585     function getRegisteredPoint(uint256 index) external view returns (uint256, uint256, uint256) {
586         RewardVelocityPoint memory point = registeredPoints[index];
587         return (point.blockNumber, point.rewardPerBlock, point.decrementUnitPerBlock);
588     }
589 
590     function userInfo(address userAddr) external view returns (uint256, uint256, uint256) {
591         Account memory user = accounts[userAddr];
592         uint256 earnedRewardAmount = _redeemAllView(userAddr);
593 
594         return (user.deposited, user.pointOnLane, earnedRewardAmount);
595     }
596 
597     function distributionInfo() external view returns (uint256, uint256, uint256) {
598         uint256 totalDistributedRewardAmount_now = _distributedRewardAmountView();
599         return (rewardPerBlock, decrementUnitPerBlock, totalDistributedRewardAmount_now);
600     }
601 
602     function _distributedRewardAmountView() internal view returns (uint256) {
603         return _redeemAllView( address(0) );
604     }
605 
606     function _redeemAllView(address userAddr) internal view returns (uint256) {
607         Account memory user;
608         uint256 newRewardLane;
609         if( userAddr != address(0) ) {
610             user = accounts[userAddr];
611             newRewardLane = _updateRewardLaneView(lastBlockNum);
612         } else {
613             user = Account(totalDeposited, 0, 0);
614             newRewardLane = _updateRewardLaneView(0);
615         }
616 
617         uint256 distance = safeSub(newRewardLane, user.pointOnLane);
618         uint256 rewardAmount = expMul(user.deposited, distance);
619 
620         return safeAdd(user.rewardAmount, rewardAmount);
621     }
622 
623     function _updateRewardLaneView(uint256 fromBlockNumber) internal view returns (uint256) {
624         /// @dev Set up memory variables used for calculation temporarily.
625         UpdateRewardLaneModel memory vars;
626 
627         vars.len = registeredPoints.length;
628         vars.memTotalDeposit = totalDeposited;
629 
630         if(fromBlockNumber == 0){
631             vars.tmpPassedPoint = vars.memPassedPoint = 0;
632 
633             vars.memThisBlockNum = block.number;
634             vars.tmpLastBlockNum = vars.memLastBlockNum = 0;
635             vars.tmpRewardLane = vars.memRewardLane = 0;
636             vars.tmpRewardPerBlock = vars.memRewardPerBlock = 0;
637             vars.tmpDecrementUnitPerBlock = vars.memDecrementUnitPerBlock = 0;
638         } else {
639             vars.tmpPassedPoint = vars.memPassedPoint = passedPoint;
640             vars.memThisBlockNum = block.number;
641             vars.tmpLastBlockNum = vars.memLastBlockNum = fromBlockNumber;
642 
643             vars.tmpRewardLane = vars.memRewardLane = rewardLane;
644             vars.tmpRewardPerBlock = vars.memRewardPerBlock = rewardPerBlock;
645             vars.tmpDecrementUnitPerBlock = vars.memDecrementUnitPerBlock = decrementUnitPerBlock;
646         }
647 
648         for(uint256 i=vars.memPassedPoint; i<vars.len; i++) {
649             RewardVelocityPoint memory point = registeredPoints[i];
650             /**
651              * @dev Check whether this reward velocity point is valid and has
652                not applied yet.
653              */
654             if(vars.tmpLastBlockNum < point.blockNumber && point.blockNumber <= vars.memThisBlockNum) {
655                 vars.tmpPassedPoint = i+1;
656                 /// @dev Update the reward lane with the tmp variables
657                 vars.tmpBlockDelta = safeSub(point.blockNumber, vars.tmpLastBlockNum);
658                 (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
659                 _calcNewRewardLane(
660                     vars.tmpRewardLane,
661                     vars.memTotalDeposit,
662                     vars.tmpRewardPerBlock,
663                     vars.tmpDecrementUnitPerBlock,
664                     vars.tmpBlockDelta);
665 
666                 /// @dev Update the tmp variables with this reward velocity point.
667                 vars.tmpLastBlockNum = point.blockNumber;
668                 vars.tmpRewardPerBlock = point.rewardPerBlock;
669                 vars.tmpDecrementUnitPerBlock = point.decrementUnitPerBlock;
670                 /**
671                  * @dev Notify the update of the parameters (by passing the
672                    reward velocity points)
673                  */
674             } else {
675                 /// @dev sorted array, exit eariler without accessing future points.
676                 break;
677             }
678         }
679 
680         /**
681          * @dev Update the reward lane for the remained period between the
682            latest velocity point and this moment (block)
683          */
684         if(vars.memThisBlockNum > vars.tmpLastBlockNum) {
685             vars.tmpBlockDelta = safeSub(vars.memThisBlockNum, vars.tmpLastBlockNum);
686             vars.tmpLastBlockNum = vars.memThisBlockNum;
687             (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
688             _calcNewRewardLane(
689                 vars.tmpRewardLane,
690                 vars.memTotalDeposit,
691                 vars.tmpRewardPerBlock,
692                 vars.tmpDecrementUnitPerBlock,
693                 vars.tmpBlockDelta);
694         }
695         return vars.tmpRewardLane;
696     }
697     /**
698      * @notice Get The rewardPerBlock of user in suggested period(see params)
699      * @param userAddr The Address of user, 0 for total
700      * @param fromBlockNumber calculation start block number
701      * @param toBlockNumber calculation end block number
702      * @notice this function calculate based on current contract state
703      */
704     function getPoolRate(address userAddr, uint256 fromBlockNumber, uint256 toBlockNumber) internal view returns (uint256) {
705         UpdateRewardLaneModel memory vars;
706 
707         vars.len = registeredPoints.length;
708         vars.memTotalDeposit = totalDeposited;
709 
710         vars.tmpLastBlockNum = vars.memLastBlockNum = fromBlockNumber;
711         (vars.memPassedPoint, vars.memRewardPerBlock, vars.memDecrementUnitPerBlock) = getParamsByBlockNumber(fromBlockNumber);
712         vars.tmpPassedPoint = vars.memPassedPoint;
713         vars.tmpRewardPerBlock = vars.memRewardPerBlock;
714         vars.tmpDecrementUnitPerBlock = vars.memDecrementUnitPerBlock;
715 
716         vars.memThisBlockNum = toBlockNumber;
717         vars.tmpRewardLane = vars.memRewardLane = 0;
718 
719         for(uint256 i=vars.memPassedPoint; i<vars.len; i++) {
720             RewardVelocityPoint memory point = registeredPoints[i];
721 
722             if(vars.tmpLastBlockNum < point.blockNumber && point.blockNumber <= vars.memThisBlockNum) {
723                 vars.tmpPassedPoint = i+1;
724                 vars.tmpBlockDelta = safeSub(point.blockNumber, vars.tmpLastBlockNum);
725                 (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
726                 _calcNewRewardLane(
727                     vars.tmpRewardLane,
728                     vars.memTotalDeposit,
729                     vars.tmpRewardPerBlock,
730                     vars.tmpDecrementUnitPerBlock,
731                     vars.tmpBlockDelta);
732 
733                 vars.tmpLastBlockNum = point.blockNumber;
734                 vars.tmpRewardPerBlock = point.rewardPerBlock;
735                 vars.tmpDecrementUnitPerBlock = point.decrementUnitPerBlock;
736 
737             } else {
738                 break;
739             }
740         }
741 
742         if(vars.memThisBlockNum > vars.tmpLastBlockNum) {
743             vars.tmpBlockDelta = safeSub(vars.memThisBlockNum, vars.tmpLastBlockNum);
744             vars.tmpLastBlockNum = vars.memThisBlockNum;
745             (vars.tmpRewardLane, vars.tmpRewardPerBlock) =
746             _calcNewRewardLane(
747                 vars.tmpRewardLane,
748                 vars.memTotalDeposit,
749                 vars.tmpRewardPerBlock,
750                 vars.tmpDecrementUnitPerBlock,
751                 vars.tmpBlockDelta);
752         }
753 
754         Account memory user;
755         if( userAddr != address(0) ) user = accounts[userAddr];
756         else user = Account(vars.memTotalDeposit, 0, 0);
757 
758         return safeDiv(expMul(user.deposited, vars.tmpRewardLane), safeSub(toBlockNumber, fromBlockNumber));
759     }
760 
761     function getParamsByBlockNumber(uint256 _blockNumber) internal view returns (uint256, uint256, uint256) {
762         uint256 _rewardPerBlock; uint256 _decrement;
763         uint256 i;
764 
765         uint256 tmpthisPoint;
766 
767         uint256 pointLength = registeredPoints.length;
768         if( pointLength > 0 ) {
769             for(i = 0; i < pointLength; i++) {
770                 RewardVelocityPoint memory point = registeredPoints[i];
771                 if(_blockNumber >= point.blockNumber && 0 != point.blockNumber) {
772                     tmpthisPoint = i;
773                     _rewardPerBlock = point.rewardPerBlock;
774                     _decrement = point.decrementUnitPerBlock;
775                 } else if( 0 == point.blockNumber ) continue;
776                 else break;
777             }
778         }
779         RewardVelocityPoint memory point = registeredPoints[tmpthisPoint];
780         _rewardPerBlock = point.rewardPerBlock;
781         _decrement = point.decrementUnitPerBlock;
782         if(_blockNumber > point.blockNumber) {
783             _rewardPerBlock = safeSub(_rewardPerBlock, safeMul(_decrement, safeSub(_blockNumber, point.blockNumber) ) );
784         }
785         return (i, _rewardPerBlock, _decrement);
786     }
787 
788     function getUserPoolRate(address userAddr, uint256 fromBlockNumber, uint256 toBlockNumber) external view returns (uint256) {
789         return getPoolRate(userAddr, fromBlockNumber, toBlockNumber);
790     }
791 
792     function getModelPoolRate(uint256 fromBlockNumber, uint256 toBlockNumber) external view returns (uint256) {
793         return getPoolRate(address(0), fromBlockNumber, toBlockNumber);
794     }
795 }
796 
797 // File: contracts/module/externalModule.sol
798 
799 
800 /**
801  * @title BiFi's Reward Distribution External Contract
802  * @notice Implements the service actions.
803  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
804  */
805 contract externalModule is viewModule {
806     modifier onlyOwner() {
807         require(msg.sender == owner, "onlyOwner: external function access control!");
808         _;
809     }
810     modifier checkClaimLocked() {
811         require(!claimLock, "error: claim Locked");
812         _;
813     }
814     modifier checkWithdrawLocked() {
815         require(!withdrawLock, "error: withdraw Locked");
816         _;
817     }
818 
819     /**
820      * @notice Set the Deposit-Token address
821      * @param erc20Addr The address of Deposit Token
822      */
823     function setERC(address erc20Addr) external onlyOwner {
824         lpErc = ERC20(erc20Addr);
825     }
826 
827     /**
828      * @notice Set the Contribution-Token address
829      * @param erc20Addr The address of Contribution Token
830      */
831     function setRE(address erc20Addr) external onlyOwner {
832         rewardErc = ERC20(erc20Addr);
833     }
834 
835     /**
836      * @notice Set the reward distribution parameters instantly
837      */
838     function setParam(uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) onlyOwner external {
839         _setParams(_rewardPerBlock, _decrementUnitPerBlock);
840     }
841 
842     /**
843      * @notice Terminate Contract Distribution
844      */
845     function modelFinish(uint256 amount) external onlyOwner {
846         if( amount != 0) {
847             require( rewardErc.transfer(owner, amount), "token error" );
848         }
849         else {
850             require( rewardErc.transfer(owner, rewardErc.balanceOf(address(this))), "token error" );
851         }
852         delete totalDeposited;
853         delete rewardPerBlock;
854         delete decrementUnitPerBlock;
855         delete rewardLane;
856         delete totalDeposited;
857         delete registeredPoints;
858     }
859 
860     /**
861      * @notice Transfer the Remaining Contribution Tokens
862      */
863     function retrieveRewardAmount(uint256 amount) external onlyOwner {
864         if( amount != 0) {
865             require( rewardErc.transfer(owner, amount), "token error");
866         }
867         else {
868             require( rewardErc.transfer(owner, rewardErc.balanceOf(address(this))), "token error");
869         }
870     }
871 
872     /**
873      * @notice Deposit the Contribution Tokens
874      * @param amount The amount of the Contribution Tokens
875      */
876     function deposit(uint256 amount) external {
877         address userAddr = msg.sender;
878         _redeemAll(userAddr);
879         _deposit(userAddr, amount);
880     }
881 
882     /**
883      * @notice Deposit the Contribution Tokens to target user
884      * @param userAddr The target user
885      * @param amount The amount of the Contribution Tokens
886      */
887     function depositTo(address userAddr, uint256 amount) external {
888         _redeemAll(userAddr);
889         _deposit(userAddr, amount);
890     }
891 
892     /**
893      * @notice Withdraw the Contribution Tokens
894      * @param amount The amount of the Contribution Tokens
895      */
896     function withdraw(uint256 amount) checkWithdrawLocked external {
897         address userAddr = msg.sender;
898         _redeemAll(userAddr);
899         _withdraw(userAddr, amount);
900     }
901 
902     /**
903      * @notice Claim the Reward Tokens
904      * @dev Transfer all reward the user has earned at once.
905      */
906     function rewardClaim() checkClaimLocked external {
907         address userAddr = msg.sender;
908         _redeemAll(userAddr);
909         _rewardClaim(userAddr);
910     }
911     /**
912      * @notice Claim the Reward Tokens
913      * @param userAddr The targetUser
914      * @dev Transfer all reward the target user has earned at once.
915      */
916     function rewardClaimTo(address userAddr) checkClaimLocked external {
917         _redeemAll(userAddr);
918         _rewardClaim(userAddr);
919     }
920 
921     /// @dev Set locks & access control
922     function setClaimLock(bool lock) onlyOwner external {
923         _setClaimLock(lock);
924     }
925     function setWithdrawLock(bool lock) onlyOwner external {
926         _setWithdrawLock(lock);
927     }
928     function ownershipTransfer(address to) onlyOwner external {
929         _ownershipTransfer(to);
930     }
931 
932     /**
933      * @notice Register a new future reward velocity point
934      */
935     function registerRewardVelocity(uint256 _blockNumber, uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) onlyOwner public {
936         require(_blockNumber > block.number, "new Reward params should register earlier");
937         require(registeredPoints.length == 0 || _blockNumber > registeredPoints[registeredPoints.length-1].blockNumber, "Earilier velocity points are already set.");
938         _registerRewardVelocity(_blockNumber, _rewardPerBlock, _decrementUnitPerBlock);
939     }
940     function deleteRegisteredRewardVelocity(uint256 _index) onlyOwner external {
941         require(_index >= passedPoint, "Reward velocity point already passed.");
942         _deleteRegisteredRewardVelocity(_index);
943     }
944 
945     /**
946      * @notice Set the reward distribution parameters
947      */
948     function setRewardVelocity(uint256 _rewardPerBlock, uint256 _decrementUnitPerBlock) onlyOwner external {
949         _updateRewardLane();
950         _setParams(_rewardPerBlock, _decrementUnitPerBlock);
951     }
952 }
953 
954 // File: contracts/DistributionModelV3.sol
955 
956 
957 /**
958  * @title BiFi's Reward Distribution Contract
959  * @notice Implements voting process along with vote delegation
960  * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
961  */
962 contract DistributionModelV3 is externalModule {
963     constructor(address _owner, address _lpErc, address _rewardErc) public {
964         owner = _owner;
965         lpErc = ERC20(_lpErc);
966         rewardErc = ERC20(_rewardErc);
967         lastBlockNum = block.number;
968     }
969 }
970 
971 contract BFCModel is DistributionModelV3 {
972     constructor(address _owner, address _lpErc, address _rewardErc, uint256 _start)
973     DistributionModelV3(_owner, _lpErc, _rewardErc) public {
974         /*
975         _start: parameter start block nubmer
976         0x3935413a1cdd90ff: fixed point(1e18) reward per blocks
977         0x62e9bea75f: fixed point(1e18) decrement per blocks
978         */
979         _registerRewardVelocity(_start, 0x3935413a1cdd90ff, 0x62e9bea75f);
980     }
981 }
982 
983 contract BFCETHModel is DistributionModelV3 {
984     constructor(address _owner, address _lpErc, address _rewardErc, uint256 _start)
985     DistributionModelV3(_owner, _lpErc, _rewardErc) public {
986         /*
987         _start: parameter start block nubmer
988         0xe4d505786b744b3f: fixed point(1e18) reward per blocks
989         0x18ba6fb966b: fixed point(1e18) decrement per blocks
990         */
991         _registerRewardVelocity(_start, 0xe4d505786b744b3f, 0x18ba6fb966b);
992     }
993 }
994 
995 contract BiFiETHModel is DistributionModelV3 {
996     constructor(address _owner, address _lpErc, address _rewardErc, uint256 _start)
997     DistributionModelV3(_owner, _lpErc, _rewardErc) public {
998         /*
999         _start: parameter start block nubmer
1000         0x11e0a46e285a68955: fixed point(1e18) reward per blocks
1001         0x1ee90ba90c4: fixed point(1e18) decrement per blocks
1002         */
1003         _registerRewardVelocity(_start, 0x11e0a46e285a68955, 0x1ee90ba90c4);
1004     }
1005 }