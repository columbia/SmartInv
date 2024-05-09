1 pragma solidity 0.4.23;
2 
3 //
4 // This source file is part of the current-contracts open source project
5 // Copyright 2018 Zerion LLC
6 // Licensed under Apache License v2.0
7 //
8 
9 
10 // @title Abstract ERC20 token interface
11 contract AbstractToken {
12 	function balanceOf(address owner) public view returns (uint256 balance);
13 	function transfer(address to, uint256 value) public returns (bool success);
14 	function transferFrom(address from, address to, uint256 value) public returns (bool success);
15 	function approve(address spender, uint256 value) public returns (bool success);
16 	function allowance(address owner, address spender) public view returns (uint256 remaining);
17 
18 	event Transfer(address indexed from, address indexed to, uint256 value);
19 	event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 contract Owned {
23 
24 	address public owner = msg.sender;
25 	address public potentialOwner;
26 
27 	modifier onlyOwner {
28 		require(msg.sender == owner);
29 		_;
30 	}
31 
32 	modifier onlyPotentialOwner {
33 		require(msg.sender == potentialOwner);
34 		_;
35 	}
36 
37 	event NewOwner(address old, address current);
38 	event NewPotentialOwner(address old, address potential);
39 
40 	function setOwner(address _new)
41 		public
42 		onlyOwner
43 	{
44 		emit NewPotentialOwner(owner, _new);
45 		potentialOwner = _new;
46 	}
47 
48 	function confirmOwnership()
49 		public
50 		onlyPotentialOwner
51 	{
52 		emit NewOwner(owner, potentialOwner);
53 		owner = potentialOwner;
54 		potentialOwner = address(0);
55 	}
56 }
57 
58 // @title SafeMath contract - Math operations with safety checks.
59 // @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
60 contract SafeMath {
61 	/**
62 	* @dev Multiplies two numbers, throws on overflow.
63 	*/
64 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65 		if (a == 0) {
66 			return 0;
67 		}
68 		uint256 c = a * b;
69 		assert(c / a == b);
70 		return c;
71 	}
72 
73 	/**
74 	* @dev Integer division of two numbers, truncating the quotient.
75 	*/
76 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
77 		return a / b;
78 	}
79 
80 	/**
81 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82 	*/
83 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84 		assert(b <= a);
85 		return a - b;
86 	}
87 
88 	/**
89 	* @dev Adds two numbers, throws on overflow.
90 	*/
91 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
92 		uint256 c = a + b;
93 		assert(c >= a);
94 		return c;
95 	}
96 
97 	/**
98 	* @dev Raises `a` to the `b`th power, throws on overflow.
99 	*/
100 	function pow(uint256 a, uint256 b) internal pure returns (uint256) {
101 		uint256 c = a ** b;
102 		assert(c >= a);
103 		return c;
104 	}
105 }
106 
107 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
108 contract StandardToken is AbstractToken, Owned, SafeMath {
109 
110 	/*
111 	 *  Data structures
112 	 */
113 	mapping (address => uint256) internal balances;
114 	mapping (address => mapping (address => uint256)) internal allowed;
115 	uint256 public totalSupply;
116 
117 	/*
118 	 *  Read and write storage functions
119 	 */
120 	/// @dev Transfers sender's tokens to a given address. Returns success.
121 	/// @param _to Address of token receiver.
122 	/// @param _value Number of tokens to transfer.
123 	function transfer(address _to, uint256 _value) public returns (bool success) {
124 		return _transfer(msg.sender, _to, _value);
125 	}
126 
127 	/// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
128 	/// @param _from Address from where tokens are withdrawn.
129 	/// @param _to Address to where tokens are sent.
130 	/// @param _value Number of tokens to transfer.
131 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132 		require(allowed[_from][msg.sender] >= _value);
133 		allowed[_from][msg.sender] -= _value;
134 
135 		return _transfer(_from, _to, _value);
136 	}
137 
138 	/// @dev Returns number of tokens owned by given address.
139 	/// @param _owner Address of token owner.
140 	function balanceOf(address _owner) public view returns (uint256 balance) {
141 		return balances[_owner];
142 	}
143 
144 	/// @dev Sets approved amount of tokens for spender. Returns success.
145 	/// @param _spender Address of allowed account.
146 	/// @param _value Number of approved tokens.
147 	function approve(address _spender, uint256 _value) public returns (bool success) {
148 		allowed[msg.sender][_spender] = _value;
149 		emit Approval(msg.sender, _spender, _value);
150 		return true;
151 	}
152 
153 	/*
154 	 * Read storage functions
155 	 */
156 	/// @dev Returns number of allowed tokens for given address.
157 	/// @param _owner Address of token owner.
158 	/// @param _spender Address of token spender.
159 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
160 		return allowed[_owner][_spender];
161 	}
162 
163 	/**
164 	* @dev Private transfer, can only be called by this contract.
165 	* @param _from The address of the sender.
166 	* @param _to The address of the recipient.
167 	* @param _value The amount to send.
168 	* @return success True if the transfer was successful, or throws.
169 	*/
170 	function _transfer(address _from, address _to, uint256 _value) private returns (bool success) {
171 		require(_to != address(0));
172 		require(balances[_from] >= _value);
173 		balances[_from] -= _value;
174 		balances[_to] = add(balances[_to], _value);
175 		emit Transfer(_from, _to, _value);
176 		return true;
177 	}
178 }
179 
180 /// @title Token contract - Implements Standard ERC20 with additional features.
181 /// @author Zerion - <inbox@zerion.io>
182 contract Token is StandardToken {
183 
184 	// Time of the contract creation
185 	uint256 public creationTime;
186 
187 	function Token() public {
188 		/* solium-disable-next-line security/no-block-members */
189 		creationTime = now;
190 	}
191 
192 	/// @dev Owner can transfer out any accidentally sent ERC20 tokens
193 	function transferERC20Token(AbstractToken _token, address _to, uint256 _value)
194 		public
195 		onlyOwner
196 		returns (bool success)
197 	{
198 		require(_token.balanceOf(address(this)) >= _value);
199 		uint256 receiverBalance = _token.balanceOf(_to);
200 		require(_token.transfer(_to, _value));
201 
202 		uint256 receiverNewBalance = _token.balanceOf(_to);
203 		assert(receiverNewBalance == add(receiverBalance, _value));
204 
205 		return true;
206 	}
207 
208 	/// @dev Increases approved amount of tokens for spender. Returns success.
209 	function increaseApproval(address _spender, uint256 _value) public returns (bool success) {
210 		allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _value);
211 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212 		return true;
213 	}
214 
215 	/// @dev Decreases approved amount of tokens for spender. Returns success.
216 	function decreaseApproval(address _spender, uint256 _value) public returns (bool success) {
217 		uint256 oldValue = allowed[msg.sender][_spender];
218 		if (_value > oldValue) {
219 			allowed[msg.sender][_spender] = 0;
220 		} else {
221 			allowed[msg.sender][_spender] = sub(oldValue, _value);
222 		}
223 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224 		return true;
225 	}
226 }
227 
228 // @title Token contract - Implements Standard ERC20 Token for NEXO project.
229 /// @author Zerion - <inbox@zerion.io>
230 contract NexoToken is Token {
231 
232 	/// TOKEN META DATA
233 	string constant public name = 'Nexo';
234 	string constant public symbol = 'NEXO';
235 	uint8  constant public decimals = 18;
236 
237 
238 	/// ALOCATIONS
239 	// To calculate vesting periods we assume that 1 month is always equal to 30 days 
240 
241 
242 	/*** Initial Investors' tokens ***/
243 
244 	// 525,000,000 (52.50%) tokens are distributed among initial investors
245 	// These tokens will be distributed without vesting
246 
247 	address public investorsAllocation = address(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
248 	uint256 public investorsTotal = 525000000e18;
249 
250 
251 	/*** Overdraft Reserves ***/
252 
253 	// 250,000,000 (25%) tokens will be eventually available for overdraft
254 	// These tokens will be distributed monthly with a 6 month cliff within a year
255 	// 41,666,666 tokens will be unlocked every month after the cliff
256 	// 4 tokens will be unlocked without vesting to ensure that total amount sums up to 250,000,000.
257 
258 	address public overdraftAllocation = address(0x1111111111111111111111111111111111111111);
259 	uint256 public overdraftTotal = 250000000e18;
260 	uint256 public overdraftPeriodAmount = 41666666e18;
261 	uint256 public overdraftUnvested = 4e18;
262 	uint256 public overdraftCliff = 5 * 30 days;
263 	uint256 public overdraftPeriodLength = 30 days;
264 	uint8   public overdraftPeriodsNumber = 6;
265 
266 
267 	/*** Tokens reserved for Founders and Team ***/
268 
269 	// 112,500,000 (11.25%) tokens will be eventually available for the team
270 	// These tokens will be distributed every 3 month without a cliff within 4 years
271 	// 7,031,250 tokens will be unlocked every 3 month
272 
273 	address public teamAllocation  = address(0x2222222222222222222222222222222222222222);
274 	uint256 public teamTotal = 112500000e18;
275 	uint256 public teamPeriodAmount = 7031250e18;
276 	uint256 public teamUnvested = 0;
277 	uint256 public teamCliff = 0;
278 	uint256 public teamPeriodLength = 3 * 30 days;
279 	uint8   public teamPeriodsNumber = 16;
280 
281 
282 
283 	/*** Tokens reserved for Community Building and Airdrop Campaigns ***/
284 
285 	// 60,000,000 (6%) tokens will be eventually available for the community
286 	// 10,000,002 tokens will be available instantly without vesting
287 	// 49,999,998 tokens will be distributed every 3 month without a cliff within 18 months
288 	// 8,333,333 tokens will be unlocked every 3 month
289 
290 
291 	address public communityAllocation  = address(0x3333333333333333333333333333333333333333);
292 	uint256 public communityTotal = 60000000e18;
293 	uint256 public communityPeriodAmount = 8333333e18;
294 	uint256 public communityUnvested = 10000002e18;
295 	uint256 public communityCliff = 0;
296 	uint256 public communityPeriodLength = 3 * 30 days;
297 	uint8   public communityPeriodsNumber = 6;
298 
299 
300 
301 	/*** Tokens reserved for Advisors, Legal and PR ***/
302 
303 	// 52,500,000 (5.25%) tokens will be eventually available for advisers
304 	// 25,000,008 tokens will be available instantly without vesting
305 	// 27 499 992 tokens will be distributed monthly without a cliff within 12 months
306 	// 2,291,666 tokens will be unlocked every month
307 
308 	address public advisersAllocation  = address(0x4444444444444444444444444444444444444444);
309 	uint256 public advisersTotal = 52500000e18;
310 	uint256 public advisersPeriodAmount = 2291666e18;
311 	uint256 public advisersUnvested = 25000008e18;
312 	uint256 public advisersCliff = 0;
313 	uint256 public advisersPeriodLength = 30 days;
314 	uint8   public advisersPeriodsNumber = 12;
315 
316 
317 	/// CONSTRUCTOR
318 
319 	function NexoToken() public {
320 		//  Overall, 1,000,000,000 tokens exist
321 		totalSupply = 1000000000e18;
322 
323 		balances[investorsAllocation] = investorsTotal;
324 		balances[overdraftAllocation] = overdraftTotal;
325 		balances[teamAllocation] = teamTotal;
326 		balances[communityAllocation] = communityTotal;
327 		balances[advisersAllocation] = advisersTotal;
328 
329 		// Unlock some tokens without vesting
330 		allowed[investorsAllocation][msg.sender] = investorsTotal;
331 		allowed[overdraftAllocation][msg.sender] = overdraftUnvested;
332 		allowed[communityAllocation][msg.sender] = communityUnvested;
333 		allowed[advisersAllocation][msg.sender] = advisersUnvested;
334 	}
335 
336 	/// DISTRIBUTION
337 
338 	function distributeInvestorsTokens(address _to, uint256 _amountWithDecimals)
339 		public
340 		onlyOwner
341 	{
342 		require(transferFrom(investorsAllocation, _to, _amountWithDecimals));
343 	}
344 
345 	/// VESTING
346 
347 	function withdrawOverdraftTokens(address _to, uint256 _amountWithDecimals)
348 		public
349 		onlyOwner
350 	{
351 		allowed[overdraftAllocation][msg.sender] = allowance(overdraftAllocation, msg.sender);
352 		require(transferFrom(overdraftAllocation, _to, _amountWithDecimals));
353 	}
354 
355 	function withdrawTeamTokens(address _to, uint256 _amountWithDecimals)
356 		public
357 		onlyOwner 
358 	{
359 		allowed[teamAllocation][msg.sender] = allowance(teamAllocation, msg.sender);
360 		require(transferFrom(teamAllocation, _to, _amountWithDecimals));
361 	}
362 
363 	function withdrawCommunityTokens(address _to, uint256 _amountWithDecimals)
364 		public
365 		onlyOwner 
366 	{
367 		allowed[communityAllocation][msg.sender] = allowance(communityAllocation, msg.sender);
368 		require(transferFrom(communityAllocation, _to, _amountWithDecimals));
369 	}
370 
371 	function withdrawAdvisersTokens(address _to, uint256 _amountWithDecimals)
372 		public
373 		onlyOwner 
374 	{
375 		allowed[advisersAllocation][msg.sender] = allowance(advisersAllocation, msg.sender);
376 		require(transferFrom(advisersAllocation, _to, _amountWithDecimals));
377 	}
378 
379 	/// @dev Overrides StandardToken.sol function
380 	function allowance(address _owner, address _spender)
381 		public
382 		view
383 		returns (uint256 remaining)
384 	{   
385 		if (_spender != owner) {
386 			return allowed[_owner][_spender];
387 		}
388 
389 		uint256 unlockedTokens;
390 		uint256 spentTokens;
391 
392 		if (_owner == overdraftAllocation) {
393 			unlockedTokens = _calculateUnlockedTokens(
394 				overdraftCliff,
395 				overdraftPeriodLength,
396 				overdraftPeriodAmount,
397 				overdraftPeriodsNumber,
398 				overdraftUnvested
399 			);
400 			spentTokens = sub(overdraftTotal, balanceOf(overdraftAllocation));
401 		} else if (_owner == teamAllocation) {
402 			unlockedTokens = _calculateUnlockedTokens(
403 				teamCliff,
404 				teamPeriodLength,
405 				teamPeriodAmount,
406 				teamPeriodsNumber,
407 				teamUnvested
408 			);
409 			spentTokens = sub(teamTotal, balanceOf(teamAllocation));
410 		} else if (_owner == communityAllocation) {
411 			unlockedTokens = _calculateUnlockedTokens(
412 				communityCliff,
413 				communityPeriodLength,
414 				communityPeriodAmount,
415 				communityPeriodsNumber,
416 				communityUnvested
417 			);
418 			spentTokens = sub(communityTotal, balanceOf(communityAllocation));
419 		} else if (_owner == advisersAllocation) {
420 			unlockedTokens = _calculateUnlockedTokens(
421 				advisersCliff,
422 				advisersPeriodLength,
423 				advisersPeriodAmount,
424 				advisersPeriodsNumber,
425 				advisersUnvested
426 			);
427 			spentTokens = sub(advisersTotal, balanceOf(advisersAllocation));
428 		} else {
429 			return allowed[_owner][_spender];
430 		}
431 
432 		return sub(unlockedTokens, spentTokens);
433 	}
434 
435 	/// @dev Overrides Owned.sol function
436 	function confirmOwnership()
437 		public
438 		onlyPotentialOwner
439 	{   
440 		// Forbid the old owner to distribute investors' tokens
441 		allowed[investorsAllocation][owner] = 0;
442 
443 		// Allow the new owner to distribute investors' tokens
444 		allowed[investorsAllocation][msg.sender] = balanceOf(investorsAllocation);
445 
446 		// Forbid the old owner to withdraw any tokens from the reserves
447 		allowed[overdraftAllocation][owner] = 0;
448 		allowed[teamAllocation][owner] = 0;
449 		allowed[communityAllocation][owner] = 0;
450 		allowed[advisersAllocation][owner] = 0;
451 
452 		super.confirmOwnership();
453 	}
454 
455 	function _calculateUnlockedTokens(
456 		uint256 _cliff,
457 		uint256 _periodLength,
458 		uint256 _periodAmount,
459 		uint8 _periodsNumber,
460 		uint256 _unvestedAmount
461 	)
462 		private
463 		view
464 		returns (uint256) 
465 	{
466 		/* solium-disable-next-line security/no-block-members */
467 		if (now < add(creationTime, _cliff)) {
468 			return _unvestedAmount;
469 		}
470 		/* solium-disable-next-line security/no-block-members */
471 		uint256 periods = div(sub(now, add(creationTime, _cliff)), _periodLength);
472 		periods = periods > _periodsNumber ? _periodsNumber : periods;
473 		return add(_unvestedAmount, mul(periods, _periodAmount));
474 	}
475 }