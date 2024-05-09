1 pragma solidity 0.4.25;
2 
3 /**
4  * token contract functions
5 */
6 contract Ierc20 {
7     function balanceOf(address who) external view returns (uint256);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function transfer(address to, uint256 value) external returns (bool);
10     function approve(address spender, uint256 value) external returns (bool);
11     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 }
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     require(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     require(c >= a);
38     return c;
39   }
40 
41   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
42     uint256 c = add(a,m);
43     uint256 d = sub(c,1);
44     return mul(div(d,m),m);
45   }
46 }
47 
48 contract Owned {
49         address public owner;
50         event OwnerChanges(address newOwner);
51         
52         constructor() public {
53             owner = msg.sender;
54         }
55 
56         modifier onlyOwner {
57             require(msg.sender == owner);
58             _;
59         }
60 
61         function transferOwnership(address newOwner) onlyOwner external {
62             require(newOwner != address(0), "New owner is the zero address");
63             owner = newOwner;
64             emit OwnerChanges(newOwner);
65         }
66 }
67 
68 contract StakingPool is Owned {
69     using SafeMath for uint256;
70     
71     Ierc20 public tswap;
72     Ierc20 public rewardToken;
73     uint256 poolDuration;
74     uint256 totalRewards;
75     uint256 rewardsWithdrawn;
76     uint256 poolStartTime;
77     uint256 poolEndTime;
78     uint256 totalStaked;
79     // Represents a single stake for a user. A user may have multiple.
80     struct Stake {
81         uint256 amount;
82         uint256 stakingTime;
83         uint256 lastWithdrawTime;
84     }
85     mapping (address => Stake[]) public userStaking;
86     
87     // Represents total staking of an user
88     struct UserTotals {
89         uint256 totalStaking;
90         uint256 totalStakingTIme;
91     }
92     mapping (address => UserTotals) public userTotalStaking;
93     
94     struct Ris3Rewards {
95         uint256 totalWithdrawn;
96         uint256 lastWithdrawTime;
97     }
98     mapping(address => Ris3Rewards) public userRewardInfo;
99     
100     event OwnerSetReward(uint256 amount);
101     event Staked(address userAddress, uint256 amount);
102     event StakingWithdrawal(address userAddress, uint256 amount);
103     event RewardWithdrawal(address userAddress, uint256 amount);
104     event PoolDurationChange(uint256 poolDuration);
105     
106     /**
107      * Constrctor function
108     */
109     constructor() public {
110         tswap = Ierc20(0xCC4304A31d09258b0029eA7FE63d032f52e44EFe);
111         rewardToken = Ierc20(0xe047705117Eb07e712C3d684f5B18E74577e83aC);
112         poolDuration = 720 hours;
113     }
114     
115     //Set pool rewards
116     function ownerSetPoolRewards(uint256 _rewardAmount) external onlyOwner {
117         require(poolStartTime == 0, "Pool rewards already set");
118         require(_rewardAmount > 0, "Cannot create pool with zero amount");
119         
120         //set total rewards value
121         totalRewards = _rewardAmount;
122         
123         poolStartTime = now;
124         poolEndTime = now + poolDuration;
125         
126         //transfer tokens to contract
127         rewardToken.transferFrom(msg.sender, this, _rewardAmount);
128         emit OwnerSetReward(_rewardAmount);
129     }
130     
131     //Stake function for users to stake SWAP token
132     function stake(uint256 amount) external {
133         require(amount > 0, "Cannot stake 0");
134         require(now < poolEndTime, "Staking pool is closed"); //staking pool is closed for staking
135         
136         //add value in staking
137         userTotalStaking[msg.sender].totalStaking = userTotalStaking[msg.sender].totalStaking.add(amount);
138         
139         //add new stake
140         Stake memory newStake = Stake(amount, now, 0);
141         userStaking[msg.sender].push(newStake);
142         
143         //add to total staked
144         totalStaked = totalStaked.add(amount);
145         
146         tswap.transferFrom(msg.sender, this, amount);
147         emit Staked(msg.sender, amount);
148     }
149     
150     //compute rewards
151     function computeNewReward(uint256 _rewardAmount, uint256 _stakedAmount, uint256 _stakeTimeSec) private view returns (uint256 _reward) {
152         uint256 rewardPerSecond = totalRewards.mul(1 ether);
153         if (rewardPerSecond != 0 ) {
154             rewardPerSecond = rewardPerSecond.div(poolDuration);
155         }
156         
157         if (rewardPerSecond > 0) {
158             uint256 rewardPerSecForEachTokenStaked = rewardPerSecond.div(totalStaked);
159             uint256 userRewards = rewardPerSecForEachTokenStaked.mul(_stakedAmount).mul(_stakeTimeSec);
160                     userRewards = userRewards.div(1 ether);
161             
162             return _rewardAmount.add(userRewards);
163         } else {
164             return 0;
165         }
166     }
167     
168     //calculate your rewards
169     function calculateReward(address _userAddress) public view returns (uint256 _reward) {
170         // all user stakes
171         Stake[] storage accountStakes = userStaking[_userAddress];
172         
173         // Redeem from most recent stake and go backwards in time.
174         uint256 rewardAmount = 0;
175         uint256 i = accountStakes.length;
176         while (i > 0) {
177             Stake storage userStake = accountStakes[i - 1];
178             uint256 stakeTimeSec;
179             
180             //check if current time is more than pool ending time
181             if (now > poolEndTime) {
182                 stakeTimeSec = poolEndTime.sub(userStake.stakingTime);
183                 if(userStake.lastWithdrawTime != 0){
184                     stakeTimeSec = poolEndTime.sub(userStake.lastWithdrawTime);
185                 }
186             } else {
187                 stakeTimeSec = now.sub(userStake.stakingTime);
188                 if(userStake.lastWithdrawTime != 0){
189                     stakeTimeSec = now.sub(userStake.lastWithdrawTime);
190                 }
191             }
192             
193             // fully redeem a past stake
194             rewardAmount = computeNewReward(rewardAmount, userStake.amount, stakeTimeSec);
195             i--;
196         }
197         
198         return rewardAmount;
199     }
200     
201     //Withdraw staking and rewards
202     function withdrawStaking(uint256 amount) external {
203         require(amount > 0, "Amount can not be zero");
204         require(userTotalStaking[msg.sender].totalStaking >= amount, "You are trying to withdaw more than your stake");
205         
206         // 1. User Accounting
207         Stake[] storage accountStakes = userStaking[msg.sender];
208         
209         // Redeem from most recent stake and go backwards in time.
210         uint256 sharesLeftToBurn = amount;
211         uint256 rewardAmount = 0;
212         while (sharesLeftToBurn > 0) {
213             Stake storage lastStake = accountStakes[accountStakes.length - 1];
214             uint256 stakeTimeSec;
215             //check if current time is more than pool ending time
216             if (now > poolEndTime) {
217                 stakeTimeSec = poolEndTime.sub(lastStake.stakingTime);
218                 if(lastStake.lastWithdrawTime != 0){
219                     stakeTimeSec = poolEndTime.sub(lastStake.lastWithdrawTime);
220                 }
221             } else {
222                 stakeTimeSec = now.sub(lastStake.stakingTime);
223                 if(lastStake.lastWithdrawTime != 0){
224                     stakeTimeSec = now.sub(lastStake.lastWithdrawTime);
225                 }
226             }
227             
228             if (lastStake.amount <= sharesLeftToBurn) {
229                 // fully redeem a past stake
230                 rewardAmount = computeNewReward(rewardAmount, lastStake.amount, stakeTimeSec);
231                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.amount);
232                 accountStakes.length--;
233             } else {
234                 // partially redeem a past stake
235                 rewardAmount = computeNewReward(rewardAmount, sharesLeftToBurn, stakeTimeSec);
236                 lastStake.amount = lastStake.amount.sub(sharesLeftToBurn);
237                 lastStake.lastWithdrawTime = now;
238                 sharesLeftToBurn = 0;
239             }
240         }
241         
242         //substract value in staking
243         userTotalStaking[msg.sender].totalStaking = userTotalStaking[msg.sender].totalStaking.sub(amount);
244         
245         //substract from total staked
246         totalStaked = totalStaked.sub(amount);
247         
248         //update user rewards info
249         userRewardInfo[msg.sender].totalWithdrawn = userRewardInfo[msg.sender].totalWithdrawn.add(rewardAmount);
250         userRewardInfo[msg.sender].lastWithdrawTime = now;
251         
252         //update total rewards withdrawn
253         rewardsWithdrawn = rewardsWithdrawn.add(rewardAmount);
254         
255         //transfer rewards and tokens
256         rewardToken.transfer(msg.sender, rewardAmount);
257         tswap.transfer(msg.sender, amount);
258         
259         emit RewardWithdrawal(msg.sender, rewardAmount);
260         emit StakingWithdrawal(msg.sender, amount);
261     }
262     
263     //Withdraw rewards
264     function withdrawRewardsOnly() external {
265         uint256 _rwdAmount = calculateReward(msg.sender);
266         require(_rwdAmount > 0, "You do not have enough rewards");
267         
268         // 1. User Accounting
269         Stake[] storage accountStakes = userStaking[msg.sender];
270         
271         // Redeem from most recent stake and go backwards in time.
272         uint256 rewardAmount = 0;
273         uint256 i = accountStakes.length;
274         while (i > 0) {
275             Stake storage userStake = accountStakes[i - 1];
276             uint256 stakeTimeSec;
277             
278             //check if current time is more than pool ending time
279             if (now > poolEndTime) {
280                 stakeTimeSec = poolEndTime.sub(userStake.stakingTime);
281                 if(userStake.lastWithdrawTime != 0){
282                     stakeTimeSec = poolEndTime.sub(userStake.lastWithdrawTime);
283                 }
284             } else {
285                 stakeTimeSec = now.sub(userStake.stakingTime);
286                 if(userStake.lastWithdrawTime != 0){
287                     stakeTimeSec = now.sub(userStake.lastWithdrawTime);
288                 }
289             }
290             
291             // fully redeem a past stake
292             rewardAmount = computeNewReward(rewardAmount, userStake.amount, stakeTimeSec);
293             userStake.lastWithdrawTime = now;
294             i--;
295         }
296         
297         //update user rewards info
298         userRewardInfo[msg.sender].totalWithdrawn = userRewardInfo[msg.sender].totalWithdrawn.add(rewardAmount);
299         userRewardInfo[msg.sender].lastWithdrawTime = now;
300         
301         //update total rewards withdrawn
302         rewardsWithdrawn = rewardsWithdrawn.add(rewardAmount);
303         
304         //transfer rewards
305         rewardToken.transfer(msg.sender, rewardAmount);
306         emit RewardWithdrawal(msg.sender, rewardAmount);
307     }
308     
309     //get staking details by user address
310     function getStakingAmount(address _userAddress) external constant returns (uint256 _stakedAmount) {
311         return userTotalStaking[_userAddress].totalStaking;
312     }
313     
314     //get total rewards collected by user
315     function getTotalRewardCollectedByUser(address userAddress) view external returns (uint256 _totalRewardCollected) 
316     {
317         return userRewardInfo[userAddress].totalWithdrawn;
318     }
319     
320     //get total SWAP token staked in the contract
321     function getTotalStaked() external constant returns ( uint256 _totalStaked) {
322         return totalStaked;
323     }
324     
325     //get total rewards in the contract
326     function getTotalRewards() external constant returns ( uint256 _totalRewards) {
327         return totalRewards;
328     }
329     
330     //get pool details
331     function getPoolDetails() external view returns (address _baseToken, address _pairedToken, uint256 _totalRewards, uint256 _rewardsWithdrawn, uint256 _poolStartTime, uint256 _poolEndTime) {
332         return (address(tswap),address(rewardToken),totalRewards,rewardsWithdrawn,poolStartTime,poolEndTime);
333     }
334     
335     //get duration of pools
336     function getPoolDuration() external constant returns (uint256 _poolDuration) {
337         return poolDuration;
338     }
339 
340     //set duration of pools by owner in seconds
341     function setPoolDuration(uint256 _poolDuration) external onlyOwner {
342         poolDuration = _poolDuration;
343         poolEndTime = poolStartTime + _poolDuration;
344         emit PoolDurationChange(_poolDuration);
345     }
346     
347     //get SWAP token address
348     function getSwapAddress() external constant returns (address _swapAddress) {
349         return address(tswap);
350     }
351     
352     //set tswap address
353     function setTswapAddress(address _address) external onlyOwner {
354         tswap = Ierc20(_address);
355     }
356     
357     //set reward token address
358     function setRewardTokenAddress(address _address) external onlyOwner {
359         rewardToken = Ierc20(_address);
360     }
361     
362 }