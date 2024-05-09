1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Module
5  * @dev Interface for a module. 
6  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
7  * can never end up in a "frozen" state.
8  * @author Julien Niset - <julien@argent.xyz>
9  */
10 interface Module {
11 
12     /**
13      * @dev Inits a module for a wallet by e.g. setting some wallet specific parameters in storage.
14      * @param _wallet The wallet.
15      */
16     function init(BaseWallet _wallet) external;
17 
18     /**
19      * @dev Adds a module to a wallet.
20      * @param _wallet The target wallet.
21      * @param _module The modules to authorise.
22      */
23     function addModule(BaseWallet _wallet, Module _module) external;
24 
25     /**
26     * @dev Utility method to recover any ERC20 token that was sent to the
27     * module by mistake. 
28     * @param _token The token to recover.
29     */
30     function recoverToken(address _token) external;
31 }
32 
33 /**
34  * @title Upgrader
35  * @dev Interface for a contract that can upgrade wallets by enabling/disabling modules. 
36  * @author Julien Niset - <julien@argent.xyz>
37  */
38 interface Upgrader {
39 
40     /**
41      * @dev Upgrades a wallet by enabling/disabling modules.
42      * @param _wallet The owner.
43      */
44     function upgrade(address _wallet, address[] _toDisable, address[] _toEnable) external;
45 
46     function toDisable() external view returns (address[]);
47 
48     function toEnable() external view returns (address[]);
49 }
50 
51 /**
52  * @title BaseModule
53  * @dev Basic module that contains some methods common to all modules.
54  * @author Julien Niset - <julien@argent.xyz>
55  */
56 contract BaseModule is Module {
57 
58     // The adddress of the module registry.
59     ModuleRegistry internal registry;
60 
61     event ModuleCreated(bytes32 name);
62     event ModuleInitialised(address wallet);
63 
64     constructor(ModuleRegistry _registry, bytes32 _name) public {
65         registry = _registry;
66         emit ModuleCreated(_name);
67     }
68 
69     /**
70      * @dev Throws if the sender is not the target wallet of the call.
71      */
72     modifier onlyWallet(BaseWallet _wallet) {
73         require(msg.sender == address(_wallet), "BM: caller must be wallet");
74         _;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
79      */
80     modifier onlyOwner(BaseWallet _wallet) {
81         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
82         _;
83     }
84 
85     /**
86      * @dev Throws if the sender is not the owner of the target wallet.
87      */
88     modifier strictOnlyOwner(BaseWallet _wallet) {
89         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
90         _;
91     }
92 
93     /**
94      * @dev Inits the module for a wallet by logging an event.
95      * The method can only be called by the wallet itself.
96      * @param _wallet The wallet.
97      */
98     function init(BaseWallet _wallet) external onlyWallet(_wallet) {
99         emit ModuleInitialised(_wallet);
100     }
101 
102     /**
103      * @dev Adds a module to a wallet. First checks that the module is registered.
104      * @param _wallet The target wallet.
105      * @param _module The modules to authorise.
106      */
107     function addModule(BaseWallet _wallet, Module _module) external strictOnlyOwner(_wallet) {
108         require(registry.isRegisteredModule(_module), "BM: module is not registered");
109         _wallet.authoriseModule(_module, true);
110     }
111 
112     /**
113     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
114     * module by mistake and transfer them to the Module Registry. 
115     * @param _token The token to recover.
116     */
117     function recoverToken(address _token) external {
118         uint total = ERC20(_token).balanceOf(address(this));
119         ERC20(_token).transfer(address(registry), total);
120     }
121 
122     /**
123      * @dev Helper method to check if an address is the owner of a target wallet.
124      * @param _wallet The target wallet.
125      * @param _addr The address.
126      */
127     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
128         return _wallet.owner() == _addr;
129     }
130 }
131 
132 /**
133  * @title RelayerModule
134  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer. 
135  * @author Julien Niset - <julien@argent.xyz>
136  */
137 contract RelayerModule is Module {
138 
139     uint256 constant internal BLOCKBOUND = 10000;
140 
141     mapping (address => RelayerConfig) public relayer; 
142 
143     struct RelayerConfig {
144         uint256 nonce;
145         mapping (bytes32 => bool) executedTx;
146     }
147 
148     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
149 
150     /**
151      * @dev Throws if the call did not go through the execute() method.
152      */
153     modifier onlyExecute {
154         require(msg.sender == address(this), "RM: must be called via execute()");
155         _;
156     }
157 
158     /* ***************** Abstract method ************************* */
159 
160     /**
161     * @dev Gets the number of valid signatures that must be provided to execute a
162     * specific relayed transaction.
163     * @param _wallet The target wallet.
164     * @param _data The data of the relayed transaction.
165     * @return The number of required signatures.
166     */
167     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256);
168 
169     /**
170     * @dev Validates the signatures provided with a relayed transaction.
171     * The method MUST throw if one or more signatures are not valid.
172     * @param _wallet The target wallet.
173     * @param _data The data of the relayed transaction.
174     * @param _signHash The signed hash representing the relayed transaction.
175     * @param _signatures The signatures as a concatenated byte array.
176     */
177     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool);
178 
179     /* ************************************************************ */
180 
181     /**
182     * @dev Executes a relayed transaction.
183     * @param _wallet The target wallet.
184     * @param _data The data for the relayed transaction
185     * @param _nonce The nonce used to prevent replay attacks.
186     * @param _signatures The signatures as a concatenated byte array.
187     * @param _gasPrice The gas price to use for the gas refund.
188     * @param _gasLimit The gas limit to use for the gas refund.
189     */
190     function execute(
191         BaseWallet _wallet,
192         bytes _data, 
193         uint256 _nonce, 
194         bytes _signatures, 
195         uint256 _gasPrice,
196         uint256 _gasLimit
197     )
198         external
199         returns (bool success)
200     {
201         uint startGas = gasleft();
202         bytes32 signHash = getSignHash(address(this), _wallet, 0, _data, _nonce, _gasPrice, _gasLimit);
203         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
204         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
205         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
206         if((requiredSignatures * 65) == _signatures.length) {
207             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
208                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
209                     // solium-disable-next-line security/no-call-value
210                     success = address(this).call(_data);
211                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
212                 }
213             }
214         }
215         emit TransactionExecuted(_wallet, success, signHash); 
216     }
217 
218     /**
219     * @dev Gets the current nonce for a wallet.
220     * @param _wallet The target wallet.
221     */
222     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
223         return relayer[_wallet].nonce;
224     }
225 
226     /**
227     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
228     * @param _from The starting address for the relayed transaction (should be the module)
229     * @param _to The destination address for the relayed transaction (should be the wallet)
230     * @param _value The value for the relayed transaction
231     * @param _data The data for the relayed transaction
232     * @param _nonce The nonce used to prevent replay attacks.
233     * @param _gasPrice The gas price to use for the gas refund.
234     * @param _gasLimit The gas limit to use for the gas refund.
235     */
236     function getSignHash(
237         address _from,
238         address _to, 
239         uint256 _value, 
240         bytes _data, 
241         uint256 _nonce,
242         uint256 _gasPrice,
243         uint256 _gasLimit
244     ) 
245         internal 
246         pure
247         returns (bytes32) 
248     {
249         return keccak256(
250             abi.encodePacked(
251                 "\x19Ethereum Signed Message:\n32",
252                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
253         ));
254     }
255 
256     /**
257     * @dev Checks if the relayed transaction is unique.
258     * @param _wallet The target wallet.
259     * @param _nonce The nonce
260     * @param _signHash The signed hash of the transaction
261     */
262     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
263         if(relayer[_wallet].executedTx[_signHash] == true) {
264             return false;
265         }
266         relayer[_wallet].executedTx[_signHash] = true;
267         return true;
268     }
269 
270     /**
271     * @dev Checks that a nonce has the correct format and is valid. 
272     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
273     * @param _wallet The target wallet.
274     * @param _nonce The nonce
275     */
276     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
277         if(_nonce <= relayer[_wallet].nonce) {
278             return false;
279         }   
280         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
281         if(nonceBlock > block.number + BLOCKBOUND) {
282             return false;
283         }
284         relayer[_wallet].nonce = _nonce;
285         return true;    
286     }
287 
288     /**
289     * @dev Recovers the signer at a given position from a list of concatenated signatures.
290     * @param _signedHash The signed hash
291     * @param _signatures The concatenated signatures.
292     * @param _index The index of the signature to recover.
293     */
294     function recoverSigner(bytes32 _signedHash, bytes _signatures, uint _index) internal pure returns (address) {
295         uint8 v;
296         bytes32 r;
297         bytes32 s;
298         // we jump 32 (0x20) as the first slot of bytes contains the length
299         // we jump 65 (0x41) per signature
300         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
301         // solium-disable-next-line security/no-inline-assembly
302         assembly {
303             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
304             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
305             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
306         }
307         require(v == 27 || v == 28); 
308         return ecrecover(_signedHash, v, r, s);
309     }
310 
311     /**
312     * @dev Refunds the gas used to the Relayer. 
313     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
314     * @param _wallet The target wallet.
315     * @param _gasUsed The gas used.
316     * @param _gasPrice The gas price for the refund.
317     * @param _gasLimit The gas limit for the refund.
318     * @param _signatures The number of signatures used in the call.
319     * @param _relayer The address of the Relayer.
320     */
321     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
322         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
323         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
324         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
325             if(_gasPrice > tx.gasprice) {
326                 amount = amount * tx.gasprice;
327             }
328             else {
329                 amount = amount * _gasPrice;
330             }
331             _wallet.invoke(_relayer, amount, "");
332         }
333     }
334 
335     /**
336     * @dev Returns false if the refund is expected to fail.
337     * @param _wallet The target wallet.
338     * @param _gasUsed The expected gas used.
339     * @param _gasPrice The expected gas price for the refund.
340     */
341     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
342         if(_gasPrice > 0 
343             && _signatures > 1 
344             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(this) == false)) {
345             return false;
346         }
347         return true;
348     }
349 
350     /**
351     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
352     * as the wallet passed as the input of the execute() method. 
353     @return false if the addresses are different.
354     */
355     function verifyData(address _wallet, bytes _data) private pure returns (bool) {
356         require(_data.length >= 36, "RM: Invalid dataWallet");
357         address dataWallet;
358         // solium-disable-next-line security/no-inline-assembly
359         assembly {
360             //_data = {length:32}{sig:4}{_wallet:32}{...}
361             dataWallet := mload(add(_data, 0x24))
362         }
363         return dataWallet == _wallet;
364     }
365 
366     /**
367     * @dev Parses the data to extract the method signature. 
368     */
369     function functionPrefix(bytes _data) internal pure returns (bytes4 prefix) {
370         require(_data.length >= 4, "RM: Invalid functionPrefix");
371         // solium-disable-next-line security/no-inline-assembly
372         assembly {
373             prefix := mload(add(_data, 0x20))
374         }
375     }
376 }
377 
378 /**
379  * @title OnlyOwnerModule
380  * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
381  * must be called with one signature frm the owner.
382  * @author Julien Niset - <julien@argent.xyz>
383  */
384 contract OnlyOwnerModule is BaseModule, RelayerModule {
385 
386     // *************** Implementation of RelayerModule methods ********************* //
387 
388     // Overrides to use the incremental nonce and save some gas
389     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
390         return checkAndUpdateNonce(_wallet, _nonce);
391     }
392 
393     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool) {
394         address signer = recoverSigner(_signHash, _signatures, 0);
395         return isOwner(_wallet, signer); // "OOM: signer must be owner"
396     }
397 
398     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256) {
399         return 1;
400     }
401 }
402 
403 /**
404  * ERC20 contract interface.
405  */
406 contract ERC20 {
407     function totalSupply() public view returns (uint);
408     function decimals() public view returns (uint);
409     function balanceOf(address tokenOwner) public view returns (uint balance);
410     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
411     function transfer(address to, uint tokens) public returns (bool success);
412     function approve(address spender, uint tokens) public returns (bool success);
413     function transferFrom(address from, address to, uint tokens) public returns (bool success);
414 }
415 
416 /**
417  * @title Owned
418  * @dev Basic contract to define an owner.
419  * @author Julien Niset - <julien@argent.xyz>
420  */
421 contract Owned {
422 
423     // The owner
424     address public owner;
425 
426     event OwnerChanged(address indexed _newOwner);
427 
428     /**
429      * @dev Throws if the sender is not the owner.
430      */
431     modifier onlyOwner {
432         require(msg.sender == owner, "Must be owner");
433         _;
434     }
435 
436     constructor() public {
437         owner = msg.sender;
438     }
439 
440     /**
441      * @dev Lets the owner transfer ownership of the contract to a new owner.
442      * @param _newOwner The new owner.
443      */
444     function changeOwner(address _newOwner) external onlyOwner {
445         require(_newOwner != address(0), "Address must not be null");
446         owner = _newOwner;
447         emit OwnerChanged(_newOwner);
448     }
449 }
450 
451 /**
452  * @title ModuleRegistry
453  * @dev Registry of authorised modules. 
454  * Modules must be registered before they can be authorised on a wallet.
455  * @author Julien Niset - <julien@argent.xyz>
456  */
457 contract ModuleRegistry is Owned {
458 
459     mapping (address => Info) internal modules;
460     mapping (address => Info) internal upgraders;
461 
462     event ModuleRegistered(address indexed module, bytes32 name);
463     event ModuleDeRegistered(address module);
464     event UpgraderRegistered(address indexed upgrader, bytes32 name);
465     event UpgraderDeRegistered(address upgrader);
466 
467     struct Info {
468         bool exists;
469         bytes32 name;
470     }
471 
472     /**
473      * @dev Registers a module.
474      * @param _module The module.
475      * @param _name The unique name of the module.
476      */
477     function registerModule(address _module, bytes32 _name) external onlyOwner {
478         require(!modules[_module].exists, "MR: module already exists");
479         modules[_module] = Info({exists: true, name: _name});
480         emit ModuleRegistered(_module, _name);
481     }
482 
483     /**
484      * @dev Deregisters a module.
485      * @param _module The module.
486      */
487     function deregisterModule(address _module) external onlyOwner {
488         require(modules[_module].exists, "MR: module does not exists");
489         delete modules[_module];
490         emit ModuleDeRegistered(_module);
491     }
492 
493         /**
494      * @dev Registers an upgrader.
495      * @param _upgrader The upgrader.
496      * @param _name The unique name of the upgrader.
497      */
498     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
499         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
500         upgraders[_upgrader] = Info({exists: true, name: _name});
501         emit UpgraderRegistered(_upgrader, _name);
502     }
503 
504     /**
505      * @dev Deregisters an upgrader.
506      * @param _upgrader The _upgrader.
507      */
508     function deregisterUpgrader(address _upgrader) external onlyOwner {
509         require(upgraders[_upgrader].exists, "MR: upgrader does not exists");
510         delete upgraders[_upgrader];
511         emit UpgraderDeRegistered(_upgrader);
512     }
513 
514     /**
515     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
516     * registry.
517     * @param _token The token to recover.
518     */
519     function recoverToken(address _token) external onlyOwner {
520         uint total = ERC20(_token).balanceOf(address(this));
521         ERC20(_token).transfer(msg.sender, total);
522     } 
523 
524     /**
525      * @dev Gets the name of a module from its address.
526      * @param _module The module address.
527      * @return the name.
528      */
529     function moduleInfo(address _module) external view returns (bytes32) {
530         return modules[_module].name;
531     }
532 
533     /**
534      * @dev Gets the name of an upgrader from its address.
535      * @param _upgrader The upgrader address.
536      * @return the name.
537      */
538     function upgraderInfo(address _upgrader) external view returns (bytes32) {
539         return upgraders[_upgrader].name;
540     }
541 
542     /**
543      * @dev Checks if a module is registered.
544      * @param _module The module address.
545      * @return true if the module is registered.
546      */
547     function isRegisteredModule(address _module) external view returns (bool) {
548         return modules[_module].exists;
549     }
550 
551     /**
552      * @dev Checks if a list of modules are registered.
553      * @param _modules The list of modules address.
554      * @return true if all the modules are registered.
555      */
556     function isRegisteredModule(address[] _modules) external view returns (bool) {
557         for(uint i = 0; i < _modules.length; i++) {
558             if (!modules[_modules[i]].exists) {
559                 return false;
560             }
561         }
562         return true;
563     }  
564 
565     /**
566      * @dev Checks if an upgrader is registered.
567      * @param _upgrader The upgrader address.
568      * @return true if the upgrader is registered.
569      */
570     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
571         return upgraders[_upgrader].exists;
572     } 
573 }
574 
575 /**
576  * @title BaseWallet
577  * @dev Simple modular wallet that authorises modules to call its invoke() method.
578  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
579  * @author Julien Niset - <julien@argent.xyz>
580  */
581 contract BaseWallet {
582 
583     // The implementation of the proxy
584     address public implementation;
585     // The owner 
586     address public owner;
587     // The authorised modules
588     mapping (address => bool) public authorised;
589     // The enabled static calls
590     mapping (bytes4 => address) public enabled;
591     // The number of modules
592     uint public modules;
593     
594     event AuthorisedModule(address indexed module, bool value);
595     event EnabledStaticCall(address indexed module, bytes4 indexed method);
596     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
597     event Received(uint indexed value, address indexed sender, bytes data);
598     event OwnerChanged(address owner);
599     
600     /**
601      * @dev Throws if the sender is not an authorised module.
602      */
603     modifier moduleOnly {
604         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
605         _;
606     }
607 
608     /**
609      * @dev Inits the wallet by setting the owner and authorising a list of modules.
610      * @param _owner The owner.
611      * @param _modules The modules to authorise.
612      */
613     function init(address _owner, address[] _modules) external {
614         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
615         require(_modules.length > 0, "BW: construction requires at least 1 module");
616         owner = _owner;
617         modules = _modules.length;
618         for(uint256 i = 0; i < _modules.length; i++) {
619             require(authorised[_modules[i]] == false, "BW: module is already added");
620             authorised[_modules[i]] = true;
621             Module(_modules[i]).init(this);
622             emit AuthorisedModule(_modules[i], true);
623         }
624     }
625     
626     /**
627      * @dev Enables/Disables a module.
628      * @param _module The target module.
629      * @param _value Set to true to authorise the module.
630      */
631     function authoriseModule(address _module, bool _value) external moduleOnly {
632         if (authorised[_module] != _value) {
633             if(_value == true) {
634                 modules += 1;
635                 authorised[_module] = true;
636                 Module(_module).init(this);
637             }
638             else {
639                 modules -= 1;
640                 require(modules > 0, "BW: wallet must have at least one module");
641                 delete authorised[_module];
642             }
643             emit AuthorisedModule(_module, _value);
644         }
645     }
646 
647     /**
648     * @dev Enables a static method by specifying the target module to which the call
649     * must be delegated.
650     * @param _module The target module.
651     * @param _method The static method signature.
652     */
653     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
654         require(authorised[_module], "BW: must be an authorised module for static call");
655         enabled[_method] = _module;
656         emit EnabledStaticCall(_module, _method);
657     }
658 
659     /**
660      * @dev Sets a new owner for the wallet.
661      * @param _newOwner The new owner.
662      */
663     function setOwner(address _newOwner) external moduleOnly {
664         require(_newOwner != address(0), "BW: address cannot be null");
665         owner = _newOwner;
666         emit OwnerChanged(_newOwner);
667     }
668     
669     /**
670      * @dev Performs a generic transaction.
671      * @param _target The address for the transaction.
672      * @param _value The value of the transaction.
673      * @param _data The data of the transaction.
674      */
675     function invoke(address _target, uint _value, bytes _data) external moduleOnly {
676         // solium-disable-next-line security/no-call-value
677         require(_target.call.value(_value)(_data), "BW: call to target failed");
678         emit Invoked(msg.sender, _target, _value, _data);
679     }
680 
681     /**
682      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
683      * implement specific static methods. It delegates the static call to a target contract if the data corresponds 
684      * to an enabled method, or logs the call otherwise.
685      */
686     function() public payable {
687         if(msg.data.length > 0) { 
688             address module = enabled[msg.sig];
689             if(module == address(0)) {
690                 emit Received(msg.value, msg.sender, msg.data);
691             } 
692             else {
693                 require(authorised[module], "BW: must be an authorised module for static call");
694                 // solium-disable-next-line security/no-inline-assembly
695                 assembly {
696                     calldatacopy(0, 0, calldatasize())
697                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
698                     returndatacopy(0, 0, returndatasize())
699                     switch result 
700                     case 0 {revert(0, returndatasize())} 
701                     default {return (0, returndatasize())}
702                 }
703             }
704         }
705     }
706 }
707 
708 /**
709  * @title ModuleManager
710  * @dev Module to manage the addition, removal and upgrade of the modules of wallets.
711  * @author Julien Niset - <julien@argent.xyz>
712  */
713 contract ModuleManager is BaseModule, RelayerModule, OnlyOwnerModule {
714 
715     bytes32 constant NAME = "ModuleManager";
716 
717     constructor(ModuleRegistry _registry) BaseModule(_registry, NAME) public {
718 
719     }
720 
721     /**
722      * @dev Upgrades the modules of a wallet. 
723      * The implementation of the upgrade is delegated to a contract implementing the Upgrade interface.
724      * This makes it possible for the manager to implement any possible present and future upgrades
725      * without the need to authorise modules just for the upgrade process. 
726      * @param _wallet The target wallet.
727      * @param _upgrader The address of an implementation of the Upgrader interface.
728      */
729     function upgrade(BaseWallet _wallet, Upgrader _upgrader) external onlyOwner(_wallet) {
730         require(registry.isRegisteredUpgrader(_upgrader), "MM: upgrader is not registered");
731         address[] memory toDisable = _upgrader.toDisable();
732         address[] memory toEnable = _upgrader.toEnable();
733         bytes memory methodData = abi.encodeWithSignature("upgrade(address,address[],address[])", _wallet, toDisable, toEnable);
734         // solium-disable-next-line security/no-low-level-calls
735         require(address(_upgrader).delegatecall(methodData), "MM: upgrade failed");
736     }
737 }