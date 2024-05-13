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
136 contract LockStakingRewardFixedAPYReferral is ILockStakingRewards, ReentrancyGuard, Ownable {
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
155     INimbusRouter public swapRouter;
156     uint256 public rewardRate;
157     uint256 public referralRewardRate;
158     uint256 public withdrawalCashbackRate;
159     uint256 public stakingCashbackRate;
160 
161     INimbusReferralProgramUsers public referralProgramUsers;
162 
163     uint256 public immutable lockDuration; 
164     uint256 public constant rewardDuration = 365 days;
165 
166     bool public allowAccuralMarketingReward;
167     bool public onlyAllowedAddresses;
168     mapping(address => bool) public allowedAddresses;
169 
170     mapping(address => uint256) public stakeNonces;
171 
172     mapping(address => mapping(uint => StakeInfo)) public stakeInfo;
173     mapping(address => StakingUserInfo) public userStakingInfo;
174 
175     uint256 private _totalSupply;
176     uint256 private _totalSupplyRewardEquivalent;
177 
178     event RewardUpdated(uint256 reward);
179     event Staked(address indexed user, uint256 amount);
180     event Withdrawn(address indexed user, uint256 amount);
181     event RewardPaid(address indexed user, uint256 reward);
182     event Rescue(address indexed to, uint amount);
183     event RescueToken(address indexed to, address indexed token, uint amount);
184     event WithdrawalCashbackSent(address indexed to, uint withdrawnAmount, uint cashbackAmout);
185     event StakingCashbackSent(address indexed to, uint stakedAmount, uint cashbackAmout);
186     event AccuralMarketingRewardAllowanceUpdated(bool allowance);
187     event RewardRateUpdated(uint rate);
188     event ReferralRewardRateUpdated(uint rate);
189     event StakingCashbackRateUpdated(uint rate);
190     event WithdrawalCashbackRateUpdated(uint rate);
191     event OnlyAllowedAddressesUpdated(bool allowance);
192 
193     constructor(
194         address _rewardsToken,
195         address _stakingToken,
196         address _swapRouter,
197         address _referralProgramUsers,
198         uint _rewardRate,
199         uint _referralRewardRate,
200         uint _stakingCashbackRate,
201         uint _withdrawalCashbackRate,
202         uint _lockDuration
203     ) {
204         require(Address.isContract(_rewardsToken), "_rewardsToken is not a contract");
205         require(Address.isContract(_stakingToken), "_stakingToken is not a contract");
206         require(Address.isContract(_swapRouter), "_swapRouter is not a contract");
207         require(Address.isContract(_referralProgramUsers), "_referralProgramUsers is not a contract");
208         require(_rewardRate > 0, "_rewardRate is equal to zero");
209         require(_referralRewardRate > 0, "_referralRewardRate is equal to zero");
210         require(_lockDuration > 0, "_lockDuration is equal to zero");
211 
212         rewardsToken = IBEP20(_rewardsToken);
213         stakingToken = IBEP20(_stakingToken);
214         swapRouter = INimbusRouter(_swapRouter);
215         referralProgramUsers = INimbusReferralProgramUsers(_referralProgramUsers);
216         rewardRate = _rewardRate;
217         referralRewardRate = _referralRewardRate;
218         stakingCashbackRate = _stakingCashbackRate;
219         withdrawalCashbackRate = _withdrawalCashbackRate;
220         lockDuration = _lockDuration;
221     }
222 
223     function totalSupply() external view override returns (uint256) {
224         return _totalSupply;
225     }
226 
227     function totalSupplyRewardEquivalent() external view returns (uint256) {
228         return _totalSupplyRewardEquivalent;
229     }
230 
231     function balanceOf(address account) public view override returns (uint256) {
232         return userStakingInfo[account].balance;
233     }
234 
235     function getRate(address user) public view returns(uint totalRate) {
236         uint totalStakingAmount = balanceOf(user);
237 
238         for(uint i = 0; i < stakeNonces[user]; i++) {
239             StakeInfo memory userStakeInfo = stakeInfo[user][i];
240 
241             if(userStakeInfo.stakeAmount != 0) {
242                 totalRate += userStakeInfo.rewardRate * userStakeInfo.stakeAmount / totalStakingAmount;
243             }
244         }
245     }
246     
247     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
248         return userStakingInfo[account].balanceRewardEquivalent;
249     }
250 
251     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
252         require(amount > 0, "LockStakingRewardFixedAPYReferral: Cannot stake 0");
253 
254         if(onlyAllowedAddresses) {
255             require(allowedAddresses[msg.sender], "LockStakingRewardFixedAPYReferral: Only allowed addresses.");
256         }
257         
258         // permit
259         IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
260         _stake(amount, msg.sender);
261     }
262 
263     function stake(uint256 amount) external override nonReentrant {
264         require(amount > 0, "LockStakingRewardFixedAPYReferral: Cannot stake 0");
265 
266         if(onlyAllowedAddresses) {
267             require(allowedAddresses[msg.sender], "LockStakingRewardFixedAPYReferral: Only allowed addresses.");
268         }
269 
270         _stake(amount, msg.sender);
271     }
272 
273     function stakeFor(uint256 amount, address user) external override nonReentrant {
274         require(amount > 0, "LockStakingRewardFixedAPYReferral: Cannot stake 0");
275         require(user != address(0), "LockStakingRewardFixedAPYReferral: Cannot stake for zero address");
276 
277         if(onlyAllowedAddresses) {
278             require(allowedAddresses[user], "LockStakingRewardFixedAPYReferral: Only allowed addresses.");
279         }
280 
281         _stake(amount, user);
282     }
283 
284     function withdrawAndGetReward(uint256 nonce) external override {
285         getReward();
286         withdraw(nonce);
287     }
288 
289     function earned(address account) public view override returns (uint256) {
290         return (userStakingInfo[account].balanceRewardEquivalent * (block.timestamp - userStakingInfo[account].weightedStakeDate) * getRate(account)) / (100 * rewardDuration);
291     }
292 
293     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
294     function withdraw(uint256 nonce) public override nonReentrant {
295         require(stakeInfo[msg.sender][nonce].stakeAmount > 0, "LockStakingRewardFixedAPYReferral: This stake nonce was withdrawn");
296         require(stakeInfo[msg.sender][nonce].stakeLock < block.timestamp, "LockStakingRewardFixedAPYReferral: Locked");
297         uint amount = stakeInfo[msg.sender][nonce].stakeAmount;
298         uint amountRewardEquivalent = stakeInfo[msg.sender][nonce].stakeAmountRewardEquivalent;
299         _totalSupply -= amount;
300         _totalSupplyRewardEquivalent -= amountRewardEquivalent;
301         userStakingInfo[msg.sender].balance -= amount;
302         userStakingInfo[msg.sender].balanceRewardEquivalent -= amountRewardEquivalent;
303         stakingToken.safeTransfer(msg.sender, amount);
304         _sendWithdrawalCashback(msg.sender, amountRewardEquivalent);
305         stakeInfo[msg.sender][nonce].stakeAmount = 0;
306         stakeInfo[msg.sender][nonce].stakeAmountRewardEquivalent = 0;
307         emit Withdrawn(msg.sender, amount);
308     }
309 
310     function getReward() public override nonReentrant {
311         uint256 reward = earned(msg.sender);
312         if (reward > 0) {
313             userStakingInfo[msg.sender].weightedStakeDate = block.timestamp;
314             rewardsToken.safeTransfer(msg.sender, reward);
315             emit RewardPaid(msg.sender, reward);
316         }
317     }
318 
319     function getEquivalentAmount(uint amount) public view returns (uint) {
320         address[] memory path = new address[](2);
321 
322         uint equivalent;
323         if (stakingToken != rewardsToken) {
324             path[0] = address(stakingToken);            
325             path[1] = address(rewardsToken);
326             equivalent = swapRouter.getAmountsOut(amount, path)[1];
327         } else {
328             equivalent = amount;   
329         }
330         
331         return equivalent;
332     }
333 
334     function getUserReferralId(address account) external view returns (uint256 id) {
335         require(address(referralProgramUsers) != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Referral Program was not added.");
336         return referralProgramUsers.userIdByAddress(account);
337     }
338 
339     function updateAccuralMarketingRewardAllowance(bool isAllowed) external onlyOwner {
340         allowAccuralMarketingReward = isAllowed;
341         emit AccuralMarketingRewardAllowanceUpdated(allowAccuralMarketingReward);
342     }
343 
344     function updateRewardRate(uint256 _rewardRate) external onlyOwner {
345         rewardRate = _rewardRate;
346         emit RewardRateUpdated(rewardRate);
347     }
348     
349     function updateReferralRewardRate(uint256 _referralRewardRate) external onlyOwner {
350         require(_referralRewardRate >= rewardRate, "LockStakingRewardFixedAPYReferral: Referral reward rate can't be lower than reward rate");
351         referralRewardRate = _referralRewardRate;
352         emit ReferralRewardRateUpdated(referralRewardRate);
353     }
354     
355     function updateStakingCashbackRate(uint256 _stakingCashbackRate) external onlyOwner {
356         //Staking cahsback can be equal to 0
357         stakingCashbackRate = _stakingCashbackRate;
358         emit StakingCashbackRateUpdated(stakingCashbackRate);
359     }
360     
361     function updateWithdrawalCashbackRate(uint256 _withdrawalCashbackRate) external onlyOwner {
362         //Withdrawal cahsback can be equal to 0
363         withdrawalCashbackRate = _withdrawalCashbackRate;
364         emit WithdrawalCashbackRateUpdated(withdrawalCashbackRate);
365     }
366     
367     function updateReferralProgramUsers(address _referralProgramUsers) external onlyOwner {
368         require(_referralProgramUsers != address(0), "LockStakingRewardFixedAPYReferral: Referral program users address can't be equal to address(0)");
369         referralProgramUsers = INimbusReferralProgramUsers(_referralProgramUsers);
370     }
371     
372     function updateOnlyAllowedAddresses(bool allowance) external onlyOwner {
373         onlyAllowedAddresses = allowance;
374         emit OnlyAllowedAddressesUpdated(onlyAllowedAddresses);
375     }
376 
377     function updateAllowedAddress(address _address, bool allowance) public onlyOwner {
378         require(_address != address(0), "LockStakingRewardFixedAPYReferral: allowed address can't be equal to address(0)");
379         allowedAddresses[_address] = allowance;
380     }
381 
382     function updateAllowedAddresses(address[] memory addresses, bool[] memory allowances) external onlyOwner {
383         require(addresses.length == allowances.length, "LockStakingRewardFixedAPYReferral: Addresses and allowances arrays have different size.");
384 
385         for(uint i = 0; i < addresses.length; i++) {
386             updateAllowedAddress(addresses[i], allowances[i]);
387         }
388     }
389 
390     function updateRewardAmount(uint256 reward) external onlyOwner {
391         rewardRate = reward;
392         emit RewardUpdated(reward);
393     }
394 
395     function updateSwapRouter(address newSwapRouter) external onlyOwner {
396         require(newSwapRouter != address(0), "LockStakingRewardFixedAPYReferral: Address is zero");
397         swapRouter = INimbusRouter(newSwapRouter);
398     }
399 
400     function rescue(address to, address token, uint256 amount) external onlyOwner {
401         require(to != address(0), "LockStakingRewardFixedAPYReferral: Cannot rescue to the zero address");
402         require(amount > 0, "LockStakingRewardFixedAPYReferral: Cannot rescue 0");
403         require(token != address(stakingToken), "LockStakingRewardFixedAPYReferral: Cannot rescue staking token");
404         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
405 
406         IBEP20(token).safeTransfer(to, amount);
407         emit RescueToken(to, address(token), amount);
408     }
409 
410     function rescue(address payable to, uint256 amount) external onlyOwner {
411         require(to != address(0), "LockStakingRewardFixedAPYReferral: Cannot rescue to the zero address");
412         require(amount > 0, "LockStakingRewardFixedAPYReferral: Cannot rescue 0");
413 
414         to.transfer(amount);
415         emit Rescue(to, amount);
416     }
417     
418     function _sendWithdrawalCashback(address _account, uint _withdrawalAmount) internal {
419         if(address(referralProgramUsers) != address(0) && referralProgramUsers.userIdByAddress(_account) != 0) {
420             uint256 cashbackAmount = (_withdrawalAmount * withdrawalCashbackRate) / 100;
421             rewardsToken.safeTransfer(_account, cashbackAmount);
422             emit WithdrawalCashbackSent(_account, _withdrawalAmount, cashbackAmount);
423         }
424     }
425     
426     function _sendStakingCashback(address _account, uint _stakingAmount) internal {
427         if(address(referralProgramUsers) != address(0) && referralProgramUsers.userIdByAddress(_account) != 0) {
428             uint256 cashbackAmount = (_stakingAmount * stakingCashbackRate) / 100;
429             rewardsToken.safeTransfer(_account, cashbackAmount);
430             emit StakingCashbackSent(_account, _stakingAmount, cashbackAmount);
431         }
432     }
433 
434     function _stake(uint256 amount, address user) private {
435         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
436         uint id = referralProgramUsers.userIdByAddress(user);
437         bool isReferral = id != 0 ? true : false;
438         uint stakeLock = block.timestamp + lockDuration;
439         uint rate = isReferral ? referralRewardRate : rewardRate;
440         uint amountRewardEquivalent = getEquivalentAmount(amount);      
441         _sendStakingCashback(user, amountRewardEquivalent);
442         _totalSupply += amount;
443         _totalSupplyRewardEquivalent += amountRewardEquivalent;
444         uint previousAmount = userStakingInfo[user].balance;
445         uint newAmount = previousAmount + amount;
446         userStakingInfo[user].weightedStakeDate = userStakingInfo[user].weightedStakeDate * previousAmount / newAmount + block.timestamp * amount / newAmount;
447         userStakingInfo[user].balance = newAmount;
448 
449         uint stakeNonce = stakeNonces[user]++;
450         stakeInfo[user][stakeNonce].rewardRate = rate;
451         stakeInfo[user][stakeNonce].isReferral = isReferral;
452         stakeInfo[user][stakeNonce].stakeAmount = amount;
453         stakeInfo[user][stakeNonce].stakeLock = stakeLock;
454         
455         stakeInfo[user][stakeNonce].stakeAmountRewardEquivalent = amountRewardEquivalent;
456         userStakingInfo[user].balanceRewardEquivalent += amountRewardEquivalent;
457         
458         emit Staked(user, amount);
459     }
460 }