1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-02
3 */
4 
5 pragma solidity ^0.5.4;
6 
7 /**
8  * ERC20 contract interface.
9  */
10 contract ERC20 {
11     function totalSupply() public view returns (uint);
12     function decimals() public view returns (uint);
13     function balanceOf(address tokenOwner) public view returns (uint balance);
14     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
15     function transfer(address to, uint tokens) public returns (bool success);
16     function approve(address spender, uint tokens) public returns (bool success);
17     function transferFrom(address from, address to, uint tokens) public returns (bool success);
18 }
19 
20 /**
21  * @title Module
22  * @dev Interface for a module. 
23  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
24  * can never end up in a "frozen" state.
25  * @author Julien Niset - <julien@argent.xyz>
26  */
27 interface Module {
28     function init(BaseWallet _wallet) external;
29     function addModule(BaseWallet _wallet, Module _module) external;
30     function recoverToken(address _token) external;
31 }
32 
33 /**
34  * @title BaseWallet
35  * @dev Simple modular wallet that authorises modules to call its invoke() method.
36  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
37  * @author Julien Niset - <julien@argent.xyz>
38  */
39 contract BaseWallet {
40     address public implementation;
41     address public owner;
42     mapping (address => bool) public authorised;
43     mapping (bytes4 => address) public enabled;
44     uint public modules;
45     function init(address _owner, address[] calldata _modules) external;
46     function authoriseModule(address _module, bool _value) external;
47     function enableStaticCall(address _module, bytes4 _method) external;
48     function setOwner(address _newOwner) external;
49     function invoke(address _target, uint _value, bytes calldata _data) external;
50     function() external payable;
51 }
52 
53 /**
54  * @title ModuleRegistry
55  * @dev Registry of authorised modules. 
56  * Modules must be registered before they can be authorised on a wallet.
57  * @author Julien Niset - <julien@argent.xyz>
58  */
59 contract ModuleRegistry {
60     function registerModule(address _module, bytes32 _name) external;
61     function deregisterModule(address _module) external;
62     function registerUpgrader(address _upgrader, bytes32 _name) external;
63     function deregisterUpgrader(address _upgrader) external;
64     function recoverToken(address _token) external;
65     function moduleInfo(address _module) external view returns (bytes32);
66     function upgraderInfo(address _upgrader) external view returns (bytes32);
67     function isRegisteredModule(address _module) external view returns (bool);
68     function isRegisteredModule(address[] calldata _modules) external view returns (bool);
69     function isRegisteredUpgrader(address _upgrader) external view returns (bool);
70 }
71 
72 /**
73  * @title GuardianStorage
74  * @dev Contract storing the state of wallets related to guardians and lock.
75  * The contract only defines basic setters and getters with no logic. Only modules authorised
76  * for a wallet can modify its state.
77  * @author Julien Niset - <julien@argent.xyz>
78  * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
79  */
80 contract GuardianStorage {
81     function addGuardian(BaseWallet _wallet, address _guardian) external;
82     function revokeGuardian(BaseWallet _wallet, address _guardian) external;
83     function guardianCount(BaseWallet _wallet) external view returns (uint256);
84     function getGuardians(BaseWallet _wallet) external view returns (address[] memory);
85     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool);
86     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external;
87     function isLocked(BaseWallet _wallet) external view returns (bool);
88     function getLock(BaseWallet _wallet) external view returns (uint256);
89     function getLocker(BaseWallet _wallet) external view returns (address);
90 }
91 
92 interface Comptroller {
93     function enterMarkets(address[] calldata _cTokens) external returns (uint[] memory);
94     function exitMarket(address _cToken) external returns (uint);
95     function getAssetsIn(address _account) external view returns (address[] memory);
96     function getAccountLiquidity(address _account) external view returns (uint, uint, uint);
97     function checkMembership(address account, CToken cToken) external view returns (bool);
98 }
99 
100 interface CToken {
101     function comptroller() external view returns (address);
102     function underlying() external view returns (address);
103     function symbol() external view returns (string memory);
104     function exchangeRateCurrent() external returns (uint256);
105     function exchangeRateStored() external view returns (uint256);
106     function balanceOf(address _account) external view returns (uint256);
107     function borrowBalanceCurrent(address _account) external returns (uint256);
108     function borrowBalanceStored(address _account) external view returns (uint256);
109 }
110 
111 /**
112  * @title CompoundRegistry
113  * @dev Simple registry containing a mapping between underlying assets and their corresponding cToken.
114  * @author Julien Niset - <julien@argent.xyz>
115  */
116 contract CompoundRegistry {
117     function addCToken(address _underlying, address _cToken) external;
118     function removeCToken(address _underlying) external;
119     function getCToken(address _underlying) external view returns (address);
120     function listUnderlyings() external view returns (address[] memory);
121 }
122 
123 /**
124  * @title Interface for a contract that can invest tokens in order to earn an interest.
125  * @author Julien Niset - <julien@argent.xyz>
126  */
127 interface Invest {
128 
129     event InvestmentAdded(address indexed _wallet, address _token, uint256 _invested, uint256 _period);
130     event InvestmentRemoved(address indexed _wallet, address _token, uint256 _fraction);
131 
132     /**
133      * @dev Invest tokens for a given period.
134      * @param _wallet The target wallet.
135      * @param _token The token address.
136      * @param _amount The amount of tokens to invest.
137      * @param _period The period over which the tokens may be locked in the investment (optional).
138      * @return The exact amount of tokens that have been invested. 
139      */
140     function addInvestment(
141         BaseWallet _wallet, 
142         address _token, 
143         uint256 _amount, 
144         uint256 _period
145     ) 
146         external
147         returns (uint256 _invested);
148 
149     /**
150      * @dev Exit invested postions.
151      * @param _wallet The target wallet.
152      * @param _token The token address.
153      * @param _fraction The fraction of invested tokens to exit in per 10000. 
154      */
155     function removeInvestment(
156         BaseWallet _wallet, 
157         address _token, 
158         uint256 _fraction
159     ) 
160         external;
161 
162     /**
163      * @dev Get the amount of investment in a given token.
164      * @param _wallet The target wallet.
165      * @param _token The token address.
166      * @return The value in tokens of the investment (including interests) and the time at which the investment can be removed.
167      */
168     function getInvestment(
169         BaseWallet _wallet,
170         address _token
171     )
172         external
173         view
174         returns (uint256 _tokenValue, uint256 _periodEnd);
175 }
176 
177 /**
178  * @title Interface for a contract that can loan tokens to a wallet.
179  * @author Julien Niset - <julien@argent.xyz>
180  */
181 interface Loan {
182 
183     event LoanOpened(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount, address _debtToken, uint256 _debtAmount);
184     event LoanClosed(address indexed _wallet, bytes32 indexed _loanId);
185     event CollateralAdded(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount);
186     event CollateralRemoved(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount);
187     event DebtAdded(address indexed _wallet, bytes32 indexed _loanId, address _debtToken, uint256 _debtAmount);
188     event DebtRemoved(address indexed _wallet, bytes32 indexed _loanId, address _debtToken, uint256 _debtAmount);
189 
190     /**
191      * @dev Opens a collateralized loan.
192      * @param _wallet The target wallet.
193      * @param _collateral The token used as a collateral.
194      * @param _collateralAmount The amount of collateral token provided.
195      * @param _debtToken The token borrowed.
196      * @param _debtAmount The amount of tokens borrowed.
197      * @return (optional) An ID for the loan when the provider enables users to create multiple distinct loans.
198      */
199     function openLoan(
200         BaseWallet _wallet, 
201         address _collateral, 
202         uint256 _collateralAmount, 
203         address _debtToken, 
204         uint256 _debtAmount
205     ) 
206         external 
207         returns (bytes32 _loanId);
208 
209     /**
210      * @dev Closes a collateralized loan by repaying all debts (plus interest) and redeeming all collateral (plus interest).
211      * @param _wallet The target wallet.
212      * @param _loanId The ID of the loan if any, 0 otherwise.
213      */
214     function closeLoan(
215         BaseWallet _wallet, 
216         bytes32 _loanId
217     ) 
218         external;
219 
220     /**
221      * @dev Adds collateral to a loan identified by its ID.
222      * @param _wallet The target wallet.
223      * @param _loanId The ID of the loan if any, 0 otherwise.
224      * @param _collateral The token used as a collateral.
225      * @param _collateralAmount The amount of collateral to add.
226      */
227     function addCollateral(
228         BaseWallet _wallet, 
229         bytes32 _loanId, 
230         address _collateral, 
231         uint256 _collateralAmount
232     ) 
233         external;
234 
235     /**
236      * @dev Removes collateral from a loan identified by its ID.
237      * @param _wallet The target wallet.
238      * @param _loanId The ID of the loan if any, 0 otherwise.
239      * @param _collateral The token used as a collateral.
240      * @param _collateralAmount The amount of collateral to remove.
241      */
242     function removeCollateral(
243         BaseWallet _wallet, 
244         bytes32 _loanId, 
245         address _collateral, 
246         uint256 _collateralAmount
247     ) 
248         external;
249 
250     /**
251      * @dev Increases the debt by borrowing more token from a loan identified by its ID.
252      * @param _wallet The target wallet.
253      * @param _loanId The ID of the loan if any, 0 otherwise.
254      * @param _debtToken The token borrowed.
255      * @param _debtAmount The amount of token to borrow.
256      */
257     function addDebt(
258         BaseWallet _wallet, 
259         bytes32 _loanId, 
260         address _debtToken, 
261         uint256 _debtAmount
262     ) 
263         external;
264 
265     /**
266      * @dev Decreases the debt by repaying some token from a loan identified by its ID.
267      * @param _wallet The target wallet.
268      * @param _loanId The ID of the loan if any, 0 otherwise.
269      * @param _debtToken The token to repay.
270      * @param _debtAmount The amount of token to repay.
271      */
272     function removeDebt(
273         BaseWallet _wallet, 
274         bytes32 _loanId, 
275         address _debtToken, 
276         uint256 _debtAmount
277     ) 
278         external;
279 
280     /**
281      * @dev Gets information about a loan identified by its ID.
282      * @param _wallet The target wallet.
283      * @param _loanId The ID of the loan if any, 0 otherwise.
284      * @return a status [0: no loan, 1: loan is safe, 2: loan is unsafe and can be liquidated, 3: unable to provide info]
285      * and a value (in ETH) representing the value that could still be borrowed when status = 1; or the value of the collateral 
286      * that should be added to avoid liquidation when status = 2.     
287      */
288     function getLoan(
289         BaseWallet _wallet, 
290         bytes32 _loanId
291     ) 
292         external 
293         view 
294         returns (uint8 _status, uint256 _ethValue);
295 }
296 
297 /**
298  * @title SafeMath
299  * @dev Math operations with safety checks that throw on error
300  */
301 library SafeMath {
302 
303     /**
304     * @dev Multiplies two numbers, reverts on overflow.
305     */
306     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
307         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
308         // benefit is lost if 'b' is also tested.
309         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
310         if (a == 0) {
311             return 0;
312         }
313 
314         uint256 c = a * b;
315         require(c / a == b);
316 
317         return c;
318     }
319 
320     /**
321     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
322     */
323     function div(uint256 a, uint256 b) internal pure returns (uint256) {
324         require(b > 0); // Solidity only automatically asserts when dividing by 0
325         uint256 c = a / b;
326         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
327 
328         return c;
329     }
330 
331     /**
332     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
333     */
334     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
335         require(b <= a);
336         uint256 c = a - b;
337 
338         return c;
339     }
340 
341     /**
342     * @dev Adds two numbers, reverts on overflow.
343     */
344     function add(uint256 a, uint256 b) internal pure returns (uint256) {
345         uint256 c = a + b;
346         require(c >= a);
347 
348         return c;
349     }
350 
351     /**
352     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
353     * reverts when dividing by zero.
354     */
355     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
356         require(b != 0);
357         return a % b;
358     }
359 
360     /**
361     * @dev Returns ceil(a / b).
362     */
363     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
364         uint256 c = a / b;
365         if(a % b == 0) {
366             return c;
367         }
368         else {
369             return c + 1;
370         }
371     }
372 }
373 
374 /**
375  * @title BaseModule
376  * @dev Basic module that contains some methods common to all modules.
377  * @author Julien Niset - <julien@argent.im>
378  */
379 contract BaseModule is Module {
380 
381     // The adddress of the module registry.
382     ModuleRegistry internal registry;
383 
384     event ModuleCreated(bytes32 name);
385     event ModuleInitialised(address wallet);
386 
387     constructor(ModuleRegistry _registry, bytes32 _name) public {
388         registry = _registry;
389         emit ModuleCreated(_name);
390     }
391 
392     /**
393      * @dev Throws if the sender is not the target wallet of the call.
394      */
395     modifier onlyWallet(BaseWallet _wallet) {
396         require(msg.sender == address(_wallet), "BM: caller must be wallet");
397         _;
398     }
399 
400     /**
401      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
402      */
403     modifier onlyWalletOwner(BaseWallet _wallet) {
404         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
405         _;
406     }
407 
408     /**
409      * @dev Throws if the sender is not the owner of the target wallet.
410      */
411     modifier strictOnlyWalletOwner(BaseWallet _wallet) {
412         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
413         _;
414     }
415 
416     /**
417      * @dev Inits the module for a wallet by logging an event.
418      * The method can only be called by the wallet itself.
419      * @param _wallet The wallet.
420      */
421     function init(BaseWallet _wallet) external onlyWallet(_wallet) {
422         emit ModuleInitialised(address(_wallet));
423     }
424 
425     /**
426      * @dev Adds a module to a wallet. First checks that the module is registered.
427      * @param _wallet The target wallet.
428      * @param _module The modules to authorise.
429      */
430     function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
431         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
432         _wallet.authoriseModule(address(_module), true);
433     }
434 
435     /**
436     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
437     * module by mistake and transfer them to the Module Registry. 
438     * @param _token The token to recover.
439     */
440     function recoverToken(address _token) external {
441         uint total = ERC20(_token).balanceOf(address(this));
442         ERC20(_token).transfer(address(registry), total);
443     }
444 
445     /**
446      * @dev Helper method to check if an address is the owner of a target wallet.
447      * @param _wallet The target wallet.
448      * @param _addr The address.
449      */
450     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
451         return _wallet.owner() == _addr;
452     }
453 }
454 
455 /**
456  * @title RelayerModule
457  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer. 
458  * @author Julien Niset - <julien@argent.im>
459  */
460 contract RelayerModule is Module {
461 
462     uint256 constant internal BLOCKBOUND = 10000;
463 
464     mapping (address => RelayerConfig) public relayer; 
465 
466     struct RelayerConfig {
467         uint256 nonce;
468         mapping (bytes32 => bool) executedTx;
469     }
470 
471     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
472 
473     /**
474      * @dev Throws if the call did not go through the execute() method.
475      */
476     modifier onlyExecute {
477         require(msg.sender == address(this), "RM: must be called via execute()");
478         _;
479     }
480 
481     /* ***************** Abstract method ************************* */
482 
483     /**
484     * @dev Gets the number of valid signatures that must be provided to execute a
485     * specific relayed transaction.
486     * @param _wallet The target wallet.
487     * @param _data The data of the relayed transaction.
488     * @return The number of required signatures.
489     */
490     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);
491 
492     /**
493     * @dev Validates the signatures provided with a relayed transaction.
494     * The method MUST throw if one or more signatures are not valid.
495     * @param _wallet The target wallet.
496     * @param _data The data of the relayed transaction.
497     * @param _signHash The signed hash representing the relayed transaction.
498     * @param _signatures The signatures as a concatenated byte array.
499     */
500     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool);
501 
502     /* ************************************************************ */
503 
504     /**
505     * @dev Executes a relayed transaction.
506     * @param _wallet The target wallet.
507     * @param _data The data for the relayed transaction
508     * @param _nonce The nonce used to prevent replay attacks.
509     * @param _signatures The signatures as a concatenated byte array.
510     * @param _gasPrice The gas price to use for the gas refund.
511     * @param _gasLimit The gas limit to use for the gas refund.
512     */
513     function execute(
514         BaseWallet _wallet,
515         bytes calldata _data, 
516         uint256 _nonce, 
517         bytes calldata _signatures, 
518         uint256 _gasPrice,
519         uint256 _gasLimit
520     )
521         external
522         returns (bool success)
523     {
524         uint startGas = gasleft();
525         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
526         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
527         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
528         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
529         if((requiredSignatures * 65) == _signatures.length) {
530             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
531                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
532                     // solium-disable-next-line security/no-call-value
533                     (success,) = address(this).call(_data);
534                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
535                 }
536             }
537         }
538         emit TransactionExecuted(address(_wallet), success, signHash); 
539     }
540 
541     /**
542     * @dev Gets the current nonce for a wallet.
543     * @param _wallet The target wallet.
544     */
545     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
546         return relayer[address(_wallet)].nonce;
547     }
548 
549     /**
550     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
551     * @param _from The starting address for the relayed transaction (should be the module)
552     * @param _to The destination address for the relayed transaction (should be the wallet)
553     * @param _value The value for the relayed transaction
554     * @param _data The data for the relayed transaction
555     * @param _nonce The nonce used to prevent replay attacks.
556     * @param _gasPrice The gas price to use for the gas refund.
557     * @param _gasLimit The gas limit to use for the gas refund.
558     */
559     function getSignHash(
560         address _from,
561         address _to, 
562         uint256 _value, 
563         bytes memory _data, 
564         uint256 _nonce,
565         uint256 _gasPrice,
566         uint256 _gasLimit
567     ) 
568         internal 
569         pure
570         returns (bytes32) 
571     {
572         return keccak256(
573             abi.encodePacked(
574                 "\x19Ethereum Signed Message:\n32",
575                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
576         ));
577     }
578 
579     /**
580     * @dev Checks if the relayed transaction is unique.
581     * @param _wallet The target wallet.
582     * @param _nonce The nonce
583     * @param _signHash The signed hash of the transaction
584     */
585     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
586         if(relayer[address(_wallet)].executedTx[_signHash] == true) {
587             return false;
588         }
589         relayer[address(_wallet)].executedTx[_signHash] = true;
590         return true;
591     }
592 
593     /**
594     * @dev Checks that a nonce has the correct format and is valid. 
595     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
596     * @param _wallet The target wallet.
597     * @param _nonce The nonce
598     */
599     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
600         if(_nonce <= relayer[address(_wallet)].nonce) {
601             return false;
602         }   
603         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
604         if(nonceBlock > block.number + BLOCKBOUND) {
605             return false;
606         }
607         relayer[address(_wallet)].nonce = _nonce;
608         return true;    
609     }
610 
611     /**
612     * @dev Recovers the signer at a given position from a list of concatenated signatures.
613     * @param _signedHash The signed hash
614     * @param _signatures The concatenated signatures.
615     * @param _index The index of the signature to recover.
616     */
617     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
618         uint8 v;
619         bytes32 r;
620         bytes32 s;
621         // we jump 32 (0x20) as the first slot of bytes contains the length
622         // we jump 65 (0x41) per signature
623         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
624         // solium-disable-next-line security/no-inline-assembly
625         assembly {
626             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
627             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
628             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
629         }
630         require(v == 27 || v == 28); 
631         return ecrecover(_signedHash, v, r, s);
632     }
633 
634     /**
635     * @dev Refunds the gas used to the Relayer. 
636     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
637     * @param _wallet The target wallet.
638     * @param _gasUsed The gas used.
639     * @param _gasPrice The gas price for the refund.
640     * @param _gasLimit The gas limit for the refund.
641     * @param _signatures The number of signatures used in the call.
642     * @param _relayer The address of the Relayer.
643     */
644     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
645         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
646         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
647         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
648             if(_gasPrice > tx.gasprice) {
649                 amount = amount * tx.gasprice;
650             }
651             else {
652                 amount = amount * _gasPrice;
653             }
654             _wallet.invoke(_relayer, amount, "");
655         }
656     }
657 
658     /**
659     * @dev Returns false if the refund is expected to fail.
660     * @param _wallet The target wallet.
661     * @param _gasUsed The expected gas used.
662     * @param _gasPrice The expected gas price for the refund.
663     */
664     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
665         if(_gasPrice > 0 
666             && _signatures > 1 
667             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
668             return false;
669         }
670         return true;
671     }
672 
673     /**
674     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
675     * as the wallet passed as the input of the execute() method. 
676     @return false if the addresses are different.
677     */
678     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
679         require(_data.length >= 36, "RM: Invalid dataWallet");
680         address dataWallet;
681         // solium-disable-next-line security/no-inline-assembly
682         assembly {
683             //_data = {length:32}{sig:4}{_wallet:32}{...}
684             dataWallet := mload(add(_data, 0x24))
685         }
686         return dataWallet == _wallet;
687     }
688 
689     /**
690     * @dev Parses the data to extract the method signature. 
691     */
692     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
693         require(_data.length >= 4, "RM: Invalid functionPrefix");
694         // solium-disable-next-line security/no-inline-assembly
695         assembly {
696             prefix := mload(add(_data, 0x20))
697         }
698     }
699 }
700 
701 /**
702  * @title OnlyOwnerModule
703  * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
704  * must be called with one signature frm the owner.
705  * @author Julien Niset - <julien@argent.im>
706  */
707 contract OnlyOwnerModule is BaseModule, RelayerModule {
708 
709     // *************** Implementation of RelayerModule methods ********************* //
710 
711     // Overrides to use the incremental nonce and save some gas
712     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
713         return checkAndUpdateNonce(_wallet, _nonce);
714     }
715 
716     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool) {
717         address signer = recoverSigner(_signHash, _signatures, 0);
718         return isOwner(_wallet, signer); // "OOM: signer must be owner"
719     }
720 
721     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256) {
722         return 1;
723     }
724 }
725 
726 /**
727  * @title CompoundManager
728  * @dev Module to invest and borrow tokens with CompoundV2
729  * @author Julien Niset - <julien@argent.xyz>
730  */
731 contract CompoundManager is Loan, Invest, BaseModule, RelayerModule, OnlyOwnerModule {
732 
733     bytes32 constant NAME = "CompoundManager";
734 
735     // The Guardian storage contract
736     GuardianStorage public guardianStorage;
737     // The Compound Comptroller contract
738     Comptroller public comptroller;
739     // The registry mapping underlying with cTokens
740     CompoundRegistry public compoundRegistry;
741 
742     // Mock token address for ETH
743     address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
744 
745     using SafeMath for uint256;
746 
747     /**
748      * @dev Throws if the wallet is locked.
749      */
750     modifier onlyWhenUnlocked(BaseWallet _wallet) {
751         // solium-disable-next-line security/no-block-members
752         require(!guardianStorage.isLocked(_wallet), "CompoundManager: wallet must be unlocked");
753         _;
754     }
755 
756     constructor(
757         ModuleRegistry _registry,
758         GuardianStorage _guardianStorage,
759         Comptroller _comptroller,
760         CompoundRegistry _compoundRegistry
761     )
762         BaseModule(_registry, NAME)
763         public
764     {
765         guardianStorage = _guardianStorage;
766         comptroller = _comptroller;
767         compoundRegistry = _compoundRegistry;
768     }
769 
770     /* ********************************** Implementation of Loan ************************************* */
771 
772     /**
773      * @dev Opens a collateralized loan.
774      * @param _wallet The target wallet.
775      * @param _collateral The token used as a collateral.
776      * @param _collateralAmount The amount of collateral token provided.
777      * @param _debtToken The token borrowed.
778      * @param _debtAmount The amount of tokens borrowed.
779      * @return bytes32(0) as Compound does not allow the creation of multiple loans.
780      */
781     function openLoan(
782         BaseWallet _wallet,
783         address _collateral,
784         uint256 _collateralAmount,
785         address _debtToken,
786         uint256 _debtAmount
787     ) 
788         external 
789         onlyWalletOwner(_wallet)
790         onlyWhenUnlocked(_wallet)
791         returns (bytes32 _loanId) 
792     {
793         address[] memory markets = new address[](2);
794         markets[0] = compoundRegistry.getCToken(_collateral);
795         markets[1] = compoundRegistry.getCToken(_debtToken);
796         _wallet.invoke(address(comptroller), 0, abi.encodeWithSignature("enterMarkets(address[])", markets));
797         mint(_wallet, markets[0], _collateral, _collateralAmount);
798         borrow(_wallet, markets[1], _debtAmount);
799         emit LoanOpened(address(_wallet), _loanId, _collateral, _collateralAmount, _debtToken, _debtAmount);
800     }
801 
802     /**
803      * @dev Closes the collateralized loan in all markets by repaying all debts (plus interest). Note that it does not redeem the collateral.
804      * @param _wallet The target wallet.
805      * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
806      */
807     function closeLoan(
808         BaseWallet _wallet,
809         bytes32 _loanId
810     )
811         external
812         onlyWalletOwner(_wallet)
813         onlyWhenUnlocked(_wallet)
814     {
815         address[] memory markets = comptroller.getAssetsIn(address(_wallet));
816         for(uint i = 0; i < markets.length; i++) {
817             address cToken = markets[i];
818             uint debt = CToken(cToken).borrowBalanceCurrent(address(_wallet));
819             if(debt > 0) {
820                 repayBorrow(_wallet, cToken, debt);
821                 uint collateral = CToken(cToken).balanceOf(address(_wallet));
822                 if(collateral == 0) {
823                     _wallet.invoke(address(comptroller), 0, abi.encodeWithSignature("exitMarket(address)", address(cToken)));
824                 }
825             }
826         }
827         emit LoanClosed(address(_wallet), _loanId);
828     }
829 
830     /**
831      * @dev Adds collateral to a loan identified by its ID.
832      * @param _wallet The target wallet.
833      * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
834      * @param _collateral The token used as a collateral.
835      * @param _collateralAmount The amount of collateral to add.
836      */
837     function addCollateral(
838         BaseWallet _wallet, 
839         bytes32 _loanId, 
840         address _collateral, 
841         uint256 _collateralAmount
842     ) 
843         external 
844         onlyWalletOwner(_wallet)
845         onlyWhenUnlocked(_wallet)
846     {
847         address cToken = compoundRegistry.getCToken(_collateral);
848         enterMarketIfNeeded(_wallet, cToken, address(comptroller));
849         mint(_wallet, cToken, _collateral, _collateralAmount);
850         emit CollateralAdded(address(_wallet), _loanId, _collateral, _collateralAmount);
851     }
852 
853     /**
854      * @dev Removes collateral from a loan identified by its ID.
855      * @param _wallet The target wallet.
856      * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
857      * @param _collateral The token used as a collateral.
858      * @param _collateralAmount The amount of collateral to remove.
859      */
860     function removeCollateral(
861         BaseWallet _wallet, 
862         bytes32 _loanId, 
863         address _collateral, 
864         uint256 _collateralAmount
865     ) 
866         external 
867         onlyWalletOwner(_wallet)
868         onlyWhenUnlocked(_wallet)
869     {
870         address cToken = compoundRegistry.getCToken(_collateral);
871         redeemUnderlying(_wallet, cToken, _collateralAmount);
872         exitMarketIfNeeded(_wallet, cToken, address(comptroller));
873         emit CollateralRemoved(address(_wallet), _loanId, _collateral, _collateralAmount);
874     }
875 
876     /**
877      * @dev Increases the debt by borrowing more token from a loan identified by its ID.
878      * @param _wallet The target wallet.
879      * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
880      * @param _debtToken The token borrowed.
881      * @param _debtAmount The amount of token to borrow.
882      */
883     function addDebt(
884         BaseWallet _wallet, 
885         bytes32 _loanId, 
886         address _debtToken, 
887         uint256 _debtAmount
888     ) 
889         external 
890         onlyWalletOwner(_wallet)
891         onlyWhenUnlocked(_wallet)
892     {
893         address dToken = compoundRegistry.getCToken(_debtToken);
894         enterMarketIfNeeded(_wallet, dToken, address(comptroller));
895         borrow(_wallet, dToken, _debtAmount);
896         emit DebtAdded(address(_wallet), _loanId, _debtToken, _debtAmount);
897     }
898 
899     /**
900      * @dev Decreases the debt by repaying some token from a loan identified by its ID.
901      * @param _wallet The target wallet.
902      * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
903      * @param _debtToken The token to repay.
904      * @param _debtAmount The amount of token to repay.
905      */
906     function removeDebt(
907         BaseWallet _wallet, 
908         bytes32 _loanId, 
909         address _debtToken, 
910         uint256 _debtAmount
911     ) 
912         external
913         onlyWalletOwner(_wallet)
914         onlyWhenUnlocked(_wallet)
915     {
916         address dToken = compoundRegistry.getCToken(_debtToken);
917         repayBorrow(_wallet, dToken, _debtAmount);
918         exitMarketIfNeeded(_wallet, dToken, address(comptroller));
919         emit DebtRemoved(address(_wallet), _loanId, _debtToken, _debtAmount);
920     }
921 
922     /**
923      * @dev Gets information about a loan identified by its ID.
924      * @param _wallet The target wallet.
925      * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans
926      * @return a status [0: no loan, 1: loan is safe, 2: loan is unsafe and can be liquidated]
927      * and a value (in ETH) representing the value that could still be borrowed when status = 1; or the value of the collateral 
928      * that should be added to avoid liquidation when status = 2.  
929      */
930     function getLoan(
931         BaseWallet _wallet, 
932         bytes32 _loanId
933     ) 
934         external 
935         view 
936         returns (uint8 _status, uint256 _ethValue)
937     {
938         (uint error, uint liquidity, uint shortfall) = comptroller.getAccountLiquidity(address(_wallet));
939         require(error == 0, "Compound: failed to get account liquidity");
940         if(liquidity > 0) {
941             return (1, liquidity);
942         }
943         if(shortfall > 0) {
944             return (2, shortfall);
945         }
946         return (0,0);
947     }
948 
949     /* ********************************** Implementation of Invest ************************************* */
950 
951     /**
952      * @dev Invest tokens for a given period.
953      * @param _wallet The target wallet.
954      * @param _token The token address.
955      * @param _amount The amount of tokens to invest.
956      * @param _period The period over which the tokens may be locked in the investment (optional).
957      * @return The exact amount of tokens that have been invested. 
958      */
959     function addInvestment(
960         BaseWallet _wallet, 
961         address _token, 
962         uint256 _amount, 
963         uint256 _period
964     ) 
965         external 
966         onlyWalletOwner(_wallet)
967         onlyWhenUnlocked(_wallet)
968         returns (uint256 _invested)
969     {
970         address cToken = compoundRegistry.getCToken(_token);
971         mint(_wallet, cToken, _token, _amount);
972         _invested = _amount;
973         emit InvestmentAdded(address(_wallet), _token, _amount, _period);
974     }
975 
976     /**
977      * @dev Exit invested postions.
978      * @param _wallet The target wallet.
979      * @param _token The token address.
980      * @param _fraction The fraction of invested tokens to exit in per 10000. 
981      */
982     function removeInvestment(
983         BaseWallet _wallet, 
984         address _token, 
985         uint256 _fraction
986     )
987         external
988         onlyWalletOwner(_wallet)
989         onlyWhenUnlocked(_wallet)
990     {
991         require(_fraction <= 10000, "CompoundV2: invalid fraction value");
992         address cToken = compoundRegistry.getCToken(_token);
993         uint shares = CToken(cToken).balanceOf(address(_wallet));
994         redeem(_wallet, cToken, shares.mul(_fraction).div(10000));
995         emit InvestmentRemoved(address(_wallet), _token, _fraction);
996     }
997 
998     /**
999      * @dev Get the amount of investment in a given token.
1000      * @param _wallet The target wallet.
1001      * @param _token The token address.
1002      * @return The value in tokens of the investment (including interests) and the time at which the investment can be removed.
1003      */
1004     function getInvestment(
1005         BaseWallet _wallet, 
1006         address _token
1007     ) 
1008         external 
1009         view
1010         returns (uint256 _tokenValue, uint256 _periodEnd) 
1011     {
1012         address cToken = compoundRegistry.getCToken(_token);
1013         uint amount = CToken(cToken).balanceOf(address(_wallet));
1014         uint exchangeRateMantissa = CToken(cToken).exchangeRateStored();
1015         _tokenValue = amount.mul(exchangeRateMantissa).div(10 ** 18);
1016         _periodEnd = 0;
1017     }
1018 
1019     /* ****************************************** Compound wrappers ******************************************* */
1020 
1021     /**
1022      * @dev Adds underlying tokens to a cToken contract.
1023      * @param _wallet The target wallet.
1024      * @param _cToken The cToken contract.
1025      * @param _token The underlying token.
1026      * @param _amount The amount of underlying token to add.
1027      */
1028     function mint(BaseWallet _wallet, address _cToken, address _token, uint256 _amount) internal {
1029         require(_cToken != address(0), "Compound: No market for target token");
1030         require(_amount > 0, "Compound: amount cannot be 0");
1031         if(_token == ETH_TOKEN_ADDRESS) {
1032             _wallet.invoke(_cToken, _amount, abi.encodeWithSignature("mint()"));
1033         }
1034         else {
1035             _wallet.invoke(_token, 0, abi.encodeWithSignature("approve(address,uint256)", _cToken, _amount));
1036             _wallet.invoke(_cToken, 0, abi.encodeWithSignature("mint(uint256)", _amount));
1037         }
1038     }
1039 
1040     /**
1041      * @dev Redeems underlying tokens from a cToken contract.
1042      * @param _wallet The target wallet.
1043      * @param _cToken The cToken contract.
1044      * @param _amount The amount of cToken to redeem.
1045      */
1046     function redeem(BaseWallet _wallet, address _cToken, uint256 _amount) internal {     
1047         require(_cToken != address(0), "Compound: No market for target token");   
1048         require(_amount > 0, "Compound: amount cannot be 0");
1049         _wallet.invoke(_cToken, 0, abi.encodeWithSignature("redeem(uint256)", _amount));
1050     }
1051 
1052     /**
1053      * @dev Redeems underlying tokens from a cToken contract.
1054      * @param _wallet The target wallet.
1055      * @param _cToken The cToken contract.
1056      * @param _amount The amount of underlying token to redeem.
1057      */
1058     function redeemUnderlying(BaseWallet _wallet, address _cToken, uint256 _amount) internal {     
1059         require(_cToken != address(0), "Compound: No market for target token");   
1060         require(_amount > 0, "Compound: amount cannot be 0");
1061         _wallet.invoke(_cToken, 0, abi.encodeWithSignature("redeemUnderlying(uint256)", _amount));
1062     }
1063 
1064     /**
1065      * @dev Borrows underlying tokens from a cToken contract.
1066      * @param _wallet The target wallet.
1067      * @param _cToken The cToken contract.
1068      * @param _amount The amount of underlying tokens to borrow.
1069      */
1070     function borrow(BaseWallet _wallet, address _cToken, uint256 _amount) internal {
1071         require(_cToken != address(0), "Compound: No market for target token");
1072         require(_amount > 0, "Compound: amount cannot be 0");
1073         _wallet.invoke(_cToken, 0, abi.encodeWithSignature("borrow(uint256)", _amount));
1074     }
1075 
1076     /**
1077      * @dev Repays some borrowed underlying tokens to a cToken contract.
1078      * @param _wallet The target wallet.
1079      * @param _cToken The cToken contract.
1080      * @param _amount The amount of underlying to repay.
1081      */
1082     function repayBorrow(BaseWallet _wallet, address _cToken, uint256 _amount) internal {
1083         require(_cToken != address(0), "Compound: No market for target token");
1084         require(_amount > 0, "Compound: amount cannot be 0");
1085         string memory symbol = CToken(_cToken).symbol();
1086         if(keccak256(abi.encodePacked(symbol)) == keccak256(abi.encodePacked("cETH"))) {
1087             _wallet.invoke(_cToken, _amount, abi.encodeWithSignature("repayBorrow()"));
1088         }
1089         else { 
1090             address token = CToken(_cToken).underlying();
1091             _wallet.invoke(token, 0, abi.encodeWithSignature("approve(address,uint256)", _cToken, _amount));
1092             _wallet.invoke(_cToken, 0, abi.encodeWithSignature("repayBorrow(uint256)", _amount));
1093         }
1094     }
1095 
1096     /**
1097      * @dev Enters a cToken market if it was not entered before.
1098      * @param _wallet The target wallet.
1099      * @param _cToken The cToken contract.
1100      * @param _comptroller The comptroller contract.
1101      */
1102     function enterMarketIfNeeded(BaseWallet _wallet, address _cToken, address _comptroller) internal {
1103         bool isEntered = Comptroller(_comptroller).checkMembership(address(_wallet), CToken(_cToken));
1104         if(!isEntered) {
1105             address[] memory market = new address[](1);
1106             market[0] = _cToken;
1107             _wallet.invoke(_comptroller, 0, abi.encodeWithSignature("enterMarkets(address[])", market));
1108         }
1109     }
1110 
1111     /**
1112      * @dev Exits a cToken market if there is no more collateral and debt.
1113      * @param _wallet The target wallet.
1114      * @param _cToken The cToken contract.
1115      * @param _comptroller The comptroller contract.
1116      */
1117     function exitMarketIfNeeded(BaseWallet _wallet, address _cToken, address _comptroller) internal {
1118         uint collateral = CToken(_cToken).balanceOf(address(_wallet));
1119         uint debt = CToken(_cToken).borrowBalanceStored(address(_wallet));
1120         if(collateral == 0 && debt == 0) {
1121             _wallet.invoke(_comptroller, 0, abi.encodeWithSignature("exitMarket(address)", _cToken));
1122         }
1123     }
1124 }