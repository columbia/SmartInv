1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances.
117  */
118 contract BasicToken is ERC20Basic, Ownable {
119   using SafeMath for uint256;
120   mapping(address => uint256) balances;
121   // 1 denied / 0 allow
122   mapping(address => uint8) permissionsList;
123   
124   function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{
125     permissionsList[_address] = _sign; 
126   }
127   function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){
128     return permissionsList[_address]; 
129   }  
130   uint256 totalSupply_;
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(permissionsList[msg.sender] == 0);
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     emit Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256) {
160     return balances[_owner];
161   }
162 
163 }
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * @dev https://github.com/ethereum/EIPs/issues/20
170  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
171  */
172 contract StandardToken is ERC20, BasicToken {
173 
174   mapping (address => mapping (address => uint256)) internal allowed;
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(permissionsList[msg.sender] == 0);
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    *
198    * Beware that changing an allowance with this method brings the risk that someone may use both the old
199    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     emit Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(address _owner, address _spender) public view returns (uint256) {
218     return allowed[_owner][_spender];
219   }
220 
221   /**
222    * @dev Increase the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To increment
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _addedValue The amount of tokens to increase the allowance by.
230    */
231   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
232     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To decrement
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _subtractedValue The amount of tokens to decrease the allowance by.
246    */
247   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 
261 /**
262  * @title Pausable
263  * @dev Base contract which allows children to implement an emergency stop mechanism.
264  */
265 contract Pausable is Ownable {
266   event Pause();
267   event Unpause();
268 
269   bool public paused = false;
270 
271 
272   /**
273    * @dev Modifier to make a function callable only when the contract is not paused.
274    */
275   modifier whenNotPaused() {
276     require(!paused);
277     _;
278   }
279 
280   /**
281    * @dev Modifier to make a function callable only when the contract is paused.
282    */
283   modifier whenPaused() {
284     require(paused);
285     _;
286   }
287 
288   /**
289    * @dev called by the owner to pause, triggers stopped state
290    */
291   function pause() onlyOwner whenNotPaused public {
292     paused = true;
293     emit Pause();
294   }
295 
296   /**
297    * @dev called by the owner to unpause, returns to normal state
298    */
299   function unpause() onlyOwner whenPaused public {
300     paused = false;
301     emit Unpause();
302   }
303 }
304 
305 /**
306  * @title Pausable token
307  * @dev StandardToken modified with pausable transfers.
308  **/
309 contract PausableToken is StandardToken, Pausable {
310 
311   function transfer(
312     address _to,
313     uint256 _value
314   )
315     public
316     whenNotPaused
317     returns (bool)
318   {
319     return super.transfer(_to, _value);
320   }
321 
322   function transferFrom(
323     address _from,
324     address _to,
325     uint256 _value
326   )
327     public
328     whenNotPaused
329     returns (bool)
330   {
331     return super.transferFrom(_from, _to, _value);
332   }
333 
334   function approve(
335     address _spender,
336     uint256 _value
337   )
338     public
339     whenNotPaused
340     returns (bool)
341   {
342     return super.approve(_spender, _value);
343   }
344 
345   function increaseApproval(
346     address _spender,
347     uint _addedValue
348   )
349     public
350     whenNotPaused
351     returns (bool success)
352   {
353     return super.increaseApproval(_spender, _addedValue);
354   }
355 
356   function decreaseApproval(
357     address _spender,
358     uint _subtractedValue
359   )
360     public
361     whenNotPaused
362     returns (bool success)
363   {
364     return super.decreaseApproval(_spender, _subtractedValue);
365   }
366 }
367 
368 /**
369  * @title Mintable token
370  * @dev Simple ERC20 Token example, with mintable token creation
371  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
372  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
373  */
374 contract MintableToken is PausableToken {
375   event Mint(address indexed to, uint256 amount);
376   event MintFinished();
377 
378   bool public mintingFinished = false;
379 
380 
381   modifier canMint() {
382     require(!mintingFinished);
383     _;
384   }
385 
386   /**
387    * @dev Function to mint tokens
388    * @param _to The address that will receive the minted tokens.
389    * @param _amount The amount of tokens to mint.
390    * @return A boolean that indicates if the operation was successful.
391    */
392   function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
393     totalSupply_ = totalSupply_.add(_amount);
394     balances[_to] = balances[_to].add(_amount);
395     emit Mint(_to, _amount);
396     emit Transfer(address(0), _to, _amount);
397     return true;
398   }
399 
400   /**
401    * @dev Function to stop minting new tokens.
402    * @return True if the operation was successful.
403    */
404   function finishMinting() onlyOwner canMint public returns (bool) {
405     mintingFinished = true;
406     emit MintFinished();
407     return true;
408   }
409 }
410 contract BurnableByOwner is BasicToken {
411 
412   event Burn(address indexed burner, uint256 value);
413   function burn(address _address, uint256 _value) public onlyOwner{
414     require(_value <= balances[_address]);
415     // no need to require value <= totalSupply, since that would imply the
416     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
417 
418     address burner = _address;
419     balances[burner] = balances[burner].sub(_value);
420     totalSupply_ = totalSupply_.sub(_value);
421     emit Burn(burner, _value);
422     emit Transfer(burner, address(0), _value);
423   }
424 }
425 
426 contract TRND is Ownable, MintableToken, BurnableByOwner {
427   using SafeMath for uint256;    
428   string public constant name = "Trends";
429   string public constant symbol = "TRND";
430   uint32 public constant decimals = 18;
431   
432   address public addressPrivateSale;
433   address public addressAirdrop;
434   address public addressFoundersShare;
435   address public addressPartnershipsAndExchanges;
436 
437   uint256 public summPrivateSale;
438   uint256 public summAirdrop;
439   uint256 public summFoundersShare;
440   uint256 public summPartnershipsAndExchanges;
441  // uint256 public totalSupply;
442 
443   function TRND() public {
444     addressPrivateSale   = 0x6701DdeDBeb3155B8c908D0D12985A699B9d2272;
445     addressFoundersShare = 0x441B2B781a6b411f1988084a597e2ED4e0A7C352;
446     addressPartnershipsAndExchanges  = 0x5317709Ffae188eF4ed3BC3434a4EC629778721f; 
447     addressAirdrop       = 0xd176131235B5B8dC314202a8B348CC71798B0874;
448 	
449     summPrivateSale   = 5000000 * (10 ** uint256(decimals)); 
450     summFoundersShare = 5000000 * (10 ** uint256(decimals));  
451     summPartnershipsAndExchanges  = 7500000 * (10 ** uint256(decimals));  		    
452     summAirdrop       = 2500000 * (10 ** uint256(decimals));  
453     // Founders and supporters initial Allocations
454     mint(addressPrivateSale, summPrivateSale);
455     mint(addressAirdrop, summAirdrop);
456     mint(addressFoundersShare, summFoundersShare);
457     mint(addressPartnershipsAndExchanges, summPartnershipsAndExchanges);
458   }
459 }
460 
461 /**
462  * @title Crowdsale
463  * @dev Crowdsale is a base contract for managing a token crowdsale.
464  * Crowdsales have a start and end timestamps, where Contributors can make
465  * token Contributions and the crowdsale will assign them tokens based
466  * on a token per ETH rate. Funds collected are forwarded to a wallet
467  * as they arrive. The contract requires a MintableToken that will be
468  * minted as contributions arrive, note that the crowdsale contract
469  * must be owner of the token in order to be able to mint it.
470  */
471 contract Crowdsale is Ownable {
472   using SafeMath for uint256;
473   // soft cap
474   uint softcap;
475   // hard cap
476   uint256 hardcapPreICO; 
477   uint256 hardcapMainSale;  
478   TRND public token;
479   // balances for softcap
480   mapping(address => uint) public balances;
481 
482   // start and end timestamps where investments are allowed (both inclusive)
483   //ico
484     //start
485   uint256 public startIcoPreICO;  
486   uint256 public startIcoMainSale;  
487     //end 
488   uint256 public endIcoPreICO; 
489   uint256 public endIcoMainSale;   
490   //token distribution
491  // uint256 public maxIco;
492 
493   uint256 public totalSoldTokens;
494   uint256 minPurchasePreICO;     
495   
496   // how many token units a Contributor gets per wei
497   uint256 public rateIcoPreICO;
498   uint256 public rateIcoMainSale;
499 
500   //Unconfirmed sum
501   uint256 public unconfirmedSum;
502   mapping(address => uint) public unconfirmedSumAddr;
503   // address where funds are collected
504   address public wallet;
505   
506   
507 /**
508 * event for token Procurement logging
509 * @param contributor who Pledged for the tokens
510 * @param beneficiary who got the tokens
511 * @param value weis Contributed for Procurement
512 * @param amount amount of tokens Procured
513 */
514   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
515   
516   function Crowdsale() public {
517     token = createTokenContract();
518     //soft cap in tokens
519     softcap            = 20000000 * 1 ether; 
520     hardcapPreICO      =  5000000 * 1 ether; 
521     hardcapMainSale    = 75000000 * 1 ether; 
522 	
523     //min Purchase in wei = 0.1 ETH
524     minPurchasePreICO      = 100000000000000000;
525     
526     // start and end timestamps where investments are allowed
527     startIcoPreICO   = 1530435600; //   07/01/2018 @ 9:00am (UTC)
528     endIcoPreICO     = 1533027600; //   07/31/2018 @ 9:00am (UTC)
529     startIcoMainSale = 1534323600; //   08/15/2018 @ 9:00am (UTC)
530     endIcoMainSale   = 1540976400; //   10/31/2018 @ 9:00am (UTC)
531 
532     //rate; 0.1875$ for ETH = 700$
533     rateIcoPreICO = 3733;
534     //rate; 0.25$ for ETH = 700$
535     rateIcoMainSale = 2800;
536 
537     // address where funds are collected
538     wallet = 0xca5EdAE100d4D262DC3Ec2dE96FD9943Ea659d04;
539   }
540   
541   function setStartIcoPreICO(uint256 _startIcoPreICO) public onlyOwner  { 
542     // Enforce consistency of dates
543     require(_startIcoPreICO < endIcoPreICO);
544     // Once Pre-ICO has started, none of the dates can be moved anymore.
545     require(now < startIcoPreICO);
546 	  startIcoPreICO   = _startIcoPreICO;
547   }
548 
549   function setEndIcoPreICO(uint256 _endIcoPreICO) public onlyOwner  {     
550 	// Enforce consistency of dates
551     require(startIcoPreICO < _endIcoPreICO && _endIcoPreICO < startIcoMainSale);
552     // Once Pre-ICO has started, none of the dates can be moved anymore.
553     require(now < startIcoPreICO);
554 	  endIcoPreICO   = _endIcoPreICO;
555   }
556   
557   function setStartIcoMainICO(uint256 _startIcoMainSale) public onlyOwner  { 
558     // Enforce consistency of dates
559     require(endIcoPreICO < _startIcoMainSale && _startIcoMainSale < endIcoMainSale);
560     // Once Pre-ICO has started, none of the dates can be moved anymore.    
561     require(now < startIcoPreICO);
562 	  startIcoMainSale   = _startIcoMainSale;
563   }
564   
565   function setEndIcoMainICO(uint256 _endIcoMainSale) public onlyOwner  { 
566     // Enforce consistency of dates
567     require(startIcoMainSale < _endIcoMainSale);
568     // Once Pre-ICO has started, none of the dates can be moved anymore.
569     require(now < startIcoPreICO);
570 	  endIcoMainSale   = _endIcoMainSale;
571   }
572   
573   function setRateIcoPreICO(uint256 _rateIcoPreICO) public onlyOwner  {
574     rateIcoPreICO = _rateIcoPreICO;
575   }   
576   
577   function setRateIcoMainSale(uint _rateIcoMainSale) public onlyOwner  {
578     rateIcoMainSale = _rateIcoMainSale;
579   }
580        
581   // fallback function can be used to Procure tokens
582   function () external payable {
583     procureTokens(msg.sender);
584   }
585   
586   function createTokenContract() internal returns (TRND) {
587     return new TRND();
588   }
589   
590   function getRateIcoWithBonus() public view returns (uint256) {
591     uint256 bonus;
592 	  uint256 rateICO;
593     //icoPreICO   
594     if (now >= startIcoPreICO && now < endIcoPreICO){
595       rateICO = rateIcoPreICO;
596     }  
597 
598     //icoMainSale   
599     if (now >= startIcoMainSale  && now < endIcoMainSale){
600       rateICO = rateIcoMainSale;
601     }  
602 
603     //bonus
604     if (now >= startIcoPreICO && now < startIcoPreICO.add( 2 * 7 * 1 days )){
605       bonus = 10;
606     }  
607     if (now >= startIcoPreICO.add(2 * 7 * 1 days) && now < startIcoPreICO.add(4 * 7 * 1 days)){
608       bonus = 8;
609     } 
610     if (now >= startIcoPreICO.add(4 * 7 * 1 days) && now < startIcoPreICO.add(6 * 7 * 1 days)){
611       bonus = 6;
612     } 
613     if (now >= startIcoPreICO.add(6 * 7 * 1 days) && now < startIcoPreICO.add(8 * 7 * 1 days)){
614       bonus = 4;
615     } 
616     if (now >= startIcoPreICO.add(8 * 7 * 1 days) && now < startIcoPreICO.add(10 * 7 * 1 days)){
617       bonus = 2;
618     } 
619 
620     return rateICO + rateICO.mul(bonus).div(100);
621   }    
622   // low level token Pledge function
623   function procureTokens(address beneficiary) public payable {
624     uint256 tokens;
625     uint256 weiAmount = msg.value;
626     uint256 backAmount;
627     uint256 rate;
628     uint hardCap;
629     require(beneficiary != address(0));
630     rate = getRateIcoWithBonus();
631     //icoPreICO   
632     hardCap = hardcapPreICO;
633     if (now >= startIcoPreICO && now < endIcoPreICO && totalSoldTokens < hardCap){
634 	  require(weiAmount >= minPurchasePreICO);
635       tokens = weiAmount.mul(rate);
636       if (hardCap.sub(totalSoldTokens) < tokens){
637         tokens = hardCap.sub(totalSoldTokens); 
638         weiAmount = tokens.div(rate);
639         backAmount = msg.value.sub(weiAmount);
640       }
641     }  
642     //icoMainSale  
643     hardCap = hardcapMainSale.add(hardcapPreICO);
644     if (now >= startIcoMainSale  && now < endIcoMainSale  && totalSoldTokens < hardCap){
645       tokens = weiAmount.mul(rate);
646       if (hardCap.sub(totalSoldTokens) < tokens){
647         tokens = hardCap.sub(totalSoldTokens); 
648         weiAmount = tokens.div(rate);
649         backAmount = msg.value.sub(weiAmount);
650       }
651     }     
652     require(tokens > 0);
653     totalSoldTokens = totalSoldTokens.add(tokens);
654     balances[msg.sender] = balances[msg.sender].add(weiAmount);
655     token.mint(msg.sender, tokens);
656 	unconfirmedSum = unconfirmedSum.add(tokens);
657 	unconfirmedSumAddr[msg.sender] = unconfirmedSumAddr[msg.sender].add(tokens);
658 	token.SetPermissionsList(beneficiary, 1);
659     if (backAmount > 0){
660       msg.sender.transfer(backAmount);    
661     }
662     emit TokenProcurement(msg.sender, beneficiary, weiAmount, tokens);
663   }
664 
665   function refund() public{
666     require(totalSoldTokens.sub(unconfirmedSum) < softcap && now > endIcoMainSale);
667     require(balances[msg.sender] > 0);
668     uint value = balances[msg.sender];
669     balances[msg.sender] = 0;
670     msg.sender.transfer(value);
671   }
672   
673   function transferEthToMultisig() public onlyOwner {
674     address _this = this;
675     require(totalSoldTokens.sub(unconfirmedSum) >= softcap && now > endIcoMainSale);  
676     wallet.transfer(_this.balance);
677   } 
678   
679   function refundUnconfirmed() public{
680     require(now > endIcoMainSale);
681     require(balances[msg.sender] > 0);
682     require(token.GetPermissionsList(msg.sender) == 1);
683     uint value = balances[msg.sender];
684     balances[msg.sender] = 0;
685     msg.sender.transfer(value);
686    // token.burn(msg.sender, token.balanceOf(msg.sender));
687     uint uvalue = unconfirmedSumAddr[msg.sender];
688     unconfirmedSumAddr[msg.sender] = 0;
689     token.burn(msg.sender, uvalue );
690    // totalICO = totalICO.sub(token.balanceOf(msg.sender));    
691   } 
692   
693   function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{
694       uint8 sign;
695       sign = token.GetPermissionsList(_address);
696       token.SetPermissionsList(_address, _sign);
697       if (_sign == 0){
698           if (sign != _sign){  
699 			unconfirmedSum = unconfirmedSum.sub(unconfirmedSumAddr[_address]);
700 			unconfirmedSumAddr[_address] = 0;
701           }
702       }
703    }
704    
705    function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){
706      return token.GetPermissionsList(_address); 
707    }   
708    
709    function pause() onlyOwner public {
710      token.pause();
711    }
712 
713    function unpause() onlyOwner public {
714      token.unpause();
715    }
716     
717 }