1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72     address public owner;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /**
77     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78     * account.
79     */
80     constructor(address _owner) public {
81         owner = _owner;
82     }
83 
84     /**
85     * @dev Throws if called by any account other than the owner.
86     */
87     modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     /**
93     * @dev Allows the current owner to transfer control of the contract to a newOwner.
94     * @param newOwner The address to transfer ownership to.
95     */
96     function transferOwnership(address newOwner) public onlyOwner {
97         require(newOwner != address(0));
98         emit OwnershipTransferred(owner, newOwner);
99         owner = newOwner;
100     }
101 
102 }
103 
104 
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   uint256 totalSupply_;
116 
117   /**
118   * @dev total number of tokens in existence
119   */
120   function totalSupply() public view returns (uint256) {
121     return totalSupply_;
122   }
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[msg.sender]);
132 
133     // SafeMath.sub will throw if there is not enough balance.
134     balances[msg.sender] = balances[msg.sender].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     emit Transfer(msg.sender, _to, _value);
137     return true;
138   }
139 
140   /**
141   * @dev Gets the balance of the specified address.
142   * @param _owner The address to query the the balance of.
143   * @return An uint256 representing the amount owned by the passed address.
144   */
145   function balanceOf(address _owner) public view returns (uint256 balance) {
146     return balances[_owner];
147   }
148 
149 }
150 
151 
152 
153 
154 
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     emit Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     emit Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273     event Mint(address indexed to, uint256 amount);
274     event MintFinished();
275 
276     bool public mintingFinished = false;
277 
278 
279     modifier canMint() {
280         require(!mintingFinished);
281         _;
282     }
283 
284     constructor(address _owner) 
285         public 
286         Ownable(_owner) 
287     {
288     }
289 
290     /**
291     * @dev Function to mint tokens
292     * @param _to The address that will receive the minted tokens.
293     * @param _amount The amount of tokens to mint.
294     * @return A boolean that indicates if the operation was successful.
295     */
296     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
297         totalSupply_ = totalSupply_.add(_amount);
298         balances[_to] = balances[_to].add(_amount);
299         emit Mint(_to, _amount);
300         emit Transfer(address(0), _to, _amount);
301         return true;
302     }
303 
304     /**
305     * @dev Function to stop minting new tokens.
306     * @return True if the operation was successful.
307     */
308     function finishMinting() onlyOwner canMint public returns (bool) {
309         mintingFinished = true;
310         emit MintFinished();
311         return true;
312     }
313 }
314 
315 
316 /**
317  * @title Validator
318  * @dev The Validator contract has a validator address, and provides basic authorization control
319  * functions, this simplifies the implementation of "user permissions".
320  */
321 contract Validator {
322     address public validator;
323 
324     event NewValidatorSet(address indexed previousOwner, address indexed newValidator);
325 
326     /**
327     * @dev The Validator constructor sets the original `validator` of the contract to the sender
328     * account.
329     */
330     constructor() public {
331         validator = msg.sender;
332     }
333 
334     /**
335     * @dev Throws if called by any account other than the validator.
336     */
337     modifier onlyValidator() {
338         require(msg.sender == validator);
339         _;
340     }
341 
342     /**
343     * @dev Allows the current validator to transfer control of the contract to a newValidator.
344     * @param newValidator The address to become next validator.
345     */
346     function setNewValidator(address newValidator) public onlyValidator {
347         require(newValidator != address(0));
348         emit NewValidatorSet(validator, newValidator);
349         validator = newValidator;
350     }
351 }
352 
353 
354 
355 
356 contract Whitelist is Ownable {
357     mapping(address => bool) internal investorMap;
358 
359     event Approved(address indexed investor);
360     event Disapproved(address indexed investor);
361 
362     constructor(address _owner) 
363         public 
364         Ownable(_owner) 
365     {
366     }
367 
368     function isInvestorApproved(address _investor) external view returns (bool) {
369         require(_investor != address(0));
370         return investorMap[_investor];
371     }
372 
373     function approveInvestor(address toApprove) external onlyOwner {
374         investorMap[toApprove] = true;
375         emit Approved(toApprove);
376     }
377 
378     function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
379         for (uint i = 0; i < toApprove.length; i++) {
380             investorMap[toApprove[i]] = true;
381             emit Approved(toApprove[i]);
382         }
383     }
384 
385     function disapproveInvestor(address toDisapprove) external onlyOwner {
386         delete investorMap[toDisapprove];
387         emit Disapproved(toDisapprove);
388     }
389 
390     function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
391         for (uint i = 0; i < toDisapprove.length; i++) {
392             delete investorMap[toDisapprove[i]];
393             emit Disapproved(toDisapprove[i]);
394         }
395     }
396 }
397 
398 
399 
400 contract CompliantToken is Validator, MintableToken {
401     Whitelist public whiteListingContract;
402 
403     struct TransactionStruct {
404         address from;
405         address to;
406         uint256 value;
407         uint256 fee;
408         address spender;
409     }
410 
411     mapping (uint => TransactionStruct) public pendingTransactions;
412     mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
413     uint256 public currentNonce = 0;
414     uint256 public transferFee;
415     address public feeRecipient;
416 
417     modifier checkIsInvestorApproved(address _account) {
418         require(whiteListingContract.isInvestorApproved(_account));
419         _;
420     }
421 
422     modifier checkIsAddressValid(address _account) {
423         require(_account != address(0));
424         _;
425     }
426 
427     modifier checkIsValueValid(uint256 _value) {
428         require(_value > 0);
429         _;
430     }
431 
432     event TransferRejected(
433         address indexed from,
434         address indexed to,
435         uint256 value,
436         uint256 indexed nonce,
437         uint256 reason
438     );
439 
440     event TransferWithFee(
441         address indexed from,
442         address indexed to,
443         uint256 value,
444         uint256 fee
445     );
446 
447     event RecordedPendingTransaction(
448         address indexed from,
449         address indexed to,
450         uint256 value,
451         uint256 fee,
452         address indexed spender
453     );
454 
455     event WhiteListingContractSet(address indexed _whiteListingContract);
456 
457     event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);
458 
459     event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);
460 
461     constructor(
462         address _owner,
463         address whitelistAddress,
464         address recipient,
465         uint256 fee
466     )
467         public 
468         MintableToken(_owner)
469         Validator()
470     {
471         setWhitelistContract(whitelistAddress);
472         setFeeRecipient(recipient);
473         setFee(fee);
474     }
475 
476     function setWhitelistContract(address whitelistAddress)
477         public
478         onlyValidator
479         checkIsAddressValid(whitelistAddress)
480     {
481         whiteListingContract = Whitelist(whitelistAddress);
482         emit WhiteListingContractSet(whiteListingContract);
483     }
484 
485     function setFee(uint256 fee)
486         public
487         onlyValidator
488     {
489         emit FeeSet(transferFee, fee);
490         transferFee = fee;
491     }
492 
493     function setFeeRecipient(address recipient)
494         public
495         onlyValidator
496         checkIsAddressValid(recipient)
497     {
498         emit FeeRecipientSet(feeRecipient, recipient);
499         feeRecipient = recipient;
500     }
501 
502     function transfer(address _to, uint256 _value)
503         public
504         checkIsInvestorApproved(msg.sender)
505         checkIsInvestorApproved(_to)
506         checkIsValueValid(_value)
507         returns (bool)
508     {
509         uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];
510 
511         if (msg.sender == feeRecipient) {
512             require(_value.add(pendingAmount) <= balances[msg.sender]);
513             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
514         } else {
515             require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
516             pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
517         }
518 
519         pendingTransactions[currentNonce] = TransactionStruct(
520             msg.sender,
521             _to,
522             _value,
523             transferFee,
524             address(0)
525         );
526 
527         emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
528         currentNonce++;
529 
530         return true;
531     }
532 
533     function transferFrom(address _from, address _to, uint256 _value)
534         public 
535         checkIsInvestorApproved(_from)
536         checkIsInvestorApproved(_to)
537         checkIsValueValid(_value)
538         returns (bool)
539     {
540         uint256 allowedTransferAmount = allowed[_from][msg.sender];
541         uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
542         
543         if (_from == feeRecipient) {
544             require(_value.add(pendingAmount) <= balances[_from]);
545             require(_value.add(pendingAmount) <= allowedTransferAmount);
546             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
547         } else {
548             require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
549             require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
550             pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
551         }
552 
553         pendingTransactions[currentNonce] = TransactionStruct(
554             _from,
555             _to,
556             _value,
557             transferFee,
558             msg.sender
559         );
560 
561         emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
562         currentNonce++;
563 
564         return true;
565     }
566 
567     function approveTransfer(uint256 nonce)
568         external 
569         onlyValidator 
570         checkIsInvestorApproved(pendingTransactions[nonce].from)
571         checkIsInvestorApproved(pendingTransactions[nonce].to)
572         checkIsValueValid(pendingTransactions[nonce].value)
573         returns (bool)
574     {   
575         address from = pendingTransactions[nonce].from;
576         address spender = pendingTransactions[nonce].spender;
577         address to = pendingTransactions[nonce].to;
578         uint256 value = pendingTransactions[nonce].value;
579         uint256 allowedTransferAmount = allowed[from][spender];
580         uint256 pendingAmount = pendingApprovalAmount[from][spender];
581         uint256 fee = pendingTransactions[nonce].fee;
582         uint256 balanceFrom = balances[from];
583         uint256 balanceTo = balances[to];
584 
585         delete pendingTransactions[nonce];
586 
587         if (from == feeRecipient) {
588             fee = 0;
589             balanceFrom = balanceFrom.sub(value);
590             balanceTo = balanceTo.add(value);
591 
592             if (spender != address(0)) {
593                 allowedTransferAmount = allowedTransferAmount.sub(value);
594             } 
595             pendingAmount = pendingAmount.sub(value);
596 
597         } else {
598             balanceFrom = balanceFrom.sub(value.add(fee));
599             balanceTo = balanceTo.add(value);
600             balances[feeRecipient] = balances[feeRecipient].add(fee);
601 
602             if (spender != address(0)) {
603                 allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
604             }
605             pendingAmount = pendingAmount.sub(value).sub(fee);
606         }
607 
608         emit TransferWithFee(
609             from,
610             to,
611             value,
612             fee
613         );
614 
615         emit Transfer(
616             from,
617             to,
618             value
619         );
620         
621         balances[from] = balanceFrom;
622         balances[to] = balanceTo;
623         allowed[from][spender] = allowedTransferAmount;
624         pendingApprovalAmount[from][spender] = pendingAmount;
625         return true;
626     }
627 
628     function rejectTransfer(uint256 nonce, uint256 reason)
629         external 
630         onlyValidator
631         checkIsAddressValid(pendingTransactions[nonce].from)
632     {        
633         address from = pendingTransactions[nonce].from;
634         address spender = pendingTransactions[nonce].spender;
635 
636         if (from == feeRecipient) {
637             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
638                 .sub(pendingTransactions[nonce].value);
639         } else {
640             pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
641                 .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
642         }
643         
644         emit TransferRejected(
645             from,
646             pendingTransactions[nonce].to,
647             pendingTransactions[nonce].value,
648             nonce,
649             reason
650         );
651         
652         delete pendingTransactions[nonce];
653     }
654 }