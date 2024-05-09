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
166     /**
167     * event for validator address update logging
168     * @param previousOwner address of the old validator
169     * @param newValidator address of the new validator
170     */
171     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
172 
173     /**
174     * @dev The Validator constructor sets the original `validator` of the contract to the sender
175     * account.
176     */
177     constructor() public {
178         validator = msg.sender;
179     }
180 
181     /**
182     * @dev Throws if called by any account other than the validator.
183     */
184     modifier onlyValidator() {
185         require(msg.sender == validator);
186         _;
187     }
188 
189     /**
190     * @dev Allows the current validator to transfer control of the contract to a newValidator.
191     * @param newValidator The address to become next validator.
192     */
193     function setNewValidator(address newValidator) public onlyValidator {
194         require(newValidator != address(0));
195         emit NewValidatorSet(validator, newValidator);
196         validator = newValidator;
197     }
198 }
199 
200 
201 /**
202  * @title ERC20Basic
203  * @dev Simpler version of ERC20 interface
204  * @dev see https://github.com/ethereum/EIPs/issues/179
205  */
206 contract ERC20Basic {
207   function totalSupply() public view returns (uint256);
208   function balanceOf(address who) public view returns (uint256);
209   function transfer(address to, uint256 value) public returns (bool);
210   event Transfer(address indexed from, address indexed to, uint256 value);
211 }
212 
213 
214 /**
215  * @title ERC20 interface
216  * @dev see https://github.com/ethereum/EIPs/issues/20
217  */
218 contract ERC20 is ERC20Basic {
219   function allowance(address owner, address spender) public view returns (uint256);
220   function transferFrom(address from, address to, uint256 value) public returns (bool);
221   function approve(address spender, uint256 value) public returns (bool);
222   event Approval(address indexed owner, address indexed spender, uint256 value);
223 }
224 
225 
226 /**
227  * @title Basic token
228  * @dev Basic version of StandardToken, with no allowances.
229  */
230 contract BasicToken is ERC20Basic {
231   using SafeMath for uint256;
232 
233   mapping(address => uint256) balances;
234 
235   uint256 totalSupply_;
236 
237   /**
238   * @dev total number of tokens in existence
239   */
240   function totalSupply() public view returns (uint256) {
241     return totalSupply_;
242   }
243 
244   /**
245   * @dev transfer token for a specified address
246   * @param _to The address to transfer to.
247   * @param _value The amount to be transferred.
248   */
249   function transfer(address _to, uint256 _value) public returns (bool) {
250     require(_to != address(0));
251     require(_value <= balances[msg.sender]);
252 
253     // SafeMath.sub will throw if there is not enough balance.
254     balances[msg.sender] = balances[msg.sender].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     emit Transfer(msg.sender, _to, _value);
257     return true;
258   }
259 
260   /**
261   * @dev Gets the balance of the specified address.
262   * @param _owner The address to query the the balance of.
263   * @return An uint256 representing the amount owned by the passed address.
264   */
265   function balanceOf(address _owner) public view returns (uint256 balance) {
266     return balances[_owner];
267   }
268 
269 }
270 
271 
272 /**
273  * @title Standard ERC20 token
274  *
275  * @dev Implementation of the basic standard token.
276  * @dev https://github.com/ethereum/EIPs/issues/20
277  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
278  */
279 contract StandardToken is ERC20, BasicToken {
280 
281   mapping (address => mapping (address => uint256)) internal allowed;
282 
283 
284   /**
285    * @dev Transfer tokens from one address to another
286    * @param _from address The address which you want to send tokens from
287    * @param _to address The address which you want to transfer to
288    * @param _value uint256 the amount of tokens to be transferred
289    */
290   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
291     require(_to != address(0));
292     require(_value <= balances[_from]);
293     require(_value <= allowed[_from][msg.sender]);
294 
295     balances[_from] = balances[_from].sub(_value);
296     balances[_to] = balances[_to].add(_value);
297     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
298     emit Transfer(_from, _to, _value);
299     return true;
300   }
301 
302   /**
303    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
304    *
305    * Beware that changing an allowance with this method brings the risk that someone may use both the old
306    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
307    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
308    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309    * @param _spender The address which will spend the funds.
310    * @param _value The amount of tokens to be spent.
311    */
312   function approve(address _spender, uint256 _value) public returns (bool) {
313     allowed[msg.sender][_spender] = _value;
314     emit Approval(msg.sender, _spender, _value);
315     return true;
316   }
317 
318   /**
319    * @dev Function to check the amount of tokens that an owner allowed to a spender.
320    * @param _owner address The address which owns the funds.
321    * @param _spender address The address which will spend the funds.
322    * @return A uint256 specifying the amount of tokens still available for the spender.
323    */
324   function allowance(address _owner, address _spender) public view returns (uint256) {
325     return allowed[_owner][_spender];
326   }
327 
328   /**
329    * @dev Increase the amount of tokens that an owner allowed to a spender.
330    *
331    * approve should be called when allowed[_spender] == 0. To increment
332    * allowed value is better to use this function to avoid 2 calls (and wait until
333    * the first transaction is mined)
334    * From MonolithDAO Token.sol
335    * @param _spender The address which will spend the funds.
336    * @param _addedValue The amount of tokens to increase the allowance by.
337    */
338   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
339     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
340     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
341     return true;
342   }
343 
344   /**
345    * @dev Decrease the amount of tokens that an owner allowed to a spender.
346    *
347    * approve should be called when allowed[_spender] == 0. To decrement
348    * allowed value is better to use this function to avoid 2 calls (and wait until
349    * the first transaction is mined)
350    * From MonolithDAO Token.sol
351    * @param _spender The address which will spend the funds.
352    * @param _subtractedValue The amount of tokens to decrease the allowance by.
353    */
354   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
355     uint oldValue = allowed[msg.sender][_spender];
356     if (_subtractedValue > oldValue) {
357       allowed[msg.sender][_spender] = 0;
358     } else {
359       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
360     }
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365 }
366 
367 
368 /**
369  * @title Mintable token
370  * @dev Simple ERC20 Token example, with mintable token creation
371  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
372  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
373  */
374 contract MintableToken is StandardToken, Ownable {
375     event Mint(address indexed to, uint256 amount);
376     event MintFinished();
377 
378     bool public mintingFinished = false;
379 
380 
381     modifier canMint() {
382         require(!mintingFinished);
383         _;
384     }
385 
386     constructor(address _owner) 
387         public 
388         Ownable(_owner) 
389     {
390 
391     }
392 
393     /**
394     * @dev Function to mint tokens
395     * @param _to The address that will receive the minted tokens.
396     * @param _amount The amount of tokens to mint.
397     * @return A boolean that indicates if the operation was successful.
398     */
399     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
400         totalSupply_ = totalSupply_.add(_amount);
401         balances[_to] = balances[_to].add(_amount);
402         emit Mint(_to, _amount);
403         emit Transfer(address(0), _to, _amount);
404         return true;
405     }
406 
407     /**
408     * @dev Function to stop minting new tokens.
409     * @return True if the operation was successful.
410     */
411     function finishMinting() onlyOwner canMint public returns (bool) {
412         mintingFinished = true;
413         emit MintFinished();
414         return true;
415     }
416 }
417 
418 
419 contract DetailedERC20 {
420   string public name;
421   string public symbol;
422   uint8 public decimals;
423 
424   constructor(string _name, string _symbol, uint8 _decimals) public {
425     name = _name;
426     symbol = _symbol;
427     decimals = _decimals;
428   }
429 }
430 
431 
432 /** @title Compliant Token */
433 contract CompliantToken is Validator, DetailedERC20, MintableToken {
434     Whitelist public whiteListingContract;
435 
436     struct TransactionStruct {
437         address from;
438         address to;
439         uint256 value;
440         uint256 fee;
441         address spender;
442     }
443 
444     mapping (uint => TransactionStruct) public pendingTransactions;
445     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
446     uint256 public currentNonce = 0;
447     uint256 public transferFee;
448     address public feeRecipient;
449 
450     modifier checkIsInvestorApproved(address _account) {
451         require(whiteListingContract.isInvestorApproved(_account));
452         _;
453     }
454 
455     modifier checkIsAddressValid(address _account) {
456         require(_account != address(0));
457         _;
458     }
459 
460     modifier checkIsValueValid(uint256 _value) {
461         require(_value > 0);
462         _;
463     }
464 
465     /**
466     * event for rejected transfer logging
467     * @param from address from which tokens have to be transferred
468     * @param to address to tokens have to be transferred
469     * @param value number of tokens
470     * @param nonce request recorded at this particular nonce
471     * @param reason reason for rejection
472     */
473     event TransferRejected(
474         address indexed from,
475         address indexed to,
476         uint256 value,
477         uint256 indexed nonce,
478         uint256 reason
479     );
480 
481     /**
482     * event for transfer tokens logging
483     * @param from address from which tokens have to be transferred
484     * @param to address to tokens have to be transferred
485     * @param value number of tokens
486     * @param fee fee in tokens
487     */
488     event TransferWithFee(
489         address indexed from,
490         address indexed to,
491         uint256 value,
492         uint256 fee
493     );
494 
495     /**
496     * event for transfer/transferFrom request logging
497     * @param from address from which tokens have to be transferred
498     * @param to address to tokens have to be transferred
499     * @param value number of tokens
500     * @param fee fee in tokens
501     * @param spender The address which will spend the tokens
502     */
503     event RecordedPendingTransaction(
504         address indexed from,
505         address indexed to,
506         uint256 value,
507         uint256 fee,
508         address indexed spender
509     );
510 
511     /**
512     * event for whitelist contract update logging
513     * @param _whiteListingContract address of the new whitelist contract
514     */
515     event WhiteListingContractSet(address indexed _whiteListingContract);
516 
517     /**
518     * event for fee update logging
519     * @param previousFee previous fee
520     * @param newFee new fee
521     */
522     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
523 
524     /**
525     * event for fee recipient update logging
526     * @param previousRecipient address of the old fee recipient
527     * @param newRecipient address of the new fee recipient
528     */
529     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
530 
531     /** @dev Constructor
532       * @param _owner Token contract owner
533       * @param _name Token name
534       * @param _symbol Token symbol
535       * @param _decimals number of decimals in the token(usually 18)
536       * @param whitelistAddress Ethereum address of the whitelist contract
537       * @param recipient Ethereum address of the fee recipient
538       * @param fee token fee for approving a transfer
539       */
540     constructor(
541         address _owner,
542         string _name, 
543         string _symbol, 
544         uint8 _decimals,
545         address whitelistAddress,
546         address recipient,
547         uint256 fee
548     )
549         public
550         MintableToken(_owner)
551         DetailedERC20(_name, _symbol, _decimals)
552         Validator()
553     {
554         setWhitelistContract(whitelistAddress);
555         setFeeRecipient(recipient);
556         setFee(fee);
557     }
558 
559     /** @dev Updates whitelist contract address
560       * @param whitelistAddress New whitelist contract address
561       */
562     function setWhitelistContract(address whitelistAddress)
563         public
564         onlyValidator
565         checkIsAddressValid(whitelistAddress)
566     {
567         whiteListingContract = Whitelist(whitelistAddress);
568         emit WhiteListingContractSet(whiteListingContract);
569     }
570 
571     /** @dev Updates token fee for approving a transfer
572       * @param fee New token fee
573       */
574     function setFee(uint256 fee)
575         public
576         onlyValidator
577     {
578         emit FeeSet(transferFee, fee);
579         transferFee = fee;
580     }
581 
582     /** @dev Updates fee recipient address
583       * @param recipient New whitelist contract address
584       */
585     function setFeeRecipient(address recipient)
586         public
587         onlyValidator
588         checkIsAddressValid(recipient)
589     {
590         emit FeeRecipientSet(feeRecipient, recipient);
591         feeRecipient = recipient;
592     }
593 
594     /** @dev Updates token name
595       * @param _name New token name
596       */
597     function updateName(string _name) public onlyOwner {
598         require(bytes(_name).length != 0);
599         name = _name;
600     }
601 
602     /** @dev Updates token symbol
603       * @param _symbol New token name
604       */
605     function updateSymbol(string _symbol) public onlyOwner {
606         require(bytes(_symbol).length != 0);
607         symbol = _symbol;
608     }
609 
610     /** @dev transfer request
611       * @param _to address to which the tokens have to be transferred
612       * @param _value amount of tokens to be transferred
613       */
614     function transfer(address _to, uint256 _value)
615         public
616         checkIsInvestorApproved(msg.sender)
617         checkIsInvestorApproved(_to)
618         checkIsValueValid(_value)
619         returns (bool)
620     {
621         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
622 
623         if (msg.sender == feeRecipient) {
624             require(_value.add(pendingAmount) <= balances[msg.sender]);
625             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
626         } else {
627             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
628             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
629         }
630 
631         pendingTransactions[currentNonce] = TransactionStruct(
632             msg.sender,
633             _to,
634             _value,
635             transferFee,
636             address(0)
637         );
638 
639         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
640         currentNonce++;
641 
642         return true;
643     }
644 
645     /** @dev transferFrom request
646       * @param _from address from which the tokens have to be transferred
647       * @param _to address to which the tokens have to be transferred
648       * @param _value amount of tokens to be transferred
649       */
650     function transferFrom(address _from, address _to, uint256 _value)
651         public 
652         checkIsInvestorApproved(_from)
653         checkIsInvestorApproved(_to)
654         checkIsValueValid(_value)
655         returns (bool)
656     {
657         uint256 allowedTransferAmount = allowed[_from][msg.sender];
658         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
659         
660         if (_from == feeRecipient) {
661             require(_value.add(pendingAmount) <= balances[_from]);
662             require(_value.add(pendingAmount) <= allowedTransferAmount);
663             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
664         } else {
665             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
666             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
667             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
668         }
669 
670         pendingTransactions[currentNonce] = TransactionStruct(
671             _from,
672             _to,
673             _value,
674             transferFee,
675             msg.sender
676         );
677 
678         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
679         currentNonce++;
680 
681         return true;
682     }
683 
684     /** @dev approve transfer/transferFrom request
685       * @param nonce request recorded at this particular nonce
686       */
687     function approveTransfer(uint256 nonce)
688         external 
689         onlyValidator 
690         checkIsInvestorApproved(pendingTransactions[nonce].from)
691         checkIsInvestorApproved(pendingTransactions[nonce].to)
692         checkIsValueValid(pendingTransactions[nonce].value)
693         returns (bool)
694     {   
695         address from = pendingTransactions[nonce].from;
696         address spender = pendingTransactions[nonce].spender;
697         address to = pendingTransactions[nonce].to;
698         uint256 value = pendingTransactions[nonce].value;
699         uint256 allowedTransferAmount = allowed[from][spender];
700         uint256 pendingAmount = pendingApprovalAmount[from][spender];
701         uint256 fee = pendingTransactions[nonce].fee;
702         uint256 balanceFrom = balances[from];
703         uint256 balanceTo = balances[to];
704 
705         delete pendingTransactions[nonce];
706 
707         if (from == feeRecipient) {
708             fee = 0;
709             balanceFrom = balanceFrom.sub(value);
710             balanceTo = balanceTo.add(value);
711 
712             if (spender != address(0)) {
713                 allowedTransferAmount = allowedTransferAmount.sub(value);
714             } 
715             pendingAmount = pendingAmount.sub(value);
716 
717         } else {
718             balanceFrom = balanceFrom.sub(value.add(fee));
719             balanceTo = balanceTo.add(value);
720             balances[feeRecipient] = balances[feeRecipient].add(fee);
721 
722             if (spender != address(0)) {
723                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
724             }
725             pendingAmount = pendingAmount.sub(value).sub(fee);
726         }
727 
728         emit TransferWithFee(
729             from,
730             to,
731             value,
732             fee
733         );
734 
735         emit Transfer(
736             from,
737             to,
738             value
739         );
740         
741         balances[from] = balanceFrom;
742         balances[to] = balanceTo;
743         allowed[from][spender] = allowedTransferAmount;
744         pendingApprovalAmount[from][spender] = pendingAmount;
745         return true;
746     }
747 
748     /** @dev reject transfer/transferFrom request
749       * @param nonce request recorded at this particular nonce
750       * @param reason reason for rejection
751       */
752     function rejectTransfer(uint256 nonce, uint256 reason)
753         external 
754         onlyValidator
755         checkIsAddressValid(pendingTransactions[nonce].from)
756     {        
757         address from = pendingTransactions[nonce].from;
758         address spender = pendingTransactions[nonce].spender;
759 
760         if (from == feeRecipient) {
761             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
762                 .sub(pendingTransactions[nonce].value);
763         } else {
764             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
765                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
766         }
767         
768         emit TransferRejected(
769             from,
770             pendingTransactions[nonce].to,
771             pendingTransactions[nonce].value,
772             nonce,
773             reason
774         );
775         
776         delete pendingTransactions[nonce];
777     }
778 }
779 
780 
781 /**
782  * @title Crowdsale
783  * @dev Crowdsale is a base contract for managing a token crowdsale.
784  * Crowdsales have a start and end timestamps, where investors can make
785  * token purchases and the crowdsale will assign them tokens based
786  * on a token per ETH rate. Funds collected are forwarded to a wallet
787  * as they arrive. The contract requires a MintableToken that will be
788  * minted as contributions arrive, note that the crowdsale contract
789  * must be owner of the token in order to be able to mint it.
790  */
791 contract Crowdsale {
792     using SafeMath for uint256;
793 
794     // The token being sold
795     MintableToken public token;
796 
797     // start and end timestamps where investments are allowed (both inclusive)
798     uint256 public startTime;
799     uint256 public endTime;
800 
801     // address where funds are collected
802     address public wallet;
803 
804     // how many token units a buyer gets per wei
805     uint256 public rate;
806 
807     // amount of raised money in wei
808     uint256 public weiRaised;
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
820     constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public {
821         require(_startTime >= now);
822         require(_endTime >= _startTime);
823         require(_rate > 0);
824         require(_wallet != address(0));
825         require(_token != address(0));
826 
827         startTime = _startTime;
828         endTime = _endTime;
829         rate = _rate;
830         wallet = _wallet;
831         token = _token;
832     }
833 
834     /** @dev fallback function redirects to buy tokens */
835     function () external payable {
836         buyTokens(msg.sender);
837     }
838 
839     /** @dev buy tokens
840       * @param beneficiary the address to which the tokens have to be minted
841       */
842     function buyTokens(address beneficiary) public payable {
843         require(beneficiary != address(0));
844         require(validPurchase());
845 
846         uint256 weiAmount = msg.value;
847 
848         // calculate token amount to be created
849         uint256 tokens = getTokenAmount(weiAmount);
850 
851         // update state
852         weiRaised = weiRaised.add(weiAmount);
853 
854         token.mint(beneficiary, tokens);
855         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
856 
857         forwardFunds();
858     }
859 
860     /** @return true if crowdsale event has ended */
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
878         bool withinPeriod = now >= startTime && now <= endTime;
879         bool nonZeroPurchase = msg.value != 0;
880         return withinPeriod && nonZeroPurchase;
881     }
882 
883 }
884 
885 
886 /**
887  * @title FinalizableCrowdsale
888  * @dev Extension of Crowdsale where an owner can do extra work
889  * after finishing.
890  */
891 contract FinalizableCrowdsale is Crowdsale, Ownable {
892     using SafeMath for uint256;
893 
894     bool public isFinalized = false;
895 
896     event Finalized();
897  
898     constructor(address _owner) public Ownable(_owner) {}
899 
900     /**
901     * @dev Must be called after crowdsale ends, to do some extra finalization
902     * work. Calls the contract's finalization function.
903     */
904     function finalize() onlyOwner public {
905         require(!isFinalized);
906         require(hasEnded());
907 
908         finalization();
909         emit Finalized();
910 
911         isFinalized = true;
912     }
913 
914     /**
915     * @dev Can be overridden to add finalization logic. The overriding function
916     * should call super.finalization() to ensure the chain of finalization is
917     * executed entirely.
918     */
919     function finalization() internal {}
920 }
921 
922 
923 /** @title Compliant Crowdsale */
924 contract CompliantCrowdsale is Validator, FinalizableCrowdsale {
925     Whitelist public whiteListingContract;
926 
927     struct MintStruct {
928         address to;
929         uint256 tokens;
930         uint256 weiAmount;
931     }
932 
933     mapping (uint => MintStruct) public pendingMints;
934     uint256 public currentMintNonce;
935     mapping (address => uint) public rejectedMintBalance;
936 
937     modifier checkIsInvestorApproved(address _account) {
938         require(whiteListingContract.isInvestorApproved(_account));
939         _;
940     }
941 
942     modifier checkIsAddressValid(address _account) {
943         require(_account != address(0));
944         _;
945     }
946 
947     /**
948     * event for rejected mint logging
949     * @param to address for which buy tokens got rejected
950     * @param value number of tokens
951     * @param amount number of ethers invested
952     * @param nonce request recorded at this particular nonce
953     * @param reason reason for rejection
954     */
955     event MintRejected(
956         address indexed to,
957         uint256 value,
958         uint256 amount,
959         uint256 indexed nonce,
960         uint256 reason
961     );
962 
963     /**
964     * event for buy tokens request logging
965     * @param beneficiary address for which buy tokens is requested
966     * @param tokens number of tokens
967     * @param weiAmount number of ethers invested
968     * @param nonce request recorded at this particular nonce
969     */
970     event ContributionRegistered(
971         address beneficiary,
972         uint256 tokens,
973         uint256 weiAmount,
974         uint256 nonce
975     );
976 
977     /**
978     * event for whitelist contract update logging
979     * @param _whiteListingContract address of the new whitelist contract
980     */
981     event WhiteListingContractSet(address indexed _whiteListingContract);
982 
983     /**
984     * event for claimed ether logging
985     * @param account user claiming the ether
986     * @param amount ether claimed
987     */
988     event Claimed(address indexed account, uint256 amount);
989 
990     /** @dev Constructor
991       * @param whitelistAddress Ethereum address of the whitelist contract
992       * @param _startTime crowdsale start time
993       * @param _endTime crowdsale end time
994       * @param _rate number of tokens to be sold per ether
995       * @param _wallet Ethereum address of the wallet
996       * @param _token Ethereum address of the token contract
997       * @param _owner Ethereum address of the owner
998       */
999     constructor(
1000         address whitelistAddress,
1001         uint256 _startTime,
1002         uint256 _endTime,
1003         uint256 _rate,
1004         address _wallet,
1005         MintableToken _token,
1006         address _owner
1007     )
1008         public
1009         FinalizableCrowdsale(_owner)
1010         Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
1011     {
1012         setWhitelistContract(whitelistAddress);
1013     }
1014 
1015     /** @dev Updates whitelist contract address
1016       * @param whitelistAddress address of the new whitelist contract 
1017       */
1018     function setWhitelistContract(address whitelistAddress)
1019         public 
1020         onlyValidator 
1021         checkIsAddressValid(whitelistAddress)
1022     {
1023         whiteListingContract = Whitelist(whitelistAddress);
1024         emit WhiteListingContractSet(whiteListingContract);
1025     }
1026 
1027     /** @dev buy tokens request
1028       * @param beneficiary the address to which the tokens have to be minted
1029       */
1030     function buyTokens(address beneficiary)
1031         public 
1032         payable
1033         checkIsInvestorApproved(beneficiary)
1034     {
1035         require(validPurchase());
1036 
1037         uint256 weiAmount = msg.value;
1038 
1039         // calculate token amount to be created
1040         uint256 tokens = weiAmount.mul(rate);
1041 
1042         pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount);
1043         emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce);
1044 
1045         currentMintNonce++;
1046     }
1047 
1048     /** @dev approve buy tokens request
1049       * @param nonce request recorded at this particular nonce
1050       */
1051     function approveMint(uint256 nonce)
1052         external 
1053         onlyValidator 
1054         checkIsInvestorApproved(pendingMints[nonce].to)
1055         returns (bool)
1056     {
1057         // update state
1058         weiRaised = weiRaised.add(pendingMints[nonce].weiAmount);
1059 
1060         //No need to use mint-approval on token side, since the minting is already approved in the crowdsale side
1061         token.mint(pendingMints[nonce].to, pendingMints[nonce].tokens);
1062         
1063         emit TokenPurchase(
1064             msg.sender,
1065             pendingMints[nonce].to,
1066             pendingMints[nonce].weiAmount,
1067             pendingMints[nonce].tokens
1068         );
1069 
1070         forwardFunds(pendingMints[nonce].weiAmount);
1071         delete pendingMints[nonce];
1072 
1073         return true;
1074     }
1075 
1076     /** @dev reject buy tokens request
1077       * @param nonce request recorded at this particular nonce
1078       * @param reason reason for rejection
1079       */
1080     function rejectMint(uint256 nonce, uint256 reason)
1081         external 
1082         onlyValidator 
1083         checkIsAddressValid(pendingMints[nonce].to)
1084     {
1085         rejectedMintBalance[pendingMints[nonce].to] = rejectedMintBalance[pendingMints[nonce].to].add(pendingMints[nonce].weiAmount);
1086         
1087         emit MintRejected(
1088             pendingMints[nonce].to,
1089             pendingMints[nonce].tokens,
1090             pendingMints[nonce].weiAmount,
1091             nonce,
1092             reason
1093         );
1094         
1095         delete pendingMints[nonce];
1096     }
1097 
1098     /** @dev claim back ether if buy tokens request is rejected */
1099     function claim() external {
1100         require(rejectedMintBalance[msg.sender] > 0);
1101         uint256 value = rejectedMintBalance[msg.sender];
1102         rejectedMintBalance[msg.sender] = 0;
1103 
1104         msg.sender.transfer(value);
1105 
1106         emit Claimed(msg.sender, value);
1107     }
1108 
1109     function finalization() internal {
1110         token.finishMinting();
1111         transferTokenOwnership(owner);
1112         super.finalization();
1113     }
1114 
1115     /** @dev Updates token contract address
1116       * @param newToken New token contract address
1117       */
1118     function setTokenContract(address newToken)
1119         external 
1120         onlyOwner
1121         checkIsAddressValid(newToken)
1122     {
1123         token = CompliantToken(newToken);
1124     }
1125 
1126     /** @dev transfers ownership of the token contract
1127       * @param newOwner New owner of the token contract
1128       */
1129     function transferTokenOwnership(address newOwner)
1130         public 
1131         onlyOwner
1132         checkIsAddressValid(newOwner)
1133     {
1134         token.transferOwnership(newOwner);
1135     }
1136 
1137     function forwardFunds(uint256 amount) internal {
1138         wallet.transfer(amount);
1139     }
1140 }