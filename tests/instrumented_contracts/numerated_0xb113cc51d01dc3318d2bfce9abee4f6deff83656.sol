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
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   function totalSupply() public view returns (uint256);
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic, Ownable {
118   using SafeMath for uint256;
119   mapping(address => uint256) balances;
120   // 1 denied / 0 allow
121   mapping(address => uint8) permissionsList;
122   
123   function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{
124     permissionsList[_address] = _sign; 
125   }
126   function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){
127     return permissionsList[_address]; 
128   }  
129   uint256 totalSupply_;
130 
131   /**
132   * @dev total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(permissionsList[msg.sender] == 0);
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146 
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175   /**
176    * @dev Transfer tokens from one address to another
177    * @param _from address The address which you want to send tokens from
178    * @param _to address The address which you want to transfer to
179    * @param _value uint256 the amount of tokens to be transferred
180    */
181   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182     require(permissionsList[msg.sender] == 0);
183     require(_to != address(0));
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     emit Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     emit Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 
260 /**
261  * @title Pausable
262  * @dev Base contract which allows children to implement an emergency stop mechanism.
263  */
264 contract Pausable is Ownable {
265   event Pause();
266   event Unpause();
267 
268   bool public paused = false;
269 
270 
271   /**
272    * @dev Modifier to make a function callable only when the contract is not paused.
273    */
274   modifier whenNotPaused() {
275     require(!paused);
276     _;
277   }
278 
279   /**
280    * @dev Modifier to make a function callable only when the contract is paused.
281    */
282   modifier whenPaused() {
283     require(paused);
284     _;
285   }
286 
287   /**
288    * @dev called by the owner to pause, triggers stopped state
289    */
290   function pause() onlyOwner whenNotPaused public {
291     paused = true;
292     emit Pause();
293   }
294 
295   /**
296    * @dev called by the owner to unpause, returns to normal state
297    */
298   function unpause() onlyOwner whenPaused public {
299     paused = false;
300     emit Unpause();
301   }
302 }
303 
304 /**
305  * @title Pausable token
306  * @dev StandardToken modified with pausable transfers.
307  **/
308 contract PausableToken is StandardToken, Pausable {
309 
310   function transfer(
311     address _to,
312     uint256 _value
313   )
314     public
315     whenNotPaused
316     returns (bool)
317   {
318     return super.transfer(_to, _value);
319   }
320 
321   function transferFrom(
322     address _from,
323     address _to,
324     uint256 _value
325   )
326     public
327     whenNotPaused
328     returns (bool)
329   {
330     return super.transferFrom(_from, _to, _value);
331   }
332 
333   function approve(
334     address _spender,
335     uint256 _value
336   )
337     public
338     whenNotPaused
339     returns (bool)
340   {
341     return super.approve(_spender, _value);
342   }
343 
344   function increaseApproval(
345     address _spender,
346     uint _addedValue
347   )
348     public
349     whenNotPaused
350     returns (bool success)
351   {
352     return super.increaseApproval(_spender, _addedValue);
353   }
354 
355   function decreaseApproval(
356     address _spender,
357     uint _subtractedValue
358   )
359     public
360     whenNotPaused
361     returns (bool success)
362   {
363     return super.decreaseApproval(_spender, _subtractedValue);
364   }
365 }
366 
367 /**
368  * @title Mintable token
369  * @dev Simple ERC20 Token example, with mintable token creation
370  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
371  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
372  */
373 contract MintableToken is PausableToken {
374   event Mint(address indexed to, uint256 amount);
375   event MintFinished();
376 
377   bool public mintingFinished = false;
378 
379 
380   modifier canMint() {
381     require(!mintingFinished);
382     _;
383   }
384 
385   /**
386    * @dev Function to mint tokens
387    * @param _to The address that will receive the minted tokens.
388    * @param _amount The amount of tokens to mint.
389    * @return A boolean that indicates if the operation was successful.
390    */
391   function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
392     totalSupply_ = totalSupply_.add(_amount);
393     balances[_to] = balances[_to].add(_amount);
394     emit Mint(_to, _amount);
395     emit Transfer(address(0), _to, _amount);
396     return true;
397   }
398 
399   /**
400    * @dev Function to stop minting new tokens.
401    * @return True if the operation was successful.
402    */
403   function finishMinting() onlyOwner canMint public returns (bool) {
404     mintingFinished = true;
405     emit MintFinished();
406     return true;
407   }
408 }
409 contract BurnableByOwner is BasicToken {
410 
411   event Burn(address indexed burner, uint256 value);
412   function burn(address _address, uint256 _value) public onlyOwner{
413     require(_value <= balances[_address]);
414     // no need to require value <= totalSupply, since that would imply the
415     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
416 
417     address burner = _address;
418     balances[burner] = balances[burner].sub(_value);
419     totalSupply_ = totalSupply_.sub(_value);
420     emit Burn(burner, _value);
421     emit Transfer(burner, address(0), _value);
422   }
423 }
424 
425 contract TRND is Ownable, MintableToken, BurnableByOwner {
426   using SafeMath for uint256;    
427   string public constant name = "Trends";
428   string public constant symbol = "TRND";
429   uint32 public constant decimals = 18;
430   
431   address public addressPrivateSale;
432   address public addressAirdrop;
433   address public addressPremineBounty;
434   address public addressPartnerships;
435 
436   uint256 public summPrivateSale;
437   uint256 public summAirdrop;
438   uint256 public summPremineBounty;
439   uint256 public summPartnerships;
440  // uint256 public totalSupply;
441 
442   function TRND() public {
443     addressPrivateSale   = 0x6701DdeDBeb3155B8c908D0D12985A699B9d2272;
444     addressAirdrop       = 0xd176131235B5B8dC314202a8B348CC71798B0874;
445     addressPremineBounty = 0xd176131235B5B8dC314202a8B348CC71798B0874;
446     addressPartnerships  = 0x441B2B781a6b411f1988084a597e2ED4e0A7C352; 
447 	
448     summPrivateSale   = 5000000 * (10 ** uint256(decimals)); 
449     summAirdrop       = 4500000 * (10 ** uint256(decimals));  
450     summPremineBounty = 1000000 * (10 ** uint256(decimals));  
451     summPartnerships  = 2500000 * (10 ** uint256(decimals));  		    
452     // Founders and supporters initial Allocations
453     mint(addressPrivateSale, summPrivateSale);
454     mint(addressAirdrop, summAirdrop);
455     mint(addressPremineBounty, summPremineBounty);
456     mint(addressPartnerships, summPartnerships);
457   }
458 }
459 
460 /**
461  * @title Crowdsale
462  * @dev Crowdsale is a base contract for managing a token crowdsale.
463  * Crowdsales have a start and end timestamps, where Contributors can make
464  * token Contributions and the crowdsale will assign them tokens based
465  * on a token per ETH rate. Funds collected are forwarded to a wallet
466  * as they arrive. The contract requires a MintableToken that will be
467  * minted as contributions arrive, note that the crowdsale contract
468  * must be owner of the token in order to be able to mint it.
469  */
470 contract Crowdsale is Ownable {
471   using SafeMath for uint256;
472   // soft cap
473   uint softcap;
474   // hard cap
475   uint256 hardcapPreICO; 
476   uint256 hardcapMainSale;  
477   TRND public token;
478   // balances for softcap
479   mapping(address => uint) public balances;
480 
481   // start and end timestamps where investments are allowed (both inclusive)
482   //ico
483     //start
484   uint256 public startIcoPreICO;  
485   uint256 public startIcoMainSale;  
486     //end 
487   uint256 public endIcoPreICO; 
488   uint256 public endIcoMainSale;   
489   //token distribution
490  // uint256 public maxIco;
491 
492   uint256 public totalSoldTokens;
493   uint256 minPurchasePreICO;     
494   uint256 minPurchaseMainSale;   
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
521     hardcapMainSale    = 80000000 * 1 ether; 
522 	
523     //min Purchase in wei = 0.1 ETH
524     minPurchasePreICO      = 100000000000000000;
525     minPurchaseMainSale    = 100000000000000000;
526     // start and end timestamps where investments are allowed
527     //ico
528     //start/end 
529     startIcoPreICO   = 1527843600; //   06/01/2018 @ 9:00am (UTC)
530     endIcoPreICO     = 1530435600; //   07/01/2018 @ 9:00am (UTC)
531     startIcoMainSale = 1530435600; //   07/01/2018 @ 9:00am (UTC)
532     endIcoMainSale   = 1533891600; //   08/10/2018 @ 9:00am (UTC)
533 
534     //rate; 0.125$ for ETH = 700$
535     rateIcoPreICO = 5600;
536     //rate; 0.25$ for ETH = 700$
537     rateIcoMainSale = 2800;
538 
539     // address where funds are collected
540     wallet = 0xca5EdAE100d4D262DC3Ec2dE96FD9943Ea659d04;
541   }
542   
543   function setStartIcoPreICO(uint256 _startIcoPreICO) public onlyOwner  { 
544     uint256 delta;
545     require(now < startIcoPreICO);
546 	if (startIcoPreICO > _startIcoPreICO) {
547 	  delta = startIcoPreICO.sub(_startIcoPreICO);
548 	  startIcoPreICO   = _startIcoPreICO;
549 	  endIcoPreICO     = endIcoPreICO.sub(delta);
550       startIcoMainSale = startIcoMainSale.sub(delta);
551       endIcoMainSale   = endIcoMainSale.sub(delta);
552 	}
553 	if (startIcoPreICO < _startIcoPreICO) {
554 	  delta = _startIcoPreICO.sub(startIcoPreICO);
555 	  startIcoPreICO   = _startIcoPreICO;
556 	  endIcoPreICO     = endIcoPreICO.add(delta);
557       startIcoMainSale = startIcoMainSale.add(delta);
558       endIcoMainSale   = endIcoMainSale.add(delta);
559 	}	
560   }
561   
562   function setRateIcoPreICO(uint256 _rateIcoPreICO) public onlyOwner  {
563     rateIcoPreICO = _rateIcoPreICO;
564   }   
565   function setRateIcoMainSale(uint _rateIcoMainSale) public onlyOwner  {
566     rateIcoMainSale = _rateIcoMainSale;
567   }     
568   // fallback function can be used to Procure tokens
569   function () external payable {
570     procureTokens(msg.sender);
571   }
572   
573   function createTokenContract() internal returns (TRND) {
574     return new TRND();
575   }
576   
577   function getRateIcoWithBonus() public view returns (uint256) {
578     uint256 bonus;
579 	uint256 rateICO;
580     //icoPreICO   
581     if (now >= startIcoPreICO && now < endIcoPreICO){
582       rateICO = rateIcoPreICO;
583     }  
584 
585     //icoMainSale   
586     if (now >= startIcoMainSale  && now < endIcoMainSale){
587       rateICO = rateIcoMainSale;
588     }  
589 
590     //bonus
591     if (now >= startIcoPreICO && now < startIcoPreICO.add( 2 * 7 * 1 days )){
592       bonus = 10;
593     }  
594     if (now >= startIcoPreICO.add(2 * 7 * 1 days) && now < startIcoPreICO.add(4 * 7 * 1 days)){
595       bonus = 8;
596     } 
597     if (now >= startIcoPreICO.add(4 * 7 * 1 days) && now < startIcoPreICO.add(6 * 7 * 1 days)){
598       bonus = 6;
599     } 
600     if (now >= startIcoPreICO.add(6 * 7 * 1 days) && now < startIcoPreICO.add(8 * 7 * 1 days)){
601       bonus = 4;
602     } 
603     if (now >= startIcoPreICO.add(8 * 7 * 1 days) && now < startIcoPreICO.add(10 * 7 * 1 days)){
604       bonus = 2;
605     } 
606 
607     return rateICO + rateICO.mul(bonus).div(100);
608   }    
609   // low level token Pledge function
610   function procureTokens(address beneficiary) public payable {
611     uint256 tokens;
612     uint256 weiAmount = msg.value;
613     uint256 backAmount;
614     uint256 rate;
615     uint hardCap;
616     require(beneficiary != address(0));
617     rate = getRateIcoWithBonus();
618     //icoPreICO   
619     hardCap = hardcapPreICO;
620     if (now >= startIcoPreICO && now < endIcoPreICO && totalSoldTokens < hardCap){
621 	  require(weiAmount >= minPurchasePreICO);
622       tokens = weiAmount.mul(rate);
623       if (hardCap.sub(totalSoldTokens) < tokens){
624         tokens = hardCap.sub(totalSoldTokens); 
625         weiAmount = tokens.div(rate);
626         backAmount = msg.value.sub(weiAmount);
627       }
628     }  
629     //icoMainSale  
630     hardCap = hardcapMainSale.add(hardcapPreICO);
631     if (now >= startIcoMainSale  && now < endIcoMainSale  && totalSoldTokens < hardCap){
632 	  require(weiAmount >= minPurchaseMainSale);
633       tokens = weiAmount.mul(rate);
634       if (hardCap.sub(totalSoldTokens) < tokens){
635         tokens = hardCap.sub(totalSoldTokens); 
636         weiAmount = tokens.div(rate);
637         backAmount = msg.value.sub(weiAmount);
638       }
639     }     
640     require(tokens > 0);
641     totalSoldTokens = totalSoldTokens.add(tokens);
642     balances[msg.sender] = balances[msg.sender].add(weiAmount);
643     token.mint(msg.sender, tokens);
644 	unconfirmedSum = unconfirmedSum.add(tokens);
645 	unconfirmedSumAddr[msg.sender] = unconfirmedSumAddr[msg.sender].add(tokens);
646 	token.SetPermissionsList(beneficiary, 1);
647     if (backAmount > 0){
648       msg.sender.transfer(backAmount);    
649     }
650     emit TokenProcurement(msg.sender, beneficiary, weiAmount, tokens);
651   }
652 
653   function refund() public{
654     require(totalSoldTokens.sub(unconfirmedSum) < softcap && now > endIcoMainSale);
655     require(balances[msg.sender] > 0);
656     uint value = balances[msg.sender];
657     balances[msg.sender] = 0;
658     msg.sender.transfer(value);
659   }
660   
661   function transferEthToMultisig() public onlyOwner {
662     address _this = this;
663     require(totalSoldTokens.sub(unconfirmedSum) >= softcap && now > endIcoMainSale);  
664     wallet.transfer(_this.balance);
665   } 
666   
667   function refundUnconfirmed() public{
668     require(now > endIcoMainSale);
669     require(balances[msg.sender] > 0);
670     require(token.GetPermissionsList(msg.sender) == 1);
671     uint value = balances[msg.sender];
672     balances[msg.sender] = 0;
673     msg.sender.transfer(value);
674    // token.burn(msg.sender, token.balanceOf(msg.sender));
675     uint uvalue = unconfirmedSumAddr[msg.sender];
676     unconfirmedSumAddr[msg.sender] = 0;
677     token.burn(msg.sender, uvalue );
678    // totalICO = totalICO.sub(token.balanceOf(msg.sender));    
679   } 
680   
681   function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{
682       uint8 sign;
683       sign = token.GetPermissionsList(_address);
684       token.SetPermissionsList(_address, _sign);
685       if (_sign == 0){
686           if (sign != _sign){  
687 			unconfirmedSum = unconfirmedSum.sub(unconfirmedSumAddr[_address]);
688 			unconfirmedSumAddr[_address] = 0;
689           }
690       }
691    }
692    
693    function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){
694      return token.GetPermissionsList(_address); 
695    }   
696    
697    function pause() onlyOwner public {
698      token.pause();
699    }
700 
701    function unpause() onlyOwner public {
702      token.unpause();
703    }
704     
705 }