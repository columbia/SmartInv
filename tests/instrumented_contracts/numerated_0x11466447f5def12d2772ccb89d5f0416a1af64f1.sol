1 pragma solidity 0.4.24;
2 //
3 //
4 //
5 //used Wallet of ACcount 179//
6 //
7 //
8 //
9 //
10 //
11 //
12 //testing 2nd company
13 //demo
14 //wallet2
15 //new ICO Sep28
16 //company_2
17 //DefaultOffer
18 //new for company_2
19 //FOR PRODUCTION
20 //New Offer
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   /**
51   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     address public owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     /**
80     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81     * account.
82     */
83     constructor(address _owner) public {
84         owner = _owner;
85     }
86 
87     /**
88     * @dev Throws if called by any account other than the owner.
89     */
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94 
95     /**
96     * @dev Allows the current owner to transfer control of the contract to a newOwner.
97     * @param newOwner The address to transfer ownership to.
98     */
99     function transferOwnership(address newOwner) public onlyOwner {
100         require(newOwner != address(0));
101         emit OwnershipTransferred(owner, newOwner);
102         owner = newOwner;
103     }
104 
105 }
106 
107 
108 contract Whitelist is Ownable {
109     mapping(address => bool) internal investorMap;
110 
111     /**
112     * event for investor approval logging
113     * @param investor approved investor
114     */
115     event Approved(address indexed investor);
116 
117     /**
118     * event for investor disapproval logging
119     * @param investor disapproved investor
120     */
121     event Disapproved(address indexed investor);
122 
123     constructor(address _owner) 
124         public 
125         Ownable(_owner) 
126     {
127         
128     }
129 
130     /** @param _investor the address of investor to be checked
131       * @return true if investor is approved
132       */
133     function isInvestorApproved(address _investor) external view returns (bool) {
134         require(_investor != address(0));
135         return investorMap[_investor];
136     }
137 
138     /** @dev approve an investor
139       * @param toApprove investor to be approved
140       */
141     function approveInvestor(address toApprove) external onlyOwner {
142         investorMap[toApprove] = true;
143         emit Approved(toApprove);
144     }
145 
146     /** @dev approve investors in bulk
147       * @param toApprove array of investors to be approved
148       */
149     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
150         for (uint i = 0; i < toApprove.length; i++) {
151             investorMap[toApprove[i]] = true;
152             emit Approved(toApprove[i]);
153         }
154     }
155 
156     /** @dev disapprove an investor
157       * @param toDisapprove investor to be disapproved
158       */
159     function disapproveInvestor(address toDisapprove) external onlyOwner {
160         delete investorMap[toDisapprove];
161         emit Disapproved(toDisapprove);
162     }
163 
164     /** @dev disapprove investors in bulk
165       * @param toDisapprove array of investors to be disapproved
166       */
167     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
168         for (uint i = 0; i < toDisapprove.length; i++) {
169             delete investorMap[toDisapprove[i]];
170             emit Disapproved(toDisapprove[i]);
171         }
172     }
173 }
174 
175 
176 /**
177  * @title Validator
178  * @dev The Validator contract has a validator address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Validator {
182     address public validator;
183 
184     /**
185     * event for validator address update logging
186     * @param previousOwner address of the old validator
187     * @param newValidator address of the new validator
188     */
189     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
190 
191     /**
192     * @dev The Validator constructor sets the original `validator` of the contract to the sender
193     * account.
194     */
195     constructor() public {
196         validator = msg.sender;
197     }
198 
199     /**
200     * @dev Throws if called by any account other than the validator.
201     */
202     modifier onlyValidator() {
203         require(msg.sender == validator);
204         _;
205     }
206 
207     /**
208     * @dev Allows the current validator to transfer control of the contract to a newValidator.
209     * @param newValidator The address to become next validator.
210     */
211     function setNewValidator(address newValidator) public onlyValidator {
212         require(newValidator != address(0));
213         emit NewValidatorSet(validator, newValidator);
214         validator = newValidator;
215     }
216 }
217 
218 
219 /**
220  * @title ERC20Basic
221  * @dev Simpler version of ERC20 interface
222  * @dev see https://github.com/ethereum/EIPs/issues/179
223  */
224 contract ERC20Basic {
225   function totalSupply() public view returns (uint256);
226   function balanceOf(address who) public view returns (uint256);
227   function transfer(address to, uint256 value) public returns (bool);
228   event Transfer(address indexed from, address indexed to, uint256 value);
229 }
230 
231 
232 /**
233  * @title ERC20 interface
234  * @dev see https://github.com/ethereum/EIPs/issues/20
235  */
236 contract ERC20 is ERC20Basic {
237   function allowance(address owner, address spender) public view returns (uint256);
238   function transferFrom(address from, address to, uint256 value) public returns (bool);
239   function approve(address spender, uint256 value) public returns (bool);
240   event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 
244 /**
245  * @title Basic token
246  * @dev Basic version of StandardToken, with no allowances.
247  */
248 contract BasicToken is ERC20Basic {
249   using SafeMath for uint256;
250 
251   mapping(address => uint256) balances;
252 
253   uint256 totalSupply_;
254 
255   /**
256   * @dev total number of tokens in existence
257   */
258   function totalSupply() public view returns (uint256) {
259     return totalSupply_;
260   }
261 
262   /**
263   * @dev transfer token for a specified address
264   * @param _to The address to transfer to.
265   * @param _value The amount to be transferred.
266   */
267   function transfer(address _to, uint256 _value) public returns (bool) {
268     require(_to != address(0));
269     require(_value <= balances[msg.sender]);
270 
271     // SafeMath.sub will throw if there is not enough balance.
272     balances[msg.sender] = balances[msg.sender].sub(_value);
273     balances[_to] = balances[_to].add(_value);
274     emit Transfer(msg.sender, _to, _value);
275     return true;
276   }
277 
278   /**
279   * @dev Gets the balance of the specified address.
280   * @param _owner The address to query the the balance of.
281   * @return An uint256 representing the amount owned by the passed address.
282   */
283   function balanceOf(address _owner) public view returns (uint256 balance) {
284     return balances[_owner];
285   }
286 
287 }
288 
289 
290 /**
291  * @title Standard ERC20 token
292  *
293  * @dev Implementation of the basic standard token.
294  * @dev https://github.com/ethereum/EIPs/issues/20
295  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
296  */
297 contract StandardToken is ERC20, BasicToken {
298 
299   mapping (address => mapping (address => uint256)) internal allowed;
300 
301 
302   /**
303    * @dev Transfer tokens from one address to another
304    * @param _from address The address which you want to send tokens from
305    * @param _to address The address which you want to transfer to
306    * @param _value uint256 the amount of tokens to be transferred
307    */
308   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
309     require(_to != address(0));
310     require(_value <= balances[_from]);
311     require(_value <= allowed[_from][msg.sender]);
312 
313     balances[_from] = balances[_from].sub(_value);
314     balances[_to] = balances[_to].add(_value);
315     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
316     emit Transfer(_from, _to, _value);
317     return true;
318   }
319 
320   /**
321    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
322    *
323    * Beware that changing an allowance with this method brings the risk that someone may use both the old
324    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
325    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
326    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
327    * @param _spender The address which will spend the funds.
328    * @param _value The amount of tokens to be spent.
329    */
330   function approve(address _spender, uint256 _value) public returns (bool) {
331     allowed[msg.sender][_spender] = _value;
332     emit Approval(msg.sender, _spender, _value);
333     return true;
334   }
335 
336   /**
337    * @dev Function to check the amount of tokens that an owner allowed to a spender.
338    * @param _owner address The address which owns the funds.
339    * @param _spender address The address which will spend the funds.
340    * @return A uint256 specifying the amount of tokens still available for the spender.
341    */
342   function allowance(address _owner, address _spender) public view returns (uint256) {
343     return allowed[_owner][_spender];
344   }
345 
346   /**
347    * @dev Increase the amount of tokens that an owner allowed to a spender.
348    *
349    * approve should be called when allowed[_spender] == 0. To increment
350    * allowed value is better to use this function to avoid 2 calls (and wait until
351    * the first transaction is mined)
352    * From MonolithDAO Token.sol
353    * @param _spender The address which will spend the funds.
354    * @param _addedValue The amount of tokens to increase the allowance by.
355    */
356   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
357     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
358     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359     return true;
360   }
361 
362   /**
363    * @dev Decrease the amount of tokens that an owner allowed to a spender.
364    *
365    * approve should be called when allowed[_spender] == 0. To decrement
366    * allowed value is better to use this function to avoid 2 calls (and wait until
367    * the first transaction is mined)
368    * From MonolithDAO Token.sol
369    * @param _spender The address which will spend the funds.
370    * @param _subtractedValue The amount of tokens to decrease the allowance by.
371    */
372   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
373     uint oldValue = allowed[msg.sender][_spender];
374     if (_subtractedValue > oldValue) {
375       allowed[msg.sender][_spender] = 0;
376     } else {
377       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
378     }
379     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
380     return true;
381   }
382 
383 }
384 
385 
386 /**
387  * @title Mintable token
388  * @dev Simple ERC20 Token example, with mintable token creation
389  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
390  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
391  */
392 contract MintableToken is StandardToken, Ownable {
393     event Mint(address indexed to, uint256 amount);
394     event MintFinished();
395 
396     bool public mintingFinished = false;
397 
398 
399     modifier canMint() {
400         require(!mintingFinished);
401         _;
402     }
403 
404     constructor(address _owner) 
405         public 
406         Ownable(_owner) 
407     {
408 
409     }
410 
411     /**
412     * @dev Function to mint tokens
413     * @param _to The address that will receive the minted tokens.
414     * @param _amount The amount of tokens to mint.
415     * @return A boolean that indicates if the operation was successful.
416     */
417     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
418         totalSupply_ = totalSupply_.add(_amount);
419         balances[_to] = balances[_to].add(_amount);
420         emit Mint(_to, _amount);
421         emit Transfer(address(0), _to, _amount);
422         return true;
423     }
424 
425     /**
426     * @dev Function to stop minting new tokens.
427     * @return True if the operation was successful.
428     */
429     function finishMinting() onlyOwner canMint public returns (bool) {
430         mintingFinished = true;
431         emit MintFinished();
432         return true;
433     }
434 }
435 
436 
437 contract DetailedERC20 {
438   string public name;
439   string public symbol;
440   uint8 public decimals;
441 
442   constructor(string _name, string _symbol, uint8 _decimals) public {
443     name = _name;
444     symbol = _symbol;
445     decimals = _decimals;
446   }
447 }
448 
449 
450 /** @title Compliant Token */
451 contract CompliantToken is Validator, DetailedERC20, MintableToken {
452     Whitelist public whiteListingContract;
453 
454     struct TransactionStruct {
455         address from;
456         address to;
457         uint256 value;
458         uint256 fee;
459         address spender;
460     }
461 
462     mapping (uint => TransactionStruct) public pendingTransactions;
463     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
464     uint256 public currentNonce = 0;
465     uint256 public transferFee;
466     address public feeRecipient;
467 
468     modifier checkIsInvestorApproved(address _account) {
469         require(whiteListingContract.isInvestorApproved(_account));
470         _;
471     }
472 
473     modifier checkIsAddressValid(address _account) {
474         require(_account != address(0));
475         _;
476     }
477 
478     modifier checkIsValueValid(uint256 _value) {
479         require(_value > 0);
480         _;
481     }
482 
483     /**
484     * event for rejected transfer logging
485     * @param from address from which tokens have to be transferred
486     * @param to address to tokens have to be transferred
487     * @param value number of tokens
488     * @param nonce request recorded at this particular nonce
489     * @param reason reason for rejection
490     */
491     event TransferRejected(
492         address indexed from,
493         address indexed to,
494         uint256 value,
495         uint256 indexed nonce,
496         uint256 reason
497     );
498 
499     /**
500     * event for transfer tokens logging
501     * @param from address from which tokens have to be transferred
502     * @param to address to tokens have to be transferred
503     * @param value number of tokens
504     * @param fee fee in tokens
505     */
506     event TransferWithFee(
507         address indexed from,
508         address indexed to,
509         uint256 value,
510         uint256 fee
511     );
512 
513     /**
514     * event for transfer/transferFrom request logging
515     * @param from address from which tokens have to be transferred
516     * @param to address to tokens have to be transferred
517     * @param value number of tokens
518     * @param fee fee in tokens
519     * @param spender The address which will spend the tokens
520     */
521     event RecordedPendingTransaction(
522         address indexed from,
523         address indexed to,
524         uint256 value,
525         uint256 fee,
526         address indexed spender
527     );
528 
529     /**
530     * event for whitelist contract update logging
531     * @param _whiteListingContract address of the new whitelist contract
532     */
533     event WhiteListingContractSet(address indexed _whiteListingContract);
534 
535     /**
536     * event for fee update logging
537     * @param previousFee previous fee
538     * @param newFee new fee
539     */
540     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
541 
542     /**
543     * event for fee recipient update logging
544     * @param previousRecipient address of the old fee recipient
545     * @param newRecipient address of the new fee recipient
546     */
547     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
548 
549     /** @dev Constructor
550       * @param _owner Token contract owner
551       * @param _name Token name
552       * @param _symbol Token symbol
553       * @param _decimals number of decimals in the token(usually 18)
554       * @param whitelistAddress Ethereum address of the whitelist contract
555       * @param recipient Ethereum address of the fee recipient
556       * @param fee token fee for approving a transfer
557       */
558     constructor(
559         address _owner,
560         string _name, 
561         string _symbol, 
562         uint8 _decimals,
563         address whitelistAddress,
564         address recipient,
565         uint256 fee
566     )
567         public
568         MintableToken(_owner)
569         DetailedERC20(_name, _symbol, _decimals)
570         Validator()
571     {
572         setWhitelistContract(whitelistAddress);
573         setFeeRecipient(recipient);
574         setFee(fee);
575     }
576 
577     /** @dev Updates whitelist contract address
578       * @param whitelistAddress New whitelist contract address
579       */
580     function setWhitelistContract(address whitelistAddress)
581         public
582         onlyValidator
583         checkIsAddressValid(whitelistAddress)
584     {
585         whiteListingContract = Whitelist(whitelistAddress);
586         emit WhiteListingContractSet(whiteListingContract);
587     }
588 
589     /** @dev Updates token fee for approving a transfer
590       * @param fee New token fee
591       */
592     function setFee(uint256 fee)
593         public
594         onlyValidator
595     {
596         emit FeeSet(transferFee, fee);
597         transferFee = fee;
598     }
599 
600     /** @dev Updates fee recipient address
601       * @param recipient New whitelist contract address
602       */
603     function setFeeRecipient(address recipient)
604         public
605         onlyValidator
606         checkIsAddressValid(recipient)
607     {
608         emit FeeRecipientSet(feeRecipient, recipient);
609         feeRecipient = recipient;
610     }
611 
612     /** @dev Updates token name
613       * @param _name New token name
614       */
615     function updateName(string _name) public onlyOwner {
616         require(bytes(_name).length != 0);
617         name = _name;
618     }
619 
620     /** @dev Updates token symbol
621       * @param _symbol New token name
622       */
623     function updateSymbol(string _symbol) public onlyOwner {
624         require(bytes(_symbol).length != 0);
625         symbol = _symbol;
626     }
627 
628     /** @dev transfer request
629       * @param _to address to which the tokens have to be transferred
630       * @param _value amount of tokens to be transferred
631       */
632     function transfer(address _to, uint256 _value)
633         public
634         checkIsInvestorApproved(msg.sender)
635         checkIsInvestorApproved(_to)
636         checkIsValueValid(_value)
637         returns (bool)
638     {
639         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
640 
641         if (msg.sender == feeRecipient) {
642             require(_value.add(pendingAmount) <= balances[msg.sender]);
643             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
644         } else {
645             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
646             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
647         }
648 
649         pendingTransactions[currentNonce] = TransactionStruct(
650             msg.sender,
651             _to,
652             _value,
653             transferFee,
654             address(0)
655         );
656 
657         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
658         currentNonce++;
659 
660         return true;
661     }
662 
663     /** @dev transferFrom request
664       * @param _from address from which the tokens have to be transferred
665       * @param _to address to which the tokens have to be transferred
666       * @param _value amount of tokens to be transferred
667       */
668     function transferFrom(address _from, address _to, uint256 _value)
669         public 
670         checkIsInvestorApproved(_from)
671         checkIsInvestorApproved(_to)
672         checkIsValueValid(_value)
673         returns (bool)
674     {
675         uint256 allowedTransferAmount = allowed[_from][msg.sender];
676         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
677         
678         if (_from == feeRecipient) {
679             require(_value.add(pendingAmount) <= balances[_from]);
680             require(_value.add(pendingAmount) <= allowedTransferAmount);
681             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
682         } else {
683             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
684             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
685             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
686         }
687 
688         pendingTransactions[currentNonce] = TransactionStruct(
689             _from,
690             _to,
691             _value,
692             transferFee,
693             msg.sender
694         );
695 
696         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
697         currentNonce++;
698 
699         return true;
700     }
701 
702     /** @dev approve transfer/transferFrom request
703       * @param nonce request recorded at this particular nonce
704       */
705     function approveTransfer(uint256 nonce)
706         external 
707         onlyValidator 
708         checkIsInvestorApproved(pendingTransactions[nonce].from)
709         checkIsInvestorApproved(pendingTransactions[nonce].to)
710         checkIsValueValid(pendingTransactions[nonce].value)
711         returns (bool)
712     {   
713         address from = pendingTransactions[nonce].from;
714         address spender = pendingTransactions[nonce].spender;
715         address to = pendingTransactions[nonce].to;
716         uint256 value = pendingTransactions[nonce].value;
717         uint256 allowedTransferAmount = allowed[from][spender];
718         uint256 pendingAmount = pendingApprovalAmount[from][spender];
719         uint256 fee = pendingTransactions[nonce].fee;
720         uint256 balanceFrom = balances[from];
721         uint256 balanceTo = balances[to];
722 
723         delete pendingTransactions[nonce];
724 
725         if (from == feeRecipient) {
726             fee = 0;
727             balanceFrom = balanceFrom.sub(value);
728             balanceTo = balanceTo.add(value);
729 
730             if (spender != address(0)) {
731                 allowedTransferAmount = allowedTransferAmount.sub(value);
732             } 
733             pendingAmount = pendingAmount.sub(value);
734 
735         } else {
736             balanceFrom = balanceFrom.sub(value.add(fee));
737             balanceTo = balanceTo.add(value);
738             balances[feeRecipient] = balances[feeRecipient].add(fee);
739 
740             if (spender != address(0)) {
741                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
742             }
743             pendingAmount = pendingAmount.sub(value).sub(fee);
744         }
745 
746         emit TransferWithFee(
747             from,
748             to,
749             value,
750             fee
751         );
752 
753         emit Transfer(
754             from,
755             to,
756             value
757         );
758         
759         balances[from] = balanceFrom;
760         balances[to] = balanceTo;
761         allowed[from][spender] = allowedTransferAmount;
762         pendingApprovalAmount[from][spender] = pendingAmount;
763         return true;
764     }
765 
766     /** @dev reject transfer/transferFrom request
767       * @param nonce request recorded at this particular nonce
768       * @param reason reason for rejection
769       */
770     function rejectTransfer(uint256 nonce, uint256 reason)
771         external 
772         onlyValidator
773         checkIsAddressValid(pendingTransactions[nonce].from)
774     {        
775         address from = pendingTransactions[nonce].from;
776         address spender = pendingTransactions[nonce].spender;
777 
778         if (from == feeRecipient) {
779             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
780                 .sub(pendingTransactions[nonce].value);
781         } else {
782             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
783                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
784         }
785         
786         emit TransferRejected(
787             from,
788             pendingTransactions[nonce].to,
789             pendingTransactions[nonce].value,
790             nonce,
791             reason
792         );
793         
794         delete pendingTransactions[nonce];
795     }
796 }