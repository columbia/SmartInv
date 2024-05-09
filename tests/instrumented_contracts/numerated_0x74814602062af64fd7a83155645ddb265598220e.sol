1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
117 
118 /**
119  * @title Pausable
120  * @dev Base contract which allows children to implement an emergency stop mechanism.
121  */
122 contract Pausable is Ownable {
123   event Pause();
124   event Unpause();
125 
126   bool public paused = false;
127 
128 
129   /**
130    * @dev Modifier to make a function callable only when the contract is not paused.
131    */
132   modifier whenNotPaused() {
133     require(!paused);
134     _;
135   }
136 
137   /**
138    * @dev Modifier to make a function callable only when the contract is paused.
139    */
140   modifier whenPaused() {
141     require(paused);
142     _;
143   }
144 
145   /**
146    * @dev called by the owner to pause, triggers stopped state
147    */
148   function pause() onlyOwner whenNotPaused public {
149     paused = true;
150     emit Pause();
151   }
152 
153   /**
154    * @dev called by the owner to unpause, returns to normal state
155    */
156   function unpause() onlyOwner whenPaused public {
157     paused = false;
158     emit Unpause();
159   }
160 }
161 
162 // File: contracts/LinkedListLib.sol
163 
164 /**
165  * @title LinkedListLib
166  * @author Darryl Morris (o0ragman0o) and Modular.network
167  *
168  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
169  * into the Modular-Network ethereum-libraries repo at https://github.com/Modular-Network/ethereum-libraries
170  * It has been updated to add additional functionality and be more compatible with solidity 0.4.18
171  * coding patterns.
172  *
173  * version 1.1.1
174  * Copyright (c) 2017 Modular Inc.
175  * The MIT License (MIT)
176  * https://github.com/Modular-network/ethereum-libraries/blob/master/LICENSE
177  *
178  * The LinkedListLib provides functionality for implementing data indexing using
179  * a circlular linked list
180  *
181  * Modular provides smart contract services and security reviews for contract
182  * deployments in addition to working on open source projects in the Ethereum
183  * community. Our purpose is to test, document, and deploy reusable code onto the
184  * blockchain and improve both security and usability. We also educate non-profits,
185  * schools, and other community members about the application of blockchain
186  * technology. For further information: modular.network
187  *
188  *
189  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
190  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
191  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
192  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
193  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
194  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
195  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
196 */
197 
198 
199 library LinkedListLib {
200 
201     uint256 constant NULL = 0;
202     uint256 constant HEAD = 0;
203     bool constant PREV = false;
204     bool constant NEXT = true;
205 
206     struct LinkedList{
207         mapping (uint256 => mapping (bool => uint256)) list;
208     }
209 
210     /// @dev returns true if the list exists
211     /// @param self stored linked list from contract
212     function listExists(LinkedList storage self)
213         public
214         view returns (bool)
215     {
216         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
217         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
218             return true;
219         } else {
220             return false;
221         }
222     }
223 
224     /// @dev returns true if the node exists
225     /// @param self stored linked list from contract
226     /// @param _node a node to search for
227     function nodeExists(LinkedList storage self, uint256 _node)
228         public
229         view returns (bool)
230     {
231         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
232             if (self.list[HEAD][NEXT] == _node) {
233                 return true;
234             } else {
235                 return false;
236             }
237         } else {
238             return true;
239         }
240     }
241 
242     /// @dev Returns the number of elements in the list
243     /// @param self stored linked list from contract
244     function sizeOf(LinkedList storage self) public view returns (uint256 numElements) {
245         bool exists;
246         uint256 i;
247         (exists,i) = getAdjacent(self, HEAD, NEXT);
248         while (i != HEAD) {
249             (exists,i) = getAdjacent(self, i, NEXT);
250             numElements++;
251         }
252         return;
253     }
254 
255     /// @dev Returns the links of a node as a tuple
256     /// @param self stored linked list from contract
257     /// @param _node id of the node to get
258     function getNode(LinkedList storage self, uint256 _node)
259         public view returns (bool,uint256,uint256)
260     {
261         if (!nodeExists(self,_node)) {
262             return (false,0,0);
263         } else {
264             return (true,self.list[_node][PREV], self.list[_node][NEXT]);
265         }
266     }
267 
268     /// @dev Returns the link of a node `_node` in direction `_direction`.
269     /// @param self stored linked list from contract
270     /// @param _node id of the node to step from
271     /// @param _direction direction to step in
272     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
273         public view returns (bool,uint256)
274     {
275         if (!nodeExists(self,_node)) {
276             return (false,0);
277         } else {
278             return (true,self.list[_node][_direction]);
279         }
280     }
281 
282     /// @dev Can be used before `insert` to build an ordered list
283     /// @param self stored linked list from contract
284     /// @param _node an existing node to search from, e.g. HEAD.
285     /// @param _value value to seek
286     /// @param _direction direction to seek in
287     //  @return next first node beyond '_node' in direction `_direction`
288     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
289         public view returns (uint256)
290     {
291         if (sizeOf(self) == 0) { return 0; }
292         require((_node == 0) || nodeExists(self,_node));
293         bool exists;
294         uint256 next;
295         (exists,next) = getAdjacent(self, _node, _direction);
296         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
297         return next;
298     }
299 
300     /// @dev Creates a bidirectional link between two nodes on direction `_direction`
301     /// @param self stored linked list from contract
302     /// @param _node first node for linking
303     /// @param _link  node to link to in the _direction
304     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) private  {
305         self.list[_link][!_direction] = _node;
306         self.list[_node][_direction] = _link;
307     }
308 
309     /// @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
310     /// @param self stored linked list from contract
311     /// @param _node existing node
312     /// @param _new  new node to insert
313     /// @param _direction direction to insert node in
314     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) internal returns (bool) {
315         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
316             uint256 c = self.list[_node][_direction];
317             createLink(self, _node, _new, _direction);
318             createLink(self, _new, c, _direction);
319             return true;
320         } else {
321             return false;
322         }
323     }
324 
325     /// @dev removes an entry from the linked list
326     /// @param self stored linked list from contract
327     /// @param _node node to remove from the list
328     function remove(LinkedList storage self, uint256 _node) internal returns (uint256) {
329         if ((_node == NULL) || (!nodeExists(self,_node))) { return 0; }
330         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
331         delete self.list[_node][PREV];
332         delete self.list[_node][NEXT];
333         return _node;
334     }
335 
336     /// @dev pushes an enrty to the head of the linked list
337     /// @param self stored linked list from contract
338     /// @param _node new entry to push to the head
339     /// @param _direction push to the head (NEXT) or tail (PREV)
340     function push(LinkedList storage self, uint256 _node, bool _direction) internal  {
341         insert(self, HEAD, _node, _direction);
342     }
343 
344     /// @dev pops the first entry from the linked list
345     /// @param self stored linked list from contract
346     /// @param _direction pop from the head (NEXT) or the tail (PREV)
347     function pop(LinkedList storage self, bool _direction) internal returns (uint256) {
348         bool exists;
349         uint256 adj;
350 
351         (exists,adj) = getAdjacent(self, HEAD, _direction);
352 
353         return remove(self, adj);
354     }
355 }
356 
357 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
358 
359 /**
360  * @title ERC20Basic
361  * @dev Simpler version of ERC20 interface
362  * @dev see https://github.com/ethereum/EIPs/issues/179
363  */
364 contract ERC20Basic {
365   function totalSupply() public view returns (uint256);
366   function balanceOf(address who) public view returns (uint256);
367   function transfer(address to, uint256 value) public returns (bool);
368   event Transfer(address indexed from, address indexed to, uint256 value);
369 }
370 
371 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
372 
373 /**
374  * @title Basic token
375  * @dev Basic version of StandardToken, with no allowances.
376  */
377 contract BasicToken is ERC20Basic {
378   using SafeMath for uint256;
379 
380   mapping(address => uint256) balances;
381 
382   uint256 totalSupply_;
383 
384   /**
385   * @dev total number of tokens in existence
386   */
387   function totalSupply() public view returns (uint256) {
388     return totalSupply_;
389   }
390 
391   /**
392   * @dev transfer token for a specified address
393   * @param _to The address to transfer to.
394   * @param _value The amount to be transferred.
395   */
396   function transfer(address _to, uint256 _value) public returns (bool) {
397     require(_to != address(0));
398     require(_value <= balances[msg.sender]);
399 
400     balances[msg.sender] = balances[msg.sender].sub(_value);
401     balances[_to] = balances[_to].add(_value);
402     emit Transfer(msg.sender, _to, _value);
403     return true;
404   }
405 
406   /**
407   * @dev Gets the balance of the specified address.
408   * @param _owner The address to query the the balance of.
409   * @return An uint256 representing the amount owned by the passed address.
410   */
411   function balanceOf(address _owner) public view returns (uint256) {
412     return balances[_owner];
413   }
414 
415 }
416 
417 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
418 
419 /**
420  * @title ERC20 interface
421  * @dev see https://github.com/ethereum/EIPs/issues/20
422  */
423 contract ERC20 is ERC20Basic {
424   function allowance(address owner, address spender)
425     public view returns (uint256);
426 
427   function transferFrom(address from, address to, uint256 value)
428     public returns (bool);
429 
430   function approve(address spender, uint256 value) public returns (bool);
431   event Approval(
432     address indexed owner,
433     address indexed spender,
434     uint256 value
435   );
436 }
437 
438 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
439 
440 /**
441  * @title Standard ERC20 token
442  *
443  * @dev Implementation of the basic standard token.
444  * @dev https://github.com/ethereum/EIPs/issues/20
445  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
446  */
447 contract StandardToken is ERC20, BasicToken {
448 
449   mapping (address => mapping (address => uint256)) internal allowed;
450 
451 
452   /**
453    * @dev Transfer tokens from one address to another
454    * @param _from address The address which you want to send tokens from
455    * @param _to address The address which you want to transfer to
456    * @param _value uint256 the amount of tokens to be transferred
457    */
458   function transferFrom(
459     address _from,
460     address _to,
461     uint256 _value
462   )
463     public
464     returns (bool)
465   {
466     require(_to != address(0));
467     require(_value <= balances[_from]);
468     require(_value <= allowed[_from][msg.sender]);
469 
470     balances[_from] = balances[_from].sub(_value);
471     balances[_to] = balances[_to].add(_value);
472     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
473     emit Transfer(_from, _to, _value);
474     return true;
475   }
476 
477   /**
478    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
479    *
480    * Beware that changing an allowance with this method brings the risk that someone may use both the old
481    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
482    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
483    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
484    * @param _spender The address which will spend the funds.
485    * @param _value The amount of tokens to be spent.
486    */
487   function approve(address _spender, uint256 _value) public returns (bool) {
488     allowed[msg.sender][_spender] = _value;
489     emit Approval(msg.sender, _spender, _value);
490     return true;
491   }
492 
493   /**
494    * @dev Function to check the amount of tokens that an owner allowed to a spender.
495    * @param _owner address The address which owns the funds.
496    * @param _spender address The address which will spend the funds.
497    * @return A uint256 specifying the amount of tokens still available for the spender.
498    */
499   function allowance(
500     address _owner,
501     address _spender
502    )
503     public
504     view
505     returns (uint256)
506   {
507     return allowed[_owner][_spender];
508   }
509 
510   /**
511    * @dev Increase the amount of tokens that an owner allowed to a spender.
512    *
513    * approve should be called when allowed[_spender] == 0. To increment
514    * allowed value is better to use this function to avoid 2 calls (and wait until
515    * the first transaction is mined)
516    * From MonolithDAO Token.sol
517    * @param _spender The address which will spend the funds.
518    * @param _addedValue The amount of tokens to increase the allowance by.
519    */
520   function increaseApproval(
521     address _spender,
522     uint _addedValue
523   )
524     public
525     returns (bool)
526   {
527     allowed[msg.sender][_spender] = (
528       allowed[msg.sender][_spender].add(_addedValue));
529     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
530     return true;
531   }
532 
533   /**
534    * @dev Decrease the amount of tokens that an owner allowed to a spender.
535    *
536    * approve should be called when allowed[_spender] == 0. To decrement
537    * allowed value is better to use this function to avoid 2 calls (and wait until
538    * the first transaction is mined)
539    * From MonolithDAO Token.sol
540    * @param _spender The address which will spend the funds.
541    * @param _subtractedValue The amount of tokens to decrease the allowance by.
542    */
543   function decreaseApproval(
544     address _spender,
545     uint _subtractedValue
546   )
547     public
548     returns (bool)
549   {
550     uint oldValue = allowed[msg.sender][_spender];
551     if (_subtractedValue > oldValue) {
552       allowed[msg.sender][_spender] = 0;
553     } else {
554       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
555     }
556     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
557     return true;
558   }
559 
560 }
561 
562 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
563 
564 /**
565  * @title Roles
566  * @author Francisco Giordano (@frangio)
567  * @dev Library for managing addresses assigned to a Role.
568  *      See RBAC.sol for example usage.
569  */
570 library Roles {
571   struct Role {
572     mapping (address => bool) bearer;
573   }
574 
575   /**
576    * @dev give an address access to this role
577    */
578   function add(Role storage role, address addr)
579     internal
580   {
581     role.bearer[addr] = true;
582   }
583 
584   /**
585    * @dev remove an address' access to this role
586    */
587   function remove(Role storage role, address addr)
588     internal
589   {
590     role.bearer[addr] = false;
591   }
592 
593   /**
594    * @dev check if an address has this role
595    * // reverts
596    */
597   function check(Role storage role, address addr)
598     view
599     internal
600   {
601     require(has(role, addr));
602   }
603 
604   /**
605    * @dev check if an address has this role
606    * @return bool
607    */
608   function has(Role storage role, address addr)
609     view
610     internal
611     returns (bool)
612   {
613     return role.bearer[addr];
614   }
615 }
616 
617 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
618 
619 /**
620  * @title RBAC (Role-Based Access Control)
621  * @author Matt Condon (@Shrugs)
622  * @dev Stores and provides setters and getters for roles and addresses.
623  * @dev Supports unlimited numbers of roles and addresses.
624  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
625  * This RBAC method uses strings to key roles. It may be beneficial
626  *  for you to write your own implementation of this interface using Enums or similar.
627  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
628  *  to avoid typos.
629  */
630 contract RBAC {
631   using Roles for Roles.Role;
632 
633   mapping (string => Roles.Role) private roles;
634 
635   event RoleAdded(address addr, string roleName);
636   event RoleRemoved(address addr, string roleName);
637 
638   /**
639    * @dev reverts if addr does not have role
640    * @param addr address
641    * @param roleName the name of the role
642    * // reverts
643    */
644   function checkRole(address addr, string roleName)
645     view
646     public
647   {
648     roles[roleName].check(addr);
649   }
650 
651   /**
652    * @dev determine if addr has role
653    * @param addr address
654    * @param roleName the name of the role
655    * @return bool
656    */
657   function hasRole(address addr, string roleName)
658     view
659     public
660     returns (bool)
661   {
662     return roles[roleName].has(addr);
663   }
664 
665   /**
666    * @dev add a role to an address
667    * @param addr address
668    * @param roleName the name of the role
669    */
670   function addRole(address addr, string roleName)
671     internal
672   {
673     roles[roleName].add(addr);
674     emit RoleAdded(addr, roleName);
675   }
676 
677   /**
678    * @dev remove a role from an address
679    * @param addr address
680    * @param roleName the name of the role
681    */
682   function removeRole(address addr, string roleName)
683     internal
684   {
685     roles[roleName].remove(addr);
686     emit RoleRemoved(addr, roleName);
687   }
688 
689   /**
690    * @dev modifier to scope access to a single role (uses msg.sender as addr)
691    * @param roleName the name of the role
692    * // reverts
693    */
694   modifier onlyRole(string roleName)
695   {
696     checkRole(msg.sender, roleName);
697     _;
698   }
699 
700   /**
701    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
702    * @param roleNames the names of the roles to scope access to
703    * // reverts
704    *
705    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
706    *  see: https://github.com/ethereum/solidity/issues/2467
707    */
708   // modifier onlyRoles(string[] roleNames) {
709   //     bool hasAnyRole = false;
710   //     for (uint8 i = 0; i < roleNames.length; i++) {
711   //         if (hasRole(msg.sender, roleNames[i])) {
712   //             hasAnyRole = true;
713   //             break;
714   //         }
715   //     }
716 
717   //     require(hasAnyRole);
718 
719   //     _;
720   // }
721 }
722 
723 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
724 
725 /**
726  * @title Whitelist
727  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
728  * @dev This simplifies the implementation of "user permissions".
729  */
730 contract Whitelist is Ownable, RBAC {
731   event WhitelistedAddressAdded(address addr);
732   event WhitelistedAddressRemoved(address addr);
733 
734   string public constant ROLE_WHITELISTED = "whitelist";
735 
736   /**
737    * @dev Throws if called by any account that's not whitelisted.
738    */
739   modifier onlyWhitelisted() {
740     checkRole(msg.sender, ROLE_WHITELISTED);
741     _;
742   }
743 
744   /**
745    * @dev add an address to the whitelist
746    * @param addr address
747    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
748    */
749   function addAddressToWhitelist(address addr)
750     onlyOwner
751     public
752   {
753     addRole(addr, ROLE_WHITELISTED);
754     emit WhitelistedAddressAdded(addr);
755   }
756 
757   /**
758    * @dev getter to determine if address is in whitelist
759    */
760   function whitelist(address addr)
761     public
762     view
763     returns (bool)
764   {
765     return hasRole(addr, ROLE_WHITELISTED);
766   }
767 
768   /**
769    * @dev add addresses to the whitelist
770    * @param addrs addresses
771    * @return true if at least one address was added to the whitelist,
772    * false if all addresses were already in the whitelist
773    */
774   function addAddressesToWhitelist(address[] addrs)
775     onlyOwner
776     public
777   {
778     for (uint256 i = 0; i < addrs.length; i++) {
779       addAddressToWhitelist(addrs[i]);
780     }
781   }
782 
783   /**
784    * @dev remove an address from the whitelist
785    * @param addr address
786    * @return true if the address was removed from the whitelist,
787    * false if the address wasn't in the whitelist in the first place
788    */
789   function removeAddressFromWhitelist(address addr)
790     onlyOwner
791     public
792   {
793     removeRole(addr, ROLE_WHITELISTED);
794     emit WhitelistedAddressRemoved(addr);
795   }
796 
797   /**
798    * @dev remove addresses from the whitelist
799    * @param addrs addresses
800    * @return true if at least one address was removed from the whitelist,
801    * false if all addresses weren't in the whitelist in the first place
802    */
803   function removeAddressesFromWhitelist(address[] addrs)
804     onlyOwner
805     public
806   {
807     for (uint256 i = 0; i < addrs.length; i++) {
808       removeAddressFromWhitelist(addrs[i]);
809     }
810   }
811 
812 }
813 
814 // File: contracts/QuantstampAuditData.sol
815 
816 contract QuantstampAuditData is Whitelist {
817   // the audit data has a whitelist of addresses of audit contracts that may interact with this contract
818   using LinkedListLib for LinkedListLib.LinkedList;
819 
820   // constants used by LinkedListLib
821   uint256 constant internal NULL = 0;
822   uint256 constant internal HEAD = 0;
823   bool constant internal PREV = false;
824   bool constant internal NEXT = true;
825 
826   // state of audit requests submitted to the contract
827   enum AuditState {
828     None,
829     Queued,
830     Assigned,
831     Refunded,
832     Completed,  // automated audit finished successfully and the report is available
833     Error,      // automated audit failed to finish; the report contains detailed information about the error
834     Expired,
835     Resolved
836   }
837 
838   // structure representing an audit
839   struct Audit {
840     address requestor;
841     string contractUri;
842     uint256 price;
843     uint256 requestBlockNumber; // block number that audit was requested
844     QuantstampAuditData.AuditState state;
845     address auditor;       // the address of the node assigned to the audit
846     uint256 assignBlockNumber;  // block number that audit was assigned
847     string reportHash;     // stores the hash of audit report
848     uint256 reportBlockNumber;  // block number that the payment and the audit report were submitted
849     address registrar;  // address of the contract which registers this request
850   }
851 
852   // map audits (requestId, Audit)
853   mapping(uint256 => Audit) public audits;
854 
855   // token used to pay for audits. This contract assumes that the owner of the contract trusts token's code and
856   // that transfer function (such as transferFrom, transfer) do the right thing
857   StandardToken public token;
858 
859   // Once an audit node gets an audit request, the audit price is locked for this many blocks.
860   // After that, the requestor can asks for a refund.
861   uint256 public auditTimeoutInBlocks = 25;
862 
863   // maximum number of assigned audits per each auditor
864   uint256 public maxAssignedRequests = 10;
865 
866   // map audit nodes to their minimum prices. Defaults to zero: the node accepts all requests.
867   mapping(address => uint256) public minAuditPrice;
868 
869   // whitelist audit nodes
870   LinkedListLib.LinkedList internal whitelistedNodesList;
871 
872   uint256 private requestCounter;
873 
874   event WhitelistedNodeAdded(address addr);
875   event WhitelistedNodeRemoved(address addr);
876 
877   /**
878    * @dev The constructor creates an audit contract.
879    * @param tokenAddress The address of a StandardToken that will be used to pay auditor nodes.
880    */
881   constructor (address tokenAddress) public {
882     require(tokenAddress != address(0));
883     token = StandardToken(tokenAddress);
884   }
885 
886   function addAuditRequest (address requestor, string contractUri, uint256 price) public onlyWhitelisted returns(uint256) {
887     // assign the next request ID
888     uint256 requestId = ++requestCounter;
889     // store the audit
890     audits[requestId] = Audit(requestor, contractUri, price, block.number, AuditState.Queued, address(0), 0, "", 0, msg.sender);  // solhint-disable-line not-rely-on-time
891     return requestId;
892   }
893 
894   function getAuditContractUri(uint256 requestId) public view returns(string) {
895     return audits[requestId].contractUri;
896   }
897 
898   function getAuditRequestor(uint256 requestId) public view returns(address) {
899     return audits[requestId].requestor;
900   }
901 
902   function getAuditPrice (uint256 requestId) public view returns(uint256) {
903     return audits[requestId].price;
904   }
905 
906   function getAuditState (uint256 requestId) public view returns(AuditState) {
907     return audits[requestId].state;
908   }
909 
910   function getAuditRequestBlockNumber (uint256 requestId) public view returns(uint) {
911     return audits[requestId].requestBlockNumber;
912   }
913 
914   function setAuditState (uint256 requestId, AuditState state) public onlyWhitelisted {
915     audits[requestId].state = state;
916   }
917 
918   function getAuditAuditor (uint256 requestId) public view returns(address) {
919     return audits[requestId].auditor;
920   }
921 
922   function getAuditRegistrar (uint256 requestId) public view returns(address) {
923     return audits[requestId].registrar;
924   }
925 
926   function setAuditAuditor (uint256 requestId, address auditor) public onlyWhitelisted {
927     audits[requestId].auditor = auditor;
928   }
929 
930   function getAuditAssignBlockNumber (uint256 requestId) public view returns(uint) {
931     return audits[requestId].assignBlockNumber;
932   }
933 
934   function setAuditAssignBlockNumber (uint256 requestId, uint256 assignBlockNumber) public onlyWhitelisted {
935     audits[requestId].assignBlockNumber = assignBlockNumber;
936   }
937 
938   function setAuditReportHash (uint256 requestId, string reportHash) public onlyWhitelisted {
939     audits[requestId].reportHash = reportHash;
940   }
941 
942   function setAuditReportBlockNumber (uint256 requestId, uint256 reportBlockNumber) public onlyWhitelisted {
943     audits[requestId].reportBlockNumber = reportBlockNumber;
944   }
945 
946   function setAuditRegistrar (uint256 requestId, address registrar) public onlyWhitelisted {
947     audits[requestId].registrar = registrar;
948   }
949 
950   function setAuditTimeout (uint256 timeoutInBlocks) public onlyOwner {
951     auditTimeoutInBlocks = timeoutInBlocks;
952   }
953 
954   /**
955    * @dev set the maximum number of audits any audit node can handle at any time.
956    * @param maxAssignments maximum number of audit requests for each auditor
957    */
958   function setMaxAssignedRequests (uint256 maxAssignments) public onlyOwner {
959     maxAssignedRequests = maxAssignments;
960   }
961 
962   function getMinAuditPrice (address auditor) public view returns(uint256) {
963     return minAuditPrice[auditor];
964   }
965 
966   /**
967    * @dev Allows the audit node to set its minimum price per audit in wei-QSP
968    * @param price The minimum price.
969    */
970   function setMinAuditPrice(address auditor, uint256 price) public onlyWhitelisted {
971     minAuditPrice[auditor] = price;
972   }
973 
974   /**
975    * @dev Returns true if a node is whitelisted
976    * param node Node to check.
977    */
978   function isWhitelisted(address node) public view returns(bool) {
979     return whitelistedNodesList.nodeExists(uint256(node));
980   }
981 
982   /**
983    * @dev Adds an address to the whitelist
984    * @param addr address
985    * @return true if the address was added to the whitelist
986    */
987   function addNodeToWhitelist(address addr) public onlyOwner returns(bool success) {
988     if (whitelistedNodesList.insert(HEAD, uint256(addr), PREV)) {
989       emit WhitelistedNodeAdded(addr);
990       success = true;
991     }
992   }
993 
994   /**
995    * @dev Removes an address from the whitelist linked-list
996    * @param addr address
997    * @return true if the address was removed from the whitelist,
998    */
999   function removeNodeFromWhitelist(address addr) public onlyOwner returns(bool success) {
1000     if (whitelistedNodesList.remove(uint256(addr)) != 0) {
1001       emit WhitelistedNodeRemoved(addr);
1002       success = true;
1003     }
1004   }
1005 
1006   /**
1007    * @dev Given a whitelisted address, returns the next address from the whitelist
1008    * @param addr address
1009    * @return next address of the given param
1010    */
1011   function getNextWhitelistedNode(address addr) public view returns(address) {
1012     bool direction;
1013     uint256 next;
1014     (direction, next) = whitelistedNodesList.getAdjacent(uint256(addr), NEXT);
1015     return address(next);
1016   }
1017 }
1018 
1019 // File: contracts/QuantstampAudit.sol
1020 
1021 contract QuantstampAudit is Ownable, Pausable {
1022   using SafeMath for uint256;
1023   using LinkedListLib for LinkedListLib.LinkedList;
1024 
1025   // constants used by LinkedListLib
1026   uint256 constant internal NULL = 0;
1027   uint256 constant internal HEAD = 0;
1028   bool constant internal PREV = false;
1029   bool constant internal NEXT = true;
1030 
1031   // mapping from an auditor address to the number of requests that it currently processes
1032   mapping(address => uint256) public assignedRequestCount;
1033 
1034   // increasingly sorted linked list of prices
1035   LinkedListLib.LinkedList internal priceList;
1036   // map from price to a list of request IDs
1037   mapping(uint256 => LinkedListLib.LinkedList) internal auditsByPrice;
1038 
1039   // list of request IDs of assigned audits (the list preserves temporal order of assignments)
1040   LinkedListLib.LinkedList internal assignedAudits;
1041 
1042   // contract that stores audit data (separate from the auditing logic)
1043   QuantstampAuditData public auditData;
1044 
1045   event LogAuditFinished(
1046     uint256 requestId,
1047     address auditor,
1048     QuantstampAuditData.AuditState auditResult,
1049     string reportHash
1050   );
1051 
1052   event LogAuditRequested(uint256 requestId,
1053     address requestor,
1054     string uri,
1055     uint256 price
1056   );
1057 
1058   event LogAuditAssigned(uint256 requestId,
1059     address auditor,
1060     address requestor,
1061     string uri,
1062     uint256 price,
1063     uint256 requestBlockNumber);
1064 
1065   /* solhint-disable event-name-camelcase */
1066   event LogReportSubmissionError_InvalidAuditor(uint256 requestId, address auditor);
1067   event LogReportSubmissionError_InvalidState(uint256 requestId, address auditor, QuantstampAuditData.AuditState state);
1068   event LogReportSubmissionError_InvalidResult(uint256 requestId, address auditor, QuantstampAuditData.AuditState state);
1069   event LogReportSubmissionError_ExpiredAudit(uint256 requestId, address auditor, uint256 allowanceBlockNumber);
1070   event LogAuditAssignmentError_ExceededMaxAssignedRequests(address auditor);
1071   event LogAuditAssignmentUpdate_Expired(uint256 requestId, uint256 allowanceBlockNumber);
1072   /* solhint-enable event-name-camelcase */
1073 
1074   event LogAuditQueueIsEmpty();
1075 
1076   event LogPayAuditor(uint256 requestId, address auditor, uint256 amount);
1077   event LogAuditNodePriceChanged(address auditor, uint256 amount);
1078 
1079   event LogRefund(uint256 requestId, address requestor, uint256 amount);
1080   event LogRefundInvalidRequestor(uint256 requestId, address requestor);
1081   event LogRefundInvalidState(uint256 requestId, QuantstampAuditData.AuditState state);
1082   event LogRefundInvalidFundsLocked(uint256 requestId, uint256 currentBlock, uint256 fundLockEndBlock);
1083 
1084   // the audit queue has elements, but none satisfy the minPrice of the audit node
1085   // amount corresponds to the current minPrice of the auditor
1086   event LogAuditNodePriceHigherThanRequests(address auditor, uint256 amount);
1087 
1088   event LogInvalidResolutionCall(uint256 requestId);
1089   event LogErrorReportResolved(uint256 requestId, address receiver, uint256 auditPrice);
1090 
1091   enum AuditAvailabilityState {
1092     Error,
1093     Ready,      // an audit is available to be picked up
1094     Empty,      // there is no audit request in the queue
1095     Exceeded,   // number of incomplete audit requests is reached the cap
1096     Underprice  // all queued audit requests are less than the expected price
1097   }
1098 
1099   /**
1100    * @dev The constructor creates an audit contract.
1101    * @param auditDataAddress The address of a AuditData that stores data used for performing audits.
1102    */
1103   constructor (address auditDataAddress) public {
1104     require(auditDataAddress != address(0));
1105     auditData = QuantstampAuditData(auditDataAddress);
1106   }
1107 
1108   /**
1109    * @dev Throws if called by any account that's not whitelisted.
1110    */
1111   modifier onlyWhitelisted() {
1112     require(auditData.isWhitelisted(msg.sender));
1113     _;
1114   }
1115 
1116   /**
1117    * @dev Returns funds to the requestor.
1118    * @param requestId Unique ID of the audit request.
1119    */
1120   function refund(uint256 requestId) external returns(bool) {
1121     QuantstampAuditData.AuditState state = auditData.getAuditState(requestId);
1122     // check that the audit exists and is in a valid state
1123     if (state != QuantstampAuditData.AuditState.Queued &&
1124           state != QuantstampAuditData.AuditState.Assigned &&
1125             state != QuantstampAuditData.AuditState.Expired) {
1126       emit LogRefundInvalidState(requestId, state);
1127       return false;
1128     }
1129     address requestor = auditData.getAuditRequestor(requestId);
1130     if (requestor != msg.sender) {
1131       emit LogRefundInvalidRequestor(requestId, msg.sender);
1132       return;
1133     }
1134     uint256 refundBlockNumber = auditData.getAuditAssignBlockNumber(requestId) + auditData.auditTimeoutInBlocks();
1135     // check that the auditor has not recently started the audit (locking the funds)
1136     if (state == QuantstampAuditData.AuditState.Assigned) {
1137       if (block.number <= refundBlockNumber) {
1138         emit LogRefundInvalidFundsLocked(requestId, block.number, refundBlockNumber);
1139         return false;
1140       }
1141       // the request is expired but not detected by getNextAuditRequest
1142       updateAssignedAudits(requestId);
1143     } else if (state == QuantstampAuditData.AuditState.Queued) {
1144       // remove the request from the queue
1145       // note that if an audit node is currently assigned the request, it is already removed from the queue
1146       removeQueueElement(requestId);
1147     }
1148 
1149     // set the audit state to refunded
1150     auditData.setAuditState(requestId, QuantstampAuditData.AuditState.Refunded);
1151 
1152     // return the funds to the user
1153     uint256 price = auditData.getAuditPrice(requestId);
1154     emit LogRefund(requestId, requestor, price);
1155     return auditData.token().transfer(requestor, price);
1156   }
1157 
1158   /**
1159    * @dev Submits audit request.
1160    * @param contractUri Identifier of the resource to audit.
1161    * @param price The total amount of tokens that will be paid for the audit.
1162    */
1163   function requestAudit(string contractUri, uint256 price) external whenNotPaused returns(uint256) {
1164     require(price > 0);
1165     // transfer tokens to this contract
1166     auditData.token().transferFrom(msg.sender, address(this), price);
1167     // store the audit
1168     uint256 requestId = auditData.addAuditRequest(msg.sender, contractUri, price);
1169 
1170     // TODO: use existing price instead of HEAD (optimization)
1171     queueAuditRequest(requestId, HEAD);
1172 
1173     emit LogAuditRequested(requestId, msg.sender, contractUri, price); // solhint-disable-line not-rely-on-time
1174 
1175     return requestId;
1176   }
1177 
1178   /**
1179    * @dev Submits the report and pays the auditor node for their work if the audit is completed.
1180    * @param requestId Unique identifier of the audit request.
1181    * @param auditResult Result of an audit.
1182    * @param reportHash Hash of the generated report.
1183    */
1184   function submitReport(uint256 requestId, QuantstampAuditData.AuditState auditResult, string reportHash) public onlyWhitelisted {
1185     if (QuantstampAuditData.AuditState.Completed != auditResult && QuantstampAuditData.AuditState.Error != auditResult) {
1186       emit LogReportSubmissionError_InvalidResult(requestId, msg.sender, auditResult);
1187       return;
1188     }
1189 
1190     QuantstampAuditData.AuditState auditState = auditData.getAuditState(requestId);
1191     if (auditState != QuantstampAuditData.AuditState.Assigned) {
1192       emit LogReportSubmissionError_InvalidState(requestId, msg.sender, auditState);
1193       return;
1194     }
1195 
1196     // the sender must be the auditor
1197     if (msg.sender != auditData.getAuditAuditor(requestId)) {
1198       emit LogReportSubmissionError_InvalidAuditor(requestId, msg.sender);
1199       return;
1200     }
1201 
1202     // remove the requestId from assigned queue
1203     updateAssignedAudits(requestId);
1204 
1205     // auditor should not send a report after its allowed period
1206     uint256 allowanceBlockNumber = auditData.getAuditAssignBlockNumber(requestId) + auditData.auditTimeoutInBlocks();
1207     if (allowanceBlockNumber < block.number) {
1208       // update assigned to expired state
1209       auditData.setAuditState(requestId, QuantstampAuditData.AuditState.Expired);
1210       emit LogReportSubmissionError_ExpiredAudit(requestId, msg.sender, allowanceBlockNumber);
1211       return;
1212     }
1213 
1214     // update the audit information held in this contract
1215     auditData.setAuditState(requestId, auditResult);
1216     auditData.setAuditReportHash(requestId, reportHash);
1217     auditData.setAuditReportBlockNumber(requestId, block.number); // solhint-disable-line not-rely-on-time
1218 
1219     // validate the audit state
1220     require(isAuditFinished(requestId));
1221 
1222     emit LogAuditFinished(requestId, msg.sender, auditResult, reportHash); // solhint-disable-line not-rely-on-time
1223 
1224     if (auditResult == QuantstampAuditData.AuditState.Completed) {
1225       uint256 auditPrice = auditData.getAuditPrice(requestId);
1226       auditData.token().transfer(msg.sender, auditPrice);
1227       emit LogPayAuditor(requestId, msg.sender, auditPrice);
1228     }
1229   }
1230 
1231   /**
1232    * @dev Determines who has to be paid for a given requestId recorded with an error status
1233    * @param requestId Unique identifier of the audit request.
1234    * @param toRequester The audit price goes to the requester or the audit node.
1235    */
1236   function resolveErrorReport(uint256 requestId, bool toRequester) public onlyOwner {
1237     QuantstampAuditData.AuditState auditState = auditData.getAuditState(requestId);
1238     if (auditState != QuantstampAuditData.AuditState.Error) {
1239       emit LogInvalidResolutionCall(requestId);
1240       return;
1241     }
1242 
1243     uint256 auditPrice = auditData.getAuditPrice(requestId);
1244     address receiver = toRequester ? auditData.getAuditRequestor(requestId) : auditData.getAuditAuditor(requestId);
1245     auditData.token().transfer(receiver, auditPrice);
1246     auditData.setAuditState(requestId, QuantstampAuditData.AuditState.Resolved);
1247     emit LogErrorReportResolved(requestId, receiver, auditPrice);
1248   }
1249 
1250   /**
1251    * @dev Determines if there is an audit request available to be picked up by the caller
1252    */
1253   function anyRequestAvailable() public view returns(AuditAvailabilityState) {
1254     // there are no audits in the queue
1255     if (!auditQueueExists()) {
1256       return AuditAvailabilityState.Empty;
1257     }
1258 
1259     // check if the auditor's assignment is not exceeded.
1260     if (assignedRequestCount[msg.sender] >= auditData.maxAssignedRequests()) {
1261       return AuditAvailabilityState.Exceeded;
1262     }
1263 
1264     if (anyAuditRequestMatchesPrice(auditData.getMinAuditPrice(msg.sender)) == 0) {
1265       return AuditAvailabilityState.Underprice;
1266     }
1267 
1268     return AuditAvailabilityState.Ready;
1269   }
1270 
1271   /**
1272    * @dev Finds a list of most expensive audits and assigns the oldest one to the auditor node.
1273    */
1274   function getNextAuditRequest() public onlyWhitelisted {
1275     // remove an expired audit request
1276     if (assignedAudits.listExists()) {
1277       bool exists;
1278       uint256 potentialExpiredRequestId;
1279       (exists, potentialExpiredRequestId) = assignedAudits.getAdjacent(HEAD, NEXT);
1280       uint256 allowanceBlockNumber = auditData.getAuditAssignBlockNumber(potentialExpiredRequestId) + auditData.auditTimeoutInBlocks();
1281       if (allowanceBlockNumber < block.number) {
1282         updateAssignedAudits(potentialExpiredRequestId);
1283         auditData.setAuditState(potentialExpiredRequestId, QuantstampAuditData.AuditState.Expired);
1284         emit LogAuditAssignmentUpdate_Expired(potentialExpiredRequestId, allowanceBlockNumber);
1285       }
1286     }
1287 
1288     AuditAvailabilityState isRequestAvailable = anyRequestAvailable();
1289     // there are no audits in the queue
1290     if (isRequestAvailable == AuditAvailabilityState.Empty) {
1291       emit LogAuditQueueIsEmpty();
1292       return;
1293     }
1294 
1295     // check if the auditor's assignment is not exceeded.
1296     if (isRequestAvailable == AuditAvailabilityState.Exceeded) {
1297       emit LogAuditAssignmentError_ExceededMaxAssignedRequests(msg.sender);
1298       return;
1299     }
1300 
1301     // there are no audits in the queue with a price high enough for the audit node
1302     uint256 minPrice = auditData.getMinAuditPrice(msg.sender);
1303     uint256 requestId = dequeueAuditRequest(minPrice);
1304     if (requestId == 0) {
1305       emit LogAuditNodePriceHigherThanRequests(msg.sender, minPrice);
1306       return;
1307     }
1308 
1309     auditData.setAuditState(requestId, QuantstampAuditData.AuditState.Assigned);
1310     auditData.setAuditAuditor(requestId, msg.sender);
1311     auditData.setAuditAssignBlockNumber(requestId, block.number);
1312     assignedRequestCount[msg.sender]++;
1313 
1314     // push to the tail
1315     assignedAudits.push(requestId, PREV);
1316 
1317     emit LogAuditAssigned(
1318       requestId,
1319       auditData.getAuditAuditor(requestId),
1320       auditData.getAuditRequestor(requestId),
1321       auditData.getAuditContractUri(requestId),
1322       auditData.getAuditPrice(requestId),
1323       auditData.getAuditRequestBlockNumber(requestId));
1324   }
1325 
1326   /**
1327    * @dev Allows the audit node to set its minimum price per audit in wei-QSP
1328    * @param price The minimum price.
1329    */
1330   function setAuditNodePrice(uint256 price) public onlyWhitelisted {
1331     auditData.setMinAuditPrice(msg.sender, price);
1332     emit LogAuditNodePriceChanged(msg.sender, price);
1333   }
1334 
1335   /**
1336    * @dev Checks if an audit is finished. It is considered finished when the audit is either completed or failed.
1337    * @param requestId Unique ID of the audit request.
1338    */
1339   function isAuditFinished(uint256 requestId) public view returns(bool) {
1340     QuantstampAuditData.AuditState state = auditData.getAuditState(requestId);
1341     return state == QuantstampAuditData.AuditState.Completed || state == QuantstampAuditData.AuditState.Error;
1342   }
1343 
1344   /**
1345    * @dev Given a price, returns the next price from the priceList
1346    * @param price of the current node
1347    * @return next price in the linked list
1348    */
1349   function getNextPrice(uint256 price) public view returns(uint256) {
1350     bool exists;
1351     uint256 next;
1352     (exists, next) = priceList.getAdjacent(price, NEXT);
1353     return next;
1354   }
1355 
1356   /**
1357    * @dev Given a requestId, returns the next one from assignedAudits
1358    * @param requestId of the current node
1359    * @return next requestId in the linked list
1360    */
1361   function getNextAssignedRequest(uint256 requestId) public view returns(uint256) {
1362     bool exists;
1363     uint256 next;
1364     (exists, next) = assignedAudits.getAdjacent(requestId, NEXT);
1365     return next;
1366   }
1367 
1368   /**
1369    * @dev Given a price and a requestId, then function returns the next requestId with the same price
1370    * return 0, provided the given price does not exist in auditsByPrice
1371    * @param price of the current bucket
1372    * @param requestId unique Id of an requested audit
1373    * @return next requestId with the same price
1374    */
1375   function getNextAuditByPrice(uint256 price, uint256 requestId) public view returns(uint256) {
1376     bool exists;
1377     uint256 next;
1378     (exists, next) = auditsByPrice[price].getAdjacent(requestId, NEXT);
1379     return next;
1380   }
1381 
1382   /**
1383    * @dev Given a requestId, the function removes it from the list of audits and decreases the number of assigned
1384    * audits of the associated auditor
1385    * @param requestId unique Id of an requested audit
1386    */
1387   function updateAssignedAudits(uint256 requestId) internal {
1388     assignedAudits.remove(requestId);
1389     assignedRequestCount[auditData.getAuditAuditor(requestId)] =
1390       assignedRequestCount[auditData.getAuditAuditor(requestId)].sub(1);
1391   }
1392 
1393   /**
1394    * @dev Checks if the list of audits has any elements
1395    */
1396   function auditQueueExists() internal view returns(bool) {
1397     return priceList.listExists();
1398   }
1399 
1400   /**
1401    * @dev Adds an audit request to the queue
1402    * @param requestId Request ID.
1403    * @param existingPrice price of an existing audit in the queue (makes insertion O(1))
1404    */
1405   function queueAuditRequest(uint256 requestId, uint256 existingPrice) internal {
1406     uint256 price = auditData.getAuditPrice(requestId);
1407     if (!priceList.nodeExists(price)) {
1408       // if a price bucket doesn't exist, create it next to an existing one
1409       priceList.insert(priceList.getSortedSpot(existingPrice, price, NEXT), price, PREV);
1410     }
1411     // push to the tail
1412     auditsByPrice[price].push(requestId, PREV);
1413   }
1414 
1415   /**
1416    * @dev Evaluates if there is an audit price >= minPrice. Returns 0 if there no audit with the desired price.
1417    * Note that there should not be any audit with price as 0.
1418    * @param minPrice The minimum audit price.
1419    */
1420   function anyAuditRequestMatchesPrice(uint256 minPrice) internal view returns(uint256) {
1421     bool exists;
1422     uint256 price;
1423 
1424     // picks the tail of price buckets
1425     (exists, price) = priceList.getAdjacent(HEAD, PREV);
1426 
1427     if (price < minPrice) {
1428       return 0;
1429     }
1430     return price;
1431   }
1432 
1433   /**
1434    * @dev Finds a list of most expensive audits and returns the oldest one that has a price >= minPrice
1435    * @param minPrice The minimum audit price.
1436    */
1437   function dequeueAuditRequest(uint256 minPrice) internal returns(uint256) {
1438     uint256 price;
1439 
1440     // picks the tail of price buckets
1441     // TODO seems the following statement is redundantly called from getNextAuditRequest. If this is the only place
1442     // to call dequeueAuditRequest, then removing the following line saves gas, but leaves dequeueAuditRequest
1443     // unsafe for further extension by noobies.
1444     price = anyAuditRequestMatchesPrice(minPrice);
1445 
1446     if (price > 0) {
1447       // picks the oldest audit request
1448       uint256 result = auditsByPrice[price].pop(NEXT);
1449       // removes the price bucket if it contains no requests
1450       if (!auditsByPrice[price].listExists()) {
1451         priceList.remove(price);
1452       }
1453       return result;
1454     }
1455     return 0;
1456   }
1457 
1458   /**
1459    * @dev Removes an element from the list
1460    * @param requestId The Id of the request to be removed
1461    */
1462   function removeQueueElement(uint256 requestId) internal {
1463     uint256 price = auditData.getAuditPrice(requestId);
1464 
1465     // the node must exist in the list
1466     require(priceList.nodeExists(price));
1467     require(auditsByPrice[price].nodeExists(requestId));
1468 
1469     auditsByPrice[price].remove(requestId);
1470     if (!auditsByPrice[price].listExists()) {
1471       priceList.remove(price);
1472     }
1473   }
1474 }