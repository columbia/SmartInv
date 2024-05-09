1 pragma solidity 0.4.24;
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
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (a == 0) {
91       return 0;
92     }
93 
94     c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     // uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return a / b;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
121     c = a + b;
122     assert(c >= a);
123     return c;
124   }
125 }
126 
127 /**
128  * @title Basic token
129  * @dev Basic version of StandardToken, with no allowances.
130  */
131 contract BasicToken is ERC20Basic {
132   using SafeMath for uint256;
133 
134   mapping(address => uint256) balances;
135 
136   uint256 totalSupply_;
137 
138   /**
139   * @dev Total number of tokens in existence
140   */
141   function totalSupply() public view returns (uint256) {
142     return totalSupply_;
143   }
144 
145   /**
146   * @dev Transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) public returns (bool) {
151     require(_to != address(0));
152     require(_value <= balances[msg.sender]);
153 
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176   function allowance(address owner, address spender)
177     public view returns (uint256);
178 
179   function transferFrom(address from, address to, uint256 value)
180     public returns (bool);
181 
182   function approve(address spender, uint256 value) public returns (bool);
183   event Approval(
184     address indexed owner,
185     address indexed spender,
186     uint256 value
187   );
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
1267 /// @notice The BrokerVerifier interface defines the functions that a settlement
1268 /// layer's broker verifier contract must implement.
1269 interface BrokerVerifier {
1270 
1271     /// @notice The function signature that will be called when a trader opens
1272     /// an order.
1273     ///
1274     /// @param _trader The trader requesting the withdrawal.
1275     /// @param _signature The 65-byte signature from the broker.
1276     /// @param _orderID The 32-byte order ID.
1277     function verifyOpenSignature(
1278         address _trader,
1279         bytes _signature,
1280         bytes32 _orderID
1281     ) external returns (bool);
1282 }
1283 
1284 /// @notice The Settlement interface defines the functions that a settlement
1285 /// layer must implement.
1286 /// Docs: https://github.com/republicprotocol/republic-sol/blob/nightly/docs/05-settlement.md
1287 interface Settlement {
1288     function submitOrder(
1289         bytes _details,
1290         uint64 _settlementID,
1291         uint64 _tokens,
1292         uint256 _price,
1293         uint256 _volume,
1294         uint256 _minimumVolume
1295     ) external;
1296 
1297     function submissionGasPriceLimit() external view returns (uint256);
1298 
1299     function settle(
1300         bytes32 _buyID,
1301         bytes32 _sellID
1302     ) external;
1303 
1304     /// @notice orderStatus should return the status of the order, which should
1305     /// be:
1306     ///     0  - Order not seen before
1307     ///     1  - Order details submitted
1308     ///     >1 - Order settled, or settlement no longer possible
1309     function orderStatus(bytes32 _orderID) external view returns (uint8);
1310 }
1311 
1312 /// @notice SettlementRegistry allows a Settlement layer to register the
1313 /// contracts used for match settlement and for broker signature verification.
1314 contract SettlementRegistry is Ownable {
1315     string public VERSION; // Passed in as a constructor parameter.
1316 
1317     struct SettlementDetails {
1318         bool registered;
1319         Settlement settlementContract;
1320         BrokerVerifier brokerVerifierContract;
1321     }
1322 
1323     // Settlement IDs are 64-bit unsigned numbers
1324     mapping(uint64 => SettlementDetails) public settlementDetails;
1325 
1326     // Events
1327     event LogSettlementRegistered(uint64 settlementID, Settlement settlementContract, BrokerVerifier brokerVerifierContract);
1328     event LogSettlementUpdated(uint64 settlementID, Settlement settlementContract, BrokerVerifier brokerVerifierContract);
1329     event LogSettlementDeregistered(uint64 settlementID);
1330 
1331     /// @notice The contract constructor.
1332     ///
1333     /// @param _VERSION A string defining the contract version.
1334     constructor(string _VERSION) public {
1335         VERSION = _VERSION;
1336     }
1337 
1338     /// @notice Returns the settlement contract of a settlement layer.
1339     function settlementRegistration(uint64 _settlementID) external view returns (bool) {
1340         return settlementDetails[_settlementID].registered;
1341     }
1342 
1343     /// @notice Returns the settlement contract of a settlement layer.
1344     function settlementContract(uint64 _settlementID) external view returns (Settlement) {
1345         return settlementDetails[_settlementID].settlementContract;
1346     }
1347 
1348     /// @notice Returns the broker verifier contract of a settlement layer.
1349     function brokerVerifierContract(uint64 _settlementID) external view returns (BrokerVerifier) {
1350         return settlementDetails[_settlementID].brokerVerifierContract;
1351     }
1352 
1353     /// @param _settlementID A unique 64-bit settlement identifier.
1354     /// @param _settlementContract The address to use for settling matches.
1355     /// @param _brokerVerifierContract The decimals to use for verifying
1356     ///        broker signatures.
1357     function registerSettlement(uint64 _settlementID, Settlement _settlementContract, BrokerVerifier _brokerVerifierContract) public onlyOwner {
1358         bool alreadyRegistered = settlementDetails[_settlementID].registered;
1359         
1360         settlementDetails[_settlementID] = SettlementDetails({
1361             registered: true,
1362             settlementContract: _settlementContract,
1363             brokerVerifierContract: _brokerVerifierContract
1364         });
1365 
1366         if (alreadyRegistered) {
1367             emit LogSettlementUpdated(_settlementID, _settlementContract, _brokerVerifierContract);
1368         } else {
1369             emit LogSettlementRegistered(_settlementID, _settlementContract, _brokerVerifierContract);
1370         }
1371     }
1372 
1373     /// @notice Deregisteres a settlement layer, clearing the details.
1374     /// @param _settlementID The unique 64-bit settlement identifier.
1375     function deregisterSettlement(uint64 _settlementID) external onlyOwner {
1376         require(settlementDetails[_settlementID].registered, "not registered");
1377 
1378         delete settlementDetails[_settlementID];
1379 
1380         emit LogSettlementDeregistered(_settlementID);
1381     }
1382 }
1383 
1384 /**
1385  * @title Eliptic curve signature operations
1386  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
1387  * TODO Remove this library once solidity supports passing a signature to ecrecover.
1388  * See https://github.com/ethereum/solidity/issues/864
1389  */
1390 
1391 library ECRecovery {
1392 
1393   /**
1394    * @dev Recover signer address from a message by using their signature
1395    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
1396    * @param sig bytes signature, the signature is generated using web3.eth.sign()
1397    */
1398   function recover(bytes32 hash, bytes sig)
1399     internal
1400     pure
1401     returns (address)
1402   {
1403     bytes32 r;
1404     bytes32 s;
1405     uint8 v;
1406 
1407     // Check the signature length
1408     if (sig.length != 65) {
1409       return (address(0));
1410     }
1411 
1412     // Divide the signature in r, s and v variables
1413     // ecrecover takes the signature parameters, and the only way to get them
1414     // currently is to use assembly.
1415     // solium-disable-next-line security/no-inline-assembly
1416     assembly {
1417       r := mload(add(sig, 32))
1418       s := mload(add(sig, 64))
1419       v := byte(0, mload(add(sig, 96)))
1420     }
1421 
1422     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
1423     if (v < 27) {
1424       v += 27;
1425     }
1426 
1427     // If the version is correct return the signer address
1428     if (v != 27 && v != 28) {
1429       return (address(0));
1430     } else {
1431       // solium-disable-next-line arg-overflow
1432       return ecrecover(hash, v, r, s);
1433     }
1434   }
1435 
1436   /**
1437    * toEthSignedMessageHash
1438    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
1439    * and hash the result
1440    */
1441   function toEthSignedMessageHash(bytes32 hash)
1442     internal
1443     pure
1444     returns (bytes32)
1445   {
1446     // 32 is the length in bytes of hash,
1447     // enforced by the type signature above
1448     return keccak256(
1449       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1450     );
1451   }
1452 }
1453 
1454 library Utils {
1455 
1456     /**
1457      * @notice Converts a number to its string/bytes representation
1458      *
1459      * @param _v the uint to convert
1460      */
1461     function uintToBytes(uint256 _v) internal pure returns (bytes) {
1462         uint256 v = _v;
1463         if (v == 0) {
1464             return "0";
1465         }
1466 
1467         uint256 digits = 0;
1468         uint256 v2 = v;
1469         while (v2 > 0) {
1470             v2 /= 10;
1471             digits += 1;
1472         }
1473 
1474         bytes memory result = new bytes(digits);
1475 
1476         for (uint256 i = 0; i < digits; i++) {
1477             result[digits - i - 1] = bytes1((v % 10) + 48);
1478             v /= 10;
1479         }
1480 
1481         return result;
1482     }
1483 
1484     /**
1485      * @notice Retrieves the address from a signature
1486      *
1487      * @param _hash the message that was signed (any length of bytes)
1488      * @param _signature the signature (65 bytes)
1489      */
1490     function addr(bytes _hash, bytes _signature) internal pure returns (address) {
1491         bytes memory prefix = "\x19Ethereum Signed Message:\n";
1492         bytes memory encoded = abi.encodePacked(prefix, uintToBytes(_hash.length), _hash);
1493         bytes32 prefixedHash = keccak256(encoded);
1494 
1495         return ECRecovery.recover(prefixedHash, _signature);
1496     }
1497 
1498 }
1499 
1500 /// @notice The Orderbook contract stores the state and priority of orders and
1501 /// allows the Darknodes to easily reach consensus. Eventually, this contract
1502 /// will only store a subset of order states, such as cancellation, to improve
1503 /// the throughput of orders.
1504 contract Orderbook is Ownable {
1505     string public VERSION; // Passed in as a constructor parameter.
1506 
1507     /// @notice OrderState enumerates the possible states of an order. All
1508     /// orders default to the Undefined state.
1509     enum OrderState {Undefined, Open, Confirmed, Canceled}
1510 
1511     /// @notice Order stores a subset of the public data associated with an order.
1512     struct Order {
1513         OrderState state;     // State of the order
1514         address trader;       // Trader that owns the order
1515         address confirmer;    // Darknode that confirmed the order in a match
1516         uint64 settlementID;  // The settlement that signed the order opening
1517         uint256 priority;     // Logical time priority of this order
1518         uint256 blockNumber;  // Block number of the most recent state change
1519         bytes32 matchedOrder; // Order confirmed in a match with this order
1520     }
1521 
1522     RepublicToken public ren;
1523     DarknodeRegistry public darknodeRegistry;
1524     SettlementRegistry public settlementRegistry;
1525 
1526     bytes32[] private orderbook;
1527 
1528     // Order details are exposed through directly accessing this mapping, or
1529     // through the getter functions below for each of the order's fields.
1530     mapping(bytes32 => Order) public orders;
1531 
1532     event LogFeeUpdated(uint256 previousFee, uint256 nextFee);
1533     event LogDarknodeRegistryUpdated(DarknodeRegistry previousDarknodeRegistry, DarknodeRegistry nextDarknodeRegistry);
1534 
1535     /// @notice Only allow registered dark nodes.
1536     modifier onlyDarknode(address _sender) {
1537         require(darknodeRegistry.isRegistered(address(_sender)), "must be registered darknode");
1538         _;
1539     }
1540 
1541     /// @notice The contract constructor.
1542     ///
1543     /// @param _VERSION A string defining the contract version.
1544     /// @param _renAddress The address of the RepublicToken contract.
1545     /// @param _darknodeRegistry The address of the DarknodeRegistry contract.
1546     /// @param _settlementRegistry The address of the SettlementRegistry
1547     ///        contract.
1548     constructor(
1549         string _VERSION,
1550         RepublicToken _renAddress,
1551         DarknodeRegistry _darknodeRegistry,
1552         SettlementRegistry _settlementRegistry
1553     ) public {
1554         VERSION = _VERSION;
1555         ren = _renAddress;
1556         darknodeRegistry = _darknodeRegistry;
1557         settlementRegistry = _settlementRegistry;
1558     }
1559 
1560     /// @notice Allows the owner to update the address of the DarknodeRegistry
1561     /// contract.
1562     function updateDarknodeRegistry(DarknodeRegistry _newDarknodeRegistry) external onlyOwner {
1563         emit LogDarknodeRegistryUpdated(darknodeRegistry, _newDarknodeRegistry);
1564         darknodeRegistry = _newDarknodeRegistry;
1565     }
1566 
1567     /// @notice Open an order in the orderbook. The order must be in the
1568     /// Undefined state.
1569     ///
1570     /// @param _signature Signature of the message that defines the trader. The
1571     ///        message is "Republic Protocol: open: {orderId}".
1572     /// @param _orderID The hash of the order.
1573     function openOrder(uint64 _settlementID, bytes _signature, bytes32 _orderID) external {
1574         require(orders[_orderID].state == OrderState.Undefined, "invalid order status");
1575 
1576         address trader = msg.sender;
1577 
1578         // Verify the order signature
1579         require(settlementRegistry.settlementRegistration(_settlementID), "settlement not registered");
1580         BrokerVerifier brokerVerifier = settlementRegistry.brokerVerifierContract(_settlementID);
1581         require(brokerVerifier.verifyOpenSignature(trader, _signature, _orderID), "invalid broker signature");
1582 
1583         orders[_orderID] = Order({
1584             state: OrderState.Open,
1585             trader: trader,
1586             confirmer: 0x0,
1587             settlementID: _settlementID,
1588             priority: orderbook.length + 1,
1589             blockNumber: block.number,
1590             matchedOrder: 0x0
1591         });
1592 
1593         orderbook.push(_orderID);
1594     }
1595 
1596     /// @notice Confirm an order match between orders. The confirmer must be a
1597     /// registered Darknode and the orders must be in the Open state. A
1598     /// malicious confirmation by a Darknode will result in a bond slash of the
1599     /// Darknode.
1600     ///
1601     /// @param _orderID The hash of the order.
1602     /// @param _matchedOrderID The hashes of the matching order.
1603     function confirmOrder(bytes32 _orderID, bytes32 _matchedOrderID) external onlyDarknode(msg.sender) {
1604         require(orders[_orderID].state == OrderState.Open, "invalid order status");
1605         require(orders[_matchedOrderID].state == OrderState.Open, "invalid order status");
1606 
1607         orders[_orderID].state = OrderState.Confirmed;
1608         orders[_orderID].confirmer = msg.sender;
1609         orders[_orderID].matchedOrder = _matchedOrderID;
1610         orders[_orderID].blockNumber = block.number;
1611 
1612         orders[_matchedOrderID].state = OrderState.Confirmed;
1613         orders[_matchedOrderID].confirmer = msg.sender;
1614         orders[_matchedOrderID].matchedOrder = _orderID;
1615         orders[_matchedOrderID].blockNumber = block.number;
1616     }
1617 
1618     /// @notice Cancel an open order in the orderbook. An order can be cancelled
1619     /// by the trader who opened the order, or by the broker verifier contract.
1620     /// This allows the settlement layer to implement their own logic for
1621     /// cancelling orders without trader interaction (e.g. to ban a trader from
1622     /// a specific darkpool, or to use multiple order-matching platforms)
1623     ///
1624     /// @param _orderID The hash of the order.
1625     function cancelOrder(bytes32 _orderID) external {
1626         require(orders[_orderID].state == OrderState.Open, "invalid order state");
1627 
1628         // Require the msg.sender to be the trader or the broker verifier
1629         address brokerVerifier = address(settlementRegistry.brokerVerifierContract(orders[_orderID].settlementID));
1630         require(msg.sender == orders[_orderID].trader || msg.sender == brokerVerifier, "not authorized");
1631 
1632         orders[_orderID].state = OrderState.Canceled;
1633         orders[_orderID].blockNumber = block.number;
1634     }
1635 
1636     /// @notice returns status of the given orderID.
1637     function orderState(bytes32 _orderID) external view returns (OrderState) {
1638         return orders[_orderID].state;
1639     }
1640 
1641     /// @notice returns a list of matched orders to the given orderID.
1642     function orderMatch(bytes32 _orderID) external view returns (bytes32) {
1643         return orders[_orderID].matchedOrder;
1644     }
1645 
1646     /// @notice returns the priority of the given orderID.
1647     /// The priority is the index of the order in the orderbook.
1648     function orderPriority(bytes32 _orderID) external view returns (uint256) {
1649         return orders[_orderID].priority;
1650     }
1651 
1652     /// @notice returns the trader of the given orderID.
1653     /// Trader is the one who signs the message and does the actual trading.
1654     function orderTrader(bytes32 _orderID) external view returns (address) {
1655         return orders[_orderID].trader;
1656     }
1657 
1658     /// @notice returns the darknode address which confirms the given orderID.
1659     function orderConfirmer(bytes32 _orderID) external view returns (address) {
1660         return orders[_orderID].confirmer;
1661     }
1662 
1663     /// @notice returns the block number when the order being last modified.
1664     function orderBlockNumber(bytes32 _orderID) external view returns (uint256) {
1665         return orders[_orderID].blockNumber;
1666     }
1667 
1668     /// @notice returns the block depth of the orderId
1669     function orderDepth(bytes32 _orderID) external view returns (uint256) {
1670         if (orders[_orderID].blockNumber == 0) {
1671             return 0;
1672         }
1673         return (block.number - orders[_orderID].blockNumber);
1674     }
1675 
1676     /// @notice returns the number of orders in the orderbook
1677     function ordersCount() external view returns (uint256) {
1678         return orderbook.length;
1679     }
1680 
1681     /// @notice returns order details of the orders starting from the offset.
1682     function getOrders(uint256 _offset, uint256 _limit) external view returns (bytes32[], address[], uint8[]) {
1683         if (_offset >= orderbook.length) {
1684             return;
1685         }
1686 
1687         // If the provided limit is more than the number of orders after the offset,
1688         // decrease the limit
1689         uint256 limit = _limit;
1690         if (_offset + limit > orderbook.length) {
1691             limit = orderbook.length - _offset;
1692         }
1693 
1694         bytes32[] memory orderIDs = new bytes32[](limit);
1695         address[] memory traderAddresses = new address[](limit);
1696         uint8[] memory states = new uint8[](limit);
1697 
1698         for (uint256 i = 0; i < limit; i++) {
1699             bytes32 order = orderbook[i + _offset];
1700             orderIDs[i] = order;
1701             traderAddresses[i] = orders[order].trader;
1702             states[i] = uint8(orders[order].state);
1703         }
1704 
1705         return (orderIDs, traderAddresses, states);
1706     }
1707 }