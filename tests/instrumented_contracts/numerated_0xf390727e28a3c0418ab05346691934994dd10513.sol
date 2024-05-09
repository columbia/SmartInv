1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev Total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev Transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
107 
108 }
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * https://github.com/ethereum/EIPs/issues/20
134  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) internal allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(
148     address _from,
149     address _to,
150     uint256 _value
151   )
152     public
153     returns (bool)
154   {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _addedValue The amount of tokens to increase the allowance by.
206    */
207   function increaseApproval(
208     address _spender,
209     uint256 _addedValue
210   )
211     public
212     returns (bool)
213   {
214     allowed[msg.sender][_spender] = (
215       allowed[msg.sender][_spender].add(_addedValue));
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(
230     address _spender,
231     uint256 _subtractedValue
232   )
233     public
234     returns (bool)
235   {
236     uint256 oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue > oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to relinquish control of the contract.
281    * @notice Renouncing to ownership will leave the contract without an owner.
282    * It will not be possible to call the functions with the `onlyOwner`
283    * modifier anymore.
284    */
285   function renounceOwnership() public onlyOwner {
286     emit OwnershipRenounced(owner);
287     owner = address(0);
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param _newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address _newOwner) public onlyOwner {
295     _transferOwnership(_newOwner);
296   }
297 
298   /**
299    * @dev Transfers control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function _transferOwnership(address _newOwner) internal {
303     require(_newOwner != address(0));
304     emit OwnershipTransferred(owner, _newOwner);
305     owner = _newOwner;
306   }
307 }
308 
309 
310 /**
311  * @title Pausable
312  * @dev Base contract which allows children to implement an emergency stop mechanism.
313  */
314 contract Pausable is Ownable {
315   event Pause();
316   event Unpause();
317 
318   bool public paused = false;
319 
320 
321   /**
322    * @dev Modifier to make a function callable only when the contract is not paused.
323    */
324   modifier whenNotPaused() {
325     require(!paused);
326     _;
327   }
328 
329   /**
330    * @dev Modifier to make a function callable only when the contract is paused.
331    */
332   modifier whenPaused() {
333     require(paused);
334     _;
335   }
336 
337   /**
338    * @dev called by the owner to pause, triggers stopped state
339    */
340   function pause() onlyOwner whenNotPaused public {
341     paused = true;
342     emit Pause();
343   }
344 
345   /**
346    * @dev called by the owner to unpause, returns to normal state
347    */
348   function unpause() onlyOwner whenPaused public {
349     paused = false;
350     emit Unpause();
351   }
352 }
353 
354 
355 /**
356  * @title Pausable token
357  * @dev StandardToken modified with pausable transfers.
358  **/
359 contract PausableToken is StandardToken, Pausable {
360 
361   function transfer(
362     address _to,
363     uint256 _value
364   )
365     public
366     whenNotPaused
367     returns (bool)
368   {
369     return super.transfer(_to, _value);
370   }
371 
372   function transferFrom(
373     address _from,
374     address _to,
375     uint256 _value
376   )
377     public
378     whenNotPaused
379     returns (bool)
380   {
381     return super.transferFrom(_from, _to, _value);
382   }
383 
384   function approve(
385     address _spender,
386     uint256 _value
387   )
388     public
389     whenNotPaused
390     returns (bool)
391   {
392     return super.approve(_spender, _value);
393   }
394 
395   function increaseApproval(
396     address _spender,
397     uint _addedValue
398   )
399     public
400     whenNotPaused
401     returns (bool success)
402   {
403     return super.increaseApproval(_spender, _addedValue);
404   }
405 
406   function decreaseApproval(
407     address _spender,
408     uint _subtractedValue
409   )
410     public
411     whenNotPaused
412     returns (bool success)
413   {
414     return super.decreaseApproval(_spender, _subtractedValue);
415   }
416 }
417 /**
418  * @title Mintable token
419  * @dev Simple ERC20 Token example, with mintable token creation
420  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
421  */
422 contract MintableToken is StandardToken, Ownable {
423   event Mint(address indexed to, uint256 amount);
424   event MintFinished();
425 
426   bool public mintingFinished = false;
427 
428 
429   modifier canMint() {
430     require(!mintingFinished);
431     _;
432   }
433 
434   modifier hasMintPermission() {
435     require(msg.sender == owner);
436     _;
437   }
438 
439   /**
440    * @dev Function to mint tokens
441    * @param _to The address that will receive the minted tokens.
442    * @param _amount The amount of tokens to mint.
443    * @return A boolean that indicates if the operation was successful.
444    */
445   function mint(
446     address _to,
447     uint256 _amount
448   )
449     hasMintPermission
450     canMint
451     public
452     returns (bool)
453   {
454     totalSupply_ = totalSupply_.add(_amount);
455     balances[_to] = balances[_to].add(_amount);
456     emit Mint(_to, _amount);
457     emit Transfer(address(0), _to, _amount);
458     return true;
459   }
460 
461   /**
462    * @dev Function to stop minting new tokens.
463    * @return True if the operation was successful.
464    */
465   function finishMinting() onlyOwner canMint public returns (bool) {
466     mintingFinished = true;
467     emit MintFinished();
468     return true;
469   }
470 }
471 
472 
473 /**
474  * @title Capped token
475  * @dev Mintable token with a token cap.
476  */
477 contract CappedToken is MintableToken {
478 
479   uint256 public cap;
480 
481   constructor(uint256 _cap) public {
482     require(_cap > 0);
483     cap = _cap;
484   }
485 
486   /**
487    * @dev Function to mint tokens
488    * @param _to The address that will receive the minted tokens.
489    * @param _amount The amount of tokens to mint.
490    * @return A boolean that indicates if the operation was successful.
491    */
492   function mint(
493     address _to,
494     uint256 _amount
495   )
496     public
497     returns (bool)
498   {
499     require(totalSupply_.add(_amount) <= cap);
500 
501     return super.mint(_to, _amount);
502   }
503 
504 }
505 /**
506  * @title Roles
507  * @author Francisco Giordano (@frangio)
508  * @dev Library for managing addresses assigned to a Role.
509  * See RBAC.sol for example usage.
510  */
511 library Roles {
512   struct Role {
513     mapping (address => bool) bearer;
514   }
515 
516   /**
517    * @dev give an address access to this role
518    */
519   function add(Role storage role, address addr)
520     internal
521   {
522     role.bearer[addr] = true;
523   }
524 
525   /**
526    * @dev remove an address' access to this role
527    */
528   function remove(Role storage role, address addr)
529     internal
530   {
531     role.bearer[addr] = false;
532   }
533 
534   /**
535    * @dev check if an address has this role
536    * // reverts
537    */
538   function check(Role storage role, address addr)
539     view
540     internal
541   {
542     require(has(role, addr));
543   }
544 
545   /**
546    * @dev check if an address has this role
547    * @return bool
548    */
549   function has(Role storage role, address addr)
550     view
551     internal
552     returns (bool)
553   {
554     return role.bearer[addr];
555   }
556 }
557 
558 
559 /**
560  * @title RBAC (Role-Based Access Control)
561  * @author Matt Condon (@Shrugs)
562  * @dev Stores and provides setters and getters for roles and addresses.
563  * Supports unlimited numbers of roles and addresses.
564  * See //contracts/mocks/RBACMock.sol for an example of usage.
565  * This RBAC method uses strings to key roles. It may be beneficial
566  * for you to write your own implementation of this interface using Enums or similar.
567  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
568  * to avoid typos.
569  */
570 contract RBAC {
571   using Roles for Roles.Role;
572 
573   mapping (string => Roles.Role) private roles;
574 
575   event RoleAdded(address indexed operator, string role);
576   event RoleRemoved(address indexed operator, string role);
577 
578   /**
579    * @dev reverts if addr does not have role
580    * @param _operator address
581    * @param _role the name of the role
582    * // reverts
583    */
584   function checkRole(address _operator, string _role)
585     view
586     public
587   {
588     roles[_role].check(_operator);
589   }
590 
591   /**
592    * @dev determine if addr has role
593    * @param _operator address
594    * @param _role the name of the role
595    * @return bool
596    */
597   function hasRole(address _operator, string _role)
598     view
599     public
600     returns (bool)
601   {
602     return roles[_role].has(_operator);
603   }
604 
605   /**
606    * @dev add a role to an address
607    * @param _operator address
608    * @param _role the name of the role
609    */
610   function addRole(address _operator, string _role)
611     internal
612   {
613     roles[_role].add(_operator);
614     emit RoleAdded(_operator, _role);
615   }
616 
617   /**
618    * @dev remove a role from an address
619    * @param _operator address
620    * @param _role the name of the role
621    */
622   function removeRole(address _operator, string _role)
623     internal
624   {
625     roles[_role].remove(_operator);
626     emit RoleRemoved(_operator, _role);
627   }
628 
629   /**
630    * @dev modifier to scope access to a single role (uses msg.sender as addr)
631    * @param _role the name of the role
632    * // reverts
633    */
634   modifier onlyRole(string _role)
635   {
636     checkRole(msg.sender, _role);
637     _;
638   }
639 
640   /**
641    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
642    * @param _roles the names of the roles to scope access to
643    * // reverts
644    *
645    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
646    *  see: https://github.com/ethereum/solidity/issues/2467
647    */
648   // modifier onlyRoles(string[] _roles) {
649   //     bool hasAnyRole = false;
650   //     for (uint8 i = 0; i < _roles.length; i++) {
651   //         if (hasRole(msg.sender, _roles[i])) {
652   //             hasAnyRole = true;
653   //             break;
654   //         }
655   //     }
656 
657   //     require(hasAnyRole);
658 
659   //     _;
660   // }
661 }
662 
663 
664 /**
665  * @title Superuser
666  * @dev The Superuser contract defines a single superuser who can transfer the ownership 
667  * of a contract to a new address, even if he is not the owner. 
668  * A superuser can transfer his role to a new address. 
669  */
670 contract Superuser is Ownable, RBAC {
671   string public constant ROLE_SUPERUSER = "superuser";
672 
673   constructor () public {
674     addRole(msg.sender, ROLE_SUPERUSER);
675   }
676 
677   /**
678    * @dev Throws if called by any account that's not a superuser.
679    */
680   modifier onlySuperuser() {
681     checkRole(msg.sender, ROLE_SUPERUSER);
682     _;
683   }
684 
685   modifier onlyOwnerOrSuperuser() {
686     require(msg.sender == owner || isSuperuser(msg.sender));
687     _;
688   }
689 
690   /**
691    * @dev getter to determine if address has superuser role
692    */
693   function isSuperuser(address _addr)
694     public
695     view
696     returns (bool)
697   {
698     return hasRole(_addr, ROLE_SUPERUSER);
699   }
700 
701   /**
702    * @dev Allows the current superuser to transfer his role to a newSuperuser.
703    * @param _newSuperuser The address to transfer ownership to.
704    */
705   function transferSuperuser(address _newSuperuser) public onlySuperuser {
706     require(_newSuperuser != address(0));
707     removeRole(msg.sender, ROLE_SUPERUSER);
708     addRole(_newSuperuser, ROLE_SUPERUSER);
709   }
710 
711   /**
712    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
713    * @param _newOwner The address to transfer ownership to.
714    */
715   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
716     _transferOwnership(_newOwner);
717   }
718 }
719 
720 
721 contract CoinSmartt is Superuser, PausableToken, CappedToken {
722 
723 	string public name = "CoinSmartt";
724 	string public symbol = "TURN";
725 	uint256 public decimals = 18;
726 
727 	string public constant ROLE_MINTER = "minter";
728 
729 	constructor(address _minter) CappedToken(7663809523810000000000000000) {
730 		//constructor
731 		addRole(_minter, ROLE_MINTER);
732 	}
733 
734 	function mint(
735 		address _to,
736 		uint256 _amount
737 		)
738 		onlyRole("minter")
739 		canMint
740 		public
741 		returns (bool)
742 	{
743 		require(totalSupply_.add(_amount) <= cap);
744 		totalSupply_ = totalSupply_.add(_amount);
745 		balances[_to] = balances[_to].add(_amount);
746 		emit Mint(_to, _amount);
747 		emit Transfer(address(0), _to, _amount);
748 		return true;
749 	}
750 	function removeMinter(address _minter) onlyOwnerOrSuperuser {
751 		removeRole(_minter, "minter");
752 	}
753 	function addMinter(address _minter) onlyOwnerOrSuperuser {
754 		addRole(_minter, "minter");
755 	}
756 
757 }