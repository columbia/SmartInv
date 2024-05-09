1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Log Various Error Types
5  * @author Adam Lemmon <adam@oraclize.it>
6  * @dev Inherit this contract and your may now log errors easily
7  * To support various error types, params, etc.
8  */
9 contract LoggingErrors {
10   /**
11   * Events
12   */
13   event LogErrorString(string errorString);
14 
15   /**
16   * Error cases
17   */
18 
19   /**
20    * @dev Default error to simply log the error message and return
21    * @param _errorMessage The error message to log
22    * @return ALWAYS false
23    */
24   function error(string _errorMessage) internal returns(bool) {
25     LogErrorString(_errorMessage);
26     return false;
27   }
28 }
29 
30 /**
31  * @title Wallet Connector
32  * @dev Connect the wallet contract to the correct Wallet Logic version
33  */
34 contract WalletConnector is LoggingErrors {
35   /**
36    * Storage
37    */
38   address public owner_;
39   address public latestLogic_;
40   uint256 public latestVersion_;
41   mapping(uint256 => address) public logicVersions_;
42   uint256 public birthBlock_;
43 
44   /**
45    * Events
46    */
47   event LogLogicVersionAdded(uint256 version);
48   event LogLogicVersionRemoved(uint256 version);
49 
50   /**
51    * @dev Constructor to set the latest logic address
52    * @param _latestVersion Latest version of the wallet logic
53    * @param _latestLogic Latest address of the wallet logic contract
54    */
55   function WalletConnector (
56     uint256 _latestVersion,
57     address _latestLogic
58   ) public {
59     owner_ = msg.sender;
60     latestLogic_ = _latestLogic;
61     latestVersion_ = _latestVersion;
62     logicVersions_[_latestVersion] = _latestLogic;
63     birthBlock_ = block.number;
64   }
65 
66   /**
67    * Add a new version of the logic contract
68    * @param _version The version to be associated with the new contract.
69    * @param _logic New logic contract.
70    * @return Success of the transaction.
71    */
72   function addLogicVersion (
73     uint256 _version,
74     address _logic
75   ) external
76     returns(bool)
77   {
78     if (msg.sender != owner_)
79       return error('msg.sender != owner, WalletConnector.addLogicVersion()');
80 
81     if (logicVersions_[_version] != 0)
82       return error('Version already exists, WalletConnector.addLogicVersion()');
83 
84     // Update latest if this is the latest version
85     if (_version > latestVersion_) {
86       latestLogic_ = _logic;
87       latestVersion_ = _version;
88     }
89 
90     logicVersions_[_version] = _logic;
91     LogLogicVersionAdded(_version);
92 
93     return true;
94   }
95 
96   /**
97    * @dev Remove a version. Cannot remove the latest version.
98    * @param  _version The version to remove.
99    */
100   function removeLogicVersion(uint256 _version) external {
101     require(msg.sender == owner_);
102     require(_version != latestVersion_);
103     delete logicVersions_[_version];
104     LogLogicVersionRemoved(_version);
105   }
106 
107   /**
108    * Constants
109    */
110 
111   /**
112    * Called from user wallets in order to upgrade their logic.
113    * @param _version The version to upgrade to. NOTE pass in 0 to upgrade to latest.
114    * @return The address of the logic contract to upgrade to.
115    */
116   function getLogic(uint256 _version)
117     external
118     constant
119     returns(address)
120   {
121     if (_version == 0)
122       return latestLogic_;
123     else
124       return logicVersions_[_version];
125   }
126 }
127 
128 /**
129  * @title Wallet to hold and trade ERC20 tokens and ether
130  * @author Adam Lemmon <adam@oraclize.it>
131  * @dev User wallet to interact with the exchange.
132  * all tokens and ether held in this wallet, 1 to 1 mapping to user EOAs.
133  */
134 contract Wallet is LoggingErrors {
135   /**
136    * Storage
137    */
138   // Vars included in wallet logic "lib", the order must match between Wallet and Logic
139   address public owner_;
140   address public exchange_;
141   mapping(address => uint256) public tokenBalances_;
142 
143   address public logic_; // storage location 0x3 loaded for delegatecalls so this var must remain at index 3
144   uint256 public birthBlock_;
145 
146   // Address updated at deploy time
147   WalletConnector private connector_ = WalletConnector(0x03d6e7b2f48120fd57a89ff0bbd56e9ec39af21c);
148 
149   /**
150    * Events
151    */
152   event LogDeposit(address token, uint256 amount, uint256 balance);
153   event LogWithdrawal(address token, uint256 amount, uint256 balance);
154 
155   /**
156    * @dev Contract consturtor. Set user as owner and connector address.
157    * @param _owner The address of the user's EOA, wallets created from the exchange
158    * so must past in the owner address, msg.sender == exchange.
159    */
160   function Wallet(address _owner) public {
161     owner_ = _owner;
162     exchange_ = msg.sender;
163     logic_ = connector_.latestLogic_();
164     birthBlock_ = block.number;
165   }
166 
167   /**
168    * @dev Fallback - Only enable funds to be sent from the exchange.
169    * Ensures balances will be consistent.
170    */
171   function () external payable {
172     require(msg.sender == exchange_);
173   }
174 
175   /**
176   * External
177   */
178 
179   /**
180    * @dev Deposit ether into this wallet, default to address 0 for consistent token lookup.
181    */
182   function depositEther()
183     external
184     payable
185   {
186     require(logic_.delegatecall(bytes4(sha3('deposit(address,uint256)')), 0, msg.value));
187   }
188 
189   /**
190    * @dev Deposit any ERC20 token into this wallet.
191    * @param _token The address of the existing token contract.
192    * @param _amount The amount of tokens to deposit.
193    * @return Bool if the deposit was successful.
194    */
195   function depositERC20Token (
196     address _token,
197     uint256 _amount
198   ) external
199     returns(bool)
200   {
201     // ether
202     if (_token == 0)
203       return error('Cannot deposit ether via depositERC20, Wallet.depositERC20Token()');
204 
205     require(logic_.delegatecall(bytes4(sha3('deposit(address,uint256)')), _token, _amount));
206     return true;
207   }
208 
209   /**
210    * @dev The result of an order, update the balance of this wallet.
211    * @param _token The address of the token balance to update.
212    * @param _amount The amount to update the balance by.
213    * @param _subtractionFlag If true then subtract the token amount else add.
214    * @return Bool if the update was successful.
215    */
216   function updateBalance (
217     address _token,
218     uint256 _amount,
219     bool _subtractionFlag
220   ) external
221     returns(bool)
222   {
223     assembly {
224       calldatacopy(0x40, 0, calldatasize)
225       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
226       return(0, 32)
227       pop
228     }
229   }
230 
231   /**
232    * User may update to the latest version of the exchange contract.
233    * Note that multiple versions are NOT supported at this time and therefore if a
234    * user does not wish to update they will no longer be able to use the exchange.
235    * @param _exchange The new exchange.
236    * @return Success of this transaction.
237    */
238   function updateExchange(address _exchange)
239     external
240     returns(bool)
241   {
242     if (msg.sender != owner_)
243       return error('msg.sender != owner_, Wallet.updateExchange()');
244 
245     // If subsequent messages are not sent from this address all orders will fail
246     exchange_ = _exchange;
247 
248     return true;
249   }
250 
251   /**
252    * User may update to a new or older version of the logic contract.
253    * @param _version The versin to update to.
254    * @return Success of this transaction.
255    */
256   function updateLogic(uint256 _version)
257     external
258     returns(bool)
259   {
260     if (msg.sender != owner_)
261       return error('msg.sender != owner_, Wallet.updateLogic()');
262 
263     address newVersion = connector_.getLogic(_version);
264 
265     // Invalid version as defined by connector
266     if (newVersion == 0)
267       return error('Invalid version, Wallet.updateLogic()');
268 
269     logic_ = newVersion;
270     return true;
271   }
272 
273   /**
274    * @dev Verify an order that the Exchange has received involving this wallet.
275    * Internal checks and then authorize the exchange to move the tokens.
276    * If sending ether will transfer to the exchange to broker the trade.
277    * @param _token The address of the token contract being sold.
278    * @param _amount The amount of tokens the order is for.
279    * @param _fee The fee for the current trade.
280    * @param _feeToken The token of which the fee is to be paid in.
281    * @return If the order was verified or not.
282    */
283   function verifyOrder (
284     address _token,
285     uint256 _amount,
286     uint256 _fee,
287     address _feeToken
288   ) external
289     returns(bool)
290   {
291     assembly {
292       calldatacopy(0x40, 0, calldatasize)
293       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
294       return(0, 32)
295       pop
296     }
297   }
298 
299   /**
300    * @dev Withdraw any token, including ether from this wallet to an EOA.
301    * @param _token The address of the token to withdraw.
302    * @param _amount The amount to withdraw.
303    * @return Success of the withdrawal.
304    */
305   function withdraw(address _token, uint256 _amount)
306     external
307     returns(bool)
308   {
309     if(msg.sender != owner_)
310       return error('msg.sender != owner, Wallet.withdraw()');
311 
312     assembly {
313       calldatacopy(0x40, 0, calldatasize)
314       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
315       return(0, 32)
316       pop
317     }
318   }
319 
320   /**
321    * Constants
322    */
323 
324   /**
325    * @dev Get the balance for a specific token.
326    * @param _token The address of the token contract to retrieve the balance of.
327    * @return The current balance within this contract.
328    */
329   function balanceOf(address _token)
330     public
331     constant
332     returns(uint)
333   {
334     return tokenBalances_[_token];
335   }
336 }
337 
338 /**
339  * @title SafeMath
340  * @dev Math operations with safety checks that throw on error
341  */
342 library SafeMath {
343   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
344     uint256 c = a * b;
345     assert(a == 0 || c / a == b);
346     return c;
347   }
348 
349   function div(uint256 a, uint256 b) internal constant returns (uint256) {
350     // assert(b > 0); // Solidity automatically throws when dividing by 0
351     uint256 c = a / b;
352     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
353     return c;
354   }
355 
356   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
357     assert(b <= a);
358     return a - b;
359   }
360 
361   function add(uint256 a, uint256 b) internal constant returns (uint256) {
362     uint256 c = a + b;
363     assert(c >= a);
364     return c;
365   }
366 }
367 
368 
369 contract Token {
370   /// @return total amount of tokens
371   function totalSupply() constant returns (uint256 supply) {}
372 
373   /// @param _owner The address from which the balance will be retrieved
374   /// @return The balance
375   function balanceOf(address _owner) constant returns (uint256 balance) {}
376 
377   /// @notice send `_value` token to `_to` from `msg.sender`
378   /// @param _to The address of the recipient
379   /// @param _value The amount of token to be transferred
380   /// @return Whether the transfer was successful or not
381   function transfer(address _to, uint256 _value) returns (bool success) {}
382 
383   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
384   /// @param _from The address of the sender
385   /// @param _to The address of the recipient
386   /// @param _value The amount of token to be transferred
387   /// @return Whether the transfer was successful or not
388   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
389 
390   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
391   /// @param _spender The address of the account able to transfer the tokens
392   /// @param _value The amount of wei to be approved for transfer
393   /// @return Whether the approval was successful or not
394   function approve(address _spender, uint256 _value) returns (bool success) {}
395 
396   /// @param _owner The address of the account owning tokens
397   /// @param _spender The address of the account able to transfer the tokens
398   /// @return Amount of remaining tokens allowed to spent
399   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
400 
401   event Transfer(address indexed _from, address indexed _to, uint256 _value);
402   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
403 
404   uint public decimals;
405   string public name;
406 }
407 
408 
409 /**
410  * @title Decentralized exchange for ether and ERC20 tokens.
411  * @author Adam Lemmon <adam@oraclize.it>
412  * @dev All trades brokered by this contract.
413  * Orders submitted by off chain order book and this contract handles
414  * verification and execution of orders.
415  * All value between parties is transferred via this exchange.
416  * Methods arranged by visibility; external, public, internal, private and alphabatized within.
417  */
418 contract Exchange is LoggingErrors {
419 
420   using SafeMath for uint256;
421 
422   /**
423    * Data Structures
424    */
425   struct Order {
426     bool active_;  // True: active, False: filled or cancelled
427     address offerToken_;
428     uint256 offerTokenTotal_;
429     uint256 offerTokenRemaining_;  // Amount left to give
430     address wantToken_;
431     uint256 wantTokenTotal_;
432     uint256 wantTokenReceived_;  // Amount received, note this may exceed want total
433   }
434 
435   /**
436    * Storage
437    */
438   address private orderBookAccount_;
439   address private owner_;
440   uint256 public minOrderEthAmount_;
441   uint256 public birthBlock_;
442   address public edoToken_;
443   uint256 public edoPerWei_;
444   uint256 public edoPerWeiDecimals_;
445   address public eidooWallet_;
446   mapping(bytes32 => Order) public orders_; // Map order hashes to order data struct
447   mapping(address => address) public userAccountToWallet_; // User EOA to wallet addresses
448 
449   /**
450    * Events
451    */
452   event LogEdoRateSet(uint256 rate);
453   event LogOrderExecutionSuccess();
454   event LogOrderFilled(bytes32 indexed orderId, uint256 fillAmount, uint256 fillRemaining);
455   event LogUserAdded(address indexed user, address walletAddress);
456   event LogWalletDeposit(address indexed walletAddress, address token, uint256 amount, uint256 balance);
457   event LogWalletWithdrawal(address indexed walletAddress, address token, uint256 amount, uint256 balance);
458 
459   /**
460    * @dev Contract constructor - CONFIRM matches contract name.  Set owner and addr of order book.
461    * @param _bookAccount The EOA address for the order book, will submit ALL orders.
462    * @param _minOrderEthAmount Minimum amount of ether that each order must contain.
463    * @param _edoToken Deployed edo token.
464    * @param _edoPerWei Rate of edo tokens per wei.
465    * @param _edoPerWeiDecimals Decimlas carried in edo rate.
466    * @param _eidooWallet Wallet to pay fees to.
467    */
468   function Exchange(
469     address _bookAccount,
470     uint256 _minOrderEthAmount,
471     address _edoToken,
472     uint256 _edoPerWei,
473     uint256 _edoPerWeiDecimals,
474     address _eidooWallet
475   ) public {
476     orderBookAccount_ = _bookAccount;
477     minOrderEthAmount_ = _minOrderEthAmount;
478     owner_ = msg.sender;
479     birthBlock_ = block.number;
480     edoToken_ = _edoToken;
481     edoPerWei_ = _edoPerWei;
482     edoPerWeiDecimals_ = _edoPerWeiDecimals;
483     eidooWallet_ = _eidooWallet;
484   }
485 
486   /**
487    * @dev Fallback. wallets utilize to send ether in order to broker trade.
488    */
489   function () external payable { }
490 
491   /**
492    * External
493    */
494 
495   /**
496    * @dev Add a new user to the exchange, create a wallet for them.
497    * Map their account address to the wallet contract for lookup.
498    * @param _userAccount The address of the user's EOA.
499    * @return Success of the transaction, false if error condition met.
500    */
501   function addNewUser(address _userAccount)
502     external
503     returns (bool)
504   {
505     if (userAccountToWallet_[_userAccount] != address(0))
506       return error('User already exists, Exchange.addNewUser()');
507 
508     // Pass the userAccount address to wallet constructor so owner is not the exchange contract
509     address userWallet = new Wallet(_userAccount);
510 
511     userAccountToWallet_[_userAccount] = userWallet;
512 
513     LogUserAdded(_userAccount, userWallet);
514 
515     return true;
516   }
517 
518   /**
519    * Execute orders in batches.
520    * @param  _token_and_EOA_Addresses Tokan and user addresses.
521    * @param  _amountsExpirationAndSalt Offer and want token amount and expiration and salt values.
522    * @param _sig_v All order signature v values.
523    * @param _sig_r_and_s All order signature r and r values.
524    * @return The success of this transaction.
525    */
526   function batchExecuteOrder(
527     address[4][] _token_and_EOA_Addresses,
528     uint256[8][] _amountsExpirationAndSalt, // Packing to save stack size
529     uint8[2][] _sig_v,
530     bytes32[4][] _sig_r_and_s
531   ) external
532     returns(bool)
533   {
534     for (uint256 i = 0; i < _amountsExpirationAndSalt.length; i++) {
535       require(executeOrder(
536         _token_and_EOA_Addresses[i],
537         _amountsExpirationAndSalt[i],
538         _sig_v[i],
539         _sig_r_and_s[i]
540       ));
541     }
542 
543     return true;
544   }
545 
546   /**
547    * @dev Execute an order that was submitted by the external order book server.
548    * The order book server believes it to be a match.
549    * There are components for both orders, maker and taker, 2 signatures as well.
550    * @param _token_and_EOA_Addresses The addresses of the maker and taker EOAs and offered token contracts.
551    * [makerEOA, makerOfferToken, takerEOA, takerOfferToken]
552    * @param _amountsExpirationAndSalt The amount of tokens, [makerOffer, makerWant, takerOffer, takerWant].
553    * and the block number at which this order expires
554    * and a random number to mitigate replay. [makerExpiry, makerSalt, takerExpiry, takerSalt]
555    * @param _sig_v ECDSA signature parameter v, maker 0 and taker 1.
556    * @param _sig_r_and_s ECDSA signature parameters r ans s, maker 0, 1 and taker 2, 3.
557    * @return Success of the transaction, false if error condition met.
558    * Like types grouped to eliminate stack depth error
559    */
560   function executeOrder (
561     address[4] _token_and_EOA_Addresses,
562     uint256[8] _amountsExpirationAndSalt, // Packing to save stack size
563     uint8[2] _sig_v,
564     bytes32[4] _sig_r_and_s
565   ) public
566     returns(bool)
567   {
568     // Only read wallet addresses from storage once
569     // Need one more stack slot so squashing into array
570     Wallet[2] memory wallets = [
571       Wallet(userAccountToWallet_[_token_and_EOA_Addresses[0]]), // maker
572       Wallet(userAccountToWallet_[_token_and_EOA_Addresses[2]]) // taker
573     ];
574 
575     // Basic pre-conditions, return if any input data is invalid
576     if(!__executeOrderInputIsValid__(
577       _token_and_EOA_Addresses,
578       _amountsExpirationAndSalt,
579       wallets[0],
580       wallets[1]
581     ))
582       return error('Input is invalid, Exchange.executeOrder()');
583 
584     // Verify Maker and Taker signatures
585     bytes32 makerOrderHash;
586     bytes32 takerOrderHash;
587     (makerOrderHash, takerOrderHash) = __generateOrderHashes__(_token_and_EOA_Addresses, _amountsExpirationAndSalt);
588 
589     if (!__signatureIsValid__(
590       _token_and_EOA_Addresses[0],
591       makerOrderHash,
592       _sig_v[0],
593       _sig_r_and_s[0],
594       _sig_r_and_s[1]
595     ))
596       return error('Maker signature is invalid, Exchange.executeOrder()');
597 
598     if (!__signatureIsValid__(
599       _token_and_EOA_Addresses[2],
600       takerOrderHash,
601       _sig_v[1],
602       _sig_r_and_s[2],
603       _sig_r_and_s[3]
604     ))
605       return error('Taker signature is invalid, Exchange.executeOrder()');
606 
607     // Exchange Order Verification and matching.
608     Order memory makerOrder = orders_[makerOrderHash];
609     Order memory takerOrder = orders_[takerOrderHash];
610 
611     if (makerOrder.wantTokenTotal_ == 0) {  // Check for existence
612       makerOrder.active_ = true;
613       makerOrder.offerToken_ = _token_and_EOA_Addresses[1];
614       makerOrder.offerTokenTotal_ = _amountsExpirationAndSalt[0];
615       makerOrder.offerTokenRemaining_ = _amountsExpirationAndSalt[0]; // Amount to give
616       makerOrder.wantToken_ = _token_and_EOA_Addresses[3];
617       makerOrder.wantTokenTotal_ = _amountsExpirationAndSalt[1];
618       makerOrder.wantTokenReceived_ = 0; // Amount received
619     }
620 
621     if (takerOrder.wantTokenTotal_ == 0) {  // Check for existence
622       takerOrder.active_ = true;
623       takerOrder.offerToken_ = _token_and_EOA_Addresses[3];
624       takerOrder.offerTokenTotal_ = _amountsExpirationAndSalt[2];
625       takerOrder.offerTokenRemaining_ = _amountsExpirationAndSalt[2];  // Amount to give
626       takerOrder.wantToken_ = _token_and_EOA_Addresses[1];
627       takerOrder.wantTokenTotal_ = _amountsExpirationAndSalt[3];
628       takerOrder.wantTokenReceived_ = 0; // Amount received
629     }
630 
631     if (!__ordersMatch_and_AreVaild__(makerOrder, takerOrder))
632       return error('Orders do not match, Exchange.executeOrder()');
633 
634     // Trade amounts
635     uint256 toTakerAmount;
636     uint256 toMakerAmount;
637     (toTakerAmount, toMakerAmount) = __getTradeAmounts__(makerOrder, takerOrder);
638 
639     // TODO consider removing. Can this condition be met?
640     if (toTakerAmount < 1 || toMakerAmount < 1)
641       return error('Token amount < 1, price ratio is invalid! Token value < 1, Exchange.executeOrder()');
642 
643     // Taker is offering edo tokens so ensure sufficient balance in order to offer edo and pay fee in edo
644     if (
645         takerOrder.offerToken_ == edoToken_ &&
646         Token(edoToken_).balanceOf(wallets[1]) < __calculateFee__(makerOrder, toTakerAmount, toMakerAmount).add(toMakerAmount)
647       ) {
648         return error('Taker has an insufficient EDO token balance to cover the fee AND the offer, Exchange.executeOrder()');
649     // Taker has sufficent EDO token balance to pay the fee
650     } else if (Token(edoToken_).balanceOf(wallets[1]) < __calculateFee__(makerOrder, toTakerAmount, toMakerAmount))
651       return error('Taker has an insufficient EDO token balance to cover the fee, Exchange.executeOrder()');
652 
653     // Wallet Order Verification, reach out to the maker and taker wallets.
654     if (!__ordersVerifiedByWallets__(
655         _token_and_EOA_Addresses,
656         toMakerAmount,
657         toTakerAmount,
658         wallets[0],
659         wallets[1],
660         __calculateFee__(makerOrder, toTakerAmount, toMakerAmount)
661       ))
662       return error('Order could not be verified by wallets, Exchange.executeOrder()');
663 
664     // Order Execution, Order Fully Verified by this point, time to execute!
665     // Local order structs
666     __updateOrders__(makerOrder, takerOrder, toTakerAmount, toMakerAmount);
667 
668     // Write to storage then external calls
669     //  Update orders active flag if filled
670     if (makerOrder.offerTokenRemaining_ == 0)
671       makerOrder.active_ = false;
672 
673     if (takerOrder.offerTokenRemaining_ == 0)
674       takerOrder.active_ = false;
675 
676     // Finally write orders to storage
677     orders_[makerOrderHash] = makerOrder;
678     orders_[takerOrderHash] = takerOrder;
679 
680     // Transfer the external value, ether <> tokens
681     require(
682       __executeTokenTransfer__(
683         _token_and_EOA_Addresses,
684         toTakerAmount,
685         toMakerAmount,
686         __calculateFee__(makerOrder, toTakerAmount, toMakerAmount),
687         wallets[0],
688         wallets[1]
689       )
690     );
691 
692     // Log the order id(hash), amount of offer given, amount of offer remaining
693     LogOrderFilled(makerOrderHash, toTakerAmount, makerOrder.offerTokenRemaining_);
694     LogOrderFilled(takerOrderHash, toMakerAmount, takerOrder.offerTokenRemaining_);
695 
696     LogOrderExecutionSuccess();
697 
698     return true;
699   }
700 
701   /**
702    * @dev Set the rate of wei per edo token in or to calculate edo fee
703    * @param _edoPerWei Rate of edo tokens per wei.
704    * @return Success of the transaction.
705    */
706   function setEdoRate(
707     uint256 _edoPerWei
708   ) external
709     returns(bool)
710   {
711     if (msg.sender != owner_)
712       return error('msg.sender != owner, Exchange.setEdoRate()');
713 
714     edoPerWei_ = _edoPerWei;
715 
716     LogEdoRateSet(edoPerWei_);
717 
718     return true;
719   }
720 
721   /**
722    * @dev Set the wallet for fees to be paid to.
723    * @param _eidooWallet Wallet to pay fees to.
724    * @return Success of the transaction.
725    */
726   function setEidooWallet(
727     address _eidooWallet
728   ) external
729     returns(bool)
730   {
731     if (msg.sender != owner_)
732       return error('msg.sender != owner, Exchange.setEidooWallet()');
733 
734     eidooWallet_ = _eidooWallet;
735 
736     return true;
737   }
738 
739   /**
740    * @dev Set the minimum amount of ether required per order.
741    * @param _minOrderEthAmount Min amount of ether required per order.
742    * @return Success of the transaction.
743    */
744   function setMinOrderEthAmount (
745     uint256 _minOrderEthAmount
746   ) external
747     returns(bool)
748   {
749     if (msg.sender != owner_)
750       return error('msg.sender != owner, Exchange.setMinOrderEtherAmount()');
751 
752     minOrderEthAmount_ = _minOrderEthAmount;
753 
754     return true;
755   }
756 
757   /**
758    * @dev Set a new order book account.
759    * @param _account The new order book account.
760    */
761   function setOrderBookAcount (
762     address _account
763   ) external
764     returns(bool)
765   {
766     if (msg.sender != owner_)
767       return error('msg.sender != owner, Exchange.setOrderBookAcount()');
768 
769     orderBookAccount_ = _account;
770     return true;
771   }
772 
773   /*
774    Methods to catch events from external contracts, user wallets primarily
775    */
776 
777   /**
778    * @dev Simply log the event to track wallet interaction off-chain
779    * @param _token The address of the token that was deposited.
780    * @param _amount The amount of the token that was deposited.
781    * @param _walletBalance The updated balance of the wallet after deposit.
782    */
783   function walletDeposit(
784     address _token,
785     uint256 _amount,
786     uint256 _walletBalance
787   ) external
788   {
789     LogWalletDeposit(msg.sender, _token, _amount, _walletBalance);
790   }
791 
792   /**
793    * @dev Simply log the event to track wallet interaction off-chain
794    * @param _token The address of the token that was deposited.
795    * @param _amount The amount of the token that was deposited.
796    * @param _walletBalance The updated balance of the wallet after deposit.
797    */
798   function walletWithdrawal(
799     address _token,
800     uint256 _amount,
801     uint256 _walletBalance
802   ) external
803   {
804     LogWalletWithdrawal(msg.sender, _token, _amount, _walletBalance);
805   }
806 
807   /**
808    * Private
809    */
810 
811   /**
812    * Calculate the fee for the given trade. Calculated as the set % of the wei amount
813    * converted into EDO tokens using the manually set conversion ratio.
814    * @param _makerOrder The maker order object.
815    * @param _toTaker The amount of tokens going to the taker.
816    * @param _toMaker The amount of tokens going to the maker.
817    * @return The total fee to be paid in EDO tokens.
818    */
819   function __calculateFee__(
820     Order _makerOrder,
821     uint256 _toTaker,
822     uint256 _toMaker
823   ) private
824     constant
825     returns(uint256)
826   {
827     // weiAmount * (fee %) * (EDO/Wei) / (decimals in edo/wei) / (decimals in percentage)
828     if (_makerOrder.offerToken_ == address(0)) {
829       return _toTaker.mul(edoPerWei_).div(10**edoPerWeiDecimals_);
830     } else {
831       return _toMaker.mul(edoPerWei_).div(10**edoPerWeiDecimals_);
832     }
833   }
834 
835   /**
836    * @dev Verify the input to order execution is valid.
837    * @param _token_and_EOA_Addresses The addresses of the maker and taker EOAs and offered token contracts.
838    * [makerEOA, makerOfferToken, takerEOA, takerOfferToken]
839    * @param _amountsExpirationAndSalt The amount of tokens, [makerOffer, makerWant, takerOffer, takerWant].
840    * as well as The block number at which this order expires, maker[4] and taker[6].
841    * @return Success if all checks pass.
842    */
843   function __executeOrderInputIsValid__(
844     address[4] _token_and_EOA_Addresses,
845     uint256[8] _amountsExpirationAndSalt,
846     address _makerWallet,
847     address _takerWallet
848   ) private
849     constant
850     returns(bool)
851   {
852     if (msg.sender != orderBookAccount_)
853       return error('msg.sender != orderBookAccount, Exchange.__executeOrderInputIsValid__()');
854 
855     if (block.number > _amountsExpirationAndSalt[4])
856       return error('Maker order has expired, Exchange.__executeOrderInputIsValid__()');
857 
858     if (block.number > _amountsExpirationAndSalt[6])
859       return error('Taker order has expired, Exchange.__executeOrderInputIsValid__()');
860 
861     // Wallets
862     if (_makerWallet == address(0))
863       return error('Maker wallet does not exist, Exchange.__executeOrderInputIsValid__()');
864 
865     if (_takerWallet == address(0))
866       return error('Taker wallet does not exist, Exchange.__executeOrderInputIsValid__()');
867 
868     // Tokens, addresses and amounts, ether exists
869     if (_token_and_EOA_Addresses[1] != address(0) && _token_and_EOA_Addresses[3] != address(0))
870       return error('Ether omitted! Is not offered by either the Taker or Maker, Exchange.__executeOrderInputIsValid__()');
871 
872     if (_token_and_EOA_Addresses[1] == address(0) && _token_and_EOA_Addresses[3] == address(0))
873       return error('Taker and Maker offer token are both ether, Exchange.__executeOrderInputIsValid__()');
874 
875     if (
876         _amountsExpirationAndSalt[0] == 0 ||
877         _amountsExpirationAndSalt[1] == 0 ||
878         _amountsExpirationAndSalt[2] == 0 ||
879         _amountsExpirationAndSalt[3] == 0
880       )
881       return error('May not execute an order where token amount == 0, Exchange.__executeOrderInputIsValid__()');
882 
883     // Confirm order ether amount >= min amount
884     // Maker
885     uint256 minOrderEthAmount = minOrderEthAmount_; // Single storage read
886     if (_token_and_EOA_Addresses[1] == 0 && _amountsExpirationAndSalt[0] < minOrderEthAmount)
887       return error('Maker order does not meet the minOrderEthAmount_ of ether, Exchange.__executeOrderInputIsValid__()');
888 
889     // Taker
890     if (_token_and_EOA_Addresses[3] == 0 && _amountsExpirationAndSalt[2] < minOrderEthAmount)
891       return error('Taker order does not meet the minOrderEthAmount_ of ether, Exchange.__executeOrderInputIsValid__()');
892 
893     return true;
894   }
895 
896   /**
897    * @dev Execute the external transfer of tokens.
898    * @param _token_and_EOA_Addresses The addresses of the maker and taker EOAs and offered token contracts.
899    * [makerEOA, makerOfferToken, takerEOA, takerOfferToken]
900    * @param _toTakerAmount The amount of tokens to transfer to the taker.
901    * @param _toMakerAmount The amount of tokens to transfer to the maker.
902    * @return Success if both wallets verify the order.
903    */
904   function __executeTokenTransfer__(
905     address[4] _token_and_EOA_Addresses,
906     uint256 _toTakerAmount,
907     uint256 _toMakerAmount,
908     uint256 _fee,
909     Wallet _makerWallet,
910     Wallet _takerWallet
911   ) private
912     returns (bool)
913   {
914     // Wallet mapping balances
915     address makerOfferToken = _token_and_EOA_Addresses[1];
916     address takerOfferToken = _token_and_EOA_Addresses[3];
917 
918     // Taker to pay fee before trading
919     require(_takerWallet.updateBalance(edoToken_, _fee, true));  // Subtraction flag
920     require(Token(edoToken_).transferFrom(_takerWallet, eidooWallet_, _fee));
921 
922     // Move the toTakerAmount from the maker to the taker
923     require(_makerWallet.updateBalance(makerOfferToken, _toTakerAmount, true));  // Subtraction flag
924       /*return error('Unable to subtract maker token from maker wallet, Exchange.__executeTokenTransfer__()');*/
925 
926     require(_takerWallet.updateBalance(makerOfferToken, _toTakerAmount, false));
927       /*return error('Unable to add maker token to taker wallet, Exchange.__executeTokenTransfer__()');*/
928 
929     // Move the toMakerAmount from the taker to the maker
930     require(_takerWallet.updateBalance(takerOfferToken, _toMakerAmount, true));  // Subtraction flag
931       /*return error('Unable to subtract taker token from taker wallet, Exchange.__executeTokenTransfer__()');*/
932 
933     require(_makerWallet.updateBalance(takerOfferToken, _toMakerAmount, false));
934       /*return error('Unable to add taker token to maker wallet, Exchange.__executeTokenTransfer__()');*/
935 
936     // Contract ether balances and token contract balances
937     // Ether to the taker and tokens to the maker
938     if (makerOfferToken == address(0)) {
939       _takerWallet.transfer(_toTakerAmount);
940       require(
941         Token(takerOfferToken).transferFrom(_takerWallet, _makerWallet, _toMakerAmount)
942       );
943       assert(
944         __tokenAndWalletBalancesMatch__(_makerWallet, _takerWallet, takerOfferToken)
945       );
946 
947     // Ether to the maker and tokens to the taker
948     } else if (takerOfferToken == address(0)) {
949       _makerWallet.transfer(_toMakerAmount);
950       require(
951         Token(makerOfferToken).transferFrom(_makerWallet, _takerWallet, _toTakerAmount)
952       );
953       assert(
954         __tokenAndWalletBalancesMatch__(_makerWallet, _takerWallet, makerOfferToken)
955       );
956 
957     // Something went wrong one had to have been ether
958     } else revert();
959 
960     return true;
961   }
962 
963   /**
964    * @dev compute the log10 of a given number, takes the floor, ie. 2.5 = 2
965    * @param _number The number to compute the log 10 of.
966    * @return The floored log 10.
967    */
968   function __flooredLog10__(uint _number)
969     public
970     constant
971     returns (uint256)
972   {
973     uint unit = 0;
974     while (_number / (10**unit) >= 10)
975       unit++;
976     return unit;
977   }
978 
979   /**
980    * @dev Calculates Keccak-256 hash of order with specified parameters.
981    * @param _token_and_EOA_Addresses The addresses of the order, [makerEOA, makerOfferToken, makerWantToken].
982    * @param _amountsExpirationAndSalt The amount of tokens as well as
983    * the block number at which this order expires and random salt number.
984    * @return Keccak-256 hash of each order.
985    */
986   function __generateOrderHashes__(
987     address[4] _token_and_EOA_Addresses,
988     uint256[8] _amountsExpirationAndSalt
989   ) private
990     constant
991     returns (bytes32, bytes32)
992   {
993     bytes32 makerOrderHash = keccak256(
994       address(this),
995       _token_and_EOA_Addresses[0], // _makerEOA
996       _token_and_EOA_Addresses[1], // offerToken
997       _amountsExpirationAndSalt[0],  // offerTokenAmount
998       _token_and_EOA_Addresses[3], // wantToken
999       _amountsExpirationAndSalt[1],  // wantTokenAmount
1000       _amountsExpirationAndSalt[4], // expiry
1001       _amountsExpirationAndSalt[5] // salt
1002     );
1003 
1004 
1005     bytes32 takerOrderHash = keccak256(
1006       address(this),
1007       _token_and_EOA_Addresses[2], // _makerEOA
1008       _token_and_EOA_Addresses[3], // offerToken
1009       _amountsExpirationAndSalt[2],  // offerTokenAmount
1010       _token_and_EOA_Addresses[1], // wantToken
1011       _amountsExpirationAndSalt[3],  // wantTokenAmount
1012       _amountsExpirationAndSalt[6], // expiry
1013       _amountsExpirationAndSalt[7] // salt
1014     );
1015 
1016     return (makerOrderHash, takerOrderHash);
1017   }
1018 
1019   /**
1020    * @dev Returns the price ratio for this order.
1021    * The ratio is calculated with the largest value as the numerator, this aids
1022    * to significantly reduce rounding errors.
1023    * @param _makerOrder The maker order data structure.
1024    * @return The ratio to `_decimals` decimal places.
1025    */
1026   function __getOrderPriceRatio__(Order _makerOrder, uint256 _decimals)
1027     private
1028     constant
1029     returns (uint256 orderPriceRatio)
1030   {
1031     if (_makerOrder.offerTokenTotal_ >= _makerOrder.wantTokenTotal_) {
1032       orderPriceRatio = _makerOrder.offerTokenTotal_.mul(10**_decimals).div(_makerOrder.wantTokenTotal_);
1033     } else {
1034       orderPriceRatio = _makerOrder.wantTokenTotal_.mul(10**_decimals).div(_makerOrder.offerTokenTotal_);
1035     }
1036   }
1037 
1038   /**
1039    * @dev Compute the tradeable amounts of the two verified orders.
1040    * Token amount is the min remaining between want and offer of the two orders that isn't ether.
1041    * Ether amount is then: etherAmount = tokenAmount * priceRatio, as ratio = eth / token.
1042    * @param _makerOrder The maker order data structure.
1043    * @param _takerOrder The taker order data structure.
1044    * @return The amount moving from makerOfferRemaining to takerWantRemaining and vice versa.
1045    * TODO: consider rounding errors, etc
1046    */
1047   function __getTradeAmounts__(
1048     Order _makerOrder,
1049     Order _takerOrder
1050   ) private
1051     constant
1052     returns (uint256 toTakerAmount, uint256 toMakerAmount)
1053   {
1054     bool ratioIsWeiPerTok = __ratioIsWeiPerTok__(_makerOrder);
1055     uint256 decimals = __flooredLog10__(__max__(_makerOrder.offerTokenTotal_, _makerOrder.wantTokenTotal_)) + 1;
1056     uint256 priceRatio = __getOrderPriceRatio__(_makerOrder, decimals);
1057 
1058     // Amount left for order to receive
1059     uint256 makerAmountLeftToReceive = _makerOrder.wantTokenTotal_.sub(_makerOrder.wantTokenReceived_);
1060     uint256 takerAmountLeftToReceive = _takerOrder.wantTokenTotal_.sub(_takerOrder.wantTokenReceived_);
1061 
1062     // wei/tok and taker receiving wei or tok/wei and taker receiving tok
1063     if (
1064         ratioIsWeiPerTok && _takerOrder.wantToken_ == address(0) ||
1065         !ratioIsWeiPerTok && _takerOrder.wantToken_ != address(0)
1066     ) {
1067       // In the case that the maker is offering more than the taker wants for the same quantity being offered
1068       // For example: maker offer 20 wei for 10 tokens but taker offers 10 tokens for 10 wei
1069       // Taker receives 20 wei for the 10 tokens, both orders filled
1070       if (
1071         _makerOrder.offerTokenRemaining_ > takerAmountLeftToReceive &&
1072         makerAmountLeftToReceive <= _takerOrder.offerTokenRemaining_
1073       ) {
1074         toTakerAmount = __max__(_makerOrder.offerTokenRemaining_, takerAmountLeftToReceive);
1075       } else {
1076         toTakerAmount = __min__(_makerOrder.offerTokenRemaining_, takerAmountLeftToReceive);
1077       }
1078 
1079       toMakerAmount = toTakerAmount.mul(10**decimals).div(priceRatio);
1080 
1081     // wei/tok and maker receiving wei or tok/wei and maker receiving tok
1082     } else {
1083       toMakerAmount = __min__(_takerOrder.offerTokenRemaining_, makerAmountLeftToReceive);
1084       toTakerAmount = toMakerAmount.mul(10**decimals).div(priceRatio);
1085     }
1086   }
1087 
1088   /**
1089    * @dev Return the maximum of two uints
1090    * @param _a Uint 1
1091    * @param _b Uint 2
1092    * @return The grater value or a if equal
1093    */
1094   function __max__(uint256 _a, uint256 _b)
1095     private
1096     constant
1097     returns (uint256)
1098   {
1099     return _a < _b ? _b : _a;
1100   }
1101 
1102   /**
1103    * @dev Return the minimum of two uints
1104    * @param _a Uint 1
1105    * @param _b Uint 2
1106    * @return The smallest value or b if equal
1107    */
1108   function __min__(uint256 _a, uint256 _b)
1109     private
1110     constant
1111     returns (uint256)
1112   {
1113     return _a < _b ? _a : _b;
1114   }
1115 
1116   /**
1117    * @dev Define if the ratio to be used is wei/tok to tok/wei. Largest uint will
1118    * always act as the numerator.
1119    * @param _makerOrder The maker order object.
1120    * @return If the ratio is wei/tok or not.
1121    */
1122   function __ratioIsWeiPerTok__(Order _makerOrder)
1123     private
1124     constant
1125     returns (bool)
1126   {
1127     bool offerIsWei = _makerOrder.offerToken_ == address(0) ? true : false;
1128 
1129     // wei/tok
1130     if (offerIsWei && _makerOrder.offerTokenTotal_ >= _makerOrder.wantTokenTotal_) {
1131       return true;
1132 
1133     } else if (!offerIsWei && _makerOrder.wantTokenTotal_ >= _makerOrder.offerTokenTotal_) {
1134       return true;
1135 
1136     // tok/wei. otherwise wanting wei && offer > want, OR offer wei && want > offer
1137     } else {
1138       return false;
1139     }
1140   }
1141 
1142   /**
1143    * @dev Confirm that the orders do match and are valid.
1144    * @param _makerOrder The maker order data structure.
1145    * @param _takerOrder The taker order data structure.
1146    * @return Bool if the orders passes all checks.
1147    */
1148   function __ordersMatch_and_AreVaild__(
1149     Order _makerOrder,
1150     Order _takerOrder
1151   ) private
1152     constant
1153     returns (bool)
1154   {
1155     // Orders still active
1156     if (!_makerOrder.active_)
1157       return error('Maker order is inactive, Exchange.__ordersMatch_and_AreVaild__()');
1158 
1159     if (!_takerOrder.active_)
1160       return error('Taker order is inactive, Exchange.__ordersMatch_and_AreVaild__()');
1161 
1162     // Confirm tokens match
1163     // NOTE potentially omit as matching handled upstream?
1164     if (_makerOrder.wantToken_ != _takerOrder.offerToken_)
1165       return error('Maker wanted token does not match taker offer token, Exchange.__ordersMatch_and_AreVaild__()');
1166 
1167     if (_makerOrder.offerToken_ != _takerOrder.wantToken_)
1168       return error('Maker offer token does not match taker wanted token, Exchange.__ordersMatch_and_AreVaild__()');
1169 
1170     // Price Ratios, to x decimal places hence * decimals, dependent on the size of the denominator.
1171     // Ratios are relative to eth, amount of ether for a single token, ie. ETH / GNO == 0.2 Ether per 1 Gnosis
1172     uint256 orderPrice;  // The price the maker is willing to accept
1173     uint256 offeredPrice; // The offer the taker has given
1174     uint256 decimals = _makerOrder.offerToken_ == address(0) ? __flooredLog10__(_makerOrder.wantTokenTotal_) : __flooredLog10__(_makerOrder.offerTokenTotal_);
1175 
1176     // Ratio = larger amount / smaller amount
1177     if (_makerOrder.offerTokenTotal_ >= _makerOrder.wantTokenTotal_) {
1178       orderPrice = _makerOrder.offerTokenTotal_.mul(10**decimals).div(_makerOrder.wantTokenTotal_);
1179       offeredPrice = _takerOrder.wantTokenTotal_.mul(10**decimals).div(_takerOrder.offerTokenTotal_);
1180 
1181       // ie. Maker is offering 10 ETH for 100 GNO but taker is offering 100 GNO for 20 ETH, no match!
1182       // The taker wants more ether than the maker is offering.
1183       if (orderPrice < offeredPrice)
1184         return error('Taker price is greater than maker price, Exchange.__ordersMatch_and_AreVaild__()');
1185 
1186     } else {
1187       orderPrice = _makerOrder.wantTokenTotal_.mul(10**decimals).div(_makerOrder.offerTokenTotal_);
1188       offeredPrice = _takerOrder.offerTokenTotal_.mul(10**decimals).div(_takerOrder.wantTokenTotal_);
1189 
1190       // ie. Maker is offering 100 GNO for 10 ETH but taker is offering 5 ETH for 100 GNO, no match!
1191       // The taker is not offering enough ether for the maker
1192       if (orderPrice > offeredPrice)
1193         return error('Taker price is less than maker price, Exchange.__ordersMatch_and_AreVaild__()');
1194 
1195     }
1196 
1197     return true;
1198   }
1199 
1200   /**
1201    * @dev Ask each wallet to verify this order.
1202    * @param _token_and_EOA_Addresses The addresses of the maker and taker EOAs and offered token contracts.
1203    * [makerEOA, makerOfferToken, takerEOA, takerOfferToken]
1204    * @param _toMakerAmount The amount of tokens to be sent to the maker.
1205    * @param _toTakerAmount The amount of tokens to be sent to the taker.
1206    * @param _makerWallet The maker's wallet contract.
1207    * @param _takerWallet The taker's wallet contract.
1208    * @param _fee The fee to be paid for this trade, paid in full by taker.
1209    * @return Success if both wallets verify the order.
1210    */
1211   function __ordersVerifiedByWallets__(
1212     address[4] _token_and_EOA_Addresses,
1213     uint256 _toMakerAmount,
1214     uint256 _toTakerAmount,
1215     Wallet _makerWallet,
1216     Wallet _takerWallet,
1217     uint256 _fee
1218   ) private
1219     constant
1220     returns (bool)
1221   {
1222     // Have the transaction verified by both maker and taker wallets
1223     // confirm sufficient balance to transfer, offerToken and offerTokenAmount
1224     if(!_makerWallet.verifyOrder(_token_and_EOA_Addresses[1], _toTakerAmount, 0, 0))
1225       return error('Maker wallet could not verify the order, Exchange.__ordersVerifiedByWallets__()');
1226 
1227     if(!_takerWallet.verifyOrder(_token_and_EOA_Addresses[3], _toMakerAmount, _fee, edoToken_))
1228       return error('Taker wallet could not verify the order, Exchange.__ordersVerifiedByWallets__()');
1229 
1230     return true;
1231   }
1232 
1233   /**
1234    * @dev On chain verification of an ECDSA ethereum signature.
1235    * @param _signer The EOA address of the account that supposedly signed the message.
1236    * @param _orderHash The on-chain generated hash for the order.
1237    * @param _v ECDSA signature parameter v.
1238    * @param _r ECDSA signature parameter r.
1239    * @param _s ECDSA signature parameter s.
1240    * @return Bool if the signature is valid or not.
1241    */
1242   function __signatureIsValid__(
1243     address _signer,
1244     bytes32 _orderHash,
1245     uint8 _v,
1246     bytes32 _r,
1247     bytes32 _s
1248   ) private
1249     constant
1250     returns (bool)
1251   {
1252     address recoveredAddr = ecrecover(
1253       keccak256('\x19Ethereum Signed Message:\n32', _orderHash),
1254       _v, _r, _s
1255     );
1256 
1257     return recoveredAddr == _signer;
1258   }
1259 
1260   /**
1261    * @dev Confirm wallet local balances and token balances match.
1262    * @param _makerWallet  Maker wallet address.
1263    * @param _takerWallet  Taker wallet address.
1264    * @param _token  Token address to confirm balances match.
1265    * @return If the balances do match.
1266    */
1267   function __tokenAndWalletBalancesMatch__(
1268     address _makerWallet,
1269     address _takerWallet,
1270     address _token
1271   ) private
1272     constant
1273     returns(bool)
1274   {
1275     if (Token(_token).balanceOf(_makerWallet) != Wallet(_makerWallet).balanceOf(_token))
1276       return false;
1277 
1278     if (Token(_token).balanceOf(_takerWallet) != Wallet(_takerWallet).balanceOf(_token))
1279       return false;
1280 
1281     return true;
1282   }
1283 
1284   /**
1285    * @dev Update the order structs.
1286    * @param _makerOrder The maker order data structure.
1287    * @param _takerOrder The taker order data structure.
1288    * @param _toTakerAmount The amount of tokens to be moved to the taker.
1289    * @param _toTakerAmount The amount of tokens to be moved to the maker.
1290    * @return Success if the update succeeds.
1291    */
1292   function __updateOrders__(
1293     Order _makerOrder,
1294     Order _takerOrder,
1295     uint256 _toTakerAmount,
1296     uint256 _toMakerAmount
1297   ) private
1298   {
1299     // taker => maker
1300     _makerOrder.wantTokenReceived_ = _makerOrder.wantTokenReceived_.add(_toMakerAmount);
1301     _takerOrder.offerTokenRemaining_ = _takerOrder.offerTokenRemaining_.sub(_toMakerAmount);
1302 
1303     // maker => taker
1304     _takerOrder.wantTokenReceived_ = _takerOrder.wantTokenReceived_.add(_toTakerAmount);
1305     _makerOrder.offerTokenRemaining_ = _makerOrder.offerTokenRemaining_.sub(_toTakerAmount);
1306   }
1307 }