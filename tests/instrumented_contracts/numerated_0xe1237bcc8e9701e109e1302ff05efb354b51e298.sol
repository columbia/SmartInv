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
69 
70 /**
71  * @title Roles
72  * @author Francisco Giordano (@frangio)
73  * @dev Library for managing addresses assigned to a Role.
74  *      See RBAC.sol for example usage.
75  */
76 library Roles {
77   struct Role {
78     mapping (address => bool) bearer;
79   }
80 
81   /**
82    * @dev give an address access to this role
83    */
84   function add(Role storage role, address addr)
85     internal
86   {
87     role.bearer[addr] = true;
88   }
89 
90   /**
91    * @dev remove an address' access to this role
92    */
93   function remove(Role storage role, address addr)
94     internal
95   {
96     role.bearer[addr] = false;
97   }
98 
99   /**
100    * @dev check if an address has this role
101    * // reverts
102    */
103   function check(Role storage role, address addr)
104     view
105     internal
106   {
107     require(has(role, addr));
108   }
109 
110   /**
111    * @dev check if an address has this role
112    * @return bool
113    */
114   function has(Role storage role, address addr)
115     view
116     internal
117     returns (bool)
118   {
119     return role.bearer[addr];
120   }
121 }
122 
123 
124 /**
125  * @title LinkedListLib
126  * @author Darryl Morris (o0ragman0o) and Modular.network
127  *
128  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
129  * into the Modular-Network ethereum-libraries repo at https://github.com/Modular-Network/ethereum-libraries
130  * It has been updated to add additional functionality and be more compatible with solidity 0.4.18
131  * coding patterns.
132  *
133  * version 1.1.1
134  * Copyright (c) 2017 Modular Inc.
135  * The MIT License (MIT)
136  * https://github.com/Modular-network/ethereum-libraries/blob/master/LICENSE
137  *
138  * The LinkedListLib provides functionality for implementing data indexing using
139  * a circlular linked list
140  *
141  * Modular provides smart contract services and security reviews for contract
142  * deployments in addition to working on open source projects in the Ethereum
143  * community. Our purpose is to test, document, and deploy reusable code onto the
144  * blockchain and improve both security and usability. We also educate non-profits,
145  * schools, and other community members about the application of blockchain
146  * technology. For further information: modular.network
147  *
148  *
149  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
150  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
151  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
152  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
153  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
154  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
155  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
156 */
157 
158 
159 library LinkedListLib {
160 
161     uint256 constant NULL = 0;
162     uint256 constant HEAD = 0;
163     bool constant PREV = false;
164     bool constant NEXT = true;
165 
166     struct LinkedList{
167         mapping (uint256 => mapping (bool => uint256)) list;
168     }
169 
170     /// @dev returns true if the list exists
171     /// @param self stored linked list from contract
172     function listExists(LinkedList storage self)
173         public
174         view returns (bool)
175     {
176         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
177         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
178             return true;
179         } else {
180             return false;
181         }
182     }
183 
184     /// @dev returns true if the node exists
185     /// @param self stored linked list from contract
186     /// @param _node a node to search for
187     function nodeExists(LinkedList storage self, uint256 _node)
188         public
189         view returns (bool)
190     {
191         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
192             if (self.list[HEAD][NEXT] == _node) {
193                 return true;
194             } else {
195                 return false;
196             }
197         } else {
198             return true;
199         }
200     }
201 
202     /// @dev Returns the number of elements in the list
203     /// @param self stored linked list from contract
204     function sizeOf(LinkedList storage self) public view returns (uint256 numElements) {
205         bool exists;
206         uint256 i;
207         (exists,i) = getAdjacent(self, HEAD, NEXT);
208         while (i != HEAD) {
209             (exists,i) = getAdjacent(self, i, NEXT);
210             numElements++;
211         }
212         return;
213     }
214 
215     /// @dev Returns the links of a node as a tuple
216     /// @param self stored linked list from contract
217     /// @param _node id of the node to get
218     function getNode(LinkedList storage self, uint256 _node)
219         public view returns (bool,uint256,uint256)
220     {
221         if (!nodeExists(self,_node)) {
222             return (false,0,0);
223         } else {
224             return (true,self.list[_node][PREV], self.list[_node][NEXT]);
225         }
226     }
227 
228     /// @dev Returns the link of a node `_node` in direction `_direction`.
229     /// @param self stored linked list from contract
230     /// @param _node id of the node to step from
231     /// @param _direction direction to step in
232     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
233         public view returns (bool,uint256)
234     {
235         if (!nodeExists(self,_node)) {
236             return (false,0);
237         } else {
238             return (true,self.list[_node][_direction]);
239         }
240     }
241 
242     /// @dev Can be used before `insert` to build an ordered list
243     /// @param self stored linked list from contract
244     /// @param _node an existing node to search from, e.g. HEAD.
245     /// @param _value value to seek
246     /// @param _direction direction to seek in
247     //  @return next first node beyond '_node' in direction `_direction`
248     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
249         public view returns (uint256)
250     {
251         if (sizeOf(self) == 0) { return 0; }
252         require((_node == 0) || nodeExists(self,_node));
253         bool exists;
254         uint256 next;
255         (exists,next) = getAdjacent(self, _node, _direction);
256         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
257         return next;
258     }
259 
260     /// @dev Creates a bidirectional link between two nodes on direction `_direction`
261     /// @param self stored linked list from contract
262     /// @param _node first node for linking
263     /// @param _link  node to link to in the _direction
264     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) private  {
265         self.list[_link][!_direction] = _node;
266         self.list[_node][_direction] = _link;
267     }
268 
269     /// @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
270     /// @param self stored linked list from contract
271     /// @param _node existing node
272     /// @param _new  new node to insert
273     /// @param _direction direction to insert node in
274     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) internal returns (bool) {
275         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
276             uint256 c = self.list[_node][_direction];
277             createLink(self, _node, _new, _direction);
278             createLink(self, _new, c, _direction);
279             return true;
280         } else {
281             return false;
282         }
283     }
284 
285     /// @dev removes an entry from the linked list
286     /// @param self stored linked list from contract
287     /// @param _node node to remove from the list
288     function remove(LinkedList storage self, uint256 _node) internal returns (uint256) {
289         if ((_node == NULL) || (!nodeExists(self,_node))) { return 0; }
290         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
291         delete self.list[_node][PREV];
292         delete self.list[_node][NEXT];
293         return _node;
294     }
295 
296     /// @dev pushes an enrty to the head of the linked list
297     /// @param self stored linked list from contract
298     /// @param _node new entry to push to the head
299     /// @param _direction push to the head (NEXT) or tail (PREV)
300     function push(LinkedList storage self, uint256 _node, bool _direction) internal  {
301         insert(self, HEAD, _node, _direction);
302     }
303 
304     /// @dev pops the first entry from the linked list
305     /// @param self stored linked list from contract
306     /// @param _direction pop from the head (NEXT) or the tail (PREV)
307     function pop(LinkedList storage self, bool _direction) internal returns (uint256) {
308         bool exists;
309         uint256 adj;
310 
311         (exists,adj) = getAdjacent(self, HEAD, _direction);
312 
313         return remove(self, adj);
314     }
315 }
316 
317 
318 
319 
320 
321 /**
322  * @title RBAC (Role-Based Access Control)
323  * @author Matt Condon (@Shrugs)
324  * @dev Stores and provides setters and getters for roles and addresses.
325  * @dev Supports unlimited numbers of roles and addresses.
326  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
327  * This RBAC method uses strings to key roles. It may be beneficial
328  *  for you to write your own implementation of this interface using Enums or similar.
329  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
330  *  to avoid typos.
331  */
332 contract RBAC {
333   using Roles for Roles.Role;
334 
335   mapping (string => Roles.Role) private roles;
336 
337   event RoleAdded(address addr, string roleName);
338   event RoleRemoved(address addr, string roleName);
339 
340   /**
341    * @dev reverts if addr does not have role
342    * @param addr address
343    * @param roleName the name of the role
344    * // reverts
345    */
346   function checkRole(address addr, string roleName)
347     view
348     public
349   {
350     roles[roleName].check(addr);
351   }
352 
353   /**
354    * @dev determine if addr has role
355    * @param addr address
356    * @param roleName the name of the role
357    * @return bool
358    */
359   function hasRole(address addr, string roleName)
360     view
361     public
362     returns (bool)
363   {
364     return roles[roleName].has(addr);
365   }
366 
367   /**
368    * @dev add a role to an address
369    * @param addr address
370    * @param roleName the name of the role
371    */
372   function addRole(address addr, string roleName)
373     internal
374   {
375     roles[roleName].add(addr);
376     emit RoleAdded(addr, roleName);
377   }
378 
379   /**
380    * @dev remove a role from an address
381    * @param addr address
382    * @param roleName the name of the role
383    */
384   function removeRole(address addr, string roleName)
385     internal
386   {
387     roles[roleName].remove(addr);
388     emit RoleRemoved(addr, roleName);
389   }
390 
391   /**
392    * @dev modifier to scope access to a single role (uses msg.sender as addr)
393    * @param roleName the name of the role
394    * // reverts
395    */
396   modifier onlyRole(string roleName)
397   {
398     checkRole(msg.sender, roleName);
399     _;
400   }
401 
402   /**
403    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
404    * @param roleNames the names of the roles to scope access to
405    * // reverts
406    *
407    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
408    *  see: https://github.com/ethereum/solidity/issues/2467
409    */
410   // modifier onlyRoles(string[] roleNames) {
411   //     bool hasAnyRole = false;
412   //     for (uint8 i = 0; i < roleNames.length; i++) {
413   //         if (hasRole(msg.sender, roleNames[i])) {
414   //             hasAnyRole = true;
415   //             break;
416   //         }
417   //     }
418 
419   //     require(hasAnyRole);
420 
421   //     _;
422   // }
423 }
424 
425 
426 
427 /**
428  * @title Ownable
429  * @dev The Ownable contract has an owner address, and provides basic authorization control
430  * functions, this simplifies the implementation of "user permissions".
431  */
432 contract Ownable {
433   address public owner;
434 
435 
436   event OwnershipRenounced(address indexed previousOwner);
437   event OwnershipTransferred(
438     address indexed previousOwner,
439     address indexed newOwner
440   );
441 
442 
443   /**
444    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
445    * account.
446    */
447   constructor() public {
448     owner = msg.sender;
449   }
450 
451   /**
452    * @dev Throws if called by any account other than the owner.
453    */
454   modifier onlyOwner() {
455     require(msg.sender == owner);
456     _;
457   }
458 
459   /**
460    * @dev Allows the current owner to relinquish control of the contract.
461    */
462   function renounceOwnership() public onlyOwner {
463     emit OwnershipRenounced(owner);
464     owner = address(0);
465   }
466 
467   /**
468    * @dev Allows the current owner to transfer control of the contract to a newOwner.
469    * @param _newOwner The address to transfer ownership to.
470    */
471   function transferOwnership(address _newOwner) public onlyOwner {
472     _transferOwnership(_newOwner);
473   }
474 
475   /**
476    * @dev Transfers control of the contract to a newOwner.
477    * @param _newOwner The address to transfer ownership to.
478    */
479   function _transferOwnership(address _newOwner) internal {
480     require(_newOwner != address(0));
481     emit OwnershipTransferred(owner, _newOwner);
482     owner = _newOwner;
483   }
484 }
485 // Abstract contract for the full ERC 20 Token standard
486 // https://github.com/ethereum/EIPs/issues/20
487 
488 
489 contract EIP20Interface {
490     /* This is a slight change to the ERC20 base standard.
491     function totalSupply() constant returns (uint256 supply);
492     is replaced with:
493     uint256 public totalSupply;
494     This automatically creates a getter function for the totalSupply.
495     This is moved to the base contract since public getter functions are not
496     currently recognised as an implementation of the matching abstract
497     function by the compiler.
498     */
499     /// total amount of tokens
500     uint256 public totalSupply;
501 
502     /// @param _owner The address from which the balance will be retrieved
503     /// @return The balance
504     function balanceOf(address _owner) public view returns (uint256 balance);
505 
506     /// @notice send `_value` token to `_to` from `msg.sender`
507     /// @param _to The address of the recipient
508     /// @param _value The amount of token to be transferred
509     /// @return Whether the transfer was successful or not
510     function transfer(address _to, uint256 _value) public returns (bool success);
511 
512     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
513     /// @param _from The address of the sender
514     /// @param _to The address of the recipient
515     /// @param _value The amount of token to be transferred
516     /// @return Whether the transfer was successful or not
517     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
518 
519     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
520     /// @param _spender The address of the account able to transfer the tokens
521     /// @param _value The amount of tokens to be approved for transfer
522     /// @return Whether the approval was successful or not
523     function approve(address _spender, uint256 _value) public returns (bool success);
524 
525     /// @param _owner The address of the account owning tokens
526     /// @param _spender The address of the account able to transfer the tokens
527     /// @return Amount of remaining tokens allowed to spent
528     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
529 
530     event Transfer(address indexed _from, address indexed _to, uint256 _value);
531     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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
651 
652 
653 
654 
655 
656 /**
657 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
658 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
659 */
660 contract PLCRVoting {
661 
662     // ============
663     // EVENTS:
664     // ============
665 
666     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
667     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter, uint salt);
668     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
669     event _VotingRightsGranted(uint numTokens, address indexed voter);
670     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
671     event _TokensRescued(uint indexed pollID, address indexed voter);
672 
673     // ============
674     // DATA STRUCTURES:
675     // ============
676 
677     using AttributeStore for AttributeStore.Data;
678     using DLL for DLL.Data;
679     using SafeMath for uint;
680 
681     struct Poll {
682         uint commitEndDate;     /// expiration date of commit period for poll
683         uint revealEndDate;     /// expiration date of reveal period for poll
684         uint voteQuorum;	    /// number of votes required for a proposal to pass
685         uint votesFor;		    /// tally of votes supporting proposal
686         uint votesAgainst;      /// tally of votes countering proposal
687         mapping(address => bool) didCommit;   /// indicates whether an address committed a vote for this poll
688         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
689         mapping(address => uint) voteOptions; /// stores the voteOption of an address that revealed
690     }
691 
692     // ============
693     // STATE VARIABLES:
694     // ============
695 
696     uint constant public INITIAL_POLL_NONCE = 0;
697     uint public pollNonce;
698 
699     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
700     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
701 
702     mapping(address => DLL.Data) dllMap;
703     AttributeStore.Data store;
704 
705     EIP20Interface public token;
706 
707     /**
708     @dev Initializer. Can only be called once.
709     @param _token The address where the ERC20 token contract is deployed
710     */
711     function init(address _token) public {
712         require(_token != address(0) && address(token) == address(0));
713 
714         token = EIP20Interface(_token);
715         pollNonce = INITIAL_POLL_NONCE;
716     }
717 
718     // ================
719     // TOKEN INTERFACE:
720     // ================
721 
722     /**
723     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
724     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
725     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
726     */
727     function requestVotingRights(uint _numTokens) public {
728         require(token.balanceOf(msg.sender) >= _numTokens);
729         voteTokenBalance[msg.sender] += _numTokens;
730         require(token.transferFrom(msg.sender, this, _numTokens));
731         emit _VotingRightsGranted(_numTokens, msg.sender);
732     }
733 
734     /**
735     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
736     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
737     */
738     function withdrawVotingRights(uint _numTokens) external {
739         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
740         require(availableTokens >= _numTokens);
741         voteTokenBalance[msg.sender] -= _numTokens;
742         require(token.transfer(msg.sender, _numTokens));
743         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
744     }
745 
746     /**
747     @dev Unlocks tokens locked in unrevealed vote where poll has ended
748     @param _pollID Integer identifier associated with the target poll
749     */
750     function rescueTokens(uint _pollID) public {
751         require(isExpired(pollMap[_pollID].revealEndDate));
752         require(dllMap[msg.sender].contains(_pollID));
753 
754         dllMap[msg.sender].remove(_pollID);
755         emit _TokensRescued(_pollID, msg.sender);
756     }
757 
758     /**
759     @dev Unlocks tokens locked in unrevealed votes where polls have ended
760     @param _pollIDs Array of integer identifiers associated with the target polls
761     */
762     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
763         // loop through arrays, rescuing tokens from all
764         for (uint i = 0; i < _pollIDs.length; i++) {
765             rescueTokens(_pollIDs[i]);
766         }
767     }
768 
769     // =================
770     // VOTING INTERFACE:
771     // =================
772 
773     /**
774     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
775     @param _pollID Integer identifier associated with target poll
776     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
777     @param _numTokens The number of tokens to be committed towards the target poll
778     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
779     */
780     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
781         require(commitPeriodActive(_pollID));
782 
783         // if msg.sender doesn't have enough voting rights,
784         // request for enough voting rights
785         if (voteTokenBalance[msg.sender] < _numTokens) {
786             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
787             requestVotingRights(remainder);
788         }
789 
790         // make sure msg.sender has enough voting rights
791         require(voteTokenBalance[msg.sender] >= _numTokens);
792         // prevent user from committing to zero node placeholder
793         require(_pollID != 0);
794         // prevent user from committing a secretHash of 0
795         require(_secretHash != 0);
796 
797         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
798         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
799 
800         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
801 
802         // edge case: in-place update
803         if (nextPollID == _pollID) {
804             nextPollID = dllMap[msg.sender].getNext(_pollID);
805         }
806 
807         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
808         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
809 
810         bytes32 UUID = attrUUID(msg.sender, _pollID);
811 
812         store.setAttribute(UUID, "numTokens", _numTokens);
813         store.setAttribute(UUID, "commitHash", uint(_secretHash));
814 
815         pollMap[_pollID].didCommit[msg.sender] = true;
816         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
817     }
818 
819     /**
820     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
821     @param _pollIDs         Array of integer identifiers associated with target polls
822     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
823     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
824     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
825     */
826     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
827         // make sure the array lengths are all the same
828         require(_pollIDs.length == _secretHashes.length);
829         require(_pollIDs.length == _numsTokens.length);
830         require(_pollIDs.length == _prevPollIDs.length);
831 
832         // loop through arrays, committing each individual vote values
833         for (uint i = 0; i < _pollIDs.length; i++) {
834             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
835         }
836     }
837 
838     /**
839     @dev Compares previous and next poll's committed tokens for sorting purposes
840     @param _prevID Integer identifier associated with previous poll in sorted order
841     @param _nextID Integer identifier associated with next poll in sorted order
842     @param _voter Address of user to check DLL position for
843     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
844     @return valid Boolean indication of if the specified position maintains the sort
845     */
846     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
847         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
848         // if next is zero node, _numTokens does not need to be greater
849         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
850         return prevValid && nextValid;
851     }
852 
853     /**
854     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
855     @param _pollID Integer identifier associated with target poll
856     @param _voteOption Vote choice used to generate commitHash for associated poll
857     @param _salt Secret number used to generate commitHash for associated poll
858     */
859     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
860         // Make sure the reveal period is active
861         require(revealPeriodActive(_pollID));
862         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
863         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
864         require(keccak256(abi.encodePacked(_voteOption, _salt)) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
865 
866         uint numTokens = getNumTokens(msg.sender, _pollID);
867 
868         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
869             pollMap[_pollID].votesFor += numTokens;
870         } else {
871             pollMap[_pollID].votesAgainst += numTokens;
872         }
873 
874         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
875         pollMap[_pollID].didReveal[msg.sender] = true;
876         pollMap[_pollID].voteOptions[msg.sender] = _voteOption;
877 
878         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender, _salt);
879     }
880 
881     /**
882     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
883     @param _pollIDs     Array of integer identifiers associated with target polls
884     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
885     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
886     */
887     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
888         // make sure the array lengths are all the same
889         require(_pollIDs.length == _voteOptions.length);
890         require(_pollIDs.length == _salts.length);
891 
892         // loop through arrays, revealing each individual vote values
893         for (uint i = 0; i < _pollIDs.length; i++) {
894             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
895         }
896     }
897 
898     /**
899     @param _voter           Address of voter who voted in the majority bloc
900     @param _pollID          Integer identifier associated with target poll
901     @return correctVotes    Number of tokens voted for winning option
902     */
903     function getNumPassingTokens(address _voter, uint _pollID) public constant returns (uint correctVotes) {
904         require(pollEnded(_pollID));
905         require(pollMap[_pollID].didReveal[_voter]);
906 
907         uint winningChoice = isPassed(_pollID) ? 1 : 0;
908         uint voterVoteOption = pollMap[_pollID].voteOptions[_voter];
909 
910         require(voterVoteOption == winningChoice, "Voter revealed, but not in the majority");
911 
912         return getNumTokens(_voter, _pollID);
913     }
914 
915     // ==================
916     // POLLING INTERFACE:
917     // ==================
918 
919     /**
920     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
921     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
922     @param _commitDuration Length of desired commit period in seconds
923     @param _revealDuration Length of desired reveal period in seconds
924     */
925     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
926         pollNonce = pollNonce + 1;
927 
928         uint commitEndDate = block.timestamp.add(_commitDuration);
929         uint revealEndDate = commitEndDate.add(_revealDuration);
930 
931         pollMap[pollNonce] = Poll({
932             voteQuorum: _voteQuorum,
933             commitEndDate: commitEndDate,
934             revealEndDate: revealEndDate,
935             votesFor: 0,
936             votesAgainst: 0
937         });
938 
939         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
940         return pollNonce;
941     }
942 
943     /**
944     @notice Determines if proposal has passed
945     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
946     @param _pollID Integer identifier associated with target poll
947     */
948     function isPassed(uint _pollID) constant public returns (bool passed) {
949         require(pollEnded(_pollID));
950 
951         Poll memory poll = pollMap[_pollID];
952         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
953     }
954 
955     // ----------------
956     // POLLING HELPERS:
957     // ----------------
958 
959     /**
960     @dev Gets the total winning votes for reward distribution purposes
961     @param _pollID Integer identifier associated with target poll
962     @return Total number of votes committed to the winning option for specified poll
963     */
964     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
965         require(pollEnded(_pollID));
966 
967         if (isPassed(_pollID))
968             return pollMap[_pollID].votesFor;
969         else
970             return pollMap[_pollID].votesAgainst;
971     }
972 
973     /**
974     @notice Determines if poll is over
975     @dev Checks isExpired for specified poll's revealEndDate
976     @return Boolean indication of whether polling period is over
977     */
978     function pollEnded(uint _pollID) constant public returns (bool ended) {
979         require(pollExists(_pollID));
980 
981         return isExpired(pollMap[_pollID].revealEndDate);
982     }
983 
984     /**
985     @notice Checks if the commit period is still active for the specified poll
986     @dev Checks isExpired for the specified poll's commitEndDate
987     @param _pollID Integer identifier associated with target poll
988     @return Boolean indication of isCommitPeriodActive for target poll
989     */
990     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
991         require(pollExists(_pollID));
992 
993         return !isExpired(pollMap[_pollID].commitEndDate);
994     }
995 
996     /**
997     @notice Checks if the reveal period is still active for the specified poll
998     @dev Checks isExpired for the specified poll's revealEndDate
999     @param _pollID Integer identifier associated with target poll
1000     */
1001     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
1002         require(pollExists(_pollID));
1003 
1004         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
1005     }
1006 
1007     /**
1008     @dev Checks if user has committed for specified poll
1009     @param _voter Address of user to check against
1010     @param _pollID Integer identifier associated with target poll
1011     @return Boolean indication of whether user has committed
1012     */
1013     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
1014         require(pollExists(_pollID));
1015 
1016         return pollMap[_pollID].didCommit[_voter];
1017     }
1018 
1019     /**
1020     @dev Checks if user has revealed for specified poll
1021     @param _voter Address of user to check against
1022     @param _pollID Integer identifier associated with target poll
1023     @return Boolean indication of whether user has revealed
1024     */
1025     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
1026         require(pollExists(_pollID));
1027 
1028         return pollMap[_pollID].didReveal[_voter];
1029     }
1030 
1031     /**
1032     @dev Checks if a poll exists
1033     @param _pollID The pollID whose existance is to be evaluated.
1034     @return Boolean Indicates whether a poll exists for the provided pollID
1035     */
1036     function pollExists(uint _pollID) constant public returns (bool exists) {
1037         return (_pollID != 0 && _pollID <= pollNonce);
1038     }
1039 
1040     // ---------------------------
1041     // DOUBLE-LINKED-LIST HELPERS:
1042     // ---------------------------
1043 
1044     /**
1045     @dev Gets the bytes32 commitHash property of target poll
1046     @param _voter Address of user to check against
1047     @param _pollID Integer identifier associated with target poll
1048     @return Bytes32 hash property attached to target poll
1049     */
1050     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
1051         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
1052     }
1053 
1054     /**
1055     @dev Wrapper for getAttribute with attrName="numTokens"
1056     @param _voter Address of user to check against
1057     @param _pollID Integer identifier associated with target poll
1058     @return Number of tokens committed to poll in sorted poll-linked-list
1059     */
1060     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
1061         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
1062     }
1063 
1064     /**
1065     @dev Gets top element of sorted poll-linked-list
1066     @param _voter Address of user to check against
1067     @return Integer identifier to poll with maximum number of tokens committed to it
1068     */
1069     function getLastNode(address _voter) constant public returns (uint pollID) {
1070         return dllMap[_voter].getPrev(0);
1071     }
1072 
1073     /**
1074     @dev Gets the numTokens property of getLastNode
1075     @param _voter Address of user to check against
1076     @return Maximum number of tokens committed in poll specified
1077     */
1078     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
1079         return getNumTokens(_voter, getLastNode(_voter));
1080     }
1081 
1082     /*
1083     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
1084     for a node with a value less than or equal to the provided _numTokens value. When such a node
1085     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
1086     update. In that case, return the previous node of the node being updated. Otherwise return the
1087     first node that was found with a value less than or equal to the provided _numTokens.
1088     @param _voter The voter whose DLL will be searched
1089     @param _numTokens The value for the numTokens attribute in the node to be inserted
1090     @return the node which the propoded node should be inserted after
1091     */
1092     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
1093     constant public returns (uint prevNode) {
1094         // Get the last node in the list and the number of tokens in that node
1095         uint nodeID = getLastNode(_voter);
1096         uint tokensInNode = getNumTokens(_voter, nodeID);
1097 
1098         // Iterate backwards through the list until reaching the root node
1099         while(nodeID != 0) {
1100             // Get the number of tokens in the current node
1101             tokensInNode = getNumTokens(_voter, nodeID);
1102             if(tokensInNode <= _numTokens) { // We found the insert point!
1103                 if(nodeID == _pollID) {
1104                     // This is an in-place update. Return the prev node of the node being updated
1105                     nodeID = dllMap[_voter].getPrev(nodeID);
1106                 }
1107                 // Return the insert point
1108                 return nodeID;
1109             }
1110             // We did not find the insert point. Continue iterating backwards through the list
1111             nodeID = dllMap[_voter].getPrev(nodeID);
1112         }
1113 
1114         // The list is empty, or a smaller value than anything else in the list is being inserted
1115         return nodeID;
1116     }
1117 
1118     // ----------------
1119     // GENERAL HELPERS:
1120     // ----------------
1121 
1122     /**
1123     @dev Checks if an expiration date has been reached
1124     @param _terminationDate Integer timestamp of date to compare current timestamp with
1125     @return expired Boolean indication of whether the terminationDate has passed
1126     */
1127     function isExpired(uint _terminationDate) constant public returns (bool expired) {
1128         return (block.timestamp > _terminationDate);
1129     }
1130 
1131     /**
1132     @dev Generates an identifier which associates a user and a poll together
1133     @param _pollID Integer identifier associated with target poll
1134     @return UUID Hash which is deterministic from _user and _pollID
1135     */
1136     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
1137         return keccak256(abi.encodePacked(_user, _pollID));
1138     }
1139 }
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
2334 /***************************************************************************************************
2335 *                                                                                                  *
2336 * (c) 2019 Quantstamp, Inc. This content and its use are governed by the license terms at          *
2337 * <https://github.com/quantstamp/qsp-protocol-node/blob/develop/LICENSE>                           *
2338 *                                                                                                  *
2339 ***************************************************************************************************/
2340 
2341 
2342 
2343 
2344 
2345 
2346 
2347 
2348 
2349 /**
2350 Extends PLCR Voting to have restricted polls that can only be voted on by the TCR.
2351 */
2352 contract RestrictedPLCRVoting is PLCRVoting, Whitelist {
2353 
2354   using SafeMath for uint256;
2355   using LinkedListLib for LinkedListLib.LinkedList;
2356 
2357   // constants used by LinkedListLib
2358   uint256 constant internal NULL = 0;
2359   uint256 constant internal HEAD = 0;
2360   bool constant internal PREV = false;
2361   bool constant internal NEXT = true;
2362 
2363   // TCR used to list judge stakers.
2364   Registry public judgeRegistry;
2365 
2366   QuantstampBountyData public bountyData;
2367 
2368   // Map that contains IDs of restricted polls that can only be voted on by the TCR
2369   mapping(uint256 => bool) isRestrictedPoll;
2370 
2371   // Map from IDs of restricted polls to the minimum number of votes needed for a bug to pass
2372   mapping(uint256 => uint256) minimumVotes;
2373 
2374   // Map from IDs of restricted polls to the amount a judge must deposit to vote
2375   mapping(uint256 => uint256) judgeDeposit;
2376 
2377   // Map from (voter x pollId) -> bool to determine whether a voter has already claimed a reward of a given poll
2378   mapping(address => mapping(uint256 => bool)) private voterHasClaimedReward;
2379 
2380   // Map from (voter x pollId) -> bool indicating whether a voter voted yes (true) or no (false) for a poll.
2381   // Needed due to visibility issues with Poll structs in PLCRVoting
2382   mapping(address => mapping(uint256 => bool)) private votedAffirmatively;
2383 
2384   // Recording polls voted on but not yet awarded for each voter
2385   mapping (address => LinkedListLib.LinkedList) private voterPolls;
2386   mapping (address => uint256) public voterPollsCount;
2387 
2388   event LogPollRestricted(uint256 pollId);
2389 
2390   /**
2391    * @dev Initializer. Can only be called once.
2392    * @param _registry The address of the TCR registry
2393    * @param _token The address of the token
2394    */
2395   function initialize(address _token, address _registry, address _bountyData) public {
2396     require(_token != 0 && address(token) == 0);
2397     require(_registry != 0 && address(judgeRegistry) == 0);
2398     require(_bountyData != 0 && address(bountyData) == 0);
2399     bountyData = QuantstampBountyData(_bountyData);
2400     token = EIP20Interface(_token);
2401     judgeRegistry = Registry(_registry);
2402     pollNonce = INITIAL_POLL_NONCE;
2403   }
2404 
2405   /*
2406    * @dev addr is of type Address which is 20 Bytes, but the TCR expects all
2407    * entries to be of type Bytes32. addr is first cast to Uint256 so that it
2408    * becomes 32 bytes long, addr is then shifted 12 bytes (96 bits) to the
2409    * left so the 20 important bytes are in the correct spot.
2410    * @param addr The address of the person who may be an judge.
2411    * @return true If addr is on the TCR (is an judge)
2412    */
2413   function isJudge(address addr) public view returns(bool) {
2414     return judgeRegistry.isWhitelisted(bytes32(uint256(addr) << 96));
2415   }
2416 
2417   /**
2418    * @dev Set a poll to be restricted to TCR voting
2419    * @param _pollId The ID of the poll
2420    * @param _minimumVotes The minimum number of votes needed for the vote to go through. Each voter counts as 1 vote (not weighted).
2421    * @param _judgeDepositAmount The deposit of a judge to vote
2422    */
2423   function restrictPoll(uint256 _pollId, uint256 _minimumVotes, uint256 _judgeDepositAmount) public onlyWhitelisted {
2424     isRestrictedPoll[_pollId] = true;
2425     minimumVotes[_pollId] = _minimumVotes;
2426     judgeDeposit[_pollId] = _judgeDepositAmount;
2427     emit LogPollRestricted(_pollId);
2428   }
2429 
2430   /**
2431    * @dev Set that a voter has claimed a reward for voting with the majority
2432    * @param _voter The address of the voter
2433    * @param _pollID Integer identifier associated with target poll
2434    */
2435   function setVoterClaimedReward(address _voter, uint256 _pollID) public onlyWhitelisted {
2436     voterHasClaimedReward[_voter][_pollID] = true;
2437   }
2438 
2439   /**
2440    * @dev Determines whether a restricted poll has met the minimum vote requirements
2441    * @param _pollId The ID of the poll
2442    */
2443   function isEnoughVotes(uint256 _pollId) public view returns (bool) {
2444     return pollMap[_pollId].votesFor.add(pollMap[_pollId].votesAgainst) >= minimumVotes[_pollId].mul(judgeDeposit[_pollId]);
2445   }
2446 
2447   // Overridden methods from PLCRVoting. Needed for special requirements of the bounty protocol
2448 
2449   /**
2450   * @dev Overridden Initializer from PLCR Voting. Always reverts to ensure the registry is initialized in the above initialize function.
2451   * @param _token The address of the token
2452   */
2453   function init(address _token) public {
2454     require(false);
2455   }
2456 
2457   /**
2458    * @dev Overrides PLCRVoting to only allow TCR members to vote on restricted votes.
2459    *      Commits vote using hash of choice and secret salt to conceal vote until reveal.
2460    * @param _pollID Integer identifier associated with target poll
2461    * @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
2462    * @param _numTokens The number of tokens to be committed towards the target poll
2463    * @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
2464    */
2465   function commitVote(uint256 _pollID, bytes32 _secretHash, uint256 _numTokens, uint256 _prevPollID) public {
2466     if (isRestrictedPoll[_pollID]) {
2467       require(isJudge(msg.sender));
2468       // Note: The PLCR weights votes by numTokens, so here we use strict equality rather than '>='
2469       // This must be accounted for when tallying votes.
2470       require(_numTokens == judgeDeposit[_pollID]);
2471       require(bountyData.isJudgingPeriod(bountyData.getBugBountyId(bountyData.getBugIdFromPollId(_pollID))));
2472     }
2473     super.commitVote(_pollID, _secretHash, _numTokens, _prevPollID);
2474   }
2475 
2476   /**
2477    * @dev Overrides PLCRVoting to track which polls are associated with a voter.
2478    * @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
2479    * @param _pollID Integer identifier associated with target poll
2480    * @param _voteOption Vote choice used to generate commitHash for associated poll
2481    * @param _salt Secret number used to generate commitHash for associated poll
2482    */
2483   function revealVote(uint256 _pollID, uint256 _voteOption, uint256 _salt) public {
2484     address voter = msg.sender;
2485     // record the vote
2486     if (_voteOption == 1) {
2487       votedAffirmatively[voter][_pollID] = true;
2488     }
2489     // do not allow multiple votes for the same poll
2490     require(!voterPolls[voter].nodeExists(_pollID));
2491     bool wasPassing = isPassing(_pollID);
2492     bool wasEnoughVotes = isEnoughVotes(_pollID);
2493     voterPolls[voter].push(_pollID, PREV);
2494     voterPollsCount[voter] = voterPollsCount[voter].add(1);
2495     super.revealVote(_pollID, _voteOption, _salt);
2496     bool voteIsPassing = isPassing(_pollID);
2497     bountyData.updateNumApprovedBugs(_pollID, wasPassing, voteIsPassing, wasEnoughVotes);
2498   }
2499 
2500   function removePollFromVoter (address _voter, uint256 _pollID) public onlyWhitelisted returns (bool) {
2501     if (voterPolls[_voter].remove(_pollID) != 0) {
2502       voterPollsCount[_voter] = voterPollsCount[_voter] - 1;
2503       return true;
2504     }
2505     return false;
2506   }
2507 
2508   /**
2509    * @dev Determines if proposal has more affirmative votes
2510    *      Check if votesFor out of totalVotes exceeds votesQuorum (does not require pollEnded)
2511    * @param _pollID Integer identifier associated with target poll
2512    */
2513   function isPassing(uint _pollID) public view returns (bool) {
2514     Poll memory poll = pollMap[_pollID];
2515     return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
2516   }
2517 
2518   /**
2519    * @dev Gets the total winning votes for reward distribution purposes.
2520    *      Returns 0 if there were not enough votes.
2521    * @param _pollID Integer identifier associated with target poll
2522    * @return Total number of votes committed to the winning option for specified poll
2523    */
2524   function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint256) {
2525     if (isRestrictedPoll[_pollID] && !isEnoughVotes(_pollID)) {
2526       return 0;
2527     }
2528     return super.getTotalNumberOfTokensForWinningOption(_pollID);
2529   }
2530 
2531   /**
2532    * @dev Gets the number of tokens allocated toward the winning vote for a particular voter.
2533    *      Zero if there were not enough votes for a restricted poll.
2534    * @param _voter Address of voter who voted in the majority bloc
2535    * @param _pollID Integer identifier associated with target poll
2536    * @return correctVotes Number of tokens voted for winning option
2537    */
2538   function getNumPassingTokens(address _voter, uint _pollID) public constant returns (uint256) {
2539     if (isRestrictedPoll[_pollID] && !isEnoughVotes(_pollID)) {
2540       return 0;
2541     }
2542     return super.getNumPassingTokens(_voter, _pollID);
2543   }
2544 
2545   /**
2546    * @dev Determines if proposal has passed
2547    *      Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
2548    * @param _pollID Integer identifier associated with target poll
2549    */
2550   function isPassed(uint _pollID) constant public returns (bool) {
2551     if (isRestrictedPoll[_pollID] && !isEnoughVotes(_pollID)) {
2552       return false;
2553     }
2554     return super.isPassed(_pollID);
2555   }
2556 
2557   /**
2558    * @dev Determines if a voter has already claimed a reward for voting with the majority
2559    * @param _voter The address of the voter
2560    * @param _pollID Integer identifier associated with target poll
2561    */
2562   function hasVoterClaimedReward(address _voter, uint256 _pollID) public view returns (bool) {
2563     return voterHasClaimedReward[_voter][_pollID];
2564   }
2565 
2566   /**
2567    * @dev Determines if a voter voted yes or no for a poll
2568    * @param _voter The address of the voter
2569    * @param _pollID Integer identifier associated with target poll
2570    */
2571   function hasVotedAffirmatively(address _voter, uint256 _pollID) public view returns (bool) {
2572     return votedAffirmatively[_voter][_pollID];
2573   }
2574 
2575   /**
2576    * @dev Returns the number of unclaimed polls associated with the voter.
2577    * @param _voter The address of the voter
2578    */
2579   function getVoterPollsCount (address _voter) public view returns (uint256) {
2580     return voterPollsCount[_voter];
2581   }
2582 
2583   function getListHeadConstant () public pure returns(uint256 head) {
2584     return HEAD;
2585   }
2586 
2587   /**
2588    * @dev Given a pollID, it retrieves the next pollID voted on but unclaimed by the voter.
2589    * @param _voter The address of the voter
2590    * @param _prevPollID The id of the previous unclaimed poll. Passing 0, it returns the first poll.
2591    */
2592   function getNextPollFromVoter(address _voter, uint256 _prevPollID) public view returns (bool, uint256) {
2593     if (!voterPolls[_voter].listExists()) {
2594       return (false, 0);
2595     }
2596     uint256 pollID;
2597     bool exists;
2598     (exists, pollID) = voterPolls[_voter].getAdjacent(_prevPollID, NEXT);
2599     if (!exists || pollID == 0) {
2600       return (false, 0);
2601     }
2602     return (true, pollID);
2603   }
2604 }
2605  //Imports SafeMath
2606 
2607 
2608 
2609 contract QuantstampBountyData is Whitelist {
2610 
2611   using SafeMath for uint256;
2612   using LinkedListLib for LinkedListLib.LinkedList;
2613 
2614   // constants used by LinkedListLib
2615   uint256 constant internal NULL = 0;
2616   uint256 constant internal HEAD = 0;
2617   bool constant internal PREV = false;
2618   bool constant internal NEXT = true;
2619 
2620 
2621   uint256 constant internal NUMBER_OF_PHASES = 3;
2622 
2623   struct Bounty {
2624     address submitter;
2625     string contractAddress;
2626     uint256 size; // R1
2627     uint256 minVotes; // R3
2628     uint256 duration; // R2. Number of seconds
2629     uint256 judgeDeposit; // R5
2630     uint256 hunterDeposit; // R6
2631     uint256 initiationTimestamp; // Time in seconds that the bounty is created
2632     bool remainingFeesWithdrawn; // true if the remaining fees have been withdrawn by the submitter
2633     uint256 numApprovedBugs;
2634   }
2635 
2636   // holds information about a revealed bug
2637   struct Bug {
2638     address hunter; // address that submitted the hash
2639     uint256 bountyId; // the ID of the associated bounty
2640     string bugDescription; // the description of the bug
2641     uint256 numTokens; // the number of tokens staked on the commit
2642     uint256 pollId; // the poll that decided on the validity of the bug
2643   }
2644 
2645   // holds information relevant to a bug commit
2646   struct BugCommit {
2647     address hunter;  // address that submitted the hash
2648     uint256 bountyId;  // the ID of the associated bounty
2649     bytes32 bugDescriptionHash;  // keccak256 hash of the bug
2650     uint256 commitTimestamp;  // Time in seconds that the bug commit occurred
2651     uint256 revealStartTimestamp;  // Time in seconds when the the reveal phase starts
2652     uint256 revealEndTimestamp;  // Time in seconds when the the reveal phase ends
2653     uint256 numTokens;  // the number of tokens staked on the commit
2654   }
2655 
2656   mapping (uint256 => Bounty) public bounties;
2657 
2658   // maps pollIds back to bugIds
2659   mapping (uint256 => uint256) public pollIdToBugId;
2660 
2661   // For generating bountyIDs starting from 1
2662   uint256 private bountyCounter;
2663 
2664   // For generating bugIDs starting from 1
2665   uint256 private bugCounter;
2666 
2667   // token used to pay for participants in a bounty. This contract assumes that the owner of the contract
2668   // trusts token's code and that transfer function (such as transferFrom, transfer) do the right thing
2669   StandardToken public token;
2670 
2671   // The partial-locking commit-reveal voting interface used by the TCR to determine the validity of bugs
2672   RestrictedPLCRVoting public voting;
2673 
2674   // The underlying contract to hold PLCR voting parameters
2675   Parameterizer public parameterizer;
2676 
2677   // Recording reported bugs not yet awarded for each hunter
2678   mapping (address => LinkedListLib.LinkedList) private hunterReportedBugs;
2679   mapping (address => uint256) public hunterReportedBugsCount;
2680 
2681   /**
2682    * @dev The constructor creates a QuantstampBountyData contract.
2683    * @param tokenAddress The address of a StandardToken that will be used to pay auditor nodes.
2684    */
2685   constructor (address tokenAddress, address votingAddress, address parameterizerAddress) public {
2686     require(tokenAddress != address(0));
2687     require(votingAddress != address(0));
2688     require(parameterizerAddress != address(0));
2689     token = StandardToken(tokenAddress);
2690     voting = RestrictedPLCRVoting(votingAddress);
2691     parameterizer = Parameterizer(parameterizerAddress);
2692   }
2693 
2694   // maps bountyIDs to list of corresponding bugIDs
2695   // each list contains all revealed bugs for a given bounty, ordered by time
2696   // NOTE: this cannot be part of the Bounty struct due to solidity limitations
2697   mapping(uint256 => LinkedListLib.LinkedList) private bugLists;
2698 
2699   // maps bugIDs to BugCommits
2700   mapping(uint256 => BugCommit) public bugCommitMap;
2701 
2702   // maps bugIDs to revealed bugs; uses the same ID as the bug commit
2703   mapping(uint256 => Bug) public bugs;
2704 
2705   function addBugCommitment(address hunter,
2706                             uint256 bountyId,
2707                             bytes32 bugDescriptionHash,
2708                             uint256 hunterDeposit) public onlyWhitelisted returns (uint256) {
2709     bugCounter = bugCounter.add(1);
2710     bugCommitMap[bugCounter] = BugCommit({
2711       hunter: hunter,
2712       bountyId: bountyId,
2713       bugDescriptionHash: bugDescriptionHash,
2714       commitTimestamp: block.timestamp,
2715       revealStartTimestamp: getBountyRevealPhaseStartTimestamp(bountyId),
2716       revealEndTimestamp: getBountyRevealPhaseEndTimestamp(bountyId),
2717       numTokens: hunterDeposit
2718     });
2719     return bugCounter;
2720   }
2721 
2722   function addBug(uint256 bugId, string bugDescription, uint256 pollId) public onlyWhitelisted returns (bool) {
2723     // create a Bug
2724     bugs[bugId] = Bug({
2725       hunter: bugCommitMap[bugId].hunter,
2726       bountyId: bugCommitMap[bugId].bountyId,
2727       bugDescription: bugDescription,
2728       numTokens: bugCommitMap[bugId].numTokens,
2729       pollId: pollId
2730     });
2731     // add pointer to it in the corresponding bounty
2732     bugLists[bugCommitMap[bugId].bountyId].push(bugId, PREV);
2733     pollIdToBugId[pollId] = bugId;
2734     return true;
2735   }
2736 
2737   function addBounty (address submitter,
2738                       string contractAddress,
2739                       uint256 size,
2740                       uint256 minVotes,
2741                       uint256 duration,
2742                       uint256 judgeDeposit,
2743                       uint256 hunterDeposit) public onlyWhitelisted returns(uint256) {
2744     bounties[++bountyCounter] = Bounty(submitter,
2745                                         contractAddress,
2746                                         size,
2747                                         minVotes,
2748                                         duration,
2749                                         judgeDeposit,
2750                                         hunterDeposit,
2751                                         block.timestamp,
2752                                         false,
2753                                         0);
2754     return bountyCounter;
2755   }
2756 
2757   function removeBugCommitment(uint256 bugId) public onlyWhitelisted returns (bool) {
2758     delete bugCommitMap[bugId];
2759     return true;
2760   }
2761 
2762   /**
2763    * @dev Sets a new value for the number of approved bugs, if appropriate
2764    * @param pollId The ID of the poll being that a vote was received for
2765    * @param wasPassing true if and only if more affirmative votes prior to this vote
2766    * @param isPassing true if and only if more affirmative votes after this vote
2767    * @param wasEnoughVotes true if and only if quorum was reached prior to this vote
2768    */
2769   function updateNumApprovedBugs(uint256 pollId, bool wasPassing, bool isPassing, bool wasEnoughVotes) public {
2770     require(msg.sender == address(voting));
2771     uint256 bountyId = getBugBountyId(getBugIdFromPollId(pollId));
2772 
2773     if (wasEnoughVotes) {
2774       if (!wasPassing && isPassing) {
2775         bounties[bountyId].numApprovedBugs = bounties[bountyId].numApprovedBugs.add(1);
2776       } else if (wasPassing && !isPassing) {
2777         bounties[bountyId].numApprovedBugs = bounties[bountyId].numApprovedBugs.sub(1);
2778       }
2779     } else if (voting.isEnoughVotes(pollId) && isPassing) {
2780       bounties[bountyId].numApprovedBugs = bounties[bountyId].numApprovedBugs.add(1);
2781     }
2782   }
2783 
2784   /**
2785    * @dev Reports the number of approved bugs of a bounty
2786    * @param bountyId The ID of the bounty.
2787    */
2788   function getNumApprovedBugs(uint256 bountyId) public view returns (uint256) {
2789     return bounties[bountyId].numApprovedBugs;
2790   }
2791 
2792   /**
2793    * @dev Sets remainingFeesWithdrawn to true after the submitter withdraws.
2794    * @param bountyId The ID of the bounty.
2795    */
2796   function setBountyRemainingFeesWithdrawn (uint256 bountyId) public onlyWhitelisted {
2797     bounties[bountyId].remainingFeesWithdrawn = true;
2798   }
2799 
2800   function addBugToHunter (address hunter, uint256 bugId) public onlyWhitelisted {
2801     hunterReportedBugs[hunter].push(bugId, PREV);
2802     hunterReportedBugsCount[hunter] = hunterReportedBugsCount[hunter].add(1);
2803   }
2804 
2805   function removeBugFromHunter (address hunter, uint256 bugId) public onlyWhitelisted returns (bool) {
2806     if (hunterReportedBugs[hunter].remove(bugId) != 0) {
2807       hunterReportedBugsCount[hunter] = hunterReportedBugsCount[hunter].sub(1);
2808       bugs[bugId].hunter = 0x0;
2809       return true;
2810     }
2811     return false;
2812   }
2813 
2814   function getListHeadConstant () public pure returns(uint256 head) {
2815     return HEAD;
2816   }
2817 
2818   function getBountySubmitter (uint256 bountyId) public view returns(address) {
2819     return bounties[bountyId].submitter;
2820   }
2821 
2822   function getBountyContractAddress (uint256 bountyId) public view returns(string) {
2823     return bounties[bountyId].contractAddress;
2824   }
2825 
2826   function getBountySize (uint256 bountyId) public view returns(uint256) {
2827     return bounties[bountyId].size;
2828   }
2829 
2830   function getBountyMinVotes (uint256 bountyId) public view returns(uint256) {
2831     return bounties[bountyId].minVotes;
2832   }
2833 
2834   function getBountyDuration (uint256 bountyId) public view returns(uint256) {
2835     return bounties[bountyId].duration;
2836   }
2837 
2838   function getBountyJudgeDeposit (uint256 bountyId) public view returns(uint256) {
2839     return bounties[bountyId].judgeDeposit;
2840   }
2841 
2842   function getBountyHunterDeposit (uint256 bountyId) public view returns(uint256) {
2843     return bounties[bountyId].hunterDeposit;
2844   }
2845 
2846   function getBountyInitiationTimestamp (uint256 bountyId) public view returns(uint256) {
2847     return bounties[bountyId].initiationTimestamp;
2848   }
2849 
2850   function getBountyCommitPhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2851     return bounties[bountyId].initiationTimestamp.add(getBountyDuration(bountyId).div(NUMBER_OF_PHASES));
2852   }
2853 
2854   function getBountyRevealPhaseStartTimestamp (uint256 bountyId) public view returns(uint256) {
2855     return getBountyCommitPhaseEndTimestamp(bountyId).add(1);
2856   }
2857 
2858   function getBountyRevealPhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2859     return getBountyCommitPhaseEndTimestamp(bountyId).add(getBountyDuration(bountyId).div(NUMBER_OF_PHASES));
2860   }
2861 
2862   function getBountyJudgePhaseStartTimestamp (uint256 bountyId) public view returns(uint256) {
2863     return getBountyRevealPhaseEndTimestamp(bountyId).add(1);
2864   }
2865 
2866   function getBountyJudgePhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2867     return bounties[bountyId].initiationTimestamp.add(getBountyDuration(bountyId));
2868   }
2869 
2870   function getBountyJudgeCommitPhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2871     uint256 judgePhaseDuration = getBountyDuration(bountyId).div(NUMBER_OF_PHASES);
2872     return getBountyJudgePhaseStartTimestamp(bountyId).add(judgePhaseDuration.div(2));
2873   }
2874 
2875   function getBountyJudgeRevealDuration (uint256 bountyId) public view returns(uint256) {
2876     return getBountyJudgePhaseEndTimestamp(bountyId).sub(getBountyJudgeCommitPhaseEndTimestamp(bountyId));
2877   }
2878 
2879   function isCommitPeriod (uint256 bountyId) public view returns(bool) {
2880     return block.timestamp >= bounties[bountyId].initiationTimestamp && block.timestamp <= getBountyCommitPhaseEndTimestamp(bountyId);
2881   }
2882 
2883   function isRevealPeriod (uint256 bountyId) public view returns(bool) {
2884     return block.timestamp >= getBountyRevealPhaseStartTimestamp(bountyId) && block.timestamp <= getBountyRevealPhaseEndTimestamp(bountyId);
2885   }
2886 
2887   function isJudgingPeriod (uint256 bountyId) public view returns(bool) {
2888     return block.timestamp >= getBountyJudgePhaseStartTimestamp(bountyId) && block.timestamp <= getBountyJudgePhaseEndTimestamp(bountyId);
2889   }
2890 
2891   function getBountyRemainingFeesWithdrawn (uint256 bountyId) public view returns(bool) {
2892     return bounties[bountyId].remainingFeesWithdrawn;
2893   }
2894 
2895   function getBugCommitCommitter(uint256 bugCommitId) public view returns (address) {
2896     return bugCommitMap[bugCommitId].hunter;
2897   }
2898 
2899   function getBugCommitBountyId(uint256 bugCommitId) public view returns (uint256) {
2900     return bugCommitMap[bugCommitId].bountyId;
2901   }
2902 
2903   function getBugCommitBugDescriptionHash(uint256 bugCommitId) public view returns (bytes32) {
2904     return bugCommitMap[bugCommitId].bugDescriptionHash;
2905   }
2906 
2907   function getBugCommitCommitTimestamp(uint256 bugCommitId) public view returns (uint256) {
2908     return bugCommitMap[bugCommitId].commitTimestamp;
2909   }
2910 
2911   function getBugCommitRevealStartTimestamp(uint256 bugCommitId) public view returns (uint256) {
2912     return bugCommitMap[bugCommitId].revealStartTimestamp;
2913   }
2914 
2915   function getBugCommitRevealEndTimestamp(uint256 bugCommitId) public view returns (uint256) {
2916     return bugCommitMap[bugCommitId].revealEndTimestamp;
2917   }
2918 
2919   function getBugCommitNumTokens(uint256 bugCommitId) public view returns (uint256) {
2920     return bugCommitMap[bugCommitId].numTokens;
2921   }
2922 
2923   function bugRevealPeriodActive(uint256 bugCommitId) public view returns (bool) {
2924     return bugCommitMap[bugCommitId].revealStartTimestamp <= block.timestamp && block.timestamp <= bugCommitMap[bugCommitId].revealEndTimestamp;
2925   }
2926 
2927   function bugRevealPeriodExpired(uint256 bugCommitId) public view returns (bool) {
2928     return block.timestamp > bugCommitMap[bugCommitId].revealEndTimestamp;
2929   }
2930 
2931   function bugRevealDelayPeriodActive(uint256 bugCommitId) public view returns (bool) {
2932     return block.timestamp < bugCommitMap[bugCommitId].revealStartTimestamp;
2933   }
2934 
2935   function bountyActive(uint256 bountyId) public view returns (bool) {
2936     return block.timestamp <= getBountyInitiationTimestamp(bountyId).add(getBountyDuration(bountyId));
2937   }
2938 
2939   function getHunterReportedBugsCount (address hunter) public view returns (uint256) {
2940     return hunterReportedBugsCount[hunter];
2941   }
2942 
2943   // Bug Functions
2944   function getBugBountyId(uint256 bugId) public view returns (uint256) {
2945     return bugs[bugId].bountyId;
2946   }
2947 
2948   function getBugHunter(uint256 bugId) public view returns (address) {
2949     return bugs[bugId].hunter;
2950   }
2951 
2952   function getBugDescription(uint256 bugId) public view returns (string) {
2953     return bugs[bugId].bugDescription;
2954   }
2955 
2956   function getBugNumTokens(uint256 bugId) public view returns (uint256) {
2957     return bugs[bugId].numTokens;
2958   }
2959 
2960   function getBugPollId(uint256 bugId) public view returns (uint256) {
2961     return bugs[bugId].pollId;
2962   }
2963 
2964   function getFirstRevealedBug(uint256 bountyId) public view returns (bool, uint256, string) {
2965     return getNextRevealedBug(bountyId, HEAD);
2966   }
2967 
2968   function getBugIdFromPollId(uint256 pollId) public view returns (uint256) {
2969     return pollIdToBugId[pollId];
2970   }
2971 
2972   /*
2973    * @dev Gets the bug description of a revealed bug associated with a bounty
2974    * @param bountyId The ID of the bounty
2975    * @param previousBugId The ID of the previous bug in the linked list (HEAD for the first bug)
2976    * @return a triple containing 1) whether the bug exists; 2) its bugId (0 if non-existent); 3) the description
2977    */
2978   function getNextRevealedBug(uint256 bountyId, uint256 previousBugId) public view returns (bool, uint256, string) {
2979     if (!bugLists[bountyId].listExists()) {
2980       return (false, 0, "");
2981     }
2982     uint256 bugId;
2983     bool exists;
2984     (exists, bugId) = bugLists[bountyId].getAdjacent(previousBugId, NEXT);
2985     if (!exists || bugId == 0) {
2986       return (false, 0, "");
2987     }
2988     string memory bugDescription = bugs[bugId].bugDescription;
2989     return (true, bugId, bugDescription);
2990   }
2991 
2992   /**
2993    * @dev Given a bugId, it retrieves the next bugId reported by a hunter. Such bugs have not been cashed yet.
2994    * @param hunter The address of a hunter
2995    * @param previousBugId The id of the previous reported bug. Passing 0, it returns the first reported bug.
2996    */
2997   function getNextBugFromHunter(address hunter, uint256 previousBugId) public view returns (bool, uint256) {
2998     if (!hunterReportedBugs[hunter].listExists()) {
2999       return (false, 0);
3000     }
3001     uint256 bugId;
3002     bool exists;
3003     (exists, bugId) = hunterReportedBugs[hunter].getAdjacent(previousBugId, NEXT);
3004     if (!exists || bugId == 0) {
3005       return (false, 0);
3006     }
3007     return (true, bugId);
3008   }
3009 
3010   /**
3011    * @dev Determines if the judge meets the requirements to claim an award for voting in a poll
3012    * @param bugId Id of a bug
3013    * Note: moved to this contract as the Bounty contract was getting too large to deploy
3014    */
3015   function canClaimJudgeAward(address judge, uint256 bugId) public view returns (bool) {
3016     // NOTE: these cannot be a require statement as this check occurs in a loop that should not fail
3017     // the poll has concluded
3018     uint256 pollId = getBugPollId(bugId);
3019     bool pollHasConcluded = voting.pollExists(pollId) && voting.pollEnded(pollId);
3020     // the judge voted in the majority
3021     // this is needed to avoid hitting a require statement when in the minority in PLCRVoting
3022     bool votedWithMajority = pollHasConcluded && voting.isEnoughVotes(pollId) &&
3023       (voting.isPassed(pollId) && voting.hasVotedAffirmatively(judge, pollId) ||
3024       !voting.isPassed(pollId) && !voting.hasVotedAffirmatively(judge, pollId));
3025     // the judge should not have already claimed an award for this poll
3026     bool alreadyClaimed = voting.hasVoterClaimedReward(judge, pollId);
3027     // the bounty should be over
3028     bool bountyStillActive = bountyActive(getBugBountyId(bugId));
3029     return votedWithMajority && !alreadyClaimed && !bountyStillActive;
3030   }
3031 }
3032 
3033 
3034 
3035 contract QuantstampBounty is Ownable {
3036   using SafeMath for uint256;
3037 
3038   // separating logic from data
3039   QuantstampBountyData public bountyData;
3040 
3041   // TCR used to list judge stakers.
3042   Registry public bountyRegistry;
3043 
3044   event LogBugCommitted(uint256 bugId,
3045                         address hunter,
3046                         uint256 bountyId,
3047                         bytes32 bugDescriptionHash,
3048                         uint256 hunterDeposit);
3049 
3050   event LogRevealBugRefund(uint256 bugId);
3051   event LogBugRevealed(uint256 bountyId, uint256 bugId, address hunter);
3052   event LogBugVoteInitiated(uint256 bountyId, uint256 bugId, uint256 pollId);
3053   event LogBountyCreated(uint256 bountyId);
3054   event LogBountyWithdrawn(uint256 bountyId, address submitter, uint256 amount);
3055   event LogJudgePaid(uint256 bountyId, uint256 bugId, address judge, uint256 amount);
3056 
3057   /**
3058    * @dev Initializes the QuantstampBounty protocol.
3059    * @param bountyDataAddress The contract that holds data associated with the bounty.
3060    */
3061   constructor(address bountyDataAddress, address tcrAddress) public {
3062     require(bountyDataAddress != address(0));
3063     require(tcrAddress != address(0));
3064     bountyData = QuantstampBountyData(bountyDataAddress);
3065     bountyRegistry = Registry(tcrAddress);
3066   }
3067 
3068   function getBountyRegistry() public view returns (address) {
3069     return address(bountyRegistry);
3070   }
3071 
3072   /**
3073    * @dev addr is of type Address which is 20 Bytes, but the TCR expects all
3074    * entries to be of type Bytes32. addr is first cast to Uint256 so that it
3075    * becomes 32 bytes long, addr is then shifted 12 bytes (96 bits) to the
3076    * left so the 20 important bytes are in the correct spot.
3077    * @param addr The address of the person who may be an judge.
3078    * @return true If addr is on the TCR (is an judge)
3079    */
3080   function isJudge(address addr) public view returns(bool) {
3081     return bountyRegistry.isWhitelisted(bytes32(uint256(addr) << 96));
3082   }
3083 
3084   /*
3085    * @dev creating a new bounty
3086    * @param contractAddress the address of a smart contract
3087    * @param bountySize bounty size
3088    * @param minVotes the minimum amount of votes required to be considered a bug
3089    * @param duration the duration of the bounty in seconds
3090    * @param judgeDeposit the QSP required for judge deposits
3091    * @param hunterDeposit the QSP required for bug hunter deposits
3092    */
3093   function createBounty(string contractAddress,
3094                         uint256 bountySize,
3095                         uint256 minVotes,
3096                         uint256 duration,
3097                         uint256 judgeDeposit,
3098                         uint256 hunterDeposit) public {
3099     require(bountySize > 0, "bountySize == 0");
3100     require(judgeDeposit > 0, "judgeDeposit == 0");
3101     require(hunterDeposit > 0, "hunterDeposit == 0");
3102     require(minVotes > 0, "minVotes == 0");
3103     require(duration > 0, "duration == 0");
3104 
3105     uint256 bountyId = bountyData.addBounty(msg.sender,
3106       contractAddress,
3107       bountySize,
3108       minVotes,
3109       duration,
3110       judgeDeposit,
3111       hunterDeposit);
3112     // transfer tokens to this contract
3113     bountyData.token().transferFrom(msg.sender, address(this), bountySize);
3114     emit LogBountyCreated(bountyId);
3115   }
3116 
3117   /**
3118    * @dev Commit the hash of a bug submission. Commit-reveal used to avoid front-running.
3119    *      This commitment is NOT partial-locking; every commit requires its own stake.
3120    * @param bountyId the ID of the bounty
3121    * @param bugDescriptionHash the hash of the bug
3122    */
3123   function submitBugCommitment(uint256 bountyId,
3124     bytes32 bugDescriptionHash) public returns (bool) {
3125 
3126     address hunter = msg.sender;
3127     // the bounty exists
3128     require(bountyData.getBountySubmitter(bountyId) != address(0));
3129     // the bounty is accepting commits
3130     require(bountyData.isCommitPeriod(bountyId));
3131     // the amount in wei-QSP that the hunter must deposit for a bug submission
3132     uint256 hunterDeposit = bountyData.getBountyHunterDeposit(bountyId);
3133     // the bug description hash is non-zero
3134     require(bugDescriptionHash != 0);
3135     // msg.sender has approved enough tokens for the deposit
3136     require(bountyData.token().transferFrom(hunter, this, hunterDeposit));
3137 
3138     // create the bug commitment
3139     uint256 bugId = bountyData.addBugCommitment(hunter, bountyId, bugDescriptionHash, hunterDeposit);
3140     emit LogBugCommitted(bugId, hunter, bountyId, bugDescriptionHash, hunterDeposit);
3141 
3142     return true;
3143   }
3144 
3145   /**
3146    * @dev Reveal a previously committed bug.
3147    * @param bugId The ID of the bug commitment
3148    * @param bugDescription The description of the bug
3149    */
3150   function revealBug(uint256 bugId, string bugDescription, uint256 nonce) public returns (bool) {
3151     address hunter = msg.sender;
3152     uint256 bountyId = bountyData.getBugCommitBountyId(bugId);
3153 
3154     // the bug commit exists, and the committer is the hunter
3155     require(bountyData.getBugCommitCommitter(bugId) == hunter);
3156     // the current timestamp is within the reveal period
3157     require(bountyData.isRevealPeriod(bountyId));
3158     // the bounty is active. Otherwise, it's too late to reveal, and funds should
3159     // be rescued using rescueHunterDeposit below (that function does not reveal
3160     // the bug)
3161     require(bountyData.bountyActive(bountyId));
3162     // the hash of the bug description matches the hash and was sent from the hunter
3163     // the hunter address will be converted to lower case after abi.encodePacked
3164     // so be sure to use the lower-case version during bug hash generation.
3165     require(keccak256(abi.encodePacked(bugDescription, hunter, nonce)) == bountyData.getBugCommitBugDescriptionHash(bugId));
3166 
3167     // create a poll for the TCR to vote on the bug
3168     uint256 pollId = bountyData.voting().startPoll(
3169       bountyData.parameterizer().get("voteQuorum"),
3170       bountyData.getBountyJudgeCommitPhaseEndTimestamp(bountyId).sub(block.timestamp),
3171       bountyData.getBountyJudgeRevealDuration(bountyId)
3172     );
3173     // the minimum votes for a vote to succeed
3174     uint256 minVotes = bountyData.getBountyMinVotes(bountyId);
3175     // the judge must stake a deposit to incentivize vote reveal
3176     uint256 judgeDeposit = bountyData.getBountyJudgeDeposit(bountyId);
3177     bountyData.voting().restrictPoll(pollId, minVotes, judgeDeposit);
3178 
3179     // add the bug to the list of revealed bugs
3180     bountyData.addBug(bugId, bugDescription, pollId);
3181 
3182     bountyData.addBugToHunter(hunter, bugId);
3183 
3184     // delete the bug commit
3185     bountyData.removeBugCommitment(bugId);
3186 
3187     emit LogBugRevealed(bountyId, bugId, hunter);
3188     emit LogBugVoteInitiated(bountyId, bugId, pollId);
3189 
3190     return true;
3191   }
3192 
3193   /**
3194    * @dev Rescue a bug hunter's deposit after the bounty has expired.
3195    *      This function allows deposits to be claimed for expired bounties
3196    *      even if they have not yet been claimed)
3197    * @param bugId The ID of the bug commitment
3198    */
3199   function rescueHunterDeposit(uint256 bugId) public returns (bool) {
3200     address hunter = msg.sender;
3201 
3202     // the current timestamp is past the reveal period
3203     require(bountyData.bugRevealPeriodExpired(bugId));
3204 
3205     // Can't rescue anything before the bounty ends
3206     require(!bountyData.bountyActive(bountyData.getBugBountyId(bugId)));
3207 
3208     uint256 bountyId = bountyData.getBugBountyId(bugId);
3209 
3210     if (bountyId != 0 && !bountyData.bountyActive(bountyId)) {
3211       // the bounty was real, but has passed
3212       // the bountyId != 0 only if the bug was revealed. The commitment should have been deleted
3213       require(bountyData.getBugCommitCommitter(bugId) == 0x0);
3214       require(bountyData.getBugHunter(bugId) == hunter);
3215       uint256 pollId = bountyData.getBugPollId(bugId);
3216       require(!bountyData.voting().isEnoughVotes(pollId));
3217       uint256 hunterDeposit = bountyData.getBugNumTokens(bugId);
3218       require(bountyData.token().transfer(hunter, hunterDeposit) && bountyData.removeBugFromHunter(hunter, bugId));
3219       emit LogRevealBugRefund(bugId);
3220       return true;
3221     } else {
3222       // the bug commit exists, and the committer is the hunter
3223       require(bountyData.getBugCommitCommitter(bugId) == hunter);
3224       uint256 hunterCommitDeposit = bountyData.getBugCommitNumTokens(bugId);
3225       // NOTE: this is intentionally without checking the bug description against the hash,
3226       //       as it allows the refund without giving away the bug
3227       // and delete the bug commit
3228       require(bountyData.token().transfer(hunter, hunterCommitDeposit) && bountyData.removeBugCommitment(bugId));
3229       emit LogRevealBugRefund(bugId);
3230       return true;
3231     }
3232   }
3233 
3234   /**
3235    * @dev Gets the next revealed bug for the given bounty in the bug list.
3236    * @param bountyId The ID of the bounty
3237    * @param previousBugId The ID of the previous bug.
3238    */
3239   function getNextRevealedBug(uint256 bountyId, uint256 previousBugId) public view returns (bool, uint256, string) {
3240     return bountyData.getNextRevealedBug(bountyId, previousBugId);
3241   }
3242 
3243   /**
3244    * @dev Gets the first revealed bug for the given bounty.
3245    *      Returns whether a bug exists, its bugId, and the bug string.
3246    * @param bountyId The ID of the bounty
3247    */
3248   function getFirstRevealedBug(uint256 bountyId) public view returns (bool, uint256, string) {
3249     return bountyData.getFirstRevealedBug(bountyId);
3250   }
3251 
3252   /**
3253    * @dev Claims award for a given bug validated by judges
3254    * @param bugId Id of a bug
3255    */
3256   function claimAwardOfBugByHunter(uint256 bugId) public returns (bool) {
3257     if (isBugValidForWithdrawByHunter(bugId)) {
3258       address hunter = msg.sender;
3259       uint256 bountyId = bountyData.getBugBountyId(bugId);
3260       uint256 award = computeHunterAwardPaymentForBug(bountyId);
3261       require(bountyData.token().transfer(hunter, award) && bountyData.removeBugFromHunter(hunter, bugId), "transfer for claim is failed");
3262       return true;
3263     }
3264     return false;
3265   }
3266 
3267   /**
3268    * @dev Claims award for all valid bugs by a hunter
3269    */
3270   function claimAwardOfBugsByHunter() public returns (bool) {
3271     address hunter = msg.sender;
3272     uint256[] memory bugIds = getNotWithdrawnBugs(hunter);
3273     for (uint256 i = 0; i < bugIds.length; i++) {
3274       if (bugIds[i] != 0) {
3275         claimAwardOfBugByHunter(bugIds[i]);
3276       }
3277     }
3278     return true;
3279   }
3280 
3281   /**
3282    * @dev If a bounty has not been fully claimed during its duration, allow the submitter to withdraw the remainder.
3283    * bountyId The ID of the bounty
3284    */
3285   function withdrawRemainingBounty(uint256 bountyId) public returns (bool) {
3286     address submitter = msg.sender;
3287     // the submitter matches the bounty's submitter
3288     require(submitter == bountyData.getBountySubmitter(bountyId));
3289     // the remaining fees have not already been withdrawn
3290     require(!bountyData.getBountyRemainingFeesWithdrawn(bountyId));
3291     // the bounty duration is over
3292     require(!bountyData.bountyActive(bountyId));
3293 
3294     // if the count is 0, the full bounty should be returned, else the remainder after division
3295     uint256 validBugsInBountyCount = allValidBugsInBountyCount(bountyId);
3296     uint256 remainingBounty;
3297     if (validBugsInBountyCount > 0) {
3298       // Need to upgrade openzeppelin for safe mod()
3299       remainingBounty = bountyData.getBountySize(bountyId) % validBugsInBountyCount; //TODO: this should be done?
3300     } else {
3301       remainingBounty = bountyData.getBountySize(bountyId);
3302     }
3303     // mark as withdrawn so the bounty cannot be withdrawn multiple times
3304     bountyData.setBountyRemainingFeesWithdrawn(bountyId);
3305 
3306     bountyData.token().transfer(submitter, remainingBounty);
3307      // log withdraw
3308     emit LogBountyWithdrawn(bountyId, submitter, remainingBounty);
3309   }
3310 
3311   /**
3312    * @dev Claims award for an judge if they voted on the winning side of a poll
3313    * @param bugId Id of a bug
3314    */
3315   function claimJudgeAward(uint256 bugId) public returns (bool) {
3316     address judge = msg.sender;
3317     uint256 bountyId = bountyData.getBugBountyId(bugId);
3318     uint256 pollId = bountyData.getBugPollId(bugId);
3319 
3320     if (!bountyData.canClaimJudgeAward(judge, bugId)) {
3321       // if the poll ended and the judge can't claim (either not enough votes or voted in minority), remove from the list
3322       if (bountyData.voting().pollExists(pollId) &&
3323         bountyData.voting().pollEnded(pollId)) {
3324         bountyData.voting().removePollFromVoter(judge, pollId);
3325       }
3326       // the award cannot be claimed - return
3327       return false;
3328     }
3329     // remove the poll from the unclaimed list; fails gracefully if the poll is not in the list
3330     bountyData.voting().removePollFromVoter(judge, pollId);
3331 
3332     uint256 payment = computeJudgeAward(bountyId, pollId, judge);
3333     // transfer the reward
3334     require(bountyData.token().transfer(judge, payment));
3335     // set that the judge has claimed the reward
3336     bountyData.voting().setVoterClaimedReward(judge, pollId);
3337 
3338     // emit an event
3339     emit LogJudgePaid(bountyId, bugId, judge, payment);
3340     return true;
3341   }
3342 
3343   /**
3344    * @dev Claims awards for all unclaimed polls
3345    */
3346   function claimAllJudgeAwards() public returns (bool) {
3347     address judge = msg.sender;
3348     bool exists;
3349     uint256 pollId;
3350     uint256 nextPollId;
3351     uint256 bugId;
3352     bool claimed;
3353     (exists, pollId) = bountyData.voting().getNextPollFromVoter(judge, bountyData.voting().getListHeadConstant());
3354     while (exists) {
3355       // temporary variable since we might remove the current element from the linked list
3356       (exists, nextPollId) = bountyData.voting().getNextPollFromVoter(judge, pollId);
3357       bugId = bountyData.getBugIdFromPollId(pollId);
3358       claimed = claimJudgeAward(bugId);
3359       pollId = nextPollId;
3360     }
3361   }
3362 
3363   /**
3364    * @dev Determine how much unclaimed award an judge is owed
3365    */
3366   function trackJudgeAwards() public view returns(uint256) {
3367     address judge = msg.sender;
3368     bool exists;
3369     uint256 bountyId;
3370     uint256 pollId;
3371     uint256 bugId;
3372     uint256 hunterDeposit;
3373     uint256 judgeVotes;
3374     uint256 totalVotesForWinningSide;
3375     uint256 payment;
3376     uint256 totalPayment;
3377     (exists, pollId) = bountyData.voting().getNextPollFromVoter(judge, bountyData.voting().getListHeadConstant());
3378     while (exists) {
3379       bugId = bountyData.getBugIdFromPollId(pollId);
3380       bountyId = bountyData.getBugBountyId(bugId);
3381       if (bountyData.canClaimJudgeAward(judge, bugId)) {
3382         // divide the hunter deposit by the total number of judges on the winning side of the poll
3383         hunterDeposit = bountyData.getBountyHunterDeposit(bountyId);
3384         // this is not simply 1 because it is weighted by the amount of QSP attached to the vote
3385         judgeVotes = bountyData.voting().getNumPassingTokens(judge, pollId);
3386         // a winning side cannot have a zero amount of votes
3387         totalVotesForWinningSide = bountyData.voting().getTotalNumberOfTokensForWinningOption(pollId);
3388         payment = computeJudgeAward(bountyId, pollId, judge);
3389         totalPayment = totalPayment.add(payment);
3390       }
3391       (exists, pollId) = bountyData.voting().getNextPollFromVoter(judge, pollId);
3392     }
3393     return totalPayment;
3394   }
3395 
3396   /**
3397    * @dev Determining how much not claimed award a bug hunter has been received so far
3398    */
3399   function trackEarnedBounties() public view returns(uint256) {
3400     address hunter = msg.sender;
3401     uint256 totalAward = 0;
3402     // iterate over all reported bugs by hunter
3403     // if the bounty is finished and hunter won
3404     // then award will be a division of bounty, i.e. bounty.size/number of bugs
3405     uint256[] memory bugIds = getNotWithdrawnBugs(hunter);
3406     for (uint256 i = 0; i < bugIds.length; i++) {
3407       if (bugIds[i] != 0) {
3408         uint256 bountyId = bountyData.getBugBountyId(bugIds[i]);
3409         totalAward = totalAward.add(computeHunterAwardPaymentForBug(bountyId));
3410       }
3411     }
3412     return totalAward;
3413   }
3414 
3415   /**
3416    * @dev Computes the amount earned by a judge for a specified poll
3417    * @param bountyId Id of a bounty containing the poll
3418    * @param pollId Id of a poll
3419    * @param judge the address of the judge for whom awards are calculated
3420    */
3421   function computeJudgeAward(uint256 bountyId, uint256 pollId, address judge) internal view returns (uint256) {
3422     // this is not simply 1 because it is weighted by the amount of QSP attached to the vote
3423     uint256 judgeVotes = bountyData.voting().getNumPassingTokens(judge, pollId);
3424     // this case should be caught by votedWithMajority in canClaimJudgeAward
3425     assert(judgeVotes != 0);
3426     // divide the hunter deposit by the total number of judges on the winning side of the poll
3427     uint256 hunterDeposit = bountyData.getBountyHunterDeposit(bountyId);
3428     // a winning side cannot have a zero amount of votes
3429     uint256 totalVotesForWinningSide = bountyData.voting().getTotalNumberOfTokensForWinningOption(pollId);
3430 
3431     if (bountyData.voting().isPassed(pollId)) {
3432       // The hunter's get their deposit back in true positive cases, and judges split the bounty
3433       // because otherwise the hunters did work for negative income.
3434 
3435       uint256 numApprovedBugs = allValidBugsInBountyCount(bountyId);
3436 
3437       uint256 bountySize = bountyData.getBountySize(bountyId);
3438       uint256 award = computeHunterAwardPaymentForBug(bountyId);
3439 
3440       if (award == bountyData.getBountyHunterDeposit(bountyId)) {
3441         return (bountySize.mul(judgeVotes).div(totalVotesForWinningSide)).div(numApprovedBugs);
3442       } else {
3443         return hunterDeposit.mul(judgeVotes).div(totalVotesForWinningSide);  // NOTE: losing the remainder
3444       }
3445     } else {
3446       // If the bug was a false positive, judges split the hunter's deposit;
3447       return hunterDeposit.mul(judgeVotes).div(totalVotesForWinningSide);  // NOTE: losing the remainder
3448     }
3449   }
3450 
3451   /**
3452    * @dev calculate award of a bug for a given bounty
3453    * @param bountyId Id of a bounty
3454    */
3455   function computeHunterAwardPaymentForBug(uint256 bountyId) internal view returns (uint256) {
3456     uint256 validBugsInBountyCount = allValidBugsInBountyCount(bountyId);
3457     require(validBugsInBountyCount > 0, "expected at least one valid bugId");
3458 
3459     uint256 huntersAward = bountyData.getBountySize(bountyId);
3460     uint256 award = huntersAward.div(validBugsInBountyCount);
3461     // NOTE: the remainder after division can be retrieved by the bounty provider
3462 
3463     if (award < bountyData.getBountyHunterDeposit(bountyId)) {
3464       return bountyData.getBountyHunterDeposit(bountyId);
3465     }
3466 
3467     return award;
3468   }
3469 
3470   /**
3471    * @dev Checks if an award for the given bug can be claimed
3472    * @param bugId Id of a bug
3473    */
3474   function isBugValidForWithdrawByHunter(uint256 bugId) internal view returns (bool) {
3475     uint256 bountyId = bountyData.getBugBountyId(bugId);
3476     bool isDurationPassed = bountyData.getBountyInitiationTimestamp(bountyId).add(bountyData.getBountyDuration(bountyId)) < block.timestamp;
3477     uint256 pollId = bountyData.getBugPollId(bugId);
3478     bool isVoted;
3479     if (bountyData.voting().pollExists(pollId) && bountyData.voting().pollEnded(pollId)) {
3480       isVoted = bountyData.voting().isPassed(pollId);
3481     } else {
3482       isVoted = false;
3483     }
3484     return isDurationPassed && isVoted;
3485   }
3486 
3487   /**
3488    * @dev Extracting an array of bugIds that a given hunter can claim for payment
3489    * @param hunter The address of a hunter
3490    * @return an array of bugs. Note that this array might have zeros, invalid bugIds. Iterating over the array,
3491    *         such elements should be skipped.
3492    */
3493   function getNotWithdrawnBugs(address hunter) internal view returns (uint256[] memory) {
3494     uint256[] memory bugIds = new uint256[](bountyData.getHunterReportedBugsCount(hunter));
3495     uint256 bugIdsIndex;
3496     uint256 bugId;
3497     bool exists;
3498     (exists, bugId) = bountyData.getNextBugFromHunter(hunter, bountyData.getListHeadConstant());
3499     while (exists) {
3500       if (isBugValidForWithdrawByHunter(bugId)) {
3501         bugIds[bugIdsIndex] = bugId;
3502         bugIdsIndex = bugIdsIndex.add(1);
3503       }
3504       (exists, bugId) = bountyData.getNextBugFromHunter(hunter, bugId);
3505     }
3506     return bugIds;
3507   }
3508 
3509   /**
3510    * @dev counting all valid bugs for a bounty
3511    * @param bountyId passing a bounty
3512    */
3513   function allValidBugsInBountyCount(uint256 bountyId) internal view returns(uint256) {
3514     return bountyData.getNumApprovedBugs(bountyId);
3515   }
3516 }