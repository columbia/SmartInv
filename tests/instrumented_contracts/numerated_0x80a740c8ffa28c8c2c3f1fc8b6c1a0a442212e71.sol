1 pragma solidity 0.5.8;
2 // From: https://github.com/mixbytes/solidity/blob/master/contracts/ownership/multiowned.sol
3 // Copyright (C) 2017  MixBytes, LLC
4 
5 // Licensed under the Apache License, Version 2.0 (the "License").
6 // You may not use this file except in compliance with the License.
7 
8 // Unless required by applicable law or agreed to in writing, software
9 // distributed under the License is distributed on an "AS IS" BASIS,
10 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
11 
12 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
13 // Audit, refactoring and improvements by github.com/Eenae
14 
15 // @authors:
16 // Gav Wood <g@ethdev.com>
17 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
18 // single, or, crucially, each of a number of, designated owners.
19 // usage:
20 // use modifiers onlyOwner (just own owned) or onlyManyOwners(hash), whereby the same hash must be provided by
21 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
22 // interior is executed.
23 
24 
25 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
26 // TODO acceptOwnership
27 contract multiowned {
28 
29 	// TYPES
30 
31 	// struct for the status of a pending operation.
32 	struct MultiOwnedOperationPendingState {
33 		// count of confirmations needed
34 		uint256 yetNeeded;
35 
36 		// bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
37 		uint256 ownersDone;
38 
39 		// position of this operation key in m_multiOwnedPendingIndex
40 		uint256 index;
41 	}
42 
43 	// EVENTS
44 
45 	event Confirmation(address owner, bytes32 operation);
46 	event Revoke(address owner, bytes32 operation);
47 	event FinalConfirmation(address owner, bytes32 operation);
48 
49 	// some others are in the case of an owner changing.
50 	event OwnerChanged(address oldOwner, address newOwner);
51 	event OwnerAdded(address newOwner);
52 	event OwnerRemoved(address oldOwner);
53 
54 	// the last one is emitted if the required signatures change
55 	event RequirementChanged(uint256 newRequirement);
56 
57 	// MODIFIERS
58 
59 	// simple single-sig function modifier.
60 	modifier onlyOwner {
61 		require(isOwner(msg.sender), "Auth");
62 		_;
63 	}
64 	// multi-sig function modifier: the operation must have an intrinsic hash in order
65 	// that later attempts can be realised as the same underlying operation and
66 	// thus count as confirmations.
67 	modifier onlyManyOwners(bytes32 _operation) {
68 		if (confirmAndCheck(_operation)) {
69 			_;
70 		}
71 		// Even if required number of confirmations has't been collected yet,
72 		// we can't throw here - because changes to the state have to be preserved.
73 		// But, confirmAndCheck itself will throw in case sender is not an owner.
74 	}
75 
76 	modifier validNumOwners(uint256 _numOwners) {
77 		require(_numOwners > 0 && _numOwners <= c_maxOwners, "NumOwners OOR");
78 		_;
79 	}
80 
81 	modifier multiOwnedValidRequirement(uint256 _required, uint256 _numOwners) {
82 		require(_required > 0 && _required <= _numOwners, "Req OOR");
83 		_;
84 	}
85 
86 	modifier ownerExists(address _address) {
87 		require(isOwner(_address), "Auth");
88 		_;
89 	}
90 
91 	modifier ownerDoesNotExist(address _address) {
92 		require(!isOwner(_address), "Is owner");
93 		_;
94 	}
95 
96 	modifier multiOwnedOperationIsActive(bytes32 _operation) {
97 		require(isOperationActive(_operation), "NoOp");
98 		_;
99 	}
100 
101 	// METHODS
102 
103 	// constructor is given number of sigs required to do protected "onlyManyOwners" transactions
104 	// as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
105 	constructor (address[] memory _owners, uint256 _required)
106 		public
107 		validNumOwners(_owners.length)
108 		multiOwnedValidRequirement(_required, _owners.length)
109 	{
110 		assert(c_maxOwners <= 255);
111 
112 		m_numOwners = _owners.length;
113 		m_multiOwnedRequired = _required;
114 
115 		for (uint256 i = 0; i < _owners.length; ++i)
116 		{
117 			address owner = _owners[i];
118 			// invalid and duplicate addresses are not allowed
119 			require(address(0) != owner && !isOwner(owner), "Exists");  /* not isOwner yet! */
120 
121 			uint256 currentOwnerIndex = checkOwnerIndex(i + 1);  /* first slot is unused */
122 			m_owners[currentOwnerIndex] = owner;
123 			m_ownerIndex[owner] = currentOwnerIndex;
124 		}
125 
126 		assertOwnersAreConsistent();
127 	}
128 
129 	/// @notice replaces an owner `_from` with another `_to`.
130 	/// @param _from address of owner to replace
131 	/// @param _to address of new owner
132 	// All pending operations will be canceled!
133 	function changeOwner(address _from, address _to)
134 		external
135 		ownerExists(_from)
136 		ownerDoesNotExist(_to)
137 		onlyManyOwners(keccak256(msg.data))
138 	{
139 		assertOwnersAreConsistent();
140 
141 		clearPending();
142 		uint256 ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
143 		m_owners[ownerIndex] = _to;
144 		m_ownerIndex[_from] = 0;
145 		m_ownerIndex[_to] = ownerIndex;
146 
147 		assertOwnersAreConsistent();
148 		emit OwnerChanged(_from, _to);
149 	}
150 
151 	/// @notice adds an owner
152 	/// @param _owner address of new owner
153 	// All pending operations will be canceled!
154 	function addOwner(address _owner)
155 		external
156 		ownerDoesNotExist(_owner)
157 		validNumOwners(m_numOwners + 1)
158 		onlyManyOwners(keccak256(msg.data))
159 	{
160 		assertOwnersAreConsistent();
161 
162 		clearPending();
163 		m_numOwners++;
164 		m_owners[m_numOwners] = _owner;
165 		m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
166 
167 		assertOwnersAreConsistent();
168 		emit OwnerAdded(_owner);
169 	}
170 
171 	/// @notice removes an owner
172 	/// @param _owner address of owner to remove
173 	// All pending operations will be canceled!
174 	function removeOwner(address _owner)
175 		external
176 		ownerExists(_owner)
177 		validNumOwners(m_numOwners - 1)
178 		multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
179 		onlyManyOwners(keccak256(msg.data))
180 	{
181 		assertOwnersAreConsistent();
182 
183 		clearPending();
184 		uint256 ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
185 		m_owners[ownerIndex] = address(0);
186 		m_ownerIndex[_owner] = 0;
187 		//make sure m_numOwners is equal to the number of owners and always points to the last owner
188 		reorganizeOwners();
189 
190 		assertOwnersAreConsistent();
191 		emit OwnerRemoved(_owner);
192 	}
193 
194 	/// @notice changes the required number of owner signatures
195 	/// @param _newRequired new number of signatures required
196 	// All pending operations will be canceled!
197 	function changeRequirement(uint256 _newRequired)
198 		external
199 		multiOwnedValidRequirement(_newRequired, m_numOwners)
200 		onlyManyOwners(keccak256(msg.data))
201 	{
202 		m_multiOwnedRequired = _newRequired;
203 		clearPending();
204 		emit RequirementChanged(_newRequired);
205 	}
206 
207 	/// @notice Gets an owner by 0-indexed position
208 	/// @param ownerIndex 0-indexed owner position
209 	function getOwner(uint256 ownerIndex) public view returns (address) {
210 		return m_owners[ownerIndex + 1];
211 	}
212 
213 	/// @notice Gets owners
214 	/// @return memory array of owners
215 	function getOwners() public view returns (address[] memory) {
216 		address[] memory result = new address[](m_numOwners);
217 		for (uint256 i = 0; i < m_numOwners; i++)
218 			result[i] = getOwner(i);
219 
220 		return result;
221 	}
222 
223 	/// @notice checks if provided address is an owner address
224 	/// @param _addr address to check
225 	/// @return true if it's an owner
226 	function isOwner(address _addr) public view returns (bool) {
227 		return m_ownerIndex[_addr] > 0;
228 	}
229 
230 	/// @notice Tests ownership of the current caller.
231 	/// @return true if it's an owner
232 	// It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
233 	// addOwner/changeOwner and to isOwner.
234 	function amIOwner() external view onlyOwner returns (bool) {
235 		return true;
236 	}
237 
238 	/// @notice Revokes a prior confirmation of the given operation
239 	/// @param _operation operation value, typically keccak256(msg.data)
240 	function revoke(bytes32 _operation)
241 		external
242 		multiOwnedOperationIsActive(_operation)
243 		onlyOwner
244 	{
245 		uint256 ownerIndexBit = makeOwnerBitmapBit(msg.sender);
246 		MultiOwnedOperationPendingState storage pending = m_multiOwnedPending[_operation];
247 		require(pending.ownersDone & ownerIndexBit > 0, "Auth");
248 
249 		assertOperationIsConsistent(_operation);
250 
251 		pending.yetNeeded++;
252 		pending.ownersDone -= ownerIndexBit;
253 
254 		assertOperationIsConsistent(_operation);
255 		emit Revoke(msg.sender, _operation);
256 	}
257 
258 	/// @notice Checks if owner confirmed given operation
259 	/// @param _operation operation value, typically keccak256(msg.data)
260 	/// @param _owner an owner address
261 	function hasConfirmed(bytes32 _operation, address _owner)
262 		external
263 		view
264 		multiOwnedOperationIsActive(_operation)
265 		ownerExists(_owner)
266 		returns (bool)
267 	{
268 		return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
269 	}
270 
271 	// INTERNAL METHODS
272 
273 	function confirmAndCheck(bytes32 _operation)
274 		internal
275 		onlyOwner
276 		returns (bool)
277 	{
278 		if (512 == m_multiOwnedPendingIndex.length)
279 			// In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
280 			// we won't be able to do it because of block gas limit.
281 			// Yes, pending confirmations will be lost. Dont see any security or stability implications.
282 			// TODO use more graceful approach like compact or removal of clearPending completely
283 			clearPending();
284 
285 		MultiOwnedOperationPendingState storage pending = m_multiOwnedPending[_operation];
286 
287 		// if we're not yet working on this operation, switch over and reset the confirmation status.
288 		if (! isOperationActive(_operation)) {
289 			// reset count of confirmations needed.
290 			pending.yetNeeded = m_multiOwnedRequired;
291 			// reset which owners have confirmed (none) - set our bitmap to 0.
292 			pending.ownersDone = 0;
293 			pending.index = m_multiOwnedPendingIndex.length++;
294 			m_multiOwnedPendingIndex[pending.index] = _operation;
295 			assertOperationIsConsistent(_operation);
296 		}
297 
298 		// determine the bit to set for this owner.
299 		uint256 ownerIndexBit = makeOwnerBitmapBit(msg.sender);
300 		// make sure we (the message sender) haven't confirmed this operation previously.
301 		if (pending.ownersDone & ownerIndexBit == 0) {
302 			// ok - check if count is enough to go ahead.
303 			assert(pending.yetNeeded > 0);
304 			if (pending.yetNeeded == 1) {
305 				// enough confirmations: reset and run interior.
306 				delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
307 				delete m_multiOwnedPending[_operation];
308 				emit FinalConfirmation(msg.sender, _operation);
309 				return true;
310 			}
311 			else
312 			{
313 				// not enough: record that this owner in particular confirmed.
314 				pending.yetNeeded--;
315 				pending.ownersDone |= ownerIndexBit;
316 				assertOperationIsConsistent(_operation);
317 				emit Confirmation(msg.sender, _operation);
318 			}
319 		}
320 	}
321 
322 	// Reclaims free slots between valid owners in m_owners.
323 	// TODO given that its called after each removal, it could be simplified.
324 	function reorganizeOwners() private {
325 		uint256 free = 1;
326 		uint256 numberOfOwners = m_numOwners;
327 		while (free < numberOfOwners)
328 		{
329 			// iterating to the first free slot from the beginning
330 			while (free < numberOfOwners && m_owners[free] != address(0)) free++;
331 
332 			// iterating to the first occupied slot from the end
333 			while (numberOfOwners > 1 && m_owners[numberOfOwners] == address(0)) numberOfOwners--;
334 
335 			// swap, if possible, so free slot is located at the end after the swap
336 			if (free < numberOfOwners && m_owners[numberOfOwners] != address(0) && m_owners[free] == address(0))
337 			{
338 				// owners between swapped slots should't be renumbered - that saves a lot of gas
339 				m_owners[free] = m_owners[numberOfOwners];
340 				m_ownerIndex[m_owners[free]] = free;
341 				m_owners[numberOfOwners] = address(0);
342 			}
343 		}
344 		m_numOwners = numberOfOwners;
345 	}
346 
347 	function clearPending() private onlyOwner {
348 		uint256 length = m_multiOwnedPendingIndex.length;
349 		// TODO block gas limit
350 		for (uint256 i = 0; i < length; ++i) {
351 			if (m_multiOwnedPendingIndex[i] != 0)
352 				delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
353 		}
354 		delete m_multiOwnedPendingIndex;
355 	}
356 
357 	function checkOwnerIndex(uint256 ownerIndex) internal pure returns (uint256) {
358 		assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
359 		return ownerIndex;
360 	}
361 
362 	function makeOwnerBitmapBit(address owner) private view returns (uint256) {
363 		uint256 ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
364 		return 2 ** ownerIndex;
365 	}
366 
367 	function isOperationActive(bytes32 _operation) private view returns (bool) {
368 		return 0 != m_multiOwnedPending[_operation].yetNeeded;
369 	}
370 
371 
372 	function assertOwnersAreConsistent() private view {
373 		assert(m_numOwners > 0);
374 		assert(m_numOwners <= c_maxOwners);
375 		assert(m_owners[0] == address(0));
376 		assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
377 	}
378 
379 	function assertOperationIsConsistent(bytes32 _operation) private view {
380 		MultiOwnedOperationPendingState storage pending = m_multiOwnedPending[_operation];
381 		assert(0 != pending.yetNeeded);
382 		assert(m_multiOwnedPendingIndex[pending.index] == _operation);
383 		assert(pending.yetNeeded <= m_multiOwnedRequired);
384 	}
385 
386 
387 	// FIELDS
388 
389 	uint256 constant c_maxOwners = 250;
390 
391 	// the number of owners that must confirm the same operation before it is run.
392 	uint256 public m_multiOwnedRequired;
393 
394 
395 	// pointer used to find a free slot in m_owners
396 	uint256 public m_numOwners;
397 
398 	// list of owners (addresses),
399 	// slot 0 is unused so there are no owner which index is 0.
400 	// TODO could we save space at the end of the array for the common case of <10 owners? and should we?
401 	address[256] internal m_owners;
402 
403 	// index on the list of owners to allow reverse lookup: owner address => index in m_owners
404 	mapping(address => uint256) internal m_ownerIndex;
405 
406 
407 	// the ongoing operations.
408 	mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
409 	bytes32[] internal m_multiOwnedPendingIndex;
410 }
411 
412 
413 /**
414 * @title ERC20Basic
415 * @dev Simpler version of ERC20 interface
416 * See https://github.com/ethereum/EIPs/issues/179
417 */
418 contract ERC20Basic {
419 	function totalSupply() public view returns (uint256);
420 	function balanceOf(address who) public view returns (uint256);
421 	function transfer(address to, uint256 value) public returns (bool);
422 	event Transfer(address indexed from, address indexed to, uint256 value);
423 }
424 
425 /**
426 * @title SafeMath
427 * @dev Math operations with safety checks that throw on error
428 */
429 library SafeMath {
430 
431 	/**
432 	* @dev Multiplies two numbers, throws on overflow.
433 	*/
434 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
435 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
436 		// benefit is lost if 'b' is also tested.
437 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
438 		if (a == 0) {
439 			return 0;
440 		}
441 
442 		c = a * b;
443 		assert(c / a == b);
444 		return c;
445 	}
446 
447 	/**
448 	* @dev Integer division of two numbers, truncating the quotient.
449 	*/
450 	/*
451 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
452 		// assert(b > 0); // Solidity automatically throws when dividing by 0
453 		// uint256 c = a / b;
454 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
455 		return a / b;
456 	}
457 	*/
458 
459 	/**
460 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
461 	*/
462 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
463 		assert(b <= a);
464 		return a - b;
465 	}
466 
467 	/**
468 	* @dev Adds two numbers, throws on overflow.
469 	*/
470 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
471 		c = a + b;
472 		assert(c >= a);
473 		return c;
474 	}
475 }
476 
477 
478 /**
479 * @title Basic token
480 * @dev Basic version of StandardToken, with no allowances.
481 */
482 contract BasicToken is ERC20Basic {
483 	using SafeMath for uint256;
484 
485 	mapping(address => uint256) balances;
486 
487 	uint256 totalSupply_;
488 
489 	/**
490 	* @dev Total number of tokens in existence
491 	*/
492 	function totalSupply() public view returns (uint256) {
493 		return totalSupply_;
494 	}
495 
496 	/**
497 	* @dev Transfer token for a specified address
498 	* @param _to The address to transfer to.
499 	* @param _value The amount to be transferred.
500 	*/
501 	function transfer(address _to, uint256 _value) public returns (bool) {
502 		require(_to != address(0), "Self");
503 		require(_value <= balances[msg.sender], "NSF");
504 
505 		balances[msg.sender] = balances[msg.sender].sub(_value);
506 		balances[_to] = balances[_to].add(_value);
507 		emit Transfer(msg.sender, _to, _value);
508 		return true;
509 	}
510 
511 	/**
512 	* @dev Gets the balance of the specified address.
513 	* @param _owner The address to query the the balance of.
514 	* @return An uint256 representing the amount owned by the passed address.
515 	*/
516 	function balanceOf(address _owner) public view returns (uint256) {
517 		return balances[_owner];
518 	}
519 
520 }
521 
522 
523 /**
524 * @title ERC20 interface
525 * @dev see https://github.com/ethereum/EIPs/issues/20
526 */
527 contract ERC20 is ERC20Basic {
528 	function allowance(address owner, address spender) public view returns (uint256);
529 
530 	function transferFrom(address from, address to, uint256 value) public returns (bool);
531 
532 	function approve(address spender, uint256 value) public returns (bool);
533 	event Approval(
534 		address indexed owner,
535 		address indexed spender,
536 		uint256 value
537 	);
538 }
539 
540 
541 /**
542 * @title Standard ERC20 token
543 *
544 * @dev Implementation of the basic standard token.
545 * https://github.com/ethereum/EIPs/issues/20
546 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
547 */
548 contract StandardToken is ERC20, BasicToken {
549 
550 	mapping (address => mapping (address => uint256)) internal allowed;
551 
552 
553 	/**
554 	* @dev Transfer tokens from one address to another
555 	* @param _from address The address which you want to send tokens from
556 	* @param _to address The address which you want to transfer to
557 	* @param _value uint256 the amount of tokens to be transferred
558 	*/
559 	function transferFrom(
560 		address _from,
561 		address _to,
562 		uint256 _value
563 	)
564 	public
565 	returns (bool)
566 	{
567 		require(_to != address(0), "Invl");
568 		require(_value <= balances[_from], "NSF");
569 		require(_value <= allowed[_from][msg.sender], "NFAllowance");
570 
571 		balances[_from] = balances[_from].sub(_value);
572 		balances[_to] = balances[_to].add(_value);
573 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
574 		emit Transfer(_from, _to, _value);
575 		return true;
576 	}
577 
578 	/**
579 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
580 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
581 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
582 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
583 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
584 	* @param _spender The address which will spend the funds.
585 	* @param _value The amount of tokens to be spent.
586 	*/
587 	function approve(address _spender, uint256 _value) public returns (bool) {
588 		allowed[msg.sender][_spender] = _value;
589 		emit Approval(msg.sender, _spender, _value);
590 		return true;
591 	}
592 
593 	/**
594 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
595 	* @param _owner address The address which owns the funds.
596 	* @param _spender address The address which will spend the funds.
597 	* @return A uint256 specifying the amount of tokens still available for the spender.
598 	*/
599 	function allowance(
600 		address _owner,
601 		address _spender
602 	)
603 	public
604 	view
605 	returns (uint256)
606 	{
607 		return allowed[_owner][_spender];
608 	}
609 
610 	/**
611 	* @dev Increase the amount of tokens that an owner allowed to a spender.
612 	* approve should be called when allowed[_spender] == 0. To increment
613 	* allowed value is better to use this function to avoid 2 calls (and wait until
614 	* the first transaction is mined)
615 	* From MonolithDAO Token.sol
616 	* @param _spender The address which will spend the funds.
617 	* @param _addedValue The amount of tokens to increase the allowance by.
618 	*/
619 	function increaseApproval(
620 		address _spender,
621 		uint256 _addedValue
622 	)
623 	public
624 	returns (bool)
625 	{
626 		allowed[msg.sender][_spender] = (
627 		allowed[msg.sender][_spender].add(_addedValue));
628 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
629 		return true;
630 	}
631 
632 	/**
633 	* @dev Decrease the amount of tokens that an owner allowed to a spender.
634 	* approve should be called when allowed[_spender] == 0. To decrement
635 	* allowed value is better to use this function to avoid 2 calls (and wait until
636 	* the first transaction is mined)
637 	* From MonolithDAO Token.sol
638 	* @param _spender The address which will spend the funds.
639 	* @param _subtractedValue The amount of tokens to decrease the allowance by.
640 	*/
641 	function decreaseApproval(
642 		address _spender,
643 		uint256 _subtractedValue
644 	)
645 	public
646 	returns (bool)
647 	{
648 		uint256 oldValue = allowed[msg.sender][_spender];
649 		if (_subtractedValue > oldValue) {
650 			allowed[msg.sender][_spender] = 0;
651 		} else {
652 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
653 		}
654 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
655 		return true;
656 	}
657 
658 }
659 
660 contract SparksterTokenSwap is StandardToken, multiowned {
661 	using SafeMath for uint256;
662 	struct Member {
663 		mapping(uint256 => uint256) weiBalance; // How much wei has this member contributed for this group?
664 		uint256[] groups; // A list of groups this member belongs to.
665 		// Used to see how many locked tokens this user has so we don't have to iterate over all groups;
666 		// we can just iterate over the groups this user belongs to.
667 	}
668 
669 	enum GroupStates {
670 		none,
671 		distributing,
672 		distributed,
673 		unlocked // This value is only set for groups that don't define an unlock time.
674 		// For groups that define an unlock time, the group is unlocked if Group.state == GroupStates.distributed and the unlock time has elapsed; the GroupStates.unlocked state will be ignored.
675 	}
676 
677 	struct Group {
678 		GroupStates state; // Indicates whether the group is distributed or unlocked.
679 		mapping(address => bool) exists; // If exists[address] is true, this address has made a purchase on this group before.
680 		string name;
681 		uint256 ratio; // 1 eth:ratio tokens. This amount represents the decimal amount. ratio*10**decimal = ratio sparks.
682 		uint256 unlockTime; // The timestamp after which tokens in this group are unlocked.
683 		// If set to a truthy value, the group will be considered unlocked after this time elapses and the group is distributed.
684 		uint256 startTime; // Epoch of crowdsale start time.
685 		uint256 phase1endTime; // Epoch of phase1 end time.
686 		uint256 phase2endTime; // Epoch of phase2 end time.
687 		uint256 deadline; // No contributions allowed after this epoch.
688 		uint256 max2; // cap of phase2
689 		uint256 max3; // Total ether this group can collect in phase 3.
690 		uint256 weiTotal; // How much ether has this group collected?
691 		uint256 cap; // The hard ether cap.
692 		uint256 nextDistributionIndex; // The next index to start distributing at.
693 		address[] addresses; // List of addresses that have made a purchase on this group.
694 	}
695 
696 	address[] internal initialSigners = [0xCdF06E2F49F7445098CFA54F52C7f43eE40fa016, 0x0D2b5b40F88cCb05e011509830c2E5003d73FE92, 0x363d591196d3004Ca708DB2049501440718594f5];
697 	address public oracleAddress;
698 	address constant public oldSprkAddress = 0x971d048E737619884f2df75e31c7Eb6412392328;
699 	address public owner; // We call this the owner simply because so many ERC-20 contracts have an owner variable,
700 	// so if an API implements getting the balance of the original token holder by querying balanceOf(owner()), this contract won't break the API.
701 	// But in our implementation, the contract is multiowned so this owner field has no owning significance besides being the token generator.
702 	bool public transferLock = true; // A Global transfer lock. Set to lock down all tokens from all groups.
703 	bool public allowedToBuyBack = false;
704 	bool public allowedToPurchase = false;
705 	string public name;									 // name for display
706 	string public symbol;								 //An identifier
707 	uint8 public decimals;							//How many decimals to show.
708 	uint8 constant internal maxGroups = 100; // Total number of groups we are allowed to create.
709 	uint256 public penalty;
710 	uint256 public maxGasPrice; // The maximum allowed gas for the purchase function.
711 	uint256 internal nextGroupNumber;
712 	uint256 public sellPrice; // sellPrice wei:1 spark token; we won't allow to sell back parts of a token.
713 	uint256 public minimumRequiredBalance; // How much wei is required for the contract to hold that will cover all refunds.
714 	// Owners must leave this much in the contract.
715 	uint256 public openGroupNumber;
716 	mapping(address => Member) internal members; // For reverse member lookup.
717 	mapping(uint256 => Group) internal groups; // For reverse group lookup.
718 	mapping(address => uint256) internal withdrawableBalances; // How much wei is this address allowed to withdraw?
719 	ERC20 oldSprk; // The old Sparkster token contract
720 	event WantsToPurchase(address walletAddress, uint256 weiAmount, uint256 groupNumber, bool inPhase1);
721 	event PurchasedCallbackOnAccept(uint256 groupNumber, address[] addresses);
722 	event WantsToDistribute(uint256 groupNumber);
723 	event NearingHardCap(uint256 groupNumber, uint256 remainder);
724 	event ReachedHardCap(uint256 groupNumber);
725 	event DistributeDone(uint256 groupNumber);
726 	event DistributedBatch(uint256 groupNumber, uint256 howMany);
727 	event ShouldCallDoneDistributing();
728 	event AirdroppedBatch(address[] addresses);
729 	event RefundedBatch(address[] addresses);
730 	event AddToGroup(address walletAddress, uint256 groupNumber);
731 	event ChangedTransferLock(bool transferLock);
732 	event ChangedAllowedToPurchase(bool allowedToPurchase);
733 	event ChangedAllowedToBuyBack(bool allowedToBuyBack);
734 	event SetSellPrice(uint256 sellPrice);
735 
736 	modifier onlyOwnerOrOracle() {
737 		require(isOwner(msg.sender) || msg.sender == oracleAddress, "Auth");
738 		_;
739 	}
740 
741 	modifier onlyManyOwnersOrOracle(bytes32 _operation) {
742 		if (confirmAndCheck(_operation) || msg.sender == oracleAddress)
743 			_;
744 		// Don't throw here since confirmAndCheck needs to preserve state.
745 	}
746 
747 	modifier canTransfer() {
748 		if (!isOwner(msg.sender)) { // Owners are immuned from the transfer lock.
749 			require(!transferLock, "Locked");
750 		}
751 		_;
752 	}
753 
754 	modifier canPurchase() {
755 		require(allowedToPurchase, "Disallowed");
756 		_;
757 	}
758 
759 	modifier canSell() {
760 		require(allowedToBuyBack, "Denied");
761 		_;
762 	}
763 
764 	function() external payable {
765 		purchase();
766 	}
767 
768 	constructor()
769 	multiowned( initialSigners, 2) public {
770 		require(isOwner(msg.sender), "NaO");
771 		oldSprk = ERC20(oldSprkAddress);
772 		owner = msg.sender;
773 		name = "Sparkster";									// Set the name for display purposes
774 		decimals = 18;					 // Amount of decimals for display purposes
775 		symbol = "SPRK";							// Set the symbol for display purposes
776 		maxGasPrice = 40 * 10**9; // Set max gas to 40 Gwei to start with.
777 		uint256 amount = 435000000;
778 		uint256 decimalAmount = amount.mul(uint(10)**decimals);
779 		totalSupply_ = decimalAmount;
780 		balances[msg.sender] = decimalAmount;
781 		emit Transfer(address(0), msg.sender, decimalAmount); // Per erc20 standards-compliance.
782 	}
783 
784 	function swapTokens() public returns(bool) {
785 		require(msg.sender != address(this), "Self"); // Don't let this contract swap tokens with itself.
786 		// First, find out how much the sender has allowed us to spend. This is the amount of Sprk we're allowed to move.
787 		// Sender can set this value by calling increaseApproval on the old contract.
788 		uint256 amountToTransfer = oldSprk.allowance(msg.sender, address(this));
789 		require(amountToTransfer > 0, "Amount==0");
790 		// However many tokens we took away from the user in the old contract, give that amount in our new contract.
791 		balances[msg.sender] = balances[msg.sender].add(amountToTransfer);
792 		balances[owner] = balances[owner].sub(amountToTransfer);
793 		// Finally, transfer the old tokens away from the sender and to our address. This will effectively freeze the tokens because no one can transact on this contract's behalf except the contract.
794 		require(oldSprk.transferFrom(msg.sender, address(this), amountToTransfer), "Transfer");
795 		emit Transfer(owner, msg.sender, amountToTransfer);
796 		return true;
797 	}
798 
799 	function setOwnerAddress(address newAddress) public onlyManyOwners(keccak256(msg.data)) returns(bool) {
800 		require(newAddress != address(0), "Invl");
801 		require(newAddress != owner, "Self");
802 		uint256 oldOwnerBalance = balances[owner];
803 		balances[newAddress] = balances[newAddress].add(oldOwnerBalance);
804 		balances[owner] = 0;
805 		emit Transfer(owner, newAddress, oldOwnerBalance);
806 		owner = newAddress;
807 		return true;
808 	}
809 
810 	function setOracleAddress(address newAddress) public onlyManyOwners(keccak256(msg.data)) returns(bool) {
811 		oracleAddress = newAddress;
812 		return true;
813 	}
814 
815 	function removeOracleAddress() public onlyOwner returns(bool) {
816 		oracleAddress = address(0);
817 		return true;
818 	}
819 
820 	function setMaximumGasPrice(uint256 gweiPrice) public onlyManyOwners(keccak256(msg.data)) returns(bool) {
821 		maxGasPrice = gweiPrice.mul(10**9); // Convert the gwei value to wei.
822 		return true;
823 	}
824 
825 	function purchase() public canPurchase payable returns(bool) {
826 		Member storage memberRecord = members[msg.sender];
827 		Group storage openGroup = groups[openGroupNumber];
828 		require(openGroup.ratio > 0, "Not initialized"); // Group must be initialized.
829 		uint256 currentTimestamp = block.timestamp;
830 		require(currentTimestamp >= openGroup.startTime && currentTimestamp <= openGroup.deadline, "OOR");
831 		// The timestamp must be greater than or equal to the start time and less than or equal to the deadline time
832 		require(openGroup.state == GroupStates.none, "State");
833 		// Don't allow to purchase if we're in the middle of distributing, have already distributed, or have unlocked.
834 		require(tx.gasprice <= maxGasPrice, "Gas price"); // Restrict maximum gas this transaction is allowed to consume.
835 		uint256 weiAmount = msg.value;																		// The amount purchased by the current member
836 		// Updated in purchaseCallbackOnAccept.
837 		require(weiAmount >= 0.1 ether, "Amount<0.1 ether");
838 		uint256 weiTotal = openGroup.weiTotal.add(weiAmount); // Calculate total contribution of all members in this group.
839 		// WeiTotals are updated in purchaseCallbackOnAccept
840 		require(weiTotal <= openGroup.cap, "Cap exceeded");														// Check to see if accepting these funds will put us above the hard ether cap.
841 		uint256 userWeiTotal = memberRecord.weiBalance[openGroupNumber].add(weiAmount); // Calculate the total amount purchased by the current member
842 		if (!openGroup.exists[msg.sender]) { // Has this person not purchased on this group before?
843 			openGroup.addresses.push(msg.sender);
844 			openGroup.exists[msg.sender] = true;
845 			memberRecord.groups.push(openGroupNumber);
846 		}
847 		if(currentTimestamp <= openGroup.phase1endTime){																			 // whether the current timestamp is in the first phase
848 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, true);
849 			return true;
850 		} else if (currentTimestamp <= openGroup.phase2endTime) { // Are we in phase 2?
851 			require(userWeiTotal <= openGroup.max2, "Phase2 cap exceeded"); // Allow to contribute no more than max2 in phase 2.
852 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, false);
853 			return true;
854 		} else { // We've passed both phases 1 and 2.
855 			require(userWeiTotal <= openGroup.max3, "Phase3 cap exceeded"); // Don't allow to contribute more than max3 in phase 3.
856 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, false);
857 			return true;
858 		}
859 	}
860 
861 	function purchaseCallbackOnAccept(
862 		uint256 groupNumber, address[] memory addresses, uint256[] memory weiAmounts)
863 	public onlyManyOwnersOrOracle(keccak256(msg.data)) returns(bool success) {
864 		return accept(groupNumber, addresses, weiAmounts);
865 	}
866 
867 	// Base function for accepts.
868 	// Calling functions should be multisig.
869 	function accept(
870 		uint256 groupNumber, address[] memory addresses, uint256[] memory weiAmounts)
871 	private onlyOwnerOrOracle returns(bool) {
872 		uint256 n = addresses.length;
873 		require(n == weiAmounts.length, "Length");
874 		Group storage theGroup = groups[groupNumber];
875 		uint256 weiTotal = theGroup.weiTotal;
876 		for (uint256 i = 0; i < n; i++) {
877 			Member storage memberRecord = members[addresses[i]];
878 			uint256 weiAmount = weiAmounts[i];
879 			weiTotal = weiTotal.add(weiAmount);								 // Calculate the total amount purchased by all members in this group.
880 			memberRecord.weiBalance[groupNumber] = memberRecord.weiBalance[groupNumber].add(weiAmount);
881 			// Record the total amount purchased by the current member
882 		}
883 		theGroup.weiTotal = weiTotal;
884 		if (getHowMuchUntilHardCap_(groupNumber) <= 100 ether) {
885 			emit NearingHardCap(groupNumber, getHowMuchUntilHardCap_(groupNumber));
886 			if (weiTotal >= theGroup.cap) {
887 				emit ReachedHardCap(groupNumber);
888 			}
889 		}
890 		emit PurchasedCallbackOnAccept(groupNumber, addresses);
891 		return true;
892 	}
893 
894 	function insertAndApprove(uint256 groupNumber, address[] memory addresses, uint256[] memory weiAmounts)
895 	public onlyManyOwnersOrOracle(keccak256(msg.data)) returns(bool) {
896 		uint256 n = addresses.length;
897 		require(n == weiAmounts.length, "Length");
898 		Group storage theGroup = groups[groupNumber];
899 		for (uint256 i = 0; i < n; i++) {
900 			address theAddress = addresses[i];
901 			if (!theGroup.exists[theAddress]) {
902 				theGroup.addresses.push(theAddress);
903 				theGroup.exists[theAddress] = true;
904 				members[theAddress].groups.push(groupNumber);
905 			}
906 		}
907 		return accept(groupNumber, addresses, weiAmounts);
908 	}
909 
910 	function callbackInsertApproveAndDistribute(
911 		uint256 groupNumber, address[] memory addresses, uint256[] memory weiAmounts)
912 	public onlyManyOwnersOrOracle(keccak256(msg.data)) returns(bool) {
913 		uint256 n = addresses.length;
914 		require(n == weiAmounts.length, "Length");
915 		require(getGroupState(groupNumber) != GroupStates.unlocked, "Unlocked");
916 		Group storage theGroup = groups[groupNumber];
917 		uint256 newOwnerSupply = balances[owner];
918 		for (uint256 i = 0; i < n; i++) {
919 			address theAddress = addresses[i];
920 			Member storage memberRecord = members[theAddress];
921 			uint256 weiAmount = weiAmounts[i];
922 			memberRecord.weiBalance[groupNumber] = memberRecord.weiBalance[groupNumber].add(weiAmount);
923 			// Record the total amount purchased by the current member
924 			if (!theGroup.exists[theAddress]) {
925 				theGroup.addresses.push(theAddress);
926 				theGroup.exists[theAddress] = true;
927 				memberRecord.groups.push(groupNumber);
928 			}
929 			uint256 additionalBalance = weiAmount.mul(theGroup.ratio); // Don't give cumulative tokens; one address can be distributed multiple times.
930 			if (additionalBalance > 0) {
931 				balances[theAddress] = balances[theAddress].add(additionalBalance);
932 				newOwnerSupply = newOwnerSupply.sub(additionalBalance); // Update the available number of tokens.
933 				emit Transfer(owner, theAddress, additionalBalance); // Notify exchanges of the distribution.
934 			}
935 		}
936 		balances[owner] = newOwnerSupply;
937 		emit PurchasedCallbackOnAccept(groupNumber, addresses);
938 		if (getGroupState(groupNumber) != GroupStates.distributed)
939 			theGroup.state = GroupStates.distributed;
940 		return true;
941 	}
942 
943 	function getWithdrawableAmount() public view returns(uint256) {
944 		return withdrawableBalances[msg.sender];
945 	}
946 
947 	function withdraw() public returns (bool) {
948 		uint256 amount = withdrawableBalances[msg.sender];
949 		require(amount > 0, "NSF");
950 		withdrawableBalances[msg.sender] = 0;
951 		minimumRequiredBalance = minimumRequiredBalance.sub(amount);
952 		msg.sender.transfer(amount);
953 		return true;
954 	}
955 
956 	function refund(address[] memory addresses, uint256[] memory weiAmounts) public onlyManyOwners(keccak256(msg.data)) returns(bool success) {
957 		uint256 n = addresses.length;
958 		require (n == weiAmounts.length, "Length");
959 		uint256 thePenalty = penalty;
960 		uint256 totalRefund = 0;
961 		for(uint256 i = 0; i < n; i++) {
962 			uint256 weiAmount = weiAmounts[i];
963 			address payable theAddress = address(uint160(address(addresses[i])));
964 			if (thePenalty < weiAmount) {
965 				weiAmount = weiAmount.sub(thePenalty);
966 				totalRefund = totalRefund.add(weiAmount);
967 				withdrawableBalances[theAddress] = withdrawableBalances[theAddress].add(weiAmount);
968 			}
969 		}
970 		require(address(this).balance >= minimumRequiredBalance + totalRefund, "NSF"); // The contract must have enough to refund these addresses.
971 		minimumRequiredBalance = minimumRequiredBalance.add(totalRefund);
972 		emit RefundedBatch(addresses);
973 		return true;
974 	}
975 
976 	function signalDoneDistributing(uint256 groupNumber) public onlyManyOwnersOrOracle(keccak256(msg.data)) {
977 		Group storage theGroup = groups[groupNumber];
978 		theGroup.state = GroupStates.distributed;
979 		emit DistributeDone(groupNumber);
980 	}
981 
982 	function drain(address payable to) public onlyManyOwners(keccak256(msg.data)) returns(bool) {
983 		uint256 amountAllowedToDrain = address(this).balance.sub(minimumRequiredBalance);
984 		require(amountAllowedToDrain > 0, "NSF");
985 		to.transfer(amountAllowedToDrain);
986 		return true;
987 	}
988 
989 	function setPenalty(uint256 newPenalty) public onlyManyOwners(keccak256(msg.data)) returns(bool) {
990 		penalty = newPenalty;
991 		return true;
992 	}
993 
994 	function buyback(uint256 amount) public canSell {
995 		require(sellPrice>0, "sellPrice==0");
996 		uint256 decimalAmount = amount.mul(uint(10)**decimals); // convert the full token value to the smallest unit possible.
997 		require(balances[msg.sender].sub(decimalAmount) >= getLockedTokens_(msg.sender), "NSF"); // Don't allow to sell locked tokens.
998 		balances[msg.sender] = balances[msg.sender].sub(decimalAmount);
999 		// Amount is considered to be how many full tokens the user wants to sell.
1000 		uint256 totalCost = amount.mul(sellPrice); // sellPrice is the per-full-token value.
1001 		minimumRequiredBalance = minimumRequiredBalance.add(totalCost);
1002 		require(address(this).balance >= minimumRequiredBalance, "NSF"); // The contract must have enough funds to cover the selling.
1003 		balances[owner] = balances[owner].add(decimalAmount); // Put these tokens back into the available pile.
1004 		withdrawableBalances[msg.sender] = withdrawableBalances[msg.sender].add(totalCost); // Pay the seller for their tokens.
1005 		emit Transfer(msg.sender, owner, decimalAmount); // Notify exchanges of the sell.
1006 	}
1007 
1008 	function fundContract() public onlyOwnerOrOracle payable { // For the owner to put funds into the contract.
1009 	}
1010 
1011 	function setSellPrice(uint256 thePrice) public onlyManyOwners(keccak256(msg.data)) returns (bool) {
1012 		sellPrice = thePrice;
1013 		emit SetSellPrice(thePrice);
1014 		return true;
1015 	}
1016 
1017 	function setAllowedToBuyBack(bool value) public onlyManyOwners(keccak256(msg.data)) {
1018 		allowedToBuyBack = value;
1019 		emit ChangedAllowedToBuyBack(value);
1020 	}
1021 
1022 	function setAllowedToPurchase(bool value) public onlyManyOwners(keccak256(msg.data)) returns(bool) {
1023 		allowedToPurchase = value;
1024 		emit ChangedAllowedToPurchase(value);
1025 		return true;
1026 	}
1027 
1028 	function createGroup(
1029 		string memory groupName, uint256 startEpoch, uint256 phase1endEpoch, uint256 phase2endEpoch, uint256 deadlineEpoch,
1030 		uint256 unlockAfterEpoch, uint256 phase2weiCap, uint256 phase3weiCap, uint256 hardWeiCap, uint256 ratio) public
1031 	onlyManyOwners(keccak256(msg.data)) returns (bool success, uint256 createdGroupNumber) {
1032 		require(nextGroupNumber < maxGroups, "Too many groups");
1033 		createdGroupNumber = nextGroupNumber;
1034 		Group storage theGroup = groups[createdGroupNumber];
1035 		theGroup.name = groupName;
1036 		theGroup.startTime = startEpoch;
1037 		theGroup.phase1endTime = phase1endEpoch;
1038 		theGroup.phase2endTime = phase2endEpoch;
1039 		theGroup.deadline = deadlineEpoch;
1040 		theGroup.unlockTime = unlockAfterEpoch;
1041 		theGroup.max2 = phase2weiCap;
1042 		theGroup.max3 = phase3weiCap;
1043 		theGroup.cap = hardWeiCap;
1044 		theGroup.ratio = ratio;
1045 		nextGroupNumber++;
1046 		success = true;
1047 	}
1048 
1049 	function getGroup(uint256 groupNumber) public view returns(string memory groupName, string memory status, uint256 phase2cap,
1050 	uint256 phase3cap, uint256 cap, uint256 ratio, uint256 startTime, uint256 phase1endTime, uint256 phase2endTime, uint256 deadline,
1051 	uint256 weiTotal) {
1052 		require(groupNumber < nextGroupNumber, "OOR");
1053 		Group storage theGroup = groups[groupNumber];
1054 		groupName = theGroup.name;
1055 		GroupStates state = getGroupState(groupNumber);
1056 		status = (state == GroupStates.none)? "none"
1057 		:(state == GroupStates.distributing)? "distributing"
1058 		:(state == GroupStates.distributed)? "distributed":"unlocked";
1059 		phase2cap = theGroup.max2;
1060 		phase3cap = theGroup.max3;
1061 		cap = theGroup.cap;
1062 		ratio = theGroup.ratio;
1063 		startTime = theGroup.startTime;
1064 		phase1endTime = theGroup.phase1endTime;
1065 		phase2endTime = theGroup.phase2endTime;
1066 		deadline = theGroup.deadline;
1067 		weiTotal = theGroup.weiTotal;
1068 	}
1069 
1070 	function getGroupUnlockTime(uint256 groupNumber) public view returns(uint256) {
1071 		require(groupNumber < nextGroupNumber, "OOR");
1072 		Group storage theGroup = groups[groupNumber];
1073 		return theGroup.unlockTime;
1074 	}
1075 
1076 	function getHowMuchUntilHardCap_(uint256 groupNumber) internal view returns(uint256) {
1077 		Group storage theGroup = groups[groupNumber];
1078 		if (theGroup.weiTotal > theGroup.cap) { // calling .sub in this situation will throw.
1079 			return 0;
1080 		}
1081 		return theGroup.cap.sub(theGroup.weiTotal);
1082 	}
1083 
1084 	function getHowMuchUntilHardCap() public view returns(uint256) {
1085 		return getHowMuchUntilHardCap_(openGroupNumber);
1086 	}
1087 
1088 	function addMemberToGroup(address walletAddress, uint256 groupNumber) public onlyOwner returns(bool) {
1089 		emit AddToGroup(walletAddress, groupNumber);
1090 		return true;
1091 	}
1092 
1093 	function instructOracleToDistribute(uint256 groupNumber) public onlyOwnerOrOracle returns(bool) {
1094 		require(groupNumber < nextGroupNumber && getGroupState(groupNumber) < GroupStates.distributed, "Dist");
1095 		emit WantsToDistribute(groupNumber);
1096 		return true;
1097 	}
1098 
1099 	function distributeCallback(uint256 groupNumber, uint256 howMany) public onlyManyOwnersOrOracle(keccak256(msg.data)) returns (bool success) {
1100 		Group storage theGroup = groups[groupNumber];
1101 		GroupStates state = getGroupState(groupNumber);
1102 		require(state < GroupStates.distributed, "Dist");
1103 		if (state != GroupStates.distributing) {
1104 			theGroup.state = GroupStates.distributing;
1105 		}
1106 		uint256 n = theGroup.addresses.length;
1107 		uint256 nextDistributionIndex = theGroup.nextDistributionIndex;
1108 		uint256 exclusiveEndIndex = nextDistributionIndex + howMany;
1109 		if (exclusiveEndIndex > n) {
1110 			exclusiveEndIndex = n;
1111 		}
1112 		uint256 newOwnerSupply = balances[owner];
1113 		for (uint256 i = nextDistributionIndex; i < exclusiveEndIndex; i++) {
1114 			address theAddress = theGroup.addresses[i];
1115 			uint256 balance = getUndistributedBalanceOf_(theAddress, groupNumber);
1116 			if (balance > 0) { // No need to waste ticks if they have no tokens to distribute
1117 				balances[theAddress] = balances[theAddress].add(balance);
1118 				newOwnerSupply = newOwnerSupply.sub(balance); // Update the available number of tokens.
1119 				emit Transfer(owner, theAddress, balance); // Notify exchanges of the distribution.
1120 			}
1121 		}
1122 		balances[owner] = newOwnerSupply;
1123 		if (exclusiveEndIndex < n) {
1124 			emit DistributedBatch(groupNumber, howMany);
1125 		} else { // We've finished distributing people
1126 			// However, signalDoneDistributing needs to be manually called since it's multisig. So if we're calling this function from multiple owners then calling signalDoneDistributing from here won't work.
1127 			emit ShouldCallDoneDistributing();
1128 		}
1129 		theGroup.nextDistributionIndex = exclusiveEndIndex; // Usually not necessary if we've finished distribution,
1130 		// but if we don't update this, getHowManyLeftToDistribute will never show 0.
1131 		return true;
1132 	}
1133 
1134 	function getHowManyLeftToDistribute(uint256 groupNumber) public view returns(uint256 remainder) {
1135 		Group storage theGroup = groups[groupNumber];
1136 		return theGroup.addresses.length - theGroup.nextDistributionIndex;
1137 	}
1138 
1139 	function unlock(uint256 groupNumber) public onlyManyOwners(keccak256(msg.data)) returns (bool success) {
1140 		Group storage theGroup = groups[groupNumber];
1141 		require(getGroupState(groupNumber) == GroupStates.distributed, "Undist"); // Distribution must have occurred first.
1142 		require(theGroup.unlockTime == 0, "Unlocktime");
1143 		// If the group has set an explicit unlock time, the admins cannot force an unlock and the unlock will happen automatically.
1144 		theGroup.state = GroupStates.unlocked;
1145 		return true;
1146 	}
1147 
1148 	function liftGlobalLock() public onlyManyOwners(keccak256(msg.data)) returns(bool) {
1149 		transferLock = false;
1150 		emit ChangedTransferLock(transferLock);
1151 		return true;
1152 	}
1153 
1154 	function airdrop( address[] memory addresses, uint256[] memory tokenDecimalAmounts) public onlyManyOwnersOrOracle(keccak256(msg.data))
1155 	returns (bool) {
1156 		uint256 n = addresses.length;
1157 		require(n == tokenDecimalAmounts.length, "Length");
1158 		uint256 newOwnerBalance = balances[owner];
1159 		for (uint256 i = 0; i < n; i++) {
1160 			address theAddress = addresses[i];
1161 			uint256 airdropAmount = tokenDecimalAmounts[i];
1162 			if (airdropAmount > 0) {
1163 				uint256 currentBalance = balances[theAddress];
1164 				balances[theAddress] = currentBalance.add(airdropAmount);
1165 				newOwnerBalance = newOwnerBalance.sub(airdropAmount);
1166 				emit Transfer(owner, theAddress, airdropAmount);
1167 			}
1168 		}
1169 		balances[owner] = newOwnerBalance;
1170 		emit AirdroppedBatch(addresses);
1171 		return true;
1172 	}
1173 
1174 	function transfer(address _to, uint256 _value) public canTransfer returns (bool success) {
1175 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
1176 		require(balances[msg.sender].sub(_value) >= getLockedTokens_(msg.sender), "Not enough tokens");
1177 		return super.transfer(_to, _value);
1178 	}
1179 
1180 	function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool success) {
1181 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
1182 		require(balances[_from].sub(_value) >= getLockedTokens_(_from), "Not enough tokens");
1183 		return super.transferFrom(_from, _to, _value);
1184 	}
1185 
1186 	function setOpenGroup(uint256 groupNumber) public onlyManyOwners(keccak256(msg.data)) returns (bool) {
1187 		require(groupNumber < nextGroupNumber, "OOR");
1188 		openGroupNumber = groupNumber;
1189 		return true;
1190 	}
1191 
1192 	function getGroupState(uint256 groupNumber) public view returns(GroupStates) {
1193 		require(groupNumber < nextGroupNumber, "out of range"); // Must have created at least one group.
1194 		Group storage theGroup = groups[groupNumber];
1195 		if (theGroup.state < GroupStates.distributed)
1196 			return theGroup.state;
1197 		// Here, we have two cases.
1198 		// If this is a time-based group, tokens will only unlock after a certain time. Otherwise, we depend on the group's state being set to unlock.
1199 		if (block.timestamp < theGroup.unlockTime)
1200 			return GroupStates.distributed;
1201 		else if (theGroup.unlockTime > 0) // Here, blocktime exceeds the group unlock time, and we've set an unlock time explicitly
1202 			return GroupStates.unlocked;
1203 		return theGroup.state;
1204 	}
1205 
1206 	function getLockedTokensInGroup_(address walletAddress, uint256 groupNumber) internal view returns (uint256 balance) {
1207 		Member storage theMember = members[walletAddress];
1208 		if (getGroupState(groupNumber) == GroupStates.unlocked) {
1209 			return 0;
1210 		}
1211 		return theMember.weiBalance[groupNumber].mul(groups[groupNumber].ratio);
1212 	}
1213 
1214 	function getLockedTokens_(address walletAddress) internal view returns(uint256 balance) {
1215 		uint256[] storage memberGroups = members[walletAddress].groups;
1216 		uint256 n = memberGroups.length;
1217 		for (uint256 i = 0; i < n; i++) {
1218 			balance = balance.add(getLockedTokensInGroup_(walletAddress, memberGroups[i]));
1219 		}
1220 		return balance;
1221 	}
1222 
1223 	function getLockedTokens(address walletAddress) public view returns(uint256 balance) {
1224 		return getLockedTokens_(walletAddress);
1225 	}
1226 
1227 	function getUndistributedBalanceOf_(address walletAddress, uint256 groupNumber) internal view returns (uint256 balance) {
1228 		Member storage theMember = members[walletAddress];
1229 		Group storage theGroup = groups[groupNumber];
1230 		if (getGroupState(groupNumber) > GroupStates.distributing) {
1231 			return 0;
1232 		}
1233 		return theMember.weiBalance[groupNumber].mul(theGroup.ratio);
1234 	}
1235 
1236 	function getUndistributedBalanceOf(address walletAddress, uint256 groupNumber) public view returns (uint256 balance) {
1237 		return getUndistributedBalanceOf_(walletAddress, groupNumber);
1238 	}
1239 
1240 	function checkMyUndistributedBalance(uint256 groupNumber) public view returns (uint256 balance) {
1241 		return getUndistributedBalanceOf_(msg.sender, groupNumber);
1242 	}
1243 	
1244 	function burn(uint256 amount) public onlyManyOwners(keccak256(msg.data)) {
1245 		balances[owner] = balances[owner].sub(amount);
1246 		totalSupply_ = totalSupply_.sub(amount);
1247 		emit Transfer(owner, address(0), amount);
1248 	}
1249 }