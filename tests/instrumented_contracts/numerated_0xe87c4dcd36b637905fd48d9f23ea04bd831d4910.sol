1 pragma solidity 0.4.23;
2 
3 // File: contracts/IBoomstarterToken.sol
4 
5 /// @title Interface of the BoomstarterToken.
6 interface IBoomstarterToken {
7     // multiowned
8     function changeOwner(address _from, address _to) external;
9     function addOwner(address _owner) external;
10     function removeOwner(address _owner) external;
11     function changeRequirement(uint _newRequired) external;
12     function getOwner(uint ownerIndex) public view returns (address);
13     function getOwners() public view returns (address[]);
14     function isOwner(address _addr) public view returns (bool);
15     function amIOwner() external view returns (bool);
16     function revoke(bytes32 _operation) external;
17     function hasConfirmed(bytes32 _operation, address _owner) external view returns (bool);
18 
19     // ERC20Basic
20     function totalSupply() public view returns (uint256);
21     function balanceOf(address who) public view returns (uint256);
22     function transfer(address to, uint256 value) public returns (bool);
23 
24     // ERC20
25     function allowance(address owner, address spender) public view returns (uint256);
26     function transferFrom(address from, address to, uint256 value) public returns (bool);
27     function approve(address spender, uint256 value) public returns (bool);
28 
29     function name() public view returns (string);
30     function symbol() public view returns (string);
31     function decimals() public view returns (uint8);
32 
33     // BurnableToken
34     function burn(uint256 _amount) public returns (bool);
35 
36     // TokenWithApproveAndCallMethod
37     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public;
38 
39     // BoomstarterToken
40     function setSale(address account, bool isSale) external;
41     function switchToNextSale(address _newSale) external;
42     function thaw() external;
43     function disablePrivileged() external;
44 
45 }
46 
47 // File: mixbytes-solidity/contracts/ownership/multiowned.sol
48 
49 // Copyright (C) 2017  MixBytes, LLC
50 
51 // Licensed under the Apache License, Version 2.0 (the "License").
52 // You may not use this file except in compliance with the License.
53 
54 // Unless required by applicable law or agreed to in writing, software
55 // distributed under the License is distributed on an "AS IS" BASIS,
56 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
57 
58 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
59 // Audit, refactoring and improvements by github.com/Eenae
60 
61 // @authors:
62 // Gav Wood <g@ethdev.com>
63 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
64 // single, or, crucially, each of a number of, designated owners.
65 // usage:
66 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
67 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
68 // interior is executed.
69 
70 pragma solidity ^0.4.15;
71 
72 
73 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
74 // TODO acceptOwnership
75 contract multiowned {
76 
77 	// TYPES
78 
79     // struct for the status of a pending operation.
80     struct MultiOwnedOperationPendingState {
81         // count of confirmations needed
82         uint yetNeeded;
83 
84         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
85         uint ownersDone;
86 
87         // position of this operation key in m_multiOwnedPendingIndex
88         uint index;
89     }
90 
91 	// EVENTS
92 
93     event Confirmation(address owner, bytes32 operation);
94     event Revoke(address owner, bytes32 operation);
95     event FinalConfirmation(address owner, bytes32 operation);
96 
97     // some others are in the case of an owner changing.
98     event OwnerChanged(address oldOwner, address newOwner);
99     event OwnerAdded(address newOwner);
100     event OwnerRemoved(address oldOwner);
101 
102     // the last one is emitted if the required signatures change
103     event RequirementChanged(uint newRequirement);
104 
105 	// MODIFIERS
106 
107     // simple single-sig function modifier.
108     modifier onlyowner {
109         require(isOwner(msg.sender));
110         _;
111     }
112     // multi-sig function modifier: the operation must have an intrinsic hash in order
113     // that later attempts can be realised as the same underlying operation and
114     // thus count as confirmations.
115     modifier onlymanyowners(bytes32 _operation) {
116         if (confirmAndCheck(_operation)) {
117             _;
118         }
119         // Even if required number of confirmations has't been collected yet,
120         // we can't throw here - because changes to the state have to be preserved.
121         // But, confirmAndCheck itself will throw in case sender is not an owner.
122     }
123 
124     modifier validNumOwners(uint _numOwners) {
125         require(_numOwners > 0 && _numOwners <= c_maxOwners);
126         _;
127     }
128 
129     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
130         require(_required > 0 && _required <= _numOwners);
131         _;
132     }
133 
134     modifier ownerExists(address _address) {
135         require(isOwner(_address));
136         _;
137     }
138 
139     modifier ownerDoesNotExist(address _address) {
140         require(!isOwner(_address));
141         _;
142     }
143 
144     modifier multiOwnedOperationIsActive(bytes32 _operation) {
145         require(isOperationActive(_operation));
146         _;
147     }
148 
149 	// METHODS
150 
151     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
152     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
153     function multiowned(address[] _owners, uint _required)
154         public
155         validNumOwners(_owners.length)
156         multiOwnedValidRequirement(_required, _owners.length)
157     {
158         assert(c_maxOwners <= 255);
159 
160         m_numOwners = _owners.length;
161         m_multiOwnedRequired = _required;
162 
163         for (uint i = 0; i < _owners.length; ++i)
164         {
165             address owner = _owners[i];
166             // invalid and duplicate addresses are not allowed
167             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
168 
169             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
170             m_owners[currentOwnerIndex] = owner;
171             m_ownerIndex[owner] = currentOwnerIndex;
172         }
173 
174         assertOwnersAreConsistent();
175     }
176 
177     /// @notice replaces an owner `_from` with another `_to`.
178     /// @param _from address of owner to replace
179     /// @param _to address of new owner
180     // All pending operations will be canceled!
181     function changeOwner(address _from, address _to)
182         external
183         ownerExists(_from)
184         ownerDoesNotExist(_to)
185         onlymanyowners(keccak256(msg.data))
186     {
187         assertOwnersAreConsistent();
188 
189         clearPending();
190         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
191         m_owners[ownerIndex] = _to;
192         m_ownerIndex[_from] = 0;
193         m_ownerIndex[_to] = ownerIndex;
194 
195         assertOwnersAreConsistent();
196         OwnerChanged(_from, _to);
197     }
198 
199     /// @notice adds an owner
200     /// @param _owner address of new owner
201     // All pending operations will be canceled!
202     function addOwner(address _owner)
203         external
204         ownerDoesNotExist(_owner)
205         validNumOwners(m_numOwners + 1)
206         onlymanyowners(keccak256(msg.data))
207     {
208         assertOwnersAreConsistent();
209 
210         clearPending();
211         m_numOwners++;
212         m_owners[m_numOwners] = _owner;
213         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
214 
215         assertOwnersAreConsistent();
216         OwnerAdded(_owner);
217     }
218 
219     /// @notice removes an owner
220     /// @param _owner address of owner to remove
221     // All pending operations will be canceled!
222     function removeOwner(address _owner)
223         external
224         ownerExists(_owner)
225         validNumOwners(m_numOwners - 1)
226         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
227         onlymanyowners(keccak256(msg.data))
228     {
229         assertOwnersAreConsistent();
230 
231         clearPending();
232         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
233         m_owners[ownerIndex] = 0;
234         m_ownerIndex[_owner] = 0;
235         //make sure m_numOwners is equal to the number of owners and always points to the last owner
236         reorganizeOwners();
237 
238         assertOwnersAreConsistent();
239         OwnerRemoved(_owner);
240     }
241 
242     /// @notice changes the required number of owner signatures
243     /// @param _newRequired new number of signatures required
244     // All pending operations will be canceled!
245     function changeRequirement(uint _newRequired)
246         external
247         multiOwnedValidRequirement(_newRequired, m_numOwners)
248         onlymanyowners(keccak256(msg.data))
249     {
250         m_multiOwnedRequired = _newRequired;
251         clearPending();
252         RequirementChanged(_newRequired);
253     }
254 
255     /// @notice Gets an owner by 0-indexed position
256     /// @param ownerIndex 0-indexed owner position
257     function getOwner(uint ownerIndex) public constant returns (address) {
258         return m_owners[ownerIndex + 1];
259     }
260 
261     /// @notice Gets owners
262     /// @return memory array of owners
263     function getOwners() public constant returns (address[]) {
264         address[] memory result = new address[](m_numOwners);
265         for (uint i = 0; i < m_numOwners; i++)
266             result[i] = getOwner(i);
267 
268         return result;
269     }
270 
271     /// @notice checks if provided address is an owner address
272     /// @param _addr address to check
273     /// @return true if it's an owner
274     function isOwner(address _addr) public constant returns (bool) {
275         return m_ownerIndex[_addr] > 0;
276     }
277 
278     /// @notice Tests ownership of the current caller.
279     /// @return true if it's an owner
280     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
281     // addOwner/changeOwner and to isOwner.
282     function amIOwner() external constant onlyowner returns (bool) {
283         return true;
284     }
285 
286     /// @notice Revokes a prior confirmation of the given operation
287     /// @param _operation operation value, typically keccak256(msg.data)
288     function revoke(bytes32 _operation)
289         external
290         multiOwnedOperationIsActive(_operation)
291         onlyowner
292     {
293         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
294         var pending = m_multiOwnedPending[_operation];
295         require(pending.ownersDone & ownerIndexBit > 0);
296 
297         assertOperationIsConsistent(_operation);
298 
299         pending.yetNeeded++;
300         pending.ownersDone -= ownerIndexBit;
301 
302         assertOperationIsConsistent(_operation);
303         Revoke(msg.sender, _operation);
304     }
305 
306     /// @notice Checks if owner confirmed given operation
307     /// @param _operation operation value, typically keccak256(msg.data)
308     /// @param _owner an owner address
309     function hasConfirmed(bytes32 _operation, address _owner)
310         external
311         constant
312         multiOwnedOperationIsActive(_operation)
313         ownerExists(_owner)
314         returns (bool)
315     {
316         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
317     }
318 
319     // INTERNAL METHODS
320 
321     function confirmAndCheck(bytes32 _operation)
322         private
323         onlyowner
324         returns (bool)
325     {
326         if (512 == m_multiOwnedPendingIndex.length)
327             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
328             // we won't be able to do it because of block gas limit.
329             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
330             // TODO use more graceful approach like compact or removal of clearPending completely
331             clearPending();
332 
333         var pending = m_multiOwnedPending[_operation];
334 
335         // if we're not yet working on this operation, switch over and reset the confirmation status.
336         if (! isOperationActive(_operation)) {
337             // reset count of confirmations needed.
338             pending.yetNeeded = m_multiOwnedRequired;
339             // reset which owners have confirmed (none) - set our bitmap to 0.
340             pending.ownersDone = 0;
341             pending.index = m_multiOwnedPendingIndex.length++;
342             m_multiOwnedPendingIndex[pending.index] = _operation;
343             assertOperationIsConsistent(_operation);
344         }
345 
346         // determine the bit to set for this owner.
347         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
348         // make sure we (the message sender) haven't confirmed this operation previously.
349         if (pending.ownersDone & ownerIndexBit == 0) {
350             // ok - check if count is enough to go ahead.
351             assert(pending.yetNeeded > 0);
352             if (pending.yetNeeded == 1) {
353                 // enough confirmations: reset and run interior.
354                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
355                 delete m_multiOwnedPending[_operation];
356                 FinalConfirmation(msg.sender, _operation);
357                 return true;
358             }
359             else
360             {
361                 // not enough: record that this owner in particular confirmed.
362                 pending.yetNeeded--;
363                 pending.ownersDone |= ownerIndexBit;
364                 assertOperationIsConsistent(_operation);
365                 Confirmation(msg.sender, _operation);
366             }
367         }
368     }
369 
370     // Reclaims free slots between valid owners in m_owners.
371     // TODO given that its called after each removal, it could be simplified.
372     function reorganizeOwners() private {
373         uint free = 1;
374         while (free < m_numOwners)
375         {
376             // iterating to the first free slot from the beginning
377             while (free < m_numOwners && m_owners[free] != 0) free++;
378 
379             // iterating to the first occupied slot from the end
380             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
381 
382             // swap, if possible, so free slot is located at the end after the swap
383             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
384             {
385                 // owners between swapped slots should't be renumbered - that saves a lot of gas
386                 m_owners[free] = m_owners[m_numOwners];
387                 m_ownerIndex[m_owners[free]] = free;
388                 m_owners[m_numOwners] = 0;
389             }
390         }
391     }
392 
393     function clearPending() private onlyowner {
394         uint length = m_multiOwnedPendingIndex.length;
395         // TODO block gas limit
396         for (uint i = 0; i < length; ++i) {
397             if (m_multiOwnedPendingIndex[i] != 0)
398                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
399         }
400         delete m_multiOwnedPendingIndex;
401     }
402 
403     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
404         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
405         return ownerIndex;
406     }
407 
408     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
409         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
410         return 2 ** ownerIndex;
411     }
412 
413     function isOperationActive(bytes32 _operation) private constant returns (bool) {
414         return 0 != m_multiOwnedPending[_operation].yetNeeded;
415     }
416 
417 
418     function assertOwnersAreConsistent() private constant {
419         assert(m_numOwners > 0);
420         assert(m_numOwners <= c_maxOwners);
421         assert(m_owners[0] == 0);
422         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
423     }
424 
425     function assertOperationIsConsistent(bytes32 _operation) private constant {
426         var pending = m_multiOwnedPending[_operation];
427         assert(0 != pending.yetNeeded);
428         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
429         assert(pending.yetNeeded <= m_multiOwnedRequired);
430     }
431 
432 
433    	// FIELDS
434 
435     uint constant c_maxOwners = 250;
436 
437     // the number of owners that must confirm the same operation before it is run.
438     uint public m_multiOwnedRequired;
439 
440 
441     // pointer used to find a free slot in m_owners
442     uint public m_numOwners;
443 
444     // list of owners (addresses),
445     // slot 0 is unused so there are no owner which index is 0.
446     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
447     address[256] internal m_owners;
448 
449     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
450     mapping(address => uint) internal m_ownerIndex;
451 
452 
453     // the ongoing operations.
454     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
455     bytes32[] internal m_multiOwnedPendingIndex;
456 }
457 
458 // File: mixbytes-solidity/contracts/ownership/MultiownedControlled.sol
459 
460 // Copyright (C) 2017  MixBytes, LLC
461 
462 // Licensed under the Apache License, Version 2.0 (the "License").
463 // You may not use this file except in compliance with the License.
464 
465 // Unless required by applicable law or agreed to in writing, software
466 // distributed under the License is distributed on an "AS IS" BASIS,
467 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
468 
469 pragma solidity ^0.4.15;
470 
471 
472 
473 /**
474  * @title Contract which is owned by owners and operated by controller.
475  *
476  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
477  * Controller is set up by owners or during construction.
478  *
479  * @dev controller check is performed by onlyController modifier.
480  */
481 contract MultiownedControlled is multiowned {
482 
483     event ControllerSet(address controller);
484     event ControllerRetired(address was);
485     event ControllerRetiredForever(address was);
486 
487 
488     modifier onlyController {
489         require(msg.sender == m_controller);
490         _;
491     }
492 
493 
494     // PUBLIC interface
495 
496     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
497         public
498         multiowned(_owners, _signaturesRequired)
499     {
500         m_controller = _controller;
501         ControllerSet(m_controller);
502     }
503 
504     /// @dev sets the controller
505     function setController(address _controller) external onlymanyowners(keccak256(msg.data)) {
506         require(m_attaching_enabled);
507         m_controller = _controller;
508         ControllerSet(m_controller);
509     }
510 
511     /// @dev ability for controller to step down
512     function detachController() external onlyController {
513         address was = m_controller;
514         m_controller = address(0);
515         ControllerRetired(was);
516     }
517 
518     /// @dev ability for controller to step down and make this contract completely automatic (without third-party control)
519     function detachControllerForever() external onlyController {
520         assert(m_attaching_enabled);
521         address was = m_controller;
522         m_controller = address(0);
523         m_attaching_enabled = false;
524         ControllerRetiredForever(was);
525     }
526 
527 
528     // FIELDS
529 
530     /// @notice address of entity entitled to mint new tokens
531     address public m_controller;
532 
533     bool public m_attaching_enabled = true;
534 }
535 
536 // File: mixbytes-solidity/contracts/security/ArgumentsChecker.sol
537 
538 // Copyright (C) 2017  MixBytes, LLC
539 
540 // Licensed under the Apache License, Version 2.0 (the "License").
541 // You may not use this file except in compliance with the License.
542 
543 // Unless required by applicable law or agreed to in writing, software
544 // distributed under the License is distributed on an "AS IS" BASIS,
545 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
546 
547 pragma solidity ^0.4.15;
548 
549 
550 /// @title utility methods and modifiers of arguments validation
551 contract ArgumentsChecker {
552 
553     /// @dev check which prevents short address attack
554     modifier payloadSizeIs(uint size) {
555        require(msg.data.length == size + 4 /* function selector */);
556        _;
557     }
558 
559     /// @dev check that address is valid
560     modifier validAddress(address addr) {
561         require(addr != address(0));
562         _;
563     }
564 }
565 
566 // File: zeppelin-solidity/contracts/ReentrancyGuard.sol
567 
568 /**
569  * @title Helps contracts guard agains rentrancy attacks.
570  * @author Remco Bloemen <remco@2π.com>
571  * @notice If you mark a function `nonReentrant`, you should also
572  * mark it `external`.
573  */
574 contract ReentrancyGuard {
575 
576   /**
577    * @dev We use a single lock for the whole contract.
578    */
579   bool private rentrancy_lock = false;
580 
581   /**
582    * @dev Prevents a contract from calling itself, directly or indirectly.
583    * @notice If you mark a function `nonReentrant`, you should also
584    * mark it `external`. Calling one nonReentrant function from
585    * another is not supported. Instead, you can implement a
586    * `private` function doing the actual work, and a `external`
587    * wrapper marked as `nonReentrant`.
588    */
589   modifier nonReentrant() {
590     require(!rentrancy_lock);
591     rentrancy_lock = true;
592     _;
593     rentrancy_lock = false;
594   }
595 
596 }
597 
598 // File: zeppelin-solidity/contracts/math/SafeMath.sol
599 
600 /**
601  * @title SafeMath
602  * @dev Math operations with safety checks that throw on error
603  */
604 library SafeMath {
605   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
606     uint256 c = a * b;
607     assert(a == 0 || c / a == b);
608     return c;
609   }
610 
611   function div(uint256 a, uint256 b) internal constant returns (uint256) {
612     // assert(b > 0); // Solidity automatically throws when dividing by 0
613     uint256 c = a / b;
614     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
615     return c;
616   }
617 
618   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
619     assert(b <= a);
620     return a - b;
621   }
622 
623   function add(uint256 a, uint256 b) internal constant returns (uint256) {
624     uint256 c = a + b;
625     assert(c >= a);
626     return c;
627   }
628 }
629 
630 // File: contracts/crowdsale/FundsRegistry.sol
631 
632 /// @title registry of funds sent by investors
633 contract FundsRegistry is ArgumentsChecker, MultiownedControlled, ReentrancyGuard {
634     using SafeMath for uint256;
635 
636     enum State {
637         // gathering funds
638         GATHERING,
639         // returning funds to investors
640         REFUNDING,
641         // funds can be pulled by owners
642         SUCCEEDED
643     }
644 
645     event StateChanged(State _state);
646     event Invested(address indexed investor, uint etherInvested, uint tokensReceived);
647     event EtherSent(address indexed to, uint value);
648     event RefundSent(address indexed to, uint value);
649 
650 
651     modifier requiresState(State _state) {
652         require(m_state == _state);
653         _;
654     }
655 
656 
657     // PUBLIC interface
658 
659     function FundsRegistry(
660         address[] _owners,
661         uint _signaturesRequired,
662         address _controller,
663         address _token
664     )
665         MultiownedControlled(_owners, _signaturesRequired, _controller)
666     {
667         m_token = IBoomstarterToken(_token);
668     }
669 
670     /// @dev performs only allowed state transitions
671     function changeState(State _newState)
672         external
673         onlyController
674     {
675         assert(m_state != _newState);
676 
677         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
678         else assert(false);
679 
680         m_state = _newState;
681         StateChanged(m_state);
682     }
683 
684     /// @dev records an investment
685     /// @param _investor who invested
686     /// @param _tokenAmount the amount of token bought, calculation is handled by ICO
687     function invested(address _investor, uint _tokenAmount)
688         external
689         payable
690         onlyController
691         requiresState(State.GATHERING)
692     {
693         uint256 amount = msg.value;
694         require(0 != amount);
695         assert(_investor != m_controller);
696 
697         // register investor
698         if (0 == m_weiBalances[_investor])
699             m_investors.push(_investor);
700 
701         // register payment
702         totalInvested = totalInvested.add(amount);
703         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
704         m_tokenBalances[_investor] = m_tokenBalances[_investor].add(_tokenAmount);
705 
706         Invested(_investor, amount, _tokenAmount);
707     }
708 
709     /// @notice owners: send `value` of ether to address `to`, can be called if crowdsale succeeded
710     /// @param to where to send ether
711     /// @param value amount of wei to send
712     function sendEther(address to, uint value)
713         external
714         validAddress(to)
715         onlymanyowners(keccak256(msg.data))
716         requiresState(State.SUCCEEDED)
717     {
718         require(value > 0 && this.balance >= value);
719         to.transfer(value);
720         EtherSent(to, value);
721     }
722 
723     /// @notice owners: send `value` of tokens to address `to`, can be called if
724     ///         crowdsale failed and some of the investors refunded the ether
725     /// @param to where to send tokens
726     /// @param value amount of token-wei to send
727     function sendTokens(address to, uint value)
728         external
729         validAddress(to)
730         onlymanyowners(keccak256(msg.data))
731         requiresState(State.REFUNDING)
732     {
733         require(value > 0 && m_token.balanceOf(this) >= value);
734         m_token.transfer(to, value);
735     }
736 
737     /// @notice withdraw accumulated balance, called by payee in case crowdsale failed
738     /// @dev caller should approve tokens bought during ICO to this contract
739     function withdrawPayments()
740         external
741         nonReentrant
742         requiresState(State.REFUNDING)
743     {
744         address payee = msg.sender;
745         uint payment = m_weiBalances[payee];
746         uint tokens = m_tokenBalances[payee];
747 
748         // check that there is some ether to withdraw
749         require(payment != 0);
750         // check that the contract holds enough ether
751         require(this.balance >= payment);
752         // check that the investor (payee) gives back all tokens bought during ICO
753         require(m_token.allowance(payee, this) >= m_tokenBalances[payee]);
754 
755         totalInvested = totalInvested.sub(payment);
756         m_weiBalances[payee] = 0;
757         m_tokenBalances[payee] = 0;
758 
759         m_token.transferFrom(payee, this, tokens);
760 
761         payee.transfer(payment);
762         RefundSent(payee, payment);
763     }
764 
765     function getInvestorsCount() external constant returns (uint) { return m_investors.length; }
766 
767     // FIELDS
768 
769     /// @notice total amount of investments in wei
770     uint256 public totalInvested;
771 
772     /// @notice state of the registry
773     State public m_state = State.GATHERING;
774 
775     /// @dev balances of investors in wei
776     mapping(address => uint256) public m_weiBalances;
777 
778     /// @dev balances of tokens sold to investors
779     mapping(address => uint256) public m_tokenBalances;
780 
781     /// @dev list of unique investors
782     address[] public m_investors;
783 
784     /// @dev token accepted for refunds
785     IBoomstarterToken public m_token;
786 }