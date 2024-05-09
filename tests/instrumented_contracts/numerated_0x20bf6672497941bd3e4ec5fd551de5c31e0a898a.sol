1 pragma solidity ^0.4.11;
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
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal constant returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 contract ERC20Basic {
73   uint256 public totalSupply;
74   function balanceOf(address who) public constant returns (uint256);
75   function transfer(address to, uint256 value) public returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) public constant returns (uint256);
85   function transferFrom(address from, address to, uint256 value) public returns (bool);
86   function approve(address spender, uint256 value) public returns (bool);
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102 
103     // SafeMath.sub will throw if there is not enough balance.
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public constant returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141 
142     uint256 _allowance = allowed[_from][msg.sender];
143 
144     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
145     // require (_value <= _allowance);
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = _allowance.sub(_value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    */
186   function increaseApproval (address _spender, uint _addedValue)
187     returns (bool success) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   function decreaseApproval (address _spender, uint _subtractedValue)
194     returns (bool success) {
195     uint oldValue = allowed[msg.sender][_spender];
196     if (_subtractedValue > oldValue) {
197       allowed[msg.sender][_spender] = 0;
198     } else {
199       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200     }
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205 }
206 
207 contract MintableToken is StandardToken, Ownable {
208   event Mint(address indexed to, uint256 amount);
209   event MintFinished();
210 
211   bool public mintingFinished = false;
212 
213 
214   modifier canMint() {
215     require(!mintingFinished);
216     _;
217   }
218 
219   /**
220    * @dev Function to mint tokens
221    * @param _to The address that will receive the minted tokens.
222    * @param _amount The amount of tokens to mint.
223    * @return A boolean that indicates if the operation was successful.
224    */
225   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
226     totalSupply = totalSupply.add(_amount);
227     balances[_to] = balances[_to].add(_amount);
228     Mint(_to, _amount);
229     Transfer(0x0, _to, _amount);
230     return true;
231   }
232 
233   /**
234    * @dev Function to stop minting new tokens.
235    * @return True if the operation was successful.
236    */
237   function finishMinting() onlyOwner public returns (bool) {
238     mintingFinished = true;
239     MintFinished();
240     return true;
241   }
242 }
243 
244 /**
245  * @title SetherToken
246  * @dev Sether ERC20 Token that can be minted.
247  * It is meant to be used in sether crowdsale contract.
248  */
249 contract SetherToken is MintableToken {
250 
251     string public constant name = "Sether";
252     string public constant symbol = "SETH";
253     uint8 public constant decimals = 18;
254 
255     function getTotalSupply() public returns (uint256) {
256         return totalSupply;
257     }
258 }
259 
260 /**
261  * @title SetherBaseCrowdsale
262  * @dev SetherBaseCrowdsale is a base contract for managing a sether token crowdsale.
263  */
264 contract SetherBaseCrowdsale {
265     using SafeMath for uint256;
266 
267     // The token being sold
268     SetherToken public token;
269 
270     // start and end timestamps where investments are allowed (both inclusive)
271     uint256 public startTime;
272     uint256 public endTime;
273 
274     // address where funds are collected
275     address public wallet;
276 
277     // how many finney per token
278     uint256 public rate;
279 
280     // amount of raised money in wei
281     uint256 public weiRaised;
282 
283     /**
284     * event for token purchase logging
285     * @param purchaser who paid for the tokens
286     * @param beneficiary who got the tokens
287     * @param value weis paid for purchase
288     * @param amount amount of tokens purchased
289     */
290     event SethTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
291 
292     function SetherBaseCrowdsale(uint256 _rate, address _wallet) {
293         require(_rate > 0);
294         require(_wallet != address(0));
295 
296         token = createTokenContract();
297         rate = _rate;
298         wallet = _wallet;
299     }
300 
301     // fallback function can be used to buy tokens
302     function () payable {
303         buyTokens(msg.sender);
304     }
305 
306     // low level token purchase function
307     function buyTokens(address beneficiary) public payable {
308         require(beneficiary != address(0));
309         require(validPurchase());
310 
311         uint256 weiAmount = msg.value;
312 
313         // calculate token amount to be created
314         uint256 tokens = computeTokens(weiAmount);
315 
316         require(isWithinTokenAllocLimit(tokens));
317 
318         // update state
319         weiRaised = weiRaised.add(weiAmount);
320 
321         token.mint(beneficiary, tokens);
322 
323         SethTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
324 
325         forwardFunds();
326     }
327 
328     // @return true if crowdsale event has ended
329     function hasEnded() public constant returns (bool) {
330         return now > endTime;
331     }
332 
333     // @return true if crowdsale event has started
334     function hasStarted() public constant returns (bool) {
335         return now < startTime;
336     }
337 
338     // send ether to the fund collection wallet
339     function forwardFunds() internal {
340         wallet.transfer(msg.value);
341     }
342 
343     // @return true if the transaction can buy tokens
344     function validPurchase() internal constant returns (bool) {
345         bool withinPeriod = now >= startTime && now <= endTime;
346         bool nonZeroPurchase = msg.value != 0;
347         return withinPeriod && nonZeroPurchase;
348     }
349     
350     //Override this method with token distribution strategy
351     function computeTokens(uint256 weiAmount) internal returns (uint256) {
352         //To be overriden
353     }
354 
355     //Override this method with token limitation strategy
356     function isWithinTokenAllocLimit(uint256 _tokens) internal returns (bool) {
357         //To be overriden
358     }
359     
360     // creates the token to be sold.
361     function createTokenContract() internal returns (SetherToken) {
362         return new SetherToken();
363     }
364 }
365 
366 /**
367  * @title SetherMultiStepCrowdsale
368  * @dev Multi-step payment policy contract that extends SetherBaseCrowdsale
369  */
370 contract SetherMultiStepCrowdsale is SetherBaseCrowdsale {
371     uint256 public constant PRESALE_LIMIT = 25 * (10 ** 6) * (10 ** 18);
372     uint256 public constant CROWDSALE_LIMIT = 55 * (10 ** 6) * (10 ** 18);
373     
374     uint256 public constant PRESALE_BONUS_LIMIT = 1 * (10 ** 17);
375 
376     // Presale period (includes holidays)
377     uint public constant PRESALE_PERIOD = 53 days;
378     // Crowdsale first week period (constants for proper testing)
379     uint public constant CROWD_WEEK1_PERIOD = 7 days;
380     // Crowdsale second week period
381     uint public constant CROWD_WEEK2_PERIOD = 7 days;
382     //Crowdsale third week period
383     uint public constant CROWD_WEEK3_PERIOD = 7 days;
384     //Crowdsale last week period
385     uint public constant CROWD_WEEK4_PERIOD = 7 days;
386 
387     uint public constant PRESALE_BONUS = 40;
388     uint public constant CROWD_WEEK1_BONUS = 25;
389     uint public constant CROWD_WEEK2_BONUS = 20;
390     uint public constant CROWD_WEEK3_BONUS = 10;
391 
392     uint256 public limitDatePresale;
393     uint256 public limitDateCrowdWeek1;
394     uint256 public limitDateCrowdWeek2;
395     uint256 public limitDateCrowdWeek3;
396 
397     function SetherMultiStepCrowdsale() {
398 
399     }
400 
401     function isWithinPresaleTimeLimit() internal returns (bool) {
402         return now <= limitDatePresale;
403     }
404 
405     function isWithinCrowdWeek1TimeLimit() internal returns (bool) {
406         return now <= limitDateCrowdWeek1;
407     }
408 
409     function isWithinCrowdWeek2TimeLimit() internal returns (bool) {
410         return now <= limitDateCrowdWeek2;
411     }
412 
413     function isWithinCrowdWeek3TimeLimit() internal returns (bool) {
414         return now <= limitDateCrowdWeek3;
415     }
416 
417     function isWithinCrodwsaleTimeLimit() internal returns (bool) {
418         return now <= endTime && now > limitDatePresale;
419     }
420 
421     function isWithinPresaleLimit(uint256 _tokens) internal returns (bool) {
422         return token.getTotalSupply().add(_tokens) <= PRESALE_LIMIT;
423     }
424 
425     function isWithinCrowdsaleLimit(uint256 _tokens) internal returns (bool) {
426         return token.getTotalSupply().add(_tokens) <= CROWDSALE_LIMIT;
427     }
428 
429     function validPurchase() internal constant returns (bool) {
430         return super.validPurchase() &&
431                  !(isWithinPresaleTimeLimit() && msg.value < PRESALE_BONUS_LIMIT);
432     }
433 
434     function isWithinTokenAllocLimit(uint256 _tokens) internal returns (bool) {
435         return (isWithinPresaleTimeLimit() && isWithinPresaleLimit(_tokens)) ||
436                         (isWithinCrodwsaleTimeLimit() && isWithinCrowdsaleLimit(_tokens));
437     }
438 
439     function computeTokens(uint256 weiAmount) internal returns (uint256) {
440         uint256 appliedBonus = 0;
441         if (isWithinPresaleTimeLimit()) {
442             appliedBonus = PRESALE_BONUS;
443         } else if (isWithinCrowdWeek1TimeLimit()) {
444             appliedBonus = CROWD_WEEK1_BONUS;
445         } else if (isWithinCrowdWeek2TimeLimit()) {
446             appliedBonus = CROWD_WEEK2_BONUS;
447         } else if (isWithinCrowdWeek3TimeLimit()) {
448             appliedBonus = CROWD_WEEK3_BONUS;
449         }
450 
451         return weiAmount.mul(10).mul(100 + appliedBonus).div(rate);
452     }
453 }
454 
455 /**
456  * @title SetherCappedCrowdsale
457  * @dev Extension of SetherBaseCrowdsale with a max amount of funds raised
458  */
459 contract SetherCappedCrowdsale is SetherMultiStepCrowdsale {
460     using SafeMath for uint256;
461 
462     uint256 public constant HARD_CAP = 55 * (10 ** 6) * (10 ** 18);
463 
464     function SetherCappedCrowdsale() {
465         
466     }
467 
468     // overriding SetherBaseCrowdsale#validPurchase to add extra cap logic
469     // @return true if investors can buy at the moment
470     function validPurchase() internal constant returns (bool) {
471         bool withinCap = weiRaised.add(msg.value) <= HARD_CAP;
472 
473         return super.validPurchase() && withinCap;
474     }
475 
476     // overriding Crowdsale#hasEnded to add cap logic
477     // @return true if crowdsale event has ended
478     function hasEnded() public constant returns (bool) {
479         bool capReached = weiRaised >= HARD_CAP;
480         return super.hasEnded() || capReached;
481     }
482 }
483 
484 /**
485  * @title SetherStartableCrowdsale
486  * @dev Extension of SetherBaseCrowdsale where an owner can start the crowdsale
487  */
488 contract SetherStartableCrowdsale is SetherBaseCrowdsale, Ownable {
489   using SafeMath for uint256;
490 
491   bool public isStarted = false;
492 
493   event SetherStarted();
494 
495   /**
496    * @dev Must be called after crowdsale ends, to do some extra finalization
497    * work. Calls the contract's finalization function.
498    */
499   function start() onlyOwner public {
500     require(!isStarted);
501     require(!hasStarted());
502 
503     starting();
504     SetherStarted();
505 
506     isStarted = true;
507   }
508 
509   /**
510    * @dev Can be overridden to add start logic. The overriding function
511    * should call super.starting() to ensure the chain of starting is
512    * executed entirely.
513    */
514   function starting() internal {
515     //To be overriden
516   }
517 }
518 
519 /**
520  * @title SetherFinalizableCrowdsale
521  * @dev Extension of SetherBaseCrowdsale where an owner can do extra work
522  * after finishing.
523  */
524 contract SetherFinalizableCrowdsale is SetherBaseCrowdsale, Ownable {
525   using SafeMath for uint256;
526 
527   bool public isFinalized = false;
528 
529   event SetherFinalized();
530 
531   /**
532    * @dev Must be called after crowdsale ends, to do some extra finalization
533    * work. Calls the contract's finalization function.
534    */
535   function finalize() onlyOwner public {
536     require(!isFinalized);
537     require(hasEnded());
538 
539     finalization();
540     SetherFinalized();
541 
542     isFinalized = true;
543   }
544 
545   /**
546    * @dev Can be overridden to add finalization logic. The overriding function
547    * should call super.finalization() to ensure the chain of finalization is
548    * executed entirely.
549    */
550   function finalization() internal {
551     //To be overriden
552   }
553 }
554 
555 /**
556  * @title SetherCrowdsale
557  * @dev This is Sether's crowdsale contract.
558  */
559 contract SetherCrowdsale is SetherCappedCrowdsale, SetherStartableCrowdsale, SetherFinalizableCrowdsale {
560 
561     function SetherCrowdsale(uint256 rate, address _wallet) 
562         SetherCappedCrowdsale()
563         SetherFinalizableCrowdsale()
564         SetherStartableCrowdsale()
565         SetherMultiStepCrowdsale()
566         SetherBaseCrowdsale(rate, _wallet) 
567     {
568    
569     }
570 
571     function starting() internal {
572         super.starting();
573         startTime = now;
574         limitDatePresale = startTime + PRESALE_PERIOD;
575         limitDateCrowdWeek1 = limitDatePresale + CROWD_WEEK1_PERIOD; 
576         limitDateCrowdWeek2 = limitDateCrowdWeek1 + CROWD_WEEK2_PERIOD; 
577         limitDateCrowdWeek3 = limitDateCrowdWeek2 + CROWD_WEEK3_PERIOD;         
578         endTime = limitDateCrowdWeek3 + CROWD_WEEK4_PERIOD;
579     }
580 
581     function finalization() internal {
582         super.finalization();
583         uint256 ownerShareTokens = token.getTotalSupply().mul(9).div(11);
584 
585         token.mint(wallet, ownerShareTokens);
586     }
587 }