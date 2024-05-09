1 pragma solidity 0.4.21;
2 
3 /**
4  * @title Cryptonia Poker Chips token and crowdsale contracts
5  * @author Kirill Varlamov (@ongrid), OnGridSystems
6  * @dev https://github.com/OnGridSystems/CryptoniaPokerContracts
7  */
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Roles
57  * @author Francisco Giordano (@frangio)
58  * @dev Library for managing addresses assigned to a Role.
59  *      See RBAC.sol for example usage.
60  */
61 library Roles {
62   struct Role {
63     mapping (address => bool) bearer;
64   }
65 
66   /**
67    * @dev give an address access to this role
68    */
69   function add(Role storage role, address addr)
70     internal
71   {
72     role.bearer[addr] = true;
73   }
74 
75   /**
76    * @dev remove an address' access to this role
77    */
78   function remove(Role storage role, address addr)
79     internal
80   {
81     role.bearer[addr] = false;
82   }
83 
84   /**
85    * @dev check if an address has this role
86    * // reverts
87    */
88   function check(Role storage role, address addr)
89     view
90     internal
91   {
92     require(has(role, addr));
93   }
94 
95   /**
96    * @dev check if an address has this role
97    * @return bool
98    */
99   function has(Role storage role, address addr)
100     view
101     internal
102     returns (bool)
103   {
104     return role.bearer[addr];
105   }
106 }
107 
108 
109 /**
110  * @title RBAC (Role-Based Access Control)
111  * @author Matt Condon (@Shrugs)
112  * @dev Stores and provides setters and getters for roles and addresses.
113  *      Supports unlimited numbers of roles and addresses.
114  *      See //contracts/mocks/RBACMock.sol for an example of usage.
115  * This RBAC method uses strings to key roles. It may be beneficial
116  *  for you to write your own implementation of this interface using Enums or similar.
117  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
118  *  to avoid typos.
119  */
120 contract RBAC {
121   using Roles for Roles.Role;
122 
123   mapping (string => Roles.Role) private roles;
124 
125   event RoleAdded(address addr, string roleName);
126   event RoleRemoved(address addr, string roleName);
127 
128   /**
129    * A constant role name for indicating admins.
130    */
131   string public constant ROLE_ADMIN = "admin";
132 
133   /**
134    * @dev constructor. Sets msg.sender as admin by default
135    */
136   function RBAC()
137     public
138   {
139     addRole(msg.sender, ROLE_ADMIN);
140   }
141 
142   /**
143    * @dev reverts if addr does not have role
144    * @param addr address
145    * @param roleName the name of the role
146    * // reverts
147    */
148   function checkRole(address addr, string roleName)
149     view
150     public
151   {
152     roles[roleName].check(addr);
153   }
154 
155   /**
156    * @dev determine if addr has role
157    * @param addr address
158    * @param roleName the name of the role
159    * @return bool
160    */
161   function hasRole(address addr, string roleName)
162     view
163     public
164     returns (bool)
165   {
166     return roles[roleName].has(addr);
167   }
168 
169   /**
170    * @dev add a role to an address
171    * @param addr address
172    * @param roleName the name of the role
173    */
174   function adminAddRole(address addr, string roleName)
175     onlyAdmin
176     public
177   {
178     addRole(addr, roleName);
179   }
180 
181   /**
182    * @dev remove a role from an address
183    * @param addr address
184    * @param roleName the name of the role
185    */
186   function adminRemoveRole(address addr, string roleName)
187     onlyAdmin
188     public
189   {
190     removeRole(addr, roleName);
191   }
192 
193   /**
194    * @dev add a role to an address
195    * @param addr address
196    * @param roleName the name of the role
197    */
198   function addRole(address addr, string roleName)
199     internal
200   {
201     roles[roleName].add(addr);
202     emit RoleAdded(addr, roleName);
203   }
204 
205   /**
206    * @dev remove a role from an address
207    * @param addr address
208    * @param roleName the name of the role
209    */
210   function removeRole(address addr, string roleName)
211     internal
212   {
213     roles[roleName].remove(addr);
214     emit RoleRemoved(addr, roleName);
215   }
216 
217   /**
218    * @dev modifier to scope access to a single role (uses msg.sender as addr)
219    * @param roleName the name of the role
220    * // reverts
221    */
222   modifier onlyRole(string roleName)
223   {
224     checkRole(msg.sender, roleName);
225     _;
226   }
227 
228   /**
229    * @dev modifier to scope access to admins
230    * // reverts
231    */
232   modifier onlyAdmin()
233   {
234     checkRole(msg.sender, ROLE_ADMIN);
235     _;
236   }
237 }
238 
239 
240 /**
241  * @title ERC20Basic
242  * @dev Simpler version of ERC20 interface
243  * @dev see https://github.com/ethereum/EIPs/issues/179
244  */
245 contract ERC20Basic {
246   function totalSupply() public view returns (uint256);
247   function balanceOf(address who) public view returns (uint256);
248   function transfer(address to, uint256 value) public returns (bool);
249   event Transfer(address indexed from, address indexed to, uint256 value);
250 }
251 
252 
253 /**
254  * @title ERC20 interface
255  * @dev see https://github.com/ethereum/EIPs/issues/20
256  */
257 contract ERC20 is ERC20Basic {
258   function allowance(address owner, address spender) public view returns (uint256);
259   function transferFrom(address from, address to, uint256 value) public returns (bool);
260   function approve(address spender, uint256 value) public returns (bool);
261   event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 
265 /**
266  * @title Basic token
267  * @dev Basic version of StandardToken, with no allowances.
268  */
269 contract BasicToken is ERC20Basic {
270   using SafeMath for uint256;
271 
272   mapping(address => uint256) balances;
273 
274   uint256 totalSupply_;
275 
276   /**
277   * @dev total number of tokens in existence
278   */
279   function totalSupply() public view returns (uint256) {
280     return totalSupply_;
281   }
282 
283   /**
284   * @dev transfer token for a specified address
285   * @param _to The address to transfer to.
286   * @param _value The amount to be transferred.
287   */
288   function transfer(address _to, uint256 _value) public returns (bool) {
289     require(_to != address(0));
290     require(_value <= balances[msg.sender]);
291 
292     // SafeMath.sub will throw if there is not enough balance.
293     balances[msg.sender] = balances[msg.sender].sub(_value);
294     balances[_to] = balances[_to].add(_value);
295     emit Transfer(msg.sender, _to, _value);
296     return true;
297   }
298 
299   /**
300   * @dev Gets the balance of the specified address.
301   * @param _owner The address to query the the balance of.
302   * @return An uint256 representing the amount owned by the passed address.
303   */
304   function balanceOf(address _owner) public view returns (uint256 balance) {
305     return balances[_owner];
306   }
307 
308 }
309 
310 
311 /**
312  * @title Standard ERC20 token
313  *
314  * @dev Implementation of the basic standard token.
315  * @dev https://github.com/ethereum/EIPs/issues/20
316  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
317  */
318 contract StandardToken is ERC20, BasicToken {
319 
320   mapping (address => mapping (address => uint256)) internal allowed;
321 
322 
323   /**
324    * @dev Transfer tokens from one address to another
325    * @param _from address The address which you want to send tokens from
326    * @param _to address The address which you want to transfer to
327    * @param _value uint256 the amount of tokens to be transferred
328    */
329   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
330     require(_to != address(0));
331     require(_value <= balances[_from]);
332     require(_value <= allowed[_from][msg.sender]);
333 
334     balances[_from] = balances[_from].sub(_value);
335     balances[_to] = balances[_to].add(_value);
336     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
337     emit Transfer(_from, _to, _value);
338     return true;
339   }
340 
341   /**
342    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
343    *
344    * Beware that changing an allowance with this method brings the risk that someone may use both the old
345    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
346    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
347    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
348    * @param _spender The address which will spend the funds.
349    * @param _value The amount of tokens to be spent.
350    */
351   function approve(address _spender, uint256 _value) public returns (bool) {
352     allowed[msg.sender][_spender] = _value;
353     emit Approval(msg.sender, _spender, _value);
354     return true;
355   }
356 
357   /**
358    * @dev Function to check the amount of tokens that an owner allowed to a spender.
359    * @param _owner address The address which owns the funds.
360    * @param _spender address The address which will spend the funds.
361    * @return A uint256 specifying the amount of tokens still available for the spender.
362    */
363   function allowance(address _owner, address _spender) public view returns (uint256) {
364     return allowed[_owner][_spender];
365   }
366 
367   /**
368    * @dev Increase the amount of tokens that an owner allowed to a spender.
369    *
370    * approve should be called when allowed[_spender] == 0. To increment
371    * allowed value is better to use this function to avoid 2 calls (and wait until
372    * the first transaction is mined)
373    * From MonolithDAO Token.sol
374    * @param _spender The address which will spend the funds.
375    * @param _addedValue The amount of tokens to increase the allowance by.
376    */
377   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
378     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
379     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
380     return true;
381   }
382 
383   /**
384    * @dev Decrease the amount of tokens that an owner allowed to a spender.
385    *
386    * approve should be called when allowed[_spender] == 0. To decrement
387    * allowed value is better to use this function to avoid 2 calls (and wait until
388    * the first transaction is mined)
389    * From MonolithDAO Token.sol
390    * @param _spender The address which will spend the funds.
391    * @param _subtractedValue The amount of tokens to decrease the allowance by.
392    */
393   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
394     uint oldValue = allowed[msg.sender][_spender];
395     if (_subtractedValue > oldValue) {
396       allowed[msg.sender][_spender] = 0;
397     } else {
398       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
399     }
400     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
401     return true;
402   }
403 
404 }
405 
406 
407 /**
408  * @title Cryptonia Poker Chips Contract
409  * @author Kirill Varlamov (@ongrid), OnGrid systems
410  * @dev ERC-20 compatible token with zeppelin's RBAC
411  */
412 contract CryptoniaToken is StandardToken, RBAC {
413   string public name = "Cryptonia Poker Chips";
414   string public symbol = "CPC";
415   uint8 public decimals = 2;
416   uint256 public cap = 100000000000;
417   bool public mintingFinished = false;
418   string constant ROLE_MINTER = "minter";
419 
420   event Mint(address indexed to, uint256 amount);
421   event MintFinished();
422   event Burn(address indexed burner, uint256 value);
423 
424   /**
425    * @dev Function to mint tokens
426    * @param _to The address that will receive the minted tokens.
427    * @param _amount The amount of tokens to mint.
428    * @return A boolean that indicates if the operation was successful.
429    */
430   function mint(address _to, uint256 _amount) onlyRole(ROLE_MINTER) public returns (bool) {
431     require(!mintingFinished);
432     require(totalSupply_.add(_amount) <= cap);
433     totalSupply_ = totalSupply_.add(_amount);
434     balances[_to] = balances[_to].add(_amount);
435     emit Mint(_to, _amount);
436     emit Transfer(address(0), _to, _amount);
437     return true;
438   }
439 
440   /**
441    * @dev Function to stop minting new tokens.
442    * @return True if the operation was successful.
443    */
444   function finishMinting() onlyAdmin public returns (bool) {
445     require(!mintingFinished);
446     mintingFinished = true;
447     emit MintFinished();
448     return true;
449   }
450 
451   /**
452    * @dev Burns a specific amount of tokens.
453    * @param _value The amount of token to be burned.
454    */
455   function burn(uint256 _value) public {
456     require(_value <= balances[msg.sender]);
457     // no need to require value <= totalSupply, since that would imply the
458     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
459 
460     address burner = msg.sender;
461     balances[burner] = balances[burner].sub(_value);
462     totalSupply_ = totalSupply_.sub(_value);
463     emit Burn(burner, _value);
464     emit Transfer(burner, address(0), _value);
465   }
466 }
467 
468 
469 /**
470  * @title Crowdsale Contract
471  * @author Kirill Varlamov (@ongrid), OnGrid systems
472  * @dev Crowdsale is a contract for managing a token crowdsale,
473  * allowing investors to purchase tokens with ether.
474  */
475 contract CryptoniaCrowdsale is RBAC {
476   using SafeMath for uint256;
477 
478   struct Phase {
479     uint256 startDate;
480     uint256 endDate;
481     uint256 tokensPerETH;
482     uint256 tokensIssued;
483   }
484 
485   Phase[] public phases;
486 
487   // The token being sold
488   CryptoniaToken public token;
489 
490   // Address where funds get collected
491   address public wallet;
492 
493   // Minimal allowed purchase is 0.1 ETH
494   uint256 public minPurchase = 100000000000000000;
495 
496   // Amount of ETH raised in wei. 1 wei is 10e-18 ETH
497   uint256 public weiRaised;
498 
499   // Amount of tokens issued by this contract
500   uint256 public tokensIssued;
501 
502   /**
503    * Event for token purchase logging
504    * @param purchaser who paid for the tokens
505    * @param beneficiary who got the tokens
506    * @param value weis paid for purchase
507    * @param amount amount of tokens purchased
508    */
509   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
510 
511   /**
512    * @dev Events for contract states changes
513    */
514   event PhaseAdded(address indexed sender, uint256 index, uint256 startDate, uint256 endDate, uint256 tokensPerETH);
515   event PhaseDeleted(address indexed sender, uint256 index);
516   event WalletChanged(address newWallet);
517   event OracleChanged(address newOracle);
518 
519   /**
520    * @param _wallet Address where collected funds will be forwarded to
521    * @param _token  Address of the token being sold
522    */
523   function CryptoniaCrowdsale(address _wallet, CryptoniaToken _token) public {
524     require(_wallet != address(0));
525     require(_token != address(0));
526     wallet = _wallet;
527     token = _token;
528   }
529 
530   /**
531    * @dev fallback function receiving investor's ethers
532    *      It calculates deposit USD value and corresponding token amount,
533    *      runs some checks (if phase cap not exceeded, value and addresses are not null),
534    *      then mints corresponding amount of tokens, increments state variables.
535    *      After tokens issued Ethers get transferred to the wallet.
536    */
537   function() external payable {
538     uint256 weiAmount = msg.value;
539     address beneficiary = msg.sender;
540     uint256 currentPhaseIndex = getCurrentPhaseIndex();
541     uint256 tokens = weiAmount.mul(phases[currentPhaseIndex].tokensPerETH).div(1 ether);
542     require(beneficiary != address(0));
543     require(weiAmount >= minPurchase);
544     weiRaised = weiRaised.add(weiAmount);
545     phases[currentPhaseIndex].tokensIssued = phases[currentPhaseIndex].tokensIssued.add(tokens);
546     tokensIssued = tokensIssued.add(tokens);
547     token.mint(beneficiary, tokens);
548     wallet.transfer(msg.value);
549     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
550   }
551 
552   /**
553    * @dev Checks if dates overlap with existing phases of the contract.
554    * @param _startDate  Start date of the phase
555    * @param _endDate    End date of the phase
556    * @return true if provided dates valid
557    */
558   function validatePhaseDates(uint256 _startDate, uint256 _endDate) view public returns (bool) {
559     if (_endDate <= _startDate) {
560       return false;
561     }
562     for (uint i = 0; i < phases.length; i++) {
563       if (_startDate >= phases[i].startDate && _startDate <= phases[i].endDate) {
564         return false;
565       }
566       if (_endDate >= phases[i].startDate && _endDate <= phases[i].endDate) {
567         return false;
568       }
569     }
570     return true;
571   }
572 
573   /**
574    * @dev Adds a new phase
575    * @param _startDate  Start date of the phase
576    * @param _endDate    End date of the phase
577    * @param _tokensPerETH  amount of tokens per ETH
578    */
579   function addPhase(uint256 _startDate, uint256 _endDate, uint256 _tokensPerETH) public onlyAdmin {
580     require(validatePhaseDates(_startDate, _endDate));
581     require(_tokensPerETH > 0);
582     phases.push(Phase(_startDate, _endDate, _tokensPerETH, 0));
583     uint256 index = phases.length - 1;
584     emit PhaseAdded(msg.sender, index, _startDate, _endDate, _tokensPerETH);
585   }
586 
587   /**
588    * @dev Delete phase by its index
589    * @param index Index of the phase
590    */
591   function delPhase(uint256 index) public onlyAdmin {
592     require (index < phases.length);
593 
594     for (uint i = index; i < phases.length - 1; i++) {
595       phases[i] = phases[i + 1];
596     }
597     phases.length--;
598     emit PhaseDeleted(msg.sender, index);
599   }
600 
601   /**
602    * @dev Return current phase index
603    * @return current phase id
604    */
605   function getCurrentPhaseIndex() view public returns (uint256) {
606     for (uint i = 0; i < phases.length; i++) {
607       if (phases[i].startDate <= now && now <= phases[i].endDate) {
608         return i;
609       }
610     }
611     revert();
612   }
613 
614   /**
615    * @dev Set new wallet to collect ethers
616    * @param _newWallet EOA or the contract adderess of the new receiver
617    */
618   function setWallet(address _newWallet) onlyAdmin public {
619     require(_newWallet != address(0));
620     wallet = _newWallet;
621     emit WalletChanged(_newWallet);
622   }
623 }