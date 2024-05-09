1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-30
3 */
4 
5 pragma solidity 0.4.25;
6 
7 /**
8  * token contract functions
9 */
10 contract Ierc20 {
11     function balanceOf(address who) external view returns (uint256);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function transfer(address to, uint256 value) external returns (bool);
14     function approve(address spender, uint256 value) external returns (bool);
15     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
16     function transferFrom(address from, address to, uint256 value) external returns (bool);
17 }
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     require(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     require(c >= a);
42     return c;
43   }
44 
45   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
46     uint256 c = add(a,m);
47     uint256 d = sub(c,1);
48     return mul(div(d,m),m);
49   }
50 }
51 
52 contract Owned {
53         address public owner;
54         event OwnerChanges(address newOwner);
55         
56         constructor() public {
57             owner = msg.sender;
58         }
59 
60         modifier onlyOwner {
61             require(msg.sender == owner);
62             _;
63         }
64 
65         function transferOwnership(address newOwner) onlyOwner external {
66             require(newOwner != address(0), "New owner is the zero address");
67             owner = newOwner;
68             emit OwnerChanges(newOwner);
69         }
70 }
71 
72 contract StakingPool is Owned {
73     using SafeMath for uint256;
74     
75     Ierc20 public tswap;
76     Ierc20 public rewardToken;
77     uint256 poolDuration;
78     uint256 totalRewards;
79     uint256 rewardsWithdrawn;
80     uint256 poolStartTime;
81     uint256 poolEndTime;
82     uint256 totalStaked;
83     // Represents a single stake for a user. A user may have multiple.
84     struct Stake {
85         uint256 amount;
86         uint256 stakingTime;
87         uint256 lastWithdrawTime;
88     }
89     mapping (address => Stake[]) public userStaking;
90     
91     // Represents total staking of an user
92     struct UserTotals {
93         uint256 totalStaking;
94         uint256 totalStakingTIme;
95     }
96     mapping (address => UserTotals) public userTotalStaking;
97     
98     struct Ris3Rewards {
99         uint256 totalWithdrawn;
100         uint256 lastWithdrawTime;
101     }
102     mapping(address => Ris3Rewards) public userRewardInfo;
103     
104     event OwnerSetReward(uint256 amount);
105     event Staked(address userAddress, uint256 amount);
106     event StakingWithdrawal(address userAddress, uint256 amount);
107     event RewardWithdrawal(address userAddress, uint256 amount);
108     event PoolDurationChange(uint256 poolDuration);
109     
110     /**
111      * Constrctor function
112     */
113     constructor() public {
114         tswap = Ierc20(0xCC4304A31d09258b0029eA7FE63d032f52e44EFe);
115         rewardToken = Ierc20(0x8D717AB5eaC1016b64C2A7fD04720Fd2D27D1B86);
116         poolDuration = 720 hours;
117     }
118     
119     //Set pool rewards
120     function ownerSetPoolRewards(uint256 _rewardAmount) external onlyOwner {
121         require(poolStartTime == 0, "Pool rewards already set");
122         require(_rewardAmount > 0, "Cannot create pool with zero amount");
123         
124         //set total rewards value
125         totalRewards = _rewardAmount;
126         
127         poolStartTime = now;
128         poolEndTime = now + poolDuration;
129         
130         //transfer tokens to contract
131         rewardToken.transferFrom(msg.sender, this, _rewardAmount);
132         emit OwnerSetReward(_rewardAmount);
133     }
134     
135     //Stake function for users to stake SWAP token
136     function stake(uint256 amount) external {
137         require(amount > 0, "Cannot stake 0");
138         require(now < poolEndTime, "Staking pool is closed"); //staking pool is closed for staking
139         
140         //add value in staking
141         userTotalStaking[msg.sender].totalStaking = userTotalStaking[msg.sender].totalStaking.add(amount);
142         
143         //add new stake
144         Stake memory newStake = Stake(amount, now, 0);
145         userStaking[msg.sender].push(newStake);
146         
147         //add to total staked
148         totalStaked = totalStaked.add(amount);
149         
150         tswap.transferFrom(msg.sender, this, amount);
151         emit Staked(msg.sender, amount);
152     }
153     
154     //compute rewards
155     function computeNewReward(uint256 _rewardAmount, uint256 _stakedAmount, uint256 _stakeTimeSec) private view returns (uint256 _reward) {
156         uint256 rewardPerSecond = totalRewards.mul(1 ether);
157         if (rewardPerSecond != 0 ) {
158             rewardPerSecond = rewardPerSecond.div(poolDuration);
159         }
160         
161         if (rewardPerSecond > 0) {
162             uint256 rewardPerSecForEachTokenStaked = rewardPerSecond.div(totalStaked);
163             uint256 userRewards = rewardPerSecForEachTokenStaked.mul(_stakedAmount).mul(_stakeTimeSec);
164                     userRewards = userRewards.div(1 ether);
165             
166             return _rewardAmount.add(userRewards);
167         } else {
168             return 0;
169         }
170     }
171     
172     //calculate your rewards
173     function calculateReward(address _userAddress) public view returns (uint256 _reward) {
174         // all user stakes
175         Stake[] storage accountStakes = userStaking[_userAddress];
176         
177         // Redeem from most recent stake and go backwards in time.
178         uint256 rewardAmount = 0;
179         uint256 i = accountStakes.length;
180         while (i > 0) {
181             Stake storage userStake = accountStakes[i - 1];
182             uint256 stakeTimeSec;
183             
184             //check if current time is more than pool ending time
185             if (now > poolEndTime) {
186                 stakeTimeSec = poolEndTime.sub(userStake.stakingTime);
187                 if(userStake.lastWithdrawTime != 0){
188                     stakeTimeSec = poolEndTime.sub(userStake.lastWithdrawTime);
189                 }
190             } else {
191                 stakeTimeSec = now.sub(userStake.stakingTime);
192                 if(userStake.lastWithdrawTime != 0){
193                     stakeTimeSec = now.sub(userStake.lastWithdrawTime);
194                 }
195             }
196             
197             // fully redeem a past stake
198             rewardAmount = computeNewReward(rewardAmount, userStake.amount, stakeTimeSec);
199             i--;
200         }
201         
202         return rewardAmount;
203     }
204     
205     //Withdraw staking and rewards
206     function withdrawStaking(uint256 amount) external {
207         require(amount > 0, "Amount can not be zero");
208         require(userTotalStaking[msg.sender].totalStaking >= amount, "You are trying to withdaw more than your stake");
209         
210         // 1. User Accounting
211         Stake[] storage accountStakes = userStaking[msg.sender];
212         
213         // Redeem from most recent stake and go backwards in time.
214         uint256 sharesLeftToBurn = amount;
215         uint256 rewardAmount = 0;
216         while (sharesLeftToBurn > 0) {
217             Stake storage lastStake = accountStakes[accountStakes.length - 1];
218             uint256 stakeTimeSec;
219             //check if current time is more than pool ending time
220             if (now > poolEndTime) {
221                 stakeTimeSec = poolEndTime.sub(lastStake.stakingTime);
222                 if(lastStake.lastWithdrawTime != 0){
223                     stakeTimeSec = poolEndTime.sub(lastStake.lastWithdrawTime);
224                 }
225             } else {
226                 stakeTimeSec = now.sub(lastStake.stakingTime);
227                 if(lastStake.lastWithdrawTime != 0){
228                     stakeTimeSec = now.sub(lastStake.lastWithdrawTime);
229                 }
230             }
231             
232             if (lastStake.amount <= sharesLeftToBurn) {
233                 // fully redeem a past stake
234                 rewardAmount = computeNewReward(rewardAmount, lastStake.amount, stakeTimeSec);
235                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.amount);
236                 accountStakes.length--;
237             } else {
238                 // partially redeem a past stake
239                 rewardAmount = computeNewReward(rewardAmount, sharesLeftToBurn, stakeTimeSec);
240                 lastStake.amount = lastStake.amount.sub(sharesLeftToBurn);
241                 lastStake.lastWithdrawTime = now;
242                 sharesLeftToBurn = 0;
243             }
244         }
245         
246         //substract value in staking
247         userTotalStaking[msg.sender].totalStaking = userTotalStaking[msg.sender].totalStaking.sub(amount);
248         
249         //substract from total staked
250         totalStaked = totalStaked.sub(amount);
251         
252         //update user rewards info
253         userRewardInfo[msg.sender].totalWithdrawn = userRewardInfo[msg.sender].totalWithdrawn.add(rewardAmount);
254         userRewardInfo[msg.sender].lastWithdrawTime = now;
255         
256         //update total rewards withdrawn
257         rewardsWithdrawn = rewardsWithdrawn.add(rewardAmount);
258         
259         //transfer rewards and tokens
260         rewardToken.transfer(msg.sender, rewardAmount);
261         tswap.transfer(msg.sender, amount);
262         
263         emit RewardWithdrawal(msg.sender, rewardAmount);
264         emit StakingWithdrawal(msg.sender, amount);
265     }
266     
267     //Withdraw rewards
268     function withdrawRewardsOnly() external {
269         uint256 _rwdAmount = calculateReward(msg.sender);
270         require(_rwdAmount > 0, "You do not have enough rewards");
271         
272         // 1. User Accounting
273         Stake[] storage accountStakes = userStaking[msg.sender];
274         
275         // Redeem from most recent stake and go backwards in time.
276         uint256 rewardAmount = 0;
277         uint256 i = accountStakes.length;
278         while (i > 0) {
279             Stake storage userStake = accountStakes[i - 1];
280             uint256 stakeTimeSec;
281             
282             //check if current time is more than pool ending time
283             if (now > poolEndTime) {
284                 stakeTimeSec = poolEndTime.sub(userStake.stakingTime);
285                 if(userStake.lastWithdrawTime != 0){
286                     stakeTimeSec = poolEndTime.sub(userStake.lastWithdrawTime);
287                 }
288             } else {
289                 stakeTimeSec = now.sub(userStake.stakingTime);
290                 if(userStake.lastWithdrawTime != 0){
291                     stakeTimeSec = now.sub(userStake.lastWithdrawTime);
292                 }
293             }
294             
295             // fully redeem a past stake
296             rewardAmount = computeNewReward(rewardAmount, userStake.amount, stakeTimeSec);
297             userStake.lastWithdrawTime = now;
298             i--;
299         }
300         
301         //update user rewards info
302         userRewardInfo[msg.sender].totalWithdrawn = userRewardInfo[msg.sender].totalWithdrawn.add(rewardAmount);
303         userRewardInfo[msg.sender].lastWithdrawTime = now;
304         
305         //update total rewards withdrawn
306         rewardsWithdrawn = rewardsWithdrawn.add(rewardAmount);
307         
308         //transfer rewards
309         rewardToken.transfer(msg.sender, rewardAmount);
310         emit RewardWithdrawal(msg.sender, rewardAmount);
311     }
312     
313     //get staking details by user address
314     function getStakingAmount(address _userAddress) external constant returns (uint256 _stakedAmount) {
315         return userTotalStaking[_userAddress].totalStaking;
316     }
317     
318     //get total rewards collected by user
319     function getTotalRewardCollectedByUser(address userAddress) view external returns (uint256 _totalRewardCollected) 
320     {
321         return userRewardInfo[userAddress].totalWithdrawn;
322     }
323     
324     //get total SWAP token staked in the contract
325     function getTotalStaked() external constant returns ( uint256 _totalStaked) {
326         return totalStaked;
327     }
328     
329     //get total rewards in the contract
330     function getTotalRewards() external constant returns ( uint256 _totalRewards) {
331         return totalRewards;
332     }
333     
334     //get pool details
335     function getPoolDetails() external view returns (address _baseToken, address _pairedToken, uint256 _totalRewards, uint256 _rewardsWithdrawn, uint256 _poolStartTime, uint256 _poolEndTime) {
336         return (address(tswap),address(rewardToken),totalRewards,rewardsWithdrawn,poolStartTime,poolEndTime);
337     }
338     
339     //get duration of pools
340     function getPoolDuration() external constant returns (uint256 _poolDuration) {
341         return poolDuration;
342     }
343 
344     //set duration of pools by owner in seconds
345     function setPoolDuration(uint256 _poolDuration) external onlyOwner {
346         poolDuration = _poolDuration;
347         poolEndTime = poolStartTime + _poolDuration;
348         emit PoolDurationChange(_poolDuration);
349     }
350     
351     //get SWAP token address
352     function getSwapAddress() external constant returns (address _swapAddress) {
353         return address(tswap);
354     }
355     
356     //set tswap address
357     function setTswapAddress(address _address) external onlyOwner {
358         tswap = Ierc20(_address);
359     }
360     
361     //set reward token address
362     function setRewardTokenAddress(address _address) external onlyOwner {
363         rewardToken = Ierc20(_address);
364     }
365     
366 }