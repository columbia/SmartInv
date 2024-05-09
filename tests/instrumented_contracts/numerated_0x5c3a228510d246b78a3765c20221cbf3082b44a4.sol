1 pragma solidity 0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances. 
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) returns (bool) {
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of. 
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) constant returns (uint256);
84   function transferFrom(address from, address to, uint256 value) returns (bool);
85   function approve(address spender, uint256 value) returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) returns (bool) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifing the amount of tokens still avaible for the spender.
145    */
146   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150 }
151 
152 
153 /// @title StandardToken which circulation can be delayed and started by another contract.
154 /// @dev To be used as a mixin contract.
155 /// The contract is created in disabled state: circulation is disabled.
156 contract CirculatingToken is StandardToken {
157 
158     event CirculationEnabled();
159 
160     modifier requiresCirculation {
161         require(m_isCirculating);
162         _;
163     }
164 
165 
166     // PUBLIC interface
167 
168     function transfer(address _to, uint256 _value) requiresCirculation returns (bool) {
169         return super.transfer(_to, _value);
170     }
171 
172     function transferFrom(address _from, address _to, uint256 _value) requiresCirculation returns (bool) {
173         return super.transferFrom(_from, _to, _value);
174     }
175 
176     function approve(address _spender, uint256 _value) requiresCirculation returns (bool) {
177         return super.approve(_spender, _value);
178     }
179 
180 
181     // INTERNAL functions
182 
183     function enableCirculation() internal returns (bool) {
184         if (m_isCirculating)
185             return false;
186 
187         m_isCirculating = true;
188         CirculationEnabled();
189         return true;
190     }
191 
192 
193     // FIELDS
194 
195     /// @notice are the circulation started?
196     bool public m_isCirculating;
197 }
198 
199 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
200 // TODO acceptOwnership
201 contract multiowned {
202 
203 	// TYPES
204 
205     // struct for the status of a pending operation.
206     struct MultiOwnedOperationPendingState {
207         // count of confirmations needed
208         uint yetNeeded;
209 
210         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
211         uint ownersDone;
212 
213         // position of this operation key in m_multiOwnedPendingIndex
214         uint index;
215     }
216 
217 	// EVENTS
218 
219     event Confirmation(address owner, bytes32 operation);
220     event Revoke(address owner, bytes32 operation);
221     event FinalConfirmation(address owner, bytes32 operation);
222 
223     // some others are in the case of an owner changing.
224     event OwnerChanged(address oldOwner, address newOwner);
225     event OwnerAdded(address newOwner);
226     event OwnerRemoved(address oldOwner);
227 
228     // the last one is emitted if the required signatures change
229     event RequirementChanged(uint newRequirement);
230 
231 	// MODIFIERS
232 
233     // simple single-sig function modifier.
234     modifier onlyowner {
235         require(isOwner(msg.sender));
236         _;
237     }
238     // multi-sig function modifier: the operation must have an intrinsic hash in order
239     // that later attempts can be realised as the same underlying operation and
240     // thus count as confirmations.
241     modifier onlymanyowners(bytes32 _operation) {
242         if (confirmAndCheck(_operation)) {
243             _;
244         }
245         // Even if required number of confirmations has't been collected yet,
246         // we can't throw here - because changes to the state have to be preserved.
247         // But, confirmAndCheck itself will throw in case sender is not an owner.
248     }
249 
250     modifier validNumOwners(uint _numOwners) {
251         require(_numOwners > 0 && _numOwners <= c_maxOwners);
252         _;
253     }
254 
255     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
256         require(_required > 0 && _required <= _numOwners);
257         _;
258     }
259 
260     modifier ownerExists(address _address) {
261         require(isOwner(_address));
262         _;
263     }
264 
265     modifier ownerDoesNotExist(address _address) {
266         require(!isOwner(_address));
267         _;
268     }
269 
270     modifier multiOwnedOperationIsActive(bytes32 _operation) {
271         require(isOperationActive(_operation));
272         _;
273     }
274 
275 	// METHODS
276 
277     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
278     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
279     function multiowned(address[] _owners, uint _required)
280         validNumOwners(_owners.length)
281         multiOwnedValidRequirement(_required, _owners.length)
282     {
283         assert(c_maxOwners <= 255);
284 
285         m_numOwners = _owners.length;
286         m_multiOwnedRequired = _required;
287 
288         for (uint i = 0; i < _owners.length; ++i)
289         {
290             address owner = _owners[i];
291             // invalid and duplicate addresses are not allowed
292             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
293 
294             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
295             m_owners[currentOwnerIndex] = owner;
296             m_ownerIndex[owner] = currentOwnerIndex;
297         }
298 
299         assertOwnersAreConsistent();
300     }
301 
302     /// @notice replaces an owner `_from` with another `_to`.
303     /// @param _from address of owner to replace
304     /// @param _to address of new owner
305     // All pending operations will be canceled!
306     function changeOwner(address _from, address _to)
307         external
308         ownerExists(_from)
309         ownerDoesNotExist(_to)
310         onlymanyowners(sha3(msg.data))
311     {
312         assertOwnersAreConsistent();
313 
314         clearPending();
315         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
316         m_owners[ownerIndex] = _to;
317         m_ownerIndex[_from] = 0;
318         m_ownerIndex[_to] = ownerIndex;
319 
320         assertOwnersAreConsistent();
321         OwnerChanged(_from, _to);
322     }
323 
324     /// @notice adds an owner
325     /// @param _owner address of new owner
326     // All pending operations will be canceled!
327     function addOwner(address _owner)
328         external
329         ownerDoesNotExist(_owner)
330         validNumOwners(m_numOwners + 1)
331         onlymanyowners(sha3(msg.data))
332     {
333         assertOwnersAreConsistent();
334 
335         clearPending();
336         m_numOwners++;
337         m_owners[m_numOwners] = _owner;
338         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
339 
340         assertOwnersAreConsistent();
341         OwnerAdded(_owner);
342     }
343 
344     /// @notice removes an owner
345     /// @param _owner address of owner to remove
346     // All pending operations will be canceled!
347     function removeOwner(address _owner)
348         external
349         ownerExists(_owner)
350         validNumOwners(m_numOwners - 1)
351         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
352         onlymanyowners(sha3(msg.data))
353     {
354         assertOwnersAreConsistent();
355 
356         clearPending();
357         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
358         m_owners[ownerIndex] = 0;
359         m_ownerIndex[_owner] = 0;
360         //make sure m_numOwners is equal to the number of owners and always points to the last owner
361         reorganizeOwners();
362 
363         assertOwnersAreConsistent();
364         OwnerRemoved(_owner);
365     }
366 
367     /// @notice changes the required number of owner signatures
368     /// @param _newRequired new number of signatures required
369     // All pending operations will be canceled!
370     function changeRequirement(uint _newRequired)
371         external
372         multiOwnedValidRequirement(_newRequired, m_numOwners)
373         onlymanyowners(sha3(msg.data))
374     {
375         m_multiOwnedRequired = _newRequired;
376         clearPending();
377         RequirementChanged(_newRequired);
378     }
379 
380     /// @notice Gets an owner by 0-indexed position
381     /// @param ownerIndex 0-indexed owner position
382     function getOwner(uint ownerIndex) public constant returns (address) {
383         return m_owners[ownerIndex + 1];
384     }
385 
386     /// @notice Gets owners
387     /// @return memory array of owners
388     function getOwners() public constant returns (address[]) {
389         address[] memory result = new address[](m_numOwners);
390         for (uint i = 0; i < m_numOwners; i++)
391             result[i] = getOwner(i);
392 
393         return result;
394     }
395 
396     /// @notice checks if provided address is an owner address
397     /// @param _addr address to check
398     /// @return true if it's an owner
399     function isOwner(address _addr) public constant returns (bool) {
400         return m_ownerIndex[_addr] > 0;
401     }
402 
403     /// @notice Tests ownership of the current caller.
404     /// @return true if it's an owner
405     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
406     // addOwner/changeOwner and to isOwner.
407     function amIOwner() external constant onlyowner returns (bool) {
408         return true;
409     }
410 
411     /// @notice Revokes a prior confirmation of the given operation
412     /// @param _operation operation value, typically sha3(msg.data)
413     function revoke(bytes32 _operation)
414         external
415         multiOwnedOperationIsActive(_operation)
416         onlyowner
417     {
418         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
419         var pending = m_multiOwnedPending[_operation];
420         require(pending.ownersDone & ownerIndexBit > 0);
421 
422         assertOperationIsConsistent(_operation);
423 
424         pending.yetNeeded++;
425         pending.ownersDone -= ownerIndexBit;
426 
427         assertOperationIsConsistent(_operation);
428         Revoke(msg.sender, _operation);
429     }
430 
431     /// @notice Checks if owner confirmed given operation
432     /// @param _operation operation value, typically sha3(msg.data)
433     /// @param _owner an owner address
434     function hasConfirmed(bytes32 _operation, address _owner)
435         external
436         constant
437         multiOwnedOperationIsActive(_operation)
438         ownerExists(_owner)
439         returns (bool)
440     {
441         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
442     }
443 
444     // INTERNAL METHODS
445 
446     function confirmAndCheck(bytes32 _operation)
447         private
448         onlyowner
449         returns (bool)
450     {
451         if (512 == m_multiOwnedPendingIndex.length)
452             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
453             // we won't be able to do it because of block gas limit.
454             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
455             // TODO use more graceful approach like compact or removal of clearPending completely
456             clearPending();
457 
458         var pending = m_multiOwnedPending[_operation];
459 
460         // if we're not yet working on this operation, switch over and reset the confirmation status.
461         if (! isOperationActive(_operation)) {
462             // reset count of confirmations needed.
463             pending.yetNeeded = m_multiOwnedRequired;
464             // reset which owners have confirmed (none) - set our bitmap to 0.
465             pending.ownersDone = 0;
466             pending.index = m_multiOwnedPendingIndex.length++;
467             m_multiOwnedPendingIndex[pending.index] = _operation;
468             assertOperationIsConsistent(_operation);
469         }
470 
471         // determine the bit to set for this owner.
472         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
473         // make sure we (the message sender) haven't confirmed this operation previously.
474         if (pending.ownersDone & ownerIndexBit == 0) {
475             // ok - check if count is enough to go ahead.
476             assert(pending.yetNeeded > 0);
477             if (pending.yetNeeded == 1) {
478                 // enough confirmations: reset and run interior.
479                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
480                 delete m_multiOwnedPending[_operation];
481                 FinalConfirmation(msg.sender, _operation);
482                 return true;
483             }
484             else
485             {
486                 // not enough: record that this owner in particular confirmed.
487                 pending.yetNeeded--;
488                 pending.ownersDone |= ownerIndexBit;
489                 assertOperationIsConsistent(_operation);
490                 Confirmation(msg.sender, _operation);
491             }
492         }
493     }
494 
495     // Reclaims free slots between valid owners in m_owners.
496     // TODO given that its called after each removal, it could be simplified.
497     function reorganizeOwners() private {
498         uint free = 1;
499         while (free < m_numOwners)
500         {
501             // iterating to the first free slot from the beginning
502             while (free < m_numOwners && m_owners[free] != 0) free++;
503 
504             // iterating to the first occupied slot from the end
505             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
506 
507             // swap, if possible, so free slot is located at the end after the swap
508             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
509             {
510                 // owners between swapped slots should't be renumbered - that saves a lot of gas
511                 m_owners[free] = m_owners[m_numOwners];
512                 m_ownerIndex[m_owners[free]] = free;
513                 m_owners[m_numOwners] = 0;
514             }
515         }
516     }
517 
518     function clearPending() private onlyowner {
519         uint length = m_multiOwnedPendingIndex.length;
520         for (uint i = 0; i < length; ++i) {
521             if (m_multiOwnedPendingIndex[i] != 0)
522                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
523         }
524         delete m_multiOwnedPendingIndex;
525     }
526 
527     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
528         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
529         return ownerIndex;
530     }
531 
532     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
533         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
534         return 2 ** ownerIndex;
535     }
536 
537     function isOperationActive(bytes32 _operation) private constant returns (bool) {
538         return 0 != m_multiOwnedPending[_operation].yetNeeded;
539     }
540 
541 
542     function assertOwnersAreConsistent() private constant {
543         assert(m_numOwners > 0);
544         assert(m_numOwners <= c_maxOwners);
545         assert(m_owners[0] == 0);
546         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
547     }
548 
549     function assertOperationIsConsistent(bytes32 _operation) private constant {
550         var pending = m_multiOwnedPending[_operation];
551         assert(0 != pending.yetNeeded);
552         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
553         assert(pending.yetNeeded <= m_multiOwnedRequired);
554     }
555 
556 
557    	// FIELDS
558 
559     uint constant c_maxOwners = 250;
560 
561     // the number of owners that must confirm the same operation before it is run.
562     uint public m_multiOwnedRequired;
563 
564 
565     // pointer used to find a free slot in m_owners
566     uint public m_numOwners;
567 
568     // list of owners (addresses),
569     // slot 0 is unused so there are no owner which index is 0.
570     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
571     address[256] internal m_owners;
572 
573     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
574     mapping(address => uint) internal m_ownerIndex;
575 
576 
577     // the ongoing operations.
578     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
579     bytes32[] internal m_multiOwnedPendingIndex;
580 }
581 
582 
583 /**
584  * @title Contract which is owned by owners and operated by controller.
585  *
586  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
587  * Controller is set up by owners or during construction.
588  *
589  * @dev controller check is performed by onlyController modifier.
590  */
591 contract MultiownedControlled is multiowned {
592 
593     event ControllerSet(address controller);
594     event ControllerRetired(address was);
595 
596 
597     modifier onlyController {
598         require(msg.sender == m_controller);
599         _;
600     }
601 
602 
603     // PUBLIC interface
604 
605     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
606         multiowned(_owners, _signaturesRequired)
607     {
608         m_controller = _controller;
609         ControllerSet(m_controller);
610     }
611 
612     /// @dev sets the controller
613     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
614         m_controller = _controller;
615         ControllerSet(m_controller);
616     }
617 
618     /// @dev ability for controller to step down
619     function detachController() external onlyController {
620         address was = m_controller;
621         m_controller = address(0);
622         ControllerRetired(was);
623     }
624 
625 
626     // FIELDS
627 
628     /// @notice address of entity entitled to mint new tokens
629     address public m_controller;
630 }
631 
632 
633 /// @title StandardToken which can be minted by another contract.
634 contract MintableMultiownedToken is MultiownedControlled, StandardToken {
635 
636     /// @dev parameters of an extra token emission
637     struct EmissionInfo {
638         // tokens created
639         uint256 created;
640 
641         // totalSupply at the moment of emission (excluding created tokens)
642         uint256 totalSupplyWas;
643     }
644 
645     event Mint(address indexed to, uint256 amount);
646     event Emission(uint256 tokensCreated, uint256 totalSupplyWas, uint256 time);
647     event Dividend(address indexed to, uint256 amount);
648 
649 
650     // PUBLIC interface
651 
652     function MintableMultiownedToken(address[] _owners, uint _signaturesRequired, address _minter)
653         MultiownedControlled(_owners, _signaturesRequired, _minter)
654     {
655         dividendsPool = this;   // or any other special unforgeable value, actually
656 
657         // emission #0 is a dummy: because of default value 0 in m_lastAccountEmission
658         m_emissions.push(EmissionInfo({created: 0, totalSupplyWas: 0}));
659     }
660 
661     /// @notice Request dividends for current account.
662     function requestDividends() external {
663         payDividendsTo(msg.sender);
664     }
665 
666     /// @notice hook on standard ERC20#transfer to pay dividends
667     function transfer(address _to, uint256 _value) returns (bool) {
668         payDividendsTo(msg.sender);
669         payDividendsTo(_to);
670         return super.transfer(_to, _value);
671     }
672 
673     /// @notice hook on standard ERC20#transferFrom to pay dividends
674     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
675         payDividendsTo(_from);
676         payDividendsTo(_to);
677         return super.transferFrom(_from, _to, _value);
678     }
679 
680     // Disabled: this could be undesirable because sum of (balanceOf() for each token owner) != totalSupply
681     // (but: sum of (balances[owner] for each token owner) == totalSupply!).
682     //
683     // @notice hook on standard ERC20#balanceOf to take dividends into consideration
684     // function balanceOf(address _owner) constant returns (uint256) {
685     //     var (hasNewDividends, dividends) = calculateDividendsFor(_owner);
686     //     return hasNewDividends ? super.balanceOf(_owner).add(dividends) : super.balanceOf(_owner);
687     // }
688 
689 
690     /// @dev mints new tokens
691     function mint(address _to, uint256 _amount) external onlyController {
692         require(m_externalMintingEnabled);
693         payDividendsTo(_to);
694         mintInternal(_to, _amount);
695     }
696 
697     /// @dev disables mint(), irreversible!
698     function disableMinting() external onlyController {
699         require(m_externalMintingEnabled);
700         m_externalMintingEnabled = false;
701     }
702 
703 
704     // INTERNAL functions
705 
706     /**
707      * @notice Starts new token emission
708      * @param _tokensCreated Amount of tokens to create
709      * @dev Dividends are not distributed immediately as it could require billions of gas,
710      * instead they are `pulled` by a holder from dividends pool account before any update to the holder account occurs.
711      */
712     function emissionInternal(uint256 _tokensCreated) internal {
713         require(0 != _tokensCreated);
714         require(_tokensCreated < totalSupply / 2);  // otherwise it looks like an error
715 
716         uint256 totalSupplyWas = totalSupply;
717 
718         m_emissions.push(EmissionInfo({created: _tokensCreated, totalSupplyWas: totalSupplyWas}));
719         mintInternal(dividendsPool, _tokensCreated);
720 
721         Emission(_tokensCreated, totalSupplyWas, now);
722     }
723 
724     function mintInternal(address _to, uint256 _amount) internal {
725         totalSupply = totalSupply.add(_amount);
726         balances[_to] = balances[_to].add(_amount);
727         Transfer(this, _to, _amount);
728         Mint(_to, _amount);
729     }
730 
731     /// @dev adds dividends to the account _to
732     function payDividendsTo(address _to) internal {
733         var (hasNewDividends, dividends) = calculateDividendsFor(_to);
734         if (!hasNewDividends)
735             return;
736 
737         if (0 != dividends) {
738             balances[dividendsPool] = balances[dividendsPool].sub(dividends);
739             balances[_to] = balances[_to].add(dividends);
740             Transfer(dividendsPool, _to, dividends);
741         }
742         m_lastAccountEmission[_to] = getLastEmissionNum();
743     }
744 
745     /// @dev calculates dividends for the account _for
746     /// @return (true if state has to be updated, dividend amount (could be 0!))
747     function calculateDividendsFor(address _for) constant internal returns (bool hasNewDividends, uint dividends) {
748         assert(_for != dividendsPool);  // no dividends for the pool!
749 
750         uint256 lastEmissionNum = getLastEmissionNum();
751         uint256 lastAccountEmissionNum = m_lastAccountEmission[_for];
752         assert(lastAccountEmissionNum <= lastEmissionNum);
753         if (lastAccountEmissionNum == lastEmissionNum)
754             return (false, 0);
755 
756         uint256 initialBalance = balances[_for];    // beware of recursion!
757         if (0 == initialBalance)
758             return (true, 0);
759 
760         uint256 balance = initialBalance;
761         for (uint256 emissionToProcess = lastAccountEmissionNum + 1; emissionToProcess <= lastEmissionNum; emissionToProcess++) {
762             EmissionInfo storage emission = m_emissions[emissionToProcess];
763             assert(0 != emission.created && 0 != emission.totalSupplyWas);
764 
765             uint256 dividend = balance.mul(emission.created).div(emission.totalSupplyWas);
766             Dividend(_for, dividend);
767 
768             balance = balance.add(dividend);
769         }
770 
771         return (true, balance.sub(initialBalance));
772     }
773 
774     function getLastEmissionNum() private constant returns (uint256) {
775         return m_emissions.length - 1;
776     }
777 
778 
779     // FIELDS
780 
781     /// @notice if this true then token is still externally mintable (but this flag does't affect emissions!)
782     bool public m_externalMintingEnabled = true;
783 
784     /// @dev internal address of dividends in balances mapping.
785     address dividendsPool;
786 
787     /// @notice record of issued dividend emissions
788     EmissionInfo[] public m_emissions;
789 
790     /// @dev for each token holder: last emission (index in m_emissions) which was processed for this holder
791     mapping(address => uint256) m_lastAccountEmission;
792 }
793 
794 
795 /// @title Storiqa coin contract
796 contract STQToken is CirculatingToken, MintableMultiownedToken {
797 
798 
799     // PUBLIC interface
800 
801     function STQToken(address[] _owners)
802         MintableMultiownedToken(_owners, 2, /* minter: */ address(0))
803     {
804         require(3 == _owners.length);
805     }
806 
807     /// @dev Allows token transfers
808     function startCirculation() external onlyController {
809         assert(enableCirculation());    // must be called once
810     }
811 
812     /// @notice Starts new token emission
813     /// @param _tokensCreatedInSTQ Amount of STQ (not STQ-wei!) to create, like 30 000 or so
814     function emission(uint256 _tokensCreatedInSTQ) external onlymanyowners(sha3(msg.data)) {
815         emissionInternal(_tokensCreatedInSTQ.mul(uint256(10) ** uint256(decimals)));
816     }
817 
818 
819     // FIELDS
820 
821     string public constant name = 'Storiqa Token';
822     string public constant symbol = 'STQ';
823     uint8 public constant decimals = 18;
824 }