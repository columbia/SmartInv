1 pragma solidity ^0.4.23;
2 
3 // From OpenZeppelin
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     emit OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 
39 // from Open-Zeppelin
40 library SafeMath {
41 
42   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     if (a == 0) {
44       return 0;
45     }
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     // uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return a / b;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) public view returns (uint256);
83   function transferFrom(address from, address to, uint256 value) public returns (bool);
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic, Ownable {
93   using SafeMath for uint256;
94   mapping(address => uint256) balances;
95   // 1 denied / 0 allow
96   mapping(address => uint8) permissionsList;
97   
98   function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{
99     permissionsList[_address] = _sign; 
100   }
101   function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){
102     return permissionsList[_address]; 
103   }  
104   uint256 totalSupply_;
105 
106   /**
107   * @dev total number of tokens in existence
108   */
109   function totalSupply() public view returns (uint256) {
110     return totalSupply_;
111   }
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(permissionsList[msg.sender] == 0);
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     emit Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(permissionsList[msg.sender] == 0);
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     emit Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222     uint oldValue = allowed[msg.sender][_spender];
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232 }
233 
234 
235 /**
236  * @title Pausable
237  * @dev Base contract which allows children to implement an emergency stop mechanism.
238  */
239 contract Pausable is Ownable {
240   event Pause();
241   event Unpause();
242 
243   bool public paused = false;
244 
245 
246   /**
247    * @dev Modifier to make a function callable only when the contract is not paused.
248    */
249   modifier whenNotPaused() {
250     require(!paused);
251     _;
252   }
253 
254   /**
255    * @dev Modifier to make a function callable only when the contract is paused.
256    */
257   modifier whenPaused() {
258     require(paused);
259     _;
260   }
261 
262   /**
263    * @dev called by the owner to pause, triggers stopped state
264    */
265   function pause() onlyOwner whenNotPaused public {
266     paused = true;
267     emit Pause();
268   }
269 
270   /**
271    * @dev called by the owner to unpause, returns to normal state
272    */
273   function unpause() onlyOwner whenPaused public {
274     paused = false;
275     emit Unpause();
276   }
277 }
278 
279 /**
280  * @title Pausable token
281  * @dev StandardToken modified with pausable transfers.
282  **/
283 contract PausableToken is StandardToken, Pausable {
284 
285   function transfer(
286     address _to,
287     uint256 _value
288   )
289     public
290     whenNotPaused
291     returns (bool)
292   {
293     return super.transfer(_to, _value);
294   }
295 
296   function transferFrom(
297     address _from,
298     address _to,
299     uint256 _value
300   )
301     public
302     whenNotPaused
303     returns (bool)
304   {
305     return super.transferFrom(_from, _to, _value);
306   }
307 
308   function approve(
309     address _spender,
310     uint256 _value
311   )
312     public
313     whenNotPaused
314     returns (bool)
315   {
316     return super.approve(_spender, _value);
317   }
318 
319   function increaseApproval(
320     address _spender,
321     uint _addedValue
322   )
323     public
324     whenNotPaused
325     returns (bool success)
326   {
327     return super.increaseApproval(_spender, _addedValue);
328   }
329 
330   function decreaseApproval(
331     address _spender,
332     uint _subtractedValue
333   )
334     public
335     whenNotPaused
336     returns (bool success)
337   {
338     return super.decreaseApproval(_spender, _subtractedValue);
339   }
340 }
341 
342 /**
343  * @title Mintable token
344  * @dev Simple ERC20 Token example, with mintable token creation
345  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
346  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
347  */
348 contract MintableToken is PausableToken {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   /**
361    * @dev Function to mint tokens
362    * @param _to The address that will receive the minted tokens.
363    * @param _amount The amount of tokens to mint.
364    * @return A boolean that indicates if the operation was successful.
365    */
366   function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
367     totalSupply_ = totalSupply_.add(_amount);
368     balances[_to] = balances[_to].add(_amount);
369     emit Mint(_to, _amount);
370     emit Transfer(address(0), _to, _amount);
371     return true;
372   }
373 
374   /**
375    * @dev Function to stop minting new tokens.
376    * @return True if the operation was successful.
377    */
378   function finishMinting() onlyOwner canMint public returns (bool) {
379     mintingFinished = true;
380     emit MintFinished();
381     return true;
382   }
383 }
384 contract BurnableByOwner is BasicToken {
385 
386   event Burn(address indexed burner, uint256 value);
387   function burn(address _address, uint256 _value) public onlyOwner{
388     require(_value <= balances[_address]);
389     // no need to require value <= totalSupply, since that would imply the
390     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
391 
392     address burner = _address;
393     balances[burner] = balances[burner].sub(_value);
394     totalSupply_ = totalSupply_.sub(_value);
395     emit Burn(burner, _value);
396     emit Transfer(burner, address(0), _value);
397   }
398 }
399 
400 contract TRND is Ownable, MintableToken, BurnableByOwner {
401   using SafeMath for uint256;    
402   string public constant name = "Trends";
403   string public constant symbol = "TRND";
404   uint32 public constant decimals = 18;
405   
406   address public addressPrivateSale;
407   address public addressAirdrop;
408   address public addressFoundersShare;
409   address public addressPartnershipsAndExchanges;
410 
411   uint256 public summPrivateSale;
412   uint256 public summAirdrop;
413   uint256 public summFoundersShare;
414   uint256 public summPartnershipsAndExchanges;
415  // uint256 public totalSupply;
416 
417   function TRND() public {
418     addressPrivateSale   = 0xAfB042EE51FE904F67935222744628e1Ce3F6584;
419     addressFoundersShare = 0x6E3F6b1cB72B4C315d0Ae719aACbE8436638b134;
420     addressPartnershipsAndExchanges  = 0xedc57Ed34370139E9f8144C7cf3D0374fa1f0eCf; 
421     addressAirdrop       = 0xA1f99816B7DD6913bF8BDe68d71A1a3a6A47513B;
422 	
423     summPrivateSale   = 5000000 * (10 ** uint256(decimals)); 
424     summFoundersShare = 5000000 * (10 ** uint256(decimals));  
425     summPartnershipsAndExchanges  = 7500000 * (10 ** uint256(decimals));  		    
426     summAirdrop       = 2500000 * (10 ** uint256(decimals));  
427     // Founders and supporters initial Allocations
428     mint(addressPrivateSale, summPrivateSale);
429     mint(addressAirdrop, summAirdrop);
430     mint(addressFoundersShare, summFoundersShare);
431     mint(addressPartnershipsAndExchanges, summPartnershipsAndExchanges);
432   }
433 }
434 
435 /**
436  * @title Crowdsale
437  * @dev Crowdsale is a base contract for managing a token crowdsale.
438  * Crowdsales have a start and end timestamps, where Contributors can make
439  * token Contributions and the crowdsale will assign them tokens based
440  * on a token per ETH rate. Funds collected are forwarded to a wallet
441  * as they arrive. The contract requires a MintableToken that will be
442  * minted as contributions arrive, note that the crowdsale contract
443  * must be owner of the token in order to be able to mint it.
444  */
445 contract Crowdsale is Ownable {
446   using SafeMath for uint256;
447   // soft cap
448   uint256 softcap;
449   // hard cap
450   uint256 hardcapPreICO; 
451   uint256 hardcapMainSale;  
452   TRND public token;
453   // balances for softcap
454   mapping(address => uint) public balances;
455 
456   // start and end timestamps where investments are allowed (both inclusive)
457   // start
458   uint256 public startIcoPreICO;  
459   uint256 public startIcoPreICO2ndRound;  
460   uint256 public startIcoMainSale;  
461   // end 
462   uint256 public endIcoPreICO; 
463   uint256 public endIcoMainSale;   
464 
465   //token distribution
466   uint256 public totalSoldTokens;
467   uint256 public minPurchasePreICO;     
468   
469   // how many token units a Contributor gets per wei
470   uint256 public rateIcoPreICO;
471   uint256 public rateIcoMainSale;
472 
473   //Unconfirmed sum
474   uint256 public unconfirmedSum;
475   mapping(address => uint) public unconfirmedSumAddr;
476 
477   // address where funds are collected
478   address public wallet;
479   
480   bool isTesting;
481   
482 /**
483 * event for token Procurement logging
484 * @param contributor who Pledged for the tokens
485 * @param beneficiary who got the tokens
486 * @param value weis Contributed for Procurement
487 * @param amount amount of tokens Procured
488 */
489   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
490   
491   function Crowdsale() public {
492     //isTesting = _isTesting;
493     token = createTokenContract();
494     //soft cap in tokens
495     softcap            = 20000000 * 1 ether; 
496     hardcapPreICO      =  5000000 * 1 ether; 
497     hardcapMainSale    = 75000000 * 1 ether; 
498 	
499     //min Purchase in wei = 0.1 ETH
500     minPurchasePreICO      = 100000000000000000;
501     
502     // start and end timestamps where investments are allowed
503     startIcoPreICO   = 1530435600;        // 07/01/2018 @ 9:00am (UTC)
504     startIcoPreICO2ndRound = 1531731600;  // 07/16/2018 @ 9:00am (UTC)
505     endIcoPreICO     = 1533027600;        // 07/31/2018 @ 9:00am (UTC)
506     startIcoMainSale = 1534323600;        // 08/15/2018 @ 9:00am (UTC)
507     endIcoMainSale   = 1538557200;        // 10/03/2018 @ 9:00am (UTC)
508 
509     //rate; 0.1875$ for ETH = 550$
510     rateIcoPreICO = 2933;
511     //rate; 0.25$ for ETH = 550$
512     rateIcoMainSale = 2200;
513 
514     // address where funds are collected
515     wallet = 0xca5EdAE100d4D262DC3Ec2dE96FD9943Ea659d04;
516   }
517 
518 
519 // for testing
520   function contractBalanceOf(address _owner) public view returns (uint256) {
521     return balances[_owner];
522   }
523 
524 // for testing
525   function tokenBalanceOf(address _owner) public view returns (uint256) {
526     return token.balanceOf(_owner);
527   }
528 
529   function setStartIcoPreICO(uint256 _startIcoPreICO) public onlyOwner  { 
530     // Enforce consistency of dates
531     require(_startIcoPreICO < endIcoPreICO);
532     // Once Pre-ICO has started, none of the dates can be moved anymore.
533     require(now < startIcoPreICO); // removed so this can be tested
534 	  startIcoPreICO   = _startIcoPreICO;
535   }
536 
537   function setStartIcoPreICO2ndRound(uint256 _startIcoPreICO2ndRound) public onlyOwner  { 
538     // Enforce consistency of dates
539     require(_startIcoPreICO2ndRound > startIcoPreICO && _startIcoPreICO2ndRound < endIcoPreICO);
540     // Once Pre-ICO has started, none of the dates can be moved anymore.
541     require(now < startIcoPreICO);
542 	  startIcoPreICO2ndRound   = _startIcoPreICO2ndRound;
543   }
544 
545   function setEndIcoPreICO(uint256 _endIcoPreICO) public onlyOwner  {     
546 	// Enforce consistency of dates
547     require(startIcoPreICO < _endIcoPreICO && _endIcoPreICO < startIcoMainSale);
548     // Once Pre-ICO has started, none of the dates can be moved anymore.
549     require(now < startIcoPreICO);
550 	  endIcoPreICO   = _endIcoPreICO;
551   }
552   
553   function setStartIcoMainICO(uint256 _startIcoMainSale) public onlyOwner  { 
554     // Enforce consistency of dates
555     require(endIcoPreICO < _startIcoMainSale && _startIcoMainSale < endIcoMainSale);
556     // Once Pre-ICO has started, none of the dates can be moved anymore.    
557     require(now < startIcoPreICO);
558 	  startIcoMainSale   = _startIcoMainSale;
559   }
560   
561   function setEndIcoMainICO(uint256 _endIcoMainSale) public onlyOwner  { 
562     // Enforce consistency of dates
563     require(startIcoMainSale < _endIcoMainSale);
564     // Once Pre-ICO has started, none of the dates can be moved anymore.
565     require(now < startIcoPreICO);
566 	  endIcoMainSale   = _endIcoMainSale;
567   }
568   
569   // set all the dates
570   function setIcoDates(
571                   uint256 _startIcoPreICO,
572                   uint256 _startIcoPreICO2ndRound,
573                   uint256 _endIcoPreICO,
574                   uint256 _startIcoMainSale,
575                   uint256 _endIcoMainSale
576     ) public onlyOwner  { 
577     // Enforce consistency of dates
578     require(_startIcoPreICO < _startIcoPreICO2ndRound);
579     require(_startIcoPreICO2ndRound < _endIcoPreICO);
580     require(_endIcoPreICO <= _startIcoMainSale);
581     require(_startIcoMainSale < _endIcoMainSale);
582     // Once Pre-ICO has started, none of the dates can be moved anymore.
583     require(now < startIcoPreICO); 
584 
585 	  startIcoPreICO   = _startIcoPreICO;
586 	  startIcoPreICO2ndRound = _startIcoPreICO2ndRound;
587     endIcoPreICO = _endIcoPreICO;
588     startIcoMainSale = _startIcoMainSale;
589 	  endIcoMainSale = _endIcoMainSale;
590   }
591   function setRateIcoPreICO(uint256 _rateIcoPreICO) public onlyOwner  {
592     rateIcoPreICO = _rateIcoPreICO;
593   }   
594   
595   function setRateIcoMainSale(uint _rateIcoMainSale) public onlyOwner  {
596     rateIcoMainSale = _rateIcoMainSale;
597   }
598        
599   // fallback function can be used to Procure tokens
600   function () external payable {
601     procureTokens(msg.sender);
602   }
603   
604   function createTokenContract() internal returns (TRND) {
605     return new TRND();
606   }
607   
608   function getRateIcoWithBonus() public view returns (uint256) {
609     return getRateIcoWithBonusByDate(now);
610   }    
611 
612   // testable method
613   function getRateIcoWithBonusByDate(uint256 _date) public view returns (uint256) {
614     uint256 bonus;
615 	  uint256 rateICO;
616     //icoPreICO   
617     if (_date >= startIcoPreICO && _date < endIcoPreICO){
618       rateICO = rateIcoPreICO;
619     }  
620 
621     //icoMainSale   
622     if (_date >= startIcoMainSale  && _date < endIcoMainSale){
623       rateICO = rateIcoMainSale;
624     }  
625 
626     // bonus
627     // Note: Multiplying percentages with 10, later dividing by 1000 instead of 100
628     // This deals with our 0.2% daily decrease. 
629     if (_date >= startIcoPreICO && _date < startIcoPreICO2ndRound){
630       bonus = 300; // 30% * 10
631     } else if (_date >= startIcoPreICO2ndRound && _date < endIcoPreICO){
632       bonus = 200; // 20% * 10
633     } else if (_date >= startIcoMainSale) {
634       // note: 86400 seconds in a day, decrease by 0.2% daily
635       uint256 daysSinceMainIcoStarted = (_date - startIcoMainSale) / 86400;
636       bonus = 100 - (2 * daysSinceMainIcoStarted); // 10% - 0.2 per day * 10
637       if (bonus < 0) { // safety - all the dates can be changed
638         bonus = 0;
639       }
640     }
641 
642     return rateICO + rateICO.mul(bonus).div(1000);
643   }    
644 
645   // low level token Pledge function
646   function procureTokens(address beneficiary) public payable {
647     uint256 tokens;
648     uint256 weiAmount = msg.value;
649     uint256 backAmount;
650     uint256 rate;
651     uint hardCap;
652     require(beneficiary != address(0));
653     rate = getRateIcoWithBonus();
654     //icoPreICO   
655     hardCap = hardcapPreICO;
656     if (now >= startIcoPreICO && now < endIcoPreICO && totalSoldTokens < hardCap){
657 	    require(weiAmount >= minPurchasePreICO);
658       tokens = weiAmount.mul(rate);
659       if (hardCap.sub(totalSoldTokens) < tokens){
660         tokens = hardCap.sub(totalSoldTokens); 
661         weiAmount = tokens.div(rate);
662         backAmount = msg.value.sub(weiAmount);
663       }
664     }  
665     //icoMainSale  
666     hardCap = hardcapMainSale.add(hardcapPreICO);
667     if (now >= startIcoMainSale  && now < endIcoMainSale  && totalSoldTokens < hardCap){
668       tokens = weiAmount.mul(rate);
669       if (hardCap.sub(totalSoldTokens) < tokens){
670         tokens = hardCap.sub(totalSoldTokens); 
671         weiAmount = tokens.div(rate);
672         backAmount = msg.value.sub(weiAmount);
673       }
674     }         
675     require(tokens > 0);
676     totalSoldTokens = totalSoldTokens.add(tokens);
677     balances[msg.sender] = balances[msg.sender].add(weiAmount);
678     token.mint(msg.sender, tokens);
679 	  unconfirmedSum = unconfirmedSum.add(tokens);
680 	  unconfirmedSumAddr[msg.sender] = unconfirmedSumAddr[msg.sender].add(tokens);
681 	  token.SetPermissionsList(beneficiary, 1);
682     if (backAmount > 0){
683       msg.sender.transfer(backAmount);    
684     }
685     emit TokenProcurement(msg.sender, beneficiary, weiAmount, tokens);
686   }
687 
688   function refund() public{
689     require(totalSoldTokens.sub(unconfirmedSum) < softcap && now > endIcoMainSale);
690     require(balances[msg.sender] > 0);
691     uint value = balances[msg.sender];
692     balances[msg.sender] = 0;
693     msg.sender.transfer(value);
694   }
695   
696   function transferEthToMultisig() public onlyOwner {
697     address _this = this;
698     // during main sale, all funds are protected by soft cap, all funds will be restored if softcap is not hit
699     require(now < startIcoMainSale || (totalSoldTokens.sub(unconfirmedSum) >= softcap && now > endIcoMainSale));  
700     wallet.transfer(_this.balance);
701   } 
702   
703   function refundUnconfirmed() public{
704     // you can claim a refund 24h after main sale ended
705     require(now > endIcoMainSale + 24*60*60);
706     require(balances[msg.sender] > 0);
707     require(token.GetPermissionsList(msg.sender) == 1);
708     uint value = balances[msg.sender];
709     balances[msg.sender] = 0;
710     msg.sender.transfer(value);
711    // token.burn(msg.sender, token.balanceOf(msg.sender));
712     uint uvalue = unconfirmedSumAddr[msg.sender];
713     unconfirmedSumAddr[msg.sender] = 0;
714     token.burn(msg.sender, uvalue );
715    // totalICO = totalICO.sub(token.balanceOf(msg.sender));    
716   } 
717   
718   function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{
719       uint8 sign;
720       sign = token.GetPermissionsList(_address);
721       token.SetPermissionsList(_address, _sign);
722       if (_sign == 0){
723           if (sign != _sign){  
724 			      unconfirmedSum = unconfirmedSum.sub(unconfirmedSumAddr[_address]);
725 			      unconfirmedSumAddr[_address] = 0;
726           }
727       }
728    }
729    
730    function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){
731      return token.GetPermissionsList(_address); 
732    }   
733    
734    function pause() onlyOwner public {
735      token.pause();
736    }
737 
738    function unpause() onlyOwner public {
739      token.unpause();
740    }
741     
742 }