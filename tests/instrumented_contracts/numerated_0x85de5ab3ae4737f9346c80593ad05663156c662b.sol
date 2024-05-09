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
496     */
497     event RecordedPendingTransaction(
498         address indexed from,
499         address indexed to,
500         uint256 value,
501         uint256 fee,
502         address indexed spender
503     );
504 
505     /**
506     * event for whitelist contract update logging
507     * @param _whiteListingContract address of the new whitelist contract
508     */
509     event WhiteListingContractSet(address indexed _whiteListingContract);
510 
511     /**
512     * event for fee update logging
513     * @param previousFee previous fee
514     * @param newFee new fee
515     */
516     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
517 
518     /**
519     * event for fee recipient update logging
520     * @param previousRecipient address of the old fee recipient
521     * @param newRecipient address of the new fee recipient
522     */
523     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
524 
525     /** @dev Constructor
526       * @param _owner Token contract owner
527       * @param _name Token name
528       * @param _symbol Token symbol
529       * @param _decimals number of decimals in the token(usually 18)
530       * @param whitelistAddress Ethereum address of the whitelist contract
531       * @param recipient Ethereum address of the fee recipient
532       * @param fee token fee for approving a transfer
533       */
534     constructor(
535         address _owner,
536         string _name, 
537         string _symbol, 
538         uint8 _decimals,
539         address whitelistAddress,
540         address recipient,
541         uint256 fee
542     )
543         public
544         MintableToken(_owner)
545         DetailedERC20(_name, _symbol, _decimals)
546         Validator()
547     {
548         setWhitelistContract(whitelistAddress);
549         setFeeRecipient(recipient);
550         setFee(fee);
551     }
552 
553     /** @dev Updates whitelist contract address
554       * @param whitelistAddress New whitelist contract address
555       */
556     function setWhitelistContract(address whitelistAddress)
557         public
558         onlyValidator
559         checkIsAddressValid(whitelistAddress)
560     {
561         whiteListingContract = Whitelist(whitelistAddress);
562         emit WhiteListingContractSet(whiteListingContract);
563     }
564 
565     /** @dev Updates token fee for approving a transfer
566       * @param fee New token fee
567       */
568     function setFee(uint256 fee)
569         public
570         onlyValidator
571     {
572         emit FeeSet(transferFee, fee);
573         transferFee = fee;
574     }
575 
576     /** @dev Updates fee recipient address
577       * @param recipient New whitelist contract address
578       */
579     function setFeeRecipient(address recipient)
580         public
581         onlyValidator
582         checkIsAddressValid(recipient)
583     {
584         emit FeeRecipientSet(feeRecipient, recipient);
585         feeRecipient = recipient;
586     }
587 
588     /** @dev Updates token name
589       * @param _name New token name
590       */
591     function updateName(string _name) public onlyOwner {
592         require(bytes(_name).length != 0);
593         name = _name;
594     }
595 
596     /** @dev Updates token symbol
597       * @param _symbol New token name
598       */
599     function updateSymbol(string _symbol) public onlyOwner {
600         require(bytes(_symbol).length != 0);
601         symbol = _symbol;
602     }
603 
604     /** @dev transfer request
605       * @param _to address to which the tokens have to be transferred
606       * @param _value amount of tokens to be transferred
607       */
608     function transfer(address _to, uint256 _value)
609         public
610         checkIsInvestorApproved(msg.sender)
611         checkIsInvestorApproved(_to)
612         checkIsValueValid(_value)
613         returns (bool)
614     {
615         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
616 
617         if (msg.sender == feeRecipient) {
618             require(_value.add(pendingAmount) <= balances[msg.sender]);
619             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
620         } else {
621             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
622             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
623         }
624 
625         pendingTransactions[currentNonce] = TransactionStruct(
626             msg.sender,
627             _to,
628             _value,
629             transferFee,
630             address(0)
631         );
632 
633         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
634         currentNonce++;
635 
636         return true;
637     }
638 
639     /** @dev transferFrom request
640       * @param _from address from which the tokens have to be transferred
641       * @param _to address to which the tokens have to be transferred
642       * @param _value amount of tokens to be transferred
643       */
644     function transferFrom(address _from, address _to, uint256 _value)
645         public 
646         checkIsInvestorApproved(_from)
647         checkIsInvestorApproved(_to)
648         checkIsValueValid(_value)
649         returns (bool)
650     {
651         uint256 allowedTransferAmount = allowed[_from][msg.sender];
652         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
653         
654         if (_from == feeRecipient) {
655             require(_value.add(pendingAmount) <= balances[_from]);
656             require(_value.add(pendingAmount) <= allowedTransferAmount);
657             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
658         } else {
659             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
660             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
661             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
662         }
663 
664         pendingTransactions[currentNonce] = TransactionStruct(
665             _from,
666             _to,
667             _value,
668             transferFee,
669             msg.sender
670         );
671 
672         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
673         currentNonce++;
674 
675         return true;
676     }
677 
678     /** @dev approve transfer/transferFrom request
679       * @param nonce request recorded at this particular nonce
680       */
681     function approveTransfer(uint256 nonce)
682         external 
683         onlyValidator 
684         checkIsInvestorApproved(pendingTransactions[nonce].from)
685         checkIsInvestorApproved(pendingTransactions[nonce].to)
686         checkIsValueValid(pendingTransactions[nonce].value)
687         returns (bool)
688     {   
689         address from = pendingTransactions[nonce].from;
690         address spender = pendingTransactions[nonce].spender;
691         address to = pendingTransactions[nonce].to;
692         uint256 value = pendingTransactions[nonce].value;
693         uint256 allowedTransferAmount = allowed[from][spender];
694         uint256 pendingAmount = pendingApprovalAmount[from][spender];
695         uint256 fee = pendingTransactions[nonce].fee;
696         uint256 balanceFrom = balances[from];
697         uint256 balanceTo = balances[to];
698 
699         delete pendingTransactions[nonce];
700 
701         if (from == feeRecipient) {
702             fee = 0;
703             balanceFrom = balanceFrom.sub(value);
704             balanceTo = balanceTo.add(value);
705 
706             if (spender != address(0)) {
707                 allowedTransferAmount = allowedTransferAmount.sub(value);
708             } 
709             pendingAmount = pendingAmount.sub(value);
710 
711         } else {
712             balanceFrom = balanceFrom.sub(value.add(fee));
713             balanceTo = balanceTo.add(value);
714             balances[feeRecipient] = balances[feeRecipient].add(fee);
715 
716             if (spender != address(0)) {
717                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
718             }
719             pendingAmount = pendingAmount.sub(value).sub(fee);
720         }
721 
722         emit TransferWithFee(
723             from,
724             to,
725             value,
726             fee
727         );
728 
729         emit Transfer(
730             from,
731             to,
732             value
733         );
734         
735         balances[from] = balanceFrom;
736         balances[to] = balanceTo;
737         allowed[from][spender] = allowedTransferAmount;
738         pendingApprovalAmount[from][spender] = pendingAmount;
739         return true;
740     }
741 
742     /** @dev reject transfer/transferFrom request
743       * @param nonce request recorded at this particular nonce
744       * @param reason reason for rejection
745       */
746     function rejectTransfer(uint256 nonce, uint256 reason)
747         external 
748         onlyValidator
749         checkIsAddressValid(pendingTransactions[nonce].from)
750     {        
751         address from = pendingTransactions[nonce].from;
752         address spender = pendingTransactions[nonce].spender;
753 
754         if (from == feeRecipient) {
755             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
756                 .sub(pendingTransactions[nonce].value);
757         } else {
758             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
759                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
760         }
761         
762         emit TransferRejected(
763             from,
764             pendingTransactions[nonce].to,
765             pendingTransactions[nonce].value,
766             nonce,
767             reason
768         );
769         
770         delete pendingTransactions[nonce];
771     }
772 }
773 
774 
775 /**
776  * @title Crowdsale
777  * @dev Crowdsale is a base contract for managing a token crowdsale.
778  * Crowdsales have a start and end timestamps, where investors can make
779  * token purchases and the crowdsale will assign them tokens based
780  * on a token per ETH rate. Funds collected are forwarded to a wallet
781  * as they arrive. The contract requires a MintableToken that will be
782  * minted as contributions arrive, note that the crowdsale contract
783  * must be owner of the token in order to be able to mint it.
784  */
785 contract Crowdsale {
786     using SafeMath for uint256;
787 
788     // The token being sold
789     MintableToken public token;
790 
791     // start and end timestamps where investments are allowed (both inclusive)
792     uint256 public startTime;
793     uint256 public endTime;
794 
795     // address where funds are collected
796     address public wallet;
797 
798     // how many token units a buyer gets per wei
799     uint256 public rate;
800 
801     // amount of raised money in wei
802     uint256 public weiRaised;
803 
804     // amount of tokens sold
805     uint256 public totalSupply;
806 
807     // maximum amount of tokens that can be sold
808     uint256 public tokenCap;
809 
810     /**
811     * event for token purchase logging
812     * @param purchaser who paid for the tokens
813     * @param beneficiary who got the tokens
814     * @param value weis paid for purchase
815     * @param amount amount of tokens purchased
816     */
817     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
818 
819 
820     constructor(uint256 _startTime, uint256 _endTime, uint256 _tokenCap, uint256 _rate, address _wallet, MintableToken _token) public {
821         require(_startTime >= now);
822         require(_endTime >= _startTime);
823         require(_rate > 0);
824         require(_wallet != address(0));
825         require(_token != address(0));
826 
827         startTime = _startTime;
828         endTime = _endTime;
829         tokenCap = _tokenCap;
830         rate = _rate;
831         wallet = _wallet;
832         token = _token;
833     }
834 
835     // fallback function can be used to buy tokens
836     function () external payable {
837         buyTokens(msg.sender);
838     }
839 
840     // low level token purchase function
841     function buyTokens(address beneficiary) public payable {
842         require(beneficiary != address(0));
843         require(validPurchase());
844 
845         uint256 weiAmount = msg.value;
846 
847         // calculate token amount to be created
848         uint256 tokens = getTokenAmount(weiAmount);
849 
850         // update state
851         weiRaised = weiRaised.add(weiAmount);
852         totalSupply = totalSupply.add(tokens);
853 
854         token.mint(beneficiary, tokens);
855         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
856 
857         forwardFunds();
858     }
859 
860     // @return true if crowdsale event has ended
861     function hasEnded() public view returns (bool) {
862         return now > endTime;
863     }
864 
865     // Override this method to have a way to add business logic to your crowdsale when buying
866     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
867         return weiAmount.mul(rate);
868     }
869 
870     // send ether to the fund collection wallet
871     // override to create custom fund forwarding mechanisms
872     function forwardFunds() internal {
873         wallet.transfer(msg.value);
874     }
875 
876     // @return true if the transaction can buy tokens
877     function validPurchase() internal view returns (bool) {
878         uint256 tokens = msg.value.mul(rate);
879         require(totalSupply.add(tokens) <= tokenCap);
880         bool withinPeriod = now >= startTime && now <= endTime;
881         bool nonZeroPurchase = msg.value != 0;
882         return withinPeriod && nonZeroPurchase;
883     }
884 
885 }
886 
887 
888 /**
889  * @title FinalizableCrowdsale
890  * @dev Extension of Crowdsale where an owner can do extra work
891  * after finishing.
892  */
893 contract FinalizableCrowdsale is Crowdsale, Ownable {
894     using SafeMath for uint256;
895 
896     bool public isFinalized = false;
897 
898     event Finalized();
899  
900     constructor(address _owner) public Ownable(_owner) {}
901 
902     /**
903     * @dev Must be called after crowdsale ends, to do some extra finalization
904     * work. Calls the contract's finalization function.
905     */
906     function finalize() onlyOwner public {
907         require(!isFinalized);
908         require(hasEnded());
909 
910         finalization();
911         emit Finalized();
912 
913         isFinalized = true;
914     }
915 
916     /**
917     * @dev Can be overridden to add finalization logic. The overriding function
918     * should call super.finalization() to ensure the chain of finalization is
919     * executed entirely.
920     */
921     function finalization() internal {}
922 }
923 
924 
925 /** @title Compliant Crowdsale */
926 contract CompliantCrowdsale is Validator, FinalizableCrowdsale {
927     Whitelist public whiteListingContract;
928 
929     struct MintStruct {
930         address to;
931         uint256 tokens;
932         uint256 weiAmount;
933     }
934 
935     mapping (uint => MintStruct) public pendingMints;
936     uint256 public currentMintNonce;
937     mapping (address => uint) public rejectedMintBalance;
938 
939     modifier checkIsInvestorApproved(address _account) {
940         require(whiteListingContract.isInvestorApproved(_account));
941         _;
942     }
943 
944     modifier checkIsAddressValid(address _account) {
945         require(_account != address(0));
946         _;
947     }
948 
949     /**
950     * event for rejected mint logging
951     * @param to address for which buy tokens got rejected
952     * @param value number of tokens
953     * @param amount number of ethers invested
954     * @param nonce request recorded at this particular nonce
955     * @param reason reason for rejection
956     */
957     event MintRejected(
958         address indexed to,
959         uint256 value,
960         uint256 amount,
961         uint256 indexed nonce,
962         uint256 reason
963     );
964 
965     /**
966     * event for buy tokens request logging
967     * @param beneficiary address for which buy tokens is requested
968     * @param tokens number of tokens
969     * @param weiAmount number of ethers invested
970     * @param nonce request recorded at this particular nonce
971     */
972     event ContributionRegistered(
973         address beneficiary,
974         uint256 tokens,
975         uint256 weiAmount,
976         uint256 nonce
977     );
978 
979     /**
980     * event for whitelist contract update logging
981     * @param _whiteListingContract address of the new whitelist contract
982     */
983     event WhiteListingContractSet(address indexed _whiteListingContract);
984 
985     /**
986     * event for claimed ether logging
987     * @param account user claiming the ether
988     * @param amount ether claimed
989     */
990     event Claimed(address indexed account, uint256 amount);
991 
992     /** @dev Constructor
993       * @param whitelistAddress Ethereum address of the whitelist contract
994       * @param _startTime crowdsale start time
995       * @param _endTime crowdsale end time
996       * @param _tokenCap maximum number of tokens to be sold in the crowdsale
997       * @param _rate number of tokens to be sold per ether
998       * @param _wallet Ethereum address of the wallet
999       * @param _token Ethereum address of the token contract
1000       * @param _owner Ethereum address of the owner
1001       */
1002     constructor(
1003         address whitelistAddress,
1004         uint256 _startTime,
1005         uint256 _endTime,
1006         uint256 _tokenCap,
1007         uint256 _rate,
1008         address _wallet,
1009         MintableToken _token,
1010         address _owner
1011     )
1012         public
1013         FinalizableCrowdsale(_owner)
1014         Crowdsale(_startTime, _endTime, _tokenCap, _rate, _wallet, _token)
1015     {
1016         setWhitelistContract(whitelistAddress);
1017     }
1018 
1019     /** @dev Updates whitelist contract address
1020       * @param whitelistAddress address of the new whitelist contract 
1021       */
1022     function setWhitelistContract(address whitelistAddress)
1023         public 
1024         onlyValidator 
1025         checkIsAddressValid(whitelistAddress)
1026     {
1027         whiteListingContract = Whitelist(whitelistAddress);
1028         emit WhiteListingContractSet(whiteListingContract);
1029     }
1030 
1031     /** @dev buy tokens request
1032       * @param beneficiary the address to which the tokens have to be minted
1033       */
1034     function buyTokens(address beneficiary)
1035         public 
1036         payable
1037         checkIsInvestorApproved(beneficiary)
1038     {
1039         require(validPurchase());
1040 
1041         uint256 weiAmount = msg.value;
1042 
1043         // calculate token amount to be created
1044         uint256 tokens = weiAmount.mul(rate);
1045 
1046         pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount);
1047         emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce);
1048 
1049         currentMintNonce++;
1050     }
1051 
1052     /** @dev approve buy tokens request
1053       * @param nonce request recorded at this particular nonce
1054       */
1055     function approveMint(uint256 nonce)
1056         external 
1057         onlyValidator 
1058         checkIsInvestorApproved(pendingMints[nonce].to)
1059         returns (bool)
1060     {
1061         // update state
1062         weiRaised = weiRaised.add(pendingMints[nonce].weiAmount);
1063         totalSupply = totalSupply.add(pendingMints[nonce].tokens);
1064 
1065         //No need to use mint-approval on token side, since the minting is already approved in the crowdsale side
1066         token.mint(pendingMints[nonce].to, pendingMints[nonce].tokens);
1067         
1068         emit TokenPurchase(
1069             msg.sender,
1070             pendingMints[nonce].to,
1071             pendingMints[nonce].weiAmount,
1072             pendingMints[nonce].tokens
1073         );
1074 
1075         forwardFunds(pendingMints[nonce].weiAmount);
1076         delete pendingMints[nonce];
1077 
1078         return true;
1079     }
1080 
1081     /** @dev reject buy tokens request
1082       * @param nonce request recorded at this particular nonce
1083       * @param reason reason for rejection
1084       */
1085     function rejectMint(uint256 nonce, uint256 reason)
1086         external 
1087         onlyValidator 
1088         checkIsAddressValid(pendingMints[nonce].to)
1089     {
1090         rejectedMintBalance[pendingMints[nonce].to] = rejectedMintBalance[pendingMints[nonce].to].add(pendingMints[nonce].weiAmount);
1091         
1092         emit MintRejected(
1093             pendingMints[nonce].to,
1094             pendingMints[nonce].tokens,
1095             pendingMints[nonce].weiAmount,
1096             nonce,
1097             reason
1098         );
1099         
1100         delete pendingMints[nonce];
1101     }
1102 
1103     /** @dev claim back ether if buy tokens request is rejected */
1104     function claim() external {
1105         require(rejectedMintBalance[msg.sender] > 0);
1106         uint256 value = rejectedMintBalance[msg.sender];
1107         rejectedMintBalance[msg.sender] = 0;
1108 
1109         msg.sender.transfer(value);
1110 
1111         emit Claimed(msg.sender, value);
1112     }
1113 
1114     function finalization() internal {
1115         token.finishMinting();
1116         transferTokenOwnership(owner);
1117         super.finalization();
1118     }
1119 
1120     /** @dev Updates token contract address
1121       * @param newToken New token contract address
1122       */
1123     function setTokenContract(address newToken)
1124         external 
1125         onlyOwner
1126         checkIsAddressValid(newToken)
1127     {
1128         token = CompliantToken(newToken);
1129     }
1130 
1131     /** @dev transfers ownership of the token contract
1132       * @param newOwner New owner of the token contract
1133       */
1134     function transferTokenOwnership(address newOwner)
1135         public 
1136         onlyOwner
1137         checkIsAddressValid(newOwner)
1138     {
1139         token.transferOwnership(newOwner);
1140     }
1141 
1142     function forwardFunds(uint256 amount) internal {
1143         wallet.transfer(amount);
1144     }
1145 }