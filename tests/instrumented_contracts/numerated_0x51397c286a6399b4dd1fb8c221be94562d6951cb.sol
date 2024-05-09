1 pragma solidity 0.4.25;
2 
3 // File: contracts/LinkedListLib.sol
4 
5 /**
6  * @title LinkedListLib
7  * @author Darryl Morris (o0ragman0o) and Modular.network
8  *
9  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
10  * into the Modular-Network ethereum-libraries repo at https://github.com/Modular-Network/ethereum-libraries
11  * It has been updated to add additional functionality and be more compatible with solidity 0.4.18
12  * coding patterns.
13  *
14  * version 1.1.1
15  * Copyright (c) 2017 Modular Inc.
16  * The MIT License (MIT)
17  * https://github.com/Modular-network/ethereum-libraries/blob/master/LICENSE
18  *
19  * The LinkedListLib provides functionality for implementing data indexing using
20  * a circlular linked list
21  *
22  * Modular provides smart contract services and security reviews for contract
23  * deployments in addition to working on open source projects in the Ethereum
24  * community. Our purpose is to test, document, and deploy reusable code onto the
25  * blockchain and improve both security and usability. We also educate non-profits,
26  * schools, and other community members about the application of blockchain
27  * technology. For further information: modular.network
28  *
29  *
30  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
31  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
32  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
33  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
34  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
35  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
36  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
37 */
38 
39 
40 library LinkedListLib {
41 
42     uint256 constant NULL = 0;
43     uint256 constant HEAD = 0;
44     bool constant PREV = false;
45     bool constant NEXT = true;
46 
47     struct LinkedList{
48         mapping (uint256 => mapping (bool => uint256)) list;
49     }
50 
51     /// @dev returns true if the list exists
52     /// @param self stored linked list from contract
53     function listExists(LinkedList storage self)
54         public
55         view returns (bool)
56     {
57         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
58         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
59             return true;
60         } else {
61             return false;
62         }
63     }
64 
65     /// @dev returns true if the node exists
66     /// @param self stored linked list from contract
67     /// @param _node a node to search for
68     function nodeExists(LinkedList storage self, uint256 _node)
69         public
70         view returns (bool)
71     {
72         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
73             if (self.list[HEAD][NEXT] == _node) {
74                 return true;
75             } else {
76                 return false;
77             }
78         } else {
79             return true;
80         }
81     }
82 
83     /// @dev Returns the number of elements in the list
84     /// @param self stored linked list from contract
85     function sizeOf(LinkedList storage self) public view returns (uint256 numElements) {
86         bool exists;
87         uint256 i;
88         (exists,i) = getAdjacent(self, HEAD, NEXT);
89         while (i != HEAD) {
90             (exists,i) = getAdjacent(self, i, NEXT);
91             numElements++;
92         }
93         return;
94     }
95 
96     /// @dev Returns the links of a node as a tuple
97     /// @param self stored linked list from contract
98     /// @param _node id of the node to get
99     function getNode(LinkedList storage self, uint256 _node)
100         public view returns (bool,uint256,uint256)
101     {
102         if (!nodeExists(self,_node)) {
103             return (false,0,0);
104         } else {
105             return (true,self.list[_node][PREV], self.list[_node][NEXT]);
106         }
107     }
108 
109     /// @dev Returns the link of a node `_node` in direction `_direction`.
110     /// @param self stored linked list from contract
111     /// @param _node id of the node to step from
112     /// @param _direction direction to step in
113     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
114         public view returns (bool,uint256)
115     {
116         if (!nodeExists(self,_node)) {
117             return (false,0);
118         } else {
119             return (true,self.list[_node][_direction]);
120         }
121     }
122 
123     /// @dev Can be used before `insert` to build an ordered list
124     /// @param self stored linked list from contract
125     /// @param _node an existing node to search from, e.g. HEAD.
126     /// @param _value value to seek
127     /// @param _direction direction to seek in
128     //  @return next first node beyond '_node' in direction `_direction`
129     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
130         public view returns (uint256)
131     {
132         if (sizeOf(self) == 0) { return 0; }
133         require((_node == 0) || nodeExists(self,_node));
134         bool exists;
135         uint256 next;
136         (exists,next) = getAdjacent(self, _node, _direction);
137         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
138         return next;
139     }
140 
141     /// @dev Creates a bidirectional link between two nodes on direction `_direction`
142     /// @param self stored linked list from contract
143     /// @param _node first node for linking
144     /// @param _link  node to link to in the _direction
145     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) private  {
146         self.list[_link][!_direction] = _node;
147         self.list[_node][_direction] = _link;
148     }
149 
150     /// @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
151     /// @param self stored linked list from contract
152     /// @param _node existing node
153     /// @param _new  new node to insert
154     /// @param _direction direction to insert node in
155     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) internal returns (bool) {
156         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
157             uint256 c = self.list[_node][_direction];
158             createLink(self, _node, _new, _direction);
159             createLink(self, _new, c, _direction);
160             return true;
161         } else {
162             return false;
163         }
164     }
165 
166     /// @dev removes an entry from the linked list
167     /// @param self stored linked list from contract
168     /// @param _node node to remove from the list
169     function remove(LinkedList storage self, uint256 _node) internal returns (uint256) {
170         if ((_node == NULL) || (!nodeExists(self,_node))) { return 0; }
171         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
172         delete self.list[_node][PREV];
173         delete self.list[_node][NEXT];
174         return _node;
175     }
176 
177     /// @dev pushes an enrty to the head of the linked list
178     /// @param self stored linked list from contract
179     /// @param _node new entry to push to the head
180     /// @param _direction push to the head (NEXT) or tail (PREV)
181     function push(LinkedList storage self, uint256 _node, bool _direction) internal  {
182         insert(self, HEAD, _node, _direction);
183     }
184 
185     /// @dev pops the first entry from the linked list
186     /// @param self stored linked list from contract
187     /// @param _direction pop from the head (NEXT) or the tail (PREV)
188     function pop(LinkedList storage self, bool _direction) internal returns (uint256) {
189         bool exists;
190         uint256 adj;
191 
192         (exists,adj) = getAdjacent(self, HEAD, _direction);
193 
194         return remove(self, adj);
195     }
196 }
197 
198 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
199 
200 /**
201  * @title SafeMath
202  * @dev Math operations with safety checks that throw on error
203  */
204 library SafeMath {
205 
206   /**
207   * @dev Multiplies two numbers, throws on overflow.
208   */
209   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
210     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
211     // benefit is lost if 'b' is also tested.
212     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
213     if (a == 0) {
214       return 0;
215     }
216 
217     c = a * b;
218     assert(c / a == b);
219     return c;
220   }
221 
222   /**
223   * @dev Integer division of two numbers, truncating the quotient.
224   */
225   function div(uint256 a, uint256 b) internal pure returns (uint256) {
226     // assert(b > 0); // Solidity automatically throws when dividing by 0
227     // uint256 c = a / b;
228     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229     return a / b;
230   }
231 
232   /**
233   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
234   */
235   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236     assert(b <= a);
237     return a - b;
238   }
239 
240   /**
241   * @dev Adds two numbers, throws on overflow.
242   */
243   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
244     c = a + b;
245     assert(c >= a);
246     return c;
247   }
248 }
249 
250 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
251 
252 /**
253  * @title Ownable
254  * @dev The Ownable contract has an owner address, and provides basic authorization control
255  * functions, this simplifies the implementation of "user permissions".
256  */
257 contract Ownable {
258   address public owner;
259 
260 
261   event OwnershipRenounced(address indexed previousOwner);
262   event OwnershipTransferred(
263     address indexed previousOwner,
264     address indexed newOwner
265   );
266 
267 
268   /**
269    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
270    * account.
271    */
272   constructor() public {
273     owner = msg.sender;
274   }
275 
276   /**
277    * @dev Throws if called by any account other than the owner.
278    */
279   modifier onlyOwner() {
280     require(msg.sender == owner);
281     _;
282   }
283 
284   /**
285    * @dev Allows the current owner to relinquish control of the contract.
286    */
287   function renounceOwnership() public onlyOwner {
288     emit OwnershipRenounced(owner);
289     owner = address(0);
290   }
291 
292   /**
293    * @dev Allows the current owner to transfer control of the contract to a newOwner.
294    * @param _newOwner The address to transfer ownership to.
295    */
296   function transferOwnership(address _newOwner) public onlyOwner {
297     _transferOwnership(_newOwner);
298   }
299 
300   /**
301    * @dev Transfers control of the contract to a newOwner.
302    * @param _newOwner The address to transfer ownership to.
303    */
304   function _transferOwnership(address _newOwner) internal {
305     require(_newOwner != address(0));
306     emit OwnershipTransferred(owner, _newOwner);
307     owner = _newOwner;
308   }
309 }
310 
311 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
312 
313 /**
314  * @title Roles
315  * @author Francisco Giordano (@frangio)
316  * @dev Library for managing addresses assigned to a Role.
317  *      See RBAC.sol for example usage.
318  */
319 library Roles {
320   struct Role {
321     mapping (address => bool) bearer;
322   }
323 
324   /**
325    * @dev give an address access to this role
326    */
327   function add(Role storage role, address addr)
328     internal
329   {
330     role.bearer[addr] = true;
331   }
332 
333   /**
334    * @dev remove an address' access to this role
335    */
336   function remove(Role storage role, address addr)
337     internal
338   {
339     role.bearer[addr] = false;
340   }
341 
342   /**
343    * @dev check if an address has this role
344    * // reverts
345    */
346   function check(Role storage role, address addr)
347     view
348     internal
349   {
350     require(has(role, addr));
351   }
352 
353   /**
354    * @dev check if an address has this role
355    * @return bool
356    */
357   function has(Role storage role, address addr)
358     view
359     internal
360     returns (bool)
361   {
362     return role.bearer[addr];
363   }
364 }
365 
366 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
367 
368 /**
369  * @title RBAC (Role-Based Access Control)
370  * @author Matt Condon (@Shrugs)
371  * @dev Stores and provides setters and getters for roles and addresses.
372  * @dev Supports unlimited numbers of roles and addresses.
373  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
374  * This RBAC method uses strings to key roles. It may be beneficial
375  *  for you to write your own implementation of this interface using Enums or similar.
376  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
377  *  to avoid typos.
378  */
379 contract RBAC {
380   using Roles for Roles.Role;
381 
382   mapping (string => Roles.Role) private roles;
383 
384   event RoleAdded(address addr, string roleName);
385   event RoleRemoved(address addr, string roleName);
386 
387   /**
388    * @dev reverts if addr does not have role
389    * @param addr address
390    * @param roleName the name of the role
391    * // reverts
392    */
393   function checkRole(address addr, string roleName)
394     view
395     public
396   {
397     roles[roleName].check(addr);
398   }
399 
400   /**
401    * @dev determine if addr has role
402    * @param addr address
403    * @param roleName the name of the role
404    * @return bool
405    */
406   function hasRole(address addr, string roleName)
407     view
408     public
409     returns (bool)
410   {
411     return roles[roleName].has(addr);
412   }
413 
414   /**
415    * @dev add a role to an address
416    * @param addr address
417    * @param roleName the name of the role
418    */
419   function addRole(address addr, string roleName)
420     internal
421   {
422     roles[roleName].add(addr);
423     emit RoleAdded(addr, roleName);
424   }
425 
426   /**
427    * @dev remove a role from an address
428    * @param addr address
429    * @param roleName the name of the role
430    */
431   function removeRole(address addr, string roleName)
432     internal
433   {
434     roles[roleName].remove(addr);
435     emit RoleRemoved(addr, roleName);
436   }
437 
438   /**
439    * @dev modifier to scope access to a single role (uses msg.sender as addr)
440    * @param roleName the name of the role
441    * // reverts
442    */
443   modifier onlyRole(string roleName)
444   {
445     checkRole(msg.sender, roleName);
446     _;
447   }
448 
449   /**
450    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
451    * @param roleNames the names of the roles to scope access to
452    * // reverts
453    *
454    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
455    *  see: https://github.com/ethereum/solidity/issues/2467
456    */
457   // modifier onlyRoles(string[] roleNames) {
458   //     bool hasAnyRole = false;
459   //     for (uint8 i = 0; i < roleNames.length; i++) {
460   //         if (hasRole(msg.sender, roleNames[i])) {
461   //             hasAnyRole = true;
462   //             break;
463   //         }
464   //     }
465 
466   //     require(hasAnyRole);
467 
468   //     _;
469   // }
470 }
471 
472 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
473 
474 /**
475  * @title Whitelist
476  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
477  * @dev This simplifies the implementation of "user permissions".
478  */
479 contract Whitelist is Ownable, RBAC {
480   event WhitelistedAddressAdded(address addr);
481   event WhitelistedAddressRemoved(address addr);
482 
483   string public constant ROLE_WHITELISTED = "whitelist";
484 
485   /**
486    * @dev Throws if called by any account that's not whitelisted.
487    */
488   modifier onlyWhitelisted() {
489     checkRole(msg.sender, ROLE_WHITELISTED);
490     _;
491   }
492 
493   /**
494    * @dev add an address to the whitelist
495    * @param addr address
496    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
497    */
498   function addAddressToWhitelist(address addr)
499     onlyOwner
500     public
501   {
502     addRole(addr, ROLE_WHITELISTED);
503     emit WhitelistedAddressAdded(addr);
504   }
505 
506   /**
507    * @dev getter to determine if address is in whitelist
508    */
509   function whitelist(address addr)
510     public
511     view
512     returns (bool)
513   {
514     return hasRole(addr, ROLE_WHITELISTED);
515   }
516 
517   /**
518    * @dev add addresses to the whitelist
519    * @param addrs addresses
520    * @return true if at least one address was added to the whitelist,
521    * false if all addresses were already in the whitelist
522    */
523   function addAddressesToWhitelist(address[] addrs)
524     onlyOwner
525     public
526   {
527     for (uint256 i = 0; i < addrs.length; i++) {
528       addAddressToWhitelist(addrs[i]);
529     }
530   }
531 
532   /**
533    * @dev remove an address from the whitelist
534    * @param addr address
535    * @return true if the address was removed from the whitelist,
536    * false if the address wasn't in the whitelist in the first place
537    */
538   function removeAddressFromWhitelist(address addr)
539     onlyOwner
540     public
541   {
542     removeRole(addr, ROLE_WHITELISTED);
543     emit WhitelistedAddressRemoved(addr);
544   }
545 
546   /**
547    * @dev remove addresses from the whitelist
548    * @param addrs addresses
549    * @return true if at least one address was removed from the whitelist,
550    * false if all addresses weren't in the whitelist in the first place
551    */
552   function removeAddressesFromWhitelist(address[] addrs)
553     onlyOwner
554     public
555   {
556     for (uint256 i = 0; i < addrs.length; i++) {
557       removeAddressFromWhitelist(addrs[i]);
558     }
559   }
560 
561 }
562 
563 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
564 
565 /**
566  * @title ERC20Basic
567  * @dev Simpler version of ERC20 interface
568  * @dev see https://github.com/ethereum/EIPs/issues/179
569  */
570 contract ERC20Basic {
571   function totalSupply() public view returns (uint256);
572   function balanceOf(address who) public view returns (uint256);
573   function transfer(address to, uint256 value) public returns (bool);
574   event Transfer(address indexed from, address indexed to, uint256 value);
575 }
576 
577 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
578 
579 /**
580  * @title ERC20 interface
581  * @dev see https://github.com/ethereum/EIPs/issues/20
582  */
583 contract ERC20 is ERC20Basic {
584   function allowance(address owner, address spender)
585     public view returns (uint256);
586 
587   function transferFrom(address from, address to, uint256 value)
588     public returns (bool);
589 
590   function approve(address spender, uint256 value) public returns (bool);
591   event Approval(
592     address indexed owner,
593     address indexed spender,
594     uint256 value
595   );
596 }
597 
598 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
599 
600 /**
601  * @title SafeERC20
602  * @dev Wrappers around ERC20 operations that throw on failure.
603  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
604  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
605  */
606 library SafeERC20 {
607   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
608     require(token.transfer(to, value));
609   }
610 
611   function safeTransferFrom(
612     ERC20 token,
613     address from,
614     address to,
615     uint256 value
616   )
617     internal
618   {
619     require(token.transferFrom(from, to, value));
620   }
621 
622   function safeApprove(ERC20 token, address spender, uint256 value) internal {
623     require(token.approve(spender, value));
624   }
625 }
626 
627 // File: contracts/token_escrow/TokenEscrow.sol
628 
629 /**
630  * NOTE: All contracts in this directory were taken from a non-master branch of openzeppelin-solidity.
631  * This contract was modified to be a whitelist.
632  * Commit: ed451a8688d1fa7c927b27cec299a9726667d9b1
633  */
634 
635 pragma solidity ^0.4.24;
636 
637 
638 
639 
640 
641 
642 /**
643  * @title TokenEscrow
644  * @dev Holds tokens destinated to a payee until they withdraw them.
645  * The contract that uses the TokenEscrow as its payment method
646  * should be its owner, and provide public methods redirecting
647  * to the TokenEscrow's deposit and withdraw.
648  * Moreover, the TokenEscrow should also be allowed to transfer
649  * tokens from the payer to itself.
650  */
651 contract TokenEscrow is Ownable, Whitelist {
652   using SafeMath for uint256;
653   using SafeERC20 for ERC20;
654 
655   event Deposited(address indexed payee, uint256 tokenAmount);
656   event Withdrawn(address indexed payee, uint256 tokenAmount);
657 
658   mapping(address => uint256) public deposits;
659 
660   ERC20 public token;
661 
662   constructor (ERC20 _token) public {
663     require(_token != address(0));
664     token = _token;
665   }
666 
667   function depositsOf(address _payee) public view returns (uint256) {
668     return deposits[_payee];
669   }
670 
671   /**
672   * @dev Puts in escrow a certain amount of tokens as credit to be withdrawn.
673   * @param _payee The destination address of the tokens.
674   * @param _amount The amount of tokens to deposit in escrow.
675   */
676   function deposit(address _payee, uint256 _amount) public onlyWhitelisted {
677     deposits[_payee] = deposits[_payee].add(_amount);
678 
679     token.safeTransferFrom(msg.sender, address(this), _amount);
680 
681     emit Deposited(_payee, _amount);
682   }
683 
684   /**
685   * @dev Withdraw accumulated tokens for a payee.
686   * @param _payee The address whose tokens will be withdrawn and transferred to.
687   */
688   function withdraw(address _payee) public onlyWhitelisted {
689     uint256 payment = deposits[_payee];
690     assert(token.balanceOf(address(this)) >= payment);
691 
692     deposits[_payee] = 0;
693 
694     token.safeTransfer(_payee, payment);
695 
696     emit Withdrawn(_payee, payment);
697   }
698 }
699 
700 // File: contracts/token_escrow/ConditionalTokenEscrow.sol
701 
702 /**
703  * NOTE: All contracts in this directory were taken from a non-master branch of openzeppelin-solidity.
704  * Commit: ed451a8688d1fa7c927b27cec299a9726667d9b1
705  */
706 
707 pragma solidity ^0.4.24;
708 
709 
710 
711 /**
712  * @title ConditionalTokenEscrow
713  * @dev Base abstract escrow to only allow withdrawal of tokens
714  * if a condition is met.
715  */
716 contract ConditionalTokenEscrow is TokenEscrow {
717   /**
718   * @dev Returns whether an address is allowed to withdraw their tokens.
719   * To be implemented by derived contracts.
720   * @param _payee The destination address of the tokens.
721   */
722   function withdrawalAllowed(address _payee) public view returns (bool);
723 
724   function withdraw(address _payee) public {
725     require(withdrawalAllowed(_payee));
726     super.withdraw(_payee);
727   }
728 }
729 
730 // File: contracts/QuantstampAuditTokenEscrow.sol
731 
732 contract QuantstampAuditTokenEscrow is ConditionalTokenEscrow {
733 
734   // the escrow maintains the list of staked addresses
735   using LinkedListLib for LinkedListLib.LinkedList;
736 
737   // constants used by LinkedListLib
738   uint256 constant internal NULL = 0;
739   uint256 constant internal HEAD = 0;
740   bool constant internal PREV = false;
741   bool constant internal NEXT = true;
742 
743   // maintain the number of staked nodes
744   // saves gas cost over needing to call stakedNodesList.sizeOf()
745   uint256 public stakedNodesCount = 0;
746 
747   // the minimum amount of wei-QSP that must be staked in order to be a node
748   uint256 public minAuditStake = 10000 * (10 ** 18);
749 
750   // if true, the payee cannot currently withdraw their funds
751   mapping(address => bool) public lockedFunds;
752 
753   // if funds are locked, they may be retrieved after this block
754   // if funds are unlocked, the number should be ignored
755   mapping(address => uint256) public unlockBlockNumber;
756 
757   // staked audit nodes -- needed to inquire about audit node statistics, such as min price
758   // this list contains all nodes that have *ANY* stake, however when getNextStakedNode is called,
759   // it skips nodes that do not meet the minimum stake.
760   // the reason for this approach is that if the owner lowers the minAuditStake,
761   // we must be aware of any node with a stake.
762   LinkedListLib.LinkedList internal stakedNodesList;
763 
764   event Slashed(address addr, uint256 amount);
765   event StakedNodeAdded(address addr);
766   event StakedNodeRemoved(address addr);
767 
768   // the constructor of TokenEscrow requires an ERC20, not an address
769   constructor(address tokenAddress) public TokenEscrow(ERC20(tokenAddress)) {} // solhint-disable no-empty-blocks
770 
771   /**
772   * @dev Puts in escrow a certain amount of tokens as credit to be withdrawn.
773   *      Overrides the function in TokenEscrow.sol to add the payee to the staked list.
774   * @param _payee The destination address of the tokens.
775   * @param _amount The amount of tokens to deposit in escrow.
776   */
777   function deposit(address _payee, uint256 _amount) public onlyWhitelisted {
778     super.deposit(_payee, _amount);
779     if (_amount > 0) {
780       // fails gracefully if the node already exists
781       addNodeToStakedList(_payee);
782     }
783   }
784 
785  /**
786   * @dev Withdraw accumulated tokens for a payee.
787   *      Overrides the function in TokenEscrow.sol to remove the payee from the staked list.
788   * @param _payee The address whose tokens will be withdrawn and transferred to.
789   */
790   function withdraw(address _payee) public onlyWhitelisted {
791     super.withdraw(_payee);
792     removeNodeFromStakedList(_payee);
793   }
794 
795   /**
796    * @dev Sets the minimum stake to a new value.
797    * @param _value The new value. _value must be greater than zero in order for the linked list to be maintained correctly.
798    */
799   function setMinAuditStake(uint256 _value) public onlyOwner {
800     require(_value > 0);
801     minAuditStake = _value;
802   }
803 
804   /**
805    * @dev Returns true if the sender staked enough.
806    * @param addr The address to check.
807    */
808   function hasEnoughStake(address addr) public view returns(bool) {
809     return depositsOf(addr) >= minAuditStake;
810   }
811 
812   /**
813    * @dev Overrides ConditionalTokenEscrow function. If true, funds may be withdrawn.
814    * @param _payee The address that wants to withdraw funds.
815    */
816   function withdrawalAllowed(address _payee) public view returns (bool) {
817     return !lockedFunds[_payee] || unlockBlockNumber[_payee] < block.number;
818   }
819 
820   /**
821    * @dev Prevents the payee from withdrawing funds.
822    * @param _payee The address that will be locked.
823    */
824   function lockFunds(address _payee, uint256 _unlockBlockNumber) public onlyWhitelisted returns (bool) {
825     lockedFunds[_payee] = true;
826     unlockBlockNumber[_payee] = _unlockBlockNumber;
827     return true;
828   }
829 
830     /**
831    * @dev Slash a percentage of the stake of an address.
832    *      The percentage is taken from the minAuditStake, not the total stake of the address.
833    *      The caller of this function receives the slashed QSP.
834    *      If the current stake does not cover the slash amount, the full stake is taken.
835    *
836    * @param addr The address that will be slashed.
837    * @param percentage The percent of the minAuditStake that should be slashed.
838    */
839   function slash(address addr, uint256 percentage) public onlyWhitelisted returns (uint256) {
840     require(0 <= percentage && percentage <= 100);
841 
842     uint256 slashAmount = getSlashAmount(percentage);
843     uint256 balance = depositsOf(addr);
844     if (balance < slashAmount) {
845       slashAmount = balance;
846     }
847 
848     // subtract from the deposits amount of the addr
849     deposits[addr] = deposits[addr].sub(slashAmount);
850 
851     emit Slashed(addr, slashAmount);
852 
853     // if the deposits of the address are now zero, remove from the list
854     if (depositsOf(addr) == 0) {
855       removeNodeFromStakedList(addr);
856     }
857 
858     // transfer the slashAmount to the police contract
859     token.safeTransfer(msg.sender, slashAmount);
860 
861     return slashAmount;
862   }
863 
864   /**
865    * @dev Returns the slash amount for a given percentage.
866    * @param percentage The percent of the minAuditStake that should be slashed.
867    */
868   function getSlashAmount(uint256 percentage) public view returns (uint256) {
869     return (minAuditStake.mul(percentage)).div(100);
870   }
871 
872   /**
873    * @dev Given a staked address, returns the next address from the list that meets the minAuditStake.
874    * @param addr The staked address.
875    * @return The next address in the list.
876    */
877   function getNextStakedNode(address addr) public view returns(address) {
878     bool exists;
879     uint256 next;
880     (exists, next) = stakedNodesList.getAdjacent(uint256(addr), NEXT);
881     // only return addresses that meet the minAuditStake
882     while (exists && next != HEAD && !hasEnoughStake(address(next))) {
883       (exists, next) = stakedNodesList.getAdjacent(next, NEXT);
884     }
885     return address(next);
886   }
887 
888   /**
889    * @dev Adds an address to the stakedNodesList.
890    * @param addr The address to be added to the list.
891    * @return true if the address was added to the list.
892    */
893   function addNodeToStakedList(address addr) internal returns(bool success) {
894     if (stakedNodesList.insert(HEAD, uint256(addr), PREV)) {
895       stakedNodesCount++;
896       emit StakedNodeAdded(addr);
897       success = true;
898     }
899   }
900 
901   /**
902    * @dev Removes an address from the stakedNodesList.
903    * @param addr The address to be removed from the list.
904    * @return true if the address was removed from the list.
905    */
906   function removeNodeFromStakedList(address addr) internal returns(bool success) {
907     if (stakedNodesList.remove(uint256(addr)) != 0) {
908       stakedNodesCount--;
909       emit StakedNodeRemoved(addr);
910       success = true;
911     }
912   }
913 }