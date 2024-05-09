1 pragma solidity ^0.4.24;
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
134 contract WalletV2 is LoggingErrors {
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
146   WalletConnector private connector_;
147 
148   /**
149    * Events
150    */
151   event LogDeposit(address token, uint256 amount, uint256 balance);
152   event LogWithdrawal(address token, uint256 amount, uint256 balance);
153 
154   /**
155    * @dev Contract constructor. Set user as owner and connector address.
156    * @param _owner The address of the user's EOA, wallets created from the exchange
157    * so must past in the owner address, msg.sender == exchange.
158    * @param _connector The wallet connector to be used to retrieve the wallet logic
159    */
160   function WalletV2(address _owner, address _connector) public {
161     owner_ = _owner;
162     connector_ = WalletConnector(_connector);
163     exchange_ = msg.sender;
164     logic_ = connector_.latestLogic_();
165     birthBlock_ = block.number;
166   }
167 
168   /**
169    * @dev Fallback - Only enable funds to be sent from the exchange.
170    * Ensures balances will be consistent.
171    */
172   function () external payable {
173     require(msg.sender == exchange_);
174   }
175 
176   /**
177   * External
178   */
179 
180   /**
181    * @dev Deposit ether into this wallet, default to address 0 for consistent token lookup.
182    */
183   function depositEther()
184     external
185     payable
186   {
187     require(logic_.delegatecall(bytes4(sha3('deposit(address,uint256)')), 0, msg.value));
188   }
189 
190   /**
191    * @dev Deposit any ERC20 token into this wallet.
192    * @param _token The address of the existing token contract.
193    * @param _amount The amount of tokens to deposit.
194    * @return Bool if the deposit was successful.
195    */
196   function depositERC20Token (
197     address _token,
198     uint256 _amount
199   ) external
200     returns(bool)
201   {
202     // ether
203     if (_token == 0)
204       return error('Cannot deposit ether via depositERC20, Wallet.depositERC20Token()');
205 
206     require(logic_.delegatecall(bytes4(sha3('deposit(address,uint256)')), _token, _amount));
207     return true;
208   }
209 
210   /**
211    * @dev The result of an order, update the balance of this wallet.
212    * @param _token The address of the token balance to update.
213    * @param _amount The amount to update the balance by.
214    * @param _subtractionFlag If true then subtract the token amount else add.
215    * @return Bool if the update was successful.
216    */
217   function updateBalance (
218     address _token,
219     uint256 _amount,
220     bool _subtractionFlag
221   ) external
222     returns(bool)
223   {
224     assembly {
225       calldatacopy(0x40, 0, calldatasize)
226       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
227       return(0, 32)
228       pop
229     }
230   }
231 
232   /**
233    * User may update to the latest version of the exchange contract.
234    * Note that multiple versions are NOT supported at this time and therefore if a
235    * user does not wish to update they will no longer be able to use the exchange.
236    * @param _exchange The new exchange.
237    * @return Success of this transaction.
238    */
239   function updateExchange(address _exchange)
240     external
241     returns(bool)
242   {
243     if (msg.sender != owner_)
244       return error('msg.sender != owner_, Wallet.updateExchange()');
245 
246     // If subsequent messages are not sent from this address all orders will fail
247     exchange_ = _exchange;
248 
249     return true;
250   }
251 
252   /**
253    * User may update to a new or older version of the logic contract.
254    * @param _version The versin to update to.
255    * @return Success of this transaction.
256    */
257   function updateLogic(uint256 _version)
258     external
259     returns(bool)
260   {
261     if (msg.sender != owner_)
262       return error('msg.sender != owner_, Wallet.updateLogic()');
263 
264     address newVersion = connector_.getLogic(_version);
265 
266     // Invalid version as defined by connector
267     if (newVersion == 0)
268       return error('Invalid version, Wallet.updateLogic()');
269 
270     logic_ = newVersion;
271     return true;
272   }
273 
274   /**
275    * @dev Verify an order that the Exchange has received involving this wallet.
276    * Internal checks and then authorize the exchange to move the tokens.
277    * If sending ether will transfer to the exchange to broker the trade.
278    * @param _token The address of the token contract being sold.
279    * @param _amount The amount of tokens the order is for.
280    * @param _fee The fee for the current trade.
281    * @param _feeToken The token of which the fee is to be paid in.
282    * @return If the order was verified or not.
283    */
284   function verifyOrder (
285     address _token,
286     uint256 _amount,
287     uint256 _fee,
288     address _feeToken
289   ) external
290     returns(bool)
291   {
292     assembly {
293       calldatacopy(0x40, 0, calldatasize)
294       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
295       return(0, 32)
296       pop
297     }
298   }
299 
300   /**
301    * @dev Withdraw any token, including ether from this wallet to an EOA.
302    * @param _token The address of the token to withdraw.
303    * @param _amount The amount to withdraw.
304    * @return Success of the withdrawal.
305    */
306   function withdraw(address _token, uint256 _amount)
307     external
308     returns(bool)
309   {
310     if(msg.sender != owner_)
311       return error('msg.sender != owner, Wallet.withdraw()');
312 
313     assembly {
314       calldatacopy(0x40, 0, calldatasize)
315       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
316       return(0, 32)
317       pop
318     }
319   }
320 
321   /**
322    * Constants
323    */
324 
325   /**
326    * @dev Get the balance for a specific token.
327    * @param _token The address of the token contract to retrieve the balance of.
328    * @return The current balance within this contract.
329    */
330   function balanceOf(address _token)
331     public
332     view
333     returns(uint)
334   {
335     return tokenBalances_[_token];
336   }
337 }
338 
339 /**
340  * @title SafeMath
341  * @dev Math operations with safety checks that throw on error
342  */
343 library SafeMath {
344   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
345     uint256 c = a * b;
346     assert(a == 0 || c / a == b);
347     return c;
348   }
349 
350   function div(uint256 a, uint256 b) internal constant returns (uint256) {
351     // assert(b > 0); // Solidity automatically throws when dividing by 0
352     uint256 c = a / b;
353     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
354     return c;
355   }
356 
357   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
358     assert(b <= a);
359     return a - b;
360   }
361 
362   function add(uint256 a, uint256 b) internal constant returns (uint256) {
363     uint256 c = a + b;
364     assert(c >= a);
365     return c;
366   }
367 }
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
408 interface ExchangeV1 {
409   function userAccountToWallet_(address) external returns(address);
410 }
411 
412 interface BadERC20 {
413   function transfer(address to, uint value) external;
414   function transferFrom(address from, address to, uint256 value) external;
415 }
416 
417 /**
418  * @title Decentralized exchange for ether and ERC20 tokens.
419  * @author Eidoo SAGL.
420  * @dev All trades brokered by this contract.
421  * Orders submitted by off chain order book and this contract handles
422  * verification and execution of orders.
423  * All value between parties is transferred via this exchange.
424  * Methods arranged by visibility; external, public, internal, private and alphabatized within.
425  *
426  * New Exchange SC with eventually no fee and ERC20 tokens as quote
427  */
428 contract ExchangeV2 is LoggingErrors {
429 
430   using SafeMath for uint256;
431 
432   /**
433    * Data Structures
434    */
435   struct Order {
436     address offerToken_;
437     uint256 offerTokenTotal_;
438     uint256 offerTokenRemaining_;  // Amount left to give
439     address wantToken_;
440     uint256 wantTokenTotal_;
441     uint256 wantTokenReceived_;  // Amount received, note this may exceed want total
442   }
443 
444   struct OrderStatus {
445     uint256 expirationBlock_;
446     uint256 wantTokenReceived_;    // Amount received, note this may exceed want total
447     uint256 offerTokenRemaining_;  // Amount left to give
448   }
449 
450   /**
451    * Storage
452    */
453   address public previousExchangeAddress_;
454   address private orderBookAccount_;
455   address public owner_;
456   uint256 public birthBlock_;
457   address public edoToken_;
458   address public walletConnector;
459 
460   mapping (address => uint256) public feeEdoPerQuote;
461   mapping (address => uint256) public feeEdoPerQuoteDecimals;
462 
463   address public eidooWallet_;
464 
465   // Define if fee calculation must be skipped for a given trade. By default (false) fee must not be skipped.
466   mapping(address => mapping(address => bool)) public mustSkipFee;
467 
468   /**
469    * @dev Define in a trade who is the quote using a priority system:
470    * values example
471    *   0: not used as quote
472    *  >0: used as quote
473    *  if wanted and offered tokens have value > 0 the quote is the token with the bigger value
474    */
475   mapping(address => uint256) public quotePriority;
476 
477   mapping(bytes32 => OrderStatus) public orders_; // Map order hashes to order data struct
478   mapping(address => address) public userAccountToWallet_; // User EOA to wallet addresses
479 
480   /**
481    * Events
482    */
483   event LogFeeRateSet(address indexed token, uint256 rate, uint256 decimals);
484   event LogQuotePrioritySet(address indexed quoteToken, uint256 priority);
485   event LogMustSkipFeeSet(address indexed base, address indexed quote, bool mustSkipFee);
486   event LogUserAdded(address indexed user, address walletAddress);
487   event LogWalletDeposit(address indexed walletAddress, address token, uint256 amount, uint256 balance);
488   event LogWalletWithdrawal(address indexed walletAddress, address token, uint256 amount, uint256 balance);
489 
490   event LogOrderExecutionSuccess(
491     bytes32 indexed makerOrderId,
492     bytes32 indexed takerOrderId,
493     uint256 toMaker,
494     uint256 toTaker
495   );
496   event LogOrderFilled(bytes32 indexed orderId, uint256 totalOfferRemaining, uint256 totalWantReceived);
497 
498   /**
499    * @dev Contract constructor - CONFIRM matches contract name.  Set owner and addr of order book.
500    * @param _bookAccount The EOA address for the order book, will submit ALL orders.
501    * @param _edoToken Deployed edo token.
502    * @param _edoPerWei Rate of edo tokens per wei.
503    * @param _edoPerWeiDecimals Decimlas carried in edo rate.
504    * @param _eidooWallet Wallet to pay fees to.
505    * @param _previousExchangeAddress Previous exchange smart contract address.
506    */
507   constructor (
508     address _bookAccount,
509     address _edoToken,
510     uint256 _edoPerWei,
511     uint256 _edoPerWeiDecimals,
512     address _eidooWallet,
513     address _previousExchangeAddress,
514     address _walletConnector
515   ) public {
516     orderBookAccount_ = _bookAccount;
517     owner_ = msg.sender;
518     birthBlock_ = block.number;
519     edoToken_ = _edoToken;
520     feeEdoPerQuote[address(0)] = _edoPerWei;
521     feeEdoPerQuoteDecimals[address(0)] = _edoPerWeiDecimals;
522     eidooWallet_ = _eidooWallet;
523     quotePriority[address(0)] = 10;
524     previousExchangeAddress_ = _previousExchangeAddress;
525     require(_walletConnector != address (0), "WalletConnector address == 0");
526     walletConnector = _walletConnector;
527   }
528 
529   /**
530    * @dev Fallback. wallets utilize to send ether in order to broker trade.
531    */
532   function () external payable { }
533 
534   /**
535    * External
536    */
537 
538   /**
539    * @dev Returns the Wallet contract address associated to a user account. If the user account is not known, try to
540    * migrate the wallet address from the old exchange instance. This function is equivalent to getWallet(), in addition
541    * it stores the wallet address fetched from old the exchange instance.
542    * @param userAccount The user account address
543    * @return The address of the Wallet instance associated to the user account
544    */
545   function retrieveWallet(address userAccount)
546     public
547     returns(address walletAddress)
548   {
549     walletAddress = userAccountToWallet_[userAccount];
550     if (walletAddress == address(0) && previousExchangeAddress_ != 0) {
551       // Retrieve the wallet address from the old exchange.
552       walletAddress = ExchangeV1(previousExchangeAddress_).userAccountToWallet_(userAccount);
553       // TODO: in the future versions of the exchange the above line must be replaced with the following one
554       //walletAddress = ExchangeV2(previousExchangeAddress_).retrieveWallet(userAccount);
555 
556       if (walletAddress != address(0)) {
557         userAccountToWallet_[userAccount] = walletAddress;
558       }
559     }
560   }
561 
562   /**
563    * @dev Add a new user to the exchange, create a wallet for them.
564    * Map their account address to the wallet contract for lookup.
565    * @param userExternalOwnedAccount The address of the user"s EOA.
566    * @return Success of the transaction, false if error condition met.
567    */
568   function addNewUser(address userExternalOwnedAccount)
569     public
570     returns (bool)
571   {
572     if (retrieveWallet(userExternalOwnedAccount) != address(0)) {
573       return error("User already exists, Exchange.addNewUser()");
574     }
575 
576     // Pass the userAccount address to wallet constructor so owner is not the exchange contract
577     address userTradingWallet = new WalletV2(userExternalOwnedAccount, walletConnector);
578     userAccountToWallet_[userExternalOwnedAccount] = userTradingWallet;
579     emit LogUserAdded(userExternalOwnedAccount, userTradingWallet);
580     return true;
581   }
582 
583   /**
584    * Execute orders in batches.
585    * @param ownedExternalAddressesAndTokenAddresses Tokan and user addresses.
586    * @param amountsExpirationsAndSalts Offer and want token amount and expiration and salt values.
587    * @param vSignatures All order signature v values.
588    * @param rAndSsignatures All order signature r and r values.
589    * @return The success of this transaction.
590    */
591   function batchExecuteOrder(
592     address[4][] ownedExternalAddressesAndTokenAddresses,
593     uint256[8][] amountsExpirationsAndSalts, // Packing to save stack size
594     uint8[2][] vSignatures,
595     bytes32[4][] rAndSsignatures
596   ) external
597     returns(bool)
598   {
599     for (uint256 i = 0; i < amountsExpirationsAndSalts.length; i++) {
600       require(
601         executeOrder(
602           ownedExternalAddressesAndTokenAddresses[i],
603           amountsExpirationsAndSalts[i],
604           vSignatures[i],
605           rAndSsignatures[i]
606         ),
607         "Cannot execute order, Exchange.batchExecuteOrder()"
608       );
609     }
610 
611     return true;
612   }
613 
614   /**
615    * @dev Execute an order that was submitted by the external order book server.
616    * The order book server believes it to be a match.
617    * There are components for both orders, maker and taker, 2 signatures as well.
618    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
619    * [
620    *   makerEOA
621    *   makerOfferToken
622    *   takerEOA
623    *   takerOfferToken
624    * ]
625    * @param amountsExpirationsAndSalts The amount of tokens and the block number at which this order expires and a random number to mitigate replay.
626    * [
627    *   makerOffer
628    *   makerWant
629    *   takerOffer
630    *   takerWant
631    *   makerExpiry
632    *   makerSalt
633    *   takerExpiry
634    *   takerSalt
635    * ]
636    * @param vSignatures ECDSA signature parameter.
637    * [
638    *   maker V
639    *   taker V
640    * ]
641    * @param rAndSsignatures ECDSA signature parameters r ans s, maker 0, 1 and taker 2, 3.
642    * [
643    *   maker R
644    *   maker S
645    *   taker R
646    *   taker S
647    * ]
648    * @return Success of the transaction, false if error condition met.
649    * Like types grouped to eliminate stack depth error.
650    */
651   function executeOrder (
652     address[4] ownedExternalAddressesAndTokenAddresses,
653     uint256[8] amountsExpirationsAndSalts, // Packing to save stack size
654     uint8[2] vSignatures,
655     bytes32[4] rAndSsignatures
656   ) public
657     returns(bool)
658   {
659     // Only read wallet addresses from storage once
660     // Need one more stack slot so squashing into array
661     WalletV2[2] memory makerAndTakerTradingWallets = [
662       WalletV2(retrieveWallet(ownedExternalAddressesAndTokenAddresses[0])), // maker
663       WalletV2(retrieveWallet(ownedExternalAddressesAndTokenAddresses[2])) // taker
664     ];
665 
666     // Basic pre-conditions, return if any input data is invalid
667     if(!__executeOrderInputIsValid__(
668       ownedExternalAddressesAndTokenAddresses,
669       amountsExpirationsAndSalts,
670       makerAndTakerTradingWallets[0], // maker
671       makerAndTakerTradingWallets[1] // taker
672     )) {
673       return error("Input is invalid, Exchange.executeOrder()");
674     }
675 
676     // Verify Maker and Taker signatures
677     bytes32[2] memory makerAndTakerOrderHash = generateOrderHashes(
678       ownedExternalAddressesAndTokenAddresses,
679       amountsExpirationsAndSalts
680     );
681 
682     // Check maker order signature
683     if (!__signatureIsValid__(
684       ownedExternalAddressesAndTokenAddresses[0],
685       makerAndTakerOrderHash[0],
686       vSignatures[0],
687       rAndSsignatures[0],
688       rAndSsignatures[1]
689     )) {
690       return error("Maker signature is invalid, Exchange.executeOrder()");
691     }
692 
693     // Check taker order signature
694     if (!__signatureIsValid__(
695       ownedExternalAddressesAndTokenAddresses[2],
696       makerAndTakerOrderHash[1],
697       vSignatures[1],
698       rAndSsignatures[2],
699       rAndSsignatures[3]
700     )) {
701       return error("Taker signature is invalid, Exchange.executeOrder()");
702     }
703 
704     // Exchange Order Verification and matching
705     OrderStatus memory makerOrderStatus = orders_[makerAndTakerOrderHash[0]];
706     OrderStatus memory takerOrderStatus = orders_[makerAndTakerOrderHash[1]];
707     Order memory makerOrder;
708     Order memory takerOrder;
709 
710     makerOrder.offerToken_ = ownedExternalAddressesAndTokenAddresses[1];
711     makerOrder.offerTokenTotal_ = amountsExpirationsAndSalts[0];
712     makerOrder.wantToken_ = ownedExternalAddressesAndTokenAddresses[3];
713     makerOrder.wantTokenTotal_ = amountsExpirationsAndSalts[1];
714 
715     if (makerOrderStatus.expirationBlock_ > 0) {  // Check for existence
716       // Orders still active
717       if (makerOrderStatus.offerTokenRemaining_ == 0) {
718         return error("Maker order is inactive, Exchange.executeOrder()");
719       }
720       makerOrder.offerTokenRemaining_ = makerOrderStatus.offerTokenRemaining_; // Amount to give
721       makerOrder.wantTokenReceived_ = makerOrderStatus.wantTokenReceived_; // Amount received
722     } else {
723       makerOrder.offerTokenRemaining_ = amountsExpirationsAndSalts[0]; // Amount to give
724       makerOrder.wantTokenReceived_ = 0; // Amount received
725       makerOrderStatus.expirationBlock_ = amountsExpirationsAndSalts[4]; // maker order expiration block
726     }
727 
728     takerOrder.offerToken_ = ownedExternalAddressesAndTokenAddresses[3];
729     takerOrder.offerTokenTotal_ = amountsExpirationsAndSalts[2];
730     takerOrder.wantToken_ = ownedExternalAddressesAndTokenAddresses[1];
731     takerOrder.wantTokenTotal_ = amountsExpirationsAndSalts[3];
732 
733     if (takerOrderStatus.expirationBlock_ > 0) {  // Check for existence
734       if (takerOrderStatus.offerTokenRemaining_ == 0) {
735         return error("Taker order is inactive, Exchange.executeOrder()");
736       }
737       takerOrder.offerTokenRemaining_ = takerOrderStatus.offerTokenRemaining_;  // Amount to give
738       takerOrder.wantTokenReceived_ = takerOrderStatus.wantTokenReceived_; // Amount received
739 
740     } else {
741       takerOrder.offerTokenRemaining_ = amountsExpirationsAndSalts[2];  // Amount to give
742       takerOrder.wantTokenReceived_ = 0; // Amount received
743       takerOrderStatus.expirationBlock_ = amountsExpirationsAndSalts[6]; // taker order expiration block
744     }
745 
746     // Check if orders are matching and are valid
747     if (!__ordersMatch_and_AreVaild__(makerOrder, takerOrder)) {
748       return error("Orders do not match, Exchange.executeOrder()");
749     }
750 
751     // Trade amounts
752     // [0] => toTakerAmount
753     // [1] => toMakerAmount
754     uint[2] memory toTakerAndToMakerAmount;
755     toTakerAndToMakerAmount = __getTradeAmounts__(makerOrder, takerOrder);
756 
757     // TODO consider removing. Can this condition be met?
758     if (toTakerAndToMakerAmount[0] < 1 || toTakerAndToMakerAmount[1] < 1) {
759       return error("Token amount < 1, price ratio is invalid! Token value < 1, Exchange.executeOrder()");
760     }
761 
762     uint calculatedFee = __calculateFee__(makerOrder, toTakerAndToMakerAmount[0], toTakerAndToMakerAmount[1]);
763 
764     // Check taker has sufficent EDO token balance to pay the fee
765     if (
766       takerOrder.offerToken_ == edoToken_ &&
767       Token(edoToken_).balanceOf(makerAndTakerTradingWallets[1]) < calculatedFee.add(toTakerAndToMakerAmount[1])
768     ) {
769       return error("Taker has an insufficient EDO token balance to cover the fee AND the offer, Exchange.executeOrder()");
770     } else if (Token(edoToken_).balanceOf(makerAndTakerTradingWallets[1]) < calculatedFee) {
771       return error("Taker has an insufficient EDO token balance to cover the fee, Exchange.executeOrder()");
772     }
773 
774     // Wallet Order Verification, reach out to the maker and taker wallets.
775     if (
776       !__ordersVerifiedByWallets__(
777         ownedExternalAddressesAndTokenAddresses,
778         toTakerAndToMakerAmount[1],
779         toTakerAndToMakerAmount[0],
780         makerAndTakerTradingWallets[0],
781         makerAndTakerTradingWallets[1],
782         calculatedFee
783     )) {
784       return error("Order could not be verified by wallets, Exchange.executeOrder()");
785     }
786 
787     // Write to storage then external calls
788     makerOrderStatus.offerTokenRemaining_ = makerOrder.offerTokenRemaining_.sub(toTakerAndToMakerAmount[0]);
789     makerOrderStatus.wantTokenReceived_ = makerOrder.wantTokenReceived_.add(toTakerAndToMakerAmount[1]);
790 
791     takerOrderStatus.offerTokenRemaining_ = takerOrder.offerTokenRemaining_.sub(toTakerAndToMakerAmount[1]);
792     takerOrderStatus.wantTokenReceived_ = takerOrder.wantTokenReceived_.add(toTakerAndToMakerAmount[0]);
793 
794     // Finally write orders to storage
795     orders_[makerAndTakerOrderHash[0]] = makerOrderStatus;
796     orders_[makerAndTakerOrderHash[1]] = takerOrderStatus;
797 
798     // Transfer the external value, ether <> tokens
799     require(
800       __executeTokenTransfer__(
801         ownedExternalAddressesAndTokenAddresses,
802         toTakerAndToMakerAmount[0],
803         toTakerAndToMakerAmount[1],
804         calculatedFee,
805         makerAndTakerTradingWallets[0],
806         makerAndTakerTradingWallets[1]
807       ),
808       "Cannot execute token transfer, Exchange.__executeTokenTransfer__()"
809     );
810 
811     // Log the order id(hash), amount of offer given, amount of offer remaining
812     emit LogOrderFilled(makerAndTakerOrderHash[0], makerOrderStatus.offerTokenRemaining_, makerOrderStatus.wantTokenReceived_);
813     emit LogOrderFilled(makerAndTakerOrderHash[1], takerOrderStatus.offerTokenRemaining_, takerOrderStatus.wantTokenReceived_);
814     emit LogOrderExecutionSuccess(makerAndTakerOrderHash[0], makerAndTakerOrderHash[1], toTakerAndToMakerAmount[1], toTakerAndToMakerAmount[0]);
815 
816     return true;
817   }
818 
819   /**
820    * @dev Set the fee rate for a specific quote
821    * @param _quoteToken Quote token.
822    * @param _edoPerQuote EdoPerQuote.
823    * @param _edoPerQuoteDecimals EdoPerQuoteDecimals.
824    * @return Success of the transaction.
825    */
826   function setFeeRate(
827     address _quoteToken,
828     uint256 _edoPerQuote,
829     uint256 _edoPerQuoteDecimals
830   ) external
831     returns(bool)
832   {
833     if (msg.sender != owner_) {
834       return error("msg.sender != owner, Exchange.setFeeRate()");
835     }
836 
837     if (quotePriority[_quoteToken] == 0) {
838       return error("quotePriority[_quoteToken] == 0, Exchange.setFeeRate()");
839     }
840 
841     feeEdoPerQuote[_quoteToken] = _edoPerQuote;
842     feeEdoPerQuoteDecimals[_quoteToken] = _edoPerQuoteDecimals;
843 
844     emit LogFeeRateSet(_quoteToken, _edoPerQuote, _edoPerQuoteDecimals);
845 
846     return true;
847   }
848 
849   /**
850    * @dev Set the wallet for fees to be paid to.
851    * @param eidooWallet Wallet to pay fees to.
852    * @return Success of the transaction.
853    */
854   function setEidooWallet(
855     address eidooWallet
856   ) external
857     returns(bool)
858   {
859     if (msg.sender != owner_) {
860       return error("msg.sender != owner, Exchange.setEidooWallet()");
861     }
862     eidooWallet_ = eidooWallet;
863     return true;
864   }
865 
866   /**
867    * @dev Set a new order book account.
868    * @param account The new order book account.
869    */
870   function setOrderBookAcount (
871     address account
872   ) external
873     returns(bool)
874   {
875     if (msg.sender != owner_) {
876       return error("msg.sender != owner, Exchange.setOrderBookAcount()");
877     }
878     orderBookAccount_ = account;
879     return true;
880   }
881 
882   /**
883    * @dev Set if a base must skip fee calculation.
884    * @param _baseTokenAddress The trade base token address that must skip fee calculation.
885    * @param _quoteTokenAddress The trade quote token address that must skip fee calculation.
886    * @param _mustSkipFee The trade base token address that must skip fee calculation.
887    */
888   function setMustSkipFee (
889     address _baseTokenAddress,
890     address _quoteTokenAddress,
891     bool _mustSkipFee
892   ) external
893     returns(bool)
894   {
895     // Preserving same owner check style
896     if (msg.sender != owner_) {
897       return error("msg.sender != owner, Exchange.setMustSkipFee()");
898     }
899     mustSkipFee[_baseTokenAddress][_quoteTokenAddress] = _mustSkipFee;
900     emit LogMustSkipFeeSet(_baseTokenAddress, _quoteTokenAddress, _mustSkipFee);
901     return true;
902   }
903 
904   /**
905    * @dev Set quote priority token.
906    * Set the sorting of token quote based on a priority.
907    * @param _token The address of the token that was deposited.
908    * @param _priority The amount of the token that was deposited.
909    * @return Operation success.
910    */
911 
912   function setQuotePriority(address _token, uint256 _priority)
913     external
914     returns(bool)
915   {
916     if (msg.sender != owner_) {
917       return error("msg.sender != owner, Exchange.setQuotePriority()");
918     }
919     quotePriority[_token] = _priority;
920     emit LogQuotePrioritySet(_token, _priority);
921     return true;
922   }
923 
924   /*
925    Methods to catch events from external contracts, user wallets primarily
926    */
927 
928   /**
929    * @dev Simply log the event to track wallet interaction off-chain.
930    * @param tokenAddress The address of the token that was deposited.
931    * @param amount The amount of the token that was deposited.
932    * @param tradingWalletBalance The updated balance of the wallet after deposit.
933    */
934   function walletDeposit(
935     address tokenAddress,
936     uint256 amount,
937     uint256 tradingWalletBalance
938   ) external
939   {
940     emit LogWalletDeposit(msg.sender, tokenAddress, amount, tradingWalletBalance);
941   }
942 
943   /**
944    * @dev Simply log the event to track wallet interaction off-chain.
945    * @param tokenAddress The address of the token that was deposited.
946    * @param amount The amount of the token that was deposited.
947    * @param tradingWalletBalance The updated balance of the wallet after deposit.
948    */
949   function walletWithdrawal(
950     address tokenAddress,
951     uint256 amount,
952     uint256 tradingWalletBalance
953   ) external
954   {
955     emit LogWalletWithdrawal(msg.sender, tokenAddress, amount, tradingWalletBalance);
956   }
957 
958   /**
959    * Private
960    */
961 
962   /**
963    * Calculate the fee for the given trade. Calculated as the set % of the wei amount
964    * converted into EDO tokens using the manually set conversion ratio.
965    * @param makerOrder The maker order object.
966    * @param toTakerAmount The amount of tokens going to the taker.
967    * @param toMakerAmount The amount of tokens going to the maker.
968    * @return The total fee to be paid in EDO tokens.
969    */
970   function __calculateFee__(
971     Order makerOrder,
972     uint256 toTakerAmount,
973     uint256 toMakerAmount
974   ) private
975     view
976     returns(uint256)
977   {
978     // weiAmount * (fee %) * (EDO/Wei) / (decimals in edo/wei) / (decimals in percentage)
979     if (!__isSell__(makerOrder)) {
980       // buy -> the quote is the offered token by the maker
981       return mustSkipFee[makerOrder.wantToken_][makerOrder.offerToken_]
982         ? 0
983         : toTakerAmount.mul(feeEdoPerQuote[makerOrder.offerToken_]).div(10**feeEdoPerQuoteDecimals[makerOrder.offerToken_]);
984     } else {
985       // sell -> the quote is the wanted token by the maker
986       return mustSkipFee[makerOrder.offerToken_][makerOrder.wantToken_]
987         ? 0
988         : toMakerAmount.mul(feeEdoPerQuote[makerOrder.wantToken_]).div(10**feeEdoPerQuoteDecimals[makerOrder.wantToken_]);
989     }
990   }
991 
992   /**
993    * @dev Verify the input to order execution is valid.
994    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
995    * [
996    *   makerEOA
997    *   makerOfferToken
998    *   takerEOA
999    *   takerOfferToken
1000    * ]
1001    * @param amountsExpirationsAndSalts The amount of tokens and the block number at which this order expires and a random number to mitigate replay.
1002    * [
1003    *   makerOffer
1004    *   makerWant
1005    *   takerOffer
1006    *   takerWant
1007    *   makerExpiry
1008    *   makerSalt
1009    *   takerExpiry
1010    *   takerSalt
1011    * ]
1012    * @return Success if all checks pass.
1013    */
1014   function __executeOrderInputIsValid__(
1015     address[4] ownedExternalAddressesAndTokenAddresses,
1016     uint256[8] amountsExpirationsAndSalts,
1017     address makerTradingWallet,
1018     address takerTradingWallet
1019   ) private
1020     returns(bool)
1021   {
1022     // msg.send needs to be the orderBookAccount
1023     if (msg.sender != orderBookAccount_) {
1024       return error("msg.sender != orderBookAccount, Exchange.__executeOrderInputIsValid__()");
1025     }
1026 
1027     // Check expirations base on the block number
1028     if (block.number > amountsExpirationsAndSalts[4]) {
1029       return error("Maker order has expired, Exchange.__executeOrderInputIsValid__()");
1030     }
1031 
1032     if (block.number > amountsExpirationsAndSalts[6]) {
1033       return error("Taker order has expired, Exchange.__executeOrderInputIsValid__()");
1034     }
1035 
1036     // Operating on existing tradingWallets
1037     if (makerTradingWallet == address(0)) {
1038       return error("Maker wallet does not exist, Exchange.__executeOrderInputIsValid__()");
1039     }
1040 
1041     if (takerTradingWallet == address(0)) {
1042       return error("Taker wallet does not exist, Exchange.__executeOrderInputIsValid__()");
1043     }
1044 
1045     if (quotePriority[ownedExternalAddressesAndTokenAddresses[1]] == quotePriority[ownedExternalAddressesAndTokenAddresses[3]]) {
1046       return error("Quote token is omitted! Is not offered by either the Taker or Maker, Exchange.__executeOrderInputIsValid__()");
1047     }
1048 
1049     // Check that none of the amounts is = to 0
1050     if (
1051         amountsExpirationsAndSalts[0] == 0 ||
1052         amountsExpirationsAndSalts[1] == 0 ||
1053         amountsExpirationsAndSalts[2] == 0 ||
1054         amountsExpirationsAndSalts[3] == 0
1055       )
1056       return error("May not execute an order where token amount == 0, Exchange.__executeOrderInputIsValid__()");
1057 
1058     // // Confirm order ether amount >= min amount
1059     //  // Maker
1060     //  uint256 minOrderEthAmount = minOrderEthAmount_; // Single storage read
1061     //  if (_token_and_EOA_Addresses[1] == 0 && _amountsExpirationAndSalt[0] < minOrderEthAmount)
1062     //    return error('Maker order does not meet the minOrderEthAmount_ of ether, Exchange.__executeOrderInputIsValid__()');
1063 
1064     //  // Taker
1065     //  if (_token_and_EOA_Addresses[3] == 0 && _amountsExpirationAndSalt[2] < minOrderEthAmount)
1066     //    return error('Taker order does not meet the minOrderEthAmount_ of ether, Exchange.__executeOrderInputIsValid__()');
1067 
1068     return true;
1069   }
1070 
1071   /**
1072    * @dev Execute the external transfer of tokens.
1073    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
1074    * [
1075    *   makerEOA
1076    *   makerOfferToken
1077    *   takerEOA
1078    *   takerOfferToken
1079    * ]
1080    * @param toTakerAmount The amount of tokens to transfer to the taker.
1081    * @param toMakerAmount The amount of tokens to transfer to the maker.
1082    * @return Success if both wallets verify the order.
1083    */
1084   function __executeTokenTransfer__(
1085     address[4] ownedExternalAddressesAndTokenAddresses,
1086     uint256 toTakerAmount,
1087     uint256 toMakerAmount,
1088     uint256 fee,
1089     WalletV2 makerTradingWallet,
1090     WalletV2 takerTradingWallet
1091   ) private
1092     returns (bool)
1093   {
1094     // Wallet mapping balances
1095     address makerOfferTokenAddress = ownedExternalAddressesAndTokenAddresses[1];
1096     address takerOfferTokenAddress = ownedExternalAddressesAndTokenAddresses[3];
1097 
1098     // Taker to pay fee before trading
1099     if(fee != 0) {
1100       require(
1101         takerTradingWallet.updateBalance(edoToken_, fee, true),
1102         "Taker trading wallet cannot update balance with fee, Exchange.__executeTokenTransfer__()"
1103       );
1104 
1105       require(
1106         Token(edoToken_).transferFrom(takerTradingWallet, eidooWallet_, fee),
1107         "Cannot transfer fees from taker trading wallet to eidoo wallet, Exchange.__executeTokenTransfer__()"
1108       );
1109     }
1110 
1111     // Updating makerTradingWallet balance by the toTaker
1112     require(
1113       makerTradingWallet.updateBalance(makerOfferTokenAddress, toTakerAmount, true),
1114       "Maker trading wallet cannot update balance subtracting toTakerAmount, Exchange.__executeTokenTransfer__()"
1115     ); // return error("Unable to subtract maker token from maker wallet, Exchange.__executeTokenTransfer__()");
1116 
1117     // Updating takerTradingWallet balance by the toTaker
1118     require(
1119       takerTradingWallet.updateBalance(makerOfferTokenAddress, toTakerAmount, false),
1120       "Taker trading wallet cannot update balance adding toTakerAmount, Exchange.__executeTokenTransfer__()"
1121     ); // return error("Unable to add maker token to taker wallet, Exchange.__executeTokenTransfer__()");
1122 
1123     // Updating takerTradingWallet balance by the toMaker amount
1124     require(
1125       takerTradingWallet.updateBalance(takerOfferTokenAddress, toMakerAmount, true),
1126       "Taker trading wallet cannot update balance subtracting toMakerAmount, Exchange.__executeTokenTransfer__()"
1127     ); // return error("Unable to subtract taker token from taker wallet, Exchange.__executeTokenTransfer__()");
1128 
1129     // Updating makerTradingWallet balance by the toMaker amount
1130     require(
1131       makerTradingWallet.updateBalance(takerOfferTokenAddress, toMakerAmount, false),
1132       "Maker trading wallet cannot update balance adding toMakerAmount, Exchange.__executeTokenTransfer__()"
1133     ); // return error("Unable to add taker token to maker wallet, Exchange.__executeTokenTransfer__()");
1134 
1135     // Ether to the taker and tokens to the maker
1136     if (makerOfferTokenAddress == address(0)) {
1137       address(takerTradingWallet).transfer(toTakerAmount);
1138     } else {
1139       require(
1140         safeTransferFrom(makerOfferTokenAddress, makerTradingWallet, takerTradingWallet, toTakerAmount),
1141         "Token transfership from makerTradingWallet to takerTradingWallet failed, Exchange.__executeTokenTransfer__()"
1142       );
1143       assert(
1144         __tokenAndWalletBalancesMatch__(
1145           makerTradingWallet,
1146           takerTradingWallet,
1147           makerOfferTokenAddress
1148         )
1149       );
1150     }
1151 
1152     if (takerOfferTokenAddress == address(0)) {
1153       address(makerTradingWallet).transfer(toMakerAmount);
1154     } else {
1155       require(
1156         safeTransferFrom(takerOfferTokenAddress, takerTradingWallet, makerTradingWallet, toMakerAmount),
1157         "Token transfership from takerTradingWallet to makerTradingWallet failed, Exchange.__executeTokenTransfer__()"
1158       );
1159       assert(
1160         __tokenAndWalletBalancesMatch__(
1161           makerTradingWallet,
1162           takerTradingWallet,
1163           takerOfferTokenAddress
1164         )
1165       );
1166     }
1167 
1168     return true;
1169   }
1170 
1171   /**
1172    * @dev Calculates Keccak-256 hash of order with specified parameters.
1173    * @param ownedExternalAddressesAndTokenAddresses The orders maker EOA and current exchange address.
1174    * @param amountsExpirationsAndSalts The orders offer and want amounts and expirations with salts.
1175    * @return Keccak-256 hash of the passed order.
1176    */
1177 
1178   function generateOrderHashes(
1179     address[4] ownedExternalAddressesAndTokenAddresses,
1180     uint256[8] amountsExpirationsAndSalts
1181   ) public
1182     view
1183     returns (bytes32[2])
1184   {
1185     bytes32 makerOrderHash = keccak256(
1186       address(this),
1187       ownedExternalAddressesAndTokenAddresses[0], // _makerEOA
1188       ownedExternalAddressesAndTokenAddresses[1], // offerToken
1189       amountsExpirationsAndSalts[0],  // offerTokenAmount
1190       ownedExternalAddressesAndTokenAddresses[3], // wantToken
1191       amountsExpirationsAndSalts[1],  // wantTokenAmount
1192       amountsExpirationsAndSalts[4], // expiry
1193       amountsExpirationsAndSalts[5] // salt
1194     );
1195 
1196     bytes32 takerOrderHash = keccak256(
1197       address(this),
1198       ownedExternalAddressesAndTokenAddresses[2], // _makerEOA
1199       ownedExternalAddressesAndTokenAddresses[3], // offerToken
1200       amountsExpirationsAndSalts[2],  // offerTokenAmount
1201       ownedExternalAddressesAndTokenAddresses[1], // wantToken
1202       amountsExpirationsAndSalts[3],  // wantTokenAmount
1203       amountsExpirationsAndSalts[6], // expiry
1204       amountsExpirationsAndSalts[7] // salt
1205     );
1206 
1207     return [makerOrderHash, takerOrderHash];
1208   }
1209 
1210   /**
1211    * @dev Returns a bool representing a SELL or BUY order based on quotePriority.
1212    * @param _order The maker order data structure.
1213    * @return The bool indicating if the order is a SELL or BUY.
1214    */
1215   function __isSell__(Order _order) internal view returns (bool) {
1216     return quotePriority[_order.offerToken_] < quotePriority[_order.wantToken_];
1217   }
1218 
1219   /**
1220    * @dev Compute the tradeable amounts of the two verified orders.
1221    * Token amount is the __min__ remaining between want and offer of the two orders that isn"t ether.
1222    * Ether amount is then: etherAmount = tokenAmount * priceRatio, as ratio = eth / token.
1223    * @param makerOrder The maker order data structure.
1224    * @param takerOrder The taker order data structure.
1225    * @return The amount moving from makerOfferRemaining to takerWantRemaining and vice versa.
1226    */
1227   function __getTradeAmounts__(
1228     Order makerOrder,
1229     Order takerOrder
1230   ) internal
1231     view
1232     returns (uint256[2])
1233   {
1234     bool isMakerBuy = __isSell__(takerOrder);  // maker buy = taker sell
1235     uint256 priceRatio;
1236     uint256 makerAmountLeftToReceive;
1237     uint256 takerAmountLeftToReceive;
1238 
1239     uint toTakerAmount;
1240     uint toMakerAmount;
1241 
1242     if (makerOrder.offerTokenTotal_ >= makerOrder.wantTokenTotal_) {
1243       priceRatio = makerOrder.offerTokenTotal_.mul(2**128).div(makerOrder.wantTokenTotal_);
1244       if (isMakerBuy) {
1245         // MP > 1
1246         makerAmountLeftToReceive = makerOrder.wantTokenTotal_.sub(makerOrder.wantTokenReceived_);
1247         toMakerAmount = __min__(takerOrder.offerTokenRemaining_, makerAmountLeftToReceive);
1248         // add 2**128-1 in order to obtain a round up
1249         toTakerAmount = toMakerAmount.mul(priceRatio).add(2**128-1).div(2**128);
1250       } else {
1251         // MP < 1
1252         takerAmountLeftToReceive = takerOrder.wantTokenTotal_.sub(takerOrder.wantTokenReceived_);
1253         toTakerAmount = __min__(makerOrder.offerTokenRemaining_, takerAmountLeftToReceive);
1254         toMakerAmount = toTakerAmount.mul(2**128).div(priceRatio);
1255       }
1256     } else {
1257       priceRatio = makerOrder.wantTokenTotal_.mul(2**128).div(makerOrder.offerTokenTotal_);
1258       if (isMakerBuy) {
1259         // MP < 1
1260         makerAmountLeftToReceive = makerOrder.wantTokenTotal_.sub(makerOrder.wantTokenReceived_);
1261         toMakerAmount = __min__(takerOrder.offerTokenRemaining_, makerAmountLeftToReceive);
1262         toTakerAmount = toMakerAmount.mul(2**128).div(priceRatio);
1263       } else {
1264         // MP > 1
1265         takerAmountLeftToReceive = takerOrder.wantTokenTotal_.sub(takerOrder.wantTokenReceived_);
1266         toTakerAmount = __min__(makerOrder.offerTokenRemaining_, takerAmountLeftToReceive);
1267         // add 2**128-1 in order to obtain a round up
1268         toMakerAmount = toTakerAmount.mul(priceRatio).add(2**128-1).div(2**128);
1269       }
1270     }
1271     return [toTakerAmount, toMakerAmount];
1272   }
1273 
1274   /**
1275    * @dev Return the maximum of two uints
1276    * @param a Uint 1
1277    * @param b Uint 2
1278    * @return The grater value or a if equal
1279    */
1280   function __max__(uint256 a, uint256 b)
1281     private
1282     pure
1283     returns (uint256)
1284   {
1285     return a < b
1286       ? b
1287       : a;
1288   }
1289 
1290   /**
1291    * @dev Return the minimum of two uints
1292    * @param a Uint 1
1293    * @param b Uint 2
1294    * @return The smallest value or b if equal
1295    */
1296   function __min__(uint256 a, uint256 b)
1297     private
1298     pure
1299     returns (uint256)
1300   {
1301     return a < b
1302       ? a
1303       : b;
1304   }
1305 
1306   /**
1307    * @dev Confirm that the orders do match and are valid.
1308    * @param makerOrder The maker order data structure.
1309    * @param takerOrder The taker order data structure.
1310    * @return Bool if the orders passes all checks.
1311    */
1312   function __ordersMatch_and_AreVaild__(
1313     Order makerOrder,
1314     Order takerOrder
1315   ) private
1316     returns (bool)
1317   {
1318     // Confirm tokens match
1319     // NOTE potentially omit as matching handled upstream?
1320     if (makerOrder.wantToken_ != takerOrder.offerToken_) {
1321       return error("Maker wanted token does not match taker offer token, Exchange.__ordersMatch_and_AreVaild__()");
1322     }
1323 
1324     if (makerOrder.offerToken_ != takerOrder.wantToken_) {
1325       return error("Maker offer token does not match taker wanted token, Exchange.__ordersMatch_and_AreVaild__()");
1326     }
1327 
1328     // Price Ratios, to x decimal places hence * decimals, dependent on the size of the denominator.
1329     // Ratios are relative to eth, amount of ether for a single token, ie. ETH / GNO == 0.2 Ether per 1 Gnosis
1330 
1331     uint256 orderPrice;   // The price the maker is willing to accept
1332     uint256 offeredPrice; // The offer the taker has given
1333 
1334     // Ratio = larger amount / smaller amount
1335     if (makerOrder.offerTokenTotal_ >= makerOrder.wantTokenTotal_) {
1336       orderPrice = makerOrder.offerTokenTotal_.mul(2**128).div(makerOrder.wantTokenTotal_);
1337       offeredPrice = takerOrder.wantTokenTotal_.mul(2**128).div(takerOrder.offerTokenTotal_);
1338 
1339       // ie. Maker is offering 10 ETH for 100 GNO but taker is offering 100 GNO for 20 ETH, no match!
1340       // The taker wants more ether than the maker is offering.
1341       if (orderPrice < offeredPrice) {
1342         return error("Taker price is greater than maker price, Exchange.__ordersMatch_and_AreVaild__()");
1343       }
1344     } else {
1345       orderPrice = makerOrder.wantTokenTotal_.mul(2**128).div(makerOrder.offerTokenTotal_);
1346       offeredPrice = takerOrder.offerTokenTotal_.mul(2**128).div(takerOrder.wantTokenTotal_);
1347 
1348       // ie. Maker is offering 100 GNO for 10 ETH but taker is offering 5 ETH for 100 GNO, no match!
1349       // The taker is not offering enough ether for the maker
1350       if (orderPrice > offeredPrice) {
1351         return error("Taker price is less than maker price, Exchange.__ordersMatch_and_AreVaild__()");
1352       }
1353     }
1354 
1355     return true;
1356   }
1357 
1358   /**
1359    * @dev Ask each wallet to verify this order.
1360    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
1361    * [
1362    *   makerEOA
1363    *   makerOfferToken
1364    *   takerEOA
1365    *   takerOfferToken
1366    * ]
1367    * @param toMakerAmount The amount of tokens to be sent to the maker.
1368    * @param toTakerAmount The amount of tokens to be sent to the taker.
1369    * @param makerTradingWallet The maker trading wallet contract.
1370    * @param takerTradingWallet The taker trading wallet contract.
1371    * @param fee The fee to be paid for this trade, paid in full by taker.
1372    * @return Success if both wallets verify the order.
1373    */
1374   function __ordersVerifiedByWallets__(
1375     address[4] ownedExternalAddressesAndTokenAddresses,
1376     uint256 toMakerAmount,
1377     uint256 toTakerAmount,
1378     WalletV2 makerTradingWallet,
1379     WalletV2 takerTradingWallet,
1380     uint256 fee
1381   ) private
1382     returns (bool)
1383   {
1384     // Have the transaction verified by both maker and taker wallets
1385     // confirm sufficient balance to transfer, offerToken and offerTokenAmount
1386     if(!makerTradingWallet.verifyOrder(ownedExternalAddressesAndTokenAddresses[1], toTakerAmount, 0, 0)) {
1387       return error("Maker wallet could not verify the order, Exchange.____ordersVerifiedByWallets____()");
1388     }
1389 
1390     if(!takerTradingWallet.verifyOrder(ownedExternalAddressesAndTokenAddresses[3], toMakerAmount, fee, edoToken_)) {
1391       return error("Taker wallet could not verify the order, Exchange.____ordersVerifiedByWallets____()");
1392     }
1393 
1394     return true;
1395   }
1396 
1397   /**
1398    * @dev On chain verification of an ECDSA ethereum signature.
1399    * @param signer The EOA address of the account that supposedly signed the message.
1400    * @param orderHash The on-chain generated hash for the order.
1401    * @param v ECDSA signature parameter v.
1402    * @param r ECDSA signature parameter r.
1403    * @param s ECDSA signature parameter s.
1404    * @return Bool if the signature is valid or not.
1405    */
1406   function __signatureIsValid__(
1407     address signer,
1408     bytes32 orderHash,
1409     uint8 v,
1410     bytes32 r,
1411     bytes32 s
1412   ) private
1413     pure
1414     returns (bool)
1415   {
1416     address recoveredAddr = ecrecover(
1417       keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash)),
1418       v,
1419       r,
1420       s
1421     );
1422 
1423     return recoveredAddr == signer;
1424   }
1425 
1426   /**
1427    * @dev Confirm wallet local balances and token balances match.
1428    * @param makerTradingWallet  Maker wallet address.
1429    * @param takerTradingWallet  Taker wallet address.
1430    * @param token  Token address to confirm balances match.
1431    * @return If the balances do match.
1432    */
1433   function __tokenAndWalletBalancesMatch__(
1434     address makerTradingWallet,
1435     address takerTradingWallet,
1436     address token
1437   ) private
1438     view
1439     returns(bool)
1440   {
1441     if (Token(token).balanceOf(makerTradingWallet) != WalletV2(makerTradingWallet).balanceOf(token)) {
1442       return false;
1443     }
1444 
1445     if (Token(token).balanceOf(takerTradingWallet) != WalletV2(takerTradingWallet).balanceOf(token)) {
1446       return false;
1447     }
1448 
1449     return true;
1450   }
1451 
1452   /**
1453    * @dev Wrapping the ERC20 transfer function to avoid missing returns.
1454    * @param _token The address of bad formed ERC20 token.
1455    * @param _from Transfer sender.
1456    * @param _to Transfer receiver.
1457    * @param _value Amount to be transfered.
1458    * @return Success of the safeTransfer.
1459    */
1460   function safeTransferFrom(
1461     address _token,
1462     address _from,
1463     address _to,
1464     uint256 _value
1465   )
1466     public
1467     returns (bool result)
1468   {
1469     BadERC20(_token).transferFrom(_from, _to, _value);
1470 
1471     assembly {
1472       switch returndatasize()
1473       case 0 {                      // This is our BadToken
1474         result := not(0)            // result is true
1475       }
1476       case 32 {                     // This is our GoodToken
1477         returndatacopy(0, 0, 32)
1478         result := mload(0)          // result == returndata of external call
1479       }
1480       default {                     // This is not an ERC20 token
1481         revert(0, 0)
1482       }
1483     }
1484   }
1485 }