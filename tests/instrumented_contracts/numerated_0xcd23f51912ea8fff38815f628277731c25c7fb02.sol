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
107  * @title SafeMath
108  * @dev Math operations with safety checks that throw on error
109  */
110 library SafeMath {
111 
112     /**
113     * @dev Multiplies two numbers, reverts on overflow.
114     */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117         // benefit is lost if 'b' is also tested.
118         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b);
125 
126         return c;
127     }
128 
129     /**
130     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
131     */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b > 0); // Solidity only automatically asserts when dividing by 0
134         uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136 
137         return c;
138     }
139 
140     /**
141     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
142     */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         require(b <= a);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151     * @dev Adds two numbers, reverts on overflow.
152     */
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a);
156 
157         return c;
158     }
159 
160     /**
161     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
162     * reverts when dividing by zero.
163     */
164     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         require(b != 0);
166         return a % b;
167     }
168 
169     /**
170     * @dev Returns ceil(a / b).
171     */
172     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a / b;
174         if(a % b == 0) {
175             return c;
176         }
177         else {
178             return c + 1;
179         }
180     }
181 }
182 
183 library GuardianUtils {
184 
185     /**
186     * @dev Checks if an address is an account guardian or an account authorised to sign on behalf of a smart-contract guardian
187     * given a list of guardians.
188     * @param _guardians the list of guardians
189     * @param _guardian the address to test
190     * @return true and the list of guardians minus the found guardian upon success, false and the original list of guardians if not found.
191     */
192     function isGuardian(address[] memory _guardians, address _guardian) internal view returns (bool, address[] memory) {
193         if(_guardians.length == 0 || _guardian == address(0)) {
194             return (false, _guardians);
195         }
196         bool isFound = false;
197         address[] memory updatedGuardians = new address[](_guardians.length - 1);
198         uint256 index = 0;
199         for (uint256 i = 0; i < _guardians.length; i++) {
200             if(!isFound) {
201                 // check if _guardian is an account guardian
202                 if(_guardian == _guardians[i]) {
203                     isFound = true;
204                     continue;
205                 }
206                 // check if _guardian is the owner of a smart contract guardian
207                 if(isContract(_guardians[i]) && isGuardianOwner(_guardians[i], _guardian)) {
208                     isFound = true;
209                     continue;
210                 }
211             }
212             if(index < updatedGuardians.length) {
213                 updatedGuardians[index] = _guardians[i];
214                 index++;
215             }
216         }
217         return isFound ? (true, updatedGuardians) : (false, _guardians);
218     }
219 
220    /**
221     * @dev Checks if an address is a contract.
222     * @param _addr The address.
223     */
224     function isContract(address _addr) internal view returns (bool) {
225         uint32 size;
226         // solium-disable-next-line security/no-inline-assembly
227         assembly {
228             size := extcodesize(_addr)
229         }
230         return (size > 0);
231     }
232 
233     /**
234     * @dev Checks if an address is the owner of a guardian contract. 
235     * The method does not revert if the call to the owner() method consumes more then 5000 gas. 
236     * @param _guardian The guardian contract
237     * @param _owner The owner to verify.
238     */
239     function isGuardianOwner(address _guardian, address _owner) internal view returns (bool) {
240         address owner = address(0);
241         bytes4 sig = bytes4(keccak256("owner()"));
242         // solium-disable-next-line security/no-inline-assembly
243         assembly {
244             let ptr := mload(0x40)
245             mstore(ptr,sig)
246             let result := staticcall(5000, _guardian, ptr, 0x20, ptr, 0x20)
247             if eq(result, 1) {
248                 owner := mload(ptr)
249             }
250         }
251         return owner == _owner;
252     }
253 } 
254 
255 /**
256  * @title BaseModule
257  * @dev Basic module that contains some methods common to all modules.
258  * @author Julien Niset - <julien@argent.im>
259  */
260 contract BaseModule is Module {
261 
262     // Empty calldata
263     bytes constant internal EMPTY_BYTES = "";
264 
265     // The adddress of the module registry.
266     ModuleRegistry internal registry;
267     // The address of the Guardian storage
268     GuardianStorage internal guardianStorage;
269 
270     /**
271      * @dev Throws if the wallet is locked.
272      */
273     modifier onlyWhenUnlocked(BaseWallet _wallet) {
274         // solium-disable-next-line security/no-block-members
275         require(!guardianStorage.isLocked(_wallet), "BM: wallet must be unlocked");
276         _;
277     }
278 
279     event ModuleCreated(bytes32 name);
280     event ModuleInitialised(address wallet);
281 
282     constructor(ModuleRegistry _registry, GuardianStorage _guardianStorage, bytes32 _name) public {
283         registry = _registry;
284         guardianStorage = _guardianStorage;
285         emit ModuleCreated(_name);
286     }
287 
288     /**
289      * @dev Throws if the sender is not the target wallet of the call.
290      */
291     modifier onlyWallet(BaseWallet _wallet) {
292         require(msg.sender == address(_wallet), "BM: caller must be wallet");
293         _;
294     }
295 
296     /**
297      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
298      */
299     modifier onlyWalletOwner(BaseWallet _wallet) {
300         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
301         _;
302     }
303 
304     /**
305      * @dev Throws if the sender is not the owner of the target wallet.
306      */
307     modifier strictOnlyWalletOwner(BaseWallet _wallet) {
308         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
309         _;
310     }
311 
312     /**
313      * @dev Inits the module for a wallet by logging an event.
314      * The method can only be called by the wallet itself.
315      * @param _wallet The wallet.
316      */
317     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
318         emit ModuleInitialised(address(_wallet));
319     }
320 
321     /**
322      * @dev Adds a module to a wallet. First checks that the module is registered.
323      * @param _wallet The target wallet.
324      * @param _module The modules to authorise.
325      */
326     function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
327         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
328         _wallet.authoriseModule(address(_module), true);
329     }
330 
331     /**
332     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
333     * module by mistake and transfer them to the Module Registry. 
334     * @param _token The token to recover.
335     */
336     function recoverToken(address _token) external {
337         uint total = ERC20(_token).balanceOf(address(this));
338         ERC20(_token).transfer(address(registry), total);
339     }
340 
341     /**
342      * @dev Helper method to check if an address is the owner of a target wallet.
343      * @param _wallet The target wallet.
344      * @param _addr The address.
345      */
346     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
347         return _wallet.owner() == _addr;
348     }
349 
350     /**
351      * @dev Helper method to invoke a wallet.
352      * @param _wallet The target wallet.
353      * @param _to The target address for the transaction.
354      * @param _value The value of the transaction.
355      * @param _data The data of the transaction.
356      */
357     function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data) internal returns (bytes memory _res) {
358         bool success;
359         // solium-disable-next-line security/no-call-value
360         (success, _res) = _wallet.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _to, _value, _data));
361         if(success && _res.length > 0) { //_res is empty if _wallet is an "old" BaseWallet that can't return output values
362             (_res) = abi.decode(_res, (bytes));
363         } else if (_res.length > 0) {
364             // solium-disable-next-line security/no-inline-assembly
365             assembly {
366                 returndatacopy(0, 0, returndatasize)
367                 revert(0, returndatasize)
368             }
369         } else if(!success) {
370             revert("BM: wallet invoke reverted");
371         }
372     }
373 }
374 
375 /**
376  * @title RelayerModule
377  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer.
378  * @author Julien Niset - <julien@argent.im>
379  */
380 contract RelayerModule is BaseModule {
381 
382     uint256 constant internal BLOCKBOUND = 10000;
383 
384     mapping (address => RelayerConfig) public relayer;
385 
386     struct RelayerConfig {
387         uint256 nonce;
388         mapping (bytes32 => bool) executedTx;
389     }
390 
391     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
392 
393     /**
394      * @dev Throws if the call did not go through the execute() method.
395      */
396     modifier onlyExecute {
397         require(msg.sender == address(this), "RM: must be called via execute()");
398         _;
399     }
400 
401     /* ***************** Abstract method ************************* */
402 
403     /**
404     * @dev Gets the number of valid signatures that must be provided to execute a
405     * specific relayed transaction.
406     * @param _wallet The target wallet.
407     * @param _data The data of the relayed transaction.
408     * @return The number of required signatures.
409     */
410     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);
411 
412     /**
413     * @dev Validates the signatures provided with a relayed transaction.
414     * The method MUST throw if one or more signatures are not valid.
415     * @param _wallet The target wallet.
416     * @param _data The data of the relayed transaction.
417     * @param _signHash The signed hash representing the relayed transaction.
418     * @param _signatures The signatures as a concatenated byte array.
419     */
420     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool);
421 
422     /* ************************************************************ */
423 
424     /**
425     * @dev Executes a relayed transaction.
426     * @param _wallet The target wallet.
427     * @param _data The data for the relayed transaction
428     * @param _nonce The nonce used to prevent replay attacks.
429     * @param _signatures The signatures as a concatenated byte array.
430     * @param _gasPrice The gas price to use for the gas refund.
431     * @param _gasLimit The gas limit to use for the gas refund.
432     */
433     function execute(
434         BaseWallet _wallet,
435         bytes calldata _data,
436         uint256 _nonce,
437         bytes calldata _signatures,
438         uint256 _gasPrice,
439         uint256 _gasLimit
440     )
441         external
442         returns (bool success)
443     {
444         uint startGas = gasleft();
445         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
446         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
447         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
448         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
449         if((requiredSignatures * 65) == _signatures.length) {
450             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
451                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
452                     // solium-disable-next-line security/no-call-value
453                     (success,) = address(this).call(_data);
454                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
455                 }
456             }
457         }
458         emit TransactionExecuted(address(_wallet), success, signHash);
459     }
460 
461     /**
462     * @dev Gets the current nonce for a wallet.
463     * @param _wallet The target wallet.
464     */
465     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
466         return relayer[address(_wallet)].nonce;
467     }
468 
469     /**
470     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
471     * @param _from The starting address for the relayed transaction (should be the module)
472     * @param _to The destination address for the relayed transaction (should be the wallet)
473     * @param _value The value for the relayed transaction
474     * @param _data The data for the relayed transaction
475     * @param _nonce The nonce used to prevent replay attacks.
476     * @param _gasPrice The gas price to use for the gas refund.
477     * @param _gasLimit The gas limit to use for the gas refund.
478     */
479     function getSignHash(
480         address _from,
481         address _to,
482         uint256 _value,
483         bytes memory _data,
484         uint256 _nonce,
485         uint256 _gasPrice,
486         uint256 _gasLimit
487     )
488         internal
489         pure
490         returns (bytes32)
491     {
492         return keccak256(
493             abi.encodePacked(
494                 "\x19Ethereum Signed Message:\n32",
495                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
496         ));
497     }
498 
499     /**
500     * @dev Checks if the relayed transaction is unique.
501     * @param _wallet The target wallet.
502     * @param _nonce The nonce
503     * @param _signHash The signed hash of the transaction
504     */
505     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
506         if(relayer[address(_wallet)].executedTx[_signHash] == true) {
507             return false;
508         }
509         relayer[address(_wallet)].executedTx[_signHash] = true;
510         return true;
511     }
512 
513     /**
514     * @dev Checks that a nonce has the correct format and is valid.
515     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
516     * @param _wallet The target wallet.
517     * @param _nonce The nonce
518     */
519     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
520         if(_nonce <= relayer[address(_wallet)].nonce) {
521             return false;
522         }
523         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
524         if(nonceBlock > block.number + BLOCKBOUND) {
525             return false;
526         }
527         relayer[address(_wallet)].nonce = _nonce;
528         return true;
529     }
530 
531     /**
532     * @dev Recovers the signer at a given position from a list of concatenated signatures.
533     * @param _signedHash The signed hash
534     * @param _signatures The concatenated signatures.
535     * @param _index The index of the signature to recover.
536     */
537     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
538         uint8 v;
539         bytes32 r;
540         bytes32 s;
541         // we jump 32 (0x20) as the first slot of bytes contains the length
542         // we jump 65 (0x41) per signature
543         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
544         // solium-disable-next-line security/no-inline-assembly
545         assembly {
546             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
547             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
548             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
549         }
550         require(v == 27 || v == 28);
551         return ecrecover(_signedHash, v, r, s);
552     }
553 
554     /**
555     * @dev Refunds the gas used to the Relayer. 
556     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
557     * @param _wallet The target wallet.
558     * @param _gasUsed The gas used.
559     * @param _gasPrice The gas price for the refund.
560     * @param _gasLimit The gas limit for the refund.
561     * @param _signatures The number of signatures used in the call.
562     * @param _relayer The address of the Relayer.
563     */
564     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
565         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
566         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
567         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
568             if(_gasPrice > tx.gasprice) {
569                 amount = amount * tx.gasprice;
570             }
571             else {
572                 amount = amount * _gasPrice;
573             }
574             invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
575         }
576     }
577 
578     /**
579     * @dev Returns false if the refund is expected to fail.
580     * @param _wallet The target wallet.
581     * @param _gasUsed The expected gas used.
582     * @param _gasPrice The expected gas price for the refund.
583     */
584     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
585         if(_gasPrice > 0
586             && _signatures > 1
587             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
588             return false;
589         }
590         return true;
591     }
592 
593     /**
594     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
595     * as the wallet passed as the input of the execute() method. 
596     @return false if the addresses are different.
597     */
598     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
599         require(_data.length >= 36, "RM: Invalid dataWallet");
600         address dataWallet;
601         // solium-disable-next-line security/no-inline-assembly
602         assembly {
603             //_data = {length:32}{sig:4}{_wallet:32}{...}
604             dataWallet := mload(add(_data, 0x24))
605         }
606         return dataWallet == _wallet;
607     }
608 
609     /**
610     * @dev Parses the data to extract the method signature.
611     */
612     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
613         require(_data.length >= 4, "RM: Invalid functionPrefix");
614         // solium-disable-next-line security/no-inline-assembly
615         assembly {
616             prefix := mload(add(_data, 0x20))
617         }
618     }
619 }
620 
621 /**
622  * @title BaseTransfer
623  * @dev Module containing internal methods to execute or approve transfers
624  * @author Olivier VDB - <olivier@argent.xyz>
625  */
626 contract BaseTransfer is BaseModule {
627 
628     // Mock token address for ETH
629     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
630 
631     // *************** Events *************************** //
632 
633     event Transfer(address indexed wallet, address indexed token, uint256 indexed amount, address to, bytes data);
634     event Approved(address indexed wallet, address indexed token, uint256 amount, address spender);
635     event CalledContract(address indexed wallet, address indexed to, uint256 amount, bytes data);
636 
637     // *************** Internal Functions ********************* //
638 
639     /**
640     * @dev Helper method to transfer ETH or ERC20 for a wallet.
641     * @param _wallet The target wallet.
642     * @param _token The ERC20 address.
643     * @param _to The recipient.
644     * @param _value The amount of ETH to transfer
645     * @param _data The data to *log* with the transfer.
646     */
647     function doTransfer(BaseWallet _wallet, address _token, address _to, uint256 _value, bytes memory _data) internal {
648         if(_token == ETH_TOKEN) {
649             invokeWallet(address(_wallet), _to, _value, EMPTY_BYTES);
650         }
651         else {
652             bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", _to, _value);
653             invokeWallet(address(_wallet), _token, 0, methodData);
654         }
655         emit Transfer(address(_wallet), _token, _value, _to, _data);
656     }
657 
658     /**
659     * @dev Helper method to approve spending the ERC20 of a wallet.
660     * @param _wallet The target wallet.
661     * @param _token The ERC20 address.
662     * @param _spender The spender address.
663     * @param _value The amount of token to transfer.
664     */
665     function doApproveToken(BaseWallet _wallet, address _token, address _spender, uint256 _value) internal {
666         bytes memory methodData = abi.encodeWithSignature("approve(address,uint256)", _spender, _value);
667         invokeWallet(address(_wallet), _token, 0, methodData);
668         emit Approved(address(_wallet), _token, _value, _spender);
669     }
670 
671     /**
672     * @dev Helper method to call an external contract.
673     * @param _wallet The target wallet.
674     * @param _contract The contract address.
675     * @param _value The ETH value to transfer.
676     * @param _data The method data.
677     */
678     function doCallContract(BaseWallet _wallet, address _contract, uint256 _value, bytes memory _data) internal {
679         invokeWallet(address(_wallet), _contract, _value, _data);
680         emit CalledContract(address(_wallet), _contract, _value, _data);
681     }
682 }
683 
684 /**
685  * @title ApprovedTransfer
686  * @dev Module to transfer tokens (ETH or ERC20) with the approval of guardians.
687  * @author Julien Niset - <julien@argent.im>
688  */
689 contract ApprovedTransfer is BaseModule, RelayerModule, BaseTransfer {
690 
691     bytes32 constant NAME = "ApprovedTransfer";
692 
693     constructor(ModuleRegistry _registry, GuardianStorage _guardianStorage) BaseModule(_registry, _guardianStorage, NAME) public {
694 
695     }
696 
697     /**
698     * @dev transfers tokens (ETH or ERC20) from a wallet.
699     * @param _wallet The target wallet.
700     * @param _token The address of the token to transfer.
701     * @param _to The destination address
702     * @param _amount The amoutnof token to transfer
703     * @param _data  The data for the transaction (only for ETH transfers)
704     */
705     function transferToken(
706         BaseWallet _wallet,
707         address _token,
708         address _to,
709         uint256 _amount,
710         bytes calldata _data
711     )
712         external
713         onlyExecute
714         onlyWhenUnlocked(_wallet)
715     {
716         doTransfer(_wallet, _token, _to, _amount, _data);
717     }
718 
719     /**
720     * @dev call a contract.
721     * @param _wallet The target wallet.
722     * @param _contract The address of the contract.
723     * @param _value The amount of ETH to transfer as part of call
724     * @param _data The encoded method data
725     */
726     function callContract(
727         BaseWallet _wallet,
728         address _contract,
729         uint256 _value,
730         bytes calldata _data
731     )
732         external
733         onlyExecute
734         onlyWhenUnlocked(_wallet)
735     {
736         require(!_wallet.authorised(_contract) && _contract != address(_wallet), "AT: Forbidden contract");
737         doCallContract(_wallet, _contract, _value, _data);
738     }
739 
740     // *************** Implementation of RelayerModule methods ********************* //
741 
742     function validateSignatures(
743         BaseWallet _wallet,
744         bytes memory /* _data */,
745         bytes32 _signHash,
746         bytes memory _signatures
747     )
748         internal
749         view
750         returns (bool)
751     {
752         address lastSigner = address(0);
753         address[] memory guardians = guardianStorage.getGuardians(_wallet);
754         bool isGuardian = false;
755         for (uint8 i = 0; i < _signatures.length / 65; i++) {
756             address signer = recoverSigner(_signHash, _signatures, i);
757             if(i == 0) {
758                 // AT: first signer must be owner
759                 if(!isOwner(_wallet, signer)) {
760                     return false;
761                 }
762             }
763             else {
764                 // "AT: signers must be different"
765                 if(signer <= lastSigner) {
766                     return false;
767                 }
768                 lastSigner = signer;
769                 (isGuardian, guardians) = GuardianUtils.isGuardian(guardians, signer);
770                 // "AT: signatures not valid"
771                 if(!isGuardian) {
772                     return false;
773                 }
774             }
775         }
776         return true;
777     }
778 
779     function getRequiredSignatures(BaseWallet _wallet, bytes memory /* _data */) internal view returns (uint256) {
780         // owner  + [n/2] guardians
781         return  1 + SafeMath.ceil(guardianStorage.guardianCount(_wallet), 2);
782     }
783 }