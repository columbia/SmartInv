1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     function balanceOf(address who) public view returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20Basic {
54     using SafeMath for uint256;
55 
56     mapping(address => uint256) balances;
57 
58     /**
59     * @dev transfer token for a specified address
60     * @param _to The address to transfer to.
61     * @param _value The amount to be transferred.
62     */
63     function transfer(address _to, uint256 _value) public returns (bool) {
64         require(_to != address(0));
65         require(_value <= balances[msg.sender]);
66 
67         // SafeMath.sub will throw if there is not enough balance.
68         balances[msg.sender] = balances[msg.sender].sub(_value);
69         balances[_to] = balances[_to].add(_value);
70         Transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     /**
75     * @dev Gets the balance of the specified address.
76     * @param _owner The address to query the the balance of.
77     * @return An uint256 representing the amount owned by the passed address.
78     */
79     function balanceOf(address _owner) public view returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public view returns (uint256);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107     mapping (address => mapping (address => uint256)) internal allowed;
108 
109 
110     /**
111      * @dev Transfer tokens from one address to another
112      * @param _from address The address which you want to send tokens from
113      * @param _to address The address which you want to transfer to
114      * @param _value uint256 the amount of tokens to be transferred
115      */
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117         require(_to != address(0));
118         require(_value <= balances[_from]);
119         require(_value <= allowed[_from][msg.sender]);
120 
121         balances[_from] = balances[_from].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124         Transfer(_from, _to, _value);
125         return true;
126     }
127 
128     /**
129      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130      *
131      * Beware that changing an allowance with this method brings the risk that someone may use both the old
132      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      * @param _spender The address which will spend the funds.
136      * @param _value The amount of tokens to be spent.
137      */
138     function approve(address _spender, uint256 _value) public returns (bool) {
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /**
145      * @dev Function to check the amount of tokens that an owner allowed to a spender.
146      * @param _owner address The address which owns the funds.
147      * @param _spender address The address which will spend the funds.
148      * @return A uint256 specifying the amount of tokens still available for the spender.
149      */
150     function allowance(address _owner, address _spender) public view returns (uint256) {
151         return allowed[_owner][_spender];
152     }
153 
154     /**
155      * approve should be called when allowed[_spender] == 0. To increment
156      * allowed value is better to use this function to avoid 2 calls (and wait until
157      * the first transaction is mined)
158      * From MonolithDAO Token.sol
159      */
160     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 
166     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
167         uint oldValue = allowed[msg.sender][_spender];
168         if (_subtractedValue > oldValue) {
169             allowed[msg.sender][_spender] = 0;
170         } else {
171             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172         }
173         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174         return true;
175     }
176 
177 }
178 
179 
180 
181 /// @title StandardToken which can be minted by another contract.
182 contract MintableToken {
183     event Mint(address indexed to, uint256 amount);
184 
185     /// @dev mints new tokens
186     function mint(address _to, uint256 _amount) public;
187 }
188 
189 
190 
191 /**
192  * MetropolMintableToken
193  */
194 contract MetropolMintableToken is StandardToken, MintableToken {
195 
196     event Mint(address indexed to, uint256 amount);
197 
198     function mint(address _to, uint256 _amount) public;//todo propose return value
199 
200     /**
201      * Function to mint tokens
202      * Internal for not forgetting to add access modifier
203      *
204      * @param _to The address that will receive the minted tokens.
205      * @param _amount The amount of tokens to mint.
206      *
207      * @return A boolean that indicates if the operation was successful.
208      */
209     function mintInternal(address _to, uint256 _amount) internal returns (bool) {
210         require(_amount>0);
211         require(_to!=address(0));
212 
213         totalSupply = totalSupply.add(_amount);
214         balances[_to] = balances[_to].add(_amount);
215         Mint(_to, _amount);
216         Transfer(address(0), _to, _amount);
217 
218         return true;
219     }
220 
221 }
222 
223 /**
224  * Contract which is operated by controller.
225  *
226  * Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
227  *
228  * Controller check is performed by onlyController modifier.
229  */
230 contract Controlled {
231 
232     address public m_controller;
233 
234     event ControllerSet(address controller);
235     event ControllerRetired(address was);
236 
237 
238     modifier onlyController {
239         require(msg.sender == m_controller);
240         _;
241     }
242 
243     function setController(address _controller) external;
244 
245     /**
246      * Sets the controller. Internal for not forgetting to add access modifier
247      */
248     function setControllerInternal(address _controller) internal {
249         m_controller = _controller;
250         ControllerSet(m_controller);
251     }
252 
253     /**
254      * Ability for controller to step down
255      */
256     function detachController() external onlyController {
257         address was = m_controller;
258         m_controller = address(0);
259         ControllerRetired(was);
260     }
261 }
262 
263 
264 /**
265  * MintableControlledToken
266  */
267 contract MintableControlledToken is MetropolMintableToken, Controlled {
268 
269     /**
270      * Function to mint tokens
271      *
272      * @param _to The address that will receive the minted tokens.
273      * @param _amount The amount of tokens to mint.
274      *
275      * @return A boolean that indicates if the operation was successful.
276      */
277     function mint(address _to, uint256 _amount) public onlyController {
278         super.mintInternal(_to, _amount);
279     }
280 
281 }
282 
283 
284 /**
285  * BurnableToken
286  */
287 contract BurnableToken is StandardToken {
288 
289     event Burn(address indexed from, uint256 amount);
290 
291     function burn(address _from, uint256 _amount) public returns (bool);
292 
293     /**
294      * Function to burn tokens
295      * Internal for not forgetting to add access modifier
296      *
297      * @param _from The address to burn tokens from.
298      * @param _amount The amount of tokens to burn.
299      *
300      * @return A boolean that indicates if the operation was successful.
301      */
302     function burnInternal(address _from, uint256 _amount) internal returns (bool) {
303         require(_amount>0);
304         require(_amount<=balances[_from]);
305 
306         totalSupply = totalSupply.sub(_amount);
307         balances[_from] = balances[_from].sub(_amount);
308         Burn(_from, _amount);
309         Transfer(_from, address(0), _amount);
310 
311         return true;
312     }
313 
314 }
315 
316 
317 /**
318  * BurnableControlledToken
319  */
320 contract BurnableControlledToken is BurnableToken, Controlled {
321 
322     /**
323      * Function to burn tokens
324      *
325      * @param _from The address to burn tokens from.
326      * @param _amount The amount of tokens to burn.
327      *
328      * @return A boolean that indicates if the operation was successful.
329      */
330     function burn(address _from, uint256 _amount) public onlyController returns (bool) {
331         return super.burnInternal(_from, _amount);
332     }
333 
334 }
335 
336 
337 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
338 // TODO acceptOwnership
339 contract multiowned {
340 
341     // TYPES
342 
343     // struct for the status of a pending operation.
344     struct MultiOwnedOperationPendingState {
345     // count of confirmations needed
346     uint yetNeeded;
347 
348     // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
349     uint ownersDone;
350 
351     // position of this operation key in m_multiOwnedPendingIndex
352     uint index;
353     }
354 
355     // EVENTS
356 
357     event Confirmation(address owner, bytes32 operation);
358     event Revoke(address owner, bytes32 operation);
359     event FinalConfirmation(address owner, bytes32 operation);
360 
361     // some others are in the case of an owner changing.
362     event OwnerChanged(address oldOwner, address newOwner);
363     event OwnerAdded(address newOwner);
364     event OwnerRemoved(address oldOwner);
365 
366     // the last one is emitted if the required signatures change
367     event RequirementChanged(uint newRequirement);
368 
369     // MODIFIERS
370 
371     // simple single-sig function modifier.
372     modifier onlyowner {
373         require(isOwner(msg.sender));
374         _;
375     }
376     // multi-sig function modifier: the operation must have an intrinsic hash in order
377     // that later attempts can be realised as the same underlying operation and
378     // thus count as confirmations.
379     modifier onlymanyowners(bytes32 _operation) {
380         if (confirmAndCheck(_operation)) {
381             _;
382         }
383         // Even if required number of confirmations has't been collected yet,
384         // we can't throw here - because changes to the state have to be preserved.
385         // But, confirmAndCheck itself will throw in case sender is not an owner.
386     }
387 
388     modifier validNumOwners(uint _numOwners) {
389         require(_numOwners > 0 && _numOwners <= c_maxOwners);
390         _;
391     }
392 
393     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
394         require(_required > 0 && _required <= _numOwners);
395         _;
396     }
397 
398     modifier ownerExists(address _address) {
399         require(isOwner(_address));
400         _;
401     }
402 
403     modifier ownerDoesNotExist(address _address) {
404         require(!isOwner(_address));
405         _;
406     }
407 
408     modifier multiOwnedOperationIsActive(bytes32 _operation) {
409         require(isOperationActive(_operation));
410         _;
411     }
412 
413     // METHODS
414 
415     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
416     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
417     function multiowned(address[] _owners, uint _required)
418     validNumOwners(_owners.length)
419     multiOwnedValidRequirement(_required, _owners.length)
420     {
421         assert(c_maxOwners <= 255);
422 
423         m_numOwners = _owners.length;
424         m_multiOwnedRequired = _required;
425 
426         for (uint i = 0; i < _owners.length; ++i)
427         {
428             address owner = _owners[i];
429             // invalid and duplicate addresses are not allowed
430             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
431 
432             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
433             m_owners[currentOwnerIndex] = owner;
434             m_ownerIndex[owner] = currentOwnerIndex;
435         }
436 
437         assertOwnersAreConsistent();
438     }
439 
440     /// @notice replaces an owner `_from` with another `_to`.
441     /// @param _from address of owner to replace
442     /// @param _to address of new owner
443     // All pending operations will be canceled!
444     function changeOwner(address _from, address _to)
445     external
446     ownerExists(_from)
447     ownerDoesNotExist(_to)
448     onlymanyowners(sha3(msg.data))
449     {
450         assertOwnersAreConsistent();
451 
452         clearPending();
453         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
454         m_owners[ownerIndex] = _to;
455         m_ownerIndex[_from] = 0;
456         m_ownerIndex[_to] = ownerIndex;
457 
458         assertOwnersAreConsistent();
459         OwnerChanged(_from, _to);
460     }
461 
462     /// @notice adds an owner
463     /// @param _owner address of new owner
464     // All pending operations will be canceled!
465     function addOwner(address _owner)
466     external
467     ownerDoesNotExist(_owner)
468     validNumOwners(m_numOwners + 1)
469     onlymanyowners(sha3(msg.data))
470     {
471         assertOwnersAreConsistent();
472 
473         clearPending();
474         m_numOwners++;
475         m_owners[m_numOwners] = _owner;
476         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
477 
478         assertOwnersAreConsistent();
479         OwnerAdded(_owner);
480     }
481 
482     /// @notice removes an owner
483     /// @param _owner address of owner to remove
484     // All pending operations will be canceled!
485     function removeOwner(address _owner)
486     external
487     ownerExists(_owner)
488     validNumOwners(m_numOwners - 1)
489     multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
490     onlymanyowners(sha3(msg.data))
491     {
492         assertOwnersAreConsistent();
493 
494         clearPending();
495         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
496         m_owners[ownerIndex] = 0;
497         m_ownerIndex[_owner] = 0;
498         //make sure m_numOwners is equal to the number of owners and always points to the last owner
499         reorganizeOwners();
500 
501         assertOwnersAreConsistent();
502         OwnerRemoved(_owner);
503     }
504 
505     /// @notice changes the required number of owner signatures
506     /// @param _newRequired new number of signatures required
507     // All pending operations will be canceled!
508     function changeRequirement(uint _newRequired)
509     external
510     multiOwnedValidRequirement(_newRequired, m_numOwners)
511     onlymanyowners(sha3(msg.data))
512     {
513         m_multiOwnedRequired = _newRequired;
514         clearPending();
515         RequirementChanged(_newRequired);
516     }
517 
518     /// @notice Gets an owner by 0-indexed position
519     /// @param ownerIndex 0-indexed owner position
520     function getOwner(uint ownerIndex) public constant returns (address) {
521         return m_owners[ownerIndex + 1];
522     }
523 
524     /// @notice Gets owners
525     /// @return memory array of owners
526     function getOwners() public constant returns (address[]) {
527         address[] memory result = new address[](m_numOwners);
528         for (uint i = 0; i < m_numOwners; i++)
529         result[i] = getOwner(i);
530 
531         return result;
532     }
533 
534     /// @notice checks if provided address is an owner address
535     /// @param _addr address to check
536     /// @return true if it's an owner
537     function isOwner(address _addr) public constant returns (bool) {
538         return m_ownerIndex[_addr] > 0;
539     }
540 
541     /// @notice Tests ownership of the current caller.
542     /// @return true if it's an owner
543     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
544     // addOwner/changeOwner and to isOwner.
545     function amIOwner() external constant onlyowner returns (bool) {
546         return true;
547     }
548 
549     /// @notice Revokes a prior confirmation of the given operation
550     /// @param _operation operation value, typically sha3(msg.data)
551     function revoke(bytes32 _operation)
552     external
553     multiOwnedOperationIsActive(_operation)
554     onlyowner
555     {
556         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
557         var pending = m_multiOwnedPending[_operation];
558         require(pending.ownersDone & ownerIndexBit > 0);
559 
560         assertOperationIsConsistent(_operation);
561 
562         pending.yetNeeded++;
563         pending.ownersDone -= ownerIndexBit;
564 
565         assertOperationIsConsistent(_operation);
566         Revoke(msg.sender, _operation);
567     }
568 
569     /// @notice Checks if owner confirmed given operation
570     /// @param _operation operation value, typically sha3(msg.data)
571     /// @param _owner an owner address
572     function hasConfirmed(bytes32 _operation, address _owner)
573     external
574     constant
575     multiOwnedOperationIsActive(_operation)
576     ownerExists(_owner)
577     returns (bool)
578     {
579         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
580     }
581 
582     // INTERNAL METHODS
583 
584     function confirmAndCheck(bytes32 _operation)
585     private
586     onlyowner
587     returns (bool)
588     {
589         if (512 == m_multiOwnedPendingIndex.length)
590         // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
591         // we won't be able to do it because of block gas limit.
592         // Yes, pending confirmations will be lost. Dont see any security or stability implications.
593         // TODO use more graceful approach like compact or removal of clearPending completely
594         clearPending();
595 
596         var pending = m_multiOwnedPending[_operation];
597 
598         // if we're not yet working on this operation, switch over and reset the confirmation status.
599         if (! isOperationActive(_operation)) {
600             // reset count of confirmations needed.
601             pending.yetNeeded = m_multiOwnedRequired;
602             // reset which owners have confirmed (none) - set our bitmap to 0.
603             pending.ownersDone = 0;
604             pending.index = m_multiOwnedPendingIndex.length++;
605             m_multiOwnedPendingIndex[pending.index] = _operation;
606             assertOperationIsConsistent(_operation);
607         }
608 
609         // determine the bit to set for this owner.
610         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
611         // make sure we (the message sender) haven't confirmed this operation previously.
612         if (pending.ownersDone & ownerIndexBit == 0) {
613             // ok - check if count is enough to go ahead.
614             assert(pending.yetNeeded > 0);
615             if (pending.yetNeeded == 1) {
616                 // enough confirmations: reset and run interior.
617                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
618                 delete m_multiOwnedPending[_operation];
619                 FinalConfirmation(msg.sender, _operation);
620                 return true;
621             }
622             else
623             {
624                 // not enough: record that this owner in particular confirmed.
625                 pending.yetNeeded--;
626                 pending.ownersDone |= ownerIndexBit;
627                 assertOperationIsConsistent(_operation);
628                 Confirmation(msg.sender, _operation);
629             }
630         }
631     }
632 
633     // Reclaims free slots between valid owners in m_owners.
634     // TODO given that its called after each removal, it could be simplified.
635     function reorganizeOwners() private {
636         uint free = 1;
637         while (free < m_numOwners)
638         {
639             // iterating to the first free slot from the beginning
640             while (free < m_numOwners && m_owners[free] != 0) free++;
641 
642             // iterating to the first occupied slot from the end
643             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
644 
645             // swap, if possible, so free slot is located at the end after the swap
646             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
647             {
648                 // owners between swapped slots should't be renumbered - that saves a lot of gas
649                 m_owners[free] = m_owners[m_numOwners];
650                 m_ownerIndex[m_owners[free]] = free;
651                 m_owners[m_numOwners] = 0;
652             }
653         }
654     }
655 
656     function clearPending() private onlyowner {
657         uint length = m_multiOwnedPendingIndex.length;
658         // TODO block gas limit
659         for (uint i = 0; i < length; ++i) {
660             if (m_multiOwnedPendingIndex[i] != 0)
661             delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
662         }
663         delete m_multiOwnedPendingIndex;
664     }
665 
666     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
667         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
668         return ownerIndex;
669     }
670 
671     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
672         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
673         return 2 ** ownerIndex;
674     }
675 
676     function isOperationActive(bytes32 _operation) private constant returns (bool) {
677         return 0 != m_multiOwnedPending[_operation].yetNeeded;
678     }
679 
680 
681     function assertOwnersAreConsistent() private constant {
682         assert(m_numOwners > 0);
683         assert(m_numOwners <= c_maxOwners);
684         assert(m_owners[0] == 0);
685         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
686     }
687 
688     function assertOperationIsConsistent(bytes32 _operation) private constant {
689         var pending = m_multiOwnedPending[_operation];
690         assert(0 != pending.yetNeeded);
691         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
692         assert(pending.yetNeeded <= m_multiOwnedRequired);
693     }
694 
695 
696     // FIELDS
697 
698     uint constant c_maxOwners = 250;
699 
700     // the number of owners that must confirm the same operation before it is run.
701     uint public m_multiOwnedRequired;
702 
703 
704     // pointer used to find a free slot in m_owners
705     uint public m_numOwners;
706 
707     // list of owners (addresses),
708     // slot 0 is unused so there are no owner which index is 0.
709     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
710     address[256] internal m_owners;
711 
712     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
713     mapping(address => uint) internal m_ownerIndex;
714 
715 
716     // the ongoing operations.
717     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
718     bytes32[] internal m_multiOwnedPendingIndex;
719 }
720 
721 
722 /**
723  * Contract which is owned by owners and operated by controller.
724  *
725  * Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
726  * Controller is set up by owners or during construction.
727  *
728  */
729 contract MetropolMultiownedControlled is Controlled, multiowned {
730 
731 
732     function MetropolMultiownedControlled(address[] _owners, uint256 _signaturesRequired)
733     multiowned(_owners, _signaturesRequired)
734     public
735     {
736         // nothing here
737     }
738 
739     /**
740      * Sets the controller
741      */
742     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
743         super.setControllerInternal(_controller);
744     }
745 
746 }
747 
748 
749 
750 /// @title StandardToken which circulation can be delayed and started by another contract.
751 /// @dev To be used as a mixin contract.
752 /// The contract is created in disabled state: circulation is disabled.
753 contract CirculatingToken is StandardToken {
754 
755     event CirculationEnabled();
756 
757     modifier requiresCirculation {
758         require(m_isCirculating);
759         _;
760     }
761 
762 
763     // PUBLIC interface
764 
765     function transfer(address _to, uint256 _value) requiresCirculation returns (bool) {
766         return super.transfer(_to, _value);
767     }
768 
769     function transferFrom(address _from, address _to, uint256 _value) requiresCirculation returns (bool) {
770         return super.transferFrom(_from, _to, _value);
771     }
772 
773     function approve(address _spender, uint256 _value) requiresCirculation returns (bool) {
774         return super.approve(_spender, _value);
775     }
776 
777 
778     // INTERNAL functions
779 
780     function enableCirculation() internal returns (bool) {
781         if (m_isCirculating)
782         return false;
783 
784         m_isCirculating = true;
785         CirculationEnabled();
786         return true;
787     }
788 
789 
790     // FIELDS
791 
792     /// @notice are the circulation started?
793     bool public m_isCirculating;
794 }
795 
796 
797 
798 
799 /**
800  * CirculatingControlledToken
801  */
802 contract CirculatingControlledToken is CirculatingToken, Controlled {
803 
804     /**
805      * Allows token transfers
806      */
807     function startCirculation() external onlyController {
808         assert(enableCirculation());    // must be called once
809     }
810 }
811 
812 
813 /**
814  * MetropolToken
815  */
816 contract MetropolToken is
817     StandardToken,
818     Controlled,
819     MintableControlledToken,
820     BurnableControlledToken,
821     CirculatingControlledToken,
822     MetropolMultiownedControlled
823 {
824     string internal m_name = '';
825     string internal m_symbol = '';
826     uint8 public constant decimals = 18;
827 
828     /**
829      * MetropolToken constructor
830      */
831     function MetropolToken(address[] _owners)
832         MetropolMultiownedControlled(_owners, 2)
833         public
834     {
835         require(3 == _owners.length);
836     }
837 
838     function name() public constant returns (string) {
839         return m_name;
840     }
841     function symbol() public constant returns (string) {
842         return m_symbol;
843     }
844 
845     function setNameSymbol(string _name, string _symbol) external onlymanyowners(sha3(msg.data)) {
846         require(bytes(m_name).length==0);
847         require(bytes(_name).length!=0 && bytes(_symbol).length!=0);
848 
849         m_name = _name;
850         m_symbol = _symbol;
851     }
852 
853 }