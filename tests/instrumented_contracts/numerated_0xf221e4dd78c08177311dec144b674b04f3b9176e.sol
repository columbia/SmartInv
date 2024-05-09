1 /**
2  * Source Code first verified at https://etherscan.io on Sunday, May 12, 2019
3  (UTC) */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Friday, April 20, 2018
7  (UTC) */
8 
9 pragma solidity 0.4.23;
10 
11 //
12 // This source file is part of the current-contracts open source project
13 // Copyright 2018 Zerion LLC
14 // Licensed under Apache License v2.0
15 //
16 
17 
18 // @title Abstract ERC20 token interface
19 contract AbstractToken {
20 	function balanceOf(address owner) public view returns (uint256 balance);
21 	function transfer(address to, uint256 value) public returns (bool success);
22 	function transferFrom(address from, address to, uint256 value) public returns (bool success);
23 	function approve(address spender, uint256 value) public returns (bool success);
24 	function allowance(address owner, address spender) public view returns (uint256 remaining);
25 
26 	event Transfer(address indexed from, address indexed to, uint256 value);
27 	event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 contract Owned {
31 
32 	address public owner = msg.sender;
33 	address public potentialOwner;
34 
35 	modifier onlyOwner {
36 		require(msg.sender == owner);
37 		_;
38 	}
39 
40 	modifier onlyPotentialOwner {
41 		require(msg.sender == potentialOwner);
42 		_;
43 	}
44 
45 	event NewOwner(address old, address current);
46 	event NewPotentialOwner(address old, address potential);
47 
48 	function setOwner(address _new)
49 		public
50 		onlyOwner
51 	{
52 		emit NewPotentialOwner(owner, _new);
53 		potentialOwner = _new;
54 	}
55 
56 	function confirmOwnership()
57 		public
58 		onlyPotentialOwner
59 	{
60 		emit NewOwner(owner, potentialOwner);
61 		owner = potentialOwner;
62 		potentialOwner = address(0);
63 	}
64 }
65 
66 // @title SafeMath contract - Math operations with safety checks.
67 // @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
68 contract SafeMath {
69 	/**
70 	* @dev Multiplies two numbers, throws on overflow.
71 	*/
72 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73 		if (a == 0) {
74 			return 0;
75 		}
76 		uint256 c = a * b;
77 		assert(c / a == b);
78 		return c;
79 	}
80 
81 	/**
82 	* @dev Integer division of two numbers, truncating the quotient.
83 	*/
84 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
85 		return a / b;
86 	}
87 
88 	/**
89 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90 	*/
91 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92 		assert(b <= a);
93 		return a - b;
94 	}
95 
96 	/**
97 	* @dev Adds two numbers, throws on overflow.
98 	*/
99 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
100 		uint256 c = a + b;
101 		assert(c >= a);
102 		return c;
103 	}
104 
105 	/**
106 	* @dev Raises `a` to the `b`th power, throws on overflow.
107 	*/
108 	function pow(uint256 a, uint256 b) internal pure returns (uint256) {
109 		uint256 c = a ** b;
110 		assert(c >= a);
111 		return c;
112 	}
113 }
114 
115 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
116 contract StandardToken is AbstractToken, Owned, SafeMath {
117 
118 	/*
119 	 *  Data structures
120 	 */
121 	mapping (address => uint256) internal balances;
122 	mapping (address => mapping (address => uint256)) internal allowed;
123 	uint256 public totalSupply;
124 
125 	/*
126 	 *  Read and write storage functions
127 	 */
128 	/// @dev Transfers sender's tokens to a given address. Returns success.
129 	/// @param _to Address of token receiver.
130 	/// @param _value Number of tokens to transfer.
131 	function transfer(address _to, uint256 _value) public returns (bool success) {
132 		return _transfer(msg.sender, _to, _value);
133 	}
134 
135 	/// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
136 	/// @param _from Address from where tokens are withdrawn.
137 	/// @param _to Address to where tokens are sent.
138 	/// @param _value Number of tokens to transfer.
139 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
140 		require(allowed[_from][msg.sender] >= _value);
141 		allowed[_from][msg.sender] -= _value;
142 
143 		return _transfer(_from, _to, _value);
144 	}
145 
146 	/// @dev Returns number of tokens owned by given address.
147 	/// @param _owner Address of token owner.
148 	function balanceOf(address _owner) public view returns (uint256 balance) {
149 		return balances[_owner];
150 	}
151 
152 	/// @dev Sets approved amount of tokens for spender. Returns success.
153 	/// @param _spender Address of allowed account.
154 	/// @param _value Number of approved tokens.
155 	function approve(address _spender, uint256 _value) public returns (bool success) {
156 		allowed[msg.sender][_spender] = _value;
157 		emit Approval(msg.sender, _spender, _value);
158 		return true;
159 	}
160 
161 	/*
162 	 * Read storage functions
163 	 */
164 	/// @dev Returns number of allowed tokens for given address.
165 	/// @param _owner Address of token owner.
166 	/// @param _spender Address of token spender.
167 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
168 		return allowed[_owner][_spender];
169 	}
170 
171 	/**
172 	* @dev Private transfer, can only be called by this contract.
173 	* @param _from The address of the sender.
174 	* @param _to The address of the recipient.
175 	* @param _value The amount to send.
176 	* @return success True if the transfer was successful, or throws.
177 	*/
178 	function _transfer(address _from, address _to, uint256 _value) private returns (bool success) {
179 		require(_to != address(0));
180 		require(balances[_from] >= _value);
181 		balances[_from] -= _value;
182 		balances[_to] = add(balances[_to], _value);
183 		emit Transfer(_from, _to, _value);
184 		return true;
185 	}
186 }
187 
188 /// @title Token contract - Implements Standard ERC20 with additional features.
189 /// @author Zerion - <inbox@zerion.io>
190 contract Token is StandardToken {
191 
192 	// Time of the contract creation
193 	uint256 public creationTime;
194 
195 	function Token() public {
196 		/* solium-disable-next-line security/no-block-members */
197 		creationTime = now;
198 	}
199 
200 	/// @dev Owner can transfer out any accidentally sent ERC20 tokens
201 	function transferERC20Token(AbstractToken _token, address _to, uint256 _value)
202 		public
203 		onlyOwner
204 		returns (bool success)
205 	{
206 		require(_token.balanceOf(address(this)) >= _value);
207 		uint256 receiverBalance = _token.balanceOf(_to);
208 		require(_token.transfer(_to, _value));
209 
210 		uint256 receiverNewBalance = _token.balanceOf(_to);
211 		assert(receiverNewBalance == add(receiverBalance, _value));
212 
213 		return true;
214 	}
215 
216 	/// @dev Increases approved amount of tokens for spender. Returns success.
217 	function increaseApproval(address _spender, uint256 _value) public returns (bool success) {
218 		allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _value);
219 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220 		return true;
221 	}
222 
223 	/// @dev Decreases approved amount of tokens for spender. Returns success.
224 	function decreaseApproval(address _spender, uint256 _value) public returns (bool success) {
225 		uint256 oldValue = allowed[msg.sender][_spender];
226 		if (_value > oldValue) {
227 			allowed[msg.sender][_spender] = 0;
228 		} else {
229 			allowed[msg.sender][_spender] = sub(oldValue, _value);
230 		}
231 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232 		return true;
233 	}
234 }
235 
236 // @title Token contract - Implements Standard ERC20 Token for GCT project.
237 /// @author Zerion - <inbox@zerion.io>
238 contract GenesisCryptoTechnology is Token {
239 
240 	/// TOKEN META DATA
241 	string constant public name = 'GenesisCryptoTechnology';
242 	string constant public symbol = 'GCT';
243 	uint8  constant public decimals = 8;
244  uint256 public exchangeRate = 5880; 
245 
246 	/// ALOCATIONS
247 	// To calculate vesting periods we assume that 1 month is always equal to 30 days 
248 
249 
250 	/*** Initial Investors' tokens ***/
251 
252 	// 600,000,00 (60%) tokens are distributed among initial investors
253 	// These tokens will be distributed without vesting
254 
255 	address public investorsAllocation = address(0x11195539543Ec8E6fe7179112E42fe1d3c434Ed4);
256 	uint256 public investorsTotal = 60000000e8;
257 
258 
259 	/*** Overdraft Reserves ***/
260 
261 	// 200,000,00 (20%) tokens will be eventually available for overdraft
262 	// These tokens will be distributed monthly with a 6 month cliff within a year
263 	// 41,666,666 tokens will be unlocked every month after the cliff
264 	// 4 tokens will be unlocked without vesting to ensure that total amount sums up to 250,000,000.
265 
266 	address public overdraftAllocation = address(0xa218A1Ae3D584d02598C3c5Aa675E547bBeeE0E7);
267 	uint256 public overdraftTotal = 20000000e8;
268 	uint256 public overdraftPeriodAmount = 41666666e8;
269 	uint256 public overdraftUnvested = 4e8;
270 	uint256 public overdraftCliff = 5 * 30 days;
271 	uint256 public overdraftPeriodLength = 810 days;
272 	uint8   public overdraftPeriodsNumber = 6;
273 
274 
275 	/*** Tokens reserved for Founders and Team ***/
276 
277 	// 150,000,00 (15%) tokens will be eventually available for the team
278 	// These tokens will be distributed every 3 month without a cliff within 4 years
279 	// 7,031,250 tokens will be unlocked every 3 month
280 
281 	address public teamAllocation  = address(0x4ee4562cc0eeC0381a974efffe768ce2017632Ad);
282 	uint256 public teamTotal = 15000000e8;
283 	uint256 public teamPeriodAmount = 7031250e8;
284 	uint256 public teamUnvested = 0;
285 	uint256 public teamCliff = 0;
286 	uint256 public teamPeriodLength = 3 * 810 days;
287 	uint8   public teamPeriodsNumber = 16;
288 
289 
290 
291 	/*** Tokens reserved for Community Building and Airdrop Campaigns ***/
292 
293 	// 40,000,00 (4%) tokens will be eventually available for the community
294 	// 10,000,002 tokens will be available instantly without vesting
295 	// 49,999,998 tokens will be distributed every 3 month without a cliff within 18 months
296 	// 8,333,333 tokens will be unlocked every 3 month
297 
298 
299 	address public communityAllocation  = address(0x99559c417313e61aE699FD55B9A2FD533e97dAB1);
300 	uint256 public communityTotal = 4000000e8;
301 	uint256 public communityPeriodAmount = 8333333e8;
302 	uint256 public communityUnvested = 10000002e8;
303 	uint256 public communityCliff = 0;
304 	uint256 public communityPeriodLength = 3 * 810 days;
305 	uint8   public communityPeriodsNumber = 6;
306 
307 
308 
309 	/*** Tokens reserved for Advisors, Legal and PR ***/
310 
311 	// 10,000,00 (1%) tokens will be eventually available for advisers
312 	// 25,000,008 tokens will be available instantly without vesting
313 	// 27 499 992 tokens will be distributed monthly without a cliff within 12 months
314 	// 2,291,666 tokens will be unlocked every month
315 
316 	address public advisersAllocation  = address(0x3E553bB7c931DC752E9CDd7Acb52e6F0b2bEB35E);
317 	uint256 public advisersTotal = 1000000e8;
318 	uint256 public advisersPeriodAmount = 2291666e8;
319 	uint256 public advisersUnvested = 25000008e8;
320 	uint256 public advisersCliff = 0;
321 	uint256 public advisersPeriodLength = 1 days;
322 	uint8   public advisersPeriodsNumber = 12;
323 
324 
325 	/// CONSTRUCTOR
326 
327 	function GenesisCryptoTechnology() public {
328 		//  Overall, 1,000,000,00 tokens exist
329 		totalSupply = 100000000e8;
330 
331 		balances[investorsAllocation] = investorsTotal;
332 		balances[overdraftAllocation] = overdraftTotal;
333 		balances[teamAllocation] = teamTotal;
334 		balances[communityAllocation] = communityTotal;
335 		balances[advisersAllocation] = advisersTotal;
336 
337 		// Unlock some tokens without vesting
338 		allowed[investorsAllocation][msg.sender] = investorsTotal;
339 		allowed[overdraftAllocation][msg.sender] = overdraftUnvested;
340 		allowed[communityAllocation][msg.sender] = communityUnvested;
341 		allowed[advisersAllocation][msg.sender] = advisersUnvested;
342 	}
343 
344 	/// DISTRIBUTION
345 
346 	function distributeInvestorsTokens(address _to, uint256 _amountWithDecimals)
347 		public
348 		onlyOwner
349 	{
350 		require(transferFrom(investorsAllocation, _to, _amountWithDecimals));
351 	}
352 
353 	/// VESTING
354 
355 	function withdrawOverdraftTokens(address _to, uint256 _amountWithDecimals)
356 		public
357 		onlyOwner
358 	{
359 		allowed[overdraftAllocation][msg.sender] = allowance(overdraftAllocation, msg.sender);
360 		require(transferFrom(overdraftAllocation, _to, _amountWithDecimals));
361 	}
362 
363 	function withdrawTeamTokens(address _to, uint256 _amountWithDecimals)
364 		public
365 		onlyOwner 
366 	{
367 		allowed[teamAllocation][msg.sender] = allowance(teamAllocation, msg.sender);
368 		require(transferFrom(teamAllocation, _to, _amountWithDecimals));
369 	}
370 
371 	function withdrawCommunityTokens(address _to, uint256 _amountWithDecimals)
372 		public
373 		onlyOwner 
374 	{
375 		allowed[communityAllocation][msg.sender] = allowance(communityAllocation, msg.sender);
376 		require(transferFrom(communityAllocation, _to, _amountWithDecimals));
377 	}
378 
379 	function withdrawAdvisersTokens(address _to, uint256 _amountWithDecimals)
380 		public
381 		onlyOwner 
382 	{
383 		allowed[advisersAllocation][msg.sender] = allowance(advisersAllocation, msg.sender);
384 		require(transferFrom(advisersAllocation, _to, _amountWithDecimals));
385 	}
386 
387 	/// @dev Overrides StandardToken.sol function
388 	function allowance(address _owner, address _spender)
389 		public
390 		view
391 		returns (uint256 remaining)
392 	{   
393 		if (_spender != owner) {
394 			return allowed[_owner][_spender];
395 		}
396 
397 		uint256 unlockedTokens;
398 		uint256 spentTokens;
399 
400 		if (_owner == overdraftAllocation) {
401 			unlockedTokens = _calculateUnlockedTokens(
402 				overdraftCliff,
403 				overdraftPeriodLength,
404 				overdraftPeriodAmount,
405 				overdraftPeriodsNumber,
406 				overdraftUnvested
407 			);
408 			spentTokens = sub(overdraftTotal, balanceOf(overdraftAllocation));
409 		} else if (_owner == teamAllocation) {
410 			unlockedTokens = _calculateUnlockedTokens(
411 				teamCliff,
412 				teamPeriodLength,
413 				teamPeriodAmount,
414 				teamPeriodsNumber,
415 				teamUnvested
416 			);
417 			spentTokens = sub(teamTotal, balanceOf(teamAllocation));
418 		} else if (_owner == communityAllocation) {
419 			unlockedTokens = _calculateUnlockedTokens(
420 				communityCliff,
421 				communityPeriodLength,
422 				communityPeriodAmount,
423 				communityPeriodsNumber,
424 				communityUnvested
425 			);
426 			spentTokens = sub(communityTotal, balanceOf(communityAllocation));
427 		} else if (_owner == advisersAllocation) {
428 			unlockedTokens = _calculateUnlockedTokens(
429 				advisersCliff,
430 				advisersPeriodLength,
431 				advisersPeriodAmount,
432 				advisersPeriodsNumber,
433 				advisersUnvested
434 			);
435 			spentTokens = sub(advisersTotal, balanceOf(advisersAllocation));
436 		} else {
437 			return allowed[_owner][_spender];
438 		}
439 
440 		return sub(unlockedTokens, spentTokens);
441 	}
442 
443 	/// @dev Overrides Owned.sol function
444 	function confirmOwnership()
445 		public
446 		onlyPotentialOwner
447 	{   
448 		// Forbid the old owner to distribute investors' tokens
449 		allowed[investorsAllocation][owner] = 0;
450 
451 		// Allow the new owner to distribute investors' tokens
452 		allowed[investorsAllocation][msg.sender] = balanceOf(investorsAllocation);
453 
454 		// Forbid the old owner to withdraw any tokens from the reserves
455 		allowed[overdraftAllocation][owner] = 0;
456 		allowed[teamAllocation][owner] = 0;
457 		allowed[communityAllocation][owner] = 0;
458 		allowed[advisersAllocation][owner] = 0;
459 
460 		super.confirmOwnership();
461 	}
462 
463 	function _calculateUnlockedTokens(
464 		uint256 _cliff,
465 		uint256 _periodLength,
466 		uint256 _periodAmount,
467 		uint8 _periodsNumber,
468 		uint256 _unvestedAmount
469 	)
470 		private
471 		view
472 		returns (uint256) 
473 	{
474 		/* solium-disable-next-line security/no-block-members */
475 		if (now < add(creationTime, _cliff)) {
476 			return _unvestedAmount;
477 		}
478 		/* solium-disable-next-line security/no-block-members */
479 		uint256 periods = div(sub(now, add(creationTime, _cliff)), _periodLength);
480 		periods = periods > _periodsNumber ? _periodsNumber : periods;
481 		return add(_unvestedAmount, mul(periods, _periodAmount));
482 	}
483 }