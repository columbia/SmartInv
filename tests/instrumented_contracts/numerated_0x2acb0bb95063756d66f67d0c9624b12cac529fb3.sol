1 pragma solidity 0.4.23;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) constant returns (uint256);
45   function transfer(address to, uint256 value) returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 // File: zeppelin-solidity/contracts/token/BasicToken.sol
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances. 
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) returns (bool) {
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   /**
73   * @dev Gets the balance of the specified address.
74   * @param _owner The address to query the the balance of. 
75   * @return An uint256 representing the amount owned by the passed address.
76   */
77   function balanceOf(address _owner) constant returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81 }
82 
83 // File: contracts/token/BurnableToken.sol
84 
85 /**
86  * @title Token which could be burned by any holder.
87  */
88 contract BurnableToken is BasicToken {
89 
90     event Burn(address indexed from, uint256 amount);
91 
92     /**
93      * Function to burn msg.sender's tokens.
94      *
95      * @param _amount amount of tokens to burn
96      *
97      * @return boolean that indicates if the operation was successful
98      */
99     function burn(uint256 _amount)
100         public
101         returns (bool)
102     {
103         address from = msg.sender;
104 
105         require(_amount > 0);
106         require(_amount <= balances[from]);
107 
108         totalSupply = totalSupply.sub(_amount);
109         balances[from] = balances[from].sub(_amount);
110         Burn(from, _amount);
111         Transfer(from, address(0), _amount);
112 
113         return true;
114     }
115 }
116 
117 // File: zeppelin-solidity/contracts/token/ERC20.sol
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender) constant returns (uint256);
125   function transferFrom(address from, address to, uint256 value) returns (bool);
126   function approve(address spender, uint256 value) returns (bool);
127   event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 // File: zeppelin-solidity/contracts/token/StandardToken.sol
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amout of tokens to be transfered
149    */
150   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
151     var _allowance = allowed[_from][msg.sender];
152 
153     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
154     // require (_value <= _allowance);
155 
156     balances[_to] = balances[_to].add(_value);
157     balances[_from] = balances[_from].sub(_value);
158     allowed[_from][msg.sender] = _allowance.sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) returns (bool) {
169 
170     // To change the approve amount you first have to reduce the addresses`
171     //  allowance to zero by calling `approve(_spender, 0)` if it is not
172     //  already 0 to mitigate the race condition described here:
173     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
175 
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifing the amount of tokens still avaible for the spender.
186    */
187   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
188     return allowed[_owner][_spender];
189   }
190 
191 }
192 
193 // File: contracts/token/TokenWithApproveAndCallMethod.sol
194 
195 /// @title Utility interface for approveAndCall token function.
196 interface IApprovalRecipient {
197     /**
198      * @notice Signals that token holder approved spending of tokens and some action should be taken.
199      *
200      * @param _sender token holder which approved spending of his tokens
201      * @param _value amount of tokens approved to be spent
202      * @param _extraData any extra data token holder provided to the call
203      *
204      * @dev warning: implementors should validate sender of this message (it should be the token) and make no further
205      *      assumptions unless validated them via ERC20 methods.
206      */
207     function receiveApproval(address _sender, uint256 _value, bytes _extraData) public;
208 }
209 
210 
211 /**
212  * @title Mixin adds approveAndCall token function.
213  */
214 contract TokenWithApproveAndCallMethod is StandardToken {
215 
216     /**
217      * @notice Approves spending tokens and immediately triggers token recipient logic.
218      *
219      * @param _spender contract which supports IApprovalRecipient and allowed to receive tokens
220      * @param _value amount of tokens approved to be spent
221      * @param _extraData any extra data which to be provided to the _spender
222      *
223      * By invoking this utility function token holder could do two things in one transaction: approve spending his
224      * tokens and execute some external contract which spends them on token holder's behalf.
225      * It can't be known if _spender's invocation succeed or not.
226      * This function will throw if approval failed.
227      */
228     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public {
229         require(approve(_spender, _value));
230         IApprovalRecipient(_spender).receiveApproval(msg.sender, _value, _extraData);
231     }
232 }
233 
234 // File: mixbytes-solidity/contracts/ownership/multiowned.sol
235 
236 // Copyright (C) 2017  MixBytes, LLC
237 
238 // Licensed under the Apache License, Version 2.0 (the "License").
239 // You may not use this file except in compliance with the License.
240 
241 // Unless required by applicable law or agreed to in writing, software
242 // distributed under the License is distributed on an "AS IS" BASIS,
243 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
244 
245 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
246 // Audit, refactoring and improvements by github.com/Eenae
247 
248 // @authors:
249 // Gav Wood <g@ethdev.com>
250 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
251 // single, or, crucially, each of a number of, designated owners.
252 // usage:
253 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
254 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
255 // interior is executed.
256 
257 pragma solidity ^0.4.15;
258 
259 
260 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
261 // TODO acceptOwnership
262 contract multiowned {
263 
264 	// TYPES
265 
266     // struct for the status of a pending operation.
267     struct MultiOwnedOperationPendingState {
268         // count of confirmations needed
269         uint yetNeeded;
270 
271         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
272         uint ownersDone;
273 
274         // position of this operation key in m_multiOwnedPendingIndex
275         uint index;
276     }
277 
278 	// EVENTS
279 
280     event Confirmation(address owner, bytes32 operation);
281     event Revoke(address owner, bytes32 operation);
282     event FinalConfirmation(address owner, bytes32 operation);
283 
284     // some others are in the case of an owner changing.
285     event OwnerChanged(address oldOwner, address newOwner);
286     event OwnerAdded(address newOwner);
287     event OwnerRemoved(address oldOwner);
288 
289     // the last one is emitted if the required signatures change
290     event RequirementChanged(uint newRequirement);
291 
292 	// MODIFIERS
293 
294     // simple single-sig function modifier.
295     modifier onlyowner {
296         require(isOwner(msg.sender));
297         _;
298     }
299     // multi-sig function modifier: the operation must have an intrinsic hash in order
300     // that later attempts can be realised as the same underlying operation and
301     // thus count as confirmations.
302     modifier onlymanyowners(bytes32 _operation) {
303         if (confirmAndCheck(_operation)) {
304             _;
305         }
306         // Even if required number of confirmations has't been collected yet,
307         // we can't throw here - because changes to the state have to be preserved.
308         // But, confirmAndCheck itself will throw in case sender is not an owner.
309     }
310 
311     modifier validNumOwners(uint _numOwners) {
312         require(_numOwners > 0 && _numOwners <= c_maxOwners);
313         _;
314     }
315 
316     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
317         require(_required > 0 && _required <= _numOwners);
318         _;
319     }
320 
321     modifier ownerExists(address _address) {
322         require(isOwner(_address));
323         _;
324     }
325 
326     modifier ownerDoesNotExist(address _address) {
327         require(!isOwner(_address));
328         _;
329     }
330 
331     modifier multiOwnedOperationIsActive(bytes32 _operation) {
332         require(isOperationActive(_operation));
333         _;
334     }
335 
336 	// METHODS
337 
338     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
339     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
340     function multiowned(address[] _owners, uint _required)
341         public
342         validNumOwners(_owners.length)
343         multiOwnedValidRequirement(_required, _owners.length)
344     {
345         assert(c_maxOwners <= 255);
346 
347         m_numOwners = _owners.length;
348         m_multiOwnedRequired = _required;
349 
350         for (uint i = 0; i < _owners.length; ++i)
351         {
352             address owner = _owners[i];
353             // invalid and duplicate addresses are not allowed
354             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
355 
356             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
357             m_owners[currentOwnerIndex] = owner;
358             m_ownerIndex[owner] = currentOwnerIndex;
359         }
360 
361         assertOwnersAreConsistent();
362     }
363 
364     /// @notice replaces an owner `_from` with another `_to`.
365     /// @param _from address of owner to replace
366     /// @param _to address of new owner
367     // All pending operations will be canceled!
368     function changeOwner(address _from, address _to)
369         external
370         ownerExists(_from)
371         ownerDoesNotExist(_to)
372         onlymanyowners(keccak256(msg.data))
373     {
374         assertOwnersAreConsistent();
375 
376         clearPending();
377         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
378         m_owners[ownerIndex] = _to;
379         m_ownerIndex[_from] = 0;
380         m_ownerIndex[_to] = ownerIndex;
381 
382         assertOwnersAreConsistent();
383         OwnerChanged(_from, _to);
384     }
385 
386     /// @notice adds an owner
387     /// @param _owner address of new owner
388     // All pending operations will be canceled!
389     function addOwner(address _owner)
390         external
391         ownerDoesNotExist(_owner)
392         validNumOwners(m_numOwners + 1)
393         onlymanyowners(keccak256(msg.data))
394     {
395         assertOwnersAreConsistent();
396 
397         clearPending();
398         m_numOwners++;
399         m_owners[m_numOwners] = _owner;
400         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
401 
402         assertOwnersAreConsistent();
403         OwnerAdded(_owner);
404     }
405 
406     /// @notice removes an owner
407     /// @param _owner address of owner to remove
408     // All pending operations will be canceled!
409     function removeOwner(address _owner)
410         external
411         ownerExists(_owner)
412         validNumOwners(m_numOwners - 1)
413         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
414         onlymanyowners(keccak256(msg.data))
415     {
416         assertOwnersAreConsistent();
417 
418         clearPending();
419         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
420         m_owners[ownerIndex] = 0;
421         m_ownerIndex[_owner] = 0;
422         //make sure m_numOwners is equal to the number of owners and always points to the last owner
423         reorganizeOwners();
424 
425         assertOwnersAreConsistent();
426         OwnerRemoved(_owner);
427     }
428 
429     /// @notice changes the required number of owner signatures
430     /// @param _newRequired new number of signatures required
431     // All pending operations will be canceled!
432     function changeRequirement(uint _newRequired)
433         external
434         multiOwnedValidRequirement(_newRequired, m_numOwners)
435         onlymanyowners(keccak256(msg.data))
436     {
437         m_multiOwnedRequired = _newRequired;
438         clearPending();
439         RequirementChanged(_newRequired);
440     }
441 
442     /// @notice Gets an owner by 0-indexed position
443     /// @param ownerIndex 0-indexed owner position
444     function getOwner(uint ownerIndex) public constant returns (address) {
445         return m_owners[ownerIndex + 1];
446     }
447 
448     /// @notice Gets owners
449     /// @return memory array of owners
450     function getOwners() public constant returns (address[]) {
451         address[] memory result = new address[](m_numOwners);
452         for (uint i = 0; i < m_numOwners; i++)
453             result[i] = getOwner(i);
454 
455         return result;
456     }
457 
458     /// @notice checks if provided address is an owner address
459     /// @param _addr address to check
460     /// @return true if it's an owner
461     function isOwner(address _addr) public constant returns (bool) {
462         return m_ownerIndex[_addr] > 0;
463     }
464 
465     /// @notice Tests ownership of the current caller.
466     /// @return true if it's an owner
467     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
468     // addOwner/changeOwner and to isOwner.
469     function amIOwner() external constant onlyowner returns (bool) {
470         return true;
471     }
472 
473     /// @notice Revokes a prior confirmation of the given operation
474     /// @param _operation operation value, typically keccak256(msg.data)
475     function revoke(bytes32 _operation)
476         external
477         multiOwnedOperationIsActive(_operation)
478         onlyowner
479     {
480         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
481         var pending = m_multiOwnedPending[_operation];
482         require(pending.ownersDone & ownerIndexBit > 0);
483 
484         assertOperationIsConsistent(_operation);
485 
486         pending.yetNeeded++;
487         pending.ownersDone -= ownerIndexBit;
488 
489         assertOperationIsConsistent(_operation);
490         Revoke(msg.sender, _operation);
491     }
492 
493     /// @notice Checks if owner confirmed given operation
494     /// @param _operation operation value, typically keccak256(msg.data)
495     /// @param _owner an owner address
496     function hasConfirmed(bytes32 _operation, address _owner)
497         external
498         constant
499         multiOwnedOperationIsActive(_operation)
500         ownerExists(_owner)
501         returns (bool)
502     {
503         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
504     }
505 
506     // INTERNAL METHODS
507 
508     function confirmAndCheck(bytes32 _operation)
509         private
510         onlyowner
511         returns (bool)
512     {
513         if (512 == m_multiOwnedPendingIndex.length)
514             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
515             // we won't be able to do it because of block gas limit.
516             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
517             // TODO use more graceful approach like compact or removal of clearPending completely
518             clearPending();
519 
520         var pending = m_multiOwnedPending[_operation];
521 
522         // if we're not yet working on this operation, switch over and reset the confirmation status.
523         if (! isOperationActive(_operation)) {
524             // reset count of confirmations needed.
525             pending.yetNeeded = m_multiOwnedRequired;
526             // reset which owners have confirmed (none) - set our bitmap to 0.
527             pending.ownersDone = 0;
528             pending.index = m_multiOwnedPendingIndex.length++;
529             m_multiOwnedPendingIndex[pending.index] = _operation;
530             assertOperationIsConsistent(_operation);
531         }
532 
533         // determine the bit to set for this owner.
534         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
535         // make sure we (the message sender) haven't confirmed this operation previously.
536         if (pending.ownersDone & ownerIndexBit == 0) {
537             // ok - check if count is enough to go ahead.
538             assert(pending.yetNeeded > 0);
539             if (pending.yetNeeded == 1) {
540                 // enough confirmations: reset and run interior.
541                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
542                 delete m_multiOwnedPending[_operation];
543                 FinalConfirmation(msg.sender, _operation);
544                 return true;
545             }
546             else
547             {
548                 // not enough: record that this owner in particular confirmed.
549                 pending.yetNeeded--;
550                 pending.ownersDone |= ownerIndexBit;
551                 assertOperationIsConsistent(_operation);
552                 Confirmation(msg.sender, _operation);
553             }
554         }
555     }
556 
557     // Reclaims free slots between valid owners in m_owners.
558     // TODO given that its called after each removal, it could be simplified.
559     function reorganizeOwners() private {
560         uint free = 1;
561         while (free < m_numOwners)
562         {
563             // iterating to the first free slot from the beginning
564             while (free < m_numOwners && m_owners[free] != 0) free++;
565 
566             // iterating to the first occupied slot from the end
567             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
568 
569             // swap, if possible, so free slot is located at the end after the swap
570             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
571             {
572                 // owners between swapped slots should't be renumbered - that saves a lot of gas
573                 m_owners[free] = m_owners[m_numOwners];
574                 m_ownerIndex[m_owners[free]] = free;
575                 m_owners[m_numOwners] = 0;
576             }
577         }
578     }
579 
580     function clearPending() private onlyowner {
581         uint length = m_multiOwnedPendingIndex.length;
582         // TODO block gas limit
583         for (uint i = 0; i < length; ++i) {
584             if (m_multiOwnedPendingIndex[i] != 0)
585                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
586         }
587         delete m_multiOwnedPendingIndex;
588     }
589 
590     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
591         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
592         return ownerIndex;
593     }
594 
595     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
596         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
597         return 2 ** ownerIndex;
598     }
599 
600     function isOperationActive(bytes32 _operation) private constant returns (bool) {
601         return 0 != m_multiOwnedPending[_operation].yetNeeded;
602     }
603 
604 
605     function assertOwnersAreConsistent() private constant {
606         assert(m_numOwners > 0);
607         assert(m_numOwners <= c_maxOwners);
608         assert(m_owners[0] == 0);
609         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
610     }
611 
612     function assertOperationIsConsistent(bytes32 _operation) private constant {
613         var pending = m_multiOwnedPending[_operation];
614         assert(0 != pending.yetNeeded);
615         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
616         assert(pending.yetNeeded <= m_multiOwnedRequired);
617     }
618 
619 
620    	// FIELDS
621 
622     uint constant c_maxOwners = 250;
623 
624     // the number of owners that must confirm the same operation before it is run.
625     uint public m_multiOwnedRequired;
626 
627 
628     // pointer used to find a free slot in m_owners
629     uint public m_numOwners;
630 
631     // list of owners (addresses),
632     // slot 0 is unused so there are no owner which index is 0.
633     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
634     address[256] internal m_owners;
635 
636     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
637     mapping(address => uint) internal m_ownerIndex;
638 
639 
640     // the ongoing operations.
641     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
642     bytes32[] internal m_multiOwnedPendingIndex;
643 }
644 
645 // File: mixbytes-solidity/contracts/security/ArgumentsChecker.sol
646 
647 // Copyright (C) 2017  MixBytes, LLC
648 
649 // Licensed under the Apache License, Version 2.0 (the "License").
650 // You may not use this file except in compliance with the License.
651 
652 // Unless required by applicable law or agreed to in writing, software
653 // distributed under the License is distributed on an "AS IS" BASIS,
654 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
655 
656 pragma solidity ^0.4.15;
657 
658 
659 /// @title utility methods and modifiers of arguments validation
660 contract ArgumentsChecker {
661 
662     /// @dev check which prevents short address attack
663     modifier payloadSizeIs(uint size) {
664        require(msg.data.length == size + 4 /* function selector */);
665        _;
666     }
667 
668     /// @dev check that address is valid
669     modifier validAddress(address addr) {
670         require(addr != address(0));
671         _;
672     }
673 }
674 
675 // File: contracts/BoomstarterToken.sol
676 
677 /**
678  * @title Boomstarter project token.
679  *
680  * Standard ERC20 burnable token plus logic to support token freezing for crowdsales.
681  */
682 contract BoomstarterToken is ArgumentsChecker, multiowned, BurnableToken, StandardToken, TokenWithApproveAndCallMethod {
683 
684     // MODIFIERS
685 
686     /// @dev makes transfer possible if tokens are unfrozen OR if the caller is a sale account
687     modifier saleOrUnfrozen(address account) {
688         require( (m_frozen == false) || isSale(account) );
689         _;
690     }
691 
692     modifier onlySale(address account) {
693         require(isSale(account));
694         _;
695     }
696 
697     modifier privilegedAllowed {
698         require(m_allowPrivileged);
699         _;
700     }
701 
702 
703     // PUBLIC FUNCTIONS
704 
705     /**
706      * @notice Constructs token.
707      *
708      * @param _initialOwners initial multi-signatures, see comment below
709      * @param _signaturesRequired quorum of multi-signatures
710      *
711      * Initial owners have power over the token contract only during bootstrap phase (early investments and token
712      * sales). To be precise, the owners can set sales (which can transfer frozen tokens) during
713      * bootstrap phase. After final token sale any control over the token removed by issuing disablePrivileged call.
714      * For lifecycle example please see test/BootstarterTokenTest.js, 'test full lifecycle'.
715      */
716     function BoomstarterToken(address[] _initialOwners, uint _signaturesRequired)
717         public
718         multiowned(_initialOwners, _signaturesRequired)
719     {
720         totalSupply = MAX_SUPPLY;
721         balances[msg.sender] = totalSupply;
722         // mark initial owner as a sale to enable frozen transfer for them
723         // as well as the option to set next sale without multi-signature
724         m_sales[msg.sender] = true;
725         Transfer(address(0), msg.sender, totalSupply);
726     }
727 
728     /**
729      * @notice Standard transfer() but with check of frozen status
730      *
731      * @param _to the address to transfer to
732      * @param _value the amount to be transferred
733      *
734      * @return true iff operation was successfully completed
735      */
736     function transfer(address _to, uint256 _value)
737         public
738         saleOrUnfrozen(msg.sender)
739         returns (bool)
740     {
741         return super.transfer(_to, _value);
742     }
743 
744     /**
745      * @notice Standard transferFrom but incorporating frozen tokens logic
746      *
747      * @param _from address the address which you want to send tokens from
748      * @param _to address the address which you want to transfer to
749      * @param _value uint256 the amount of tokens to be transferred
750      *
751      * @return true iff operation was successfully completed
752      */
753     function transferFrom(address _from, address _to, uint256 _value)
754         public
755         saleOrUnfrozen(msg.sender)
756         returns (bool)
757     {
758         return super.transferFrom(_from, _to, _value);
759     }
760 
761     /**
762      * Function to burn msg.sender's tokens. Overridden to prohibit burning frozen tokens
763      *
764      * @param _amount amount of tokens to burn
765      *
766      * @return boolean that indicates if the operation was successful
767      */
768     function burn(uint256 _amount)
769         public
770         saleOrUnfrozen(msg.sender)
771         returns (bool)
772     {
773         return super.burn(_amount);
774     }
775 
776     // ADMINISTRATIVE FUNCTIONS
777 
778     /**
779      * @notice Sets sale status of an account.
780      *
781      * @param account account address
782      * @param isSale enables this account to transfer tokens in frozen state
783      *
784      * Function is used only during token sale phase, before disablePrivileged() is called.
785      */
786     function setSale(address account, bool isSale)
787         external
788         validAddress(account)
789         privilegedAllowed
790         onlymanyowners(keccak256(msg.data))
791     {
792         m_sales[account] = isSale;
793     }
794 
795     /**
796      * @notice Same as setSale, but must be called from the current active sale and
797      *         doesn't need multisigning (it's done in the finishSale call anyway)
798      */
799     function switchToNextSale(address _nextSale)
800         external
801         validAddress(_nextSale)
802         onlySale(msg.sender)
803     {
804         m_sales[msg.sender] = false;
805         m_sales[_nextSale] = true;
806     }
807 
808     /// @notice Make transfer of tokens available to everyone
809     function thaw()
810         external
811         privilegedAllowed
812         onlymanyowners(keccak256(msg.data))
813     {
814         m_frozen = false;
815     }
816 
817     /// @notice Disables further use of privileged functions: setSale, thaw
818     function disablePrivileged()
819         external
820         privilegedAllowed
821         onlymanyowners(keccak256(msg.data))
822     {
823         // shouldn't be frozen otherwise will be impossible to unfreeze
824         require( false == m_frozen );
825         m_allowPrivileged = false;
826     }
827 
828 
829     // INTERNAL FUNCTIONS
830 
831     function isSale(address account) private view returns (bool) {
832         return m_sales[account];
833     }
834 
835 
836     // FIELDS
837 
838     /// @notice set of sale accounts which can freeze tokens
839     mapping (address => bool) public m_sales;
840 
841     /// @notice allows privileged functions (token sale phase)
842     bool public m_allowPrivileged = true;
843 
844     /// @notice when true - all tokens are frozen and only sales can move their tokens
845     ///         when false - all tokens are unfrozen and can be moved by their owners
846     bool public m_frozen = true;
847 
848     // CONSTANTS
849 
850     string public constant name = "BoomstarterCoin";
851     string public constant symbol = "BC";
852     uint8 public constant decimals = 18;
853 
854     uint public constant MAX_SUPPLY = uint(36) * uint(1000000) * uint(10) ** uint(decimals);
855 }