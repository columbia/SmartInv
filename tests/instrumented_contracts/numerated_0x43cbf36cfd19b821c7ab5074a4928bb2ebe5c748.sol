1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 
46 contract Ownable {
47     address public owner;
48 
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53     /**
54     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55     * account.
56     */
57     function Ownable() public {
58         owner = msg.sender;
59     }
60 
61     /**
62     * @dev Throws if called by any account other than the owner.
63     */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     /**
70     * @dev Allows the current owner to transfer control of the contract to a newOwner.
71     * @param newOwner The address to transfer ownership to.
72     */
73     function transferOwnership(address newOwner) public onlyOwner {
74         require(newOwner != address(0));
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77     }
78 
79 }
80 
81 
82 contract ERC20Basic {
83     function totalSupply() public view returns (uint256);
84     function balanceOf(address who) public view returns (uint256);
85     function transfer(address to, uint256 value) public returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public view returns (uint256);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 /**
99  * @title Crowdsale
100  * @dev Crowdsale is a base contract for managing a token crowdsale,
101  * allowing investors to purchase tokens with ether. This contract implements
102  * such functionality in its most fundamental form and can be extended to provide additional
103  * functionality and/or custom behavior.
104  * The external interface represents the basic interface for purchasing tokens, and conform
105  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
106  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
107  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
108  * behavior.
109  */
110 
111 contract Crowdsale {
112     using SafeMath for uint256;
113 
114     // The token being sold
115     ERC20 public token;
116 
117     // Address where funds are collected
118     address public wallet;
119 
120     // How many token units a buyer gets per wei
121     uint256 public rate;
122 
123     // Amount of wei raised
124     uint256 public weiRaised;
125 
126     /**
127     * Event for token purchase logging
128     * @param purchaser who paid for the tokens
129     * @param beneficiary who got the tokens
130     * @param value weis paid for purchase
131     * @param amount amount of tokens purchased
132     */
133     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
134 
135     /**
136     * @param _rate Number of token units a buyer gets per wei
137     * @param _wallet Address where collected funds will be forwarded to
138     * @param _token Address of the token being sold
139     */
140     function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
141         require(_rate > 0);
142         require(_wallet != address(0));
143         require(_token != address(0));
144 
145         rate = _rate;
146         wallet = _wallet;
147         token = _token;
148     }
149 
150     // -----------------------------------------
151     // Crowdsale external interface
152     // -----------------------------------------
153 
154     /**
155     * @dev fallback function ***DO NOT OVERRIDE***
156     */
157     function () external payable {
158         buyTokens(msg.sender);
159     }
160 
161     /**
162     * @dev low level token purchase ***DO NOT OVERRIDE***
163     * @param _beneficiary Address performing the token purchase
164     */
165     function buyTokens(address _beneficiary) public payable {
166 
167         uint256 weiAmount = msg.value;
168         _preValidatePurchase(_beneficiary, weiAmount);
169 
170         // calculate token amount to be created
171         uint256 tokens = _getTokenAmount(weiAmount);
172 
173         // update state
174         weiRaised = weiRaised.add(weiAmount);
175 
176         _processPurchase(_beneficiary, tokens);
177         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
178 
179         _updatePurchasingState(_beneficiary, weiAmount);
180 
181         _forwardFunds();
182         _postValidatePurchase(_beneficiary, weiAmount);
183     }
184 
185     // -----------------------------------------
186     // Internal interface (extensible)
187     // -----------------------------------------
188 
189     /**
190     * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
191     * @param _beneficiary Address performing the token purchase
192     * @param _weiAmount Value in wei involved in the purchase
193     */
194     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
195         require(_beneficiary != address(0));
196         require(_weiAmount != 0);
197     }
198 
199     /**
200     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
201     * @param _beneficiary Address performing the token purchase
202     * @param _weiAmount Value in wei involved in the purchase
203     */
204     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
205         // optional override
206     }
207 
208     /**
209     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
210     * @param _beneficiary Address performing the token purchase
211     * @param _tokenAmount Number of tokens to be emitted
212     */
213     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
214         token.transfer(_beneficiary, _tokenAmount);
215     }
216 
217     /**
218     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
219     * @param _beneficiary Address receiving the tokens
220     * @param _tokenAmount Number of tokens to be purchased
221     */
222     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
223         _deliverTokens(_beneficiary, _tokenAmount);
224     }
225 
226     /**
227     * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
228     * @param _beneficiary Address receiving the tokens
229     * @param _weiAmount Value in wei involved in the purchase
230     */
231     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
232         // optional override
233     }
234 
235     /**
236     * @dev Override to extend the way in which ether is converted to tokens.
237     * @param _weiAmount Value in wei to be converted into tokens
238     * @return Number of tokens that can be purchased with the specified _weiAmount
239     */
240     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
241         return _weiAmount.mul(rate);
242     }
243 
244     /**
245     * @dev Determines how ETH is stored/forwarded on purchases.
246     */
247     function _forwardFunds() internal {
248         wallet.transfer(msg.value);
249     }
250 }
251 
252 contract WhitelistedCrowdsale is Crowdsale, Ownable {
253 
254     mapping(address => bool) public whitelist;
255 
256     /**
257     * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
258     */
259     modifier isWhitelisted(address _beneficiary) {
260         require(whitelist[_beneficiary]);
261         _;
262     }
263 
264     /**
265     * @dev Adds single address to whitelist.
266     * @param _beneficiary Address to be added to the whitelist
267     */
268     function addToWhitelist(address _beneficiary) external onlyOwner {
269         whitelist[_beneficiary] = true;
270     }
271 
272     /**
273     * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
274     * @param _beneficiaries Addresses to be added to the whitelist
275     */
276     function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
277         for (uint256 i = 0; i < _beneficiaries.length; i++) {
278             whitelist[_beneficiaries[i]] = true;
279         }
280     }
281 
282     /**
283     * @dev Removes single address from whitelist.
284     * @param _beneficiary Address to be removed to the whitelist
285     */
286     function removeFromWhitelist(address _beneficiary) external onlyOwner {
287         whitelist[_beneficiary] = false;
288     }
289 
290     /**
291     * @dev Extend parent behavior requiring beneficiary to be in whitelist.
292     * @param _beneficiary Token beneficiary
293     * @param _weiAmount Amount of wei contributed
294     */
295     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
296         super._preValidatePurchase(_beneficiary, _weiAmount);
297     }
298 
299 }
300 
301 
302 contract BasicToken is ERC20Basic {
303     using SafeMath for uint256;
304 
305     mapping(address => uint256) balances;
306 
307     uint256 totalSupply_;
308 
309     /**
310     * @dev total number of tokens in existence
311     */
312     function totalSupply() public view returns (uint256) {
313         return totalSupply_;
314     }
315 
316     /**
317     * @dev transfer token for a specified address
318     * @param _to The address to transfer to.
319     * @param _value The amount to be transferred.
320     */
321     function transfer(address _to, uint256 _value) public returns (bool) {
322         require(_to != address(0));
323         require(_value <= balances[msg.sender]);
324 
325         // SafeMath.sub will throw if there is not enough balance.
326         balances[msg.sender] = balances[msg.sender].sub(_value);
327         balances[_to] = balances[_to].add(_value);
328         emit Transfer(msg.sender, _to, _value);
329         return true;
330     }
331 
332     /**
333     * @dev Gets the balance of the specified address.
334     * @param _owner The address to query the the balance of.
335     * @return An uint256 representing the amount owned by the passed address.
336     */
337     function balanceOf(address _owner) public view returns (uint256 balance) {
338         return balances[_owner];
339     }
340 
341 }
342 
343 
344 contract StandardToken is ERC20, BasicToken {
345 
346     mapping (address => mapping (address => uint256)) internal allowed;
347 
348 
349     /**
350     * @dev Transfer tokens from one address to another
351     * @param _from address The address which you want to send tokens from
352     * @param _to address The address which you want to transfer to
353     * @param _value uint256 the amount of tokens to be transferred
354     */
355     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
356         require(_to != address(0));
357         require(_value <= balances[_from]);
358         require(_value <= allowed[_from][msg.sender]);
359 
360         balances[_from] = balances[_from].sub(_value);
361         balances[_to] = balances[_to].add(_value);
362         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
363         emit Transfer(_from, _to, _value);
364         return true;
365     }
366 
367     /**
368     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
369     *
370     * Beware that changing an allowance with this method brings the risk that someone may use both the old
371     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
372     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
373     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374     * @param _spender The address which will spend the funds.
375     * @param _value The amount of tokens to be spent.
376     */
377     function approve(address _spender, uint256 _value) public returns (bool) {
378         allowed[msg.sender][_spender] = _value;
379         emit Approval(msg.sender, _spender, _value);
380         return true;
381     }
382 
383     /**
384     * @dev Function to check the amount of tokens that an owner allowed to a spender.
385     * @param _owner address The address which owns the funds.
386     * @param _spender address The address which will spend the funds.
387     * @return A uint256 specifying the amount of tokens still available for the spender.
388     */
389     function allowance(address _owner, address _spender) public view returns (uint256) {
390         return allowed[_owner][_spender];
391     }
392 
393     /**
394     * @dev Increase the amount of tokens that an owner allowed to a spender.
395     *
396     * approve should be called when allowed[_spender] == 0. To increment
397     * allowed value is better to use this function to avoid 2 calls (and wait until
398     * the first transaction is mined)
399     * From MonolithDAO Token.sol
400     * @param _spender The address which will spend the funds.
401     * @param _addedValue The amount of tokens to increase the allowance by.
402     */
403     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
404         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
405         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
406         return true;
407     }
408 
409     /**
410     * @dev Decrease the amount of tokens that an owner allowed to a spender.
411     *
412     * approve should be called when allowed[_spender] == 0. To decrement
413     * allowed value is better to use this function to avoid 2 calls (and wait until
414     * the first transaction is mined)
415     * From MonolithDAO Token.sol
416     * @param _spender The address which will spend the funds.
417     * @param _subtractedValue The amount of tokens to decrease the allowance by.
418     */
419     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
420         uint oldValue = allowed[msg.sender][_spender];
421         if (_subtractedValue > oldValue) {
422             allowed[msg.sender][_spender] = 0;
423         } else {
424             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
425         }
426         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
427         return true;
428     }
429 
430 }
431 
432 
433 contract GStarToken is StandardToken, Ownable {
434     using SafeMath for uint256;
435 
436     string public constant name = "GSTAR Token";
437     string public constant symbol = "GSTAR";
438     uint8 public constant decimals = 18;
439 
440     uint256 public constant INITIAL_SUPPLY = 1600000000 * ((10 ** uint256(decimals)));
441     uint256 public currentTotalSupply = 0;
442 
443     event Burn(address indexed burner, uint256 value);
444 
445 
446     /**
447     * @dev Constructor that gives msg.sender all of existing tokens.
448     */
449     function GStarToken() public {
450         owner = msg.sender;
451         totalSupply_ = INITIAL_SUPPLY;
452         balances[owner] = INITIAL_SUPPLY;
453         currentTotalSupply = INITIAL_SUPPLY;
454         emit Transfer(address(0), owner, INITIAL_SUPPLY);
455     }
456 
457     /**
458     * @dev Burns a specific amount of tokens.
459     * @param value The amount of token to be burned.
460     */
461     function burn(uint256 value) public onlyOwner {
462         require(value <= balances[msg.sender]);
463 
464         address burner = msg.sender;
465         balances[burner] = balances[burner].sub(value);
466         currentTotalSupply = currentTotalSupply.sub(value);
467         emit Burn(burner, value);
468     }
469 }
470 
471 
472 /**
473  * @title GStarCrowdsale
474  * @dev This contract manages the crowdsale of GStar Tokens.
475  * The crowdsale will involve two key timings - Start and ending of funding.
476  * The earlier the contribution, the larger the bonuses. (according to the bonus structure)
477  * Tokens will be released to the contributors after the crowdsale.
478  * There is only one owner at any one time. The owner can stop or start the crowdsale at anytime.
479  */
480 contract GStarCrowdsale is WhitelistedCrowdsale {
481     using SafeMath for uint256;
482 
483     // Start and end timestamps where contributions are allowed (both inclusive)
484     // All timestamps are expressed in seconds instead of block number.
485     uint256 constant public presaleStartTime = 1531051200; // 8 Jul 2018 1200h
486     uint256 constant public startTime = 1532260800; // 22 Jul 2018 1200h
487     uint256 constant public endTime = 1534593600; // 18 Aug 2018 1200h
488 
489     // Keeps track of contributors tokens
490     mapping (address => uint256) public depositedTokens;
491 
492     // Minimum amount of ETH contribution during ICO period
493     // Minimum of ETH contributed during ICO is 0.1ETH
494     uint256 constant public MINIMUM_PRESALE_PURCHASE_AMOUNT_IN_WEI = 1 ether;
495     uint256 constant public MINIMUM_PURCHASE_AMOUNT_IN_WEI = 0.1 ether;
496 
497     // Total tokens raised so far, bonus inclusive
498     uint256 public tokensWeiRaised = 0;
499 
500     //Funding goal is 76,000 ETH, includes private contributions
501     uint256 constant public fundingGoal = 76000 ether;
502     uint256 constant public presaleFundingGoal = 1000 ether;
503     bool public fundingGoalReached = false;
504     bool public presaleFundingGoalReached = false;
505 
506     //private contributions
507     uint256 public privateContribution = 0;
508 
509     // Indicates if crowdsale is active
510     bool public crowdsaleActive = false;
511     bool public isCrowdsaleClosed = false;
512 
513     uint256 public tokensReleasedAmount = 0;
514 
515 
516     /*==================================================================== */
517     /*============================== EVENTS ============================== */
518     /*==================================================================== */
519 
520     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
521     event GoalReached(uint256 totalEtherAmountRaised);
522     event PresaleGoalReached(uint256 totalEtherAmountRaised);
523     event StartCrowdsale();
524     event StopCrowdsale();
525     event ReleaseTokens(address[] _beneficiaries);
526     event Close();
527 
528     /**
529     * @dev Constructor. Checks validity of the time entered.
530     */
531     function GStarCrowdsale (
532         uint256 _rate,
533         address _wallet,
534         GStarToken token
535         ) public Crowdsale(_rate, _wallet, token) {
536     }
537 
538 
539     /*==================================================================== */
540     /*========================= PUBLIC FUNCTIONS ========================= */
541     /*==================================================================== */
542 
543     /**
544     * @dev Override buyTokens function as tokens should only be delivered when released.
545     * @param _beneficiary Address receiving the tokens.
546     */
547     function buyTokens(address _beneficiary) public payable {
548 
549         uint256 weiAmount = msg.value;
550         _preValidatePurchase(_beneficiary, weiAmount);
551 
552         // calculate token amount to be created
553         uint256 tokens = _getTokenAmount(weiAmount);
554 
555         // update state
556         weiRaised = weiRaised.add(weiAmount);
557         
558         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
559 
560         _updatePurchasingState(_beneficiary, weiAmount);
561 
562         _forwardFunds();
563         _processPurchase(_beneficiary, weiAmount);
564     }
565 
566     /**
567     * @dev Calculates the token amount per ETH contributed based on the time now.
568     * @return Rate of amount of GSTAR per Ether as of current time.
569     */
570     function getRate() public view returns (uint256) {
571         //calculate bonus based on timing
572         if (block.timestamp <= startTime) { return ((rate / 100) * 120); } // 20 percent bonus on presale period, returns 12000
573         if (block.timestamp <= startTime.add(1 days)) {return ((rate / 100) * 108);} // 8 percent bonus on day one, return 10800
574 
575         return rate;
576     }
577 
578 
579     /*==================================================================== */
580     /*======================== EXTERNAL FUNCTIONS ======================== */
581     /*==================================================================== */
582 
583     /**
584     * @dev Change the private contribution, in ether, wei units.
585     * Private contribution amount will be calculated into funding goal.
586     */
587     function changePrivateContribution(uint256 etherWeiAmount) external onlyOwner {
588         privateContribution = etherWeiAmount;
589     }
590 
591     /**
592     * @dev Allows owner to start/unpause crowdsale.
593     */
594     function startCrowdsale() external onlyOwner {
595         require(!crowdsaleActive);
596         require(!isCrowdsaleClosed);
597 
598         crowdsaleActive = true;
599         emit StartCrowdsale();
600     }
601 
602     /**
603     * @dev Allows owner to stop/pause crowdsale.
604     */
605     function stopCrowdsale() external onlyOwner {
606         require(crowdsaleActive);
607         crowdsaleActive = false;
608         emit StopCrowdsale();
609     }
610 
611     /**
612     * @dev Release tokens to multiple addresses.
613     * @param contributors Addresses to release tokens to
614     */
615     function releaseTokens(address[] contributors) external onlyOwner {
616 
617         for (uint256 j = 0; j < contributors.length; j++) {
618 
619             // the amount of tokens to be distributed to contributor
620             uint256 tokensAmount = depositedTokens[contributors[j]];
621 
622             if (tokensAmount > 0) {
623                 super._deliverTokens(contributors[j], tokensAmount);
624 
625                 depositedTokens[contributors[j]] = 0;
626 
627                 //update state of release
628                 tokensReleasedAmount = tokensReleasedAmount.add(tokensAmount);
629             }
630         }
631     }
632 
633     /**
634     * @dev Stops crowdsale and release of tokens. Transfer remainining tokens back to owner.
635     */
636     function close() external onlyOwner {
637         crowdsaleActive = false;
638         isCrowdsaleClosed = true;
639         
640         token.transfer(owner, token.balanceOf(address(this)));
641         emit Close();
642     }
643 
644 
645     /*==================================================================== */
646     /*======================== INTERNAL FUNCTIONS ======================== */
647     /*==================================================================== */
648 
649     /**
650     * @dev Overrides _preValidatePurchase function in Crowdsale.
651     * Requires purchase is made within crowdsale period.
652     * Requires contributor to be the beneficiary.
653     * Requires purchase value and address to be non-zero.
654     * Requires amount not to exceed funding goal.
655     * Requires purchase value to be higher or equal to minimum amount.
656     * Requires contributor to be whitelisted.
657     */
658     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
659         bool withinPeriod = now >= presaleStartTime && now <= endTime;
660 
661         bool atLeastMinimumAmount = false;
662 
663         if(block.timestamp <= startTime) {
664             // during presale period
665 
666             require(_weiAmount.add(weiRaised.add(privateContribution)) <= presaleFundingGoal);
667             atLeastMinimumAmount = _weiAmount >= MINIMUM_PRESALE_PURCHASE_AMOUNT_IN_WEI;
668             
669         } else {
670             // during funding period
671             atLeastMinimumAmount = _weiAmount >= MINIMUM_PURCHASE_AMOUNT_IN_WEI;
672         }
673 
674         super._preValidatePurchase(_beneficiary, _weiAmount);
675         require(msg.sender == _beneficiary);
676         require(_weiAmount.add(weiRaised.add(privateContribution)) <= fundingGoal);
677         require(withinPeriod);
678         require(atLeastMinimumAmount);
679         require(crowdsaleActive);
680     }
681 
682     /**
683     * @dev Overrides _getTokenAmount function in Crowdsale.
684     * Calculates token amount, inclusive of bonus, based on ETH contributed.
685     * @param _weiAmount Value in wei to be converted into tokens
686     * @return Number of tokens that can be purchased with the specified _weiAmount
687     */
688     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
689         return _weiAmount.mul(getRate());
690     }
691 
692     /**
693     * @dev Overrides _updatePurchasingState function from Crowdsale.
694     * Updates tokenWeiRaised amount and funding goal status.
695     */
696     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
697         tokensWeiRaised = tokensWeiRaised.add(_getTokenAmount(_weiAmount));
698         _updateFundingGoal();
699     }
700 
701     /**
702     * @dev Overrides _processPurchase function from Crowdsale.
703     * Adds the tokens purchased to the beneficiary.
704     * @param _tokenAmount The token amount in wei before multiplied by the rate.
705     */
706     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
707         depositedTokens[_beneficiary] = depositedTokens[_beneficiary].add(_getTokenAmount(_tokenAmount));
708     }
709 
710     /**
711     * @dev Updates fundingGoal status.
712     */
713     function _updateFundingGoal() internal {
714         if (weiRaised.add(privateContribution) >= fundingGoal) {
715             fundingGoalReached = true;
716             emit GoalReached(weiRaised.add(privateContribution));
717         }
718 
719         if(block.timestamp <= startTime) {
720             if(weiRaised.add(privateContribution) >= presaleFundingGoal) {
721                 
722                 presaleFundingGoalReached = true;
723                 emit PresaleGoalReached(weiRaised.add(privateContribution));
724             }
725         }
726     }
727 
728 
729 
730 }