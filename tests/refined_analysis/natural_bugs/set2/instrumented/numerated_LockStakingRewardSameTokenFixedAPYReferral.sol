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
14 interface ILockStakingRewards {
15     function earned(address account) external view returns (uint256);
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function stake(uint256 amount) external;
19     function stakeFor(uint256 amount, address user) external;
20     function getReward() external;
21     function withdraw(uint256 nonce) external;
22     function withdrawAndGetReward(uint256 nonce) external;
23 }
24 
25 interface IBEP20Permit {
26     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
27 }
28 
29 interface INimbusReferralProgramUsers {
30     function userIdByAddress(address user) external view returns (uint);
31 }
32 
33 contract Ownable {
34     address public owner;
35     address public newOwner;
36 
37     event OwnershipTransferred(address indexed from, address indexed to);
38 
39     constructor() {
40         owner = msg.sender;
41         emit OwnershipTransferred(address(0), owner);
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner, "Ownable: Caller is not the owner");
46         _;
47     }
48 
49     function transferOwnership(address transferOwner) external onlyOwner {
50         require(transferOwner != newOwner);
51         newOwner = transferOwner;
52     }
53 
54     function acceptOwnership() virtual external {
55         require(msg.sender == newOwner);
56         emit OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58         newOwner = address(0);
59     }
60 }
61 
62 contract ReentrancyGuard {
63     /// @dev counter to allow mutex lock with only one SSTORE operation
64     uint256 private _guardCounter;
65 
66     constructor () {
67         // The counter starts at one to prevent changing it from zero to a non-zero
68         // value, which is a more expensive operation.
69         _guardCounter = 1;
70     }
71 
72     modifier nonReentrant() {
73         _guardCounter += 1;
74         uint256 localCounter = _guardCounter;
75         _;
76         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
77     }
78 }
79 
80 library Address {
81     function isContract(address account) internal view returns (bool) {
82         // This method relies in extcodesize, which returns 0 for contracts in construction, 
83         // since the code is only stored at the end of the constructor execution.
84 
85         uint256 size;
86         // solhint-disable-next-line no-inline-assembly
87         assembly { size := extcodesize(account) }
88         return size > 0;
89     }
90 }
91 
92 library SafeBEP20 {
93     using Address for address;
94 
95     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
96         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
97     }
98 
99     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
100         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
101     }
102 
103     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
104         require((value == 0) || (token.allowance(address(this), spender) == 0),
105             "SafeBEP20: approve from non-zero to non-zero allowance"
106         );
107         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
108     }
109 
110     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
111         uint256 newAllowance = token.allowance(address(this), spender) + value;
112         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
113     }
114 
115     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
116         uint256 newAllowance = token.allowance(address(this), spender) - value;
117         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
118     }
119 
120     function callOptionalReturn(IBEP20 token, bytes memory data) private {
121         require(address(token).isContract(), "SafeBEP20: call to non-contract");
122 
123         (bool success, bytes memory returndata) = address(token).call(data);
124         require(success, "SafeBEP20: low-level call failed");
125 
126         if (returndata.length > 0) { 
127             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
128         }
129     }
130 }
131 
132 contract LockStakingRewardSameTokenFixedAPYReferral is ILockStakingRewards, ReentrancyGuard, Ownable {
133     using SafeBEP20 for IBEP20;
134 
135     struct StakeInfo {
136         uint rewardRate;
137         bool isReferral;
138         uint stakeAmount;
139         uint stakeAmountRewardEquivalent;
140         uint stakeLock;
141     }
142 
143     struct StakingUserInfo {
144         uint weightedStakeDate;
145         uint balance;
146         uint balanceRewardEquivalent;
147     }
148 
149     IBEP20 public immutable token;
150     IBEP20 public immutable stakingToken; //read only variable for compatibility with other contracts
151     uint256 public rewardRate;
152     uint256 public referralRewardRate;
153     uint256 public withdrawalCashbackRate;
154     uint256 public stakingCashbackRate;
155 
156     INimbusReferralProgramUsers public referralProgramUsers;
157 
158     uint256 public immutable lockDuration; 
159     uint256 public constant rewardDuration = 365 days;
160 
161     bool public allowAccuralMarketingReward;
162     bool public onlyAllowedAddresses;
163     mapping(address => bool) allowedAddresses; 
164 
165     mapping(address => uint256) public stakeNonces;
166 
167     uint256 private _totalSupply;
168 
169     mapping(address => mapping(uint => StakeInfo)) public stakeInfo;
170     mapping(address => StakingUserInfo) public userStakingInfo;
171 
172     event RewardUpdated(uint256 reward);
173     event Staked(address indexed user, uint256 amount);
174     event Withdrawn(address indexed user, uint256 amount);
175     event RewardPaid(address indexed user, uint256 reward);
176     event Rescue(address indexed to, uint amount);
177     event RescueToken(address indexed to, address indexed token, uint amount);
178     event WithdrawalCashbackSent(address indexed to, uint withdrawnAmount, uint cashbackAmout);
179     event StakingCashbackSent(address indexed to, uint stakedAmount, uint cashbackAmout);
180     event AccuralMarketingRewardAllowanceUpdated(bool allowance);
181     event RewardRateUpdated(uint rate);
182     event ReferralRewardRateUpdated(uint rate);
183     event StakingCashbackRateUpdated(uint rate);
184     event WithdrawalCashbackRateUpdated(uint rate);
185     event OnlyAllowedAddressesUpdated(bool allowance);
186 
187     constructor(
188         address _token,
189         address _referralProgramUsers,
190         uint _rewardRate,
191         uint _referralRewardRate,
192         uint _stakingCashbackRate,
193         uint _withdrawalCashbackRate,
194         uint _lockDuration
195     ) {
196         require(Address.isContract(_token), "_token is not a contract");
197         require(Address.isContract(_referralProgramUsers), "_referralProgramUsers is not a contract");
198         require(_rewardRate > 0, "_rewardRate is equal to zero");
199         require(_referralRewardRate > 0, "_referralRewardRate is equal to zero");
200         require(_lockDuration > 0, "_lockDuration is equal to zero");
201         token = IBEP20(_token);
202         stakingToken = IBEP20(_token);
203         referralProgramUsers = INimbusReferralProgramUsers(_referralProgramUsers);
204         rewardRate = _rewardRate;
205         referralRewardRate = _referralRewardRate;
206         stakingCashbackRate = _stakingCashbackRate;
207         withdrawalCashbackRate = _withdrawalCashbackRate;
208         lockDuration = _lockDuration;
209     }
210 
211     function totalSupply() external view override returns (uint256) {
212         return _totalSupply;
213     }
214 
215     function balanceOf(address account) public view override returns (uint256) {
216         return userStakingInfo[account].balance;
217     }
218 
219     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
220         require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake 0");
221 
222         if(onlyAllowedAddresses) {
223             require(allowedAddresses[msg.sender], "LockStakingRewardMinAmountFixedAPYReferral: Only allowed addresses.");
224         }
225 
226         // permit
227         IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
228         _stake(amount, msg.sender);
229     }
230 
231     function stake(uint256 amount) external override nonReentrant {
232         require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake 0");
233 
234         if(onlyAllowedAddresses) {
235             require(allowedAddresses[msg.sender], "LockStakingRewardMinAmountFixedAPYReferral: Only allowed addresses.");
236         }
237         
238         _stake(amount, msg.sender);
239     }
240 
241     function stakeFor(uint256 amount, address user) external override nonReentrant {
242         require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake 0");
243         require(user != address(0), "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake for zero address");
244 
245         if(onlyAllowedAddresses) {
246             require(allowedAddresses[user], "LockStakingRewardMinAmountFixedAPYReferral: Only allowed addresses.");
247         }
248 
249         _stake(amount, user);
250     }
251 
252     function withdrawAndGetReward(uint256 nonce) external override {
253         getReward();
254         withdraw(nonce);
255     }
256     
257     function earned(address account) public view override returns (uint256) {
258         return (userStakingInfo[account].balanceRewardEquivalent * (block.timestamp - userStakingInfo[account].weightedStakeDate) * getRate(account)) / (100 * rewardDuration);
259     }
260 
261     function getRate(address user) public view returns(uint totalRate) {
262         uint totalStakingAmount = balanceOf(user);
263 
264         for(uint i = 0; i < stakeNonces[user]; i++) {
265             StakeInfo memory userStakeInfo = stakeInfo[user][i];
266 
267             if(userStakeInfo.stakeAmount != 0) {
268                 totalRate += userStakeInfo.rewardRate * (userStakeInfo.stakeAmount / totalStakingAmount);
269             }
270         }
271     }
272 
273     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
274     function withdraw(uint256 nonce) public override nonReentrant {
275         uint amount = stakeInfo[msg.sender][nonce].stakeAmount;
276         require(stakeInfo[msg.sender][nonce].stakeAmount > 0, "LockStakingRewardSameTokenFixedAPYReferral: This stake nonce was withdrawn");
277         require(stakeInfo[msg.sender][nonce].stakeLock < block.timestamp, "LockStakingRewardSameTokenFixedAPYReferral: Locked");
278         _totalSupply -= amount;
279         userStakingInfo[msg.sender].balance -= amount;
280         token.safeTransfer(msg.sender, amount);
281         _sendWithdrawalCashback(msg.sender, amount);
282         stakeInfo[msg.sender][nonce].stakeAmount = 0;
283         emit Withdrawn(msg.sender, amount);
284     }
285 
286     function getReward() public override nonReentrant {
287         uint256 reward = earned(msg.sender);
288         if (reward > 0) {
289             userStakingInfo[msg.sender].weightedStakeDate = block.timestamp;
290             token.safeTransfer(msg.sender, reward);
291             emit RewardPaid(msg.sender, reward);
292         }
293     }
294         
295     function getUserReferralId(address account) external view returns (uint256) {
296         require(address(referralProgramUsers) != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Referral Program was not added.");
297         return referralProgramUsers.userIdByAddress(account);
298     }
299 
300         function updateRewardAmount(uint256 reward) external onlyOwner {
301         rewardRate = reward;
302         emit RewardUpdated(reward);
303     }
304 
305     function rescue(address to, address tokenAddress, uint256 amount) external onlyOwner {
306         require(to != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue to the zero address");
307         require(amount > 0, "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue 0");
308         require(tokenAddress != address(token), "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue staking/reward token");
309 
310         IBEP20(tokenAddress).safeTransfer(to, amount);
311         emit RescueToken(to, address(tokenAddress), amount);
312     }
313 
314     function rescue(address payable to, uint256 amount) external onlyOwner {
315         require(to != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue to the zero address");
316         require(amount > 0, "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue 0");
317 
318         to.transfer(amount);
319         emit Rescue(to, amount);
320     }
321 
322     function updateOnlyAllowedAddresses(bool allowance) external onlyOwner {
323         onlyAllowedAddresses = allowance;
324         emit OnlyAllowedAddressesUpdated(onlyAllowedAddresses);
325     }
326 
327     function updateAccuralMarketingRewardAllowance(bool isAllowed) external onlyOwner {
328         allowAccuralMarketingReward = isAllowed;
329         emit AccuralMarketingRewardAllowanceUpdated(allowAccuralMarketingReward);
330     }
331 
332     function updateAllowedAddress(address _address, bool allowance) public onlyOwner {
333         require(_address != address(0), "LockStakingRewardSameTokenFixedAPYReferral: allowed address can't be equal to address(0)");
334         allowedAddresses[_address] = allowance;
335     }
336 
337     function updateAllowedAddresses(address[] memory addresses, bool[] memory allowances) external onlyOwner {
338         require(addresses.length == allowances.length, "LockStakingRewardSameTokenFixedAPYReferral: Addresses and allowances arrays have different size.");
339 
340         for(uint i = 0; i < addresses.length; i++) {
341             updateAllowedAddress(addresses[i], allowances[i]);
342         }
343     }
344 
345     function updateRewardRate(uint256 _rewardRate) external onlyOwner {
346         require(_rewardRate > 0, "LockStakingRewardSameTokenFixedAPYReferral: Reward rate must be grater than 0");
347         rewardRate = _rewardRate;
348         emit RewardRateUpdated(rewardRate);
349     }
350     
351     function updateReferralRewardRate(uint256 _referralRewardRate) external onlyOwner {
352         require(_referralRewardRate >= rewardRate, "LockStakingRewardSameTokenFixedAPYReferral: Referral reward rate can't be lower than reward rate");
353         referralRewardRate = _referralRewardRate;
354         emit ReferralRewardRateUpdated(referralRewardRate);
355     }
356     
357     function updateStakingCashbackRate(uint256 _stakingCashbackRate) external onlyOwner {
358         //Staking cahsback can be equal to 0
359         stakingCashbackRate = _stakingCashbackRate;
360         emit StakingCashbackRateUpdated(stakingCashbackRate);
361     }
362     
363     function updateWithdrawalCashbackRate(uint256 _withdrawalCashbackRate) external onlyOwner {
364         //Withdrawal cahsback can be equal to 0
365         withdrawalCashbackRate = _withdrawalCashbackRate;
366         emit WithdrawalCashbackRateUpdated(withdrawalCashbackRate);
367     }
368     
369     function updateReferralProgramUsers(address _referralProgramUsers) external onlyOwner {
370         require(_referralProgramUsers != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Referral program users address can't be equal to address(0)");
371         referralProgramUsers = INimbusReferralProgramUsers(_referralProgramUsers);
372     }
373 
374     function _stake(uint256 amount, address user) private {
375         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
376         uint id = referralProgramUsers.userIdByAddress(user);
377         bool isReferral = id != 0 ? true : false;
378         uint stakeLock = block.timestamp + lockDuration;
379         uint rate = isReferral ? referralRewardRate : rewardRate;
380         _sendStakingCashback(user, amount);
381 
382         _totalSupply += amount;
383         uint previousAmount = userStakingInfo[user].balance;
384         uint newAmount = previousAmount + amount;
385         userStakingInfo[user].weightedStakeDate = (userStakingInfo[user].weightedStakeDate * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
386         userStakingInfo[user].balance = newAmount;
387 
388         uint stakeNonce = stakeNonces[user]++;
389         stakeInfo[user][stakeNonce].rewardRate = rate;
390         stakeInfo[user][stakeNonce].isReferral = isReferral;
391         stakeInfo[user][stakeNonce].stakeAmount = amount;
392         stakeInfo[user][stakeNonce].stakeLock = stakeLock;
393         
394         stakeInfo[user][stakeNonce].stakeAmountRewardEquivalent = amount;
395         userStakingInfo[user].balanceRewardEquivalent += amount;
396         
397         emit Staked(user, amount);
398     }
399 
400     function _sendWithdrawalCashback(address account, uint _withdrawalAmount) internal {
401         if(address(referralProgramUsers) != address(0) && referralProgramUsers.userIdByAddress(account) != 0) {
402             uint256 cashbackAmount = (_withdrawalAmount * withdrawalCashbackRate) / 100;
403             token.safeTransfer(account, cashbackAmount);
404             emit WithdrawalCashbackSent(account, _withdrawalAmount, cashbackAmount);
405         }
406     }
407     
408     function _sendStakingCashback(address account, uint _stakingAmount) internal {
409         if(address(referralProgramUsers) != address(0) && referralProgramUsers.userIdByAddress(account) != 0) {
410             uint256 cashbackAmount = (_stakingAmount * stakingCashbackRate) / 100;
411             token.safeTransfer(account, cashbackAmount);
412             emit StakingCashbackSent(account, _stakingAmount, cashbackAmount);
413         }
414     }
415 }