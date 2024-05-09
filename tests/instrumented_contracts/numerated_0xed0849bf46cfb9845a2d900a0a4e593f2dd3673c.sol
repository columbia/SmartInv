1 pragma solidity 0.4.25;
2 
3 // File: contracts/saga/interfaces/IPaymentHandler.sol
4 
5 /**
6  * @title Payment Handler Interface.
7  */
8 interface IPaymentHandler {
9     /**
10      * @dev Get the amount of available ETH.
11      * @return The amount of available ETH.
12      */
13     function getEthBalance() external view returns (uint256);
14 
15     /**
16      * @dev Transfer ETH to an SGA holder.
17      * @param _to The address of the SGA holder.
18      * @param _value The amount of ETH to transfer.
19      */
20     function transferEthToSgaHolder(address _to, uint256 _value) external;
21 }
22 
23 // File: contracts/saga/interfaces/IMintListener.sol
24 
25 /**
26  * @title Mint Listener Interface.
27  */
28 interface IMintListener {
29     /**
30      * @dev Mint SGA for SGN holders.
31      * @param _value The amount of SGA to mint.
32      */
33     function mintSgaForSgnHolders(uint256 _value) external;
34 }
35 
36 // File: contracts/saga/interfaces/ISGATokenManager.sol
37 
38 /**
39  * @title SGA Token Manager Interface.
40  */
41 interface ISGATokenManager {
42     /**
43      * @dev Exchange ETH for SGA.
44      * @param _sender The address of the sender.
45      * @param _ethAmount The amount of ETH received.
46      * @return The amount of SGA that the sender is entitled to.
47      */
48     function exchangeEthForSga(address _sender, uint256 _ethAmount) external returns (uint256);
49 
50     /**
51      * @dev Exchange SGA for ETH.
52      * @param _sender The address of the sender.
53      * @param _sgaAmount The amount of SGA received.
54      * @return The amount of ETH that the sender is entitled to.
55      */
56     function exchangeSgaForEth(address _sender, uint256 _sgaAmount) external returns (uint256);
57 
58     /**
59      * @dev Handle direct SGA transfer.
60      * @param _sender The address of the sender.
61      * @param _to The address of the destination account.
62      * @param _value The amount of SGA to be transferred.
63      */
64     function uponTransfer(address _sender, address _to, uint256 _value) external;
65 
66     /**
67      * @dev Handle custodian SGA transfer.
68      * @param _sender The address of the sender.
69      * @param _from The address of the source account.
70      * @param _to The address of the destination account.
71      * @param _value The amount of SGA to be transferred.
72      */
73     function uponTransferFrom(address _sender, address _from, address _to, uint256 _value) external;
74 
75     /**
76      * @dev Handle the operation of ETH deposit into the SGAToken contract.
77      * @param _sender The address of the account which has issued the operation.
78      * @param _balance The amount of ETH in the SGAToken contract.
79      * @param _amount The deposited ETH amount.
80      * @return The address of the reserve-wallet and the deficient amount of ETH in the SGAToken contract.
81      */
82     function uponDeposit(address _sender, uint256 _balance, uint256 _amount) external returns (address, uint256);
83 
84     /**
85      * @dev Handle the operation of ETH withdrawal from the SGAToken contract.
86      * @param _sender The address of the account which has issued the operation.
87      * @param _balance The amount of ETH in the SGAToken contract prior the withdrawal.
88      * @return The address of the reserve-wallet and the excessive amount of ETH in the SGAToken contract.
89      */
90     function uponWithdraw(address _sender, uint256 _balance) external returns (address, uint256);
91 
92     /** 
93      * @dev Upon SGA mint for SGN holders.
94      * @param _value The amount of SGA to mint.
95      */
96     function uponMintSgaForSgnHolders(uint256 _value) external;
97 
98     /**
99      * @dev Upon SGA transfer to an SGN holder.
100      * @param _to The address of the SGN holder.
101      * @param _value The amount of SGA to transfer.
102      */
103     function uponTransferSgaToSgnHolder(address _to, uint256 _value) external;
104 
105     /**
106      * @dev Upon ETH transfer to an SGA holder.
107      * @param _to The address of the SGA holder.
108      * @param _value The amount of ETH to transfer.
109      * @param _status The operation's completion-status.
110      */
111     function postTransferEthToSgaHolder(address _to, uint256 _value, bool _status) external;
112 
113     /**
114      * @dev Get the address of the reserve-wallet and the deficient amount of ETH in the SGAToken contract.
115      * @return The address of the reserve-wallet and the deficient amount of ETH in the SGAToken contract.
116      */
117     function getDepositParams() external view returns (address, uint256);
118 
119     /**
120      * @dev Get the address of the reserve-wallet and the excessive amount of ETH in the SGAToken contract.
121      * @return The address of the reserve-wallet and the excessive amount of ETH in the SGAToken contract.
122      */
123     function getWithdrawParams() external view returns (address, uint256);
124 }
125 
126 // File: contracts/contract_address_locator/interfaces/IContractAddressLocator.sol
127 
128 /**
129  * @title Contract Address Locator Interface.
130  */
131 interface IContractAddressLocator {
132     /**
133      * @dev Get the contract address mapped to a given identifier.
134      * @param _identifier The identifier.
135      * @return The contract address.
136      */
137     function getContractAddress(bytes32 _identifier) external view returns (address);
138 
139     /**
140      * @dev Determine whether or not a contract address relates to one of the identifiers.
141      * @param _contractAddress The contract address to look for.
142      * @param _identifiers The identifiers.
143      * @return A boolean indicating if the contract address relates to one of the identifiers.
144      */
145     function isContractAddressRelates(address _contractAddress, bytes32[] _identifiers) external view returns (bool);
146 }
147 
148 // File: contracts/contract_address_locator/ContractAddressLocatorHolder.sol
149 
150 /**
151  * @title Contract Address Locator Holder.
152  * @dev Hold a contract address locator, which maps a unique identifier to every contract address in the system.
153  * @dev Any contract which inherits from this contract can retrieve the address of any contract in the system.
154  * @dev Thus, any contract can remain "oblivious" to the replacement of any other contract in the system.
155  * @dev In addition to that, any function in any contract can be restricted to a specific caller.
156  */
157 contract ContractAddressLocatorHolder {
158     bytes32 internal constant _IAuthorizationDataSource_ = "IAuthorizationDataSource";
159     bytes32 internal constant _ISGNConversionManager_    = "ISGNConversionManager"      ;
160     bytes32 internal constant _IModelDataSource_         = "IModelDataSource"        ;
161     bytes32 internal constant _IPaymentHandler_          = "IPaymentHandler"            ;
162     bytes32 internal constant _IPaymentManager_          = "IPaymentManager"            ;
163     bytes32 internal constant _IPaymentQueue_            = "IPaymentQueue"              ;
164     bytes32 internal constant _IReconciliationAdjuster_  = "IReconciliationAdjuster"      ;
165     bytes32 internal constant _IIntervalIterator_        = "IIntervalIterator"       ;
166     bytes32 internal constant _IMintHandler_             = "IMintHandler"            ;
167     bytes32 internal constant _IMintListener_            = "IMintListener"           ;
168     bytes32 internal constant _IMintManager_             = "IMintManager"            ;
169     bytes32 internal constant _IPriceBandCalculator_     = "IPriceBandCalculator"       ;
170     bytes32 internal constant _IModelCalculator_         = "IModelCalculator"        ;
171     bytes32 internal constant _IRedButton_               = "IRedButton"              ;
172     bytes32 internal constant _IReserveManager_          = "IReserveManager"         ;
173     bytes32 internal constant _ISagaExchanger_           = "ISagaExchanger"          ;
174     bytes32 internal constant _IMonetaryModel_               = "IMonetaryModel"              ;
175     bytes32 internal constant _IMonetaryModelState_          = "IMonetaryModelState"         ;
176     bytes32 internal constant _ISGAAuthorizationManager_ = "ISGAAuthorizationManager";
177     bytes32 internal constant _ISGAToken_                = "ISGAToken"               ;
178     bytes32 internal constant _ISGATokenManager_         = "ISGATokenManager"        ;
179     bytes32 internal constant _ISGNAuthorizationManager_ = "ISGNAuthorizationManager";
180     bytes32 internal constant _ISGNToken_                = "ISGNToken"               ;
181     bytes32 internal constant _ISGNTokenManager_         = "ISGNTokenManager"        ;
182     bytes32 internal constant _IMintingPointTimersManager_             = "IMintingPointTimersManager"            ;
183     bytes32 internal constant _ITradingClasses_          = "ITradingClasses"         ;
184     bytes32 internal constant _IWalletsTradingLimiterValueConverter_        = "IWalletsTLValueConverter"       ;
185     bytes32 internal constant _IWalletsTradingDataSource_       = "IWalletsTradingDataSource"      ;
186     bytes32 internal constant _WalletsTradingLimiter_SGNTokenManager_          = "WalletsTLSGNTokenManager"         ;
187     bytes32 internal constant _WalletsTradingLimiter_SGATokenManager_          = "WalletsTLSGATokenManager"         ;
188     bytes32 internal constant _IETHConverter_             = "IETHConverter"   ;
189     bytes32 internal constant _ITransactionLimiter_      = "ITransactionLimiter"     ;
190     bytes32 internal constant _ITransactionManager_      = "ITransactionManager"     ;
191     bytes32 internal constant _IRateApprover_      = "IRateApprover"     ;
192 
193     IContractAddressLocator private contractAddressLocator;
194 
195     /**
196      * @dev Create the contract.
197      * @param _contractAddressLocator The contract address locator.
198      */
199     constructor(IContractAddressLocator _contractAddressLocator) internal {
200         require(_contractAddressLocator != address(0), "locator is illegal");
201         contractAddressLocator = _contractAddressLocator;
202     }
203 
204     /**
205      * @dev Get the contract address locator.
206      * @return The contract address locator.
207      */
208     function getContractAddressLocator() external view returns (IContractAddressLocator) {
209         return contractAddressLocator;
210     }
211 
212     /**
213      * @dev Get the contract address mapped to a given identifier.
214      * @param _identifier The identifier.
215      * @return The contract address.
216      */
217     function getContractAddress(bytes32 _identifier) internal view returns (address) {
218         return contractAddressLocator.getContractAddress(_identifier);
219     }
220 
221 
222 
223     /**
224      * @dev Determine whether or not the sender relates to one of the identifiers.
225      * @param _identifiers The identifiers.
226      * @return A boolean indicating if the sender relates to one of the identifiers.
227      */
228     function isSenderAddressRelates(bytes32[] _identifiers) internal view returns (bool) {
229         return contractAddressLocator.isContractAddressRelates(msg.sender, _identifiers);
230     }
231 
232     /**
233      * @dev Verify that the caller is mapped to a given identifier.
234      * @param _identifier The identifier.
235      */
236     modifier only(bytes32 _identifier) {
237         require(msg.sender == getContractAddress(_identifier), "caller is illegal");
238         _;
239     }
240 
241 }
242 
243 // File: contracts/saga-genesis/interfaces/ISagaExchanger.sol
244 
245 /**
246  * @title Saga Exchanger Interface.
247  */
248 interface ISagaExchanger {
249     /**
250      * @dev Transfer SGA to an SGN holder.
251      * @param _to The address of the SGN holder.
252      * @param _value The amount of SGA to transfer.
253      */
254     function transferSgaToSgnHolder(address _to, uint256 _value) external;
255 }
256 
257 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
258 
259 /**
260  * @title ERC20 interface
261  * @dev see https://github.com/ethereum/EIPs/issues/20
262  */
263 interface IERC20 {
264   function totalSupply() external view returns (uint256);
265 
266   function balanceOf(address who) external view returns (uint256);
267 
268   function allowance(address owner, address spender)
269     external view returns (uint256);
270 
271   function transfer(address to, uint256 value) external returns (bool);
272 
273   function approve(address spender, uint256 value)
274     external returns (bool);
275 
276   function transferFrom(address from, address to, uint256 value)
277     external returns (bool);
278 
279   event Transfer(
280     address indexed from,
281     address indexed to,
282     uint256 value
283   );
284 
285   event Approval(
286     address indexed owner,
287     address indexed spender,
288     uint256 value
289   );
290 }
291 
292 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
293 
294 /**
295  * @title SafeMath
296  * @dev Math operations with safety checks that revert on error
297  */
298 library SafeMath {
299 
300   /**
301   * @dev Multiplies two numbers, reverts on overflow.
302   */
303   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
304     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
305     // benefit is lost if 'b' is also tested.
306     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
307     if (a == 0) {
308       return 0;
309     }
310 
311     uint256 c = a * b;
312     require(c / a == b);
313 
314     return c;
315   }
316 
317   /**
318   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
319   */
320   function div(uint256 a, uint256 b) internal pure returns (uint256) {
321     require(b > 0); // Solidity only automatically asserts when dividing by 0
322     uint256 c = a / b;
323     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
324 
325     return c;
326   }
327 
328   /**
329   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
330   */
331   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332     require(b <= a);
333     uint256 c = a - b;
334 
335     return c;
336   }
337 
338   /**
339   * @dev Adds two numbers, reverts on overflow.
340   */
341   function add(uint256 a, uint256 b) internal pure returns (uint256) {
342     uint256 c = a + b;
343     require(c >= a);
344 
345     return c;
346   }
347 
348   /**
349   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
350   * reverts when dividing by zero.
351   */
352   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
353     require(b != 0);
354     return a % b;
355   }
356 }
357 
358 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
359 
360 /**
361  * @title Standard ERC20 token
362  *
363  * @dev Implementation of the basic standard token.
364  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
365  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
366  */
367 contract ERC20 is IERC20 {
368   using SafeMath for uint256;
369 
370   mapping (address => uint256) private _balances;
371 
372   mapping (address => mapping (address => uint256)) private _allowed;
373 
374   uint256 private _totalSupply;
375 
376   /**
377   * @dev Total number of tokens in existence
378   */
379   function totalSupply() public view returns (uint256) {
380     return _totalSupply;
381   }
382 
383   /**
384   * @dev Gets the balance of the specified address.
385   * @param owner The address to query the balance of.
386   * @return An uint256 representing the amount owned by the passed address.
387   */
388   function balanceOf(address owner) public view returns (uint256) {
389     return _balances[owner];
390   }
391 
392   /**
393    * @dev Function to check the amount of tokens that an owner allowed to a spender.
394    * @param owner address The address which owns the funds.
395    * @param spender address The address which will spend the funds.
396    * @return A uint256 specifying the amount of tokens still available for the spender.
397    */
398   function allowance(
399     address owner,
400     address spender
401    )
402     public
403     view
404     returns (uint256)
405   {
406     return _allowed[owner][spender];
407   }
408 
409   /**
410   * @dev Transfer token for a specified address
411   * @param to The address to transfer to.
412   * @param value The amount to be transferred.
413   */
414   function transfer(address to, uint256 value) public returns (bool) {
415     _transfer(msg.sender, to, value);
416     return true;
417   }
418 
419   /**
420    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
421    * Beware that changing an allowance with this method brings the risk that someone may use both the old
422    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
423    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
424    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
425    * @param spender The address which will spend the funds.
426    * @param value The amount of tokens to be spent.
427    */
428   function approve(address spender, uint256 value) public returns (bool) {
429     require(spender != address(0));
430 
431     _allowed[msg.sender][spender] = value;
432     emit Approval(msg.sender, spender, value);
433     return true;
434   }
435 
436   /**
437    * @dev Transfer tokens from one address to another
438    * @param from address The address which you want to send tokens from
439    * @param to address The address which you want to transfer to
440    * @param value uint256 the amount of tokens to be transferred
441    */
442   function transferFrom(
443     address from,
444     address to,
445     uint256 value
446   )
447     public
448     returns (bool)
449   {
450     require(value <= _allowed[from][msg.sender]);
451 
452     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
453     _transfer(from, to, value);
454     return true;
455   }
456 
457   /**
458    * @dev Increase the amount of tokens that an owner allowed to a spender.
459    * approve should be called when allowed_[_spender] == 0. To increment
460    * allowed value is better to use this function to avoid 2 calls (and wait until
461    * the first transaction is mined)
462    * From MonolithDAO Token.sol
463    * @param spender The address which will spend the funds.
464    * @param addedValue The amount of tokens to increase the allowance by.
465    */
466   function increaseAllowance(
467     address spender,
468     uint256 addedValue
469   )
470     public
471     returns (bool)
472   {
473     require(spender != address(0));
474 
475     _allowed[msg.sender][spender] = (
476       _allowed[msg.sender][spender].add(addedValue));
477     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
478     return true;
479   }
480 
481   /**
482    * @dev Decrease the amount of tokens that an owner allowed to a spender.
483    * approve should be called when allowed_[_spender] == 0. To decrement
484    * allowed value is better to use this function to avoid 2 calls (and wait until
485    * the first transaction is mined)
486    * From MonolithDAO Token.sol
487    * @param spender The address which will spend the funds.
488    * @param subtractedValue The amount of tokens to decrease the allowance by.
489    */
490   function decreaseAllowance(
491     address spender,
492     uint256 subtractedValue
493   )
494     public
495     returns (bool)
496   {
497     require(spender != address(0));
498 
499     _allowed[msg.sender][spender] = (
500       _allowed[msg.sender][spender].sub(subtractedValue));
501     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
502     return true;
503   }
504 
505   /**
506   * @dev Transfer token for a specified addresses
507   * @param from The address to transfer from.
508   * @param to The address to transfer to.
509   * @param value The amount to be transferred.
510   */
511   function _transfer(address from, address to, uint256 value) internal {
512     require(value <= _balances[from]);
513     require(to != address(0));
514 
515     _balances[from] = _balances[from].sub(value);
516     _balances[to] = _balances[to].add(value);
517     emit Transfer(from, to, value);
518   }
519 
520   /**
521    * @dev Internal function that mints an amount of the token and assigns it to
522    * an account. This encapsulates the modification of balances such that the
523    * proper events are emitted.
524    * @param account The account that will receive the created tokens.
525    * @param value The amount that will be created.
526    */
527   function _mint(address account, uint256 value) internal {
528     require(account != 0);
529     _totalSupply = _totalSupply.add(value);
530     _balances[account] = _balances[account].add(value);
531     emit Transfer(address(0), account, value);
532   }
533 
534   /**
535    * @dev Internal function that burns an amount of the token of a given
536    * account.
537    * @param account The account whose tokens will be burnt.
538    * @param value The amount that will be burnt.
539    */
540   function _burn(address account, uint256 value) internal {
541     require(account != 0);
542     require(value <= _balances[account]);
543 
544     _totalSupply = _totalSupply.sub(value);
545     _balances[account] = _balances[account].sub(value);
546     emit Transfer(account, address(0), value);
547   }
548 
549   /**
550    * @dev Internal function that burns an amount of the token of a given
551    * account, deducting from the sender's allowance for said account. Uses the
552    * internal burn function.
553    * @param account The account whose tokens will be burnt.
554    * @param value The amount that will be burnt.
555    */
556   function _burnFrom(address account, uint256 value) internal {
557     require(value <= _allowed[account][msg.sender]);
558 
559     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
560     // this function needs to emit an event with the updated approval.
561     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
562       value);
563     _burn(account, value);
564   }
565 }
566 
567 // File: contracts/saga/SGAToken.sol
568 
569 /**
570  * Details of usage of licenced software see here: https://www.saga.org/software/readme_v1
571  */
572 
573 /**
574  * @title Saga Token.
575  * @dev ERC20 compatible.
576  * @dev Exchange ETH for SGA.
577  * @dev Exchange SGA for ETH.
578  */
579 contract SGAToken is ERC20, ContractAddressLocatorHolder, IMintListener, ISagaExchanger, IPaymentHandler {
580     string public constant VERSION = "1.0.0";
581 
582     string public constant name = "Saga";
583     string public constant symbol = "SGA";
584     uint8  public constant decimals = 18;
585 
586     /**
587      * @dev Public Address 0x10063FCCf5eEE46fC65D399a7F5dd88730906CF9.
588      * @notice SGA will be minted at this public address for SGN holders.
589      * @notice SGA will be transferred from this public address upon conversion by an SGN holder.
590      * @notice It is generated in a manner which ensures that the corresponding private key is unknown.
591      */
592     address public constant SGA_MINTED_FOR_SGN_HOLDERS = address(keccak256("SGA_MINTED_FOR_SGN_HOLDERS"));
593 
594     /**
595      * @dev Create the contract.
596      * @param _contractAddressLocator The contract address locator.
597      */
598     constructor(IContractAddressLocator _contractAddressLocator) ContractAddressLocatorHolder(_contractAddressLocator) public {}
599 
600     /**
601      * @dev Return the contract which implements the ISGATokenManager interface.
602      */
603     function getSGATokenManager() public view returns (ISGATokenManager) {
604         return ISGATokenManager(getContractAddress(_ISGATokenManager_));
605     }
606 
607     /**
608      * @dev Exchange ETH for SGA.
609      * @notice Can be executed from externally-owned accounts but not from other contracts.
610      * @notice This is due to the insufficient gas-stipend provided to the fallback function.
611      */
612     function() external payable {
613         uint256 amount = getSGATokenManager().exchangeEthForSga(msg.sender, msg.value);
614         _mint(msg.sender, amount);
615     }
616 
617     /**
618      * @dev Exchange ETH for SGA.
619      * @notice Can be executed from externally-owned accounts as well as from other contracts.
620      */
621     function exchange() external payable {
622         uint256 amount = getSGATokenManager().exchangeEthForSga(msg.sender, msg.value);
623         _mint(msg.sender, amount);
624     }
625 
626     /**
627      * @dev Transfer SGA to another account.
628      * @param _to The address of the destination account.
629      * @param _value The amount of SGA to be transferred.
630      * @return Status (true if completed successfully, false otherwise).
631      * @notice If the destination account is this contract, then exchange SGA for ETH.
632      */
633     function transfer(address _to, uint256 _value) public returns (bool) {
634         if (_to == address(this)) {
635             uint256 amount = getSGATokenManager().exchangeSgaForEth(msg.sender, _value);
636             _burn(msg.sender, _value);
637             msg.sender.transfer(amount);
638             return true;
639         }
640         getSGATokenManager().uponTransfer(msg.sender, _to, _value);
641         return super.transfer(_to, _value);
642     }
643 
644     /**
645      * @dev Transfer SGA from one account to another.
646      * @param _from The address of the source account.
647      * @param _to The address of the destination account.
648      * @param _value The amount of SGA to be transferred.
649      * @return Status (true if completed successfully, false otherwise).
650      * @notice If the destination account is this contract, then the operation is illegal.
651      */
652     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
653         require(_to != address(this), "custodian-transfer of SGA into this contract is illegal");
654         getSGATokenManager().uponTransferFrom(msg.sender, _from, _to, _value);
655         return super.transferFrom(_from, _to, _value);
656     }
657 
658     /**
659      * @dev Deposit ETH into this contract.
660      */
661     function deposit() external payable {
662         getSGATokenManager().uponDeposit(msg.sender, address(this).balance, msg.value);
663     }
664 
665     /**
666      * @dev Withdraw ETH from this contract.
667      */
668     function withdraw() external {
669         (address wallet, uint256 amount) = getSGATokenManager().uponWithdraw(msg.sender, address(this).balance);
670         wallet.transfer(amount);
671     }
672 
673     /**
674      * @dev Mint SGA for SGN holders.
675      * @param _value The amount of SGA to mint.
676      */
677     function mintSgaForSgnHolders(uint256 _value) external only(_IMintManager_) {
678         getSGATokenManager().uponMintSgaForSgnHolders(_value);
679         _mint(SGA_MINTED_FOR_SGN_HOLDERS, _value);
680     }
681 
682     /**
683      * @dev Transfer SGA to an SGN holder.
684      * @param _to The address of the SGN holder.
685      * @param _value The amount of SGA to transfer.
686      */
687     function transferSgaToSgnHolder(address _to, uint256 _value) external only(_ISGNToken_) {
688         getSGATokenManager().uponTransferSgaToSgnHolder(_to, _value);
689         _transfer(SGA_MINTED_FOR_SGN_HOLDERS, _to, _value);
690     }
691 
692     /**
693      * @dev Transfer ETH to an SGA holder.
694      * @param _to The address of the SGA holder.
695      * @param _value The amount of ETH to transfer.
696      */
697     function transferEthToSgaHolder(address _to, uint256 _value) external only(_IPaymentManager_) {
698         bool status = _to.send(_value);
699         getSGATokenManager().postTransferEthToSgaHolder(_to, _value, status);
700     }
701 
702     /**
703      * @dev Get the amount of available ETH.
704      * @return The amount of available ETH.
705      */
706     function getEthBalance() external view returns (uint256) {
707         return address(this).balance;
708     }
709 
710     /**
711      * @dev Get the address of the reserve-wallet and the deficient amount of ETH in this contract.
712      * @return The address of the reserve-wallet and the deficient amount of ETH in this contract.
713      */
714     function getDepositParams() external view returns (address, uint256) {
715         return getSGATokenManager().getDepositParams();
716     }
717 
718     /**
719      * @dev Get the address of the reserve-wallet and the excessive amount of ETH in this contract.
720      * @return The address of the reserve-wallet and the excessive amount of ETH in this contract.
721      */
722     function getWithdrawParams() external view returns (address, uint256) {
723         return getSGATokenManager().getWithdrawParams();
724     }
725 }
