1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23     function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26     function approve(address spender, uint256 value) public returns (bool);
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40     /**
41     * @dev Multiplies two numbers, throws on overflow.
42     */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         if (a == 0) {
45             return 0;
46         }
47         c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two numbers, truncating the quotient.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         // uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return a / b;
60     }
61 
62     /**
63     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         assert(b <= a);
67         return a - b;
68     }
69 
70     /**
71     * @dev Adds two numbers, throws on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
74         c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 /**
81  * @title Crowdsale
82  * @dev Crowdsale is a base contract for managing a token crowdsale,
83  * allowing investors to purchase tokens with ether. This contract implements
84  * such functionality in its most fundamental form and can be extended to provide additional
85  * functionality and/or custom behavior.
86  * The external interface represents the basic interface for purchasing tokens, and conform
87  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
88  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
89  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
90  * behavior.
91  */
92 contract Crowdsale {
93     using SafeMath for uint256;
94 
95     // The token being sold
96     ERC20 public token;
97 
98     // Address where funds are collected
99     address public wallet;
100 
101     // How many token units a buyer gets per wei
102     uint256 public rate;
103 
104     // Amount of wei raised
105     uint256 public weiRaised;
106 
107     /**
108      * Event for token purchase logging
109      * @param purchaser who paid for the tokens
110      * @param beneficiary who got the tokens
111      * @param value weis paid for purchase
112      * @param amount amount of tokens purchased
113      */
114     event TokenPurchase(
115         address indexed purchaser,
116         address indexed beneficiary,
117         uint256 value,
118         uint256 amount
119     );
120 
121     /**
122      * @param _rate Number of token units a buyer gets per wei
123      * @param _wallet Address where collected funds will be forwarded to
124      * @param _token Address of the token being sold
125      */
126     constructor(uint256 _rate, address _wallet, ERC20 _token) public {
127         require(_rate > 0);
128         require(_wallet != address(0));
129         require(_token != address(0));
130 
131         rate   = _rate;
132         wallet = _wallet;
133         token  = _token;
134         
135         
136     }
137 
138     // -----------------------------------------
139     // Crowdsale external interface
140     // -----------------------------------------
141 
142     /**
143      * @dev fallback function ***DO NOT OVERRIDE***
144      */
145     function () external payable {
146         buyTokens(msg.sender);
147     }
148 
149     /**
150      * @dev low level token purchase ***DO NOT OVERRIDE***
151      * @param _beneficiary Address performing the token purchase
152      */
153     function buyTokens(address _beneficiary) public payable {
154 
155         uint256 weiAmount = msg.value;
156         _preValidatePurchase(_beneficiary, weiAmount);
157 
158         // calculate token amount to be created
159         uint256 tokens = _getTokenAmount(weiAmount);
160 
161         // update state
162         weiRaised = weiRaised.add(weiAmount);
163 
164         _processPurchase(_beneficiary, tokens);
165         emit TokenPurchase(
166             msg.sender,
167             _beneficiary,
168             weiAmount,
169             tokens
170         );
171 
172         _updatePurchasingState(_beneficiary, weiAmount);
173 
174         _forwardFunds();
175         _postValidatePurchase(_beneficiary, weiAmount);
176     }
177 
178     // -----------------------------------------
179     // Internal interface (extensible)
180     // -----------------------------------------
181 
182     /**
183      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
184      * @param _beneficiary Address performing the token purchase
185      * @param _weiAmount Value in wei involved in the purchase
186      */
187     function _preValidatePurchase (
188         address _beneficiary,
189         uint256 _weiAmount
190     )
191     internal
192     {
193         require(_beneficiary != address(0));
194         require(_weiAmount != 0);
195     }
196 
197     /**
198      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
199      * @param _beneficiary Address performing the token purchase
200      * @param _weiAmount Value in wei involved in the purchase
201      */
202     function _postValidatePurchase (
203         address _beneficiary,
204         uint256 _weiAmount
205     )
206     internal
207     {
208         // optional override
209     }
210 
211     /**
212      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
213      * @param _beneficiary Address performing the token purchase
214      * @param _tokenAmount Number of tokens to be emitted
215      */
216     function _deliverTokens (
217         address _beneficiary,
218         uint256 _tokenAmount
219     )
220     internal
221     {
222         token.transfer(_beneficiary, _tokenAmount);
223     }
224 
225     /**
226      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
227      * @param _beneficiary Address receiving the tokens
228      * @param _tokenAmount Number of tokens to be purchased
229      */
230     function _processPurchase (
231         address _beneficiary,
232         uint256 _tokenAmount
233     )
234     internal
235     {
236         _deliverTokens(_beneficiary, _tokenAmount);
237     }
238 
239     /**
240      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
241      * @param _beneficiary Address receiving the tokens
242      * @param _weiAmount Value in wei involved in the purchase
243      */
244     function _updatePurchasingState (
245         address _beneficiary,
246         uint256 _weiAmount
247     )
248     internal
249     {
250         // optional override
251     }
252 
253     /**
254      * @dev Override to extend the way in which ether is converted to tokens.
255      * @param _weiAmount Value in wei to be converted into tokens
256      * @return Number of tokens that can be purchased with the specified _weiAmount
257      */
258     function _getTokenAmount(uint256 _weiAmount)
259     internal view returns (uint256)
260     {
261         return _weiAmount.mul(rate);
262     }
263 
264     /**
265      * @dev Determines how ETH is stored/forwarded on purchases.
266      */
267     function _forwardFunds() internal {
268         wallet.transfer(msg.value);
269     }
270 }
271 
272 /**
273  * @title CappedCrowdsale
274  * @dev Crowdsale with a limit for total contributions.
275  */
276 contract CappedCrowdsale is Crowdsale {
277     using SafeMath for uint256;
278 
279     uint256 public cap;
280 
281     /**
282      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
283      * @param _cap Max amount of wei to be contributed
284      */
285     constructor(uint256 _cap) public {
286         require(_cap > 0);
287         cap = _cap;
288     }
289 
290     /**
291      * @dev Checks whether the cap has been reached.
292      * @return Whether the cap was reached
293      */
294     function capReached() public view returns (bool) {
295         return weiRaised >= cap;
296     }
297 
298     /**
299      * @dev Extend parent behavior requiring purchase to respect the funding cap.
300      * @param _beneficiary Token purchaser
301      * @param _weiAmount Amount of wei contributed
302      */
303     function _preValidatePurchase(
304         address _beneficiary,
305         uint256 _weiAmount
306     )
307     internal
308     {
309         super._preValidatePurchase(_beneficiary, _weiAmount);
310         require(weiRaised.add(_weiAmount) <= cap);
311     }
312 }
313 
314 /**
315  * @title TimedCrowdsale
316  * @dev Crowdsale accepting contributions only within a time frame.
317  */
318 contract TimedCrowdsale is Crowdsale {
319     using SafeMath for uint256;
320 
321     uint256 public openingTime;
322     uint256 public closingTime;
323 
324     /**
325      * @dev Reverts if not in crowdsale time range.
326      */
327     modifier onlyWhileOpen {
328         // solium-disable-next-line security/no-block-members
329         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
330         _;
331     }
332 
333     /**
334      * @dev Constructor, takes crowdsale opening and closing times.
335      * @param _openingTime Crowdsale opening time
336      * @param _closingTime Crowdsale closing time
337      */
338     constructor(uint256 _openingTime, uint256 _closingTime) public {
339         // solium-disable-next-line security/no-block-members
340         require(_openingTime >= block.timestamp);
341         require(_closingTime >= _openingTime);
342 
343         openingTime = _openingTime;
344         closingTime = _closingTime;
345     }
346 
347     /**
348      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
349      * @return Whether crowdsale period has elapsed
350      */
351     function hasClosed() public view returns (bool) {
352         // solium-disable-next-line security/no-block-members
353         return block.timestamp > closingTime;
354     }
355 
356     /**
357      * @dev Extend parent behavior requiring to be within contributing period
358      * @param _beneficiary Token purchaser
359      * @param _weiAmount Amount of wei contributed
360      */
361     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
362         super._preValidatePurchase(_beneficiary, _weiAmount);
363     }
364 }
365 
366 /**
367  * @title Ownable
368  * @dev The Ownable contract has an owner address, and provides basic authorization control
369  * functions, this simplifies the implementation of "user permissions".
370  */
371 contract Ownable {
372     address public owner;
373 
374 
375     event OwnershipRenounced(address indexed previousOwner);
376     event OwnershipTransferred(
377         address indexed previousOwner,
378         address indexed newOwner
379     );
380 
381 
382     /**
383      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
384      * account.
385      */
386     constructor() public {
387         owner = msg.sender;
388     }
389 
390     /**
391      * @dev Throws if called by any account other than the owner.
392      */
393     modifier onlyOwner() {
394         require(msg.sender == owner);
395         _;
396     }
397 
398     /**
399      * @dev Allows the current owner to transfer control of the contract to a newOwner.
400      * @param newOwner The address to transfer ownership to.
401      */
402     function transferOwnership(address newOwner) public onlyOwner {
403         require(newOwner != address(0));
404         emit OwnershipTransferred(owner, newOwner);
405         owner = newOwner;
406     }
407 
408     /**
409      * @dev Allows the current owner to relinquish control of the contract.
410      */
411     function renounceOwnership() public onlyOwner {
412         emit OwnershipRenounced(owner);
413         owner = address(0);
414     }
415 }
416 
417 /**
418  * @title FinalizableCrowdsale
419  * @dev Extension of Crowdsale where an owner can do extra work
420  * after finishing.
421  */
422 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
423     using SafeMath for uint256;
424 
425     bool public isFinalized = false;
426 
427     event Finalized();
428 
429     /**
430      * @dev Must be called after crowdsale ends, to do some extra finalization
431      * work. Calls the contract's finalization function.
432      */
433     function finalize() onlyOwner public {
434         require(!isFinalized);
435         require(hasClosed());
436 
437         finalization();
438         emit Finalized();
439 
440         isFinalized = true;
441     }
442 
443     /**
444      * @dev Can be overridden to add finalization logic. The overriding function
445      * should call super.finalization() to ensure the chain of finalization is
446      * executed entirely.
447      */
448     function finalization() internal {}
449 }
450 
451 /**
452  * @title RefundVault
453  * @dev This contract is used for storing funds while a crowdsale
454  * is in progress. Supports refunding the money if crowdsale fails,
455  * and forwarding it if crowdsale is successful.
456  */
457 contract RefundVault is Ownable {
458     using SafeMath for uint256;
459 
460     enum State { Active, Refunding, Closed }
461 
462     mapping (address => uint256) public deposited;
463     address public wallet;
464     State public state;
465 
466     event Closed();
467     event RefundsEnabled();
468     event Refunded(address indexed beneficiary, uint256 weiAmount);
469 
470     /**
471      * @param _wallet Vault address
472      */
473     constructor(address _wallet) public {
474         require(_wallet != address(0));
475         wallet = _wallet;
476         state = State.Active;
477     }
478 
479     /**
480      * @param investor Investor address
481      */
482     function deposit(address investor) onlyOwner public payable {
483         require(state == State.Active);
484         deposited[investor] = deposited[investor].add(msg.value);
485     }
486 
487     function close() onlyOwner public {
488         require(state == State.Active);
489         state = State.Closed;
490         emit Closed();
491         wallet.transfer(address(this).balance);
492     }
493 
494     function enableRefunds() onlyOwner public {
495         require(state == State.Active);
496         state = State.Refunding;
497         emit RefundsEnabled();
498     }
499 
500     /**
501      * @param investor Investor address
502      */
503     function refund(address investor) public {
504         require(state == State.Refunding);
505         uint256 depositedValue = deposited[investor];
506         deposited[investor] = 0;
507         investor.transfer(depositedValue);
508         emit Refunded(investor, depositedValue);
509     }
510 }
511 
512 /**
513  * @title RefundableCrowdsale
514  * @dev Extension of Crowdsale contract that adds a funding goal, and
515  * the possibility of users getting a refund if goal is not met.
516  * Uses a RefundVault as the crowdsale's vault.
517  */
518 contract RefundableCrowdsale is FinalizableCrowdsale {
519     using SafeMath for uint256;
520 
521     // minimum amount of funds to be raised in weis
522     uint256 public goal;
523 
524     // refund vault used to hold funds while crowdsale is running
525     RefundVault public vault;
526 
527     /**
528      * @dev Constructor, creates RefundVault.
529      * @param _goal Funding goal
530      */
531     constructor(uint256 _goal) public {
532         require(_goal > 0);
533         vault = new RefundVault(wallet);
534         goal  = _goal;
535     }
536 
537     /**
538      * @dev Investors can claim refunds here if crowdsale is unsuccessful
539      */
540     function claimRefund() public {
541         require(isFinalized);
542         require(!goalReached());
543 
544         vault.refund(msg.sender);
545     }
546 
547     /**
548      * @dev Checks whether funding goal was reached.
549      * @return Whether funding goal was reached
550      */
551     function goalReached() public view returns (bool) {
552         return weiRaised >= goal;
553     }
554 
555     /**
556      * @dev vault finalization task, called when owner calls finalize()
557      */
558     function finalization() internal {
559         if (goalReached()) {
560             vault.close();
561         } else {
562             vault.enableRefunds();
563         }
564 
565         super.finalization();
566     }
567 
568     /**
569      * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
570      */
571     function _forwardFunds() internal {
572         vault.deposit.value(msg.value)(msg.sender);
573     }
574 }
575 
576 /**
577  * @title SafeERC20
578  * @dev Wrappers around ERC20 operations that throw on failure.
579  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
580  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
581  */
582 library SafeERC20 {
583     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
584         require(token.transfer(to, value));
585     }
586 
587     function safeTransferFrom(
588         ERC20 token,
589         address from,
590         address to,
591         uint256 value
592     )
593     internal
594     {
595         require(token.transferFrom(from, to, value));
596     }
597 
598     function safeApprove(ERC20 token, address spender, uint256 value) internal {
599         require(token.approve(spender, value));
600     }
601 }
602 
603 /**
604  * @title AllowanceCrowdsale
605  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
606  */
607 contract AllowanceCrowdsale is Crowdsale {
608     using SafeMath for uint256;
609     using SafeERC20 for ERC20;
610 
611     address public tokenWallet;
612 
613     /**
614      * @dev Constructor, takes token wallet address. 
615      * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
616      */
617     constructor(address _tokenWallet) public {
618         require(_tokenWallet != address(0));
619         tokenWallet = _tokenWallet;
620     }
621 
622     /**
623      * @dev Checks the amount of tokens left in the allowance.
624      * @return Amount of tokens left in the allowance
625      */
626     function remainingTokens() public view returns (uint256) {
627         return token.allowance(tokenWallet, this);
628     }
629 
630     /**
631      * @dev Overrides parent behavior by transferring tokens from wallet.
632      * @param _beneficiary Token purchaser
633      * @param _tokenAmount Amount of tokens purchased
634      */
635     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
636         token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
637     }
638 }
639 
640 /**
641  * @title Basic token
642  * @dev Basic version of StandardToken, with no allowances.
643  */
644 contract BasicToken is ERC20Basic {
645     using SafeMath for uint256;
646 
647     mapping(address => uint256) balances;
648 
649     uint256 totalSupply_;
650 
651     /**
652     * @dev total number of tokens in existence
653     */
654     function totalSupply() public view returns (uint256) {
655         return totalSupply_;
656     }
657 
658     /**
659     * @dev transfer token for a specified address
660     * @param _to The address to transfer to.
661     * @param _value The amount to be transferred.
662     */
663     function transfer(address _to, uint256 _value) public returns (bool) {
664         require(_to != address(0));
665         require(_value <= balances[msg.sender]);
666 
667         balances[msg.sender] = balances[msg.sender].sub(_value);
668         balances[_to] = balances[_to].add(_value);
669         emit Transfer(msg.sender, _to, _value);
670         return true;
671     }
672 
673     /**
674     * @dev Gets the balance of the specified address.
675     * @param _owner The address to query the the balance of.
676     * @return An uint256 representing the amount owned by the passed address.
677     */
678     function balanceOf(address _owner) public view returns (uint256) {
679         return balances[_owner];
680     }
681 }
682 
683 /**
684  * @title Burnable Token
685  * @dev Token that can be irreversibly burned (destroyed).
686  */
687 contract BurnableToken is BasicToken {
688 
689     event Burn(address indexed burner, uint256 value);
690 
691     /**
692      * @dev Burns a specific amount of tokens.
693      * @param _value The amount of token to be burned.
694      */
695     function burn(uint256 _value) public {
696         _burn(msg.sender, _value);
697     }
698 
699     function _burn(address _who, uint256 _value) internal {
700         require(_value <= balances[_who]);
701         // no need to require value <= totalSupply, since that would imply the
702         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
703 
704         balances[_who] = balances[_who].sub(_value);
705         totalSupply_ = totalSupply_.sub(_value);
706         emit Burn(_who, _value);
707         emit Transfer(_who, address(0), _value);
708     }
709 }
710 
711 /**
712  * @title Standard ERC20 token
713  *
714  * @dev Implementation of the basic standard token.
715  * @dev https://github.com/ethereum/EIPs/issues/20
716  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
717  */
718 contract StandardToken is ERC20, BasicToken, Ownable {
719 
720     mapping (address => mapping (address => uint256)) internal allowed;
721 
722 
723     /**
724      * @dev Transfer tokens from one address to another
725      * @param _from address The address which you want to send tokens from
726      * @param _to address The address which you want to transfer to
727      * @param _value uint256 the amount of tokens to be transferred
728      */
729     function transferFrom (
730         address _from,
731         address _to,
732         uint256 _value
733     )
734     public
735     returns (bool)
736     {
737         require(_to != address(0));
738         require(_value <= balances[_from]);
739         require(_value <= allowed[_from][msg.sender]);
740 
741         balances[_from] = balances[_from].sub(_value);
742         balances[_to] = balances[_to].add(_value);
743         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
744         emit Transfer(_from, _to, _value);
745         return true;
746     }
747 
748     /**
749      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
750      *
751      * Beware that changing an allowance with this method brings the risk that someone may use both the old
752      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
753      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
754      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
755      * @param _spender The address which will spend the funds.
756      * @param _value The amount of tokens to be spent.
757      */
758     function approve(address _spender, uint256 _value) public onlyOwner returns (bool) {
759         allowed[msg.sender][_spender] = _value;
760         emit Approval(msg.sender, _spender, _value);
761         return true;
762     }
763 
764     /**
765      * @dev Function to check the amount of tokens that an owner allowed to a spender.
766      * @param _owner address The address which owns the funds.
767      * @param _spender address The address which will spend the funds.
768      * @return A uint256 specifying the amount of tokens still available for the spender.
769      */
770     function allowance(
771         address _owner,
772         address _spender
773     )
774     public
775     view
776     returns (uint256)
777     {
778         return allowed[_owner][_spender];
779     }
780 
781     /**
782      * @dev Increase the amount of tokens that an owner allowed to a spender.
783      *
784      * approve should be called when allowed[_spender] == 0. To increment
785      * allowed value is better to use this function to avoid 2 calls (and wait until
786      * the first transaction is mined)
787      * From MonolithDAO Token.sol
788      * @param _spender The address which will spend the funds.
789      * @param _addedValue The amount of tokens to increase the allowance by.
790      */
791     function increaseApproval(
792         address _spender,
793         uint _addedValue
794     )
795     public
796     returns (bool)
797     {
798         allowed[msg.sender][_spender] = (
799         allowed[msg.sender][_spender].add(_addedValue));
800         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
801         return true;
802     }
803 
804     /**
805      * @dev Decrease the amount of tokens that an owner allowed to a spender.
806      *
807      * approve should be called when allowed[_spender] == 0. To decrement
808      * allowed value is better to use this function to avoid 2 calls (and wait until
809      * the first transaction is mined)
810      * From MonolithDAO Token.sol
811      * @param _spender The address which will spend the funds.
812      * @param _subtractedValue The amount of tokens to decrease the allowance by.
813      */
814     function decreaseApproval(
815         address _spender,
816         uint _subtractedValue
817     )
818     public
819     returns (bool)
820     {
821         uint oldValue = allowed[msg.sender][_spender];
822         if (_subtractedValue > oldValue) {
823             allowed[msg.sender][_spender] = 0;
824         } else {
825             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
826         }
827         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
828         return true;
829     }
830 }
831 
832 /**
833  * @title Standard Burnable Token
834  * @dev Adds burnFrom method to ERC20 implementations
835  */
836 contract StandardBurnableToken is BurnableToken, StandardToken {
837 
838     /**
839      * @dev Burns a specific amount of tokens from the target address and decrements allowance
840      * @param _from address The address which you want to send tokens from
841      * @param _value uint256 The amount of token to be burned
842      */
843     function burnFrom(address _from, uint256 _value) public onlyOwner {
844         require(_value <= allowed[_from][msg.sender]);
845         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
846         // this function needs to emit an event with the updated approval.
847         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
848         _burn(_from, _value);
849     }
850 }
851 
852 /**
853  * @title MoleculeCrowdsale
854  * @dev This is an example of a fully fledged crowdsale.
855  * The way to add new features to a base crowdsale is by multiple inheritance.
856  * In this example we are providing following extensions:
857  * CappedCrowdsale - sets a max boundary for raised funds
858  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
859  *
860  * After adding multiple features it's good practice to run integration tests
861  * to ensure that subcontracts works together as intended.
862  */
863 // XXX There doesn't seem to be a way to split this line that keeps solium
864 // happy. See:
865 // https://github.com/duaraghav8/Solium/issues/205
866 // --elopio - 2018-05-10
867 // solium-disable-next-line max-len
868 contract MoleculeCrowdsale is CappedCrowdsale, RefundableCrowdsale, AllowanceCrowdsale {
869 
870     mapping(address => bool) public whitelist;
871     
872     //mapping (address => uint256) internal referrers
873     mapping (address => uint256) public referrers;
874     
875     uint internal constant REFERRER_PERCENT = 8;
876 
877     /**
878      * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
879      */
880     modifier isWhitelisted(address _beneficiary) {
881         require(whitelist[_beneficiary]);
882         _;
883     }
884     
885     modifier whenNotPaused() {
886         require((block.timestamp > openingTime && block.timestamp < openingTime + (5 weeks)) || (block.timestamp > openingTime + (7 weeks) && block.timestamp < closingTime));
887         _;
888     }
889     
890     constructor(
891         uint256 _openingTime,
892         uint256 _closingTime,
893         uint256 _rate,
894         address _wallet,
895         uint256 _cap,
896         StandardBurnableToken _token,
897         uint256 _goal
898     )
899     public
900     Crowdsale(_rate, _wallet, _token)
901     CappedCrowdsale(_cap)
902     TimedCrowdsale(_openingTime, _closingTime)
903     RefundableCrowdsale(_goal)
904     AllowanceCrowdsale(_wallet)
905     {
906         //As goal needs to be met for a successful crowdsale
907         //the value needs to less or equal than a cap which is limit for accepted funds
908         require(_goal <= _cap);
909         require(_rate > 0);
910     }
911 
912     /**
913      * @dev Adds single address to whitelist.
914      * @param _beneficiary Address to be added to the whitelist
915      */
916     function addToWhitelist(address _beneficiary) external onlyOwner {
917         whitelist[_beneficiary] = true;
918     }
919 
920     /**
921      * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
922      * @param _beneficiaries Addresses to be added to the whitelist
923      */
924     function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
925         for (uint256 i = 0; i < _beneficiaries.length; i++) {
926             whitelist[_beneficiaries[i]] = true;
927         }
928     }
929 
930     /**
931      * @dev Removes single address from whitelist.
932      * @param _beneficiary Address to be removed to the whitelist
933      */
934     function removeFromWhitelist(address _beneficiary) external onlyOwner {
935         whitelist[_beneficiary] = false;
936     }
937     
938     
939     function bytesToAddres(bytes source) internal pure returns(address) {
940         uint result;
941         uint mul = 1;
942         for(uint i = 20; i > 0; i--) {
943             result += uint8(source[i-1])*mul;
944             mul = mul*256;
945         }
946         return address(result);
947     }
948     
949 
950     /**
951      * @dev Extend parent behavior requiring beneficiary to be in whitelist.
952      * @param _beneficiary Token beneficiary
953      * @param _weiAmount Amount of wei contributed
954      */
955     function _preValidatePurchase(
956         address _beneficiary,
957         uint256 _weiAmount
958     )
959     internal
960     whenNotPaused
961     {
962         super._preValidatePurchase(_beneficiary, _weiAmount);
963         
964         if(block.timestamp <= openingTime + (2 weeks)) {
965             require(whitelist[_beneficiary]);
966             require(msg.value >= 5 ether);
967             rate = 833;
968         }else if(block.timestamp > openingTime + (2 weeks) && block.timestamp <= openingTime + (3 weeks)) {
969             require(msg.value >= 5 ether);
970             rate = 722;
971         }else if(block.timestamp > openingTime + (3 weeks) && block.timestamp <= openingTime + (4 weeks)) {
972             require(msg.value >= 5 ether);
973             rate = 666;
974         }else if(block.timestamp > openingTime + (4 weeks) && block.timestamp <= openingTime + (5 weeks)) {
975             require(msg.value >= 5 ether);
976             rate = 611;
977         }else{
978             rate = 555;
979         }
980     }
981 
982     function referrerBonus(address _referrer) public view returns (uint256) {
983         require(goalReached());
984         return referrers[_referrer];
985     }
986     
987     /**
988      * @dev Determines how ETH is stored/forwarded on purchases.
989      */
990     function _forwardFunds()
991     internal
992     {
993         // referer bonus
994         if(msg.data.length == 20) {
995             address referrerAddress = bytesToAddres(bytes(msg.data));
996             require(referrerAddress != address(token) && referrerAddress != msg.sender);
997             uint256 referrerAmount = msg.value.mul(REFERRER_PERCENT).div(100);
998             referrers[referrerAddress] = referrers[referrerAddress].add(referrerAmount);
999         }
1000         
1001         if(block.timestamp <= openingTime + (2 weeks)) {
1002             wallet.transfer(msg.value);
1003         }else{
1004             vault.deposit.value(msg.value)(msg.sender);
1005         }
1006     }
1007 }