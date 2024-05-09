1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  * version mainet
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b; //alicia 2
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64     * account.
65     */
66     constructor(address _owner) public {
67         owner = _owner;
68     }
69 
70     /**
71     * @dev Throws if called by any account other than the owner.
72     */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79     * @dev Allows the current owner to transfer control of the contract to a newOwner.
80     * @param newOwner The address to transfer ownership to.
81     */
82     function transferOwnership(address newOwner) public onlyOwner {
83         require(newOwner != address(0));
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 
88 }
89 
90 
91 contract Whitelist is Ownable {
92     mapping(address => bool) internal investorMap;
93 
94     /**
95     * event for investor approval logging
96     * @param investor approved investor
97     */
98     event Approved(address indexed investor);
99 
100     /**
101     * event for investor disapproval logging
102     * @param investor disapproved investor
103     */
104     event Disapproved(address indexed investor);
105 
106     constructor(address _owner) 
107         public 
108         Ownable(_owner) 
109     {
110         
111     }
112 
113     /** @param _investor the address of investor to be checked
114       * @return true if investor is approved
115       */
116     function isInvestorApproved(address _investor) external view returns (bool) {
117         require(_investor != address(0));
118         return investorMap[_investor];
119     }
120 
121     /** @dev approve an investor
122       * @param toApprove investor to be approved
123       */
124     function approveInvestor(address toApprove) external onlyOwner {
125         investorMap[toApprove] = true;
126         emit Approved(toApprove);
127     }
128 
129     /** @dev approve investors in bulk
130       * @param toApprove array of investors to be approved
131       */
132     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
133         for (uint i = 0; i < toApprove.length; i++) {
134             investorMap[toApprove[i]] = true;
135             emit Approved(toApprove[i]);
136         }
137     }
138 
139     /** @dev disapprove an investor
140       * @param toDisapprove investor to be disapproved
141       */
142     function disapproveInvestor(address toDisapprove) external onlyOwner {
143         delete investorMap[toDisapprove];
144         emit Disapproved(toDisapprove);
145     }
146 
147     /** @dev disapprove investors in bulk
148       * @param toDisapprove array of investors to be disapproved
149       */
150     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
151         for (uint i = 0; i < toDisapprove.length; i++) {
152             delete investorMap[toDisapprove[i]];
153             emit Disapproved(toDisapprove[i]);
154         }
155     }
156 }
157 
158 
159 /**
160  * @title Validator
161  * @dev The Validator contract has a validator address, and provides basic authorization control
162  * functions, this simplifies the implementation of "user permissions".
163  */
164 contract Validator {
165     address public validator;
166 
167     /**
168     * event for validator address update logging
169     * @param previousOwner address of the old validator
170     * @param newValidator address of the new validator
171     */
172     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
173 
174     /**
175     * @dev The Validator constructor sets the original `validator` of the contract to the sender
176     * account.
177     */
178     constructor() public {
179         validator = msg.sender;
180     }
181 
182     /**
183     * @dev Throws if called by any account other than the validator.
184     */
185     modifier onlyValidator() {
186         require(msg.sender == validator);
187         _;
188     }
189 
190     /**
191     * @dev Allows the current validator to transfer control of the contract to a newValidator.
192     * @param newValidator The address to become next validator.
193     */
194     function setNewValidator(address newValidator) public onlyValidator {
195         require(newValidator != address(0));
196         emit NewValidatorSet(validator, newValidator);
197         validator = newValidator;
198     }
199 }
200 
201 
202 /**
203  * @title ERC20Basic
204  * @dev Simpler version of ERC20 interface
205  * @dev see https://github.com/ethereum/EIPs/issues/179
206  */
207 contract ERC20Basic {
208   function totalSupply() public view returns (uint256);
209   function balanceOf(address who) public view returns (uint256);
210   function transfer(address to, uint256 value) public returns (bool);
211   event Transfer(address indexed from, address indexed to, uint256 value);
212 }
213 
214 
215 /**
216  * @title ERC20 interface
217  * @dev see https://github.com/ethereum/EIPs/issues/20
218  */
219 contract ERC20 is ERC20Basic {
220   function allowance(address owner, address spender) public view returns (uint256);
221   function transferFrom(address from, address to, uint256 value) public returns (bool);
222   function approve(address spender, uint256 value) public returns (bool);
223   event Approval(address indexed owner, address indexed spender, uint256 value);
224 }
225 
226 
227 /**
228  * @title Basic token
229  * @dev Basic version of StandardToken, with no allowances.
230  */
231 contract BasicToken is ERC20Basic {
232   using SafeMath for uint256;
233 
234   mapping(address => uint256) balances;
235 
236   uint256 totalSupply_;
237 
238   /**
239   * @dev total number of tokens in existence
240   */
241   function totalSupply() public view returns (uint256) {
242     return totalSupply_;
243   }
244 
245   /**
246   * @dev transfer token for a specified address
247   * @param _to The address to transfer to.
248   * @param _value The amount to be transferred.
249   */
250   function transfer(address _to, uint256 _value) public returns (bool) {
251     require(_to != address(0));
252     require(_value <= balances[msg.sender]);
253 
254     // SafeMath.sub will throw if there is not enough balance.
255     balances[msg.sender] = balances[msg.sender].sub(_value);
256     balances[_to] = balances[_to].add(_value);
257     emit Transfer(msg.sender, _to, _value);
258     return true;
259   }
260 
261   /**
262   * @dev Gets the balance of the specified address.
263   * @param _owner The address to query the the balance of.
264   * @return An uint256 representing the amount owned by the passed address.
265   */
266   function balanceOf(address _owner) public view returns (uint256 balance) {
267     return balances[_owner];
268   }
269 
270 }
271 
272 
273 /**
274  * @title Standard ERC20 token
275  *
276  * @dev Implementation of the basic standard token.
277  * @dev https://github.com/ethereum/EIPs/issues/20
278  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
279  */
280 contract StandardToken is ERC20, BasicToken {
281 
282   mapping (address => mapping (address => uint256)) internal allowed;
283 
284 
285   /**
286    * @dev Transfer tokens from one address to another
287    * @param _from address The address which you want to send tokens from
288    * @param _to address The address which you want to transfer to
289    * @param _value uint256 the amount of tokens to be transferred
290    */
291   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
292     require(_to != address(0));
293     require(_value <= balances[_from]);
294     require(_value <= allowed[_from][msg.sender]);
295 
296     balances[_from] = balances[_from].sub(_value);
297     balances[_to] = balances[_to].add(_value);
298     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
299     emit Transfer(_from, _to, _value);
300     return true;
301   }
302 
303   /**
304    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
305    *
306    * Beware that changing an allowance with this method brings the risk that someone may use both the old
307    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
308    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
309    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310    * @param _spender The address which will spend the funds.
311    * @param _value The amount of tokens to be spent.
312    */
313   function approve(address _spender, uint256 _value) public returns (bool) {
314     allowed[msg.sender][_spender] = _value;
315     emit Approval(msg.sender, _spender, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Function to check the amount of tokens that an owner allowed to a spender.
321    * @param _owner address The address which owns the funds.
322    * @param _spender address The address which will spend the funds.
323    * @return A uint256 specifying the amount of tokens still available for the spender.
324    */
325   function allowance(address _owner, address _spender) public view returns (uint256) {
326     return allowed[_owner][_spender];
327   }
328 
329   /**
330    * @dev Increase the amount of tokens that an owner allowed to a spender.
331    *
332    * approve should be called when allowed[_spender] == 0. To increment
333    * allowed value is better to use this function to avoid 2 calls (and wait until
334    * the first transaction is mined)
335    * From MonolithDAO Token.sol
336    * @param _spender The address which will spend the funds.
337    * @param _addedValue The amount of tokens to increase the allowance by.
338    */
339   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
340     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
341     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345   /**
346    * @dev Decrease the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To decrement
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _subtractedValue The amount of tokens to decrease the allowance by.
354    */
355   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
356     uint oldValue = allowed[msg.sender][_spender];
357     if (_subtractedValue > oldValue) {
358       allowed[msg.sender][_spender] = 0;
359     } else {
360       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
361     }
362     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
363     return true;
364   }
365 
366 }
367 
368 
369 /**
370  * @title Mintable token
371  * @dev Simple ERC20 Token example, with mintable token creation
372  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
373  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
374  */
375 contract MintableToken is StandardToken, Ownable {
376     event Mint(address indexed to, uint256 amount);
377     event MintFinished();
378 
379     bool public mintingFinished = false;
380 
381 
382     modifier canMint() {
383         require(!mintingFinished);
384         _;
385     }
386 
387     constructor(address _owner) 
388         public 
389         Ownable(_owner) 
390     {
391 
392     }
393 
394     /**
395     * @dev Function to mint tokens
396     * @param _to The address that will receive the minted tokens.
397     * @param _amount The amount of tokens to mint.
398     * @return A boolean that indicates if the operation was successful.
399     */
400     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
401         totalSupply_ = totalSupply_.add(_amount);
402         balances[_to] = balances[_to].add(_amount);
403         emit Mint(_to, _amount);
404         emit Transfer(address(0), _to, _amount);
405         return true;
406     }
407 
408     /**
409     * @dev Function to stop minting new tokens.
410     * @return True if the operation was successful.
411     */
412     function finishMinting() onlyOwner canMint public returns (bool) {
413         mintingFinished = true;
414         emit MintFinished();
415         return true;
416     }
417 }
418 
419 
420 contract DetailedERC20 {
421   string public name;
422   string public symbol;
423   uint8 public decimals;
424 
425   constructor(string _name, string _symbol, uint8 _decimals) public {
426     name = _name;
427     symbol = _symbol;
428     decimals = _decimals;
429   }
430 }
431 
432 
433 /** @title Compliant Token */
434 contract CompliantToken is Validator, DetailedERC20, MintableToken {
435     Whitelist public whiteListingContract;
436 
437     struct TransactionStruct {
438         address from;
439         address to;
440         uint256 value;
441         uint256 fee;
442         address spender;
443     }
444 
445     mapping (uint => TransactionStruct) public pendingTransactions;
446     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
447     uint256 public currentNonce = 0;
448     uint256 public transferFee;
449     address public feeRecipient;
450 
451     modifier checkIsInvestorApproved(address _account) {
452         require(whiteListingContract.isInvestorApproved(_account));
453         _;
454     }
455 
456     modifier checkIsAddressValid(address _account) {
457         require(_account != address(0));
458         _;
459     }
460 
461     modifier checkIsValueValid(uint256 _value) {
462         require(_value > 0);
463         _;
464     }
465 
466     /**
467     * event for rejected transfer logging
468     * @param from address from which tokens have to be transferred
469     * @param to address to tokens have to be transferred
470     * @param value number of tokens
471     * @param nonce request recorded at this particular nonce
472     * @param reason reason for rejection
473     */
474     event TransferRejected(
475         address indexed from,
476         address indexed to,
477         uint256 value,
478         uint256 indexed nonce,
479         uint256 reason
480     );
481 
482     /**
483     * event for transfer tokens logging
484     * @param from address from which tokens have to be transferred
485     * @param to address to tokens have to be transferred
486     * @param value number of tokens
487     * @param fee fee in tokens
488     */
489     event TransferWithFee(
490         address indexed from,
491         address indexed to,
492         uint256 value,
493         uint256 fee
494     );
495 
496     /**
497     * event for transfer/transferFrom request logging
498     * @param from address from which tokens have to be transferred
499     * @param to address to tokens have to be transferred
500     * @param value number of tokens
501     * @param fee fee in tokens
502     * @param spender The address which will spend the tokens
503     */
504     event RecordedPendingTransaction(
505         address indexed from,
506         address indexed to,
507         uint256 value,
508         uint256 fee,
509         address indexed spender
510     );
511 
512     /**
513     * event for whitelist contract update logging
514     * @param _whiteListingContract address of the new whitelist contract
515     */
516     event WhiteListingContractSet(address indexed _whiteListingContract);
517 
518     /**
519     * event for fee update logging
520     * @param previousFee previous fee
521     * @param newFee new fee
522     */
523     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
524 
525     /**
526     * event for fee recipient update logging
527     * @param previousRecipient address of the old fee recipient
528     * @param newRecipient address of the new fee recipient
529     */
530     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
531 
532     /** @dev Constructor
533       * @param _owner Token contract owner
534       * @param _name Token name
535       * @param _symbol Token symbol
536       * @param _decimals number of decimals in the token(usually 18)
537       * @param whitelistAddress Ethereum address of the whitelist contract
538       * @param recipient Ethereum address of the fee recipient
539       * @param fee token fee for approving a transfer
540       */
541     constructor(
542         address _owner,
543         string _name, 
544         string _symbol, 
545         uint8 _decimals,
546         address whitelistAddress,
547         address recipient,
548         uint256 fee
549     )
550         public
551         MintableToken(_owner)
552         DetailedERC20(_name, _symbol, _decimals)
553         Validator()
554     {
555         setWhitelistContract(whitelistAddress);
556         setFeeRecipient(recipient);
557         setFee(fee);
558     }
559 
560     /** @dev Updates whitelist contract address
561       * @param whitelistAddress New whitelist contract address
562       */
563     function setWhitelistContract(address whitelistAddress)
564         public
565         onlyValidator
566         checkIsAddressValid(whitelistAddress)
567     {
568         whiteListingContract = Whitelist(whitelistAddress);
569         emit WhiteListingContractSet(whiteListingContract);
570     }
571 
572     /** @dev Updates token fee for approving a transfer
573       * @param fee New token fee
574       */
575     function setFee(uint256 fee)
576         public
577         onlyValidator
578     {
579         emit FeeSet(transferFee, fee);
580         transferFee = fee;
581     }
582 
583     /** @dev Updates fee recipient address
584       * @param recipient New whitelist contract address
585       */
586     function setFeeRecipient(address recipient)
587         public
588         onlyValidator
589         checkIsAddressValid(recipient)
590     {
591         emit FeeRecipientSet(feeRecipient, recipient);
592         feeRecipient = recipient;
593     }
594 
595     /** @dev Updates token name
596       * @param _name New token name
597       */
598     function updateName(string _name) public onlyOwner {
599         require(bytes(_name).length != 0);
600         name = _name;
601     }
602 
603     /** @dev Updates token symbol
604       * @param _symbol New token name
605       */
606     function updateSymbol(string _symbol) public onlyOwner {
607         require(bytes(_symbol).length != 0);
608         symbol = _symbol;
609     }
610 
611     /** @dev transfer request
612       * @param _to address to which the tokens have to be transferred
613       * @param _value amount of tokens to be transferred
614       */
615     function transfer(address _to, uint256 _value)
616         public
617         checkIsInvestorApproved(msg.sender)
618         checkIsInvestorApproved(_to)
619         checkIsValueValid(_value)
620         returns (bool)
621     {
622         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
623 
624         if (msg.sender == feeRecipient) {
625             require(_value.add(pendingAmount) <= balances[msg.sender]);
626             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
627         } else {
628             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
629             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
630         }
631 
632         pendingTransactions[currentNonce] = TransactionStruct(
633             msg.sender,
634             _to,
635             _value,
636             transferFee,
637             address(0)
638         );
639 
640         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
641         currentNonce++;
642 
643         return true;
644     }
645 
646     /** @dev transferFrom request
647       * @param _from address from which the tokens have to be transferred
648       * @param _to address to which the tokens have to be transferred
649       * @param _value amount of tokens to be transferred
650       */
651     function transferFrom(address _from, address _to, uint256 _value)
652         public 
653         checkIsInvestorApproved(_from)
654         checkIsInvestorApproved(_to)
655         checkIsValueValid(_value)
656         returns (bool)
657     {
658         uint256 allowedTransferAmount = allowed[_from][msg.sender];
659         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
660         
661         if (_from == feeRecipient) {
662             require(_value.add(pendingAmount) <= balances[_from]);
663             require(_value.add(pendingAmount) <= allowedTransferAmount);
664             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
665         } else {
666             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
667             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
668             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
669         }
670 
671         pendingTransactions[currentNonce] = TransactionStruct(
672             _from,
673             _to,
674             _value,
675             transferFee,
676             msg.sender
677         );
678 
679         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
680         currentNonce++;
681 
682         return true;
683     }
684 
685     /** @dev approve transfer/transferFrom request
686       * @param nonce request recorded at this particular nonce
687       */
688     function approveTransfer(uint256 nonce)
689         external 
690         onlyValidator 
691         checkIsInvestorApproved(pendingTransactions[nonce].from)
692         checkIsInvestorApproved(pendingTransactions[nonce].to)
693         checkIsValueValid(pendingTransactions[nonce].value)
694         returns (bool)
695     {   
696         address from = pendingTransactions[nonce].from;
697         address spender = pendingTransactions[nonce].spender;
698         address to = pendingTransactions[nonce].to;
699         uint256 value = pendingTransactions[nonce].value;
700         uint256 allowedTransferAmount = allowed[from][spender];
701         uint256 pendingAmount = pendingApprovalAmount[from][spender];
702         uint256 fee = pendingTransactions[nonce].fee;
703         uint256 balanceFrom = balances[from];
704         uint256 balanceTo = balances[to];
705 
706         delete pendingTransactions[nonce];
707 
708         if (from == feeRecipient) {
709             fee = 0;
710             balanceFrom = balanceFrom.sub(value);
711             balanceTo = balanceTo.add(value);
712 
713             if (spender != address(0)) {
714                 allowedTransferAmount = allowedTransferAmount.sub(value);
715             } 
716             pendingAmount = pendingAmount.sub(value);
717 
718         } else {
719             balanceFrom = balanceFrom.sub(value.add(fee));
720             balanceTo = balanceTo.add(value);
721             balances[feeRecipient] = balances[feeRecipient].add(fee);
722 
723             if (spender != address(0)) {
724                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
725             }
726             pendingAmount = pendingAmount.sub(value).sub(fee);
727         }
728 
729         emit TransferWithFee(
730             from,
731             to,
732             value,
733             fee
734         );
735 
736         emit Transfer(
737             from,
738             to,
739             value
740         );
741         
742         balances[from] = balanceFrom;
743         balances[to] = balanceTo;
744         allowed[from][spender] = allowedTransferAmount;
745         pendingApprovalAmount[from][spender] = pendingAmount;
746         return true;
747     }
748 
749     /** @dev reject transfer/transferFrom request
750       * @param nonce request recorded at this particular nonce
751       * @param reason reason for rejection
752       */
753     function rejectTransfer(uint256 nonce, uint256 reason)
754         external 
755         onlyValidator
756         checkIsAddressValid(pendingTransactions[nonce].from)
757     {        
758         address from = pendingTransactions[nonce].from;
759         address spender = pendingTransactions[nonce].spender;
760 
761         if (from == feeRecipient) {
762             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
763                 .sub(pendingTransactions[nonce].value);
764         } else {
765             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
766                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
767         }
768         
769         emit TransferRejected(
770             from,
771             pendingTransactions[nonce].to,
772             pendingTransactions[nonce].value,
773             nonce,
774             reason
775         );
776         
777         delete pendingTransactions[nonce];
778     }
779 }