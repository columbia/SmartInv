1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 /**
53  * @title SafeERC20
54  * @dev Wrappers around ERC20 operations that throw on failure.
55  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
56  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
57  */
58 library SafeERC20 {
59   function safeTransfer(
60     ERC20Basic _token,
61     address _to,
62     uint256 _value
63   )
64     internal
65   {
66     require(_token.transfer(_to, _value));
67   }
68 
69   function safeTransferFrom(
70     ERC20 _token,
71     address _from,
72     address _to,
73     uint256 _value
74   )
75     internal
76   {
77     require(_token.transferFrom(_from, _to, _value));
78   }
79 
80   function safeApprove(
81     ERC20 _token,
82     address _spender,
83     uint256 _value
84   )
85     internal
86   {
87     require(_token.approve(_spender, _value));
88   }
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * See https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address _who) public view returns (uint256);
99   function transfer(address _to, uint256 _value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address _owner, address _spender)
109     public view returns (uint256);
110 
111   function transferFrom(address _from, address _to, uint256 _value)
112     public returns (bool);
113 
114   function approve(address _spender, uint256 _value) public returns (bool);
115   event Approval(
116     address indexed owner,
117     address indexed spender,
118     uint256 value
119   );
120 }
121 
122 /**
123  * @title Ownable
124  * @dev The Ownable contract has an owner address, and provides basic authorization control
125  * functions, this simplifies the implementation of "user permissions".
126  */
127 contract Ownable {
128   address public owner;
129 
130 
131   event OwnershipRenounced(address indexed previousOwner);
132   event OwnershipTransferred(
133     address indexed previousOwner,
134     address indexed newOwner
135   );
136 
137 
138   /**
139    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
140    * account.
141    */
142   constructor() public {
143     owner = msg.sender;
144   }
145 
146   /**
147    * @dev Throws if called by any account other than the owner.
148    */
149   modifier onlyOwner() {
150     require(msg.sender == owner);
151     _;
152   }
153 
154   /**
155    * @dev Allows the current owner to relinquish control of the contract.
156    * @notice Renouncing to ownership will leave the contract without an owner.
157    * It will not be possible to call the functions with the `onlyOwner`
158    * modifier anymore.
159    */
160   function renounceOwnership() public onlyOwner {
161     emit OwnershipRenounced(owner);
162     owner = address(0);
163   }
164 
165   /**
166    * @dev Allows the current owner to transfer control of the contract to a newOwner.
167    * @param _newOwner The address to transfer ownership to.
168    */
169   function transferOwnership(address _newOwner) public onlyOwner {
170     _transferOwnership(_newOwner);
171   }
172 
173   /**
174    * @dev Transfers control of the contract to a newOwner.
175    * @param _newOwner The address to transfer ownership to.
176    */
177   function _transferOwnership(address _newOwner) internal {
178     require(_newOwner != address(0));
179     emit OwnershipTransferred(owner, _newOwner);
180     owner = _newOwner;
181   }
182 }
183 
184 /**
185  * @title Roles
186  * @author Francisco Giordano (@frangio)
187  * @dev Library for managing addresses assigned to a Role.
188  * See RBAC.sol for example usage.
189  */
190 library Roles {
191   struct Role {
192     mapping (address => bool) bearer;
193   }
194 
195   /**
196    * @dev give an address access to this role
197    */
198   function add(Role storage _role, address _addr)
199     internal
200   {
201     _role.bearer[_addr] = true;
202   }
203 
204   /**
205    * @dev remove an address' access to this role
206    */
207   function remove(Role storage _role, address _addr)
208     internal
209   {
210     _role.bearer[_addr] = false;
211   }
212 
213   /**
214    * @dev check if an address has this role
215    * // reverts
216    */
217   function check(Role storage _role, address _addr)
218     internal
219     view
220   {
221     require(has(_role, _addr));
222   }
223 
224   /**
225    * @dev check if an address has this role
226    * @return bool
227    */
228   function has(Role storage _role, address _addr)
229     internal
230     view
231     returns (bool)
232   {
233     return _role.bearer[_addr];
234   }
235 }
236 
237 /**
238  * @title RBAC (Role-Based Access Control)
239  * @author Matt Condon (@Shrugs)
240  * @dev Stores and provides setters and getters for roles and addresses.
241  * Supports unlimited numbers of roles and addresses.
242  * See //contracts/mocks/RBACMock.sol for an example of usage.
243  * This RBAC method uses strings to key roles. It may be beneficial
244  * for you to write your own implementation of this interface using Enums or similar.
245  */
246 contract RBAC {
247   using Roles for Roles.Role;
248 
249   mapping (string => Roles.Role) private roles;
250 
251   event RoleAdded(address indexed operator, string role);
252   event RoleRemoved(address indexed operator, string role);
253 
254   /**
255    * @dev reverts if addr does not have role
256    * @param _operator address
257    * @param _role the name of the role
258    * // reverts
259    */
260   function checkRole(address _operator, string _role)
261     public
262     view
263   {
264     roles[_role].check(_operator);
265   }
266 
267   /**
268    * @dev determine if addr has role
269    * @param _operator address
270    * @param _role the name of the role
271    * @return bool
272    */
273   function hasRole(address _operator, string _role)
274     public
275     view
276     returns (bool)
277   {
278     return roles[_role].has(_operator);
279   }
280 
281   /**
282    * @dev add a role to an address
283    * @param _operator address
284    * @param _role the name of the role
285    */
286   function addRole(address _operator, string _role)
287     internal
288   {
289     roles[_role].add(_operator);
290     emit RoleAdded(_operator, _role);
291   }
292 
293   /**
294    * @dev remove a role from an address
295    * @param _operator address
296    * @param _role the name of the role
297    */
298   function removeRole(address _operator, string _role)
299     internal
300   {
301     roles[_role].remove(_operator);
302     emit RoleRemoved(_operator, _role);
303   }
304 
305   /**
306    * @dev modifier to scope access to a single role (uses msg.sender as addr)
307    * @param _role the name of the role
308    * // reverts
309    */
310   modifier onlyRole(string _role)
311   {
312     checkRole(msg.sender, _role);
313     _;
314   }
315 
316   /**
317    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
318    * @param _roles the names of the roles to scope access to
319    * // reverts
320    *
321    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
322    *  see: https://github.com/ethereum/solidity/issues/2467
323    */
324   // modifier onlyRoles(string[] _roles) {
325   //     bool hasAnyRole = false;
326   //     for (uint8 i = 0; i < _roles.length; i++) {
327   //         if (hasRole(msg.sender, _roles[i])) {
328   //             hasAnyRole = true;
329   //             break;
330   //         }
331   //     }
332 
333   //     require(hasAnyRole);
334 
335   //     _;
336   // }
337 }
338 
339 contract Crowdsale {
340  using SafeMath for uint256;
341  using SafeERC20 for ERC20;
342 
343  // The token being sold
344  ERC20 public token;
345 
346  // Address where funds are collected
347  address public wallet;
348 
349  // How many token units a buyer gets per wei.
350  // The rate is the conversion between wei and the smallest and indivisible token unit.
351  // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
352  // 1 wei will give you 1 unit, or 0.001 TOK.
353  uint256 public rate;
354 
355  // Amount of wei raised
356  uint256 public weiRaised;
357 
358  /**
359   * Event for token purchase logging
360   * @param purchaser who paid for the tokens
361   * @param beneficiary who got the tokens
362   * @param value weis paid for purchase
363   * @param amount amount of tokens purchased
364   */
365  event TokenPurchase(
366    address indexed purchaser,
367    address indexed beneficiary,
368    uint256 value,
369    uint256 amount
370  );
371 
372  /**
373   * @param _rate Number of token units a buyer gets per wei
374   * @param _wallet Address where collected funds will be forwarded to
375   * @param _token Address of the token being sold
376   */
377  constructor(uint256 _rate, address _wallet, ERC20 _token) public {
378    require(_rate > 0);
379    require(_wallet != address(0));
380    require(_token != address(0));
381 
382    rate = _rate;
383    wallet = _wallet;
384    token = _token;
385  }
386 
387  // -----------------------------------------
388  // Crowdsale external interface
389  // -----------------------------------------
390 
391  /**
392   * @dev fallback function ***DO NOT OVERRIDE***
393   */
394  function () external payable {
395    buyTokens(msg.sender);
396  }
397 
398  /**
399   * @dev low level token purchase ***DO NOT OVERRIDE***
400   * @param _beneficiary Address performing the token purchase
401   */
402  function buyTokens(address _beneficiary) public payable {
403 
404    uint256 weiAmount = msg.value;
405    _preValidatePurchase(_beneficiary, weiAmount);
406 
407    // calculate token amount to be created
408    uint256 tokens = _getTokenAmount(weiAmount);
409 
410    // update state
411    weiRaised = weiRaised.add(weiAmount);
412 
413    _processPurchase(_beneficiary, tokens);
414    emit TokenPurchase(
415      msg.sender,
416      _beneficiary,
417      weiAmount,
418      tokens
419    );
420 
421    _updatePurchasingState(_beneficiary, weiAmount);
422 
423    _forwardFunds();
424    _postValidatePurchase(_beneficiary, weiAmount);
425  }
426 
427  // -----------------------------------------
428  // Internal interface (extensible)
429  // -----------------------------------------
430 
431  /**
432   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
433   * Example from CappedCrowdsale.sol's _preValidatePurchase method:
434   *   super._preValidatePurchase(_beneficiary, _weiAmount);
435   *   require(weiRaised.add(_weiAmount) <= cap);
436   * @param _beneficiary Address performing the token purchase
437   * @param _weiAmount Value in wei involved in the purchase
438   */
439  function _preValidatePurchase(
440    address _beneficiary,
441    uint256 _weiAmount
442  )
443    internal
444  {
445    require(_beneficiary != address(0));
446    require(_weiAmount != 0);
447  }
448 
449  /**
450   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
451   * @param _beneficiary Address performing the token purchase
452   * @param _weiAmount Value in wei involved in the purchase
453   */
454  function _postValidatePurchase(
455    address _beneficiary,
456    uint256 _weiAmount
457  )
458    internal
459  {
460    // optional override
461  }
462 
463  /**
464   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
465   * @param _beneficiary Address performing the token purchase
466   * @param _tokenAmount Number of tokens to be emitted
467   */
468  function _deliverTokens(
469    address _beneficiary,
470    uint256 _tokenAmount
471  )
472    internal
473  {
474    token.safeTransfer(_beneficiary, _tokenAmount);
475  }
476 
477  /**
478   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
479   * @param _beneficiary Address receiving the tokens
480   * @param _tokenAmount Number of tokens to be purchased
481   */
482  function _processPurchase(
483    address _beneficiary,
484    uint256 _tokenAmount
485  )
486    internal
487  {
488    _deliverTokens(_beneficiary, _tokenAmount);
489  }
490 
491  /**
492   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
493   * @param _beneficiary Address receiving the tokens
494   * @param _weiAmount Value in wei involved in the purchase
495   */
496  function _updatePurchasingState(
497    address _beneficiary,
498    uint256 _weiAmount
499  )
500    internal
501  {
502    // optional override
503  }
504 
505  /**
506   * @dev Override to extend the way in which ether is converted to tokens.
507   * @param _weiAmount Value in wei to be converted into tokens
508   * @return Number of tokens that can be purchased with the specified _weiAmount
509   */
510  function _getTokenAmount(uint256 _weiAmount)
511    internal view returns (uint256)
512  {
513    return _weiAmount.mul(rate);
514  }
515 
516  /**
517   * @dev Determines how ETH is stored/forwarded on purchases.
518   */
519  function _forwardFunds() internal {
520    wallet.transfer(msg.value);
521  }
522 }
523 
524 contract TimedCrowdsale is Crowdsale {
525   using SafeMath for uint256;
526 
527   uint256 public openingTime;
528   uint256 public closingTime;
529 
530   /**
531    * @dev Reverts if not in crowdsale time range.
532    */
533   modifier onlyWhileOpen {
534     // solium-disable-next-line security/no-block-members
535     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
536     _;
537   }
538 
539   /**
540    * @dev Constructor, takes crowdsale opening and closing times.
541    * @param _openingTime Crowdsale opening time
542    * @param _closingTime Crowdsale closing time
543    */
544   constructor(uint256 _openingTime, uint256 _closingTime) public {
545     // solium-disable-next-line security/no-block-members
546     require(_openingTime >= block.timestamp);
547     require(_closingTime >= _openingTime);
548 
549     openingTime = _openingTime;
550     closingTime = _closingTime;
551   }
552 
553   /**
554    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
555    * @return Whether crowdsale period has elapsed
556    */
557   function hasClosed() public view returns (bool) {
558     // solium-disable-next-line security/no-block-members
559     return block.timestamp > closingTime;
560   }
561 
562   /**
563    * @dev Extend parent behavior requiring to be within contributing period
564    * @param _beneficiary Token purchaser
565    * @param _weiAmount Amount of wei contributed
566    */
567   function _preValidatePurchase(
568     address _beneficiary,
569     uint256 _weiAmount
570   )
571     internal
572     onlyWhileOpen
573   {
574     super._preValidatePurchase(_beneficiary, _weiAmount);
575   }
576 
577 }
578 
579 contract Whitelist is Ownable, RBAC {
580   string public constant ROLE_WHITELISTED = "whitelist";
581 
582   /**
583    * @dev Throws if operator is not whitelisted.
584    * @param _operator address
585    */
586   modifier onlyIfWhitelisted(address _operator) {
587     checkRole(_operator, ROLE_WHITELISTED);
588     _;
589   }
590 
591   /**
592    * @dev add an address to the whitelist
593    * @param _operator address
594    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
595    */
596   function addAddressToWhitelist(address _operator)
597     public
598     onlyOwner
599   {
600     addRole(_operator, ROLE_WHITELISTED);
601   }
602 
603   /**
604    * @dev getter to determine if address is in whitelist
605    */
606   function whitelist(address _operator)
607     public
608     view
609     returns (bool)
610   {
611     return hasRole(_operator, ROLE_WHITELISTED);
612   }
613 
614   /**
615    * @dev add addresses to the whitelist
616    * @param _operators addresses
617    * @return true if at least one address was added to the whitelist,
618    * false if all addresses were already in the whitelist
619    */
620   function addAddressesToWhitelist(address[] _operators)
621     public
622     onlyOwner
623   {
624     for (uint256 i = 0; i < _operators.length; i++) {
625       addAddressToWhitelist(_operators[i]);
626     }
627   }
628 
629   /**
630    * @dev remove an address from the whitelist
631    * @param _operator address
632    * @return true if the address was removed from the whitelist,
633    * false if the address wasn't in the whitelist in the first place
634    */
635   function removeAddressFromWhitelist(address _operator)
636     public
637     onlyOwner
638   {
639     removeRole(_operator, ROLE_WHITELISTED);
640   }
641 
642   /**
643    * @dev remove addresses from the whitelist
644    * @param _operators addresses
645    * @return true if at least one address was removed from the whitelist,
646    * false if all addresses weren't in the whitelist in the first place
647    */
648   function removeAddressesFromWhitelist(address[] _operators)
649     public
650     onlyOwner
651   {
652     for (uint256 i = 0; i < _operators.length; i++) {
653       removeAddressFromWhitelist(_operators[i]);
654     }
655   }
656 
657 }
658 
659 contract WhitelistedCrowdsale is Whitelist, Crowdsale {
660   /**
661    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
662    * @param _beneficiary Token beneficiary
663    * @param _weiAmount Amount of wei contributed
664    */
665   function _preValidatePurchase(
666     address _beneficiary,
667     uint256 _weiAmount
668   )
669     internal
670     onlyIfWhitelisted(_beneficiary)
671   {
672     super._preValidatePurchase(_beneficiary, _weiAmount);
673   }
674 
675 }
676 
677 contract CbntCrowdsale is TimedCrowdsale, WhitelistedCrowdsale {
678  using SafeMath for uint256;
679 
680 
681  struct FutureTransaction{
682    address beneficiary;
683    uint256 num;
684    uint32  times;
685    uint256 lastTime;
686  }
687  FutureTransaction[] public futureTrans;
688  uint256 public oweCbnt;
689 
690  uint256[] public rateSteps;
691  uint256[] public rateStepsValue;
692  uint32[] public regularTransTime;
693  uint32 public transTimes;
694 
695  uint256 public minInvest;
696 
697 /**
698   * @param _openingTime Crowdsale opening time
699   * @param _closingTime Crowdsale closing time
700   * @param _rate Number of token units a buyer gets per wei
701   * @param _wallet Address where collected funds will be forwarded to
702   * @param _token Address of the token being sold
703   */
704  constructor(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, ERC20 _token) TimedCrowdsale(_openingTime,_closingTime) Crowdsale(_rate,_wallet, _token) public {
705   // Crowdsale(uint256(1),_wallet, _token);
706    //TimedCrowdsale(_openingTime,_closingTime);
707  }
708 
709  /** external functions **/
710  function triggerTransaction(uint256 beginIdx, uint256 endIdx) public returns (bool){
711    uint32 regularTime = findRegularTime();
712    require(regularTime > 0 && endIdx < futureTrans.length);
713 
714    bool bRemove = false;
715    uint256 i = 0;
716    for(i = beginIdx; i<=endIdx && i<futureTrans.length; ){
717      bRemove = false;
718      if(futureTrans[i].lastTime < regularTime){  // need to set the regularTime again when it comes late than the last regularTime
719         uint256 transNum = futureTrans[i].num;
720         address beneficiary = futureTrans[i].beneficiary;
721         //update data
722 
723         futureTrans[i].lastTime = now;
724         futureTrans[i].times = futureTrans[i].times - 1;
725         require(futureTrans[i].times <= transTimes);
726 
727         // remove item if it is the last time transaction
728         if(futureTrans[i].times ==0 ){
729            bRemove = true;
730            futureTrans[i].beneficiary = futureTrans[futureTrans.length -1].beneficiary;
731            futureTrans[i].num = futureTrans[futureTrans.length -1].num;
732            futureTrans[i].lastTime = futureTrans[futureTrans.length -1].lastTime;
733            futureTrans[i].times = futureTrans[futureTrans.length -1].times;
734            futureTrans.length = futureTrans.length.sub(1);
735         }
736            // transfer token
737         oweCbnt = oweCbnt.sub(transNum);
738         _deliverTokens(beneficiary, transNum);
739      }
740 
741      if(!bRemove){
742        i++;
743      }
744    }
745 
746    return true;
747 
748  }
749  function transferBonus(address _beneficiary, uint256 _tokenAmount) public onlyOwner returns(bool){
750    _deliverTokens(_beneficiary, _tokenAmount);
751    return true;
752  }
753 
754  // need to set this param before start business
755  function setMinInvest(uint256 _minInvest) public onlyOwner returns (bool){
756    minInvest = _minInvest;
757    return true;
758  }
759 
760  // need to set this param before start business
761  function setTransTimes(uint32 _times) public onlyOwner returns (bool){
762    transTimes = _times;
763    return true;
764  }
765 
766  function setRegularTransTime(uint32[] _times) public onlyOwner returns (bool){
767    for (uint256 i = 0; i + 1 < _times.length; i++) {
768        require(_times[i] < _times[i+1]);
769    }
770 
771    regularTransTime = _times;
772    return true;
773  }
774 
775  // need to set this param before start business
776  function setRateSteps(uint256[] _steps, uint256[] _stepsValue) public onlyOwner returns (bool){
777    require(_steps.length == _stepsValue.length);
778    for (uint256 i = 0; i + 1 < _steps.length; i++) {
779        require(_steps[i] > _steps[i+1]);
780    }
781 
782    rateSteps = _steps;
783    rateStepsValue = _stepsValue;
784    return true;
785  }
786 
787  // need to check these params before start business
788  function normalCheck() public view returns (bool){
789    return (transTimes > 0 && regularTransTime.length > 0 && minInvest >0 && rateSteps.length >0);
790  }
791 
792  function getFutureTransLength() public view returns(uint256) {
793      return futureTrans.length;
794  }
795  function getFutureTransByIdx(uint256 _idx) public view returns(address,uint256, uint32, uint256) {
796      return (futureTrans[_idx].beneficiary, futureTrans[_idx].num, futureTrans[_idx].times, futureTrans[_idx].lastTime);
797  }
798  function getFutureTransIdxByAddress(address _beneficiary) public view returns(uint256[]) {
799      uint256 i = 0;
800      uint256 num = 0;
801      for(i=0; i<futureTrans.length; i++){
802        if(futureTrans[i].beneficiary == _beneficiary){
803            num++;
804        }
805      }
806      uint256[] memory transList = new uint256[](num);
807 
808      uint256 idx = 0;
809      for(i=0; i<futureTrans.length; i++){
810        if(futureTrans[i].beneficiary == _beneficiary){
811          transList[idx] = i;
812          idx++;
813        }
814      }
815      return transList;
816  }
817 
818  /** internal functions **/
819  /**
820   * @dev Returns the rate of tokens per wei.
821   * Note that, as price _increases_ with invest number, the rate _increases_.
822   * @param _weiAmount The value in wei to be converted into tokens
823   * @return The number of tokens a buyer gets per wei
824   */
825  function getCurrentRate(uint256 _weiAmount) public view returns (uint256) {
826    for (uint256 i = 0; i < rateSteps.length; i++) {
827        if (_weiAmount >= rateSteps[i]) {
828            return rateStepsValue[i];
829        }
830    }
831    return 0;
832  }
833 
834  /**
835   * @dev Overrides parent method taking into account variable rate.
836   * @param _weiAmount The value in wei to be converted into tokens
837   * @return The number of tokens _weiAmount wei will send at present time
838   */
839  function _getTokenAmount(uint256 _weiAmount)
840    internal view returns (uint256)
841  {
842    uint256 currentRate = getCurrentRate(_weiAmount);
843    return currentRate.mul(_weiAmount).div(transTimes);
844  }
845 
846  /**
847   * @dev Extend parent behavior requiring to be within contributing period
848   * @param _beneficiary Token purchaser
849   * @param _weiAmount Amount of wei contributed
850   */
851  function _preValidatePurchase(
852    address _beneficiary,
853    uint256 _weiAmount
854  )
855    internal
856  {
857    require(msg.value >= minInvest);
858    super._preValidatePurchase(_beneficiary, _weiAmount);
859  }
860 
861  /**
862   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
863   * @param _beneficiary Address receiving the tokens
864   * @param _tokenAmount Number of tokens to be purchased
865   */
866  function _processPurchase(
867    address _beneficiary,
868    uint256 _tokenAmount
869  )
870    internal
871  {
872    // update the future transactions for future using.
873    FutureTransaction memory tran = FutureTransaction(_beneficiary, _tokenAmount, transTimes-1, now); // the trtanstimes always lagger than 0
874    futureTrans.push(tran);
875 
876    //update owe cbnt
877    oweCbnt = oweCbnt.add(_tokenAmount.mul(tran.times));
878    super._processPurchase(_beneficiary, _tokenAmount);
879  }
880 
881  function findRegularTime() internal view returns (uint32) {
882    if(now < regularTransTime[0]){
883      return 0;
884    }
885 
886    uint256 i = 0;
887    while(i<regularTransTime.length && now >= regularTransTime[i]){
888      i++;
889    }
890 
891    return regularTransTime[i -1];
892 
893  }
894 
895 }