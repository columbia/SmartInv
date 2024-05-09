1 pragma solidity ^0.4.13;
2 
3 contract ArgumentsChecker {
4 
5     /// @dev check which prevents short address attack
6     modifier payloadSizeIs(uint size) {
7        require(msg.data.length == size + 4 /* function selector */);
8        _;
9     }
10 
11     /// @dev check that address is valid
12     modifier validAddress(address addr) {
13         require(addr != address(0));
14         _;
15     }
16 }
17 
18 contract MintableToken {
19     event Mint(address indexed to, uint256 amount);
20 
21     /// @dev mints new tokens
22     function mint(address _to, uint256 _amount) public;
23 }
24 
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 interface IApprovalRecipient {
55     /**
56      * @notice Signals that token holder approved spending of tokens and some action should be taken.
57      *
58      * @param _sender token holder which approved spending of his tokens
59      * @param _value amount of tokens approved to be spent
60      * @param _extraData any extra data token holder provided to the call
61      *
62      * @dev warning: implementors should validate sender of this message (it should be the token) and make no further
63      *      assumptions unless validated them via ERC20 methods.
64      */
65     function receiveApproval(address _sender, uint256 _value, bytes _extraData) public;
66 }
67 
68 interface IDetachable {
69     function detach() public;
70 }
71 
72 contract multiowned {
73 
74 	// TYPES
75 
76     // struct for the status of a pending operation.
77     struct MultiOwnedOperationPendingState {
78         // count of confirmations needed
79         uint yetNeeded;
80 
81         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
82         uint ownersDone;
83 
84         // position of this operation key in m_multiOwnedPendingIndex
85         uint index;
86     }
87 
88 	// EVENTS
89 
90     event Confirmation(address owner, bytes32 operation);
91     event Revoke(address owner, bytes32 operation);
92     event FinalConfirmation(address owner, bytes32 operation);
93 
94     // some others are in the case of an owner changing.
95     event OwnerChanged(address oldOwner, address newOwner);
96     event OwnerAdded(address newOwner);
97     event OwnerRemoved(address oldOwner);
98 
99     // the last one is emitted if the required signatures change
100     event RequirementChanged(uint newRequirement);
101 
102 	// MODIFIERS
103 
104     // simple single-sig function modifier.
105     modifier onlyowner {
106         require(isOwner(msg.sender));
107         _;
108     }
109     // multi-sig function modifier: the operation must have an intrinsic hash in order
110     // that later attempts can be realised as the same underlying operation and
111     // thus count as confirmations.
112     modifier onlymanyowners(bytes32 _operation) {
113         if (confirmAndCheck(_operation)) {
114             _;
115         }
116         // Even if required number of confirmations has't been collected yet,
117         // we can't throw here - because changes to the state have to be preserved.
118         // But, confirmAndCheck itself will throw in case sender is not an owner.
119     }
120 
121     modifier validNumOwners(uint _numOwners) {
122         require(_numOwners > 0 && _numOwners <= c_maxOwners);
123         _;
124     }
125 
126     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
127         require(_required > 0 && _required <= _numOwners);
128         _;
129     }
130 
131     modifier ownerExists(address _address) {
132         require(isOwner(_address));
133         _;
134     }
135 
136     modifier ownerDoesNotExist(address _address) {
137         require(!isOwner(_address));
138         _;
139     }
140 
141     modifier multiOwnedOperationIsActive(bytes32 _operation) {
142         require(isOperationActive(_operation));
143         _;
144     }
145 
146 	// METHODS
147 
148     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
149     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
150     function multiowned(address[] _owners, uint _required)
151         public
152         validNumOwners(_owners.length)
153         multiOwnedValidRequirement(_required, _owners.length)
154     {
155         assert(c_maxOwners <= 255);
156 
157         m_numOwners = _owners.length;
158         m_multiOwnedRequired = _required;
159 
160         for (uint i = 0; i < _owners.length; ++i)
161         {
162             address owner = _owners[i];
163             // invalid and duplicate addresses are not allowed
164             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
165 
166             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
167             m_owners[currentOwnerIndex] = owner;
168             m_ownerIndex[owner] = currentOwnerIndex;
169         }
170 
171         assertOwnersAreConsistent();
172     }
173 
174     /// @notice replaces an owner `_from` with another `_to`.
175     /// @param _from address of owner to replace
176     /// @param _to address of new owner
177     // All pending operations will be canceled!
178     function changeOwner(address _from, address _to)
179         external
180         ownerExists(_from)
181         ownerDoesNotExist(_to)
182         onlymanyowners(keccak256(msg.data))
183     {
184         assertOwnersAreConsistent();
185 
186         clearPending();
187         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
188         m_owners[ownerIndex] = _to;
189         m_ownerIndex[_from] = 0;
190         m_ownerIndex[_to] = ownerIndex;
191 
192         assertOwnersAreConsistent();
193         OwnerChanged(_from, _to);
194     }
195 
196     /// @notice adds an owner
197     /// @param _owner address of new owner
198     // All pending operations will be canceled!
199     function addOwner(address _owner)
200         external
201         ownerDoesNotExist(_owner)
202         validNumOwners(m_numOwners + 1)
203         onlymanyowners(keccak256(msg.data))
204     {
205         assertOwnersAreConsistent();
206 
207         clearPending();
208         m_numOwners++;
209         m_owners[m_numOwners] = _owner;
210         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
211 
212         assertOwnersAreConsistent();
213         OwnerAdded(_owner);
214     }
215 
216     /// @notice removes an owner
217     /// @param _owner address of owner to remove
218     // All pending operations will be canceled!
219     function removeOwner(address _owner)
220         external
221         ownerExists(_owner)
222         validNumOwners(m_numOwners - 1)
223         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
224         onlymanyowners(keccak256(msg.data))
225     {
226         assertOwnersAreConsistent();
227 
228         clearPending();
229         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
230         m_owners[ownerIndex] = 0;
231         m_ownerIndex[_owner] = 0;
232         //make sure m_numOwners is equal to the number of owners and always points to the last owner
233         reorganizeOwners();
234 
235         assertOwnersAreConsistent();
236         OwnerRemoved(_owner);
237     }
238 
239     /// @notice changes the required number of owner signatures
240     /// @param _newRequired new number of signatures required
241     // All pending operations will be canceled!
242     function changeRequirement(uint _newRequired)
243         external
244         multiOwnedValidRequirement(_newRequired, m_numOwners)
245         onlymanyowners(keccak256(msg.data))
246     {
247         m_multiOwnedRequired = _newRequired;
248         clearPending();
249         RequirementChanged(_newRequired);
250     }
251 
252     /// @notice Gets an owner by 0-indexed position
253     /// @param ownerIndex 0-indexed owner position
254     function getOwner(uint ownerIndex) public constant returns (address) {
255         return m_owners[ownerIndex + 1];
256     }
257 
258     /// @notice Gets owners
259     /// @return memory array of owners
260     function getOwners() public constant returns (address[]) {
261         address[] memory result = new address[](m_numOwners);
262         for (uint i = 0; i < m_numOwners; i++)
263             result[i] = getOwner(i);
264 
265         return result;
266     }
267 
268     /// @notice checks if provided address is an owner address
269     /// @param _addr address to check
270     /// @return true if it's an owner
271     function isOwner(address _addr) public constant returns (bool) {
272         return m_ownerIndex[_addr] > 0;
273     }
274 
275     /// @notice Tests ownership of the current caller.
276     /// @return true if it's an owner
277     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
278     // addOwner/changeOwner and to isOwner.
279     function amIOwner() external constant onlyowner returns (bool) {
280         return true;
281     }
282 
283     /// @notice Revokes a prior confirmation of the given operation
284     /// @param _operation operation value, typically keccak256(msg.data)
285     function revoke(bytes32 _operation)
286         external
287         multiOwnedOperationIsActive(_operation)
288         onlyowner
289     {
290         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
291         var pending = m_multiOwnedPending[_operation];
292         require(pending.ownersDone & ownerIndexBit > 0);
293 
294         assertOperationIsConsistent(_operation);
295 
296         pending.yetNeeded++;
297         pending.ownersDone -= ownerIndexBit;
298 
299         assertOperationIsConsistent(_operation);
300         Revoke(msg.sender, _operation);
301     }
302 
303     /// @notice Checks if owner confirmed given operation
304     /// @param _operation operation value, typically keccak256(msg.data)
305     /// @param _owner an owner address
306     function hasConfirmed(bytes32 _operation, address _owner)
307         external
308         constant
309         multiOwnedOperationIsActive(_operation)
310         ownerExists(_owner)
311         returns (bool)
312     {
313         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
314     }
315 
316     // INTERNAL METHODS
317 
318     function confirmAndCheck(bytes32 _operation)
319         private
320         onlyowner
321         returns (bool)
322     {
323         if (512 == m_multiOwnedPendingIndex.length)
324             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
325             // we won't be able to do it because of block gas limit.
326             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
327             // TODO use more graceful approach like compact or removal of clearPending completely
328             clearPending();
329 
330         var pending = m_multiOwnedPending[_operation];
331 
332         // if we're not yet working on this operation, switch over and reset the confirmation status.
333         if (! isOperationActive(_operation)) {
334             // reset count of confirmations needed.
335             pending.yetNeeded = m_multiOwnedRequired;
336             // reset which owners have confirmed (none) - set our bitmap to 0.
337             pending.ownersDone = 0;
338             pending.index = m_multiOwnedPendingIndex.length++;
339             m_multiOwnedPendingIndex[pending.index] = _operation;
340             assertOperationIsConsistent(_operation);
341         }
342 
343         // determine the bit to set for this owner.
344         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
345         // make sure we (the message sender) haven't confirmed this operation previously.
346         if (pending.ownersDone & ownerIndexBit == 0) {
347             // ok - check if count is enough to go ahead.
348             assert(pending.yetNeeded > 0);
349             if (pending.yetNeeded == 1) {
350                 // enough confirmations: reset and run interior.
351                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
352                 delete m_multiOwnedPending[_operation];
353                 FinalConfirmation(msg.sender, _operation);
354                 return true;
355             }
356             else
357             {
358                 // not enough: record that this owner in particular confirmed.
359                 pending.yetNeeded--;
360                 pending.ownersDone |= ownerIndexBit;
361                 assertOperationIsConsistent(_operation);
362                 Confirmation(msg.sender, _operation);
363             }
364         }
365     }
366 
367     // Reclaims free slots between valid owners in m_owners.
368     // TODO given that its called after each removal, it could be simplified.
369     function reorganizeOwners() private {
370         uint free = 1;
371         while (free < m_numOwners)
372         {
373             // iterating to the first free slot from the beginning
374             while (free < m_numOwners && m_owners[free] != 0) free++;
375 
376             // iterating to the first occupied slot from the end
377             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
378 
379             // swap, if possible, so free slot is located at the end after the swap
380             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
381             {
382                 // owners between swapped slots should't be renumbered - that saves a lot of gas
383                 m_owners[free] = m_owners[m_numOwners];
384                 m_ownerIndex[m_owners[free]] = free;
385                 m_owners[m_numOwners] = 0;
386             }
387         }
388     }
389 
390     function clearPending() private onlyowner {
391         uint length = m_multiOwnedPendingIndex.length;
392         // TODO block gas limit
393         for (uint i = 0; i < length; ++i) {
394             if (m_multiOwnedPendingIndex[i] != 0)
395                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
396         }
397         delete m_multiOwnedPendingIndex;
398     }
399 
400     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
401         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
402         return ownerIndex;
403     }
404 
405     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
406         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
407         return 2 ** ownerIndex;
408     }
409 
410     function isOperationActive(bytes32 _operation) private constant returns (bool) {
411         return 0 != m_multiOwnedPending[_operation].yetNeeded;
412     }
413 
414 
415     function assertOwnersAreConsistent() private constant {
416         assert(m_numOwners > 0);
417         assert(m_numOwners <= c_maxOwners);
418         assert(m_owners[0] == 0);
419         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
420     }
421 
422     function assertOperationIsConsistent(bytes32 _operation) private constant {
423         var pending = m_multiOwnedPending[_operation];
424         assert(0 != pending.yetNeeded);
425         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
426         assert(pending.yetNeeded <= m_multiOwnedRequired);
427     }
428 
429 
430    	// FIELDS
431 
432     uint constant c_maxOwners = 250;
433 
434     // the number of owners that must confirm the same operation before it is run.
435     uint public m_multiOwnedRequired;
436 
437 
438     // pointer used to find a free slot in m_owners
439     uint public m_numOwners;
440 
441     // list of owners (addresses),
442     // slot 0 is unused so there are no owner which index is 0.
443     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
444     address[256] internal m_owners;
445 
446     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
447     mapping(address => uint) internal m_ownerIndex;
448 
449 
450     // the ongoing operations.
451     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
452     bytes32[] internal m_multiOwnedPendingIndex;
453 }
454 
455 contract MultiownedControlled is multiowned {
456 
457     event ControllerSet(address controller);
458     event ControllerRetired(address was);
459     event ControllerRetiredForever(address was);
460 
461 
462     modifier onlyController {
463         require(msg.sender == m_controller);
464         _;
465     }
466 
467 
468     // PUBLIC interface
469 
470     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
471         public
472         multiowned(_owners, _signaturesRequired)
473     {
474         m_controller = _controller;
475         ControllerSet(m_controller);
476     }
477 
478     /// @dev sets the controller
479     function setController(address _controller) external onlymanyowners(keccak256(msg.data)) {
480         require(m_attaching_enabled);
481         m_controller = _controller;
482         ControllerSet(m_controller);
483     }
484 
485     /// @dev ability for controller to step down
486     function detachController() external onlyController {
487         address was = m_controller;
488         m_controller = address(0);
489         ControllerRetired(was);
490     }
491 
492     /// @dev ability for controller to step down and make this contract completely automatic (without third-party control)
493     function detachControllerForever() external onlyController {
494         assert(m_attaching_enabled);
495         address was = m_controller;
496         m_controller = address(0);
497         m_attaching_enabled = false;
498         ControllerRetiredForever(was);
499     }
500 
501 
502     // FIELDS
503 
504     /// @notice address of entity entitled to mint new tokens
505     address public m_controller;
506 
507     bool public m_attaching_enabled = true;
508 }
509 
510 interface IEmissionPartMinter {
511     function mintPartOfEmission(address to, uint part, uint partOfEmissionForPublicSales) public;
512 }
513 
514 contract ERC20Basic {
515   uint256 public totalSupply;
516   function balanceOf(address who) public view returns (uint256);
517   function transfer(address to, uint256 value) public returns (bool);
518   event Transfer(address indexed from, address indexed to, uint256 value);
519 }
520 
521 contract BasicToken is ERC20Basic {
522   using SafeMath for uint256;
523 
524   mapping(address => uint256) balances;
525 
526   /**
527   * @dev transfer token for a specified address
528   * @param _to The address to transfer to.
529   * @param _value The amount to be transferred.
530   */
531   function transfer(address _to, uint256 _value) public returns (bool) {
532     require(_to != address(0));
533     require(_value <= balances[msg.sender]);
534 
535     // SafeMath.sub will throw if there is not enough balance.
536     balances[msg.sender] = balances[msg.sender].sub(_value);
537     balances[_to] = balances[_to].add(_value);
538     Transfer(msg.sender, _to, _value);
539     return true;
540   }
541 
542   /**
543   * @dev Gets the balance of the specified address.
544   * @param _owner The address to query the the balance of.
545   * @return An uint256 representing the amount owned by the passed address.
546   */
547   function balanceOf(address _owner) public view returns (uint256 balance) {
548     return balances[_owner];
549   }
550 
551 }
552 
553 contract ERC20 is ERC20Basic {
554   function allowance(address owner, address spender) public view returns (uint256);
555   function transferFrom(address from, address to, uint256 value) public returns (bool);
556   function approve(address spender, uint256 value) public returns (bool);
557   event Approval(address indexed owner, address indexed spender, uint256 value);
558 }
559 
560 contract StandardToken is ERC20, BasicToken {
561 
562   mapping (address => mapping (address => uint256)) internal allowed;
563 
564 
565   /**
566    * @dev Transfer tokens from one address to another
567    * @param _from address The address which you want to send tokens from
568    * @param _to address The address which you want to transfer to
569    * @param _value uint256 the amount of tokens to be transferred
570    */
571   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
572     require(_to != address(0));
573     require(_value <= balances[_from]);
574     require(_value <= allowed[_from][msg.sender]);
575 
576     balances[_from] = balances[_from].sub(_value);
577     balances[_to] = balances[_to].add(_value);
578     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
579     Transfer(_from, _to, _value);
580     return true;
581   }
582 
583   /**
584    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
585    *
586    * Beware that changing an allowance with this method brings the risk that someone may use both the old
587    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
588    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
589    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
590    * @param _spender The address which will spend the funds.
591    * @param _value The amount of tokens to be spent.
592    */
593   function approve(address _spender, uint256 _value) public returns (bool) {
594     allowed[msg.sender][_spender] = _value;
595     Approval(msg.sender, _spender, _value);
596     return true;
597   }
598 
599   /**
600    * @dev Function to check the amount of tokens that an owner allowed to a spender.
601    * @param _owner address The address which owns the funds.
602    * @param _spender address The address which will spend the funds.
603    * @return A uint256 specifying the amount of tokens still available for the spender.
604    */
605   function allowance(address _owner, address _spender) public view returns (uint256) {
606     return allowed[_owner][_spender];
607   }
608 
609   /**
610    * approve should be called when allowed[_spender] == 0. To increment
611    * allowed value is better to use this function to avoid 2 calls (and wait until
612    * the first transaction is mined)
613    * From MonolithDAO Token.sol
614    */
615   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
616     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
617     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
618     return true;
619   }
620 
621   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
622     uint oldValue = allowed[msg.sender][_spender];
623     if (_subtractedValue > oldValue) {
624       allowed[msg.sender][_spender] = 0;
625     } else {
626       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
627     }
628     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
629     return true;
630   }
631 
632 }
633 
634 contract CirculatingToken is StandardToken {
635 
636     event CirculationEnabled();
637 
638     modifier requiresCirculation {
639         require(m_isCirculating);
640         _;
641     }
642 
643 
644     // PUBLIC interface
645 
646     function transfer(address _to, uint256 _value) public requiresCirculation returns (bool) {
647         return super.transfer(_to, _value);
648     }
649 
650     function transferFrom(address _from, address _to, uint256 _value) public requiresCirculation returns (bool) {
651         return super.transferFrom(_from, _to, _value);
652     }
653 
654     function approve(address _spender, uint256 _value) public requiresCirculation returns (bool) {
655         return super.approve(_spender, _value);
656     }
657 
658 
659     // INTERNAL functions
660 
661     function enableCirculation() internal returns (bool) {
662         if (m_isCirculating)
663             return false;
664 
665         m_isCirculating = true;
666         CirculationEnabled();
667         return true;
668     }
669 
670 
671     // FIELDS
672 
673     /// @notice are the circulation started?
674     bool public m_isCirculating;
675 }
676 
677 contract MintableMultiownedToken is MintableToken, MultiownedControlled, StandardToken {
678 
679     // PUBLIC interface
680 
681     function MintableMultiownedToken(address[] _owners, uint _signaturesRequired, address _minter)
682         public
683         MultiownedControlled(_owners, _signaturesRequired, _minter)
684     {
685     }
686 
687 
688     /// @dev mints new tokens
689     function mint(address _to, uint256 _amount) public onlyController {
690         require(m_externalMintingEnabled);
691         mintInternal(_to, _amount);
692     }
693 
694     /// @dev disables mint(), irreversible!
695     function disableMinting() public onlyController {
696         require(m_externalMintingEnabled);
697         m_externalMintingEnabled = false;
698     }
699 
700 
701     // INTERNAL functions
702 
703     function mintInternal(address _to, uint256 _amount) internal {
704         totalSupply = totalSupply.add(_amount);
705         balances[_to] = balances[_to].add(_amount);
706         Transfer(address(0), _to, _amount);
707         Mint(_to, _amount);
708     }
709 
710 
711     // FIELDS
712 
713     /// @notice if this true then token is still externally mintable
714     bool public m_externalMintingEnabled = true;
715 }
716 
717 contract SmartzToken is CirculatingToken, MintableMultiownedToken {
718 
719     event Burn(address indexed from, uint256 amount);
720 
721 
722     // PUBLIC FUNCTIONS
723 
724     /**
725      * @notice Constructs token.
726      *
727      * @param _initialOwners initial multi-signatures, see comment below
728      * @param _signaturesRequired quorum of multi-signatures
729      *
730      * Initial owners have power over the token contract only during bootstrap phase (early investments and token
731      * sales). After final token sale any control over the token removed by issuing detachControllerForever call.
732      * For lifecycle example please see test/SmartzTokenTest.js, 'test full lifecycle'.
733      */
734     function SmartzToken(address[] _initialOwners, uint _signaturesRequired)
735         public
736         MintableMultiownedToken(_initialOwners, _signaturesRequired, address(0))
737     {
738     }
739 
740     /**
741      * Function to burn msg.sender's tokens.
742      *
743      * @param _amount The amount of tokens to burn
744      *
745      * @return A boolean that indicates if the operation was successful.
746      */
747     function burn(uint256 _amount) public returns (bool) {
748         address from = msg.sender;
749         require(_amount > 0);
750         require(_amount <= balances[from]);
751 
752         totalSupply = totalSupply.sub(_amount);
753         balances[from] = balances[from].sub(_amount);
754         Burn(from, _amount);
755         Transfer(from, address(0), _amount);
756 
757         return true;
758     }
759 
760     /**
761      * @notice Approves spending tokens and immediately triggers token recipient logic.
762      *
763      * @param _spender contract which supports IApprovalRecipient and allowed to receive tokens
764      * @param _value amount of tokens approved to be spent
765      * @param _extraData any extra data which to be provided to the _spender
766      *
767      * By invoking this utility function token holder could do two things in one transaction: approve spending his
768      * tokens and execute some external contract which spends them on token holder's behalf.
769      * It can't be known if _spender's invocation succeed or not.
770      * This function will throw if approval failed.
771      */
772     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public {
773         require(approve(_spender, _value));
774         IApprovalRecipient(_spender).receiveApproval(msg.sender, _value, _extraData);
775     }
776 
777 
778     // ADMINISTRATIVE FUNCTIONS
779 
780     function startCirculation() external onlyController returns (bool) {
781         return enableCirculation();
782     }
783 
784 
785     // CONSTANTS
786 
787     string public constant name = "Smartz token";
788     string public constant symbol = "SMR";
789     uint8 public constant decimals = 18;
790 }
791 
792 /// @title Contract orchestrates minting of SMR tokens to various parties.
793 contract SmartzTokenLifecycleManager is ArgumentsChecker, multiowned, IDetachable, MintableToken, IEmissionPartMinter {
794     using SafeMath for uint256;
795 
796     /**
797      * @notice State machine of the contract.
798      *
799      * State transitions are straightforward: MINTING2PUBLIC_SALES -> MINTING2POOLS -> CIRCULATING_TOKEN.
800      */
801     enum State {
802         // minting tokens during public sales
803         MINTING2PUBLIC_SALES,
804         // minting tokens to token pools
805         MINTING2POOLS,
806         // further minting is not possible
807         CIRCULATING_TOKEN
808     }
809 
810 
811     event StateChanged(State _state);
812 
813 
814     modifier requiresState(State _state) {
815         require(m_state == _state);
816         _;
817     }
818 
819     modifier onlyBy(address _from) {
820         require(msg.sender == _from);
821         _;
822     }
823 
824 
825     // PUBLIC FUNCTIONS
826 
827     function SmartzTokenLifecycleManager(address[] _owners, uint _signaturesRequired, SmartzToken _SMR)
828         public
829         validAddress(_SMR)
830         multiowned(_owners, _signaturesRequired)
831     {
832         m_SMR = _SMR;
833     }
834 
835 
836     /// @notice Mints tokens during public sales
837     function mint(address _to, uint256 _amount)
838         public
839         payloadSizeIs(32 * 2)
840         validAddress(_to)
841         requiresState(State.MINTING2PUBLIC_SALES)
842         onlyBy(m_sale)
843     {
844         m_SMR.mint(_to, _amount);
845     }
846 
847     /// @notice Mints tokens to predefined token pools after public sales
848     function mintPartOfEmission(address to, uint part, uint partOfEmissionForPublicSales)
849         public
850         payloadSizeIs(32 * 3)
851         validAddress(to)
852         requiresState(State.MINTING2POOLS)
853         onlyBy(m_pools)
854     {
855         uint poolTokens = m_publiclyDistributedTokens.mul(part).div(partOfEmissionForPublicSales);
856         m_SMR.mint(to, poolTokens);
857     }
858 
859     /// @notice Detach is executed by sale contract or token pools contract
860     function detach()
861         public
862     {
863         if (m_state == State.MINTING2PUBLIC_SALES) {
864             require(msg.sender == m_sale);
865             m_sale = address(0);
866         }
867         else if (m_state == State.MINTING2POOLS) {
868             require(msg.sender == m_pools);
869             m_pools = address(0);
870 
871             // final stage of the lifecycle: autonomous token circulation
872             changeState(State.CIRCULATING_TOKEN);
873             m_SMR.disableMinting();
874             assert(m_SMR.startCirculation());
875             m_SMR.detachControllerForever();
876         }
877         else {
878             revert();
879         }
880     }
881 
882 
883     // ADMINISTRATIVE FUNCTIONS
884 
885     /// @dev Sets the next sale contract
886     function setSale(address sale)
887         external
888         payloadSizeIs(32)
889         validAddress(sale)
890         requiresState(State.MINTING2PUBLIC_SALES)
891         onlymanyowners(keccak256(msg.data))
892     {
893         m_sale = sale;
894     }
895 
896     /// @dev Sets contract which is responsible for token pools accounting
897     function setPools(address pools)
898         external
899         payloadSizeIs(32)
900         validAddress(pools)
901         requiresState(State.MINTING2PUBLIC_SALES)
902         onlymanyowners(keccak256(msg.data))
903     {
904         m_pools = pools;
905     }
906 
907     /// @dev Signals that there will be no more public sales
908     function setSalesFinished()
909         external
910         requiresState(State.MINTING2PUBLIC_SALES)
911         onlymanyowners(keccak256(msg.data))
912     {
913         require(m_pools != address(0));
914         changeState(State.MINTING2POOLS);
915         m_publiclyDistributedTokens = m_SMR.totalSupply();
916     }
917 
918 
919     // INTERNAL
920 
921     /// @dev performs only allowed state transitions
922     function changeState(State _newState)
923         private
924     {
925         assert(m_state != _newState);
926 
927         if (State.MINTING2PUBLIC_SALES == m_state) {    assert(State.MINTING2POOLS == _newState); }
928         else if (State.MINTING2POOLS == m_state) {      assert(State.CIRCULATING_TOKEN == _newState); }
929         else assert(false);
930 
931         m_state = _newState;
932         StateChanged(m_state);
933     }
934 
935 
936     // FIELDS
937 
938     /// @notice managed SMR token
939     SmartzToken public m_SMR;
940 
941     /// @notice current sale contract which can mint tokens
942     address public m_sale;
943 
944     /// @notice contract which is responsible for token pools accounting
945     address public m_pools;
946 
947     /// @notice stage of the life cycle
948     State public m_state = State.MINTING2PUBLIC_SALES;
949 
950     /// @notice amount of tokens sold during public sales
951     uint public m_publiclyDistributedTokens;
952 }