1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
45     // benefit is lost if 'b' is also tested.
46     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47     if (a == 0) {
48       return 0;
49     }
50 
51     c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers, truncating the quotient.
58   */
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     // uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return a / b;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   /**
75   * @dev Adds two numbers, throws on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
78     c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90   address public owner;
91 
92 
93   event OwnershipRenounced(address indexed previousOwner);
94   event OwnershipTransferred(
95     address indexed previousOwner,
96     address indexed newOwner
97   );
98 
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   constructor() public {
105     owner = msg.sender;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116   /**
117    * @dev Allows the current owner to relinquish control of the contract.
118    * @notice Renouncing to ownership will leave the contract without an owner.
119    * It will not be possible to call the functions with the `onlyOwner`
120    * modifier anymore.
121    */
122   function renounceOwnership() public onlyOwner {
123     emit OwnershipRenounced(owner);
124     owner = address(0);
125   }
126 
127   /**
128    * @dev Allows the current owner to transfer control of the contract to a newOwner.
129    * @param _newOwner The address to transfer ownership to.
130    */
131   function transferOwnership(address _newOwner) public onlyOwner {
132     _transferOwnership(_newOwner);
133   }
134 
135   /**
136    * @dev Transfers control of the contract to a newOwner.
137    * @param _newOwner The address to transfer ownership to.
138    */
139   function _transferOwnership(address _newOwner) internal {
140     require(_newOwner != address(0));
141     emit OwnershipTransferred(owner, _newOwner);
142     owner = _newOwner;
143   }
144 }
145 
146 /**
147  * @title Basic token
148  * @dev Basic version of StandardToken, with no allowances.
149  */
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   uint256 totalSupply_;
156 
157   /**
158   * @dev Total number of tokens in existence
159   */
160   function totalSupply() public view returns (uint256) {
161     return totalSupply_;
162   }
163 
164   /**
165   * @dev Transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171     require(_value <= balances[msg.sender]);
172 
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     emit Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256) {
185     return balances[_owner];
186   }
187 
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
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(
209     address _from,
210     address _to,
211     uint256 _value
212   )
213     public
214     returns (bool)
215   {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     emit Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     emit Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(
249     address _owner,
250     address _spender
251    )
252     public
253     view
254     returns (uint256)
255   {
256     return allowed[_owner][_spender];
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _addedValue The amount of tokens to increase the allowance by.
267    */
268   function increaseApproval(
269     address _spender,
270     uint256 _addedValue
271   )
272     public
273     returns (bool)
274   {
275     allowed[msg.sender][_spender] = (
276       allowed[msg.sender][_spender].add(_addedValue));
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281   /**
282    * @dev Decrease the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint256 _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint256 oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 /**
310  * @title Pausable
311  * @dev Base contract which allows children to implement an emergency stop mechanism.
312  */
313 contract Pausable is Ownable {
314   event Pause();
315   event Unpause();
316 
317   bool public paused = false;
318 
319 
320   /**
321    * @dev Modifier to make a function callable only when the contract is not paused.
322    */
323   modifier whenNotPaused() {
324     require(!paused);
325     _;
326   }
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is paused.
330    */
331   modifier whenPaused() {
332     require(paused);
333     _;
334   }
335 
336   /**
337    * @dev called by the owner to pause, triggers stopped state
338    */
339   function pause() onlyOwner whenNotPaused public {
340     paused = true;
341     emit Pause();
342   }
343 
344   /**
345    * @dev called by the owner to unpause, returns to normal state
346    */
347   function unpause() onlyOwner whenPaused public {
348     paused = false;
349     emit Unpause();
350   }
351 }
352 
353 /**
354  * @title Pausable token
355  * @dev StandardToken modified with pausable transfers.
356  **/
357 contract PausableToken is StandardToken, Pausable {
358 
359   function transfer(
360     address _to,
361     uint256 _value
362   )
363     public
364     whenNotPaused
365     returns (bool)
366   {
367     return super.transfer(_to, _value);
368   }
369 
370   function transferFrom(
371     address _from,
372     address _to,
373     uint256 _value
374   )
375     public
376     whenNotPaused
377     returns (bool)
378   {
379     return super.transferFrom(_from, _to, _value);
380   }
381 
382   function approve(
383     address _spender,
384     uint256 _value
385   )
386     public
387     whenNotPaused
388     returns (bool)
389   {
390     return super.approve(_spender, _value);
391   }
392 
393   function increaseApproval(
394     address _spender,
395     uint _addedValue
396   )
397     public
398     whenNotPaused
399     returns (bool success)
400   {
401     return super.increaseApproval(_spender, _addedValue);
402   }
403 
404   function decreaseApproval(
405     address _spender,
406     uint _subtractedValue
407   )
408     public
409     whenNotPaused
410     returns (bool success)
411   {
412     return super.decreaseApproval(_spender, _subtractedValue);
413   }
414 }
415 
416 /**
417  * @title Burnable Token
418  * @dev Token that can be irreversibly burned (destroyed).
419  */
420 contract BurnableToken is BasicToken {
421 
422   event Burn(address indexed burner, uint256 value);
423 
424   /**
425    * @dev Burns a specific amount of tokens.
426    * @param _value The amount of token to be burned.
427    */
428   function burn(uint256 _value) public {
429     _burn(msg.sender, _value);
430   }
431 
432   function _burn(address _who, uint256 _value) internal {
433     require(_value <= balances[_who]);
434     // no need to require value <= totalSupply, since that would imply the
435     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
436 
437     balances[_who] = balances[_who].sub(_value);
438     totalSupply_ = totalSupply_.sub(_value);
439     emit Burn(_who, _value);
440     emit Transfer(_who, address(0), _value);
441   }
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
470  * @notice LinkedList is a library for a circular double linked list.
471  */
472 library LinkedList {
473 
474     /*
475     * @notice A permanent NULL node (0x0) in the circular double linked list.
476     * NULL.next is the head, and NULL.previous is the tail.
477     */
478     address public constant NULL = 0x0;
479 
480     /**
481     * @notice A node points to the node before it, and the node after it. If
482     * node.previous = NULL, then the node is the head of the list. If
483     * node.next = NULL, then the node is the tail of the list.
484     */
485     struct Node {
486         bool inList;
487         address previous;
488         address next;
489     }
490 
491     /**
492     * @notice LinkedList uses a mapping from address to nodes. Each address
493     * uniquely identifies a node, and in this way they are used like pointers.
494     */
495     struct List {
496         mapping (address => Node) list;
497     }
498 
499     /**
500     * @notice Insert a new node before an existing node.
501     *
502     * @param self The list being used.
503     * @param target The existing node in the list.
504     * @param newNode The next node to insert before the target.
505     */
506     function insertBefore(List storage self, address target, address newNode) internal {
507         require(!isInList(self, newNode), "already in list");
508         require(isInList(self, target) || target == NULL, "not in list");
509 
510         // It is expected that this value is sometimes NULL.
511         address prev = self.list[target].previous;
512 
513         self.list[newNode].next = target;
514         self.list[newNode].previous = prev;
515         self.list[target].previous = newNode;
516         self.list[prev].next = newNode;
517 
518         self.list[newNode].inList = true;
519     }
520 
521     /**
522     * @notice Insert a new node after an existing node.
523     *
524     * @param self The list being used.
525     * @param target The existing node in the list.
526     * @param newNode The next node to insert after the target.
527     */
528     function insertAfter(List storage self, address target, address newNode) internal {
529         require(!isInList(self, newNode), "already in list");
530         require(isInList(self, target) || target == NULL, "not in list");
531 
532         // It is expected that this value is sometimes NULL.
533         address n = self.list[target].next;
534 
535         self.list[newNode].previous = target;
536         self.list[newNode].next = n;
537         self.list[target].next = newNode;
538         self.list[n].previous = newNode;
539 
540         self.list[newNode].inList = true;
541     }
542 
543     /**
544     * @notice Remove a node from the list, and fix the previous and next
545     * pointers that are pointing to the removed node. Removing anode that is not
546     * in the list will do nothing.
547     *
548     * @param self The list being using.
549     * @param node The node in the list to be removed.
550     */
551     function remove(List storage self, address node) internal {
552         require(isInList(self, node), "not in list");
553         if (node == NULL) {
554             return;
555         }
556         address p = self.list[node].previous;
557         address n = self.list[node].next;
558 
559         self.list[p].next = n;
560         self.list[n].previous = p;
561 
562         // Deleting the node should set this value to false, but we set it here for
563         // explicitness.
564         self.list[node].inList = false;
565         delete self.list[node];
566     }
567 
568     /**
569     * @notice Insert a node at the beginning of the list.
570     *
571     * @param self The list being used.
572     * @param node The node to insert at the beginning of the list.
573     */
574     function prepend(List storage self, address node) internal {
575         // isInList(node) is checked in insertBefore
576 
577         insertBefore(self, begin(self), node);
578     }
579 
580     /**
581     * @notice Insert a node at the end of the list.
582     *
583     * @param self The list being used.
584     * @param node The node to insert at the end of the list.
585     */
586     function append(List storage self, address node) internal {
587         // isInList(node) is checked in insertBefore
588 
589         insertAfter(self, end(self), node);
590     }
591 
592     function swap(List storage self, address left, address right) internal {
593         // isInList(left) and isInList(right) are checked in remove
594 
595         address previousRight = self.list[right].previous;
596         remove(self, right);
597         insertAfter(self, left, right);
598         remove(self, left);
599         insertAfter(self, previousRight, left);
600     }
601 
602     function isInList(List storage self, address node) internal view returns (bool) {
603         return self.list[node].inList;
604     }
605 
606     /**
607     * @notice Get the node at the beginning of a double linked list.
608     *
609     * @param self The list being used.
610     *
611     * @return A address identifying the node at the beginning of the double
612     * linked list.
613     */
614     function begin(List storage self) internal view returns (address) {
615         return self.list[NULL].next;
616     }
617 
618     /**
619     * @notice Get the node at the end of a double linked list.
620     *
621     * @param self The list being used.
622     *
623     * @return A address identifying the node at the end of the double linked
624     * list.
625     */
626     function end(List storage self) internal view returns (address) {
627         return self.list[NULL].previous;
628     }
629 
630     function next(List storage self, address node) internal view returns (address) {
631         require(isInList(self, node), "not in list");
632         return self.list[node].next;
633     }
634 
635     function previous(List storage self, address node) internal view returns (address) {
636         require(isInList(self, node), "not in list");
637         return self.list[node].previous;
638     }
639 
640 }
641 
642 /// @notice This contract stores data and funds for the DarknodeRegistry
643 /// contract. The data / fund logic and storage have been separated to improve
644 /// upgradability.
645 contract DarknodeRegistryStore is Ownable {
646     string public VERSION; // Passed in as a constructor parameter.
647 
648     /// @notice Darknodes are stored in the darknode struct. The owner is the
649     /// address that registered the darknode, the bond is the amount of REN that
650     /// was transferred during registration, and the public key is the
651     /// encryption key that should be used when sending sensitive information to
652     /// the darknode.
653     struct Darknode {
654         // The owner of a Darknode is the address that called the register
655         // function. The owner is the only address that is allowed to
656         // deregister the Darknode, unless the Darknode is slashed for
657         // malicious behavior.
658         address owner;
659 
660         // The bond is the amount of REN submitted as a bond by the Darknode.
661         // This amount is reduced when the Darknode is slashed for malicious
662         // behavior.
663         uint256 bond;
664 
665         // The block number at which the Darknode is considered registered.
666         uint256 registeredAt;
667 
668         // The block number at which the Darknode is considered deregistered.
669         uint256 deregisteredAt;
670 
671         // The public key used by this Darknode for encrypting sensitive data
672         // off chain. It is assumed that the Darknode has access to the
673         // respective private key, and that there is an agreement on the format
674         // of the public key.
675         bytes publicKey;
676     }
677 
678     /// Registry data.
679     mapping(address => Darknode) private darknodeRegistry;
680     LinkedList.List private darknodes;
681 
682     // RepublicToken.
683     RepublicToken public ren;
684 
685     /// @notice The contract constructor.
686     ///
687     /// @param _VERSION A string defining the contract version.
688     /// @param _ren The address of the RepublicToken contract.
689     constructor(
690         string _VERSION,
691         RepublicToken _ren
692     ) public {
693         VERSION = _VERSION;
694         ren = _ren;
695     }
696 
697     /// @notice Instantiates a darknode and appends it to the darknodes
698     /// linked-list.
699     ///
700     /// @param _darknodeID The darknode's ID.
701     /// @param _darknodeOwner The darknode's owner's address
702     /// @param _bond The darknode's bond value
703     /// @param _publicKey The darknode's public key
704     /// @param _registeredAt The time stamp when the darknode is registered.
705     /// @param _deregisteredAt The time stamp when the darknode is deregistered.
706     function appendDarknode(
707         address _darknodeID,
708         address _darknodeOwner,
709         uint256 _bond,
710         bytes _publicKey,
711         uint256 _registeredAt,
712         uint256 _deregisteredAt
713     ) external onlyOwner {
714         Darknode memory darknode = Darknode({
715             owner: _darknodeOwner,
716             bond: _bond,
717             publicKey: _publicKey,
718             registeredAt: _registeredAt,
719             deregisteredAt: _deregisteredAt
720         });
721         darknodeRegistry[_darknodeID] = darknode;
722         LinkedList.append(darknodes, _darknodeID);
723     }
724 
725     /// @notice Returns the address of the first darknode in the store
726     function begin() external view onlyOwner returns(address) {
727         return LinkedList.begin(darknodes);
728     }
729 
730     /// @notice Returns the address of the next darknode in the store after the
731     /// given address.
732     function next(address darknodeID) external view onlyOwner returns(address) {
733         return LinkedList.next(darknodes, darknodeID);
734     }
735 
736     /// @notice Removes a darknode from the store and transfers its bond to the
737     /// owner of this contract.
738     function removeDarknode(address darknodeID) external onlyOwner {
739         uint256 bond = darknodeRegistry[darknodeID].bond;
740         delete darknodeRegistry[darknodeID];
741         LinkedList.remove(darknodes, darknodeID);
742         require(ren.transfer(owner, bond), "bond transfer failed");
743     }
744 
745     /// @notice Updates the bond of the darknode. If the bond is being
746     /// decreased, the difference is sent to the owner of this contract.
747     function updateDarknodeBond(address darknodeID, uint256 bond) external onlyOwner {
748         uint256 previousBond = darknodeRegistry[darknodeID].bond;
749         darknodeRegistry[darknodeID].bond = bond;
750         if (previousBond > bond) {
751             require(ren.transfer(owner, previousBond - bond), "cannot transfer bond");
752         }
753     }
754 
755     /// @notice Updates the deregistration timestamp of a darknode.
756     function updateDarknodeDeregisteredAt(address darknodeID, uint256 deregisteredAt) external onlyOwner {
757         darknodeRegistry[darknodeID].deregisteredAt = deregisteredAt;
758     }
759 
760     /// @notice Returns the owner of a given darknode.
761     function darknodeOwner(address darknodeID) external view onlyOwner returns (address) {
762         return darknodeRegistry[darknodeID].owner;
763     }
764 
765     /// @notice Returns the bond of a given darknode.
766     function darknodeBond(address darknodeID) external view onlyOwner returns (uint256) {
767         return darknodeRegistry[darknodeID].bond;
768     }
769 
770     /// @notice Returns the registration time of a given darknode.
771     function darknodeRegisteredAt(address darknodeID) external view onlyOwner returns (uint256) {
772         return darknodeRegistry[darknodeID].registeredAt;
773     }
774 
775     /// @notice Returns the deregistration time of a given darknode.
776     function darknodeDeregisteredAt(address darknodeID) external view onlyOwner returns (uint256) {
777         return darknodeRegistry[darknodeID].deregisteredAt;
778     }
779 
780     /// @notice Returns the encryption public key of a given darknode.
781     function darknodePublicKey(address darknodeID) external view onlyOwner returns (bytes) {
782         return darknodeRegistry[darknodeID].publicKey;
783     }
784 }
785 
786 /// @notice DarknodeRegistry is responsible for the registration and
787 /// deregistration of Darknodes.
788 contract DarknodeRegistry is Ownable {
789     string public VERSION; // Passed in as a constructor parameter.
790 
791     /// @notice Darknode pods are shuffled after a fixed number of blocks.
792     /// An Epoch stores an epoch hash used as an (insecure) RNG seed, and the
793     /// blocknumber which restricts when the next epoch can be called.
794     struct Epoch {
795         uint256 epochhash;
796         uint256 blocknumber;
797     }
798 
799     uint256 public numDarknodes;
800     uint256 public numDarknodesNextEpoch;
801     uint256 public numDarknodesPreviousEpoch;
802 
803     /// Variables used to parameterize behavior.
804     uint256 public minimumBond;
805     uint256 public minimumPodSize;
806     uint256 public minimumEpochInterval;
807     address public slasher;
808 
809     /// When one of the above variables is modified, it is only updated when the
810     /// next epoch is called. These variables store the values for the next epoch.
811     uint256 public nextMinimumBond;
812     uint256 public nextMinimumPodSize;
813     uint256 public nextMinimumEpochInterval;
814     address public nextSlasher;
815 
816     /// The current and previous epoch
817     Epoch public currentEpoch;
818     Epoch public previousEpoch;
819 
820     /// Republic ERC20 token contract used to transfer bonds.
821     RepublicToken public ren;
822 
823     /// Darknode Registry Store is the storage contract for darknodes.
824     DarknodeRegistryStore public store;
825 
826     /// @notice Emitted when a darknode is registered.
827     /// @param _darknodeID The darknode ID that was registered.
828     /// @param _bond The amount of REN that was transferred as bond.
829     event LogDarknodeRegistered(address _darknodeID, uint256 _bond);
830 
831     /// @notice Emitted when a darknode is deregistered.
832     /// @param _darknodeID The darknode ID that was deregistered.
833     event LogDarknodeDeregistered(address _darknodeID);
834 
835     /// @notice Emitted when a refund has been made.
836     /// @param _owner The address that was refunded.
837     /// @param _amount The amount of REN that was refunded.
838     event LogDarknodeOwnerRefunded(address _owner, uint256 _amount);
839 
840     /// @notice Emitted when a new epoch has begun.
841     event LogNewEpoch();
842 
843     /// @notice Emitted when a constructor parameter has been updated.
844     event LogMinimumBondUpdated(uint256 previousMinimumBond, uint256 nextMinimumBond);
845     event LogMinimumPodSizeUpdated(uint256 previousMinimumPodSize, uint256 nextMinimumPodSize);
846     event LogMinimumEpochIntervalUpdated(uint256 previousMinimumEpochInterval, uint256 nextMinimumEpochInterval);
847     event LogSlasherUpdated(address previousSlasher, address nextSlasher);
848 
849     /// @notice Only allow the owner that registered the darknode to pass.
850     modifier onlyDarknodeOwner(address _darknodeID) {
851         require(store.darknodeOwner(_darknodeID) == msg.sender, "must be darknode owner");
852         _;
853     }
854 
855     /// @notice Only allow unregistered darknodes.
856     modifier onlyRefunded(address _darknodeID) {
857         require(isRefunded(_darknodeID), "must be refunded or never registered");
858         _;
859     }
860 
861     /// @notice Only allow refundable darknodes.
862     modifier onlyRefundable(address _darknodeID) {
863         require(isRefundable(_darknodeID), "must be deregistered for at least one epoch");
864         _;
865     }
866 
867     /// @notice Only allowed registered nodes without a pending deregistration to
868     /// deregister
869     modifier onlyDeregisterable(address _darknodeID) {
870         require(isDeregisterable(_darknodeID), "must be deregisterable");
871         _;
872     }
873 
874     /// @notice Only allow the Slasher contract.
875     modifier onlySlasher() {
876         require(slasher == msg.sender, "must be slasher");
877         _;
878     }
879 
880     /// @notice The contract constructor.
881     ///
882     /// @param _VERSION A string defining the contract version.
883     /// @param _renAddress The address of the RepublicToken contract.
884     /// @param _storeAddress The address of the DarknodeRegistryStore contract.
885     /// @param _minimumBond The minimum bond amount that can be submitted by a
886     ///        Darknode.
887     /// @param _minimumPodSize The minimum size of a Darknode pod.
888     /// @param _minimumEpochInterval The minimum number of blocks between
889     ///        epochs.
890     constructor(
891         string _VERSION,
892         RepublicToken _renAddress,
893         DarknodeRegistryStore _storeAddress,
894         uint256 _minimumBond,
895         uint256 _minimumPodSize,
896         uint256 _minimumEpochInterval
897     ) public {
898         VERSION = _VERSION;
899 
900         store = _storeAddress;
901         ren = _renAddress;
902 
903         minimumBond = _minimumBond;
904         nextMinimumBond = minimumBond;
905 
906         minimumPodSize = _minimumPodSize;
907         nextMinimumPodSize = minimumPodSize;
908 
909         minimumEpochInterval = _minimumEpochInterval;
910         nextMinimumEpochInterval = minimumEpochInterval;
911 
912         currentEpoch = Epoch({
913             epochhash: uint256(blockhash(block.number - 1)),
914             blocknumber: block.number
915         });
916         numDarknodes = 0;
917         numDarknodesNextEpoch = 0;
918         numDarknodesPreviousEpoch = 0;
919     }
920 
921     /// @notice Register a darknode and transfer the bond to this contract. The
922     /// caller must provide a public encryption key for the darknode as well as
923     /// a bond in REN. The bond must be provided as an ERC20 allowance. The dark
924     /// node will remain pending registration until the next epoch. Only after
925     /// this period can the darknode be deregistered. The caller of this method
926     /// will be stored as the owner of the darknode.
927     ///
928     /// @param _darknodeID The darknode ID that will be registered.
929     /// @param _publicKey The public key of the darknode. It is stored to allow
930     ///        other darknodes and traders to encrypt messages to the trader.
931     /// @param _bond The bond that will be paid. It must be greater than, or
932     ///        equal to, the minimum bond.
933     function register(address _darknodeID, bytes _publicKey, uint256 _bond) external onlyRefunded(_darknodeID) {
934         // REN allowance
935         require(_bond >= minimumBond, "insufficient bond");
936         // require(ren.allowance(msg.sender, address(this)) >= _bond);
937         require(ren.transferFrom(msg.sender, address(this), _bond), "bond transfer failed");
938         ren.transfer(address(store), _bond);
939 
940         // Flag this darknode for registration
941         store.appendDarknode(
942             _darknodeID,
943             msg.sender,
944             _bond,
945             _publicKey,
946             currentEpoch.blocknumber + minimumEpochInterval,
947             0
948         );
949 
950         numDarknodesNextEpoch += 1;
951 
952         // Emit an event.
953         emit LogDarknodeRegistered(_darknodeID, _bond);
954     }
955 
956     /// @notice Deregister a darknode. The darknode will not be deregistered
957     /// until the end of the epoch. After another epoch, the bond can be
958     /// refunded by calling the refund method.
959     /// @param _darknodeID The darknode ID that will be deregistered. The caller
960     ///        of this method store.darknodeRegisteredAt(_darknodeID) must be
961     //         the owner of this darknode.
962     function deregister(address _darknodeID) external onlyDeregisterable(_darknodeID) onlyDarknodeOwner(_darknodeID) {
963         // Flag the darknode for deregistration
964         store.updateDarknodeDeregisteredAt(_darknodeID, currentEpoch.blocknumber + minimumEpochInterval);
965         numDarknodesNextEpoch -= 1;
966 
967         // Emit an event
968         emit LogDarknodeDeregistered(_darknodeID);
969     }
970 
971     /// @notice Progress the epoch if it is possible to do so. This captures
972     /// the current timestamp and current blockhash and overrides the current
973     /// epoch.
974     function epoch() external {
975         if (previousEpoch.blocknumber == 0) {
976             // The first epoch must be called by the owner of the contract
977             require(msg.sender == owner, "not authorized (first epochs)");
978         }
979 
980         // Require that the epoch interval has passed
981         require(block.number >= currentEpoch.blocknumber + minimumEpochInterval, "epoch interval has not passed");
982         uint256 epochhash = uint256(blockhash(block.number - 1));
983 
984         // Update the epoch hash and timestamp
985         previousEpoch = currentEpoch;
986         currentEpoch = Epoch({
987             epochhash: epochhash,
988             blocknumber: block.number
989         });
990 
991         // Update the registry information
992         numDarknodesPreviousEpoch = numDarknodes;
993         numDarknodes = numDarknodesNextEpoch;
994 
995         // If any update functions have been called, update the values now
996         if (nextMinimumBond != minimumBond) {
997             minimumBond = nextMinimumBond;
998             emit LogMinimumBondUpdated(minimumBond, nextMinimumBond);
999         }
1000         if (nextMinimumPodSize != minimumPodSize) {
1001             minimumPodSize = nextMinimumPodSize;
1002             emit LogMinimumPodSizeUpdated(minimumPodSize, nextMinimumPodSize);
1003         }
1004         if (nextMinimumEpochInterval != minimumEpochInterval) {
1005             minimumEpochInterval = nextMinimumEpochInterval;
1006             emit LogMinimumEpochIntervalUpdated(minimumEpochInterval, nextMinimumEpochInterval);
1007         }
1008         if (nextSlasher != slasher) {
1009             slasher = nextSlasher;
1010             emit LogSlasherUpdated(slasher, nextSlasher);
1011         }
1012 
1013         // Emit an event
1014         emit LogNewEpoch();
1015     }
1016 
1017     /// @notice Allows the contract owner to transfer ownership of the
1018     /// DarknodeRegistryStore.
1019     /// @param _newOwner The address to transfer the ownership to.
1020     function transferStoreOwnership(address _newOwner) external onlyOwner {
1021         store.transferOwnership(_newOwner);
1022     }
1023 
1024     /// @notice Allows the contract owner to update the minimum bond.
1025     /// @param _nextMinimumBond The minimum bond amount that can be submitted by
1026     ///        a darknode.
1027     function updateMinimumBond(uint256 _nextMinimumBond) external onlyOwner {
1028         // Will be updated next epoch
1029         nextMinimumBond = _nextMinimumBond;
1030     }
1031 
1032     /// @notice Allows the contract owner to update the minimum pod size.
1033     /// @param _nextMinimumPodSize The minimum size of a pod.
1034     function updateMinimumPodSize(uint256 _nextMinimumPodSize) external onlyOwner {
1035         // Will be updated next epoch
1036         nextMinimumPodSize = _nextMinimumPodSize;
1037     }
1038 
1039     /// @notice Allows the contract owner to update the minimum epoch interval.
1040     /// @param _nextMinimumEpochInterval The minimum number of blocks between epochs.
1041     function updateMinimumEpochInterval(uint256 _nextMinimumEpochInterval) external onlyOwner {
1042         // Will be updated next epoch
1043         nextMinimumEpochInterval = _nextMinimumEpochInterval;
1044     }
1045 
1046     /// @notice Allow the contract owner to update the DarknodeSlasher contract
1047     /// address.
1048     /// @param _slasher The new slasher address.
1049     function updateSlasher(address _slasher) external onlyOwner {
1050         nextSlasher = _slasher;
1051     }
1052 
1053     /// @notice Allow the DarknodeSlasher contract to slash half of a darknode's
1054     /// bond and deregister it. The bond is distributed as follows:
1055     ///   1/2 is kept by the guilty prover
1056     ///   1/8 is rewarded to the first challenger
1057     ///   1/8 is rewarded to the second challenger
1058     ///   1/4 becomes unassigned
1059     /// @param _prover The guilty prover whose bond is being slashed
1060     /// @param _challenger1 The first of the two darknodes who submitted the challenge
1061     /// @param _challenger2 The second of the two darknodes who submitted the challenge
1062     function slash(address _prover, address _challenger1, address _challenger2)
1063         external
1064         onlySlasher
1065     {
1066         uint256 penalty = store.darknodeBond(_prover) / 2;
1067         uint256 reward = penalty / 4;
1068 
1069         // Slash the bond of the failed prover in half
1070         store.updateDarknodeBond(_prover, penalty);
1071 
1072         // If the darknode has not been deregistered then deregister it
1073         if (isDeregisterable(_prover)) {
1074             store.updateDarknodeDeregisteredAt(_prover, currentEpoch.blocknumber + minimumEpochInterval);
1075             numDarknodesNextEpoch -= 1;
1076             emit LogDarknodeDeregistered(_prover);
1077         }
1078 
1079         // Reward the challengers with less than the penalty so that it is not
1080         // worth challenging yourself
1081         ren.transfer(store.darknodeOwner(_challenger1), reward);
1082         ren.transfer(store.darknodeOwner(_challenger2), reward);
1083     }
1084 
1085     /// @notice Refund the bond of a deregistered darknode. This will make the
1086     /// darknode available for registration again. Anyone can call this function
1087     /// but the bond will always be refunded to the darknode owner.
1088     ///
1089     /// @param _darknodeID The darknode ID that will be refunded. The caller
1090     ///        of this method must be the owner of this darknode.
1091     function refund(address _darknodeID) external onlyRefundable(_darknodeID) {
1092         address darknodeOwner = store.darknodeOwner(_darknodeID);
1093 
1094         // Remember the bond amount
1095         uint256 amount = store.darknodeBond(_darknodeID);
1096 
1097         // Erase the darknode from the registry
1098         store.removeDarknode(_darknodeID);
1099 
1100         // Refund the owner by transferring REN
1101         ren.transfer(darknodeOwner, amount);
1102 
1103         // Emit an event.
1104         emit LogDarknodeOwnerRefunded(darknodeOwner, amount);
1105     }
1106 
1107     /// @notice Retrieves the address of the account that registered a darknode.
1108     /// @param _darknodeID The ID of the darknode to retrieve the owner for.
1109     function getDarknodeOwner(address _darknodeID) external view returns (address) {
1110         return store.darknodeOwner(_darknodeID);
1111     }
1112 
1113     /// @notice Retrieves the bond amount of a darknode in 10^-18 REN.
1114     /// @param _darknodeID The ID of the darknode to retrieve the bond for.
1115     function getDarknodeBond(address _darknodeID) external view returns (uint256) {
1116         return store.darknodeBond(_darknodeID);
1117     }
1118 
1119     /// @notice Retrieves the encryption public key of the darknode.
1120     /// @param _darknodeID The ID of the darknode to retrieve the public key for.
1121     function getDarknodePublicKey(address _darknodeID) external view returns (bytes) {
1122         return store.darknodePublicKey(_darknodeID);
1123     }
1124 
1125     /// @notice Retrieves a list of darknodes which are registered for the
1126     /// current epoch.
1127     /// @param _start A darknode ID used as an offset for the list. If _start is
1128     ///        0x0, the first dark node will be used. _start won't be
1129     ///        included it is not registered for the epoch.
1130     /// @param _count The number of darknodes to retrieve starting from _start.
1131     ///        If _count is 0, all of the darknodes from _start are
1132     ///        retrieved. If _count is more than the remaining number of
1133     ///        registered darknodes, the rest of the list will contain
1134     ///        0x0s.
1135     function getDarknodes(address _start, uint256 _count) external view returns (address[]) {
1136         uint256 count = _count;
1137         if (count == 0) {
1138             count = numDarknodes;
1139         }
1140         return getDarknodesFromEpochs(_start, count, false);
1141     }
1142 
1143     /// @notice Retrieves a list of darknodes which were registered for the
1144     /// previous epoch. See `getDarknodes` for the parameter documentation.
1145     function getPreviousDarknodes(address _start, uint256 _count) external view returns (address[]) {
1146         uint256 count = _count;
1147         if (count == 0) {
1148             count = numDarknodesPreviousEpoch;
1149         }
1150         return getDarknodesFromEpochs(_start, count, true);
1151     }
1152 
1153     /// @notice Returns whether a darknode is scheduled to become registered
1154     /// at next epoch.
1155     /// @param _darknodeID The ID of the darknode to return
1156     function isPendingRegistration(address _darknodeID) external view returns (bool) {
1157         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1158         return registeredAt != 0 && registeredAt > currentEpoch.blocknumber;
1159     }
1160 
1161     /// @notice Returns if a darknode is in the pending deregistered state. In
1162     /// this state a darknode is still considered registered.
1163     function isPendingDeregistration(address _darknodeID) external view returns (bool) {
1164         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1165         return deregisteredAt != 0 && deregisteredAt > currentEpoch.blocknumber;
1166     }
1167 
1168     /// @notice Returns if a darknode is in the deregistered state.
1169     function isDeregistered(address _darknodeID) public view returns (bool) {
1170         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1171         return deregisteredAt != 0 && deregisteredAt <= currentEpoch.blocknumber;
1172     }
1173 
1174     /// @notice Returns if a darknode can be deregistered. This is true if the
1175     /// darknodes is in the registered state and has not attempted to
1176     /// deregister yet.
1177     function isDeregisterable(address _darknodeID) public view returns (bool) {
1178         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1179         // The Darknode is currently in the registered state and has not been
1180         // transitioned to the pending deregistration, or deregistered, state
1181         return isRegistered(_darknodeID) && deregisteredAt == 0;
1182     }
1183 
1184     /// @notice Returns if a darknode is in the refunded state. This is true
1185     /// for darknodes that have never been registered, or darknodes that have
1186     /// been deregistered and refunded.
1187     function isRefunded(address _darknodeID) public view returns (bool) {
1188         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1189         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1190         return registeredAt == 0 && deregisteredAt == 0;
1191     }
1192 
1193     /// @notice Returns if a darknode is refundable. This is true for darknodes
1194     /// that have been in the deregistered state for one full epoch.
1195     function isRefundable(address _darknodeID) public view returns (bool) {
1196         return isDeregistered(_darknodeID) && store.darknodeDeregisteredAt(_darknodeID) <= previousEpoch.blocknumber;
1197     }
1198 
1199     /// @notice Returns if a darknode is in the registered state.
1200     function isRegistered(address _darknodeID) public view returns (bool) {
1201         return isRegisteredInEpoch(_darknodeID, currentEpoch);
1202     }
1203 
1204     /// @notice Returns if a darknode was in the registered state last epoch.
1205     function isRegisteredInPreviousEpoch(address _darknodeID) public view returns (bool) {
1206         return isRegisteredInEpoch(_darknodeID, previousEpoch);
1207     }
1208 
1209     /// @notice Returns if a darknode was in the registered state for a given
1210     /// epoch.
1211     /// @param _darknodeID The ID of the darknode
1212     /// @param _epoch One of currentEpoch, previousEpoch
1213     function isRegisteredInEpoch(address _darknodeID, Epoch _epoch) private view returns (bool) {
1214         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1215         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1216         bool registered = registeredAt != 0 && registeredAt <= _epoch.blocknumber;
1217         bool notDeregistered = deregisteredAt == 0 || deregisteredAt > _epoch.blocknumber;
1218         // The Darknode has been registered and has not yet been deregistered,
1219         // although it might be pending deregistration
1220         return registered && notDeregistered;
1221     }
1222 
1223     /// @notice Returns a list of darknodes registered for either the current
1224     /// or the previous epoch. See `getDarknodes` for documentation on the
1225     /// parameters `_start` and `_count`.
1226     /// @param _usePreviousEpoch If true, use the previous epoch, otherwise use
1227     ///        the current epoch.
1228     function getDarknodesFromEpochs(address _start, uint256 _count, bool _usePreviousEpoch) private view returns (address[]) {
1229         uint256 count = _count;
1230         if (count == 0) {
1231             count = numDarknodes;
1232         }
1233 
1234         address[] memory nodes = new address[](count);
1235 
1236         // Begin with the first node in the list
1237         uint256 n = 0;
1238         address next = _start;
1239         if (next == 0x0) {
1240             next = store.begin();
1241         }
1242 
1243         // Iterate until all registered Darknodes have been collected
1244         while (n < count) {
1245             if (next == 0x0) {
1246                 break;
1247             }
1248             // Only include Darknodes that are currently registered
1249             bool includeNext;
1250             if (_usePreviousEpoch) {
1251                 includeNext = isRegisteredInPreviousEpoch(next);
1252             } else {
1253                 includeNext = isRegistered(next);
1254             }
1255             if (!includeNext) {
1256                 next = store.next(next);
1257                 continue;
1258             }
1259             nodes[n] = next;
1260             next = store.next(next);
1261             n += 1;
1262         }
1263         return nodes;
1264     }
1265 }
1266 
1267 /**
1268  * @title Math
1269  * @dev Assorted math operations
1270  */
1271 library Math {
1272   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
1273     return a >= b ? a : b;
1274   }
1275 
1276   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
1277     return a < b ? a : b;
1278   }
1279 
1280   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
1281     return a >= b ? a : b;
1282   }
1283 
1284   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
1285     return a < b ? a : b;
1286   }
1287 }
1288 
1289 /// @notice Implements safeTransfer, safeTransferFrom and
1290 /// safeApprove for CompatibleERC20.
1291 ///
1292 /// See https://github.com/ethereum/solidity/issues/4116
1293 ///
1294 /// This library allows interacting with ERC20 tokens that implement any of
1295 /// these interfaces:
1296 ///
1297 /// (1) transfer returns true on success, false on failure
1298 /// (2) transfer returns true on success, reverts on failure
1299 /// (3) transfer returns nothing on success, reverts on failure
1300 ///
1301 /// Additionally, safeTransferFromWithFees will return the final token
1302 /// value received after accounting for token fees.
1303 library CompatibleERC20Functions {
1304     using SafeMath for uint256;
1305 
1306     /// @notice Calls transfer on the token and reverts if the call fails.
1307     function safeTransfer(address token, address to, uint256 amount) internal {
1308         CompatibleERC20(token).transfer(to, amount);
1309         require(previousReturnValue(), "transfer failed");
1310     }
1311 
1312     /// @notice Calls transferFrom on the token and reverts if the call fails.
1313     function safeTransferFrom(address token, address from, address to, uint256 amount) internal {
1314         CompatibleERC20(token).transferFrom(from, to, amount);
1315         require(previousReturnValue(), "transferFrom failed");
1316     }
1317 
1318     /// @notice Calls approve on the token and reverts if the call fails.
1319     function safeApprove(address token, address spender, uint256 amount) internal {
1320         CompatibleERC20(token).approve(spender, amount);
1321         require(previousReturnValue(), "approve failed");
1322     }
1323 
1324     /// @notice Calls transferFrom on the token, reverts if the call fails and
1325     /// returns the value transferred after fees.
1326     function safeTransferFromWithFees(address token, address from, address to, uint256 amount) internal returns (uint256) {
1327         uint256 balancesBefore = CompatibleERC20(token).balanceOf(to);
1328         CompatibleERC20(token).transferFrom(from, to, amount);
1329         require(previousReturnValue(), "transferFrom failed");
1330         uint256 balancesAfter = CompatibleERC20(token).balanceOf(to);
1331         return Math.min256(amount, balancesAfter.sub(balancesBefore));
1332     }
1333 
1334     /// @notice Checks the return value of the previous function. Returns true
1335     /// if the previous function returned 32 non-zero bytes or returned zero
1336     /// bytes.
1337     function previousReturnValue() private pure returns (bool)
1338     {
1339         uint256 returnData = 0;
1340 
1341         assembly { /* solium-disable-line security/no-inline-assembly */
1342             // Switch on the number of bytes returned by the previous call
1343             switch returndatasize
1344 
1345             // 0 bytes: ERC20 of type (3), did not throw
1346             case 0 {
1347                 returnData := 1
1348             }
1349 
1350             // 32 bytes: ERC20 of types (1) or (2)
1351             case 32 {
1352                 // Copy the return data into scratch space
1353                 returndatacopy(0x0, 0x0, 32)
1354 
1355                 // Load  the return data into returnData
1356                 returnData := mload(0x0)
1357             }
1358 
1359             // Other return size: return false
1360             default { }
1361         }
1362 
1363         return returnData != 0;
1364     }
1365 }
1366 
1367 /// @notice ERC20 interface which doesn't specify the return type for transfer,
1368 /// transferFrom and approve.
1369 interface CompatibleERC20 {
1370     // Modified to not return boolean
1371     function transfer(address to, uint256 value) external;
1372     function transferFrom(address from, address to, uint256 value) external;
1373     function approve(address spender, uint256 value) external;
1374 
1375     // Not modifier
1376     function totalSupply() external view returns (uint256);
1377     function balanceOf(address who) external view returns (uint256);
1378     function allowance(address owner, address spender) external view returns (uint256);
1379     event Transfer(address indexed from, address indexed to, uint256 value);
1380     event Approval(address indexed owner, address indexed spender, uint256 value);
1381 }
1382 
1383 /// @notice The DarknodeRewardVault contract is responsible for holding fees
1384 /// for darknodes for settling orders. Fees can be withdrawn to the address of
1385 /// the darknode's operator. Fees can be in ETH or in ERC20 tokens.
1386 /// Docs: https://github.com/republicprotocol/republic-sol/blob/master/docs/02-darknode-reward-vault.md
1387 contract DarknodeRewardVault is Ownable {
1388     using SafeMath for uint256;
1389     using CompatibleERC20Functions for CompatibleERC20;
1390 
1391     string public VERSION; // Passed in as a constructor parameter.
1392 
1393     /// @notice The special address for Ether.
1394     address constant public ETHEREUM = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1395 
1396     DarknodeRegistry public darknodeRegistry;
1397 
1398     mapping(address => mapping(address => uint256)) public darknodeBalances;
1399 
1400     event LogDarknodeRegistryUpdated(DarknodeRegistry previousDarknodeRegistry, DarknodeRegistry nextDarknodeRegistry);
1401 
1402     /// @notice The contract constructor.
1403     ///
1404     /// @param _VERSION A string defining the contract version.
1405     /// @param _darknodeRegistry The DarknodeRegistry contract that is used by
1406     ///        the vault to lookup Darknode owners.
1407     constructor(string _VERSION, DarknodeRegistry _darknodeRegistry) public {
1408         VERSION = _VERSION;
1409         darknodeRegistry = _darknodeRegistry;
1410     }
1411 
1412     function updateDarknodeRegistry(DarknodeRegistry _newDarknodeRegistry) public onlyOwner {
1413         emit LogDarknodeRegistryUpdated(darknodeRegistry, _newDarknodeRegistry);
1414         darknodeRegistry = _newDarknodeRegistry;
1415     }
1416 
1417     /// @notice Deposit fees into the vault for a Darknode. The Darknode
1418     /// registration is not checked (to reduce gas fees); the caller must be
1419     /// careful not to call this function for a Darknode that is not registered
1420     /// otherwise any fees deposited to that Darknode can be withdrawn by a
1421     /// malicious adversary (by registering the Darknode before the honest
1422     /// party and claiming ownership).
1423     ///
1424     /// @param _darknode The address of the Darknode that will receive the
1425     ///        fees.
1426     /// @param _token The address of the ERC20 token being used to pay the fee.
1427     ///        A special address is used for Ether.
1428     /// @param _value The amount of fees in the smallest unit of the token.
1429     function deposit(address _darknode, ERC20 _token, uint256 _value) public payable {
1430         uint256 receivedValue = _value;
1431         if (address(_token) == ETHEREUM) {
1432             require(msg.value == _value, "mismatched ether value");
1433         } else {
1434             require(msg.value == 0, "unexpected ether value");
1435             receivedValue = CompatibleERC20(_token).safeTransferFromWithFees(msg.sender, address(this), _value);
1436         }
1437         darknodeBalances[_darknode][_token] = darknodeBalances[_darknode][_token].add(receivedValue);
1438     }
1439 
1440     /// @notice Withdraw fees earned by a Darknode. The fees will be sent to
1441     /// the owner of the Darknode. If a Darknode is not registered the fees
1442     /// cannot be withdrawn.
1443     ///
1444     /// @param _darknode The address of the Darknode whose fees are being
1445     ///        withdrawn. The owner of this Darknode will receive the fees.
1446     /// @param _token The address of the ERC20 token to withdraw.
1447     function withdraw(address _darknode, ERC20 _token) public {
1448         address darknodeOwner = darknodeRegistry.getDarknodeOwner(address(_darknode));
1449 
1450         require(darknodeOwner != 0x0, "invalid darknode owner");
1451 
1452         uint256 value = darknodeBalances[_darknode][_token];
1453         darknodeBalances[_darknode][_token] = 0;
1454 
1455         if (address(_token) == ETHEREUM) {
1456             darknodeOwner.transfer(value);
1457         } else {
1458             CompatibleERC20(_token).safeTransfer(darknodeOwner, value);
1459         }
1460     }
1461 
1462 }
1463 
1464 /// @notice The BrokerVerifier interface defines the functions that a settlement
1465 /// layer's broker verifier contract must implement.
1466 interface BrokerVerifier {
1467 
1468     /// @notice The function signature that will be called when a trader opens
1469     /// an order.
1470     ///
1471     /// @param _trader The trader requesting the withdrawal.
1472     /// @param _signature The 65-byte signature from the broker.
1473     /// @param _orderID The 32-byte order ID.
1474     function verifyOpenSignature(
1475         address _trader,
1476         bytes _signature,
1477         bytes32 _orderID
1478     ) external returns (bool);
1479 }
1480 
1481 /// @notice The Settlement interface defines the functions that a settlement
1482 /// layer must implement.
1483 /// Docs: https://github.com/republicprotocol/republic-sol/blob/nightly/docs/05-settlement.md
1484 interface Settlement {
1485     function submitOrder(
1486         bytes _details,
1487         uint64 _settlementID,
1488         uint64 _tokens,
1489         uint256 _price,
1490         uint256 _volume,
1491         uint256 _minimumVolume
1492     ) external;
1493 
1494     function submissionGasPriceLimit() external view returns (uint256);
1495 
1496     function settle(
1497         bytes32 _buyID,
1498         bytes32 _sellID
1499     ) external;
1500 
1501     /// @notice orderStatus should return the status of the order, which should
1502     /// be:
1503     ///     0  - Order not seen before
1504     ///     1  - Order details submitted
1505     ///     >1 - Order settled, or settlement no longer possible
1506     function orderStatus(bytes32 _orderID) external view returns (uint8);
1507 }
1508 
1509 /// @notice SettlementRegistry allows a Settlement layer to register the
1510 /// contracts used for match settlement and for broker signature verification.
1511 contract SettlementRegistry is Ownable {
1512     string public VERSION; // Passed in as a constructor parameter.
1513 
1514     struct SettlementDetails {
1515         bool registered;
1516         Settlement settlementContract;
1517         BrokerVerifier brokerVerifierContract;
1518     }
1519 
1520     // Settlement IDs are 64-bit unsigned numbers
1521     mapping(uint64 => SettlementDetails) public settlementDetails;
1522 
1523     // Events
1524     event LogSettlementRegistered(uint64 settlementID, Settlement settlementContract, BrokerVerifier brokerVerifierContract);
1525     event LogSettlementUpdated(uint64 settlementID, Settlement settlementContract, BrokerVerifier brokerVerifierContract);
1526     event LogSettlementDeregistered(uint64 settlementID);
1527 
1528     /// @notice The contract constructor.
1529     ///
1530     /// @param _VERSION A string defining the contract version.
1531     constructor(string _VERSION) public {
1532         VERSION = _VERSION;
1533     }
1534 
1535     /// @notice Returns the settlement contract of a settlement layer.
1536     function settlementRegistration(uint64 _settlementID) external view returns (bool) {
1537         return settlementDetails[_settlementID].registered;
1538     }
1539 
1540     /// @notice Returns the settlement contract of a settlement layer.
1541     function settlementContract(uint64 _settlementID) external view returns (Settlement) {
1542         return settlementDetails[_settlementID].settlementContract;
1543     }
1544 
1545     /// @notice Returns the broker verifier contract of a settlement layer.
1546     function brokerVerifierContract(uint64 _settlementID) external view returns (BrokerVerifier) {
1547         return settlementDetails[_settlementID].brokerVerifierContract;
1548     }
1549 
1550     /// @param _settlementID A unique 64-bit settlement identifier.
1551     /// @param _settlementContract The address to use for settling matches.
1552     /// @param _brokerVerifierContract The decimals to use for verifying
1553     ///        broker signatures.
1554     function registerSettlement(uint64 _settlementID, Settlement _settlementContract, BrokerVerifier _brokerVerifierContract) public onlyOwner {
1555         bool alreadyRegistered = settlementDetails[_settlementID].registered;
1556         
1557         settlementDetails[_settlementID] = SettlementDetails({
1558             registered: true,
1559             settlementContract: _settlementContract,
1560             brokerVerifierContract: _brokerVerifierContract
1561         });
1562 
1563         if (alreadyRegistered) {
1564             emit LogSettlementUpdated(_settlementID, _settlementContract, _brokerVerifierContract);
1565         } else {
1566             emit LogSettlementRegistered(_settlementID, _settlementContract, _brokerVerifierContract);
1567         }
1568     }
1569 
1570     /// @notice Deregisteres a settlement layer, clearing the details.
1571     /// @param _settlementID The unique 64-bit settlement identifier.
1572     function deregisterSettlement(uint64 _settlementID) external onlyOwner {
1573         require(settlementDetails[_settlementID].registered, "not registered");
1574 
1575         delete settlementDetails[_settlementID];
1576 
1577         emit LogSettlementDeregistered(_settlementID);
1578     }
1579 }
1580 
1581 /**
1582  * @title Eliptic curve signature operations
1583  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
1584  * TODO Remove this library once solidity supports passing a signature to ecrecover.
1585  * See https://github.com/ethereum/solidity/issues/864
1586  */
1587 
1588 library ECRecovery {
1589 
1590   /**
1591    * @dev Recover signer address from a message by using their signature
1592    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
1593    * @param sig bytes signature, the signature is generated using web3.eth.sign()
1594    */
1595   function recover(bytes32 hash, bytes sig)
1596     internal
1597     pure
1598     returns (address)
1599   {
1600     bytes32 r;
1601     bytes32 s;
1602     uint8 v;
1603 
1604     // Check the signature length
1605     if (sig.length != 65) {
1606       return (address(0));
1607     }
1608 
1609     // Divide the signature in r, s and v variables
1610     // ecrecover takes the signature parameters, and the only way to get them
1611     // currently is to use assembly.
1612     // solium-disable-next-line security/no-inline-assembly
1613     assembly {
1614       r := mload(add(sig, 32))
1615       s := mload(add(sig, 64))
1616       v := byte(0, mload(add(sig, 96)))
1617     }
1618 
1619     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
1620     if (v < 27) {
1621       v += 27;
1622     }
1623 
1624     // If the version is correct return the signer address
1625     if (v != 27 && v != 28) {
1626       return (address(0));
1627     } else {
1628       // solium-disable-next-line arg-overflow
1629       return ecrecover(hash, v, r, s);
1630     }
1631   }
1632 
1633   /**
1634    * toEthSignedMessageHash
1635    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
1636    * and hash the result
1637    */
1638   function toEthSignedMessageHash(bytes32 hash)
1639     internal
1640     pure
1641     returns (bytes32)
1642   {
1643     // 32 is the length in bytes of hash,
1644     // enforced by the type signature above
1645     return keccak256(
1646       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1647     );
1648   }
1649 }
1650 
1651 library Utils {
1652 
1653     /**
1654      * @notice Converts a number to its string/bytes representation
1655      *
1656      * @param _v the uint to convert
1657      */
1658     function uintToBytes(uint256 _v) internal pure returns (bytes) {
1659         uint256 v = _v;
1660         if (v == 0) {
1661             return "0";
1662         }
1663 
1664         uint256 digits = 0;
1665         uint256 v2 = v;
1666         while (v2 > 0) {
1667             v2 /= 10;
1668             digits += 1;
1669         }
1670 
1671         bytes memory result = new bytes(digits);
1672 
1673         for (uint256 i = 0; i < digits; i++) {
1674             result[digits - i - 1] = bytes1((v % 10) + 48);
1675             v /= 10;
1676         }
1677 
1678         return result;
1679     }
1680 
1681     /**
1682      * @notice Retrieves the address from a signature
1683      *
1684      * @param _hash the message that was signed (any length of bytes)
1685      * @param _signature the signature (65 bytes)
1686      */
1687     function addr(bytes _hash, bytes _signature) internal pure returns (address) {
1688         bytes memory prefix = "\x19Ethereum Signed Message:\n";
1689         bytes memory encoded = abi.encodePacked(prefix, uintToBytes(_hash.length), _hash);
1690         bytes32 prefixedHash = keccak256(encoded);
1691 
1692         return ECRecovery.recover(prefixedHash, _signature);
1693     }
1694 
1695 }
1696 
1697 /// @notice The Orderbook contract stores the state and priority of orders and
1698 /// allows the Darknodes to easily reach consensus. Eventually, this contract
1699 /// will only store a subset of order states, such as cancellation, to improve
1700 /// the throughput of orders.
1701 contract Orderbook is Ownable {
1702     string public VERSION; // Passed in as a constructor parameter.
1703 
1704     /// @notice OrderState enumerates the possible states of an order. All
1705     /// orders default to the Undefined state.
1706     enum OrderState {Undefined, Open, Confirmed, Canceled}
1707 
1708     /// @notice Order stores a subset of the public data associated with an order.
1709     struct Order {
1710         OrderState state;     // State of the order
1711         address trader;       // Trader that owns the order
1712         address confirmer;    // Darknode that confirmed the order in a match
1713         uint64 settlementID;  // The settlement that signed the order opening
1714         uint256 priority;     // Logical time priority of this order
1715         uint256 blockNumber;  // Block number of the most recent state change
1716         bytes32 matchedOrder; // Order confirmed in a match with this order
1717     }
1718 
1719     DarknodeRegistry public darknodeRegistry;
1720     SettlementRegistry public settlementRegistry;
1721 
1722     bytes32[] private orderbook;
1723 
1724     // Order details are exposed through directly accessing this mapping, or
1725     // through the getter functions below for each of the order's fields.
1726     mapping(bytes32 => Order) public orders;
1727 
1728     event LogFeeUpdated(uint256 previousFee, uint256 nextFee);
1729     event LogDarknodeRegistryUpdated(DarknodeRegistry previousDarknodeRegistry, DarknodeRegistry nextDarknodeRegistry);
1730 
1731     /// @notice Only allow registered dark nodes.
1732     modifier onlyDarknode(address _sender) {
1733         require(darknodeRegistry.isRegistered(address(_sender)), "must be registered darknode");
1734         _;
1735     }
1736 
1737     /// @notice The contract constructor.
1738     ///
1739     /// @param _VERSION A string defining the contract version.
1740     /// @param _darknodeRegistry The address of the DarknodeRegistry contract.
1741     /// @param _settlementRegistry The address of the SettlementRegistry
1742     ///        contract.
1743     constructor(
1744         string _VERSION,
1745         DarknodeRegistry _darknodeRegistry,
1746         SettlementRegistry _settlementRegistry
1747     ) public {
1748         VERSION = _VERSION;
1749         darknodeRegistry = _darknodeRegistry;
1750         settlementRegistry = _settlementRegistry;
1751     }
1752 
1753     /// @notice Allows the owner to update the address of the DarknodeRegistry
1754     /// contract.
1755     function updateDarknodeRegistry(DarknodeRegistry _newDarknodeRegistry) external onlyOwner {
1756         emit LogDarknodeRegistryUpdated(darknodeRegistry, _newDarknodeRegistry);
1757         darknodeRegistry = _newDarknodeRegistry;
1758     }
1759 
1760     /// @notice Open an order in the orderbook. The order must be in the
1761     /// Undefined state.
1762     ///
1763     /// @param _signature Signature of the message that defines the trader. The
1764     ///        message is "Republic Protocol: open: {orderId}".
1765     /// @param _orderID The hash of the order.
1766     function openOrder(uint64 _settlementID, bytes _signature, bytes32 _orderID) external {
1767         require(orders[_orderID].state == OrderState.Undefined, "invalid order status");
1768 
1769         address trader = msg.sender;
1770 
1771         // Verify the order signature
1772         require(settlementRegistry.settlementRegistration(_settlementID), "settlement not registered");
1773         BrokerVerifier brokerVerifier = settlementRegistry.brokerVerifierContract(_settlementID);
1774         require(brokerVerifier.verifyOpenSignature(trader, _signature, _orderID), "invalid broker signature");
1775 
1776         orders[_orderID] = Order({
1777             state: OrderState.Open,
1778             trader: trader,
1779             confirmer: 0x0,
1780             settlementID: _settlementID,
1781             priority: orderbook.length + 1,
1782             blockNumber: block.number,
1783             matchedOrder: 0x0
1784         });
1785 
1786         orderbook.push(_orderID);
1787     }
1788 
1789     /// @notice Confirm an order match between orders. The confirmer must be a
1790     /// registered Darknode and the orders must be in the Open state. A
1791     /// malicious confirmation by a Darknode will result in a bond slash of the
1792     /// Darknode.
1793     ///
1794     /// @param _orderID The hash of the order.
1795     /// @param _matchedOrderID The hashes of the matching order.
1796     function confirmOrder(bytes32 _orderID, bytes32 _matchedOrderID) external onlyDarknode(msg.sender) {
1797         require(orders[_orderID].state == OrderState.Open, "invalid order status");
1798         require(orders[_matchedOrderID].state == OrderState.Open, "invalid order status");
1799 
1800         orders[_orderID].state = OrderState.Confirmed;
1801         orders[_orderID].confirmer = msg.sender;
1802         orders[_orderID].matchedOrder = _matchedOrderID;
1803         orders[_orderID].blockNumber = block.number;
1804 
1805         orders[_matchedOrderID].state = OrderState.Confirmed;
1806         orders[_matchedOrderID].confirmer = msg.sender;
1807         orders[_matchedOrderID].matchedOrder = _orderID;
1808         orders[_matchedOrderID].blockNumber = block.number;
1809     }
1810 
1811     /// @notice Cancel an open order in the orderbook. An order can be cancelled
1812     /// by the trader who opened the order, or by the broker verifier contract.
1813     /// This allows the settlement layer to implement their own logic for
1814     /// cancelling orders without trader interaction (e.g. to ban a trader from
1815     /// a specific darkpool, or to use multiple order-matching platforms)
1816     ///
1817     /// @param _orderID The hash of the order.
1818     function cancelOrder(bytes32 _orderID) external {
1819         require(orders[_orderID].state == OrderState.Open, "invalid order state");
1820 
1821         // Require the msg.sender to be the trader or the broker verifier
1822         address brokerVerifier = address(settlementRegistry.brokerVerifierContract(orders[_orderID].settlementID));
1823         require(msg.sender == orders[_orderID].trader || msg.sender == brokerVerifier, "not authorized");
1824 
1825         orders[_orderID].state = OrderState.Canceled;
1826         orders[_orderID].blockNumber = block.number;
1827     }
1828 
1829     /// @notice returns status of the given orderID.
1830     function orderState(bytes32 _orderID) external view returns (OrderState) {
1831         return orders[_orderID].state;
1832     }
1833 
1834     /// @notice returns a list of matched orders to the given orderID.
1835     function orderMatch(bytes32 _orderID) external view returns (bytes32) {
1836         return orders[_orderID].matchedOrder;
1837     }
1838 
1839     /// @notice returns the priority of the given orderID.
1840     /// The priority is the index of the order in the orderbook.
1841     function orderPriority(bytes32 _orderID) external view returns (uint256) {
1842         return orders[_orderID].priority;
1843     }
1844 
1845     /// @notice returns the trader of the given orderID.
1846     /// Trader is the one who signs the message and does the actual trading.
1847     function orderTrader(bytes32 _orderID) external view returns (address) {
1848         return orders[_orderID].trader;
1849     }
1850 
1851     /// @notice returns the darknode address which confirms the given orderID.
1852     function orderConfirmer(bytes32 _orderID) external view returns (address) {
1853         return orders[_orderID].confirmer;
1854     }
1855 
1856     /// @notice returns the block number when the order being last modified.
1857     function orderBlockNumber(bytes32 _orderID) external view returns (uint256) {
1858         return orders[_orderID].blockNumber;
1859     }
1860 
1861     /// @notice returns the block depth of the orderId
1862     function orderDepth(bytes32 _orderID) external view returns (uint256) {
1863         if (orders[_orderID].blockNumber == 0) {
1864             return 0;
1865         }
1866         return (block.number - orders[_orderID].blockNumber);
1867     }
1868 
1869     /// @notice returns the number of orders in the orderbook
1870     function ordersCount() external view returns (uint256) {
1871         return orderbook.length;
1872     }
1873 
1874     /// @notice returns order details of the orders starting from the offset.
1875     function getOrders(uint256 _offset, uint256 _limit) external view returns (bytes32[], address[], uint8[]) {
1876         if (_offset >= orderbook.length) {
1877             return;
1878         }
1879 
1880         // If the provided limit is more than the number of orders after the offset,
1881         // decrease the limit
1882         uint256 limit = _limit;
1883         if (_offset + limit > orderbook.length) {
1884             limit = orderbook.length - _offset;
1885         }
1886 
1887         bytes32[] memory orderIDs = new bytes32[](limit);
1888         address[] memory traderAddresses = new address[](limit);
1889         uint8[] memory states = new uint8[](limit);
1890 
1891         for (uint256 i = 0; i < limit; i++) {
1892             bytes32 order = orderbook[i + _offset];
1893             orderIDs[i] = order;
1894             traderAddresses[i] = orders[order].trader;
1895             states[i] = uint8(orders[order].state);
1896         }
1897 
1898         return (orderIDs, traderAddresses, states);
1899     }
1900 }
1901 
1902 /// @notice A library for calculating and verifying order match details
1903 library SettlementUtils {
1904 
1905     struct OrderDetails {
1906         uint64 settlementID;
1907         uint64 tokens;
1908         uint256 price;
1909         uint256 volume;
1910         uint256 minimumVolume;
1911     }
1912 
1913     /// @notice Calculates the ID of the order.
1914     /// @param details Order details that are not required for settlement
1915     ///        execution. They are combined as a single byte array.
1916     /// @param order The order details required for settlement execution.
1917     function hashOrder(bytes details, OrderDetails memory order) internal pure returns (bytes32) {
1918         return keccak256(
1919             abi.encodePacked(
1920                 details,
1921                 order.settlementID,
1922                 order.tokens,
1923                 order.price,
1924                 order.volume,
1925                 order.minimumVolume
1926             )
1927         );
1928     }
1929 
1930     /// @notice Verifies that two orders match when considering the tokens,
1931     /// price, volumes / minimum volumes and settlement IDs. verifyMatchDetails is used
1932     /// my the DarknodeSlasher to verify challenges. Settlement layers may also
1933     /// use this function.
1934     /// @dev When verifying two orders for settlement, you should also:
1935     ///   1) verify the orders have been confirmed together
1936     ///   2) verify the orders' traders are distinct
1937     /// @param _buy The buy order details.
1938     /// @param _sell The sell order details.
1939     function verifyMatchDetails(OrderDetails memory _buy, OrderDetails memory _sell) internal pure returns (bool) {
1940 
1941         // Buy and sell tokens should match
1942         if (!verifyTokens(_buy.tokens, _sell.tokens)) {
1943             return false;
1944         }
1945 
1946         // Buy price should be greater than sell price
1947         if (_buy.price < _sell.price) {
1948             return false;
1949         }
1950 
1951         // // Buy volume should be greater than sell minimum volume
1952         if (_buy.volume < _sell.minimumVolume) {
1953             return false;
1954         }
1955 
1956         // Sell volume should be greater than buy minimum volume
1957         if (_sell.volume < _buy.minimumVolume) {
1958             return false;
1959         }
1960 
1961         // Require that the orders were submitted to the same settlement layer
1962         if (_buy.settlementID != _sell.settlementID) {
1963             return false;
1964         }
1965 
1966         return true;
1967     }
1968 
1969     /// @notice Verifies that two token requirements can be matched and that the
1970     /// tokens are formatted correctly.
1971     /// @param _buyTokens The buy token details.
1972     /// @param _sellToken The sell token details.
1973     function verifyTokens(uint64 _buyTokens, uint64 _sellToken) internal pure returns (bool) {
1974         return ((
1975                 uint32(_buyTokens) == uint32(_sellToken >> 32)) && (
1976                 uint32(_sellToken) == uint32(_buyTokens >> 32)) && (
1977                 uint32(_buyTokens >> 32) <= uint32(_buyTokens))
1978         );
1979     }
1980 }
1981 
1982 /// @notice RenExTokens is a registry of tokens that can be traded on RenEx.
1983 contract RenExTokens is Ownable {
1984     string public VERSION; // Passed in as a constructor parameter.
1985 
1986     struct TokenDetails {
1987         address addr;
1988         uint8 decimals;
1989         bool registered;
1990     }
1991 
1992     // Storage
1993     mapping(uint32 => TokenDetails) public tokens;
1994     mapping(uint32 => bool) private detailsSubmitted;
1995 
1996     // Events
1997     event LogTokenRegistered(uint32 tokenCode, address tokenAddress, uint8 tokenDecimals);
1998     event LogTokenDeregistered(uint32 tokenCode);
1999 
2000     /// @notice The contract constructor.
2001     ///
2002     /// @param _VERSION A string defining the contract version.
2003     constructor(string _VERSION) public {
2004         VERSION = _VERSION;
2005     }
2006 
2007     /// @notice Allows the owner to register and the details for a token.
2008     /// Once details have been submitted, they cannot be overwritten.
2009     /// To re-register the same token with different details (e.g. if the address
2010     /// has changed), a different token identifier should be used and the
2011     /// previous token identifier should be deregistered.
2012     /// If a token is not Ethereum-based, the address will be set to 0x0.
2013     ///
2014     /// @param _tokenCode A unique 32-bit token identifier.
2015     /// @param _tokenAddress The address of the token.
2016     /// @param _tokenDecimals The decimals to use for the token.
2017     function registerToken(uint32 _tokenCode, address _tokenAddress, uint8 _tokenDecimals) public onlyOwner {
2018         require(!tokens[_tokenCode].registered, "already registered");
2019 
2020         // If a token is being re-registered, the same details must be provided.
2021         if (detailsSubmitted[_tokenCode]) {
2022             require(tokens[_tokenCode].addr == _tokenAddress, "different address");
2023             require(tokens[_tokenCode].decimals == _tokenDecimals, "different decimals");
2024         } else {
2025             detailsSubmitted[_tokenCode] = true;
2026         }
2027 
2028         tokens[_tokenCode] = TokenDetails({
2029             addr: _tokenAddress,
2030             decimals: _tokenDecimals,
2031             registered: true
2032         });
2033 
2034         emit LogTokenRegistered(_tokenCode, _tokenAddress, _tokenDecimals);
2035     }
2036 
2037     /// @notice Sets a token as being deregistered. The details are still stored
2038     /// to prevent the token from being re-registered with different details.
2039     ///
2040     /// @param _tokenCode The unique 32-bit token identifier.
2041     function deregisterToken(uint32 _tokenCode) external onlyOwner {
2042         require(tokens[_tokenCode].registered, "not registered");
2043 
2044         tokens[_tokenCode].registered = false;
2045 
2046         emit LogTokenDeregistered(_tokenCode);
2047     }
2048 }
2049 
2050 /// @notice RenExSettlement implements the Settlement interface. It implements
2051 /// the on-chain settlement for the RenEx settlement layer, and the fee payment
2052 /// for the RenExAtomic settlement layer.
2053 contract RenExSettlement is Ownable {
2054     using SafeMath for uint256;
2055 
2056     string public VERSION; // Passed in as a constructor parameter.
2057 
2058     // This contract handles the settlements with ID 1 and 2.
2059     uint32 constant public RENEX_SETTLEMENT_ID = 1;
2060     uint32 constant public RENEX_ATOMIC_SETTLEMENT_ID = 2;
2061 
2062     // Fees in RenEx are 0.2%. To represent this as integers, it is broken into
2063     // a numerator and denominator.
2064     uint256 constant public DARKNODE_FEES_NUMERATOR = 2;
2065     uint256 constant public DARKNODE_FEES_DENOMINATOR = 1000;
2066 
2067     // Constants used in the price / volume inputs.
2068     int16 constant private PRICE_OFFSET = 12;
2069     int16 constant private VOLUME_OFFSET = 12;
2070 
2071     // Constructor parameters, updatable by the owner
2072     Orderbook public orderbookContract;
2073     RenExTokens public renExTokensContract;
2074     RenExBalances public renExBalancesContract;
2075     address public slasherAddress;
2076     uint256 public submissionGasPriceLimit;
2077 
2078     enum OrderStatus {None, Submitted, Settled, Slashed}
2079 
2080     struct TokenPair {
2081         RenExTokens.TokenDetails priorityToken;
2082         RenExTokens.TokenDetails secondaryToken;
2083     }
2084 
2085     // A uint256 tuple representing a value and an associated fee
2086     struct ValueWithFees {
2087         uint256 value;
2088         uint256 fees;
2089     }
2090 
2091     // A uint256 tuple representing a fraction
2092     struct Fraction {
2093         uint256 numerator;
2094         uint256 denominator;
2095     }
2096 
2097     // We use left and right because the tokens do not always represent the
2098     // priority and secondary tokens.
2099     struct SettlementDetails {
2100         uint256 leftVolume;
2101         uint256 rightVolume;
2102         uint256 leftTokenFee;
2103         uint256 rightTokenFee;
2104         address leftTokenAddress;
2105         address rightTokenAddress;
2106     }
2107 
2108     // Events
2109     event LogOrderbookUpdated(Orderbook previousOrderbook, Orderbook nextOrderbook);
2110     event LogRenExTokensUpdated(RenExTokens previousRenExTokens, RenExTokens nextRenExTokens);
2111     event LogRenExBalancesUpdated(RenExBalances previousRenExBalances, RenExBalances nextRenExBalances);
2112     event LogSubmissionGasPriceLimitUpdated(uint256 previousSubmissionGasPriceLimit, uint256 nextSubmissionGasPriceLimit);
2113     event LogSlasherUpdated(address previousSlasher, address nextSlasher);
2114 
2115     // Order Storage
2116     mapping(bytes32 => SettlementUtils.OrderDetails) public orderDetails;
2117     mapping(bytes32 => address) public orderSubmitter;
2118     mapping(bytes32 => OrderStatus) public orderStatus;
2119 
2120     // Match storage (match details are indexed by [buyID][sellID])
2121     mapping(bytes32 => mapping(bytes32 => uint256)) public matchTimestamp;
2122 
2123     /// @notice Prevents a function from being called with a gas price higher
2124     /// than the specified limit.
2125     ///
2126     /// @param _gasPriceLimit The gas price upper-limit in Wei.
2127     modifier withGasPriceLimit(uint256 _gasPriceLimit) {
2128         require(tx.gasprice <= _gasPriceLimit, "gas price too high");
2129         _;
2130     }
2131 
2132     /// @notice Restricts a function to only being called by the slasher
2133     /// address.
2134     modifier onlySlasher() {
2135         require(msg.sender == slasherAddress, "unauthorized");
2136         _;
2137     }
2138 
2139     /// @notice The contract constructor.
2140     ///
2141     /// @param _VERSION A string defining the contract version.
2142     /// @param _orderbookContract The address of the Orderbook contract.
2143     /// @param _renExBalancesContract The address of the RenExBalances
2144     ///        contract.
2145     /// @param _renExTokensContract The address of the RenExTokens contract.
2146     constructor(
2147         string _VERSION,
2148         Orderbook _orderbookContract,
2149         RenExTokens _renExTokensContract,
2150         RenExBalances _renExBalancesContract,
2151         address _slasherAddress,
2152         uint256 _submissionGasPriceLimit
2153     ) public {
2154         VERSION = _VERSION;
2155         orderbookContract = _orderbookContract;
2156         renExTokensContract = _renExTokensContract;
2157         renExBalancesContract = _renExBalancesContract;
2158         slasherAddress = _slasherAddress;
2159         submissionGasPriceLimit = _submissionGasPriceLimit;
2160     }
2161 
2162     /// @notice The owner of the contract can update the Orderbook address.
2163     /// @param _newOrderbookContract The address of the new Orderbook contract.
2164     function updateOrderbook(Orderbook _newOrderbookContract) external onlyOwner {
2165         emit LogOrderbookUpdated(orderbookContract, _newOrderbookContract);
2166         orderbookContract = _newOrderbookContract;
2167     }
2168 
2169     /// @notice The owner of the contract can update the RenExTokens address.
2170     /// @param _newRenExTokensContract The address of the new RenExTokens
2171     ///       contract.
2172     function updateRenExTokens(RenExTokens _newRenExTokensContract) external onlyOwner {
2173         emit LogRenExTokensUpdated(renExTokensContract, _newRenExTokensContract);
2174         renExTokensContract = _newRenExTokensContract;
2175     }
2176     
2177     /// @notice The owner of the contract can update the RenExBalances address.
2178     /// @param _newRenExBalancesContract The address of the new RenExBalances
2179     ///       contract.
2180     function updateRenExBalances(RenExBalances _newRenExBalancesContract) external onlyOwner {
2181         emit LogRenExBalancesUpdated(renExBalancesContract, _newRenExBalancesContract);
2182         renExBalancesContract = _newRenExBalancesContract;
2183     }
2184 
2185     /// @notice The owner of the contract can update the order submission gas
2186     /// price limit.
2187     /// @param _newSubmissionGasPriceLimit The new gas price limit.
2188     function updateSubmissionGasPriceLimit(uint256 _newSubmissionGasPriceLimit) external onlyOwner {
2189         emit LogSubmissionGasPriceLimitUpdated(submissionGasPriceLimit, _newSubmissionGasPriceLimit);
2190         submissionGasPriceLimit = _newSubmissionGasPriceLimit;
2191     }
2192 
2193     /// @notice The owner of the contract can update the slasher address.
2194     /// @param _newSlasherAddress The new slasher address.
2195     function updateSlasher(address _newSlasherAddress) external onlyOwner {
2196         emit LogSlasherUpdated(slasherAddress, _newSlasherAddress);
2197         slasherAddress = _newSlasherAddress;
2198     }
2199 
2200     /// @notice Stores the details of an order.
2201     ///
2202     /// @param _prefix The miscellaneous details of the order required for
2203     ///        calculating the order id.
2204     /// @param _settlementID The settlement identifier.
2205     /// @param _tokens The encoding of the token pair (buy token is encoded as
2206     ///        the first 32 bytes and sell token is encoded as the last 32
2207     ///        bytes).
2208     /// @param _price The price of the order. Interpreted as the cost for 1
2209     ///        standard unit of the non-priority token, in 1e12 (i.e.
2210     ///        PRICE_OFFSET) units of the priority token).
2211     /// @param _volume The volume of the order. Interpreted as the maximum
2212     ///        number of 1e-12 (i.e. VOLUME_OFFSET) units of the non-priority
2213     ///        token that can be traded by this order.
2214     /// @param _minimumVolume The minimum volume the trader is willing to
2215     ///        accept. Encoded the same as the volume.
2216     function submitOrder(
2217         bytes _prefix,
2218         uint64 _settlementID,
2219         uint64 _tokens,
2220         uint256 _price,
2221         uint256 _volume,
2222         uint256 _minimumVolume
2223     ) external withGasPriceLimit(submissionGasPriceLimit) {
2224 
2225         SettlementUtils.OrderDetails memory order = SettlementUtils.OrderDetails({
2226             settlementID: _settlementID,
2227             tokens: _tokens,
2228             price: _price,
2229             volume: _volume,
2230             minimumVolume: _minimumVolume
2231         });
2232         bytes32 orderID = SettlementUtils.hashOrder(_prefix, order);
2233 
2234         require(orderStatus[orderID] == OrderStatus.None, "order already submitted");
2235         require(orderbookContract.orderState(orderID) == Orderbook.OrderState.Confirmed, "unconfirmed order");
2236 
2237         orderSubmitter[orderID] = msg.sender;
2238         orderStatus[orderID] = OrderStatus.Submitted;
2239         orderDetails[orderID] = order;
2240     }
2241 
2242     /// @notice Settles two orders that are matched. `submitOrder` must have been
2243     /// called for each order before this function is called.
2244     ///
2245     /// @param _buyID The 32 byte ID of the buy order.
2246     /// @param _sellID The 32 byte ID of the sell order.
2247     function settle(bytes32 _buyID, bytes32 _sellID) external {
2248         require(orderStatus[_buyID] == OrderStatus.Submitted, "invalid buy status");
2249         require(orderStatus[_sellID] == OrderStatus.Submitted, "invalid sell status");
2250 
2251         // Check the settlement ID (only have to check for one, since
2252         // `verifyMatchDetails` checks that they are the same)
2253         require(
2254             orderDetails[_buyID].settlementID == RENEX_ATOMIC_SETTLEMENT_ID ||
2255             orderDetails[_buyID].settlementID == RENEX_SETTLEMENT_ID,
2256             "invalid settlement id"
2257         );
2258 
2259         // Verify that the two order details are compatible.
2260         require(SettlementUtils.verifyMatchDetails(orderDetails[_buyID], orderDetails[_sellID]), "incompatible orders");
2261 
2262         // Verify that the two orders have been confirmed to one another.
2263         require(orderbookContract.orderMatch(_buyID) == _sellID, "unconfirmed orders");
2264 
2265         // Retrieve token details.
2266         TokenPair memory tokens = getTokenDetails(orderDetails[_buyID].tokens);
2267 
2268         // Require that the tokens have been registered.
2269         require(tokens.priorityToken.registered, "unregistered priority token");
2270         require(tokens.secondaryToken.registered, "unregistered secondary token");
2271 
2272         address buyer = orderbookContract.orderTrader(_buyID);
2273         address seller = orderbookContract.orderTrader(_sellID);
2274 
2275         require(buyer != seller, "orders from same trader");
2276 
2277         execute(_buyID, _sellID, buyer, seller, tokens);
2278 
2279         /* solium-disable-next-line security/no-block-members */
2280         matchTimestamp[_buyID][_sellID] = now;
2281 
2282         // Store that the orders have been settled.
2283         orderStatus[_buyID] = OrderStatus.Settled;
2284         orderStatus[_sellID] = OrderStatus.Settled;
2285     }
2286 
2287     /// @notice Slashes the bond of a guilty trader. This is called when an
2288     /// atomic swap is not executed successfully.
2289     /// To open an atomic order, a trader must have a balance equivalent to
2290     /// 0.6% of the trade in the Ethereum-based token. 0.2% is always paid in
2291     /// darknode fees when the order is matched. If the remaining amount is
2292     /// is slashed, it is distributed as follows:
2293     ///   1) 0.2% goes to the other trader, covering their fee
2294     ///   2) 0.2% goes to the slasher address
2295     /// Only one order in a match can be slashed.
2296     ///
2297     /// @param _guiltyOrderID The 32 byte ID of the order of the guilty trader.
2298     function slash(bytes32 _guiltyOrderID) external onlySlasher {
2299         require(orderDetails[_guiltyOrderID].settlementID == RENEX_ATOMIC_SETTLEMENT_ID, "slashing non-atomic trade");
2300 
2301         bytes32 innocentOrderID = orderbookContract.orderMatch(_guiltyOrderID);
2302 
2303         require(orderStatus[_guiltyOrderID] == OrderStatus.Settled, "invalid order status");
2304         require(orderStatus[innocentOrderID] == OrderStatus.Settled, "invalid order status");
2305         orderStatus[_guiltyOrderID] = OrderStatus.Slashed;
2306 
2307         (bytes32 buyID, bytes32 sellID) = isBuyOrder(_guiltyOrderID) ?
2308             (_guiltyOrderID, innocentOrderID) : (innocentOrderID, _guiltyOrderID);
2309 
2310         TokenPair memory tokens = getTokenDetails(orderDetails[buyID].tokens);
2311 
2312         SettlementDetails memory settlementDetails = calculateAtomicFees(buyID, sellID, tokens);
2313 
2314         // Transfer the fee amount to the other trader
2315         renExBalancesContract.transferBalanceWithFee(
2316             orderbookContract.orderTrader(_guiltyOrderID),
2317             orderbookContract.orderTrader(innocentOrderID),
2318             settlementDetails.leftTokenAddress,
2319             settlementDetails.leftTokenFee,
2320             0,
2321             0x0
2322         );
2323 
2324         // Transfer the fee amount to the slasher
2325         renExBalancesContract.transferBalanceWithFee(
2326             orderbookContract.orderTrader(_guiltyOrderID),
2327             slasherAddress,
2328             settlementDetails.leftTokenAddress,
2329             settlementDetails.leftTokenFee,
2330             0,
2331             0x0
2332         );
2333     }
2334 
2335     /// @notice Retrieves the settlement details of an order.
2336     /// For atomic swaps, it returns the full volumes, not the settled fees.
2337     ///
2338     /// @param _orderID The order to lookup the details of. Can be the ID of a
2339     ///        buy or a sell order.
2340     /// @return [
2341     ///     a boolean representing whether or not the order has been settled,
2342     ///     a boolean representing whether or not the order is a buy
2343     ///     the 32-byte order ID of the matched order
2344     ///     the volume of the priority token,
2345     ///     the volume of the secondary token,
2346     ///     the fee paid in the priority token,
2347     ///     the fee paid in the secondary token,
2348     ///     the token code of the priority token,
2349     ///     the token code of the secondary token
2350     /// ]
2351     function getMatchDetails(bytes32 _orderID)
2352     external view returns (
2353         bool settled,
2354         bool orderIsBuy,
2355         bytes32 matchedID,
2356         uint256 priorityVolume,
2357         uint256 secondaryVolume,
2358         uint256 priorityFee,
2359         uint256 secondaryFee,
2360         uint32 priorityToken,
2361         uint32 secondaryToken
2362     ) {
2363         matchedID = orderbookContract.orderMatch(_orderID);
2364 
2365         orderIsBuy = isBuyOrder(_orderID);
2366 
2367         (bytes32 buyID, bytes32 sellID) = orderIsBuy ?
2368             (_orderID, matchedID) : (matchedID, _orderID);
2369 
2370         SettlementDetails memory settlementDetails = calculateSettlementDetails(
2371             buyID,
2372             sellID,
2373             getTokenDetails(orderDetails[buyID].tokens)
2374         );
2375 
2376         return (
2377             orderStatus[_orderID] == OrderStatus.Settled || orderStatus[_orderID] == OrderStatus.Slashed,
2378             orderIsBuy,
2379             matchedID,
2380             settlementDetails.leftVolume,
2381             settlementDetails.rightVolume,
2382             settlementDetails.leftTokenFee,
2383             settlementDetails.rightTokenFee,
2384             uint32(orderDetails[buyID].tokens >> 32),
2385             uint32(orderDetails[buyID].tokens)
2386         );
2387     }
2388 
2389     /// @notice Exposes the hashOrder function for computing a hash of an
2390     /// order's details. An order hash is used as its ID. See `submitOrder`
2391     /// for the parameter descriptions.
2392     ///
2393     /// @return The 32-byte hash of the order.
2394     function hashOrder(
2395         bytes _prefix,
2396         uint64 _settlementID,
2397         uint64 _tokens,
2398         uint256 _price,
2399         uint256 _volume,
2400         uint256 _minimumVolume
2401     ) external pure returns (bytes32) {
2402         return SettlementUtils.hashOrder(_prefix, SettlementUtils.OrderDetails({
2403             settlementID: _settlementID,
2404             tokens: _tokens,
2405             price: _price,
2406             volume: _volume,
2407             minimumVolume: _minimumVolume
2408         }));
2409     }
2410 
2411     /// @notice Called by `settle`, executes the settlement for a RenEx order
2412     /// or distributes the fees for a RenExAtomic swap.
2413     ///
2414     /// @param _buyID The 32 byte ID of the buy order.
2415     /// @param _sellID The 32 byte ID of the sell order.
2416     /// @param _buyer The address of the buy trader.
2417     /// @param _seller The address of the sell trader.
2418     /// @param _tokens The details of the priority and secondary tokens.
2419     function execute(
2420         bytes32 _buyID,
2421         bytes32 _sellID,
2422         address _buyer,
2423         address _seller,
2424         TokenPair memory _tokens
2425     ) private {
2426         // Calculate the fees for atomic swaps, and the settlement details
2427         // otherwise.
2428         SettlementDetails memory settlementDetails = (orderDetails[_buyID].settlementID == RENEX_ATOMIC_SETTLEMENT_ID) ?
2429             settlementDetails = calculateAtomicFees(_buyID, _sellID, _tokens) :
2430             settlementDetails = calculateSettlementDetails(_buyID, _sellID, _tokens);
2431 
2432         // Transfer priority token value
2433         renExBalancesContract.transferBalanceWithFee(
2434             _buyer,
2435             _seller,
2436             settlementDetails.leftTokenAddress,
2437             settlementDetails.leftVolume,
2438             settlementDetails.leftTokenFee,
2439             orderSubmitter[_buyID]
2440         );
2441 
2442         // Transfer secondary token value
2443         renExBalancesContract.transferBalanceWithFee(
2444             _seller,
2445             _buyer,
2446             settlementDetails.rightTokenAddress,
2447             settlementDetails.rightVolume,
2448             settlementDetails.rightTokenFee,
2449             orderSubmitter[_sellID]
2450         );
2451     }
2452 
2453     /// @notice Calculates the details required to execute two matched orders.
2454     ///
2455     /// @param _buyID The 32 byte ID of the buy order.
2456     /// @param _sellID The 32 byte ID of the sell order.
2457     /// @param _tokens The details of the priority and secondary tokens.
2458     /// @return A struct containing the settlement details.
2459     function calculateSettlementDetails(
2460         bytes32 _buyID,
2461         bytes32 _sellID,
2462         TokenPair memory _tokens
2463     ) private view returns (SettlementDetails memory) {
2464 
2465         // Calculate the mid-price (using numerator and denominator to not loose
2466         // precision).
2467         Fraction memory midPrice = Fraction(orderDetails[_buyID].price + orderDetails[_sellID].price, 2);
2468 
2469         // Calculate the lower of the two max volumes of each trader
2470         uint256 commonVolume = Math.min256(orderDetails[_buyID].volume, orderDetails[_sellID].volume);
2471 
2472         uint256 priorityTokenVolume = joinFraction(
2473             commonVolume.mul(midPrice.numerator),
2474             midPrice.denominator,
2475             int16(_tokens.priorityToken.decimals) - PRICE_OFFSET - VOLUME_OFFSET
2476         );
2477         uint256 secondaryTokenVolume = joinFraction(
2478             commonVolume,
2479             1,
2480             int16(_tokens.secondaryToken.decimals) - VOLUME_OFFSET
2481         );
2482 
2483         // Calculate darknode fees
2484         ValueWithFees memory priorityVwF = subtractDarknodeFee(priorityTokenVolume);
2485         ValueWithFees memory secondaryVwF = subtractDarknodeFee(secondaryTokenVolume);
2486 
2487         return SettlementDetails({
2488             leftVolume: priorityVwF.value,
2489             rightVolume: secondaryVwF.value,
2490             leftTokenFee: priorityVwF.fees,
2491             rightTokenFee: secondaryVwF.fees,
2492             leftTokenAddress: _tokens.priorityToken.addr,
2493             rightTokenAddress: _tokens.secondaryToken.addr
2494         });
2495     }
2496 
2497     /// @notice Calculates the fees to be transferred for an atomic swap.
2498     ///
2499     /// @param _buyID The 32 byte ID of the buy order.
2500     /// @param _sellID The 32 byte ID of the sell order.
2501     /// @param _tokens The details of the priority and secondary tokens.
2502     /// @return A struct containing the fee details.
2503     function calculateAtomicFees(
2504         bytes32 _buyID,
2505         bytes32 _sellID,
2506         TokenPair memory _tokens
2507     ) private view returns (SettlementDetails memory) {
2508 
2509         // Calculate the mid-price (using numerator and denominator to not loose
2510         // precision).
2511         Fraction memory midPrice = Fraction(orderDetails[_buyID].price + orderDetails[_sellID].price, 2);
2512 
2513         // Calculate the lower of the two max volumes of each trader
2514         uint256 commonVolume = Math.min256(orderDetails[_buyID].volume, orderDetails[_sellID].volume);
2515 
2516         if (isEthereumBased(_tokens.secondaryToken.addr)) {
2517             uint256 secondaryTokenVolume = joinFraction(
2518                 commonVolume,
2519                 1,
2520                 int16(_tokens.secondaryToken.decimals) - VOLUME_OFFSET
2521             );
2522 
2523             // Calculate darknode fees
2524             ValueWithFees memory secondaryVwF = subtractDarknodeFee(secondaryTokenVolume);
2525 
2526             return SettlementDetails({
2527                 leftVolume: 0,
2528                 rightVolume: 0,
2529                 leftTokenFee: secondaryVwF.fees,
2530                 rightTokenFee: secondaryVwF.fees,
2531                 leftTokenAddress: _tokens.secondaryToken.addr,
2532                 rightTokenAddress: _tokens.secondaryToken.addr
2533             });
2534         } else if (isEthereumBased(_tokens.priorityToken.addr)) {
2535             uint256 priorityTokenVolume = joinFraction(
2536                 commonVolume.mul(midPrice.numerator),
2537                 midPrice.denominator,
2538                 int16(_tokens.priorityToken.decimals) - PRICE_OFFSET - VOLUME_OFFSET
2539             );
2540 
2541             // Calculate darknode fees
2542             ValueWithFees memory priorityVwF = subtractDarknodeFee(priorityTokenVolume);
2543 
2544             return SettlementDetails({
2545                 leftVolume: 0,
2546                 rightVolume: 0,
2547                 leftTokenFee: priorityVwF.fees,
2548                 rightTokenFee: priorityVwF.fees,
2549                 leftTokenAddress: _tokens.priorityToken.addr,
2550                 rightTokenAddress: _tokens.priorityToken.addr
2551             });
2552         } else {
2553             // Currently, at least one token must be Ethereum-based.
2554             // This will be implemented in the future.
2555             revert("non-eth atomic swaps are not supported");
2556         }
2557     }
2558 
2559     /// @notice Order parity is set by the order tokens are listed. This returns
2560     /// whether an order is a buy or a sell.
2561     /// @return true if _orderID is a buy order.
2562     function isBuyOrder(bytes32 _orderID) private view returns (bool) {
2563         uint64 tokens = orderDetails[_orderID].tokens;
2564         uint32 firstToken = uint32(tokens >> 32);
2565         uint32 secondaryToken = uint32(tokens);
2566         return (firstToken < secondaryToken);
2567     }
2568 
2569     /// @return (value - fee, fee) where fee is 0.2% of value
2570     function subtractDarknodeFee(uint256 _value) private pure returns (ValueWithFees memory) {
2571         uint256 newValue = (_value * (DARKNODE_FEES_DENOMINATOR - DARKNODE_FEES_NUMERATOR)) / DARKNODE_FEES_DENOMINATOR;
2572         return ValueWithFees(newValue, _value - newValue);
2573     }
2574 
2575     /// @notice Gets the order details of the priority and secondary token from
2576     /// the RenExTokens contract and returns them as a single struct.
2577     ///
2578     /// @param _tokens The 64-bit combined token identifiers.
2579     /// @return A TokenPair struct containing two TokenDetails structs.
2580     function getTokenDetails(uint64 _tokens) private view returns (TokenPair memory) {
2581         (
2582             address priorityAddress,
2583             uint8 priorityDecimals,
2584             bool priorityRegistered
2585         ) = renExTokensContract.tokens(uint32(_tokens >> 32));
2586 
2587         (
2588             address secondaryAddress,
2589             uint8 secondaryDecimals,
2590             bool secondaryRegistered
2591         ) = renExTokensContract.tokens(uint32(_tokens));
2592 
2593         return TokenPair({
2594             priorityToken: RenExTokens.TokenDetails(priorityAddress, priorityDecimals, priorityRegistered),
2595             secondaryToken: RenExTokens.TokenDetails(secondaryAddress, secondaryDecimals, secondaryRegistered)
2596         });
2597     }
2598 
2599     /// @return true if _tokenAddress is 0x0, representing a token that is not
2600     /// on Ethereum
2601     function isEthereumBased(address _tokenAddress) private pure returns (bool) {
2602         return (_tokenAddress != address(0x0));
2603     }
2604 
2605     /// @notice Computes (_numerator / _denominator) * 10 ** _scale
2606     function joinFraction(uint256 _numerator, uint256 _denominator, int16 _scale) private pure returns (uint256) {
2607         if (_scale >= 0) {
2608             // Check that (10**_scale) doesn't overflow
2609             assert(_scale <= 77); // log10(2**256) = 77.06
2610             return _numerator.mul(10 ** uint256(_scale)) / _denominator;
2611         } else {
2612             /// @dev If _scale is less than -77, 10**-_scale would overflow.
2613             // For now, -_scale > -24 (when a token has 0 decimals and
2614             // VOLUME_OFFSET and PRICE_OFFSET are each 12). It is unlikely these
2615             // will be increased to add to more than 77.
2616             // assert((-_scale) <= 77); // log10(2**256) = 77.06
2617             return (_numerator / _denominator) / 10 ** uint256(-_scale);
2618         }
2619     }
2620 }
2621 
2622 /// @notice RenExBrokerVerifier implements the BrokerVerifier contract,
2623 /// verifying broker signatures for order opening and fund withdrawal.
2624 contract RenExBrokerVerifier is Ownable {
2625     string public VERSION; // Passed in as a constructor parameter.
2626 
2627     // Events
2628     event LogBalancesContractUpdated(address previousBalancesContract, address nextBalancesContract);
2629     event LogBrokerRegistered(address broker);
2630     event LogBrokerDeregistered(address broker);
2631 
2632     // Storage
2633     mapping(address => bool) public brokers;
2634     mapping(address => uint256) public traderNonces;
2635 
2636     address public balancesContract;
2637 
2638     modifier onlyBalancesContract() {
2639         require(msg.sender == balancesContract, "not authorized");
2640         _;
2641     }
2642 
2643     /// @notice The contract constructor.
2644     ///
2645     /// @param _VERSION A string defining the contract version.
2646     constructor(string _VERSION) public {
2647         VERSION = _VERSION;
2648     }
2649 
2650     /// @notice Allows the owner of the contract to update the address of the
2651     /// RenExBalances contract.
2652     ///
2653     /// @param _balancesContract The address of the new balances contract
2654     function updateBalancesContract(address _balancesContract) external onlyOwner {
2655         emit LogBalancesContractUpdated(balancesContract, _balancesContract);
2656 
2657         balancesContract = _balancesContract;
2658     }
2659 
2660     /// @notice Approved an address to sign order-opening and withdrawals.
2661     /// @param _broker The address of the broker.
2662     function registerBroker(address _broker) external onlyOwner {
2663         require(!brokers[_broker], "already registered");
2664         brokers[_broker] = true;
2665         emit LogBrokerRegistered(_broker);
2666     }
2667 
2668     /// @notice Reverts the a broker's registration.
2669     /// @param _broker The address of the broker.
2670     function deregisterBroker(address _broker) external onlyOwner {
2671         require(brokers[_broker], "not registered");
2672         brokers[_broker] = false;
2673         emit LogBrokerDeregistered(_broker);
2674     }
2675 
2676     /// @notice Verifies a broker's signature for an order opening.
2677     /// The data signed by the broker is a prefixed message and the order ID.
2678     ///
2679     /// @param _trader The trader requesting the withdrawal.
2680     /// @param _signature The 65-byte signature from the broker.
2681     /// @param _orderID The 32-byte order ID.
2682     /// @return True if the signature is valid, false otherwise.
2683     function verifyOpenSignature(
2684         address _trader,
2685         bytes _signature,
2686         bytes32 _orderID
2687     ) external view returns (bool) {
2688         bytes memory data = abi.encodePacked("Republic Protocol: open: ", _trader, _orderID);
2689         address signer = Utils.addr(data, _signature);
2690         return (brokers[signer] == true);
2691     }
2692 
2693     /// @notice Verifies a broker's signature for a trader withdrawal.
2694     /// The data signed by the broker is a prefixed message, the trader address
2695     /// and a 256-bit trader nonce, which is incremented every time a valid
2696     /// signature is checked.
2697     ///
2698     /// @param _trader The trader requesting the withdrawal.
2699     /// @param _signature 65-byte signature from the broker.
2700     /// @return True if the signature is valid, false otherwise.
2701     function verifyWithdrawSignature(
2702         address _trader,
2703         bytes _signature
2704     ) external onlyBalancesContract returns (bool) {
2705         bytes memory data = abi.encodePacked("Republic Protocol: withdraw: ", _trader, traderNonces[_trader]);
2706         address signer = Utils.addr(data, _signature);
2707         if (brokers[signer]) {
2708             traderNonces[_trader] += 1;
2709             return true;
2710         }
2711         return false;
2712     }
2713 }
2714 
2715 /// @notice RenExBalances is responsible for holding RenEx trader funds.
2716 contract RenExBalances is Ownable {
2717     using SafeMath for uint256;
2718     using CompatibleERC20Functions for CompatibleERC20;
2719 
2720     string public VERSION; // Passed in as a constructor parameter.
2721 
2722     RenExSettlement public settlementContract;
2723     RenExBrokerVerifier public brokerVerifierContract;
2724     DarknodeRewardVault public rewardVaultContract;
2725 
2726     /// @dev Should match the address in the DarknodeRewardVault
2727     address constant public ETHEREUM = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
2728     
2729     // Delay between a trader calling `withdrawSignal` and being able to call
2730     // `withdraw` without a broker signature.
2731     uint256 constant public SIGNAL_DELAY = 48 hours;
2732 
2733     // Events
2734     event LogBalanceDecreased(address trader, ERC20 token, uint256 value);
2735     event LogBalanceIncreased(address trader, ERC20 token, uint256 value);
2736     event LogRenExSettlementContractUpdated(address previousRenExSettlementContract, address newRenExSettlementContract);
2737     event LogRewardVaultContractUpdated(address previousRewardVaultContract, address newRewardVaultContract);
2738     event LogBrokerVerifierContractUpdated(address previousBrokerVerifierContract, address newBrokerVerifierContract);
2739 
2740     // Storage
2741     mapping(address => mapping(address => uint256)) public traderBalances;
2742     mapping(address => mapping(address => uint256)) public traderWithdrawalSignals;
2743 
2744     /// @notice The contract constructor.
2745     ///
2746     /// @param _VERSION A string defining the contract version.
2747     /// @param _rewardVaultContract The address of the RewardVault contract.
2748     constructor(
2749         string _VERSION,
2750         DarknodeRewardVault _rewardVaultContract,
2751         RenExBrokerVerifier _brokerVerifierContract
2752     ) public {
2753         VERSION = _VERSION;
2754         rewardVaultContract = _rewardVaultContract;
2755         brokerVerifierContract = _brokerVerifierContract;
2756     }
2757 
2758     /// @notice Restricts a function to only being called by the RenExSettlement
2759     /// contract.
2760     modifier onlyRenExSettlementContract() {
2761         require(msg.sender == address(settlementContract), "not authorized");
2762         _;
2763     }
2764 
2765     /// @notice Restricts trader withdrawing to be called if a signature from a
2766     /// RenEx broker is provided, or if a certain amount of time has passed
2767     /// since a trader has called `signalBackupWithdraw`.
2768     /// @dev If the trader is withdrawing after calling `signalBackupWithdraw`,
2769     /// this will reset the time to zero, writing to storage.
2770     modifier withBrokerSignatureOrSignal(address _token, bytes _signature) {
2771         address trader = msg.sender;
2772 
2773         // If a signature has been provided, verify it - otherwise, verify that
2774         // the user has signalled the withdraw
2775         if (_signature.length > 0) {
2776             require (brokerVerifierContract.verifyWithdrawSignature(trader, _signature), "invalid signature");
2777         } else  {
2778             require(traderWithdrawalSignals[trader][_token] != 0, "not signalled");
2779             /* solium-disable-next-line security/no-block-members */
2780             require((now - traderWithdrawalSignals[trader][_token]) > SIGNAL_DELAY, "signal time remaining");
2781             traderWithdrawalSignals[trader][_token] = 0;
2782         }
2783         _;
2784     }
2785 
2786     /// @notice Allows the owner of the contract to update the address of the
2787     /// RenExSettlement contract.
2788     ///
2789     /// @param _newSettlementContract the address of the new settlement contract
2790     function updateRenExSettlementContract(RenExSettlement _newSettlementContract) external onlyOwner {
2791         emit LogRenExSettlementContractUpdated(settlementContract, _newSettlementContract);
2792         settlementContract = _newSettlementContract;
2793     }
2794 
2795     /// @notice Allows the owner of the contract to update the address of the
2796     /// DarknodeRewardVault contract.
2797     ///
2798     /// @param _newRewardVaultContract the address of the new reward vault contract
2799     function updateRewardVaultContract(DarknodeRewardVault _newRewardVaultContract) external onlyOwner {
2800         emit LogRewardVaultContractUpdated(rewardVaultContract, _newRewardVaultContract);
2801         rewardVaultContract = _newRewardVaultContract;
2802     }
2803 
2804     /// @notice Allows the owner of the contract to update the address of the
2805     /// RenExBrokerVerifier contract.
2806     ///
2807     /// @param _newBrokerVerifierContract the address of the new broker verifier contract
2808     function updateBrokerVerifierContract(RenExBrokerVerifier _newBrokerVerifierContract) external onlyOwner {
2809         emit LogBrokerVerifierContractUpdated(brokerVerifierContract, _newBrokerVerifierContract);
2810         brokerVerifierContract = _newBrokerVerifierContract;
2811     }
2812 
2813     /// @notice Transfer a token value from one trader to another, transferring
2814     /// a fee to the RewardVault. Can only be called by the RenExSettlement
2815     /// contract.
2816     ///
2817     /// @param _traderFrom The address of the trader to decrement the balance of.
2818     /// @param _traderTo The address of the trader to increment the balance of.
2819     /// @param _token The token's address.
2820     /// @param _value The number of tokens to decrement the balance by (in the
2821     ///        token's smallest unit).
2822     /// @param _fee The fee amount to forward on to the RewardVault.
2823     /// @param _feePayee The recipient of the fee.
2824     function transferBalanceWithFee(address _traderFrom, address _traderTo, address _token, uint256 _value, uint256 _fee, address _feePayee)
2825     external onlyRenExSettlementContract {
2826         require(traderBalances[_traderFrom][_token] >= _fee, "insufficient funds for fee");
2827 
2828         if (address(_token) == ETHEREUM) {
2829             rewardVaultContract.deposit.value(_fee)(_feePayee, ERC20(_token), _fee);
2830         } else {
2831             CompatibleERC20(_token).safeApprove(rewardVaultContract, _fee);
2832             rewardVaultContract.deposit(_feePayee, ERC20(_token), _fee);
2833         }
2834         privateDecrementBalance(_traderFrom, ERC20(_token), _value + _fee);
2835         if (_value > 0) {
2836             privateIncrementBalance(_traderTo, ERC20(_token), _value);
2837         }
2838     }
2839 
2840     /// @notice Deposits ETH or an ERC20 token into the contract.
2841     ///
2842     /// @param _token The token's address (must be a registered token).
2843     /// @param _value The amount to deposit in the token's smallest unit.
2844     function deposit(ERC20 _token, uint256 _value) external payable {
2845         address trader = msg.sender;
2846 
2847         uint256 receivedValue = _value;
2848         if (address(_token) == ETHEREUM) {
2849             require(msg.value == _value, "mismatched value parameter and tx value");
2850         } else {
2851             require(msg.value == 0, "unexpected ether transfer");
2852             receivedValue = CompatibleERC20(_token).safeTransferFromWithFees(trader, this, _value);
2853         }
2854         privateIncrementBalance(trader, _token, receivedValue);
2855     }
2856 
2857     /// @notice Withdraws ETH or an ERC20 token from the contract. A broker
2858     /// signature is required to guarantee that the trader has a sufficient
2859     /// balance after accounting for open orders. As a trustless backup,
2860     /// traders can withdraw 48 hours after calling `signalBackupWithdraw`.
2861     ///
2862     /// @param _token The token's address.
2863     /// @param _value The amount to withdraw in the token's smallest unit.
2864     /// @param _signature The broker signature
2865     function withdraw(ERC20 _token, uint256 _value, bytes _signature) external withBrokerSignatureOrSignal(_token, _signature) {
2866         address trader = msg.sender;
2867 
2868         privateDecrementBalance(trader, _token, _value);
2869         if (address(_token) == ETHEREUM) {
2870             trader.transfer(_value);
2871         } else {
2872             CompatibleERC20(_token).safeTransfer(trader, _value);
2873         }
2874     }
2875 
2876     /// @notice A trader can withdraw without needing a broker signature if they
2877     /// first call `signalBackupWithdraw` for the token they want to withdraw.
2878     /// The trader can only withdraw the particular token once for each call to
2879     /// this function. Traders can signal the intent to withdraw multiple
2880     /// tokens.
2881     /// Once this function is called, brokers will not sign order-opens for the
2882     /// trader until the trader has withdrawn, guaranteeing that they won't have
2883     /// orders open for the particular token.
2884     function signalBackupWithdraw(address _token) external {
2885         /* solium-disable-next-line security/no-block-members */
2886         traderWithdrawalSignals[msg.sender][_token] = now;
2887     }
2888 
2889     function privateIncrementBalance(address _trader, ERC20 _token, uint256 _value) private {
2890         traderBalances[_trader][_token] = traderBalances[_trader][_token].add(_value);
2891 
2892         emit LogBalanceIncreased(_trader, _token, _value);
2893     }
2894 
2895     function privateDecrementBalance(address _trader, ERC20 _token, uint256 _value) private {
2896         require(traderBalances[_trader][_token] >= _value, "insufficient funds");
2897         traderBalances[_trader][_token] = traderBalances[_trader][_token].sub(_value);
2898 
2899         emit LogBalanceDecreased(_trader, _token, _value);
2900     }
2901 }