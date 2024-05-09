1 pragma solidity 0.4.25;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: contracts/PumaPayToken.sol
379 
380 /// PumaPayToken inherits from MintableToken, which in turn inherits from StandardToken.
381 /// Super is used to bypass the original function signature and include the whenNotMinting modifier.
382 contract PumaPayToken is MintableToken {
383 
384     string public name = "PumaPay"; 
385     string public symbol = "PMA";
386     uint8 public decimals = 18;
387 
388     constructor() public {
389     }
390 
391     /// This modifier will be used to disable all ERC20 functionalities during the minting process.
392     modifier whenNotMinting() {
393         require(mintingFinished);
394         _;
395     }
396 
397     /// @dev transfer token for a specified address
398     /// @param _to address The address to transfer to.
399     /// @param _value uint256 The amount to be transferred.
400     /// @return success bool Calling super.transfer and returns true if successful.
401     function transfer(address _to, uint256 _value) public whenNotMinting returns (bool) {
402         return super.transfer(_to, _value);
403     }
404 
405     /// @dev Transfer tokens from one address to another.
406     /// @param _from address The address which you want to send tokens from.
407     /// @param _to address The address which you want to transfer to.
408     /// @param _value uint256 the amount of tokens to be transferred.
409     /// @return success bool Calling super.transferFrom and returns true if successful.
410     function transferFrom(address _from, address _to, uint256 _value) public whenNotMinting returns (bool) {
411         return super.transferFrom(_from, _to, _value);
412     }
413 }
414 
415 // File: contracts/PumaPayPullPayment.sol
416 
417 /// @title PumaPay Pull Payment - Contract that facilitates our pull payment protocol
418 /// @author PumaPay Dev Team - <developers@pumapay.io>
419 contract PumaPayPullPayment is Ownable {
420 
421     using SafeMath for uint256;
422 
423     /// ===============================================================================================================
424     ///                                      Events
425     /// ===============================================================================================================
426 
427     event LogExecutorAdded(address executor);
428     event LogExecutorRemoved(address executor);
429     event LogPaymentRegistered(address clientAddress, address beneficiaryAddress, string paymentID);
430     event LogPaymentCancelled(address clientAddress, address beneficiaryAddress, string paymentID);
431     event LogPullPaymentExecuted(address clientAddress, address beneficiaryAddress, string paymentID);
432     event LogSetExchangeRate(string currency, uint256 exchangeRate);
433 
434     /// ===============================================================================================================
435     ///                                      Constants
436     /// ===============================================================================================================
437 
438     uint256 constant private DECIMAL_FIXER = 10 ** 10;    /// 1e^10 - This transforms the Rate from decimals to uint256
439     uint256 constant private FIAT_TO_CENT_FIXER = 100;    /// Fiat currencies have 100 cents in 1 basic monetary unit.
440     uint256 constant private ONE_ETHER = 1 ether;         /// PumaPay token has 18 decimals - same as one ETHER
441     uint256 constant private MINIMUM_AMOUNT_OF_ETH_FOR_OPARATORS = 0.01 ether; /// minimum amount of ETHER the owner/executor should have
442     uint256 constant private OVERFLOW_LIMITER_NUMBER = 10 ** 20; /// 1e^20 - This number is used to prevent numeric overflows
443 
444     /// ===============================================================================================================
445     ///                                      Members
446     /// ===============================================================================================================
447 
448     PumaPayToken public token;
449 
450     mapping(string => uint256) private exchangeRates;
451     mapping(address => bool) public executors;
452     mapping(address => mapping(address => PullPayment)) public pullPayments;
453 
454     struct PullPayment {
455         string merchantID;                      /// ID of the merchant
456         string paymentID;                       /// ID of the payment
457         string currency;                        /// 3-letter abbr i.e. 'EUR' / 'USD' etc.
458         uint256 initialPaymentAmountInCents;    /// initial payment amount in fiat in cents
459         uint256 fiatAmountInCents;              /// payment amount in fiat in cents
460         uint256 frequency;                      /// how often merchant can pull - in seconds
461         uint256 numberOfPayments;               /// amount of pull payments merchant can make
462         uint256 startTimestamp;                 /// when subscription starts - in seconds
463         uint256 nextPaymentTimestamp;           /// timestamp of next payment
464         uint256 lastPaymentTimestamp;           /// timestamp of last payment
465         uint256 cancelTimestamp;                /// timestamp the payment was cancelled
466     }
467 
468     /// ===============================================================================================================
469     ///                                      Modifiers
470     /// ===============================================================================================================
471     modifier isExecutor() {
472         require(executors[msg.sender]);
473         _;
474     }
475 
476     modifier executorExists(address _executor) {
477         require(executors[_executor]);
478         _;
479     }
480 
481     modifier executorDoesNotExists(address _executor) {
482         require(!executors[_executor]);
483         _;
484     }
485 
486     modifier paymentExists(address _client, address _beneficiary) {
487         require(doesPaymentExist(_client, _beneficiary));
488         _;
489     }
490 
491     modifier paymentNotCancelled(address _client, address _beneficiary) {
492         require(pullPayments[_client][_beneficiary].cancelTimestamp == 0);
493         _;
494     }
495 
496     modifier isValidPullPaymentRequest(address _client, address _beneficiary, string _paymentID) {
497         require(
498             (pullPayments[_client][_beneficiary].initialPaymentAmountInCents > 0 ||
499             (now >= pullPayments[_client][_beneficiary].startTimestamp &&
500             now >= pullPayments[_client][_beneficiary].nextPaymentTimestamp)
501             )
502             &&
503             pullPayments[_client][_beneficiary].numberOfPayments > 0 &&
504         (pullPayments[_client][_beneficiary].cancelTimestamp == 0 ||
505         pullPayments[_client][_beneficiary].cancelTimestamp > pullPayments[_client][_beneficiary].nextPaymentTimestamp) &&
506         keccak256(
507             abi.encodePacked(pullPayments[_client][_beneficiary].paymentID)
508         ) == keccak256(abi.encodePacked(_paymentID))
509         );
510         _;
511     }
512 
513     modifier isValidDeletionRequest(string paymentID, address client, address beneficiary) {
514         require(
515             beneficiary != address(0) &&
516             client != address(0) &&
517             bytes(paymentID).length != 0
518         );
519         _;
520     }
521 
522     modifier isValidAddress(address _address) {
523         require(_address != address(0));
524         _;
525     }
526 
527     /// ===============================================================================================================
528     ///                                      Constructor
529     /// ===============================================================================================================
530 
531     /// @dev Contract constructor - sets the token address that the contract facilitates.
532     /// @param _token Token Address.
533     constructor (PumaPayToken _token)
534     public
535     {
536         require(_token != address(0));
537         token = _token;
538     }
539 
540     // @notice Will receive any eth sent to the contract
541     function() external payable {
542     }
543 
544     /// ===============================================================================================================
545     ///                                      Public Functions - Owner Only
546     /// ===============================================================================================================
547 
548     /// @dev Adds a new executor. - can be executed only by the onwer. 
549     /// When adding a new executor 1 ETH is tranferred to allow the executor to pay for gas.
550     /// The balance of the owner is also checked and if funding is needed 1 ETH is transferred.
551     /// @param _executor - address of the executor which cannot be zero address.
552     function addExecutor(address _executor)
553     public
554     onlyOwner
555     isValidAddress(_executor)
556     executorDoesNotExists(_executor)
557     {
558         _executor.transfer(0.25 ether);
559         executors[_executor] = true;
560 
561         if (isFundingNeeded(owner)) {
562             owner.transfer(0.5 ether);
563         }
564 
565         emit LogExecutorAdded(_executor);
566     }
567 
568     /// @dev Removes a new executor. - can be executed only by the onwer.
569     /// The balance of the owner is checked and if funding is needed 1 ETH is transferred.
570     /// @param _executor - address of the executor which cannot be zero address.
571     function removeExecutor(address _executor)
572     public
573     onlyOwner
574     isValidAddress(_executor)
575     executorExists(_executor)
576     {
577         executors[_executor] = false;
578         if (isFundingNeeded(owner)) {
579             owner.transfer(0.5 ether);
580         }
581         emit LogExecutorRemoved(_executor);
582     }
583 
584     /// @dev Sets the exchange rate for a currency. - can be executed only by the onwer.
585     /// Emits 'LogSetExchangeRate' with the currency and the updated rate.
586     /// The balance of the owner is checked and if funding is needed 1 ETH is transferred.
587     /// @param _currency - address of the executor which cannot be zero address
588     /// @param _rate - address of the executor which cannot be zero address
589     function setRate(string _currency, uint256 _rate)
590     public
591     onlyOwner
592     returns (bool) {
593         exchangeRates[_currency] = _rate;
594         emit LogSetExchangeRate(_currency, _rate);
595 
596         if (isFundingNeeded(owner)) {
597             owner.transfer(0.5 ether);
598         }
599 
600         return true;
601     }
602 
603     /// ===============================================================================================================
604     ///                                      Public Functions - Executors Only
605     /// ===============================================================================================================
606 
607     /// @dev Registers a new pull payment to the PumaPay Pull Payment Contract - The registration can be executed only by one of the executors of the PumaPay Pull Payment Contract
608     /// and the PumaPay Pull Payment Contract checks that the pull payment has been singed by the client of the account.
609     /// The balance of the executor (msg.sender) is checked and if funding is needed 1 ETH is transferred.
610     /// Emits 'LogPaymentRegistered' with client address, beneficiary address and paymentID.
611     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
612     /// @param r - R output of ECDSA signature.
613     /// @param s - S output of ECDSA signature.
614     /// @param _merchantID - ID of the merchant.
615     /// @param _paymentID - ID of the payment.
616     /// @param _client - client address that is linked to this pull payment.
617     /// @param _beneficiary - address that is allowed to execute this pull payment.
618     /// @param _currency - currency of the payment / 3-letter abbr i.e. 'EUR'.
619     /// @param _fiatAmountInCents - payment amount in fiat in cents.
620     /// @param _frequency - how often merchant can pull - in seconds.
621     /// @param _numberOfPayments - amount of pull payments merchant can make
622     /// @param _startTimestamp - when subscription starts - in seconds.
623     function registerPullPayment(
624         uint8 v,
625         bytes32 r,
626         bytes32 s,
627         string _merchantID,
628         string _paymentID,
629         address _client,
630         address _beneficiary,
631         string _currency,
632         uint256 _initialPaymentAmountInCents,
633         uint256 _fiatAmountInCents,
634         uint256 _frequency,
635         uint256 _numberOfPayments,
636         uint256 _startTimestamp
637     )
638     public
639     isExecutor()
640     {
641         require(
642             bytes(_paymentID).length > 0 &&
643             bytes(_currency).length > 0 &&
644             _client != address(0) &&
645             _beneficiary != address(0) &&
646             _fiatAmountInCents > 0 &&
647             _frequency > 0 &&
648             _frequency < OVERFLOW_LIMITER_NUMBER &&
649             _numberOfPayments > 0 &&
650             _startTimestamp > 0 &&
651             _startTimestamp < OVERFLOW_LIMITER_NUMBER
652         );
653 
654         pullPayments[_client][_beneficiary].currency = _currency;
655         pullPayments[_client][_beneficiary].initialPaymentAmountInCents = _initialPaymentAmountInCents;
656         pullPayments[_client][_beneficiary].fiatAmountInCents = _fiatAmountInCents;
657         pullPayments[_client][_beneficiary].frequency = _frequency;
658         pullPayments[_client][_beneficiary].startTimestamp = _startTimestamp;
659         pullPayments[_client][_beneficiary].numberOfPayments = _numberOfPayments;
660 
661         require(isValidRegistration(v, r, s, _client, _beneficiary, pullPayments[_client][_beneficiary]));
662 
663         pullPayments[_client][_beneficiary].merchantID = _merchantID;
664         pullPayments[_client][_beneficiary].paymentID = _paymentID;
665         pullPayments[_client][_beneficiary].nextPaymentTimestamp = _startTimestamp;
666         pullPayments[_client][_beneficiary].lastPaymentTimestamp = 0;
667         pullPayments[_client][_beneficiary].cancelTimestamp = 0;
668 
669         if (isFundingNeeded(msg.sender)) {
670             msg.sender.transfer(0.5 ether);
671         }
672 
673         emit LogPaymentRegistered(_client, _beneficiary, _paymentID);
674     }
675 
676     /// @dev Deletes a pull payment for a beneficiary - The deletion needs can be executed only by one of the executors of the PumaPay Pull Payment Contract
677     /// and the PumaPay Pull Payment Contract checks that the beneficiary and the paymentID have been singed by the client of the account.
678     /// This method sets the cancellation of the pull payment in the pull payments array for this beneficiary specified.
679     /// The balance of the executor (msg.sender) is checked and if funding is needed 1 ETH is transferred.
680     /// Emits 'LogPaymentCancelled' with beneficiary address and paymentID.
681     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
682     /// @param r - R output of ECDSA signature.
683     /// @param s - S output of ECDSA signature.
684     /// @param _paymentID - ID of the payment.
685     /// @param _client - client address that is linked to this pull payment.
686     /// @param _beneficiary - address that is allowed to execute this pull payment.
687     function deletePullPayment(
688         uint8 v,
689         bytes32 r,
690         bytes32 s,
691         string _paymentID,
692         address _client,
693         address _beneficiary
694     )
695     public
696     isExecutor()
697     paymentExists(_client, _beneficiary)
698     paymentNotCancelled(_client, _beneficiary)
699     isValidDeletionRequest(_paymentID, _client, _beneficiary)
700     {
701         require(isValidDeletion(v, r, s, _paymentID, _client, _beneficiary));
702 
703         pullPayments[_client][_beneficiary].cancelTimestamp = now;
704 
705         if (isFundingNeeded(msg.sender)) {
706             msg.sender.transfer(0.5 ether);
707         }
708 
709         emit LogPaymentCancelled(_client, _beneficiary, _paymentID);
710     }
711 
712     /// ===============================================================================================================
713     ///                                      Public Functions
714     /// ===============================================================================================================
715 
716     /// @dev Executes a pull payment for the msg.sender - The pull payment should exist and the payment request
717     /// should be valid in terms of when it can be executed.
718     /// Emits 'LogPullPaymentExecuted' with client address, msg.sender as the beneficiary address and the paymentID.
719     /// Use Case 1: Single/Recurring Fixed Pull Payment (initialPaymentAmountInCents == 0 )
720     /// ------------------------------------------------
721     /// We calculate the amount in PMA using the rate for the currency specified in the pull payment
722     /// and the 'fiatAmountInCents' and we transfer from the client account the amount in PMA.
723     /// After execution we set the last payment timestamp to NOW, the next payment timestamp is incremented by
724     /// the frequency and the number of payments is decresed by 1.
725     /// Use Case 2: Recurring Fixed Pull Payment with initial fee (initialPaymentAmountInCents > 0)
726     /// ------------------------------------------------------------------------------------------------
727     /// We calculate the amount in PMA using the rate for the currency specified in the pull payment
728     /// and the 'initialPaymentAmountInCents' and we transfer from the client account the amount in PMA.
729     /// After execution we set the last payment timestamp to NOW and the 'initialPaymentAmountInCents to ZERO.
730     /// @param _client - address of the client from which the msg.sender requires to pull funds.
731     function executePullPayment(address _client, string _paymentID)
732     public
733     paymentExists(_client, msg.sender)
734     isValidPullPaymentRequest(_client, msg.sender, _paymentID)
735     {
736         uint256 amountInPMA;
737         if (pullPayments[_client][msg.sender].initialPaymentAmountInCents > 0) {
738             amountInPMA = calculatePMAFromFiat(pullPayments[_client][msg.sender].initialPaymentAmountInCents, pullPayments[_client][msg.sender].currency);
739             pullPayments[_client][msg.sender].initialPaymentAmountInCents = 0;
740         } else {
741             amountInPMA = calculatePMAFromFiat(pullPayments[_client][msg.sender].fiatAmountInCents, pullPayments[_client][msg.sender].currency);
742 
743             pullPayments[_client][msg.sender].nextPaymentTimestamp = pullPayments[_client][msg.sender].nextPaymentTimestamp + pullPayments[_client][msg.sender].frequency;
744             pullPayments[_client][msg.sender].numberOfPayments = pullPayments[_client][msg.sender].numberOfPayments - 1;
745         }
746         pullPayments[_client][msg.sender].lastPaymentTimestamp = now;
747         token.transferFrom(_client, msg.sender, amountInPMA);
748 
749         emit LogPullPaymentExecuted(_client, msg.sender, pullPayments[_client][msg.sender].paymentID);
750     }
751 
752     function getRate(string _currency) public view returns (uint256) {
753         return exchangeRates[_currency];
754     }
755 
756     /// ===============================================================================================================
757     ///                                      Internal Functions
758     /// ===============================================================================================================
759 
760     /// @dev Calculates the PMA Rate for the fiat currency specified - The rate is set every 10 minutes by our PMA server
761     /// for the currencies specified in the smart contract. 
762     /// @param _fiatAmountInCents - payment amount in fiat CENTS so that is always integer
763     /// @param _currency - currency in which the payment needs to take place
764     /// RATE CALCULATION EXAMPLE
765     /// ------------------------
766     /// RATE ==> 1 PMA = 0.01 USD$
767     /// 1 USD$ = 1/0.01 PMA = 100 PMA
768     /// Start the calculation from one ether - PMA Token has 18 decimals
769     /// Multiply by the DECIMAL_FIXER (1e+10) to fix the multiplication of the rate
770     /// Multiply with the fiat amount in cents
771     /// Divide by the Rate of PMA to Fiat in cents
772     /// Divide by the FIAT_TO_CENT_FIXER to fix the _fiatAmountInCents
773     function calculatePMAFromFiat(uint256 _fiatAmountInCents, string _currency)
774     internal
775     view
776     returns (uint256) {
777         return ONE_ETHER.mul(DECIMAL_FIXER).mul(_fiatAmountInCents).div(exchangeRates[_currency]).div(FIAT_TO_CENT_FIXER);
778     }
779 
780     /// @dev Checks if a registration request is valid by comparing the v, r, s params
781     /// and the hashed params with the client address.
782     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
783     /// @param r - R output of ECDSA signature.
784     /// @param s - S output of ECDSA signature.
785     /// @param _client - client address that is linked to this pull payment.
786     /// @param _beneficiary - address that is allowed to execute this pull payment.
787     /// @param _pullPayment - pull payment to be validated.
788     /// @return bool - if the v, r, s params with the hashed params match the client address
789     function isValidRegistration(
790         uint8 v,
791         bytes32 r,
792         bytes32 s,
793         address _client,
794         address _beneficiary,
795         PullPayment _pullPayment
796     )
797     internal
798     pure
799     returns (bool)
800     {
801         return ecrecover(
802             keccak256(
803                 abi.encodePacked(
804                     _beneficiary,
805                     _pullPayment.currency,
806                     _pullPayment.initialPaymentAmountInCents,
807                     _pullPayment.fiatAmountInCents,
808                     _pullPayment.frequency,
809                     _pullPayment.numberOfPayments,
810                     _pullPayment.startTimestamp
811                 )
812             ),
813             v, r, s) == _client;
814     }
815 
816     /// @dev Checks if a deletion request is valid by comparing the v, r, s params
817     /// and the hashed params with the client address.
818     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
819     /// @param r - R output of ECDSA signature.
820     /// @param s - S output of ECDSA signature.
821     /// @param _paymentID - ID of the payment.
822     /// @param _client - client address that is linked to this pull payment.
823     /// @param _beneficiary - address that is allowed to execute this pull payment.
824     /// @return bool - if the v, r, s params with the hashed params match the client address
825     function isValidDeletion(
826         uint8 v,
827         bytes32 r,
828         bytes32 s,
829         string _paymentID,
830         address _client,
831         address _beneficiary
832     )
833     internal
834     view
835     returns (bool)
836     {
837         return ecrecover(
838             keccak256(
839                 abi.encodePacked(
840                     _paymentID,
841                     _beneficiary
842                 )
843             ), v, r, s) == _client
844         && keccak256(
845             abi.encodePacked(pullPayments[_client][_beneficiary].paymentID)
846         ) == keccak256(abi.encodePacked(_paymentID));
847     }
848 
849     /// @dev Checks if a payment for a beneficiary of a client exists.
850     /// @param _client - client address that is linked to this pull payment.
851     /// @param _beneficiary - address to execute a pull payment.
852     /// @return bool - whether the beneficiary for this client has a pull payment to execute.
853     function doesPaymentExist(address _client, address _beneficiary)
854     internal
855     view
856     returns (bool) {
857         return (
858         bytes(pullPayments[_client][_beneficiary].currency).length > 0 &&
859         pullPayments[_client][_beneficiary].fiatAmountInCents > 0 &&
860         pullPayments[_client][_beneficiary].frequency > 0 &&
861         pullPayments[_client][_beneficiary].startTimestamp > 0 &&
862         pullPayments[_client][_beneficiary].numberOfPayments > 0 &&
863         pullPayments[_client][_beneficiary].nextPaymentTimestamp > 0
864         );
865     }
866 
867     /// @dev Checks if the address of an owner/executor needs to be funded. 
868     /// The minimum amount the owner/executors should always have is 0.001 ETH 
869     /// @param _address - address of owner/executors that the balance is checked against. 
870     /// @return bool - whether the address needs more ETH.
871     function isFundingNeeded(address _address)
872     private
873     view
874     returns (bool) {
875         return address(_address).balance <= MINIMUM_AMOUNT_OF_ETH_FOR_OPARATORS;
876     }
877 }