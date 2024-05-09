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
123  * @title Basic token
124  * @dev Basic version of StandardToken, with no allowances.
125  */
126 contract BasicToken is ERC20Basic {
127   using SafeMath for uint256;
128 
129   mapping(address => uint256) internal balances;
130 
131   uint256 internal totalSupply_;
132 
133   /**
134   * @dev Total number of tokens in existence
135   */
136   function totalSupply() public view returns (uint256) {
137     return totalSupply_;
138   }
139 
140   /**
141   * @dev Transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     require(_value <= balances[msg.sender]);
147     require(_to != address(0));
148 
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     emit Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * https://github.com/ethereum/EIPs/issues/20
171  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(
185     address _from,
186     address _to,
187     uint256 _value
188   )
189     public
190     returns (bool)
191   {
192     require(_value <= balances[_from]);
193     require(_value <= allowed[_from][msg.sender]);
194     require(_to != address(0));
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199     emit Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    * Beware that changing an allowance with this method brings the risk that someone may use both the old
206    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209    * @param _spender The address which will spend the funds.
210    * @param _value The amount of tokens to be spent.
211    */
212   function approve(address _spender, uint256 _value) public returns (bool) {
213     allowed[msg.sender][_spender] = _value;
214     emit Approval(msg.sender, _spender, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifying the amount of tokens still available for the spender.
223    */
224   function allowance(
225     address _owner,
226     address _spender
227    )
228     public
229     view
230     returns (uint256)
231   {
232     return allowed[_owner][_spender];
233   }
234 
235   /**
236    * @dev Increase the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _addedValue The amount of tokens to increase the allowance by.
243    */
244   function increaseApproval(
245     address _spender,
246     uint256 _addedValue
247   )
248     public
249     returns (bool)
250   {
251     allowed[msg.sender][_spender] = (
252       allowed[msg.sender][_spender].add(_addedValue));
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Decrease the amount of tokens that an owner allowed to a spender.
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(
267     address _spender,
268     uint256 _subtractedValue
269   )
270     public
271     returns (bool)
272   {
273     uint256 oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue >= oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 /**
286  * @title Ownable
287  * @dev The Ownable contract has an owner address, and provides basic authorization control
288  * functions, this simplifies the implementation of "user permissions".
289  */
290 contract Ownable {
291   address public owner;
292 
293 
294   event OwnershipRenounced(address indexed previousOwner);
295   event OwnershipTransferred(
296     address indexed previousOwner,
297     address indexed newOwner
298   );
299 
300 
301   /**
302    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
303    * account.
304    */
305   constructor() public {
306     owner = msg.sender;
307   }
308 
309   /**
310    * @dev Throws if called by any account other than the owner.
311    */
312   modifier onlyOwner() {
313     require(msg.sender == owner);
314     _;
315   }
316 
317   /**
318    * @dev Allows the current owner to relinquish control of the contract.
319    * @notice Renouncing to ownership will leave the contract without an owner.
320    * It will not be possible to call the functions with the `onlyOwner`
321    * modifier anymore.
322    */
323   function renounceOwnership() public onlyOwner {
324     emit OwnershipRenounced(owner);
325     owner = address(0);
326   }
327 
328   /**
329    * @dev Allows the current owner to transfer control of the contract to a newOwner.
330    * @param _newOwner The address to transfer ownership to.
331    */
332   function transferOwnership(address _newOwner) public onlyOwner {
333     _transferOwnership(_newOwner);
334   }
335 
336   /**
337    * @dev Transfers control of the contract to a newOwner.
338    * @param _newOwner The address to transfer ownership to.
339    */
340   function _transferOwnership(address _newOwner) internal {
341     require(_newOwner != address(0));
342     emit OwnershipTransferred(owner, _newOwner);
343     owner = _newOwner;
344   }
345 }
346 
347 /**
348  * @title Roles
349  * @author Francisco Giordano (@frangio)
350  * @dev Library for managing addresses assigned to a Role.
351  * See RBAC.sol for example usage.
352  */
353 library Roles {
354   struct Role {
355     mapping (address => bool) bearer;
356   }
357 
358   /**
359    * @dev give an address access to this role
360    */
361   function add(Role storage _role, address _addr)
362     internal
363   {
364     _role.bearer[_addr] = true;
365   }
366 
367   /**
368    * @dev remove an address' access to this role
369    */
370   function remove(Role storage _role, address _addr)
371     internal
372   {
373     _role.bearer[_addr] = false;
374   }
375 
376   /**
377    * @dev check if an address has this role
378    * // reverts
379    */
380   function check(Role storage _role, address _addr)
381     internal
382     view
383   {
384     require(has(_role, _addr));
385   }
386 
387   /**
388    * @dev check if an address has this role
389    * @return bool
390    */
391   function has(Role storage _role, address _addr)
392     internal
393     view
394     returns (bool)
395   {
396     return _role.bearer[_addr];
397   }
398 }
399 
400 /**
401  * @title RBAC (Role-Based Access Control)
402  * @author Matt Condon (@Shrugs)
403  * @dev Stores and provides setters and getters for roles and addresses.
404  * Supports unlimited numbers of roles and addresses.
405  * See //contracts/mocks/RBACMock.sol for an example of usage.
406  * This RBAC method uses strings to key roles. It may be beneficial
407  * for you to write your own implementation of this interface using Enums or similar.
408  */
409 contract RBAC {
410   using Roles for Roles.Role;
411 
412   mapping (string => Roles.Role) private roles;
413 
414   event RoleAdded(address indexed operator, string role);
415   event RoleRemoved(address indexed operator, string role);
416 
417   /**
418    * @dev reverts if addr does not have role
419    * @param _operator address
420    * @param _role the name of the role
421    * // reverts
422    */
423   function checkRole(address _operator, string _role)
424     public
425     view
426   {
427     roles[_role].check(_operator);
428   }
429 
430   /**
431    * @dev determine if addr has role
432    * @param _operator address
433    * @param _role the name of the role
434    * @return bool
435    */
436   function hasRole(address _operator, string _role)
437     public
438     view
439     returns (bool)
440   {
441     return roles[_role].has(_operator);
442   }
443 
444   /**
445    * @dev add a role to an address
446    * @param _operator address
447    * @param _role the name of the role
448    */
449   function addRole(address _operator, string _role)
450     internal
451   {
452     roles[_role].add(_operator);
453     emit RoleAdded(_operator, _role);
454   }
455 
456   /**
457    * @dev remove a role from an address
458    * @param _operator address
459    * @param _role the name of the role
460    */
461   function removeRole(address _operator, string _role)
462     internal
463   {
464     roles[_role].remove(_operator);
465     emit RoleRemoved(_operator, _role);
466   }
467 
468   /**
469    * @dev modifier to scope access to a single role (uses msg.sender as addr)
470    * @param _role the name of the role
471    * // reverts
472    */
473   modifier onlyRole(string _role)
474   {
475     checkRole(msg.sender, _role);
476     _;
477   }
478 
479   /**
480    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
481    * @param _roles the names of the roles to scope access to
482    * // reverts
483    *
484    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
485    *  see: https://github.com/ethereum/solidity/issues/2467
486    */
487   // modifier onlyRoles(string[] _roles) {
488   //     bool hasAnyRole = false;
489   //     for (uint8 i = 0; i < _roles.length; i++) {
490   //         if (hasRole(msg.sender, _roles[i])) {
491   //             hasAnyRole = true;
492   //             break;
493   //         }
494   //     }
495 
496   //     require(hasAnyRole);
497 
498   //     _;
499   // }
500 }
501 contract RBACOperator is Ownable, RBAC{
502 
503   /**
504    * A constant role name for indicating operator.
505    */
506   string public constant ROLE_OPERATOR = "operator";
507 
508   /**
509    * @dev the modifier to operate
510    */
511   modifier hasOperationPermission() {
512     checkRole(msg.sender, ROLE_OPERATOR);
513     _;
514   }
515 
516   /**
517    * @dev add a operator role to an address
518    * @param _operator address
519    */
520   function addOperater(address _operator) public onlyOwner {
521     addRole(_operator, ROLE_OPERATOR);
522   }
523 
524   /**
525    * @dev remove a operator role from an address
526    * @param _operator address
527    */
528   function removeOperater(address _operator) public onlyOwner {
529     removeRole(_operator, ROLE_OPERATOR);
530   }
531 }
532 
533 /**
534  * @title Pausable
535  * @dev Base contract which allows children to implement an emergency stop mechanism.
536  */
537 contract Pausable is Ownable {
538   event Pause();
539   event Unpause();
540 
541   bool public paused = false;
542 
543 
544   /**
545    * @dev Modifier to make a function callable only when the contract is not paused.
546    */
547   modifier whenNotPaused() {
548     require(!paused);
549     _;
550   }
551 
552   /**
553    * @dev Modifier to make a function callable only when the contract is paused.
554    */
555   modifier whenPaused() {
556     require(paused);
557     _;
558   }
559 
560   /**
561    * @dev called by the owner to pause, triggers stopped state
562    */
563   function pause() public onlyOwner whenNotPaused {
564     paused = true;
565     emit Pause();
566   }
567 
568   /**
569    * @dev called by the owner to unpause, returns to normal state
570    */
571   function unpause() public onlyOwner whenPaused {
572     paused = false;
573     emit Unpause();
574   }
575 }
576 
577 /**
578  * @title Mintable token
579  * @dev Simple ERC20 Token example, with mintable token creation
580  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
581  */
582 contract MintableToken is StandardToken, Ownable {
583   event Mint(address indexed to, uint256 amount);
584   event MintFinished();
585 
586   bool public mintingFinished = false;
587 
588 
589   modifier canMint() {
590     require(!mintingFinished);
591     _;
592   }
593 
594   modifier hasMintPermission() {
595     require(msg.sender == owner);
596     _;
597   }
598 
599   /**
600    * @dev Function to mint tokens
601    * @param _to The address that will receive the minted tokens.
602    * @param _amount The amount of tokens to mint.
603    * @return A boolean that indicates if the operation was successful.
604    */
605   function mint(
606     address _to,
607     uint256 _amount
608   )
609     public
610     hasMintPermission
611     canMint
612     returns (bool)
613   {
614     totalSupply_ = totalSupply_.add(_amount);
615     balances[_to] = balances[_to].add(_amount);
616     emit Mint(_to, _amount);
617     emit Transfer(address(0), _to, _amount);
618     return true;
619   }
620 
621   /**
622    * @dev Function to stop minting new tokens.
623    * @return True if the operation was successful.
624    */
625   function finishMinting() public onlyOwner canMint returns (bool) {
626     mintingFinished = true;
627     emit MintFinished();
628     return true;
629   }
630 }
631 
632 /**
633  * @title RBACMintableToken
634  * @author Vittorio Minacori (@vittominacori)
635  * @dev Mintable Token, with RBAC minter permissions
636  */
637 contract RBACMintableToken is MintableToken, RBAC {
638   /**
639    * A constant role name for indicating minters.
640    */
641   string public constant ROLE_MINTER = "minter";
642 
643   /**
644    * @dev override the Mintable token modifier to add role based logic
645    */
646   modifier hasMintPermission() {
647     checkRole(msg.sender, ROLE_MINTER);
648     _;
649   }
650 
651   /**
652    * @dev add a minter role to an address
653    * @param _minter address
654    */
655   function addMinter(address _minter) public onlyOwner {
656     addRole(_minter, ROLE_MINTER);
657   }
658 
659   /**
660    * @dev remove a minter role from an address
661    * @param _minter address
662    */
663   function removeMinter(address _minter) public onlyOwner {
664     removeRole(_minter, ROLE_MINTER);
665   }
666 }
667 
668 /**
669  * @title Pausable token
670  * @dev StandardToken modified with pausable transfers.
671  **/
672 contract PausableToken is StandardToken, Pausable {
673 
674   function transfer(
675     address _to,
676     uint256 _value
677   )
678     public
679     whenNotPaused
680     returns (bool)
681   {
682     return super.transfer(_to, _value);
683   }
684 
685   function transferFrom(
686     address _from,
687     address _to,
688     uint256 _value
689   )
690     public
691     whenNotPaused
692     returns (bool)
693   {
694     return super.transferFrom(_from, _to, _value);
695   }
696 
697   function approve(
698     address _spender,
699     uint256 _value
700   )
701     public
702     whenNotPaused
703     returns (bool)
704   {
705     return super.approve(_spender, _value);
706   }
707 
708   function increaseApproval(
709     address _spender,
710     uint _addedValue
711   )
712     public
713     whenNotPaused
714     returns (bool success)
715   {
716     return super.increaseApproval(_spender, _addedValue);
717   }
718 
719   function decreaseApproval(
720     address _spender,
721     uint _subtractedValue
722   )
723     public
724     whenNotPaused
725     returns (bool success)
726   {
727     return super.decreaseApproval(_spender, _subtractedValue);
728   }
729 }
730 
731 /**
732  * @dev cbnt token ERC20 contract
733  * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
734  */
735 contract Cbnt is RBACMintableToken, PausableToken {
736   string public constant version = "1.1";
737   string public constant name = "Create Breaking News Together";
738   string public constant symbol = "CBNT";
739   uint8 public constant decimals = 18;
740   uint256 public constant MAX_AMOUNT = 10000000000000000000000000000;
741 
742   event Burn(address indexed burner, uint256 value);
743   function mintToAddresses(address[] _addresses, uint256 _amount) public hasMintPermission canMint returns (bool){
744     for (uint i = 0; i < _addresses.length; i++) {
745       mint(_addresses[i],_amount);
746     }
747     return true;
748   }
749   function mintToAddressesAndAmounts(address[] _addresses, uint256[] _amounts) public hasMintPermission canMint returns (bool){
750     require(_addresses.length == _amounts.length);
751     for (uint i = 0; i < _addresses.length; i++) {
752       mint(_addresses[i],_amounts[i]);
753     }
754     return true;
755   }
756 
757   /**
758    * @dev Overrides parent method to mint tokens
759    * @param _to The address that will receive the minted tokens.
760    * @param _amount The amount of tokens to mint.
761    * @return A boolean that indicates if the operation was successful.
762    */
763   function mint(
764     address _to,
765     uint256 _amount
766   )
767     public
768     returns (bool)
769   {
770     require((_amount+totalSupply_) <= MAX_AMOUNT && _to != address(0));
771     return super.mint(_to,_amount);
772   }
773 
774   function burn(uint256 _value) public {
775     require(_value <= balances[msg.sender]);
776 
777     balances[msg.sender] = balances[msg.sender].sub(_value);
778     totalSupply_ = totalSupply_.sub(_value);
779     emit Burn(msg.sender, _value);
780     emit Transfer(msg.sender, address(0), _value);
781   }
782 
783 }