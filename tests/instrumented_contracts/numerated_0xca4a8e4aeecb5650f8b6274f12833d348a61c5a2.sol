1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63     * account.
64     */
65     constructor(address _owner) public {
66         owner = _owner;
67     }
68 
69     /**
70     * @dev Throws if called by any account other than the owner.
71     */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78     * @dev Allows the current owner to transfer control of the contract to a newOwner.
79     * @param newOwner The address to transfer ownership to.
80     */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 
90 contract Whitelist is Ownable {
91     mapping(address => bool) internal investorMap;
92 
93     /**
94     * event for investor approval logging
95     * @param investor approved investor
96     */
97     event Approved(address indexed investor);
98 
99     /**
100     * event for investor disapproval logging
101     * @param investor disapproved investor
102     */
103     event Disapproved(address indexed investor);
104 
105     constructor(address _owner) 
106         public 
107         Ownable(_owner) 
108     {
109         
110     }
111 
112     /** @param _investor the address of investor to be checked
113       * @return true if investor is approved
114       */
115     function isInvestorApproved(address _investor) external view returns (bool) {
116         require(_investor != address(0));
117         return investorMap[_investor];
118     }
119 
120     /** @dev approve an investor
121       * @param toApprove investor to be approved
122       */
123     function approveInvestor(address toApprove) external onlyOwner {
124         investorMap[toApprove] = true;
125         emit Approved(toApprove);
126     }
127 
128     /** @dev approve investors in bulk
129       * @param toApprove array of investors to be approved
130       */
131     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
132         for (uint i = 0; i < toApprove.length; i++) {
133             investorMap[toApprove[i]] = true;
134             emit Approved(toApprove[i]);
135         }
136     }
137 
138     /** @dev disapprove an investor
139       * @param toDisapprove investor to be disapproved
140       */
141     function disapproveInvestor(address toDisapprove) external onlyOwner {
142         delete investorMap[toDisapprove];
143         emit Disapproved(toDisapprove);
144     }
145 
146     /** @dev disapprove investors in bulk
147       * @param toDisapprove array of investors to be disapproved
148       */
149     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
150         for (uint i = 0; i < toDisapprove.length; i++) {
151             delete investorMap[toDisapprove[i]];
152             emit Disapproved(toDisapprove[i]);
153         }
154     }
155 }
156 
157 
158 /**
159  * @title Validator
160  * @dev The Validator contract has a validator address, and provides basic authorization control
161  * functions, this simplifies the implementation of "user permissions".
162  */
163 contract Validator {
164     address public validator;
165 
166     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
167 
168     /**
169     * @dev The Validator constructor sets the original `validator` of the contract to the sender
170     * account.
171     */
172     constructor() public {
173         validator = msg.sender;
174     }
175 
176     /**
177     * @dev Throws if called by any account other than the validator.
178     */
179     modifier onlyValidator() {
180         require(msg.sender == validator);
181         _;
182     }
183 
184     /**
185     * @dev Allows the current validator to transfer control of the contract to a newValidator.
186     * @param newValidator The address to become next validator.
187     */
188     function setNewValidator(address newValidator) public onlyValidator {
189         require(newValidator != address(0));
190         emit NewValidatorSet(validator, newValidator);
191         validator = newValidator;
192     }
193 }
194 
195 
196 /**
197  * @title ERC20Basic
198  * @dev Simpler version of ERC20 interface
199  * @dev see https://github.com/ethereum/EIPs/issues/179
200  */
201 contract ERC20Basic {
202   function totalSupply() public view returns (uint256);
203   function balanceOf(address who) public view returns (uint256);
204   function transfer(address to, uint256 value) public returns (bool);
205   event Transfer(address indexed from, address indexed to, uint256 value);
206 }
207 
208 
209 /**
210  * @title ERC20 interface
211  * @dev see https://github.com/ethereum/EIPs/issues/20
212  */
213 contract ERC20 is ERC20Basic {
214   function allowance(address owner, address spender) public view returns (uint256);
215   function transferFrom(address from, address to, uint256 value) public returns (bool);
216   function approve(address spender, uint256 value) public returns (bool);
217   event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 
221 /**
222  * @title Basic token
223  * @dev Basic version of StandardToken, with no allowances.
224  */
225 contract BasicToken is ERC20Basic {
226   using SafeMath for uint256;
227 
228   mapping(address => uint256) balances;
229 
230   uint256 totalSupply_;
231 
232   /**
233   * @dev total number of tokens in existence
234   */
235   function totalSupply() public view returns (uint256) {
236     return totalSupply_;
237   }
238 
239   /**
240   * @dev transfer token for a specified address
241   * @param _to The address to transfer to.
242   * @param _value The amount to be transferred.
243   */
244   function transfer(address _to, uint256 _value) public returns (bool) {
245     require(_to != address(0));
246     require(_value <= balances[msg.sender]);
247 
248     // SafeMath.sub will throw if there is not enough balance.
249     balances[msg.sender] = balances[msg.sender].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     emit Transfer(msg.sender, _to, _value);
252     return true;
253   }
254 
255   /**
256   * @dev Gets the balance of the specified address.
257   * @param _owner The address to query the the balance of.
258   * @return An uint256 representing the amount owned by the passed address.
259   */
260   function balanceOf(address _owner) public view returns (uint256 balance) {
261     return balances[_owner];
262   }
263 
264 }
265 
266 
267 /**
268  * @title Standard ERC20 token
269  *
270  * @dev Implementation of the basic standard token.
271  * @dev https://github.com/ethereum/EIPs/issues/20
272  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
273  */
274 contract StandardToken is ERC20, BasicToken {
275 
276   mapping (address => mapping (address => uint256)) internal allowed;
277 
278 
279   /**
280    * @dev Transfer tokens from one address to another
281    * @param _from address The address which you want to send tokens from
282    * @param _to address The address which you want to transfer to
283    * @param _value uint256 the amount of tokens to be transferred
284    */
285   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
286     require(_to != address(0));
287     require(_value <= balances[_from]);
288     require(_value <= allowed[_from][msg.sender]);
289 
290     balances[_from] = balances[_from].sub(_value);
291     balances[_to] = balances[_to].add(_value);
292     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
293     emit Transfer(_from, _to, _value);
294     return true;
295   }
296 
297   /**
298    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
299    *
300    * Beware that changing an allowance with this method brings the risk that someone may use both the old
301    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
302    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
303    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304    * @param _spender The address which will spend the funds.
305    * @param _value The amount of tokens to be spent.
306    */
307   function approve(address _spender, uint256 _value) public returns (bool) {
308     allowed[msg.sender][_spender] = _value;
309     emit Approval(msg.sender, _spender, _value);
310     return true;
311   }
312 
313   /**
314    * @dev Function to check the amount of tokens that an owner allowed to a spender.
315    * @param _owner address The address which owns the funds.
316    * @param _spender address The address which will spend the funds.
317    * @return A uint256 specifying the amount of tokens still available for the spender.
318    */
319   function allowance(address _owner, address _spender) public view returns (uint256) {
320     return allowed[_owner][_spender];
321   }
322 
323   /**
324    * @dev Increase the amount of tokens that an owner allowed to a spender.
325    *
326    * approve should be called when allowed[_spender] == 0. To increment
327    * allowed value is better to use this function to avoid 2 calls (and wait until
328    * the first transaction is mined)
329    * From MonolithDAO Token.sol
330    * @param _spender The address which will spend the funds.
331    * @param _addedValue The amount of tokens to increase the allowance by.
332    */
333   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
334     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339   /**
340    * @dev Decrease the amount of tokens that an owner allowed to a spender.
341    *
342    * approve should be called when allowed[_spender] == 0. To decrement
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param _spender The address which will spend the funds.
347    * @param _subtractedValue The amount of tokens to decrease the allowance by.
348    */
349   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
350     uint oldValue = allowed[msg.sender][_spender];
351     if (_subtractedValue > oldValue) {
352       allowed[msg.sender][_spender] = 0;
353     } else {
354       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
355     }
356     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
357     return true;
358   }
359 
360 }
361 
362 
363 /**
364  * @title Mintable token
365  * @dev Simple ERC20 Token example, with mintable token creation
366  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
367  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
368  */
369 contract MintableToken is StandardToken, Ownable {
370     event Mint(address indexed to, uint256 amount);
371     event MintFinished();
372 
373     bool public mintingFinished = false;
374 
375 
376     modifier canMint() {
377         require(!mintingFinished);
378         _;
379     }
380 
381     constructor(address _owner) 
382         public 
383         Ownable(_owner) 
384     {
385     }
386 
387     /**
388     * @dev Function to mint tokens
389     * @param _to The address that will receive the minted tokens.
390     * @param _amount The amount of tokens to mint.
391     * @return A boolean that indicates if the operation was successful.
392     */
393     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
394         totalSupply_ = totalSupply_.add(_amount);
395         balances[_to] = balances[_to].add(_amount);
396         emit Mint(_to, _amount);
397         emit Transfer(address(0), _to, _amount);
398         return true;
399     }
400 
401     /**
402     * @dev Function to stop minting new tokens.
403     * @return True if the operation was successful.
404     */
405     function finishMinting() onlyOwner canMint public returns (bool) {
406         mintingFinished = true;
407         emit MintFinished();
408         return true;
409     }
410 }
411 
412 
413 contract DetailedERC20 {
414   string public name;
415   string public symbol;
416   uint8 public decimals;
417 
418   constructor(string _name, string _symbol, uint8 _decimals) public {
419     name = _name;
420     symbol = _symbol;
421     decimals = _decimals;
422   }
423 }
424 
425 
426 /** @title Compliant Token */
427 contract CompliantToken is Validator, DetailedERC20, MintableToken {
428     Whitelist public whiteListingContract;
429 
430     struct TransactionStruct {
431         address from;
432         address to;
433         uint256 value;
434         uint256 fee;
435         address spender;
436     }
437 
438     mapping (uint => TransactionStruct) public pendingTransactions;
439     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
440     uint256 public currentNonce = 0;
441     uint256 public transferFee;
442     address public feeRecipient;
443 
444     modifier checkIsInvestorApproved(address _account) {
445         require(whiteListingContract.isInvestorApproved(_account));
446         _;
447     }
448 
449     modifier checkIsAddressValid(address _account) {
450         require(_account != address(0));
451         _;
452     }
453 
454     modifier checkIsValueValid(uint256 _value) {
455         require(_value > 0);
456         _;
457     }
458 
459     /**
460     * event for rejected transfer logging
461     * @param from address from which tokens have to be transferred
462     * @param to address to tokens have to be transferred
463     * @param value number of tokens
464     * @param nonce request recorded at this particular nonce
465     * @param reason reason for rejection
466     */
467     event TransferRejected(
468         address indexed from,
469         address indexed to,
470         uint256 value,
471         uint256 indexed nonce,
472         uint256 reason
473     );
474 
475     /**
476     * event for transfer tokens logging
477     * @param from address from which tokens have to be transferred
478     * @param to address to tokens have to be transferred
479     * @param value number of tokens
480     * @param fee fee in tokens
481     */
482     event TransferWithFee(
483         address indexed from,
484         address indexed to,
485         uint256 value,
486         uint256 fee
487     );
488 
489     /**
490     * event for transfer/transferFrom request logging
491     * @param from address from which tokens have to be transferred
492     * @param to address to tokens have to be transferred
493     * @param value number of tokens
494     * @param fee fee in tokens
495     * @param spender The address which will spend the tokens
496     * @param nonce request recorded at this particular nonce
497     */
498     event RecordedPendingTransaction(
499         address indexed from,
500         address indexed to,
501         uint256 value,
502         uint256 fee,
503         address indexed spender,
504         uint256 nonce
505     );
506 
507     /**
508     * event for whitelist contract update logging
509     * @param _whiteListingContract address of the new whitelist contract
510     */
511     event WhiteListingContractSet(address indexed _whiteListingContract);
512 
513     /**
514     * event for fee update logging
515     * @param previousFee previous fee
516     * @param newFee new fee
517     */
518     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
519 
520     /**
521     * event for fee recipient update logging
522     * @param previousRecipient address of the old fee recipient
523     * @param newRecipient address of the new fee recipient
524     */
525     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
526 
527     /** @dev Constructor
528       * @param _owner Token contract owner
529       * @param _name Token name
530       * @param _symbol Token symbol
531       * @param _decimals number of decimals in the token(usually 18)
532       * @param whitelistAddress Ethereum address of the whitelist contract
533       * @param recipient Ethereum address of the fee recipient
534       * @param fee token fee for approving a transfer
535       */
536     constructor(
537         address _owner,
538         string _name, 
539         string _symbol, 
540         uint8 _decimals,
541         address whitelistAddress,
542         address recipient,
543         uint256 fee
544     )
545         public
546         MintableToken(_owner)
547         DetailedERC20(_name, _symbol, _decimals)
548         Validator()
549     {
550         setWhitelistContract(whitelistAddress);
551         setFeeRecipient(recipient);
552         setFee(fee);
553     }
554 
555     /** @dev Updates whitelist contract address
556       * @param whitelistAddress New whitelist contract address
557       */
558     function setWhitelistContract(address whitelistAddress)
559         public
560         onlyValidator
561         checkIsAddressValid(whitelistAddress)
562     {
563         whiteListingContract = Whitelist(whitelistAddress);
564         emit WhiteListingContractSet(whiteListingContract);
565     }
566 
567     /** @dev Updates token fee for approving a transfer
568       * @param fee New token fee
569       */
570     function setFee(uint256 fee)
571         public
572         onlyValidator
573     {
574         emit FeeSet(transferFee, fee);
575         transferFee = fee;
576     }
577 
578     /** @dev Updates fee recipient address
579       * @param recipient New whitelist contract address
580       */
581     function setFeeRecipient(address recipient)
582         public
583         onlyValidator
584         checkIsAddressValid(recipient)
585     {
586         emit FeeRecipientSet(feeRecipient, recipient);
587         feeRecipient = recipient;
588     }
589 
590     /** @dev Updates token name
591       * @param _name New token name
592       */
593     function updateName(string _name) public onlyOwner {
594         require(bytes(_name).length != 0);
595         name = _name;
596     }
597 
598     /** @dev Updates token symbol
599       * @param _symbol New token name
600       */
601     function updateSymbol(string _symbol) public onlyOwner {
602         require(bytes(_symbol).length != 0);
603         symbol = _symbol;
604     }
605 
606     /** @dev transfer request
607       * @param _to address to which the tokens have to be transferred
608       * @param _value amount of tokens to be transferred
609       */
610     function transfer(address _to, uint256 _value)
611         public
612         checkIsInvestorApproved(msg.sender)
613         checkIsInvestorApproved(_to)
614         checkIsValueValid(_value)
615         returns (bool)
616     {
617         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
618 
619         if (msg.sender == feeRecipient) {
620             require(_value.add(pendingAmount) <= balances[msg.sender]);
621             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
622         } else {
623             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
624             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
625         }
626 
627         pendingTransactions[currentNonce] = TransactionStruct(
628             msg.sender,
629             _to,
630             _value,
631             transferFee,
632             address(0)
633         );
634 
635         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0), currentNonce);
636         currentNonce++;
637 
638         return true;
639     }
640 
641     /** @dev transferFrom request
642       * @param _from address from which the tokens have to be transferred
643       * @param _to address to which the tokens have to be transferred
644       * @param _value amount of tokens to be transferred
645       */
646     function transferFrom(address _from, address _to, uint256 _value)
647         public 
648         checkIsInvestorApproved(_from)
649         checkIsInvestorApproved(_to)
650         checkIsValueValid(_value)
651         returns (bool)
652     {
653         uint256 allowedTransferAmount = allowed[_from][msg.sender];
654         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
655         
656         if (_from == feeRecipient) {
657             require(_value.add(pendingAmount) <= balances[_from]);
658             require(_value.add(pendingAmount) <= allowedTransferAmount);
659             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
660         } else {
661             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
662             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
663             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
664         }
665 
666         pendingTransactions[currentNonce] = TransactionStruct(
667             _from,
668             _to,
669             _value,
670             transferFee,
671             msg.sender
672         );
673 
674         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender, currentNonce);
675         currentNonce++;
676 
677         return true;
678     }
679 
680     /** @dev approve transfer/transferFrom request
681       * @param nonce request recorded at this particular nonce
682       */
683     function approveTransfer(uint256 nonce)
684         external 
685         onlyValidator 
686         checkIsInvestorApproved(pendingTransactions[nonce].from)
687         checkIsInvestorApproved(pendingTransactions[nonce].to)
688         checkIsValueValid(pendingTransactions[nonce].value)
689         returns (bool)
690     {   
691         address from = pendingTransactions[nonce].from;
692         address spender = pendingTransactions[nonce].spender;
693         address to = pendingTransactions[nonce].to;
694         uint256 value = pendingTransactions[nonce].value;
695         uint256 allowedTransferAmount = allowed[from][spender];
696         uint256 pendingAmount = pendingApprovalAmount[from][spender];
697         uint256 fee = pendingTransactions[nonce].fee;
698         uint256 balanceFrom = balances[from];
699         uint256 balanceTo = balances[to];
700 
701         delete pendingTransactions[nonce];
702 
703         if (from == feeRecipient) {
704             fee = 0;
705             balanceFrom = balanceFrom.sub(value);
706             balanceTo = balanceTo.add(value);
707 
708             if (spender != address(0)) {
709                 allowedTransferAmount = allowedTransferAmount.sub(value);
710             } 
711             pendingAmount = pendingAmount.sub(value);
712 
713         } else {
714             balanceFrom = balanceFrom.sub(value.add(fee));
715             balanceTo = balanceTo.add(value);
716             balances[feeRecipient] = balances[feeRecipient].add(fee);
717 
718             if (spender != address(0)) {
719                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
720             }
721             pendingAmount = pendingAmount.sub(value).sub(fee);
722         }
723 
724         emit TransferWithFee(
725             from,
726             to,
727             value,
728             fee
729         );
730 
731         emit Transfer(
732             from,
733             to,
734             value
735         );
736         
737         balances[from] = balanceFrom;
738         balances[to] = balanceTo;
739         allowed[from][spender] = allowedTransferAmount;
740         pendingApprovalAmount[from][spender] = pendingAmount;
741         return true;
742     }
743 
744     /** @dev reject transfer/transferFrom request
745       * @param nonce request recorded at this particular nonce
746       * @param reason reason for rejection
747       */
748     function rejectTransfer(uint256 nonce, uint256 reason)
749         external 
750         onlyValidator
751         checkIsAddressValid(pendingTransactions[nonce].from)
752     {        
753         address from = pendingTransactions[nonce].from;
754         address spender = pendingTransactions[nonce].spender;
755 
756         if (from == feeRecipient) {
757             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
758                 .sub(pendingTransactions[nonce].value);
759         } else {
760             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
761                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
762         }
763         
764         emit TransferRejected(
765             from,
766             pendingTransactions[nonce].to,
767             pendingTransactions[nonce].value,
768             nonce,
769             reason
770         );
771         
772         delete pendingTransactions[nonce];
773     }
774 }