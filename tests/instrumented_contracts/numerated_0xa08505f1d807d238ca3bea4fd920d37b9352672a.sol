1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0 <0.9.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address to, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(
11         address from,
12         address to,
13         uint256 amount
14     ) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 abstract contract Auth {
20 
21     address internal owner;
22     mapping (address => bool) internal authorizations;
23 
24     constructor(address _owner) {
25         owner = _owner;
26         authorizations[_owner] = true;
27     }
28 
29     modifier onlyOwner() {
30         require(isOwner(msg.sender), "!OWNER"); _;
31     }
32 
33     modifier authorized() {
34         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
35     }
36 
37     function authorize(address adr) public onlyOwner {
38         authorizations[adr] = true;
39     }
40 
41     function unauthorize(address adr) public onlyOwner {
42         authorizations[adr] = false;
43     }
44 
45     function isOwner(address account) public view returns (bool) {
46         return account == owner;
47     }
48 
49     function isAuthorized(address adr) public view returns (bool) {
50         return authorizations[adr];
51     }
52 
53     function transferOwnership(address payable adr) public onlyOwner {
54         owner = adr;
55         authorizations[adr] = true;
56         emit OwnershipTransferred(adr);
57     }
58 
59     event OwnershipTransferred(address owner);
60 }
61 
62 contract SRI is Auth {
63 
64 	struct StakeState {
65 		uint256 stakedAmount;
66 		uint32 since;
67 		uint32 lastUpdate;
68 	}
69 
70 	// Staking token and fee receivers.
71 	address public stakingToken;
72 	address constant public DEAD = address(0xdead);
73 	address public devFeeReceiver;
74 	address public lpFeeReceiver;
75 	// APR% with 2 decimals.
76 	uint256 public aprNumerator = 3600;
77 	uint256 constant public aprDenominator = 10000;
78 	// Fees in % with 2 decimals.
79 	uint256 public burnFeeNumerator = 300;
80 	uint256 constant public burnFeeDenominator = 10000;
81 	uint256 public devFeeNumerator = 50;
82 	uint256 constant public devFeeDenominator = 10000;
83 	uint256 public lpFeeNumerator = 50;
84 	uint256 constant public lpFeeDenominator = 10000;
85 	// Staking status.
86 	uint256 public totalStakedTokens;
87 	mapping (address => StakeState) internal stakerDetails;
88 
89 	event TokenStaked(address indexed user, uint256 amount);
90 	event TokenUnstaked(address indexed user, uint256 amount, uint256 reward);
91 	event RewardClaimed(address indexed user, uint256 reward);
92 	event Compounded(address indexed user, uint256 amount);
93 
94 	constructor(address tokenToStake, address devFee, address lpAddress) Auth(msg.sender) {
95 		stakingToken = tokenToStake;
96 		devFeeReceiver = devFee;
97 		lpFeeReceiver = lpAddress;
98 	}
99 
100 	function stake(uint256 amount) external {
101 		require(amount > 0, "Amount needs to be bigger than 0");
102 
103 		StakeState storage user = stakerDetails[msg.sender];
104 		uint32 ts = uint32(block.timestamp);
105 
106 		// New staking
107 		if (user.since == 0) {
108 			user.since = ts;
109 		} else {
110 			compoundFor(msg.sender);
111 		}
112 		user.lastUpdate = ts;
113 		user.stakedAmount += amount;
114 		totalStakedTokens += amount;
115 
116 		IERC20(stakingToken).transferFrom(msg.sender, address(this), amount);
117 
118 		emit TokenStaked(msg.sender, amount);
119 	}
120 
121 	function unstake(uint256 amount) public {
122 		require(amount > 0, "Amount needs to be bigger than 0");
123 		unstakeFor(msg.sender, amount);
124 	}
125 
126 	function unstakeAll() external {
127 		StakeState storage user = stakerDetails[msg.sender];
128 		require(user.since > 0, "You are not staking.");
129 		require(user.stakedAmount > 0, "You are not staking.");
130 		uint256 toUnstake = user.stakedAmount;
131 		require(toUnstake > 0, "You are not staking.");
132 		unstakeFor(msg.sender, toUnstake);
133 	}
134 
135 	function unstakeFor(address staker, uint256 amount) internal {
136 		StakeState storage user = stakerDetails[staker];
137 		require(user.stakedAmount >= amount, "Not enough tokens staked.");
138 
139 		// Unstaking automatically gives the pending reward.
140 		uint256 pending = pendingReward(staker);
141 		uint256 total = amount + pending;
142 		uint256 burnFee = executeBurnFee(total);
143 		uint256 devFee = executeDevFee(total);
144 		uint256 lpFee = executeLPFee(total);
145 		uint256 toReceive = total - burnFee - devFee - lpFee;
146 		user.stakedAmount -= amount;
147 		totalStakedTokens -= amount;
148 		user.lastUpdate = uint32(block.timestamp);
149 
150 		IERC20(stakingToken).transfer(staker, toReceive);
151 
152 		emit TokenUnstaked(staker, toReceive, pending);
153 	}
154 
155 	function executeBurnFee(uint256 amount) internal returns (uint256) {
156 		return executeFee(amount, burnFeeNumerator, burnFeeDenominator, DEAD);
157 	}
158 
159 	function executeDevFee(uint256 amount) internal returns (uint256) {
160 		return executeFee(amount, devFeeNumerator, devFeeDenominator, devFeeReceiver);
161 	}
162 
163 	function executeLPFee(uint256 amount) internal returns (uint256) {
164 		return executeFee(amount, lpFeeNumerator, lpFeeDenominator, lpFeeReceiver);
165 	}
166 
167 	function executeFee(uint256 amount, uint256 numerator, uint256 denominator, address receiver) internal returns (uint256) {
168 		uint256 fee = calcFee(amount, numerator, denominator);
169 		if (fee > 0) {
170 			IERC20(stakingToken).transfer(receiver, fee);
171 			return fee;
172 		}
173 
174 		return 0;
175 	}
176 
177 	function calcFee(uint256 amount, uint256 num, uint256 den) public pure returns (uint256) {
178 		if (amount == 0) {
179 			return 0;
180 		}
181 		if (num == 0 || den == 0) {
182 			return 0;
183 		}
184 
185 		return amount * num / den;
186 	}
187 
188 	function claim() external {
189 		StakeState storage user = stakerDetails[msg.sender];
190 		require(user.since > 0, "You are not staking.");
191 		uint256 pending = pendingReward(msg.sender);
192 		if (pending > 0) {
193 			IERC20(stakingToken).transfer(msg.sender, pending);
194 			user.lastUpdate = uint32(block.timestamp);
195 
196 			emit RewardClaimed(msg.sender, pending);
197 		}
198 	}
199 
200 	function compound() external {
201 		compoundFor(msg.sender);
202 	}
203 
204 	function compoundFor(address staker) internal {
205 		StakeState storage user = stakerDetails[staker];
206 		uint256 pending = pendingReward(staker);
207 		if (pending > 0) {
208 			user.lastUpdate = uint32(block.timestamp);
209 			user.stakedAmount += pending;
210 			totalStakedTokens += pending;
211 
212 			emit Compounded(staker, pending);
213 		}
214 	}
215 
216 	function getPendingReward() external view returns (uint256) {
217 		return pendingReward(msg.sender);
218 	}
219 
220 	/**
221 	 * @dev Check the current unclaimed pending reward for a user.
222 	 */
223 	function pendingReward(address staker) public view returns (uint256) {
224 		StakeState storage user = stakerDetails[staker];
225 		// Check if the user ever staked.
226 		if (user.since == 0) {
227 			return 0;
228 		}
229 
230 		// Should not happen but block.timestamp is not 100% secure.
231 		if (block.timestamp <= user.lastUpdate) {
232 			return 0;
233 		}
234 
235 		uint256 deltaTime = block.timestamp - user.lastUpdate;
236 		uint256 annualReward = user.stakedAmount * aprNumerator / aprDenominator;
237 		return annualReward * deltaTime / 365 days;
238 	}
239 
240 	/**
241 	 * @dev Get the APR values, returns a numerator to divide by a denominator to get the decimal value of the percentage.
242 	 * Example: 20% can be 2000 / 10000, which is 0.2, the decimal representation of 20%.
243 	 * @notice APY = (1 + APR / n) ** n - 1;
244 	 * Where n is the compounding rate (times of compounding in a year)
245 	 * This is better calculated on a frontend, as Solidity does not do floating point arithmetic.
246 	 */
247 	function getAPR() external view returns (uint256 numerator, uint256 denominator) {
248 		return (aprNumerator, aprDenominator);
249 	}
250 
251 	/**
252 	 * @dev Gets an approximated APR percentage rounded to no decimals.
253 	 */
254 	function getAPRRoundedPercentage() external view returns (uint256) {
255 		return 100 * aprNumerator / aprDenominator;
256 	}
257 
258 	/**
259 	 * @dev Gets an approximated APR percentage rounded to specified decimals.
260 	 */
261 	function getAPRPercentage(uint256 desiredDecimals) external view returns (uint256 percentage, uint256 decimals) {
262 		uint256 factor = 10 ** desiredDecimals;
263 		uint256 integerPercent = 100 * factor * aprNumerator / aprDenominator;
264 		return (integerPercent / factor, integerPercent % factor);
265 	}
266 
267 	function setDevFeeReceiver(address receiver) external authorized {
268 		devFeeReceiver = receiver;
269 	}
270 
271 	function setLPAddress(address lp) external authorized {
272 		lpFeeReceiver = lp;
273 	}
274 
275 	/**
276 	 * @dev Sets the unstake burn fee. It is then divided by 10000, so for 1% fee you would set it to 100.
277 	 */
278 	function setBurnFeeNumerator(uint256 numerator) external authorized {
279 		require(numerator + lpFeeNumerator + devFeeNumerator < 3333, "Total fee has to be lower than 33.33%.");
280 		burnFeeNumerator = numerator;
281 	}
282 
283 	function setDevFeeNumerator(uint256 numerator) external authorized {
284 		require(numerator + lpFeeNumerator + burnFeeNumerator < 3333, "Total fee has to be lower than 33.33%.");
285 		devFeeNumerator = numerator;
286 	}
287 
288 	function setLPFeeNumerator(uint256 numerator) external authorized {
289 		require(numerator + burnFeeNumerator + devFeeNumerator < 3333, "Total fee has to be lower than 33.33%.");
290 		lpFeeNumerator = numerator;
291 	}
292 
293 	function getStake(address staker) external view returns (StakeState memory) {
294 		return stakerDetails[staker];
295 	}
296 
297 	function availableRewardTokens() external view returns (uint256) {
298 		uint256 tokens = IERC20(stakingToken).balanceOf(address(this));
299 		if (tokens <= totalStakedTokens) {
300 			return 0;
301 		}
302 		return tokens - totalStakedTokens;
303 	}
304 
305 	function setStakingToken(address newToken) external authorized {
306 		require(totalStakedTokens == 0, "Cannot change staking token while people are still staking.");
307 		stakingToken = newToken;
308 	}
309 
310 	function forceUnstakeAll(address staker) external authorized {
311 		StakeState storage user = stakerDetails[staker];
312 		require(user.since > 0, "User is not staking.");
313 		require(user.stakedAmount > 0, "User is not staking.");
314 		uint256 toUnstake = user.stakedAmount;
315 		require(toUnstake > 0, "User is not staking.");
316 		unstakeFor(staker, toUnstake);
317 	}
318 }