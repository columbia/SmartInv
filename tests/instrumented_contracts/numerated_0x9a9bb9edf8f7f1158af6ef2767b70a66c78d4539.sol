1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 pragma solidity ^0.4.23;
17 
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 pragma solidity ^0.4.23;
39 
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
52     // benefit is lost if 'b' is also tested.
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54     if (a == 0) {
55       return 0;
56     }
57 
58     c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     // uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return a / b;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 pragma solidity ^0.4.23;
93 
94 
95 /**
96  * @title Ownable
97  * @dev The Ownable contract has an owner address, and provides basic authorization control
98  * functions, this simplifies the implementation of "user permissions".
99  */
100 contract Ownable {
101   address public owner;
102 
103 
104   event OwnershipRenounced(address indexed previousOwner);
105   event OwnershipTransferred(
106     address indexed previousOwner,
107     address indexed newOwner
108   );
109 
110 
111   /**
112    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
113    * account.
114    */
115   constructor() public {
116     owner = msg.sender;
117   }
118 
119   /**
120    * @dev Throws if called by any account other than the owner.
121    */
122   modifier onlyOwner() {
123     require(msg.sender == owner);
124     _;
125   }
126 
127   /**
128    * @dev Allows the current owner to relinquish control of the contract.
129    */
130   function renounceOwnership() public onlyOwner {
131     emit OwnershipRenounced(owner);
132     owner = address(0);
133   }
134 
135   /**
136    * @dev Allows the current owner to transfer control of the contract to a newOwner.
137    * @param _newOwner The address to transfer ownership to.
138    */
139   function transferOwnership(address _newOwner) public onlyOwner {
140     _transferOwnership(_newOwner);
141   }
142 
143   /**
144    * @dev Transfers control of the contract to a newOwner.
145    * @param _newOwner The address to transfer ownership to.
146    */
147   function _transferOwnership(address _newOwner) internal {
148     require(_newOwner != address(0));
149     emit OwnershipTransferred(owner, _newOwner);
150     owner = _newOwner;
151   }
152 }
153 
154 pragma solidity ^0.4.23;
155 
156 
157 /**
158  * @title Roles
159  * @author Francisco Giordano (@frangio)
160  * @dev Library for managing addresses assigned to a Role.
161  *      See RBAC.sol for example usage.
162  */
163 library Roles {
164   struct Role {
165     mapping (address => bool) bearer;
166   }
167 
168   /**
169    * @dev give an address access to this role
170    */
171   function add(Role storage role, address addr)
172     internal
173   {
174     role.bearer[addr] = true;
175   }
176 
177   /**
178    * @dev remove an address' access to this role
179    */
180   function remove(Role storage role, address addr)
181     internal
182   {
183     role.bearer[addr] = false;
184   }
185 
186   /**
187    * @dev check if an address has this role
188    * // reverts
189    */
190   function check(Role storage role, address addr)
191     view
192     internal
193   {
194     require(has(role, addr));
195   }
196 
197   /**
198    * @dev check if an address has this role
199    * @return bool
200    */
201   function has(Role storage role, address addr)
202     view
203     internal
204     returns (bool)
205   {
206     return role.bearer[addr];
207   }
208 }
209 
210 pragma solidity ^0.4.23;
211 
212 /**
213  * @title RBAC (Role-Based Access Control)
214  * @author Matt Condon (@Shrugs)
215  * @dev Stores and provides setters and getters for roles and addresses.
216  * @dev Supports unlimited numbers of roles and addresses.
217  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
218  * This RBAC method uses strings to key roles. It may be beneficial
219  *  for you to write your own implementation of this interface using Enums or similar.
220  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
221  *  to avoid typos.
222  */
223 contract RBAC {
224   using Roles for Roles.Role;
225 
226   mapping (string => Roles.Role) private roles;
227 
228   event RoleAdded(address addr, string roleName);
229   event RoleRemoved(address addr, string roleName);
230 
231   /**
232    * @dev reverts if addr does not have role
233    * @param addr address
234    * @param roleName the name of the role
235    * // reverts
236    */
237   function checkRole(address addr, string roleName)
238     view
239     public
240   {
241     roles[roleName].check(addr);
242   }
243 
244   /**
245    * @dev determine if addr has role
246    * @param addr address
247    * @param roleName the name of the role
248    * @return bool
249    */
250   function hasRole(address addr, string roleName)
251     view
252     public
253     returns (bool)
254   {
255     return roles[roleName].has(addr);
256   }
257 
258   /**
259    * @dev add a role to an address
260    * @param addr address
261    * @param roleName the name of the role
262    */
263   function addRole(address addr, string roleName)
264     internal
265   {
266     roles[roleName].add(addr);
267     emit RoleAdded(addr, roleName);
268   }
269 
270   /**
271    * @dev remove a role from an address
272    * @param addr address
273    * @param roleName the name of the role
274    */
275   function removeRole(address addr, string roleName)
276     internal
277   {
278     roles[roleName].remove(addr);
279     emit RoleRemoved(addr, roleName);
280   }
281 
282   /**
283    * @dev modifier to scope access to a single role (uses msg.sender as addr)
284    * @param roleName the name of the role
285    * // reverts
286    */
287   modifier onlyRole(string roleName)
288   {
289     checkRole(msg.sender, roleName);
290     _;
291   }
292 
293   /**
294    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
295    * @param roleNames the names of the roles to scope access to
296    * // reverts
297    *
298    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
299    *  see: https://github.com/ethereum/solidity/issues/2467
300    */
301   // modifier onlyRoles(string[] roleNames) {
302   //     bool hasAnyRole = false;
303   //     for (uint8 i = 0; i < roleNames.length; i++) {
304   //         if (hasRole(msg.sender, roleNames[i])) {
305   //             hasAnyRole = true;
306   //             break;
307   //         }
308   //     }
309 
310   //     require(hasAnyRole);
311 
312   //     _;
313   // }
314 }
315 
316 pragma solidity ^0.4.23;
317 
318 /**
319  * @title Basic token
320  * @dev Basic version of StandardToken, with no allowances.
321  */
322 contract BasicToken is ERC20Basic {
323   using SafeMath for uint256;
324 
325   mapping(address => uint256) balances;
326 
327   uint256 totalSupply_;
328 
329   /**
330   * @dev total number of tokens in existence
331   */
332   function totalSupply() public view returns (uint256) {
333     return totalSupply_;
334   }
335 
336   /**
337   * @dev transfer token for a specified address
338   * @param _to The address to transfer to.
339   * @param _value The amount to be transferred.
340   */
341   function transfer(address _to, uint256 _value) public returns (bool) {
342     require(_to != address(0));
343     require(_value <= balances[msg.sender]);
344 
345     balances[msg.sender] = balances[msg.sender].sub(_value);
346     balances[_to] = balances[_to].add(_value);
347     emit Transfer(msg.sender, _to, _value);
348     return true;
349   }
350 
351   /**
352   * @dev Gets the balance of the specified address.
353   * @param _owner The address to query the the balance of.
354   * @return An uint256 representing the amount owned by the passed address.
355   */
356   function balanceOf(address _owner) public view returns (uint256) {
357     return balances[_owner];
358   }
359 
360 }
361 
362 pragma solidity ^0.4.23;
363 
364 
365 /**
366  * @title Burnable Token
367  * @dev Token that can be irreversibly burned (destroyed).
368  */
369 contract BurnableToken is BasicToken {
370 
371   event Burn(address indexed burner, uint256 value);
372 
373   /**
374    * @dev Burns a specific amount of tokens.
375    * @param _value The amount of token to be burned.
376    */
377   function burn(uint256 _value) public {
378     _burn(msg.sender, _value);
379   }
380 
381   function _burn(address _who, uint256 _value) internal {
382     require(_value <= balances[_who]);
383     // no need to require value <= totalSupply, since that would imply the
384     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
385 
386     balances[_who] = balances[_who].sub(_value);
387     totalSupply_ = totalSupply_.sub(_value);
388     emit Burn(_who, _value);
389     emit Transfer(_who, address(0), _value);
390   }
391 }
392 
393 pragma solidity ^0.4.23;
394 
395 /**
396  * @title Standard ERC20 token
397  *
398  * @dev Implementation of the basic standard token.
399  * @dev https://github.com/ethereum/EIPs/issues/20
400  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
401  */
402 contract StandardToken is ERC20, BasicToken {
403 
404   mapping (address => mapping (address => uint256)) internal allowed;
405 
406 
407   /**
408    * @dev Transfer tokens from one address to another
409    * @param _from address The address which you want to send tokens from
410    * @param _to address The address which you want to transfer to
411    * @param _value uint256 the amount of tokens to be transferred
412    */
413   function transferFrom(
414     address _from,
415     address _to,
416     uint256 _value
417   )
418     public
419     returns (bool)
420   {
421     require(_to != address(0));
422     require(_value <= balances[_from]);
423     require(_value <= allowed[_from][msg.sender]);
424 
425     balances[_from] = balances[_from].sub(_value);
426     balances[_to] = balances[_to].add(_value);
427     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
428     emit Transfer(_from, _to, _value);
429     return true;
430   }
431 
432   /**
433    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
434    *
435    * Beware that changing an allowance with this method brings the risk that someone may use both the old
436    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
437    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
438    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
439    * @param _spender The address which will spend the funds.
440    * @param _value The amount of tokens to be spent.
441    */
442   function approve(address _spender, uint256 _value) public returns (bool) {
443     allowed[msg.sender][_spender] = _value;
444     emit Approval(msg.sender, _spender, _value);
445     return true;
446   }
447 
448   /**
449    * @dev Function to check the amount of tokens that an owner allowed to a spender.
450    * @param _owner address The address which owns the funds.
451    * @param _spender address The address which will spend the funds.
452    * @return A uint256 specifying the amount of tokens still available for the spender.
453    */
454   function allowance(
455     address _owner,
456     address _spender
457    )
458     public
459     view
460     returns (uint256)
461   {
462     return allowed[_owner][_spender];
463   }
464 
465   /**
466    * @dev Increase the amount of tokens that an owner allowed to a spender.
467    *
468    * approve should be called when allowed[_spender] == 0. To increment
469    * allowed value is better to use this function to avoid 2 calls (and wait until
470    * the first transaction is mined)
471    * From MonolithDAO Token.sol
472    * @param _spender The address which will spend the funds.
473    * @param _addedValue The amount of tokens to increase the allowance by.
474    */
475   function increaseApproval(
476     address _spender,
477     uint _addedValue
478   )
479     public
480     returns (bool)
481   {
482     allowed[msg.sender][_spender] = (
483       allowed[msg.sender][_spender].add(_addedValue));
484     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
485     return true;
486   }
487 
488   /**
489    * @dev Decrease the amount of tokens that an owner allowed to a spender.
490    *
491    * approve should be called when allowed[_spender] == 0. To decrement
492    * allowed value is better to use this function to avoid 2 calls (and wait until
493    * the first transaction is mined)
494    * From MonolithDAO Token.sol
495    * @param _spender The address which will spend the funds.
496    * @param _subtractedValue The amount of tokens to decrease the allowance by.
497    */
498   function decreaseApproval(
499     address _spender,
500     uint _subtractedValue
501   )
502     public
503     returns (bool)
504   {
505     uint oldValue = allowed[msg.sender][_spender];
506     if (_subtractedValue > oldValue) {
507       allowed[msg.sender][_spender] = 0;
508     } else {
509       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
510     }
511     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
512     return true;
513   }
514 
515 }
516 
517 pragma solidity ^0.4.23;
518 
519 /**
520  * @title Mintable token
521  * @dev Simple ERC20 Token example, with mintable token creation
522  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
523  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
524  */
525 contract MintableToken is StandardToken, Ownable {
526   event Mint(address indexed to, uint256 amount);
527   event MintFinished();
528 
529   bool public mintingFinished = false;
530 
531 
532   modifier canMint() {
533     require(!mintingFinished);
534     _;
535   }
536 
537   modifier hasMintPermission() {
538     require(msg.sender == owner);
539     _;
540   }
541 
542   /**
543    * @dev Function to mint tokens
544    * @param _to The address that will receive the minted tokens.
545    * @param _amount The amount of tokens to mint.
546    * @return A boolean that indicates if the operation was successful.
547    */
548   function mint(
549     address _to,
550     uint256 _amount
551   )
552     hasMintPermission
553     canMint
554     public
555     returns (bool)
556   {
557     totalSupply_ = totalSupply_.add(_amount);
558     balances[_to] = balances[_to].add(_amount);
559     emit Mint(_to, _amount);
560     emit Transfer(address(0), _to, _amount);
561     return true;
562   }
563 
564   /**
565    * @dev Function to stop minting new tokens.
566    * @return True if the operation was successful.
567    */
568   function finishMinting() onlyOwner canMint public returns (bool) {
569     mintingFinished = true;
570     emit MintFinished();
571     return true;
572   }
573 }
574 
575 pragma solidity ^0.4.23;
576 
577 /**
578  * @title Whitelist
579  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
580  * @dev This simplifies the implementation of "user permissions".
581  */
582 contract Whitelist is Ownable, RBAC {
583   event WhitelistedAddressAdded(address addr);
584   event WhitelistedAddressRemoved(address addr);
585 
586   string public constant ROLE_WHITELISTED = "whitelist";
587 
588   /**
589    * @dev Throws if called by any account that's not whitelisted.
590    */
591   modifier onlyWhitelisted() {
592     checkRole(msg.sender, ROLE_WHITELISTED);
593     _;
594   }
595 
596   /**
597    * @dev add an address to the whitelist
598    * @param addr address
599    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
600    */
601   function addAddressToWhitelist(address addr)
602     onlyOwner
603     public
604   {
605     addRole(addr, ROLE_WHITELISTED);
606     emit WhitelistedAddressAdded(addr);
607   }
608 
609   /**
610    * @dev getter to determine if address is in whitelist
611    */
612   function whitelist(address addr)
613     public
614     view
615     returns (bool)
616   {
617     return hasRole(addr, ROLE_WHITELISTED);
618   }
619 
620   /**
621    * @dev add addresses to the whitelist
622    * @param addrs addresses
623    * @return true if at least one address was added to the whitelist,
624    * false if all addresses were already in the whitelist
625    */
626   function addAddressesToWhitelist(address[] addrs)
627     onlyOwner
628     public
629   {
630     for (uint256 i = 0; i < addrs.length; i++) {
631       addAddressToWhitelist(addrs[i]);
632     }
633   }
634 
635   /**
636    * @dev remove an address from the whitelist
637    * @param addr address
638    * @return true if the address was removed from the whitelist,
639    * false if the address wasn't in the whitelist in the first place
640    */
641   function removeAddressFromWhitelist(address addr)
642     onlyOwner
643     public
644   {
645     removeRole(addr, ROLE_WHITELISTED);
646     emit WhitelistedAddressRemoved(addr);
647   }
648 
649   /**
650    * @dev remove addresses from the whitelist
651    * @param addrs addresses
652    * @return true if at least one address was removed from the whitelist,
653    * false if all addresses weren't in the whitelist in the first place
654    */
655   function removeAddressesFromWhitelist(address[] addrs)
656     onlyOwner
657     public
658   {
659     for (uint256 i = 0; i < addrs.length; i++) {
660       removeAddressFromWhitelist(addrs[i]);
661     }
662   }
663 
664 }
665 
666 pragma solidity 0.4.24;
667 
668 contract DXCASH is StandardToken, MintableToken, BurnableToken, Whitelist {
669   string public symbol;
670   string public name;
671   uint8 public decimals;
672   address[] public WhiteListAddresses;
673 
674   constructor (
675     string symbol_,
676     string name_,
677     uint8 decimals_,
678     uint256 totalSupply,
679     address owner,
680     address supplyOwnerAddress
681   ) public {
682     symbol = symbol_;
683     name = name_;
684     decimals = decimals_;
685     totalSupply_ = totalSupply;
686     balances[supplyOwnerAddress] = totalSupply;
687     
688     WhiteListAddresses.push(owner); 
689     WhiteListAddresses.push(supplyOwnerAddress);
690 
691     addAddressesToWhitelist(WhiteListAddresses);
692     transferOwnership(owner);
693     emit Transfer(0x0, supplyOwnerAddress, totalSupply);
694   }
695   
696   modifier onlyRecipientWhitelisted(address _to) {
697     checkRole(_to, ROLE_WHITELISTED);
698     _;
699   }
700 
701   function transfer(
702     address _to,
703     uint256 _value
704   ) 
705     public
706     onlyRecipientWhitelisted(_to)
707     returns (bool) 
708   {
709     BasicToken.transfer(_to, _value);
710   }
711 
712   function transferFrom(
713     address _from,
714     address _to,
715     uint256 _value
716   )
717     public
718     onlyRecipientWhitelisted(_to)
719     returns (bool)
720   {
721     StandardToken.transferFrom(_from, _to, _value);
722   }
723 
724   function approve(
725     address _spender,
726     uint256 _value
727   ) public
728     onlyRecipientWhitelisted(_spender)
729     returns (bool)
730   {
731     StandardToken.approve(_spender, _value);
732   }
733 
734   function mint(
735     address _to,
736     uint256 _amount
737   )
738     hasMintPermission
739     canMint
740     onlyRecipientWhitelisted(_to)
741     public
742     returns (bool)
743   {
744     MintableToken.mint(_to, _amount);
745   }
746 
747 }