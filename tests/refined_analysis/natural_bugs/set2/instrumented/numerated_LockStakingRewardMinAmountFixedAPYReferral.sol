1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 interface INimbusRouter {
15     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
16 }
17 
18 interface ILockStakingRewards {
19     function earned(address account) external view returns (uint256);
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function stake(uint256 amount) external;
23     function stakeFor(uint256 amount, address user) external;
24     function getReward() external;
25     function withdraw(uint256 nonce) external;
26     function withdrawAndGetReward(uint256 nonce) external;
27 }
28 
29 interface IBEP20Permit {
30     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
31 }
32 
33 interface INimbusReferralProgramUsers {
34     function userIdByAddress(address user) external view returns (uint);
35 }
36 
37 contract Ownable {
38     address public owner;
39     address public newOwner;
40 
41     event OwnershipTransferred(address indexed from, address indexed to);
42 
43     constructor() {
44         owner = msg.sender;
45         emit OwnershipTransferred(address(0), owner);
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner, "Ownable: Caller is not the owner");
50         _;
51     }
52 
53     function transferOwnership(address transferOwner) external onlyOwner {
54         require(transferOwner != newOwner);
55         newOwner = transferOwner;
56     }
57 
58     function acceptOwnership() virtual external {
59         require(msg.sender == newOwner);
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62         newOwner = address(0);
63     }
64 }
65 
66 contract ReentrancyGuard {
67     /// @dev counter to allow mutex lock with only one SSTORE operation
68     uint256 private _guardCounter;
69 
70     constructor () {
71         // The counter starts at one to prevent changing it from zero to a non-zero
72         // value, which is a more expensive operation.
73         _guardCounter = 1;
74     }
75 
76     modifier nonReentrant() {
77         _guardCounter += 1;
78         uint256 localCounter = _guardCounter;
79         _;
80         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
81     }
82 }
83 
84 library Address {
85     function isContract(address account) internal view returns (bool) {
86         // This method relies in extcodesize, which returns 0 for contracts in construction, 
87         // since the code is only stored at the end of the constructor execution.
88 
89         uint256 size;
90         // solhint-disable-next-line no-inline-assembly
91         assembly { size := extcodesize(account) }
92         return size > 0;
93     }
94 }
95 
96 library SafeBEP20 {
97     using Address for address;
98 
99     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
100         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
101     }
102 
103     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
104         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
105     }
106 
107     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
108         require((value == 0) || (token.allowance(address(this), spender) == 0),
109             "SafeBEP20: approve from non-zero to non-zero allowance"
110         );
111         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
112     }
113 
114     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
115         uint256 newAllowance = token.allowance(address(this), spender) + value;
116         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
117     }
118 
119     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
120         uint256 newAllowance = token.allowance(address(this), spender) - value;
121         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
122     }
123 
124     function callOptionalReturn(IBEP20 token, bytes memory data) private {
125         require(address(token).isContract(), "SafeBEP20: call to non-contract");
126 
127         (bool success, bytes memory returndata) = address(token).call(data);
128         require(success, "SafeBEP20: low-level call failed");
129 
130         if (returndata.length > 0) { 
131             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
132         }
133     }
134 }
135 
136 contract LockStakingRewardMinAmountFixedAPYReferral is ILockStakingRewards, ReentrancyGuard, Ownable {
137     using SafeBEP20 for IBEP20;
138 
139     struct StakeInfo {
140         uint rewardRate;
141         bool isReferral;
142         uint stakeAmount;
143         uint stakeAmountRewardEquivalent;
144         uint stakeLock;
145     }
146 
147     struct StakingUserInfo {
148         uint weightedStakeDate;
149         uint balance;
150         uint balanceRewardEquivalent;
151     }
152 
153     IBEP20 public immutable rewardsToken;
154     IBEP20 public immutable stakingToken;
155     uint256 public rewardRate;
156     uint256 public referralRewardRate;
157     uint256 public withdrawalCashbackRate;
158     uint256 public stakingCashbackRate;
159     uint256 public immutable lockDuration; 
160     uint256 public constant rewardDuration = 365 days; 
161     
162     INimbusReferralProgramUsers public referralProgramUsers;
163      
164     INimbusRouter public swapRouter;
165     address public swapToken;                       
166     uint public swapTokenAmountThresholdForStaking;
167 
168     bool public allowAccuralMarketingReward;
169     bool public onlyAllowedAddresses;
170     mapping(address => bool) public allowedAddresses;
171 
172     mapping(address => uint256) public stakeNonces;
173 
174     mapping(address => mapping(uint => StakeInfo)) public stakeInfo;
175     mapping(address => StakingUserInfo) public userStakingInfo;
176 
177     uint256 private _totalSupply;
178     uint256 private _totalSupplyRewardEquivalent;
179 
180     event RewardUpdated(uint256 reward);
181     event Staked(address indexed user, uint256 amount);
182     event Withdrawn(address indexed user, uint256 amount);
183     event RewardPaid(address indexed user, uint256 reward);
184     event Rescue(address indexed to, uint amount);
185     event RescueToken(address indexed to, address indexed token, uint amount);
186     event WithdrawalCashbackSent(address indexed to, uint withdrawnAmount, uint cashbackAmout);
187     event StakingCashbackSent(address indexed to, uint stakedAmount, uint cashbackAmout);
188     event AccuralMarketingRewardAllowanceUpdated(bool allowance);
189     event RewardRateUpdated(uint rate);
190     event ReferralRewardRateUpdated(uint rate);
191     event StakingCashbackRateUpdated(uint rate);
192     event WithdrawalCashbackRateUpdated(uint rate);
193     event OnlyAllowedAddressesUpdated(bool allowance);
194     event StakeSwapTokenAmountTresholdUpdated(uint treshold);
195 
196     constructor(
197         address _rewardsToken,
198         address _stakingToken,
199         address _referralProgramUsers,
200         uint _rewardRate,
201         uint _referralRewardRate,
202         uint _stakingCashbackRate,
203         uint _withdrawalCashbackRate,
204         uint _lockDuration,
205         address _swapRouter,
206         address _swapToken,
207         uint _swapTokenAmount
208     ) {
209         require(Address.isContract(_rewardsToken), "_rewardsToken is not a contract");
210         require(Address.isContract(_stakingToken), "_stakingToken is not a contract");
211         require(Address.isContract(_swapRouter), "_swapRouter is not a contract");
212         require(Address.isContract(_referralProgramUsers), "_referralProgramUsers is not a contract");
213         require(Address.isContract(_swapToken), "_swapToken is not a contract");
214         require(_rewardRate >= 0, "_rewardRate is lower or equal to zero");
215         require(_referralRewardRate >= 0, "_referralRewardRate is lower or equal to zero");
216         require(_lockDuration >= 0, "_lockDuration is lower or equal to zero");
217         require(_swapTokenAmount > 0, "_swapTokenAmount is lower than zero");
218 
219         rewardsToken = IBEP20(_rewardsToken);
220         stakingToken = IBEP20(_stakingToken);
221         referralProgramUsers = INimbusReferralProgramUsers(_referralProgramUsers);
222         rewardRate = _rewardRate;
223         referralRewardRate = _referralRewardRate;
224         stakingCashbackRate = _stakingCashbackRate;
225         withdrawalCashbackRate = _withdrawalCashbackRate;
226         lockDuration = _lockDuration;
227         swapRouter = INimbusRouter(_swapRouter);
228         swapToken = _swapToken;
229         swapTokenAmountThresholdForStaking = _swapTokenAmount;
230     }
231 
232     function totalSupply() external view override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     function totalSupplyRewardEquivalent() external view returns (uint256) {
237         return _totalSupplyRewardEquivalent;
238     }
239 
240     function balanceOf(address account) public view override returns (uint256) {
241         return userStakingInfo[account].balance;
242     }
243     
244     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
245         return userStakingInfo[account].balanceRewardEquivalent;
246     }
247 
248     function earned(address account) public view override returns (uint256) {
249         return (userStakingInfo[account].balanceRewardEquivalent * (block.timestamp - userStakingInfo[account].weightedStakeDate) * getRate(account)) / (100 * rewardDuration);
250     }
251 
252     function getRate(address user) public view returns(uint totalRate) {
253         uint totalStakingAmount = balanceOf(user);
254 
255         for(uint i = 0; i < stakeNonces[user]; i++) {
256             StakeInfo memory userStakeInfo = stakeInfo[user][i];
257 
258             if(userStakeInfo.stakeAmount != 0) {
259                 totalRate += userStakeInfo.rewardRate * userStakeInfo.stakeAmount / totalStakingAmount;
260             }
261         }
262     }
263 
264     function isAmountMeetsMinThreshold(uint amount) public view returns (bool) {
265         address[] memory path = new address[](2);
266         path[0] = address(stakingToken);
267         path[1] = swapToken;
268         uint tokenAmount = swapRouter.getAmountsOut(amount, path)[1];
269         return tokenAmount >= swapTokenAmountThresholdForStaking;
270     }
271 
272     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
273         require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake 0");
274 
275         if(onlyAllowedAddresses) {
276             require(allowedAddresses[msg.sender], "LockStakingRewardMinAmountFixedAPYReferral: Only allowed addresses.");
277         }
278 
279         // permit
280         IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
281         _stake(amount, msg.sender);
282     }
283 
284     function stake(uint256 amount) external override nonReentrant {
285         require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake 0");
286 
287         if(onlyAllowedAddresses) {
288             require(allowedAddresses[msg.sender], "LockStakingRewardMinAmountFixedAPYReferral: Only allowed addresses.");
289         }
290         
291         _stake(amount, msg.sender);
292     }
293 
294     function stakeFor(uint256 amount, address user) external override nonReentrant {
295         require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake 0");
296         require(user != address(0), "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake for zero address");
297 
298         if(onlyAllowedAddresses) {
299             require(allowedAddresses[user], "LockStakingRewardMinAmountFixedAPYReferral: Only allowed addresses.");
300         }
301 
302         _stake(amount, user);
303     }
304 
305     function _stake(uint256 amount, address user) private {
306         require(isAmountMeetsMinThreshold(amount), "LockStakingRewardMinAmountFixedAPYReferral: Amount is less than min stake");
307         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
308         uint id = referralProgramUsers.userIdByAddress(user);
309         bool isReferral = id != 0 ? true : false;
310         uint stakeLock = block.timestamp + lockDuration;
311         uint rate = isReferral ? referralRewardRate : rewardRate;
312         uint amountRewardEquivalent = getEquivalentAmount(amount);
313         _sendStakingCashback(user, amountRewardEquivalent);
314 
315         _totalSupply += amount;
316         _totalSupplyRewardEquivalent += amountRewardEquivalent;
317         uint previousAmount = userStakingInfo[user].balance;
318         uint newAmount = previousAmount + amount;
319         userStakingInfo[user].weightedStakeDate = (userStakingInfo[user].weightedStakeDate * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
320         userStakingInfo[user].balance = newAmount;
321 
322         uint stakeNonce = stakeNonces[user]++;
323         stakeInfo[user][stakeNonce].rewardRate = rate;
324         stakeInfo[user][stakeNonce].isReferral = isReferral;
325         stakeInfo[user][stakeNonce].stakeAmount = amount;
326         stakeInfo[user][stakeNonce].stakeLock = stakeLock;
327         
328         stakeInfo[user][stakeNonce].stakeAmountRewardEquivalent = amountRewardEquivalent;
329         userStakingInfo[user].balanceRewardEquivalent += amountRewardEquivalent;
330 
331         emit Staked(user, amount);
332     }
333 
334 
335     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
336     function withdraw(uint256 nonce) public override nonReentrant {
337         require(stakeInfo[msg.sender][nonce].stakeAmount > 0, "LockStakingRewardMinAmountFixedAPYReferral: This stake nonce was withdrawn");
338         require(stakeInfo[msg.sender][nonce].stakeLock < block.timestamp, "LockStakingRewardMinAmountFixedAPYReferral: Locked");
339         uint amount = stakeInfo[msg.sender][nonce].stakeAmount;
340         uint amountRewardEquivalent = stakeInfo[msg.sender][nonce].stakeAmountRewardEquivalent;
341         _totalSupply -= amount;
342         _totalSupplyRewardEquivalent -= amountRewardEquivalent;
343         userStakingInfo[msg.sender].balance -= amount;
344         userStakingInfo[msg.sender].balanceRewardEquivalent -= amountRewardEquivalent;
345         stakingToken.safeTransfer(msg.sender, amount);
346         _sendWithdrawalCashback(msg.sender, amountRewardEquivalent);
347         stakeInfo[msg.sender][nonce].stakeAmount = 0;
348         stakeInfo[msg.sender][nonce].stakeAmountRewardEquivalent = 0;
349         emit Withdrawn(msg.sender, amount);
350     }
351 
352     function getReward() public override nonReentrant {
353         uint256 reward = earned(msg.sender);
354         if (reward > 0) {
355             userStakingInfo[msg.sender].weightedStakeDate = block.timestamp;
356             rewardsToken.safeTransfer(msg.sender, reward);
357             emit RewardPaid(msg.sender, reward);
358         }
359     }
360 
361     function withdrawAndGetReward(uint256 nonce) external override {
362         getReward();
363         withdraw(nonce);
364     }
365 
366     function getEquivalentAmount(uint amount) public view returns (uint) {
367         address[] memory path = new address[](2);
368 
369         uint equivalent;
370         if (stakingToken != rewardsToken) {
371             path[0] = address(stakingToken);            
372             path[1] = address(rewardsToken);
373             equivalent = swapRouter.getAmountsOut(amount, path)[1];
374         } else {
375             equivalent = amount;   
376         }
377         
378         return equivalent;
379     }
380 
381     function getUserReferralId(address account) external view returns (uint256 id) {
382         require(address(referralProgramUsers) != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Referral Program was not added.");
383         return referralProgramUsers.userIdByAddress(account);
384     }
385 
386     function updateOnlyAllowedAddresses(bool allowance) external onlyOwner {
387         onlyAllowedAddresses = allowance;
388         emit OnlyAllowedAddressesUpdated(onlyAllowedAddresses);
389     }
390 
391     function updateAccuralMarketingRewardAllowance(bool isAllowed) external onlyOwner {
392         allowAccuralMarketingReward = isAllowed;
393         emit AccuralMarketingRewardAllowanceUpdated(allowAccuralMarketingReward);
394     }
395 
396     function updateAllowedAddress(address _address, bool allowance) public onlyOwner {
397         require(_address != address(0), "LockStakingRewardMinAmountFixedAPYReferral: allowed address can't be equal to address(0)");
398         allowedAddresses[_address] = allowance;
399     }
400 
401     function updateAllowedAddresses(address[] memory addresses, bool[] memory allowances) external onlyOwner {
402         require(addresses.length == allowances.length, "LockStakingRewardMinAmountFixedAPYReferral: Addresses and allowances arrays have different size.");
403 
404         for(uint i = 0; i < addresses.length; i++) {
405             updateAllowedAddress(addresses[i], allowances[i]);
406         }
407     }
408 
409     function updateRewardAmount(uint256 reward) external onlyOwner {
410         rewardRate = reward;
411         emit RewardUpdated(reward);
412     }
413 
414     function updateSwapRouter(address newSwapRouter) external onlyOwner {
415         require(newSwapRouter != address(0), "LockStakingRewardMinAmountFixedAPYReferral: Address is zero");
416         swapRouter = INimbusRouter(newSwapRouter);
417     }
418 
419     function updateSwapToken(address newSwapToken) external onlyOwner {
420         require(newSwapToken != address(0), "LockStakingRewardMinAmountFixedAPYReferral: Address is zero");
421         swapToken = newSwapToken;
422     }
423 
424     function updateStakeSwapTokenAmountThreshold(uint threshold) external onlyOwner {
425         swapTokenAmountThresholdForStaking = threshold;
426         emit StakeSwapTokenAmountTresholdUpdated(swapTokenAmountThresholdForStaking);
427     }
428 
429     function updateRewardRate(uint256 _rewardRate) external onlyOwner {
430         require(_rewardRate > 0, "LockStakingRewardFixedAPYReferral: Reward rate must be grater than 0");
431         rewardRate = _rewardRate;
432         emit RewardRateUpdated(rewardRate);
433     }
434     
435     function updateReferralRewardRate(uint256 _referralRewardRate) external onlyOwner {
436         require(_referralRewardRate >= rewardRate, "LockStakingRewardMinAmountFixedAPYReferral: Referral reward rate can't be lower than reward rate");
437         referralRewardRate = _referralRewardRate;
438         emit ReferralRewardRateUpdated(referralRewardRate);
439     }
440     
441     function updateStakingCashbackRate(uint256 _stakingCashbackRate) external onlyOwner {
442         //Staking cahsback can be equal to 0
443         stakingCashbackRate = _stakingCashbackRate;
444         emit StakingCashbackRateUpdated(stakingCashbackRate);
445     }
446     
447     function updateWithdrawalCashbackRate(uint256 _withdrawalCashbackRate) external onlyOwner {
448         //Withdrawal cahsback can be equal to 0
449         withdrawalCashbackRate = _withdrawalCashbackRate;
450         emit WithdrawalCashbackRateUpdated(withdrawalCashbackRate);
451     }
452     
453     function updateReferralProgramUsers(address _referralProgramUsers) external onlyOwner {
454         require(_referralProgramUsers != address(0), "LockStakingRewardMinAmountFixedAPYReferral: Referral program users address can't be equal to address(0)");
455         referralProgramUsers = INimbusReferralProgramUsers(_referralProgramUsers);
456     }
457 
458     function rescue(address to, address token, uint256 amount) external onlyOwner {
459         require(to != address(0), "LockStakingRewardMinAmountFixedAPYReferral: Cannot rescue to the zero address");
460         require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot rescue 0");
461         require(token != address(stakingToken), "LockStakingRewardMinAmountFixedAPYReferral: Cannot rescue staking token");
462         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
463 
464         IBEP20(token).safeTransfer(to, amount);
465         emit RescueToken(to, address(token), amount);
466     }
467 
468     function rescue(address payable to, uint256 amount) external onlyOwner {
469         require(to != address(0), "LockStakingRewardMinAmountFixedAPYReferral: Cannot rescue to the zero address");
470         require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot rescue 0");
471 
472         to.transfer(amount);
473         emit Rescue(to, amount);
474     }
475 
476     function _sendWithdrawalCashback(address account, uint _withdrawalAmount) internal {
477         if(address(referralProgramUsers) != address(0) && referralProgramUsers.userIdByAddress(account) != 0) {
478             uint256 cashbackAmount = (_withdrawalAmount * withdrawalCashbackRate) / 100;
479             rewardsToken.safeTransfer(account, cashbackAmount);
480             emit WithdrawalCashbackSent(account, _withdrawalAmount, cashbackAmount);
481         }
482     }
483     
484     function _sendStakingCashback(address account, uint _stakingAmount) internal {
485         if(address(referralProgramUsers) != address(0) && referralProgramUsers.userIdByAddress(account) != 0) {
486             uint256 cashbackAmount = (_stakingAmount * stakingCashbackRate) / 100;
487             rewardsToken.safeTransfer(account, cashbackAmount);
488             emit StakingCashbackSent(account, _stakingAmount, cashbackAmount);
489         }
490     }
491 }