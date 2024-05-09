1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 
19     /**
20     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21     * account.
22     */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28     * @dev Throws if called by any account other than the owner.
29     */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36     * @dev Allows the current owner to relinquish control of the contract.
37     * @notice Renouncing to ownership will leave the contract without an owner.
38     * It will not be possible to call the functions with the `onlyOwner`
39     * modifier anymore.
40     */
41     function renounceOwnership() public onlyOwner {
42         emit OwnershipRenounced(owner);
43         owner = address(0);
44     }
45 
46     /**
47     * @dev Allows the current owner to transfer control of the contract to a newOwner.
48     * @param _newOwner The address to transfer ownership to.
49     */
50     function transferOwnership(address _newOwner) public onlyOwner {
51         _transferOwnership(_newOwner);
52     }
53 
54     /**
55     * @dev Transfers control of the contract to a newOwner.
56     * @param _newOwner The address to transfer ownership to.
57     */
58     function _transferOwnership(address _newOwner) internal {
59         require(_newOwner != address(0));
60         emit OwnershipTransferred(owner, _newOwner);
61         owner = _newOwner;
62     }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71     /**
72     * @dev Multiplies two numbers, throws on overflow.
73     */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
75         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         c = a * b;
83         assert(c / a == b);
84         return c;
85     }
86 
87     /**
88     * @dev Integer division of two numbers, truncating the quotient.
89     */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // assert(b > 0); // Solidity automatically throws when dividing by 0
92         // uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94         return a / b;
95     }
96 
97     /**
98     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99     */
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         assert(b <= a);
102         return a - b;
103     }
104 
105     /**
106     * @dev Adds two numbers, throws on overflow.
107     */
108     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
109         c = a + b;
110         assert(c >= a);
111         return c;
112     }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121     function totalSupply() public view returns (uint256);
122     function balanceOf(address who) public view returns (uint256);
123     function transfer(address to, uint256 value) public returns (bool);
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 /**
128  * @title Basic token
129  * @dev Basic version of StandardToken, with no allowances.
130  */
131 contract BasicToken is ERC20Basic {
132     using SafeMath for uint256;
133 
134     mapping(address => uint256) balances;
135 
136     uint256 totalSupply_;
137 
138     /**
139     * @dev Total number of tokens in existence
140     */
141     function totalSupply() public view returns (uint256) {
142         return totalSupply_;
143     }
144 
145     /**
146     * @dev Transfer token for a specified address
147     * @param _to The address to transfer to.
148     * @param _value The amount to be transferred.
149     */
150     function transfer(address _to, uint256 _value) public returns (bool) {
151         require(_to != address(0));
152         require(_value <= balances[msg.sender]);
153 
154         balances[msg.sender] = balances[msg.sender].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         emit Transfer(msg.sender, _to, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Gets the balance of the specified address.
162     * @param _owner The address to query the the balance of.
163     * @return An uint256 representing the amount owned by the passed address.
164     */
165     function balanceOf(address _owner) public view returns (uint256) {
166         return balances[_owner];
167     }
168 
169 }
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176     function allowance(address owner, address spender)
177         public view returns (uint256);
178 
179     function transferFrom(address from, address to, uint256 value)
180         public returns (bool);
181 
182     function approve(address spender, uint256 value) public returns (bool);
183     event Approval(
184         address indexed owner,
185         address indexed spender,
186         uint256 value
187     );
188 }
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * https://github.com/ethereum/EIPs/issues/20
195  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199     mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202     /**
203     * @dev Transfer tokens from one address to another
204     * @param _from address The address which you want to send tokens from
205     * @param _to address The address which you want to transfer to
206     * @param _value uint256 the amount of tokens to be transferred
207     */
208     function transferFrom(
209         address _from,
210         address _to,
211         uint256 _value
212     )
213         public
214         returns (bool)
215     {
216         require(_to != address(0));
217         require(_value <= balances[_from]);
218         require(_value <= allowed[_from][msg.sender]);
219 
220         balances[_from] = balances[_from].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223         emit Transfer(_from, _to, _value);
224         return true;
225     }
226 
227     /**
228     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229     * Beware that changing an allowance with this method brings the risk that someone may use both the old
230     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233     * @param _spender The address which will spend the funds.
234     * @param _value The amount of tokens to be spent.
235     */
236     function approve(address _spender, uint256 _value) public returns (bool) {
237         allowed[msg.sender][_spender] = _value;
238         emit Approval(msg.sender, _spender, _value);
239         return true;
240     }
241 
242     /**
243     * @dev Function to check the amount of tokens that an owner allowed to a spender.
244     * @param _owner address The address which owns the funds.
245     * @param _spender address The address which will spend the funds.
246     * @return A uint256 specifying the amount of tokens still available for the spender.
247     */
248     function allowance(
249         address _owner,
250         address _spender
251     )
252         public
253         view
254         returns (uint256)
255     {
256         return allowed[_owner][_spender];
257     }
258 
259     /**
260     * @dev Increase the amount of tokens that an owner allowed to a spender.
261     * approve should be called when allowed[_spender] == 0. To increment
262     * allowed value is better to use this function to avoid 2 calls (and wait until
263     * the first transaction is mined)
264     * From MonolithDAO Token.sol
265     * @param _spender The address which will spend the funds.
266     * @param _addedValue The amount of tokens to increase the allowance by.
267     */
268     function increaseApproval(
269         address _spender,
270         uint256 _addedValue
271     )
272         public
273         returns (bool)
274     {
275         allowed[msg.sender][_spender] = (
276         allowed[msg.sender][_spender].add(_addedValue));
277         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278         return true;
279     }
280 
281     /**
282     * @dev Decrease the amount of tokens that an owner allowed to a spender.
283     * approve should be called when allowed[_spender] == 0. To decrement
284     * allowed value is better to use this function to avoid 2 calls (and wait until
285     * the first transaction is mined)
286     * From MonolithDAO Token.sol
287     * @param _spender The address which will spend the funds.
288     * @param _subtractedValue The amount of tokens to decrease the allowance by.
289     */
290     function decreaseApproval(
291         address _spender,
292         uint256 _subtractedValue
293     )
294         public
295         returns (bool)
296     {
297         uint256 oldValue = allowed[msg.sender][_spender];
298         if (_subtractedValue > oldValue) {
299             allowed[msg.sender][_spender] = 0;
300         } else {
301             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302         }
303         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304         return true;
305     }
306 
307 }
308 
309 /**
310  * @title Pausable
311  * @dev Base contract which allows children to implement an emergency stop mechanism.
312  */
313 contract Pausable is Ownable {
314     event Pause();
315     event Unpause();
316 
317     bool public paused = false;
318 
319 
320     /**
321     * @dev Modifier to make a function callable only when the contract is not paused.
322     */
323     modifier whenNotPaused() {
324         require(!paused);
325         _;
326     }
327 
328     /**
329     * @dev Modifier to make a function callable only when the contract is paused.
330     */
331     modifier whenPaused() {
332         require(paused);
333         _;
334     }
335 
336     /**
337     * @dev called by the owner to pause, triggers stopped state
338     */
339     function pause() onlyOwner whenNotPaused public {
340         paused = true;
341         emit Pause();
342     }
343 
344     /**
345     * @dev called by the owner to unpause, returns to normal state
346     */
347     function unpause() onlyOwner whenPaused public {
348         paused = false;
349         emit Unpause();
350     }
351 }
352 
353 /**
354  * @title Pausable token
355  * @dev StandardToken modified with pausable transfers.
356  **/
357 contract PausableToken is StandardToken, Pausable {
358 
359     function transfer(
360         address _to,
361         uint256 _value
362     )
363         public
364         whenNotPaused
365         returns (bool)
366     {
367         return super.transfer(_to, _value);
368     }
369 
370     function transferFrom(
371         address _from,
372         address _to,
373         uint256 _value
374     )
375         public
376         whenNotPaused
377         returns (bool)
378     {
379         return super.transferFrom(_from, _to, _value);
380     }
381 
382     function approve(
383         address _spender,
384         uint256 _value
385     )
386         public
387         whenNotPaused
388         returns (bool)
389     {
390         return super.approve(_spender, _value);
391     }
392 
393     function increaseApproval(
394         address _spender,
395         uint _addedValue
396     )
397         public
398         whenNotPaused
399         returns (bool success)
400     {
401         return super.increaseApproval(_spender, _addedValue);
402     }
403 
404     function decreaseApproval(
405         address _spender,
406         uint _subtractedValue
407     )
408         public
409         whenNotPaused
410         returns (bool success)
411     {
412         return super.decreaseApproval(_spender, _subtractedValue);
413     }
414 }
415 
416 /**
417  * @title Burnable Token
418  * @dev Token that can be irreversibly burned (destroyed).
419  */
420 contract BurnableToken is BasicToken {
421 
422     event Burn(address indexed burner, uint256 value);
423 
424     /**
425     * @dev Burns a specific amount of tokens.
426     * @param _value The amount of token to be burned.
427     */
428     function burn(uint256 _value) public {
429         _burn(msg.sender, _value);
430     }
431 
432     function _burn(address _who, uint256 _value) internal {
433         require(_value <= balances[_who]);
434         // no need to require value <= totalSupply, since that would imply the
435         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
436 
437         balances[_who] = balances[_who].sub(_value);
438         totalSupply_ = totalSupply_.sub(_value);
439         emit Burn(_who, _value);
440         emit Transfer(_who, address(0), _value);
441     }
442 }
443 
444 contract RepublicToken is PausableToken, BurnableToken {
445 
446     string public constant name = "Republic Token";
447     string public constant symbol = "REN";
448     uint8 public constant decimals = 18;
449     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**uint256(decimals);
450 
451     /// @notice The RepublicToken Constructor.
452     constructor() public {
453         totalSupply_ = INITIAL_SUPPLY;
454         balances[msg.sender] = INITIAL_SUPPLY;
455     }
456 
457     function transferTokens(address beneficiary, uint256 amount) public onlyOwner returns (bool) {
458         /* solium-disable error-reason */
459         require(amount > 0);
460 
461         balances[owner] = balances[owner].sub(amount);
462         balances[beneficiary] = balances[beneficiary].add(amount);
463         emit Transfer(owner, beneficiary, amount);
464 
465         return true;
466     }
467 }
468 
469 /**
470  * @title Claimable
471  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
472  * This allows the new owner to accept the transfer.
473  */
474 contract Claimable is Ownable {
475     address public pendingOwner;
476 
477     /**
478     * @dev Modifier throws if called by any account other than the pendingOwner.
479     */
480     modifier onlyPendingOwner() {
481         require(msg.sender == pendingOwner);
482         _;
483     }
484 
485     /**
486     * @dev Allows the current owner to set the pendingOwner address.
487     * @param newOwner The address to transfer ownership to.
488     */
489     function transferOwnership(address newOwner) onlyOwner public {
490         pendingOwner = newOwner;
491     }
492 
493     /**
494     * @dev Allows the pendingOwner address to finalize the transfer.
495     */
496     function claimOwnership() onlyPendingOwner public {
497         emit OwnershipTransferred(owner, pendingOwner);
498         owner = pendingOwner;
499         pendingOwner = address(0);
500     }
501 }
502 
503 /**
504  * @notice LinkedList is a library for a circular double linked list.
505  */
506 library LinkedList {
507 
508     /*
509     * @notice A permanent NULL node (0x0) in the circular double linked list.
510     * NULL.next is the head, and NULL.previous is the tail.
511     */
512     address public constant NULL = 0x0;
513 
514     /**
515     * @notice A node points to the node before it, and the node after it. If
516     * node.previous = NULL, then the node is the head of the list. If
517     * node.next = NULL, then the node is the tail of the list.
518     */
519     struct Node {
520         bool inList;
521         address previous;
522         address next;
523     }
524 
525     /**
526     * @notice LinkedList uses a mapping from address to nodes. Each address
527     * uniquely identifies a node, and in this way they are used like pointers.
528     */
529     struct List {
530         mapping (address => Node) list;
531     }
532 
533     /**
534     * @notice Insert a new node before an existing node.
535     *
536     * @param self The list being used.
537     * @param target The existing node in the list.
538     * @param newNode The next node to insert before the target.
539     */
540     function insertBefore(List storage self, address target, address newNode) internal {
541         require(!isInList(self, newNode), "already in list");
542         require(isInList(self, target) || target == NULL, "not in list");
543 
544         // It is expected that this value is sometimes NULL.
545         address prev = self.list[target].previous;
546 
547         self.list[newNode].next = target;
548         self.list[newNode].previous = prev;
549         self.list[target].previous = newNode;
550         self.list[prev].next = newNode;
551 
552         self.list[newNode].inList = true;
553     }
554 
555     /**
556     * @notice Insert a new node after an existing node.
557     *
558     * @param self The list being used.
559     * @param target The existing node in the list.
560     * @param newNode The next node to insert after the target.
561     */
562     function insertAfter(List storage self, address target, address newNode) internal {
563         require(!isInList(self, newNode), "already in list");
564         require(isInList(self, target) || target == NULL, "not in list");
565 
566         // It is expected that this value is sometimes NULL.
567         address n = self.list[target].next;
568 
569         self.list[newNode].previous = target;
570         self.list[newNode].next = n;
571         self.list[target].next = newNode;
572         self.list[n].previous = newNode;
573 
574         self.list[newNode].inList = true;
575     }
576 
577     /**
578     * @notice Remove a node from the list, and fix the previous and next
579     * pointers that are pointing to the removed node. Removing anode that is not
580     * in the list will do nothing.
581     *
582     * @param self The list being using.
583     * @param node The node in the list to be removed.
584     */
585     function remove(List storage self, address node) internal {
586         require(isInList(self, node), "not in list");
587         if (node == NULL) {
588             return;
589         }
590         address p = self.list[node].previous;
591         address n = self.list[node].next;
592 
593         self.list[p].next = n;
594         self.list[n].previous = p;
595 
596         // Deleting the node should set this value to false, but we set it here for
597         // explicitness.
598         self.list[node].inList = false;
599         delete self.list[node];
600     }
601 
602     /**
603     * @notice Insert a node at the beginning of the list.
604     *
605     * @param self The list being used.
606     * @param node The node to insert at the beginning of the list.
607     */
608     function prepend(List storage self, address node) internal {
609         // isInList(node) is checked in insertBefore
610 
611         insertBefore(self, begin(self), node);
612     }
613 
614     /**
615     * @notice Insert a node at the end of the list.
616     *
617     * @param self The list being used.
618     * @param node The node to insert at the end of the list.
619     */
620     function append(List storage self, address node) internal {
621         // isInList(node) is checked in insertBefore
622 
623         insertAfter(self, end(self), node);
624     }
625 
626     function swap(List storage self, address left, address right) internal {
627         // isInList(left) and isInList(right) are checked in remove
628 
629         address previousRight = self.list[right].previous;
630         remove(self, right);
631         insertAfter(self, left, right);
632         remove(self, left);
633         insertAfter(self, previousRight, left);
634     }
635 
636     function isInList(List storage self, address node) internal view returns (bool) {
637         return self.list[node].inList;
638     }
639 
640     /**
641     * @notice Get the node at the beginning of a double linked list.
642     *
643     * @param self The list being used.
644     *
645     * @return A address identifying the node at the beginning of the double
646     * linked list.
647     */
648     function begin(List storage self) internal view returns (address) {
649         return self.list[NULL].next;
650     }
651 
652     /**
653     * @notice Get the node at the end of a double linked list.
654     *
655     * @param self The list being used.
656     *
657     * @return A address identifying the node at the end of the double linked
658     * list.
659     */
660     function end(List storage self) internal view returns (address) {
661         return self.list[NULL].previous;
662     }
663 
664     function next(List storage self, address node) internal view returns (address) {
665         require(isInList(self, node), "not in list");
666         return self.list[node].next;
667     }
668 
669     function previous(List storage self, address node) internal view returns (address) {
670         require(isInList(self, node), "not in list");
671         return self.list[node].previous;
672     }
673 
674 }
675 
676 /// @notice This contract stores data and funds for the DarknodeRegistry
677 /// contract. The data / fund logic and storage have been separated to improve
678 /// upgradability.
679 contract DarknodeRegistryStore is Claimable {
680     using SafeMath for uint256;
681 
682     string public VERSION; // Passed in as a constructor parameter.
683 
684     /// @notice Darknodes are stored in the darknode struct. The owner is the
685     /// address that registered the darknode, the bond is the amount of REN that
686     /// was transferred during registration, and the public key is the
687     /// encryption key that should be used when sending sensitive information to
688     /// the darknode.
689     struct Darknode {
690         // The owner of a Darknode is the address that called the register
691         // function. The owner is the only address that is allowed to
692         // deregister the Darknode, unless the Darknode is slashed for
693         // malicious behavior.
694         address owner;
695 
696         // The bond is the amount of REN submitted as a bond by the Darknode.
697         // This amount is reduced when the Darknode is slashed for malicious
698         // behavior.
699         uint256 bond;
700 
701         // The block number at which the Darknode is considered registered.
702         uint256 registeredAt;
703 
704         // The block number at which the Darknode is considered deregistered.
705         uint256 deregisteredAt;
706 
707         // The public key used by this Darknode for encrypting sensitive data
708         // off chain. It is assumed that the Darknode has access to the
709         // respective private key, and that there is an agreement on the format
710         // of the public key.
711         bytes publicKey;
712     }
713 
714     /// Registry data.
715     mapping(address => Darknode) private darknodeRegistry;
716     LinkedList.List private darknodes;
717 
718     // RepublicToken.
719     RepublicToken public ren;
720 
721     /// @notice The contract constructor.
722     ///
723     /// @param _VERSION A string defining the contract version.
724     /// @param _ren The address of the RepublicToken contract.
725     constructor(
726         string _VERSION,
727         RepublicToken _ren
728     ) public {
729         VERSION = _VERSION;
730         ren = _ren;
731     }
732 
733     /// @notice Instantiates a darknode and appends it to the darknodes
734     /// linked-list.
735     ///
736     /// @param _darknodeID The darknode's ID.
737     /// @param _darknodeOwner The darknode's owner's address
738     /// @param _bond The darknode's bond value
739     /// @param _publicKey The darknode's public key
740     /// @param _registeredAt The time stamp when the darknode is registered.
741     /// @param _deregisteredAt The time stamp when the darknode is deregistered.
742     function appendDarknode(
743         address _darknodeID,
744         address _darknodeOwner,
745         uint256 _bond,
746         bytes _publicKey,
747         uint256 _registeredAt,
748         uint256 _deregisteredAt
749     ) external onlyOwner {
750         Darknode memory darknode = Darknode({
751             owner: _darknodeOwner,
752             bond: _bond,
753             publicKey: _publicKey,
754             registeredAt: _registeredAt,
755             deregisteredAt: _deregisteredAt
756         });
757         darknodeRegistry[_darknodeID] = darknode;
758         LinkedList.append(darknodes, _darknodeID);
759     }
760 
761     /// @notice Returns the address of the first darknode in the store
762     function begin() external view onlyOwner returns(address) {
763         return LinkedList.begin(darknodes);
764     }
765 
766     /// @notice Returns the address of the next darknode in the store after the
767     /// given address.
768     function next(address darknodeID) external view onlyOwner returns(address) {
769         return LinkedList.next(darknodes, darknodeID);
770     }
771 
772     /// @notice Removes a darknode from the store and transfers its bond to the
773     /// owner of this contract.
774     function removeDarknode(address darknodeID) external onlyOwner {
775         uint256 bond = darknodeRegistry[darknodeID].bond;
776         delete darknodeRegistry[darknodeID];
777         LinkedList.remove(darknodes, darknodeID);
778         require(ren.transfer(owner, bond), "bond transfer failed");
779     }
780 
781     /// @notice Updates the bond of a darknode. The new bond must be smaller
782     /// than the previous bond of the darknode.
783     function updateDarknodeBond(address darknodeID, uint256 decreasedBond) external onlyOwner {
784         uint256 previousBond = darknodeRegistry[darknodeID].bond;
785         require(decreasedBond < previousBond, "bond not decreased");
786         darknodeRegistry[darknodeID].bond = decreasedBond;
787         require(ren.transfer(owner, previousBond.sub(decreasedBond)), "bond transfer failed");
788     }
789 
790     /// @notice Updates the deregistration timestamp of a darknode.
791     function updateDarknodeDeregisteredAt(address darknodeID, uint256 deregisteredAt) external onlyOwner {
792         darknodeRegistry[darknodeID].deregisteredAt = deregisteredAt;
793     }
794 
795     /// @notice Returns the owner of a given darknode.
796     function darknodeOwner(address darknodeID) external view onlyOwner returns (address) {
797         return darknodeRegistry[darknodeID].owner;
798     }
799 
800     /// @notice Returns the bond of a given darknode.
801     function darknodeBond(address darknodeID) external view onlyOwner returns (uint256) {
802         return darknodeRegistry[darknodeID].bond;
803     }
804 
805     /// @notice Returns the registration time of a given darknode.
806     function darknodeRegisteredAt(address darknodeID) external view onlyOwner returns (uint256) {
807         return darknodeRegistry[darknodeID].registeredAt;
808     }
809 
810     /// @notice Returns the deregistration time of a given darknode.
811     function darknodeDeregisteredAt(address darknodeID) external view onlyOwner returns (uint256) {
812         return darknodeRegistry[darknodeID].deregisteredAt;
813     }
814 
815     /// @notice Returns the encryption public key of a given darknode.
816     function darknodePublicKey(address darknodeID) external view onlyOwner returns (bytes) {
817         return darknodeRegistry[darknodeID].publicKey;
818     }
819 }
820 
821 /// @notice DarknodeRegistry is responsible for the registration and
822 /// deregistration of Darknodes.
823 contract DarknodeRegistry is Ownable {
824     using SafeMath for uint256;
825 
826     string public VERSION; // Passed in as a constructor parameter.
827 
828     /// @notice Darknode pods are shuffled after a fixed number of blocks.
829     /// An Epoch stores an epoch hash used as an (insecure) RNG seed, and the
830     /// blocknumber which restricts when the next epoch can be called.
831     struct Epoch {
832         uint256 epochhash;
833         uint256 blocknumber;
834     }
835 
836     uint256 public numDarknodes;
837     uint256 public numDarknodesNextEpoch;
838     uint256 public numDarknodesPreviousEpoch;
839 
840     /// Variables used to parameterize behavior.
841     uint256 public minimumBond;
842     uint256 public minimumPodSize;
843     uint256 public minimumEpochInterval;
844     address public slasher;
845 
846     /// When one of the above variables is modified, it is only updated when the
847     /// next epoch is called. These variables store the values for the next epoch.
848     uint256 public nextMinimumBond;
849     uint256 public nextMinimumPodSize;
850     uint256 public nextMinimumEpochInterval;
851     address public nextSlasher;
852 
853     /// The current and previous epoch
854     Epoch public currentEpoch;
855     Epoch public previousEpoch;
856 
857     /// Republic ERC20 token contract used to transfer bonds.
858     RepublicToken public ren;
859 
860     /// Darknode Registry Store is the storage contract for darknodes.
861     DarknodeRegistryStore public store;
862 
863     /// @notice Emitted when a darknode is registered.
864     /// @param _darknodeID The darknode ID that was registered.
865     /// @param _bond The amount of REN that was transferred as bond.
866     event LogDarknodeRegistered(address _darknodeID, uint256 _bond);
867 
868     /// @notice Emitted when a darknode is deregistered.
869     /// @param _darknodeID The darknode ID that was deregistered.
870     event LogDarknodeDeregistered(address _darknodeID);
871 
872     /// @notice Emitted when a refund has been made.
873     /// @param _owner The address that was refunded.
874     /// @param _amount The amount of REN that was refunded.
875     event LogDarknodeOwnerRefunded(address _owner, uint256 _amount);
876 
877     /// @notice Emitted when a new epoch has begun.
878     event LogNewEpoch();
879 
880     /// @notice Emitted when a constructor parameter has been updated.
881     event LogMinimumBondUpdated(uint256 previousMinimumBond, uint256 nextMinimumBond);
882     event LogMinimumPodSizeUpdated(uint256 previousMinimumPodSize, uint256 nextMinimumPodSize);
883     event LogMinimumEpochIntervalUpdated(uint256 previousMinimumEpochInterval, uint256 nextMinimumEpochInterval);
884     event LogSlasherUpdated(address previousSlasher, address nextSlasher);
885 
886     /// @notice Only allow the owner that registered the darknode to pass.
887     modifier onlyDarknodeOwner(address _darknodeID) {
888         require(store.darknodeOwner(_darknodeID) == msg.sender, "must be darknode owner");
889         _;
890     }
891 
892     /// @notice Only allow unregistered darknodes.
893     modifier onlyRefunded(address _darknodeID) {
894         require(isRefunded(_darknodeID), "must be refunded or never registered");
895         _;
896     }
897 
898     /// @notice Only allow refundable darknodes.
899     modifier onlyRefundable(address _darknodeID) {
900         require(isRefundable(_darknodeID), "must be deregistered for at least one epoch");
901         _;
902     }
903 
904     /// @notice Only allowed registered nodes without a pending deregistration to
905     /// deregister
906     modifier onlyDeregisterable(address _darknodeID) {
907         require(isDeregisterable(_darknodeID), "must be deregisterable");
908         _;
909     }
910 
911     /// @notice Only allow the Slasher contract.
912     modifier onlySlasher() {
913         require(slasher == msg.sender, "must be slasher");
914         _;
915     }
916 
917     /// @notice The contract constructor.
918     ///
919     /// @param _VERSION A string defining the contract version.
920     /// @param _renAddress The address of the RepublicToken contract.
921     /// @param _storeAddress The address of the DarknodeRegistryStore contract.
922     /// @param _minimumBond The minimum bond amount that can be submitted by a
923     ///        Darknode.
924     /// @param _minimumPodSize The minimum size of a Darknode pod.
925     /// @param _minimumEpochInterval The minimum number of blocks between
926     ///        epochs.
927     constructor(
928         string _VERSION,
929         RepublicToken _renAddress,
930         DarknodeRegistryStore _storeAddress,
931         uint256 _minimumBond,
932         uint256 _minimumPodSize,
933         uint256 _minimumEpochInterval
934     ) public {
935         VERSION = _VERSION;
936 
937         store = _storeAddress;
938         ren = _renAddress;
939 
940         minimumBond = _minimumBond;
941         nextMinimumBond = minimumBond;
942 
943         minimumPodSize = _minimumPodSize;
944         nextMinimumPodSize = minimumPodSize;
945 
946         minimumEpochInterval = _minimumEpochInterval;
947         nextMinimumEpochInterval = minimumEpochInterval;
948 
949         currentEpoch = Epoch({
950             epochhash: uint256(blockhash(block.number - 1)),
951             blocknumber: block.number
952         });
953         numDarknodes = 0;
954         numDarknodesNextEpoch = 0;
955         numDarknodesPreviousEpoch = 0;
956     }
957 
958     /// @notice Register a darknode and transfer the bond to this contract.
959     /// Before registering, the bond transfer must be approved in the REN
960     /// contract. The caller must provide a public encryption key for the
961     /// darknode. The darknode will remain pending registration until the next
962     /// epoch. Only after this period can the darknode be deregistered. The
963     /// caller of this method will be stored as the owner of the darknode.
964     ///
965     /// @param _darknodeID The darknode ID that will be registered.
966     /// @param _publicKey The public key of the darknode. It is stored to allow
967     ///        other darknodes and traders to encrypt messages to the trader.
968     function register(address _darknodeID, bytes _publicKey) external onlyRefunded(_darknodeID) {
969         // Use the current minimum bond as the darknode's bond.
970         uint256 bond = minimumBond;
971 
972         // Transfer bond to store
973         require(ren.transferFrom(msg.sender, store, bond), "bond transfer failed");
974 
975         // Flag this darknode for registration
976         store.appendDarknode(
977             _darknodeID,
978             msg.sender,
979             bond,
980             _publicKey,
981             currentEpoch.blocknumber.add(minimumEpochInterval),
982             0
983         );
984 
985         numDarknodesNextEpoch = numDarknodesNextEpoch.add(1);
986 
987         // Emit an event.
988         emit LogDarknodeRegistered(_darknodeID, bond);
989     }
990 
991     /// @notice Deregister a darknode. The darknode will not be deregistered
992     /// until the end of the epoch. After another epoch, the bond can be
993     /// refunded by calling the refund method.
994     /// @param _darknodeID The darknode ID that will be deregistered. The caller
995     ///        of this method store.darknodeRegisteredAt(_darknodeID) must be
996     //         the owner of this darknode.
997     function deregister(address _darknodeID) external onlyDeregisterable(_darknodeID) onlyDarknodeOwner(_darknodeID) {
998         deregisterDarknode(_darknodeID);
999     }
1000 
1001     /// @notice Progress the epoch if it is possible to do so. This captures
1002     /// the current timestamp and current blockhash and overrides the current
1003     /// epoch.
1004     function epoch() external {
1005         if (previousEpoch.blocknumber == 0) {
1006             // The first epoch must be called by the owner of the contract
1007             require(msg.sender == owner, "not authorized (first epochs)");
1008         }
1009 
1010         // Require that the epoch interval has passed
1011         require(block.number >= currentEpoch.blocknumber.add(minimumEpochInterval), "epoch interval has not passed");
1012         uint256 epochhash = uint256(blockhash(block.number - 1));
1013 
1014         // Update the epoch hash and timestamp
1015         previousEpoch = currentEpoch;
1016         currentEpoch = Epoch({
1017             epochhash: epochhash,
1018             blocknumber: block.number
1019         });
1020 
1021         // Update the registry information
1022         numDarknodesPreviousEpoch = numDarknodes;
1023         numDarknodes = numDarknodesNextEpoch;
1024 
1025         // If any update functions have been called, update the values now
1026         if (nextMinimumBond != minimumBond) {
1027             minimumBond = nextMinimumBond;
1028             emit LogMinimumBondUpdated(minimumBond, nextMinimumBond);
1029         }
1030         if (nextMinimumPodSize != minimumPodSize) {
1031             minimumPodSize = nextMinimumPodSize;
1032             emit LogMinimumPodSizeUpdated(minimumPodSize, nextMinimumPodSize);
1033         }
1034         if (nextMinimumEpochInterval != minimumEpochInterval) {
1035             minimumEpochInterval = nextMinimumEpochInterval;
1036             emit LogMinimumEpochIntervalUpdated(minimumEpochInterval, nextMinimumEpochInterval);
1037         }
1038         if (nextSlasher != slasher) {
1039             slasher = nextSlasher;
1040             emit LogSlasherUpdated(slasher, nextSlasher);
1041         }
1042 
1043         // Emit an event
1044         emit LogNewEpoch();
1045     }
1046 
1047     /// @notice Allows the contract owner to initiate an ownership transfer of
1048     /// the DarknodeRegistryStore. 
1049     /// @param _newOwner The address to transfer the ownership to.
1050     function transferStoreOwnership(address _newOwner) external onlyOwner {
1051         store.transferOwnership(_newOwner);
1052     }
1053 
1054     /// @notice Claims ownership of the store passed in to the constructor.
1055     /// `transferStoreOwnership` must have previously been called when
1056     /// transferring from another Darknode Registry.
1057     function claimStoreOwnership() external onlyOwner {
1058         store.claimOwnership();
1059     }
1060 
1061     /// @notice Allows the contract owner to update the minimum bond.
1062     /// @param _nextMinimumBond The minimum bond amount that can be submitted by
1063     ///        a darknode.
1064     function updateMinimumBond(uint256 _nextMinimumBond) external onlyOwner {
1065         // Will be updated next epoch
1066         nextMinimumBond = _nextMinimumBond;
1067     }
1068 
1069     /// @notice Allows the contract owner to update the minimum pod size.
1070     /// @param _nextMinimumPodSize The minimum size of a pod.
1071     function updateMinimumPodSize(uint256 _nextMinimumPodSize) external onlyOwner {
1072         // Will be updated next epoch
1073         nextMinimumPodSize = _nextMinimumPodSize;
1074     }
1075 
1076     /// @notice Allows the contract owner to update the minimum epoch interval.
1077     /// @param _nextMinimumEpochInterval The minimum number of blocks between epochs.
1078     function updateMinimumEpochInterval(uint256 _nextMinimumEpochInterval) external onlyOwner {
1079         // Will be updated next epoch
1080         nextMinimumEpochInterval = _nextMinimumEpochInterval;
1081     }
1082 
1083     /// @notice Allow the contract owner to update the DarknodeSlasher contract
1084     /// address.
1085     /// @param _slasher The new slasher address.
1086     function updateSlasher(address _slasher) external onlyOwner {
1087         require(_slasher != 0x0, "invalid slasher address");
1088         nextSlasher = _slasher;
1089     }
1090 
1091     /// @notice Allow the DarknodeSlasher contract to slash half of a darknode's
1092     /// bond and deregister it. The bond is distributed as follows:
1093     ///   1/2 is kept by the guilty prover
1094     ///   1/8 is rewarded to the first challenger
1095     ///   1/8 is rewarded to the second challenger
1096     ///   1/4 becomes unassigned
1097     /// @param _prover The guilty prover whose bond is being slashed
1098     /// @param _challenger1 The first of the two darknodes who submitted the challenge
1099     /// @param _challenger2 The second of the two darknodes who submitted the challenge
1100     function slash(address _prover, address _challenger1, address _challenger2)
1101         external
1102         onlySlasher
1103     {
1104         uint256 penalty = store.darknodeBond(_prover) / 2;
1105         uint256 reward = penalty / 4;
1106 
1107         // Slash the bond of the failed prover in half
1108         store.updateDarknodeBond(_prover, penalty);
1109 
1110         // If the darknode has not been deregistered then deregister it
1111         if (isDeregisterable(_prover)) {
1112             deregisterDarknode(_prover);
1113         }
1114 
1115         // Reward the challengers with less than the penalty so that it is not
1116         // worth challenging yourself
1117         require(ren.transfer(store.darknodeOwner(_challenger1), reward), "reward transfer failed");
1118         require(ren.transfer(store.darknodeOwner(_challenger2), reward), "reward transfer failed");
1119     }
1120 
1121     /// @notice Refund the bond of a deregistered darknode. This will make the
1122     /// darknode available for registration again. Anyone can call this function
1123     /// but the bond will always be refunded to the darknode owner.
1124     ///
1125     /// @param _darknodeID The darknode ID that will be refunded. The caller
1126     ///        of this method must be the owner of this darknode.
1127     function refund(address _darknodeID) external onlyRefundable(_darknodeID) {
1128         address darknodeOwner = store.darknodeOwner(_darknodeID);
1129 
1130         // Remember the bond amount
1131         uint256 amount = store.darknodeBond(_darknodeID);
1132 
1133         // Erase the darknode from the registry
1134         store.removeDarknode(_darknodeID);
1135 
1136         // Refund the owner by transferring REN
1137         require(ren.transfer(darknodeOwner, amount), "bond transfer failed");
1138 
1139         // Emit an event.
1140         emit LogDarknodeOwnerRefunded(darknodeOwner, amount);
1141     }
1142 
1143     /// @notice Retrieves the address of the account that registered a darknode.
1144     /// @param _darknodeID The ID of the darknode to retrieve the owner for.
1145     function getDarknodeOwner(address _darknodeID) external view returns (address) {
1146         return store.darknodeOwner(_darknodeID);
1147     }
1148 
1149     /// @notice Retrieves the bond amount of a darknode in 10^-18 REN.
1150     /// @param _darknodeID The ID of the darknode to retrieve the bond for.
1151     function getDarknodeBond(address _darknodeID) external view returns (uint256) {
1152         return store.darknodeBond(_darknodeID);
1153     }
1154 
1155     /// @notice Retrieves the encryption public key of the darknode.
1156     /// @param _darknodeID The ID of the darknode to retrieve the public key for.
1157     function getDarknodePublicKey(address _darknodeID) external view returns (bytes) {
1158         return store.darknodePublicKey(_darknodeID);
1159     }
1160 
1161     /// @notice Retrieves a list of darknodes which are registered for the
1162     /// current epoch.
1163     /// @param _start A darknode ID used as an offset for the list. If _start is
1164     ///        0x0, the first dark node will be used. _start won't be
1165     ///        included it is not registered for the epoch.
1166     /// @param _count The number of darknodes to retrieve starting from _start.
1167     ///        If _count is 0, all of the darknodes from _start are
1168     ///        retrieved. If _count is more than the remaining number of
1169     ///        registered darknodes, the rest of the list will contain
1170     ///        0x0s.
1171     function getDarknodes(address _start, uint256 _count) external view returns (address[]) {
1172         uint256 count = _count;
1173         if (count == 0) {
1174             count = numDarknodes;
1175         }
1176         return getDarknodesFromEpochs(_start, count, false);
1177     }
1178 
1179     /// @notice Retrieves a list of darknodes which were registered for the
1180     /// previous epoch. See `getDarknodes` for the parameter documentation.
1181     function getPreviousDarknodes(address _start, uint256 _count) external view returns (address[]) {
1182         uint256 count = _count;
1183         if (count == 0) {
1184             count = numDarknodesPreviousEpoch;
1185         }
1186         return getDarknodesFromEpochs(_start, count, true);
1187     }
1188 
1189     /// @notice Returns whether a darknode is scheduled to become registered
1190     /// at next epoch.
1191     /// @param _darknodeID The ID of the darknode to return
1192     function isPendingRegistration(address _darknodeID) external view returns (bool) {
1193         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1194         return registeredAt != 0 && registeredAt > currentEpoch.blocknumber;
1195     }
1196 
1197     /// @notice Returns if a darknode is in the pending deregistered state. In
1198     /// this state a darknode is still considered registered.
1199     function isPendingDeregistration(address _darknodeID) external view returns (bool) {
1200         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1201         return deregisteredAt != 0 && deregisteredAt > currentEpoch.blocknumber;
1202     }
1203 
1204     /// @notice Returns if a darknode is in the deregistered state.
1205     function isDeregistered(address _darknodeID) public view returns (bool) {
1206         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1207         return deregisteredAt != 0 && deregisteredAt <= currentEpoch.blocknumber;
1208     }
1209 
1210     /// @notice Returns if a darknode can be deregistered. This is true if the
1211     /// darknodes is in the registered state and has not attempted to
1212     /// deregister yet.
1213     function isDeregisterable(address _darknodeID) public view returns (bool) {
1214         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1215         // The Darknode is currently in the registered state and has not been
1216         // transitioned to the pending deregistration, or deregistered, state
1217         return isRegistered(_darknodeID) && deregisteredAt == 0;
1218     }
1219 
1220     /// @notice Returns if a darknode is in the refunded state. This is true
1221     /// for darknodes that have never been registered, or darknodes that have
1222     /// been deregistered and refunded.
1223     function isRefunded(address _darknodeID) public view returns (bool) {
1224         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1225         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1226         return registeredAt == 0 && deregisteredAt == 0;
1227     }
1228 
1229     /// @notice Returns if a darknode is refundable. This is true for darknodes
1230     /// that have been in the deregistered state for one full epoch.
1231     function isRefundable(address _darknodeID) public view returns (bool) {
1232         return isDeregistered(_darknodeID) && store.darknodeDeregisteredAt(_darknodeID) <= previousEpoch.blocknumber;
1233     }
1234 
1235     /// @notice Returns if a darknode is in the registered state.
1236     function isRegistered(address _darknodeID) public view returns (bool) {
1237         return isRegisteredInEpoch(_darknodeID, currentEpoch);
1238     }
1239 
1240     /// @notice Returns if a darknode was in the registered state last epoch.
1241     function isRegisteredInPreviousEpoch(address _darknodeID) public view returns (bool) {
1242         return isRegisteredInEpoch(_darknodeID, previousEpoch);
1243     }
1244 
1245     /// @notice Returns if a darknode was in the registered state for a given
1246     /// epoch.
1247     /// @param _darknodeID The ID of the darknode
1248     /// @param _epoch One of currentEpoch, previousEpoch
1249     function isRegisteredInEpoch(address _darknodeID, Epoch _epoch) private view returns (bool) {
1250         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1251         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1252         bool registered = registeredAt != 0 && registeredAt <= _epoch.blocknumber;
1253         bool notDeregistered = deregisteredAt == 0 || deregisteredAt > _epoch.blocknumber;
1254         // The Darknode has been registered and has not yet been deregistered,
1255         // although it might be pending deregistration
1256         return registered && notDeregistered;
1257     }
1258 
1259     /// @notice Returns a list of darknodes registered for either the current
1260     /// or the previous epoch. See `getDarknodes` for documentation on the
1261     /// parameters `_start` and `_count`.
1262     /// @param _usePreviousEpoch If true, use the previous epoch, otherwise use
1263     ///        the current epoch.
1264     function getDarknodesFromEpochs(address _start, uint256 _count, bool _usePreviousEpoch) private view returns (address[]) {
1265         uint256 count = _count;
1266         if (count == 0) {
1267             count = numDarknodes;
1268         }
1269 
1270         address[] memory nodes = new address[](count);
1271 
1272         // Begin with the first node in the list
1273         uint256 n = 0;
1274         address next = _start;
1275         if (next == 0x0) {
1276             next = store.begin();
1277         }
1278 
1279         // Iterate until all registered Darknodes have been collected
1280         while (n < count) {
1281             if (next == 0x0) {
1282                 break;
1283             }
1284             // Only include Darknodes that are currently registered
1285             bool includeNext;
1286             if (_usePreviousEpoch) {
1287                 includeNext = isRegisteredInPreviousEpoch(next);
1288             } else {
1289                 includeNext = isRegistered(next);
1290             }
1291             if (!includeNext) {
1292                 next = store.next(next);
1293                 continue;
1294             }
1295             nodes[n] = next;
1296             next = store.next(next);
1297             n += 1;
1298         }
1299         return nodes;
1300     }
1301 
1302     /// Private function called by `deregister` and `slash`
1303     function deregisterDarknode(address _darknodeID) private {
1304         // Flag the darknode for deregistration
1305         store.updateDarknodeDeregisteredAt(_darknodeID, currentEpoch.blocknumber.add(minimumEpochInterval));
1306         numDarknodesNextEpoch = numDarknodesNextEpoch.sub(1);
1307 
1308         // Emit an event
1309         emit LogDarknodeDeregistered(_darknodeID);
1310     }
1311 }
1312 
1313 /// @notice The BrokerVerifier interface defines the functions that a settlement
1314 /// layer's broker verifier contract must implement.
1315 interface BrokerVerifier {
1316 
1317     /// @notice The function signature that will be called when a trader opens
1318     /// an order.
1319     ///
1320     /// @param _trader The trader requesting the withdrawal.
1321     /// @param _signature The 65-byte signature from the broker.
1322     /// @param _orderID The 32-byte order ID.
1323     function verifyOpenSignature(
1324         address _trader,
1325         bytes _signature,
1326         bytes32 _orderID
1327     ) external returns (bool);
1328 }
1329 
1330 /// @notice The Settlement interface defines the functions that a settlement
1331 /// layer must implement.
1332 /// Docs: https://github.com/republicprotocol/republic-sol/blob/nightly/docs/05-settlement.md
1333 interface Settlement {
1334     function submitOrder(
1335         bytes _details,
1336         uint64 _settlementID,
1337         uint64 _tokens,
1338         uint256 _price,
1339         uint256 _volume,
1340         uint256 _minimumVolume
1341     ) external;
1342 
1343     function submissionGasPriceLimit() external view returns (uint256);
1344 
1345     function settle(
1346         bytes32 _buyID,
1347         bytes32 _sellID
1348     ) external;
1349 
1350     /// @notice orderStatus should return the status of the order, which should
1351     /// be:
1352     ///     0  - Order not seen before
1353     ///     1  - Order details submitted
1354     ///     >1 - Order settled, or settlement no longer possible
1355     function orderStatus(bytes32 _orderID) external view returns (uint8);
1356 }
1357 
1358 /// @notice SettlementRegistry allows a Settlement layer to register the
1359 /// contracts used for match settlement and for broker signature verification.
1360 contract SettlementRegistry is Ownable {
1361     string public VERSION; // Passed in as a constructor parameter.
1362 
1363     struct SettlementDetails {
1364         bool registered;
1365         Settlement settlementContract;
1366         BrokerVerifier brokerVerifierContract;
1367     }
1368 
1369     // Settlement IDs are 64-bit unsigned numbers
1370     mapping(uint64 => SettlementDetails) public settlementDetails;
1371 
1372     // Events
1373     event LogSettlementRegistered(uint64 settlementID, Settlement settlementContract, BrokerVerifier brokerVerifierContract);
1374     event LogSettlementUpdated(uint64 settlementID, Settlement settlementContract, BrokerVerifier brokerVerifierContract);
1375     event LogSettlementDeregistered(uint64 settlementID);
1376 
1377     /// @notice The contract constructor.
1378     ///
1379     /// @param _VERSION A string defining the contract version.
1380     constructor(string _VERSION) public {
1381         VERSION = _VERSION;
1382     }
1383 
1384     /// @notice Returns the settlement contract of a settlement layer.
1385     function settlementRegistration(uint64 _settlementID) external view returns (bool) {
1386         return settlementDetails[_settlementID].registered;
1387     }
1388 
1389     /// @notice Returns the settlement contract of a settlement layer.
1390     function settlementContract(uint64 _settlementID) external view returns (Settlement) {
1391         return settlementDetails[_settlementID].settlementContract;
1392     }
1393 
1394     /// @notice Returns the broker verifier contract of a settlement layer.
1395     function brokerVerifierContract(uint64 _settlementID) external view returns (BrokerVerifier) {
1396         return settlementDetails[_settlementID].brokerVerifierContract;
1397     }
1398 
1399     /// @param _settlementID A unique 64-bit settlement identifier.
1400     /// @param _settlementContract The address to use for settling matches.
1401     /// @param _brokerVerifierContract The decimals to use for verifying
1402     ///        broker signatures.
1403     function registerSettlement(uint64 _settlementID, Settlement _settlementContract, BrokerVerifier _brokerVerifierContract) public onlyOwner {
1404         bool alreadyRegistered = settlementDetails[_settlementID].registered;
1405         
1406         settlementDetails[_settlementID] = SettlementDetails({
1407             registered: true,
1408             settlementContract: _settlementContract,
1409             brokerVerifierContract: _brokerVerifierContract
1410         });
1411 
1412         if (alreadyRegistered) {
1413             emit LogSettlementUpdated(_settlementID, _settlementContract, _brokerVerifierContract);
1414         } else {
1415             emit LogSettlementRegistered(_settlementID, _settlementContract, _brokerVerifierContract);
1416         }
1417     }
1418 
1419     /// @notice Deregisteres a settlement layer, clearing the details.
1420     /// @param _settlementID The unique 64-bit settlement identifier.
1421     function deregisterSettlement(uint64 _settlementID) external onlyOwner {
1422         require(settlementDetails[_settlementID].registered, "not registered");
1423 
1424         delete settlementDetails[_settlementID];
1425 
1426         emit LogSettlementDeregistered(_settlementID);
1427     }
1428 }
1429 
1430 /**
1431  * @title Eliptic curve signature operations
1432  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
1433  * TODO Remove this library once solidity supports passing a signature to ecrecover.
1434  * See https://github.com/ethereum/solidity/issues/864
1435  */
1436 
1437 library ECRecovery {
1438 
1439     /**
1440     * @dev Recover signer address from a message by using their signature
1441     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
1442     * @param sig bytes signature, the signature is generated using web3.eth.sign()
1443     */
1444     function recover(bytes32 hash, bytes sig)
1445         internal
1446         pure
1447         returns (address)
1448     {
1449         bytes32 r;
1450         bytes32 s;
1451         uint8 v;
1452 
1453         // Check the signature length
1454         if (sig.length != 65) {
1455             return (address(0));
1456         }
1457 
1458         // Divide the signature in r, s and v variables
1459         // ecrecover takes the signature parameters, and the only way to get them
1460         // currently is to use assembly.
1461         // solium-disable-next-line security/no-inline-assembly
1462         assembly {
1463         r := mload(add(sig, 32))
1464         s := mload(add(sig, 64))
1465         v := byte(0, mload(add(sig, 96)))
1466         }
1467 
1468         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
1469         if (v < 27) {
1470             v += 27;
1471         }
1472 
1473         // If the version is correct return the signer address
1474         if (v != 27 && v != 28) {
1475             return (address(0));
1476         } else {
1477         // solium-disable-next-line arg-overflow
1478             return ecrecover(hash, v, r, s);
1479         }
1480     }
1481 
1482     /**
1483     * toEthSignedMessageHash
1484     * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
1485     * and hash the result
1486     */
1487     function toEthSignedMessageHash(bytes32 hash)
1488         internal
1489         pure
1490         returns (bytes32)
1491     {
1492         // 32 is the length in bytes of hash,
1493         // enforced by the type signature above
1494         return keccak256(
1495             abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1496         );
1497     }
1498 }
1499 
1500 library Utils {
1501 
1502     /**
1503      * @notice Converts a number to its string/bytes representation
1504      *
1505      * @param _v the uint to convert
1506      */
1507     function uintToBytes(uint256 _v) internal pure returns (bytes) {
1508         uint256 v = _v;
1509         if (v == 0) {
1510             return "0";
1511         }
1512 
1513         uint256 digits = 0;
1514         uint256 v2 = v;
1515         while (v2 > 0) {
1516             v2 /= 10;
1517             digits += 1;
1518         }
1519 
1520         bytes memory result = new bytes(digits);
1521 
1522         for (uint256 i = 0; i < digits; i++) {
1523             result[digits - i - 1] = bytes1((v % 10) + 48);
1524             v /= 10;
1525         }
1526 
1527         return result;
1528     }
1529 
1530     /**
1531      * @notice Retrieves the address from a signature
1532      *
1533      * @param _hash the message that was signed (any length of bytes)
1534      * @param _signature the signature (65 bytes)
1535      */
1536     function addr(bytes _hash, bytes _signature) internal pure returns (address) {
1537         bytes memory prefix = "\x19Ethereum Signed Message:\n";
1538         bytes memory encoded = abi.encodePacked(prefix, uintToBytes(_hash.length), _hash);
1539         bytes32 prefixedHash = keccak256(encoded);
1540 
1541         return ECRecovery.recover(prefixedHash, _signature);
1542     }
1543 
1544 }
1545 
1546 /// @notice The Orderbook contract stores the state and priority of orders and
1547 /// allows the Darknodes to easily reach consensus. Eventually, this contract
1548 /// will only store a subset of order states, such as cancellation, to improve
1549 /// the throughput of orders.
1550 contract Orderbook is Ownable {
1551     using SafeMath for uint256;
1552 
1553     string public VERSION; // Passed in as a constructor parameter.
1554 
1555     /// @notice OrderState enumerates the possible states of an order. All
1556     /// orders default to the Undefined state.
1557     enum OrderState {Undefined, Open, Confirmed, Canceled}
1558 
1559     /// @notice Order stores a subset of the public data associated with an order.
1560     struct Order {
1561         OrderState state;     // State of the order
1562         address trader;       // Trader that owns the order
1563         address confirmer;    // Darknode that confirmed the order in a match
1564         uint64 settlementID;  // The settlement that signed the order opening
1565         uint256 priority;     // Logical time priority of this order
1566         uint256 blockNumber;  // Block number of the most recent state change
1567         bytes32 matchedOrder; // Order confirmed in a match with this order
1568     }
1569 
1570     DarknodeRegistry public darknodeRegistry;
1571     SettlementRegistry public settlementRegistry;
1572 
1573     bytes32[] private orderbook;
1574 
1575     // Order details are exposed through directly accessing this mapping, or
1576     // through the getter functions below for each of the order's fields.
1577     mapping(bytes32 => Order) public orders;
1578 
1579     event LogFeeUpdated(uint256 previousFee, uint256 nextFee);
1580     event LogDarknodeRegistryUpdated(DarknodeRegistry previousDarknodeRegistry, DarknodeRegistry nextDarknodeRegistry);
1581 
1582     /// @notice Only allow registered dark nodes.
1583     modifier onlyDarknode(address _sender) {
1584         require(darknodeRegistry.isRegistered(_sender), "must be registered darknode");
1585         _;
1586     }
1587 
1588     /// @notice The contract constructor.
1589     ///
1590     /// @param _VERSION A string defining the contract version.
1591     /// @param _darknodeRegistry The address of the DarknodeRegistry contract.
1592     /// @param _settlementRegistry The address of the SettlementRegistry
1593     ///        contract.
1594     constructor(
1595         string _VERSION,
1596         DarknodeRegistry _darknodeRegistry,
1597         SettlementRegistry _settlementRegistry
1598     ) public {
1599         VERSION = _VERSION;
1600         darknodeRegistry = _darknodeRegistry;
1601         settlementRegistry = _settlementRegistry;
1602     }
1603 
1604     /// @notice Allows the owner to update the address of the DarknodeRegistry
1605     /// contract.
1606     function updateDarknodeRegistry(DarknodeRegistry _newDarknodeRegistry) external onlyOwner {
1607         // Basic validation knowing that DarknodeRegistry exposes VERSION
1608         require(bytes(_newDarknodeRegistry.VERSION()).length > 0, "invalid darknode registry contract");
1609 
1610         emit LogDarknodeRegistryUpdated(darknodeRegistry, _newDarknodeRegistry);
1611         darknodeRegistry = _newDarknodeRegistry;
1612     }
1613 
1614     /// @notice Open an order in the orderbook. The order must be in the
1615     /// Undefined state.
1616     ///
1617     /// @param _signature Signature of the message that defines the trader. The
1618     ///        message is "Republic Protocol: open: {orderId}".
1619     /// @param _orderID The hash of the order.
1620     function openOrder(uint64 _settlementID, bytes _signature, bytes32 _orderID) external {
1621         require(orders[_orderID].state == OrderState.Undefined, "invalid order status");
1622 
1623         address trader = msg.sender;
1624 
1625         // Verify the order signature
1626         require(settlementRegistry.settlementRegistration(_settlementID), "settlement not registered");
1627         BrokerVerifier brokerVerifier = settlementRegistry.brokerVerifierContract(_settlementID);
1628         require(brokerVerifier.verifyOpenSignature(trader, _signature, _orderID), "invalid broker signature");
1629 
1630         orders[_orderID] = Order({
1631             state: OrderState.Open,
1632             trader: trader,
1633             confirmer: 0x0,
1634             settlementID: _settlementID,
1635             priority: orderbook.length + 1,
1636             blockNumber: block.number,
1637             matchedOrder: 0x0
1638         });
1639 
1640         orderbook.push(_orderID);
1641     }
1642 
1643     /// @notice Confirm an order match between orders. The confirmer must be a
1644     /// registered Darknode and the orders must be in the Open state. A
1645     /// malicious confirmation by a Darknode will result in a bond slash of the
1646     /// Darknode.
1647     ///
1648     /// @param _orderID The hash of the order.
1649     /// @param _matchedOrderID The hashes of the matching order.
1650     function confirmOrder(bytes32 _orderID, bytes32 _matchedOrderID) external onlyDarknode(msg.sender) {
1651         require(orders[_orderID].state == OrderState.Open, "invalid order status");
1652         require(orders[_matchedOrderID].state == OrderState.Open, "invalid order status");
1653 
1654         orders[_orderID].state = OrderState.Confirmed;
1655         orders[_orderID].confirmer = msg.sender;
1656         orders[_orderID].matchedOrder = _matchedOrderID;
1657         orders[_orderID].blockNumber = block.number;
1658 
1659         orders[_matchedOrderID].state = OrderState.Confirmed;
1660         orders[_matchedOrderID].confirmer = msg.sender;
1661         orders[_matchedOrderID].matchedOrder = _orderID;
1662         orders[_matchedOrderID].blockNumber = block.number;
1663     }
1664 
1665     /// @notice Cancel an open order in the orderbook. An order can be cancelled
1666     /// by the trader who opened the order, or by the broker verifier contract.
1667     /// This allows the settlement layer to implement their own logic for
1668     /// cancelling orders without trader interaction (e.g. to ban a trader from
1669     /// a specific darkpool, or to use multiple order-matching platforms)
1670     ///
1671     /// @param _orderID The hash of the order.
1672     function cancelOrder(bytes32 _orderID) external {
1673         require(orders[_orderID].state == OrderState.Open, "invalid order state");
1674 
1675         // Require the msg.sender to be the trader or the broker verifier
1676         address brokerVerifier = settlementRegistry.brokerVerifierContract(orders[_orderID].settlementID);
1677         require(msg.sender == orders[_orderID].trader || msg.sender == brokerVerifier, "not authorized");
1678 
1679         orders[_orderID].state = OrderState.Canceled;
1680         orders[_orderID].blockNumber = block.number;
1681     }
1682 
1683     /// @notice returns status of the given orderID.
1684     function orderState(bytes32 _orderID) external view returns (OrderState) {
1685         return orders[_orderID].state;
1686     }
1687 
1688     /// @notice returns a list of matched orders to the given orderID.
1689     function orderMatch(bytes32 _orderID) external view returns (bytes32) {
1690         return orders[_orderID].matchedOrder;
1691     }
1692 
1693     /// @notice returns the priority of the given orderID.
1694     /// The priority is the index of the order in the orderbook.
1695     function orderPriority(bytes32 _orderID) external view returns (uint256) {
1696         return orders[_orderID].priority;
1697     }
1698 
1699     /// @notice returns the trader of the given orderID.
1700     /// Trader is the one who signs the message and does the actual trading.
1701     function orderTrader(bytes32 _orderID) external view returns (address) {
1702         return orders[_orderID].trader;
1703     }
1704 
1705     /// @notice returns the darknode address which confirms the given orderID.
1706     function orderConfirmer(bytes32 _orderID) external view returns (address) {
1707         return orders[_orderID].confirmer;
1708     }
1709 
1710     /// @notice returns the block number when the order being last modified.
1711     function orderBlockNumber(bytes32 _orderID) external view returns (uint256) {
1712         return orders[_orderID].blockNumber;
1713     }
1714 
1715     /// @notice returns the block depth of the orderId
1716     function orderDepth(bytes32 _orderID) external view returns (uint256) {
1717         if (orders[_orderID].blockNumber == 0) {
1718             return 0;
1719         }
1720         return (block.number.sub(orders[_orderID].blockNumber));
1721     }
1722 
1723     /// @notice returns the total number of orders in the orderbook, including
1724     /// orders that are no longer open
1725     function ordersCount() external view returns (uint256) {
1726         return orderbook.length;
1727     }
1728 
1729     /// @notice returns order details of the orders starting from the offset.
1730     function getOrders(uint256 _offset, uint256 _limit) external view returns (bytes32[], address[], uint8[]) {
1731         if (_offset >= orderbook.length) {
1732             return;
1733         }
1734 
1735         // If the provided limit is more than the number of orders after the offset,
1736         // decrease the limit
1737         uint256 limit = _limit;
1738         if (_offset.add(limit) > orderbook.length) {
1739             limit = orderbook.length - _offset;
1740         }
1741 
1742         bytes32[] memory orderIDs = new bytes32[](limit);
1743         address[] memory traderAddresses = new address[](limit);
1744         uint8[] memory states = new uint8[](limit);
1745 
1746         for (uint256 i = 0; i < limit; i++) {
1747             bytes32 order = orderbook[i + _offset];
1748             orderIDs[i] = order;
1749             traderAddresses[i] = orders[order].trader;
1750             states[i] = uint8(orders[order].state);
1751         }
1752 
1753         return (orderIDs, traderAddresses, states);
1754     }
1755 }
1756 
1757 /// @notice A library for calculating and verifying order match details
1758 library SettlementUtils {
1759 
1760     struct OrderDetails {
1761         uint64 settlementID;
1762         uint64 tokens;
1763         uint256 price;
1764         uint256 volume;
1765         uint256 minimumVolume;
1766     }
1767 
1768     /// @notice Calculates the ID of the order.
1769     /// @param details Order details that are not required for settlement
1770     ///        execution. They are combined as a single byte array.
1771     /// @param order The order details required for settlement execution.
1772     function hashOrder(bytes details, OrderDetails memory order) internal pure returns (bytes32) {
1773         return keccak256(
1774             abi.encodePacked(
1775                 details,
1776                 order.settlementID,
1777                 order.tokens,
1778                 order.price,
1779                 order.volume,
1780                 order.minimumVolume
1781             )
1782         );
1783     }
1784 
1785     /// @notice Verifies that two orders match when considering the tokens,
1786     /// price, volumes / minimum volumes and settlement IDs. verifyMatchDetails is used
1787     /// my the DarknodeSlasher to verify challenges. Settlement layers may also
1788     /// use this function.
1789     /// @dev When verifying two orders for settlement, you should also:
1790     ///   1) verify the orders have been confirmed together
1791     ///   2) verify the orders' traders are distinct
1792     /// @param _buy The buy order details.
1793     /// @param _sell The sell order details.
1794     function verifyMatchDetails(OrderDetails memory _buy, OrderDetails memory _sell) internal pure returns (bool) {
1795 
1796         // Buy and sell tokens should match
1797         if (!verifyTokens(_buy.tokens, _sell.tokens)) {
1798             return false;
1799         }
1800 
1801         // Buy price should be greater than sell price
1802         if (_buy.price < _sell.price) {
1803             return false;
1804         }
1805 
1806         // // Buy volume should be greater than sell minimum volume
1807         if (_buy.volume < _sell.minimumVolume) {
1808             return false;
1809         }
1810 
1811         // Sell volume should be greater than buy minimum volume
1812         if (_sell.volume < _buy.minimumVolume) {
1813             return false;
1814         }
1815 
1816         // Require that the orders were submitted to the same settlement layer
1817         if (_buy.settlementID != _sell.settlementID) {
1818             return false;
1819         }
1820 
1821         return true;
1822     }
1823 
1824     /// @notice Verifies that two token requirements can be matched and that the
1825     /// tokens are formatted correctly.
1826     /// @param _buyTokens The buy token details.
1827     /// @param _sellToken The sell token details.
1828     function verifyTokens(uint64 _buyTokens, uint64 _sellToken) internal pure returns (bool) {
1829         return ((
1830                 uint32(_buyTokens) == uint32(_sellToken >> 32)) && (
1831                 uint32(_sellToken) == uint32(_buyTokens >> 32)) && (
1832                 uint32(_buyTokens >> 32) <= uint32(_buyTokens))
1833         );
1834     }
1835 }
1836 
1837 /**
1838  * @title Math
1839  * @dev Assorted math operations
1840  */
1841 library Math {
1842     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
1843         return a >= b ? a : b;
1844     }
1845 
1846     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
1847         return a < b ? a : b;
1848     }
1849 
1850     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
1851         return a >= b ? a : b;
1852     }
1853 
1854     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
1855         return a < b ? a : b;
1856     }
1857 }
1858 
1859 /// @notice Implements safeTransfer, safeTransferFrom and
1860 /// safeApprove for CompatibleERC20.
1861 ///
1862 /// See https://github.com/ethereum/solidity/issues/4116
1863 ///
1864 /// This library allows interacting with ERC20 tokens that implement any of
1865 /// these interfaces:
1866 ///
1867 /// (1) transfer returns true on success, false on failure
1868 /// (2) transfer returns true on success, reverts on failure
1869 /// (3) transfer returns nothing on success, reverts on failure
1870 ///
1871 /// Additionally, safeTransferFromWithFees will return the final token
1872 /// value received after accounting for token fees.
1873 library CompatibleERC20Functions {
1874     using SafeMath for uint256;
1875 
1876     /// @notice Calls transfer on the token and reverts if the call fails.
1877     function safeTransfer(address token, address to, uint256 amount) internal {
1878         CompatibleERC20(token).transfer(to, amount);
1879         require(previousReturnValue(), "transfer failed");
1880     }
1881 
1882     /// @notice Calls transferFrom on the token and reverts if the call fails.
1883     function safeTransferFrom(address token, address from, address to, uint256 amount) internal {
1884         CompatibleERC20(token).transferFrom(from, to, amount);
1885         require(previousReturnValue(), "transferFrom failed");
1886     }
1887 
1888     /// @notice Calls approve on the token and reverts if the call fails.
1889     function safeApprove(address token, address spender, uint256 amount) internal {
1890         CompatibleERC20(token).approve(spender, amount);
1891         require(previousReturnValue(), "approve failed");
1892     }
1893 
1894     /// @notice Calls transferFrom on the token, reverts if the call fails and
1895     /// returns the value transferred after fees.
1896     function safeTransferFromWithFees(address token, address from, address to, uint256 amount) internal returns (uint256) {
1897         uint256 balancesBefore = CompatibleERC20(token).balanceOf(to);
1898         CompatibleERC20(token).transferFrom(from, to, amount);
1899         require(previousReturnValue(), "transferFrom failed");
1900         uint256 balancesAfter = CompatibleERC20(token).balanceOf(to);
1901         return Math.min256(amount, balancesAfter.sub(balancesBefore));
1902     }
1903 
1904     /// @notice Checks the return value of the previous function. Returns true
1905     /// if the previous function returned 32 non-zero bytes or returned zero
1906     /// bytes.
1907     function previousReturnValue() private pure returns (bool)
1908     {
1909         uint256 returnData = 0;
1910 
1911         assembly { /* solium-disable-line security/no-inline-assembly */
1912             // Switch on the number of bytes returned by the previous call
1913             switch returndatasize
1914 
1915             // 0 bytes: ERC20 of type (3), did not throw
1916             case 0 {
1917                 returnData := 1
1918             }
1919 
1920             // 32 bytes: ERC20 of types (1) or (2)
1921             case 32 {
1922                 // Copy the return data into scratch space
1923                 returndatacopy(0, 0, 32)
1924 
1925                 // Load  the return data into returnData
1926                 returnData := mload(0)
1927             }
1928 
1929             // Other return size: return false
1930             default { }
1931         }
1932 
1933         return returnData != 0;
1934     }
1935 }
1936 
1937 /// @notice ERC20 interface which doesn't specify the return type for transfer,
1938 /// transferFrom and approve.
1939 interface CompatibleERC20 {
1940     // Modified to not return boolean
1941     function transfer(address to, uint256 value) external;
1942     function transferFrom(address from, address to, uint256 value) external;
1943     function approve(address spender, uint256 value) external;
1944 
1945     // Not modifier
1946     function totalSupply() external view returns (uint256);
1947     function balanceOf(address who) external view returns (uint256);
1948     function allowance(address owner, address spender) external view returns (uint256);
1949     event Transfer(address indexed from, address indexed to, uint256 value);
1950     event Approval(address indexed owner, address indexed spender, uint256 value);
1951 }
1952 
1953 /// @notice The DarknodeRewardVault contract is responsible for holding fees
1954 /// for darknodes for settling orders. Fees can be withdrawn to the address of
1955 /// the darknode's operator. Fees can be in ETH or in ERC20 tokens.
1956 /// Docs: https://github.com/republicprotocol/republic-sol/blob/master/docs/02-darknode-reward-vault.md
1957 contract DarknodeRewardVault is Ownable {
1958     using SafeMath for uint256;
1959     using CompatibleERC20Functions for CompatibleERC20;
1960 
1961     string public VERSION; // Passed in as a constructor parameter.
1962 
1963     /// @notice The special address for Ether.
1964     address constant public ETHEREUM = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1965 
1966     DarknodeRegistry public darknodeRegistry;
1967 
1968     mapping(address => mapping(address => uint256)) public darknodeBalances;
1969 
1970     event LogDarknodeRegistryUpdated(DarknodeRegistry previousDarknodeRegistry, DarknodeRegistry nextDarknodeRegistry);
1971 
1972     /// @notice The contract constructor.
1973     ///
1974     /// @param _VERSION A string defining the contract version.
1975     /// @param _darknodeRegistry The DarknodeRegistry contract that is used by
1976     ///        the vault to lookup Darknode owners.
1977     constructor(string _VERSION, DarknodeRegistry _darknodeRegistry) public {
1978         VERSION = _VERSION;
1979         darknodeRegistry = _darknodeRegistry;
1980     }
1981 
1982     function updateDarknodeRegistry(DarknodeRegistry _newDarknodeRegistry) public onlyOwner {
1983         // Basic validation knowing that DarknodeRegistry exposes VERSION
1984         require(bytes(_newDarknodeRegistry.VERSION()).length > 0, "invalid darknode registry contract");
1985 
1986         emit LogDarknodeRegistryUpdated(darknodeRegistry, _newDarknodeRegistry);
1987         darknodeRegistry = _newDarknodeRegistry;
1988     }
1989 
1990     /// @notice Deposit fees into the vault for a Darknode. The Darknode
1991     /// registration is not checked (to reduce gas fees); the caller must be
1992     /// careful not to call this function for a Darknode that is not registered
1993     /// otherwise any fees deposited to that Darknode can be withdrawn by a
1994     /// malicious adversary (by registering the Darknode before the honest
1995     /// party and claiming ownership).
1996     ///
1997     /// @param _darknode The address of the Darknode that will receive the
1998     ///        fees.
1999     /// @param _token The address of the ERC20 token being used to pay the fee.
2000     ///        A special address is used for Ether.
2001     /// @param _value The amount of fees in the smallest unit of the token.
2002     function deposit(address _darknode, ERC20 _token, uint256 _value) public payable {
2003         uint256 receivedValue = _value;
2004         if (_token == ETHEREUM) {
2005             require(msg.value == _value, "mismatched ether value");
2006         } else {
2007             require(msg.value == 0, "unexpected ether value");
2008             receivedValue = CompatibleERC20(_token).safeTransferFromWithFees(msg.sender, this, _value);
2009         }
2010         darknodeBalances[_darknode][_token] = darknodeBalances[_darknode][_token].add(receivedValue);
2011     }
2012 
2013     /// @notice Withdraw fees earned by a Darknode. The fees will be sent to
2014     /// the owner of the Darknode. If a Darknode is not registered the fees
2015     /// cannot be withdrawn.
2016     ///
2017     /// @param _darknode The address of the Darknode whose fees are being
2018     ///        withdrawn. The owner of this Darknode will receive the fees.
2019     /// @param _token The address of the ERC20 token to withdraw.
2020     function withdraw(address _darknode, ERC20 _token) public {
2021         address darknodeOwner = darknodeRegistry.getDarknodeOwner(_darknode);
2022 
2023         require(darknodeOwner != 0x0, "invalid darknode owner");
2024 
2025         uint256 value = darknodeBalances[_darknode][_token];
2026         darknodeBalances[_darknode][_token] = 0;
2027 
2028         if (_token == ETHEREUM) {
2029             darknodeOwner.transfer(value);
2030         } else {
2031             CompatibleERC20(_token).safeTransfer(darknodeOwner, value);
2032         }
2033     }
2034 
2035 }
2036 
2037 /// @notice RenExTokens is a registry of tokens that can be traded on RenEx.
2038 contract RenExTokens is Ownable {
2039     string public VERSION; // Passed in as a constructor parameter.
2040 
2041     struct TokenDetails {
2042         address addr;
2043         uint8 decimals;
2044         bool registered;
2045     }
2046 
2047     // Storage
2048     mapping(uint32 => TokenDetails) public tokens;
2049     mapping(uint32 => bool) private detailsSubmitted;
2050 
2051     // Events
2052     event LogTokenRegistered(uint32 tokenCode, address tokenAddress, uint8 tokenDecimals);
2053     event LogTokenDeregistered(uint32 tokenCode);
2054 
2055     /// @notice The contract constructor.
2056     ///
2057     /// @param _VERSION A string defining the contract version.
2058     constructor(string _VERSION) public {
2059         VERSION = _VERSION;
2060     }
2061 
2062     /// @notice Allows the owner to register and the details for a token.
2063     /// Once details have been submitted, they cannot be overwritten.
2064     /// To re-register the same token with different details (e.g. if the address
2065     /// has changed), a different token identifier should be used and the
2066     /// previous token identifier should be deregistered.
2067     /// If a token is not Ethereum-based, the address will be set to 0x0.
2068     ///
2069     /// @param _tokenCode A unique 32-bit token identifier.
2070     /// @param _tokenAddress The address of the token.
2071     /// @param _tokenDecimals The decimals to use for the token.
2072     function registerToken(uint32 _tokenCode, address _tokenAddress, uint8 _tokenDecimals) public onlyOwner {
2073         require(!tokens[_tokenCode].registered, "already registered");
2074 
2075         // If a token is being re-registered, the same details must be provided.
2076         if (detailsSubmitted[_tokenCode]) {
2077             require(tokens[_tokenCode].addr == _tokenAddress, "different address");
2078             require(tokens[_tokenCode].decimals == _tokenDecimals, "different decimals");
2079         } else {
2080             detailsSubmitted[_tokenCode] = true;
2081         }
2082 
2083         tokens[_tokenCode] = TokenDetails({
2084             addr: _tokenAddress,
2085             decimals: _tokenDecimals,
2086             registered: true
2087         });
2088 
2089         emit LogTokenRegistered(_tokenCode, _tokenAddress, _tokenDecimals);
2090     }
2091 
2092     /// @notice Sets a token as being deregistered. The details are still stored
2093     /// to prevent the token from being re-registered with different details.
2094     ///
2095     /// @param _tokenCode The unique 32-bit token identifier.
2096     function deregisterToken(uint32 _tokenCode) external onlyOwner {
2097         require(tokens[_tokenCode].registered, "not registered");
2098 
2099         tokens[_tokenCode].registered = false;
2100 
2101         emit LogTokenDeregistered(_tokenCode);
2102     }
2103 }
2104 
2105 /// @notice RenExSettlement implements the Settlement interface. It implements
2106 /// the on-chain settlement for the RenEx settlement layer, and the fee payment
2107 /// for the RenExAtomic settlement layer.
2108 contract RenExSettlement is Ownable {
2109     using SafeMath for uint256;
2110 
2111     string public VERSION; // Passed in as a constructor parameter.
2112 
2113     // Fees in RenEx are 0.2%. To represent this as integers, it is broken into
2114     // a numerator and denominator.
2115     // DARKNODE_FEES_NUMERATOR must not be greater than
2116     // DARKNODE_FEES_DENOMINATOR.
2117     uint256 constant public DARKNODE_FEES_NUMERATOR = 2;
2118     uint256 constant public DARKNODE_FEES_DENOMINATOR = 1000;
2119 
2120     // This contract handles the settlements with ID 1 and 2.
2121     uint32 constant public RENEX_SETTLEMENT_ID = 1;
2122     uint32 constant public RENEX_ATOMIC_SETTLEMENT_ID = 2;
2123 
2124     // Constants used in the price / volume inputs.
2125     int16 constant private PRICE_OFFSET = 12;
2126     int16 constant private VOLUME_OFFSET = 12;
2127 
2128     // Constructor parameters, updatable by the owner
2129     Orderbook public orderbookContract;
2130     RenExTokens public renExTokensContract;
2131     RenExBalances public renExBalancesContract;
2132     address public slasherAddress;
2133     uint256 public submissionGasPriceLimit;
2134 
2135     enum OrderStatus {None, Submitted, Settled, Slashed}
2136 
2137     struct TokenPair {
2138         RenExTokens.TokenDetails priorityToken;
2139         RenExTokens.TokenDetails secondaryToken;
2140     }
2141 
2142     // A uint256 tuple representing a value and an associated fee
2143     struct ValueWithFees {
2144         uint256 value;
2145         uint256 fees;
2146     }
2147 
2148     // A uint256 tuple representing a fraction
2149     struct Fraction {
2150         uint256 numerator;
2151         uint256 denominator;
2152     }
2153 
2154     // We use left and right because the tokens do not always represent the
2155     // priority and secondary tokens.
2156     struct SettlementDetails {
2157         uint256 leftVolume;
2158         uint256 rightVolume;
2159         uint256 leftTokenFee;
2160         uint256 rightTokenFee;
2161         address leftTokenAddress;
2162         address rightTokenAddress;
2163     }
2164 
2165     // Events
2166     event LogOrderbookUpdated(Orderbook previousOrderbook, Orderbook nextOrderbook);
2167     event LogRenExTokensUpdated(RenExTokens previousRenExTokens, RenExTokens nextRenExTokens);
2168     event LogRenExBalancesUpdated(RenExBalances previousRenExBalances, RenExBalances nextRenExBalances);
2169     event LogSubmissionGasPriceLimitUpdated(uint256 previousSubmissionGasPriceLimit, uint256 nextSubmissionGasPriceLimit);
2170     event LogSlasherUpdated(address previousSlasher, address nextSlasher);
2171 
2172     // Order Storage
2173     mapping(bytes32 => SettlementUtils.OrderDetails) public orderDetails;
2174     mapping(bytes32 => address) public orderSubmitter;
2175     mapping(bytes32 => OrderStatus) public orderStatus;
2176 
2177     // Match storage (match details are indexed by [buyID][sellID])
2178     mapping(bytes32 => mapping(bytes32 => uint256)) public matchTimestamp;
2179 
2180     /// @notice Prevents a function from being called with a gas price higher
2181     /// than the specified limit.
2182     ///
2183     /// @param _gasPriceLimit The gas price upper-limit in Wei.
2184     modifier withGasPriceLimit(uint256 _gasPriceLimit) {
2185         require(tx.gasprice <= _gasPriceLimit, "gas price too high");
2186         _;
2187     }
2188 
2189     /// @notice Restricts a function to only being called by the slasher
2190     /// address.
2191     modifier onlySlasher() {
2192         require(msg.sender == slasherAddress, "unauthorized");
2193         _;
2194     }
2195 
2196     /// @notice The contract constructor.
2197     ///
2198     /// @param _VERSION A string defining the contract version.
2199     /// @param _orderbookContract The address of the Orderbook contract.
2200     /// @param _renExBalancesContract The address of the RenExBalances
2201     ///        contract.
2202     /// @param _renExTokensContract The address of the RenExTokens contract.
2203     constructor(
2204         string _VERSION,
2205         Orderbook _orderbookContract,
2206         RenExTokens _renExTokensContract,
2207         RenExBalances _renExBalancesContract,
2208         address _slasherAddress,
2209         uint256 _submissionGasPriceLimit
2210     ) public {
2211         VERSION = _VERSION;
2212         orderbookContract = _orderbookContract;
2213         renExTokensContract = _renExTokensContract;
2214         renExBalancesContract = _renExBalancesContract;
2215         slasherAddress = _slasherAddress;
2216         submissionGasPriceLimit = _submissionGasPriceLimit;
2217     }
2218 
2219     /// @notice The owner of the contract can update the Orderbook address.
2220     /// @param _newOrderbookContract The address of the new Orderbook contract.
2221     function updateOrderbook(Orderbook _newOrderbookContract) external onlyOwner {
2222         // Basic validation knowing that Orderbook exposes VERSION
2223         require(bytes(_newOrderbookContract.VERSION()).length > 0, "invalid orderbook contract");
2224 
2225         emit LogOrderbookUpdated(orderbookContract, _newOrderbookContract);
2226         orderbookContract = _newOrderbookContract;
2227     }
2228 
2229     /// @notice The owner of the contract can update the RenExTokens address.
2230     /// @param _newRenExTokensContract The address of the new RenExTokens
2231     ///       contract.
2232     function updateRenExTokens(RenExTokens _newRenExTokensContract) external onlyOwner {
2233         // Basic validation knowing that RenExTokens exposes VERSION
2234         require(bytes(_newRenExTokensContract.VERSION()).length > 0, "invalid tokens contract");
2235         
2236         emit LogRenExTokensUpdated(renExTokensContract, _newRenExTokensContract);
2237         renExTokensContract = _newRenExTokensContract;
2238     }
2239     
2240     /// @notice The owner of the contract can update the RenExBalances address.
2241     /// @param _newRenExBalancesContract The address of the new RenExBalances
2242     ///       contract.
2243     function updateRenExBalances(RenExBalances _newRenExBalancesContract) external onlyOwner {
2244         // Basic validation knowing that RenExBalances exposes VERSION
2245         require(bytes(_newRenExBalancesContract.VERSION()).length > 0, "invalid balances contract");
2246 
2247         emit LogRenExBalancesUpdated(renExBalancesContract, _newRenExBalancesContract);
2248         renExBalancesContract = _newRenExBalancesContract;
2249     }
2250 
2251     /// @notice The owner of the contract can update the order submission gas
2252     /// price limit.
2253     /// @param _newSubmissionGasPriceLimit The new gas price limit.
2254     function updateSubmissionGasPriceLimit(uint256 _newSubmissionGasPriceLimit) external onlyOwner {
2255         // Submission Gas Price Limit must be at least 100000000 wei (0.1 gwei)
2256         require(_newSubmissionGasPriceLimit >= 100000000, "invalid new submission gas price limit");
2257         emit LogSubmissionGasPriceLimitUpdated(submissionGasPriceLimit, _newSubmissionGasPriceLimit);
2258         submissionGasPriceLimit = _newSubmissionGasPriceLimit;
2259     }
2260 
2261     /// @notice The owner of the contract can update the slasher address.
2262     /// @param _newSlasherAddress The new slasher address.
2263     function updateSlasher(address _newSlasherAddress) external onlyOwner {
2264         require(_newSlasherAddress != 0x0, "invalid slasher address");
2265         emit LogSlasherUpdated(slasherAddress, _newSlasherAddress);
2266         slasherAddress = _newSlasherAddress;
2267     }
2268 
2269     /// @notice Stores the details of an order.
2270     ///
2271     /// @param _prefix The miscellaneous details of the order required for
2272     ///        calculating the order id.
2273     /// @param _settlementID The settlement identifier.
2274     /// @param _tokens The encoding of the token pair (buy token is encoded as
2275     ///        the first 32 bytes and sell token is encoded as the last 32
2276     ///        bytes).
2277     /// @param _price The price of the order. Interpreted as the cost for 1
2278     ///        standard unit of the secondary token, in 1e12 (i.e.
2279     ///        PRICE_OFFSET) units of the priority token).
2280     /// @param _volume The volume of the order. Interpreted as the maximum
2281     ///        number of 1e-12 (i.e. VOLUME_OFFSET) units of the secondary
2282     ///        token that can be traded by this order.
2283     /// @param _minimumVolume The minimum volume the trader is willing to
2284     ///        accept. Encoded the same as the volume.
2285     function submitOrder(
2286         bytes _prefix,
2287         uint64 _settlementID,
2288         uint64 _tokens,
2289         uint256 _price,
2290         uint256 _volume,
2291         uint256 _minimumVolume
2292     ) external withGasPriceLimit(submissionGasPriceLimit) {
2293 
2294         SettlementUtils.OrderDetails memory order = SettlementUtils.OrderDetails({
2295             settlementID: _settlementID,
2296             tokens: _tokens,
2297             price: _price,
2298             volume: _volume,
2299             minimumVolume: _minimumVolume
2300         });
2301         bytes32 orderID = SettlementUtils.hashOrder(_prefix, order);
2302 
2303         require(orderStatus[orderID] == OrderStatus.None, "order already submitted");
2304         require(orderbookContract.orderState(orderID) == Orderbook.OrderState.Confirmed, "unconfirmed order");
2305 
2306         orderSubmitter[orderID] = msg.sender;
2307         orderStatus[orderID] = OrderStatus.Submitted;
2308         orderDetails[orderID] = order;
2309     }
2310 
2311     /// @notice Settles two orders that are matched. `submitOrder` must have been
2312     /// called for each order before this function is called.
2313     ///
2314     /// @param _buyID The 32 byte ID of the buy order.
2315     /// @param _sellID The 32 byte ID of the sell order.
2316     function settle(bytes32 _buyID, bytes32 _sellID) external {
2317         require(orderStatus[_buyID] == OrderStatus.Submitted, "invalid buy status");
2318         require(orderStatus[_sellID] == OrderStatus.Submitted, "invalid sell status");
2319 
2320         // Check the settlement ID (only have to check for one, since
2321         // `verifyMatchDetails` checks that they are the same)
2322         require(
2323             orderDetails[_buyID].settlementID == RENEX_ATOMIC_SETTLEMENT_ID ||
2324             orderDetails[_buyID].settlementID == RENEX_SETTLEMENT_ID,
2325             "invalid settlement id"
2326         );
2327 
2328         // Verify that the two order details are compatible.
2329         require(SettlementUtils.verifyMatchDetails(orderDetails[_buyID], orderDetails[_sellID]), "incompatible orders");
2330 
2331         // Verify that the two orders have been confirmed to one another.
2332         require(orderbookContract.orderMatch(_buyID) == _sellID, "unconfirmed orders");
2333 
2334         // Retrieve token details.
2335         TokenPair memory tokens = getTokenDetails(orderDetails[_buyID].tokens);
2336 
2337         // Require that the tokens have been registered.
2338         require(tokens.priorityToken.registered, "unregistered priority token");
2339         require(tokens.secondaryToken.registered, "unregistered secondary token");
2340 
2341         address buyer = orderbookContract.orderTrader(_buyID);
2342         address seller = orderbookContract.orderTrader(_sellID);
2343 
2344         require(buyer != seller, "orders from same trader");
2345 
2346         execute(_buyID, _sellID, buyer, seller, tokens);
2347 
2348         /* solium-disable-next-line security/no-block-members */
2349         matchTimestamp[_buyID][_sellID] = now;
2350 
2351         // Store that the orders have been settled.
2352         orderStatus[_buyID] = OrderStatus.Settled;
2353         orderStatus[_sellID] = OrderStatus.Settled;
2354     }
2355 
2356     /// @notice Slashes the bond of a guilty trader. This is called when an
2357     /// atomic swap is not executed successfully.
2358     /// To open an atomic order, a trader must have a balance equivalent to
2359     /// 0.6% of the trade in the Ethereum-based token. 0.2% is always paid in
2360     /// darknode fees when the order is matched. If the remaining amount is
2361     /// is slashed, it is distributed as follows:
2362     ///   1) 0.2% goes to the other trader, covering their fee
2363     ///   2) 0.2% goes to the slasher address
2364     /// Only one order in a match can be slashed.
2365     ///
2366     /// @param _guiltyOrderID The 32 byte ID of the order of the guilty trader.
2367     function slash(bytes32 _guiltyOrderID) external onlySlasher {
2368         require(orderDetails[_guiltyOrderID].settlementID == RENEX_ATOMIC_SETTLEMENT_ID, "slashing non-atomic trade");
2369 
2370         bytes32 innocentOrderID = orderbookContract.orderMatch(_guiltyOrderID);
2371 
2372         require(orderStatus[_guiltyOrderID] == OrderStatus.Settled, "invalid order status");
2373         require(orderStatus[innocentOrderID] == OrderStatus.Settled, "invalid order status");
2374         orderStatus[_guiltyOrderID] = OrderStatus.Slashed;
2375 
2376         (bytes32 buyID, bytes32 sellID) = isBuyOrder(_guiltyOrderID) ?
2377             (_guiltyOrderID, innocentOrderID) : (innocentOrderID, _guiltyOrderID);
2378 
2379         TokenPair memory tokens = getTokenDetails(orderDetails[buyID].tokens);
2380 
2381         SettlementDetails memory settlementDetails = calculateAtomicFees(buyID, sellID, tokens);
2382 
2383         // Transfer the fee amount to the other trader
2384         renExBalancesContract.transferBalanceWithFee(
2385             orderbookContract.orderTrader(_guiltyOrderID),
2386             orderbookContract.orderTrader(innocentOrderID),
2387             settlementDetails.leftTokenAddress,
2388             settlementDetails.leftTokenFee,
2389             0,
2390             0x0
2391         );
2392 
2393         // Transfer the fee amount to the slasher
2394         renExBalancesContract.transferBalanceWithFee(
2395             orderbookContract.orderTrader(_guiltyOrderID),
2396             slasherAddress,
2397             settlementDetails.leftTokenAddress,
2398             settlementDetails.leftTokenFee,
2399             0,
2400             0x0
2401         );
2402     }
2403 
2404     /// @notice Retrieves the settlement details of an order.
2405     /// For atomic swaps, it returns the full volumes, not the settled fees.
2406     ///
2407     /// @param _orderID The order to lookup the details of. Can be the ID of a
2408     ///        buy or a sell order.
2409     /// @return [
2410     ///     a boolean representing whether or not the order has been settled,
2411     ///     a boolean representing whether or not the order is a buy
2412     ///     the 32-byte order ID of the matched order
2413     ///     the volume of the priority token,
2414     ///     the volume of the secondary token,
2415     ///     the fee paid in the priority token,
2416     ///     the fee paid in the secondary token,
2417     ///     the token code of the priority token,
2418     ///     the token code of the secondary token
2419     /// ]
2420     function getMatchDetails(bytes32 _orderID)
2421     external view returns (
2422         bool settled,
2423         bool orderIsBuy,
2424         bytes32 matchedID,
2425         uint256 priorityVolume,
2426         uint256 secondaryVolume,
2427         uint256 priorityFee,
2428         uint256 secondaryFee,
2429         uint32 priorityToken,
2430         uint32 secondaryToken
2431     ) {
2432         matchedID = orderbookContract.orderMatch(_orderID);
2433 
2434         orderIsBuy = isBuyOrder(_orderID);
2435 
2436         (bytes32 buyID, bytes32 sellID) = orderIsBuy ?
2437             (_orderID, matchedID) : (matchedID, _orderID);
2438 
2439         SettlementDetails memory settlementDetails = calculateSettlementDetails(
2440             buyID,
2441             sellID,
2442             getTokenDetails(orderDetails[buyID].tokens)
2443         );
2444 
2445         return (
2446             orderStatus[_orderID] == OrderStatus.Settled || orderStatus[_orderID] == OrderStatus.Slashed,
2447             orderIsBuy,
2448             matchedID,
2449             settlementDetails.leftVolume,
2450             settlementDetails.rightVolume,
2451             settlementDetails.leftTokenFee,
2452             settlementDetails.rightTokenFee,
2453             uint32(orderDetails[buyID].tokens >> 32),
2454             uint32(orderDetails[buyID].tokens)
2455         );
2456     }
2457 
2458     /// @notice Exposes the hashOrder function for computing a hash of an
2459     /// order's details. An order hash is used as its ID. See `submitOrder`
2460     /// for the parameter descriptions.
2461     ///
2462     /// @return The 32-byte hash of the order.
2463     function hashOrder(
2464         bytes _prefix,
2465         uint64 _settlementID,
2466         uint64 _tokens,
2467         uint256 _price,
2468         uint256 _volume,
2469         uint256 _minimumVolume
2470     ) external pure returns (bytes32) {
2471         return SettlementUtils.hashOrder(_prefix, SettlementUtils.OrderDetails({
2472             settlementID: _settlementID,
2473             tokens: _tokens,
2474             price: _price,
2475             volume: _volume,
2476             minimumVolume: _minimumVolume
2477         }));
2478     }
2479 
2480     /// @notice Called by `settle`, executes the settlement for a RenEx order
2481     /// or distributes the fees for a RenExAtomic swap.
2482     ///
2483     /// @param _buyID The 32 byte ID of the buy order.
2484     /// @param _sellID The 32 byte ID of the sell order.
2485     /// @param _buyer The address of the buy trader.
2486     /// @param _seller The address of the sell trader.
2487     /// @param _tokens The details of the priority and secondary tokens.
2488     function execute(
2489         bytes32 _buyID,
2490         bytes32 _sellID,
2491         address _buyer,
2492         address _seller,
2493         TokenPair memory _tokens
2494     ) private {
2495         // Calculate the fees for atomic swaps, and the settlement details
2496         // otherwise.
2497         SettlementDetails memory settlementDetails = (orderDetails[_buyID].settlementID == RENEX_ATOMIC_SETTLEMENT_ID) ?
2498             settlementDetails = calculateAtomicFees(_buyID, _sellID, _tokens) :
2499             settlementDetails = calculateSettlementDetails(_buyID, _sellID, _tokens);
2500 
2501         // Transfer priority token value
2502         renExBalancesContract.transferBalanceWithFee(
2503             _buyer,
2504             _seller,
2505             settlementDetails.leftTokenAddress,
2506             settlementDetails.leftVolume,
2507             settlementDetails.leftTokenFee,
2508             orderSubmitter[_buyID]
2509         );
2510 
2511         // Transfer secondary token value
2512         renExBalancesContract.transferBalanceWithFee(
2513             _seller,
2514             _buyer,
2515             settlementDetails.rightTokenAddress,
2516             settlementDetails.rightVolume,
2517             settlementDetails.rightTokenFee,
2518             orderSubmitter[_sellID]
2519         );
2520     }
2521 
2522     /// @notice Calculates the details required to execute two matched orders.
2523     ///
2524     /// @param _buyID The 32 byte ID of the buy order.
2525     /// @param _sellID The 32 byte ID of the sell order.
2526     /// @param _tokens The details of the priority and secondary tokens.
2527     /// @return A struct containing the settlement details.
2528     function calculateSettlementDetails(
2529         bytes32 _buyID,
2530         bytes32 _sellID,
2531         TokenPair memory _tokens
2532     ) private view returns (SettlementDetails memory) {
2533 
2534         // Calculate the mid-price (using numerator and denominator to not loose
2535         // precision).
2536         Fraction memory midPrice = Fraction(orderDetails[_buyID].price.add(orderDetails[_sellID].price), 2);
2537 
2538         // Calculate the lower of the two max volumes of each trader
2539         uint256 commonVolume = Math.min256(orderDetails[_buyID].volume, orderDetails[_sellID].volume);
2540 
2541         uint256 priorityTokenVolume = joinFraction(
2542             commonVolume.mul(midPrice.numerator),
2543             midPrice.denominator,
2544             int16(_tokens.priorityToken.decimals) - PRICE_OFFSET - VOLUME_OFFSET
2545         );
2546         uint256 secondaryTokenVolume = joinFraction(
2547             commonVolume,
2548             1,
2549             int16(_tokens.secondaryToken.decimals) - VOLUME_OFFSET
2550         );
2551 
2552         // Calculate darknode fees
2553         ValueWithFees memory priorityVwF = subtractDarknodeFee(priorityTokenVolume);
2554         ValueWithFees memory secondaryVwF = subtractDarknodeFee(secondaryTokenVolume);
2555 
2556         return SettlementDetails({
2557             leftVolume: priorityVwF.value,
2558             rightVolume: secondaryVwF.value,
2559             leftTokenFee: priorityVwF.fees,
2560             rightTokenFee: secondaryVwF.fees,
2561             leftTokenAddress: _tokens.priorityToken.addr,
2562             rightTokenAddress: _tokens.secondaryToken.addr
2563         });
2564     }
2565 
2566     /// @notice Calculates the fees to be transferred for an atomic swap.
2567     ///
2568     /// @param _buyID The 32 byte ID of the buy order.
2569     /// @param _sellID The 32 byte ID of the sell order.
2570     /// @param _tokens The details of the priority and secondary tokens.
2571     /// @return A struct containing the fee details.
2572     function calculateAtomicFees(
2573         bytes32 _buyID,
2574         bytes32 _sellID,
2575         TokenPair memory _tokens
2576     ) private view returns (SettlementDetails memory) {
2577 
2578         // Calculate the mid-price (using numerator and denominator to not loose
2579         // precision).
2580         Fraction memory midPrice = Fraction(orderDetails[_buyID].price.add(orderDetails[_sellID].price), 2);
2581 
2582         // Calculate the lower of the two max volumes of each trader
2583         uint256 commonVolume = Math.min256(orderDetails[_buyID].volume, orderDetails[_sellID].volume);
2584 
2585         if (isEthereumBased(_tokens.secondaryToken.addr)) {
2586             uint256 secondaryTokenVolume = joinFraction(
2587                 commonVolume,
2588                 1,
2589                 int16(_tokens.secondaryToken.decimals) - VOLUME_OFFSET
2590             );
2591 
2592             // Calculate darknode fees
2593             ValueWithFees memory secondaryVwF = subtractDarknodeFee(secondaryTokenVolume);
2594 
2595             return SettlementDetails({
2596                 leftVolume: 0,
2597                 rightVolume: 0,
2598                 leftTokenFee: secondaryVwF.fees,
2599                 rightTokenFee: secondaryVwF.fees,
2600                 leftTokenAddress: _tokens.secondaryToken.addr,
2601                 rightTokenAddress: _tokens.secondaryToken.addr
2602             });
2603         } else if (isEthereumBased(_tokens.priorityToken.addr)) {
2604             uint256 priorityTokenVolume = joinFraction(
2605                 commonVolume.mul(midPrice.numerator),
2606                 midPrice.denominator,
2607                 int16(_tokens.priorityToken.decimals) - PRICE_OFFSET - VOLUME_OFFSET
2608             );
2609 
2610             // Calculate darknode fees
2611             ValueWithFees memory priorityVwF = subtractDarknodeFee(priorityTokenVolume);
2612 
2613             return SettlementDetails({
2614                 leftVolume: 0,
2615                 rightVolume: 0,
2616                 leftTokenFee: priorityVwF.fees,
2617                 rightTokenFee: priorityVwF.fees,
2618                 leftTokenAddress: _tokens.priorityToken.addr,
2619                 rightTokenAddress: _tokens.priorityToken.addr
2620             });
2621         } else {
2622             // Currently, at least one token must be Ethereum-based.
2623             // This will be implemented in the future.
2624             revert("non-eth atomic swaps are not supported");
2625         }
2626     }
2627 
2628     /// @notice Order parity is set by the order tokens are listed. This returns
2629     /// whether an order is a buy or a sell.
2630     /// @return true if _orderID is a buy order.
2631     function isBuyOrder(bytes32 _orderID) private view returns (bool) {
2632         uint64 tokens = orderDetails[_orderID].tokens;
2633         uint32 firstToken = uint32(tokens >> 32);
2634         uint32 secondaryToken = uint32(tokens);
2635         return (firstToken < secondaryToken);
2636     }
2637 
2638     /// @return (value - fee, fee) where fee is 0.2% of value
2639     function subtractDarknodeFee(uint256 _value) private pure returns (ValueWithFees memory) {
2640         uint256 newValue = (_value.mul(DARKNODE_FEES_DENOMINATOR - DARKNODE_FEES_NUMERATOR)) / DARKNODE_FEES_DENOMINATOR;
2641         return ValueWithFees(newValue, _value.sub(newValue));
2642     }
2643 
2644     /// @notice Gets the order details of the priority and secondary token from
2645     /// the RenExTokens contract and returns them as a single struct.
2646     ///
2647     /// @param _tokens The 64-bit combined token identifiers.
2648     /// @return A TokenPair struct containing two TokenDetails structs.
2649     function getTokenDetails(uint64 _tokens) private view returns (TokenPair memory) {
2650         (
2651             address priorityAddress,
2652             uint8 priorityDecimals,
2653             bool priorityRegistered
2654         ) = renExTokensContract.tokens(uint32(_tokens >> 32));
2655 
2656         (
2657             address secondaryAddress,
2658             uint8 secondaryDecimals,
2659             bool secondaryRegistered
2660         ) = renExTokensContract.tokens(uint32(_tokens));
2661 
2662         return TokenPair({
2663             priorityToken: RenExTokens.TokenDetails(priorityAddress, priorityDecimals, priorityRegistered),
2664             secondaryToken: RenExTokens.TokenDetails(secondaryAddress, secondaryDecimals, secondaryRegistered)
2665         });
2666     }
2667 
2668     /// @return true if _tokenAddress is 0x0, representing a token that is not
2669     /// on Ethereum
2670     function isEthereumBased(address _tokenAddress) private pure returns (bool) {
2671         return (_tokenAddress != 0x0);
2672     }
2673 
2674     /// @notice Computes (_numerator / _denominator) * 10 ** _scale
2675     function joinFraction(uint256 _numerator, uint256 _denominator, int16 _scale) private pure returns (uint256) {
2676         if (_scale >= 0) {
2677             // Check that (10**_scale) doesn't overflow
2678             assert(_scale <= 77); // log10(2**256) = 77.06
2679             return _numerator.mul(10 ** uint256(_scale)) / _denominator;
2680         } else {
2681             /// @dev If _scale is less than -77, 10**-_scale would overflow.
2682             // For now, -_scale > -24 (when a token has 0 decimals and
2683             // VOLUME_OFFSET and PRICE_OFFSET are each 12). It is unlikely these
2684             // will be increased to add to more than 77.
2685             // assert((-_scale) <= 77); // log10(2**256) = 77.06
2686             return (_numerator / _denominator) / 10 ** uint256(-_scale);
2687         }
2688     }
2689 }
2690 
2691 /// @notice RenExBrokerVerifier implements the BrokerVerifier contract,
2692 /// verifying broker signatures for order opening and fund withdrawal.
2693 contract RenExBrokerVerifier is Ownable {
2694     string public VERSION; // Passed in as a constructor parameter.
2695 
2696     // Events
2697     event LogBalancesContractUpdated(address previousBalancesContract, address nextBalancesContract);
2698     event LogBrokerRegistered(address broker);
2699     event LogBrokerDeregistered(address broker);
2700 
2701     // Storage
2702     mapping(address => bool) public brokerRegistered;
2703     mapping(address => mapping(address => uint256)) public traderTokenNonce;
2704 
2705     address public balancesContract;
2706 
2707     modifier onlyBalancesContract() {
2708         require(msg.sender == balancesContract, "not authorized");
2709         _;
2710     }
2711 
2712     /// @notice The contract constructor.
2713     ///
2714     /// @param _VERSION A string defining the contract version.
2715     constructor(string _VERSION) public {
2716         VERSION = _VERSION;
2717     }
2718 
2719     /// @notice Allows the owner of the contract to update the address of the
2720     /// RenExBalances contract.
2721     ///
2722     /// @param _balancesContract The address of the new balances contract
2723     function updateBalancesContract(address _balancesContract) external onlyOwner {
2724         // Basic validation
2725         require(_balancesContract != 0x0, "invalid contract address");
2726 
2727         emit LogBalancesContractUpdated(balancesContract, _balancesContract);
2728 
2729         balancesContract = _balancesContract;
2730     }
2731 
2732     /// @notice Approved an address to sign order-opening and withdrawals.
2733     /// @param _broker The address of the broker.
2734     function registerBroker(address _broker) external onlyOwner {
2735         require(!brokerRegistered[_broker], "already registered");
2736         brokerRegistered[_broker] = true;
2737         emit LogBrokerRegistered(_broker);
2738     }
2739 
2740     /// @notice Reverts the a broker's registration.
2741     /// @param _broker The address of the broker.
2742     function deregisterBroker(address _broker) external onlyOwner {
2743         require(brokerRegistered[_broker], "not registered");
2744         brokerRegistered[_broker] = false;
2745         emit LogBrokerDeregistered(_broker);
2746     }
2747 
2748     /// @notice Verifies a broker's signature for an order opening.
2749     /// The data signed by the broker is a prefixed message and the order ID.
2750     ///
2751     /// @param _trader The trader requesting the withdrawal.
2752     /// @param _signature The 65-byte signature from the broker.
2753     /// @param _orderID The 32-byte order ID.
2754     /// @return True if the signature is valid, false otherwise.
2755     function verifyOpenSignature(
2756         address _trader,
2757         bytes _signature,
2758         bytes32 _orderID
2759     ) external view returns (bool) {
2760         bytes memory data = abi.encodePacked("Republic Protocol: open: ", _trader, _orderID);
2761         address signer = Utils.addr(data, _signature);
2762         return (brokerRegistered[signer] == true);
2763     }
2764 
2765     /// @notice Verifies a broker's signature for a trader withdrawal.
2766     /// The data signed by the broker is a prefixed message, the trader address
2767     /// and a 256-bit trader token nonce, which is incremented every time a
2768     /// valid signature is checked for a specific token.
2769     ///
2770     /// @param _trader The trader requesting the withdrawal.
2771     /// @param _signature 65-byte signature from the broker.
2772     /// @return True if the signature is valid, false otherwise.
2773     function verifyWithdrawSignature(
2774         address _trader,
2775         address _token,
2776         bytes _signature
2777     ) external onlyBalancesContract returns (bool) {
2778         bytes memory data = abi.encodePacked(
2779             "Republic Protocol: withdraw: ",
2780             _trader,
2781             _token,
2782             traderTokenNonce[_trader][_token]
2783         );
2784         address signer = Utils.addr(data, _signature);
2785         if (brokerRegistered[signer]) {
2786             traderTokenNonce[_trader][_token] += 1;
2787             return true;
2788         }
2789         return false;
2790     }
2791 }
2792 
2793 /// @notice RenExBalances is responsible for holding RenEx trader funds.
2794 contract RenExBalances is Ownable {
2795     using SafeMath for uint256;
2796     using CompatibleERC20Functions for CompatibleERC20;
2797 
2798     string public VERSION; // Passed in as a constructor parameter.
2799 
2800     RenExSettlement public settlementContract;
2801     RenExBrokerVerifier public brokerVerifierContract;
2802     DarknodeRewardVault public rewardVaultContract;
2803 
2804     /// @dev Should match the address in the DarknodeRewardVault
2805     address constant public ETHEREUM = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
2806     
2807     // Delay between a trader calling `withdrawSignal` and being able to call
2808     // `withdraw` without a broker signature.
2809     uint256 constant public SIGNAL_DELAY = 48 hours;
2810 
2811     // Events
2812     event LogBalanceDecreased(address trader, ERC20 token, uint256 value);
2813     event LogBalanceIncreased(address trader, ERC20 token, uint256 value);
2814     event LogRenExSettlementContractUpdated(address previousRenExSettlementContract, address newRenExSettlementContract);
2815     event LogRewardVaultContractUpdated(address previousRewardVaultContract, address newRewardVaultContract);
2816     event LogBrokerVerifierContractUpdated(address previousBrokerVerifierContract, address newBrokerVerifierContract);
2817 
2818     // Storage
2819     mapping(address => mapping(address => uint256)) public traderBalances;
2820     mapping(address => mapping(address => uint256)) public traderWithdrawalSignals;
2821 
2822     /// @notice The contract constructor.
2823     ///
2824     /// @param _VERSION A string defining the contract version.
2825     /// @param _rewardVaultContract The address of the RewardVault contract.
2826     constructor(
2827         string _VERSION,
2828         DarknodeRewardVault _rewardVaultContract,
2829         RenExBrokerVerifier _brokerVerifierContract
2830     ) public {
2831         VERSION = _VERSION;
2832         rewardVaultContract = _rewardVaultContract;
2833         brokerVerifierContract = _brokerVerifierContract;
2834     }
2835 
2836     /// @notice Restricts a function to only being called by the RenExSettlement
2837     /// contract.
2838     modifier onlyRenExSettlementContract() {
2839         require(msg.sender == address(settlementContract), "not authorized");
2840         _;
2841     }
2842 
2843     /// @notice Restricts trader withdrawing to be called if a signature from a
2844     /// RenEx broker is provided, or if a certain amount of time has passed
2845     /// since a trader has called `signalBackupWithdraw`.
2846     /// @dev If the trader is withdrawing after calling `signalBackupWithdraw`,
2847     /// this will reset the time to zero, writing to storage.
2848     modifier withBrokerSignatureOrSignal(address _token, bytes _signature) {
2849         address trader = msg.sender;
2850 
2851         // If a signature has been provided, verify it - otherwise, verify that
2852         // the user has signalled the withdraw
2853         if (_signature.length > 0) {
2854             require (brokerVerifierContract.verifyWithdrawSignature(trader, _token, _signature), "invalid signature");
2855         } else  {
2856             require(traderWithdrawalSignals[trader][_token] != 0, "not signalled");
2857             /* solium-disable-next-line security/no-block-members */
2858             require((now - traderWithdrawalSignals[trader][_token]) > SIGNAL_DELAY, "signal time remaining");
2859             traderWithdrawalSignals[trader][_token] = 0;
2860         }
2861         _;
2862     }
2863 
2864     /// @notice Allows the owner of the contract to update the address of the
2865     /// RenExSettlement contract.
2866     ///
2867     /// @param _newSettlementContract the address of the new settlement contract
2868     function updateRenExSettlementContract(RenExSettlement _newSettlementContract) external onlyOwner {
2869         // Basic validation knowing that RenExSettlement exposes VERSION
2870         require(bytes(_newSettlementContract.VERSION()).length > 0, "invalid settlement contract");
2871 
2872         emit LogRenExSettlementContractUpdated(settlementContract, _newSettlementContract);
2873         settlementContract = _newSettlementContract;
2874     }
2875 
2876     /// @notice Allows the owner of the contract to update the address of the
2877     /// DarknodeRewardVault contract.
2878     ///
2879     /// @param _newRewardVaultContract the address of the new reward vault contract
2880     function updateRewardVaultContract(DarknodeRewardVault _newRewardVaultContract) external onlyOwner {
2881         // Basic validation knowing that DarknodeRewardVault exposes VERSION
2882         require(bytes(_newRewardVaultContract.VERSION()).length > 0, "invalid reward vault contract");
2883 
2884         emit LogRewardVaultContractUpdated(rewardVaultContract, _newRewardVaultContract);
2885         rewardVaultContract = _newRewardVaultContract;
2886     }
2887 
2888     /// @notice Allows the owner of the contract to update the address of the
2889     /// RenExBrokerVerifier contract.
2890     ///
2891     /// @param _newBrokerVerifierContract the address of the new broker verifier contract
2892     function updateBrokerVerifierContract(RenExBrokerVerifier _newBrokerVerifierContract) external onlyOwner {
2893         // Basic validation knowing that RenExBrokerVerifier exposes VERSION
2894         require(bytes(_newBrokerVerifierContract.VERSION()).length > 0, "invalid broker verifier contract");        
2895 
2896         emit LogBrokerVerifierContractUpdated(brokerVerifierContract, _newBrokerVerifierContract);
2897         brokerVerifierContract = _newBrokerVerifierContract;
2898     }
2899 
2900     /// @notice Transfer a token value from one trader to another, transferring
2901     /// a fee to the RewardVault. Can only be called by the RenExSettlement
2902     /// contract.
2903     ///
2904     /// @param _traderFrom The address of the trader to decrement the balance of.
2905     /// @param _traderTo The address of the trader to increment the balance of.
2906     /// @param _token The token's address.
2907     /// @param _value The number of tokens to decrement the balance by (in the
2908     ///        token's smallest unit).
2909     /// @param _fee The fee amount to forward on to the RewardVault.
2910     /// @param _feePayee The recipient of the fee.
2911     function transferBalanceWithFee(address _traderFrom, address _traderTo, address _token, uint256 _value, uint256 _fee, address _feePayee)
2912     external onlyRenExSettlementContract {
2913         require(traderBalances[_traderFrom][_token] >= _fee, "insufficient funds for fee");
2914 
2915         // Decrease balance
2916         privateDecrementBalance(_traderFrom, ERC20(_token), _value.add(_fee));
2917 
2918         if (_token == ETHEREUM) {
2919             rewardVaultContract.deposit.value(_fee)(_feePayee, ERC20(_token), _fee);
2920         } else {
2921             CompatibleERC20(_token).safeApprove(rewardVaultContract, _fee);
2922             rewardVaultContract.deposit(_feePayee, ERC20(_token), _fee);
2923         }
2924         
2925         // Increase balance
2926         if (_value > 0) {
2927             privateIncrementBalance(_traderTo, ERC20(_token), _value);
2928         }
2929     }
2930 
2931     /// @notice Deposits ETH or an ERC20 token into the contract.
2932     ///
2933     /// @param _token The token's address (must be a registered token).
2934     /// @param _value The amount to deposit in the token's smallest unit.
2935     function deposit(ERC20 _token, uint256 _value) external payable {
2936         address trader = msg.sender;
2937 
2938         uint256 receivedValue = _value;
2939         if (_token == ETHEREUM) {
2940             require(msg.value == _value, "mismatched value parameter and tx value");
2941         } else {
2942             require(msg.value == 0, "unexpected ether transfer");
2943             receivedValue = CompatibleERC20(_token).safeTransferFromWithFees(trader, this, _value);
2944         }
2945         privateIncrementBalance(trader, _token, receivedValue);
2946     }
2947 
2948     /// @notice Withdraws ETH or an ERC20 token from the contract. A broker
2949     /// signature is required to guarantee that the trader has a sufficient
2950     /// balance after accounting for open orders. As a trustless backup,
2951     /// traders can withdraw 48 hours after calling `signalBackupWithdraw`.
2952     ///
2953     /// @param _token The token's address.
2954     /// @param _value The amount to withdraw in the token's smallest unit.
2955     /// @param _signature The broker signature
2956     function withdraw(ERC20 _token, uint256 _value, bytes _signature) external withBrokerSignatureOrSignal(_token, _signature) {
2957         address trader = msg.sender;
2958 
2959         privateDecrementBalance(trader, _token, _value);
2960         if (_token == ETHEREUM) {
2961             trader.transfer(_value);
2962         } else {
2963             CompatibleERC20(_token).safeTransfer(trader, _value);
2964         }
2965     }
2966 
2967     /// @notice A trader can withdraw without needing a broker signature if they
2968     /// first call `signalBackupWithdraw` for the token they want to withdraw.
2969     /// The trader can only withdraw the particular token once for each call to
2970     /// this function. Traders can signal the intent to withdraw multiple
2971     /// tokens.
2972     /// Once this function is called, brokers will not sign order-opens for the
2973     /// trader until the trader has withdrawn, guaranteeing that they won't have
2974     /// orders open for the particular token.
2975     function signalBackupWithdraw(address _token) external {
2976         /* solium-disable-next-line security/no-block-members */
2977         traderWithdrawalSignals[msg.sender][_token] = now;
2978     }
2979 
2980     function privateIncrementBalance(address _trader, ERC20 _token, uint256 _value) private {
2981         traderBalances[_trader][_token] = traderBalances[_trader][_token].add(_value);
2982 
2983         emit LogBalanceIncreased(_trader, _token, _value);
2984     }
2985 
2986     function privateDecrementBalance(address _trader, ERC20 _token, uint256 _value) private {
2987         require(traderBalances[_trader][_token] >= _value, "insufficient funds");
2988         traderBalances[_trader][_token] = traderBalances[_trader][_token].sub(_value);
2989 
2990         emit LogBalanceDecreased(_trader, _token, _value);
2991     }
2992 }
2993 
2994 /// @notice RenExSettlement implements the Settlement interface. It implements
2995 /// the on-chain settlement for the RenEx settlement layer, and the fee payment
2996 /// for the RenExAtomic settlement layer.
2997 contract RenExSwapperdSettlement is Ownable {
2998     using SafeMath for uint256;
2999 
3000     string public VERSION; // Passed in as a constructor parameter.
3001 
3002     // Fees in RenEx are 0%. To represent this as integers, it is broken into
3003     // a numerator and denominator.
3004     // DARKNODE_FEES_NUMERATOR must not be greater than
3005     // DARKNODE_FEES_DENOMINATOR.
3006     uint256 constant public DARKNODE_FEES_NUMERATOR = 0;
3007     uint256 constant public DARKNODE_FEES_DENOMINATOR = 1000;
3008 
3009     // This contract handles the settlements with ID 3.
3010     uint32 constant public RENEX_SWAPPERD_SETTLEMENT_ID = 3;
3011 
3012     // Constants used in the price / volume inputs.
3013     int16 constant private PRICE_OFFSET = 12;
3014     int16 constant private VOLUME_OFFSET = 12;
3015 
3016     // Constructor parameters, updatable by the owner
3017     Orderbook public orderbookContract;
3018     RenExTokens public renExTokensContract;
3019     RenExBalances public renExBalancesContract;
3020     address public slasherAddress;
3021     uint256 public submissionGasPriceLimit;
3022 
3023     enum OrderStatus {None, Submitted, Settled, Slashed}
3024 
3025     struct TokenPair {
3026         RenExTokens.TokenDetails priorityToken;
3027         RenExTokens.TokenDetails secondaryToken;
3028     }
3029 
3030     // A uint256 tuple representing a value and an associated fee
3031     struct ValueWithFees {
3032         uint256 value;
3033         uint256 fees;
3034     }
3035 
3036     // A uint256 tuple representing a fraction
3037     struct Fraction {
3038         uint256 numerator;
3039         uint256 denominator;
3040     }
3041 
3042     // We use left and right because the tokens do not always represent the
3043     // priority and secondary tokens.
3044     struct SettlementDetails {
3045         uint256 leftVolume;
3046         uint256 rightVolume;
3047         uint256 leftTokenFee;
3048         uint256 rightTokenFee;
3049         address leftTokenAddress;
3050         address rightTokenAddress;
3051     }
3052 
3053     // Events
3054     event LogOrderbookUpdated(Orderbook previousOrderbook, Orderbook nextOrderbook);
3055     event LogRenExTokensUpdated(RenExTokens previousRenExTokens, RenExTokens nextRenExTokens);
3056     event LogRenExBalancesUpdated(RenExBalances previousRenExBalances, RenExBalances nextRenExBalances);
3057     event LogSubmissionGasPriceLimitUpdated(uint256 previousSubmissionGasPriceLimit, uint256 nextSubmissionGasPriceLimit);
3058     event LogSlasherUpdated(address previousSlasher, address nextSlasher);
3059     event LogOrderSettled(bytes32 indexed orderID);
3060 
3061     // Order Storage
3062     mapping(bytes32 => SettlementUtils.OrderDetails) public orderDetails;
3063     mapping(bytes32 => address) public orderSubmitter;
3064     mapping(bytes32 => OrderStatus) public orderStatus;
3065 
3066     // Match storage (match details are indexed by [buyID][sellID])
3067     mapping(bytes32 => mapping(bytes32 => uint256)) public matchTimestamp;
3068 
3069     /// @notice Prevents a function from being called with a gas price higher
3070     /// than the specified limit.
3071     ///
3072     /// @param _gasPriceLimit The gas price upper-limit in Wei.
3073     modifier withGasPriceLimit(uint256 _gasPriceLimit) {
3074         require(tx.gasprice <= _gasPriceLimit, "gas price too high");
3075         _;
3076     }
3077 
3078     /// @notice Restricts a function to only being called by the slasher
3079     /// address.
3080     modifier onlySlasher() {
3081         require(msg.sender == slasherAddress, "unauthorized");
3082         _;
3083     }
3084 
3085     /// @notice The contract constructor.
3086     ///
3087     /// @param _VERSION A string defining the contract version.
3088     /// @param _orderbookContract The address of the Orderbook contract.
3089     /// @param _renExBalancesContract The address of the RenExBalances
3090     ///        contract.
3091     /// @param _renExTokensContract The address of the RenExTokens contract.
3092     constructor(
3093         string _VERSION,
3094         Orderbook _orderbookContract,
3095         RenExTokens _renExTokensContract,
3096         RenExBalances _renExBalancesContract,
3097         address _slasherAddress,
3098         uint256 _submissionGasPriceLimit
3099     ) public {
3100         VERSION = _VERSION;
3101         orderbookContract = _orderbookContract;
3102         renExTokensContract = _renExTokensContract;
3103         renExBalancesContract = _renExBalancesContract;
3104         slasherAddress = _slasherAddress;
3105         submissionGasPriceLimit = _submissionGasPriceLimit;
3106     }
3107 
3108     /// @notice The owner of the contract can update the Orderbook address.
3109     /// @param _newOrderbookContract The address of the new Orderbook contract.
3110     function updateOrderbook(Orderbook _newOrderbookContract) external onlyOwner {
3111         // Basic validation knowing that Orderbook exposes VERSION
3112         require(bytes(_newOrderbookContract.VERSION()).length > 0, "invalid orderbook contract");
3113 
3114         emit LogOrderbookUpdated(orderbookContract, _newOrderbookContract);
3115         orderbookContract = _newOrderbookContract;
3116     }
3117 
3118     /// @notice The owner of the contract can update the RenExTokens address.
3119     /// @param _newRenExTokensContract The address of the new RenExTokens
3120     ///       contract.
3121     function updateRenExTokens(RenExTokens _newRenExTokensContract) external onlyOwner {
3122         // Basic validation knowing that RenExTokens exposes VERSION
3123         require(bytes(_newRenExTokensContract.VERSION()).length > 0, "invalid tokens contract");
3124         
3125         emit LogRenExTokensUpdated(renExTokensContract, _newRenExTokensContract);
3126         renExTokensContract = _newRenExTokensContract;
3127     }
3128     
3129     /// @notice The owner of the contract can update the RenExBalances address.
3130     /// @param _newRenExBalancesContract The address of the new RenExBalances
3131     ///       contract.
3132     function updateRenExBalances(RenExBalances _newRenExBalancesContract) external onlyOwner {
3133         // Basic validation knowing that RenExBalances exposes VERSION
3134         require(bytes(_newRenExBalancesContract.VERSION()).length > 0, "invalid balances contract");
3135 
3136         emit LogRenExBalancesUpdated(renExBalancesContract, _newRenExBalancesContract);
3137         renExBalancesContract = _newRenExBalancesContract;
3138     }
3139 
3140     /// @notice The owner of the contract can update the order submission gas
3141     /// price limit.
3142     /// @param _newSubmissionGasPriceLimit The new gas price limit.
3143     function updateSubmissionGasPriceLimit(uint256 _newSubmissionGasPriceLimit) external onlyOwner {
3144         // Submission Gas Price Limit must be at least 100000000 wei (0.1 gwei)
3145         require(_newSubmissionGasPriceLimit >= 100000000, "invalid new submission gas price limit");
3146         emit LogSubmissionGasPriceLimitUpdated(submissionGasPriceLimit, _newSubmissionGasPriceLimit);
3147         submissionGasPriceLimit = _newSubmissionGasPriceLimit;
3148     }
3149 
3150     /// @notice The owner of the contract can update the slasher address.
3151     /// @param _newSlasherAddress The new slasher address.
3152     function updateSlasher(address _newSlasherAddress) external onlyOwner {
3153         require(_newSlasherAddress != 0x0, "invalid slasher address");
3154         emit LogSlasherUpdated(slasherAddress, _newSlasherAddress);
3155         slasherAddress = _newSlasherAddress;
3156     }
3157 
3158     /// @notice Stores the details of an order.
3159     ///
3160     /// @param _prefix The miscellaneous details of the order required for
3161     ///        calculating the order id.
3162     /// @param _settlementID The settlement identifier.
3163     /// @param _tokens The encoding of the token pair (buy token is encoded as
3164     ///        the first 32 bytes and sell token is encoded as the last 32
3165     ///        bytes).
3166     /// @param _price The price of the order. Interpreted as the cost for 1
3167     ///        standard unit of the secondary token, in 1e12 (i.e.
3168     ///        PRICE_OFFSET) units of the priority token).
3169     /// @param _volume The volume of the order. Interpreted as the maximum
3170     ///        number of 1e-12 (i.e. VOLUME_OFFSET) units of the secondary
3171     ///        token that can be traded by this order.
3172     /// @param _minimumVolume The minimum volume the trader is willing to
3173     ///        accept. Encoded the same as the volume.
3174     function submitOrder(
3175         bytes _prefix,
3176         uint64 _settlementID,
3177         uint64 _tokens,
3178         uint256 _price,
3179         uint256 _volume,
3180         uint256 _minimumVolume
3181     ) external withGasPriceLimit(submissionGasPriceLimit) {
3182 
3183         SettlementUtils.OrderDetails memory order = SettlementUtils.OrderDetails({
3184             settlementID: _settlementID,
3185             tokens: _tokens,
3186             price: _price,
3187             volume: _volume,
3188             minimumVolume: _minimumVolume
3189         });
3190         bytes32 orderID = SettlementUtils.hashOrder(_prefix, order);
3191 
3192         require(orderStatus[orderID] == OrderStatus.None, "order already submitted");
3193         require(orderbookContract.orderState(orderID) == Orderbook.OrderState.Confirmed, "unconfirmed order");
3194 
3195         orderSubmitter[orderID] = msg.sender;
3196         orderStatus[orderID] = OrderStatus.Submitted;
3197         orderDetails[orderID] = order;
3198     }
3199 
3200     /// @notice Settles two orders that are matched. `submitOrder` must have been
3201     /// called for each order before this function is called.
3202     ///
3203     /// @param _buyID The 32 byte ID of the buy order.
3204     /// @param _sellID The 32 byte ID of the sell order.
3205     function settle(bytes32 _buyID, bytes32 _sellID) external {
3206         require(orderStatus[_buyID] == OrderStatus.Submitted, "invalid buy status");
3207         require(orderStatus[_sellID] == OrderStatus.Submitted, "invalid sell status");
3208 
3209         // Check the settlement ID (only have to check for one, since
3210         // `verifyMatchDetails` checks that they are the same)
3211         require(
3212             orderDetails[_buyID].settlementID == RENEX_SWAPPERD_SETTLEMENT_ID,
3213             "invalid settlement id"
3214         );
3215 
3216         // Verify that the two order details are compatible.
3217         require(SettlementUtils.verifyMatchDetails(orderDetails[_buyID], orderDetails[_sellID]), "incompatible orders");
3218 
3219         // Verify that the two orders have been confirmed to one another.
3220         require(orderbookContract.orderMatch(_buyID) == _sellID, "unconfirmed orders");
3221 
3222         // Retrieve token details.
3223         TokenPair memory tokens = getTokenDetails(orderDetails[_buyID].tokens);
3224 
3225         // Require that the tokens have been registered.
3226         require(tokens.priorityToken.registered, "unregistered priority token");
3227         require(tokens.secondaryToken.registered, "unregistered secondary token");
3228 
3229         address buyer = orderbookContract.orderTrader(_buyID);
3230         address seller = orderbookContract.orderTrader(_sellID);
3231 
3232         require(buyer != seller, "orders from same trader");
3233 
3234         /* solium-disable-next-line security/no-block-members */
3235         matchTimestamp[_buyID][_sellID] = now;
3236 
3237         // Store that the orders have been settled.
3238         orderStatus[_buyID] = OrderStatus.Settled;
3239         orderStatus[_sellID] = OrderStatus.Settled;
3240 
3241         emit LogOrderSettled(_buyID);
3242         emit LogOrderSettled(_sellID);
3243     }
3244 
3245     /// @notice Retrieves the settlement details of an order.
3246     /// For atomic swaps, it returns the full volumes, not the settled fees.
3247     ///
3248     /// @param _orderID The order to lookup the details of. Can be the ID of a
3249     ///        buy or a sell order.
3250     /// @return [
3251     ///     a boolean representing whether or not the order has been settled,
3252     ///     a boolean representing whether or not the order is a buy
3253     ///     the 32-byte order ID of the matched order
3254     ///     the volume of the priority token,
3255     ///     the volume of the secondary token,
3256     ///     the fee paid in the priority token,
3257     ///     the fee paid in the secondary token,
3258     ///     the token code of the priority token,
3259     ///     the token code of the secondary token
3260     /// ]
3261     function getMatchDetails(bytes32 _orderID)
3262     external view returns (
3263         bool settled,
3264         bool orderIsBuy,
3265         bytes32 matchedID,
3266         uint256 priorityVolume,
3267         uint256 secondaryVolume,
3268         uint256 priorityFee,
3269         uint256 secondaryFee,
3270         uint32 priorityToken,
3271         uint32 secondaryToken
3272     ) {
3273         matchedID = orderbookContract.orderMatch(_orderID);
3274 
3275         orderIsBuy = isBuyOrder(_orderID);
3276 
3277         (bytes32 buyID, bytes32 sellID) = orderIsBuy ?
3278             (_orderID, matchedID) : (matchedID, _orderID);
3279 
3280         SettlementDetails memory settlementDetails = calculateSettlementDetails(
3281             buyID,
3282             sellID,
3283             getTokenDetails(orderDetails[buyID].tokens)
3284         );
3285 
3286         return (
3287             orderStatus[_orderID] == OrderStatus.Settled || orderStatus[_orderID] == OrderStatus.Slashed,
3288             orderIsBuy,
3289             matchedID,
3290             settlementDetails.leftVolume,
3291             settlementDetails.rightVolume,
3292             settlementDetails.leftTokenFee,
3293             settlementDetails.rightTokenFee,
3294             uint32(orderDetails[buyID].tokens >> 32),
3295             uint32(orderDetails[buyID].tokens)
3296         );
3297     }
3298 
3299     /// @notice Exposes the hashOrder function for computing a hash of an
3300     /// order's details. An order hash is used as its ID. See `submitOrder`
3301     /// for the parameter descriptions.
3302     ///
3303     /// @return The 32-byte hash of the order.
3304     function hashOrder(
3305         bytes _prefix,
3306         uint64 _settlementID,
3307         uint64 _tokens,
3308         uint256 _price,
3309         uint256 _volume,
3310         uint256 _minimumVolume
3311     ) external pure returns (bytes32) {
3312         return SettlementUtils.hashOrder(_prefix, SettlementUtils.OrderDetails({
3313             settlementID: _settlementID,
3314             tokens: _tokens,
3315             price: _price,
3316             volume: _volume,
3317             minimumVolume: _minimumVolume
3318         }));
3319     }
3320 
3321     /// @notice Calculates the details required to execute two matched orders.
3322     ///
3323     /// @param _buyID The 32 byte ID of the buy order.
3324     /// @param _sellID The 32 byte ID of the sell order.
3325     /// @param _tokens The details of the priority and secondary tokens.
3326     /// @return A struct containing the settlement details.
3327     function calculateSettlementDetails(
3328         bytes32 _buyID,
3329         bytes32 _sellID,
3330         TokenPair memory _tokens
3331     ) private view returns (SettlementDetails memory) {
3332 
3333         // Calculate the mid-price (using numerator and denominator to not loose
3334         // precision).
3335         Fraction memory midPrice = Fraction(orderDetails[_buyID].price.add(orderDetails[_sellID].price), 2);
3336 
3337         // Calculate the lower of the two max volumes of each trader
3338         uint256 commonVolume = Math.min256(orderDetails[_buyID].volume, orderDetails[_sellID].volume);
3339 
3340         uint256 priorityTokenVolume = joinFraction(
3341             commonVolume.mul(midPrice.numerator),
3342             midPrice.denominator,
3343             int16(_tokens.priorityToken.decimals) - PRICE_OFFSET - VOLUME_OFFSET
3344         );
3345         uint256 secondaryTokenVolume = joinFraction(
3346             commonVolume,
3347             1,
3348             int16(_tokens.secondaryToken.decimals) - VOLUME_OFFSET
3349         );
3350 
3351         // Calculate darknode fees
3352         ValueWithFees memory priorityVwF = subtractDarknodeFee(priorityTokenVolume);
3353         ValueWithFees memory secondaryVwF = subtractDarknodeFee(secondaryTokenVolume);
3354 
3355         return SettlementDetails({
3356             leftVolume: priorityVwF.value,
3357             rightVolume: secondaryVwF.value,
3358             leftTokenFee: priorityVwF.fees,
3359             rightTokenFee: secondaryVwF.fees,
3360             leftTokenAddress: _tokens.priorityToken.addr,
3361             rightTokenAddress: _tokens.secondaryToken.addr
3362         });
3363     }
3364 
3365     /// @notice Calculates the fees to be transferred for an atomic swap.
3366     ///
3367     /// @param _buyID The 32 byte ID of the buy order.
3368     /// @param _sellID The 32 byte ID of the sell order.
3369     /// @param _tokens The details of the priority and secondary tokens.
3370     /// @return A struct containing the fee details.
3371     function calculateAtomicFees(
3372         bytes32 _buyID,
3373         bytes32 _sellID,
3374         TokenPair memory _tokens
3375     ) private view returns (SettlementDetails memory) {
3376 
3377         // Calculate the mid-price (using numerator and denominator to not loose
3378         // precision).
3379         Fraction memory midPrice = Fraction(orderDetails[_buyID].price.add(orderDetails[_sellID].price), 2);
3380 
3381         // Calculate the lower of the two max volumes of each trader
3382         uint256 commonVolume = Math.min256(orderDetails[_buyID].volume, orderDetails[_sellID].volume);
3383 
3384         if (isEthereumBased(_tokens.secondaryToken.addr)) {
3385             uint256 secondaryTokenVolume = joinFraction(
3386                 commonVolume,
3387                 1,
3388                 int16(_tokens.secondaryToken.decimals) - VOLUME_OFFSET
3389             );
3390 
3391             // Calculate darknode fees
3392             ValueWithFees memory secondaryVwF = subtractDarknodeFee(secondaryTokenVolume);
3393 
3394             return SettlementDetails({
3395                 leftVolume: 0,
3396                 rightVolume: 0,
3397                 leftTokenFee: secondaryVwF.fees,
3398                 rightTokenFee: secondaryVwF.fees,
3399                 leftTokenAddress: _tokens.secondaryToken.addr,
3400                 rightTokenAddress: _tokens.secondaryToken.addr
3401             });
3402         } else if (isEthereumBased(_tokens.priorityToken.addr)) {
3403             uint256 priorityTokenVolume = joinFraction(
3404                 commonVolume.mul(midPrice.numerator),
3405                 midPrice.denominator,
3406                 int16(_tokens.priorityToken.decimals) - PRICE_OFFSET - VOLUME_OFFSET
3407             );
3408 
3409             // Calculate darknode fees
3410             ValueWithFees memory priorityVwF = subtractDarknodeFee(priorityTokenVolume);
3411 
3412             return SettlementDetails({
3413                 leftVolume: 0,
3414                 rightVolume: 0,
3415                 leftTokenFee: priorityVwF.fees,
3416                 rightTokenFee: priorityVwF.fees,
3417                 leftTokenAddress: _tokens.priorityToken.addr,
3418                 rightTokenAddress: _tokens.priorityToken.addr
3419             });
3420         } else {
3421             // Currently, at least one token must be Ethereum-based.
3422             // This will be implemented in the future.
3423             revert("non-eth atomic swaps are not supported");
3424         }
3425     }
3426 
3427     /// @notice Order parity is set by the order tokens are listed. This returns
3428     /// whether an order is a buy or a sell.
3429     /// @return true if _orderID is a buy order.
3430     function isBuyOrder(bytes32 _orderID) private view returns (bool) {
3431         uint64 tokens = orderDetails[_orderID].tokens;
3432         uint32 firstToken = uint32(tokens >> 32);
3433         uint32 secondaryToken = uint32(tokens);
3434         return (firstToken < secondaryToken);
3435     }
3436 
3437     /// @return (value - fee, fee) where fee is 0.2% of value
3438     function subtractDarknodeFee(uint256 _value) private pure returns (ValueWithFees memory) {
3439         uint256 newValue = (_value.mul(DARKNODE_FEES_DENOMINATOR - DARKNODE_FEES_NUMERATOR)) / DARKNODE_FEES_DENOMINATOR;
3440         return ValueWithFees(newValue, _value.sub(newValue));
3441     }
3442 
3443     /// @notice Gets the order details of the priority and secondary token from
3444     /// the RenExTokens contract and returns them as a single struct.
3445     ///
3446     /// @param _tokens The 64-bit combined token identifiers.
3447     /// @return A TokenPair struct containing two TokenDetails structs.
3448     function getTokenDetails(uint64 _tokens) private view returns (TokenPair memory) {
3449         (
3450             address priorityAddress,
3451             uint8 priorityDecimals,
3452             bool priorityRegistered
3453         ) = renExTokensContract.tokens(uint32(_tokens >> 32));
3454 
3455         (
3456             address secondaryAddress,
3457             uint8 secondaryDecimals,
3458             bool secondaryRegistered
3459         ) = renExTokensContract.tokens(uint32(_tokens));
3460 
3461         return TokenPair({
3462             priorityToken: RenExTokens.TokenDetails(priorityAddress, priorityDecimals, priorityRegistered),
3463             secondaryToken: RenExTokens.TokenDetails(secondaryAddress, secondaryDecimals, secondaryRegistered)
3464         });
3465     }
3466 
3467     /// @return true if _tokenAddress is 0x0, representing a token that is not
3468     /// on Ethereum
3469     function isEthereumBased(address _tokenAddress) private pure returns (bool) {
3470         return (_tokenAddress != 0x0);
3471     }
3472 
3473     /// @notice Computes (_numerator / _denominator) * 10 ** _scale
3474     function joinFraction(uint256 _numerator, uint256 _denominator, int16 _scale) private pure returns (uint256) {
3475         if (_scale >= 0) {
3476             // Check that (10**_scale) doesn't overflow
3477             assert(_scale <= 77); // log10(2**256) = 77.06
3478             return _numerator.mul(10 ** uint256(_scale)) / _denominator;
3479         } else {
3480             /// @dev If _scale is less than -77, 10**-_scale would overflow.
3481             // For now, -_scale > -24 (when a token has 0 decimals and
3482             // VOLUME_OFFSET and PRICE_OFFSET are each 12). It is unlikely these
3483             // will be increased to add to more than 77.
3484             // assert((-_scale) <= 77); // log10(2**256) = 77.06
3485             return (_numerator / _denominator) / 10 ** uint256(-_scale);
3486         }
3487     }
3488 }