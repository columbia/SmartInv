1 pragma solidity 0.4.20;
2 
3 /**
4  * @title Crowdsale Contract
5  * @author Kirill Varlamov (@ongrid), OnGrid systems
6  * @dev Crowdsale is a contract for managing a token crowdsale,
7  * allowing investors to purchase tokens with ether.
8  */
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 
57 /**
58  * @title Roles
59  * @author Francisco Giordano (@frangio)
60  * @dev Library for managing addresses assigned to a Role.
61  *      See RBAC.sol for example usage.
62  */
63 library Roles {
64   struct Role {
65     mapping (address => bool) bearer;
66   }
67 
68   /**
69    * @dev give an address access to this role
70    */
71   function add(Role storage role, address addr)
72     internal
73   {
74     role.bearer[addr] = true;
75   }
76 
77   /**
78    * @dev remove an address' access to this role
79    */
80   function remove(Role storage role, address addr)
81     internal
82   {
83     role.bearer[addr] = false;
84   }
85 
86   /**
87    * @dev check if an address has this role
88    * // reverts
89    */
90   function check(Role storage role, address addr)
91     view
92     internal
93   {
94     require(has(role, addr));
95   }
96 
97   /**
98    * @dev check if an address has this role
99    * @return bool
100    */
101   function has(Role storage role, address addr)
102     view
103     internal
104     returns (bool)
105   {
106     return role.bearer[addr];
107   }
108 }
109 
110 
111 /**
112  * @title RBAC (Role-Based Access Control)
113  * @author Matt Condon (@Shrugs)
114  * @dev Stores and provides setters and getters for roles and addresses.
115  *      Supports unlimited numbers of roles and addresses.
116  *      See //contracts/mocks/RBACMock.sol for an example of usage.
117  * This RBAC method uses strings to key roles. It may be beneficial
118  *  for you to write your own implementation of this interface using Enums or similar.
119  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
120  *  to avoid typos.
121  */
122 contract RBAC {
123   using Roles for Roles.Role;
124 
125   mapping (string => Roles.Role) private roles;
126 
127   event RoleAdded(address addr, string roleName);
128   event RoleRemoved(address addr, string roleName);
129 
130   /**
131    * A constant role name for indicating admins.
132    */
133   string public constant ROLE_ADMIN = "admin";
134 
135   /**
136    * @dev constructor. Sets msg.sender as admin by default
137    */
138   function RBAC()
139     public
140   {
141     addRole(msg.sender, ROLE_ADMIN);
142   }
143 
144   /**
145    * @dev reverts if addr does not have role
146    * @param addr address
147    * @param roleName the name of the role
148    * // reverts
149    */
150   function checkRole(address addr, string roleName)
151     view
152     public
153   {
154     roles[roleName].check(addr);
155   }
156 
157   /**
158    * @dev determine if addr has role
159    * @param addr address
160    * @param roleName the name of the role
161    * @return bool
162    */
163   function hasRole(address addr, string roleName)
164     view
165     public
166     returns (bool)
167   {
168     return roles[roleName].has(addr);
169   }
170 
171   /**
172    * @dev add a role to an address
173    * @param addr address
174    * @param roleName the name of the role
175    */
176   function adminAddRole(address addr, string roleName)
177     onlyAdmin
178     public
179   {
180     addRole(addr, roleName);
181   }
182 
183   /**
184    * @dev remove a role from an address
185    * @param addr address
186    * @param roleName the name of the role
187    */
188   function adminRemoveRole(address addr, string roleName)
189     onlyAdmin
190     public
191   {
192     removeRole(addr, roleName);
193   }
194 
195   /**
196    * @dev add a role to an address
197    * @param addr address
198    * @param roleName the name of the role
199    */
200   function addRole(address addr, string roleName)
201     internal
202   {
203     roles[roleName].add(addr);
204     RoleAdded(addr, roleName);
205   }
206 
207   /**
208    * @dev remove a role from an address
209    * @param addr address
210    * @param roleName the name of the role
211    */
212   function removeRole(address addr, string roleName)
213     internal
214   {
215     roles[roleName].remove(addr);
216     RoleRemoved(addr, roleName);
217   }
218 
219   /**
220    * @dev modifier to scope access to a single role (uses msg.sender as addr)
221    * @param roleName the name of the role
222    * // reverts
223    */
224   modifier onlyRole(string roleName)
225   {
226     checkRole(msg.sender, roleName);
227     _;
228   }
229 
230   /**
231    * @dev modifier to scope access to admins
232    * // reverts
233    */
234   modifier onlyAdmin()
235   {
236     checkRole(msg.sender, ROLE_ADMIN);
237     _;
238   }
239 }
240 
241 /**
242  * @title ERC20Basic
243  * @dev Simpler version of ERC20 interface
244  * @dev see https://github.com/ethereum/EIPs/issues/179
245  */
246 contract ERC20Basic {
247   function totalSupply() public view returns (uint256);
248   function balanceOf(address who) public view returns (uint256);
249   function transfer(address to, uint256 value) public returns (bool);
250   event Transfer(address indexed from, address indexed to, uint256 value);
251 }
252 
253 
254 /**
255  * @title ERC20 interface
256  * @dev see https://github.com/ethereum/EIPs/issues/20
257  */
258 contract ERC20 is ERC20Basic {
259   function allowance(address owner, address spender) public view returns (uint256);
260   function transferFrom(address from, address to, uint256 value) public returns (bool);
261   function approve(address spender, uint256 value) public returns (bool);
262   event Approval(address indexed owner, address indexed spender, uint256 value);
263 }
264 
265 
266 /**
267  * @title Basic token
268  * @dev Basic version of StandardToken, with no allowances.
269  */
270 contract BasicToken is ERC20Basic {
271   using SafeMath for uint256;
272 
273   mapping(address => uint256) balances;
274 
275   uint256 totalSupply_;
276 
277   /**
278   * @dev total number of tokens in existence
279   */
280   function totalSupply() public view returns (uint256) {
281     return totalSupply_;
282   }
283 
284   /**
285   * @dev transfer token for a specified address
286   * @param _to The address to transfer to.
287   * @param _value The amount to be transferred.
288   */
289   function transfer(address _to, uint256 _value) public returns (bool) {
290     require(_to != address(0));
291     require(_value <= balances[msg.sender]);
292 
293     // SafeMath.sub will throw if there is not enough balance.
294     balances[msg.sender] = balances[msg.sender].sub(_value);
295     balances[_to] = balances[_to].add(_value);
296     Transfer(msg.sender, _to, _value);
297     return true;
298   }
299 
300   /**
301   * @dev Gets the balance of the specified address.
302   * @param _owner The address to query the the balance of.
303   * @return An uint256 representing the amount owned by the passed address.
304   */
305   function balanceOf(address _owner) public view returns (uint256 balance) {
306     return balances[_owner];
307   }
308 
309 }
310 
311 
312 /**
313  * @title Standard ERC20 token
314  *
315  * @dev Implementation of the basic standard token.
316  * @dev https://github.com/ethereum/EIPs/issues/20
317  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
318  */
319 contract StandardToken is ERC20, BasicToken {
320 
321   mapping (address => mapping (address => uint256)) internal allowed;
322 
323 
324   /**
325    * @dev Transfer tokens from one address to another
326    * @param _from address The address which you want to send tokens from
327    * @param _to address The address which you want to transfer to
328    * @param _value uint256 the amount of tokens to be transferred
329    */
330   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
331     require(_to != address(0));
332     require(_value <= balances[_from]);
333     require(_value <= allowed[_from][msg.sender]);
334 
335     balances[_from] = balances[_from].sub(_value);
336     balances[_to] = balances[_to].add(_value);
337     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
338     Transfer(_from, _to, _value);
339     return true;
340   }
341 
342   /**
343    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
344    *
345    * Beware that changing an allowance with this method brings the risk that someone may use both the old
346    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
347    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
348    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349    * @param _spender The address which will spend the funds.
350    * @param _value The amount of tokens to be spent.
351    */
352   function approve(address _spender, uint256 _value) public returns (bool) {
353     allowed[msg.sender][_spender] = _value;
354     Approval(msg.sender, _spender, _value);
355     return true;
356   }
357 
358   /**
359    * @dev Function to check the amount of tokens that an owner allowed to a spender.
360    * @param _owner address The address which owns the funds.
361    * @param _spender address The address which will spend the funds.
362    * @return A uint256 specifying the amount of tokens still available for the spender.
363    */
364   function allowance(address _owner, address _spender) public view returns (uint256) {
365     return allowed[_owner][_spender];
366   }
367 
368   /**
369    * @dev Increase the amount of tokens that an owner allowed to a spender.
370    *
371    * approve should be called when allowed[_spender] == 0. To increment
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param _spender The address which will spend the funds.
376    * @param _addedValue The amount of tokens to increase the allowance by.
377    */
378   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
379     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
380     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
381     return true;
382   }
383 
384   /**
385    * @dev Decrease the amount of tokens that an owner allowed to a spender.
386    *
387    * approve should be called when allowed[_spender] == 0. To decrement
388    * allowed value is better to use this function to avoid 2 calls (and wait until
389    * the first transaction is mined)
390    * From MonolithDAO Token.sol
391    * @param _spender The address which will spend the funds.
392    * @param _subtractedValue The amount of tokens to decrease the allowance by.
393    */
394   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
395     uint oldValue = allowed[msg.sender][_spender];
396     if (_subtractedValue > oldValue) {
397       allowed[msg.sender][_spender] = 0;
398     } else {
399       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
400     }
401     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
402     return true;
403   }
404 
405 }
406 
407 
408 contract DeneumToken is StandardToken {
409     string public name = "Deneum";
410     string public symbol = "DNM";
411     uint8 public decimals = 2;
412     bool public mintingFinished = false;
413     mapping (address => bool) owners;
414     mapping (address => bool) minters;
415 
416     event Mint(address indexed to, uint256 amount);
417     event MintFinished();
418     event OwnerAdded(address indexed newOwner);
419     event OwnerRemoved(address indexed removedOwner);
420     event MinterAdded(address indexed newMinter);
421     event MinterRemoved(address indexed removedMinter);
422     event Burn(address indexed burner, uint256 value);
423 
424     function DeneumToken() public {
425         owners[msg.sender] = true;
426     }
427 
428     /**
429      * @dev Function to mint tokens
430      * @param _to The address that will receive the minted tokens.
431      * @param _amount The amount of tokens to mint.
432      * @return A boolean that indicates if the operation was successful.
433      */
434     function mint(address _to, uint256 _amount) onlyMinter public returns (bool) {
435         require(!mintingFinished);
436         totalSupply_ = totalSupply_.add(_amount);
437         balances[_to] = balances[_to].add(_amount);
438         Mint(_to, _amount);
439         Transfer(address(0), _to, _amount);
440         return true;
441     }
442 
443     /**
444      * @dev Function to stop minting new tokens.
445      * @return True if the operation was successful.
446      */
447     function finishMinting() onlyOwner public returns (bool) {
448         require(!mintingFinished);
449         mintingFinished = true;
450         MintFinished();
451         return true;
452     }
453 
454     /**
455      * @dev Burns a specific amount of tokens.
456      * @param _value The amount of token to be burned.
457      */
458     function burn(uint256 _value) public {
459         require(_value <= balances[msg.sender]);
460         // no need to require value <= totalSupply, since that would imply the
461         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
462 
463         address burner = msg.sender;
464         balances[burner] = balances[burner].sub(_value);
465         totalSupply_ = totalSupply_.sub(_value);
466         Burn(burner, _value);
467         Transfer(burner, address(0), _value);
468     }
469 
470     /**
471      * @dev Adds administrative role to address
472      * @param _address The address that will get administrative privileges
473      */
474     function addOwner(address _address) onlyOwner public {
475         owners[_address] = true;
476         OwnerAdded(_address);
477     }
478 
479     /**
480      * @dev Removes administrative role from address
481      * @param _address The address to remove administrative privileges from
482      */
483     function delOwner(address _address) onlyOwner public {
484         owners[_address] = false;
485         OwnerRemoved(_address);
486     }
487 
488     /**
489      * @dev Throws if called by any account other than the owner.
490      */
491     modifier onlyOwner() {
492         require(owners[msg.sender]);
493         _;
494     }
495 
496     /**
497      * @dev Adds minter role to address (able to create new tokens)
498      * @param _address The address that will get minter privileges
499      */
500     function addMinter(address _address) onlyOwner public {
501         minters[_address] = true;
502         MinterAdded(_address);
503     }
504 
505     /**
506      * @dev Removes minter role from address
507      * @param _address The address to remove minter privileges
508      */
509     function delMinter(address _address) onlyOwner public {
510         minters[_address] = false;
511         MinterRemoved(_address);
512     }
513 
514     /**
515      * @dev Throws if called by any account other than the minter.
516      */
517     modifier onlyMinter() {
518         require(minters[msg.sender]);
519         _;
520     }
521 }
522 
523 
524 /**
525  * @title PriceOracle interface
526  * @dev Price oracle is a contract representing actual average ETH/USD price in the
527  * Ethereum blockchain fo use by other contracts.
528  */
529 contract PriceOracle {
530     // USD cents per ETH exchange price
531     uint256 public priceUSDcETH;
532 }
533 
534 
535 /**
536  * @title Crowdsale Contract
537  * @author Kirill Varlamov (@ongrid), OnGrid systems
538  * @dev Crowdsale is a contract for managing a token crowdsale,
539  * allowing investors to purchase tokens with ether.
540  */
541 contract DeneumCrowdsale is RBAC {
542     using SafeMath for uint256;
543 
544     struct Phase {
545         uint256 startDate;
546         uint256 endDate;
547         uint256 priceUSDcDNM;
548         uint256 tokensIssued;
549         uint256 tokensCap; // the maximum amount of tokens allowed to be sold on the phase
550     }
551     Phase[] public phases;
552 
553     // The token being sold
554     DeneumToken public token;
555 
556     // ETH/USD price source
557     PriceOracle public oracle;
558 
559     // Address where funds get collected
560     address public wallet;
561 
562     // Amount of ETH raised in wei. 1 wei is 10e-18 ETH
563     uint256 public weiRaised;
564 
565     // Amount of tokens issued by this contract
566     uint256 public tokensIssued;
567 
568     /**
569      * Event for token purchase logging
570      * @param purchaser who paid for the tokens
571      * @param beneficiary who got the tokens
572      * @param value weis paid for purchase
573      * @param amount amount of tokens purchased
574      */
575     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
576 
577     /**
578      * @dev Events for contract states changes
579      */
580     event PhaseAdded(address indexed sender, uint256 index, uint256 startDate, uint256 endDate, uint256 priceUSDcDNM, uint256 tokensCap);
581     event PhaseDeleted(address indexed sender, uint256 index);
582     event WalletChanged(address newWallet);
583     event OracleChanged(address newOracle);
584 
585     /**
586      * @param _wallet Address where collected funds will be forwarded to
587      * @param _token  Address of the token being sold
588      * @param _oracle ETH price oracle where we get actual exchange rate
589      */
590     function DeneumCrowdsale(address _wallet, DeneumToken _token, PriceOracle _oracle) RBAC() public {
591         require(_wallet != address(0));
592         require(_token != address(0));
593         wallet = _wallet;
594         token = _token;
595         oracle = _oracle;
596     }
597 
598     /**
599      * @dev fallback function receiving investor's ethers
600      *      It calculates deposit USD value and corresponding token amount,
601      *      runs some checks (if phase cap not exceeded, value and addresses are not null),
602      *      then mints corresponding amount of tokens, increments state variables.
603      *      After tokens issued Ethers get transferred to the wallet.
604      */
605     function () external payable {
606         uint256 priceUSDcETH = getPriceUSDcETH();
607         uint256 weiAmount = msg.value;
608         address beneficiary = msg.sender;
609         uint256 currentPhaseIndex = getCurrentPhaseIndex();
610         uint256 valueUSDc = weiAmount.mul(priceUSDcETH).div(1 ether);
611         uint256 tokens = valueUSDc.mul(100).div(phases[currentPhaseIndex].priceUSDcDNM);
612         require(beneficiary != address(0));
613         require(weiAmount != 0);
614         require(phases[currentPhaseIndex].tokensIssued.add(tokens) < phases[currentPhaseIndex].tokensCap);
615         weiRaised = weiRaised.add(weiAmount);
616         phases[currentPhaseIndex].tokensIssued = phases[currentPhaseIndex].tokensIssued.add(tokens);
617         tokensIssued = tokensIssued.add(tokens);
618         token.mint(beneficiary, tokens);
619         wallet.transfer(msg.value);
620         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
621     }
622 
623     /**
624      * @dev Proxies current ETH balance request to the Oracle contract
625      * @return ETH price in USD cents
626      */
627     function getPriceUSDcETH() public view returns(uint256) {
628         require(oracle.priceUSDcETH() > 0);
629         return oracle.priceUSDcETH();
630     }
631 
632     /**
633      * @dev Allows to change Oracle address (source of ETH price)
634      * @param _oracle ETH price oracle where we get actual exchange rate
635      */
636     function setOracle(PriceOracle _oracle) public onlyAdmin {
637         require(oracle.priceUSDcETH() > 0);
638         oracle = _oracle;
639         OracleChanged(oracle);
640     }
641 
642     /**
643      * @dev Checks if dates overlap with existing phases of the contract.
644      * @param _startDate  Start date of the phase
645      * @param _endDate    End date of the phase
646      * @return true if provided dates valid
647      */
648     function validatePhaseDates(uint256 _startDate, uint256 _endDate) view public returns (bool) {
649         if (_endDate <= _startDate) {
650             return false;
651         }
652         for (uint i = 0; i < phases.length; i++) {
653             if (_startDate >= phases[i].startDate && _startDate <= phases[i].endDate) {
654                 return false;
655             }
656             if (_endDate >= phases[i].startDate && _endDate <= phases[i].endDate) {
657                 return false;
658             }
659         }
660         return true;
661     }
662 
663     /**
664      * @dev Adds a new phase
665      * @param _startDate  Start date of the phase
666      * @param _endDate    End date of the phase
667      * @param _priceUSDcDNM  Price USD cents per token
668      * @param _tokensCap     Maximum allowed emission at the phase
669      */
670     function addPhase(uint256 _startDate, uint256 _endDate, uint256 _priceUSDcDNM, uint256 _tokensCap) public onlyAdmin {
671         require(validatePhaseDates(_startDate, _endDate));
672         require(_priceUSDcDNM > 0);
673         require(_tokensCap > 0);
674         phases.push(Phase(_startDate, _endDate, _priceUSDcDNM, 0, _tokensCap));
675         uint256 index = phases.length - 1;
676         PhaseAdded(msg.sender, index, _startDate, _endDate, _priceUSDcDNM, _tokensCap);
677     }
678 
679     /**
680      * @dev Delete phase by its index
681      * @param index Index of the phase
682      */
683     function delPhase(uint256 index) public onlyAdmin {
684         if (index >= phases.length) return;
685 
686         for (uint i = index; i<phases.length-1; i++){
687             phases[i] = phases[i+1];
688         }
689         phases.length--;
690         PhaseDeleted(msg.sender, index);
691     }
692 
693     /**
694      * @dev Return current phase index
695      * @return current phase id
696      */
697     function getCurrentPhaseIndex() view public returns (uint256) {
698         for (uint i = 0; i < phases.length; i++) {
699             if (phases[i].startDate <= now && now <= phases[i].endDate) {
700                 return i;
701             }
702         }
703         revert();
704     }
705 
706     /**
707      * @dev Set new wallet to collect ethers
708      * @param _newWallet EOA or the contract adderess of the new receiver
709      */
710     function setWallet(address _newWallet) onlyAdmin public {
711         require(_newWallet != address(0));
712         wallet = _newWallet;
713         WalletChanged(_newWallet);
714     }
715 }