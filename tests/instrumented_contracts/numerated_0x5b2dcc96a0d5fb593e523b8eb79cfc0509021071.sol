1 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
2 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
3 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
4 //////////////////////////////////////////////////################################################################/////////////////////////////////////////////////////////////////////////
5 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
6 ///////////////////////////////////////////////////THIS IS THE RPEPEBLU POOL OF KEK STAKING - rPepe Token Staking//////////////////////////////////////////////////////////////////////////
7 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
8 //////////////////////////////////////////////////################################################################/////////////////////////////////////////////////////////////////////////
9 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
10 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
11 
12 // SPDX-License-Identifier: UNLICENSED
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  *
18 */
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 
48   function ceil(uint a, uint m) internal pure returns (uint r) {
49     return (a + m - 1) / m * m;
50   }
51 }
52 
53 interface IKEK{
54     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
55     function transfer(address to, uint256 tokens) external returns (bool success);
56     function claimRewards(uint256 rewards, address rewardedTo) external returns(bool);
57     function stakingRewardsAvailable() external view returns(uint256 _rewardsAvailable);
58 }
59 
60 pragma solidity ^0.6.0;
61 contract rPepeToKEK {
62     using SafeMath for uint256;
63     
64     uint256 public currentStakingRate;
65     address public KEK = 0x31AEe7Db3b390bAaD34213C173A9df0dd11D84bd;
66     address public RPepe = 0x0e9b56D2233ea2b5883861754435f9C51Dbca141;
67     
68     uint256 public totalRewards;
69     uint256 private basePercent = 100;
70     
71     struct DepositedToken{
72         uint256 activeDeposit;
73         uint256 totalDeposits;
74         uint256 startTime;
75         uint256 pendingGains;
76         uint256 lastClaimedDate;
77         uint256 totalGained;
78         uint    rate;
79     }
80     
81     mapping(address => DepositedToken) users;
82     
83     event Staked(address indexed staker, uint256 indexed tokens);
84     event StakingRateChanged(uint256 indexed stakingRatePerHour);
85     event TokensClaimed(address indexed claimer, uint256 indexed stakedTokens);
86     event RewardClaimed(address indexed claimer, uint256 indexed reward);
87     
88     constructor() public{
89         currentStakingRate = 1e16; // 0.01 per hour
90     }
91     
92     // ------------------------------------------------------------------------
93     // Start staking
94     // @param _amount amount of tokens to deposit
95     // ------------------------------------------------------------------------
96     function Stake(uint256 _amount) external {
97         
98         // transfer tokens from user to the contract balance
99         require(IKEK(RPepe).transferFrom(msg.sender, address(this), _amount));
100         
101         uint256 tokensBurned = findTwoPointFivePercent(_amount);
102         uint256 tokensTransferred = _amount.sub(tokensBurned);
103     
104         // add new stake
105         _addToStake(tokensTransferred);
106         
107         emit Staked(msg.sender, _amount);
108         
109     }
110     
111     // ------------------------------------------------------------------------
112     // Claim reward and staked tokens
113     // @required user must be a staker
114     // @required must be claimable
115     // ------------------------------------------------------------------------
116     function ClaimStakedTokens() public {
117         require(users[msg.sender].activeDeposit > 0, "no running stake");
118         
119         uint256 _currentDeposit = users[msg.sender].activeDeposit;
120         
121         // check if we have any pending reward, add it to pendingGains var
122         users[msg.sender].pendingGains = PendingReward(msg.sender);
123         // update amount 
124         users[msg.sender].activeDeposit = 0;
125         
126         // transfer staked tokens
127         require(IKEK(RPepe).transfer(msg.sender, _currentDeposit));
128         
129         emit TokensClaimed(msg.sender, _currentDeposit);
130         
131     }
132     
133     // ------------------------------------------------------------------------
134     // Claim reward and staked tokens
135     // @required user must be a staker
136     // @required must be claimable
137     // ------------------------------------------------------------------------
138     function ClaimReward() public {
139         require(PendingReward(msg.sender) > 0, "nothing pending to claim");
140     
141         uint256 _pendingReward = PendingReward(msg.sender);
142         
143         // add claimed reward to global stats
144         totalRewards = totalRewards.add(_pendingReward);
145         // add the reward to total claimed rewards
146         users[msg.sender].totalGained = users[msg.sender].totalGained.add(_pendingReward);
147         // update lastClaim amount
148         users[msg.sender].lastClaimedDate = now;
149         // reset previous rewards
150         users[msg.sender].pendingGains = 0;
151         
152         // send tokens from KEK to the user
153         require(IKEK(KEK).claimRewards(_pendingReward, msg.sender));
154         
155         _updateStakingRate();
156         // update staking rate
157         users[msg.sender].rate = currentStakingRate;
158         
159         emit RewardClaimed(msg.sender, _pendingReward);
160     }
161     
162     function Exit() external{
163         if(PendingReward(msg.sender) > 0)
164             ClaimReward();
165         if(users[msg.sender].activeDeposit > 0)
166             ClaimStakedTokens();
167     }
168     
169     // ------------------------------------------------------------------------
170     // Private function to update the staking rate
171     // ------------------------------------------------------------------------
172     function _updateStakingRate() private{
173         uint256 originalRewards = 49000000 * 10 ** 18;
174         
175         // check the current volume of the rewards
176         uint256 rewardsAvailable = IKEK(KEK).stakingRewardsAvailable();
177         uint256 rewardsRemoved = originalRewards.sub(rewardsAvailable);
178         
179         if(rewardsRemoved >= 12250000 * 10 ** 18 && rewardsRemoved < 24500000 * 10 ** 18) { // less than 25% but greater than 50%
180             currentStakingRate =  5e15; // 0.005 per hour
181         }
182         else if(rewardsRemoved >= 24500000 * 10 ** 18 && rewardsRemoved < 34300000 * 10 ** 18){ // less than equal to 50% but greater than 70%
183             currentStakingRate = 2e15; // 0.002 per hour
184         }
185         else if(rewardsRemoved >= 34300000 * 10 ** 18 && rewardsRemoved < 44100000 * 10 ** 18){ // less than equal to 70% but greater than 90%
186             currentStakingRate = 1e15; // 0.001 per hour
187         }
188         else if(rewardsRemoved >= 44100000 * 10 ** 18) {
189             currentStakingRate = 5e14; // 0.0005 per hour
190         }
191     }
192     
193     // ------------------------------------------------------------------------
194     // Query to get the pending reward
195     // ------------------------------------------------------------------------
196     function PendingReward(address _caller) public view returns(uint256 _pendingReward){
197         uint256 _totalStakedTime = (now.sub(users[_caller].lastClaimedDate)).div(1 hours); // in hours
198         
199         uint256 reward = ((users[_caller].activeDeposit).mul(_totalStakedTime.mul(users[_caller].rate)));
200         reward = reward.div(10 ** 18);
201         return reward.add(users[_caller].pendingGains);
202     }
203     
204     // ------------------------------------------------------------------------
205     // Query to get the active stake of the user
206     // ------------------------------------------------------------------------
207     function YourActiveStake(address _user) external view returns(uint256 _activeStake){
208         return users[_user].activeDeposit;
209     }
210     
211     // ------------------------------------------------------------------------
212     // Query to get the total stakes of the user
213     // ------------------------------------------------------------------------
214     function YourTotalStakes(address _user) external view returns(uint256 _totalStakes){
215         return users[_user].totalDeposits;
216     }
217     
218     // ------------------------------------------------------------------------
219     // Query to get total earned rewards from stake
220     // ------------------------------------------------------------------------
221     function TotalStakeRewardsClaimed(address _user) external view returns(uint256 _totalEarned){
222         return users[_user].totalGained;
223     }
224     
225     // ------------------------------------------------------------------------
226     // Query to get the staking rate you staked at
227     // ------------------------------------------------------------------------
228     function YourStakingRate(address _user) external view returns(uint256 _stakingRate){
229         return users[_user].rate;
230     }
231     
232     // ------------------------------------------------------------------------
233     // Internal function to add new deposit
234     // ------------------------------------------------------------------------        
235     function _addToStake(uint256 _amount) internal{
236         _updateStakingRate();
237         
238         // check if we have any pending reward, add it to pendingGains variable
239         users[msg.sender].pendingGains = PendingReward(msg.sender);
240         users[msg.sender].rate = currentStakingRate; // rate for stakers will be fixed at time of staking
241             
242         users[msg.sender].activeDeposit = users[msg.sender].activeDeposit.add(_amount);
243         users[msg.sender].totalDeposits = users[msg.sender].totalDeposits.add(_amount);
244         users[msg.sender].startTime = now;
245         users[msg.sender].lastClaimedDate = now;
246         
247     }
248     
249     //// utility function from RPepe
250     function findTwoPointFivePercent(uint256 value) public view returns (uint256)  {
251         uint256 roundValue = value.ceil(basePercent);
252         uint256 twoPointFivePercent = roundValue.mul(basePercent).div(4000);
253         return twoPointFivePercent;
254     }
255 }