1 pragma solidity 0.4.24;
2 
3 /**
4  * @title LinkedListLib
5  * @author Darryl Morris (o0ragman0o) and Modular.network
6  *
7  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
8  * into the Modular-Network ethereum-libraries repo at https://github.com/Modular-Network/ethereum-libraries
9  * It has been updated to add additional functionality and be more compatible with solidity 0.4.18
10  * coding patterns.
11  *
12  * version 1.1.1
13  * Copyright (c) 2017 Modular Inc.
14  * The MIT License (MIT)
15  * https://github.com/Modular-network/ethereum-libraries/blob/master/LICENSE
16  *
17  * The LinkedListLib provides functionality for implementing data indexing using
18  * a circlular linked list
19  *
20  * Modular provides smart contract services and security reviews for contract
21  * deployments in addition to working on open source projects in the Ethereum
22  * community. Our purpose is to test, document, and deploy reusable code onto the
23  * blockchain and improve both security and usability. We also educate non-profits,
24  * schools, and other community members about the application of blockchain
25  * technology. For further information: modular.network
26  *
27  *
28  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
29  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
30  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
31  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
32  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
33  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
34  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
35 */
36 
37 
38 library LinkedListLib {
39 
40     uint256 constant NULL = 0;
41     uint256 constant HEAD = 0;
42     bool constant PREV = false;
43     bool constant NEXT = true;
44 
45     struct LinkedList{
46         mapping (uint256 => mapping (bool => uint256)) list;
47     }
48 
49     /// @dev returns true if the list exists
50     /// @param self stored linked list from contract
51     function listExists(LinkedList storage self)
52         public
53         view returns (bool)
54     {
55         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
56         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
57             return true;
58         } else {
59             return false;
60         }
61     }
62 
63     /// @dev returns true if the node exists
64     /// @param self stored linked list from contract
65     /// @param _node a node to search for
66     function nodeExists(LinkedList storage self, uint256 _node)
67         public
68         view returns (bool)
69     {
70         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
71             if (self.list[HEAD][NEXT] == _node) {
72                 return true;
73             } else {
74                 return false;
75             }
76         } else {
77             return true;
78         }
79     }
80 
81     /// @dev Returns the number of elements in the list
82     /// @param self stored linked list from contract
83     function sizeOf(LinkedList storage self) public view returns (uint256 numElements) {
84         bool exists;
85         uint256 i;
86         (exists,i) = getAdjacent(self, HEAD, NEXT);
87         while (i != HEAD) {
88             (exists,i) = getAdjacent(self, i, NEXT);
89             numElements++;
90         }
91         return;
92     }
93 
94     /// @dev Returns the links of a node as a tuple
95     /// @param self stored linked list from contract
96     /// @param _node id of the node to get
97     function getNode(LinkedList storage self, uint256 _node)
98         public view returns (bool,uint256,uint256)
99     {
100         if (!nodeExists(self,_node)) {
101             return (false,0,0);
102         } else {
103             return (true,self.list[_node][PREV], self.list[_node][NEXT]);
104         }
105     }
106 
107     /// @dev Returns the link of a node `_node` in direction `_direction`.
108     /// @param self stored linked list from contract
109     /// @param _node id of the node to step from
110     /// @param _direction direction to step in
111     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
112         public view returns (bool,uint256)
113     {
114         if (!nodeExists(self,_node)) {
115             return (false,0);
116         } else {
117             return (true,self.list[_node][_direction]);
118         }
119     }
120 
121     /// @dev Can be used before `insert` to build an ordered list
122     /// @param self stored linked list from contract
123     /// @param _node an existing node to search from, e.g. HEAD.
124     /// @param _value value to seek
125     /// @param _direction direction to seek in
126     //  @return next first node beyond '_node' in direction `_direction`
127     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
128         public view returns (uint256)
129     {
130         if (sizeOf(self) == 0) { return 0; }
131         require((_node == 0) || nodeExists(self,_node));
132         bool exists;
133         uint256 next;
134         (exists,next) = getAdjacent(self, _node, _direction);
135         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
136         return next;
137     }
138 
139     /// @dev Creates a bidirectional link between two nodes on direction `_direction`
140     /// @param self stored linked list from contract
141     /// @param _node first node for linking
142     /// @param _link  node to link to in the _direction
143     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) private  {
144         self.list[_link][!_direction] = _node;
145         self.list[_node][_direction] = _link;
146     }
147 
148     /// @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
149     /// @param self stored linked list from contract
150     /// @param _node existing node
151     /// @param _new  new node to insert
152     /// @param _direction direction to insert node in
153     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) internal returns (bool) {
154         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
155             uint256 c = self.list[_node][_direction];
156             createLink(self, _node, _new, _direction);
157             createLink(self, _new, c, _direction);
158             return true;
159         } else {
160             return false;
161         }
162     }
163 
164     /// @dev removes an entry from the linked list
165     /// @param self stored linked list from contract
166     /// @param _node node to remove from the list
167     function remove(LinkedList storage self, uint256 _node) internal returns (uint256) {
168         if ((_node == NULL) || (!nodeExists(self,_node))) { return 0; }
169         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
170         delete self.list[_node][PREV];
171         delete self.list[_node][NEXT];
172         return _node;
173     }
174 
175     /// @dev pushes an enrty to the head of the linked list
176     /// @param self stored linked list from contract
177     /// @param _node new entry to push to the head
178     /// @param _direction push to the head (NEXT) or tail (PREV)
179     function push(LinkedList storage self, uint256 _node, bool _direction) internal  {
180         insert(self, HEAD, _node, _direction);
181     }
182 
183     /// @dev pops the first entry from the linked list
184     /// @param self stored linked list from contract
185     /// @param _direction pop from the head (NEXT) or the tail (PREV)
186     function pop(LinkedList storage self, bool _direction) internal returns (uint256) {
187         bool exists;
188         uint256 adj;
189 
190         (exists,adj) = getAdjacent(self, HEAD, _direction);
191 
192         return remove(self, adj);
193     }
194 }
195 // Abstract contract for the full ERC 20 Token standard
196 // https://github.com/ethereum/EIPs/issues/20
197 
198 
199 contract EIP20Interface {
200     /* This is a slight change to the ERC20 base standard.
201     function totalSupply() constant returns (uint256 supply);
202     is replaced with:
203     uint256 public totalSupply;
204     This automatically creates a getter function for the totalSupply.
205     This is moved to the base contract since public getter functions are not
206     currently recognised as an implementation of the matching abstract
207     function by the compiler.
208     */
209     /// total amount of tokens
210     uint256 public totalSupply;
211 
212     /// @param _owner The address from which the balance will be retrieved
213     /// @return The balance
214     function balanceOf(address _owner) public view returns (uint256 balance);
215 
216     /// @notice send `_value` token to `_to` from `msg.sender`
217     /// @param _to The address of the recipient
218     /// @param _value The amount of token to be transferred
219     /// @return Whether the transfer was successful or not
220     function transfer(address _to, uint256 _value) public returns (bool success);
221 
222     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
223     /// @param _from The address of the sender
224     /// @param _to The address of the recipient
225     /// @param _value The amount of token to be transferred
226     /// @return Whether the transfer was successful or not
227     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
228 
229     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
230     /// @param _spender The address of the account able to transfer the tokens
231     /// @param _value The amount of tokens to be approved for transfer
232     /// @return Whether the approval was successful or not
233     function approve(address _spender, uint256 _value) public returns (bool success);
234 
235     /// @param _owner The address of the account owning tokens
236     /// @param _spender The address of the account able to transfer the tokens
237     /// @return Amount of remaining tokens allowed to spent
238     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
239 
240     event Transfer(address indexed _from, address indexed _to, uint256 _value);
241     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
242 }
243 
244 
245 
246 /**
247  * @title ERC20Basic
248  * @dev Simpler version of ERC20 interface
249  * @dev see https://github.com/ethereum/EIPs/issues/179
250  */
251 contract ERC20Basic {
252   function totalSupply() public view returns (uint256);
253   function balanceOf(address who) public view returns (uint256);
254   function transfer(address to, uint256 value) public returns (bool);
255   event Transfer(address indexed from, address indexed to, uint256 value);
256 }
257 
258 
259 
260 /**
261  * @title SafeMath
262  * @dev Math operations with safety checks that throw on error
263  */
264 library SafeMath {
265 
266   /**
267   * @dev Multiplies two numbers, throws on overflow.
268   */
269   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
270     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
271     // benefit is lost if 'b' is also tested.
272     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
273     if (a == 0) {
274       return 0;
275     }
276 
277     c = a * b;
278     assert(c / a == b);
279     return c;
280   }
281 
282   /**
283   * @dev Integer division of two numbers, truncating the quotient.
284   */
285   function div(uint256 a, uint256 b) internal pure returns (uint256) {
286     // assert(b > 0); // Solidity automatically throws when dividing by 0
287     // uint256 c = a / b;
288     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289     return a / b;
290   }
291 
292   /**
293   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
294   */
295   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296     assert(b <= a);
297     return a - b;
298   }
299 
300   /**
301   * @dev Adds two numbers, throws on overflow.
302   */
303   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
304     c = a + b;
305     assert(c >= a);
306     return c;
307   }
308 }
309 
310 
311 library AttributeStore {
312     struct Data {
313         mapping(bytes32 => uint) store;
314     }
315 
316     function getAttribute(Data storage self, bytes32 _UUID, string _attrName)
317     public view returns (uint) {
318         bytes32 key = keccak256(_UUID, _attrName);
319         return self.store[key];
320     }
321 
322     function setAttribute(Data storage self, bytes32 _UUID, string _attrName, uint _attrVal)
323     public {
324         bytes32 key = keccak256(_UUID, _attrName);
325         self.store[key] = _attrVal;
326     }
327 }
328 
329 
330 library DLL {
331 
332   uint constant NULL_NODE_ID = 0;
333 
334   struct Node {
335     uint next;
336     uint prev;
337   }
338 
339   struct Data {
340     mapping(uint => Node) dll;
341   }
342 
343   function isEmpty(Data storage self) public view returns (bool) {
344     return getStart(self) == NULL_NODE_ID;
345   }
346 
347   function contains(Data storage self, uint _curr) public view returns (bool) {
348     if (isEmpty(self) || _curr == NULL_NODE_ID) {
349       return false;
350     } 
351 
352     bool isSingleNode = (getStart(self) == _curr) && (getEnd(self) == _curr);
353     bool isNullNode = (getNext(self, _curr) == NULL_NODE_ID) && (getPrev(self, _curr) == NULL_NODE_ID);
354     return isSingleNode || !isNullNode;
355   }
356 
357   function getNext(Data storage self, uint _curr) public view returns (uint) {
358     return self.dll[_curr].next;
359   }
360 
361   function getPrev(Data storage self, uint _curr) public view returns (uint) {
362     return self.dll[_curr].prev;
363   }
364 
365   function getStart(Data storage self) public view returns (uint) {
366     return getNext(self, NULL_NODE_ID);
367   }
368 
369   function getEnd(Data storage self) public view returns (uint) {
370     return getPrev(self, NULL_NODE_ID);
371   }
372 
373   /**
374   @dev Inserts a new node between _prev and _next. When inserting a node already existing in 
375   the list it will be automatically removed from the old position.
376   @param _prev the node which _new will be inserted after
377   @param _curr the id of the new node being inserted
378   @param _next the node which _new will be inserted before
379   */
380   function insert(Data storage self, uint _prev, uint _curr, uint _next) public {
381     require(_curr != NULL_NODE_ID);
382 
383     remove(self, _curr);
384 
385     require(_prev == NULL_NODE_ID || contains(self, _prev));
386     require(_next == NULL_NODE_ID || contains(self, _next));
387 
388     require(getNext(self, _prev) == _next);
389     require(getPrev(self, _next) == _prev);
390 
391     self.dll[_curr].prev = _prev;
392     self.dll[_curr].next = _next;
393 
394     self.dll[_prev].next = _curr;
395     self.dll[_next].prev = _curr;
396   }
397 
398   function remove(Data storage self, uint _curr) public {
399     if (!contains(self, _curr)) {
400       return;
401     }
402 
403     uint next = getNext(self, _curr);
404     uint prev = getPrev(self, _curr);
405 
406     self.dll[next].prev = prev;
407     self.dll[prev].next = next;
408 
409     delete self.dll[_curr];
410   }
411 }
412 
413 
414 
415 /**
416  * @title Roles
417  * @author Francisco Giordano (@frangio)
418  * @dev Library for managing addresses assigned to a Role.
419  *      See RBAC.sol for example usage.
420  */
421 library Roles {
422   struct Role {
423     mapping (address => bool) bearer;
424   }
425 
426   /**
427    * @dev give an address access to this role
428    */
429   function add(Role storage role, address addr)
430     internal
431   {
432     role.bearer[addr] = true;
433   }
434 
435   /**
436    * @dev remove an address' access to this role
437    */
438   function remove(Role storage role, address addr)
439     internal
440   {
441     role.bearer[addr] = false;
442   }
443 
444   /**
445    * @dev check if an address has this role
446    * // reverts
447    */
448   function check(Role storage role, address addr)
449     view
450     internal
451   {
452     require(has(role, addr));
453   }
454 
455   /**
456    * @dev check if an address has this role
457    * @return bool
458    */
459   function has(Role storage role, address addr)
460     view
461     internal
462     returns (bool)
463   {
464     return role.bearer[addr];
465   }
466 }
467 
468 
469 
470 
471 
472 /**
473  * @title RBAC (Role-Based Access Control)
474  * @author Matt Condon (@Shrugs)
475  * @dev Stores and provides setters and getters for roles and addresses.
476  * @dev Supports unlimited numbers of roles and addresses.
477  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
478  * This RBAC method uses strings to key roles. It may be beneficial
479  *  for you to write your own implementation of this interface using Enums or similar.
480  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
481  *  to avoid typos.
482  */
483 contract RBAC {
484   using Roles for Roles.Role;
485 
486   mapping (string => Roles.Role) private roles;
487 
488   event RoleAdded(address addr, string roleName);
489   event RoleRemoved(address addr, string roleName);
490 
491   /**
492    * @dev reverts if addr does not have role
493    * @param addr address
494    * @param roleName the name of the role
495    * // reverts
496    */
497   function checkRole(address addr, string roleName)
498     view
499     public
500   {
501     roles[roleName].check(addr);
502   }
503 
504   /**
505    * @dev determine if addr has role
506    * @param addr address
507    * @param roleName the name of the role
508    * @return bool
509    */
510   function hasRole(address addr, string roleName)
511     view
512     public
513     returns (bool)
514   {
515     return roles[roleName].has(addr);
516   }
517 
518   /**
519    * @dev add a role to an address
520    * @param addr address
521    * @param roleName the name of the role
522    */
523   function addRole(address addr, string roleName)
524     internal
525   {
526     roles[roleName].add(addr);
527     emit RoleAdded(addr, roleName);
528   }
529 
530   /**
531    * @dev remove a role from an address
532    * @param addr address
533    * @param roleName the name of the role
534    */
535   function removeRole(address addr, string roleName)
536     internal
537   {
538     roles[roleName].remove(addr);
539     emit RoleRemoved(addr, roleName);
540   }
541 
542   /**
543    * @dev modifier to scope access to a single role (uses msg.sender as addr)
544    * @param roleName the name of the role
545    * // reverts
546    */
547   modifier onlyRole(string roleName)
548   {
549     checkRole(msg.sender, roleName);
550     _;
551   }
552 
553   /**
554    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
555    * @param roleNames the names of the roles to scope access to
556    * // reverts
557    *
558    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
559    *  see: https://github.com/ethereum/solidity/issues/2467
560    */
561   // modifier onlyRoles(string[] roleNames) {
562   //     bool hasAnyRole = false;
563   //     for (uint8 i = 0; i < roleNames.length; i++) {
564   //         if (hasRole(msg.sender, roleNames[i])) {
565   //             hasAnyRole = true;
566   //             break;
567   //         }
568   //     }
569 
570   //     require(hasAnyRole);
571 
572   //     _;
573   // }
574 }
575 
576 
577 
578 /**
579  * @title Ownable
580  * @dev The Ownable contract has an owner address, and provides basic authorization control
581  * functions, this simplifies the implementation of "user permissions".
582  */
583 contract Ownable {
584   address public owner;
585 
586 
587   event OwnershipRenounced(address indexed previousOwner);
588   event OwnershipTransferred(
589     address indexed previousOwner,
590     address indexed newOwner
591   );
592 
593 
594   /**
595    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
596    * account.
597    */
598   constructor() public {
599     owner = msg.sender;
600   }
601 
602   /**
603    * @dev Throws if called by any account other than the owner.
604    */
605   modifier onlyOwner() {
606     require(msg.sender == owner);
607     _;
608   }
609 
610   /**
611    * @dev Allows the current owner to relinquish control of the contract.
612    */
613   function renounceOwnership() public onlyOwner {
614     emit OwnershipRenounced(owner);
615     owner = address(0);
616   }
617 
618   /**
619    * @dev Allows the current owner to transfer control of the contract to a newOwner.
620    * @param _newOwner The address to transfer ownership to.
621    */
622   function transferOwnership(address _newOwner) public onlyOwner {
623     _transferOwnership(_newOwner);
624   }
625 
626   /**
627    * @dev Transfers control of the contract to a newOwner.
628    * @param _newOwner The address to transfer ownership to.
629    */
630   function _transferOwnership(address _newOwner) internal {
631     require(_newOwner != address(0));
632     emit OwnershipTransferred(owner, _newOwner);
633     owner = _newOwner;
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
654 /**
655 @title Partial-Lock-Commit-Reveal Voting scheme with ERC20 tokens
656 @author Team: Aspyn Palatnick, Cem Ozer, Yorke Rhodes
657 */
658 contract PLCRVoting {
659 
660     // ============
661     // EVENTS:
662     // ============
663 
664     event _VoteCommitted(uint indexed pollID, uint numTokens, address indexed voter);
665     event _VoteRevealed(uint indexed pollID, uint numTokens, uint votesFor, uint votesAgainst, uint indexed choice, address indexed voter, uint salt);
666     event _PollCreated(uint voteQuorum, uint commitEndDate, uint revealEndDate, uint indexed pollID, address indexed creator);
667     event _VotingRightsGranted(uint numTokens, address indexed voter);
668     event _VotingRightsWithdrawn(uint numTokens, address indexed voter);
669     event _TokensRescued(uint indexed pollID, address indexed voter);
670 
671     // ============
672     // DATA STRUCTURES:
673     // ============
674 
675     using AttributeStore for AttributeStore.Data;
676     using DLL for DLL.Data;
677     using SafeMath for uint;
678 
679     struct Poll {
680         uint commitEndDate;     /// expiration date of commit period for poll
681         uint revealEndDate;     /// expiration date of reveal period for poll
682         uint voteQuorum;	    /// number of votes required for a proposal to pass
683         uint votesFor;		    /// tally of votes supporting proposal
684         uint votesAgainst;      /// tally of votes countering proposal
685         mapping(address => bool) didCommit;   /// indicates whether an address committed a vote for this poll
686         mapping(address => bool) didReveal;   /// indicates whether an address revealed a vote for this poll
687         mapping(address => uint) voteOptions; /// stores the voteOption of an address that revealed
688     }
689 
690     // ============
691     // STATE VARIABLES:
692     // ============
693 
694     uint constant public INITIAL_POLL_NONCE = 0;
695     uint public pollNonce;
696 
697     mapping(uint => Poll) public pollMap; // maps pollID to Poll struct
698     mapping(address => uint) public voteTokenBalance; // maps user's address to voteToken balance
699 
700     mapping(address => DLL.Data) dllMap;
701     AttributeStore.Data store;
702 
703     EIP20Interface public token;
704 
705     /**
706     @dev Initializer. Can only be called once.
707     @param _token The address where the ERC20 token contract is deployed
708     */
709     function init(address _token) public {
710         require(_token != address(0) && address(token) == address(0));
711 
712         token = EIP20Interface(_token);
713         pollNonce = INITIAL_POLL_NONCE;
714     }
715 
716     // ================
717     // TOKEN INTERFACE:
718     // ================
719 
720     /**
721     @notice Loads _numTokens ERC20 tokens into the voting contract for one-to-one voting rights
722     @dev Assumes that msg.sender has approved voting contract to spend on their behalf
723     @param _numTokens The number of votingTokens desired in exchange for ERC20 tokens
724     */
725     function requestVotingRights(uint _numTokens) public {
726         require(token.balanceOf(msg.sender) >= _numTokens);
727         voteTokenBalance[msg.sender] += _numTokens;
728         require(token.transferFrom(msg.sender, this, _numTokens));
729         emit _VotingRightsGranted(_numTokens, msg.sender);
730     }
731 
732     /**
733     @notice Withdraw _numTokens ERC20 tokens from the voting contract, revoking these voting rights
734     @param _numTokens The number of ERC20 tokens desired in exchange for voting rights
735     */
736     function withdrawVotingRights(uint _numTokens) external {
737         uint availableTokens = voteTokenBalance[msg.sender].sub(getLockedTokens(msg.sender));
738         require(availableTokens >= _numTokens);
739         voteTokenBalance[msg.sender] -= _numTokens;
740         require(token.transfer(msg.sender, _numTokens));
741         emit _VotingRightsWithdrawn(_numTokens, msg.sender);
742     }
743 
744     /**
745     @dev Unlocks tokens locked in unrevealed vote where poll has ended
746     @param _pollID Integer identifier associated with the target poll
747     */
748     function rescueTokens(uint _pollID) public {
749         require(isExpired(pollMap[_pollID].revealEndDate));
750         require(dllMap[msg.sender].contains(_pollID));
751 
752         dllMap[msg.sender].remove(_pollID);
753         emit _TokensRescued(_pollID, msg.sender);
754     }
755 
756     /**
757     @dev Unlocks tokens locked in unrevealed votes where polls have ended
758     @param _pollIDs Array of integer identifiers associated with the target polls
759     */
760     function rescueTokensInMultiplePolls(uint[] _pollIDs) public {
761         // loop through arrays, rescuing tokens from all
762         for (uint i = 0; i < _pollIDs.length; i++) {
763             rescueTokens(_pollIDs[i]);
764         }
765     }
766 
767     // =================
768     // VOTING INTERFACE:
769     // =================
770 
771     /**
772     @notice Commits vote using hash of choice and secret salt to conceal vote until reveal
773     @param _pollID Integer identifier associated with target poll
774     @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
775     @param _numTokens The number of tokens to be committed towards the target poll
776     @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
777     */
778     function commitVote(uint _pollID, bytes32 _secretHash, uint _numTokens, uint _prevPollID) public {
779         require(commitPeriodActive(_pollID));
780 
781         // if msg.sender doesn't have enough voting rights,
782         // request for enough voting rights
783         if (voteTokenBalance[msg.sender] < _numTokens) {
784             uint remainder = _numTokens.sub(voteTokenBalance[msg.sender]);
785             requestVotingRights(remainder);
786         }
787 
788         // make sure msg.sender has enough voting rights
789         require(voteTokenBalance[msg.sender] >= _numTokens);
790         // prevent user from committing to zero node placeholder
791         require(_pollID != 0);
792         // prevent user from committing a secretHash of 0
793         require(_secretHash != 0);
794 
795         // Check if _prevPollID exists in the user's DLL or if _prevPollID is 0
796         require(_prevPollID == 0 || dllMap[msg.sender].contains(_prevPollID));
797 
798         uint nextPollID = dllMap[msg.sender].getNext(_prevPollID);
799 
800         // edge case: in-place update
801         if (nextPollID == _pollID) {
802             nextPollID = dllMap[msg.sender].getNext(_pollID);
803         }
804 
805         require(validPosition(_prevPollID, nextPollID, msg.sender, _numTokens));
806         dllMap[msg.sender].insert(_prevPollID, _pollID, nextPollID);
807 
808         bytes32 UUID = attrUUID(msg.sender, _pollID);
809 
810         store.setAttribute(UUID, "numTokens", _numTokens);
811         store.setAttribute(UUID, "commitHash", uint(_secretHash));
812 
813         pollMap[_pollID].didCommit[msg.sender] = true;
814         emit _VoteCommitted(_pollID, _numTokens, msg.sender);
815     }
816 
817     /**
818     @notice                 Commits votes using hashes of choices and secret salts to conceal votes until reveal
819     @param _pollIDs         Array of integer identifiers associated with target polls
820     @param _secretHashes    Array of commit keccak256 hashes of voter's choices and salts (tightly packed in this order)
821     @param _numsTokens      Array of numbers of tokens to be committed towards the target polls
822     @param _prevPollIDs     Array of IDs of the polls that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
823     */
824     function commitVotes(uint[] _pollIDs, bytes32[] _secretHashes, uint[] _numsTokens, uint[] _prevPollIDs) external {
825         // make sure the array lengths are all the same
826         require(_pollIDs.length == _secretHashes.length);
827         require(_pollIDs.length == _numsTokens.length);
828         require(_pollIDs.length == _prevPollIDs.length);
829 
830         // loop through arrays, committing each individual vote values
831         for (uint i = 0; i < _pollIDs.length; i++) {
832             commitVote(_pollIDs[i], _secretHashes[i], _numsTokens[i], _prevPollIDs[i]);
833         }
834     }
835 
836     /**
837     @dev Compares previous and next poll's committed tokens for sorting purposes
838     @param _prevID Integer identifier associated with previous poll in sorted order
839     @param _nextID Integer identifier associated with next poll in sorted order
840     @param _voter Address of user to check DLL position for
841     @param _numTokens The number of tokens to be committed towards the poll (used for sorting)
842     @return valid Boolean indication of if the specified position maintains the sort
843     */
844     function validPosition(uint _prevID, uint _nextID, address _voter, uint _numTokens) public constant returns (bool valid) {
845         bool prevValid = (_numTokens >= getNumTokens(_voter, _prevID));
846         // if next is zero node, _numTokens does not need to be greater
847         bool nextValid = (_numTokens <= getNumTokens(_voter, _nextID) || _nextID == 0);
848         return prevValid && nextValid;
849     }
850 
851     /**
852     @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
853     @param _pollID Integer identifier associated with target poll
854     @param _voteOption Vote choice used to generate commitHash for associated poll
855     @param _salt Secret number used to generate commitHash for associated poll
856     */
857     function revealVote(uint _pollID, uint _voteOption, uint _salt) public {
858         // Make sure the reveal period is active
859         require(revealPeriodActive(_pollID));
860         require(pollMap[_pollID].didCommit[msg.sender]);                         // make sure user has committed a vote for this poll
861         require(!pollMap[_pollID].didReveal[msg.sender]);                        // prevent user from revealing multiple times
862         require(keccak256(abi.encodePacked(_voteOption, _salt)) == getCommitHash(msg.sender, _pollID)); // compare resultant hash from inputs to original commitHash
863 
864         uint numTokens = getNumTokens(msg.sender, _pollID);
865 
866         if (_voteOption == 1) {// apply numTokens to appropriate poll choice
867             pollMap[_pollID].votesFor += numTokens;
868         } else {
869             pollMap[_pollID].votesAgainst += numTokens;
870         }
871 
872         dllMap[msg.sender].remove(_pollID); // remove the node referring to this vote upon reveal
873         pollMap[_pollID].didReveal[msg.sender] = true;
874         pollMap[_pollID].voteOptions[msg.sender] = _voteOption;
875 
876         emit _VoteRevealed(_pollID, numTokens, pollMap[_pollID].votesFor, pollMap[_pollID].votesAgainst, _voteOption, msg.sender, _salt);
877     }
878 
879     /**
880     @notice             Reveals multiple votes with choices and secret salts used in generating commitHashes to attribute committed tokens
881     @param _pollIDs     Array of integer identifiers associated with target polls
882     @param _voteOptions Array of vote choices used to generate commitHashes for associated polls
883     @param _salts       Array of secret numbers used to generate commitHashes for associated polls
884     */
885     function revealVotes(uint[] _pollIDs, uint[] _voteOptions, uint[] _salts) external {
886         // make sure the array lengths are all the same
887         require(_pollIDs.length == _voteOptions.length);
888         require(_pollIDs.length == _salts.length);
889 
890         // loop through arrays, revealing each individual vote values
891         for (uint i = 0; i < _pollIDs.length; i++) {
892             revealVote(_pollIDs[i], _voteOptions[i], _salts[i]);
893         }
894     }
895 
896     /**
897     @param _voter           Address of voter who voted in the majority bloc
898     @param _pollID          Integer identifier associated with target poll
899     @return correctVotes    Number of tokens voted for winning option
900     */
901     function getNumPassingTokens(address _voter, uint _pollID) public constant returns (uint correctVotes) {
902         require(pollEnded(_pollID));
903         require(pollMap[_pollID].didReveal[_voter]);
904 
905         uint winningChoice = isPassed(_pollID) ? 1 : 0;
906         uint voterVoteOption = pollMap[_pollID].voteOptions[_voter];
907 
908         require(voterVoteOption == winningChoice, "Voter revealed, but not in the majority");
909 
910         return getNumTokens(_voter, _pollID);
911     }
912 
913     // ==================
914     // POLLING INTERFACE:
915     // ==================
916 
917     /**
918     @dev Initiates a poll with canonical configured parameters at pollID emitted by PollCreated event
919     @param _voteQuorum Type of majority (out of 100) that is necessary for poll to be successful
920     @param _commitDuration Length of desired commit period in seconds
921     @param _revealDuration Length of desired reveal period in seconds
922     */
923     function startPoll(uint _voteQuorum, uint _commitDuration, uint _revealDuration) public returns (uint pollID) {
924         pollNonce = pollNonce + 1;
925 
926         uint commitEndDate = block.timestamp.add(_commitDuration);
927         uint revealEndDate = commitEndDate.add(_revealDuration);
928 
929         pollMap[pollNonce] = Poll({
930             voteQuorum: _voteQuorum,
931             commitEndDate: commitEndDate,
932             revealEndDate: revealEndDate,
933             votesFor: 0,
934             votesAgainst: 0
935         });
936 
937         emit _PollCreated(_voteQuorum, commitEndDate, revealEndDate, pollNonce, msg.sender);
938         return pollNonce;
939     }
940 
941     /**
942     @notice Determines if proposal has passed
943     @dev Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
944     @param _pollID Integer identifier associated with target poll
945     */
946     function isPassed(uint _pollID) constant public returns (bool passed) {
947         require(pollEnded(_pollID));
948 
949         Poll memory poll = pollMap[_pollID];
950         return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
951     }
952 
953     // ----------------
954     // POLLING HELPERS:
955     // ----------------
956 
957     /**
958     @dev Gets the total winning votes for reward distribution purposes
959     @param _pollID Integer identifier associated with target poll
960     @return Total number of votes committed to the winning option for specified poll
961     */
962     function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint numTokens) {
963         require(pollEnded(_pollID));
964 
965         if (isPassed(_pollID))
966             return pollMap[_pollID].votesFor;
967         else
968             return pollMap[_pollID].votesAgainst;
969     }
970 
971     /**
972     @notice Determines if poll is over
973     @dev Checks isExpired for specified poll's revealEndDate
974     @return Boolean indication of whether polling period is over
975     */
976     function pollEnded(uint _pollID) constant public returns (bool ended) {
977         require(pollExists(_pollID));
978 
979         return isExpired(pollMap[_pollID].revealEndDate);
980     }
981 
982     /**
983     @notice Checks if the commit period is still active for the specified poll
984     @dev Checks isExpired for the specified poll's commitEndDate
985     @param _pollID Integer identifier associated with target poll
986     @return Boolean indication of isCommitPeriodActive for target poll
987     */
988     function commitPeriodActive(uint _pollID) constant public returns (bool active) {
989         require(pollExists(_pollID));
990 
991         return !isExpired(pollMap[_pollID].commitEndDate);
992     }
993 
994     /**
995     @notice Checks if the reveal period is still active for the specified poll
996     @dev Checks isExpired for the specified poll's revealEndDate
997     @param _pollID Integer identifier associated with target poll
998     */
999     function revealPeriodActive(uint _pollID) constant public returns (bool active) {
1000         require(pollExists(_pollID));
1001 
1002         return !isExpired(pollMap[_pollID].revealEndDate) && !commitPeriodActive(_pollID);
1003     }
1004 
1005     /**
1006     @dev Checks if user has committed for specified poll
1007     @param _voter Address of user to check against
1008     @param _pollID Integer identifier associated with target poll
1009     @return Boolean indication of whether user has committed
1010     */
1011     function didCommit(address _voter, uint _pollID) constant public returns (bool committed) {
1012         require(pollExists(_pollID));
1013 
1014         return pollMap[_pollID].didCommit[_voter];
1015     }
1016 
1017     /**
1018     @dev Checks if user has revealed for specified poll
1019     @param _voter Address of user to check against
1020     @param _pollID Integer identifier associated with target poll
1021     @return Boolean indication of whether user has revealed
1022     */
1023     function didReveal(address _voter, uint _pollID) constant public returns (bool revealed) {
1024         require(pollExists(_pollID));
1025 
1026         return pollMap[_pollID].didReveal[_voter];
1027     }
1028 
1029     /**
1030     @dev Checks if a poll exists
1031     @param _pollID The pollID whose existance is to be evaluated.
1032     @return Boolean Indicates whether a poll exists for the provided pollID
1033     */
1034     function pollExists(uint _pollID) constant public returns (bool exists) {
1035         return (_pollID != 0 && _pollID <= pollNonce);
1036     }
1037 
1038     // ---------------------------
1039     // DOUBLE-LINKED-LIST HELPERS:
1040     // ---------------------------
1041 
1042     /**
1043     @dev Gets the bytes32 commitHash property of target poll
1044     @param _voter Address of user to check against
1045     @param _pollID Integer identifier associated with target poll
1046     @return Bytes32 hash property attached to target poll
1047     */
1048     function getCommitHash(address _voter, uint _pollID) constant public returns (bytes32 commitHash) {
1049         return bytes32(store.getAttribute(attrUUID(_voter, _pollID), "commitHash"));
1050     }
1051 
1052     /**
1053     @dev Wrapper for getAttribute with attrName="numTokens"
1054     @param _voter Address of user to check against
1055     @param _pollID Integer identifier associated with target poll
1056     @return Number of tokens committed to poll in sorted poll-linked-list
1057     */
1058     function getNumTokens(address _voter, uint _pollID) constant public returns (uint numTokens) {
1059         return store.getAttribute(attrUUID(_voter, _pollID), "numTokens");
1060     }
1061 
1062     /**
1063     @dev Gets top element of sorted poll-linked-list
1064     @param _voter Address of user to check against
1065     @return Integer identifier to poll with maximum number of tokens committed to it
1066     */
1067     function getLastNode(address _voter) constant public returns (uint pollID) {
1068         return dllMap[_voter].getPrev(0);
1069     }
1070 
1071     /**
1072     @dev Gets the numTokens property of getLastNode
1073     @param _voter Address of user to check against
1074     @return Maximum number of tokens committed in poll specified
1075     */
1076     function getLockedTokens(address _voter) constant public returns (uint numTokens) {
1077         return getNumTokens(_voter, getLastNode(_voter));
1078     }
1079 
1080     /*
1081     @dev Takes the last node in the user's DLL and iterates backwards through the list searching
1082     for a node with a value less than or equal to the provided _numTokens value. When such a node
1083     is found, if the provided _pollID matches the found nodeID, this operation is an in-place
1084     update. In that case, return the previous node of the node being updated. Otherwise return the
1085     first node that was found with a value less than or equal to the provided _numTokens.
1086     @param _voter The voter whose DLL will be searched
1087     @param _numTokens The value for the numTokens attribute in the node to be inserted
1088     @return the node which the propoded node should be inserted after
1089     */
1090     function getInsertPointForNumTokens(address _voter, uint _numTokens, uint _pollID)
1091     constant public returns (uint prevNode) {
1092         // Get the last node in the list and the number of tokens in that node
1093         uint nodeID = getLastNode(_voter);
1094         uint tokensInNode = getNumTokens(_voter, nodeID);
1095 
1096         // Iterate backwards through the list until reaching the root node
1097         while(nodeID != 0) {
1098             // Get the number of tokens in the current node
1099             tokensInNode = getNumTokens(_voter, nodeID);
1100             if(tokensInNode <= _numTokens) { // We found the insert point!
1101                 if(nodeID == _pollID) {
1102                     // This is an in-place update. Return the prev node of the node being updated
1103                     nodeID = dllMap[_voter].getPrev(nodeID);
1104                 }
1105                 // Return the insert point
1106                 return nodeID;
1107             }
1108             // We did not find the insert point. Continue iterating backwards through the list
1109             nodeID = dllMap[_voter].getPrev(nodeID);
1110         }
1111 
1112         // The list is empty, or a smaller value than anything else in the list is being inserted
1113         return nodeID;
1114     }
1115 
1116     // ----------------
1117     // GENERAL HELPERS:
1118     // ----------------
1119 
1120     /**
1121     @dev Checks if an expiration date has been reached
1122     @param _terminationDate Integer timestamp of date to compare current timestamp with
1123     @return expired Boolean indication of whether the terminationDate has passed
1124     */
1125     function isExpired(uint _terminationDate) constant public returns (bool expired) {
1126         return (block.timestamp > _terminationDate);
1127     }
1128 
1129     /**
1130     @dev Generates an identifier which associates a user and a poll together
1131     @param _pollID Integer identifier associated with target poll
1132     @return UUID Hash which is deterministic from _user and _pollID
1133     */
1134     function attrUUID(address _user, uint _pollID) public pure returns (bytes32 UUID) {
1135         return keccak256(abi.encodePacked(_user, _pollID));
1136     }
1137 }
1138 
1139 
1140 
1141 contract Parameterizer {
1142 
1143     // ------
1144     // EVENTS
1145     // ------
1146 
1147     event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate, address indexed proposer);
1148     event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate, address indexed challenger);
1149     event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
1150     event _ProposalExpired(bytes32 indexed propID);
1151     event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
1152     event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
1153     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
1154 
1155 
1156     // ------
1157     // DATA STRUCTURES
1158     // ------
1159 
1160     using SafeMath for uint;
1161 
1162     struct ParamProposal {
1163         uint appExpiry;
1164         uint challengeID;
1165         uint deposit;
1166         string name;
1167         address owner;
1168         uint processBy;
1169         uint value;
1170     }
1171 
1172     struct Challenge {
1173         uint rewardPool;        // (remaining) pool of tokens distributed amongst winning voters
1174         address challenger;     // owner of Challenge
1175         bool resolved;          // indication of if challenge is resolved
1176         uint stake;             // number of tokens at risk for either party during challenge
1177         uint winningTokens;     // (remaining) amount of tokens used for voting by the winning side
1178         mapping(address => bool) tokenClaims;
1179     }
1180 
1181     // ------
1182     // STATE
1183     // ------
1184 
1185     mapping(bytes32 => uint) public params;
1186 
1187     // maps challengeIDs to associated challenge data
1188     mapping(uint => Challenge) public challenges;
1189 
1190     // maps pollIDs to intended data change if poll passes
1191     mapping(bytes32 => ParamProposal) public proposals;
1192 
1193     // Global Variables
1194     EIP20Interface public token;
1195     PLCRVoting public voting;
1196     uint public PROCESSBY = 604800; // 7 days
1197 
1198     /**
1199     @dev Initializer        Can only be called once
1200     @param _token           The address where the ERC20 token contract is deployed
1201     @param _plcr            address of a PLCR voting contract for the provided token
1202     @notice _parameters     array of canonical parameters
1203     */
1204     function init(
1205         address _token,
1206         address _plcr,
1207         uint[] _parameters
1208     ) public {
1209         require(_token != 0 && address(token) == 0);
1210         require(_plcr != 0 && address(voting) == 0);
1211 
1212         token = EIP20Interface(_token);
1213         voting = PLCRVoting(_plcr);
1214 
1215         // minimum deposit for listing to be whitelisted
1216         set("minDeposit", _parameters[0]);
1217 
1218         // minimum deposit to propose a reparameterization
1219         set("pMinDeposit", _parameters[1]);
1220 
1221         // period over which applicants wait to be whitelisted
1222         set("applyStageLen", _parameters[2]);
1223 
1224         // period over which reparmeterization proposals wait to be processed
1225         set("pApplyStageLen", _parameters[3]);
1226 
1227         // length of commit period for voting
1228         set("commitStageLen", _parameters[4]);
1229 
1230         // length of commit period for voting in parameterizer
1231         set("pCommitStageLen", _parameters[5]);
1232 
1233         // length of reveal period for voting
1234         set("revealStageLen", _parameters[6]);
1235 
1236         // length of reveal period for voting in parameterizer
1237         set("pRevealStageLen", _parameters[7]);
1238 
1239         // percentage of losing party's deposit distributed to winning party
1240         set("dispensationPct", _parameters[8]);
1241 
1242         // percentage of losing party's deposit distributed to winning party in parameterizer
1243         set("pDispensationPct", _parameters[9]);
1244 
1245         // type of majority out of 100 necessary for candidate success
1246         set("voteQuorum", _parameters[10]);
1247 
1248         // type of majority out of 100 necessary for proposal success in parameterizer
1249         set("pVoteQuorum", _parameters[11]);
1250 
1251         // minimum length of time user has to wait to exit the registry
1252         set("exitTimeDelay", _parameters[12]);
1253 
1254         // maximum length of time user can wait to exit the registry
1255         set("exitPeriodLen", _parameters[13]);
1256     }
1257 
1258     // -----------------------
1259     // TOKEN HOLDER INTERFACE
1260     // -----------------------
1261 
1262     /**
1263     @notice propose a reparamaterization of the key _name's value to _value.
1264     @param _name the name of the proposed param to be set
1265     @param _value the proposed value to set the param to be set
1266     */
1267     function proposeReparameterization(string _name, uint _value) public returns (bytes32) {
1268         uint deposit = get("pMinDeposit");
1269         bytes32 propID = keccak256(abi.encodePacked(_name, _value));
1270 
1271         if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("dispensationPct")) ||
1272             keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("pDispensationPct"))) {
1273             require(_value <= 100);
1274         }
1275 
1276         require(!propExists(propID)); // Forbid duplicate proposals
1277         require(get(_name) != _value); // Forbid NOOP reparameterizations
1278 
1279         // attach name and value to pollID
1280         proposals[propID] = ParamProposal({
1281             appExpiry: now.add(get("pApplyStageLen")),
1282             challengeID: 0,
1283             deposit: deposit,
1284             name: _name,
1285             owner: msg.sender,
1286             processBy: now.add(get("pApplyStageLen"))
1287                 .add(get("pCommitStageLen"))
1288                 .add(get("pRevealStageLen"))
1289                 .add(PROCESSBY),
1290             value: _value
1291         });
1292 
1293         require(token.transferFrom(msg.sender, this, deposit)); // escrow tokens (deposit amt)
1294 
1295         emit _ReparameterizationProposal(_name, _value, propID, deposit, proposals[propID].appExpiry, msg.sender);
1296         return propID;
1297     }
1298 
1299     /**
1300     @notice challenge the provided proposal ID, and put tokens at stake to do so.
1301     @param _propID the proposal ID to challenge
1302     */
1303     function challengeReparameterization(bytes32 _propID) public returns (uint challengeID) {
1304         ParamProposal memory prop = proposals[_propID];
1305         uint deposit = prop.deposit;
1306 
1307         require(propExists(_propID) && prop.challengeID == 0);
1308 
1309         //start poll
1310         uint pollID = voting.startPoll(
1311             get("pVoteQuorum"),
1312             get("pCommitStageLen"),
1313             get("pRevealStageLen")
1314         );
1315 
1316         challenges[pollID] = Challenge({
1317             challenger: msg.sender,
1318             rewardPool: SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100),
1319             stake: deposit,
1320             resolved: false,
1321             winningTokens: 0
1322         });
1323 
1324         proposals[_propID].challengeID = pollID;       // update listing to store most recent challenge
1325 
1326         //take tokens from challenger
1327         require(token.transferFrom(msg.sender, this, deposit));
1328 
1329         (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
1330 
1331         emit _NewChallenge(_propID, pollID, commitEndDate, revealEndDate, msg.sender);
1332         return pollID;
1333     }
1334 
1335     /**
1336     @notice             for the provided proposal ID, set it, resolve its challenge, or delete it depending on whether it can be set, has a challenge which can be resolved, or if its "process by" date has passed
1337     @param _propID      the proposal ID to make a determination and state transition for
1338     */
1339     function processProposal(bytes32 _propID) public {
1340         ParamProposal storage prop = proposals[_propID];
1341         address propOwner = prop.owner;
1342         uint propDeposit = prop.deposit;
1343 
1344 
1345         // Before any token transfers, deleting the proposal will ensure that if reentrancy occurs the
1346         // prop.owner and prop.deposit will be 0, thereby preventing theft
1347         if (canBeSet(_propID)) {
1348             // There is no challenge against the proposal. The processBy date for the proposal has not
1349             // passed, but the proposal's appExpirty date has passed.
1350             set(prop.name, prop.value);
1351             emit _ProposalAccepted(_propID, prop.name, prop.value);
1352             delete proposals[_propID];
1353             require(token.transfer(propOwner, propDeposit));
1354         } else if (challengeCanBeResolved(_propID)) {
1355             // There is a challenge against the proposal.
1356             resolveChallenge(_propID);
1357         } else if (now > prop.processBy) {
1358             // There is no challenge against the proposal, but the processBy date has passed.
1359             emit _ProposalExpired(_propID);
1360             delete proposals[_propID];
1361             require(token.transfer(propOwner, propDeposit));
1362         } else {
1363             // There is no challenge against the proposal, and neither the appExpiry date nor the
1364             // processBy date has passed.
1365             revert();
1366         }
1367 
1368         assert(get("dispensationPct") <= 100);
1369         assert(get("pDispensationPct") <= 100);
1370 
1371         // verify that future proposal appExpiry and processBy times will not overflow
1372         now.add(get("pApplyStageLen"))
1373             .add(get("pCommitStageLen"))
1374             .add(get("pRevealStageLen"))
1375             .add(PROCESSBY);
1376 
1377         delete proposals[_propID];
1378     }
1379 
1380     /**
1381     @notice                 Claim the tokens owed for the msg.sender in the provided challenge
1382     @param _challengeID     the challenge ID to claim tokens for
1383     */
1384     function claimReward(uint _challengeID) public {
1385         Challenge storage challenge = challenges[_challengeID];
1386         // ensure voter has not already claimed tokens and challenge results have been processed
1387         require(challenge.tokenClaims[msg.sender] == false);
1388         require(challenge.resolved == true);
1389 
1390         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID);
1391         uint reward = voterReward(msg.sender, _challengeID);
1392 
1393         // subtract voter's information to preserve the participation ratios of other voters
1394         // compared to the remaining pool of rewards
1395         challenge.winningTokens -= voterTokens;
1396         challenge.rewardPool -= reward;
1397 
1398         // ensures a voter cannot claim tokens again
1399         challenge.tokenClaims[msg.sender] = true;
1400 
1401         emit _RewardClaimed(_challengeID, reward, msg.sender);
1402         require(token.transfer(msg.sender, reward));
1403     }
1404 
1405     /**
1406     @dev                    Called by a voter to claim their rewards for each completed vote.
1407                             Someone must call updateStatus() before this can be called.
1408     @param _challengeIDs    The PLCR pollIDs of the challenges rewards are being claimed for
1409     */
1410     function claimRewards(uint[] _challengeIDs) public {
1411         // loop through arrays, claiming each individual vote reward
1412         for (uint i = 0; i < _challengeIDs.length; i++) {
1413             claimReward(_challengeIDs[i]);
1414         }
1415     }
1416 
1417     // --------
1418     // GETTERS
1419     // --------
1420 
1421     /**
1422     @dev                Calculates the provided voter's token reward for the given poll.
1423     @param _voter       The address of the voter whose reward balance is to be returned
1424     @param _challengeID The ID of the challenge the voter's reward is being calculated for
1425     @return             The uint indicating the voter's reward
1426     */
1427     function voterReward(address _voter, uint _challengeID)
1428     public view returns (uint) {
1429         uint winningTokens = challenges[_challengeID].winningTokens;
1430         uint rewardPool = challenges[_challengeID].rewardPool;
1431         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID);
1432         return (voterTokens * rewardPool) / winningTokens;
1433     }
1434 
1435     /**
1436     @notice Determines whether a proposal passed its application stage without a challenge
1437     @param _propID The proposal ID for which to determine whether its application stage passed without a challenge
1438     */
1439     function canBeSet(bytes32 _propID) view public returns (bool) {
1440         ParamProposal memory prop = proposals[_propID];
1441 
1442         return (now > prop.appExpiry && now < prop.processBy && prop.challengeID == 0);
1443     }
1444 
1445     /**
1446     @notice Determines whether a proposal exists for the provided proposal ID
1447     @param _propID The proposal ID whose existance is to be determined
1448     */
1449     function propExists(bytes32 _propID) view public returns (bool) {
1450         return proposals[_propID].processBy > 0;
1451     }
1452 
1453     /**
1454     @notice Determines whether the provided proposal ID has a challenge which can be resolved
1455     @param _propID The proposal ID whose challenge to inspect
1456     */
1457     function challengeCanBeResolved(bytes32 _propID) view public returns (bool) {
1458         ParamProposal memory prop = proposals[_propID];
1459         Challenge memory challenge = challenges[prop.challengeID];
1460 
1461         return (prop.challengeID > 0 && challenge.resolved == false && voting.pollEnded(prop.challengeID));
1462     }
1463 
1464     /**
1465     @notice Determines the number of tokens to awarded to the winning party in a challenge
1466     @param _challengeID The challengeID to determine a reward for
1467     */
1468     function challengeWinnerReward(uint _challengeID) public view returns (uint) {
1469         if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
1470             // Edge case, nobody voted, give all tokens to the challenger.
1471             return 2 * challenges[_challengeID].stake;
1472         }
1473 
1474         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
1475     }
1476 
1477     /**
1478     @notice gets the parameter keyed by the provided name value from the params mapping
1479     @param _name the key whose value is to be determined
1480     */
1481     function get(string _name) public view returns (uint value) {
1482         return params[keccak256(abi.encodePacked(_name))];
1483     }
1484 
1485     /**
1486     @dev                Getter for Challenge tokenClaims mappings
1487     @param _challengeID The challengeID to query
1488     @param _voter       The voter whose claim status to query for the provided challengeID
1489     */
1490     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
1491         return challenges[_challengeID].tokenClaims[_voter];
1492     }
1493 
1494     // ----------------
1495     // PRIVATE FUNCTIONS
1496     // ----------------
1497 
1498     /**
1499     @dev resolves a challenge for the provided _propID. It must be checked in advance whether the _propID has a challenge on it
1500     @param _propID the proposal ID whose challenge is to be resolved.
1501     */
1502     function resolveChallenge(bytes32 _propID) private {
1503         ParamProposal memory prop = proposals[_propID];
1504         Challenge storage challenge = challenges[prop.challengeID];
1505 
1506         // winner gets back their full staked deposit, and dispensationPct*loser's stake
1507         uint reward = challengeWinnerReward(prop.challengeID);
1508 
1509         challenge.winningTokens = voting.getTotalNumberOfTokensForWinningOption(prop.challengeID);
1510         challenge.resolved = true;
1511 
1512         if (voting.isPassed(prop.challengeID)) { // The challenge failed
1513             if(prop.processBy > now) {
1514                 set(prop.name, prop.value);
1515             }
1516             emit _ChallengeFailed(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1517             require(token.transfer(prop.owner, reward));
1518         }
1519         else { // The challenge succeeded or nobody voted
1520             emit _ChallengeSucceeded(_propID, prop.challengeID, challenge.rewardPool, challenge.winningTokens);
1521             require(token.transfer(challenges[prop.challengeID].challenger, reward));
1522         }
1523     }
1524 
1525     /**
1526     @dev sets the param keted by the provided name to the provided value
1527     @param _name the name of the param to be set
1528     @param _value the value to set the param to be set
1529     */
1530     function set(string _name, uint _value) private {
1531         params[keccak256(abi.encodePacked(_name))] = _value;
1532     }
1533 }
1534  // Imports PLCRVoting and SafeMath
1535 
1536 
1537 
1538 
1539 
1540 
1541 
1542 
1543 
1544 /**
1545  * @title Basic token
1546  * @dev Basic version of StandardToken, with no allowances.
1547  */
1548 contract BasicToken is ERC20Basic {
1549   using SafeMath for uint256;
1550 
1551   mapping(address => uint256) balances;
1552 
1553   uint256 totalSupply_;
1554 
1555   /**
1556   * @dev total number of tokens in existence
1557   */
1558   function totalSupply() public view returns (uint256) {
1559     return totalSupply_;
1560   }
1561 
1562   /**
1563   * @dev transfer token for a specified address
1564   * @param _to The address to transfer to.
1565   * @param _value The amount to be transferred.
1566   */
1567   function transfer(address _to, uint256 _value) public returns (bool) {
1568     require(_to != address(0));
1569     require(_value <= balances[msg.sender]);
1570 
1571     balances[msg.sender] = balances[msg.sender].sub(_value);
1572     balances[_to] = balances[_to].add(_value);
1573     emit Transfer(msg.sender, _to, _value);
1574     return true;
1575   }
1576 
1577   /**
1578   * @dev Gets the balance of the specified address.
1579   * @param _owner The address to query the the balance of.
1580   * @return An uint256 representing the amount owned by the passed address.
1581   */
1582   function balanceOf(address _owner) public view returns (uint256) {
1583     return balances[_owner];
1584   }
1585 
1586 }
1587 
1588 
1589 
1590 
1591 
1592 
1593 /**
1594  * @title ERC20 interface
1595  * @dev see https://github.com/ethereum/EIPs/issues/20
1596  */
1597 contract ERC20 is ERC20Basic {
1598   function allowance(address owner, address spender)
1599     public view returns (uint256);
1600 
1601   function transferFrom(address from, address to, uint256 value)
1602     public returns (bool);
1603 
1604   function approve(address spender, uint256 value) public returns (bool);
1605   event Approval(
1606     address indexed owner,
1607     address indexed spender,
1608     uint256 value
1609   );
1610 }
1611 
1612 
1613 
1614 /**
1615  * @title Standard ERC20 token
1616  *
1617  * @dev Implementation of the basic standard token.
1618  * @dev https://github.com/ethereum/EIPs/issues/20
1619  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1620  */
1621 contract StandardToken is ERC20, BasicToken {
1622 
1623   mapping (address => mapping (address => uint256)) internal allowed;
1624 
1625 
1626   /**
1627    * @dev Transfer tokens from one address to another
1628    * @param _from address The address which you want to send tokens from
1629    * @param _to address The address which you want to transfer to
1630    * @param _value uint256 the amount of tokens to be transferred
1631    */
1632   function transferFrom(
1633     address _from,
1634     address _to,
1635     uint256 _value
1636   )
1637     public
1638     returns (bool)
1639   {
1640     require(_to != address(0));
1641     require(_value <= balances[_from]);
1642     require(_value <= allowed[_from][msg.sender]);
1643 
1644     balances[_from] = balances[_from].sub(_value);
1645     balances[_to] = balances[_to].add(_value);
1646     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1647     emit Transfer(_from, _to, _value);
1648     return true;
1649   }
1650 
1651   /**
1652    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1653    *
1654    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1655    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1656    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1657    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1658    * @param _spender The address which will spend the funds.
1659    * @param _value The amount of tokens to be spent.
1660    */
1661   function approve(address _spender, uint256 _value) public returns (bool) {
1662     allowed[msg.sender][_spender] = _value;
1663     emit Approval(msg.sender, _spender, _value);
1664     return true;
1665   }
1666 
1667   /**
1668    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1669    * @param _owner address The address which owns the funds.
1670    * @param _spender address The address which will spend the funds.
1671    * @return A uint256 specifying the amount of tokens still available for the spender.
1672    */
1673   function allowance(
1674     address _owner,
1675     address _spender
1676    )
1677     public
1678     view
1679     returns (uint256)
1680   {
1681     return allowed[_owner][_spender];
1682   }
1683 
1684   /**
1685    * @dev Increase the amount of tokens that an owner allowed to a spender.
1686    *
1687    * approve should be called when allowed[_spender] == 0. To increment
1688    * allowed value is better to use this function to avoid 2 calls (and wait until
1689    * the first transaction is mined)
1690    * From MonolithDAO Token.sol
1691    * @param _spender The address which will spend the funds.
1692    * @param _addedValue The amount of tokens to increase the allowance by.
1693    */
1694   function increaseApproval(
1695     address _spender,
1696     uint _addedValue
1697   )
1698     public
1699     returns (bool)
1700   {
1701     allowed[msg.sender][_spender] = (
1702       allowed[msg.sender][_spender].add(_addedValue));
1703     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1704     return true;
1705   }
1706 
1707   /**
1708    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1709    *
1710    * approve should be called when allowed[_spender] == 0. To decrement
1711    * allowed value is better to use this function to avoid 2 calls (and wait until
1712    * the first transaction is mined)
1713    * From MonolithDAO Token.sol
1714    * @param _spender The address which will spend the funds.
1715    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1716    */
1717   function decreaseApproval(
1718     address _spender,
1719     uint _subtractedValue
1720   )
1721     public
1722     returns (bool)
1723   {
1724     uint oldValue = allowed[msg.sender][_spender];
1725     if (_subtractedValue > oldValue) {
1726       allowed[msg.sender][_spender] = 0;
1727     } else {
1728       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1729     }
1730     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1731     return true;
1732   }
1733 
1734 }
1735 
1736 
1737 
1738 
1739 
1740 
1741 
1742 
1743 /**
1744  * @title Whitelist
1745  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1746  * @dev This simplifies the implementation of "user permissions".
1747  */
1748 contract Whitelist is Ownable, RBAC {
1749   event WhitelistedAddressAdded(address addr);
1750   event WhitelistedAddressRemoved(address addr);
1751 
1752   string public constant ROLE_WHITELISTED = "whitelist";
1753 
1754   /**
1755    * @dev Throws if called by any account that's not whitelisted.
1756    */
1757   modifier onlyWhitelisted() {
1758     checkRole(msg.sender, ROLE_WHITELISTED);
1759     _;
1760   }
1761 
1762   /**
1763    * @dev add an address to the whitelist
1764    * @param addr address
1765    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1766    */
1767   function addAddressToWhitelist(address addr)
1768     onlyOwner
1769     public
1770   {
1771     addRole(addr, ROLE_WHITELISTED);
1772     emit WhitelistedAddressAdded(addr);
1773   }
1774 
1775   /**
1776    * @dev getter to determine if address is in whitelist
1777    */
1778   function whitelist(address addr)
1779     public
1780     view
1781     returns (bool)
1782   {
1783     return hasRole(addr, ROLE_WHITELISTED);
1784   }
1785 
1786   /**
1787    * @dev add addresses to the whitelist
1788    * @param addrs addresses
1789    * @return true if at least one address was added to the whitelist,
1790    * false if all addresses were already in the whitelist
1791    */
1792   function addAddressesToWhitelist(address[] addrs)
1793     onlyOwner
1794     public
1795   {
1796     for (uint256 i = 0; i < addrs.length; i++) {
1797       addAddressToWhitelist(addrs[i]);
1798     }
1799   }
1800 
1801   /**
1802    * @dev remove an address from the whitelist
1803    * @param addr address
1804    * @return true if the address was removed from the whitelist,
1805    * false if the address wasn't in the whitelist in the first place
1806    */
1807   function removeAddressFromWhitelist(address addr)
1808     onlyOwner
1809     public
1810   {
1811     removeRole(addr, ROLE_WHITELISTED);
1812     emit WhitelistedAddressRemoved(addr);
1813   }
1814 
1815   /**
1816    * @dev remove addresses from the whitelist
1817    * @param addrs addresses
1818    * @return true if at least one address was removed from the whitelist,
1819    * false if all addresses weren't in the whitelist in the first place
1820    */
1821   function removeAddressesFromWhitelist(address[] addrs)
1822     onlyOwner
1823     public
1824   {
1825     for (uint256 i = 0; i < addrs.length; i++) {
1826       removeAddressFromWhitelist(addrs[i]);
1827     }
1828   }
1829 
1830 }
1831 
1832 /***************************************************************************************************
1833 *                                                                                                  *
1834 * (c) 2019 Quantstamp, Inc. This content and its use are governed by the license terms at          *
1835 * <https://github.com/quantstamp/qsp-protocol-node/blob/develop/LICENSE>                           *
1836 *                                                                                                  *
1837 ***************************************************************************************************/
1838 
1839 
1840 
1841 
1842 
1843 
1844 
1845 
1846 
1847 contract Registry {
1848 
1849     // ------
1850     // EVENTS
1851     // ------
1852 
1853     event _Application(bytes32 indexed listingHash, uint deposit, uint appEndDate, string data, address indexed applicant);
1854     event _Challenge(bytes32 indexed listingHash, uint challengeID, string data, uint commitEndDate, uint revealEndDate, address indexed challenger);
1855     event _Deposit(bytes32 indexed listingHash, uint added, uint newTotal, address indexed owner);
1856     event _Withdrawal(bytes32 indexed listingHash, uint withdrew, uint newTotal, address indexed owner);
1857     event _ApplicationWhitelisted(bytes32 indexed listingHash);
1858     event _ApplicationRemoved(bytes32 indexed listingHash);
1859     event _ListingRemoved(bytes32 indexed listingHash);
1860     event _ListingWithdrawn(bytes32 indexed listingHash, address indexed owner);
1861     event _TouchAndRemoved(bytes32 indexed listingHash);
1862     event _ChallengeFailed(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1863     event _ChallengeSucceeded(bytes32 indexed listingHash, uint indexed challengeID, uint rewardPool, uint totalTokens);
1864     event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
1865     event _ExitInitialized(bytes32 indexed listingHash, uint exitTime, uint exitDelayEndDate, address indexed owner);
1866 
1867     using SafeMath for uint;
1868 
1869     struct Listing {
1870         uint applicationExpiry; // Expiration date of apply stage
1871         bool whitelisted;       // Indicates registry status
1872         address owner;          // Owner of Listing
1873         uint unstakedDeposit;   // Number of tokens in the listing not locked in a challenge
1874         uint challengeID;       // Corresponds to a PollID in PLCRVoting
1875 	uint exitTime;		// Time the listing may leave the registry
1876         uint exitTimeExpiry;    // Expiration date of exit period
1877     }
1878 
1879     struct Challenge {
1880         uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
1881         address challenger;     // Owner of Challenge
1882         bool resolved;          // Indication of if challenge is resolved
1883         uint stake;             // Number of tokens at stake for either party during challenge
1884         uint totalTokens;       // (remaining) Number of tokens used in voting by the winning side
1885         mapping(address => bool) tokenClaims; // Indicates whether a voter has claimed a reward yet
1886     }
1887 
1888     // Maps challengeIDs to associated challenge data
1889     mapping(uint => Challenge) public challenges;
1890 
1891     // Maps listingHashes to associated listingHash data
1892     mapping(bytes32 => Listing) public listings;
1893 
1894     // Global Variables
1895     EIP20Interface public token;
1896     PLCRVoting public voting;
1897     Parameterizer public parameterizer;
1898     string public name;
1899 
1900     /**
1901     @dev Initializer. Can only be called once.
1902     @param _token The address where the ERC20 token contract is deployed
1903     */
1904     function init(address _token, address _voting, address _parameterizer, string _name) public {
1905         require(_token != 0 && address(token) == 0);
1906         require(_voting != 0 && address(voting) == 0);
1907         require(_parameterizer != 0 && address(parameterizer) == 0);
1908 
1909         token = EIP20Interface(_token);
1910         voting = PLCRVoting(_voting);
1911         parameterizer = Parameterizer(_parameterizer);
1912         name = _name;
1913     }
1914 
1915     // --------------------
1916     // PUBLISHER INTERFACE:
1917     // --------------------
1918 
1919     /**
1920     @dev                Allows a user to start an application. Takes tokens from user and sets
1921                         apply stage end time.
1922     @param _listingHash The hash of a potential listing a user is applying to add to the registry
1923     @param _amount      The number of ERC20 tokens a user is willing to potentially stake
1924     @param _data        Extra data relevant to the application. Think IPFS hashes.
1925     */
1926     function apply(bytes32 _listingHash, uint _amount, string _data) external {
1927         require(!isWhitelisted(_listingHash));
1928         require(!appWasMade(_listingHash));
1929         require(_amount >= parameterizer.get("minDeposit"));
1930 
1931         // Sets owner
1932         Listing storage listing = listings[_listingHash];
1933         listing.owner = msg.sender;
1934 
1935         // Sets apply stage end time
1936         listing.applicationExpiry = block.timestamp.add(parameterizer.get("applyStageLen"));
1937         listing.unstakedDeposit = _amount;
1938 
1939         // Transfers tokens from user to Registry contract
1940         require(token.transferFrom(listing.owner, this, _amount));
1941 
1942         emit _Application(_listingHash, _amount, listing.applicationExpiry, _data, msg.sender);
1943     }
1944 
1945     /**
1946     @dev                Allows the owner of a listingHash to increase their unstaked deposit.
1947     @param _listingHash A listingHash msg.sender is the owner of
1948     @param _amount      The number of ERC20 tokens to increase a user's unstaked deposit
1949     */
1950     function deposit(bytes32 _listingHash, uint _amount) external {
1951         Listing storage listing = listings[_listingHash];
1952 
1953         require(listing.owner == msg.sender);
1954 
1955         listing.unstakedDeposit += _amount;
1956         require(token.transferFrom(msg.sender, this, _amount));
1957 
1958         emit _Deposit(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1959     }
1960 
1961     /**
1962     @dev                Allows the owner of a listingHash to decrease their unstaked deposit.
1963     @param _listingHash A listingHash msg.sender is the owner of.
1964     @param _amount      The number of ERC20 tokens to withdraw from the unstaked deposit.
1965     */
1966     function withdraw(bytes32 _listingHash, uint _amount) external {
1967         Listing storage listing = listings[_listingHash];
1968 
1969         require(listing.owner == msg.sender);
1970         require(_amount <= listing.unstakedDeposit);
1971         require(listing.unstakedDeposit - _amount >= parameterizer.get("minDeposit"));
1972 
1973         listing.unstakedDeposit -= _amount;
1974         require(token.transfer(msg.sender, _amount));
1975 
1976         emit _Withdrawal(_listingHash, _amount, listing.unstakedDeposit, msg.sender);
1977     }
1978 
1979     /**
1980     @dev		Initialize an exit timer for a listing to leave the whitelist
1981     @param _listingHash	A listing hash msg.sender is the owner of
1982     */
1983     function initExit(bytes32 _listingHash) external {
1984         Listing storage listing = listings[_listingHash];
1985 
1986         require(msg.sender == listing.owner);
1987         require(isWhitelisted(_listingHash));
1988         // Cannot exit during ongoing challenge
1989         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
1990 
1991         // Ensure user never initializedExit or exitPeriodLen passed
1992         require(listing.exitTime == 0 || now > listing.exitTimeExpiry);
1993 
1994         // Set when the listing may be removed from the whitelist
1995         listing.exitTime = now.add(parameterizer.get("exitTimeDelay"));
1996 	// Set exit period end time
1997 	listing.exitTimeExpiry = listing.exitTime.add(parameterizer.get("exitPeriodLen"));
1998         emit _ExitInitialized(_listingHash, listing.exitTime,
1999             listing.exitTimeExpiry, msg.sender);
2000     }
2001 
2002     /**
2003     @dev		Allow a listing to leave the whitelist
2004     @param _listingHash A listing hash msg.sender is the owner of
2005     */
2006     function finalizeExit(bytes32 _listingHash) external {
2007         Listing storage listing = listings[_listingHash];
2008 
2009         require(msg.sender == listing.owner);
2010         require(isWhitelisted(_listingHash));
2011         // Cannot exit during ongoing challenge
2012         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
2013 
2014         // Make sure the exit was initialized
2015         require(listing.exitTime > 0);
2016         // Time to exit has to be after exit delay but before the exitPeriodLen is over
2017 	require(listing.exitTime < now && now < listing.exitTimeExpiry);
2018 
2019         resetListing(_listingHash);
2020         emit _ListingWithdrawn(_listingHash, msg.sender);
2021     }
2022 
2023     // -----------------------
2024     // TOKEN HOLDER INTERFACE:
2025     // -----------------------
2026 
2027     /**
2028     @dev                Starts a poll for a listingHash which is either in the apply stage or
2029                         already in the whitelist. Tokens are taken from the challenger and the
2030                         applicant's deposits are locked.
2031     @param _listingHash The listingHash being challenged, whether listed or in application
2032     @param _data        Extra data relevant to the challenge. Think IPFS hashes.
2033     */
2034     function challenge(bytes32 _listingHash, string _data) external returns (uint challengeID) {
2035         Listing storage listing = listings[_listingHash];
2036         uint minDeposit = parameterizer.get("minDeposit");
2037 
2038         // Listing must be in apply stage or already on the whitelist
2039         require(appWasMade(_listingHash) || listing.whitelisted);
2040         // Prevent multiple challenges
2041         require(listing.challengeID == 0 || challenges[listing.challengeID].resolved);
2042 
2043         if (listing.unstakedDeposit < minDeposit) {
2044             // Not enough tokens, listingHash auto-delisted
2045             resetListing(_listingHash);
2046             emit _TouchAndRemoved(_listingHash);
2047             return 0;
2048         }
2049 
2050         // Starts poll
2051         uint pollID = voting.startPoll(
2052             parameterizer.get("voteQuorum"),
2053             parameterizer.get("commitStageLen"),
2054             parameterizer.get("revealStageLen")
2055         );
2056 
2057         uint oneHundred = 100; // Kludge that we need to use SafeMath
2058         challenges[pollID] = Challenge({
2059             challenger: msg.sender,
2060             rewardPool: ((oneHundred.sub(parameterizer.get("dispensationPct"))).mul(minDeposit)).div(100),
2061             stake: minDeposit,
2062             resolved: false,
2063             totalTokens: 0
2064         });
2065 
2066         // Updates listingHash to store most recent challenge
2067         listing.challengeID = pollID;
2068 
2069         // Locks tokens for listingHash during challenge
2070         listing.unstakedDeposit -= minDeposit;
2071 
2072         // Takes tokens from challenger
2073         require(token.transferFrom(msg.sender, this, minDeposit));
2074 
2075         (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
2076 
2077         emit _Challenge(_listingHash, pollID, _data, commitEndDate, revealEndDate, msg.sender);
2078         return pollID;
2079     }
2080 
2081     /**
2082     @dev                Updates a listingHash's status from 'application' to 'listing' or resolves
2083                         a challenge if one exists.
2084     @param _listingHash The listingHash whose status is being updated
2085     */
2086     function updateStatus(bytes32 _listingHash) public {
2087         if (canBeWhitelisted(_listingHash)) {
2088             whitelistApplication(_listingHash);
2089         } else if (challengeCanBeResolved(_listingHash)) {
2090             resolveChallenge(_listingHash);
2091         } else {
2092             revert();
2093         }
2094     }
2095 
2096     /**
2097     @dev                  Updates an array of listingHashes' status from 'application' to 'listing' or resolves
2098                           a challenge if one exists.
2099     @param _listingHashes The listingHashes whose status are being updated
2100     */
2101     function updateStatuses(bytes32[] _listingHashes) public {
2102         // loop through arrays, revealing each individual vote values
2103         for (uint i = 0; i < _listingHashes.length; i++) {
2104             updateStatus(_listingHashes[i]);
2105         }
2106     }
2107 
2108     // ----------------
2109     // TOKEN FUNCTIONS:
2110     // ----------------
2111 
2112     /**
2113     @dev                Called by a voter to claim their reward for each completed vote. Someone
2114                         must call updateStatus() before this can be called.
2115     @param _challengeID The PLCR pollID of the challenge a reward is being claimed for
2116     */
2117     function claimReward(uint _challengeID) public {
2118         Challenge storage challengeInstance = challenges[_challengeID];
2119         // Ensures the voter has not already claimed tokens and challengeInstance results have
2120         // been processed
2121         require(challengeInstance.tokenClaims[msg.sender] == false);
2122         require(challengeInstance.resolved == true);
2123 
2124         uint voterTokens = voting.getNumPassingTokens(msg.sender, _challengeID);
2125         uint reward = voterTokens.mul(challengeInstance.rewardPool)
2126                       .div(challengeInstance.totalTokens);
2127 
2128         // Subtracts the voter's information to preserve the participation ratios
2129         // of other voters compared to the remaining pool of rewards
2130         challengeInstance.totalTokens -= voterTokens;
2131         challengeInstance.rewardPool -= reward;
2132 
2133         // Ensures a voter cannot claim tokens again
2134         challengeInstance.tokenClaims[msg.sender] = true;
2135 
2136         require(token.transfer(msg.sender, reward));
2137 
2138         emit _RewardClaimed(_challengeID, reward, msg.sender);
2139     }
2140 
2141     /**
2142     @dev                 Called by a voter to claim their rewards for each completed vote. Someone
2143                          must call updateStatus() before this can be called.
2144     @param _challengeIDs The PLCR pollIDs of the challenges rewards are being claimed for
2145     */
2146     function claimRewards(uint[] _challengeIDs) public {
2147         // loop through arrays, claiming each individual vote reward
2148         for (uint i = 0; i < _challengeIDs.length; i++) {
2149             claimReward(_challengeIDs[i]);
2150         }
2151     }
2152 
2153     // --------
2154     // GETTERS:
2155     // --------
2156 
2157     /**
2158     @dev                Calculates the provided voter's token reward for the given poll.
2159     @param _voter       The address of the voter whose reward balance is to be returned
2160     @param _challengeID The pollID of the challenge a reward balance is being queried for
2161     @return             The uint indicating the voter's reward
2162     */
2163     function voterReward(address _voter, uint _challengeID)
2164     public view returns (uint) {
2165         uint totalTokens = challenges[_challengeID].totalTokens;
2166         uint rewardPool = challenges[_challengeID].rewardPool;
2167         uint voterTokens = voting.getNumPassingTokens(_voter, _challengeID);
2168         return voterTokens.mul(rewardPool).div(totalTokens);
2169     }
2170 
2171     /**
2172     @dev                Determines whether the given listingHash be whitelisted.
2173     @param _listingHash The listingHash whose status is to be examined
2174     */
2175     function canBeWhitelisted(bytes32 _listingHash) view public returns (bool) {
2176         uint challengeID = listings[_listingHash].challengeID;
2177 
2178         // Ensures that the application was made,
2179         // the application period has ended,
2180         // the listingHash can be whitelisted,
2181         // and either: the challengeID == 0, or the challenge has been resolved.
2182         if (
2183             appWasMade(_listingHash) &&
2184             listings[_listingHash].applicationExpiry < now &&
2185             !isWhitelisted(_listingHash) &&
2186             (challengeID == 0 || challenges[challengeID].resolved == true)
2187         ) { return true; }
2188 
2189         return false;
2190     }
2191 
2192     /**
2193     @dev                Returns true if the provided listingHash is whitelisted
2194     @param _listingHash The listingHash whose status is to be examined
2195     */
2196     function isWhitelisted(bytes32 _listingHash) view public returns (bool whitelisted) {
2197         return listings[_listingHash].whitelisted;
2198     }
2199 
2200     /**
2201     @dev                Returns true if apply was called for this listingHash
2202     @param _listingHash The listingHash whose status is to be examined
2203     */
2204     function appWasMade(bytes32 _listingHash) view public returns (bool exists) {
2205         return listings[_listingHash].applicationExpiry > 0;
2206     }
2207 
2208     /**
2209     @dev                Returns true if the application/listingHash has an unresolved challenge
2210     @param _listingHash The listingHash whose status is to be examined
2211     */
2212     function challengeExists(bytes32 _listingHash) view public returns (bool) {
2213         uint challengeID = listings[_listingHash].challengeID;
2214 
2215         return (listings[_listingHash].challengeID > 0 && !challenges[challengeID].resolved);
2216     }
2217 
2218     /**
2219     @dev                Determines whether voting has concluded in a challenge for a given
2220                         listingHash. Throws if no challenge exists.
2221     @param _listingHash A listingHash with an unresolved challenge
2222     */
2223     function challengeCanBeResolved(bytes32 _listingHash) view public returns (bool) {
2224         uint challengeID = listings[_listingHash].challengeID;
2225 
2226         require(challengeExists(_listingHash));
2227 
2228         return voting.pollEnded(challengeID);
2229     }
2230 
2231     /**
2232     @dev                Determines the number of tokens awarded to the winning party in a challenge.
2233     @param _challengeID The challengeID to determine a reward for
2234     */
2235     function determineReward(uint _challengeID) public view returns (uint) {
2236         require(!challenges[_challengeID].resolved && voting.pollEnded(_challengeID));
2237 
2238         // Edge case, nobody voted, give all tokens to the challenger.
2239         if (voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
2240             return 2 * challenges[_challengeID].stake;
2241         }
2242 
2243         return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
2244     }
2245 
2246     /**
2247     @dev                Getter for Challenge tokenClaims mappings
2248     @param _challengeID The challengeID to query
2249     @param _voter       The voter whose claim status to query for the provided challengeID
2250     */
2251     function tokenClaims(uint _challengeID, address _voter) public view returns (bool) {
2252         return challenges[_challengeID].tokenClaims[_voter];
2253     }
2254 
2255     // ----------------
2256     // PRIVATE FUNCTIONS:
2257     // ----------------
2258 
2259     /**
2260     @dev                Determines the winner in a challenge. Rewards the winner tokens and
2261                         either whitelists or de-whitelists the listingHash.
2262     @param _listingHash A listingHash with a challenge that is to be resolved
2263     */
2264     function resolveChallenge(bytes32 _listingHash) private {
2265         uint challengeID = listings[_listingHash].challengeID;
2266 
2267         // Calculates the winner's reward,
2268         // which is: (winner's full stake) + (dispensationPct * loser's stake)
2269         uint reward = determineReward(challengeID);
2270 
2271         // Sets flag on challenge being processed
2272         challenges[challengeID].resolved = true;
2273 
2274         // Stores the total tokens used for voting by the winning side for reward purposes
2275         challenges[challengeID].totalTokens =
2276             voting.getTotalNumberOfTokensForWinningOption(challengeID);
2277 
2278         // Case: challenge failed
2279         if (voting.isPassed(challengeID)) {
2280             whitelistApplication(_listingHash);
2281             // Unlock stake so that it can be retrieved by the applicant
2282             listings[_listingHash].unstakedDeposit += reward;
2283 
2284             emit _ChallengeFailed(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
2285         }
2286         // Case: challenge succeeded or nobody voted
2287         else {
2288             resetListing(_listingHash);
2289             // Transfer the reward to the challenger
2290             require(token.transfer(challenges[challengeID].challenger, reward));
2291 
2292             emit _ChallengeSucceeded(_listingHash, challengeID, challenges[challengeID].rewardPool, challenges[challengeID].totalTokens);
2293         }
2294     }
2295 
2296     /**
2297     @dev                Called by updateStatus() if the applicationExpiry date passed without a
2298                         challenge being made. Called by resolveChallenge() if an
2299                         application/listing beat a challenge.
2300     @param _listingHash The listingHash of an application/listingHash to be whitelisted
2301     */
2302     function whitelistApplication(bytes32 _listingHash) private {
2303         if (!listings[_listingHash].whitelisted) { emit _ApplicationWhitelisted(_listingHash); }
2304         listings[_listingHash].whitelisted = true;
2305     }
2306 
2307     /**
2308     @dev                Deletes a listingHash from the whitelist and transfers tokens back to owner
2309     @param _listingHash The listing hash to delete
2310     */
2311     function resetListing(bytes32 _listingHash) private {
2312         Listing storage listing = listings[_listingHash];
2313 
2314         // Emit events before deleting listing to check whether is whitelisted
2315         if (listing.whitelisted) {
2316             emit _ListingRemoved(_listingHash);
2317         } else {
2318             emit _ApplicationRemoved(_listingHash);
2319         }
2320 
2321         // Deleting listing to prevent reentry
2322         address owner = listing.owner;
2323         uint unstakedDeposit = listing.unstakedDeposit;
2324         delete listings[_listingHash];
2325 
2326         // Transfers any remaining balance back to the owner
2327         if (unstakedDeposit > 0){
2328             require(token.transfer(owner, unstakedDeposit));
2329         }
2330     }
2331 }
2332 
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
2343  // Imports PLCRVoting and SafeMath
2344 
2345 
2346  //Imports SafeMath
2347 
2348 
2349 
2350 contract QuantstampBountyData is Whitelist {
2351 
2352   using SafeMath for uint256;
2353   using LinkedListLib for LinkedListLib.LinkedList;
2354 
2355   // constants used by LinkedListLib
2356   uint256 constant internal NULL = 0;
2357   uint256 constant internal HEAD = 0;
2358   bool constant internal PREV = false;
2359   bool constant internal NEXT = true;
2360 
2361 
2362   uint256 constant internal NUMBER_OF_PHASES = 3;
2363 
2364   struct Bounty {
2365     address submitter;
2366     string contractAddress;
2367     uint256 size; // R1
2368     uint256 minVotes; // R3
2369     uint256 duration; // R2. Number of seconds
2370     uint256 judgeDeposit; // R5
2371     uint256 hunterDeposit; // R6
2372     uint256 initiationTimestamp; // Time in seconds that the bounty is created
2373     bool remainingFeesWithdrawn; // true if the remaining fees have been withdrawn by the submitter
2374     uint256 numApprovedBugs;
2375   }
2376 
2377   // holds information about a revealed bug
2378   struct Bug {
2379     address hunter; // address that submitted the hash
2380     uint256 bountyId; // the ID of the associated bounty
2381     string bugDescription; // the description of the bug
2382     uint256 numTokens; // the number of tokens staked on the commit
2383     uint256 pollId; // the poll that decided on the validity of the bug
2384   }
2385 
2386   // holds information relevant to a bug commit
2387   struct BugCommit {
2388     address hunter;  // address that submitted the hash
2389     uint256 bountyId;  // the ID of the associated bounty
2390     bytes32 bugDescriptionHash;  // keccak256 hash of the bug
2391     uint256 commitTimestamp;  // Time in seconds that the bug commit occurred
2392     uint256 revealStartTimestamp;  // Time in seconds when the the reveal phase starts
2393     uint256 revealEndTimestamp;  // Time in seconds when the the reveal phase ends
2394     uint256 numTokens;  // the number of tokens staked on the commit
2395   }
2396 
2397   mapping (uint256 => Bounty) public bounties;
2398 
2399   // maps pollIds back to bugIds
2400   mapping (uint256 => uint256) public pollIdToBugId;
2401 
2402   // For generating bountyIDs starting from 1
2403   uint256 private bountyCounter;
2404 
2405   // For generating bugIDs starting from 1
2406   uint256 private bugCounter;
2407 
2408   // token used to pay for participants in a bounty. This contract assumes that the owner of the contract
2409   // trusts token's code and that transfer function (such as transferFrom, transfer) do the right thing
2410   StandardToken public token;
2411 
2412   // The partial-locking commit-reveal voting interface used by the TCR to determine the validity of bugs
2413   RestrictedPLCRVoting public voting;
2414 
2415   // The underlying contract to hold PLCR voting parameters
2416   Parameterizer public parameterizer;
2417 
2418   // Recording reported bugs not yet awarded for each hunter
2419   mapping (address => LinkedListLib.LinkedList) private hunterReportedBugs;
2420   mapping (address => uint256) public hunterReportedBugsCount;
2421 
2422   /**
2423    * @dev The constructor creates a QuantstampBountyData contract.
2424    * @param tokenAddress The address of a StandardToken that will be used to pay auditor nodes.
2425    */
2426   constructor (address tokenAddress, address votingAddress, address parameterizerAddress) public {
2427     require(tokenAddress != address(0));
2428     require(votingAddress != address(0));
2429     require(parameterizerAddress != address(0));
2430     token = StandardToken(tokenAddress);
2431     voting = RestrictedPLCRVoting(votingAddress);
2432     parameterizer = Parameterizer(parameterizerAddress);
2433   }
2434 
2435   // maps bountyIDs to list of corresponding bugIDs
2436   // each list contains all revealed bugs for a given bounty, ordered by time
2437   // NOTE: this cannot be part of the Bounty struct due to solidity limitations
2438   mapping(uint256 => LinkedListLib.LinkedList) private bugLists;
2439 
2440   // maps bugIDs to BugCommits
2441   mapping(uint256 => BugCommit) public bugCommitMap;
2442 
2443   // maps bugIDs to revealed bugs; uses the same ID as the bug commit
2444   mapping(uint256 => Bug) public bugs;
2445 
2446   function addBugCommitment(address hunter,
2447                             uint256 bountyId,
2448                             bytes32 bugDescriptionHash,
2449                             uint256 hunterDeposit) public onlyWhitelisted returns (uint256) {
2450     bugCounter = bugCounter.add(1);
2451     bugCommitMap[bugCounter] = BugCommit({
2452       hunter: hunter,
2453       bountyId: bountyId,
2454       bugDescriptionHash: bugDescriptionHash,
2455       commitTimestamp: block.timestamp,
2456       revealStartTimestamp: getBountyRevealPhaseStartTimestamp(bountyId),
2457       revealEndTimestamp: getBountyRevealPhaseEndTimestamp(bountyId),
2458       numTokens: hunterDeposit
2459     });
2460     return bugCounter;
2461   }
2462 
2463   function addBug(uint256 bugId, string bugDescription, uint256 pollId) public onlyWhitelisted returns (bool) {
2464     // create a Bug
2465     bugs[bugId] = Bug({
2466       hunter: bugCommitMap[bugId].hunter,
2467       bountyId: bugCommitMap[bugId].bountyId,
2468       bugDescription: bugDescription,
2469       numTokens: bugCommitMap[bugId].numTokens,
2470       pollId: pollId
2471     });
2472     // add pointer to it in the corresponding bounty
2473     bugLists[bugCommitMap[bugId].bountyId].push(bugId, PREV);
2474     pollIdToBugId[pollId] = bugId;
2475     return true;
2476   }
2477 
2478   function addBounty (address submitter,
2479                       string contractAddress,
2480                       uint256 size,
2481                       uint256 minVotes,
2482                       uint256 duration,
2483                       uint256 judgeDeposit,
2484                       uint256 hunterDeposit) public onlyWhitelisted returns(uint256) {
2485     bounties[++bountyCounter] = Bounty(submitter,
2486                                         contractAddress,
2487                                         size,
2488                                         minVotes,
2489                                         duration,
2490                                         judgeDeposit,
2491                                         hunterDeposit,
2492                                         block.timestamp,
2493                                         false,
2494                                         0);
2495     return bountyCounter;
2496   }
2497 
2498   function removeBugCommitment(uint256 bugId) public onlyWhitelisted returns (bool) {
2499     delete bugCommitMap[bugId];
2500     return true;
2501   }
2502 
2503   /**
2504    * @dev Sets a new value for the number of approved bugs, if appropriate
2505    * @param pollId The ID of the poll being that a vote was received for
2506    * @param wasPassing true if and only if more affirmative votes prior to this vote
2507    * @param isPassing true if and only if more affirmative votes after this vote
2508    * @param wasEnoughVotes true if and only if quorum was reached prior to this vote
2509    */
2510   function updateNumApprovedBugs(uint256 pollId, bool wasPassing, bool isPassing, bool wasEnoughVotes) public {
2511     require(msg.sender == address(voting));
2512     uint256 bountyId = getBugBountyId(getBugIdFromPollId(pollId));
2513 
2514     if (wasEnoughVotes) {
2515       if (!wasPassing && isPassing) {
2516         bounties[bountyId].numApprovedBugs = bounties[bountyId].numApprovedBugs.add(1);
2517       } else if (wasPassing && !isPassing) {
2518         bounties[bountyId].numApprovedBugs = bounties[bountyId].numApprovedBugs.sub(1);
2519       }
2520     } else if (voting.isEnoughVotes(pollId) && isPassing) {
2521       bounties[bountyId].numApprovedBugs = bounties[bountyId].numApprovedBugs.add(1);
2522     }
2523   }
2524 
2525   /**
2526    * @dev Reports the number of approved bugs of a bounty
2527    * @param bountyId The ID of the bounty.
2528    */
2529   function getNumApprovedBugs(uint256 bountyId) public view returns (uint256) {
2530     return bounties[bountyId].numApprovedBugs;
2531   }
2532 
2533   /**
2534    * @dev Sets remainingFeesWithdrawn to true after the submitter withdraws.
2535    * @param bountyId The ID of the bounty.
2536    */
2537   function setBountyRemainingFeesWithdrawn (uint256 bountyId) public onlyWhitelisted {
2538     bounties[bountyId].remainingFeesWithdrawn = true;
2539   }
2540 
2541   function addBugToHunter (address hunter, uint256 bugId) public onlyWhitelisted {
2542     hunterReportedBugs[hunter].push(bugId, PREV);
2543     hunterReportedBugsCount[hunter] = hunterReportedBugsCount[hunter].add(1);
2544   }
2545 
2546   function removeBugFromHunter (address hunter, uint256 bugId) public onlyWhitelisted returns (bool) {
2547     if (hunterReportedBugs[hunter].remove(bugId) != 0) {
2548       hunterReportedBugsCount[hunter] = hunterReportedBugsCount[hunter].sub(1);
2549       bugs[bugId].hunter = 0x0;
2550       return true;
2551     }
2552     return false;
2553   }
2554 
2555   function getListHeadConstant () public pure returns(uint256 head) {
2556     return HEAD;
2557   }
2558 
2559   function getBountySubmitter (uint256 bountyId) public view returns(address) {
2560     return bounties[bountyId].submitter;
2561   }
2562 
2563   function getBountyContractAddress (uint256 bountyId) public view returns(string) {
2564     return bounties[bountyId].contractAddress;
2565   }
2566 
2567   function getBountySize (uint256 bountyId) public view returns(uint256) {
2568     return bounties[bountyId].size;
2569   }
2570 
2571   function getBountyMinVotes (uint256 bountyId) public view returns(uint256) {
2572     return bounties[bountyId].minVotes;
2573   }
2574 
2575   function getBountyDuration (uint256 bountyId) public view returns(uint256) {
2576     return bounties[bountyId].duration;
2577   }
2578 
2579   function getBountyJudgeDeposit (uint256 bountyId) public view returns(uint256) {
2580     return bounties[bountyId].judgeDeposit;
2581   }
2582 
2583   function getBountyHunterDeposit (uint256 bountyId) public view returns(uint256) {
2584     return bounties[bountyId].hunterDeposit;
2585   }
2586 
2587   function getBountyInitiationTimestamp (uint256 bountyId) public view returns(uint256) {
2588     return bounties[bountyId].initiationTimestamp;
2589   }
2590 
2591   function getBountyCommitPhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2592     return bounties[bountyId].initiationTimestamp.add(getBountyDuration(bountyId).div(NUMBER_OF_PHASES));
2593   }
2594 
2595   function getBountyRevealPhaseStartTimestamp (uint256 bountyId) public view returns(uint256) {
2596     return getBountyCommitPhaseEndTimestamp(bountyId).add(1);
2597   }
2598 
2599   function getBountyRevealPhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2600     return getBountyCommitPhaseEndTimestamp(bountyId).add(getBountyDuration(bountyId).div(NUMBER_OF_PHASES));
2601   }
2602 
2603   function getBountyJudgePhaseStartTimestamp (uint256 bountyId) public view returns(uint256) {
2604     return getBountyRevealPhaseEndTimestamp(bountyId).add(1);
2605   }
2606 
2607   function getBountyJudgePhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2608     return bounties[bountyId].initiationTimestamp.add(getBountyDuration(bountyId));
2609   }
2610 
2611   function getBountyJudgeCommitPhaseEndTimestamp (uint256 bountyId) public view returns(uint256) {
2612     uint256 judgePhaseDuration = getBountyDuration(bountyId).div(NUMBER_OF_PHASES);
2613     return getBountyJudgePhaseStartTimestamp(bountyId).add(judgePhaseDuration.div(2));
2614   }
2615 
2616   function getBountyJudgeRevealDuration (uint256 bountyId) public view returns(uint256) {
2617     return getBountyJudgePhaseEndTimestamp(bountyId).sub(getBountyJudgeCommitPhaseEndTimestamp(bountyId));
2618   }
2619 
2620   function isCommitPeriod (uint256 bountyId) public view returns(bool) {
2621     return block.timestamp >= bounties[bountyId].initiationTimestamp && block.timestamp <= getBountyCommitPhaseEndTimestamp(bountyId);
2622   }
2623 
2624   function isRevealPeriod (uint256 bountyId) public view returns(bool) {
2625     return block.timestamp >= getBountyRevealPhaseStartTimestamp(bountyId) && block.timestamp <= getBountyRevealPhaseEndTimestamp(bountyId);
2626   }
2627 
2628   function isJudgingPeriod (uint256 bountyId) public view returns(bool) {
2629     return block.timestamp >= getBountyJudgePhaseStartTimestamp(bountyId) && block.timestamp <= getBountyJudgePhaseEndTimestamp(bountyId);
2630   }
2631 
2632   function getBountyRemainingFeesWithdrawn (uint256 bountyId) public view returns(bool) {
2633     return bounties[bountyId].remainingFeesWithdrawn;
2634   }
2635 
2636   function getBugCommitCommitter(uint256 bugCommitId) public view returns (address) {
2637     return bugCommitMap[bugCommitId].hunter;
2638   }
2639 
2640   function getBugCommitBountyId(uint256 bugCommitId) public view returns (uint256) {
2641     return bugCommitMap[bugCommitId].bountyId;
2642   }
2643 
2644   function getBugCommitBugDescriptionHash(uint256 bugCommitId) public view returns (bytes32) {
2645     return bugCommitMap[bugCommitId].bugDescriptionHash;
2646   }
2647 
2648   function getBugCommitCommitTimestamp(uint256 bugCommitId) public view returns (uint256) {
2649     return bugCommitMap[bugCommitId].commitTimestamp;
2650   }
2651 
2652   function getBugCommitRevealStartTimestamp(uint256 bugCommitId) public view returns (uint256) {
2653     return bugCommitMap[bugCommitId].revealStartTimestamp;
2654   }
2655 
2656   function getBugCommitRevealEndTimestamp(uint256 bugCommitId) public view returns (uint256) {
2657     return bugCommitMap[bugCommitId].revealEndTimestamp;
2658   }
2659 
2660   function getBugCommitNumTokens(uint256 bugCommitId) public view returns (uint256) {
2661     return bugCommitMap[bugCommitId].numTokens;
2662   }
2663 
2664   function bugRevealPeriodActive(uint256 bugCommitId) public view returns (bool) {
2665     return bugCommitMap[bugCommitId].revealStartTimestamp <= block.timestamp && block.timestamp <= bugCommitMap[bugCommitId].revealEndTimestamp;
2666   }
2667 
2668   function bugRevealPeriodExpired(uint256 bugCommitId) public view returns (bool) {
2669     return block.timestamp > bugCommitMap[bugCommitId].revealEndTimestamp;
2670   }
2671 
2672   function bugRevealDelayPeriodActive(uint256 bugCommitId) public view returns (bool) {
2673     return block.timestamp < bugCommitMap[bugCommitId].revealStartTimestamp;
2674   }
2675 
2676   function bountyActive(uint256 bountyId) public view returns (bool) {
2677     return block.timestamp <= getBountyInitiationTimestamp(bountyId).add(getBountyDuration(bountyId));
2678   }
2679 
2680   function getHunterReportedBugsCount (address hunter) public view returns (uint256) {
2681     return hunterReportedBugsCount[hunter];
2682   }
2683 
2684   // Bug Functions
2685   function getBugBountyId(uint256 bugId) public view returns (uint256) {
2686     return bugs[bugId].bountyId;
2687   }
2688 
2689   function getBugHunter(uint256 bugId) public view returns (address) {
2690     return bugs[bugId].hunter;
2691   }
2692 
2693   function getBugDescription(uint256 bugId) public view returns (string) {
2694     return bugs[bugId].bugDescription;
2695   }
2696 
2697   function getBugNumTokens(uint256 bugId) public view returns (uint256) {
2698     return bugs[bugId].numTokens;
2699   }
2700 
2701   function getBugPollId(uint256 bugId) public view returns (uint256) {
2702     return bugs[bugId].pollId;
2703   }
2704 
2705   function getFirstRevealedBug(uint256 bountyId) public view returns (bool, uint256, string) {
2706     return getNextRevealedBug(bountyId, HEAD);
2707   }
2708 
2709   function getBugIdFromPollId(uint256 pollId) public view returns (uint256) {
2710     return pollIdToBugId[pollId];
2711   }
2712 
2713   /*
2714    * @dev Gets the bug description of a revealed bug associated with a bounty
2715    * @param bountyId The ID of the bounty
2716    * @param previousBugId The ID of the previous bug in the linked list (HEAD for the first bug)
2717    * @return a triple containing 1) whether the bug exists; 2) its bugId (0 if non-existent); 3) the description
2718    */
2719   function getNextRevealedBug(uint256 bountyId, uint256 previousBugId) public view returns (bool, uint256, string) {
2720     if (!bugLists[bountyId].listExists()) {
2721       return (false, 0, "");
2722     }
2723     uint256 bugId;
2724     bool exists;
2725     (exists, bugId) = bugLists[bountyId].getAdjacent(previousBugId, NEXT);
2726     if (!exists || bugId == 0) {
2727       return (false, 0, "");
2728     }
2729     string memory bugDescription = bugs[bugId].bugDescription;
2730     return (true, bugId, bugDescription);
2731   }
2732 
2733   /**
2734    * @dev Given a bugId, it retrieves the next bugId reported by a hunter. Such bugs have not been cashed yet.
2735    * @param hunter The address of a hunter
2736    * @param previousBugId The id of the previous reported bug. Passing 0, it returns the first reported bug.
2737    */
2738   function getNextBugFromHunter(address hunter, uint256 previousBugId) public view returns (bool, uint256) {
2739     if (!hunterReportedBugs[hunter].listExists()) {
2740       return (false, 0);
2741     }
2742     uint256 bugId;
2743     bool exists;
2744     (exists, bugId) = hunterReportedBugs[hunter].getAdjacent(previousBugId, NEXT);
2745     if (!exists || bugId == 0) {
2746       return (false, 0);
2747     }
2748     return (true, bugId);
2749   }
2750 
2751   /**
2752    * @dev Determines if the judge meets the requirements to claim an award for voting in a poll
2753    * @param bugId Id of a bug
2754    * Note: moved to this contract as the Bounty contract was getting too large to deploy
2755    */
2756   function canClaimJudgeAward(address judge, uint256 bugId) public view returns (bool) {
2757     // NOTE: these cannot be a require statement as this check occurs in a loop that should not fail
2758     // the poll has concluded
2759     uint256 pollId = getBugPollId(bugId);
2760     bool pollHasConcluded = voting.pollExists(pollId) && voting.pollEnded(pollId);
2761     // the judge voted in the majority
2762     // this is needed to avoid hitting a require statement when in the minority in PLCRVoting
2763     bool votedWithMajority = pollHasConcluded && voting.isEnoughVotes(pollId) &&
2764       (voting.isPassed(pollId) && voting.hasVotedAffirmatively(judge, pollId) ||
2765       !voting.isPassed(pollId) && !voting.hasVotedAffirmatively(judge, pollId));
2766     // the judge should not have already claimed an award for this poll
2767     bool alreadyClaimed = voting.hasVoterClaimedReward(judge, pollId);
2768     // the bounty should be over
2769     bool bountyStillActive = bountyActive(getBugBountyId(bugId));
2770     return votedWithMajority && !alreadyClaimed && !bountyStillActive;
2771   }
2772 }
2773 
2774 
2775 
2776 
2777 /**
2778 Extends PLCR Voting to have restricted polls that can only be voted on by the TCR.
2779 */
2780 contract RestrictedPLCRVoting is PLCRVoting, Whitelist {
2781 
2782   using SafeMath for uint256;
2783   using LinkedListLib for LinkedListLib.LinkedList;
2784 
2785   // constants used by LinkedListLib
2786   uint256 constant internal NULL = 0;
2787   uint256 constant internal HEAD = 0;
2788   bool constant internal PREV = false;
2789   bool constant internal NEXT = true;
2790 
2791   // TCR used to list judge stakers.
2792   Registry public judgeRegistry;
2793 
2794   QuantstampBountyData public bountyData;
2795 
2796   // Map that contains IDs of restricted polls that can only be voted on by the TCR
2797   mapping(uint256 => bool) isRestrictedPoll;
2798 
2799   // Map from IDs of restricted polls to the minimum number of votes needed for a bug to pass
2800   mapping(uint256 => uint256) minimumVotes;
2801 
2802   // Map from IDs of restricted polls to the amount a judge must deposit to vote
2803   mapping(uint256 => uint256) judgeDeposit;
2804 
2805   // Map from (voter x pollId) -> bool to determine whether a voter has already claimed a reward of a given poll
2806   mapping(address => mapping(uint256 => bool)) private voterHasClaimedReward;
2807 
2808   // Map from (voter x pollId) -> bool indicating whether a voter voted yes (true) or no (false) for a poll.
2809   // Needed due to visibility issues with Poll structs in PLCRVoting
2810   mapping(address => mapping(uint256 => bool)) private votedAffirmatively;
2811 
2812   // Recording polls voted on but not yet awarded for each voter
2813   mapping (address => LinkedListLib.LinkedList) private voterPolls;
2814   mapping (address => uint256) public voterPollsCount;
2815 
2816   event LogPollRestricted(uint256 pollId);
2817 
2818   /**
2819    * @dev Initializer. Can only be called once.
2820    * @param _registry The address of the TCR registry
2821    * @param _token The address of the token
2822    */
2823   function initialize(address _token, address _registry, address _bountyData) public {
2824     require(_token != 0 && address(token) == 0);
2825     require(_registry != 0 && address(judgeRegistry) == 0);
2826     require(_bountyData != 0 && address(bountyData) == 0);
2827     bountyData = QuantstampBountyData(_bountyData);
2828     token = EIP20Interface(_token);
2829     judgeRegistry = Registry(_registry);
2830     pollNonce = INITIAL_POLL_NONCE;
2831   }
2832 
2833   /*
2834    * @dev addr is of type Address which is 20 Bytes, but the TCR expects all
2835    * entries to be of type Bytes32. addr is first cast to Uint256 so that it
2836    * becomes 32 bytes long, addr is then shifted 12 bytes (96 bits) to the
2837    * left so the 20 important bytes are in the correct spot.
2838    * @param addr The address of the person who may be an judge.
2839    * @return true If addr is on the TCR (is an judge)
2840    */
2841   function isJudge(address addr) public view returns(bool) {
2842     return judgeRegistry.isWhitelisted(bytes32(uint256(addr) << 96));
2843   }
2844 
2845   /**
2846    * @dev Set a poll to be restricted to TCR voting
2847    * @param _pollId The ID of the poll
2848    * @param _minimumVotes The minimum number of votes needed for the vote to go through. Each voter counts as 1 vote (not weighted).
2849    * @param _judgeDepositAmount The deposit of a judge to vote
2850    */
2851   function restrictPoll(uint256 _pollId, uint256 _minimumVotes, uint256 _judgeDepositAmount) public onlyWhitelisted {
2852     isRestrictedPoll[_pollId] = true;
2853     minimumVotes[_pollId] = _minimumVotes;
2854     judgeDeposit[_pollId] = _judgeDepositAmount;
2855     emit LogPollRestricted(_pollId);
2856   }
2857 
2858   /**
2859    * @dev Set that a voter has claimed a reward for voting with the majority
2860    * @param _voter The address of the voter
2861    * @param _pollID Integer identifier associated with target poll
2862    */
2863   function setVoterClaimedReward(address _voter, uint256 _pollID) public onlyWhitelisted {
2864     voterHasClaimedReward[_voter][_pollID] = true;
2865   }
2866 
2867   /**
2868    * @dev Determines whether a restricted poll has met the minimum vote requirements
2869    * @param _pollId The ID of the poll
2870    */
2871   function isEnoughVotes(uint256 _pollId) public view returns (bool) {
2872     return pollMap[_pollId].votesFor.add(pollMap[_pollId].votesAgainst) >= minimumVotes[_pollId].mul(judgeDeposit[_pollId]);
2873   }
2874 
2875   // Overridden methods from PLCRVoting. Needed for special requirements of the bounty protocol
2876 
2877   /**
2878   * @dev Overridden Initializer from PLCR Voting. Always reverts to ensure the registry is initialized in the above initialize function.
2879   * @param _token The address of the token
2880   */
2881   function init(address _token) public {
2882     require(false);
2883   }
2884 
2885   /**
2886    * @dev Overrides PLCRVoting to only allow TCR members to vote on restricted votes.
2887    *      Commits vote using hash of choice and secret salt to conceal vote until reveal.
2888    * @param _pollID Integer identifier associated with target poll
2889    * @param _secretHash Commit keccak256 hash of voter's choice and salt (tightly packed in this order)
2890    * @param _numTokens The number of tokens to be committed towards the target poll
2891    * @param _prevPollID The ID of the poll that the user has voted the maximum number of tokens in which is still less than or equal to numTokens
2892    */
2893   function commitVote(uint256 _pollID, bytes32 _secretHash, uint256 _numTokens, uint256 _prevPollID) public {
2894     if (isRestrictedPoll[_pollID]) {
2895       require(isJudge(msg.sender));
2896       // Note: The PLCR weights votes by numTokens, so here we use strict equality rather than '>='
2897       // This must be accounted for when tallying votes.
2898       require(_numTokens == judgeDeposit[_pollID]);
2899       require(bountyData.isJudgingPeriod(bountyData.getBugBountyId(bountyData.getBugIdFromPollId(_pollID))));
2900     }
2901     super.commitVote(_pollID, _secretHash, _numTokens, _prevPollID);
2902   }
2903 
2904   /**
2905    * @dev Overrides PLCRVoting to track which polls are associated with a voter.
2906    * @notice Reveals vote with choice and secret salt used in generating commitHash to attribute committed tokens
2907    * @param _pollID Integer identifier associated with target poll
2908    * @param _voteOption Vote choice used to generate commitHash for associated poll
2909    * @param _salt Secret number used to generate commitHash for associated poll
2910    */
2911   function revealVote(uint256 _pollID, uint256 _voteOption, uint256 _salt) public {
2912     address voter = msg.sender;
2913     // record the vote
2914     if (_voteOption == 1) {
2915       votedAffirmatively[voter][_pollID] = true;
2916     }
2917     // do not allow multiple votes for the same poll
2918     require(!voterPolls[voter].nodeExists(_pollID));
2919     bool wasPassing = isPassing(_pollID);
2920     bool wasEnoughVotes = isEnoughVotes(_pollID);
2921     voterPolls[voter].push(_pollID, PREV);
2922     voterPollsCount[voter] = voterPollsCount[voter].add(1);
2923     super.revealVote(_pollID, _voteOption, _salt);
2924     bool voteIsPassing = isPassing(_pollID);
2925     bountyData.updateNumApprovedBugs(_pollID, wasPassing, voteIsPassing, wasEnoughVotes);
2926   }
2927 
2928   function removePollFromVoter (address _voter, uint256 _pollID) public onlyWhitelisted returns (bool) {
2929     if (voterPolls[_voter].remove(_pollID) != 0) {
2930       voterPollsCount[_voter] = voterPollsCount[_voter] - 1;
2931       return true;
2932     }
2933     return false;
2934   }
2935 
2936   /**
2937    * @dev Determines if proposal has more affirmative votes
2938    *      Check if votesFor out of totalVotes exceeds votesQuorum (does not require pollEnded)
2939    * @param _pollID Integer identifier associated with target poll
2940    */
2941   function isPassing(uint _pollID) public view returns (bool) {
2942     Poll memory poll = pollMap[_pollID];
2943     return (100 * poll.votesFor) > (poll.voteQuorum * (poll.votesFor + poll.votesAgainst));
2944   }
2945 
2946   /**
2947    * @dev Gets the total winning votes for reward distribution purposes.
2948    *      Returns 0 if there were not enough votes.
2949    * @param _pollID Integer identifier associated with target poll
2950    * @return Total number of votes committed to the winning option for specified poll
2951    */
2952   function getTotalNumberOfTokensForWinningOption(uint _pollID) constant public returns (uint256) {
2953     if (isRestrictedPoll[_pollID] && !isEnoughVotes(_pollID)) {
2954       return 0;
2955     }
2956     return super.getTotalNumberOfTokensForWinningOption(_pollID);
2957   }
2958 
2959   /**
2960    * @dev Gets the number of tokens allocated toward the winning vote for a particular voter.
2961    *      Zero if there were not enough votes for a restricted poll.
2962    * @param _voter Address of voter who voted in the majority bloc
2963    * @param _pollID Integer identifier associated with target poll
2964    * @return correctVotes Number of tokens voted for winning option
2965    */
2966   function getNumPassingTokens(address _voter, uint _pollID) public constant returns (uint256) {
2967     if (isRestrictedPoll[_pollID] && !isEnoughVotes(_pollID)) {
2968       return 0;
2969     }
2970     return super.getNumPassingTokens(_voter, _pollID);
2971   }
2972 
2973   /**
2974    * @dev Determines if proposal has passed
2975    *      Check if votesFor out of totalVotes exceeds votesQuorum (requires pollEnded)
2976    * @param _pollID Integer identifier associated with target poll
2977    */
2978   function isPassed(uint _pollID) constant public returns (bool) {
2979     if (isRestrictedPoll[_pollID] && !isEnoughVotes(_pollID)) {
2980       return false;
2981     }
2982     return super.isPassed(_pollID);
2983   }
2984 
2985   /**
2986    * @dev Determines if a voter has already claimed a reward for voting with the majority
2987    * @param _voter The address of the voter
2988    * @param _pollID Integer identifier associated with target poll
2989    */
2990   function hasVoterClaimedReward(address _voter, uint256 _pollID) public view returns (bool) {
2991     return voterHasClaimedReward[_voter][_pollID];
2992   }
2993 
2994   /**
2995    * @dev Determines if a voter voted yes or no for a poll
2996    * @param _voter The address of the voter
2997    * @param _pollID Integer identifier associated with target poll
2998    */
2999   function hasVotedAffirmatively(address _voter, uint256 _pollID) public view returns (bool) {
3000     return votedAffirmatively[_voter][_pollID];
3001   }
3002 
3003   /**
3004    * @dev Returns the number of unclaimed polls associated with the voter.
3005    * @param _voter The address of the voter
3006    */
3007   function getVoterPollsCount (address _voter) public view returns (uint256) {
3008     return voterPollsCount[_voter];
3009   }
3010 
3011   function getListHeadConstant () public pure returns(uint256 head) {
3012     return HEAD;
3013   }
3014 
3015   /**
3016    * @dev Given a pollID, it retrieves the next pollID voted on but unclaimed by the voter.
3017    * @param _voter The address of the voter
3018    * @param _prevPollID The id of the previous unclaimed poll. Passing 0, it returns the first poll.
3019    */
3020   function getNextPollFromVoter(address _voter, uint256 _prevPollID) public view returns (bool, uint256) {
3021     if (!voterPolls[_voter].listExists()) {
3022       return (false, 0);
3023     }
3024     uint256 pollID;
3025     bool exists;
3026     (exists, pollID) = voterPolls[_voter].getAdjacent(_prevPollID, NEXT);
3027     if (!exists || pollID == 0) {
3028       return (false, 0);
3029     }
3030     return (true, pollID);
3031   }
3032 }
3033  //Imports SafeMath