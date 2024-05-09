1 pragma solidity ^0.4.24;
2 
3 // File: contracts/SkrumbleStaking.sol
4 
5 // File: contracts/SkrumbleStaking.sol
6 
7 // Staking Contract for Skrumble Network - https://skrumble.network/
8 // written by @iamdefinitelyahuman
9 
10 
11 library SafeMath {
12 
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 
42 interface ERC20 {
43   function balanceOf(address _owner) external returns (uint256);
44   function transfer(address _to, uint256 _value) external returns (bool);
45   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
46 }
47 
48 
49 contract SkrumbleStaking {
50 
51   using SafeMath for uint;
52 
53   bool public isLocked = true;
54   address owner;
55   address rewardWallet;
56   uint balance;
57   uint public count;
58   uint public limit;
59   ERC20 token;
60   
61   struct Reward {
62     uint stakedAmount;
63     uint lockupPeriod;
64     uint[] rewardAmounts;
65     uint[] rewardEpochStart;
66   }
67   mapping (uint => Reward) public rewardLevels;
68 
69   struct Staker {
70     uint balance;
71     uint rewardLevel;
72     uint stakingSince;
73     uint lastClaim;
74   }
75   mapping (address => Staker) stakerMap;
76 
77   event RewardLevel (uint level, uint amount, uint lockupPeriod, uint[] rewardAmounts, uint[] rewardEpochStart);
78   event NewStaker (address staker, uint rewardLevel, uint stakingSince);
79   event StakerCount (uint count, uint limit);
80   event RewardClaimed (address staker, uint rewardAmount);
81 
82   modifier onlyOwner () {
83     require (msg.sender == owner);
84     _;
85   }
86 
87   modifier onlyUnlocked () {
88     require (!isLocked);
89     _;
90   }
91 
92   constructor (address _tokenContract, address _rewardWallet) public {
93     owner = msg.sender;
94     rewardWallet = _rewardWallet;
95     token = ERC20(_tokenContract);
96   }
97   
98   function min (uint a, uint b) pure internal returns (uint) {
99     if (a <= b) return a;
100     return b;
101   }
102   
103   function max (uint a, uint b) pure internal returns (uint) {
104     if (a >= b) return a;
105     return b;
106   }
107   
108   function lockContract () public onlyOwner {
109     isLocked = true;
110   }
111   
112   function unlockContract () public onlyOwner {
113     isLocked = false;
114   }
115   
116   function setRewardWallet (address _rewardWallet) public onlyOwner {
117     rewardWallet = _rewardWallet;
118   }
119   
120   function setRewardLevel (uint _level, uint _amount, uint _lockup, uint[] _reward, uint[] _period) public onlyOwner {
121     require (_reward.length == _period.length);
122     require (_period[_period.length.sub(1)] < 9999999999);
123     for (uint i = 1; i < _period.length; i++) {
124       require (_period[i] > _period[i.sub(1)]);
125     }
126     rewardLevels[_level] = Reward(_amount, _lockup, _reward, _period);
127     emit RewardLevel (_level, _amount, _lockup, _reward, _period);
128   }
129   
130   function modifyStakerLimit (uint _limit) public onlyOwner {
131     require (count <= _limit);
132     limit = _limit;
133   }
134   
135   function getAvailableReward (address _staker) view public returns (uint) {
136     Staker storage staker = stakerMap[_staker];
137     Reward storage reward = rewardLevels[staker.rewardLevel];
138     if (staker.balance == 0 || staker.lastClaim.add(86400) > now) {
139       return 0;
140     }
141     uint unclaimed = 0;
142     uint periodEnd = 9999999999;
143     for (uint i = reward.rewardEpochStart.length; i > 0; i--) {
144       uint start = staker.stakingSince.add(reward.rewardEpochStart[i.sub(1)]);
145       if (start >= now) {
146         continue;
147       }
148       uint length = min(now, periodEnd).sub(max(start, staker.lastClaim));
149       unclaimed = unclaimed.add(reward.rewardAmounts[i.sub(1)].mul(length).div(31622400));
150       if (staker.lastClaim >= start) {
151         break;
152       }
153       periodEnd = start;
154     }
155     return unclaimed;
156   }
157 
158   function getStakerInfo (address _staker) view public returns (uint stakedBalance, uint lockedUntil, uint lastClaim) {
159     Staker storage staker = stakerMap[_staker];
160     Reward storage reward = rewardLevels[staker.rewardLevel];
161     return (staker.balance, staker.stakingSince.add(reward.lockupPeriod), staker.lastClaim);
162   }
163 
164   function stakeTokens (uint _level) public onlyUnlocked {
165     Reward storage reward = rewardLevels[_level];
166     require (stakerMap[msg.sender].balance == 0);
167     require (count < limit);
168     require (token.transferFrom(msg.sender, address(this), reward.stakedAmount));
169     count = count.add(1);
170     balance = balance.add(reward.stakedAmount);
171     stakerMap[msg.sender] = Staker(reward.stakedAmount, _level, now, now);
172     emit NewStaker (msg.sender, _level, now);
173     emit StakerCount (count, limit);
174   }
175   
176   function unstakeTokens () public onlyUnlocked {
177     Staker storage staker = stakerMap[msg.sender];
178     Reward storage reward = rewardLevels[staker.rewardLevel];
179     require (staker.balance > 0);
180     require (staker.stakingSince.add(reward.lockupPeriod) < now);
181     if (getAvailableReward(msg.sender) > 0) {
182       claimReward();
183     }
184     require (token.transfer(msg.sender, staker.balance));
185     count = count.sub(1);
186     balance = balance.sub(staker.balance);
187     emit StakerCount (count, limit);
188   	stakerMap[msg.sender] = Staker(0, 0, 0, 0);
189   }
190   
191   function claimReward () public onlyUnlocked {
192     uint amount = getAvailableReward(msg.sender);
193     require (amount > 0);
194     stakerMap[msg.sender].lastClaim = now;
195     require (token.transferFrom(rewardWallet, msg.sender, amount));
196     emit RewardClaimed (msg.sender, amount);
197   }
198   
199   function transferSKM () public onlyOwner {
200     uint fullBalance = token.balanceOf(address(this));
201     require (fullBalance > balance);
202     require (token.transfer(owner, fullBalance.sub(balance)));
203   }
204   
205   function transferOtherTokens (address _tokenAddr) public onlyOwner {
206     require (_tokenAddr != address(token));
207     ERC20 _token = ERC20(_tokenAddr);
208     require (_token.transfer(owner, _token.balanceOf(address(this))));
209   }
210 
211   function claimRewardManually (address _staker) public onlyOwner {
212     uint amount = getAvailableReward(_staker);
213     require (amount > 0);
214     stakerMap[_staker].lastClaim = now;
215     require (token.transferFrom(rewardWallet, _staker, amount));
216     emit RewardClaimed (_staker, amount);
217   }
218 
219   function unstakeTokensManually (address _staker) public onlyOwner {
220     Staker storage staker = stakerMap[_staker];
221     Reward storage reward = rewardLevels[staker.rewardLevel];
222     require (staker.balance > 0);
223     require (staker.stakingSince.add(reward.lockupPeriod) < now);
224     if (getAvailableReward(_staker) > 0) {
225       claimRewardManually(_staker);
226     }
227     require (token.transfer(_staker, staker.balance));
228     count = count.sub(1);
229     balance = balance.sub(staker.balance);
230     emit StakerCount (count, limit);
231   	stakerMap[_staker] = Staker(0, 0, 0, 0);
232   }
233 
234   function stakeTokensManually (address _staker, uint _level, uint time) public onlyOwner {
235     Reward storage reward = rewardLevels[_level];
236     require (stakerMap[_staker].balance == 0);
237     require (count < limit);
238     count = count.add(1);
239     balance = balance.add(reward.stakedAmount);
240     stakerMap[_staker] = Staker(reward.stakedAmount, _level, time, time);
241     emit NewStaker (_staker, _level, time);
242     emit StakerCount (count, limit);
243   }
244 
245 }