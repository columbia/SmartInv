1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 
77 
78 /**
79  * @title Ownable
80  * @dev The Ownable contract has an owner address, and provides basic authorization control
81  * functions, this simplifies the implementation of "user permissions".
82  */
83 contract Ownable {
84   address public owner;
85 
86 
87   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89 
90   /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94   function Ownable() public {
95     owner = msg.sender;
96   }
97 
98   /**
99    * @dev Throws if called by any account other than the owner.
100    */
101   modifier onlyOwner() {
102     require(msg.sender == owner);
103     _;
104   }
105 
106   /**
107    * @dev Allows the current owner to transfer control of the contract to a newOwner.
108    * @param newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address newOwner) public onlyOwner {
111     require(newOwner != address(0));
112     OwnershipTransferred(owner, newOwner);
113     owner = newOwner;
114   }
115 
116 }
117 
118 
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   uint256 totalSupply_;
130 
131   /**
132   * @dev total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146 
147     // SafeMath.sub will throw if there is not enough balance.
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256 balance) {
160     return balances[_owner];
161   }
162 
163 }
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(address _owner, address _spender) public view returns (uint256) {
219     return allowed[_owner][_spender];
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 
262 /**
263  * @title Crowdsale
264  * @dev Crowdsale is a base contract for managing a token crowdsale,
265  * allowing investors to purchase tokens with ether. This contract implements
266  * such functionality in its most fundamental form and can be extended to provide additional
267  * functionality and/or custom behavior.
268  * The external interface represents the basic interface for purchasing tokens, and conform
269  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
270  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
271  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
272  * behavior.
273  */
274 
275 contract Crowdsale {
276   using SafeMath for uint256;
277 
278   // The token being sold
279   ERC20 public token;
280 
281   // Address where funds are collected
282   address public wallet;
283 
284   // How many token units a buyer gets per wei
285   uint256 public rate;
286 
287   // Amount of wei raised
288   uint256 public weiRaised;
289 
290   // total cap
291   uint256 public cap;
292 
293   //sales between openingTime and closingTime
294   uint256 public openingTime;
295   uint256 public closingTime;
296 
297   mapping (address => uint256) public contributorList;
298 
299   /**
300    * @dev Reverts if not in crowdsale time range. 
301    */
302   modifier onlyWhileOpen {
303     require(now >= openingTime && now <= closingTime);
304     _;
305   }
306 
307   /**
308    * Event for token purchase logging
309    * @param purchaser who paid for the tokens
310    * @param beneficiary who got the tokens
311    * @param value weis paid for purchase
312    * @param amount amount of tokens purchased
313    */
314   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
315 
316   /**
317    * @param _rate Number of token units a buyer gets per wei
318    * @param _wallet Address where collected funds will be forwarded to
319    * @param _token Address of the token being sold
320    * @param _cap Amount of weis to be sold
321    */
322   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token, uint256 _cap, uint256 _openingTime, uint256 _closingTime) public {
323     require(_rate > 0);
324     require(_wallet != address(0));
325     require(_token != address(0));
326     require(_cap > 0);
327     require(_openingTime >= now);
328     require(_closingTime >= _openingTime);
329     
330     rate = _rate;
331     wallet = _wallet;
332     token = _token;
333     cap = _cap;
334     openingTime = _openingTime;
335     closingTime = _closingTime;  
336     
337     }
338 
339   /**
340    * @dev Checks whether the cap has been reached. 
341    * @return Whether the cap was reached
342    */
343   function capReached() public view returns (bool) {
344     return weiRaised >= cap;
345   }
346 
347   // -----------------------------------------
348   // Crowdsale external interface
349   // -----------------------------------------
350 
351   /**
352    * @dev fallback function ***DO NOT OVERRIDE***
353    */
354   function () external payable {
355     buyTokens(msg.sender);
356   }
357 
358   /**
359    * @dev low level token purchase ***DO NOT OVERRIDE***
360    * @param _beneficiary Address performing the token purchase
361    */
362   function buyTokens(address _beneficiary) public payable {
363 
364     //uint256 weiAmountTmp = msg.value;
365     uint256 weiAmount;
366 
367     weiAmount = (weiRaised.add(msg.value) <= cap) ? (msg.value) : (cap.sub(weiRaised));
368 
369     _preValidatePurchase(_beneficiary, weiAmount);
370 
371     _setContributor(_beneficiary, weiAmount);
372 
373     //update state
374     weiRaised = weiRaised.add(weiAmount);
375 
376     /**
377     * return overflowed ETH to sender
378     */
379     if(weiAmount < msg.value){
380         _beneficiary.transfer(msg.value.sub(weiAmount));
381     }
382     _forwardFundsWei(weiAmount);
383 
384   }
385 
386   /**
387    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
388    * @return Whether crowdsale period has elapsed
389    */
390   function hasClosed() public view returns (bool) {
391     return now > closingTime;
392   }
393 
394   // -----------------------------------------
395   // Internal interface (extensible)
396   // -----------------------------------------
397 
398   /**
399    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
400    * @param _beneficiary Address performing the token purchase
401    * @param _weiAmount Value in wei involved in the purchase
402    */
403   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
404     require(_beneficiary != address(0));
405     require(_weiAmount != 0);
406     require(weiRaised.add(_weiAmount) <= cap);
407 
408   }
409 
410   function _setContributor(address _beneficiary, uint256 _tokenAmount) internal onlyWhileOpen {
411 
412     // rounding at 2 point
413     uint pibToken = _tokenAmount.mul(rate).div(10 ** 16).mul(10 ** 16);
414 //      uint pibToken = _tokenAmount.mul(rate);
415   
416      contributorList[_beneficiary] += pibToken;
417 
418   }
419 
420   /**
421    * @dev Determines how ETH is stored/forwarded on purchases.
422    */
423   function _forwardFundsWei(uint256 txAmount) internal {
424 
425     wallet.transfer(txAmount);
426 
427   }  
428   
429 }
430 
431 
432 /**
433  * @title Mintable token
434  * @dev Simple ERC20 Token example, with mintable token creation
435  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
436  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
437  */
438 contract MintableToken is StandardToken, Ownable {
439   event Mint(address indexed to, uint256 amount);
440   event MintFinished();
441 
442   bool public mintingFinished = false;
443 
444 
445   modifier canMint() {
446     require(!mintingFinished);
447     _;
448   }
449 
450   /**
451    * @dev Function to mint tokens
452    * @param _to The address that will receive the minted tokens.
453    * @param _amount The amount of tokens to mint.
454    * @return A boolean that indicates if the operation was successful.
455    */
456   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
457     totalSupply_ = totalSupply_.add(_amount);
458     balances[_to] = balances[_to].add(_amount);
459     Mint(_to, _amount);
460     Transfer(address(0), _to, _amount);
461     return true;
462   }
463 
464   /**
465    * @dev Function to stop minting new tokens.
466    * @return True if the operation was successful.
467    */
468   function finishMinting() onlyOwner canMint public returns (bool) {
469     mintingFinished = true;
470     MintFinished();
471     return true;
472   }
473 }
474 
475 
476 //////////////////
477 
478 /**
479  * @title Pibble2ndPresale
480  * @dev This is an example of a fully fledged crowdsale.
481  * The way to add new features to a base crowdsale is by multiple inheritance.
482  * In this example we are providing following extensions:
483  * CappedCrowdsale - sets a max boundary for raised funds
484  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
485  *
486  * After adding multiple features it's good practice to run integration tests
487  * to ensure that subcontracts works together as intended.
488  */
489 contract PibbleMain is Crowdsale, Ownable {
490 
491   uint256 public minValue;
492 //  uint256 public maxValue;
493   
494   bool public paused = false;
495 
496 
497   event Pause();
498   event Unpause();
499 
500   /**
501    * @dev Modifier to make a function callable only when the contract is not paused.
502    */
503   modifier whenNotPaused() {
504     require(!paused);
505     _;
506   }
507 
508   /**
509    * @dev Modifier to make a function callable only when the contract is paused.
510    */
511   modifier whenPaused() {
512     require(paused);
513     _;
514   }
515 
516 /**
517  * rate 200,000 PIB per 1 eth  
518  */
519   function PibbleMain(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, uint256 _cap, MintableToken _token, uint256 _minValue) public
520     Crowdsale(_rate, _wallet, _token, _cap, _openingTime, _closingTime)
521     {
522         require(_minValue >= 0);
523         minValue =_minValue;
524 //        maxValue =_maxValue;
525     }
526 
527 
528   /**
529    * @dev Allows the "TOKEN owner" to transfer control of the contract to a newOwner.
530    * @param newOwner The address to transfer ownership to.
531    */
532   function transferTokenOwnership(address newOwner) public onlyOwner {
533     require(newOwner != address(0));
534     OwnershipTransferred(owner, newOwner);
535     MintableToken(token).transferOwnership(newOwner);
536   }
537 
538   function buyTokens(address _beneficiary) public payable whenNotPaused {
539 
540     require( minValue <= msg.value );
541 //    require( ( minValue <= msg.value && msg.value <= maxValue) );
542 //    require(msg.value <= maxValue);
543     super.buyTokens(_beneficiary);
544     
545   }
546 
547 /**
548   function _forwardFunds() internal whenNotPaused {
549     super._forwardFunds();
550   }
551 **/
552 
553   function _forwardFundsWei(uint256 txAmount) internal whenNotPaused {
554     super._forwardFundsWei(txAmount);
555   }
556 
557   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal whenNotPaused {
558 //    do nothing at thistime.
559 //    super._deliverTokens(_beneficiary, _tokenAmount) 
560 
561   }
562 
563   function _setContributor(address _beneficiary, uint256 _tokenAmount) internal whenNotPaused {
564 
565     super._setContributor(_beneficiary,_tokenAmount);
566 
567   }
568 
569   function mintContributors(address[] contributors) public onlyOwner {
570 
571     address contributor ;
572     uint tokenCount = 0;
573 
574     for (uint i = 0; i < contributors.length; i++) {
575         contributor = contributors[i];
576         tokenCount = contributorList[contributor];
577         
578         //require(tokenCount > 0);
579         
580         MintableToken(token).mint(contributor, tokenCount);
581        
582        // reset data
583        delete contributorList[contributor];
584     }      
585       
586   }
587 
588   /**
589    * @dev called by the owner to pause, triggers stopped state
590    */
591   function pause() onlyOwner whenNotPaused public {
592     paused = true;
593     Pause();
594   }
595 
596   /**
597    * @dev called by the owner to unpause, returns to normal state
598    */
599   function unpause() onlyOwner whenPaused public {
600     paused = false;
601     Unpause();
602   }
603 
604   function saleEnded() public view returns (bool) {
605     return (weiRaised >= cap || now > closingTime);
606   }
607  
608   function saleStatus() public view returns (uint, uint) {
609     return (cap, weiRaised);
610   } 
611   
612 }