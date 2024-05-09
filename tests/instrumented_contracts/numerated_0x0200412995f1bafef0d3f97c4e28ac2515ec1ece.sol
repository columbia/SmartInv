1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ERC223Receiver.sol
4 
5 /**
6  * @title Contract that will work with ERC223 tokens.
7  */
8 
9 contract ERC223Receiver {
10 	/**
11 	 * @dev Standard ERC223 function that will handle incoming token transfers.
12 	 *
13 	 * @param _from  Token sender address.
14 	 * @param _value Amount of tokens.
15 	 * @param _data  Transaction metadata.
16 	 */
17 	function tokenFallback(address _from, uint _value, bytes _data) public;
18 }
19 
20 // File: zeppelin-solidity/contracts/math/SafeMath.sol
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   /**
51   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76   address public owner;
77 
78 
79   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81 
82   /**
83    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84    * account.
85    */
86   function Ownable() public {
87     owner = msg.sender;
88   }
89 
90   /**
91    * @dev Throws if called by any account other than the owner.
92    */
93   modifier onlyOwner() {
94     require(msg.sender == owner);
95     _;
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address newOwner) public onlyOwner {
103     require(newOwner != address(0));
104     OwnershipTransferred(owner, newOwner);
105     owner = newOwner;
106   }
107 
108 }
109 
110 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
111 
112 /**
113  * @title Claimable
114  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
115  * This allows the new owner to accept the transfer.
116  */
117 contract Claimable is Ownable {
118   address public pendingOwner;
119 
120   /**
121    * @dev Modifier throws if called by any account other than the pendingOwner.
122    */
123   modifier onlyPendingOwner() {
124     require(msg.sender == pendingOwner);
125     _;
126   }
127 
128   /**
129    * @dev Allows the current owner to set the pendingOwner address.
130    * @param newOwner The address to transfer ownership to.
131    */
132   function transferOwnership(address newOwner) onlyOwner public {
133     pendingOwner = newOwner;
134   }
135 
136   /**
137    * @dev Allows the pendingOwner address to finalize the transfer.
138    */
139   function claimOwnership() onlyPendingOwner public {
140     OwnershipTransferred(owner, pendingOwner);
141     owner = pendingOwner;
142     pendingOwner = address(0);
143   }
144 }
145 
146 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
147 
148 /**
149  * @title ERC20Basic
150  * @dev Simpler version of ERC20 interface
151  * @dev see https://github.com/ethereum/EIPs/issues/179
152  */
153 contract ERC20Basic {
154   function totalSupply() public view returns (uint256);
155   function balanceOf(address who) public view returns (uint256);
156   function transfer(address to, uint256 value) public returns (bool);
157   event Transfer(address indexed from, address indexed to, uint256 value);
158 }
159 
160 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
161 
162 /**
163  * @title Basic token
164  * @dev Basic version of StandardToken, with no allowances.
165  */
166 contract BasicToken is ERC20Basic {
167   using SafeMath for uint256;
168 
169   mapping(address => uint256) balances;
170 
171   uint256 totalSupply_;
172 
173   /**
174   * @dev total number of tokens in existence
175   */
176   function totalSupply() public view returns (uint256) {
177     return totalSupply_;
178   }
179 
180   /**
181   * @dev transfer token for a specified address
182   * @param _to The address to transfer to.
183   * @param _value The amount to be transferred.
184   */
185   function transfer(address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[msg.sender]);
188 
189     // SafeMath.sub will throw if there is not enough balance.
190     balances[msg.sender] = balances[msg.sender].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     Transfer(msg.sender, _to, _value);
193     return true;
194   }
195 
196   /**
197   * @dev Gets the balance of the specified address.
198   * @param _owner The address to query the the balance of.
199   * @return An uint256 representing the amount owned by the passed address.
200   */
201   function balanceOf(address _owner) public view returns (uint256 balance) {
202     return balances[_owner];
203   }
204 
205 }
206 
207 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
208 
209 /**
210  * @title ERC20 interface
211  * @dev see https://github.com/ethereum/EIPs/issues/20
212  */
213 contract ERC20 is ERC20Basic {
214   function allowance(address owner, address spender) public view returns (uint256);
215   function transferFrom(address from, address to, uint256 value) public returns (bool);
216   function approve(address spender, uint256 value) public returns (bool);
217   event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
221 
222 /**
223  * @title Standard ERC20 token
224  *
225  * @dev Implementation of the basic standard token.
226  * @dev https://github.com/ethereum/EIPs/issues/20
227  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
228  */
229 contract StandardToken is ERC20, BasicToken {
230 
231   mapping (address => mapping (address => uint256)) internal allowed;
232 
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242     require(_value <= balances[_from]);
243     require(_value <= allowed[_from][msg.sender]);
244 
245     balances[_from] = balances[_from].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248     Transfer(_from, _to, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254    *
255    * Beware that changing an allowance with this method brings the risk that someone may use both the old
256    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259    * @param _spender The address which will spend the funds.
260    * @param _value The amount of tokens to be spent.
261    */
262   function approve(address _spender, uint256 _value) public returns (bool) {
263     allowed[msg.sender][_spender] = _value;
264     Approval(msg.sender, _spender, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Function to check the amount of tokens that an owner allowed to a spender.
270    * @param _owner address The address which owns the funds.
271    * @param _spender address The address which will spend the funds.
272    * @return A uint256 specifying the amount of tokens still available for the spender.
273    */
274   function allowance(address _owner, address _spender) public view returns (uint256) {
275     return allowed[_owner][_spender];
276   }
277 
278   /**
279    * @dev Increase the amount of tokens that an owner allowed to a spender.
280    *
281    * approve should be called when allowed[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   /**
295    * @dev Decrease the amount of tokens that an owner allowed to a spender.
296    *
297    * approve should be called when allowed[_spender] == 0. To decrement
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _subtractedValue The amount of tokens to decrease the allowance by.
303    */
304   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
305     uint oldValue = allowed[msg.sender][_spender];
306     if (_subtractedValue > oldValue) {
307       allowed[msg.sender][_spender] = 0;
308     } else {
309       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
310     }
311     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314 
315 }
316 
317 // File: contracts/ERC223Token.sol
318 
319 /*!	ERC223 token implementation
320  */
321 contract ERC223Token is StandardToken, Claimable {
322 	using SafeMath for uint256;
323 
324 	bool public erc223Activated;
325 
326 	/*!	Whitelisting addresses of smart contracts which have
327 
328 	 */
329 	mapping (address => bool) public whiteListContracts;
330 
331 	/*!	Per user: whitelisting addresses of smart contracts which have
332 
333 	 */
334 	mapping (address => mapping (address => bool) ) public userWhiteListContracts;
335 
336 	function setERC223Activated(bool _activate) public onlyOwner {
337 		erc223Activated = _activate;
338 	}
339 	function setWhiteListContract(address _addr, bool f) public onlyOwner {
340 		whiteListContracts[_addr] = f;
341 	}
342 	function setUserWhiteListContract(address _addr, bool f) public {
343 		userWhiteListContracts[msg.sender][_addr] = f;
344 	}
345 
346 	function checkAndInvokeReceiver(address _to, uint256 _value, bytes _data) internal {
347 		uint codeLength;
348 
349 		assembly {
350 			// Retrieve the size of the code
351 			codeLength := extcodesize(_to)
352 		}
353 
354 		if (codeLength>0) {
355 			ERC223Receiver receiver = ERC223Receiver(_to);
356 			receiver.tokenFallback(msg.sender, _value, _data);
357 		}
358 	}
359 
360 	function transfer(address _to, uint256 _value) public returns (bool) {
361 		bool ok = super.transfer(_to, _value);
362 		if (erc223Activated
363 			&& whiteListContracts[_to] ==false
364 			&& userWhiteListContracts[msg.sender][_to] ==false) {
365 			bytes memory empty;
366 			checkAndInvokeReceiver(_to, _value, empty);
367 		}
368 		return ok;
369 	}
370 
371 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
372 		bool ok = super.transfer(_to, _value);
373 		if (erc223Activated
374 			&& whiteListContracts[_to] ==false
375 			&& userWhiteListContracts[msg.sender][_to] ==false) {
376 			checkAndInvokeReceiver(_to, _value, _data);
377 		}
378 		return ok;
379 	}
380 
381 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
382 		bool ok = super.transferFrom(_from, _to, _value);
383 		if (erc223Activated
384 			&& whiteListContracts[_to] ==false
385 			&& userWhiteListContracts[_from][_to] ==false
386 			&& userWhiteListContracts[msg.sender][_to] ==false) {
387 			bytes memory empty;
388 			checkAndInvokeReceiver(_to, _value, empty);
389 		}
390 		return ok;
391 	}
392 
393 	function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
394 		bool ok = super.transferFrom(_from, _to, _value);
395 		if (erc223Activated
396 			&& whiteListContracts[_to] ==false
397 			&& userWhiteListContracts[_from][_to] ==false
398 			&& userWhiteListContracts[msg.sender][_to] ==false) {
399 			checkAndInvokeReceiver(_to, _value, _data);
400 		}
401 		return ok;
402 	}
403 
404 }
405 
406 // File: contracts/BurnableToken.sol
407 
408 /*!	Functionality to keep burn for owner.
409 	Copy from Burnable token but only for owner
410  */
411 contract BurnableToken is ERC223Token {
412 	using SafeMath for uint256;
413 
414 	/*! Copy from Burnable token but only for owner */
415 
416 	event Burn(address indexed burner, uint256 value);
417 
418 	/**
419 	 * @dev Burns a specific amount of tokens.
420 	 * @param _value The amount of token to be burned.
421 	 */
422 	function burnTokenBurn(uint256 _value) public onlyOwner {
423 		require(_value <= balances[msg.sender]);
424 		// no need to require value <= totalSupply, since that would imply the
425 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
426 
427 		address burner = msg.sender;
428 		balances[burner] = balances[burner].sub(_value);
429 		totalSupply_ = totalSupply_.sub(_value);
430 		Burn(burner, _value);
431 	}
432 }
433 
434 // File: contracts/HoldersToken.sol
435 
436 /*!	Functionality to keep up-to-dated list of all holders.
437  */
438 contract HoldersToken is BurnableToken {
439 	using SafeMath for uint256;
440 
441 	/*!	Keep the list of addresses of holders up-to-dated
442 
443 		other contracts can communicate with or to do operations
444 		with all holders of tokens
445 	 */
446 	mapping (address => bool) public isHolder;
447 	address [] public holders;
448 
449 	function addHolder(address _addr) internal returns (bool) {
450 		if (isHolder[_addr] != true) {
451 			holders[holders.length++] = _addr;
452 			isHolder[_addr] = true;
453 			return true;
454 		}
455 		return false;
456 	}
457 
458 	function transfer(address _to, uint256 _value) public returns (bool) {
459 		require(_to != address(this)); // Prevent transfer to contract itself
460 		bool ok = super.transfer(_to, _value);
461 		addHolder(_to);
462 		return ok;
463 	}
464 
465 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
466 		require(_to != address(this)); // Prevent transfer to contract itself
467 		bool ok = super.transfer(_to, _value, _data);
468 		addHolder(_to);
469 		return ok;
470 	}
471 
472 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
473 		require(_to != address(this)); // Prevent transfer to contract itself
474 		bool ok = super.transferFrom(_from, _to, _value);
475 		addHolder(_to);
476 		return ok;
477 	}
478 
479 	function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
480 		require(_to != address(this)); // Prevent transfer to contract itself
481 		bool ok = super.transferFrom(_from, _to, _value, _data);
482 		addHolder(_to);
483 		return ok;
484 	}
485 
486 }
487 
488 // File: contracts/MigrationAgent.sol
489 
490 /*!	Definition of destination interface
491 	for contract that can be used for migration
492  */
493 contract MigrationAgent {
494 	function migrateFrom(address from, uint256 value) public returns (bool);
495 }
496 
497 // File: contracts/MigratoryToken.sol
498 
499 /*!	Functionality to support migrations to new upgraded contract
500 	for tokens. Only has effect if migrations are enabled and
501 	address of new contract is known.
502  */
503 contract MigratoryToken is HoldersToken {
504 	using SafeMath for uint256;
505 
506 	//! Address of new contract for possible upgrades
507 	address public migrationAgent;
508 	//! Counter to iterate (by portions) through all addresses for migration
509 	uint256 public migrationCountComplete;
510 
511 	/*!	Setup the address for new contract (to migrate coins to)
512 		Can be called only by owner (onlyOwner)
513 	 */
514 	function setMigrationAgent(address agent) public onlyOwner {
515 		migrationAgent = agent;
516 	}
517 
518 	/*!	Migrate tokens to the new token contract
519 		The method can be only called when migration agent is set.
520 
521 		Can be called by user(holder) that would like to transfer
522 		coins to new contract immediately.
523 	 */
524 	function migrate() public returns (bool) {
525 		require(migrationAgent != 0x0);
526 		uint256 value = balances[msg.sender];
527 		balances[msg.sender] = balances[msg.sender].sub(value);
528 		totalSupply_ = totalSupply_.sub(value);
529 		MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
530 		// Notify anyone listening that this migration took place
531 		Migrate(msg.sender, value);
532 		return true;
533 	}
534 
535 	/*!	Migrate holders of tokens to the new contract
536 		The method can be only called when migration agent is set.
537 
538 		Can be called only by owner (onlyOwner)
539 	 */
540 	function migrateHolders(uint256 count) public onlyOwner returns (bool) {
541 		require(count > 0);
542 		require(migrationAgent != 0x0);
543 		// Calculate bounds for processing
544 		count = migrationCountComplete.add(count);
545 		if (count > holders.length) {
546 			count = holders.length;
547 		}
548 		// Process migration
549 		for (uint256 i = migrationCountComplete; i < count; i++) {
550 			address holder = holders[i];
551 			uint value = balances[holder];
552 			balances[holder] = balances[holder].sub(value);
553 			totalSupply_ = totalSupply_.sub(value);
554 			MigrationAgent(migrationAgent).migrateFrom(holder, value);
555 			// Notify anyone listening that this migration took place
556 			Migrate(holder, value);
557 		}
558 		migrationCountComplete = count;
559 		return true;
560 	}
561 
562 	event Migrate(address indexed owner, uint256 value);
563 }
564 
565 // File: contracts/FollowCoin.sol
566 
567 contract FollowCoin is MigratoryToken {
568 	using SafeMath for uint256;
569 
570 	//! Token name FollowCoin
571 	string public name;
572 	//! Token symbol FLLW
573 	string public symbol;
574 	//! Token decimals, 18
575 	uint8 public decimals;
576 
577 	/*!	Contructor
578 	 */
579 	function FollowCoin() public {
580 		name = "FollowCoin";
581 		symbol = "FLLW";
582 		decimals = 18;
583 		totalSupply_ = 515547535173959076174820000;
584 		balances[owner] = totalSupply_;
585 		holders[holders.length++] = owner;
586 		isHolder[owner] = true;
587 	}
588 
589 	//! Address of migration gate to do transferMulti on migration
590 	address public migrationGate;
591 
592 	/*!	Setup the address for new contract (to migrate coins to)
593 		Can be called only by owner (onlyOwner)
594 	 */
595 	function setMigrationGate(address _addr) public onlyOwner {
596 		migrationGate = _addr;
597 	}
598 
599 	/*!	Throws if called by any account other than the migrationGate.
600 	 */
601 	modifier onlyMigrationGate() {
602 		require(msg.sender == migrationGate);
603 		_;
604 	}
605 
606 	/*!	Transfer tokens to multipe destination addresses
607 		Returns list with appropriate (by index) successful statuses.
608 		(string with 0 or 1 chars)
609 	 */
610 	function transferMulti(address [] _tos, uint256 [] _values) public onlyMigrationGate returns (string) {
611 		require(_tos.length == _values.length);
612 		bytes memory return_values = new bytes(_tos.length);
613 
614 		for (uint256 i = 0; i < _tos.length; i++) {
615 			address _to = _tos[i];
616 			uint256 _value = _values[i];
617 			return_values[i] = byte(48); //'0'
618 
619 			if (_to != address(0) &&
620 				_value <= balances[msg.sender]) {
621 
622 				bool ok = transfer(_to, _value);
623 				if (ok) {
624 					return_values[i] = byte(49); //'1'
625 				}
626 			}
627 		}
628 		return string(return_values);
629 	}
630 
631 	/*!	Do not accept incoming ether
632 	 */
633 	function() public payable {
634 		revert();
635 	}
636 }