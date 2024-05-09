1 //v1.0.14
2 //License: Apache2.0
3 pragma solidity ^0.4.8;
4 
5 contract TokenSpender {
6     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
7 }
8 
9 pragma solidity ^0.4.8;
10 
11 contract ERC20 {
12   uint public totalSupply;
13   function balanceOf(address who) constant returns (uint);
14   function allowance(address owner, address spender) constant returns (uint);
15 
16   function transfer(address to, uint value) returns (bool ok);
17   function transferFrom(address from, address to, uint value) returns (bool ok);
18   function approve(address spender, uint value) returns (bool ok);
19   event Transfer(address indexed from, address indexed to, uint value);
20   event Approval(address indexed owner, address indexed spender, uint value);
21 }
22 
23 pragma solidity ^0.4.8;
24 
25 contract SafeMath {
26   function safeMul(uint a, uint b) internal returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint a, uint b) internal returns (uint) {
33     assert(b > 0);
34     uint c = a / b;
35     assert(a == b * c + a % b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a >= b ? a : b;
52   }
53 
54   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55     return a < b ? a : b;
56   }
57 
58   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a >= b ? a : b;
60   }
61 
62   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
63     return a < b ? a : b;
64   }
65 
66   function assert(bool assertion) internal {
67     if (!assertion) {
68       throw;
69     }
70   }
71 }
72 
73 pragma solidity ^0.4.21;
74 
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  * last open zepplin version used for : add sub mul div function : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
80 * commit : https://github.com/OpenZeppelin/zeppelin-solidity/commit/815d9e1f457f57cfbb1b4e889f2255c9a517f661
81  */
82 library SafeMathOZ
83 {
84 	function add(uint256 a, uint256 b) internal pure returns (uint256)
85 	{
86 		uint256 c = a + b;
87 		assert(c >= a);
88 		return c;
89 	}
90 
91 	function sub(uint256 a, uint256 b) internal pure returns (uint256)
92 	{
93 		assert(b <= a);
94 		return a - b;
95 	}
96 
97 	function mul(uint256 a, uint256 b) internal pure returns (uint256)
98 	{
99 		if (a == 0)
100 		{
101 			return 0;
102 		}
103 		uint256 c = a * b;
104 		assert(c / a == b);
105 		return c;
106 	}
107 
108 	function div(uint256 a, uint256 b) internal pure returns (uint256)
109 	{
110 		// assert(b > 0); // Solidity automatically throws when dividing by 0
111 		uint256 c = a / b;
112 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 		return c;
114 	}
115 
116 	function max(uint256 a, uint256 b) internal pure returns (uint256)
117 	{
118 		return a >= b ? a : b;
119 	}
120 
121 	function min(uint256 a, uint256 b) internal pure returns (uint256)
122 	{
123 		return a < b ? a : b;
124 	}
125 
126 	function mulByFraction(uint256 a, uint256 b, uint256 c) internal pure returns (uint256)
127 	{
128 		return div(mul(a, b), c);
129 	}
130 
131 	function percentage(uint256 a, uint256 b) internal pure returns (uint256)
132 	{
133 		return mulByFraction(a, b, 100);
134 	}
135 	// Source : https://ethereum.stackexchange.com/questions/8086/logarithm-math-operation-in-solidity
136 	function log(uint x) internal pure returns (uint y)
137 	{
138 		assembly
139 		{
140 			let arg := x
141 			x := sub(x,1)
142 			x := or(x, div(x, 0x02))
143 			x := or(x, div(x, 0x04))
144 			x := or(x, div(x, 0x10))
145 			x := or(x, div(x, 0x100))
146 			x := or(x, div(x, 0x10000))
147 			x := or(x, div(x, 0x100000000))
148 			x := or(x, div(x, 0x10000000000000000))
149 			x := or(x, div(x, 0x100000000000000000000000000000000))
150 			x := add(x, 1)
151 			let m := mload(0x40)
152 			mstore(m,           0xf8f9cbfae6cc78fbefe7cdc3a1793dfcf4f0e8bbd8cec470b6a28a7a5a3e1efd)
153 			mstore(add(m,0x20), 0xf5ecf1b3e9debc68e1d9cfabc5997135bfb7a7a3938b7b606b5b4b3f2f1f0ffe)
154 			mstore(add(m,0x40), 0xf6e4ed9ff2d6b458eadcdf97bd91692de2d4da8fd2d0ac50c6ae9a8272523616)
155 			mstore(add(m,0x60), 0xc8c0b887b0a8a4489c948c7f847c6125746c645c544c444038302820181008ff)
156 			mstore(add(m,0x80), 0xf7cae577eec2a03cf3bad76fb589591debb2dd67e0aa9834bea6925f6a4a2e0e)
157 			mstore(add(m,0xa0), 0xe39ed557db96902cd38ed14fad815115c786af479b7e83247363534337271707)
158 			mstore(add(m,0xc0), 0xc976c13bb96e881cb166a933a55e490d9d56952b8d4e801485467d2362422606)
159 			mstore(add(m,0xe0), 0x753a6d1b65325d0c552a4d1345224105391a310b29122104190a110309020100)
160 			mstore(0x40, add(m, 0x100))
161 			let magic := 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff
162 			let shift := 0x100000000000000000000000000000000000000000000000000000000000000
163 			let a := div(mul(x, magic), shift)
164 			y := div(mload(add(m,sub(255,a))), shift)
165 			y := add(y, mul(256, gt(arg, 0x8000000000000000000000000000000000000000000000000000000000000000)))
166 		}
167 	}
168 }
169 
170 
171 pragma solidity ^0.4.8;
172 
173 contract Ownable {
174   address public owner;
175 
176   function Ownable() {
177     owner = msg.sender;
178   }
179 
180   modifier onlyOwner() {
181     if (msg.sender == owner)
182       _;
183   }
184 
185   function transferOwnership(address newOwner) onlyOwner {
186     if (newOwner != address(0)) owner = newOwner;
187   }
188 
189 }
190 
191 pragma solidity ^0.4.21;
192 
193 /**
194  * @title Ownable
195  * @dev The Ownable contract has an owner address, and provides basic authorization control
196  * functions, this simplifies the implementation of "user permissions".
197  */
198 contract OwnableOZ
199 {
200 	address public m_owner;
201 	bool    public m_changeable;
202 
203 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205 	/**
206 	 * @dev Throws if called by any account other than the owner.
207 	 */
208 	modifier onlyOwner()
209 	{
210 		require(msg.sender == m_owner);
211 		_;
212 	}
213 
214 	/**
215 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
216 	 * account.
217 	 */
218 	function OwnableOZ() public
219 	{
220 		m_owner      = msg.sender;
221 		m_changeable = true;
222 	}
223 
224 	/**
225 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
226 	 * @param _newOwner The address to transfer ownership to.
227 	 */
228 	function setImmutableOwnership(address _newOwner) public onlyOwner
229 	{
230 		require(m_changeable);
231 		require(_newOwner != address(0));
232 		emit OwnershipTransferred(m_owner, _newOwner);
233 		m_owner      = _newOwner;
234 		m_changeable = false;
235 	}
236 
237 }
238 
239 
240 pragma solidity ^0.4.8;
241 
242 contract RLC is ERC20, SafeMath, Ownable {
243 
244     /* Public variables of the token */
245   string public name;       //fancy name
246   string public symbol;
247   uint8 public decimals;    //How many decimals to show.
248   string public version = 'v0.1';
249   uint public initialSupply;
250   uint public totalSupply;
251   bool public locked;
252   //uint public unlockBlock;
253 
254   mapping(address => uint) balances;
255   mapping (address => mapping (address => uint)) allowed;
256 
257   // lock transfer during the ICO
258   modifier onlyUnlocked() {
259     if (msg.sender != owner && locked) throw;
260     _;
261   }
262 
263   /*
264    *  The RLC Token created with the time at which the crowdsale end
265    */
266 
267   function RLC() {
268     // lock the transfer function during the crowdsale
269     locked = true;
270     //unlockBlock=  now + 45 days; // (testnet) - for mainnet put the block number
271 
272     initialSupply = 87000000000000000;
273     totalSupply = initialSupply;
274     balances[msg.sender] = initialSupply;// Give the creator all initial tokens
275     name = 'iEx.ec Network Token';        // Set the name for display purposes
276     symbol = 'RLC';                       // Set the symbol for display purposes
277     decimals = 9;                        // Amount of decimals for display purposes
278   }
279 
280   function unlock() onlyOwner {
281     locked = false;
282   }
283 
284   function burn(uint256 _value) returns (bool){
285     balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
286     totalSupply = safeSub(totalSupply, _value);
287     Transfer(msg.sender, 0x0, _value);
288     return true;
289   }
290 
291   function transfer(address _to, uint _value) onlyUnlocked returns (bool) {
292     balances[msg.sender] = safeSub(balances[msg.sender], _value);
293     balances[_to] = safeAdd(balances[_to], _value);
294     Transfer(msg.sender, _to, _value);
295     return true;
296   }
297 
298   function transferFrom(address _from, address _to, uint _value) onlyUnlocked returns (bool) {
299     var _allowance = allowed[_from][msg.sender];
300 
301     balances[_to] = safeAdd(balances[_to], _value);
302     balances[_from] = safeSub(balances[_from], _value);
303     allowed[_from][msg.sender] = safeSub(_allowance, _value);
304     Transfer(_from, _to, _value);
305     return true;
306   }
307 
308   function balanceOf(address _owner) constant returns (uint balance) {
309     return balances[_owner];
310   }
311 
312   function approve(address _spender, uint _value) returns (bool) {
313     allowed[msg.sender][_spender] = _value;
314     Approval(msg.sender, _spender, _value);
315     return true;
316   }
317 
318     /* Approve and then comunicate the approved contract in a single tx */
319   function approveAndCall(address _spender, uint256 _value, bytes _extraData){
320       TokenSpender spender = TokenSpender(_spender);
321       if (approve(_spender, _value)) {
322           spender.receiveApproval(msg.sender, _value, this, _extraData);
323       }
324   }
325 
326   function allowance(address _owner, address _spender) constant returns (uint remaining) {
327     return allowed[_owner][_spender];
328   }
329 
330 }
331 
332 
333 pragma solidity ^0.4.21;
334 
335 
336 contract IexecHubInterface
337 {
338 	RLC public rlc;
339 
340 	function attachContracts(
341 		address _tokenAddress,
342 		address _marketplaceAddress,
343 		address _workerPoolHubAddress,
344 		address _appHubAddress,
345 		address _datasetHubAddress)
346 		public;
347 
348 	function setCategoriesCreator(
349 		address _categoriesCreator)
350 	public;
351 
352 	function createCategory(
353 		string  _name,
354 		string  _description,
355 		uint256 _workClockTimeRef)
356 	public returns (uint256 catid);
357 
358 	function createWorkerPool(
359 		string  _description,
360 		uint256 _subscriptionLockStakePolicy,
361 		uint256 _subscriptionMinimumStakePolicy,
362 		uint256 _subscriptionMinimumScorePolicy)
363 	external returns (address createdWorkerPool);
364 
365 	function createApp(
366 		string  _appName,
367 		uint256 _appPrice,
368 		string  _appParams)
369 	external returns (address createdApp);
370 
371 	function createDataset(
372 		string  _datasetName,
373 		uint256 _datasetPrice,
374 		string  _datasetParams)
375 	external returns (address createdDataset);
376 
377 	function buyForWorkOrder(
378 		uint256 _marketorderIdx,
379 		address _workerpool,
380 		address _app,
381 		address _dataset,
382 		string  _params,
383 		address _callback,
384 		address _beneficiary)
385 	external returns (address);
386 
387 	function isWoidRegistred(
388 		address _woid)
389 	public view returns (bool);
390 
391 	function lockWorkOrderCost(
392 		address _requester,
393 		address _workerpool, // Address of a smartcontract
394 		address _app,        // Address of a smartcontract
395 		address _dataset)    // Address of a smartcontract
396 	internal returns (uint256);
397 
398 	function claimFailedConsensus(
399 		address _woid)
400 	public returns (bool);
401 
402 	function finalizeWorkOrder(
403 		address _woid,
404 		string  _stdout,
405 		string  _stderr,
406 		string  _uri)
407 	public returns (bool);
408 
409 	function getCategoryWorkClockTimeRef(
410 		uint256 _catId)
411 	public view returns (uint256 workClockTimeRef);
412 
413 	function existingCategory(
414 		uint256 _catId)
415 	public view  returns (bool categoryExist);
416 
417 	function getCategory(
418 		uint256 _catId)
419 		public view returns (uint256 catid, string name, string  description, uint256 workClockTimeRef);
420 
421 	function getWorkerStatus(
422 		address _worker)
423 	public view returns (address workerPool, uint256 workerScore);
424 
425 	function getWorkerScore(address _worker) public view returns (uint256 workerScore);
426 
427 	function registerToPool(address _worker) public returns (bool subscribed);
428 
429 	function unregisterFromPool(address _worker) public returns (bool unsubscribed);
430 
431 	function evictWorker(address _worker) public returns (bool unsubscribed);
432 
433 	function removeWorker(address _workerpool, address _worker) internal returns (bool unsubscribed);
434 
435 	function lockForOrder(address _user, uint256 _amount) public returns (bool);
436 
437 	function unlockForOrder(address _user, uint256 _amount) public returns (bool);
438 
439 	function lockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
440 
441 	function unlockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
442 
443 	function rewardForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
444 
445 	function seizeForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
446 
447 	function deposit(uint256 _amount) external returns (bool);
448 
449 	function withdraw(uint256 _amount) external returns (bool);
450 
451 	function checkBalance(address _owner) public view returns (uint256 stake, uint256 locked);
452 
453 	function reward(address _user, uint256 _amount) internal returns (bool);
454 
455 	function seize(address _user, uint256 _amount) internal returns (bool);
456 
457 	function lock(address _user, uint256 _amount) internal returns (bool);
458 
459 	function unlock(address _user, uint256 _amount) internal returns (bool);
460 }
461 
462 
463 pragma solidity ^0.4.21;
464 
465 
466 contract IexecHubAccessor
467 {
468 	IexecHubInterface internal iexecHubInterface;
469 
470 	modifier onlyIexecHub()
471 	{
472 		require(msg.sender == address(iexecHubInterface));
473 		_;
474 	}
475 
476 	function IexecHubAccessor(address _iexecHubAddress) public
477 	{
478 		require(_iexecHubAddress != address(0));
479 		iexecHubInterface = IexecHubInterface(_iexecHubAddress);
480 	}
481 
482 }
483 
484 
485 pragma solidity ^0.4.21;
486 
487 
488 contract App is OwnableOZ, IexecHubAccessor
489 {
490 
491 	/**
492 	 * Members
493 	 */
494 	string        public m_appName;
495 	uint256       public m_appPrice;
496 	string        public m_appParams;
497 
498 	/**
499 	 * Constructor
500 	 */
501 	function App(
502 		address _iexecHubAddress,
503 		string  _appName,
504 		uint256 _appPrice,
505 		string  _appParams)
506 	IexecHubAccessor(_iexecHubAddress)
507 	public
508 	{
509 		// tx.origin == owner
510 		// msg.sender == DatasetHub
511 		require(tx.origin != msg.sender);
512 		setImmutableOwnership(tx.origin); // owner → tx.origin
513 
514 		m_appName   = _appName;
515 		m_appPrice  = _appPrice;
516 		m_appParams = _appParams;
517 
518 	}
519 
520 
521 
522 }
523 
524 
525 pragma solidity ^0.4.21;
526 
527 
528 
529 contract AppHub is OwnableOZ // is Owned by IexecHub
530 {
531 
532 	using SafeMathOZ for uint256;
533 
534 	/**
535 	 * Members
536 	 */
537 	mapping(address => uint256)                     m_appCountByOwner;
538 	mapping(address => mapping(uint256 => address)) m_appByOwnerByIndex;
539 	mapping(address => bool)                        m_appRegistered;
540 
541 	mapping(uint256 => address)                     m_appByIndex;
542 	uint256 public                                  m_totalAppCount;
543 
544 	/**
545 	 * Constructor
546 	 */
547 	function AppHub() public
548 	{
549 	}
550 
551 	/**
552 	 * Methods
553 	 */
554 	function isAppRegistered(address _app) public view returns (bool)
555 	{
556 		return m_appRegistered[_app];
557 	}
558 	function getAppsCount(address _owner) public view returns (uint256)
559 	{
560 		return m_appCountByOwner[_owner];
561 	}
562 	function getApp(address _owner, uint256 _index) public view returns (address)
563 	{
564 		return m_appByOwnerByIndex[_owner][_index];
565 	}
566 	function getAppByIndex(uint256 _index) public view returns (address)
567 	{
568 		return m_appByIndex[_index];
569 	}
570 
571 	function addApp(address _owner, address _app) internal
572 	{
573 		uint id = m_appCountByOwner[_owner].add(1);
574 		m_totalAppCount=m_totalAppCount.add(1);
575 		m_appByIndex       [m_totalAppCount] = _app;
576 		m_appCountByOwner  [_owner]          = id;
577 		m_appByOwnerByIndex[_owner][id]      = _app;
578 		m_appRegistered    [_app]            = true;
579 	}
580 
581 	function createApp(
582 		string  _appName,
583 		uint256 _appPrice,
584 		string  _appParams)
585 	public onlyOwner /*owner == IexecHub*/ returns (address createdApp)
586 	{
587 		// tx.origin == owner
588 		// msg.sender == IexecHub
589 		address newApp = new App(
590 			msg.sender,
591 			_appName,
592 			_appPrice,
593 			_appParams
594 		);
595 		addApp(tx.origin, newApp);
596 		return newApp;
597 	}
598 
599 }