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
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   /**
50   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74     address public owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80     * account.
81     */
82     constructor(address _owner) public {
83         owner = _owner;
84     }
85 
86     /**
87     * @dev Throws if called by any account other than the owner.
88     */
89     modifier onlyOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     /**
95     * @dev Allows the current owner to transfer control of the contract to a newOwner.
96     * @param newOwner The address to transfer ownership to.
97     */
98     function transferOwnership(address newOwner) public onlyOwner {
99         require(newOwner != address(0));
100         emit OwnershipTransferred(owner, newOwner);
101         owner = newOwner;
102     }
103 
104 }
105 
106 
107 contract Whitelist is Ownable {
108     mapping(address => bool) internal investorMap;
109 
110     /**
111     * event for investor approval logging
112     * @param investor approved investor
113     */
114     event Approved(address indexed investor);
115 
116     /**
117     * event for investor disapproval logging
118     * @param investor disapproved investor
119     */
120     event Disapproved(address indexed investor);
121 
122     constructor(address _owner) 
123         public 
124         Ownable(_owner) 
125     {
126         
127     }
128 
129     /** @param _investor the address of investor to be checked
130       * @return true if investor is approved
131       */
132     function isInvestorApproved(address _investor) external view returns (bool) {
133         require(_investor != address(0));
134         return investorMap[_investor];
135     }
136 
137     /** @dev approve an investor
138       * @param toApprove investor to be approved
139       */
140     function approveInvestor(address toApprove) external onlyOwner {
141         investorMap[toApprove] = true;
142         emit Approved(toApprove);
143     }
144 
145     /** @dev approve investors in bulk
146       * @param toApprove array of investors to be approved
147       */
148     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
149         for (uint i = 0; i < toApprove.length; i++) {
150             investorMap[toApprove[i]] = true;
151             emit Approved(toApprove[i]);
152         }
153     }
154 
155     /** @dev disapprove an investor
156       * @param toDisapprove investor to be disapproved
157       */
158     function disapproveInvestor(address toDisapprove) external onlyOwner {
159         delete investorMap[toDisapprove];
160         emit Disapproved(toDisapprove);
161     }
162 
163     /** @dev disapprove investors in bulk
164       * @param toDisapprove array of investors to be disapproved
165       */
166     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
167         for (uint i = 0; i < toDisapprove.length; i++) {
168             delete investorMap[toDisapprove[i]];
169             emit Disapproved(toDisapprove[i]);
170         }
171     }
172 }
173 
174 
175 /**
176  * @title Validator
177  * @dev The Validator contract has a validator address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Validator {
181     address public validator;
182 
183     /**
184     * event for validator address update logging
185     * @param previousOwner address of the old validator
186     * @param newValidator address of the new validator
187     */
188     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
189 
190     /**
191     * @dev The Validator constructor sets the original `validator` of the contract to the sender
192     * account.
193     */
194     constructor() public {
195         validator = msg.sender;
196     }
197 
198     /**
199     * @dev Throws if called by any account other than the validator.
200     */
201     modifier onlyValidator() {
202         require(msg.sender == validator);
203         _;
204     }
205 
206     /**
207     * @dev Allows the current validator to transfer control of the contract to a newValidator.
208     * @param newValidator The address to become next validator.
209     */
210     function setNewValidator(address newValidator) public onlyValidator {
211         require(newValidator != address(0));
212         emit NewValidatorSet(validator, newValidator);
213         validator = newValidator;
214     }
215 }
216 
217 
218 /**
219  * @title ERC20Basic
220  * @dev Simpler version of ERC20 interface
221  * @dev see https://github.com/ethereum/EIPs/issues/179
222  */
223 contract ERC20Basic {
224   function totalSupply() public view returns (uint256);
225   function balanceOf(address who) public view returns (uint256);
226   function transfer(address to, uint256 value) public returns (bool);
227   event Transfer(address indexed from, address indexed to, uint256 value);
228 }
229 
230 
231 /**
232  * @title ERC20 interface
233  * @dev see https://github.com/ethereum/EIPs/issues/20
234  */
235 contract ERC20 is ERC20Basic {
236   function allowance(address owner, address spender) public view returns (uint256);
237   function transferFrom(address from, address to, uint256 value) public returns (bool);
238   function approve(address spender, uint256 value) public returns (bool);
239   event Approval(address indexed owner, address indexed spender, uint256 value);
240 }
241 
242 
243 /**
244  * @title Basic token
245  * @dev Basic version of StandardToken, with no allowances.
246  */
247 contract BasicToken is ERC20Basic {
248   using SafeMath for uint256;
249 
250   mapping(address => uint256) balances;
251 
252   uint256 totalSupply_;
253 
254   /**
255   * @dev total number of tokens in existence
256   */
257   function totalSupply() public view returns (uint256) {
258     return totalSupply_;
259   }
260 
261   /**
262   * @dev transfer token for a specified address
263   * @param _to The address to transfer to.
264   * @param _value The amount to be transferred.
265   */
266   function transfer(address _to, uint256 _value) public returns (bool) {
267     require(_to != address(0));
268     require(_value <= balances[msg.sender]);
269 
270     // SafeMath.sub will throw if there is not enough balance.
271     balances[msg.sender] = balances[msg.sender].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     emit Transfer(msg.sender, _to, _value);
274     return true;
275   }
276 
277   /**
278   * @dev Gets the balance of the specified address.
279   * @param _owner The address to query the the balance of.
280   * @return An uint256 representing the amount owned by the passed address.
281   */
282   function balanceOf(address _owner) public view returns (uint256 balance) {
283     return balances[_owner];
284   }
285 
286 }
287 
288 
289 /**
290  * @title Standard ERC20 token
291  *
292  * @dev Implementation of the basic standard token.
293  * @dev https://github.com/ethereum/EIPs/issues/20
294  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
295  */
296 contract StandardToken is ERC20, BasicToken {
297 
298   mapping (address => mapping (address => uint256)) internal allowed;
299 
300 
301   /**
302    * @dev Transfer tokens from one address to another
303    * @param _from address The address which you want to send tokens from
304    * @param _to address The address which you want to transfer to
305    * @param _value uint256 the amount of tokens to be transferred
306    */
307   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
308     require(_to != address(0));
309     require(_value <= balances[_from]);
310     require(_value <= allowed[_from][msg.sender]);
311 
312     balances[_from] = balances[_from].sub(_value);
313     balances[_to] = balances[_to].add(_value);
314     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
315     emit Transfer(_from, _to, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
321    *
322    * Beware that changing an allowance with this method brings the risk that someone may use both the old
323    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
324    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
325    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
326    * @param _spender The address which will spend the funds.
327    * @param _value The amount of tokens to be spent.
328    */
329   function approve(address _spender, uint256 _value) public returns (bool) {
330     allowed[msg.sender][_spender] = _value;
331     emit Approval(msg.sender, _spender, _value);
332     return true;
333   }
334 
335   /**
336    * @dev Function to check the amount of tokens that an owner allowed to a spender.
337    * @param _owner address The address which owns the funds.
338    * @param _spender address The address which will spend the funds.
339    * @return A uint256 specifying the amount of tokens still available for the spender.
340    */
341   function allowance(address _owner, address _spender) public view returns (uint256) {
342     return allowed[_owner][_spender];
343   }
344 
345   /**
346    * @dev Increase the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To increment
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _addedValue The amount of tokens to increase the allowance by.
354    */
355   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
356     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
357     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358     return true;
359   }
360 
361   /**
362    * @dev Decrease the amount of tokens that an owner allowed to a spender.
363    *
364    * approve should be called when allowed[_spender] == 0. To decrement
365    * allowed value is better to use this function to avoid 2 calls (and wait until
366    * the first transaction is mined)
367    * From MonolithDAO Token.sol
368    * @param _spender The address which will spend the funds.
369    * @param _subtractedValue The amount of tokens to decrease the allowance by.
370    */
371   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
372     uint oldValue = allowed[msg.sender][_spender];
373     if (_subtractedValue > oldValue) {
374       allowed[msg.sender][_spender] = 0;
375     } else {
376       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
377     }
378     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
379     return true;
380   }
381 
382 }
383 
384 
385 /**
386  * @title Mintable token
387  * @dev Simple ERC20 Token example, with mintable token creation
388  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
389  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
390  */
391 contract MintableToken is StandardToken, Ownable {
392     event Mint(address indexed to, uint256 amount);
393     event MintFinished();
394 
395     bool public mintingFinished = false;
396 
397 
398     modifier canMint() {
399         require(!mintingFinished);
400         _;
401     }
402 
403     constructor(address _owner) 
404         public 
405         Ownable(_owner) 
406     {
407 
408     }
409 
410     /**
411     * @dev Function to mint tokens
412     * @param _to The address that will receive the minted tokens.
413     * @param _amount The amount of tokens to mint.
414     * @return A boolean that indicates if the operation was successful.
415     */
416     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
417         totalSupply_ = totalSupply_.add(_amount);
418         balances[_to] = balances[_to].add(_amount);
419         emit Mint(_to, _amount);
420         emit Transfer(address(0), _to, _amount);
421         return true;
422     }
423 
424     /**
425     * @dev Function to stop minting new tokens.
426     * @return True if the operation was successful.
427     */
428     function finishMinting() onlyOwner canMint public returns (bool) {
429         mintingFinished = true;
430         emit MintFinished();
431         return true;
432     }
433 }
434 
435 
436 contract DetailedERC20 {
437   string public name;
438   string public symbol;
439   uint8 public decimals;
440 
441   constructor(string _name, string _symbol, uint8 _decimals) public {
442     name = _name;
443     symbol = _symbol;
444     decimals = _decimals;
445   }
446 }
447 
448 
449 /** @title Compliant Token */
450 contract CompliantToken is Validator, DetailedERC20, MintableToken {
451     Whitelist public whiteListingContract;
452 
453     struct TransactionStruct {
454         address from;
455         address to;
456         uint256 value;
457         uint256 fee;
458         address spender;
459     }
460 
461     mapping (uint => TransactionStruct) public pendingTransactions;
462     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
463     uint256 public currentNonce = 0;
464     uint256 public transferFee;
465     address public feeRecipient;
466 
467     modifier checkIsInvestorApproved(address _account) {
468         require(whiteListingContract.isInvestorApproved(_account));
469         _;
470     }
471 
472     modifier checkIsAddressValid(address _account) {
473         require(_account != address(0));
474         _;
475     }
476 
477     modifier checkIsValueValid(uint256 _value) {
478         require(_value > 0);
479         _;
480     }
481 
482     /**
483     * event for rejected transfer logging
484     * @param from address from which tokens have to be transferred
485     * @param to address to tokens have to be transferred
486     * @param value number of tokens
487     * @param nonce request recorded at this particular nonce
488     * @param reason reason for rejection
489     */
490     event TransferRejected(
491         address indexed from,
492         address indexed to,
493         uint256 value,
494         uint256 indexed nonce,
495         uint256 reason
496     );
497 
498     /**
499     * event for transfer tokens logging
500     * @param from address from which tokens have to be transferred
501     * @param to address to tokens have to be transferred
502     * @param value number of tokens
503     * @param fee fee in tokens
504     */
505     event TransferWithFee(
506         address indexed from,
507         address indexed to,
508         uint256 value,
509         uint256 fee
510     );
511 
512     /**
513     * event for transfer/transferFrom request logging
514     * @param from address from which tokens have to be transferred
515     * @param to address to tokens have to be transferred
516     * @param value number of tokens
517     * @param fee fee in tokens
518     * @param spender The address which will spend the tokens
519     */
520     event RecordedPendingTransaction(
521         address indexed from,
522         address indexed to,
523         uint256 value,
524         uint256 fee,
525         address indexed spender
526     );
527 
528     /**
529     * event for whitelist contract update logging
530     * @param _whiteListingContract address of the new whitelist contract
531     */
532     event WhiteListingContractSet(address indexed _whiteListingContract);
533 
534     /**
535     * event for fee update logging
536     * @param previousFee previous fee
537     * @param newFee new fee
538     */
539     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
540 
541     /**
542     * event for fee recipient update logging
543     * @param previousRecipient address of the old fee recipient
544     * @param newRecipient address of the new fee recipient
545     */
546     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
547 
548     /** @dev Constructor
549       * @param _owner Token contract owner
550       * @param _name Token name
551       * @param _symbol Token symbol
552       * @param _decimals number of decimals in the token(usually 18)
553       * @param whitelistAddress Ethereum address of the whitelist contract
554       * @param recipient Ethereum address of the fee recipient
555       * @param fee token fee for approving a transfer
556       */
557     constructor(
558         address _owner,
559         string _name, 
560         string _symbol, 
561         uint8 _decimals,
562         address whitelistAddress,
563         address recipient,
564         uint256 fee
565     )
566         public
567         MintableToken(_owner)
568         DetailedERC20(_name, _symbol, _decimals)
569         Validator()
570     {
571         setWhitelistContract(whitelistAddress);
572         setFeeRecipient(recipient);
573         setFee(fee);
574     }
575 
576     /** @dev Updates whitelist contract address
577       * @param whitelistAddress New whitelist contract address
578       */
579     function setWhitelistContract(address whitelistAddress)
580         public
581         onlyValidator
582         checkIsAddressValid(whitelistAddress)
583     {
584         whiteListingContract = Whitelist(whitelistAddress);
585         emit WhiteListingContractSet(whiteListingContract);
586     }
587 
588     /** @dev Updates token fee for approving a transfer
589       * @param fee New token fee
590       */
591     function setFee(uint256 fee)
592         public
593         onlyValidator
594     {
595         emit FeeSet(transferFee, fee);
596         transferFee = fee;
597     }
598 
599     /** @dev Updates fee recipient address
600       * @param recipient New whitelist contract address
601       */
602     function setFeeRecipient(address recipient)
603         public
604         onlyValidator
605         checkIsAddressValid(recipient)
606     {
607         emit FeeRecipientSet(feeRecipient, recipient);
608         feeRecipient = recipient;
609     }
610 
611     /** @dev Updates token name
612       * @param _name New token name
613       */
614     function updateName(string _name) public onlyOwner {
615         require(bytes(_name).length != 0);
616         name = _name;
617     }
618 
619     /** @dev Updates token symbol
620       * @param _symbol New token name
621       */
622     function updateSymbol(string _symbol) public onlyOwner {
623         require(bytes(_symbol).length != 0);
624         symbol = _symbol;
625     }
626 
627     /** @dev transfer request
628       * @param _to address to which the tokens have to be transferred
629       * @param _value amount of tokens to be transferred
630       */
631     function transfer(address _to, uint256 _value)
632         public
633         checkIsInvestorApproved(msg.sender)
634         checkIsInvestorApproved(_to)
635         checkIsValueValid(_value)
636         returns (bool)
637     {
638         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
639 
640         if (msg.sender == feeRecipient) {
641             require(_value.add(pendingAmount) <= balances[msg.sender]);
642             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
643         } else {
644             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
645             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
646         }
647 
648         pendingTransactions[currentNonce] = TransactionStruct(
649             msg.sender,
650             _to,
651             _value,
652             transferFee,
653             address(0)
654         );
655 
656         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
657         currentNonce++;
658 
659         return true;
660     }
661 
662     /** @dev transferFrom request
663       * @param _from address from which the tokens have to be transferred
664       * @param _to address to which the tokens have to be transferred
665       * @param _value amount of tokens to be transferred
666       */
667     function transferFrom(address _from, address _to, uint256 _value)
668         public 
669         checkIsInvestorApproved(_from)
670         checkIsInvestorApproved(_to)
671         checkIsValueValid(_value)
672         returns (bool)
673     {
674         uint256 allowedTransferAmount = allowed[_from][msg.sender];
675         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
676         
677         if (_from == feeRecipient) {
678             require(_value.add(pendingAmount) <= balances[_from]);
679             require(_value.add(pendingAmount) <= allowedTransferAmount);
680             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
681         } else {
682             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
683             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
684             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
685         }
686 
687         pendingTransactions[currentNonce] = TransactionStruct(
688             _from,
689             _to,
690             _value,
691             transferFee,
692             msg.sender
693         );
694 
695         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
696         currentNonce++;
697 
698         return true;
699     }
700 
701     /** @dev approve transfer/transferFrom request
702       * @param nonce request recorded at this particular nonce
703       */
704     function approveTransfer(uint256 nonce)
705         external 
706         onlyValidator 
707         checkIsInvestorApproved(pendingTransactions[nonce].from)
708         checkIsInvestorApproved(pendingTransactions[nonce].to)
709         checkIsValueValid(pendingTransactions[nonce].value)
710         returns (bool)
711     {   
712         address from = pendingTransactions[nonce].from;
713         address spender = pendingTransactions[nonce].spender;
714         address to = pendingTransactions[nonce].to;
715         uint256 value = pendingTransactions[nonce].value;
716         uint256 allowedTransferAmount = allowed[from][spender];
717         uint256 pendingAmount = pendingApprovalAmount[from][spender];
718         uint256 fee = pendingTransactions[nonce].fee;
719         uint256 balanceFrom = balances[from];
720         uint256 balanceTo = balances[to];
721 
722         delete pendingTransactions[nonce];
723 
724         if (from == feeRecipient) {
725             fee = 0;
726             balanceFrom = balanceFrom.sub(value);
727             balanceTo = balanceTo.add(value);
728 
729             if (spender != address(0)) {
730                 allowedTransferAmount = allowedTransferAmount.sub(value);
731             } 
732             pendingAmount = pendingAmount.sub(value);
733 
734         } else {
735             balanceFrom = balanceFrom.sub(value.add(fee));
736             balanceTo = balanceTo.add(value);
737             balances[feeRecipient] = balances[feeRecipient].add(fee);
738 
739             if (spender != address(0)) {
740                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
741             }
742             pendingAmount = pendingAmount.sub(value).sub(fee);
743         }
744 
745         emit TransferWithFee(
746             from,
747             to,
748             value,
749             fee
750         );
751 
752         emit Transfer(
753             from,
754             to,
755             value
756         );
757         
758         balances[from] = balanceFrom;
759         balances[to] = balanceTo;
760         allowed[from][spender] = allowedTransferAmount;
761         pendingApprovalAmount[from][spender] = pendingAmount;
762         return true;
763     }
764 
765     /** @dev reject transfer/transferFrom request
766       * @param nonce request recorded at this particular nonce
767       * @param reason reason for rejection
768       */
769     function rejectTransfer(uint256 nonce, uint256 reason)
770         external 
771         onlyValidator
772         checkIsAddressValid(pendingTransactions[nonce].from)
773     {        
774         address from = pendingTransactions[nonce].from;
775         address spender = pendingTransactions[nonce].spender;
776 
777         if (from == feeRecipient) {
778             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
779                 .sub(pendingTransactions[nonce].value);
780         } else {
781             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
782                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
783         }
784         
785         emit TransferRejected(
786             from,
787             pendingTransactions[nonce].to,
788             pendingTransactions[nonce].value,
789             nonce,
790             reason
791         );
792         
793         delete pendingTransactions[nonce];
794     }
795 }