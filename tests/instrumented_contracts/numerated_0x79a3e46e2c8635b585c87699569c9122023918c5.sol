1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9 
10     function totalSupply() public view returns (uint256);
11 
12     function balanceOf(address who) public view returns (uint256);
13 
14     function transfer(address to, uint256 value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25 
26     function allowance(address owner, address spender) public view returns (uint256);
27 
28     function transferFrom(address from, address to, uint256 value) public returns (bool);
29 
30     function approve(address spender, uint256 value) public returns (bool);
31 
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */
40 library SafeMath {
41 
42     /**
43     * @dev Multiplies two numbers, throws on overflow.
44     */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         assert(c / a == b);
51         return c;
52     }
53 
54     /**
55     * @dev Integer division of two numbers, truncating the quotient.
56     */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // assert(b > 0); // Solidity automatically throws when dividing by 0
59         // uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61         return a / b;
62     }
63 
64     /**
65     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66     */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72     /**
73     * @dev Adds two numbers, throws on overflow.
74     */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         assert(c >= a);
78         return c;
79     }
80 }
81 
82 
83 /**
84  * @title Basic token
85  * @dev Basic version of StandardToken, with no allowances.
86  */
87 contract BasicToken is ERC20Basic {
88     using SafeMath for uint256;
89 
90     mapping(address => uint256) balances;
91 
92     uint256 totalSupply_;
93 
94     /**
95     * @dev total number of tokens in existence
96     */
97     function totalSupply() public view returns (uint256) {
98         return totalSupply_;
99     }
100 
101     /**
102     * @dev transfer token for a specified address
103     * @param _to The address to transfer to.
104     * @param _value The amount to be transferred.
105     */
106     function transfer(address _to, uint256 _value) public returns (bool) {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109 
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param _owner The address to query the the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121     function balanceOf(address _owner) public view returns (uint256 balance) {
122         return balances[_owner];
123     }
124 
125 }
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping(address => mapping(address => uint256)) internal allowed;
138 
139     /**
140      * @dev Transfer tokens from one address to another
141      * @param _from address The address which you want to send tokens from
142      * @param _to address The address which you want to transfer to
143      * @param _value uint256 the amount of tokens to be transferred
144      */
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146         require(_to != address(0));
147         require(_value <= balances[_from]);
148         require(_value <= allowed[_from][msg.sender]);
149 
150         balances[_from] = balances[_from].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153         Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159      *
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param _spender The address which will spend the funds.
165      * @param _value The amount of tokens to be spent.
166      */
167     function approve(address _spender, uint256 _value) public returns (bool) {
168         allowed[msg.sender][_spender] = _value;
169         Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /**
174      * @dev Function to check the amount of tokens that an owner allowed to a spender.
175      * @param _owner address The address which owns the funds.
176      * @param _spender address The address which will spend the funds.
177      * @return A uint256 specifying the amount of tokens still available for the spender.
178      */
179     function allowance(address _owner, address _spender) public view returns (uint256) {
180         return allowed[_owner][_spender];
181     }
182 
183     /**
184      * @dev Increase the amount of tokens that an owner allowed to a spender.
185      *
186      * approve should be called when allowed[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * @param _spender The address which will spend the funds.
191      * @param _addedValue The amount of tokens to increase the allowance by.
192      */
193     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199     /**
200      * @dev Decrease the amount of tokens that an owner allowed to a spender.
201      *
202      * approve should be called when allowed[_spender] == 0. To decrement
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * @param _spender The address which will spend the funds.
207      * @param _subtractedValue The amount of tokens to decrease the allowance by.
208      */
209     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210         uint oldValue = allowed[msg.sender][_spender];
211         if (_subtractedValue > oldValue) {
212             allowed[msg.sender][_spender] = 0;
213         } else {
214             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215         }
216         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217         return true;
218     }
219 
220 }
221 
222 
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229 
230     address public owner;
231 
232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234     /**
235      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
236      * account.
237      */
238     function Ownable() public {
239         owner = msg.sender;
240     }
241 
242     /**
243      * @dev Throws if called by any account other than the owner.
244      */
245     modifier onlyOwner() {
246         require(msg.sender == owner);
247         _;
248     }
249 
250     /**
251      * @dev Allows the current owner to transfer control of the contract to a newOwner.
252      * @param newOwner The address to transfer ownership to.
253      */
254     function transferOwnership(address newOwner) public onlyOwner {
255         require(newOwner != address(0));
256         OwnershipTransferred(owner, newOwner);
257         owner = newOwner;
258     }
259 
260 }
261 
262 
263 /**
264  * @title Mintable token
265  * @dev Simple ERC20 Token example, with mintable token creation
266  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
267  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
268  */
269 contract MintableToken is StandardToken, Ownable {
270 
271     event Mint(address indexed to, uint256 amount);
272     event MintFinished();
273 
274     bool public mintingFinished = false;
275 
276     modifier canMint() {
277         require(!mintingFinished);
278         _;
279     }
280 
281     /**
282      * @dev Function to mint tokens
283      * @param _to The address that will receive the minted tokens.
284      * @param _amount The amount of tokens to mint.
285      * @return A boolean that indicates if the operation was successful.
286      */
287     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
288         totalSupply_ = totalSupply_.add(_amount);
289         balances[_to] = balances[_to].add(_amount);
290         Mint(_to, _amount);
291         Transfer(address(0), _to, _amount);
292         return true;
293     }
294 
295     /**
296      * @dev Function to stop minting new tokens.
297      * @return True if the operation was successful.
298      */
299     function finishMinting() onlyOwner canMint public returns (bool) {
300         mintingFinished = true;
301         MintFinished();
302         return true;
303     }
304 
305 }
306 
307 
308 /**
309  * @title Burnable Token
310  * @dev Token that can be irreversibly burned (destroyed).
311  */
312 contract BurnableToken is BasicToken {
313 
314     event Burn(address indexed burner, uint256 value);
315 
316     function _burn(address _burner, uint256 _value) internal {
317         require(_value <= balances[_burner]);
318         // no need to require value <= totalSupply, since that would imply the
319         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
320 
321         balances[_burner] = balances[_burner].sub(_value);
322         totalSupply_ = totalSupply_.sub(_value);
323         Burn(_burner, _value);
324         Transfer(_burner, address(0), _value);
325     }
326 
327 }
328 
329 
330 contract DividendPayoutToken is BurnableToken, MintableToken {
331 
332     // Dividends already claimed by investor
333     mapping(address => uint256) public dividendPayments;
334     // Total dividends claimed by all investors
335     uint256 public totalDividendPayments;
336 
337     // invoke this function after each dividend payout
338     function increaseDividendPayments(address _investor, uint256 _amount) onlyOwner public {
339         dividendPayments[_investor] = dividendPayments[_investor].add(_amount);
340         totalDividendPayments = totalDividendPayments.add(_amount);
341     }
342 
343     //When transfer tokens decrease dividendPayments for sender and increase for receiver
344     function transfer(address _to, uint256 _value) public returns (bool) {
345 
346         // balance before transfer
347         uint256 oldBalanceFrom = balances[msg.sender];
348 
349         // invoke super function with requires
350         bool isTransferred = super.transfer(_to, _value);
351 
352         uint256 transferredClaims = dividendPayments[msg.sender].mul(_value).div(oldBalanceFrom);
353         dividendPayments[msg.sender] = dividendPayments[msg.sender].sub(transferredClaims);
354         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
355 
356         return isTransferred;
357     }
358 
359     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
360 
361         // balance before transfer
362         uint256 oldBalanceFrom = balances[_from];
363 
364         // invoke super function with requires
365         bool isTransferred = super.transferFrom(_from, _to, _value);
366 
367         uint256 transferredClaims = dividendPayments[_from].mul(_value).div(oldBalanceFrom);
368         dividendPayments[_from] = dividendPayments[_from].sub(transferredClaims);
369         dividendPayments[_to] = dividendPayments[_to].add(transferredClaims);
370 
371         return isTransferred;
372     }
373 
374     function burn() public {
375 
376         address burner = msg.sender;
377 
378         // balance before burning tokens
379         uint256 oldBalance = balances[burner];
380 
381         super._burn(burner, oldBalance);
382 
383         uint256 burnedClaims = dividendPayments[burner];
384         dividendPayments[burner] = dividendPayments[burner].sub(burnedClaims);
385         totalDividendPayments = totalDividendPayments.sub(burnedClaims);
386 
387         SaleInterface(owner).refund(burner);
388     }
389 
390 }
391 
392 contract RicoToken is DividendPayoutToken {
393 
394     string public constant name = "CFE";
395 
396     string public constant symbol = "CFE";
397 
398     uint8 public constant decimals = 18;
399 
400 }
401 
402 
403 // Interface for PreSale and CrowdSale contracts with refund function
404 contract SaleInterface {
405 
406     function refund(address _to) public;
407 
408 }
409 
410 
411 contract ReentrancyGuard {
412 
413     /**
414      * @dev We use a single lock for the whole contract.
415      */
416     bool private reentrancy_lock = false;
417 
418     /**
419      * @dev Prevents a contract from calling itself, directly or indirectly.
420      * @notice If you mark a function `nonReentrant`, you should also
421      * mark it `external`. Calling one nonReentrant function from
422      * another is not supported. Instead, you can implement a
423      * `private` function doing the actual work, and a `external`
424      * wrapper marked as `nonReentrant`.
425      */
426     modifier nonReentrant() {
427 
428         require(!reentrancy_lock);
429         reentrancy_lock = true;
430         _;
431         reentrancy_lock = false;
432     }
433 
434 }
435 
436 contract PreSale is Ownable, ReentrancyGuard {
437 
438     using SafeMath for uint256;
439 
440     // The token being sold
441     RicoToken public token;
442     address tokenContractAddress;
443 
444     // start and end timestamps where investments are allowed (both inclusive)
445     uint256 public startTime;
446     uint256 public endTime;
447 
448     // Address where funds are transferred after success end of PreSale
449     address public wallet;
450 
451     // How many token units a buyer gets per wei
452     uint256 public rate;
453 
454     uint256 public minimumInvest; // in wei
455 
456     uint256 public softCap; // in wei
457     uint256 public hardCap; // in wei
458 
459     // investors => amount of money
460     mapping(address => uint) public balances;
461 
462     // Amount of wei raised
463     uint256 public weiRaised;
464 
465     // PreSale bonus in percent
466     uint256 bonusPercent;
467 
468     /**
469      * event for token purchase logging
470      * @param purchaser who paid for the tokens
471      * @param beneficiary who got the tokens
472      * @param value weis paid for purchase
473      * @param amount amount of tokens purchased
474      */
475     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
476 
477     function PreSale(
478         uint256 _startTime,
479         uint256 _period,
480         address _wallet,
481         address _token,
482         uint256 _minimumInvest) public
483     {
484         require(_period != 0);
485         require(_token != address(0));
486 
487         startTime = _startTime;
488         endTime = startTime + _period * 1 days;
489 
490         wallet = _wallet;
491         token = RicoToken(_token);
492         tokenContractAddress = _token;
493 
494         // minimumInvest in wei
495         minimumInvest = _minimumInvest;
496 
497         // 1 token for approximately 0,000666666666667 eth
498         rate = 1000;
499 
500         softCap = 150 * 1 ether;
501         hardCap = 1500 * 1 ether;
502         bonusPercent = 50;
503     }
504 
505     // @return true if the transaction can buy tokens
506     modifier saleIsOn() {
507         bool withinPeriod = now >= startTime && now <= endTime;
508         require(withinPeriod);
509         _;
510     }
511 
512     modifier isUnderHardCap() {
513         require(weiRaised < hardCap);
514         _;
515     }
516 
517     modifier refundAllowed() {
518         require(weiRaised < softCap && now > endTime);
519         _;
520     }
521 
522     // @return true if PreSale event has ended
523     function hasEnded() public view returns (bool) {
524         return now > endTime;
525     }
526 
527     // Refund ether to the investors (invoke from only token)
528     function refund(address _to) public refundAllowed {
529         require(msg.sender == tokenContractAddress);
530 
531         uint256 valueToReturn = balances[_to];
532 
533         // update states
534         balances[_to] = 0;
535         weiRaised = weiRaised.sub(valueToReturn);
536 
537         _to.transfer(valueToReturn);
538     }
539 
540     // Get amount of tokens
541     // @param value weis paid for tokens
542     function getTokenAmount(uint256 _value) internal view returns (uint256) {
543         return _value.mul(rate);
544     }
545 
546     // Send weis to the wallet
547     function forwardFunds(uint256 _value) internal {
548         wallet.transfer(_value);
549     }
550 
551     // Success finish of PreSale
552     function finishPreSale() public onlyOwner {
553         require(weiRaised >= softCap);
554         require(weiRaised >= hardCap || now > endTime);
555 
556         if (now < endTime) {
557             endTime = now;
558         }
559 
560         forwardFunds(this.balance);
561         token.transferOwnership(owner);
562     }
563 
564     // Change owner of token after end of PreSale if Soft Cap has not raised
565     function changeTokenOwner() public onlyOwner {
566         require(now > endTime && weiRaised < softCap);
567         token.transferOwnership(owner);
568     }
569 
570     // low level token purchase function
571     function buyTokens(address _beneficiary) saleIsOn isUnderHardCap nonReentrant public payable {
572         require(_beneficiary != address(0));
573         require(msg.value >= minimumInvest);
574 
575         uint256 weiAmount = msg.value;
576         uint256 tokens = getTokenAmount(weiAmount);
577         tokens = tokens.add(tokens.mul(bonusPercent).div(100));
578 
579         token.mint(_beneficiary, tokens);
580 
581         // update states
582         weiRaised = weiRaised.add(weiAmount);
583         balances[_beneficiary] = balances[_beneficiary].add(weiAmount);
584 
585         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
586     }
587 
588     function() external payable {
589         buyTokens(msg.sender);
590     }
591 }
592 
593 
594 
595 contract rICO is Ownable, ReentrancyGuard {
596     using SafeMath for uint256;
597 
598     // The token being sold
599     RicoToken public token;
600     address tokenContractAddress;
601 
602     // PreSale
603     PreSale public preSale;
604 
605     // Timestamps of periods
606     uint256 public startTime;
607     uint256 public endCrowdSaleTime;
608     uint256 public endRefundableTime;
609 
610 
611     // Address where funds are transferred
612     address public wallet;
613 
614     // How many token units a buyer gets per wei
615     uint256 public rate;
616 
617     uint256 public minimumInvest; // in wei
618 
619     uint256 public softCap; // in wei
620     uint256 public hardCap; // in wei
621 
622     // investors => amount of money
623     mapping(address => uint) public balances;
624     mapping(address => uint) public balancesInToken;
625 
626     // Amount of wei raised
627     uint256 public weiRaised;
628 
629     // Rest amount of wei after refunding by investors and withdraws by owner
630     uint256 public restWei;
631 
632     // Amount of wei which reserved for withdraw by owner
633     uint256 public reservedWei;
634 
635     // stages of Refundable part
636     bool public firstStageRefund = false;  // allow 500 eth to withdraw
637     bool public secondStageRefund = false;  // allow 30 percent of rest wei to withdraw
638     bool public finalStageRefund = false;  // allow all rest wei to withdraw
639 
640     /**
641      * event for token purchase logging
642      * @param purchaser who paid for the tokens
643      * @param beneficiary who got the tokens
644      * @param value weis paid for purchase
645      * @param amount amount of tokens purchased
646      */
647     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
648 
649     function rICO(
650         address _wallet,
651         address _token,
652         address _preSale) public
653     {
654         require(_token != address(0));
655 
656         startTime = 1525027800;
657         endCrowdSaleTime = startTime + 60 * 1 minutes;
658         endRefundableTime = endCrowdSaleTime + 130 * 1 minutes;
659 
660         wallet = _wallet;
661         token = RicoToken(_token);
662         tokenContractAddress = _token;
663         preSale = PreSale(_preSale);
664 
665         // minimumInvest in wei
666         minimumInvest = 1000000000000;
667 
668         // 1 token rate
669         rate = 1000;
670 
671         softCap = 1500 * 0.000001 ether;
672         hardCap = 15000 * 0.000001 ether;
673     }
674 
675     // @return true if the transaction can buy tokens
676     modifier saleIsOn() {
677         bool withinPeriod = now >= startTime && now <= endCrowdSaleTime;
678         require(withinPeriod);
679         _;
680     }
681 
682     modifier isUnderHardCap() {
683         require(weiRaised.add(preSale.weiRaised()) < hardCap);
684         _;
685     }
686 
687     // @return true if CrowdSale event has ended
688     function hasEnded() public view returns (bool) {
689         return now > endRefundableTime;
690     }
691 
692     // Get bonus percent
693     function getBonusPercent() internal view returns(uint256) {
694         uint256 collectedWei = weiRaised.add(preSale.weiRaised());
695 
696         if (collectedWei < 1500 * 0.000001 ether) {
697             return 20;
698         }
699         if (collectedWei < 5000 * 0.000001 ether) {
700             return 10;
701         }
702         if (collectedWei < 10000 * 0.000001 ether) {
703             return 5;
704         }
705 
706         return 0;
707     }
708 
709     // Get real value to return to investor
710     function getRealValueToReturn(uint256 _value) internal view returns(uint256) {
711         return _value.mul(restWei).div(weiRaised);
712     }
713 
714     // Update of reservedWei for withdraw
715     function updateReservedWei() public {
716         
717         require(weiRaised.add(preSale.weiRaised()) >= softCap && now > endCrowdSaleTime);
718 
719         uint256 curWei;
720 
721         if (!firstStageRefund && now > endCrowdSaleTime) {
722             curWei = 500 * 0.000001 ether;
723 
724             reservedWei = curWei;
725             restWei = weiRaised.sub(curWei);
726 
727             firstStageRefund = true;
728         }
729 
730         if (!secondStageRefund && now > endCrowdSaleTime + 99 * 1 minutes) {
731             curWei = restWei.mul(30).div(100);
732 
733             reservedWei = reservedWei.add(curWei);
734             restWei = restWei.sub(curWei);
735 
736             secondStageRefund = true;
737         }
738 
739         if (!finalStageRefund && now > endRefundableTime) {
740             reservedWei = reservedWei.add(restWei);
741             restWei = 0;
742 
743             finalStageRefund = true;
744         }
745 
746     }
747 
748     // Refund ether to the investors (invoke from only token)
749     function refund(address _to) public {
750         require(msg.sender == tokenContractAddress);
751         require(weiRaised.add(preSale.weiRaised()) < softCap && now > endCrowdSaleTime
752         || weiRaised.add(preSale.weiRaised()) >= softCap && now > endCrowdSaleTime && now <= endRefundableTime);
753 
754 
755         // unsuccessful end of CrowdSale
756         if (weiRaised.add(preSale.weiRaised()) < softCap && now > endCrowdSaleTime) {
757             refundAll(_to);
758             return;
759         }
760 
761         // successful end of CrowdSale
762         if (weiRaised.add(preSale.weiRaised()) >= softCap && now > endCrowdSaleTime && now <= endRefundableTime) {
763             refundPart(_to);
764             return;
765         }
766 
767     }
768 
769     // Refund ether to the investors in case of unsuccessful end of CrowdSale
770     function refundAll(address _to) internal {
771         uint256 valueToReturn = balances[_to];
772 
773         // update states
774         balances[_to] = 0;
775         balancesInToken[_to] = 0;
776         weiRaised = weiRaised.sub(valueToReturn);
777 
778         _to.transfer(valueToReturn);
779     }
780 
781     // Refund part of ether to the investors in case of successful end of CrowdSale
782     function refundPart(address _to) internal {
783         uint256 valueToReturn = balances[_to];
784 
785         // get real value to return
786         updateReservedWei();
787         valueToReturn = getRealValueToReturn(valueToReturn);
788 
789         // update states
790         balances[_to] = 0;
791         balancesInToken[_to] = 0;
792         restWei = restWei.sub(valueToReturn);
793 
794         _to.transfer(valueToReturn);
795     }
796 
797     // Get amount of tokens
798     // @param value weis paid for tokens
799     function getTokenAmount(uint256 _value) internal view returns (uint256) {
800         return _value.mul(rate);
801     }
802 
803     // Send weis to the wallet
804     function forwardFunds(uint256 _value) internal {
805         wallet.transfer(_value);
806     }
807 
808     // Withdrawal eth to owner
809     function withdrawal() public onlyOwner {
810 
811         updateReservedWei();
812 
813         uint256 withdrawalWei = reservedWei;
814         reservedWei = 0;
815         forwardFunds(withdrawalWei);
816     }
817 
818     // Success finish of CrowdSale
819     function finishCrowdSale() public onlyOwner {
820         require(now > endRefundableTime);
821 
822         // withdrawal all eth from contract
823         updateReservedWei();
824         reservedWei = 0;
825         forwardFunds(this.balance);
826 
827         // mint tokens to owner - wallet
828         token.mint(wallet, (token.totalSupply().mul(65).div(100)));
829         token.finishMinting();
830 
831         token.transferOwnership(owner);
832     }
833 
834     // Change owner of token after end of CrowdSale if Soft Cap has not raised
835     function changeTokenOwner() public onlyOwner {
836         require(now > endRefundableTime && weiRaised.add(preSale.weiRaised()) < softCap);
837         token.transferOwnership(owner);
838     }
839 
840     // low level token purchase function
841     function buyTokens(address _beneficiary) saleIsOn isUnderHardCap nonReentrant public payable {
842         require(_beneficiary != address(0));
843         require(msg.value >= minimumInvest);
844 
845         uint256 weiAmount = msg.value;
846         uint256 tokens = getTokenAmount(weiAmount);
847         uint256 bonusPercent = getBonusPercent();
848         tokens = tokens.add(tokens.mul(bonusPercent).div(100));
849 
850         token.mint(_beneficiary, tokens);
851 
852         // update states
853         weiRaised = weiRaised.add(weiAmount);
854         balances[_beneficiary] = balances[_beneficiary].add(weiAmount);
855         balancesInToken[_beneficiary] = balancesInToken[_beneficiary].add(tokens);
856 
857         // update timestamps and begin Refundable stage
858         if (weiRaised >= hardCap) {
859             endCrowdSaleTime = now;
860             endRefundableTime = endCrowdSaleTime + 130 * 1 minutes;
861         }
862 
863         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
864     }
865 
866     function() external payable {
867         buyTokens(msg.sender);
868     }
869 }