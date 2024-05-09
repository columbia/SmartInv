1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) public onlyOwner {
64     require(newOwner != address(0));
65     OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 /**
72  * @title Pausable
73  * @dev Base contract which allows children to implement an emergency stop mechanism.
74  */
75 contract Pausable is Ownable {
76   event Pause();
77   event Unpause();
78 
79   bool public paused = false;
80 
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is not paused.
84    */
85   modifier whenNotPaused() {
86     require(!paused);
87     _;
88   }
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is paused.
92    */
93   modifier whenPaused() {
94     require(paused);
95     _;
96   }
97 
98   /**
99    * @dev called by the owner to pause, triggers stopped state
100    */
101   function pause() onlyOwner whenNotPaused public {
102     paused = true;
103     Pause();
104   }
105 
106   /**
107    * @dev called by the owner to unpause, returns to normal state
108    */
109   function unpause() onlyOwner whenPaused public {
110     paused = false;
111     Unpause();
112   }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   uint256 public totalSupply;
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public view returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 /**
139  * @title Basic token
140  * @dev Basic version of StandardToken, with no allowances.
141  */
142 contract BasicToken is ERC20Basic {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[msg.sender]);
155 
156     // SafeMath.sub will throw if there is not enough balance.
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256 balance) {
169     return balances[_owner];
170   }
171 
172 }
173 
174 contract StandardToken is ERC20, BasicToken {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    *
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(address _owner, address _spender) public view returns (uint256) {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
234     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 
263 contract MintableToken is StandardToken, Ownable {
264   event Mint(address indexed to, uint256 amount);
265   event MintFinished();
266 
267   bool public mintingFinished = false;
268 
269 
270   modifier canMint() {
271     require(!mintingFinished);
272     _;
273   }
274 
275   /**
276    * @dev Function to mint tokens
277    * @param _to The address that will receive the minted tokens.
278    * @param _amount The amount of tokens to mint.
279    * @return A boolean that indicates if the operation was successful.
280    */
281   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
282     totalSupply = totalSupply.add(_amount);
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
298 }
299 
300 
301 /**
302  * @title ICOToken
303  * @dev Very simple ERC20 Token example.
304  * `StandardToken` functions.
305  */
306 contract ICOToken is MintableToken, Pausable {
307 
308   string public constant name = "IPCHAIN Token";
309   string public constant symbol = "IP";
310   uint8 public constant decimals = 18;
311 
312 
313   /**
314    * @dev Constructor that gives msg.sender all of existing tokens.
315    */
316   function ICOToken() public {
317   }
318 }
319 
320 contract Crowdsale {
321   using SafeMath for uint256;
322 
323   // The token being sold
324   MintableToken public token;
325 
326   // start and end timestamps where investments are allowed (both inclusive)
327   uint256 public startTime;
328   uint256 public endTime;
329 
330   // address where funds are collected
331   address public wallet;
332 
333   // how many token units a buyer gets per wei
334   uint256 public rate;
335 
336   // amount of raised money in wei
337   uint256 public weiRaised;
338 
339   /**
340    * event for token purchase logging
341    * @param purchaser who paid for the tokens
342    * @param beneficiary who got the tokens
343    * @param value weis paid for purchase
344    * @param amount amount of tokens purchased
345    */
346   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
347 
348 
349   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
350     require(_startTime >= now);
351     require(_endTime >= _startTime);
352     require(_rate > 0);
353     require(_wallet != address(0));
354 
355     token = createTokenContract();
356     startTime = _startTime;
357     endTime = _endTime;
358     rate = _rate;
359     wallet = _wallet;
360   }
361 
362   // creates the token to be sold.
363   // override this method to have crowdsale of a specific mintable token.
364   function createTokenContract() internal returns (MintableToken) {
365     return new MintableToken();
366   }
367 
368   // fallback function can be used to buy tokens
369   function () external payable {
370     buyTokens(msg.sender);
371   }
372 
373   // Override this method to have a way to add business logic to your crowdsale when buying
374   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
375     return weiAmount.mul(rate);
376   }
377 
378   // low level token purchase function
379   function buyTokens(address beneficiary) public payable {
380     require(beneficiary != address(0));
381     require(validPurchase());
382 
383     uint256 weiAmount = msg.value;
384 
385     // calculate token amount to be created
386     uint256 tokens = getTokenAmount(weiAmount);
387 
388     // update state
389     weiRaised = weiRaised.add(weiAmount);
390 
391     token.mint(beneficiary, tokens);
392     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
393 
394     forwardFunds();
395   }
396 
397   // send ether to the fund collection wallet
398   // override to create custom fund forwarding mechanisms
399   function forwardFunds() internal {
400     wallet.transfer(msg.value);
401   }
402 
403   // @return true if the transaction can buy tokens
404   function validPurchase() internal view returns (bool) {
405     bool withinPeriod = now >= startTime && now <= endTime;
406     bool nonZeroPurchase = msg.value != 0;
407     return withinPeriod && nonZeroPurchase;
408   }
409 
410   // @return true if crowdsale event has ended
411   function hasEnded() public view returns (bool) {
412     return now > endTime;
413   }
414 
415 
416 }
417 
418 /**
419  * @title FinalizableCrowdsale
420  * @dev Extension of Crowdsale where an owner can do extra work
421  * after finishing.
422  */
423 contract FinalizableCrowdsale is Crowdsale, Ownable {
424   using SafeMath for uint256;
425 
426   bool public isFinalized = false;
427 
428   event Finalized();
429 
430   /**
431    * @dev Must be called after crowdsale ends, to do some extra finalization
432    * work. Calls the contract's finalization function.
433    */
434   function finalize() onlyOwner public {
435     require(!isFinalized);
436     require(hasEnded());
437 
438     finalization();
439     Finalized();
440 
441     isFinalized = true;
442   }
443 
444   /**
445    * @dev Can be overridden to add finalization logic. The overriding function
446    * should call super.finalization() to ensure the chain of finalization is
447    * executed entirely.
448    */
449   function finalization() internal {
450   }
451 }
452 
453 /**
454  * @title CappedCrowdsale
455  * @dev Extension of Crowdsale with a max amount of funds raised
456  */
457 contract CappedCrowdsale is Crowdsale {
458   using SafeMath for uint256;
459 
460   uint256 public cap;
461 
462   function CappedCrowdsale(uint256 _cap) public {
463     require(_cap > 0);
464     cap = _cap;
465   }
466 
467   // overriding Crowdsale#validPurchase to add extra cap logic
468   // @return true if investors can buy at the moment
469   function validPurchase() internal view returns (bool) {
470     bool withinCap = weiRaised.add(msg.value) <= cap;
471     return super.validPurchase() && withinCap;
472   }
473 
474   // overriding Crowdsale#hasEnded to add cap logic
475   // @return true if crowdsale event has ended
476   function hasEnded() public view returns (bool) {
477     bool capReached = weiRaised >= cap;
478     return super.hasEnded() || capReached;
479   }
480 
481 }
482 
483 contract ICOCrowdsale is Ownable, Pausable, FinalizableCrowdsale {
484 
485   uint256 constant PRESALE_CAP = 2727 ether;
486   uint256 constant PRESALE_RATE = 316;
487   uint256 constant PRESALE_DURATION = 23 days;
488 
489   uint256 constant MAIN_SALE_START = 1527771600;
490   uint256 constant BONUS_1_CAP = PRESALE_CAP + 3636 ether;
491   uint256 constant BONUS_1_RATE = 292;
492 
493   uint256 constant BONUS_2_CAP = BONUS_1_CAP + 7273 ether;
494   uint256 constant BONUS_2_RATE = 269;
495 
496   uint256 constant BONUS_3_CAP = BONUS_2_CAP + 9091 ether;
497   uint256 constant BONUS_3_RATE = 257;
498 
499   uint256 constant BONUS_4_CAP = BONUS_3_CAP + 10909 ether;
500   uint256 constant BONUS_4_RATE = 245;
501 
502   uint256 constant NORMAL_RATE = 234;
503 
504   address tokenAddress;
505 
506   event LogBountyTokenMinted(address minter, address beneficiary, uint256 amount);
507 
508   function ICOCrowdsale(uint256 _startTime, uint256 _endTime, address _wallet, address _tokenAddress) public
509     FinalizableCrowdsale()
510     Crowdsale(_startTime, _endTime, NORMAL_RATE, _wallet)
511   {
512     require((_endTime-_startTime) > (15 * 1 days));
513     require(_tokenAddress != address(0x0));
514     tokenAddress = _tokenAddress;
515     token = createTokenContract();
516   }
517 
518   /**
519    * Invoked on initialization of the contract
520    */
521   function createTokenContract() internal returns (MintableToken) {
522     return ICOToken(tokenAddress);
523   }
524 
525   function finalization() internal {
526     super.finalization();
527 
528     // Un/Comment this if you have/have not paused the token contract
529     ICOToken _token = ICOToken(token);
530     if(_token.paused()) {
531       _token.unpause();
532     }
533     _token.transferOwnership(owner);
534   }
535 
536   function buyTokens(address beneficiary) public payable {
537     uint256 minContributionAmount = 1 finney; // 0.001 ETH
538     require(msg.value >= minContributionAmount);
539     super.buyTokens(beneficiary);
540   }
541 
542   function getRate() internal constant returns(uint256) {
543     // Pre-sale Period
544     if (now < (startTime + PRESALE_DURATION)) {
545       require(weiRaised <= PRESALE_CAP);
546       return PRESALE_RATE;
547     }
548 
549     // Main sale
550     require(now >= MAIN_SALE_START);
551 
552     // First Bonus Period
553     if (weiRaised <= BONUS_1_CAP) {
554         return BONUS_1_RATE;
555     }
556 
557     // Second Bonus Period
558     if (weiRaised <= BONUS_2_CAP) {
559         return BONUS_2_RATE;
560     }
561 
562     // Third Bonus Period
563     if (weiRaised <= BONUS_3_CAP) {
564         return BONUS_3_RATE;
565     }
566 
567     // Fourth Bonus Period
568     if (weiRaised <= BONUS_4_CAP) {
569         return BONUS_4_RATE;
570     }
571 
572     // Default Period
573     return rate;
574   }
575 
576   function getTokenAmount(uint256 weiAmount) internal constant returns(uint256) {
577     uint256 _rate = getRate();
578     return weiAmount.mul(_rate);
579   }
580 
581   function createBountyToken(address beneficiary, uint256 amount) public onlyOwner returns(bool) {
582     require(!hasEnded());
583     token.mint(beneficiary, amount);
584     LogBountyTokenMinted(msg.sender, beneficiary, amount);
585     return true;
586   }
587 
588 }
589 
590 contract ICOCappedRefundableCrowdsale is CappedCrowdsale, ICOCrowdsale {
591 
592 
593   function ICOCappedRefundableCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _cap, address _wallet, address _tokenAddress) public
594   	FinalizableCrowdsale()
595     ICOCrowdsale(_startTime, _endTime, _wallet, _tokenAddress)
596 	CappedCrowdsale(_cap)
597 	{
598 	}
599 
600 }