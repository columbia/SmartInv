1 pragma solidity ^0.4.13;
2 
3 interface IEmissionPartMinter {
4     function mintPartOfEmission(address to, uint part, uint partOfEmissionForPublicSales) public;
5 }
6 
7 contract ArgumentsChecker {
8 
9     /// @dev check which prevents short address attack
10     modifier payloadSizeIs(uint size) {
11        require(msg.data.length == size + 4 /* function selector */);
12        _;
13     }
14 
15     /// @dev check that address is valid
16     modifier validAddress(address addr) {
17         require(addr != address(0));
18         _;
19     }
20 }
21 
22 contract MintableToken {
23     event Mint(address indexed to, uint256 amount);
24 
25     /// @dev mints new tokens
26     function mint(address _to, uint256 _amount) public;
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) public view returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) public view returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract multiowned {
44 
45 	// TYPES
46 
47     // struct for the status of a pending operation.
48     struct MultiOwnedOperationPendingState {
49         // count of confirmations needed
50         uint yetNeeded;
51 
52         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
53         uint ownersDone;
54 
55         // position of this operation key in m_multiOwnedPendingIndex
56         uint index;
57     }
58 
59 	// EVENTS
60 
61     event Confirmation(address owner, bytes32 operation);
62     event Revoke(address owner, bytes32 operation);
63     event FinalConfirmation(address owner, bytes32 operation);
64 
65     // some others are in the case of an owner changing.
66     event OwnerChanged(address oldOwner, address newOwner);
67     event OwnerAdded(address newOwner);
68     event OwnerRemoved(address oldOwner);
69 
70     // the last one is emitted if the required signatures change
71     event RequirementChanged(uint newRequirement);
72 
73 	// MODIFIERS
74 
75     // simple single-sig function modifier.
76     modifier onlyowner {
77         require(isOwner(msg.sender));
78         _;
79     }
80     // multi-sig function modifier: the operation must have an intrinsic hash in order
81     // that later attempts can be realised as the same underlying operation and
82     // thus count as confirmations.
83     modifier onlymanyowners(bytes32 _operation) {
84         if (confirmAndCheck(_operation)) {
85             _;
86         }
87         // Even if required number of confirmations has't been collected yet,
88         // we can't throw here - because changes to the state have to be preserved.
89         // But, confirmAndCheck itself will throw in case sender is not an owner.
90     }
91 
92     modifier validNumOwners(uint _numOwners) {
93         require(_numOwners > 0 && _numOwners <= c_maxOwners);
94         _;
95     }
96 
97     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
98         require(_required > 0 && _required <= _numOwners);
99         _;
100     }
101 
102     modifier ownerExists(address _address) {
103         require(isOwner(_address));
104         _;
105     }
106 
107     modifier ownerDoesNotExist(address _address) {
108         require(!isOwner(_address));
109         _;
110     }
111 
112     modifier multiOwnedOperationIsActive(bytes32 _operation) {
113         require(isOperationActive(_operation));
114         _;
115     }
116 
117 	// METHODS
118 
119     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
120     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
121     function multiowned(address[] _owners, uint _required)
122         public
123         validNumOwners(_owners.length)
124         multiOwnedValidRequirement(_required, _owners.length)
125     {
126         assert(c_maxOwners <= 255);
127 
128         m_numOwners = _owners.length;
129         m_multiOwnedRequired = _required;
130 
131         for (uint i = 0; i < _owners.length; ++i)
132         {
133             address owner = _owners[i];
134             // invalid and duplicate addresses are not allowed
135             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
136 
137             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
138             m_owners[currentOwnerIndex] = owner;
139             m_ownerIndex[owner] = currentOwnerIndex;
140         }
141 
142         assertOwnersAreConsistent();
143     }
144 
145     /// @notice replaces an owner `_from` with another `_to`.
146     /// @param _from address of owner to replace
147     /// @param _to address of new owner
148     // All pending operations will be canceled!
149     function changeOwner(address _from, address _to)
150         external
151         ownerExists(_from)
152         ownerDoesNotExist(_to)
153         onlymanyowners(keccak256(msg.data))
154     {
155         assertOwnersAreConsistent();
156 
157         clearPending();
158         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
159         m_owners[ownerIndex] = _to;
160         m_ownerIndex[_from] = 0;
161         m_ownerIndex[_to] = ownerIndex;
162 
163         assertOwnersAreConsistent();
164         OwnerChanged(_from, _to);
165     }
166 
167     /// @notice adds an owner
168     /// @param _owner address of new owner
169     // All pending operations will be canceled!
170     function addOwner(address _owner)
171         external
172         ownerDoesNotExist(_owner)
173         validNumOwners(m_numOwners + 1)
174         onlymanyowners(keccak256(msg.data))
175     {
176         assertOwnersAreConsistent();
177 
178         clearPending();
179         m_numOwners++;
180         m_owners[m_numOwners] = _owner;
181         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
182 
183         assertOwnersAreConsistent();
184         OwnerAdded(_owner);
185     }
186 
187     /// @notice removes an owner
188     /// @param _owner address of owner to remove
189     // All pending operations will be canceled!
190     function removeOwner(address _owner)
191         external
192         ownerExists(_owner)
193         validNumOwners(m_numOwners - 1)
194         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
195         onlymanyowners(keccak256(msg.data))
196     {
197         assertOwnersAreConsistent();
198 
199         clearPending();
200         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
201         m_owners[ownerIndex] = 0;
202         m_ownerIndex[_owner] = 0;
203         //make sure m_numOwners is equal to the number of owners and always points to the last owner
204         reorganizeOwners();
205 
206         assertOwnersAreConsistent();
207         OwnerRemoved(_owner);
208     }
209 
210     /// @notice changes the required number of owner signatures
211     /// @param _newRequired new number of signatures required
212     // All pending operations will be canceled!
213     function changeRequirement(uint _newRequired)
214         external
215         multiOwnedValidRequirement(_newRequired, m_numOwners)
216         onlymanyowners(keccak256(msg.data))
217     {
218         m_multiOwnedRequired = _newRequired;
219         clearPending();
220         RequirementChanged(_newRequired);
221     }
222 
223     /// @notice Gets an owner by 0-indexed position
224     /// @param ownerIndex 0-indexed owner position
225     function getOwner(uint ownerIndex) public constant returns (address) {
226         return m_owners[ownerIndex + 1];
227     }
228 
229     /// @notice Gets owners
230     /// @return memory array of owners
231     function getOwners() public constant returns (address[]) {
232         address[] memory result = new address[](m_numOwners);
233         for (uint i = 0; i < m_numOwners; i++)
234             result[i] = getOwner(i);
235 
236         return result;
237     }
238 
239     /// @notice checks if provided address is an owner address
240     /// @param _addr address to check
241     /// @return true if it's an owner
242     function isOwner(address _addr) public constant returns (bool) {
243         return m_ownerIndex[_addr] > 0;
244     }
245 
246     /// @notice Tests ownership of the current caller.
247     /// @return true if it's an owner
248     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
249     // addOwner/changeOwner and to isOwner.
250     function amIOwner() external constant onlyowner returns (bool) {
251         return true;
252     }
253 
254     /// @notice Revokes a prior confirmation of the given operation
255     /// @param _operation operation value, typically keccak256(msg.data)
256     function revoke(bytes32 _operation)
257         external
258         multiOwnedOperationIsActive(_operation)
259         onlyowner
260     {
261         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
262         var pending = m_multiOwnedPending[_operation];
263         require(pending.ownersDone & ownerIndexBit > 0);
264 
265         assertOperationIsConsistent(_operation);
266 
267         pending.yetNeeded++;
268         pending.ownersDone -= ownerIndexBit;
269 
270         assertOperationIsConsistent(_operation);
271         Revoke(msg.sender, _operation);
272     }
273 
274     /// @notice Checks if owner confirmed given operation
275     /// @param _operation operation value, typically keccak256(msg.data)
276     /// @param _owner an owner address
277     function hasConfirmed(bytes32 _operation, address _owner)
278         external
279         constant
280         multiOwnedOperationIsActive(_operation)
281         ownerExists(_owner)
282         returns (bool)
283     {
284         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
285     }
286 
287     // INTERNAL METHODS
288 
289     function confirmAndCheck(bytes32 _operation)
290         private
291         onlyowner
292         returns (bool)
293     {
294         if (512 == m_multiOwnedPendingIndex.length)
295             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
296             // we won't be able to do it because of block gas limit.
297             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
298             // TODO use more graceful approach like compact or removal of clearPending completely
299             clearPending();
300 
301         var pending = m_multiOwnedPending[_operation];
302 
303         // if we're not yet working on this operation, switch over and reset the confirmation status.
304         if (! isOperationActive(_operation)) {
305             // reset count of confirmations needed.
306             pending.yetNeeded = m_multiOwnedRequired;
307             // reset which owners have confirmed (none) - set our bitmap to 0.
308             pending.ownersDone = 0;
309             pending.index = m_multiOwnedPendingIndex.length++;
310             m_multiOwnedPendingIndex[pending.index] = _operation;
311             assertOperationIsConsistent(_operation);
312         }
313 
314         // determine the bit to set for this owner.
315         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
316         // make sure we (the message sender) haven't confirmed this operation previously.
317         if (pending.ownersDone & ownerIndexBit == 0) {
318             // ok - check if count is enough to go ahead.
319             assert(pending.yetNeeded > 0);
320             if (pending.yetNeeded == 1) {
321                 // enough confirmations: reset and run interior.
322                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
323                 delete m_multiOwnedPending[_operation];
324                 FinalConfirmation(msg.sender, _operation);
325                 return true;
326             }
327             else
328             {
329                 // not enough: record that this owner in particular confirmed.
330                 pending.yetNeeded--;
331                 pending.ownersDone |= ownerIndexBit;
332                 assertOperationIsConsistent(_operation);
333                 Confirmation(msg.sender, _operation);
334             }
335         }
336     }
337 
338     // Reclaims free slots between valid owners in m_owners.
339     // TODO given that its called after each removal, it could be simplified.
340     function reorganizeOwners() private {
341         uint free = 1;
342         while (free < m_numOwners)
343         {
344             // iterating to the first free slot from the beginning
345             while (free < m_numOwners && m_owners[free] != 0) free++;
346 
347             // iterating to the first occupied slot from the end
348             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
349 
350             // swap, if possible, so free slot is located at the end after the swap
351             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
352             {
353                 // owners between swapped slots should't be renumbered - that saves a lot of gas
354                 m_owners[free] = m_owners[m_numOwners];
355                 m_ownerIndex[m_owners[free]] = free;
356                 m_owners[m_numOwners] = 0;
357             }
358         }
359     }
360 
361     function clearPending() private onlyowner {
362         uint length = m_multiOwnedPendingIndex.length;
363         // TODO block gas limit
364         for (uint i = 0; i < length; ++i) {
365             if (m_multiOwnedPendingIndex[i] != 0)
366                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
367         }
368         delete m_multiOwnedPendingIndex;
369     }
370 
371     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
372         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
373         return ownerIndex;
374     }
375 
376     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
377         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
378         return 2 ** ownerIndex;
379     }
380 
381     function isOperationActive(bytes32 _operation) private constant returns (bool) {
382         return 0 != m_multiOwnedPending[_operation].yetNeeded;
383     }
384 
385 
386     function assertOwnersAreConsistent() private constant {
387         assert(m_numOwners > 0);
388         assert(m_numOwners <= c_maxOwners);
389         assert(m_owners[0] == 0);
390         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
391     }
392 
393     function assertOperationIsConsistent(bytes32 _operation) private constant {
394         var pending = m_multiOwnedPending[_operation];
395         assert(0 != pending.yetNeeded);
396         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
397         assert(pending.yetNeeded <= m_multiOwnedRequired);
398     }
399 
400 
401    	// FIELDS
402 
403     uint constant c_maxOwners = 250;
404 
405     // the number of owners that must confirm the same operation before it is run.
406     uint public m_multiOwnedRequired;
407 
408 
409     // pointer used to find a free slot in m_owners
410     uint public m_numOwners;
411 
412     // list of owners (addresses),
413     // slot 0 is unused so there are no owner which index is 0.
414     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
415     address[256] internal m_owners;
416 
417     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
418     mapping(address => uint) internal m_ownerIndex;
419 
420 
421     // the ongoing operations.
422     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
423     bytes32[] internal m_multiOwnedPendingIndex;
424 }
425 
426 interface IDetachable {
427     function detach() public;
428 }
429 
430 library SafeMath {
431   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
432     if (a == 0) {
433       return 0;
434     }
435     uint256 c = a * b;
436     assert(c / a == b);
437     return c;
438   }
439 
440   function div(uint256 a, uint256 b) internal pure returns (uint256) {
441     // assert(b > 0); // Solidity automatically throws when dividing by 0
442     uint256 c = a / b;
443     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
444     return c;
445   }
446 
447   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
448     assert(b <= a);
449     return a - b;
450   }
451 
452   function add(uint256 a, uint256 b) internal pure returns (uint256) {
453     uint256 c = a + b;
454     assert(c >= a);
455     return c;
456   }
457 }
458 
459 contract BasicToken is ERC20Basic {
460   using SafeMath for uint256;
461 
462   mapping(address => uint256) balances;
463 
464   /**
465   * @dev transfer token for a specified address
466   * @param _to The address to transfer to.
467   * @param _value The amount to be transferred.
468   */
469   function transfer(address _to, uint256 _value) public returns (bool) {
470     require(_to != address(0));
471     require(_value <= balances[msg.sender]);
472 
473     // SafeMath.sub will throw if there is not enough balance.
474     balances[msg.sender] = balances[msg.sender].sub(_value);
475     balances[_to] = balances[_to].add(_value);
476     Transfer(msg.sender, _to, _value);
477     return true;
478   }
479 
480   /**
481   * @dev Gets the balance of the specified address.
482   * @param _owner The address to query the the balance of.
483   * @return An uint256 representing the amount owned by the passed address.
484   */
485   function balanceOf(address _owner) public view returns (uint256 balance) {
486     return balances[_owner];
487   }
488 
489 }
490 
491 /**
492  * @title Contract tracks (in percents) token allocation to various pools and early investors.
493  *
494  * When all public sales are finished and absolute values of token emission
495  * are known, this pool percent-tokens are used to mint SMR tokens in
496  * appropriate amounts.
497  *
498  * See also SmartzTokenLifecycleManager.sol.
499  */
500 contract SmartzTokenEmissionPools is ArgumentsChecker, BasicToken, ERC20, multiowned, MintableToken {
501 
502     event Claimed(address indexed to, uint256 amount);
503 
504 
505     // PUBLIC FUNCTIONS
506 
507     function SmartzTokenEmissionPools(address[] _owners, uint _signaturesRequired, address _SMRMinter)
508         public
509         validAddress(_SMRMinter)
510         multiowned(_owners, _signaturesRequired)
511     {
512         m_SMRMinter = _SMRMinter;
513     }
514 
515 
516     /// @notice mints specified percent of token emission to pool
517     function mint(address _to, uint256 _amount)
518         public
519         payloadSizeIs(32 * 2)
520         validAddress(_to)
521         onlymanyowners(keccak256(msg.data))
522     {
523         require(!m_claimingIsActive);
524         require(_amount > 0 && _amount < publiclyDistributedParts());
525 
526         // record new holder to auxiliary structure
527         if (0 == balances[_to]) {
528             m_holders.push(_to);
529         }
530 
531         totalSupply = totalSupply.add(_amount);
532         balances[_to] = balances[_to].add(_amount);
533 
534         Transfer(address(0), _to, _amount);
535         Mint(_to, _amount);
536 
537         assert(publiclyDistributedParts() > 0);
538     }
539 
540     /// @notice get appropriate amount of SMR for msg.sender account
541     function claimSMR()
542         external
543     {
544         claimSMRFor(msg.sender);
545     }
546 
547     /// @notice iteratively distributes SMR according to SMRE possession to all SMRE holders and pools
548     function claimSMRforAll(uint invocationsLimit)
549         external
550     {
551         require(unclaimedPoolsPresent());
552 
553         uint invocations = 0;
554         uint maxGasPerInvocation = 0;
555         while (unclaimedPoolsPresent() && ++invocations <= invocationsLimit) {
556             uint startingGas = msg.gas;
557 
558             claimSMRFor(m_holders[m_unclaimedHolderIdx++]);
559 
560             uint gasPerInvocation = startingGas.sub(msg.gas);
561             if (gasPerInvocation > maxGasPerInvocation) {
562                 maxGasPerInvocation = gasPerInvocation;
563             }
564             if (maxGasPerInvocation.add(70000) > msg.gas) {
565                 break;  // enough invocations for this call
566             }
567         }
568 
569         if (! unclaimedPoolsPresent()) {
570             // all tokens claimed - detaching
571             IDetachable(m_SMRMinter).detach();
572         }
573     }
574 
575 
576     // VIEWS
577 
578     /// @dev amount of non-distributed SMRE
579     function publiclyDistributedParts() public view returns (uint) {
580         return maxSupply.sub(totalSupply);
581     }
582 
583     /// @dev are there parties which still have't received their SMR?
584     function unclaimedPoolsPresent() public view returns (bool) {
585         return m_unclaimedHolderIdx < m_holders.length;
586     }
587 
588 
589     /*
590      * PUBLIC FUNCTIONS: ERC20
591      *
592      * SMRE tokens are not transferable. ERC20 here is for convenience - to see balance in a wallet.
593      */
594 
595     function transfer(address /* to */, uint256 /* value */) public returns (bool) {
596         revert();
597     }
598 
599     function allowance(address /* owner */, address /* spender */) public view returns (uint256) {
600         revert();
601     }
602     function transferFrom(address /* from */, address /* to */, uint256 /* value */) public returns (bool) {
603         revert();
604     }
605 
606     function approve(address /* spender */, uint256 /* value */) public returns (bool) {
607         revert();
608     }
609 
610 
611     // INTERNAL
612 
613     /// @dev mint SMR tokens for SMRE holder
614     function claimSMRFor(address _for)
615         private
616     {
617         assert(_for != address(0));
618 
619         require(0 != balances[_for]);
620         if (m_tokensClaimed[_for])
621             return;
622 
623         m_tokensClaimed[_for] = true;
624 
625         uint part = balances[_for];
626         uint partOfEmissionForPublicSales = publiclyDistributedParts();
627 
628         // If it's too early (not an appropriate SMR lifecycle stage, see SmartzTokenLifecycleManager),
629         // m_SMRMinter will revert() and all changes to the state of this contract will be rolled back.
630         IEmissionPartMinter(m_SMRMinter).mintPartOfEmission(_for, part, partOfEmissionForPublicSales);
631 
632         if (! m_claimingIsActive) {
633             m_claimingIsActive = true;
634         }
635 
636         Claimed(_for, part);
637     }
638 
639 
640     // FIELDS
641 
642     /// @dev IDetachable IEmissionPartMinter
643     address public m_SMRMinter;
644 
645     /// @dev list of all SMRE holders
646     address[] public m_holders;
647 
648     /// @dev index in m_holders which is scheduled next for SMRE->SMR conversion
649     uint public m_unclaimedHolderIdx;
650 
651     /// @dev keeps track of pool which claimed their SMR
652     /// As they could do it manually, out-of-order, m_unclaimedHolderIdx is not enough.
653     mapping(address => bool) public m_tokensClaimed;
654 
655     /// @dev true iff SMRE->SMR conversion is active and SMRE will no longer be minted
656     bool public m_claimingIsActive = false;
657 
658 
659     // CONSTANTS
660 
661     string public constant name = "Part of Smartz token emission";
662     string public constant symbol = "SMRE";
663     uint8 public constant decimals = 2;
664 
665     // @notice maximum amount of SMRE to be allocated, in smallest units (1/100 of percent)
666     uint public constant maxSupply = uint(100) * (uint(10) ** uint(decimals));
667 }