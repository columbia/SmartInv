1 pragma solidity ^0.4.24;
2 
3 // File: contracts/utils/LoggingErrors.sol
4 
5 /**
6  * @title Log Various Error Types
7  * @author Adam Lemmon <adam@oraclize.it>
8  * @dev Inherit this contract and your may now log errors easily
9  * To support various error types, params, etc.
10  */
11 contract LoggingErrors {
12   /**
13   * Events
14   */
15   event LogErrorString(string errorString);
16 
17   /**
18   * Error cases
19   */
20 
21   /**
22    * @dev Default error to simply log the error message and return
23    * @param _errorMessage The error message to log
24    * @return ALWAYS false
25    */
26   function error(string _errorMessage) internal returns(bool) {
27     LogErrorString(_errorMessage);
28     return false;
29   }
30 }
31 
32 // File: contracts/wallet/WalletConnector.sol
33 
34 /**
35  * @title Wallet Connector
36  * @dev Connect the wallet contract to the correct Wallet Logic version
37  */
38 contract WalletConnector is LoggingErrors {
39   /**
40    * Storage
41    */
42   address public owner_;
43   address public latestLogic_;
44   uint256 public latestVersion_;
45   mapping(uint256 => address) public logicVersions_;
46   uint256 public birthBlock_;
47 
48   /**
49    * Events
50    */
51   event LogLogicVersionAdded(uint256 version);
52   event LogLogicVersionRemoved(uint256 version);
53 
54   /**
55    * @dev Constructor to set the latest logic address
56    * @param _latestVersion Latest version of the wallet logic
57    * @param _latestLogic Latest address of the wallet logic contract
58    */
59   function WalletConnector (
60     uint256 _latestVersion,
61     address _latestLogic
62   ) public {
63     owner_ = msg.sender;
64     latestLogic_ = _latestLogic;
65     latestVersion_ = _latestVersion;
66     logicVersions_[_latestVersion] = _latestLogic;
67     birthBlock_ = block.number;
68   }
69 
70   /**
71    * Add a new version of the logic contract
72    * @param _version The version to be associated with the new contract.
73    * @param _logic New logic contract.
74    * @return Success of the transaction.
75    */
76   function addLogicVersion (
77     uint256 _version,
78     address _logic
79   ) external
80     returns(bool)
81   {
82     if (msg.sender != owner_)
83       return error('msg.sender != owner, WalletConnector.addLogicVersion()');
84 
85     if (logicVersions_[_version] != 0)
86       return error('Version already exists, WalletConnector.addLogicVersion()');
87 
88     // Update latest if this is the latest version
89     if (_version > latestVersion_) {
90       latestLogic_ = _logic;
91       latestVersion_ = _version;
92     }
93 
94     logicVersions_[_version] = _logic;
95     LogLogicVersionAdded(_version);
96 
97     return true;
98   }
99 
100   /**
101    * @dev Remove a version. Cannot remove the latest version.
102    * @param  _version The version to remove.
103    */
104   function removeLogicVersion(uint256 _version) external {
105     require(msg.sender == owner_);
106     require(_version != latestVersion_);
107     delete logicVersions_[_version];
108     LogLogicVersionRemoved(_version);
109   }
110 
111   /**
112    * Constants
113    */
114 
115   /**
116    * Called from user wallets in order to upgrade their logic.
117    * @param _version The version to upgrade to. NOTE pass in 0 to upgrade to latest.
118    * @return The address of the logic contract to upgrade to.
119    */
120   function getLogic(uint256 _version)
121     external
122     constant
123     returns(address)
124   {
125     if (_version == 0)
126       return latestLogic_;
127     else
128       return logicVersions_[_version];
129   }
130 }
131 
132 // File: contracts/wallet/WalletV2.sol
133 
134 /**
135  * @title Wallet to hold and trade ERC20 tokens and ether
136  * @author Adam Lemmon <adam@oraclize.it>
137  * @dev User wallet to interact with the exchange.
138  * all tokens and ether held in this wallet, 1 to 1 mapping to user EOAs.
139  */
140 contract WalletV2 is LoggingErrors {
141   /**
142    * Storage
143    */
144   // Vars included in wallet logic "lib", the order must match between Wallet and Logic
145   address public owner_;
146   address public exchange_;
147   mapping(address => uint256) public tokenBalances_;
148 
149   address public logic_; // storage location 0x3 loaded for delegatecalls so this var must remain at index 3
150   uint256 public birthBlock_;
151 
152   WalletConnector private connector_;
153 
154   /**
155    * Events
156    */
157   event LogDeposit(address token, uint256 amount, uint256 balance);
158   event LogWithdrawal(address token, uint256 amount, uint256 balance);
159 
160   /**
161    * @dev Contract constructor. Set user as owner and connector address.
162    * @param _owner The address of the user's EOA, wallets created from the exchange
163    * so must past in the owner address, msg.sender == exchange.
164    * @param _connector The wallet connector to be used to retrieve the wallet logic
165    */
166   function WalletV2(address _owner, address _connector) public {
167     owner_ = _owner;
168     connector_ = WalletConnector(_connector);
169     exchange_ = msg.sender;
170     logic_ = connector_.latestLogic_();
171     birthBlock_ = block.number;
172   }
173 
174   /**
175    * @dev Fallback - Only enable funds to be sent from the exchange.
176    * Ensures balances will be consistent.
177    */
178   function () external payable {
179     require(msg.sender == exchange_);
180   }
181 
182   /**
183   * External
184   */
185 
186   /**
187    * @dev Deposit ether into this wallet, default to address 0 for consistent token lookup.
188    */
189   function depositEther()
190     external
191     payable
192   {
193     require(logic_.delegatecall(bytes4(sha3('deposit(address,uint256)')), 0, msg.value));
194   }
195 
196   /**
197    * @dev Deposit any ERC20 token into this wallet.
198    * @param _token The address of the existing token contract.
199    * @param _amount The amount of tokens to deposit.
200    * @return Bool if the deposit was successful.
201    */
202   function depositERC20Token (
203     address _token,
204     uint256 _amount
205   ) external
206     returns(bool)
207   {
208     // ether
209     if (_token == 0)
210       return error('Cannot deposit ether via depositERC20, Wallet.depositERC20Token()');
211 
212     require(logic_.delegatecall(bytes4(sha3('deposit(address,uint256)')), _token, _amount));
213     return true;
214   }
215 
216   /**
217    * @dev The result of an order, update the balance of this wallet.
218    * @param _token The address of the token balance to update.
219    * @param _amount The amount to update the balance by.
220    * @param _subtractionFlag If true then subtract the token amount else add.
221    * @return Bool if the update was successful.
222    */
223   function updateBalance (
224     address _token,
225     uint256 _amount,
226     bool _subtractionFlag
227   ) external
228     returns(bool)
229   {
230     assembly {
231       calldatacopy(0x40, 0, calldatasize)
232       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
233       return(0, 32)
234       pop
235     }
236   }
237 
238   /**
239    * User may update to the latest version of the exchange contract.
240    * Note that multiple versions are NOT supported at this time and therefore if a
241    * user does not wish to update they will no longer be able to use the exchange.
242    * @param _exchange The new exchange.
243    * @return Success of this transaction.
244    */
245   function updateExchange(address _exchange)
246     external
247     returns(bool)
248   {
249     if (msg.sender != owner_)
250       return error('msg.sender != owner_, Wallet.updateExchange()');
251 
252     // If subsequent messages are not sent from this address all orders will fail
253     exchange_ = _exchange;
254 
255     return true;
256   }
257 
258   /**
259    * User may update to a new or older version of the logic contract.
260    * @param _version The versin to update to.
261    * @return Success of this transaction.
262    */
263   function updateLogic(uint256 _version)
264     external
265     returns(bool)
266   {
267     if (msg.sender != owner_)
268       return error('msg.sender != owner_, Wallet.updateLogic()');
269 
270     address newVersion = connector_.getLogic(_version);
271 
272     // Invalid version as defined by connector
273     if (newVersion == 0)
274       return error('Invalid version, Wallet.updateLogic()');
275 
276     logic_ = newVersion;
277     return true;
278   }
279 
280   /**
281    * @dev Verify an order that the Exchange has received involving this wallet.
282    * Internal checks and then authorize the exchange to move the tokens.
283    * If sending ether will transfer to the exchange to broker the trade.
284    * @param _token The address of the token contract being sold.
285    * @param _amount The amount of tokens the order is for.
286    * @param _fee The fee for the current trade.
287    * @param _feeToken The token of which the fee is to be paid in.
288    * @return If the order was verified or not.
289    */
290   function verifyOrder (
291     address _token,
292     uint256 _amount,
293     uint256 _fee,
294     address _feeToken
295   ) external
296     returns(bool)
297   {
298     assembly {
299       calldatacopy(0x40, 0, calldatasize)
300       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
301       return(0, 32)
302       pop
303     }
304   }
305 
306   /**
307    * @dev Withdraw any token, including ether from this wallet to an EOA.
308    * @param _token The address of the token to withdraw.
309    * @param _amount The amount to withdraw.
310    * @return Success of the withdrawal.
311    */
312   function withdraw(address _token, uint256 _amount)
313     external
314     returns(bool)
315   {
316     if(msg.sender != owner_)
317       return error('msg.sender != owner, Wallet.withdraw()');
318 
319     assembly {
320       calldatacopy(0x40, 0, calldatasize)
321       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
322       return(0, 32)
323       pop
324     }
325   }
326 
327   /**
328    * Constants
329    */
330 
331   /**
332    * @dev Get the balance for a specific token.
333    * @param _token The address of the token contract to retrieve the balance of.
334    * @return The current balance within this contract.
335    */
336   function balanceOf(address _token)
337     public
338     view
339     returns(uint)
340   {
341     return tokenBalances_[_token];
342   }
343 }
344 
345 // File: contracts/utils/SafeMath.sol
346 
347 /**
348  * @title SafeMath
349  * @dev Math operations with safety checks that throw on error
350  */
351 library SafeMath {
352   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
353     uint256 c = a * b;
354     assert(a == 0 || c / a == b);
355     return c;
356   }
357 
358   function div(uint256 a, uint256 b) internal constant returns (uint256) {
359     // assert(b > 0); // Solidity automatically throws when dividing by 0
360     uint256 c = a / b;
361     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
362     return c;
363   }
364 
365   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
366     assert(b <= a);
367     return a - b;
368   }
369 
370   function add(uint256 a, uint256 b) internal constant returns (uint256) {
371     uint256 c = a + b;
372     assert(c >= a);
373     return c;
374   }
375 }
376 
377 // File: contracts/token/ERC20Interface.sol
378 
379 contract Token {
380   /// @return total amount of tokens
381   function totalSupply() constant returns (uint256 supply) {}
382 
383   /// @param _owner The address from which the balance will be retrieved
384   /// @return The balance
385   function balanceOf(address _owner) constant returns (uint256 balance) {}
386 
387   /// @notice send `_value` token to `_to` from `msg.sender`
388   /// @param _to The address of the recipient
389   /// @param _value The amount of token to be transferred
390   /// @return Whether the transfer was successful or not
391   function transfer(address _to, uint256 _value) returns (bool success) {}
392 
393   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
394   /// @param _from The address of the sender
395   /// @param _to The address of the recipient
396   /// @param _value The amount of token to be transferred
397   /// @return Whether the transfer was successful or not
398   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
399 
400   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
401   /// @param _spender The address of the account able to transfer the tokens
402   /// @param _value The amount of wei to be approved for transfer
403   /// @return Whether the approval was successful or not
404   function approve(address _spender, uint256 _value) returns (bool success) {}
405 
406   /// @param _owner The address of the account owning tokens
407   /// @param _spender The address of the account able to transfer the tokens
408   /// @return Amount of remaining tokens allowed to spent
409   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
410 
411   event Transfer(address indexed _from, address indexed _to, uint256 _value);
412   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
413 
414   uint public decimals;
415   string public name;
416 }
417 
418 // File: contracts/ExchangeV2.sol
419 
420 interface ExchangeV1 {
421   function userAccountToWallet_(address) external returns(address);
422 }
423 
424 /**
425  * @title Decentralized exchange for ether and ERC20 tokens.
426  * @author Eidoo SAGL.
427  * @dev All trades brokered by this contract.
428  * Orders submitted by off chain order book and this contract handles
429  * verification and execution of orders.
430  * All value between parties is transferred via this exchange.
431  * Methods arranged by visibility; external, public, internal, private and alphabatized within.
432  *
433  * New Exchange SC with eventually no fee and ERC20 tokens as quote
434  */
435 contract ExchangeV2 is LoggingErrors {
436 
437   using SafeMath for uint256;
438 
439   /**
440    * Data Structures
441    */
442   struct Order {
443     address offerToken_;
444     uint256 offerTokenTotal_;
445     uint256 offerTokenRemaining_;  // Amount left to give
446     address wantToken_;
447     uint256 wantTokenTotal_;
448     uint256 wantTokenReceived_;  // Amount received, note this may exceed want total
449   }
450 
451   struct OrderStatus {
452     uint256 expirationBlock_;
453     uint256 wantTokenReceived_;    // Amount received, note this may exceed want total
454     uint256 offerTokenRemaining_;  // Amount left to give
455   }
456 
457   /**
458    * Storage
459    */
460   address public previousExchangeAddress_;
461   address private orderBookAccount_;
462   address public owner_;
463   uint256 public birthBlock_;
464   address public edoToken_;
465   address public walletConnector;
466 
467   mapping (address => uint256) public feeEdoPerQuote;
468   mapping (address => uint256) public feeEdoPerQuoteDecimals;
469 
470   address public eidooWallet_;
471 
472   // Define if fee calculation must be skipped for a given trade. By default (false) fee must not be skipped.
473   mapping(address => mapping(address => bool)) public mustSkipFee;
474 
475   /**
476    * @dev Define in a trade who is the quote using a priority system:
477    * values example
478    *   0: not used as quote
479    *  >0: used as quote
480    *  if wanted and offered tokens have value > 0 the quote is the token with the bigger value
481    */
482   mapping(address => uint256) public quotePriority;
483 
484   mapping(bytes32 => OrderStatus) public orders_; // Map order hashes to order data struct
485   mapping(address => address) public userAccountToWallet_; // User EOA to wallet addresses
486 
487   /**
488    * Events
489    */
490   event LogFeeRateSet(address indexed token, uint256 rate, uint256 decimals);
491   event LogQuotePrioritySet(address indexed quoteToken, uint256 priority);
492   event LogMustSkipFeeSet(address indexed base, address indexed quote, bool mustSkipFee);
493   event LogUserAdded(address indexed user, address walletAddress);
494   event LogWalletDeposit(address indexed walletAddress, address token, uint256 amount, uint256 balance);
495   event LogWalletWithdrawal(address indexed walletAddress, address token, uint256 amount, uint256 balance);
496 
497   event LogOrderExecutionSuccess();
498   event LogOrderFilled(bytes32 indexed orderId, uint256 fillAmount, uint256 fillRemaining);
499 
500   /**
501    * @dev Contract constructor - CONFIRM matches contract name.  Set owner and addr of order book.
502    * @param _bookAccount The EOA address for the order book, will submit ALL orders.
503    * @param _edoToken Deployed edo token.
504    * @param _edoPerWei Rate of edo tokens per wei.
505    * @param _edoPerWeiDecimals Decimlas carried in edo rate.
506    * @param _eidooWallet Wallet to pay fees to.
507    * @param _previousExchangeAddress Previous exchange smart contract address.
508    */
509   constructor (
510     address _bookAccount,
511     address _edoToken,
512     uint256 _edoPerWei,
513     uint256 _edoPerWeiDecimals,
514     address _eidooWallet,
515     address _previousExchangeAddress,
516     address _walletConnector
517   ) public {
518     orderBookAccount_ = _bookAccount;
519     owner_ = msg.sender;
520     birthBlock_ = block.number;
521     edoToken_ = _edoToken;
522     feeEdoPerQuote[address(0)] = _edoPerWei;
523     feeEdoPerQuoteDecimals[address(0)] = _edoPerWeiDecimals;
524     eidooWallet_ = _eidooWallet;
525     quotePriority[address(0)] = 10;
526     previousExchangeAddress_ = _previousExchangeAddress;
527     require(_walletConnector != address (0), "WalletConnector address == 0");
528     walletConnector = _walletConnector;
529   }
530 
531   /**
532    * @dev Fallback. wallets utilize to send ether in order to broker trade.
533    */
534   function () external payable { }
535 
536   /**
537    * External
538    */
539 
540   /**
541    * @dev Returns the Wallet contract address associated to a user account. If the user account is not known, try to
542    * migrate the wallet address from the old exchange instance. This function is equivalent to getWallet(), in addition
543    * it stores the wallet address fetched from old the exchange instance.
544    * @param userAccount The user account address
545    * @return The address of the Wallet instance associated to the user account
546    */
547   function retrieveWallet(address userAccount)
548     public
549     returns(address walletAddress)
550   {
551     walletAddress = userAccountToWallet_[userAccount];
552     if (walletAddress == address(0) && previousExchangeAddress_ != 0) {
553       // Retrieve the wallet address from the old exchange.
554       walletAddress = ExchangeV1(previousExchangeAddress_).userAccountToWallet_(userAccount);
555       // TODO: in the future versions of the exchange the above line must be replaced with the following one
556       //walletAddress = ExchangeV2(previousExchangeAddress_).retrieveWallet(userAccount);
557 
558       if (walletAddress != address(0)) {
559         userAccountToWallet_[userAccount] = walletAddress;
560       }
561     }
562   }
563 
564   /**
565    * @dev Add a new user to the exchange, create a wallet for them.
566    * Map their account address to the wallet contract for lookup.
567    * @param userExternalOwnedAccount The address of the user"s EOA.
568    * @return Success of the transaction, false if error condition met.
569    */
570   function addNewUser(address userExternalOwnedAccount)
571     public
572     returns (bool)
573   {
574     if (retrieveWallet(userExternalOwnedAccount) != address(0)) {
575       return error("User already exists, Exchange.addNewUser()");
576     }
577 
578     // Pass the userAccount address to wallet constructor so owner is not the exchange contract
579     address userTradingWallet = new WalletV2(userExternalOwnedAccount, walletConnector);
580     userAccountToWallet_[userExternalOwnedAccount] = userTradingWallet;
581     emit LogUserAdded(userExternalOwnedAccount, userTradingWallet);
582     return true;
583   }
584 
585   /**
586    * Execute orders in batches.
587    * @param ownedExternalAddressesAndTokenAddresses Tokan and user addresses.
588    * @param amountsExpirationsAndSalts Offer and want token amount and expiration and salt values.
589    * @param vSignatures All order signature v values.
590    * @param rAndSsignatures All order signature r and r values.
591    * @return The success of this transaction.
592    */
593   function batchExecuteOrder(
594     address[4][] ownedExternalAddressesAndTokenAddresses,
595     uint256[8][] amountsExpirationsAndSalts, // Packing to save stack size
596     uint8[2][] vSignatures,
597     bytes32[4][] rAndSsignatures
598   ) external
599     returns(bool)
600   {
601     for (uint256 i = 0; i < amountsExpirationsAndSalts.length; i++) {
602       require(
603         executeOrder(
604           ownedExternalAddressesAndTokenAddresses[i],
605           amountsExpirationsAndSalts[i],
606           vSignatures[i],
607           rAndSsignatures[i]
608         ),
609         "Cannot execute order, Exchange.batchExecuteOrder()"
610       );
611     }
612 
613     return true;
614   }
615 
616   /**
617    * @dev Execute an order that was submitted by the external order book server.
618    * The order book server believes it to be a match.
619    * There are components for both orders, maker and taker, 2 signatures as well.
620    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
621    * [
622    *   makerEOA
623    *   makerOfferToken
624    *   takerEOA
625    *   takerOfferToken
626    * ]
627    * @param amountsExpirationsAndSalts The amount of tokens and the block number at which this order expires and a random number to mitigate replay.
628    * [
629    *   makerOffer
630    *   makerWant
631    *   takerOffer
632    *   takerWant
633    *   makerExpiry
634    *   makerSalt
635    *   takerExpiry
636    *   takerSalt
637    * ]
638    * @param vSignatures ECDSA signature parameter.
639    * [
640    *   maker V
641    *   taker V
642    * ]
643    * @param rAndSsignatures ECDSA signature parameters r ans s, maker 0, 1 and taker 2, 3.
644    * [
645    *   maker R
646    *   maker S
647    *   taker R
648    *   taker S
649    * ]
650    * @return Success of the transaction, false if error condition met.
651    * Like types grouped to eliminate stack depth error.
652    */
653   function executeOrder (
654     address[4] ownedExternalAddressesAndTokenAddresses,
655     uint256[8] amountsExpirationsAndSalts, // Packing to save stack size
656     uint8[2] vSignatures,
657     bytes32[4] rAndSsignatures
658   ) public
659     returns(bool)
660   {
661     // Only read wallet addresses from storage once
662     // Need one more stack slot so squashing into array
663     WalletV2[2] memory makerAndTakerTradingWallets = [
664       WalletV2(retrieveWallet(ownedExternalAddressesAndTokenAddresses[0])), // maker
665       WalletV2(retrieveWallet(ownedExternalAddressesAndTokenAddresses[2])) // taker
666     ];
667 
668     // Basic pre-conditions, return if any input data is invalid
669     if(!__executeOrderInputIsValid__(
670       ownedExternalAddressesAndTokenAddresses,
671       amountsExpirationsAndSalts,
672       makerAndTakerTradingWallets[0], // maker
673       makerAndTakerTradingWallets[1] // taker
674     )) {
675       return error("Input is invalid, Exchange.executeOrder()");
676     }
677 
678     // Verify Maker and Taker signatures
679     bytes32[2] memory makerAndTakerOrderHash = generateOrderHashes(
680       ownedExternalAddressesAndTokenAddresses,
681       amountsExpirationsAndSalts
682     );
683 
684     // Check maker order signature
685     if (!__signatureIsValid__(
686       ownedExternalAddressesAndTokenAddresses[0],
687       makerAndTakerOrderHash[0],
688       vSignatures[0],
689       rAndSsignatures[0],
690       rAndSsignatures[1]
691     )) {
692       return error("Maker signature is invalid, Exchange.executeOrder()");
693     }
694 
695     // Check taker order signature
696     if (!__signatureIsValid__(
697       ownedExternalAddressesAndTokenAddresses[2],
698       makerAndTakerOrderHash[1],
699       vSignatures[1],
700       rAndSsignatures[2],
701       rAndSsignatures[3]
702     )) {
703       return error("Taker signature is invalid, Exchange.executeOrder()");
704     }
705 
706     // Exchange Order Verification and matching
707     OrderStatus memory makerOrderStatus = orders_[makerAndTakerOrderHash[0]];
708     OrderStatus memory takerOrderStatus = orders_[makerAndTakerOrderHash[1]];
709     Order memory makerOrder;
710     Order memory takerOrder;
711 
712     makerOrder.offerToken_ = ownedExternalAddressesAndTokenAddresses[1];
713     makerOrder.offerTokenTotal_ = amountsExpirationsAndSalts[0];
714     makerOrder.wantToken_ = ownedExternalAddressesAndTokenAddresses[3];
715     makerOrder.wantTokenTotal_ = amountsExpirationsAndSalts[1];
716 
717     if (makerOrderStatus.expirationBlock_ > 0) {  // Check for existence
718       // Orders still active
719       if (makerOrderStatus.offerTokenRemaining_ == 0) {
720         return error("Maker order is inactive, Exchange.executeOrder()");
721       }
722       makerOrder.offerTokenRemaining_ = makerOrderStatus.offerTokenRemaining_; // Amount to give
723       makerOrder.wantTokenReceived_ = makerOrderStatus.wantTokenReceived_; // Amount received
724     } else {
725       makerOrder.offerTokenRemaining_ = amountsExpirationsAndSalts[0]; // Amount to give
726       makerOrder.wantTokenReceived_ = 0; // Amount received
727       makerOrderStatus.expirationBlock_ = amountsExpirationsAndSalts[4]; // maker order expiration block
728     }
729 
730     takerOrder.offerToken_ = ownedExternalAddressesAndTokenAddresses[3];
731     takerOrder.offerTokenTotal_ = amountsExpirationsAndSalts[2];
732     takerOrder.wantToken_ = ownedExternalAddressesAndTokenAddresses[1];
733     takerOrder.wantTokenTotal_ = amountsExpirationsAndSalts[3];
734 
735     if (takerOrderStatus.expirationBlock_ > 0) {  // Check for existence
736       if (takerOrderStatus.offerTokenRemaining_ == 0) {
737         return error("Taker order is inactive, Exchange.executeOrder()");
738       }
739       takerOrder.offerTokenRemaining_ = takerOrderStatus.offerTokenRemaining_;  // Amount to give
740       takerOrder.wantTokenReceived_ = takerOrderStatus.wantTokenReceived_; // Amount received
741 
742     } else {
743       takerOrder.offerTokenRemaining_ = amountsExpirationsAndSalts[2];  // Amount to give
744       takerOrder.wantTokenReceived_ = 0; // Amount received
745       takerOrderStatus.expirationBlock_ = amountsExpirationsAndSalts[6]; // taker order expiration block
746     }
747 
748     // Check if orders are matching and are valid
749     if (!__ordersMatch_and_AreVaild__(makerOrder, takerOrder)) {
750       return error("Orders do not match, Exchange.executeOrder()");
751     }
752 
753     // Trade amounts
754     // [0] => toTakerAmount
755     // [1] => toMakerAmount
756     uint[2] memory toTakerAndToMakerAmount;
757     toTakerAndToMakerAmount = __getTradeAmounts__(makerOrder, takerOrder);
758 
759     // TODO consider removing. Can this condition be met?
760     if (toTakerAndToMakerAmount[0] < 1 || toTakerAndToMakerAmount[1] < 1) {
761       return error("Token amount < 1, price ratio is invalid! Token value < 1, Exchange.executeOrder()");
762     }
763 
764     uint calculatedFee = __calculateFee__(makerOrder, toTakerAndToMakerAmount[0], toTakerAndToMakerAmount[1]);
765 
766     // Check taker has sufficent EDO token balance to pay the fee
767     if (
768       takerOrder.offerToken_ == edoToken_ &&
769       Token(edoToken_).balanceOf(makerAndTakerTradingWallets[1]) < calculatedFee.add(toTakerAndToMakerAmount[1])
770     ) {
771       return error("Taker has an insufficient EDO token balance to cover the fee AND the offer, Exchange.executeOrder()");
772     } else if (Token(edoToken_).balanceOf(makerAndTakerTradingWallets[1]) < calculatedFee) {
773       return error("Taker has an insufficient EDO token balance to cover the fee, Exchange.executeOrder()");
774     }
775 
776     // Wallet Order Verification, reach out to the maker and taker wallets.
777     if (
778       !__ordersVerifiedByWallets__(
779         ownedExternalAddressesAndTokenAddresses,
780         toTakerAndToMakerAmount[1],
781         toTakerAndToMakerAmount[0],
782         makerAndTakerTradingWallets[0],
783         makerAndTakerTradingWallets[1],
784         calculatedFee
785     )) {
786       return error("Order could not be verified by wallets, Exchange.executeOrder()");
787     }
788 
789     // Order Execution, Order Fully Verified by this point, time to execute!
790     // Local order structs
791     __updateOrders__(
792       makerOrder,
793       takerOrder,
794       toTakerAndToMakerAmount[0],
795       toTakerAndToMakerAmount[1]
796     );
797 
798     // Write to storage then external calls
799     makerOrderStatus.offerTokenRemaining_ = makerOrder.offerTokenRemaining_;
800     makerOrderStatus.wantTokenReceived_ = makerOrder.wantTokenReceived_;
801 
802     takerOrderStatus.offerTokenRemaining_ = takerOrder.offerTokenRemaining_;
803     takerOrderStatus.wantTokenReceived_ = takerOrder.wantTokenReceived_;
804 
805     // Finally write orders to storage
806     orders_[makerAndTakerOrderHash[0]] = makerOrderStatus;
807     orders_[makerAndTakerOrderHash[1]] = takerOrderStatus;
808 
809     // Transfer the external value, ether <> tokens
810     require(
811       __executeTokenTransfer__(
812         ownedExternalAddressesAndTokenAddresses,
813         toTakerAndToMakerAmount[0],
814         toTakerAndToMakerAmount[1],
815         calculatedFee,
816         makerAndTakerTradingWallets[0],
817         makerAndTakerTradingWallets[1]
818       ),
819       "Cannot execute token transfer, Exchange.__executeTokenTransfer__()"
820     );
821 
822     // Log the order id(hash), amount of offer given, amount of offer remaining
823     emit LogOrderFilled(makerAndTakerOrderHash[0], toTakerAndToMakerAmount[0], makerOrder.offerTokenRemaining_);
824     emit LogOrderFilled(makerAndTakerOrderHash[1], toTakerAndToMakerAmount[1], takerOrder.offerTokenRemaining_);
825     emit LogOrderExecutionSuccess();
826 
827     return true;
828   }
829 
830   /**
831    * @dev Set the fee rate for a specific quote
832    * @param _quoteToken Quote token.
833    * @param _edoPerQuote EdoPerQuote.
834    * @param _edoPerQuoteDecimals EdoPerQuoteDecimals.
835    * @return Success of the transaction.
836    */
837   function setFeeRate(
838     address _quoteToken,
839     uint256 _edoPerQuote,
840     uint256 _edoPerQuoteDecimals
841   ) external
842     returns(bool)
843   {
844     if (msg.sender != owner_) {
845       return error("msg.sender != owner, Exchange.setFeeRate()");
846     }
847 
848     if (quotePriority[_quoteToken] == 0) {
849       return error("quotePriority[_quoteToken] == 0, Exchange.setFeeRate()");
850     }
851 
852     feeEdoPerQuote[_quoteToken] = _edoPerQuote;
853     feeEdoPerQuoteDecimals[_quoteToken] = _edoPerQuoteDecimals;
854 
855     emit LogFeeRateSet(_quoteToken, _edoPerQuote, _edoPerQuoteDecimals);
856 
857     return true;
858   }
859 
860   /**
861    * @dev Set the wallet for fees to be paid to.
862    * @param eidooWallet Wallet to pay fees to.
863    * @return Success of the transaction.
864    */
865   function setEidooWallet(
866     address eidooWallet
867   ) external
868     returns(bool)
869   {
870     if (msg.sender != owner_) {
871       return error("msg.sender != owner, Exchange.setEidooWallet()");
872     }
873     eidooWallet_ = eidooWallet;
874     return true;
875   }
876 
877   /**
878    * @dev Set a new order book account.
879    * @param account The new order book account.
880    */
881   function setOrderBookAcount (
882     address account
883   ) external
884     returns(bool)
885   {
886     if (msg.sender != owner_) {
887       return error("msg.sender != owner, Exchange.setOrderBookAcount()");
888     }
889     orderBookAccount_ = account;
890     return true;
891   }
892 
893   /**
894    * @dev Set if a base must skip fee calculation.
895    * @param _baseTokenAddress The trade base token address that must skip fee calculation.
896    * @param _quoteTokenAddress The trade quote token address that must skip fee calculation.
897    * @param _mustSkipFee The trade base token address that must skip fee calculation.
898    */
899   function setMustSkipFee (
900     address _baseTokenAddress,
901     address _quoteTokenAddress,
902     bool _mustSkipFee
903   ) external
904     returns(bool)
905   {
906     // Preserving same owner check style
907     if (msg.sender != owner_) {
908       return error("msg.sender != owner, Exchange.setMustSkipFee()");
909     }
910     mustSkipFee[_baseTokenAddress][_quoteTokenAddress] = _mustSkipFee;
911     emit LogMustSkipFeeSet(_baseTokenAddress, _quoteTokenAddress, _mustSkipFee);
912     return true;
913   }
914 
915   /**
916    * @dev Set quote priority token.
917    * Set the sorting of token quote based on a priority.
918    * @param _token The address of the token that was deposited.
919    * @param _priority The amount of the token that was deposited.
920    * @return Operation success.
921    */
922 
923   function setQuotePriority(address _token, uint256 _priority)
924     external
925     returns(bool)
926   {
927     if (msg.sender != owner_) {
928       return error("msg.sender != owner, Exchange.setQuotePriority()");
929     }
930     quotePriority[_token] = _priority;
931     emit LogQuotePrioritySet(_token, _priority);
932     return true;
933   }
934 
935   /*
936    Methods to catch events from external contracts, user wallets primarily
937    */
938 
939   /**
940    * @dev Simply log the event to track wallet interaction off-chain.
941    * @param tokenAddress The address of the token that was deposited.
942    * @param amount The amount of the token that was deposited.
943    * @param tradingWalletBalance The updated balance of the wallet after deposit.
944    */
945   function walletDeposit(
946     address tokenAddress,
947     uint256 amount,
948     uint256 tradingWalletBalance
949   ) external
950   {
951     emit LogWalletDeposit(msg.sender, tokenAddress, amount, tradingWalletBalance);
952   }
953 
954   /**
955    * @dev Simply log the event to track wallet interaction off-chain.
956    * @param tokenAddress The address of the token that was deposited.
957    * @param amount The amount of the token that was deposited.
958    * @param tradingWalletBalance The updated balance of the wallet after deposit.
959    */
960   function walletWithdrawal(
961     address tokenAddress,
962     uint256 amount,
963     uint256 tradingWalletBalance
964   ) external
965   {
966     emit LogWalletWithdrawal(msg.sender, tokenAddress, amount, tradingWalletBalance);
967   }
968 
969   /**
970    * Private
971    */
972 
973   /**
974    * Calculate the fee for the given trade. Calculated as the set % of the wei amount
975    * converted into EDO tokens using the manually set conversion ratio.
976    * @param makerOrder The maker order object.
977    * @param toTakerAmount The amount of tokens going to the taker.
978    * @param toMakerAmount The amount of tokens going to the maker.
979    * @return The total fee to be paid in EDO tokens.
980    */
981   function __calculateFee__(
982     Order makerOrder,
983     uint256 toTakerAmount,
984     uint256 toMakerAmount
985   ) private
986     view
987     returns(uint256)
988   {
989     // weiAmount * (fee %) * (EDO/Wei) / (decimals in edo/wei) / (decimals in percentage)
990     if (!__isSell__(makerOrder)) {
991       // buy -> the quote is the offered token by the maker
992       return mustSkipFee[makerOrder.wantToken_][makerOrder.offerToken_]
993         ? 0
994         : toTakerAmount.mul(feeEdoPerQuote[makerOrder.offerToken_]).div(10**feeEdoPerQuoteDecimals[makerOrder.offerToken_]);
995     } else {
996       // sell -> the quote is the wanted token by the maker
997       return mustSkipFee[makerOrder.offerToken_][makerOrder.wantToken_]
998         ? 0
999         : toMakerAmount.mul(feeEdoPerQuote[makerOrder.wantToken_]).div(10**feeEdoPerQuoteDecimals[makerOrder.wantToken_]);
1000     }
1001   }
1002 
1003   /**
1004    * @dev Verify the input to order execution is valid.
1005    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
1006    * [
1007    *   makerEOA
1008    *   makerOfferToken
1009    *   takerEOA
1010    *   takerOfferToken
1011    * ]
1012    * @param amountsExpirationsAndSalts The amount of tokens and the block number at which this order expires and a random number to mitigate replay.
1013    * [
1014    *   makerOffer
1015    *   makerWant
1016    *   takerOffer
1017    *   takerWant
1018    *   makerExpiry
1019    *   makerSalt
1020    *   takerExpiry
1021    *   takerSalt
1022    * ]
1023    * @return Success if all checks pass.
1024    */
1025   function __executeOrderInputIsValid__(
1026     address[4] ownedExternalAddressesAndTokenAddresses,
1027     uint256[8] amountsExpirationsAndSalts,
1028     address makerTradingWallet,
1029     address takerTradingWallet
1030   ) private
1031     returns(bool)
1032   {
1033     // msg.send needs to be the orderBookAccount
1034     if (msg.sender != orderBookAccount_) {
1035       return error("msg.sender != orderBookAccount, Exchange.__executeOrderInputIsValid__()");
1036     }
1037 
1038     // Check expirations base on the block number
1039     if (block.number > amountsExpirationsAndSalts[4]) {
1040       return error("Maker order has expired, Exchange.__executeOrderInputIsValid__()");
1041     }
1042 
1043     if (block.number > amountsExpirationsAndSalts[6]) {
1044       return error("Taker order has expired, Exchange.__executeOrderInputIsValid__()");
1045     }
1046 
1047     // Operating on existing tradingWallets
1048     if (makerTradingWallet == address(0)) {
1049       return error("Maker wallet does not exist, Exchange.__executeOrderInputIsValid__()");
1050     }
1051 
1052     if (takerTradingWallet == address(0)) {
1053       return error("Taker wallet does not exist, Exchange.__executeOrderInputIsValid__()");
1054     }
1055 
1056     if (quotePriority[ownedExternalAddressesAndTokenAddresses[1]] == quotePriority[ownedExternalAddressesAndTokenAddresses[3]]) {
1057       return error("Quote token is omitted! Is not offered by either the Taker or Maker, Exchange.__executeOrderInputIsValid__()");
1058     }
1059 
1060     // Check that none of the amounts is = to 0
1061     if (
1062         amountsExpirationsAndSalts[0] == 0 ||
1063         amountsExpirationsAndSalts[1] == 0 ||
1064         amountsExpirationsAndSalts[2] == 0 ||
1065         amountsExpirationsAndSalts[3] == 0
1066       )
1067       return error("May not execute an order where token amount == 0, Exchange.__executeOrderInputIsValid__()");
1068 
1069     // // Confirm order ether amount >= min amount
1070     //  // Maker
1071     //  uint256 minOrderEthAmount = minOrderEthAmount_; // Single storage read
1072     //  if (_token_and_EOA_Addresses[1] == 0 && _amountsExpirationAndSalt[0] < minOrderEthAmount)
1073     //    return error('Maker order does not meet the minOrderEthAmount_ of ether, Exchange.__executeOrderInputIsValid__()');
1074 
1075     //  // Taker
1076     //  if (_token_and_EOA_Addresses[3] == 0 && _amountsExpirationAndSalt[2] < minOrderEthAmount)
1077     //    return error('Taker order does not meet the minOrderEthAmount_ of ether, Exchange.__executeOrderInputIsValid__()');
1078 
1079     return true;
1080   }
1081 
1082   /**
1083    * @dev Execute the external transfer of tokens.
1084    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
1085    * [
1086    *   makerEOA
1087    *   makerOfferToken
1088    *   takerEOA
1089    *   takerOfferToken
1090    * ]
1091    * @param toTakerAmount The amount of tokens to transfer to the taker.
1092    * @param toMakerAmount The amount of tokens to transfer to the maker.
1093    * @return Success if both wallets verify the order.
1094    */
1095   function __executeTokenTransfer__(
1096     address[4] ownedExternalAddressesAndTokenAddresses,
1097     uint256 toTakerAmount,
1098     uint256 toMakerAmount,
1099     uint256 fee,
1100     WalletV2 makerTradingWallet,
1101     WalletV2 takerTradingWallet
1102   ) private
1103     returns (bool)
1104   {
1105     // Wallet mapping balances
1106     address makerOfferTokenAddress = ownedExternalAddressesAndTokenAddresses[1];
1107     address takerOfferTokenAddress = ownedExternalAddressesAndTokenAddresses[3];
1108 
1109     // Taker to pay fee before trading
1110     if(fee != 0) {
1111       require(
1112         takerTradingWallet.updateBalance(edoToken_, fee, true),
1113         "Taker trading wallet cannot update balance with fee, Exchange.__executeTokenTransfer__()"
1114       );
1115 
1116       require(
1117         Token(edoToken_).transferFrom(takerTradingWallet, eidooWallet_, fee),
1118         "Cannot transfer fees from taker trading wallet to eidoo wallet, Exchange.__executeTokenTransfer__()"
1119       );
1120     }
1121 
1122     // Updating makerTradingWallet balance by the toTaker
1123     require(
1124       makerTradingWallet.updateBalance(makerOfferTokenAddress, toTakerAmount, true),
1125       "Maker trading wallet cannot update balance subtracting toTakerAmount, Exchange.__executeTokenTransfer__()"
1126     ); // return error("Unable to subtract maker token from maker wallet, Exchange.__executeTokenTransfer__()");
1127 
1128     // Updating takerTradingWallet balance by the toTaker
1129     require(
1130       takerTradingWallet.updateBalance(makerOfferTokenAddress, toTakerAmount, false),
1131       "Taker trading wallet cannot update balance adding toTakerAmount, Exchange.__executeTokenTransfer__()"
1132     ); // return error("Unable to add maker token to taker wallet, Exchange.__executeTokenTransfer__()");
1133 
1134     // Updating takerTradingWallet balance by the toMaker amount
1135     require(
1136       takerTradingWallet.updateBalance(takerOfferTokenAddress, toMakerAmount, true),
1137       "Taker trading wallet cannot update balance subtracting toMakerAmount, Exchange.__executeTokenTransfer__()"
1138     ); // return error("Unable to subtract taker token from taker wallet, Exchange.__executeTokenTransfer__()");
1139 
1140     // Updating makerTradingWallet balance by the toMaker amount
1141     require(
1142       makerTradingWallet.updateBalance(takerOfferTokenAddress, toMakerAmount, false),
1143       "Maker trading wallet cannot update balance adding toMakerAmount, Exchange.__executeTokenTransfer__()"
1144     ); // return error("Unable to add taker token to maker wallet, Exchange.__executeTokenTransfer__()");
1145 
1146     // Ether to the taker and tokens to the maker
1147     if (makerOfferTokenAddress == address(0)) {
1148       address(takerTradingWallet).transfer(toTakerAmount);
1149     } else {
1150       require(
1151         Token(makerOfferTokenAddress).transferFrom(makerTradingWallet, takerTradingWallet, toTakerAmount),
1152         "Token transfership from makerTradingWallet to takerTradingWallet failed, Exchange.__executeTokenTransfer__()"
1153       );
1154       assert(
1155         __tokenAndWalletBalancesMatch__(
1156           makerTradingWallet,
1157           takerTradingWallet,
1158           makerOfferTokenAddress
1159         )
1160       );
1161     }
1162 
1163     if (takerOfferTokenAddress == address(0)) {
1164       address(makerTradingWallet).transfer(toMakerAmount);
1165     } else {
1166       require(
1167         Token(takerOfferTokenAddress).transferFrom(takerTradingWallet, makerTradingWallet, toMakerAmount),
1168         "Token transfership from takerTradingWallet to makerTradingWallet failed, Exchange.__executeTokenTransfer__()"
1169       );
1170       assert(
1171         __tokenAndWalletBalancesMatch__(
1172           makerTradingWallet,
1173           takerTradingWallet,
1174           takerOfferTokenAddress
1175         )
1176       );
1177     }
1178 
1179     return true;
1180   }
1181 
1182   /**
1183    * @dev Calculates Keccak-256 hash of order with specified parameters.
1184    * @param ownedExternalAddressesAndTokenAddresses The orders maker EOA and current exchange address.
1185    * @param amountsExpirationsAndSalts The orders offer and want amounts and expirations with salts.
1186    * @return Keccak-256 hash of the passed order.
1187    */
1188 
1189   function generateOrderHashes(
1190     address[4] ownedExternalAddressesAndTokenAddresses,
1191     uint256[8] amountsExpirationsAndSalts
1192   ) public
1193     view
1194     returns (bytes32[2])
1195   {
1196     bytes32 makerOrderHash = keccak256(
1197       address(this),
1198       ownedExternalAddressesAndTokenAddresses[0], // _makerEOA
1199       ownedExternalAddressesAndTokenAddresses[1], // offerToken
1200       amountsExpirationsAndSalts[0],  // offerTokenAmount
1201       ownedExternalAddressesAndTokenAddresses[3], // wantToken
1202       amountsExpirationsAndSalts[1],  // wantTokenAmount
1203       amountsExpirationsAndSalts[4], // expiry
1204       amountsExpirationsAndSalts[5] // salt
1205     );
1206 
1207     bytes32 takerOrderHash = keccak256(
1208       address(this),
1209       ownedExternalAddressesAndTokenAddresses[2], // _makerEOA
1210       ownedExternalAddressesAndTokenAddresses[3], // offerToken
1211       amountsExpirationsAndSalts[2],  // offerTokenAmount
1212       ownedExternalAddressesAndTokenAddresses[1], // wantToken
1213       amountsExpirationsAndSalts[3],  // wantTokenAmount
1214       amountsExpirationsAndSalts[6], // expiry
1215       amountsExpirationsAndSalts[7] // salt
1216     );
1217 
1218     return [makerOrderHash, takerOrderHash];
1219   }
1220 
1221   /**
1222    * @dev Returns a bool representing a SELL or BUY order based on quotePriority.
1223    * @param _order The maker order data structure.
1224    * @return The bool indicating if the order is a SELL or BUY.
1225    */
1226   function __isSell__(Order _order) internal view returns (bool) {
1227     return quotePriority[_order.offerToken_] < quotePriority[_order.wantToken_];
1228   }
1229 
1230   /**
1231    * @dev Compute the tradeable amounts of the two verified orders.
1232    * Token amount is the __min__ remaining between want and offer of the two orders that isn"t ether.
1233    * Ether amount is then: etherAmount = tokenAmount * priceRatio, as ratio = eth / token.
1234    * @param makerOrder The maker order data structure.
1235    * @param takerOrder The taker order data structure.
1236    * @return The amount moving from makerOfferRemaining to takerWantRemaining and vice versa.
1237    */
1238   function __getTradeAmounts__(
1239     Order makerOrder,
1240     Order takerOrder
1241   ) internal
1242     view
1243     returns (uint256[2])
1244   {
1245     bool isMakerBuy = __isSell__(takerOrder);  // maker buy = taker sell
1246     uint256 priceRatio;
1247     uint256 makerAmountLeftToReceive;
1248     uint256 takerAmountLeftToReceive;
1249 
1250     uint toTakerAmount;
1251     uint toMakerAmount;
1252 
1253     if (makerOrder.offerTokenTotal_ >= makerOrder.wantTokenTotal_) {
1254       priceRatio = makerOrder.offerTokenTotal_.mul(2**128).div(makerOrder.wantTokenTotal_);
1255       if (isMakerBuy) {
1256         // MP > 1
1257         makerAmountLeftToReceive = makerOrder.wantTokenTotal_.sub(makerOrder.wantTokenReceived_);
1258         toMakerAmount = __min__(takerOrder.offerTokenRemaining_, makerAmountLeftToReceive);
1259         // add 2**128-1 in order to obtain a round up
1260         toTakerAmount = toMakerAmount.mul(priceRatio).add(2**128-1).div(2**128);
1261       } else {
1262         // MP < 1
1263         takerAmountLeftToReceive = takerOrder.wantTokenTotal_.sub(takerOrder.wantTokenReceived_);
1264         toTakerAmount = __min__(makerOrder.offerTokenRemaining_, takerAmountLeftToReceive);
1265         toMakerAmount = toTakerAmount.mul(2**128).div(priceRatio);
1266       }
1267     } else {
1268       priceRatio = makerOrder.wantTokenTotal_.mul(2**128).div(makerOrder.offerTokenTotal_);
1269       if (isMakerBuy) {
1270         // MP < 1
1271         makerAmountLeftToReceive = makerOrder.wantTokenTotal_.sub(makerOrder.wantTokenReceived_);
1272         toMakerAmount = __min__(takerOrder.offerTokenRemaining_, makerAmountLeftToReceive);
1273         toTakerAmount = toMakerAmount.mul(2**128).div(priceRatio);
1274       } else {
1275         // MP > 1
1276         takerAmountLeftToReceive = takerOrder.wantTokenTotal_.sub(takerOrder.wantTokenReceived_);
1277         toTakerAmount = __min__(makerOrder.offerTokenRemaining_, takerAmountLeftToReceive);
1278         // add 2**128-1 in order to obtain a round up
1279         toMakerAmount = toTakerAmount.mul(priceRatio).add(2**128-1).div(2**128);
1280       }
1281     }
1282     return [toTakerAmount, toMakerAmount];
1283   }
1284 
1285   /**
1286    * @dev Return the maximum of two uints
1287    * @param a Uint 1
1288    * @param b Uint 2
1289    * @return The grater value or a if equal
1290    */
1291   function __max__(uint256 a, uint256 b)
1292     private
1293     pure
1294     returns (uint256)
1295   {
1296     return a < b
1297       ? b
1298       : a;
1299   }
1300 
1301   /**
1302    * @dev Return the minimum of two uints
1303    * @param a Uint 1
1304    * @param b Uint 2
1305    * @return The smallest value or b if equal
1306    */
1307   function __min__(uint256 a, uint256 b)
1308     private
1309     pure
1310     returns (uint256)
1311   {
1312     return a < b
1313       ? a
1314       : b;
1315   }
1316 
1317   /**
1318    * @dev Confirm that the orders do match and are valid.
1319    * @param makerOrder The maker order data structure.
1320    * @param takerOrder The taker order data structure.
1321    * @return Bool if the orders passes all checks.
1322    */
1323   function __ordersMatch_and_AreVaild__(
1324     Order makerOrder,
1325     Order takerOrder
1326   ) private
1327     returns (bool)
1328   {
1329     // Confirm tokens match
1330     // NOTE potentially omit as matching handled upstream?
1331     if (makerOrder.wantToken_ != takerOrder.offerToken_) {
1332       return error("Maker wanted token does not match taker offer token, Exchange.__ordersMatch_and_AreVaild__()");
1333     }
1334 
1335     if (makerOrder.offerToken_ != takerOrder.wantToken_) {
1336       return error("Maker offer token does not match taker wanted token, Exchange.__ordersMatch_and_AreVaild__()");
1337     }
1338 
1339     // Price Ratios, to x decimal places hence * decimals, dependent on the size of the denominator.
1340     // Ratios are relative to eth, amount of ether for a single token, ie. ETH / GNO == 0.2 Ether per 1 Gnosis
1341 
1342     uint256 orderPrice;   // The price the maker is willing to accept
1343     uint256 offeredPrice; // The offer the taker has given
1344 
1345     // Ratio = larger amount / smaller amount
1346     if (makerOrder.offerTokenTotal_ >= makerOrder.wantTokenTotal_) {
1347       orderPrice = makerOrder.offerTokenTotal_.mul(2**128).div(makerOrder.wantTokenTotal_);
1348       offeredPrice = takerOrder.wantTokenTotal_.mul(2**128).div(takerOrder.offerTokenTotal_);
1349 
1350       // ie. Maker is offering 10 ETH for 100 GNO but taker is offering 100 GNO for 20 ETH, no match!
1351       // The taker wants more ether than the maker is offering.
1352       if (orderPrice < offeredPrice) {
1353         return error("Taker price is greater than maker price, Exchange.__ordersMatch_and_AreVaild__()");
1354       }
1355     } else {
1356       orderPrice = makerOrder.wantTokenTotal_.mul(2**128).div(makerOrder.offerTokenTotal_);
1357       offeredPrice = takerOrder.offerTokenTotal_.mul(2**128).div(takerOrder.wantTokenTotal_);
1358 
1359       // ie. Maker is offering 100 GNO for 10 ETH but taker is offering 5 ETH for 100 GNO, no match!
1360       // The taker is not offering enough ether for the maker
1361       if (orderPrice > offeredPrice) {
1362         return error("Taker price is less than maker price, Exchange.__ordersMatch_and_AreVaild__()");
1363       }
1364     }
1365 
1366     return true;
1367   }
1368 
1369   /**
1370    * @dev Ask each wallet to verify this order.
1371    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
1372    * [
1373    *   makerEOA
1374    *   makerOfferToken
1375    *   takerEOA
1376    *   takerOfferToken
1377    * ]
1378    * @param toMakerAmount The amount of tokens to be sent to the maker.
1379    * @param toTakerAmount The amount of tokens to be sent to the taker.
1380    * @param makerTradingWallet The maker trading wallet contract.
1381    * @param takerTradingWallet The taker trading wallet contract.
1382    * @param fee The fee to be paid for this trade, paid in full by taker.
1383    * @return Success if both wallets verify the order.
1384    */
1385   function __ordersVerifiedByWallets__(
1386     address[4] ownedExternalAddressesAndTokenAddresses,
1387     uint256 toMakerAmount,
1388     uint256 toTakerAmount,
1389     WalletV2 makerTradingWallet,
1390     WalletV2 takerTradingWallet,
1391     uint256 fee
1392   ) private
1393     returns (bool)
1394   {
1395     // Have the transaction verified by both maker and taker wallets
1396     // confirm sufficient balance to transfer, offerToken and offerTokenAmount
1397     if(!makerTradingWallet.verifyOrder(ownedExternalAddressesAndTokenAddresses[1], toTakerAmount, 0, 0)) {
1398       return error("Maker wallet could not verify the order, Exchange.____ordersVerifiedByWallets____()");
1399     }
1400 
1401     if(!takerTradingWallet.verifyOrder(ownedExternalAddressesAndTokenAddresses[3], toMakerAmount, fee, edoToken_)) {
1402       return error("Taker wallet could not verify the order, Exchange.____ordersVerifiedByWallets____()");
1403     }
1404 
1405     return true;
1406   }
1407 
1408   /**
1409    * @dev On chain verification of an ECDSA ethereum signature.
1410    * @param signer The EOA address of the account that supposedly signed the message.
1411    * @param orderHash The on-chain generated hash for the order.
1412    * @param v ECDSA signature parameter v.
1413    * @param r ECDSA signature parameter r.
1414    * @param s ECDSA signature parameter s.
1415    * @return Bool if the signature is valid or not.
1416    */
1417   function __signatureIsValid__(
1418     address signer,
1419     bytes32 orderHash,
1420     uint8 v,
1421     bytes32 r,
1422     bytes32 s
1423   ) private
1424     pure
1425     returns (bool)
1426   {
1427     address recoveredAddr = ecrecover(
1428       keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash)),
1429       v,
1430       r,
1431       s
1432     );
1433 
1434     return recoveredAddr == signer;
1435   }
1436 
1437   /**
1438    * @dev Confirm wallet local balances and token balances match.
1439    * @param makerTradingWallet  Maker wallet address.
1440    * @param takerTradingWallet  Taker wallet address.
1441    * @param token  Token address to confirm balances match.
1442    * @return If the balances do match.
1443    */
1444   function __tokenAndWalletBalancesMatch__(
1445     address makerTradingWallet,
1446     address takerTradingWallet,
1447     address token
1448   ) private
1449     view
1450     returns(bool)
1451   {
1452     if (Token(token).balanceOf(makerTradingWallet) != WalletV2(makerTradingWallet).balanceOf(token)) {
1453       return false;
1454     }
1455 
1456     if (Token(token).balanceOf(takerTradingWallet) != WalletV2(takerTradingWallet).balanceOf(token)) {
1457       return false;
1458     }
1459 
1460     return true;
1461   }
1462 
1463   /**
1464    * @dev Update the order structs.
1465    * @param makerOrder The maker order data structure.
1466    * @param takerOrder The taker order data structure.
1467    * @param toTakerAmount The amount of tokens to be moved to the taker.
1468    * @param toTakerAmount The amount of tokens to be moved to the maker.
1469    * @return Success if the update succeeds.
1470    */
1471   function __updateOrders__(
1472     Order makerOrder,
1473     Order takerOrder,
1474     uint256 toTakerAmount,
1475     uint256 toMakerAmount
1476   ) private
1477     view
1478   {
1479     // taker => maker
1480     makerOrder.wantTokenReceived_ = makerOrder.wantTokenReceived_.add(toMakerAmount);
1481     takerOrder.offerTokenRemaining_ = takerOrder.offerTokenRemaining_.sub(toMakerAmount);
1482 
1483     // maker => taker
1484     takerOrder.wantTokenReceived_ = takerOrder.wantTokenReceived_.add(toTakerAmount);
1485     makerOrder.offerTokenRemaining_ = makerOrder.offerTokenRemaining_.sub(toTakerAmount);
1486   }
1487 }