1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address who) external view returns (uint256);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function transfer(address to, uint256 value) external returns (bool);
16 
17     function approve(address spender, uint256 value) external returns (bool);
18 
19     function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37      * account.
38      */
39     constructor () internal {
40         _owner = msg.sender;
41         emit OwnershipTransferred(address(0), _owner);
42     }
43 
44     /**
45      * @return the address of the owner.
46      */
47     function owner() public view returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(isOwner());
56         _;
57     }
58 
59     /**
60      * @return true if `msg.sender` is the owner of the contract.
61      */
62     function isOwner() public view returns (bool) {
63         return msg.sender == _owner;
64     }
65 
66     /**
67      * @dev Allows the current owner to relinquish control of the contract.
68      * @notice Renouncing to ownership will leave the contract without an owner.
69      * It will not be possible to call the functions with the `onlyOwner`
70      * modifier anymore.
71      */
72     function renounceOwnership() public onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers control of the contract to a newOwner.
87      * @param newOwner The address to transfer ownership to.
88      */
89     function _transferOwnership(address newOwner) internal {
90         require(newOwner != address(0));
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that revert on error
98  */
99 library SafeMath {
100     /**
101     * @dev Multiplies two numbers, reverts on overflow.
102     */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b);
113 
114         return c;
115     }
116 
117     /**
118     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
119     */
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         // Solidity only automatically asserts when dividing by 0
122         require(b > 0);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
131     */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b <= a);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140     * @dev Adds two numbers, reverts on overflow.
141     */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a);
145 
146         return c;
147     }
148 
149     /**
150     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
151     * reverts when dividing by zero.
152     */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         require(b != 0);
155         return a % b;
156     }
157 }
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
164  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract ERC20 is IERC20 {
167     using SafeMath for uint256;
168 
169     mapping (address => uint256) private _balances;
170 
171     mapping (address => mapping (address => uint256)) private _allowed;
172 
173     uint256 private _totalSupply;
174 
175     /**
176     * @dev Total number of tokens in existence
177     */
178     function totalSupply() public view returns (uint256) {
179         return _totalSupply;
180     }
181 
182     /**
183     * @dev Gets the balance of the specified address.
184     * @param owner The address to query the balance of.
185     * @return An uint256 representing the amount owned by the passed address.
186     */
187     function balanceOf(address owner) public view returns (uint256) {
188         return _balances[owner];
189     }
190 
191     /**
192      * @dev Function to check the amount of tokens that an owner allowed to a spender.
193      * @param owner address The address which owns the funds.
194      * @param spender address The address which will spend the funds.
195      * @return A uint256 specifying the amount of tokens still available for the spender.
196      */
197     function allowance(address owner, address spender) public view returns (uint256) {
198         return _allowed[owner][spender];
199     }
200 
201     /**
202     * @dev Transfer token for a specified address
203     * @param to The address to transfer to.
204     * @param value The amount to be transferred.
205     */
206     function transfer(address to, uint256 value) public returns (bool) {
207         _transfer(msg.sender, to, value);
208         return true;
209     }
210 
211     /**
212      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213      * Beware that changing an allowance with this method brings the risk that someone may use both the old
214      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
215      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
216      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217      * @param spender The address which will spend the funds.
218      * @param value The amount of tokens to be spent.
219      */
220     function approve(address spender, uint256 value) public returns (bool) {
221         require(spender != address(0));
222 
223         _allowed[msg.sender][spender] = value;
224         emit Approval(msg.sender, spender, value);
225         return true;
226     }
227 
228     /**
229      * @dev Transfer tokens from one address to another
230      * @param from address The address which you want to send tokens from
231      * @param to address The address which you want to transfer to
232      * @param value uint256 the amount of tokens to be transferred
233      */
234     function transferFrom(address from, address to, uint256 value) public returns (bool) {
235         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
236         _transfer(from, to, value);
237         return true;
238     }
239 
240     /**
241      * @dev Increase the amount of tokens that an owner allowed to a spender.
242      * approve should be called when allowed_[_spender] == 0. To increment
243      * allowed value is better to use this function to avoid 2 calls (and wait until
244      * the first transaction is mined)
245      * From MonolithDAO Token.sol
246      * @param spender The address which will spend the funds.
247      * @param addedValue The amount of tokens to increase the allowance by.
248      */
249     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
250         require(spender != address(0));
251 
252         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
253         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
254         return true;
255     }
256 
257     /**
258      * @dev Decrease the amount of tokens that an owner allowed to a spender.
259      * approve should be called when allowed_[_spender] == 0. To decrement
260      * allowed value is better to use this function to avoid 2 calls (and wait until
261      * the first transaction is mined)
262      * From MonolithDAO Token.sol
263      * @param spender The address which will spend the funds.
264      * @param subtractedValue The amount of tokens to decrease the allowance by.
265      */
266     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
267         require(spender != address(0));
268 
269         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
270         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
271         return true;
272     }
273 
274     /**
275     * @dev Transfer token for a specified addresses
276     * @param from The address to transfer from.
277     * @param to The address to transfer to.
278     * @param value The amount to be transferred.
279     */
280     function _transfer(address from, address to, uint256 value) internal {
281         require(to != address(0));
282 
283         _balances[from] = _balances[from].sub(value);
284         _balances[to] = _balances[to].add(value);
285         emit Transfer(from, to, value);
286     }
287 
288     /**
289      * @dev Internal function that mints an amount of the token and assigns it to
290      * an account. This encapsulates the modification of balances such that the
291      * proper events are emitted.
292      * @param account The account that will receive the created tokens.
293      * @param value The amount that will be created.
294      */
295     function _mint(address account, uint256 value) internal {
296         require(account != address(0));
297 
298         _totalSupply = _totalSupply.add(value);
299         _balances[account] = _balances[account].add(value);
300         emit Transfer(address(0), account, value);
301     }
302 
303     /**
304      * @dev Internal function that burns an amount of the token of a given
305      * account.
306      * @param account The account whose tokens will be burnt.
307      * @param value The amount that will be burnt.
308      */
309     function _burn(address account, uint256 value) internal {
310         require(account != address(0));
311 
312         _totalSupply = _totalSupply.sub(value);
313         _balances[account] = _balances[account].sub(value);
314         emit Transfer(account, address(0), value);
315     }
316 
317     /**
318      * @dev Internal function that burns an amount of the token of a given
319      * account, deducting from the sender's allowance for said account. Uses the
320      * internal burn function.
321      * @param account The account whose tokens will be burnt.
322      * @param value The amount that will be burnt.
323      */
324     function _burnFrom(address account, uint256 value) internal {
325         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
326         // this function needs to emit an event with the updated approval.
327         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
328         _burn(account, value);
329     }
330 }
331 
332 
333 /**
334  * @title ERC20Detailed token
335  * @dev The decimals are only for visualization purposes.
336  * All the operations are done using the smallest and indivisible token unit,
337  * just as on Ethereum all the operations are done in wei.
338  */
339 contract ERC20Detailed is IERC20 {
340     string private _name;
341     string private _symbol;
342     uint8 private _decimals;
343 
344     constructor (string name, string symbol, uint8 decimals) public {
345         _name = name;
346         _symbol = symbol;
347         _decimals = decimals;
348     }
349 
350     /**
351      * @return the name of the token.
352      */
353     function name() public view returns (string) {
354         return _name;
355     }
356 
357     /**
358      * @return the symbol of the token.
359      */
360     function symbol() public view returns (string) {
361         return _symbol;
362     }
363 
364     /**
365      * @return the number of decimals of the token.
366      */
367     function decimals() public view returns (uint8) {
368         return _decimals;
369     }
370 }
371 
372 /**
373  * @title Roles
374  * @dev Library for managing addresses assigned to a Role.
375  */
376 library Roles {
377     struct Role {
378         mapping (address => bool) bearer;
379     }
380 
381     /**
382      * @dev give an account access to this role
383      */
384     function add(Role storage role, address account) internal {
385         require(account != address(0));
386         require(!has(role, account));
387 
388         role.bearer[account] = true;
389     }
390 
391     /**
392      * @dev remove an account's access to this role
393      */
394     function remove(Role storage role, address account) internal {
395         require(account != address(0));
396         require(has(role, account));
397 
398         role.bearer[account] = false;
399     }
400 
401     /**
402      * @dev check if an account has this role
403      * @return bool
404      */
405     function has(Role storage role, address account) internal view returns (bool) {
406         require(account != address(0));
407         return role.bearer[account];
408     }
409 }
410 
411 contract PauserRole {
412     using Roles for Roles.Role;
413 
414     event PauserAdded(address indexed account);
415     event PauserRemoved(address indexed account);
416 
417     Roles.Role private _pausers;
418 
419     constructor () internal {
420         _addPauser(msg.sender);
421     }
422 
423     modifier onlyPauser() {
424         require(isPauser(msg.sender));
425         _;
426     }
427 
428     function isPauser(address account) public view returns (bool) {
429         return _pausers.has(account);
430     }
431 
432     function addPauser(address account) public onlyPauser {
433         _addPauser(account);
434     }
435 
436     function renouncePauser() public {
437         _removePauser(msg.sender);
438     }
439 
440     function _addPauser(address account) internal {
441         _pausers.add(account);
442         emit PauserAdded(account);
443     }
444 
445     function _removePauser(address account) internal {
446         _pausers.remove(account);
447         emit PauserRemoved(account);
448     }
449 }
450 
451 /**
452  * @title Pausable
453  * @dev Base contract which allows children to implement an emergency stop mechanism.
454  */
455 contract Pausable is PauserRole {
456     event Paused(address account);
457     event Unpaused(address account);
458 
459     bool private _paused;
460 
461     constructor () internal {
462         _paused = false;
463     }
464 
465     /**
466      * @return true if the contract is paused, false otherwise.
467      */
468     function paused() public view returns (bool) {
469         return _paused;
470     }
471 
472     /**
473      * @dev Modifier to make a function callable only when the contract is not paused.
474      */
475     modifier whenNotPaused() {
476         require(!_paused);
477         _;
478     }
479 
480     /**
481      * @dev Modifier to make a function callable only when the contract is paused.
482      */
483     modifier whenPaused() {
484         require(_paused);
485         _;
486     }
487 
488     /**
489      * @dev called by the owner to pause, triggers stopped state
490      */
491     function pause() public onlyPauser whenNotPaused {
492         _paused = true;
493         emit Paused(msg.sender);
494     }
495 
496     /**
497      * @dev called by the owner to unpause, returns to normal state
498      */
499     function unpause() public onlyPauser whenPaused {
500         _paused = false;
501         emit Unpaused(msg.sender);
502     }
503 }
504 
505 /**
506  * @title Pausable token
507  * @dev ERC20 modified with pausable transfers.
508  **/
509 contract ERC20Pausable is ERC20, Pausable {
510     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
511         return super.transfer(to, value);
512     }
513 
514     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
515         return super.transferFrom(from, to, value);
516     }
517 
518     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
519         return super.approve(spender, value);
520     }
521 
522     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
523         return super.increaseAllowance(spender, addedValue);
524     }
525 
526     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
527         return super.decreaseAllowance(spender, subtractedValue);
528     }
529 }
530 
531 
532 contract Airtoto is ERC20Pausable, ERC20Detailed, Ownable {
533     using SafeMath for uint256;
534 	uint256 public constant initialSupply = 300000000 * (10 ** uint256(decimals()));
535     uint256 public constant sum_bounties_wallet = initialSupply.mul(10).div(100);
536     address public constant address_bounties_wallet = 0x5E4C4043A5C96FEFc61F6548FcF14Abc5a92654B;
537     uint256 public constant sum_team_wallet = initialSupply.mul(20).div(100);
538     address public constant address_team_wallet = 0xDeFb454cB3771C98144CbfC1359Eb7FE2bDd054B;	
539     uint256 public constant sum_crowdsale = initialSupply.mul(70).div(100);
540 	
541     constructor () public ERC20Detailed("Airtoto", "Att", 18) {
542 		_mint(address_bounties_wallet, sum_bounties_wallet);
543 		_mint(address_team_wallet, sum_team_wallet);
544 		_mint(msg.sender, sum_crowdsale);		
545     }
546 	
547     function transferForICO (address _to, uint256 _value) public onlyOwner{
548         _transfer(msg.sender, _to, _value);
549     }	
550 	 /**
551      * @dev Burns a specific amount of tokens.
552      * @param value The amount of token to be burned.
553      */
554     function burn(uint256 value) public {
555         _burn(msg.sender, value);
556     }
557 }
558 
559 /**
560  * @title Helps contracts guard against reentrancy attacks.
561  * @author Remco Bloemen <remco@2?.com>, Eenae <alexey@mixbytes.io>
562  * @dev If you mark a function `nonReentrant`, you should also
563  * mark it `external`.
564  */
565 contract ReentrancyGuard {
566 
567   /// @dev counter to allow mutex lock with only one SSTORE operation
568   uint256 private _guardCounter;
569 
570   constructor() internal {
571     // The counter starts at one to prevent changing it from zero to a non-zero
572     // value, which is a more expensive operation.
573     _guardCounter = 1;
574   }
575 
576   /**
577    * @dev Prevents a contract from calling itself, directly or indirectly.
578    * Calling a `nonReentrant` function from another `nonReentrant`
579    * function is not supported. It is possible to prevent this from happening
580    * by making the `nonReentrant` function external, and make it call a
581    * `private` function that does the actual work.
582    */
583   modifier nonReentrant() {
584     _guardCounter += 1;
585     uint256 localCounter = _guardCounter;
586     _;
587     require(localCounter == _guardCounter);
588   }
589 }
590 
591 contract Crowdsale is Ownable, ReentrancyGuard {
592 
593   using SafeMath for uint256;  
594   
595   Airtoto public token;
596   //IERC20 public token;
597   
598   //start and end timestamps where investments are allowed (both inclusive)
599   uint256 public   startPreICOStage;
600   uint256 public   endPreICOStage;
601   uint256 public   startICOStage1;
602   uint256 public   endICOStage1;  
603   uint256 public   startICOStage2;
604   uint256 public   endICOStage2; 
605   uint256 public   startICOStage3;
606   uint256 public   endICOStage3;  
607 
608   //balances for softcap
609   mapping(address => uint256) public balances;  
610   //token distribution
611   uint256 public amountOfTokensSold; 
612   uint256 public minimumPayment;  
613   //AirDrop
614   uint256 public valueAirDrop;
615   uint8 public airdropOn;
616   uint8 public referralSystemOn;
617   mapping (address => uint8) public payedAddress; 
618   // rate ETH/USD
619   uint256 public rateETHUSD;    
620   // address where funds are collected
621   address public wallet;
622 
623 /**
624 * event for token Procurement logging
625 * @param contributor who Pledged for the tokens
626 * @param beneficiary who got the tokens
627 * @param value weis Contributed for Procurement
628 * @param amount amount of tokens Procured
629 */
630   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount, address indexed referrer, uint256 amountReferrer);
631 
632   constructor() public {    
633     token = createTokenContract();
634 	// rate ETH - USD
635     rateETHUSD = 10000; //2 decimals
636     // start and end timestamps where investments are allowed
637     // start/end for stage of ICO
638     startPreICOStage  = 1544875200; //Sat, 15 Dec 2018 12:00:00 +0000
639     endPreICOStage    = 1546084800; //Sat, 29 Dec 2018 12:00:00 +0000	 
640     startICOStage1    = 1546084800; //Sat, 29 Dec 2018 12:00:00 +0000
641     endICOStage1      = 1547294400; //Sat, 12 Jan 2019 12:00:00 +0000
642     startICOStage2    = 1547294400; //Sat, 12 Jan 2019 12:00:00 +0000  
643     endICOStage2      = 1550059200; //Wed, 13 Feb 2019 12:00:00 +0000
644     startICOStage3    = 1550059200; //Wed, 13 Feb 2019 12:00:00 +0000 
645     endICOStage3      = 1552564800; //Thu, 14 Mar 2019 12:00:00 +0000	
646 
647     // minimum payment in ETH	
648     minimumPayment = 980000000000000000; // 0.98 ether = ca. 150 USD
649 
650     // valueAirDrop in tokens
651     valueAirDrop = 1 * 1 ether;	
652     // address where funds are collected
653     wallet = 0xfc19e8fD7564A48b82a51d106e6D0E6098032811;
654   }
655   
656   function setMinimumPayment(uint256 _minimumPayment) public onlyOwner{
657     minimumPayment = _minimumPayment;
658   } 
659   function setValueAirDrop(uint256 _valueAirDrop) public onlyOwner{
660     valueAirDrop = _valueAirDrop;
661   } 
662 
663   function setRateIco(uint256 _rateETHUSD) public onlyOwner  {
664     rateETHUSD = _rateETHUSD;
665   }  
666   // fallback function can be used to Procure tokens
667   function () external payable {
668     buyTokens(msg.sender);
669   }
670   
671   function createTokenContract() internal returns (Airtoto) {
672     return new Airtoto();
673   }
674   
675   function getRateTokeUSD() public view returns (uint256) {
676     uint256 rate; //6 decimals
677     if (now >= startPreICOStage && now < endPreICOStage){
678       rate = 100000;    
679     }	
680     if (now >= startICOStage1 && now < endICOStage1){
681       rate = 100000;    
682     } 
683     if (now >= startICOStage2 && now < endICOStage2){
684       rate = 150000;    
685     }    
686     if (now >= startICOStage3 && now < endICOStage3){
687       rate = 200000;    
688     }    	
689     return rate;
690   }
691   
692   function getRateIcoWithBonus() public view returns (uint256) {
693     uint256 bonus;
694     if (now >= startPreICOStage && now < endPreICOStage){
695       bonus = 20;    
696     }
697     if (now >= startICOStage1 && now < endICOStage1){
698       bonus = 15;    
699     }
700     if (now >= startICOStage2 && now < endICOStage2){
701       bonus = 10;    
702     }   
703     if (now >= startICOStage3 && now < endICOStage3){
704       bonus = 5;    
705     }       
706     return rateETHUSD + rateETHUSD.mul(bonus).div(100);
707   }  
708  
709   function bytesToAddress(bytes source) internal pure returns(address) {
710     uint result;
711     uint mul = 1;
712     for(uint i = 20; i > 0; i--) {
713       result += uint8(source[i-1])*mul;
714       mul = mul*256;
715     }
716     return address(result);
717   }
718   function setAirdropOn(uint8 _flag) public onlyOwner{
719     airdropOn = _flag;
720   } 
721   function setReferralSystemOn(uint8 _flag) public onlyOwner{
722     referralSystemOn = _flag;
723   }   
724   function buyTokens(address _beneficiary) public nonReentrant payable {
725     uint256 tokensAmount;
726     uint256 weiAmount = msg.value;
727     uint256 rate;
728 	uint256 referrerTokens;
729 	uint256 restTokensAmount;
730 	uint256 restWeiAmount;
731 	address referrer; 
732     address _this = this;
733     uint256 rateTokenUSD;  
734     require(now >= startPreICOStage);
735     require(now <= endICOStage3);
736 	require(token.balanceOf(_this) > 0);
737     require(_beneficiary != address(0));
738 	
739 	if (weiAmount == 0 && airdropOn == 1){ 
740 	  require(payedAddress[_beneficiary] == 0);
741       payedAddress[_beneficiary] = 1;
742 	  token.transferForICO(_beneficiary, valueAirDrop);
743 	}
744 	else{	
745 	  require(weiAmount >= minimumPayment);
746       rate = getRateIcoWithBonus();
747 	  rateTokenUSD = getRateTokeUSD();
748       tokensAmount = weiAmount.mul(rate).mul(10000).div(rateTokenUSD);
749 	  // referral system
750 	  if(msg.data.length == 20 && referralSystemOn == 1) {
751         referrer = bytesToAddress(bytes(msg.data));
752         require(referrer != msg.sender);
753 	    // add tokensAmount to the referrer
754         referrerTokens = tokensAmount.mul(5).div(100);
755 	    // add tokensAmount to the referral
756 	    tokensAmount = tokensAmount + tokensAmount.mul(5).div(100);
757       }
758 	  // last sale of tokens
759       if (tokensAmount.add(referrerTokens) > token.balanceOf(_this)) {
760 	    restTokensAmount = tokensAmount.add(referrerTokens) - token.balanceOf(_this);
761 	    tokensAmount = token.balanceOf(_this);
762 	    referrerTokens = 0;
763 	    restWeiAmount = restTokensAmount.mul(rateTokenUSD).div(rate).div(10000);
764 	  }
765         amountOfTokensSold = amountOfTokensSold.add(tokensAmount);
766 	    balances[_beneficiary] = balances[_beneficiary].add(msg.value);
767 	  if (referrerTokens != 0){
768         token.transferForICO(referrer, referrerTokens);	  
769 	  }
770 	  if (restWeiAmount != 0){
771 	    _beneficiary.transfer(restWeiAmount);
772 		weiAmount = weiAmount.sub(restWeiAmount);
773 	  }
774       token.transferForICO(_beneficiary, tokensAmount);
775 	  wallet.transfer(weiAmount);
776       emit TokenProcurement(msg.sender, _beneficiary, weiAmount, tokensAmount, referrer, referrerTokens);
777 	}
778   }
779   function manualSendTokens(address _to, uint256 _value) public onlyOwner{
780     address _this = this;
781     require(_value > 0);
782 	require(_value <= token.balanceOf(_this));
783     require(_to != address(0));
784     amountOfTokensSold = amountOfTokensSold.add(_value);
785     token.transferForICO(_to, _value);
786 	emit TokenProcurement(msg.sender, _to, 0, _value, address(0), 0);
787   } 
788   function pause() public onlyOwner{
789     token.pause();
790   }
791   function unpause() public onlyOwner{
792     token.unpause();
793   }
794  
795 }