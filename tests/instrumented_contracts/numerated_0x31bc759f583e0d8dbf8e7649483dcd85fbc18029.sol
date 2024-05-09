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
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   /**
54   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78     address public owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84     * account.
85     */
86     constructor(address _owner) public {
87         owner = _owner;
88     }
89 
90     /**
91     * @dev Throws if called by any account other than the owner.
92     */
93     modifier onlyOwner() {
94         require(msg.sender == owner);
95         _;
96     }
97 
98     /**
99     * @dev Allows the current owner to transfer control of the contract to a newOwner.
100     * @param newOwner The address to transfer ownership to.
101     */
102     function transferOwnership(address newOwner) public onlyOwner {
103         require(newOwner != address(0));
104         emit OwnershipTransferred(owner, newOwner);
105         owner = newOwner;
106     }
107 
108 }
109 
110 
111 contract Whitelist is Ownable {
112     mapping(address => bool) internal investorMap;
113 
114     /**
115     * event for investor approval logging
116     * @param investor approved investor
117     */
118     event Approved(address indexed investor);
119 
120     /**
121     * event for investor disapproval logging
122     * @param investor disapproved investor
123     */
124     event Disapproved(address indexed investor);
125 
126     constructor(address _owner) 
127         public 
128         Ownable(_owner) 
129     {
130         
131     }
132 
133     /** @param _investor the address of investor to be checked
134       * @return true if investor is approved
135       */
136     function isInvestorApproved(address _investor) external view returns (bool) {
137         require(_investor != address(0));
138         return investorMap[_investor];
139     }
140 
141     /** @dev approve an investor
142       * @param toApprove investor to be approved
143       */
144     function approveInvestor(address toApprove) external onlyOwner {
145         investorMap[toApprove] = true;
146         emit Approved(toApprove);
147     }
148 
149     /** @dev approve investors in bulk
150       * @param toApprove array of investors to be approved
151       */
152     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
153         for (uint i = 0; i < toApprove.length; i++) {
154             investorMap[toApprove[i]] = true;
155             emit Approved(toApprove[i]);
156         }
157     }
158 
159     /** @dev disapprove an investor
160       * @param toDisapprove investor to be disapproved
161       */
162     function disapproveInvestor(address toDisapprove) external onlyOwner {
163         delete investorMap[toDisapprove];
164         emit Disapproved(toDisapprove);
165     }
166 
167     /** @dev disapprove investors in bulk
168       * @param toDisapprove array of investors to be disapproved
169       */
170     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
171         for (uint i = 0; i < toDisapprove.length; i++) {
172             delete investorMap[toDisapprove[i]];
173             emit Disapproved(toDisapprove[i]);
174         }
175     }
176 }
177 
178 
179 /**
180  * @title Validator
181  * @dev The Validator contract has a validator address, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Validator {
185     address public validator;
186 
187     /**
188     * event for validator address update logging
189     * @param previousOwner address of the old validator
190     * @param newValidator address of the new validator
191     */
192     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
193 
194     /**
195     * @dev The Validator constructor sets the original `validator` of the contract to the sender
196     * account.
197     */
198     constructor() public {
199         validator = msg.sender;
200     }
201 
202     /**
203     * @dev Throws if called by any account other than the validator.
204     */
205     modifier onlyValidator() {
206         require(msg.sender == validator);
207         _;
208     }
209 
210     /**
211     * @dev Allows the current validator to transfer control of the contract to a newValidator.
212     * @param newValidator The address to become next validator.
213     */
214     function setNewValidator(address newValidator) public onlyValidator {
215         require(newValidator != address(0));
216         emit NewValidatorSet(validator, newValidator);
217         validator = newValidator;
218     }
219 }
220 
221 
222 /**
223  * @title ERC20Basic
224  * @dev Simpler version of ERC20 interface
225  * @dev see https://github.com/ethereum/EIPs/issues/179
226  */
227 contract ERC20Basic {
228   function totalSupply() public view returns (uint256);
229   function balanceOf(address who) public view returns (uint256);
230   function transfer(address to, uint256 value) public returns (bool);
231   event Transfer(address indexed from, address indexed to, uint256 value);
232 }
233 
234 
235 /**
236  * @title ERC20 interface
237  * @dev see https://github.com/ethereum/EIPs/issues/20
238  */
239 contract ERC20 is ERC20Basic {
240   function allowance(address owner, address spender) public view returns (uint256);
241   function transferFrom(address from, address to, uint256 value) public returns (bool);
242   function approve(address spender, uint256 value) public returns (bool);
243   event Approval(address indexed owner, address indexed spender, uint256 value);
244 }
245 
246 
247 /**
248  * @title Basic token
249  * @dev Basic version of StandardToken, with no allowances.
250  */
251 contract BasicToken is ERC20Basic {
252   using SafeMath for uint256;
253 
254   mapping(address => uint256) balances;
255 
256   uint256 totalSupply_;
257 
258   /**
259   * @dev total number of tokens in existence
260   */
261   function totalSupply() public view returns (uint256) {
262     return totalSupply_;
263   }
264 
265   /**
266   * @dev transfer token for a specified address
267   * @param _to The address to transfer to.
268   * @param _value The amount to be transferred.
269   */
270   function transfer(address _to, uint256 _value) public returns (bool) {
271     require(_to != address(0));
272     require(_value <= balances[msg.sender]);
273 
274     // SafeMath.sub will throw if there is not enough balance.
275     balances[msg.sender] = balances[msg.sender].sub(_value);
276     balances[_to] = balances[_to].add(_value);
277     emit Transfer(msg.sender, _to, _value);
278     return true;
279   }
280 
281   /**
282   * @dev Gets the balance of the specified address.
283   * @param _owner The address to query the the balance of.
284   * @return An uint256 representing the amount owned by the passed address.
285   */
286   function balanceOf(address _owner) public view returns (uint256 balance) {
287     return balances[_owner];
288   }
289 
290 }
291 
292 
293 /**
294  * @title Standard ERC20 token
295  *
296  * @dev Implementation of the basic standard token.
297  * @dev https://github.com/ethereum/EIPs/issues/20
298  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
299  */
300 contract StandardToken is ERC20, BasicToken {
301 
302   mapping (address => mapping (address => uint256)) internal allowed;
303 
304 
305   /**
306    * @dev Transfer tokens from one address to another
307    * @param _from address The address which you want to send tokens from
308    * @param _to address The address which you want to transfer to
309    * @param _value uint256 the amount of tokens to be transferred
310    */
311   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
312     require(_to != address(0));
313     require(_value <= balances[_from]);
314     require(_value <= allowed[_from][msg.sender]);
315 
316     balances[_from] = balances[_from].sub(_value);
317     balances[_to] = balances[_to].add(_value);
318     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
319     emit Transfer(_from, _to, _value);
320     return true;
321   }
322 
323   /**
324    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
325    *
326    * Beware that changing an allowance with this method brings the risk that someone may use both the old
327    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
328    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
329    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
330    * @param _spender The address which will spend the funds.
331    * @param _value The amount of tokens to be spent.
332    */
333   function approve(address _spender, uint256 _value) public returns (bool) {
334     allowed[msg.sender][_spender] = _value;
335     emit Approval(msg.sender, _spender, _value);
336     return true;
337   }
338 
339   /**
340    * @dev Function to check the amount of tokens that an owner allowed to a spender.
341    * @param _owner address The address which owns the funds.
342    * @param _spender address The address which will spend the funds.
343    * @return A uint256 specifying the amount of tokens still available for the spender.
344    */
345   function allowance(address _owner, address _spender) public view returns (uint256) {
346     return allowed[_owner][_spender];
347   }
348 
349   /**
350    * @dev Increase the amount of tokens that an owner allowed to a spender.
351    *
352    * approve should be called when allowed[_spender] == 0. To increment
353    * allowed value is better to use this function to avoid 2 calls (and wait until
354    * the first transaction is mined)
355    * From MonolithDAO Token.sol
356    * @param _spender The address which will spend the funds.
357    * @param _addedValue The amount of tokens to increase the allowance by.
358    */
359   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
360     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365   /**
366    * @dev Decrease the amount of tokens that an owner allowed to a spender.
367    *
368    * approve should be called when allowed[_spender] == 0. To decrement
369    * allowed value is better to use this function to avoid 2 calls (and wait until
370    * the first transaction is mined)
371    * From MonolithDAO Token.sol
372    * @param _spender The address which will spend the funds.
373    * @param _subtractedValue The amount of tokens to decrease the allowance by.
374    */
375   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
376     uint oldValue = allowed[msg.sender][_spender];
377     if (_subtractedValue > oldValue) {
378       allowed[msg.sender][_spender] = 0;
379     } else {
380       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
381     }
382     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
383     return true;
384   }
385 
386 }
387 
388 
389 /**
390  * @title Mintable token
391  * @dev Simple ERC20 Token example, with mintable token creation
392  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
393  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
394  */
395 contract MintableToken is StandardToken, Ownable {
396     event Mint(address indexed to, uint256 amount);
397     event MintFinished();
398 
399     bool public mintingFinished = false;
400 
401 
402     modifier canMint() {
403         require(!mintingFinished);
404         _;
405     }
406 
407     constructor(address _owner) 
408         public 
409         Ownable(_owner) 
410     {
411 
412     }
413 
414     /**
415     * @dev Function to mint tokens
416     * @param _to The address that will receive the minted tokens.
417     * @param _amount The amount of tokens to mint.
418     * @return A boolean that indicates if the operation was successful.
419     */
420     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
421         totalSupply_ = totalSupply_.add(_amount);
422         balances[_to] = balances[_to].add(_amount);
423         emit Mint(_to, _amount);
424         emit Transfer(address(0), _to, _amount);
425         return true;
426     }
427 
428     /**
429     * @dev Function to stop minting new tokens.
430     * @return True if the operation was successful.
431     */
432     function finishMinting() onlyOwner canMint public returns (bool) {
433         mintingFinished = true;
434         emit MintFinished();
435         return true;
436     }
437 }
438 
439 
440 contract DetailedERC20 {
441   string public name;
442   string public symbol;
443   uint8 public decimals;
444 
445   constructor(string _name, string _symbol, uint8 _decimals) public {
446     name = _name;
447     symbol = _symbol;
448     decimals = _decimals;
449   }
450 }
451 
452 
453 /** @title Compliant Token */
454 contract CompliantToken is Validator, DetailedERC20, MintableToken {
455     Whitelist public whiteListingContract;
456 
457     struct TransactionStruct {
458         address from;
459         address to;
460         uint256 value;
461         uint256 fee;
462         address spender;
463     }
464 
465     mapping (uint => TransactionStruct) public pendingTransactions;
466     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
467     uint256 public currentNonce = 0;
468     uint256 public transferFee;
469     address public feeRecipient;
470 
471     modifier checkIsInvestorApproved(address _account) {
472         require(whiteListingContract.isInvestorApproved(_account));
473         _;
474     }
475 
476     modifier checkIsAddressValid(address _account) {
477         require(_account != address(0));
478         _;
479     }
480 
481     modifier checkIsValueValid(uint256 _value) {
482         require(_value > 0);
483         _;
484     }
485 
486     /**
487     * event for rejected transfer logging
488     * @param from address from which tokens have to be transferred
489     * @param to address to tokens have to be transferred
490     * @param value number of tokens
491     * @param nonce request recorded at this particular nonce
492     * @param reason reason for rejection
493     */
494     event TransferRejected(
495         address indexed from,
496         address indexed to,
497         uint256 value,
498         uint256 indexed nonce,
499         uint256 reason
500     );
501 
502     /**
503     * event for transfer tokens logging
504     * @param from address from which tokens have to be transferred
505     * @param to address to tokens have to be transferred
506     * @param value number of tokens
507     * @param fee fee in tokens
508     */
509     event TransferWithFee(
510         address indexed from,
511         address indexed to,
512         uint256 value,
513         uint256 fee
514     );
515 
516     /**
517     * event for transfer/transferFrom request logging
518     * @param from address from which tokens have to be transferred
519     * @param to address to tokens have to be transferred
520     * @param value number of tokens
521     * @param fee fee in tokens
522     * @param spender The address which will spend the tokens
523     */
524     event RecordedPendingTransaction(
525         address indexed from,
526         address indexed to,
527         uint256 value,
528         uint256 fee,
529         address indexed spender
530     );
531 
532     /**
533     * event for whitelist contract update logging
534     * @param _whiteListingContract address of the new whitelist contract
535     */
536     event WhiteListingContractSet(address indexed _whiteListingContract);
537 
538     /**
539     * event for fee update logging
540     * @param previousFee previous fee
541     * @param newFee new fee
542     */
543     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
544 
545     /**
546     * event for fee recipient update logging
547     * @param previousRecipient address of the old fee recipient
548     * @param newRecipient address of the new fee recipient
549     */
550     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
551 
552     /** @dev Constructor
553       * @param _owner Token contract owner
554       * @param _name Token name
555       * @param _symbol Token symbol
556       * @param _decimals number of decimals in the token(usually 18)
557       * @param whitelistAddress Ethereum address of the whitelist contract
558       * @param recipient Ethereum address of the fee recipient
559       * @param fee token fee for approving a transfer
560       */
561     constructor(
562         address _owner,
563         string _name, 
564         string _symbol, 
565         uint8 _decimals,
566         address whitelistAddress,
567         address recipient,
568         uint256 fee
569     )
570         public
571         MintableToken(_owner)
572         DetailedERC20(_name, _symbol, _decimals)
573         Validator()
574     {
575         setWhitelistContract(whitelistAddress);
576         setFeeRecipient(recipient);
577         setFee(fee);
578     }
579 
580     /** @dev Updates whitelist contract address
581       * @param whitelistAddress New whitelist contract address
582       */
583     function setWhitelistContract(address whitelistAddress)
584         public
585         onlyValidator
586         checkIsAddressValid(whitelistAddress)
587     {
588         whiteListingContract = Whitelist(whitelistAddress);
589         emit WhiteListingContractSet(whiteListingContract);
590     }
591 
592     /** @dev Updates token fee for approving a transfer
593       * @param fee New token fee
594       */
595     function setFee(uint256 fee)
596         public
597         onlyValidator
598     {
599         emit FeeSet(transferFee, fee);
600         transferFee = fee;
601     }
602 
603     /** @dev Updates fee recipient address
604       * @param recipient New whitelist contract address
605       */
606     function setFeeRecipient(address recipient)
607         public
608         onlyValidator
609         checkIsAddressValid(recipient)
610     {
611         emit FeeRecipientSet(feeRecipient, recipient);
612         feeRecipient = recipient;
613     }
614 
615     /** @dev Updates token name
616       * @param _name New token name
617       */
618     function updateName(string _name) public onlyOwner {
619         require(bytes(_name).length != 0);
620         name = _name;
621     }
622 
623     /** @dev Updates token symbol
624       * @param _symbol New token name
625       */
626     function updateSymbol(string _symbol) public onlyOwner {
627         require(bytes(_symbol).length != 0);
628         symbol = _symbol;
629     }
630 
631     /** @dev transfer request
632       * @param _to address to which the tokens have to be transferred
633       * @param _value amount of tokens to be transferred
634       */
635     function transfer(address _to, uint256 _value)
636         public
637         checkIsInvestorApproved(msg.sender)
638         checkIsInvestorApproved(_to)
639         checkIsValueValid(_value)
640         returns (bool)
641     {
642         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
643 
644         if (msg.sender == feeRecipient) {
645             require(_value.add(pendingAmount) <= balances[msg.sender]);
646             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
647         } else {
648             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
649             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
650         }
651 
652         pendingTransactions[currentNonce] = TransactionStruct(
653             msg.sender,
654             _to,
655             _value,
656             transferFee,
657             address(0)
658         );
659 
660         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
661         currentNonce++;
662 
663         return true;
664     }
665 
666     /** @dev transferFrom request
667       * @param _from address from which the tokens have to be transferred
668       * @param _to address to which the tokens have to be transferred
669       * @param _value amount of tokens to be transferred
670       */
671     function transferFrom(address _from, address _to, uint256 _value)
672         public 
673         checkIsInvestorApproved(_from)
674         checkIsInvestorApproved(_to)
675         checkIsValueValid(_value)
676         returns (bool)
677     {
678         uint256 allowedTransferAmount = allowed[_from][msg.sender];
679         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
680         
681         if (_from == feeRecipient) {
682             require(_value.add(pendingAmount) <= balances[_from]);
683             require(_value.add(pendingAmount) <= allowedTransferAmount);
684             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
685         } else {
686             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
687             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
688             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
689         }
690 
691         pendingTransactions[currentNonce] = TransactionStruct(
692             _from,
693             _to,
694             _value,
695             transferFee,
696             msg.sender
697         );
698 
699         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
700         currentNonce++;
701 
702         return true;
703     }
704 
705     /** @dev approve transfer/transferFrom request
706       * @param nonce request recorded at this particular nonce
707       */
708     function approveTransfer(uint256 nonce)
709         external 
710         onlyValidator 
711         checkIsInvestorApproved(pendingTransactions[nonce].from)
712         checkIsInvestorApproved(pendingTransactions[nonce].to)
713         checkIsValueValid(pendingTransactions[nonce].value)
714         returns (bool)
715     {   
716         address from = pendingTransactions[nonce].from;
717         address spender = pendingTransactions[nonce].spender;
718         address to = pendingTransactions[nonce].to;
719         uint256 value = pendingTransactions[nonce].value;
720         uint256 allowedTransferAmount = allowed[from][spender];
721         uint256 pendingAmount = pendingApprovalAmount[from][spender];
722         uint256 fee = pendingTransactions[nonce].fee;
723         uint256 balanceFrom = balances[from];
724         uint256 balanceTo = balances[to];
725 
726         delete pendingTransactions[nonce];
727 
728         if (from == feeRecipient) {
729             fee = 0;
730             balanceFrom = balanceFrom.sub(value);
731             balanceTo = balanceTo.add(value);
732 
733             if (spender != address(0)) {
734                 allowedTransferAmount = allowedTransferAmount.sub(value);
735             } 
736             pendingAmount = pendingAmount.sub(value);
737 
738         } else {
739             balanceFrom = balanceFrom.sub(value.add(fee));
740             balanceTo = balanceTo.add(value);
741             balances[feeRecipient] = balances[feeRecipient].add(fee);
742 
743             if (spender != address(0)) {
744                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
745             }
746             pendingAmount = pendingAmount.sub(value).sub(fee);
747         }
748 
749         emit TransferWithFee(
750             from,
751             to,
752             value,
753             fee
754         );
755 
756         emit Transfer(
757             from,
758             to,
759             value
760         );
761         
762         balances[from] = balanceFrom;
763         balances[to] = balanceTo;
764         allowed[from][spender] = allowedTransferAmount;
765         pendingApprovalAmount[from][spender] = pendingAmount;
766         return true;
767     }
768 
769     /** @dev reject transfer/transferFrom request
770       * @param nonce request recorded at this particular nonce
771       * @param reason reason for rejection
772       */
773     function rejectTransfer(uint256 nonce, uint256 reason)
774         external 
775         onlyValidator
776         checkIsAddressValid(pendingTransactions[nonce].from)
777     {        
778         address from = pendingTransactions[nonce].from;
779         address spender = pendingTransactions[nonce].spender;
780 
781         if (from == feeRecipient) {
782             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
783                 .sub(pendingTransactions[nonce].value);
784         } else {
785             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
786                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
787         }
788         
789         emit TransferRejected(
790             from,
791             pendingTransactions[nonce].to,
792             pendingTransactions[nonce].value,
793             nonce,
794             reason
795         );
796         
797         delete pendingTransactions[nonce];
798     }
799 }
800 
801 
802 /**
803  * @title Crowdsale
804  * @dev Crowdsale is a base contract for managing a token crowdsale.
805  * Crowdsales have a start and end timestamps, where investors can make
806  * token purchases and the crowdsale will assign them tokens based
807  * on a token per ETH rate. Funds collected are forwarded to a wallet
808  * as they arrive. The contract requires a MintableToken that will be
809  * minted as contributions arrive, note that the crowdsale contract
810  * must be owner of the token in order to be able to mint it.
811  */
812 contract Crowdsale {
813     using SafeMath for uint256;
814 
815     // The token being sold
816     MintableToken public token;
817 
818     // start and end timestamps where investments are allowed (both inclusive)
819     uint256 public startTime;
820     uint256 public endTime;
821 
822     // address where funds are collected
823     address public wallet;
824 
825     // how many token units a buyer gets per wei
826     uint256 public rate;
827 
828     // amount of raised money in wei
829     uint256 public weiRaised;
830 
831     /**
832     * event for token purchase logging
833     * @param purchaser who paid for the tokens
834     * @param beneficiary who got the tokens
835     * @param value weis paid for purchase
836     * @param amount amount of tokens purchased
837     */
838     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
839 
840 
841     constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public {
842         require(_startTime >= now);
843         require(_endTime >= _startTime);
844         require(_rate > 0);
845         require(_wallet != address(0));
846         require(_token != address(0));
847 
848         startTime = _startTime;
849         endTime = _endTime;
850         rate = _rate;
851         wallet = _wallet;
852         token = _token;
853     }
854 
855     /** @dev fallback function redirects to buy tokens */
856     function () external payable {
857         buyTokens(msg.sender);
858     }
859 
860     /** @dev buy tokens
861       * @param beneficiary the address to which the tokens have to be minted
862       */
863     function buyTokens(address beneficiary) public payable {
864         require(beneficiary != address(0));
865         require(validPurchase());
866 
867         uint256 weiAmount = msg.value;
868 
869         // calculate token amount to be created
870         uint256 tokens = getTokenAmount(weiAmount);
871 
872         // update state
873         weiRaised = weiRaised.add(weiAmount);
874 
875         token.mint(beneficiary, tokens);
876         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
877 
878         forwardFunds();
879     }
880 
881     /** @return true if crowdsale event has ended */
882     function hasEnded() public view returns (bool) {
883         return now > endTime;
884     }
885 
886     // Override this method to have a way to add business logic to your crowdsale when buying
887     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
888         return weiAmount.mul(rate);
889     }
890 
891     // send ether to the fund collection wallet
892     // override to create custom fund forwarding mechanisms
893     function forwardFunds() internal {
894         wallet.transfer(msg.value);
895     }
896 
897     // @return true if the transaction can buy tokens
898     function validPurchase() internal view returns (bool) {
899         bool withinPeriod = now >= startTime && now <= endTime;
900         bool nonZeroPurchase = msg.value != 0;
901         return withinPeriod && nonZeroPurchase;
902     }
903 
904 }
905 
906 
907 /**
908  * @title FinalizableCrowdsale
909  * @dev Extension of Crowdsale where an owner can do extra work
910  * after finishing.
911  */
912 contract FinalizableCrowdsale is Crowdsale, Ownable {
913     using SafeMath for uint256;
914 
915     bool public isFinalized = false;
916 
917     event Finalized();
918  
919     constructor(address _owner) public Ownable(_owner) {}
920 
921     /**
922     * @dev Must be called after crowdsale ends, to do some extra finalization
923     * work. Calls the contract's finalization function.
924     */
925     function finalize() onlyOwner public {
926         require(!isFinalized);
927         require(hasEnded());
928 
929         finalization();
930         emit Finalized();
931 
932         isFinalized = true;
933     }
934 
935     /**
936     * @dev Can be overridden to add finalization logic. The overriding function
937     * should call super.finalization() to ensure the chain of finalization is
938     * executed entirely.
939     */
940     function finalization() internal {}
941 }
942 
943 
944 /** @title Compliant Crowdsale */
945 contract CompliantCrowdsale is Validator, FinalizableCrowdsale {
946     Whitelist public whiteListingContract;
947 
948     struct MintStruct {
949         address to;
950         uint256 tokens;
951         uint256 weiAmount;
952     }
953 
954     mapping (uint => MintStruct) public pendingMints;
955     uint256 public currentMintNonce;
956     mapping (address => uint) public rejectedMintBalance;
957 
958     modifier checkIsInvestorApproved(address _account) {
959         require(whiteListingContract.isInvestorApproved(_account));
960         _;
961     }
962 
963     modifier checkIsAddressValid(address _account) {
964         require(_account != address(0));
965         _;
966     }
967 
968     /**
969     * event for rejected mint logging
970     * @param to address for which buy tokens got rejected
971     * @param value number of tokens
972     * @param amount number of ethers invested
973     * @param nonce request recorded at this particular nonce
974     * @param reason reason for rejection
975     */
976     event MintRejected(
977         address indexed to,
978         uint256 value,
979         uint256 amount,
980         uint256 indexed nonce,
981         uint256 reason
982     );
983 
984     /**
985     * event for buy tokens request logging
986     * @param beneficiary address for which buy tokens is requested
987     * @param tokens number of tokens
988     * @param weiAmount number of ethers invested
989     * @param nonce request recorded at this particular nonce
990     */
991     event ContributionRegistered(
992         address beneficiary,
993         uint256 tokens,
994         uint256 weiAmount,
995         uint256 nonce
996     );
997 
998     /**
999     * event for whitelist contract update logging
1000     * @param _whiteListingContract address of the new whitelist contract
1001     */
1002     event WhiteListingContractSet(address indexed _whiteListingContract);
1003 
1004     /**
1005     * event for claimed ether logging
1006     * @param account user claiming the ether
1007     * @param amount ether claimed
1008     */
1009     event Claimed(address indexed account, uint256 amount);
1010 
1011     /** @dev Constructor
1012       * @param whitelistAddress Ethereum address of the whitelist contract
1013       * @param _startTime crowdsale start time
1014       * @param _endTime crowdsale end time
1015       * @param _rate number of tokens to be sold per ether
1016       * @param _wallet Ethereum address of the wallet
1017       * @param _token Ethereum address of the token contract
1018       * @param _owner Ethereum address of the owner
1019       */
1020     constructor(
1021         address whitelistAddress,
1022         uint256 _startTime,
1023         uint256 _endTime,
1024         uint256 _rate,
1025         address _wallet,
1026         MintableToken _token,
1027         address _owner
1028     )
1029         public
1030         FinalizableCrowdsale(_owner)
1031         Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
1032     {
1033         setWhitelistContract(whitelistAddress);
1034     }
1035 
1036     /** @dev Updates whitelist contract address
1037       * @param whitelistAddress address of the new whitelist contract 
1038       */
1039     function setWhitelistContract(address whitelistAddress)
1040         public 
1041         onlyValidator 
1042         checkIsAddressValid(whitelistAddress)
1043     {
1044         whiteListingContract = Whitelist(whitelistAddress);
1045         emit WhiteListingContractSet(whiteListingContract);
1046     }
1047 
1048     /** @dev buy tokens request
1049       * @param beneficiary the address to which the tokens have to be minted
1050       */
1051     function buyTokens(address beneficiary)
1052         public 
1053         payable
1054         checkIsInvestorApproved(beneficiary)
1055     {
1056         require(validPurchase());
1057 
1058         uint256 weiAmount = msg.value;
1059 
1060         // calculate token amount to be created
1061         uint256 tokens = weiAmount.mul(rate);
1062 
1063         pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount);
1064         emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce);
1065 
1066         currentMintNonce++;
1067     }
1068 
1069     /** @dev approve buy tokens request
1070       * @param nonce request recorded at this particular nonce
1071       */
1072     function approveMint(uint256 nonce)
1073         external 
1074         onlyValidator 
1075         checkIsInvestorApproved(pendingMints[nonce].to)
1076         returns (bool)
1077     {
1078         // update state
1079         weiRaised = weiRaised.add(pendingMints[nonce].weiAmount);
1080 
1081         //No need to use mint-approval on token side, since the minting is already approved in the crowdsale side
1082         token.mint(pendingMints[nonce].to, pendingMints[nonce].tokens);
1083         
1084         emit TokenPurchase(
1085             msg.sender,
1086             pendingMints[nonce].to,
1087             pendingMints[nonce].weiAmount,
1088             pendingMints[nonce].tokens
1089         );
1090 
1091         forwardFunds(pendingMints[nonce].weiAmount);
1092         delete pendingMints[nonce];
1093 
1094         return true;
1095     }
1096 
1097     /** @dev reject buy tokens request
1098       * @param nonce request recorded at this particular nonce
1099       * @param reason reason for rejection
1100       */
1101     function rejectMint(uint256 nonce, uint256 reason)
1102         external 
1103         onlyValidator 
1104         checkIsAddressValid(pendingMints[nonce].to)
1105     {
1106         rejectedMintBalance[pendingMints[nonce].to] = rejectedMintBalance[pendingMints[nonce].to].add(pendingMints[nonce].weiAmount);
1107         
1108         emit MintRejected(
1109             pendingMints[nonce].to,
1110             pendingMints[nonce].tokens,
1111             pendingMints[nonce].weiAmount,
1112             nonce,
1113             reason
1114         );
1115         
1116         delete pendingMints[nonce];
1117     }
1118 
1119     /** @dev claim back ether if buy tokens request is rejected */
1120     function claim() external {
1121         require(rejectedMintBalance[msg.sender] > 0);
1122         uint256 value = rejectedMintBalance[msg.sender];
1123         rejectedMintBalance[msg.sender] = 0;
1124 
1125         msg.sender.transfer(value);
1126 
1127         emit Claimed(msg.sender, value);
1128     }
1129 
1130     function finalization() internal {
1131         token.finishMinting();
1132         transferTokenOwnership(owner);
1133         super.finalization();
1134     }
1135 
1136     /** @dev Updates token contract address
1137       * @param newToken New token contract address
1138       */
1139     function setTokenContract(address newToken)
1140         external 
1141         onlyOwner
1142         checkIsAddressValid(newToken)
1143     {
1144         token = CompliantToken(newToken);
1145     }
1146 
1147     /** @dev transfers ownership of the token contract
1148       * @param newOwner New owner of the token contract
1149       */
1150     function transferTokenOwnership(address newOwner)
1151         public 
1152         onlyOwner
1153         checkIsAddressValid(newOwner)
1154     {
1155         token.transferOwnership(newOwner);
1156     }
1157 
1158     function forwardFunds(uint256 amount) internal {
1159         wallet.transfer(amount);
1160     }
1161 }