1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title ERC20Basic
67  * @dev Simpler version of ERC20 interface
68  * See https://github.com/ethereum/EIPs/issues/179
69  */
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender)
83     public view returns (uint256);
84 
85   function transferFrom(address from, address to, uint256 value)
86     public returns (bool);
87 
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(
90     address indexed owner,
91     address indexed spender,
92     uint256 value
93   );
94 }
95 
96 /**
97  * @title SafeMath
98  * @dev Math operations with safety checks that throw on error
99  */
100 library SafeMath {
101 
102   /**
103   * @dev Multiplies two numbers, throws on overflow.
104   */
105   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
107     // benefit is lost if 'b' is also tested.
108     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
109     if (a == 0) {
110       return 0;
111     }
112 
113     c = a * b;
114     assert(c / a == b);
115     return c;
116   }
117 
118   /**
119   * @dev Integer division of two numbers, truncating the quotient.
120   */
121   function div(uint256 a, uint256 b) internal pure returns (uint256) {
122     // assert(b > 0); // Solidity automatically throws when dividing by 0
123     // uint256 c = a / b;
124     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125     return a / b;
126   }
127 
128   /**
129   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
130   */
131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     assert(b <= a);
133     return a - b;
134   }
135 
136   /**
137   * @dev Adds two numbers, throws on overflow.
138   */
139   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
140     c = a + b;
141     assert(c >= a);
142     return c;
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