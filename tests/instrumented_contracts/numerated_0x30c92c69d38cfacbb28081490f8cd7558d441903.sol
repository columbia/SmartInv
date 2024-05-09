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
567 // File: contracts/COE.sol
568 
569 contract COE is MintableToken, BurnableToken, RBAC {
570   using SafeMath for uint256;
571 
572   string public constant name = "Coin Market Cap Coeval";
573   string public constant symbol = "COE";
574   uint8 public constant decimals = 18;
575 
576   // this variable represents the total amount of eth raised
577   uint public ethRaised;
578 
579   string public constant ROLE_WHITELISTED = "whitelist";
580   string public constant ROLE_ADMIN = "admin";
581   string public constant ROLE_SUPER = "super";
582 
583   uint public swapLimit;
584   uint public constant CYCLE_CAP = 100000 * (10 ** uint256(decimals));
585   uint public constant BILLION = 10 ** 9;
586 
587   event SwapStarted(uint256 startTime);
588   event MiningRestart(uint256 endTime);
589   event CMCUpdate(string updateType, uint value);
590 
591   uint offset = 10**18;
592   // these rates are offset. divide by 1e18 to get actual rate.
593   uint public exchangeRateMNY;
594   uint public exchangeRateFUTX;
595 
596   //initial state
597   uint public cycleMintSupply = 0;
598   bool public isMiningOpen = false;
599   uint public CMC = 236346228108;
600   uint public cycleEndTime;
601 
602   address public constant ZUR = 0x8218a33eB15901Ce71b3B8123E58b7E312ce638A;
603   address public constant MNY = 0xD2354AcF1a2f06D69D8BC2e2048AaBD404445DF6;
604   address public constant FUTX = 0x8b7d07b6ffB9364e97B89cEA8b84F94249bE459F;
605 
606   constructor() public {
607     //only the contract itself can mint as the owner
608     owner = this;
609     totalSupply_ = 0;
610     addRole(msg.sender, ROLE_ADMIN);
611     addRole(msg.sender, ROLE_SUPER);
612     addRole(msg.sender, ROLE_WHITELISTED);
613 
614     // initial market data to set rates.
615     exchangeRateMNY = offset.mul(offset).div(CMC.mul(offset).div(BILLION)).mul(65).div(100);
616     exchangeRateFUTX = offset.mul(offset).div(uint(29997535964).mul(offset).div(uint(123943034521)).mul(CMC).div(BILLION)).mul(65).div(100);
617   }
618 
619   function () external payable {
620     buyTokens(msg.sender);
621   }
622 
623   function donateEth() external payable {
624     //thanks! this will add to the swap back amount.
625     ethRaised += msg.value;
626   }
627 
628   uint public presaleFee = 0;
629   uint8 public presaleLevel = 1;
630   uint public coePerEthOffset = offset.div(presaleLevel).mul(650);
631   bool public presaleOpen = false;
632   uint public ethRateExpiration;
633   uint public coeRemainingAtCurrentRate = 1000 ether;
634 
635   function startPresale() onlyAdmin public {
636     require(!presaleOpen && presaleLevel == 1);
637     ethRateExpiration = now + 1 days;
638     presaleOpen = true;
639   }
640 
641   function buyTokens(address _beneficiary) public payable {
642     require(presaleOpen);
643     require(msg.value > 0);
644     ethRaised += msg.value;
645     uint buyingPower = msg.value;
646     presaleFee += buyingPower.mul(65).div(100);
647     uint tokens = 0;
648     uint zurFeed = 0;
649 
650     if (now > ethRateExpiration) {
651       incrementLevel(buyingPower);
652     }
653 
654     while(buyingPower > 0) {
655       uint ethToFillLevel = coeRemainingAtCurrentRate.mul(65).div(100).mul(offset).div(coePerEthOffset);
656       if (buyingPower >= ethToFillLevel) {
657         buyingPower -= ethToFillLevel;
658         tokens += coeRemainingAtCurrentRate.mul(65).div(100);
659         zurFeed += coeRemainingAtCurrentRate.mul(35).div(100);
660         coeRemainingAtCurrentRate = 0;
661       } else {
662         tokens += buyingPower.mul(coePerEthOffset).div(offset);
663         zurFeed += buyingPower.mul(coePerEthOffset).div(offset).mul(35).div(65);
664         coeRemainingAtCurrentRate = coeRemainingAtCurrentRate.sub(buyingPower.mul(coePerEthOffset).mul(100).div(65).div(offset));
665         buyingPower = 0;
666       }
667 
668       if (coeRemainingAtCurrentRate == 0) {
669         incrementLevel(buyingPower);
670 
671         if (!presaleOpen) {
672           // round any leftover dust to last buyer
673           tokens += (CYCLE_CAP - cycleMintSupply - tokens - zurFeed);
674           break;
675         }
676       }
677     }
678 
679     cycleMintSupply += (tokens + zurFeed);
680     if (!presaleOpen) {
681       // start swap
682       _startSwap();
683     }
684     MintableToken(this).mint(_beneficiary, tokens);
685     MintableToken(this).mint(ZUR, zurFeed);
686   }
687 
688   function incrementLevel(uint buyingPower) private {
689     if (presaleLevel == 100) {
690       if (buyingPower > 0) {
691         // refund extra eth
692         presaleFee -= buyingPower.mul(65).div(100);
693         ethRaised -= buyingPower;
694         msg.sender.transfer(buyingPower);
695       }
696       presaleOpen = false;
697     } else {
698       presaleLevel++;
699       coeRemainingAtCurrentRate += 1000 ether;
700       coePerEthOffset = offset.div(presaleLevel).mul(650);
701       ethRateExpiration = now + 1 days;
702     }
703   }
704 
705   modifier canMine() {
706     require(isMiningOpen);
707     _;
708   }
709 
710   // first call (mny address).approve(coe address, amount) for COE to transfer on your behalf.
711   function mine(uint amount) canMine public {
712     require(amount > 0);
713     require(cycleMintSupply < CYCLE_CAP);
714     require(ERC20(MNY).transferFrom(msg.sender, address(this), amount));
715 
716     uint refund = _mine(exchangeRateMNY, amount);
717     if(refund > 0) {
718       ERC20(MNY).transfer(msg.sender, refund);
719     }
720     if (cycleMintSupply == CYCLE_CAP) {
721       //start swap
722       _startSwap();
723     }
724   }
725 
726   // first call (futx address).approve(coe address, amount) for COE to transfer on your behalf.
727   function whitelistMine(uint amount) canMine onlyIfWhitelisted public {
728     require(amount > 0);
729     require(cycleMintSupply < CYCLE_CAP);
730     require(ERC20(FUTX).transferFrom(msg.sender, address(this), amount));
731 
732     uint refund = _mine(exchangeRateFUTX, amount);
733     if(refund > 0) {
734       ERC20(FUTX).transfer(msg.sender, refund);
735     }
736     if (cycleMintSupply == CYCLE_CAP) {
737       //start swap
738       _startSwap();
739     }
740   }
741 
742   function _mine(uint _rate, uint _inAmount) private returns (uint) {
743     assert(_rate > 0);
744 
745     // took too long; return tokens and start swap.
746     if (now > cycleEndTime && cycleMintSupply > 0) {
747       _startSwap();
748       return _inAmount;
749     }
750     uint tokens = _rate.mul(_inAmount).div(offset);
751     uint refund = 0;
752 
753     // for every 65 tokens mined, we mine 35 for the zur contract.
754     uint zurFeed = tokens.mul(35).div(65);
755 
756     if (tokens + zurFeed + cycleMintSupply > CYCLE_CAP) {
757       uint overage = tokens + zurFeed + cycleMintSupply - CYCLE_CAP;
758       uint tokenOverage = overage.mul(65).div(100);
759       zurFeed -= (overage - tokenOverage);
760       tokens -= tokenOverage;
761 
762       // refund token overage
763       refund = tokenOverage.mul(offset).div(_rate);
764     }
765     cycleMintSupply += (tokens + zurFeed);
766     require(zurFeed > 0, "Mining payment too small.");
767     MintableToken(this).mint(msg.sender, tokens);
768     MintableToken(this).mint(ZUR, zurFeed);
769 
770     return refund;
771   }
772 
773   // swap data
774   bool public swapOpen = false;
775   uint public ethSwapRate;
776   mapping(address => uint) public swapRates;
777 
778   function _startSwap() private {
779     swapOpen = true;
780     isMiningOpen = false;
781 
782     // set swap rates
783     // 35% of holdings split among a number equal to 35% of newly minted coe
784     swapLimit = cycleMintSupply.mul(35).div(100);
785     ethSwapRate = (address(this).balance.sub(presaleFee)).mul(offset).mul(35).div(100).div(swapLimit);
786     swapRates[FUTX] = ERC20(FUTX).balanceOf(address(this)).mul(offset).mul(35).div(100).div(swapLimit);
787     swapRates[MNY] = ERC20(MNY).balanceOf(address(this)).mul(offset).mul(35).div(100).div(swapLimit);
788 
789     emit SwapStarted(now);
790   }
791 
792   function swap(uint amt) public {
793     require(swapOpen && swapLimit > 0);
794     if (amt > swapLimit) {
795       amt = swapLimit;
796     }
797     swapLimit -= amt;
798     // burn verifies msg.sender has balance
799     burn(amt);
800 
801     if (amt.mul(ethSwapRate) > 0) {
802       msg.sender.transfer(amt.mul(ethSwapRate).div(offset));
803     }
804 
805     if (amt.mul(swapRates[FUTX]) > 0) {
806       ERC20(FUTX).transfer(msg.sender, amt.mul(swapRates[FUTX]).div(offset));
807     }
808 
809     if (amt.mul(swapRates[MNY]) > 0) {
810       ERC20(MNY).transfer(msg.sender, amt.mul(swapRates[MNY]).div(offset));
811     }
812 
813     if (swapLimit == 0) {
814       _restart();
815     }
816   }
817 
818   function _restart() private {
819     require(swapOpen);
820     require(swapLimit == 0);
821 
822     cycleMintSupply = 0;
823     swapOpen = false;
824     isMiningOpen = true;
825     cycleEndTime = now + 100 days;
826 
827     emit MiningRestart(cycleEndTime);
828   }
829 
830   function updateCMC(uint _cmc) private {
831     require(_cmc > 0);
832     CMC = _cmc;
833     emit CMCUpdate("TOTAL_CMC", _cmc);
834     exchangeRateMNY = offset.mul(offset).div(CMC.mul(offset).div(BILLION)).mul(65).div(100);
835   }
836 
837   function updateCMC(uint _cmc, uint _btc, uint _eth) public onlyAdmin{
838     require(_btc > 0 && _eth > 0);
839     updateCMC(_cmc);
840     emit CMCUpdate("BTC_CMC", _btc);
841     emit CMCUpdate("ETH_CMC", _eth);
842     exchangeRateFUTX = offset.mul(offset).div(_eth.mul(offset).div(_btc).mul(CMC).div(BILLION)).mul(65).div(100);
843   }
844 
845   modifier onlyIfWhitelisted() {
846     checkRole(msg.sender, ROLE_WHITELISTED);
847     _;
848   }
849 
850   modifier onlySuper() {
851     checkRole(msg.sender, ROLE_SUPER);
852     _;
853   }
854 
855   modifier onlyAdmin() {
856     checkRole(msg.sender, ROLE_ADMIN);
857     _;
858   }
859 
860   function addAdmin(address _addr) public onlySuper {
861     addRole(_addr, ROLE_ADMIN);
862   }
863 
864   function removeAdmin(address _addr) public onlySuper {
865     removeRole(_addr, ROLE_ADMIN);
866   }
867 
868   function changeSuper(address _addr) public onlySuper {
869     addRole(_addr, ROLE_SUPER);
870     removeRole(msg.sender, ROLE_SUPER);
871   }
872 
873   function addAddressToWhitelist(address _operator)
874     public
875     onlySuper
876   {
877     addRole(_operator, ROLE_WHITELISTED);
878   }
879 
880   function whitelist(address _operator)
881     public
882     view
883     returns (bool)
884   {
885     return hasRole(_operator, ROLE_WHITELISTED);
886   }
887 
888   function addAddressesToWhitelist(address[] _operators)
889     public
890     onlySuper
891   {
892     for (uint256 i = 0; i < _operators.length; i++) {
893       addAddressToWhitelist(_operators[i]);
894     }
895   }
896 
897   function removeAddressFromWhitelist(address _operator)
898     public
899     onlySuper
900   {
901     removeRole(_operator, ROLE_WHITELISTED);
902   }
903 
904   function removeAddressesFromWhitelist(address[] _operators)
905     public
906     onlySuper
907   {
908     for (uint256 i = 0; i < _operators.length; i++) {
909       removeAddressFromWhitelist(_operators[i]);
910     }
911   }
912 
913   function payFees() public {
914     require(presaleFee > 0);
915     uint feeShare = presaleFee.div(13);
916     if (feeShare > 0) {
917       address(0x17F619855432168f2aB5A1B2133888d9ffCC3946).transfer(feeShare);
918       address(0xAaf47A27BBd9B82ee0f1f77C7b437A36160c4242).transfer(feeShare * 4);
919       address(0x6c18DCCDfFd4874Cb88b403637045f12f5a227e3).transfer(feeShare * 3);
920       address(0x5d2b9f5345e69E2390cE4C26ccc9C2910A097520).transfer(feeShare * 2);
921       address(0xcf5Ee528278a57Ba087684f685D99A6a5EC4c439).transfer(feeShare * 3);
922     }
923     presaleFee = 0;
924   }
925 }