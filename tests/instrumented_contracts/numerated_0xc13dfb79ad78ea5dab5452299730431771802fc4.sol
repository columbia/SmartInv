1 /**
2  * Source Code first verified at https://etherscan.io on Friday, April 20, 2018
3  (UTC) */
4 
5 pragma solidity 0.4.23;
6 
7 //
8 // This source file is part of the current-contracts open source project
9 // Copyright 2018 Zerion LLC
10 // Licensed under Apache License v2.0
11 //
12 
13 
14 // @title Abstract ERC20 token interface
15 contract AbstractToken {
16 	function balanceOf(address owner) public view returns (uint256 balance);
17 	function transfer(address to, uint256 value) public returns (bool success);
18 	function transferFrom(address from, address to, uint256 value) public returns (bool success);
19 	function approve(address spender, uint256 value) public returns (bool success);
20 	function allowance(address owner, address spender) public view returns (uint256 remaining);
21 
22 	event Transfer(address indexed from, address indexed to, uint256 value);
23 	event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract Owned {
27 
28 	address public owner = msg.sender;
29 	address public potentialOwner;
30 
31 	modifier onlyOwner {
32 		require(msg.sender == owner);
33 		_;
34 	}
35 
36 	modifier onlyPotentialOwner {
37 		require(msg.sender == potentialOwner);
38 		_;
39 	}
40 
41 	event NewOwner(address old, address current);
42 	event NewPotentialOwner(address old, address potential);
43 
44 	function setOwner(address _new)
45 		public
46 		onlyOwner
47 	{
48 		emit NewPotentialOwner(owner, _new);
49 		potentialOwner = _new;
50 	}
51 
52 	function confirmOwnership()
53 		public
54 		onlyPotentialOwner
55 	{
56 		emit NewOwner(owner, potentialOwner);
57 		owner = potentialOwner;
58 		potentialOwner = address(0);
59 	}
60 }
61 
62 // @title SafeMath contract - Math operations with safety checks.
63 // @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
64 contract SafeMath {
65 	/**
66 	* @dev Multiplies two numbers, throws on overflow.
67 	*/
68 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69 		if (a == 0) {
70 			return 0;
71 		}
72 		uint256 c = a * b;
73 		assert(c / a == b);
74 		return c;
75 	}
76 
77 	/**
78 	* @dev Integer division of two numbers, truncating the quotient.
79 	*/
80 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
81 		return a / b;
82 	}
83 
84 	/**
85 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
86 	*/
87 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88 		assert(b <= a);
89 		return a - b;
90 	}
91 
92 	/**
93 	* @dev Adds two numbers, throws on overflow.
94 	*/
95 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
96 		uint256 c = a + b;
97 		assert(c >= a);
98 		return c;
99 	}
100 
101 	/**
102 	* @dev Raises `a` to the `b`th power, throws on overflow.
103 	*/
104 	function pow(uint256 a, uint256 b) internal pure returns (uint256) {
105 		uint256 c = a ** b;
106 		assert(c >= a);
107 		return c;
108 	}
109 }
110 
111 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
112 contract StandardToken is AbstractToken, Owned, SafeMath {
113 
114 	/*
115 	 *  Data structures
116 	 */
117 	mapping (address => uint256) internal balances;
118 	mapping (address => mapping (address => uint256)) internal allowed;
119 	uint256 public totalSupply;
120 
121 	/*
122 	 *  Read and write storage functions
123 	 */
124 	/// @dev Transfers sender's tokens to a given address. Returns success.
125 	/// @param _to Address of token receiver.
126 	/// @param _value Number of tokens to transfer.
127 	function transfer(address _to, uint256 _value) public returns (bool success) {
128 		return _transfer(msg.sender, _to, _value);
129 	}
130 
131 	/// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
132 	/// @param _from Address from where tokens are withdrawn.
133 	/// @param _to Address to where tokens are sent.
134 	/// @param _value Number of tokens to transfer.
135 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
136 		require(allowed[_from][msg.sender] >= _value);
137 		allowed[_from][msg.sender] -= _value;
138 
139 		return _transfer(_from, _to, _value);
140 	}
141 
142 	/// @dev Returns number of tokens owned by given address.
143 	/// @param _owner Address of token owner.
144 	function balanceOf(address _owner) public view returns (uint256 balance) {
145 		return balances[_owner];
146 	}
147 
148 	/// @dev Sets approved amount of tokens for spender. Returns success.
149 	/// @param _spender Address of allowed account.
150 	/// @param _value Number of approved tokens.
151 	function approve(address _spender, uint256 _value) public returns (bool success) {
152 		allowed[msg.sender][_spender] = _value;
153 		emit Approval(msg.sender, _spender, _value);
154 		return true;
155 	}
156 
157 	/*
158 	 * Read storage functions
159 	 */
160 	/// @dev Returns number of allowed tokens for given address.
161 	/// @param _owner Address of token owner.
162 	/// @param _spender Address of token spender.
163 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
164 		return allowed[_owner][_spender];
165 	}
166 
167 	/**
168 	* @dev Private transfer, can only be called by this contract.
169 	* @param _from The address of the sender.
170 	* @param _to The address of the recipient.
171 	* @param _value The amount to send.
172 	* @return success True if the transfer was successful, or throws.
173 	*/
174 	function _transfer(address _from, address _to, uint256 _value) private returns (bool success) {
175 		require(_to != address(0));
176 		require(balances[_from] >= _value);
177 		balances[_from] -= _value;
178 		balances[_to] = add(balances[_to], _value);
179 		emit Transfer(_from, _to, _value);
180 		return true;
181 	}
182 }
183 
184 /// @title Token contract - Implements Standard ERC20 with additional features.
185 /// @author Zerion - <inbox@zerion.io>
186 contract Token is StandardToken {
187 
188 	// Time of the contract creation
189 	uint256 public creationTime;
190 
191 	function Token() public {
192 		/* solium-disable-next-line security/no-block-members */
193 		creationTime = now;
194 	}
195 
196 	/// @dev Owner can transfer out any accidentally sent ERC20 tokens
197 	function transferERC20Token(AbstractToken _token, address _to, uint256 _value)
198 		public
199 		onlyOwner
200 		returns (bool success)
201 	{
202 		require(_token.balanceOf(address(this)) >= _value);
203 		uint256 receiverBalance = _token.balanceOf(_to);
204 		require(_token.transfer(_to, _value));
205 
206 		uint256 receiverNewBalance = _token.balanceOf(_to);
207 		assert(receiverNewBalance == add(receiverBalance, _value));
208 
209 		return true;
210 	}
211 
212 	/// @dev Increases approved amount of tokens for spender. Returns success.
213 	function increaseApproval(address _spender, uint256 _value) public returns (bool success) {
214 		allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _value);
215 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216 		return true;
217 	}
218 
219 	/// @dev Decreases approved amount of tokens for spender. Returns success.
220 	function decreaseApproval(address _spender, uint256 _value) public returns (bool success) {
221 		uint256 oldValue = allowed[msg.sender][_spender];
222 		if (_value > oldValue) {
223 			allowed[msg.sender][_spender] = 0;
224 		} else {
225 			allowed[msg.sender][_spender] = sub(oldValue, _value);
226 		}
227 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228 		return true;
229 	}
230 }
231 
232 // @title Token contract - Implements Standard ERC20 Token for GCT project.
233 /// @author Zerion - <inbox@zerion.io>
234 contract GenesisCryptoTechnology is Token {
235 
236 	/// TOKEN META DATA
237 	string constant public name = 'GenesisCryptoTechnology';
238 	string constant public symbol = 'GCT';
239 	uint8  constant public decimals = 8;
240  uint256 public exchangeRate = 5880; 
241 
242 	/// ALOCATIONS
243 	// To calculate vesting periods we assume that 1 month is always equal to 30 days 
244 
245 
246 	/*** Initial Investors' tokens ***/
247 
248 	// 600,000,00 (60%) tokens are distributed among initial investors
249 	// These tokens will be distributed without vesting
250 
251 	address public investorsAllocation = address(0x55f6074046b1fA3210E350CF520033F629f686d1);
252 	uint256 public investorsTotal = 60000000e8;
253 
254 
255 	/*** Overdraft Reserves ***/
256 
257 	// 200,000,00 (20%) tokens will be eventually available for overdraft
258 	// These tokens will be distributed monthly with a 6 month cliff within a year
259 	// 41,666,666 tokens will be unlocked every month after the cliff
260 	// 4 tokens will be unlocked without vesting to ensure that total amount sums up to 250,000,000.
261 
262 	address public overdraftAllocation = address(0x93F233fdF9d0Ea73c87AA0EDB3e4FB417Fb50145);
263 	uint256 public overdraftTotal = 20000000e8;
264 	uint256 public overdraftPeriodAmount = 41666666e8;
265 	uint256 public overdraftUnvested = 4e8;
266 	uint256 public overdraftCliff = 5 * 30 days;
267 	uint256 public overdraftPeriodLength = 810 days;
268 	uint8   public overdraftPeriodsNumber = 6;
269 
270 
271 	/*** Tokens reserved for Founders and Team ***/
272 
273 	// 150,000,00 (15%) tokens will be eventually available for the team
274 	// These tokens will be distributed every 3 month without a cliff within 4 years
275 	// 7,031,250 tokens will be unlocked every 3 month
276 
277 	address public teamAllocation  = address(0x1258c8C124dCAdf8122117EbF1968FFC54bFBFa6);
278 	uint256 public teamTotal = 15000000e8;
279 	uint256 public teamPeriodAmount = 7031250e8;
280 	uint256 public teamUnvested = 0;
281 	uint256 public teamCliff = 0;
282 	uint256 public teamPeriodLength = 3 * 810 days;
283 	uint8   public teamPeriodsNumber = 16;
284 
285 
286 
287 	/*** Tokens reserved for Community Building and Airdrop Campaigns ***/
288 
289 	// 40,000,00 (4%) tokens will be eventually available for the community
290 	// 10,000,002 tokens will be available instantly without vesting
291 	// 49,999,998 tokens will be distributed every 3 month without a cliff within 18 months
292 	// 8,333,333 tokens will be unlocked every 3 month
293 
294 
295 	address public communityAllocation  = address(0xa4d82eb18d2Bca1A3A2443324F0Beea0A0DC23C8);
296 	uint256 public communityTotal = 4000000e8;
297 	uint256 public communityPeriodAmount = 8333333e8;
298 	uint256 public communityUnvested = 10000002e8;
299 	uint256 public communityCliff = 0;
300 	uint256 public communityPeriodLength = 3 * 810 days;
301 	uint8   public communityPeriodsNumber = 6;
302 
303 
304 
305 	/*** Tokens reserved for Advisors, Legal and PR ***/
306 
307 	// 10,000,00 (1%) tokens will be eventually available for advisers
308 	// 25,000,008 tokens will be available instantly without vesting
309 	// 27 499 992 tokens will be distributed monthly without a cliff within 12 months
310 	// 2,291,666 tokens will be unlocked every month
311 
312 	address public advisersAllocation  = address(0xa020d6Ca8738B18727dEFbe49fC22e3eF7110163);
313 	uint256 public advisersTotal = 1000000e8;
314 	uint256 public advisersPeriodAmount = 2291666e8;
315 	uint256 public advisersUnvested = 25000008e8;
316 	uint256 public advisersCliff = 0;
317 	uint256 public advisersPeriodLength = 1 days;
318 	uint8   public advisersPeriodsNumber = 12;
319 
320 
321 	/// CONSTRUCTOR
322 
323 	function GenesisCryptoTechnology() public {
324 		//  Overall, 1,000,000,00 tokens exist
325 		totalSupply = 100000000e8;
326 
327 		balances[investorsAllocation] = investorsTotal;
328 		balances[overdraftAllocation] = overdraftTotal;
329 		balances[teamAllocation] = teamTotal;
330 		balances[communityAllocation] = communityTotal;
331 		balances[advisersAllocation] = advisersTotal;
332 
333 		// Unlock some tokens without vesting
334 		allowed[investorsAllocation][msg.sender] = investorsTotal;
335 		allowed[overdraftAllocation][msg.sender] = overdraftUnvested;
336 		allowed[communityAllocation][msg.sender] = communityUnvested;
337 		allowed[advisersAllocation][msg.sender] = advisersUnvested;
338 	}
339 
340 	/// DISTRIBUTION
341 
342 	function distributeInvestorsTokens(address _to, uint256 _amountWithDecimals)
343 		public
344 		onlyOwner
345 	{
346 		require(transferFrom(investorsAllocation, _to, _amountWithDecimals));
347 	}
348 
349 	/// VESTING
350 
351 	function withdrawOverdraftTokens(address _to, uint256 _amountWithDecimals)
352 		public
353 		onlyOwner
354 	{
355 		allowed[overdraftAllocation][msg.sender] = allowance(overdraftAllocation, msg.sender);
356 		require(transferFrom(overdraftAllocation, _to, _amountWithDecimals));
357 	}
358 
359 	function withdrawTeamTokens(address _to, uint256 _amountWithDecimals)
360 		public
361 		onlyOwner 
362 	{
363 		allowed[teamAllocation][msg.sender] = allowance(teamAllocation, msg.sender);
364 		require(transferFrom(teamAllocation, _to, _amountWithDecimals));
365 	}
366 
367 	function withdrawCommunityTokens(address _to, uint256 _amountWithDecimals)
368 		public
369 		onlyOwner 
370 	{
371 		allowed[communityAllocation][msg.sender] = allowance(communityAllocation, msg.sender);
372 		require(transferFrom(communityAllocation, _to, _amountWithDecimals));
373 	}
374 
375 	function withdrawAdvisersTokens(address _to, uint256 _amountWithDecimals)
376 		public
377 		onlyOwner 
378 	{
379 		allowed[advisersAllocation][msg.sender] = allowance(advisersAllocation, msg.sender);
380 		require(transferFrom(advisersAllocation, _to, _amountWithDecimals));
381 	}
382 
383 	/// @dev Overrides StandardToken.sol function
384 	function allowance(address _owner, address _spender)
385 		public
386 		view
387 		returns (uint256 remaining)
388 	{   
389 		if (_spender != owner) {
390 			return allowed[_owner][_spender];
391 		}
392 
393 		uint256 unlockedTokens;
394 		uint256 spentTokens;
395 
396 		if (_owner == overdraftAllocation) {
397 			unlockedTokens = _calculateUnlockedTokens(
398 				overdraftCliff,
399 				overdraftPeriodLength,
400 				overdraftPeriodAmount,
401 				overdraftPeriodsNumber,
402 				overdraftUnvested
403 			);
404 			spentTokens = sub(overdraftTotal, balanceOf(overdraftAllocation));
405 		} else if (_owner == teamAllocation) {
406 			unlockedTokens = _calculateUnlockedTokens(
407 				teamCliff,
408 				teamPeriodLength,
409 				teamPeriodAmount,
410 				teamPeriodsNumber,
411 				teamUnvested
412 			);
413 			spentTokens = sub(teamTotal, balanceOf(teamAllocation));
414 		} else if (_owner == communityAllocation) {
415 			unlockedTokens = _calculateUnlockedTokens(
416 				communityCliff,
417 				communityPeriodLength,
418 				communityPeriodAmount,
419 				communityPeriodsNumber,
420 				communityUnvested
421 			);
422 			spentTokens = sub(communityTotal, balanceOf(communityAllocation));
423 		} else if (_owner == advisersAllocation) {
424 			unlockedTokens = _calculateUnlockedTokens(
425 				advisersCliff,
426 				advisersPeriodLength,
427 				advisersPeriodAmount,
428 				advisersPeriodsNumber,
429 				advisersUnvested
430 			);
431 			spentTokens = sub(advisersTotal, balanceOf(advisersAllocation));
432 		} else {
433 			return allowed[_owner][_spender];
434 		}
435 
436 		return sub(unlockedTokens, spentTokens);
437 	}
438 
439 	/// @dev Overrides Owned.sol function
440 	function confirmOwnership()
441 		public
442 		onlyPotentialOwner
443 	{   
444 		// Forbid the old owner to distribute investors' tokens
445 		allowed[investorsAllocation][owner] = 0;
446 
447 		// Allow the new owner to distribute investors' tokens
448 		allowed[investorsAllocation][msg.sender] = balanceOf(investorsAllocation);
449 
450 		// Forbid the old owner to withdraw any tokens from the reserves
451 		allowed[overdraftAllocation][owner] = 0;
452 		allowed[teamAllocation][owner] = 0;
453 		allowed[communityAllocation][owner] = 0;
454 		allowed[advisersAllocation][owner] = 0;
455 
456 		super.confirmOwnership();
457 	}
458 
459 	function _calculateUnlockedTokens(
460 		uint256 _cliff,
461 		uint256 _periodLength,
462 		uint256 _periodAmount,
463 		uint8 _periodsNumber,
464 		uint256 _unvestedAmount
465 	)
466 		private
467 		view
468 		returns (uint256) 
469 	{
470 		/* solium-disable-next-line security/no-block-members */
471 		if (now < add(creationTime, _cliff)) {
472 			return _unvestedAmount;
473 		}
474 		/* solium-disable-next-line security/no-block-members */
475 		uint256 periods = div(sub(now, add(creationTime, _cliff)), _periodLength);
476 		periods = periods > _periodsNumber ? _periodsNumber : periods;
477 		return add(_unvestedAmount, mul(periods, _periodAmount));
478 	}
479 }