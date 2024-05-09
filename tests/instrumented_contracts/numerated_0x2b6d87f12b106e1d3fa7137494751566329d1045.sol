1 pragma solidity ^0.5.4;
2 
3 /**
4  * ERC20 contract interface.
5  */
6 contract ERC20 {
7     function totalSupply() public view returns (uint);
8     function decimals() public view returns (uint);
9     function balanceOf(address tokenOwner) public view returns (uint balance);
10     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 }
15 
16 /**
17  * @title Module
18  * @dev Interface for a module. 
19  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
20  * can never end up in a "frozen" state.
21  * @author Julien Niset - <julien@argent.xyz>
22  */
23 interface Module {
24     function init(BaseWallet _wallet) external;
25     function addModule(BaseWallet _wallet, Module _module) external;
26     function recoverToken(address _token) external;
27 }
28 
29 /**
30  * @title BaseWallet
31  * @dev Simple modular wallet that authorises modules to call its invoke() method.
32  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
33  * @author Julien Niset - <julien@argent.xyz>
34  */
35 contract BaseWallet {
36     address public implementation;
37     address public owner;
38     mapping (address => bool) public authorised;
39     mapping (bytes4 => address) public enabled;
40     uint public modules;
41     function init(address _owner, address[] calldata _modules) external;
42     function authoriseModule(address _module, bool _value) external;
43     function enableStaticCall(address _module, bytes4 _method) external;
44     function setOwner(address _newOwner) external;
45     function invoke(address _target, uint _value, bytes calldata _data) external returns (bytes memory _result);
46     function() external payable;
47 }
48 
49 /**
50  * @title ModuleRegistry
51  * @dev Registry of authorised modules. 
52  * Modules must be registered before they can be authorised on a wallet.
53  * @author Julien Niset - <julien@argent.xyz>
54  */
55 contract ModuleRegistry {
56     function registerModule(address _module, bytes32 _name) external;
57     function deregisterModule(address _module) external;
58     function registerUpgrader(address _upgrader, bytes32 _name) external;
59     function deregisterUpgrader(address _upgrader) external;
60     function recoverToken(address _token) external;
61     function moduleInfo(address _module) external view returns (bytes32);
62     function upgraderInfo(address _upgrader) external view returns (bytes32);
63     function isRegisteredModule(address _module) external view returns (bool);
64     function isRegisteredModule(address[] calldata _modules) external view returns (bool);
65     function isRegisteredUpgrader(address _upgrader) external view returns (bool);
66 }
67 
68 contract TokenPriceProvider {
69     mapping(address => uint256) public cachedPrices;
70     function getEtherValue(uint256 _amount, address _token) external view returns (uint256);
71 }
72 
73 /**
74  * @title GuardianStorage
75  * @dev Contract storing the state of wallets related to guardians and lock.
76  * The contract only defines basic setters and getters with no logic. Only modules authorised
77  * for a wallet can modify its state.
78  * @author Julien Niset - <julien@argent.xyz>
79  * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
80  */
81 contract GuardianStorage {
82     function addGuardian(BaseWallet _wallet, address _guardian) external;
83     function revokeGuardian(BaseWallet _wallet, address _guardian) external;
84     function guardianCount(BaseWallet _wallet) external view returns (uint256);
85     function getGuardians(BaseWallet _wallet) external view returns (address[] memory);
86     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool);
87     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external;
88     function isLocked(BaseWallet _wallet) external view returns (bool);
89     function getLock(BaseWallet _wallet) external view returns (uint256);
90     function getLocker(BaseWallet _wallet) external view returns (address);
91 }
92 
93 /**
94  * @title TransferStorage
95  * @dev Contract storing the state of wallets related to transfers (limit and whitelist).
96  * The contract only defines basic setters and getters with no logic. Only modules authorised
97  * for a wallet can modify its state.
98  * @author Julien Niset - <julien@argent.xyz>
99  */
100 contract TransferStorage {
101     function setWhitelist(BaseWallet _wallet, address _target, uint256 _value) external;
102     function getWhitelist(BaseWallet _wallet, address _target) external view returns (uint256);
103 }
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that throw on error
108  */
109 library SafeMath {
110 
111     /**
112     * @dev Multiplies two numbers, reverts on overflow.
113     */
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b);
124 
125         return c;
126     }
127 
128     /**
129     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
130     */
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b > 0); // Solidity only automatically asserts when dividing by 0
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136         return c;
137     }
138 
139     /**
140     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
141     */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b <= a);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150     * @dev Adds two numbers, reverts on overflow.
151     */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a);
155 
156         return c;
157     }
158 
159     /**
160     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
161     * reverts when dividing by zero.
162     */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b != 0);
165         return a % b;
166     }
167 
168     /**
169     * @dev Returns ceil(a / b).
170     */
171     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
172         uint256 c = a / b;
173         if(a % b == 0) {
174             return c;
175         }
176         else {
177             return c + 1;
178         }
179     }
180 }
181 
182 /**
183  * @title BaseModule
184  * @dev Basic module that contains some methods common to all modules.
185  * @author Julien Niset - <julien@argent.im>
186  */
187 contract BaseModule is Module {
188 
189     // Empty calldata
190     bytes constant internal EMPTY_BYTES = "";
191 
192     // The adddress of the module registry.
193     ModuleRegistry internal registry;
194     // The address of the Guardian storage
195     GuardianStorage internal guardianStorage;
196 
197     /**
198      * @dev Throws if the wallet is locked.
199      */
200     modifier onlyWhenUnlocked(BaseWallet _wallet) {
201         // solium-disable-next-line security/no-block-members
202         require(!guardianStorage.isLocked(_wallet), "BM: wallet must be unlocked");
203         _;
204     }
205 
206     event ModuleCreated(bytes32 name);
207     event ModuleInitialised(address wallet);
208 
209     constructor(ModuleRegistry _registry, GuardianStorage _guardianStorage, bytes32 _name) public {
210         registry = _registry;
211         guardianStorage = _guardianStorage;
212         emit ModuleCreated(_name);
213     }
214 
215     /**
216      * @dev Throws if the sender is not the target wallet of the call.
217      */
218     modifier onlyWallet(BaseWallet _wallet) {
219         require(msg.sender == address(_wallet), "BM: caller must be wallet");
220         _;
221     }
222 
223     /**
224      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
225      */
226     modifier onlyWalletOwner(BaseWallet _wallet) {
227         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
228         _;
229     }
230 
231     /**
232      * @dev Throws if the sender is not the owner of the target wallet.
233      */
234     modifier strictOnlyWalletOwner(BaseWallet _wallet) {
235         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
236         _;
237     }
238 
239     /**
240      * @dev Inits the module for a wallet by logging an event.
241      * The method can only be called by the wallet itself.
242      * @param _wallet The wallet.
243      */
244     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
245         emit ModuleInitialised(address(_wallet));
246     }
247 
248     /**
249      * @dev Adds a module to a wallet. First checks that the module is registered.
250      * @param _wallet The target wallet.
251      * @param _module The modules to authorise.
252      */
253     function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
254         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
255         _wallet.authoriseModule(address(_module), true);
256     }
257 
258     /**
259     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
260     * module by mistake and transfer them to the Module Registry. 
261     * @param _token The token to recover.
262     */
263     function recoverToken(address _token) external {
264         uint total = ERC20(_token).balanceOf(address(this));
265         ERC20(_token).transfer(address(registry), total);
266     }
267 
268     /**
269      * @dev Helper method to check if an address is the owner of a target wallet.
270      * @param _wallet The target wallet.
271      * @param _addr The address.
272      */
273     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
274         return _wallet.owner() == _addr;
275     }
276 
277     /**
278      * @dev Helper method to invoke a wallet.
279      * @param _wallet The target wallet.
280      * @param _to The target address for the transaction.
281      * @param _value The value of the transaction.
282      * @param _data The data of the transaction.
283      */
284     function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data) internal returns (bytes memory _res) {
285         bool success;
286         // solium-disable-next-line security/no-call-value
287         (success, _res) = _wallet.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _to, _value, _data));
288         if(success && _res.length > 0) { //_res is empty if _wallet is an "old" BaseWallet that can't return output values
289             (_res) = abi.decode(_res, (bytes));
290         } else if (_res.length > 0) {
291             // solium-disable-next-line security/no-inline-assembly
292             assembly {
293                 returndatacopy(0, 0, returndatasize)
294                 revert(0, returndatasize)
295             }
296         } else if(!success) {
297             revert("BM: wallet invoke reverted");
298         }
299     }
300 }
301 
302 /**
303  * @title RelayerModule
304  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer.
305  * @author Julien Niset - <julien@argent.im>
306  */
307 contract RelayerModule is BaseModule {
308 
309     uint256 constant internal BLOCKBOUND = 10000;
310 
311     mapping (address => RelayerConfig) public relayer;
312 
313     struct RelayerConfig {
314         uint256 nonce;
315         mapping (bytes32 => bool) executedTx;
316     }
317 
318     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
319 
320     /**
321      * @dev Throws if the call did not go through the execute() method.
322      */
323     modifier onlyExecute {
324         require(msg.sender == address(this), "RM: must be called via execute()");
325         _;
326     }
327 
328     /* ***************** Abstract method ************************* */
329 
330     /**
331     * @dev Gets the number of valid signatures that must be provided to execute a
332     * specific relayed transaction.
333     * @param _wallet The target wallet.
334     * @param _data The data of the relayed transaction.
335     * @return The number of required signatures.
336     */
337     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);
338 
339     /**
340     * @dev Validates the signatures provided with a relayed transaction.
341     * The method MUST throw if one or more signatures are not valid.
342     * @param _wallet The target wallet.
343     * @param _data The data of the relayed transaction.
344     * @param _signHash The signed hash representing the relayed transaction.
345     * @param _signatures The signatures as a concatenated byte array.
346     */
347     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool);
348 
349     /* ************************************************************ */
350 
351     /**
352     * @dev Executes a relayed transaction.
353     * @param _wallet The target wallet.
354     * @param _data The data for the relayed transaction
355     * @param _nonce The nonce used to prevent replay attacks.
356     * @param _signatures The signatures as a concatenated byte array.
357     * @param _gasPrice The gas price to use for the gas refund.
358     * @param _gasLimit The gas limit to use for the gas refund.
359     */
360     function execute(
361         BaseWallet _wallet,
362         bytes calldata _data,
363         uint256 _nonce,
364         bytes calldata _signatures,
365         uint256 _gasPrice,
366         uint256 _gasLimit
367     )
368         external
369         returns (bool success)
370     {
371         uint startGas = gasleft();
372         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
373         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
374         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
375         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
376         if((requiredSignatures * 65) == _signatures.length) {
377             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
378                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
379                     // solium-disable-next-line security/no-call-value
380                     (success,) = address(this).call(_data);
381                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
382                 }
383             }
384         }
385         emit TransactionExecuted(address(_wallet), success, signHash);
386     }
387 
388     /**
389     * @dev Gets the current nonce for a wallet.
390     * @param _wallet The target wallet.
391     */
392     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
393         return relayer[address(_wallet)].nonce;
394     }
395 
396     /**
397     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
398     * @param _from The starting address for the relayed transaction (should be the module)
399     * @param _to The destination address for the relayed transaction (should be the wallet)
400     * @param _value The value for the relayed transaction
401     * @param _data The data for the relayed transaction
402     * @param _nonce The nonce used to prevent replay attacks.
403     * @param _gasPrice The gas price to use for the gas refund.
404     * @param _gasLimit The gas limit to use for the gas refund.
405     */
406     function getSignHash(
407         address _from,
408         address _to,
409         uint256 _value,
410         bytes memory _data,
411         uint256 _nonce,
412         uint256 _gasPrice,
413         uint256 _gasLimit
414     )
415         internal
416         pure
417         returns (bytes32)
418     {
419         return keccak256(
420             abi.encodePacked(
421                 "\x19Ethereum Signed Message:\n32",
422                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
423         ));
424     }
425 
426     /**
427     * @dev Checks if the relayed transaction is unique.
428     * @param _wallet The target wallet.
429     * @param _nonce The nonce
430     * @param _signHash The signed hash of the transaction
431     */
432     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
433         if(relayer[address(_wallet)].executedTx[_signHash] == true) {
434             return false;
435         }
436         relayer[address(_wallet)].executedTx[_signHash] = true;
437         return true;
438     }
439 
440     /**
441     * @dev Checks that a nonce has the correct format and is valid.
442     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
443     * @param _wallet The target wallet.
444     * @param _nonce The nonce
445     */
446     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
447         if(_nonce <= relayer[address(_wallet)].nonce) {
448             return false;
449         }
450         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
451         if(nonceBlock > block.number + BLOCKBOUND) {
452             return false;
453         }
454         relayer[address(_wallet)].nonce = _nonce;
455         return true;
456     }
457 
458     /**
459     * @dev Recovers the signer at a given position from a list of concatenated signatures.
460     * @param _signedHash The signed hash
461     * @param _signatures The concatenated signatures.
462     * @param _index The index of the signature to recover.
463     */
464     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
465         uint8 v;
466         bytes32 r;
467         bytes32 s;
468         // we jump 32 (0x20) as the first slot of bytes contains the length
469         // we jump 65 (0x41) per signature
470         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
471         // solium-disable-next-line security/no-inline-assembly
472         assembly {
473             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
474             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
475             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
476         }
477         require(v == 27 || v == 28);
478         return ecrecover(_signedHash, v, r, s);
479     }
480 
481     /**
482     * @dev Refunds the gas used to the Relayer. 
483     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
484     * @param _wallet The target wallet.
485     * @param _gasUsed The gas used.
486     * @param _gasPrice The gas price for the refund.
487     * @param _gasLimit The gas limit for the refund.
488     * @param _signatures The number of signatures used in the call.
489     * @param _relayer The address of the Relayer.
490     */
491     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
492         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
493         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
494         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
495             if(_gasPrice > tx.gasprice) {
496                 amount = amount * tx.gasprice;
497             }
498             else {
499                 amount = amount * _gasPrice;
500             }
501             invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
502         }
503     }
504 
505     /**
506     * @dev Returns false if the refund is expected to fail.
507     * @param _wallet The target wallet.
508     * @param _gasUsed The expected gas used.
509     * @param _gasPrice The expected gas price for the refund.
510     */
511     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
512         if(_gasPrice > 0
513             && _signatures > 1
514             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
515             return false;
516         }
517         return true;
518     }
519 
520     /**
521     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
522     * as the wallet passed as the input of the execute() method. 
523     @return false if the addresses are different.
524     */
525     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
526         require(_data.length >= 36, "RM: Invalid dataWallet");
527         address dataWallet;
528         // solium-disable-next-line security/no-inline-assembly
529         assembly {
530             //_data = {length:32}{sig:4}{_wallet:32}{...}
531             dataWallet := mload(add(_data, 0x24))
532         }
533         return dataWallet == _wallet;
534     }
535 
536     /**
537     * @dev Parses the data to extract the method signature.
538     */
539     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
540         require(_data.length >= 4, "RM: Invalid functionPrefix");
541         // solium-disable-next-line security/no-inline-assembly
542         assembly {
543             prefix := mload(add(_data, 0x20))
544         }
545     }
546 }
547 
548 /**
549  * @title OnlyOwnerModule
550  * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
551  * must be called with one signature frm the owner.
552  * @author Julien Niset - <julien@argent.im>
553  */
554 contract OnlyOwnerModule is BaseModule, RelayerModule {
555 
556     // bytes4 private constant IS_ONLY_OWNER_MODULE = bytes4(keccak256("isOnlyOwnerModule()"));
557 
558    /**
559     * @dev Returns a constant that indicates that the module is an OnlyOwnerModule.
560     * @return The constant bytes4(keccak256("isOnlyOwnerModule()"))
561     */
562     function isOnlyOwnerModule() external pure returns (bytes4) {
563         // return IS_ONLY_OWNER_MODULE;
564         return this.isOnlyOwnerModule.selector;
565     }
566 
567     /**
568      * @dev Adds a module to a wallet. First checks that the module is registered.
569      * Unlike its overrided parent, this method can be called via the RelayerModule's execute()
570      * @param _wallet The target wallet.
571      * @param _module The modules to authorise.
572      */
573     function addModule(BaseWallet _wallet, Module _module) external onlyWalletOwner(_wallet) {
574         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
575         _wallet.authoriseModule(address(_module), true);
576     }
577 
578     // *************** Implementation of RelayerModule methods ********************* //
579 
580     // Overrides to use the incremental nonce and save some gas
581     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 /* _signHash */) internal returns (bool) {
582         return checkAndUpdateNonce(_wallet, _nonce);
583     }
584 
585     function validateSignatures(
586         BaseWallet _wallet,
587         bytes memory /* _data */,
588         bytes32 _signHash,
589         bytes memory _signatures
590     )
591         internal
592         view
593         returns (bool)
594     {
595         address signer = recoverSigner(_signHash, _signatures, 0);
596         return isOwner(_wallet, signer); // "OOM: signer must be owner"
597     }
598 
599     function getRequiredSignatures(BaseWallet /* _wallet */, bytes memory /* _data */) internal view returns (uint256) {
600         return 1;
601     }
602 }
603 
604 /**
605  * @title LimitManager
606  * @dev Module to manage a daily spending limit
607  * @author Julien Niset - <julien@argent.im>
608  */
609 contract LimitManager is BaseModule {
610 
611     // large limit when the limit can be considered disabled
612     uint128 constant private LIMIT_DISABLED = uint128(-1); // 3.40282366920938463463374607431768211455e+38
613 
614     using SafeMath for uint256;
615 
616     struct LimitManagerConfig {
617         // The daily limit
618         Limit limit;
619         // The current usage
620         DailySpent dailySpent;
621     }
622 
623     struct Limit {
624         // the current limit
625         uint128 current;
626         // the pending limit if any
627         uint128 pending;
628         // when the pending limit becomes the current limit
629         uint64 changeAfter;
630     }
631 
632     struct DailySpent {
633         // The amount already spent during the current period
634         uint128 alreadySpent;
635         // The end of the current period
636         uint64 periodEnd;
637     }
638 
639     // wallet specific storage
640     mapping (address => LimitManagerConfig) internal limits;
641     // The default limit
642     uint256 public defaultLimit;
643 
644     // *************** Events *************************** //
645 
646     event LimitChanged(address indexed wallet, uint indexed newLimit, uint64 indexed startAfter);
647 
648     // *************** Constructor ********************** //
649 
650     constructor(uint256 _defaultLimit) public {
651         defaultLimit = _defaultLimit;
652     }
653 
654     // *************** External/Public Functions ********************* //
655 
656     /**
657      * @dev Inits the module for a wallet by setting the limit to the default value.
658      * @param _wallet The target wallet.
659      */
660     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
661         Limit storage limit = limits[address(_wallet)].limit;
662         if(limit.current == 0 && limit.changeAfter == 0) {
663             limit.current = uint128(defaultLimit);
664         }
665     }
666 
667     // *************** Internal Functions ********************* //
668 
669     /**
670      * @dev Changes the daily limit.
671      * The limit is expressed in ETH and the change is pending for the security period.
672      * @param _wallet The target wallet.
673      * @param _newLimit The new limit.
674      * @param _securityPeriod The security period.
675      */
676     function changeLimit(BaseWallet _wallet, uint256 _newLimit, uint256 _securityPeriod) internal {
677         Limit storage limit = limits[address(_wallet)].limit;
678         // solium-disable-next-line security/no-block-members
679         uint128 current = (limit.changeAfter > 0 && limit.changeAfter < now) ? limit.pending : limit.current;
680         limit.current = current;
681         limit.pending = uint128(_newLimit);
682         // solium-disable-next-line security/no-block-members
683         limit.changeAfter = uint64(now.add(_securityPeriod));
684         // solium-disable-next-line security/no-block-members
685         emit LimitChanged(address(_wallet), _newLimit, uint64(now.add(_securityPeriod)));
686     }
687 
688      /**
689      * @dev Disable the daily limit.
690      * The change is pending for the security period.
691      * @param _wallet The target wallet.
692      * @param _securityPeriod The security period.
693      */
694     function disableLimit(BaseWallet _wallet, uint256 _securityPeriod) internal {
695         changeLimit(_wallet, LIMIT_DISABLED, _securityPeriod);
696     }
697 
698     /**
699     * @dev Gets the current daily limit for a wallet.
700     * @param _wallet The target wallet.
701     * @return the current limit expressed in ETH.
702     */
703     function getCurrentLimit(BaseWallet _wallet) public view returns (uint256 _currentLimit) {
704         Limit storage limit = limits[address(_wallet)].limit;
705         _currentLimit = uint256(currentLimit(limit.current, limit.pending, limit.changeAfter));
706     }
707 
708     /**
709     * @dev Returns whether the daily limit is disabled for a wallet.
710     * @param _wallet The target wallet.
711     * @return true if the daily limit is disabled, false otherwise.
712     */
713     function isLimitDisabled(BaseWallet _wallet) public view returns (bool _limitDisabled) {
714         uint256 currentLimit = getCurrentLimit(_wallet);
715         _limitDisabled = currentLimit == LIMIT_DISABLED;
716     }
717 
718     /**
719     * @dev Gets a pending limit for a wallet if any.
720     * @param _wallet The target wallet.
721     * @return the pending limit (in ETH) and the time at chich it will become effective.
722     */
723     function getPendingLimit(BaseWallet _wallet) external view returns (uint256 _pendingLimit, uint64 _changeAfter) {
724         Limit storage limit = limits[address(_wallet)].limit;
725         // solium-disable-next-line security/no-block-members
726         return ((now < limit.changeAfter)? (uint256(limit.pending), limit.changeAfter) : (0,0));
727     }
728 
729     /**
730     * @dev Gets the amount of tokens that has not yet been spent during the current period.
731     * @param _wallet The target wallet.
732     * @return the amount of tokens (in ETH) that has not been spent yet and the end of the period.
733     */
734     function getDailyUnspent(BaseWallet _wallet) external view returns (uint256 _unspent, uint64 _periodEnd) {
735         uint256 limit = getCurrentLimit(_wallet);
736         DailySpent storage expense = limits[address(_wallet)].dailySpent;
737         // solium-disable-next-line security/no-block-members
738         if(now > expense.periodEnd) {
739             _unspent = limit;
740             // solium-disable-next-line security/no-block-members
741             _periodEnd = uint64(now + 24 hours);
742         }
743         else {
744             _periodEnd = expense.periodEnd;
745             if(expense.alreadySpent < limit) {
746                 _unspent = limit - expense.alreadySpent;
747             }
748         }
749     }
750 
751     /**
752     * @dev Helper method to check if a transfer is within the limit.
753     * If yes the daily unspent for the current period is updated.
754     * @param _wallet The target wallet.
755     * @param _amount The amount for the transfer
756     */
757     function checkAndUpdateDailySpent(BaseWallet _wallet, uint _amount) internal returns (bool) {
758         if(_amount == 0) return true;
759         Limit storage limit = limits[address(_wallet)].limit;
760         uint128 current = currentLimit(limit.current, limit.pending, limit.changeAfter);
761         if(isWithinDailyLimit(_wallet, current, _amount)) {
762             updateDailySpent(_wallet, current, _amount);
763             return true;
764         }
765         return false;
766     }
767 
768     /**
769     * @dev Helper method to update the daily spent for the current period.
770     * @param _wallet The target wallet.
771     * @param _limit The current limit for the wallet.
772     * @param _amount The amount to add to the daily spent.
773     */
774     function updateDailySpent(BaseWallet _wallet, uint128 _limit, uint _amount) internal {
775         if(_limit != LIMIT_DISABLED) {
776             DailySpent storage expense = limits[address(_wallet)].dailySpent;
777             // solium-disable-next-line security/no-block-members
778             if (expense.periodEnd < now) {
779                 // solium-disable-next-line security/no-block-members
780                 expense.periodEnd = uint64(now + 24 hours);
781                 expense.alreadySpent = uint128(_amount);
782             }
783             else {
784                 expense.alreadySpent += uint128(_amount);
785             }
786         }
787     }
788 
789     /**
790     * @dev Checks if a transfer amount is withing the daily limit for a wallet.
791     * @param _wallet The target wallet.
792     * @param _limit The current limit for the wallet.
793     * @param _amount The transfer amount.
794     * @return true if the transfer amount is withing the daily limit.
795     */
796     function isWithinDailyLimit(BaseWallet _wallet, uint _limit, uint _amount) internal view returns (bool)  {
797         if(_limit == LIMIT_DISABLED) {
798             return true;
799         }
800         DailySpent storage expense = limits[address(_wallet)].dailySpent;
801         // solium-disable-next-line security/no-block-members
802         if (expense.periodEnd < now) {
803             return (_amount <= _limit);
804         } else {
805             return (expense.alreadySpent + _amount <= _limit && expense.alreadySpent + _amount >= expense.alreadySpent);
806         }
807     }
808 
809     /**
810     * @dev Helper method to get the current limit from a Limit struct.
811     * @param _current The value of the current parameter
812     * @param _pending The value of the pending parameter
813     * @param _changeAfter The value of the changeAfter parameter
814     */
815     function currentLimit(uint128 _current, uint128 _pending, uint64 _changeAfter) internal view returns (uint128) {
816         // solium-disable-next-line security/no-block-members
817         if(_changeAfter > 0 && _changeAfter < now) {
818             return _pending;
819         }
820         return _current;
821     }
822 
823 }
824 
825 /**
826  * @title BaseTransfer
827  * @dev Module containing internal methods to execute or approve transfers
828  * @author Olivier VDB - <olivier@argent.xyz>
829  */
830 contract BaseTransfer is BaseModule {
831 
832     // Mock token address for ETH
833     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
834 
835     // *************** Events *************************** //
836 
837     event Transfer(address indexed wallet, address indexed token, uint256 indexed amount, address to, bytes data);
838     event Approved(address indexed wallet, address indexed token, uint256 amount, address spender);
839     event CalledContract(address indexed wallet, address indexed to, uint256 amount, bytes data);
840 
841     // *************** Internal Functions ********************* //
842 
843     /**
844     * @dev Helper method to transfer ETH or ERC20 for a wallet.
845     * @param _wallet The target wallet.
846     * @param _token The ERC20 address.
847     * @param _to The recipient.
848     * @param _value The amount of ETH to transfer
849     * @param _data The data to *log* with the transfer.
850     */
851     function doTransfer(BaseWallet _wallet, address _token, address _to, uint256 _value, bytes memory _data) internal {
852         if(_token == ETH_TOKEN) {
853             invokeWallet(address(_wallet), _to, _value, EMPTY_BYTES);
854         }
855         else {
856             bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", _to, _value);
857             invokeWallet(address(_wallet), _token, 0, methodData);
858         }
859         emit Transfer(address(_wallet), _token, _value, _to, _data);
860     }
861 
862     /**
863     * @dev Helper method to approve spending the ERC20 of a wallet.
864     * @param _wallet The target wallet.
865     * @param _token The ERC20 address.
866     * @param _spender The spender address.
867     * @param _value The amount of token to transfer.
868     */
869     function doApproveToken(BaseWallet _wallet, address _token, address _spender, uint256 _value) internal {
870         bytes memory methodData = abi.encodeWithSignature("approve(address,uint256)", _spender, _value);
871         invokeWallet(address(_wallet), _token, 0, methodData);
872         emit Approved(address(_wallet), _token, _value, _spender);
873     }
874 
875     /**
876     * @dev Helper method to call an external contract.
877     * @param _wallet The target wallet.
878     * @param _contract The contract address.
879     * @param _value The ETH value to transfer.
880     * @param _data The method data.
881     */
882     function doCallContract(BaseWallet _wallet, address _contract, uint256 _value, bytes memory _data) internal {
883         invokeWallet(address(_wallet), _contract, _value, _data);
884         emit CalledContract(address(_wallet), _contract, _value, _data);
885     }
886 }
887 
888 /**
889  * @title TransferManager
890  * @dev Module to transfer and approve tokens (ETH or ERC20) or data (contract call) based on a security context (daily limit, whitelist, etc).
891  * This module is the V2 of TokenTransfer.
892  * @author Julien Niset - <julien@argent.xyz>
893  */
894 contract TransferManager is BaseModule, RelayerModule, OnlyOwnerModule, BaseTransfer, LimitManager {
895 
896     bytes32 constant NAME = "TransferManager";
897 
898     bytes4 private constant ERC721_ISVALIDSIGNATURE_BYTES = bytes4(keccak256("isValidSignature(bytes,bytes)"));
899     bytes4 private constant ERC721_ISVALIDSIGNATURE_BYTES32 = bytes4(keccak256("isValidSignature(bytes32,bytes)"));
900 
901     enum ActionType { Transfer }
902 
903     using SafeMath for uint256;
904 
905     struct TokenManagerConfig {
906         // Mapping between pending action hash and their timestamp
907         mapping (bytes32 => uint256) pendingActions;
908     }
909 
910     // wallet specific storage
911     mapping (address => TokenManagerConfig) internal configs;
912 
913     // The security period
914     uint256 public securityPeriod;
915     // The execution window
916     uint256 public securityWindow;
917     // The Token storage
918     TransferStorage public transferStorage;
919     // The Token price provider
920     TokenPriceProvider public priceProvider;
921     // The previous limit manager needed to migrate the limits
922     LimitManager public oldLimitManager;
923 
924     // *************** Events *************************** //
925 
926     event AddedToWhitelist(address indexed wallet, address indexed target, uint64 whitelistAfter);
927     event RemovedFromWhitelist(address indexed wallet, address indexed target);
928     event PendingTransferCreated(address indexed wallet, bytes32 indexed id, uint256 indexed executeAfter,
929         address token, address to, uint256 amount, bytes data);
930     event PendingTransferExecuted(address indexed wallet, bytes32 indexed id);
931     event PendingTransferCanceled(address indexed wallet, bytes32 indexed id);
932 
933     // *************** Constructor ********************** //
934 
935     constructor(
936         ModuleRegistry _registry,
937         TransferStorage _transferStorage,
938         GuardianStorage _guardianStorage,
939         address _priceProvider,
940         uint256 _securityPeriod,
941         uint256 _securityWindow,
942         uint256 _defaultLimit,
943         LimitManager _oldLimitManager
944     )
945         BaseModule(_registry, _guardianStorage, NAME)
946         LimitManager(_defaultLimit)
947         public
948     {
949         transferStorage = _transferStorage;
950         priceProvider = TokenPriceProvider(_priceProvider);
951         securityPeriod = _securityPeriod;
952         securityWindow = _securityWindow;
953         oldLimitManager = _oldLimitManager;
954     }
955 
956     /**
957      * @dev Inits the module for a wallet by setting up the isValidSignature (EIP 1271)
958      * static call redirection from the wallet to the module and copying all the parameters
959      * of the daily limit from the previous implementation of the LimitManager module.
960      * @param _wallet The target wallet.
961      */
962     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
963 
964         // setup static calls
965         _wallet.enableStaticCall(address(this), ERC721_ISVALIDSIGNATURE_BYTES);
966         _wallet.enableStaticCall(address(this), ERC721_ISVALIDSIGNATURE_BYTES32);
967 
968         // setup default limit for new deployment
969         if(address(oldLimitManager) == address(0)) {
970             super.init(_wallet);
971             return;
972         }
973         // get limit from previous LimitManager
974         uint256 current = oldLimitManager.getCurrentLimit(_wallet);
975         (uint256 pending, uint64 changeAfter) = oldLimitManager.getPendingLimit(_wallet);
976         // setup default limit for new wallets
977         if(current == 0 && changeAfter == 0) {
978             super.init(_wallet);
979             return;
980         }
981         // migrate existing limit for existing wallets
982         if(current == pending) {
983             limits[address(_wallet)].limit.current = uint128(current);
984         }
985         else {
986             limits[address(_wallet)].limit = Limit(uint128(current), uint128(pending), changeAfter);
987         }
988         // migrate daily pending if we are within a rolling period
989         (uint256 unspent, uint64 periodEnd) = oldLimitManager.getDailyUnspent(_wallet);
990         // solium-disable-next-line security/no-block-members
991         if(periodEnd > now) {
992             limits[address(_wallet)].dailySpent = DailySpent(uint128(current.sub(unspent)), periodEnd);
993         }
994     }
995 
996     // *************** External/Public Functions ********************* //
997 
998     /**
999     * @dev lets the owner transfer tokens (ETH or ERC20) from a wallet.
1000     * @param _wallet The target wallet.
1001     * @param _token The address of the token to transfer.
1002     * @param _to The destination address
1003     * @param _amount The amoutn of token to transfer
1004     * @param _data The data for the transaction
1005     */
1006     function transferToken(
1007         BaseWallet _wallet,
1008         address _token,
1009         address _to,
1010         uint256 _amount,
1011         bytes calldata _data
1012     )
1013         external
1014         onlyWalletOwner(_wallet)
1015         onlyWhenUnlocked(_wallet)
1016     {
1017         if(isWhitelisted(_wallet, _to)) {
1018             // transfer to whitelist
1019             doTransfer(_wallet, _token, _to, _amount, _data);
1020         }
1021         else {
1022             uint256 etherAmount = (_token == ETH_TOKEN) ? _amount : priceProvider.getEtherValue(_amount, _token);
1023             if (checkAndUpdateDailySpent(_wallet, etherAmount)) {
1024                 // transfer under the limit
1025                 doTransfer(_wallet, _token, _to, _amount, _data);
1026             }
1027             else {
1028                 // transfer above the limit
1029                 (bytes32 id, uint256 executeAfter) = addPendingAction(ActionType.Transfer, _wallet, _token, _to, _amount, _data);
1030                 emit PendingTransferCreated(address(_wallet), id, executeAfter, _token, _to, _amount, _data);
1031             }
1032         }
1033     }
1034 
1035     /**
1036     * @dev lets the owner approve an allowance of ERC20 tokens for a spender (dApp).
1037     * @param _wallet The target wallet.
1038     * @param _token The address of the token to transfer.
1039     * @param _spender The address of the spender
1040     * @param _amount The amount of tokens to approve
1041     */
1042     function approveToken(
1043         BaseWallet _wallet,
1044         address _token,
1045         address _spender,
1046         uint256 _amount
1047     )
1048         external
1049         onlyWalletOwner(_wallet)
1050         onlyWhenUnlocked(_wallet)
1051     {
1052         if(isWhitelisted(_wallet, _spender)) {
1053             // approve to whitelist
1054             doApproveToken(_wallet, _token, _spender, _amount);
1055         }
1056         else {
1057             // get current alowance
1058             uint256 currentAllowance = ERC20(_token).allowance(address(_wallet), _spender);
1059             if(_amount <= currentAllowance) {
1060                 // approve if we reduce the allowance
1061                 doApproveToken(_wallet, _token, _spender, _amount);
1062             }
1063             else {
1064                 // check if delta is under the limit
1065                 uint delta = _amount - currentAllowance;
1066                 uint256 deltaInEth = priceProvider.getEtherValue(delta, _token);
1067                 require(checkAndUpdateDailySpent(_wallet, deltaInEth), "TM: Approve above daily limit");
1068                 // approve if under the limit
1069                 doApproveToken(_wallet, _token, _spender, _amount);
1070             }
1071         }
1072     }
1073 
1074     /**
1075     * @dev lets the owner call a contract.
1076     * @param _wallet The target wallet.
1077     * @param _contract The address of the contract.
1078     * @param _value The amount of ETH to transfer as part of call
1079     * @param _data The encoded method data
1080     */
1081     function callContract(
1082         BaseWallet _wallet,
1083         address _contract,
1084         uint256 _value,
1085         bytes calldata _data
1086     )
1087         external
1088         onlyWalletOwner(_wallet)
1089         onlyWhenUnlocked(_wallet)
1090     {
1091         // Make sure we don't call a module, the wallet itself, or a supported ERC20
1092         authoriseContractCall(_wallet, _contract);
1093 
1094         if(isWhitelisted(_wallet, _contract)) {
1095             // call to whitelist
1096             doCallContract(_wallet, _contract, _value, _data);
1097         }
1098         else {
1099             require(checkAndUpdateDailySpent(_wallet, _value), "TM: Call contract above daily limit");
1100             // call under the limit
1101             doCallContract(_wallet, _contract, _value, _data);
1102         }
1103     }
1104 
1105     /**
1106     * @dev lets the owner do an ERC20 approve followed by a call to a contract.
1107     * We assume that the contract will pull the tokens and does not require ETH.
1108     * @param _wallet The target wallet.
1109     * @param _token The token to approve.
1110     * @param _contract The address of the contract.
1111     * @param _amount The amount of ERC20 tokens to approve.
1112     * @param _data The encoded method data
1113     */
1114     function approveTokenAndCallContract(
1115         BaseWallet _wallet,
1116         address _token,
1117         address _contract,
1118         uint256 _amount,
1119         bytes calldata _data
1120     )
1121         external
1122         onlyWalletOwner(_wallet)
1123         onlyWhenUnlocked(_wallet)
1124     {
1125         // Make sure we don't call a module, the wallet itself, or a supported ERC20
1126         authoriseContractCall(_wallet, _contract);
1127 
1128         if(isWhitelisted(_wallet, _contract)) {
1129             doApproveToken(_wallet, _token, _contract, _amount);
1130             doCallContract(_wallet, _contract, 0, _data);
1131         }
1132         else {
1133             // get current alowance
1134             uint256 currentAllowance = ERC20(_token).allowance(address(_wallet), _contract);
1135             if(_amount <= currentAllowance) {
1136                 // no need to approve more
1137                 doCallContract(_wallet, _contract, 0, _data);
1138             }
1139             else {
1140                 // check if delta is under the limit
1141                 uint delta = _amount - currentAllowance;
1142                 uint256 deltaInEth = priceProvider.getEtherValue(delta, _token);
1143                 require(checkAndUpdateDailySpent(_wallet, deltaInEth), "TM: Approve above daily limit");
1144                 // approve if under the limit
1145                 doApproveToken(_wallet, _token, _contract, _amount);
1146                 doCallContract(_wallet, _contract, 0, _data);
1147             }
1148         }
1149     }
1150 
1151     /**
1152      * @dev Adds an address to the whitelist of a wallet.
1153      * @param _wallet The target wallet.
1154      * @param _target The address to add.
1155      */
1156     function addToWhitelist(
1157         BaseWallet _wallet,
1158         address _target
1159     )
1160         external
1161         onlyWalletOwner(_wallet)
1162         onlyWhenUnlocked(_wallet)
1163     {
1164         require(!isWhitelisted(_wallet, _target), "TT: target already whitelisted");
1165         // solium-disable-next-line security/no-block-members
1166         uint256 whitelistAfter = now.add(securityPeriod);
1167         transferStorage.setWhitelist(_wallet, _target, whitelistAfter);
1168         emit AddedToWhitelist(address(_wallet), _target, uint64(whitelistAfter));
1169     }
1170 
1171     /**
1172      * @dev Removes an address from the whitelist of a wallet.
1173      * @param _wallet The target wallet.
1174      * @param _target The address to remove.
1175      */
1176     function removeFromWhitelist(
1177         BaseWallet _wallet,
1178         address _target
1179     )
1180         external
1181         onlyWalletOwner(_wallet)
1182         onlyWhenUnlocked(_wallet)
1183     {
1184         require(isWhitelisted(_wallet, _target), "TT: target not whitelisted");
1185         transferStorage.setWhitelist(_wallet, _target, 0);
1186         emit RemovedFromWhitelist(address(_wallet), _target);
1187     }
1188 
1189     /**
1190     * @dev Executes a pending transfer for a wallet.
1191     * The method can be called by anyone to enable orchestration.
1192     * @param _wallet The target wallet.
1193     * @param _token The token of the pending transfer.
1194     * @param _to The destination address of the pending transfer.
1195     * @param _amount The amount of token to transfer of the pending transfer.
1196     * @param _data The data associated to the pending transfer.
1197     * @param _block The block at which the pending transfer was created.
1198     */
1199     function executePendingTransfer(
1200         BaseWallet _wallet,
1201         address _token,
1202         address _to,
1203         uint _amount,
1204         bytes calldata _data,
1205         uint _block
1206     )
1207         external
1208         onlyWhenUnlocked(_wallet)
1209     {
1210         bytes32 id = keccak256(abi.encodePacked(ActionType.Transfer, _token, _to, _amount, _data, _block));
1211         uint executeAfter = configs[address(_wallet)].pendingActions[id];
1212         require(executeAfter > 0, "TT: unknown pending transfer");
1213         uint executeBefore = executeAfter.add(securityWindow);
1214         // solium-disable-next-line security/no-block-members
1215         require(executeAfter <= now && now <= executeBefore, "TT: transfer outside of the execution window");
1216         delete configs[address(_wallet)].pendingActions[id];
1217         doTransfer(_wallet, _token, _to, _amount, _data);
1218         emit PendingTransferExecuted(address(_wallet), id);
1219     }
1220 
1221     function cancelPendingTransfer(
1222         BaseWallet _wallet,
1223         bytes32 _id
1224     )
1225         external
1226         onlyWalletOwner(_wallet)
1227         onlyWhenUnlocked(_wallet)
1228     {
1229         require(configs[address(_wallet)].pendingActions[_id] > 0, "TT: unknown pending action");
1230         delete configs[address(_wallet)].pendingActions[_id];
1231         emit PendingTransferCanceled(address(_wallet), _id);
1232     }
1233 
1234     /**
1235      * @dev Lets the owner of a wallet change its daily limit.
1236      * The limit is expressed in ETH. Changes to the limit take 24 hours.
1237      * @param _wallet The target wallet.
1238      * @param _newLimit The new limit.
1239      */
1240     function changeLimit(BaseWallet _wallet, uint256 _newLimit) external onlyWalletOwner(_wallet) onlyWhenUnlocked(_wallet) {
1241         changeLimit(_wallet, _newLimit, securityPeriod);
1242     }
1243 
1244     /**
1245      * @dev Convenience method to disable the limit
1246      * The limit is disabled by setting it to an arbitrary large value.
1247      * @param _wallet The target wallet.
1248      */
1249     function disableLimit(BaseWallet _wallet) external onlyWalletOwner(_wallet) onlyWhenUnlocked(_wallet) {
1250         disableLimit(_wallet, securityPeriod);
1251     }
1252 
1253     /**
1254     * @dev Checks if an address is whitelisted for a wallet.
1255     * @param _wallet The target wallet.
1256     * @param _target The address.
1257     * @return true if the address is whitelisted.
1258     */
1259     function isWhitelisted(BaseWallet _wallet, address _target) public view returns (bool _isWhitelisted) {
1260         uint whitelistAfter = transferStorage.getWhitelist(_wallet, _target);
1261         // solium-disable-next-line security/no-block-members
1262         return whitelistAfter > 0 && whitelistAfter < now;
1263     }
1264 
1265     /**
1266     * @dev Gets the info of a pending transfer for a wallet.
1267     * @param _wallet The target wallet.
1268     * @param _id The pending transfer ID.
1269     * @return the epoch time at which the pending transfer can be executed.
1270     */
1271     function getPendingTransfer(BaseWallet _wallet, bytes32 _id) external view returns (uint64 _executeAfter) {
1272         _executeAfter = uint64(configs[address(_wallet)].pendingActions[_id]);
1273     }
1274 
1275     /**
1276     * @dev Implementation of EIP 1271.
1277     * Should return whether the signature provided is valid for the provided data.
1278     * @param _data Arbitrary length data signed on the behalf of address(this)
1279     * @param _signature Signature byte array associated with _data
1280     */
1281     function isValidSignature(bytes calldata _data, bytes calldata _signature) external view returns (bytes4) {
1282         bytes32 msgHash = keccak256(abi.encodePacked(_data));
1283         isValidSignature(msgHash, _signature);
1284         return ERC721_ISVALIDSIGNATURE_BYTES;
1285     }
1286 
1287     /**
1288     * @dev Implementation of EIP 1271.
1289     * Should return whether the signature provided is valid for the provided data.
1290     * @param _msgHash Hash of a message signed on the behalf of address(this)
1291     * @param _signature Signature byte array associated with _msgHash
1292     */
1293     function isValidSignature(bytes32 _msgHash, bytes memory _signature) public view returns (bytes4) {
1294         require(_signature.length == 65, "TM: invalid signature length");
1295         address signer = recoverSigner(_msgHash, _signature, 0);
1296         require(isOwner(BaseWallet(msg.sender), signer), "TM: Invalid signer");
1297         return ERC721_ISVALIDSIGNATURE_BYTES32;
1298     }
1299 
1300     // *************** Internal Functions ********************* //
1301 
1302     /**
1303      * @dev Creates a new pending action for a wallet.
1304      * @param _action The target action.
1305      * @param _wallet The target wallet.
1306      * @param _token The target token for the action.
1307      * @param _to The recipient of the action.
1308      * @param _amount The amount of token associated to the action.
1309      * @param _data The data associated to the action.
1310      * @return the identifier for the new pending action and the time when the action can be executed
1311      */
1312     function addPendingAction(
1313         ActionType _action,
1314         BaseWallet _wallet,
1315         address _token,
1316         address _to,
1317         uint _amount,
1318         bytes memory _data
1319     )
1320         internal
1321         returns (bytes32 id, uint256 executeAfter)
1322     {
1323         id = keccak256(abi.encodePacked(_action, _token, _to, _amount, _data, block.number));
1324         require(configs[address(_wallet)].pendingActions[id] == 0, "TM: duplicate pending action");
1325         // solium-disable-next-line security/no-block-members
1326         executeAfter = now.add(securityPeriod);
1327         configs[address(_wallet)].pendingActions[id] = executeAfter;
1328     }
1329 
1330     /**
1331     * @dev Make sure a contract call is not trying to call a module, the wallet itself, or a supported ERC20.
1332     * @param _wallet The target wallet.
1333     * @param _contract The address of the contract.
1334      */
1335     function authoriseContractCall(BaseWallet _wallet, address _contract) internal view {
1336         require(
1337             _contract != address(_wallet) && // not the wallet itself
1338             !_wallet.authorised(_contract) && // not an authorised module
1339             (priceProvider.cachedPrices(_contract) == 0 || isLimitDisabled(_wallet)), // not an ERC20 listed in the provider (or limit disabled)
1340             "TM: Forbidden contract");
1341     }
1342 
1343     // *************** Implementation of RelayerModule methods ********************* //
1344 
1345     // Overrides refund to add the refund in the daily limit.
1346     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
1347         // 21000 (transaction) + 7620 (execution of refund) + 7324 (execution of updateDailySpent) + 672 to log the event + _gasUsed
1348         uint256 amount = 36616 + _gasUsed;
1349         if(_gasPrice > 0 && _signatures > 0 && amount <= _gasLimit) {
1350             if(_gasPrice > tx.gasprice) {
1351                 amount = amount * tx.gasprice;
1352             }
1353             else {
1354                 amount = amount * _gasPrice;
1355             }
1356             checkAndUpdateDailySpent(_wallet, amount);
1357             invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
1358         }
1359     }
1360 
1361     // Overrides verifyRefund to add the refund in the daily limit.
1362     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
1363         if(_gasPrice > 0 && _signatures > 0 && (
1364             address(_wallet).balance < _gasUsed * _gasPrice ||
1365             isWithinDailyLimit(_wallet, getCurrentLimit(_wallet), _gasUsed * _gasPrice) == false ||
1366             _wallet.authorised(address(this)) == false
1367         ))
1368         {
1369             return false;
1370         }
1371         return true;
1372     }
1373 }