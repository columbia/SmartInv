1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (_a == 0) {
79       return 0;
80     }
81 
82     c = _a * _b;
83     assert(c / _a == _b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     // assert(_b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = _a / _b;
93     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
94     return _a / _b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
101     assert(_b <= _a);
102     return _a - _b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
109     c = _a + _b;
110     assert(c >= _a);
111     return c;
112   }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address _owner, address _spender)
133     public view returns (uint256);
134 
135   function transferFrom(address _from, address _to, uint256 _value)
136     public returns (bool);
137 
138   function approve(address _spender, uint256 _value) public returns (bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) public balances;
150 
151   uint256 internal totalSupply_;
152 
153   /**
154   * @dev Total number of tokens in existence
155   */
156   function totalSupply() public view returns (uint256) {
157     return totalSupply_;
158   }
159 
160   /**
161   * @dev Transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_value <= balances[msg.sender]);
167     require(_to != address(0));
168     balances[msg.sender] = balances[msg.sender].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     emit Transfer(msg.sender, _to, _value);
171     return true;
172   }
173 
174   /**
175   * @dev Gets the balance of the specified address.
176   * @param _owner The address to query the the balance of.
177   * @return An uint256 representing the amount owned by the passed address.
178   */
179   function balanceOf(address _owner) public view returns (uint256) {
180     return balances[_owner];
181   }
182 
183 }
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * https://github.com/ethereum/EIPs/issues/20
190  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194   mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(
204     address _from,
205     address _to,
206     uint256 _value
207   )
208     public
209     returns (bool)
210   {
211     require(_value <= balances[_from]);
212     require(_value <= allowed[_from][msg.sender]);
213     require(_to != address(0));
214 
215     balances[_from] = balances[_from].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218     emit Transfer(_from, _to, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     emit Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(
244     address _owner,
245     address _spender
246    )
247     public
248     view
249     returns (uint256)
250   {
251     return allowed[_owner][_spender];
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    * approve should be called when allowed[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseApproval(
264     address _spender,
265     uint256 _addedValue
266   )
267     public
268     returns (bool)
269   {
270     allowed[msg.sender][_spender] = (
271       allowed[msg.sender][_spender].add(_addedValue));
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276   /**
277    * @dev Decrease the amount of tokens that an owner allowed to a spender.
278    * approve should be called when allowed[_spender] == 0. To decrement
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseApproval(
286     address _spender,
287     uint256 _subtractedValue
288   )
289     public
290     returns (bool)
291   {
292     uint256 oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue >= oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302 }
303 
304 /**
305  * @title Burnable Token
306  * @dev Token that can be irreversibly burned (destroyed).
307  */
308 contract BurnableToken is StandardToken {
309 
310   event Burn(address indexed burner, uint256 value);
311 
312   /**
313    * @dev Burns a specific amount of tokens.
314    * @param _value The amount of token to be burned.
315    */
316   function burn(uint256 _value) public {
317     _burn(msg.sender, _value);
318   }
319 
320   /**
321    * @dev Burns a specific amount of tokens from the target address and decrements allowance
322    * @param _from address The address which you want to send tokens from
323    * @param _value uint256 The amount of token to be burned
324    */
325   function burnFrom(address _from, uint256 _value) public {
326     require(_value <= allowed[_from][msg.sender]);
327     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
328     // this function needs to emit an event with the updated approval.
329     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
330     _burn(_from, _value);
331   }
332 
333   function _burn(address _who, uint256 _value) internal {
334     require(_value <= balances[_who]);
335     // no need to require value <= totalSupply, since that would imply the
336     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
337 
338     balances[_who] = balances[_who].sub(_value);
339     totalSupply_ = totalSupply_.sub(_value);
340     emit Burn(_who, _value);
341   }
342 }
343 
344 contract AvailComToken is BurnableToken, Ownable {
345 
346     string public constant name = "AvailCom Token";
347     string public constant symbol = "AVL";
348     uint32 public constant decimals = 4;
349 
350     constructor () public {
351         // 0000 is added to the totalSupply because decimal 4
352         totalSupply_ = 22000000000000;
353         balances[msg.sender] = totalSupply_;
354     }
355 }
356 
357 
358 /**
359  * @title RBAC (Role-Based Access Control)
360  * @author Matt Condon (@Shrugs)
361  * @dev Stores and provides setters and getters for roles and addresses.
362  * Supports unlimited numbers of roles and addresses.
363  * See //contracts/mocks/RBACMock.sol for an example of usage.
364  * This RBAC method uses strings to key roles. It may be beneficial
365  * for you to write your own implementation of this interface using Enums or similar.
366  */
367 contract RBAC {
368   using Roles for Roles.Role;
369 
370   mapping (string => Roles.Role) private roles;
371 
372   event RoleAdded(address indexed operator, string role);
373   event RoleRemoved(address indexed operator, string role);
374 
375   /**
376    * @dev reverts if addr does not have role
377    * @param _operator address
378    * @param _role the name of the role
379    * // reverts
380    */
381   function checkRole(address _operator, string _role) public view {
382     roles[_role].check(_operator);
383   }
384 
385   /**
386    * @dev determine if addr has role
387    * @param _operator address
388    * @param _role the name of the role
389    * @return bool
390    */
391   function hasRole(address _operator, string _role) public view returns (bool) {
392     return roles[_role].has(_operator);
393   }
394 
395   /**
396    * @dev add a role to an address
397    * @param _operator address
398    * @param _role the name of the role
399    */
400   function addRole(address _operator, string _role) internal {
401     roles[_role].add(_operator);
402     emit RoleAdded(_operator, _role);
403   }
404 
405   /**
406    * @dev remove a role from an address
407    * @param _operator address
408    * @param _role the name of the role
409    */
410   function removeRole(address _operator, string _role) internal {
411     roles[_role].remove(_operator);
412     emit RoleRemoved(_operator, _role);
413   }
414 
415   /**
416    * @dev modifier to scope access to a single role (uses msg.sender as addr)
417    * @param _role the name of the role
418    * // reverts
419    */
420   modifier onlyRole(string _role) {
421     checkRole(msg.sender, _role);
422     _;
423   }
424 }
425 
426 /**
427  * @title Roles
428  * @author Francisco Giordano (@frangio)
429  * @dev Library for managing addresses assigned to a Role.
430  * See RBAC.sol for example usage.
431  */
432 library Roles {
433 
434   struct Role {
435     mapping (address => bool) bearer;
436   }
437 
438   /**
439    * @dev give an account access to this role
440    */
441   function add(Role storage _role, address _account) internal {
442     _role.bearer[_account] = true;
443   }
444 
445   /**
446    * @dev remove an account's access to this role
447    */
448   function remove(Role storage _role, address _account) internal {
449     _role.bearer[_account] = false;
450   }
451 
452   /**
453    * @dev check if an account has this role
454    * // reverts
455    */
456   function check(Role storage _role, address _account) internal view {
457     require(has(_role, _account));
458   }
459 
460   /**
461    * @dev check if an account has this role
462    * @return bool
463    */
464   function has(Role storage _role, address _account) internal view returns (bool) {
465     return _role.bearer[_account];
466   }
467 }
468 
469 /**
470  * @title Whitelist
471  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
472  * This simplifies the implementation of "user permissions".
473  */
474 contract Whitelist is Ownable, RBAC {
475   string public constant ROLE_WHITELISTED = "whitelist";
476 
477   /**
478    * @dev Throws if operator is not whitelisted.
479    * @param _operator address
480    */
481   modifier onlyIfWhitelisted(address _operator) {
482     checkRole(_operator, ROLE_WHITELISTED);
483     _;
484   }
485 
486   /**
487    * @dev add an address to the whitelist
488    * @param _operator address
489    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
490    */
491   function addAddressToWhitelist(address _operator) public onlyOwner {
492     addRole(_operator, ROLE_WHITELISTED);
493   }
494 
495   /**
496    * @dev getter to determine if address is in whitelist
497    */
498   function whitelist(address _operator) public view returns (bool) {
499     return hasRole(_operator, ROLE_WHITELISTED);
500   }
501 
502   /**
503    * @dev add addresses to the whitelist
504    * @param _operators addresses
505    * @return true if at least one address was added to the whitelist,
506    * false if all addresses were already in the whitelist
507    */
508   function addAddressesToWhitelist(address[] _operators) public onlyOwner {
509     for (uint256 i = 0; i < _operators.length; i++) {
510       addAddressToWhitelist(_operators[i]);
511     }
512   }
513 
514   /**
515    * @dev remove an address from the whitelist
516    * @param _operator address
517    * @return true if the address was removed from the whitelist,
518    * false if the address wasn't in the whitelist in the first place
519    */
520   function removeAddressFromWhitelist(address _operator) public onlyOwner {
521     removeRole(_operator, ROLE_WHITELISTED);
522   }
523 
524   /**
525    * @dev remove addresses from the whitelist
526    * @param _operators addresses
527    * @return true if at least one address was removed from the whitelist,
528    * false if all addresses weren't in the whitelist in the first place
529    */
530   function removeAddressesFromWhitelist(address[] _operators) public onlyOwner {
531     for (uint256 i = 0; i < _operators.length; i++) {
532       removeAddressFromWhitelist(_operators[i]);
533     }
534   }
535 }
536 
537 
538 
539 
540 /**
541  * @title Crowdsale
542  * @dev Crowdsale is a base contract for managing a token crowdsale,
543  * allowing investors to purchase tokens with ether. This contract implements
544  * such functionality in its most fundamental form and can be extended to provide additional
545  * functionality and/or custom behavior.
546  * The external interface represents the basic interface for purchasing tokens, and conform
547  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
548  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
549  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
550  * behavior.
551  */
552 contract Crowdsale is Ownable, Whitelist {
553   using SafeMath for uint256;
554 
555   // The token being sold
556   AvailComToken public token;
557 
558   // Variable for tracking whether ICO is complete
559   bool public fifishICO = false;
560 
561   // Address where funds are collected
562   address public wallet;
563 
564   // How many token units a buyer gets per wei.
565   // The rate is the conversion between wei and the smallest and indivisible token unit.
566   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
567   // 1 wei will give you 1 unit, or 0.001 TOK.
568   uint256 public rate;
569 
570   // Start time for test contract
571   uint public start = 1534291200; 
572   // uint public start = 1534291200; // 15.08.2018
573 
574   uint public period = 30;
575   uint public hardcap = 800 * 1 ether;
576 
577   // Bonus on the closed sale of tokens - 50%
578   uint public bonusPersent = 50;
579 
580   // Amount of wei raised
581   uint256 public weiRaised;
582 
583   // The minimum purchase amount of tokens. Can be changed during ICO
584   uint256 public etherLimit = 1 ether;
585 
586   /**
587    * Event for token purchase logging
588    * @param purchaser who paid for the tokens
589    * @param beneficiary who got the tokens
590    * @param value weis paid for purchase
591    * @param amount amount of tokens purchased
592    */
593   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
594 
595     // Time check modifier
596     modifier saleICOn() {
597     	require(now > start && now < start + period * 1 days);
598     	_;
599     }
600     
601     // Check modifier on the collected hardcap
602     modifier isUnderHardCap() {
603         require(wallet.balance <= hardcap);
604         _;
605     }
606 
607   /**
608    * @param _token Address of the token being sold
609    */
610   constructor (AvailComToken _token) public {
611     require(_token != address(0));
612 
613     // 0000 is added to the rate because decimal 4
614     rate = 167000000;
615     wallet = msg.sender;
616     token = _token;
617   }
618 
619   // -----------------------------------------
620   // Crowdsale external interface
621   // -----------------------------------------
622 
623   /**
624    * @dev fallback function ***DO NOT OVERRIDE***
625    */
626   function () saleICOn isUnderHardCap external payable {
627     require(!fifishICO);
628 
629     if (!whitelist(msg.sender)) {
630       require(msg.value >= etherLimit);
631     }
632 
633     buyTokens(msg.sender);
634   }
635 
636   function buyTokens(address _beneficiary) public payable {
637 
638     uint256 weiAmount = msg.value;
639     _preValidatePurchase(_beneficiary, weiAmount);
640 
641     // calculate token amount to be created
642     uint256 tokens = _getTokenAmount(weiAmount);
643 
644     // update state
645     weiRaised = weiRaised.add(weiAmount);
646 
647     _processPurchase(_beneficiary, tokens);
648     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
649 
650     _forwardFunds();
651   }
652 
653   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
654     require(_beneficiary != address(0));
655     require(_weiAmount != 0);
656   }
657 
658   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
659     // Adding a bonus tokens to purchase
660     _tokenAmount = _tokenAmount + (_tokenAmount * bonusPersent / 100);
661     // Сonversion from wei
662     _tokenAmount = _tokenAmount / 1000000000000000000;
663     token.transfer(_beneficiary, _tokenAmount);
664   }
665 
666   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
667     _deliverTokens(_beneficiary, _tokenAmount);
668   }
669 
670   /**
671    * @dev Override to extend the way in which ether is converted to tokens.
672    * @param _weiAmount Value in wei to be converted into tokens
673    * @return Number of tokens that can be purchased with the specified _weiAmount
674    */
675   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
676     return _weiAmount.mul(rate);
677   }
678 
679   /**
680    * @dev Determines how ETH is stored/forwarded on purchases.
681    */
682   function _forwardFunds() internal {
683     wallet.transfer(msg.value);
684   }
685 
686   // ICO completion function. 
687   // At the end of ICO all unallocated tokens are returned to the address of the creator of the contract
688   function finishCrowdsale() public onlyOwner {
689     uint _value = token.balanceOf(this);
690     token.transfer(wallet, _value);
691     fifishICO = true;
692   }
693 
694   // The function of changing the minimum purchase amount of tokens.
695   function editEtherLimit (uint256 _value) public onlyOwner {
696     etherLimit = _value;
697     etherLimit = etherLimit * 1 ether;
698   }
699 
700 }