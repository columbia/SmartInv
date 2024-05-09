1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
7 // TODO acceptOwnership
8 contract multiowned {
9 
10     // TYPES
11 
12     // struct for the status of a pending operation.
13     struct MultiOwnedOperationPendingState {
14     // count of confirmations needed
15     uint yetNeeded;
16 
17     // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
18     uint ownersDone;
19 
20     // position of this operation key in m_multiOwnedPendingIndex
21     uint index;
22     }
23 
24     // EVENTS
25 
26     event Confirmation(address owner, bytes32 operation);
27     event Revoke(address owner, bytes32 operation);
28     event FinalConfirmation(address owner, bytes32 operation);
29 
30     // some others are in the case of an owner changing.
31     event OwnerChanged(address oldOwner, address newOwner);
32     event OwnerAdded(address newOwner);
33     event OwnerRemoved(address oldOwner);
34 
35     // the last one is emitted if the required signatures change
36     event RequirementChanged(uint newRequirement);
37 
38     // MODIFIERS
39 
40     // simple single-sig function modifier.
41     modifier onlyowner {
42         require(isOwner(msg.sender));
43         _;
44     }
45     // multi-sig function modifier: the operation must have an intrinsic hash in order
46     // that later attempts can be realised as the same underlying operation and
47     // thus count as confirmations.
48     modifier onlymanyowners(bytes32 _operation) {
49         if (confirmAndCheck(_operation)) {
50             _;
51         }
52         // Even if required number of confirmations has't been collected yet,
53         // we can't throw here - because changes to the state have to be preserved.
54         // But, confirmAndCheck itself will throw in case sender is not an owner.
55     }
56 
57     modifier validNumOwners(uint _numOwners) {
58         require(_numOwners > 0 && _numOwners <= c_maxOwners);
59         _;
60     }
61 
62     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
63         require(_required > 0 && _required <= _numOwners);
64         _;
65     }
66 
67     modifier ownerExists(address _address) {
68         require(isOwner(_address));
69         _;
70     }
71 
72     modifier ownerDoesNotExist(address _address) {
73         require(!isOwner(_address));
74         _;
75     }
76 
77     modifier multiOwnedOperationIsActive(bytes32 _operation) {
78         require(isOperationActive(_operation));
79         _;
80     }
81 
82     // METHODS
83 
84     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
85     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
86     function multiowned(address[] _owners, uint _required)
87     validNumOwners(_owners.length)
88     multiOwnedValidRequirement(_required, _owners.length)
89     {
90         assert(c_maxOwners <= 255);
91 
92         m_numOwners = _owners.length;
93         m_multiOwnedRequired = _required;
94 
95         for (uint i = 0; i < _owners.length; ++i)
96         {
97             address owner = _owners[i];
98             // invalid and duplicate addresses are not allowed
99             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
100 
101             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
102             m_owners[currentOwnerIndex] = owner;
103             m_ownerIndex[owner] = currentOwnerIndex;
104         }
105 
106         assertOwnersAreConsistent();
107     }
108 
109     /// @notice replaces an owner `_from` with another `_to`.
110     /// @param _from address of owner to replace
111     /// @param _to address of new owner
112     // All pending operations will be canceled!
113     function changeOwner(address _from, address _to)
114     external
115     ownerExists(_from)
116     ownerDoesNotExist(_to)
117     onlymanyowners(sha3(msg.data))
118     {
119         assertOwnersAreConsistent();
120 
121         clearPending();
122         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
123         m_owners[ownerIndex] = _to;
124         m_ownerIndex[_from] = 0;
125         m_ownerIndex[_to] = ownerIndex;
126 
127         assertOwnersAreConsistent();
128         OwnerChanged(_from, _to);
129     }
130 
131     /// @notice adds an owner
132     /// @param _owner address of new owner
133     // All pending operations will be canceled!
134     function addOwner(address _owner)
135     external
136     ownerDoesNotExist(_owner)
137     validNumOwners(m_numOwners + 1)
138     onlymanyowners(sha3(msg.data))
139     {
140         assertOwnersAreConsistent();
141 
142         clearPending();
143         m_numOwners++;
144         m_owners[m_numOwners] = _owner;
145         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
146 
147         assertOwnersAreConsistent();
148         OwnerAdded(_owner);
149     }
150 
151     /// @notice removes an owner
152     /// @param _owner address of owner to remove
153     // All pending operations will be canceled!
154     function removeOwner(address _owner)
155     external
156     ownerExists(_owner)
157     validNumOwners(m_numOwners - 1)
158     multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
159     onlymanyowners(sha3(msg.data))
160     {
161         assertOwnersAreConsistent();
162 
163         clearPending();
164         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
165         m_owners[ownerIndex] = 0;
166         m_ownerIndex[_owner] = 0;
167         //make sure m_numOwners is equal to the number of owners and always points to the last owner
168         reorganizeOwners();
169 
170         assertOwnersAreConsistent();
171         OwnerRemoved(_owner);
172     }
173 
174     /// @notice changes the required number of owner signatures
175     /// @param _newRequired new number of signatures required
176     // All pending operations will be canceled!
177     function changeRequirement(uint _newRequired)
178     external
179     multiOwnedValidRequirement(_newRequired, m_numOwners)
180     onlymanyowners(sha3(msg.data))
181     {
182         m_multiOwnedRequired = _newRequired;
183         clearPending();
184         RequirementChanged(_newRequired);
185     }
186 
187     /// @notice Gets an owner by 0-indexed position
188     /// @param ownerIndex 0-indexed owner position
189     function getOwner(uint ownerIndex) public constant returns (address) {
190         return m_owners[ownerIndex + 1];
191     }
192 
193     /// @notice Gets owners
194     /// @return memory array of owners
195     function getOwners() public constant returns (address[]) {
196         address[] memory result = new address[](m_numOwners);
197         for (uint i = 0; i < m_numOwners; i++)
198         result[i] = getOwner(i);
199 
200         return result;
201     }
202 
203     /// @notice checks if provided address is an owner address
204     /// @param _addr address to check
205     /// @return true if it's an owner
206     function isOwner(address _addr) public constant returns (bool) {
207         return m_ownerIndex[_addr] > 0;
208     }
209 
210     /// @notice Tests ownership of the current caller.
211     /// @return true if it's an owner
212     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
213     // addOwner/changeOwner and to isOwner.
214     function amIOwner() external constant onlyowner returns (bool) {
215         return true;
216     }
217 
218     /// @notice Revokes a prior confirmation of the given operation
219     /// @param _operation operation value, typically sha3(msg.data)
220     function revoke(bytes32 _operation)
221     external
222     multiOwnedOperationIsActive(_operation)
223     onlyowner
224     {
225         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
226         var pending = m_multiOwnedPending[_operation];
227         require(pending.ownersDone & ownerIndexBit > 0);
228 
229         assertOperationIsConsistent(_operation);
230 
231         pending.yetNeeded++;
232         pending.ownersDone -= ownerIndexBit;
233 
234         assertOperationIsConsistent(_operation);
235         Revoke(msg.sender, _operation);
236     }
237 
238     /// @notice Checks if owner confirmed given operation
239     /// @param _operation operation value, typically sha3(msg.data)
240     /// @param _owner an owner address
241     function hasConfirmed(bytes32 _operation, address _owner)
242     external
243     constant
244     multiOwnedOperationIsActive(_operation)
245     ownerExists(_owner)
246     returns (bool)
247     {
248         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
249     }
250 
251     // INTERNAL METHODS
252 
253     function confirmAndCheck(bytes32 _operation)
254     private
255     onlyowner
256     returns (bool)
257     {
258         if (512 == m_multiOwnedPendingIndex.length)
259         // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
260         // we won't be able to do it because of block gas limit.
261         // Yes, pending confirmations will be lost. Dont see any security or stability implications.
262         // TODO use more graceful approach like compact or removal of clearPending completely
263         clearPending();
264 
265         var pending = m_multiOwnedPending[_operation];
266 
267         // if we're not yet working on this operation, switch over and reset the confirmation status.
268         if (! isOperationActive(_operation)) {
269             // reset count of confirmations needed.
270             pending.yetNeeded = m_multiOwnedRequired;
271             // reset which owners have confirmed (none) - set our bitmap to 0.
272             pending.ownersDone = 0;
273             pending.index = m_multiOwnedPendingIndex.length++;
274             m_multiOwnedPendingIndex[pending.index] = _operation;
275             assertOperationIsConsistent(_operation);
276         }
277 
278         // determine the bit to set for this owner.
279         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
280         // make sure we (the message sender) haven't confirmed this operation previously.
281         if (pending.ownersDone & ownerIndexBit == 0) {
282             // ok - check if count is enough to go ahead.
283             assert(pending.yetNeeded > 0);
284             if (pending.yetNeeded == 1) {
285                 // enough confirmations: reset and run interior.
286                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
287                 delete m_multiOwnedPending[_operation];
288                 FinalConfirmation(msg.sender, _operation);
289                 return true;
290             }
291             else
292             {
293                 // not enough: record that this owner in particular confirmed.
294                 pending.yetNeeded--;
295                 pending.ownersDone |= ownerIndexBit;
296                 assertOperationIsConsistent(_operation);
297                 Confirmation(msg.sender, _operation);
298             }
299         }
300     }
301 
302     // Reclaims free slots between valid owners in m_owners.
303     // TODO given that its called after each removal, it could be simplified.
304     function reorganizeOwners() private {
305         uint free = 1;
306         while (free < m_numOwners)
307         {
308             // iterating to the first free slot from the beginning
309             while (free < m_numOwners && m_owners[free] != 0) free++;
310 
311             // iterating to the first occupied slot from the end
312             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
313 
314             // swap, if possible, so free slot is located at the end after the swap
315             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
316             {
317                 // owners between swapped slots should't be renumbered - that saves a lot of gas
318                 m_owners[free] = m_owners[m_numOwners];
319                 m_ownerIndex[m_owners[free]] = free;
320                 m_owners[m_numOwners] = 0;
321             }
322         }
323     }
324 
325     function clearPending() private onlyowner {
326         uint length = m_multiOwnedPendingIndex.length;
327         // TODO block gas limit
328         for (uint i = 0; i < length; ++i) {
329             if (m_multiOwnedPendingIndex[i] != 0)
330             delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
331         }
332         delete m_multiOwnedPendingIndex;
333     }
334 
335     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
336         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
337         return ownerIndex;
338     }
339 
340     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
341         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
342         return 2 ** ownerIndex;
343     }
344 
345     function isOperationActive(bytes32 _operation) private constant returns (bool) {
346         return 0 != m_multiOwnedPending[_operation].yetNeeded;
347     }
348 
349 
350     function assertOwnersAreConsistent() private constant {
351         assert(m_numOwners > 0);
352         assert(m_numOwners <= c_maxOwners);
353         assert(m_owners[0] == 0);
354         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
355     }
356 
357     function assertOperationIsConsistent(bytes32 _operation) private constant {
358         var pending = m_multiOwnedPending[_operation];
359         assert(0 != pending.yetNeeded);
360         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
361         assert(pending.yetNeeded <= m_multiOwnedRequired);
362     }
363 
364 
365     // FIELDS
366 
367     uint constant c_maxOwners = 250;
368 
369     // the number of owners that must confirm the same operation before it is run.
370     uint public m_multiOwnedRequired;
371 
372 
373     // pointer used to find a free slot in m_owners
374     uint public m_numOwners;
375 
376     // list of owners (addresses),
377     // slot 0 is unused so there are no owner which index is 0.
378     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
379     address[256] internal m_owners;
380 
381     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
382     mapping(address => uint) internal m_ownerIndex;
383 
384 
385     // the ongoing operations.
386     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
387     bytes32[] internal m_multiOwnedPendingIndex;
388 }
389 
390 /**
391  * @title Helps contracts guard agains rentrancy attacks.
392  * @author Remco Bloemen <remco@2π.com>
393  * @notice If you mark a function `nonReentrant`, you should also
394  * mark it `external`.
395  */
396 contract ReentrancyGuard {
397 
398     /**
399      * @dev We use a single lock for the whole contract.
400      */
401     bool private rentrancy_lock = false;
402 
403     /**
404      * @dev Prevents a contract from calling itself, directly or indirectly.
405      * @notice If you mark a function `nonReentrant`, you should also
406      * mark it `external`. Calling one nonReentrant function from
407      * another is not supported. Instead, you can implement a
408      * `private` function doing the actual work, and a `external`
409      * wrapper marked as `nonReentrant`.
410      */
411     modifier nonReentrant() {
412         require(!rentrancy_lock);
413         rentrancy_lock = true;
414         _;
415         rentrancy_lock = false;
416     }
417 
418 }
419 
420 
421 /**
422  * @title Contract which is owned by owners and operated by controller.
423  *
424  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
425  * Controller is set up by owners or during construction.
426  *
427  * @dev controller check is performed by onlyController modifier.
428  */
429 contract MultiownedControlled is multiowned {
430 
431     event ControllerSet(address controller);
432     event ControllerRetired(address was);
433 
434 
435     modifier onlyController {
436         require(msg.sender == m_controller);
437         _;
438     }
439 
440 
441     // PUBLIC interface
442 
443     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
444     multiowned(_owners, _signaturesRequired)
445     {
446         m_controller = _controller;
447         ControllerSet(m_controller);
448     }
449 
450     /// @dev sets the controller
451     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
452         m_controller = _controller;
453         ControllerSet(m_controller);
454     }
455 
456     /// @dev ability for controller to step down
457     function detachController() external onlyController {
458         address was = m_controller;
459         m_controller = address(0);
460         ControllerRetired(was);
461     }
462 
463 
464     // FIELDS
465 
466     /// @notice address of entity entitled to mint new tokens
467     address public m_controller;
468 }
469 
470 
471 /// @title utility methods and modifiers of arguments validation
472 contract ArgumentsChecker {
473 
474     /// @dev check which prevents short address attack
475     modifier payloadSizeIs(uint size) {
476         require(msg.data.length == size + 4 /* function selector */);
477         _;
478     }
479 
480     /// @dev check that address is valid
481     modifier validAddress(address addr) {
482         require(addr != address(0));
483         _;
484     }
485 }
486 
487 
488 /// @title registry of funds sent by investors
489 contract FundsRegistry is ArgumentsChecker, MultiownedControlled, ReentrancyGuard {
490     using SafeMath for uint256;
491 
492     enum State {
493     // gathering funds
494     GATHERING,
495     // returning funds to investors
496     REFUNDING,
497     // funds can be pulled by owners
498     SUCCEEDED
499     }
500 
501     event StateChanged(State _state);
502     event Invested(address indexed investor, uint256 amount);
503     event EtherSent(address indexed to, uint value);
504     event RefundSent(address indexed to, uint value);
505 
506 
507     modifier requiresState(State _state) {
508         require(m_state == _state);
509         _;
510     }
511 
512 
513     // PUBLIC interface
514 
515     function FundsRegistry(address[] _owners, uint _signaturesRequired, address _controller)
516     MultiownedControlled(_owners, _signaturesRequired, _controller)
517     {
518     }
519 
520     /// @dev performs only allowed state transitions
521     function changeState(State _newState)
522     external
523     onlyController
524     {
525         assert(m_state != _newState);
526 
527         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
528         else assert(false);
529 
530         m_state = _newState;
531         StateChanged(m_state);
532     }
533 
534     /// @dev records an investment
535     function invested(address _investor)
536     external
537     payable
538     onlyController
539     requiresState(State.GATHERING)
540     {
541         uint256 amount = msg.value;
542         require(0 != amount);
543         assert(_investor != m_controller);
544 
545         // register investor
546         if (0 == m_weiBalances[_investor])
547         m_investors.push(_investor);
548 
549         // register payment
550         totalInvested = totalInvested.add(amount);
551         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
552 
553         Invested(_investor, amount);
554     }
555 
556     /// @notice owners: send `value` of ether to address `to`, can be called if crowdsale succeeded
557     /// @param to where to send ether
558     /// @param value amount of wei to send
559     function sendEther(address to, uint value)
560     external
561     validAddress(to)
562     onlymanyowners(sha3(msg.data))
563     requiresState(State.SUCCEEDED)
564     {
565         require(value > 0 && this.balance >= value);
566         to.transfer(value);
567         EtherSent(to, value);
568     }
569 
570     /// @notice withdraw accumulated balance, called by payee in case crowdsale failed
571     function withdrawPayments(address payee)
572     external
573     nonReentrant
574     onlyController
575     requiresState(State.REFUNDING)
576     {
577         uint256 payment = m_weiBalances[payee];
578 
579         require(payment != 0);
580         require(this.balance >= payment);
581 
582         totalInvested = totalInvested.sub(payment);
583         m_weiBalances[payee] = 0;
584 
585         payee.transfer(payment);
586         RefundSent(payee, payment);
587     }
588 
589     function getInvestorsCount() external constant returns (uint) { return m_investors.length; }
590 
591 
592     // FIELDS
593 
594     /// @notice total amount of investments in wei
595     uint256 public totalInvested;
596 
597     /// @notice state of the registry
598     State public m_state = State.GATHERING;
599 
600     /// @dev balances of investors in wei
601     mapping(address => uint256) public m_weiBalances;
602 
603     /// @dev list of unique investors
604     address[] public m_investors;
605 }
606 
607 
608 ///123
609 /**
610  * @title SafeMath
611  * @dev Math operations with safety checks that throw on error
612  */
613 library SafeMath {
614     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
615         if (a == 0) {
616             return 0;
617         }
618         uint256 c = a * b;
619         assert(c / a == b);
620         return c;
621     }
622 
623     function div(uint256 a, uint256 b) internal pure returns (uint256) {
624         // assert(b > 0); // Solidity automatically throws when dividing by 0
625         uint256 c = a / b;
626         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
627         return c;
628     }
629 
630     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
631         assert(b <= a);
632         return a - b;
633     }
634 
635     function add(uint256 a, uint256 b) internal pure returns (uint256) {
636         uint256 c = a + b;
637         assert(c >= a);
638         return c;
639     }
640 }
641 
642 
643 /**
644  * @title ERC20Basic
645  * @dev Simpler version of ERC20 interface
646  * @dev see https://github.com/ethereum/EIPs/issues/179
647  */
648 contract ERC20Basic {
649     uint256 public totalSupply;
650     function balanceOf(address who) public view returns (uint256);
651     function transfer(address to, uint256 value) public returns (bool);
652     event Transfer(address indexed from, address indexed to, uint256 value);
653 }
654 
655 /**
656  * @title Basic token
657  * @dev Basic version of StandardToken, with no allowances.
658  */
659 contract BasicToken is ERC20Basic {
660     using SafeMath for uint256;
661 
662     mapping(address => uint256) balances;
663 
664     /**
665     * @dev transfer token for a specified address
666     * @param _to The address to transfer to.
667     * @param _value The amount to be transferred.
668     */
669     function transfer(address _to, uint256 _value) public returns (bool) {
670         require(_to != address(0));
671         require(_value <= balances[msg.sender]);
672 
673         // SafeMath.sub will throw if there is not enough balance.
674         balances[msg.sender] = balances[msg.sender].sub(_value);
675         balances[_to] = balances[_to].add(_value);
676         Transfer(msg.sender, _to, _value);
677         return true;
678     }
679 
680     /**
681     * @dev Gets the balance of the specified address.
682     * @param _owner The address to query the the balance of.
683     * @return An uint256 representing the amount owned by the passed address.
684     */
685     function balanceOf(address _owner) public view returns (uint256 balance) {
686         return balances[_owner];
687     }
688 
689 }
690 
691 
692 /**
693  * @title ERC20 interface
694  * @dev see https://github.com/ethereum/EIPs/issues/20
695  */
696 contract ERC20 is ERC20Basic {
697     function allowance(address owner, address spender) public view returns (uint256);
698     function transferFrom(address from, address to, uint256 value) public returns (bool);
699     function approve(address spender, uint256 value) public returns (bool);
700     event Approval(address indexed owner, address indexed spender, uint256 value);
701 }
702 
703 
704 /**
705  * @title Standard ERC20 token
706  *
707  * @dev Implementation of the basic standard token.
708  * @dev https://github.com/ethereum/EIPs/issues/20
709  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
710  */
711 contract StandardToken is ERC20, BasicToken {
712 
713     mapping (address => mapping (address => uint256)) internal allowed;
714 
715 
716     /**
717      * @dev Transfer tokens from one address to another
718      * @param _from address The address which you want to send tokens from
719      * @param _to address The address which you want to transfer to
720      * @param _value uint256 the amount of tokens to be transferred
721      */
722     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
723         require(_to != address(0));
724         require(_value <= balances[_from]);
725         require(_value <= allowed[_from][msg.sender]);
726 
727         balances[_from] = balances[_from].sub(_value);
728         balances[_to] = balances[_to].add(_value);
729         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
730         Transfer(_from, _to, _value);
731         return true;
732     }
733 
734     /**
735      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
736      *
737      * Beware that changing an allowance with this method brings the risk that someone may use both the old
738      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
739      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
740      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
741      * @param _spender The address which will spend the funds.
742      * @param _value The amount of tokens to be spent.
743      */
744     function approve(address _spender, uint256 _value) public returns (bool) {
745         allowed[msg.sender][_spender] = _value;
746         Approval(msg.sender, _spender, _value);
747         return true;
748     }
749 
750     /**
751      * @dev Function to check the amount of tokens that an owner allowed to a spender.
752      * @param _owner address The address which owns the funds.
753      * @param _spender address The address which will spend the funds.
754      * @return A uint256 specifying the amount of tokens still available for the spender.
755      */
756     function allowance(address _owner, address _spender) public view returns (uint256) {
757         return allowed[_owner][_spender];
758     }
759 
760     /**
761      * approve should be called when allowed[_spender] == 0. To increment
762      * allowed value is better to use this function to avoid 2 calls (and wait until
763      * the first transaction is mined)
764      * From MonolithDAO Token.sol
765      */
766     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
767         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
768         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
769         return true;
770     }
771 
772     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
773         uint oldValue = allowed[msg.sender][_spender];
774         if (_subtractedValue > oldValue) {
775             allowed[msg.sender][_spender] = 0;
776         } else {
777             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
778         }
779         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
780         return true;
781     }
782 
783 }
784 
785 
786 
787 /// @title StandardToken which can be minted by another contract.
788 contract MintableToken {
789     event Mint(address indexed to, uint256 amount);
790 
791     /// @dev mints new tokens
792     function mint(address _to, uint256 _amount) public;
793 }
794 
795 
796 
797 /**
798  * MetropolMintableToken
799  */
800 contract MetropolMintableToken is StandardToken, MintableToken {
801 
802     event Mint(address indexed to, uint256 amount);
803 
804     function mint(address _to, uint256 _amount) public;//todo propose return value
805 
806     /**
807      * Function to mint tokens
808      * Internal for not forgetting to add access modifier
809      *
810      * @param _to The address that will receive the minted tokens.
811      * @param _amount The amount of tokens to mint.
812      *
813      * @return A boolean that indicates if the operation was successful.
814      */
815     function mintInternal(address _to, uint256 _amount) internal returns (bool) {
816         require(_amount>0);
817         require(_to!=address(0));
818 
819         totalSupply = totalSupply.add(_amount);
820         balances[_to] = balances[_to].add(_amount);
821         Mint(_to, _amount);
822         Transfer(address(0), _to, _amount);
823 
824         return true;
825     }
826 
827 }
828 
829 /**
830  * Contract which is operated by controller.
831  *
832  * Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
833  *
834  * Controller check is performed by onlyController modifier.
835  */
836 contract Controlled {
837 
838     address public m_controller;
839 
840     event ControllerSet(address controller);
841     event ControllerRetired(address was);
842 
843 
844     modifier onlyController {
845         require(msg.sender == m_controller);
846         _;
847     }
848 
849     function setController(address _controller) external;
850 
851     /**
852      * Sets the controller. Internal for not forgetting to add access modifier
853      */
854     function setControllerInternal(address _controller) internal {
855         m_controller = _controller;
856         ControllerSet(m_controller);
857     }
858 
859     /**
860      * Ability for controller to step down
861      */
862     function detachController() external onlyController {
863         address was = m_controller;
864         m_controller = address(0);
865         ControllerRetired(was);
866     }
867 }
868 
869 
870 /**
871  * MintableControlledToken
872  */
873 contract MintableControlledToken is MetropolMintableToken, Controlled {
874 
875     /**
876      * Function to mint tokens
877      *
878      * @param _to The address that will receive the minted tokens.
879      * @param _amount The amount of tokens to mint.
880      *
881      * @return A boolean that indicates if the operation was successful.
882      */
883     function mint(address _to, uint256 _amount) public onlyController {
884         super.mintInternal(_to, _amount);
885     }
886 
887 }
888 
889 
890 /**
891  * BurnableToken
892  */
893 contract BurnableToken is StandardToken {
894 
895     event Burn(address indexed from, uint256 amount);
896 
897     function burn(address _from, uint256 _amount) public returns (bool);
898 
899     /**
900      * Function to burn tokens
901      * Internal for not forgetting to add access modifier
902      *
903      * @param _from The address to burn tokens from.
904      * @param _amount The amount of tokens to burn.
905      *
906      * @return A boolean that indicates if the operation was successful.
907      */
908     function burnInternal(address _from, uint256 _amount) internal returns (bool) {
909         require(_amount>0);
910         require(_amount<=balances[_from]);
911 
912         totalSupply = totalSupply.sub(_amount);
913         balances[_from] = balances[_from].sub(_amount);
914         Burn(_from, _amount);
915         Transfer(_from, address(0), _amount);
916 
917         return true;
918     }
919 
920 }
921 
922 
923 /**
924  * BurnableControlledToken
925  */
926 contract BurnableControlledToken is BurnableToken, Controlled {
927 
928     /**
929      * Function to burn tokens
930      *
931      * @param _from The address to burn tokens from.
932      * @param _amount The amount of tokens to burn.
933      *
934      * @return A boolean that indicates if the operation was successful.
935      */
936     function burn(address _from, uint256 _amount) public onlyController returns (bool) {
937         return super.burnInternal(_from, _amount);
938     }
939 
940 }
941 
942 
943 
944 /**
945  * Contract which is owned by owners and operated by controller.
946  *
947  * Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
948  * Controller is set up by owners or during construction.
949  *
950  */
951 contract MetropolMultiownedControlled is Controlled, multiowned {
952 
953 
954     function MetropolMultiownedControlled(address[] _owners, uint256 _signaturesRequired)
955     multiowned(_owners, _signaturesRequired)
956     public
957     {
958         // nothing here
959     }
960 
961     /**
962      * Sets the controller
963      */
964     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
965         super.setControllerInternal(_controller);
966     }
967 
968 }
969 
970 
971 
972 /// @title StandardToken which circulation can be delayed and started by another contract.
973 /// @dev To be used as a mixin contract.
974 /// The contract is created in disabled state: circulation is disabled.
975 contract CirculatingToken is StandardToken {
976 
977     event CirculationEnabled();
978 
979     modifier requiresCirculation {
980         require(m_isCirculating);
981         _;
982     }
983 
984 
985     // PUBLIC interface
986 
987     function transfer(address _to, uint256 _value) requiresCirculation returns (bool) {
988         return super.transfer(_to, _value);
989     }
990 
991     function transferFrom(address _from, address _to, uint256 _value) requiresCirculation returns (bool) {
992         return super.transferFrom(_from, _to, _value);
993     }
994 
995     function approve(address _spender, uint256 _value) requiresCirculation returns (bool) {
996         return super.approve(_spender, _value);
997     }
998 
999 
1000     // INTERNAL functions
1001 
1002     function enableCirculation() internal returns (bool) {
1003         if (m_isCirculating)
1004         return false;
1005 
1006         m_isCirculating = true;
1007         CirculationEnabled();
1008         return true;
1009     }
1010 
1011 
1012     // FIELDS
1013 
1014     /// @notice are the circulation started?
1015     bool public m_isCirculating;
1016 }
1017 
1018 
1019 
1020 
1021 /**
1022  * CirculatingControlledToken
1023  */
1024 contract CirculatingControlledToken is CirculatingToken, Controlled {
1025 
1026     /**
1027      * Allows token transfers
1028      */
1029     function startCirculation() external onlyController {
1030         assert(enableCirculation());    // must be called once
1031     }
1032 }
1033 
1034 
1035 
1036 /**
1037  * MetropolToken
1038  */
1039 contract MetropolToken is
1040     StandardToken,
1041     Controlled,
1042     MintableControlledToken,
1043     BurnableControlledToken,
1044     CirculatingControlledToken,
1045     MetropolMultiownedControlled
1046 {
1047     string internal m_name = '';
1048     string internal m_symbol = '';
1049     uint8 public constant decimals = 18;
1050 
1051     /**
1052      * MetropolToken constructor
1053      */
1054     function MetropolToken(address[] _owners)
1055         MetropolMultiownedControlled(_owners, 2)
1056         public
1057     {
1058         require(3 == _owners.length);
1059     }
1060 
1061     function name() public constant returns (string) {
1062         return m_name;
1063     }
1064     function symbol() public constant returns (string) {
1065         return m_symbol;
1066     }
1067 
1068     function setNameSymbol(string _name, string _symbol) external onlymanyowners(sha3(msg.data)) {
1069         require(bytes(m_name).length==0);
1070         require(bytes(_name).length!=0 && bytes(_symbol).length!=0);
1071 
1072         m_name = _name;
1073         m_symbol = _symbol;
1074     }
1075 
1076 }
1077 
1078 
1079 /////////123
1080 /**
1081  * @title Basic crowdsale stat
1082  * @author Eenae
1083  */
1084 contract ICrowdsaleStat {
1085 
1086     /// @notice amount of funds collected in wei
1087     function getWeiCollected() public constant returns (uint);
1088 
1089     /// @notice amount of tokens minted (NOT equal to totalSupply() in case token is reused!)
1090     function getTokenMinted() public constant returns (uint);
1091 }
1092 
1093 /**
1094  * @title Interface for code which processes and stores investments.
1095  * @author Eenae
1096  */
1097 contract IInvestmentsWalletConnector {
1098     /// @dev process and forward investment
1099     function storeInvestment(address investor, uint payment) internal;
1100 
1101     /// @dev total investments amount stored using storeInvestment()
1102     function getTotalInvestmentsStored() internal constant returns (uint);
1103 
1104     /// @dev called in case crowdsale succeeded
1105     function wcOnCrowdsaleSuccess() internal;
1106 
1107     /// @dev called in case crowdsale failed
1108     function wcOnCrowdsaleFailure() internal;
1109 }
1110 
1111 
1112 /// @title Base contract for simple crowdsales
1113 contract SimpleCrowdsaleBase is ArgumentsChecker, ReentrancyGuard, IInvestmentsWalletConnector, ICrowdsaleStat {
1114     using SafeMath for uint256;
1115 
1116     event FundTransfer(address backer, uint amount, bool isContribution);
1117 
1118     function SimpleCrowdsaleBase(address token)
1119     validAddress(token)
1120     {
1121         m_token = MintableToken(token);
1122     }
1123 
1124 
1125     // PUBLIC interface: payments
1126 
1127     // fallback function as a shortcut
1128     function() payable {
1129         require(0 == msg.data.length);
1130         buy();  // only internal call here!
1131     }
1132 
1133     /// @notice crowdsale participation
1134     function buy() public payable {     // dont mark as external!
1135         buyInternal(msg.sender, msg.value, 0);
1136     }
1137 
1138 
1139     // INTERNAL
1140 
1141     /// @dev payment processing
1142     function buyInternal(address investor, uint payment, uint extraBonuses)
1143     internal
1144     nonReentrant
1145     {
1146         require(payment >= getMinInvestment());
1147         require(getCurrentTime() >= getStartTime() || ! mustApplyTimeCheck(investor, payment) /* for final check */);
1148         if (getCurrentTime() >= getEndTime()) {
1149 
1150             finish();
1151         }
1152 
1153         if (m_finished) {
1154             // saving provided gas
1155             investor.transfer(payment);
1156             return;
1157         }
1158 
1159         uint startingWeiCollected = getWeiCollected();
1160         uint startingInvariant = this.balance.add(startingWeiCollected);
1161 
1162         uint change;
1163         if (hasHardCap()) {
1164             // return or update payment if needed
1165             uint paymentAllowed = getMaximumFunds().sub(getWeiCollected());
1166             assert(0 != paymentAllowed);
1167 
1168             if (paymentAllowed < payment) {
1169                 change = payment.sub(paymentAllowed);
1170                 payment = paymentAllowed;
1171             }
1172         }
1173 
1174         // issue tokens
1175         uint tokens = calculateTokens(investor, payment, extraBonuses);
1176         m_token.mint(investor, tokens);
1177         m_tokensMinted += tokens;
1178 
1179         // record payment
1180         storeInvestment(investor, payment);
1181         assert((!hasHardCap() || getWeiCollected() <= getMaximumFunds()) && getWeiCollected() > startingWeiCollected);
1182         FundTransfer(investor, payment, true);
1183 
1184         if (hasHardCap() && getWeiCollected() == getMaximumFunds())
1185         finish();
1186 
1187         if (change > 0)
1188         investor.transfer(change);
1189 
1190         assert(startingInvariant == this.balance.add(getWeiCollected()).add(change));
1191     }
1192 
1193     function finish() internal {
1194         if (m_finished)
1195         return;
1196 
1197         if (getWeiCollected() >= getMinimumFunds())
1198         wcOnCrowdsaleSuccess();
1199         else
1200         wcOnCrowdsaleFailure();
1201 
1202         m_finished = true;
1203     }
1204 
1205 
1206     // Other pluggables
1207 
1208     /// @dev says if crowdsale time bounds must be checked
1209     function mustApplyTimeCheck(address /*investor*/, uint /*payment*/) constant internal returns (bool) {
1210         return true;
1211     }
1212 
1213     /// @notice whether to apply hard cap check logic via getMaximumFunds() method
1214     function hasHardCap() constant internal returns (bool) {
1215         return getMaximumFunds() != 0;
1216     }
1217 
1218     /// @dev to be overridden in tests
1219     function getCurrentTime() internal constant returns (uint) {
1220         return now;
1221     }
1222 
1223     /// @notice maximum investments to be accepted during pre-ICO
1224     function getMaximumFunds() internal constant returns (uint);
1225 
1226     /// @notice minimum amount of funding to consider crowdsale as successful
1227     function getMinimumFunds() internal constant returns (uint);
1228 
1229     /// @notice start time of the pre-ICO
1230     function getStartTime() internal constant returns (uint);
1231 
1232     /// @notice end time of the pre-ICO
1233     function getEndTime() internal constant returns (uint);
1234 
1235     /// @notice minimal amount of investment
1236     function getMinInvestment() public constant returns (uint) {
1237         return 10 finney;
1238     }
1239 
1240     /// @dev calculates token amount for given investment
1241     function calculateTokens(address investor, uint payment, uint extraBonuses) internal constant returns (uint);
1242 
1243 
1244     // ICrowdsaleStat
1245 
1246     function getWeiCollected() public constant returns (uint) {
1247         return getTotalInvestmentsStored();
1248     }
1249 
1250     /// @notice amount of tokens minted (NOT equal to totalSupply() in case token is reused!)
1251     function getTokenMinted() public constant returns (uint) {
1252         return m_tokensMinted;
1253     }
1254 
1255 
1256     // FIELDS
1257 
1258     /// @dev contract responsible for token accounting
1259     MintableToken public m_token;
1260 
1261     uint m_tokensMinted;
1262 
1263     bool m_finished = false;
1264 }
1265 
1266 
1267 /// @title Stateful mixin add state to contact and handlers for it
1268 contract SimpleStateful {
1269     enum State { INIT, RUNNING, PAUSED, FAILED, SUCCEEDED }
1270 
1271     event StateChanged(State _state);
1272 
1273     modifier requiresState(State _state) {
1274         require(m_state == _state);
1275         _;
1276     }
1277 
1278     modifier exceptState(State _state) {
1279         require(m_state != _state);
1280         _;
1281     }
1282 
1283     function changeState(State _newState) internal {
1284         assert(m_state != _newState);
1285 
1286         if (State.INIT == m_state) {
1287             assert(State.RUNNING == _newState);
1288         }
1289         else if (State.RUNNING == m_state) {
1290             assert(State.PAUSED == _newState || State.FAILED == _newState || State.SUCCEEDED == _newState);
1291         }
1292         else if (State.PAUSED == m_state) {
1293             assert(State.RUNNING == _newState || State.FAILED == _newState);
1294         }
1295         else assert(false);
1296 
1297         m_state = _newState;
1298         StateChanged(m_state);
1299     }
1300 
1301     function getCurrentState() internal view returns(State) {
1302         return m_state;
1303     }
1304 
1305     /// @dev state of sale
1306     State public m_state = State.INIT;
1307 }
1308 
1309 
1310 
1311 /**
1312  * Stores investments in FundsRegistry.
1313  */
1314 contract MetropolFundsRegistryWalletConnector is IInvestmentsWalletConnector {
1315 
1316     function MetropolFundsRegistryWalletConnector(address _fundsAddress)
1317     public
1318     {
1319         require(_fundsAddress!=address(0));
1320         m_fundsAddress = FundsRegistry(_fundsAddress);
1321     }
1322 
1323     /// @dev process and forward investment
1324     function storeInvestment(address investor, uint payment) internal
1325     {
1326         m_fundsAddress.invested.value(payment)(investor);
1327     }
1328 
1329     /// @dev total investments amount stored using storeInvestment()
1330     function getTotalInvestmentsStored() internal constant returns (uint)
1331     {
1332         return m_fundsAddress.totalInvested();
1333     }
1334 
1335     /// @dev called in case crowdsale succeeded
1336     function wcOnCrowdsaleSuccess() internal {
1337         m_fundsAddress.changeState(FundsRegistry.State.SUCCEEDED);
1338         m_fundsAddress.detachController();
1339     }
1340 
1341     /// @dev called in case crowdsale failed
1342     function wcOnCrowdsaleFailure() internal {
1343         m_fundsAddress.changeState(FundsRegistry.State.REFUNDING);
1344     }
1345 
1346     /// @notice address of wallet which stores funds
1347     FundsRegistry public m_fundsAddress;
1348 }
1349 
1350 
1351 /**
1352  * Crowdsale with state
1353  */
1354 contract StatefulReturnableCrowdsale is
1355 SimpleCrowdsaleBase,
1356 SimpleStateful,
1357 multiowned,
1358 MetropolFundsRegistryWalletConnector
1359 {
1360 
1361     /** Last recorded funds */
1362     uint256 public m_lastFundsAmount;
1363 
1364     event Withdraw(address payee, uint amount);
1365 
1366     /**
1367      * Automatic check for unaccounted withdrawals
1368      * @param _investor optional refund parameter
1369      * @param _payment optional refund parameter
1370      */
1371     modifier fundsChecker(address _investor, uint _payment) {
1372         uint atTheBeginning = getTotalInvestmentsStored();
1373         if (atTheBeginning < m_lastFundsAmount) {
1374             changeState(State.PAUSED);
1375             if (_payment > 0) {
1376                 _investor.transfer(_payment);     // we cant throw (have to save state), so refunding this way
1377             }
1378             // note that execution of further (but not preceding!) modifiers and functions ends here
1379         } else {
1380             _;
1381 
1382             if (getTotalInvestmentsStored() < atTheBeginning) {
1383                 changeState(State.PAUSED);
1384             } else {
1385                 m_lastFundsAmount = getTotalInvestmentsStored();
1386             }
1387         }
1388     }
1389 
1390     /**
1391      * Triggers some state changes based on current time
1392      */
1393     modifier timedStateChange() {
1394         if (getCurrentState() == State.INIT && getCurrentTime() >= getStartTime()) {
1395             changeState(State.RUNNING);
1396         }
1397 
1398         _;
1399     }
1400 
1401 
1402     /**
1403      * Constructor
1404      */
1405     function StatefulReturnableCrowdsale(
1406     address _token,
1407     address _funds,
1408     address[] _owners,
1409     uint _signaturesRequired
1410     )
1411     public
1412     SimpleCrowdsaleBase(_token)
1413     multiowned(_owners, _signaturesRequired)
1414     MetropolFundsRegistryWalletConnector(_funds)
1415     validAddress(_token)
1416     validAddress(_funds)
1417     {
1418     }
1419 
1420     function pauseCrowdsale()
1421     public
1422     onlyowner
1423     requiresState(State.RUNNING)
1424     {
1425         changeState(State.PAUSED);
1426     }
1427     function continueCrowdsale()
1428     public
1429     onlymanyowners(sha3(msg.data))
1430     requiresState(State.PAUSED)
1431     {
1432         changeState(State.RUNNING);
1433 
1434         if (getCurrentTime() >= getEndTime()) {
1435             finish();
1436         }
1437     }
1438     function failCrowdsale()
1439     public
1440     onlymanyowners(sha3(msg.data))
1441     requiresState(State.PAUSED)
1442     {
1443         wcOnCrowdsaleFailure();
1444         m_finished = true;
1445     }
1446 
1447     function withdrawPayments()
1448     public
1449     nonReentrant
1450     requiresState(State.FAILED)
1451     {
1452         Withdraw(msg.sender, m_fundsAddress.m_weiBalances(msg.sender));
1453         m_fundsAddress.withdrawPayments(msg.sender);
1454     }
1455 
1456 
1457     /**
1458      * Additional check of contributing process since we have state
1459      */
1460     function buyInternal(address _investor, uint _payment, uint _extraBonuses)
1461     internal
1462     timedStateChange
1463     exceptState(State.PAUSED)
1464     fundsChecker(_investor, _payment)
1465     {
1466         if (!mustApplyTimeCheck(_investor, _payment)) {
1467             require(State.RUNNING == m_state || State.INIT == m_state);
1468         }
1469         else
1470         {
1471             require(State.RUNNING == m_state);
1472         }
1473 
1474         super.buyInternal(_investor, _payment, _extraBonuses);
1475     }
1476 
1477 
1478     /// @dev called in case crowdsale succeeded
1479     function wcOnCrowdsaleSuccess() internal {
1480         super.wcOnCrowdsaleSuccess();
1481 
1482         changeState(State.SUCCEEDED);
1483     }
1484 
1485     /// @dev called in case crowdsale failed
1486     function wcOnCrowdsaleFailure() internal {
1487         super.wcOnCrowdsaleFailure();
1488 
1489         changeState(State.FAILED);
1490     }
1491 
1492 }
1493 
1494 
1495 /**
1496  * MetropolCrowdsale
1497  */
1498 contract MetropolCrowdsale is StatefulReturnableCrowdsale {
1499 
1500     uint256 public m_startTimestamp;
1501     uint256 public m_softCap;
1502     uint256 public m_hardCap;
1503     uint256 public m_exchangeRate;
1504     address public m_foundersTokensStorage;
1505     bool public m_initialSettingsSet = false;
1506 
1507     modifier requireSettingsSet() {
1508         require(m_initialSettingsSet);
1509         _;
1510     }
1511 
1512     function MetropolCrowdsale(address _token, address _funds, address[] _owners)
1513         public
1514         StatefulReturnableCrowdsale(_token, _funds, _owners, 2)
1515     {
1516         require(3 == _owners.length);
1517 
1518         //2030-01-01, not to start crowdsale
1519         m_startTimestamp = 1893456000;
1520     }
1521 
1522     /**
1523      * Set exchange rate before start
1524      */
1525     function setInitialSettings(
1526             address _foundersTokensStorage,
1527             uint256 _startTimestamp,
1528             uint256 _softCapInEther,
1529             uint256 _hardCapInEther,
1530             uint256 _tokensForOneEther
1531         )
1532         public
1533         timedStateChange
1534         requiresState(State.INIT)
1535         onlymanyowners(sha3(msg.data))
1536         validAddress(_foundersTokensStorage)
1537     {
1538         //no check for settings set
1539         //can be set multiple times before ICO
1540 
1541         require(_startTimestamp!=0);
1542         require(_softCapInEther!=0);
1543         require(_hardCapInEther!=0);
1544         require(_tokensForOneEther!=0);
1545 
1546         m_startTimestamp = _startTimestamp;
1547         m_softCap = _softCapInEther * 1 ether;
1548         m_hardCap = _hardCapInEther * 1 ether;
1549         m_exchangeRate = _tokensForOneEther;
1550         m_foundersTokensStorage = _foundersTokensStorage;
1551 
1552         m_initialSettingsSet = true;
1553     }
1554 
1555     /**
1556      * Set exchange rate before start
1557      */
1558     function setExchangeRate(uint256 _tokensForOneEther)
1559         public
1560         timedStateChange
1561         requiresState(State.INIT)
1562         onlymanyowners(sha3(msg.data))
1563     {
1564         m_exchangeRate = _tokensForOneEther;
1565     }
1566 
1567     /**
1568      * withdraw payments by investor on fail
1569      */
1570     function withdrawPayments() public requireSettingsSet {
1571         getToken().burn(
1572             msg.sender,
1573             getToken().balanceOf(msg.sender)
1574         );
1575 
1576         super.withdrawPayments();
1577     }
1578 
1579 
1580     // INTERNAL
1581     /**
1582      * Additional check of initial settings set
1583      */
1584     function buyInternal(address _investor, uint _payment, uint _extraBonuses)
1585         internal
1586         requireSettingsSet
1587     {
1588         super.buyInternal(_investor, _payment, _extraBonuses);
1589     }
1590 
1591 
1592     /**
1593      * All users except deployer must check time before contributing
1594      */
1595     function mustApplyTimeCheck(address investor, uint payment) constant internal returns (bool) {
1596         return !isOwner(investor);
1597     }
1598 
1599     /**
1600      * For min investment check
1601      */
1602     function getMinInvestment() public constant returns (uint) {
1603         return 1 wei;
1604     }
1605 
1606     /**
1607      * Get collected funds (internally from FundsRegistry)
1608      */
1609     function getWeiCollected() public constant returns (uint) {
1610         return getTotalInvestmentsStored();
1611     }
1612 
1613     /**
1614      * Minimum amount of funding to consider crowdsale as successful
1615      */
1616     function getMinimumFunds() internal constant returns (uint) {
1617         return m_softCap;
1618     }
1619 
1620     /**
1621      * Maximum investments to be accepted during crowdsale
1622      */
1623     function getMaximumFunds() internal constant returns (uint) {
1624         return m_hardCap;
1625     }
1626 
1627     /**
1628      * Start time of the crowdsale
1629      */
1630     function getStartTime() internal constant returns (uint) {
1631         return m_startTimestamp;
1632     }
1633 
1634     /**
1635      * End time of the crowdsale
1636      */
1637     function getEndTime() internal constant returns (uint) {
1638         return m_startTimestamp + 60 days;
1639     }
1640 
1641     /**
1642      * Formula for calculating tokens from contributed ether
1643      */
1644     function calculateTokens(address /*investor*/, uint payment, uint /*extraBonuses*/)
1645         internal
1646         constant
1647         returns (uint)
1648     {
1649         uint256 secondMonth = m_startTimestamp + 30 days;
1650         if (getCurrentTime() <= secondMonth) {
1651             return payment.mul(m_exchangeRate);
1652         } else if (getCurrentTime() <= secondMonth + 1 weeks) {
1653             return payment.mul(m_exchangeRate).mul(100).div(105);
1654         } else if (getCurrentTime() <= secondMonth + 2 weeks) {
1655             return payment.mul(m_exchangeRate).mul(100).div(110);
1656         } else if (getCurrentTime() <= secondMonth + 3 weeks) {
1657             return payment.mul(m_exchangeRate).mul(100).div(115);
1658         } else if (getCurrentTime() <= secondMonth + 4 weeks) {
1659             return payment.mul(m_exchangeRate).mul(100).div(120);
1660         } else {
1661             return payment.mul(m_exchangeRate).mul(100).div(125);
1662         }
1663     }
1664 
1665     /**
1666      * Additional on-success actions
1667      */
1668     function wcOnCrowdsaleSuccess() internal {
1669         super.wcOnCrowdsaleSuccess();
1670 
1671         //20% of total totalSupply to team
1672         m_token.mint(
1673             m_foundersTokensStorage,
1674             getToken().totalSupply().mul(20).div(80)
1675         );
1676 
1677 
1678         getToken().startCirculation();
1679         getToken().detachController();
1680     }
1681 
1682     /**
1683      * Returns attached token
1684      */
1685     function getToken() internal returns(MetropolToken) {
1686         return MetropolToken(m_token);
1687     }
1688 }