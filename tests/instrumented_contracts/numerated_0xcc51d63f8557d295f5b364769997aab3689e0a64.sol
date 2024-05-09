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
1072   // the minimum amount of wei-QSP that must be staked in order to be a node
1073   uint256 public minAuditStake = 10000 * (10 ** 18);
1074 
1075   // if true, the payee cannot currently withdraw their funds
1076   mapping(address => bool) public lockedFunds;
1077 
1078   // if funds are locked, they may be retrieved after this block
1079   // if funds are unlocked, the number should be ignored
1080   mapping(address => uint256) public unlockBlockNumber;
1081 
1082   // staked audit nodes -- needed to inquire about audit node statistics, such as min price
1083   // this list contains all nodes that have *ANY* stake, however when getNextStakedNode is called,
1084   // it skips nodes that do not meet the minimum stake.
1085   // the reason for this approach is that if the owner lowers the minAuditStake,
1086   // we must be aware of any node with a stake.
1087   LinkedListLib.LinkedList internal stakedNodesList;
1088 
1089   event Slashed(address addr, uint256 amount);
1090   event StakedNodeAdded(address addr);
1091   event StakedNodeRemoved(address addr);
1092 
1093   // the constructor of TokenEscrow requires an ERC20, not an address
1094   constructor(address tokenAddress) public TokenEscrow(ERC20(tokenAddress)) {} // solhint-disable no-empty-blocks
1095 
1096   /**
1097   * @dev Puts in escrow a certain amount of tokens as credit to be withdrawn.
1098   *      Overrides the function in TokenEscrow.sol to add the payee to the staked list.
1099   * @param _payee The destination address of the tokens.
1100   * @param _amount The amount of tokens to deposit in escrow.
1101   */
1102   function deposit(address _payee, uint256 _amount) public onlyWhitelisted {
1103     super.deposit(_payee, _amount);
1104     if (_amount > 0) {
1105       // fails gracefully if the node already exists
1106       addNodeToStakedList(_payee);
1107     }
1108   }
1109 
1110  /**
1111   * @dev Withdraw accumulated tokens for a payee.
1112   *      Overrides the function in TokenEscrow.sol to remove the payee from the staked list.
1113   * @param _payee The address whose tokens will be withdrawn and transferred to.
1114   */
1115   function withdraw(address _payee) public onlyWhitelisted {
1116     super.withdraw(_payee);
1117     removeNodeFromStakedList(_payee);
1118   }
1119 
1120   /**
1121    * @dev Sets the minimum stake to a new value.
1122    * @param _value The new value. _value must be greater than zero in order for the linked list to be maintained correctly.
1123    */
1124   function setMinAuditStake(uint256 _value) public onlyOwner {
1125     require(_value > 0);
1126     minAuditStake = _value;
1127   }
1128 
1129   /**
1130    * @dev Returns true if the sender staked enough.
1131    * @param addr The address to check.
1132    */
1133   function hasEnoughStake(address addr) public view returns(bool) {
1134     return depositsOf(addr) >= minAuditStake;
1135   }
1136 
1137   /**
1138    * @dev Overrides ConditionalTokenEscrow function. If true, funds may be withdrawn.
1139    * @param _payee The address that wants to withdraw funds.
1140    */
1141   function withdrawalAllowed(address _payee) public view returns (bool) {
1142     return !lockedFunds[_payee] || unlockBlockNumber[_payee] < block.number;
1143   }
1144 
1145   /**
1146    * @dev Prevents the payee from withdrawing funds.
1147    * @param _payee The address that will be locked.
1148    */
1149   function lockFunds(address _payee, uint256 _unlockBlockNumber) public onlyWhitelisted returns (bool) {
1150     lockedFunds[_payee] = true;
1151     unlockBlockNumber[_payee] = _unlockBlockNumber;
1152     return true;
1153   }
1154 
1155     /**
1156    * @dev Slash a percentage of the stake of an address.
1157    *      The percentage is taken from the minAuditStake, not the total stake of the address.
1158    *      The caller of this function receives the slashed QSP.
1159    *      If the current stake does not cover the slash amount, the full stake is taken.
1160    *
1161    * @param addr The address that will be slashed.
1162    * @param percentage The percent of the minAuditStake that should be slashed.
1163    */
1164   function slash(address addr, uint256 percentage) public onlyWhitelisted returns (uint256) {
1165     require(0 <= percentage && percentage <= 100);
1166 
1167     uint256 slashAmount = getSlashAmount(percentage);
1168     uint256 balance = depositsOf(addr);
1169     if (balance < slashAmount) {
1170       slashAmount = balance;
1171     }
1172 
1173     // subtract from the deposits amount of the addr
1174     deposits[addr] = deposits[addr].sub(slashAmount);
1175 
1176     emit Slashed(addr, slashAmount);
1177 
1178     // if the deposits of the address are now zero, remove from the list
1179     if (depositsOf(addr) == 0) {
1180       removeNodeFromStakedList(addr);
1181     }
1182 
1183     // transfer the slashAmount to the police contract
1184     token.safeTransfer(msg.sender, slashAmount);
1185 
1186     return slashAmount;
1187   }
1188 
1189   /**
1190    * @dev Returns the slash amount for a given percentage.
1191    * @param percentage The percent of the minAuditStake that should be slashed.
1192    */
1193   function getSlashAmount(uint256 percentage) public view returns (uint256) {
1194     return (minAuditStake.mul(percentage)).div(100);
1195   }
1196 
1197   /**
1198    * @dev Given a staked address, returns the next address from the list that meets the minAuditStake.
1199    * @param addr The staked address.
1200    * @return The next address in the list.
1201    */
1202   function getNextStakedNode(address addr) public view returns(address) {
1203     bool exists;
1204     uint256 next;
1205     (exists, next) = stakedNodesList.getAdjacent(uint256(addr), NEXT);
1206     // only return addresses that meet the minAuditStake
1207     while (exists && next != HEAD && !hasEnoughStake(address(next))) {
1208       (exists, next) = stakedNodesList.getAdjacent(next, NEXT);
1209     }
1210     return address(next);
1211   }
1212 
1213   /**
1214    * @dev Adds an address to the stakedNodesList.
1215    * @param addr The address to be added to the list.
1216    * @return true if the address was added to the list.
1217    */
1218   function addNodeToStakedList(address addr) internal returns(bool success) {
1219     if (stakedNodesList.insert(HEAD, uint256(addr), PREV)) {
1220       emit StakedNodeAdded(addr);
1221       success = true;
1222     }
1223   }
1224 
1225   /**
1226    * @dev Removes an address from the stakedNodesList.
1227    * @param addr The address to be removed from the list.
1228    * @return true if the address was removed from the list.
1229    */
1230   function removeNodeFromStakedList(address addr) internal returns(bool success) {
1231     if (stakedNodesList.remove(uint256(addr)) != 0) {
1232       emit StakedNodeRemoved(addr);
1233       success = true;
1234     }
1235   }
1236 }
1237 
1238 // File: contracts/QuantstampAuditPolice.sol
1239 
1240 // TODO (QSP-833): salary and taxing
1241 // TODO transfer existing salary if removing police
1242 contract QuantstampAuditPolice is Whitelist {   // solhint-disable max-states-count
1243 
1244   using SafeMath for uint256;
1245   using LinkedListLib for LinkedListLib.LinkedList;
1246 
1247   // constants used by LinkedListLib
1248   uint256 constant internal NULL = 0;
1249   uint256 constant internal HEAD = 0;
1250   bool constant internal PREV = false;
1251   bool constant internal NEXT = true;
1252 
1253   enum PoliceReportState {
1254     UNVERIFIED,
1255     INVALID,
1256     VALID,
1257     EXPIRED
1258   }
1259 
1260   // whitelisted police nodes
1261   LinkedListLib.LinkedList internal policeList;
1262 
1263   // the total number of police nodes
1264   uint256 public numPoliceNodes = 0;
1265 
1266   // the number of police nodes assigned to each report
1267   uint256 public policeNodesPerReport = 3;
1268 
1269   // the number of blocks the police have to verify a report
1270   uint256 public policeTimeoutInBlocks = 100;
1271 
1272   // number from [0-100] that indicates the percentage of the minAuditStake that should be slashed
1273   uint256 public slashPercentage = 20;
1274 
1275     // this is only deducted once per report, regardless of the number of police nodes assigned to it
1276   uint256 public reportProcessingFeePercentage = 5;
1277 
1278   event PoliceNodeAdded(address addr);
1279   event PoliceNodeRemoved(address addr);
1280   // TODO: we may want these parameters indexed
1281   event PoliceNodeAssignedToReport(address policeNode, uint256 requestId);
1282   event PoliceSubmissionPeriodExceeded(uint256 requestId, uint256 timeoutBlock, uint256 currentBlock);
1283   event PoliceSlash(uint256 requestId, address policeNode, address auditNode, uint256 amount);
1284   event PoliceFeesClaimed(address policeNode, uint256 fee);
1285   event PoliceFeesCollected(uint256 requestId, uint256 fee);
1286   event PoliceAssignmentExpiredAndCleared(uint256 requestId);
1287 
1288   // pointer to the police node that was last assigned to a report
1289   address private lastAssignedPoliceNode = address(HEAD);
1290 
1291   // maps each police node to the IDs of reports it should check
1292   mapping(address => LinkedListLib.LinkedList) internal assignedReports;
1293 
1294   // maps request IDs to the police nodes that are expected to check the report
1295   mapping(uint256 => LinkedListLib.LinkedList) internal assignedPolice;
1296 
1297   // maps each audit node to the IDs of reports that are pending police approval for payment
1298   mapping(address => LinkedListLib.LinkedList) internal pendingPayments;
1299 
1300   // maps request IDs to police timeouts
1301   mapping(uint256 => uint256) public policeTimeouts;
1302 
1303   // maps request IDs to reports submitted by police nodes
1304   mapping(uint256 => mapping(address => bytes)) public policeReports;
1305 
1306   // maps request IDs to the result reported by each police node
1307   mapping(uint256 => mapping(address => PoliceReportState)) public policeReportResults;
1308 
1309   // maps request IDs to whether they have been verified by the police
1310   mapping(uint256 => PoliceReportState) public verifiedReports;
1311 
1312   // maps request IDs to whether their reward has been claimed by the submitter
1313   mapping(uint256 => bool) public rewardHasBeenClaimed;
1314 
1315   // tracks the total number of reports ever assigned to a police node
1316   mapping(address => uint256) public totalReportsAssigned;
1317 
1318   // tracks the total number of reports ever checked by a police node
1319   mapping(address => uint256) public totalReportsChecked;
1320 
1321   // the collected fees for each report
1322   mapping(uint256 => uint256) public collectedFees;
1323 
1324   // contract that stores audit data (separate from the auditing logic)
1325   QuantstampAuditData public auditData;
1326 
1327   // contract that stores token escrows of nodes on the network
1328   QuantstampAuditTokenEscrow public tokenEscrow;
1329 
1330   /**
1331    * @dev The constructor creates a police contract.
1332    * @param auditDataAddress The address of an AuditData that stores data used for performing audits.
1333    * @param escrowAddress The address of a QuantstampTokenEscrow contract that holds staked deposits of nodes.
1334    */
1335   constructor (address auditDataAddress, address escrowAddress) public {
1336     require(auditDataAddress != address(0));
1337     require(escrowAddress != address(0));
1338     auditData = QuantstampAuditData(auditDataAddress);
1339     tokenEscrow = QuantstampAuditTokenEscrow(escrowAddress);
1340   }
1341 
1342   /**
1343    * @dev Assigns police nodes to a submitted report
1344    * @param requestId The ID of the audit request.
1345    */
1346   function assignPoliceToReport(uint256 requestId) public onlyWhitelisted {
1347     // ensure that the requestId has not already been assigned to police already
1348     require(policeTimeouts[requestId] == 0);
1349     // set the timeout for police reports
1350     policeTimeouts[requestId] = block.number + policeTimeoutInBlocks;
1351     // if there are not enough police nodes, this avoids assigning the same node twice
1352     uint256 numToAssign = policeNodesPerReport;
1353     if (numPoliceNodes < numToAssign) {
1354       numToAssign = numPoliceNodes;
1355     }
1356     while (numToAssign > 0) {
1357       lastAssignedPoliceNode = getNextPoliceNode(lastAssignedPoliceNode);
1358       if (lastAssignedPoliceNode != address(0)) {
1359         // push the request ID to the tail of the assignment list for the police node
1360         assignedReports[lastAssignedPoliceNode].push(requestId, PREV);
1361         // push the police node to the list of nodes assigned to check the report
1362         assignedPolice[requestId].push(uint256(lastAssignedPoliceNode), PREV);
1363         emit PoliceNodeAssignedToReport(lastAssignedPoliceNode, requestId);
1364         totalReportsAssigned[lastAssignedPoliceNode] = totalReportsAssigned[lastAssignedPoliceNode].add(1);
1365         numToAssign = numToAssign.sub(1);
1366       }
1367     }
1368   }
1369 
1370   /**
1371    * Cleans the list of assignments to police node (msg.sender), but checks only up to a limit
1372    * of assignments. If the limit is 0, attempts to clean the entire list.
1373    * @param policeNode The node whose assignments should be cleared.
1374    * @param limit The number of assigments to check.
1375    */
1376   function clearExpiredAssignments (address policeNode, uint256 limit) public {
1377     removeExpiredAssignments(policeNode, 0, limit);
1378   }
1379 
1380   /**
1381    * @dev Collects the police fee for checking a report.
1382    *      NOTE: this function assumes that the fee will be transferred by the calling contract.
1383    * @param requestId The ID of the audit request.
1384    * @return The amount collected.
1385    */
1386   function collectFee(uint256 requestId) public onlyWhitelisted returns (uint256) {
1387     uint256 policeFee = getPoliceFee(auditData.getAuditPrice(requestId));
1388     // the collected fee needs to be stored in a map since the owner could change the fee percentage
1389     collectedFees[requestId] = policeFee;
1390     emit PoliceFeesCollected(requestId, policeFee);
1391     return policeFee;
1392   }
1393 
1394   /**
1395    * @dev Split a payment, which may be for report checking or from slashing, amongst all police nodes
1396    * @param amount The amount to be split, which should have been transferred to this contract earlier.
1397    */
1398   function splitPayment(uint256 amount) public onlyWhitelisted {
1399     require(numPoliceNodes != 0);
1400     address policeNode = getNextPoliceNode(address(HEAD));
1401     uint256 amountPerNode = amount.div(numPoliceNodes);
1402     // TODO: upgrade our openzeppelin version to use mod
1403     uint256 largerAmount = amountPerNode.add(amount % numPoliceNodes);
1404     bool largerAmountClaimed = false;
1405     while (policeNode != address(HEAD)) {
1406       // give the largerAmount to the current lastAssignedPoliceNode if it is not equal to HEAD
1407       // this approach is only truly fair if numPoliceNodes and policeNodesPerReport are relatively prime
1408       // but the remainder should be extremely small in any case
1409       // the last conditional handles the edge case where all police nodes were removed and then re-added
1410       if (!largerAmountClaimed && (policeNode == lastAssignedPoliceNode || lastAssignedPoliceNode == address(HEAD))) {
1411         require(auditData.token().transfer(policeNode, largerAmount));
1412         emit PoliceFeesClaimed(policeNode, largerAmount);
1413         largerAmountClaimed = true;
1414       } else {
1415         require(auditData.token().transfer(policeNode, amountPerNode));
1416         emit PoliceFeesClaimed(policeNode, amountPerNode);
1417       }
1418       policeNode = getNextPoliceNode(address(policeNode));
1419     }
1420   }
1421 
1422   /**
1423    * @dev Associates a pending payment with an auditor that can be claimed after the policing period.
1424    * @param auditor The audit node that submitted the report.
1425    * @param requestId The ID of the audit request.
1426    */
1427   function addPendingPayment(address auditor, uint256 requestId) public onlyWhitelisted {
1428     pendingPayments[auditor].push(requestId, PREV);
1429   }
1430 
1431   /**
1432    * @dev Submits verification of a report by a police node.
1433    * @param policeNode The address of the police node.
1434    * @param auditNode The address of the audit node.
1435    * @param requestId The ID of the audit request.
1436    * @param report The compressed bytecode representation of the report.
1437    * @param isVerified Whether the police node's report matches the submitted report.
1438    *                   If not, the audit node is slashed.
1439    * @return two bools and a uint256: (true if the report was successfully submitted, true if a slash occurred, the slash amount).
1440    */
1441   function submitPoliceReport(
1442     address policeNode,
1443     address auditNode,
1444     uint256 requestId,
1445     bytes report,
1446     bool isVerified) public onlyWhitelisted returns (bool, bool, uint256) {
1447     // remove expired assignments
1448     bool hasRemovedCurrentId = removeExpiredAssignments(policeNode, requestId, 0);
1449     // if the current request has timed out, return
1450     if (hasRemovedCurrentId) {
1451       emit PoliceSubmissionPeriodExceeded(requestId, policeTimeouts[requestId], block.number);
1452       return (false, false, 0);
1453     }
1454     // the police node is assigned to the report
1455     require(isAssigned(requestId, policeNode));
1456 
1457     // remove the report from the assignments to the node
1458     assignedReports[policeNode].remove(requestId);
1459     // increment the number of reports checked by the police node
1460     totalReportsChecked[policeNode] = totalReportsChecked[policeNode] + 1;
1461     // store the report
1462     policeReports[requestId][policeNode] = report;
1463     // emit an event
1464     PoliceReportState state;
1465     if (isVerified) {
1466       state = PoliceReportState.VALID;
1467     } else {
1468       state = PoliceReportState.INVALID;
1469     }
1470     policeReportResults[requestId][policeNode] = state;
1471 
1472     // the report was already marked invalid by a different police node
1473     if (verifiedReports[requestId] == PoliceReportState.INVALID) {
1474       return (true, false, 0);
1475     } else {
1476       verifiedReports[requestId] = state;
1477     }
1478     bool slashOccurred;
1479     uint256 slashAmount;
1480     if (!isVerified) {
1481       pendingPayments[auditNode].remove(requestId);
1482       // an audit node can only be slashed once for each report,
1483       // even if multiple police mark the report as invalid
1484       slashAmount = tokenEscrow.slash(auditNode, slashPercentage);
1485       slashOccurred = true;
1486       emit PoliceSlash(requestId, policeNode, auditNode, slashAmount);
1487     }
1488     return (true, slashOccurred, slashAmount);
1489   }
1490 
1491   /**
1492    * @dev Determines whether an audit node is allowed by the police to claim an audit.
1493    * @param auditNode The address of the audit node.
1494    * @param requestId The ID of the requested audit.
1495    */
1496   function canClaimAuditReward (address auditNode, uint256 requestId) public view returns (bool) {
1497     // NOTE: can't use requires here, as claimNextReward needs to iterate the full list
1498     return
1499       // the report is in the pending payments list for the audit node
1500       pendingPayments[auditNode].nodeExists(requestId) &&
1501       // the policing period has ended for the report
1502       policeTimeouts[requestId] < block.number &&
1503       // the police did not invalidate the report
1504       verifiedReports[requestId] != PoliceReportState.INVALID &&
1505       // the reward has not already been claimed
1506       !rewardHasBeenClaimed[requestId] &&
1507       // the requestId is non-zero
1508       requestId > 0;
1509   }
1510 
1511   /**
1512    * @dev Given a requestId, returns the next pending available reward for the audit node.
1513    * @param auditNode The address of the audit node.
1514    * @param requestId The ID of the current linked list node
1515    * @return true if the next reward exists, and the corresponding requestId in the linked list
1516    */
1517   function getNextAvailableReward (address auditNode, uint256 requestId) public view returns (bool, uint256) {
1518     bool exists;
1519     (exists, requestId) = pendingPayments[auditNode].getAdjacent(requestId, NEXT);
1520     // NOTE: Do NOT short circuit this list based on timeouts.
1521     // The ordering may be broken if the owner changes the timeouts.
1522     while (exists && requestId != HEAD) {
1523       if (canClaimAuditReward(auditNode, requestId)) {
1524         return (true, requestId);
1525       }
1526       (exists, requestId) = pendingPayments[auditNode].getAdjacent(requestId, NEXT);
1527     }
1528     return (false, 0);
1529   }
1530 
1531   /**
1532    * @dev Sets the reward as claimed after checking that it can be claimed.
1533    *      This function also ensures double payment does not occur.
1534    * @param auditNode The address of the audit node.
1535    * @param requestId The ID of the requested audit.
1536    */
1537   function setRewardClaimed (address auditNode, uint256 requestId) public onlyWhitelisted returns (bool) {
1538     // set the reward to claimed, to avoid double payment
1539     rewardHasBeenClaimed[requestId] = true;
1540     pendingPayments[auditNode].remove(requestId);
1541     // if it is possible to claim yet the state is UNVERIFIED, mark EXPIRED
1542     if (verifiedReports[requestId] == PoliceReportState.UNVERIFIED) {
1543       verifiedReports[requestId] = PoliceReportState.EXPIRED;
1544     }
1545     return true;
1546   }
1547 
1548   /**
1549    * @dev Selects the next ID to be rewarded.
1550    * @param auditNode The address of the audit node.
1551    * @param requestId The previous claimed requestId (initially set to HEAD).
1552    * @return True if another reward exists, and the request ID.
1553    */
1554   function claimNextReward (address auditNode, uint256 requestId) public onlyWhitelisted returns (bool, uint256) {
1555     bool exists;
1556     (exists, requestId) = pendingPayments[auditNode].getAdjacent(requestId, NEXT);
1557     // NOTE: Do NOT short circuit this list based on timeouts.
1558     // The ordering may be broken if the owner changes the timeouts.
1559     while (exists && requestId != HEAD) {
1560       if (canClaimAuditReward(auditNode, requestId)) {
1561         setRewardClaimed(auditNode, requestId);
1562         return (true, requestId);
1563       }
1564       (exists, requestId) = pendingPayments[auditNode].getAdjacent(requestId, NEXT);
1565     }
1566     return (false, 0);
1567   }
1568 
1569   /**
1570    * @dev Gets the next assigned report to the police node.
1571    * @param policeNode The address of the police node.
1572    * @return true if the list is non-empty, requestId, auditPrice, uri, and policeAssignmentBlockNumber.
1573    */
1574   function getNextPoliceAssignment(address policeNode) public view returns (bool, uint256, uint256, string, uint256) {
1575     bool exists;
1576     uint256 requestId;
1577     (exists, requestId) = assignedReports[policeNode].getAdjacent(HEAD, NEXT);
1578     // if the head of the list is an expired assignment, try to find a current one
1579     while (exists && requestId != HEAD) {
1580       if (policeTimeouts[requestId] < block.number) {
1581         (exists, requestId) = assignedReports[policeNode].getAdjacent(requestId, NEXT);
1582       } else {
1583         uint256 price = auditData.getAuditPrice(requestId);
1584         string memory uri = auditData.getAuditContractUri(requestId);
1585         uint256 policeAssignmentBlockNumber = auditData.getAuditReportBlockNumber(requestId);
1586         return (exists, requestId, price, uri, policeAssignmentBlockNumber);
1587       }
1588     }
1589     return (false, 0, 0, "", 0);
1590   }
1591 
1592   /**
1593    * @dev Gets the next assigned police node to an audit request.
1594    * @param requestId The ID of the audit request.
1595    * @param policeNode The previous claimed requestId (initially set to HEAD).
1596    * @return true if the next police node exists, and the address of the police node.
1597    */
1598   function getNextAssignedPolice(uint256 requestId, address policeNode) public view returns (bool, address) {
1599     bool exists;
1600     uint256 nextPoliceNode;
1601     (exists, nextPoliceNode) = assignedPolice[requestId].getAdjacent(uint256(policeNode), NEXT);
1602     if (nextPoliceNode == HEAD) {
1603       return (false, address(0));
1604     }
1605     return (exists, address(nextPoliceNode));
1606   }
1607 
1608   /**
1609    * @dev Sets the number of police nodes that should check each report.
1610    * @param numPolice The number of police.
1611    */
1612   function setPoliceNodesPerReport(uint256 numPolice) public onlyOwner {
1613     policeNodesPerReport = numPolice;
1614   }
1615 
1616   /**
1617    * @dev Sets the police timeout.
1618    * @param numBlocks The number of blocks for the timeout.
1619    */
1620   function setPoliceTimeoutInBlocks(uint256 numBlocks) public onlyOwner {
1621     policeTimeoutInBlocks = numBlocks;
1622   }
1623 
1624   /**
1625    * @dev Sets the slash percentage.
1626    * @param percentage The percentage as an integer from [0-100].
1627    */
1628   function setSlashPercentage(uint256 percentage) public onlyOwner {
1629     require(0 <= percentage && percentage <= 100);
1630     slashPercentage = percentage;
1631   }
1632 
1633   /**
1634    * @dev Sets the report processing fee percentage.
1635    * @param percentage The percentage in the range of [0-100].
1636    */
1637   function setReportProcessingFeePercentage(uint256 percentage) public onlyOwner {
1638     require(percentage <= 100);
1639     reportProcessingFeePercentage = percentage;
1640   }
1641 
1642   /**
1643    * @dev Returns true if a node is whitelisted.
1644    * @param node The node to check.
1645    */
1646   function isPoliceNode(address node) public view returns (bool) {
1647     return policeList.nodeExists(uint256(node));
1648   }
1649 
1650   /**
1651    * @dev Adds an address to the police.
1652    * @param addr The address to be added.
1653    * @return true if the address was added to the whitelist.
1654    */
1655   function addPoliceNode(address addr) public onlyOwner returns (bool success) {
1656     if (policeList.insert(HEAD, uint256(addr), PREV)) {
1657       numPoliceNodes = numPoliceNodes.add(1);
1658       emit PoliceNodeAdded(addr);
1659       success = true;
1660     }
1661   }
1662 
1663   /**
1664    * @dev Removes an address from the whitelist linked-list.
1665    * @param addr The address to be removed.
1666    * @return true if the address was removed from the whitelist.
1667    */
1668   function removePoliceNode(address addr) public onlyOwner returns (bool success) {
1669     // if lastAssignedPoliceNode is addr, need to move the pointer
1670     bool exists;
1671     uint256 next;
1672     if (lastAssignedPoliceNode == addr) {
1673       (exists, next) = policeList.getAdjacent(uint256(addr), NEXT);
1674       lastAssignedPoliceNode = address(next);
1675     }
1676 
1677     if (policeList.remove(uint256(addr)) != NULL) {
1678       numPoliceNodes = numPoliceNodes.sub(1);
1679       emit PoliceNodeRemoved(addr);
1680       success = true;
1681     }
1682   }
1683 
1684   /**
1685    * @dev Given a whitelisted address, returns the next address from the whitelist.
1686    * @param addr The address in the whitelist.
1687    * @return The next address in the whitelist.
1688    */
1689   function getNextPoliceNode(address addr) public view returns (address) {
1690     bool exists;
1691     uint256 next;
1692     (exists, next) = policeList.getAdjacent(uint256(addr), NEXT);
1693     return address(next);
1694   }
1695 
1696   /**
1697    * @dev Returns the resulting state of a police report for a given audit request.
1698    * @param requestId The ID of the audit request.
1699    * @param policeAddr The address of the police node.
1700    * @return the PoliceReportState of the (requestId, policeNode) pair.
1701    */
1702   function getPoliceReportResult(uint256 requestId, address policeAddr) public view returns (PoliceReportState) {
1703     return policeReportResults[requestId][policeAddr];
1704   }
1705 
1706   function getPoliceReport(uint256 requestId, address policeAddr) public view returns (bytes) {
1707     return policeReports[requestId][policeAddr];
1708   }
1709 
1710   function getPoliceFee(uint256 auditPrice) public view returns (uint256) {
1711     return auditPrice.mul(reportProcessingFeePercentage).div(100);
1712   }
1713 
1714   function isAssigned(uint256 requestId, address policeAddr) public view returns (bool) {
1715     return assignedReports[policeAddr].nodeExists(requestId);
1716   }
1717 
1718   /**
1719    * Cleans the list of assignments to a given police node.
1720    * @param policeNode The address of the police node.
1721    * @param requestId The ID of the audit request.
1722    * @param limit The number of assigments to check. Use 0 if the entire list should be checked.
1723    * @return true if the current request ID gets removed during cleanup.
1724    */
1725   function removeExpiredAssignments (address policeNode, uint256 requestId, uint256 limit) internal returns (bool) {
1726     bool hasRemovedCurrentId = false;
1727     bool exists;
1728     uint256 potentialExpiredRequestId;
1729     uint256 nextExpiredRequestId;
1730     uint256 iterationsLeft = limit;
1731     (exists, nextExpiredRequestId) = assignedReports[policeNode].getAdjacent(HEAD, NEXT);
1732     // NOTE: Short circuiting this list may cause expired assignments to exist later in the list.
1733     //       The may occur if the owner changes the global police timeout.
1734     //       These expired assignments will be removed in subsequent calls.
1735     while (exists && nextExpiredRequestId != HEAD && (limit == 0 || iterationsLeft > 0)) {
1736       potentialExpiredRequestId = nextExpiredRequestId;
1737       (exists, nextExpiredRequestId) = assignedReports[policeNode].getAdjacent(nextExpiredRequestId, NEXT);
1738       if (policeTimeouts[potentialExpiredRequestId] < block.number) {
1739         assignedReports[policeNode].remove(potentialExpiredRequestId);
1740         emit PoliceAssignmentExpiredAndCleared(potentialExpiredRequestId);
1741         if (potentialExpiredRequestId == requestId) {
1742           hasRemovedCurrentId = true;
1743         }
1744       } else {
1745         break;
1746       }
1747       iterationsLeft -= 1;
1748     }
1749     return hasRemovedCurrentId;
1750   }
1751 }
1752 
1753 // File: contracts/QuantstampAuditReportData.sol
1754 
1755 contract QuantstampAuditReportData is Whitelist {
1756 
1757   // mapping from requestId to a report
1758   mapping(uint256 => bytes) public reports;
1759 
1760   function setReport(uint256 requestId, bytes report) external onlyWhitelisted {
1761     reports[requestId] = report;
1762   }
1763 
1764   function getReport(uint256 requestId) external view returns(bytes) {
1765     return reports[requestId];
1766   }
1767 
1768 }
1769 
1770 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
1771 
1772 /**
1773  * @title Pausable
1774  * @dev Base contract which allows children to implement an emergency stop mechanism.
1775  */
1776 contract Pausable is Ownable {
1777   event Pause();
1778   event Unpause();
1779 
1780   bool public paused = false;
1781 
1782 
1783   /**
1784    * @dev Modifier to make a function callable only when the contract is not paused.
1785    */
1786   modifier whenNotPaused() {
1787     require(!paused);
1788     _;
1789   }
1790 
1791   /**
1792    * @dev Modifier to make a function callable only when the contract is paused.
1793    */
1794   modifier whenPaused() {
1795     require(paused);
1796     _;
1797   }
1798 
1799   /**
1800    * @dev called by the owner to pause, triggers stopped state
1801    */
1802   function pause() onlyOwner whenNotPaused public {
1803     paused = true;
1804     emit Pause();
1805   }
1806 
1807   /**
1808    * @dev called by the owner to unpause, returns to normal state
1809    */
1810   function unpause() onlyOwner whenPaused public {
1811     paused = false;
1812     emit Unpause();
1813   }
1814 }
1815 
1816 // File: contracts/QuantstampAudit.sol
1817 
1818 contract QuantstampAudit is Pausable {
1819   using SafeMath for uint256;
1820   using LinkedListLib for LinkedListLib.LinkedList;
1821 
1822   // constants used by LinkedListLib
1823   uint256 constant internal NULL = 0;
1824   uint256 constant internal HEAD = 0;
1825   bool constant internal PREV = false;
1826   bool constant internal NEXT = true;
1827 
1828   // mapping from an audit node address to the number of requests that it currently processes
1829   mapping(address => uint256) public assignedRequestCount;
1830 
1831   // increasingly sorted linked list of prices
1832   LinkedListLib.LinkedList internal priceList;
1833   // map from price to a list of request IDs
1834   mapping(uint256 => LinkedListLib.LinkedList) internal auditsByPrice;
1835 
1836   // list of request IDs of assigned audits (the list preserves temporal order of assignments)
1837   LinkedListLib.LinkedList internal assignedAudits;
1838 
1839   // stores request ids of the most recently assigned audits for each audit node
1840   mapping(address => uint256) public mostRecentAssignedRequestIdsPerAuditor;
1841 
1842   // contract that stores audit data (separate from the auditing logic)
1843   QuantstampAuditData public auditData;
1844 
1845   // contract that stores audit reports on-chain
1846   QuantstampAuditReportData public reportData;
1847 
1848   // contract that handles policing
1849   QuantstampAuditPolice public police;
1850 
1851   // contract that stores token escrows of nodes on the network
1852   QuantstampAuditTokenEscrow public tokenEscrow;
1853 
1854   event LogAuditFinished(
1855     uint256 requestId,
1856     address auditor,
1857     QuantstampAuditData.AuditState auditResult,
1858     bytes report
1859   );
1860 
1861   event LogPoliceAuditFinished(
1862     uint256 requestId,
1863     address policeNode,
1864     bytes report,
1865     bool isVerified
1866   );
1867 
1868   event LogAuditRequested(uint256 requestId,
1869     address requestor,
1870     string uri,
1871     uint256 price
1872   );
1873 
1874   event LogAuditAssigned(uint256 requestId,
1875     address auditor,
1876     address requestor,
1877     string uri,
1878     uint256 price,
1879     uint256 requestBlockNumber);
1880 
1881   /* solhint-disable event-name-camelcase */
1882   event LogReportSubmissionError_InvalidAuditor(uint256 requestId, address auditor);
1883   event LogReportSubmissionError_InvalidState(uint256 requestId, address auditor, QuantstampAuditData.AuditState state);
1884   event LogReportSubmissionError_InvalidResult(uint256 requestId, address auditor, QuantstampAuditData.AuditState state);
1885   event LogReportSubmissionError_ExpiredAudit(uint256 requestId, address auditor, uint256 allowanceBlockNumber);
1886   event LogAuditAssignmentError_ExceededMaxAssignedRequests(address auditor);
1887   event LogAuditAssignmentError_Understaked(address auditor, uint256 stake);
1888   event LogAuditAssignmentUpdate_Expired(uint256 requestId, uint256 allowanceBlockNumber);
1889   event LogClaimRewardsReachedGasLimit(address auditor);
1890 
1891   /* solhint-enable event-name-camelcase */
1892 
1893   event LogAuditQueueIsEmpty();
1894 
1895   event LogPayAuditor(uint256 requestId, address auditor, uint256 amount);
1896   event LogAuditNodePriceChanged(address auditor, uint256 amount);
1897 
1898   event LogRefund(uint256 requestId, address requestor, uint256 amount);
1899   event LogRefundInvalidRequestor(uint256 requestId, address requestor);
1900   event LogRefundInvalidState(uint256 requestId, QuantstampAuditData.AuditState state);
1901   event LogRefundInvalidFundsLocked(uint256 requestId, uint256 currentBlock, uint256 fundLockEndBlock);
1902 
1903   // the audit queue has elements, but none satisfy the minPrice of the audit node
1904   // amount corresponds to the current minPrice of the audit node
1905   event LogAuditNodePriceHigherThanRequests(address auditor, uint256 amount);
1906 
1907   event LogInvalidResolutionCall(uint256 requestId);
1908   event LogErrorReportResolved(uint256 requestId, address receiver, uint256 auditPrice);
1909 
1910   enum AuditAvailabilityState {
1911     Error,
1912     Ready,      // an audit is available to be picked up
1913     Empty,      // there is no audit request in the queue
1914     Exceeded,   // number of incomplete audit requests is reached the cap
1915     Underpriced, // all queued audit requests are less than the expected price
1916     Understaked // the audit node's stake is not large enough to request its min price
1917   }
1918 
1919   /**
1920    * @dev The constructor creates an audit contract.
1921    * @param auditDataAddress The address of an AuditData that stores data used for performing audits.
1922    * @param reportDataAddress The address of a ReportData that stores audit reports.
1923    * @param escrowAddress The address of a QuantstampTokenEscrow contract that holds staked deposits of nodes.
1924    * @param policeAddress The address of a QuantstampAuditPolice that performs report checking.
1925    */
1926   constructor (address auditDataAddress, address reportDataAddress, address escrowAddress, address policeAddress) public {
1927     require(auditDataAddress != address(0));
1928     require(reportDataAddress != address(0));
1929     require(escrowAddress != address(0));
1930     require(policeAddress != address(0));
1931     auditData = QuantstampAuditData(auditDataAddress);
1932     reportData = QuantstampAuditReportData(reportDataAddress);
1933     tokenEscrow = QuantstampAuditTokenEscrow(escrowAddress);
1934     police = QuantstampAuditPolice(policeAddress);
1935   }
1936 
1937   /**
1938    * @dev Allows nodes to stake a deposit. The audit node must approve QuantstampAudit before invoking.
1939    * @param amount The amount of wei-QSP to deposit.
1940    */
1941   function stake(uint256 amount) external returns(bool) {
1942     // first acquire the tokens approved by the audit node
1943     require(auditData.token().transferFrom(msg.sender, address(this), amount));
1944     // use those tokens to approve a transfer in the escrow
1945     auditData.token().approve(address(tokenEscrow), amount);
1946     // a "Deposited" event is emitted in TokenEscrow
1947     tokenEscrow.deposit(msg.sender, amount);
1948     return true;
1949   }
1950 
1951   /**
1952    * @dev Allows audit nodes to retrieve a deposit.
1953    */
1954   function unstake() external returns(bool) {
1955     // the escrow contract ensures that the deposit is not currently locked
1956     tokenEscrow.withdraw(msg.sender);
1957     return true;
1958   }
1959 
1960   /**
1961    * @dev Returns funds to the requestor.
1962    * @param requestId Unique ID of the audit request.
1963    */
1964   function refund(uint256 requestId) external returns(bool) {
1965     QuantstampAuditData.AuditState state = auditData.getAuditState(requestId);
1966     // check that the audit exists and is in a valid state
1967     if (state != QuantstampAuditData.AuditState.Queued &&
1968           state != QuantstampAuditData.AuditState.Assigned &&
1969             state != QuantstampAuditData.AuditState.Expired) {
1970       emit LogRefundInvalidState(requestId, state);
1971       return false;
1972     }
1973     address requestor = auditData.getAuditRequestor(requestId);
1974     if (requestor != msg.sender) {
1975       emit LogRefundInvalidRequestor(requestId, msg.sender);
1976       return;
1977     }
1978     uint256 refundBlockNumber = auditData.getAuditAssignBlockNumber(requestId).add(auditData.auditTimeoutInBlocks());
1979     // check that the audit node has not recently started the audit (locking the funds)
1980     if (state == QuantstampAuditData.AuditState.Assigned) {
1981       if (block.number <= refundBlockNumber) {
1982         emit LogRefundInvalidFundsLocked(requestId, block.number, refundBlockNumber);
1983         return false;
1984       }
1985       // the request is expired but not detected by getNextAuditRequest
1986       updateAssignedAudits(requestId);
1987     } else if (state == QuantstampAuditData.AuditState.Queued) {
1988       // remove the request from the queue
1989       // note that if an audit node is currently assigned the request, it is already removed from the queue
1990       removeQueueElement(requestId);
1991     }
1992 
1993     // set the audit state to refunded
1994     auditData.setAuditState(requestId, QuantstampAuditData.AuditState.Refunded);
1995 
1996     // return the funds to the requestor
1997     uint256 price = auditData.getAuditPrice(requestId);
1998     emit LogRefund(requestId, requestor, price);
1999     safeTransferFromDataContract(requestor, price);
2000     return true;
2001   }
2002 
2003   /**
2004    * @dev Submits audit request.
2005    * @param contractUri Identifier of the resource to audit.
2006    * @param price The total amount of tokens that will be paid for the audit.
2007    */
2008   function requestAudit(string contractUri, uint256 price) public returns(uint256) {
2009     // it passes HEAD as the existing price, therefore may result in extra gas needed for list iteration
2010     return requestAuditWithPriceHint(contractUri, price, HEAD);
2011   }
2012 
2013   /**
2014    * @dev Submits audit request.
2015    * @param contractUri Identifier of the resource to audit.
2016    * @param price The total amount of tokens that will be paid for the audit.
2017    * @param existingPrice Existing price in the list (price hint allows for optimization that can make insertion O(1)).
2018    */
2019   function requestAuditWithPriceHint(string contractUri, uint256 price, uint256 existingPrice) public whenNotPaused returns(uint256) {
2020     require(price > 0);
2021     // transfer tokens to the data contract
2022     require(auditData.token().transferFrom(msg.sender, address(auditData), price));
2023     // store the audit
2024     uint256 requestId = auditData.addAuditRequest(msg.sender, contractUri, price);
2025 
2026     queueAuditRequest(requestId, existingPrice);
2027 
2028     emit LogAuditRequested(requestId, msg.sender, contractUri, price); // solhint-disable-line not-rely-on-time
2029 
2030     return requestId;
2031   }
2032 
2033   /**
2034    * @dev Submits the report and pays the audit node for their work if the audit is completed.
2035    * @param requestId Unique identifier of the audit request.
2036    * @param auditResult Result of an audit.
2037    * @param report a compressed report. TODO, let's document the report format.
2038    */
2039   function submitReport(uint256 requestId, QuantstampAuditData.AuditState auditResult, bytes report) public { // solhint-disable-line function-max-lines
2040     if (QuantstampAuditData.AuditState.Completed != auditResult && QuantstampAuditData.AuditState.Error != auditResult) {
2041       emit LogReportSubmissionError_InvalidResult(requestId, msg.sender, auditResult);
2042       return;
2043     }
2044 
2045     QuantstampAuditData.AuditState auditState = auditData.getAuditState(requestId);
2046     if (auditState != QuantstampAuditData.AuditState.Assigned) {
2047       emit LogReportSubmissionError_InvalidState(requestId, msg.sender, auditState);
2048       return;
2049     }
2050 
2051     // the sender must be the audit node
2052     if (msg.sender != auditData.getAuditAuditor(requestId)) {
2053       emit LogReportSubmissionError_InvalidAuditor(requestId, msg.sender);
2054       return;
2055     }
2056 
2057     // remove the requestId from assigned queue
2058     updateAssignedAudits(requestId);
2059 
2060     // the audit node should not send a report after its allowed period
2061     uint256 allowanceBlockNumber = auditData.getAuditAssignBlockNumber(requestId) + auditData.auditTimeoutInBlocks();
2062     if (allowanceBlockNumber < block.number) {
2063       // update assigned to expired state
2064       auditData.setAuditState(requestId, QuantstampAuditData.AuditState.Expired);
2065       emit LogReportSubmissionError_ExpiredAudit(requestId, msg.sender, allowanceBlockNumber);
2066       return;
2067     }
2068 
2069     // update the audit information held in this contract
2070     auditData.setAuditState(requestId, auditResult);
2071     auditData.setAuditReportBlockNumber(requestId, block.number); // solhint-disable-line not-rely-on-time
2072 
2073     // validate the audit state
2074     require(isAuditFinished(requestId));
2075 
2076     // store reports on-chain
2077     reportData.setReport(requestId, report);
2078 
2079     emit LogAuditFinished(requestId, msg.sender, auditResult, report);
2080 
2081     if (auditResult == QuantstampAuditData.AuditState.Completed) {
2082       // alert the police to verify the report
2083       police.assignPoliceToReport(requestId);
2084       // add the requestId to the pending payments that should be paid to the audit node after policing
2085       police.addPendingPayment(msg.sender, requestId);
2086       // pay fee to the police
2087       if (police.reportProcessingFeePercentage() > 0 && police.numPoliceNodes() > 0) {
2088         uint256 policeFee = police.collectFee(requestId);
2089         safeTransferFromDataContract(address(police), policeFee);
2090         police.splitPayment(policeFee);
2091       }
2092     }
2093   }
2094 
2095   /**
2096    * @dev Returns the compressed report submitted by the audit node.
2097    * @param requestId The ID of the audit request.
2098    */
2099   function getReport(uint256 requestId) public view returns (bytes) {
2100     return reportData.getReport(requestId);
2101   }
2102 
2103   /**
2104    * @dev Checks whether a given node is a police.
2105    * @param node The address of the node to be checked.
2106    * @return true if the target address is a police node.
2107    */
2108   function isPoliceNode(address node) public view returns(bool) {
2109     return police.isPoliceNode(node);
2110   }
2111 
2112   /**
2113    * @dev Submits verification of a report by a police node.
2114    * @param requestId The ID of the audit request.
2115    * @param report The compressed bytecode representation of the report.
2116    * @param isVerified Whether the police node's report matches the submitted report.
2117    *                   If not, the audit node is slashed.
2118    * @return true if the report was submitted successfully.
2119    */
2120   function submitPoliceReport(
2121     uint256 requestId,
2122     bytes report,
2123     bool isVerified) public returns (bool) {
2124     require(police.isPoliceNode(msg.sender));
2125     // get the address of the audit node
2126     address auditNode = auditData.getAuditAuditor(requestId);
2127     bool hasBeenSubmitted;
2128     bool slashOccurred;
2129     uint256 slashAmount;
2130     // hasBeenSubmitted may be false if the police submission period has ended
2131     (hasBeenSubmitted, slashOccurred, slashAmount) = police.submitPoliceReport(msg.sender, auditNode, requestId, report, isVerified);
2132     if (hasBeenSubmitted) {
2133       emit LogPoliceAuditFinished(requestId, msg.sender, report, isVerified);
2134     }
2135     if (slashOccurred) {
2136       // transfer the audit request price to the police
2137       uint256 auditPoliceFee = police.collectedFees(requestId);
2138       uint256 adjustedPrice = auditData.getAuditPrice(requestId).sub(auditPoliceFee);
2139       safeTransferFromDataContract(address(police), adjustedPrice);
2140 
2141       // divide the adjusted price + slash among police assigned to report
2142       police.splitPayment(adjustedPrice.add(slashAmount));
2143     }
2144     return hasBeenSubmitted;
2145   }
2146 
2147   /**
2148    * @dev Determines whether the address (of an audit node) can claim any audit rewards.
2149    */
2150   function hasAvailableRewards () public view returns (bool) {
2151     bool exists;
2152     uint256 next;
2153     (exists, next) = police.getNextAvailableReward(msg.sender, HEAD);
2154     return exists;
2155   }
2156 
2157   /**
2158    * @dev Given a requestId, returns the next pending available reward for the audit node.
2159    *      This can be used in conjunction with claimReward() if claimRewards fails due to gas limits.
2160    * @param requestId The ID of the current linked list node
2161    * @return true if the next reward exists, and the corresponding requestId in the linked list
2162    */
2163   function getNextAvailableReward (uint256 requestId) public view returns(bool, uint256) {
2164     return police.getNextAvailableReward(msg.sender, requestId);
2165   }
2166 
2167   /**
2168    * @dev If the policing period has ended without the report being marked invalid,
2169    *      allow the audit node to claim the audit's reward.
2170    * @param requestId The ID of the audit request.
2171    * NOTE: We need this function if claimRewards always fails due to gas limits.
2172    *       I think this can only happen if the audit node receives many (i.e., hundreds) of audits,
2173    *       and never calls claimRewards() until much later.
2174    */
2175   function claimReward (uint256 requestId) public returns (bool) {
2176     require(police.canClaimAuditReward(msg.sender, requestId));
2177     police.setRewardClaimed(msg.sender, requestId);
2178     transferReward(requestId);
2179     return true;
2180   }
2181 
2182   /**
2183    * @dev Claim all pending rewards for the audit node.
2184    * @return Returns true if the operation ran to completion, or false if the loop exits due to gas limits.
2185    */
2186   function claimRewards () public returns (bool) {
2187     // Yet another list iteration. Could ignore this check, but makes testing painful.
2188     require(hasAvailableRewards());
2189     bool exists;
2190     uint256 requestId = HEAD;
2191     uint256 remainingGasBeforeCall;
2192     uint256 remainingGasAfterCall;
2193     bool loopExitedDueToGasLimit;
2194     // This loop occurs here (not in QuantstampAuditPolice) due to requiring the audit price,
2195     // as otherwise we require more dependencies/mappings in QuantstampAuditPolice.
2196     while (true) {
2197       remainingGasBeforeCall = gasleft();
2198       (exists, requestId) = police.claimNextReward(msg.sender, HEAD);
2199       if (!exists) {
2200         break;
2201       }
2202       transferReward(requestId);
2203       remainingGasAfterCall = gasleft();
2204       // multiplying by 2 to leave a bit of extra leeway, particularly due to the while-loop in claimNextReward
2205       if (remainingGasAfterCall < remainingGasBeforeCall.sub(remainingGasAfterCall).mul(2)) {
2206         loopExitedDueToGasLimit = true;
2207         emit LogClaimRewardsReachedGasLimit(msg.sender);
2208         break;
2209       }
2210     }
2211     return loopExitedDueToGasLimit;
2212   }
2213 
2214   /**
2215    * @dev Determines who has to be paid for a given requestId recorded with an error status.
2216    * @param requestId Unique identifier of the audit request.
2217    * @param toRequester The audit price goes to the requester or the audit node.
2218    */
2219   function resolveErrorReport(uint256 requestId, bool toRequester) public onlyOwner {
2220     QuantstampAuditData.AuditState auditState = auditData.getAuditState(requestId);
2221     if (auditState != QuantstampAuditData.AuditState.Error) {
2222       emit LogInvalidResolutionCall(requestId);
2223       return;
2224     }
2225 
2226     uint256 auditPrice = auditData.getAuditPrice(requestId);
2227     address receiver = toRequester ? auditData.getAuditRequestor(requestId) : auditData.getAuditAuditor(requestId);
2228     auditData.setAuditState(requestId, QuantstampAuditData.AuditState.Resolved);
2229     safeTransferFromDataContract(receiver, auditPrice);
2230     emit LogErrorReportResolved(requestId, receiver, auditPrice);
2231   }
2232 
2233   /**
2234    * @dev Returns the total stake deposited by an address.
2235    * @param addr The address to check.
2236    */
2237   function totalStakedFor(address addr) public view returns(uint256) {
2238     return tokenEscrow.depositsOf(addr);
2239   }
2240 
2241   /**
2242    * @dev Returns true if the sender staked enough.
2243    * @param addr The address to check.
2244    */
2245   function hasEnoughStake(address addr) public view returns(bool) {
2246     return tokenEscrow.hasEnoughStake(addr);
2247   }
2248 
2249   /**
2250    * @dev Returns the minimum stake required to be an audit node.
2251    */
2252   function getMinAuditStake() public view returns(uint256) {
2253     return tokenEscrow.minAuditStake();
2254   }
2255 
2256   /**
2257    *  @dev Returns the timeout time (in blocks) for any given audit.
2258    */
2259   function getAuditTimeoutInBlocks() public view returns(uint256) {
2260     return auditData.auditTimeoutInBlocks();
2261   }
2262 
2263   /**
2264    *  @dev Returns the minimum price for a specific audit node.
2265    */
2266   function getMinAuditPrice (address auditor) public view returns(uint256) {
2267     return auditData.getMinAuditPrice(auditor);
2268   }
2269 
2270   /**
2271    * @dev Returns the maximum number of assigned audits for any given audit node.
2272    */
2273   function getMaxAssignedRequests() public view returns(uint256) {
2274     return auditData.maxAssignedRequests();
2275   }
2276 
2277   /**
2278    * @dev Determines if there is an audit request available to be picked up by the caller.
2279    */
2280   function anyRequestAvailable() public view returns(AuditAvailabilityState) {
2281     uint256 requestId;
2282 
2283     // there are no audits in the queue
2284     if (!auditQueueExists()) {
2285       return AuditAvailabilityState.Empty;
2286     }
2287 
2288     // check if the audit node's assignment count is not exceeded
2289     if (assignedRequestCount[msg.sender] >= auditData.maxAssignedRequests()) {
2290       return AuditAvailabilityState.Exceeded;
2291     }
2292 
2293     // check that the audit node's stake is large enough
2294     if (!hasEnoughStake(msg.sender)) {
2295       return AuditAvailabilityState.Understaked;
2296     }
2297 
2298     requestId = anyAuditRequestMatchesPrice(auditData.getMinAuditPrice(msg.sender));
2299     if (requestId == 0) {
2300       return AuditAvailabilityState.Underpriced;
2301     }
2302     return AuditAvailabilityState.Ready;
2303   }
2304 
2305   /**
2306    * @dev Returns the next assigned report in a police node's assignment queue.
2307    * @return true if the list is non-empty, requestId, auditPrice, uri, and policeAssignmentBlockNumber.
2308    */
2309   function getNextPoliceAssignment() public view returns (bool, uint256, uint256, string, uint256) {
2310     return police.getNextPoliceAssignment(msg.sender);
2311   }
2312 
2313   /**
2314    * @dev Finds a list of most expensive audits and assigns the oldest one to the audit node.
2315    */
2316   /* solhint-disable function-max-lines */
2317   function getNextAuditRequest() public {
2318     // remove an expired audit request
2319     if (assignedAudits.listExists()) {
2320       bool exists;
2321       uint256 potentialExpiredRequestId;
2322       (exists, potentialExpiredRequestId) = assignedAudits.getAdjacent(HEAD, NEXT);
2323       uint256 allowanceBlockNumber = auditData.getAuditAssignBlockNumber(potentialExpiredRequestId) + auditData.auditTimeoutInBlocks();
2324       if (allowanceBlockNumber < block.number) {
2325         updateAssignedAudits(potentialExpiredRequestId);
2326         auditData.setAuditState(potentialExpiredRequestId, QuantstampAuditData.AuditState.Expired);
2327         emit LogAuditAssignmentUpdate_Expired(potentialExpiredRequestId, allowanceBlockNumber);
2328       }
2329     }
2330 
2331     AuditAvailabilityState isRequestAvailable = anyRequestAvailable();
2332     // there are no audits in the queue
2333     if (isRequestAvailable == AuditAvailabilityState.Empty) {
2334       emit LogAuditQueueIsEmpty();
2335       return;
2336     }
2337 
2338     // check if the audit node's assignment is not exceeded
2339     if (isRequestAvailable == AuditAvailabilityState.Exceeded) {
2340       emit LogAuditAssignmentError_ExceededMaxAssignedRequests(msg.sender);
2341       return;
2342     }
2343 
2344     uint256 minPrice = auditData.getMinAuditPrice(msg.sender);
2345 
2346     // check that the audit node has staked enough QSP
2347     if (isRequestAvailable == AuditAvailabilityState.Understaked) {
2348       emit LogAuditAssignmentError_Understaked(msg.sender, totalStakedFor(msg.sender));
2349       return;
2350     }
2351 
2352     // there are no audits in the queue with a price high enough for the audit node
2353     uint256 requestId = dequeueAuditRequest(minPrice);
2354     if (requestId == 0) {
2355       emit LogAuditNodePriceHigherThanRequests(msg.sender, minPrice);
2356       return;
2357     }
2358 
2359     auditData.setAuditState(requestId, QuantstampAuditData.AuditState.Assigned);
2360     auditData.setAuditAuditor(requestId, msg.sender);
2361     auditData.setAuditAssignBlockNumber(requestId, block.number);
2362     assignedRequestCount[msg.sender]++;
2363     // push to the tail
2364     assignedAudits.push(requestId, PREV);
2365 
2366     // lock stake when assigned
2367     tokenEscrow.lockFunds(msg.sender, block.number.add(auditData.auditTimeoutInBlocks()).add(police.policeTimeoutInBlocks()));
2368 
2369     mostRecentAssignedRequestIdsPerAuditor[msg.sender] = requestId;
2370     emit LogAuditAssigned(requestId,
2371       auditData.getAuditAuditor(requestId),
2372       auditData.getAuditRequestor(requestId),
2373       auditData.getAuditContractUri(requestId),
2374       auditData.getAuditPrice(requestId),
2375       auditData.getAuditRequestBlockNumber(requestId));
2376   }
2377   /* solhint-enable function-max-lines */
2378 
2379   /**
2380    * @dev Allows the audit node to set its minimum price per audit in wei-QSP.
2381    * @param price The minimum price.
2382    */
2383   function setAuditNodePrice(uint256 price) public {
2384     auditData.setMinAuditPrice(msg.sender, price);
2385     emit LogAuditNodePriceChanged(msg.sender, price);
2386   }
2387 
2388   /**
2389    * @dev Checks if an audit is finished. It is considered finished when the audit is either completed or failed.
2390    * @param requestId Unique ID of the audit request.
2391    */
2392   function isAuditFinished(uint256 requestId) public view returns(bool) {
2393     QuantstampAuditData.AuditState state = auditData.getAuditState(requestId);
2394     return state == QuantstampAuditData.AuditState.Completed || state == QuantstampAuditData.AuditState.Error;
2395   }
2396 
2397   /**
2398    * @dev Given a price, returns the next price from the priceList.
2399    * @param price A price indicated by a node in priceList.
2400    * @return The next price in the linked list.
2401    */
2402   function getNextPrice(uint256 price) public view returns(uint256) {
2403     bool exists;
2404     uint256 next;
2405     (exists, next) = priceList.getAdjacent(price, NEXT);
2406     return next;
2407   }
2408 
2409   /**
2410    * @dev Given a requestId, returns the next one from assignedAudits.
2411    * @param requestId The ID of the current linked list node
2412    * @return next requestId in the linked list
2413    */
2414   function getNextAssignedRequest(uint256 requestId) public view returns(uint256) {
2415     bool exists;
2416     uint256 next;
2417     (exists, next) = assignedAudits.getAdjacent(requestId, NEXT);
2418     return next;
2419   }
2420 
2421   /**
2422    * @dev Returns the audit request most recently assigned to msg.sender.
2423    * @return A tuple (requestId, audit_uri, audit_price, request_block_number).
2424    */
2425   function myMostRecentAssignedAudit() public view returns(
2426     uint256, // requestId
2427     address, // requestor
2428     string,  // contract uri
2429     uint256, // price
2430     uint256  // request block number
2431   ) {
2432     uint256 requestId = mostRecentAssignedRequestIdsPerAuditor[msg.sender];
2433     return (
2434       requestId,
2435       auditData.getAuditRequestor(requestId),
2436       auditData.getAuditContractUri(requestId),
2437       auditData.getAuditPrice(requestId),
2438       auditData.getAuditRequestBlockNumber(requestId)
2439     );
2440   }
2441 
2442   /**
2443    * @dev Given a price and a requestId, the function returns the next requestId with the same price.
2444    * Return 0, provided the given price does not exist in auditsByPrice.
2445    * @param price The price value of the current bucket.
2446    * @param requestId Unique Id of a requested audit.
2447    * @return The next requestId with the same price.
2448    */
2449   function getNextAuditByPrice(uint256 price, uint256 requestId) public view returns(uint256) {
2450     bool exists;
2451     uint256 next;
2452     (exists, next) = auditsByPrice[price].getAdjacent(requestId, NEXT);
2453     return next;
2454   }
2455 
2456   /**
2457    * @dev Given a price finds where it should be placed to build a sorted list.
2458    * @return next First existing price higher than the passed price.
2459    */
2460   function findPrecedingPrice(uint256 price) public view returns(uint256) {
2461     return priceList.getSortedSpot(HEAD, price, NEXT);
2462   }
2463 
2464   /**
2465    * @dev Given a requestId, the function removes it from the list of audits and decreases the number of assigned
2466    * audits of the associated audit node.
2467    * @param requestId Unique ID of a requested audit.
2468    */
2469   function updateAssignedAudits(uint256 requestId) internal {
2470     assignedAudits.remove(requestId);
2471     assignedRequestCount[auditData.getAuditAuditor(requestId)] =
2472       assignedRequestCount[auditData.getAuditAuditor(requestId)].sub(1);
2473   }
2474 
2475   /**
2476    * @dev Checks if the list of audits has any elements.
2477    */
2478   function auditQueueExists() internal view returns(bool) {
2479     return priceList.listExists();
2480   }
2481 
2482   /**
2483    * @dev Adds an audit request to the queue.
2484    * @param requestId Request ID.
2485    * @param existingPrice The price of an existing audit in the queue (makes insertion O(1)).
2486    */
2487   function queueAuditRequest(uint256 requestId, uint256 existingPrice) internal {
2488     uint256 price = auditData.getAuditPrice(requestId);
2489     if (!priceList.nodeExists(price)) {
2490       uint256 priceHint = priceList.nodeExists(existingPrice) ? existingPrice : HEAD;
2491       // if a price bucket doesn't exist, create it next to an existing one
2492       priceList.insert(priceList.getSortedSpot(priceHint, price, NEXT), price, PREV);
2493     }
2494     // push to the tail
2495     auditsByPrice[price].push(requestId, PREV);
2496   }
2497 
2498   /**
2499    * @dev Evaluates if there is an audit price >= minPrice.
2500    * Note that there should not be any audit with price as 0.
2501    * @param minPrice The minimum audit price.
2502    * @return The requestId of an audit adhering to the minPrice, or 0 if no such audit exists.
2503    */
2504   function anyAuditRequestMatchesPrice(uint256 minPrice) internal view returns(uint256) {
2505     bool priceExists;
2506     uint256 price;
2507     uint256 requestId;
2508 
2509     // picks the tail of price buckets
2510     (priceExists, price) = priceList.getAdjacent(HEAD, PREV);
2511     if (price < minPrice) {
2512       return 0;
2513     }
2514     requestId = getNextAuditByPrice(price, HEAD);
2515     return requestId;
2516   }
2517 
2518   /**
2519    * @dev Finds a list of most expensive audits and returns the oldest one that has a price >= minPrice.
2520    * @param minPrice The minimum audit price.
2521    */
2522   function dequeueAuditRequest(uint256 minPrice) internal returns(uint256) {
2523 
2524     uint256 requestId;
2525     uint256 price;
2526 
2527     // picks the tail of price buckets
2528     // TODO seems the following statement is redundantly called from getNextAuditRequest. If this is the only place
2529     // to call dequeueAuditRequest, then removing the following line saves gas, but leaves dequeueAuditRequest
2530     // unsafe for further extension.
2531     requestId = anyAuditRequestMatchesPrice(minPrice);
2532 
2533     if (requestId > 0) {
2534       price = auditData.getAuditPrice(requestId);
2535       auditsByPrice[price].remove(requestId);
2536       // removes the price bucket if it contains no requests
2537       if (!auditsByPrice[price].listExists()) {
2538         priceList.remove(price);
2539       }
2540       return requestId;
2541     }
2542     return 0;
2543   }
2544 
2545   /**
2546    * @dev Removes an element from the list.
2547    * @param requestId The Id of the request to be removed.
2548    */
2549   function removeQueueElement(uint256 requestId) internal {
2550     uint256 price = auditData.getAuditPrice(requestId);
2551 
2552     // the node must exist in the list
2553     require(priceList.nodeExists(price));
2554     require(auditsByPrice[price].nodeExists(requestId));
2555 
2556     auditsByPrice[price].remove(requestId);
2557     if (!auditsByPrice[price].listExists()) {
2558       priceList.remove(price);
2559     }
2560   }
2561 
2562   /**
2563    * @dev Internal helper function to perform the transfer of rewards.
2564    * @param requestId The ID of the audit request.
2565    */
2566   function transferReward (uint256 requestId) internal {
2567     uint256 auditPoliceFee = police.collectedFees(requestId);
2568     uint256 auditorPayment = auditData.getAuditPrice(requestId).sub(auditPoliceFee);
2569     safeTransferFromDataContract(msg.sender, auditorPayment);
2570     emit LogPayAuditor(requestId, msg.sender, auditorPayment);
2571   }
2572 
2573   /**
2574    * @dev Used to transfer funds stored in the data contract to a given address.
2575    * @param _to The address to transfer funds.
2576    * @param amount The number of wei-QSP to be transferred.
2577    */
2578   function safeTransferFromDataContract(address _to, uint256 amount) internal {
2579     auditData.approveWhitelisted(amount);
2580     require(auditData.token().transferFrom(address(auditData), _to, amount));
2581   }
2582 }