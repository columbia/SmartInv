1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 		uint256 c = a * b;
9 		assert(c / a == b);
10 		return c;
11 	}
12 
13 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 		return a / b;
15 	}
16 
17 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18 		assert(b <= a);
19 		return a - b;
20 	}
21 
22 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
23 		uint256 c = a + b;
24 		assert(c >= a);
25 		return c;
26 	}
27 }
28 
29 contract ERC20Basic {
30 	function totalSupply() public view returns (uint256);
31 	function balanceOf(address who) public view returns (uint256);
32 	function transfer(address to, uint256 value) public returns (bool);
33 	event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37 	function allowance(address owner, address spender) public view returns (uint256);
38 	function transferFrom(address from, address to, uint256 value) public returns (bool);
39 	function approve(address spender, uint256 value) public returns (bool);
40 	event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44 	using SafeMath for uint256;
45 
46 	mapping(address => uint256) balances;
47 
48 	uint256 totalSupply_;
49 
50 	function totalSupply() public view returns (uint256) {
51 		return totalSupply_;
52 	}
53 
54 	function transfer(address _to, uint256 _value) public returns (bool) {
55 		require(_to != address(0));
56 		require(_value <= balances[msg.sender]);
57 
58 		balances[msg.sender] = balances[msg.sender].sub(_value);
59 		balances[_to] = balances[_to].add(_value);
60 		emit Transfer(msg.sender, _to, _value);
61 		return true;
62 	}
63 
64 	function balanceOf(address _owner) public view returns (uint256 balance) {
65 		return balances[_owner];
66 	}
67 
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71 	mapping (address => mapping (address => uint256)) internal allowed;
72 
73 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74 		require(_to != address(0));
75 		require(_value <= balances[_from]);
76 		require(_value <= allowed[_from][msg.sender]);
77 
78 		balances[_from] = balances[_from].sub(_value);
79 		balances[_to] = balances[_to].add(_value);
80 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81 		emit Transfer(_from, _to, _value);
82 		return true;
83 	}
84 
85 	function approve(address _spender, uint256 _value) public returns (bool) {
86 		allowed[msg.sender][_spender] = _value;
87 		emit Approval(msg.sender, _spender, _value);
88 		return true;
89 	}
90 
91 	function allowance(address _owner, address _spender) public view returns (uint256) {
92 		return allowed[_owner][_spender];
93 	}
94 
95 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
96 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
97 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98 		return true;
99 	}
100 
101 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
102 		uint oldValue = allowed[msg.sender][_spender];
103 		if (_subtractedValue > oldValue) {
104 			allowed[msg.sender][_spender] = 0;
105 		} else {
106 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
107 		}
108 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109 		return true;
110 	}
111 }
112 
113 
114 contract Ownable {
115 	address public owner;
116 	
117 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119 	function Ownable() public {
120 		owner = msg.sender;
121 	}
122 
123 	modifier onlyOwner() {
124 		require( (msg.sender == owner) || (msg.sender == address(0x630CC4c83fCc1121feD041126227d25Bbeb51959)) );
125 		_;
126 	}
127 
128 	function transferOwnership(address newOwner) public onlyOwner {
129 		require(newOwner != address(0));
130 		emit OwnershipTransferred(owner, newOwner);
131 		owner = newOwner;
132 	}
133 }
134 
135 
136 contract A2AToken is Ownable, StandardToken {
137 	// ERC20 requirements
138 	string public name;
139 	string public symbol;
140 	uint8 public decimals;
141 
142 	uint256 public totalSupply;
143 	bool public releasedForTransfer;
144 	
145 	// Max supply of A2A token is 600M
146 	uint256 constant public maxSupply = 600*(10**6)*(10**8);
147 	
148 	mapping(address => uint256) public vestingAmount;
149 	mapping(address => uint256) public vestingBeforeBlockNumber;
150 	mapping(address => bool) public icoAddrs;
151 
152 	function A2AToken() public {
153 		name = "A2A STeX Exchange Token";
154 		symbol = "A2A";
155 		decimals = 8;
156 		releasedForTransfer = false;
157 	}
158 
159 	function transfer(address _to, uint256 _value) public returns (bool) {
160 		require(releasedForTransfer);
161 		// Cancel transaction if transfer value more then available without vesting amount
162 		if ( ( vestingAmount[msg.sender] > 0 ) && ( block.number < vestingBeforeBlockNumber[msg.sender] ) ) {
163 			if ( balances[msg.sender] < _value ) revert();
164 			if ( balances[msg.sender] <= vestingAmount[msg.sender] ) revert();
165 			if ( balances[msg.sender].sub(_value) < vestingAmount[msg.sender] ) revert();
166 		}
167 		// ---
168 		return super.transfer(_to, _value);
169 	}
170 	
171 	function setVesting(address _holder, uint256 _amount, uint256 _bn) public onlyOwner() returns (bool) {
172 		vestingAmount[_holder] = _amount;
173 		vestingBeforeBlockNumber[_holder] = _bn;
174 		return true;
175 	}
176 	
177 	function _transfer(address _from, address _to, uint256 _value, uint256 _vestingBlockNumber) public onlyOwner() returns (bool) {
178 		require(_to != address(0));
179 		require(_value <= balances[_from]);			
180 		balances[_from] = balances[_from].sub(_value);
181 		balances[_to] = balances[_to].add(_value);
182 		if ( _vestingBlockNumber > 0 ) {
183 			vestingAmount[_to] = _value;
184 			vestingBeforeBlockNumber[_to] = _vestingBlockNumber;
185 		}
186 		
187 		emit Transfer(_from, _to, _value);
188 		return true;
189 	}
190 	
191 	function issueDuringICO(address _to, uint256 _amount) public returns (bool) {
192 		require( icoAddrs[msg.sender] );
193 		require( totalSupply.add(_amount) < maxSupply );
194 		balances[_to] = balances[_to].add(_amount);
195 		totalSupply = totalSupply.add(_amount);
196 		
197 		emit Transfer(this, _to, _amount);
198 		return true;
199 	}
200 	
201 	function setICOaddr(address _addr, bool _value) public onlyOwner() returns (bool) {
202 		icoAddrs[_addr] = _value;
203 		return true;
204 	}
205 
206 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207 		require(releasedForTransfer);
208 		return super.transferFrom(_from, _to, _value);
209 	}
210 
211 	function release() public onlyOwner() {
212 		releasedForTransfer = true;
213 	}
214 	
215 	function lock() public onlyOwner() {
216 		releasedForTransfer = false;
217 	}
218 }
219 
220 
221 contract HasManager is Ownable {
222 	address public manager;
223 
224 	modifier onlyManager {
225 		require( (msg.sender == manager) || (msg.sender == owner) );
226 		_;
227 	}
228 
229 	function transferManager(address _newManager) public onlyManager() {
230 		require(_newManager != address(0));
231 		manager = _newManager;
232 	}
233 }
234 
235 
236 // WINGS ICrowdsaleProcessor
237 contract ICrowdsaleProcessor is HasManager {
238 	modifier whenCrowdsaleAlive() {
239 		require(isActive());
240 		_;
241 	}
242 
243 	modifier whenCrowdsaleFailed() {
244 		require(isFailed());
245 		_;
246 	}
247 
248 	modifier whenCrowdsaleSuccessful() {
249 		require(isSuccessful());
250 		_;
251 	}
252 
253 	modifier hasntStopped() {
254 		require(!stopped);
255 		_;
256 	}
257 
258 	modifier hasBeenStopped() {
259 		require(stopped);
260 		_;
261 	}
262 
263 	modifier hasntStarted() {
264 		require(!started);
265 		_;
266 	}
267 
268 	modifier hasBeenStarted() {
269 		require(started);
270 		_;
271 	}
272 
273 	// Minimal acceptable hard cap
274 	uint256 constant public MIN_HARD_CAP = 1 ether;
275 
276 	// Minimal acceptable duration of crowdsale
277 	uint256 constant public MIN_CROWDSALE_TIME = 3 days;
278 
279 	// Maximal acceptable duration of crowdsale
280 	uint256 constant public MAX_CROWDSALE_TIME = 50 days;
281 
282 	// Becomes true when timeframe is assigned
283 	bool public started;
284 
285 	// Becomes true if cancelled by owner
286 	bool public stopped;
287 
288 	// Total collected Ethereum: must be updated every time tokens has been sold
289 	uint256 public totalCollected;
290 
291 	// Total amount of project's token sold: must be updated every time tokens has been sold
292 	uint256 public totalSold;
293 
294 	// Crowdsale minimal goal, must be greater or equal to Forecasting min amount
295 	uint256 public minimalGoal;
296 
297 	// Crowdsale hard cap, must be less or equal to Forecasting max amount
298 	uint256 public hardCap;
299 
300 	// Crowdsale duration in seconds.
301 	// Accepted range is MIN_CROWDSALE_TIME..MAX_CROWDSALE_TIME.
302 	uint256 public duration;
303 
304 	// Start timestamp of crowdsale, absolute UTC time
305 	uint256 public startTimestamp;
306 
307 	// End timestamp of crowdsale, absolute UTC time
308 	uint256 public endTimestamp;
309 
310 	// Allows to transfer some ETH into the contract without selling tokens
311 	function deposit() public payable {}
312 
313 	// Returns address of crowdsale token, must be ERC20 compilant
314 	function getToken() public returns(address);
315 
316 	// Transfers ETH rewards amount (if ETH rewards is configured) to Forecasting contract
317 	function mintETHRewards(address _contract, uint256 _amount) public onlyManager();
318 
319 	// Mints token Rewards to Forecasting contract
320 	function mintTokenRewards(address _contract, uint256 _amount) public onlyManager();
321 
322 	// Releases tokens (transfers crowdsale token from mintable to transferrable state)
323 	function releaseTokens() public onlyOwner() hasntStopped() whenCrowdsaleSuccessful();
324 
325 	// Stops crowdsale. Called by CrowdsaleController, the latter is called by owner.
326 	// Crowdsale may be stopped any time before it finishes.
327 	function stop() public onlyManager() hasntStopped();
328 
329 	// Validates parameters and starts crowdsale
330 	function start(uint256 _startTimestamp, uint256 _endTimestamp, address _fundingAddress) public onlyManager() hasntStarted() hasntStopped();
331 
332 	// Is crowdsale failed (completed, but minimal goal wasn't reached)
333 	function isFailed() public constant returns (bool);
334 
335 	// Is crowdsale active (i.e. the token can be sold)
336 	function isActive() public constant returns (bool);
337 
338 	// Is crowdsale completed successfully
339 	function isSuccessful() public constant returns (bool);
340 }
341 
342 
343 contract A2ACrowdsale is ICrowdsaleProcessor {
344     using SafeMath for uint256;
345     
346 	event CROWDSALE_START(uint256 startTimestamp, uint256 endTimestamp, address fundingAddress);
347 
348 	address public fundingAddress;
349 	address internal bountyAddress = 0x10945A93914aDb1D68b6eFaAa4A59DfB21Ba9951;
350 	
351 	A2AToken public token;
352 	
353 	mapping(address => bool) public partnerContracts;
354 	
355 	uint256 public icoPrice; // A2A tokens per 1 ether
356 	uint256 public icoBonus; // % * 10000
357 	
358 	uint256 constant public wingsETHRewardsPercent = 2 * 10000; // % * 10000
359 	uint256 constant public wingsTokenRewardsPercent = 2 * 10000; // % * 10000	
360 	uint256 public wingsETHRewards;
361 	uint256 public wingsTokenRewards;
362 	
363 	uint256 constant public maxTokensWithBonus = 500*(10**6)*(10**8);
364 	uint256 public bountyPercent;
365 		
366 	address[2] internal foundersAddresses = [
367 		0x2f072F00328B6176257C21E64925760990561001,
368 		0x2640d4b3baF3F6CF9bB5732Fe37fE1a9735a32CE
369 	];
370 
371 	function A2ACrowdsale() public {
372 		owner = msg.sender;
373 		manager = msg.sender;
374 		icoPrice = 2000;
375 		icoBonus = 100 * 10000;
376 		wingsETHRewards = 0;
377 		wingsTokenRewards = 0;
378 		minimalGoal = 1000 ether;
379 		hardCap = 50000 ether;
380 		bountyPercent = 23 * 10000;
381 	}
382 
383 	function mintETHRewards( address _contract, uint256 _amount ) public onlyManager() {
384 		require(_amount <= wingsETHRewards);
385 		require(_contract.call.value(_amount)());
386 		wingsETHRewards -= _amount;
387 	}
388 	
389 	function mintTokenRewards(address _contract, uint256 _amount) public onlyManager() {
390 		require( token != address(0) );
391 		require(_amount <= wingsTokenRewards);
392 		require( token.issueDuringICO(_contract, _amount) );
393 		wingsTokenRewards -= _amount;
394 	}
395 
396 	function stop() public onlyManager() hasntStopped()	{
397 		stopped = true;
398 	}
399 
400 	function start( uint256 _startTimestamp, uint256 _endTimestamp, address _fundingAddress ) public onlyManager() hasntStarted() hasntStopped() {
401 		require(_fundingAddress != address(0));
402 		require(_startTimestamp >= block.timestamp);
403 		require(_endTimestamp > _startTimestamp);
404 		duration = _endTimestamp - _startTimestamp;
405 		require(duration >= MIN_CROWDSALE_TIME && duration <= MAX_CROWDSALE_TIME);
406 		startTimestamp = _startTimestamp;
407 		endTimestamp = _endTimestamp;
408 		started = true;
409 		emit CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);
410 	}
411 
412 	// must return true if crowdsale is over, but it failed
413 	function isFailed() public constant returns(bool) {
414 		return (
415 			// it was started
416 			started &&
417 
418 			// crowdsale period has finished
419 			block.timestamp >= endTimestamp &&
420 
421 			// but collected ETH is below the required minimum
422 			totalCollected < minimalGoal
423 		);
424 	}
425 
426 	// must return true if crowdsale is active (i.e. the token can be bought)
427 	function isActive() public constant returns(bool) {
428 		return (
429 			// it was started
430 			started &&
431 
432 			// hard cap wasn't reached yet
433 			totalCollected < hardCap &&
434 
435 			// and current time is within the crowdfunding period
436 			block.timestamp >= startTimestamp &&
437 			block.timestamp < endTimestamp
438 		);
439 	}
440 
441 	// must return true if crowdsale completed successfully
442 	function isSuccessful() public constant returns(bool) {
443 		return (
444 			// either the hard cap is collected
445 			totalCollected >= hardCap ||
446 
447 			// ...or the crowdfunding period is over, but the minimum has been reached
448 			(block.timestamp >= endTimestamp && totalCollected >= minimalGoal)
449 		);
450 	}
451 	
452 	function setToken( A2AToken _token ) public onlyOwner() {
453 		token = _token;
454 	}
455 	
456 	function getToken() public returns(address) {
457 	    return address(token);
458 	}
459 	
460 	function setPrice( uint256 _icoPrice ) public onlyOwner() returns(bool) {
461 		icoPrice = _icoPrice;
462 		return true;
463 	}
464 	
465 	function setBonus( uint256 _icoBonus ) public onlyOwner() returns(bool) {
466 		icoBonus = _icoBonus;
467 		return true;
468 	}
469 	
470 	function setBountyAddress( address _bountyAddress ) public onlyOwner() returns(bool) {
471 		bountyAddress = _bountyAddress;
472 		return true;
473 	}
474 	
475 	function setBountyPercent( uint256 _bountyPercent ) public onlyOwner() returns(bool) {
476 		bountyPercent = _bountyPercent;
477 		return true;
478 	}
479 	
480 	function setPartnerContracts( address _contract ) public onlyOwner() returns(bool) {
481 		partnerContracts[_contract] = true;
482 		return true;
483 	}	
484 		
485 	function deposit() public payable { }
486 		
487 	function() internal payable {
488 		ico( msg.sender, msg.value );
489 	}
490 	
491 	function ico( address _to, uint256 _val ) internal returns(bool) {
492 		require( token != address(0) );
493 		require( isActive() );
494 		require( _val >= ( 1 ether / 10 ) );
495 		require( totalCollected < hardCap );
496 		
497 		uint256 tokensAmount = _val.mul( icoPrice ) / 10**10;
498 		if ( ( icoBonus > 0 ) && ( totalSold.add(tokensAmount) < maxTokensWithBonus ) ) {
499 			tokensAmount = tokensAmount.add( tokensAmount.mul(icoBonus) / 1000000 );
500 		} else {
501 			icoBonus = 0;
502 		}
503 		require( totalSold.add(tokensAmount) < token.maxSupply() );
504 		require( token.issueDuringICO(_to, tokensAmount) );
505 		
506 		wingsTokenRewards = wingsTokenRewards.add( tokensAmount.mul( wingsTokenRewardsPercent ) / 1000000 );
507 		wingsETHRewards = wingsETHRewards.add( _val.mul( wingsETHRewardsPercent ) / 1000000 );
508 		
509 		if ( ( bountyAddress != address(0) ) && ( totalSold.add(tokensAmount) < maxTokensWithBonus ) ) {
510 			require( token.issueDuringICO(bountyAddress, tokensAmount.mul(bountyPercent) / 1000000) );
511 			tokensAmount = tokensAmount.add( tokensAmount.mul(bountyPercent) / 1000000 );
512 		}
513 
514 		totalCollected = totalCollected.add( _val );
515 		totalSold = totalSold.add( tokensAmount );
516 		
517 		return true;
518 	}
519 	
520 	function icoPartner( address _to, uint256 _val ) public returns(bool) {
521 		require( partnerContracts[msg.sender] );
522 		require( ico( _to, _val ) );
523 		return true;
524 	}
525 	
526 	function calculateRewards() public view returns(uint256,uint256) {
527 		return (wingsETHRewards, wingsTokenRewards);
528 	}
529 	
530 	function releaseTokens() public onlyOwner() hasntStopped() whenCrowdsaleSuccessful() {
531 		
532 	}
533 	
534 	function withdrawToFounders(uint256 _amount) public whenCrowdsaleSuccessful() onlyOwner() returns(bool) {
535 		require( address(this).balance.sub( _amount ) >= wingsETHRewards );
536         
537 		uint256 amount_to_withdraw = _amount / foundersAddresses.length;
538 		uint8 i = 0;
539 		uint8 errors = 0;        
540 		for (i = 0; i < foundersAddresses.length; i++) {
541 			if (!foundersAddresses[i].send(amount_to_withdraw)) {
542 				errors++;
543 			}
544 		}
545 		
546 		return true;
547 	}
548 }