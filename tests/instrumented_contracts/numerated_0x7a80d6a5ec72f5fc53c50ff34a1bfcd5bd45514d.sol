1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
4 
5 /**
6  * @title Roles
7  * @author Francisco Giordano (@frangio)
8  * @dev Library for managing addresses assigned to a Role.
9  * See RBAC.sol for example usage.
10  */
11 library Roles {
12   struct Role {
13     mapping (address => bool) bearer;
14   }
15 
16   /**
17    * @dev give an address access to this role
18    */
19   function add(Role storage _role, address _addr)
20     internal
21   {
22     _role.bearer[_addr] = true;
23   }
24 
25   /**
26    * @dev remove an address' access to this role
27    */
28   function remove(Role storage _role, address _addr)
29     internal
30   {
31     _role.bearer[_addr] = false;
32   }
33 
34   /**
35    * @dev check if an address has this role
36    * // reverts
37    */
38   function check(Role storage _role, address _addr)
39     internal
40     view
41   {
42     require(has(_role, _addr));
43   }
44 
45   /**
46    * @dev check if an address has this role
47    * @return bool
48    */
49   function has(Role storage _role, address _addr)
50     internal
51     view
52     returns (bool)
53   {
54     return _role.bearer[_addr];
55   }
56 }
57 
58 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
59 
60 /**
61  * @title RBAC (Role-Based Access Control)
62  * @author Matt Condon (@Shrugs)
63  * @dev Stores and provides setters and getters for roles and addresses.
64  * Supports unlimited numbers of roles and addresses.
65  * See //contracts/mocks/RBACMock.sol for an example of usage.
66  * This RBAC method uses strings to key roles. It may be beneficial
67  * for you to write your own implementation of this interface using Enums or similar.
68  */
69 contract RBAC {
70   using Roles for Roles.Role;
71 
72   mapping (string => Roles.Role) private roles;
73 
74   event RoleAdded(address indexed operator, string role);
75   event RoleRemoved(address indexed operator, string role);
76 
77   /**
78    * @dev reverts if addr does not have role
79    * @param _operator address
80    * @param _role the name of the role
81    * // reverts
82    */
83   function checkRole(address _operator, string _role)
84     public
85     view
86   {
87     roles[_role].check(_operator);
88   }
89 
90   /**
91    * @dev determine if addr has role
92    * @param _operator address
93    * @param _role the name of the role
94    * @return bool
95    */
96   function hasRole(address _operator, string _role)
97     public
98     view
99     returns (bool)
100   {
101     return roles[_role].has(_operator);
102   }
103 
104   /**
105    * @dev add a role to an address
106    * @param _operator address
107    * @param _role the name of the role
108    */
109   function addRole(address _operator, string _role)
110     internal
111   {
112     roles[_role].add(_operator);
113     emit RoleAdded(_operator, _role);
114   }
115 
116   /**
117    * @dev remove a role from an address
118    * @param _operator address
119    * @param _role the name of the role
120    */
121   function removeRole(address _operator, string _role)
122     internal
123   {
124     roles[_role].remove(_operator);
125     emit RoleRemoved(_operator, _role);
126   }
127 
128   /**
129    * @dev modifier to scope access to a single role (uses msg.sender as addr)
130    * @param _role the name of the role
131    * // reverts
132    */
133   modifier onlyRole(string _role)
134   {
135     checkRole(msg.sender, _role);
136     _;
137   }
138 
139   /**
140    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
141    * @param _roles the names of the roles to scope access to
142    * // reverts
143    *
144    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
145    *  see: https://github.com/ethereum/solidity/issues/2467
146    */
147   // modifier onlyRoles(string[] _roles) {
148   //     bool hasAnyRole = false;
149   //     for (uint8 i = 0; i < _roles.length; i++) {
150   //         if (hasRole(msg.sender, _roles[i])) {
151   //             hasAnyRole = true;
152   //             break;
153   //         }
154   //     }
155 
156   //     require(hasAnyRole);
157 
158   //     _;
159   // }
160 }
161 
162 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
163 
164 /**
165  * @title SafeMath
166  * @dev Math operations with safety checks that throw on error
167  */
168 library SafeMath {
169 
170   /**
171   * @dev Multiplies two numbers, throws on overflow.
172   */
173   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
174     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
175     // benefit is lost if 'b' is also tested.
176     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
177     if (_a == 0) {
178       return 0;
179     }
180 
181     c = _a * _b;
182     assert(c / _a == _b);
183     return c;
184   }
185 
186   /**
187   * @dev Integer division of two numbers, truncating the quotient.
188   */
189   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
190     // assert(_b > 0); // Solidity automatically throws when dividing by 0
191     // uint256 c = _a / _b;
192     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
193     return _a / _b;
194   }
195 
196   /**
197   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198   */
199   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
200     assert(_b <= _a);
201     return _a - _b;
202   }
203 
204   /**
205   * @dev Adds two numbers, throws on overflow.
206   */
207   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
208     c = _a + _b;
209     assert(c >= _a);
210     return c;
211   }
212 }
213 
214 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
215 
216 /**
217  * @title ERC20Basic
218  * @dev Simpler version of ERC20 interface
219  * See https://github.com/ethereum/EIPs/issues/179
220  */
221 contract ERC20Basic {
222   function totalSupply() public view returns (uint256);
223   function balanceOf(address _who) public view returns (uint256);
224   function transfer(address _to, uint256 _value) public returns (bool);
225   event Transfer(address indexed from, address indexed to, uint256 value);
226 }
227 
228 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
229 
230 /**
231  * @title Basic token
232  * @dev Basic version of StandardToken, with no allowances.
233  */
234 contract BasicToken is ERC20Basic {
235   using SafeMath for uint256;
236 
237   mapping(address => uint256) internal balances;
238 
239   uint256 internal totalSupply_;
240 
241   /**
242   * @dev Total number of tokens in existence
243   */
244   function totalSupply() public view returns (uint256) {
245     return totalSupply_;
246   }
247 
248   /**
249   * @dev Transfer token for a specified address
250   * @param _to The address to transfer to.
251   * @param _value The amount to be transferred.
252   */
253   function transfer(address _to, uint256 _value) public returns (bool) {
254     require(_value <= balances[msg.sender]);
255     require(_to != address(0));
256 
257     balances[msg.sender] = balances[msg.sender].sub(_value);
258     balances[_to] = balances[_to].add(_value);
259     emit Transfer(msg.sender, _to, _value);
260     return true;
261   }
262 
263   /**
264   * @dev Gets the balance of the specified address.
265   * @param _owner The address to query the the balance of.
266   * @return An uint256 representing the amount owned by the passed address.
267   */
268   function balanceOf(address _owner) public view returns (uint256) {
269     return balances[_owner];
270   }
271 
272 }
273 
274 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
275 
276 /**
277  * @title Burnable Token
278  * @dev Token that can be irreversibly burned (destroyed).
279  */
280 contract BurnableToken is BasicToken {
281 
282   event Burn(address indexed burner, uint256 value);
283 
284   /**
285    * @dev Burns a specific amount of tokens.
286    * @param _value The amount of token to be burned.
287    */
288   function burn(uint256 _value) public {
289     _burn(msg.sender, _value);
290   }
291 
292   function _burn(address _who, uint256 _value) internal {
293     require(_value <= balances[_who]);
294     // no need to require value <= totalSupply, since that would imply the
295     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
296 
297     balances[_who] = balances[_who].sub(_value);
298     totalSupply_ = totalSupply_.sub(_value);
299     emit Burn(_who, _value);
300     emit Transfer(_who, address(0), _value);
301   }
302 }
303 
304 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
305 
306 /**
307  * @title Ownable
308  * @dev The Ownable contract has an owner address, and provides basic authorization control
309  * functions, this simplifies the implementation of "user permissions".
310  */
311 contract Ownable {
312   address public owner;
313 
314 
315   event OwnershipRenounced(address indexed previousOwner);
316   event OwnershipTransferred(
317     address indexed previousOwner,
318     address indexed newOwner
319   );
320 
321 
322   /**
323    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
324    * account.
325    */
326   constructor() public {
327     owner = msg.sender;
328   }
329 
330   /**
331    * @dev Throws if called by any account other than the owner.
332    */
333   modifier onlyOwner() {
334     require(msg.sender == owner);
335     _;
336   }
337 
338   /**
339    * @dev Allows the current owner to relinquish control of the contract.
340    * @notice Renouncing to ownership will leave the contract without an owner.
341    * It will not be possible to call the functions with the `onlyOwner`
342    * modifier anymore.
343    */
344   function renounceOwnership() public onlyOwner {
345     emit OwnershipRenounced(owner);
346     owner = address(0);
347   }
348 
349   /**
350    * @dev Allows the current owner to transfer control of the contract to a newOwner.
351    * @param _newOwner The address to transfer ownership to.
352    */
353   function transferOwnership(address _newOwner) public onlyOwner {
354     _transferOwnership(_newOwner);
355   }
356 
357   /**
358    * @dev Transfers control of the contract to a newOwner.
359    * @param _newOwner The address to transfer ownership to.
360    */
361   function _transferOwnership(address _newOwner) internal {
362     require(_newOwner != address(0));
363     emit OwnershipTransferred(owner, _newOwner);
364     owner = _newOwner;
365   }
366 }
367 
368 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
369 
370 /**
371  * @title ERC20 interface
372  * @dev see https://github.com/ethereum/EIPs/issues/20
373  */
374 contract ERC20 is ERC20Basic {
375   function allowance(address _owner, address _spender)
376     public view returns (uint256);
377 
378   function transferFrom(address _from, address _to, uint256 _value)
379     public returns (bool);
380 
381   function approve(address _spender, uint256 _value) public returns (bool);
382   event Approval(
383     address indexed owner,
384     address indexed spender,
385     uint256 value
386   );
387 }
388 
389 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
390 
391 /**
392  * @title Standard ERC20 token
393  *
394  * @dev Implementation of the basic standard token.
395  * https://github.com/ethereum/EIPs/issues/20
396  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
397  */
398 contract StandardToken is ERC20, BasicToken {
399 
400   mapping (address => mapping (address => uint256)) internal allowed;
401 
402 
403   /**
404    * @dev Transfer tokens from one address to another
405    * @param _from address The address which you want to send tokens from
406    * @param _to address The address which you want to transfer to
407    * @param _value uint256 the amount of tokens to be transferred
408    */
409   function transferFrom(
410     address _from,
411     address _to,
412     uint256 _value
413   )
414     public
415     returns (bool)
416   {
417     require(_value <= balances[_from]);
418     require(_value <= allowed[_from][msg.sender]);
419     require(_to != address(0));
420 
421     balances[_from] = balances[_from].sub(_value);
422     balances[_to] = balances[_to].add(_value);
423     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
424     emit Transfer(_from, _to, _value);
425     return true;
426   }
427 
428   /**
429    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
430    * Beware that changing an allowance with this method brings the risk that someone may use both the old
431    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
432    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
433    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
434    * @param _spender The address which will spend the funds.
435    * @param _value The amount of tokens to be spent.
436    */
437   function approve(address _spender, uint256 _value) public returns (bool) {
438     allowed[msg.sender][_spender] = _value;
439     emit Approval(msg.sender, _spender, _value);
440     return true;
441   }
442 
443   /**
444    * @dev Function to check the amount of tokens that an owner allowed to a spender.
445    * @param _owner address The address which owns the funds.
446    * @param _spender address The address which will spend the funds.
447    * @return A uint256 specifying the amount of tokens still available for the spender.
448    */
449   function allowance(
450     address _owner,
451     address _spender
452    )
453     public
454     view
455     returns (uint256)
456   {
457     return allowed[_owner][_spender];
458   }
459 
460   /**
461    * @dev Increase the amount of tokens that an owner allowed to a spender.
462    * approve should be called when allowed[_spender] == 0. To increment
463    * allowed value is better to use this function to avoid 2 calls (and wait until
464    * the first transaction is mined)
465    * From MonolithDAO Token.sol
466    * @param _spender The address which will spend the funds.
467    * @param _addedValue The amount of tokens to increase the allowance by.
468    */
469   function increaseApproval(
470     address _spender,
471     uint256 _addedValue
472   )
473     public
474     returns (bool)
475   {
476     allowed[msg.sender][_spender] = (
477       allowed[msg.sender][_spender].add(_addedValue));
478     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
479     return true;
480   }
481 
482   /**
483    * @dev Decrease the amount of tokens that an owner allowed to a spender.
484    * approve should be called when allowed[_spender] == 0. To decrement
485    * allowed value is better to use this function to avoid 2 calls (and wait until
486    * the first transaction is mined)
487    * From MonolithDAO Token.sol
488    * @param _spender The address which will spend the funds.
489    * @param _subtractedValue The amount of tokens to decrease the allowance by.
490    */
491   function decreaseApproval(
492     address _spender,
493     uint256 _subtractedValue
494   )
495     public
496     returns (bool)
497   {
498     uint256 oldValue = allowed[msg.sender][_spender];
499     if (_subtractedValue >= oldValue) {
500       allowed[msg.sender][_spender] = 0;
501     } else {
502       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
503     }
504     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
505     return true;
506   }
507 
508 }
509 
510 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
511 
512 /**
513  * @title Mintable token
514  * @dev Simple ERC20 Token example, with mintable token creation
515  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
516  */
517 contract MintableToken is StandardToken, Ownable {
518   event Mint(address indexed to, uint256 amount);
519   event MintFinished();
520 
521   bool public mintingFinished = false;
522 
523 
524   modifier canMint() {
525     require(!mintingFinished);
526     _;
527   }
528 
529   modifier hasMintPermission() {
530     require(msg.sender == owner);
531     _;
532   }
533 
534   /**
535    * @dev Function to mint tokens
536    * @param _to The address that will receive the minted tokens.
537    * @param _amount The amount of tokens to mint.
538    * @return A boolean that indicates if the operation was successful.
539    */
540   function mint(
541     address _to,
542     uint256 _amount
543   )
544     public
545     hasMintPermission
546     canMint
547     returns (bool)
548   {
549     totalSupply_ = totalSupply_.add(_amount);
550     balances[_to] = balances[_to].add(_amount);
551     emit Mint(_to, _amount);
552     emit Transfer(address(0), _to, _amount);
553     return true;
554   }
555 
556   /**
557    * @dev Function to stop minting new tokens.
558    * @return True if the operation was successful.
559    */
560   function finishMinting() public onlyOwner canMint returns (bool) {
561     mintingFinished = true;
562     emit MintFinished();
563     return true;
564   }
565 }
566 
567 // File: contracts/FUTM.sol
568 
569 contract FUTM is MintableToken, BurnableToken, RBAC {
570   using SafeMath for uint256;
571 
572   string public constant name = "Futereum Markets";
573   string public constant symbol = "FUTM";
574   uint8 public constant decimals = 18;
575 
576   string public constant ROLE_ADMIN = "admin";
577   string public constant ROLE_SUPER = "super";
578 
579   uint public swapLimit;
580   uint public constant CYCLE_CAP = 100000 * (10 ** uint256(decimals));
581   uint public constant BILLION = 10 ** 9;
582 
583   event SwapStarted(uint256 startTime);
584   event MiningRestart(uint256 endTime);
585   event CMCUpdate(string updateType, uint value);
586 
587   uint offset = 10**18;
588   // these rates are offset. divide by 1e18 to get actual rate.
589   uint public exchangeRateFUTB;
590   uint public exchangeRateFUTX;
591 
592   //initial state
593   uint public cycleMintSupply = 0;
594   bool public isMiningOpen = false;
595   uint public CMC = 129238998229;
596   uint public cycleEndTime;
597 
598   address public constant FUTC = 0xdaa6CD28E6aA9d656930cE4BB4FA93eEC96ee791;
599   address public constant FUTB = 0x42D8F8E19F73707397B6e9eB7dD022d3c0aE736c;
600   address public constant FUTX = 0x8b7d07b6ffB9364e97B89cEA8b84F94249bE459F;
601 
602   constructor() public {
603     //only the contract itself can mint as the owner
604     owner = this;
605     totalSupply_ = 0;
606     addRole(msg.sender, ROLE_ADMIN);
607     addRole(msg.sender, ROLE_SUPER);
608 
609     // initial market data to set rates.
610     exchangeRateFUTB = offset.mul(offset).div(CMC.mul(offset).div(BILLION)).mul(65).div(100);
611     exchangeRateFUTX = offset.mul(offset).div(uint(14757117940).mul(offset).div(uint(67447696614)).mul(CMC).div(BILLION)).mul(65).div(100);
612   }
613 
614   modifier canMine() {
615     require(isMiningOpen);
616     _;
617   }
618 
619   // first call (futb address).approve(futm address, amount) for FUTM to transfer on your behalf.
620   function mine(uint amount) canMine external {
621     require(amount > 0);
622     require(cycleMintSupply < CYCLE_CAP);
623     require(ERC20(FUTB).transferFrom(msg.sender, address(this), amount));
624 
625     uint refund = _mine(exchangeRateFUTB, amount);
626     if(refund > 0) {
627       ERC20(FUTB).transfer(msg.sender, refund);
628     }
629     if (cycleMintSupply >= CYCLE_CAP || now > cycleEndTime) {
630       //start swap
631       _startSwap();
632     }
633   }
634 
635   function _mine(uint _rate, uint _inAmount) private returns (uint) {
636     assert(_rate > 0);
637 
638     // took too long; return tokens and start swap.
639     if (now > cycleEndTime && cycleMintSupply > 0) {
640       return _inAmount;
641     }
642     uint tokens = _rate.mul(_inAmount).div(offset);
643     uint refund = 0;
644 
645     // for every 65 tokens mined, we mine 35 for the futc contract.
646     uint futcFeed = tokens.mul(35).div(65);
647 
648     if (tokens + futcFeed + cycleMintSupply > CYCLE_CAP) {
649       uint overage = tokens + futcFeed + cycleMintSupply - CYCLE_CAP;
650       uint tokenOverage = overage.mul(65).div(100);
651       futcFeed -= (overage - tokenOverage);
652       tokens -= tokenOverage;
653 
654       // refund token overage
655       refund = tokenOverage.mul(offset).div(_rate);
656     }
657     cycleMintSupply += (tokens + futcFeed);
658     require(futcFeed > 0, "Mining payment too small.");
659     MintableToken(this).mint(msg.sender, tokens);
660     MintableToken(this).mint(FUTC, futcFeed);
661 
662     return refund;
663   }
664 
665   // swap data
666   bool public swapOpen = false;
667   mapping(address => uint) public swapRates;
668 
669   function _startSwap() private {
670     swapOpen = true;
671     isMiningOpen = false;
672 
673     // set swap rates
674     // 35% of holdings split among a number equal to 35% of newly minted futm
675     swapLimit = cycleMintSupply.mul(35).div(100);
676     swapRates[FUTX] = ERC20(FUTX).balanceOf(address(this)).mul(offset).mul(35).div(100).div(swapLimit);
677     swapRates[FUTB] = ERC20(FUTB).balanceOf(address(this)).mul(offset).mul(35).div(100).div(swapLimit);
678 
679     emit SwapStarted(now);
680   }
681 
682   function swap(uint amt) public {
683     require(swapOpen && swapLimit > 0);
684     if (amt > swapLimit) {
685       amt = swapLimit;
686     }
687     swapLimit -= amt;
688     // burn verifies msg.sender has balance
689     burn(amt);
690 
691     if (amt.mul(swapRates[FUTX]) > 0) {
692       ERC20(FUTX).transfer(msg.sender, amt.mul(swapRates[FUTX]).div(offset));
693     }
694 
695     if (amt.mul(swapRates[FUTB]) > 0) {
696       ERC20(FUTB).transfer(msg.sender, amt.mul(swapRates[FUTB]).div(offset));
697     }
698 
699     if (swapLimit == 0) {
700       _restart();
701     }
702   }
703 
704   function _restart() private {
705     require(swapOpen);
706     require(swapLimit == 0);
707 
708     cycleMintSupply = 0;
709     swapOpen = false;
710     isMiningOpen = true;
711     cycleEndTime = now + 100 days;
712 
713     emit MiningRestart(cycleEndTime);
714   }
715 
716   function updateCMC(uint _cmc) private {
717     require(_cmc > 0);
718     CMC = _cmc;
719     emit CMCUpdate("TOTAL_CMC", _cmc);
720     exchangeRateFUTB = offset.mul(offset).div(CMC.mul(offset).div(BILLION)).mul(65).div(100);
721   }
722 
723   function updateCMC(uint _cmc, uint _btc, uint _eth) public onlyAdmin{
724     require(_btc > 0 && _eth > 0);
725     updateCMC(_cmc);
726     emit CMCUpdate("BTC_CMC", _btc);
727     emit CMCUpdate("ETH_CMC", _eth);
728     exchangeRateFUTX = offset.mul(offset).div(_eth.mul(offset).div(_btc).mul(CMC).div(BILLION)).mul(65).div(100);
729   }
730 
731   function setIsMiningOpen(bool isOpen) onlyAdmin external {
732     isMiningOpen = isOpen;
733   }
734 
735   modifier onlySuper() {
736     checkRole(msg.sender, ROLE_SUPER);
737     _;
738   }
739 
740   modifier onlyAdmin() {
741     checkRole(msg.sender, ROLE_ADMIN);
742     _;
743   }
744 
745   function addAdmin(address _addr) public onlySuper {
746     addRole(_addr, ROLE_ADMIN);
747   }
748 
749   function removeAdmin(address _addr) public onlySuper {
750     removeRole(_addr, ROLE_ADMIN);
751   }
752 
753   function changeSuper(address _addr) public onlySuper {
754     addRole(_addr, ROLE_SUPER);
755     removeRole(msg.sender, ROLE_SUPER);
756   }
757 }