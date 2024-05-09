1 pragma solidity ^0.4.18;
2 
3 interface IApprovalRecipient {
4     /**
5      * @notice Signals that token holder approved spending of tokens and some action should be taken.
6      *
7      * @param _sender token holder which approved spending of his tokens
8      * @param _value amount of tokens approved to be spent
9      * @param _extraData any extra data token holder provided to the call
10      *
11      * @dev warning: implementors should validate sender of this message (it should be the token) and make no further
12      *      assumptions unless validated them via ERC20 methods.
13      */
14     function receiveApproval(address _sender, uint256 _value, bytes _extraData) public;
15 }
16 
17 interface IKYCProvider {
18     function isKYCPassed(address _address) public view returns (bool);
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract ArgumentsChecker {
51 
52     /// @dev check which prevents short address attack
53     modifier payloadSizeIs(uint size) {
54        require(msg.data.length == size + 4 /* function selector */);
55        _;
56     }
57 
58     /// @dev check that address is valid
59     modifier validAddress(address addr) {
60         require(addr != address(0));
61         _;
62     }
63 }
64 
65 contract multiowned {
66 
67 	// TYPES
68 
69     // struct for the status of a pending operation.
70     struct MultiOwnedOperationPendingState {
71         // count of confirmations needed
72         uint yetNeeded;
73 
74         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
75         uint ownersDone;
76 
77         // position of this operation key in m_multiOwnedPendingIndex
78         uint index;
79     }
80 
81 	// EVENTS
82 
83     event Confirmation(address owner, bytes32 operation);
84     event Revoke(address owner, bytes32 operation);
85     event FinalConfirmation(address owner, bytes32 operation);
86 
87     // some others are in the case of an owner changing.
88     event OwnerChanged(address oldOwner, address newOwner);
89     event OwnerAdded(address newOwner);
90     event OwnerRemoved(address oldOwner);
91 
92     // the last one is emitted if the required signatures change
93     event RequirementChanged(uint newRequirement);
94 
95 	// MODIFIERS
96 
97     // simple single-sig function modifier.
98     modifier onlyowner {
99         require(isOwner(msg.sender));
100         _;
101     }
102     // multi-sig function modifier: the operation must have an intrinsic hash in order
103     // that later attempts can be realised as the same underlying operation and
104     // thus count as confirmations.
105     modifier onlymanyowners(bytes32 _operation) {
106         if (confirmAndCheck(_operation)) {
107             _;
108         }
109         // Even if required number of confirmations has't been collected yet,
110         // we can't throw here - because changes to the state have to be preserved.
111         // But, confirmAndCheck itself will throw in case sender is not an owner.
112     }
113 
114     modifier validNumOwners(uint _numOwners) {
115         require(_numOwners > 0 && _numOwners <= c_maxOwners);
116         _;
117     }
118 
119     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
120         require(_required > 0 && _required <= _numOwners);
121         _;
122     }
123 
124     modifier ownerExists(address _address) {
125         require(isOwner(_address));
126         _;
127     }
128 
129     modifier ownerDoesNotExist(address _address) {
130         require(!isOwner(_address));
131         _;
132     }
133 
134     modifier multiOwnedOperationIsActive(bytes32 _operation) {
135         require(isOperationActive(_operation));
136         _;
137     }
138 
139 	// METHODS
140 
141     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
142     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
143     function multiowned(address[] _owners, uint _required)
144         public
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
175         onlymanyowners(keccak256(msg.data))
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
196         onlymanyowners(keccak256(msg.data))
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
217         onlymanyowners(keccak256(msg.data))
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
238         onlymanyowners(keccak256(msg.data))
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
277     /// @param _operation operation value, typically keccak256(msg.data)
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
297     /// @param _operation operation value, typically keccak256(msg.data)
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
393     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
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
447 
448 contract ERC20Basic {
449   uint256 public totalSupply;
450   function balanceOf(address who) public view returns (uint256);
451   function transfer(address to, uint256 value) public returns (bool);
452   event Transfer(address indexed from, address indexed to, uint256 value);
453 }
454 
455 contract ERC20 is ERC20Basic {
456   function allowance(address owner, address spender) public view returns (uint256);
457   function transferFrom(address from, address to, uint256 value) public returns (bool);
458   function approve(address spender, uint256 value) public returns (bool);
459   event Approval(address indexed owner, address indexed spender, uint256 value);
460 }
461 
462 contract BasicToken is ERC20Basic {
463   using SafeMath for uint256;
464 
465   mapping(address => uint256) balances;
466 
467   /**
468   * @dev transfer token for a specified address
469   * @param _to The address to transfer to.
470   * @param _value The amount to be transferred.
471   */
472   function transfer(address _to, uint256 _value) public returns (bool) {
473     require(_to != address(0));
474     require(_value <= balances[msg.sender]);
475 
476     // SafeMath.sub will throw if there is not enough balance.
477     balances[msg.sender] = balances[msg.sender].sub(_value);
478     balances[_to] = balances[_to].add(_value);
479     Transfer(msg.sender, _to, _value);
480     return true;
481   }
482 
483   /**
484   * @dev Gets the balance of the specified address.
485   * @param _owner The address to query the the balance of.
486   * @return An uint256 representing the amount owned by the passed address.
487   */
488   function balanceOf(address _owner) public view returns (uint256 balance) {
489     return balances[_owner];
490   }
491 
492 }
493 
494 contract BurnableToken is BasicToken {
495 
496     event Burn(address indexed from, uint256 amount);
497 
498     /**
499      * Function to burn msg.sender's tokens.
500      *
501      * @param _amount amount of tokens to burn
502      *
503      * @return boolean that indicates if the operation was successful
504      */
505     function burn(uint256 _amount)
506         public
507         returns (bool)
508     {
509         address from = msg.sender;
510 
511         require(_amount > 0);
512         require(_amount <= balances[from]);
513 
514         totalSupply = totalSupply.sub(_amount);
515         balances[from] = balances[from].sub(_amount);
516         Burn(from, _amount);
517         Transfer(from, address(0), _amount);
518 
519         return true;
520     }
521 }
522 
523 contract StandardToken is ERC20, BasicToken {
524 
525   mapping (address => mapping (address => uint256)) internal allowed;
526 
527 
528   /**
529    * @dev Transfer tokens from one address to another
530    * @param _from address The address which you want to send tokens from
531    * @param _to address The address which you want to transfer to
532    * @param _value uint256 the amount of tokens to be transferred
533    */
534   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
535     require(_to != address(0));
536     require(_value <= balances[_from]);
537     require(_value <= allowed[_from][msg.sender]);
538 
539     balances[_from] = balances[_from].sub(_value);
540     balances[_to] = balances[_to].add(_value);
541     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
542     Transfer(_from, _to, _value);
543     return true;
544   }
545 
546   /**
547    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
548    *
549    * Beware that changing an allowance with this method brings the risk that someone may use both the old
550    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
551    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
552    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
553    * @param _spender The address which will spend the funds.
554    * @param _value The amount of tokens to be spent.
555    */
556   function approve(address _spender, uint256 _value) public returns (bool) {
557     allowed[msg.sender][_spender] = _value;
558     Approval(msg.sender, _spender, _value);
559     return true;
560   }
561 
562   /**
563    * @dev Function to check the amount of tokens that an owner allowed to a spender.
564    * @param _owner address The address which owns the funds.
565    * @param _spender address The address which will spend the funds.
566    * @return A uint256 specifying the amount of tokens still available for the spender.
567    */
568   function allowance(address _owner, address _spender) public view returns (uint256) {
569     return allowed[_owner][_spender];
570   }
571 
572   /**
573    * approve should be called when allowed[_spender] == 0. To increment
574    * allowed value is better to use this function to avoid 2 calls (and wait until
575    * the first transaction is mined)
576    * From MonolithDAO Token.sol
577    */
578   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
579     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
580     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
581     return true;
582   }
583 
584   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
585     uint oldValue = allowed[msg.sender][_spender];
586     if (_subtractedValue > oldValue) {
587       allowed[msg.sender][_spender] = 0;
588     } else {
589       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
590     }
591     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
592     return true;
593   }
594 
595 }
596 
597 contract TokenWithApproveAndCallMethod is StandardToken {
598 
599     /**
600      * @notice Approves spending tokens and immediately triggers token recipient logic.
601      *
602      * @param _spender contract which supports IApprovalRecipient and allowed to receive tokens
603      * @param _value amount of tokens approved to be spent
604      * @param _extraData any extra data which to be provided to the _spender
605      *
606      * By invoking this utility function token holder could do two things in one transaction: approve spending his
607      * tokens and execute some external contract which spends them on token holder's behalf.
608      * It can't be known if _spender's invocation succeed or not.
609      * This function will throw if approval failed.
610      */
611     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public {
612         require(approve(_spender, _value));
613         IApprovalRecipient(_spender).receiveApproval(msg.sender, _value, _extraData);
614     }
615 }
616 
617 contract SmartzToken is ArgumentsChecker, multiowned, BurnableToken, StandardToken {
618 
619     /// @title Unit of frozen tokens - tokens which can't be spent until certain conditions is met.
620     struct FrozenCell {
621         /// @notice amount of frozen tokens
622         uint amount;
623 
624         /// @notice until this unix time the cell is considered frozen
625         uint128 thawTS;
626 
627         /// @notice is KYC required for a token holder to spend this cell?
628         uint128 isKYCRequired;
629     }
630 
631 
632     // MODIFIERS
633 
634     modifier onlySale(address account) {
635         require(isSale(account));
636         _;
637     }
638 
639     modifier validUnixTS(uint ts) {
640         require(ts >= 1522046326 && ts <= 1800000000);
641         _;
642     }
643 
644     modifier checkTransferInvariant(address from, address to) {
645         uint initial = balanceOf(from).add(balanceOf(to));
646         _;
647         assert(balanceOf(from).add(balanceOf(to)) == initial);
648     }
649 
650     modifier privilegedAllowed {
651         require(m_allowPrivileged);
652         _;
653     }
654 
655 
656     // PUBLIC FUNCTIONS
657 
658     /**
659      * @notice Constructs token.
660      *
661      * Initial owners have power over the token contract only during bootstrap phase (early investments and token
662      * sales). To be precise, the owners can set KYC provider and sales (which can freeze transfered tokens) during
663      * bootstrap phase. After final token sale any control over the token removed by issuing disablePrivileged call.
664      */
665     function SmartzToken()
666         public
667         payable
668         multiowned(getInitialOwners(), 1)
669     {
670         if (0 != 9999999999999) {
671             totalSupply = 9999999999999;
672             balances[msg.sender] = totalSupply;
673             Transfer(address(0), msg.sender, totalSupply);
674         }
675 
676         
677 totalSupply = totalSupply.add(0);
678 
679         
680         address(0xfF20387Dd4dbfA3e72AbC7Ee9B03393A941EE36E).transfer(60000000000000000 wei);
681         address(0xfF20387Dd4dbfA3e72AbC7Ee9B03393A941EE36E).transfer(240000000000000000 wei);
682             
683     }
684 
685     function getInitialOwners() private pure returns (address[]) {
686         address[] memory result = new address[](1);
687 result[0] = address(0xa1381D5a5d97abf6f8418fA41FAE44b2CA0Be77C);
688         return result;
689     }
690 
691     /**
692      * @notice Version of balanceOf() which includes all frozen tokens.
693      *
694      * @param _owner the address to query the balance of
695      *
696      * @return an uint256 representing the amount owned by the passed address
697      */
698     function balanceOf(address _owner) public view returns (uint256) {
699         uint256 balance = balances[_owner];
700 
701         for (uint cellIndex = 0; cellIndex < frozenBalances[_owner].length; ++cellIndex) {
702             balance = balance.add(frozenBalances[_owner][cellIndex].amount);
703         }
704 
705         return balance;
706     }
707 
708     /**
709      * @notice Version of balanceOf() which includes only currently spendable tokens.
710      *
711      * @param _owner the address to query the balance of
712      *
713      * @return an uint256 representing the amount spendable by the passed address
714      */
715     function availableBalanceOf(address _owner) public view returns (uint256) {
716         uint256 balance = balances[_owner];
717 
718         for (uint cellIndex = 0; cellIndex < frozenBalances[_owner].length; ++cellIndex) {
719             if (isSpendableFrozenCell(_owner, cellIndex))
720                 balance = balance.add(frozenBalances[_owner][cellIndex].amount);
721         }
722 
723         return balance;
724     }
725 
726     /**
727      * @notice Standard transfer() overridden to have a chance to thaw sender's tokens.
728      *
729      * @param _to the address to transfer to
730      * @param _value the amount to be transferred
731      *
732      * @return true iff operation was successfully completed
733      */
734     function transfer(address _to, uint256 _value)
735         public
736         payloadSizeIs(2 * 32)
737         returns (bool)
738     {
739         thawSomeTokens(msg.sender, _value);
740         return super.transfer(_to, _value);
741     }
742 
743     /**
744      * @notice Standard transferFrom overridden to have a chance to thaw sender's tokens.
745      *
746      * @param _from address the address which you want to send tokens from
747      * @param _to address the address which you want to transfer to
748      * @param _value uint256 the amount of tokens to be transferred
749      *
750      * @return true iff operation was successfully completed
751      */
752     function transferFrom(address _from, address _to, uint256 _value)
753         public
754         payloadSizeIs(3 * 32)
755         returns (bool)
756     {
757         thawSomeTokens(_from, _value);
758         return super.transferFrom(_from, _to, _value);
759     }
760 
761     
762     /**
763      * Function to burn msg.sender's tokens. Overridden to have a chance to thaw sender's tokens.
764      *
765      * @param _amount amount of tokens to burn
766      *
767      * @return boolean that indicates if the operation was successful
768      */
769     function burn(uint256 _amount)
770         public
771         payloadSizeIs(1 * 32)
772         returns (bool)
773     {
774         thawSomeTokens(msg.sender, _amount);
775         return super.burn(_amount);
776     }
777 
778 
779     // INFORMATIONAL FUNCTIONS (VIEWS)
780 
781     /**
782      * @notice Number of frozen cells of an account.
783      *
784      * @param owner account address
785      *
786      * @return number of frozen cells
787      */
788     function frozenCellCount(address owner) public view returns (uint) {
789         return frozenBalances[owner].length;
790     }
791 
792     /**
793      * @notice Retrieves information about account frozen tokens.
794      *
795      * @param owner account address
796      * @param index index of so-called frozen cell from 0 (inclusive) up to frozenCellCount(owner) exclusive
797      *
798      * @return amount amount of tokens frozen in this cell
799      * @return thawTS unix timestamp at which tokens'll become available
800      * @return isKYCRequired it's required to pass KYC to spend tokens iff isKYCRequired is true
801      */
802     function frozenCell(address owner, uint index) public view returns (uint amount, uint thawTS, bool isKYCRequired) {
803         require(index < frozenCellCount(owner));
804 
805         amount = frozenBalances[owner][index].amount;
806         thawTS = uint(frozenBalances[owner][index].thawTS);
807         isKYCRequired = decodeKYCFlag(frozenBalances[owner][index].isKYCRequired);
808     }
809 
810 
811     // ADMINISTRATIVE FUNCTIONS
812 
813     /**
814      * @notice Sets current KYC provider of the token.
815      *
816      * @param KYCProvider address of the IKYCProvider-compatible contract
817      *
818      * Function is used only during token sale phase, before disablePrivileged() is called.
819      */
820     function setKYCProvider(address KYCProvider)
821         external
822         validAddress(KYCProvider)
823         privilegedAllowed
824         onlymanyowners(keccak256(msg.data))
825     {
826         m_KYCProvider = IKYCProvider(KYCProvider);
827     }
828 
829     /**
830      * @notice Sets sale status of an account.
831      *
832      * @param account account address
833      * @param isSale is this account has access to frozen* functions
834      *
835      * Function is used only during token sale phase, before disablePrivileged() is called.
836      */
837     function setSale(address account, bool isSale)
838         external
839         validAddress(account)
840         privilegedAllowed
841         onlymanyowners(keccak256(msg.data))
842     {
843         m_sales[account] = isSale;
844     }
845 
846 
847     /**
848      * @notice Transfers tokens to a recipient and freezes it.
849      *
850      * @param _to account to which tokens are sent
851      * @param _value amount of tokens to send
852      * @param thawTS unix timestamp at which tokens'll become available
853      * @param isKYCRequired it's required to pass KYC to spend tokens iff isKYCRequired is true
854      *
855      * Function is used only during token sale phase and available only to sale accounts.
856      */
857     function frozenTransfer(address _to, uint256 _value, uint thawTS, bool isKYCRequired)
858         external
859         validAddress(_to)
860         validUnixTS(thawTS)
861         payloadSizeIs(4 * 32)
862         privilegedAllowed
863         onlySale(msg.sender)
864         checkTransferInvariant(msg.sender, _to)
865         returns (bool)
866     {
867         require(_value <= balances[msg.sender]);
868 
869         balances[msg.sender] = balances[msg.sender].sub(_value);
870         addFrozen(_to, _value, thawTS, isKYCRequired);
871         Transfer(msg.sender, _to, _value);
872 
873         return true;
874     }
875 
876     /**
877      * @notice Transfers frozen tokens back.
878      *
879      * @param _from account to send tokens from
880      * @param _to account to which tokens are sent
881      * @param _value amount of tokens to send
882      * @param thawTS unix timestamp at which tokens'll become available
883      * @param isKYCRequired it's required to pass KYC to spend tokens iff isKYCRequired is true
884      *
885      * Function is used only during token sale phase to make a refunds and available only to sale accounts.
886      * _from account has to explicitly approve spending with the approve() call.
887      * thawTS and isKYCRequired parameters are required to withdraw exact "same" tokens (to not affect availability of
888      * other tokens of the account).
889      */
890     function frozenTransferFrom(address _from, address _to, uint256 _value, uint thawTS, bool isKYCRequired)
891         external
892         validAddress(_to)
893         validUnixTS(thawTS)
894         payloadSizeIs(5 * 32)
895         privilegedAllowed
896         //onlySale(msg.sender) too many local variables - compiler fails
897         //onlySale(_to)
898         checkTransferInvariant(_from, _to)
899         returns (bool)
900     {
901         require(isSale(msg.sender) && isSale(_to));
902         require(_value <= allowed[_from][msg.sender]);
903 
904         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
905         subFrozen(_from, _value, thawTS, isKYCRequired);
906         balances[_to] = balances[_to].add(_value);
907         Transfer(_from, _to, _value);
908 
909         return true;
910     }
911 
912     /// @notice Disables further use of any privileged functions like freezing tokens.
913     function disablePrivileged()
914         external
915         privilegedAllowed
916         onlymanyowners(keccak256(msg.data))
917     {
918         m_allowPrivileged = false;
919     }
920 
921 
922     // INTERNAL FUNCTIONS
923 
924     function isSale(address account) private view returns (bool) {
925         return m_sales[account];
926     }
927 
928     /**
929      * @dev Tries to find existent FrozenCell that matches (thawTS, isKYCRequired).
930      *
931      * @return index in frozenBalances[_owner] which equals to frozenBalances[_owner].length in case cell is not found
932      *
933      * Because frozen* functions are only for token sales and token sale number is limited, expecting cellIndex
934      * to be ~ 1-5 and the following loop to be O(1).
935      */
936     function findFrozenCell(address owner, uint128 thawTSEncoded, uint128 isKYCRequiredEncoded)
937         private
938         view
939         returns (uint cellIndex)
940     {
941         for (cellIndex = 0; cellIndex < frozenBalances[owner].length; ++cellIndex) {
942             FrozenCell storage checkedCell = frozenBalances[owner][cellIndex];
943             if (checkedCell.thawTS == thawTSEncoded && checkedCell.isKYCRequired == isKYCRequiredEncoded)
944                 break;
945         }
946 
947         assert(cellIndex <= frozenBalances[owner].length);
948     }
949 
950     /// @dev Says if the given cell could be spent now
951     function isSpendableFrozenCell(address owner, uint cellIndex)
952         private
953         view
954         returns (bool)
955     {
956         FrozenCell storage cell = frozenBalances[owner][cellIndex];
957         if (uint(cell.thawTS) > getTime())
958             return false;
959 
960         if (0 == cell.amount)   // already spent
961             return false;
962 
963         if (decodeKYCFlag(cell.isKYCRequired) && !m_KYCProvider.isKYCPassed(owner))
964             return false;
965 
966         return true;
967     }
968 
969     /// @dev Internal function to increment or create frozen cell.
970     function addFrozen(address _to, uint256 _value, uint thawTS, bool isKYCRequired)
971         private
972         validAddress(_to)
973         validUnixTS(thawTS)
974     {
975         uint128 thawTSEncoded = uint128(thawTS);
976         uint128 isKYCRequiredEncoded = encodeKYCFlag(isKYCRequired);
977 
978         uint cellIndex = findFrozenCell(_to, thawTSEncoded, isKYCRequiredEncoded);
979 
980         // In case cell is not found - creating new.
981         if (cellIndex == frozenBalances[_to].length) {
982             frozenBalances[_to].length++;
983             targetCell = frozenBalances[_to][cellIndex];
984             assert(0 == targetCell.amount);
985 
986             targetCell.thawTS = thawTSEncoded;
987             targetCell.isKYCRequired = isKYCRequiredEncoded;
988         }
989 
990         FrozenCell storage targetCell = frozenBalances[_to][cellIndex];
991         assert(targetCell.thawTS == thawTSEncoded && targetCell.isKYCRequired == isKYCRequiredEncoded);
992 
993         targetCell.amount = targetCell.amount.add(_value);
994     }
995 
996     /// @dev Internal function to decrement frozen cell.
997     function subFrozen(address _from, uint256 _value, uint thawTS, bool isKYCRequired)
998         private
999         validUnixTS(thawTS)
1000     {
1001         uint cellIndex = findFrozenCell(_from, uint128(thawTS), encodeKYCFlag(isKYCRequired));
1002         require(cellIndex != frozenBalances[_from].length);   // has to be found
1003 
1004         FrozenCell storage cell = frozenBalances[_from][cellIndex];
1005         require(cell.amount >= _value);
1006 
1007         cell.amount = cell.amount.sub(_value);
1008     }
1009 
1010     /// @dev Thaws tokens of owner until enough tokens could be spent or no more such tokens found.
1011     function thawSomeTokens(address owner, uint requiredAmount)
1012         private
1013     {
1014         if (balances[owner] >= requiredAmount)
1015             return;     // fast path
1016 
1017         // Checking that our goal is reachable before issuing expensive storage modifications.
1018         require(availableBalanceOf(owner) >= requiredAmount);
1019 
1020         for (uint cellIndex = 0; cellIndex < frozenBalances[owner].length; ++cellIndex) {
1021             if (isSpendableFrozenCell(owner, cellIndex)) {
1022                 uint amount = frozenBalances[owner][cellIndex].amount;
1023                 frozenBalances[owner][cellIndex].amount = 0;
1024                 balances[owner] = balances[owner].add(amount);
1025             }
1026         }
1027 
1028         assert(balances[owner] >= requiredAmount);
1029     }
1030 
1031     /// @dev to be overridden in tests
1032     function getTime() internal view returns (uint) {
1033         return now;
1034     }
1035 
1036     function encodeKYCFlag(bool isKYCRequired) private pure returns (uint128) {
1037         return isKYCRequired ? uint128(1) : uint128(0);
1038     }
1039 
1040     function decodeKYCFlag(uint128 isKYCRequired) private pure returns (bool) {
1041         return isKYCRequired != uint128(0);
1042     }
1043 
1044 
1045     // FIELDS
1046 
1047     /// @notice current KYC provider of the token
1048     IKYCProvider public m_KYCProvider;
1049 
1050     /// @notice set of sale accounts which can freeze tokens
1051     mapping (address => bool) public m_sales;
1052 
1053     /// @notice frozen tokens
1054     mapping (address => FrozenCell[]) public frozenBalances;
1055 
1056     /// @notice allows privileged functions (token sale phase)
1057     bool public m_allowPrivileged = true;
1058 
1059 
1060     // CONSTANTS
1061 
1062     string public constant name = 'Buytex';
1063     string public constant symbol = 'BUX';
1064     uint8 public constant decimals = 4;
1065 }