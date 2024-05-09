1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address who) public view returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 /**
70  * @title LinkedListLib
71  * @author Darryl Morris (o0ragman0o) and Modular.network
72  *
73  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
74  * into the Modular-Network ethereum-libraries repo at https://github.com/Modular-Network/ethereum-libraries
75  * It has been updated to add additional functionality and be more compatible with solidity 0.4.18
76  * coding patterns.
77  *
78  * version 1.1.1
79  * Copyright (c) 2017 Modular Inc.
80  * The MIT License (MIT)
81  * https://github.com/Modular-network/ethereum-libraries/blob/master/LICENSE
82  *
83  * The LinkedListLib provides functionality for implementing data indexing using
84  * a circlular linked list
85  *
86  * Modular provides smart contract services and security reviews for contract
87  * deployments in addition to working on open source projects in the Ethereum
88  * community. Our purpose is to test, document, and deploy reusable code onto the
89  * blockchain and improve both security and usability. We also educate non-profits,
90  * schools, and other community members about the application of blockchain
91  * technology. For further information: modular.network
92  *
93  *
94  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
95  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
96  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
97  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
98  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
99  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
100  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
101 */
102 
103 
104 library LinkedListLib {
105 
106     uint256 constant NULL = 0;
107     uint256 constant HEAD = 0;
108     bool constant PREV = false;
109     bool constant NEXT = true;
110 
111     struct LinkedList{
112         mapping (uint256 => mapping (bool => uint256)) list;
113     }
114 
115     /// @dev returns true if the list exists
116     /// @param self stored linked list from contract
117     function listExists(LinkedList storage self)
118         public
119         view returns (bool)
120     {
121         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
122         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
123             return true;
124         } else {
125             return false;
126         }
127     }
128 
129     /// @dev returns true if the node exists
130     /// @param self stored linked list from contract
131     /// @param _node a node to search for
132     function nodeExists(LinkedList storage self, uint256 _node)
133         public
134         view returns (bool)
135     {
136         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
137             if (self.list[HEAD][NEXT] == _node) {
138                 return true;
139             } else {
140                 return false;
141             }
142         } else {
143             return true;
144         }
145     }
146 
147     /// @dev Returns the number of elements in the list
148     /// @param self stored linked list from contract
149     function sizeOf(LinkedList storage self) public view returns (uint256 numElements) {
150         bool exists;
151         uint256 i;
152         (exists,i) = getAdjacent(self, HEAD, NEXT);
153         while (i != HEAD) {
154             (exists,i) = getAdjacent(self, i, NEXT);
155             numElements++;
156         }
157         return;
158     }
159 
160     /// @dev Returns the links of a node as a tuple
161     /// @param self stored linked list from contract
162     /// @param _node id of the node to get
163     function getNode(LinkedList storage self, uint256 _node)
164         public view returns (bool,uint256,uint256)
165     {
166         if (!nodeExists(self,_node)) {
167             return (false,0,0);
168         } else {
169             return (true,self.list[_node][PREV], self.list[_node][NEXT]);
170         }
171     }
172 
173     /// @dev Returns the link of a node `_node` in direction `_direction`.
174     /// @param self stored linked list from contract
175     /// @param _node id of the node to step from
176     /// @param _direction direction to step in
177     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
178         public view returns (bool,uint256)
179     {
180         if (!nodeExists(self,_node)) {
181             return (false,0);
182         } else {
183             return (true,self.list[_node][_direction]);
184         }
185     }
186 
187     /// @dev Can be used before `insert` to build an ordered list
188     /// @param self stored linked list from contract
189     /// @param _node an existing node to search from, e.g. HEAD.
190     /// @param _value value to seek
191     /// @param _direction direction to seek in
192     //  @return next first node beyond '_node' in direction `_direction`
193     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
194         public view returns (uint256)
195     {
196         if (sizeOf(self) == 0) { return 0; }
197         require((_node == 0) || nodeExists(self,_node));
198         bool exists;
199         uint256 next;
200         (exists,next) = getAdjacent(self, _node, _direction);
201         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
202         return next;
203     }
204 
205     /// @dev Creates a bidirectional link between two nodes on direction `_direction`
206     /// @param self stored linked list from contract
207     /// @param _node first node for linking
208     /// @param _link  node to link to in the _direction
209     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) private  {
210         self.list[_link][!_direction] = _node;
211         self.list[_node][_direction] = _link;
212     }
213 
214     /// @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
215     /// @param self stored linked list from contract
216     /// @param _node existing node
217     /// @param _new  new node to insert
218     /// @param _direction direction to insert node in
219     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) internal returns (bool) {
220         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
221             uint256 c = self.list[_node][_direction];
222             createLink(self, _node, _new, _direction);
223             createLink(self, _new, c, _direction);
224             return true;
225         } else {
226             return false;
227         }
228     }
229 
230     /// @dev removes an entry from the linked list
231     /// @param self stored linked list from contract
232     /// @param _node node to remove from the list
233     function remove(LinkedList storage self, uint256 _node) internal returns (uint256) {
234         if ((_node == NULL) || (!nodeExists(self,_node))) { return 0; }
235         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
236         delete self.list[_node][PREV];
237         delete self.list[_node][NEXT];
238         return _node;
239     }
240 
241     /// @dev pushes an enrty to the head of the linked list
242     /// @param self stored linked list from contract
243     /// @param _node new entry to push to the head
244     /// @param _direction push to the head (NEXT) or tail (PREV)
245     function push(LinkedList storage self, uint256 _node, bool _direction) internal  {
246         insert(self, HEAD, _node, _direction);
247     }
248 
249     /// @dev pops the first entry from the linked list
250     /// @param self stored linked list from contract
251     /// @param _direction pop from the head (NEXT) or the tail (PREV)
252     function pop(LinkedList storage self, bool _direction) internal returns (uint256) {
253         bool exists;
254         uint256 adj;
255 
256         (exists,adj) = getAdjacent(self, HEAD, _direction);
257 
258         return remove(self, adj);
259     }
260 }
261 // Abstract contract for the full ERC 20 Token standard
262 // https://github.com/ethereum/EIPs/issues/20
263 
264 
265 contract EIP20Interface {
266     /* This is a slight change to the ERC20 base standard.
267     function totalSupply() constant returns (uint256 supply);
268     is replaced with:
269     uint256 public totalSupply;
270     This automatically creates a getter function for the totalSupply.
271     This is moved to the base contract since public getter functions are not
272     currently recognised as an implementation of the matching abstract
273     function by the compiler.
274     */
275     /// total amount of tokens
276     uint256 public totalSupply;
277 
278     /// @param _owner The address from which the balance will be retrieved
279     /// @return The balance
280     function balanceOf(address _owner) public view returns (uint256 balance);
281 
282     /// @notice send `_value` token to `_to` from `msg.sender`
283     /// @param _to The address of the recipient
284     /// @param _value The amount of token to be transferred
285     /// @return Whether the transfer was successful or not
286     function transfer(address _to, uint256 _value) public returns (bool success);
287 
288     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
289     /// @param _from The address of the sender
290     /// @param _to The address of the recipient
291     /// @param _value The amount of token to be transferred
292     /// @return Whether the transfer was successful or not
293     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
294 
295     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
296     /// @param _spender The address of the account able to transfer the tokens
297     /// @param _value The amount of tokens to be approved for transfer
298     /// @return Whether the approval was successful or not
299     function approve(address _spender, uint256 _value) public returns (bool success);
300 
301     /// @param _owner The address of the account owning tokens
302     /// @param _spender The address of the account able to transfer the tokens
303     /// @return Amount of remaining tokens allowed to spent
304     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
305 
306     event Transfer(address indexed _from, address indexed _to, uint256 _value);
307     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
308 }
309 
310 
311 
312 /**
313  * @title Roles
314  * @author Francisco Giordano (@frangio)
315  * @dev Library for managing addresses assigned to a Role.
316  *      See RBAC.sol for example usage.
317  */
318 library Roles {
319   struct Role {
320     mapping (address => bool) bearer;
321   }
322 
323   /**
324    * @dev give an address access to this role
325    */
326   function add(Role storage role, address addr)
327     internal
328   {
329     role.bearer[addr] = true;
330   }
331 
332   /**
333    * @dev remove an address' access to this role
334    */
335   function remove(Role storage role, address addr)
336     internal
337   {
338     role.bearer[addr] = false;
339   }
340 
341   /**
342    * @dev check if an address has this role
343    * // reverts
344    */
345   function check(Role storage role, address addr)
346     view
347     internal
348   {
349     require(has(role, addr));
350   }
351 
352   /**
353    * @dev check if an address has this role
354    * @return bool
355    */
356   function has(Role storage role, address addr)
357     view
358     internal
359     returns (bool)
360   {
361     return role.bearer[addr];
362   }
363 }
364 
365 
366 
367 
368 
369 /**
370  * @title RBAC (Role-Based Access Control)
371  * @author Matt Condon (@Shrugs)
372  * @dev Stores and provides setters and getters for roles and addresses.
373  * @dev Supports unlimited numbers of roles and addresses.
374  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
375  * This RBAC method uses strings to key roles. It may be beneficial
376  *  for you to write your own implementation of this interface using Enums or similar.
377  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
378  *  to avoid typos.
379  */
380 contract RBAC {
381   using Roles for Roles.Role;
382 
383   mapping (string => Roles.Role) private roles;
384 
385   event RoleAdded(address addr, string roleName);
386   event RoleRemoved(address addr, string roleName);
387 
388   /**
389    * @dev reverts if addr does not have role
390    * @param addr address
391    * @param roleName the name of the role
392    * // reverts
393    */
394   function checkRole(address addr, string roleName)
395     view
396     public
397   {
398     roles[roleName].check(addr);
399   }
400 
401   /**
402    * @dev determine if addr has role
403    * @param addr address
404    * @param roleName the name of the role
405    * @return bool
406    */
407   function hasRole(address addr, string roleName)
408     view
409     public
410     returns (bool)
411   {
412     return roles[roleName].has(addr);
413   }
414 
415   /**
416    * @dev add a role to an address
417    * @param addr address
418    * @param roleName the name of the role
419    */
420   function addRole(address addr, string roleName)
421     internal
422   {
423     roles[roleName].add(addr);
424     emit RoleAdded(addr, roleName);
425   }
426 
427   /**
428    * @dev remove a role from an address
429    * @param addr address
430    * @param roleName the name of the role
431    */
432   function removeRole(address addr, string roleName)
433     internal
434   {
435     roles[roleName].remove(addr);
436     emit RoleRemoved(addr, roleName);
437   }
438 
439   /**
440    * @dev modifier to scope access to a single role (uses msg.sender as addr)
441    * @param roleName the name of the role
442    * // reverts
443    */
444   modifier onlyRole(string roleName)
445   {
446     checkRole(msg.sender, roleName);
447     _;
448   }
449 
450   /**
451    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
452    * @param roleNames the names of the roles to scope access to
453    * // reverts
454    *
455    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
456    *  see: https://github.com/ethereum/solidity/issues/2467
457    */
458   // modifier onlyRoles(string[] roleNames) {
459   //     bool hasAnyRole = false;
460   //     for (uint8 i = 0; i < roleNames.length; i++) {
461   //         if (hasRole(msg.sender, roleNames[i])) {
462   //             hasAnyRole = true;
463   //             break;
464   //         }
465   //     }
466 
467   //     require(hasAnyRole);
468 
469   //     _;
470   // }
471 }
472 
473 
474 
475 /**
476  * @title Ownable
477  * @dev The Ownable contract has an owner address, and provides basic authorization control
478  * functions, this simplifies the implementation of "user permissions".
479  */
480 contract Ownable {
481   address public owner;
482 
483 
484   event OwnershipRenounced(address indexed previousOwner);
485   event OwnershipTransferred(
486     address indexed previousOwner,
487     address indexed newOwner
488   );
489 
490 
491   /**
492    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
493    * account.
494    */
495   constructor() public {
496     owner = msg.sender;
497   }
498 
499   /**
500    * @dev Throws if called by any account other than the owner.
501    */
502   modifier onlyOwner() {
503     require(msg.sender == owner);
504     _;
505   }
506 
507   /**
508    * @dev Allows the current owner to relinquish control of the contract.
509    */
510   function renounceOwnership() public onlyOwner {
511     emit OwnershipRenounced(owner);
512     owner = address(0);
513   }
514 
515   /**
516    * @dev Allows the current owner to transfer control of the contract to a newOwner.
517    * @param _newOwner The address to transfer ownership to.
518    */
519   function transferOwnership(address _newOwner) public onlyOwner {
520     _transferOwnership(_newOwner);
521   }
522 
523   /**
524    * @dev Transfers control of the contract to a newOwner.
525    * @param _newOwner The address to transfer ownership to.
526    */
527   function _transferOwnership(address _newOwner) internal {
528     require(_newOwner != address(0));
529     emit OwnershipTransferred(owner, _newOwner);
530     owner = _newOwner;
531   }
532 }
533 
534 
535 library AttributeStore {
536     struct Data {
537         mapping(bytes32 => uint) store;
538     }
539 
540     function getAttribute(Data storage self, bytes32 _UUID, string _attrName)
541     public view returns (uint) {
542         bytes32 key = keccak256(_UUID, _attrName);
543         return self.store[key];
544     }
545 
546     function setAttribute(Data storage self, bytes32 _UUID, string _attrName, uint _attrVal)
547     public {
548         bytes32 key = keccak256(_UUID, _attrName);
549         self.store[key] = _attrVal;
550     }
551 }
552 
553 
554 library DLL {
555 
556   uint constant NULL_NODE_ID = 0;
557 
558   struct Node {
559     uint next;
560     uint prev;
561   }
562 
563   struct Data {
564     mapping(uint => Node) dll;
565   }
566 
567   function isEmpty(Data storage self) public view returns (bool) {
568     return getStart(self) == NULL_NODE_ID;
569   }
570 
571   function contains(Data storage self, uint _curr) public view returns (bool) {
572     if (isEmpty(self) || _curr == NULL_NODE_ID) {
573       return false;
574     } 
575 
576     bool isSingleNode = (getStart(self) == _curr) && (getEnd(self) == _curr);
577     bool isNullNode = (getNext(self, _curr) == NULL_NODE_ID) && (getPrev(self, _curr) == NULL_NODE_ID);
578     return isSingleNode || !isNullNode;
579   }
580 
581   function getNext(Data storage self, uint _curr) public view returns (uint) {
582     return self.dll[_curr].next;
583   }
584 
585   function getPrev(Data storage self, uint _curr) public view returns (uint) {
586     return self.dll[_curr].prev;
587   }
588 
589   function getStart(Data storage self) public view returns (uint) {
590     return getNext(self, NULL_NODE_ID);
591   }
592 
593   function getEnd(Data storage self) public view returns (uint) {
594     return getPrev(self, NULL_NODE_ID);
595   }
596 
597   /**
598   @dev Inserts a new node between _prev and _next. When inserting a node already existing in 
599   the list it will be automatically removed from the old position.
600   @param _prev the node which _new will be inserted after
601   @param _curr the id of the new node being inserted
602   @param _next the node which _new will be inserted before
603   */
604   function insert(Data storage self, uint _prev, uint _curr, uint _next) public {
605     require(_curr != NULL_NODE_ID);
606 
607     remove(self, _curr);
608 
609     require(_prev == NULL_NODE_ID || contains(self, _prev));
610     require(_next == NULL_NODE_ID || contains(self, _next));
611 
612     require(getNext(self, _prev) == _next);
613     require(getPrev(self, _next) == _prev);
614 
615     self.dll[_curr].prev = _prev;
616     self.dll[_curr].next = _next;
617 
618     self.dll[_prev].next = _curr;
619     self.dll[_next].prev = _curr;
620   }
621 
622   function remove(Data storage self, uint _curr) public {
623     if (!contains(self, _curr)) {
624       return;
625     }
626 
627     uint next = getNext(self, _curr);
628     uint prev = getPrev(self, _curr);
629 
630     self.dll[next].prev = prev;
631     self.dll[prev].next = next;
632 
633     delete self.dll[_curr];
634   }
635 }
636 /***************************************************************************************************
637 *                                                                                                  *
638 * (c) 2019 Quantstamp, Inc. This content and its use are governed by the license terms at          *
639 * <https://github.com/quantstamp/qsp-protocol-node/blob/develop/LICENSE>                           *
640 *                                                                                                  *
641 ***************************************************************************************************/
642 
643 
644 
645 
646 
647 
648 
649 
650 
651 /**
652 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
653 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
654 */
655 contract PLCRVoting {
656 
657     // ============
658     // EVENTS:
659     // ============
660 
661     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
662     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter, uint salt);
663     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
664     event _VotingRightsGranted(uint numTokens, address indexed voter);
665     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
666     event _TokensRescued(uint indexed pollID, address indexed voter);
667 
668     // ============
669     // DATA STRUCTURES:
670     // ============
671 
672     using AttributeStore for AttributeStore.Data;
673     using DLL for DLL.Data;
674     using SafeMath for uint;
675 
676     struct Poll {
677         uint commitEndDate;     /// expiration date of commit period for poll
678         uint revealEndDate;     /// expiration date of reveal period for poll
679         uint voteQuorum;	    /// number of votes required for a proposal to pass
680         uint votesFor;		    /// tally of votes supporting proposal
681         uint votesAgainst;      /// tally of votes countering proposal
682         mapping(address => bool) didCommit;   /// indicates whether an address committed a vote for this poll
683         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
684         mapping(address => uint) voteOptions; /// stores the voteOption of an address that revealed
685     }
686 
687     // ============
688     // STATE VARIABLES:
689     // ============
690 
691     uint constant public INITIAL_POLL_NONCE = 0;
692     uint public pollNonce;
693 
694     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
695     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
696 
697     mapping(address => DLL.Data) dllMap;
698     AttributeStore.Data store;
699 
700     EIP20Interface public token;
701 
702     /**
703     @dev Initializer. Can only be called once.
704     @param _token The address where the ERC20 token contract is deployed
705     */
706     function init(address _token) public {
707         require(_token != address(0) && address(token) == address(0));
708 
709         token = EIP20Interface(_token);
710         pollNonce = INITIAL_POLL_NONCE;
711     }
712 
713     // ================
714     // TOKEN INTERFACE:
715     // ================
716 
717     /**
718     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
719     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
720     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
721     */
722     function requestVotingRights(uint _numTokens) public {
723         require(token.balanceOf(msg.sender) >= _numTokens);
724         voteTokenBalance[msg.sender] += _numTokens;
725         require(token.transferFrom(msg.sender, this, _numTokens));
726         emit _VotingRightsGranted(_numTokens, msg.sender);
727     }
728 
729     /**
730     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
731     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
732     */
733     function withdrawVotingRights(uint _numTokens) external {
734         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
735         require(availableTokens >= _numTokens);
736         voteTokenBalance[msg.sender] -= _numTokens;
737         require(token.transfer(msg.sender, _numTokens));
738         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
739     }
740 
741     /**
742     @dev Unlocks tokens locked in unrevealed vote where poll has ended
743     @param _pollID Integer identifier associated with the target poll
744     */
745     function rescueTokens(uint _pollID) public {
746         require(isExpired(pollMap[_pollID].revealEndDate));
747         require(dllMap[msg.sender].contains(_pollID));
748 
749         dllMap[msg.sender].remove(_pollID);
750         emit _TokensRescued(_pollID, msg.sender);
751     }
752 
753     /**
754     @dev Unlocks tokens locked in unrevealed votes where polls have ended
755     @param _pollIDs Array of integer identifiers associated with the target polls
756     */
757     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
758         // loop through arrays, rescuing tokens from all
759         for (uint i = 0; i < _pollIDs.length; i++) {
760             rescueTokens(_pollIDs[i]);
761         }
762     }
763 
764     // =================
765     // VOTING INTERFACE:
766     // =================
767 
768     /**
769     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
770     @param _pollID Integer identifier associated with target poll
771     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
772     @param _numTokens The number of tokens to be committed towards the target poll
773     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
774     */
775     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
776         require(commitPeriodActive(_pollID));
777 
778         // if msg.sender doesn't have enough voting rights,
779         // request for enough voting rights
780         if (voteTokenBalance[msg.sender] < _numTokens) {
781             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
782             requestVotingRights(remainder);
783         }
784 
785         // make sure msg.sender has enough voting rights
786         require(voteTokenBalance[msg.sender] >= _numTokens);
787         // prevent user from committing to zero node placeholder
788         require(_pollID != 0);
789         // prevent user from committing a secretHash of 0
790         require(_secretHash != 0);
791 
792         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
793         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
794 
795         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
796 
797         // edge case: in-place update
798         if (nextPollID == _pollID) {
799             nextPollID = dllMap[msg.sender].getNext(_pollID);
800         }
801 
802         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
803         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
804 
805         bytes32 UUID = attrUUID(msg.sender, _pollID);
806 
807         store.setAttribute(UUID, "numTokens", _numTokens);
808         store.setAttribute(UUID, "commitHash", uint(_secretHash));
809 
810         pollMap[_pollID].didCommit[msg.sender] = true;
811         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
812     }
813 
814     /**
815     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
816     @param _pollIDs         Array of integer identifiers associated with target polls
817     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
818     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
819     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
820     */
821     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
822         // make sure the array lengths are all the same
823         require(_pollIDs.length == _secretHashes.length);
824         require(_pollIDs.length == _numsTokens.length);
825         require(_pollIDs.length == _prevPollIDs.length);
826 
827         // loop through arrays, committing each individual vote values
828         for (uint i = 0; i < _pollIDs.length; i++) {
829             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
830         }
831     }
832 
833     /**
834     @dev Compares previous and next poll's committed tokens for sorting purposes
835     @param _prevID Integer identifier associated with previous poll in sorted order
836     @param _nextID Integer identifier associated with next poll in sorted order
837     @param _voter Address of user to check DLL position for
838     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
839     @return valid Boolean indication of if the specified position maintains the sort
840     */
841     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
842         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
843         // if next is zero node, _numTokens does not need to be greater
844         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
845         return prevValid && nextValid;
846     }
847 
848     /**
849     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
850     @param _pollID Integer identifier associated with target poll
851     @param _voteOption Vote choice used to generate commitHash for associated poll
852     @param _salt Secret number used to generate commitHash for associated poll
853     */
854     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
855         // Make sure the reveal period is active
856         require(revealPeriodActive(_pollID));
857         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
858         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
859         require(keccak256(abi.encodePacked(_voteOption, _salt)) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
860 
861         uint numTokens = getNumTokens(msg.sender, _pollID);
862 
863         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
864             pollMap[_pollID].votesFor += numTokens;
865         } else {
866             pollMap[_pollID].votesAgainst += numTokens;
867         }
868 
869         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
870         pollMap[_pollID].didReveal[msg.sender] = true;
871         pollMap[_pollID].voteOptions[msg.sender] = _voteOption;
872 
873         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender, _salt);
874     }
875 
876     /**
877     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
878     @param _pollIDs     Array of integer identifiers associated with target polls
879     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
880     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
881     */
882     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
883         // make sure the array lengths are all the same
884         require(_pollIDs.length == _voteOptions.length);
885         require(_pollIDs.length == _salts.length);
886 
887         // loop through arrays, revealing each individual vote values
888         for (uint i = 0; i < _pollIDs.length; i++) {
889             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
890         }
891     }
892 
893     /**
894     @param _voter           Address of voter who voted in the majority bloc
895     @param _pollID          Integer identifier associated with target poll
896     @return correctVotes    Number of tokens voted for winning option
897     */
898     function getNumPassingTokens(address _voter, uint _pollID) public constant returns (uint correctVotes) {
899         require(pollEnded(_pollID));
900         require(pollMap[_pollID].didReveal[_voter]);
901 
902         uint winningChoice = isPassed(_pollID) ? 1 : 0;
903         uint voterVoteOption = pollMap[_pollID].voteOptions[_voter];
904 
905         require(voterVoteOption == winningChoice, "Voter revealed, but not in the majority");
906 
907         return getNumTokens(_voter, _pollID);
908     }
909 
910     // ==================
911     // POLLING INTERFACE:
912     // ==================
913 
914     /**
915     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
916     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
917     @param _commitDuration Length of desired commit period in seconds
918     @param _revealDuration Length of desired reveal period in seconds
919     */
920     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
921         pollNonce = pollNonce + 1;
922 
923         uint commitEndDate = block.timestamp.add(_commitDuration);
924         uint revealEndDate = commitEndDate.add(_revealDuration);
925 
926         pollMap[pollNonce] = Poll({
927             voteQuorum: _voteQuorum,
928             commitEndDate: commitEndDate,
929             revealEndDate: revealEndDate,
930             votesFor: 0,
931             votesAgainst: 0
932         });
933 
934         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
935         return pollNonce;
936     }
937 
938     /**
939     @notice Determines if proposal has passed
940     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
941     @param _pollID Integer identifier associated with target poll
942     */
943     function isPassed(uint _pollID) constant public returns (bool passed) {
944         require(pollEnded(_pollID));
945 
946         Poll memory poll = pollMap[_pollID];
947         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
948     }
949 
950     // ----------------
951     // POLLING HELPERS:
952     // ----------------
953 
954     /**
955     @dev Gets the total winning votes for reward distribution purposes
956     @param _pollID Integer identifier associated with target poll
957     @return Total number of votes committed to the winning option for specified poll
958     */
959     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
960         require(pollEnded(_pollID));
961 
962         if (isPassed(_pollID))
963             return pollMap[_pollID].votesFor;
964         else
965             return pollMap[_pollID].votesAgainst;
966     }
967 
968     /**
969     @notice Determines if poll is over
970     @dev Checks isExpired for specified poll's revealEndDate
971     @return Boolean indication of whether polling period is over
972     */
973     function pollEnded(uint _pollID) constant public returns (bool ended) {
974         require(pollExists(_pollID));
975 
976         return isExpired(pollMap[_pollID].revealEndDate);
977     }
978 
979     /**
980     @notice Checks if the commit period is still active for the specified poll
981     @dev Checks isExpired for the specified poll's commitEndDate
982     @param _pollID Integer identifier associated with target poll
983     @return Boolean indication of isCommitPeriodActive for target poll
984     */
985     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
986         require(pollExists(_pollID));
987 
988         return !isExpired(pollMap[_pollID].commitEndDate);
989     }
990 
991     /**
992     @notice Checks if the reveal period is still active for the specified poll
993     @dev Checks isExpired for the specified poll's revealEndDate
994     @param _pollID Integer identifier associated with target poll
995     */
996     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
997         require(pollExists(_pollID));
998 
999         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
1000     }
1001 
1002     /**
1003     @dev Checks if user has committed for specified poll
1004     @param _voter Address of user to check against
1005     @param _pollID Integer identifier associated with target poll
1006     @return Boolean indication of whether user has committed
1007     */
1008     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
1009         require(pollExists(_pollID));
1010 
1011         return pollMap[_pollID].didCommit[_voter];
1012     }
1013 
1014     /**
1015     @dev Checks if user has revealed for specified poll
1016     @param _voter Address of user to check against
1017     @param _pollID Integer identifier associated with target poll
1018     @return Boolean indication of whether user has revealed
1019     */
1020     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
1021         require(pollExists(_pollID));
1022 
1023         return pollMap[_pollID].didReveal[_voter];
1024     }
1025 
1026     /**
1027     @dev Checks if a poll exists
1028     @param _pollID The pollID whose existance is to be evaluated.
1029     @return Boolean Indicates whether a poll exists for the provided pollID
1030     */
1031     function pollExists(uint _pollID) constant public returns (bool exists) {
1032         return (_pollID != 0 && _pollID <= pollNonce);
1033     }
1034 
1035     // ---------------------------
1036     // DOUBLE-LINKED-LIST HELPERS:
1037     // ---------------------------
1038 
1039     /**
1040     @dev Gets the bytes32 commitHash property of target poll
1041     @param _voter Address of user to check against
1042     @param _pollID Integer identifier associated with target poll
1043     @return Bytes32 hash property attached to target poll
1044     */
1045     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
1046         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
1047     }
1048 
1049     /**
1050     @dev Wrapper for getAttribute with attrName="numTokens"
1051     @param _voter Address of user to check against
1052     @param _pollID Integer identifier associated with target poll
1053     @return Number of tokens committed to poll in sorted poll-linked-list
1054     */
1055     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
1056         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
1057     }
1058 
1059     /**
1060     @dev Gets top element of sorted poll-linked-list
1061     @param _voter Address of user to check against
1062     @return Integer identifier to poll with maximum number of tokens committed to it
1063     */
1064     function getLastNode(address _voter) constant public returns (uint pollID) {
1065         return dllMap[_voter].getPrev(0);
1066     }
1067 
1068     /**
1069     @dev Gets the numTokens property of getLastNode
1070     @param _voter Address of user to check against
1071     @return Maximum number of tokens committed in poll specified
1072     */
1073     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
1074         return getNumTokens(_voter, getLastNode(_voter));
1075     }
1076 
1077     /*
1078     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
1079     for a node with a value less than or equal to the provided _numTokens value. When such a node
1080     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
1081     update. In that case, return the previous node of the node being updated. Otherwise return the
1082     first node that was found with a value less than or equal to the provided _numTokens.
1083     @param _voter The voter whose DLL will be searched
1084     @param _numTokens The value for the numTokens attribute in the node to be inserted
1085     @return the node which the propoded node should be inserted after
1086     */
1087     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
1088     constant public returns (uint prevNode) {
1089         // Get the last node in the list and the number of tokens in that node
1090         uint nodeID = getLastNode(_voter);
1091         uint tokensInNode = getNumTokens(_voter, nodeID);
1092 
1093         // Iterate backwards through the list until reaching the root node
1094         while(nodeID != 0) {
1095             // Get the number of tokens in the current node
1096             tokensInNode = getNumTokens(_voter, nodeID);
1097             if(tokensInNode <= _numTokens) { // We found the insert point!
1098                 if(nodeID == _pollID) {
1099                     // This is an in-place update. Return the prev node of the node being updated
1100                     nodeID = dllMap[_voter].getPrev(nodeID);
1101                 }
1102                 // Return the insert point
1103                 return nodeID;
1104             }
1105             // We did not find the insert point. Continue iterating backwards through the list
1106             nodeID = dllMap[_voter].getPrev(nodeID);
1107         }
1108 
1109         // The list is empty, or a smaller value than anything else in the list is being inserted
1110         return nodeID;
1111     }
1112 
1113     // ----------------
1114     // GENERAL HELPERS:
1115     // ----------------
1116 
1117     /**
1118     @dev Checks if an expiration date has been reached
1119     @param _terminationDate Integer timestamp of date to compare current timestamp with
1120     @return expired Boolean indication of whether the terminationDate has passed
1121     */
1122     function isExpired(uint _terminationDate) constant public returns (bool expired) {
1123         return (block.timestamp > _terminationDate);
1124     }
1125 
1126     /**
1127     @dev Generates an identifier which associates a user and a poll together
1128     @param _pollID Integer identifier associated with target poll
1129     @return UUID Hash which is deterministic from _user and _pollID
1130     */
1131     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
1132         return keccak256(abi.encodePacked(_user, _pollID));
1133     }
1134 }
1135 
1136 
1137 
1138 
1139 
1140 
1141 
1142 
1143 contract Parameterizer {
1144 
1145     // ------
1146     // EVENTS
1147     // ------
1148 
1149     event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate, address indexed proposer);
1150     event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate, address indexed challenger);
1151     event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
1152     event _ProposalExpired(bytes32 indexed propID);
1153     event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
1154     event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
1155     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
1156 
1157 
1158     // ------
1159     // DATA STRUCTURES
1160     // ------
1161 
1162     using SafeMath for uint;
1163 
1164     struct ParamProposal {
1165         uint appExpiry;
1166         uint challengeID;
1167         uint deposit;
1168         string name;
1169         address owner;
1170         uint processBy;
1171         uint value;
1172     }
1173 
1174     struct Challenge {
1175         uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
1176         address challenger;     // owner of Challenge
1177         bool resolved;          // indication of if challenge is resolved
1178         uint stake;             // number of tokens at risk for either party during challenge
1179         uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
1180         mapping(address => bool) tokenClaims;
1181     }
1182 
1183     // ------
1184     // STATE
1185     // ------
1186 
1187     mapping(bytes32 => uint) public params;
1188 
1189     // maps challengeIDs to associated challenge data
1190     mapping(uint => Challenge) public challenges;
1191 
1192     // maps pollIDs to intended data change if poll passes
1193     mapping(bytes32 => ParamProposal) public proposals;
1194 
1195     // Global Variables
1196     EIP20Interface public token;
1197     PLCRVoting public voting;
1198     uint public PROCESSBY = 604800; // 7 days
1199 
1200     /**
1201     @dev Initializer        Can only be called once
1202     @param _token           The address where the ERC20 token contract is deployed
1203     @param _plcr            address of a PLCR voting contract for the provided token
1204     @notice _parameters     array of canonical parameters
1205     */
1206     function init(
1207         address _token,
1208         address _plcr,
1209         uint[] _parameters
1210     ) public {
1211         require(_token != 0 && address(token) == 0);
1212         require(_plcr != 0 && address(voting) == 0);
1213 
1214         token = EIP20Interface(_token);
1215         voting = PLCRVoting(_plcr);
1216 
1217         // minimum deposit for listing to be whitelisted
1218         set("minDeposit", _parameters[0]);
1219 
1220         // minimum deposit to propose a reparameterization
1221         set("pMinDeposit", _parameters[1]);
1222 
1223         // period over which applicants wait to be whitelisted
1224         set("applyStageLen", _parameters[2]);
1225 
1226         // period over which reparmeterization proposals wait to be processed
1227         set("pApplyStageLen", _parameters[3]);
1228 
1229         // length of commit period for voting
1230         set("commitStageLen", _parameters[4]);
1231 
1232         // length of commit period for voting in parameterizer
1233         set("pCommitStageLen", _parameters[5]);
1234 
1235         // length of reveal period for voting
1236         set("revealStageLen", _parameters[6]);
1237 
1238         // length of reveal period for voting in parameterizer
1239         set("pRevealStageLen", _parameters[7]);
1240 
1241         // percentage of losing party's deposit distributed to winning party
1242         set("dispensationPct", _parameters[8]);
1243 
1244         // percentage of losing party's deposit distributed to winning party in parameterizer
1245         set("pDispensationPct", _parameters[9]);
1246 
1247         // type of majority out of 100 necessary for candidate success
1248         set("voteQuorum", _parameters[10]);
1249 
1250         // type of majority out of 100 necessary for proposal success in parameterizer
1251         set("pVoteQuorum", _parameters[11]);
1252 
1253         // minimum length of time user has to wait to exit the registry
1254         set("exitTimeDelay", _parameters[12]);
1255 
1256         // maximum length of time user can wait to exit the registry
1257         set("exitPeriodLen", _parameters[13]);
1258     }
1259 
1260     // -----------------------
1261     // TOKEN HOLDER INTERFACE
1262     // -----------------------
1263 
1264     /**
1265     @notice propose a reparamaterization of the key _name's value to _value.
1266     @param _name the name of the proposed param to be set
1267     @param _value the proposed value to set the param to be set
1268     */
1269     function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
1270         uint deposit = get("pMinDeposit");
1271         bytes32 propID = keccak256(abi.encodePacked(_name, _value));
1272 
1273         if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("dispensationPct")) ||
1274             keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("pDispensationPct"))) {
1275             require(_value <= 100);
1276         }
1277 
1278         require(!propExists(propID)); // Forbid duplicate proposals
1279         require(get(_name) != _value); // Forbid NOOP reparameterizations
1280 
1281         // attach name and value to pollID
1282         proposals[propID] = ParamProposal({
1283             appExpiry: now.add(get("pApplyStageLen")),
1284             challengeID: 0,
1285             deposit: deposit,
1286             name: _name,
1287             owner: msg.sender,
1288             processBy: now.add(get("pApplyStageLen"))
1289                 .add(get("pCommitStageLen"))
1290                 .add(get("pRevealStageLen"))
1291                 .add(PROCESSBY),
1292             value: _value
1293         });
1294 
1295         require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
1296 
1297         emit _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry, msg.sender);
1298         return propID;
1299     }
1300 
1301     /**
1302     @notice challenge the provided proposal ID, and put tokens at stake to do so.
1303     @param _propID the proposal ID to challenge
1304     */
1305     function challengeReparameterization(bytes32 _propID) public returns (uint challengeID) {
1306         ParamProposal memory prop = proposals[_propID];
1307         uint deposit = prop.deposit;
1308 
1309         require(propExists(_propID) && prop.challengeID == 0);
1310 
1311         //start poll
1312         uint pollID = voting.startPoll(
1313             get("pVoteQuorum"),
1314             get("pCommitStageLen"),
1315             get("pRevealStageLen")
1316         );
1317 
1318         challenges[pollID] = Challenge({
1319             challenger: msg.sender,
1320             rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
1321             stake: deposit,
1322             resolved: false,
1323             winningTokens: 0
1324         });
1325 
1326         proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
1327 
1328         //take tokens from challenger
1329         require(token.transferFrom(msg.sender, this, deposit));
1330 
1331         (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
1332 
1333         emit _NewChallenge(_propID, pollID, commitEndDate, revealEndDate, msg.sender);
1334         return pollID;
1335     }
1336 
1337     /**
1338     @notice             for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
1339     @param _propID      the proposal ID to make a determination and state transition for
1340     */
1341     function processProposal(bytes32 _propID) public {
1342         ParamProposal storage prop = proposals[_propID];
1343         address propOwner = prop.owner;
1344         uint propDeposit = prop.deposit;
1345 
1346 
1347         // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
1348         // prop.owner and prop.deposit will be 0, thereby preventing theft
1349         if (canBeSet(_propID)) {
1350             // There is no challenge against the proposal. The processBy date for the proposal has not
1351             // passed, but the proposal's appExpirty date has passed.
1352             set(prop.name, prop.value);
1353             emit _ProposalAccepted(_propID, prop.name, prop.value);
1354             delete proposals[_propID];
1355             require(token.transfer(propOwner, propDeposit));
1356         } else if (challengeCanBeResolved(_propID)) {
1357             // There is a challenge against the proposal.
1358             resolveChallenge(_propID);
1359         } else if (now > prop.processBy) {
1360             // There is no challenge against the proposal, but the processBy date has passed.
1361             emit _ProposalExpired(_propID);
1362             delete proposals[_propID];
1363             require(token.transfer(propOwner, propDeposit));
1364         } else {
1365             // There is no challenge against the proposal, and neither the appExpiry date nor the
1366             // processBy date has passed.
1367             revert();
1368         }
1369 
1370         assert(get("dispensationPct") <= 100);
1371         assert(get("pDispensationPct") <= 100);
1372 
1373         // verify that future proposal appExpiry and processBy times will not overflow
1374         now.add(get("pApplyStageLen"))
1375             .add(get("pCommitStageLen"))
1376             .add(get("pRevealStageLen"))
1377             .add(PROCESSBY);
1378 
1379         delete proposals[_propID];
1380     }
1381 
1382     /**
1383     @notice                 Claim the tokens owed for the msg.sender in the provided challenge
1384     @param _challengeID     the challenge ID to claim tokens for
1385     */
1386     function claimReward(uint _challengeID) public {
1387         Challenge storage challenge = challenges[_challengeID];
1388         // ensure voter has not already claimed tokens and challenge results have been processed
1389         require(challenge.tokenClaims[msg.sender] == false);
1390         require(challenge.resolved == true);
1391 
1392         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID);
1393         uint reward = voterReward(msg.sender, _challengeID);
1394 
1395         // subtract voter's information to preserve the participation ratios of other voters
1396         // compared to the remaining pool of rewards
1397         challenge.winningTokens -= voterTokens;
1398         challenge.rewardPool -= reward;
1399 
1400         // ensures a voter cannot claim tokens again
1401         challenge.tokenClaims[msg.sender] = true;
1402 
1403         emit _RewardClaimed(_challengeID, reward, msg.sender);
1404         require(token.transfer(msg.sender, reward));
1405     }
1406 
1407     /**
1408     @dev                    Called by a voter to claim their rewards for each completed vote.
1409                             Someone must call updateStatus() before this can be called.
1410     @param _challengeIDs    The PLCR pollIDs of the challenges rewards are being claimed for
1411     */
1412     function claimRewards(uint[] _challengeIDs) public {
1413         // loop through arrays, claiming each individual vote reward
1414         for (uint i = 0; i < _challengeIDs.length; i++) {
1415             claimReward(_challengeIDs[i]);
1416         }
1417     }
1418 
1419     // --------
1420     // GETTERS
1421     // --------
1422 
1423     /**
1424     @dev                Calculates the provided voter's token reward for the given poll.
1425     @param _voter       The address of the voter whose reward balance is to be returned
1426     @param _challengeID The ID of the challenge the voter's reward is being calculated for
1427     @return             The uint indicating the voter's reward
1428     */
1429     function voterReward(address _voter, uint _challengeID)
1430     public view returns (uint) {
1431         uint winningTokens = challenges[_challengeID].winningTokens;
1432         uint rewardPool = challenges[_challengeID].rewardPool;
1433         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID);
1434         return (voterTokens * rewardPool) / winningTokens;
1435     }
1436 
1437     /**
1438     @notice Determines whether a proposal passed its application stage without a challenge
1439     @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
1440     */
1441     function canBeSet(bytes32 _propID) view public returns (bool) {
1442         ParamProposal memory prop = proposals[_propID];
1443 
1444         return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
1445     }
1446 
1447     /**
1448     @notice Determines whether a proposal exists for the provided proposal ID
1449     @param _propID The proposal ID whose existance is to be determined
1450     */
1451     function propExists(bytes32 _propID) view public returns (bool) {
1452         return proposals[_propID].processBy > 0;
1453     }
1454 
1455     /**
1456     @notice Determines whether the provided proposal ID has a challenge which can be resolved
1457     @param _propID The proposal ID whose challenge to inspect
1458     */
1459     function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
1460         ParamProposal memory prop = proposals[_propID];
1461         Challenge memory challenge = challenges[prop.challengeID];
1462 
1463         return (prop.challengeID > 0 && challenge.resolved == false && voting.pollEnded(prop.challengeID));
1464     }
1465 
1466     /**
1467     @notice Determines the number of tokens to awarded to the winning party in a challenge
1468     @param _challengeID The challengeID to determine a reward for
1469     */
1470     function challengeWinnerReward(uint _challengeID) public view returns (uint) {
1471         if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1472             // Edge case, nobody voted, give all tokens to the challenger.
1473             return 2 * challenges[_challengeID].stake;
1474         }
1475 
1476         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1477     }
1478 
1479     /**
1480     @notice gets the parameter keyed by the provided name value from the params mapping
1481     @param _name the key whose value is to be determined
1482     */
1483     function get(string _name) public view returns (uint value) {
1484         return params[keccak256(abi.encodePacked(_name))];
1485     }
1486 
1487     /**
1488     @dev                Getter for Challenge tokenClaims mappings
1489     @param _challengeID The challengeID to query
1490     @param _voter       The voter whose claim status to query for the provided challengeID
1491     */
1492     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1493         return challenges[_challengeID].tokenClaims[_voter];
1494     }
1495 
1496     // ----------------
1497     // PRIVATE FUNCTIONS
1498     // ----------------
1499 
1500     /**
1501     @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
1502     @param _propID the proposal ID whose challenge is to be resolved.
1503     */
1504     function resolveChallenge(bytes32 _propID) private {
1505         ParamProposal memory prop = proposals[_propID];
1506         Challenge storage challenge = challenges[prop.challengeID];
1507 
1508         // winner gets back their full staked deposit, and dispensationPct*loser's stake
1509         uint reward = challengeWinnerReward(prop.challengeID);
1510 
1511         challenge.winningTokens = voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
1512         challenge.resolved = true;
1513 
1514         if (voting.isPassed(prop.challengeID)) { // The challenge failed
1515             if(prop.processBy > now) {
1516                 set(prop.name, prop.value);
1517             }
1518             emit _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1519             require(token.transfer(prop.owner, reward));
1520         }
1521         else { // The challenge succeeded or nobody voted
1522             emit _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1523             require(token.transfer(challenges[prop.challengeID].challenger, reward));
1524         }
1525     }
1526 
1527     /**
1528     @dev sets the param keted by the provided name to the provided value
1529     @param _name the name of the param to be set
1530     @param _value the value to set the param to be set
1531     */
1532     function set(string _name, uint _value) private {
1533         params[keccak256(abi.encodePacked(_name))] = _value;
1534     }
1535 }
1536 
1537 
1538 
1539 
1540 contract Registry {
1541 
1542     // ------
1543     // EVENTS
1544     // ------
1545 
1546     event _Application(bytes32 indexed listingHash, uint deposit, uint appEndDate, string data, address indexed applicant);
1547     event _Challenge(bytes32 indexed listingHash, uint challengeID, string data, uint commitEndDate, uint revealEndDate, address indexed challenger);
1548     event _Deposit(bytes32 indexed listingHash, uint added, uint newTotal, address indexed owner);
1549     event _Withdrawal(bytes32 indexed listingHash, uint withdrew, uint newTotal, address indexed owner);
1550     event _ApplicationWhitelisted(bytes32 indexed listingHash);
1551     event _ApplicationRemoved(bytes32 indexed listingHash);
1552     event _ListingRemoved(bytes32 indexed listingHash);
1553     event _ListingWithdrawn(bytes32 indexed listingHash, address indexed owner);
1554     event _TouchAndRemoved(bytes32 indexed listingHash);
1555     event _ChallengeFailed(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1556     event _ChallengeSucceeded(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1557     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
1558     event _ExitInitialized(bytes32 indexed listingHash, uint exitTime, uint exitDelayEndDate, address indexed owner);
1559 
1560     using SafeMath for uint;
1561 
1562     struct Listing {
1563         uint applicationExpiry; // Expiration date of apply stage
1564         bool whitelisted;       // Indicates registry status
1565         address owner;          // Owner of Listing
1566         uint unstakedDeposit;   // Number of tokens in the listing not locked in a challenge
1567         uint challengeID;       // Corresponds to a PollID in PLCRVoting
1568 	uint exitTime;		// Time the listing may leave the registry
1569         uint exitTimeExpiry;    // Expiration date of exit period
1570     }
1571 
1572     struct Challenge {
1573         uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
1574         address challenger;     // Owner of Challenge
1575         bool resolved;          // Indication of if challenge is resolved
1576         uint stake;             // Number of tokens at stake for either party during challenge
1577         uint totalTokens;       // (remaining) Number of tokens used in voting by the winning side
1578         mapping(address => bool) tokenClaims; // Indicates whether a voter has claimed a reward yet
1579     }
1580 
1581     // Maps challengeIDs to associated challenge data
1582     mapping(uint => Challenge) public challenges;
1583 
1584     // Maps listingHashes to associated listingHash data
1585     mapping(bytes32 => Listing) public listings;
1586 
1587     // Global Variables
1588     EIP20Interface public token;
1589     PLCRVoting public voting;
1590     Parameterizer public parameterizer;
1591     string public name;
1592 
1593     /**
1594     @dev Initializer. Can only be called once.
1595     @param _token The address where the ERC20 token contract is deployed
1596     */
1597     function init(address _token, address _voting, address _parameterizer, string _name) public {
1598         require(_token != 0 && address(token) == 0);
1599         require(_voting != 0 && address(voting) == 0);
1600         require(_parameterizer != 0 && address(parameterizer) == 0);
1601 
1602         token = EIP20Interface(_token);
1603         voting = PLCRVoting(_voting);
1604         parameterizer = Parameterizer(_parameterizer);
1605         name = _name;
1606     }
1607 
1608     // --------------------
1609     // PUBLISHER INTERFACE:
1610     // --------------------
1611 
1612     /**
1613     @dev                Allows a user to start an application. Takes tokens from user and sets
1614                         apply stage end time.
1615     @param _listingHash The hash of a potential listing a user is applying to add to the registry
1616     @param _amount      The number of ERC20 tokens a user is willing to potentially stake
1617     @param _data        Extra data relevant to the application. Think IPFS hashes.
1618     */
1619     function apply(bytes32 _listingHash, uint _amount, string _data) external {
1620         require(!isWhitelisted(_listingHash));
1621         require(!appWasMade(_listingHash));
1622         require(_amount >= parameterizer.get("minDeposit"));
1623 
1624         // Sets owner
1625         Listing storage listing = listings[_listingHash];
1626         listing.owner = msg.sender;
1627 
1628         // Sets apply stage end time
1629         listing.applicationExpiry = block.timestamp.add(parameterizer.get("applyStageLen"));
1630         listing.unstakedDeposit = _amount;
1631 
1632         // Transfers tokens from user to Registry contract
1633         require(token.transferFrom(listing.owner, this, _amount));
1634 
1635         emit _Application(_listingHash, _amount, listing.applicationExpiry, _data, msg.sender);
1636     }
1637 
1638     /**
1639     @dev                Allows the owner of a listingHash to increase their unstaked deposit.
1640     @param _listingHash A listingHash msg.sender is the owner of
1641     @param _amount      The number of ERC20 tokens to increase a user's unstaked deposit
1642     */
1643     function deposit(bytes32 _listingHash, uint _amount) external {
1644         Listing storage listing = listings[_listingHash];
1645 
1646         require(listing.owner == msg.sender);
1647 
1648         listing.unstakedDeposit += _amount;
1649         require(token.transferFrom(msg.sender, this, _amount));
1650 
1651         emit _Deposit(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1652     }
1653 
1654     /**
1655     @dev                Allows the owner of a listingHash to decrease their unstaked deposit.
1656     @param _listingHash A listingHash msg.sender is the owner of.
1657     @param _amount      The number of ERC20 tokens to withdraw from the unstaked deposit.
1658     */
1659     function withdraw(bytes32 _listingHash, uint _amount) external {
1660         Listing storage listing = listings[_listingHash];
1661 
1662         require(listing.owner == msg.sender);
1663         require(_amount <= listing.unstakedDeposit);
1664         require(listing.unstakedDeposit - _amount >= parameterizer.get("minDeposit"));
1665 
1666         listing.unstakedDeposit -= _amount;
1667         require(token.transfer(msg.sender, _amount));
1668 
1669         emit _Withdrawal(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1670     }
1671 
1672     /**
1673     @dev		Initialize an exit timer for a listing to leave the whitelist
1674     @param _listingHash	A listing hash msg.sender is the owner of
1675     */
1676     function initExit(bytes32 _listingHash) external {
1677         Listing storage listing = listings[_listingHash];
1678 
1679         require(msg.sender == listing.owner);
1680         require(isWhitelisted(_listingHash));
1681         // Cannot exit during ongoing challenge
1682         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1683 
1684         // Ensure user never initializedExit or exitPeriodLen passed
1685         require(listing.exitTime == 0 || now > listing.exitTimeExpiry);
1686 
1687         // Set when the listing may be removed from the whitelist
1688         listing.exitTime = now.add(parameterizer.get("exitTimeDelay"));
1689 	// Set exit period end time
1690 	listing.exitTimeExpiry = listing.exitTime.add(parameterizer.get("exitPeriodLen"));
1691         emit _ExitInitialized(_listingHash, listing.exitTime,
1692             listing.exitTimeExpiry, msg.sender);
1693     }
1694 
1695     /**
1696     @dev		Allow a listing to leave the whitelist
1697     @param _listingHash A listing hash msg.sender is the owner of
1698     */
1699     function finalizeExit(bytes32 _listingHash) external {
1700         Listing storage listing = listings[_listingHash];
1701 
1702         require(msg.sender == listing.owner);
1703         require(isWhitelisted(_listingHash));
1704         // Cannot exit during ongoing challenge
1705         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1706 
1707         // Make sure the exit was initialized
1708         require(listing.exitTime > 0);
1709         // Time to exit has to be after exit delay but before the exitPeriodLen is over
1710 	require(listing.exitTime < now && now < listing.exitTimeExpiry);
1711 
1712         resetListing(_listingHash);
1713         emit _ListingWithdrawn(_listingHash, msg.sender);
1714     }
1715 
1716     // -----------------------
1717     // TOKEN HOLDER INTERFACE:
1718     // -----------------------
1719 
1720     /**
1721     @dev                Starts a poll for a listingHash which is either in the apply stage or
1722                         already in the whitelist. Tokens are taken from the challenger and the
1723                         applicant's deposits are locked.
1724     @param _listingHash The listingHash being challenged, whether listed or in application
1725     @param _data        Extra data relevant to the challenge. Think IPFS hashes.
1726     */
1727     function challenge(bytes32 _listingHash, string _data) external returns (uint challengeID) {
1728         Listing storage listing = listings[_listingHash];
1729         uint minDeposit = parameterizer.get("minDeposit");
1730 
1731         // Listing must be in apply stage or already on the whitelist
1732         require(appWasMade(_listingHash) || listing.whitelisted);
1733         // Prevent multiple challenges
1734         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1735 
1736         if (listing.unstakedDeposit < minDeposit) {
1737             // Not enough tokens, listingHash auto-delisted
1738             resetListing(_listingHash);
1739             emit _TouchAndRemoved(_listingHash);
1740             return 0;
1741         }
1742 
1743         // Starts poll
1744         uint pollID = voting.startPoll(
1745             parameterizer.get("voteQuorum"),
1746             parameterizer.get("commitStageLen"),
1747             parameterizer.get("revealStageLen")
1748         );
1749 
1750         uint oneHundred = 100; // Kludge that we need to use SafeMath
1751         challenges[pollID] = Challenge({
1752             challenger: msg.sender,
1753             rewardPool: ((oneHundred.sub(parameterizer.get("dispensationPct"))).mul(minDeposit)).div(100),
1754             stake: minDeposit,
1755             resolved: false,
1756             totalTokens: 0
1757         });
1758 
1759         // Updates listingHash to store most recent challenge
1760         listing.challengeID = pollID;
1761 
1762         // Locks tokens for listingHash during challenge
1763         listing.unstakedDeposit -= minDeposit;
1764 
1765         // Takes tokens from challenger
1766         require(token.transferFrom(msg.sender, this, minDeposit));
1767 
1768         (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
1769 
1770         emit _Challenge(_listingHash, pollID, _data, commitEndDate, revealEndDate, msg.sender);
1771         return pollID;
1772     }
1773 
1774     /**
1775     @dev                Updates a listingHash's status from 'application' to 'listing' or resolves
1776                         a challenge if one exists.
1777     @param _listingHash The listingHash whose status is being updated
1778     */
1779     function updateStatus(bytes32 _listingHash) public {
1780         if (canBeWhitelisted(_listingHash)) {
1781             whitelistApplication(_listingHash);
1782         } else if (challengeCanBeResolved(_listingHash)) {
1783             resolveChallenge(_listingHash);
1784         } else {
1785             revert();
1786         }
1787     }
1788 
1789     /**
1790     @dev                  Updates an array of listingHashes' status from 'application' to 'listing' or resolves
1791                           a challenge if one exists.
1792     @param _listingHashes The listingHashes whose status are being updated
1793     */
1794     function updateStatuses(bytes32[] _listingHashes) public {
1795         // loop through arrays, revealing each individual vote values
1796         for (uint i = 0; i < _listingHashes.length; i++) {
1797             updateStatus(_listingHashes[i]);
1798         }
1799     }
1800 
1801     // ----------------
1802     // TOKEN FUNCTIONS:
1803     // ----------------
1804 
1805     /**
1806     @dev                Called by a voter to claim their reward for each completed vote. Someone
1807                         must call updateStatus() before this can be called.
1808     @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
1809     */
1810     function claimReward(uint _challengeID) public {
1811         Challenge storage challengeInstance = challenges[_challengeID];
1812         // Ensures the voter has not already claimed tokens and challengeInstance results have
1813         // been processed
1814         require(challengeInstance.tokenClaims[msg.sender] == false);
1815         require(challengeInstance.resolved == true);
1816 
1817         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID);
1818         uint reward = voterTokens.mul(challengeInstance.rewardPool)
1819                       .div(challengeInstance.totalTokens);
1820 
1821         // Subtracts the voter's information to preserve the participation ratios
1822         // of other voters compared to the remaining pool of rewards
1823         challengeInstance.totalTokens -= voterTokens;
1824         challengeInstance.rewardPool -= reward;
1825 
1826         // Ensures a voter cannot claim tokens again
1827         challengeInstance.tokenClaims[msg.sender] = true;
1828 
1829         require(token.transfer(msg.sender, reward));
1830 
1831         emit _RewardClaimed(_challengeID, reward, msg.sender);
1832     }
1833 
1834     /**
1835     @dev                 Called by a voter to claim their rewards for each completed vote. Someone
1836                          must call updateStatus() before this can be called.
1837     @param _challengeIDs The PLCR pollIDs of the challenges rewards are being claimed for
1838     */
1839     function claimRewards(uint[] _challengeIDs) public {
1840         // loop through arrays, claiming each individual vote reward
1841         for (uint i = 0; i < _challengeIDs.length; i++) {
1842             claimReward(_challengeIDs[i]);
1843         }
1844     }
1845 
1846     // --------
1847     // GETTERS:
1848     // --------
1849 
1850     /**
1851     @dev                Calculates the provided voter's token reward for the given poll.
1852     @param _voter       The address of the voter whose reward balance is to be returned
1853     @param _challengeID The pollID of the challenge a reward balance is being queried for
1854     @return             The uint indicating the voter's reward
1855     */
1856     function voterReward(address _voter, uint _challengeID)
1857     public view returns (uint) {
1858         uint totalTokens = challenges[_challengeID].totalTokens;
1859         uint rewardPool = challenges[_challengeID].rewardPool;
1860         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID);
1861         return voterTokens.mul(rewardPool).div(totalTokens);
1862     }
1863 
1864     /**
1865     @dev                Determines whether the given listingHash be whitelisted.
1866     @param _listingHash The listingHash whose status is to be examined
1867     */
1868     function canBeWhitelisted(bytes32 _listingHash) view public returns (bool) {
1869         uint challengeID = listings[_listingHash].challengeID;
1870 
1871         // Ensures that the application was made,
1872         // the application period has ended,
1873         // the listingHash can be whitelisted,
1874         // and either: the challengeID == 0, or the challenge has been resolved.
1875         if (
1876             appWasMade(_listingHash) &&
1877             listings[_listingHash].applicationExpiry < now &&
1878             !isWhitelisted(_listingHash) &&
1879             (challengeID == 0 || challenges[challengeID].resolved == true)
1880         ) { return true; }
1881 
1882         return false;
1883     }
1884 
1885     /**
1886     @dev                Returns true if the provided listingHash is whitelisted
1887     @param _listingHash The listingHash whose status is to be examined
1888     */
1889     function isWhitelisted(bytes32 _listingHash) view public returns (bool whitelisted) {
1890         return listings[_listingHash].whitelisted;
1891     }
1892 
1893     /**
1894     @dev                Returns true if apply was called for this listingHash
1895     @param _listingHash The listingHash whose status is to be examined
1896     */
1897     function appWasMade(bytes32 _listingHash) view public returns (bool exists) {
1898         return listings[_listingHash].applicationExpiry > 0;
1899     }
1900 
1901     /**
1902     @dev                Returns true if the application/listingHash has an unresolved challenge
1903     @param _listingHash The listingHash whose status is to be examined
1904     */
1905     function challengeExists(bytes32 _listingHash) view public returns (bool) {
1906         uint challengeID = listings[_listingHash].challengeID;
1907 
1908         return (listings[_listingHash].challengeID > 0 && !challenges[challengeID].resolved);
1909     }
1910 
1911     /**
1912     @dev                Determines whether voting has concluded in a challenge for a given
1913                         listingHash. Throws if no challenge exists.
1914     @param _listingHash A listingHash with an unresolved challenge
1915     */
1916     function challengeCanBeResolved(bytes32 _listingHash) view public returns (bool) {
1917         uint challengeID = listings[_listingHash].challengeID;
1918 
1919         require(challengeExists(_listingHash));
1920 
1921         return voting.pollEnded(challengeID);
1922     }
1923 
1924     /**
1925     @dev                Determines the number of tokens awarded to the winning party in a challenge.
1926     @param _challengeID The challengeID to determine a reward for
1927     */
1928     function determineReward(uint _challengeID) public view returns (uint) {
1929         require(!challenges[_challengeID].resolved && voting.pollEnded(_challengeID));
1930 
1931         // Edge case, nobody voted, give all tokens to the challenger.
1932         if (voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1933             return 2 * challenges[_challengeID].stake;
1934         }
1935 
1936         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1937     }
1938 
1939     /**
1940     @dev                Getter for Challenge tokenClaims mappings
1941     @param _challengeID The challengeID to query
1942     @param _voter       The voter whose claim status to query for the provided challengeID
1943     */
1944     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1945         return challenges[_challengeID].tokenClaims[_voter];
1946     }
1947 
1948     // ----------------
1949     // PRIVATE FUNCTIONS:
1950     // ----------------
1951 
1952     /**
1953     @dev                Determines the winner in a challenge. Rewards the winner tokens and
1954                         either whitelists or de-whitelists the listingHash.
1955     @param _listingHash A listingHash with a challenge that is to be resolved
1956     */
1957     function resolveChallenge(bytes32 _listingHash) private {
1958         uint challengeID = listings[_listingHash].challengeID;
1959 
1960         // Calculates the winner's reward,
1961         // which is: (winner's full stake) + (dispensationPct * loser's stake)
1962         uint reward = determineReward(challengeID);
1963 
1964         // Sets flag on challenge being processed
1965         challenges[challengeID].resolved = true;
1966 
1967         // Stores the total tokens used for voting by the winning side for reward purposes
1968         challenges[challengeID].totalTokens =
1969             voting.getTotalNumberOfTokensForWinningOption(challengeID);
1970 
1971         // Case: challenge failed
1972         if (voting.isPassed(challengeID)) {
1973             whitelistApplication(_listingHash);
1974             // Unlock stake so that it can be retrieved by the applicant
1975             listings[_listingHash].unstakedDeposit += reward;
1976 
1977             emit _ChallengeFailed(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1978         }
1979         // Case: challenge succeeded or nobody voted
1980         else {
1981             resetListing(_listingHash);
1982             // Transfer the reward to the challenger
1983             require(token.transfer(challenges[challengeID].challenger, reward));
1984 
1985             emit _ChallengeSucceeded(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
1986         }
1987     }
1988 
1989     /**
1990     @dev                Called by updateStatus() if the applicationExpiry date passed without a
1991                         challenge being made. Called by resolveChallenge() if an
1992                         application/listing beat a challenge.
1993     @param _listingHash The listingHash of an application/listingHash to be whitelisted
1994     */
1995     function whitelistApplication(bytes32 _listingHash) private {
1996         if (!listings[_listingHash].whitelisted) { emit _ApplicationWhitelisted(_listingHash); }
1997         listings[_listingHash].whitelisted = true;
1998     }
1999 
2000     /**
2001     @dev                Deletes a listingHash from the whitelist and transfers tokens back to owner
2002     @param _listingHash The listing hash to delete
2003     */
2004     function resetListing(bytes32 _listingHash) private {
2005         Listing storage listing = listings[_listingHash];
2006 
2007         // Emit events before deleting listing to check whether is whitelisted
2008         if (listing.whitelisted) {
2009             emit _ListingRemoved(_listingHash);
2010         } else {
2011             emit _ApplicationRemoved(_listingHash);
2012         }
2013 
2014         // Deleting listing to prevent reentry
2015         address owner = listing.owner;
2016         uint unstakedDeposit = listing.unstakedDeposit;
2017         delete listings[_listingHash];
2018 
2019         // Transfers any remaining balance back to the owner
2020         if (unstakedDeposit > 0){
2021             require(token.transfer(owner, unstakedDeposit));
2022         }
2023     }
2024 }
2025 
2026 
2027 /***************************************************************************************************
2028 *                                                                                                  *
2029 * (c) 2019 Quantstamp, Inc. This content and its use are governed by the license terms at          *
2030 * <https://github.com/quantstamp/qsp-protocol-node/blob/develop/LICENSE>                           *
2031 *                                                                                                  *
2032 ***************************************************************************************************/
2033 
2034 
2035 
2036  // Imports PLCRVoting and SafeMath
2037 
2038 
2039 
2040 
2041 
2042 
2043 
2044 
2045 
2046 /**
2047  * @title Basic token
2048  * @dev Basic version of StandardToken, with no allowances.
2049  */
2050 contract BasicToken is ERC20Basic {
2051   using SafeMath for uint256;
2052 
2053   mapping(address => uint256) balances;
2054 
2055   uint256 totalSupply_;
2056 
2057   /**
2058   * @dev total number of tokens in existence
2059   */
2060   function totalSupply() public view returns (uint256) {
2061     return totalSupply_;
2062   }
2063 
2064   /**
2065   * @dev transfer token for a specified address
2066   * @param _to The address to transfer to.
2067   * @param _value The amount to be transferred.
2068   */
2069   function transfer(address _to, uint256 _value) public returns (bool) {
2070     require(_to != address(0));
2071     require(_value <= balances[msg.sender]);
2072 
2073     balances[msg.sender] = balances[msg.sender].sub(_value);
2074     balances[_to] = balances[_to].add(_value);
2075     emit Transfer(msg.sender, _to, _value);
2076     return true;
2077   }
2078 
2079   /**
2080   * @dev Gets the balance of the specified address.
2081   * @param _owner The address to query the the balance of.
2082   * @return An uint256 representing the amount owned by the passed address.
2083   */
2084   function balanceOf(address _owner) public view returns (uint256) {
2085     return balances[_owner];
2086   }
2087 
2088 }
2089 
2090 
2091 
2092 
2093 
2094 
2095 /**
2096  * @title ERC20 interface
2097  * @dev see https://github.com/ethereum/EIPs/issues/20
2098  */
2099 contract ERC20 is ERC20Basic {
2100   function allowance(address owner, address spender)
2101     public view returns (uint256);
2102 
2103   function transferFrom(address from, address to, uint256 value)
2104     public returns (bool);
2105 
2106   function approve(address spender, uint256 value) public returns (bool);
2107   event Approval(
2108     address indexed owner,
2109     address indexed spender,
2110     uint256 value
2111   );
2112 }
2113 
2114 
2115 
2116 /**
2117  * @title Standard ERC20 token
2118  *
2119  * @dev Implementation of the basic standard token.
2120  * @dev https://github.com/ethereum/EIPs/issues/20
2121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
2122  */
2123 contract StandardToken is ERC20, BasicToken {
2124 
2125   mapping (address => mapping (address => uint256)) internal allowed;
2126 
2127 
2128   /**
2129    * @dev Transfer tokens from one address to another
2130    * @param _from address The address which you want to send tokens from
2131    * @param _to address The address which you want to transfer to
2132    * @param _value uint256 the amount of tokens to be transferred
2133    */
2134   function transferFrom(
2135     address _from,
2136     address _to,
2137     uint256 _value
2138   )
2139     public
2140     returns (bool)
2141   {
2142     require(_to != address(0));
2143     require(_value <= balances[_from]);
2144     require(_value <= allowed[_from][msg.sender]);
2145 
2146     balances[_from] = balances[_from].sub(_value);
2147     balances[_to] = balances[_to].add(_value);
2148     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
2149     emit Transfer(_from, _to, _value);
2150     return true;
2151   }
2152 
2153   /**
2154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
2155    *
2156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
2157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
2158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
2159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2160    * @param _spender The address which will spend the funds.
2161    * @param _value The amount of tokens to be spent.
2162    */
2163   function approve(address _spender, uint256 _value) public returns (bool) {
2164     allowed[msg.sender][_spender] = _value;
2165     emit Approval(msg.sender, _spender, _value);
2166     return true;
2167   }
2168 
2169   /**
2170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
2171    * @param _owner address The address which owns the funds.
2172    * @param _spender address The address which will spend the funds.
2173    * @return A uint256 specifying the amount of tokens still available for the spender.
2174    */
2175   function allowance(
2176     address _owner,
2177     address _spender
2178    )
2179     public
2180     view
2181     returns (uint256)
2182   {
2183     return allowed[_owner][_spender];
2184   }
2185 
2186   /**
2187    * @dev Increase the amount of tokens that an owner allowed to a spender.
2188    *
2189    * approve should be called when allowed[_spender] == 0. To increment
2190    * allowed value is better to use this function to avoid 2 calls (and wait until
2191    * the first transaction is mined)
2192    * From MonolithDAO Token.sol
2193    * @param _spender The address which will spend the funds.
2194    * @param _addedValue The amount of tokens to increase the allowance by.
2195    */
2196   function increaseApproval(
2197     address _spender,
2198     uint _addedValue
2199   )
2200     public
2201     returns (bool)
2202   {
2203     allowed[msg.sender][_spender] = (
2204       allowed[msg.sender][_spender].add(_addedValue));
2205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
2206     return true;
2207   }
2208 
2209   /**
2210    * @dev Decrease the amount of tokens that an owner allowed to a spender.
2211    *
2212    * approve should be called when allowed[_spender] == 0. To decrement
2213    * allowed value is better to use this function to avoid 2 calls (and wait until
2214    * the first transaction is mined)
2215    * From MonolithDAO Token.sol
2216    * @param _spender The address which will spend the funds.
2217    * @param _subtractedValue The amount of tokens to decrease the allowance by.
2218    */
2219   function decreaseApproval(
2220     address _spender,
2221     uint _subtractedValue
2222   )
2223     public
2224     returns (bool)
2225   {
2226     uint oldValue = allowed[msg.sender][_spender];
2227     if (_subtractedValue > oldValue) {
2228       allowed[msg.sender][_spender] = 0;
2229     } else {
2230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
2231     }
2232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
2233     return true;
2234   }
2235 
2236 }
2237 
2238 
2239 
2240 
2241 
2242 
2243 
2244 
2245 /**
2246  * @title Whitelist
2247  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
2248  * @dev This simplifies the implementation of "user permissions".
2249  */
2250 contract Whitelist is Ownable, RBAC {
2251   event WhitelistedAddressAdded(address addr);
2252   event WhitelistedAddressRemoved(address addr);
2253 
2254   string public constant ROLE_WHITELISTED = "whitelist";
2255 
2256   /**
2257    * @dev Throws if called by any account that's not whitelisted.
2258    */
2259   modifier onlyWhitelisted() {
2260     checkRole(msg.sender, ROLE_WHITELISTED);
2261     _;
2262   }
2263 
2264   /**
2265    * @dev add an address to the whitelist
2266    * @param addr address
2267    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
2268    */
2269   function addAddressToWhitelist(address addr)
2270     onlyOwner
2271     public
2272   {
2273     addRole(addr, ROLE_WHITELISTED);
2274     emit WhitelistedAddressAdded(addr);
2275   }
2276 
2277   /**
2278    * @dev getter to determine if address is in whitelist
2279    */
2280   function whitelist(address addr)
2281     public
2282     view
2283     returns (bool)
2284   {
2285     return hasRole(addr, ROLE_WHITELISTED);
2286   }
2287 
2288   /**
2289    * @dev add addresses to the whitelist
2290    * @param addrs addresses
2291    * @return true if at least one address was added to the whitelist,
2292    * false if all addresses were already in the whitelist
2293    */
2294   function addAddressesToWhitelist(address[] addrs)
2295     onlyOwner
2296     public
2297   {
2298     for (uint256 i = 0; i < addrs.length; i++) {
2299       addAddressToWhitelist(addrs[i]);
2300     }
2301   }
2302 
2303   /**
2304    * @dev remove an address from the whitelist
2305    * @param addr address
2306    * @return true if the address was removed from the whitelist,
2307    * false if the address wasn't in the whitelist in the first place
2308    */
2309   function removeAddressFromWhitelist(address addr)
2310     onlyOwner
2311     public
2312   {
2313     removeRole(addr, ROLE_WHITELISTED);
2314     emit WhitelistedAddressRemoved(addr);
2315   }
2316 
2317   /**
2318    * @dev remove addresses from the whitelist
2319    * @param addrs addresses
2320    * @return true if at least one address was removed from the whitelist,
2321    * false if all addresses weren't in the whitelist in the first place
2322    */
2323   function removeAddressesFromWhitelist(address[] addrs)
2324     onlyOwner
2325     public
2326   {
2327     for (uint256 i = 0; i < addrs.length; i++) {
2328       removeAddressFromWhitelist(addrs[i]);
2329     }
2330   }
2331 
2332 }
2333 
2334 
2335 contract QuantstampBountyData is Whitelist {
2336 
2337   using SafeMath for uint256;
2338   using LinkedListLib for LinkedListLib.LinkedList;
2339 
2340   // constants used by LinkedListLib
2341   uint256 constant internal NULL = 0;
2342   uint256 constant internal HEAD = 0;
2343   bool constant internal PREV = false;
2344   bool constant internal NEXT = true;
2345 
2346 
2347   uint256 constant internal NUMBER_OF_PHASES = 3;
2348 
2349   struct Bounty {
2350     address submitter;
2351     string contractAddress;
2352     uint256 size; // R1
2353     uint256 minVotes; // R3
2354     uint256 duration; // R2. Number of seconds
2355     uint256 judgeDeposit; // R5
2356     uint256 hunterDeposit; // R6
2357     uint256 initiationTimestamp; // Time in seconds that the bounty is created
2358     bool remainingFeesWithdrawn; // true if the remaining fees have been withdrawn by the submitter
2359     uint256 numApprovedBugs;
2360   }
2361 
2362   // holds information about a revealed bug
2363   struct Bug {
2364     address hunter; // address that submitted the hash
2365     uint256 bountyId; // the ID of the associated bounty
2366     string bugDescription; // the description of the bug
2367     uint256 numTokens; // the number of tokens staked on the commit
2368     uint256 pollId; // the poll that decided on the validity of the bug
2369   }
2370 
2371   // holds information relevant to a bug commit
2372   struct BugCommit {
2373     address hunter;  // address that submitted the hash
2374     uint256 bountyId;  // the ID of the associated bounty
2375     bytes32 bugDescriptionHash;  // keccak256 hash of the bug
2376     uint256 commitTimestamp;  // Time in seconds that the bug commit occurred
2377     uint256 revealStartTimestamp;  // Time in seconds when the the reveal phase starts
2378     uint256 revealEndTimestamp;  // Time in seconds when the the reveal phase ends
2379     uint256 numTokens;  // the number of tokens staked on the commit
2380   }
2381 
2382   mapping (uint256 => Bounty) public bounties;
2383 
2384   // maps pollIds back to bugIds
2385   mapping (uint256 => uint256) public pollIdToBugId;
2386 
2387   // For generating bountyIDs starting from 1
2388   uint256 private bountyCounter;
2389 
2390   // For generating bugIDs starting from 1
2391   uint256 private bugCounter;
2392 
2393   // token used to pay for participants in a bounty. This contract assumes that the owner of the contract
2394   // trusts token's code and that transfer function (such as transferFrom, transfer) do the right thing
2395   StandardToken public token;
2396 
2397   // The partial-locking commit-reveal voting interface used by the TCR to determine the validity of bugs
2398   RestrictedPLCRVoting public voting;
2399 
2400   // The underlying contract to hold PLCR voting parameters
2401   Parameterizer public parameterizer;
2402 
2403   // Recording reported bugs not yet awarded for each hunter
2404   mapping (address => LinkedListLib.LinkedList) private hunterReportedBugs;
2405   mapping (address => uint256) public hunterReportedBugsCount;
2406 
2407   /**
2408    * @dev The constructor creates a QuantstampBountyData contract.
2409    * @param tokenAddress The address of a StandardToken that will be used to pay auditor nodes.
2410    */
2411   constructor (address tokenAddress, address votingAddress, address parameterizerAddress) public {
2412     require(tokenAddress != address(0));
2413     require(votingAddress != address(0));
2414     require(parameterizerAddress != address(0));
2415     token = StandardToken(tokenAddress);
2416     voting = RestrictedPLCRVoting(votingAddress);
2417     parameterizer = Parameterizer(parameterizerAddress);
2418   }
2419 
2420   // maps bountyIDs to list of corresponding bugIDs
2421   // each list contains all revealed bugs for a given bounty, ordered by time
2422   // NOTE: this cannot be part of the Bounty struct due to solidity limitations
2423   mapping(uint256 => LinkedListLib.LinkedList) private bugLists;
2424 
2425   // maps bugIDs to BugCommits
2426   mapping(uint256 => BugCommit) public bugCommitMap;
2427 
2428   // maps bugIDs to revealed bugs; uses the same ID as the bug commit
2429   mapping(uint256 => Bug) public bugs;
2430 
2431   function addBugCommitment(address hunter,
2432                             uint256 bountyId,
2433                             bytes32 bugDescriptionHash,
2434                             uint256 hunterDeposit) public onlyWhitelisted returns (uint256) {
2435     bugCounter = bugCounter.add(1);
2436     bugCommitMap[bugCounter] = BugCommit({
2437       hunter: hunter,
2438       bountyId: bountyId,
2439       bugDescriptionHash: bugDescriptionHash,
2440       commitTimestamp: block.timestamp,
2441       revealStartTimestamp: getBountyRevealPhaseStartTimestamp(bountyId),
2442       revealEndTimestamp: getBountyRevealPhaseEndTimestamp(bountyId),
2443       numTokens: hunterDeposit
2444     });
2445     return bugCounter;
2446   }
2447 
2448   function addBug(uint256 bugId, string bugDescription, uint256 pollId) public onlyWhitelisted returns (bool) {
2449     // create a Bug
2450     bugs[bugId] = Bug({
2451       hunter: bugCommitMap[bugId].hunter,
2452       bountyId: bugCommitMap[bugId].bountyId,
2453       bugDescription: bugDescription,
2454       numTokens: bugCommitMap[bugId].numTokens,
2455       pollId: pollId
2456     });
2457     // add pointer to it in the corresponding bounty
2458     bugLists[bugCommitMap[bugId].bountyId].push(bugId, PREV);
2459     pollIdToBugId[pollId] = bugId;
2460     return true;
2461   }
2462 
2463   function addBounty (address submitter,
2464                       string contractAddress,
2465                       uint256 size,
2466                       uint256 minVotes,
2467                       uint256 duration,
2468                       uint256 judgeDeposit,
2469                       uint256 hunterDeposit) public onlyWhitelisted returns(uint256) {
2470     bounties[++bountyCounter] = Bounty(submitter,
2471                                         contractAddress,
2472                                         size,
2473                                         minVotes,
2474                                         duration,
2475                                         judgeDeposit,
2476                                         hunterDeposit,
2477                                         block.timestamp,
2478                                         false,
2479                                         0);
2480     return bountyCounter;
2481   }
2482 
2483   function removeBugCommitment(uint256 bugId) public onlyWhitelisted returns (bool) {
2484     delete bugCommitMap[bugId];
2485     return true;
2486   }
2487 
2488   /**
2489    * @dev Sets a new value for the number of approved bugs, if appropriate
2490    * @param pollId The ID of the poll being that a vote was received for
2491    * @param wasPassing true if and only if more affirmative votes prior to this vote
2492    * @param isPassing true if and only if more affirmative votes after this vote
2493    * @param wasEnoughVotes true if and only if quorum was reached prior to this vote
2494    */
2495   function updateNumApprovedBugs(uint256 pollId, bool wasPassing, bool isPassing, bool wasEnoughVotes) public {
2496     require(msg.sender == address(voting));
2497     uint256 bountyId = getBugBountyId(getBugIdFromPollId(pollId));
2498 
2499     if (wasEnoughVotes) {
2500       if (!wasPassing && isPassing) {
2501         bounties[bountyId].numApprovedBugs = bounties[bountyId].numApprovedBugs.add(1);
2502       } else if (wasPassing && !isPassing) {
2503         bounties[bountyId].numApprovedBugs = bounties[bountyId].numApprovedBugs.sub(1);
2504       }
2505     } else if (voting.isEnoughVotes(pollId) && isPassing) {
2506       bounties[bountyId].numApprovedBugs = bounties[bountyId].numApprovedBugs.add(1);
2507     }
2508   }
2509 
2510   /**
2511    * @dev Reports the number of approved bugs of a bounty
2512    * @param bountyId The ID of the bounty.
2513    */
2514   function getNumApprovedBugs(uint256 bountyId) public view returns (uint256) {
2515     return bounties[bountyId].numApprovedBugs;
2516   }
2517 
2518   /**
2519    * @dev Sets remainingFeesWithdrawn to true after the submitter withdraws.
2520    * @param bountyId The ID of the bounty.
2521    */
2522   function setBountyRemainingFeesWithdrawn (uint256 bountyId) public onlyWhitelisted {
2523     bounties[bountyId].remainingFeesWithdrawn = true;
2524   }
2525 
2526   function addBugToHunter (address hunter, uint256 bugId) public onlyWhitelisted {
2527     hunterReportedBugs[hunter].push(bugId, PREV);
2528     hunterReportedBugsCount[hunter] = hunterReportedBugsCount[hunter].add(1);
2529   }
2530 
2531   function removeBugFromHunter (address hunter, uint256 bugId) public onlyWhitelisted returns (bool) {
2532     if (hunterReportedBugs[hunter].remove(bugId) != 0) {
2533       hunterReportedBugsCount[hunter] = hunterReportedBugsCount[hunter].sub(1);
2534       bugs[bugId].hunter = 0x0;
2535       return true;
2536     }
2537     return false;
2538   }
2539 
2540   function getListHeadConstant () public pure returns(uint256 head) {
2541     return HEAD;
2542   }
2543 
2544   function getBountySubmitter (uint256 bountyId) public view returns(address) {
2545     return bounties[bountyId].submitter;
2546   }
2547 
2548   function getBountyContractAddress (uint256 bountyId) public view returns(string) {
2549     return bounties[bountyId].contractAddress;
2550   }
2551 
2552   function getBountySize (uint256 bountyId) public view returns(uint256) {
2553     return bounties[bountyId].size;
2554   }
2555 
2556   function getBountyMinVotes (uint256 bountyId) public view returns(uint256) {
2557     return bounties[bountyId].minVotes;
2558   }
2559 
2560   function getBountyDuration (uint256 bountyId) public view returns(uint256) {
2561     return bounties[bountyId].duration;
2562   }
2563 
2564   function getBountyJudgeDeposit (uint256 bountyId) public view returns(uint256) {
2565     return bounties[bountyId].judgeDeposit;
2566   }
2567 
2568   function getBountyHunterDeposit (uint256 bountyId) public view returns(uint256) {
2569     return bounties[bountyId].hunterDeposit;
2570   }
2571 
2572   function getBountyInitiationTimestamp (uint256 bountyId) public view returns(uint256) {
2573     return bounties[bountyId].initiationTimestamp;
2574   }
2575 
2576   function getBountyCommitPhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2577     return bounties[bountyId].initiationTimestamp.add(getBountyDuration(bountyId).div(NUMBER_OF_PHASES));
2578   }
2579 
2580   function getBountyRevealPhaseStartTimestamp (uint256 bountyId) public view returns(uint256) {
2581     return getBountyCommitPhaseEndTimestamp(bountyId).add(1);
2582   }
2583 
2584   function getBountyRevealPhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2585     return getBountyCommitPhaseEndTimestamp(bountyId).add(getBountyDuration(bountyId).div(NUMBER_OF_PHASES));
2586   }
2587 
2588   function getBountyJudgePhaseStartTimestamp (uint256 bountyId) public view returns(uint256) {
2589     return getBountyRevealPhaseEndTimestamp(bountyId).add(1);
2590   }
2591 
2592   function getBountyJudgePhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2593     return bounties[bountyId].initiationTimestamp.add(getBountyDuration(bountyId));
2594   }
2595 
2596   function getBountyJudgeCommitPhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2597     uint256 judgePhaseDuration = getBountyDuration(bountyId).div(NUMBER_OF_PHASES);
2598     return getBountyJudgePhaseStartTimestamp(bountyId).add(judgePhaseDuration.div(2));
2599   }
2600 
2601   function getBountyJudgeRevealDuration (uint256 bountyId) public view returns(uint256) {
2602     return getBountyJudgePhaseEndTimestamp(bountyId).sub(getBountyJudgeCommitPhaseEndTimestamp(bountyId));
2603   }
2604 
2605   function isCommitPeriod (uint256 bountyId) public view returns(bool) {
2606     return block.timestamp >= bounties[bountyId].initiationTimestamp && block.timestamp <= getBountyCommitPhaseEndTimestamp(bountyId);
2607   }
2608 
2609   function isRevealPeriod (uint256 bountyId) public view returns(bool) {
2610     return block.timestamp >= getBountyRevealPhaseStartTimestamp(bountyId) && block.timestamp <= getBountyRevealPhaseEndTimestamp(bountyId);
2611   }
2612 
2613   function isJudgingPeriod (uint256 bountyId) public view returns(bool) {
2614     return block.timestamp >= getBountyJudgePhaseStartTimestamp(bountyId) && block.timestamp <= getBountyJudgePhaseEndTimestamp(bountyId);
2615   }
2616 
2617   function getBountyRemainingFeesWithdrawn (uint256 bountyId) public view returns(bool) {
2618     return bounties[bountyId].remainingFeesWithdrawn;
2619   }
2620 
2621   function getBugCommitCommitter(uint256 bugCommitId) public view returns (address) {
2622     return bugCommitMap[bugCommitId].hunter;
2623   }
2624 
2625   function getBugCommitBountyId(uint256 bugCommitId) public view returns (uint256) {
2626     return bugCommitMap[bugCommitId].bountyId;
2627   }
2628 
2629   function getBugCommitBugDescriptionHash(uint256 bugCommitId) public view returns (bytes32) {
2630     return bugCommitMap[bugCommitId].bugDescriptionHash;
2631   }
2632 
2633   function getBugCommitCommitTimestamp(uint256 bugCommitId) public view returns (uint256) {
2634     return bugCommitMap[bugCommitId].commitTimestamp;
2635   }
2636 
2637   function getBugCommitRevealStartTimestamp(uint256 bugCommitId) public view returns (uint256) {
2638     return bugCommitMap[bugCommitId].revealStartTimestamp;
2639   }
2640 
2641   function getBugCommitRevealEndTimestamp(uint256 bugCommitId) public view returns (uint256) {
2642     return bugCommitMap[bugCommitId].revealEndTimestamp;
2643   }
2644 
2645   function getBugCommitNumTokens(uint256 bugCommitId) public view returns (uint256) {
2646     return bugCommitMap[bugCommitId].numTokens;
2647   }
2648 
2649   function bugRevealPeriodActive(uint256 bugCommitId) public view returns (bool) {
2650     return bugCommitMap[bugCommitId].revealStartTimestamp <= block.timestamp && block.timestamp <= bugCommitMap[bugCommitId].revealEndTimestamp;
2651   }
2652 
2653   function bugRevealPeriodExpired(uint256 bugCommitId) public view returns (bool) {
2654     return block.timestamp > bugCommitMap[bugCommitId].revealEndTimestamp;
2655   }
2656 
2657   function bugRevealDelayPeriodActive(uint256 bugCommitId) public view returns (bool) {
2658     return block.timestamp < bugCommitMap[bugCommitId].revealStartTimestamp;
2659   }
2660 
2661   function bountyActive(uint256 bountyId) public view returns (bool) {
2662     return block.timestamp <= getBountyInitiationTimestamp(bountyId).add(getBountyDuration(bountyId));
2663   }
2664 
2665   function getHunterReportedBugsCount (address hunter) public view returns (uint256) {
2666     return hunterReportedBugsCount[hunter];
2667   }
2668 
2669   // Bug Functions
2670   function getBugBountyId(uint256 bugId) public view returns (uint256) {
2671     return bugs[bugId].bountyId;
2672   }
2673 
2674   function getBugHunter(uint256 bugId) public view returns (address) {
2675     return bugs[bugId].hunter;
2676   }
2677 
2678   function getBugDescription(uint256 bugId) public view returns (string) {
2679     return bugs[bugId].bugDescription;
2680   }
2681 
2682   function getBugNumTokens(uint256 bugId) public view returns (uint256) {
2683     return bugs[bugId].numTokens;
2684   }
2685 
2686   function getBugPollId(uint256 bugId) public view returns (uint256) {
2687     return bugs[bugId].pollId;
2688   }
2689 
2690   function getFirstRevealedBug(uint256 bountyId) public view returns (bool, uint256, string) {
2691     return getNextRevealedBug(bountyId, HEAD);
2692   }
2693 
2694   function getBugIdFromPollId(uint256 pollId) public view returns (uint256) {
2695     return pollIdToBugId[pollId];
2696   }
2697 
2698   /*
2699    * @dev Gets the bug description of a revealed bug associated with a bounty
2700    * @param bountyId The ID of the bounty
2701    * @param previousBugId The ID of the previous bug in the linked list (HEAD for the first bug)
2702    * @return a triple containing 1) whether the bug exists; 2) its bugId (0 if non-existent); 3) the description
2703    */
2704   function getNextRevealedBug(uint256 bountyId, uint256 previousBugId) public view returns (bool, uint256, string) {
2705     if (!bugLists[bountyId].listExists()) {
2706       return (false, 0, "");
2707     }
2708     uint256 bugId;
2709     bool exists;
2710     (exists, bugId) = bugLists[bountyId].getAdjacent(previousBugId, NEXT);
2711     if (!exists || bugId == 0) {
2712       return (false, 0, "");
2713     }
2714     string memory bugDescription = bugs[bugId].bugDescription;
2715     return (true, bugId, bugDescription);
2716   }
2717 
2718   /**
2719    * @dev Given a bugId, it retrieves the next bugId reported by a hunter. Such bugs have not been cashed yet.
2720    * @param hunter The address of a hunter
2721    * @param previousBugId The id of the previous reported bug. Passing 0, it returns the first reported bug.
2722    */
2723   function getNextBugFromHunter(address hunter, uint256 previousBugId) public view returns (bool, uint256) {
2724     if (!hunterReportedBugs[hunter].listExists()) {
2725       return (false, 0);
2726     }
2727     uint256 bugId;
2728     bool exists;
2729     (exists, bugId) = hunterReportedBugs[hunter].getAdjacent(previousBugId, NEXT);
2730     if (!exists || bugId == 0) {
2731       return (false, 0);
2732     }
2733     return (true, bugId);
2734   }
2735 
2736   /**
2737    * @dev Determines if the judge meets the requirements to claim an award for voting in a poll
2738    * @param bugId Id of a bug
2739    * Note: moved to this contract as the Bounty contract was getting too large to deploy
2740    */
2741   function canClaimJudgeAward(address judge, uint256 bugId) public view returns (bool) {
2742     // NOTE: these cannot be a require statement as this check occurs in a loop that should not fail
2743     // the poll has concluded
2744     uint256 pollId = getBugPollId(bugId);
2745     bool pollHasConcluded = voting.pollExists(pollId) && voting.pollEnded(pollId);
2746     // the judge voted in the majority
2747     // this is needed to avoid hitting a require statement when in the minority in PLCRVoting
2748     bool votedWithMajority = pollHasConcluded && voting.isEnoughVotes(pollId) &&
2749       (voting.isPassed(pollId) && voting.hasVotedAffirmatively(judge, pollId) ||
2750       !voting.isPassed(pollId) && !voting.hasVotedAffirmatively(judge, pollId));
2751     // the judge should not have already claimed an award for this poll
2752     bool alreadyClaimed = voting.hasVoterClaimedReward(judge, pollId);
2753     // the bounty should be over
2754     bool bountyStillActive = bountyActive(getBugBountyId(bugId));
2755     return votedWithMajority && !alreadyClaimed && !bountyStillActive;
2756   }
2757 }
2758 
2759 
2760 
2761 
2762 /**
2763 Extends PLCR Voting to have restricted polls that can only be voted on by the TCR.
2764 */
2765 contract RestrictedPLCRVoting is PLCRVoting, Whitelist {
2766 
2767   using SafeMath for uint256;
2768   using LinkedListLib for LinkedListLib.LinkedList;
2769 
2770   // constants used by LinkedListLib
2771   uint256 constant internal NULL = 0;
2772   uint256 constant internal HEAD = 0;
2773   bool constant internal PREV = false;
2774   bool constant internal NEXT = true;
2775 
2776   // TCR used to list judge stakers.
2777   Registry public judgeRegistry;
2778 
2779   QuantstampBountyData public bountyData;
2780 
2781   // Map that contains IDs of restricted polls that can only be voted on by the TCR
2782   mapping(uint256 => bool) isRestrictedPoll;
2783 
2784   // Map from IDs of restricted polls to the minimum number of votes needed for a bug to pass
2785   mapping(uint256 => uint256) minimumVotes;
2786 
2787   // Map from IDs of restricted polls to the amount a judge must deposit to vote
2788   mapping(uint256 => uint256) judgeDeposit;
2789 
2790   // Map from (voter x pollId) -> bool to determine whether a voter has already claimed a reward of a given poll
2791   mapping(address => mapping(uint256 => bool)) private voterHasClaimedReward;
2792 
2793   // Map from (voter x pollId) -> bool indicating whether a voter voted yes (true) or no (false) for a poll.
2794   // Needed due to visibility issues with Poll structs in PLCRVoting
2795   mapping(address => mapping(uint256 => bool)) private votedAffirmatively;
2796 
2797   // Recording polls voted on but not yet awarded for each voter
2798   mapping (address => LinkedListLib.LinkedList) private voterPolls;
2799   mapping (address => uint256) public voterPollsCount;
2800 
2801   event LogPollRestricted(uint256 pollId);
2802 
2803   /**
2804    * @dev Initializer. Can only be called once.
2805    * @param _registry The address of the TCR registry
2806    * @param _token The address of the token
2807    */
2808   function initialize(address _token, address _registry, address _bountyData) public {
2809     require(_token != 0 && address(token) == 0);
2810     require(_registry != 0 && address(judgeRegistry) == 0);
2811     require(_bountyData != 0 && address(bountyData) == 0);
2812     bountyData = QuantstampBountyData(_bountyData);
2813     token = EIP20Interface(_token);
2814     judgeRegistry = Registry(_registry);
2815     pollNonce = INITIAL_POLL_NONCE;
2816   }
2817 
2818   /*
2819    * @dev addr is of type Address which is 20 Bytes, but the TCR expects all
2820    * entries to be of type Bytes32. addr is first cast to Uint256 so that it
2821    * becomes 32 bytes long, addr is then shifted 12 bytes (96 bits) to the
2822    * left so the 20 important bytes are in the correct spot.
2823    * @param addr The address of the person who may be an judge.
2824    * @return true If addr is on the TCR (is an judge)
2825    */
2826   function isJudge(address addr) public view returns(bool) {
2827     return judgeRegistry.isWhitelisted(bytes32(uint256(addr) << 96));
2828   }
2829 
2830   /**
2831    * @dev Set a poll to be restricted to TCR voting
2832    * @param _pollId The ID of the poll
2833    * @param _minimumVotes The minimum number of votes needed for the vote to go through. Each voter counts as 1 vote (not weighted).
2834    * @param _judgeDepositAmount The deposit of a judge to vote
2835    */
2836   function restrictPoll(uint256 _pollId, uint256 _minimumVotes, uint256 _judgeDepositAmount) public onlyWhitelisted {
2837     isRestrictedPoll[_pollId] = true;
2838     minimumVotes[_pollId] = _minimumVotes;
2839     judgeDeposit[_pollId] = _judgeDepositAmount;
2840     emit LogPollRestricted(_pollId);
2841   }
2842 
2843   /**
2844    * @dev Set that a voter has claimed a reward for voting with the majority
2845    * @param _voter The address of the voter
2846    * @param _pollID Integer identifier associated with target poll
2847    */
2848   function setVoterClaimedReward(address _voter, uint256 _pollID) public onlyWhitelisted {
2849     voterHasClaimedReward[_voter][_pollID] = true;
2850   }
2851 
2852   /**
2853    * @dev Determines whether a restricted poll has met the minimum vote requirements
2854    * @param _pollId The ID of the poll
2855    */
2856   function isEnoughVotes(uint256 _pollId) public view returns (bool) {
2857     return pollMap[_pollId].votesFor.add(pollMap[_pollId].votesAgainst) >= minimumVotes[_pollId].mul(judgeDeposit[_pollId]);
2858   }
2859 
2860   // Overridden methods from PLCRVoting. Needed for special requirements of the bounty protocol
2861 
2862   /**
2863   * @dev Overridden Initializer from PLCR Voting. Always reverts to ensure the registry is initialized in the above initialize function.
2864   * @param _token The address of the token
2865   */
2866   function init(address _token) public {
2867     require(false);
2868   }
2869 
2870   /**
2871    * @dev Overrides PLCRVoting to only allow TCR members to vote on restricted votes.
2872    *      Commits vote using hash of choice and secret salt to conceal vote until reveal.
2873    * @param _pollID Integer identifier associated with target poll
2874    * @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
2875    * @param _numTokens The number of tokens to be committed towards the target poll
2876    * @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
2877    */
2878   function commitVote(uint256 _pollID, bytes32 _secretHash, uint256 _numTokens, uint256 _prevPollID) public {
2879     if (isRestrictedPoll[_pollID]) {
2880       require(isJudge(msg.sender));
2881       // Note: The PLCR weights votes by numTokens, so here we use strict equality rather than '>='
2882       // This must be accounted for when tallying votes.
2883       require(_numTokens == judgeDeposit[_pollID]);
2884       require(bountyData.isJudgingPeriod(bountyData.getBugBountyId(bountyData.getBugIdFromPollId(_pollID))));
2885     }
2886     super.commitVote(_pollID, _secretHash, _numTokens, _prevPollID);
2887   }
2888 
2889   /**
2890    * @dev Overrides PLCRVoting to track which polls are associated with a voter.
2891    * @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
2892    * @param _pollID Integer identifier associated with target poll
2893    * @param _voteOption Vote choice used to generate commitHash for associated poll
2894    * @param _salt Secret number used to generate commitHash for associated poll
2895    */
2896   function revealVote(uint256 _pollID, uint256 _voteOption, uint256 _salt) public {
2897     address voter = msg.sender;
2898     // record the vote
2899     if (_voteOption == 1) {
2900       votedAffirmatively[voter][_pollID] = true;
2901     }
2902     // do not allow multiple votes for the same poll
2903     require(!voterPolls[voter].nodeExists(_pollID));
2904     bool wasPassing = isPassing(_pollID);
2905     bool wasEnoughVotes = isEnoughVotes(_pollID);
2906     voterPolls[voter].push(_pollID, PREV);
2907     voterPollsCount[voter] = voterPollsCount[voter].add(1);
2908     super.revealVote(_pollID, _voteOption, _salt);
2909     bool voteIsPassing = isPassing(_pollID);
2910     bountyData.updateNumApprovedBugs(_pollID, wasPassing, voteIsPassing, wasEnoughVotes);
2911   }
2912 
2913   function removePollFromVoter (address _voter, uint256 _pollID) public onlyWhitelisted returns (bool) {
2914     if (voterPolls[_voter].remove(_pollID) != 0) {
2915       voterPollsCount[_voter] = voterPollsCount[_voter] - 1;
2916       return true;
2917     }
2918     return false;
2919   }
2920 
2921   /**
2922    * @dev Determines if proposal has more affirmative votes
2923    *      Check if votesFor out of totalVotes exceeds votesQuorum (does not require pollEnded)
2924    * @param _pollID Integer identifier associated with target poll
2925    */
2926   function isPassing(uint _pollID) public view returns (bool) {
2927     Poll memory poll = pollMap[_pollID];
2928     return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
2929   }
2930 
2931   /**
2932    * @dev Gets the total winning votes for reward distribution purposes.
2933    *      Returns 0 if there were not enough votes.
2934    * @param _pollID Integer identifier associated with target poll
2935    * @return Total number of votes committed to the winning option for specified poll
2936    */
2937   function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint256) {
2938     if (isRestrictedPoll[_pollID] && !isEnoughVotes(_pollID)) {
2939       return 0;
2940     }
2941     return super.getTotalNumberOfTokensForWinningOption(_pollID);
2942   }
2943 
2944   /**
2945    * @dev Gets the number of tokens allocated toward the winning vote for a particular voter.
2946    *      Zero if there were not enough votes for a restricted poll.
2947    * @param _voter Address of voter who voted in the majority bloc
2948    * @param _pollID Integer identifier associated with target poll
2949    * @return correctVotes Number of tokens voted for winning option
2950    */
2951   function getNumPassingTokens(address _voter, uint _pollID) public constant returns (uint256) {
2952     if (isRestrictedPoll[_pollID] && !isEnoughVotes(_pollID)) {
2953       return 0;
2954     }
2955     return super.getNumPassingTokens(_voter, _pollID);
2956   }
2957 
2958   /**
2959    * @dev Determines if proposal has passed
2960    *      Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
2961    * @param _pollID Integer identifier associated with target poll
2962    */
2963   function isPassed(uint _pollID) constant public returns (bool) {
2964     if (isRestrictedPoll[_pollID] && !isEnoughVotes(_pollID)) {
2965       return false;
2966     }
2967     return super.isPassed(_pollID);
2968   }
2969 
2970   /**
2971    * @dev Determines if a voter has already claimed a reward for voting with the majority
2972    * @param _voter The address of the voter
2973    * @param _pollID Integer identifier associated with target poll
2974    */
2975   function hasVoterClaimedReward(address _voter, uint256 _pollID) public view returns (bool) {
2976     return voterHasClaimedReward[_voter][_pollID];
2977   }
2978 
2979   /**
2980    * @dev Determines if a voter voted yes or no for a poll
2981    * @param _voter The address of the voter
2982    * @param _pollID Integer identifier associated with target poll
2983    */
2984   function hasVotedAffirmatively(address _voter, uint256 _pollID) public view returns (bool) {
2985     return votedAffirmatively[_voter][_pollID];
2986   }
2987 
2988   /**
2989    * @dev Returns the number of unclaimed polls associated with the voter.
2990    * @param _voter The address of the voter
2991    */
2992   function getVoterPollsCount (address _voter) public view returns (uint256) {
2993     return voterPollsCount[_voter];
2994   }
2995 
2996   function getListHeadConstant () public pure returns(uint256 head) {
2997     return HEAD;
2998   }
2999 
3000   /**
3001    * @dev Given a pollID, it retrieves the next pollID voted on but unclaimed by the voter.
3002    * @param _voter The address of the voter
3003    * @param _prevPollID The id of the previous unclaimed poll. Passing 0, it returns the first poll.
3004    */
3005   function getNextPollFromVoter(address _voter, uint256 _prevPollID) public view returns (bool, uint256) {
3006     if (!voterPolls[_voter].listExists()) {
3007       return (false, 0);
3008     }
3009     uint256 pollID;
3010     bool exists;
3011     (exists, pollID) = voterPolls[_voter].getAdjacent(_prevPollID, NEXT);
3012     if (!exists || pollID == 0) {
3013       return (false, 0);
3014     }
3015     return (true, pollID);
3016   }
3017 }