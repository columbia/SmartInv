1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * See https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
23     // benefit is lost if 'b' is also tested.
24     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
25     if (a == 0) {
26       return 0;
27     }
28 
29     c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return a / b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev Total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev Transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105 }
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender)
112     public view returns (uint256);
113 
114   function transferFrom(address from, address to, uint256 value)
115     public returns (bool);
116 
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(
119     address indexed owner,
120     address indexed spender,
121     uint256 value
122   );
123 }
124 
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * https://github.com/ethereum/EIPs/issues/20
131  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(
145     address _from,
146     address _to,
147     uint256 _value
148   )
149     public
150     returns (bool)
151   {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(
185     address _owner,
186     address _spender
187    )
188     public
189     view
190     returns (uint256)
191   {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseApproval(
205     address _spender,
206     uint256 _addedValue
207   )
208     public
209     returns (bool)
210   {
211     allowed[msg.sender][_spender] = (
212       allowed[msg.sender][_spender].add(_addedValue));
213     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(
227     address _spender,
228     uint256 _subtractedValue
229   )
230     public
231     returns (bool)
232   {
233     uint256 oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 /**
245  * @title Ownable
246  * @dev The Ownable contract has an owner address, and provides basic authorization control
247  * functions, this simplifies the implementation of "user permissions".
248  */
249 contract Ownable {
250   address public owner;
251 
252 
253   event OwnershipRenounced(address indexed previousOwner);
254   event OwnershipTransferred(
255     address indexed previousOwner,
256     address indexed newOwner
257   );
258 
259 
260   /**
261    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
262    * account.
263    */
264   constructor() public {
265     owner = msg.sender;
266   }
267 
268   /**
269    * @dev Throws if called by any account other than the owner.
270    */
271   modifier onlyOwner() {
272     require(msg.sender == owner);
273     _;
274   }
275 
276   /**
277    * @dev Allows the current owner to relinquish control of the contract.
278    * @notice Renouncing to ownership will leave the contract without an owner.
279    * It will not be possible to call the functions with the `onlyOwner`
280    * modifier anymore.
281    */
282   function renounceOwnership() public onlyOwner {
283     emit OwnershipRenounced(owner);
284     owner = address(0);
285   }
286 
287   /**
288    * @dev Allows the current owner to transfer control of the contract to a newOwner.
289    * @param _newOwner The address to transfer ownership to.
290    */
291   function transferOwnership(address _newOwner) public onlyOwner {
292     _transferOwnership(_newOwner);
293   }
294 
295   /**
296    * @dev Transfers control of the contract to a newOwner.
297    * @param _newOwner The address to transfer ownership to.
298    */
299   function _transferOwnership(address _newOwner) internal {
300     require(_newOwner != address(0));
301     emit OwnershipTransferred(owner, _newOwner);
302     owner = _newOwner;
303   }
304 }
305 
306 
307 /**
308  * @title Pausable
309  * @dev Base contract which allows children to implement an emergency stop mechanism.
310  */
311 contract Pausable is Ownable {
312   event Pause();
313   event Unpause();
314 
315   bool public paused = false;
316 
317 
318   /**
319    * @dev Modifier to make a function callable only when the contract is not paused.
320    */
321   modifier whenNotPaused() {
322     require(!paused);
323     _;
324   }
325 
326   /**
327    * @dev Modifier to make a function callable only when the contract is paused.
328    */
329   modifier whenPaused() {
330     require(paused);
331     _;
332   }
333 
334   /**
335    * @dev called by the owner to pause, triggers stopped state
336    */
337   function pause() onlyOwner whenNotPaused public {
338     paused = true;
339     emit Pause();
340   }
341 
342   /**
343    * @dev called by the owner to unpause, returns to normal state
344    */
345   function unpause() onlyOwner whenPaused public {
346     paused = false;
347     emit Unpause();
348   }
349 }
350 
351 
352 /**
353  * @title Pausable token
354  * @dev StandardToken modified with pausable transfers.
355  **/
356 contract PausableToken is StandardToken, Pausable {
357 
358   function transfer(
359     address _to,
360     uint256 _value
361   )
362     public
363     whenNotPaused
364     returns (bool)
365   {
366     return super.transfer(_to, _value);
367   }
368 
369   function transferFrom(
370     address _from,
371     address _to,
372     uint256 _value
373   )
374     public
375     whenNotPaused
376     returns (bool)
377   {
378     return super.transferFrom(_from, _to, _value);
379   }
380 
381   function approve(
382     address _spender,
383     uint256 _value
384   )
385     public
386     whenNotPaused
387     returns (bool)
388   {
389     return super.approve(_spender, _value);
390   }
391 
392   function increaseApproval(
393     address _spender,
394     uint _addedValue
395   )
396     public
397     whenNotPaused
398     returns (bool success)
399   {
400     return super.increaseApproval(_spender, _addedValue);
401   }
402 
403   function decreaseApproval(
404     address _spender,
405     uint _subtractedValue
406   )
407     public
408     whenNotPaused
409     returns (bool success)
410   {
411     return super.decreaseApproval(_spender, _subtractedValue);
412   }
413 }
414 /**
415  * @title Mintable token
416  * @dev Simple ERC20 Token example, with mintable token creation
417  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
418  */
419 contract MintableToken is StandardToken, Ownable {
420   event Mint(address indexed to, uint256 amount);
421   event MintFinished();
422 
423   bool public mintingFinished = false;
424 
425 
426   modifier canMint() {
427     require(!mintingFinished);
428     _;
429   }
430 
431   modifier hasMintPermission() {
432     require(msg.sender == owner);
433     _;
434   }
435 
436   /**
437    * @dev Function to mint tokens
438    * @param _to The address that will receive the minted tokens.
439    * @param _amount The amount of tokens to mint.
440    * @return A boolean that indicates if the operation was successful.
441    */
442   function mint(
443     address _to,
444     uint256 _amount
445   )
446     hasMintPermission
447     canMint
448     public
449     returns (bool)
450   {
451     totalSupply_ = totalSupply_.add(_amount);
452     balances[_to] = balances[_to].add(_amount);
453     emit Mint(_to, _amount);
454     emit Transfer(address(0), _to, _amount);
455     return true;
456   }
457 
458   /**
459    * @dev Function to stop minting new tokens.
460    * @return True if the operation was successful.
461    */
462   function finishMinting() onlyOwner canMint public returns (bool) {
463     mintingFinished = true;
464     emit MintFinished();
465     return true;
466   }
467 }
468 
469 
470 /**
471  * @title Capped token
472  * @dev Mintable token with a token cap.
473  */
474 contract CappedToken is MintableToken {
475 
476   uint256 public cap;
477 
478   constructor(uint256 _cap) public {
479     require(_cap > 0);
480     cap = _cap;
481   }
482 
483   /**
484    * @dev Function to mint tokens
485    * @param _to The address that will receive the minted tokens.
486    * @param _amount The amount of tokens to mint.
487    * @return A boolean that indicates if the operation was successful.
488    */
489   function mint(
490     address _to,
491     uint256 _amount
492   )
493     public
494     returns (bool)
495   {
496     require(totalSupply_.add(_amount) <= cap);
497 
498     return super.mint(_to, _amount);
499   }
500 
501 }
502 /**
503  * @title Roles
504  * @author Francisco Giordano (@frangio)
505  * @dev Library for managing addresses assigned to a Role.
506  * See RBAC.sol for example usage.
507  */
508 library Roles {
509   struct Role {
510     mapping (address => bool) bearer;
511   }
512 
513   /**
514    * @dev give an address access to this role
515    */
516   function add(Role storage role, address addr)
517     internal
518   {
519     role.bearer[addr] = true;
520   }
521 
522   /**
523    * @dev remove an address' access to this role
524    */
525   function remove(Role storage role, address addr)
526     internal
527   {
528     role.bearer[addr] = false;
529   }
530 
531   /**
532    * @dev check if an address has this role
533    * // reverts
534    */
535   function check(Role storage role, address addr)
536     view
537     internal
538   {
539     require(has(role, addr));
540   }
541 
542   /**
543    * @dev check if an address has this role
544    * @return bool
545    */
546   function has(Role storage role, address addr)
547     view
548     internal
549     returns (bool)
550   {
551     return role.bearer[addr];
552   }
553 }
554 
555 
556 /**
557  * @title RBAC (Role-Based Access Control)
558  * @author Matt Condon (@Shrugs)
559  * @dev Stores and provides setters and getters for roles and addresses.
560  * Supports unlimited numbers of roles and addresses.
561  * See //contracts/mocks/RBACMock.sol for an example of usage.
562  * This RBAC method uses strings to key roles. It may be beneficial
563  * for you to write your own implementation of this interface using Enums or similar.
564  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
565  * to avoid typos.
566  */
567 contract RBAC {
568   using Roles for Roles.Role;
569 
570   mapping (string => Roles.Role) private roles;
571 
572   event RoleAdded(address indexed operator, string role);
573   event RoleRemoved(address indexed operator, string role);
574 
575   /**
576    * @dev reverts if addr does not have role
577    * @param _operator address
578    * @param _role the name of the role
579    * // reverts
580    */
581   function checkRole(address _operator, string _role)
582     view
583     public
584   {
585     roles[_role].check(_operator);
586   }
587 
588   /**
589    * @dev determine if addr has role
590    * @param _operator address
591    * @param _role the name of the role
592    * @return bool
593    */
594   function hasRole(address _operator, string _role)
595     view
596     public
597     returns (bool)
598   {
599     return roles[_role].has(_operator);
600   }
601 
602   /**
603    * @dev add a role to an address
604    * @param _operator address
605    * @param _role the name of the role
606    */
607   function addRole(address _operator, string _role)
608     internal
609   {
610     roles[_role].add(_operator);
611     emit RoleAdded(_operator, _role);
612   }
613 
614   /**
615    * @dev remove a role from an address
616    * @param _operator address
617    * @param _role the name of the role
618    */
619   function removeRole(address _operator, string _role)
620     internal
621   {
622     roles[_role].remove(_operator);
623     emit RoleRemoved(_operator, _role);
624   }
625 
626   /**
627    * @dev modifier to scope access to a single role (uses msg.sender as addr)
628    * @param _role the name of the role
629    * // reverts
630    */
631   modifier onlyRole(string _role)
632   {
633     checkRole(msg.sender, _role);
634     _;
635   }
636 
637   /**
638    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
639    * @param _roles the names of the roles to scope access to
640    * // reverts
641    *
642    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
643    *  see: https://github.com/ethereum/solidity/issues/2467
644    */
645   // modifier onlyRoles(string[] _roles) {
646   //     bool hasAnyRole = false;
647   //     for (uint8 i = 0; i < _roles.length; i++) {
648   //         if (hasRole(msg.sender, _roles[i])) {
649   //             hasAnyRole = true;
650   //             break;
651   //         }
652   //     }
653 
654   //     require(hasAnyRole);
655 
656   //     _;
657   // }
658 }
659 
660 
661 /**
662  * @title Superuser
663  * @dev The Superuser contract defines a single superuser who can transfer the ownership 
664  * of a contract to a new address, even if he is not the owner. 
665  * A superuser can transfer his role to a new address. 
666  */
667 contract Superuser is Ownable, RBAC {
668   string public constant ROLE_SUPERUSER = "superuser";
669 
670   constructor () public {
671     addRole(msg.sender, ROLE_SUPERUSER);
672   }
673 
674   /**
675    * @dev Throws if called by any account that's not a superuser.
676    */
677   modifier onlySuperuser() {
678     checkRole(msg.sender, ROLE_SUPERUSER);
679     _;
680   }
681 
682   modifier onlyOwnerOrSuperuser() {
683     require(msg.sender == owner || isSuperuser(msg.sender));
684     _;
685   }
686 
687   /**
688    * @dev getter to determine if address has superuser role
689    */
690   function isSuperuser(address _addr)
691     public
692     view
693     returns (bool)
694   {
695     return hasRole(_addr, ROLE_SUPERUSER);
696   }
697 
698   /**
699    * @dev Allows the current superuser to transfer his role to a newSuperuser.
700    * @param _newSuperuser The address to transfer ownership to.
701    */
702   function transferSuperuser(address _newSuperuser) public onlySuperuser {
703     require(_newSuperuser != address(0));
704     removeRole(msg.sender, ROLE_SUPERUSER);
705     addRole(_newSuperuser, ROLE_SUPERUSER);
706   }
707 
708   /**
709    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
710    * @param _newOwner The address to transfer ownership to.
711    */
712   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
713     _transferOwnership(_newOwner);
714   }
715 }
716 
717 
718 contract CoinSmartt is Superuser, PausableToken, CappedToken {
719 
720 	string public name = "CoinSmartt";
721 	string public symbol = "TURN";
722 	uint256 public decimals = 18;
723 
724 	string public constant ROLE_MINTER = "minter";
725 
726 	constructor(address _minter) CappedToken(4907460316 ether) {
727 		//constructor
728 		addRole(_minter, ROLE_MINTER);
729 	}
730 
731 	function mint(
732 		address _to,
733 		uint256 _amount
734 		)
735 		onlyRole("minter")
736 		canMint
737 		public
738 		returns (bool)
739 	{
740 		require(totalSupply_.add(_amount) <= cap);
741 		totalSupply_ = totalSupply_.add(_amount);
742 		balances[_to] = balances[_to].add(_amount);
743 		emit Mint(_to, _amount);
744 		emit Transfer(address(0), _to, _amount);
745 		return true;
746 	}
747 	function removeMinter(address _minter) onlyOwnerOrSuperuser {
748 		removeRole(_minter, "minter");
749 	}
750 	function addMinter(address _minter) onlyOwnerOrSuperuser {
751 		addRole(_minter, "minter");
752 	}
753 
754 }