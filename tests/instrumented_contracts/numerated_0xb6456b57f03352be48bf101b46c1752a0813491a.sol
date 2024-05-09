1 pragma solidity 0.8.1;
2 
3 interface ISupplyController {
4 	function mintIncentive(address addr) external;
5 	function mintableIncentive(address addr) external view returns (uint);
6 	function mint(address token, address owner, uint amount) external;
7 	function changeSupplyController(address newSupplyController) external;
8 }
9 
10 interface IADXToken {
11 	function transfer(address to, uint256 amount) external returns (bool);
12 	function transferFrom(address from, address to, uint256 amount) external returns (bool);
13 	function approve(address spender, uint256 amount) external returns (bool);
14 	function balanceOf(address spender) external view returns (uint);
15 	function allowance(address owner, address spender) external view returns (uint);
16 	function totalSupply() external returns (uint);
17 	function supplyController() external view returns (ISupplyController);
18 	function changeSupplyController(address newSupplyController) external;
19 	function mint(address owner, uint amount) external;
20 }
21 
22 
23 interface IERCDecimals {
24 	function decimals() external view returns (uint);
25 }
26 
27 interface IChainlink {
28 	// AUDIT: ensure this API is not deprecated
29 	function latestAnswer() external view returns (uint);
30 }
31 
32 // Full interface here: https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router01.sol
33 interface IUniswapSimple {
34 	function WETH() external pure returns (address);
35 	function swapTokensForExactTokens(
36 		uint amountOut,
37 		uint amountInMax,
38 		address[] calldata path,
39 		address to,
40 		uint deadline
41 	) external returns (uint[] memory amounts);
42 }
43 
44 contract StakingPool {
45 	// ERC20 stuff
46 	// Constants
47 	string public constant name = "AdEx Staking Token";
48 	uint8 public constant decimals = 18;
49 	string public constant symbol = "ADX-STAKING";
50 
51 	// Mutable variables
52 	uint public totalSupply;
53 	mapping(address => uint) private balances;
54 	mapping(address => mapping(address => uint)) private allowed;
55 
56 	// EIP 2612
57 	bytes32 public DOMAIN_SEPARATOR;
58 	// keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
59 	bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
60 	mapping(address => uint) public nonces;
61 
62 	// ERC20 events
63 	event Approval(address indexed owner, address indexed spender, uint amount);
64 	event Transfer(address indexed from, address indexed to, uint amount);
65 
66 	// ERC20 methods
67 	function balanceOf(address owner) external view returns (uint balance) {
68 		return balances[owner];
69 	}
70 
71 	function transfer(address to, uint amount) external returns (bool success) {
72 		require(to != address(this), "BAD_ADDRESS");
73 		balances[msg.sender] = balances[msg.sender] - amount;
74 		balances[to] = balances[to] + amount;
75 		emit Transfer(msg.sender, to, amount);
76 		return true;
77 	}
78 
79 	function transferFrom(address from, address to, uint amount) external returns (bool success) {
80 		balances[from] = balances[from] - amount;
81 		allowed[from][msg.sender] = allowed[from][msg.sender] - amount;
82 		balances[to] = balances[to] + amount;
83 		emit Transfer(from, to, amount);
84 		return true;
85 	}
86 
87 	function approve(address spender, uint amount) external returns (bool success) {
88 		allowed[msg.sender][spender] = amount;
89 		emit Approval(msg.sender, spender, amount);
90 		return true;
91 	}
92 
93 	function allowance(address owner, address spender) external view returns (uint remaining) {
94 		return allowed[owner][spender];
95 	}
96 
97 	// EIP 2612
98 	function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
99 		require(deadline >= block.timestamp, "DEADLINE_EXPIRED");
100 		bytes32 digest = keccak256(abi.encodePacked(
101 			"\x19\x01",
102 			DOMAIN_SEPARATOR,
103 			keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline))
104 		));
105 		address recoveredAddress = ecrecover(digest, v, r, s);
106 		require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNATURE");
107 		allowed[owner][spender] = amount;
108 		emit Approval(owner, spender, amount);
109 	}
110 
111 	// Inner
112 	function innerMint(address owner, uint amount) internal {
113 		totalSupply = totalSupply + amount;
114 		balances[owner] = balances[owner] + amount;
115 		// Because of https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
116 		emit Transfer(address(0), owner, amount);
117 	}
118 	function innerBurn(address owner, uint amount) internal {
119 		totalSupply = totalSupply - amount;
120 		balances[owner] = balances[owner] - amount;
121 		emit Transfer(owner, address(0), amount);
122 	}
123 
124 	// Pool functionality
125 	uint public timeToUnbond = 20 days;
126 	uint public rageReceivedPromilles = 700;
127 
128 	IUniswapSimple public uniswap; // = IUniswapSimple(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
129 	IChainlink public ADXUSDOracle; // = IChainlink(0x231e764B44b2C1b7Ca171fa8021A24ed520Cde10);
130 
131 	IADXToken public immutable ADXToken;
132 	address public guardian;
133 	address public validator;
134 	address public governance;
135 
136 	// claim token whitelist: normally claim tokens are stablecoins
137 	// eg Tether (0xdAC17F958D2ee523a2206206994597C13D831ec7)
138 	mapping (address => bool) public whitelistedClaimTokens;
139 
140 	// Commitment ID against the max amount of tokens it will pay out
141 	mapping (bytes32 => uint) public commitments;
142 	// How many of a user's shares are locked
143 	mapping (address => uint) public lockedShares;
144 	// Unbonding commitment from a staker
145 	struct UnbondCommitment {
146 		address owner;
147 		uint shares;
148 		uint unlocksAt;
149 	}
150 
151 	// claims/penalizations limits
152 	uint public maxDailyPenaltiesPromilles;
153 	uint public limitLastReset;
154 	uint public limitRemaining;
155 
156 	// Staking pool events
157 	// LogLeave/LogWithdraw must begin with the UnbondCommitment struct
158 	event LogLeave(address indexed owner, uint shares, uint unlocksAt, uint maxTokens);
159 	event LogWithdraw(address indexed owner, uint shares, uint unlocksAt, uint maxTokens, uint receivedTokens);
160 	event LogRageLeave(address indexed owner, uint shares, uint maxTokens, uint receivedTokens);
161 	event LogNewGuardian(address newGuardian);
162 	event LogClaim(address tokenAddr, address to, uint amountInUSD, uint burnedValidatorShares, uint usedADX, uint totalADX, uint totalShares);
163 	event LogPenalize(uint burnedADX);
164 
165 	constructor(IADXToken token, IUniswapSimple uni, IChainlink oracle, address guardianAddr, address validatorStakingWallet, address governanceAddr, address claimToken) {
166 		ADXToken = token;
167 		uniswap = uni;
168 		ADXUSDOracle = oracle;
169 		guardian = guardianAddr;
170 		validator = validatorStakingWallet;
171 		governance = governanceAddr;
172 		whitelistedClaimTokens[claimToken] = true;
173 
174 		// EIP 2612
175 		uint chainId;
176 		assembly {
177 			chainId := chainid()
178 		}
179 		DOMAIN_SEPARATOR = keccak256(
180 			abi.encode(
181 				keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
182 				keccak256(bytes(name)),
183 				keccak256(bytes("1")),
184 				chainId,
185 				address(this)
186 			)
187 		);
188 	}
189 
190 	// Governance functions
191 	function setGovernance(address addr) external {
192 		require(governance == msg.sender, "NOT_GOVERNANCE");
193 		governance = addr;
194 	}
195 	function setDailyPenaltyMax(uint max) external {
196 		require(governance == msg.sender, "NOT_GOVERNANCE");
197 		require(max <= 200, "DAILY_PENALTY_TOO_LARGE");
198 		maxDailyPenaltiesPromilles = max;
199 		resetLimits();
200 	}
201 	function setRageReceived(uint rageReceived) external {
202 		require(governance == msg.sender, "NOT_GOVERNANCE");
203 		// AUDIT: should there be a minimum here?
204 		require(rageReceived <= 1000, "TOO_LARGE");
205 		rageReceivedPromilles = rageReceived;
206 	}
207 	function setTimeToUnbond(uint time) external {
208 		require(governance == msg.sender, "NOT_GOVERNANCE");
209 		require(time >= 1 days && time <= 30 days, "BOUNDS");
210 		timeToUnbond = time;
211 	}
212 	function setGuardian(address newGuardian) external {
213 		require(governance == msg.sender, "NOT_GOVERNANCE");
214 		guardian = newGuardian;
215 		emit LogNewGuardian(newGuardian);
216 	}
217 	function setWhitelistedClaimToken(address token, bool whitelisted) external {
218 		require(governance == msg.sender, "NOT_GOVERNANCE");
219 		whitelistedClaimTokens[token] = whitelisted;
220 	}
221 
222 	// Pool stuff
223 	function shareValue() external view returns (uint) {
224 		if (totalSupply == 0) return 0;
225 		return ((ADXToken.balanceOf(address(this)) + ADXToken.supplyController().mintableIncentive(address(this)))
226 			* 1e18)
227 			/ totalSupply;
228 	}
229 
230 	function innerEnter(address recipient, uint amount) internal {
231 		// Please note that minting has to be in the beginning so that we take it into account
232 		// when using ADXToken.balanceOf()
233 		// Minting makes an external call but it"s to a trusted contract (ADXToken)
234 		ADXToken.supplyController().mintIncentive(address(this));
235 
236 		uint totalADX = ADXToken.balanceOf(address(this));
237 
238 		// The totalADX == 0 check here should be redudnant; the only way to get totalSupply to a nonzero val is by adding ADX
239 		if (totalSupply == 0 || totalADX == 0) {
240 			innerMint(recipient, amount);
241 		} else {
242 			uint256 newShares = (amount * totalSupply) / totalADX;
243 			innerMint(recipient, newShares);
244 		}
245 		require(ADXToken.transferFrom(msg.sender, address(this), amount));
246 		// no events, as innerMint already emits enough to know the shares amount and price
247 	}
248 
249 	function enter(uint amount) external {
250 		innerEnter(msg.sender, amount);
251 	}
252 
253 	function enterTo(address recipient, uint amount) external {
254 		innerEnter(recipient, amount);
255 	}
256 
257 	function unbondingCommitmentWorth(address owner, uint shares, uint unlocksAt) external view returns (uint) {
258 		if (totalSupply == 0) return 0;
259 		bytes32 commitmentId = keccak256(abi.encode(UnbondCommitment({ owner: owner, shares: shares, unlocksAt: unlocksAt })));
260 		uint maxTokens = commitments[commitmentId];
261 		uint totalADX = ADXToken.balanceOf(address(this));
262 		uint currentTokens = (shares * totalADX) / totalSupply;
263 		return currentTokens > maxTokens ? maxTokens : currentTokens;
264 	}
265 
266 	function leave(uint shares, bool skipMint) external {
267 		if (!skipMint) ADXToken.supplyController().mintIncentive(address(this));
268 
269 		require(shares <= balances[msg.sender] - lockedShares[msg.sender], "INSUFFICIENT_SHARES");
270 		uint totalADX = ADXToken.balanceOf(address(this));
271 		uint maxTokens = (shares * totalADX) / totalSupply;
272 		uint unlocksAt = block.timestamp + timeToUnbond;
273 		bytes32 commitmentId = keccak256(abi.encode(UnbondCommitment({ owner: msg.sender, shares: shares, unlocksAt: unlocksAt })));
274 		require(commitments[commitmentId] == 0, "COMMITMENT_EXISTS");
275 
276 		commitments[commitmentId] = maxTokens;
277 		lockedShares[msg.sender] += shares;
278 
279 		emit LogLeave(msg.sender, shares, unlocksAt, maxTokens);
280 	}
281 
282 	function withdraw(uint shares, uint unlocksAt, bool skipMint) external {
283 		if (!skipMint) ADXToken.supplyController().mintIncentive(address(this));
284 
285 		require(block.timestamp > unlocksAt, "UNLOCK_TOO_EARLY");
286 		bytes32 commitmentId = keccak256(abi.encode(UnbondCommitment({ owner: msg.sender, shares: shares, unlocksAt: unlocksAt })));
287 		uint maxTokens = commitments[commitmentId];
288 		require(maxTokens > 0, "NO_COMMITMENT");
289 		uint totalADX = ADXToken.balanceOf(address(this));
290 		uint currentTokens = (shares * totalADX) / totalSupply;
291 		uint receivedTokens = currentTokens > maxTokens ? maxTokens : currentTokens;
292 
293 		commitments[commitmentId] = 0;
294 		lockedShares[msg.sender] -= shares;
295 
296 		innerBurn(msg.sender, shares);
297 		require(ADXToken.transfer(msg.sender, receivedTokens));
298 
299 		emit LogWithdraw(msg.sender, shares, unlocksAt, maxTokens, receivedTokens);
300 	}
301 
302 	function rageLeave(uint shares, bool skipMint) external {
303 		if (!skipMint) ADXToken.supplyController().mintIncentive(address(this));
304 
305 		uint totalADX = ADXToken.balanceOf(address(this));
306 		uint adxAmount = (shares * totalADX) / totalSupply;
307 		uint receivedTokens = (adxAmount * rageReceivedPromilles) / 1000;
308 		innerBurn(msg.sender, shares);
309 		require(ADXToken.transfer(msg.sender, receivedTokens));
310 
311 		emit LogRageLeave(msg.sender, shares, adxAmount, receivedTokens);
312 	}
313 
314 	// Insurance mechanism
315 	// In case something goes wrong, this can be used to recoup funds
316 	// As of V5, the idea is to use it to provide some interest (eg 10%) for late refunds, in case channels get stuck and have to wait through their challenge period
317 	function claim(address tokenOut, address to, uint amount) external {
318 		require(msg.sender == guardian, "NOT_GUARDIAN");
319 
320 		// start by resetting claim/penalty limits
321 		resetLimits();
322 
323 		// NOTE: minting is intentionally skipped here
324 		// This means that a validator may be punished a bit more when burning their shares,
325 		// but it guarantees that claim() always works
326 		uint totalADX = ADXToken.balanceOf(address(this));
327 
328 		// Note: whitelist of tokenOut tokens
329 		require(whitelistedClaimTokens[tokenOut], "TOKEN_NOT_WHITELISTED");
330 
331 		address[] memory path = new address[](3);
332 		path[0] = address(ADXToken);
333 		path[1] = uniswap.WETH();
334 		path[2] = tokenOut;
335 
336 		// You may think the Uniswap call enables reentrancy, but reentrancy is a problem only if the pattern is check-call-modify, not call-check-modify as is here
337 		// there"s no case in which we "double-spend" a value
338 		// Plus, ADX, USDT and uniswap are all trusted
339 
340 		// Slippage protection; 5% slippage allowed
341 		uint price = ADXUSDOracle.latestAnswer();
342 		// chainlink price is in 1e8
343 		// for example, if the amount is in 1e6;
344 		// we need to convert from 1e6 to 1e18 (adx) but we divide by 1e8 (price); 18 - 6 + 8 ; verified this by calculating manually
345 		uint multiplier = 1.05e26 / (10 ** IERCDecimals(tokenOut).decimals());
346 		uint adxAmountMax = (amount * multiplier) / price;
347 		require(adxAmountMax < totalADX, "INSUFFICIENT_ADX");
348 		uint[] memory amounts = uniswap.swapTokensForExactTokens(amount, adxAmountMax, path, to, block.timestamp);
349 
350 		// calculate the total ADX amount used in the swap
351 		uint adxAmountUsed = amounts[0];
352 
353 		// burn the validator shares so that they pay for it first, before dilluting other holders
354 		// calculate the worth in ADX of the validator"s shares
355 		uint sharesNeeded = (adxAmountUsed * totalSupply) / totalADX;
356 		uint toBurn = sharesNeeded < balances[validator] ? sharesNeeded : balances[validator];
357 		if (toBurn > 0) innerBurn(validator, toBurn);
358 
359 		// Technically redundant cause we"ll fail on the subtraction, but we"re doing this for better err msgs
360 		require(limitRemaining >= adxAmountUsed, "LIMITS");
361 		limitRemaining -= adxAmountUsed;
362 
363 		emit LogClaim(tokenOut, to, amount, toBurn, adxAmountUsed, totalADX, totalSupply);
364 	}
365 
366 	function penalize(uint adxAmount) external {
367 		require(msg.sender == guardian, "NOT_GUARDIAN");
368 		// AUDIT: we can do getLimitRemaining() instead of resetLimits() that returns the remaining limit
369 		resetLimits();
370 		// Technically redundant cause we'll fail on the subtraction, but we're doing this for better err msgs
371 		require(limitRemaining >= adxAmount, "LIMITS");
372 		limitRemaining -= adxAmount;
373 		require(ADXToken.transfer(address(0), adxAmount));
374 		emit LogPenalize(adxAmount);
375 	}
376 
377 	function resetLimits() internal {
378 		if (block.timestamp - limitLastReset > 24 hours) {
379 			limitLastReset = block.timestamp;
380 			limitRemaining = (ADXToken.balanceOf(address(this)) * maxDailyPenaltiesPromilles) / 1000;
381 		}
382 	}
383 }