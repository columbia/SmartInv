1 //////////DEFI product for staking Your YOP tokens and getting rewards
2 
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 ///////////////////////////////////////////////////////////////////////////////////
83 pragma solidity ^0.8.0;
84 
85 //Version 1.3
86 
87 //THE smart contract for staking RAMP tokens and claiming the rewards
88 //Fully fair and simple. Enjoy ;)
89 
90 
91 contract HopOnYop
92 {
93     
94     IERC20 public YOP;
95     
96     uint256 public RewardPool;
97     uint256 public AllTimeStaked;
98     uint256 public TVL;
99     uint256 public RewardsOwed;
100     uint256 private constant minStake = 88  * (10 ** 8);
101     uint256 private constant maxStake = 33333  * (10 ** 8);
102     uint8 constant public reward1 = 6; uint256 constant public stakedFor1 = 30 days; //6% reward for 30 days lock
103     uint8 constant public reward2 = 15; uint256 constant public stakedFor2 = 60 days; //15% reward for 60 days lock
104     uint8 constant public reward3 = 33; uint256 constant public stakedFor3 = 90 days; //33% reward for 90 days lock
105     
106     
107     constructor (address addr)
108     {
109         YOP = IERC20(addr);
110     }
111     
112     enum options {d30, d60, d90}
113     struct stake
114     {
115         uint256 amount;
116         uint256 stakingTime;
117         options option;
118         bool rewardTaken;
119     }
120     
121     mapping(address => stake) private stakes;    
122     
123     
124     /**
125      * @dev Adds more tokens to the pool, but first we needs to add allowance for this contract
126      */
127     function feedRewardPool() public
128     {
129          uint256 tokenAmount = YOP.allowance(msg.sender, address(this));
130          RewardPool += tokenAmount;
131          require(YOP.transferFrom(msg.sender, address(this), tokenAmount)); //Transfers the tokens to smart contract
132     }
133 
134     function stakeYOP(options option) public
135     {
136        
137         require(stakes[msg.sender].stakingTime == 0, "Error: Only one staking per address!!!");
138         uint256 tokenAmount = YOP.allowance(msg.sender, address(this));
139         require(tokenAmount > 0, "Error: Need to increase allowance first");
140         require(tokenAmount >= minStake && tokenAmount <= maxStake ,"Error: You should stake from 33 to 88888 tokens.");
141         stakes[msg.sender].amount = tokenAmount;
142         stakes[msg.sender].option = option;
143         stakes[msg.sender].stakingTime = block.timestamp;
144         
145         uint256 reward = calculateReward(msg.sender);
146         require(RewardPool >= reward + RewardsOwed, "Error: No enough rewards for You, shouldve thought about this before it went moon");
147         
148         TVL += tokenAmount;
149         RewardsOwed += reward;
150         AllTimeStaked += tokenAmount;
151         require(YOP.transferFrom(msg.sender, address(this), tokenAmount)); //Transfers the tokens to smart contract
152         
153 
154     }
155 
156     /**
157      * @dev claims the rewards and stake for the stake, can be only called by the user
158      * doesnt work if the campaign isnt finished yet
159      */
160     function claimRewards() public
161     {
162         require(stakes[msg.sender].rewardTaken == false,"Error: You already took the reward");
163         uint256 stakedFor;
164         options option = stakes[msg.sender].option;
165         
166         if(option == options.d30)
167         stakedFor = stakedFor1;
168         
169         if(option == options.d60)
170         stakedFor = stakedFor2;
171         
172         if(option == options.d90)
173         stakedFor = stakedFor3;
174         
175         require(stakes[msg.sender].stakingTime + stakedFor <= block.timestamp, "Error: Too soon to unstake");
176         uint256 reward = calculateReward(msg.sender);
177         uint256 amount = stakes[msg.sender].amount;
178         TVL -= amount;
179         RewardsOwed -= reward;
180         RewardPool -= reward;
181         stakes[msg.sender].rewardTaken = true;
182         
183         _withdraw(reward + amount);
184         
185     }
186     
187     /**
188      * @dev calculates the rewards+stake for the given staker
189      * @param staker is the staker we want the info for
190      */
191     function calculateReward(address staker) public view returns(uint256)
192     {
193         uint256 reward;
194         options option = stakes[staker].option;
195         
196         if(option == options.d30)
197         reward = reward1;
198         
199         if(option == options.d60)
200         reward = reward2;
201         
202         if(option == options.d90)
203         reward = reward3;
204         
205         return ((stakes[staker].amount * reward) / 100);
206     }
207     
208     
209     function getStakerInfo(address addr) public view returns(uint256, uint256, options, bool)
210     {
211         return(stakes[addr].amount,stakes[addr].stakingTime,stakes[addr].option,stakes[addr].rewardTaken);
212     }
213     
214     
215     function _withdraw(uint256 amount) internal
216     {
217         require(YOP.transfer(msg.sender, amount));
218         emit withdrawHappened(msg.sender, amount);
219     }
220     
221     event withdrawHappened(address indexed to, uint256 amount);
222    
223 }