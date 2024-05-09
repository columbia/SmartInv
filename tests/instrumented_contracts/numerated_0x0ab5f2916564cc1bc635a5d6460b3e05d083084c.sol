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
457 contract CompliantTokenSwitch is Validator, DetailedERC20, MintableToken {
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
473     bool public tokenSwitch;
474 
475     modifier checkIsInvestorApproved(address _account) {
476         if (!tokenSwitch) require(whiteListingContract.isInvestorApproved(_account));
477         _;
478     }
479 
480     modifier checkIsAddressValid(address _account) {
481         require(_account != address(0));
482         _;
483     }
484 
485     modifier checkIsValueValid(uint256 _value) {
486         require(_value > 0);
487         _;
488     }
489 
490     /**
491     * event for rejected transfer logging
492     * @param from address from which tokens have to be transferred
493     * @param to address to tokens have to be transferred
494     * @param value number of tokens
495     * @param nonce request recorded at this particular nonce
496     * @param reason reason for rejection
497     */
498     event TransferRejected(
499         address indexed from,
500         address indexed to,
501         uint256 value,
502         uint256 indexed nonce,
503         uint256 reason
504     );
505 
506     /**
507     * event for transfer tokens logging
508     * @param from address from which tokens have to be transferred
509     * @param to address to tokens have to be transferred
510     * @param value number of tokens
511     * @param fee fee in tokens
512     */
513     event TransferWithFee(
514         address indexed from,
515         address indexed to,
516         uint256 value,
517         uint256 fee
518     );
519 
520     /**
521     * event for transfer/transferFrom request logging
522     * @param from address from which tokens have to be transferred
523     * @param to address to tokens have to be transferred
524     * @param value number of tokens
525     * @param fee fee in tokens
526     * @param spender The address which will spend the tokens
527     * @param nonce request recorded at this particular nonce
528     */
529     event RecordedPendingTransaction(
530         address indexed from,
531         address indexed to,
532         uint256 value,
533         uint256 fee,
534         address indexed spender,
535         uint256 nonce
536     );
537 
538     /**
539     * event for token switch activate logging
540     */
541     event TokenSwitchActivated();
542 
543     /**
544     * event for token switch deactivate logging
545     */
546     event TokenSwitchDeactivated();
547 
548     /**
549     * event for whitelist contract update logging
550     * @param _whiteListingContract address of the new whitelist contract
551     */
552     event WhiteListingContractSet(address indexed _whiteListingContract);
553 
554     /**
555     * event for fee update logging
556     * @param previousFee previous fee
557     * @param newFee new fee
558     */
559     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
560 
561     /**
562     * event for fee recipient update logging
563     * @param previousRecipient address of the old fee recipient
564     * @param newRecipient address of the new fee recipient
565     */
566     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
567 
568     /** @dev Constructor
569       * @param _owner Token contract owner
570       * @param _name Token name
571       * @param _symbol Token symbol
572       * @param _decimals number of decimals in the token(usually 18)
573       * @param whitelistAddress Ethereum address of the whitelist contract
574       * @param recipient Ethereum address of the fee recipient
575       * @param fee token fee for approving a transfer
576       */
577     constructor(
578         address _owner,
579         string _name, 
580         string _symbol, 
581         uint8 _decimals,
582         address whitelistAddress,
583         address recipient,
584         uint256 fee
585     )
586         public
587         MintableToken(_owner)
588         DetailedERC20(_name, _symbol, _decimals)
589         Validator()
590     {
591         setWhitelistContract(whitelistAddress);
592         setFeeRecipient(recipient);
593         setFee(fee);
594     }
595 
596     /** @dev Updates whitelist contract address
597       * @param whitelistAddress New whitelist contract address
598       */
599     function setWhitelistContract(address whitelistAddress)
600         public
601         onlyValidator
602         checkIsAddressValid(whitelistAddress)
603     {
604         whiteListingContract = Whitelist(whitelistAddress);
605         emit WhiteListingContractSet(whiteListingContract);
606     }
607 
608     /** @dev Updates token fee for approving a transfer
609       * @param fee New token fee
610       */
611     function setFee(uint256 fee)
612         public
613         onlyValidator
614     {
615         emit FeeSet(transferFee, fee);
616         transferFee = fee;
617     }
618 
619     /** @dev Updates fee recipient address
620       * @param recipient New whitelist contract address
621       */
622     function setFeeRecipient(address recipient)
623         public
624         onlyValidator
625         checkIsAddressValid(recipient)
626     {
627         emit FeeRecipientSet(feeRecipient, recipient);
628         feeRecipient = recipient;
629     }
630 
631     /** @dev activates token switch after which no validator approval is required for transfer */
632     function activateTokenSwitch() public onlyValidator {
633         tokenSwitch = true;
634         emit TokenSwitchActivated();
635     }
636 
637     /** @dev deactivates token switch after which validator approval is required for transfer */ 
638     function deactivateTokenSwitch() public onlyValidator {
639         tokenSwitch = false;
640         emit TokenSwitchDeactivated();
641     }
642 
643     /** @dev Updates token name
644       * @param _name New token name
645       */
646     function updateName(string _name) public onlyOwner {
647         require(bytes(_name).length != 0);
648         name = _name;
649     }
650 
651     /** @dev Updates token symbol
652       * @param _symbol New token name
653       */
654     function updateSymbol(string _symbol) public onlyOwner {
655         require(bytes(_symbol).length != 0);
656         symbol = _symbol;
657     }
658 
659     /** @dev transfer
660       * @param _to address to which the tokens have to be transferred
661       * @param _value amount of tokens to be transferred
662       */
663     function transfer(address _to, uint256 _value)
664         public
665         checkIsInvestorApproved(msg.sender)
666         checkIsInvestorApproved(_to)
667         checkIsValueValid(_value)
668         returns (bool)
669     {
670         if (tokenSwitch) {
671             super.transfer(_to, _value);
672         } else {
673             uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
674             uint256 fee = 0;
675 
676             if (msg.sender == feeRecipient) {
677                 require(_value.add(pendingAmount) <= balances[msg.sender]);
678                 pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
679             } else {
680                 fee = transferFee;
681                 require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
682                 pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
683             }
684 
685             pendingTransactions[currentNonce] = TransactionStruct(
686                 msg.sender,
687                 _to,
688                 _value,
689                 fee,
690                 address(0)
691             );
692 
693             emit RecordedPendingTransaction(msg.sender, _to, _value, fee, address(0), currentNonce);
694             currentNonce++;
695         }
696 
697         return true;
698     }
699 
700     /** @dev transferFrom
701       * @param _from address from which the tokens have to be transferred
702       * @param _to address to which the tokens have to be transferred
703       * @param _value amount of tokens to be transferred
704       */
705     function transferFrom(address _from, address _to, uint256 _value)
706         public 
707         checkIsInvestorApproved(_from)
708         checkIsInvestorApproved(_to)
709         checkIsValueValid(_value)
710         returns (bool)
711     {
712         if (tokenSwitch) {
713             super.transferFrom(_from, _to, _value);
714         } else {
715             uint256 allowedTransferAmount = allowed[_from][msg.sender];
716             uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
717             uint256 fee = 0;
718             
719             if (_from == feeRecipient) {
720                 require(_value.add(pendingAmount) <= balances[_from]);
721                 require(_value.add(pendingAmount) <= allowedTransferAmount);
722                 pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
723             } else {
724                 fee = transferFee;
725                 require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
726                 require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
727                 pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
728             }
729 
730             pendingTransactions[currentNonce] = TransactionStruct(
731                 _from,
732                 _to,
733                 _value,
734                 fee,
735                 msg.sender
736             );
737 
738             emit RecordedPendingTransaction(_from, _to, _value, fee, msg.sender, currentNonce);
739             currentNonce++;
740         }
741 
742         return true;
743     }
744 
745     /** @dev approve transfer/transferFrom request
746       * @param nonce request recorded at this particular nonce
747       */
748     function approveTransfer(uint256 nonce)
749         external 
750         onlyValidator
751     {   
752         require(_approveTransfer(nonce));
753     }    
754 
755     /** @dev reject transfer/transferFrom request
756       * @param nonce request recorded at this particular nonce
757       * @param reason reason for rejection
758       */
759     function rejectTransfer(uint256 nonce, uint256 reason)
760         external 
761         onlyValidator
762     {        
763         _rejectTransfer(nonce, reason);
764     }
765 
766     /** @dev approve transfer/transferFrom requests
767       * @param nonces request recorded at these nonces
768       */
769     function bulkApproveTransfers(uint256[] nonces)
770         external 
771         onlyValidator
772         returns (bool)
773     {
774         for (uint i = 0; i < nonces.length; i++) {
775             require(_approveTransfer(nonces[i]));
776         }
777     }
778 
779     /** @dev reject transfer/transferFrom request
780       * @param nonces requests recorded at these nonces
781       * @param reasons reasons for rejection
782       */
783     function bulkRejectTransfers(uint256[] nonces, uint256[] reasons)
784         external 
785         onlyValidator
786     {
787         require(nonces.length == reasons.length);
788         for (uint i = 0; i < nonces.length; i++) {
789             _rejectTransfer(nonces[i], reasons[i]);
790         }
791     }
792 
793     /** @dev approve transfer/transferFrom request called internally in the approveTransfer and bulkApproveTransfers functions
794       * @param nonce request recorded at this particular nonce
795       */
796     function _approveTransfer(uint256 nonce)
797         private
798         checkIsInvestorApproved(pendingTransactions[nonce].from)
799         checkIsInvestorApproved(pendingTransactions[nonce].to)
800         returns (bool)
801     {   
802         address from = pendingTransactions[nonce].from;
803         address to = pendingTransactions[nonce].to;
804         address spender = pendingTransactions[nonce].spender;
805         uint256 value = pendingTransactions[nonce].value;
806         uint256 fee = pendingTransactions[nonce].fee;
807 
808         delete pendingTransactions[nonce];
809 
810         if (fee == 0) {
811 
812             balances[from] = balances[from].sub(value);
813             balances[to] = balances[to].add(value);
814 
815             if (spender != address(0)) {
816                 allowed[from][spender] = allowed[from][spender].sub(value);
817             }
818 
819             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender].sub(value);
820 
821             emit Transfer(
822                 from,
823                 to,
824                 value
825             );
826 
827         } else {
828 
829             balances[from] = balances[from].sub(value.add(fee));
830             balances[to] = balances[to].add(value);
831             balances[feeRecipient] = balances[feeRecipient].add(fee);
832 
833             if (spender != address(0)) {
834                 allowed[from][spender] = allowed[from][spender].sub(value).sub(fee);
835             }
836 
837             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender].sub(value).sub(fee);
838             
839             emit TransferWithFee(
840                 from,
841                 to,
842                 value,
843                 fee
844             );
845 
846         }
847 
848         return true;
849     }    
850 
851     /** @dev reject transfer/transferFrom request called internally in the rejectTransfer and bulkRejectTransfers functions
852       * @param nonce request recorded at this particular nonce
853       * @param reason reason for rejection
854       */
855     function _rejectTransfer(uint256 nonce, uint256 reason)
856         private
857         checkIsAddressValid(pendingTransactions[nonce].from)
858     {        
859         address from = pendingTransactions[nonce].from;
860         address spender = pendingTransactions[nonce].spender;
861         uint256 value = pendingTransactions[nonce].value;
862 
863         if (pendingTransactions[nonce].fee == 0) {
864             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
865                 .sub(value);
866         } else {
867             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
868                 .sub(value).sub(pendingTransactions[nonce].fee);
869         }
870         
871         emit TransferRejected(
872             from,
873             pendingTransactions[nonce].to,
874             value,
875             nonce,
876             reason
877         );
878         
879         delete pendingTransactions[nonce];
880     }
881 }