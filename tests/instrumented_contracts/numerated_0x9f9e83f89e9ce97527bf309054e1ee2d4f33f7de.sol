1 /*
2 	Utility functions for safe math operations.  See link below for more information:
3 	https://ethereum.stackexchange.com/questions/15258/safemath-safe-add-function-assertions-against-overflows
4 */
5 pragma solidity ^0.4.19;
6 
7 contract SafeMath {
8 
9     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256) {
10         uint256 z = x + y;
11         assert((z >= x) && (z >= y));
12         return z;
13     }
14 
15     function safeSubtract(uint256 x, uint256 y) pure internal returns (uint256) {
16         assert(x >= y);
17         uint256 z = x - y;
18         return z;
19     }
20 
21     function safeMult(uint256 x, uint256 y) pure internal returns (uint256) {
22         uint256 z = x * y;
23         assert((x == 0) || (z / x == y));
24         return z;
25     }
26 
27     function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
28         assert(b > 0);
29         uint c = a / b;
30         assert(a == b * c + a % b);
31         return c;
32     }
33 }
34 
35 contract Owner {
36 	
37 	// Token Name
38 	string public name = "FoodCoin";
39 	// Token Symbol
40 	string public symbol = "FOOD";
41 	// Decimals
42 	uint256 public decimals = 8;
43 	// Version 
44 	string public version = "v1";
45 	
46 	// Emission Address
47 	address public emissionAddress = address(0);
48 	// Withdraw address
49 	address public withdrawAddress = address(0);
50 	
51 	// Owners Addresses
52 	mapping ( address => bool ) public ownerAddressMap;
53 	// Owner Address/Number
54 	mapping ( address => uint256 ) public ownerAddressNumberMap;
55 	// Owners List
56 	mapping ( uint256 => address ) public ownerListMap;
57 	// Amount of owners
58 	uint256 public ownerCountInt = 0;
59 
60 	// Modifier - Owner
61 	modifier isOwner {
62         require( ownerAddressMap[msg.sender]==true );
63         _;
64     }
65 	
66 	// Owner Creation/Activation
67 	function ownerOn( address _onOwnerAddress ) external isOwner returns (bool retrnVal) {
68 		// Check if it's a non-zero address
69 		require( _onOwnerAddress != address(0) );
70 		// If the owner is already exist
71 		if ( ownerAddressNumberMap[ _onOwnerAddress ]>0 )
72 		{
73 			// If the owner is disablead, activate him again
74 			if ( !ownerAddressMap[ _onOwnerAddress ] )
75 			{
76 				ownerAddressMap[ _onOwnerAddress ] = true;
77 				retrnVal = true;
78 			}
79 			else
80 			{
81 				retrnVal = false;
82 			}
83 		}
84 		// If the owner is not exist
85 		else
86 		{
87 			ownerAddressMap[ _onOwnerAddress ] = true;
88 			ownerAddressNumberMap[ _onOwnerAddress ] = ownerCountInt;
89 			ownerListMap[ ownerCountInt ] = _onOwnerAddress;
90 			ownerCountInt++;
91 			retrnVal = true;
92 		}
93 	}
94 	
95 	// Owner disabled
96 	function ownerOff( address _offOwnerAddress ) external isOwner returns (bool retrnVal) {
97 		// If owner exist and he is not 0 and active
98 		// 0 owner can`t be off
99 		if ( ownerAddressNumberMap[ _offOwnerAddress ]>0 && ownerAddressMap[ _offOwnerAddress ] )
100 		{
101 			ownerAddressMap[ _offOwnerAddress ] = false;
102 			retrnVal = true;
103 		}
104 		else
105 		{
106 			retrnVal = false;
107 		}
108 	}
109 	
110 	// Token name changing function
111 	function contractNameUpdate( string _newName, bool updateConfirmation ) external isOwner returns (bool retrnVal) {
112 		
113 		if ( updateConfirmation )
114 		{
115 			name = _newName;
116 			retrnVal = true;
117 		}
118 		else
119 		{
120 			retrnVal = false;
121 		}
122 	}
123 	
124 	// Token symbol changing function
125 	function contractSymbolUpdate( string _newSymbol, bool updateConfirmation ) external isOwner returns (bool retrnVal) {
126 
127 		if ( updateConfirmation )
128 		{
129 			symbol = _newSymbol;
130 			retrnVal = true;
131 		}
132 		else
133 		{
134 			retrnVal = false;
135 		}
136 	}
137 	
138 	// Token decimals changing function
139 	function contractDecimalsUpdate( uint256 _newDecimals, bool updateConfirmation ) external isOwner returns (bool retrnVal) {
140 		
141 		if ( updateConfirmation && _newDecimals != decimals )
142 		{
143 			decimals = _newDecimals;
144 			retrnVal = true;
145 		}
146 		else
147 		{
148 			retrnVal = false;
149 		}
150 	}
151 	
152 	// New token emission address setting up 
153 	function emissionAddressUpdate( address _newEmissionAddress ) external isOwner {
154 		emissionAddress = _newEmissionAddress;
155 	}
156 	
157 	// New token withdrawing address setting up
158 	function withdrawAddressUpdate( address _newWithdrawAddress ) external isOwner {
159 		withdrawAddress = _newWithdrawAddress;
160 	}
161 
162 	// Constructor adds owner to undeletable list
163 	function Owner() public {
164 		// Owner creation
165 		ownerAddressMap[ msg.sender ] = true;
166 		ownerAddressNumberMap[ msg.sender ] = ownerCountInt;
167 		ownerListMap[ ownerCountInt ] = msg.sender;
168 		ownerCountInt++;
169 	}
170 }
171 
172 contract SpecialManager is Owner {
173 
174 	// Special Managers Addresses
175 	mapping ( address => bool ) public specialManagerAddressMap;
176 	// Special Manager Address/Number Mapping
177 	mapping ( address => uint256 ) public specialManagerAddressNumberMap;
178 	// Special Managers List
179 	mapping ( uint256 => address ) public specialManagerListMap;
180 	// Special Manager Amount
181 	uint256 public specialManagerCountInt = 0;
182 	
183 	// Special Manager or Owner modifier
184 	modifier isSpecialManagerOrOwner {
185         require( specialManagerAddressMap[msg.sender]==true || ownerAddressMap[msg.sender]==true );
186         _;
187     }
188 	
189 	// Special Manager creation/actination
190 	function specialManagerOn( address _onSpecialManagerAddress ) external isOwner returns (bool retrnVal) {
191 		// Check if it's a non-zero address
192 		require( _onSpecialManagerAddress != address(0) );
193 		// If this special manager already exists
194 		if ( specialManagerAddressNumberMap[ _onSpecialManagerAddress ]>0 )
195 		{
196 			// If this special manager disabled, activate him again
197 			if ( !specialManagerAddressMap[ _onSpecialManagerAddress ] )
198 			{
199 				specialManagerAddressMap[ _onSpecialManagerAddress ] = true;
200 				retrnVal = true;
201 			}
202 			else
203 			{
204 				retrnVal = false;
205 			}
206 		}
207 		// If this special manager doesn`t exist
208 		else
209 		{
210 			specialManagerAddressMap[ _onSpecialManagerAddress ] = true;
211 			specialManagerAddressNumberMap[ _onSpecialManagerAddress ] = specialManagerCountInt;
212 			specialManagerListMap[ specialManagerCountInt ] = _onSpecialManagerAddress;
213 			specialManagerCountInt++;
214 			retrnVal = true;
215 		}
216 	}
217 	
218 	// Special manager disactivation
219 	function specialManagerOff( address _offSpecialManagerAddress ) external isOwner returns (bool retrnVal) {
220 		// If this special manager exists and he is non-zero and also active 
221 		// 0-number manager can`t be disactivated
222 		if ( specialManagerAddressNumberMap[ _offSpecialManagerAddress ]>0 && specialManagerAddressMap[ _offSpecialManagerAddress ] )
223 		{
224 			specialManagerAddressMap[ _offSpecialManagerAddress ] = false;
225 			retrnVal = true;
226 		}
227 		else
228 		{
229 			retrnVal = false;
230 		}
231 	}
232 
233 
234 	// Constructor adds owner to superowner list
235 	function SpecialManager() public {
236 		// owner creation
237 		specialManagerAddressMap[ msg.sender ] = true;
238 		specialManagerAddressNumberMap[ msg.sender ] = specialManagerCountInt;
239 		specialManagerListMap[ specialManagerCountInt ] = msg.sender;
240 		specialManagerCountInt++;
241 	}
242 }
243 
244 
245 contract Manager is SpecialManager {
246 	
247 	// Managers addresses
248 	mapping ( address => bool ) public managerAddressMap;
249 	// Manager Address/Number Mapping
250 	mapping ( address => uint256 ) public managerAddressNumberMap;
251 	// Managers` List
252 	mapping ( uint256 => address ) public managerListMap;
253 	// Amount of managers
254 	uint256 public managerCountInt = 0;
255 	
256 	// Modifier - Manager Or Owner
257 	modifier isManagerOrOwner {
258         require( managerAddressMap[msg.sender]==true || ownerAddressMap[msg.sender]==true );
259         _;
260     }
261 	
262 	// Owner Creation/Activation
263 	function managerOn( address _onManagerAddress ) external isOwner returns (bool retrnVal) {
264 		// Check if it's a non-zero address
265 		require( _onManagerAddress != address(0) );
266 		// If this special manager exists
267 		if ( managerAddressNumberMap[ _onManagerAddress ]>0 )
268 		{
269 			// If this special manager disabled, activate him again
270 			if ( !managerAddressMap[ _onManagerAddress ] )
271 			{
272 				managerAddressMap[ _onManagerAddress ] = true;
273 				retrnVal = true;
274 			}
275 			else
276 			{
277 				retrnVal = false;
278 			}
279 		}
280 		// If this special manager doesn`t exist
281 		else
282 		{
283 			managerAddressMap[ _onManagerAddress ] = true;
284 			managerAddressNumberMap[ _onManagerAddress ] = managerCountInt;
285 			managerListMap[ managerCountInt ] = _onManagerAddress;
286 			managerCountInt++;
287 			retrnVal = true;
288 		}
289 	}
290 	
291 	// Manager disactivation
292 	function managerOff( address _offManagerAddress ) external isOwner returns (bool retrnVal) {
293 		// if it's a non-zero manager and already exists and active
294 		// 0-number manager can`t be disactivated
295 		if ( managerAddressNumberMap[ _offManagerAddress ]>0 && managerAddressMap[ _offManagerAddress ] )
296 		{
297 			managerAddressMap[ _offManagerAddress ] = false;
298 			retrnVal = true;
299 		}
300 		else
301 		{
302 			retrnVal = false;
303 		}
304 	}
305 
306 
307 	// Constructor adds owner to manager list 
308 	function Manager() public {
309 		// manager creation
310 		managerAddressMap[ msg.sender ] = true;
311 		managerAddressNumberMap[ msg.sender ] = managerCountInt;
312 		managerListMap[ managerCountInt ] = msg.sender;
313 		managerCountInt++;
314 	}
315 }
316 
317 
318 contract Management is Manager {
319 	
320 	// Description
321 	string public description = "";
322 	
323 	// Current tansaction status 
324 	// TRUE - tansaction available
325 	// FALSE - tansaction not available
326 	bool public transactionsOn = false;
327 	// Special permissions to allow/prohibit transactions to move tokens for specific accounts
328 	// 0 - depends on transactionsOn
329 	// 1 - always "forbidden"
330 	// 2 - always "allowed"
331 	mapping ( address => uint256 ) public transactionsOnForHolder;
332 	
333 	
334 	// Displaying tokens in the balanceOf function for all tokens
335 	// TRUE - Displaying available
336 	// FALSE - Displaying hidden, shows 0. Checking the token balance available in function balanceOfReal
337 	bool public balanceOfOn = true;
338 	// Displaying the token balance in function balanceOfReal for definit holder
339 	// 0 - depends on transactionsOn
340 	// 1 - always "forbidden"
341 	// 2 - always "allowed"
342 	mapping ( address => uint256 ) public balanceOfOnForHolder;
343 	
344 	
345 	// Current emission status
346 	// TRUE - emission is available, managers may add tokens to contract
347 	// FALSE - emission isn`t available, managers may not add tokens to contract
348 	bool public emissionOn = true;
349 
350 	// emission cap
351 	uint256 public tokenCreationCap = 0;
352 	
353 	// Addresses list for verification of acoounts owners
354 	// Addresses
355 	mapping ( address => bool ) public verificationAddressMap;
356 	// Verification Address/Number Mapping
357 	mapping ( address => uint256 ) public verificationAddressNumberMap;
358 	// Verification List Mapping
359 	mapping ( uint256 => address ) public verificationListMap;
360 	// Amount of verifications
361 	uint256 public verificationCountInt = 1;
362 	
363 	// Verification holding
364 	// Verification Holders Timestamp
365 	mapping (address => uint256) public verificationHoldersTimestampMap;
366 	// Verification Holders Value
367 	mapping (address => uint256) public verificationHoldersValueMap;
368 	// Verification Holders Verifier Address
369 	mapping (address => address) public verificationHoldersVerifierAddressMap;
370 	// Verification Address Holders List Count
371 	mapping (address => uint256) public verificationAddressHoldersListCountMap;
372 	// Verification Address Holders List Number
373 	mapping (address => mapping ( uint256 => address )) public verificationAddressHoldersListNumberMap;
374 	
375 	// Modifier - Transactions On
376 	modifier isTransactionsOn( address addressFrom ) {
377 		
378 		require( transactionsOnNowVal( addressFrom ) );
379 		_;
380     }
381 	
382 	// Modifier - Emission On
383 	modifier isEmissionOn{
384         require( emissionOn );
385         _;
386     }
387 	
388 	// Function transactions On now validate for definit address 
389 	function transactionsOnNowVal( address addressFrom ) public view returns( bool )
390 	{
391 		return ( transactionsOnForHolder[ addressFrom ]==0 && transactionsOn ) || transactionsOnForHolder[ addressFrom ]==2 ;
392 	}
393 	
394 	// transaction allow/forbidden for definit token holder
395 	function transactionsOnForHolderUpdate( address _to, uint256 _newValue ) external isOwner
396 	{
397 		if ( transactionsOnForHolder[ _to ] != _newValue )
398 		{
399 			transactionsOnForHolder[ _to ] = _newValue;
400 		}
401 	}
402 
403 	// Function of changing allow/forbidden transfer status
404 	function transactionsStatusUpdate( bool _on ) external isOwner
405 	{
406 		transactionsOn = _on;
407 	}
408 	
409 	// Function of changing emission status
410 	function emissionStatusUpdate( bool _on ) external isOwner
411 	{
412 		emissionOn = _on;
413 	}
414 	
415 	// Emission cap setting up
416 	function tokenCreationCapUpdate( uint256 _newVal ) external isOwner
417 	{
418 		tokenCreationCap = _newVal;
419 	}
420 	
421 	// balanceOfOnForHolder; balanceOfOn
422 	
423 	// Function on/off token displaying in function balanceOf
424 	function balanceOfOnUpdate( bool _on ) external isOwner
425 	{
426 		balanceOfOn = _on;
427 	}
428 	
429 	// Function on/off token displaying in function balanceOf for definit token holder
430 	function balanceOfOnForHolderUpdate( address _to, uint256 _newValue ) external isOwner
431 	{
432 		if ( balanceOfOnForHolder[ _to ] != _newValue )
433 		{
434 			balanceOfOnForHolder[ _to ] = _newValue;
435 		}
436 	}
437 	
438 	
439 	// Function adding of new verification address
440 	function verificationAddressOn( address _onVerificationAddress ) external isOwner returns (bool retrnVal) {
441 		// Check if it's a non-zero address
442 		require( _onVerificationAddress != address(0) );
443 		// If this address is already exists
444 		if ( verificationAddressNumberMap[ _onVerificationAddress ]>0 )
445 		{
446 			// If address off, activate it again
447 			if ( !verificationAddressMap[ _onVerificationAddress ] )
448 			{
449 				verificationAddressMap[ _onVerificationAddress ] = true;
450 				retrnVal = true;
451 			}
452 			else
453 			{
454 				retrnVal = false;
455 			}
456 		}
457 		// If this address doesn`t exist
458 		else
459 		{
460 			verificationAddressMap[ _onVerificationAddress ] = true;
461 			verificationAddressNumberMap[ _onVerificationAddress ] = verificationCountInt;
462 			verificationListMap[ verificationCountInt ] = _onVerificationAddress;
463 			verificationCountInt++;
464 			retrnVal = true;
465 		}
466 	}
467 	
468 	// Function of disactivation of verification address
469 	function verificationOff( address _offVerificationAddress ) external isOwner returns (bool retrnVal) {
470 		// If this verification address exists and disabled
471 		if ( verificationAddressNumberMap[ _offVerificationAddress ]>0 && verificationAddressMap[ _offVerificationAddress ] )
472 		{
473 			verificationAddressMap[ _offVerificationAddress ] = false;
474 			retrnVal = true;
475 		}
476 		else
477 		{
478 			retrnVal = false;
479 		}
480 	}
481 	
482 	// Event "Description updated"
483 	event DescriptionPublished( string _description, address _initiator);
484 	
485 	// Description update
486 	function descriptionUpdate( string _newVal ) external isOwner
487 	{
488 		description = _newVal;
489 		DescriptionPublished( _newVal, msg.sender );
490 	}
491 }
492 
493 // Token contract FoodCoin Ecosystem
494 contract FoodcoinEcosystem is SafeMath, Management {
495 	
496 	// Token total supply
497 	uint256 public totalSupply = 0;
498 	
499 	// Balance
500 	mapping ( address => uint256 ) balances;
501 	// Balances List Address
502 	mapping ( uint256 => address ) public balancesListAddressMap;
503 	// Balances List/Number Mapping
504 	mapping ( address => uint256 ) public balancesListNumberMap;
505 	// Balances Address Description
506 	mapping ( address => string ) public balancesAddressDescription;
507 	// Total amount of all balances
508 	uint256 balancesCountInt = 1;
509 	
510 	// Forwarding of address managing for definit amount of tokens
511 	mapping ( address => mapping ( address => uint256 ) ) allowed;
512 	
513 	
514 	// Standard ERC-20 events
515 	// Event - token transfer
516 	event Transfer( address indexed from, address indexed to, uint value );
517 	// Event - Forwarding of address managing
518     event Approval( address indexed owner, address indexed spender, uint value );
519 	
520 	// Token transfer
521 	event FoodTransferEvent( address from, address to, uint256 value, address initiator, uint256 newBalanceFrom, uint256 newBalanceTo );
522 	// Event - Emission
523 	event FoodTokenEmissionEvent( address initiator, address to, uint256 value, bool result, uint256 newBalanceTo );
524 	// Event - Withdraw
525 	event FoodWithdrawEvent( address initiator, address to, bool withdrawOk, uint256 withdraw, uint256 withdrawReal, uint256 newBalancesValue );
526 	
527 	
528 	// Balance View
529 	function balanceOf( address _owner ) external view returns ( uint256 )
530 	{
531 		// If allows to display balance for all or definit holder
532 		if ( ( balanceOfOnForHolder[ _owner ]==0 && balanceOfOn ) || balanceOfOnForHolder[ _owner ]==2 )
533 		{
534 			return balances[ _owner ];
535 		}
536 		else
537 		{
538 			return 0;
539 		}
540 	}
541 	// Real Balance View
542 	function balanceOfReal( address _owner ) external view returns ( uint256 )
543 	{
544 		return balances[ _owner ];
545 	}
546 	// Check if a given user has been delegated rights to perform transfers on behalf of the account owner
547 	function allowance( address _owner, address _initiator ) external view returns ( uint256 remaining )
548 	{
549 		return allowed[ _owner ][ _initiator ];
550 	}
551 	// Total balances quantity
552 	function balancesQuantity() external view returns ( uint256 )
553 	{
554 		return balancesCountInt - 1;
555 	}
556 	
557 	// Function of token transaction. For the first transaction will be created the detailed information
558 	function _addClientAddress( address _balancesAddress, uint256 _amount ) internal
559 	{
560 		// check if this address is not on the list yet
561 		if ( balancesListNumberMap[ _balancesAddress ] == 0 )
562 		{
563 			// add it to the list
564 			balancesListAddressMap[ balancesCountInt ] = _balancesAddress;
565 			balancesListNumberMap[ _balancesAddress ] = balancesCountInt;
566 			// increment account counter
567 			balancesCountInt++;
568 		}
569 		// add tokens to the account 
570 		balances[ _balancesAddress ] = safeAdd( balances[ _balancesAddress ], _amount );
571 	}
572 	// Internal function that performs the actual transfer (cannot be called externally)
573 	function _transfer( address _from, address _to, uint256 _value ) internal isTransactionsOn( _from ) returns ( bool success )
574 	{
575 		// If the amount to transfer is greater than 0, and sender has funds available
576 		if ( _value > 0 && balances[ _from ] >= _value )
577 		{
578 			// Subtract from sender account
579 			balances[ _from ] -= _value;
580 			// Add to receiver's account
581 			_addClientAddress( _to, _value );
582 			// Perform the transfer
583 			Transfer( _from, _to, _value );
584 			FoodTransferEvent( _from, _to, _value, msg.sender, balances[ _from ], balances[ _to ] );
585 			// Successfully completed transfer
586 			return true;
587 		}
588 		// Return false if there are problems
589 		else
590 		{
591 			return false;
592 		}
593 	}
594 	// Function token transfer
595 	function transfer(address _to, uint256 _value) external returns ( bool success )
596 	{
597 		// If it is transfer to verification address
598 		if ( verificationAddressNumberMap[ _to ]>0 )
599 		{
600 			_verification(msg.sender, _to, _value);
601 		}
602 		// Regular transfer
603 		else
604 		{
605 			// Call function transfer. 
606 			return _transfer( msg.sender, _to, _value );
607 		}
608 	}
609 	// Function of transferring tokens from a delegated account
610 	function transferFrom(address _from, address _to, uint256 _value) external isTransactionsOn( _from ) returns ( bool success )
611 	{
612 		// Regular transfer. Not to verification address
613 		require( verificationAddressNumberMap[ _to ]==0 );
614 		// Check if the transfer initiator has permissions to move funds from the sender's account
615 		if ( allowed[_from][msg.sender] >= _value )
616 		{
617 			// If yes - perform transfer 
618 			if ( _transfer( _from, _to, _value ) )
619 			{
620 				// Decrease the total amount that initiator has permissions to access
621 				allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
622 				return true;
623 			}
624 			else
625 			{
626 				return false;
627 			}
628 		}
629 		else
630 		{
631 			return false;
632 		}
633 	}
634 	// Function of delegating account management for a certain amount
635 	function approve( address _initiator, uint256 _value ) external isTransactionsOn( msg.sender ) returns ( bool success )
636 	{
637 		// Grant the rights for a certain amount of tokens only
638 		allowed[ msg.sender ][ _initiator ] = _value;
639 		// Initiate the Approval event
640 		Approval( msg.sender, _initiator, _value );
641 		return true;
642 	}
643 	
644 	// The emission function (the manager or contract owner creates tokens and sends them to a specific account)
645 	function _emission (address _reciever, uint256 _amount) internal isManagerOrOwner isEmissionOn returns ( bool returnVal )
646 	{
647 		// if non-zero address
648 		if ( _reciever != address(0) )
649 		{
650 			// Calculate number of tokens after generation
651 			uint256 checkedSupply = safeAdd( totalSupply, _amount );
652 			// Emission amount
653 			uint256 amountTmp = _amount;
654 			// If emission cap settled additional emission is impossible
655 			if ( tokenCreationCap > 0 && tokenCreationCap < checkedSupply )
656 			{
657 				amountTmp = 0;
658 			}
659 			// if try to add more than 0 tokens
660 			if ( amountTmp > 0 )
661 			{
662 				// If no error, add generated tokens to a given address
663 				_addClientAddress( _reciever, amountTmp );
664 				// increase total supply of tokens
665 				totalSupply = checkedSupply;
666 				// event "token transfer"
667 				Transfer( emissionAddress, _reciever, amountTmp );
668 				// event "emission successfull"
669 				FoodTokenEmissionEvent( msg.sender, _reciever, _amount, true, balances[ _reciever ] );
670 			}
671 			else
672 			{
673 				returnVal = false;
674 				// event "emission failed"
675 				FoodTokenEmissionEvent( msg.sender, _reciever, _amount, false, balances[ _reciever ] );
676 			}
677 		}
678 	}
679 	// emission to definit 1 address
680 	function tokenEmission(address _reciever, uint256 _amount) external isManagerOrOwner isEmissionOn returns ( bool returnVal )
681 	{
682 		// Check if it's a non-zero address
683 		require( _reciever != address(0) );
684 		// emission in process
685 		returnVal = _emission( _reciever, _amount );
686 	}
687 	// adding 5 addresses at once
688 	function tokenEmission5( address _reciever_0, uint256 _amount_0, address _reciever_1, uint256 _amount_1, address _reciever_2, uint256 _amount_2, address _reciever_3, uint256 _amount_3, address _reciever_4, uint256 _amount_4 ) external isManagerOrOwner isEmissionOn
689 	{
690 		_emission( _reciever_0, _amount_0 );
691 		_emission( _reciever_1, _amount_1 );
692 		_emission( _reciever_2, _amount_2 );
693 		_emission( _reciever_3, _amount_3 );
694 		_emission( _reciever_4, _amount_4 );
695 	}
696 	
697 	// Function Tokens withdraw
698 	function withdraw( address _to, uint256 _amount ) external isSpecialManagerOrOwner returns ( bool returnVal, uint256 withdrawValue, uint256 newBalancesValue )
699 	{
700 		// check if this is a valid account
701 		if ( balances[ _to ] > 0 )
702 		{
703 			// Withdraw amount
704 			uint256 amountTmp = _amount;
705 			// It is impossible to withdraw more than available on balance
706 			if ( balances[ _to ] < _amount )
707 			{
708 				amountTmp = balances[ _to ];
709 			}
710 			// Withdraw in process
711 			balances[ _to ] = safeSubtract( balances[ _to ], amountTmp );
712 			// Changing of current tokens amount
713 			totalSupply = safeSubtract( totalSupply, amountTmp );
714 			// Return reply
715 			returnVal = true;
716 			withdrawValue = amountTmp;
717 			newBalancesValue = balances[ _to ];
718 			FoodWithdrawEvent( msg.sender, _to, true, _amount, amountTmp, balances[ _to ] );
719 			// Event "Token transfer"
720 			Transfer( _to, withdrawAddress, amountTmp );
721 		}
722 		else
723 		{
724 			returnVal = false;
725 			withdrawValue = 0;
726 			newBalancesValue = 0;
727 			FoodWithdrawEvent( msg.sender, _to, false, _amount, 0, balances[ _to ] );
728 		}
729 	}
730 	
731 	// Balance description update
732 	function balancesAddressDescriptionUpdate( string _newDescription ) external returns ( bool returnVal )
733 	{
734 		// If this address or contrat`s owher exists
735 		if ( balancesListNumberMap[ msg.sender ] > 0 || ownerAddressMap[msg.sender]==true )
736 		{
737 			balancesAddressDescription[ msg.sender ] = _newDescription;
738 			returnVal = true;
739 		}
740 		else
741 		{
742 			returnVal = false;
743 		}
744 	}
745 	
746 	// Recording of verification details
747 	function _verification( address _from, address _verificationAddress, uint256 _value) internal
748 	{
749 		// If verification address is active
750 		require( verificationAddressMap[ _verificationAddress ] );
751 		
752 		// If it is updating of already verificated address
753 		if ( verificationHoldersVerifierAddressMap[ _from ] == _verificationAddress )
754 		{
755 			// Verification Address Holders List Count
756 			uint256 tmpNumberVerification = verificationAddressHoldersListCountMap[ _verificationAddress ];
757 			verificationAddressHoldersListCountMap[ _verificationAddress ]++;
758 			// Verification Address Holders List Number
759 			verificationAddressHoldersListNumberMap[ _verificationAddress ][ tmpNumberVerification ] = _from;
760 		}
761 		
762 		// Verification Holders Timestamp 
763 		verificationHoldersTimestampMap[ _from ] = now;
764 		// Verification Value
765 		verificationHoldersValueMap[ _from ] = _value;
766 		// Verification Holders Verifier Address
767 		verificationHoldersVerifierAddressMap[ _from ] = _verificationAddress;
768 	}
769 }