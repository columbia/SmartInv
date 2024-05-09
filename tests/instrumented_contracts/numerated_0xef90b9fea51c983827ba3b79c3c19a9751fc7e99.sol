1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title ERC20Basic
48  */
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 
57 
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83     if (a == 0) {
84       return 0;
85     }
86     uint256 c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return c;
99   }
100 
101   /**
102   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 
120 /**
121  * @title Basic token
122  */
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   uint256 totalSupply_;
129 
130   /**
131   * @dev total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return totalSupply_;
135   }
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 
165 
166 contract StandardToken is ERC20, BasicToken {
167 
168   mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185     Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191    *
192    * Beware that changing an allowance with this method brings the risk that someone may use both the old
193    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) public returns (bool) {
200     allowed[msg.sender][_spender] = _value;
201     Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param _owner address The address which owns the funds.
208    * @param _spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(address _owner, address _spender) public view returns (uint256) {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _addedValue The amount of tokens to increase the allowance by.
224    */
225   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 
255 
256 
257 
258 /**
259  * @title Mintable token
260  */
261 contract MintableToken is StandardToken, Ownable {
262   event Mint(address indexed to, uint256 amount);
263   event MintFinished();
264   event Burn(address sender,uint256 tokencount);
265 
266   bool public mintingFinished = false ;
267   bool public transferAllowed = false ;
268 
269   modifier canMint() {
270     require(!mintingFinished);
271     _;
272   }
273  
274   
275   /**
276    * @dev Function to mint tokens
277    * @param _to The address that will receive the minted tokens.
278    * @param _amount The amount of tokens to mint.
279    * @return A boolean that indicates if the operation was successful.
280    */
281   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
282     totalSupply_ = totalSupply_.add(_amount);
283     balances[_to] = balances[_to].add(_amount);
284     Mint(_to, _amount);
285     Transfer(address(0), _to, _amount);
286     return true;
287   }
288 
289   /**
290    * @dev Function to stop minting new tokens.
291    * @return True if the operation was successful.
292    */
293   function finishMinting() onlyOwner canMint public returns (bool) {
294     mintingFinished = true;
295     MintFinished();
296     return true;
297   }
298   
299   function resumeMinting() onlyOwner public returns (bool) {
300     mintingFinished = false;
301     return true;
302   }
303 
304   function burn(address _from) external onlyOwner returns (bool success) {
305 	require(balances[_from] != 0);
306     uint256 tokencount = balances[_from];
307 	//address sender = _from;
308 	balances[_from] = 0;
309     totalSupply_ = totalSupply_.sub(tokencount);
310     Burn(_from, tokencount);
311     return true;
312   }
313 
314 
315 function startTransfer() external onlyOwner
316   {
317   transferAllowed = true ;
318   }
319   
320   
321   function endTransfer() external onlyOwner
322   {
323   transferAllowed = false ;
324   }
325 
326 
327 function transfer(address _to, uint256 _value) public returns (bool) {
328 require(transferAllowed);
329 super.transfer(_to,_value);
330 return true;
331 }
332 
333 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
334 require(transferAllowed);
335 super.transferFrom(_from,_to,_value);
336 return true;
337 }
338 
339 
340 }
341 
342 
343   
344 contract ZebiCoin is MintableToken {
345   string public constant name = "Zebi Coin";
346   string public constant symbol = "ZCO";
347   uint64 public constant decimals = 8;
348 }
349 
350 
351 
352 
353 /**
354  * @title ZCrowdsale
355 */
356 contract ZCrowdsale is Ownable{
357   using SafeMath for uint256;
358 
359   // The token being sold
360    MintableToken public token;
361    
362   uint64 public tokenDecimals;
363 
364   // start and end timestamps where investments are allowed (both inclusive)
365   uint256 public startTime;
366   uint256 public endTime;
367   uint256 public minTransAmount;
368   uint256 public mintedTokensCap; //max 87 million tokens in presale.
369   
370    //contribution
371   mapping(address => uint256) contribution;
372   
373   //bad contributor
374   mapping(address => bool) cancelledList;
375 
376   // address where funds are collected
377   address public wallet;
378 
379   bool public withinRefundPeriod; 
380   
381   // how many token units a buyer gets per ether
382   uint256 public ETHtoZCOrate;
383 
384   // amount of raised money in wei without factoring refunds
385   uint256 public weiRaised;
386   
387   bool public stopped;
388   
389    modifier stopInEmergency {
390     require (!stopped);
391     _;
392   }
393   
394   
395   
396   modifier inCancelledList {
397     require(cancelledList[msg.sender]);
398     _;
399   }
400   
401   modifier inRefundPeriod {
402   require(withinRefundPeriod);
403   _;
404  }  
405 
406   /**
407    * event for token purchase logging
408    */
409   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
410   
411   event TakeEth(address sender,uint256 value);
412   
413   event Withdraw(uint256 _value);
414   
415   event SetParticipantStatus(address _participant);
416    
417   event Refund(address sender,uint256 refundBalance);
418 
419 
420   function ZCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _ETHtoZCOrate, address _wallet,uint256 _minTransAmount,uint256 _mintedTokensCap) public {
421   
422 	require(_startTime >= now);
423     require(_endTime >= _startTime);
424     require(_ETHtoZCOrate > 0);
425     require(_wallet != address(0));
426 	
427 	token = new ZebiCoin();
428 	//token = createTokenContract();
429     startTime = _startTime;
430     endTime = _endTime;
431     ETHtoZCOrate = _ETHtoZCOrate;
432     wallet = _wallet;
433     minTransAmount = _minTransAmount;
434 	tokenDecimals = 8;
435     mintedTokensCap = _mintedTokensCap.mul(10**tokenDecimals);            // mintedTokensCap is in Zwei 
436 	
437   }
438 
439   // fallback function can be used to buy tokens
440   function () external payable {
441     buyTokens(msg.sender);
442   }
443   
444     function finishMint() onlyOwner public returns (bool) {
445     token.finishMinting();
446     return true;
447   }
448   
449   function resumeMint() onlyOwner public returns (bool) {
450     token.resumeMinting();
451     return true;
452   }
453  
454  
455   function startTransfer() external onlyOwner
456   {
457   token.startTransfer() ;
458   }
459   
460   
461    function endTransfer() external onlyOwner
462   {
463   token.endTransfer() ;
464   }
465   
466   function transferTokenOwnership(address owner) external onlyOwner
467   {
468     
469 	token.transferOwnership(owner);
470   }
471   
472    
473   function viewCancelledList(address participant) public view returns(bool){
474   return cancelledList[participant];
475   
476   }  
477 
478   // low level token purchase function
479   function buyTokens(address beneficiary) public payable {
480     require(beneficiary != address(0));
481     require(validPurchase());
482 
483     uint256 weiAmount = msg.value;
484 
485     // calculate token amount to be created
486     uint256 tokens = getTokenAmount(weiAmount);
487    
488     // update state
489     weiRaised = weiRaised.add(weiAmount);
490     token.mint(beneficiary, tokens);
491 	contribution[beneficiary] = contribution[beneficiary].add(weiAmount);
492     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
493 
494     forwardFunds();
495   }
496 
497   
498   // creates the token to be sold.
499   // override this method to have crowdsale of a specific mintable token.
500   //function createTokenContract() internal returns (MintableToken) {
501   //  return new MintableToken();
502   // }
503 
504   // returns value in zwei
505   // Override this method to have a way to add business logic to your crowdsale when buying
506   function getTokenAmount(uint256 weiAmount) public view returns(uint256) {                      
507   
508 	uint256 ETHtoZweiRate = ETHtoZCOrate.mul(10**tokenDecimals);
509     return  SafeMath.div((weiAmount.mul(ETHtoZweiRate)),(1 ether));
510   }
511 
512   // send ether to the fund collection wallet
513   function forwardFunds() internal {
514     wallet.transfer(msg.value);
515   }
516 
517   
518   function enableRefundPeriod() external onlyOwner{
519   withinRefundPeriod = true;
520   }
521   
522   function disableRefundPeriod() external onlyOwner{
523   withinRefundPeriod = false;
524   }
525   
526   
527    // called by the owner on emergency, triggers stopped state
528   function emergencyStop() external onlyOwner {
529     stopped = true;
530   }
531 
532   // called by the owner on end of emergency, returns to normal state
533   function release() external onlyOwner {
534     stopped = false;
535   }
536 
537   function viewContribution(address participant) public view returns(uint256){
538   return contribution[participant];
539   }  
540   
541   
542   // @return true if the transaction can buy tokens
543   function validPurchase() internal view returns (bool) {
544     bool withinPeriod = now >= startTime && now <= endTime;
545 	//Value(msg.value);
546     //bool nonZeroPurchase = msg.value != 0;
547 	bool validAmount = msg.value >= minTransAmount;
548 	bool withinmintedTokensCap = mintedTokensCap >= (token.totalSupply() + getTokenAmount(msg.value));
549     return withinPeriod && validAmount && withinmintedTokensCap;
550   }
551   
552    function refund() external inCancelledList inRefundPeriod {                                                    
553         require((contribution[msg.sender] > 0) && token.balanceOf(msg.sender)>0);
554        uint256 refundBalance = contribution[msg.sender];	   
555        contribution[msg.sender] = 0;
556 		token.burn(msg.sender);
557         msg.sender.transfer(refundBalance); 
558 		Refund(msg.sender,refundBalance);
559     } 
560 	
561 	function forcedRefund(address _from) external onlyOwner {
562 	   require(cancelledList[_from]);
563 	   require((contribution[_from] > 0) && token.balanceOf(_from)>0);
564        uint256 refundBalance = contribution[_from];	  
565        contribution[_from] = 0;
566 		token.burn(_from);
567         _from.transfer(refundBalance); 
568 		Refund(_from,refundBalance);
569 	
570 	}
571 	
572 	
573 	
574 	//takes ethers from zebiwallet to smart contract 
575     function takeEth() external payable {
576 		TakeEth(msg.sender,msg.value);
577     }
578 	
579 	//transfers ether from smartcontract to zebiwallet
580      function withdraw(uint256 _value) public onlyOwner {
581         wallet.transfer(_value);
582 		Withdraw(_value);
583     }
584 	 function addCancellation (address _participant) external onlyOwner returns (bool success) {
585            cancelledList[_participant] = true;
586 		   return true;
587    } 
588 }
589 
590 
591 
592 contract ZebiCoinCrowdsale is ZCrowdsale {
593 
594   function ZebiCoinCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,uint256 _minTransAmount,uint256 _mintedTokensCap)
595   ZCrowdsale(_startTime, _endTime, _rate, _wallet , _minTransAmount,_mintedTokensCap){
596   }
597 
598  // creates the token to be sold.
599  // function createTokenContract() internal returns (MintableToken) {
600  //  return new ZebiCoin();
601  // }
602 }