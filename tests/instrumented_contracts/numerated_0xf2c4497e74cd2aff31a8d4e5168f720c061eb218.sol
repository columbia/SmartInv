1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity 0.4.15;
7 
8 /*************************************************************************
9  * import "../ownership/MultiownedControlled.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "./multiowned.sol" : start
14  *************************************************************************/// Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
15 // Audit, refactoring and improvements by github.com/Eenae
16 
17 // @authors:
18 // Gav Wood <g@ethdev.com>
19 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
20 // single, or, crucially, each of a number of, designated owners.
21 // usage:
22 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
23 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
24 // interior is executed.
25 
26 
27 
28 
29 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
30 // TODO acceptOwnership
31 contract multiowned {
32 
33 	// TYPES
34 
35     // struct for the status of a pending operation.
36     struct MultiOwnedOperationPendingState {
37         // count of confirmations needed
38         uint yetNeeded;
39 
40         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
41         uint ownersDone;
42 
43         // position of this operation key in m_multiOwnedPendingIndex
44         uint index;
45     }
46 
47 	// EVENTS
48 
49     event Confirmation(address owner, bytes32 operation);
50     event Revoke(address owner, bytes32 operation);
51     event FinalConfirmation(address owner, bytes32 operation);
52 
53     // some others are in the case of an owner changing.
54     event OwnerChanged(address oldOwner, address newOwner);
55     event OwnerAdded(address newOwner);
56     event OwnerRemoved(address oldOwner);
57 
58     // the last one is emitted if the required signatures change
59     event RequirementChanged(uint newRequirement);
60 
61 	// MODIFIERS
62 
63     // simple single-sig function modifier.
64     modifier onlyowner {
65         require(isOwner(msg.sender));
66         _;
67     }
68     // multi-sig function modifier: the operation must have an intrinsic hash in order
69     // that later attempts can be realised as the same underlying operation and
70     // thus count as confirmations.
71     modifier onlymanyowners(bytes32 _operation) {
72         if (confirmAndCheck(_operation)) {
73             _;
74         }
75         // Even if required number of confirmations has't been collected yet,
76         // we can't throw here - because changes to the state have to be preserved.
77         // But, confirmAndCheck itself will throw in case sender is not an owner.
78     }
79 
80     modifier validNumOwners(uint _numOwners) {
81         require(_numOwners > 0 && _numOwners <= c_maxOwners);
82         _;
83     }
84 
85     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
86         require(_required > 0 && _required <= _numOwners);
87         _;
88     }
89 
90     modifier ownerExists(address _address) {
91         require(isOwner(_address));
92         _;
93     }
94 
95     modifier ownerDoesNotExist(address _address) {
96         require(!isOwner(_address));
97         _;
98     }
99 
100     modifier multiOwnedOperationIsActive(bytes32 _operation) {
101         require(isOperationActive(_operation));
102         _;
103     }
104 
105 	// METHODS
106 
107     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
108     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
109     function multiowned(address[] _owners, uint _required)
110         validNumOwners(_owners.length)
111         multiOwnedValidRequirement(_required, _owners.length)
112     {
113         assert(c_maxOwners <= 255);
114 
115         m_numOwners = _owners.length;
116         m_multiOwnedRequired = _required;
117 
118         for (uint i = 0; i < _owners.length; ++i)
119         {
120             address owner = _owners[i];
121             // invalid and duplicate addresses are not allowed
122             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
123 
124             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
125             m_owners[currentOwnerIndex] = owner;
126             m_ownerIndex[owner] = currentOwnerIndex;
127         }
128 
129         assertOwnersAreConsistent();
130     }
131 
132     /// @notice replaces an owner `_from` with another `_to`.
133     /// @param _from address of owner to replace
134     /// @param _to address of new owner
135     // All pending operations will be canceled!
136     function changeOwner(address _from, address _to)
137         external
138         ownerExists(_from)
139         ownerDoesNotExist(_to)
140         onlymanyowners(sha3(msg.data))
141     {
142         assertOwnersAreConsistent();
143 
144         clearPending();
145         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
146         m_owners[ownerIndex] = _to;
147         m_ownerIndex[_from] = 0;
148         m_ownerIndex[_to] = ownerIndex;
149 
150         assertOwnersAreConsistent();
151         OwnerChanged(_from, _to);
152     }
153 
154     /// @notice adds an owner
155     /// @param _owner address of new owner
156     // All pending operations will be canceled!
157     function addOwner(address _owner)
158         external
159         ownerDoesNotExist(_owner)
160         validNumOwners(m_numOwners + 1)
161         onlymanyowners(sha3(msg.data))
162     {
163         assertOwnersAreConsistent();
164 
165         clearPending();
166         m_numOwners++;
167         m_owners[m_numOwners] = _owner;
168         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
169 
170         assertOwnersAreConsistent();
171         OwnerAdded(_owner);
172     }
173 
174     /// @notice removes an owner
175     /// @param _owner address of owner to remove
176     // All pending operations will be canceled!
177     function removeOwner(address _owner)
178         external
179         ownerExists(_owner)
180         validNumOwners(m_numOwners - 1)
181         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
182         onlymanyowners(sha3(msg.data))
183     {
184         assertOwnersAreConsistent();
185 
186         clearPending();
187         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
188         m_owners[ownerIndex] = 0;
189         m_ownerIndex[_owner] = 0;
190         //make sure m_numOwners is equal to the number of owners and always points to the last owner
191         reorganizeOwners();
192 
193         assertOwnersAreConsistent();
194         OwnerRemoved(_owner);
195     }
196 
197     /// @notice changes the required number of owner signatures
198     /// @param _newRequired new number of signatures required
199     // All pending operations will be canceled!
200     function changeRequirement(uint _newRequired)
201         external
202         multiOwnedValidRequirement(_newRequired, m_numOwners)
203         onlymanyowners(sha3(msg.data))
204     {
205         m_multiOwnedRequired = _newRequired;
206         clearPending();
207         RequirementChanged(_newRequired);
208     }
209 
210     /// @notice Gets an owner by 0-indexed position
211     /// @param ownerIndex 0-indexed owner position
212     function getOwner(uint ownerIndex) public constant returns (address) {
213         return m_owners[ownerIndex + 1];
214     }
215 
216     /// @notice Gets owners
217     /// @return memory array of owners
218     function getOwners() public constant returns (address[]) {
219         address[] memory result = new address[](m_numOwners);
220         for (uint i = 0; i < m_numOwners; i++)
221             result[i] = getOwner(i);
222 
223         return result;
224     }
225 
226     /// @notice checks if provided address is an owner address
227     /// @param _addr address to check
228     /// @return true if it's an owner
229     function isOwner(address _addr) public constant returns (bool) {
230         return m_ownerIndex[_addr] > 0;
231     }
232 
233     /// @notice Tests ownership of the current caller.
234     /// @return true if it's an owner
235     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
236     // addOwner/changeOwner and to isOwner.
237     function amIOwner() external constant onlyowner returns (bool) {
238         return true;
239     }
240 
241     /// @notice Revokes a prior confirmation of the given operation
242     /// @param _operation operation value, typically sha3(msg.data)
243     function revoke(bytes32 _operation)
244         external
245         multiOwnedOperationIsActive(_operation)
246         onlyowner
247     {
248         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
249         var pending = m_multiOwnedPending[_operation];
250         require(pending.ownersDone & ownerIndexBit > 0);
251 
252         assertOperationIsConsistent(_operation);
253 
254         pending.yetNeeded++;
255         pending.ownersDone -= ownerIndexBit;
256 
257         assertOperationIsConsistent(_operation);
258         Revoke(msg.sender, _operation);
259     }
260 
261     /// @notice Checks if owner confirmed given operation
262     /// @param _operation operation value, typically sha3(msg.data)
263     /// @param _owner an owner address
264     function hasConfirmed(bytes32 _operation, address _owner)
265         external
266         constant
267         multiOwnedOperationIsActive(_operation)
268         ownerExists(_owner)
269         returns (bool)
270     {
271         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
272     }
273 
274     // INTERNAL METHODS
275 
276     function confirmAndCheck(bytes32 _operation)
277         private
278         onlyowner
279         returns (bool)
280     {
281         if (512 == m_multiOwnedPendingIndex.length)
282             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
283             // we won't be able to do it because of block gas limit.
284             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
285             // TODO use more graceful approach like compact or removal of clearPending completely
286             clearPending();
287 
288         var pending = m_multiOwnedPending[_operation];
289 
290         // if we're not yet working on this operation, switch over and reset the confirmation status.
291         if (! isOperationActive(_operation)) {
292             // reset count of confirmations needed.
293             pending.yetNeeded = m_multiOwnedRequired;
294             // reset which owners have confirmed (none) - set our bitmap to 0.
295             pending.ownersDone = 0;
296             pending.index = m_multiOwnedPendingIndex.length++;
297             m_multiOwnedPendingIndex[pending.index] = _operation;
298             assertOperationIsConsistent(_operation);
299         }
300 
301         // determine the bit to set for this owner.
302         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
303         // make sure we (the message sender) haven't confirmed this operation previously.
304         if (pending.ownersDone & ownerIndexBit == 0) {
305             // ok - check if count is enough to go ahead.
306             assert(pending.yetNeeded > 0);
307             if (pending.yetNeeded == 1) {
308                 // enough confirmations: reset and run interior.
309                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
310                 delete m_multiOwnedPending[_operation];
311                 FinalConfirmation(msg.sender, _operation);
312                 return true;
313             }
314             else
315             {
316                 // not enough: record that this owner in particular confirmed.
317                 pending.yetNeeded--;
318                 pending.ownersDone |= ownerIndexBit;
319                 assertOperationIsConsistent(_operation);
320                 Confirmation(msg.sender, _operation);
321             }
322         }
323     }
324 
325     // Reclaims free slots between valid owners in m_owners.
326     // TODO given that its called after each removal, it could be simplified.
327     function reorganizeOwners() private {
328         uint free = 1;
329         while (free < m_numOwners)
330         {
331             // iterating to the first free slot from the beginning
332             while (free < m_numOwners && m_owners[free] != 0) free++;
333 
334             // iterating to the first occupied slot from the end
335             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
336 
337             // swap, if possible, so free slot is located at the end after the swap
338             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
339             {
340                 // owners between swapped slots should't be renumbered - that saves a lot of gas
341                 m_owners[free] = m_owners[m_numOwners];
342                 m_ownerIndex[m_owners[free]] = free;
343                 m_owners[m_numOwners] = 0;
344             }
345         }
346     }
347 
348     function clearPending() private onlyowner {
349         uint length = m_multiOwnedPendingIndex.length;
350         // TODO block gas limit
351         for (uint i = 0; i < length; ++i) {
352             if (m_multiOwnedPendingIndex[i] != 0)
353                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
354         }
355         delete m_multiOwnedPendingIndex;
356     }
357 
358     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
359         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
360         return ownerIndex;
361     }
362 
363     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
364         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
365         return 2 ** ownerIndex;
366     }
367 
368     function isOperationActive(bytes32 _operation) private constant returns (bool) {
369         return 0 != m_multiOwnedPending[_operation].yetNeeded;
370     }
371 
372 
373     function assertOwnersAreConsistent() private constant {
374         assert(m_numOwners > 0);
375         assert(m_numOwners <= c_maxOwners);
376         assert(m_owners[0] == 0);
377         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
378     }
379 
380     function assertOperationIsConsistent(bytes32 _operation) private constant {
381         var pending = m_multiOwnedPending[_operation];
382         assert(0 != pending.yetNeeded);
383         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
384         assert(pending.yetNeeded <= m_multiOwnedRequired);
385     }
386 
387 
388    	// FIELDS
389 
390     uint constant c_maxOwners = 250;
391 
392     // the number of owners that must confirm the same operation before it is run.
393     uint public m_multiOwnedRequired;
394 
395 
396     // pointer used to find a free slot in m_owners
397     uint public m_numOwners;
398 
399     // list of owners (addresses),
400     // slot 0 is unused so there are no owner which index is 0.
401     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
402     address[256] internal m_owners;
403 
404     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
405     mapping(address => uint) internal m_ownerIndex;
406 
407 
408     // the ongoing operations.
409     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
410     bytes32[] internal m_multiOwnedPendingIndex;
411 }
412 /*************************************************************************
413  * import "./multiowned.sol" : end
414  *************************************************************************/
415 
416 
417 /**
418  * @title Contract which is owned by owners and operated by controller.
419  *
420  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
421  * Controller is set up by owners or during construction.
422  *
423  * @dev controller check is performed by onlyController modifier.
424  */
425 contract MultiownedControlled is multiowned {
426 
427     event ControllerSet(address controller);
428     event ControllerRetired(address was);
429 
430 
431     modifier onlyController {
432         require(msg.sender == m_controller);
433         _;
434     }
435 
436 
437     // PUBLIC interface
438 
439     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
440         multiowned(_owners, _signaturesRequired)
441     {
442         m_controller = _controller;
443         ControllerSet(m_controller);
444     }
445 
446     /// @dev sets the controller
447     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
448         m_controller = _controller;
449         ControllerSet(m_controller);
450     }
451 
452     /// @dev ability for controller to step down
453     function detachController() external onlyController {
454         address was = m_controller;
455         m_controller = address(0);
456         ControllerRetired(was);
457     }
458 
459 
460     // FIELDS
461 
462     /// @notice address of entity entitled to mint new tokens
463     address public m_controller;
464 }
465 /*************************************************************************
466  * import "../ownership/MultiownedControlled.sol" : end
467  *************************************************************************/
468 /*************************************************************************
469  * import "../security/ArgumentsChecker.sol" : start
470  *************************************************************************/
471 
472 
473 /// @title utility methods and modifiers of arguments validation
474 contract ArgumentsChecker {
475 
476     /// @dev check which prevents short address attack
477     modifier payloadSizeIs(uint size) {
478        require(msg.data.length == size + 4 /* function selector */);
479        _;
480     }
481 
482     /// @dev check that address is valid
483     modifier validAddress(address addr) {
484         require(addr != address(0));
485         _;
486     }
487 }
488 /*************************************************************************
489  * import "../security/ArgumentsChecker.sol" : end
490  *************************************************************************/
491 /*************************************************************************
492  * import "zeppelin-solidity/contracts/math/SafeMath.sol" : start
493  *************************************************************************/
494 
495 
496 /**
497  * @title SafeMath
498  * @dev Math operations with safety checks that throw on error
499  */
500 library SafeMath {
501   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
502     uint256 c = a * b;
503     assert(a == 0 || c / a == b);
504     return c;
505   }
506 
507   function div(uint256 a, uint256 b) internal constant returns (uint256) {
508     // assert(b > 0); // Solidity automatically throws when dividing by 0
509     uint256 c = a / b;
510     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
511     return c;
512   }
513 
514   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
515     assert(b <= a);
516     return a - b;
517   }
518 
519   function add(uint256 a, uint256 b) internal constant returns (uint256) {
520     uint256 c = a + b;
521     assert(c >= a);
522     return c;
523   }
524 }
525 /*************************************************************************
526  * import "zeppelin-solidity/contracts/math/SafeMath.sol" : end
527  *************************************************************************/
528 /*************************************************************************
529  * import "zeppelin-solidity/contracts/ReentrancyGuard.sol" : start
530  *************************************************************************/
531 
532 /**
533  * @title Helps contracts guard agains rentrancy attacks.
534  * @author Remco Bloemen <remco@2π.com>
535  * @notice If you mark a function `nonReentrant`, you should also
536  * mark it `external`.
537  */
538 contract ReentrancyGuard {
539 
540   /**
541    * @dev We use a single lock for the whole contract.
542    */
543   bool private rentrancy_lock = false;
544 
545   /**
546    * @dev Prevents a contract from calling itself, directly or indirectly.
547    * @notice If you mark a function `nonReentrant`, you should also
548    * mark it `external`. Calling one nonReentrant function from
549    * another is not supported. Instead, you can implement a
550    * `private` function doing the actual work, and a `external`
551    * wrapper marked as `nonReentrant`.
552    */
553   modifier nonReentrant() {
554     require(!rentrancy_lock);
555     rentrancy_lock = true;
556     _;
557     rentrancy_lock = false;
558   }
559 
560 }
561 /*************************************************************************
562  * import "zeppelin-solidity/contracts/ReentrancyGuard.sol" : end
563  *************************************************************************/
564 
565 
566 /// @title registry of funds sent by investors
567 contract FundsRegistry is ArgumentsChecker, MultiownedControlled, ReentrancyGuard {
568     using SafeMath for uint256;
569 
570     enum State {
571         // gathering funds
572         GATHERING,
573         // returning funds to investors
574         REFUNDING,
575         // funds can be pulled by owners
576         SUCCEEDED
577     }
578 
579     event StateChanged(State _state);
580     event Invested(address indexed investor, uint256 amount);
581     event EtherSent(address indexed to, uint value);
582     event RefundSent(address indexed to, uint value);
583 
584 
585     modifier requiresState(State _state) {
586         require(m_state == _state);
587         _;
588     }
589 
590 
591     // PUBLIC interface
592 
593     function FundsRegistry(address[] _owners, uint _signaturesRequired, address _controller)
594         MultiownedControlled(_owners, _signaturesRequired, _controller)
595     {
596     }
597 
598     /// @dev performs only allowed state transitions
599     function changeState(State _newState)
600         external
601         onlyController
602     {
603         assert(m_state != _newState);
604 
605         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
606         else assert(false);
607 
608         m_state = _newState;
609         StateChanged(m_state);
610     }
611 
612     /// @dev records an investment
613     function invested(address _investor)
614         external
615         payable
616         onlyController
617         requiresState(State.GATHERING)
618     {
619         uint256 amount = msg.value;
620         require(0 != amount);
621         assert(_investor != m_controller);
622 
623         // register investor
624         if (0 == m_weiBalances[_investor])
625             m_investors.push(_investor);
626 
627         // register payment
628         totalInvested = totalInvested.add(amount);
629         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
630 
631         Invested(_investor, amount);
632     }
633 
634     /// @notice owners: send `value` of ether to address `to`, can be called if crowdsale succeeded
635     /// @param to where to send ether
636     /// @param value amount of wei to send
637     function sendEther(address to, uint value)
638         external
639         validAddress(to)
640         onlymanyowners(sha3(msg.data))
641         requiresState(State.SUCCEEDED)
642     {
643         require(value > 0 && this.balance >= value);
644         to.transfer(value);
645         EtherSent(to, value);
646     }
647 
648     /// @notice withdraw accumulated balance, called by payee in case crowdsale failed
649     function withdrawPayments()
650         external
651         nonReentrant
652         requiresState(State.REFUNDING)
653     {
654         address payee = msg.sender;
655         uint256 payment = m_weiBalances[payee];
656 
657         require(payment != 0);
658         require(this.balance >= payment);
659 
660         totalInvested = totalInvested.sub(payment);
661         m_weiBalances[payee] = 0;
662 
663         payee.transfer(payment);
664         RefundSent(payee, payment);
665     }
666 
667     function getInvestorsCount() external constant returns (uint) { return m_investors.length; }
668 
669 
670     // FIELDS
671 
672     /// @notice total amount of investments in wei
673     uint256 public totalInvested;
674 
675     /// @notice state of the registry
676     State public m_state = State.GATHERING;
677 
678     /// @dev balances of investors in wei
679     mapping(address => uint256) public m_weiBalances;
680 
681     /// @dev list of unique investors
682     address[] public m_investors;
683 }