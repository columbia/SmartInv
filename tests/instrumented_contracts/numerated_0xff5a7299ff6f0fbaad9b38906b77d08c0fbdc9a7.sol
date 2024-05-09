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
34  * @title BaseModule
35  * @dev Basic module that contains some methods common to all modules.
36  * @author Julien Niset - <julien@argent.xyz>
37  */
38 contract BaseModule is Module {
39 
40     // The adddress of the module registry.
41     ModuleRegistry internal registry;
42 
43     event ModuleCreated(bytes32 name);
44     event ModuleInitialised(address wallet);
45 
46     constructor(ModuleRegistry _registry, bytes32 _name) public {
47         registry = _registry;
48         emit ModuleCreated(_name);
49     }
50 
51     /**
52      * @dev Throws if the sender is not the target wallet of the call.
53      */
54     modifier onlyWallet(BaseWallet _wallet) {
55         require(msg.sender == address(_wallet), "BM: caller must be wallet");
56         _;
57     }
58 
59     /**
60      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
61      */
62     modifier onlyOwner(BaseWallet _wallet) {
63         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
64         _;
65     }
66 
67     /**
68      * @dev Throws if the sender is not the owner of the target wallet.
69      */
70     modifier strictOnlyOwner(BaseWallet _wallet) {
71         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
72         _;
73     }
74 
75     /**
76      * @dev Inits the module for a wallet by logging an event.
77      * The method can only be called by the wallet itself.
78      * @param _wallet The wallet.
79      */
80     function init(BaseWallet _wallet) external onlyWallet(_wallet) {
81         emit ModuleInitialised(_wallet);
82     }
83 
84     /**
85      * @dev Adds a module to a wallet. First checks that the module is registered.
86      * @param _wallet The target wallet.
87      * @param _module The modules to authorise.
88      */
89     function addModule(BaseWallet _wallet, Module _module) external strictOnlyOwner(_wallet) {
90         require(registry.isRegisteredModule(_module), "BM: module is not registered");
91         _wallet.authoriseModule(_module, true);
92     }
93 
94     /**
95     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
96     * module by mistake and transfer them to the Module Registry. 
97     * @param _token The token to recover.
98     */
99     function recoverToken(address _token) external {
100         uint total = ERC20(_token).balanceOf(address(this));
101         ERC20(_token).transfer(address(registry), total);
102     }
103 
104     /**
105      * @dev Helper method to check if an address is the owner of a target wallet.
106      * @param _wallet The target wallet.
107      * @param _addr The address.
108      */
109     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
110         return _wallet.owner() == _addr;
111     }
112 }
113 
114 /**
115  * @title RelayerModule
116  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer. 
117  * @author Julien Niset - <julien@argent.xyz>
118  */
119 contract RelayerModule is Module {
120 
121     uint256 constant internal BLOCKBOUND = 10000;
122 
123     mapping (address => RelayerConfig) public relayer; 
124 
125     struct RelayerConfig {
126         uint256 nonce;
127         mapping (bytes32 => bool) executedTx;
128     }
129 
130     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
131 
132     /**
133      * @dev Throws if the call did not go through the execute() method.
134      */
135     modifier onlyExecute {
136         require(msg.sender == address(this), "RM: must be called via execute()");
137         _;
138     }
139 
140     /* ***************** Abstract method ************************* */
141 
142     /**
143     * @dev Gets the number of valid signatures that must be provided to execute a
144     * specific relayed transaction.
145     * @param _wallet The target wallet.
146     * @param _data The data of the relayed transaction.
147     * @return The number of required signatures.
148     */
149     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256);
150 
151     /**
152     * @dev Validates the signatures provided with a relayed transaction.
153     * The method MUST throw if one or more signatures are not valid.
154     * @param _wallet The target wallet.
155     * @param _data The data of the relayed transaction.
156     * @param _signHash The signed hash representing the relayed transaction.
157     * @param _signatures The signatures as a concatenated byte array.
158     */
159     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool);
160 
161     /* ************************************************************ */
162 
163     /**
164     * @dev Executes a relayed transaction.
165     * @param _wallet The target wallet.
166     * @param _data The data for the relayed transaction
167     * @param _nonce The nonce used to prevent replay attacks.
168     * @param _signatures The signatures as a concatenated byte array.
169     * @param _gasPrice The gas price to use for the gas refund.
170     * @param _gasLimit The gas limit to use for the gas refund.
171     */
172     function execute(
173         BaseWallet _wallet,
174         bytes _data, 
175         uint256 _nonce, 
176         bytes _signatures, 
177         uint256 _gasPrice,
178         uint256 _gasLimit
179     )
180         external
181         returns (bool success)
182     {
183         uint startGas = gasleft();
184         bytes32 signHash = getSignHash(address(this), _wallet, 0, _data, _nonce, _gasPrice, _gasLimit);
185         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
186         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
187         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
188         if((requiredSignatures * 65) == _signatures.length) {
189             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
190                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
191                     // solium-disable-next-line security/no-call-value
192                     success = address(this).call(_data);
193                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
194                 }
195             }
196         }
197         emit TransactionExecuted(_wallet, success, signHash); 
198     }
199 
200     /**
201     * @dev Gets the current nonce for a wallet.
202     * @param _wallet The target wallet.
203     */
204     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
205         return relayer[_wallet].nonce;
206     }
207 
208     /**
209     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
210     * @param _from The starting address for the relayed transaction (should be the module)
211     * @param _to The destination address for the relayed transaction (should be the wallet)
212     * @param _value The value for the relayed transaction
213     * @param _data The data for the relayed transaction
214     * @param _nonce The nonce used to prevent replay attacks.
215     * @param _gasPrice The gas price to use for the gas refund.
216     * @param _gasLimit The gas limit to use for the gas refund.
217     */
218     function getSignHash(
219         address _from,
220         address _to, 
221         uint256 _value, 
222         bytes _data, 
223         uint256 _nonce,
224         uint256 _gasPrice,
225         uint256 _gasLimit
226     ) 
227         internal 
228         pure
229         returns (bytes32) 
230     {
231         return keccak256(
232             abi.encodePacked(
233                 "\x19Ethereum Signed Message:\n32",
234                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
235         ));
236     }
237 
238     /**
239     * @dev Checks if the relayed transaction is unique.
240     * @param _wallet The target wallet.
241     * @param _nonce The nonce
242     * @param _signHash The signed hash of the transaction
243     */
244     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
245         if(relayer[_wallet].executedTx[_signHash] == true) {
246             return false;
247         }
248         relayer[_wallet].executedTx[_signHash] = true;
249         return true;
250     }
251 
252     /**
253     * @dev Checks that a nonce has the correct format and is valid. 
254     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
255     * @param _wallet The target wallet.
256     * @param _nonce The nonce
257     */
258     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
259         if(_nonce <= relayer[_wallet].nonce) {
260             return false;
261         }   
262         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
263         if(nonceBlock > block.number + BLOCKBOUND) {
264             return false;
265         }
266         relayer[_wallet].nonce = _nonce;
267         return true;    
268     }
269 
270     /**
271     * @dev Recovers the signer at a given position from a list of concatenated signatures.
272     * @param _signedHash The signed hash
273     * @param _signatures The concatenated signatures.
274     * @param _index The index of the signature to recover.
275     */
276     function recoverSigner(bytes32 _signedHash, bytes _signatures, uint _index) internal pure returns (address) {
277         uint8 v;
278         bytes32 r;
279         bytes32 s;
280         // we jump 32 (0x20) as the first slot of bytes contains the length
281         // we jump 65 (0x41) per signature
282         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
283         // solium-disable-next-line security/no-inline-assembly
284         assembly {
285             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
286             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
287             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
288         }
289         require(v == 27 || v == 28); 
290         return ecrecover(_signedHash, v, r, s);
291     }
292 
293     /**
294     * @dev Refunds the gas used to the Relayer. 
295     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
296     * @param _wallet The target wallet.
297     * @param _gasUsed The gas used.
298     * @param _gasPrice The gas price for the refund.
299     * @param _gasLimit The gas limit for the refund.
300     * @param _signatures The number of signatures used in the call.
301     * @param _relayer The address of the Relayer.
302     */
303     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
304         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
305         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
306         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
307             if(_gasPrice > tx.gasprice) {
308                 amount = amount * tx.gasprice;
309             }
310             else {
311                 amount = amount * _gasPrice;
312             }
313             _wallet.invoke(_relayer, amount, "");
314         }
315     }
316 
317     /**
318     * @dev Returns false if the refund is expected to fail.
319     * @param _wallet The target wallet.
320     * @param _gasUsed The expected gas used.
321     * @param _gasPrice The expected gas price for the refund.
322     */
323     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
324         if(_gasPrice > 0 
325             && _signatures > 1 
326             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(this) == false)) {
327             return false;
328         }
329         return true;
330     }
331 
332     /**
333     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
334     * as the wallet passed as the input of the execute() method. 
335     @return false if the addresses are different.
336     */
337     function verifyData(address _wallet, bytes _data) private pure returns (bool) {
338         require(_data.length >= 36, "RM: Invalid dataWallet");
339         address dataWallet;
340         // solium-disable-next-line security/no-inline-assembly
341         assembly {
342             //_data = {length:32}{sig:4}{_wallet:32}{...}
343             dataWallet := mload(add(_data, 0x24))
344         }
345         return dataWallet == _wallet;
346     }
347 
348     /**
349     * @dev Parses the data to extract the method signature. 
350     */
351     function functionPrefix(bytes _data) internal pure returns (bytes4 prefix) {
352         require(_data.length >= 4, "RM: Invalid functionPrefix");
353         // solium-disable-next-line security/no-inline-assembly
354         assembly {
355             prefix := mload(add(_data, 0x20))
356         }
357     }
358 }
359 
360 /**
361  * ERC20 contract interface.
362  */
363 contract ERC20 {
364     function totalSupply() public view returns (uint);
365     function decimals() public view returns (uint);
366     function balanceOf(address tokenOwner) public view returns (uint balance);
367     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
368     function transfer(address to, uint tokens) public returns (bool success);
369     function approve(address spender, uint tokens) public returns (bool success);
370     function transferFrom(address from, address to, uint tokens) public returns (bool success);
371 }
372 
373 /**
374  * @title Owned
375  * @dev Basic contract to define an owner.
376  * @author Julien Niset - <julien@argent.xyz>
377  */
378 contract Owned {
379 
380     // The owner
381     address public owner;
382 
383     event OwnerChanged(address indexed _newOwner);
384 
385     /**
386      * @dev Throws if the sender is not the owner.
387      */
388     modifier onlyOwner {
389         require(msg.sender == owner, "Must be owner");
390         _;
391     }
392 
393     constructor() public {
394         owner = msg.sender;
395     }
396 
397     /**
398      * @dev Lets the owner transfer ownership of the contract to a new owner.
399      * @param _newOwner The new owner.
400      */
401     function changeOwner(address _newOwner) external onlyOwner {
402         require(_newOwner != address(0), "Address must not be null");
403         owner = _newOwner;
404         emit OwnerChanged(_newOwner);
405     }
406 }
407 
408 /**
409  * @title ModuleRegistry
410  * @dev Registry of authorised modules. 
411  * Modules must be registered before they can be authorised on a wallet.
412  * @author Julien Niset - <julien@argent.xyz>
413  */
414 contract ModuleRegistry is Owned {
415 
416     mapping (address => Info) internal modules;
417     mapping (address => Info) internal upgraders;
418 
419     event ModuleRegistered(address indexed module, bytes32 name);
420     event ModuleDeRegistered(address module);
421     event UpgraderRegistered(address indexed upgrader, bytes32 name);
422     event UpgraderDeRegistered(address upgrader);
423 
424     struct Info {
425         bool exists;
426         bytes32 name;
427     }
428 
429     /**
430      * @dev Registers a module.
431      * @param _module The module.
432      * @param _name The unique name of the module.
433      */
434     function registerModule(address _module, bytes32 _name) external onlyOwner {
435         require(!modules[_module].exists, "MR: module already exists");
436         modules[_module] = Info({exists: true, name: _name});
437         emit ModuleRegistered(_module, _name);
438     }
439 
440     /**
441      * @dev Deregisters a module.
442      * @param _module The module.
443      */
444     function deregisterModule(address _module) external onlyOwner {
445         require(modules[_module].exists, "MR: module does not exists");
446         delete modules[_module];
447         emit ModuleDeRegistered(_module);
448     }
449 
450         /**
451      * @dev Registers an upgrader.
452      * @param _upgrader The upgrader.
453      * @param _name The unique name of the upgrader.
454      */
455     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
456         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
457         upgraders[_upgrader] = Info({exists: true, name: _name});
458         emit UpgraderRegistered(_upgrader, _name);
459     }
460 
461     /**
462      * @dev Deregisters an upgrader.
463      * @param _upgrader The _upgrader.
464      */
465     function deregisterUpgrader(address _upgrader) external onlyOwner {
466         require(upgraders[_upgrader].exists, "MR: upgrader does not exists");
467         delete upgraders[_upgrader];
468         emit UpgraderDeRegistered(_upgrader);
469     }
470 
471     /**
472     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
473     * registry.
474     * @param _token The token to recover.
475     */
476     function recoverToken(address _token) external onlyOwner {
477         uint total = ERC20(_token).balanceOf(address(this));
478         ERC20(_token).transfer(msg.sender, total);
479     } 
480 
481     /**
482      * @dev Gets the name of a module from its address.
483      * @param _module The module address.
484      * @return the name.
485      */
486     function moduleInfo(address _module) external view returns (bytes32) {
487         return modules[_module].name;
488     }
489 
490     /**
491      * @dev Gets the name of an upgrader from its address.
492      * @param _upgrader The upgrader address.
493      * @return the name.
494      */
495     function upgraderInfo(address _upgrader) external view returns (bytes32) {
496         return upgraders[_upgrader].name;
497     }
498 
499     /**
500      * @dev Checks if a module is registered.
501      * @param _module The module address.
502      * @return true if the module is registered.
503      */
504     function isRegisteredModule(address _module) external view returns (bool) {
505         return modules[_module].exists;
506     }
507 
508     /**
509      * @dev Checks if a list of modules are registered.
510      * @param _modules The list of modules address.
511      * @return true if all the modules are registered.
512      */
513     function isRegisteredModule(address[] _modules) external view returns (bool) {
514         for(uint i = 0; i < _modules.length; i++) {
515             if (!modules[_modules[i]].exists) {
516                 return false;
517             }
518         }
519         return true;
520     }  
521 
522     /**
523      * @dev Checks if an upgrader is registered.
524      * @param _upgrader The upgrader address.
525      * @return true if the upgrader is registered.
526      */
527     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
528         return upgraders[_upgrader].exists;
529     } 
530 }
531 
532 /**
533  * @title BaseWallet
534  * @dev Simple modular wallet that authorises modules to call its invoke() method.
535  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
536  * @author Julien Niset - <julien@argent.xyz>
537  */
538 contract BaseWallet {
539 
540     // The implementation of the proxy
541     address public implementation;
542     // The owner 
543     address public owner;
544     // The authorised modules
545     mapping (address => bool) public authorised;
546     // The enabled static calls
547     mapping (bytes4 => address) public enabled;
548     // The number of modules
549     uint public modules;
550     
551     event AuthorisedModule(address indexed module, bool value);
552     event EnabledStaticCall(address indexed module, bytes4 indexed method);
553     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
554     event Received(uint indexed value, address indexed sender, bytes data);
555     event OwnerChanged(address owner);
556     
557     /**
558      * @dev Throws if the sender is not an authorised module.
559      */
560     modifier moduleOnly {
561         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
562         _;
563     }
564 
565     /**
566      * @dev Inits the wallet by setting the owner and authorising a list of modules.
567      * @param _owner The owner.
568      * @param _modules The modules to authorise.
569      */
570     function init(address _owner, address[] _modules) external {
571         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
572         require(_modules.length > 0, "BW: construction requires at least 1 module");
573         owner = _owner;
574         modules = _modules.length;
575         for(uint256 i = 0; i < _modules.length; i++) {
576             require(authorised[_modules[i]] == false, "BW: module is already added");
577             authorised[_modules[i]] = true;
578             Module(_modules[i]).init(this);
579             emit AuthorisedModule(_modules[i], true);
580         }
581     }
582     
583     /**
584      * @dev Enables/Disables a module.
585      * @param _module The target module.
586      * @param _value Set to true to authorise the module.
587      */
588     function authoriseModule(address _module, bool _value) external moduleOnly {
589         if (authorised[_module] != _value) {
590             if(_value == true) {
591                 modules += 1;
592                 authorised[_module] = true;
593                 Module(_module).init(this);
594             }
595             else {
596                 modules -= 1;
597                 require(modules > 0, "BW: wallet must have at least one module");
598                 delete authorised[_module];
599             }
600             emit AuthorisedModule(_module, _value);
601         }
602     }
603 
604     /**
605     * @dev Enables a static method by specifying the target module to which the call
606     * must be delegated.
607     * @param _module The target module.
608     * @param _method The static method signature.
609     */
610     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
611         require(authorised[_module], "BW: must be an authorised module for static call");
612         enabled[_method] = _module;
613         emit EnabledStaticCall(_module, _method);
614     }
615 
616     /**
617      * @dev Sets a new owner for the wallet.
618      * @param _newOwner The new owner.
619      */
620     function setOwner(address _newOwner) external moduleOnly {
621         require(_newOwner != address(0), "BW: address cannot be null");
622         owner = _newOwner;
623         emit OwnerChanged(_newOwner);
624     }
625     
626     /**
627      * @dev Performs a generic transaction.
628      * @param _target The address for the transaction.
629      * @param _value The value of the transaction.
630      * @param _data The data of the transaction.
631      */
632     function invoke(address _target, uint _value, bytes _data) external moduleOnly {
633         // solium-disable-next-line security/no-call-value
634         require(_target.call.value(_value)(_data), "BW: call to target failed");
635         emit Invoked(msg.sender, _target, _value, _data);
636     }
637 
638     /**
639      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
640      * implement specific static methods. It delegates the static call to a target contract if the data corresponds 
641      * to an enabled method, or logs the call otherwise.
642      */
643     function() public payable {
644         if(msg.data.length > 0) { 
645             address module = enabled[msg.sig];
646             if(module == address(0)) {
647                 emit Received(msg.value, msg.sender, msg.data);
648             } 
649             else {
650                 require(authorised[module], "BW: must be an authorised module for static call");
651                 // solium-disable-next-line security/no-inline-assembly
652                 assembly {
653                     calldatacopy(0, 0, calldatasize())
654                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
655                     returndatacopy(0, 0, returndatasize())
656                     switch result 
657                     case 0 {revert(0, returndatasize())} 
658                     default {return (0, returndatasize())}
659                 }
660             }
661         }
662     }
663 }
664 
665 /**
666  * @title Storage
667  * @dev Base contract for the storage of a wallet.
668  * @author Julien Niset - <julien@argent.xyz>
669  */
670 contract Storage {
671 
672     /**
673      * @dev Throws if the caller is not an authorised module.
674      */
675     modifier onlyModule(BaseWallet _wallet) {
676         require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
677         _;
678     }
679 }
680 
681 /**
682  * @title GuardianStorage
683  * @dev Contract storing the state of wallets related to guardians and lock.
684  * The contract only defines basic setters and getters with no logic. Only modules authorised
685  * for a wallet can modify its state.
686  * @author Julien Niset - <julien@argent.xyz>
687  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
688  */
689 contract GuardianStorage is Storage {
690 
691     struct GuardianStorageConfig {
692         // the list of guardians
693         address[] guardians;
694         // the info about guardians
695         mapping (address => GuardianInfo) info;
696         // the lock's release timestamp
697         uint256 lock; 
698         // the module that set the last lock
699         address locker;
700     }
701 
702     struct GuardianInfo {
703         bool exists;
704         uint128 index;
705     }
706 
707     // wallet specific storage
708     mapping (address => GuardianStorageConfig) internal configs;
709 
710     // *************** External Functions ********************* //
711 
712     /**
713      * @dev Lets an authorised module add a guardian to a wallet.
714      * @param _wallet The target wallet.
715      * @param _guardian The guardian to add.
716      */
717     function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
718         GuardianStorageConfig storage config = configs[_wallet];
719         config.info[_guardian].exists = true;
720         config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
721     }
722 
723     /**
724      * @dev Lets an authorised module revoke a guardian from a wallet.
725      * @param _wallet The target wallet.
726      * @param _guardian The guardian to revoke.
727      */
728     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
729         GuardianStorageConfig storage config = configs[_wallet];
730         address lastGuardian = config.guardians[config.guardians.length - 1];
731         if (_guardian != lastGuardian) {
732             uint128 targetIndex = config.info[_guardian].index;
733             config.guardians[targetIndex] = lastGuardian;
734             config.info[lastGuardian].index = targetIndex;
735         }
736         config.guardians.length--;
737         delete config.info[_guardian];
738     }
739 
740     /**
741      * @dev Returns the number of guardians for a wallet.
742      * @param _wallet The target wallet.
743      * @return the number of guardians.
744      */
745     function guardianCount(BaseWallet _wallet) external view returns (uint256) {
746         return configs[_wallet].guardians.length;
747     }
748     
749     /**
750      * @dev Gets the list of guaridans for a wallet.
751      * @param _wallet The target wallet.
752      * @return the list of guardians.
753      */
754     function getGuardians(BaseWallet _wallet) external view returns (address[]) {
755         GuardianStorageConfig storage config = configs[_wallet];
756         address[] memory guardians = new address[](config.guardians.length);
757         for (uint256 i = 0; i < config.guardians.length; i++) {
758             guardians[i] = config.guardians[i];
759         }
760         return guardians;
761     }
762 
763     /**
764      * @dev Checks if an account is a guardian for a wallet.
765      * @param _wallet The target wallet.
766      * @param _guardian The account.
767      * @return true if the account is a guardian for a wallet.
768      */
769     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
770         return configs[_wallet].info[_guardian].exists;
771     }
772 
773     /**
774      * @dev Lets an authorised module set the lock for a wallet.
775      * @param _wallet The target wallet.
776      * @param _releaseAfter The epoch time at which the lock should automatically release.
777      */
778     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
779         configs[_wallet].lock = _releaseAfter;
780         if(_releaseAfter != 0 && msg.sender != configs[_wallet].locker) {
781             configs[_wallet].locker = msg.sender;
782         }
783     }
784 
785     /**
786      * @dev Checks if the lock is set for a wallet.
787      * @param _wallet The target wallet.
788      * @return true if the lock is set for the wallet.
789      */
790     function isLocked(BaseWallet _wallet) external view returns (bool) {
791         return configs[_wallet].lock > now;
792     }
793 
794     /**
795      * @dev Gets the time at which the lock of a wallet will release.
796      * @param _wallet The target wallet.
797      * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
798      */
799     function getLock(BaseWallet _wallet) external view returns (uint256) {
800         return configs[_wallet].lock;
801     }
802 
803     /**
804      * @dev Gets the address of the last module that modified the lock for a wallet.
805      * @param _wallet The target wallet.
806      * @return the address of the last module that modified the lock for a wallet.
807      */
808     function getLocker(BaseWallet _wallet) external view returns (address) {
809         return configs[_wallet].locker;
810     }
811 }
812 
813 library GuardianUtils {
814 
815     /**
816     * @dev Checks if an address is an account guardian or an account authorised to sign on behalf of a smart-contract guardian
817     * given a list of guardians.
818     * @param _guardians the list of guardians
819     * @param _guardian the address to test
820     * @return true and the list of guardians minus the found guardian upon success, false and the original list of guardians if not found.
821     */
822     function isGuardian(address[] _guardians, address _guardian) internal view returns (bool, address[]) {
823         if(_guardians.length == 0 || _guardian == address(0)) {
824             return (false, _guardians);
825         }
826         bool isFound = false;
827         address[] memory updatedGuardians = new address[](_guardians.length - 1);
828         uint256 index = 0;
829         for (uint256 i = 0; i < _guardians.length; i++) {
830             if(!isFound) {
831                 // check if _guardian is an account guardian
832                 if(_guardian == _guardians[i]) {
833                     isFound = true;
834                     continue;
835                 }
836                 // check if _guardian is the owner of a smart contract guardian
837                 if(isContract(_guardians[i]) && isGuardianOwner(_guardians[i], _guardian)) {
838                     isFound = true;
839                     continue;
840                 }
841             }
842             if(index < updatedGuardians.length) {
843                 updatedGuardians[index] = _guardians[i];
844                 index++;
845             }
846         }
847         return isFound ? (true, updatedGuardians) : (false, _guardians);
848     }
849 
850    /**
851     * @dev Checks if an address is a contract.
852     * @param _addr The address.
853     */
854     function isContract(address _addr) internal view returns (bool) {
855         uint32 size;
856         // solium-disable-next-line security/no-inline-assembly
857         assembly {
858             size := extcodesize(_addr)
859         }
860         return (size > 0);
861     }
862 
863     /**
864     * @dev Checks if an address is the owner of a guardian contract. 
865     * The method does not revert if the call to the owner() method consumes more then 5000 gas. 
866     * @param _guardian The guardian contract
867     * @param _owner The owner to verify.
868     */
869     function isGuardianOwner(address _guardian, address _owner) internal view returns (bool) {
870         address owner = address(0);
871         bytes4 sig = bytes4(keccak256("owner()"));
872         // solium-disable-next-line security/no-inline-assembly
873         assembly {
874             let ptr := mload(0x40)
875             mstore(ptr,sig)
876             let result := staticcall(5000, _guardian, ptr, 0x20, ptr, 0x20)
877             if eq(result, 1) {
878                 owner := mload(ptr)
879             }
880         }
881         return owner == _owner;
882     }
883 } 
884 
885 /**
886  * @title GuardianManager
887  * @dev Module to manage the guardians of wallets.
888  * Guardians are accounts (EOA or contracts) that are authorized to perform specific 
889  * security operations on wallets such as toggle a safety lock, start a recovery procedure,
890  * or confirm transactions. Addition or revokation of guardians is initiated by the owner 
891  * of a wallet and must be confirmed after a security period (e.g. 24 hours).
892  * The list of guardians for a wallet is stored on a saparate
893  * contract to facilitate its use by other modules.
894  * @author Julien Niset - <julien@argent.xyz>
895  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
896  */
897 contract GuardianManager is BaseModule, RelayerModule {
898 
899     bytes32 constant NAME = "GuardianManager";
900 
901     bytes4 constant internal CONFIRM_ADDITION_PREFIX = bytes4(keccak256("confirmGuardianAddition(address,address)"));
902     bytes4 constant internal CONFIRM_REVOKATION_PREFIX = bytes4(keccak256("confirmGuardianRevokation(address,address)"));
903 
904     struct GuardianManagerConfig {
905         // the time at which a guardian addition or revokation will be confirmable by the owner
906         mapping (bytes32 => uint256) pending;
907     }
908 
909     // the wallet specific storage
910     mapping (address => GuardianManagerConfig) internal configs;
911     // the address of the Guardian storage 
912     GuardianStorage public guardianStorage;
913     // the security period
914     uint256 public securityPeriod;
915     // the security window
916     uint256 public securityWindow;
917 
918     // *************** Events *************************** //
919 
920     event GuardianAdditionRequested(address indexed wallet, address indexed guardian, uint256 executeAfter);
921     event GuardianRevokationRequested(address indexed wallet, address indexed guardian, uint256 executeAfter);
922     event GuardianAdditionCancelled(address indexed wallet, address indexed guardian);
923     event GuardianRevokationCancelled(address indexed wallet, address indexed guardian);
924     event GuardianAdded(address indexed wallet, address indexed guardian);
925     event GuardianRevoked(address indexed wallet, address indexed guardian);
926     
927     // *************** Modifiers ************************ //
928 
929     /**
930      * @dev Throws if the wallet is not locked.
931      */
932     modifier onlyWhenLocked(BaseWallet _wallet) {
933         // solium-disable-next-line security/no-block-members
934         require(guardianStorage.isLocked(_wallet), "GM: wallet must be locked");
935         _;
936     }
937 
938     /**
939      * @dev Throws if the wallet is locked.
940      */
941     modifier onlyWhenUnlocked(BaseWallet _wallet) {
942         // solium-disable-next-line security/no-block-members
943         require(!guardianStorage.isLocked(_wallet), "GM: wallet must be unlocked");
944         _;
945     }
946 
947     // *************** Constructor ********************** //
948 
949     constructor(
950         ModuleRegistry _registry, 
951         GuardianStorage _guardianStorage, 
952         uint256 _securityPeriod,
953         uint256 _securityWindow
954     ) 
955         BaseModule(_registry, NAME) 
956         public 
957     {
958         guardianStorage = _guardianStorage;
959         securityPeriod = _securityPeriod;
960         securityWindow = _securityWindow;
961     }
962 
963     // *************** External Functions ********************* //
964 
965     /**
966      * @dev Lets the owner add a guardian to its wallet.
967      * The first guardian is added immediately. All following additions must be confirmed
968      * by calling the confirmGuardianAddition() method. 
969      * @param _wallet The target wallet.
970      * @param _guardian The guardian to add.
971      */
972     function addGuardian(BaseWallet _wallet, address _guardian) external onlyOwner(_wallet) onlyWhenUnlocked(_wallet) {
973         require(!isOwner(_wallet, _guardian), "GM: target guardian cannot be owner");
974         require(!isGuardian(_wallet, _guardian), "GM: target is already a guardian"); 
975         // Guardians must either be an EOA or a contract with an owner() 
976         // method that returns an address with a 5000 gas stipend.
977         // Note that this test is not meant to be strict and can be bypassed by custom malicious contracts.
978         // solium-disable-next-line security/no-low-level-calls
979         require(_guardian.call.gas(5000)(abi.encodeWithSignature("owner()")), "GM: guardian must be EOA or implement owner()");
980         if(guardianStorage.guardianCount(_wallet) == 0) {
981             guardianStorage.addGuardian(_wallet, _guardian);
982             emit GuardianAdded(_wallet, _guardian);
983         } else {
984             bytes32 id = keccak256(abi.encodePacked(address(_wallet), _guardian, "addition"));
985             GuardianManagerConfig storage config = configs[_wallet];
986             require(
987                 config.pending[id] == 0 || now > config.pending[id] + securityWindow, 
988                 "GM: addition of target as guardian is already pending"); 
989             config.pending[id] = now + securityPeriod;
990             emit GuardianAdditionRequested(_wallet, _guardian, now + securityPeriod);
991         }
992     }
993 
994     /**
995      * @dev Confirms the pending addition of a guardian to a wallet.
996      * The method must be called during the confirmation window and 
997      * can be called by anyone to enable orchestration.
998      * @param _wallet The target wallet.
999      * @param _guardian The guardian.
1000      */
1001     function confirmGuardianAddition(BaseWallet _wallet, address _guardian) public onlyWhenUnlocked(_wallet) {
1002         bytes32 id = keccak256(abi.encodePacked(address(_wallet), _guardian, "addition"));
1003         GuardianManagerConfig storage config = configs[_wallet];
1004         require(config.pending[id] > 0, "GM: no pending addition as guardian for target");
1005         require(config.pending[id] < now, "GM: Too early to confirm guardian addition");
1006         require(now < config.pending[id] + securityWindow, "GM: Too late to confirm guardian addition");
1007         guardianStorage.addGuardian(_wallet, _guardian);
1008         delete config.pending[id];
1009         emit GuardianAdded(_wallet, _guardian);
1010     }
1011 
1012     /**
1013      * @dev Lets the owner cancel a pending guardian addition.
1014      * @param _wallet The target wallet.
1015      * @param _guardian The guardian.
1016      */
1017     function cancelGuardianAddition(BaseWallet _wallet, address _guardian) public onlyOwner(_wallet) onlyWhenUnlocked(_wallet) {
1018         bytes32 id = keccak256(abi.encodePacked(address(_wallet), _guardian, "addition"));
1019         GuardianManagerConfig storage config = configs[_wallet];
1020         require(config.pending[id] > 0, "GM: no pending addition as guardian for target");
1021         delete config.pending[id];
1022         emit GuardianAdditionCancelled(_wallet, _guardian);
1023     }
1024 
1025     /**
1026      * @dev Lets the owner revoke a guardian from its wallet.
1027      * Revokation must be confirmed by calling the confirmGuardianRevokation() method. 
1028      * @param _wallet The target wallet.
1029      * @param _guardian The guardian to revoke.
1030      */
1031     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyOwner(_wallet) {
1032         require(isGuardian(_wallet, _guardian), "GM: must be an existing guardian");
1033         bytes32 id = keccak256(abi.encodePacked(address(_wallet), _guardian, "revokation"));
1034         GuardianManagerConfig storage config = configs[_wallet];
1035         require(
1036             config.pending[id] == 0 || now > config.pending[id] + securityWindow, 
1037             "GM: revokation of target as guardian is already pending"); // TODO need to allow if confirmation window passed
1038         config.pending[id] = now + securityPeriod;
1039         emit GuardianRevokationRequested(_wallet, _guardian, now + securityPeriod);
1040     }
1041 
1042     /**
1043      * @dev Confirms the pending revokation of a guardian to a wallet.
1044      * The method must be called during the confirmation window and 
1045      * can be called by anyone to enable orchestration.
1046      * @param _wallet The target wallet.
1047      * @param _guardian The guardian.
1048      */
1049     function confirmGuardianRevokation(BaseWallet _wallet, address _guardian) public {
1050         bytes32 id = keccak256(abi.encodePacked(address(_wallet), _guardian, "revokation"));
1051         GuardianManagerConfig storage config = configs[_wallet];
1052         require(config.pending[id] > 0, "GM: no pending guardian revokation for target");
1053         require(config.pending[id] < now, "GM: Too early to confirm guardian revokation");
1054         require(now < config.pending[id] + securityWindow, "GM: Too late to confirm guardian revokation");
1055         guardianStorage.revokeGuardian(_wallet, _guardian);
1056         delete config.pending[id];
1057         emit GuardianRevoked(_wallet, _guardian);
1058     }
1059 
1060     /**
1061      * @dev Lets the owner cancel a pending guardian revokation.
1062      * @param _wallet The target wallet.
1063      * @param _guardian The guardian.
1064      */
1065     function cancelGuardianRevokation(BaseWallet _wallet, address _guardian) public onlyOwner(_wallet) onlyWhenUnlocked(_wallet) {
1066         bytes32 id = keccak256(abi.encodePacked(address(_wallet), _guardian, "revokation"));
1067         GuardianManagerConfig storage config = configs[_wallet];
1068         require(config.pending[id] > 0, "GM: no pending guardian revokation for target");
1069         delete config.pending[id];
1070         emit GuardianRevokationCancelled(_wallet, _guardian);
1071     }
1072 
1073     /**
1074      * @dev Checks if an address is a guardian for a wallet.
1075      * @param _wallet The target wallet.
1076      * @param _guardian The address to check.
1077      * @return true if the address if a guardian for the wallet.
1078      */
1079     function isGuardian(BaseWallet _wallet, address _guardian) public view returns (bool _isGuardian) {
1080         (_isGuardian, ) = GuardianUtils.isGuardian(guardianStorage.getGuardians(_wallet), _guardian);
1081     }
1082 
1083     /**
1084      * @dev Counts the number of active guardians for a wallet.
1085      * @param _wallet The target wallet.
1086      * @return the number of active guardians for a wallet.
1087      */
1088     function guardianCount(BaseWallet _wallet) external view returns (uint256 _count) {
1089         return guardianStorage.guardianCount(_wallet);
1090     }
1091 
1092     /**
1093      * @dev Get the active guardians for a wallet.
1094      * @param _wallet The target wallet.
1095      * @return the active guardians for a wallet.
1096      */
1097     function getGuardians(BaseWallet _wallet) external view returns (address[] _guardians) {
1098         return guardianStorage.getGuardians(_wallet);
1099     }
1100 
1101     // *************** Implementation of RelayerModule methods ********************* //
1102 
1103     // Overrides to use the incremental nonce and save some gas
1104     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
1105         return checkAndUpdateNonce(_wallet, _nonce);
1106     }
1107 
1108     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool) {
1109         address signer = recoverSigner(_signHash, _signatures, 0);
1110         return isOwner(_wallet, signer); // "GM: signer must be owner"
1111     }
1112 
1113     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256) {
1114         bytes4 methodId = functionPrefix(_data);
1115         if (methodId == CONFIRM_ADDITION_PREFIX || methodId == CONFIRM_REVOKATION_PREFIX) {
1116             return 0;
1117         }
1118         return 1;
1119     }
1120 }