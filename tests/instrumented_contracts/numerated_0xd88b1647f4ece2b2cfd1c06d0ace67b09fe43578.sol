1 pragma solidity ^0.4.18;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     Unpause();
130   }
131 }
132 
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/179
138  */
139 contract ERC20Basic {
140   function totalSupply() public view returns (uint256);
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 
158 contract DetailedERC20 is ERC20 {
159   string public name;
160   string public symbol;
161   uint8 public decimals;
162 
163   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
164     name = _name;
165     symbol = _symbol;
166     decimals = _decimals;
167   }
168 }
169 
170 /**
171  * @title Basic token
172  * @dev Basic version of StandardToken, with no allowances.
173  */
174 contract BasicToken is ERC20Basic {
175   using SafeMath for uint256;
176 
177   mapping(address => uint256) balances;
178 
179   uint256 totalSupply_;
180 
181   /**
182   * @dev total number of tokens in existence
183   */
184   function totalSupply() public view returns (uint256) {
185     return totalSupply_;
186   }
187 
188   /**
189   * @dev transfer token for a specified address
190   * @param _to The address to transfer to.
191   * @param _value The amount to be transferred.
192   */
193   function transfer(address _to, uint256 _value) public returns (bool) {
194     require(_to != address(0));
195     require(_value <= balances[msg.sender]);
196 
197     // SafeMath.sub will throw if there is not enough balance.
198     balances[msg.sender] = balances[msg.sender].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     Transfer(msg.sender, _to, _value);
201     return true;
202   }
203 
204   /**
205   * @dev Gets the balance of the specified address.
206   * @param _owner The address to query the the balance of.
207   * @return An uint256 representing the amount owned by the passed address.
208   */
209   function balanceOf(address _owner) public view returns (uint256 balance) {
210     return balances[_owner];
211   }
212 
213 }
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * @dev https://github.com/ethereum/EIPs/issues/20
220  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234     require(_to != address(0));
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241     Transfer(_from, _to, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public view returns (uint256) {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
282     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
298     uint oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue > oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 }
309 /**
310  * @title Pausable token
311  * @dev StandardToken modified with pausable transfers.
312  **/
313 contract PausableToken is StandardToken, Pausable {
314 
315   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
316     return super.transfer(_to, _value);
317   }
318 
319   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
320     return super.transferFrom(_from, _to, _value);
321   }
322 
323   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
324     return super.approve(_spender, _value);
325   }
326 
327   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
328     return super.increaseApproval(_spender, _addedValue);
329   }
330 
331   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
332     return super.decreaseApproval(_spender, _subtractedValue);
333   }
334 }
335 
336 /**
337  * @title SafeERC20
338  * @dev Wrappers around ERC20 operations that throw on failure.
339  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
340  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
341  */
342 library SafeERC20 {
343   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
344     assert(token.transfer(to, value));
345   }
346 
347   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
348     assert(token.transferFrom(from, to, value));
349   }
350 
351   function safeApprove(ERC20 token, address spender, uint256 value) internal {
352     assert(token.approve(spender, value));
353   }
354 }
355 
356 
357 /**
358  * @title TokenVesting
359  * @dev A token holder contract that can release its token balance gradually like a
360  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
361  * owner.
362  */
363 contract TokenVesting is Ownable {
364   using SafeMath for uint256;
365   using SafeERC20 for ERC20Basic;
366 
367   event Released(uint256 amount);
368   event Revoked();
369 
370   // beneficiary of tokens after they are released
371   address public beneficiary;
372 
373   uint256 public cliff;
374   uint256 public start;
375   uint256 public duration;
376 
377   bool public revocable;
378 
379   mapping (address => uint256) public released;
380   mapping (address => bool) public revoked;
381 
382   /**
383    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
384    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
385    * of the balance will have vested.
386    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
387    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
388    * @param _duration duration in seconds of the period in which the tokens will vest
389    * @param _revocable whether the vesting is revocable or not
390    */
391   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
392     require(_beneficiary != address(0));
393     require(_cliff <= _duration);
394 
395     beneficiary = _beneficiary;
396     revocable = _revocable;
397     duration = _duration;
398     cliff = _start.add(_cliff);
399     start = _start;
400   }
401 
402   /**
403    * @notice Transfers vested tokens to beneficiary.
404    * @param token ERC20 token which is being vested
405    */
406   function release(ERC20Basic token) public {
407     uint256 unreleased = releasableAmount(token);
408 
409     require(unreleased > 0);
410 
411     released[token] = released[token].add(unreleased);
412 
413     token.safeTransfer(beneficiary, unreleased);
414 
415     Released(unreleased);
416   }
417 
418   /**
419    * @notice Allows the owner to revoke the vesting. Tokens already vested
420    * remain in the contract, the rest are returned to the owner.
421    * @param token ERC20 token which is being vested
422    */
423   function revoke(ERC20Basic token) public onlyOwner {
424     require(revocable);
425     require(!revoked[token]);
426 
427     uint256 balance = token.balanceOf(this);
428 
429     uint256 unreleased = releasableAmount(token);
430     uint256 refund = balance.sub(unreleased);
431 
432     revoked[token] = true;
433 
434     token.safeTransfer(owner, refund);
435 
436     Revoked();
437   }
438 
439   /**
440    * @dev Calculates the amount that has already vested but hasn't been released yet.
441    * @param token ERC20 token which is being vested
442    */
443   function releasableAmount(ERC20Basic token) public view returns (uint256) {
444     return vestedAmount(token).sub(released[token]);
445   }
446 
447   /**
448    * @dev Calculates the amount that has already vested.
449    * @param token ERC20 token which is being vested
450    */
451   function vestedAmount(ERC20Basic token) public view returns (uint256) {
452     uint256 currentBalance = token.balanceOf(this);
453     uint256 totalBalance = currentBalance.add(released[token]);
454 
455     if (now < cliff) {
456       return 0;
457     } else if (now >= start.add(duration) || revoked[token]) {
458       return totalBalance;
459     } else {
460       return totalBalance.mul(now.sub(start)).div(duration);
461     }
462   }
463 }
464 
465 
466 /**
467   * @title  RateToken
468   * @dev Rate Token Contract implementation 
469 */
470 contract RateToken is Ownable {
471     using SafeMath for uint256;
472     //struct that holds values for specific discount
473     struct Discount {
474         //min number of tokens expected to be bought
475         uint256 minTokens;
476         //discount percentage
477         uint256 percent;
478     }
479     //Discount per address
480     mapping(address => Discount) private discounts;
481     //Token conversion rate
482     uint256 public rate;
483 
484    /**
485     * @dev Event which is fired when Rate is set
486     */
487     event RateSet(uint256 rate);
488 
489    
490     function RateToken(uint256 _initialRate) public {
491         setRate(_initialRate);
492     }
493 
494    /**
495    * @dev Function that sets the conversion rate
496    * @param _rateInWei The amount of rate to be set
497     */
498     function setRate(uint _rateInWei) onlyOwner public {
499         require(_rateInWei > 0);
500         rate = _rateInWei;
501         RateSet(rate);
502     }
503 
504    /**
505    * @dev Function for adding discount for concrete buyer, only available for the owner.  
506    * @param _buyer The address of the buyer.
507    * @param _minTokens The amount of tokens.
508    * @param _percent The amount of discount in percents.
509    * @return A boolean that indicates if the operation was successful.
510     */
511     
512     // NOTE FROM BLOCKERA - PERCENTAGE COULD BE UINT8 (0 - 255)
513     function addDiscount(address _buyer, uint256 _minTokens, uint256 _percent) public onlyOwner returns (bool) { 
514         require(_buyer != address(0));
515         require(_minTokens > 0);
516         require(_percent > 0);
517         require(_percent < 100);
518         Discount memory discount;
519         discount.minTokens = _minTokens;
520         discount.percent = _percent;
521         discounts[_buyer] = discount;
522         return true;
523     }
524 
525    /**
526    * @dev Function to remove discount.
527    * @param _buyer The address to remove the discount from.
528    * @return A boolean that indicates if the operation was successful.
529    */
530     function removeDiscount(address _buyer) public onlyOwner {
531         require(_buyer != address(0));
532         removeExistingDiscount(_buyer);
533     }
534 
535     /**
536     * @dev Public Function that calculates the amount in wei for specific number of tokens
537     * @param _buyer address.
538     * @param _tokens The amount of tokens.
539     * @return uint256 the price for tokens in wei.
540     */
541     function calculateWeiNeeded(address _buyer, uint _tokens) public view returns (uint256) {
542         require(_buyer != address(0));
543         require(_tokens > 0);
544 
545         Discount memory discount = discounts[_buyer];
546         require(_tokens >= discount.minTokens);
547         if (discount.minTokens == 0) {
548             return _tokens.div(rate);
549         }
550 
551         uint256 costOfTokensNormally = _tokens.div(rate);
552         return costOfTokensNormally.mul(100 - discount.percent).div(100);
553 
554     }
555     
556     /**
557      * @dev Removes discount for concrete buyer.
558      * @param _buyer the address for which the discount will be removed.
559      */
560     function removeExistingDiscount(address _buyer) internal {
561         delete(discounts[_buyer]);
562     }
563 
564     /**
565     * @dev Function that converts wei into tokens.
566     * @param _buyer address of the buyer.
567     * @param _buyerAmountInWei amount of ether in wei. 
568     * @return uint256 value of the calculated tokens.
569     */
570     function calculateTokens(address _buyer, uint256 _buyerAmountInWei) internal view returns (uint256) {
571         Discount memory discount = discounts[_buyer];
572         if (discount.minTokens == 0) {
573             return _buyerAmountInWei.mul(rate);
574         }
575 
576         uint256 normalTokens = _buyerAmountInWei.mul(rate);
577         uint256 discountBonus = normalTokens.mul(discount.percent).div(100);
578         uint256 tokens = normalTokens + discountBonus;
579         require(tokens >= discount.minTokens);
580         return tokens;
581     }  
582 }
583 
584 
585 
586 /**
587  * @title Caerus token.
588  * @dev Implementation of the Caerus token.
589  */
590 contract CaerusToken is RateToken, PausableToken, DetailedERC20 {
591     mapping (address => uint256) public contributions;
592     uint256 public tokenSold = 0; 
593     uint256 public weiRaised = 0; 
594     address transferAddress;
595     
596     mapping (address => TokenVesting) public vestedTokens;
597 
598     event TokensBought(address indexed buyer, uint256 tokens);
599     event Contribution(address indexed buyer, uint256 amountInWei);
600     event VestedTokenCreated(address indexed beneficiary, uint256 duration, uint256 tokens);
601     event TokensSpent(address indexed tokensHolder, uint256 tokens);
602 
603     function CaerusToken(address _transferAddress, uint _initialRate) public RateToken(_initialRate) DetailedERC20("Caerus Token", "CAER", 18) {
604         totalSupply_ = 73000000 * 10 ** 18;
605         transferAddress = _transferAddress;
606         balances[owner] = totalSupply_;
607   	}
608     /**
609     * @dev Sets the address to transfer funds.
610     * @param _transferAddress An address to transfer funds.
611     */
612     function setTransferAddress(address _transferAddress) onlyOwner public {
613         transferAddress = _transferAddress;
614     }
615     /**
616     * @dev Fallback function when receiving Ether.
617     */
618     function() payable public {
619         buyTokens();
620     }
621 
622     /**
623     * @dev Allow addresses to buy tokens.
624     */
625     function buyTokens() payable public whenNotPaused {
626         require(msg.value > 0);
627         
628         uint256 tokens = calculateTokens(msg.sender, msg.value);
629         transferTokens(owner, msg.sender, tokens);
630 
631         markTokenSold(tokens);
632         markContribution();
633         removeExistingDiscount(msg.sender);
634         transferAddress.transfer(msg.value);
635         TokensBought(msg.sender, tokens);
636     }
637 
638     /**
639     * @dev Transfer tokens from owner to specific address, available only for the owner.
640     * @param _to The address where tokens are transfered.
641     * @param _tokens Amount of tokens that need to be transfered.
642     * @return Boolean representing the successful execution of the function.
643     */
644     // Owner could use regular transfer method if they wanted to
645     function markTransferTokens(address _to, uint256 _tokens) onlyOwner public returns (bool) {
646         require(_to != address(0));
647 
648         transferTokens(owner, _to, _tokens);
649         markTokenSold(_tokens);
650         return true;
651     }
652 
653     /**
654    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
655    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
656    * of the balance will have vested.
657    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred.
658    * @param _start time when vesting starts.
659    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest.
660    * @param _duration duration in seconds of the period in which the tokens will vest.
661    * @param _tokens Amount of tokens that need to be vested.
662    * @return Boolean representing the successful execution of the function.
663    */
664     function createVestedToken(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _tokens) onlyOwner public returns (bool) {
665         TokenVesting vestedToken = new TokenVesting(_beneficiary, _start, _cliff, _duration, false);
666         vestedTokens[_beneficiary] = vestedToken;
667         address vestedAddress = address(vestedToken);
668         transferTokens(owner, vestedAddress, _tokens);
669         VestedTokenCreated(_beneficiary, _duration, _tokens);
670         return true;
671     }
672 
673     /**
674     * @dev Transfer tokens from address to owner address.
675     * @param _tokens Amount of tokens that need to be transfered.
676     * @return Boolean representing the successful execution of the function.
677     */
678     function spendToken(uint256 _tokens) public returns (bool) {
679         transferTokens(msg.sender, owner, _tokens);
680         TokensSpent(msg.sender, _tokens);
681         return true;
682     }
683 
684     /**
685     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
686     * @param _spender The address which will spend the funds.
687     * @param _value The amount of tokens to be spent.
688     * @return Boolean representing the successful execution of the function.
689     */
690     function approve(address _spender, uint _value) public returns (bool) {
691         //  To change the approve amount you first have to reduce the addresses`
692         //  allowance to zero by calling `approve(_spender, 0)` if it is not
693         //  already 0 to mitigate the race condition described here:
694         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
695         require(_value == 0 || allowed[msg.sender][_spender] == 0);
696 
697         return super.approve(_spender, _value);
698     }
699 
700     /**
701     * @dev Transfer tokens from one address to another.
702     * @param _from The address which you want to send tokens from.
703     * @param _to The address which you want to transfer to.
704     * @param _tokens the amount of tokens to be transferred.
705     */
706     function transferTokens(address _from, address _to, uint256 _tokens) private {
707         require(_tokens > 0);
708         require(balances[_from] >= _tokens);
709         
710         balances[_from] = balances[_from].sub(_tokens);
711         balances[_to] = balances[_to].add(_tokens);
712         Transfer(_from, _to, _tokens);
713     }
714 
715     /**
716     * @dev Adds or updates contributions
717     */
718     function markContribution() private {
719         contributions[msg.sender] = contributions[msg.sender].add(msg.value);
720         weiRaised = weiRaised.add(msg.value);
721         Contribution(msg.sender, msg.value);
722     }
723 
724     /**
725     * @dev Increase token sold amount.
726     * @param _tokens Amount of tokens that are sold.
727     */
728     function markTokenSold(uint256 _tokens) private {
729         tokenSold = tokenSold.add(_tokens);
730     }
731     
732     /**
733     * @dev Owner can transfer out any accidentally sent Caerus tokens.
734     * @param _tokenAddress The address which you want to send tokens from.
735     * @param _tokens the amount of tokens to be transferred.
736     */    
737     function transferAnyCaerusToken(address _tokenAddress, uint _tokens) public onlyOwner returns (bool success) {
738         transferTokens(_tokenAddress, owner, _tokens);
739         return true;
740     }
741 }