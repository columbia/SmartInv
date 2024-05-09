1 pragma solidity ^0.4.24;
2 
3 /**
4  * Powered by Daonomic (https://daonomic.io)
5  */
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * See https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 /**
39  * @title SafeERC20
40  * @dev Wrappers around ERC20 operations that throw on failure.
41  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
42  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
43  */
44 library SafeERC20 {
45   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
46     require(token.transfer(to, value));
47   }
48 
49   function safeTransferFrom(
50     ERC20 token,
51     address from,
52     address to,
53     uint256 value
54   )
55     internal
56   {
57     require(token.transferFrom(from, to, value));
58   }
59 
60   function safeApprove(ERC20 token, address spender, uint256 value) internal {
61     require(token.approve(spender, value));
62   }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (a == 0) {
79       return 0;
80     }
81 
82     c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return a / b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 }
114 
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123 
124   uint256 totalSupply_;
125 
126   /**
127   * @dev Total number of tokens in existence
128   */
129   function totalSupply() public view returns (uint256) {
130     return totalSupply_;
131   }
132 
133   /**
134   * @dev Transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[msg.sender]);
141 
142     balances[msg.sender] = balances[msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     emit Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public view returns (uint256) {
154     return balances[_owner];
155   }
156 
157 }
158 
159 /**
160  * @title Burnable Token
161  * @dev Token that can be irreversibly burned (destroyed).
162  */
163 contract BurnableToken is BasicToken {
164 
165   event Burn(address indexed burner, uint256 value);
166 
167   /**
168    * @dev Burns a specific amount of tokens.
169    * @param _value The amount of token to be burned.
170    */
171   function burn(uint256 _value) public {
172     _burn(msg.sender, _value);
173   }
174 
175   function _burn(address _who, uint256 _value) internal {
176     require(_value <= balances[_who]);
177     // no need to require value <= totalSupply, since that would imply the
178     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
179 
180     balances[_who] = balances[_who].sub(_value);
181     totalSupply_ = totalSupply_.sub(_value);
182     emit Burn(_who, _value);
183     emit Transfer(_who, address(0), _value);
184   }
185 }
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * https://github.com/ethereum/EIPs/issues/20
192  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    * Beware that changing an allowance with this method brings the risk that someone may use both the old
227    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230    * @param _spender The address which will spend the funds.
231    * @param _value The amount of tokens to be spent.
232    */
233   function approve(address _spender, uint256 _value) public returns (bool) {
234     allowed[msg.sender][_spender] = _value;
235     emit Approval(msg.sender, _spender, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Function to check the amount of tokens that an owner allowed to a spender.
241    * @param _owner address The address which owns the funds.
242    * @param _spender address The address which will spend the funds.
243    * @return A uint256 specifying the amount of tokens still available for the spender.
244    */
245   function allowance(
246     address _owner,
247     address _spender
248    )
249     public
250     view
251     returns (uint256)
252   {
253     return allowed[_owner][_spender];
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseApproval(
266     address _spender,
267     uint256 _addedValue
268   )
269     public
270     returns (bool)
271   {
272     allowed[msg.sender][_spender] = (
273       allowed[msg.sender][_spender].add(_addedValue));
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278   /**
279    * @dev Decrease the amount of tokens that an owner allowed to a spender.
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(
288     address _spender,
289     uint256 _subtractedValue
290   )
291     public
292     returns (bool)
293   {
294     uint256 oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue > oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304 }
305 
306 /**
307  * @title Standard Burnable Token
308  * @dev Adds burnFrom method to ERC20 implementations
309  */
310 contract StandardBurnableToken is BurnableToken, StandardToken {
311 
312   /**
313    * @dev Burns a specific amount of tokens from the target address and decrements allowance
314    * @param _from address The address which you want to send tokens from
315    * @param _value uint256 The amount of token to be burned
316    */
317   function burnFrom(address _from, uint256 _value) public {
318     require(_value <= allowed[_from][msg.sender]);
319     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
320     // this function needs to emit an event with the updated approval.
321     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
322     _burn(_from, _value);
323   }
324 }
325 
326 contract WgdToken is StandardBurnableToken {
327   string public constant name = "webGold";
328   string public constant symbol = "WGD";
329   uint8 public constant decimals = 18;
330 
331   uint256 constant TOTAL = 387500000000000000000000000;
332 
333   constructor() public {
334     balances[msg.sender] = TOTAL;
335     totalSupply_ = TOTAL;
336     emit Transfer(address(0), msg.sender, TOTAL);
337   }
338 }
339 
340 /**
341  * @title Ownable
342  * @dev The Ownable contract has an owner address, and provides basic authorization control
343  * functions, this simplifies the implementation of "user permissions".
344  */
345 contract Ownable {
346   address public owner;
347 
348 
349   event OwnershipRenounced(address indexed previousOwner);
350   event OwnershipTransferred(
351     address indexed previousOwner,
352     address indexed newOwner
353   );
354 
355 
356   /**
357    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
358    * account.
359    */
360   constructor() public {
361     owner = msg.sender;
362   }
363 
364   /**
365    * @dev Throws if called by any account other than the owner.
366    */
367   modifier onlyOwner() {
368     require(msg.sender == owner);
369     _;
370   }
371 
372   /**
373    * @dev Allows the current owner to relinquish control of the contract.
374    * @notice Renouncing to ownership will leave the contract without an owner.
375    * It will not be possible to call the functions with the `onlyOwner`
376    * modifier anymore.
377    */
378   function renounceOwnership() public onlyOwner {
379     emit OwnershipRenounced(owner);
380     owner = address(0);
381   }
382 
383   /**
384    * @dev Allows the current owner to transfer control of the contract to a newOwner.
385    * @param _newOwner The address to transfer ownership to.
386    */
387   function transferOwnership(address _newOwner) public onlyOwner {
388     _transferOwnership(_newOwner);
389   }
390 
391   /**
392    * @dev Transfers control of the contract to a newOwner.
393    * @param _newOwner The address to transfer ownership to.
394    */
395   function _transferOwnership(address _newOwner) internal {
396     require(_newOwner != address(0));
397     emit OwnershipTransferred(owner, _newOwner);
398     owner = _newOwner;
399   }
400 }
401 
402 /**
403  * @title Crowdsale
404  * @dev Crowdsale is a base contract for managing a token crowdsale,
405  * allowing investors to purchase tokens with ether. This contract implements
406  * such functionality in its most fundamental form and can be extended to provide additional
407  * functionality and/or custom behavior.
408  * The external interface represents the basic interface for purchasing tokens, and conform
409  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
410  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
411  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
412  * behavior.
413  */
414 contract DaonomicCrowdsale {
415   using SafeMath for uint256;
416 
417   // Amount of wei raised
418   uint256 public weiRaised;
419 
420   /**
421    * @dev This event should be emitted when user buys something
422    */
423   event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus, bytes txId);
424   /**
425    * @dev Should be emitted if new payment method added
426    */
427   event RateAdd(address token);
428   /**
429    * @dev Should be emitted if payment method removed
430    */
431   event RateRemove(address token);
432 
433   // -----------------------------------------
434   // Crowdsale external interface
435   // -----------------------------------------
436 
437   /**
438    * @dev fallback function ***DO NOT OVERRIDE***
439    */
440   function () external payable {
441     buyTokens(msg.sender);
442   }
443 
444   /**
445    * @dev low level token purchase ***DO NOT OVERRIDE***
446    * @param _beneficiary Address performing the token purchase
447    */
448   function buyTokens(address _beneficiary) public payable {
449 
450     uint256 weiAmount = msg.value;
451     _preValidatePurchase(_beneficiary, weiAmount);
452 
453     // calculate token amount to be created
454     (uint256 tokens, uint256 left) = _getTokenAmount(weiAmount);
455     uint256 weiEarned = weiAmount.sub(left);
456     uint256 bonus = _getBonus(tokens);
457     uint256 withBonus = tokens.add(bonus);
458 
459     // update state
460     weiRaised = weiRaised.add(weiEarned);
461 
462     _processPurchase(_beneficiary, withBonus);
463     emit Purchase(
464       _beneficiary,
465       address(0),
466         weiEarned,
467       tokens,
468       bonus,
469       ""
470     );
471 
472     _updatePurchasingState(_beneficiary, weiEarned, withBonus);
473     _postValidatePurchase(_beneficiary, weiEarned);
474 
475     if (left > 0) {
476       _beneficiary.transfer(left);
477     }
478   }
479 
480   // -----------------------------------------
481   // Internal interface (extensible)
482   // -----------------------------------------
483 
484   /**
485    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
486    * @param _beneficiary Address performing the token purchase
487    * @param _weiAmount Value in wei involved in the purchase
488    */
489   function _preValidatePurchase(
490     address _beneficiary,
491     uint256 _weiAmount
492   )
493     internal
494   {
495     require(_beneficiary != address(0));
496     require(_weiAmount != 0);
497   }
498 
499   /**
500    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
501    * @param _beneficiary Address performing the token purchase
502    * @param _weiAmount Value in wei involved in the purchase
503    */
504   function _postValidatePurchase(
505     address _beneficiary,
506     uint256 _weiAmount
507   )
508     internal
509   {
510     // optional override
511   }
512 
513   /**
514    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
515    * @param _beneficiary Address performing the token purchase
516    * @param _tokenAmount Number of tokens to be emitted
517    */
518   function _deliverTokens(
519     address _beneficiary,
520     uint256 _tokenAmount
521   ) internal;
522 
523   /**
524    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
525    * @param _beneficiary Address receiving the tokens
526    * @param _tokenAmount Number of tokens to be purchased
527    */
528   function _processPurchase(
529     address _beneficiary,
530     uint256 _tokenAmount
531   )
532     internal
533   {
534     _deliverTokens(_beneficiary, _tokenAmount);
535   }
536 
537   /**
538    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
539    * @param _beneficiary Address receiving the tokens
540    * @param _weiAmount Value in wei involved in the purchase
541    */
542   function _updatePurchasingState(
543     address _beneficiary,
544     uint256 _weiAmount,
545     uint256 _tokens
546   )
547     internal
548   {
549     // optional override
550   }
551 
552   /**
553    * @dev Override to extend the way in which ether is converted to tokens.
554    * @param _weiAmount Value in wei to be converted into tokens
555    * @return Number of tokens that can be purchased with the specified _weiAmount
556    *         and wei left (if no more tokens can be sold)
557    */
558   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256, uint256);
559 
560   function _getBonus(uint256 _tokens) internal view returns (uint256);
561 }
562 
563 contract Whitelist {
564   function isInWhitelist(address addr) public view returns (bool);
565 }
566 
567 contract WhitelistDaonomicCrowdsale is Ownable, DaonomicCrowdsale {
568   Whitelist[] public whitelists;
569 
570   constructor (Whitelist[] _whitelists) public {
571     whitelists = _whitelists;
572   }
573 
574   function setWhitelists(Whitelist[] _whitelists) onlyOwner public {
575     whitelists = _whitelists;
576   }
577 
578   function getWhitelists() view public returns (Whitelist[]) {
579     return whitelists;
580   }
581 
582   function _preValidatePurchase(
583     address _beneficiary,
584     uint256 _weiAmount
585   ) internal {
586     super._preValidatePurchase(_beneficiary, _weiAmount);
587     require(canBuy(_beneficiary), "investor is not verified by Whitelists");
588   }
589 
590   function canBuy(address _beneficiary) constant public returns (bool) {
591     for (uint i = 0; i < whitelists.length; i++) {
592       if (whitelists[i].isInWhitelist(_beneficiary)) {
593         return true;
594       }
595     }
596     return false;
597   }
598 }
599 
600 contract RefundableDaonomicCrowdsale is DaonomicCrowdsale {
601   event Refund(address _address, uint256 investment);
602   mapping(address => uint256) public investments;
603 
604   function claimRefund() public {
605     require(isRefundable());
606     require(investments[msg.sender] > 0);
607 
608     uint investment = investments[msg.sender];
609     investments[msg.sender] = 0;
610 
611     msg.sender.transfer(investment);
612     emit Refund(msg.sender, investment);
613   }
614 
615   function isRefundable() public view returns (bool);
616 
617   function _updatePurchasingState(
618     address _beneficiary,
619     uint256 _weiAmount,
620     uint256 _tokens
621   ) internal {
622     super._updatePurchasingState(_beneficiary, _weiAmount, _tokens);
623     investments[_beneficiary] = investments[_beneficiary].add(_weiAmount);
624   }
625 }
626 
627 contract WgdSale is WhitelistDaonomicCrowdsale, RefundableDaonomicCrowdsale {
628   using SafeERC20 for WgdToken;
629 
630   event Buyback(address indexed addr, uint256 tokens, uint256 value);
631 
632   WgdToken public token;
633 
634   uint256 constant public FOR_SALE = 300000000000000000000000000;
635   uint256 constant public MINIMAL_WEI = 500000000000000000;
636   uint256 constant public END = 1541592000;
637 
638   //stages
639   uint256 constant STAGE1 = 20000000000000000000000000;
640   uint256 constant STAGE2 = 60000000000000000000000000;
641   uint256 constant STAGE3 = 140000000000000000000000000;
642   uint256 constant STAGE4 = 300000000000000000000000000;
643 
644   //rates
645   uint256 constant RATE1 = 28000;
646   uint256 constant RATE2 = 24000;
647   uint256 constant RATE3 = 22000;
648   uint256 constant RATE4 = 20000;
649 
650   //bonus stages
651   uint256 constant BONUS_STAGE1 = 100000000000000000000000;
652   uint256 constant BONUS_STAGE2 = 500000000000000000000000;
653   uint256 constant BONUS_STAGE3 = 1000000000000000000000000;
654   uint256 constant BONUS_STAGE4 = 5000000000000000000000000;
655 
656   //bonuses
657   uint256 constant BONUS1 = 1000000000000000000000;
658   uint256 constant BONUS2 = 25000000000000000000000;
659   uint256 constant BONUS3 = 100000000000000000000000;
660   uint256 constant BONUS4 = 750000000000000000000000;
661 
662   uint256 public sold;
663 
664   constructor(WgdToken _token, Whitelist[] _whitelists)
665   WhitelistDaonomicCrowdsale(_whitelists) public {
666     token = _token;
667     emit RateAdd(address(0));
668   }
669 
670   function _preValidatePurchase(
671     address _beneficiary,
672     uint256 _weiAmount
673   ) internal {
674     super._preValidatePurchase(_beneficiary, _weiAmount);
675     require(_weiAmount >= MINIMAL_WEI);
676   }
677 
678   /**
679    * @dev function for Daonomic UI
680    */
681   function getRate(address _token) public view returns (uint256) {
682     if (_token == address(0)) {
683       (,, uint256 rate) = getStage(sold);
684       return rate.mul(10 ** 18);
685     } else {
686       return 0;
687     }
688   }
689 
690   /**
691    * @dev Executes buyback
692    * @dev burns all allowed tokens and returns back Eth
693    * @dev call token.approve before calling this function
694    */
695   function buyback() public {
696     (uint8 stage,,) = getStage(sold);
697     require(stage > 0, "buyback doesn't work on stage 0");
698 
699     uint256 approved = token.allowance(msg.sender, this);
700     uint256 inCirculation = token.totalSupply().sub(token.balanceOf(this));
701     uint256 value = approved.mul(address(this).balance).div(inCirculation);
702 
703     token.burnFrom(msg.sender, approved);
704     msg.sender.transfer(value);
705     emit Buyback(msg.sender, approved, value);
706   }
707 
708   function _deliverTokens(
709     address _beneficiary,
710     uint256 _tokenAmount
711   ) internal {
712     token.safeTransfer(_beneficiary, _tokenAmount);
713   }
714 
715   function _getBonus(uint256 _tokens) internal view returns (uint256) {
716     return getRealAmountBonus(FOR_SALE, sold, _tokens);
717   }
718 
719   function getRealAmountBonus(uint256 _forSale, uint256 _sold, uint256 _tokens) public pure returns (uint256) {
720     uint256 bonus = getAmountBonus(_tokens);
721     uint256 left = _forSale.sub(_sold).sub(_tokens);
722     if (left > bonus) {
723       return bonus;
724     } else {
725       return left;
726     }
727   }
728 
729   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256, uint256) {
730     return getTokenAmount(sold, _weiAmount);
731   }
732 
733   function getTokenAmount(uint256 _sold, uint256 _weiAmount) public view returns (uint256 tokens, uint256 left) {
734     left = _weiAmount;
735     while (left > 0) {
736       (uint256 currentTokens, uint256 currentLeft) = getTokensForStage(_sold.add(tokens), left);
737       if (left == currentLeft) {
738         return (tokens, left);
739       }
740       left = currentLeft;
741       tokens = tokens.add(currentTokens);
742     }
743   }
744 
745   /**
746    * @dev Calculates tokens for this stage
747    * @return Number of tokens that can be purchased in this stage + wei left
748    */
749   function getTokensForStage(uint256 _sold, uint256 _weiAmount) public view returns (uint256 tokens, uint256 left) {
750     (uint8 stage, uint256 limit, uint256 rate) = getStage(_sold);
751     if (stage == 4) {
752       return (0, _weiAmount);
753     }
754     if (stage == 0 && now > END) {
755       revert("Sale is refundable, unable to buy");
756     }
757     tokens = _weiAmount.mul(rate);
758     left = 0;
759     (uint8 newStage,,) = getStage(_sold.add(tokens));
760     if (newStage != stage) {
761       tokens = limit.sub(_sold);
762       //alternative to Math.ceil(tokens / rate)
763       uint256 weiSpent = (tokens.add(rate).sub(1)).div(rate);
764       left = _weiAmount.sub(weiSpent);
765     }
766   }
767 
768   function _updatePurchasingState(
769     address _beneficiary,
770     uint256 _weiAmount,
771     uint256 _tokens
772   ) internal {
773     super._updatePurchasingState(_beneficiary, _weiAmount, _tokens);
774 
775     sold = sold.add(_tokens);
776   }
777 
778   function isRefundable() public view returns (bool) {
779     (uint8 stage,,) = getStage(sold);
780     return now > END && stage == 0;
781   }
782 
783   function getStage(uint256 _sold) public pure returns (uint8 stage, uint256 limit, uint256 rate) {
784     if (_sold < STAGE1) {
785       return (0, STAGE1, RATE1);
786     } else if (_sold < STAGE2) {
787       return (1, STAGE2, RATE2);
788     } else if (_sold < STAGE3) {
789       return (2, STAGE3, RATE3);
790     } else if (_sold < STAGE4) {
791       return (3, STAGE4, RATE4);
792     } else {
793       return (4, 0, 0);
794     }
795   }
796 
797   function getAmountBonus(uint256 _tokens) public pure returns (uint256) {
798     if (_tokens < BONUS_STAGE1) {
799       return 0;
800     } else if (_tokens < BONUS_STAGE2) {
801       return BONUS1;
802     } else if (_tokens < BONUS_STAGE3) {
803       return BONUS2;
804     } else if (_tokens < BONUS_STAGE4) {
805       return BONUS3;
806     } else {
807       return BONUS4;
808     }
809   }
810 }