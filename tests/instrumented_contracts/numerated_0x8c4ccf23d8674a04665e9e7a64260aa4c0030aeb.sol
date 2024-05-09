1 // Copyright (C) 2017  MixBytes, LLC
2 
3 // Licensed under the Apache License, Version 2.0 (the "License").
4 // You may not use this file except in compliance with the License.
5 
6 // Unless required by applicable law or agreed to in writing, software
7 // distributed under the License is distributed on an "AS IS" BASIS,
8 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
9 
10 pragma solidity ^0.4.15;
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 
46 /**
47  * @title Helps contracts guard agains rentrancy attacks.
48  * @author Remco Bloemen <remco@2π.com>
49  * @notice If you mark a function `nonReentrant`, you should also
50  * mark it `external`.
51  */
52 contract ReentrancyGuard {
53 
54     /**
55      * @dev We use a single lock for the whole contract.
56      */
57     bool private rentrancy_lock = false;
58 
59     /**
60      * @dev Prevents a contract from calling itself, directly or indirectly.
61      * @notice If you mark a function `nonReentrant`, you should also
62      * mark it `external`. Calling one nonReentrant function from
63      * another is not supported. Instead, you can implement a
64      * `private` function doing the actual work, and a `external`
65      * wrapper marked as `nonReentrant`.
66      */
67     modifier nonReentrant() {
68         require(!rentrancy_lock);
69         rentrancy_lock = true;
70         _;
71         rentrancy_lock = false;
72     }
73 
74 }
75 
76 
77 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
78 // TODO acceptOwnership
79 contract multiowned {
80 
81     // TYPES
82 
83     // struct for the status of a pending operation.
84     struct MultiOwnedOperationPendingState {
85     // count of confirmations needed
86     uint yetNeeded;
87 
88     // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
89     uint ownersDone;
90 
91     // position of this operation key in m_multiOwnedPendingIndex
92     uint index;
93     }
94 
95     // EVENTS
96 
97     event Confirmation(address owner, bytes32 operation);
98     event Revoke(address owner, bytes32 operation);
99     event FinalConfirmation(address owner, bytes32 operation);
100 
101     // some others are in the case of an owner changing.
102     event OwnerChanged(address oldOwner, address newOwner);
103     event OwnerAdded(address newOwner);
104     event OwnerRemoved(address oldOwner);
105 
106     // the last one is emitted if the required signatures change
107     event RequirementChanged(uint newRequirement);
108 
109     // MODIFIERS
110 
111     // simple single-sig function modifier.
112     modifier onlyowner {
113         require(isOwner(msg.sender));
114         _;
115     }
116     // multi-sig function modifier: the operation must have an intrinsic hash in order
117     // that later attempts can be realised as the same underlying operation and
118     // thus count as confirmations.
119     modifier onlymanyowners(bytes32 _operation) {
120         if (confirmAndCheck(_operation)) {
121             _;
122         }
123         // Even if required number of confirmations has't been collected yet,
124         // we can't throw here - because changes to the state have to be preserved.
125         // But, confirmAndCheck itself will throw in case sender is not an owner.
126     }
127 
128     modifier validNumOwners(uint _numOwners) {
129         require(_numOwners > 0 && _numOwners <= c_maxOwners);
130         _;
131     }
132 
133     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
134         require(_required > 0 && _required <= _numOwners);
135         _;
136     }
137 
138     modifier ownerExists(address _address) {
139         require(isOwner(_address));
140         _;
141     }
142 
143     modifier ownerDoesNotExist(address _address) {
144         require(!isOwner(_address));
145         _;
146     }
147 
148     modifier multiOwnedOperationIsActive(bytes32 _operation) {
149         require(isOperationActive(_operation));
150         _;
151     }
152 
153     // METHODS
154 
155     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
156     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
157     function multiowned(address[] _owners, uint _required)
158     validNumOwners(_owners.length)
159     multiOwnedValidRequirement(_required, _owners.length)
160     {
161         assert(c_maxOwners <= 255);
162 
163         m_numOwners = _owners.length;
164         m_multiOwnedRequired = _required;
165 
166         for (uint i = 0; i < _owners.length; ++i)
167         {
168             address owner = _owners[i];
169             // invalid and duplicate addresses are not allowed
170             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
171 
172             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
173             m_owners[currentOwnerIndex] = owner;
174             m_ownerIndex[owner] = currentOwnerIndex;
175         }
176 
177         assertOwnersAreConsistent();
178     }
179 
180     /// @notice replaces an owner `_from` with another `_to`.
181     /// @param _from address of owner to replace
182     /// @param _to address of new owner
183     // All pending operations will be canceled!
184     function changeOwner(address _from, address _to)
185     external
186     ownerExists(_from)
187     ownerDoesNotExist(_to)
188     onlymanyowners(sha3(msg.data))
189     {
190         assertOwnersAreConsistent();
191 
192         clearPending();
193         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
194         m_owners[ownerIndex] = _to;
195         m_ownerIndex[_from] = 0;
196         m_ownerIndex[_to] = ownerIndex;
197 
198         assertOwnersAreConsistent();
199         OwnerChanged(_from, _to);
200     }
201 
202     /// @notice adds an owner
203     /// @param _owner address of new owner
204     // All pending operations will be canceled!
205     function addOwner(address _owner)
206     external
207     ownerDoesNotExist(_owner)
208     validNumOwners(m_numOwners + 1)
209     onlymanyowners(sha3(msg.data))
210     {
211         assertOwnersAreConsistent();
212 
213         clearPending();
214         m_numOwners++;
215         m_owners[m_numOwners] = _owner;
216         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
217 
218         assertOwnersAreConsistent();
219         OwnerAdded(_owner);
220     }
221 
222     /// @notice removes an owner
223     /// @param _owner address of owner to remove
224     // All pending operations will be canceled!
225     function removeOwner(address _owner)
226     external
227     ownerExists(_owner)
228     validNumOwners(m_numOwners - 1)
229     multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
230     onlymanyowners(sha3(msg.data))
231     {
232         assertOwnersAreConsistent();
233 
234         clearPending();
235         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
236         m_owners[ownerIndex] = 0;
237         m_ownerIndex[_owner] = 0;
238         //make sure m_numOwners is equal to the number of owners and always points to the last owner
239         reorganizeOwners();
240 
241         assertOwnersAreConsistent();
242         OwnerRemoved(_owner);
243     }
244 
245     /// @notice changes the required number of owner signatures
246     /// @param _newRequired new number of signatures required
247     // All pending operations will be canceled!
248     function changeRequirement(uint _newRequired)
249     external
250     multiOwnedValidRequirement(_newRequired, m_numOwners)
251     onlymanyowners(sha3(msg.data))
252     {
253         m_multiOwnedRequired = _newRequired;
254         clearPending();
255         RequirementChanged(_newRequired);
256     }
257 
258     /// @notice Gets an owner by 0-indexed position
259     /// @param ownerIndex 0-indexed owner position
260     function getOwner(uint ownerIndex) public constant returns (address) {
261         return m_owners[ownerIndex + 1];
262     }
263 
264     /// @notice Gets owners
265     /// @return memory array of owners
266     function getOwners() public constant returns (address[]) {
267         address[] memory result = new address[](m_numOwners);
268         for (uint i = 0; i < m_numOwners; i++)
269         result[i] = getOwner(i);
270 
271         return result;
272     }
273 
274     /// @notice checks if provided address is an owner address
275     /// @param _addr address to check
276     /// @return true if it's an owner
277     function isOwner(address _addr) public constant returns (bool) {
278         return m_ownerIndex[_addr] > 0;
279     }
280 
281     /// @notice Tests ownership of the current caller.
282     /// @return true if it's an owner
283     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
284     // addOwner/changeOwner and to isOwner.
285     function amIOwner() external constant onlyowner returns (bool) {
286         return true;
287     }
288 
289     /// @notice Revokes a prior confirmation of the given operation
290     /// @param _operation operation value, typically sha3(msg.data)
291     function revoke(bytes32 _operation)
292     external
293     multiOwnedOperationIsActive(_operation)
294     onlyowner
295     {
296         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
297         var pending = m_multiOwnedPending[_operation];
298         require(pending.ownersDone & ownerIndexBit > 0);
299 
300         assertOperationIsConsistent(_operation);
301 
302         pending.yetNeeded++;
303         pending.ownersDone -= ownerIndexBit;
304 
305         assertOperationIsConsistent(_operation);
306         Revoke(msg.sender, _operation);
307     }
308 
309     /// @notice Checks if owner confirmed given operation
310     /// @param _operation operation value, typically sha3(msg.data)
311     /// @param _owner an owner address
312     function hasConfirmed(bytes32 _operation, address _owner)
313     external
314     constant
315     multiOwnedOperationIsActive(_operation)
316     ownerExists(_owner)
317     returns (bool)
318     {
319         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
320     }
321 
322     // INTERNAL METHODS
323 
324     function confirmAndCheck(bytes32 _operation)
325     private
326     onlyowner
327     returns (bool)
328     {
329         if (512 == m_multiOwnedPendingIndex.length)
330         // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
331         // we won't be able to do it because of block gas limit.
332         // Yes, pending confirmations will be lost. Dont see any security or stability implications.
333         // TODO use more graceful approach like compact or removal of clearPending completely
334         clearPending();
335 
336         var pending = m_multiOwnedPending[_operation];
337 
338         // if we're not yet working on this operation, switch over and reset the confirmation status.
339         if (! isOperationActive(_operation)) {
340             // reset count of confirmations needed.
341             pending.yetNeeded = m_multiOwnedRequired;
342             // reset which owners have confirmed (none) - set our bitmap to 0.
343             pending.ownersDone = 0;
344             pending.index = m_multiOwnedPendingIndex.length++;
345             m_multiOwnedPendingIndex[pending.index] = _operation;
346             assertOperationIsConsistent(_operation);
347         }
348 
349         // determine the bit to set for this owner.
350         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
351         // make sure we (the message sender) haven't confirmed this operation previously.
352         if (pending.ownersDone & ownerIndexBit == 0) {
353             // ok - check if count is enough to go ahead.
354             assert(pending.yetNeeded > 0);
355             if (pending.yetNeeded == 1) {
356                 // enough confirmations: reset and run interior.
357                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
358                 delete m_multiOwnedPending[_operation];
359                 FinalConfirmation(msg.sender, _operation);
360                 return true;
361             }
362             else
363             {
364                 // not enough: record that this owner in particular confirmed.
365                 pending.yetNeeded--;
366                 pending.ownersDone |= ownerIndexBit;
367                 assertOperationIsConsistent(_operation);
368                 Confirmation(msg.sender, _operation);
369             }
370         }
371     }
372 
373     // Reclaims free slots between valid owners in m_owners.
374     // TODO given that its called after each removal, it could be simplified.
375     function reorganizeOwners() private {
376         uint free = 1;
377         while (free < m_numOwners)
378         {
379             // iterating to the first free slot from the beginning
380             while (free < m_numOwners && m_owners[free] != 0) free++;
381 
382             // iterating to the first occupied slot from the end
383             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
384 
385             // swap, if possible, so free slot is located at the end after the swap
386             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
387             {
388                 // owners between swapped slots should't be renumbered - that saves a lot of gas
389                 m_owners[free] = m_owners[m_numOwners];
390                 m_ownerIndex[m_owners[free]] = free;
391                 m_owners[m_numOwners] = 0;
392             }
393         }
394     }
395 
396     function clearPending() private onlyowner {
397         uint length = m_multiOwnedPendingIndex.length;
398         // TODO block gas limit
399         for (uint i = 0; i < length; ++i) {
400             if (m_multiOwnedPendingIndex[i] != 0)
401             delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
402         }
403         delete m_multiOwnedPendingIndex;
404     }
405 
406     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
407         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
408         return ownerIndex;
409     }
410 
411     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
412         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
413         return 2 ** ownerIndex;
414     }
415 
416     function isOperationActive(bytes32 _operation) private constant returns (bool) {
417         return 0 != m_multiOwnedPending[_operation].yetNeeded;
418     }
419 
420 
421     function assertOwnersAreConsistent() private constant {
422         assert(m_numOwners > 0);
423         assert(m_numOwners <= c_maxOwners);
424         assert(m_owners[0] == 0);
425         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
426     }
427 
428     function assertOperationIsConsistent(bytes32 _operation) private constant {
429         var pending = m_multiOwnedPending[_operation];
430         assert(0 != pending.yetNeeded);
431         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
432         assert(pending.yetNeeded <= m_multiOwnedRequired);
433     }
434 
435 
436     // FIELDS
437 
438     uint constant c_maxOwners = 250;
439 
440     // the number of owners that must confirm the same operation before it is run.
441     uint public m_multiOwnedRequired;
442 
443 
444     // pointer used to find a free slot in m_owners
445     uint public m_numOwners;
446 
447     // list of owners (addresses),
448     // slot 0 is unused so there are no owner which index is 0.
449     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
450     address[256] internal m_owners;
451 
452     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
453     mapping(address => uint) internal m_ownerIndex;
454 
455 
456     // the ongoing operations.
457     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
458     bytes32[] internal m_multiOwnedPendingIndex;
459 }
460 
461 
462 /**
463  * @title Contract which is owned by owners and operated by controller.
464  *
465  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
466  * Controller is set up by owners or during construction.
467  *
468  * @dev controller check is performed by onlyController modifier.
469  */
470 contract MultiownedControlled is multiowned {
471 
472     event ControllerSet(address controller);
473     event ControllerRetired(address was);
474 
475 
476     modifier onlyController {
477         require(msg.sender == m_controller);
478         _;
479     }
480 
481 
482     // PUBLIC interface
483 
484     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
485     multiowned(_owners, _signaturesRequired)
486     {
487         m_controller = _controller;
488         ControllerSet(m_controller);
489     }
490 
491     /// @dev sets the controller
492     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
493         m_controller = _controller;
494         ControllerSet(m_controller);
495     }
496 
497     /// @dev ability for controller to step down
498     function detachController() external onlyController {
499         address was = m_controller;
500         m_controller = address(0);
501         ControllerRetired(was);
502     }
503 
504 
505     // FIELDS
506 
507     /// @notice address of entity entitled to mint new tokens
508     address public m_controller;
509 }
510 
511 
512 /// @title utility methods and modifiers of arguments validation
513 contract ArgumentsChecker {
514 
515     /// @dev check which prevents short address attack
516     modifier payloadSizeIs(uint size) {
517         require(msg.data.length == size + 4 /* function selector */);
518         _;
519     }
520 
521     /// @dev check that address is valid
522     modifier validAddress(address addr) {
523         require(addr != address(0));
524         _;
525     }
526 }
527 
528 
529 /// @title registry of funds sent by investors
530 contract FundsRegistry is ArgumentsChecker, MultiownedControlled, ReentrancyGuard {
531     using SafeMath for uint256;
532 
533     enum State {
534         // gathering funds
535         GATHERING,
536         // returning funds to investors
537         REFUNDING,
538         // funds can be pulled by owners
539         SUCCEEDED
540     }
541 
542     event StateChanged(State _state);
543     event Invested(address indexed investor, uint256 amount);
544     event EtherSent(address indexed to, uint value);
545     event RefundSent(address indexed to, uint value);
546 
547 
548     modifier requiresState(State _state) {
549         require(m_state == _state);
550         _;
551     }
552 
553 
554     // PUBLIC interface
555 
556     function FundsRegistry(address[] _owners, uint _signaturesRequired, address _controller)
557         MultiownedControlled(_owners, _signaturesRequired, _controller)
558     {
559     }
560 
561     /// @dev performs only allowed state transitions
562     function changeState(State _newState)
563         external
564         onlyController
565     {
566         assert(m_state != _newState);
567 
568         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
569         else assert(false);
570 
571         m_state = _newState;
572         StateChanged(m_state);
573     }
574 
575     /// @dev records an investment
576     function invested(address _investor)
577         external
578         payable
579         onlyController
580         requiresState(State.GATHERING)
581     {
582         uint256 amount = msg.value;
583         require(0 != amount);
584         assert(_investor != m_controller);
585 
586         // register investor
587         if (0 == m_weiBalances[_investor])
588             m_investors.push(_investor);
589 
590         // register payment
591         totalInvested = totalInvested.add(amount);
592         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
593 
594         Invested(_investor, amount);
595     }
596 
597     /// @notice owners: send `value` of ether to address `to`, can be called if crowdsale succeeded
598     /// @param to where to send ether
599     /// @param value amount of wei to send
600     function sendEther(address to, uint value)
601         external
602         validAddress(to)
603         onlymanyowners(sha3(msg.data))
604         requiresState(State.SUCCEEDED)
605     {
606         require(value > 0 && this.balance >= value);
607         to.transfer(value);
608         EtherSent(to, value);
609     }
610 
611     /// @notice withdraw accumulated balance, called by payee in case crowdsale failed
612     function withdrawPayments(address payee)
613         external
614         nonReentrant
615         onlyController
616         requiresState(State.REFUNDING)
617     {
618         uint256 payment = m_weiBalances[payee];
619 
620         require(payment != 0);
621         require(this.balance >= payment);
622 
623         totalInvested = totalInvested.sub(payment);
624         m_weiBalances[payee] = 0;
625 
626         payee.transfer(payment);
627         RefundSent(payee, payment);
628     }
629 
630     function getInvestorsCount() external constant returns (uint) { return m_investors.length; }
631 
632 
633     // FIELDS
634 
635     /// @notice total amount of investments in wei
636     uint256 public totalInvested;
637 
638     /// @notice state of the registry
639     State public m_state = State.GATHERING;
640 
641     /// @dev balances of investors in wei
642     mapping(address => uint256) public m_weiBalances;
643 
644     /// @dev list of unique investors
645     address[] public m_investors;
646 }