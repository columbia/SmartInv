1 pragma solidity ^0.4.25;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public view returns (uint256);
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function approve(address spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library Math {
18     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
19         return a >= b ? a : b;
20     }
21 
22     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
23         return a < b ? a : b;
24     }
25 
26     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a >= b ? a : b;
28     }
29 
30     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
31         return a < b ? a : b;
32     }
33 }
34 
35 library SafeMath {
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a * b;
38         assert(a == 0 || c / a == b);
39         return c;
40     }
41 
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         assert(b <= a);
51         return a - b;
52     }
53 
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         assert(c >= a);
57         return c;
58     }
59 }
60 
61 contract BasicToken is ERC20Basic {
62     using SafeMath for uint256;
63 
64     mapping(address => uint256) balances;
65     mapping(address => bool) blockListed;
66 
67     /**
68     * @dev transfer token for a specified address
69     * @param _to The address to transfer to.
70     * @param _value The amount to be transferred.
71     */
72     function transfer(address _to, uint256 _value) public returns (bool) {
73         require(_to != address(0));
74         
75         require(
76             balances[msg.sender] >= _value
77             && _value > 0
78             && !blockListed[_to]
79             && !blockListed[msg.sender]
80         );
81 
82         // SafeMath.sub will throw if there is not enough balance.
83         balances[msg.sender] = balances[msg.sender].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         emit Transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     /**
90     * @dev Gets the balance of the specified address.
91     * @param _owner The address to query the the balance of.
92     * @return An uint256 representing the amount owned by the passed address.
93     */
94     function balanceOf(address _owner) public view returns (uint256 balance) {
95         return balances[_owner];
96     }
97 }
98 
99 contract StandardToken is ERC20, BasicToken {
100 
101     mapping (address => mapping (address => uint256)) allowed;
102 
103     /**
104     * @dev Transfer tokens from one address to another
105     * @param _from address The address which you want to send tokens from
106     * @param _to address The address which you want to transfer to
107     * @param _value uint256 the amount of tokens to be transferred
108     */
109 
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111         require(
112             _to != address(0)
113             && balances[msg.sender] >= _value
114             && balances[_from] >= _value
115             && _value > 0
116             && !blockListed[_to]
117             && !blockListed[msg.sender]
118         );
119 
120         uint256 _allowance = allowed[_from][msg.sender];
121 
122         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
123         // require (_value <= _allowance);
124 
125         balances[_from] = balances[_from].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         allowed[_from][msg.sender] = _allowance.sub(_value);
128         emit Transfer(_from, _to, _value);
129         return true;
130     }
131 
132     /**
133     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134     *
135     * Beware that changing an allowance with this method brings the risk that someone may use both the old
136     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
137     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
138     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139     * @param _spender The address which will spend the funds.
140     * @param _value The amount of tokens to be spent.
141     */
142     function approve(address _spender, uint256 _value) public returns (bool) {
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     /**
149     * @dev Function to check the amount of tokens that an owner allowed to a spender.
150     * @param _owner address The address which owns the funds.
151     * @param _spender address The address which will spend the funds.
152     * @return A uint256 specifying the amount of tokens still available for the spender.
153     */
154     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
155         return allowed[_owner][_spender];
156     }
157 }
158 
159 library SafeERC20 {
160     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
161         assert(token.transfer(to, value));
162     }
163 
164     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
165         assert(token.transferFrom(from, to, value));
166     }
167 
168     function safeApprove(ERC20 token, address spender, uint256 value) internal {
169         assert(token.approve(spender, value));
170     }
171 }
172 
173 contract BurnableToken is StandardToken {
174 
175     event Burn(address indexed burner, uint256 value);
176 
177     /**
178      * @dev Burns a specific amount of tokens.
179      * @param _value The amount of token to be burned.
180      */
181     function burn(uint256 _value) public {
182         require(_value > 0);
183 
184         address burner = msg.sender;
185         balances[burner] = balances[burner].sub(_value);
186         totalSupply = totalSupply.sub(_value);
187         emit Burn(burner, _value);
188     }
189 }
190 
191 contract Ownable {
192     address internal owner;
193 
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197 
198     /**
199     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200     * account.
201     */
202     constructor() public {
203         owner = msg.sender;
204     }
205 
206 
207     /**
208     * @dev Throws if called by any account other than the owner.
209     */
210     modifier onlyOwner() {
211         require(msg.sender == owner);
212         _;
213     }
214 
215 
216     /**
217     * @dev Allows the current owner to transfer control of the contract to a newOwner.
218     * @param newOwner The address to transfer ownership to.
219     */
220     function transferOwnership(address newOwner) onlyOwner public {
221         require(newOwner != address(0));
222         emit OwnershipTransferred(owner, newOwner);
223         owner = newOwner;
224     }
225 }
226 
227 contract MintableToken is StandardToken, Ownable {
228     event Mint(address indexed to, uint256 amount);
229     event MintFinished();
230 
231     bool public mintingFinished = false;
232 
233 
234     modifier canMint() {
235         require(!mintingFinished);
236         _;
237     }
238 
239     /**
240     * @dev Function to mint tokens
241     * @param _to The address that will receive the minted tokens.
242     * @param _amount The amount of tokens to mint.
243     * @return A boolean that indicates if the operation was successful.
244     */
245 
246     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
247 
248         balances[_to] = balances[_to].add(_amount);
249         emit Mint(_to, _amount);
250         emit Transfer(msg.sender, _to, _amount);
251         return true;
252     }
253 
254     /**
255     * @dev Function to stop minting new tokens.
256     * @return True if the operation was successful.
257     */
258     function finishMinting() onlyOwner public returns (bool) {
259         mintingFinished = true;
260         emit MintFinished();
261         return true;
262     }
263 
264     function addBlockeddUser(address user) public onlyOwner {
265         blockListed[user] = true;
266     }
267 
268     function removeBlockeddUser(address user) public onlyOwner  {
269         blockListed[user] = false;
270     }
271 }
272 
273 contract PullPayment {
274     using SafeMath for uint256;
275 
276     mapping(address => uint256) public payments;
277     uint256 public totalPayments;
278 
279     /**
280     * @dev Called by the payer to store the sent amount as credit to be pulled.
281     * @param dest The destination address of the funds.
282     * @param amount The amount to transfer.
283     */
284     function asyncSend(address dest, uint256 amount) internal {
285         payments[dest] = payments[dest].add(amount);
286         totalPayments = totalPayments.add(amount);
287     }
288 
289     /**
290     * @dev withdraw accumulated balance, called by payee.
291     */
292     function withdrawPayments() public {
293         address payee = msg.sender;
294         uint256 payment = payments[payee];
295 
296         require(payment != 0);
297         require(this.balance >= payment);
298 
299         totalPayments = totalPayments.sub(payment);
300         payments[payee] = 0;
301 
302         assert(payee.send(payment));
303     }
304 }
305 
306 
307 contract AutoCoinToken is MintableToken {
308 
309   /**
310    *  @string name - Token Name
311    *  @string symbol - Token Symbol
312    *  @uint8 decimals - Token Decimals
313    *  @uint256 _totalSupply - Token Total Supply
314   */
315 
316     string public constant name = "AUTO COIN";
317     string public constant symbol = "AUTO COIN";
318     uint8 public constant decimals = 18;
319     uint256 public constant _totalSupply = 400000000000000000000000000;
320 
321 /** Constructor AutoCoinToken */
322     constructor() public {
323         totalSupply = _totalSupply;
324     }
325 }
326 
327 contract Pausable is Ownable {
328     event Pause();
329     event Unpause();
330 
331     bool public paused = false;
332 
333 
334     /**
335     * @dev Modifier to make a function callable only when the contract is not paused.
336     */
337     modifier whenNotPaused() {
338         require(!paused);
339         _;
340     }
341 
342     /**
343     * @dev Modifier to make a function callable only when the contract is paused.
344     */
345     modifier whenPaused() {
346         require(paused);
347         _;
348     }
349 
350     /**
351     * @dev called by the owner to pause, triggers stopped state
352     */
353     function pause() onlyOwner whenNotPaused public {
354         paused = true;
355         emit Pause();
356     }
357 
358     /**
359     * @dev called by the owner to unpause, returns to normal state
360     */
361     function unpause() onlyOwner whenPaused public {
362         paused = false;
363         emit Unpause();
364     }
365 }
366 
367 
368 contract Crowdsale is Ownable, Pausable {
369     using SafeMath for uint256;
370 
371     /**
372     *  @MintableToken token - Token Object
373     *  @address wallet - Wallet Address
374     *  @uint8 rate - Tokens per Ether
375     *  @uint256 weiRaised - Total funds raised in Ethers
376     */
377 
378     MintableToken internal token;
379     address internal wallet;
380     uint256 public rate;
381     uint256 internal weiRaised;
382 
383     /**
384     *  @uint256 privateSaleStartTime - Private-Sale Start Time
385     *  @uint256 privateSaleEndTime - Private-Sale End Time
386     *  @uint256 preSaleStartTime - Pre-Sale Start Time
387     *  @uint256 preSaleEndTime - Pre-Sale End Time
388     *  @uint256 preICOStartTime - Pre-ICO Start Time
389     *  @uint256 preICOEndTime - Pre-ICO End Time
390     *  @uint256 ICOstartTime - ICO Start Time
391     *  @uint256 ICOEndTime - ICO End Time
392     */
393     
394     uint256 public privateSaleStartTime;
395     uint256 public privateSaleEndTime;
396     uint256 public preSaleStartTime;
397     uint256 public preSaleEndTime;
398     uint256 public preICOStartTime;
399     uint256 public preICOEndTime;
400     uint256 public ICOstartTime;
401     uint256 public ICOEndTime;
402     
403     /**
404     *  @uint privateBonus - Private Bonus
405     *  @uint preSaleBonus - Pre-Sale Bonus
406     *  @uint preICOBonus - Pre-Sale Bonus
407     *  @uint firstWeekBonus - ICO 1st Week Bonus
408     *  @uint secondWeekBonus - ICO 2nd Week Bonus
409     *  @uint thirdWeekBonus - ICO 3rd Week Bonus
410     *  @uint forthWeekBonus - ICO 4th Week Bonus
411     *  @uint fifthWeekBonus - ICO 5th Week Bonus
412     */
413 
414     uint256 internal privateSaleBonus;
415     uint256 internal preSaleBonus;
416     uint256 internal preICOBonus;
417     uint256 internal firstWeekBonus;
418     uint256 internal secondWeekBonus;
419     uint256 internal thirdWeekBonus;
420     uint256 internal forthWeekBonus;
421     uint256 internal fifthWeekBonus;
422 
423     uint256 internal weekOne;
424     uint256 internal weekTwo;
425     uint256 internal weekThree;
426     uint256 internal weekFour;
427     uint256 internal weekFive;
428 
429 
430     uint256 internal privateSaleTarget;
431     uint256 internal preSaleTarget;
432     uint256 internal preICOTarget;
433 
434     /**
435     *  @uint256 totalSupply - Total supply of tokens 
436     *  @uint256 publicSupply - Total public Supply 
437     *  @uint256 bountySupply - Total Bounty Supply
438     *  @uint256 reservedSupply - Total Reserved Supply 
439     *  @uint256 privateSaleSupply - Total Private Supply from Public Supply  
440     *  @uint256 preSaleSupply - Total PreSale Supply from Public Supply 
441     *  @uint256 preICOSupply - Total PreICO Supply from Public Supply
442     *  @uint256 icoSupply - Total ICO Supply from Public Supply
443     */
444 
445     uint256 public totalSupply = SafeMath.mul(400000000, 1 ether);
446     uint256 internal publicSupply = SafeMath.mul(SafeMath.div(totalSupply,100),55);
447     uint256 internal bountySupply = SafeMath.mul(SafeMath.div(totalSupply,100),6);
448     uint256 internal reservedSupply = SafeMath.mul(SafeMath.div(totalSupply,100),39);
449     uint256 internal privateSaleSupply = SafeMath.mul(24750000, 1 ether);
450     uint256 internal preSaleSupply = SafeMath.mul(39187500, 1 ether);
451     uint256 internal preICOSupply = SafeMath.mul(39187500, 1 ether);
452     uint256 internal icoSupply = SafeMath.mul(116875000, 1 ether);
453 
454 
455     /**
456     *  @bool checkUnsoldTokens - Tokens will be added to bounty supply
457     *  @bool upgradePreSaleSupply - Boolean variable updates when the PrivateSale tokens added to PreSale supply
458     *  @bool upgradePreICOSupply - Boolean variable updates when the PreSale tokens added to PreICO supply
459     *  @bool upgradeICOSupply - Boolean variable updates when the PreICO tokens added to ICO supply
460     *  @bool grantFounderTeamSupply - Boolean variable updates when Team and Founder tokens minted
461     */
462 
463     bool public checkUnsoldTokens;
464     bool internal upgradePreSaleSupply;
465     bool internal upgradePreICOSupply;
466     bool internal upgradeICOSupply;
467 
468 
469 
470     /**
471     * event for token purchase logging
472     * @param purchaser who paid for the tokens
473     * @param beneficiary who got the tokens
474     * @param value Wei's paid for purchase
475     * @param amount amount of tokens purchased
476     */
477 
478     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
479 
480     /**
481     * function Crowdsale - Parameterized Constructor
482     * @param _startTime - StartTime of Crowdsale
483     * @param _endTime - EndTime of Crowdsale
484     * @param _rate - Tokens against Ether
485     * @param _wallet - MultiSignature Wallet Address
486     */
487 
488     constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) internal {
489         
490         require(_wallet != 0x0);
491 
492         token = createTokenContract();
493 
494         privateSaleStartTime = _startTime;
495         privateSaleEndTime = 1537952399;
496         preSaleStartTime = 1537952400;
497         preSaleEndTime = 1541581199;
498         preICOStartTime = 1541581200;
499         preICOEndTime = 1544000399; 
500         ICOstartTime = 1544000400;
501         ICOEndTime = _endTime;
502 
503         rate = _rate;
504         wallet = _wallet;
505 
506         privateSaleBonus = SafeMath.div(SafeMath.mul(rate,50),100);
507         preSaleBonus = SafeMath.div(SafeMath.mul(rate,30),100);
508         preICOBonus = SafeMath.div(SafeMath.mul(rate,30),100);
509         firstWeekBonus = SafeMath.div(SafeMath.mul(rate,20),100);
510         secondWeekBonus = SafeMath.div(SafeMath.mul(rate,15),100);
511         thirdWeekBonus = SafeMath.div(SafeMath.mul(rate,10),100);
512         forthWeekBonus = SafeMath.div(SafeMath.mul(rate,5),100);
513         
514 
515         weekOne = SafeMath.add(ICOstartTime, 14 days);
516         weekTwo = SafeMath.add(weekOne, 14 days);
517         weekThree = SafeMath.add(weekTwo, 14 days);
518         weekFour = SafeMath.add(weekThree, 14 days);
519         weekFive = SafeMath.add(weekFour, 14 days);
520 
521         privateSaleTarget = SafeMath.mul(4500, 1 ether);
522         preSaleTarget = SafeMath.mul(7125, 1 ether);
523         preICOTarget = SafeMath.mul(7125, 1 ether);
524 
525         checkUnsoldTokens = false;
526         upgradeICOSupply = false;
527         upgradePreICOSupply = false;
528         upgradePreSaleSupply = false;
529     
530     }
531 
532     /**
533     * function createTokenContract - Mintable Token Created
534     */
535 
536     function createTokenContract() internal returns (MintableToken) {
537         return new MintableToken();
538     }
539     
540     /**
541     * function Fallback - Receives Ethers
542     */
543 
544     function () payable public {
545         buyTokens(msg.sender);
546     }
547 
548         /**
549     * function preSaleTokens - Calculate Tokens in PreSale
550     */
551 
552     function privateSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
553         require(privateSaleSupply > 0);
554         require(weiAmount <= privateSaleTarget);
555 
556         tokens = SafeMath.add(tokens, weiAmount.mul(privateSaleBonus));
557         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
558 
559         require(privateSaleSupply >= tokens);
560 
561         privateSaleSupply = privateSaleSupply.sub(tokens);        
562         privateSaleTarget = privateSaleTarget.sub(weiAmount);
563 
564         return tokens;
565     }
566 
567 
568     /**
569     * function preSaleTokens - Calculate Tokens in PreSale
570     */
571 
572     function preSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
573         require(preSaleSupply > 0);
574         require(weiAmount <= preSaleTarget);
575 
576         if (!upgradePreSaleSupply) {
577             preSaleSupply = SafeMath.add(preSaleSupply, privateSaleSupply);
578             preSaleTarget = SafeMath.add(preSaleTarget, privateSaleTarget);
579             upgradePreSaleSupply = true;
580         }
581 
582         tokens = SafeMath.add(tokens, weiAmount.mul(preSaleBonus));
583         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
584 
585         require(preSaleSupply >= tokens);
586 
587         preSaleSupply = preSaleSupply.sub(tokens);        
588         preSaleTarget = preSaleTarget.sub(weiAmount);
589         return tokens;
590     }
591 
592     /**
593         * function preICOTokens - Calculate Tokens in PreICO
594         */
595 
596     function preICOTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
597             
598         require(preICOSupply > 0);
599         require(weiAmount <= preICOTarget);
600 
601         if (!upgradePreICOSupply) {
602             preICOSupply = SafeMath.add(preICOSupply, preSaleSupply);
603             preICOTarget = SafeMath.add(preICOTarget, preSaleTarget);
604             upgradePreICOSupply = true;
605         }
606 
607         tokens = SafeMath.add(tokens, weiAmount.mul(preICOBonus));
608         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
609         
610         require(preICOSupply >= tokens);
611         
612         preICOSupply = preICOSupply.sub(tokens);        
613         preICOTarget = preICOTarget.sub(weiAmount);
614         return tokens;
615     }
616 
617     /**
618     * function icoTokens - Calculate Tokens in ICO
619     */
620     
621     function icoTokens(uint256 weiAmount, uint256 tokens, uint256 accessTime) internal returns (uint256) {
622             
623         require(icoSupply > 0);
624 
625         if (!upgradeICOSupply) {
626             icoSupply = SafeMath.add(icoSupply,preICOSupply);
627             upgradeICOSupply = true;
628         }
629         
630         if (accessTime <= weekOne) {
631             tokens = SafeMath.add(tokens, weiAmount.mul(firstWeekBonus));
632         } else if (accessTime <= weekTwo) {
633             tokens = SafeMath.add(tokens, weiAmount.mul(secondWeekBonus));
634         } else if ( accessTime < weekThree ) {
635             tokens = SafeMath.add(tokens, weiAmount.mul(thirdWeekBonus));
636         } else if ( accessTime < weekFour ) {
637             tokens = SafeMath.add(tokens, weiAmount.mul(forthWeekBonus));
638         } else if ( accessTime < weekFive ) {
639             tokens = SafeMath.add(tokens, weiAmount.mul(fifthWeekBonus));
640         }
641         
642         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
643         icoSupply = icoSupply.sub(tokens);        
644 
645         return tokens;
646     }
647 
648     /**
649     * function buyTokens - Collect Ethers and transfer tokens
650     */
651 
652     function buyTokens(address beneficiary) whenNotPaused internal {
653 
654         require(beneficiary != 0x0);
655         require(validPurchase());
656         uint256 accessTime = now;
657         uint256 tokens = 0;
658         uint256 weiAmount = msg.value;
659 
660         require((weiAmount >= (100000000000000000)) && (weiAmount <= (20000000000000000000)));
661 
662         if ((accessTime >= privateSaleStartTime) && (accessTime < privateSaleEndTime)) {
663             tokens = privateSaleTokens(weiAmount, tokens);
664         } else if ((accessTime >= preSaleStartTime) && (accessTime < preSaleEndTime)) {
665             tokens = preSaleTokens(weiAmount, tokens);
666         } else if ((accessTime >= preICOStartTime) && (accessTime < preICOEndTime)) {
667             tokens = preICOTokens(weiAmount, tokens);
668         } else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) { 
669             tokens = icoTokens(weiAmount, tokens, accessTime);
670         } else {
671             revert();
672         }
673         
674         publicSupply = publicSupply.sub(tokens);
675         weiRaised = weiRaised.add(weiAmount);
676         token.mint(beneficiary, tokens);
677         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
678         forwardFunds();
679     }
680 
681     /**
682     * function forwardFunds - Transfer funds to wallet
683     */
684 
685     function forwardFunds() internal {
686         wallet.transfer(msg.value);
687     }
688 
689     /**
690     * function validPurchase - Checks the purchase is valid or not
691     * @return true - Purchase is withPeriod and nonZero
692     */
693 
694     function validPurchase() internal view returns (bool) {
695         bool withinPeriod = now >= privateSaleStartTime && now <= ICOEndTime;
696         bool nonZeroPurchase = msg.value != 0;
697         return withinPeriod && nonZeroPurchase;
698     }
699 
700     /**
701     * function hasEnded - Checks the ICO ends or not
702     * @return true - ICO Ends
703     */
704     
705     function hasEnded() public view returns (bool) {
706         return now > ICOEndTime;
707     }
708 
709     /**
710     * function unsoldToken - Function used to transfer all 
711     *               unsold public tokens to reserve supply
712     */
713 
714     function unsoldToken() onlyOwner public {
715         require(hasEnded());
716         require(!checkUnsoldTokens);
717         
718         checkUnsoldTokens = true;
719         bountySupply = SafeMath.add(bountySupply, publicSupply);
720         publicSupply = 0;
721 
722     }
723 
724     /** 
725     * function getTokenAddress - Get Token Address 
726     */
727 
728     function getTokenAddress() onlyOwner view public returns (address) {
729         return token;
730     }
731 }
732 
733 contract CappedCrowdsale is Crowdsale {
734     using SafeMath for uint256;
735 
736     uint256 public cap;
737 
738     constructor(uint256 _cap) public {
739         require(_cap > 0);
740         cap = _cap;
741     }
742 
743     // overriding Crowdsale#validPurchase to add extra cap logic
744     // @return true if investors can buy at the moment
745     function validPurchase() internal view returns (bool) {
746         return super.validPurchase() && weiRaised.add(msg.value) <= cap;
747     }
748 
749     // overriding Crowdsale#hasEnded to add cap logic
750     // @return true if crowdsale event has ended
751     function hasEnded() public view returns (bool) {
752         return super.hasEnded() || weiRaised >= cap;
753     }
754 }
755 
756 contract CrowdsaleFunctions is Crowdsale {
757 
758  /** 
759   * function bountyFunds - Transfer bounty tokens via AirDrop
760   * @param beneficiary address where owner wants to transfer tokens
761   * @param tokens value of token
762   */
763 
764     function bountyFunds(address[] beneficiary, uint256[] tokens) public onlyOwner {
765 
766         for (uint256 i = 0; i < beneficiary.length; i++) {
767             tokens[i] = SafeMath.mul(tokens[i],1 ether); 
768 
769             require(beneficiary[i] != 0x0);
770             require(bountySupply >= tokens[i]);
771             
772             bountySupply = SafeMath.sub(bountySupply,tokens[i]);
773             token.mint(beneficiary[i], tokens[i]);
774         }
775     }
776 
777 
778   /** 
779    * function grantReservedToken - Transfer advisor,team and founder tokens  
780    */
781 
782     function grantReservedToken(address beneficiary, uint256 tokens) public onlyOwner {
783         require(beneficiary != 0x0);
784         require(reservedSupply > 0);
785 
786         tokens = SafeMath.mul(tokens,1 ether);
787         require(reservedSupply >= tokens);
788         reservedSupply = SafeMath.sub(reservedSupply,tokens);
789         token.mint(beneficiary, tokens);
790     }
791 
792 /** 
793  *.function transferToken - Used to transfer tokens to investors who pays us other than Ethers
794  * @param beneficiary - Address where owner wants to transfer tokens
795  * @param tokens -  Number of tokens
796  */
797     function transferToken(address beneficiary, uint256 tokens) onlyOwner public {
798         
799         require(beneficiary != 0x0);
800         require(publicSupply > 0);
801         tokens = SafeMath.mul(tokens,1 ether);
802         require(publicSupply >= tokens);
803         publicSupply = SafeMath.sub(publicSupply,tokens);
804         token.mint(beneficiary, tokens);
805     }
806 
807     function addBlockListed(address user) public onlyOwner {
808         token.addBlockeddUser(user);
809     }
810     
811     function removeBlockListed(address user) public onlyOwner {
812         token.removeBlockeddUser(user);
813     }
814 }
815 
816 contract FinalizableCrowdsale is Crowdsale {
817     using SafeMath for uint256;
818 
819     bool isFinalized = false;
820 
821     event Finalized();
822 
823     /**
824     * @dev Must be called after crowdsale ends, to do some extra finalization
825     * work. Calls the contract's finalization function.
826     */
827     function finalize() onlyOwner public {
828         require(!isFinalized);
829         require(hasEnded());
830 
831         finalization();
832         emit Finalized();
833 
834         isFinalized = true;
835     }
836 
837     /**
838     * @dev Can be overridden to add finalization logic. The overriding function
839     * should call super.finalization() to ensure the chain of finalization is
840     * executed entirely.
841     */
842     function finalization() internal view {
843     }
844 }
845 
846 contract Migrations {
847     address public owner;
848     uint public last_completed_migration;
849 
850     modifier restricted() {
851         if (msg.sender == owner) _;
852     }
853 
854     constructor() public {
855         owner = msg.sender;
856     }
857 
858     function setCompleted(uint completed) public restricted {
859         last_completed_migration = completed;
860     }
861 
862     function upgrade(address new_address) public restricted {
863         Migrations upgraded = Migrations(new_address);
864         upgraded.setCompleted(last_completed_migration);
865     }
866 }
867 
868 contract RefundableCrowdsale is FinalizableCrowdsale {
869     using SafeMath for uint256;
870 
871     // minimum amount of funds to be raised in weis
872     uint256 public goal;
873     bool private _goalReached = false;
874     // refund vault used to hold funds while crowdsale is running
875     RefundVault private vault;
876 
877     constructor(uint256 _goal) public {
878         require(_goal > 0);
879         vault = new RefundVault(wallet);
880         goal = _goal;
881     }
882 
883     // We're overriding the fund forwarding from Crowdsale.
884     // In addition to sending the funds, we want to call
885     // the RefundVault deposit function
886     function forwardFunds() internal {
887         vault.deposit.value(msg.value)(msg.sender);
888     }
889 
890     // if crowdsale is unsuccessful, investors can claim refunds here
891     function claimRefund() public {
892         require(isFinalized);
893         require(!goalReached());
894 
895         vault.refund(msg.sender);
896     }
897 
898     // vault finalization task, called when owner calls finalize()
899     function finalization() internal view {
900         if (goalReached()) {
901             vault.close();
902         } else {
903             vault.enableRefunds();
904         }
905         super.finalization();
906     }
907 
908     function goalReached() public payable returns (bool) {
909         if (weiRaised >= goal) {
910             _goalReached = true;
911             return true;
912         } else if (_goalReached) {
913             return true;
914         } 
915         else {
916             return false;
917         }
918     }
919 
920     function updateGoalCheck() onlyOwner public {
921         _goalReached = true;
922     }
923 
924     function getVaultAddress() onlyOwner view public returns (address) {
925         return vault;
926     }
927 }
928 
929 contract RefundVault is Ownable {
930     using SafeMath for uint256;
931 
932     enum State { Active, Refunding, Closed }
933 
934     mapping (address => uint256) public deposited;
935     address public wallet;
936     State public state;
937 
938     event Closed();
939     event RefundsEnabled();
940     event Refunded(address indexed beneficiary, uint256 weiAmount);
941 
942     constructor(address _wallet) public {
943         require(_wallet != 0x0);
944         wallet = _wallet;
945         state = State.Active;
946     }
947 
948     function deposit(address investor) onlyOwner public payable {
949         require(state == State.Active);
950         deposited[investor] = deposited[investor].add(msg.value);
951     }
952 
953     function close() onlyOwner public {
954         require(state == State.Active);
955         state = State.Closed;
956         emit Closed();
957         wallet.transfer(this.balance);
958     }
959 
960     function enableRefunds() onlyOwner public {
961         require(state == State.Active);
962         state = State.Refunding;
963         emit RefundsEnabled();
964     }
965 
966     function refund(address investor) public {
967         require(state == State.Refunding);
968         uint256 depositedValue = deposited[investor];
969         deposited[investor] = 0;
970         investor.transfer(depositedValue);
971         emit Refunded(investor, depositedValue);
972     }
973 }