1 /**
2  * @author https://github.com/Dmitx
3  */
4 
5 pragma solidity ^0.4.23;
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13     function totalSupply() public view returns (uint256);
14 
15     function balanceOf(address who) public view returns (uint256);
16 
17     function transfer(address to, uint256 value) public returns (bool);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 
23 /**
24  * @title ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/20
26  */
27 contract ERC20 is ERC20Basic {
28     function allowance(address owner, address spender) public view returns (uint256);
29 
30     function transferFrom(address from, address to, uint256 value) public returns (bool);
31 
32     function approve(address spender, uint256 value) public returns (bool);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44     /**
45     * @dev Multiplies two numbers, throws on overflow.
46     */
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         assert(c / a == b);
53         return c;
54     }
55 
56     /**
57     * @dev Integer division of two numbers, truncating the quotient.
58     */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // assert(b > 0); // Solidity automatically throws when dividing by 0
61         // uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63         return a / b;
64     }
65 
66     /**
67     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         assert(b <= a);
71         return a - b;
72     }
73 
74     /**
75     * @dev Adds two numbers, throws on overflow.
76     */
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 }
83 
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90     using SafeMath for uint256;
91 
92     mapping(address => uint256) balances;
93 
94     uint256 totalSupply_;
95 
96     /**
97     * @dev total number of tokens in existence
98     */
99     function totalSupply() public view returns (uint256) {
100         return totalSupply_;
101     }
102 
103     /**
104     * @dev transfer token for a specified address
105     * @param _to The address to transfer to.
106     * @param _value The amount to be transferred.
107     */
108     function transfer(address _to, uint256 _value) public returns (bool) {
109         require(_to != address(0));
110         require(_value <= balances[msg.sender]);
111 
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         emit Transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118     /**
119     * @dev Gets the balance of the specified address.
120     * @param _owner The address to query the the balance of.
121     * @return An uint256 representing the amount owned by the passed address.
122     */
123     function balanceOf(address _owner) public view returns (uint256 balance) {
124         return balances[_owner];
125     }
126 
127 }
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139     mapping(address => mapping(address => uint256)) internal allowed;
140 
141 
142     /**
143      * @dev Transfer tokens from one address to another
144      * @param _from address The address which you want to send tokens from
145      * @param _to address The address which you want to transfer to
146      * @param _value uint256 the amount of tokens to be transferred
147      */
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[_from]);
151         require(_value <= allowed[_from][msg.sender]);
152 
153         balances[_from] = balances[_from].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156         emit Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162      *
163      * Beware that changing an allowance with this method brings the risk that someone may use both the old
164      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      * @param _spender The address which will spend the funds.
168      * @param _value The amount of tokens to be spent.
169      */
170     function approve(address _spender, uint256 _value) public returns (bool) {
171         allowed[msg.sender][_spender] = _value;
172         emit Approval(msg.sender, _spender, _value);
173         return true;
174     }
175 
176     /**
177      * @dev Function to check the amount of tokens that an owner allowed to a spender.
178      * @param _owner address The address which owns the funds.
179      * @param _spender address The address which will spend the funds.
180      * @return A uint256 specifying the amount of tokens still available for the spender.
181      */
182     function allowance(address _owner, address _spender) public view returns (uint256) {
183         return allowed[_owner][_spender];
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      *
189      * approve should be called when allowed[_spender] == 0. To increment
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      * @param _spender The address which will spend the funds.
194      * @param _addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      *
205      * approve should be called when allowed[_spender] == 0. To decrement
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * @param _spender The address which will spend the funds.
210      * @param _subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213         uint oldValue = allowed[msg.sender][_spender];
214         if (_subtractedValue > oldValue) {
215             allowed[msg.sender][_spender] = 0;
216         } else {
217             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218         }
219         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222 
223 }
224 
225 
226 /**
227  * @title Ownable
228  * @dev The Ownable contract has an owner address, and provides basic authorization control
229  * functions, this simplifies the implementation of "user permissions".
230  */
231 contract Ownable {
232   address public owner;
233 
234 
235   event OwnershipRenounced(address indexed previousOwner);
236   event OwnershipTransferred(
237     address indexed previousOwner,
238     address indexed newOwner
239   );
240 
241 
242   /**
243    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
244    * account.
245    */
246   constructor() public {
247     owner = msg.sender;
248   }
249 
250   /**
251    * @dev Throws if called by any account other than the owner.
252    */
253   modifier onlyOwner() {
254     require(msg.sender == owner);
255     _;
256   }
257 
258   /**
259    * @dev Allows the current owner to transfer control of the contract to a newOwner.
260    * @param newOwner The address to transfer ownership to.
261    */
262   function transferOwnership(address newOwner) public onlyOwner {
263     require(newOwner != address(0));
264     emit OwnershipTransferred(owner, newOwner);
265     owner = newOwner;
266   }
267 
268   /**
269    * @dev Allows the current owner to relinquish control of the contract.
270    */
271   function renounceOwnership() public onlyOwner {
272     emit OwnershipRenounced(owner);
273     owner = address(0);
274   }
275   
276 }
277 
278 
279 /**
280  * @title Mintable token
281  * @dev Simple ERC20 Token example, with mintable token creation
282  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
283  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
284  */
285 contract MintableToken is StandardToken, Ownable {
286     event Mint(address indexed to, uint256 amount);
287     event MintFinished();
288 
289     bool public mintingFinished = false;
290 
291 
292     modifier canMint() {
293         require(!mintingFinished);
294         _;
295     }
296 
297     /**
298      * @dev Function to mint tokens
299      * @param _to The address that will receive the minted tokens.
300      * @param _amount The amount of tokens to mint.
301      * @return A boolean that indicates if the operation was successful.
302      */
303     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
304         totalSupply_ = totalSupply_.add(_amount);
305         balances[_to] = balances[_to].add(_amount);
306         emit Mint(_to, _amount);
307         emit Transfer(address(0), _to, _amount);
308         return true;
309     }
310 
311     /**
312      * @dev Function to stop minting new tokens.
313      * @return True if the operation was successful.
314      */
315     function finishMinting() onlyOwner canMint public returns (bool) {
316         mintingFinished = true;
317         emit MintFinished();
318         return true;
319     }
320 
321 }
322 
323 
324 /**
325  * @title Capped token
326  * @dev Mintable token with a token cap.
327  */
328 contract CappedToken is MintableToken {
329 
330     uint256 public cap;
331 
332     constructor(uint256 _cap) public {
333         require(_cap > 0);
334         cap = _cap;
335     }
336 
337     /**
338      * @dev Function to mint tokens
339      * @param _to The address that will receive the minted tokens.
340      * @param _amount The amount of tokens to mint.
341      * @return A boolean that indicates if the operation was successful.
342      */
343     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
344         require(totalSupply_.add(_amount) <= cap);
345 
346         return super.mint(_to, _amount);
347     }
348 
349 }
350 
351 
352 contract DividendPayoutToken is CappedToken {
353 
354     // Dividends already claimed by investor
355     mapping(address => uint256) public dividendPayments;
356     // Total dividends claimed by all investors
357     uint256 public totalDividendPayments;
358 
359     // invoke this function after each dividend payout
360     function increaseDividendPayments(address _investor, uint256 _amount) onlyOwner public {
361         dividendPayments[_investor] = dividendPayments[_investor].add(_amount);
362         totalDividendPayments = totalDividendPayments.add(_amount);
363     }
364 
365     //When transfer tokens decrease dividendPayments for sender and increase for receiver
366     function transfer(address _to, uint256 _value) public returns (bool) {
367         // balance before transfer
368         uint256 oldBalanceFrom = balances[msg.sender];
369 
370         // invoke super function with requires
371         bool isTransferred = super.transfer(_to, _value);
372 
373         uint256 transferredClaims = dividendPayments[msg.sender].mul(_value).div(oldBalanceFrom);
374         dividendPayments[msg.sender] = dividendPayments[msg.sender].sub(transferredClaims);
375         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
376 
377         return isTransferred;
378     }
379 
380     //When transfer tokens decrease dividendPayments for token owner and increase for receiver
381     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
382         // balance before transfer
383         uint256 oldBalanceFrom = balances[_from];
384 
385         // invoke super function with requires
386         bool isTransferred = super.transferFrom(_from, _to, _value);
387 
388         uint256 transferredClaims = dividendPayments[_from].mul(_value).div(oldBalanceFrom);
389         dividendPayments[_from] = dividendPayments[_from].sub(transferredClaims);
390         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
391 
392         return isTransferred;
393     }
394 
395 }
396 
397 contract IcsToken is DividendPayoutToken {
398 
399     string public constant name = "Interexchange Crypstock System";
400 
401     string public constant symbol = "ICS";
402 
403     uint8 public constant decimals = 18;
404 
405     // set Total Supply in 500 000 000 tokens
406     constructor() public
407     CappedToken(5e8 * 1e18) {}
408 
409 }
410 
411 contract HicsToken is DividendPayoutToken {
412 
413     string public constant name = "Interexchange Crypstock System Heritage Token";
414 
415     string public constant symbol = "HICS";
416 
417     uint8 public constant decimals = 18;
418 
419     // set Total Supply in 50 000 000 tokens
420     constructor() public
421     CappedToken(5e7 * 1e18) {}
422 
423 }
424 
425 
426 /**
427  * @title Helps contracts guard against reentrancy attacks.
428  */
429 contract ReentrancyGuard {
430 
431     /**
432      * @dev We use a single lock for the whole contract.
433      */
434     bool private reentrancyLock = false;
435 
436     /**
437      * @dev Prevents a contract from calling itself, directly or indirectly.
438      * @notice If you mark a function `nonReentrant`, you should also
439      * mark it `external`. Calling one nonReentrant function from
440      * another is not supported. Instead, you can implement a
441      * `private` function doing the actual work, and a `external`
442      * wrapper marked as `nonReentrant`.
443      */
444     modifier nonReentrant() {
445         require(!reentrancyLock);
446         reentrancyLock = true;
447         _;
448         reentrancyLock = false;
449     }
450 
451 }
452 
453 contract PreSale is Ownable, ReentrancyGuard {
454     using SafeMath for uint256;
455 
456     // T4T Token
457     ERC20 public t4tToken;
458 
459     // Tokens being sold
460     IcsToken public icsToken;
461     HicsToken public hicsToken;
462 
463     // Timestamps of period
464     uint64 public startTime;
465     uint64 public endTime;
466     uint64 public endPeriodA;
467     uint64 public endPeriodB;
468     uint64 public endPeriodC;
469 
470     // Address where funds are transferred
471     address public wallet;
472 
473     // How many token units a buyer gets per 1 wei
474     uint256 public rate;
475 
476     // How many token units a buyer gets per 1 token T4T
477     uint256 public rateT4T;
478 
479     uint256 public minimumInvest; // in tokens
480 
481     uint256 public hicsTokenPrice;  // in tokens
482 
483     // Max HICS Token distribution in PreSale
484     uint256 public capHicsToken;  // in tokens
485 
486     uint256 public softCap; // in tokens
487 
488     // investors => amount of money
489     mapping(address => uint) public balances;  // in tokens
490 
491     // wei which has stored on PreSale contract
492     mapping(address => uint) balancesForRefund;  // in wei (not public: only for refund)
493 
494     // T4T which has stored on PreSale contract
495     mapping(address => uint) balancesForRefundT4T;  // in T4T tokens (not public: only for refund)
496 
497     // Amount of wei raised in PreSale Contract
498     uint256 public weiRaised;
499 
500     // Number of T4T raised in PreSale Contract
501     uint256 public t4tRaised;
502 
503     // Total number of token emitted
504     uint256 public totalTokensEmitted;  // in tokens
505 
506     // Total money raised (number of tokens without bonuses)
507     uint256 public totalRaised;  // in tokens
508 
509     /**
510      * events for tokens purchase logging
511      * @param purchaser who paid for the tokens
512      * @param beneficiary who got the tokens
513      * @param tokens purchased
514      */
515     event IcsTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 tokens);
516     event HicsTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 tokens);
517 
518     /**
519     * @dev Constructor of PreSale
520     *
521     * @notice Duration of bonus periods, start and end timestamps, minimum invest,
522     * minimum invest to get HICS Token, token price, Soft Cap and HICS Hard Cap are set
523     * in body of PreSale constructor.
524     *
525     * @param _wallet for withdrawal ether
526     * @param _icsToken ICS Token address
527     * @param _hicsToken HICS Token address
528     * @param _erc20Token T4T Token address
529     */
530     constructor(
531         address _wallet,
532         address _icsToken,
533         address _hicsToken,
534         address _erc20Token) public
535     {
536         require(_wallet != address(0));
537         require(_icsToken != address(0));
538         require(_hicsToken != address(0));
539         require(_erc20Token != address(0));
540 
541         // periods of PreSale's bonus and PreSale's time
542         startTime = 1528675200;  // 1528675200 - 11.06.2018 00:00 UTC
543         endPeriodA = 1529107200; // 1529107200 - 16.06.2018 00:00 UTC
544         endPeriodB = 1529798400; // 1529798400 - 24.06.2018 00:00 UTC
545         endPeriodC = 1530489600; // 1530489600 - 02.07.2018 00:00 UTC
546         endTime = 1531353600;    // 1531353600 - 12.07.2018 00:00 UTC
547 
548         // check valid of periods
549         bool validPeriod = now < startTime && startTime < endPeriodA 
550                         && endPeriodA < endPeriodB && endPeriodB < endPeriodC 
551                         && endPeriodC < endTime;
552         require(validPeriod);
553 
554         wallet = _wallet;
555         icsToken = IcsToken(_icsToken);
556         hicsToken = HicsToken(_hicsToken);
557 
558         // set T4T token address
559         t4tToken = ERC20(_erc20Token);
560 
561         // 4 tokens = 1 T4T token (1$)
562         rateT4T = 4;
563 
564         // minimum invest in tokens
565         minimumInvest = 4 * 1e18;  // 4 tokens = 1$
566 
567         // minimum invest to get HicsToken
568         hicsTokenPrice = 2e4 * 1e18;  // 20 000 tokens = 5 000$
569 
570         // initial rate - 1 token for 25 US Cent
571         // initial price - 1 ETH = 680 USD
572         rate = 2720;  // number of tokens for 1 wei
573 
574         // in tokens
575         softCap = 4e6 * 1e18;  // equals 1 000 000$
576 
577         capHicsToken = 15e6 * 1e18;  // 15 000 000 tokens
578     }
579 
580     // @return true if the transaction can buy tokens
581     modifier saleIsOn() {
582         bool withinPeriod = now >= startTime && now <= endTime;
583         require(withinPeriod);
584         _;
585     }
586 
587     // allowed refund in case of unsuccess PreSale
588     modifier refundAllowed() {
589         require(totalRaised < softCap && now > endTime);
590         _;
591     }
592 
593     // @return true if CrowdSale event has ended
594     function hasEnded() public view returns (bool) {
595         return now > endTime;
596     }
597 
598     // Refund ether to the investors in case of under Soft Cap end
599     function refund() public refundAllowed nonReentrant {
600         uint256 valueToReturn = balancesForRefund[msg.sender];
601 
602         // update states
603         balancesForRefund[msg.sender] = 0;
604         weiRaised = weiRaised.sub(valueToReturn);
605 
606         msg.sender.transfer(valueToReturn);
607     }
608 
609     // Refund T4T tokens to the investors in case of under Soft Cap end
610     function refundT4T() public refundAllowed nonReentrant {
611         uint256 valueToReturn = balancesForRefundT4T[msg.sender];
612 
613         // update states
614         balancesForRefundT4T[msg.sender] = 0;
615         t4tRaised = t4tRaised.sub(valueToReturn);
616 
617         t4tToken.transfer(msg.sender, valueToReturn);
618     }
619 
620     // Get bonus percent
621     function _getBonusPercent() internal view returns(uint256) {
622 
623         if (now < endPeriodA) {
624             return 40;
625         }
626         if (now < endPeriodB) {
627             return 25;
628         }
629         if (now < endPeriodC) {
630             return 20;
631         }
632 
633         return 15;
634     }
635 
636     // Get number of tokens with bonus
637     // @param _value in tokens without bonus
638     function _getTokenNumberWithBonus(uint256 _value) internal view returns (uint256) {
639         return _value.add(_value.mul(_getBonusPercent()).div(100));
640     }
641 
642     // Send weis to the wallet
643     // @param _value in wei
644     function _forwardFunds(uint256 _value) internal {
645         wallet.transfer(_value);
646     }
647 
648     // Send T4T tokens to the wallet
649     // @param _value in T4T tokens
650     function _forwardT4T(uint256 _value) internal {
651         t4tToken.transfer(wallet, _value);
652     }
653 
654     // Withdrawal eth from contract
655     function withdrawalEth() public onlyOwner {
656         require(totalRaised >= softCap);
657 
658         // withdrawal all eth from contract
659         _forwardFunds(address(this).balance);
660     }
661 
662     // Withdrawal T4T tokens from contract
663     function withdrawalT4T() public onlyOwner {
664         require(totalRaised >= softCap);
665 
666         // withdrawal all T4T tokens from contract
667         _forwardT4T(t4tToken.balanceOf(address(this)));
668     }
669 
670     // Success finish of PreSale
671     function finishPreSale() public onlyOwner {
672         require(totalRaised >= softCap);
673         require(now > endTime);
674 
675         // withdrawal all eth from contract
676         _forwardFunds(address(this).balance);
677 
678         // withdrawal all T4T tokens from contract
679         _forwardT4T(t4tToken.balanceOf(address(this)));
680 
681         // transfer ownership of tokens to owner
682         icsToken.transferOwnership(owner);
683         hicsToken.transferOwnership(owner);
684     }
685 
686     // Change owner of tokens after end of PreSale
687     function changeTokensOwner() public onlyOwner {
688         require(now > endTime);
689 
690         // transfer ownership of tokens to owner
691         icsToken.transferOwnership(owner);
692         hicsToken.transferOwnership(owner);
693     }
694 
695     // Change rate
696     // @param _rate for change
697     function _changeRate(uint256 _rate) internal {
698         require(_rate != 0);
699         rate = _rate;
700     }
701 
702     // buy ICS tokens
703     function _buyIcsTokens(address _beneficiary, uint256 _value) internal {
704         uint256 tokensWithBonus = _getTokenNumberWithBonus(_value);
705 
706         icsToken.mint(_beneficiary, tokensWithBonus);
707 
708         emit IcsTokenPurchase(msg.sender, _beneficiary, tokensWithBonus);
709     }
710 
711     // buy HICS tokens
712     function _buyHicsTokens(address _beneficiary, uint256 _value) internal {
713         uint256 tokensWithBonus = _getTokenNumberWithBonus(_value);
714 
715         hicsToken.mint(_beneficiary, tokensWithBonus);
716 
717         emit HicsTokenPurchase(msg.sender, _beneficiary, tokensWithBonus);
718     }
719 
720     // buy tokens - helper function
721     // @param _beneficiary address of beneficiary
722     // @param _value of tokens (1 token = 10^18)
723     function _buyTokens(address _beneficiary, uint256 _value) internal {
724         // calculate HICS token amount
725         uint256 valueHics = _value.div(5);  // 20% HICS and 80% ICS Tokens
726 
727         if (_value >= hicsTokenPrice
728         && hicsToken.totalSupply().add(_getTokenNumberWithBonus(valueHics)) < capHicsToken) {
729             // 20% HICS and 80% ICS Tokens
730             _buyIcsTokens(_beneficiary, _value - valueHics);
731             _buyHicsTokens(_beneficiary, valueHics);
732         } else {
733             // 100% of ICS Tokens
734             _buyIcsTokens(_beneficiary, _value);
735         }
736 
737         // update states
738         uint256 tokensWithBonus = _getTokenNumberWithBonus(_value);
739         totalTokensEmitted = totalTokensEmitted.add(tokensWithBonus);
740         balances[_beneficiary] = balances[_beneficiary].add(tokensWithBonus);
741 
742         totalRaised = totalRaised.add(_value);
743     }
744 
745     // buy tokens for T4T tokens
746     // @param _beneficiary address of beneficiary
747     function buyTokensT4T(address _beneficiary) public saleIsOn {
748         require(_beneficiary != address(0));
749 
750         uint256 valueT4T = t4tToken.allowance(_beneficiary, address(this));
751 
752         // check minimumInvest
753         uint256 value = valueT4T.mul(rateT4T);
754         require(value >= minimumInvest);
755 
756         // transfer T4T from _beneficiary to this contract
757         require(t4tToken.transferFrom(_beneficiary, address(this), valueT4T));
758 
759         _buyTokens(_beneficiary, value);
760 
761         // only for buy using T4T tokens
762         t4tRaised = t4tRaised.add(valueT4T);
763         balancesForRefundT4T[_beneficiary] = balancesForRefundT4T[_beneficiary].add(valueT4T);
764     }
765 
766     // manual transfer tokens by owner (e.g.: selling for fiat money)
767     // @param _to address of beneficiary
768     // @param _value of tokens (1 token = 10^18)
769     function manualBuy(address _to, uint256 _value) public saleIsOn onlyOwner {
770         require(_to != address(0));
771         require(_value >= minimumInvest);
772 
773         _buyTokens(_to, _value);
774     }
775 
776     // buy tokens with update rate state by owner
777     // @param _beneficiary address of beneficiary
778     // @param _rate new rate - how many token units a buyer gets per 1 wei
779     function buyTokensWithUpdateRate(address _beneficiary, uint256 _rate) public saleIsOn onlyOwner payable {
780         _changeRate(_rate);
781         buyTokens(_beneficiary);
782     }
783 
784     // low level token purchase function
785     // @param _beneficiary address of beneficiary
786     function buyTokens(address _beneficiary) saleIsOn public payable {
787         require(_beneficiary != address(0));
788 
789         uint256 weiAmount = msg.value;
790         uint256 value = weiAmount.mul(rate);
791         require(value >= minimumInvest);
792 
793         _buyTokens(_beneficiary, value);
794 
795         // only for buy using PreSale contract
796         weiRaised = weiRaised.add(weiAmount);
797         balancesForRefund[_beneficiary] = balancesForRefund[_beneficiary].add(weiAmount);
798     }
799 
800     function() external payable {
801         buyTokens(msg.sender);
802     }
803 }