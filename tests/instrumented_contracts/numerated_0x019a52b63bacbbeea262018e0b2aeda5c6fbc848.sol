1 pragma solidity ^0.4.24;
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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
56 
57 /**
58  * @title Roles
59  * @author Francisco Giordano (@frangio)
60  * @dev Library for managing addresses assigned to a Role.
61  * See RBAC.sol for example usage.
62  */
63 library Roles {
64   struct Role {
65     mapping (address => bool) bearer;
66   }
67 
68   /**
69    * @dev give an address access to this role
70    */
71   function add(Role storage _role, address _addr)
72     internal
73   {
74     _role.bearer[_addr] = true;
75   }
76 
77   /**
78    * @dev remove an address' access to this role
79    */
80   function remove(Role storage _role, address _addr)
81     internal
82   {
83     _role.bearer[_addr] = false;
84   }
85 
86   /**
87    * @dev check if an address has this role
88    * // reverts
89    */
90   function check(Role storage _role, address _addr)
91     internal
92     view
93   {
94     require(has(_role, _addr));
95   }
96 
97   /**
98    * @dev check if an address has this role
99    * @return bool
100    */
101   function has(Role storage _role, address _addr)
102     internal
103     view
104     returns (bool)
105   {
106     return _role.bearer[_addr];
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
111 
112 /**
113  * @title RBAC (Role-Based Access Control)
114  * @author Matt Condon (@Shrugs)
115  * @dev Stores and provides setters and getters for roles and addresses.
116  * Supports unlimited numbers of roles and addresses.
117  * See //contracts/mocks/RBACMock.sol for an example of usage.
118  * This RBAC method uses strings to key roles. It may be beneficial
119  * for you to write your own implementation of this interface using Enums or similar.
120  */
121 contract RBAC {
122   using Roles for Roles.Role;
123 
124   mapping (string => Roles.Role) private roles;
125 
126   event RoleAdded(address indexed operator, string role);
127   event RoleRemoved(address indexed operator, string role);
128 
129   /**
130    * @dev reverts if addr does not have role
131    * @param _operator address
132    * @param _role the name of the role
133    * // reverts
134    */
135   function checkRole(address _operator, string _role)
136     public
137     view
138   {
139     roles[_role].check(_operator);
140   }
141 
142   /**
143    * @dev determine if addr has role
144    * @param _operator address
145    * @param _role the name of the role
146    * @return bool
147    */
148   function hasRole(address _operator, string _role)
149     public
150     view
151     returns (bool)
152   {
153     return roles[_role].has(_operator);
154   }
155 
156   /**
157    * @dev add a role to an address
158    * @param _operator address
159    * @param _role the name of the role
160    */
161   function addRole(address _operator, string _role)
162     internal
163   {
164     roles[_role].add(_operator);
165     emit RoleAdded(_operator, _role);
166   }
167 
168   /**
169    * @dev remove a role from an address
170    * @param _operator address
171    * @param _role the name of the role
172    */
173   function removeRole(address _operator, string _role)
174     internal
175   {
176     roles[_role].remove(_operator);
177     emit RoleRemoved(_operator, _role);
178   }
179 
180   /**
181    * @dev modifier to scope access to a single role (uses msg.sender as addr)
182    * @param _role the name of the role
183    * // reverts
184    */
185   modifier onlyRole(string _role)
186   {
187     checkRole(msg.sender, _role);
188     _;
189   }
190 
191   /**
192    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
193    * @param _roles the names of the roles to scope access to
194    * // reverts
195    *
196    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
197    *  see: https://github.com/ethereum/solidity/issues/2467
198    */
199   // modifier onlyRoles(string[] _roles) {
200   //     bool hasAnyRole = false;
201   //     for (uint8 i = 0; i < _roles.length; i++) {
202   //         if (hasRole(msg.sender, _roles[i])) {
203   //             hasAnyRole = true;
204   //             break;
205   //         }
206   //     }
207 
208   //     require(hasAnyRole);
209 
210   //     _;
211   // }
212 }
213 
214 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
215 
216 /**
217  * @title Ownable
218  * @dev The Ownable contract has an owner address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  */
221 contract Ownable {
222   address public owner;
223 
224 
225   event OwnershipRenounced(address indexed previousOwner);
226   event OwnershipTransferred(
227     address indexed previousOwner,
228     address indexed newOwner
229   );
230 
231 
232   /**
233    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234    * account.
235    */
236   constructor() public {
237     owner = msg.sender;
238   }
239 
240   /**
241    * @dev Throws if called by any account other than the owner.
242    */
243   modifier onlyOwner() {
244     require(msg.sender == owner);
245     _;
246   }
247 
248   /**
249    * @dev Allows the current owner to relinquish control of the contract.
250    * @notice Renouncing to ownership will leave the contract without an owner.
251    * It will not be possible to call the functions with the `onlyOwner`
252    * modifier anymore.
253    */
254   function renounceOwnership() public onlyOwner {
255     emit OwnershipRenounced(owner);
256     owner = address(0);
257   }
258 
259   /**
260    * @dev Allows the current owner to transfer control of the contract to a newOwner.
261    * @param _newOwner The address to transfer ownership to.
262    */
263   function transferOwnership(address _newOwner) public onlyOwner {
264     _transferOwnership(_newOwner);
265   }
266 
267   /**
268    * @dev Transfers control of the contract to a newOwner.
269    * @param _newOwner The address to transfer ownership to.
270    */
271   function _transferOwnership(address _newOwner) internal {
272     require(_newOwner != address(0));
273     emit OwnershipTransferred(owner, _newOwner);
274     owner = _newOwner;
275   }
276 }
277 
278 // File: contracts/crowdsale/utils/Contributions.sol
279 
280 contract Contributions is RBAC, Ownable {
281   using SafeMath for uint256;
282 
283   uint256 private constant TIER_DELETED = 999;
284   string public constant ROLE_MINTER = "minter";
285   string public constant ROLE_OPERATOR = "operator";
286 
287   uint256 public tierLimit;
288 
289   modifier onlyMinter () {
290     checkRole(msg.sender, ROLE_MINTER);
291     _;
292   }
293 
294   modifier onlyOperator () {
295     checkRole(msg.sender, ROLE_OPERATOR);
296     _;
297   }
298 
299   uint256 public totalSoldTokens;
300   mapping(address => uint256) public tokenBalances;
301   mapping(address => uint256) public ethContributions;
302   mapping(address => uint256) private _whitelistTier;
303   address[] public tokenAddresses;
304   address[] public ethAddresses;
305   address[] private whitelistAddresses;
306 
307   constructor(uint256 _tierLimit) public {
308     addRole(owner, ROLE_OPERATOR);
309     tierLimit = _tierLimit;
310   }
311 
312   function addMinter(address minter) external onlyOwner {
313     addRole(minter, ROLE_MINTER);
314   }
315 
316   function removeMinter(address minter) external onlyOwner {
317     removeRole(minter, ROLE_MINTER);
318   }
319 
320   function addOperator(address _operator) external onlyOwner {
321     addRole(_operator, ROLE_OPERATOR);
322   }
323 
324   function removeOperator(address _operator) external onlyOwner {
325     removeRole(_operator, ROLE_OPERATOR);
326   }
327 
328   function addTokenBalance(
329     address _address,
330     uint256 _tokenAmount
331   )
332     external
333     onlyMinter
334   {
335     if (tokenBalances[_address] == 0) {
336       tokenAddresses.push(_address);
337     }
338     tokenBalances[_address] = tokenBalances[_address].add(_tokenAmount);
339     totalSoldTokens = totalSoldTokens.add(_tokenAmount);
340   }
341 
342   function addEthContribution(
343     address _address,
344     uint256 _weiAmount
345   )
346     external
347     onlyMinter
348   {
349     if (ethContributions[_address] == 0) {
350       ethAddresses.push(_address);
351     }
352     ethContributions[_address] = ethContributions[_address].add(_weiAmount);
353   }
354 
355   function setTierLimit(uint256 _newTierLimit) external onlyOperator {
356     require(_newTierLimit > 0, "Tier must be greater than zero");
357 
358     tierLimit = _newTierLimit;
359   }
360 
361   function addToWhitelist(
362     address _investor,
363     uint256 _tier
364   )
365     external
366     onlyOperator
367   {
368     require(_tier == 1 || _tier == 2, "Only two tier level available");
369     if (_whitelistTier[_investor] == 0) {
370       whitelistAddresses.push(_investor);
371     }
372     _whitelistTier[_investor] = _tier;
373   }
374 
375   function removeFromWhitelist(address _investor) external onlyOperator {
376     _whitelistTier[_investor] = TIER_DELETED;
377   }
378 
379   function whitelistTier(address _investor) external view returns (uint256) {
380     return _whitelistTier[_investor] <= 2 ? _whitelistTier[_investor] : 0;
381   }
382 
383   function getWhitelistedAddresses(
384     uint256 _tier
385   )
386     external
387     view
388     returns (address[])
389   {
390     address[] memory tmp = new address[](whitelistAddresses.length);
391 
392     uint y = 0;
393     if (_tier == 1 || _tier == 2) {
394       uint len = whitelistAddresses.length;
395       for (uint i = 0; i < len; i++) {
396         if (_whitelistTier[whitelistAddresses[i]] == _tier) {
397           tmp[y] = whitelistAddresses[i];
398           y++;
399         }
400       }
401     }
402 
403     address[] memory toReturn = new address[](y);
404 
405     for (uint k = 0; k < y; k++) {
406       toReturn[k] = tmp[k];
407     }
408 
409     return toReturn;
410   }
411 
412   function isAllowedPurchase(
413     address _beneficiary,
414     uint256 _weiAmount
415   )
416     external
417     view
418     returns (bool)
419   {
420     if (_whitelistTier[_beneficiary] == 2) {
421       return true;
422     } else if (_whitelistTier[_beneficiary] == 1 && ethContributions[_beneficiary].add(_weiAmount) <= tierLimit) {
423       return true;
424     }
425 
426     return false;
427   }
428 
429   function getTokenAddressesLength() external view returns (uint) {
430     return tokenAddresses.length;
431   }
432 
433   function getEthAddressesLength() external view returns (uint) {
434     return ethAddresses.length;
435   }
436 }
437 
438 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
439 
440 /**
441  * @title ERC20Basic
442  * @dev Simpler version of ERC20 interface
443  * See https://github.com/ethereum/EIPs/issues/179
444  */
445 contract ERC20Basic {
446   function totalSupply() public view returns (uint256);
447   function balanceOf(address _who) public view returns (uint256);
448   function transfer(address _to, uint256 _value) public returns (bool);
449   event Transfer(address indexed from, address indexed to, uint256 value);
450 }
451 
452 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
453 
454 /**
455  * @title ERC20 interface
456  * @dev see https://github.com/ethereum/EIPs/issues/20
457  */
458 contract ERC20 is ERC20Basic {
459   function allowance(address _owner, address _spender)
460     public view returns (uint256);
461 
462   function transferFrom(address _from, address _to, uint256 _value)
463     public returns (bool);
464 
465   function approve(address _spender, uint256 _value) public returns (bool);
466   event Approval(
467     address indexed owner,
468     address indexed spender,
469     uint256 value
470   );
471 }
472 
473 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
474 
475 /**
476  * @title DetailedERC20 token
477  * @dev The decimals are only for visualization purposes.
478  * All the operations are done using the smallest and indivisible token unit,
479  * just as on Ethereum all the operations are done in wei.
480  */
481 contract DetailedERC20 is ERC20 {
482   string public name;
483   string public symbol;
484   uint8 public decimals;
485 
486   constructor(string _name, string _symbol, uint8 _decimals) public {
487     name = _name;
488     symbol = _symbol;
489     decimals = _decimals;
490   }
491 }
492 
493 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
494 
495 /**
496  * @title Basic token
497  * @dev Basic version of StandardToken, with no allowances.
498  */
499 contract BasicToken is ERC20Basic {
500   using SafeMath for uint256;
501 
502   mapping(address => uint256) internal balances;
503 
504   uint256 internal totalSupply_;
505 
506   /**
507   * @dev Total number of tokens in existence
508   */
509   function totalSupply() public view returns (uint256) {
510     return totalSupply_;
511   }
512 
513   /**
514   * @dev Transfer token for a specified address
515   * @param _to The address to transfer to.
516   * @param _value The amount to be transferred.
517   */
518   function transfer(address _to, uint256 _value) public returns (bool) {
519     require(_value <= balances[msg.sender]);
520     require(_to != address(0));
521 
522     balances[msg.sender] = balances[msg.sender].sub(_value);
523     balances[_to] = balances[_to].add(_value);
524     emit Transfer(msg.sender, _to, _value);
525     return true;
526   }
527 
528   /**
529   * @dev Gets the balance of the specified address.
530   * @param _owner The address to query the the balance of.
531   * @return An uint256 representing the amount owned by the passed address.
532   */
533   function balanceOf(address _owner) public view returns (uint256) {
534     return balances[_owner];
535   }
536 
537 }
538 
539 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
540 
541 /**
542  * @title Standard ERC20 token
543  *
544  * @dev Implementation of the basic standard token.
545  * https://github.com/ethereum/EIPs/issues/20
546  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
547  */
548 contract StandardToken is ERC20, BasicToken {
549 
550   mapping (address => mapping (address => uint256)) internal allowed;
551 
552 
553   /**
554    * @dev Transfer tokens from one address to another
555    * @param _from address The address which you want to send tokens from
556    * @param _to address The address which you want to transfer to
557    * @param _value uint256 the amount of tokens to be transferred
558    */
559   function transferFrom(
560     address _from,
561     address _to,
562     uint256 _value
563   )
564     public
565     returns (bool)
566   {
567     require(_value <= balances[_from]);
568     require(_value <= allowed[_from][msg.sender]);
569     require(_to != address(0));
570 
571     balances[_from] = balances[_from].sub(_value);
572     balances[_to] = balances[_to].add(_value);
573     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
574     emit Transfer(_from, _to, _value);
575     return true;
576   }
577 
578   /**
579    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
580    * Beware that changing an allowance with this method brings the risk that someone may use both the old
581    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
582    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
583    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
584    * @param _spender The address which will spend the funds.
585    * @param _value The amount of tokens to be spent.
586    */
587   function approve(address _spender, uint256 _value) public returns (bool) {
588     allowed[msg.sender][_spender] = _value;
589     emit Approval(msg.sender, _spender, _value);
590     return true;
591   }
592 
593   /**
594    * @dev Function to check the amount of tokens that an owner allowed to a spender.
595    * @param _owner address The address which owns the funds.
596    * @param _spender address The address which will spend the funds.
597    * @return A uint256 specifying the amount of tokens still available for the spender.
598    */
599   function allowance(
600     address _owner,
601     address _spender
602    )
603     public
604     view
605     returns (uint256)
606   {
607     return allowed[_owner][_spender];
608   }
609 
610   /**
611    * @dev Increase the amount of tokens that an owner allowed to a spender.
612    * approve should be called when allowed[_spender] == 0. To increment
613    * allowed value is better to use this function to avoid 2 calls (and wait until
614    * the first transaction is mined)
615    * From MonolithDAO Token.sol
616    * @param _spender The address which will spend the funds.
617    * @param _addedValue The amount of tokens to increase the allowance by.
618    */
619   function increaseApproval(
620     address _spender,
621     uint256 _addedValue
622   )
623     public
624     returns (bool)
625   {
626     allowed[msg.sender][_spender] = (
627       allowed[msg.sender][_spender].add(_addedValue));
628     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
629     return true;
630   }
631 
632   /**
633    * @dev Decrease the amount of tokens that an owner allowed to a spender.
634    * approve should be called when allowed[_spender] == 0. To decrement
635    * allowed value is better to use this function to avoid 2 calls (and wait until
636    * the first transaction is mined)
637    * From MonolithDAO Token.sol
638    * @param _spender The address which will spend the funds.
639    * @param _subtractedValue The amount of tokens to decrease the allowance by.
640    */
641   function decreaseApproval(
642     address _spender,
643     uint256 _subtractedValue
644   )
645     public
646     returns (bool)
647   {
648     uint256 oldValue = allowed[msg.sender][_spender];
649     if (_subtractedValue >= oldValue) {
650       allowed[msg.sender][_spender] = 0;
651     } else {
652       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
653     }
654     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
655     return true;
656   }
657 
658 }
659 
660 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
661 
662 /**
663  * @title Mintable token
664  * @dev Simple ERC20 Token example, with mintable token creation
665  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
666  */
667 contract MintableToken is StandardToken, Ownable {
668   event Mint(address indexed to, uint256 amount);
669   event MintFinished();
670 
671   bool public mintingFinished = false;
672 
673 
674   modifier canMint() {
675     require(!mintingFinished);
676     _;
677   }
678 
679   modifier hasMintPermission() {
680     require(msg.sender == owner);
681     _;
682   }
683 
684   /**
685    * @dev Function to mint tokens
686    * @param _to The address that will receive the minted tokens.
687    * @param _amount The amount of tokens to mint.
688    * @return A boolean that indicates if the operation was successful.
689    */
690   function mint(
691     address _to,
692     uint256 _amount
693   )
694     public
695     hasMintPermission
696     canMint
697     returns (bool)
698   {
699     totalSupply_ = totalSupply_.add(_amount);
700     balances[_to] = balances[_to].add(_amount);
701     emit Mint(_to, _amount);
702     emit Transfer(address(0), _to, _amount);
703     return true;
704   }
705 
706   /**
707    * @dev Function to stop minting new tokens.
708    * @return True if the operation was successful.
709    */
710   function finishMinting() public onlyOwner canMint returns (bool) {
711     mintingFinished = true;
712     emit MintFinished();
713     return true;
714   }
715 }
716 
717 // File: openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol
718 
719 /**
720  * @title RBACMintableToken
721  * @author Vittorio Minacori (@vittominacori)
722  * @dev Mintable Token, with RBAC minter permissions
723  */
724 contract RBACMintableToken is MintableToken, RBAC {
725   /**
726    * A constant role name for indicating minters.
727    */
728   string public constant ROLE_MINTER = "minter";
729 
730   /**
731    * @dev override the Mintable token modifier to add role based logic
732    */
733   modifier hasMintPermission() {
734     checkRole(msg.sender, ROLE_MINTER);
735     _;
736   }
737 
738   /**
739    * @dev add a minter role to an address
740    * @param _minter address
741    */
742   function addMinter(address _minter) public onlyOwner {
743     addRole(_minter, ROLE_MINTER);
744   }
745 
746   /**
747    * @dev remove a minter role from an address
748    * @param _minter address
749    */
750   function removeMinter(address _minter) public onlyOwner {
751     removeRole(_minter, ROLE_MINTER);
752   }
753 }
754 
755 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
756 
757 /**
758  * @title Burnable Token
759  * @dev Token that can be irreversibly burned (destroyed).
760  */
761 contract BurnableToken is BasicToken {
762 
763   event Burn(address indexed burner, uint256 value);
764 
765   /**
766    * @dev Burns a specific amount of tokens.
767    * @param _value The amount of token to be burned.
768    */
769   function burn(uint256 _value) public {
770     _burn(msg.sender, _value);
771   }
772 
773   function _burn(address _who, uint256 _value) internal {
774     require(_value <= balances[_who]);
775     // no need to require value <= totalSupply, since that would imply the
776     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
777 
778     balances[_who] = balances[_who].sub(_value);
779     totalSupply_ = totalSupply_.sub(_value);
780     emit Burn(_who, _value);
781     emit Transfer(_who, address(0), _value);
782   }
783 }
784 
785 // File: openzeppelin-solidity/contracts/AddressUtils.sol
786 
787 /**
788  * Utility library of inline functions on addresses
789  */
790 library AddressUtils {
791 
792   /**
793    * Returns whether the target address is a contract
794    * @dev This function will return false if invoked during the constructor of a contract,
795    * as the code is not actually created until after the constructor finishes.
796    * @param _addr address to check
797    * @return whether the target address is a contract
798    */
799   function isContract(address _addr) internal view returns (bool) {
800     uint256 size;
801     // XXX Currently there is no better way to check if there is a contract in an address
802     // than to check the size of the code at that address.
803     // See https://ethereum.stackexchange.com/a/14016/36603
804     // for more details about how this works.
805     // TODO Check this again before the Serenity release, because all addresses will be
806     // contracts then.
807     // solium-disable-next-line security/no-inline-assembly
808     assembly { size := extcodesize(_addr) }
809     return size > 0;
810   }
811 
812 }
813 
814 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
815 
816 /**
817  * @title ERC165
818  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
819  */
820 interface ERC165 {
821 
822   /**
823    * @notice Query if a contract implements an interface
824    * @param _interfaceId The interface identifier, as specified in ERC-165
825    * @dev Interface identification is specified in ERC-165. This function
826    * uses less than 30,000 gas.
827    */
828   function supportsInterface(bytes4 _interfaceId)
829     external
830     view
831     returns (bool);
832 }
833 
834 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
835 
836 /**
837  * @title SupportsInterfaceWithLookup
838  * @author Matt Condon (@shrugs)
839  * @dev Implements ERC165 using a lookup table.
840  */
841 contract SupportsInterfaceWithLookup is ERC165 {
842 
843   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
844   /**
845    * 0x01ffc9a7 ===
846    *   bytes4(keccak256('supportsInterface(bytes4)'))
847    */
848 
849   /**
850    * @dev a mapping of interface id to whether or not it's supported
851    */
852   mapping(bytes4 => bool) internal supportedInterfaces;
853 
854   /**
855    * @dev A contract implementing SupportsInterfaceWithLookup
856    * implement ERC165 itself
857    */
858   constructor()
859     public
860   {
861     _registerInterface(InterfaceId_ERC165);
862   }
863 
864   /**
865    * @dev implement supportsInterface(bytes4) using a lookup table
866    */
867   function supportsInterface(bytes4 _interfaceId)
868     external
869     view
870     returns (bool)
871   {
872     return supportedInterfaces[_interfaceId];
873   }
874 
875   /**
876    * @dev private method for registering an interface
877    */
878   function _registerInterface(bytes4 _interfaceId)
879     internal
880   {
881     require(_interfaceId != 0xffffffff);
882     supportedInterfaces[_interfaceId] = true;
883   }
884 }
885 
886 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
887 
888 /**
889  * @title ERC1363 interface
890  * @author Vittorio Minacori (https://github.com/vittominacori)
891  * @dev Interface for a Payable Token contract as defined in
892  *  https://github.com/ethereum/EIPs/issues/1363
893  */
894 contract ERC1363 is ERC20, ERC165 {
895   /*
896    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
897    * 0x4bbee2df ===
898    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
899    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
900    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
901    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
902    */
903 
904   /*
905    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
906    * 0xfb9ec8ce ===
907    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
908    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
909    */
910 
911   /**
912    * @notice Transfer tokens from `msg.sender` to another address
913    *  and then call `onTransferReceived` on receiver
914    * @param _to address The address which you want to transfer to
915    * @param _value uint256 The amount of tokens to be transferred
916    * @return true unless throwing
917    */
918   function transferAndCall(address _to, uint256 _value) public returns (bool);
919 
920   /**
921    * @notice Transfer tokens from `msg.sender` to another address
922    *  and then call `onTransferReceived` on receiver
923    * @param _to address The address which you want to transfer to
924    * @param _value uint256 The amount of tokens to be transferred
925    * @param _data bytes Additional data with no specified format, sent in call to `_to`
926    * @return true unless throwing
927    */
928   function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
929 
930   /**
931    * @notice Transfer tokens from one address to another
932    *  and then call `onTransferReceived` on receiver
933    * @param _from address The address which you want to send tokens from
934    * @param _to address The address which you want to transfer to
935    * @param _value uint256 The amount of tokens to be transferred
936    * @return true unless throwing
937    */
938   function transferFromAndCall(address _from, address _to, uint256 _value) public returns (bool); // solium-disable-line max-len
939 
940 
941   /**
942    * @notice Transfer tokens from one address to another
943    *  and then call `onTransferReceived` on receiver
944    * @param _from address The address which you want to send tokens from
945    * @param _to address The address which you want to transfer to
946    * @param _value uint256 The amount of tokens to be transferred
947    * @param _data bytes Additional data with no specified format, sent in call to `_to`
948    * @return true unless throwing
949    */
950   function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len, arg-overflow
951 
952   /**
953    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
954    *  and then call `onApprovalReceived` on spender
955    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
956    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
957    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
958    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
959    * @param _spender address The address which will spend the funds
960    * @param _value uint256 The amount of tokens to be spent
961    */
962   function approveAndCall(address _spender, uint256 _value) public returns (bool); // solium-disable-line max-len
963 
964   /**
965    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
966    *  and then call `onApprovalReceived` on spender
967    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
968    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
969    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
970    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
971    * @param _spender address The address which will spend the funds
972    * @param _value uint256 The amount of tokens to be spent
973    * @param _data bytes Additional data with no specified format, sent in call to `_spender`
974    */
975   function approveAndCall(address _spender, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
976 }
977 
978 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Receiver.sol
979 
980 /**
981  * @title ERC1363Receiver interface
982  * @author Vittorio Minacori (https://github.com/vittominacori)
983  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
984  *  from ERC1363 token contracts as defined in
985  *  https://github.com/ethereum/EIPs/issues/1363
986  */
987 contract ERC1363Receiver {
988   /*
989    * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
990    * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
991    */
992 
993   /**
994    * @notice Handle the receipt of ERC1363 tokens
995    * @dev Any ERC1363 smart contract calls this function on the recipient
996    *  after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
997    *  transfer. Return of other than the magic value MUST result in the
998    *  transaction being reverted.
999    *  Note: the token contract address is always the message sender.
1000    * @param _operator address The address which called `transferAndCall` or `transferFromAndCall` function
1001    * @param _from address The address which are token transferred from
1002    * @param _value uint256 The amount of tokens transferred
1003    * @param _data bytes Additional data with no specified format
1004    * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1005    *  unless throwing
1006    */
1007   function onTransferReceived(address _operator, address _from, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len, arg-overflow
1008 }
1009 
1010 // File: erc-payable-token/contracts/token/ERC1363/ERC1363Spender.sol
1011 
1012 /**
1013  * @title ERC1363Spender interface
1014  * @author Vittorio Minacori (https://github.com/vittominacori)
1015  * @dev Interface for any contract that wants to support approveAndCall
1016  *  from ERC1363 token contracts as defined in
1017  *  https://github.com/ethereum/EIPs/issues/1363
1018  */
1019 contract ERC1363Spender {
1020   /*
1021    * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
1022    * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
1023    */
1024 
1025   /**
1026    * @notice Handle the approval of ERC1363 tokens
1027    * @dev Any ERC1363 smart contract calls this function on the recipient
1028    *  after an `approve`. This function MAY throw to revert and reject the
1029    *  approval. Return of other than the magic value MUST result in the
1030    *  transaction being reverted.
1031    *  Note: the token contract address is always the message sender.
1032    * @param _owner address The address which called `approveAndCall` function
1033    * @param _value uint256 The amount of tokens to be spent
1034    * @param _data bytes Additional data with no specified format
1035    * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1036    *  unless throwing
1037    */
1038   function onApprovalReceived(address _owner, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len
1039 }
1040 
1041 // File: erc-payable-token/contracts/token/ERC1363/ERC1363BasicToken.sol
1042 
1043 // solium-disable-next-line max-len
1044 
1045 
1046 
1047 
1048 
1049 
1050 
1051 /**
1052  * @title ERC1363BasicToken
1053  * @author Vittorio Minacori (https://github.com/vittominacori)
1054  * @dev Implementation of an ERC1363 interface
1055  */
1056 contract ERC1363BasicToken is SupportsInterfaceWithLookup, StandardToken, ERC1363 { // solium-disable-line max-len
1057   using AddressUtils for address;
1058 
1059   /*
1060    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1061    * 0x4bbee2df ===
1062    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1063    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1064    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1065    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1066    */
1067   bytes4 internal constant InterfaceId_ERC1363Transfer = 0x4bbee2df;
1068 
1069   /*
1070    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1071    * 0xfb9ec8ce ===
1072    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1073    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1074    */
1075   bytes4 internal constant InterfaceId_ERC1363Approve = 0xfb9ec8ce;
1076 
1077   // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1078   // which can be also obtained as `ERC1363Receiver(0).onTransferReceived.selector`
1079   bytes4 private constant ERC1363_RECEIVED = 0x88a7ca5c;
1080 
1081   // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1082   // which can be also obtained as `ERC1363Spender(0).onApprovalReceived.selector`
1083   bytes4 private constant ERC1363_APPROVED = 0x7b04a2d0;
1084 
1085   constructor() public {
1086     // register the supported interfaces to conform to ERC1363 via ERC165
1087     _registerInterface(InterfaceId_ERC1363Transfer);
1088     _registerInterface(InterfaceId_ERC1363Approve);
1089   }
1090 
1091   function transferAndCall(
1092     address _to,
1093     uint256 _value
1094   )
1095     public
1096     returns (bool)
1097   {
1098     return transferAndCall(_to, _value, "");
1099   }
1100 
1101   function transferAndCall(
1102     address _to,
1103     uint256 _value,
1104     bytes _data
1105   )
1106     public
1107     returns (bool)
1108   {
1109     require(transfer(_to, _value));
1110     require(
1111       checkAndCallTransfer(
1112         msg.sender,
1113         _to,
1114         _value,
1115         _data
1116       )
1117     );
1118     return true;
1119   }
1120 
1121   function transferFromAndCall(
1122     address _from,
1123     address _to,
1124     uint256 _value
1125   )
1126     public
1127     returns (bool)
1128   {
1129     // solium-disable-next-line arg-overflow
1130     return transferFromAndCall(_from, _to, _value, "");
1131   }
1132 
1133   function transferFromAndCall(
1134     address _from,
1135     address _to,
1136     uint256 _value,
1137     bytes _data
1138   )
1139     public
1140     returns (bool)
1141   {
1142     require(transferFrom(_from, _to, _value));
1143     require(
1144       checkAndCallTransfer(
1145         _from,
1146         _to,
1147         _value,
1148         _data
1149       )
1150     );
1151     return true;
1152   }
1153 
1154   function approveAndCall(
1155     address _spender,
1156     uint256 _value
1157   )
1158     public
1159     returns (bool)
1160   {
1161     return approveAndCall(_spender, _value, "");
1162   }
1163 
1164   function approveAndCall(
1165     address _spender,
1166     uint256 _value,
1167     bytes _data
1168   )
1169     public
1170     returns (bool)
1171   {
1172     approve(_spender, _value);
1173     require(
1174       checkAndCallApprove(
1175         _spender,
1176         _value,
1177         _data
1178       )
1179     );
1180     return true;
1181   }
1182 
1183   /**
1184    * @dev Internal function to invoke `onTransferReceived` on a target address
1185    *  The call is not executed if the target address is not a contract
1186    * @param _from address Representing the previous owner of the given token value
1187    * @param _to address Target address that will receive the tokens
1188    * @param _value uint256 The amount mount of tokens to be transferred
1189    * @param _data bytes Optional data to send along with the call
1190    * @return whether the call correctly returned the expected magic value
1191    */
1192   function checkAndCallTransfer(
1193     address _from,
1194     address _to,
1195     uint256 _value,
1196     bytes _data
1197   )
1198     internal
1199     returns (bool)
1200   {
1201     if (!_to.isContract()) {
1202       return false;
1203     }
1204     bytes4 retval = ERC1363Receiver(_to).onTransferReceived(
1205       msg.sender, _from, _value, _data
1206     );
1207     return (retval == ERC1363_RECEIVED);
1208   }
1209 
1210   /**
1211    * @dev Internal function to invoke `onApprovalReceived` on a target address
1212    *  The call is not executed if the target address is not a contract
1213    * @param _spender address The address which will spend the funds
1214    * @param _value uint256 The amount of tokens to be spent
1215    * @param _data bytes Optional data to send along with the call
1216    * @return whether the call correctly returned the expected magic value
1217    */
1218   function checkAndCallApprove(
1219     address _spender,
1220     uint256 _value,
1221     bytes _data
1222   )
1223     internal
1224     returns (bool)
1225   {
1226     if (!_spender.isContract()) {
1227       return false;
1228     }
1229     bytes4 retval = ERC1363Spender(_spender).onApprovalReceived(
1230       msg.sender, _value, _data
1231     );
1232     return (retval == ERC1363_APPROVED);
1233   }
1234 }
1235 
1236 // File: eth-token-recover/contracts/TokenRecover.sol
1237 
1238 /**
1239  * @title TokenRecover
1240  * @author Vittorio Minacori (https://github.com/vittominacori)
1241  * @dev Allow to recover any ERC20 sent into the contract for error
1242  */
1243 contract TokenRecover is Ownable {
1244 
1245   /**
1246    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1247    * @param _tokenAddress address The token contract address
1248    * @param _tokens Number of tokens to be sent
1249    * @return bool
1250    */
1251   function recoverERC20(
1252     address _tokenAddress,
1253     uint256 _tokens
1254   )
1255   public
1256   onlyOwner
1257   returns (bool success)
1258   {
1259     return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
1260   }
1261 }
1262 
1263 // File: contracts/token/FidelityHouseToken.sol
1264 
1265 // solium-disable-next-line max-len
1266 contract FidelityHouseToken is DetailedERC20, RBACMintableToken, BurnableToken, ERC1363BasicToken, TokenRecover {
1267 
1268   uint256 public lockedUntil;
1269   mapping(address => uint256) internal lockedBalances;
1270 
1271   modifier canTransfer(address _from, uint256 _value) {
1272     require(
1273       mintingFinished,
1274       "Minting should be finished before transfer."
1275     );
1276     require(
1277       _value <= balances[_from].sub(lockedBalanceOf(_from)),
1278       "Can't transfer more than unlocked tokens"
1279     );
1280     _;
1281   }
1282 
1283   constructor(uint256 _lockedUntil)
1284     DetailedERC20("FidelityHouse Token", "FIH", 18)
1285     public
1286   {
1287     lockedUntil = _lockedUntil;
1288   }
1289 
1290   /**
1291    * @dev Gets the locked balance of the specified address.
1292    * @param _owner The address to query the balance of.
1293    * @return An uint256 representing the locked amount owned by the passed address.
1294    */
1295   function lockedBalanceOf(address _owner) public view returns (uint256) {
1296     // solium-disable-next-line security/no-block-members
1297     return block.timestamp <= lockedUntil ? lockedBalances[_owner] : 0;
1298   }
1299 
1300   /**
1301    * @dev Function to mint and lock tokens
1302    * @param _to The address that will receive the minted tokens.
1303    * @param _amount The amount of tokens to mint.
1304    * @return A boolean that indicates if the operation was successful.
1305    */
1306   function mintAndLock(
1307     address _to,
1308     uint256 _amount
1309   )
1310     public
1311     hasMintPermission
1312     canMint
1313     returns (bool)
1314   {
1315     lockedBalances[_to] = lockedBalances[_to].add(_amount);
1316     return super.mint(_to, _amount);
1317   }
1318 
1319   function transfer(
1320     address _to,
1321     uint256 _value
1322   )
1323     public
1324     canTransfer(msg.sender, _value)
1325     returns (bool)
1326   {
1327     return super.transfer(_to, _value);
1328   }
1329 
1330   function transferFrom(
1331     address _from,
1332     address _to,
1333     uint256 _value
1334   )
1335     public
1336     canTransfer(_from, _value)
1337     returns (bool)
1338   {
1339     return super.transferFrom(_from, _to, _value);
1340   }
1341 }
1342 
1343 // File: contracts/crowdsale/FidelityHousePrivateSale.sol
1344 
1345 contract FidelityHousePrivateSale is TokenRecover {
1346   using SafeMath for uint256;
1347 
1348   mapping (address => uint256) public sentTokens;
1349 
1350   FidelityHouseToken public token;
1351   Contributions public contributions;
1352 
1353   constructor(address _token, address _contributions) public {
1354     require(
1355       _token != address(0),
1356       "Token shouldn't be the zero address."
1357     );
1358     require(
1359       _contributions != address(0),
1360       "Contributions address can't be the zero address."
1361     );
1362 
1363     token = FidelityHouseToken(_token);
1364     contributions = Contributions(_contributions);
1365   }
1366 
1367   function multiSend(
1368     address[] _addresses,
1369     uint256[] _amounts,
1370     uint256[] _bonuses
1371   )
1372     external
1373     onlyOwner
1374   {
1375     require(
1376       _addresses.length > 0,
1377       "Addresses array shouldn't be empty."
1378     );
1379     require(
1380       _amounts.length > 0,
1381       "Amounts array shouldn't be empty."
1382     );
1383     require(
1384       _bonuses.length > 0,
1385       "Bonuses array shouldn't be empty."
1386     );
1387     require(
1388       _addresses.length == _amounts.length && _addresses.length == _bonuses.length,
1389       "Arrays should have the same length."
1390     );
1391 
1392     uint len = _addresses.length;
1393     for (uint i = 0; i < len; i++) {
1394       address _beneficiary = _addresses[i];
1395       uint256 _tokenAmount = _amounts[i];
1396       uint256 _bonusAmount = _bonuses[i];
1397 
1398       if (sentTokens[_beneficiary] == 0) {
1399         uint256 totalTokens = _tokenAmount.add(_bonusAmount);
1400         sentTokens[_beneficiary] = totalTokens;
1401         token.mintAndLock(_beneficiary, _tokenAmount);
1402         token.mint(_beneficiary, _bonusAmount);
1403         contributions.addTokenBalance(_beneficiary, totalTokens);
1404       }
1405     }
1406   }
1407 }