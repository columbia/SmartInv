1 pragma solidity ^0.4.13;
2 
3 contract MintableToken {
4     event Mint(address indexed to, uint256 amount);
5 
6     /// @dev mints new tokens
7     function mint(address _to, uint256 _amount) public;
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 interface IApprovalRecipient {
40     /**
41      * @notice Signals that token holder approved spending of tokens and some action should be taken.
42      *
43      * @param _sender token holder which approved spending of his tokens
44      * @param _value amount of tokens approved to be spent
45      * @param _extraData any extra data token holder provided to the call
46      *
47      * @dev warning: implementors should validate sender of this message (it should be the token) and make no further
48      *      assumptions unless validated them via ERC20 methods.
49      */
50     function receiveApproval(address _sender, uint256 _value, bytes _extraData) public;
51 }
52 
53 contract multiowned {
54 
55 	// TYPES
56 
57     // struct for the status of a pending operation.
58     struct MultiOwnedOperationPendingState {
59         // count of confirmations needed
60         uint yetNeeded;
61 
62         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
63         uint ownersDone;
64 
65         // position of this operation key in m_multiOwnedPendingIndex
66         uint index;
67     }
68 
69 	// EVENTS
70 
71     event Confirmation(address owner, bytes32 operation);
72     event Revoke(address owner, bytes32 operation);
73     event FinalConfirmation(address owner, bytes32 operation);
74 
75     // some others are in the case of an owner changing.
76     event OwnerChanged(address oldOwner, address newOwner);
77     event OwnerAdded(address newOwner);
78     event OwnerRemoved(address oldOwner);
79 
80     // the last one is emitted if the required signatures change
81     event RequirementChanged(uint newRequirement);
82 
83 	// MODIFIERS
84 
85     // simple single-sig function modifier.
86     modifier onlyowner {
87         require(isOwner(msg.sender));
88         _;
89     }
90     // multi-sig function modifier: the operation must have an intrinsic hash in order
91     // that later attempts can be realised as the same underlying operation and
92     // thus count as confirmations.
93     modifier onlymanyowners(bytes32 _operation) {
94         if (confirmAndCheck(_operation)) {
95             _;
96         }
97         // Even if required number of confirmations has't been collected yet,
98         // we can't throw here - because changes to the state have to be preserved.
99         // But, confirmAndCheck itself will throw in case sender is not an owner.
100     }
101 
102     modifier validNumOwners(uint _numOwners) {
103         require(_numOwners > 0 && _numOwners <= c_maxOwners);
104         _;
105     }
106 
107     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
108         require(_required > 0 && _required <= _numOwners);
109         _;
110     }
111 
112     modifier ownerExists(address _address) {
113         require(isOwner(_address));
114         _;
115     }
116 
117     modifier ownerDoesNotExist(address _address) {
118         require(!isOwner(_address));
119         _;
120     }
121 
122     modifier multiOwnedOperationIsActive(bytes32 _operation) {
123         require(isOperationActive(_operation));
124         _;
125     }
126 
127 	// METHODS
128 
129     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
130     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
131     function multiowned(address[] _owners, uint _required)
132         public
133         validNumOwners(_owners.length)
134         multiOwnedValidRequirement(_required, _owners.length)
135     {
136         assert(c_maxOwners <= 255);
137 
138         m_numOwners = _owners.length;
139         m_multiOwnedRequired = _required;
140 
141         for (uint i = 0; i < _owners.length; ++i)
142         {
143             address owner = _owners[i];
144             // invalid and duplicate addresses are not allowed
145             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
146 
147             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
148             m_owners[currentOwnerIndex] = owner;
149             m_ownerIndex[owner] = currentOwnerIndex;
150         }
151 
152         assertOwnersAreConsistent();
153     }
154 
155     /// @notice replaces an owner `_from` with another `_to`.
156     /// @param _from address of owner to replace
157     /// @param _to address of new owner
158     // All pending operations will be canceled!
159     function changeOwner(address _from, address _to)
160         external
161         ownerExists(_from)
162         ownerDoesNotExist(_to)
163         onlymanyowners(keccak256(msg.data))
164     {
165         assertOwnersAreConsistent();
166 
167         clearPending();
168         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
169         m_owners[ownerIndex] = _to;
170         m_ownerIndex[_from] = 0;
171         m_ownerIndex[_to] = ownerIndex;
172 
173         assertOwnersAreConsistent();
174         OwnerChanged(_from, _to);
175     }
176 
177     /// @notice adds an owner
178     /// @param _owner address of new owner
179     // All pending operations will be canceled!
180     function addOwner(address _owner)
181         external
182         ownerDoesNotExist(_owner)
183         validNumOwners(m_numOwners + 1)
184         onlymanyowners(keccak256(msg.data))
185     {
186         assertOwnersAreConsistent();
187 
188         clearPending();
189         m_numOwners++;
190         m_owners[m_numOwners] = _owner;
191         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
192 
193         assertOwnersAreConsistent();
194         OwnerAdded(_owner);
195     }
196 
197     /// @notice removes an owner
198     /// @param _owner address of owner to remove
199     // All pending operations will be canceled!
200     function removeOwner(address _owner)
201         external
202         ownerExists(_owner)
203         validNumOwners(m_numOwners - 1)
204         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
205         onlymanyowners(keccak256(msg.data))
206     {
207         assertOwnersAreConsistent();
208 
209         clearPending();
210         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
211         m_owners[ownerIndex] = 0;
212         m_ownerIndex[_owner] = 0;
213         //make sure m_numOwners is equal to the number of owners and always points to the last owner
214         reorganizeOwners();
215 
216         assertOwnersAreConsistent();
217         OwnerRemoved(_owner);
218     }
219 
220     /// @notice changes the required number of owner signatures
221     /// @param _newRequired new number of signatures required
222     // All pending operations will be canceled!
223     function changeRequirement(uint _newRequired)
224         external
225         multiOwnedValidRequirement(_newRequired, m_numOwners)
226         onlymanyowners(keccak256(msg.data))
227     {
228         m_multiOwnedRequired = _newRequired;
229         clearPending();
230         RequirementChanged(_newRequired);
231     }
232 
233     /// @notice Gets an owner by 0-indexed position
234     /// @param ownerIndex 0-indexed owner position
235     function getOwner(uint ownerIndex) public constant returns (address) {
236         return m_owners[ownerIndex + 1];
237     }
238 
239     /// @notice Gets owners
240     /// @return memory array of owners
241     function getOwners() public constant returns (address[]) {
242         address[] memory result = new address[](m_numOwners);
243         for (uint i = 0; i < m_numOwners; i++)
244             result[i] = getOwner(i);
245 
246         return result;
247     }
248 
249     /// @notice checks if provided address is an owner address
250     /// @param _addr address to check
251     /// @return true if it's an owner
252     function isOwner(address _addr) public constant returns (bool) {
253         return m_ownerIndex[_addr] > 0;
254     }
255 
256     /// @notice Tests ownership of the current caller.
257     /// @return true if it's an owner
258     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
259     // addOwner/changeOwner and to isOwner.
260     function amIOwner() external constant onlyowner returns (bool) {
261         return true;
262     }
263 
264     /// @notice Revokes a prior confirmation of the given operation
265     /// @param _operation operation value, typically keccak256(msg.data)
266     function revoke(bytes32 _operation)
267         external
268         multiOwnedOperationIsActive(_operation)
269         onlyowner
270     {
271         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
272         var pending = m_multiOwnedPending[_operation];
273         require(pending.ownersDone & ownerIndexBit > 0);
274 
275         assertOperationIsConsistent(_operation);
276 
277         pending.yetNeeded++;
278         pending.ownersDone -= ownerIndexBit;
279 
280         assertOperationIsConsistent(_operation);
281         Revoke(msg.sender, _operation);
282     }
283 
284     /// @notice Checks if owner confirmed given operation
285     /// @param _operation operation value, typically keccak256(msg.data)
286     /// @param _owner an owner address
287     function hasConfirmed(bytes32 _operation, address _owner)
288         external
289         constant
290         multiOwnedOperationIsActive(_operation)
291         ownerExists(_owner)
292         returns (bool)
293     {
294         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
295     }
296 
297     // INTERNAL METHODS
298 
299     function confirmAndCheck(bytes32 _operation)
300         private
301         onlyowner
302         returns (bool)
303     {
304         if (512 == m_multiOwnedPendingIndex.length)
305             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
306             // we won't be able to do it because of block gas limit.
307             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
308             // TODO use more graceful approach like compact or removal of clearPending completely
309             clearPending();
310 
311         var pending = m_multiOwnedPending[_operation];
312 
313         // if we're not yet working on this operation, switch over and reset the confirmation status.
314         if (! isOperationActive(_operation)) {
315             // reset count of confirmations needed.
316             pending.yetNeeded = m_multiOwnedRequired;
317             // reset which owners have confirmed (none) - set our bitmap to 0.
318             pending.ownersDone = 0;
319             pending.index = m_multiOwnedPendingIndex.length++;
320             m_multiOwnedPendingIndex[pending.index] = _operation;
321             assertOperationIsConsistent(_operation);
322         }
323 
324         // determine the bit to set for this owner.
325         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
326         // make sure we (the message sender) haven't confirmed this operation previously.
327         if (pending.ownersDone & ownerIndexBit == 0) {
328             // ok - check if count is enough to go ahead.
329             assert(pending.yetNeeded > 0);
330             if (pending.yetNeeded == 1) {
331                 // enough confirmations: reset and run interior.
332                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
333                 delete m_multiOwnedPending[_operation];
334                 FinalConfirmation(msg.sender, _operation);
335                 return true;
336             }
337             else
338             {
339                 // not enough: record that this owner in particular confirmed.
340                 pending.yetNeeded--;
341                 pending.ownersDone |= ownerIndexBit;
342                 assertOperationIsConsistent(_operation);
343                 Confirmation(msg.sender, _operation);
344             }
345         }
346     }
347 
348     // Reclaims free slots between valid owners in m_owners.
349     // TODO given that its called after each removal, it could be simplified.
350     function reorganizeOwners() private {
351         uint free = 1;
352         while (free < m_numOwners)
353         {
354             // iterating to the first free slot from the beginning
355             while (free < m_numOwners && m_owners[free] != 0) free++;
356 
357             // iterating to the first occupied slot from the end
358             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
359 
360             // swap, if possible, so free slot is located at the end after the swap
361             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
362             {
363                 // owners between swapped slots should't be renumbered - that saves a lot of gas
364                 m_owners[free] = m_owners[m_numOwners];
365                 m_ownerIndex[m_owners[free]] = free;
366                 m_owners[m_numOwners] = 0;
367             }
368         }
369     }
370 
371     function clearPending() private onlyowner {
372         uint length = m_multiOwnedPendingIndex.length;
373         // TODO block gas limit
374         for (uint i = 0; i < length; ++i) {
375             if (m_multiOwnedPendingIndex[i] != 0)
376                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
377         }
378         delete m_multiOwnedPendingIndex;
379     }
380 
381     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
382         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
383         return ownerIndex;
384     }
385 
386     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
387         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
388         return 2 ** ownerIndex;
389     }
390 
391     function isOperationActive(bytes32 _operation) private constant returns (bool) {
392         return 0 != m_multiOwnedPending[_operation].yetNeeded;
393     }
394 
395 
396     function assertOwnersAreConsistent() private constant {
397         assert(m_numOwners > 0);
398         assert(m_numOwners <= c_maxOwners);
399         assert(m_owners[0] == 0);
400         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
401     }
402 
403     function assertOperationIsConsistent(bytes32 _operation) private constant {
404         var pending = m_multiOwnedPending[_operation];
405         assert(0 != pending.yetNeeded);
406         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
407         assert(pending.yetNeeded <= m_multiOwnedRequired);
408     }
409 
410 
411    	// FIELDS
412 
413     uint constant c_maxOwners = 250;
414 
415     // the number of owners that must confirm the same operation before it is run.
416     uint public m_multiOwnedRequired;
417 
418 
419     // pointer used to find a free slot in m_owners
420     uint public m_numOwners;
421 
422     // list of owners (addresses),
423     // slot 0 is unused so there are no owner which index is 0.
424     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
425     address[256] internal m_owners;
426 
427     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
428     mapping(address => uint) internal m_ownerIndex;
429 
430 
431     // the ongoing operations.
432     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
433     bytes32[] internal m_multiOwnedPendingIndex;
434 }
435 
436 contract ERC20Basic {
437   uint256 public totalSupply;
438   function balanceOf(address who) public view returns (uint256);
439   function transfer(address to, uint256 value) public returns (bool);
440   event Transfer(address indexed from, address indexed to, uint256 value);
441 }
442 
443 contract BasicToken is ERC20Basic {
444   using SafeMath for uint256;
445 
446   mapping(address => uint256) balances;
447 
448   /**
449   * @dev transfer token for a specified address
450   * @param _to The address to transfer to.
451   * @param _value The amount to be transferred.
452   */
453   function transfer(address _to, uint256 _value) public returns (bool) {
454     require(_to != address(0));
455     require(_value <= balances[msg.sender]);
456 
457     // SafeMath.sub will throw if there is not enough balance.
458     balances[msg.sender] = balances[msg.sender].sub(_value);
459     balances[_to] = balances[_to].add(_value);
460     Transfer(msg.sender, _to, _value);
461     return true;
462   }
463 
464   /**
465   * @dev Gets the balance of the specified address.
466   * @param _owner The address to query the the balance of.
467   * @return An uint256 representing the amount owned by the passed address.
468   */
469   function balanceOf(address _owner) public view returns (uint256 balance) {
470     return balances[_owner];
471   }
472 
473 }
474 
475 contract MultiownedControlled is multiowned {
476 
477     event ControllerSet(address controller);
478     event ControllerRetired(address was);
479     event ControllerRetiredForever(address was);
480 
481 
482     modifier onlyController {
483         require(msg.sender == m_controller);
484         _;
485     }
486 
487 
488     // PUBLIC interface
489 
490     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
491         public
492         multiowned(_owners, _signaturesRequired)
493     {
494         m_controller = _controller;
495         ControllerSet(m_controller);
496     }
497 
498     /// @dev sets the controller
499     function setController(address _controller) external onlymanyowners(keccak256(msg.data)) {
500         require(m_attaching_enabled);
501         m_controller = _controller;
502         ControllerSet(m_controller);
503     }
504 
505     /// @dev ability for controller to step down
506     function detachController() external onlyController {
507         address was = m_controller;
508         m_controller = address(0);
509         ControllerRetired(was);
510     }
511 
512     /// @dev ability for controller to step down and make this contract completely automatic (without third-party control)
513     function detachControllerForever() external onlyController {
514         assert(m_attaching_enabled);
515         address was = m_controller;
516         m_controller = address(0);
517         m_attaching_enabled = false;
518         ControllerRetiredForever(was);
519     }
520 
521 
522     // FIELDS
523 
524     /// @notice address of entity entitled to mint new tokens
525     address public m_controller;
526 
527     bool public m_attaching_enabled = true;
528 }
529 
530 contract ERC20 is ERC20Basic {
531   function allowance(address owner, address spender) public view returns (uint256);
532   function transferFrom(address from, address to, uint256 value) public returns (bool);
533   function approve(address spender, uint256 value) public returns (bool);
534   event Approval(address indexed owner, address indexed spender, uint256 value);
535 }
536 
537 contract StandardToken is ERC20, BasicToken {
538 
539   mapping (address => mapping (address => uint256)) internal allowed;
540 
541 
542   /**
543    * @dev Transfer tokens from one address to another
544    * @param _from address The address which you want to send tokens from
545    * @param _to address The address which you want to transfer to
546    * @param _value uint256 the amount of tokens to be transferred
547    */
548   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
549     require(_to != address(0));
550     require(_value <= balances[_from]);
551     require(_value <= allowed[_from][msg.sender]);
552 
553     balances[_from] = balances[_from].sub(_value);
554     balances[_to] = balances[_to].add(_value);
555     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
556     Transfer(_from, _to, _value);
557     return true;
558   }
559 
560   /**
561    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
562    *
563    * Beware that changing an allowance with this method brings the risk that someone may use both the old
564    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
565    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
566    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
567    * @param _spender The address which will spend the funds.
568    * @param _value The amount of tokens to be spent.
569    */
570   function approve(address _spender, uint256 _value) public returns (bool) {
571     allowed[msg.sender][_spender] = _value;
572     Approval(msg.sender, _spender, _value);
573     return true;
574   }
575 
576   /**
577    * @dev Function to check the amount of tokens that an owner allowed to a spender.
578    * @param _owner address The address which owns the funds.
579    * @param _spender address The address which will spend the funds.
580    * @return A uint256 specifying the amount of tokens still available for the spender.
581    */
582   function allowance(address _owner, address _spender) public view returns (uint256) {
583     return allowed[_owner][_spender];
584   }
585 
586   /**
587    * approve should be called when allowed[_spender] == 0. To increment
588    * allowed value is better to use this function to avoid 2 calls (and wait until
589    * the first transaction is mined)
590    * From MonolithDAO Token.sol
591    */
592   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
593     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
594     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
595     return true;
596   }
597 
598   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
599     uint oldValue = allowed[msg.sender][_spender];
600     if (_subtractedValue > oldValue) {
601       allowed[msg.sender][_spender] = 0;
602     } else {
603       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
604     }
605     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
606     return true;
607   }
608 
609 }
610 
611 contract MintableMultiownedToken is MintableToken, MultiownedControlled, StandardToken {
612 
613     // PUBLIC interface
614 
615     function MintableMultiownedToken(address[] _owners, uint _signaturesRequired, address _minter)
616         public
617         MultiownedControlled(_owners, _signaturesRequired, _minter)
618     {
619     }
620 
621 
622     /// @dev mints new tokens
623     function mint(address _to, uint256 _amount) public onlyController {
624         require(m_externalMintingEnabled);
625         mintInternal(_to, _amount);
626     }
627 
628     /// @dev disables mint(), irreversible!
629     function disableMinting() public onlyController {
630         require(m_externalMintingEnabled);
631         m_externalMintingEnabled = false;
632     }
633 
634 
635     // INTERNAL functions
636 
637     function mintInternal(address _to, uint256 _amount) internal {
638         totalSupply = totalSupply.add(_amount);
639         balances[_to] = balances[_to].add(_amount);
640         Transfer(address(0), _to, _amount);
641         Mint(_to, _amount);
642     }
643 
644 
645     // FIELDS
646 
647     /// @notice if this true then token is still externally mintable
648     bool public m_externalMintingEnabled = true;
649 }
650 
651 contract CirculatingToken is StandardToken {
652 
653     event CirculationEnabled();
654 
655     modifier requiresCirculation {
656         require(m_isCirculating);
657         _;
658     }
659 
660 
661     // PUBLIC interface
662 
663     function transfer(address _to, uint256 _value) public requiresCirculation returns (bool) {
664         return super.transfer(_to, _value);
665     }
666 
667     function transferFrom(address _from, address _to, uint256 _value) public requiresCirculation returns (bool) {
668         return super.transferFrom(_from, _to, _value);
669     }
670 
671     function approve(address _spender, uint256 _value) public requiresCirculation returns (bool) {
672         return super.approve(_spender, _value);
673     }
674 
675 
676     // INTERNAL functions
677 
678     function enableCirculation() internal returns (bool) {
679         if (m_isCirculating)
680             return false;
681 
682         m_isCirculating = true;
683         CirculationEnabled();
684         return true;
685     }
686 
687 
688     // FIELDS
689 
690     /// @notice are the circulation started?
691     bool public m_isCirculating;
692 }
693 
694 contract SmartzToken is CirculatingToken, MintableMultiownedToken {
695 
696     event Burn(address indexed from, uint256 amount);
697 
698 
699     // PUBLIC FUNCTIONS
700 
701     /**
702      * @notice Constructs token.
703      *
704      * @param _initialOwners initial multi-signatures, see comment below
705      * @param _signaturesRequired quorum of multi-signatures
706      *
707      * Initial owners have power over the token contract only during bootstrap phase (early investments and token
708      * sales). After final token sale any control over the token removed by issuing detachControllerForever call.
709      * For lifecycle example please see test/SmartzTokenTest.js, 'test full lifecycle'.
710      */
711     function SmartzToken(address[] _initialOwners, uint _signaturesRequired)
712         public
713         MintableMultiownedToken(_initialOwners, _signaturesRequired, address(0))
714     {
715     }
716 
717     /**
718      * Function to burn msg.sender's tokens.
719      *
720      * @param _amount The amount of tokens to burn
721      *
722      * @return A boolean that indicates if the operation was successful.
723      */
724     function burn(uint256 _amount) public returns (bool) {
725         address from = msg.sender;
726         require(_amount > 0);
727         require(_amount <= balances[from]);
728 
729         totalSupply = totalSupply.sub(_amount);
730         balances[from] = balances[from].sub(_amount);
731         Burn(from, _amount);
732         Transfer(from, address(0), _amount);
733 
734         return true;
735     }
736 
737     /**
738      * @notice Approves spending tokens and immediately triggers token recipient logic.
739      *
740      * @param _spender contract which supports IApprovalRecipient and allowed to receive tokens
741      * @param _value amount of tokens approved to be spent
742      * @param _extraData any extra data which to be provided to the _spender
743      *
744      * By invoking this utility function token holder could do two things in one transaction: approve spending his
745      * tokens and execute some external contract which spends them on token holder's behalf.
746      * It can't be known if _spender's invocation succeed or not.
747      * This function will throw if approval failed.
748      */
749     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public {
750         require(approve(_spender, _value));
751         IApprovalRecipient(_spender).receiveApproval(msg.sender, _value, _extraData);
752     }
753 
754 
755     // ADMINISTRATIVE FUNCTIONS
756 
757     function startCirculation() external onlyController returns (bool) {
758         return enableCirculation();
759     }
760 
761 
762     // CONSTANTS
763 
764     string public constant name = "Smartz token";
765     string public constant symbol = "SMR";
766     uint8 public constant decimals = 18;
767 }