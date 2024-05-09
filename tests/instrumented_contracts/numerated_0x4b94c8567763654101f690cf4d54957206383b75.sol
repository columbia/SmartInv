1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Ownable {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     function Ownable() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, newOwner);
27         owner = newOwner;
28         newOwner = address(0);
29     }
30 }
31 
32 contract Pausable is Ownable {
33 	event Pause();
34 	event Unpause();
35 
36 	bool public paused = false;
37 
38 
39 	/**
40 	 * @dev modifier to allow actions only when the contract IS paused
41 	 */
42 	modifier whenNotPaused() {
43 		require(!paused);
44 		_;
45 	}
46 
47 	/**
48 	 * @dev modifier to allow actions only when the contract IS NOT paused
49 	 */
50 	modifier whenPaused {
51 		require(paused);
52 		_;
53 	}
54 
55 	/**
56 	 * @dev called by the owner to pause, triggers stopped state
57 	 */
58 	function pause() onlyOwner whenNotPaused public returns (bool) {
59 		paused = true;
60 		emit Pause();
61 		return true;
62 	}
63 
64 	/**
65 	 * @dev called by the owner to unpause, returns to normal state
66 	 */
67 	function unpause() onlyOwner whenPaused public returns (bool) {
68 		paused = false;
69 		emit Unpause();
70 		return true;
71 	}
72 }
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     if (a == 0) {
84       return 0;
85     }
86     c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return a / b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 library ContractLib {
120 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
121 	function isContract(address _addr) internal view returns (bool) {
122 		uint length;
123 		assembly {
124 			//retrieve the size of the code on target address, this needs assembly
125 			length := extcodesize(_addr)
126 		}
127 		return (length>0);
128 	}
129 }
130 
131 /*
132 * Contract that is working with ERC223 tokens
133 */
134  
135 contract ContractReceiver {
136 	function tokenFallback(address _from, uint _value, bytes _data) public pure;
137 }
138 
139 // ----------------------------------------------------------------------------
140 // ERC Token Standard #20 Interface
141 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
142 // ----------------------------------------------------------------------------
143 contract ERC20Interface {
144 	function totalSupply() public constant returns (uint);
145 	function balanceOf(address tokenOwner) public constant returns (uint);
146 	function allowance(address tokenOwner, address spender) public constant returns (uint);
147 	function transfer(address to, uint tokens) public returns (bool);
148 	function approve(address spender, uint tokens) public returns (bool);
149 	function transferFrom(address from, address to, uint tokens) public returns (bool);
150 
151 	function name() public constant returns (string);
152 	function symbol() public constant returns (string);
153 	function decimals() public constant returns (uint8);
154 
155 	event Transfer(address indexed from, address indexed to, uint tokens);
156 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
157 }
158 
159 
160  /**
161  * ERC223 token by Dexaran
162  *
163  * https://github.com/Dexaran/ERC223-token-standard
164  */
165  
166 
167  /* New ERC223 contract interface */
168  
169 contract ERC223 is ERC20Interface {
170 	function transfer(address to, uint value, bytes data) public returns (bool);
171 	
172 	event Transfer(address indexed from, address indexed to, uint tokens);
173 	event Transfer(address indexed from, address indexed to, uint value, bytes data);
174 }
175 
176  
177 contract NeoWorldCash is ERC223, Pausable {
178 
179 	using SafeMath for uint256;
180 	using ContractLib for address;
181 
182 	mapping(address => uint) balances;
183 	mapping(address => mapping(address => uint)) allowed;
184 	
185 	string public name;
186 	string public symbol;
187 	uint8 public decimals;
188 	uint256 public totalSupply;
189 
190 	event Burn(address indexed from, uint256 value);
191 	
192 	// ------------------------------------------------------------------------
193 	// Constructor
194 	// ------------------------------------------------------------------------
195 	function NeoWorldCash() public {
196 		symbol = "NASH";
197 		name = "NEOWORLD CASH";
198 		decimals = 18;
199 		totalSupply = 100000000000 * 10**uint(decimals);
200 		balances[msg.sender] = totalSupply;
201 		emit Transfer(address(0), msg.sender, totalSupply);
202 	}
203 	
204 	
205 	// Function to access name of token .
206 	function name() public constant returns (string) {
207 		return name;
208 	}
209 	// Function to access symbol of token .
210 	function symbol() public constant returns (string) {
211 		return symbol;
212 	}
213 	// Function to access decimals of token .
214 	function decimals() public constant returns (uint8) {
215 		return decimals;
216 	}
217 	// Function to access total supply of tokens .
218 	function totalSupply() public constant returns (uint256) {
219 		return totalSupply;
220 	}
221 	
222 	// Function that is called when a user or another contract wants to transfer funds .
223 	function transfer(address _to, uint _value, bytes _data) public whenNotPaused returns (bool) {
224 		require(_to != 0x0);
225 		if(_to.isContract()) {
226 			return transferToContract(_to, _value, _data);
227 		}
228 		else {
229 			return transferToAddress(_to, _value, _data);
230 		}
231 	}
232 	
233 	// Standard function transfer similar to ERC20 transfer with no _data .
234 	// Added due to backwards compatibility reasons .
235 	function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
236 		//standard function transfer similar to ERC20 transfer with no _data
237 		//added due to backwards compatibility reasons
238 		require(_to != 0x0);
239 
240 		bytes memory empty;
241 		if(_to.isContract()) {
242 			return transferToContract(_to, _value, empty);
243 		}
244 		else {
245 			return transferToAddress(_to, _value, empty);
246 		}
247 	}
248 
249 
250 
251 	//function that is called when transaction target is an address
252 	function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
253 		balances[msg.sender] = balanceOf(msg.sender).sub(_value);
254 		balances[_to] = balanceOf(_to).add(_value);
255 		emit Transfer(msg.sender, _to, _value);
256 		emit Transfer(msg.sender, _to, _value, _data);
257 		return true;
258 	}
259 	
260   //function that is called when transaction target is a contract
261   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
262 	    balances[msg.sender] = balanceOf(msg.sender).sub(_value);
263 	    balances[_to] = balanceOf(_to).add(_value);
264 	    ContractReceiver receiver = ContractReceiver(_to);
265 	    receiver.tokenFallback(msg.sender, _value, _data);
266 	    emit Transfer(msg.sender, _to, _value);
267 	    emit Transfer(msg.sender, _to, _value, _data);
268 	    return true;
269 	}
270 	
271 	function balanceOf(address _owner) public constant returns (uint) {
272 		return balances[_owner];
273 	}  
274 
275 	function burn(uint256 _value) public whenNotPaused returns (bool) {
276 		require (_value > 0); 
277 		require (balanceOf(msg.sender) >= _value);            // Check if the sender has enough
278 		balances[msg.sender] = balanceOf(msg.sender).sub(_value);                      // Subtract from the sender
279 		totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
280 		emit Burn(msg.sender, _value);
281 		return true;
282 	}
283 
284 	// ------------------------------------------------------------------------
285 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
286 	// from the token owner's account
287 	//
288 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
289 	// recommends that there are no checks for the approval double-spend attack
290 	// as this should be implemented in user interfaces 
291 	// ------------------------------------------------------------------------
292 	function approve(address spender, uint tokens) public whenNotPaused returns (bool) {
293 		allowed[msg.sender][spender] = tokens;
294 		emit Approval(msg.sender, spender, tokens);
295 		return true;
296 	}
297 
298 	function increaseApproval (address _spender, uint _addedValue) public whenNotPaused
299 	    returns (bool success) {
300 	    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
301 	    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302 	    return true;
303 	}
304 
305 	function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused
306 	    returns (bool success) {
307 	    uint oldValue = allowed[msg.sender][_spender];
308 	    if (_subtractedValue > oldValue) {
309 	      allowed[msg.sender][_spender] = 0;
310 	    } else {
311 	      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312 	    }
313 	    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314 	    return true;
315 	}	
316 
317 	// ------------------------------------------------------------------------
318 	// Transfer `tokens` from the `from` account to the `to` account
319 	// 
320 	// The calling account must already have sufficient tokens approve(...)-d
321 	// for spending from the `from` account and
322 	// - From account must have sufficient balance to transfer
323 	// - Spender must have sufficient allowance to transfer
324 	// - 0 value transfers are allowed
325 	// ------------------------------------------------------------------------
326 	function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool) {
327 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
328 		balances[from] = balances[from].sub(tokens);
329 		balances[to] = balances[to].add(tokens);
330 		emit Transfer(from, to, tokens);
331 		return true;
332 	}
333 
334 	// ------------------------------------------------------------------------
335 	// Returns the amount of tokens approved by the owner that can be
336 	// transferred to the spender's account
337 	// ------------------------------------------------------------------------
338 	function allowance(address tokenOwner, address spender) public constant returns (uint) {
339 		return allowed[tokenOwner][spender];
340 	}
341 
342 	// ------------------------------------------------------------------------
343 	// Don't accept ETH
344 	// ------------------------------------------------------------------------
345 	function () public payable {
346 		revert();
347 	}
348 
349 	// ------------------------------------------------------------------------
350 	// Owner can transfer out any accidentally sent ERC20 tokens
351 	// ------------------------------------------------------------------------
352 	function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool) {
353 		return ERC20Interface(tokenAddress).transfer(owner, tokens);
354 	}
355 
356 	/* RO Token 预售 */
357 	/*
358 	预售的操作流程：
359 	1. 发行需要的新的ERC20 Token
360 	2. 将此Token的预售份额转入本合约地址
361 	3. 设定预售时间和价格
362 	4. 用户可以用过 joinPreSale 函数参加预售，卖完，逾期或者主动结束为止
363 	5. 管理员把预售的到的Nash转出
364 	MISC：因为必须制作预售页面通过MetaMask调用函数所以不存在交易所地址转账的问题。
365 	MISC：外部项目无法自行使用本预售功能
366 	*/
367 	address[] supportedERC20Token;
368 	mapping (address => bool) tokenSupported;
369 	mapping (address => uint256) prices;
370 	mapping (address => uint256) starttime;
371 	mapping (address => uint256) endtime;
372 
373 	uint256 maxTokenCountPerTrans = 10000;
374 	uint256 nashInPool;
375 
376 	event AddSupportedToken(
377 		address _address, 
378 		uint256 _price, 
379 		uint256 _startTime, 
380 		uint256 _endTime);
381 
382 	event RemoveSupportedToken(
383 		address _address
384 	);
385 
386 	function addSupportedToken(
387 		address _address, 
388 		uint256 _price, 
389 		uint256 _startTime, 
390 		uint256 _endTime
391 	) public onlyOwner returns (bool) {
392 		
393 		require(_address != 0x0);
394 		require(_address.isContract());
395 		require(_startTime < _endTime);
396 		require(_price > 0);
397 		require(_endTime > block.timestamp);
398 
399 		for (uint256 i = 0; i < supportedERC20Token.length; i++) {
400 			require(supportedERC20Token[i] != _address);
401 		}
402 
403 		supportedERC20Token.push(_address);
404 		tokenSupported[_address] = true;
405 		prices[_address] = _price;
406 		starttime[_address] = _startTime;
407 		endtime[_address] = _endTime;
408 
409 		emit AddSupportedToken(_address, _price, _startTime, _endTime);
410 
411 		return true;
412 	}
413 
414 	function removeSupportedToken(address _address) public onlyOwner returns (bool) {
415 		require(_address != 0x0);
416 		uint256 length = supportedERC20Token.length;
417 		for (uint256 i = 0; i < length; i++) {
418 			if (supportedERC20Token[i] == _address) {
419 				if (i != length - 1) {
420 					supportedERC20Token[i] = supportedERC20Token[length - 1];
421 				}
422                 delete supportedERC20Token[length-1];
423 				supportedERC20Token.length--;
424 
425 				prices[_address] = 0;
426 				starttime[_address] = 0;
427 				endtime[_address] = 0;
428 				tokenSupported[_address] = false;
429 
430 				emit RemoveSupportedToken(_address);
431 
432 				break;
433 			}
434 		}
435 		return true;
436 	}
437 
438 	modifier canBuy(address _address) { 
439 		require(tokenSupported[_address]);
440 		require(block.timestamp > starttime[_address]);
441 		require(block.timestamp < endtime[_address]);
442 		_; 
443 	}
444 
445 	function joinPreSale(address _tokenAddress, uint256 _tokenCount) public canBuy(_tokenAddress) returns (bool) {
446 		require(prices[_tokenAddress] > 0);
447 		uint256 total = _tokenCount.mul(prices[_tokenAddress]); // will not overflow here since the price will not be high
448 		balances[msg.sender] = balances[msg.sender].sub(total);
449 		nashInPool = nashInPool.add(total);
450 
451 		require(ERC20Interface(_tokenAddress).transfer(msg.sender, _tokenCount));
452 		emit Transfer(msg.sender, this, total);
453 
454 		return true;
455 	}
456 
457 	function transferNashOut(address _to, uint256 count) public onlyOwner returns(bool) {
458 		require(_to != 0x0);
459 		nashInPool = nashInPool.sub(count);
460 		balances[_to] = balances[_to].add(count);
461 
462 		emit Transfer(this, _to, count);
463 
464 		return true;
465 	}
466 
467 	function getSupportedTokens() public view returns (address[]) {
468 		return supportedERC20Token;
469 	}
470 
471 	function getTokenStatus(address _tokenAddress) public view returns (uint256 _starttime, uint256 _endtime, uint256 _price) {
472 		_starttime = starttime[_tokenAddress];
473 		_endtime = endtime[_tokenAddress];
474 		_price = prices[_tokenAddress];
475 	}
476 
477 	/* end of 预售逻辑 */
478 
479 	/* 锁币逻辑 */ 
480 	// 此功能仅供项目组账号使用，使用后锁住自己的币且不能修改
481 
482 	mapping(address => uint256) lockedBalanceTotal;
483 	mapping(address => uint256) lockedStartTime;
484 	mapping(address => uint256) unlockPeriod;
485 	mapping(address => uint256) unlockNumberOfCycles;
486 
487 	mapping(address => uint256) lockedBalanceRemains;
488 	mapping(address => uint256) cyclesUnlocked;
489 
490 	mapping(address => bool) addressAllowToLock;
491 
492 	event Locked (address _address, uint256 _count, uint256 _starttime, uint256 _unlockPeriodInSeconds, uint256 _unlockNumberOfCycles);
493 	event Unlocked (address _address, uint256 _count);
494 
495 	function allowToLock(address _address) public onlyOwner {
496 		require(_address != 0x0);
497 		addressAllowToLock[_address] = true;
498 	}
499 
500 	function disallowToLock(address _address) public onlyOwner {
501 		require(_address != 0x0);
502 		addressAllowToLock[_address] = false;
503 	}
504 
505 	function lock(uint256 _count, uint256 _starttime, uint256 _unlockPeriodInSeconds, uint256 _unlockNumberOfCycles) public returns (bool) {
506 		require(addressAllowToLock[msg.sender]);
507 		require(lockedStartTime[msg.sender] == 0);
508 		require(0 < _unlockNumberOfCycles && _unlockNumberOfCycles <= 10); 
509 		require(_unlockPeriodInSeconds > 0); 
510 		require(_count > 10000);
511 		require(_starttime > 0);
512 
513 		balances[msg.sender] = balances[msg.sender].sub(_count);
514 
515 		lockedBalanceTotal[msg.sender] = _count;
516 		lockedStartTime[msg.sender] = _starttime;
517 		unlockPeriod[msg.sender] = _unlockPeriodInSeconds;
518 		unlockNumberOfCycles[msg.sender] = _unlockNumberOfCycles;
519 
520 		lockedBalanceRemains[msg.sender] = lockedBalanceTotal[msg.sender];
521 
522 		emit Locked (msg.sender, _count, _starttime, _unlockPeriodInSeconds, _unlockNumberOfCycles);
523 
524 		return true;
525 	}
526 
527 	function tryUnlock() public returns (bool) {
528 		require(lockedBalanceRemains[msg.sender] > 0);
529 		uint256 cycle = (block.timestamp.sub(lockedStartTime[msg.sender])) / unlockPeriod[msg.sender];
530 		require(cycle > cyclesUnlocked[msg.sender]);
531 
532 		if (cycle > unlockNumberOfCycles[msg.sender]) {
533 			cycle = unlockNumberOfCycles[msg.sender];
534 		}
535 
536 		uint256 amount = lockedBalanceTotal[msg.sender].mul(cycle - cyclesUnlocked[msg.sender]) / unlockNumberOfCycles[msg.sender] ;
537 		lockedBalanceRemains[msg.sender] = lockedBalanceRemains[msg.sender].sub(amount);
538 		balances[msg.sender] = balances[msg.sender].add(amount);
539 
540 		if (cycle == unlockNumberOfCycles[msg.sender]) {
541 			// cleanup
542 			lockedBalanceTotal[msg.sender] = 0;
543 			lockedStartTime[msg.sender] = 0;
544 			unlockPeriod[msg.sender] = 0;
545 			unlockNumberOfCycles[msg.sender] = 0;
546 			cyclesUnlocked[msg.sender] = 0;
547 
548 			if (lockedBalanceRemains[msg.sender] > 0) {
549 				balances[msg.sender] = balances[msg.sender].add(lockedBalanceRemains[msg.sender]);
550 				lockedBalanceRemains[msg.sender] = 0;
551 			}
552 
553 		}
554 		else {
555 			cyclesUnlocked[msg.sender] = cycle;
556 		}
557 
558 		emit Unlocked(msg.sender, amount);
559 
560 		return true;
561 	}
562 
563 	function getLockStatus(address _address) public view returns (
564 		uint256 _lockTotal, 
565 		uint256 _starttime, 
566 		uint256 _unlockPeriodInSeconds,
567 		uint256 _unlockNumberOfCycles,
568 		uint256 _lockedBalanceRemains,
569 		uint256 _cyclesUnlocked 
570 		 ) {
571 
572 		_lockTotal = lockedBalanceTotal[_address];
573 		_starttime = lockedStartTime[_address];
574 		_unlockPeriodInSeconds = unlockPeriod[_address];
575 		_unlockNumberOfCycles = unlockNumberOfCycles[_address];
576 		_lockedBalanceRemains = lockedBalanceRemains[_address];
577 		_cyclesUnlocked = cyclesUnlocked[_address];
578 
579 	}
580 
581 }