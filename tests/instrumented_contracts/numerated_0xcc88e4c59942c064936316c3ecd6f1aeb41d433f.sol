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
58 contract DetailedERC20 {
59   string public name;
60   string public symbol;
61   uint8 public decimals;
62 
63   constructor(string _name, string _symbol, uint8 _decimals) public {
64     name = _name;
65     symbol = _symbol;
66     decimals = _decimals;
67   }
68 }
69 
70 
71 
72 /**
73  * @title Validator
74  * @dev The Validator contract has a validator address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Validator {
78     address public validator;
79 
80     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
81 
82     /**
83     * @dev The Validator constructor sets the original `validator` of the contract to the sender
84     * account.
85     */
86     constructor() public {
87         validator = msg.sender;
88     }
89 
90     /**
91     * @dev Throws if called by any account other than the validator.
92     */
93     modifier onlyValidator() {
94         require(msg.sender == validator);
95         _;
96     }
97 
98     /**
99     * @dev Allows the current validator to transfer control of the contract to a newValidator.
100     * @param newValidator The address to become next validator.
101     */
102     function setNewValidator(address newValidator) public onlyValidator {
103         require(newValidator != address(0));
104         emit NewValidatorSet(validator, newValidator);
105         validator = newValidator;
106     }
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
330 /**
331  * @title Mintable token
332  * @dev Simple ERC20 Token example, with mintable token creation
333  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
334  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
335  */
336 contract MintableToken is StandardToken, Ownable {
337     event Mint(address indexed to, uint256 amount);
338     event MintFinished();
339 
340     bool public mintingFinished = false;
341 
342 
343     modifier canMint() {
344         require(!mintingFinished);
345         _;
346     }
347 
348     constructor(address _owner) 
349         public 
350         Ownable(_owner) 
351     {
352 
353     }
354 
355     /**
356     * @dev Function to mint tokens
357     * @param _to The address that will receive the minted tokens.
358     * @param _amount The amount of tokens to mint.
359     * @return A boolean that indicates if the operation was successful.
360     */
361     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
362         totalSupply_ = totalSupply_.add(_amount);
363         balances[_to] = balances[_to].add(_amount);
364         emit Mint(_to, _amount);
365         emit Transfer(address(0), _to, _amount);
366         return true;
367     }
368 
369     /**
370     * @dev Function to stop minting new tokens.
371     * @return True if the operation was successful.
372     */
373     function finishMinting() onlyOwner canMint public returns (bool) {
374         mintingFinished = true;
375         emit MintFinished();
376         return true;
377     }
378 }
379 
380 
381 
382 
383 
384 
385 
386 contract Whitelist is Ownable {
387     mapping(address => bool) internal investorMap;
388 
389     /**
390     * event for investor approval logging
391     * @param investor approved investor
392     */
393     event Approved(address indexed investor);
394 
395     /**
396     * event for investor disapproval logging
397     * @param investor disapproved investor
398     */
399     event Disapproved(address indexed investor);
400 
401     constructor(address _owner) 
402         public 
403         Ownable(_owner) 
404     {
405         
406     }
407 
408     /** @param _investor the address of investor to be checked
409       * @return true if investor is approved
410       */
411     function isInvestorApproved(address _investor) external view returns (bool) {
412         require(_investor != address(0));
413         return investorMap[_investor];
414     }
415 
416     /** @dev approve an investor
417       * @param toApprove investor to be approved
418       */
419     function approveInvestor(address toApprove) external onlyOwner {
420         investorMap[toApprove] = true;
421         emit Approved(toApprove);
422     }
423 
424     /** @dev approve investors in bulk
425       * @param toApprove array of investors to be approved
426       */
427     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
428         for (uint i = 0; i < toApprove.length; i++) {
429             investorMap[toApprove[i]] = true;
430             emit Approved(toApprove[i]);
431         }
432     }
433 
434     /** @dev disapprove an investor
435       * @param toDisapprove investor to be disapproved
436       */
437     function disapproveInvestor(address toDisapprove) external onlyOwner {
438         delete investorMap[toDisapprove];
439         emit Disapproved(toDisapprove);
440     }
441 
442     /** @dev disapprove investors in bulk
443       * @param toDisapprove array of investors to be disapproved
444       */
445     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
446         for (uint i = 0; i < toDisapprove.length; i++) {
447             delete investorMap[toDisapprove[i]];
448             emit Disapproved(toDisapprove[i]);
449         }
450     }
451 }
452 
453 
454 
455 
456 /** @title Compliant Token */
457 contract CompliantToken is Validator, DetailedERC20, MintableToken {
458     Whitelist public whiteListingContract;
459 
460     struct TransactionStruct {
461         address from;
462         address to;
463         uint256 value;
464         uint256 fee;
465         address spender;
466     }
467 
468     mapping (uint => TransactionStruct) public pendingTransactions;
469     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
470     uint256 public currentNonce = 0;
471     uint256 public transferFee;
472     address public feeRecipient;
473 
474     modifier checkIsInvestorApproved(address _account) {
475         require(whiteListingContract.isInvestorApproved(_account));
476         _;
477     }
478 
479     modifier checkIsAddressValid(address _account) {
480         require(_account != address(0));
481         _;
482     }
483 
484     modifier checkIsValueValid(uint256 _value) {
485         require(_value > 0);
486         _;
487     }
488 
489     /**
490     * event for rejected transfer logging
491     * @param from address from which tokens have to be transferred
492     * @param to address to tokens have to be transferred
493     * @param value number of tokens
494     * @param nonce request recorded at this particular nonce
495     * @param reason reason for rejection
496     */
497     event TransferRejected(
498         address indexed from,
499         address indexed to,
500         uint256 value,
501         uint256 indexed nonce,
502         uint256 reason
503     );
504 
505     /**
506     * event for transfer tokens logging
507     * @param from address from which tokens have to be transferred
508     * @param to address to tokens have to be transferred
509     * @param value number of tokens
510     * @param fee fee in tokens
511     */
512     event TransferWithFee(
513         address indexed from,
514         address indexed to,
515         uint256 value,
516         uint256 fee
517     );
518 
519     /**
520     * event for transfer/transferFrom request logging
521     * @param from address from which tokens have to be transferred
522     * @param to address to tokens have to be transferred
523     * @param value number of tokens
524     * @param fee fee in tokens
525     * @param spender The address which will spend the tokens
526     * @param nonce request recorded at this particular nonce
527     */
528     event RecordedPendingTransaction(
529         address indexed from,
530         address indexed to,
531         uint256 value,
532         uint256 fee,
533         address indexed spender,
534         uint256 nonce
535     );
536 
537     /**
538     * event for whitelist contract update logging
539     * @param _whiteListingContract address of the new whitelist contract
540     */
541     event WhiteListingContractSet(address indexed _whiteListingContract);
542 
543     /**
544     * event for fee update logging
545     * @param previousFee previous fee
546     * @param newFee new fee
547     */
548     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
549 
550     /**
551     * event for fee recipient update logging
552     * @param previousRecipient address of the old fee recipient
553     * @param newRecipient address of the new fee recipient
554     */
555     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
556 
557     /** @dev Constructor
558       * @param _owner Token contract owner
559       * @param _name Token name
560       * @param _symbol Token symbol
561       * @param _decimals number of decimals in the token(usually 18)
562       * @param whitelistAddress Ethereum address of the whitelist contract
563       * @param recipient Ethereum address of the fee recipient
564       * @param fee token fee for approving a transfer
565       */
566     constructor(
567         address _owner,
568         string _name, 
569         string _symbol, 
570         uint8 _decimals,
571         address whitelistAddress,
572         address recipient,
573         uint256 fee
574     )
575         public
576         MintableToken(_owner)
577         DetailedERC20(_name, _symbol, _decimals)
578         Validator()
579     {
580         setWhitelistContract(whitelistAddress);
581         setFeeRecipient(recipient);
582         setFee(fee);
583     }
584 
585     /** @dev Updates whitelist contract address
586       * @param whitelistAddress New whitelist contract address
587       */
588     function setWhitelistContract(address whitelistAddress)
589         public
590         onlyValidator
591         checkIsAddressValid(whitelistAddress)
592     {
593         whiteListingContract = Whitelist(whitelistAddress);
594         emit WhiteListingContractSet(whiteListingContract);
595     }
596 
597     /** @dev Updates token fee for approving a transfer
598       * @param fee New token fee
599       */
600     function setFee(uint256 fee)
601         public
602         onlyValidator
603     {
604         emit FeeSet(transferFee, fee);
605         transferFee = fee;
606     }
607 
608     /** @dev Updates fee recipient address
609       * @param recipient New whitelist contract address
610       */
611     function setFeeRecipient(address recipient)
612         public
613         onlyValidator
614         checkIsAddressValid(recipient)
615     {
616         emit FeeRecipientSet(feeRecipient, recipient);
617         feeRecipient = recipient;
618     }
619 
620     /** @dev Updates token name
621       * @param _name New token name
622       */
623     function updateName(string _name) public onlyOwner {
624         require(bytes(_name).length != 0);
625         name = _name;
626     }
627 
628     /** @dev Updates token symbol
629       * @param _symbol New token name
630       */
631     function updateSymbol(string _symbol) public onlyOwner {
632         require(bytes(_symbol).length != 0);
633         symbol = _symbol;
634     }
635 
636     /** @dev transfer request
637       * @param _to address to which the tokens have to be transferred
638       * @param _value amount of tokens to be transferred
639       */
640     function transfer(address _to, uint256 _value)
641         public
642         checkIsInvestorApproved(msg.sender)
643         checkIsInvestorApproved(_to)
644         checkIsValueValid(_value)
645         returns (bool)
646     {
647         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
648         uint256 fee = 0;
649 
650         if (msg.sender == feeRecipient) {
651             require(_value.add(pendingAmount) <= balances[msg.sender]);
652             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
653         } else {
654             fee = transferFee;
655             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
656             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
657         }
658 
659         pendingTransactions[currentNonce] = TransactionStruct(
660             msg.sender,
661             _to,
662             _value,
663             fee,
664             address(0)
665         );
666 
667         emit RecordedPendingTransaction(msg.sender, _to, _value, fee, address(0), currentNonce);
668         currentNonce++;
669 
670         return true;
671     }
672 
673     /** @dev transferFrom request
674       * @param _from address from which the tokens have to be transferred
675       * @param _to address to which the tokens have to be transferred
676       * @param _value amount of tokens to be transferred
677       */
678     function transferFrom(address _from, address _to, uint256 _value)
679         public 
680         checkIsInvestorApproved(_from)
681         checkIsInvestorApproved(_to)
682         checkIsValueValid(_value)
683         returns (bool)
684     {
685         uint256 allowedTransferAmount = allowed[_from][msg.sender];
686         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
687         uint256 fee = 0;
688         
689         if (_from == feeRecipient) {
690             require(_value.add(pendingAmount) <= balances[_from]);
691             require(_value.add(pendingAmount) <= allowedTransferAmount);
692             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
693         } else {
694             fee = transferFee;
695             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
696             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
697             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
698         }
699 
700         pendingTransactions[currentNonce] = TransactionStruct(
701             _from,
702             _to,
703             _value,
704             fee,
705             msg.sender
706         );
707 
708         emit RecordedPendingTransaction(_from, _to, _value, fee, msg.sender, currentNonce);
709         currentNonce++;
710 
711         return true;
712     }
713 
714     /** @dev approve transfer/transferFrom request
715       * @param nonce request recorded at this particular nonce
716       */
717     function approveTransfer(uint256 nonce)
718         external 
719         onlyValidator
720     {   
721         require(_approveTransfer(nonce));
722     }
723     
724 
725     /** @dev reject transfer/transferFrom request
726       * @param nonce request recorded at this particular nonce
727       * @param reason reason for rejection
728       */
729     function rejectTransfer(uint256 nonce, uint256 reason)
730         external 
731         onlyValidator
732     {        
733         _rejectTransfer(nonce, reason);
734     }
735 
736     /** @dev approve transfer/transferFrom requests
737       * @param nonces request recorded at these nonces
738       */
739     function bulkApproveTransfers(uint256[] nonces)
740         external 
741         onlyValidator
742     {
743         for (uint i = 0; i < nonces.length; i++) {
744             require(_approveTransfer(nonces[i]));
745         }
746     }
747 
748     /** @dev reject transfer/transferFrom request
749       * @param nonces requests recorded at these nonces
750       * @param reasons reasons for rejection
751       */
752     function bulkRejectTransfers(uint256[] nonces, uint256[] reasons)
753         external 
754         onlyValidator
755     {
756         require(nonces.length == reasons.length);
757         for (uint i = 0; i < nonces.length; i++) {
758             _rejectTransfer(nonces[i], reasons[i]);
759         }
760     }
761 
762     /** @dev approve transfer/transferFrom request called internally in the rejectTransfer and bulkRejectTransfers functions
763       * @param nonce request recorded at this particular nonce
764       */
765     function _approveTransfer(uint256 nonce)
766         private 
767         checkIsInvestorApproved(pendingTransactions[nonce].from)
768         checkIsInvestorApproved(pendingTransactions[nonce].to)
769         returns (bool)
770     {   
771         address from = pendingTransactions[nonce].from;
772         address to = pendingTransactions[nonce].to;
773         address spender = pendingTransactions[nonce].spender;
774         uint256 value = pendingTransactions[nonce].value;
775         uint256 fee = pendingTransactions[nonce].fee;
776 
777         delete pendingTransactions[nonce];
778 
779         if (fee == 0) {
780 
781             balances[from] = balances[from].sub(value);
782             balances[to] = balances[to].add(value);
783 
784             if (spender != address(0)) {
785                 allowed[from][spender] = allowed[from][spender].sub(value);
786             }
787 
788             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender].sub(value);
789 
790             emit Transfer(
791                 from,
792                 to,
793                 value
794             );
795 
796         } else {
797 
798             balances[from] = balances[from].sub(value.add(fee));
799             balances[to] = balances[to].add(value);
800             balances[feeRecipient] = balances[feeRecipient].add(fee);
801 
802             if (spender != address(0)) {
803                 allowed[from][spender] = allowed[from][spender].sub(value).sub(fee);
804             }
805 
806             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender].sub(value).sub(fee);
807             
808             emit TransferWithFee(
809                 from,
810                 to,
811                 value,
812                 fee
813             );
814 
815         }
816 
817         return true;
818     }
819     
820 
821     /** @dev reject transfer/transferFrom request called internally in the rejectTransfer and bulkRejectTransfers functions
822       * @param nonce request recorded at this particular nonce
823       * @param reason reason for rejection
824       */
825     function _rejectTransfer(uint256 nonce, uint256 reason)
826         private
827         checkIsAddressValid(pendingTransactions[nonce].from)
828     {        
829         address from = pendingTransactions[nonce].from;
830         address spender = pendingTransactions[nonce].spender;
831         uint256 value = pendingTransactions[nonce].value;
832 
833         if (pendingTransactions[nonce].fee == 0) {
834             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
835                 .sub(value);
836         } else {
837             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
838                 .sub(value).sub(pendingTransactions[nonce].fee);
839         }
840         
841         emit TransferRejected(
842             from,
843             pendingTransactions[nonce].to,
844             value,
845             nonce,
846             reason
847         );
848         
849         delete pendingTransactions[nonce];
850     }
851 }