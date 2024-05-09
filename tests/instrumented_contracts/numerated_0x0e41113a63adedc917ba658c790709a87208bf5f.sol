1 // File: contracts/utils/LoggingErrors.sol
2 
3 pragma solidity ^0.4.11;
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
27     emit LogErrorString(_errorMessage);
28     return false;
29   }
30 }
31 
32 // File: contracts/wallet/WalletConnector.sol
33 
34 pragma solidity ^0.4.15;
35 
36 
37 /**
38  * @title Wallet Connector
39  * @dev Connect the wallet contract to the correct Wallet Logic version
40  */
41 contract WalletConnector is LoggingErrors {
42   /**
43    * Storage
44    */
45   address public owner_;
46   address public latestLogic_;
47   uint256 public latestVersion_;
48   mapping(uint256 => address) public logicVersions_;
49   uint256 public birthBlock_;
50 
51   /**
52    * Events
53    */
54   event LogLogicVersionAdded(uint256 version);
55   event LogLogicVersionRemoved(uint256 version);
56 
57   /**
58    * @dev Constructor to set the latest logic address
59    * @param _latestVersion Latest version of the wallet logic
60    * @param _latestLogic Latest address of the wallet logic contract
61    */
62   function WalletConnector (
63     uint256 _latestVersion,
64     address _latestLogic
65   ) public {
66     owner_ = msg.sender;
67     latestLogic_ = _latestLogic;
68     latestVersion_ = _latestVersion;
69     logicVersions_[_latestVersion] = _latestLogic;
70     birthBlock_ = block.number;
71   }
72 
73   /**
74    * Add a new version of the logic contract
75    * @param _version The version to be associated with the new contract.
76    * @param _logic New logic contract.
77    * @return Success of the transaction.
78    */
79   function addLogicVersion (
80     uint256 _version,
81     address _logic
82   ) external
83     returns(bool)
84   {
85     if (msg.sender != owner_)
86       return error('msg.sender != owner, WalletConnector.addLogicVersion()');
87 
88     if (logicVersions_[_version] != 0)
89       return error('Version already exists, WalletConnector.addLogicVersion()');
90 
91     // Update latest if this is the latest version
92     if (_version > latestVersion_) {
93       latestLogic_ = _logic;
94       latestVersion_ = _version;
95     }
96 
97     logicVersions_[_version] = _logic;
98     LogLogicVersionAdded(_version);
99 
100     return true;
101   }
102 
103   /**
104    * @dev Remove a version. Cannot remove the latest version.
105    * @param  _version The version to remove.
106    */
107   function removeLogicVersion(uint256 _version) external {
108     require(msg.sender == owner_);
109     require(_version != latestVersion_);
110     delete logicVersions_[_version];
111     LogLogicVersionRemoved(_version);
112   }
113 
114   /**
115    * Constants
116    */
117 
118   /**
119    * Called from user wallets in order to upgrade their logic.
120    * @param _version The version to upgrade to. NOTE pass in 0 to upgrade to latest.
121    * @return The address of the logic contract to upgrade to.
122    */
123   function getLogic(uint256 _version)
124     external
125     constant
126     returns(address)
127   {
128     if (_version == 0)
129       return latestLogic_;
130     else
131       return logicVersions_[_version];
132   }
133 }
134 
135 // File: contracts/token/ERC20Interface.sol
136 
137 pragma solidity ^0.4.11;
138 
139 interface Token {
140   /// @return total amount of tokens
141   function totalSupply() external constant returns (uint256 supply);
142 
143   /// @param _owner The address from which the balance will be retrieved
144   /// @return The balance
145   function balanceOf(address _owner) external constant returns (uint256 balance);
146 
147   /// @notice send `_value` token to `_to` from `msg.sender`
148   /// @param _to The address of the recipient
149   /// @param _value The amount of token to be transferred
150   /// @return Whether the transfer was successful or not
151   function transfer(address _to, uint256 _value) external returns (bool success);
152 
153   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
154   /// @param _from The address of the sender
155   /// @param _to The address of the recipient
156   /// @param _value The amount of token to be transferred
157   /// @return Whether the transfer was successful or not
158   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
159 
160   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
161   /// @param _spender The address of the account able to transfer the tokens
162   /// @param _value The amount of wei to be approved for transfer
163   /// @return Whether the approval was successful or not
164   function approve(address _spender, uint256 _value) external returns (bool success);
165 
166   /// @param _owner The address of the account owning tokens
167   /// @param _spender The address of the account able to transfer the tokens
168   /// @return Amount of remaining tokens allowed to spent
169   function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
170 
171   event Transfer(address indexed _from, address indexed _to, uint256 _value);
172   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
173 
174   function decimals() external constant returns(uint);
175   function name() external constant returns(string);
176 }
177 
178 // File: contracts/wallet/WalletV3.sol
179 
180 pragma solidity ^0.4.15;
181 
182 
183 
184 
185 /**
186  * @title Wallet to hold and trade ERC20 tokens and ether
187  * @dev User wallet to interact with the exchange.
188  * all tokens and ether held in this wallet, 1 to 1 mapping to user EOAs.
189  */
190 contract WalletV3 is LoggingErrors {
191   /**
192    * Storage
193    */
194   // Vars included in wallet logic "lib", the order must match between Wallet and Logic
195   address public owner_;
196   address public exchange_;
197   mapping(address => uint256) public tokenBalances_;
198 
199   address public logic_; // storage location 0x3 loaded for delegatecalls so this var must remain at index 3
200   uint256 public birthBlock_;
201 
202   WalletConnector private connector_;
203 
204   /**
205    * Events
206    */
207   event LogDeposit(address token, uint256 amount, uint256 balance);
208   event LogWithdrawal(address token, uint256 amount, uint256 balance);
209 
210   /**
211    * @dev Contract constructor. Set user as owner and connector address.
212    * @param _owner The address of the user's EOA, wallets created from the exchange
213    * so must past in the owner address, msg.sender == exchange.
214    * @param _connector The wallet connector to be used to retrieve the wallet logic
215    */
216   constructor(address _owner, address _connector, address _exchange) public {
217     owner_ = _owner;
218     connector_ = WalletConnector(_connector);
219     exchange_ = _exchange;
220     logic_ = connector_.latestLogic_();
221     birthBlock_ = block.number;
222   }
223 
224   function () external payable {}
225 
226   /**
227   * External
228   */
229 
230   /**
231    * @dev Deposit ether into this wallet, default to address 0 for consistent token lookup.
232    */
233   function depositEther()
234     external
235     payable
236   {
237     require(
238       logic_.delegatecall(abi.encodeWithSignature('deposit(address,uint256)', 0, msg.value)),
239       "depositEther() failed"
240     );
241   }
242 
243   /**
244    * @dev Deposit any ERC20 token into this wallet.
245    * @param _token The address of the existing token contract.
246    * @param _amount The amount of tokens to deposit.
247    * @return Bool if the deposit was successful.
248    */
249   function depositERC20Token (
250     address _token,
251     uint256 _amount
252   ) external
253     returns(bool)
254   {
255     // ether
256     if (_token == 0)
257       return error('Cannot deposit ether via depositERC20, Wallet.depositERC20Token()');
258 
259     require(
260       logic_.delegatecall(abi.encodeWithSignature('deposit(address,uint256)', _token, _amount)),
261       "depositERC20Token() failed"
262     );
263     return true;
264   }
265 
266   /**
267    * @dev The result of an order, update the balance of this wallet.
268    * param _token The address of the token balance to update.
269    * param _amount The amount to update the balance by.
270    * param _subtractionFlag If true then subtract the token amount else add.
271    * @return Bool if the update was successful.
272    */
273   function updateBalance (
274     address /*_token*/,
275     uint256 /*_amount*/,
276     bool /*_subtractionFlag*/
277   ) external
278     returns(bool)
279   {
280     assembly {
281       calldatacopy(0x40, 0, calldatasize)
282       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
283       return(0, 32)
284       pop
285     }
286   }
287 
288   /**
289    * User may update to the latest version of the exchange contract.
290    * Note that multiple versions are NOT supported at this time and therefore if a
291    * user does not wish to update they will no longer be able to use the exchange.
292    * @param _exchange The new exchange.
293    * @return Success of this transaction.
294    */
295   function updateExchange(address _exchange)
296     external
297     returns(bool)
298   {
299     if (msg.sender != owner_)
300       return error('msg.sender != owner_, Wallet.updateExchange()');
301 
302     // If subsequent messages are not sent from this address all orders will fail
303     exchange_ = _exchange;
304 
305     return true;
306   }
307 
308   /**
309    * User may update to a new or older version of the logic contract.
310    * @param _version The versin to update to.
311    * @return Success of this transaction.
312    */
313   function updateLogic(uint256 _version)
314     external
315     returns(bool)
316   {
317     if (msg.sender != owner_)
318       return error('msg.sender != owner_, Wallet.updateLogic()');
319 
320     address newVersion = connector_.getLogic(_version);
321 
322     // Invalid version as defined by connector
323     if (newVersion == 0)
324       return error('Invalid version, Wallet.updateLogic()');
325 
326     logic_ = newVersion;
327     return true;
328   }
329 
330   /**
331    * @dev Verify an order that the Exchange has received involving this wallet.
332    * Internal checks and then authorize the exchange to move the tokens.
333    * If sending ether will transfer to the exchange to broker the trade.
334    * param _token The address of the token contract being sold.
335    * param _amount The amount of tokens the order is for.
336    * param _fee The fee for the current trade.
337    * param _feeToken The token of which the fee is to be paid in.
338    * @return If the order was verified or not.
339    */
340   function verifyOrder (
341     address /*_token*/,
342     uint256 /*_amount*/,
343     uint256 /*_fee*/,
344     address /*_feeToken*/
345   ) external
346     returns(bool)
347   {
348     assembly {
349       calldatacopy(0x40, 0, calldatasize)
350       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
351       return(0, 32)
352       pop
353     }
354   }
355 
356   /**
357    * @dev Withdraw any token, including ether from this wallet to an EOA.
358    * param _token The address of the token to withdraw.
359    * param _amount The amount to withdraw.
360    * @return Success of the withdrawal.
361    */
362   function withdraw(address /*_token*/, uint256 /*_amount*/)
363     external
364     returns(bool)
365   {
366     if(msg.sender != owner_)
367       return error('msg.sender != owner, Wallet.withdraw()');
368 
369     assembly {
370       calldatacopy(0x40, 0, calldatasize)
371       delegatecall(gas, sload(0x3), 0x40, calldatasize, 0, 32)
372       return(0, 32)
373       pop
374     }
375   }
376 
377   /**
378    * Constants
379    */
380 
381   /**
382    * @dev Get the balance for a specific token.
383    * @param _token The address of the token contract to retrieve the balance of.
384    * @return The current balance within this contract.
385    */
386   function balanceOf(address _token)
387     public
388     view
389     returns(uint)
390   {
391     if (_token == address(0)) {
392       return address(this).balance;
393     } else {
394       return Token(_token).balanceOf(this);
395     }
396   }
397 
398   function walletVersion() external pure returns(uint){
399     return 3;
400   }
401 }
402 
403 // File: contracts/wallet/WalletBuilderInterface.sol
404 
405 pragma solidity ^0.4.15;
406 
407 
408 
409 /**
410  * @title Wallet to hold and trade ERC20 tokens and ether
411  */
412 interface WalletBuilderInterface {
413 
414   /**
415    * @dev build a new trading wallet and returns its address
416    * @param _owner user EOA of the created trading wallet
417    * @param _exchange exchange address
418    */
419   function buildWallet(address _owner, address _exchange) external returns(address);
420 }
421 
422 // File: contracts/utils/Ownable.sol
423 
424 pragma solidity ^0.4.24;
425 
426 contract Ownable {
427   address public owner;
428 
429   function Ownable() public {
430     owner = msg.sender;
431   }
432 
433   modifier onlyOwner() {
434     require(msg.sender == owner, "msg.sender != owner");
435     _;
436   }
437 
438   function transferOwnership(address newOwner) public onlyOwner {
439     require(newOwner != address(0), "newOwner == 0");
440     owner = newOwner;
441   }
442 
443 }
444 
445 // File: contracts/utils/SafeMath.sol
446 
447 pragma solidity ^0.4.11;
448 
449 
450 /**
451  * @title SafeMath
452  * @dev Math operations with safety checks that throw on error
453  */
454 library SafeMath {
455   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
456     uint256 c = a * b;
457     assert(a == 0 || c / a == b);
458     return c;
459   }
460 
461   function div(uint256 a, uint256 b) internal pure returns (uint256) {
462     // assert(b > 0); // Solidity automatically throws when dividing by 0
463     uint256 c = a / b;
464     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
465     return c;
466   }
467 
468   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
469     assert(b <= a);
470     return a - b;
471   }
472 
473   function add(uint256 a, uint256 b) internal pure returns (uint256) {
474     uint256 c = a + b;
475     assert(c >= a);
476     return c;
477   }
478 }
479 
480 // File: contracts/UsersManager.sol
481 
482 pragma solidity ^0.4.24;
483 
484 
485 
486 
487 
488 
489 
490 interface RetrieveWalletInterface {
491   function retrieveWallet(address userAccount) external returns(address walletAddress);
492 }
493 
494 contract UsersManager is Ownable, RetrieveWalletInterface {
495   mapping(address => address) public userAccountToWallet_; // User EOA to wallet addresses
496   WalletBuilderInterface public walletBuilder;
497   RetrieveWalletInterface public previousMapping;
498 
499   event LogUserAdded(address indexed user, address walletAddress);
500   event LogWalletUpgraded(address indexed user, address oldWalletAddress, address newWalletAddress);
501   event LogWalletBuilderChanged(address newWalletBuilder);
502 
503   constructor (
504     address _previousMappingAddress,
505     address _walletBuilder
506   ) public {
507     require(_walletBuilder != address (0), "WalletConnector address == 0");
508     previousMapping = RetrieveWalletInterface(_previousMappingAddress);
509     walletBuilder = WalletBuilderInterface(_walletBuilder);
510   }
511 
512   /**
513    * External
514    */
515 
516   /**
517    * @dev Returns the Wallet contract address associated to a user account. If the user account is not known, try to
518    * migrate the wallet address from the old exchange instance. This function is equivalent to getWallet(), in addition
519    * it stores the wallet address fetched from old the exchange instance.
520    * @param userAccount The user account address
521    * @return The address of the Wallet instance associated to the user account
522    */
523   function retrieveWallet(address userAccount)
524     public
525     returns(address walletAddress)
526   {
527     walletAddress = userAccountToWallet_[userAccount];
528     if (walletAddress == address(0) && address(previousMapping) != address(0)) {
529       // Retrieve the wallet address from the old exchange.
530       walletAddress = previousMapping.retrieveWallet(userAccount);
531 
532       if (walletAddress != address(0)) {
533         userAccountToWallet_[userAccount] = walletAddress;
534       }
535     }
536   }
537 
538   /**
539  * @dev Private implementation for addNewUser function. Add a new user
540  * into the exchange, create a wallet for them.
541  * Map their account address to the wallet contract for lookup.
542  * @param userExternalOwnedAccount The address of the user"s EOA.
543  * @param exchangeAddress The address of the exchange smart contract.
544  * @return the created trading wallet address.
545  */
546   function __addNewUser(address userExternalOwnedAccount, address exchangeAddress)
547     private
548     returns (address)
549   {
550     address userTradingWallet = walletBuilder.buildWallet(userExternalOwnedAccount, exchangeAddress);
551     userAccountToWallet_[userExternalOwnedAccount] = userTradingWallet;
552     emit LogUserAdded(userExternalOwnedAccount, userTradingWallet);
553     return userTradingWallet;
554   }
555 
556   /**
557    * @dev Add a new user to the exchange, create a wallet for them.
558    * Map their account address to the wallet contract for lookup.
559    * @param userExternalOwnedAccount The address of the user"s EOA.
560    * @return Success of the transaction, false if error condition met.
561    */
562   function addNewUser(address userExternalOwnedAccount)
563     public
564     returns (bool)
565   {
566     require (
567       retrieveWallet(userExternalOwnedAccount) == address(0),
568       "User already exists, Exchange.addNewUser()"
569     );
570 
571     // Create a new wallet passing EOA for owner and msg.sender for exchange. If the caller of this function is not the
572     // exchange, the trading wallet is not operable and requires an updateExchange()
573     __addNewUser(userExternalOwnedAccount, msg.sender);
574     return true;
575   }
576 
577   /**
578    * @dev Recreate the trading wallet for the user calling the function.
579    */
580   function upgradeWallet() external
581   {
582     address oldWallet = retrieveWallet(msg.sender);
583     require(
584       oldWallet != address(0),
585       "User does not exists yet, Exchange.upgradeWallet()"
586     );
587     address exchange = WalletV3(oldWallet).exchange_();
588     address userTradingWallet = __addNewUser(msg.sender, exchange);
589     emit LogWalletUpgraded(msg.sender, oldWallet, userTradingWallet);
590   }
591 
592   /**
593    * @dev Administratively changes the wallet address for a specific EOA.
594    */
595   function adminSetWallet(address userExternalOwnedAccount, address userTradingWallet)
596     onlyOwner
597     external
598   {
599     address oldWallet = retrieveWallet(userExternalOwnedAccount);
600     userAccountToWallet_[userExternalOwnedAccount] = userTradingWallet;
601     emit LogUserAdded(userExternalOwnedAccount, userTradingWallet);
602     if (oldWallet != address(0)) {
603       emit LogWalletUpgraded(userExternalOwnedAccount, oldWallet, userTradingWallet);
604     }
605   }
606 
607   /**
608    * @dev Add a new user to the exchange, create a wallet for them.
609    * Map their account address to the wallet contract for lookup.
610    * @param newWalletBuilder The address of the new wallet builder
611    * @return Success of the transaction, false if error condition met.
612    */
613   function setWalletBuilder(address newWalletBuilder)
614     public
615     onlyOwner
616     returns (bool)
617   {
618     require(newWalletBuilder != address(0), "setWalletBuilder(): newWalletBuilder == 0");
619     walletBuilder = WalletBuilderInterface(newWalletBuilder);
620     emit LogWalletBuilderChanged(walletBuilder);
621     return true;
622   }
623 }
624 
625 // File: contracts/utils/SafeERC20.sol
626 
627 pragma solidity ^0.4.11;
628 
629 
630 interface BadERC20 {
631   function transfer(address to, uint value) external;
632   function transferFrom(address from, address to, uint256 value) external;
633   function approve(address spender, uint value) external;
634 }
635 
636 /**
637  * @title SafeMath
638  * @dev Math operations with safety checks that throw on error
639  */
640 library SafeERC20 {
641 
642   event LogWarningNonZeroAllowance(address token, address spender, uint256 allowance);
643 
644   /**
645    * @dev Wrapping the ERC20 transfer function to avoid missing returns.
646    * @param _token The address of bad formed ERC20 token.
647    * @param _to Transfer receiver.
648    * @param _amount Amount to be transfered.
649    * @return Success of the safeTransfer.
650    */
651 
652   function safeTransfer(
653     address _token,
654     address _to,
655     uint _amount
656   )
657   internal
658   returns (bool result)
659   {
660     BadERC20(_token).transfer(_to, _amount);
661 
662     assembly {
663       switch returndatasize()
664       case 0 {                      // This is our BadToken
665         result := not(0)            // result is true
666       }
667       case 32 {                     // This is our GoodToken
668         returndatacopy(0, 0, 32)
669         result := mload(0)          // result == returndata of external call
670       }
671       default {                     // This is not an ERC20 token
672         revert(0, 0)
673       }
674     }
675   }
676 
677 
678   /**
679    * @dev Wrapping the ERC20 transferFrom function to avoid missing returns.
680    * @param _token The address of bad formed ERC20 token.
681    * @param _from Transfer sender.
682    * @param _to Transfer receiver.
683    * @param _value Amount to be transfered.
684    * @return Success of the safeTransferFrom.
685    */
686 
687   function safeTransferFrom(
688     address _token,
689     address _from,
690     address _to,
691     uint256 _value
692   )
693   internal
694   returns (bool result)
695   {
696     BadERC20(_token).transferFrom(_from, _to, _value);
697 
698     assembly {
699       switch returndatasize()
700       case 0 {                      // This is our BadToken
701         result := not(0)            // result is true
702       }
703       case 32 {                     // This is our GoodToken
704         returndatacopy(0, 0, 32)
705         result := mload(0)          // result == returndata of external call
706       }
707       default {                     // This is not an ERC20 token
708         revert(0, 0)
709       }
710     }
711   }
712 
713   function checkAndApprove(
714     address _token,
715     address _spender,
716     uint256 _value
717   )
718   internal
719   returns (bool result)
720   {
721     uint currentAllowance = Token(_token).allowance(this, _spender);
722     if (currentAllowance > 0) {
723       emit LogWarningNonZeroAllowance(_token, _spender, currentAllowance);
724       // no check required for approve because it eventually will fail in the second approve
725       safeApprove(_token, _spender, 0);
726     }
727     return safeApprove(_token, _spender, _value);
728   }
729   /**
730    * @dev Wrapping the ERC20 approve function to avoid missing returns.
731    * @param _token The address of bad formed ERC20 token.
732    * @param _spender Spender address.
733    * @param _value Amount allowed to be spent.
734    * @return Success of the safeApprove.
735    */
736 
737   function safeApprove(
738     address _token,
739     address _spender,
740     uint256 _value
741   )
742   internal
743   returns (bool result)
744   {
745     BadERC20(_token).approve(_spender, _value);
746 
747     assembly {
748       switch returndatasize()
749       case 0 {                      // This is our BadToken
750         result := not(0)            // result is true
751       }
752       case 32 {                     // This is our GoodToken
753         returndatacopy(0, 0, 32)
754         result := mload(0)          // result == returndata of external call
755       }
756       default {                     // This is not an ERC20 token
757         revert(0, 0)
758       }
759     }
760   }
761 }
762 
763 // File: contracts/ExchangeV3.sol
764 
765 pragma solidity ^0.4.24;
766 
767 
768 
769 
770 
771 
772 /**
773  * @title Decentralized exchange for ether and ERC20 tokens.
774  * @author Eidoo SAGL.
775  * @dev All trades brokered by this contract.
776  * Orders submitted by off chain order book and this contract handles
777  * verification and execution of orders.
778  * All value between parties is transferred via this exchange.
779  * Methods arranged by visibility; external, public, internal, private and alphabatized within.
780  *
781  * New Exchange SC with eventually no fee and ERC20 tokens as quote
782  */
783 contract ExchangeV3 {
784 
785   using SafeMath for uint256;
786 
787   /**
788    * Data Structures
789    */
790   struct Order {
791     address offerToken_;
792     uint256 offerTokenTotal_;
793     uint256 offerTokenRemaining_;  // Amount left to give
794     address wantToken_;
795     uint256 wantTokenTotal_;
796     uint256 wantTokenReceived_;  // Amount received, note this may exceed want total
797   }
798 
799   struct OrderStatus {
800     uint256 expirationBlock_;
801     uint256 wantTokenReceived_;    // Amount received, note this may exceed want total
802     uint256 offerTokenRemaining_;  // Amount left to give
803   }
804 
805   struct Orders {
806     Order makerOrder;
807     Order takerOrder;
808     bool isMakerBuy;
809   }
810 
811   struct FeeRate {
812     uint256 edoPerQuote;
813     uint256 edoPerQuoteDecimals;
814   }
815 
816   struct Balances {
817     uint256 makerWantTokenBalance;
818     uint256 makerOfferTokenBalance;
819     uint256 takerWantTokenBalance;
820     uint256 takerOfferTokenBalance;
821   }
822 
823   struct TradingWallets {
824     WalletV3 maker;
825     WalletV3 taker;
826   }
827 
828   struct TradingAmounts {
829     uint256 toTaker;
830     uint256 toMaker;
831     uint256 fee;
832   }
833 
834   struct OrdersHashes {
835     bytes32 makerOrder;
836     bytes32 takerOrder;
837   }
838 
839   /**
840    * Storage
841    */
842   address private orderBookAccount_;
843   address public owner_;
844   address public feeManager_;
845   uint256 public birthBlock_;
846   address public edoToken_;
847   uint256 public dustLimit = 100;
848 
849   mapping (address => uint256) public feeEdoPerQuote;
850   mapping (address => uint256) public feeEdoPerQuoteDecimals;
851 
852   address public eidooWallet_;
853 
854   // Define if fee calculation must be skipped for a given trade. By default (false) fee must not be skipped.
855   mapping(address => mapping(address => FeeRate)) public customFee;
856   // whitelist of EOA that should not pay fee
857   mapping(address => bool) public feeTakersWhitelist;
858 
859   /**
860    * @dev Define in a trade who is the quote using a priority system:
861    * values example
862    *   0: not used as quote
863    *  >0: used as quote
864    *  if wanted and offered tokens have value > 0 the quote is the token with the bigger value
865    */
866   mapping(address => uint256) public quotePriority;
867 
868   mapping(bytes32 => OrderStatus) public orders_; // Map order hashes to order data struct
869   UsersManager public users;
870 
871   /**
872    * Events
873    */
874   event LogFeeRateSet(address indexed token, uint256 rate, uint256 decimals);
875   event LogQuotePrioritySet(address indexed quoteToken, uint256 priority);
876   event LogCustomFeeSet(address indexed base, address indexed quote, uint256 edoPerQuote, uint256 edoPerQuoteDecimals);
877   event LogFeeTakersWhitelistSet(address takerEOA, bool value);
878   event LogWalletDeposit(address indexed walletAddress, address token, uint256 amount, uint256 balance);
879   event LogWalletWithdrawal(address indexed walletAddress, address token, uint256 amount, uint256 balance);
880   event LogWithdraw(address recipient, address token, uint256 amount);
881 
882   event LogOrderExecutionSuccess(
883     bytes32 indexed makerOrderId,
884     bytes32 indexed takerOrderId,
885     uint256 toMaker,
886     uint256 toTaker
887   );
888   event LogBatchOrderExecutionFailed(
889     bytes32 indexed makerOrderId,
890     bytes32 indexed takerOrderId,
891     uint256 position
892   );
893   event LogOrderFilled(bytes32 indexed orderId, uint256 totalOfferRemaining, uint256 totalWantReceived);
894 
895   /**
896    * @dev Contract constructor - CONFIRM matches contract name.  Set owner and addr of order book.
897    * @param _bookAccount The EOA address for the order book, will submit ALL orders.
898    * @param _edoToken Deployed edo token.
899    * @param _edoPerWei Rate of edo tokens per wei.
900    * @param _edoPerWeiDecimals Decimlas carried in edo rate.
901    * @param _eidooWallet Wallet to pay fees to.
902    * @param _usersMapperAddress Previous exchange smart contract address.
903    */
904   constructor (
905     address _bookAccount,
906     address _edoToken,
907     uint256 _edoPerWei,
908     uint256 _edoPerWeiDecimals,
909     address _eidooWallet,
910     address _usersMapperAddress
911   ) public {
912     orderBookAccount_ = _bookAccount;
913     owner_ = msg.sender;
914     birthBlock_ = block.number;
915     edoToken_ = _edoToken;
916     feeEdoPerQuote[address(0)] = _edoPerWei;
917     feeEdoPerQuoteDecimals[address(0)] = _edoPerWeiDecimals;
918     eidooWallet_ = _eidooWallet;
919     quotePriority[address(0)] = 10;
920     setUsersMapper(_usersMapperAddress);
921   }
922 
923   /**
924    * @dev Fallback. wallets utilize to send ether in order to broker trade.
925    */
926   function () external payable { }
927 
928   modifier onlyOwner() {
929     require (
930       msg.sender == owner_,
931       "msg.sender != owner"
932     );
933     _;
934   }
935 
936   function setUsersMapper(address _userMapperAddress)
937     public
938     onlyOwner
939     returns (bool)
940   {
941     require(_userMapperAddress != address(0), "_userMapperAddress == 0");
942     users = UsersManager(_userMapperAddress);
943     return true;
944   }
945 
946   function setFeeManager(address feeManager)
947     public
948     onlyOwner
949   {
950     feeManager_ = feeManager;
951   }
952 
953   function setDustLimit(uint limit)
954     public
955     onlyOwner
956   {
957     dustLimit = limit;
958   }
959 
960   /**
961    * @dev Add a new user to the exchange, create a wallet for them.
962    * Map their account address to the wallet contract for lookup.
963    * @param userExternalOwnedAccount The address of the user"s EOA.
964    * @return Success of the transaction, false if error condition met.
965    */
966   function addNewUser(address userExternalOwnedAccount)
967     external
968     returns (bool)
969   {
970     return users.addNewUser(userExternalOwnedAccount);
971   }
972 
973   /**
974    * @dev For backward compatibility.
975    * @param userExternalOwnedAccount The address of the user's EOA.
976    * @return The address of the trading wallet
977    */
978   function userAccountToWallet_(address userExternalOwnedAccount) external returns(address)
979   {
980     return users.retrieveWallet(userExternalOwnedAccount);
981   }
982 
983   function retrieveWallet(address userExternalOwnedAccount)
984     external
985     returns(address)
986   {
987     return users.retrieveWallet(userExternalOwnedAccount);
988   }
989 
990   /**
991    * Execute orders in batches.
992    * @param ownedExternalAddressesAndTokenAddresses Tokan and user addresses.
993    * @param amountsExpirationsAndSalts Offer and want token amount and expiration and salt values.
994    * @param vSignatures All order signature v values.
995    * @param rAndSsignatures All order signature r and r values.
996    * @return The success of this transaction.
997    */
998   function batchExecuteOrder(
999     address[4][] ownedExternalAddressesAndTokenAddresses,
1000     uint256[8][] amountsExpirationsAndSalts, // Packing to save stack size
1001     uint8[2][] vSignatures,
1002     bytes32[4][] rAndSsignatures
1003   ) external
1004     returns(bool)
1005   {
1006     require(
1007       msg.sender == orderBookAccount_,
1008       "msg.sender != orderBookAccount, Exchange.batchExecuteOrder()"
1009     );
1010 
1011     for (uint256 i = 0; i < amountsExpirationsAndSalts.length; i++) {
1012       // TODO: the following 3 lines requires solc 0.5.0
1013 //      bytes memory payload = abi.encodeWithSignature("executeOrder(address[4],uint256[8],uint8[2],bytes32[4])",
1014 //        ownedExternalAddressesAndTokenAddresses[i],
1015 //        amountsExpirationsAndSalts[i],
1016 //        vSignatures[i],
1017 //        rAndSsignatures[i]
1018 //      );
1019 //      (bool success, bytes memory returnData) = address(this).call(payload);
1020 //      if (!success || !bool(returnData)) {
1021       bool success = address(this).call(abi.encodeWithSignature("executeOrder(address[4],uint256[8],uint8[2],bytes32[4])",
1022         ownedExternalAddressesAndTokenAddresses[i],
1023         amountsExpirationsAndSalts[i],
1024         vSignatures[i],
1025         rAndSsignatures[i]
1026       ));
1027       if (!success) {
1028         OrdersHashes memory hashes = __generateOrderHashes__(
1029           ownedExternalAddressesAndTokenAddresses[i],
1030           amountsExpirationsAndSalts[i]
1031         );
1032         emit LogBatchOrderExecutionFailed(hashes.makerOrder, hashes.takerOrder, i);
1033       }
1034     }
1035 
1036     return true;
1037   }
1038 
1039   /**
1040    * @dev Execute an order that was submitted by the external order book server.
1041    * The order book server believes it to be a match.
1042    * There are components for both orders, maker and taker, 2 signatures as well.
1043    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
1044    * [
1045    *   makerEOA
1046    *   makerOfferToken
1047    *   takerEOA
1048    *   takerOfferToken
1049    * ]
1050    * @param amountsExpirationsAndSalts The amount of tokens and the block number at which this order expires and a random number to mitigate replay.
1051    * [
1052    *   makerOffer
1053    *   makerWant
1054    *   takerOffer
1055    *   takerWant
1056    *   makerExpiry
1057    *   makerSalt
1058    *   takerExpiry
1059    *   takerSalt
1060    * ]
1061    * @param vSignatures ECDSA signature parameter.
1062    * [
1063    *   maker V
1064    *   taker V
1065    * ]
1066    * @param rAndSsignatures ECDSA signature parameters r ans s, maker 0, 1 and taker 2, 3.
1067    * [
1068    *   maker R
1069    *   maker S
1070    *   taker R
1071    *   taker S
1072    * ]
1073    * @return Success of the transaction, false if error condition met.
1074    * Like types grouped to eliminate stack depth error.
1075    */
1076   function executeOrder (
1077     address[4] ownedExternalAddressesAndTokenAddresses,
1078     uint256[8] amountsExpirationsAndSalts, // Packing to save stack size
1079     uint8[2] vSignatures,
1080     bytes32[4] rAndSsignatures
1081   ) public
1082     returns(bool)
1083   {
1084     // get users trading wallets and check if they exist
1085     TradingWallets memory wallets =
1086       getMakerAndTakerTradingWallets(ownedExternalAddressesAndTokenAddresses);
1087 
1088     // Basic pre-conditions, return if any input data is invalid
1089     __executeOrderInputIsValid__(
1090       ownedExternalAddressesAndTokenAddresses,
1091       amountsExpirationsAndSalts
1092     );
1093 
1094     // Verify Maker and Taker signatures
1095     OrdersHashes memory hashes = __generateOrderHashes__(
1096       ownedExternalAddressesAndTokenAddresses,
1097       amountsExpirationsAndSalts
1098     );
1099 
1100     // Check maker order signature
1101     require(
1102       __signatureIsValid__(
1103       ownedExternalAddressesAndTokenAddresses[0],
1104         hashes.makerOrder,
1105         vSignatures[0],
1106         rAndSsignatures[0],
1107         rAndSsignatures[1]
1108       ),
1109       "Maker signature is invalid, Exchange.executeOrder()"
1110     );
1111 
1112     // Check taker order signature
1113     require(__signatureIsValid__(
1114         ownedExternalAddressesAndTokenAddresses[2],
1115         hashes.takerOrder,
1116         vSignatures[1],
1117         rAndSsignatures[2],
1118         rAndSsignatures[3]
1119       ),
1120       "Taker signature is invalid, Exchange.executeOrder()"
1121     );
1122 
1123     // Exchange Order Verification and matching
1124     Orders memory orders = __getOrders__(ownedExternalAddressesAndTokenAddresses, amountsExpirationsAndSalts, hashes);
1125 
1126     // Trade amounts and fee
1127     TradingAmounts memory amounts = __getTradeAmounts__(orders, ownedExternalAddressesAndTokenAddresses[2]);
1128 
1129     require(
1130       amounts.toTaker > 0 && amounts.toMaker > 0,
1131       "Token amount < 1, price ratio is invalid! Token value < 1, Exchange.executeOrder()"
1132     );
1133 
1134     // Update orders status
1135     orders.makerOrder.offerTokenRemaining_ = orders.makerOrder.offerTokenRemaining_.sub(amounts.toTaker);
1136     orders.makerOrder.wantTokenReceived_ = orders.makerOrder.wantTokenReceived_.add(amounts.toMaker);
1137 
1138     orders.takerOrder.offerTokenRemaining_ = orders.takerOrder.offerTokenRemaining_.sub(amounts.toMaker);
1139     orders.takerOrder.wantTokenReceived_ = orders.takerOrder.wantTokenReceived_.add(amounts.toTaker);
1140 
1141     // Write orders status to storage. If the remaining to trade in the order is below the limit,
1142     // cleanup the storage marking the order as completed.
1143     uint limit = dustLimit;
1144     if ((orders.makerOrder.offerTokenRemaining_ <= limit) ||
1145         (orders.isMakerBuy && (orders.makerOrder.wantTokenReceived_ + limit) >= orders.makerOrder.wantTokenTotal_)
1146     ) {
1147       orders_[hashes.makerOrder].offerTokenRemaining_ = 0;
1148       orders_[hashes.makerOrder].wantTokenReceived_ = 0;
1149     } else {
1150       orders_[hashes.makerOrder].offerTokenRemaining_ = orders.makerOrder.offerTokenRemaining_;
1151       orders_[hashes.makerOrder].wantTokenReceived_ = orders.makerOrder.wantTokenReceived_;
1152     }
1153 
1154     if ((orders.takerOrder.offerTokenRemaining_ <= limit) ||
1155         (!orders.isMakerBuy && (orders.takerOrder.wantTokenReceived_ + limit) >= orders.takerOrder.wantTokenTotal_)
1156     ) {
1157       orders_[hashes.takerOrder].offerTokenRemaining_ = 0;
1158       orders_[hashes.takerOrder].wantTokenReceived_ = 0;
1159     } else {
1160       orders_[hashes.takerOrder].offerTokenRemaining_ = orders.takerOrder.offerTokenRemaining_;
1161       orders_[hashes.takerOrder].wantTokenReceived_ = orders.takerOrder.wantTokenReceived_;
1162     }
1163 
1164     // Transfer the external value, ether <> tokens
1165     __executeTokenTransfer__(
1166       ownedExternalAddressesAndTokenAddresses,
1167       amounts,
1168       wallets
1169     );
1170 
1171     // Log the order id(hash), amount of offer given, amount of offer remaining
1172     emit LogOrderFilled(hashes.makerOrder, orders.makerOrder.offerTokenRemaining_, orders.makerOrder.wantTokenReceived_);
1173     emit LogOrderFilled(hashes.takerOrder, orders.takerOrder.offerTokenRemaining_, orders.takerOrder.wantTokenReceived_);
1174     emit LogOrderExecutionSuccess(hashes.makerOrder, hashes.takerOrder, amounts.toMaker, amounts.toTaker);
1175 
1176     return true;
1177   }
1178 
1179   /**
1180    * @dev Set the fee rate for a specific quote
1181    * @param _quoteToken Quote token.
1182    * @param _edoPerQuote EdoPerQuote.
1183    * @param _edoPerQuoteDecimals EdoPerQuoteDecimals.
1184    * @return Success of the transaction.
1185    */
1186   function setFeeRate(
1187     address _quoteToken,
1188     uint256 _edoPerQuote,
1189     uint256 _edoPerQuoteDecimals
1190   ) external
1191     returns(bool)
1192   {
1193     require(
1194       msg.sender == owner_ || msg.sender == feeManager_,
1195       "msg.sender != owner, Exchange.setFeeRate()"
1196     );
1197 
1198     require(
1199       quotePriority[_quoteToken] != 0,
1200       "quotePriority[_quoteToken] == 0, Exchange.setFeeRate()"
1201     );
1202 
1203     feeEdoPerQuote[_quoteToken] = _edoPerQuote;
1204     feeEdoPerQuoteDecimals[_quoteToken] = _edoPerQuoteDecimals;
1205 
1206     emit LogFeeRateSet(_quoteToken, _edoPerQuote, _edoPerQuoteDecimals);
1207 
1208     return true;
1209   }
1210 
1211   /**
1212    * @dev Set the wallet for fees to be paid to.
1213    * @param eidooWallet Wallet to pay fees to.
1214    * @return Success of the transaction.
1215    */
1216   function setEidooWallet(
1217     address eidooWallet
1218   ) external
1219     returns(bool)
1220   {
1221     require(
1222       msg.sender == owner_,
1223       "msg.sender != owner, Exchange.setEidooWallet()"
1224     );
1225     eidooWallet_ = eidooWallet;
1226     return true;
1227   }
1228 
1229   /**
1230    * @dev Set a new order book account.
1231    * @param account The new order book account.
1232    */
1233   function setOrderBookAcount (
1234     address account
1235   ) external
1236     returns(bool)
1237   {
1238     require(
1239       msg.sender == owner_,
1240       "msg.sender != owner, Exchange.setOrderBookAcount()"
1241     );
1242     orderBookAccount_ = account;
1243     return true;
1244   }
1245 
1246   /**
1247    * @dev Set custom fee for a pair. If both _edoPerQuote and _edoPerQuoteDecimals are 0 there is no custom fee.
1248    *      If _edoPerQuote is 0 and _edoPerQuoteDecimals is greater than 0 the resulting fee rate is 0 (disable fee for the pair).
1249    * @param _baseTokenAddress The trade base token address that must skip fee calculation.
1250    * @param _quoteTokenAddress The trade quote token address that must skip fee calculation.
1251    * @param _edoPerQuote Rate
1252    * @param _edoPerQuoteDecimals Rate decimals
1253    */
1254   function setCustomFee (
1255     address _baseTokenAddress,
1256     address _quoteTokenAddress,
1257     uint256 _edoPerQuote,
1258     uint256 _edoPerQuoteDecimals
1259   ) external
1260     returns(bool)
1261   {
1262     // Preserving same owner check style
1263     require(
1264       msg.sender == owner_ || msg.sender == feeManager_,
1265       "msg.sender != owner, Exchange.setCustomFee()"
1266     );
1267     if (_edoPerQuote == 0 && _edoPerQuoteDecimals == 0) {
1268       delete customFee[_baseTokenAddress][_quoteTokenAddress];
1269     } else {
1270       customFee[_baseTokenAddress][_quoteTokenAddress] = FeeRate({
1271         edoPerQuote: _edoPerQuote,
1272         edoPerQuoteDecimals: _edoPerQuoteDecimals
1273       });
1274     }
1275     emit LogCustomFeeSet(_baseTokenAddress, _quoteTokenAddress, _edoPerQuote, _edoPerQuoteDecimals);
1276     return true;
1277   }
1278 
1279   /**
1280    *  For backward compatibility
1281    */
1282   function mustSkipFee(address base, address quote) external view returns(bool) {
1283     FeeRate storage rate = customFee[base][quote];
1284     return rate.edoPerQuote == 0 && rate.edoPerQuoteDecimals != 0;
1285   }
1286 
1287   /**
1288    * @dev Set a taker EOA in the fees whitelist
1289    * @param _takerEOA EOA address of the taker
1290    * @param _value true if the take should not pay fees
1291    *
1292    */
1293   function setFeeTakersWhitelist(
1294     address _takerEOA,
1295     bool _value
1296   ) external
1297     returns(bool)
1298   {
1299     require(
1300       msg.sender == owner_,
1301       "msg.sender != owner, Exchange.setFeeTakersWhitelist()"
1302     );
1303     feeTakersWhitelist[_takerEOA] = _value;
1304     emit LogFeeTakersWhitelistSet(_takerEOA, _value);
1305     return true;
1306   }
1307 
1308   /**
1309    * @dev Set quote priority token.
1310    * Set the sorting of token quote based on a priority.
1311    * @param _token The address of the token that was deposited.
1312    * @param _priority The amount of the token that was deposited.
1313    * @return Operation success.
1314    */
1315 
1316   function setQuotePriority(address _token, uint256 _priority)
1317     external
1318     returns(bool)
1319   {
1320     require(
1321       msg.sender == owner_,
1322       "msg.sender != owner, Exchange.setQuotePriority()"
1323     );
1324     quotePriority[_token] = _priority;
1325     emit LogQuotePrioritySet(_token, _priority);
1326     return true;
1327   }
1328 
1329   /*
1330    Methods to catch events from external contracts, user wallets primarily
1331    */
1332 
1333   /**
1334    * @dev DEPRECATED!
1335    * Simply log the event to track wallet interaction off-chain.
1336    * @param tokenAddress The address of the token that was deposited.
1337    * @param amount The amount of the token that was deposited.
1338    * @param tradingWalletBalance The updated balance of the wallet after deposit.
1339    */
1340   function walletDeposit(
1341     address tokenAddress,
1342     uint256 amount,
1343     uint256 tradingWalletBalance
1344   ) external
1345   {
1346     emit LogWalletDeposit(msg.sender, tokenAddress, amount, tradingWalletBalance);
1347   }
1348 
1349   /**
1350    * @dev DEPRECATED!
1351    * Simply log the event to track wallet interaction off-chain.
1352    * @param tokenAddress The address of the token that was deposited.
1353    * @param amount The amount of the token that was deposited.
1354    * @param tradingWalletBalance The updated balance of the wallet after deposit.
1355    */
1356   function walletWithdrawal(
1357     address tokenAddress,
1358     uint256 amount,
1359     uint256 tradingWalletBalance
1360   ) external
1361   {
1362     emit LogWalletWithdrawal(msg.sender, tokenAddress, amount, tradingWalletBalance);
1363   }
1364 
1365   /**
1366    * Private
1367    */
1368 
1369   /**
1370    * @dev Convenient function to resolve call stack size error in ExchangeV3
1371    * @param ownedExternalAddressesAndTokenAddresses -
1372    */
1373   function getMakerAndTakerTradingWallets(address[4] ownedExternalAddressesAndTokenAddresses)
1374     private
1375     returns (TradingWallets wallets)
1376   {
1377     wallets = TradingWallets(
1378       WalletV3(users.retrieveWallet(ownedExternalAddressesAndTokenAddresses[0])), // maker
1379       WalletV3(users.retrieveWallet(ownedExternalAddressesAndTokenAddresses[2])) // taker
1380     );
1381 
1382     // Operating on existing tradingWallets
1383     require(
1384       wallets.maker != address(0),
1385       "Maker wallet does not exist, Exchange.getMakerAndTakerTradingWallets()"
1386     );
1387 
1388     require(
1389       wallets.taker != address(0),
1390       "Taker wallet does not exist, Exchange.getMakerAndTakerTradingWallets()"
1391     );
1392   }
1393 
1394   function calculateFee(
1395     address base,
1396     address quote,
1397     uint256 quoteAmount,
1398     address takerEOA
1399   ) public
1400     view
1401     returns(uint256)
1402   {
1403     require(quotePriority[quote] > quotePriority[base], "Invalid pair");
1404     return __calculateFee__(base, quote, quoteAmount, takerEOA);
1405   }
1406 
1407   function __calculateFee__(
1408     address base,
1409     address quote,
1410     uint256 quoteAmount,
1411     address takerEOA
1412   )
1413     internal view returns(uint256)
1414   {
1415     FeeRate memory fee;
1416     if (feeTakersWhitelist[takerEOA]) {
1417       return 0;
1418     }
1419 
1420     // weiAmount * (fee %) * (EDO/Wei) / (decimals in edo/wei) / (decimals in percentage)
1421       fee = customFee[base][quote];
1422       if (fee.edoPerQuote == 0 && fee.edoPerQuoteDecimals == 0) {
1423         // no custom fee
1424         fee.edoPerQuote = feeEdoPerQuote[quote];
1425         fee.edoPerQuoteDecimals = feeEdoPerQuoteDecimals[quote];
1426       }
1427       return quoteAmount.mul(fee.edoPerQuote).div(10**fee.edoPerQuoteDecimals);
1428   }
1429 
1430   /**
1431    * @dev Verify the input to order execution is valid.
1432    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
1433    * [
1434    *   makerEOA
1435    *   makerOfferToken
1436    *   takerEOA
1437    *   takerOfferToken
1438    * ]
1439    * @param amountsExpirationsAndSalts The amount of tokens and the block number at which this order expires and a random number to mitigate replay.
1440    * [
1441    *   makerOffer
1442    *   makerWant
1443    *   takerOffer
1444    *   takerWant
1445    *   makerExpiry
1446    *   makerSalt
1447    *   takerExpiry
1448    *   takerSalt
1449    * ]
1450    * @return Success if all checks pass.
1451    */
1452   function __executeOrderInputIsValid__(
1453     address[4] ownedExternalAddressesAndTokenAddresses,
1454     uint256[8] amountsExpirationsAndSalts
1455   ) private view
1456   {
1457     // msg.send needs to be the orderBookAccount
1458     require(
1459       msg.sender == orderBookAccount_ || msg.sender == address(this),
1460       "msg.sender != orderBookAccount, Exchange.__executeOrderInputIsValid__()"
1461     );
1462 
1463     // Check expirations base on the block number
1464     require (
1465       block.number <= amountsExpirationsAndSalts[4],
1466       "Maker order has expired, Exchange.__executeOrderInputIsValid__()"
1467     );
1468 
1469     require(
1470       block.number <= amountsExpirationsAndSalts[6],
1471       "Taker order has expired, Exchange.__executeOrderInputIsValid__()"
1472     );
1473 
1474     require(
1475       quotePriority[ownedExternalAddressesAndTokenAddresses[1]] != quotePriority[ownedExternalAddressesAndTokenAddresses[3]],
1476       "Quote token is omitted! Is not offered by either the Taker or Maker, Exchange.__executeOrderInputIsValid__()"
1477     );
1478 
1479     // Check that none of the amounts is = to 0
1480     if (
1481         amountsExpirationsAndSalts[0] == 0 ||
1482         amountsExpirationsAndSalts[1] == 0 ||
1483         amountsExpirationsAndSalts[2] == 0 ||
1484         amountsExpirationsAndSalts[3] == 0
1485       )
1486     {
1487       revert("May not execute an order where token amount == 0, Exchange.__executeOrderInputIsValid__()");
1488     }
1489   }
1490 
1491   function __getBalance__(address token, address owner) private view returns(uint256) {
1492     if (token == address(0)) {
1493       return owner.balance;
1494     } else {
1495       return Token(token).balanceOf(owner);
1496     }
1497   }
1498 
1499   /**
1500    * @dev Execute the external transfer of tokens.
1501    * @param ownedExternalAddressesAndTokenAddresses The maker and taker external owned accounts addresses and offered tokens contracts.
1502    * [
1503    *   makerEOA
1504    *   makerOfferToken
1505    *   takerEOA
1506    *   takerOfferToken
1507    * ]
1508    * @param amounts The amount of tokens to transfer.
1509    * @return Success if both wallets verify the order.
1510    */
1511   function __executeTokenTransfer__(
1512     address[4] ownedExternalAddressesAndTokenAddresses,
1513     TradingAmounts amounts,
1514     TradingWallets wallets
1515   ) private
1516   {
1517 
1518     // Get balances. Must be taken before trading wallet verifyOrder() call because it can transfer ethers
1519     Balances memory initialBalances;
1520     initialBalances.takerOfferTokenBalance = __getBalance__(ownedExternalAddressesAndTokenAddresses[3], wallets.taker);
1521     initialBalances.makerOfferTokenBalance = __getBalance__(ownedExternalAddressesAndTokenAddresses[1], wallets.maker);
1522     initialBalances.takerWantTokenBalance = __getBalance__(ownedExternalAddressesAndTokenAddresses[1], wallets.taker);
1523     initialBalances.makerWantTokenBalance = __getBalance__(ownedExternalAddressesAndTokenAddresses[3], wallets.maker);
1524     //    initialBalances.takerFeeTokenBalance = __getBalance__(edoToken_, wallets.taker);
1525 
1526 
1527     // Wallet Order Verification, reach out to the maker and taker wallets. Approve the tokens and transfer ethers
1528     // to the exchange contract
1529     require(
1530       wallets.maker.verifyOrder(
1531         ownedExternalAddressesAndTokenAddresses[1],
1532         amounts.toTaker,
1533         0,
1534         0
1535       ),
1536       "Maker wallet could not prepare the transfer, Exchange.__executeTokenTransfer__()"
1537     );
1538 
1539     require(
1540       wallets.taker.verifyOrder(
1541         ownedExternalAddressesAndTokenAddresses[3],
1542         amounts.toMaker,
1543         amounts.fee,
1544         edoToken_
1545       ),
1546       "Taker wallet could not prepare the transfer, Exchange.__executeTokenTransfer__()"
1547     );
1548 
1549     // Wallet mapping balances
1550     address makerOfferTokenAddress = ownedExternalAddressesAndTokenAddresses[1];
1551     address takerOfferTokenAddress = ownedExternalAddressesAndTokenAddresses[3];
1552 
1553     WalletV3 makerTradingWallet = wallets.maker;
1554     WalletV3 takerTradingWallet = wallets.taker;
1555 
1556     // Taker to pay fee before trading
1557     if(amounts.fee != 0) {
1558       uint256 takerInitialFeeTokenBalance = Token(edoToken_).balanceOf(takerTradingWallet);
1559 
1560       require(
1561         Token(edoToken_).transferFrom(takerTradingWallet, eidooWallet_, amounts.fee),
1562         "Cannot transfer fees from taker trading wallet to eidoo wallet, Exchange.__executeTokenTransfer__()"
1563       );
1564       require(
1565         Token(edoToken_).balanceOf(takerTradingWallet) == takerInitialFeeTokenBalance.sub(amounts.fee),
1566         "Wrong fee token balance after transfer, Exchange.__executeTokenTransfer__()"
1567       );
1568     }
1569 
1570     // Ether to the taker and tokens to the maker
1571     if (makerOfferTokenAddress == address(0)) {
1572       address(takerTradingWallet).transfer(amounts.toTaker);
1573     } else {
1574       require(
1575         SafeERC20.safeTransferFrom(makerOfferTokenAddress, makerTradingWallet, takerTradingWallet, amounts.toTaker),
1576         "Token transfership from makerTradingWallet to takerTradingWallet failed, Exchange.__executeTokenTransfer__()"
1577       );
1578     }
1579 
1580     if (takerOfferTokenAddress == address(0)) {
1581       address(makerTradingWallet).transfer(amounts.toMaker);
1582     } else {
1583       require(
1584         SafeERC20.safeTransferFrom(takerOfferTokenAddress, takerTradingWallet, makerTradingWallet, amounts.toMaker),
1585         "Token transfership from takerTradingWallet to makerTradingWallet failed, Exchange.__executeTokenTransfer__()"
1586       );
1587     }
1588 
1589     // Check balances
1590     Balances memory expected;
1591     if (takerTradingWallet != makerTradingWallet) {
1592       expected.makerWantTokenBalance = initialBalances.makerWantTokenBalance.add(amounts.toMaker);
1593       expected.makerOfferTokenBalance = initialBalances.makerOfferTokenBalance.sub(amounts.toTaker);
1594       expected.takerWantTokenBalance = edoToken_ == makerOfferTokenAddress
1595         ? initialBalances.takerWantTokenBalance.add(amounts.toTaker).sub(amounts.fee)
1596         : initialBalances.takerWantTokenBalance.add(amounts.toTaker);
1597       expected.takerOfferTokenBalance = edoToken_ == takerOfferTokenAddress
1598         ? initialBalances.takerOfferTokenBalance.sub(amounts.toMaker).sub(amounts.fee)
1599         : initialBalances.takerOfferTokenBalance.sub(amounts.toMaker);
1600     } else {
1601       expected.makerWantTokenBalance = expected.takerOfferTokenBalance =
1602         edoToken_ == takerOfferTokenAddress
1603         ? initialBalances.takerOfferTokenBalance.sub(amounts.fee)
1604         : initialBalances.takerOfferTokenBalance;
1605       expected.makerOfferTokenBalance = expected.takerWantTokenBalance =
1606         edoToken_ == makerOfferTokenAddress
1607         ? initialBalances.takerWantTokenBalance.sub(amounts.fee)
1608         : initialBalances.takerWantTokenBalance;
1609     }
1610 
1611     require(
1612       expected.takerOfferTokenBalance == __getBalance__(takerOfferTokenAddress, takerTradingWallet),
1613       "Wrong taker offer token balance after transfer, Exchange.__executeTokenTransfer__()"
1614     );
1615     require(
1616       expected.makerOfferTokenBalance == __getBalance__(makerOfferTokenAddress, makerTradingWallet),
1617       "Wrong maker offer token balance after transfer, Exchange.__executeTokenTransfer__()"
1618     );
1619     require(
1620       expected.takerWantTokenBalance == __getBalance__(makerOfferTokenAddress, takerTradingWallet),
1621       "Wrong taker want token balance after transfer, Exchange.__executeTokenTransfer__()"
1622     );
1623     require(
1624       expected.makerWantTokenBalance == __getBalance__(takerOfferTokenAddress, makerTradingWallet),
1625       "Wrong maker want token balance after transfer, Exchange.__executeTokenTransfer__()"
1626     );
1627   }
1628 
1629   /**
1630    * @dev Calculates Keccak-256 hash of order with specified parameters.
1631    * @param ownedExternalAddressesAndTokenAddresses The orders maker EOA and current exchange address.
1632    * @param amountsExpirationsAndSalts The orders offer and want amounts and expirations with salts.
1633    * @return Keccak-256 hash of the passed order.
1634    */
1635   function generateOrderHashes(
1636     address[4] ownedExternalAddressesAndTokenAddresses,
1637     uint256[8] amountsExpirationsAndSalts
1638   ) public
1639     view
1640     returns (bytes32[2])
1641   {
1642     OrdersHashes memory hashes = __generateOrderHashes__(
1643       ownedExternalAddressesAndTokenAddresses,
1644       amountsExpirationsAndSalts
1645     );
1646     return [hashes.makerOrder, hashes.takerOrder];
1647   }
1648 
1649   function __generateOrderHashes__(
1650     address[4] ownedExternalAddressesAndTokenAddresses,
1651     uint256[8] amountsExpirationsAndSalts
1652   ) internal
1653     view
1654     returns (OrdersHashes)
1655   {
1656     bytes32 makerOrderHash = keccak256(abi.encodePacked(
1657       address(this),
1658       ownedExternalAddressesAndTokenAddresses[0], // _makerEOA
1659       ownedExternalAddressesAndTokenAddresses[1], // offerToken
1660       amountsExpirationsAndSalts[0],  // offerTokenAmount
1661       ownedExternalAddressesAndTokenAddresses[3], // wantToken
1662       amountsExpirationsAndSalts[1],  // wantTokenAmount
1663       amountsExpirationsAndSalts[4], // expiry
1664       amountsExpirationsAndSalts[5] // salt
1665     ));
1666 
1667     bytes32 takerOrderHash = keccak256(abi.encodePacked(
1668       address(this),
1669       ownedExternalAddressesAndTokenAddresses[2], // _makerEOA
1670       ownedExternalAddressesAndTokenAddresses[3], // offerToken
1671       amountsExpirationsAndSalts[2],  // offerTokenAmount
1672       ownedExternalAddressesAndTokenAddresses[1], // wantToken
1673       amountsExpirationsAndSalts[3],  // wantTokenAmount
1674       amountsExpirationsAndSalts[6], // expiry
1675       amountsExpirationsAndSalts[7] // salt
1676     ));
1677 
1678     return OrdersHashes(makerOrderHash, takerOrderHash);
1679   }
1680 
1681   function __getOrders__(
1682     address[4] ownedExternalAddressesAndTokenAddresses,
1683     uint256[8] amountsExpirationsAndSalts,
1684     OrdersHashes hashes
1685   ) private
1686     returns(Orders orders)
1687   {
1688     OrderStatus storage makerOrderStatus = orders_[hashes.makerOrder];
1689     OrderStatus storage takerOrderStatus = orders_[hashes.takerOrder];
1690 
1691     orders.makerOrder.offerToken_ = ownedExternalAddressesAndTokenAddresses[1];
1692     orders.makerOrder.offerTokenTotal_ = amountsExpirationsAndSalts[0];
1693     orders.makerOrder.wantToken_ = ownedExternalAddressesAndTokenAddresses[3];
1694     orders.makerOrder.wantTokenTotal_ = amountsExpirationsAndSalts[1];
1695 
1696     if (makerOrderStatus.expirationBlock_ > 0) {  // Check for existence
1697       // Orders still active
1698       require(
1699         makerOrderStatus.offerTokenRemaining_ != 0,
1700         "Maker order is inactive, Exchange.executeOrder()"
1701       );
1702       orders.makerOrder.offerTokenRemaining_ = makerOrderStatus.offerTokenRemaining_; // Amount to give
1703       orders.makerOrder.wantTokenReceived_ = makerOrderStatus.wantTokenReceived_; // Amount received
1704     } else {
1705       makerOrderStatus.expirationBlock_ = amountsExpirationsAndSalts[4]; // maker order expiration block, persist order on storage
1706       orders.makerOrder.offerTokenRemaining_ = amountsExpirationsAndSalts[0]; // Amount to give
1707       orders.makerOrder.wantTokenReceived_ = 0; // Amount received
1708     }
1709 
1710     orders.takerOrder.offerToken_ = ownedExternalAddressesAndTokenAddresses[3];
1711     orders.takerOrder.offerTokenTotal_ = amountsExpirationsAndSalts[2];
1712     orders.takerOrder.wantToken_ = ownedExternalAddressesAndTokenAddresses[1];
1713     orders.takerOrder.wantTokenTotal_ = amountsExpirationsAndSalts[3];
1714 
1715     if (takerOrderStatus.expirationBlock_ > 0) {  // Check for existence
1716       require(
1717         takerOrderStatus.offerTokenRemaining_ != 0,
1718         "Taker order is inactive, Exchange.executeOrder()"
1719       );
1720       orders.takerOrder.offerTokenRemaining_ = takerOrderStatus.offerTokenRemaining_;  // Amount to give
1721       orders.takerOrder.wantTokenReceived_ = takerOrderStatus.wantTokenReceived_; // Amount received
1722     } else {
1723       takerOrderStatus.expirationBlock_ = amountsExpirationsAndSalts[6]; // taker order expiration block, persist order on storage
1724       orders.takerOrder.offerTokenRemaining_ = amountsExpirationsAndSalts[2];  // Amount to give
1725       orders.takerOrder.wantTokenReceived_ = 0; // Amount received
1726     }
1727 
1728     orders.isMakerBuy = __isSell__(orders.takerOrder);
1729   }
1730 
1731   /**
1732    * @dev Returns a bool representing a SELL or BUY order based on quotePriority.
1733    * @param _order The maker order data structure.
1734    * @return The bool indicating if the order is a SELL or BUY.
1735    */
1736   function __isSell__(Order _order) internal view returns (bool) {
1737     return quotePriority[_order.offerToken_] < quotePriority[_order.wantToken_];
1738   }
1739 
1740   /**
1741    * @dev Compute the tradeable amounts of the two verified orders.
1742    * Token amount is the __min__ remaining between want and offer of the two orders that isn"t ether.
1743    * Ether amount is then: etherAmount = tokenAmount * priceRatio, as ratio = eth / token.
1744    * @param orders The maker and taker orders data structure.
1745    * @return The amount moving from makerOfferRemaining to takerWantRemaining and vice versa.
1746    */
1747   function __getTradeAmounts__(
1748     Orders memory orders,
1749     address takerEOA
1750   ) internal
1751     view
1752     returns (TradingAmounts)
1753   {
1754     Order memory makerOrder = orders.makerOrder;
1755     Order memory takerOrder = orders.takerOrder;
1756     bool isMakerBuy = orders.isMakerBuy;  // maker buy = taker sell
1757     uint256 priceRatio;
1758     uint256 makerAmountLeftToReceive;
1759     uint256 takerAmountLeftToReceive;
1760 
1761     uint toTakerAmount;
1762     uint toMakerAmount;
1763 
1764     if (makerOrder.offerTokenTotal_ >= makerOrder.wantTokenTotal_) {
1765       priceRatio = makerOrder.offerTokenTotal_.mul(2**128).div(makerOrder.wantTokenTotal_);
1766       require(
1767         priceRatio >= takerOrder.wantTokenTotal_.mul(2**128).div(takerOrder.offerTokenTotal_),
1768         "Taker price is greater than maker price, Exchange.__getTradeAmounts__()"
1769       );
1770       if (isMakerBuy) {
1771         // MP > 1
1772         makerAmountLeftToReceive = makerOrder.wantTokenTotal_.sub(makerOrder.wantTokenReceived_);
1773         toMakerAmount = __min__(takerOrder.offerTokenRemaining_, makerAmountLeftToReceive);
1774         // add 2**128-1 in order to obtain a round up
1775         toTakerAmount = toMakerAmount.mul(priceRatio).div(2**128);
1776       } else {
1777         // MP < 1
1778         takerAmountLeftToReceive = takerOrder.wantTokenTotal_.sub(takerOrder.wantTokenReceived_);
1779         toTakerAmount = __min__(makerOrder.offerTokenRemaining_, takerAmountLeftToReceive);
1780         toMakerAmount = toTakerAmount.mul(2**128).div(priceRatio);
1781       }
1782     } else {
1783       priceRatio = makerOrder.wantTokenTotal_.mul(2**128).div(makerOrder.offerTokenTotal_);
1784       require(
1785         priceRatio <= takerOrder.offerTokenTotal_.mul(2**128).div(takerOrder.wantTokenTotal_),
1786         "Taker price is less than maker price, Exchange.__getTradeAmounts__()"
1787       );
1788       if (isMakerBuy) {
1789         // MP < 1
1790         makerAmountLeftToReceive = makerOrder.wantTokenTotal_.sub(makerOrder.wantTokenReceived_);
1791         toMakerAmount = __min__(takerOrder.offerTokenRemaining_, makerAmountLeftToReceive);
1792         toTakerAmount = toMakerAmount.mul(2**128).div(priceRatio);
1793       } else {
1794         // MP > 1
1795         takerAmountLeftToReceive = takerOrder.wantTokenTotal_.sub(takerOrder.wantTokenReceived_);
1796         toTakerAmount = __min__(makerOrder.offerTokenRemaining_, takerAmountLeftToReceive);
1797         // add 2**128-1 in order to obtain a round up
1798         toMakerAmount = toTakerAmount.mul(priceRatio).div(2**128);
1799       }
1800     }
1801 
1802     uint fee = isMakerBuy
1803       ? __calculateFee__(makerOrder.wantToken_, makerOrder.offerToken_, toTakerAmount, takerEOA)
1804       : __calculateFee__(makerOrder.offerToken_, makerOrder.wantToken_, toMakerAmount, takerEOA);
1805 
1806     return TradingAmounts(toTakerAmount, toMakerAmount, fee);
1807   }
1808 
1809   /**
1810    * @dev Return the maximum of two uints
1811    * @param a Uint 1
1812    * @param b Uint 2
1813    * @return The grater value or a if equal
1814    */
1815   function __max__(uint256 a, uint256 b)
1816     private
1817     pure
1818     returns (uint256)
1819   {
1820     return a < b
1821       ? b
1822       : a;
1823   }
1824 
1825   /**
1826    * @dev Return the minimum of two uints
1827    * @param a Uint 1
1828    * @param b Uint 2
1829    * @return The smallest value or b if equal
1830    */
1831   function __min__(uint256 a, uint256 b)
1832     private
1833     pure
1834     returns (uint256)
1835   {
1836     return a < b
1837       ? a
1838       : b;
1839   }
1840 
1841   /**
1842    * @dev On chain verification of an ECDSA ethereum signature.
1843    * @param signer The EOA address of the account that supposedly signed the message.
1844    * @param orderHash The on-chain generated hash for the order.
1845    * @param v ECDSA signature parameter v.
1846    * @param r ECDSA signature parameter r.
1847    * @param s ECDSA signature parameter s.
1848    * @return Bool if the signature is valid or not.
1849    */
1850   function __signatureIsValid__(
1851     address signer,
1852     bytes32 orderHash,
1853     uint8 v,
1854     bytes32 r,
1855     bytes32 s
1856   ) private
1857     pure
1858     returns (bool)
1859   {
1860     address recoveredAddr = ecrecover(
1861       keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash)),
1862       v,
1863       r,
1864       s
1865     );
1866 
1867     return recoveredAddr == signer;
1868   }
1869 
1870   /**
1871    * @dev Confirm wallet local balances and token balances match.
1872    * @param makerTradingWallet  Maker wallet address.
1873    * @param takerTradingWallet  Taker wallet address.
1874    * @param token  Token address to confirm balances match.
1875    * @return If the balances do match.
1876    */
1877   function __tokenAndWalletBalancesMatch__(
1878     address makerTradingWallet,
1879     address takerTradingWallet,
1880     address token
1881   ) private
1882     view
1883     returns(bool)
1884   {
1885     if (Token(token).balanceOf(makerTradingWallet) != WalletV3(makerTradingWallet).balanceOf(token)) {
1886       return false;
1887     }
1888 
1889     if (Token(token).balanceOf(takerTradingWallet) != WalletV3(takerTradingWallet).balanceOf(token)) {
1890       return false;
1891     }
1892 
1893     return true;
1894   }
1895 
1896   /**
1897  * @dev Withdraw asset.
1898  * @param _tokenAddress Asset to be withdrawed.
1899  * @return bool.
1900  */
1901   function withdraw(address _tokenAddress)
1902     public
1903     onlyOwner
1904   returns(bool)
1905   {
1906     uint tokenBalance;
1907     if (_tokenAddress == address(0)) {
1908       tokenBalance = address(this).balance;
1909       msg.sender.transfer(tokenBalance);
1910     } else {
1911       tokenBalance = Token(_tokenAddress).balanceOf(address(this));
1912       require(
1913         Token(_tokenAddress).transfer(msg.sender, tokenBalance),
1914         "withdraw transfer failed"
1915       );
1916     }
1917     emit LogWithdraw(msg.sender, _tokenAddress, tokenBalance);
1918     return true;
1919   }
1920 
1921 }