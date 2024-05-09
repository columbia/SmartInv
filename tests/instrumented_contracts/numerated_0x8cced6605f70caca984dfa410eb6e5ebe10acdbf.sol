1 /**
2     Copyright (c) 2018 SmartTaylor
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
27 pragma solidity 0.4.18;
28 
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82     uint256 c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 /**
107     Copyright (c) 2018 SmartTaylor
108 
109     Permission is hereby granted, free of charge, to any person obtaining a copy
110     of this software and associated documentation files (the "Software"), to deal
111     in the Software without restriction, including without limitation the rights
112     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
113     copies of the Software, and to permit persons to whom the Software is
114     furnished to do so, subject to the following conditions:
115 
116     The above copyright notice and this permission notice shall be included in
117     all copies or substantial portions of the Software.
118 
119     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
120     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
121     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
122     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
123     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
124     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
125     THE SOFTWARE.
126 
127     based on the contracts of OpenZeppelin:
128     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
129 
130 **/
131 
132 
133 
134 
135 
136 
137 /**
138   @title TaylorToken
139 **/
140 contract TaylorToken is Ownable{
141 
142     using SafeMath for uint256;
143 
144     /**
145         EVENTS
146     **/
147     event Transfer(address indexed _from, address indexed _to, uint256 _value);
148     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
149     event Burn(address indexed _owner, uint256 _amount);
150     /**
151         CONTRACT VARIABLES
152     **/
153     mapping (address => uint256) balances;
154     mapping (address => mapping (address => uint256)) allowed;
155 
156     //this address can transfer even when transfer is disabled.
157     mapping (address => bool) public whitelistedTransfer;
158     mapping (address => bool) public whitelistedBurn;
159 
160     string public name = "Taylor";
161     string public symbol = "TAY";
162     uint8 public decimals = 18;
163     uint256 constant internal DECIMAL_CASES = 10**18;
164     uint256 public totalSupply = 10**7 * DECIMAL_CASES;
165     bool public transferable = false;
166 
167     /**
168         MODIFIERS
169     **/
170     modifier onlyWhenTransferable(){
171       if(!whitelistedTransfer[msg.sender]){
172         require(transferable);
173       }
174       _;
175     }
176 
177     /**
178         CONSTRUCTOR
179     **/
180 
181     /**
182       @dev Constructor function executed on contract creation
183     **/
184     function TaylorToken()
185       Ownable()
186       public
187     {
188       balances[owner] = balances[owner].add(totalSupply);
189       whitelistedTransfer[msg.sender] = true;
190       whitelistedBurn[msg.sender] = true;
191       Transfer(address(0),owner, totalSupply);
192     }
193 
194     /**
195         OWNER ONLY FUNCTIONS
196     **/
197 
198     /**
199       @dev Activates the trasfer for all users
200     **/
201     function activateTransfers()
202       public
203       onlyOwner
204     {
205       transferable = true;
206     }
207 
208     /**
209       @dev Allows the owner to add addresse that can bypass the
210       transfer lock. Eg: ICO contract, TGE contract.
211       @param _address address Address to be added
212     **/
213     function addWhitelistedTransfer(address _address)
214       public
215       onlyOwner
216     {
217       whitelistedTransfer[_address] = true;
218     }
219 
220     /**
221       @dev Sends all avaible TAY to the TGE contract to be properly
222       distribute
223       @param _tgeAddress address Address of the token distribution
224       contract
225     **/
226     function distribute(address _tgeAddress)
227       public
228       onlyOwner
229     {
230       whitelistedTransfer[_tgeAddress] = true;
231       transfer(_tgeAddress, balances[owner]);
232     }
233 
234 
235     /**
236       @dev Allows the owner to add addresse that can burn tokens
237       Eg: ICO contract, TGE contract.
238       @param _address address Address to be added
239     **/
240     function addWhitelistedBurn(address _address)
241       public
242       onlyOwner
243     {
244       whitelistedBurn[_address] = true;
245     }
246 
247     /**
248         PUBLIC FUNCTIONS
249     **/
250 
251     /**
252     * @dev transfer token for a specified address
253     * @param _to The address to transfer to.
254     * @param _value The amount to be transferred.
255     */
256     function transfer(address _to, uint256 _value)
257       public
258       onlyWhenTransferable
259       returns (bool success)
260     {
261       require(_to != address(0));
262       require(_value <= balances[msg.sender]);
263 
264       balances[msg.sender] = balances[msg.sender].sub(_value);
265       balances[_to] = balances[_to].add(_value);
266       Transfer(msg.sender, _to, _value);
267       return true;
268     }
269 
270     /**
271    * @dev Transfer tokens from one address to another
272    * @param _from address The address which you want to send tokens from
273    * @param _to address The address which you want to transfer to
274    * @param _value uint256 the amount of tokens to be transferred
275    */
276     function transferFrom
277       (address _from,
278         address _to,
279         uint256 _value)
280         public
281         onlyWhenTransferable
282         returns (bool success) {
283       require(_to != address(0));
284       require(_value <= balances[_from]);
285       require(_value <= allowed[_from][msg.sender]);
286 
287       balances[_from] = balances[_from].sub(_value);
288       balances[_to] = balances[_to].add(_value);
289       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
290       Transfer(_from, _to, _value);
291       return true;
292     }
293 
294     /**
295    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
296     For security reasons, if one need to change the value from a existing allowance, it must furst sets
297     it to zero and then sets the new value
298 
299    * @param _spender The address which will spend the funds.
300    * @param _value The amount of tokens to be spent.
301    */
302     function approve(address _spender, uint256 _value)
303       public
304       onlyWhenTransferable
305       returns (bool success)
306     {
307       allowed[msg.sender][_spender] = _value;
308       Approval(msg.sender, _spender, _value);
309       return true;
310     }
311 
312       /**
313      * @dev Increase the amount of tokens that an owner allowed to a spender.
314      *
315      * approve should be called when allowed[_spender] == 0. To increment
316      * allowed value is better to use this function to avoid 2 calls (and wait until
317      * the first transaction is mined)
318      * From MonolithDAO Token.sol
319      * @param _spender The address which will spend the funds.
320      * @param _addedValue The amount of tokens to increase the allowance by.
321      */
322     function increaseApproval(address _spender, uint _addedValue)
323       public
324       returns (bool)
325     {
326       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
327       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328       return true;
329     }
330 
331     /**
332      * @dev Decrease the amount of tokens that an owner allowed to a spender.
333      *
334      * approve should be called when allowed[_spender] == 0. To decrement
335      * allowed value is better to use this function to avoid 2 calls (and wait until
336      * the first transaction is mined)
337      * From MonolithDAO Token.sol
338      * @param _spender The address which will spend the funds.
339      * @param _subtractedValue The amount of tokens to decrease the allowance by.
340      */
341     function decreaseApproval(address _spender, uint _subtractedValue)
342       public
343       returns (bool)
344     {
345       uint oldValue = allowed[msg.sender][_spender];
346       if (_subtractedValue > oldValue) {
347         allowed[msg.sender][_spender] = 0;
348       } else {
349         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
350       }
351       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
352       return true;
353     }
354 
355     /**
356       @dev Allows for msg.sender to burn his on tokens
357       @param _amount uint256 The amount of tokens to be burned
358     **/
359     function burn(uint256 _amount)
360       public
361       returns (bool success)
362     {
363       require(whitelistedBurn[msg.sender]);
364       require(_amount <= balances[msg.sender]);
365       balances[msg.sender] = balances[msg.sender].sub(_amount);
366       totalSupply =  totalSupply.sub(_amount);
367       Burn(msg.sender, _amount);
368       return true;
369     }
370 
371 
372     /**
373         CONSTANT FUNCTIONS
374     **/
375 
376     /**
377     * @dev Gets the balance of the specified address.
378     * @param _owner The address to query the the balance of.
379     * @return An uint256 representing the amount owned by the passed address.
380     */
381     function balanceOf(address _owner) view public returns (uint256 balance) {
382         return balances[_owner];
383     }
384 
385     /**
386    * @dev Function to check the amount of tokens that an owner allowed to a spender.
387    * @param _owner address The address which owns the funds.
388    * @param _spender address The address which will spend the funds.
389    * @return A uint256 specifying the amount of tokens still available for the spender.
390    */
391     function allowance(address _owner, address _spender)
392       view
393       public
394       returns (uint256 remaining)
395     {
396       return allowed[_owner][_spender];
397     }
398 
399 }
400 
401 /**
402     Copyright (c) 2018 SmartTaylor
403 
404     Permission is hereby granted, free of charge, to any person obtaining a copy
405     of this software and associated documentation files (the "Software"), to deal
406     in the Software without restriction, including without limitation the rights
407     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
408     copies of the Software, and to permit persons to whom the Software is
409     furnished to do so, subject to the following conditions:
410 
411     The above copyright notice and this permission notice shall be included in
412     all copies or substantial portions of the Software.
413 
414     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
415     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
416     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
417     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
418     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
419     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
420     THE SOFTWARE.
421 
422     based on the contracts of OpenZeppelin:
423     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
424 
425 **/
426 
427 
428 
429 
430 
431 /**
432  * @title Pausable
433  * @dev Base contract which allows children to implement an emergency stop mechanism.
434  */
435 contract Pausable is Ownable {
436   event Pause();
437   event Unpause();
438 
439   bool public paused = false;
440 
441 
442   /**
443    * @dev Modifier to make a function callable only when the contract is not paused.
444    */
445   modifier whenNotPaused() {
446     require(!paused);
447     _;
448   }
449 
450   /**
451    * @dev Modifier to make a function callable only when the contract is paused.
452    */
453   modifier whenPaused() {
454     require(paused);
455     _;
456   }
457 
458   /**
459    * @dev called by the owner to pause, triggers stopped state
460    */
461   function pause() onlyOwner whenNotPaused public {
462     paused = true;
463     Pause();
464   }
465 
466   /**
467    * @dev called by the owner to unpause, returns to normal state
468    */
469   function unpause() onlyOwner whenPaused public {
470     paused = false;
471     Unpause();
472   }
473 }
474 
475 
476 /**
477   @title Crowdsale
478 
479 **/
480 contract Crowdsale is Ownable, Pausable {
481 
482   using SafeMath for uint256;
483 
484   /**
485       EVENTS
486   **/
487   event Purchase(address indexed buyer, uint256 weiAmount, uint256 tokenAmount);
488   event Finalized(uint256 tokensSold, uint256 weiAmount);
489 
490   /**
491       CONTRACT VARIABLES
492   **/
493   TaylorToken public taylorToken;
494 
495   uint256 public startTime;
496   uint256 public endTime;
497   uint256 public weiRaised;
498   uint256 public tokensSold;
499   uint256 public tokenCap;
500   uint256 public poolEthSold;
501   bool public finalized;
502   address public wallet;
503 
504   uint256 public maxGasPrice = 50000000000;
505 
506   uint256[4] public rates;
507 
508   mapping (address => bool) public whitelisted;
509   mapping (address => bool) public whitelistedPools;
510   mapping (address => uint256) public contributors;
511 
512   /**
513       PUBLIC CONSTANTS
514   **/
515   uint256 public constant poolEthCap = 1250 ether;
516   uint256 public constant minimumPoolPurchase = 100 ether;
517   uint256 public constant minimumPurchase = 0.01 ether;
518   uint256 public constant maximumPoolPurchase = 250 ether;
519   uint256 public constant maximumPurchase = 50 ether;
520   uint256 public constant specialPoolsRate = 600000000000000;
521 
522 
523 
524   /**
525       CONSTRUCTOR
526   **/
527 
528   /**
529     @dev ICO CONSTRUCTOR
530     @param _startTime uint256 timestamp that the sale will begin
531     @param _duration uint256  how long(in days) the sale will last
532     @param _tokenCap uint256 How many tokens will be sold sale
533     @param _token address the address of the token contract
534     @param _wallet address the address of the wallet that will recieve funds
535   **/
536   function Crowdsale(
537     uint256 _startTime,
538     uint256 _duration,
539     uint256 _tokenCap,
540     address _token,
541     address _wallet)
542     public
543   {
544     require(_startTime >= now);
545     require(_token != address(0));
546     require(_wallet != address(0));
547 
548     taylorToken = TaylorToken(_token);
549 
550     startTime = _startTime;
551     endTime = startTime + _duration * 1 days ;
552     wallet = _wallet;
553     tokenCap = _tokenCap;
554     rates = [700000000000000, 790000000000000, 860000000000000, 930000000000000];
555   }
556 
557 
558   /**
559       PUBLIC FUNCTIONS
560 
561   **/
562 
563   /**
564     @dev Fallback function that accepts eth and buy tokens
565   **/
566   function () payable whenNotPaused public {
567     buyTokens();
568   }
569 
570   /**
571     @dev Allows participants to buy tokens
572   **/
573   function buyTokens() payable whenNotPaused public {
574     require(isValidPurchase());
575 
576     uint256 tokens;
577     uint256 amount = msg.value;
578 
579 
580     if(whitelistedPools[msg.sender] && poolEthSold.add(amount) > poolEthCap){
581       uint256 validAmount = poolEthCap.sub(poolEthSold);
582       require(validAmount > 0);
583       uint256 ch = amount.sub(validAmount);
584       msg.sender.transfer(ch);
585       amount = validAmount;
586     }
587 
588     tokens  = calculateTokenAmount(amount);
589 
590 
591     uint256 tokenPool = tokensSold.add(tokens);
592     if(tokenPool > tokenCap){
593       uint256 possibleTokens = tokenCap.sub(tokensSold);
594       uint256 change = calculatePriceForTokens(tokens.sub(possibleTokens));
595       msg.sender.transfer(change);
596       tokens = possibleTokens;
597       amount = amount.sub(change);
598     }
599 
600 
601 
602     contributors[msg.sender] = contributors[msg.sender].add(amount);
603     taylorToken.transfer(msg.sender, tokens);
604 
605     tokensSold = tokensSold.add(tokens);
606     weiRaised = weiRaised.add(amount);
607     if(whitelistedPools[msg.sender]){
608       poolEthSold = poolEthSold.add(amount);
609     }
610 
611 
612     forwardFunds(amount);
613     Purchase(msg.sender, amount, tokens);
614 
615     if(tokenCap.sub(tokensSold) < calculateTokenAmount(minimumPurchase)){
616       finalizeSale();
617     }
618   }
619 
620   /**
621     @dev Allows owner to add addresses to the whitelisted
622     @param _address address The address to be added
623     @param isPool bool Indicating if address represents a buying pool
624   **/
625   function addWhitelisted(address _address, bool isPool)
626     public
627     onlyOwner
628     whenNotPaused
629   {
630     if(isPool) {
631       whitelistedPools[_address] = true;
632     } else {
633       whitelisted[_address] = true;
634     }
635   }
636 
637   /**
638     @dev allows the owner to change the max gas price
639     @param _gasPrice uint256 the new maximum gas price
640   **/
641   function changeMaxGasprice(uint256 _gasPrice)
642     public
643     onlyOwner
644     whenNotPaused
645   {
646     maxGasPrice = _gasPrice;
647   }
648 
649   /**
650     @dev Triggers the finalization process
651   **/
652   function endSale() whenNotPaused public {
653     require(finalized ==  false);
654     require(now > endTime);
655     finalizeSale();
656   }
657 
658   /**
659       INTERNAL FUNCTIONS
660 
661   **/
662 
663   /**
664     @dev Checks if purchase is valid
665     @return Bool Indicating if purchase is valid
666   **/
667   function isValidPurchase() view internal returns(bool valid) {
668     require(now >= startTime && now <= endTime);
669     require(msg.value >= minimumPurchase);
670     require(tx.gasprice <= maxGasPrice);
671     uint256 week = getCurrentWeek();
672     if(week == 0 && whitelistedPools[msg.sender]){
673       require(msg.value >= minimumPoolPurchase);
674       require(contributors[msg.sender].add(msg.value) <= maximumPoolPurchase);
675     } else {
676       require(whitelisted[msg.sender] || whitelistedPools[msg.sender]);
677       require(contributors[msg.sender].add(msg.value) <= maximumPurchase);
678     }
679     return true;
680   }
681 
682 
683 
684   /**
685     @dev Internal function that redirects recieved funds to wallet
686     @param _amount uint256 The amount to be fowarded
687   **/
688   function forwardFunds(uint256 _amount) internal {
689     wallet.transfer(_amount);
690   }
691 
692   /**
693     @dev Calculates the amount of tokens that buyer will recieve
694     @param weiAmount uint256 The amount, in Wei, that will be bought
695     @return uint256 Representing the amount of tokens that weiAmount buys in
696     the current stage of the sale
697   **/
698   function calculateTokenAmount(uint256 weiAmount) view internal returns(uint256 tokenAmount){
699     uint256 week = getCurrentWeek();
700     if(week == 0 && whitelistedPools[msg.sender]){
701       return weiAmount.mul(10**18).div(specialPoolsRate);
702     }
703     return weiAmount.mul(10**18).div(rates[week]);
704   }
705 
706   /**
707     @dev Calculates wei cost of specific amount of tokens
708     @param tokenAmount uint256 The amount of tokens to be calculated
709     @return uint256 Representing the total cost, in wei, for tokenAmount
710   **/
711   function calculatePriceForTokens(uint256 tokenAmount) view internal returns(uint256 weiAmount){
712     uint256 week = getCurrentWeek();
713     return tokenAmount.div(10**18).mul(rates[week]);
714   }
715 
716   /**
717     @dev Checks the current week in the sale. It's zero indexed, so the first
718     week returns 0, the sencond 1, and so forth.
719     @return Uint representing the current week
720   **/
721   function getCurrentWeek() view internal returns(uint256 _week){
722     uint256 week = (now.sub(startTime)).div(1 weeks);
723     if(week > 3){
724       week = 3;
725     }
726     return week;
727   }
728 
729   /**
730     @dev Triggers the sale finalizations process
731   **/
732   function finalizeSale() internal {
733     taylorToken.burn(taylorToken.balanceOf(this));
734     finalized = true;
735     Finalized(tokensSold, weiRaised);
736   }
737 
738   /**
739       READ ONLY FUNCTIONS
740 
741   **/
742 
743   /**
744     @dev Give the current rate(in Wei) that buys exactly one token
745   **/
746   function getCurrentRate() view public returns(uint256 _rate){
747     return rates[getCurrentWeek()];
748   }
749 
750 
751 }