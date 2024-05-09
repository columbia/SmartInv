1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity 0.4.15;
7 
8 /*************************************************************************
9  * import "./STQPreICOBase.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "./crowdsale/SimpleCrowdsaleBase.sol" : start
14  *************************************************************************/
15 
16 /*************************************************************************
17  * import "../security/ArgumentsChecker.sol" : start
18  *************************************************************************/
19 
20 
21 /// @title utility methods and modifiers of arguments validation
22 contract ArgumentsChecker {
23 
24     /// @dev check which prevents short address attack
25     modifier payloadSizeIs(uint size) {
26        require(msg.data.length == size + 4 /* function selector */);
27        _;
28     }
29 
30     /// @dev check that address is valid
31     modifier validAddress(address addr) {
32         require(addr != address(0));
33         _;
34     }
35 }
36 /*************************************************************************
37  * import "../security/ArgumentsChecker.sol" : end
38  *************************************************************************/
39 /*************************************************************************
40  * import "../token/MintableMultiownedToken.sol" : start
41  *************************************************************************/
42 
43 /*************************************************************************
44  * import "../ownership/MultiownedControlled.sol" : start
45  *************************************************************************/
46 
47 /*************************************************************************
48  * import "./multiowned.sol" : start
49  *************************************************************************/// Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
50 // Audit, refactoring and improvements by github.com/Eenae
51 
52 // @authors:
53 // Gav Wood <g@ethdev.com>
54 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
55 // single, or, crucially, each of a number of, designated owners.
56 // usage:
57 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
58 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
59 // interior is executed.
60 
61 
62 
63 
64 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
65 // TODO acceptOwnership
66 contract multiowned {
67 
68 	// TYPES
69 
70     // struct for the status of a pending operation.
71     struct MultiOwnedOperationPendingState {
72         // count of confirmations needed
73         uint yetNeeded;
74 
75         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
76         uint ownersDone;
77 
78         // position of this operation key in m_multiOwnedPendingIndex
79         uint index;
80     }
81 
82 	// EVENTS
83 
84     event Confirmation(address owner, bytes32 operation);
85     event Revoke(address owner, bytes32 operation);
86     event FinalConfirmation(address owner, bytes32 operation);
87 
88     // some others are in the case of an owner changing.
89     event OwnerChanged(address oldOwner, address newOwner);
90     event OwnerAdded(address newOwner);
91     event OwnerRemoved(address oldOwner);
92 
93     // the last one is emitted if the required signatures change
94     event RequirementChanged(uint newRequirement);
95 
96 	// MODIFIERS
97 
98     // simple single-sig function modifier.
99     modifier onlyowner {
100         require(isOwner(msg.sender));
101         _;
102     }
103     // multi-sig function modifier: the operation must have an intrinsic hash in order
104     // that later attempts can be realised as the same underlying operation and
105     // thus count as confirmations.
106     modifier onlymanyowners(bytes32 _operation) {
107         if (confirmAndCheck(_operation)) {
108             _;
109         }
110         // Even if required number of confirmations has't been collected yet,
111         // we can't throw here - because changes to the state have to be preserved.
112         // But, confirmAndCheck itself will throw in case sender is not an owner.
113     }
114 
115     modifier validNumOwners(uint _numOwners) {
116         require(_numOwners > 0 && _numOwners <= c_maxOwners);
117         _;
118     }
119 
120     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
121         require(_required > 0 && _required <= _numOwners);
122         _;
123     }
124 
125     modifier ownerExists(address _address) {
126         require(isOwner(_address));
127         _;
128     }
129 
130     modifier ownerDoesNotExist(address _address) {
131         require(!isOwner(_address));
132         _;
133     }
134 
135     modifier multiOwnedOperationIsActive(bytes32 _operation) {
136         require(isOperationActive(_operation));
137         _;
138     }
139 
140 	// METHODS
141 
142     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
143     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
144     function multiowned(address[] _owners, uint _required)
145         validNumOwners(_owners.length)
146         multiOwnedValidRequirement(_required, _owners.length)
147     {
148         assert(c_maxOwners <= 255);
149 
150         m_numOwners = _owners.length;
151         m_multiOwnedRequired = _required;
152 
153         for (uint i = 0; i < _owners.length; ++i)
154         {
155             address owner = _owners[i];
156             // invalid and duplicate addresses are not allowed
157             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
158 
159             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
160             m_owners[currentOwnerIndex] = owner;
161             m_ownerIndex[owner] = currentOwnerIndex;
162         }
163 
164         assertOwnersAreConsistent();
165     }
166 
167     /// @notice replaces an owner `_from` with another `_to`.
168     /// @param _from address of owner to replace
169     /// @param _to address of new owner
170     // All pending operations will be canceled!
171     function changeOwner(address _from, address _to)
172         external
173         ownerExists(_from)
174         ownerDoesNotExist(_to)
175         onlymanyowners(sha3(msg.data))
176     {
177         assertOwnersAreConsistent();
178 
179         clearPending();
180         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
181         m_owners[ownerIndex] = _to;
182         m_ownerIndex[_from] = 0;
183         m_ownerIndex[_to] = ownerIndex;
184 
185         assertOwnersAreConsistent();
186         OwnerChanged(_from, _to);
187     }
188 
189     /// @notice adds an owner
190     /// @param _owner address of new owner
191     // All pending operations will be canceled!
192     function addOwner(address _owner)
193         external
194         ownerDoesNotExist(_owner)
195         validNumOwners(m_numOwners + 1)
196         onlymanyowners(sha3(msg.data))
197     {
198         assertOwnersAreConsistent();
199 
200         clearPending();
201         m_numOwners++;
202         m_owners[m_numOwners] = _owner;
203         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
204 
205         assertOwnersAreConsistent();
206         OwnerAdded(_owner);
207     }
208 
209     /// @notice removes an owner
210     /// @param _owner address of owner to remove
211     // All pending operations will be canceled!
212     function removeOwner(address _owner)
213         external
214         ownerExists(_owner)
215         validNumOwners(m_numOwners - 1)
216         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
217         onlymanyowners(sha3(msg.data))
218     {
219         assertOwnersAreConsistent();
220 
221         clearPending();
222         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
223         m_owners[ownerIndex] = 0;
224         m_ownerIndex[_owner] = 0;
225         //make sure m_numOwners is equal to the number of owners and always points to the last owner
226         reorganizeOwners();
227 
228         assertOwnersAreConsistent();
229         OwnerRemoved(_owner);
230     }
231 
232     /// @notice changes the required number of owner signatures
233     /// @param _newRequired new number of signatures required
234     // All pending operations will be canceled!
235     function changeRequirement(uint _newRequired)
236         external
237         multiOwnedValidRequirement(_newRequired, m_numOwners)
238         onlymanyowners(sha3(msg.data))
239     {
240         m_multiOwnedRequired = _newRequired;
241         clearPending();
242         RequirementChanged(_newRequired);
243     }
244 
245     /// @notice Gets an owner by 0-indexed position
246     /// @param ownerIndex 0-indexed owner position
247     function getOwner(uint ownerIndex) public constant returns (address) {
248         return m_owners[ownerIndex + 1];
249     }
250 
251     /// @notice Gets owners
252     /// @return memory array of owners
253     function getOwners() public constant returns (address[]) {
254         address[] memory result = new address[](m_numOwners);
255         for (uint i = 0; i < m_numOwners; i++)
256             result[i] = getOwner(i);
257 
258         return result;
259     }
260 
261     /// @notice checks if provided address is an owner address
262     /// @param _addr address to check
263     /// @return true if it's an owner
264     function isOwner(address _addr) public constant returns (bool) {
265         return m_ownerIndex[_addr] > 0;
266     }
267 
268     /// @notice Tests ownership of the current caller.
269     /// @return true if it's an owner
270     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
271     // addOwner/changeOwner and to isOwner.
272     function amIOwner() external constant onlyowner returns (bool) {
273         return true;
274     }
275 
276     /// @notice Revokes a prior confirmation of the given operation
277     /// @param _operation operation value, typically sha3(msg.data)
278     function revoke(bytes32 _operation)
279         external
280         multiOwnedOperationIsActive(_operation)
281         onlyowner
282     {
283         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
284         var pending = m_multiOwnedPending[_operation];
285         require(pending.ownersDone & ownerIndexBit > 0);
286 
287         assertOperationIsConsistent(_operation);
288 
289         pending.yetNeeded++;
290         pending.ownersDone -= ownerIndexBit;
291 
292         assertOperationIsConsistent(_operation);
293         Revoke(msg.sender, _operation);
294     }
295 
296     /// @notice Checks if owner confirmed given operation
297     /// @param _operation operation value, typically sha3(msg.data)
298     /// @param _owner an owner address
299     function hasConfirmed(bytes32 _operation, address _owner)
300         external
301         constant
302         multiOwnedOperationIsActive(_operation)
303         ownerExists(_owner)
304         returns (bool)
305     {
306         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
307     }
308 
309     // INTERNAL METHODS
310 
311     function confirmAndCheck(bytes32 _operation)
312         private
313         onlyowner
314         returns (bool)
315     {
316         if (512 == m_multiOwnedPendingIndex.length)
317             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
318             // we won't be able to do it because of block gas limit.
319             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
320             // TODO use more graceful approach like compact or removal of clearPending completely
321             clearPending();
322 
323         var pending = m_multiOwnedPending[_operation];
324 
325         // if we're not yet working on this operation, switch over and reset the confirmation status.
326         if (! isOperationActive(_operation)) {
327             // reset count of confirmations needed.
328             pending.yetNeeded = m_multiOwnedRequired;
329             // reset which owners have confirmed (none) - set our bitmap to 0.
330             pending.ownersDone = 0;
331             pending.index = m_multiOwnedPendingIndex.length++;
332             m_multiOwnedPendingIndex[pending.index] = _operation;
333             assertOperationIsConsistent(_operation);
334         }
335 
336         // determine the bit to set for this owner.
337         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
338         // make sure we (the message sender) haven't confirmed this operation previously.
339         if (pending.ownersDone & ownerIndexBit == 0) {
340             // ok - check if count is enough to go ahead.
341             assert(pending.yetNeeded > 0);
342             if (pending.yetNeeded == 1) {
343                 // enough confirmations: reset and run interior.
344                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
345                 delete m_multiOwnedPending[_operation];
346                 FinalConfirmation(msg.sender, _operation);
347                 return true;
348             }
349             else
350             {
351                 // not enough: record that this owner in particular confirmed.
352                 pending.yetNeeded--;
353                 pending.ownersDone |= ownerIndexBit;
354                 assertOperationIsConsistent(_operation);
355                 Confirmation(msg.sender, _operation);
356             }
357         }
358     }
359 
360     // Reclaims free slots between valid owners in m_owners.
361     // TODO given that its called after each removal, it could be simplified.
362     function reorganizeOwners() private {
363         uint free = 1;
364         while (free < m_numOwners)
365         {
366             // iterating to the first free slot from the beginning
367             while (free < m_numOwners && m_owners[free] != 0) free++;
368 
369             // iterating to the first occupied slot from the end
370             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
371 
372             // swap, if possible, so free slot is located at the end after the swap
373             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
374             {
375                 // owners between swapped slots should't be renumbered - that saves a lot of gas
376                 m_owners[free] = m_owners[m_numOwners];
377                 m_ownerIndex[m_owners[free]] = free;
378                 m_owners[m_numOwners] = 0;
379             }
380         }
381     }
382 
383     function clearPending() private onlyowner {
384         uint length = m_multiOwnedPendingIndex.length;
385         // TODO block gas limit
386         for (uint i = 0; i < length; ++i) {
387             if (m_multiOwnedPendingIndex[i] != 0)
388                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
389         }
390         delete m_multiOwnedPendingIndex;
391     }
392 
393     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
394         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
395         return ownerIndex;
396     }
397 
398     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
399         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
400         return 2 ** ownerIndex;
401     }
402 
403     function isOperationActive(bytes32 _operation) private constant returns (bool) {
404         return 0 != m_multiOwnedPending[_operation].yetNeeded;
405     }
406 
407 
408     function assertOwnersAreConsistent() private constant {
409         assert(m_numOwners > 0);
410         assert(m_numOwners <= c_maxOwners);
411         assert(m_owners[0] == 0);
412         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
413     }
414 
415     function assertOperationIsConsistent(bytes32 _operation) private constant {
416         var pending = m_multiOwnedPending[_operation];
417         assert(0 != pending.yetNeeded);
418         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
419         assert(pending.yetNeeded <= m_multiOwnedRequired);
420     }
421 
422 
423    	// FIELDS
424 
425     uint constant c_maxOwners = 250;
426 
427     // the number of owners that must confirm the same operation before it is run.
428     uint public m_multiOwnedRequired;
429 
430 
431     // pointer used to find a free slot in m_owners
432     uint public m_numOwners;
433 
434     // list of owners (addresses),
435     // slot 0 is unused so there are no owner which index is 0.
436     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
437     address[256] internal m_owners;
438 
439     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
440     mapping(address => uint) internal m_ownerIndex;
441 
442 
443     // the ongoing operations.
444     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
445     bytes32[] internal m_multiOwnedPendingIndex;
446 }
447 /*************************************************************************
448  * import "./multiowned.sol" : end
449  *************************************************************************/
450 
451 
452 /**
453  * @title Contract which is owned by owners and operated by controller.
454  *
455  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
456  * Controller is set up by owners or during construction.
457  *
458  * @dev controller check is performed by onlyController modifier.
459  */
460 contract MultiownedControlled is multiowned {
461 
462     event ControllerSet(address controller);
463     event ControllerRetired(address was);
464 
465 
466     modifier onlyController {
467         require(msg.sender == m_controller);
468         _;
469     }
470 
471 
472     // PUBLIC interface
473 
474     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
475         multiowned(_owners, _signaturesRequired)
476     {
477         m_controller = _controller;
478         ControllerSet(m_controller);
479     }
480 
481     /// @dev sets the controller
482     function setController(address _controller) external onlymanyowners(sha3(msg.data)) {
483         m_controller = _controller;
484         ControllerSet(m_controller);
485     }
486 
487     /// @dev ability for controller to step down
488     function detachController() external onlyController {
489         address was = m_controller;
490         m_controller = address(0);
491         ControllerRetired(was);
492     }
493 
494 
495     // FIELDS
496 
497     /// @notice address of entity entitled to mint new tokens
498     address public m_controller;
499 }
500 /*************************************************************************
501  * import "../ownership/MultiownedControlled.sol" : end
502  *************************************************************************/
503 /*************************************************************************
504  * import "zeppelin-solidity/contracts/token/StandardToken.sol" : start
505  *************************************************************************/
506 
507 
508 /*************************************************************************
509  * import "./BasicToken.sol" : start
510  *************************************************************************/
511 
512 
513 /*************************************************************************
514  * import "./ERC20Basic.sol" : start
515  *************************************************************************/
516 
517 
518 /**
519  * @title ERC20Basic
520  * @dev Simpler version of ERC20 interface
521  * @dev see https://github.com/ethereum/EIPs/issues/179
522  */
523 contract ERC20Basic {
524   uint256 public totalSupply;
525   function balanceOf(address who) constant returns (uint256);
526   function transfer(address to, uint256 value) returns (bool);
527   event Transfer(address indexed from, address indexed to, uint256 value);
528 }
529 /*************************************************************************
530  * import "./ERC20Basic.sol" : end
531  *************************************************************************/
532 /*************************************************************************
533  * import "../math/SafeMath.sol" : start
534  *************************************************************************/
535 
536 
537 /**
538  * @title SafeMath
539  * @dev Math operations with safety checks that throw on error
540  */
541 library SafeMath {
542   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
543     uint256 c = a * b;
544     assert(a == 0 || c / a == b);
545     return c;
546   }
547 
548   function div(uint256 a, uint256 b) internal constant returns (uint256) {
549     // assert(b > 0); // Solidity automatically throws when dividing by 0
550     uint256 c = a / b;
551     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
552     return c;
553   }
554 
555   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
556     assert(b <= a);
557     return a - b;
558   }
559 
560   function add(uint256 a, uint256 b) internal constant returns (uint256) {
561     uint256 c = a + b;
562     assert(c >= a);
563     return c;
564   }
565 }
566 /*************************************************************************
567  * import "../math/SafeMath.sol" : end
568  *************************************************************************/
569 
570 
571 /**
572  * @title Basic token
573  * @dev Basic version of StandardToken, with no allowances. 
574  */
575 contract BasicToken is ERC20Basic {
576   using SafeMath for uint256;
577 
578   mapping(address => uint256) balances;
579 
580   /**
581   * @dev transfer token for a specified address
582   * @param _to The address to transfer to.
583   * @param _value The amount to be transferred.
584   */
585   function transfer(address _to, uint256 _value) returns (bool) {
586     balances[msg.sender] = balances[msg.sender].sub(_value);
587     balances[_to] = balances[_to].add(_value);
588     Transfer(msg.sender, _to, _value);
589     return true;
590   }
591 
592   /**
593   * @dev Gets the balance of the specified address.
594   * @param _owner The address to query the the balance of. 
595   * @return An uint256 representing the amount owned by the passed address.
596   */
597   function balanceOf(address _owner) constant returns (uint256 balance) {
598     return balances[_owner];
599   }
600 
601 }
602 /*************************************************************************
603  * import "./BasicToken.sol" : end
604  *************************************************************************/
605 /*************************************************************************
606  * import "./ERC20.sol" : start
607  *************************************************************************/
608 
609 
610 
611 
612 
613 /**
614  * @title ERC20 interface
615  * @dev see https://github.com/ethereum/EIPs/issues/20
616  */
617 contract ERC20 is ERC20Basic {
618   function allowance(address owner, address spender) constant returns (uint256);
619   function transferFrom(address from, address to, uint256 value) returns (bool);
620   function approve(address spender, uint256 value) returns (bool);
621   event Approval(address indexed owner, address indexed spender, uint256 value);
622 }
623 /*************************************************************************
624  * import "./ERC20.sol" : end
625  *************************************************************************/
626 
627 
628 /**
629  * @title Standard ERC20 token
630  *
631  * @dev Implementation of the basic standard token.
632  * @dev https://github.com/ethereum/EIPs/issues/20
633  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
634  */
635 contract StandardToken is ERC20, BasicToken {
636 
637   mapping (address => mapping (address => uint256)) allowed;
638 
639 
640   /**
641    * @dev Transfer tokens from one address to another
642    * @param _from address The address which you want to send tokens from
643    * @param _to address The address which you want to transfer to
644    * @param _value uint256 the amout of tokens to be transfered
645    */
646   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
647     var _allowance = allowed[_from][msg.sender];
648 
649     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
650     // require (_value <= _allowance);
651 
652     balances[_to] = balances[_to].add(_value);
653     balances[_from] = balances[_from].sub(_value);
654     allowed[_from][msg.sender] = _allowance.sub(_value);
655     Transfer(_from, _to, _value);
656     return true;
657   }
658 
659   /**
660    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
661    * @param _spender The address which will spend the funds.
662    * @param _value The amount of tokens to be spent.
663    */
664   function approve(address _spender, uint256 _value) returns (bool) {
665 
666     // To change the approve amount you first have to reduce the addresses`
667     //  allowance to zero by calling `approve(_spender, 0)` if it is not
668     //  already 0 to mitigate the race condition described here:
669     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
670     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
671 
672     allowed[msg.sender][_spender] = _value;
673     Approval(msg.sender, _spender, _value);
674     return true;
675   }
676 
677   /**
678    * @dev Function to check the amount of tokens that an owner allowed to a spender.
679    * @param _owner address The address which owns the funds.
680    * @param _spender address The address which will spend the funds.
681    * @return A uint256 specifing the amount of tokens still avaible for the spender.
682    */
683   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
684     return allowed[_owner][_spender];
685   }
686 
687 }
688 /*************************************************************************
689  * import "zeppelin-solidity/contracts/token/StandardToken.sol" : end
690  *************************************************************************/
691 
692 
693 /// @title StandardToken which can be minted by another contract.
694 contract MintableMultiownedToken is MultiownedControlled, StandardToken {
695 
696     /// @dev parameters of an extra token emission
697     struct EmissionInfo {
698         // tokens created
699         uint256 created;
700 
701         // totalSupply at the moment of emission (excluding created tokens)
702         uint256 totalSupplyWas;
703     }
704 
705     event Mint(address indexed to, uint256 amount);
706     event Emission(uint256 tokensCreated, uint256 totalSupplyWas, uint256 time);
707     event Dividend(address indexed to, uint256 amount);
708 
709 
710     // PUBLIC interface
711 
712     function MintableMultiownedToken(address[] _owners, uint _signaturesRequired, address _minter)
713         MultiownedControlled(_owners, _signaturesRequired, _minter)
714     {
715         dividendsPool = this;   // or any other special unforgeable value, actually
716 
717         // emission #0 is a dummy: because of default value 0 in m_lastAccountEmission
718         m_emissions.push(EmissionInfo({created: 0, totalSupplyWas: 0}));
719     }
720 
721     /// @notice Request dividends for current account.
722     function requestDividends() external {
723         payDividendsTo(msg.sender);
724     }
725 
726     /// @notice hook on standard ERC20#transfer to pay dividends
727     function transfer(address _to, uint256 _value) returns (bool) {
728         payDividendsTo(msg.sender);
729         payDividendsTo(_to);
730         return super.transfer(_to, _value);
731     }
732 
733     /// @notice hook on standard ERC20#transferFrom to pay dividends
734     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
735         payDividendsTo(_from);
736         payDividendsTo(_to);
737         return super.transferFrom(_from, _to, _value);
738     }
739 
740     // Disabled: this could be undesirable because sum of (balanceOf() for each token owner) != totalSupply
741     // (but: sum of (balances[owner] for each token owner) == totalSupply!).
742     //
743     // @notice hook on standard ERC20#balanceOf to take dividends into consideration
744     // function balanceOf(address _owner) constant returns (uint256) {
745     //     var (hasNewDividends, dividends) = calculateDividendsFor(_owner);
746     //     return hasNewDividends ? super.balanceOf(_owner).add(dividends) : super.balanceOf(_owner);
747     // }
748 
749 
750     /// @dev mints new tokens
751     function mint(address _to, uint256 _amount) external onlyController {
752         require(m_externalMintingEnabled);
753         payDividendsTo(_to);
754         mintInternal(_to, _amount);
755     }
756 
757     /// @dev disables mint(), irreversible!
758     function disableMinting() external onlyController {
759         require(m_externalMintingEnabled);
760         m_externalMintingEnabled = false;
761     }
762 
763 
764     // INTERNAL functions
765 
766     /**
767      * @notice Starts new token emission
768      * @param _tokensCreated Amount of tokens to create
769      * @dev Dividends are not distributed immediately as it could require billions of gas,
770      * instead they are `pulled` by a holder from dividends pool account before any update to the holder account occurs.
771      */
772     function emissionInternal(uint256 _tokensCreated) internal {
773         require(0 != _tokensCreated);
774         require(_tokensCreated < totalSupply / 2);  // otherwise it looks like an error
775 
776         uint256 totalSupplyWas = totalSupply;
777 
778         m_emissions.push(EmissionInfo({created: _tokensCreated, totalSupplyWas: totalSupplyWas}));
779         mintInternal(dividendsPool, _tokensCreated);
780 
781         Emission(_tokensCreated, totalSupplyWas, now);
782     }
783 
784     function mintInternal(address _to, uint256 _amount) internal {
785         totalSupply = totalSupply.add(_amount);
786         balances[_to] = balances[_to].add(_amount);
787         Transfer(this, _to, _amount);
788         Mint(_to, _amount);
789     }
790 
791     /// @dev adds dividends to the account _to
792     function payDividendsTo(address _to) internal {
793         var (hasNewDividends, dividends) = calculateDividendsFor(_to);
794         if (!hasNewDividends)
795             return;
796 
797         if (0 != dividends) {
798             balances[dividendsPool] = balances[dividendsPool].sub(dividends);
799             balances[_to] = balances[_to].add(dividends);
800             Transfer(dividendsPool, _to, dividends);
801         }
802         m_lastAccountEmission[_to] = getLastEmissionNum();
803     }
804 
805     /// @dev calculates dividends for the account _for
806     /// @return (true if state has to be updated, dividend amount (could be 0!))
807     function calculateDividendsFor(address _for) constant internal returns (bool hasNewDividends, uint dividends) {
808         assert(_for != dividendsPool);  // no dividends for the pool!
809 
810         uint256 lastEmissionNum = getLastEmissionNum();
811         uint256 lastAccountEmissionNum = m_lastAccountEmission[_for];
812         assert(lastAccountEmissionNum <= lastEmissionNum);
813         if (lastAccountEmissionNum == lastEmissionNum)
814             return (false, 0);
815 
816         uint256 initialBalance = balances[_for];    // beware of recursion!
817         if (0 == initialBalance)
818             return (true, 0);
819 
820         uint256 balance = initialBalance;
821         for (uint256 emissionToProcess = lastAccountEmissionNum + 1; emissionToProcess <= lastEmissionNum; emissionToProcess++) {
822             EmissionInfo storage emission = m_emissions[emissionToProcess];
823             assert(0 != emission.created && 0 != emission.totalSupplyWas);
824 
825             uint256 dividend = balance.mul(emission.created).div(emission.totalSupplyWas);
826             Dividend(_for, dividend);
827 
828             balance = balance.add(dividend);
829         }
830 
831         return (true, balance.sub(initialBalance));
832     }
833 
834     function getLastEmissionNum() private constant returns (uint256) {
835         return m_emissions.length - 1;
836     }
837 
838 
839     // FIELDS
840 
841     /// @notice if this true then token is still externally mintable (but this flag does't affect emissions!)
842     bool public m_externalMintingEnabled = true;
843 
844     /// @dev internal address of dividends in balances mapping.
845     address dividendsPool;
846 
847     /// @notice record of issued dividend emissions
848     EmissionInfo[] public m_emissions;
849 
850     /// @dev for each token holder: last emission (index in m_emissions) which was processed for this holder
851     mapping(address => uint256) m_lastAccountEmission;
852 }
853 /*************************************************************************
854  * import "../token/MintableMultiownedToken.sol" : end
855  *************************************************************************/
856 /*************************************************************************
857  * import "./IInvestmentsWalletConnector.sol" : start
858  *************************************************************************/
859 
860 /**
861  * @title Interface for code which processes and stores investments.
862  * @author Eenae
863  */
864 contract IInvestmentsWalletConnector {
865     /// @dev process and forward investment
866     function storeInvestment(address investor, uint payment) internal;
867 
868     /// @dev total investments amount stored using storeInvestment()
869     function getTotalInvestmentsStored() internal constant returns (uint);
870 
871     /// @dev called in case crowdsale succeeded
872     function wcOnCrowdsaleSuccess() internal;
873 
874     /// @dev called in case crowdsale failed
875     function wcOnCrowdsaleFailure() internal;
876 }
877 /*************************************************************************
878  * import "./IInvestmentsWalletConnector.sol" : end
879  *************************************************************************/
880 /*************************************************************************
881  * import "./ICrowdsaleStat.sol" : start
882  *************************************************************************/
883 
884 /**
885  * @title Basic crowdsale stat
886  * @author Eenae
887  */
888 contract ICrowdsaleStat {
889 
890     /// @notice amount of funds collected in wei
891     function getWeiCollected() public constant returns (uint);
892 
893     /// @notice amount of tokens minted (NOT equal to totalSupply() in case token is reused!)
894     function getTokenMinted() public constant returns (uint);
895 }
896 /*************************************************************************
897  * import "./ICrowdsaleStat.sol" : end
898  *************************************************************************/
899 /*************************************************************************
900  * import "zeppelin-solidity/contracts/ReentrancyGuard.sol" : start
901  *************************************************************************/
902 
903 /**
904  * @title Helps contracts guard agains rentrancy attacks.
905  * @author Remco Bloemen <remco@2π.com>
906  * @notice If you mark a function `nonReentrant`, you should also
907  * mark it `external`.
908  */
909 contract ReentrancyGuard {
910 
911   /**
912    * @dev We use a single lock for the whole contract.
913    */
914   bool private rentrancy_lock = false;
915 
916   /**
917    * @dev Prevents a contract from calling itself, directly or indirectly.
918    * @notice If you mark a function `nonReentrant`, you should also
919    * mark it `external`. Calling one nonReentrant function from
920    * another is not supported. Instead, you can implement a
921    * `private` function doing the actual work, and a `external`
922    * wrapper marked as `nonReentrant`.
923    */
924   modifier nonReentrant() {
925     require(!rentrancy_lock);
926     rentrancy_lock = true;
927     _;
928     rentrancy_lock = false;
929   }
930 
931 }
932 /*************************************************************************
933  * import "zeppelin-solidity/contracts/ReentrancyGuard.sol" : end
934  *************************************************************************/
935 
936 
937 
938 /// @title Base contract for simple crowdsales
939 contract SimpleCrowdsaleBase is ArgumentsChecker, ReentrancyGuard, IInvestmentsWalletConnector, ICrowdsaleStat {
940     using SafeMath for uint256;
941 
942     event FundTransfer(address backer, uint amount, bool isContribution);
943 
944     function SimpleCrowdsaleBase(address token)
945         validAddress(token)
946     {
947         m_token = MintableMultiownedToken(token);
948     }
949 
950 
951     // PUBLIC interface: payments
952 
953     // fallback function as a shortcut
954     function() payable {
955         require(0 == msg.data.length);
956         buy();  // only internal call here!
957     }
958 
959     /// @notice crowdsale participation
960     function buy() public payable {     // dont mark as external!
961         buyInternal(msg.sender, msg.value, 0);
962     }
963 
964 
965     // INTERNAL
966 
967     /// @dev payment processing
968     function buyInternal(address investor, uint payment, uint extraBonuses)
969         internal
970         nonReentrant
971     {
972         require(payment >= getMinInvestment());
973         require(getCurrentTime() >= getStartTime() || ! mustApplyTimeCheck(investor, payment) /* for final check */);
974         if (getCurrentTime() >= getEndTime())
975             finish();
976 
977         if (m_finished) {
978             // saving provided gas
979             investor.transfer(payment);
980             return;
981         }
982 
983         uint startingWeiCollected = getWeiCollected();
984         uint startingInvariant = this.balance.add(startingWeiCollected);
985 
986         // return or update payment if needed
987         uint paymentAllowed = getMaximumFunds().sub(getWeiCollected());
988         assert(0 != paymentAllowed);
989 
990         uint change;
991         if (paymentAllowed < payment) {
992             change = payment.sub(paymentAllowed);
993             payment = paymentAllowed;
994         }
995 
996         // issue tokens
997         uint tokens = calculateTokens(investor, payment, extraBonuses);
998         m_token.mint(investor, tokens);
999         m_tokensMinted += tokens;
1000 
1001         // record payment
1002         storeInvestment(investor, payment);
1003         assert(getWeiCollected() <= getMaximumFunds() && getWeiCollected() > startingWeiCollected);
1004         FundTransfer(investor, payment, true);
1005 
1006         if (getWeiCollected() == getMaximumFunds())
1007             finish();
1008 
1009         if (change > 0)
1010             investor.transfer(change);
1011 
1012         assert(startingInvariant == this.balance.add(getWeiCollected()).add(change));
1013     }
1014 
1015     function finish() internal {
1016         if (m_finished)
1017             return;
1018 
1019         if (getWeiCollected() >= getMinimumFunds())
1020             wcOnCrowdsaleSuccess();
1021         else
1022             wcOnCrowdsaleFailure();
1023 
1024         m_finished = true;
1025     }
1026 
1027 
1028     // Other pluggables
1029 
1030     /// @dev says if crowdsale time bounds must be checked
1031     function mustApplyTimeCheck(address /*investor*/, uint /*payment*/) constant internal returns (bool) {
1032         return true;
1033     }
1034 
1035     /// @dev to be overridden in tests
1036     function getCurrentTime() internal constant returns (uint) {
1037         return now;
1038     }
1039 
1040     /// @notice maximum investments to be accepted during pre-ICO
1041     function getMaximumFunds() internal constant returns (uint);
1042 
1043     /// @notice minimum amount of funding to consider crowdsale as successful
1044     function getMinimumFunds() internal constant returns (uint);
1045 
1046     /// @notice start time of the pre-ICO
1047     function getStartTime() internal constant returns (uint);
1048 
1049     /// @notice end time of the pre-ICO
1050     function getEndTime() internal constant returns (uint);
1051 
1052     /// @notice minimal amount of investment
1053     function getMinInvestment() public constant returns (uint) {
1054         return 10 finney;
1055     }
1056 
1057     /// @dev calculates token amount for given investment
1058     function calculateTokens(address investor, uint payment, uint extraBonuses) internal constant returns (uint);
1059 
1060 
1061     // ICrowdsaleStat
1062 
1063     function getWeiCollected() public constant returns (uint) {
1064         return getTotalInvestmentsStored();
1065     }
1066 
1067     /// @notice amount of tokens minted (NOT equal to totalSupply() in case token is reused!)
1068     function getTokenMinted() public constant returns (uint) {
1069         return m_tokensMinted;
1070     }
1071 
1072 
1073     // FIELDS
1074 
1075     /// @dev contract responsible for token accounting
1076     MintableMultiownedToken public m_token;
1077 
1078     uint m_tokensMinted;
1079 
1080     bool m_finished = false;
1081 }
1082 /*************************************************************************
1083  * import "./crowdsale/SimpleCrowdsaleBase.sol" : end
1084  *************************************************************************/
1085 /*************************************************************************
1086  * import "./crowdsale/InvestmentAnalytics.sol" : start
1087  *************************************************************************/
1088 
1089 
1090 
1091 
1092 /*
1093  * @title This is proxy for analytics. Target contract can be found at field m_analytics (see "read contract").
1094  * @author Eenae
1095 
1096  * FIXME after fix of truffle issue #560: refactor to a separate contract file which uses InvestmentAnalytics interface
1097  */
1098 contract AnalyticProxy {
1099 
1100     function AnalyticProxy() {
1101         m_analytics = InvestmentAnalytics(msg.sender);
1102     }
1103 
1104     /// @notice forward payment to analytics-capable contract
1105     function() payable {
1106         m_analytics.iaInvestedBy.value(msg.value)(msg.sender);
1107     }
1108 
1109     InvestmentAnalytics public m_analytics;
1110 }
1111 
1112 
1113 /*
1114  * @title Mixin contract which supports different payment channels and provides analytical per-channel data.
1115  * @author Eenae
1116  */
1117 contract InvestmentAnalytics {
1118     using SafeMath for uint256;
1119 
1120     function InvestmentAnalytics(){
1121     }
1122 
1123     /// @dev creates more payment channels, up to the limit but not exceeding gas stipend
1124     function createMorePaymentChannelsInternal(uint limit) internal returns (uint) {
1125         uint paymentChannelsCreated;
1126         for (uint i = 0; i < limit; i++) {
1127             uint startingGas = msg.gas;
1128             /*
1129              * ~170k of gas per paymentChannel,
1130              * using gas price = 4Gwei 2k paymentChannels will cost ~1.4 ETH.
1131              */
1132 
1133             address paymentChannel = new AnalyticProxy();
1134             m_validPaymentChannels[paymentChannel] = true;
1135             m_paymentChannels.push(paymentChannel);
1136             paymentChannelsCreated++;
1137 
1138             // cost of creating one channel
1139             uint gasPerChannel = startingGas.sub(msg.gas);
1140             if (gasPerChannel.add(50000) > msg.gas)
1141                 break;  // enough proxies for this call
1142         }
1143         return paymentChannelsCreated;
1144     }
1145 
1146 
1147     /// @dev process payments - record analytics and pass control to iaOnInvested callback
1148     function iaInvestedBy(address investor) external payable {
1149         address paymentChannel = msg.sender;
1150         if (m_validPaymentChannels[paymentChannel]) {
1151             // payment received by one of our channels
1152             uint value = msg.value;
1153             m_investmentsByPaymentChannel[paymentChannel] = m_investmentsByPaymentChannel[paymentChannel].add(value);
1154             // We know for sure that investment came from specified investor (see AnalyticProxy).
1155             iaOnInvested(investor, value, true);
1156         } else {
1157             // Looks like some user has paid to this method, this payment is not included in the analytics,
1158             // but, of course, processed.
1159             iaOnInvested(msg.sender, msg.value, false);
1160         }
1161     }
1162 
1163     /// @dev callback
1164     function iaOnInvested(address /*investor*/, uint /*payment*/, bool /*usingPaymentChannel*/) internal {
1165     }
1166 
1167 
1168     function paymentChannelsCount() external constant returns (uint) {
1169         return m_paymentChannels.length;
1170     }
1171 
1172     function readAnalyticsMap() external constant returns (address[], uint[]) {
1173         address[] memory keys = new address[](m_paymentChannels.length);
1174         uint[] memory values = new uint[](m_paymentChannels.length);
1175 
1176         for (uint i = 0; i < m_paymentChannels.length; i++) {
1177             address key = m_paymentChannels[i];
1178             keys[i] = key;
1179             values[i] = m_investmentsByPaymentChannel[key];
1180         }
1181 
1182         return (keys, values);
1183     }
1184 
1185     function readPaymentChannels() external constant returns (address[]) {
1186         return m_paymentChannels;
1187     }
1188 
1189 
1190     mapping(address => uint256) public m_investmentsByPaymentChannel;
1191     mapping(address => bool) m_validPaymentChannels;
1192 
1193     address[] public m_paymentChannels;
1194 }
1195 /*************************************************************************
1196  * import "./crowdsale/InvestmentAnalytics.sol" : end
1197  *************************************************************************/
1198 /*************************************************************************
1199  * import "zeppelin-solidity/contracts/ownership/Ownable.sol" : start
1200  *************************************************************************/
1201 
1202 
1203 /**
1204  * @title Ownable
1205  * @dev The Ownable contract has an owner address, and provides basic authorization control
1206  * functions, this simplifies the implementation of "user permissions".
1207  */
1208 contract Ownable {
1209   address public owner;
1210 
1211 
1212   /**
1213    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1214    * account.
1215    */
1216   function Ownable() {
1217     owner = msg.sender;
1218   }
1219 
1220 
1221   /**
1222    * @dev Throws if called by any account other than the owner.
1223    */
1224   modifier onlyOwner() {
1225     require(msg.sender == owner);
1226     _;
1227   }
1228 
1229 
1230   /**
1231    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1232    * @param newOwner The address to transfer ownership to.
1233    */
1234   function transferOwnership(address newOwner) onlyOwner {
1235     if (newOwner != address(0)) {
1236       owner = newOwner;
1237     }
1238   }
1239 
1240 }
1241 /*************************************************************************
1242  * import "zeppelin-solidity/contracts/ownership/Ownable.sol" : end
1243  *************************************************************************/
1244 
1245 
1246 /// @title Base contract for Storiqa pre-ICO
1247 contract STQPreICOBase is SimpleCrowdsaleBase, Ownable, InvestmentAnalytics {
1248 
1249     function STQPreICOBase(address token)
1250         SimpleCrowdsaleBase(token)
1251     {
1252     }
1253 
1254 
1255     // PUBLIC interface: maintenance
1256 
1257     function createMorePaymentChannels(uint limit) external onlyOwner returns (uint) {
1258         return createMorePaymentChannelsInternal(limit);
1259     }
1260 
1261     /// @notice Tests ownership of the current caller.
1262     /// @return true if it's an owner
1263     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
1264     // addOwner/changeOwner and to isOwner.
1265     function amIOwner() external constant onlyOwner returns (bool) {
1266         return true;
1267     }
1268 
1269 
1270     // INTERNAL
1271 
1272     /// @dev payment callback
1273     function iaOnInvested(address investor, uint payment, bool usingPaymentChannel) internal {
1274         buyInternal(investor, payment, usingPaymentChannel ? c_paymentChannelBonusPercent : 0);
1275     }
1276 
1277     function calculateTokens(address /*investor*/, uint payment, uint extraBonuses) internal constant returns (uint) {
1278         uint bonusPercent = getPreICOBonus().add(getLargePaymentBonus(payment)).add(extraBonuses);
1279         uint rate = c_STQperETH.mul(bonusPercent.add(100)).div(100);
1280 
1281         return payment.mul(rate);
1282     }
1283 
1284     function getLargePaymentBonus(uint payment) private constant returns (uint) {
1285         if (payment > 1000 ether) return 10;
1286         if (payment > 800 ether) return 8;
1287         if (payment > 500 ether) return 5;
1288         if (payment > 200 ether) return 2;
1289         return 0;
1290     }
1291 
1292     function mustApplyTimeCheck(address investor, uint /*payment*/) constant internal returns (bool) {
1293         return investor != owner;
1294     }
1295 
1296     /// @notice pre-ICO bonus
1297     function getPreICOBonus() internal constant returns (uint);
1298 
1299 
1300     // FIELDS
1301 
1302     /// @notice starting exchange rate of STQ
1303     uint public constant c_STQperETH = 100000;
1304 
1305     /// @notice authorised payment bonus
1306     uint public constant c_paymentChannelBonusPercent = 2;
1307 }
1308 /*************************************************************************
1309  * import "./STQPreICOBase.sol" : end
1310  *************************************************************************/
1311 /*************************************************************************
1312  * import "./crowdsale/FundsRegistryWalletConnector.sol" : start
1313  *************************************************************************/
1314 
1315 
1316 /*************************************************************************
1317  * import "./FundsRegistry.sol" : start
1318  *************************************************************************/
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 /// @title registry of funds sent by investors
1327 contract FundsRegistry is ArgumentsChecker, MultiownedControlled, ReentrancyGuard {
1328     using SafeMath for uint256;
1329 
1330     enum State {
1331         // gathering funds
1332         GATHERING,
1333         // returning funds to investors
1334         REFUNDING,
1335         // funds can be pulled by owners
1336         SUCCEEDED
1337     }
1338 
1339     event StateChanged(State _state);
1340     event Invested(address indexed investor, uint256 amount);
1341     event EtherSent(address indexed to, uint value);
1342     event RefundSent(address indexed to, uint value);
1343 
1344 
1345     modifier requiresState(State _state) {
1346         require(m_state == _state);
1347         _;
1348     }
1349 
1350 
1351     // PUBLIC interface
1352 
1353     function FundsRegistry(address[] _owners, uint _signaturesRequired, address _controller)
1354         MultiownedControlled(_owners, _signaturesRequired, _controller)
1355     {
1356     }
1357 
1358     /// @dev performs only allowed state transitions
1359     function changeState(State _newState)
1360         external
1361         onlyController
1362     {
1363         assert(m_state != _newState);
1364 
1365         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
1366         else assert(false);
1367 
1368         m_state = _newState;
1369         StateChanged(m_state);
1370     }
1371 
1372     /// @dev records an investment
1373     function invested(address _investor)
1374         external
1375         payable
1376         onlyController
1377         requiresState(State.GATHERING)
1378     {
1379         uint256 amount = msg.value;
1380         require(0 != amount);
1381         assert(_investor != m_controller);
1382 
1383         // register investor
1384         if (0 == m_weiBalances[_investor])
1385             m_investors.push(_investor);
1386 
1387         // register payment
1388         totalInvested = totalInvested.add(amount);
1389         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
1390 
1391         Invested(_investor, amount);
1392     }
1393 
1394     /// @notice owners: send `value` of ether to address `to`, can be called if crowdsale succeeded
1395     /// @param to where to send ether
1396     /// @param value amount of wei to send
1397     function sendEther(address to, uint value)
1398         external
1399         validAddress(to)
1400         onlymanyowners(sha3(msg.data))
1401         requiresState(State.SUCCEEDED)
1402     {
1403         require(value > 0 && this.balance >= value);
1404         to.transfer(value);
1405         EtherSent(to, value);
1406     }
1407 
1408     /// @notice withdraw accumulated balance, called by payee in case crowdsale failed
1409     function withdrawPayments()
1410         external
1411         nonReentrant
1412         requiresState(State.REFUNDING)
1413     {
1414         address payee = msg.sender;
1415         uint256 payment = m_weiBalances[payee];
1416 
1417         require(payment != 0);
1418         require(this.balance >= payment);
1419 
1420         totalInvested = totalInvested.sub(payment);
1421         m_weiBalances[payee] = 0;
1422 
1423         payee.transfer(payment);
1424         RefundSent(payee, payment);
1425     }
1426 
1427     function getInvestorsCount() external constant returns (uint) { return m_investors.length; }
1428 
1429 
1430     // FIELDS
1431 
1432     /// @notice total amount of investments in wei
1433     uint256 public totalInvested;
1434 
1435     /// @notice state of the registry
1436     State public m_state = State.GATHERING;
1437 
1438     /// @dev balances of investors in wei
1439     mapping(address => uint256) public m_weiBalances;
1440 
1441     /// @dev list of unique investors
1442     address[] public m_investors;
1443 }
1444 /*************************************************************************
1445  * import "./FundsRegistry.sol" : end
1446  *************************************************************************/
1447 
1448 
1449 /**
1450  * @title Stores investments in FundsRegistry.
1451  * @author Eenae
1452  */
1453 contract FundsRegistryWalletConnector is IInvestmentsWalletConnector {
1454 
1455     function FundsRegistryWalletConnector(address[] fundOwners, uint ownersSignatures)
1456     {
1457         m_fundsAddress = new FundsRegistry(fundOwners, ownersSignatures, this);
1458     }
1459 
1460     /// @dev process and forward investment
1461     function storeInvestment(address investor, uint payment) internal
1462     {
1463         m_fundsAddress.invested.value(payment)(investor);
1464     }
1465 
1466     /// @dev total investments amount stored using storeInvestment()
1467     function getTotalInvestmentsStored() internal constant returns (uint)
1468     {
1469         return m_fundsAddress.totalInvested();
1470     }
1471 
1472     /// @dev called in case crowdsale succeeded
1473     function wcOnCrowdsaleSuccess() internal {
1474         m_fundsAddress.changeState(FundsRegistry.State.SUCCEEDED);
1475         m_fundsAddress.detachController();
1476     }
1477 
1478     /// @dev called in case crowdsale failed
1479     function wcOnCrowdsaleFailure() internal {
1480         m_fundsAddress.changeState(FundsRegistry.State.REFUNDING);
1481         m_fundsAddress.detachController();
1482     }
1483 
1484     /// @notice address of wallet which stores funds
1485     FundsRegistry public m_fundsAddress;
1486 }
1487 /*************************************************************************
1488  * import "./crowdsale/FundsRegistryWalletConnector.sol" : end
1489  *************************************************************************/
1490 
1491 
1492 /// @title Storiqa pre-ICO contract
1493 contract STQPreICO2 is STQPreICOBase, FundsRegistryWalletConnector {
1494 
1495     function STQPreICO2(address token, address[] fundOwners)
1496         STQPreICOBase(token)
1497         FundsRegistryWalletConnector(fundOwners, 2)
1498     {
1499         require(3 == fundOwners.length);
1500     }
1501 
1502 
1503     // INTERNAL
1504 
1505     function getWeiCollected() public constant returns (uint) {
1506         return getTotalInvestmentsStored().add(2401 ether /* previous crowdsales */);
1507     }
1508 
1509     /// @notice minimum amount of funding to consider crowdsale as successful
1510     function getMinimumFunds() internal constant returns (uint) {
1511         return 3500 ether;
1512     }
1513 
1514     /// @notice maximum investments to be accepted during pre-ICO
1515     function getMaximumFunds() internal constant returns (uint) {
1516         return 8500 ether;
1517     }
1518 
1519     /// @notice start time of the pre-ICO
1520     function getStartTime() internal constant returns (uint) {
1521         return 1508346000;
1522     }
1523 
1524     /// @notice end time of the pre-ICO
1525     function getEndTime() internal constant returns (uint) {
1526         return getStartTime() + (5 days);
1527     }
1528 
1529     /// @notice pre-ICO bonus
1530     function getPreICOBonus() internal constant returns (uint) {
1531         return 35;
1532     }
1533 }