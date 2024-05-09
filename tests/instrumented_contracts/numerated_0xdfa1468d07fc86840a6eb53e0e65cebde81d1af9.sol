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
666  * @title SafeMath
667  * @dev Math operations with safety checks that throw on error
668  */
669 library SafeMath {
670 
671     /**
672     * @dev Returns ceil(a / b).
673     */
674     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
675         uint256 c = a / b;
676         if(a % b == 0) {
677             return c;
678         }
679         else {
680             return c + 1;
681         }
682     }
683 }
684 
685 /**
686  * @title Storage
687  * @dev Base contract for the storage of a wallet.
688  * @author Julien Niset - <julien@argent.xyz>
689  */
690 contract Storage {
691 
692     /**
693      * @dev Throws if the caller is not an authorised module.
694      */
695     modifier onlyModule(BaseWallet _wallet) {
696         require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
697         _;
698     }
699 }
700 
701 /**
702  * @title GuardianStorage
703  * @dev Contract storing the state of wallets related to guardians and lock.
704  * The contract only defines basic setters and getters with no logic. Only modules authorised
705  * for a wallet can modify its state.
706  * @author Julien Niset - <julien@argent.xyz>
707  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
708  */
709 contract GuardianStorage is Storage {
710 
711     struct GuardianStorageConfig {
712         // the list of guardians
713         address[] guardians;
714         // the info about guardians
715         mapping (address => GuardianInfo) info;
716         // the lock's release timestamp
717         uint256 lock; 
718         // the module that set the last lock
719         address locker;
720     }
721 
722     struct GuardianInfo {
723         bool exists;
724         uint128 index;
725     }
726 
727     // wallet specific storage
728     mapping (address => GuardianStorageConfig) internal configs;
729 
730     // *************** External Functions ********************* //
731 
732     /**
733      * @dev Lets an authorised module add a guardian to a wallet.
734      * @param _wallet The target wallet.
735      * @param _guardian The guardian to add.
736      */
737     function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
738         GuardianStorageConfig storage config = configs[_wallet];
739         config.info[_guardian].exists = true;
740         config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
741     }
742 
743     /**
744      * @dev Lets an authorised module revoke a guardian from a wallet.
745      * @param _wallet The target wallet.
746      * @param _guardian The guardian to revoke.
747      */
748     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
749         GuardianStorageConfig storage config = configs[_wallet];
750         address lastGuardian = config.guardians[config.guardians.length - 1];
751         if (_guardian != lastGuardian) {
752             uint128 targetIndex = config.info[_guardian].index;
753             config.guardians[targetIndex] = lastGuardian;
754             config.info[lastGuardian].index = targetIndex;
755         }
756         config.guardians.length--;
757         delete config.info[_guardian];
758     }
759 
760     /**
761      * @dev Returns the number of guardians for a wallet.
762      * @param _wallet The target wallet.
763      * @return the number of guardians.
764      */
765     function guardianCount(BaseWallet _wallet) external view returns (uint256) {
766         return configs[_wallet].guardians.length;
767     }
768     
769     /**
770      * @dev Gets the list of guaridans for a wallet.
771      * @param _wallet The target wallet.
772      * @return the list of guardians.
773      */
774     function getGuardians(BaseWallet _wallet) external view returns (address[]) {
775         GuardianStorageConfig storage config = configs[_wallet];
776         address[] memory guardians = new address[](config.guardians.length);
777         for (uint256 i = 0; i < config.guardians.length; i++) {
778             guardians[i] = config.guardians[i];
779         }
780         return guardians;
781     }
782 
783     /**
784      * @dev Checks if an account is a guardian for a wallet.
785      * @param _wallet The target wallet.
786      * @param _guardian The account.
787      * @return true if the account is a guardian for a wallet.
788      */
789     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
790         return configs[_wallet].info[_guardian].exists;
791     }
792 
793     /**
794      * @dev Lets an authorised module set the lock for a wallet.
795      * @param _wallet The target wallet.
796      * @param _releaseAfter The epoch time at which the lock should automatically release.
797      */
798     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
799         configs[_wallet].lock = _releaseAfter;
800         if(_releaseAfter != 0 && msg.sender != configs[_wallet].locker) {
801             configs[_wallet].locker = msg.sender;
802         }
803     }
804 
805     /**
806      * @dev Checks if the lock is set for a wallet.
807      * @param _wallet The target wallet.
808      * @return true if the lock is set for the wallet.
809      */
810     function isLocked(BaseWallet _wallet) external view returns (bool) {
811         return configs[_wallet].lock > now;
812     }
813 
814     /**
815      * @dev Gets the time at which the lock of a wallet will release.
816      * @param _wallet The target wallet.
817      * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
818      */
819     function getLock(BaseWallet _wallet) external view returns (uint256) {
820         return configs[_wallet].lock;
821     }
822 
823     /**
824      * @dev Gets the address of the last module that modified the lock for a wallet.
825      * @param _wallet The target wallet.
826      * @return the address of the last module that modified the lock for a wallet.
827      */
828     function getLocker(BaseWallet _wallet) external view returns (address) {
829         return configs[_wallet].locker;
830     }
831 }
832 
833 library GuardianUtils {
834 
835     /**
836     * @dev Checks if an address is an account guardian or an account authorised to sign on behalf of a smart-contract guardian
837     * given a list of guardians.
838     * @param _guardians the list of guardians
839     * @param _guardian the address to test
840     * @return true and the list of guardians minus the found guardian upon success, false and the original list of guardians if not found.
841     */
842     function isGuardian(address[] _guardians, address _guardian) internal view returns (bool, address[]) {
843         if(_guardians.length == 0 || _guardian == address(0)) {
844             return (false, _guardians);
845         }
846         bool isFound = false;
847         address[] memory updatedGuardians = new address[](_guardians.length - 1);
848         uint256 index = 0;
849         for (uint256 i = 0; i < _guardians.length; i++) {
850             if(!isFound) {
851                 // check if _guardian is an account guardian
852                 if(_guardian == _guardians[i]) {
853                     isFound = true;
854                     continue;
855                 }
856                 // check if _guardian is the owner of a smart contract guardian
857                 if(isContract(_guardians[i]) && isGuardianOwner(_guardians[i], _guardian)) {
858                     isFound = true;
859                     continue;
860                 }
861             }
862             if(index < updatedGuardians.length) {
863                 updatedGuardians[index] = _guardians[i];
864                 index++;
865             }
866         }
867         return isFound ? (true, updatedGuardians) : (false, _guardians);
868     }
869 
870    /**
871     * @dev Checks if an address is a contract.
872     * @param _addr The address.
873     */
874     function isContract(address _addr) internal view returns (bool) {
875         uint32 size;
876         // solium-disable-next-line security/no-inline-assembly
877         assembly {
878             size := extcodesize(_addr)
879         }
880         return (size > 0);
881     }
882 
883     /**
884     * @dev Checks if an address is the owner of a guardian contract. 
885     * The method does not revert if the call to the owner() method consumes more then 5000 gas. 
886     * @param _guardian The guardian contract
887     * @param _owner The owner to verify.
888     */
889     function isGuardianOwner(address _guardian, address _owner) internal view returns (bool) {
890         address owner = address(0);
891         bytes4 sig = bytes4(keccak256("owner()"));
892         // solium-disable-next-line security/no-inline-assembly
893         assembly {
894             let ptr := mload(0x40)
895             mstore(ptr,sig)
896             let result := staticcall(5000, _guardian, ptr, 0x20, ptr, 0x20)
897             if eq(result, 1) {
898                 owner := mload(ptr)
899             }
900         }
901         return owner == _owner;
902     }     
903 } 
904 
905 /**
906  * @title RecoveryManager
907  * @dev Module to manage the recovery of a wallet owner.
908  * Recovery is executed by a consensus of the wallet's guardians and takes
909  * 24 hours before it can be finalized. Once finalised the ownership of the wallet
910  * is transfered to a new address.
911  * @author Julien Niset - <julien@argent.xyz>
912  * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
913  */
914 contract RecoveryManager is BaseModule, RelayerModule {
915 
916     bytes32 constant NAME = "RecoveryManager";
917 
918     bytes4 constant internal EXECUTE_PREFIX = bytes4(keccak256("executeRecovery(address,address)"));
919     bytes4 constant internal FINALIZE_PREFIX = bytes4(keccak256("finalizeRecovery(address)"));
920     bytes4 constant internal CANCEL_PREFIX = bytes4(keccak256("cancelRecovery(address)"));
921 
922     struct RecoveryManagerConfig {
923         address recovery;
924         uint64 executeAfter;
925         uint32 guardianCount;
926     }
927 
928     // the wallet specific storage
929     mapping (address => RecoveryManagerConfig) internal configs;
930     // Recovery period   
931     uint256 public recoveryPeriod; 
932     // Lock period
933     uint256 public lockPeriod;
934     // location of the Guardian storage
935     GuardianStorage public guardianStorage;
936 
937     // *************** Events *************************** //
938 
939     event RecoveryExecuted(address indexed wallet, address indexed _recovery, uint64 executeAfter);
940     event RecoveryFinalized(address indexed wallet, address indexed _recovery);
941     event RecoveryCanceled(address indexed wallet, address indexed _recovery);
942 
943     // *************** Modifiers ************************ //
944 
945     /**
946      * @dev Throws if there is no ongoing recovery procedure.
947      */
948     modifier onlyWhenRecovery(BaseWallet _wallet) {
949         require(configs[_wallet].executeAfter > 0, "RM: there must be an ongoing recovery");
950         _;
951     }
952 
953     /**
954      * @dev Throws if there is an ongoing recovery procedure.
955      */
956     modifier notWhenRecovery(BaseWallet _wallet) {
957         require(configs[_wallet].executeAfter == 0, "RM: there cannot be an ongoing recovery");
958         _;
959     }
960 
961     // *************** Constructor ************************ //
962 
963     constructor(
964         ModuleRegistry _registry, 
965         GuardianStorage _guardianStorage, 
966         uint256 _recoveryPeriod, 
967         uint256 _lockPeriod
968     ) 
969         BaseModule(_registry, NAME) 
970         public 
971     {
972         guardianStorage = _guardianStorage;
973         recoveryPeriod = _recoveryPeriod;
974         lockPeriod = _lockPeriod;
975     }
976 
977     // *************** External functions ************************ //
978     
979     /**
980      * @dev Lets the guardians start the execution of the recovery procedure.
981      * Once triggered the recovery is pending for the security period before it can 
982      * be finalised.
983      * Must be confirmed by N guardians, where N = ((Nb Guardian + 1) / 2).
984      * @param _wallet The target wallet.
985      * @param _recovery The address to which ownership should be transferred.
986      */
987     function executeRecovery(BaseWallet _wallet, address _recovery) external onlyExecute notWhenRecovery(_wallet) {
988         require(_recovery != address(0), "RM: recovery address cannot be null");
989         RecoveryManagerConfig storage config = configs[_wallet];
990         config.recovery = _recovery;
991         config.executeAfter = uint64(now + recoveryPeriod);
992         config.guardianCount = uint32(guardianStorage.guardianCount(_wallet));
993         guardianStorage.setLock(_wallet, now + lockPeriod);
994         emit RecoveryExecuted(_wallet, _recovery, config.executeAfter);
995     }
996 
997     /**
998      * @dev Finalizes an ongoing recovery procedure if the security period is over.
999      * The method is public and callable by anyone to enable orchestration.
1000      * @param _wallet The target wallet.
1001      */
1002     function finalizeRecovery(BaseWallet _wallet) external onlyExecute onlyWhenRecovery(_wallet) {
1003         RecoveryManagerConfig storage config = configs[_wallet];
1004         require(uint64(now) > config.executeAfter, "RM: the recovery period is not over yet");
1005         _wallet.setOwner(config.recovery); 
1006         emit RecoveryFinalized(_wallet, config.recovery);
1007         guardianStorage.setLock(_wallet, 0);
1008         delete configs[_wallet];
1009     }
1010 
1011     /**
1012      * @dev Lets the owner cancel an ongoing recovery procedure.
1013      * Must be confirmed by N guardians, where N = ((Nb Guardian + 1) / 2) - 1.
1014      * @param _wallet The target wallet.
1015      */
1016     function cancelRecovery(BaseWallet _wallet) external onlyExecute onlyWhenRecovery(_wallet) {
1017         RecoveryManagerConfig storage config = configs[_wallet];
1018         emit  RecoveryCanceled(_wallet, config.recovery);
1019         guardianStorage.setLock(_wallet, 0);
1020         delete configs[_wallet];
1021     }
1022 
1023     /** 
1024     * @dev Gets the details of the ongoing recovery procedure if any.
1025     * @param _wallet The target wallet.
1026     */
1027     function getRecovery(BaseWallet _wallet) public view returns(address _address, uint64 _executeAfter, uint32 _guardianCount) {
1028         RecoveryManagerConfig storage config = configs[_wallet];
1029         return (config.recovery, config.executeAfter, config.guardianCount);
1030     }
1031 
1032     // *************** Implementation of RelayerModule methods ********************* //
1033 
1034     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool) {
1035         address lastSigner = address(0);
1036         address[] memory guardians = guardianStorage.getGuardians(_wallet);
1037         bool isGuardian = false;
1038         for (uint8 i = 0; i < _signatures.length / 65; i++) {
1039             address signer = recoverSigner(_signHash, _signatures, i);
1040             if(i == 0 && isOwner(_wallet, signer)) {
1041                 // first signer can be owner
1042                 continue;
1043             }
1044             else {
1045                 if(signer <= lastSigner) {
1046                     return false;
1047                 } // "RM: signers must be different"
1048                 lastSigner = signer;
1049                 (isGuardian, guardians) = GuardianUtils.isGuardian(guardians, signer);
1050                 if(!isGuardian) {
1051                     return false;
1052                 } // "RM: signatures not valid"
1053             }
1054         }
1055         return true;
1056     }
1057 
1058     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256) {
1059         bytes4 methodId = functionPrefix(_data);
1060         if (methodId == EXECUTE_PREFIX) {
1061             return SafeMath.ceil(guardianStorage.guardianCount(_wallet) + 1, 2);
1062         }
1063         if (methodId == FINALIZE_PREFIX) {
1064             return 0;
1065         }
1066         if(methodId == CANCEL_PREFIX) {
1067             return SafeMath.ceil(configs[_wallet].guardianCount + 1, 2);
1068         }
1069         revert("RM: unknown  method");
1070     }
1071 }