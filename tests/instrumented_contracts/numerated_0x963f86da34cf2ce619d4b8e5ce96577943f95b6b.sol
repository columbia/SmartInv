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
92 // Interface to MakerDAO's Tub contract, used to manage CDPs
93 contract IMakerCdp {
94     IDSValue  public pep; // MKR price feed
95     IMakerVox public vox; // DAI price feed
96 
97     function sai() external view returns (address);  // DAI
98     function skr() external view returns (address);  // PETH
99     function gem() external view returns (address);  // WETH
100     function gov() external view returns (address);  // MKR
101 
102     function lad(bytes32 cup) external view returns (address);
103     function ink(bytes32 cup) external view returns (uint);
104     function tab(bytes32 cup) external returns (uint);
105     function rap(bytes32 cup) external returns (uint);
106 
107     function tag() public view returns (uint wad);
108     function mat() public view returns (uint ray);
109     function per() public view returns (uint ray);
110     function safe(bytes32 cup) external returns (bool);
111     function ask(uint wad) public view returns (uint);
112     function bid(uint wad) public view returns (uint);
113 
114     function open() external returns (bytes32 cup);
115     function join(uint wad) external; // Join PETH
116     function exit(uint wad) external; // Exit PETH
117     function give(bytes32 cup, address guy) external;
118     function lock(bytes32 cup, uint wad) external;
119     function free(bytes32 cup, uint wad) external;
120     function draw(bytes32 cup, uint wad) external;
121     function wipe(bytes32 cup, uint wad) external;
122     function shut(bytes32 cup) external;
123     function bite(bytes32 cup) external;
124 }
125 
126 interface IMakerVox {
127     function par() external returns (uint);
128 }
129 
130 interface IDSValue {
131     function peek() external view returns (bytes32, bool);
132     function read() external view returns (bytes32);
133     function poke(bytes32 wut) external;
134     function void() external;
135 } 
136 
137 interface UniswapFactory {
138     function getExchange(address _token) external view returns(address);
139 }
140 
141 interface UniswapExchange {
142     function getEthToTokenOutputPrice(uint256 _tokens_bought) external view returns (uint256);
143     function getEthToTokenInputPrice(uint256 _eth_sold) external view returns (uint256);
144     function getTokenToEthOutputPrice(uint256 _eth_bought) external view returns (uint256);
145     function getTokenToEthInputPrice(uint256 _tokens_sold) external view returns (uint256);
146 }
147 
148 /**
149  * @title Interface for a contract that can loan tokens to a wallet.
150  * @author Julien Niset - <julien@argent.xyz>
151  */
152 interface Loan {
153 
154     event LoanOpened(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount, address _debtToken, uint256 _debtAmount);
155     event LoanClosed(address indexed _wallet, bytes32 indexed _loanId);
156     event CollateralAdded(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount);
157     event CollateralRemoved(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount);
158     event DebtAdded(address indexed _wallet, bytes32 indexed _loanId, address _debtToken, uint256 _debtAmount);
159     event DebtRemoved(address indexed _wallet, bytes32 indexed _loanId, address _debtToken, uint256 _debtAmount);
160 
161     /**
162      * @dev Opens a collateralized loan.
163      * @param _wallet The target wallet.
164      * @param _collateral The token used as a collateral.
165      * @param _collateralAmount The amount of collateral token provided.
166      * @param _debtToken The token borrowed.
167      * @param _debtAmount The amount of tokens borrowed.
168      * @return (optional) An ID for the loan when the provider enables users to create multiple distinct loans.
169      */
170     function openLoan(
171         BaseWallet _wallet, 
172         address _collateral, 
173         uint256 _collateralAmount, 
174         address _debtToken, 
175         uint256 _debtAmount
176     ) 
177         external 
178         returns (bytes32 _loanId);
179 
180     /**
181      * @dev Closes a collateralized loan by repaying all debts (plus interest) and redeeming all collateral (plus interest).
182      * @param _wallet The target wallet.
183      * @param _loanId The ID of the loan if any, 0 otherwise.
184      */
185     function closeLoan(
186         BaseWallet _wallet, 
187         bytes32 _loanId
188     ) 
189         external;
190 
191     /**
192      * @dev Adds collateral to a loan identified by its ID.
193      * @param _wallet The target wallet.
194      * @param _loanId The ID of the loan if any, 0 otherwise.
195      * @param _collateral The token used as a collateral.
196      * @param _collateralAmount The amount of collateral to add.
197      */
198     function addCollateral(
199         BaseWallet _wallet, 
200         bytes32 _loanId, 
201         address _collateral, 
202         uint256 _collateralAmount
203     ) 
204         external;
205 
206     /**
207      * @dev Removes collateral from a loan identified by its ID.
208      * @param _wallet The target wallet.
209      * @param _loanId The ID of the loan if any, 0 otherwise.
210      * @param _collateral The token used as a collateral.
211      * @param _collateralAmount The amount of collateral to remove.
212      */
213     function removeCollateral(
214         BaseWallet _wallet, 
215         bytes32 _loanId, 
216         address _collateral, 
217         uint256 _collateralAmount
218     ) 
219         external;
220 
221     /**
222      * @dev Increases the debt by borrowing more token from a loan identified by its ID.
223      * @param _wallet The target wallet.
224      * @param _loanId The ID of the loan if any, 0 otherwise.
225      * @param _debtToken The token borrowed.
226      * @param _debtAmount The amount of token to borrow.
227      */
228     function addDebt(
229         BaseWallet _wallet, 
230         bytes32 _loanId, 
231         address _debtToken, 
232         uint256 _debtAmount
233     ) 
234         external;
235 
236     /**
237      * @dev Decreases the debt by repaying some token from a loan identified by its ID.
238      * @param _wallet The target wallet.
239      * @param _loanId The ID of the loan if any, 0 otherwise.
240      * @param _debtToken The token to repay.
241      * @param _debtAmount The amount of token to repay.
242      */
243     function removeDebt(
244         BaseWallet _wallet, 
245         bytes32 _loanId, 
246         address _debtToken, 
247         uint256 _debtAmount
248     ) 
249         external;
250 
251     /**
252      * @dev Gets information about a loan identified by its ID.
253      * @param _wallet The target wallet.
254      * @param _loanId The ID of the loan if any, 0 otherwise.
255      * @return a status [0: no loan, 1: loan is safe, 2: loan is unsafe and can be liquidated, 3: unable to provide info]
256      * and a value (in ETH) representing the value that could still be borrowed when status = 1; or the value of the collateral 
257      * that should be added to avoid liquidation when status = 2.     
258      */
259     function getLoan(
260         BaseWallet _wallet, 
261         bytes32 _loanId
262     ) 
263         external 
264         view 
265         returns (uint8 _status, uint256 _ethValue);
266 }
267 
268 /**
269  * @title SafeMath
270  * @dev Math operations with safety checks that throw on error
271  */
272 library SafeMath {
273 
274     /**
275     * @dev Multiplies two numbers, reverts on overflow.
276     */
277     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
279         // benefit is lost if 'b' is also tested.
280         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
281         if (a == 0) {
282             return 0;
283         }
284 
285         uint256 c = a * b;
286         require(c / a == b);
287 
288         return c;
289     }
290 
291     /**
292     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
293     */
294     function div(uint256 a, uint256 b) internal pure returns (uint256) {
295         require(b > 0); // Solidity only automatically asserts when dividing by 0
296         uint256 c = a / b;
297         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
298 
299         return c;
300     }
301 
302     /**
303     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
304     */
305     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
306         require(b <= a);
307         uint256 c = a - b;
308 
309         return c;
310     }
311 
312     /**
313     * @dev Adds two numbers, reverts on overflow.
314     */
315     function add(uint256 a, uint256 b) internal pure returns (uint256) {
316         uint256 c = a + b;
317         require(c >= a);
318 
319         return c;
320     }
321 
322     /**
323     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
324     * reverts when dividing by zero.
325     */
326     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
327         require(b != 0);
328         return a % b;
329     }
330 
331     /**
332     * @dev Returns ceil(a / b).
333     */
334     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
335         uint256 c = a / b;
336         if(a % b == 0) {
337             return c;
338         }
339         else {
340             return c + 1;
341         }
342     }
343 
344     // from DSMath - operations on fixed precision floats
345 
346     uint256 constant WAD = 10 ** 18;
347     uint256 constant RAY = 10 ** 27;
348 
349     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
350         z = add(mul(x, y), WAD / 2) / WAD;
351     }
352     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
353         z = add(mul(x, y), RAY / 2) / RAY;
354     }
355     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
356         z = add(mul(x, WAD), y / 2) / y;
357     }
358     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
359         z = add(mul(x, RAY), y / 2) / y;
360     }
361 }
362 
363 /**
364  * @title BaseModule
365  * @dev Basic module that contains some methods common to all modules.
366  * @author Julien Niset - <julien@argent.im>
367  */
368 contract BaseModule is Module {
369 
370     // The adddress of the module registry.
371     ModuleRegistry internal registry;
372 
373     event ModuleCreated(bytes32 name);
374     event ModuleInitialised(address wallet);
375 
376     constructor(ModuleRegistry _registry, bytes32 _name) public {
377         registry = _registry;
378         emit ModuleCreated(_name);
379     }
380 
381     /**
382      * @dev Throws if the sender is not the target wallet of the call.
383      */
384     modifier onlyWallet(BaseWallet _wallet) {
385         require(msg.sender == address(_wallet), "BM: caller must be wallet");
386         _;
387     }
388 
389     /**
390      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
391      */
392     modifier onlyWalletOwner(BaseWallet _wallet) {
393         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
394         _;
395     }
396 
397     /**
398      * @dev Throws if the sender is not the owner of the target wallet.
399      */
400     modifier strictOnlyWalletOwner(BaseWallet _wallet) {
401         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
402         _;
403     }
404 
405     /**
406      * @dev Inits the module for a wallet by logging an event.
407      * The method can only be called by the wallet itself.
408      * @param _wallet The wallet.
409      */
410     function init(BaseWallet _wallet) external onlyWallet(_wallet) {
411         emit ModuleInitialised(address(_wallet));
412     }
413 
414     /**
415      * @dev Adds a module to a wallet. First checks that the module is registered.
416      * @param _wallet The target wallet.
417      * @param _module The modules to authorise.
418      */
419     function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
420         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
421         _wallet.authoriseModule(address(_module), true);
422     }
423 
424     /**
425     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
426     * module by mistake and transfer them to the Module Registry. 
427     * @param _token The token to recover.
428     */
429     function recoverToken(address _token) external {
430         uint total = ERC20(_token).balanceOf(address(this));
431         ERC20(_token).transfer(address(registry), total);
432     }
433 
434     /**
435      * @dev Helper method to check if an address is the owner of a target wallet.
436      * @param _wallet The target wallet.
437      * @param _addr The address.
438      */
439     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
440         return _wallet.owner() == _addr;
441     }
442 }
443 
444 /**
445  * @title RelayerModule
446  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer. 
447  * @author Julien Niset - <julien@argent.im>
448  */
449 contract RelayerModule is Module {
450 
451     uint256 constant internal BLOCKBOUND = 10000;
452 
453     mapping (address => RelayerConfig) public relayer; 
454 
455     struct RelayerConfig {
456         uint256 nonce;
457         mapping (bytes32 => bool) executedTx;
458     }
459 
460     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
461 
462     /**
463      * @dev Throws if the call did not go through the execute() method.
464      */
465     modifier onlyExecute {
466         require(msg.sender == address(this), "RM: must be called via execute()");
467         _;
468     }
469 
470     /* ***************** Abstract method ************************* */
471 
472     /**
473     * @dev Gets the number of valid signatures that must be provided to execute a
474     * specific relayed transaction.
475     * @param _wallet The target wallet.
476     * @param _data The data of the relayed transaction.
477     * @return The number of required signatures.
478     */
479     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);
480 
481     /**
482     * @dev Validates the signatures provided with a relayed transaction.
483     * The method MUST throw if one or more signatures are not valid.
484     * @param _wallet The target wallet.
485     * @param _data The data of the relayed transaction.
486     * @param _signHash The signed hash representing the relayed transaction.
487     * @param _signatures The signatures as a concatenated byte array.
488     */
489     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool);
490 
491     /* ************************************************************ */
492 
493     /**
494     * @dev Executes a relayed transaction.
495     * @param _wallet The target wallet.
496     * @param _data The data for the relayed transaction
497     * @param _nonce The nonce used to prevent replay attacks.
498     * @param _signatures The signatures as a concatenated byte array.
499     * @param _gasPrice The gas price to use for the gas refund.
500     * @param _gasLimit The gas limit to use for the gas refund.
501     */
502     function execute(
503         BaseWallet _wallet,
504         bytes calldata _data, 
505         uint256 _nonce, 
506         bytes calldata _signatures, 
507         uint256 _gasPrice,
508         uint256 _gasLimit
509     )
510         external
511         returns (bool success)
512     {
513         uint startGas = gasleft();
514         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
515         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
516         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
517         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
518         if((requiredSignatures * 65) == _signatures.length) {
519             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
520                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
521                     // solium-disable-next-line security/no-call-value
522                     (success,) = address(this).call(_data);
523                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
524                 }
525             }
526         }
527         emit TransactionExecuted(address(_wallet), success, signHash); 
528     }
529 
530     /**
531     * @dev Gets the current nonce for a wallet.
532     * @param _wallet The target wallet.
533     */
534     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
535         return relayer[address(_wallet)].nonce;
536     }
537 
538     /**
539     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
540     * @param _from The starting address for the relayed transaction (should be the module)
541     * @param _to The destination address for the relayed transaction (should be the wallet)
542     * @param _value The value for the relayed transaction
543     * @param _data The data for the relayed transaction
544     * @param _nonce The nonce used to prevent replay attacks.
545     * @param _gasPrice The gas price to use for the gas refund.
546     * @param _gasLimit The gas limit to use for the gas refund.
547     */
548     function getSignHash(
549         address _from,
550         address _to, 
551         uint256 _value, 
552         bytes memory _data, 
553         uint256 _nonce,
554         uint256 _gasPrice,
555         uint256 _gasLimit
556     ) 
557         internal 
558         pure
559         returns (bytes32) 
560     {
561         return keccak256(
562             abi.encodePacked(
563                 "\x19Ethereum Signed Message:\n32",
564                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
565         ));
566     }
567 
568     /**
569     * @dev Checks if the relayed transaction is unique.
570     * @param _wallet The target wallet.
571     * @param _nonce The nonce
572     * @param _signHash The signed hash of the transaction
573     */
574     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
575         if(relayer[address(_wallet)].executedTx[_signHash] == true) {
576             return false;
577         }
578         relayer[address(_wallet)].executedTx[_signHash] = true;
579         return true;
580     }
581 
582     /**
583     * @dev Checks that a nonce has the correct format and is valid. 
584     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
585     * @param _wallet The target wallet.
586     * @param _nonce The nonce
587     */
588     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
589         if(_nonce <= relayer[address(_wallet)].nonce) {
590             return false;
591         }   
592         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
593         if(nonceBlock > block.number + BLOCKBOUND) {
594             return false;
595         }
596         relayer[address(_wallet)].nonce = _nonce;
597         return true;    
598     }
599 
600     /**
601     * @dev Recovers the signer at a given position from a list of concatenated signatures.
602     * @param _signedHash The signed hash
603     * @param _signatures The concatenated signatures.
604     * @param _index The index of the signature to recover.
605     */
606     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
607         uint8 v;
608         bytes32 r;
609         bytes32 s;
610         // we jump 32 (0x20) as the first slot of bytes contains the length
611         // we jump 65 (0x41) per signature
612         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
613         // solium-disable-next-line security/no-inline-assembly
614         assembly {
615             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
616             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
617             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
618         }
619         require(v == 27 || v == 28); 
620         return ecrecover(_signedHash, v, r, s);
621     }
622 
623     /**
624     * @dev Refunds the gas used to the Relayer. 
625     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
626     * @param _wallet The target wallet.
627     * @param _gasUsed The gas used.
628     * @param _gasPrice The gas price for the refund.
629     * @param _gasLimit The gas limit for the refund.
630     * @param _signatures The number of signatures used in the call.
631     * @param _relayer The address of the Relayer.
632     */
633     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
634         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
635         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
636         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
637             if(_gasPrice > tx.gasprice) {
638                 amount = amount * tx.gasprice;
639             }
640             else {
641                 amount = amount * _gasPrice;
642             }
643             _wallet.invoke(_relayer, amount, "");
644         }
645     }
646 
647     /**
648     * @dev Returns false if the refund is expected to fail.
649     * @param _wallet The target wallet.
650     * @param _gasUsed The expected gas used.
651     * @param _gasPrice The expected gas price for the refund.
652     */
653     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
654         if(_gasPrice > 0 
655             && _signatures > 1 
656             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
657             return false;
658         }
659         return true;
660     }
661 
662     /**
663     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
664     * as the wallet passed as the input of the execute() method. 
665     @return false if the addresses are different.
666     */
667     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
668         require(_data.length >= 36, "RM: Invalid dataWallet");
669         address dataWallet;
670         // solium-disable-next-line security/no-inline-assembly
671         assembly {
672             //_data = {length:32}{sig:4}{_wallet:32}{...}
673             dataWallet := mload(add(_data, 0x24))
674         }
675         return dataWallet == _wallet;
676     }
677 
678     /**
679     * @dev Parses the data to extract the method signature. 
680     */
681     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
682         require(_data.length >= 4, "RM: Invalid functionPrefix");
683         // solium-disable-next-line security/no-inline-assembly
684         assembly {
685             prefix := mload(add(_data, 0x20))
686         }
687     }
688 }
689 
690 /**
691  * @title OnlyOwnerModule
692  * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
693  * must be called with one signature frm the owner.
694  * @author Julien Niset - <julien@argent.im>
695  */
696 contract OnlyOwnerModule is BaseModule, RelayerModule {
697 
698     // *************** Implementation of RelayerModule methods ********************* //
699 
700     // Overrides to use the incremental nonce and save some gas
701     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
702         return checkAndUpdateNonce(_wallet, _nonce);
703     }
704 
705     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool) {
706         address signer = recoverSigner(_signHash, _signatures, 0);
707         return isOwner(_wallet, signer); // "OOM: signer must be owner"
708     }
709 
710     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256) {
711         return 1;
712     }
713 }
714 
715 /**
716  * @title MakerManager
717  * @dev Module to borrow tokens with MakerDAO
718  * @author Olivier VDB - <olivier@argent.xyz>, Julien Niset - <julien@argent.xyz>
719  */
720 contract MakerManager is Loan, BaseModule, RelayerModule, OnlyOwnerModule {
721 
722     bytes32 constant NAME = "MakerManager";
723 
724     // The Guardian storage 
725     GuardianStorage public guardianStorage;
726     // The Maker Tub contract
727     IMakerCdp public makerCdp;
728     // The Uniswap Factory contract
729     UniswapFactory public uniswapFactory;
730 
731     // Mock token address for ETH
732     address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
733 
734     // Method signatures to reduce gas cost at depoyment
735     bytes4 constant internal CDP_DRAW = bytes4(keccak256("draw(bytes32,uint256)"));
736     bytes4 constant internal CDP_WIPE = bytes4(keccak256("wipe(bytes32,uint256)"));
737     bytes4 constant internal CDP_SHUT = bytes4(keccak256("shut(bytes32)"));
738     bytes4 constant internal CDP_JOIN = bytes4(keccak256("join(uint256)"));
739     bytes4 constant internal CDP_LOCK = bytes4(keccak256("lock(bytes32,uint256)"));
740     bytes4 constant internal CDP_FREE = bytes4(keccak256("free(bytes32,uint256)"));
741     bytes4 constant internal CDP_EXIT = bytes4(keccak256("exit(uint256)"));
742     bytes4 constant internal WETH_DEPOSIT = bytes4(keccak256("deposit()"));
743     bytes4 constant internal WETH_WITHDRAW = bytes4(keccak256("withdraw(uint256)"));
744     bytes4 constant internal ERC20_APPROVE = bytes4(keccak256("approve(address,uint256)"));
745     bytes4 constant internal ETH_TOKEN_SWAP_OUTPUT = bytes4(keccak256("ethToTokenSwapOutput(uint256,uint256)"));
746     bytes4 constant internal ETH_TOKEN_SWAP_INPUT = bytes4(keccak256("ethToTokenSwapInput(uint256,uint256)"));
747     bytes4 constant internal TOKEN_ETH_SWAP_INPUT = bytes4(keccak256("tokenToEthSwapInput(uint256,uint256,uint256)"));
748 
749     using SafeMath for uint256;
750 
751     /**
752      * @dev Throws if the wallet is locked.
753      */
754     modifier onlyWhenUnlocked(BaseWallet _wallet) {
755         // solium-disable-next-line security/no-block-members
756         require(!guardianStorage.isLocked(_wallet), "MakerManager: wallet must be unlocked");
757         _;
758     }
759 
760     constructor(
761         ModuleRegistry _registry,
762         GuardianStorage _guardianStorage,
763         IMakerCdp _makerCdp,
764         UniswapFactory _uniswapFactory
765     )
766         BaseModule(_registry, NAME)
767         public
768     {
769         guardianStorage = _guardianStorage;
770         makerCdp = _makerCdp;
771         uniswapFactory = _uniswapFactory;
772     }
773 
774     /* ********************************** Implementation of Loan ************************************* */
775 
776    /**
777      * @dev Opens a collateralized loan.
778      * @param _wallet The target wallet.
779      * @param _collateral The token used as a collateral (must be 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE).
780      * @param _collateralAmount The amount of collateral token provided.
781      * @param _debtToken The token borrowed (must be the address of the DAI contract).
782      * @param _debtAmount The amount of tokens borrowed.
783      * @return The ID of the created CDP.
784      */
785     function openLoan(
786         BaseWallet _wallet, 
787         address _collateral, 
788         uint256 _collateralAmount, 
789         address _debtToken, 
790         uint256 _debtAmount
791     ) 
792         external 
793         onlyWalletOwner(_wallet)
794         onlyWhenUnlocked(_wallet)
795         returns (bytes32 _loanId)
796     {
797         require(_collateral == ETH_TOKEN_ADDRESS, "Maker: collateral must be ETH");
798         require(_debtToken == makerCdp.sai(), "Maker: debt token must be DAI");
799         _loanId = openCdp(_wallet, _collateralAmount, _debtAmount, makerCdp);
800         emit LoanOpened(address(_wallet), _loanId, _collateral, _collateralAmount, _debtToken, _debtAmount);
801     }
802 
803     /**
804      * @dev Closes a collateralized loan by repaying all debts (plus interest) and redeeming all collateral (plus interest).
805      * @param _wallet The target wallet.
806      * @param _loanId The ID of the target CDP.
807      */
808     function closeLoan(
809         BaseWallet _wallet, 
810         bytes32 _loanId
811     ) 
812         external
813         onlyWalletOwner(_wallet)
814         onlyWhenUnlocked(_wallet)
815     {
816         closeCdp(_wallet, _loanId, makerCdp, uniswapFactory);
817         emit LoanClosed(address(_wallet), _loanId);
818     }
819 
820     /**
821      * @dev Adds collateral to a loan identified by its ID.
822      * @param _wallet The target wallet.
823      * @param _loanId The ID of the target CDP.
824      * @param _collateral The token used as a collateral (must be 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE).
825      * @param _collateralAmount The amount of collateral to add.
826      */
827     function addCollateral(
828         BaseWallet _wallet, 
829         bytes32 _loanId, 
830         address _collateral, 
831         uint256 _collateralAmount
832     ) 
833         external
834         onlyWalletOwner(_wallet)
835         onlyWhenUnlocked(_wallet)
836     {
837         require(_collateral == ETH_TOKEN_ADDRESS, "Maker: collateral must be ETH");
838         addCollateral(_wallet, _loanId, _collateralAmount, makerCdp);
839         emit CollateralAdded(address(_wallet), _loanId, _collateral, _collateralAmount);
840     }
841 
842     /**
843      * @dev Removes collateral from a loan identified by its ID.
844      * @param _wallet The target wallet.
845      * @param _loanId The ID of the target CDP.
846      * @param _collateral The token used as a collateral (must be 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE).
847      * @param _collateralAmount The amount of collateral to remove.
848      */
849     function removeCollateral(
850         BaseWallet _wallet, 
851         bytes32 _loanId, 
852         address _collateral, 
853         uint256 _collateralAmount
854     ) 
855         external 
856         onlyWalletOwner(_wallet)
857         onlyWhenUnlocked(_wallet)
858     {
859         require(_collateral == ETH_TOKEN_ADDRESS, "Maker: collateral must be ETH");
860         removeCollateral(_wallet, _loanId, _collateralAmount, makerCdp);
861         emit CollateralRemoved(address(_wallet), _loanId, _collateral, _collateralAmount);
862     }
863 
864     /**
865      * @dev Increases the debt by borrowing more token from a loan identified by its ID.
866      * @param _wallet The target wallet.
867      * @param _loanId The ID of the target CDP.
868      * @param _debtToken The token borrowed (must be the address of the DAI contract).
869      * @param _debtAmount The amount of token to borrow.
870      */
871     function addDebt(
872         BaseWallet _wallet,
873         bytes32 _loanId,
874         address _debtToken,
875         uint256 _debtAmount
876     )
877         external
878         onlyWalletOwner(_wallet)
879         onlyWhenUnlocked(_wallet)
880     {
881         require(_debtToken == makerCdp.sai(), "Maker: debt token must be DAI");
882         addDebt(_wallet, _loanId, _debtAmount, makerCdp);
883         emit DebtAdded(address(_wallet), _loanId, _debtToken, _debtAmount);
884     }
885 
886     /**
887      * @dev Decreases the debt by repaying some token from a loan identified by its ID.
888      * @param _wallet The target wallet.
889      * @param _loanId The ID of the target CDP.
890      * @param _debtToken The token to repay (must be the address of the DAI contract).
891      * @param _debtAmount The amount of token to repay.
892      */
893     function removeDebt(
894         BaseWallet _wallet,
895         bytes32 _loanId,
896         address _debtToken,
897         uint256 _debtAmount
898     )
899         external
900         onlyWalletOwner(_wallet)
901         onlyWhenUnlocked(_wallet)
902     {
903         require(_debtToken == makerCdp.sai(), "Maker: debt token must be DAI");
904         removeDebt(_wallet, _loanId, _debtAmount, makerCdp, uniswapFactory);
905         emit DebtRemoved(address(_wallet), _loanId, _debtToken, _debtAmount);
906     }
907 
908     /**
909      * @dev Gets information about a loan identified by its ID.
910      * @param _wallet The target wallet.
911      * @param _loanId The ID of the target CDP.
912      * @return a status [0: no loan, 1: loan is safe, 2: loan is unsafe and can be liquidated, 3: loan exists but we are unable to provide info] 
913      * and a value (in ETH) representing the value that could still be borrowed when status = 1; or the value of the collateral that should be added to 
914      * avoid liquidation when status = 2.      
915      */
916     function getLoan(
917         BaseWallet _wallet, 
918         bytes32 _loanId
919     ) 
920         external 
921         view 
922         returns (uint8 _status, uint256 _ethValue)
923     {
924         if(exists(_loanId, makerCdp)) {
925             return (3,0);
926         }
927         return (0,0);
928     }
929 
930     /* *********************************** Maker wrappers ************************************* */
931 
932     /* CDP actions */
933 
934     /**
935      * @dev Lets the owner of a wallet open a new CDP. The owner must have enough ether 
936      * in their wallet. The required amount of ether will be automatically converted to 
937      * PETH and used as collateral in the CDP.
938      * @param _wallet The target wallet
939      * @param _pethCollateral The amount of PETH to lock as collateral in the CDP.
940      * @param _daiDebt The amount of DAI to draw from the CDP
941      * @param _makerCdp The Maker CDP contract
942      * @return The id of the created CDP.
943      */
944     function openCdp(
945         BaseWallet _wallet, 
946         uint256 _pethCollateral, 
947         uint256 _daiDebt,
948         IMakerCdp _makerCdp
949     ) 
950         internal 
951         returns (bytes32 _cup)
952     {
953         // Open CDP (CDP owner will be module)
954         _cup = _makerCdp.open();
955         // Transfer CDP ownership to wallet
956         _makerCdp.give(_cup, address(_wallet));
957         // Convert ETH to PETH & lock PETH into CDP
958         lockETH(_wallet, _cup, _pethCollateral, _makerCdp);
959         // Draw DAI from CDP
960         if(_daiDebt > 0) {
961             invokeWallet(_wallet, address(_makerCdp), 0, abi.encodeWithSelector(CDP_DRAW, _cup, _daiDebt));
962         }
963     }
964 
965     /**
966      * @dev Lets the owner of a CDP add more collateral to their CDP. The owner must have enough ether 
967      * in their wallet. The required amount of ether will be automatically converted to 
968      * PETH and locked in the CDP.
969      * @param _wallet The target wallet
970      * @param _cup The id of the CDP.
971      * @param _amount The amount of additional PETH to lock as collateral in the CDP.
972      * @param _makerCdp The Maker CDP contract
973      */
974     function addCollateral(
975         BaseWallet _wallet, 
976         bytes32 _cup,
977         uint256 _amount,
978         IMakerCdp _makerCdp
979     ) 
980         internal
981     {
982         // _wallet must be owner of CDP
983         require(address(_wallet) == _makerCdp.lad(_cup), "CM: not CDP owner");
984         // convert ETH to PETH & lock PETH into CDP
985         lockETH(_wallet, _cup, _amount, _makerCdp);  
986     }
987 
988     /**
989      * @dev Lets the owner of a CDP remove some collateral from their CDP
990      * @param _wallet The target wallet
991      * @param _cup The id of the CDP.
992      * @param _amount The amount of PETH to remove from the CDP.
993      * @param _makerCdp The Maker CDP contract
994      */
995     function removeCollateral(
996         BaseWallet _wallet, 
997         bytes32 _cup,
998         uint256 _amount,
999         IMakerCdp _makerCdp
1000     ) 
1001         internal
1002     {
1003         // unlock PETH from CDP & convert PETH to ETH
1004         freeETH(_wallet, _cup, _amount, _makerCdp);
1005     }
1006 
1007     /**
1008      * @dev Lets the owner of a CDP draw more DAI from their CDP.
1009      * @param _wallet The target wallet
1010      * @param _cup The id of the CDP.
1011      * @param _amount The amount of additional DAI to draw from the CDP.
1012      * @param _makerCdp The Maker CDP contract
1013      */
1014     function addDebt(
1015         BaseWallet _wallet, 
1016         bytes32 _cup,
1017         uint256 _amount,
1018         IMakerCdp _makerCdp
1019     ) 
1020         internal
1021     {
1022         // draw DAI from CDP
1023         invokeWallet(_wallet, address(_makerCdp), 0, abi.encodeWithSelector(CDP_DRAW, _cup, _amount));
1024     }
1025 
1026     /**
1027      * @dev Lets the owner of a CDP partially repay their debt. The repayment is made up of 
1028      * the outstanding DAI debt (including the stability fee if non-zero) plus the MKR governance fee.
1029      * The method will use the user's MKR tokens in priority and will, if needed, convert the required 
1030      * amount of ETH to cover for any missing MKR tokens.
1031      * @param _wallet The target wallet
1032      * @param _cup The id of the CDP.
1033      * @param _amount The amount of DAI debt to repay.
1034      * @param _makerCdp The Maker CDP contract
1035      * @param _uniswapFactory The Uniswap Factory contract.
1036      */
1037     function removeDebt(
1038         BaseWallet _wallet, 
1039         bytes32 _cup,
1040         uint256 _amount,
1041         IMakerCdp _makerCdp,
1042         UniswapFactory _uniswapFactory
1043     ) 
1044         internal
1045     {
1046         // _wallet must be owner of CDP
1047         require(address(_wallet) == _makerCdp.lad(_cup), "CM: not CDP owner");
1048         // get governance fee in MKR
1049         uint256 mkrFee = governanceFeeInMKR(_cup, _amount, _makerCdp);
1050         // get MKR balance
1051         address mkrToken = _makerCdp.gov();
1052         uint256 mkrBalance = ERC20(mkrToken).balanceOf(address(_wallet));
1053         if (mkrBalance < mkrFee) {
1054             // Not enough MKR => Convert some ETH into MKR with Uniswap
1055             address mkrUniswap = _uniswapFactory.getExchange(mkrToken);
1056             uint256 etherValueOfMKR = UniswapExchange(mkrUniswap).getEthToTokenOutputPrice(mkrFee - mkrBalance);
1057             invokeWallet(_wallet, mkrUniswap, etherValueOfMKR, abi.encodeWithSelector(ETH_TOKEN_SWAP_OUTPUT, mkrFee - mkrBalance, block.timestamp));
1058         }
1059         
1060         // get DAI balance
1061         address daiToken =_makerCdp.sai();
1062         uint256 daiBalance = ERC20(daiToken).balanceOf(address(_wallet));
1063         if (daiBalance < _amount) {
1064             // Not enough DAI => Convert some ETH into DAI with Uniswap
1065             address daiUniswap = _uniswapFactory.getExchange(daiToken);
1066             uint256 etherValueOfDAI = UniswapExchange(daiUniswap).getEthToTokenOutputPrice(_amount - daiBalance);
1067             invokeWallet(_wallet, daiUniswap, etherValueOfDAI, abi.encodeWithSelector(ETH_TOKEN_SWAP_OUTPUT, _amount - daiBalance, block.timestamp));
1068         }
1069 
1070         // Approve DAI to let wipe() repay the DAI debt
1071         invokeWallet(_wallet, daiToken, 0, abi.encodeWithSelector(ERC20_APPROVE, address(_makerCdp), _amount));
1072         // Approve MKR to let wipe() pay the MKR governance fee
1073         invokeWallet(_wallet, mkrToken, 0, abi.encodeWithSelector(ERC20_APPROVE, address(_makerCdp), mkrFee));
1074         // repay DAI debt and MKR governance fee
1075         invokeWallet(_wallet, address(_makerCdp), 0, abi.encodeWithSelector(CDP_WIPE, _cup, _amount));
1076     }
1077 
1078     /**
1079      * @dev Lets the owner of a CDP close their CDP. The method will 1) repay all debt 
1080      * and governance fee, 2) free all collateral, and 3) delete the CDP.
1081      * @param _wallet The target wallet
1082      * @param _cup The id of the CDP.
1083      * @param _makerCdp The Maker CDP contract
1084      * @param _uniswapFactory The Uniswap Factory contract.
1085      */
1086     function closeCdp(
1087         BaseWallet _wallet,
1088         bytes32 _cup,
1089         IMakerCdp _makerCdp,
1090         UniswapFactory _uniswapFactory
1091     ) 
1092         internal
1093     {
1094         // repay all debt (in DAI) + stability fee (in DAI) + governance fee (in MKR)
1095         uint debt = daiDebt(_cup, _makerCdp);
1096         if(debt > 0) removeDebt(_wallet, _cup, debt, _makerCdp, _uniswapFactory);
1097         // free all ETH collateral
1098         uint collateral = pethCollateral(_cup, _makerCdp);
1099         if(collateral > 0) removeCollateral(_wallet, _cup, collateral, _makerCdp);
1100         // shut the CDP
1101         invokeWallet(_wallet, address(_makerCdp), 0, abi.encodeWithSelector(CDP_SHUT, _cup));
1102     }
1103 
1104     /* Convenience methods */
1105 
1106     /**
1107      * @dev Returns the amount of PETH collateral locked in a CDP.
1108      * @param _cup The id of the CDP.
1109      * @param _makerCdp The Maker CDP contract
1110      * @return the amount of PETH locked in the CDP.
1111      */
1112     function pethCollateral(bytes32 _cup, IMakerCdp _makerCdp) public view returns (uint256) { 
1113         return _makerCdp.ink(_cup);
1114     }
1115 
1116     /**
1117      * @dev Returns the amount of DAI debt (including the stability fee if non-zero) drawn from a CDP.
1118      * @param _cup The id of the CDP.
1119      * @param _makerCdp The Maker CDP contract
1120      * @return the amount of DAI drawn from the CDP.
1121      */
1122     function daiDebt(bytes32 _cup, IMakerCdp _makerCdp) public returns (uint256) { 
1123         return _makerCdp.tab(_cup);
1124     }
1125 
1126     /**
1127      * @dev Indicates whether a CDP is above the liquidation ratio.
1128      * @param _cup The id of the CDP.
1129      * @param _makerCdp The Maker CDP contract
1130      * @return false if the CDP is in danger of being liquidated.
1131      */
1132     function isSafe(bytes32 _cup, IMakerCdp _makerCdp) public returns (bool) { 
1133         return _makerCdp.safe(_cup);
1134     }
1135 
1136     /**
1137      * @dev Checks if a CDP exists.
1138      * @param _cup The id of the CDP.
1139      * @param _makerCdp The Maker CDP contract
1140      * @return true if the CDP exists, false otherwise.
1141      */
1142     function exists(bytes32 _cup, IMakerCdp _makerCdp) public view returns (bool) { 
1143         return _makerCdp.lad(_cup) != address(0);
1144     }
1145 
1146     /**
1147      * @dev Max amount of DAI that can still be drawn from a CDP while keeping it above the liquidation ratio. 
1148      * @param _cup The id of the CDP.
1149      * @param _makerCdp The Maker CDP contract
1150      * @return the amount of DAI that can still be drawn from a CDP while keeping it above the liquidation ratio. 
1151      */
1152     function maxDaiDrawable(bytes32 _cup, IMakerCdp _makerCdp) public returns (uint256) {
1153         uint256 maxTab = _makerCdp.ink(_cup).rmul(_makerCdp.tag()).rdiv(_makerCdp.vox().par()).rdiv(_makerCdp.mat());
1154         return maxTab.sub(_makerCdp.tab(_cup));
1155     }
1156 
1157     /**
1158      * @dev Min amount of collateral that needs to be added to a CDP to bring it above the liquidation ratio. 
1159      * @param _cup The id of the CDP.
1160      * @param _makerCdp The Maker CDP contract
1161      * @return the amount of collateral that needs to be added to a CDP to bring it above the liquidation ratio.
1162      */
1163     function minCollateralRequired(bytes32 _cup, IMakerCdp _makerCdp) public returns (uint256) {
1164         uint256 minInk = _makerCdp.tab(_cup).rmul(_makerCdp.mat()).rmul(_makerCdp.vox().par()).rdiv(_makerCdp.tag());
1165         return minInk.sub(_makerCdp.ink(_cup));
1166     }
1167 
1168     /**
1169      * @dev Returns the governance fee in MKR.
1170      * @param _cup The id of the CDP.
1171      * @param _daiRefund The amount of DAI debt being repaid.
1172      * @param _makerCdp The Maker CDP contract
1173      * @return the governance fee in MKR
1174      */
1175     function governanceFeeInMKR(bytes32 _cup, uint256 _daiRefund, IMakerCdp _makerCdp) public returns (uint256 _fee) { 
1176         uint debt = daiDebt(_cup, _makerCdp);
1177         if (debt == 0) return 0;
1178         uint256 feeInDAI = _daiRefund.rmul(_makerCdp.rap(_cup).rdiv(debt));
1179         (bytes32 daiPerMKR, bool ok) = _makerCdp.pep().peek();
1180         if (ok && daiPerMKR != 0) _fee = feeInDAI.wdiv(uint(daiPerMKR));
1181     }
1182 
1183     /**
1184      * @dev Returns the total MKR governance fee to be paid before this CDP can be closed.
1185      * @param _cup The id of the CDP.
1186      * @param _makerCdp The Maker CDP contract
1187      * @return the total governance fee in MKR
1188      */
1189     function totalGovernanceFeeInMKR(bytes32 _cup, IMakerCdp _makerCdp) external returns (uint256 _fee) { 
1190         return governanceFeeInMKR(_cup, daiDebt(_cup, _makerCdp), _makerCdp);
1191     }
1192 
1193     /**
1194      * @dev Minimum amount of PETH that must be locked in a CDP for it to be deemed "safe"
1195      * @param _cup The id of the CDP.
1196      * @param _makerCdp The Maker CDP contract
1197      * @return The minimum amount of PETH to lock in the CDP
1198      */
1199     function minRequiredCollateral(bytes32 _cup, IMakerCdp _makerCdp) public returns (uint256 _minCollateral) { 
1200         _minCollateral = daiDebt(_cup, _makerCdp)    // DAI debt
1201             .rmul(_makerCdp.vox().par())         // x ~1 USD/DAI 
1202             .rmul(_makerCdp.mat())               // x 1.5
1203             .rmul(1010000000000000000000000000) // x (1+1%) cushion
1204             .rdiv(_makerCdp.tag());              // ÷ ~170 USD/PETH
1205     }
1206 
1207     /* *********************************** Utilities ************************************* */
1208 
1209     /**
1210      * @dev Converts a user's ETH into PETH and locks the PETH in a CDP
1211      * @param _wallet The target wallet
1212      * @param _cup The id of the CDP.
1213      * @param _pethAmount The amount of PETH to buy and lock
1214      * @param _makerCdp The Maker CDP contract
1215      */
1216     function lockETH(
1217         BaseWallet _wallet, 
1218         bytes32 _cup,
1219         uint256 _pethAmount,
1220         IMakerCdp _makerCdp
1221     ) 
1222         internal 
1223     {
1224         // 1. Convert ETH to PETH
1225         address wethToken = _makerCdp.gem();
1226         // Get WETH/PETH rate
1227         uint ethAmount = _makerCdp.ask(_pethAmount);
1228         // ETH to WETH
1229         invokeWallet(_wallet, wethToken, ethAmount, abi.encodeWithSelector(WETH_DEPOSIT));
1230         // Approve WETH
1231         invokeWallet(_wallet, wethToken, 0, abi.encodeWithSelector(ERC20_APPROVE, address(_makerCdp), ethAmount));
1232         // WETH to PETH
1233         invokeWallet(_wallet, address(_makerCdp), 0, abi.encodeWithSelector(CDP_JOIN, _pethAmount));
1234 
1235         // 2. Lock PETH into CDP
1236         address pethToken = _makerCdp.skr();
1237         // Approve PETH
1238         invokeWallet(_wallet, pethToken, 0, abi.encodeWithSelector(ERC20_APPROVE, address(_makerCdp), _pethAmount));
1239         // lock PETH into CDP
1240         invokeWallet(_wallet, address(_makerCdp), 0, abi.encodeWithSelector(CDP_LOCK, _cup, _pethAmount));
1241     }
1242 
1243     /**
1244      * @dev Unlocks PETH from a user's CDP and converts it back to ETH
1245      * @param _wallet The target wallet
1246      * @param _cup The id of the CDP.
1247      * @param _pethAmount The amount of PETH to unlock and sell
1248      * @param _makerCdp The Maker CDP contract
1249      */
1250     function freeETH(
1251         BaseWallet _wallet, 
1252         bytes32 _cup,
1253         uint256 _pethAmount,
1254         IMakerCdp _makerCdp
1255     ) 
1256         internal 
1257     {
1258         // 1. Unlock PETH
1259 
1260         // Unlock PETH from CDP
1261         invokeWallet(_wallet, address(_makerCdp), 0, abi.encodeWithSelector(CDP_FREE, _cup, _pethAmount));
1262 
1263         // 2. Convert PETH to ETH
1264         address wethToken = _makerCdp.gem();
1265         address pethToken = _makerCdp.skr();
1266         // Approve PETH
1267         invokeWallet(_wallet, pethToken, 0, abi.encodeWithSelector(ERC20_APPROVE, address(_makerCdp), _pethAmount));
1268         // PETH to WETH
1269         invokeWallet(_wallet, address(_makerCdp), 0, abi.encodeWithSelector(CDP_EXIT, _pethAmount));
1270         // Get WETH/PETH rate
1271         uint ethAmount = _makerCdp.bid(_pethAmount);
1272         // WETH to ETH
1273         invokeWallet(_wallet, wethToken, 0, abi.encodeWithSelector(WETH_WITHDRAW, ethAmount));
1274     }
1275 
1276     /**
1277      * @dev Conversion rate between DAI and MKR
1278      * @param _makerCdp The Maker CDP contract
1279      * @return The amount of DAI per MKR
1280      */
1281     function daiPerMkr(IMakerCdp _makerCdp) internal view returns (uint256 _daiPerMKR) {
1282         (bytes32 daiPerMKR_, bool ok) = _makerCdp.pep().peek();
1283         require(ok && daiPerMKR_ != 0, "LM: invalid DAI/MKR rate");
1284         _daiPerMKR = uint256(daiPerMKR_);
1285     }
1286 
1287     /**
1288      * @dev Utility method to invoke a wallet
1289      * @param _wallet The wallet to invoke.
1290      * @param _to The target address.
1291      * @param _value The value.
1292      * @param _data The data.
1293      */
1294     function invokeWallet(BaseWallet _wallet, address _to, uint256 _value, bytes memory _data) internal {
1295         _wallet.invoke(_to, _value, _data);
1296     }
1297 }