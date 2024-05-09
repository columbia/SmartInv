1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 library Percent {
51   using SafeMath for uint256;
52   /**
53    * @dev Add percent to numerator variable with precision
54    */
55   function perc
56   (
57     uint256 initialValue,
58     uint256 percent
59   ) 
60     internal 
61     pure 
62     returns(uint256 result) 
63   { 
64     return initialValue.div(100).mul(percent);
65   }
66 }
67 
68 /**
69  * @title Roles
70  * @author Francisco Giordano (@frangio)
71  * @dev Library for managing addresses assigned to a Role.
72  * See RBAC.sol for example usage.
73  */
74 library Roles {
75   struct Role {
76     mapping (address => bool) bearer;
77   }
78 
79   /**
80    * @dev give an address access to this role
81    */
82   function add(Role storage role, address addr)
83     internal
84   {
85     role.bearer[addr] = true;
86   }
87 
88   /**
89    * @dev remove an address' access to this role
90    */
91   function remove(Role storage role, address addr)
92     internal
93   {
94     role.bearer[addr] = false;
95   }
96 
97   /**
98    * @dev check if an address has this role
99    * // reverts
100    */
101   function check(Role storage role, address addr)
102     view
103     internal
104   {
105     require(has(role, addr));
106   }
107 
108   /**
109    * @dev check if an address has this role
110    * @return bool
111    */
112   function has(Role storage role, address addr)
113     view
114     internal
115     returns (bool)
116   {
117     return role.bearer[addr];
118   }
119 }
120 
121 /**
122  * @title RBAC (Role-Based Access Control)
123  * @author Matt Condon (@Shrugs)
124  * @dev Stores and provides setters and getters for roles and addresses.
125  * Supports unlimited numbers of roles and addresses.
126  * See //contracts/mocks/RBACMock.sol for an example of usage.
127  * This RBAC method uses strings to key roles. It may be beneficial
128  * for you to write your own implementation of this interface using Enums or similar.
129  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
130  * to avoid typos.
131  */
132 contract RBAC {
133   using Roles for Roles.Role;
134 
135   mapping (string => Roles.Role) private roles;
136 
137   event RoleAdded(address indexed operator, string role);
138   event RoleRemoved(address indexed operator, string role);
139 
140   /**
141    * @dev reverts if addr does not have role
142    * @param _operator address
143    * @param _role the name of the role
144    * // reverts
145    */
146   function checkRole(address _operator, string _role)
147     view
148     public
149   {
150     roles[_role].check(_operator);
151   }
152 
153   /**
154    * @dev determine if addr has role
155    * @param _operator address
156    * @param _role the name of the role
157    * @return bool
158    */
159   function hasRole(address _operator, string _role)
160     view
161     public
162     returns (bool)
163   {
164     return roles[_role].has(_operator);
165   }
166 
167   /**
168    * @dev add a role to an address
169    * @param _operator address
170    * @param _role the name of the role
171    */
172   function addRole(address _operator, string _role)
173     internal
174   {
175     roles[_role].add(_operator);
176     emit RoleAdded(_operator, _role);
177   }
178 
179   /**
180    * @dev remove a role from an address
181    * @param _operator address
182    * @param _role the name of the role
183    */
184   function removeRole(address _operator, string _role)
185     internal
186   {
187     roles[_role].remove(_operator);
188     emit RoleRemoved(_operator, _role);
189   }
190 
191   /**
192    * @dev modifier to scope access to a single role (uses msg.sender as addr)
193    * @param _role the name of the role
194    * // reverts
195    */
196   modifier onlyRole(string _role)
197   {
198     checkRole(msg.sender, _role);
199     _;
200   }
201 
202 }
203 
204 
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
234    * @notice Renouncing to ownership will leave the contract without an owner.
235    * It will not be possible to call the functions with the `onlyOwner`
236    * modifier anymore.
237    */
238   function renounceOwnership() public onlyOwner {
239     emit OwnershipRenounced(owner);
240     owner = address(0);
241   }
242 
243   /**
244    * @dev Allows the current owner to transfer control of the contract to a newOwner.
245    * @param _newOwner The address to transfer ownership to.
246    */
247   function transferOwnership(address _newOwner) public onlyOwner {
248     _transferOwnership(_newOwner);
249   }
250 
251   /**
252    * @dev Transfers control of the contract to a newOwner.
253    * @param _newOwner The address to transfer ownership to.
254    */
255   function _transferOwnership(address _newOwner) internal {
256     require(_newOwner != address(0));
257     emit OwnershipTransferred(owner, _newOwner);
258     owner = _newOwner;
259   }
260 }
261 
262 /**
263  * @title ERC20 interface
264  * @dev see https://github.com/ethereum/EIPs/issues/20
265  */
266 interface IERC20 {
267     function totalSupply() external view returns (uint256);
268 
269     function balanceOf(address who) external view returns (uint256);
270 
271     function allowance(address owner, address spender) external view returns (uint256);
272 
273     function transfer(address to, uint256 value) external returns (bool);
274 
275     function approve(address spender, uint256 value) external returns (bool);
276 
277     function transferFrom(address from, address to, uint256 value) external returns (bool);
278 
279     event Transfer(address indexed from, address indexed to, uint256 value);
280 
281     event Approval(address indexed owner, address indexed spender, uint256 value);
282 }
283 
284 /**
285  * @title SafeERC20
286  * @dev Wrappers around ERC20 operations that throw on failure.
287  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
288  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
289  */
290 library SafeERC20 {
291     using SafeMath for uint256;
292 
293     function safeTransfer(IERC20 token, address to, uint256 value) internal {
294         require(token.transfer(to, value));
295     }
296 
297     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
298         require(token.transferFrom(from, to, value));
299     }
300 
301     function safeApprove(IERC20 token, address spender, uint256 value) internal {
302         // safeApprove should only be called when setting an initial allowance,
303         // or when resetting it to zero. To increase and decrease it, use
304         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
305         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
306         require(token.approve(spender, value));
307     }
308 
309     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
310         uint256 newAllowance = token.allowance(address(this), spender).add(value);
311         require(token.approve(spender, newAllowance));
312     }
313 
314     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
315         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
316         require(token.approve(spender, newAllowance));
317     }
318 }
319 
320 
321 /**
322  * @title TokenVesting
323  * @dev A token holder contract that can release its token balance gradually like a
324  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
325  * owner.
326  */
327 contract TokenVesting is Ownable {
328   using SafeMath for uint256;
329 
330   // Token release event, emits once owner releasing his tokens 
331   event Released(uint256 amount);
332 
333   // Token revoke event
334   event Revoked();
335 
336   // beneficiary of tokens after they are released
337   address public beneficiary;
338 
339   // start
340   uint256 public start;
341 
342   /**
343    * Variables for setup vesting and release periods
344    */
345   uint256 public duration = 23667695;
346   uint256 public firstStage = 7889229;
347   uint256 public secondStage = 15778458;
348   
349 
350   bool public revocable;
351 
352   mapping (address => uint256) public released;
353   mapping (address => bool) public revoked;
354 
355   /**
356    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
357    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
358    * of the balance will have vested.
359    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
360    * @param _start the time (as Unix time) at which point vesting starts 
361    * @param _revocable whether the vesting is revocable or not
362    */
363   constructor(
364     address _beneficiary,
365     uint256 _start,
366     bool _revocable
367   )
368     public
369   {
370     require(_beneficiary != address(0));
371     beneficiary = _beneficiary;
372     revocable = _revocable;
373     start = _start;
374   }
375 
376   /**
377    * @notice Transfers vested tokens to beneficiary.
378    * @param token ERC20 token which is being vested
379    */
380   function release(ERC20 token) public {
381     uint256 unreleased = releasableAmount(token);
382 
383     require(unreleased > 0);
384 
385     released[token] = released[token].add(unreleased);
386 
387     token.transfer(beneficiary, unreleased);
388 
389     emit Released(unreleased);
390   }
391 
392   /**
393    * @notice Allows the owner to revoke the vesting. Tokens already vested
394    * remain in the contract, the rest are returned to the owner.
395    * @param token ERC20 token which is being vested
396    */
397   function revoke(ERC20 token) public onlyOwner {
398     require(revocable);
399     require(!revoked[token]);
400 
401     uint256 balance = token.balanceOf(this);
402 
403     uint256 unreleased = releasableAmount(token);
404     uint256 refund = balance.sub(unreleased);
405 
406     revoked[token] = true;
407 
408     token.transfer(owner, refund);
409 
410     emit Revoked();
411   }
412 
413   /**
414    * @dev Calculates the amount that has already vested but hasn't been released yet.
415    * @param token ERC20 token which is being vested
416    */
417   function releasableAmount(ERC20 token) public view returns (uint256) {
418     return vestedAmount(token).sub(released[token]);
419   }
420 
421   /**
422    * @dev Calculates the amount that has already vested.
423    * @param token ERC20 token which is being vested
424    */
425   function vestedAmount(ERC20 token) public view returns (uint256) {
426     uint256 currentBalance = token.balanceOf(this);
427     uint256 totalBalance = currentBalance.add(released[token]);
428 
429     if (block.timestamp >= start.add(duration) || revoked[token]) {
430       return totalBalance;
431     } 
432 
433     if(block.timestamp >= start.add(firstStage) && block.timestamp <= start.add(secondStage)){
434       return totalBalance.div(3);
435     }
436 
437     if(block.timestamp >= start.add(secondStage) && block.timestamp <= start.add(duration)){
438       return totalBalance.div(3).mul(2);
439     }
440 
441     return 0;
442   }
443 }
444 
445 
446 /**
447  * @title Whitelist
448  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
449  * This simplifies the implementation of "user permissions".
450  */
451 contract Whitelist is Ownable, RBAC {
452   string public constant ROLE_WHITELISTED = "whitelist";
453 
454   /**
455    * @dev Throws if operator is not whitelisted.
456    * @param _operator address
457    */
458   modifier onlyIfWhitelisted(address _operator) {
459     checkRole(_operator, ROLE_WHITELISTED);
460     _;
461   }
462 
463   /**
464    * @dev add an address to the whitelist
465    * @param _operator address
466    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
467    */
468   function addAddressToWhitelist(address _operator)
469     onlyOwner
470     public
471   {
472     addRole(_operator, ROLE_WHITELISTED);
473   }
474 
475   /**
476    * @dev getter to determine if address is in whitelist
477    */
478   function whitelist(address _operator)
479     public
480     view
481     returns (bool)
482   {
483     return hasRole(_operator, ROLE_WHITELISTED);
484   }
485 
486   /**
487    * @dev add addresses to the whitelist
488    * @param _operators addresses
489    * @return true if at least one address was added to the whitelist,
490    * false if all addresses were already in the whitelist
491    */
492   function addAddressesToWhitelist(address[] _operators)
493     onlyOwner
494     public
495   {
496     for (uint256 i = 0; i < _operators.length; i++) {
497       addAddressToWhitelist(_operators[i]);
498     }
499   }
500 
501   /**
502    * @dev remove an address from the whitelist
503    * @param _operator address
504    * @return true if the address was removed from the whitelist,
505    * false if the address wasn't in the whitelist in the first place
506    */
507   function removeAddressFromWhitelist(address _operator)
508     onlyOwner
509     public
510   {
511     removeRole(_operator, ROLE_WHITELISTED);
512   }
513 
514   /**
515    * @dev remove addresses from the whitelist
516    * @param _operators addresses
517    * @return true if at least one address was removed from the whitelist,
518    * false if all addresses weren't in the whitelist in the first place
519    */
520   function removeAddressesFromWhitelist(address[] _operators)
521     onlyOwner
522     public
523   {
524     for (uint256 i = 0; i < _operators.length; i++) {
525       removeAddressFromWhitelist(_operators[i]);
526     }
527   }
528 
529 }
530 
531 
532 contract Pausable is Ownable {
533   event Pause();
534   event Unpause();
535 
536   bool public paused = false;
537 
538 
539   /**
540    * @dev Modifier to make a function callable only when the contract is not paused.
541    */
542   modifier whenNotPaused() {
543     require(!paused);
544     _;
545   }
546 
547   /**
548    * @dev Modifier to make a function callable only when the contract is paused.
549    */
550   modifier whenPaused() {
551     require(paused);
552     _;
553   }
554 
555   /**
556    * @dev called by the owner to pause, triggers stopped state
557    */
558   function pause() onlyOwner whenNotPaused public {
559     paused = true;
560     emit Pause();
561   }
562 
563   /**
564    * @dev called by the owner to unpause, returns to normal state
565    */
566   function unpause() onlyOwner whenPaused public {
567     paused = false;
568     emit Unpause();
569   }
570 }
571 
572 
573 contract ERC20Basic {
574   function totalSupply() public view returns (uint256);
575   function balanceOf(address who) public view returns (uint256);
576   function transfer(address to, uint256 value) public returns (bool);
577   event Transfer(address indexed from, address indexed to, uint256 value);
578 }
579 
580 
581 contract ERC20 is ERC20Basic {
582   function allowance(address owner, address spender)
583     public view returns (uint256);
584 
585   function transferFrom(address from, address to, uint256 value)
586     public returns (bool);
587 
588   function approve(address spender, uint256 value) public returns (bool);
589   event Approval(
590     address indexed owner,
591     address indexed spender,
592     uint256 value
593   );
594 }
595 
596 
597 contract BasicToken is ERC20Basic {
598   using SafeMath for uint256;
599 
600   mapping(address => uint256) balances;
601 
602   uint256 totalSupply_;
603 
604   /**
605   * @dev Total number of tokens in existence
606   */
607   function totalSupply() public view returns (uint256) {
608     return totalSupply_;
609   }
610 
611   /**
612   * @dev Transfer token for a specified address
613   * @param _to The address to transfer to.
614   * @param _value The amount to be transferred.
615   */
616   function transfer(address _to, uint256 _value) public returns (bool) {
617     require(_to != address(0));
618     require(_value <= balances[msg.sender]);
619 
620     balances[msg.sender] = balances[msg.sender].sub(_value);
621     balances[_to] = balances[_to].add(_value);
622     emit Transfer(msg.sender, _to, _value);
623     return true;
624   }
625 
626   /**
627   * @dev Gets the balance of the specified address.
628   * @param _owner The address to query the the balance of.
629   * @return An uint256 representing the amount owned by the passed address.
630   */
631   function balanceOf(address _owner) public view returns (uint256) {
632     return balances[_owner];
633   }
634 
635 }
636 
637 
638 contract StandardToken is ERC20, BasicToken {
639 
640   mapping (address => mapping (address => uint256)) internal allowed;
641 
642 
643   /**
644    * @dev Transfer tokens from one address to another
645    * @param _from address The address which you want to send tokens from
646    * @param _to address The address which you want to transfer to
647    * @param _value uint256 the amount of tokens to be transferred
648    */
649   function transferFrom(
650     address _from,
651     address _to,
652     uint256 _value
653   )
654     public
655     returns (bool)
656   {
657     require(_to != address(0));
658     require(_value <= balances[_from]);
659     require(_value <= allowed[_from][msg.sender]);
660 
661     balances[_from] = balances[_from].sub(_value);
662     balances[_to] = balances[_to].add(_value);
663     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
664     emit Transfer(_from, _to, _value);
665     return true;
666   }
667 
668   /**
669    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
670    * Beware that changing an allowance with this method brings the risk that someone may use both the old
671    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
672    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
673    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
674    * @param _spender The address which will spend the funds.
675    * @param _value The amount of tokens to be spent.
676    */
677   function approve(address _spender, uint256 _value) public returns (bool) {
678     allowed[msg.sender][_spender] = _value;
679     emit Approval(msg.sender, _spender, _value);
680     return true;
681   }
682 
683   /**
684    * @dev Function to check the amount of tokens that an owner allowed to a spender.
685    * @param _owner address The address which owns the funds.
686    * @param _spender address The address which will spend the funds.
687    * @return A uint256 specifying the amount of tokens still available for the spender.
688    */
689   function allowance(
690     address _owner,
691     address _spender
692    )
693     public
694     view
695     returns (uint256)
696   {
697     return allowed[_owner][_spender];
698   }
699 
700   /**
701    * @dev Increase the amount of tokens that an owner allowed to a spender.
702    * approve should be called when allowed[_spender] == 0. To increment
703    * allowed value is better to use this function to avoid 2 calls (and wait until
704    * the first transaction is mined)
705    * From MonolithDAO Token.sol
706    * @param _spender The address which will spend the funds.
707    * @param _addedValue The amount of tokens to increase the allowance by.
708    */
709   function increaseApproval(
710     address _spender,
711     uint256 _addedValue
712   )
713     public
714     returns (bool)
715   {
716     allowed[msg.sender][_spender] = (
717       allowed[msg.sender][_spender].add(_addedValue));
718     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
719     return true;
720   }
721 
722   /**
723    * @dev Decrease the amount of tokens that an owner allowed to a spender.
724    * approve should be called when allowed[_spender] == 0. To decrement
725    * allowed value is better to use this function to avoid 2 calls (and wait until
726    * the first transaction is mined)
727    * From MonolithDAO Token.sol
728    * @param _spender The address which will spend the funds.
729    * @param _subtractedValue The amount of tokens to decrease the allowance by.
730    */
731   function decreaseApproval(
732     address _spender,
733     uint256 _subtractedValue
734   )
735     public
736     returns (bool)
737   {
738     uint256 oldValue = allowed[msg.sender][_spender];
739     if (_subtractedValue > oldValue) {
740       allowed[msg.sender][_spender] = 0;
741     } else {
742       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
743     }
744     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
745     return true;
746   }
747 
748 }
749 
750 
751 contract PausableToken is StandardToken, Pausable {
752 
753   function transfer(
754     address _to,
755     uint256 _value
756   )
757     public
758     whenNotPaused
759     returns (bool)
760   {
761     return super.transfer(_to, _value);
762   }
763 
764   function transferFrom(
765     address _from,
766     address _to,
767     uint256 _value
768   )
769     public
770     whenNotPaused
771     returns (bool)
772   {
773     return super.transferFrom(_from, _to, _value);
774   }
775 
776   function approve(
777     address _spender,
778     uint256 _value
779   )
780     public
781     whenNotPaused
782     returns (bool)
783   {
784     return super.approve(_spender, _value);
785   }
786 
787   function increaseApproval(
788     address _spender,
789     uint _addedValue
790   )
791     public
792     whenNotPaused
793     returns (bool success)
794   {
795     return super.increaseApproval(_spender, _addedValue);
796   }
797 
798   function decreaseApproval(
799     address _spender,
800     uint _subtractedValue
801   )
802     public
803     whenNotPaused
804     returns (bool success)
805   {
806     return super.decreaseApproval(_spender, _subtractedValue);
807   }
808 }
809 
810 
811 contract TokenDestructible is Ownable {
812 
813   constructor() public payable { }
814 
815   /**
816    * @notice Terminate contract and refund to owner
817    * @notice The called token contracts could try to re-enter this contract. Only
818    supply token contracts you trust.
819    */
820   function destroy() onlyOwner public {
821     selfdestruct(owner);
822   }
823 }
824 
825 
826 contract Token is PausableToken, TokenDestructible {
827   /**
828    * Variables that define basic token features
829    */ 
830   uint256 public decimals;
831   string public name;
832   string public symbol;
833   uint256 releasedAmount = 0;
834 
835   constructor(uint256 _totalSupply, uint256 _decimals, string _name, string _symbol) public {
836     require(_totalSupply > 0);
837     require(_decimals > 0);
838 
839     totalSupply_ = _totalSupply;
840     decimals = _decimals;
841     name = _name;
842     symbol = _symbol;
843 
844     balances[msg.sender] = _totalSupply;
845 
846     // transfer all supply to the owner
847     emit Transfer(address(0), msg.sender, _totalSupply);
848   }
849 }
850 
851 /**
852  * @title Allocation
853  * Allocation is a base contract for managing a token sale,
854  * allowing investors to purchase tokens with ether.
855  */
856 contract Allocation is Whitelist {
857   using SafeMath for uint256;
858   using Percent for uint256;
859 
860   /**
861    * Event for token purchase logging
862    * @param purchaser who paid for the tokens
863    * @param beneficiary who got the tokens
864    * @param value weis paid for purchase
865    * @param amount amount of tokens purchased
866    */
867   event TokenPurchase(
868     address indexed purchaser,
869     address indexed beneficiary,
870     uint256 value,
871     uint256 amount
872   );
873 
874   event Finalized();
875 
876   /**
877    * Event for creation of token vesting contract
878    * @param beneficiary who will receive tokens 
879    * @param start time of vesting start
880    * @param revocable specifies if vesting contract has abitility to revoke
881    */
882   event TimeVestingCreation
883   (
884     address beneficiary,
885     uint256 start,
886     uint256 duration,
887     bool revocable
888   );
889 
890   struct PartInfo {
891     uint256 percent;
892     bool lockup;
893     uint256 amount;
894   }
895 
896   mapping (address => bool) public owners;
897   mapping (address => uint256) public contributors;            
898   mapping (address => TokenVesting) public vesting;
899   mapping (uint256 => PartInfo) public pieChart;
900   mapping (address => bool) public isInvestor;
901   
902   address[] public investors;
903 
904   /**
905    * Variables for bonus program
906    * ============================
907    * Variables values are test!!!
908    */
909   uint256 private SMALLEST_SUM; // 971911700000000000
910   uint256 private SMALLER_SUM;  // 291573500000000000000
911   uint256 private MEDIUM_SUM;   // 485955800000000000000
912   uint256 private BIGGER_SUM;   // 971911700000000000000
913   uint256 private BIGGEST_SUM;  // 1943823500000000000000
914 
915   // Vesting period
916   uint256 public duration = 23667695;
917 
918   // Flag of Finalized sale event
919   bool public isFinalized = false;
920 
921   // Wei raides accumulator
922   uint256 public weiRaised = 0;
923 
924   //
925   Token public token;
926   //
927   address public wallet;
928   uint256 public rate;  
929   uint256 public softCap;
930   uint256 public hardCap;
931 
932   /**
933    * @param _rate Number of token units a buyer gets per wei
934    * @param _wallet Address where collected funds will be forwarded to
935    * @param _token Address of the token being sold
936    * @param _softCap Soft cap
937    * @param _hardCap Hard cap
938    * @param _smallestSum Sum after which investor receives 5% of bonus tokens to vesting contract
939    * @param _smallerSum Sum after which investor receives 10% of bonus tokens to vesting contract
940    * @param _mediumSum Sum after which investor receives 15% of bonus tokens to vesting contract
941    * @param _biggerSum Sum after which investor receives 20% of bonus tokens to vesting contract
942    * @param _biggestSum Sum after which investor receives 30% of bonus tokens to vesting contract
943    */
944   constructor(
945     uint256 _rate, 
946     address _wallet, 
947     Token _token,
948     uint256 _softCap,
949     uint256 _hardCap,
950     uint256 _smallestSum,
951     uint256 _smallerSum,
952     uint256 _mediumSum,
953     uint256 _biggerSum,
954     uint256 _biggestSum
955   ) 
956     public 
957   {
958     require(_rate > 0);
959     require(_wallet != address(0));
960     require(_token != address(0));
961     require(_hardCap > 0);
962     require(_softCap > 0);
963     require(_hardCap > _softCap);
964 
965     rate = _rate;
966     wallet = _wallet;
967     token = _token;
968     hardCap = _hardCap;
969     softCap = _softCap;
970 
971     SMALLEST_SUM = _smallestSum;
972     SMALLER_SUM = _smallerSum;
973     MEDIUM_SUM = _mediumSum;
974     BIGGER_SUM = _biggerSum;
975     BIGGEST_SUM = _biggestSum;
976 
977     owners[msg.sender] = true;
978 
979     /**
980     * Pie chart 
981     *
982     * early cotributors => 1
983     * management team => 2
984     * advisors => 3
985     * partners => 4
986     * community => 5
987     * company => 6
988     * liquidity => 7
989     * sale => 8
990     */
991     pieChart[1] = PartInfo(10, true, token.totalSupply().mul(10).div(100));
992     pieChart[2] = PartInfo(15, true, token.totalSupply().mul(15).div(100));
993     pieChart[3] = PartInfo(5, true, token.totalSupply().mul(5).div(100));
994     pieChart[4] = PartInfo(5, false, token.totalSupply().mul(5).div(100));
995     pieChart[5] = PartInfo(8, false, token.totalSupply().mul(8).div(100));
996     pieChart[6] = PartInfo(17, false, token.totalSupply().mul(17).div(100));
997     pieChart[7] = PartInfo(10, false, token.totalSupply().mul(10).div(100));
998     pieChart[8] = PartInfo(30, false, token.totalSupply().mul(30).div(100));
999   }
1000 
1001   // -----------------------------------------
1002   // Allocation external interface
1003   // -----------------------------------------
1004   /**
1005    * Function for buying tokens
1006    */
1007   function() 
1008     external 
1009     payable 
1010   {
1011     buyTokens(msg.sender);
1012   }
1013 
1014   /**
1015    *  Check if value respects sale minimal contribution sum
1016    */
1017   modifier respectContribution() {
1018     require(
1019       msg.value >= SMALLEST_SUM,
1020       "Minimum contribution is $50,000"
1021     );
1022     _;
1023   }
1024 
1025 
1026   /**
1027    * Check if sale is still open
1028    */
1029   modifier onlyWhileOpen {
1030     require(!isFinalized, "Sale is closed");
1031     _;
1032   }
1033 
1034   /**
1035    * Check if sender is owner
1036    */
1037   modifier onlyOwner {
1038     require(isOwner(msg.sender) == true, "User is not in Owners");
1039     _;
1040   }
1041 
1042 
1043   /**
1044    * Add new owner
1045    * @param _owner Address of owner which should be added
1046    */
1047   function addOwner(address _owner) public onlyOwner {
1048     require(owners[_owner] == false);
1049     owners[_owner] = true;
1050   }
1051 
1052   /**
1053    * Delete an onwer
1054    * @param _owner Address of owner which should be deleted
1055    */
1056   function deleteOwner(address _owner) public onlyOwner {
1057     require(owners[_owner] == true);
1058     owners[_owner] = false;
1059   }
1060 
1061   /**
1062    * Check if sender is owner
1063    * @param _address Address of owner which should be checked
1064    */
1065   function isOwner(address _address) public view returns(bool res) {
1066     return owners[_address];
1067   }
1068   
1069   /**
1070    * Allocate tokens to provided investors
1071    */
1072   function allocateTokens(address[] _investors) public onlyOwner {
1073     require(_investors.length <= 50);
1074     
1075     for (uint i = 0; i < _investors.length; i++) {
1076       allocateTokensInternal(_investors[i]);
1077     }
1078   }
1079 
1080   /**
1081    * Allocate tokens to a single investor
1082    * @param _contributor Address of the investor
1083    */
1084   function allocateTokensForContributor(address _contributor) public onlyOwner {
1085     allocateTokensInternal(_contributor);
1086   }
1087 
1088   /*
1089    * Allocates tokens to single investor
1090    * @param _contributor Investor address
1091    */
1092   function allocateTokensInternal(address _contributor) internal {
1093     uint256 weiAmount = contributors[_contributor];
1094 
1095     if (weiAmount > 0) {
1096       uint256 tokens = _getTokenAmount(weiAmount);
1097       uint256 bonusTokens = _getBonusTokens(weiAmount);
1098 
1099       pieChart[8].amount = pieChart[8].amount.sub(tokens);
1100       pieChart[1].amount = pieChart[1].amount.sub(bonusTokens);
1101 
1102       contributors[_contributor] = 0;
1103 
1104       token.transfer(_contributor, tokens);
1105       createTimeBasedVesting(_contributor, bonusTokens);
1106     }
1107   }
1108   
1109   /**
1110    * Send funds from any part of pieChart
1111    * @param _to Investors address
1112    * @param _type Part of pieChart
1113    * @param _amount Amount of tokens
1114    */
1115   function sendFunds(address _to, uint256 _type, uint256 _amount) public onlyOwner {
1116     require(
1117       pieChart[_type].amount >= _amount &&
1118       _type >= 1 &&
1119       _type <= 8
1120     );
1121 
1122     if (pieChart[_type].lockup == true) {
1123       createTimeBasedVesting(_to, _amount);
1124     } else {
1125       token.transfer(_to, _amount);
1126     }
1127     
1128     pieChart[_type].amount -= _amount;
1129   }
1130 
1131   /**
1132    * Investment receiver
1133    * @param _beneficiary Address performing the token purchase
1134    */
1135   function buyTokens(address _beneficiary) public payable {
1136     uint256 weiAmount = msg.value;
1137 
1138     _preValidatePurchase(_beneficiary, weiAmount);
1139 
1140     // calculate token amount to be created without bonuses
1141     uint256 tokens = _getTokenAmount(weiAmount);
1142 
1143     // update state
1144     weiRaised = weiRaised.add(weiAmount);
1145 
1146     // update 
1147     contributors[_beneficiary] += weiAmount;
1148 
1149     if(!isInvestor[_beneficiary]){
1150       investors.push(_beneficiary);
1151       isInvestor[_beneficiary] = true;
1152     }
1153     
1154     _forwardFunds();
1155 
1156     emit TokenPurchase(
1157       msg.sender,
1158       _beneficiary,
1159       weiAmount,
1160       tokens
1161     );
1162   }
1163 
1164 
1165   // -----------------------------------------
1166   // Internal interface (extensible)
1167   // -----------------------------------------
1168   /**
1169    * Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
1170    * @param _beneficiary Address performing the token purchase
1171    * @param _weiAmount Value in wei involved in the purchase
1172    */
1173   function _preValidatePurchase
1174   (
1175     address _beneficiary,
1176     uint256 _weiAmount
1177   )
1178     onlyIfWhitelisted(_beneficiary)
1179     respectContribution
1180     onlyWhileOpen
1181     view
1182     internal
1183   {
1184     require(weiRaised.add(_weiAmount) <= hardCap);
1185     require(_beneficiary != address(0));
1186   }
1187 
1188   /**
1189    * Create vesting contract
1190    * @param _beneficiary address of person who will get all tokens as vesting ends
1191    * @param _tokens amount of vested tokens
1192    */
1193   function createTimeBasedVesting
1194   (
1195     address _beneficiary,
1196     uint256 _tokens
1197   )
1198     internal
1199   {
1200     uint256 _start = block.timestamp;
1201 
1202     TokenVesting tokenVesting;
1203 
1204     if (vesting[_beneficiary] == address(0)) {
1205       tokenVesting = new TokenVesting(_beneficiary, _start, false);
1206       vesting[_beneficiary] = tokenVesting;
1207     } else {
1208       tokenVesting = vesting[_beneficiary];
1209     }
1210 
1211     token.transfer(address(tokenVesting), _tokens);
1212 
1213     emit TimeVestingCreation(_beneficiary, _start, duration, false);
1214   }
1215 
1216 
1217   /**
1218    *  checks if sale is closed
1219    */
1220   function hasClosed() public view returns (bool) {
1221     return isFinalized;
1222   }
1223 
1224   /** 
1225    * Release tokens from vesting contract
1226    */
1227   function releaseVestedTokens() public {
1228     address beneficiary = msg.sender;
1229     require(vesting[beneficiary] != address(0));
1230 
1231     TokenVesting tokenVesting = vesting[beneficiary];
1232     tokenVesting.release(token);
1233   }
1234 
1235   /**
1236    * Override to extend the way in which ether is converted to tokens.
1237    * @param _weiAmount Value in wei to be converted into tokens
1238    * @return Number of tokens that can be purchased with the specified _weiAmount
1239    */
1240   function _getBonusTokens
1241   (
1242     uint256 _weiAmount
1243   )
1244     internal
1245     view
1246     returns (uint256 purchasedAmount)
1247   {
1248     purchasedAmount = _weiAmount;
1249 
1250     if (_weiAmount >= SMALLEST_SUM && _weiAmount < SMALLER_SUM) {
1251       purchasedAmount = _weiAmount.perc(5);
1252     }
1253 
1254     if (_weiAmount >= SMALLER_SUM && _weiAmount < MEDIUM_SUM) {
1255       purchasedAmount = _weiAmount.perc(10);
1256     }
1257 
1258     if (_weiAmount >= MEDIUM_SUM && _weiAmount < BIGGER_SUM) {
1259       purchasedAmount = _weiAmount.perc(15);
1260     }
1261 
1262     if (_weiAmount >= BIGGER_SUM && _weiAmount < BIGGEST_SUM) {
1263       purchasedAmount = _weiAmount.perc(20);
1264     }
1265 
1266     if (_weiAmount >= BIGGEST_SUM) {
1267       purchasedAmount = _weiAmount.perc(30);
1268     }
1269 
1270     return purchasedAmount.mul(rate);
1271   }
1272 
1273   function _getTokenAmount
1274   (
1275     uint256 _weiAmount
1276   )
1277     internal
1278     view
1279     returns (uint256 purchasedAmount)
1280   {
1281     return _weiAmount.mul(rate);
1282   }
1283 
1284   /**
1285    * Determines how ETH is stored/forwarded on purchases.
1286    */
1287   function _forwardFunds() internal {
1288     wallet.transfer(msg.value);
1289   }
1290 
1291 
1292   /**
1293    * Must be called after sale ends, to do some extra finalization
1294    * work. Calls the contract's finalization function.
1295    */
1296   function finalize() public onlyOwner {
1297     require(!hasClosed());
1298     finalization();
1299     isFinalized = true;
1300     emit Finalized();
1301   } 
1302 
1303 
1304   /**
1305    * Can be overridden to add finalization logic. The overriding function
1306    * should call super.finalization() to ensure the chain of finalization is
1307    * executed entirely.
1308    */
1309   function finalization() pure internal {}
1310 
1311 }