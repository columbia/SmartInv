1 pragma solidity ^0.5.6;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 
70 /**
71  * @title Roles
72  * @dev Library for managing addresses assigned to a Role.
73  */
74 library Roles {
75     struct Role {
76         mapping (address => bool) bearer;
77     }
78 
79     /**
80      * @dev give an account access to this role
81      */
82     function add(Role storage role, address account) internal {
83         require(account != address(0));
84         require(!has(role, account));
85 
86         role.bearer[account] = true;
87     }
88 
89     /**
90      * @dev remove an account's access to this role
91      */
92     function remove(Role storage role, address account) internal {
93         require(account != address(0));
94         require(has(role, account));
95 
96         role.bearer[account] = false;
97     }
98 
99     /**
100      * @dev check if an account has this role
101      * @return bool
102      */
103     function has(Role storage role, address account) internal view returns (bool) {
104         require(account != address(0));
105         return role.bearer[account];
106     }
107 }
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 interface IERC20 {
115     function totalSupply() external view returns (uint256);
116 
117     function balanceOf(address who) external view returns (uint256);
118 
119     function allowance(address owner, address spender) external view returns (uint256);
120 
121     function transfer(address to, uint256 value) external returns (bool);
122 
123     function approve(address spender, uint256 value) external returns (bool);
124 
125     function transferFrom(address from, address to, uint256 value) external returns (bool);
126 
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
138  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  *
140  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
141  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
142  * compliant implementations may not do it.
143  */
144 contract ERC20 is IERC20 {
145     using SafeMath for uint256;
146 
147     mapping (address => uint256) private _balances;
148 
149     mapping (address => mapping (address => uint256)) private _allowed;
150 
151     uint256 private _totalSupply;
152 
153     /**
154     * @dev Total number of tokens in existence
155     */
156     function totalSupply() public view returns (uint256) {
157         return _totalSupply;
158     }
159 
160     /**
161     * @dev Gets the balance of the specified address.
162     * @param owner The address to query the balance of.
163     * @return An uint256 representing the amount owned by the passed address.
164     */
165     function balanceOf(address owner) public view returns (uint256) {
166         return _balances[owner];
167     }
168 
169     /**
170      * @dev Function to check the amount of tokens that an owner allowed to a spender.
171      * @param owner address The address which owns the funds.
172      * @param spender address The address which will spend the funds.
173      * @return A uint256 specifying the amount of tokens still available for the spender.
174      */
175     function allowance(address owner, address spender) public view returns (uint256) {
176         return _allowed[owner][spender];
177     }
178 
179     /**
180     * @dev Transfer token for a specified address
181     * @param to The address to transfer to.
182     * @param value The amount to be transferred.
183     */
184     function transfer(address to, uint256 value) public returns (bool) {
185         _transfer(msg.sender, to, value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param spender The address which will spend the funds.
196      * @param value The amount of tokens to be spent.
197      */
198     function approve(address spender, uint256 value) public returns (bool) {
199         require(spender != address(0));
200 
201         _allowed[msg.sender][spender] = value;
202         emit Approval(msg.sender, spender, value);
203         return true;
204     }
205 
206     /**
207      * @dev Transfer tokens from one address to another.
208      * Note that while this function emits an Approval event, this is not required as per the specification,
209      * and other compliant implementations may not emit the event.
210      * @param from address The address which you want to send tokens from
211      * @param to address The address which you want to transfer to
212      * @param value uint256 the amount of tokens to be transferred
213      */
214     function transferFrom(address from, address to, uint256 value) public returns (bool) {
215         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
216         _transfer(from, to, value);
217         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
218         return true;
219     }
220 
221     /**
222      * @dev Increase the amount of tokens that an owner allowed to a spender.
223      * approve should be called when allowed_[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * Emits an Approval event.
228      * @param spender The address which will spend the funds.
229      * @param addedValue The amount of tokens to increase the allowance by.
230      */
231     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
232         require(spender != address(0));
233 
234         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
235         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
236         return true;
237     }
238 
239     /**
240      * @dev Decrease the amount of tokens that an owner allowed to a spender.
241      * approve should be called when allowed_[_spender] == 0. To decrement
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      * Emits an Approval event.
246      * @param spender The address which will spend the funds.
247      * @param subtractedValue The amount of tokens to decrease the allowance by.
248      */
249     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
250         require(spender != address(0));
251 
252         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
253         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
254         return true;
255     }
256 
257     /**
258     * @dev Transfer token for a specified addresses
259     * @param from The address to transfer from.
260     * @param to The address to transfer to.
261     * @param value The amount to be transferred.
262     */
263     function _transfer(address from, address to, uint256 value) internal {
264         require(to != address(0));
265 
266         _balances[from] = _balances[from].sub(value);
267         _balances[to] = _balances[to].add(value);
268         emit Transfer(from, to, value);
269     }
270 
271     /**
272      * @dev Internal function that mints an amount of the token and assigns it to
273      * an account. This encapsulates the modification of balances such that the
274      * proper events are emitted.
275      * @param account The account that will receive the created tokens.
276      * @param value The amount that will be created.
277      */
278     function _mint(address account, uint256 value) internal {
279         require(account != address(0));
280 
281         _totalSupply = _totalSupply.add(value);
282         _balances[account] = _balances[account].add(value);
283         emit Transfer(address(0), account, value);
284     }
285 }
286 
287 
288 contract MinterRole {
289     using Roles for Roles.Role;
290 
291     event MinterAdded(address indexed account);
292     event MinterRemoved(address indexed account);
293 
294     Roles.Role private _minters;
295 
296     constructor () internal {
297         _addMinter(msg.sender);
298     }
299 
300     modifier onlyMinter() {
301         require(isMinter(msg.sender));
302         _;
303     }
304 
305     function isMinter(address account) public view returns (bool) {
306         return _minters.has(account);
307     }
308 
309     function addMinter(address account) public onlyMinter {
310         _addMinter(account);
311     }
312 
313     function renounceMinter() public {
314         _removeMinter(msg.sender);
315     }
316 
317     function _addMinter(address account) internal {
318         _minters.add(account);
319         emit MinterAdded(account);
320     }
321 
322     function _removeMinter(address account) internal {
323         _minters.remove(account);
324         emit MinterRemoved(account);
325     }
326 }
327 
328 contract PauserRole {
329     using Roles for Roles.Role;
330 
331     event PauserAdded(address indexed account);
332     event PauserRemoved(address indexed account);
333 
334     Roles.Role private _pausers;
335 
336     constructor () internal {
337         _addPauser(msg.sender);
338     }
339 
340     modifier onlyPauser() {
341         require(isPauser(msg.sender));
342         _;
343     }
344 
345     function isPauser(address account) public view returns (bool) {
346         return _pausers.has(account);
347     }
348 
349     function addPauser(address account) public onlyPauser {
350         _addPauser(account);
351     }
352 
353     function renouncePauser() public {
354         _removePauser(msg.sender);
355     }
356 
357     function _addPauser(address account) internal {
358         _pausers.add(account);
359         emit PauserAdded(account);
360     }
361 
362     function _removePauser(address account) internal {
363         _pausers.remove(account);
364         emit PauserRemoved(account);
365     }
366 }
367 
368 
369 /**
370  * @title Pausable
371  * @dev Base contract which allows children to implement an emergency stop mechanism.
372  */
373 contract Pausable is PauserRole, ERC20 {
374     event Paused(address account);
375     event Unpaused(address account);
376 
377     bool private _paused;
378 
379     constructor () internal {
380         _paused = false;
381     }
382 
383     /**
384      * @return true if the contract is paused, false otherwise.
385      */
386     function paused() public view returns (bool) {
387         return _paused;
388     }
389 
390     /**
391      * @dev Modifier to make a function callable only when the contract is not paused.
392      */
393     modifier whenNotPaused() {
394         require(!_paused);
395         _;
396     }
397 
398     /**
399      * @dev Modifier to make a function callable only when the contract is paused.
400      */
401     modifier whenPaused() {
402         require(_paused);
403         _;
404     }
405 
406     /**
407      * @dev called by the owner to pause, triggers stopped state
408      */
409     function pause() public onlyPauser whenNotPaused {
410         _paused = true;
411         emit Paused(msg.sender);
412     }
413 
414     /**
415      * @dev called by the owner to unpause, returns to normal state
416      */
417     function unpause() public onlyPauser whenPaused {
418         _paused = false;
419         emit Unpaused(msg.sender);
420     }
421 }
422 
423 
424 /**
425  * @title Pausable token
426  * @dev ERC20 modified with pausable transfers.
427  **/
428 contract PausableToken is ERC20, Pausable {
429     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
430         return super.transfer(to, value);
431     }
432 
433     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
434         return super.transferFrom(from, to, value);
435     }
436 
437     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
438         return super.approve(spender, value);
439     }
440 
441     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
442         return super.increaseAllowance(spender, addedValue);
443     }
444 
445     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
446         return super.decreaseAllowance(spender, subtractedValue);
447     }
448 }
449 
450 
451 /**
452  * @title MintableToken
453  * @dev ERC20 minting logic
454  */
455 contract MintableToken is PausableToken, MinterRole {
456     event MintFinished();
457     bool public mintingFinished = false;
458 
459     modifier canMint() {
460         require(!mintingFinished);
461         _;
462     } 
463     /**
464      * @dev Function to mint tokens
465      * @param to The address that will receive the minted tokens.
466      * @param value The amount of tokens to mint.
467      * @return A boolean that indicates if the operation was successful.
468      */
469     function mint(address to, uint256 value) public onlyMinter whenNotPaused canMint returns (bool) {
470         _mint(to, value);
471         return true;
472     }
473     /**
474     * @dev Function to stop minting new tokens.
475     * @return True if the operation was successful.
476     */
477     function finishMinting() onlyMinter public returns (bool) {
478         mintingFinished = true;
479         emit MintFinished();
480         return true;
481     }
482 }
483 
484 
485 contract HlorToken is MintableToken {
486     string public constant name = "HLOR";
487     string public constant symbol = "HLOR";
488     uint32 public constant decimals = 18;
489 }
490 
491 // Copyright (C) 2017  MixBytes, LLC
492 
493 // Licensed under the Apache License, Version 2.0 (the "License").
494 // You may not use this file except in compliance with the License.
495 
496 // Unless required by applicable law or agreed to in writing, software
497 // distributed under the License is distributed on an "AS IS" BASIS,
498 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
499 
500 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
501 // Audit, refactoring and improvements by github.com/Eenae
502 
503 // @authors:
504 // Gav Wood <g@ethdev.com>
505 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
506 // single, or, crucially, each of a number of, designated owners.
507 // usage:
508 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
509 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
510 // interior is executed.
511 
512 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
513 contract multiowned {
514 
515     // TYPES
516 
517     // struct for the status of a pending operation.
518     struct MultiOwnedOperationPendingState {
519         // count of confirmations needed
520         uint yetNeeded;
521 
522         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
523         uint ownersDone;
524 
525         // position of this operation key in m_multiOwnedPendingIndex
526         uint index;
527     }
528 
529     // EVENTS
530 
531     event Confirmation(address owner, bytes32 operation);
532     event Revoke(address owner, bytes32 operation);
533     event FinalConfirmation(address owner, bytes32 operation);
534 
535     // some others are in the case of an owner changing.
536     event OwnerChanged(address oldOwner, address newOwner);
537     event OwnerAdded(address newOwner);
538     event OwnerRemoved(address oldOwner);
539 
540     // the last one is emitted if the required signatures change
541     event RequirementChanged(uint newRequirement);
542 
543     // MODIFIERS
544 
545     // simple single-sig function modifier.
546     modifier onlyowner {
547         require(isOwner(msg.sender));
548         _;
549     }
550     // multi-sig function modifier: the operation must have an intrinsic hash in order
551     // that later attempts can be realised as the same underlying operation and
552     // thus count as confirmations.
553     modifier onlymanyowners(bytes32 _operation) {
554         if (confirmAndCheck(_operation)) {
555             _;
556         }
557         // Even if required number of confirmations has't been collected yet,
558         // we can't throw here - because changes to the state have to be preserved.
559         // But, confirmAndCheck itself will throw in case sender is not an owner.
560     }
561 
562     modifier validNumOwners(uint _numOwners) {
563         require(_numOwners > 0 && _numOwners <= c_maxOwners);
564         _;
565     }
566 
567     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
568         require(_required > 0 && _required <= _numOwners);
569         _;
570     }
571 
572     modifier ownerExists(address _address) {
573         require(isOwner(_address));
574         _;
575     }
576 
577     modifier ownerDoesNotExist(address _address) {
578         require(!isOwner(_address));
579         _;
580     }
581 
582     modifier multiOwnedOperationIsActive(bytes32 _operation) {
583         require(isOperationActive(_operation));
584         _;
585     }
586 
587     // METHODS
588 
589     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
590     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
591     constructor(address[] memory _owners, uint _required)
592         public
593         validNumOwners(_owners.length)
594         multiOwnedValidRequirement(_required, _owners.length)
595     {
596         assert(c_maxOwners <= 255);
597 
598         m_numOwners = _owners.length;
599         m_multiOwnedRequired = _required;
600 
601         for (uint i = 0; i < _owners.length; ++i)
602         {
603             address owner = _owners[i];
604             // invalid and duplicate addresses are not allowed
605             require(address(0) != owner && !isOwner(owner) /* not isOwner yet! */);
606 
607             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
608             m_owners[currentOwnerIndex] = owner;
609             m_ownerIndex[owner] = currentOwnerIndex;
610         }
611 
612         assertOwnersAreConsistent();
613     }
614 
615     /// @notice replaces an owner `_from` with another `_to`.
616     /// @param _from address of owner to replace
617     /// @param _to address of new owner
618     // All pending operations will be canceled!
619     function changeOwner(address _from, address _to)
620         external
621         ownerExists(_from)
622         ownerDoesNotExist(_to)
623         onlymanyowners(keccak256(msg.data))
624     {
625         assertOwnersAreConsistent();
626 
627         clearPending();
628         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
629         m_owners[ownerIndex] = _to;
630         m_ownerIndex[_from] = 0;
631         m_ownerIndex[_to] = ownerIndex;
632 
633         assertOwnersAreConsistent();
634         emit OwnerChanged(_from, _to);
635     }
636 
637     /// @notice adds an owner
638     /// @param _owner address of new owner
639     // All pending operations will be canceled!
640     function addOwner(address _owner)
641         external
642         ownerDoesNotExist(_owner)
643         validNumOwners(m_numOwners + 1)
644         onlymanyowners(keccak256(msg.data))
645     {
646         assertOwnersAreConsistent();
647 
648         clearPending();
649         m_numOwners++;
650         m_owners[m_numOwners] = _owner;
651         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
652 
653         assertOwnersAreConsistent();
654         emit OwnerAdded(_owner);
655     }
656 
657     /// @notice removes an owner
658     /// @param _owner address of owner to remove
659     // All pending operations will be canceled!
660     function removeOwner(address _owner)
661         external
662         ownerExists(_owner)
663         validNumOwners(m_numOwners - 1)
664         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
665         onlymanyowners(keccak256(msg.data))
666     {
667         assertOwnersAreConsistent();
668 
669         clearPending();
670         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
671         m_owners[ownerIndex] = address(0);
672         m_ownerIndex[_owner] = 0;
673         //make sure m_numOwners is equal to the number of owners and always points to the last owner
674         reorganizeOwners();
675 
676         assertOwnersAreConsistent();
677         emit OwnerRemoved(_owner);
678     }
679 
680     /// @notice changes the required number of owner signatures
681     /// @param _newRequired new number of signatures required
682     // All pending operations will be canceled!
683     function changeRequirement(uint _newRequired)
684         external
685         multiOwnedValidRequirement(_newRequired, m_numOwners)
686         onlymanyowners(keccak256(msg.data))
687     {
688         m_multiOwnedRequired = _newRequired;
689         clearPending();
690         emit RequirementChanged(_newRequired);
691     }
692 
693     /// @notice Gets an owner by 0-indexed position
694     /// @param ownerIndex 0-indexed owner position
695     function getOwner(uint ownerIndex) public view returns (address) {
696         return m_owners[ownerIndex + 1];
697     }
698 
699     /// @notice Gets owners
700     /// @return memory array of owners
701     function getOwners() public view returns (address[] memory) {
702         address[] memory result = new address[](m_numOwners);
703         for (uint i = 0; i < m_numOwners; i++)
704             result[i] = getOwner(i);
705 
706         return result;
707     }
708 
709     /// @notice checks if provided address is an owner address
710     /// @param _addr address to check
711     /// @return true if it's an owner
712     function isOwner(address _addr) public view returns (bool) {
713         return m_ownerIndex[_addr] > 0;
714     }
715 
716     /// @notice Tests ownership of the current caller.
717     /// @return true if it's an owner
718     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
719     // addOwner/changeOwner and to isOwner.
720     function amIOwner() external view onlyowner returns (bool) {
721         return true;
722     }
723 
724     /// @notice Revokes a prior confirmation of the given operation
725     /// @param _operation operation value, typically keccak256(msg.data)
726     function revoke(bytes32 _operation)
727         external
728         multiOwnedOperationIsActive(_operation)
729         onlyowner
730     {
731         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
732         MultiOwnedOperationPendingState memory pending = m_multiOwnedPending[_operation];
733         require(pending.ownersDone & ownerIndexBit > 0);
734 
735         assertOperationIsConsistent(_operation);
736 
737         pending.yetNeeded++;
738         pending.ownersDone -= ownerIndexBit;
739 
740         assertOperationIsConsistent(_operation);
741         emit Revoke(msg.sender, _operation);
742     }
743 
744     /// @notice Checks if owner confirmed given operation
745     /// @param _operation operation value, typically keccak256(msg.data)
746     /// @param _owner an owner address
747     function hasConfirmed(bytes32 _operation, address _owner)
748         external
749         view
750         multiOwnedOperationIsActive(_operation)
751         ownerExists(_owner)
752         returns (bool)
753     {
754         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
755     }
756 
757     // INTERNAL METHODS
758 
759     function confirmAndCheck(bytes32 _operation)
760         private
761         onlyowner
762         returns (bool)
763     {
764         if (512 == m_multiOwnedPendingIndex.length)
765             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
766             // we won't be able to do it because of block gas limit.
767             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
768             // TODO use more graceful approach like compact or removal of clearPending completely
769             clearPending();
770 
771         MultiOwnedOperationPendingState memory pending = m_multiOwnedPending[_operation];
772 
773         // if we're not yet working on this operation, switch over and reset the confirmation status.
774         if (! isOperationActive(_operation)) {
775             // reset count of confirmations needed.
776             pending.yetNeeded = m_multiOwnedRequired;
777             // reset which owners have confirmed (none) - set our bitmap to 0.
778             pending.ownersDone = 0;
779             pending.index = m_multiOwnedPendingIndex.length++;
780             m_multiOwnedPendingIndex[pending.index] = _operation;
781             assertOperationIsConsistent(_operation);
782         }
783 
784         // determine the bit to set for this owner.
785         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
786         // make sure we (the message sender) haven't confirmed this operation previously.
787         if (pending.ownersDone & ownerIndexBit == 0) {
788             // ok - check if count is enough to go ahead.
789             assert(pending.yetNeeded > 0);
790             if (pending.yetNeeded == 1) {
791                 // enough confirmations: reset and run interior.
792                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
793                 delete m_multiOwnedPending[_operation];
794                 emit FinalConfirmation(msg.sender, _operation);
795                 return true;
796             }
797             else
798             {
799                 // not enough: record that this owner in particular confirmed.
800                 pending.yetNeeded--;
801                 pending.ownersDone |= ownerIndexBit;
802                 assertOperationIsConsistent(_operation);
803                 emit Confirmation(msg.sender, _operation);
804             }
805         }
806     }
807 
808     // Reclaims free slots between valid owners in m_owners.
809     // TODO given that its called after each removal, it could be simplified.
810     function reorganizeOwners() private {
811         uint free = 1;
812         while (free < m_numOwners)
813         {
814             // iterating to the first free slot from the beginning
815             while (free < m_numOwners && m_owners[free] != address(0)) free++;
816 
817             // iterating to the first occupied slot from the end
818             while (m_numOwners > 1 && m_owners[m_numOwners] == address(0)) m_numOwners--;
819 
820             // swap, if possible, so free slot is located at the end after the swap
821             if (free < m_numOwners && m_owners[m_numOwners] != address(0) && m_owners[free] == address(0))
822             {
823                 // owners between swapped slots should't be renumbered - that saves a lot of gas
824                 m_owners[free] = m_owners[m_numOwners];
825                 m_ownerIndex[m_owners[free]] = free;
826                 m_owners[m_numOwners] = address(0);
827             }
828         }
829     }
830 
831     function clearPending() private onlyowner {
832         uint length = m_multiOwnedPendingIndex.length;
833         // TODO block gas limit
834         for (uint i = 0; i < length; ++i) {
835             if (m_multiOwnedPendingIndex[i] != 0)
836                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
837         }
838         delete m_multiOwnedPendingIndex;
839     }
840 
841     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
842         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
843         return ownerIndex;
844     }
845 
846     function makeOwnerBitmapBit(address owner) private view returns (uint) {
847         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
848         return 2 ** ownerIndex;
849     }
850 
851     function isOperationActive(bytes32 _operation) private view returns (bool) {
852         return 0 != m_multiOwnedPending[_operation].yetNeeded;
853     }
854 
855 
856     function assertOwnersAreConsistent() private view {
857         assert(m_numOwners > 0);
858         assert(m_numOwners <= c_maxOwners);
859         assert(m_owners[0] == address(0));
860         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
861     }
862 
863     function assertOperationIsConsistent(bytes32 _operation) private view {
864         MultiOwnedOperationPendingState memory pending = m_multiOwnedPending[_operation];
865         assert(0 != pending.yetNeeded);
866         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
867         assert(pending.yetNeeded <= m_multiOwnedRequired);
868     }
869 
870 
871     // FIELDS
872 
873     uint constant c_maxOwners = 250;
874 
875     // the number of owners that must confirm the same operation before it is run.
876     uint256 public m_multiOwnedRequired;
877 
878 
879     // pointer used to find a free slot in m_owners
880     uint public m_numOwners;
881 
882     // list of owners (addresses),
883     // slot 0 is unused so there are no owner which index is 0.
884     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
885     address[256] internal m_owners;
886 
887     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
888     mapping(address => uint) internal m_ownerIndex;
889 
890 
891     // the ongoing operations.
892     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
893     bytes32[] internal m_multiOwnedPendingIndex;
894 }
895 
896 
897 // The TokenController is a proxy contract for implementation of multiowned control under token.
898 contract TokenController is multiowned {
899 
900     HlorToken public token;
901 
902     constructor(address[] memory _owners, uint _required, address _tokenAddress) 
903     multiowned(_owners, _required) public {
904         token = HlorToken(_tokenAddress);
905     }
906  
907     function mint(address _to, uint256 _amount) onlyowner public returns (bool)
908     {   
909         return token.mint(_to, _amount);
910     }
911 
912     function pause() onlymanyowners(keccak256(msg.data)) public {
913         token.pause();
914     }
915 
916     function unpause() onlymanyowners(keccak256(msg.data)) public {
917         token.unpause();
918     }
919 
920     function addMinter(address account) onlymanyowners(keccak256(msg.data)) public {
921         token.addMinter(account);
922     }
923 
924     function addPauser(address account) onlymanyowners(keccak256(msg.data)) public {
925        token.addPauser(account);
926     }
927 
928     function finishMinting() onlymanyowners(keccak256(msg.data)) public returns (bool) {
929         token.finishMinting();
930   }
931 }