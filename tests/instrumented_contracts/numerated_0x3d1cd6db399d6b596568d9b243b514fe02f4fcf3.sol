1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36   address public owner;
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() {
43     owner = msg.sender;
44   }
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner public {
57     require(newOwner != address(0));
58     OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 }
62 
63 /**
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Basic {
69   uint256 public totalSupply;
70   function balanceOf(address who) public constant returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80   mapping(address => uint256) balances;
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public constant returns (uint256 balance) {
100     return balances[_owner];
101   }
102 }
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public constant returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 /**
114  * @title Standard ERC20 token
115  *
116  * @dev Implementation of the basic standard token.
117  * @dev https://github.com/ethereum/EIPs/issues/20
118  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
119  */
120 contract StandardToken is ERC20, BasicToken {
121   mapping (address => mapping (address => uint256)) allowed;
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amount of tokens to be transferred
127    */
128   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     uint256 _allowance = allowed[_from][msg.sender];
131     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
132     // require (_value <= _allowance);
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = _allowance.sub(_value);
136     Transfer(_from, _to, _value);
137     return true;
138   }
139   /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    *
142    * Beware that changing an allowance with this method brings the risk that someone may use both the old
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) public returns (bool) {
150     allowed[msg.sender][_spender] = _value;
151     Approval(msg.sender, _spender, _value);
152     return true;
153   }
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
161     return allowed[_owner][_spender];
162   }
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue)
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175   function decreaseApproval (address _spender, uint _subtractedValue)
176     returns (bool success) {
177     uint oldValue = allowed[msg.sender][_spender];
178     if (_subtractedValue > oldValue) {
179       allowed[msg.sender][_spender] = 0;
180     } else {
181       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182     }
183     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 }
187 
188 
189 /**
190  * @title Mintable token
191  * @dev Simple ERC20 Token example, with mintable token creation
192  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
193  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
194  */
195 contract MintableToken is StandardToken, Ownable {
196   event Mint(address indexed to, uint256 amount);
197   event MintFinished();
198   bool public mintingFinished = false;
199   modifier canMint() {
200     require(!mintingFinished);
201     _;
202   }
203   /**
204    * @dev Function to mint tokens
205    * @param _to The address that will receive the minted tokens.
206    * @param _amount The amount of tokens to mint.
207    * @return A boolean that indicates if the operation was successful.
208    */
209   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
210     totalSupply = totalSupply.add(_amount);
211     balances[_to] = balances[_to].add(_amount);
212     Mint(_to, _amount);
213     Transfer(0x0, _to, _amount);
214     return true;
215   }
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner public returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225 }
226 
227 contract Crowdsale {
228   using SafeMath for uint256;
229 
230   // The token being sold
231   ERC20 public token;
232 
233   // Address where funds are collected
234   address public wallet;
235 
236   // How many token units a buyer gets per wei
237   uint256 public rate;
238 
239   // Amount of wei raised
240   uint256 public weiRaised;
241 
242   /**
243    * Event for token purchase logging
244    * @param purchaser who paid for the tokens
245    * @param beneficiary who got the tokens
246    * @param value weis paid for purchase
247    * @param amount amount of tokens purchased
248    */
249   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
250 
251   /**
252    * @param _rate Number of token units a buyer gets per wei
253    * @param _wallet Address where collected funds will be forwarded to
254    * @param _token Address of the token being sold
255    */
256   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
257     require(_rate > 0);
258     require(_wallet != address(0));
259     require(_token != address(0));
260 
261     rate = _rate;
262     wallet = _wallet;
263     token = _token;
264   }
265 
266   // -----------------------------------------
267   // Crowdsale external interface
268   // -----------------------------------------
269 
270   /**
271    * @dev fallback function ***DO NOT OVERRIDE***
272    */
273   function () external payable {
274     buyTokens(msg.sender);
275   }
276 
277   /**
278    * @dev low level token purchase ***DO NOT OVERRIDE***
279    * @param _beneficiary Address performing the token purchase
280    */
281   function buyTokens(address _beneficiary) public payable {
282 
283     uint256 weiAmount = msg.value;
284     _preValidatePurchase(_beneficiary, weiAmount);
285 
286     // calculate token amount to be created
287     uint256 tokens = _getTokenAmount(weiAmount);
288 
289     // update state
290     weiRaised = weiRaised.add(weiAmount);
291 
292     _processPurchase(_beneficiary, tokens);
293     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
294 
295     _updatePurchasingState(_beneficiary, weiAmount);
296 
297     _forwardFunds();
298     _postValidatePurchase(_beneficiary, weiAmount);
299   }
300 
301   // -----------------------------------------
302   // Internal interface (extensible)
303   // -----------------------------------------
304 
305   /**
306    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
307    * @param _beneficiary Address performing the token purchase
308    * @param _weiAmount Value in wei involved in the purchase
309    */
310   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
311     require(_beneficiary != address(0));
312     require(_weiAmount != 0);
313   }
314 
315   /**
316    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
317    * @param _beneficiary Address performing the token purchase
318    * @param _weiAmount Value in wei involved in the purchase
319    */
320   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
321     // optional override
322   }
323 
324   /**
325    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
326    * @param _beneficiary Address performing the token purchase
327    * @param _tokenAmount Number of tokens to be emitted
328    */
329   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
330     token.transfer(_beneficiary, _tokenAmount);
331   }
332 
333   /**
334    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
335    * @param _beneficiary Address receiving the tokens
336    * @param _tokenAmount Number of tokens to be purchased
337    */
338   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
339     _deliverTokens(_beneficiary, _tokenAmount);
340   }
341 
342   /**
343    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
344    * @param _beneficiary Address receiving the tokens
345    * @param _weiAmount Value in wei involved in the purchase
346    */
347   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
348     // optional override
349   }
350 
351   /**
352    * @dev Override to extend the way in which ether is converted to tokens.
353    * @param _weiAmount Value in wei to be converted into tokens
354    * @return Number of tokens that can be purchased with the specified _weiAmount
355    */
356   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
357     return _weiAmount.mul(rate);
358   }
359 
360   /**
361    * @dev Determines how ETH is stored/forwarded on purchases.
362    */
363   function _forwardFunds() internal {
364     wallet.transfer(msg.value);
365   }
366 }
367 
368 contract TimedCrowdsale is Crowdsale {
369   using SafeMath for uint256;
370 
371   uint256 public openingTime;
372   uint256 public closingTime;
373 
374   /**
375    * @dev Reverts if not in crowdsale time range. 
376    */
377   modifier onlyWhileOpen {
378     require(now >= openingTime && now <= closingTime);
379     _;
380   }
381 
382   /**
383    * @dev Constructor, takes crowdsale opening and closing times.
384    * @param _openingTime Crowdsale opening time
385    * @param _closingTime Crowdsale closing time
386    */
387   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
388     require(_openingTime >= now);
389     require(_closingTime >= _openingTime);
390 
391     openingTime = _openingTime;
392     closingTime = _closingTime;
393   }
394 
395   /**
396    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
397    * @return Whether crowdsale period has elapsed
398    */
399   function hasClosed() public view returns (bool) {
400     return now > closingTime;
401   }
402   
403   /**
404    * @dev Extend parent behavior requiring to be within contributing period
405    * @param _beneficiary Token purchaser
406    * @param _weiAmount Amount of wei contributed
407    */
408   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
409     super._preValidatePurchase(_beneficiary, _weiAmount);
410   }
411 
412 }
413 
414 /**
415  * @title IncreasingPriceCrowdsale
416  * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time. 
417  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
418  * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
419  */
420 contract IncreasingPriceCrowdsale is TimedCrowdsale {
421   using SafeMath for uint256;
422 
423   uint256 public initialRate;
424   uint256 public finalRate;
425 
426   /**
427    * @dev Constructor, takes intial and final rates of tokens received per wei contributed.
428    * @param _initialRate Number of tokens a buyer gets per wei at the start of the crowdsale
429    * @param _finalRate Number of tokens a buyer gets per wei at the end of the crowdsale
430    */
431   function IncreasingPriceCrowdsale(uint256 _initialRate, uint256 _finalRate) public {
432     require(_initialRate >= _finalRate);
433     require(_finalRate > 0);
434     initialRate = _initialRate;
435     finalRate = _finalRate;
436   }
437 
438   /**
439    * @dev Returns the rate of tokens per wei at the present time. 
440    * Note that, as price _increases_ with time, the rate _decreases_. 
441    * @return The number of tokens a buyer gets per wei at a given time
442    */
443   function getCurrentRate() public view returns (uint256) {
444     uint256 elapsedTime = now.sub(openingTime);
445     uint256 timeRange = closingTime.sub(openingTime);
446     uint256 rateRange = initialRate.sub(finalRate);
447     return initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
448   }
449 
450   /**
451    * @dev Overrides parent method taking into account variable rate.
452    * @param _weiAmount The value in wei to be converted into tokens
453    * @return The number of tokens _weiAmount wei will buy at present time
454    */
455   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
456     uint256 currentRate = getCurrentRate();
457     return currentRate.mul(_weiAmount);
458   }
459 
460 }
461 
462 /**
463  * @title MintedCrowdsale
464  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
465  * Token ownership should be transferred to MintedCrowdsale for minting. 
466  */
467 contract MintedCrowdsale is Crowdsale {
468 
469   /**
470    * @dev Overrides delivery by minting tokens upon purchase.
471    * @param _beneficiary Token purchaser
472    * @param _tokenAmount Number of tokens to be minted
473    */
474   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
475     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
476   }
477 }
478 
479 contract O9CoinCrowdsale is  TimedCrowdsale, MintedCrowdsale,Ownable {
480  
481   //decimal value
482   uint256 public constant DECIMAL_FACTOR = 10 ** uint256(18);
483   uint256 public publicAllocationTokens = 100000000*DECIMAL_FACTOR;
484   
485   /**
486  	* @dev O9CoinCrowdsale is a base contract for managing a token crowdsale.
487  	* O9CoinCrowdsale have a start and end timestamps, where investors can make
488  	* token purchases and the crowdsale will assign them tokens based
489  	* on a token per ETH rate. Funds collected are forwarded to a wallet
490  	* as they arrive.
491  	*/
492   
493   function O9CoinCrowdsale(uint256 _starttime, uint256 _endTime, uint256 _rate, address _wallet,ERC20 _token)
494   TimedCrowdsale(_starttime,_endTime)Crowdsale(_rate, _wallet,_token)
495   {
496   }
497     
498   /**
499    * @dev fallback function ***DO NOT OVERRIDE***
500    */
501   function () external payable {
502     buyTokens(msg.sender);
503   }
504   
505   function buyTokens(address _beneficiary) public payable {
506     require(_beneficiary != address(0));
507   
508     uint256 weiAmount = msg.value;
509     // calculate token amount to be created
510     uint256 tokens = weiAmount.mul(rate);
511     publicAllocationTokens=publicAllocationTokens.sub(tokens);
512     // update state
513     weiRaised = weiRaised.add(weiAmount);
514     _processPurchase(_beneficiary, tokens);
515     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
516     _forwardFunds();
517   }
518   
519  /**
520  * @dev Change TokenPrice
521  * @param  _rate is TokenPrice
522  */
523   function changeRate(uint256 _rate) public onlyOwner {
524     require(_rate != 0);
525     rate = _rate;
526 
527 }
528 
529  /**
530  * @dev Change crowdsale OpeningTime 
531  * @param  _startTime is Start time in Seconds
532  */
533   function changeStarttime(uint256 _startTime) public onlyOwner {
534     require(_startTime != 0); 
535     openingTime = _startTime;
536     }
537     
538      /**
539  * @dev Change crowdsale ClosingTime
540  * @param  _endTime is End time in Seconds
541  */
542   function changeEndtime(uint256 _endTime) public onlyOwner {
543     require(_endTime != 0); 
544     closingTime = _endTime;
545     }
546     /**
547  	* @param _to is beneficiary address
548  	* 
549  	* @param _value  Amount if tokens
550  	*   
551  	* @dev  Tokens transfer to beneficiary address only contract creator
552  	*/
553 	function tokenTransferByAdmin(address _to, uint256 _value) onlyOwner {
554         require (_to != 0x0 && _value < publicAllocationTokens);
555         _processPurchase(_to, _value);
556         publicAllocationTokens=publicAllocationTokens.sub(_value);
557        
558     }
559  
560 }