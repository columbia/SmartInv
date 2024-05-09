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
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances. 
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) returns (bool) {
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of. 
72   * @return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) constant returns (uint256);
87   function transferFrom(address from, address to, uint256 value) returns (bool);
88   function approve(address spender, uint256 value) returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amout of tokens to be transfered
110    */
111   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
112     var _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_to] = balances[_to].add(_value);
118     balances[_from] = balances[_from].sub(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) returns (bool) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifing the amount of tokens still avaible for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152 }
153 
154 
155 
156 /// @title StandardToken which circulation can be delayed and started by another contract.
157 /// @dev To be used as a mixin contract.
158 /// The contract is created in disabled state: circulation is disabled.
159 contract CirculatingToken is StandardToken {
160 
161     event CirculationEnabled();
162 
163     modifier requiresCirculation {
164         require(m_isCirculating);
165         _;
166     }
167 
168 
169     // PUBLIC interface
170 
171     function transfer(address _to, uint256 _value) requiresCirculation returns (bool) {
172         return super.transfer(_to, _value);
173     }
174 
175     function transferFrom(address _from, address _to, uint256 _value) requiresCirculation returns (bool) {
176         return super.transferFrom(_from, _to, _value);
177     }
178 
179     function approve(address _spender, uint256 _value) requiresCirculation returns (bool) {
180         return super.approve(_spender, _value);
181     }
182 
183 
184     // INTERNAL functions
185 
186     function enableCirculation() internal returns (bool) {
187         if (m_isCirculating)
188             return false;
189 
190         m_isCirculating = true;
191         CirculationEnabled();
192         return true;
193     }
194 
195 
196     // FIELDS
197 
198     /// @notice are the circulation started?
199     bool public m_isCirculating;
200 }
201 
202 
203 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
204 // Audit, refactoring and improvements by github.com/Eenae
205 
206 // @authors:
207 // Gav Wood <g@ethdev.com>
208 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
209 // single, or, crucially, each of a number of, designated owners.
210 // usage:
211 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
212 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
213 // interior is executed.
214 
215 
216 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
217 // TODO acceptOwnership
218 contract multiowned {
219 
220 	// TYPES
221 
222     // struct for the status of a pending operation.
223     struct MultiOwnedOperationPendingState {
224         // count of confirmations needed
225         uint yetNeeded;
226 
227         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
228         uint ownersDone;
229 
230         // position of this operation key in m_multiOwnedPendingIndex
231         uint index;
232     }
233 
234 	// EVENTS
235 
236     event Confirmation(address owner, bytes32 operation);
237     event Revoke(address owner, bytes32 operation);
238     event FinalConfirmation(address owner, bytes32 operation);
239 
240     // some others are in the case of an owner changing.
241     event OwnerChanged(address oldOwner, address newOwner);
242     event OwnerAdded(address newOwner);
243     event OwnerRemoved(address oldOwner);
244 
245     // the last one is emitted if the required signatures change
246     event RequirementChanged(uint newRequirement);
247 
248 	// MODIFIERS
249 
250     // simple single-sig function modifier.
251     modifier onlyowner {
252         require(isOwner(msg.sender));
253         _;
254     }
255     // multi-sig function modifier: the operation must have an intrinsic hash in order
256     // that later attempts can be realised as the same underlying operation and
257     // thus count as confirmations.
258     modifier onlymanyowners(bytes32 _operation) {
259         if (confirmAndCheck(_operation)) {
260             _;
261         }
262         // Even if required number of confirmations has't been collected yet,
263         // we can't throw here - because changes to the state have to be preserved.
264         // But, confirmAndCheck itself will throw in case sender is not an owner.
265     }
266 
267     modifier validNumOwners(uint _numOwners) {
268         require(_numOwners > 0 && _numOwners <= c_maxOwners);
269         _;
270     }
271 
272     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
273         require(_required > 0 && _required <= _numOwners);
274         _;
275     }
276 
277     modifier ownerExists(address _address) {
278         require(isOwner(_address));
279         _;
280     }
281 
282     modifier ownerDoesNotExist(address _address) {
283         require(!isOwner(_address));
284         _;
285     }
286 
287     modifier multiOwnedOperationIsActive(bytes32 _operation) {
288         require(isOperationActive(_operation));
289         _;
290     }
291 
292 	// METHODS
293 
294     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
295     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
296     function multiowned(address[] _owners, uint _required)
297         validNumOwners(_owners.length)
298         multiOwnedValidRequirement(_required, _owners.length)
299     {
300         assert(c_maxOwners <= 255);
301 
302         m_numOwners = _owners.length;
303         m_multiOwnedRequired = _required;
304 
305         for (uint i = 0; i < _owners.length; ++i)
306         {
307             address owner = _owners[i];
308             // invalid and duplicate addresses are not allowed
309             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
310 
311             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
312             m_owners[currentOwnerIndex] = owner;
313             m_ownerIndex[owner] = currentOwnerIndex;
314         }
315 
316         assertOwnersAreConsistent();
317     }
318 
319     // Replaces an owner `_from` with another `_to`.
320     // All pending operations will be canceled!
321     function changeOwner(address _from, address _to)
322         external
323         ownerExists(_from)
324         ownerDoesNotExist(_to)
325         onlymanyowners(sha3(msg.data))
326     {
327         assertOwnersAreConsistent();
328 
329         clearPending();
330         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
331         m_owners[ownerIndex] = _to;
332         m_ownerIndex[_from] = 0;
333         m_ownerIndex[_to] = ownerIndex;
334 
335         assertOwnersAreConsistent();
336         OwnerChanged(_from, _to);
337     }
338 
339     // All pending operations will be canceled!
340     function addOwner(address _owner)
341         external
342         ownerDoesNotExist(_owner)
343         validNumOwners(m_numOwners + 1)
344         onlymanyowners(sha3(msg.data))
345     {
346         assertOwnersAreConsistent();
347 
348         clearPending();
349         m_numOwners++;
350         m_owners[m_numOwners] = _owner;
351         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
352 
353         assertOwnersAreConsistent();
354         OwnerAdded(_owner);
355     }
356 
357     // All pending operations will be canceled!
358     function removeOwner(address _owner)
359         external
360         ownerExists(_owner)
361         validNumOwners(m_numOwners - 1)
362         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
363         onlymanyowners(sha3(msg.data))
364     {
365         assertOwnersAreConsistent();
366 
367         clearPending();
368         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
369         m_owners[ownerIndex] = 0;
370         m_ownerIndex[_owner] = 0;
371         //make sure m_numOwners is equal to the number of owners and always points to the last owner
372         reorganizeOwners();
373 
374         assertOwnersAreConsistent();
375         OwnerRemoved(_owner);
376     }
377 
378     // All pending operations will be canceled!
379     function changeRequirement(uint _newRequired)
380         external
381         multiOwnedValidRequirement(_newRequired, m_numOwners)
382         onlymanyowners(sha3(msg.data))
383     {
384         m_multiOwnedRequired = _newRequired;
385         clearPending();
386         RequirementChanged(_newRequired);
387     }
388 
389     // Gets an owner by 0-indexed position
390     function getOwner(uint ownerIndex) public constant returns (address) {
391         return m_owners[ownerIndex + 1];
392     }
393 
394     function getOwners() public constant returns (address[]) {
395         address[] memory result = new address[](m_numOwners);
396         for (uint i = 0; i < m_numOwners; i++)
397             result[i] = getOwner(i);
398 
399         return result;
400     }
401 
402     function isOwner(address _addr) public constant returns (bool) {
403         return m_ownerIndex[_addr] > 0;
404     }
405 
406     // Tests ownership of the current caller.
407     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
408     // addOwner/changeOwner and to isOwner.
409     function amIOwner() external constant onlyowner returns (bool) {
410         return true;
411     }
412 
413     // Revokes a prior confirmation of the given operation
414     function revoke(bytes32 _operation)
415         external
416         multiOwnedOperationIsActive(_operation)
417         onlyowner
418     {
419         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
420         var pending = m_multiOwnedPending[_operation];
421         require(pending.ownersDone & ownerIndexBit > 0);
422 
423         assertOperationIsConsistent(_operation);
424 
425         pending.yetNeeded++;
426         pending.ownersDone -= ownerIndexBit;
427 
428         assertOperationIsConsistent(_operation);
429         Revoke(msg.sender, _operation);
430     }
431 
432     function hasConfirmed(bytes32 _operation, address _owner)
433         external
434         constant
435         multiOwnedOperationIsActive(_operation)
436         ownerExists(_owner)
437         returns (bool)
438     {
439         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
440     }
441 
442     // INTERNAL METHODS
443 
444     function confirmAndCheck(bytes32 _operation)
445         private
446         onlyowner
447         returns (bool)
448     {
449         if (512 == m_multiOwnedPendingIndex.length)
450             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
451             // we won't be able to do it because of block gas limit.
452             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
453             // TODO use more graceful approach like compact or removal of clearPending completely
454             clearPending();
455 
456         var pending = m_multiOwnedPending[_operation];
457 
458         // if we're not yet working on this operation, switch over and reset the confirmation status.
459         if (! isOperationActive(_operation)) {
460             // reset count of confirmations needed.
461             pending.yetNeeded = m_multiOwnedRequired;
462             // reset which owners have confirmed (none) - set our bitmap to 0.
463             pending.ownersDone = 0;
464             pending.index = m_multiOwnedPendingIndex.length++;
465             m_multiOwnedPendingIndex[pending.index] = _operation;
466             assertOperationIsConsistent(_operation);
467         }
468 
469         // determine the bit to set for this owner.
470         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
471         // make sure we (the message sender) haven't confirmed this operation previously.
472         if (pending.ownersDone & ownerIndexBit == 0) {
473             // ok - check if count is enough to go ahead.
474             assert(pending.yetNeeded > 0);
475             if (pending.yetNeeded == 1) {
476                 // enough confirmations: reset and run interior.
477                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
478                 delete m_multiOwnedPending[_operation];
479                 FinalConfirmation(msg.sender, _operation);
480                 return true;
481             }
482             else
483             {
484                 // not enough: record that this owner in particular confirmed.
485                 pending.yetNeeded--;
486                 pending.ownersDone |= ownerIndexBit;
487                 assertOperationIsConsistent(_operation);
488                 Confirmation(msg.sender, _operation);
489             }
490         }
491     }
492 
493     // Reclaims free slots between valid owners in m_owners.
494     // TODO given that its called after each removal, it could be simplified.
495     function reorganizeOwners() private {
496         uint free = 1;
497         while (free < m_numOwners)
498         {
499             // iterating to the first free slot from the beginning
500             while (free < m_numOwners && m_owners[free] != 0) free++;
501 
502             // iterating to the first occupied slot from the end
503             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
504 
505             // swap, if possible, so free slot is located at the end after the swap
506             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
507             {
508                 // owners between swapped slots should't be renumbered - that saves a lot of gas
509                 m_owners[free] = m_owners[m_numOwners];
510                 m_ownerIndex[m_owners[free]] = free;
511                 m_owners[m_numOwners] = 0;
512             }
513         }
514     }
515 
516     function clearPending() private onlyowner {
517         uint length = m_multiOwnedPendingIndex.length;
518         for (uint i = 0; i < length; ++i) {
519             if (m_multiOwnedPendingIndex[i] != 0)
520                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
521         }
522         delete m_multiOwnedPendingIndex;
523     }
524 
525     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
526         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
527         return ownerIndex;
528     }
529 
530     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
531         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
532         return 2 ** ownerIndex;
533     }
534 
535     function isOperationActive(bytes32 _operation) private constant returns (bool) {
536         return 0 != m_multiOwnedPending[_operation].yetNeeded;
537     }
538 
539 
540     function assertOwnersAreConsistent() private constant {
541         assert(m_numOwners > 0);
542         assert(m_numOwners <= c_maxOwners);
543         assert(m_owners[0] == 0);
544         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
545     }
546 
547     function assertOperationIsConsistent(bytes32 _operation) private constant {
548         var pending = m_multiOwnedPending[_operation];
549         assert(0 != pending.yetNeeded);
550         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
551         assert(pending.yetNeeded <= m_multiOwnedRequired);
552     }
553 
554 
555    	// FIELDS
556 
557     uint constant c_maxOwners = 250;
558 
559     // the number of owners that must confirm the same operation before it is run.
560     uint public m_multiOwnedRequired;
561 
562 
563     // pointer used to find a free slot in m_owners
564     uint public m_numOwners;
565 
566     // list of owners (addresses),
567     // slot 0 is unused so there are no owner which index is 0.
568     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
569     address[256] internal m_owners;
570 
571     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
572     mapping(address => uint) internal m_ownerIndex;
573 
574 
575     // the ongoing operations.
576     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
577     bytes32[] internal m_multiOwnedPendingIndex;
578 }
579 
580 
581 /**
582  * @title Contract which is owned by owners and operated by controller.
583  *
584  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
585  * Controller is set up by owners or during construction.
586  *
587  * @dev controller check is performed by onlyController modifier.
588  */
589 contract MultiownedControlled is multiowned {
590 
591     event ControllerSet(address controller);
592     event ControllerRetired(address was);
593 
594 
595     modifier onlyController {
596         require(msg.sender == m_controller);
597         _;
598     }
599 
600 
601     // PUBLIC interface
602 
603     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
604         multiowned(_owners, _signaturesRequired)
605     {
606         m_controller = _controller;
607         ControllerSet(m_controller);
608     }
609 
610     /// @notice sets the controller
611     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
612         m_controller = _controller;
613         ControllerSet(m_controller);
614     }
615 
616     /// @notice ability for controller to step down
617     function detachController() external onlyController {
618         address was = m_controller;
619         m_controller = address(0);
620         ControllerRetired(was);
621     }
622 
623 
624     // FIELDS
625 
626     /// @notice address of entity entitled to mint new tokens
627     address public m_controller;
628 }
629 
630 
631 /// @title StandardToken which can be minted by another contract.
632 contract MintableMultiownedToken is MultiownedControlled, StandardToken {
633 
634     /// @dev parameters of an extra token emission
635     struct EmissionInfo {
636         // tokens created
637         uint256 created;
638 
639         // totalSupply at the moment of emission (excluding created tokens)
640         uint256 totalSupplyWas;
641     }
642 
643     event Mint(address indexed to, uint256 amount);
644     event Emission(uint256 tokensCreated, uint256 totalSupplyWas, uint256 time);
645     event Dividend(address indexed to, uint256 amount);
646 
647 
648     // PUBLIC interface
649 
650     function MintableMultiownedToken(address[] _owners, uint _signaturesRequired, address _minter)
651         MultiownedControlled(_owners, _signaturesRequired, _minter)
652     {
653         dividendsPool = this;   // or any other special unforgeable value, actually
654 
655         // emission #0 is a dummy: because of default value 0 in m_lastAccountEmission
656         m_emissions.push(EmissionInfo({created: 0, totalSupplyWas: 0}));
657     }
658 
659     /// @notice Request dividends for current account.
660     function requestDividends() external {
661         payDividendsTo(msg.sender);
662     }
663 
664     /// @notice hook on standard ERC20#transfer to pay dividends
665     function transfer(address _to, uint256 _value) returns (bool) {
666         payDividendsTo(msg.sender);
667         payDividendsTo(_to);
668         return super.transfer(_to, _value);
669     }
670 
671     /// @notice hook on standard ERC20#transferFrom to pay dividends
672     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
673         payDividendsTo(_from);
674         payDividendsTo(_to);
675         return super.transferFrom(_from, _to, _value);
676     }
677 
678     // Disabled: this could be undesirable because sum of (balanceOf() for each token owner) != totalSupply
679     // (but: sum of (balances[owner] for each token owner) == totalSupply!).
680     //
681     // @notice hook on standard ERC20#balanceOf to take dividends into consideration
682     // function balanceOf(address _owner) constant returns (uint256) {
683     //     var (hasNewDividends, dividends) = calculateDividendsFor(_owner);
684     //     return hasNewDividends ? super.balanceOf(_owner).add(dividends) : super.balanceOf(_owner);
685     // }
686 
687 
688     /// @dev mints new tokens
689     function mint(address _to, uint256 _amount) external onlyController {
690         require(m_externalMintingEnabled);
691         payDividendsTo(_to);
692         mintInternal(_to, _amount);
693     }
694 
695     /// @dev disables mint(), irreversible!
696     function disableMinting() external onlyController {
697         require(m_externalMintingEnabled);
698         m_externalMintingEnabled = false;
699     }
700 
701 
702     // INTERNAL functions
703 
704     /**
705      * @notice Starts new token emission
706      * @param _tokensCreated Amount of tokens to create
707      * @dev Dividends are not distributed immediately as it could require billions of gas,
708      * instead they are `pulled` by a holder from dividends pool account before any update to the holder account occurs.
709      */
710     function emissionInternal(uint256 _tokensCreated) internal {
711         require(0 != _tokensCreated);
712         require(_tokensCreated < totalSupply / 2);  // otherwise it looks like an error
713 
714         uint256 totalSupplyWas = totalSupply;
715 
716         m_emissions.push(EmissionInfo({created: _tokensCreated, totalSupplyWas: totalSupplyWas}));
717         mintInternal(dividendsPool, _tokensCreated);
718 
719         Emission(_tokensCreated, totalSupplyWas, now);
720     }
721 
722     function mintInternal(address _to, uint256 _amount) internal {
723         totalSupply = totalSupply.add(_amount);
724         balances[_to] = balances[_to].add(_amount);
725         Mint(_to, _amount);
726     }
727 
728     /// @dev adds dividends to the account _to
729     function payDividendsTo(address _to) internal {
730         var (hasNewDividends, dividends) = calculateDividendsFor(_to);
731         if (!hasNewDividends)
732             return;
733 
734         if (0 != dividends) {
735             balances[dividendsPool] = balances[dividendsPool].sub(dividends);
736             balances[_to] = balances[_to].add(dividends);
737         }
738         m_lastAccountEmission[_to] = getLastEmissionNum();
739     }
740 
741     /// @dev calculates dividends for the account _for
742     /// @return (true if state has to be updated, dividend amount (could be 0!))
743     function calculateDividendsFor(address _for) constant internal returns (bool hasNewDividends, uint dividends) {
744         assert(_for != dividendsPool);  // no dividends for the pool!
745 
746         uint256 lastEmissionNum = getLastEmissionNum();
747         uint256 lastAccountEmissionNum = m_lastAccountEmission[_for];
748         assert(lastAccountEmissionNum <= lastEmissionNum);
749         if (lastAccountEmissionNum == lastEmissionNum)
750             return (false, 0);
751 
752         uint256 initialBalance = balances[_for];    // beware of recursion!
753         if (0 == initialBalance)
754             return (true, 0);
755 
756         uint256 balance = initialBalance;
757         for (uint256 emissionToProcess = lastAccountEmissionNum + 1; emissionToProcess <= lastEmissionNum; emissionToProcess++) {
758             EmissionInfo storage emission = m_emissions[emissionToProcess];
759             assert(0 != emission.created && 0 != emission.totalSupplyWas);
760 
761             uint256 dividend = balance.mul(emission.created).div(emission.totalSupplyWas);
762             Dividend(_for, dividend);
763 
764             balance = balance.add(dividend);
765         }
766 
767         return (true, balance.sub(initialBalance));
768     }
769 
770     function getLastEmissionNum() private constant returns (uint256) {
771         return m_emissions.length - 1;
772     }
773 
774 
775     // FIELDS
776 
777     /// @notice if this true then token is still externally mintable (but this flag does't affect emissions!)
778     bool public m_externalMintingEnabled = true;
779 
780     /// @dev internal address of dividends in balances mapping.
781     address dividendsPool;
782 
783     /// @notice record of issued dividend emissions
784     EmissionInfo[] public m_emissions;
785 
786     /// @dev for each token holder: last emission (index in m_emissions) which was processed for this holder
787     mapping(address => uint256) m_lastAccountEmission;
788 }
789 
790 
791 /// @title Storiqa coin contract
792 contract STQToken is CirculatingToken, MintableMultiownedToken {
793 
794 
795     // PUBLIC interface
796 
797     function STQToken(address[] _owners)
798         MintableMultiownedToken(_owners, 2, /* minter: */ address(0))
799     {
800         require(3 == _owners.length);
801     }
802 
803     /// @notice Allows token transfers
804     function startCirculation() external onlyController {
805         assert(enableCirculation());    // must be called once
806     }
807 
808     /// @notice Starts new token emission
809     /// @param _tokensCreatedInSTQ Amount of STQ (not STQ-wei!) to create, like 30 000 or so
810     function emission(uint256 _tokensCreatedInSTQ) external onlymanyowners(sha3(msg.data)) {
811         emissionInternal(_tokensCreatedInSTQ.mul(uint256(10) ** uint256(decimals)));
812     }
813 
814 
815     // FIELDS
816 
817     string public constant name = 'Storiqa Token';
818     string public constant symbol = 'STQ';
819     uint8 public constant decimals = 18;
820 }