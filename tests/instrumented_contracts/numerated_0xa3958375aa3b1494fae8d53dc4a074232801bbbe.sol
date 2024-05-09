1 pragma solidity 0.4.15;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title Basic token
19  * @dev Basic version of StandardToken, with no allowances. 
20  */
21 contract BasicToken is ERC20Basic {
22   using SafeMath for uint256;
23 
24   mapping(address => uint256) balances;
25 
26   /**
27   * @dev transfer token for a specified address
28   * @param _to The address to transfer to.
29   * @param _value The amount to be transferred.
30   */
31   function transfer(address _to, uint256 _value) returns (bool) {
32     balances[msg.sender] = balances[msg.sender].sub(_value);
33     balances[_to] = balances[_to].add(_value);
34     Transfer(msg.sender, _to, _value);
35     return true;
36   }
37 
38   /**
39   * @dev Gets the balance of the specified address.
40   * @param _owner The address to query the the balance of. 
41   * @return An uint256 representing the amount owned by the passed address.
42   */
43   function balanceOf(address _owner) constant returns (uint256 balance) {
44     return balances[_owner];
45   }
46 
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) constant returns (uint256);
55   function transferFrom(address from, address to, uint256 value) returns (bool);
56   function approve(address spender, uint256 value) returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 
61 
62 /**
63  * @title Standard ERC20 token
64  *
65  * @dev Implementation of the basic standard token.
66  * @dev https://github.com/ethereum/EIPs/issues/20
67  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
68  */
69 contract StandardToken is ERC20, BasicToken {
70 
71   mapping (address => mapping (address => uint256)) allowed;
72 
73 
74   /**
75    * @dev Transfer tokens from one address to another
76    * @param _from address The address which you want to send tokens from
77    * @param _to address The address which you want to transfer to
78    * @param _value uint256 the amout of tokens to be transfered
79    */
80   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
81     var _allowance = allowed[_from][msg.sender];
82 
83     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
84     // require (_value <= _allowance);
85 
86     balances[_to] = balances[_to].add(_value);
87     balances[_from] = balances[_from].sub(_value);
88     allowed[_from][msg.sender] = _allowance.sub(_value);
89     Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   /**
94    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
95    * @param _spender The address which will spend the funds.
96    * @param _value The amount of tokens to be spent.
97    */
98   function approve(address _spender, uint256 _value) returns (bool) {
99 
100     // To change the approve amount you first have to reduce the addresses`
101     //  allowance to zero by calling `approve(_spender, 0)` if it is not
102     //  already 0 to mitigate the race condition described here:
103     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
105 
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Function to check the amount of tokens that an owner allowed to a spender.
113    * @param _owner address The address which owns the funds.
114    * @param _spender address The address which will spend the funds.
115    * @return A uint256 specifing the amount of tokens still avaible for the spender.
116    */
117   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118     return allowed[_owner][_spender];
119   }
120 
121 }
122 
123 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
124 // TODO acceptOwnership
125 contract multiowned {
126 
127 	// TYPES
128 
129     // struct for the status of a pending operation.
130     struct MultiOwnedOperationPendingState {
131         // count of confirmations needed
132         uint yetNeeded;
133 
134         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
135         uint ownersDone;
136 
137         // position of this operation key in m_multiOwnedPendingIndex
138         uint index;
139     }
140 
141 	// EVENTS
142 
143     event Confirmation(address owner, bytes32 operation);
144     event Revoke(address owner, bytes32 operation);
145     event FinalConfirmation(address owner, bytes32 operation);
146 
147     // some others are in the case of an owner changing.
148     event OwnerChanged(address oldOwner, address newOwner);
149     event OwnerAdded(address newOwner);
150     event OwnerRemoved(address oldOwner);
151 
152     // the last one is emitted if the required signatures change
153     event RequirementChanged(uint newRequirement);
154 
155 	// MODIFIERS
156 
157     // simple single-sig function modifier.
158     modifier onlyowner {
159         require(isOwner(msg.sender));
160         _;
161     }
162     // multi-sig function modifier: the operation must have an intrinsic hash in order
163     // that later attempts can be realised as the same underlying operation and
164     // thus count as confirmations.
165     modifier onlymanyowners(bytes32 _operation) {
166         if (confirmAndCheck(_operation)) {
167             _;
168         }
169         // Even if required number of confirmations has't been collected yet,
170         // we can't throw here - because changes to the state have to be preserved.
171         // But, confirmAndCheck itself will throw in case sender is not an owner.
172     }
173 
174     modifier validNumOwners(uint _numOwners) {
175         require(_numOwners > 0 && _numOwners <= c_maxOwners);
176         _;
177     }
178 
179     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
180         require(_required > 0 && _required <= _numOwners);
181         _;
182     }
183 
184     modifier ownerExists(address _address) {
185         require(isOwner(_address));
186         _;
187     }
188 
189     modifier ownerDoesNotExist(address _address) {
190         require(!isOwner(_address));
191         _;
192     }
193 
194     modifier multiOwnedOperationIsActive(bytes32 _operation) {
195         require(isOperationActive(_operation));
196         _;
197     }
198 
199 	// METHODS
200 
201     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
202     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
203     function multiowned(address[] _owners, uint _required)
204         validNumOwners(_owners.length)
205         multiOwnedValidRequirement(_required, _owners.length)
206     {
207         assert(c_maxOwners <= 255);
208 
209         m_numOwners = _owners.length;
210         m_multiOwnedRequired = _required;
211 
212         for (uint i = 0; i < _owners.length; ++i)
213         {
214             address owner = _owners[i];
215             // invalid and duplicate addresses are not allowed
216             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
217 
218             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
219             m_owners[currentOwnerIndex] = owner;
220             m_ownerIndex[owner] = currentOwnerIndex;
221         }
222 
223         assertOwnersAreConsistent();
224     }
225 
226     /// @notice replaces an owner `_from` with another `_to`.
227     /// @param _from address of owner to replace
228     /// @param _to address of new owner
229     // All pending operations will be canceled!
230     function changeOwner(address _from, address _to)
231         external
232         ownerExists(_from)
233         ownerDoesNotExist(_to)
234         onlymanyowners(sha3(msg.data))
235     {
236         assertOwnersAreConsistent();
237 
238         clearPending();
239         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
240         m_owners[ownerIndex] = _to;
241         m_ownerIndex[_from] = 0;
242         m_ownerIndex[_to] = ownerIndex;
243 
244         assertOwnersAreConsistent();
245         OwnerChanged(_from, _to);
246     }
247 
248     /// @notice adds an owner
249     /// @param _owner address of new owner
250     // All pending operations will be canceled!
251     function addOwner(address _owner)
252         external
253         ownerDoesNotExist(_owner)
254         validNumOwners(m_numOwners + 1)
255         onlymanyowners(sha3(msg.data))
256     {
257         assertOwnersAreConsistent();
258 
259         clearPending();
260         m_numOwners++;
261         m_owners[m_numOwners] = _owner;
262         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
263 
264         assertOwnersAreConsistent();
265         OwnerAdded(_owner);
266     }
267 
268     /// @notice removes an owner
269     /// @param _owner address of owner to remove
270     // All pending operations will be canceled!
271     function removeOwner(address _owner)
272         external
273         ownerExists(_owner)
274         validNumOwners(m_numOwners - 1)
275         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
276         onlymanyowners(sha3(msg.data))
277     {
278         assertOwnersAreConsistent();
279 
280         clearPending();
281         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
282         m_owners[ownerIndex] = 0;
283         m_ownerIndex[_owner] = 0;
284         //make sure m_numOwners is equal to the number of owners and always points to the last owner
285         reorganizeOwners();
286 
287         assertOwnersAreConsistent();
288         OwnerRemoved(_owner);
289     }
290 
291     /// @notice changes the required number of owner signatures
292     /// @param _newRequired new number of signatures required
293     // All pending operations will be canceled!
294     function changeRequirement(uint _newRequired)
295         external
296         multiOwnedValidRequirement(_newRequired, m_numOwners)
297         onlymanyowners(sha3(msg.data))
298     {
299         m_multiOwnedRequired = _newRequired;
300         clearPending();
301         RequirementChanged(_newRequired);
302     }
303 
304     /// @notice Gets an owner by 0-indexed position
305     /// @param ownerIndex 0-indexed owner position
306     function getOwner(uint ownerIndex) public constant returns (address) {
307         return m_owners[ownerIndex + 1];
308     }
309 
310     /// @notice Gets owners
311     /// @return memory array of owners
312     function getOwners() public constant returns (address[]) {
313         address[] memory result = new address[](m_numOwners);
314         for (uint i = 0; i < m_numOwners; i++)
315             result[i] = getOwner(i);
316 
317         return result;
318     }
319 
320     /// @notice checks if provided address is an owner address
321     /// @param _addr address to check
322     /// @return true if it's an owner
323     function isOwner(address _addr) public constant returns (bool) {
324         return m_ownerIndex[_addr] > 0;
325     }
326 
327     /// @notice Tests ownership of the current caller.
328     /// @return true if it's an owner
329     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
330     // addOwner/changeOwner and to isOwner.
331     function amIOwner() external constant onlyowner returns (bool) {
332         return true;
333     }
334 
335     /// @notice Revokes a prior confirmation of the given operation
336     /// @param _operation operation value, typically sha3(msg.data)
337     function revoke(bytes32 _operation)
338         external
339         multiOwnedOperationIsActive(_operation)
340         onlyowner
341     {
342         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
343         var pending = m_multiOwnedPending[_operation];
344         require(pending.ownersDone & ownerIndexBit > 0);
345 
346         assertOperationIsConsistent(_operation);
347 
348         pending.yetNeeded++;
349         pending.ownersDone -= ownerIndexBit;
350 
351         assertOperationIsConsistent(_operation);
352         Revoke(msg.sender, _operation);
353     }
354 
355     /// @notice Checks if owner confirmed given operation
356     /// @param _operation operation value, typically sha3(msg.data)
357     /// @param _owner an owner address
358     function hasConfirmed(bytes32 _operation, address _owner)
359         external
360         constant
361         multiOwnedOperationIsActive(_operation)
362         ownerExists(_owner)
363         returns (bool)
364     {
365         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
366     }
367 
368     // INTERNAL METHODS
369 
370     function confirmAndCheck(bytes32 _operation)
371         private
372         onlyowner
373         returns (bool)
374     {
375         if (512 == m_multiOwnedPendingIndex.length)
376             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
377             // we won't be able to do it because of block gas limit.
378             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
379             // TODO use more graceful approach like compact or removal of clearPending completely
380             clearPending();
381 
382         var pending = m_multiOwnedPending[_operation];
383 
384         // if we're not yet working on this operation, switch over and reset the confirmation status.
385         if (! isOperationActive(_operation)) {
386             // reset count of confirmations needed.
387             pending.yetNeeded = m_multiOwnedRequired;
388             // reset which owners have confirmed (none) - set our bitmap to 0.
389             pending.ownersDone = 0;
390             pending.index = m_multiOwnedPendingIndex.length++;
391             m_multiOwnedPendingIndex[pending.index] = _operation;
392             assertOperationIsConsistent(_operation);
393         }
394 
395         // determine the bit to set for this owner.
396         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
397         // make sure we (the message sender) haven't confirmed this operation previously.
398         if (pending.ownersDone & ownerIndexBit == 0) {
399             // ok - check if count is enough to go ahead.
400             assert(pending.yetNeeded > 0);
401             if (pending.yetNeeded == 1) {
402                 // enough confirmations: reset and run interior.
403                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
404                 delete m_multiOwnedPending[_operation];
405                 FinalConfirmation(msg.sender, _operation);
406                 return true;
407             }
408             else
409             {
410                 // not enough: record that this owner in particular confirmed.
411                 pending.yetNeeded--;
412                 pending.ownersDone |= ownerIndexBit;
413                 assertOperationIsConsistent(_operation);
414                 Confirmation(msg.sender, _operation);
415             }
416         }
417     }
418 
419     // Reclaims free slots between valid owners in m_owners.
420     // TODO given that its called after each removal, it could be simplified.
421     function reorganizeOwners() private {
422         uint free = 1;
423         while (free < m_numOwners)
424         {
425             // iterating to the first free slot from the beginning
426             while (free < m_numOwners && m_owners[free] != 0) free++;
427 
428             // iterating to the first occupied slot from the end
429             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
430 
431             // swap, if possible, so free slot is located at the end after the swap
432             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
433             {
434                 // owners between swapped slots should't be renumbered - that saves a lot of gas
435                 m_owners[free] = m_owners[m_numOwners];
436                 m_ownerIndex[m_owners[free]] = free;
437                 m_owners[m_numOwners] = 0;
438             }
439         }
440     }
441 
442     function clearPending() private onlyowner {
443         uint length = m_multiOwnedPendingIndex.length;
444         for (uint i = 0; i < length; ++i) {
445             if (m_multiOwnedPendingIndex[i] != 0)
446                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
447         }
448         delete m_multiOwnedPendingIndex;
449     }
450 
451     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
452         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
453         return ownerIndex;
454     }
455 
456     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
457         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
458         return 2 ** ownerIndex;
459     }
460 
461     function isOperationActive(bytes32 _operation) private constant returns (bool) {
462         return 0 != m_multiOwnedPending[_operation].yetNeeded;
463     }
464 
465 
466     function assertOwnersAreConsistent() private constant {
467         assert(m_numOwners > 0);
468         assert(m_numOwners <= c_maxOwners);
469         assert(m_owners[0] == 0);
470         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
471     }
472 
473     function assertOperationIsConsistent(bytes32 _operation) private constant {
474         var pending = m_multiOwnedPending[_operation];
475         assert(0 != pending.yetNeeded);
476         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
477         assert(pending.yetNeeded <= m_multiOwnedRequired);
478     }
479 
480 
481    	// FIELDS
482 
483     uint constant c_maxOwners = 250;
484 
485     // the number of owners that must confirm the same operation before it is run.
486     uint public m_multiOwnedRequired;
487 
488 
489     // pointer used to find a free slot in m_owners
490     uint public m_numOwners;
491 
492     // list of owners (addresses),
493     // slot 0 is unused so there are no owner which index is 0.
494     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
495     address[256] internal m_owners;
496 
497     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
498     mapping(address => uint) internal m_ownerIndex;
499 
500 
501     // the ongoing operations.
502     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
503     bytes32[] internal m_multiOwnedPendingIndex;
504 }
505 
506 
507 /**
508  * @title Contract which is owned by owners and operated by controller.
509  *
510  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
511  * Controller is set up by owners or during construction.
512  *
513  * @dev controller check is performed by onlyController modifier.
514  */
515 contract MultiownedControlled is multiowned {
516 
517     event ControllerSet(address controller);
518     event ControllerRetired(address was);
519 
520 
521     modifier onlyController {
522         require(msg.sender == m_controller);
523         _;
524     }
525 
526 
527     // PUBLIC interface
528 
529     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
530         multiowned(_owners, _signaturesRequired)
531     {
532         m_controller = _controller;
533         ControllerSet(m_controller);
534     }
535 
536     /// @dev sets the controller
537     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
538         m_controller = _controller;
539         ControllerSet(m_controller);
540     }
541 
542     /// @dev ability for controller to step down
543     function detachController() external onlyController {
544         address was = m_controller;
545         m_controller = address(0);
546         ControllerRetired(was);
547     }
548 
549 
550     // FIELDS
551 
552     /// @notice address of entity entitled to mint new tokens
553     address public m_controller;
554 }
555 
556 
557 /// @title StandardToken which can be minted by another contract.
558 contract MintableMultiownedToken is MultiownedControlled, StandardToken {
559 
560     /// @dev parameters of an extra token emission
561     struct EmissionInfo {
562         // tokens created
563         uint256 created;
564 
565         // totalSupply at the moment of emission (excluding created tokens)
566         uint256 totalSupplyWas;
567     }
568 
569     event Mint(address indexed to, uint256 amount);
570     event Emission(uint256 tokensCreated, uint256 totalSupplyWas, uint256 time);
571     event Dividend(address indexed to, uint256 amount);
572 
573 
574     // PUBLIC interface
575 
576     function MintableMultiownedToken(address[] _owners, uint _signaturesRequired, address _minter)
577         MultiownedControlled(_owners, _signaturesRequired, _minter)
578     {
579         dividendsPool = this;   // or any other special unforgeable value, actually
580 
581         // emission #0 is a dummy: because of default value 0 in m_lastAccountEmission
582         m_emissions.push(EmissionInfo({created: 0, totalSupplyWas: 0}));
583     }
584 
585     /// @notice Request dividends for current account.
586     function requestDividends() external {
587         payDividendsTo(msg.sender);
588     }
589 
590     /// @notice hook on standard ERC20#transfer to pay dividends
591     function transfer(address _to, uint256 _value) returns (bool) {
592         payDividendsTo(msg.sender);
593         payDividendsTo(_to);
594         return super.transfer(_to, _value);
595     }
596 
597     /// @notice hook on standard ERC20#transferFrom to pay dividends
598     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
599         payDividendsTo(_from);
600         payDividendsTo(_to);
601         return super.transferFrom(_from, _to, _value);
602     }
603 
604     // Disabled: this could be undesirable because sum of (balanceOf() for each token owner) != totalSupply
605     // (but: sum of (balances[owner] for each token owner) == totalSupply!).
606     //
607     // @notice hook on standard ERC20#balanceOf to take dividends into consideration
608     // function balanceOf(address _owner) constant returns (uint256) {
609     //     var (hasNewDividends, dividends) = calculateDividendsFor(_owner);
610     //     return hasNewDividends ? super.balanceOf(_owner).add(dividends) : super.balanceOf(_owner);
611     // }
612 
613 
614     /// @dev mints new tokens
615     function mint(address _to, uint256 _amount) external onlyController {
616         require(m_externalMintingEnabled);
617         payDividendsTo(_to);
618         mintInternal(_to, _amount);
619     }
620 
621     /// @dev disables mint(), irreversible!
622     function disableMinting() external onlyController {
623         require(m_externalMintingEnabled);
624         m_externalMintingEnabled = false;
625     }
626 
627 
628     // INTERNAL functions
629 
630     /**
631      * @notice Starts new token emission
632      * @param _tokensCreated Amount of tokens to create
633      * @dev Dividends are not distributed immediately as it could require billions of gas,
634      * instead they are `pulled` by a holder from dividends pool account before any update to the holder account occurs.
635      */
636     function emissionInternal(uint256 _tokensCreated) internal {
637         require(0 != _tokensCreated);
638         require(_tokensCreated < totalSupply / 2);  // otherwise it looks like an error
639 
640         uint256 totalSupplyWas = totalSupply;
641 
642         m_emissions.push(EmissionInfo({created: _tokensCreated, totalSupplyWas: totalSupplyWas}));
643         mintInternal(dividendsPool, _tokensCreated);
644 
645         Emission(_tokensCreated, totalSupplyWas, now);
646     }
647 
648     function mintInternal(address _to, uint256 _amount) internal {
649         totalSupply = totalSupply.add(_amount);
650         balances[_to] = balances[_to].add(_amount);
651         Transfer(this, _to, _amount);
652         Mint(_to, _amount);
653     }
654 
655     /// @dev adds dividends to the account _to
656     function payDividendsTo(address _to) internal {
657         var (hasNewDividends, dividends) = calculateDividendsFor(_to);
658         if (!hasNewDividends)
659             return;
660 
661         if (0 != dividends) {
662             balances[dividendsPool] = balances[dividendsPool].sub(dividends);
663             balances[_to] = balances[_to].add(dividends);
664             Transfer(dividendsPool, _to, dividends);
665         }
666         m_lastAccountEmission[_to] = getLastEmissionNum();
667     }
668 
669     /// @dev calculates dividends for the account _for
670     /// @return (true if state has to be updated, dividend amount (could be 0!))
671     function calculateDividendsFor(address _for) constant internal returns (bool hasNewDividends, uint dividends) {
672         assert(_for != dividendsPool);  // no dividends for the pool!
673 
674         uint256 lastEmissionNum = getLastEmissionNum();
675         uint256 lastAccountEmissionNum = m_lastAccountEmission[_for];
676         assert(lastAccountEmissionNum <= lastEmissionNum);
677         if (lastAccountEmissionNum == lastEmissionNum)
678             return (false, 0);
679 
680         uint256 initialBalance = balances[_for];    // beware of recursion!
681         if (0 == initialBalance)
682             return (true, 0);
683 
684         uint256 balance = initialBalance;
685         for (uint256 emissionToProcess = lastAccountEmissionNum + 1; emissionToProcess <= lastEmissionNum; emissionToProcess++) {
686             EmissionInfo storage emission = m_emissions[emissionToProcess];
687             assert(0 != emission.created && 0 != emission.totalSupplyWas);
688 
689             uint256 dividend = balance.mul(emission.created).div(emission.totalSupplyWas);
690             Dividend(_for, dividend);
691 
692             balance = balance.add(dividend);
693         }
694 
695         return (true, balance.sub(initialBalance));
696     }
697 
698     function getLastEmissionNum() private constant returns (uint256) {
699         return m_emissions.length - 1;
700     }
701 
702 
703     // FIELDS
704 
705     /// @notice if this true then token is still externally mintable (but this flag does't affect emissions!)
706     bool public m_externalMintingEnabled = true;
707 
708     /// @dev internal address of dividends in balances mapping.
709     address dividendsPool;
710 
711     /// @notice record of issued dividend emissions
712     EmissionInfo[] public m_emissions;
713 
714     /// @dev for each token holder: last emission (index in m_emissions) which was processed for this holder
715     mapping(address => uint256) m_lastAccountEmission;
716 }
717 
718 /// @title utility methods and modifiers of arguments validation
719 contract ArgumentsChecker {
720 
721     /// @dev check which prevents short address attack
722     modifier payloadSizeIs(uint size) {
723        require(msg.data.length == size + 4 /* function selector */);
724        _;
725     }
726 
727     /// @dev check that address is valid
728     modifier validAddress(address addr) {
729         require(addr != address(0));
730         _;
731     }
732 }
733 
734 
735 /**
736  * @title Interface for code which processes and stores investments.
737  * @author Eenae
738  */
739 contract IInvestmentsWalletConnector {
740     /// @dev process and forward investment
741     function storeInvestment(address investor, uint payment) internal;
742 
743     /// @dev total investments amount stored using storeInvestment()
744     function getTotalInvestmentsStored() internal constant returns (uint);
745 
746     /// @dev called in case crowdsale succeeded
747     function wcOnCrowdsaleSuccess() internal;
748 
749     /// @dev called in case crowdsale failed
750     function wcOnCrowdsaleFailure() internal;
751 }
752 
753 /**
754  * @title Stores investments in specified external account.
755  * @author Eenae
756  */
757 contract ExternalAccountWalletConnector is ArgumentsChecker, IInvestmentsWalletConnector {
758 
759     function ExternalAccountWalletConnector(address accountAddress)
760         validAddress(accountAddress)
761     {
762         m_walletAddress = accountAddress;
763     }
764 
765     /// @dev process and forward investment
766     function storeInvestment(address /*investor*/, uint payment) internal
767     {
768         m_wcStored += payment;
769         m_walletAddress.transfer(payment);
770     }
771 
772     /// @dev total investments amount stored using storeInvestment()
773     function getTotalInvestmentsStored() internal constant returns (uint)
774     {
775         return m_wcStored;
776     }
777 
778     /// @dev called in case crowdsale succeeded
779     function wcOnCrowdsaleSuccess() internal {
780     }
781 
782     /// @dev called in case crowdsale failed
783     function wcOnCrowdsaleFailure() internal {
784     }
785 
786     /// @notice address of wallet which stores funds
787     address public m_walletAddress;
788 
789     /// @notice total investments stored to wallet
790     uint public m_wcStored;
791 }
792 
793 
794 /**
795  * @title SafeMath
796  * @dev Math operations with safety checks that throw on error
797  */
798 library SafeMath {
799   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
800     uint256 c = a * b;
801     assert(a == 0 || c / a == b);
802     return c;
803   }
804 
805   function div(uint256 a, uint256 b) internal constant returns (uint256) {
806     // assert(b > 0); // Solidity automatically throws when dividing by 0
807     uint256 c = a / b;
808     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
809     return c;
810   }
811 
812   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
813     assert(b <= a);
814     return a - b;
815   }
816 
817   function add(uint256 a, uint256 b) internal constant returns (uint256) {
818     uint256 c = a + b;
819     assert(c >= a);
820     return c;
821   }
822 }
823 
824 
825 /*
826  * @title This is proxy for analytics. Target contract can be found at field m_analytics (see "read contract").
827  * @author Eenae
828 
829  * FIXME after fix of truffle issue #560: refactor to a separate contract file which uses InvestmentAnalytics interface
830  */
831 contract AnalyticProxy {
832 
833     function AnalyticProxy() {
834         m_analytics = InvestmentAnalytics(msg.sender);
835     }
836 
837     /// @notice forward payment to analytics-capable contract
838     function() payable {
839         m_analytics.iaInvestedBy.value(msg.value)(msg.sender);
840     }
841 
842     InvestmentAnalytics public m_analytics;
843 }
844 
845 
846 /*
847  * @title Mixin contract which supports different payment channels and provides analytical per-channel data.
848  * @author Eenae
849  */
850 contract InvestmentAnalytics {
851     using SafeMath for uint256;
852 
853     function InvestmentAnalytics(){
854     }
855 
856     /// @dev creates more payment channels, up to the limit but not exceeding gas stipend
857     function createMorePaymentChannelsInternal(uint limit) internal returns (uint) {
858         uint paymentChannelsCreated;
859         for (uint i = 0; i < limit; i++) {
860             uint startingGas = msg.gas;
861             /*
862              * ~170k of gas per paymentChannel,
863              * using gas price = 4Gwei 2k paymentChannels will cost ~1.4 ETH.
864              */
865 
866             address paymentChannel = new AnalyticProxy();
867             m_validPaymentChannels[paymentChannel] = true;
868             m_paymentChannels.push(paymentChannel);
869             paymentChannelsCreated++;
870 
871             // cost of creating one channel
872             uint gasPerChannel = startingGas.sub(msg.gas);
873             if (gasPerChannel.add(50000) > msg.gas)
874                 break;  // enough proxies for this call
875         }
876         return paymentChannelsCreated;
877     }
878 
879 
880     /// @dev process payments - record analytics and pass control to iaOnInvested callback
881     function iaInvestedBy(address investor) external payable {
882         address paymentChannel = msg.sender;
883         if (m_validPaymentChannels[paymentChannel]) {
884             // payment received by one of our channels
885             uint value = msg.value;
886             m_investmentsByPaymentChannel[paymentChannel] = m_investmentsByPaymentChannel[paymentChannel].add(value);
887             // We know for sure that investment came from specified investor (see AnalyticProxy).
888             iaOnInvested(investor, value, true);
889         } else {
890             // Looks like some user has paid to this method, this payment is not included in the analytics,
891             // but, of course, processed.
892             iaOnInvested(msg.sender, msg.value, false);
893         }
894     }
895 
896     /// @dev callback
897     function iaOnInvested(address /*investor*/, uint /*payment*/, bool /*usingPaymentChannel*/) internal {
898     }
899 
900 
901     function paymentChannelsCount() external constant returns (uint) {
902         return m_paymentChannels.length;
903     }
904 
905     function readAnalyticsMap() external constant returns (address[], uint[]) {
906         address[] memory keys = new address[](m_paymentChannels.length);
907         uint[] memory values = new uint[](m_paymentChannels.length);
908 
909         for (uint i = 0; i < m_paymentChannels.length; i++) {
910             address key = m_paymentChannels[i];
911             keys[i] = key;
912             values[i] = m_investmentsByPaymentChannel[key];
913         }
914 
915         return (keys, values);
916     }
917 
918     function readPaymentChannels() external constant returns (address[]) {
919         return m_paymentChannels;
920     }
921 
922 
923     mapping(address => uint256) public m_investmentsByPaymentChannel;
924     mapping(address => bool) m_validPaymentChannels;
925 
926     address[] public m_paymentChannels;
927 }
928 
929 
930 /**
931  * @title Ownable
932  * @dev The Ownable contract has an owner address, and provides basic authorization control
933  * functions, this simplifies the implementation of "user permissions".
934  */
935 contract Ownable {
936   address public owner;
937 
938 
939   /**
940    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
941    * account.
942    */
943   function Ownable() {
944     owner = msg.sender;
945   }
946 
947 
948   /**
949    * @dev Throws if called by any account other than the owner.
950    */
951   modifier onlyOwner() {
952     require(msg.sender == owner);
953     _;
954   }
955 
956 
957   /**
958    * @dev Allows the current owner to transfer control of the contract to a newOwner.
959    * @param newOwner The address to transfer ownership to.
960    */
961   function transferOwnership(address newOwner) onlyOwner {
962     if (newOwner != address(0)) {
963       owner = newOwner;
964     }
965   }
966 
967 }
968 
969 
970 /**
971  * @title Basic crowdsale stat
972  * @author Eenae
973  */
974 contract ICrowdsaleStat {
975 
976     /// @notice amount of funds collected in wei
977     function getWeiCollected() public constant returns (uint);
978 
979     /// @notice amount of tokens minted (NOT equal to totalSupply() in case token is reused!)
980     function getTokenMinted() public constant returns (uint);
981 }
982 
983 
984 
985 
986 
987 
988 /**
989  * @title Helps contracts guard agains rentrancy attacks.
990  * @author Remco Bloemen <remco@2π.com>
991  * @notice If you mark a function `nonReentrant`, you should also
992  * mark it `external`.
993  */
994 contract ReentrancyGuard {
995 
996   /**
997    * @dev We use a single lock for the whole contract.
998    */
999   bool private rentrancy_lock = false;
1000 
1001   /**
1002    * @dev Prevents a contract from calling itself, directly or indirectly.
1003    * @notice If you mark a function `nonReentrant`, you should also
1004    * mark it `external`. Calling one nonReentrant function from
1005    * another is not supported. Instead, you can implement a
1006    * `private` function doing the actual work, and a `external`
1007    * wrapper marked as `nonReentrant`.
1008    */
1009   modifier nonReentrant() {
1010     require(!rentrancy_lock);
1011     rentrancy_lock = true;
1012     _;
1013     rentrancy_lock = false;
1014   }
1015 
1016 }
1017 
1018 
1019 
1020 
1021 
1022 /// @title Base contract for simple crowdsales
1023 contract SimpleCrowdsaleBase is ArgumentsChecker, ReentrancyGuard, IInvestmentsWalletConnector, ICrowdsaleStat {
1024     using SafeMath for uint256;
1025 
1026     event FundTransfer(address backer, uint amount, bool isContribution);
1027 
1028     function SimpleCrowdsaleBase(address token)
1029         validAddress(token)
1030     {
1031         m_token = MintableMultiownedToken(token);
1032     }
1033 
1034 
1035     // PUBLIC interface: payments
1036 
1037     // fallback function as a shortcut
1038     function() payable {
1039         require(0 == msg.data.length);
1040         buy();  // only internal call here!
1041     }
1042 
1043     /// @notice crowdsale participation
1044     function buy() public payable {     // dont mark as external!
1045         buyInternal(msg.sender, msg.value, 0);
1046     }
1047 
1048 
1049     // INTERNAL
1050 
1051     /// @dev payment processing
1052     function buyInternal(address investor, uint payment, uint extraBonuses)
1053         internal
1054         nonReentrant
1055     {
1056         require(payment >= getMinInvestment());
1057         require(getCurrentTime() >= getStartTime() || ! mustApplyTimeCheck(investor, payment) /* for final check */);
1058         if (getCurrentTime() >= getEndTime())
1059             finish();
1060 
1061         if (m_finished) {
1062             // saving provided gas
1063             investor.transfer(payment);
1064             return;
1065         }
1066 
1067         uint startingWeiCollected = getWeiCollected();
1068         uint startingInvariant = this.balance.add(startingWeiCollected);
1069 
1070         // return or update payment if needed
1071         uint paymentAllowed = getMaximumFunds().sub(getWeiCollected());
1072         assert(0 != paymentAllowed);
1073 
1074         uint change;
1075         if (paymentAllowed < payment) {
1076             change = payment.sub(paymentAllowed);
1077             payment = paymentAllowed;
1078         }
1079 
1080         // issue tokens
1081         uint tokens = calculateTokens(investor, payment, extraBonuses);
1082         m_token.mint(investor, tokens);
1083         m_tokensMinted += tokens;
1084 
1085         // record payment
1086         storeInvestment(investor, payment);
1087         assert(getWeiCollected() <= getMaximumFunds() && getWeiCollected() > startingWeiCollected);
1088         FundTransfer(investor, payment, true);
1089 
1090         if (getWeiCollected() == getMaximumFunds())
1091             finish();
1092 
1093         if (change > 0)
1094             investor.transfer(change);
1095 
1096         assert(startingInvariant == this.balance.add(getWeiCollected()).add(change));
1097     }
1098 
1099     function finish() internal {
1100         if (m_finished)
1101             return;
1102 
1103         if (getWeiCollected() >= getMinimumFunds())
1104             wcOnCrowdsaleSuccess();
1105         else
1106             wcOnCrowdsaleFailure();
1107 
1108         m_finished = true;
1109     }
1110 
1111 
1112     // Other pluggables
1113 
1114     /// @dev says if crowdsale time bounds must be checked
1115     function mustApplyTimeCheck(address /*investor*/, uint /*payment*/) constant internal returns (bool) {
1116         return true;
1117     }
1118 
1119     /// @dev to be overridden in tests
1120     function getCurrentTime() internal constant returns (uint) {
1121         return now;
1122     }
1123 
1124     /// @notice maximum investments to be accepted during pre-ICO
1125     function getMaximumFunds() internal constant returns (uint);
1126 
1127     /// @notice minimum amount of funding to consider crowdsale as successful
1128     function getMinimumFunds() internal constant returns (uint);
1129 
1130     /// @notice start time of the pre-ICO
1131     function getStartTime() internal constant returns (uint);
1132 
1133     /// @notice end time of the pre-ICO
1134     function getEndTime() internal constant returns (uint);
1135 
1136     /// @notice minimal amount of investment
1137     function getMinInvestment() public constant returns (uint) {
1138         return 10 finney;
1139     }
1140 
1141     /// @dev calculates token amount for given investment
1142     function calculateTokens(address investor, uint payment, uint extraBonuses) internal constant returns (uint);
1143 
1144 
1145     // ICrowdsaleStat
1146 
1147     function getWeiCollected() public constant returns (uint) {
1148         return getTotalInvestmentsStored();
1149     }
1150 
1151     /// @notice amount of tokens minted (NOT equal to totalSupply() in case token is reused!)
1152     function getTokenMinted() public constant returns (uint) {
1153         return m_tokensMinted;
1154     }
1155 
1156 
1157     // FIELDS
1158 
1159     /// @dev contract responsible for token accounting
1160     MintableMultiownedToken public m_token;
1161 
1162     uint m_tokensMinted;
1163 
1164     bool m_finished = false;
1165 }
1166 
1167 
1168 
1169 /// @title Base contract for Storiqa pre-ICO
1170 contract STQPreICOBase is SimpleCrowdsaleBase, Ownable, InvestmentAnalytics {
1171 
1172     function STQPreICOBase(address token)
1173         SimpleCrowdsaleBase(token)
1174     {
1175     }
1176 
1177 
1178     // PUBLIC interface: maintenance
1179 
1180     function createMorePaymentChannels(uint limit) external onlyOwner returns (uint) {
1181         return createMorePaymentChannelsInternal(limit);
1182     }
1183 
1184     /// @notice Tests ownership of the current caller.
1185     /// @return true if it's an owner
1186     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
1187     // addOwner/changeOwner and to isOwner.
1188     function amIOwner() external constant onlyOwner returns (bool) {
1189         return true;
1190     }
1191 
1192 
1193     // INTERNAL
1194 
1195     /// @dev payment callback
1196     function iaOnInvested(address investor, uint payment, bool usingPaymentChannel) internal {
1197         buyInternal(investor, payment, usingPaymentChannel ? c_paymentChannelBonusPercent : 0);
1198     }
1199 
1200     function calculateTokens(address /*investor*/, uint payment, uint extraBonuses) internal constant returns (uint) {
1201         uint bonusPercent = getPreICOBonus().add(getLargePaymentBonus(payment)).add(extraBonuses);
1202         uint rate = c_STQperETH.mul(bonusPercent.add(100)).div(100);
1203 
1204         return payment.mul(rate);
1205     }
1206 
1207     function getLargePaymentBonus(uint payment) private constant returns (uint) {
1208         if (payment >= 5000 ether) return 20;
1209         if (payment >= 3000 ether) return 15;
1210         if (payment >= 1000 ether) return 10;
1211         if (payment >= 800 ether) return 8;
1212         if (payment >= 500 ether) return 5;
1213         if (payment >= 200 ether) return 2;
1214         return 0;
1215     }
1216 
1217     function mustApplyTimeCheck(address investor, uint /*payment*/) constant internal returns (bool) {
1218         return investor != owner;
1219     }
1220 
1221     /// @notice pre-ICO bonus
1222     function getPreICOBonus() internal constant returns (uint);
1223 
1224 
1225     // FIELDS
1226 
1227     /// @notice starting exchange rate of STQ
1228     uint public constant c_STQperETH = 100000;
1229 
1230     /// @notice authorised payment bonus
1231     uint public constant c_paymentChannelBonusPercent = 2;
1232 }
1233 
1234 
1235 
1236 
1237 /// @title Storiqa pre-ICO contract
1238 contract STQPreICO3 is STQPreICOBase, ExternalAccountWalletConnector {
1239 
1240     function STQPreICO3(address token, address wallet)
1241         STQPreICOBase(token)
1242         ExternalAccountWalletConnector(wallet)
1243     {
1244 
1245     }
1246 
1247 
1248     // INTERNAL
1249 
1250     function getWeiCollected() public constant returns (uint) {
1251         return getTotalInvestmentsStored();
1252     }
1253 
1254     /// @notice minimum amount of funding to consider crowdsale as successful
1255     function getMinimumFunds() internal constant returns (uint) {
1256         return 0;
1257     }
1258 
1259     /// @notice maximum investments to be accepted during pre-ICO
1260     function getMaximumFunds() internal constant returns (uint) {
1261         return 100000000 ether;
1262     }
1263 
1264     /// @notice start time of the pre-ICO
1265     function getStartTime() internal constant returns (uint) {
1266         return 1508958000; // 2017-10-25 19:00:00
1267     }
1268 
1269     /// @notice end time of the pre-ICO
1270     function getEndTime() internal constant returns (uint) {
1271         return 1511568000; //2017-11-25 00:00:00
1272     }
1273 
1274     /// @notice pre-ICO bonus
1275     function getPreICOBonus() internal constant returns (uint) {
1276         return 33;
1277     }
1278 }