1 pragma solidity 0.4.15;
2 
3 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
4 // Audit, refactoring and improvements by github.com/Eenae
5 
6 // @authors:
7 // Gav Wood <g@ethdev.com>
8 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
9 // single, or, crucially, each of a number of, designated owners.
10 // usage:
11 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
12 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
13 // interior is executed.
14 
15 
16 
17 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
18 // TODO acceptOwnership
19 contract multiowned {
20 
21 	// TYPES
22 
23     // struct for the status of a pending operation.
24     struct MultiOwnedOperationPendingState {
25         // count of confirmations needed
26         uint yetNeeded;
27 
28         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
29         uint ownersDone;
30 
31         // position of this operation key in m_multiOwnedPendingIndex
32         uint index;
33     }
34 
35 	// EVENTS
36 
37     event Confirmation(address owner, bytes32 operation);
38     event Revoke(address owner, bytes32 operation);
39     event FinalConfirmation(address owner, bytes32 operation);
40 
41     // some others are in the case of an owner changing.
42     event OwnerChanged(address oldOwner, address newOwner);
43     event OwnerAdded(address newOwner);
44     event OwnerRemoved(address oldOwner);
45 
46     // the last one is emitted if the required signatures change
47     event RequirementChanged(uint newRequirement);
48 
49 	// MODIFIERS
50 
51     // simple single-sig function modifier.
52     modifier onlyowner {
53         require(isOwner(msg.sender));
54         _;
55     }
56     // multi-sig function modifier: the operation must have an intrinsic hash in order
57     // that later attempts can be realised as the same underlying operation and
58     // thus count as confirmations.
59     modifier onlymanyowners(bytes32 _operation) {
60         if (confirmAndCheck(_operation)) {
61             _;
62         }
63         // Even if required number of confirmations has't been collected yet,
64         // we can't throw here - because changes to the state have to be preserved.
65         // But, confirmAndCheck itself will throw in case sender is not an owner.
66     }
67 
68     modifier validNumOwners(uint _numOwners) {
69         require(_numOwners > 0 && _numOwners <= c_maxOwners);
70         _;
71     }
72 
73     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
74         require(_required > 0 && _required <= _numOwners);
75         _;
76     }
77 
78     modifier ownerExists(address _address) {
79         require(isOwner(_address));
80         _;
81     }
82 
83     modifier ownerDoesNotExist(address _address) {
84         require(!isOwner(_address));
85         _;
86     }
87 
88     modifier multiOwnedOperationIsActive(bytes32 _operation) {
89         require(isOperationActive(_operation));
90         _;
91     }
92 
93 	// METHODS
94 
95     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
96     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
97     function multiowned(address[] _owners, uint _required)
98         validNumOwners(_owners.length)
99         multiOwnedValidRequirement(_required, _owners.length)
100     {
101         assert(c_maxOwners <= 255);
102 
103         m_numOwners = _owners.length;
104         m_multiOwnedRequired = _required;
105 
106         for (uint i = 0; i < _owners.length; ++i)
107         {
108             address owner = _owners[i];
109             // invalid and duplicate addresses are not allowed
110             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
111 
112             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
113             m_owners[currentOwnerIndex] = owner;
114             m_ownerIndex[owner] = currentOwnerIndex;
115         }
116 
117         assertOwnersAreConsistent();
118     }
119 
120     /// @notice replaces an owner `_from` with another `_to`.
121     /// @param _from address of owner to replace
122     /// @param _to address of new owner
123     // All pending operations will be canceled!
124     function changeOwner(address _from, address _to)
125         external
126         ownerExists(_from)
127         ownerDoesNotExist(_to)
128         onlymanyowners(sha3(msg.data))
129     {
130         assertOwnersAreConsistent();
131 
132         clearPending();
133         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
134         m_owners[ownerIndex] = _to;
135         m_ownerIndex[_from] = 0;
136         m_ownerIndex[_to] = ownerIndex;
137 
138         assertOwnersAreConsistent();
139         OwnerChanged(_from, _to);
140     }
141 
142     /// @notice adds an owner
143     /// @param _owner address of new owner
144     // All pending operations will be canceled!
145     function addOwner(address _owner)
146         external
147         ownerDoesNotExist(_owner)
148         validNumOwners(m_numOwners + 1)
149         onlymanyowners(sha3(msg.data))
150     {
151         assertOwnersAreConsistent();
152 
153         clearPending();
154         m_numOwners++;
155         m_owners[m_numOwners] = _owner;
156         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
157 
158         assertOwnersAreConsistent();
159         OwnerAdded(_owner);
160     }
161 
162     /// @notice removes an owner
163     /// @param _owner address of owner to remove
164     // All pending operations will be canceled!
165     function removeOwner(address _owner)
166         external
167         ownerExists(_owner)
168         validNumOwners(m_numOwners - 1)
169         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
170         onlymanyowners(sha3(msg.data))
171     {
172         assertOwnersAreConsistent();
173 
174         clearPending();
175         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
176         m_owners[ownerIndex] = 0;
177         m_ownerIndex[_owner] = 0;
178         //make sure m_numOwners is equal to the number of owners and always points to the last owner
179         reorganizeOwners();
180 
181         assertOwnersAreConsistent();
182         OwnerRemoved(_owner);
183     }
184 
185     /// @notice changes the required number of owner signatures
186     /// @param _newRequired new number of signatures required
187     // All pending operations will be canceled!
188     function changeRequirement(uint _newRequired)
189         external
190         multiOwnedValidRequirement(_newRequired, m_numOwners)
191         onlymanyowners(sha3(msg.data))
192     {
193         m_multiOwnedRequired = _newRequired;
194         clearPending();
195         RequirementChanged(_newRequired);
196     }
197 
198     /// @notice Gets an owner by 0-indexed position
199     /// @param ownerIndex 0-indexed owner position
200     function getOwner(uint ownerIndex) public constant returns (address) {
201         return m_owners[ownerIndex + 1];
202     }
203 
204     /// @notice Gets owners
205     /// @return memory array of owners
206     function getOwners() public constant returns (address[]) {
207         address[] memory result = new address[](m_numOwners);
208         for (uint i = 0; i < m_numOwners; i++)
209             result[i] = getOwner(i);
210 
211         return result;
212     }
213 
214     /// @notice checks if provided address is an owner address
215     /// @param _addr address to check
216     /// @return true if it's an owner
217     function isOwner(address _addr) public constant returns (bool) {
218         return m_ownerIndex[_addr] > 0;
219     }
220 
221     /// @notice Tests ownership of the current caller.
222     /// @return true if it's an owner
223     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
224     // addOwner/changeOwner and to isOwner.
225     function amIOwner() external constant onlyowner returns (bool) {
226         return true;
227     }
228 
229     /// @notice Revokes a prior confirmation of the given operation
230     /// @param _operation operation value, typically sha3(msg.data)
231     function revoke(bytes32 _operation)
232         external
233         multiOwnedOperationIsActive(_operation)
234         onlyowner
235     {
236         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
237         var pending = m_multiOwnedPending[_operation];
238         require(pending.ownersDone & ownerIndexBit > 0);
239 
240         assertOperationIsConsistent(_operation);
241 
242         pending.yetNeeded++;
243         pending.ownersDone -= ownerIndexBit;
244 
245         assertOperationIsConsistent(_operation);
246         Revoke(msg.sender, _operation);
247     }
248 
249     /// @notice Checks if owner confirmed given operation
250     /// @param _operation operation value, typically sha3(msg.data)
251     /// @param _owner an owner address
252     function hasConfirmed(bytes32 _operation, address _owner)
253         external
254         constant
255         multiOwnedOperationIsActive(_operation)
256         ownerExists(_owner)
257         returns (bool)
258     {
259         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
260     }
261 
262     // INTERNAL METHODS
263 
264     function confirmAndCheck(bytes32 _operation)
265         private
266         onlyowner
267         returns (bool)
268     {
269         if (512 == m_multiOwnedPendingIndex.length)
270             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
271             // we won't be able to do it because of block gas limit.
272             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
273             // TODO use more graceful approach like compact or removal of clearPending completely
274             clearPending();
275 
276         var pending = m_multiOwnedPending[_operation];
277 
278         // if we're not yet working on this operation, switch over and reset the confirmation status.
279         if (! isOperationActive(_operation)) {
280             // reset count of confirmations needed.
281             pending.yetNeeded = m_multiOwnedRequired;
282             // reset which owners have confirmed (none) - set our bitmap to 0.
283             pending.ownersDone = 0;
284             pending.index = m_multiOwnedPendingIndex.length++;
285             m_multiOwnedPendingIndex[pending.index] = _operation;
286             assertOperationIsConsistent(_operation);
287         }
288 
289         // determine the bit to set for this owner.
290         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
291         // make sure we (the message sender) haven't confirmed this operation previously.
292         if (pending.ownersDone & ownerIndexBit == 0) {
293             // ok - check if count is enough to go ahead.
294             assert(pending.yetNeeded > 0);
295             if (pending.yetNeeded == 1) {
296                 // enough confirmations: reset and run interior.
297                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
298                 delete m_multiOwnedPending[_operation];
299                 FinalConfirmation(msg.sender, _operation);
300                 return true;
301             }
302             else
303             {
304                 // not enough: record that this owner in particular confirmed.
305                 pending.yetNeeded--;
306                 pending.ownersDone |= ownerIndexBit;
307                 assertOperationIsConsistent(_operation);
308                 Confirmation(msg.sender, _operation);
309             }
310         }
311     }
312 
313     // Reclaims free slots between valid owners in m_owners.
314     // TODO given that its called after each removal, it could be simplified.
315     function reorganizeOwners() private {
316         uint free = 1;
317         while (free < m_numOwners)
318         {
319             // iterating to the first free slot from the beginning
320             while (free < m_numOwners && m_owners[free] != 0) free++;
321 
322             // iterating to the first occupied slot from the end
323             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
324 
325             // swap, if possible, so free slot is located at the end after the swap
326             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
327             {
328                 // owners between swapped slots should't be renumbered - that saves a lot of gas
329                 m_owners[free] = m_owners[m_numOwners];
330                 m_ownerIndex[m_owners[free]] = free;
331                 m_owners[m_numOwners] = 0;
332             }
333         }
334     }
335 
336     function clearPending() private onlyowner {
337         uint length = m_multiOwnedPendingIndex.length;
338         for (uint i = 0; i < length; ++i) {
339             if (m_multiOwnedPendingIndex[i] != 0)
340                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
341         }
342         delete m_multiOwnedPendingIndex;
343     }
344 
345     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
346         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
347         return ownerIndex;
348     }
349 
350     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
351         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
352         return 2 ** ownerIndex;
353     }
354 
355     function isOperationActive(bytes32 _operation) private constant returns (bool) {
356         return 0 != m_multiOwnedPending[_operation].yetNeeded;
357     }
358 
359 
360     function assertOwnersAreConsistent() private constant {
361         assert(m_numOwners > 0);
362         assert(m_numOwners <= c_maxOwners);
363         assert(m_owners[0] == 0);
364         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
365     }
366 
367     function assertOperationIsConsistent(bytes32 _operation) private constant {
368         var pending = m_multiOwnedPending[_operation];
369         assert(0 != pending.yetNeeded);
370         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
371         assert(pending.yetNeeded <= m_multiOwnedRequired);
372     }
373 
374 
375    	// FIELDS
376 
377     uint constant c_maxOwners = 250;
378 
379     // the number of owners that must confirm the same operation before it is run.
380     uint public m_multiOwnedRequired;
381 
382 
383     // pointer used to find a free slot in m_owners
384     uint public m_numOwners;
385 
386     // list of owners (addresses),
387     // slot 0 is unused so there are no owner which index is 0.
388     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
389     address[256] internal m_owners;
390 
391     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
392     mapping(address => uint) internal m_ownerIndex;
393 
394 
395     // the ongoing operations.
396     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
397     bytes32[] internal m_multiOwnedPendingIndex;
398 }
399 
400 
401 library FixedTimeBonuses {
402 
403     struct Bonus {
404         uint endTime;
405         uint bonus;
406     }
407 
408     struct Data {
409         Bonus[] bonuses;
410     }
411 
412     /// @dev validates consistency of data structure
413     /// @param self data structure
414     /// @param shouldDecrease additionally check if bonuses are decreasing over time
415     function validate(Data storage self, bool shouldDecrease) constant {
416         uint length = self.bonuses.length;
417         require(length > 0);
418 
419         Bonus storage last = self.bonuses[0];
420         for (uint i = 1; i < length; i++) {
421             Bonus storage current = self.bonuses[i];
422             require(current.endTime > last.endTime);
423             if (shouldDecrease)
424                 require(current.bonus < last.bonus);
425             last = current;
426         }
427     }
428 
429     /// @dev get ending time of the last bonus
430     /// @param self data structure
431     function getLastTime(Data storage self) constant returns (uint) {
432         return self.bonuses[self.bonuses.length - 1].endTime;
433     }
434 
435     /// @dev validates consistency of data structure
436     /// @param self data structure
437     /// @param time time for which bonus must be computed (assuming time <= getLastTime())
438     function getBonus(Data storage self, uint time) constant returns (uint) {
439         // TODO binary search?
440         uint length = self.bonuses.length;
441         for (uint i = 0; i < length; i++) {
442             if (self.bonuses[i].endTime >= time)
443                 return self.bonuses[i].bonus;
444         }
445         assert(false);  // must be unreachable
446     }
447 }
448 
449 
450 
451 /**
452  * @title Contract which is owned by owners and operated by controller.
453  *
454  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
455  * Controller is set up by owners or during construction.
456  *
457  * @dev controller check is performed by onlyController modifier.
458  */
459 contract MultiownedControlled is multiowned {
460 
461     event ControllerSet(address controller);
462     event ControllerRetired(address was);
463 
464 
465     modifier onlyController {
466         require(msg.sender == m_controller);
467         _;
468     }
469 
470 
471     // PUBLIC interface
472 
473     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
474         multiowned(_owners, _signaturesRequired)
475     {
476         m_controller = _controller;
477         ControllerSet(m_controller);
478     }
479 
480     /// @notice sets the controller
481     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
482         m_controller = _controller;
483         ControllerSet(m_controller);
484     }
485 
486     /// @notice ability for controller to step down
487     function detachController() external onlyController {
488         address was = m_controller;
489         m_controller = address(0);
490         ControllerRetired(was);
491     }
492 
493 
494     // FIELDS
495 
496     /// @notice address of entity entitled to mint new tokens
497     address public m_controller;
498 }
499 
500 /**
501  * @title SafeMath
502  * @dev Math operations with safety checks that throw on error
503  */
504 library SafeMath {
505   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
506     uint256 c = a * b;
507     assert(a == 0 || c / a == b);
508     return c;
509   }
510 
511   function div(uint256 a, uint256 b) internal constant returns (uint256) {
512     // assert(b > 0); // Solidity automatically throws when dividing by 0
513     uint256 c = a / b;
514     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
515     return c;
516   }
517 
518   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
519     assert(b <= a);
520     return a - b;
521   }
522 
523   function add(uint256 a, uint256 b) internal constant returns (uint256) {
524     uint256 c = a + b;
525     assert(c >= a);
526     return c;
527   }
528 }
529 
530 /**
531  * @title Helps contracts guard agains rentrancy attacks.
532  * @author Remco Bloemen <remco@2π.com>
533  * @notice If you mark a function `nonReentrant`, you should also
534  * mark it `external`.
535  */
536 contract ReentrancyGuard {
537 
538   /**
539    * @dev We use a single lock for the whole contract.
540    */
541   bool private rentrancy_lock = false;
542 
543   /**
544    * @dev Prevents a contract from calling itself, directly or indirectly.
545    * @notice If you mark a function `nonReentrant`, you should also
546    * mark it `external`. Calling one nonReentrant function from
547    * another is not supported. Instead, you can implement a
548    * `private` function doing the actual work, and a `external`
549    * wrapper marked as `nonReentrant`.
550    */
551   modifier nonReentrant() {
552     require(!rentrancy_lock);
553     rentrancy_lock = true;
554     _;
555     rentrancy_lock = false;
556   }
557 
558 }
559 
560 
561 
562 /// @title registry of funds sent by investors
563 contract FundsRegistry is MultiownedControlled, ReentrancyGuard {
564     using SafeMath for uint256;
565 
566     enum State {
567         // gathering funds
568         GATHERING,
569         // returning funds to investors
570         REFUNDING,
571         // funds can be pulled by owners
572         SUCCEEDED
573     }
574 
575     event StateChanged(State _state);
576     event Invested(address indexed investor, uint256 amount);
577     event EtherSent(address indexed to, uint value);
578     event RefundSent(address indexed to, uint value);
579 
580 
581     modifier requiresState(State _state) {
582         require(m_state == _state);
583         _;
584     }
585 
586 
587     // PUBLIC interface
588 
589     function FundsRegistry(address[] _owners, uint _signaturesRequired, address _controller)
590         MultiownedControlled(_owners, _signaturesRequired, _controller)
591     {
592     }
593 
594     /// @dev performs only allowed state transitions
595     function changeState(State _newState)
596         external
597         onlyController
598     {
599         assert(m_state != _newState);
600 
601         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
602         else assert(false);
603 
604         m_state = _newState;
605         StateChanged(m_state);
606     }
607 
608     /// @dev records an investment
609     function invested(address _investor)
610         external
611         payable
612         onlyController
613         requiresState(State.GATHERING)
614     {
615         uint256 amount = msg.value;
616         require(0 != amount);
617         assert(_investor != m_controller);
618 
619         // register investor
620         if (0 == m_weiBalances[_investor])
621             m_investors.push(_investor);
622 
623         // register payment
624         totalInvested = totalInvested.add(amount);
625         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
626 
627         Invested(_investor, amount);
628     }
629 
630     /// @dev Send `value` of ether to address `to`
631     function sendEther(address to, uint value)
632         external
633         onlymanyowners(sha3(msg.data))
634         requiresState(State.SUCCEEDED)
635     {
636         require(0 != to);
637         require(value > 0 && this.balance >= value);
638         to.transfer(value);
639         EtherSent(to, value);
640     }
641 
642     /// @notice withdraw accumulated balance, called by payee.
643     function withdrawPayments()
644         external
645         nonReentrant
646         requiresState(State.REFUNDING)
647     {
648         address payee = msg.sender;
649         uint256 payment = m_weiBalances[payee];
650 
651         require(payment != 0);
652         require(this.balance >= payment);
653 
654         totalInvested = totalInvested.sub(payment);
655         m_weiBalances[payee] = 0;
656 
657         payee.transfer(payment);
658         RefundSent(payee, payment);
659     }
660 
661     function getInvestorsCount() external constant returns (uint) { return m_investors.length; }
662 
663 
664     // FIELDS
665 
666     /// @notice total amount of investments in wei
667     uint256 public totalInvested;
668 
669     /// @notice state of the registry
670     State public m_state = State.GATHERING;
671 
672     /// @dev balances of investors in wei
673     mapping(address => uint256) public m_weiBalances;
674 
675     /// @dev list of unique investors
676     address[] public m_investors;
677 }
678 
679 pragma solidity 0.4.15;
680 
681 
682 /**
683  * @title ERC20Basic
684  * @dev Simpler version of ERC20 interface
685  * @dev see https://github.com/ethereum/EIPs/issues/179
686  */
687 contract ERC20Basic {
688   uint256 public totalSupply;
689   function balanceOf(address who) constant returns (uint256);
690   function transfer(address to, uint256 value) returns (bool);
691   event Transfer(address indexed from, address indexed to, uint256 value);
692 }
693 
694 
695 
696 /**
697  * @title Basic token
698  * @dev Basic version of StandardToken, with no allowances. 
699  */
700 contract BasicToken is ERC20Basic {
701   using SafeMath for uint256;
702 
703   mapping(address => uint256) balances;
704 
705   /**
706   * @dev transfer token for a specified address
707   * @param _to The address to transfer to.
708   * @param _value The amount to be transferred.
709   */
710   function transfer(address _to, uint256 _value) returns (bool) {
711     balances[msg.sender] = balances[msg.sender].sub(_value);
712     balances[_to] = balances[_to].add(_value);
713     Transfer(msg.sender, _to, _value);
714     return true;
715   }
716 
717   /**
718   * @dev Gets the balance of the specified address.
719   * @param _owner The address to query the the balance of. 
720   * @return An uint256 representing the amount owned by the passed address.
721   */
722   function balanceOf(address _owner) constant returns (uint256 balance) {
723     return balances[_owner];
724   }
725 
726 }
727 
728 
729 /**
730  * @title ERC20 interface
731  * @dev see https://github.com/ethereum/EIPs/issues/20
732  */
733 contract ERC20 is ERC20Basic {
734   function allowance(address owner, address spender) constant returns (uint256);
735   function transferFrom(address from, address to, uint256 value) returns (bool);
736   function approve(address spender, uint256 value) returns (bool);
737   event Approval(address indexed owner, address indexed spender, uint256 value);
738 }
739 
740 
741 /**
742  * @title Standard ERC20 token
743  *
744  * @dev Implementation of the basic standard token.
745  * @dev https://github.com/ethereum/EIPs/issues/20
746  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
747  */
748 contract StandardToken is ERC20, BasicToken {
749 
750   mapping (address => mapping (address => uint256)) allowed;
751 
752 
753   /**
754    * @dev Transfer tokens from one address to another
755    * @param _from address The address which you want to send tokens from
756    * @param _to address The address which you want to transfer to
757    * @param _value uint256 the amout of tokens to be transfered
758    */
759   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
760     var _allowance = allowed[_from][msg.sender];
761 
762     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
763     // require (_value <= _allowance);
764 
765     balances[_to] = balances[_to].add(_value);
766     balances[_from] = balances[_from].sub(_value);
767     allowed[_from][msg.sender] = _allowance.sub(_value);
768     Transfer(_from, _to, _value);
769     return true;
770   }
771 
772   /**
773    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
774    * @param _spender The address which will spend the funds.
775    * @param _value The amount of tokens to be spent.
776    */
777   function approve(address _spender, uint256 _value) returns (bool) {
778 
779     // To change the approve amount you first have to reduce the addresses`
780     //  allowance to zero by calling `approve(_spender, 0)` if it is not
781     //  already 0 to mitigate the race condition described here:
782     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
783     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
784 
785     allowed[msg.sender][_spender] = _value;
786     Approval(msg.sender, _spender, _value);
787     return true;
788   }
789 
790   /**
791    * @dev Function to check the amount of tokens that an owner allowed to a spender.
792    * @param _owner address The address which owns the funds.
793    * @param _spender address The address which will spend the funds.
794    * @return A uint256 specifing the amount of tokens still avaible for the spender.
795    */
796   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
797     return allowed[_owner][_spender];
798   }
799 
800 }
801 
802 
803 
804 /// @title StandardToken which circulation can be delayed and started by another contract.
805 /// @dev To be used as a mixin contract.
806 /// The contract is created in disabled state: circulation is disabled.
807 contract CirculatingToken is StandardToken {
808 
809     event CirculationEnabled();
810 
811     modifier requiresCirculation {
812         require(m_isCirculating);
813         _;
814     }
815 
816 
817     // PUBLIC interface
818 
819     function transfer(address _to, uint256 _value) requiresCirculation returns (bool) {
820         return super.transfer(_to, _value);
821     }
822 
823     function transferFrom(address _from, address _to, uint256 _value) requiresCirculation returns (bool) {
824         return super.transferFrom(_from, _to, _value);
825     }
826 
827     function approve(address _spender, uint256 _value) requiresCirculation returns (bool) {
828         return super.approve(_spender, _value);
829     }
830 
831 
832     // INTERNAL functions
833 
834     function enableCirculation() internal returns (bool) {
835         if (m_isCirculating)
836             return false;
837 
838         m_isCirculating = true;
839         CirculationEnabled();
840         return true;
841     }
842 
843 
844     // FIELDS
845 
846     /// @notice are the circulation started?
847     bool public m_isCirculating;
848 }
849 
850 
851 
852 /// @title StandardToken which can be minted by another contract.
853 contract MintableMultiownedToken is MultiownedControlled, StandardToken {
854 
855     /// @dev parameters of an extra token emission
856     struct EmissionInfo {
857         // tokens created
858         uint256 created;
859 
860         // totalSupply at the moment of emission (excluding created tokens)
861         uint256 totalSupplyWas;
862     }
863 
864     event Mint(address indexed to, uint256 amount);
865     event Emission(uint256 tokensCreated, uint256 totalSupplyWas, uint256 time);
866     event Dividend(address indexed to, uint256 amount);
867 
868 
869     // PUBLIC interface
870 
871     function MintableMultiownedToken(address[] _owners, uint _signaturesRequired, address _minter)
872         MultiownedControlled(_owners, _signaturesRequired, _minter)
873     {
874         dividendsPool = this;   // or any other special unforgeable value, actually
875 
876         // emission #0 is a dummy: because of default value 0 in m_lastAccountEmission
877         m_emissions.push(EmissionInfo({created: 0, totalSupplyWas: 0}));
878     }
879 
880     /// @notice Request dividends for current account.
881     function requestDividends() external {
882         payDividendsTo(msg.sender);
883     }
884 
885     /// @notice hook on standard ERC20#transfer to pay dividends
886     function transfer(address _to, uint256 _value) returns (bool) {
887         payDividendsTo(msg.sender);
888         payDividendsTo(_to);
889         return super.transfer(_to, _value);
890     }
891 
892     /// @notice hook on standard ERC20#transferFrom to pay dividends
893     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
894         payDividendsTo(_from);
895         payDividendsTo(_to);
896         return super.transferFrom(_from, _to, _value);
897     }
898 
899     // Disabled: this could be undesirable because sum of (balanceOf() for each token owner) != totalSupply
900     // (but: sum of (balances[owner] for each token owner) == totalSupply!).
901     //
902     // @notice hook on standard ERC20#balanceOf to take dividends into consideration
903     // function balanceOf(address _owner) constant returns (uint256) {
904     //     var (hasNewDividends, dividends) = calculateDividendsFor(_owner);
905     //     return hasNewDividends ? super.balanceOf(_owner).add(dividends) : super.balanceOf(_owner);
906     // }
907 
908 
909     /// @dev mints new tokens
910     function mint(address _to, uint256 _amount) external onlyController {
911         require(m_externalMintingEnabled);
912         payDividendsTo(_to);
913         mintInternal(_to, _amount);
914     }
915 
916     /// @dev disables mint(), irreversible!
917     function disableMinting() external onlyController {
918         require(m_externalMintingEnabled);
919         m_externalMintingEnabled = false;
920     }
921 
922 
923     // INTERNAL functions
924 
925     /**
926      * @notice Starts new token emission
927      * @param _tokensCreated Amount of tokens to create
928      * @dev Dividends are not distributed immediately as it could require billions of gas,
929      * instead they are `pulled` by a holder from dividends pool account before any update to the holder account occurs.
930      */
931     function emissionInternal(uint256 _tokensCreated) internal {
932         require(0 != _tokensCreated);
933         require(_tokensCreated < totalSupply / 2);  // otherwise it looks like an error
934 
935         uint256 totalSupplyWas = totalSupply;
936 
937         m_emissions.push(EmissionInfo({created: _tokensCreated, totalSupplyWas: totalSupplyWas}));
938         mintInternal(dividendsPool, _tokensCreated);
939 
940         Emission(_tokensCreated, totalSupplyWas, now);
941     }
942 
943     function mintInternal(address _to, uint256 _amount) internal {
944         totalSupply = totalSupply.add(_amount);
945         balances[_to] = balances[_to].add(_amount);
946         Mint(_to, _amount);
947     }
948 
949     /// @dev adds dividends to the account _to
950     function payDividendsTo(address _to) internal {
951         var (hasNewDividends, dividends) = calculateDividendsFor(_to);
952         if (!hasNewDividends)
953             return;
954 
955         if (0 != dividends) {
956             balances[dividendsPool] = balances[dividendsPool].sub(dividends);
957             balances[_to] = balances[_to].add(dividends);
958         }
959         m_lastAccountEmission[_to] = getLastEmissionNum();
960     }
961 
962     /// @dev calculates dividends for the account _for
963     /// @return (true if state has to be updated, dividend amount (could be 0!))
964     function calculateDividendsFor(address _for) constant internal returns (bool hasNewDividends, uint dividends) {
965         assert(_for != dividendsPool);  // no dividends for the pool!
966 
967         uint256 lastEmissionNum = getLastEmissionNum();
968         uint256 lastAccountEmissionNum = m_lastAccountEmission[_for];
969         assert(lastAccountEmissionNum <= lastEmissionNum);
970         if (lastAccountEmissionNum == lastEmissionNum)
971             return (false, 0);
972 
973         uint256 initialBalance = balances[_for];    // beware of recursion!
974         if (0 == initialBalance)
975             return (true, 0);
976 
977         uint256 balance = initialBalance;
978         for (uint256 emissionToProcess = lastAccountEmissionNum + 1; emissionToProcess <= lastEmissionNum; emissionToProcess++) {
979             EmissionInfo storage emission = m_emissions[emissionToProcess];
980             assert(0 != emission.created && 0 != emission.totalSupplyWas);
981 
982             uint256 dividend = balance.mul(emission.created).div(emission.totalSupplyWas);
983             Dividend(_for, dividend);
984 
985             balance = balance.add(dividend);
986         }
987 
988         return (true, balance.sub(initialBalance));
989     }
990 
991     function getLastEmissionNum() private constant returns (uint256) {
992         return m_emissions.length - 1;
993     }
994 
995 
996     // FIELDS
997 
998     /// @notice if this true then token is still externally mintable (but this flag does't affect emissions!)
999     bool public m_externalMintingEnabled = true;
1000 
1001     /// @dev internal address of dividends in balances mapping.
1002     address dividendsPool;
1003 
1004     /// @notice record of issued dividend emissions
1005     EmissionInfo[] public m_emissions;
1006 
1007     /// @dev for each token holder: last emission (index in m_emissions) which was processed for this holder
1008     mapping(address => uint256) m_lastAccountEmission;
1009 }
1010 
1011 
1012 /// @title Storiqa coin contract
1013 contract STQToken is CirculatingToken, MintableMultiownedToken {
1014 
1015 
1016     // PUBLIC interface
1017 
1018     function STQToken(address[] _owners)
1019         MintableMultiownedToken(_owners, 2, /* minter: */ address(0))
1020     {
1021         require(3 == _owners.length);
1022     }
1023 
1024     /// @notice Allows token transfers
1025     function startCirculation() external onlyController {
1026         assert(enableCirculation());    // must be called once
1027     }
1028 
1029     /// @notice Starts new token emission
1030     /// @param _tokensCreatedInSTQ Amount of STQ (not STQ-wei!) to create, like 30 000 or so
1031     function emission(uint256 _tokensCreatedInSTQ) external onlymanyowners(sha3(msg.data)) {
1032         emissionInternal(_tokensCreatedInSTQ.mul(uint256(10) ** uint256(decimals)));
1033     }
1034 
1035 
1036     // FIELDS
1037 
1038     string public constant name = 'Storiqa Token';
1039     string public constant symbol = 'STQ';
1040     uint8 public constant decimals = 18;
1041 }
1042 
1043 
1044 /**
1045  * @title Math
1046  * @dev Assorted math operations
1047  */
1048 
1049 library Math {
1050   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
1051     return a >= b ? a : b;
1052   }
1053 
1054   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
1055     return a < b ? a : b;
1056   }
1057 
1058   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
1059     return a >= b ? a : b;
1060   }
1061 
1062   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
1063     return a < b ? a : b;
1064   }
1065 }
1066 
1067 
1068 
1069 /// @title Storiqa ICO contract
1070 contract STQCrowdsale is multiowned, ReentrancyGuard {
1071     using Math for uint256;
1072     using SafeMath for uint256;
1073     using FixedTimeBonuses for FixedTimeBonuses.Data;
1074 
1075     uint internal constant MSK2UTC_DELTA = 3600 * 3;
1076 
1077     enum IcoState { INIT, ICO, PAUSED, FAILED, SUCCEEDED }
1078 
1079 
1080     event StateChanged(IcoState _state);
1081     event FundTransfer(address backer, uint amount, bool isContribution);
1082 
1083 
1084     modifier requiresState(IcoState _state) {
1085         require(m_state == _state);
1086         _;
1087     }
1088 
1089     /// @dev triggers some state changes based on current time
1090     /// note: function body could be skipped!
1091     modifier timedStateChange() {
1092         if (IcoState.INIT == m_state && getCurrentTime() >= getStartTime())
1093             changeState(IcoState.ICO);
1094 
1095         if (IcoState.ICO == m_state && getCurrentTime() > getEndTime()) {
1096             finishICO();
1097 
1098             if (msg.value > 0)
1099                 msg.sender.transfer(msg.value);
1100             // note that execution of further (but not preceding!) modifiers and functions ends here
1101         } else {
1102             _;
1103         }
1104     }
1105 
1106     /// @dev automatic check for unaccounted withdrawals
1107     modifier fundsChecker() {
1108         assert(m_state == IcoState.ICO);
1109 
1110         uint atTheBeginning = m_funds.balance;
1111         if (atTheBeginning < m_lastFundsAmount) {
1112             changeState(IcoState.PAUSED);
1113             if (msg.value > 0)
1114                 msg.sender.transfer(msg.value); // we cant throw (have to save state), so refunding this way
1115             // note that execution of further (but not preceding!) modifiers and functions ends here
1116         } else {
1117             _;
1118 
1119             if (m_funds.balance < atTheBeginning) {
1120                 changeState(IcoState.PAUSED);
1121             } else {
1122                 m_lastFundsAmount = m_funds.balance;
1123             }
1124         }
1125     }
1126 
1127 
1128     // PUBLIC interface
1129 
1130     function STQCrowdsale(address[] _owners, address _token, address _funds)
1131         multiowned(_owners, 2)
1132     {
1133         require(3 == _owners.length);
1134         require(address(0) != address(_token) && address(0) != address(_funds));
1135 
1136         m_token = STQToken(_token);
1137         m_funds = FundsRegistry(_funds);
1138 
1139         m_bonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1505681999 + MSK2UTC_DELTA, bonus: 50}));
1140         m_bonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1505768399 + MSK2UTC_DELTA, bonus: 25}));
1141         m_bonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1505941199 + MSK2UTC_DELTA, bonus: 20}));
1142         m_bonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1506200399 + MSK2UTC_DELTA, bonus: 15}));
1143         m_bonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1506545999 + MSK2UTC_DELTA, bonus: 10}));
1144         m_bonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1506891599 + MSK2UTC_DELTA, bonus: 5}));
1145         m_bonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1508360399 + MSK2UTC_DELTA, bonus: 0}));
1146         m_bonuses.validate(true);
1147     }
1148 
1149 
1150     // PUBLIC interface: payments
1151 
1152     // fallback function as a shortcut
1153     function() payable {
1154         buy();  // only internal call here!
1155     }
1156 
1157     /// @notice ICO participation
1158     /// @return number of STQ tokens bought (with all decimal symbols)
1159     function buy()
1160         public
1161         payable
1162         nonReentrant
1163         timedStateChange
1164         requiresState(IcoState.ICO)
1165         fundsChecker
1166         returns (uint)
1167     {
1168         address investor = msg.sender;
1169         uint256 payment = msg.value;
1170         require(payment >= c_MinInvestment);
1171 
1172         uint startingInvariant = this.balance.add(m_funds.balance);
1173 
1174         // checking for max cap
1175         uint fundsAllowed = getMaximumFunds().sub(m_funds.totalInvested());
1176         assert(0 != fundsAllowed);  // in this case state must not be IcoState.ICO
1177         payment = fundsAllowed.min256(payment);
1178         uint256 change = msg.value.sub(payment);
1179 
1180         // issue tokens
1181         uint stq = calcSTQAmount(payment);
1182         m_token.mint(investor, stq);
1183 
1184         // record payment
1185         m_funds.invested.value(payment)(investor);
1186         FundTransfer(investor, payment, true);
1187 
1188         // check if ICO must be closed early
1189         if (change > 0)
1190         {
1191             assert(getMaximumFunds() == m_funds.totalInvested());
1192             finishICO();
1193 
1194             // send change
1195             investor.transfer(change);
1196             assert(startingInvariant == this.balance.add(m_funds.balance).add(change));
1197         }
1198         else
1199             assert(startingInvariant == this.balance.add(m_funds.balance));
1200 
1201         return stq;
1202     }
1203 
1204 
1205     // PUBLIC interface: owners: maintenance
1206 
1207     /// @notice pauses ICO
1208     function pause()
1209         external
1210         timedStateChange
1211         requiresState(IcoState.ICO)
1212         onlyowner
1213     {
1214         changeState(IcoState.PAUSED);
1215     }
1216 
1217     /// @notice resume paused ICO
1218     function unpause()
1219         external
1220         timedStateChange
1221         requiresState(IcoState.PAUSED)
1222         onlymanyowners(sha3(msg.data))
1223     {
1224         changeState(IcoState.ICO);
1225         checkTime();
1226     }
1227 
1228     /// @notice consider paused ICO as failed
1229     function fail()
1230         external
1231         timedStateChange
1232         requiresState(IcoState.PAUSED)
1233         onlymanyowners(sha3(msg.data))
1234     {
1235         changeState(IcoState.FAILED);
1236     }
1237 
1238     /// @notice In case we need to attach to existent token
1239     function setToken(address _token)
1240         external
1241         timedStateChange
1242         requiresState(IcoState.PAUSED)
1243         onlymanyowners(sha3(msg.data))
1244     {
1245         require(address(0) != _token);
1246         m_token = STQToken(_token);
1247     }
1248 
1249     /// @notice In case we need to attach to existent funds
1250     function setFundsRegistry(address _funds)
1251         external
1252         timedStateChange
1253         requiresState(IcoState.PAUSED)
1254         onlymanyowners(sha3(msg.data))
1255     {
1256         require(address(0) != _funds);
1257         m_funds = FundsRegistry(_funds);
1258     }
1259 
1260     /// @notice explicit trigger for timed state changes
1261     function checkTime()
1262         public
1263         timedStateChange
1264         onlyowner
1265     {
1266     }
1267 
1268 
1269     // INTERNAL functions
1270 
1271     function finishICO() private {
1272         if (m_funds.totalInvested() < getMinFunds())
1273             changeState(IcoState.FAILED);
1274         else
1275             changeState(IcoState.SUCCEEDED);
1276     }
1277 
1278     /// @dev performs only allowed state transitions
1279     function changeState(IcoState _newState) private {
1280         assert(m_state != _newState);
1281 
1282         if (IcoState.INIT == m_state) {        assert(IcoState.ICO == _newState); }
1283         else if (IcoState.ICO == m_state) {    assert(IcoState.PAUSED == _newState || IcoState.FAILED == _newState || IcoState.SUCCEEDED == _newState); }
1284         else if (IcoState.PAUSED == m_state) { assert(IcoState.ICO == _newState || IcoState.FAILED == _newState); }
1285         else assert(false);
1286 
1287         m_state = _newState;
1288         StateChanged(m_state);
1289 
1290         // this should be tightly linked
1291         if (IcoState.SUCCEEDED == m_state) {
1292             onSuccess();
1293         } else if (IcoState.FAILED == m_state) {
1294             onFailure();
1295         }
1296     }
1297 
1298     function onSuccess() private {
1299         // mint tokens for owners
1300         uint tokensPerOwner = m_token.totalSupply().mul(4).div(m_numOwners);
1301         for (uint i = 0; i < m_numOwners; i++)
1302             m_token.mint(getOwner(i), tokensPerOwner);
1303 
1304         m_funds.changeState(FundsRegistry.State.SUCCEEDED);
1305         m_funds.detachController();
1306 
1307         m_token.disableMinting();
1308         m_token.startCirculation();
1309         m_token.detachController();
1310     }
1311 
1312     function onFailure() private {
1313         m_funds.changeState(FundsRegistry.State.REFUNDING);
1314         m_funds.detachController();
1315     }
1316 
1317 
1318     /// @dev calculates amount of STQ to which payer of _wei is entitled
1319     function calcSTQAmount(uint _wei) private constant returns (uint) {
1320         uint stq = _wei.mul(c_STQperETH);
1321 
1322         // apply bonus
1323         stq = stq.mul(m_bonuses.getBonus(getCurrentTime()).add(100)).div(100);
1324 
1325         return stq;
1326     }
1327 
1328     /// @dev start time of the ICO, inclusive
1329     function getStartTime() private constant returns (uint) {
1330         return c_startTime;
1331     }
1332 
1333     /// @dev end time of the ICO, inclusive
1334     function getEndTime() private constant returns (uint) {
1335         return m_bonuses.getLastTime();
1336     }
1337 
1338     /// @dev to be overridden in tests
1339     function getCurrentTime() internal constant returns (uint) {
1340         return now;
1341     }
1342 
1343     /// @dev to be overridden in tests
1344     function getMinFunds() internal constant returns (uint) {
1345         return c_MinFunds;
1346     }
1347 
1348     /// @dev to be overridden in tests
1349     function getMaximumFunds() internal constant returns (uint) {
1350         return c_MaximumFunds;
1351     }
1352 
1353 
1354     // FIELDS
1355 
1356     /// @notice starting exchange rate of STQ
1357     uint public constant c_STQperETH = 100;
1358 
1359     /// @notice minimum investment
1360     uint public constant c_MinInvestment = 10 finney;
1361 
1362     /// @notice minimum investments to consider ICO as a success
1363     uint public constant c_MinFunds = 5000 ether;
1364 
1365     /// @notice maximum investments to be accepted during ICO
1366     uint public constant c_MaximumFunds = 500000 ether;
1367 
1368     /// @notice start time of the ICO
1369     uint public constant c_startTime = 1505541600;
1370 
1371     /// @notice timed bonuses
1372     FixedTimeBonuses.Data m_bonuses;
1373 
1374     /// @dev state of the ICO
1375     IcoState public m_state = IcoState.INIT;
1376 
1377     /// @dev contract responsible for token accounting
1378     STQToken public m_token;
1379 
1380     /// @dev contract responsible for investments accounting
1381     FundsRegistry public m_funds;
1382 
1383     /// @dev last recorded funds
1384     uint256 public m_lastFundsAmount;
1385 }