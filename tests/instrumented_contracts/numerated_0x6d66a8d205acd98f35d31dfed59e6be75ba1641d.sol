1 pragma solidity 0.4.24;
2 
3 //
4 //
5 ///
6 //
7 //
8 //
9 //
10 //
11 //
12 //company_2
13 //
14 //
15 //
16 //demo
17 //wallet2
18 //new ICO Sep28
19 //company_2
20 //DefaultOffer
21 //DefaultOffer
22 //new for company_2
23 //FOR PRODUCTION
24 //New Offer
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   /**
55   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address public owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85     * account.
86     */
87     constructor(address _owner) public {
88         owner = _owner;
89     }
90 
91     /**
92     * @dev Throws if called by any account other than the owner.
93     */
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     /**
100     * @dev Allows the current owner to transfer control of the contract to a newOwner.
101     * @param newOwner The address to transfer ownership to.
102     */
103     function transferOwnership(address newOwner) public onlyOwner {
104         require(newOwner != address(0));
105         emit OwnershipTransferred(owner, newOwner);
106         owner = newOwner;
107     }
108 
109 }
110 
111 
112 contract Whitelist is Ownable {
113     mapping(address => bool) internal investorMap;
114 
115     /**
116     * event for investor approval logging
117     * @param investor approved investor
118     */
119     event Approved(address indexed investor);
120 
121     /**
122     * event for investor disapproval logging
123     * @param investor disapproved investor
124     */
125     event Disapproved(address indexed investor);
126 
127     constructor(address _owner) 
128         public 
129         Ownable(_owner) 
130     {
131         
132     }
133 
134     /** @param _investor the address of investor to be checked
135       * @return true if investor is approved
136       */
137     function isInvestorApproved(address _investor) external view returns (bool) {
138         require(_investor != address(0));
139         return investorMap[_investor];
140     }
141 
142     /** @dev approve an investor
143       * @param toApprove investor to be approved
144       */
145     function approveInvestor(address toApprove) external onlyOwner {
146         investorMap[toApprove] = true;
147         emit Approved(toApprove);
148     }
149 
150     /** @dev approve investors in bulk
151       * @param toApprove array of investors to be approved
152       */
153     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
154         for (uint i = 0; i < toApprove.length; i++) {
155             investorMap[toApprove[i]] = true;
156             emit Approved(toApprove[i]);
157         }
158     }
159 
160     /** @dev disapprove an investor
161       * @param toDisapprove investor to be disapproved
162       */
163     function disapproveInvestor(address toDisapprove) external onlyOwner {
164         delete investorMap[toDisapprove];
165         emit Disapproved(toDisapprove);
166     }
167 
168     /** @dev disapprove investors in bulk
169       * @param toDisapprove array of investors to be disapproved
170       */
171     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
172         for (uint i = 0; i < toDisapprove.length; i++) {
173             delete investorMap[toDisapprove[i]];
174             emit Disapproved(toDisapprove[i]);
175         }
176     }
177 }
178 
179 
180 /**
181  * @title Validator
182  * @dev The Validator contract has a validator address, and provides basic authorization control
183  * functions, this simplifies the implementation of "user permissions".
184  */
185 contract Validator {
186     address public validator;
187 
188     /**
189     * event for validator address update logging
190     * @param previousOwner address of the old validator
191     * @param newValidator address of the new validator
192     */
193     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
194 
195     /**
196     * @dev The Validator constructor sets the original `validator` of the contract to the sender
197     * account.
198     */
199     constructor() public {
200         validator = msg.sender;
201     }
202 
203     /**
204     * @dev Throws if called by any account other than the validator.
205     */
206     modifier onlyValidator() {
207         require(msg.sender == validator);
208         _;
209     }
210 
211     /**
212     * @dev Allows the current validator to transfer control of the contract to a newValidator.
213     * @param newValidator The address to become next validator.
214     */
215     function setNewValidator(address newValidator) public onlyValidator {
216         require(newValidator != address(0));
217         emit NewValidatorSet(validator, newValidator);
218         validator = newValidator;
219     }
220 }
221 
222 
223 /**
224  * @title ERC20Basic
225  * @dev Simpler version of ERC20 interface
226  * @dev see https://github.com/ethereum/EIPs/issues/179
227  */
228 contract ERC20Basic {
229   function totalSupply() public view returns (uint256);
230   function balanceOf(address who) public view returns (uint256);
231   function transfer(address to, uint256 value) public returns (bool);
232   event Transfer(address indexed from, address indexed to, uint256 value);
233 }
234 
235 
236 /**
237  * @title ERC20 interface
238  * @dev see https://github.com/ethereum/EIPs/issues/20
239  */
240 contract ERC20 is ERC20Basic {
241   function allowance(address owner, address spender) public view returns (uint256);
242   function transferFrom(address from, address to, uint256 value) public returns (bool);
243   function approve(address spender, uint256 value) public returns (bool);
244   event Approval(address indexed owner, address indexed spender, uint256 value);
245 }
246 
247 
248 /**
249  * @title Basic token
250  * @dev Basic version of StandardToken, with no allowances.
251  */
252 contract BasicToken is ERC20Basic {
253   using SafeMath for uint256;
254 
255   mapping(address => uint256) balances;
256 
257   uint256 totalSupply_;
258 
259   /**
260   * @dev total number of tokens in existence
261   */
262   function totalSupply() public view returns (uint256) {
263     return totalSupply_;
264   }
265 
266   /**
267   * @dev transfer token for a specified address
268   * @param _to The address to transfer to.
269   * @param _value The amount to be transferred.
270   */
271   function transfer(address _to, uint256 _value) public returns (bool) {
272     require(_to != address(0));
273     require(_value <= balances[msg.sender]);
274 
275     // SafeMath.sub will throw if there is not enough balance.
276     balances[msg.sender] = balances[msg.sender].sub(_value);
277     balances[_to] = balances[_to].add(_value);
278     emit Transfer(msg.sender, _to, _value);
279     return true;
280   }
281 
282   /**
283   * @dev Gets the balance of the specified address.
284   * @param _owner The address to query the the balance of.
285   * @return An uint256 representing the amount owned by the passed address.
286   */
287   function balanceOf(address _owner) public view returns (uint256 balance) {
288     return balances[_owner];
289   }
290 
291 }
292 
293 
294 /**
295  * @title Standard ERC20 token
296  *
297  * @dev Implementation of the basic standard token.
298  * @dev https://github.com/ethereum/EIPs/issues/20
299  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
300  */
301 contract StandardToken is ERC20, BasicToken {
302 
303   mapping (address => mapping (address => uint256)) internal allowed;
304 
305 
306   /**
307    * @dev Transfer tokens from one address to another
308    * @param _from address The address which you want to send tokens from
309    * @param _to address The address which you want to transfer to
310    * @param _value uint256 the amount of tokens to be transferred
311    */
312   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
313     require(_to != address(0));
314     require(_value <= balances[_from]);
315     require(_value <= allowed[_from][msg.sender]);
316 
317     balances[_from] = balances[_from].sub(_value);
318     balances[_to] = balances[_to].add(_value);
319     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
320     emit Transfer(_from, _to, _value);
321     return true;
322   }
323 
324   /**
325    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
326    *
327    * Beware that changing an allowance with this method brings the risk that someone may use both the old
328    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
329    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
330    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
331    * @param _spender The address which will spend the funds.
332    * @param _value The amount of tokens to be spent.
333    */
334   function approve(address _spender, uint256 _value) public returns (bool) {
335     allowed[msg.sender][_spender] = _value;
336     emit Approval(msg.sender, _spender, _value);
337     return true;
338   }
339 
340   /**
341    * @dev Function to check the amount of tokens that an owner allowed to a spender.
342    * @param _owner address The address which owns the funds.
343    * @param _spender address The address which will spend the funds.
344    * @return A uint256 specifying the amount of tokens still available for the spender.
345    */
346   function allowance(address _owner, address _spender) public view returns (uint256) {
347     return allowed[_owner][_spender];
348   }
349 
350   /**
351    * @dev Increase the amount of tokens that an owner allowed to a spender.
352    *
353    * approve should be called when allowed[_spender] == 0. To increment
354    * allowed value is better to use this function to avoid 2 calls (and wait until
355    * the first transaction is mined)
356    * From MonolithDAO Token.sol
357    * @param _spender The address which will spend the funds.
358    * @param _addedValue The amount of tokens to increase the allowance by.
359    */
360   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
361     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
362     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
363     return true;
364   }
365 
366   /**
367    * @dev Decrease the amount of tokens that an owner allowed to a spender.
368    *
369    * approve should be called when allowed[_spender] == 0. To decrement
370    * allowed value is better to use this function to avoid 2 calls (and wait until
371    * the first transaction is mined)
372    * From MonolithDAO Token.sol
373    * @param _spender The address which will spend the funds.
374    * @param _subtractedValue The amount of tokens to decrease the allowance by.
375    */
376   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
377     uint oldValue = allowed[msg.sender][_spender];
378     if (_subtractedValue > oldValue) {
379       allowed[msg.sender][_spender] = 0;
380     } else {
381       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
382     }
383     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
384     return true;
385   }
386 
387 }
388 
389 
390 /**
391  * @title Mintable token
392  * @dev Simple ERC20 Token example, with mintable token creation
393  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
394  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
395  */
396 contract MintableToken is StandardToken, Ownable {
397     event Mint(address indexed to, uint256 amount);
398     event MintFinished();
399 
400     bool public mintingFinished = false;
401 
402 
403     modifier canMint() {
404         require(!mintingFinished);
405         _;
406     }
407 
408     constructor(address _owner) 
409         public 
410         Ownable(_owner) 
411     {
412 
413     }
414 
415     /**
416     * @dev Function to mint tokens
417     * @param _to The address that will receive the minted tokens.
418     * @param _amount The amount of tokens to mint.
419     * @return A boolean that indicates if the operation was successful.
420     */
421     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
422         totalSupply_ = totalSupply_.add(_amount);
423         balances[_to] = balances[_to].add(_amount);
424         emit Mint(_to, _amount);
425         emit Transfer(address(0), _to, _amount);
426         return true;
427     }
428 
429     /**
430     * @dev Function to stop minting new tokens.
431     * @return True if the operation was successful.
432     */
433     function finishMinting() onlyOwner canMint public returns (bool) {
434         mintingFinished = true;
435         emit MintFinished();
436         return true;
437     }
438 }
439 
440 
441 contract DetailedERC20 {
442   string public name;
443   string public symbol;
444   uint8 public decimals;
445 
446   constructor(string _name, string _symbol, uint8 _decimals) public {
447     name = _name;
448     symbol = _symbol;
449     decimals = _decimals;
450   }
451 }
452 
453 
454 /** @title Compliant Token */
455 contract CompliantToken is Validator, DetailedERC20, MintableToken {
456     Whitelist public whiteListingContract;
457 
458     struct TransactionStruct {
459         address from;
460         address to;
461         uint256 value;
462         uint256 fee;
463         address spender;
464     }
465 
466     mapping (uint => TransactionStruct) public pendingTransactions;
467     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
468     uint256 public currentNonce = 0;
469     uint256 public transferFee;
470     address public feeRecipient;
471 
472     modifier checkIsInvestorApproved(address _account) {
473         require(whiteListingContract.isInvestorApproved(_account));
474         _;
475     }
476 
477     modifier checkIsAddressValid(address _account) {
478         require(_account != address(0));
479         _;
480     }
481 
482     modifier checkIsValueValid(uint256 _value) {
483         require(_value > 0);
484         _;
485     }
486 
487     /**
488     * event for rejected transfer logging
489     * @param from address from which tokens have to be transferred
490     * @param to address to tokens have to be transferred
491     * @param value number of tokens
492     * @param nonce request recorded at this particular nonce
493     * @param reason reason for rejection
494     */
495     event TransferRejected(
496         address indexed from,
497         address indexed to,
498         uint256 value,
499         uint256 indexed nonce,
500         uint256 reason
501     );
502 
503     /**
504     * event for transfer tokens logging
505     * @param from address from which tokens have to be transferred
506     * @param to address to tokens have to be transferred
507     * @param value number of tokens
508     * @param fee fee in tokens
509     */
510     event TransferWithFee(
511         address indexed from,
512         address indexed to,
513         uint256 value,
514         uint256 fee
515     );
516 
517     /**
518     * event for transfer/transferFrom request logging
519     * @param from address from which tokens have to be transferred
520     * @param to address to tokens have to be transferred
521     * @param value number of tokens
522     * @param fee fee in tokens
523     * @param spender The address which will spend the tokens
524     */
525     event RecordedPendingTransaction(
526         address indexed from,
527         address indexed to,
528         uint256 value,
529         uint256 fee,
530         address indexed spender
531     );
532 
533     /**
534     * event for whitelist contract update logging
535     * @param _whiteListingContract address of the new whitelist contract
536     */
537     event WhiteListingContractSet(address indexed _whiteListingContract);
538 
539     /**
540     * event for fee update logging
541     * @param previousFee previous fee
542     * @param newFee new fee
543     */
544     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
545 
546     /**
547     * event for fee recipient update logging
548     * @param previousRecipient address of the old fee recipient
549     * @param newRecipient address of the new fee recipient
550     */
551     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
552 
553     /** @dev Constructor
554       * @param _owner Token contract owner
555       * @param _name Token name
556       * @param _symbol Token symbol
557       * @param _decimals number of decimals in the token(usually 18)
558       * @param whitelistAddress Ethereum address of the whitelist contract
559       * @param recipient Ethereum address of the fee recipient
560       * @param fee token fee for approving a transfer
561       */
562     constructor(
563         address _owner,
564         string _name, 
565         string _symbol, 
566         uint8 _decimals,
567         address whitelistAddress,
568         address recipient,
569         uint256 fee
570     )
571         public
572         MintableToken(_owner)
573         DetailedERC20(_name, _symbol, _decimals)
574         Validator()
575     {
576         setWhitelistContract(whitelistAddress);
577         setFeeRecipient(recipient);
578         setFee(fee);
579     }
580 
581     /** @dev Updates whitelist contract address
582       * @param whitelistAddress New whitelist contract address
583       */
584     function setWhitelistContract(address whitelistAddress)
585         public
586         onlyValidator
587         checkIsAddressValid(whitelistAddress)
588     {
589         whiteListingContract = Whitelist(whitelistAddress);
590         emit WhiteListingContractSet(whiteListingContract);
591     }
592 
593     /** @dev Updates token fee for approving a transfer
594       * @param fee New token fee
595       */
596     function setFee(uint256 fee)
597         public
598         onlyValidator
599     {
600         emit FeeSet(transferFee, fee);
601         transferFee = fee;
602     }
603 
604     /** @dev Updates fee recipient address
605       * @param recipient New whitelist contract address
606       */
607     function setFeeRecipient(address recipient)
608         public
609         onlyValidator
610         checkIsAddressValid(recipient)
611     {
612         emit FeeRecipientSet(feeRecipient, recipient);
613         feeRecipient = recipient;
614     }
615 
616     /** @dev Updates token name
617       * @param _name New token name
618       */
619     function updateName(string _name) public onlyOwner {
620         require(bytes(_name).length != 0);
621         name = _name;
622     }
623 
624     /** @dev Updates token symbol
625       * @param _symbol New token name
626       */
627     function updateSymbol(string _symbol) public onlyOwner {
628         require(bytes(_symbol).length != 0);
629         symbol = _symbol;
630     }
631 
632     /** @dev transfer request
633       * @param _to address to which the tokens have to be transferred
634       * @param _value amount of tokens to be transferred
635       */
636     function transfer(address _to, uint256 _value)
637         public
638         checkIsInvestorApproved(msg.sender)
639         checkIsInvestorApproved(_to)
640         checkIsValueValid(_value)
641         returns (bool)
642     {
643         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
644 
645         if (msg.sender == feeRecipient) {
646             require(_value.add(pendingAmount) <= balances[msg.sender]);
647             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
648         } else {
649             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
650             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
651         }
652 
653         pendingTransactions[currentNonce] = TransactionStruct(
654             msg.sender,
655             _to,
656             _value,
657             transferFee,
658             address(0)
659         );
660 
661         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
662         currentNonce++;
663 
664         return true;
665     }
666 
667     /** @dev transferFrom request
668       * @param _from address from which the tokens have to be transferred
669       * @param _to address to which the tokens have to be transferred
670       * @param _value amount of tokens to be transferred
671       */
672     function transferFrom(address _from, address _to, uint256 _value)
673         public 
674         checkIsInvestorApproved(_from)
675         checkIsInvestorApproved(_to)
676         checkIsValueValid(_value)
677         returns (bool)
678     {
679         uint256 allowedTransferAmount = allowed[_from][msg.sender];
680         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
681         
682         if (_from == feeRecipient) {
683             require(_value.add(pendingAmount) <= balances[_from]);
684             require(_value.add(pendingAmount) <= allowedTransferAmount);
685             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
686         } else {
687             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
688             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
689             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
690         }
691 
692         pendingTransactions[currentNonce] = TransactionStruct(
693             _from,
694             _to,
695             _value,
696             transferFee,
697             msg.sender
698         );
699 
700         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
701         currentNonce++;
702 
703         return true;
704     }
705 
706     /** @dev approve transfer/transferFrom request
707       * @param nonce request recorded at this particular nonce
708       */
709     function approveTransfer(uint256 nonce)
710         external 
711         onlyValidator 
712         checkIsInvestorApproved(pendingTransactions[nonce].from)
713         checkIsInvestorApproved(pendingTransactions[nonce].to)
714         checkIsValueValid(pendingTransactions[nonce].value)
715         returns (bool)
716     {   
717         address from = pendingTransactions[nonce].from;
718         address spender = pendingTransactions[nonce].spender;
719         address to = pendingTransactions[nonce].to;
720         uint256 value = pendingTransactions[nonce].value;
721         uint256 allowedTransferAmount = allowed[from][spender];
722         uint256 pendingAmount = pendingApprovalAmount[from][spender];
723         uint256 fee = pendingTransactions[nonce].fee;
724         uint256 balanceFrom = balances[from];
725         uint256 balanceTo = balances[to];
726 
727         delete pendingTransactions[nonce];
728 
729         if (from == feeRecipient) {
730             fee = 0;
731             balanceFrom = balanceFrom.sub(value);
732             balanceTo = balanceTo.add(value);
733 
734             if (spender != address(0)) {
735                 allowedTransferAmount = allowedTransferAmount.sub(value);
736             } 
737             pendingAmount = pendingAmount.sub(value);
738 
739         } else {
740             balanceFrom = balanceFrom.sub(value.add(fee));
741             balanceTo = balanceTo.add(value);
742             balances[feeRecipient] = balances[feeRecipient].add(fee);
743 
744             if (spender != address(0)) {
745                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
746             }
747             pendingAmount = pendingAmount.sub(value).sub(fee);
748         }
749 
750         emit TransferWithFee(
751             from,
752             to,
753             value,
754             fee
755         );
756 
757         emit Transfer(
758             from,
759             to,
760             value
761         );
762         
763         balances[from] = balanceFrom;
764         balances[to] = balanceTo;
765         allowed[from][spender] = allowedTransferAmount;
766         pendingApprovalAmount[from][spender] = pendingAmount;
767         return true;
768     }
769 
770     /** @dev reject transfer/transferFrom request
771       * @param nonce request recorded at this particular nonce
772       * @param reason reason for rejection
773       */
774     function rejectTransfer(uint256 nonce, uint256 reason)
775         external 
776         onlyValidator
777         checkIsAddressValid(pendingTransactions[nonce].from)
778     {        
779         address from = pendingTransactions[nonce].from;
780         address spender = pendingTransactions[nonce].spender;
781 
782         if (from == feeRecipient) {
783             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
784                 .sub(pendingTransactions[nonce].value);
785         } else {
786             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
787                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
788         }
789         
790         emit TransferRejected(
791             from,
792             pendingTransactions[nonce].to,
793             pendingTransactions[nonce].value,
794             nonce,
795             reason
796         );
797         
798         delete pendingTransactions[nonce];
799     }
800 }
801 
802 
803 /**
804  * @title Crowdsale
805  * @dev Crowdsale is a base contract for managing a token crowdsale.
806  * Crowdsales have a start and end timestamps, where investors can make
807  * token purchases and the crowdsale will assign them tokens based
808  * on a token per ETH rate. Funds collected are forwarded to a wallet
809  * as they arrive. The contract requires a MintableToken that will be
810  * minted as contributions arrive, note that the crowdsale contract
811  * must be owner of the token in order to be able to mint it.
812  */
813 contract Crowdsale {
814     using SafeMath for uint256;
815 
816     // The token being sold
817     MintableToken public token;
818 
819     // start and end timestamps where investments are allowed (both inclusive)
820     uint256 public startTime;
821     uint256 public endTime;
822 
823     // address where funds are collected
824     address public wallet;
825 
826     // how many token units a buyer gets per wei
827     uint256 public rate;
828 
829     // amount of raised money in wei
830     uint256 public weiRaised;
831 
832     /**
833     * event for token purchase logging
834     * @param purchaser who paid for the tokens
835     * @param beneficiary who got the tokens
836     * @param value weis paid for purchase
837     * @param amount amount of tokens purchased
838     */
839     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
840 
841 
842     constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public {
843         require(_startTime >= now);
844         require(_endTime >= _startTime);
845         require(_rate > 0);
846         require(_wallet != address(0));
847         require(_token != address(0));
848 
849         startTime = _startTime;
850         endTime = _endTime;
851         rate = _rate;
852         wallet = _wallet;
853         token = _token;
854     }
855 
856     /** @dev fallback function redirects to buy tokens */
857     function () external payable {
858         buyTokens(msg.sender);
859     }
860 
861     /** @dev buy tokens
862       * @param beneficiary the address to which the tokens have to be minted
863       */
864     function buyTokens(address beneficiary) public payable {
865         require(beneficiary != address(0));
866         require(validPurchase());
867 
868         uint256 weiAmount = msg.value;
869 
870         // calculate token amount to be created
871         uint256 tokens = getTokenAmount(weiAmount);
872 
873         // update state
874         weiRaised = weiRaised.add(weiAmount);
875 
876         token.mint(beneficiary, tokens);
877         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
878 
879         forwardFunds();
880     }
881 
882     /** @return true if crowdsale event has ended */
883     function hasEnded() public view returns (bool) {
884         return now > endTime;
885     }
886 
887     // Override this method to have a way to add business logic to your crowdsale when buying
888     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
889         return weiAmount.mul(rate);
890     }
891 
892     // send ether to the fund collection wallet
893     // override to create custom fund forwarding mechanisms
894     function forwardFunds() internal {
895         wallet.transfer(msg.value);
896     }
897 
898     // @return true if the transaction can buy tokens
899     function validPurchase() internal view returns (bool) {
900         bool withinPeriod = now >= startTime && now <= endTime;
901         bool nonZeroPurchase = msg.value != 0;
902         return withinPeriod && nonZeroPurchase;
903     }
904 
905 }
906 
907 
908 /**
909  * @title FinalizableCrowdsale
910  * @dev Extension of Crowdsale where an owner can do extra work
911  * after finishing.
912  */
913 contract FinalizableCrowdsale is Crowdsale, Ownable {
914     using SafeMath for uint256;
915 
916     bool public isFinalized = false;
917 
918     event Finalized();
919  
920     constructor(address _owner) public Ownable(_owner) {}
921 
922     /**
923     * @dev Must be called after crowdsale ends, to do some extra finalization
924     * work. Calls the contract's finalization function.
925     */
926     function finalize() onlyOwner public {
927         require(!isFinalized);
928         require(hasEnded());
929 
930         finalization();
931         emit Finalized();
932 
933         isFinalized = true;
934     }
935 
936     /**
937     * @dev Can be overridden to add finalization logic. The overriding function
938     * should call super.finalization() to ensure the chain of finalization is
939     * executed entirely.
940     */
941     function finalization() internal {}
942 }
943 
944 
945 /** @title Compliant Crowdsale */
946 contract CompliantCrowdsale is Validator, FinalizableCrowdsale {
947     Whitelist public whiteListingContract;
948 
949     struct MintStruct {
950         address to;
951         uint256 tokens;
952         uint256 weiAmount;
953     }
954 
955     mapping (uint => MintStruct) public pendingMints;
956     uint256 public currentMintNonce;
957     mapping (address => uint) public rejectedMintBalance;
958 
959     modifier checkIsInvestorApproved(address _account) {
960         require(whiteListingContract.isInvestorApproved(_account));
961         _;
962     }
963 
964     modifier checkIsAddressValid(address _account) {
965         require(_account != address(0));
966         _;
967     }
968 
969     /**
970     * event for rejected mint logging
971     * @param to address for which buy tokens got rejected
972     * @param value number of tokens
973     * @param amount number of ethers invested
974     * @param nonce request recorded at this particular nonce
975     * @param reason reason for rejection
976     */
977     event MintRejected(
978         address indexed to,
979         uint256 value,
980         uint256 amount,
981         uint256 indexed nonce,
982         uint256 reason
983     );
984 
985     /**
986     * event for buy tokens request logging
987     * @param beneficiary address for which buy tokens is requested
988     * @param tokens number of tokens
989     * @param weiAmount number of ethers invested
990     * @param nonce request recorded at this particular nonce
991     */
992     event ContributionRegistered(
993         address beneficiary,
994         uint256 tokens,
995         uint256 weiAmount,
996         uint256 nonce
997     );
998 
999     /**
1000     * event for whitelist contract update logging
1001     * @param _whiteListingContract address of the new whitelist contract
1002     */
1003     event WhiteListingContractSet(address indexed _whiteListingContract);
1004 
1005     /**
1006     * event for claimed ether logging
1007     * @param account user claiming the ether
1008     * @param amount ether claimed
1009     */
1010     event Claimed(address indexed account, uint256 amount);
1011 
1012     /** @dev Constructor
1013       * @param whitelistAddress Ethereum address of the whitelist contract
1014       * @param _startTime crowdsale start time
1015       * @param _endTime crowdsale end time
1016       * @param _rate number of tokens to be sold per ether
1017       * @param _wallet Ethereum address of the wallet
1018       * @param _token Ethereum address of the token contract
1019       * @param _owner Ethereum address of the owner
1020       */
1021     constructor(
1022         address whitelistAddress,
1023         uint256 _startTime,
1024         uint256 _endTime,
1025         uint256 _rate,
1026         address _wallet,
1027         MintableToken _token,
1028         address _owner
1029     )
1030         public
1031         FinalizableCrowdsale(_owner)
1032         Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
1033     {
1034         setWhitelistContract(whitelistAddress);
1035     }
1036 
1037     /** @dev Updates whitelist contract address
1038       * @param whitelistAddress address of the new whitelist contract 
1039       */
1040     function setWhitelistContract(address whitelistAddress)
1041         public 
1042         onlyValidator 
1043         checkIsAddressValid(whitelistAddress)
1044     {
1045         whiteListingContract = Whitelist(whitelistAddress);
1046         emit WhiteListingContractSet(whiteListingContract);
1047     }
1048 
1049     /** @dev buy tokens request
1050       * @param beneficiary the address to which the tokens have to be minted
1051       */
1052     function buyTokens(address beneficiary)
1053         public 
1054         payable
1055         checkIsInvestorApproved(beneficiary)
1056     {
1057         require(validPurchase());
1058 
1059         uint256 weiAmount = msg.value;
1060 
1061         // calculate token amount to be created
1062         uint256 tokens = weiAmount.mul(rate);
1063 
1064         pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount);
1065         emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce);
1066 
1067         currentMintNonce++;
1068     }
1069 
1070     /** @dev approve buy tokens request
1071       * @param nonce request recorded at this particular nonce
1072       */
1073     function approveMint(uint256 nonce)
1074         external 
1075         onlyValidator 
1076         checkIsInvestorApproved(pendingMints[nonce].to)
1077         returns (bool)
1078     {
1079         // update state
1080         weiRaised = weiRaised.add(pendingMints[nonce].weiAmount);
1081 
1082         //No need to use mint-approval on token side, since the minting is already approved in the crowdsale side
1083         token.mint(pendingMints[nonce].to, pendingMints[nonce].tokens);
1084         
1085         emit TokenPurchase(
1086             msg.sender,
1087             pendingMints[nonce].to,
1088             pendingMints[nonce].weiAmount,
1089             pendingMints[nonce].tokens
1090         );
1091 
1092         forwardFunds(pendingMints[nonce].weiAmount);
1093         delete pendingMints[nonce];
1094 
1095         return true;
1096     }
1097 
1098     /** @dev reject buy tokens request
1099       * @param nonce request recorded at this particular nonce
1100       * @param reason reason for rejection
1101       */
1102     function rejectMint(uint256 nonce, uint256 reason)
1103         external 
1104         onlyValidator 
1105         checkIsAddressValid(pendingMints[nonce].to)
1106     {
1107         rejectedMintBalance[pendingMints[nonce].to] = rejectedMintBalance[pendingMints[nonce].to].add(pendingMints[nonce].weiAmount);
1108         
1109         emit MintRejected(
1110             pendingMints[nonce].to,
1111             pendingMints[nonce].tokens,
1112             pendingMints[nonce].weiAmount,
1113             nonce,
1114             reason
1115         );
1116         
1117         delete pendingMints[nonce];
1118     }
1119 
1120     /** @dev claim back ether if buy tokens request is rejected */
1121     function claim() external {
1122         require(rejectedMintBalance[msg.sender] > 0);
1123         uint256 value = rejectedMintBalance[msg.sender];
1124         rejectedMintBalance[msg.sender] = 0;
1125 
1126         msg.sender.transfer(value);
1127 
1128         emit Claimed(msg.sender, value);
1129     }
1130 
1131     function finalization() internal {
1132         token.finishMinting();
1133         transferTokenOwnership(owner);
1134         super.finalization();
1135     }
1136 
1137     /** @dev Updates token contract address
1138       * @param newToken New token contract address
1139       */
1140     function setTokenContract(address newToken)
1141         external 
1142         onlyOwner
1143         checkIsAddressValid(newToken)
1144     {
1145         token = CompliantToken(newToken);
1146     }
1147 
1148     /** @dev transfers ownership of the token contract
1149       * @param newOwner New owner of the token contract
1150       */
1151     function transferTokenOwnership(address newOwner)
1152         public 
1153         onlyOwner
1154         checkIsAddressValid(newOwner)
1155     {
1156         token.transferOwnership(newOwner);
1157     }
1158 
1159     function forwardFunds(uint256 amount) internal {
1160         wallet.transfer(amount);
1161     }
1162 }