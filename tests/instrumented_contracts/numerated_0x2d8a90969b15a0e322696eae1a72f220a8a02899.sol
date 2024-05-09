1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 
6 library SafeMath {
7     
8     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
9         uint256 c = a + b;
10         if (c < a) return (false, 0);
11         return (true, c);
12     }
13     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
14         if (b > a) return (false, 0);
15         return (true, a - b);
16     }
17     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         if (a == 0) return (true, 0);
19         uint256 c = a * b;
20         if (c / a != b) return (false, 0);
21         return (true, c);
22     }
23     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         if (b == 0) return (false, 0);
25         return (true, a / b);
26     }
27     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         if (b == 0) return (false, 0);
29         return (true, a % b);
30     }
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a, "SafeMath: subtraction overflow");
38         return a - b;
39     }
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) return 0;
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b > 0, "SafeMath: division by zero");
48         return a / b;
49     }
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b > 0, "SafeMath: modulo by zero");
52         return a % b;
53     }
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         return a - b;
57     }
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         return a / b;
61     }
62     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         return a % b;
65     }
66 }
67 
68 pragma solidity >=0.4.0;
69 
70 interface IBEP20 {
71     
72     function totalSupply() external view returns (uint256);
73     function decimals() external view returns (uint8);
74     function symbol() external view returns (string memory);
75     function name() external view returns (string memory);
76     function getOwner() external view returns (address);
77     function balanceOf(address account) external view returns (uint256);
78     function transfer(address recipient, uint256 amount) external returns (bool);
79     function allowance(address _owner, address spender) external view returns (uint256);
80     function approve(address spender, uint256 amount) external returns (bool);
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 pragma solidity >=0.6.2 <0.8.0;
91 
92 
93 library Address {
94     
95     function isContract(address account) internal view returns (bool) {
96         uint256 size;
97         // solhint-disable-next-line no-inline-assembly
98         assembly { size := extcodesize(account) }
99         return size > 0;
100     }
101     function sendValue(address payable recipient, uint256 amount) internal {
102         require(address(this).balance >= amount, "Address: insufficient balance");
103 
104         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
105         (bool success, ) = recipient.call{ value: amount }("");
106         require(success, "Address: unable to send value, recipient may have reverted");
107     }
108     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
109       return functionCall(target, data, "Address: low-level call failed");
110     }
111     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, 0, errorMessage);
113     }
114     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
118         require(address(this).balance >= value, "Address: insufficient balance for call");
119         require(isContract(target), "Address: call to non-contract");
120 
121         // solhint-disable-next-line avoid-low-level-calls
122         (bool success, bytes memory returndata) = target.call{ value: value }(data);
123         return _verifyCallResult(success, returndata, errorMessage);
124     }
125     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
126         return functionStaticCall(target, data, "Address: low-level static call failed");
127     }
128     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
129         require(isContract(target), "Address: static call to non-contract");
130 
131         // solhint-disable-next-line avoid-low-level-calls
132         (bool success, bytes memory returndata) = target.staticcall(data);
133         return _verifyCallResult(success, returndata, errorMessage);
134     }
135     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
136         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
137     }
138     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
139         require(isContract(target), "Address: delegate call to non-contract");
140 
141         // solhint-disable-next-line avoid-low-level-calls
142         (bool success, bytes memory returndata) = target.delegatecall(data);
143         return _verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
147         if (success) {
148             return returndata;
149         } else {
150             if (returndata.length > 0) {
151                 // solhint-disable-next-line no-inline-assembly
152                 assembly {
153                     let returndata_size := mload(returndata)
154                     revert(add(32, returndata), returndata_size)
155                 }
156             } else {
157                 revert(errorMessage);
158             }
159         }
160     }
161 }
162 
163 pragma solidity ^0.6.0;
164 library SafeBEP20 {
165     using SafeMath for uint256;
166     using Address for address;
167 
168     function safeTransfer(
169         IBEP20 token,
170         address to,
171         uint256 value
172     ) internal {
173         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
174     }
175 
176     function safeTransferFrom(
177         IBEP20 token,
178         address from,
179         address to,
180         uint256 value
181     ) internal {
182         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
183     }
184     function safeApprove(
185         IBEP20 token,
186         address spender,
187         uint256 value
188     ) internal {
189         // solhint-disable-next-line max-line-length
190         require(
191             (value == 0) || (token.allowance(address(this), spender) == 0),
192             "SafeBEP20: approve from non-zero to non-zero allowance"
193         );
194         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
195     }
196 
197     function safeIncreaseAllowance(
198         IBEP20 token,
199         address spender,
200         uint256 value
201     ) internal {
202         uint256 newAllowance = token.allowance(address(this), spender).add(value);
203         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
204     }
205 
206     function safeDecreaseAllowance(
207         IBEP20 token,
208         address spender,
209         uint256 value
210     ) internal {
211         uint256 newAllowance = token.allowance(address(this), spender).sub(
212             value,
213             "SafeBEP20: decreased allowance below zero"
214         );
215         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
216     }
217 
218     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
219         bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
220         if (returndata.length > 0) {
221             // Return data is optional
222             // solhint-disable-next-line max-line-length
223             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
224         }
225     }
226 }
227 
228 pragma solidity >=0.6.0 <0.8.0;
229 
230 
231 abstract contract Context {
232     function _msgSender() internal view virtual returns (address payable) {
233         return msg.sender;
234     }
235 
236     function _msgData() internal view virtual returns (bytes memory) {
237         this;
238         return msg.data;
239     }
240 }
241 
242 pragma solidity >=0.6.0 <0.8.0;
243 
244 
245 abstract contract Ownable is Context {
246     address private _owner;
247 
248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249     constructor () internal {
250         address msgSender = _msgSender();
251         _owner = msgSender;
252         emit OwnershipTransferred(address(0), msgSender);
253     }
254     function owner() public view virtual returns (address) {
255         return _owner;
256     }
257     modifier onlyOwner() {
258         require(owner() == _msgSender(), "Ownable: caller is not the owner");
259         _;
260     }
261     function renounceOwnership() public virtual onlyOwner {
262         emit OwnershipTransferred(_owner, address(0));
263         _owner = address(0);
264     }
265     function transferOwnership(address newOwner) public virtual onlyOwner {
266         require(newOwner != address(0), "Ownable: new owner is the zero address");
267         emit OwnershipTransferred(_owner, newOwner);
268         _owner = newOwner;
269     }
270 }
271 
272 pragma solidity >=0.6.0 <0.8.0;
273 abstract contract ReentrancyGuard {
274     uint256 private constant _NOT_ENTERED = 1;
275     uint256 private constant _ENTERED = 2;
276 
277     uint256 private _status;
278 
279     constructor () internal {
280         _status = _NOT_ENTERED;
281     }
282     modifier nonReentrant() {
283         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
284         _status = _ENTERED;
285         _;
286         _status = _NOT_ENTERED;
287     }
288 }
289 
290 pragma solidity 0.6.12;
291 
292 contract CircleStaking is Ownable, ReentrancyGuard {
293     using SafeMath for uint256;
294     using SafeBEP20 for IBEP20;
295 
296     // Info of each user.
297     struct UserInfo {
298         uint256 amount;
299         uint256 rewardDebt;
300         uint256 rewardLockedUp;
301         uint256 nextHarvestUntil;
302         uint256 lastDepositTime;
303     }
304 
305     // Info of each pool.
306     struct PoolInfo {
307         uint256 allocPoint;
308         uint256 lastRewardBlock;
309         uint256 accTokenPerShare;
310         uint256 harvestInterval;
311         uint256 withdrawLockPeriod;
312         uint256 balance;
313         uint256 minAmount;
314     }
315 
316     IBEP20 public token;
317 
318     uint256 public tokenPerBlock;
319     PoolInfo[] public poolInfo;
320 
321     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
322 
323     uint256 public totalAllocPoint = 0;
324     uint256 public startBlock;
325     uint256 public endBlock;
326 
327     bool public emergencyWithdrawEnable = false;
328     uint256 public totalLockedUpRewards;
329 
330     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
331     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
332     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
333     event EmissionRateUpdated(address indexed caller, uint256 previousAmount, uint256 newAmount);
334     event RewardLockedUp(address indexed user, uint256 indexed pid, uint256 amountLockedUp);
335 
336     constructor(
337         IBEP20 _token,
338         uint256 _startBlock,
339         uint256 _tokenPerBlock
340     ) public {
341         token = _token;
342         startBlock = _startBlock;
343         tokenPerBlock = _tokenPerBlock;
344         token.balanceOf( address(this) );
345     }
346 
347     function poolLength() external view returns (uint256) {
348         return poolInfo.length;
349     }
350 
351     function add(uint256 _allocPoint, uint256 _harvestInterval, bool _withUpdate,
352         uint256 _withdrawLockPeriod, uint256 _minAmount) external onlyOwner {
353         require(_withdrawLockPeriod <= 500 days, "withdraw lock must be less than 500 days");
354         require(_harvestInterval <= _withdrawLockPeriod, "Harvest period period must be less than lock period");
355         if (_withUpdate) {
356             massUpdatePools();
357         }
358 
359         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
360         totalAllocPoint = totalAllocPoint.add(_allocPoint);
361         poolInfo.push(PoolInfo({
362             allocPoint: _allocPoint,
363             lastRewardBlock: lastRewardBlock,
364             accTokenPerShare: 0,
365             balance: 0,
366             harvestInterval: _harvestInterval,
367             withdrawLockPeriod: _withdrawLockPeriod,
368             minAmount: _minAmount
369         }));
370     }
371 
372     function set(uint256 _pid, uint256 _allocPoint, uint256 _harvestInterval, bool _withUpdate,
373         uint256 _withdrawLockPeriod, uint256 _minAmount) external onlyOwner {
374         require(_withdrawLockPeriod <= 500 days, "withdraw lock must be less than 500 days");
375         require(_harvestInterval <= _withdrawLockPeriod, "Harvest period period must be less than lock period");
376         if (_withUpdate) {
377             massUpdatePools();
378         }
379         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
380         poolInfo[_pid].allocPoint = _allocPoint;
381         poolInfo[_pid].harvestInterval = _harvestInterval;
382         poolInfo[_pid].withdrawLockPeriod = _withdrawLockPeriod;
383         poolInfo[_pid].minAmount = _minAmount;
384     }
385 
386     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
387         if( treasure == 0 ){
388             // if contract has no balance, stop emission.
389             return 0;
390         }
391         return _to.sub(_from);
392     }
393 
394     function pendingToken(uint256 _pid, address _user) public view returns (uint256) {
395         PoolInfo storage pool = poolInfo[_pid];
396         UserInfo storage user = userInfo[_pid][_user];
397         uint256 accTokenPerShare = pool.accTokenPerShare;
398         uint256 poolTokenBalance = pool.balance;
399         uint256 myBlock = (block.number <= endBlock ) ? block.number : endBlock;
400         if (myBlock > pool.lastRewardBlock && poolTokenBalance != 0 ) {
401             uint256 multiplier = getMultiplier(pool.lastRewardBlock, myBlock);
402             uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
403             accTokenPerShare = accTokenPerShare.add(tokenReward.mul(1e12).div(poolTokenBalance));
404         }
405         uint256 pending = user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
406         return pending.add(user.rewardLockedUp);
407     }
408 
409     function canHarvest(uint256 _pid, address _user) public view returns (bool) {
410         UserInfo storage user = userInfo[_pid][_user];
411         return block.timestamp >= user.nextHarvestUntil;
412     }
413 
414     function massUpdatePools() public {
415         uint256 length = poolInfo.length;
416         for (uint256 pid = 0; pid < length; ++pid) {
417             updatePool(pid);
418         }
419     }
420 
421     function updatePool(uint256 _pid) public {
422         PoolInfo storage pool = poolInfo[_pid];
423         uint256 myBlock = (block.number <= endBlock ) ? block.number : endBlock;
424         if (myBlock <= pool.lastRewardBlock) {
425             return;
426         }
427         uint256 poolTokenBalance = pool.balance;
428         if (poolTokenBalance == 0 || pool.allocPoint == 0) {
429             pool.lastRewardBlock = myBlock;
430             return;
431         }
432         uint256 multiplier = getMultiplier(pool.lastRewardBlock, myBlock);
433         uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
434         mint(address(this), tokenReward);
435         pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(1e12).div(poolTokenBalance));
436         pool.lastRewardBlock = myBlock;
437     }
438 
439     function minDepositMet(uint256 _pid, uint256 _amount) public view returns (bool){
440         return (_amount >= poolInfo[_pid].minAmount);
441     }
442 
443     function setMinimumDeposit(uint256 _pid, uint256 _amount) external onlyOwner {
444         poolInfo[_pid].minAmount = _amount;
445     }
446 
447     function deposit(uint256 _pid, uint256 _amount) external nonReentrant {
448         PoolInfo storage pool = poolInfo[_pid];
449         UserInfo storage user = userInfo[_pid][msg.sender];
450 
451         // allow top-ups
452         if(user.amount == 0){
453             require(minDepositMet(_pid, _amount),"Minimum deposit requirement not met");
454         }
455         
456         updatePool(_pid);
457         
458         payOrLockupPendingToken(_pid);
459         if (_amount > 0) {
460 
461             uint256 oldBalance = token.balanceOf(address(this));
462             token.safeTransferFrom(address(msg.sender), address(this), _amount);
463             uint256 newBalance = token.balanceOf(address(this));
464             _amount = newBalance.sub(oldBalance);
465 
466             pool.balance = pool.balance.add(_amount);
467 
468             user.amount = user.amount.add(_amount);
469             
470             user.lastDepositTime = block.timestamp;
471         }
472         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
473         emit Deposit(msg.sender, _pid, _amount);
474     }
475 
476     function withdraw(uint256 _pid, uint256 _amount) external nonReentrant {
477         PoolInfo storage pool = poolInfo[_pid];
478         UserInfo storage user = userInfo[_pid][msg.sender];
479         require(user.amount >= _amount, "withdraw: Amount more than balance deposited");
480         updatePool(_pid);
481         payOrLockupPendingToken(_pid);
482         if (_amount > 0) {
483             if( pool.withdrawLockPeriod > 0){
484                 bool isLocked = block.timestamp < user.lastDepositTime + pool.withdrawLockPeriod;
485                 require( isLocked == false, "withdraw still locked" );
486             }
487             user.amount = user.amount.sub(_amount);
488             pool.balance = pool.balance.sub(_amount);
489             token.safeTransfer(address(msg.sender), _amount);
490         }
491         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
492         emit Withdraw(msg.sender, _pid, _amount);
493     }
494 
495     // fetch unlock time for user
496     function getUserUnlockTime(uint256 _pid, address _user) external view returns(uint256){
497         PoolInfo storage pool = poolInfo[_pid];
498         UserInfo storage user = userInfo[_pid][_user];
499 
500         uint256 unlockTime = user.lastDepositTime + pool.withdrawLockPeriod;
501 
502         return unlockTime;
503     }
504 
505     // Withdraw without caring about rewards. EMERGENCY ONLY.
506     function emergencyWithdraw(uint256 _pid) external nonReentrant {
507         require(emergencyWithdrawEnable,"Emergency withdraw not enabled");
508         PoolInfo storage pool = poolInfo[_pid];
509         UserInfo storage user = userInfo[_pid][msg.sender];
510         uint256 amount = user.amount;
511         pool.balance = pool.balance.sub(amount);
512         user.amount = 0;
513         user.rewardDebt = 0;
514         user.rewardLockedUp = 0;
515         user.nextHarvestUntil = 0;
516         token.safeTransfer(address(msg.sender), amount);
517         emit EmergencyWithdraw(msg.sender, _pid, amount);
518     }
519 
520     function setEmergencyWithdrawEnable(bool _status) external onlyOwner {
521         emergencyWithdrawEnable = _status;
522     }
523 
524     function payOrLockupPendingToken(uint256 _pid) internal {
525         PoolInfo storage pool = poolInfo[_pid];
526         UserInfo storage user = userInfo[_pid][msg.sender];
527 
528         if (user.nextHarvestUntil == 0) {
529             user.nextHarvestUntil = block.timestamp.add(pool.harvestInterval);
530         }
531 
532         uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
533         if (canHarvest(_pid, msg.sender)) {
534             if (pending > 0 || user.rewardLockedUp > 0) {
535                 uint256 totalRewards = pending.add(user.rewardLockedUp);
536 
537                 // reset lockup
538                 totalLockedUpRewards = totalLockedUpRewards.sub(user.rewardLockedUp);
539                 user.rewardLockedUp = 0;
540                 user.nextHarvestUntil = block.timestamp.add(pool.harvestInterval);
541 
542                 // send rewards
543                 safeTokenTransfer(msg.sender, totalRewards);
544             }
545         } else if (pending > 0) {
546             user.rewardLockedUp = user.rewardLockedUp.add(pending);
547             totalLockedUpRewards = totalLockedUpRewards.add(pending);
548             emit RewardLockedUp(msg.sender, _pid, pending);
549         }
550     }
551 
552 
553     uint256 public treasure;
554     uint256 public allocated;
555     uint256 public blocks;
556     event Mint(address to,  uint256 amount);
557     
558     // Needs approval first to be done manually before adding balance
559     function addBalance(uint256 _amount, uint256 _endBlock) external onlyOwner {
560         require( _amount > 0 , "Cant add 0 tokens");
561         require( _endBlock > block.number , "end block should be greater than current block");
562 
563         uint256 oldBalance = token.balanceOf(address(this));
564         token.safeTransferFrom(msg.sender, address(this), _amount);
565         uint256 newBalance = token.balanceOf(address(this));
566         _amount = newBalance.sub(oldBalance);
567 
568         endBlock = _endBlock;
569         treasure = treasure.add(_amount);
570         blocks = _endBlock - block.number;
571         tokenPerBlock = treasure.div(blocks);
572         startBlock = block.number;
573     }
574 
575     function mint(address to,  uint256 amount ) internal {
576         if( amount > treasure ){
577             // treasure is 0, stop emission.
578             tokenPerBlock = 0;
579             amount = treasure; // last ming
580         }
581         treasure = treasure.sub(amount);
582         allocated = allocated.add(amount);
583         emit Mint(to, amount);
584     }
585 
586     // Safe token transfer function, just in case if rounding error causes pool to not have enough Tokens
587     function safeTokenTransfer(address _to, uint256 _amount) internal {
588         uint256 tokenBal = token.balanceOf(address(this));
589         if (_amount > tokenBal) {
590             token.transfer(_to, tokenBal);
591         } else {
592             token.transfer(_to, _amount);
593         }
594     }
595 
596     function getBlock() public view returns (uint256) {
597         return block.number;
598     }
599 
600     function recoverTreasure( IBEP20 recoverToken, uint256 amount) external onlyOwner {
601         require(recoverToken != token,"Cant withdraw native token");
602         require(block.number > endBlock, "can recover only farming end.");
603         recoverToken.transfer(msg.sender, amount);
604     }
605 
606 }