1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
65 
66 /**
67  * @title Contracts that should not own Ether
68  * @author Remco Bloemen <remco@2π.com>
69  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
70  * in the contract, it will allow the owner to reclaim this ether.
71  * @notice Ether can still be sent to this contract by:
72  * calling functions labeled `payable`
73  * `selfdestruct(contract_address)`
74  * mining directly to the contract address
75  */
76 contract HasNoEther is Ownable {
77 
78   /**
79   * @dev Constructor that rejects incoming Ether
80   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
81   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
82   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
83   * we could use assembly to access msg.value.
84   */
85   constructor() public payable {
86     require(msg.value == 0);
87   }
88 
89   /**
90    * @dev Disallows direct send by settings a default function without the `payable` flag.
91    */
92   function() external {
93   }
94 
95   /**
96    * @dev Transfer all Ether held by the contract to the owner.
97    */
98   function reclaimEther() external onlyOwner {
99     owner.transfer(address(this).balance);
100   }
101 }
102 
103 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
104 
105 /**
106  * @title Roles
107  * @author Francisco Giordano (@frangio)
108  * @dev Library for managing addresses assigned to a Role.
109  *      See RBAC.sol for example usage.
110  */
111 library Roles {
112   struct Role {
113     mapping (address => bool) bearer;
114   }
115 
116   /**
117    * @dev give an address access to this role
118    */
119   function add(Role storage role, address addr)
120     internal
121   {
122     role.bearer[addr] = true;
123   }
124 
125   /**
126    * @dev remove an address' access to this role
127    */
128   function remove(Role storage role, address addr)
129     internal
130   {
131     role.bearer[addr] = false;
132   }
133 
134   /**
135    * @dev check if an address has this role
136    * // reverts
137    */
138   function check(Role storage role, address addr)
139     view
140     internal
141   {
142     require(has(role, addr));
143   }
144 
145   /**
146    * @dev check if an address has this role
147    * @return bool
148    */
149   function has(Role storage role, address addr)
150     view
151     internal
152     returns (bool)
153   {
154     return role.bearer[addr];
155   }
156 }
157 
158 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
159 
160 /**
161  * @title RBAC (Role-Based Access Control)
162  * @author Matt Condon (@Shrugs)
163  * @dev Stores and provides setters and getters for roles and addresses.
164  * @dev Supports unlimited numbers of roles and addresses.
165  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
166  * This RBAC method uses strings to key roles. It may be beneficial
167  *  for you to write your own implementation of this interface using Enums or similar.
168  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
169  *  to avoid typos.
170  */
171 contract RBAC {
172   using Roles for Roles.Role;
173 
174   mapping (string => Roles.Role) private roles;
175 
176   event RoleAdded(address addr, string roleName);
177   event RoleRemoved(address addr, string roleName);
178 
179   /**
180    * @dev reverts if addr does not have role
181    * @param addr address
182    * @param roleName the name of the role
183    * // reverts
184    */
185   function checkRole(address addr, string roleName)
186     view
187     public
188   {
189     roles[roleName].check(addr);
190   }
191 
192   /**
193    * @dev determine if addr has role
194    * @param addr address
195    * @param roleName the name of the role
196    * @return bool
197    */
198   function hasRole(address addr, string roleName)
199     view
200     public
201     returns (bool)
202   {
203     return roles[roleName].has(addr);
204   }
205 
206   /**
207    * @dev add a role to an address
208    * @param addr address
209    * @param roleName the name of the role
210    */
211   function addRole(address addr, string roleName)
212     internal
213   {
214     roles[roleName].add(addr);
215     emit RoleAdded(addr, roleName);
216   }
217 
218   /**
219    * @dev remove a role from an address
220    * @param addr address
221    * @param roleName the name of the role
222    */
223   function removeRole(address addr, string roleName)
224     internal
225   {
226     roles[roleName].remove(addr);
227     emit RoleRemoved(addr, roleName);
228   }
229 
230   /**
231    * @dev modifier to scope access to a single role (uses msg.sender as addr)
232    * @param roleName the name of the role
233    * // reverts
234    */
235   modifier onlyRole(string roleName)
236   {
237     checkRole(msg.sender, roleName);
238     _;
239   }
240 
241   /**
242    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
243    * @param roleNames the names of the roles to scope access to
244    * // reverts
245    *
246    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
247    *  see: https://github.com/ethereum/solidity/issues/2467
248    */
249   // modifier onlyRoles(string[] roleNames) {
250   //     bool hasAnyRole = false;
251   //     for (uint8 i = 0; i < roleNames.length; i++) {
252   //         if (hasRole(msg.sender, roleNames[i])) {
253   //             hasAnyRole = true;
254   //             break;
255   //         }
256   //     }
257 
258   //     require(hasAnyRole);
259 
260   //     _;
261   // }
262 }
263 
264 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
265 
266 /**
267  * @title Whitelist
268  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
269  * @dev This simplifies the implementation of "user permissions".
270  */
271 contract Whitelist is Ownable, RBAC {
272   event WhitelistedAddressAdded(address addr);
273   event WhitelistedAddressRemoved(address addr);
274 
275   string public constant ROLE_WHITELISTED = "whitelist";
276 
277   /**
278    * @dev Throws if called by any account that's not whitelisted.
279    */
280   modifier onlyWhitelisted() {
281     checkRole(msg.sender, ROLE_WHITELISTED);
282     _;
283   }
284 
285   /**
286    * @dev add an address to the whitelist
287    * @param addr address
288    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
289    */
290   function addAddressToWhitelist(address addr)
291     onlyOwner
292     public
293   {
294     addRole(addr, ROLE_WHITELISTED);
295     emit WhitelistedAddressAdded(addr);
296   }
297 
298   /**
299    * @dev getter to determine if address is in whitelist
300    */
301   function whitelist(address addr)
302     public
303     view
304     returns (bool)
305   {
306     return hasRole(addr, ROLE_WHITELISTED);
307   }
308 
309   /**
310    * @dev add addresses to the whitelist
311    * @param addrs addresses
312    * @return true if at least one address was added to the whitelist,
313    * false if all addresses were already in the whitelist
314    */
315   function addAddressesToWhitelist(address[] addrs)
316     onlyOwner
317     public
318   {
319     for (uint256 i = 0; i < addrs.length; i++) {
320       addAddressToWhitelist(addrs[i]);
321     }
322   }
323 
324   /**
325    * @dev remove an address from the whitelist
326    * @param addr address
327    * @return true if the address was removed from the whitelist,
328    * false if the address wasn't in the whitelist in the first place
329    */
330   function removeAddressFromWhitelist(address addr)
331     onlyOwner
332     public
333   {
334     removeRole(addr, ROLE_WHITELISTED);
335     emit WhitelistedAddressRemoved(addr);
336   }
337 
338   /**
339    * @dev remove addresses from the whitelist
340    * @param addrs addresses
341    * @return true if at least one address was removed from the whitelist,
342    * false if all addresses weren't in the whitelist in the first place
343    */
344   function removeAddressesFromWhitelist(address[] addrs)
345     onlyOwner
346     public
347   {
348     for (uint256 i = 0; i < addrs.length; i++) {
349       removeAddressFromWhitelist(addrs[i]);
350     }
351   }
352 
353 }
354 
355 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
356 
357 /**
358  * @title SafeMath
359  * @dev Math operations with safety checks that throw on error
360  */
361 library SafeMath {
362 
363   /**
364   * @dev Multiplies two numbers, throws on overflow.
365   */
366   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
367     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
368     // benefit is lost if 'b' is also tested.
369     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
370     if (a == 0) {
371       return 0;
372     }
373 
374     c = a * b;
375     assert(c / a == b);
376     return c;
377   }
378 
379   /**
380   * @dev Integer division of two numbers, truncating the quotient.
381   */
382   function div(uint256 a, uint256 b) internal pure returns (uint256) {
383     // assert(b > 0); // Solidity automatically throws when dividing by 0
384     // uint256 c = a / b;
385     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
386     return a / b;
387   }
388 
389   /**
390   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
391   */
392   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
393     assert(b <= a);
394     return a - b;
395   }
396 
397   /**
398   * @dev Adds two numbers, throws on overflow.
399   */
400   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
401     c = a + b;
402     assert(c >= a);
403     return c;
404   }
405 }
406 
407 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
408 
409 /**
410  * @title ERC20Basic
411  * @dev Simpler version of ERC20 interface
412  * @dev see https://github.com/ethereum/EIPs/issues/179
413  */
414 contract ERC20Basic {
415   function totalSupply() public view returns (uint256);
416   function balanceOf(address who) public view returns (uint256);
417   function transfer(address to, uint256 value) public returns (bool);
418   event Transfer(address indexed from, address indexed to, uint256 value);
419 }
420 
421 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
422 
423 /**
424  * @title Basic token
425  * @dev Basic version of StandardToken, with no allowances.
426  */
427 contract BasicToken is ERC20Basic {
428   using SafeMath for uint256;
429 
430   mapping(address => uint256) balances;
431 
432   uint256 totalSupply_;
433 
434   /**
435   * @dev total number of tokens in existence
436   */
437   function totalSupply() public view returns (uint256) {
438     return totalSupply_;
439   }
440 
441   /**
442   * @dev transfer token for a specified address
443   * @param _to The address to transfer to.
444   * @param _value The amount to be transferred.
445   */
446   function transfer(address _to, uint256 _value) public returns (bool) {
447     require(_to != address(0));
448     require(_value <= balances[msg.sender]);
449 
450     balances[msg.sender] = balances[msg.sender].sub(_value);
451     balances[_to] = balances[_to].add(_value);
452     emit Transfer(msg.sender, _to, _value);
453     return true;
454   }
455 
456   /**
457   * @dev Gets the balance of the specified address.
458   * @param _owner The address to query the the balance of.
459   * @return An uint256 representing the amount owned by the passed address.
460   */
461   function balanceOf(address _owner) public view returns (uint256) {
462     return balances[_owner];
463   }
464 
465 }
466 
467 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
468 
469 /**
470  * @title ERC20 interface
471  * @dev see https://github.com/ethereum/EIPs/issues/20
472  */
473 contract ERC20 is ERC20Basic {
474   function allowance(address owner, address spender)
475     public view returns (uint256);
476 
477   function transferFrom(address from, address to, uint256 value)
478     public returns (bool);
479 
480   function approve(address spender, uint256 value) public returns (bool);
481   event Approval(
482     address indexed owner,
483     address indexed spender,
484     uint256 value
485   );
486 }
487 
488 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
489 
490 /**
491  * @title Standard ERC20 token
492  *
493  * @dev Implementation of the basic standard token.
494  * @dev https://github.com/ethereum/EIPs/issues/20
495  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
496  */
497 contract StandardToken is ERC20, BasicToken {
498 
499   mapping (address => mapping (address => uint256)) internal allowed;
500 
501 
502   /**
503    * @dev Transfer tokens from one address to another
504    * @param _from address The address which you want to send tokens from
505    * @param _to address The address which you want to transfer to
506    * @param _value uint256 the amount of tokens to be transferred
507    */
508   function transferFrom(
509     address _from,
510     address _to,
511     uint256 _value
512   )
513     public
514     returns (bool)
515   {
516     require(_to != address(0));
517     require(_value <= balances[_from]);
518     require(_value <= allowed[_from][msg.sender]);
519 
520     balances[_from] = balances[_from].sub(_value);
521     balances[_to] = balances[_to].add(_value);
522     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
523     emit Transfer(_from, _to, _value);
524     return true;
525   }
526 
527   /**
528    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
529    *
530    * Beware that changing an allowance with this method brings the risk that someone may use both the old
531    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
532    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
533    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
534    * @param _spender The address which will spend the funds.
535    * @param _value The amount of tokens to be spent.
536    */
537   function approve(address _spender, uint256 _value) public returns (bool) {
538     allowed[msg.sender][_spender] = _value;
539     emit Approval(msg.sender, _spender, _value);
540     return true;
541   }
542 
543   /**
544    * @dev Function to check the amount of tokens that an owner allowed to a spender.
545    * @param _owner address The address which owns the funds.
546    * @param _spender address The address which will spend the funds.
547    * @return A uint256 specifying the amount of tokens still available for the spender.
548    */
549   function allowance(
550     address _owner,
551     address _spender
552    )
553     public
554     view
555     returns (uint256)
556   {
557     return allowed[_owner][_spender];
558   }
559 
560   /**
561    * @dev Increase the amount of tokens that an owner allowed to a spender.
562    *
563    * approve should be called when allowed[_spender] == 0. To increment
564    * allowed value is better to use this function to avoid 2 calls (and wait until
565    * the first transaction is mined)
566    * From MonolithDAO Token.sol
567    * @param _spender The address which will spend the funds.
568    * @param _addedValue The amount of tokens to increase the allowance by.
569    */
570   function increaseApproval(
571     address _spender,
572     uint _addedValue
573   )
574     public
575     returns (bool)
576   {
577     allowed[msg.sender][_spender] = (
578       allowed[msg.sender][_spender].add(_addedValue));
579     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
580     return true;
581   }
582 
583   /**
584    * @dev Decrease the amount of tokens that an owner allowed to a spender.
585    *
586    * approve should be called when allowed[_spender] == 0. To decrement
587    * allowed value is better to use this function to avoid 2 calls (and wait until
588    * the first transaction is mined)
589    * From MonolithDAO Token.sol
590    * @param _spender The address which will spend the funds.
591    * @param _subtractedValue The amount of tokens to decrease the allowance by.
592    */
593   function decreaseApproval(
594     address _spender,
595     uint _subtractedValue
596   )
597     public
598     returns (bool)
599   {
600     uint oldValue = allowed[msg.sender][_spender];
601     if (_subtractedValue > oldValue) {
602       allowed[msg.sender][_spender] = 0;
603     } else {
604       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
605     }
606     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
607     return true;
608   }
609 
610 }
611 
612 // File: contracts/pixie/PixieToken.sol
613 
614 contract PixieToken is StandardToken, Whitelist, HasNoEther {
615 
616   string public constant name = "Pixie Token";
617 
618   string public constant symbol = "PXE";
619 
620   uint8 public constant decimals = 18;
621 
622   uint256 public constant initialSupply = 100000000000 * (10 ** uint256(decimals)); // 100 Billion PXE ^ decimal
623 
624   bool public transfersEnabled = false;
625 
626   address public bridge;
627 
628   event BridgeChange(address to);
629 
630   event TransfersEnabledChange(bool to);
631 
632   /**
633    * @dev Constructor that gives msg.sender all of existing tokens.
634    */
635   constructor() public Whitelist() {
636     totalSupply_ = initialSupply;
637     balances[msg.sender] = initialSupply;
638     emit Transfer(0x0, msg.sender, initialSupply);
639 
640     // transfer bridge set to msg sender
641     bridge = msg.sender;
642 
643     // owner is automatically whitelisted
644     addAddressToWhitelist(msg.sender);
645   }
646 
647   function transfer(address _to, uint256 _value) public returns (bool) {
648     require(
649       transfersEnabled || whitelist(msg.sender) || _to == bridge,
650       "Unable to transfers locked or address not whitelisted or not sending to the bridge"
651     );
652 
653     return super.transfer(_to, _value);
654   }
655 
656   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
657     require(
658       transfersEnabled || whitelist(msg.sender) || _to == bridge,
659       "Unable to transfers locked or address not whitelisted or not sending to the bridge"
660     );
661 
662     return super.transferFrom(_from, _to, _value);
663   }
664 
665   /**
666    * @dev Allows for setting the bridge address
667    * @dev Must be called by owner
668    *
669    * @param _new the address to set
670    */
671   function changeBridge(address _new) external onlyOwner {
672     require(_new != address(0), "Invalid address");
673     bridge = _new;
674     emit BridgeChange(bridge);
675   }
676 
677   /**
678    * @dev Allows for setting transfer on/off - used as hard stop
679    * @dev Must be called by owner
680    *
681    * @param _transfersEnabled the value to set
682    */
683   function setTransfersEnabled(bool _transfersEnabled) external onlyOwner {
684     transfersEnabled = _transfersEnabled;
685     emit TransfersEnabledChange(transfersEnabled);
686   }
687 }