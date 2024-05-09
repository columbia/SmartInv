1 pragma solidity 0.4.15;
2 
3 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
4 // TODO acceptOwnership
5 contract multiowned {
6 
7 	// TYPES
8 
9     // struct for the status of a pending operation.
10     struct MultiOwnedOperationPendingState {
11         // count of confirmations needed
12         uint yetNeeded;
13 
14         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
15         uint ownersDone;
16 
17         // position of this operation key in m_multiOwnedPendingIndex
18         uint index;
19     }
20 
21 	// EVENTS
22 
23     event Confirmation(address owner, bytes32 operation);
24     event Revoke(address owner, bytes32 operation);
25     event FinalConfirmation(address owner, bytes32 operation);
26 
27     // some others are in the case of an owner changing.
28     event OwnerChanged(address oldOwner, address newOwner);
29     event OwnerAdded(address newOwner);
30     event OwnerRemoved(address oldOwner);
31 
32     // the last one is emitted if the required signatures change
33     event RequirementChanged(uint newRequirement);
34 
35 	// MODIFIERS
36 
37     // simple single-sig function modifier.
38     modifier onlyowner {
39         require(isOwner(msg.sender));
40         _;
41     }
42     // multi-sig function modifier: the operation must have an intrinsic hash in order
43     // that later attempts can be realised as the same underlying operation and
44     // thus count as confirmations.
45     modifier onlymanyowners(bytes32 _operation) {
46         if (confirmAndCheck(_operation)) {
47             _;
48         }
49         // Even if required number of confirmations has't been collected yet,
50         // we can't throw here - because changes to the state have to be preserved.
51         // But, confirmAndCheck itself will throw in case sender is not an owner.
52     }
53 
54     modifier validNumOwners(uint _numOwners) {
55         require(_numOwners > 0 && _numOwners <= c_maxOwners);
56         _;
57     }
58 
59     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
60         require(_required > 0 && _required <= _numOwners);
61         _;
62     }
63 
64     modifier ownerExists(address _address) {
65         require(isOwner(_address));
66         _;
67     }
68 
69     modifier ownerDoesNotExist(address _address) {
70         require(!isOwner(_address));
71         _;
72     }
73 
74     modifier multiOwnedOperationIsActive(bytes32 _operation) {
75         require(isOperationActive(_operation));
76         _;
77     }
78 
79 	// METHODS
80 
81     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
82     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
83     function multiowned(address[] _owners, uint _required)
84         validNumOwners(_owners.length)
85         multiOwnedValidRequirement(_required, _owners.length)
86     {
87         assert(c_maxOwners <= 255);
88 
89         m_numOwners = _owners.length;
90         m_multiOwnedRequired = _required;
91 
92         for (uint i = 0; i < _owners.length; ++i)
93         {
94             address owner = _owners[i];
95             // invalid and duplicate addresses are not allowed
96             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
97 
98             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
99             m_owners[currentOwnerIndex] = owner;
100             m_ownerIndex[owner] = currentOwnerIndex;
101         }
102 
103         assertOwnersAreConsistent();
104     }
105 
106     // Replaces an owner `_from` with another `_to`.
107     // All pending operations will be canceled!
108     function changeOwner(address _from, address _to)
109         external
110         ownerExists(_from)
111         ownerDoesNotExist(_to)
112         onlymanyowners(sha3(msg.data))
113     {
114         assertOwnersAreConsistent();
115 
116         clearPending();
117         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
118         m_owners[ownerIndex] = _to;
119         m_ownerIndex[_from] = 0;
120         m_ownerIndex[_to] = ownerIndex;
121 
122         assertOwnersAreConsistent();
123         OwnerChanged(_from, _to);
124     }
125 
126     // All pending operations will be canceled!
127     function addOwner(address _owner)
128         external
129         ownerDoesNotExist(_owner)
130         validNumOwners(m_numOwners + 1)
131         onlymanyowners(sha3(msg.data))
132     {
133         assertOwnersAreConsistent();
134 
135         clearPending();
136         m_numOwners++;
137         m_owners[m_numOwners] = _owner;
138         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
139 
140         assertOwnersAreConsistent();
141         OwnerAdded(_owner);
142     }
143 
144     // All pending operations will be canceled!
145     function removeOwner(address _owner)
146         external
147         ownerExists(_owner)
148         validNumOwners(m_numOwners - 1)
149         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
150         onlymanyowners(sha3(msg.data))
151     {
152         assertOwnersAreConsistent();
153 
154         clearPending();
155         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
156         m_owners[ownerIndex] = 0;
157         m_ownerIndex[_owner] = 0;
158         //make sure m_numOwners is equal to the number of owners and always points to the last owner
159         reorganizeOwners();
160 
161         assertOwnersAreConsistent();
162         OwnerRemoved(_owner);
163     }
164 
165     // All pending operations will be canceled!
166     function changeRequirement(uint _newRequired)
167         external
168         multiOwnedValidRequirement(_newRequired, m_numOwners)
169         onlymanyowners(sha3(msg.data))
170     {
171         m_multiOwnedRequired = _newRequired;
172         clearPending();
173         RequirementChanged(_newRequired);
174     }
175 
176     // Gets an owner by 0-indexed position
177     function getOwner(uint ownerIndex) public constant returns (address) {
178         return m_owners[ownerIndex + 1];
179     }
180 
181     function getOwners() public constant returns (address[]) {
182         address[] memory result = new address[](m_numOwners);
183         for (uint i = 0; i < m_numOwners; i++)
184             result[i] = getOwner(i);
185 
186         return result;
187     }
188 
189     function isOwner(address _addr) public constant returns (bool) {
190         return m_ownerIndex[_addr] > 0;
191     }
192 
193     // Tests ownership of the current caller.
194     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
195     // addOwner/changeOwner and to isOwner.
196     function amIOwner() external constant onlyowner returns (bool) {
197         return true;
198     }
199 
200     // Revokes a prior confirmation of the given operation
201     function revoke(bytes32 _operation)
202         external
203         multiOwnedOperationIsActive(_operation)
204         onlyowner
205     {
206         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
207         var pending = m_multiOwnedPending[_operation];
208         require(pending.ownersDone & ownerIndexBit > 0);
209 
210         assertOperationIsConsistent(_operation);
211 
212         pending.yetNeeded++;
213         pending.ownersDone -= ownerIndexBit;
214 
215         assertOperationIsConsistent(_operation);
216         Revoke(msg.sender, _operation);
217     }
218 
219     function hasConfirmed(bytes32 _operation, address _owner)
220         external
221         constant
222         multiOwnedOperationIsActive(_operation)
223         ownerExists(_owner)
224         returns (bool)
225     {
226         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
227     }
228 
229     // INTERNAL METHODS
230 
231     function confirmAndCheck(bytes32 _operation)
232         private
233         onlyowner
234         returns (bool)
235     {
236         if (512 == m_multiOwnedPendingIndex.length)
237             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
238             // we won't be able to do it because of block gas limit.
239             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
240             // TODO use more graceful approach like compact or removal of clearPending completely
241             clearPending();
242 
243         var pending = m_multiOwnedPending[_operation];
244 
245         // if we're not yet working on this operation, switch over and reset the confirmation status.
246         if (! isOperationActive(_operation)) {
247             // reset count of confirmations needed.
248             pending.yetNeeded = m_multiOwnedRequired;
249             // reset which owners have confirmed (none) - set our bitmap to 0.
250             pending.ownersDone = 0;
251             pending.index = m_multiOwnedPendingIndex.length++;
252             m_multiOwnedPendingIndex[pending.index] = _operation;
253             assertOperationIsConsistent(_operation);
254         }
255 
256         // determine the bit to set for this owner.
257         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
258         // make sure we (the message sender) haven't confirmed this operation previously.
259         if (pending.ownersDone & ownerIndexBit == 0) {
260             // ok - check if count is enough to go ahead.
261             assert(pending.yetNeeded > 0);
262             if (pending.yetNeeded == 1) {
263                 // enough confirmations: reset and run interior.
264                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
265                 delete m_multiOwnedPending[_operation];
266                 FinalConfirmation(msg.sender, _operation);
267                 return true;
268             }
269             else
270             {
271                 // not enough: record that this owner in particular confirmed.
272                 pending.yetNeeded--;
273                 pending.ownersDone |= ownerIndexBit;
274                 assertOperationIsConsistent(_operation);
275                 Confirmation(msg.sender, _operation);
276             }
277         }
278     }
279 
280     // Reclaims free slots between valid owners in m_owners.
281     // TODO given that its called after each removal, it could be simplified.
282     function reorganizeOwners() private {
283         uint free = 1;
284         while (free < m_numOwners)
285         {
286             // iterating to the first free slot from the beginning
287             while (free < m_numOwners && m_owners[free] != 0) free++;
288 
289             // iterating to the first occupied slot from the end
290             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
291 
292             // swap, if possible, so free slot is located at the end after the swap
293             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
294             {
295                 // owners between swapped slots should't be renumbered - that saves a lot of gas
296                 m_owners[free] = m_owners[m_numOwners];
297                 m_ownerIndex[m_owners[free]] = free;
298                 m_owners[m_numOwners] = 0;
299             }
300         }
301     }
302 
303     function clearPending() private onlyowner {
304         uint length = m_multiOwnedPendingIndex.length;
305         for (uint i = 0; i < length; ++i) {
306             if (m_multiOwnedPendingIndex[i] != 0)
307                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
308         }
309         delete m_multiOwnedPendingIndex;
310     }
311 
312     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
313         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
314         return ownerIndex;
315     }
316 
317     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
318         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
319         return 2 ** ownerIndex;
320     }
321 
322     function isOperationActive(bytes32 _operation) private constant returns (bool) {
323         return 0 != m_multiOwnedPending[_operation].yetNeeded;
324     }
325 
326 
327     function assertOwnersAreConsistent() private constant {
328         assert(m_numOwners > 0);
329         assert(m_numOwners <= c_maxOwners);
330         assert(m_owners[0] == 0);
331         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
332     }
333 
334     function assertOperationIsConsistent(bytes32 _operation) private constant {
335         var pending = m_multiOwnedPending[_operation];
336         assert(0 != pending.yetNeeded);
337         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
338         assert(pending.yetNeeded <= m_multiOwnedRequired);
339     }
340 
341 
342    	// FIELDS
343 
344     uint constant c_maxOwners = 250;
345 
346     // the number of owners that must confirm the same operation before it is run.
347     uint public m_multiOwnedRequired;
348 
349 
350     // pointer used to find a free slot in m_owners
351     uint public m_numOwners;
352 
353     // list of owners (addresses),
354     // slot 0 is unused so there are no owner which index is 0.
355     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
356     address[256] internal m_owners;
357 
358     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
359     mapping(address => uint) internal m_ownerIndex;
360 
361 
362     // the ongoing operations.
363     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
364     bytes32[] internal m_multiOwnedPendingIndex;
365 }
366 
367 
368 /**
369  * @title Contract which is owned by owners and operated by controller.
370  *
371  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
372  * Controller is set up by owners or during construction.
373  *
374  * @dev controller check is performed by onlyController modifier.
375  */
376 contract MultiownedControlled is multiowned {
377 
378     event ControllerSet(address controller);
379     event ControllerRetired(address was);
380 
381 
382     modifier onlyController {
383         require(msg.sender == m_controller);
384         _;
385     }
386 
387 
388     // PUBLIC interface
389 
390     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
391         multiowned(_owners, _signaturesRequired)
392     {
393         m_controller = _controller;
394         ControllerSet(m_controller);
395     }
396 
397     /// @notice sets the controller
398     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
399         m_controller = _controller;
400         ControllerSet(m_controller);
401     }
402 
403     /// @notice ability for controller to step down
404     function detachController() external onlyController {
405         address was = m_controller;
406         m_controller = address(0);
407         ControllerRetired(was);
408     }
409 
410 
411     // FIELDS
412 
413     /// @notice address of entity entitled to mint new tokens
414     address public m_controller;
415 }
416 
417 /**
418  * @title SafeMath
419  * @dev Math operations with safety checks that throw on error
420  */
421 library SafeMath {
422   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
423     uint256 c = a * b;
424     assert(a == 0 || c / a == b);
425     return c;
426   }
427 
428   function div(uint256 a, uint256 b) internal constant returns (uint256) {
429     // assert(b > 0); // Solidity automatically throws when dividing by 0
430     uint256 c = a / b;
431     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
432     return c;
433   }
434 
435   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
436     assert(b <= a);
437     return a - b;
438   }
439 
440   function add(uint256 a, uint256 b) internal constant returns (uint256) {
441     uint256 c = a + b;
442     assert(c >= a);
443     return c;
444   }
445 }
446 
447 /**
448  * @title Helps contracts guard agains rentrancy attacks.
449  * @author Remco Bloemen <remco@2π.com>
450  * @notice If you mark a function `nonReentrant`, you should also
451  * mark it `external`.
452  */
453 contract ReentrancyGuard {
454 
455   /**
456    * @dev We use a single lock for the whole contract.
457    */
458   bool private rentrancy_lock = false;
459 
460   /**
461    * @dev Prevents a contract from calling itself, directly or indirectly.
462    * @notice If you mark a function `nonReentrant`, you should also
463    * mark it `external`. Calling one nonReentrant function from
464    * another is not supported. Instead, you can implement a
465    * `private` function doing the actual work, and a `external`
466    * wrapper marked as `nonReentrant`.
467    */
468   modifier nonReentrant() {
469     require(!rentrancy_lock);
470     rentrancy_lock = true;
471     _;
472     rentrancy_lock = false;
473   }
474 
475 }
476 
477 
478 
479 /// @title registry of funds sent by investors
480 contract FundsRegistry is MultiownedControlled, ReentrancyGuard {
481     using SafeMath for uint256;
482 
483     enum State {
484         // gathering funds
485         GATHERING,
486         // returning funds to investors
487         REFUNDING,
488         // funds can be pulled by owners
489         SUCCEEDED
490     }
491 
492     event StateChanged(State _state);
493     event Invested(address indexed investor, uint256 amount);
494     event EtherSent(address indexed to, uint value);
495     event RefundSent(address indexed to, uint value);
496 
497 
498     modifier requiresState(State _state) {
499         require(m_state == _state);
500         _;
501     }
502 
503 
504     // PUBLIC interface
505 
506     function FundsRegistry(address[] _owners, uint _signaturesRequired, address _controller)
507         MultiownedControlled(_owners, _signaturesRequired, _controller)
508     {
509     }
510 
511     /// @dev performs only allowed state transitions
512     function changeState(State _newState)
513         external
514         onlyController
515     {
516         assert(m_state != _newState);
517 
518         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
519         else assert(false);
520 
521         m_state = _newState;
522         StateChanged(m_state);
523     }
524 
525     /// @dev records an investment
526     function invested(address _investor)
527         external
528         payable
529         onlyController
530         requiresState(State.GATHERING)
531     {
532         uint256 amount = msg.value;
533         require(0 != amount);
534         assert(_investor != m_controller);
535 
536         // register investor
537         if (0 == m_weiBalances[_investor])
538             m_investors.push(_investor);
539 
540         // register payment
541         totalInvested = totalInvested.add(amount);
542         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
543 
544         Invested(_investor, amount);
545     }
546 
547     /// @dev Send `value` of ether to address `to`
548     function sendEther(address to, uint value)
549         external
550         onlymanyowners(sha3(msg.data))
551         requiresState(State.SUCCEEDED)
552     {
553         require(0 != to);
554         require(value > 0 && this.balance >= value);
555         to.transfer(value);
556         EtherSent(to, value);
557     }
558 
559     /// @notice withdraw accumulated balance, called by payee.
560     function withdrawPayments()
561         external
562         nonReentrant
563         requiresState(State.REFUNDING)
564     {
565         address payee = msg.sender;
566         uint256 payment = m_weiBalances[payee];
567 
568         require(payment != 0);
569         require(this.balance >= payment);
570 
571         totalInvested = totalInvested.sub(payment);
572         m_weiBalances[payee] = 0;
573 
574         payee.transfer(payment);
575         RefundSent(payee, payment);
576     }
577 
578     function getInvestorsCount() external constant returns (uint) { return m_investors.length; }
579 
580 
581     // FIELDS
582 
583     /// @notice total amount of investments in wei
584     uint256 public totalInvested;
585 
586     /// @notice state of the registry
587     State public m_state = State.GATHERING;
588 
589     /// @dev balances of investors in wei
590     mapping(address => uint256) public m_weiBalances;
591 
592     /// @dev list of unique investors
593     address[] public m_investors;
594 }