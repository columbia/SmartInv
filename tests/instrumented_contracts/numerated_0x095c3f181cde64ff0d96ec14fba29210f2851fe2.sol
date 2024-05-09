1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Crowdsale
5  * @dev Crowdsale is a base contract for managing a token crowdsale.
6  * Crowdsales have a start and end timestamps, where investors can make
7  * token purchases and the crowdsale will assign them tokens based
8  * on a token per ETH rate. Funds collected are forwarded to a wallet
9  * as they arrive. The contract requires a MintableToken that will be
10  * minted as contributions arrive, note that the crowdsale contract
11  * must be owner of the token in order to be able to mint it.
12  */
13 contract Crowdsale {
14     using SafeMath for uint256;
15 
16     // The token being sold
17     MintableToken public token;
18 
19     // start and end timestamps where investments are allowed (both inclusive)
20     uint256 public startTime;
21     uint256 public endTime;
22 
23     // address where funds are collected
24     address public wallet;
25 
26     // how many token units a buyer gets per wei
27     uint256 public rate;
28 
29     // amount of raised money in wei
30     uint256 public weiRaised;
31 
32     /**
33     * event for token purchase logging
34     * @param purchaser who paid for the tokens
35     * @param beneficiary who got the tokens
36     * @param value weis paid for purchase
37     * @param amount amount of tokens purchased
38     */
39     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
40 
41 
42     constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public {
43         require(_startTime >= now);
44         require(_endTime >= _startTime);
45         require(_rate > 0);
46         require(_wallet != address(0));
47         require(_token != address(0));
48 
49         startTime = _startTime;
50         endTime = _endTime;
51         rate = _rate;
52         wallet = _wallet;
53         token = _token;
54     }
55 
56     // fallback function can be used to buy tokens
57     function () external payable {
58         buyTokens(msg.sender);
59     }
60 
61     // low level token purchase function
62     function buyTokens(address beneficiary) public payable {
63         require(beneficiary != address(0));
64         require(validPurchase());
65 
66         uint256 weiAmount = msg.value;
67 
68         // calculate token amount to be created
69         uint256 tokens = getTokenAmount(weiAmount);
70 
71         // update state
72         weiRaised = weiRaised.add(weiAmount);
73 
74         token.mint(beneficiary, tokens);
75         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
76 
77         forwardFunds();
78     }
79 
80     // @return true if crowdsale event has ended
81     function hasEnded() public view returns (bool) {
82         return now > endTime;
83     }
84 
85     // Override this method to have a way to add business logic to your crowdsale when buying
86     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
87         return weiAmount.mul(rate);
88     }
89 
90     // send ether to the fund collection wallet
91     // override to create custom fund forwarding mechanisms
92     function forwardFunds() internal {
93         wallet.transfer(msg.value);
94     }
95 
96     // @return true if the transaction can buy tokens
97     function validPurchase() internal view returns (bool) {
98         bool withinPeriod = now >= startTime && now <= endTime;
99         bool nonZeroPurchase = msg.value != 0;
100         return withinPeriod && nonZeroPurchase;
101     }
102 
103 }
104 
105 
106 
107 
108 /**
109  * @title Ownable
110  * @dev The Ownable contract has an owner address, and provides basic authorization control
111  * functions, this simplifies the implementation of "user permissions".
112  */
113 contract Ownable {
114     address public owner;
115 
116     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117 
118     /**
119     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
120     * account.
121     */
122     constructor(address _owner) public {
123         owner = _owner;
124     }
125 
126     /**
127     * @dev Throws if called by any account other than the owner.
128     */
129     modifier onlyOwner() {
130         require(msg.sender == owner);
131         _;
132     }
133 
134     /**
135     * @dev Allows the current owner to transfer control of the contract to a newOwner.
136     * @param newOwner The address to transfer ownership to.
137     */
138     function transferOwnership(address newOwner) public onlyOwner {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(owner, newOwner);
141         owner = newOwner;
142     }
143 
144 }
145 
146 
147 /**
148  * @title FinalizableCrowdsale
149  * @dev Extension of Crowdsale where an owner can do extra work
150  * after finishing.
151  */
152 contract FinalizableCrowdsale is Crowdsale, Ownable {
153     using SafeMath for uint256;
154 
155     bool public isFinalized = false;
156 
157     event Finalized();
158  
159     constructor(address _owner) public Ownable(_owner) {}
160 
161     /**
162     * @dev Must be called after crowdsale ends, to do some extra finalization
163     * work. Calls the contract's finalization function.
164     */
165     function finalize() onlyOwner public {
166         require(!isFinalized);
167         require(hasEnded());
168 
169         finalization();
170         emit Finalized();
171 
172         isFinalized = true;
173     }
174 
175     /**
176     * @dev Can be overridden to add finalization logic. The overriding function
177     * should call super.finalization() to ensure the chain of finalization is
178     * executed entirely.
179     */
180     function finalization() internal {}
181 }
182 
183 contract Whitelist is Ownable {
184     mapping(address => bool) internal investorMap;
185 
186     event Approved(address indexed investor);
187     event Disapproved(address indexed investor);
188 
189     constructor(address _owner) 
190         public 
191         Ownable(_owner) 
192     {
193     }
194 
195     function isInvestorApproved(address _investor) external view returns (bool) {
196         require(_investor != address(0));
197         return investorMap[_investor];
198     }
199 
200     function approveInvestor(address toApprove) external onlyOwner {
201         investorMap[toApprove] = true;
202         emit Approved(toApprove);
203     }
204 
205     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
206         for (uint i = 0; i < toApprove.length; i++) {
207             investorMap[toApprove[i]] = true;
208             emit Approved(toApprove[i]);
209         }
210     }
211 
212     function disapproveInvestor(address toDisapprove) external onlyOwner {
213         delete investorMap[toDisapprove];
214         emit Disapproved(toDisapprove);
215     }
216 
217     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
218         for (uint i = 0; i < toDisapprove.length; i++) {
219             delete investorMap[toDisapprove[i]];
220             emit Disapproved(toDisapprove[i]);
221         }
222     }
223 }
224 
225 
226 
227 /**
228  * @title SafeMath
229  * @dev Math operations with safety checks that throw on error
230  */
231 library SafeMath {
232 
233   /**
234   * @dev Multiplies two numbers, throws on overflow.
235   */
236   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237     if (a == 0) {
238       return 0;
239     }
240     uint256 c = a * b;
241     assert(c / a == b);
242     return c;
243   }
244 
245   /**
246   * @dev Integer division of two numbers, truncating the quotient.
247   */
248   function div(uint256 a, uint256 b) internal pure returns (uint256) {
249     // assert(b > 0); // Solidity automatically throws when dividing by 0
250     uint256 c = a / b;
251     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252     return c;
253   }
254 
255   /**
256   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
257   */
258   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259     assert(b <= a);
260     return a - b;
261   }
262 
263   /**
264   * @dev Adds two numbers, throws on overflow.
265   */
266   function add(uint256 a, uint256 b) internal pure returns (uint256) {
267     uint256 c = a + b;
268     assert(c >= a);
269     return c;
270   }
271 }
272 
273 /**
274  * @title ERC20Basic
275  * @dev Simpler version of ERC20 interface
276  * @dev see https://github.com/ethereum/EIPs/issues/179
277  */
278 contract ERC20Basic {
279   function totalSupply() public view returns (uint256);
280   function balanceOf(address who) public view returns (uint256);
281   function transfer(address to, uint256 value) public returns (bool);
282   event Transfer(address indexed from, address indexed to, uint256 value);
283 }
284 
285 
286 
287 /**
288  * @title Basic token
289  * @dev Basic version of StandardToken, with no allowances.
290  */
291 contract BasicToken is ERC20Basic {
292   using SafeMath for uint256;
293 
294   mapping(address => uint256) balances;
295 
296   uint256 totalSupply_;
297 
298   /**
299   * @dev total number of tokens in existence
300   */
301   function totalSupply() public view returns (uint256) {
302     return totalSupply_;
303   }
304 
305   /**
306   * @dev transfer token for a specified address
307   * @param _to The address to transfer to.
308   * @param _value The amount to be transferred.
309   */
310   function transfer(address _to, uint256 _value) public returns (bool) {
311     require(_to != address(0));
312     require(_value <= balances[msg.sender]);
313 
314     // SafeMath.sub will throw if there is not enough balance.
315     balances[msg.sender] = balances[msg.sender].sub(_value);
316     balances[_to] = balances[_to].add(_value);
317     emit Transfer(msg.sender, _to, _value);
318     return true;
319   }
320 
321   /**
322   * @dev Gets the balance of the specified address.
323   * @param _owner The address to query the the balance of.
324   * @return An uint256 representing the amount owned by the passed address.
325   */
326   function balanceOf(address _owner) public view returns (uint256 balance) {
327     return balances[_owner];
328   }
329 
330 }
331 
332 
333 
334 
335 
336 
337 /**
338  * @title ERC20 interface
339  * @dev see https://github.com/ethereum/EIPs/issues/20
340  */
341 contract ERC20 is ERC20Basic {
342   function allowance(address owner, address spender) public view returns (uint256);
343   function transferFrom(address from, address to, uint256 value) public returns (bool);
344   function approve(address spender, uint256 value) public returns (bool);
345   event Approval(address indexed owner, address indexed spender, uint256 value);
346 }
347 
348 
349 
350 /**
351  * @title Standard ERC20 token
352  *
353  * @dev Implementation of the basic standard token.
354  * @dev https://github.com/ethereum/EIPs/issues/20
355  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
356  */
357 contract StandardToken is ERC20, BasicToken {
358 
359   mapping (address => mapping (address => uint256)) internal allowed;
360 
361 
362   /**
363    * @dev Transfer tokens from one address to another
364    * @param _from address The address which you want to send tokens from
365    * @param _to address The address which you want to transfer to
366    * @param _value uint256 the amount of tokens to be transferred
367    */
368   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
369     require(_to != address(0));
370     require(_value <= balances[_from]);
371     require(_value <= allowed[_from][msg.sender]);
372 
373     balances[_from] = balances[_from].sub(_value);
374     balances[_to] = balances[_to].add(_value);
375     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
376     emit Transfer(_from, _to, _value);
377     return true;
378   }
379 
380   /**
381    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
382    *
383    * Beware that changing an allowance with this method brings the risk that someone may use both the old
384    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
385    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
386    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
387    * @param _spender The address which will spend the funds.
388    * @param _value The amount of tokens to be spent.
389    */
390   function approve(address _spender, uint256 _value) public returns (bool) {
391     allowed[msg.sender][_spender] = _value;
392     emit Approval(msg.sender, _spender, _value);
393     return true;
394   }
395 
396   /**
397    * @dev Function to check the amount of tokens that an owner allowed to a spender.
398    * @param _owner address The address which owns the funds.
399    * @param _spender address The address which will spend the funds.
400    * @return A uint256 specifying the amount of tokens still available for the spender.
401    */
402   function allowance(address _owner, address _spender) public view returns (uint256) {
403     return allowed[_owner][_spender];
404   }
405 
406   /**
407    * @dev Increase the amount of tokens that an owner allowed to a spender.
408    *
409    * approve should be called when allowed[_spender] == 0. To increment
410    * allowed value is better to use this function to avoid 2 calls (and wait until
411    * the first transaction is mined)
412    * From MonolithDAO Token.sol
413    * @param _spender The address which will spend the funds.
414    * @param _addedValue The amount of tokens to increase the allowance by.
415    */
416   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
417     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
418     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
419     return true;
420   }
421 
422   /**
423    * @dev Decrease the amount of tokens that an owner allowed to a spender.
424    *
425    * approve should be called when allowed[_spender] == 0. To decrement
426    * allowed value is better to use this function to avoid 2 calls (and wait until
427    * the first transaction is mined)
428    * From MonolithDAO Token.sol
429    * @param _spender The address which will spend the funds.
430    * @param _subtractedValue The amount of tokens to decrease the allowance by.
431    */
432   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
433     uint oldValue = allowed[msg.sender][_spender];
434     if (_subtractedValue > oldValue) {
435       allowed[msg.sender][_spender] = 0;
436     } else {
437       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
438     }
439     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
440     return true;
441   }
442 
443 }
444 
445 
446 
447 /**
448  * @title Mintable token
449  * @dev Simple ERC20 Token example, with mintable token creation
450  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
451  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
452  */
453 contract MintableToken is StandardToken, Ownable {
454     event Mint(address indexed to, uint256 amount);
455     event MintFinished();
456 
457     bool public mintingFinished = false;
458 
459 
460     modifier canMint() {
461         require(!mintingFinished);
462         _;
463     }
464 
465     constructor(address _owner) 
466         public 
467         Ownable(_owner) 
468     {
469     }
470 
471     /**
472     * @dev Function to mint tokens
473     * @param _to The address that will receive the minted tokens.
474     * @param _amount The amount of tokens to mint.
475     * @return A boolean that indicates if the operation was successful.
476     */
477     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
478         totalSupply_ = totalSupply_.add(_amount);
479         balances[_to] = balances[_to].add(_amount);
480         emit Mint(_to, _amount);
481         emit Transfer(address(0), _to, _amount);
482         return true;
483     }
484 
485     /**
486     * @dev Function to stop minting new tokens.
487     * @return True if the operation was successful.
488     */
489     function finishMinting() onlyOwner canMint public returns (bool) {
490         mintingFinished = true;
491         emit MintFinished();
492         return true;
493     }
494 }
495 
496 
497 /**
498  * @title Validator
499  * @dev The Validator contract has a validator address, and provides basic authorization control
500  * functions, this simplifies the implementation of "user permissions".
501  */
502 contract Validator {
503     address public validator;
504 
505     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
506 
507     /**
508     * @dev The Validator constructor sets the original `validator` of the contract to the sender
509     * account.
510     */
511     constructor() public {
512         validator = msg.sender;
513     }
514 
515     /**
516     * @dev Throws if called by any account other than the validator.
517     */
518     modifier onlyValidator() {
519         require(msg.sender == validator);
520         _;
521     }
522 
523     /**
524     * @dev Allows the current validator to transfer control of the contract to a newValidator.
525     * @param newValidator The address to become next validator.
526     */
527     function setNewValidator(address newValidator) public onlyValidator {
528         require(newValidator != address(0));
529         emit NewValidatorSet(validator, newValidator);
530         validator = newValidator;
531     }
532 }
533 
534 
535 
536 contract CompliantToken is Validator, MintableToken {
537     Whitelist public whiteListingContract;
538 
539     struct TransactionStruct {
540         address from;
541         address to;
542         uint256 value;
543         uint256 fee;
544         address spender;
545     }
546 
547     mapping (uint => TransactionStruct) public pendingTransactions;
548     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
549     uint256 public currentNonce = 0;
550     uint256 public transferFee;
551     address public feeRecipient;
552 
553     modifier checkIsInvestorApproved(address _account) {
554         require(whiteListingContract.isInvestorApproved(_account));
555         _;
556     }
557 
558     modifier checkIsAddressValid(address _account) {
559         require(_account != address(0));
560         _;
561     }
562 
563     modifier checkIsValueValid(uint256 _value) {
564         require(_value > 0);
565         _;
566     }
567 
568     event TransferRejected(
569         address indexed from,
570         address indexed to,
571         uint256 value,
572         uint256 indexed nonce,
573         uint256 reason
574     );
575 
576     event TransferWithFee(
577         address indexed from,
578         address indexed to,
579         uint256 value,
580         uint256 fee
581     );
582 
583     event RecordedPendingTransaction(
584         address indexed from,
585         address indexed to,
586         uint256 value,
587         uint256 fee,
588         address indexed spender
589     );
590 
591     event WhiteListingContractSet(address indexed _whiteListingContract);
592 
593     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
594 
595     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
596 
597     constructor(
598         address _owner,
599         address whitelistAddress,
600         address recipient,
601         uint256 fee
602     )
603         public 
604         MintableToken(_owner)
605         Validator()
606     {
607         setWhitelistContract(whitelistAddress);
608         setFeeRecipient(recipient);
609         setFee(fee);
610     }
611 
612     function setWhitelistContract(address whitelistAddress)
613         public
614         onlyValidator
615         checkIsAddressValid(whitelistAddress)
616     {
617         whiteListingContract = Whitelist(whitelistAddress);
618         emit WhiteListingContractSet(whiteListingContract);
619     }
620 
621     function setFee(uint256 fee)
622         public
623         onlyValidator
624     {
625         emit FeeSet(transferFee, fee);
626         transferFee = fee;
627     }
628 
629     function setFeeRecipient(address recipient)
630         public
631         onlyValidator
632         checkIsAddressValid(recipient)
633     {
634         emit FeeRecipientSet(feeRecipient, recipient);
635         feeRecipient = recipient;
636     }
637 
638     function transfer(address _to, uint256 _value)
639         public
640         checkIsInvestorApproved(msg.sender)
641         checkIsInvestorApproved(_to)
642         checkIsValueValid(_value)
643         returns (bool)
644     {
645         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
646 
647         if (msg.sender == feeRecipient) {
648             require(_value.add(pendingAmount) <= balances[msg.sender]);
649             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
650         } else {
651             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
652             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
653         }
654 
655         pendingTransactions[currentNonce] = TransactionStruct(
656             msg.sender,
657             _to,
658             _value,
659             transferFee,
660             address(0)
661         );
662 
663         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
664         currentNonce++;
665 
666         return true;
667     }
668 
669     function transferFrom(address _from, address _to, uint256 _value)
670         public 
671         checkIsInvestorApproved(_from)
672         checkIsInvestorApproved(_to)
673         checkIsValueValid(_value)
674         returns (bool)
675     {
676         uint256 allowedTransferAmount = allowed[_from][msg.sender];
677         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
678         
679         if (_from == feeRecipient) {
680             require(_value.add(pendingAmount) <= balances[_from]);
681             require(_value.add(pendingAmount) <= allowedTransferAmount);
682             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
683         } else {
684             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
685             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
686             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
687         }
688 
689         pendingTransactions[currentNonce] = TransactionStruct(
690             _from,
691             _to,
692             _value,
693             transferFee,
694             msg.sender
695         );
696 
697         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
698         currentNonce++;
699 
700         return true;
701     }
702 
703     function approveTransfer(uint256 nonce)
704         external 
705         onlyValidator 
706         checkIsInvestorApproved(pendingTransactions[nonce].from)
707         checkIsInvestorApproved(pendingTransactions[nonce].to)
708         checkIsValueValid(pendingTransactions[nonce].value)
709         returns (bool)
710     {   
711         address from = pendingTransactions[nonce].from;
712         address spender = pendingTransactions[nonce].spender;
713         address to = pendingTransactions[nonce].to;
714         uint256 value = pendingTransactions[nonce].value;
715         uint256 allowedTransferAmount = allowed[from][spender];
716         uint256 pendingAmount = pendingApprovalAmount[from][spender];
717         uint256 fee = pendingTransactions[nonce].fee;
718         uint256 balanceFrom = balances[from];
719         uint256 balanceTo = balances[to];
720 
721         delete pendingTransactions[nonce];
722 
723         if (from == feeRecipient) {
724             fee = 0;
725             balanceFrom = balanceFrom.sub(value);
726             balanceTo = balanceTo.add(value);
727 
728             if (spender != address(0)) {
729                 allowedTransferAmount = allowedTransferAmount.sub(value);
730             } 
731             pendingAmount = pendingAmount.sub(value);
732 
733         } else {
734             balanceFrom = balanceFrom.sub(value.add(fee));
735             balanceTo = balanceTo.add(value);
736             balances[feeRecipient] = balances[feeRecipient].add(fee);
737 
738             if (spender != address(0)) {
739                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
740             }
741             pendingAmount = pendingAmount.sub(value).sub(fee);
742         }
743 
744         emit TransferWithFee(
745             from,
746             to,
747             value,
748             fee
749         );
750 
751         emit Transfer(
752             from,
753             to,
754             value
755         );
756         
757         balances[from] = balanceFrom;
758         balances[to] = balanceTo;
759         allowed[from][spender] = allowedTransferAmount;
760         pendingApprovalAmount[from][spender] = pendingAmount;
761         return true;
762     }
763 
764     function rejectTransfer(uint256 nonce, uint256 reason)
765         external 
766         onlyValidator
767         checkIsAddressValid(pendingTransactions[nonce].from)
768     {        
769         address from = pendingTransactions[nonce].from;
770         address spender = pendingTransactions[nonce].spender;
771 
772         if (from == feeRecipient) {
773             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
774                 .sub(pendingTransactions[nonce].value);
775         } else {
776             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
777                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
778         }
779         
780         emit TransferRejected(
781             from,
782             pendingTransactions[nonce].to,
783             pendingTransactions[nonce].value,
784             nonce,
785             reason
786         );
787         
788         delete pendingTransactions[nonce];
789     }
790 }
791 
792 
793 contract CompliantCrowdsale is Validator, FinalizableCrowdsale {
794     Whitelist public whiteListingContract;
795 
796     struct MintStruct {
797         address to;
798         uint256 tokens;
799         uint256 weiAmount;
800     }
801 
802     mapping (uint => MintStruct) public pendingMints;
803     uint256 public currentMintNonce;
804     mapping (address => uint) public rejectedMintBalance;
805 
806     modifier checkIsInvestorApproved(address _account) {
807         require(whiteListingContract.isInvestorApproved(_account));
808         _;
809     }
810 
811     modifier checkIsAddressValid(address _account) {
812         require(_account != address(0));
813         _;
814     }
815 
816     event MintRejected(
817         address indexed to,
818         uint256 value,
819         uint256 amount,
820         uint256 indexed nonce,
821         uint256 reason
822     );
823 
824     event ContributionRegistered(
825         address beneficiary,
826         uint256 tokens,
827         uint256 weiAmount,
828         uint256 nonce
829     );
830 
831     event WhiteListingContractSet(address indexed _whiteListingContract);
832 
833     event Claimed(address indexed account, uint256 amount);
834 
835     constructor(
836         address whitelistAddress,
837         uint256 _startTime,
838         uint256 _endTime,
839         uint256 _rate,
840         address _wallet,
841         MintableToken _token,
842         address _owner
843     )
844         public
845         FinalizableCrowdsale(_owner)
846         Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
847     {
848         setWhitelistContract(whitelistAddress);
849     }
850 
851     function setWhitelistContract(address whitelistAddress)
852         public 
853         onlyValidator 
854         checkIsAddressValid(whitelistAddress)
855     {
856         whiteListingContract = Whitelist(whitelistAddress);
857         emit WhiteListingContractSet(whiteListingContract);
858     }
859 
860     function buyTokens(address beneficiary)
861         public 
862         payable
863         checkIsInvestorApproved(beneficiary)
864     {
865         require(validPurchase());
866 
867         uint256 weiAmount = msg.value;
868 
869         // calculate token amount to be created
870         uint256 tokens = weiAmount.mul(rate);
871 
872         pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount);
873         emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce);
874 
875         currentMintNonce++;
876     }
877 
878     function approveMint(uint256 nonce)
879         external 
880         onlyValidator 
881         checkIsInvestorApproved(pendingMints[nonce].to)
882         returns (bool)
883     {
884         // update state
885         weiRaised = weiRaised.add(pendingMints[nonce].weiAmount);
886 
887         //No need to use mint-approval on token side, since the minting is already approved in the crowdsale side
888         token.mint(pendingMints[nonce].to, pendingMints[nonce].tokens);
889         
890         emit TokenPurchase(
891             msg.sender,
892             pendingMints[nonce].to,
893             pendingMints[nonce].weiAmount,
894             pendingMints[nonce].tokens
895         );
896 
897         forwardFunds(pendingMints[nonce].weiAmount);
898         delete pendingMints[nonce];
899 
900         return true;
901     }
902 
903     function rejectMint(uint256 nonce, uint256 reason)
904         external 
905         onlyValidator 
906         checkIsAddressValid(pendingMints[nonce].to)
907     {
908         rejectedMintBalance[pendingMints[nonce].to] = rejectedMintBalance[pendingMints[nonce].to].add(pendingMints[nonce].weiAmount);
909         
910         emit MintRejected(
911             pendingMints[nonce].to,
912             pendingMints[nonce].tokens,
913             pendingMints[nonce].weiAmount,
914             nonce,
915             reason
916         );
917         
918         delete pendingMints[nonce];
919     }
920 
921     function claim() external {
922         require(rejectedMintBalance[msg.sender] > 0);
923         uint256 value = rejectedMintBalance[msg.sender];
924         rejectedMintBalance[msg.sender] = 0;
925 
926         msg.sender.transfer(value);
927 
928         emit Claimed(msg.sender, value);
929     }
930 
931     function finalization() internal {
932         transferTokenOwnership(validator);
933         super.finalization();
934     }
935     
936     function setTokenContract(address newToken)
937         external 
938         onlyOwner
939         checkIsAddressValid(newToken)
940     {
941         token = CompliantToken(newToken);
942     }
943 
944     function transferTokenOwnership(address newOwner)
945         public 
946         onlyOwner
947         checkIsAddressValid(newOwner)
948     {
949         token.transferOwnership(newOwner);
950     }
951 
952     function forwardFunds(uint256 amount) internal {
953         wallet.transfer(amount);
954     }
955 }