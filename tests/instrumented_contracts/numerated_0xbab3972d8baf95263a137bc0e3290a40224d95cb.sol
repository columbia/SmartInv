1 /**
2     Copyright (c) 2018 Taylor OÜ
3 
4     Permission is hereby granted, free of charge, to any person obtaining a copy
5     of this software and associated documentation files (the "Software"), to deal
6     in the Software without restriction, including without limitation the rights
7     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
8     copies of the Software, and to permit persons to whom the Software is
9     furnished to do so, subject to the following conditions:
10 
11     The above copyright notice and this permission notice shall be included in
12     all copies or substantial portions of the Software.
13 
14     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
15     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
16     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
17     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
18     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
19     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
20     THE SOFTWARE.
21 
22     based on the contracts of OpenZeppelin:
23     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
24 
25 **/
26 
27 pragma solidity ^0.4.18;
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
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
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     if (a == 0) {
79       return 0;
80     }
81     uint256 c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function add(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 
106 /**
107   @title TaylorToken
108 **/
109 contract TaylorToken is Ownable{
110 
111     using SafeMath for uint256;
112 
113     /**
114         EVENTS
115     **/
116     event Transfer(address indexed _from, address indexed _to, uint256 _value);
117     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
118     event Burn(address indexed _owner, uint256 _amount);
119     /**
120         CONTRACT VARIABLES
121     **/
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124 
125     //this address can transfer even when transfer is disabled.
126     mapping (address => bool) public whitelistedTransfer;
127     mapping (address => bool) public whitelistedBurn;
128 
129     string public name = "Taylor";
130     string public symbol = "TAY";
131     uint8 public decimals = 18;
132     uint256 constant internal DECIMAL_CASES = 10**18;
133     uint256 public totalSupply = 10**7 * DECIMAL_CASES;
134     bool public transferable = false;
135 
136     /**
137         MODIFIERS
138     **/
139     modifier onlyWhenTransferable(){
140       if(!whitelistedTransfer[msg.sender]){
141         require(transferable);
142       }
143       _;
144     }
145 
146     /**
147         CONSTRUCTOR
148     **/
149 
150     /**
151       @dev Constructor function executed on contract creation
152     **/
153     function TaylorToken()
154       Ownable()
155       public
156     {
157       balances[owner] = balances[owner].add(totalSupply);
158       whitelistedTransfer[msg.sender] = true;
159       whitelistedBurn[msg.sender] = true;
160       Transfer(address(0),owner, totalSupply);
161     }
162 
163     /**
164         OWNER ONLY FUNCTIONS
165     **/
166 
167     /**
168       @dev Activates the trasfer for all users
169     **/
170     function activateTransfers()
171       public
172       onlyOwner
173     {
174       transferable = true;
175     }
176 
177     /**
178       @dev Allows the owner to add addresse that can bypass the
179       transfer lock. Eg: ICO contract, TGE contract.
180       @param _address address Address to be added
181     **/
182     function addWhitelistedTransfer(address _address)
183       public
184       onlyOwner
185     {
186       whitelistedTransfer[_address] = true;
187     }
188 
189     /**
190       @dev Sends all avaible TAY to the TGE contract to be properly
191       distribute
192       @param _tgeAddress address Address of the token distribution
193       contract
194     **/
195     function distribute(address _tgeAddress)
196       public
197       onlyOwner
198     {
199       whitelistedTransfer[_tgeAddress] = true;
200       transfer(_tgeAddress, balances[owner]);
201     }
202 
203 
204     /**
205       @dev Allows the owner to add addresse that can burn tokens
206       Eg: ICO contract, TGE contract.
207       @param _address address Address to be added
208     **/
209     function addWhitelistedBurn(address _address)
210       public
211       onlyOwner
212     {
213       whitelistedBurn[_address] = true;
214     }
215 
216     /**
217         PUBLIC FUNCTIONS
218     **/
219 
220     /**
221     * @dev transfer token for a specified address
222     * @param _to The address to transfer to.
223     * @param _value The amount to be transferred.
224     */
225     function transfer(address _to, uint256 _value)
226       public
227       onlyWhenTransferable
228       returns (bool success)
229     {
230       require(_to != address(0));
231       require(_value <= balances[msg.sender]);
232 
233       balances[msg.sender] = balances[msg.sender].sub(_value);
234       balances[_to] = balances[_to].add(_value);
235       Transfer(msg.sender, _to, _value);
236       return true;
237     }
238 
239     /**
240    * @dev Transfer tokens from one address to another
241    * @param _from address The address which you want to send tokens from
242    * @param _to address The address which you want to transfer to
243    * @param _value uint256 the amount of tokens to be transferred
244    */
245     function transferFrom
246       (address _from,
247         address _to,
248         uint256 _value)
249         public
250         onlyWhenTransferable
251         returns (bool success) {
252       require(_to != address(0));
253       require(_value <= balances[_from]);
254       require(_value <= allowed[_from][msg.sender]);
255 
256       balances[_from] = balances[_from].sub(_value);
257       balances[_to] = balances[_to].add(_value);
258       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259       Transfer(_from, _to, _value);
260       return true;
261     }
262 
263     /**
264    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265     For security reasons, if one need to change the value from a existing allowance, it must furst sets
266     it to zero and then sets the new value
267 
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271     function approve(address _spender, uint256 _value)
272       public
273       onlyWhenTransferable
274       returns (bool success)
275     {
276       allowed[msg.sender][_spender] = _value;
277       Approval(msg.sender, _spender, _value);
278       return true;
279     }
280 
281       /**
282      * @dev Increase the amount of tokens that an owner allowed to a spender.
283      *
284      * approve should be called when allowed[_spender] == 0. To increment
285      * allowed value is better to use this function to avoid 2 calls (and wait until
286      * the first transaction is mined)
287      * From MonolithDAO Token.sol
288      * @param _spender The address which will spend the funds.
289      * @param _addedValue The amount of tokens to increase the allowance by.
290      */
291     function increaseApproval(address _spender, uint _addedValue)
292       public
293       returns (bool)
294     {
295       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
296       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297       return true;
298     }
299 
300     /**
301      * @dev Decrease the amount of tokens that an owner allowed to a spender.
302      *
303      * approve should be called when allowed[_spender] == 0. To decrement
304      * allowed value is better to use this function to avoid 2 calls (and wait until
305      * the first transaction is mined)
306      * From MonolithDAO Token.sol
307      * @param _spender The address which will spend the funds.
308      * @param _subtractedValue The amount of tokens to decrease the allowance by.
309      */
310     function decreaseApproval(address _spender, uint _subtractedValue)
311       public
312       returns (bool)
313     {
314       uint oldValue = allowed[msg.sender][_spender];
315       if (_subtractedValue > oldValue) {
316         allowed[msg.sender][_spender] = 0;
317       } else {
318         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
319       }
320       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321       return true;
322     }
323 
324     /**
325       @dev Allows for msg.sender to burn his on tokens
326       @param _amount uint256 The amount of tokens to be burned
327     **/
328     function burn(uint256 _amount)
329       public
330       returns (bool success)
331     {
332       require(whitelistedBurn[msg.sender]);
333       require(_amount <= balances[msg.sender]);
334       balances[msg.sender] = balances[msg.sender].sub(_amount);
335       totalSupply =  totalSupply.sub(_amount);
336       Burn(msg.sender, _amount);
337       return true;
338     }
339 
340 
341     /**
342         CONSTANT FUNCTIONS
343     **/
344 
345     /**
346     * @dev Gets the balance of the specified address.
347     * @param _owner The address to query the the balance of.
348     * @return An uint256 representing the amount owned by the passed address.
349     */
350     function balanceOf(address _owner) view public returns (uint256 balance) {
351         return balances[_owner];
352     }
353 
354     /**
355    * @dev Function to check the amount of tokens that an owner allowed to a spender.
356    * @param _owner address The address which owns the funds.
357    * @param _spender address The address which will spend the funds.
358    * @return A uint256 specifying the amount of tokens still available for the spender.
359    */
360     function allowance(address _owner, address _spender)
361       view
362       public
363       returns (uint256 remaining)
364     {
365       return allowed[_owner][_spender];
366     }
367 
368 }
369 
370 
371 /**
372  * @title Pausable
373  * @dev Base contract which allows children to implement an emergency stop mechanism.
374  */
375 contract Pausable is Ownable {
376   event Pause();
377   event Unpause();
378 
379   bool public paused = false;
380 
381 
382   /**
383    * @dev Modifier to make a function callable only when the contract is not paused.
384    */
385   modifier whenNotPaused() {
386     require(!paused);
387     _;
388   }
389 
390   /**
391    * @dev Modifier to make a function callable only when the contract is paused.
392    */
393   modifier whenPaused() {
394     require(paused);
395     _;
396   }
397 
398   /**
399    * @dev called by the owner to pause, triggers stopped state
400    */
401   function pause() onlyOwner whenNotPaused public {
402     paused = true;
403     Pause();
404   }
405 
406   /**
407    * @dev called by the owner to unpause, returns to normal state
408    */
409   function unpause() onlyOwner whenPaused public {
410     paused = false;
411     Unpause();
412   }
413 }
414 
415 
416 /**
417   @title Crowdsale
418 
419 **/
420 contract Crowdsale is Ownable, Pausable {
421 
422   using SafeMath for uint256;
423 
424   /**
425       EVENTS
426   **/
427   event Purchase(address indexed buyer, uint256 weiAmount, uint256 tokenAmount);
428   event Finalized(uint256 tokensSold, uint256 weiAmount);
429 
430   /**
431       CONTRACT VARIABLES
432   **/
433   TaylorToken public taylorToken;
434 
435   uint256 public startTime;
436   uint256 public endTime;
437   uint256 public weiRaised;
438   uint256 public tokensSold;
439   uint256 public tokenCap;
440   uint256 public poolEthSold;
441   bool public finalized;
442   address public wallet;
443 
444   uint256 public maxGasPrice = 50000000000;
445 
446   uint256[4] public rates;
447 
448   mapping (address => bool) public whitelisted;
449   mapping (address => bool) public whitelistedPools;
450   mapping (address => uint256) public contributors;
451 
452   /**
453       PUBLIC CONSTANTS
454   **/
455   uint256 public constant poolEthCap = 1250 ether;
456   uint256 public constant minimumPoolPurchase = 100 ether;
457   uint256 public constant minimumPurchase = 0.01 ether;
458   uint256 public constant maximumPoolPurchase = 250 ether;
459   uint256 public constant maximumPurchase = 50 ether;
460   uint256 public constant specialPoolsRate = 600000000000000;
461 
462 
463 
464   /**
465       CONSTRUCTOR
466   **/
467 
468   /**
469     @dev ICO CONSTRUCTOR
470     @param _startTime uint256 timestamp that the sale will begin
471     @param _duration uint256  how long(in days) the sale will last
472     @param _tokenCap uint256 How many tokens will be sold sale
473     @param _token address the address of the token contract
474     @param _wallet address the address of the wallet that will recieve funds
475   **/
476   function Crowdsale(
477     uint256 _startTime,
478     uint256 _duration,
479     uint256 _tokenCap,
480     address _token,
481     address _wallet)
482     public
483   {
484     require(_startTime >= now);
485     require(_token != address(0));
486     require(_wallet != address(0));
487 
488     taylorToken = TaylorToken(_token);
489 
490     startTime = _startTime;
491     endTime = startTime + _duration * 1 seconds ;
492     wallet = _wallet;
493     tokenCap = _tokenCap;
494     rates = [700000000000000, 790000000000000, 860000000000000, 930000000000000];
495   }
496 
497 
498   /**
499       PUBLIC FUNCTIONS
500 
501   **/
502 
503   /**
504     @dev Fallback function that accepts eth and buy tokens
505   **/
506   function () payable whenNotPaused public {
507     buyTokens();
508   }
509 
510   /**
511     @dev Allows participants to buy tokens
512   **/
513   function buyTokens() payable whenNotPaused public {
514     require(isValidPurchase());
515 
516     uint256 tokens;
517     uint256 amount = msg.value;
518 
519 
520     if(whitelistedPools[msg.sender] && poolEthSold.add(amount) > poolEthCap){
521       uint256 validAmount = poolEthCap.sub(poolEthSold);
522       require(validAmount > 0);
523       uint256 ch = amount.sub(validAmount);
524       msg.sender.transfer(ch);
525       amount = validAmount;
526     }
527 
528     tokens  = calculateTokenAmount(amount);
529 
530 
531     uint256 tokenPool = tokensSold.add(tokens);
532     if(tokenPool > tokenCap){
533       uint256 possibleTokens = tokenCap.sub(tokensSold);
534       uint256 change = calculatePriceForTokens(tokens.sub(possibleTokens));
535       msg.sender.transfer(change);
536       tokens = possibleTokens;
537       amount = amount.sub(change);
538     }
539 
540 
541 
542     contributors[msg.sender] = contributors[msg.sender].add(amount);
543     taylorToken.transfer(msg.sender, tokens);
544 
545     tokensSold = tokensSold.add(tokens);
546     weiRaised = weiRaised.add(amount);
547     if(whitelistedPools[msg.sender]){
548       poolEthSold = poolEthSold.add(amount);
549     }
550 
551 
552     forwardFunds(amount);
553     Purchase(msg.sender, amount, tokens);
554 
555     if(tokenCap.sub(tokensSold) < calculateTokenAmount(minimumPurchase)){
556       finalizeSale();
557     }
558   }
559 
560   /**
561     @dev Allows owner to add addresses to the whitelisted
562     @param _address address The address to be added
563     @param isPool bool Indicating if address represents a buying pool
564   **/
565   function addWhitelisted(address _address, bool isPool)
566     public
567     onlyOwner
568     whenNotPaused
569   {
570     if(isPool) {
571       whitelistedPools[_address] = true;
572     } else {
573       whitelisted[_address] = true;
574     }
575   }
576 
577   /**
578     @dev allows the owner to change the max gas price
579     @param _gasPrice uint256 the new maximum gas price
580   **/
581   function changeMaxGasprice(uint256 _gasPrice)
582     public
583     onlyOwner
584     whenNotPaused
585   {
586     maxGasPrice = _gasPrice;
587   }
588 
589   /**
590     @dev Triggers the finalization process
591   **/
592   function endSale() whenNotPaused public {
593     require(finalized ==  false);
594     require(now > endTime);
595     finalizeSale();
596   }
597 
598   /**
599       INTERNAL FUNCTIONS
600 
601   **/
602 
603   /**
604     @dev Checks if purchase is valid
605     @return Bool Indicating if purchase is valid
606   **/
607   function isValidPurchase() view internal returns(bool valid) {
608     require(now >= startTime && now <= endTime);
609     require(msg.value >= minimumPurchase);
610     require(tx.gasprice <= maxGasPrice);
611     uint256 week = getCurrentWeek();
612     if(week == 0 && whitelistedPools[msg.sender]){
613       require(msg.value >= minimumPoolPurchase);
614       require(contributors[msg.sender].add(msg.value) <= maximumPoolPurchase);
615     } else {
616       require(whitelisted[msg.sender] || whitelistedPools[msg.sender]);
617       require(contributors[msg.sender].add(msg.value) <= maximumPurchase);
618     }
619     return true;
620   }
621 
622 
623 
624   /**
625     @dev Internal function that redirects recieved funds to wallet
626     @param _amount uint256 The amount to be fowarded
627   **/
628   function forwardFunds(uint256 _amount) internal {
629     wallet.transfer(_amount);
630   }
631 
632   /**
633     @dev Calculates the amount of tokens that buyer will recieve
634     @param weiAmount uint256 The amount, in Wei, that will be bought
635     @return uint256 Representing the amount of tokens that weiAmount buys in
636     the current stage of the sale
637   **/
638   function calculateTokenAmount(uint256 weiAmount) view internal returns(uint256 tokenAmount){
639     uint256 week = getCurrentWeek();
640     if(week == 0 && whitelistedPools[msg.sender]){
641       return weiAmount.mul(10**18).div(specialPoolsRate);
642     }
643     return weiAmount.mul(10**18).div(rates[week]);
644   }
645 
646   /**
647     @dev Calculates wei cost of specific amount of tokens
648     @param tokenAmount uint256 The amount of tokens to be calculated
649     @return uint256 Representing the total cost, in wei, for tokenAmount
650   **/
651   function calculatePriceForTokens(uint256 tokenAmount) view internal returns(uint256 weiAmount){
652     uint256 week = getCurrentWeek();
653     return tokenAmount.div(10**18).mul(rates[week]);
654   }
655 
656   /**
657     @dev Checks the current week in the sale. It's zero indexed, so the first
658     week returns 0, the sencond 1, and so forth.
659     @return Uint representing the current week
660   **/
661   function getCurrentWeek() view internal returns(uint256 _week){
662     uint256 week = (now.sub(startTime)).div(1 weeks);
663     if(week > 3){
664       week = 3;
665     }
666     return week;
667   }
668 
669   /**
670     @dev Triggers the sale finalizations process
671   **/
672   function finalizeSale() internal {
673     taylorToken.burn(taylorToken.balanceOf(this));
674     finalized = true;
675     Finalized(tokensSold, weiRaised);
676   }
677 
678   /**
679       READ ONLY FUNCTIONS
680 
681   **/
682 
683   /**
684     @dev Give the current rate(in Wei) that buys exactly one token
685   **/
686   function getCurrentRate() view public returns(uint256 _rate){
687     return rates[getCurrentWeek()];
688   }
689 
690 
691 }