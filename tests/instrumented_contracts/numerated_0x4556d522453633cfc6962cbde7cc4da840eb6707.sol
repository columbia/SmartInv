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
52  * ERC20 contract interface.
53  */
54 contract ERC20 {
55     function totalSupply() public view returns (uint);
56     function decimals() public view returns (uint);
57     function balanceOf(address tokenOwner) public view returns (uint balance);
58     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 }
63 
64 /**
65  * @title Owned
66  * @dev Basic contract to define an owner.
67  * @author Julien Niset - <julien@argent.xyz>
68  */
69 contract Owned {
70 
71     // The owner
72     address public owner;
73 
74     event OwnerChanged(address indexed _newOwner);
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     modifier onlyOwner {
80         require(msg.sender == owner, "Must be owner");
81         _;
82     }
83 
84     constructor() public {
85         owner = msg.sender;
86     }
87 
88     /**
89      * @dev Lets the owner transfer ownership of the contract to a new owner.
90      * @param _newOwner The new owner.
91      */
92     function changeOwner(address _newOwner) external onlyOwner {
93         require(_newOwner != address(0), "Address must not be null");
94         owner = _newOwner;
95         emit OwnerChanged(_newOwner);
96     }
97 }
98 
99 /**
100  * @title BaseWallet
101  * @dev Simple modular wallet that authorises modules to call its invoke() method.
102  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
103  * @author Julien Niset - <julien@argent.xyz>
104  */
105 contract BaseWallet {
106 
107     // The implementation of the proxy
108     address public implementation;
109     // The owner 
110     address public owner;
111     // The authorised modules
112     mapping (address => bool) public authorised;
113     // The enabled static calls
114     mapping (bytes4 => address) public enabled;
115     // The number of modules
116     uint public modules;
117     
118     event AuthorisedModule(address indexed module, bool value);
119     event EnabledStaticCall(address indexed module, bytes4 indexed method);
120     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
121     event Received(uint indexed value, address indexed sender, bytes data);
122     event OwnerChanged(address owner);
123     
124     /**
125      * @dev Throws if the sender is not an authorised module.
126      */
127     modifier moduleOnly {
128         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
129         _;
130     }
131 
132     /**
133      * @dev Inits the wallet by setting the owner and authorising a list of modules.
134      * @param _owner The owner.
135      * @param _modules The modules to authorise.
136      */
137     function init(address _owner, address[] _modules) external {
138         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
139         require(_modules.length > 0, "BW: construction requires at least 1 module");
140         owner = _owner;
141         modules = _modules.length;
142         for(uint256 i = 0; i < _modules.length; i++) {
143             require(authorised[_modules[i]] == false, "BW: module is already added");
144             authorised[_modules[i]] = true;
145             Module(_modules[i]).init(this);
146             emit AuthorisedModule(_modules[i], true);
147         }
148     }
149     
150     /**
151      * @dev Enables/Disables a module.
152      * @param _module The target module.
153      * @param _value Set to true to authorise the module.
154      */
155     function authoriseModule(address _module, bool _value) external moduleOnly {
156         if (authorised[_module] != _value) {
157             if(_value == true) {
158                 modules += 1;
159                 authorised[_module] = true;
160                 Module(_module).init(this);
161             }
162             else {
163                 modules -= 1;
164                 require(modules > 0, "BW: wallet must have at least one module");
165                 delete authorised[_module];
166             }
167             emit AuthorisedModule(_module, _value);
168         }
169     }
170 
171     /**
172     * @dev Enables a static method by specifying the target module to which the call
173     * must be delegated.
174     * @param _module The target module.
175     * @param _method The static method signature.
176     */
177     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
178         require(authorised[_module], "BW: must be an authorised module for static call");
179         enabled[_method] = _module;
180         emit EnabledStaticCall(_module, _method);
181     }
182 
183     /**
184      * @dev Sets a new owner for the wallet.
185      * @param _newOwner The new owner.
186      */
187     function setOwner(address _newOwner) external moduleOnly {
188         require(_newOwner != address(0), "BW: address cannot be null");
189         owner = _newOwner;
190         emit OwnerChanged(_newOwner);
191     }
192     
193     /**
194      * @dev Performs a generic transaction.
195      * @param _target The address for the transaction.
196      * @param _value The value of the transaction.
197      * @param _data The data of the transaction.
198      */
199     function invoke(address _target, uint _value, bytes _data) external moduleOnly {
200         // solium-disable-next-line security/no-call-value
201         require(_target.call.value(_value)(_data), "BW: call to target failed");
202         emit Invoked(msg.sender, _target, _value, _data);
203     }
204 
205     /**
206      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
207      * implement specific static methods. It delegates the static call to a target contract if the data corresponds 
208      * to an enabled method, or logs the call otherwise.
209      */
210     function() public payable {
211         if(msg.data.length > 0) { 
212             address module = enabled[msg.sig];
213             if(module == address(0)) {
214                 emit Received(msg.value, msg.sender, msg.data);
215             } 
216             else {
217                 require(authorised[module], "BW: must be an authorised module for static call");
218                 // solium-disable-next-line security/no-inline-assembly
219                 assembly {
220                     calldatacopy(0, 0, calldatasize())
221                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
222                     returndatacopy(0, 0, returndatasize())
223                     switch result 
224                     case 0 {revert(0, returndatasize())} 
225                     default {return (0, returndatasize())}
226                 }
227             }
228         }
229     }
230 }
231 
232 /**
233  * @title ModuleRegistry
234  * @dev Registry of authorised modules. 
235  * Modules must be registered before they can be authorised on a wallet.
236  * @author Julien Niset - <julien@argent.xyz>
237  */
238 contract ModuleRegistry is Owned {
239 
240     mapping (address => Info) internal modules;
241     mapping (address => Info) internal upgraders;
242 
243     event ModuleRegistered(address indexed module, bytes32 name);
244     event ModuleDeRegistered(address module);
245     event UpgraderRegistered(address indexed upgrader, bytes32 name);
246     event UpgraderDeRegistered(address upgrader);
247 
248     struct Info {
249         bool exists;
250         bytes32 name;
251     }
252 
253     /**
254      * @dev Registers a module.
255      * @param _module The module.
256      * @param _name The unique name of the module.
257      */
258     function registerModule(address _module, bytes32 _name) external onlyOwner {
259         require(!modules[_module].exists, "MR: module already exists");
260         modules[_module] = Info({exists: true, name: _name});
261         emit ModuleRegistered(_module, _name);
262     }
263 
264     /**
265      * @dev Deregisters a module.
266      * @param _module The module.
267      */
268     function deregisterModule(address _module) external onlyOwner {
269         require(modules[_module].exists, "MR: module does not exists");
270         delete modules[_module];
271         emit ModuleDeRegistered(_module);
272     }
273 
274         /**
275      * @dev Registers an upgrader.
276      * @param _upgrader The upgrader.
277      * @param _name The unique name of the upgrader.
278      */
279     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
280         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
281         upgraders[_upgrader] = Info({exists: true, name: _name});
282         emit UpgraderRegistered(_upgrader, _name);
283     }
284 
285     /**
286      * @dev Deregisters an upgrader.
287      * @param _upgrader The _upgrader.
288      */
289     function deregisterUpgrader(address _upgrader) external onlyOwner {
290         require(upgraders[_upgrader].exists, "MR: upgrader does not exists");
291         delete upgraders[_upgrader];
292         emit UpgraderDeRegistered(_upgrader);
293     }
294 
295     /**
296     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
297     * registry.
298     * @param _token The token to recover.
299     */
300     function recoverToken(address _token) external onlyOwner {
301         uint total = ERC20(_token).balanceOf(address(this));
302         ERC20(_token).transfer(msg.sender, total);
303     } 
304 
305     /**
306      * @dev Gets the name of a module from its address.
307      * @param _module The module address.
308      * @return the name.
309      */
310     function moduleInfo(address _module) external view returns (bytes32) {
311         return modules[_module].name;
312     }
313 
314     /**
315      * @dev Gets the name of an upgrader from its address.
316      * @param _upgrader The upgrader address.
317      * @return the name.
318      */
319     function upgraderInfo(address _upgrader) external view returns (bytes32) {
320         return upgraders[_upgrader].name;
321     }
322 
323     /**
324      * @dev Checks if a module is registered.
325      * @param _module The module address.
326      * @return true if the module is registered.
327      */
328     function isRegisteredModule(address _module) external view returns (bool) {
329         return modules[_module].exists;
330     }
331 
332     /**
333      * @dev Checks if a list of modules are registered.
334      * @param _modules The list of modules address.
335      * @return true if all the modules are registered.
336      */
337     function isRegisteredModule(address[] _modules) external view returns (bool) {
338         for(uint i = 0; i < _modules.length; i++) {
339             if (!modules[_modules[i]].exists) {
340                 return false;
341             }
342         }
343         return true;
344     }  
345 
346     /**
347      * @dev Checks if an upgrader is registered.
348      * @param _upgrader The upgrader address.
349      * @return true if the upgrader is registered.
350      */
351     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
352         return upgraders[_upgrader].exists;
353     } 
354 }
355 
356 /**
357  * @title BaseModule
358  * @dev Basic module that contains some methods common to all modules.
359  * @author Julien Niset - <julien@argent.xyz>
360  */
361 contract BaseModule is Module {
362 
363     // The adddress of the module registry.
364     ModuleRegistry internal registry;
365 
366     event ModuleCreated(bytes32 name);
367     event ModuleInitialised(address wallet);
368 
369     constructor(ModuleRegistry _registry, bytes32 _name) public {
370         registry = _registry;
371         emit ModuleCreated(_name);
372     }
373 
374     /**
375      * @dev Throws if the sender is not the target wallet of the call.
376      */
377     modifier onlyWallet(BaseWallet _wallet) {
378         require(msg.sender == address(_wallet), "BM: caller must be wallet");
379         _;
380     }
381 
382     /**
383      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
384      */
385     modifier onlyOwner(BaseWallet _wallet) {
386         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
387         _;
388     }
389 
390     /**
391      * @dev Throws if the sender is not the owner of the target wallet.
392      */
393     modifier strictOnlyOwner(BaseWallet _wallet) {
394         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
395         _;
396     }
397 
398     /**
399      * @dev Inits the module for a wallet by logging an event.
400      * The method can only be called by the wallet itself.
401      * @param _wallet The wallet.
402      */
403     function init(BaseWallet _wallet) external onlyWallet(_wallet) {
404         emit ModuleInitialised(_wallet);
405     }
406 
407     /**
408      * @dev Adds a module to a wallet. First checks that the module is registered.
409      * @param _wallet The target wallet.
410      * @param _module The modules to authorise.
411      */
412     function addModule(BaseWallet _wallet, Module _module) external strictOnlyOwner(_wallet) {
413         require(registry.isRegisteredModule(_module), "BM: module is not registered");
414         _wallet.authoriseModule(_module, true);
415     }
416 
417     /**
418     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
419     * module by mistake and transfer them to the Module Registry. 
420     * @param _token The token to recover.
421     */
422     function recoverToken(address _token) external {
423         uint total = ERC20(_token).balanceOf(address(this));
424         ERC20(_token).transfer(address(registry), total);
425     }
426 
427     /**
428      * @dev Helper method to check if an address is the owner of a target wallet.
429      * @param _wallet The target wallet.
430      * @param _addr The address.
431      */
432     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
433         return _wallet.owner() == _addr;
434     }
435 }
436 
437 /**
438  * @title RelayerModule
439  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer. 
440  * @author Julien Niset - <julien@argent.xyz>
441  */
442 contract RelayerModule is Module {
443 
444     uint256 constant internal BLOCKBOUND = 10000;
445 
446     mapping (address => RelayerConfig) public relayer; 
447 
448     struct RelayerConfig {
449         uint256 nonce;
450         mapping (bytes32 => bool) executedTx;
451     }
452 
453     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
454 
455     /**
456      * @dev Throws if the call did not go through the execute() method.
457      */
458     modifier onlyExecute {
459         require(msg.sender == address(this), "RM: must be called via execute()");
460         _;
461     }
462 
463     /* ***************** Abstract method ************************* */
464 
465     /**
466     * @dev Gets the number of valid signatures that must be provided to execute a
467     * specific relayed transaction.
468     * @param _wallet The target wallet.
469     * @param _data The data of the relayed transaction.
470     * @return The number of required signatures.
471     */
472     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256);
473 
474     /**
475     * @dev Validates the signatures provided with a relayed transaction.
476     * The method MUST throw if one or more signatures are not valid.
477     * @param _wallet The target wallet.
478     * @param _data The data of the relayed transaction.
479     * @param _signHash The signed hash representing the relayed transaction.
480     * @param _signatures The signatures as a concatenated byte array.
481     */
482     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool);
483 
484     /* ************************************************************ */
485 
486     /**
487     * @dev Executes a relayed transaction.
488     * @param _wallet The target wallet.
489     * @param _data The data for the relayed transaction
490     * @param _nonce The nonce used to prevent replay attacks.
491     * @param _signatures The signatures as a concatenated byte array.
492     * @param _gasPrice The gas price to use for the gas refund.
493     * @param _gasLimit The gas limit to use for the gas refund.
494     */
495     function execute(
496         BaseWallet _wallet,
497         bytes _data, 
498         uint256 _nonce, 
499         bytes _signatures, 
500         uint256 _gasPrice,
501         uint256 _gasLimit
502     )
503         external
504         returns (bool success)
505     {
506         uint startGas = gasleft();
507         bytes32 signHash = getSignHash(address(this), _wallet, 0, _data, _nonce, _gasPrice, _gasLimit);
508         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
509         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
510         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
511         if((requiredSignatures * 65) == _signatures.length) {
512             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
513                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
514                     // solium-disable-next-line security/no-call-value
515                     success = address(this).call(_data);
516                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
517                 }
518             }
519         }
520         emit TransactionExecuted(_wallet, success, signHash); 
521     }
522 
523     /**
524     * @dev Gets the current nonce for a wallet.
525     * @param _wallet The target wallet.
526     */
527     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
528         return relayer[_wallet].nonce;
529     }
530 
531     /**
532     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
533     * @param _from The starting address for the relayed transaction (should be the module)
534     * @param _to The destination address for the relayed transaction (should be the wallet)
535     * @param _value The value for the relayed transaction
536     * @param _data The data for the relayed transaction
537     * @param _nonce The nonce used to prevent replay attacks.
538     * @param _gasPrice The gas price to use for the gas refund.
539     * @param _gasLimit The gas limit to use for the gas refund.
540     */
541     function getSignHash(
542         address _from,
543         address _to, 
544         uint256 _value, 
545         bytes _data, 
546         uint256 _nonce,
547         uint256 _gasPrice,
548         uint256 _gasLimit
549     ) 
550         internal 
551         pure
552         returns (bytes32) 
553     {
554         return keccak256(
555             abi.encodePacked(
556                 "\x19Ethereum Signed Message:\n32",
557                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
558         ));
559     }
560 
561     /**
562     * @dev Checks if the relayed transaction is unique.
563     * @param _wallet The target wallet.
564     * @param _nonce The nonce
565     * @param _signHash The signed hash of the transaction
566     */
567     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
568         if(relayer[_wallet].executedTx[_signHash] == true) {
569             return false;
570         }
571         relayer[_wallet].executedTx[_signHash] = true;
572         return true;
573     }
574 
575     /**
576     * @dev Checks that a nonce has the correct format and is valid. 
577     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
578     * @param _wallet The target wallet.
579     * @param _nonce The nonce
580     */
581     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
582         if(_nonce <= relayer[_wallet].nonce) {
583             return false;
584         }   
585         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
586         if(nonceBlock > block.number + BLOCKBOUND) {
587             return false;
588         }
589         relayer[_wallet].nonce = _nonce;
590         return true;    
591     }
592 
593     /**
594     * @dev Recovers the signer at a given position from a list of concatenated signatures.
595     * @param _signedHash The signed hash
596     * @param _signatures The concatenated signatures.
597     * @param _index The index of the signature to recover.
598     */
599     function recoverSigner(bytes32 _signedHash, bytes _signatures, uint _index) internal pure returns (address) {
600         uint8 v;
601         bytes32 r;
602         bytes32 s;
603         // we jump 32 (0x20) as the first slot of bytes contains the length
604         // we jump 65 (0x41) per signature
605         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
606         // solium-disable-next-line security/no-inline-assembly
607         assembly {
608             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
609             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
610             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
611         }
612         require(v == 27 || v == 28); 
613         return ecrecover(_signedHash, v, r, s);
614     }
615 
616     /**
617     * @dev Refunds the gas used to the Relayer. 
618     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
619     * @param _wallet The target wallet.
620     * @param _gasUsed The gas used.
621     * @param _gasPrice The gas price for the refund.
622     * @param _gasLimit The gas limit for the refund.
623     * @param _signatures The number of signatures used in the call.
624     * @param _relayer The address of the Relayer.
625     */
626     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
627         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
628         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
629         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
630             if(_gasPrice > tx.gasprice) {
631                 amount = amount * tx.gasprice;
632             }
633             else {
634                 amount = amount * _gasPrice;
635             }
636             _wallet.invoke(_relayer, amount, "");
637         }
638     }
639 
640     /**
641     * @dev Returns false if the refund is expected to fail.
642     * @param _wallet The target wallet.
643     * @param _gasUsed The expected gas used.
644     * @param _gasPrice The expected gas price for the refund.
645     */
646     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
647         if(_gasPrice > 0 
648             && _signatures > 1 
649             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(this) == false)) {
650             return false;
651         }
652         return true;
653     }
654 
655     /**
656     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
657     * as the wallet passed as the input of the execute() method. 
658     @return false if the addresses are different.
659     */
660     function verifyData(address _wallet, bytes _data) private pure returns (bool) {
661         require(_data.length >= 36, "RM: Invalid dataWallet");
662         address dataWallet;
663         // solium-disable-next-line security/no-inline-assembly
664         assembly {
665             //_data = {length:32}{sig:4}{_wallet:32}{...}
666             dataWallet := mload(add(_data, 0x24))
667         }
668         return dataWallet == _wallet;
669     }
670 
671     /**
672     * @dev Parses the data to extract the method signature. 
673     */
674     function functionPrefix(bytes _data) internal pure returns (bytes4 prefix) {
675         require(_data.length >= 4, "RM: Invalid functionPrefix");
676         // solium-disable-next-line security/no-inline-assembly
677         assembly {
678             prefix := mload(add(_data, 0x20))
679         }
680     }
681 }
682 
683 /**
684  * @title Storage
685  * @dev Base contract for the storage of a wallet.
686  * @author Julien Niset - <julien@argent.xyz>
687  */
688 contract Storage {
689 
690     /**
691      * @dev Throws if the caller is not an authorised module.
692      */
693     modifier onlyModule(BaseWallet _wallet) {
694         require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
695         _;
696     }
697 }
698 
699 /**
700  * @title GuardianStorage
701  * @dev Contract storing the state of wallets related to guardians and lock.
702  * The contract only defines basic setters and getters with no logic. Only modules authorised
703  * for a wallet can modify its state.
704  * @author Julien Niset - <julien@argent.xyz>
705  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
706  */
707 contract GuardianStorage is Storage {
708 
709     struct GuardianStorageConfig {
710         // the list of guardians
711         address[] guardians;
712         // the info about guardians
713         mapping (address => GuardianInfo) info;
714         // the lock's release timestamp
715         uint256 lock; 
716         // the module that set the last lock
717         address locker;
718     }
719 
720     struct GuardianInfo {
721         bool exists;
722         uint128 index;
723     }
724 
725     // wallet specific storage
726     mapping (address => GuardianStorageConfig) internal configs;
727 
728     // *************** External Functions ********************* //
729 
730     /**
731      * @dev Lets an authorised module add a guardian to a wallet.
732      * @param _wallet The target wallet.
733      * @param _guardian The guardian to add.
734      */
735     function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
736         GuardianStorageConfig storage config = configs[_wallet];
737         config.info[_guardian].exists = true;
738         config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
739     }
740 
741     /**
742      * @dev Lets an authorised module revoke a guardian from a wallet.
743      * @param _wallet The target wallet.
744      * @param _guardian The guardian to revoke.
745      */
746     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
747         GuardianStorageConfig storage config = configs[_wallet];
748         address lastGuardian = config.guardians[config.guardians.length - 1];
749         if (_guardian != lastGuardian) {
750             uint128 targetIndex = config.info[_guardian].index;
751             config.guardians[targetIndex] = lastGuardian;
752             config.info[lastGuardian].index = targetIndex;
753         }
754         config.guardians.length--;
755         delete config.info[_guardian];
756     }
757 
758     /**
759      * @dev Returns the number of guardians for a wallet.
760      * @param _wallet The target wallet.
761      * @return the number of guardians.
762      */
763     function guardianCount(BaseWallet _wallet) external view returns (uint256) {
764         return configs[_wallet].guardians.length;
765     }
766     
767     /**
768      * @dev Gets the list of guaridans for a wallet.
769      * @param _wallet The target wallet.
770      * @return the list of guardians.
771      */
772     function getGuardians(BaseWallet _wallet) external view returns (address[]) {
773         GuardianStorageConfig storage config = configs[_wallet];
774         address[] memory guardians = new address[](config.guardians.length);
775         for (uint256 i = 0; i < config.guardians.length; i++) {
776             guardians[i] = config.guardians[i];
777         }
778         return guardians;
779     }
780 
781     /**
782      * @dev Checks if an account is a guardian for a wallet.
783      * @param _wallet The target wallet.
784      * @param _guardian The account.
785      * @return true if the account is a guardian for a wallet.
786      */
787     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
788         return configs[_wallet].info[_guardian].exists;
789     }
790 
791     /**
792      * @dev Lets an authorised module set the lock for a wallet.
793      * @param _wallet The target wallet.
794      * @param _releaseAfter The epoch time at which the lock should automatically release.
795      */
796     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
797         configs[_wallet].lock = _releaseAfter;
798         if(_releaseAfter != 0 && msg.sender != configs[_wallet].locker) {
799             configs[_wallet].locker = msg.sender;
800         }
801     }
802 
803     /**
804      * @dev Checks if the lock is set for a wallet.
805      * @param _wallet The target wallet.
806      * @return true if the lock is set for the wallet.
807      */
808     function isLocked(BaseWallet _wallet) external view returns (bool) {
809         return configs[_wallet].lock > now;
810     }
811 
812     /**
813      * @dev Gets the time at which the lock of a wallet will release.
814      * @param _wallet The target wallet.
815      * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
816      */
817     function getLock(BaseWallet _wallet) external view returns (uint256) {
818         return configs[_wallet].lock;
819     }
820 
821     /**
822      * @dev Gets the address of the last module that modified the lock for a wallet.
823      * @param _wallet The target wallet.
824      * @return the address of the last module that modified the lock for a wallet.
825      */
826     function getLocker(BaseWallet _wallet) external view returns (address) {
827         return configs[_wallet].locker;
828     }
829 }
830 
831 library GuardianUtils {
832 
833     /**
834     * @dev Checks if an address is an account guardian or an account authorised to sign on behalf of a smart-contract guardian
835     * given a list of guardians.
836     * @param _guardians the list of guardians
837     * @param _guardian the address to test
838     * @return true and the list of guardians minus the found guardian upon success, false and the original list of guardians if not found.
839     */
840     function isGuardian(address[] _guardians, address _guardian) internal view returns (bool, address[]) {
841         if(_guardians.length == 0 || _guardian == address(0)) {
842             return (false, _guardians);
843         }
844         bool isFound = false;
845         address[] memory updatedGuardians = new address[](_guardians.length - 1);
846         uint256 index = 0;
847         for (uint256 i = 0; i < _guardians.length; i++) {
848             if(!isFound) {
849                 // check if _guardian is an account guardian
850                 if(_guardian == _guardians[i]) {
851                     isFound = true;
852                     continue;
853                 }
854                 // check if _guardian is the owner of a smart contract guardian
855                 if(isContract(_guardians[i]) && isGuardianOwner(_guardians[i], _guardian)) {
856                     isFound = true;
857                     continue;
858                 }
859             }
860             if(index < updatedGuardians.length) {
861                 updatedGuardians[index] = _guardians[i];
862                 index++;
863             }
864         }
865         return isFound ? (true, updatedGuardians) : (false, _guardians);
866     }
867 
868    /**
869     * @dev Checks if an address is a contract.
870     * @param _addr The address.
871     */
872     function isContract(address _addr) internal view returns (bool) {
873         uint32 size;
874         // solium-disable-next-line security/no-inline-assembly
875         assembly {
876             size := extcodesize(_addr)
877         }
878         return (size > 0);
879     }
880 
881     /**
882     * @dev Checks if an address is the owner of a guardian contract. 
883     * The method does not revert if the call to the owner() method consumes more then 5000 gas. 
884     * @param _guardian The guardian contract
885     * @param _owner The owner to verify.
886     */
887     function isGuardianOwner(address _guardian, address _owner) internal view returns (bool) {
888         address owner = address(0);
889         bytes4 sig = bytes4(keccak256("owner()"));
890         // solium-disable-next-line security/no-inline-assembly
891         assembly {
892             let ptr := mload(0x40)
893             mstore(ptr,sig)
894             let result := staticcall(5000, _guardian, ptr, 0x20, ptr, 0x20)
895             if eq(result, 1) {
896                 owner := mload(ptr)
897             }
898         }
899         return owner == _owner;
900     }
901         
902 }
903 
904 /* The MIT License (MIT)
905 
906 Copyright (c) 2016 Smart Contract Solutions, Inc.
907 
908 Permission is hereby granted, free of charge, to any person obtaining
909 a copy of this software and associated documentation files (the
910 "Software"), to deal in the Software without restriction, including
911 without limitation the rights to use, copy, modify, merge, publish,
912 distribute, sublicense, and/or sell copies of the Software, and to
913 permit persons to whom the Software is furnished to do so, subject to
914 the following conditions:
915 
916 The above copyright notice and this permission notice shall be included
917 in all copies or substantial portions of the Software.
918 
919 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
920 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
921 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
922 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
923 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
924 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
925 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
926 
927 /**
928  * @title SafeMath
929  * @dev Math operations with safety checks that throw on error
930  */
931 library SafeMath {
932 
933     /**
934     * @dev Multiplies two numbers, reverts on overflow.
935     */
936     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
937         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
938         // benefit is lost if 'b' is also tested.
939         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
940         if (a == 0) {
941             return 0;
942         }
943 
944         uint256 c = a * b;
945         require(c / a == b);
946 
947         return c;
948     }
949 
950     /**
951     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
952     */
953     function div(uint256 a, uint256 b) internal pure returns (uint256) {
954         require(b > 0); // Solidity only automatically asserts when dividing by 0
955         uint256 c = a / b;
956         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
957 
958         return c;
959     }
960 
961     /**
962     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
963     */
964     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
965         require(b <= a);
966         uint256 c = a - b;
967 
968         return c;
969     }
970 
971     /**
972     * @dev Adds two numbers, reverts on overflow.
973     */
974     function add(uint256 a, uint256 b) internal pure returns (uint256) {
975         uint256 c = a + b;
976         require(c >= a);
977 
978         return c;
979     }
980 
981     /**
982     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
983     * reverts when dividing by zero.
984     */
985     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
986         require(b != 0);
987         return a % b;
988     }
989 
990     /**
991     * @dev Returns ceil(a / b).
992     */
993     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
994         uint256 c = a / b;
995         if(a % b == 0) {
996             return c;
997         }
998         else {
999             return c + 1;
1000         }
1001     }
1002 }
1003 
1004 /**
1005  * @title ApprovedTransfer
1006  * @dev Module to transfer tokens (ETH or ERC20) with the approval of guardians.
1007  * @author Julien Niset - <julien@argent.xyz>
1008  */
1009 contract ApprovedTransfer is BaseModule, RelayerModule {
1010 
1011     bytes32 constant NAME = "ApprovedTransfer";
1012 
1013     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1014 
1015     // The Guardian storage 
1016     GuardianStorage internal guardianStorage;
1017     event Address(address _addr);
1018     event Transfer(address indexed wallet, address indexed token, uint256 indexed amount, address to, bytes data);    
1019 
1020     /**
1021      * @dev Throws if the wallet is locked.
1022      */
1023     modifier onlyWhenUnlocked(BaseWallet _wallet) {
1024         // solium-disable-next-line security/no-block-members
1025         require(!guardianStorage.isLocked(_wallet), "AT: wallet must be unlocked");
1026         _;
1027     }
1028 
1029     constructor(ModuleRegistry _registry, GuardianStorage _guardianStorage) BaseModule(_registry, NAME) public {
1030         guardianStorage = _guardianStorage;
1031     }
1032 
1033     /**
1034     * @dev transfers tokens (ETH or ERC20) from a wallet.
1035     * @param _wallet The target wallet.
1036     * @param _token The address of the token to transfer.
1037     * @param _to The destination address
1038     * @param _amount The amoutnof token to transfer
1039     * @param _data  The data for the transaction (only for ETH transfers)
1040     */
1041     function transferToken(
1042         BaseWallet _wallet, 
1043         address _token, 
1044         address _to, 
1045         uint256 _amount, 
1046         bytes _data
1047     ) 
1048         external 
1049         onlyExecute 
1050         onlyWhenUnlocked(_wallet) 
1051     {
1052         // eth transfer to whitelist
1053         if(_token == ETH_TOKEN) {
1054             _wallet.invoke(_to, _amount, _data);
1055             emit Transfer(_wallet, ETH_TOKEN, _amount, _to, _data);
1056         }
1057         // erc20 transfer to whitelist
1058         else {
1059             bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", _to, _amount);
1060             _wallet.invoke(_token, 0, methodData);
1061             emit Transfer(_wallet, _token, _amount, _to, _data);
1062         }
1063     }
1064 
1065     // *************** Implementation of RelayerModule methods ********************* //
1066 
1067     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool) {
1068         address lastSigner = address(0);
1069         address[] memory guardians = guardianStorage.getGuardians(_wallet);
1070         bool isGuardian = false;
1071         for (uint8 i = 0; i < _signatures.length / 65; i++) {
1072             address signer = recoverSigner(_signHash, _signatures, i);
1073             if(i == 0) {
1074                 // AT: first signer must be owner
1075                 if(!isOwner(_wallet, signer)) { 
1076                     return false;
1077                 }
1078             }
1079             else {
1080                 // "AT: signers must be different"
1081                 if(signer <= lastSigner) { 
1082                     return false;
1083                 }
1084                 lastSigner = signer;
1085                 (isGuardian, guardians) = GuardianUtils.isGuardian(guardians, signer);
1086                 // "AT: signatures not valid"
1087                 if(!isGuardian) { 
1088                     return false;
1089                 }
1090             }
1091         }
1092         return true;
1093     }
1094 
1095     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256) {
1096         // owner  + [n/2] guardians
1097         return  1 + SafeMath.ceil(guardianStorage.guardianCount(_wallet), 2);
1098     }
1099 }