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
46 }
47 
48 /**
49  * @title ModuleRegistry
50  * @dev Registry of authorised modules. 
51  * Modules must be registered before they can be authorised on a wallet.
52  * @author Julien Niset - <julien@argent.xyz>
53  */
54 contract ModuleRegistry {
55     function registerModule(address _module, bytes32 _name) external;
56     function deregisterModule(address _module) external;
57     function registerUpgrader(address _upgrader, bytes32 _name) external;
58     function deregisterUpgrader(address _upgrader) external;
59     function recoverToken(address _token) external;
60     function moduleInfo(address _module) external view returns (bytes32);
61     function upgraderInfo(address _upgrader) external view returns (bytes32);
62     function isRegisteredModule(address _module) external view returns (bool);
63     function isRegisteredModule(address[] calldata _modules) external view returns (bool);
64     function isRegisteredUpgrader(address _upgrader) external view returns (bool);
65 }
66 
67 contract TokenPriceProvider {
68     mapping(address => uint256) public cachedPrices;
69     function setPrice(ERC20 _token, uint256 _price) public;
70     function setPriceForTokenList(ERC20[] calldata _tokens, uint256[] calldata _prices) external;
71     function getEtherValue(uint256 _amount, address _token) external view returns (uint256);
72 }
73 
74 /**
75  * @title GuardianStorage
76  * @dev Contract storing the state of wallets related to guardians and lock.
77  * The contract only defines basic setters and getters with no logic. Only modules authorised
78  * for a wallet can modify its state.
79  * @author Julien Niset - <julien@argent.xyz>
80  * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
81  */
82 contract GuardianStorage {
83     function addGuardian(BaseWallet _wallet, address _guardian) external;
84     function revokeGuardian(BaseWallet _wallet, address _guardian) external;
85     function guardianCount(BaseWallet _wallet) external view returns (uint256);
86     function getGuardians(BaseWallet _wallet) external view returns (address[] memory);
87     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool);
88     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external;
89     function isLocked(BaseWallet _wallet) external view returns (bool);
90     function getLock(BaseWallet _wallet) external view returns (uint256);
91     function getLocker(BaseWallet _wallet) external view returns (address);
92 }
93 
94 /**
95  * @title TransferStorage
96  * @dev Contract storing the state of wallets related to transfers (limit and whitelist).
97  * The contract only defines basic setters and getters with no logic. Only modules authorised
98  * for a wallet can modify its state.
99  * @author Julien Niset - <julien@argent.xyz>
100  */
101 contract TransferStorage {
102     function setWhitelist(BaseWallet _wallet, address _target, uint256 _value) external;
103     function getWhitelist(BaseWallet _wallet, address _target) external view returns (uint256);
104 }
105 
106 /**
107  * @title Interface for a contract that can invest tokens in order to earn an interest.
108  * @author Julien Niset - <julien@argent.xyz>
109  */
110 interface Invest {
111 
112     event InvestmentAdded(address indexed _wallet, address _token, uint256 _invested, uint256 _period);
113     event InvestmentRemoved(address indexed _wallet, address _token, uint256 _fraction);
114 
115     function addInvestment(
116         BaseWallet _wallet, 
117         address _token, 
118         uint256 _amount, 
119         uint256 _period
120     ) 
121         external
122         returns (uint256 _invested);
123 
124     function removeInvestment(
125         BaseWallet _wallet, 
126         address _token, 
127         uint256 _fraction
128     ) 
129         external;
130 
131     function getInvestment(
132         BaseWallet _wallet,
133         address _token
134     )
135         external
136         view
137         returns (uint256 _tokenValue, uint256 _periodEnd);
138 }
139 
140 contract VatLike {
141     function can(address, address) public view returns (uint);
142     function dai(address) public view returns (uint);
143     function hope(address) public;
144 }
145 
146 contract JoinLike {
147     function gem() public returns (GemLike);
148     function dai() public returns (GemLike);
149     function join(address, uint) public;
150     function exit(address, uint) public;
151     VatLike public vat;
152 }
153 
154 contract PotLike {
155     function chi() public view returns (uint);
156     function pie(address) public view returns (uint);
157     function drip() public;
158 }
159 
160 contract ScdMcdMigration {
161     function swapSaiToDai(uint wad) external;
162     function swapDaiToSai(uint wad) external;
163     JoinLike public saiJoin;
164     JoinLike public wethJoin;
165     JoinLike public daiJoin;
166 }
167 
168 contract GemLike {
169     function balanceOf(address) public view returns (uint);
170     function transferFrom(address, address, uint) public returns (bool);
171 }
172 
173 /**
174  * @title SafeMath
175  * @dev Math operations with safety checks that throw on error
176  */
177 library SafeMath {
178 
179     /**
180     * @dev Multiplies two numbers, reverts on overflow.
181     */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b);
192 
193         return c;
194     }
195 
196     /**
197     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
198     */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         require(b > 0); // Solidity only automatically asserts when dividing by 0
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
209     */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a);
212         uint256 c = a - b;
213 
214         return c;
215     }
216 
217     /**
218     * @dev Adds two numbers, reverts on overflow.
219     */
220     function add(uint256 a, uint256 b) internal pure returns (uint256) {
221         uint256 c = a + b;
222         require(c >= a);
223 
224         return c;
225     }
226 
227     /**
228     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
229     * reverts when dividing by zero.
230     */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         require(b != 0);
233         return a % b;
234     }
235 
236     /**
237     * @dev Returns ceil(a / b).
238     */
239     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
240         uint256 c = a / b;
241         if(a % b == 0) {
242             return c;
243         }
244         else {
245             return c + 1;
246         }
247     }
248 }
249 
250 /**
251  * @title BaseModule
252  * @dev Basic module that contains some methods common to all modules.
253  * @author Julien Niset - <julien@argent.im>
254  */
255 contract BaseModule is Module {
256 
257     // Empty calldata
258     bytes constant internal EMPTY_BYTES = "";
259 
260     // The adddress of the module registry.
261     ModuleRegistry internal registry;
262     // The address of the Guardian storage
263     GuardianStorage internal guardianStorage;
264 
265     /**
266      * @dev Throws if the wallet is locked.
267      */
268     modifier onlyWhenUnlocked(BaseWallet _wallet) {
269         // solium-disable-next-line security/no-block-members
270         require(!guardianStorage.isLocked(_wallet), "BM: wallet must be unlocked");
271         _;
272     }
273 
274     event ModuleCreated(bytes32 name);
275     event ModuleInitialised(address wallet);
276 
277     constructor(ModuleRegistry _registry, GuardianStorage _guardianStorage, bytes32 _name) public {
278         registry = _registry;
279         guardianStorage = _guardianStorage;
280         emit ModuleCreated(_name);
281     }
282 
283     /**
284      * @dev Throws if the sender is not the target wallet of the call.
285      */
286     modifier onlyWallet(BaseWallet _wallet) {
287         require(msg.sender == address(_wallet), "BM: caller must be wallet");
288         _;
289     }
290 
291     /**
292      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
293      */
294     modifier onlyWalletOwner(BaseWallet _wallet) {
295         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
296         _;
297     }
298 
299     /**
300      * @dev Throws if the sender is not the owner of the target wallet.
301      */
302     modifier strictOnlyWalletOwner(BaseWallet _wallet) {
303         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
304         _;
305     }
306 
307     /**
308      * @dev Inits the module for a wallet by logging an event.
309      * The method can only be called by the wallet itself.
310      * @param _wallet The wallet.
311      */
312     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
313         emit ModuleInitialised(address(_wallet));
314     }
315 
316     /**
317      * @dev Adds a module to a wallet. First checks that the module is registered.
318      * @param _wallet The target wallet.
319      * @param _module The modules to authorise.
320      */
321     function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
322         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
323         _wallet.authoriseModule(address(_module), true);
324     }
325 
326     /**
327     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
328     * module by mistake and transfer them to the Module Registry. 
329     * @param _token The token to recover.
330     */
331     function recoverToken(address _token) external {
332         uint total = ERC20(_token).balanceOf(address(this));
333         ERC20(_token).transfer(address(registry), total);
334     }
335 
336     /**
337      * @dev Helper method to check if an address is the owner of a target wallet.
338      * @param _wallet The target wallet.
339      * @param _addr The address.
340      */
341     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
342         return _wallet.owner() == _addr;
343     }
344 
345     /**
346      * @dev Helper method to invoke a wallet.
347      * @param _wallet The target wallet.
348      * @param _to The target address for the transaction.
349      * @param _value The value of the transaction.
350      * @param _data The data of the transaction.
351      */
352     function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data) internal returns (bytes memory _res) {
353         bool success;
354         // solium-disable-next-line security/no-call-value
355         (success, _res) = _wallet.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _to, _value, _data));
356         if(success && _res.length > 0) { //_res is empty if _wallet is an "old" BaseWallet that can't return output values
357             (_res) = abi.decode(_res, (bytes));
358         } else if (_res.length > 0) {
359             // solium-disable-next-line security/no-inline-assembly
360             assembly {
361                 returndatacopy(0, 0, returndatasize)
362                 revert(0, returndatasize)
363             }
364         } else if(!success) {
365             revert("BM: wallet invoke reverted");
366         }
367     }
368 }
369 
370 /**
371  * @title RelayerModule
372  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer.
373  * @author Julien Niset - <julien@argent.im>
374  */
375 contract RelayerModule is BaseModule {
376 
377     uint256 constant internal BLOCKBOUND = 10000;
378 
379     mapping (address => RelayerConfig) public relayer;
380 
381     struct RelayerConfig {
382         uint256 nonce;
383         mapping (bytes32 => bool) executedTx;
384     }
385 
386     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
387 
388     /**
389      * @dev Throws if the call did not go through the execute() method.
390      */
391     modifier onlyExecute {
392         require(msg.sender == address(this), "RM: must be called via execute()");
393         _;
394     }
395 
396     /* ***************** Abstract method ************************* */
397 
398     /**
399     * @dev Gets the number of valid signatures that must be provided to execute a
400     * specific relayed transaction.
401     * @param _wallet The target wallet.
402     * @param _data The data of the relayed transaction.
403     * @return The number of required signatures.
404     */
405     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);
406 
407     /**
408     * @dev Validates the signatures provided with a relayed transaction.
409     * The method MUST throw if one or more signatures are not valid.
410     * @param _wallet The target wallet.
411     * @param _data The data of the relayed transaction.
412     * @param _signHash The signed hash representing the relayed transaction.
413     * @param _signatures The signatures as a concatenated byte array.
414     */
415     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool);
416 
417     /* ************************************************************ */
418 
419     /**
420     * @dev Executes a relayed transaction.
421     * @param _wallet The target wallet.
422     * @param _data The data for the relayed transaction
423     * @param _nonce The nonce used to prevent replay attacks.
424     * @param _signatures The signatures as a concatenated byte array.
425     * @param _gasPrice The gas price to use for the gas refund.
426     * @param _gasLimit The gas limit to use for the gas refund.
427     */
428     function execute(
429         BaseWallet _wallet,
430         bytes calldata _data,
431         uint256 _nonce,
432         bytes calldata _signatures,
433         uint256 _gasPrice,
434         uint256 _gasLimit
435     )
436         external
437         returns (bool success)
438     {
439         uint startGas = gasleft();
440         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
441         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
442         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
443         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
444         if((requiredSignatures * 65) == _signatures.length) {
445             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
446                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
447                     // solium-disable-next-line security/no-call-value
448                     (success,) = address(this).call(_data);
449                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
450                 }
451             }
452         }
453         emit TransactionExecuted(address(_wallet), success, signHash);
454     }
455 
456     /**
457     * @dev Gets the current nonce for a wallet.
458     * @param _wallet The target wallet.
459     */
460     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
461         return relayer[address(_wallet)].nonce;
462     }
463 
464     /**
465     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
466     * @param _from The starting address for the relayed transaction (should be the module)
467     * @param _to The destination address for the relayed transaction (should be the wallet)
468     * @param _value The value for the relayed transaction
469     * @param _data The data for the relayed transaction
470     * @param _nonce The nonce used to prevent replay attacks.
471     * @param _gasPrice The gas price to use for the gas refund.
472     * @param _gasLimit The gas limit to use for the gas refund.
473     */
474     function getSignHash(
475         address _from,
476         address _to,
477         uint256 _value,
478         bytes memory _data,
479         uint256 _nonce,
480         uint256 _gasPrice,
481         uint256 _gasLimit
482     )
483         internal
484         pure
485         returns (bytes32)
486     {
487         return keccak256(
488             abi.encodePacked(
489                 "\x19Ethereum Signed Message:\n32",
490                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
491         ));
492     }
493 
494     /**
495     * @dev Checks if the relayed transaction is unique.
496     * @param _wallet The target wallet.
497     * @param _nonce The nonce
498     * @param _signHash The signed hash of the transaction
499     */
500     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
501         if(relayer[address(_wallet)].executedTx[_signHash] == true) {
502             return false;
503         }
504         relayer[address(_wallet)].executedTx[_signHash] = true;
505         return true;
506     }
507 
508     /**
509     * @dev Checks that a nonce has the correct format and is valid.
510     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
511     * @param _wallet The target wallet.
512     * @param _nonce The nonce
513     */
514     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
515         if(_nonce <= relayer[address(_wallet)].nonce) {
516             return false;
517         }
518         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
519         if(nonceBlock > block.number + BLOCKBOUND) {
520             return false;
521         }
522         relayer[address(_wallet)].nonce = _nonce;
523         return true;
524     }
525 
526     /**
527     * @dev Recovers the signer at a given position from a list of concatenated signatures.
528     * @param _signedHash The signed hash
529     * @param _signatures The concatenated signatures.
530     * @param _index The index of the signature to recover.
531     */
532     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
533         uint8 v;
534         bytes32 r;
535         bytes32 s;
536         // we jump 32 (0x20) as the first slot of bytes contains the length
537         // we jump 65 (0x41) per signature
538         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
539         // solium-disable-next-line security/no-inline-assembly
540         assembly {
541             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
542             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
543             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
544         }
545         require(v == 27 || v == 28);
546         return ecrecover(_signedHash, v, r, s);
547     }
548 
549     /**
550     * @dev Refunds the gas used to the Relayer. 
551     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
552     * @param _wallet The target wallet.
553     * @param _gasUsed The gas used.
554     * @param _gasPrice The gas price for the refund.
555     * @param _gasLimit The gas limit for the refund.
556     * @param _signatures The number of signatures used in the call.
557     * @param _relayer The address of the Relayer.
558     */
559     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
560         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
561         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
562         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
563             if(_gasPrice > tx.gasprice) {
564                 amount = amount * tx.gasprice;
565             }
566             else {
567                 amount = amount * _gasPrice;
568             }
569             invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
570         }
571     }
572 
573     /**
574     * @dev Returns false if the refund is expected to fail.
575     * @param _wallet The target wallet.
576     * @param _gasUsed The expected gas used.
577     * @param _gasPrice The expected gas price for the refund.
578     */
579     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
580         if(_gasPrice > 0
581             && _signatures > 1
582             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
583             return false;
584         }
585         return true;
586     }
587 
588     /**
589     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
590     * as the wallet passed as the input of the execute() method. 
591     @return false if the addresses are different.
592     */
593     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
594         require(_data.length >= 36, "RM: Invalid dataWallet");
595         address dataWallet;
596         // solium-disable-next-line security/no-inline-assembly
597         assembly {
598             //_data = {length:32}{sig:4}{_wallet:32}{...}
599             dataWallet := mload(add(_data, 0x24))
600         }
601         return dataWallet == _wallet;
602     }
603 
604     /**
605     * @dev Parses the data to extract the method signature.
606     */
607     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
608         require(_data.length >= 4, "RM: Invalid functionPrefix");
609         // solium-disable-next-line security/no-inline-assembly
610         assembly {
611             prefix := mload(add(_data, 0x20))
612         }
613     }
614 }
615 
616 /**
617  * @title OnlyOwnerModule
618  * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
619  * must be called with one signature frm the owner.
620  * @author Julien Niset - <julien@argent.im>
621  */
622 contract OnlyOwnerModule is BaseModule, RelayerModule {
623 
624     // bytes4 private constant IS_ONLY_OWNER_MODULE = bytes4(keccak256("isOnlyOwnerModule()"));
625 
626    /**
627     * @dev Returns a constant that indicates that the module is an OnlyOwnerModule.
628     * @return The constant bytes4(keccak256("isOnlyOwnerModule()"))
629     */
630     function isOnlyOwnerModule() external pure returns (bytes4) {
631         // return IS_ONLY_OWNER_MODULE;
632         return this.isOnlyOwnerModule.selector;
633     }
634 
635     /**
636      * @dev Adds a module to a wallet. First checks that the module is registered.
637      * Unlike its overrided parent, this method can be called via the RelayerModule's execute()
638      * @param _wallet The target wallet.
639      * @param _module The modules to authorise.
640      */
641     function addModule(BaseWallet _wallet, Module _module) external onlyWalletOwner(_wallet) {
642         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
643         _wallet.authoriseModule(address(_module), true);
644     }
645 
646     // *************** Implementation of RelayerModule methods ********************* //
647 
648     // Overrides to use the incremental nonce and save some gas
649     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 /* _signHash */) internal returns (bool) {
650         return checkAndUpdateNonce(_wallet, _nonce);
651     }
652 
653     function validateSignatures(
654         BaseWallet _wallet,
655         bytes memory /* _data */,
656         bytes32 _signHash,
657         bytes memory _signatures
658     )
659         internal
660         view
661         returns (bool)
662     {
663         address signer = recoverSigner(_signHash, _signatures, 0);
664         return isOwner(_wallet, signer); // "OOM: signer must be owner"
665     }
666 
667     function getRequiredSignatures(BaseWallet /* _wallet */, bytes memory /* _data */) internal view returns (uint256) {
668         return 1;
669     }
670 }
671 
672 /**
673  * @title LimitManager
674  * @dev Module to manage a daily spending limit
675  * @author Julien Niset - <julien@argent.im>
676  */
677 contract LimitManager is BaseModule {
678 
679     // large limit when the limit can be considered disabled
680     uint128 constant private LIMIT_DISABLED = uint128(-1); // 3.40282366920938463463374607431768211455e+38
681 
682     using SafeMath for uint256;
683 
684     struct LimitManagerConfig {
685         // The daily limit
686         Limit limit;
687         // The current usage
688         DailySpent dailySpent;
689     }
690 
691     struct Limit {
692         // the current limit
693         uint128 current;
694         // the pending limit if any
695         uint128 pending;
696         // when the pending limit becomes the current limit
697         uint64 changeAfter;
698     }
699 
700     struct DailySpent {
701         // The amount already spent during the current period
702         uint128 alreadySpent;
703         // The end of the current period
704         uint64 periodEnd;
705     }
706 
707     // wallet specific storage
708     mapping (address => LimitManagerConfig) internal limits;
709     // The default limit
710     uint256 public defaultLimit;
711 
712     // *************** Events *************************** //
713 
714     event LimitChanged(address indexed wallet, uint indexed newLimit, uint64 indexed startAfter);
715 
716     // *************** Constructor ********************** //
717 
718     constructor(uint256 _defaultLimit) public {
719         defaultLimit = _defaultLimit;
720     }
721 
722     // *************** External/Public Functions ********************* //
723 
724     /**
725      * @dev Inits the module for a wallet by setting the limit to the default value.
726      * @param _wallet The target wallet.
727      */
728     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
729         Limit storage limit = limits[address(_wallet)].limit;
730         if(limit.current == 0 && limit.changeAfter == 0) {
731             limit.current = uint128(defaultLimit);
732         }
733     }
734 
735     // *************** Internal Functions ********************* //
736 
737     /**
738      * @dev Changes the daily limit.
739      * The limit is expressed in ETH and the change is pending for the security period.
740      * @param _wallet The target wallet.
741      * @param _newLimit The new limit.
742      * @param _securityPeriod The security period.
743      */
744     function changeLimit(BaseWallet _wallet, uint256 _newLimit, uint256 _securityPeriod) internal {
745         Limit storage limit = limits[address(_wallet)].limit;
746         // solium-disable-next-line security/no-block-members
747         uint128 current = (limit.changeAfter > 0 && limit.changeAfter < now) ? limit.pending : limit.current;
748         limit.current = current;
749         limit.pending = uint128(_newLimit);
750         // solium-disable-next-line security/no-block-members
751         limit.changeAfter = uint64(now.add(_securityPeriod));
752         // solium-disable-next-line security/no-block-members
753         emit LimitChanged(address(_wallet), _newLimit, uint64(now.add(_securityPeriod)));
754     }
755 
756      /**
757      * @dev Disable the daily limit.
758      * The change is pending for the security period.
759      * @param _wallet The target wallet.
760      * @param _securityPeriod The security period.
761      */
762     function disableLimit(BaseWallet _wallet, uint256 _securityPeriod) internal {
763         changeLimit(_wallet, LIMIT_DISABLED, _securityPeriod);
764     }
765 
766     /**
767     * @dev Gets the current daily limit for a wallet.
768     * @param _wallet The target wallet.
769     * @return the current limit expressed in ETH.
770     */
771     function getCurrentLimit(BaseWallet _wallet) public view returns (uint256 _currentLimit) {
772         Limit storage limit = limits[address(_wallet)].limit;
773         _currentLimit = uint256(currentLimit(limit.current, limit.pending, limit.changeAfter));
774     }
775 
776     /**
777     * @dev Returns whether the daily limit is disabled for a wallet.
778     * @param _wallet The target wallet.
779     * @return true if the daily limit is disabled, false otherwise.
780     */
781     function isLimitDisabled(BaseWallet _wallet) public view returns (bool _limitDisabled) {
782         uint256 currentLimit = getCurrentLimit(_wallet);
783         _limitDisabled = currentLimit == LIMIT_DISABLED;
784     }
785 
786     /**
787     * @dev Gets a pending limit for a wallet if any.
788     * @param _wallet The target wallet.
789     * @return the pending limit (in ETH) and the time at chich it will become effective.
790     */
791     function getPendingLimit(BaseWallet _wallet) external view returns (uint256 _pendingLimit, uint64 _changeAfter) {
792         Limit storage limit = limits[address(_wallet)].limit;
793         // solium-disable-next-line security/no-block-members
794         return ((now < limit.changeAfter)? (uint256(limit.pending), limit.changeAfter) : (0,0));
795     }
796 
797     /**
798     * @dev Gets the amount of tokens that has not yet been spent during the current period.
799     * @param _wallet The target wallet.
800     * @return the amount of tokens (in ETH) that has not been spent yet and the end of the period.
801     */
802     function getDailyUnspent(BaseWallet _wallet) external view returns (uint256 _unspent, uint64 _periodEnd) {
803         uint256 limit = getCurrentLimit(_wallet);
804         DailySpent storage expense = limits[address(_wallet)].dailySpent;
805         // solium-disable-next-line security/no-block-members
806         if(now > expense.periodEnd) {
807             _unspent = limit;
808             // solium-disable-next-line security/no-block-members
809             _periodEnd = uint64(now + 24 hours);
810         }
811         else {
812             _periodEnd = expense.periodEnd;
813             if(expense.alreadySpent < limit) {
814                 _unspent = limit - expense.alreadySpent;
815             }
816         }
817     }
818 
819     /**
820     * @dev Helper method to check if a transfer is within the limit.
821     * If yes the daily unspent for the current period is updated.
822     * @param _wallet The target wallet.
823     * @param _amount The amount for the transfer
824     */
825     function checkAndUpdateDailySpent(BaseWallet _wallet, uint _amount) internal returns (bool) {
826         if(_amount == 0) return true;
827         Limit storage limit = limits[address(_wallet)].limit;
828         uint128 current = currentLimit(limit.current, limit.pending, limit.changeAfter);
829         if(isWithinDailyLimit(_wallet, current, _amount)) {
830             updateDailySpent(_wallet, current, _amount);
831             return true;
832         }
833         return false;
834     }
835 
836     /**
837     * @dev Helper method to update the daily spent for the current period.
838     * @param _wallet The target wallet.
839     * @param _limit The current limit for the wallet.
840     * @param _amount The amount to add to the daily spent.
841     */
842     function updateDailySpent(BaseWallet _wallet, uint128 _limit, uint _amount) internal {
843         if(_limit != LIMIT_DISABLED) {
844             DailySpent storage expense = limits[address(_wallet)].dailySpent;
845             // solium-disable-next-line security/no-block-members
846             if (expense.periodEnd < now) {
847                 // solium-disable-next-line security/no-block-members
848                 expense.periodEnd = uint64(now + 24 hours);
849                 expense.alreadySpent = uint128(_amount);
850             }
851             else {
852                 expense.alreadySpent += uint128(_amount);
853             }
854         }
855     }
856 
857     /**
858     * @dev Checks if a transfer amount is withing the daily limit for a wallet.
859     * @param _wallet The target wallet.
860     * @param _limit The current limit for the wallet.
861     * @param _amount The transfer amount.
862     * @return true if the transfer amount is withing the daily limit.
863     */
864     function isWithinDailyLimit(BaseWallet _wallet, uint _limit, uint _amount) internal view returns (bool)  {
865         if(_limit == LIMIT_DISABLED) {
866             return true;
867         }
868         DailySpent storage expense = limits[address(_wallet)].dailySpent;
869         // solium-disable-next-line security/no-block-members
870         if (expense.periodEnd < now) {
871             return (_amount <= _limit);
872         } else {
873             return (expense.alreadySpent + _amount <= _limit && expense.alreadySpent + _amount >= expense.alreadySpent);
874         }
875     }
876 
877     /**
878     * @dev Helper method to get the current limit from a Limit struct.
879     * @param _current The value of the current parameter
880     * @param _pending The value of the pending parameter
881     * @param _changeAfter The value of the changeAfter parameter
882     */
883     function currentLimit(uint128 _current, uint128 _pending, uint64 _changeAfter) internal view returns (uint128) {
884         // solium-disable-next-line security/no-block-members
885         if(_changeAfter > 0 && _changeAfter < now) {
886             return _pending;
887         }
888         return _current;
889     }
890 
891 }
892 
893 /**
894  * @title BaseTransfer
895  * @dev Module containing internal methods to execute or approve transfers
896  * @author Olivier VDB - <olivier@argent.xyz>
897  */
898 contract BaseTransfer is BaseModule {
899 
900     // Mock token address for ETH
901     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
902 
903     // *************** Events *************************** //
904 
905     event Transfer(address indexed wallet, address indexed token, uint256 indexed amount, address to, bytes data);
906     event Approved(address indexed wallet, address indexed token, uint256 amount, address spender);
907     event CalledContract(address indexed wallet, address indexed to, uint256 amount, bytes data);
908 
909     // *************** Internal Functions ********************* //
910 
911     /**
912     * @dev Helper method to transfer ETH or ERC20 for a wallet.
913     * @param _wallet The target wallet.
914     * @param _token The ERC20 address.
915     * @param _to The recipient.
916     * @param _value The amount of ETH to transfer
917     * @param _data The data to *log* with the transfer.
918     */
919     function doTransfer(BaseWallet _wallet, address _token, address _to, uint256 _value, bytes memory _data) internal {
920         if(_token == ETH_TOKEN) {
921             invokeWallet(address(_wallet), _to, _value, EMPTY_BYTES);
922         }
923         else {
924             bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", _to, _value);
925             invokeWallet(address(_wallet), _token, 0, methodData);
926         }
927         emit Transfer(address(_wallet), _token, _value, _to, _data);
928     }
929 
930     /**
931     * @dev Helper method to approve spending the ERC20 of a wallet.
932     * @param _wallet The target wallet.
933     * @param _token The ERC20 address.
934     * @param _spender The spender address.
935     * @param _value The amount of token to transfer.
936     */
937     function doApproveToken(BaseWallet _wallet, address _token, address _spender, uint256 _value) internal {
938         bytes memory methodData = abi.encodeWithSignature("approve(address,uint256)", _spender, _value);
939         invokeWallet(address(_wallet), _token, 0, methodData);
940         emit Approved(address(_wallet), _token, _value, _spender);
941     }
942 
943     /**
944     * @dev Helper method to call an external contract.
945     * @param _wallet The target wallet.
946     * @param _contract The contract address.
947     * @param _value The ETH value to transfer.
948     * @param _data The method data.
949     */
950     function doCallContract(BaseWallet _wallet, address _contract, uint256 _value, bytes memory _data) internal {
951         invokeWallet(address(_wallet), _contract, _value, _data);
952         emit CalledContract(address(_wallet), _contract, _value, _data);
953     }
954 }
955 
956 /**
957  * @title MakerV2Manager
958  * @dev Module to convert SAI <-> DAI and lock/unlock MCD DAI into/from Maker's Pot,
959  * @author Olivier VDB - <olivier@argent.xyz>
960  */
961 contract MakerV2Manager is Invest, BaseModule, RelayerModule, OnlyOwnerModule {
962 
963     bytes32 constant NAME = "MakerV2Manager";
964 
965     // The address of the SAI token
966     GemLike public saiToken;
967     // The address of the (MCD) DAI token
968     GemLike public daiToken;
969     // The address of the SAI <-> DAI migration contract
970     address public scdMcdMigration;
971     // The address of the Pot
972     PotLike public pot;
973     // The address of the Dai Adapter
974     JoinLike public daiJoin;
975     // The address of the Vat
976     VatLike public vat;
977 
978     // Method signatures to reduce gas cost at depoyment
979     bytes4 constant internal ERC20_APPROVE = bytes4(keccak256("approve(address,uint256)"));
980     bytes4 constant internal SWAP_SAI_DAI = bytes4(keccak256("swapSaiToDai(uint256)"));
981     bytes4 constant internal SWAP_DAI_SAI = bytes4(keccak256("swapDaiToSai(uint256)"));
982     bytes4 constant internal ADAPTER_JOIN = bytes4(keccak256("join(address,uint256)"));
983     bytes4 constant internal ADAPTER_EXIT = bytes4(keccak256("exit(address,uint256)"));
984     bytes4 constant internal VAT_HOPE = bytes4(keccak256("hope(address)"));
985     bytes4 constant internal POT_JOIN = bytes4(keccak256("join(uint256)"));
986     bytes4 constant internal POT_EXIT = bytes4(keccak256("exit(uint256)"));
987 
988     uint256 constant internal RAY = 10 ** 27;
989 
990     using SafeMath for uint256;
991 
992     // ****************** Events *************************** //
993 
994     event TokenConverted(address indexed _wallet, address _srcToken, uint _srcAmount, address _destToken, uint _destAmount);
995 
996     // *************** Constructor ********************** //
997 
998     constructor(
999         ModuleRegistry _registry,
1000         GuardianStorage _guardianStorage,
1001         ScdMcdMigration _scdMcdMigration,
1002         PotLike _pot
1003     )
1004         BaseModule(_registry, _guardianStorage, NAME)
1005         public
1006     {
1007         scdMcdMigration = address(_scdMcdMigration);
1008         saiToken = _scdMcdMigration.saiJoin().gem();
1009         daiJoin = _scdMcdMigration.daiJoin();
1010         vat = daiJoin.vat();
1011         daiToken = daiJoin.dai();
1012         pot = _pot;
1013     }
1014 
1015     // *************** External/Public Functions ********************* //
1016 
1017     /* ********************************** Implementation of Invest ************************************* */
1018 
1019     /**
1020      * @dev Invest tokens for a given period.
1021      * @param _wallet The target wallet.
1022      * @param _token The token address.
1023      * @param _amount The amount of tokens to invest.
1024      * @param _period The period over which the tokens may be locked in the investment (optional).
1025      * @return The exact amount of tokens that have been invested.
1026      */
1027     function addInvestment(
1028         BaseWallet _wallet,
1029         address _token,
1030         uint256 _amount,
1031         uint256 _period
1032     )
1033         external
1034         returns (uint256 _invested)
1035     {
1036         require(_token == address(daiToken), "DM: token should be DAI");
1037         joinDsr(_wallet, _amount);
1038         _invested = _amount;
1039         emit InvestmentAdded(address(_wallet), address(daiToken), _amount, _period);
1040     }
1041 
1042     /**
1043      * @dev Exit invested postions.
1044      * @param _wallet The target wallet.
1045      * @param _token The token address.
1046      * @param _fraction The fraction of invested tokens to exit in per 10000.
1047      */
1048     function removeInvestment(
1049         BaseWallet _wallet,
1050         address _token,
1051         uint256 _fraction
1052     )
1053         external
1054     {
1055         require(_token == address(daiToken), "DM: token should be DAI");
1056         require(_fraction <= 10000, "DM: invalid fraction value");
1057         exitDsr(_wallet, dsrBalance(_wallet).mul(_fraction) / 10000);
1058         emit InvestmentRemoved(address(_wallet), _token, _fraction);
1059     }
1060 
1061     /**
1062      * @dev Get the amount of investment in a given token.
1063      * @param _wallet The target wallet.
1064      * @param _token The token address.
1065      * @return The value in tokens of the investment (including interests) and the time at which the investment can be removed.
1066      */
1067     function getInvestment(
1068         BaseWallet _wallet,
1069         address _token
1070     )
1071         external
1072         view
1073         returns (uint256 _tokenValue, uint256 _periodEnd)
1074     {
1075         _tokenValue = _token == address(daiToken) ? dsrBalance(_wallet) : 0;
1076         _periodEnd = 0;
1077     }
1078 
1079     /* ****************************************** DSR wrappers ******************************************* */
1080 
1081     function dsrBalance(BaseWallet _wallet) public view returns (uint256) {
1082         return pot.chi().mul(pot.pie(address(_wallet))) / RAY;
1083     }
1084 
1085     /**
1086     * @dev lets the owner deposit MCD DAI into the DSR Pot.
1087     * @param _wallet The target wallet.
1088     * @param _amount The amount of DAI to deposit
1089     */
1090     function joinDsr(
1091         BaseWallet _wallet,
1092         uint256 _amount
1093     )
1094         public
1095         onlyWalletOwner(_wallet)
1096         onlyWhenUnlocked(_wallet)
1097     {
1098         if (daiToken.balanceOf(address(_wallet)) < _amount) {
1099             swapSaiToDai(_wallet, _amount - daiToken.balanceOf(address(_wallet)));
1100         }
1101 
1102         // Execute drip to get the chi rate updated to rho == now, otherwise join will fail
1103         pot.drip();
1104         // Approve DAI adapter to take the DAI amount
1105         invokeWallet(address(_wallet), address(daiToken), 0, abi.encodeWithSelector(ERC20_APPROVE, address(daiJoin), _amount));
1106         // Join DAI into the vat (_amount of external DAI is burned and the vat transfers _amount of internal DAI from the adapter to the _wallet)
1107         invokeWallet(address(_wallet), address(daiJoin), 0, abi.encodeWithSelector(ADAPTER_JOIN, address(_wallet), _amount));
1108         // Approve the pot to take out (internal) DAI from the wallet's balance in the vat
1109         if (vat.can(address(_wallet), address(pot)) == 0) {
1110             invokeWallet(address(_wallet), address(vat), 0, abi.encodeWithSelector(VAT_HOPE, address(pot)));
1111         }
1112         // Compute the pie value in the pot
1113         uint256 pie = _amount.mul(RAY) / pot.chi();
1114         // Join the pie value to the pot
1115         invokeWallet(address(_wallet), address(pot), 0, abi.encodeWithSelector(POT_JOIN, pie));
1116     }
1117 
1118     /**
1119     * @dev lets the owner withdraw MCD DAI from the DSR Pot.
1120     * @param _wallet The target wallet.
1121     * @param _amount The amount of DAI to withdraw
1122     */
1123     function exitDsr(
1124         BaseWallet _wallet,
1125         uint256 _amount
1126     )
1127         public
1128         onlyWalletOwner(_wallet)
1129         onlyWhenUnlocked(_wallet)
1130     {
1131         // Execute drip to count the savings accumulated until this moment
1132         pot.drip();
1133         // Calculates the pie value in the pot equivalent to the DAI wad amount
1134         uint256 pie = _amount.mul(RAY) / pot.chi();
1135         // Exit DAI from the pot
1136         invokeWallet(address(_wallet), address(pot), 0, abi.encodeWithSelector(POT_EXIT, pie));
1137         // Allow adapter to access the _wallet's DAI balance in the vat
1138         if (vat.can(address(_wallet), address(daiJoin)) == 0) {
1139             invokeWallet(address(_wallet), address(vat), 0, abi.encodeWithSelector(VAT_HOPE, address(daiJoin)));
1140         }
1141         // Check the actual balance of DAI in the vat after the pot exit
1142         uint bal = vat.dai(address(_wallet));
1143         // It is necessary to check if due to rounding the exact _amount can be exited by the adapter.
1144         // Otherwise it will do the maximum DAI balance in the vat
1145         uint256 withdrawn = bal >= _amount.mul(RAY) ? _amount : bal / RAY;
1146         invokeWallet(address(_wallet), address(daiJoin), 0, abi.encodeWithSelector(ADAPTER_EXIT, address(_wallet), withdrawn));
1147     }
1148 
1149     function exitAllDsr(
1150         BaseWallet _wallet
1151     )
1152         external
1153         onlyWalletOwner(_wallet)
1154         onlyWhenUnlocked(_wallet)
1155     {
1156         // Execute drip to count the savings accumulated until this moment
1157         pot.drip();
1158         // Gets the total pie belonging to the _wallet
1159         uint256 pie = pot.pie(address(_wallet));
1160         // Exit DAI from the pot
1161         invokeWallet(address(_wallet), address(pot), 0, abi.encodeWithSelector(POT_EXIT, pie));
1162         // Allow adapter to access the _wallet's DAI balance in the vat
1163         if (vat.can(address(_wallet), address(daiJoin)) == 0) {
1164             invokeWallet(address(_wallet), address(vat), 0, abi.encodeWithSelector(VAT_HOPE, address(daiJoin)));
1165         }
1166         // Exits the DAI amount corresponding to the value of pie
1167         uint256 withdrawn = pot.chi().mul(pie) / RAY;
1168         invokeWallet(address(_wallet), address(daiJoin), 0, abi.encodeWithSelector(ADAPTER_EXIT, address(_wallet), withdrawn));
1169     }
1170 
1171     /**
1172     * @dev lets the owner convert SCD SAI into MCD DAI.
1173     * @param _wallet The target wallet.
1174     * @param _amount The amount of SAI to convert
1175     */
1176     function swapSaiToDai(
1177         BaseWallet _wallet,
1178         uint256 _amount
1179     )
1180         public
1181         onlyWalletOwner(_wallet)
1182         onlyWhenUnlocked(_wallet)
1183     {
1184         require(saiToken.balanceOf(address(_wallet)) >= _amount, "DM: insufficient SAI");
1185         invokeWallet(address(_wallet), address(saiToken), 0, abi.encodeWithSelector(ERC20_APPROVE, scdMcdMigration, _amount));
1186         invokeWallet(address(_wallet), scdMcdMigration, 0, abi.encodeWithSelector(SWAP_SAI_DAI, _amount));
1187         emit TokenConverted(address(_wallet), address(saiToken), _amount, address(daiToken), _amount);
1188     }
1189 
1190     /**
1191     * @dev lets the owner convert MCD DAI into SCD SAI.
1192     * @param _wallet The target wallet.
1193     * @param _amount The amount of DAI to convert
1194     */
1195     function swapDaiToSai(
1196         BaseWallet _wallet,
1197         uint256 _amount
1198     )
1199         external
1200         onlyWalletOwner(_wallet)
1201         onlyWhenUnlocked(_wallet)
1202     {
1203         require(daiToken.balanceOf(address(_wallet)) >= _amount, "DM: insufficient DAI");
1204         invokeWallet(address(_wallet), address(daiToken), 0, abi.encodeWithSelector(ERC20_APPROVE, scdMcdMigration, _amount));
1205         invokeWallet(address(_wallet), scdMcdMigration, 0, abi.encodeWithSelector(SWAP_DAI_SAI, _amount));
1206         emit TokenConverted(address(_wallet), address(daiToken), _amount, address(saiToken), _amount);
1207     }
1208 }