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
198 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
199 
200 /**
201  * @title Ownable
202  * @dev The Ownable contract has an owner address, and provides basic authorization control
203  * functions, this simplifies the implementation of "user permissions".
204  */
205 contract Ownable {
206   address public owner;
207 
208 
209   event OwnershipRenounced(address indexed previousOwner);
210   event OwnershipTransferred(
211     address indexed previousOwner,
212     address indexed newOwner
213   );
214 
215 
216   /**
217    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
218    * account.
219    */
220   constructor() public {
221     owner = msg.sender;
222   }
223 
224   /**
225    * @dev Throws if called by any account other than the owner.
226    */
227   modifier onlyOwner() {
228     require(msg.sender == owner);
229     _;
230   }
231 
232   /**
233    * @dev Allows the current owner to relinquish control of the contract.
234    */
235   function renounceOwnership() public onlyOwner {
236     emit OwnershipRenounced(owner);
237     owner = address(0);
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param _newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address _newOwner) public onlyOwner {
245     _transferOwnership(_newOwner);
246   }
247 
248   /**
249    * @dev Transfers control of the contract to a newOwner.
250    * @param _newOwner The address to transfer ownership to.
251    */
252   function _transferOwnership(address _newOwner) internal {
253     require(_newOwner != address(0));
254     emit OwnershipTransferred(owner, _newOwner);
255     owner = _newOwner;
256   }
257 }
258 
259 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
260 
261 /**
262  * @title Roles
263  * @author Francisco Giordano (@frangio)
264  * @dev Library for managing addresses assigned to a Role.
265  *      See RBAC.sol for example usage.
266  */
267 library Roles {
268   struct Role {
269     mapping (address => bool) bearer;
270   }
271 
272   /**
273    * @dev give an address access to this role
274    */
275   function add(Role storage role, address addr)
276     internal
277   {
278     role.bearer[addr] = true;
279   }
280 
281   /**
282    * @dev remove an address' access to this role
283    */
284   function remove(Role storage role, address addr)
285     internal
286   {
287     role.bearer[addr] = false;
288   }
289 
290   /**
291    * @dev check if an address has this role
292    * // reverts
293    */
294   function check(Role storage role, address addr)
295     view
296     internal
297   {
298     require(has(role, addr));
299   }
300 
301   /**
302    * @dev check if an address has this role
303    * @return bool
304    */
305   function has(Role storage role, address addr)
306     view
307     internal
308     returns (bool)
309   {
310     return role.bearer[addr];
311   }
312 }
313 
314 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
315 
316 /**
317  * @title RBAC (Role-Based Access Control)
318  * @author Matt Condon (@Shrugs)
319  * @dev Stores and provides setters and getters for roles and addresses.
320  * @dev Supports unlimited numbers of roles and addresses.
321  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
322  * This RBAC method uses strings to key roles. It may be beneficial
323  *  for you to write your own implementation of this interface using Enums or similar.
324  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
325  *  to avoid typos.
326  */
327 contract RBAC {
328   using Roles for Roles.Role;
329 
330   mapping (string => Roles.Role) private roles;
331 
332   event RoleAdded(address addr, string roleName);
333   event RoleRemoved(address addr, string roleName);
334 
335   /**
336    * @dev reverts if addr does not have role
337    * @param addr address
338    * @param roleName the name of the role
339    * // reverts
340    */
341   function checkRole(address addr, string roleName)
342     view
343     public
344   {
345     roles[roleName].check(addr);
346   }
347 
348   /**
349    * @dev determine if addr has role
350    * @param addr address
351    * @param roleName the name of the role
352    * @return bool
353    */
354   function hasRole(address addr, string roleName)
355     view
356     public
357     returns (bool)
358   {
359     return roles[roleName].has(addr);
360   }
361 
362   /**
363    * @dev add a role to an address
364    * @param addr address
365    * @param roleName the name of the role
366    */
367   function addRole(address addr, string roleName)
368     internal
369   {
370     roles[roleName].add(addr);
371     emit RoleAdded(addr, roleName);
372   }
373 
374   /**
375    * @dev remove a role from an address
376    * @param addr address
377    * @param roleName the name of the role
378    */
379   function removeRole(address addr, string roleName)
380     internal
381   {
382     roles[roleName].remove(addr);
383     emit RoleRemoved(addr, roleName);
384   }
385 
386   /**
387    * @dev modifier to scope access to a single role (uses msg.sender as addr)
388    * @param roleName the name of the role
389    * // reverts
390    */
391   modifier onlyRole(string roleName)
392   {
393     checkRole(msg.sender, roleName);
394     _;
395   }
396 
397   /**
398    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
399    * @param roleNames the names of the roles to scope access to
400    * // reverts
401    *
402    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
403    *  see: https://github.com/ethereum/solidity/issues/2467
404    */
405   // modifier onlyRoles(string[] roleNames) {
406   //     bool hasAnyRole = false;
407   //     for (uint8 i = 0; i < roleNames.length; i++) {
408   //         if (hasRole(msg.sender, roleNames[i])) {
409   //             hasAnyRole = true;
410   //             break;
411   //         }
412   //     }
413 
414   //     require(hasAnyRole);
415 
416   //     _;
417   // }
418 }
419 
420 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
421 
422 /**
423  * @title Whitelist
424  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
425  * @dev This simplifies the implementation of "user permissions".
426  */
427 contract Whitelist is Ownable, RBAC {
428   event WhitelistedAddressAdded(address addr);
429   event WhitelistedAddressRemoved(address addr);
430 
431   string public constant ROLE_WHITELISTED = "whitelist";
432 
433   /**
434    * @dev Throws if called by any account that's not whitelisted.
435    */
436   modifier onlyWhitelisted() {
437     checkRole(msg.sender, ROLE_WHITELISTED);
438     _;
439   }
440 
441   /**
442    * @dev add an address to the whitelist
443    * @param addr address
444    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
445    */
446   function addAddressToWhitelist(address addr)
447     onlyOwner
448     public
449   {
450     addRole(addr, ROLE_WHITELISTED);
451     emit WhitelistedAddressAdded(addr);
452   }
453 
454   /**
455    * @dev getter to determine if address is in whitelist
456    */
457   function whitelist(address addr)
458     public
459     view
460     returns (bool)
461   {
462     return hasRole(addr, ROLE_WHITELISTED);
463   }
464 
465   /**
466    * @dev add addresses to the whitelist
467    * @param addrs addresses
468    * @return true if at least one address was added to the whitelist,
469    * false if all addresses were already in the whitelist
470    */
471   function addAddressesToWhitelist(address[] addrs)
472     onlyOwner
473     public
474   {
475     for (uint256 i = 0; i < addrs.length; i++) {
476       addAddressToWhitelist(addrs[i]);
477     }
478   }
479 
480   /**
481    * @dev remove an address from the whitelist
482    * @param addr address
483    * @return true if the address was removed from the whitelist,
484    * false if the address wasn't in the whitelist in the first place
485    */
486   function removeAddressFromWhitelist(address addr)
487     onlyOwner
488     public
489   {
490     removeRole(addr, ROLE_WHITELISTED);
491     emit WhitelistedAddressRemoved(addr);
492   }
493 
494   /**
495    * @dev remove addresses from the whitelist
496    * @param addrs addresses
497    * @return true if at least one address was removed from the whitelist,
498    * false if all addresses weren't in the whitelist in the first place
499    */
500   function removeAddressesFromWhitelist(address[] addrs)
501     onlyOwner
502     public
503   {
504     for (uint256 i = 0; i < addrs.length; i++) {
505       removeAddressFromWhitelist(addrs[i]);
506     }
507   }
508 
509 }
510 
511 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
512 
513 /**
514  * @title SafeMath
515  * @dev Math operations with safety checks that throw on error
516  */
517 library SafeMath {
518 
519   /**
520   * @dev Multiplies two numbers, throws on overflow.
521   */
522   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
523     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
524     // benefit is lost if 'b' is also tested.
525     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
526     if (a == 0) {
527       return 0;
528     }
529 
530     c = a * b;
531     assert(c / a == b);
532     return c;
533   }
534 
535   /**
536   * @dev Integer division of two numbers, truncating the quotient.
537   */
538   function div(uint256 a, uint256 b) internal pure returns (uint256) {
539     // assert(b > 0); // Solidity automatically throws when dividing by 0
540     // uint256 c = a / b;
541     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
542     return a / b;
543   }
544 
545   /**
546   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
547   */
548   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
549     assert(b <= a);
550     return a - b;
551   }
552 
553   /**
554   * @dev Adds two numbers, throws on overflow.
555   */
556   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
557     c = a + b;
558     assert(c >= a);
559     return c;
560   }
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
577 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
578 
579 /**
580  * @title Basic token
581  * @dev Basic version of StandardToken, with no allowances.
582  */
583 contract BasicToken is ERC20Basic {
584   using SafeMath for uint256;
585 
586   mapping(address => uint256) balances;
587 
588   uint256 totalSupply_;
589 
590   /**
591   * @dev total number of tokens in existence
592   */
593   function totalSupply() public view returns (uint256) {
594     return totalSupply_;
595   }
596 
597   /**
598   * @dev transfer token for a specified address
599   * @param _to The address to transfer to.
600   * @param _value The amount to be transferred.
601   */
602   function transfer(address _to, uint256 _value) public returns (bool) {
603     require(_to != address(0));
604     require(_value <= balances[msg.sender]);
605 
606     balances[msg.sender] = balances[msg.sender].sub(_value);
607     balances[_to] = balances[_to].add(_value);
608     emit Transfer(msg.sender, _to, _value);
609     return true;
610   }
611 
612   /**
613   * @dev Gets the balance of the specified address.
614   * @param _owner The address to query the the balance of.
615   * @return An uint256 representing the amount owned by the passed address.
616   */
617   function balanceOf(address _owner) public view returns (uint256) {
618     return balances[_owner];
619   }
620 
621 }
622 
623 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
624 
625 /**
626  * @title ERC20 interface
627  * @dev see https://github.com/ethereum/EIPs/issues/20
628  */
629 contract ERC20 is ERC20Basic {
630   function allowance(address owner, address spender)
631     public view returns (uint256);
632 
633   function transferFrom(address from, address to, uint256 value)
634     public returns (bool);
635 
636   function approve(address spender, uint256 value) public returns (bool);
637   event Approval(
638     address indexed owner,
639     address indexed spender,
640     uint256 value
641   );
642 }
643 
644 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
645 
646 /**
647  * @title Standard ERC20 token
648  *
649  * @dev Implementation of the basic standard token.
650  * @dev https://github.com/ethereum/EIPs/issues/20
651  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
652  */
653 contract StandardToken is ERC20, BasicToken {
654 
655   mapping (address => mapping (address => uint256)) internal allowed;
656 
657 
658   /**
659    * @dev Transfer tokens from one address to another
660    * @param _from address The address which you want to send tokens from
661    * @param _to address The address which you want to transfer to
662    * @param _value uint256 the amount of tokens to be transferred
663    */
664   function transferFrom(
665     address _from,
666     address _to,
667     uint256 _value
668   )
669     public
670     returns (bool)
671   {
672     require(_to != address(0));
673     require(_value <= balances[_from]);
674     require(_value <= allowed[_from][msg.sender]);
675 
676     balances[_from] = balances[_from].sub(_value);
677     balances[_to] = balances[_to].add(_value);
678     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
679     emit Transfer(_from, _to, _value);
680     return true;
681   }
682 
683   /**
684    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
685    *
686    * Beware that changing an allowance with this method brings the risk that someone may use both the old
687    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
688    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
689    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
690    * @param _spender The address which will spend the funds.
691    * @param _value The amount of tokens to be spent.
692    */
693   function approve(address _spender, uint256 _value) public returns (bool) {
694     allowed[msg.sender][_spender] = _value;
695     emit Approval(msg.sender, _spender, _value);
696     return true;
697   }
698 
699   /**
700    * @dev Function to check the amount of tokens that an owner allowed to a spender.
701    * @param _owner address The address which owns the funds.
702    * @param _spender address The address which will spend the funds.
703    * @return A uint256 specifying the amount of tokens still available for the spender.
704    */
705   function allowance(
706     address _owner,
707     address _spender
708    )
709     public
710     view
711     returns (uint256)
712   {
713     return allowed[_owner][_spender];
714   }
715 
716   /**
717    * @dev Increase the amount of tokens that an owner allowed to a spender.
718    *
719    * approve should be called when allowed[_spender] == 0. To increment
720    * allowed value is better to use this function to avoid 2 calls (and wait until
721    * the first transaction is mined)
722    * From MonolithDAO Token.sol
723    * @param _spender The address which will spend the funds.
724    * @param _addedValue The amount of tokens to increase the allowance by.
725    */
726   function increaseApproval(
727     address _spender,
728     uint _addedValue
729   )
730     public
731     returns (bool)
732   {
733     allowed[msg.sender][_spender] = (
734       allowed[msg.sender][_spender].add(_addedValue));
735     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
736     return true;
737   }
738 
739   /**
740    * @dev Decrease the amount of tokens that an owner allowed to a spender.
741    *
742    * approve should be called when allowed[_spender] == 0. To decrement
743    * allowed value is better to use this function to avoid 2 calls (and wait until
744    * the first transaction is mined)
745    * From MonolithDAO Token.sol
746    * @param _spender The address which will spend the funds.
747    * @param _subtractedValue The amount of tokens to decrease the allowance by.
748    */
749   function decreaseApproval(
750     address _spender,
751     uint _subtractedValue
752   )
753     public
754     returns (bool)
755   {
756     uint oldValue = allowed[msg.sender][_spender];
757     if (_subtractedValue > oldValue) {
758       allowed[msg.sender][_spender] = 0;
759     } else {
760       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
761     }
762     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
763     return true;
764   }
765 
766 }
767 
768 // File: contracts/QuantstampAuditData.sol
769 
770 contract QuantstampAuditData is Whitelist {
771   // state of audit requests submitted to the contract
772   enum AuditState {
773     None,
774     Queued,
775     Assigned,
776     Refunded,
777     Completed,  // automated audit finished successfully and the report is available
778     Error,      // automated audit failed to finish; the report contains detailed information about the error
779     Expired,
780     Resolved
781   }
782 
783   // structure representing an audit
784   struct Audit {
785     address requestor;
786     string contractUri;
787     uint256 price;
788     uint256 requestBlockNumber; // block number that audit was requested
789     QuantstampAuditData.AuditState state;
790     address auditor;       // the address of the node assigned to the audit
791     uint256 assignBlockNumber;  // block number that audit was assigned
792     string reportHash;     // stores the hash of audit report
793     uint256 reportBlockNumber;  // block number that the payment and the audit report were submitted
794     address registrar;  // address of the contract which registers this request
795   }
796 
797   // map audits (requestId, Audit)
798   mapping(uint256 => Audit) public audits;
799 
800   // token used to pay for audits. This contract assumes that the owner of the contract trusts token's code and
801   // that transfer function (such as transferFrom, transfer) do the right thing
802   StandardToken public token;
803 
804   // Once an audit node gets an audit request, they must submit a report within this many blocks.
805   // After that, the report is verified by the police.
806   uint256 public auditTimeoutInBlocks = 50;
807 
808   // maximum number of assigned audits per each audit node
809   uint256 public maxAssignedRequests = 10;
810 
811   // map audit nodes to their minimum prices. Defaults to zero: the node accepts all requests.
812   mapping(address => uint256) public minAuditPrice;
813 
814   // For generating requestIds starting from 1
815   uint256 private requestCounter;
816 
817   /**
818    * @dev The constructor creates an audit contract.
819    * @param tokenAddress The address of a StandardToken that will be used to pay audit nodes.
820    */
821   constructor (address tokenAddress) public {
822     require(tokenAddress != address(0));
823     token = StandardToken(tokenAddress);
824   }
825 
826   function addAuditRequest (address requestor, string contractUri, uint256 price) public onlyWhitelisted returns(uint256) {
827     // assign the next request ID
828     uint256 requestId = ++requestCounter;
829     // store the audit
830     audits[requestId] = Audit(requestor, contractUri, price, block.number, AuditState.Queued, address(0), 0, "", 0, msg.sender);  // solhint-disable-line not-rely-on-time
831     return requestId;
832   }
833 
834   /**
835    * @dev Allows a whitelisted logic contract (QuantstampAudit) to spend stored tokens.
836    * @param amount The number of wei-QSP that will be approved.
837    */
838   function approveWhitelisted(uint256 amount) public onlyWhitelisted {
839     token.approve(msg.sender, amount);
840   }
841 
842   function getAuditContractUri(uint256 requestId) public view returns(string) {
843     return audits[requestId].contractUri;
844   }
845 
846   function getAuditRequestor(uint256 requestId) public view returns(address) {
847     return audits[requestId].requestor;
848   }
849 
850   function getAuditPrice (uint256 requestId) public view returns(uint256) {
851     return audits[requestId].price;
852   }
853 
854   function getAuditState (uint256 requestId) public view returns(AuditState) {
855     return audits[requestId].state;
856   }
857 
858   function getAuditRequestBlockNumber (uint256 requestId) public view returns(uint) {
859     return audits[requestId].requestBlockNumber;
860   }
861 
862   function setAuditState (uint256 requestId, AuditState state) public onlyWhitelisted {
863     audits[requestId].state = state;
864   }
865 
866   function getAuditAuditor (uint256 requestId) public view returns(address) {
867     return audits[requestId].auditor;
868   }
869 
870   function getAuditRegistrar (uint256 requestId) public view returns(address) {
871     return audits[requestId].registrar;
872   }
873 
874   function setAuditAuditor (uint256 requestId, address auditor) public onlyWhitelisted {
875     audits[requestId].auditor = auditor;
876   }
877 
878   function getAuditAssignBlockNumber (uint256 requestId) public view returns(uint256) {
879     return audits[requestId].assignBlockNumber;
880   }
881 
882   function getAuditReportBlockNumber (uint256 requestId) public view returns (uint256) {
883     return audits[requestId].reportBlockNumber;
884   }
885 
886   function setAuditAssignBlockNumber (uint256 requestId, uint256 assignBlockNumber) public onlyWhitelisted {
887     audits[requestId].assignBlockNumber = assignBlockNumber;
888   }
889 
890   function setAuditReportHash (uint256 requestId, string reportHash) public onlyWhitelisted {
891     audits[requestId].reportHash = reportHash;
892   }
893 
894   function setAuditReportBlockNumber (uint256 requestId, uint256 reportBlockNumber) public onlyWhitelisted {
895     audits[requestId].reportBlockNumber = reportBlockNumber;
896   }
897 
898   function setAuditRegistrar (uint256 requestId, address registrar) public onlyWhitelisted {
899     audits[requestId].registrar = registrar;
900   }
901 
902   function setAuditTimeout (uint256 timeoutInBlocks) public onlyOwner {
903     auditTimeoutInBlocks = timeoutInBlocks;
904   }
905 
906   /**
907    * @dev Set the maximum number of audits any audit node can handle at any time.
908    * @param maxAssignments Maximum number of audit requests for each audit node.
909    */
910   function setMaxAssignedRequests (uint256 maxAssignments) public onlyOwner {
911     maxAssignedRequests = maxAssignments;
912   }
913 
914   function getMinAuditPrice (address auditor) public view returns(uint256) {
915     return minAuditPrice[auditor];
916   }
917 
918   /**
919    * @dev Allows the audit node to set its minimum price per audit in wei-QSP.
920    * @param price The minimum price.
921    */
922   function setMinAuditPrice(address auditor, uint256 price) public onlyWhitelisted {
923     minAuditPrice[auditor] = price;
924   }
925 }
926 
927 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
928 
929 /**
930  * @title SafeERC20
931  * @dev Wrappers around ERC20 operations that throw on failure.
932  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
933  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
934  */
935 library SafeERC20 {
936   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
937     require(token.transfer(to, value));
938   }
939 
940   function safeTransferFrom(
941     ERC20 token,
942     address from,
943     address to,
944     uint256 value
945   )
946     internal
947   {
948     require(token.transferFrom(from, to, value));
949   }
950 
951   function safeApprove(ERC20 token, address spender, uint256 value) internal {
952     require(token.approve(spender, value));
953   }
954 }
955 
956 // File: contracts/token_escrow/TokenEscrow.sol
957 
958 /**
959  * NOTE: All contracts in this directory were taken from a non-master branch of openzeppelin-solidity.
960  * This contract was modified to be a whitelist.
961  * Commit: ed451a8688d1fa7c927b27cec299a9726667d9b1
962  */
963 
964 pragma solidity ^0.4.24;
965 
966 
967 
968 
969 
970 
971 /**
972  * @title TokenEscrow
973  * @dev Holds tokens destinated to a payee until they withdraw them.
974  * The contract that uses the TokenEscrow as its payment method
975  * should be its owner, and provide public methods redirecting
976  * to the TokenEscrow's deposit and withdraw.
977  * Moreover, the TokenEscrow should also be allowed to transfer
978  * tokens from the payer to itself.
979  */
980 contract TokenEscrow is Ownable, Whitelist {
981   using SafeMath for uint256;
982   using SafeERC20 for ERC20;
983 
984   event Deposited(address indexed payee, uint256 tokenAmount);
985   event Withdrawn(address indexed payee, uint256 tokenAmount);
986 
987   mapping(address => uint256) public deposits;
988 
989   ERC20 public token;
990 
991   constructor (ERC20 _token) public {
992     require(_token != address(0));
993     token = _token;
994   }
995 
996   function depositsOf(address _payee) public view returns (uint256) {
997     return deposits[_payee];
998   }
999 
1000   /**
1001   * @dev Puts in escrow a certain amount of tokens as credit to be withdrawn.
1002   * @param _payee The destination address of the tokens.
1003   * @param _amount The amount of tokens to deposit in escrow.
1004   */
1005   function deposit(address _payee, uint256 _amount) public onlyWhitelisted {
1006     deposits[_payee] = deposits[_payee].add(_amount);
1007 
1008     token.safeTransferFrom(msg.sender, address(this), _amount);
1009 
1010     emit Deposited(_payee, _amount);
1011   }
1012 
1013   /**
1014   * @dev Withdraw accumulated tokens for a payee.
1015   * @param _payee The address whose tokens will be withdrawn and transferred to.
1016   */
1017   function withdraw(address _payee) public onlyWhitelisted {
1018     uint256 payment = deposits[_payee];
1019     assert(token.balanceOf(address(this)) >= payment);
1020 
1021     deposits[_payee] = 0;
1022 
1023     token.safeTransfer(_payee, payment);
1024 
1025     emit Withdrawn(_payee, payment);
1026   }
1027 }
1028 
1029 // File: contracts/token_escrow/ConditionalTokenEscrow.sol
1030 
1031 /**
1032  * NOTE: All contracts in this directory were taken from a non-master branch of openzeppelin-solidity.
1033  * Commit: ed451a8688d1fa7c927b27cec299a9726667d9b1
1034  */
1035 
1036 pragma solidity ^0.4.24;
1037 
1038 
1039 
1040 /**
1041  * @title ConditionalTokenEscrow
1042  * @dev Base abstract escrow to only allow withdrawal of tokens
1043  * if a condition is met.
1044  */
1045 contract ConditionalTokenEscrow is TokenEscrow {
1046   /**
1047   * @dev Returns whether an address is allowed to withdraw their tokens.
1048   * To be implemented by derived contracts.
1049   * @param _payee The destination address of the tokens.
1050   */
1051   function withdrawalAllowed(address _payee) public view returns (bool);
1052 
1053   function withdraw(address _payee) public {
1054     require(withdrawalAllowed(_payee));
1055     super.withdraw(_payee);
1056   }
1057 }
1058 
1059 // File: contracts/QuantstampAuditTokenEscrow.sol
1060 
1061 contract QuantstampAuditTokenEscrow is ConditionalTokenEscrow {
1062 
1063   // the escrow maintains the list of staked addresses
1064   using LinkedListLib for LinkedListLib.LinkedList;
1065 
1066   // constants used by LinkedListLib
1067   uint256 constant internal NULL = 0;
1068   uint256 constant internal HEAD = 0;
1069   bool constant internal PREV = false;
1070   bool constant internal NEXT = true;
1071 
1072   // maintain the number of staked nodes
1073   // saves gas cost over needing to call stakedNodesList.sizeOf()
1074   uint256 public stakedNodesCount = 0;
1075 
1076   // the minimum amount of wei-QSP that must be staked in order to be a node
1077   uint256 public minAuditStake = 10000 * (10 ** 18);
1078 
1079   // if true, the payee cannot currently withdraw their funds
1080   mapping(address => bool) public lockedFunds;
1081 
1082   // if funds are locked, they may be retrieved after this block
1083   // if funds are unlocked, the number should be ignored
1084   mapping(address => uint256) public unlockBlockNumber;
1085 
1086   // staked audit nodes -- needed to inquire about audit node statistics, such as min price
1087   // this list contains all nodes that have *ANY* stake, however when getNextStakedNode is called,
1088   // it skips nodes that do not meet the minimum stake.
1089   // the reason for this approach is that if the owner lowers the minAuditStake,
1090   // we must be aware of any node with a stake.
1091   LinkedListLib.LinkedList internal stakedNodesList;
1092 
1093   event Slashed(address addr, uint256 amount);
1094   event StakedNodeAdded(address addr);
1095   event StakedNodeRemoved(address addr);
1096 
1097   // the constructor of TokenEscrow requires an ERC20, not an address
1098   constructor(address tokenAddress) public TokenEscrow(ERC20(tokenAddress)) {} // solhint-disable no-empty-blocks
1099 
1100   /**
1101   * @dev Puts in escrow a certain amount of tokens as credit to be withdrawn.
1102   *      Overrides the function in TokenEscrow.sol to add the payee to the staked list.
1103   * @param _payee The destination address of the tokens.
1104   * @param _amount The amount of tokens to deposit in escrow.
1105   */
1106   function deposit(address _payee, uint256 _amount) public onlyWhitelisted {
1107     super.deposit(_payee, _amount);
1108     if (_amount > 0) {
1109       // fails gracefully if the node already exists
1110       addNodeToStakedList(_payee);
1111     }
1112   }
1113 
1114  /**
1115   * @dev Withdraw accumulated tokens for a payee.
1116   *      Overrides the function in TokenEscrow.sol to remove the payee from the staked list.
1117   * @param _payee The address whose tokens will be withdrawn and transferred to.
1118   */
1119   function withdraw(address _payee) public onlyWhitelisted {
1120     super.withdraw(_payee);
1121     removeNodeFromStakedList(_payee);
1122   }
1123 
1124   /**
1125    * @dev Sets the minimum stake to a new value.
1126    * @param _value The new value. _value must be greater than zero in order for the linked list to be maintained correctly.
1127    */
1128   function setMinAuditStake(uint256 _value) public onlyOwner {
1129     require(_value > 0);
1130     minAuditStake = _value;
1131   }
1132 
1133   /**
1134    * @dev Returns true if the sender staked enough.
1135    * @param addr The address to check.
1136    */
1137   function hasEnoughStake(address addr) public view returns(bool) {
1138     return depositsOf(addr) >= minAuditStake;
1139   }
1140 
1141   /**
1142    * @dev Overrides ConditionalTokenEscrow function. If true, funds may be withdrawn.
1143    * @param _payee The address that wants to withdraw funds.
1144    */
1145   function withdrawalAllowed(address _payee) public view returns (bool) {
1146     return !lockedFunds[_payee] || unlockBlockNumber[_payee] < block.number;
1147   }
1148 
1149   /**
1150    * @dev Prevents the payee from withdrawing funds.
1151    * @param _payee The address that will be locked.
1152    */
1153   function lockFunds(address _payee, uint256 _unlockBlockNumber) public onlyWhitelisted returns (bool) {
1154     lockedFunds[_payee] = true;
1155     unlockBlockNumber[_payee] = _unlockBlockNumber;
1156     return true;
1157   }
1158 
1159     /**
1160    * @dev Slash a percentage of the stake of an address.
1161    *      The percentage is taken from the minAuditStake, not the total stake of the address.
1162    *      The caller of this function receives the slashed QSP.
1163    *      If the current stake does not cover the slash amount, the full stake is taken.
1164    *
1165    * @param addr The address that will be slashed.
1166    * @param percentage The percent of the minAuditStake that should be slashed.
1167    */
1168   function slash(address addr, uint256 percentage) public onlyWhitelisted returns (uint256) {
1169     require(0 <= percentage && percentage <= 100);
1170 
1171     uint256 slashAmount = getSlashAmount(percentage);
1172     uint256 balance = depositsOf(addr);
1173     if (balance < slashAmount) {
1174       slashAmount = balance;
1175     }
1176 
1177     // subtract from the deposits amount of the addr
1178     deposits[addr] = deposits[addr].sub(slashAmount);
1179 
1180     emit Slashed(addr, slashAmount);
1181 
1182     // if the deposits of the address are now zero, remove from the list
1183     if (depositsOf(addr) == 0) {
1184       removeNodeFromStakedList(addr);
1185     }
1186 
1187     // transfer the slashAmount to the police contract
1188     token.safeTransfer(msg.sender, slashAmount);
1189 
1190     return slashAmount;
1191   }
1192 
1193   /**
1194    * @dev Returns the slash amount for a given percentage.
1195    * @param percentage The percent of the minAuditStake that should be slashed.
1196    */
1197   function getSlashAmount(uint256 percentage) public view returns (uint256) {
1198     return (minAuditStake.mul(percentage)).div(100);
1199   }
1200 
1201   /**
1202    * @dev Given a staked address, returns the next address from the list that meets the minAuditStake.
1203    * @param addr The staked address.
1204    * @return The next address in the list.
1205    */
1206   function getNextStakedNode(address addr) public view returns(address) {
1207     bool exists;
1208     uint256 next;
1209     (exists, next) = stakedNodesList.getAdjacent(uint256(addr), NEXT);
1210     // only return addresses that meet the minAuditStake
1211     while (exists && next != HEAD && !hasEnoughStake(address(next))) {
1212       (exists, next) = stakedNodesList.getAdjacent(next, NEXT);
1213     }
1214     return address(next);
1215   }
1216 
1217   /**
1218    * @dev Adds an address to the stakedNodesList.
1219    * @param addr The address to be added to the list.
1220    * @return true if the address was added to the list.
1221    */
1222   function addNodeToStakedList(address addr) internal returns(bool success) {
1223     if (stakedNodesList.insert(HEAD, uint256(addr), PREV)) {
1224       stakedNodesCount++;
1225       emit StakedNodeAdded(addr);
1226       success = true;
1227     }
1228   }
1229 
1230   /**
1231    * @dev Removes an address from the stakedNodesList.
1232    * @param addr The address to be removed from the list.
1233    * @return true if the address was removed from the list.
1234    */
1235   function removeNodeFromStakedList(address addr) internal returns(bool success) {
1236     if (stakedNodesList.remove(uint256(addr)) != 0) {
1237       stakedNodesCount--;
1238       emit StakedNodeRemoved(addr);
1239       success = true;
1240     }
1241   }
1242 }
1243 
1244 // File: contracts/QuantstampAuditPolice.sol
1245 
1246 // TODO (QSP-833): salary and taxing
1247 // TODO transfer existing salary if removing police
1248 contract QuantstampAuditPolice is Whitelist {   // solhint-disable max-states-count
1249 
1250   using SafeMath for uint256;
1251   using LinkedListLib for LinkedListLib.LinkedList;
1252 
1253   // constants used by LinkedListLib
1254   uint256 constant internal NULL = 0;
1255   uint256 constant internal HEAD = 0;
1256   bool constant internal PREV = false;
1257   bool constant internal NEXT = true;
1258 
1259   enum PoliceReportState {
1260     UNVERIFIED,
1261     INVALID,
1262     VALID,
1263     EXPIRED
1264   }
1265 
1266   // whitelisted police nodes
1267   LinkedListLib.LinkedList internal policeList;
1268 
1269   // the total number of police nodes
1270   uint256 public numPoliceNodes = 0;
1271 
1272   // the number of police nodes assigned to each report
1273   uint256 public policeNodesPerReport = 3;
1274 
1275   // the number of blocks the police have to verify a report
1276   uint256 public policeTimeoutInBlocks = 100;
1277 
1278   // number from [0-100] that indicates the percentage of the minAuditStake that should be slashed
1279   uint256 public slashPercentage = 20;
1280 
1281     // this is only deducted once per report, regardless of the number of police nodes assigned to it
1282   uint256 public reportProcessingFeePercentage = 5;
1283 
1284   event PoliceNodeAdded(address addr);
1285   event PoliceNodeRemoved(address addr);
1286   // TODO: we may want these parameters indexed
1287   event PoliceNodeAssignedToReport(address policeNode, uint256 requestId);
1288   event PoliceSubmissionPeriodExceeded(uint256 requestId, uint256 timeoutBlock, uint256 currentBlock);
1289   event PoliceSlash(uint256 requestId, address policeNode, address auditNode, uint256 amount);
1290   event PoliceFeesClaimed(address policeNode, uint256 fee);
1291   event PoliceFeesCollected(uint256 requestId, uint256 fee);
1292   event PoliceAssignmentExpiredAndCleared(uint256 requestId);
1293 
1294   // pointer to the police node that was last assigned to a report
1295   address private lastAssignedPoliceNode = address(HEAD);
1296 
1297   // maps each police node to the IDs of reports it should check
1298   mapping(address => LinkedListLib.LinkedList) internal assignedReports;
1299 
1300   // maps request IDs to the police nodes that are expected to check the report
1301   mapping(uint256 => LinkedListLib.LinkedList) internal assignedPolice;
1302 
1303   // maps each audit node to the IDs of reports that are pending police approval for payment
1304   mapping(address => LinkedListLib.LinkedList) internal pendingPayments;
1305 
1306   // maps request IDs to police timeouts
1307   mapping(uint256 => uint256) public policeTimeouts;
1308 
1309   // maps request IDs to reports submitted by police nodes
1310   mapping(uint256 => mapping(address => bytes)) public policeReports;
1311 
1312   // maps request IDs to the result reported by each police node
1313   mapping(uint256 => mapping(address => PoliceReportState)) public policeReportResults;
1314 
1315   // maps request IDs to whether they have been verified by the police
1316   mapping(uint256 => PoliceReportState) public verifiedReports;
1317 
1318   // maps request IDs to whether their reward has been claimed by the submitter
1319   mapping(uint256 => bool) public rewardHasBeenClaimed;
1320 
1321   // tracks the total number of reports ever assigned to a police node
1322   mapping(address => uint256) public totalReportsAssigned;
1323 
1324   // tracks the total number of reports ever checked by a police node
1325   mapping(address => uint256) public totalReportsChecked;
1326 
1327   // the collected fees for each report
1328   mapping(uint256 => uint256) public collectedFees;
1329 
1330   // contract that stores audit data (separate from the auditing logic)
1331   QuantstampAuditData public auditData;
1332 
1333   // contract that stores token escrows of nodes on the network
1334   QuantstampAuditTokenEscrow public tokenEscrow;
1335 
1336   /**
1337    * @dev The constructor creates a police contract.
1338    * @param auditDataAddress The address of an AuditData that stores data used for performing audits.
1339    * @param escrowAddress The address of a QuantstampTokenEscrow contract that holds staked deposits of nodes.
1340    */
1341   constructor (address auditDataAddress, address escrowAddress) public {
1342     require(auditDataAddress != address(0));
1343     require(escrowAddress != address(0));
1344     auditData = QuantstampAuditData(auditDataAddress);
1345     tokenEscrow = QuantstampAuditTokenEscrow(escrowAddress);
1346   }
1347 
1348   /**
1349    * @dev Assigns police nodes to a submitted report
1350    * @param requestId The ID of the audit request.
1351    */
1352   function assignPoliceToReport(uint256 requestId) public onlyWhitelisted {
1353     // ensure that the requestId has not already been assigned to police already
1354     require(policeTimeouts[requestId] == 0);
1355     // set the timeout for police reports
1356     policeTimeouts[requestId] = block.number + policeTimeoutInBlocks;
1357     // if there are not enough police nodes, this avoids assigning the same node twice
1358     uint256 numToAssign = policeNodesPerReport;
1359     if (numPoliceNodes < numToAssign) {
1360       numToAssign = numPoliceNodes;
1361     }
1362     while (numToAssign > 0) {
1363       lastAssignedPoliceNode = getNextPoliceNode(lastAssignedPoliceNode);
1364       if (lastAssignedPoliceNode != address(0)) {
1365         // push the request ID to the tail of the assignment list for the police node
1366         assignedReports[lastAssignedPoliceNode].push(requestId, PREV);
1367         // push the police node to the list of nodes assigned to check the report
1368         assignedPolice[requestId].push(uint256(lastAssignedPoliceNode), PREV);
1369         emit PoliceNodeAssignedToReport(lastAssignedPoliceNode, requestId);
1370         totalReportsAssigned[lastAssignedPoliceNode] = totalReportsAssigned[lastAssignedPoliceNode].add(1);
1371         numToAssign = numToAssign.sub(1);
1372       }
1373     }
1374   }
1375 
1376   /**
1377    * Cleans the list of assignments to police node (msg.sender), but checks only up to a limit
1378    * of assignments. If the limit is 0, attempts to clean the entire list.
1379    * @param policeNode The node whose assignments should be cleared.
1380    * @param limit The number of assigments to check.
1381    */
1382   function clearExpiredAssignments (address policeNode, uint256 limit) public {
1383     removeExpiredAssignments(policeNode, 0, limit);
1384   }
1385 
1386   /**
1387    * @dev Collects the police fee for checking a report.
1388    *      NOTE: this function assumes that the fee will be transferred by the calling contract.
1389    * @param requestId The ID of the audit request.
1390    * @return The amount collected.
1391    */
1392   function collectFee(uint256 requestId) public onlyWhitelisted returns (uint256) {
1393     uint256 policeFee = getPoliceFee(auditData.getAuditPrice(requestId));
1394     // the collected fee needs to be stored in a map since the owner could change the fee percentage
1395     collectedFees[requestId] = policeFee;
1396     emit PoliceFeesCollected(requestId, policeFee);
1397     return policeFee;
1398   }
1399 
1400   /**
1401    * @dev Split a payment, which may be for report checking or from slashing, amongst all police nodes
1402    * @param amount The amount to be split, which should have been transferred to this contract earlier.
1403    */
1404   function splitPayment(uint256 amount) public onlyWhitelisted {
1405     require(numPoliceNodes != 0);
1406     address policeNode = getNextPoliceNode(address(HEAD));
1407     uint256 amountPerNode = amount.div(numPoliceNodes);
1408     // TODO: upgrade our openzeppelin version to use mod
1409     uint256 largerAmount = amountPerNode.add(amount % numPoliceNodes);
1410     bool largerAmountClaimed = false;
1411     while (policeNode != address(HEAD)) {
1412       // give the largerAmount to the current lastAssignedPoliceNode if it is not equal to HEAD
1413       // this approach is only truly fair if numPoliceNodes and policeNodesPerReport are relatively prime
1414       // but the remainder should be extremely small in any case
1415       // the last conditional handles the edge case where all police nodes were removed and then re-added
1416       if (!largerAmountClaimed && (policeNode == lastAssignedPoliceNode || lastAssignedPoliceNode == address(HEAD))) {
1417         require(auditData.token().transfer(policeNode, largerAmount));
1418         emit PoliceFeesClaimed(policeNode, largerAmount);
1419         largerAmountClaimed = true;
1420       } else {
1421         require(auditData.token().transfer(policeNode, amountPerNode));
1422         emit PoliceFeesClaimed(policeNode, amountPerNode);
1423       }
1424       policeNode = getNextPoliceNode(address(policeNode));
1425     }
1426   }
1427 
1428   /**
1429    * @dev Associates a pending payment with an auditor that can be claimed after the policing period.
1430    * @param auditor The audit node that submitted the report.
1431    * @param requestId The ID of the audit request.
1432    */
1433   function addPendingPayment(address auditor, uint256 requestId) public onlyWhitelisted {
1434     pendingPayments[auditor].push(requestId, PREV);
1435   }
1436 
1437   /**
1438    * @dev Submits verification of a report by a police node.
1439    * @param policeNode The address of the police node.
1440    * @param auditNode The address of the audit node.
1441    * @param requestId The ID of the audit request.
1442    * @param report The compressed bytecode representation of the report.
1443    * @param isVerified Whether the police node's report matches the submitted report.
1444    *                   If not, the audit node is slashed.
1445    * @return two bools and a uint256: (true if the report was successfully submitted, true if a slash occurred, the slash amount).
1446    */
1447   function submitPoliceReport(
1448     address policeNode,
1449     address auditNode,
1450     uint256 requestId,
1451     bytes report,
1452     bool isVerified) public onlyWhitelisted returns (bool, bool, uint256) {
1453     // remove expired assignments
1454     bool hasRemovedCurrentId = removeExpiredAssignments(policeNode, requestId, 0);
1455     // if the current request has timed out, return
1456     if (hasRemovedCurrentId) {
1457       emit PoliceSubmissionPeriodExceeded(requestId, policeTimeouts[requestId], block.number);
1458       return (false, false, 0);
1459     }
1460     // the police node is assigned to the report
1461     require(isAssigned(requestId, policeNode));
1462 
1463     // remove the report from the assignments to the node
1464     assignedReports[policeNode].remove(requestId);
1465     // increment the number of reports checked by the police node
1466     totalReportsChecked[policeNode] = totalReportsChecked[policeNode] + 1;
1467     // store the report
1468     policeReports[requestId][policeNode] = report;
1469     // emit an event
1470     PoliceReportState state;
1471     if (isVerified) {
1472       state = PoliceReportState.VALID;
1473     } else {
1474       state = PoliceReportState.INVALID;
1475     }
1476     policeReportResults[requestId][policeNode] = state;
1477 
1478     // the report was already marked invalid by a different police node
1479     if (verifiedReports[requestId] == PoliceReportState.INVALID) {
1480       return (true, false, 0);
1481     } else {
1482       verifiedReports[requestId] = state;
1483     }
1484     bool slashOccurred;
1485     uint256 slashAmount;
1486     if (!isVerified) {
1487       pendingPayments[auditNode].remove(requestId);
1488       // an audit node can only be slashed once for each report,
1489       // even if multiple police mark the report as invalid
1490       slashAmount = tokenEscrow.slash(auditNode, slashPercentage);
1491       slashOccurred = true;
1492       emit PoliceSlash(requestId, policeNode, auditNode, slashAmount);
1493     }
1494     return (true, slashOccurred, slashAmount);
1495   }
1496 
1497   /**
1498    * @dev Determines whether an audit node is allowed by the police to claim an audit.
1499    * @param auditNode The address of the audit node.
1500    * @param requestId The ID of the requested audit.
1501    */
1502   function canClaimAuditReward (address auditNode, uint256 requestId) public view returns (bool) {
1503     // NOTE: can't use requires here, as claimNextReward needs to iterate the full list
1504     return
1505       // the report is in the pending payments list for the audit node
1506       pendingPayments[auditNode].nodeExists(requestId) &&
1507       // the policing period has ended for the report
1508       policeTimeouts[requestId] < block.number &&
1509       // the police did not invalidate the report
1510       verifiedReports[requestId] != PoliceReportState.INVALID &&
1511       // the reward has not already been claimed
1512       !rewardHasBeenClaimed[requestId] &&
1513       // the requestId is non-zero
1514       requestId > 0;
1515   }
1516 
1517   /**
1518    * @dev Given a requestId, returns the next pending available reward for the audit node.
1519    * @param auditNode The address of the audit node.
1520    * @param requestId The ID of the current linked list node
1521    * @return true if the next reward exists, and the corresponding requestId in the linked list
1522    */
1523   function getNextAvailableReward (address auditNode, uint256 requestId) public view returns (bool, uint256) {
1524     bool exists;
1525     (exists, requestId) = pendingPayments[auditNode].getAdjacent(requestId, NEXT);
1526     // NOTE: Do NOT short circuit this list based on timeouts.
1527     // The ordering may be broken if the owner changes the timeouts.
1528     while (exists && requestId != HEAD) {
1529       if (canClaimAuditReward(auditNode, requestId)) {
1530         return (true, requestId);
1531       }
1532       (exists, requestId) = pendingPayments[auditNode].getAdjacent(requestId, NEXT);
1533     }
1534     return (false, 0);
1535   }
1536 
1537   /**
1538    * @dev Sets the reward as claimed after checking that it can be claimed.
1539    *      This function also ensures double payment does not occur.
1540    * @param auditNode The address of the audit node.
1541    * @param requestId The ID of the requested audit.
1542    */
1543   function setRewardClaimed (address auditNode, uint256 requestId) public onlyWhitelisted returns (bool) {
1544     // set the reward to claimed, to avoid double payment
1545     rewardHasBeenClaimed[requestId] = true;
1546     pendingPayments[auditNode].remove(requestId);
1547     // if it is possible to claim yet the state is UNVERIFIED, mark EXPIRED
1548     if (verifiedReports[requestId] == PoliceReportState.UNVERIFIED) {
1549       verifiedReports[requestId] = PoliceReportState.EXPIRED;
1550     }
1551     return true;
1552   }
1553 
1554   /**
1555    * @dev Selects the next ID to be rewarded.
1556    * @param auditNode The address of the audit node.
1557    * @param requestId The previous claimed requestId (initially set to HEAD).
1558    * @return True if another reward exists, and the request ID.
1559    */
1560   function claimNextReward (address auditNode, uint256 requestId) public onlyWhitelisted returns (bool, uint256) {
1561     bool exists;
1562     (exists, requestId) = pendingPayments[auditNode].getAdjacent(requestId, NEXT);
1563     // NOTE: Do NOT short circuit this list based on timeouts.
1564     // The ordering may be broken if the owner changes the timeouts.
1565     while (exists && requestId != HEAD) {
1566       if (canClaimAuditReward(auditNode, requestId)) {
1567         setRewardClaimed(auditNode, requestId);
1568         return (true, requestId);
1569       }
1570       (exists, requestId) = pendingPayments[auditNode].getAdjacent(requestId, NEXT);
1571     }
1572     return (false, 0);
1573   }
1574 
1575   /**
1576    * @dev Gets the next assigned report to the police node.
1577    * @param policeNode The address of the police node.
1578    * @return true if the list is non-empty, requestId, auditPrice, uri, and policeAssignmentBlockNumber.
1579    */
1580   function getNextPoliceAssignment(address policeNode) public view returns (bool, uint256, uint256, string, uint256) {
1581     bool exists;
1582     uint256 requestId;
1583     (exists, requestId) = assignedReports[policeNode].getAdjacent(HEAD, NEXT);
1584     // if the head of the list is an expired assignment, try to find a current one
1585     while (exists && requestId != HEAD) {
1586       if (policeTimeouts[requestId] < block.number) {
1587         (exists, requestId) = assignedReports[policeNode].getAdjacent(requestId, NEXT);
1588       } else {
1589         uint256 price = auditData.getAuditPrice(requestId);
1590         string memory uri = auditData.getAuditContractUri(requestId);
1591         uint256 policeAssignmentBlockNumber = auditData.getAuditReportBlockNumber(requestId);
1592         return (exists, requestId, price, uri, policeAssignmentBlockNumber);
1593       }
1594     }
1595     return (false, 0, 0, "", 0);
1596   }
1597 
1598   /**
1599    * @dev Gets the next assigned police node to an audit request.
1600    * @param requestId The ID of the audit request.
1601    * @param policeNode The previous claimed requestId (initially set to HEAD).
1602    * @return true if the next police node exists, and the address of the police node.
1603    */
1604   function getNextAssignedPolice(uint256 requestId, address policeNode) public view returns (bool, address) {
1605     bool exists;
1606     uint256 nextPoliceNode;
1607     (exists, nextPoliceNode) = assignedPolice[requestId].getAdjacent(uint256(policeNode), NEXT);
1608     if (nextPoliceNode == HEAD) {
1609       return (false, address(0));
1610     }
1611     return (exists, address(nextPoliceNode));
1612   }
1613 
1614   /**
1615    * @dev Sets the number of police nodes that should check each report.
1616    * @param numPolice The number of police.
1617    */
1618   function setPoliceNodesPerReport(uint256 numPolice) public onlyOwner {
1619     policeNodesPerReport = numPolice;
1620   }
1621 
1622   /**
1623    * @dev Sets the police timeout.
1624    * @param numBlocks The number of blocks for the timeout.
1625    */
1626   function setPoliceTimeoutInBlocks(uint256 numBlocks) public onlyOwner {
1627     policeTimeoutInBlocks = numBlocks;
1628   }
1629 
1630   /**
1631    * @dev Sets the slash percentage.
1632    * @param percentage The percentage as an integer from [0-100].
1633    */
1634   function setSlashPercentage(uint256 percentage) public onlyOwner {
1635     require(0 <= percentage && percentage <= 100);
1636     slashPercentage = percentage;
1637   }
1638 
1639   /**
1640    * @dev Sets the report processing fee percentage.
1641    * @param percentage The percentage in the range of [0-100].
1642    */
1643   function setReportProcessingFeePercentage(uint256 percentage) public onlyOwner {
1644     require(percentage <= 100);
1645     reportProcessingFeePercentage = percentage;
1646   }
1647 
1648   /**
1649    * @dev Returns true if a node is whitelisted.
1650    * @param node The node to check.
1651    */
1652   function isPoliceNode(address node) public view returns (bool) {
1653     return policeList.nodeExists(uint256(node));
1654   }
1655 
1656   /**
1657    * @dev Adds an address to the police.
1658    * @param addr The address to be added.
1659    * @return true if the address was added to the whitelist.
1660    */
1661   function addPoliceNode(address addr) public onlyOwner returns (bool success) {
1662     if (policeList.insert(HEAD, uint256(addr), PREV)) {
1663       numPoliceNodes = numPoliceNodes.add(1);
1664       emit PoliceNodeAdded(addr);
1665       success = true;
1666     }
1667   }
1668 
1669   /**
1670    * @dev Removes an address from the whitelist linked-list.
1671    * @param addr The address to be removed.
1672    * @return true if the address was removed from the whitelist.
1673    */
1674   function removePoliceNode(address addr) public onlyOwner returns (bool success) {
1675     // if lastAssignedPoliceNode is addr, need to move the pointer
1676     bool exists;
1677     uint256 next;
1678     if (lastAssignedPoliceNode == addr) {
1679       (exists, next) = policeList.getAdjacent(uint256(addr), NEXT);
1680       lastAssignedPoliceNode = address(next);
1681     }
1682 
1683     if (policeList.remove(uint256(addr)) != NULL) {
1684       numPoliceNodes = numPoliceNodes.sub(1);
1685       emit PoliceNodeRemoved(addr);
1686       success = true;
1687     }
1688   }
1689 
1690   /**
1691    * @dev Given a whitelisted address, returns the next address from the whitelist.
1692    * @param addr The address in the whitelist.
1693    * @return The next address in the whitelist.
1694    */
1695   function getNextPoliceNode(address addr) public view returns (address) {
1696     bool exists;
1697     uint256 next;
1698     (exists, next) = policeList.getAdjacent(uint256(addr), NEXT);
1699     return address(next);
1700   }
1701 
1702   /**
1703    * @dev Returns the resulting state of a police report for a given audit request.
1704    * @param requestId The ID of the audit request.
1705    * @param policeAddr The address of the police node.
1706    * @return the PoliceReportState of the (requestId, policeNode) pair.
1707    */
1708   function getPoliceReportResult(uint256 requestId, address policeAddr) public view returns (PoliceReportState) {
1709     return policeReportResults[requestId][policeAddr];
1710   }
1711 
1712   function getPoliceReport(uint256 requestId, address policeAddr) public view returns (bytes) {
1713     return policeReports[requestId][policeAddr];
1714   }
1715 
1716   function getPoliceFee(uint256 auditPrice) public view returns (uint256) {
1717     return auditPrice.mul(reportProcessingFeePercentage).div(100);
1718   }
1719 
1720   function isAssigned(uint256 requestId, address policeAddr) public view returns (bool) {
1721     return assignedReports[policeAddr].nodeExists(requestId);
1722   }
1723 
1724   /**
1725    * Cleans the list of assignments to a given police node.
1726    * @param policeNode The address of the police node.
1727    * @param requestId The ID of the audit request.
1728    * @param limit The number of assigments to check. Use 0 if the entire list should be checked.
1729    * @return true if the current request ID gets removed during cleanup.
1730    */
1731   function removeExpiredAssignments (address policeNode, uint256 requestId, uint256 limit) internal returns (bool) {
1732     bool hasRemovedCurrentId = false;
1733     bool exists;
1734     uint256 potentialExpiredRequestId;
1735     uint256 nextExpiredRequestId;
1736     uint256 iterationsLeft = limit;
1737     (exists, nextExpiredRequestId) = assignedReports[policeNode].getAdjacent(HEAD, NEXT);
1738     // NOTE: Short circuiting this list may cause expired assignments to exist later in the list.
1739     //       The may occur if the owner changes the global police timeout.
1740     //       These expired assignments will be removed in subsequent calls.
1741     while (exists && nextExpiredRequestId != HEAD && (limit == 0 || iterationsLeft > 0)) {
1742       potentialExpiredRequestId = nextExpiredRequestId;
1743       (exists, nextExpiredRequestId) = assignedReports[policeNode].getAdjacent(nextExpiredRequestId, NEXT);
1744       if (policeTimeouts[potentialExpiredRequestId] < block.number) {
1745         assignedReports[policeNode].remove(potentialExpiredRequestId);
1746         emit PoliceAssignmentExpiredAndCleared(potentialExpiredRequestId);
1747         if (potentialExpiredRequestId == requestId) {
1748           hasRemovedCurrentId = true;
1749         }
1750       } else {
1751         break;
1752       }
1753       iterationsLeft -= 1;
1754     }
1755     return hasRemovedCurrentId;
1756   }
1757 }