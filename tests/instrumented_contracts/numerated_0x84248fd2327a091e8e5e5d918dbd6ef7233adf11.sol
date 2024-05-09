1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity ^0.7.5;
3 
4 //MATH OPERATIONS -- designed to avoid possibility of errors with built-in math functions
5 library SafeMath {
6     //@dev Multiplies two numbers, throws on overflow.
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     //@dev Integer division of two numbers, truncating the quotient (i.e. rounds down).
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         return c;
20     }
21     //@dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         uint256 c = a - b;
25         return c;
26     }
27     //@dev Adds two numbers, throws on overflow.
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 //end library
34 }
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 abstract contract Ownable {
48     address internal _owner;
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50     constructor () {
51         _owner = msg.sender;
52         emit OwnershipTransferred(address(0), msg.sender);
53     }
54     function owner() public view returns (address) {
55         return _owner;
56     }
57     modifier onlyOwner() {
58         require(_owner == msg.sender, "Ownable: caller is not the owner");
59         _;
60     }
61     function renounceOwnership() public virtual onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         emit OwnershipTransferred(_owner, newOwner);
68         _owner = newOwner;
69     }
70 }
71 
72 contract QUAI_Staking is Ownable {
73 	using SafeMath for uint256;
74 
75 	address public constant quaiToken = 0x40821CD074dfeCb1524286923bC69315075b5c89; //token to stake
76 
77 	//STAKING PARAMETERS
78 	uint256 public constant stakingPeriod = 30 days; //period over which tokens are locked after staking
79 	uint256 public stakingEnd; //point after which staking rewards cease to accumulate
80 	uint256 public rewardRate = 14; //14% linear return per staking period
81 	uint256 public totalStaked; //sum of all user stakes
82 	uint256 public maxTotalStaked = 58e23; //5.8 million tokens
83 	uint256 public minStaked = 1e21; //1000 tokens. min staked per user
84 
85 	//STAKING MAPPINGS
86 	mapping (address => uint256) public stakedTokens; //amount of tokens that address has staked
87 	mapping (address => uint256) public lastStaked; //last time at which address staked, deposited, or "rolled over" their position by calling updateStake directly
88 	mapping (address => uint256) public totalEarnedTokens; //total tokens earned through staking by each user
89 	
90 	constructor(){
91 		stakingEnd = (block.timestamp + 180 days);
92 	}
93 
94 	//STAKING FUNCTIONS
95 	function deposit(uint256 amountTokens) external {
96 		require( (stakedTokens[msg.sender] >= minStaked || amountTokens >= minStaked), "deposit: must exceed minimum stake" );
97 		require(totalStaked + amountTokens <= maxTotalStaked, "deposit: amount would exceed max stake. call updateStake to claim dividends");
98 		updateStake();
99 		IERC20(quaiToken).transferFrom(msg.sender, address(this), amountTokens);
100 		stakedTokens[msg.sender] += amountTokens;
101 		totalStaked += amountTokens;
102 	}
103 
104 	function updateStake() public {
105 		uint256 stakedUntil = min(block.timestamp, stakingEnd);
106 		uint256 periodStaked = stakedUntil.sub(lastStaked[msg.sender]);
107 		uint256 dividends;
108 		//linear rewards up to stakingPeriod
109 		if(periodStaked < stakingPeriod) {
110 			dividends = periodStaked.mul(stakedTokens[msg.sender]).mul(rewardRate).div(stakingPeriod).div(100);
111 		} else {
112 			dividends = stakedTokens[msg.sender].mul(rewardRate).div(100);
113 		}
114 		//update lastStaked time for msg.sender -- user cannot unstake until end of another stakingPeriod
115 		lastStaked[msg.sender] = stakedUntil;
116 		//withdraw dividends for user if rolling over dividends would exceed staking cap, else stake the dividends automatically
117 		if(totalStaked + dividends > maxTotalStaked) {
118 			IERC20(quaiToken).transfer(msg.sender, dividends);
119 			totalEarnedTokens[msg.sender] += dividends;
120 		} else {
121 			stakedTokens[msg.sender] += dividends;
122 			totalStaked += dividends;
123 			totalEarnedTokens[msg.sender] += dividends;
124 		}
125 	}
126 
127 	function withdrawDividends() external {
128 		uint256 stakedUntil = min(block.timestamp, stakingEnd);
129 		uint256 periodStaked = stakedUntil.sub(lastStaked[msg.sender]);
130 		uint256 dividends;
131 		//linear rewards up to stakingPeriod
132 		if(periodStaked < stakingPeriod) {
133 			dividends = periodStaked.mul(stakedTokens[msg.sender]).mul(rewardRate).div(stakingPeriod).div(100);
134 		} else {
135 			dividends = stakedTokens[msg.sender].mul(rewardRate).div(100);
136 		}
137 		//update lastStaked time for msg.sender -- user cannot unstake until end of another stakingPeriod
138 		lastStaked[msg.sender] = stakedUntil;
139 		//withdraw dividends for user
140 		IERC20(quaiToken).transfer(msg.sender, dividends);
141 		totalEarnedTokens[msg.sender] += dividends;
142 	}
143 
144     function min(uint256 a, uint256 b) internal pure returns(uint256) {
145         return a < b ? a : b;
146     }
147 
148 	function unstake() external {
149 		uint256 timeSinceStake = (block.timestamp).sub(lastStaked[msg.sender]);
150 		require(timeSinceStake >= stakingPeriod || block.timestamp > stakingEnd, "unstake: staking period for user still ongoing");
151 		updateStake();
152 		uint256 toTransfer = stakedTokens[msg.sender];
153 		stakedTokens[msg.sender] = 0;
154 		IERC20(quaiToken).transfer(msg.sender, toTransfer);
155 		totalStaked = totalStaked.sub(toTransfer);
156 	}
157 
158 	function getPendingDivs(address user) external view returns(uint256) {
159 		uint256 stakedUntil = min(block.timestamp, stakingEnd);
160 		uint256 periodStaked = stakedUntil.sub(lastStaked[user]);
161 		uint256 dividends;
162 		//linear rewards up to stakingPeriod
163 		if(periodStaked < stakingPeriod) {
164 			dividends = periodStaked.mul(stakedTokens[user]).mul(rewardRate).div(stakingPeriod).div(100);
165 		} else {
166 			dividends = stakedTokens[user].mul(rewardRate).div(100);
167 		}
168 		return(dividends);
169 	}
170 
171 	//OWNER ONLY FUNCTIONS
172 	function updateMinStake(uint256 newMinStake) external onlyOwner() {
173 		minStaked = newMinStake;
174 	}
175 
176 	function updateStakingEnd(uint256 newStakingEnd) external onlyOwner() {
177 		require(newStakingEnd >= block.timestamp, "updateStakingEnd: newStakingEnd must be in future");
178 		stakingEnd = newStakingEnd;
179 	}
180 
181 	function updateRewardRate(uint256 newRewardRate) external onlyOwner() {
182 		require(newRewardRate <= 100, "what are you, crazy?");
183 		rewardRate = newRewardRate;
184 	}
185 
186 	function updateMaxTotalStaked(uint256 newMaxTotalStaked) external onlyOwner() {
187 		maxTotalStaked = newMaxTotalStaked;
188 	}
189 
190 	//allows owner to recover ERC20 tokens for users when they are mistakenly sent to contract
191 	function recoverTokens(address tokenAddress, address dest, uint256 amountTokens) external onlyOwner() {
192 		require(tokenAddress != quaiToken, "recoverTokens: cannot move staked token");
193 		IERC20(tokenAddress).transfer(dest, amountTokens);
194 	}
195 
196 	//allows owner to reclaim any tokens not distributed during staking
197 	function recoverQUAI() external onlyOwner() {
198 		require(block.timestamp >= (stakingEnd + 30 days), "recoverQUAI: too early");
199 		uint256 amountToSend = IERC20(quaiToken).balanceOf(address(this));
200 		IERC20(quaiToken).transfer(msg.sender, amountToSend);
201 	}
202 }