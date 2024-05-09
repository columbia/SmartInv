1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address _owner, address _spender)
21     public view returns (uint256);
22 
23   function transferFrom(address _from, address _to, uint256 _value)
24     public returns (bool);
25 
26   function approve(address _spender, uint256 _value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title Basic token
32  * @dev Basic version of StandardToken, with no allowances.
33  */
34 contract BasicToken is ERC20Basic {
35   using SafeMath for uint256;
36 
37   mapping(address => uint256) public balances;
38 
39   uint256 internal totalSupply_;
40 
41   /**
42   * @dev Total number of tokens in existence
43   */
44   function totalSupply() public view returns (uint256) {
45     return totalSupply_;
46   }
47 
48   /**
49   * @dev Transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_value <= balances[msg.sender]);
55     require(_to != address(0));
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     emit Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   /**
63   * @dev Gets the balance of the specified address.
64   * @param _owner The address to query the the balance of.
65   * @return An uint256 representing the amount owned by the passed address.
66   */
67   function balanceOf(address _owner) public view returns (uint256) {
68     return balances[_owner];
69   }
70 
71 }
72 
73 /**
74  * @title Standard ERC20 token
75  *
76  * @dev Implementation of the basic standard token.
77  * https://github.com/ethereum/EIPs/issues/20
78  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
79  */
80 contract StandardToken is ERC20, BasicToken {
81 
82   mapping (address => mapping (address => uint256)) internal allowed;
83 
84 
85   /**
86    * @dev Transfer tokens from one address to another
87    * @param _from address The address which you want to send tokens from
88    * @param _to address The address which you want to transfer to
89    * @param _value uint256 the amount of tokens to be transferred
90    */
91   function transferFrom(
92     address _from,
93     address _to,
94     uint256 _value
95   )
96     public
97     returns (bool)
98   {
99     require(_value <= balances[_from]);
100     require(_value <= allowed[_from][msg.sender]);
101     require(_to != address(0));
102 
103     balances[_from] = balances[_from].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
106     emit Transfer(_from, _to, _value);
107     return true;
108   }
109 
110   /**
111    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
112    * Beware that changing an allowance with this method brings the risk that someone may use both the old
113    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
114    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
115    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116    * @param _spender The address which will spend the funds.
117    * @param _value The amount of tokens to be spent.
118    */
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     emit Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Function to check the amount of tokens that an owner allowed to a spender.
127    * @param _owner address The address which owns the funds.
128    * @param _spender address The address which will spend the funds.
129    * @return A uint256 specifying the amount of tokens still available for the spender.
130    */
131   function allowance(
132     address _owner,
133     address _spender
134    )
135     public
136     view
137     returns (uint256)
138   {
139     return allowed[_owner][_spender];
140   }
141 
142   /**
143    * @dev Increase the amount of tokens that an owner allowed to a spender.
144    * approve should be called when allowed[_spender] == 0. To increment
145    * allowed value is better to use this function to avoid 2 calls (and wait until
146    * the first transaction is mined)
147    * From MonolithDAO Token.sol
148    * @param _spender The address which will spend the funds.
149    * @param _addedValue The amount of tokens to increase the allowance by.
150    */
151   function increaseApproval(
152     address _spender,
153     uint256 _addedValue
154   )
155     public
156     returns (bool)
157   {
158     allowed[msg.sender][_spender] = (
159       allowed[msg.sender][_spender].add(_addedValue));
160     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   /**
165    * @dev Decrease the amount of tokens that an owner allowed to a spender.
166    * approve should be called when allowed[_spender] == 0. To decrement
167    * allowed value is better to use this function to avoid 2 calls (and wait until
168    * the first transaction is mined)
169    * From MonolithDAO Token.sol
170    * @param _spender The address which will spend the funds.
171    * @param _subtractedValue The amount of tokens to decrease the allowance by.
172    */
173   function decreaseApproval(
174     address _spender,
175     uint256 _subtractedValue
176   )
177     public
178     returns (bool)
179   {
180     uint256 oldValue = allowed[msg.sender][_spender];
181     if (_subtractedValue >= oldValue) {
182       allowed[msg.sender][_spender] = 0;
183     } else {
184       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185     }
186     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190 }
191 
192 /**
193  * @title Burnable Token
194  * @dev Token that can be irreversibly burned (destroyed).
195  */
196 contract BurnableToken is StandardToken {
197 
198   event Burn(address indexed burner, uint256 value);
199 
200   /**
201    * @dev Burns a specific amount of tokens.
202    * @param _value The amount of token to be burned.
203    */
204   function burn(uint256 _value) public {
205     _burn(msg.sender, _value);
206   }
207 
208   /**
209    * @dev Burns a specific amount of tokens from the target address and decrements allowance
210    * @param _from address The address which you want to send tokens from
211    * @param _value uint256 The amount of token to be burned
212    */
213   function burnFrom(address _from, uint256 _value) public {
214     require(_value <= allowed[_from][msg.sender]);
215     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
216     // this function needs to emit an event with the updated approval.
217     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218     _burn(_from, _value);
219   }
220 
221   function _burn(address _who, uint256 _value) internal {
222     require(_value <= balances[_who]);
223     // no need to require value <= totalSupply, since that would imply the
224     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
225 
226     balances[_who] = balances[_who].sub(_value);
227     totalSupply_ = totalSupply_.sub(_value);
228     emit Burn(_who, _value);
229   }
230 }
231 
232 /**
233  * @title Whitelist
234  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
235  * This simplifies the implementation of "user permissions".
236  */
237 
238 /**
239  * @title RBAC (Role-Based Access Control)
240  * @author Matt Condon (@Shrugs)
241  * @dev Stores and provides setters and getters for roles and addresses.
242  * Supports unlimited numbers of roles and addresses.
243  * See //contracts/mocks/RBACMock.sol for an example of usage.
244  * This RBAC method uses strings to key roles. It may be beneficial
245  * for you to write your own implementation of this interface using Enums or similar.
246  */
247 contract RBAC {
248   using Roles for Roles.Role;
249 
250   mapping (string => Roles.Role) private roles;
251 
252   event RoleAdded(address indexed operator, string role);
253   event RoleRemoved(address indexed operator, string role);
254 
255   /**
256    * @dev reverts if addr does not have role
257    * @param _operator address
258    * @param _role the name of the role
259    * // reverts
260    */
261   function checkRole(address _operator, string _role) public view {
262     roles[_role].check(_operator);
263   }
264 
265   /**
266    * @dev determine if addr has role
267    * @param _operator address
268    * @param _role the name of the role
269    * @return bool
270    */
271   function hasRole(address _operator, string _role) public view returns (bool) {
272     return roles[_role].has(_operator);
273   }
274 
275   /**
276    * @dev add a role to an address
277    * @param _operator address
278    * @param _role the name of the role
279    */
280   function addRole(address _operator, string _role) internal {
281     roles[_role].add(_operator);
282     emit RoleAdded(_operator, _role);
283   }
284 
285   /**
286    * @dev remove a role from an address
287    * @param _operator address
288    * @param _role the name of the role
289    */
290   function removeRole(address _operator, string _role) internal {
291     roles[_role].remove(_operator);
292     emit RoleRemoved(_operator, _role);
293   }
294 
295   /**
296    * @dev modifier to scope access to a single role (uses msg.sender as addr)
297    * @param _role the name of the role
298    * // reverts
299    */
300   modifier onlyRole(string _role) {
301     checkRole(msg.sender, _role);
302     _;
303   }
304 }
305 
306 
307 /**
308  * @title Ownable
309  * @dev The Ownable contract has an owner address, and provides basic authorization control
310  * functions, this simplifies the implementation of "user permissions".
311  */
312 contract Ownable {
313   address public owner;
314 
315 
316   event OwnershipRenounced(address indexed previousOwner);
317   event OwnershipTransferred(
318     address indexed previousOwner,
319     address indexed newOwner
320   );
321 
322 
323   /**
324    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
325    * account.
326    */
327   constructor() public {
328     owner = msg.sender;
329   }
330 
331   /**
332    * @dev Throws if called by any account other than the owner.
333    */
334   modifier onlyOwner() {
335     require(msg.sender == owner);
336     _;
337   }
338 
339   /**
340    * @dev Allows the current owner to relinquish control of the contract.
341    * @notice Renouncing to ownership will leave the contract without an owner.
342    * It will not be possible to call the functions with the `onlyOwner`
343    * modifier anymore.
344    */
345   function renounceOwnership() public onlyOwner {
346     emit OwnershipRenounced(owner);
347     owner = address(0);
348   }
349 
350   /**
351    * @dev Allows the current owner to transfer control of the contract to a newOwner.
352    * @param _newOwner The address to transfer ownership to.
353    */
354   function transferOwnership(address _newOwner) public onlyOwner {
355     _transferOwnership(_newOwner);
356   }
357 
358   /**
359    * @dev Transfers control of the contract to a newOwner.
360    * @param _newOwner The address to transfer ownership to.
361    */
362   function _transferOwnership(address _newOwner) internal {
363     require(_newOwner != address(0));
364     emit OwnershipTransferred(owner, _newOwner);
365     owner = _newOwner;
366   }
367 }
368 
369 contract Whitelist is Ownable, RBAC {
370   string public constant ROLE_WHITELISTED = "whitelist";
371 
372   /**
373    * @dev Throws if operator is not whitelisted.
374    * @param _operator address
375    */
376   modifier onlyIfWhitelisted(address _operator) {
377     checkRole(_operator, ROLE_WHITELISTED);
378     _;
379   }
380 
381 
382   function addMassAddressToWhitelist(address[] _operator) public onlyOwner {
383     for (uint i = 0; i < _operator.length; i++) {
384         address addr = _operator[i];
385         addRole(addr, ROLE_WHITELISTED);
386     }
387   }
388 
389 
390   /**
391    * @dev add an address to the whitelist
392    * @param _operator address
393    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
394    */
395   function addAddressToWhitelist(address _operator) public onlyOwner {
396     addRole(_operator, ROLE_WHITELISTED);
397   }
398 
399   /**
400    * @dev getter to determine if address is in whitelist
401    */
402   function whitelist(address _operator) public view returns (bool) {
403     return hasRole(_operator, ROLE_WHITELISTED);
404   }
405 
406   /**
407    * @dev add addresses to the whitelist
408    * @param _operators addresses
409    * @return true if at least one address was added to the whitelist,
410    * false if all addresses were already in the whitelist
411    */
412   function addAddressesToWhitelist(address[] _operators) public onlyOwner {
413     for (uint256 i = 0; i < _operators.length; i++) {
414       addAddressToWhitelist(_operators[i]);
415     }
416   }
417 
418   /**
419    * @dev remove an address from the whitelist
420    * @param _operator address
421    * @return true if the address was removed from the whitelist,
422    * false if the address wasn't in the whitelist in the first place
423    */
424   function removeAddressFromWhitelist(address _operator) public onlyOwner {
425     removeRole(_operator, ROLE_WHITELISTED);
426   }
427 
428   /**
429    * @dev remove addresses from the whitelist
430    * @param _operators addresses
431    * @return true if at least one address was removed from the whitelist,
432    * false if all addresses weren't in the whitelist in the first place
433    */
434   function removeAddressesFromWhitelist(address[] _operators) public onlyOwner {
435     for (uint256 i = 0; i < _operators.length; i++) {
436       removeAddressFromWhitelist(_operators[i]);
437     }
438   }
439 }
440 
441 contract AvailComToken is BurnableToken, Ownable {
442 
443     string public constant name = "AvailCom Token";
444     string public constant symbol = "AVL";
445     uint32 public constant decimals = 4;
446 
447     constructor () public {
448         // 0000 is added to the totalSupply because decimal 4
449         totalSupply_ = 22000000000000;
450         balances[msg.sender] = totalSupply_;
451     }
452 }
453 
454 /**
455  * @title Crowdsale
456  * @dev Crowdsale is a base contract for managing a token crowdsale,
457  * allowing investors to purchase tokens with ether. This contract implements
458  * such functionality in its most fundamental form and can be extended to provide additional
459  * functionality and/or custom behavior.
460  * The external interface represents the basic interface for purchasing tokens, and conform
461  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
462  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
463  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
464  * behavior.
465  */
466 contract Crowdsale is Ownable, Whitelist {
467   using SafeMath for uint256;
468 
469   // The token being sold
470   AvailComToken public token;
471 
472   // Variable for tracking whether ICO is complete
473   bool public fifishICO = false;
474 
475   // Address where funds are collected
476   address public wallet;
477 
478   // How many token units a buyer gets per wei.
479   // The rate is the conversion between wei and the smallest and indivisible token unit.
480   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
481   // 1 wei will give you 1 unit, or 0.001 TOK.
482   uint256 public rate;
483 
484   // Start time for test contract
485   uint public start = 1542301199; 
486   // uint public start = 1542301199; // 15.11.2018
487 
488   uint public period = 30;
489   uint public hardcap = 2600 * 1 ether;
490 
491   // Bonus on the closed sale of tokens - 30%
492   uint public bonusPersent = 30;
493 
494   // Amount of wei raised
495   uint256 public weiRaised;
496 
497   // The minimum purchase amount of tokens. Can be changed during ICO
498   uint256 public etherLimit = 0 ether;
499 
500   /**
501    * Event for token purchase logging
502    * @param purchaser who paid for the tokens
503    * @param beneficiary who got the tokens
504    * @param value weis paid for purchase
505    * @param amount amount of tokens purchased
506    */
507   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
508 
509     // Time check modifier
510     modifier saleICOn() {
511     	require(now > start && now < start + period * 1 days);
512     	_;
513     }
514     
515     // Check modifier on the collected hardcap
516     modifier isUnderHardCap() {
517         require(wallet.balance <= hardcap);
518         _;
519     }
520 
521   /**
522    * @param _token Address of the token being sold
523    */
524   constructor (AvailComToken _token) public {
525     require(_token != address(0));
526 
527     // 0000 is added to the rate because decimal 4
528     rate = 167000000;
529     wallet = msg.sender;
530     token = _token;
531   }
532 
533   // -----------------------------------------
534   // Crowdsale external interface
535   // -----------------------------------------
536 
537   /**
538    * @dev fallback function ***DO NOT OVERRIDE***
539    */
540   function () saleICOn isUnderHardCap external payable {
541     require(!fifishICO);
542 
543     if (!whitelist(msg.sender)) {
544       require(msg.value >= etherLimit);
545     }
546 
547     buyTokens(msg.sender);
548   }
549 
550   function buyTokens(address _beneficiary) public payable {
551 
552     uint256 weiAmount = msg.value;
553     _preValidatePurchase(_beneficiary, weiAmount);
554 
555     // calculate token amount to be created
556     uint256 tokens = _getTokenAmount(weiAmount);
557 
558     // update state
559     weiRaised = weiRaised.add(weiAmount);
560 
561     _processPurchase(_beneficiary, tokens);
562     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
563 
564     _forwardFunds();
565   }
566 
567   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
568     require(_beneficiary != address(0));
569     require(_weiAmount != 0);
570   }
571 
572   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
573     // Adding a bonus tokens to purchase
574     _tokenAmount = _tokenAmount + (_tokenAmount * bonusPersent / 100);
575     // Сonversion from wei
576     _tokenAmount = _tokenAmount / 1000000000000000000;
577     token.transfer(_beneficiary, _tokenAmount);
578   }
579 
580   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
581     _deliverTokens(_beneficiary, _tokenAmount);
582   }
583 
584   /**
585    * @dev Override to extend the way in which ether is converted to tokens.
586    * @param _weiAmount Value in wei to be converted into tokens
587    * @return Number of tokens that can be purchased with the specified _weiAmount
588    */
589   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
590     return _weiAmount.mul(rate);
591   }
592 
593   /**
594    * @dev Determines how ETH is stored/forwarded on purchases.
595    */
596   function _forwardFunds() internal {
597     wallet.transfer(msg.value);
598   }
599 
600   // ICO completion function. 
601   // At the end of ICO all unallocated tokens are returned to the address of the creator of the contract
602   function finishCrowdsale() public onlyOwner {
603     uint _value = token.balanceOf(this);
604     token.transfer(wallet, _value);
605     fifishICO = true;
606   }
607 
608   // The function of changing the minimum purchase amount of tokens.
609   function editEtherLimit (uint256 _value) public onlyOwner {
610     etherLimit = _value;
611     etherLimit = etherLimit * 1 ether;
612   }
613 
614 }
615 
616 /**
617  * @title Roles
618  * @author Francisco Giordano (@frangio)
619  * @dev Library for managing addresses assigned to a Role.
620  * See RBAC.sol for example usage.
621  */
622 library Roles {
623 
624   struct Role {
625     mapping (address => bool) bearer;
626   }
627 
628   /**
629    * @dev give an account access to this role
630    */
631   function add(Role storage _role, address _account) internal {
632     _role.bearer[_account] = true;
633   }
634 
635   /**
636    * @dev remove an account's access to this role
637    */
638   function remove(Role storage _role, address _account) internal {
639     _role.bearer[_account] = false;
640   }
641 
642   /**
643    * @dev check if an account has this role
644    * // reverts
645    */
646   function check(Role storage _role, address _account) internal view {
647     require(has(_role, _account));
648   }
649 
650   /**
651    * @dev check if an account has this role
652    * @return bool
653    */
654   function has(Role storage _role, address _account) internal view returns (bool) {
655     return _role.bearer[_account];
656   }
657 }
658 
659 
660 /**
661  * @title SafeMath
662  * @dev Math operations with safety checks that throw on error
663  */
664 library SafeMath {
665 
666   /**
667   * @dev Multiplies two numbers, throws on overflow.
668   */
669   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
670     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
671     // benefit is lost if 'b' is also tested.
672     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
673     if (_a == 0) {
674       return 0;
675     }
676 
677     c = _a * _b;
678     assert(c / _a == _b);
679     return c;
680   }
681 
682   /**
683   * @dev Integer division of two numbers, truncating the quotient.
684   */
685   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
686     // assert(_b > 0); // Solidity automatically throws when dividing by 0
687     // uint256 c = _a / _b;
688     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
689     return _a / _b;
690   }
691 
692   /**
693   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
694   */
695   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
696     assert(_b <= _a);
697     return _a - _b;
698   }
699 
700   /**
701   * @dev Adds two numbers, throws on overflow.
702   */
703   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
704     c = _a + _b;
705     assert(c >= _a);
706     return c;
707   }
708 }