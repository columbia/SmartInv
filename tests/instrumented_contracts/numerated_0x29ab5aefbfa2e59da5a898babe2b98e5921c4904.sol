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
688 
689 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
690 
691 /**
692  * @title Crowdsale
693  * @dev Crowdsale is a base contract for managing a token crowdsale,
694  * allowing investors to purchase tokens with ether. This contract implements
695  * such functionality in its most fundamental form and can be extended to provide additional
696  * functionality and/or custom behavior.
697  * The external interface represents the basic interface for purchasing tokens, and conform
698  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
699  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
700  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
701  * behavior.
702  */
703 contract Crowdsale {
704   using SafeMath for uint256;
705 
706   // The token being sold
707   ERC20 public token;
708 
709   // Address where funds are collected
710   address public wallet;
711 
712   // How many token units a buyer gets per wei.
713   // The rate is the conversion between wei and the smallest and indivisible token unit.
714   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
715   // 1 wei will give you 1 unit, or 0.001 TOK.
716   uint256 public rate;
717 
718   // Amount of wei raised
719   uint256 public weiRaised;
720 
721   /**
722    * Event for token purchase logging
723    * @param purchaser who paid for the tokens
724    * @param beneficiary who got the tokens
725    * @param value weis paid for purchase
726    * @param amount amount of tokens purchased
727    */
728   event TokenPurchase(
729     address indexed purchaser,
730     address indexed beneficiary,
731     uint256 value,
732     uint256 amount
733   );
734 
735   /**
736    * @param _rate Number of token units a buyer gets per wei
737    * @param _wallet Address where collected funds will be forwarded to
738    * @param _token Address of the token being sold
739    */
740   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
741     require(_rate > 0);
742     require(_wallet != address(0));
743     require(_token != address(0));
744 
745     rate = _rate;
746     wallet = _wallet;
747     token = _token;
748   }
749 
750   // -----------------------------------------
751   // Crowdsale external interface
752   // -----------------------------------------
753 
754   /**
755    * @dev fallback function ***DO NOT OVERRIDE***
756    */
757   function () external payable {
758     buyTokens(msg.sender);
759   }
760 
761   /**
762    * @dev low level token purchase ***DO NOT OVERRIDE***
763    * @param _beneficiary Address performing the token purchase
764    */
765   function buyTokens(address _beneficiary) public payable {
766 
767     uint256 weiAmount = msg.value;
768     _preValidatePurchase(_beneficiary, weiAmount);
769 
770     // calculate token amount to be created
771     uint256 tokens = _getTokenAmount(weiAmount);
772 
773     // update state
774     weiRaised = weiRaised.add(weiAmount);
775 
776     _processPurchase(_beneficiary, tokens);
777     emit TokenPurchase(
778       msg.sender,
779       _beneficiary,
780       weiAmount,
781       tokens
782     );
783 
784     _updatePurchasingState(_beneficiary, weiAmount);
785 
786     _forwardFunds();
787     _postValidatePurchase(_beneficiary, weiAmount);
788   }
789 
790   // -----------------------------------------
791   // Internal interface (extensible)
792   // -----------------------------------------
793 
794   /**
795    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
796    * @param _beneficiary Address performing the token purchase
797    * @param _weiAmount Value in wei involved in the purchase
798    */
799   function _preValidatePurchase(
800     address _beneficiary,
801     uint256 _weiAmount
802   )
803     internal
804   {
805     require(_beneficiary != address(0));
806     require(_weiAmount != 0);
807   }
808 
809   /**
810    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
811    * @param _beneficiary Address performing the token purchase
812    * @param _weiAmount Value in wei involved in the purchase
813    */
814   function _postValidatePurchase(
815     address _beneficiary,
816     uint256 _weiAmount
817   )
818     internal
819   {
820     // optional override
821   }
822 
823   /**
824    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
825    * @param _beneficiary Address performing the token purchase
826    * @param _tokenAmount Number of tokens to be emitted
827    */
828   function _deliverTokens(
829     address _beneficiary,
830     uint256 _tokenAmount
831   )
832     internal
833   {
834     token.transfer(_beneficiary, _tokenAmount);
835   }
836 
837   /**
838    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
839    * @param _beneficiary Address receiving the tokens
840    * @param _tokenAmount Number of tokens to be purchased
841    */
842   function _processPurchase(
843     address _beneficiary,
844     uint256 _tokenAmount
845   )
846     internal
847   {
848     _deliverTokens(_beneficiary, _tokenAmount);
849   }
850 
851   /**
852    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
853    * @param _beneficiary Address receiving the tokens
854    * @param _weiAmount Value in wei involved in the purchase
855    */
856   function _updatePurchasingState(
857     address _beneficiary,
858     uint256 _weiAmount
859   )
860     internal
861   {
862     // optional override
863   }
864 
865   /**
866    * @dev Override to extend the way in which ether is converted to tokens.
867    * @param _weiAmount Value in wei to be converted into tokens
868    * @return Number of tokens that can be purchased with the specified _weiAmount
869    */
870   function _getTokenAmount(uint256 _weiAmount)
871     internal view returns (uint256)
872   {
873     return _weiAmount.mul(rate);
874   }
875 
876   /**
877    * @dev Determines how ETH is stored/forwarded on purchases.
878    */
879   function _forwardFunds() internal {
880     wallet.transfer(msg.value);
881   }
882 }
883 
884 // File: openzeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
885 
886 /**
887  * @title RefundVault
888  * @dev This contract is used for storing funds while a crowdsale
889  * is in progress. Supports refunding the money if crowdsale fails,
890  * and forwarding it if crowdsale is successful.
891  */
892 contract RefundVault is Ownable {
893   using SafeMath for uint256;
894 
895   enum State { Active, Refunding, Closed }
896 
897   mapping (address => uint256) public deposited;
898   address public wallet;
899   State public state;
900 
901   event Closed();
902   event RefundsEnabled();
903   event Refunded(address indexed beneficiary, uint256 weiAmount);
904 
905   /**
906    * @param _wallet Vault address
907    */
908   constructor(address _wallet) public {
909     require(_wallet != address(0));
910     wallet = _wallet;
911     state = State.Active;
912   }
913 
914   /**
915    * @param investor Investor address
916    */
917   function deposit(address investor) onlyOwner public payable {
918     require(state == State.Active);
919     deposited[investor] = deposited[investor].add(msg.value);
920   }
921 
922   function close() onlyOwner public {
923     require(state == State.Active);
924     state = State.Closed;
925     emit Closed();
926     wallet.transfer(address(this).balance);
927   }
928 
929   function enableRefunds() onlyOwner public {
930     require(state == State.Active);
931     state = State.Refunding;
932     emit RefundsEnabled();
933   }
934 
935   /**
936    * @param investor Investor address
937    */
938   function refund(address investor) public {
939     require(state == State.Refunding);
940     uint256 depositedValue = deposited[investor];
941     deposited[investor] = 0;
942     investor.transfer(depositedValue);
943     emit Refunded(investor, depositedValue);
944   }
945 }
946 
947 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
948 
949 /**
950  * @title Pausable
951  * @dev Base contract which allows children to implement an emergency stop mechanism.
952  */
953 contract Pausable is Ownable {
954   event Pause();
955   event Unpause();
956 
957   bool public paused = false;
958 
959 
960   /**
961    * @dev Modifier to make a function callable only when the contract is not paused.
962    */
963   modifier whenNotPaused() {
964     require(!paused);
965     _;
966   }
967 
968   /**
969    * @dev Modifier to make a function callable only when the contract is paused.
970    */
971   modifier whenPaused() {
972     require(paused);
973     _;
974   }
975 
976   /**
977    * @dev called by the owner to pause, triggers stopped state
978    */
979   function pause() onlyOwner whenNotPaused public {
980     paused = true;
981     emit Pause();
982   }
983 
984   /**
985    * @dev called by the owner to unpause, returns to normal state
986    */
987   function unpause() onlyOwner whenPaused public {
988     paused = false;
989     emit Unpause();
990   }
991 }
992 
993 // File: contracts/pixie/PixieCrowdsale.sol
994 
995 contract PixieCrowdsale is Crowdsale, Pausable {
996 
997   event Finalized();
998 
999   event MinimumContributionUpdated(uint256 _minimumContribution);
1000 
1001   event OwnerTransfer(
1002     address indexed owner,
1003     address indexed caller,
1004     address indexed beneficiary,
1005     uint256 amount
1006   );
1007 
1008   mapping(address => bool) public whitelist;
1009 
1010   mapping(address => bool) public managementWhitelist;
1011 
1012   mapping(address => uint256) public contributions;
1013 
1014   bool public isFinalized = false;
1015 
1016   // Tuesday, July 3, 2018 10:00:00 AM GMT+01:00
1017   uint256 public openingTime = 1530608400;
1018 
1019   // Wednesday, August 1, 2018 9:59:59 AM GMT+01:00
1020   uint256 public privateSaleCloseTime = 1533113999;
1021 
1022   // Monday, October 1, 2018 9:59:59 AM GMT+01:00
1023   uint256 public preSaleCloseTime = 1538384399;
1024 
1025   // Wednesday, October 31, 2018 9:59:59 AM GMT+00:00
1026   uint256 public closingTime = 1540979999;
1027 
1028   // price per token (no discount)
1029   uint256 public rate = 396039;
1030 
1031   // 22.5% discount
1032   uint256 public privateSaleRate = 485148;
1033 
1034   // 12.5% discount
1035   uint256 public preSaleRate = 445544;
1036 
1037   uint256 public softCap = 2650 ether;
1038 
1039   uint256 public hardCap = 101000 ether;
1040 
1041   uint256 public minimumContribution = 1 ether;
1042 
1043   // refund vault used to hold funds while crowdsale is running
1044   RefundVault public vault;
1045 
1046   /**
1047   * @dev Throws if called by any account other than the owner or the someone in the management list.
1048   */
1049   modifier onlyManagement() {
1050     require(msg.sender == owner || managementWhitelist[msg.sender], "Must be owner or in management whitelist");
1051     _;
1052   }
1053 
1054   /**
1055    * @dev Constructs the Crowdsale contract with pre-defined parameter plus params
1056    *
1057    * @param _wallet Address where collected funds will be forwarded to
1058    * @param _token Address of the token being sold
1059    */
1060   constructor(address _wallet, PixieToken _token) public Crowdsale(rate, _wallet, _token) {
1061     vault = new RefundVault(wallet);
1062   }
1063 
1064   /**
1065    * @dev Checks whether funding goal was reached.
1066    * @return Whether funding goal was reached
1067    */
1068   function softCapReached() public view returns (bool) {
1069     return weiRaised >= softCap;
1070   }
1071 
1072   /**
1073    * @dev vault finalization task, called when owner calls finalize()
1074    */
1075   function finalization() internal {
1076     if (softCapReached()) {
1077       vault.close();
1078     } else {
1079       vault.enableRefunds();
1080     }
1081   }
1082 
1083   /**
1084    * @dev Overrides Crowdsale fund forwarding, sending funds to vault if not finalised, otherwise to wallet
1085    */
1086   function _forwardFunds() internal {
1087     // once finalized all contributions got to the wallet
1088     if (isFinalized) {
1089       wallet.transfer(msg.value);
1090     }
1091     // otherwise send to vault to allow refunds, if required
1092     else {
1093       vault.deposit.value(msg.value)(msg.sender);
1094     }
1095   }
1096 
1097   /**
1098    * @dev Must be called after crowdsale ends, to do some extra finalization
1099    * work. Calls the contract's finalization function.
1100    */
1101   function finalize() onlyOwner public {
1102     require(!isFinalized, "Crowdsale already finalised");
1103 
1104     finalization();
1105     emit Finalized();
1106 
1107     isFinalized = true;
1108   }
1109 
1110   /**
1111    * @dev Adds single address to whitelist.
1112    * @param _beneficiary Address to be added to the whitelist
1113    */
1114   function addToWhitelist(address _beneficiary) external onlyManagement {
1115     whitelist[_beneficiary] = true;
1116   }
1117 
1118   /**
1119    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
1120    * @param _beneficiaries Addresses to be added to the whitelist
1121    */
1122   function addManyToWhitelist(address[] _beneficiaries) external onlyManagement {
1123     for (uint256 i = 0; i < _beneficiaries.length; i++) {
1124       whitelist[_beneficiaries[i]] = true;
1125     }
1126   }
1127 
1128   /**
1129    * @dev Removes single address from whitelist.
1130    * @param _beneficiary Address to be removed to the whitelist
1131    */
1132   function removeFromWhitelist(address _beneficiary) external onlyManagement {
1133     whitelist[_beneficiary] = false;
1134   }
1135 
1136   /**
1137    * @dev Adds single address to the management whitelist.
1138    * @param _manager Address to be added to the management whitelist
1139    */
1140   function addToManagementWhitelist(address _manager) external onlyManagement {
1141     managementWhitelist[_manager] = true;
1142   }
1143 
1144   /**
1145    * @dev Removes single address from the management whitelist.
1146    * @param _manager Address to be removed to the management whitelist
1147    */
1148   function removeFromManagementWhitelist(address _manager) external onlyManagement {
1149     managementWhitelist[_manager] = false;
1150   }
1151 
1152   /**
1153    * @dev Allows for updating the opening time in the event of a delay
1154    * @dev Must be called by management, use sparingly as no restrictions are set
1155    *
1156    * @param _openingTime the epoch time to set
1157    */
1158   function updateOpeningTime(uint256 _openingTime) external onlyManagement {
1159     require(_openingTime > 0, "A opening time must be specified");
1160     openingTime = _openingTime;
1161   }
1162 
1163   /**
1164    * @dev Allows for updating the private sale close time in the event of a delay
1165    * @dev Must be called by management, use sparingly as no restrictions are set
1166    *
1167    * @param _privateSaleCloseTime the epoch time to set
1168    */
1169   function updatePrivateSaleCloseTime(uint256 _privateSaleCloseTime) external onlyManagement {
1170     require(_privateSaleCloseTime > openingTime, "A private sale time must after the opening time");
1171     privateSaleCloseTime = _privateSaleCloseTime;
1172   }
1173 
1174   /**
1175    * @dev Allows for updating the pre sale close time in the event of a delay
1176    * @dev Must be called by management, use sparingly as no restrictions are set
1177    *
1178    * @param _preSaleCloseTime the epoch time to set
1179    */
1180   function updatePreSaleCloseTime(uint256 _preSaleCloseTime) external onlyManagement {
1181     require(_preSaleCloseTime > privateSaleCloseTime, "A pre sale time must be after the private sale close time");
1182     preSaleCloseTime = _preSaleCloseTime;
1183   }
1184 
1185   /**
1186    * @dev Allows for updating the pre sale close time in the event of a delay
1187    * @dev Must be called by management, use sparingly as no restrictions are set
1188    *
1189    * @param _closingTime the epoch time to set
1190    */
1191   function updateClosingTime(uint256 _closingTime) external onlyManagement {
1192     require(_closingTime > preSaleCloseTime, "A closing time must be after the pre-sale close time");
1193     closingTime = _closingTime;
1194   }
1195 
1196   /**
1197    * @dev Allows for updating the minimum contribution required to participate
1198    * @dev Must be called by management
1199    *
1200    * @param _minimumContribution the minimum contribution to set
1201    */
1202   function updateMinimumContribution(uint256 _minimumContribution) external onlyManagement {
1203     require(_minimumContribution > 0, "Minimum contribution must be great than zero");
1204     minimumContribution = _minimumContribution;
1205     emit MinimumContributionUpdated(_minimumContribution);
1206   }
1207 
1208   /**
1209    * @dev Utility method for returning a set of epoch dates about the ICO
1210    */
1211   function getDateRanges() external view returns (
1212     uint256 _openingTime,
1213     uint256 _privateSaleCloseTime,
1214     uint256 _preSaleCloseTime,
1215     uint256 _closingTime
1216   ) {
1217     return (
1218     openingTime,
1219     privateSaleCloseTime,
1220     preSaleCloseTime,
1221     closingTime
1222     );
1223   }
1224 
1225   /**
1226    * @dev Extend parent behavior to update user contributions so far
1227    * @param _beneficiary Token purchaser
1228    * @param _weiAmount Amount of wei contributed
1229    */
1230   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
1231     super._updatePurchasingState(_beneficiary, _weiAmount);
1232     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
1233   }
1234 
1235   /**
1236    * @dev Checks whether the hard cap has been reached.
1237    * @return Whether the cap was reached
1238    */
1239   function hardCapReached() public view returns (bool) {
1240     return weiRaised >= hardCap;
1241   }
1242 
1243   /**
1244    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1245    * @return Whether crowdsale period has elapsed
1246    */
1247   function hasClosed() public view returns (bool) {
1248     return now > closingTime;
1249   }
1250 
1251   /**
1252    * @dev Overridden method used to allow different rates for private/pre sale
1253    * @param _weiAmount Value in wei to be converted into tokens
1254    * @return Number of tokens that can be purchased with the specified _weiAmount
1255    */
1256   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1257     if (now < privateSaleCloseTime) {
1258       return _weiAmount.mul(privateSaleRate);
1259     }
1260 
1261     if (now < preSaleCloseTime) {
1262       return _weiAmount.mul(preSaleRate);
1263     }
1264 
1265     return _weiAmount.mul(rate);
1266   }
1267 
1268   /**
1269    * @dev Checks whether the period in which the crowdsale is open has elapsed.
1270    * @return true if crowdsale period is open, otherwise false
1271    */
1272   function isCrowdsaleOpen() public view returns (bool) {
1273     return now >= openingTime && now <= closingTime;
1274   }
1275 
1276   /**
1277    * @dev Extend parent behavior requiring contract to not be paused.
1278    * @param _beneficiary Token beneficiary
1279    * @param _weiAmount Amount of wei contributed
1280    */
1281   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1282     super._preValidatePurchase(_beneficiary, _weiAmount);
1283 
1284     require(isCrowdsaleOpen(), "Crowdsale not open");
1285 
1286     require(weiRaised.add(_weiAmount) <= hardCap, "Exceeds maximum cap");
1287 
1288     require(_weiAmount >= minimumContribution, "Beneficiary minimum amount not reached");
1289 
1290     require(whitelist[_beneficiary], "Beneficiary not whitelisted");
1291 
1292     require(whitelist[msg.sender], "Sender not whitelisted");
1293 
1294     require(!paused, "Contract paused");
1295   }
1296 
1297   /**
1298    * @dev Allow owner to transfer tokens. Will be used to transfer unsold tokens.
1299    * @param _beneficiary Token beneficiary
1300    * @param _tokenAmount Amount of tokens to deliver
1301    */
1302   function transfer(address _beneficiary, uint256 _tokenAmount) external onlyOwner {
1303     _deliverTokens(_beneficiary, _tokenAmount);
1304     emit OwnerTransfer(msg.sender, address(this), _beneficiary, _tokenAmount);
1305   }
1306 }