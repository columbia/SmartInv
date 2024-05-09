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
66  * @notice LinkedList is a library for a circular double linked list.
67  */
68 library LinkedList {
69 
70     /*
71     * @notice A permanent NULL node (0x0) in the circular double linked list.
72     * NULL.next is the head, and NULL.previous is the tail.
73     */
74     address public constant NULL = 0x0;
75 
76     /**
77     * @notice A node points to the node before it, and the node after it. If
78     * node.previous = NULL, then the node is the head of the list. If
79     * node.next = NULL, then the node is the tail of the list.
80     */
81     struct Node {
82         bool inList;
83         address previous;
84         address next;
85     }
86 
87     /**
88     * @notice LinkedList uses a mapping from address to nodes. Each address
89     * uniquely identifies a node, and in this way they are used like pointers.
90     */
91     struct List {
92         mapping (address => Node) list;
93     }
94 
95     /**
96     * @notice Insert a new node before an existing node.
97     *
98     * @param self The list being used.
99     * @param target The existing node in the list.
100     * @param newNode The next node to insert before the target.
101     */
102     function insertBefore(List storage self, address target, address newNode) internal {
103         require(!isInList(self, newNode), "already in list");
104         require(isInList(self, target) || target == NULL, "not in list");
105 
106         // It is expected that this value is sometimes NULL.
107         address prev = self.list[target].previous;
108 
109         self.list[newNode].next = target;
110         self.list[newNode].previous = prev;
111         self.list[target].previous = newNode;
112         self.list[prev].next = newNode;
113 
114         self.list[newNode].inList = true;
115     }
116 
117     /**
118     * @notice Insert a new node after an existing node.
119     *
120     * @param self The list being used.
121     * @param target The existing node in the list.
122     * @param newNode The next node to insert after the target.
123     */
124     function insertAfter(List storage self, address target, address newNode) internal {
125         require(!isInList(self, newNode), "already in list");
126         require(isInList(self, target) || target == NULL, "not in list");
127 
128         // It is expected that this value is sometimes NULL.
129         address n = self.list[target].next;
130 
131         self.list[newNode].previous = target;
132         self.list[newNode].next = n;
133         self.list[target].next = newNode;
134         self.list[n].previous = newNode;
135 
136         self.list[newNode].inList = true;
137     }
138 
139     /**
140     * @notice Remove a node from the list, and fix the previous and next
141     * pointers that are pointing to the removed node. Removing anode that is not
142     * in the list will do nothing.
143     *
144     * @param self The list being using.
145     * @param node The node in the list to be removed.
146     */
147     function remove(List storage self, address node) internal {
148         require(isInList(self, node), "not in list");
149         if (node == NULL) {
150             return;
151         }
152         address p = self.list[node].previous;
153         address n = self.list[node].next;
154 
155         self.list[p].next = n;
156         self.list[n].previous = p;
157 
158         // Deleting the node should set this value to false, but we set it here for
159         // explicitness.
160         self.list[node].inList = false;
161         delete self.list[node];
162     }
163 
164     /**
165     * @notice Insert a node at the beginning of the list.
166     *
167     * @param self The list being used.
168     * @param node The node to insert at the beginning of the list.
169     */
170     function prepend(List storage self, address node) internal {
171         // isInList(node) is checked in insertBefore
172 
173         insertBefore(self, begin(self), node);
174     }
175 
176     /**
177     * @notice Insert a node at the end of the list.
178     *
179     * @param self The list being used.
180     * @param node The node to insert at the end of the list.
181     */
182     function append(List storage self, address node) internal {
183         // isInList(node) is checked in insertBefore
184 
185         insertAfter(self, end(self), node);
186     }
187 
188     function swap(List storage self, address left, address right) internal {
189         // isInList(left) and isInList(right) are checked in remove
190 
191         address previousRight = self.list[right].previous;
192         remove(self, right);
193         insertAfter(self, left, right);
194         remove(self, left);
195         insertAfter(self, previousRight, left);
196     }
197 
198     function isInList(List storage self, address node) internal view returns (bool) {
199         return self.list[node].inList;
200     }
201 
202     /**
203     * @notice Get the node at the beginning of a double linked list.
204     *
205     * @param self The list being used.
206     *
207     * @return A address identifying the node at the beginning of the double
208     * linked list.
209     */
210     function begin(List storage self) internal view returns (address) {
211         return self.list[NULL].next;
212     }
213 
214     /**
215     * @notice Get the node at the end of a double linked list.
216     *
217     * @param self The list being used.
218     *
219     * @return A address identifying the node at the end of the double linked
220     * list.
221     */
222     function end(List storage self) internal view returns (address) {
223         return self.list[NULL].previous;
224     }
225 
226     function next(List storage self, address node) internal view returns (address) {
227         require(isInList(self, node), "not in list");
228         return self.list[node].next;
229     }
230 
231     function previous(List storage self, address node) internal view returns (address) {
232         require(isInList(self, node), "not in list");
233         return self.list[node].previous;
234     }
235 
236 }
237 
238 /**
239  * @title ERC20Basic
240  * @dev Simpler version of ERC20 interface
241  * See https://github.com/ethereum/EIPs/issues/179
242  */
243 contract ERC20Basic {
244   function totalSupply() public view returns (uint256);
245   function balanceOf(address who) public view returns (uint256);
246   function transfer(address to, uint256 value) public returns (bool);
247   event Transfer(address indexed from, address indexed to, uint256 value);
248 }
249 
250 /**
251  * @title SafeMath
252  * @dev Math operations with safety checks that throw on error
253  */
254 library SafeMath {
255 
256   /**
257   * @dev Multiplies two numbers, throws on overflow.
258   */
259   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
260     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
261     // benefit is lost if 'b' is also tested.
262     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
263     if (a == 0) {
264       return 0;
265     }
266 
267     c = a * b;
268     assert(c / a == b);
269     return c;
270   }
271 
272   /**
273   * @dev Integer division of two numbers, truncating the quotient.
274   */
275   function div(uint256 a, uint256 b) internal pure returns (uint256) {
276     // assert(b > 0); // Solidity automatically throws when dividing by 0
277     // uint256 c = a / b;
278     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
279     return a / b;
280   }
281 
282   /**
283   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
284   */
285   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
286     assert(b <= a);
287     return a - b;
288   }
289 
290   /**
291   * @dev Adds two numbers, throws on overflow.
292   */
293   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
294     c = a + b;
295     assert(c >= a);
296     return c;
297   }
298 }
299 
300 /**
301  * @title Basic token
302  * @dev Basic version of StandardToken, with no allowances.
303  */
304 contract BasicToken is ERC20Basic {
305   using SafeMath for uint256;
306 
307   mapping(address => uint256) balances;
308 
309   uint256 totalSupply_;
310 
311   /**
312   * @dev Total number of tokens in existence
313   */
314   function totalSupply() public view returns (uint256) {
315     return totalSupply_;
316   }
317 
318   /**
319   * @dev Transfer token for a specified address
320   * @param _to The address to transfer to.
321   * @param _value The amount to be transferred.
322   */
323   function transfer(address _to, uint256 _value) public returns (bool) {
324     require(_to != address(0));
325     require(_value <= balances[msg.sender]);
326 
327     balances[msg.sender] = balances[msg.sender].sub(_value);
328     balances[_to] = balances[_to].add(_value);
329     emit Transfer(msg.sender, _to, _value);
330     return true;
331   }
332 
333   /**
334   * @dev Gets the balance of the specified address.
335   * @param _owner The address to query the the balance of.
336   * @return An uint256 representing the amount owned by the passed address.
337   */
338   function balanceOf(address _owner) public view returns (uint256) {
339     return balances[_owner];
340   }
341 
342 }
343 
344 /**
345  * @title ERC20 interface
346  * @dev see https://github.com/ethereum/EIPs/issues/20
347  */
348 contract ERC20 is ERC20Basic {
349   function allowance(address owner, address spender)
350     public view returns (uint256);
351 
352   function transferFrom(address from, address to, uint256 value)
353     public returns (bool);
354 
355   function approve(address spender, uint256 value) public returns (bool);
356   event Approval(
357     address indexed owner,
358     address indexed spender,
359     uint256 value
360   );
361 }
362 
363 /**
364  * @title Standard ERC20 token
365  *
366  * @dev Implementation of the basic standard token.
367  * https://github.com/ethereum/EIPs/issues/20
368  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
369  */
370 contract StandardToken is ERC20, BasicToken {
371 
372   mapping (address => mapping (address => uint256)) internal allowed;
373 
374 
375   /**
376    * @dev Transfer tokens from one address to another
377    * @param _from address The address which you want to send tokens from
378    * @param _to address The address which you want to transfer to
379    * @param _value uint256 the amount of tokens to be transferred
380    */
381   function transferFrom(
382     address _from,
383     address _to,
384     uint256 _value
385   )
386     public
387     returns (bool)
388   {
389     require(_to != address(0));
390     require(_value <= balances[_from]);
391     require(_value <= allowed[_from][msg.sender]);
392 
393     balances[_from] = balances[_from].sub(_value);
394     balances[_to] = balances[_to].add(_value);
395     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
396     emit Transfer(_from, _to, _value);
397     return true;
398   }
399 
400   /**
401    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
402    * Beware that changing an allowance with this method brings the risk that someone may use both the old
403    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
404    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
405    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
406    * @param _spender The address which will spend the funds.
407    * @param _value The amount of tokens to be spent.
408    */
409   function approve(address _spender, uint256 _value) public returns (bool) {
410     allowed[msg.sender][_spender] = _value;
411     emit Approval(msg.sender, _spender, _value);
412     return true;
413   }
414 
415   /**
416    * @dev Function to check the amount of tokens that an owner allowed to a spender.
417    * @param _owner address The address which owns the funds.
418    * @param _spender address The address which will spend the funds.
419    * @return A uint256 specifying the amount of tokens still available for the spender.
420    */
421   function allowance(
422     address _owner,
423     address _spender
424    )
425     public
426     view
427     returns (uint256)
428   {
429     return allowed[_owner][_spender];
430   }
431 
432   /**
433    * @dev Increase the amount of tokens that an owner allowed to a spender.
434    * approve should be called when allowed[_spender] == 0. To increment
435    * allowed value is better to use this function to avoid 2 calls (and wait until
436    * the first transaction is mined)
437    * From MonolithDAO Token.sol
438    * @param _spender The address which will spend the funds.
439    * @param _addedValue The amount of tokens to increase the allowance by.
440    */
441   function increaseApproval(
442     address _spender,
443     uint256 _addedValue
444   )
445     public
446     returns (bool)
447   {
448     allowed[msg.sender][_spender] = (
449       allowed[msg.sender][_spender].add(_addedValue));
450     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
451     return true;
452   }
453 
454   /**
455    * @dev Decrease the amount of tokens that an owner allowed to a spender.
456    * approve should be called when allowed[_spender] == 0. To decrement
457    * allowed value is better to use this function to avoid 2 calls (and wait until
458    * the first transaction is mined)
459    * From MonolithDAO Token.sol
460    * @param _spender The address which will spend the funds.
461    * @param _subtractedValue The amount of tokens to decrease the allowance by.
462    */
463   function decreaseApproval(
464     address _spender,
465     uint256 _subtractedValue
466   )
467     public
468     returns (bool)
469   {
470     uint256 oldValue = allowed[msg.sender][_spender];
471     if (_subtractedValue > oldValue) {
472       allowed[msg.sender][_spender] = 0;
473     } else {
474       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
475     }
476     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
477     return true;
478   }
479 
480 }
481 
482 /**
483  * @title Pausable
484  * @dev Base contract which allows children to implement an emergency stop mechanism.
485  */
486 contract Pausable is Ownable {
487   event Pause();
488   event Unpause();
489 
490   bool public paused = false;
491 
492 
493   /**
494    * @dev Modifier to make a function callable only when the contract is not paused.
495    */
496   modifier whenNotPaused() {
497     require(!paused);
498     _;
499   }
500 
501   /**
502    * @dev Modifier to make a function callable only when the contract is paused.
503    */
504   modifier whenPaused() {
505     require(paused);
506     _;
507   }
508 
509   /**
510    * @dev called by the owner to pause, triggers stopped state
511    */
512   function pause() onlyOwner whenNotPaused public {
513     paused = true;
514     emit Pause();
515   }
516 
517   /**
518    * @dev called by the owner to unpause, returns to normal state
519    */
520   function unpause() onlyOwner whenPaused public {
521     paused = false;
522     emit Unpause();
523   }
524 }
525 
526 /**
527  * @title Pausable token
528  * @dev StandardToken modified with pausable transfers.
529  **/
530 contract PausableToken is StandardToken, Pausable {
531 
532   function transfer(
533     address _to,
534     uint256 _value
535   )
536     public
537     whenNotPaused
538     returns (bool)
539   {
540     return super.transfer(_to, _value);
541   }
542 
543   function transferFrom(
544     address _from,
545     address _to,
546     uint256 _value
547   )
548     public
549     whenNotPaused
550     returns (bool)
551   {
552     return super.transferFrom(_from, _to, _value);
553   }
554 
555   function approve(
556     address _spender,
557     uint256 _value
558   )
559     public
560     whenNotPaused
561     returns (bool)
562   {
563     return super.approve(_spender, _value);
564   }
565 
566   function increaseApproval(
567     address _spender,
568     uint _addedValue
569   )
570     public
571     whenNotPaused
572     returns (bool success)
573   {
574     return super.increaseApproval(_spender, _addedValue);
575   }
576 
577   function decreaseApproval(
578     address _spender,
579     uint _subtractedValue
580   )
581     public
582     whenNotPaused
583     returns (bool success)
584   {
585     return super.decreaseApproval(_spender, _subtractedValue);
586   }
587 }
588 
589 /**
590  * @title Burnable Token
591  * @dev Token that can be irreversibly burned (destroyed).
592  */
593 contract BurnableToken is BasicToken {
594 
595   event Burn(address indexed burner, uint256 value);
596 
597   /**
598    * @dev Burns a specific amount of tokens.
599    * @param _value The amount of token to be burned.
600    */
601   function burn(uint256 _value) public {
602     _burn(msg.sender, _value);
603   }
604 
605   function _burn(address _who, uint256 _value) internal {
606     require(_value <= balances[_who]);
607     // no need to require value <= totalSupply, since that would imply the
608     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
609 
610     balances[_who] = balances[_who].sub(_value);
611     totalSupply_ = totalSupply_.sub(_value);
612     emit Burn(_who, _value);
613     emit Transfer(_who, address(0), _value);
614   }
615 }
616 
617 contract RepublicToken is PausableToken, BurnableToken {
618 
619     string public constant name = "Republic Token";
620     string public constant symbol = "REN";
621     uint8 public constant decimals = 18;
622     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**uint256(decimals);
623 
624     /// @notice The RepublicToken Constructor.
625     constructor() public {
626         totalSupply_ = INITIAL_SUPPLY;
627         balances[msg.sender] = INITIAL_SUPPLY;
628     }
629 
630     function transferTokens(address beneficiary, uint256 amount) public onlyOwner returns (bool) {
631         /* solium-disable error-reason */
632         require(amount > 0);
633 
634         balances[owner] = balances[owner].sub(amount);
635         balances[beneficiary] = balances[beneficiary].add(amount);
636         emit Transfer(owner, beneficiary, amount);
637 
638         return true;
639     }
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