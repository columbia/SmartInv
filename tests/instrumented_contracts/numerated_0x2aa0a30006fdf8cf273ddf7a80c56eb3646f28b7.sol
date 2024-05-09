1 pragma solidity ^0.4.20;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: node_modules/zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: node_modules/zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: node_modules/zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 // File: node_modules/zeppelin-solidity/contracts/token/MintableToken.sol
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will receive the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258     totalSupply = totalSupply.add(_amount);
259     balances[_to] = balances[_to].add(_amount);
260     Mint(_to, _amount);
261     Transfer(address(0), _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 // File: node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
277 
278 /**
279  * @title Crowdsale
280  * @dev Crowdsale is a base contract for managing a token crowdsale.
281  * Crowdsales have a start and end timestamps, where investors can make
282  * token purchases and the crowdsale will assign them tokens based
283  * on a token per ETH rate. Funds collected are forwarded to a wallet
284  * as they arrive.
285  */
286 contract Crowdsale {
287   using SafeMath for uint256;
288 
289   // The token being sold
290   MintableToken public token;
291 
292   // start and end timestamps where investments are allowed (both inclusive)
293   uint256 public startTime;
294   uint256 public endTime;
295 
296   // address where funds are collected
297   address public wallet;
298 
299   // how many token units a buyer gets per wei
300   uint256 public rate;
301 
302   // amount of raised money in wei
303   uint256 public weiRaised;
304 
305   /**
306    * event for token purchase logging
307    * @param purchaser who paid for the tokens
308    * @param beneficiary who got the tokens
309    * @param value weis paid for purchase
310    * @param amount amount of tokens purchased
311    */
312   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
313 
314 
315   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
316     // Removed because recovering crowdsale
317     // require(_startTime >= now); 
318     require(_endTime >= _startTime);
319     require(_rate > 0);
320     require(_wallet != address(0));
321 
322     token = createTokenContract();
323     startTime = _startTime;
324     endTime = _endTime;
325     rate = _rate;
326     wallet = _wallet;
327   }
328 
329   // creates the token to be sold.
330   // override this method to have crowdsale of a specific mintable token.
331   function createTokenContract() internal returns (MintableToken) {
332     return new MintableToken();
333   }
334 
335 
336   // fallback function can be used to buy tokens
337   function () external payable {
338     buyTokens(msg.sender);
339   }
340 
341   // low level token purchase function
342   function buyTokens(address beneficiary) public payable {
343     require(beneficiary != address(0));
344     require(validPurchase());
345 
346     uint256 weiAmount = msg.value;
347 
348     // calculate token amount to be created
349     uint256 tokens = weiAmount.mul(rate);
350 
351     // update state
352     weiRaised = weiRaised.add(weiAmount);
353 
354     token.mint(beneficiary, tokens);
355     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
356 
357     forwardFunds();
358   }
359 
360   // send ether to the fund collection wallet
361   // override to create custom fund forwarding mechanisms
362   function forwardFunds() internal {
363     wallet.transfer(msg.value);
364   }
365 
366   // @return true if the transaction can buy tokens
367   function validPurchase() internal view returns (bool) {
368     bool withinPeriod = now >= startTime && now <= endTime;
369     bool nonZeroPurchase = msg.value != 0;
370     return withinPeriod && nonZeroPurchase;
371   }
372 
373   // @return true if crowdsale event has ended
374   function hasEnded() public view returns (bool) {
375     return now > endTime;
376   }
377 
378 
379 }
380 
381 // File: node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
382 
383 /**
384  * @title CappedCrowdsale
385  * @dev Extension of Crowdsale with a max amount of funds raised
386  */
387 contract CappedCrowdsale is Crowdsale {
388   using SafeMath for uint256;
389 
390   uint256 public cap;
391 
392   function CappedCrowdsale(uint256 _cap) public {
393     require(_cap > 0);
394     cap = _cap;
395   }
396 
397   // overriding Crowdsale#validPurchase to add extra cap logic
398   // @return true if investors can buy at the moment
399   function validPurchase() internal view returns (bool) {
400     bool withinCap = weiRaised.add(msg.value) <= cap;
401     return super.validPurchase() && withinCap;
402   }
403 
404   // overriding Crowdsale#hasEnded to add cap logic
405   // @return true if crowdsale event has ended
406   function hasEnded() public view returns (bool) {
407     bool capReached = weiRaised >= cap;
408     return super.hasEnded() || capReached;
409   }
410 
411 }
412 
413 // File: node_modules/zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
414 
415 /**
416  * @title FinalizableCrowdsale
417  * @dev Extension of Crowdsale where an owner can do extra work
418  * after finishing.
419  */
420 contract FinalizableCrowdsale is Crowdsale, Ownable {
421   using SafeMath for uint256;
422 
423   bool public isFinalized = false;
424 
425   event Finalized();
426 
427   /**
428    * @dev Must be called after crowdsale ends, to do some extra finalization
429    * work. Calls the contract's finalization function.
430    */
431   function finalize() onlyOwner public {
432     require(!isFinalized);
433     // Removed because recovering crowdsale
434     // require(hasEnded());
435 
436     finalization();
437     Finalized();
438 
439     isFinalized = true;
440   }
441 
442   /**
443    * @dev Can be overridden to add finalization logic. The overriding function
444    * should call super.finalization() to ensure the chain of finalization is
445    * executed entirely.
446    */
447   function finalization() internal {
448   }
449 }
450 
451 // File: node_modules/zeppelin-solidity/contracts/token/BurnableToken.sol
452 
453 /**
454  * @title Burnable Token
455  * @dev Token that can be irreversibly burned (destroyed).
456  */
457 contract BurnableToken is StandardToken {
458 
459     event Burn(address indexed burner, uint256 value);
460 
461     /**
462      * @dev Burns a specific amount of tokens.
463      * @param _value The amount of token to be burned.
464      */
465     function burn(uint256 _value) public {
466         require(_value > 0);
467         require(_value <= balances[msg.sender]);
468         // no need to require value <= totalSupply, since that would imply the
469         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
470 
471         address burner = msg.sender;
472         balances[burner] = balances[burner].sub(_value);
473         totalSupply = totalSupply.sub(_value);
474         Burn(burner, _value);
475     }
476 }
477 
478 // File: node_modules/zeppelin-solidity/contracts/token/CappedToken.sol
479 
480 /**
481  * @title Capped token
482  * @dev Mintable token with a token cap.
483  */
484 
485 contract CappedToken is MintableToken {
486 
487   uint256 public cap;
488 
489   function CappedToken(uint256 _cap) public {
490     require(_cap > 0);
491     cap = _cap;
492   }
493 
494   /**
495    * @dev Function to mint tokens
496    * @param _to The address that will receive the minted tokens.
497    * @param _amount The amount of tokens to mint.
498    * @return A boolean that indicates if the operation was successful.
499    */
500   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
501     require(totalSupply.add(_amount) <= cap);
502 
503     return super.mint(_to, _amount);
504   }
505 
506 }
507 
508 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
509 
510 /**
511  * @title Pausable
512  * @dev Base contract which allows children to implement an emergency stop mechanism.
513  */
514 contract Pausable is Ownable {
515   event Pause();
516   event Unpause();
517 
518   bool public paused = false;
519 
520 
521   /**
522    * @dev Modifier to make a function callable only when the contract is not paused.
523    */
524   modifier whenNotPaused() {
525     require(!paused);
526     _;
527   }
528 
529   /**
530    * @dev Modifier to make a function callable only when the contract is paused.
531    */
532   modifier whenPaused() {
533     require(paused);
534     _;
535   }
536 
537   /**
538    * @dev called by the owner to pause, triggers stopped state
539    */
540   function pause() onlyOwner whenNotPaused public {
541     paused = true;
542     Pause();
543   }
544 
545   /**
546    * @dev called by the owner to unpause, returns to normal state
547    */
548   function unpause() onlyOwner whenPaused public {
549     paused = false;
550     Unpause();
551   }
552 }
553 
554 // File: node_modules/zeppelin-solidity/contracts/token/PausableToken.sol
555 
556 /**
557  * @title Pausable token
558  *
559  * @dev StandardToken modified with pausable transfers.
560  **/
561 
562 contract PausableToken is StandardToken, Pausable {
563 
564   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
565     return super.transfer(_to, _value);
566   }
567 
568   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
569     return super.transferFrom(_from, _to, _value);
570   }
571 
572   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
573     return super.approve(_spender, _value);
574   }
575 
576   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
577     return super.increaseApproval(_spender, _addedValue);
578   }
579 
580   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
581     return super.decreaseApproval(_spender, _subtractedValue);
582   }
583 }
584 
585 // File: contracts/LSDToken.sol
586 
587 contract LSDToken is CappedToken, PausableToken, BurnableToken {
588 
589     string public constant name = "LSD";
590     string public constant symbol = "LSD";
591     uint8 public constant decimals = 18;
592 
593     function LSDToken(uint256 _cap)
594         CappedToken(_cap)
595         public
596     {
597         
598     }
599 
600 }
601 
602 // File: contracts/LSDCrowdsale.sol
603 
604 contract LSDCrowdsale is CappedCrowdsale, FinalizableCrowdsale {
605 
606     function LSDCrowdsale()
607         public
608         Crowdsale(1521288000, 1523102400, 8700, 0xCb4c2C679c08D56908be14E109501451565aEF40)
609         CappedCrowdsale(11428 ether)
610     {
611 
612         token = new LSDToken(190466000 ether); // ether is bypass because LSDToken has 18 decimals also
613 
614     }
615 
616     function createTokenContract() internal returns (MintableToken) {
617         /** 
618             This returns an empty address because token needs arguments
619         */
620         return MintableToken(address(0));
621     
622     }
623     
624     function buyTokens(address beneficiary) public payable {
625         require(beneficiary != address(0));
626         require(validPurchase());
627 
628         uint256 weiAmount = msg.value;
629 
630         // minimum investment of 0.05 ETH
631         require(msg.value >= 50 finney);
632 
633         // calculate token amount to be created
634         uint256 tokens = weiAmount.mul(calculateRate());
635 
636         // update state
637         weiRaised = weiRaised.add(weiAmount);
638 
639         token.mint(beneficiary, tokens);
640         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
641 
642         forwardFunds();
643     }
644 
645     function calculateRate() internal view returns (uint256) {
646                 
647         if ( now <= 1521309600 )
648             return rate.mul(115).div(100);
649         else if ( now <= 1521374400 )
650             return rate.mul(110).div(100);
651         else if ( now <= 1521633600 )
652             return rate.mul(107).div(100);
653 	else if ( now <= 1521892800 )
654             return rate.mul(103).div(100);
655         else
656             return rate.mul(100).div(100);
657 
658     }
659 
660     function finalization() internal {
661 
662         token.mint(0xCb4c2C679c08D56908be14E109501451565aEF40, 76186000 ether); // ether is bypass because LSDToken has 18 decimals also
663 
664         token.finishMinting();
665 
666         token.transferOwnership(owner);
667 
668     }
669 
670     function mintTo(address beneficiary, uint256 tokens) public onlyOwner {
671 
672         token.mint(beneficiary, tokens);
673 
674     }
675 
676 }