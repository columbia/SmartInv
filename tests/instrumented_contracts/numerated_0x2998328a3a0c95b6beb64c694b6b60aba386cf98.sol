1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 pragma solidity ^0.4.18;
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) internal allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) public view returns (uint256) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * approve should be called when allowed[_spender] == 0. To increment
156    * allowed value is better to use this function to avoid 2 calls (and wait until
157    * the first transaction is mined)
158    * From MonolithDAO Token.sol
159    */
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 
180 /**
181  * @title Ownable
182  * @dev The Ownable contract has an owner address, and provides basic authorization control
183  * functions, this simplifies the implementation of "user permissions".
184  */
185 contract Ownable {
186   address public owner;
187 
188 
189   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191 
192   /**
193    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
194    * account.
195    */
196   function Ownable() public {
197     owner = msg.sender;
198   }
199 
200 
201   /**
202    * @dev Throws if called by any account other than the owner.
203    */
204   modifier onlyOwner() {
205     require(msg.sender == owner);
206     _;
207   }
208 
209 
210   /**
211    * @dev Allows the current owner to transfer control of the contract to a newOwner.
212    * @param newOwner The address to transfer ownership to.
213    */
214   function transferOwnership(address newOwner) public onlyOwner {
215     require(newOwner != address(0));
216     OwnershipTransferred(owner, newOwner);
217     owner = newOwner;
218   }
219 
220 }
221 
222 
223 /**
224  * @title Mintable token
225  * @dev Simple ERC20 Token example, with mintable token creation
226  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
227  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
228  */
229 
230 contract MintableToken is StandardToken, Ownable {
231   event Mint(address indexed to, uint256 amount);
232   event MintFinished();
233 
234   bool public mintingFinished = false;
235 
236 
237   modifier canMint() {
238     require(!mintingFinished);
239     _;
240   }
241 
242   /**
243    * @dev Function to mint tokens
244    * @param _to The address that will receive the minted tokens.
245    * @param _amount The amount of tokens to mint.
246    * @return A boolean that indicates if the operation was successful.
247    */
248   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
249     totalSupply = totalSupply.add(_amount);
250     balances[_to] = balances[_to].add(_amount);
251     Mint(_to, _amount);
252     Transfer(address(0), _to, _amount);
253     return true;
254   }
255 
256   /**
257    * @dev Function to stop minting new tokens.
258    * @return True if the operation was successful.
259    */
260   function finishMinting() onlyOwner canMint public returns (bool) {
261     mintingFinished = true;
262     MintFinished();
263     return true;
264   }
265 }
266 
267 /**
268  * @title YRXToken
269  * @dev ERC20 based Token, where all tokens are pre-assigned to the creator.
270  * Note they can later distribute these tokens as they wish using `transfer` and other
271  * `StandardToken` functions.
272  */
273 contract YRXToken is MintableToken {
274     string public constant name = "Yoritex Token";
275     string public constant symbol = "YRX";
276     uint8 public constant decimals = 18;
277     address public crowdsaleAddress;
278 
279     uint256 public constant INITIAL_SUPPLY = 510000000 * 1 ether;
280 
281     modifier nonZeroAddress(address _to) {                 // Ensures an address is provided
282         require(_to != 0x0);
283         _;
284     }
285 
286     modifier nonZeroAmount(uint _amount) {                 // Ensures a non-zero amount
287         require(_amount > 0);
288         _;
289     }
290 
291     modifier nonZeroValue() {                              // Ensures a non-zero value is passed
292         require(msg.value > 0);
293         _;
294     }
295 
296     modifier onlyCrowdsale() {                             // Ensures only crowdfund can call the function
297         require(msg.sender == crowdsaleAddress);
298         _;
299     }
300 
301     /**
302      * @dev Constructor that gives msg.sender all of existing tokens.
303      */
304     function YRXToken() public {
305         totalSupply = INITIAL_SUPPLY;
306         balances[msg.sender] = totalSupply;
307     }
308 
309     // -------------------------------------------------
310     // Sets the crowdsale address, can only be done once
311     // -------------------------------------------------
312     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner nonZeroAddress(_crowdsaleAddress) returns (bool success){
313         require(crowdsaleAddress == 0x0);
314         crowdsaleAddress = _crowdsaleAddress;
315         decrementBalance(owner, totalSupply);
316         addToBalance(crowdsaleAddress, totalSupply);
317         Transfer(0x0, _crowdsaleAddress, totalSupply);
318         return true;
319     }
320 
321     // -------------------------------------------------
322     // Function for the Crowdsale to transfer tokens
323     // -------------------------------------------------
324     function transferFromCrowdsale(address _to, uint256 _amount) external onlyCrowdsale nonZeroAmount(_amount) nonZeroAddress(_to) returns (bool success) {
325         require(balanceOf(crowdsaleAddress) >= _amount);
326         decrementBalance(crowdsaleAddress, _amount);
327         addToBalance(_to, _amount);
328         Transfer(0x0, _to, _amount);
329         return true;
330     }
331 
332     // -------------------------------------------------
333     // Adds to balance
334     // -------------------------------------------------
335     function addToBalance(address _address, uint _amount) internal {
336         balances[_address] = balances[_address].add(_amount);
337     }
338 
339     // -------------------------------------------------
340     // Removes from balance
341     // -------------------------------------------------
342     function decrementBalance(address _address, uint _amount) internal {
343         balances[_address] = balances[_address].sub(_amount);
344     }
345 
346 }
347 
348 /**
349  * @title YRXCrowdsale
350  */
351 
352 contract YRXCrowdsale is Ownable {
353   using SafeMath for uint256;
354 
355   // true for finalised presale
356   bool public isPreSaleFinalised;
357   // true for finalised crowdsale
358   bool public isFinalised;
359   // The token being sold
360   YRXToken public YRX;
361   // address where funds are collected
362   address public wallet;
363 
364   // amount of raised money in wei
365   uint256 public weiRaised;
366 
367   // current amount of purchased tokens for pre-sale and main sale
368   uint256 public preSaleTotalSupply;
369   uint256 public mainSaleTotalSupply;
370   // current amount of minted tokens for bounty
371   uint256 public bountyTotalSupply;
372   uint256 private mainSaleTokensExtra;
373 
374   event WalletAddressChanged(address _wallet);           // Triggered upon owner changing the wallet address
375   event AmountRaised(address beneficiary, uint amountRaised); // Triggered upon crowdfund being finalized
376   event Mint(address indexed to, uint256 amount);
377   /**
378    * event for token purchase logging
379    * @param purchaser who paid for the tokens
380    * @param beneficiary who got the tokens
381    * @param value weis paid for purchase
382    * @param amount amount of tokens purchased
383    */
384   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
385 
386   modifier nonZeroAddress(address _to) {                 // Ensures an address is provided
387     require(_to != 0x0);
388     _;
389   }
390 
391   modifier nonZeroAmount(uint _amount) {                 // Ensures a non-zero amount
392     require(_amount > 0);
393     _;
394   }
395 
396   modifier nonZeroValue() {                              // Ensures a non-zero value is passed
397     require(msg.value > 0);
398     _;
399   }
400 
401   modifier crowdsaleIsActive() {                         // Ensures the crowdfund is ongoing
402     require(!isFinalised && (isInPreSale() || isInMainSale()));
403     _;
404   }
405 
406   function YRXCrowdsale(address _wallet, address _token) public {
407 
408     /* default start-end periods dates
409       _preSaleStartTime =     '29 Nov 2017 00:00:00 GMT' 1511913600
410       _preSaleEndTime =       '10 Jan 2018 23:59:59 GMT' 1515628799
411       _mainSaleStartTime =    '11 Jan 2018 00:00:00 GMT' 1515628800
412       _mainSaleEndTime =      '11 May 2018 00:00:00 GMT' 1525996800
413     */
414 
415     // check dates
416     require(mainSaleStartTime() >= now);                 // can't start main sale in the past
417     require(preSaleEndTime() < mainSaleStartTime());      // can't start main sale before the end of pre-sale
418     require(preSaleStartTime() < preSaleEndTime());       // the end of pre-sale can't happen before it's start
419     require(mainSaleStartTime() < mainSaleEndTime());     // the end of main sale can't happen before it's start
420 
421     // create token contract
422     YRX = YRXToken(_token);
423     wallet = _wallet;
424     isPreSaleFinalised = false;
425     isFinalised = false;
426 
427     // current amount of purchased tokens for pre-sale and main sale
428     preSaleTotalSupply = 0;
429     mainSaleTotalSupply = 0;
430     bountyTotalSupply = 0;
431     mainSaleTokensExtra = 0;
432   }
433 
434   // -------------------------------------------------
435   // Changes main contribution wallet
436   // -------------------------------------------------
437   function changeWalletAddress(address _wallet) external onlyOwner {
438     wallet = _wallet;
439     WalletAddressChanged(_wallet);
440   }
441 
442 
443   function maxTokens() public pure returns(uint256) {
444     return 510000000 * 1 ether;
445   }
446 
447   function preSaleMaxTokens() public pure returns(uint256) {
448     return 51000000 * 1 ether;
449   }
450 
451   function mainSaleMaxTokens() public view returns(uint256) {
452     return 433500000  * 1 ether + mainSaleTokensExtra;
453   }
454 
455   function bountyMaxTokens() public pure returns(uint256) {
456     return 25500000 * 1 ether;
457   }
458 
459   function preSaleStartTime() public pure returns(uint256) {
460     return 1511913600;
461   }
462 
463   function preSaleEndTime() public pure returns(uint256) {
464     return 1515628799;
465   }
466 
467   function mainSaleStartTime() public pure returns(uint256) {
468     return 1515628800;
469   }
470 
471   function mainSaleEndTime() public pure returns(uint256) {
472     return 1525996800;
473   }
474 
475   function rate() public pure returns(uint256) {
476     return 540;
477   }
478 
479   function discountRate() public pure returns(uint256) {
480     return 1350;
481   }
482 
483   function discountICO() public pure returns(uint256) {
484     return 60;
485   }
486 
487   function isInPreSale() public constant returns(bool){
488     return now >= preSaleStartTime() && now <= preSaleEndTime();
489   }
490 
491   function isInMainSale() public constant returns(bool){
492     return now >= mainSaleStartTime() && now <= mainSaleEndTime();
493   }
494 
495   function totalSupply() public view returns(uint256){
496     return YRX.totalSupply();
497   }
498 
499   // fallback function can be used to buy tokens
500   function () public payable {
501     buyTokens(msg.sender);
502   }
503 
504   // low level token purchase function
505   function buyTokens(address beneficiary) public crowdsaleIsActive nonZeroAddress(beneficiary) nonZeroValue payable {
506     uint256 weiAmount = msg.value;
507 
508     // calculate token amount to be created
509     uint256 tokens = weiAmount * rate();
510     if (isInPreSale()) {
511       require(!isPreSaleFinalised);
512       tokens = weiAmount * discountRate();
513       require(tokens <= preSaleTokenLeft());
514     }
515 
516     if (isInMainSale()) {
517       // tokens with discount
518       tokens = weiAmount * discountRate();
519       require(mainSaleTotalSupply + tokens <= mainSaleMaxTokens());
520     }
521 
522     // update state
523     weiRaised = weiRaised.add(weiAmount);
524     if (isInPreSale())
525       preSaleTotalSupply += tokens;
526     if (isInMainSale())
527       mainSaleTotalSupply += tokens;
528 
529     forwardFunds();
530     if (!YRX.transferFromCrowdsale(beneficiary, tokens)) {revert();}
531     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
532   }
533 
534   // send ether to the fund collection wallet
535   function forwardFunds() internal {
536     wallet.transfer(msg.value);
537   }
538 
539   // mint tokens to beneficiary
540   function mint(address beneficiary, uint256 amount) public onlyOwner crowdsaleIsActive nonZeroAddress(beneficiary) nonZeroAmount(amount) {
541     // check period
542     bool withinPreSalePeriod = isInPreSale();
543     bool withinMainSalePeriod = isInMainSale();
544     if (withinPreSalePeriod) {
545       require(!isPreSaleFinalised);
546       require(amount <= preSaleTokenLeft());
547     }
548     if (withinMainSalePeriod) {
549       require(amount <= (mainSaleMaxTokens() - mainSaleTotalSupply));
550     }
551 
552     if (withinPreSalePeriod)
553       preSaleTotalSupply += amount;
554     if (withinMainSalePeriod)
555       mainSaleTotalSupply += amount;
556 
557     if (!YRX.transferFromCrowdsale(beneficiary, amount)) {revert();}
558     Mint(beneficiary, amount);
559   }
560 
561   function preSaleTokenLeft() public constant returns(uint256){
562     return preSaleMaxTokens() - preSaleTotalSupply;
563   }
564 
565   // finalise presale
566   function finalisePreSale() public onlyOwner {
567     require(!isFinalised);
568     require(!isPreSaleFinalised);
569     require(now >= preSaleStartTime()); // can finalise presale only after it starts
570 
571     if (preSaleTokenLeft() > 0) {
572       mainSaleTokensExtra = preSaleTokenLeft();
573     }
574 
575     isPreSaleFinalised = true;
576   }
577 
578   // finalase crowdsale (mainsale)
579   function finalise() public onlyOwner returns(bool success){
580     require(!isFinalised);
581     require(now >= mainSaleStartTime()); // can finalise mainsale (crowdsale) only after it starts
582     AmountRaised(wallet, weiRaised);
583     isFinalised = true;
584     return true;
585   }
586 
587   // mint bounty tokens to beneficiary
588   function mintBounty(address beneficiary, uint256 amount) public onlyOwner crowdsaleIsActive nonZeroAddress(beneficiary) nonZeroAmount(amount) {
589     require(amount <= (bountyMaxTokens() - bountyTotalSupply));
590 
591     bountyTotalSupply += amount;
592     if (!YRX.transferFromCrowdsale(beneficiary, amount)) {revert();}
593     Mint(beneficiary, amount);
594   }
595 
596 }