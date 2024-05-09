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
478 contract CompliantTokenRemintable is Validator, DetailedERC20, ReMintableToken {
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
494 
495     modifier checkIsInvestorApproved(address _account) {
496         require(whiteListingContract.isInvestorApproved(_account));
497         _;
498     }
499 
500     modifier checkIsAddressValid(address _account) {
501         require(_account != address(0));
502         _;
503     }
504 
505     modifier checkIsValueValid(uint256 _value) {
506         require(_value > 0);
507         _;
508     }
509 
510     /**
511     * event for rejected transfer logging
512     * @param from address from which tokens have to be transferred
513     * @param to address to tokens have to be transferred
514     * @param value number of tokens
515     * @param nonce request recorded at this particular nonce
516     * @param reason reason for rejection
517     */
518     event TransferRejected(
519         address indexed from,
520         address indexed to,
521         uint256 value,
522         uint256 indexed nonce,
523         uint256 reason
524     );
525 
526     /**
527     * event for transfer tokens logging
528     * @param from address from which tokens have to be transferred
529     * @param to address to tokens have to be transferred
530     * @param value number of tokens
531     * @param fee fee in tokens
532     */
533     event TransferWithFee(
534         address indexed from,
535         address indexed to,
536         uint256 value,
537         uint256 fee
538     );
539 
540     /**
541     * event for transfer/transferFrom request logging
542     * @param from address from which tokens have to be transferred
543     * @param to address to tokens have to be transferred
544     * @param value number of tokens
545     * @param fee fee in tokens
546     * @param spender The address which will spend the tokens
547     * @param nonce request recorded at this particular nonce
548     */
549     event RecordedPendingTransaction(
550         address indexed from,
551         address indexed to,
552         uint256 value,
553         uint256 fee,
554         address indexed spender,
555         uint256 nonce
556     );
557 
558     /**
559     * event for whitelist contract update logging
560     * @param _whiteListingContract address of the new whitelist contract
561     */
562     event WhiteListingContractSet(address indexed _whiteListingContract);
563 
564     /**
565     * event for fee update logging
566     * @param previousFee previous fee
567     * @param newFee new fee
568     */
569     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
570 
571     /**
572     * event for fee recipient update logging
573     * @param previousRecipient address of the old fee recipient
574     * @param newRecipient address of the new fee recipient
575     */
576     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
577 
578     /** @dev Constructor
579       * @param _owner Token contract owner
580       * @param _name Token name
581       * @param _symbol Token symbol
582       * @param _decimals number of decimals in the token(usually 18)
583       * @param whitelistAddress Ethereum address of the whitelist contract
584       * @param recipient Ethereum address of the fee recipient
585       * @param fee token fee for approving a transfer
586       */
587     constructor(
588         address _owner,
589         string _name, 
590         string _symbol, 
591         uint8 _decimals,
592         address whitelistAddress,
593         address recipient,
594         uint256 fee
595     )
596         public
597         ReMintableToken(_owner)
598         DetailedERC20(_name, _symbol, _decimals)
599         Validator()
600     {
601         setWhitelistContract(whitelistAddress);
602         setFeeRecipient(recipient);
603         setFee(fee);
604     }
605 
606     /** @dev Updates whitelist contract address
607       * @param whitelistAddress New whitelist contract address
608       */
609     function setWhitelistContract(address whitelistAddress)
610         public
611         onlyValidator
612         checkIsAddressValid(whitelistAddress)
613     {
614         whiteListingContract = Whitelist(whitelistAddress);
615         emit WhiteListingContractSet(whiteListingContract);
616     }
617 
618     /** @dev Updates token fee for approving a transfer
619       * @param fee New token fee
620       */
621     function setFee(uint256 fee)
622         public
623         onlyValidator
624     {
625         emit FeeSet(transferFee, fee);
626         transferFee = fee;
627     }
628 
629     /** @dev Updates fee recipient address
630       * @param recipient New whitelist contract address
631       */
632     function setFeeRecipient(address recipient)
633         public
634         onlyValidator
635         checkIsAddressValid(recipient)
636     {
637         emit FeeRecipientSet(feeRecipient, recipient);
638         feeRecipient = recipient;
639     }
640 
641     /** @dev Updates token name
642       * @param _name New token name
643       */
644     function updateName(string _name) public onlyOwner {
645         require(bytes(_name).length != 0);
646         name = _name;
647     }
648 
649     /** @dev Updates token symbol
650       * @param _symbol New token name
651       */
652     function updateSymbol(string _symbol) public onlyOwner {
653         require(bytes(_symbol).length != 0);
654         symbol = _symbol;
655     }
656 
657     /** @dev transfer request
658       * @param _to address to which the tokens have to be transferred
659       * @param _value amount of tokens to be transferred
660       */
661     function transfer(address _to, uint256 _value)
662         public
663         checkIsInvestorApproved(msg.sender)
664         checkIsInvestorApproved(_to)
665         checkIsValueValid(_value)
666         returns (bool)
667     {
668         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
669         uint256 fee = 0;
670 
671         if (msg.sender == feeRecipient) {
672             require(_value.add(pendingAmount) <= balances[msg.sender]);
673             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
674         } else {
675             fee = transferFee;
676             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
677             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
678         }
679 
680         pendingTransactions[currentNonce] = TransactionStruct(
681             msg.sender,
682             _to,
683             _value,
684             fee,
685             address(0)
686         );
687 
688         emit RecordedPendingTransaction(msg.sender, _to, _value, fee, address(0), currentNonce);
689         currentNonce++;
690 
691         return true;
692     }
693 
694     /** @dev transferFrom request
695       * @param _from address from which the tokens have to be transferred
696       * @param _to address to which the tokens have to be transferred
697       * @param _value amount of tokens to be transferred
698       */
699     function transferFrom(address _from, address _to, uint256 _value)
700         public 
701         checkIsInvestorApproved(_from)
702         checkIsInvestorApproved(_to)
703         checkIsValueValid(_value)
704         returns (bool)
705     {
706         uint256 allowedTransferAmount = allowed[_from][msg.sender];
707         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
708         uint256 fee = 0;
709         
710         if (_from == feeRecipient) {
711             require(_value.add(pendingAmount) <= balances[_from]);
712             require(_value.add(pendingAmount) <= allowedTransferAmount);
713             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
714         } else {
715             fee = transferFee;
716             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
717             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
718             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
719         }
720 
721         pendingTransactions[currentNonce] = TransactionStruct(
722             _from,
723             _to,
724             _value,
725             fee,
726             msg.sender
727         );
728 
729         emit RecordedPendingTransaction(_from, _to, _value, fee, msg.sender, currentNonce);
730         currentNonce++;
731 
732         return true;
733     }
734 
735     /** @dev approve transfer/transferFrom request
736       * @param nonce request recorded at this particular nonce
737       */
738     function approveTransfer(uint256 nonce)
739         external 
740         onlyValidator
741     {   
742         require(_approveTransfer(nonce));
743     }
744     
745 
746     /** @dev reject transfer/transferFrom request
747       * @param nonce request recorded at this particular nonce
748       * @param reason reason for rejection
749       */
750     function rejectTransfer(uint256 nonce, uint256 reason)
751         external 
752         onlyValidator
753     {        
754         _rejectTransfer(nonce, reason);
755     }
756 
757     /** @dev approve transfer/transferFrom requests
758       * @param nonces request recorded at these nonces
759       */
760     function bulkApproveTransfers(uint256[] nonces)
761         external 
762         onlyValidator
763     {
764         for (uint i = 0; i < nonces.length; i++) {
765             require(_approveTransfer(nonces[i]));
766         }
767     }
768 
769     /** @dev reject transfer/transferFrom request
770       * @param nonces requests recorded at these nonces
771       * @param reasons reasons for rejection
772       */
773     function bulkRejectTransfers(uint256[] nonces, uint256[] reasons)
774         external 
775         onlyValidator
776     {
777         require(nonces.length == reasons.length);
778         for (uint i = 0; i < nonces.length; i++) {
779             _rejectTransfer(nonces[i], reasons[i]);
780         }
781     }
782 
783     /** @dev approve transfer/transferFrom request called internally in the rejectTransfer and bulkRejectTransfers functions
784       * @param nonce request recorded at this particular nonce
785       */
786     function _approveTransfer(uint256 nonce)
787         private 
788         checkIsInvestorApproved(pendingTransactions[nonce].from)
789         checkIsInvestorApproved(pendingTransactions[nonce].to)
790         returns (bool)
791     {   
792         address from = pendingTransactions[nonce].from;
793         address to = pendingTransactions[nonce].to;
794         address spender = pendingTransactions[nonce].spender;
795         uint256 value = pendingTransactions[nonce].value;
796         uint256 fee = pendingTransactions[nonce].fee;
797 
798         delete pendingTransactions[nonce];
799 
800         if (fee == 0) {
801 
802             balances[from] = balances[from].sub(value);
803             balances[to] = balances[to].add(value);
804 
805             if (spender != address(0)) {
806                 allowed[from][spender] = allowed[from][spender].sub(value);
807             }
808 
809             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender].sub(value);
810 
811             emit Transfer(
812                 from,
813                 to,
814                 value
815             );
816 
817         } else {
818 
819             balances[from] = balances[from].sub(value.add(fee));
820             balances[to] = balances[to].add(value);
821             balances[feeRecipient] = balances[feeRecipient].add(fee);
822 
823             if (spender != address(0)) {
824                 allowed[from][spender] = allowed[from][spender].sub(value).sub(fee);
825             }
826 
827             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender].sub(value).sub(fee);
828             
829             emit TransferWithFee(
830                 from,
831                 to,
832                 value,
833                 fee
834             );
835 
836         }
837 
838         return true;
839     }
840     
841 
842     /** @dev reject transfer/transferFrom request called internally in the rejectTransfer and bulkRejectTransfers functions
843       * @param nonce request recorded at this particular nonce
844       * @param reason reason for rejection
845       */
846     function _rejectTransfer(uint256 nonce, uint256 reason)
847         private
848         checkIsAddressValid(pendingTransactions[nonce].from)
849     {        
850         address from = pendingTransactions[nonce].from;
851         address spender = pendingTransactions[nonce].spender;
852         uint256 value = pendingTransactions[nonce].value;
853 
854         if (pendingTransactions[nonce].fee == 0) {
855             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
856                 .sub(value);
857         } else {
858             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
859                 .sub(value).sub(pendingTransactions[nonce].fee);
860         }
861         
862         emit TransferRejected(
863             from,
864             pendingTransactions[nonce].to,
865             value,
866             nonce,
867             reason
868         );
869         
870         delete pendingTransactions[nonce];
871     }
872 }