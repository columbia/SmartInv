1 pragma solidity 0.4.24;
2 
3 
4 // @title Abstract ERC20 token interface
5 contract AbstractToken {
6 	function balanceOf(address owner) public view returns (uint256 balance);
7 	function transfer(address to, uint256 value) public returns (bool success);
8 	function transferFrom(address from, address to, uint256 value) public returns (bool success);
9 	function approve(address spender, uint256 value) public returns (bool success);
10 	function allowance(address owner, address spender) public view returns (uint256 remaining);
11 
12 	event Transfer(address indexed from, address indexed to, uint256 value);
13 	event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 
17 /// @title Owned - Add an owner to the contract.
18 contract Owned {
19 
20 	address public owner = msg.sender;
21 	address public potentialOwner;
22 
23 	modifier onlyOwner {
24 		require(msg.sender == owner);
25 		_;
26 	}
27 
28 	modifier onlyPotentialOwner {
29 		require(msg.sender == potentialOwner);
30 		_;
31 	}
32 
33 	event NewOwner(address old, address current);
34 	event NewPotentialOwner(address old, address potential);
35 
36 	function setOwner(address _new)
37 		public
38 		onlyOwner
39 	{
40 		emit NewPotentialOwner(owner, _new);
41 		potentialOwner = _new;
42 	}
43 
44 	function confirmOwnership()
45 		public
46 		onlyPotentialOwner
47 	{
48 		emit NewOwner(owner, potentialOwner);
49 		owner = potentialOwner;
50 		potentialOwner = address(0);
51 	}
52 }
53 
54 
55 /// @title SafeMath contract - Math operations with safety checks.
56 /// @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
57 library SafeMath {
58 	/**
59 	* @dev Multiplies two numbers, throws on overflow.
60 	*/
61 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
62 		if (a == 0) {
63 			return 0;
64 		}
65 		c = a * b;
66 		assert(c / a == b);
67 		return c;
68 	}
69 
70 	/**
71 	* @dev Integer division of two numbers, truncating the quotient.
72 	*/
73 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
74 		return a / b;
75 	}
76 
77 	/**
78 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79 	*/
80 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81 		assert(b <= a);
82 		return a - b;
83 	}
84 
85 	/**
86 	* @dev Adds two numbers, throws on overflow.
87 	*/
88 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
89 		c = a + b;
90 		assert(c >= a);
91 		return c;
92 	}
93 }
94 
95 
96 /// @title StandardToken - Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
97 /// @author Zerion - <inbox@zerion.io>
98 contract StandardToken is AbstractToken, Owned {
99 	using SafeMath for uint256;
100 
101 	/*
102 	 *  Data structures
103 	 */
104 	mapping (address => uint256) internal balances;
105 	mapping (address => mapping (address => uint256)) internal allowed;
106 	uint256 public totalSupply;
107 
108 	/*
109 	 *  Read and write storage functions
110 	 */
111 	/// @dev Transfers sender's tokens to a given address. Returns success.
112 	/// @param _to Address of token receiver.
113 	/// @param _value Number of tokens to transfer.
114 	function transfer(address _to, uint256 _value) public returns (bool success) {
115 		return _transfer(msg.sender, _to, _value);
116 	}
117 
118 	/// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
119 	/// @param _from Address from where tokens are withdrawn.
120 	/// @param _to Address to where tokens are sent.
121 	/// @param _value Number of tokens to transfer.
122 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123 		require(_value <= allowed[_from][msg.sender]);
124 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125 		return _transfer(_from, _to, _value);
126 	}
127 
128 	/// @dev Returns number of tokens owned by given address.
129 	/// @param _owner Address of token owner.
130 	function balanceOf(address _owner) public view returns (uint256 balance) {
131 		return balances[_owner];
132 	}
133 
134 	/// @dev Sets approved amount of tokens for spender. Returns success.
135 	/// @param _spender Address of allowed account.
136 	/// @param _value Number of approved tokens.
137 	function approve(address _spender, uint256 _value) public returns (bool success) {
138 		allowed[msg.sender][_spender] = _value;
139 		emit Approval(msg.sender, _spender, _value);
140 		return true;
141 	}
142 
143 	/*
144 	 * Read storage functions
145 	 */
146 	/// @dev Returns number of allowed tokens for given address.
147 	/// @param _owner Address of token owner.
148 	/// @param _spender Address of token spender.
149 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
150 		return allowed[_owner][_spender];
151 	}
152 
153 	/**
154 	* @dev Private transfer, can only be called by this contract.
155 	* @param _from The address of the sender.
156 	* @param _to The address of the recipient.
157 	* @param _value The amount to send.
158 	* @return success True if the transfer was successful, or throws.
159 	*/
160 	function _transfer(address _from, address _to, uint256 _value) private returns (bool success) {
161 		require(_value <= balances[_from]);
162 		require(_to != address(0));
163 
164 		balances[_from] = balances[_from].sub(_value);
165 		balances[_to] = balances[_to].add(_value);
166 		emit Transfer(_from, _to, _value);
167 		return true;
168 	}
169 }
170 
171 
172 /// @title BurnableToken contract - Implements burnable functionality of the ERC-20 token
173 /// @author Zerion - <inbox@zerion.io>
174 contract BurnableToken is StandardToken {
175 
176 	address public burner;
177 
178 	modifier onlyBurner {
179 		require(msg.sender == burner);
180 		_;
181 	}
182 
183 	event NewBurner(address burner);
184 
185 	function setBurner(address _burner)
186 		public
187 		onlyOwner
188 	{
189 		burner = _burner;
190 		emit NewBurner(_burner);
191 	}
192 
193 	function burn(uint256 amount)
194 		public
195 		onlyBurner
196 	{
197 		require(balanceOf(msg.sender) >= amount);
198 		balances[msg.sender] = balances[msg.sender].sub(amount);
199 		totalSupply = totalSupply.sub(amount);
200 		emit Transfer(msg.sender, address(0x0000000000000000000000000000000000000000), amount);
201 	}
202 }
203 
204 
205 /// @title Token contract - Implements Standard ERC20 with additional features.
206 /// @author Zerion - <inbox@zerion.io>
207 contract Token is BurnableToken {
208 
209 	// Time of the contract creation
210 	uint256 public creationTime;
211 
212 	constructor() public {
213 		/* solium-disable-next-line security/no-block-members */
214 		creationTime = now;
215 	}
216 
217 	/// @dev Owner can transfer out any accidentally sent ERC20 tokens
218 	function transferERC20Token(AbstractToken _token, address _to, uint256 _value)
219 		public
220 		onlyOwner
221 		returns (bool success)
222 	{
223 		require(_token.balanceOf(address(this)) >= _value);
224 		uint256 receiverBalance = _token.balanceOf(_to);
225 		require(_token.transfer(_to, _value));
226 
227 		uint256 receiverNewBalance = _token.balanceOf(_to);
228 		assert(receiverNewBalance == receiverBalance.add(_value));
229 
230 		return true;
231 	}
232 
233 	/// @dev Increases approved amount of tokens for spender. Returns success.
234 	function increaseApproval(address _spender, uint256 _value) public returns (bool success) {
235 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
236 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237 		return true;
238 	}
239 
240 	/// @dev Decreases approved amount of tokens for spender. Returns success.
241 	function decreaseApproval(address _spender, uint256 _value) public returns (bool success) {
242 		uint256 oldValue = allowed[msg.sender][_spender];
243 		if (_value > oldValue) {
244 			allowed[msg.sender][_spender] = 0;
245 		} else {
246 			allowed[msg.sender][_spender] = oldValue.sub(_value);
247 		}
248 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249 		return true;
250 	}
251 }
252 
253 /// @title Token contract - Implements Standard ERC20 Token for Inmediate project.
254 /// @author Zerion - <inbox@zerion.io>
255 contract InmediateToken is Token {
256 
257 	/// TOKEN META DATA
258 	string constant public name = 'Inmediate';
259 	string constant public symbol = 'DIT';
260 	uint8  constant public decimals = 8;
261 
262 
263 	/// ALLOCATIONS
264 	// To calculate vesting periods we assume that 1 month is always equal to 30 days 
265 
266 
267 	/*** Initial Investors' tokens ***/
268 
269 	// 400,000,000 (40%) tokens are distributed among initial investors
270 	// These tokens will be distributed without vesting
271 
272 	address public investorsAllocation = address(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
273 	uint256 public investorsTotal = 400000000e8;
274 
275 
276 	/*** Tokens reserved for the Inmediate team ***/
277 
278 	// 100,000,000 (10%) tokens will be eventually available for the team
279 	// These tokens will be distributed querterly after a 6 months cliff
280 	// 20,000,000 will be unlocked immediately after 6 months
281 	// 10,000,000 tokens will be unlocked quarterly within 2 years after the cliff
282 
283 	address public teamAllocation  = address(0x1111111111111111111111111111111111111111);
284 	uint256 public teamTotal = 100000000e8;
285 	uint256 public teamPeriodAmount = 10000000e8;
286 	uint256 public teamCliff = 6 * 30 days;
287 	uint256 public teamUnlockedAfterCliff = 20000000e8;
288 	uint256 public teamPeriodLength = 3 * 30 days;
289 	uint8   public teamPeriodsNumber = 8;
290 
291 	/*** Tokens reserved for Advisors ***/
292 
293 	// 50,000,000 (5%) tokens will be eventually available for advisors
294 	// These tokens will be distributed querterly after a 6 months cliff
295 	// 10,000,000 will be unlocked immediately after 6 months
296 	// 10,000,000 tokens will be unlocked quarterly within a year after the cliff
297 
298 	address public advisorsAllocation  = address(0x2222222222222222222222222222222222222222);
299 	uint256 public advisorsTotal = 50000000e8;
300 	uint256 public advisorsPeriodAmount = 10000000e8;
301 	uint256 public advisorsCliff = 6 * 30 days;
302 	uint256 public advisorsUnlockedAfterCliff = 10000000e8;
303 	uint256 public advisorsPeriodLength = 3 * 30 days;
304 	uint8   public advisorsPeriodsNumber = 4;
305 
306 
307 	/*** Tokens reserved for pre- and post- ICO Bounty ***/
308 
309 	// 50,000,000 (5%) tokens will be spent on various bounty campaigns
310 	// These tokens are available immediately, without vesting
311 
312 
313 	address public bountyAllocation  = address(0x3333333333333333333333333333333333333333);
314 	uint256 public bountyTotal = 50000000e8;
315 
316 
317 	/*** Liquidity pool ***/
318 
319 	// 150,000,000 (15%) tokens will be used to manage token volatility
320 	// These tokens are available immediately, without vesting
321 
322 
323 	address public liquidityPoolAllocation  = address(0x4444444444444444444444444444444444444444);
324 	uint256 public liquidityPoolTotal = 150000000e8;
325 
326 
327 	/*** Tokens reserved for Contributors ***/
328 
329 	// 250,000,000 (25%) tokens will be used to reward parties that contribute to the ecosystem
330 	// These tokens are available immediately, without vesting
331 
332 
333 	address public contributorsAllocation  = address(0x5555555555555555555555555555555555555555);
334 	uint256 public contributorsTotal = 250000000e8;
335 
336 
337 	/// CONSTRUCTOR
338 
339 	constructor() public {
340 		//  Overall, 1,000,000,000 tokens exist
341 		totalSupply = 1000000000e8;
342 
343 		balances[investorsAllocation] = investorsTotal;
344 		balances[teamAllocation] = teamTotal;
345 		balances[advisorsAllocation] = advisorsTotal;
346 		balances[bountyAllocation] = bountyTotal;
347 		balances[liquidityPoolAllocation] = liquidityPoolTotal;
348 		balances[contributorsAllocation] = contributorsTotal;
349 		
350 
351 		// Unlock some tokens without vesting
352 		allowed[investorsAllocation][msg.sender] = investorsTotal;
353 		allowed[bountyAllocation][msg.sender] = bountyTotal;
354 		allowed[liquidityPoolAllocation][msg.sender] = liquidityPoolTotal;
355 		allowed[contributorsAllocation][msg.sender] = contributorsTotal;
356 	}
357 
358 	/// DISTRIBUTION
359 
360 	function distributeInvestorsTokens(address _to, uint256 _amountWithDecimals)
361 		public
362 		onlyOwner
363 	{
364 		require(transferFrom(investorsAllocation, _to, _amountWithDecimals));
365 	}
366 
367 	/// VESTED ALLOCATIONS
368 
369 	function withdrawTeamTokens(address _to, uint256 _amountWithDecimals)
370 		public
371 		onlyOwner 
372 	{
373 		allowed[teamAllocation][msg.sender] = allowance(teamAllocation, msg.sender);
374 		require(transferFrom(teamAllocation, _to, _amountWithDecimals));
375 	}
376 
377 	function withdrawAdvisorsTokens(address _to, uint256 _amountWithDecimals)
378 		public
379 		onlyOwner 
380 	{
381 		allowed[advisorsAllocation][msg.sender] = allowance(advisorsAllocation, msg.sender);
382 		require(transferFrom(advisorsAllocation, _to, _amountWithDecimals));
383 	}
384 
385 
386 	/// UNVESTED ALLOCATIONS
387 
388 	function withdrawBountyTokens(address _to, uint256 _amountWithDecimals)
389 		public
390 		onlyOwner
391 	{
392 		require(transferFrom(bountyAllocation, _to, _amountWithDecimals));
393 	}
394 
395 	function withdrawLiquidityPoolTokens(address _to, uint256 _amountWithDecimals)
396 		public
397 		onlyOwner
398 	{
399 		require(transferFrom(liquidityPoolAllocation, _to, _amountWithDecimals));
400 	}
401 
402 	function withdrawContributorsTokens(address _to, uint256 _amountWithDecimals)
403 		public
404 		onlyOwner
405 	{
406 		require(transferFrom(contributorsAllocation, _to, _amountWithDecimals));
407 	}
408 	
409 	/// OVERRIDEN FUNCTIONS
410 
411 	/// @dev Overrides StandardToken.sol function
412 	function allowance(address _owner, address _spender)
413 		public
414 		view
415 		returns (uint256 remaining)
416 	{   
417 		if (_spender != owner) {
418 			return allowed[_owner][_spender];
419 		}
420 
421 		uint256 unlockedTokens;
422 		uint256 spentTokens;
423 
424 		if (_owner == teamAllocation) {
425 			unlockedTokens = _calculateUnlockedTokens(
426 				teamCliff, teamUnlockedAfterCliff,
427 				teamPeriodLength, teamPeriodAmount, teamPeriodsNumber
428 			);
429 			spentTokens = balanceOf(teamAllocation) < teamTotal ? teamTotal.sub(balanceOf(teamAllocation)) : 0;
430 		} else if (_owner == advisorsAllocation) {
431 			unlockedTokens = _calculateUnlockedTokens(
432 				advisorsCliff, advisorsUnlockedAfterCliff,
433 				advisorsPeriodLength, advisorsPeriodAmount, advisorsPeriodsNumber
434 			);
435 			spentTokens = balanceOf(advisorsAllocation) < advisorsTotal ? advisorsTotal.sub(balanceOf(advisorsAllocation)) : 0;
436 		} else {
437 			return allowed[_owner][_spender];
438 		}
439 
440 		return unlockedTokens.sub(spentTokens);
441 	}
442 
443 	/// @dev Overrides Owned.sol function
444 	function confirmOwnership()
445 		public
446 		onlyPotentialOwner
447 	{   
448 		// Forbids the old owner to distribute investors' tokens
449 		allowed[investorsAllocation][owner] = 0;
450 
451 		// Allows the new owner to distribute investors' tokens
452 		allowed[investorsAllocation][msg.sender] = balanceOf(investorsAllocation);
453 
454 		// Forbidsthe old owner to withdraw any tokens from the reserves
455 		allowed[teamAllocation][owner] = 0;
456 		allowed[advisorsAllocation][owner] = 0;
457 		allowed[bountyAllocation][owner] = 0;
458 		allowed[liquidityPoolAllocation][owner] = 0;
459 		allowed[contributorsAllocation][owner] = 0;
460 
461 		// Allows the new owner to withdraw tokens from the unvested allocations
462 		allowed[bountyAllocation][msg.sender] = balanceOf(bountyAllocation);
463 		allowed[liquidityPoolAllocation][msg.sender] = balanceOf(liquidityPoolAllocation);
464 		allowed[contributorsAllocation][msg.sender] = balanceOf(contributorsAllocation);
465 		
466 		super.confirmOwnership();
467 	}
468 
469 	/// PRIVATE FUNCTIONS
470 
471 	function _calculateUnlockedTokens(
472 		uint256 _cliff,
473 		uint256 _unlockedAfterCliff,
474 		uint256 _periodLength,
475 		uint256 _periodAmount,
476 		uint8 _periodsNumber
477 	)
478 		private
479 		view
480 		returns (uint256) 
481 	{
482 		/* solium-disable-next-line security/no-block-members */
483 		if (now < creationTime.add(_cliff)) {
484 			return 0;
485 		}
486 		/* solium-disable-next-line security/no-block-members */
487 		uint256 periods = now.sub(creationTime.add(_cliff)).div(_periodLength);
488 		periods = periods > _periodsNumber ? _periodsNumber : periods;
489 		return _unlockedAfterCliff.add(periods.mul(_periodAmount));
490 	}
491 }