1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24     address public owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     /**
29     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30     * account.
31     */
32     constructor(address _owner) public {
33         owner = _owner;
34     }
35 
36     /**
37     * @dev Throws if called by any account other than the owner.
38     */
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     /**
45     * @dev Allows the current owner to transfer control of the contract to a newOwner.
46     * @param newOwner The address to transfer ownership to.
47     */
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54 }
55 
56 
57 
58 /**
59  * @title Validator
60  * @dev The Validator contract has a validator address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Validator {
64     address public validator;
65 
66     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
67 
68     /**
69     * @dev The Validator constructor sets the original `validator` of the contract to the sender
70     * account.
71     */
72     constructor() public {
73         validator = msg.sender;
74     }
75 
76     /**
77     * @dev Throws if called by any account other than the validator.
78     */
79     modifier onlyValidator() {
80         require(msg.sender == validator);
81         _;
82     }
83 
84     /**
85     * @dev Allows the current validator to transfer control of the contract to a newValidator.
86     * @param newValidator The address to become next validator.
87     */
88     function setNewValidator(address newValidator) public onlyValidator {
89         require(newValidator != address(0));
90         emit NewValidatorSet(validator, newValidator);
91         validator = newValidator;
92     }
93 }
94 
95 
96 
97 contract DetailedERC20 {
98   string public name;
99   string public symbol;
100   uint8 public decimals;
101 
102   constructor(string _name, string _symbol, uint8 _decimals) public {
103     name = _name;
104     symbol = _symbol;
105     decimals = _decimals;
106   }
107 }
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 
118 
119 
120 
121 /**
122  * @title SafeMath
123  * @dev Math operations with safety checks that throw on error
124  */
125 library SafeMath {
126 
127   /**
128   * @dev Multiplies two numbers, throws on overflow.
129   */
130   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131     if (a == 0) {
132       return 0;
133     }
134     uint256 c = a * b;
135     assert(c / a == b);
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers, truncating the quotient.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     // assert(b > 0); // Solidity automatically throws when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146     return c;
147   }
148 
149   /**
150   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
151   */
152   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153     assert(b <= a);
154     return a - b;
155   }
156 
157   /**
158   * @dev Adds two numbers, throws on overflow.
159   */
160   function add(uint256 a, uint256 b) internal pure returns (uint256) {
161     uint256 c = a + b;
162     assert(c >= a);
163     return c;
164   }
165 }
166 
167 
168 
169 /**
170  * @title Basic token
171  * @dev Basic version of StandardToken, with no allowances.
172  */
173 contract BasicToken is ERC20Basic {
174   using SafeMath for uint256;
175 
176   mapping(address => uint256) balances;
177 
178   uint256 totalSupply_;
179 
180   /**
181   * @dev total number of tokens in existence
182   */
183   function totalSupply() public view returns (uint256) {
184     return totalSupply_;
185   }
186 
187   /**
188   * @dev transfer token for a specified address
189   * @param _to The address to transfer to.
190   * @param _value The amount to be transferred.
191   */
192   function transfer(address _to, uint256 _value) public returns (bool) {
193     require(_to != address(0));
194     require(_value <= balances[msg.sender]);
195 
196     // SafeMath.sub will throw if there is not enough balance.
197     balances[msg.sender] = balances[msg.sender].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     emit Transfer(msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public view returns (uint256 balance) {
209     return balances[_owner];
210   }
211 
212 }
213 
214 
215 
216 
217 
218 
219 /**
220  * @title ERC20 interface
221  * @dev see https://github.com/ethereum/EIPs/issues/20
222  */
223 contract ERC20 is ERC20Basic {
224   function allowance(address owner, address spender) public view returns (uint256);
225   function transferFrom(address from, address to, uint256 value) public returns (bool);
226   function approve(address spender, uint256 value) public returns (bool);
227   event Approval(address indexed owner, address indexed spender, uint256 value);
228 }
229 
230 
231 
232 /**
233  * @title Standard ERC20 token
234  *
235  * @dev Implementation of the basic standard token.
236  * @dev https://github.com/ethereum/EIPs/issues/20
237  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
238  */
239 contract StandardToken is ERC20, BasicToken {
240 
241   mapping (address => mapping (address => uint256)) internal allowed;
242 
243 
244   /**
245    * @dev Transfer tokens from one address to another
246    * @param _from address The address which you want to send tokens from
247    * @param _to address The address which you want to transfer to
248    * @param _value uint256 the amount of tokens to be transferred
249    */
250   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
251     require(_to != address(0));
252     require(_value <= balances[_from]);
253     require(_value <= allowed[_from][msg.sender]);
254 
255     balances[_from] = balances[_from].sub(_value);
256     balances[_to] = balances[_to].add(_value);
257     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
258     emit Transfer(_from, _to, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264    *
265    * Beware that changing an allowance with this method brings the risk that someone may use both the old
266    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    * @param _spender The address which will spend the funds.
270    * @param _value The amount of tokens to be spent.
271    */
272   function approve(address _spender, uint256 _value) public returns (bool) {
273     allowed[msg.sender][_spender] = _value;
274     emit Approval(msg.sender, _spender, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Function to check the amount of tokens that an owner allowed to a spender.
280    * @param _owner address The address which owns the funds.
281    * @param _spender address The address which will spend the funds.
282    * @return A uint256 specifying the amount of tokens still available for the spender.
283    */
284   function allowance(address _owner, address _spender) public view returns (uint256) {
285     return allowed[_owner][_spender];
286   }
287 
288   /**
289    * @dev Increase the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To increment
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _addedValue The amount of tokens to increase the allowance by.
297    */
298   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
299     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    *
307    * approve should be called when allowed[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
315     uint oldValue = allowed[msg.sender][_spender];
316     if (_subtractedValue > oldValue) {
317       allowed[msg.sender][_spender] = 0;
318     } else {
319       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
320     }
321     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325 }
326 
327 
328 
329 
330 
331 /**
332  * @title Mintable token
333  * @dev Simple ERC20 Token example, with mintable token creation
334  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
335  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
336  */
337 contract ReMintableToken is Validator, StandardToken, Ownable {
338     event Mint(address indexed to, uint256 amount);
339     event MintFinished();
340     event MintStarted();
341 
342     bool public mintingFinished = false;
343 
344 
345     modifier canMint() {
346         require(!mintingFinished);
347         _;
348     }
349     
350     modifier cannotMint() {
351         require(mintingFinished);
352         _;
353     }
354     
355     modifier isAuthorized() {
356         require(msg.sender == owner || msg.sender == validator);
357         _;
358     }
359 
360     constructor(address _owner) 
361         public 
362         Ownable(_owner) 
363     {
364     }
365 
366     /**
367     * @dev Function to mint tokens
368     * @param _to The address that will receive the minted tokens.
369     * @param _amount The amount of tokens to mint.
370     * @return A boolean that indicates if the operation was successful.
371     */
372     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
373         totalSupply_ = totalSupply_.add(_amount);
374         balances[_to] = balances[_to].add(_amount);
375         emit Mint(_to, _amount);
376         emit Transfer(address(0), _to, _amount);
377         return true;
378     }
379 
380     /**
381     * @dev Function to stop minting new tokens.
382     * @return True if the operation was successful.
383     */
384     function finishMinting() isAuthorized canMint public returns (bool) {
385         mintingFinished = true;
386         emit MintFinished();
387         return true;
388     }
389     
390     /**
391     * @dev Function to start minting new tokens.
392     * @return True if the operation was successful.
393     */
394     function startMinting() onlyValidator cannotMint public returns (bool) {
395         mintingFinished = false;
396         emit MintStarted();
397         return true;
398     }
399 }
400 
401 
402 
403 
404 
405 
406 
407 contract Whitelist is Ownable {
408     mapping(address => bool) internal investorMap;
409 
410     /**
411     * event for investor approval logging
412     * @param investor approved investor
413     */
414     event Approved(address indexed investor);
415 
416     /**
417     * event for investor disapproval logging
418     * @param investor disapproved investor
419     */
420     event Disapproved(address indexed investor);
421 
422     constructor(address _owner) 
423         public 
424         Ownable(_owner) 
425     {
426         
427     }
428 
429     /** @param _investor the address of investor to be checked
430       * @return true if investor is approved
431       */
432     function isInvestorApproved(address _investor) external view returns (bool) {
433         require(_investor != address(0));
434         return investorMap[_investor];
435     }
436 
437     /** @dev approve an investor
438       * @param toApprove investor to be approved
439       */
440     function approveInvestor(address toApprove) external onlyOwner {
441         investorMap[toApprove] = true;
442         emit Approved(toApprove);
443     }
444 
445     /** @dev approve investors in bulk
446       * @param toApprove array of investors to be approved
447       */
448     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
449         for (uint i = 0; i < toApprove.length; i++) {
450             investorMap[toApprove[i]] = true;
451             emit Approved(toApprove[i]);
452         }
453     }
454 
455     /** @dev disapprove an investor
456       * @param toDisapprove investor to be disapproved
457       */
458     function disapproveInvestor(address toDisapprove) external onlyOwner {
459         delete investorMap[toDisapprove];
460         emit Disapproved(toDisapprove);
461     }
462 
463     /** @dev disapprove investors in bulk
464       * @param toDisapprove array of investors to be disapproved
465       */
466     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
467         for (uint i = 0; i < toDisapprove.length; i++) {
468             delete investorMap[toDisapprove[i]];
469             emit Disapproved(toDisapprove[i]);
470         }
471     }
472 }
473 
474 
475 
476 
477 /** @title Compliant Token */
478 contract CompliantTokenSwitchRemintable is Validator, DetailedERC20, ReMintableToken {
479     Whitelist public whiteListingContract;
480 
481     struct TransactionStruct {
482         address from;
483         address to;
484         uint256 value;
485         uint256 fee;
486         address spender;
487     }
488 
489     mapping (uint => TransactionStruct) public pendingTransactions;
490     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
491     uint256 public currentNonce = 0;
492     uint256 public transferFee;
493     address public feeRecipient;
494     bool public tokenSwitch;
495 
496     modifier checkIsInvestorApproved(address _account) {
497         require(whiteListingContract.isInvestorApproved(_account));
498         _;
499     }
500 
501     modifier checkIsAddressValid(address _account) {
502         require(_account != address(0));
503         _;
504     }
505 
506     modifier checkIsValueValid(uint256 _value) {
507         require(_value > 0);
508         _;
509     }
510 
511     /**
512     * event for rejected transfer logging
513     * @param from address from which tokens have to be transferred
514     * @param to address to tokens have to be transferred
515     * @param value number of tokens
516     * @param nonce request recorded at this particular nonce
517     * @param reason reason for rejection
518     */
519     event TransferRejected(
520         address indexed from,
521         address indexed to,
522         uint256 value,
523         uint256 indexed nonce,
524         uint256 reason
525     );
526 
527     /**
528     * event for transfer tokens logging
529     * @param from address from which tokens have to be transferred
530     * @param to address to tokens have to be transferred
531     * @param value number of tokens
532     * @param fee fee in tokens
533     */
534     event TransferWithFee(
535         address indexed from,
536         address indexed to,
537         uint256 value,
538         uint256 fee
539     );
540 
541     /**
542     * event for transfer/transferFrom request logging
543     * @param from address from which tokens have to be transferred
544     * @param to address to tokens have to be transferred
545     * @param value number of tokens
546     * @param fee fee in tokens
547     * @param spender The address which will spend the tokens
548     * @param nonce request recorded at this particular nonce
549     */
550     event RecordedPendingTransaction(
551         address indexed from,
552         address indexed to,
553         uint256 value,
554         uint256 fee,
555         address indexed spender,
556         uint256 nonce
557     );
558 
559     /**
560     * event for token switch activate logging
561     */
562     event TokenSwitchActivated();
563 
564     /**
565     * event for token switch deactivate logging
566     */
567     event TokenSwitchDeactivated();
568 
569     /**
570     * event for whitelist contract update logging
571     * @param _whiteListingContract address of the new whitelist contract
572     */
573     event WhiteListingContractSet(address indexed _whiteListingContract);
574 
575     /**
576     * event for fee update logging
577     * @param previousFee previous fee
578     * @param newFee new fee
579     */
580     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
581 
582     /**
583     * event for fee recipient update logging
584     * @param previousRecipient address of the old fee recipient
585     * @param newRecipient address of the new fee recipient
586     */
587     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
588 
589     /** @dev Constructor
590       * @param _owner Token contract owner
591       * @param _name Token name
592       * @param _symbol Token symbol
593       * @param _decimals number of decimals in the token(usually 18)
594       * @param whitelistAddress Ethereum address of the whitelist contract
595       * @param recipient Ethereum address of the fee recipient
596       * @param fee token fee for approving a transfer
597       */
598     constructor(
599         address _owner,
600         string _name, 
601         string _symbol, 
602         uint8 _decimals,
603         address whitelistAddress,
604         address recipient,
605         uint256 fee
606     )
607         public
608         ReMintableToken(_owner)
609         DetailedERC20(_name, _symbol, _decimals)
610         Validator()
611     {
612         setWhitelistContract(whitelistAddress);
613         setFeeRecipient(recipient);
614         setFee(fee);
615     }
616 
617     /** @dev Updates whitelist contract address
618       * @param whitelistAddress New whitelist contract address
619       */
620     function setWhitelistContract(address whitelistAddress)
621         public
622         onlyValidator
623         checkIsAddressValid(whitelistAddress)
624     {
625         whiteListingContract = Whitelist(whitelistAddress);
626         emit WhiteListingContractSet(whiteListingContract);
627     }
628 
629     /** @dev Updates token fee for approving a transfer
630       * @param fee New token fee
631       */
632     function setFee(uint256 fee)
633         public
634         onlyValidator
635     {
636         emit FeeSet(transferFee, fee);
637         transferFee = fee;
638     }
639 
640     /** @dev Updates fee recipient address
641       * @param recipient New whitelist contract address
642       */
643     function setFeeRecipient(address recipient)
644         public
645         onlyValidator
646         checkIsAddressValid(recipient)
647     {
648         emit FeeRecipientSet(feeRecipient, recipient);
649         feeRecipient = recipient;
650     }
651 
652     /** @dev activates token switch after which no validator approval is required for transfer */
653     function activateTokenSwitch() public onlyValidator {
654         tokenSwitch = true;
655         emit TokenSwitchActivated();
656     }
657 
658     /** @dev deactivates token switch after which validator approval is required for transfer */ 
659     function deactivateTokenSwitch() public onlyValidator {
660         tokenSwitch = false;
661         emit TokenSwitchDeactivated();
662     }
663 
664     /** @dev Updates token name
665       * @param _name New token name
666       */
667     function updateName(string _name) public onlyOwner {
668         require(bytes(_name).length != 0);
669         name = _name;
670     }
671 
672     /** @dev Updates token symbol
673       * @param _symbol New token name
674       */
675     function updateSymbol(string _symbol) public onlyOwner {
676         require(bytes(_symbol).length != 0);
677         symbol = _symbol;
678     }
679 
680     /** @dev transfer
681       * @param _to address to which the tokens have to be transferred
682       * @param _value amount of tokens to be transferred
683       */
684     function transfer(address _to, uint256 _value)
685         public
686         checkIsInvestorApproved(msg.sender)
687         checkIsInvestorApproved(_to)
688         checkIsValueValid(_value)
689         returns (bool)
690     {
691         if (tokenSwitch) {
692             super.transfer(_to, _value);
693         } else {
694             uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
695             uint256 fee = 0;
696 
697             if (msg.sender == feeRecipient) {
698                 require(_value.add(pendingAmount) <= balances[msg.sender]);
699                 pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
700             } else {
701                 fee = transferFee;
702                 require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
703                 pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
704             }
705 
706             pendingTransactions[currentNonce] = TransactionStruct(
707                 msg.sender,
708                 _to,
709                 _value,
710                 fee,
711                 address(0)
712             );
713 
714             emit RecordedPendingTransaction(msg.sender, _to, _value, fee, address(0), currentNonce);
715             currentNonce++;
716         }
717 
718         return true;
719     }
720 
721     /** @dev transferFrom
722       * @param _from address from which the tokens have to be transferred
723       * @param _to address to which the tokens have to be transferred
724       * @param _value amount of tokens to be transferred
725       */
726     function transferFrom(address _from, address _to, uint256 _value)
727         public 
728         checkIsInvestorApproved(_from)
729         checkIsInvestorApproved(_to)
730         checkIsValueValid(_value)
731         returns (bool)
732     {
733         if (tokenSwitch) {
734             super.transferFrom(_from, _to, _value);
735         } else {
736             uint256 allowedTransferAmount = allowed[_from][msg.sender];
737             uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
738             uint256 fee = 0;
739             
740             if (_from == feeRecipient) {
741                 require(_value.add(pendingAmount) <= balances[_from]);
742                 require(_value.add(pendingAmount) <= allowedTransferAmount);
743                 pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
744             } else {
745                 fee = transferFee;
746                 require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
747                 require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
748                 pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
749             }
750 
751             pendingTransactions[currentNonce] = TransactionStruct(
752                 _from,
753                 _to,
754                 _value,
755                 fee,
756                 msg.sender
757             );
758 
759             emit RecordedPendingTransaction(_from, _to, _value, fee, msg.sender, currentNonce);
760             currentNonce++;
761         }
762 
763         return true;
764     }
765 
766     /** @dev approve transfer/transferFrom request
767       * @param nonce request recorded at this particular nonce
768       */
769     function approveTransfer(uint256 nonce)
770         external 
771         onlyValidator
772     {   
773         require(_approveTransfer(nonce));
774     }    
775 
776     /** @dev reject transfer/transferFrom request
777       * @param nonce request recorded at this particular nonce
778       * @param reason reason for rejection
779       */
780     function rejectTransfer(uint256 nonce, uint256 reason)
781         external 
782         onlyValidator
783     {        
784         _rejectTransfer(nonce, reason);
785     }
786 
787     /** @dev approve transfer/transferFrom requests
788       * @param nonces request recorded at these nonces
789       */
790     function bulkApproveTransfers(uint256[] nonces)
791         external 
792         onlyValidator
793         returns (bool)
794     {
795         for (uint i = 0; i < nonces.length; i++) {
796             require(_approveTransfer(nonces[i]));
797         }
798     }
799 
800     /** @dev reject transfer/transferFrom request
801       * @param nonces requests recorded at these nonces
802       * @param reasons reasons for rejection
803       */
804     function bulkRejectTransfers(uint256[] nonces, uint256[] reasons)
805         external 
806         onlyValidator
807     {
808         require(nonces.length == reasons.length);
809         for (uint i = 0; i < nonces.length; i++) {
810             _rejectTransfer(nonces[i], reasons[i]);
811         }
812     }
813 
814     /** @dev approve transfer/transferFrom request called internally in the approveTransfer and bulkApproveTransfers functions
815       * @param nonce request recorded at this particular nonce
816       */
817     function _approveTransfer(uint256 nonce)
818         private
819         checkIsInvestorApproved(pendingTransactions[nonce].from)
820         checkIsInvestorApproved(pendingTransactions[nonce].to)
821         returns (bool)
822     {   
823         address from = pendingTransactions[nonce].from;
824         address to = pendingTransactions[nonce].to;
825         address spender = pendingTransactions[nonce].spender;
826         uint256 value = pendingTransactions[nonce].value;
827         uint256 fee = pendingTransactions[nonce].fee;
828 
829         delete pendingTransactions[nonce];
830 
831         if (fee == 0) {
832 
833             balances[from] = balances[from].sub(value);
834             balances[to] = balances[to].add(value);
835 
836             if (spender != address(0)) {
837                 allowed[from][spender] = allowed[from][spender].sub(value);
838             }
839 
840             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender].sub(value);
841 
842             emit Transfer(
843                 from,
844                 to,
845                 value
846             );
847 
848         } else {
849 
850             balances[from] = balances[from].sub(value.add(fee));
851             balances[to] = balances[to].add(value);
852             balances[feeRecipient] = balances[feeRecipient].add(fee);
853 
854             if (spender != address(0)) {
855                 allowed[from][spender] = allowed[from][spender].sub(value).sub(fee);
856             }
857 
858             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender].sub(value).sub(fee);
859             
860             emit TransferWithFee(
861                 from,
862                 to,
863                 value,
864                 fee
865             );
866 
867         }
868 
869         return true;
870     }    
871 
872     /** @dev reject transfer/transferFrom request called internally in the rejectTransfer and bulkRejectTransfers functions
873       * @param nonce request recorded at this particular nonce
874       * @param reason reason for rejection
875       */
876     function _rejectTransfer(uint256 nonce, uint256 reason)
877         private
878         checkIsAddressValid(pendingTransactions[nonce].from)
879     {        
880         address from = pendingTransactions[nonce].from;
881         address spender = pendingTransactions[nonce].spender;
882         uint256 value = pendingTransactions[nonce].value;
883 
884         if (pendingTransactions[nonce].fee == 0) {
885             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
886                 .sub(value);
887         } else {
888             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
889                 .sub(value).sub(pendingTransactions[nonce].fee);
890         }
891         
892         emit TransferRejected(
893             from,
894             pendingTransactions[nonce].to,
895             value,
896             nonce,
897             reason
898         );
899         
900         delete pendingTransactions[nonce];
901     }
902 }