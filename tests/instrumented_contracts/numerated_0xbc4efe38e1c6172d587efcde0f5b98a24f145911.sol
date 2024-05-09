1 pragma solidity ^0.5.4;
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
34  * @title BaseWallet
35  * @dev Simple modular wallet that authorises modules to call its invoke() method.
36  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
37  * @author Julien Niset - <julien@argent.im>
38  */
39 contract BaseWallet {
40 
41     // The implementation of the proxy
42     address public implementation;
43     // The owner 
44     address public owner;
45     // The authorised modules
46     mapping (address => bool) public authorised;
47     // The enabled static calls
48     mapping (bytes4 => address) public enabled;
49     // The number of modules
50     uint public modules;
51     
52     event AuthorisedModule(address indexed module, bool value);
53     event EnabledStaticCall(address indexed module, bytes4 indexed method);
54     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
55     event Received(uint indexed value, address indexed sender, bytes data);
56     event OwnerChanged(address owner);
57     
58     /**
59      * @dev Throws if the sender is not an authorised module.
60      */
61     modifier moduleOnly {
62         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
63         _;
64     }
65 
66     /**
67      * @dev Inits the wallet by setting the owner and authorising a list of modules.
68      * @param _owner The owner.
69      * @param _modules The modules to authorise.
70      */
71     function init(address _owner, address[] calldata _modules) external {
72         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
73         require(_modules.length > 0, "BW: construction requires at least 1 module");
74         owner = _owner;
75         modules = _modules.length;
76         for(uint256 i = 0; i < _modules.length; i++) {
77             require(authorised[_modules[i]] == false, "BW: module is already added");
78             authorised[_modules[i]] = true;
79             Module(_modules[i]).init(this);
80             emit AuthorisedModule(_modules[i], true);
81         }
82         if (address(this).balance > 0) {
83             emit Received(address(this).balance, address(0), "");
84         }
85     }
86     
87     /**
88      * @dev Enables/Disables a module.
89      * @param _module The target module.
90      * @param _value Set to true to authorise the module.
91      */
92     function authoriseModule(address _module, bool _value) external moduleOnly {
93         if (authorised[_module] != _value) {
94             emit AuthorisedModule(_module, _value);
95             if(_value == true) {
96                 modules += 1;
97                 authorised[_module] = true;
98                 Module(_module).init(this);
99             }
100             else {
101                 modules -= 1;
102                 require(modules > 0, "BW: wallet must have at least one module");
103                 delete authorised[_module];
104             }
105         }
106     }
107 
108     /**
109     * @dev Enables a static method by specifying the target module to which the call
110     * must be delegated.
111     * @param _module The target module.
112     * @param _method The static method signature.
113     */
114     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
115         require(authorised[_module], "BW: must be an authorised module for static call");
116         enabled[_method] = _module;
117         emit EnabledStaticCall(_module, _method);
118     }
119 
120     /**
121      * @dev Sets a new owner for the wallet.
122      * @param _newOwner The new owner.
123      */
124     function setOwner(address _newOwner) external moduleOnly {
125         require(_newOwner != address(0), "BW: address cannot be null");
126         owner = _newOwner;
127         emit OwnerChanged(_newOwner);
128     }
129     
130     /**
131      * @dev Performs a generic transaction.
132      * @param _target The address for the transaction.
133      * @param _value The value of the transaction.
134      * @param _data The data of the transaction.
135      */
136     function invoke(address _target, uint _value, bytes calldata _data) external moduleOnly returns (bytes memory _result) {
137         bool success;
138         // solium-disable-next-line security/no-call-value
139         (success, _result) = _target.call.value(_value)(_data);
140         if(!success) {
141             // solium-disable-next-line security/no-inline-assembly
142             assembly {
143                 returndatacopy(0, 0, returndatasize)
144                 revert(0, returndatasize)
145             }
146         }
147         emit Invoked(msg.sender, _target, _value, _data);
148     }
149 
150     /**
151      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
152      * implement specific static methods. It delegates the static call to a target contract if the data corresponds
153      * to an enabled method, or logs the call otherwise.
154      */
155     function() external payable {
156         if(msg.data.length > 0) { 
157             address module = enabled[msg.sig];
158             if(module == address(0)) {
159                 emit Received(msg.value, msg.sender, msg.data);
160             } 
161             else {
162                 require(authorised[module], "BW: must be an authorised module for static call");
163                 // solium-disable-next-line security/no-inline-assembly
164                 assembly {
165                     calldatacopy(0, 0, calldatasize())
166                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
167                     returndatacopy(0, 0, returndatasize())
168                     switch result 
169                     case 0 {revert(0, returndatasize())} 
170                     default {return (0, returndatasize())}
171                 }
172             }
173         }
174     }
175 }
176 
177 /**
178  * @title Owned
179  * @dev Basic contract to define an owner.
180  * @author Julien Niset - <julien@argent.im>
181  */
182 contract Owned {
183 
184     // The owner
185     address public owner;
186 
187     event OwnerChanged(address indexed _newOwner);
188 
189     /**
190      * @dev Throws if the sender is not the owner.
191      */
192     modifier onlyOwner {
193         require(msg.sender == owner, "Must be owner");
194         _;
195     }
196 
197     constructor() public {
198         owner = msg.sender;
199     }
200 
201     /**
202      * @dev Lets the owner transfer ownership of the contract to a new owner.
203      * @param _newOwner The new owner.
204      */
205     function changeOwner(address _newOwner) external onlyOwner {
206         require(_newOwner != address(0), "Address must not be null");
207         owner = _newOwner;
208         emit OwnerChanged(_newOwner);
209     }
210 }
211 
212 /**
213  * ERC20 contract interface.
214  */
215 contract ERC20 {
216     function totalSupply() public view returns (uint);
217     function decimals() public view returns (uint);
218     function balanceOf(address tokenOwner) public view returns (uint balance);
219     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
220     function transfer(address to, uint tokens) public returns (bool success);
221     function approve(address spender, uint tokens) public returns (bool success);
222     function transferFrom(address from, address to, uint tokens) public returns (bool success);
223 }
224 
225 
226 
227 /**
228  * @title ModuleRegistry
229  * @dev Registry of authorised modules. 
230  * Modules must be registered before they can be authorised on a wallet.
231  * @author Julien Niset - <julien@argent.im>
232  */
233 contract ModuleRegistry is Owned {
234 
235     mapping (address => Info) internal modules;
236     mapping (address => Info) internal upgraders;
237 
238     event ModuleRegistered(address indexed module, bytes32 name);
239     event ModuleDeRegistered(address module);
240     event UpgraderRegistered(address indexed upgrader, bytes32 name);
241     event UpgraderDeRegistered(address upgrader);
242 
243     struct Info {
244         bool exists;
245         bytes32 name;
246     }
247 
248     /**
249      * @dev Registers a module.
250      * @param _module The module.
251      * @param _name The unique name of the module.
252      */
253     function registerModule(address _module, bytes32 _name) external onlyOwner {
254         require(!modules[_module].exists, "MR: module already exists");
255         modules[_module] = Info({exists: true, name: _name});
256         emit ModuleRegistered(_module, _name);
257     }
258 
259     /**
260      * @dev Deregisters a module.
261      * @param _module The module.
262      */
263     function deregisterModule(address _module) external onlyOwner {
264         require(modules[_module].exists, "MR: module does not exist");
265         delete modules[_module];
266         emit ModuleDeRegistered(_module);
267     }
268 
269         /**
270      * @dev Registers an upgrader.
271      * @param _upgrader The upgrader.
272      * @param _name The unique name of the upgrader.
273      */
274     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
275         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
276         upgraders[_upgrader] = Info({exists: true, name: _name});
277         emit UpgraderRegistered(_upgrader, _name);
278     }
279 
280     /**
281      * @dev Deregisters an upgrader.
282      * @param _upgrader The _upgrader.
283      */
284     function deregisterUpgrader(address _upgrader) external onlyOwner {
285         require(upgraders[_upgrader].exists, "MR: upgrader does not exist");
286         delete upgraders[_upgrader];
287         emit UpgraderDeRegistered(_upgrader);
288     }
289 
290     /**
291     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
292     * registry.
293     * @param _token The token to recover.
294     */
295     function recoverToken(address _token) external onlyOwner {
296         uint total = ERC20(_token).balanceOf(address(this));
297         ERC20(_token).transfer(msg.sender, total);
298     } 
299 
300     /**
301      * @dev Gets the name of a module from its address.
302      * @param _module The module address.
303      * @return the name.
304      */
305     function moduleInfo(address _module) external view returns (bytes32) {
306         return modules[_module].name;
307     }
308 
309     /**
310      * @dev Gets the name of an upgrader from its address.
311      * @param _upgrader The upgrader address.
312      * @return the name.
313      */
314     function upgraderInfo(address _upgrader) external view returns (bytes32) {
315         return upgraders[_upgrader].name;
316     }
317 
318     /**
319      * @dev Checks if a module is registered.
320      * @param _module The module address.
321      * @return true if the module is registered.
322      */
323     function isRegisteredModule(address _module) external view returns (bool) {
324         return modules[_module].exists;
325     }
326 
327     /**
328      * @dev Checks if a list of modules are registered.
329      * @param _modules The list of modules address.
330      * @return true if all the modules are registered.
331      */
332     function isRegisteredModule(address[] calldata _modules) external view returns (bool) {
333         for(uint i = 0; i < _modules.length; i++) {
334             if (!modules[_modules[i]].exists) {
335                 return false;
336             }
337         }
338         return true;
339     }  
340 
341     /**
342      * @dev Checks if an upgrader is registered.
343      * @param _upgrader The upgrader address.
344      * @return true if the upgrader is registered.
345      */
346     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
347         return upgraders[_upgrader].exists;
348     } 
349 
350 }
351 
352 
353 
354 
355 /**
356  * @title BaseModule
357  * @dev Basic module that contains some methods common to all modules.
358  * @author Julien Niset - <julien@argent.im>
359  */
360 contract BaseModule is Module {
361 
362     // The adddress of the module registry.
363     ModuleRegistry internal registry;
364 
365     event ModuleCreated(bytes32 name);
366     event ModuleInitialised(address wallet);
367 
368     constructor(ModuleRegistry _registry, bytes32 _name) public {
369         registry = _registry;
370         emit ModuleCreated(_name);
371     }
372 
373     /**
374      * @dev Throws if the sender is not the target wallet of the call.
375      */
376     modifier onlyWallet(BaseWallet _wallet) {
377         require(msg.sender == address(_wallet), "BM: caller must be wallet");
378         _;
379     }
380 
381     /**
382      * @dev Throws if the sender is not the owner of the target wallet or the module itself.
383      */
384     modifier onlyWalletOwner(BaseWallet _wallet) {
385         require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
386         _;
387     }
388 
389     /**
390      * @dev Throws if the sender is not the owner of the target wallet.
391      */
392     modifier strictOnlyWalletOwner(BaseWallet _wallet) {
393         require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
394         _;
395     }
396 
397     /**
398      * @dev Inits the module for a wallet by logging an event.
399      * The method can only be called by the wallet itself.
400      * @param _wallet The wallet.
401      */
402     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
403         emit ModuleInitialised(address(_wallet));
404     }
405 
406     /**
407      * @dev Adds a module to a wallet. First checks that the module is registered.
408      * @param _wallet The target wallet.
409      * @param _module The modules to authorise.
410      */
411     function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
412         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
413         _wallet.authoriseModule(address(_module), true);
414     }
415 
416     /**
417     * @dev Utility method enbaling anyone to recover ERC20 token sent to the
418     * module by mistake and transfer them to the Module Registry. 
419     * @param _token The token to recover.
420     */
421     function recoverToken(address _token) external {
422         uint total = ERC20(_token).balanceOf(address(this));
423         ERC20(_token).transfer(address(registry), total);
424     }
425 
426     /**
427      * @dev Helper method to check if an address is the owner of a target wallet.
428      * @param _wallet The target wallet.
429      * @param _addr The address.
430      */
431     function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
432         return _wallet.owner() == _addr;
433     }
434 
435     /**
436      * @dev Helper method to invoke a wallet.
437      * @param _wallet The target wallet.
438      * @param _to The target address for the transaction.
439      * @param _value The value of the transaction.
440      * @param _data The data of the transaction.
441      */
442     function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data) internal returns (bytes memory _res) {
443         bool success;
444         // solium-disable-next-line security/no-call-value
445         (success, _res) = _wallet.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _to, _value, _data));
446         if(success && _res.length > 0) { //_res is empty if _wallet is an "old" BaseWallet that can't return output values
447             (_res) = abi.decode(_res, (bytes));
448         } else if (_res.length > 0) {
449             // solium-disable-next-line security/no-inline-assembly
450             assembly {
451                 returndatacopy(0, 0, returndatasize)
452                 revert(0, returndatasize)
453             }
454         } else if(!success) {
455             revert("BM: wallet invoke reverted");
456         }
457     }
458 }
459 
460 
461 
462 /**
463  * @title RelayerModule
464  * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer. 
465  * @author Julien Niset - <julien@argent.im>
466  */
467 contract RelayerModule is Module {
468 
469     uint256 constant internal BLOCKBOUND = 10000;
470 
471     mapping (address => RelayerConfig) public relayer; 
472 
473     struct RelayerConfig {
474         uint256 nonce;
475         mapping (bytes32 => bool) executedTx;
476     }
477 
478     event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);
479 
480     /**
481      * @dev Throws if the call did not go through the execute() method.
482      */
483     modifier onlyExecute {
484         require(msg.sender == address(this), "RM: must be called via execute()");
485         _;
486     }
487 
488     /* ***************** Abstract method ************************* */
489 
490     /**
491     * @dev Gets the number of valid signatures that must be provided to execute a
492     * specific relayed transaction.
493     * @param _wallet The target wallet.
494     * @param _data The data of the relayed transaction.
495     * @return The number of required signatures.
496     */
497     function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);
498 
499     /**
500     * @dev Validates the signatures provided with a relayed transaction.
501     * The method MUST throw if one or more signatures are not valid.
502     * @param _wallet The target wallet.
503     * @param _data The data of the relayed transaction.
504     * @param _signHash The signed hash representing the relayed transaction.
505     * @param _signatures The signatures as a concatenated byte array.
506     */
507     function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool);
508 
509     /* ************************************************************ */
510 
511     /**
512     * @dev Executes a relayed transaction.
513     * @param _wallet The target wallet.
514     * @param _data The data for the relayed transaction
515     * @param _nonce The nonce used to prevent replay attacks.
516     * @param _signatures The signatures as a concatenated byte array.
517     * @param _gasPrice The gas price to use for the gas refund.
518     * @param _gasLimit The gas limit to use for the gas refund.
519     */
520     function execute(
521         BaseWallet _wallet,
522         bytes calldata _data,
523         uint256 _nonce,
524         bytes calldata _signatures,
525         uint256 _gasPrice,
526         uint256 _gasLimit
527     )
528         external
529         returns (bool success)
530     {
531         uint startGas = gasleft();
532         bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
533         require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
534         require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
535         uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
536         if((requiredSignatures * 65) == _signatures.length) {
537             if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
538                 if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
539                     // solium-disable-next-line security/no-call-value
540                     (success,) = address(this).call(_data);
541                     refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
542                 }
543             }
544         }
545         emit TransactionExecuted(address(_wallet), success, signHash);
546     }
547 
548     /**
549     * @dev Gets the current nonce for a wallet.
550     * @param _wallet The target wallet.
551     */
552     function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
553         return relayer[address(_wallet)].nonce;
554     }
555 
556     /**
557     * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
558     * @param _from The starting address for the relayed transaction (should be the module)
559     * @param _to The destination address for the relayed transaction (should be the wallet)
560     * @param _value The value for the relayed transaction
561     * @param _data The data for the relayed transaction
562     * @param _nonce The nonce used to prevent replay attacks.
563     * @param _gasPrice The gas price to use for the gas refund.
564     * @param _gasLimit The gas limit to use for the gas refund.
565     */
566     function getSignHash(
567         address _from,
568         address _to,
569         uint256 _value,
570         bytes memory _data,
571         uint256 _nonce,
572         uint256 _gasPrice,
573         uint256 _gasLimit
574     )
575         internal
576         pure
577         returns (bytes32)
578     {
579         return keccak256(
580             abi.encodePacked(
581                 "\x19Ethereum Signed Message:\n32",
582                 keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
583         ));
584     }
585 
586     /**
587     * @dev Checks if the relayed transaction is unique.
588     * @param _wallet The target wallet.
589     * @param _nonce The nonce
590     * @param _signHash The signed hash of the transaction
591     */
592     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
593         if(relayer[address(_wallet)].executedTx[_signHash] == true) {
594             return false;
595         }
596         relayer[address(_wallet)].executedTx[_signHash] = true;
597         return true;
598     }
599 
600     /**
601     * @dev Checks that a nonce has the correct format and is valid.
602     * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
603     * @param _wallet The target wallet.
604     * @param _nonce The nonce
605     */
606     function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
607         if(_nonce <= relayer[address(_wallet)].nonce) {
608             return false;
609         }
610         uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
611         if(nonceBlock > block.number + BLOCKBOUND) {
612             return false;
613         }
614         relayer[address(_wallet)].nonce = _nonce;
615         return true;
616     }
617 
618     /**
619     * @dev Recovers the signer at a given position from a list of concatenated signatures.
620     * @param _signedHash The signed hash
621     * @param _signatures The concatenated signatures.
622     * @param _index The index of the signature to recover.
623     */
624     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
625         uint8 v;
626         bytes32 r;
627         bytes32 s;
628         // we jump 32 (0x20) as the first slot of bytes contains the length
629         // we jump 65 (0x41) per signature
630         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
631         // solium-disable-next-line security/no-inline-assembly
632         assembly {
633             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
634             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
635             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
636         }
637         require(v == 27 || v == 28);
638         return ecrecover(_signedHash, v, r, s);
639     }
640 
641     /**
642     * @dev Refunds the gas used to the Relayer. 
643     * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
644     * @param _wallet The target wallet.
645     * @param _gasUsed The gas used.
646     * @param _gasPrice The gas price for the refund.
647     * @param _gasLimit The gas limit for the refund.
648     * @param _signatures The number of signatures used in the call.
649     * @param _relayer The address of the Relayer.
650     */
651     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
652         uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
653         // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
654         if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
655             if(_gasPrice > tx.gasprice) {
656                 amount = amount * tx.gasprice;
657             }
658             else {
659                 amount = amount * _gasPrice;
660             }
661             _wallet.invoke(_relayer, amount, "");
662         }
663     }
664 
665     /**
666     * @dev Returns false if the refund is expected to fail.
667     * @param _wallet The target wallet.
668     * @param _gasUsed The expected gas used.
669     * @param _gasPrice The expected gas price for the refund.
670     */
671     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
672         if(_gasPrice > 0
673             && _signatures > 1
674             && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
675             return false;
676         }
677         return true;
678     }
679 
680     /**
681     * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
682     * as the wallet passed as the input of the execute() method. 
683     @return false if the addresses are different.
684     */
685     function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
686         require(_data.length >= 36, "RM: Invalid dataWallet");
687         address dataWallet;
688         // solium-disable-next-line security/no-inline-assembly
689         assembly {
690             //_data = {length:32}{sig:4}{_wallet:32}{...}
691             dataWallet := mload(add(_data, 0x24))
692         }
693         return dataWallet == _wallet;
694     }
695 
696     /**
697     * @dev Parses the data to extract the method signature.
698     */
699     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
700         require(_data.length >= 4, "RM: Invalid functionPrefix");
701         // solium-disable-next-line security/no-inline-assembly
702         assembly {
703             prefix := mload(add(_data, 0x20))
704         }
705     }
706 }
707 
708 
709 
710 /**
711  * @title OnlyOwnerModule
712  * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
713  * must be called with one signature frm the owner.
714  * @author Julien Niset - <julien@argent.im>
715  */
716 contract OnlyOwnerModule is BaseModule, RelayerModule {
717 
718     // bytes4 private constant IS_ONLY_OWNER_MODULE = bytes4(keccak256("isOnlyOwnerModule()"));
719 
720    /**
721     * @dev Returns a constant that indicates that the module is an OnlyOwnerModule.
722     * @return The constant bytes4(keccak256("isOnlyOwnerModule()"))
723     */
724     function isOnlyOwnerModule() external pure returns (bytes4) {
725         // return IS_ONLY_OWNER_MODULE;
726         return this.isOnlyOwnerModule.selector;
727     }
728 
729     /**
730      * @dev Adds a module to a wallet. First checks that the module is registered.
731      * Unlike its overrided parent, this method can be called via the RelayerModule's execute()
732      * @param _wallet The target wallet.
733      * @param _module The modules to authorise.
734      */
735     function addModule(BaseWallet _wallet, Module _module) external onlyWalletOwner(_wallet) {
736         require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
737         _wallet.authoriseModule(address(_module), true);
738     }
739 
740     // *************** Implementation of RelayerModule methods ********************* //
741 
742     // Overrides to use the incremental nonce and save some gas
743     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 /* _signHash */) internal returns (bool) {
744         return checkAndUpdateNonce(_wallet, _nonce);
745     }
746 
747     function validateSignatures(
748         BaseWallet _wallet,
749         bytes memory /* _data */,
750         bytes32 _signHash,
751         bytes memory _signatures
752     )
753         internal
754         view
755         returns (bool)
756     {
757         address signer = recoverSigner(_signHash, _signatures, 0);
758         return isOwner(_wallet, signer); // "OOM: signer must be owner"
759     }
760 
761     function getRequiredSignatures(BaseWallet /* _wallet */, bytes memory /* _data */) internal view returns (uint256) {
762         return 1;
763     }
764 }
765 
766 /**
767  * @title BaseTransfer
768  * @dev Module containing internal methods to execute or approve transfers
769  * @author Olivier VDB - <olivier@argent.xyz>
770  */
771 contract BaseTransfer is BaseModule {
772 
773     // Empty calldata
774     bytes constant internal EMPTY_BYTES = "";
775     // Mock token address for ETH
776     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
777 
778     // *************** Events *************************** //
779 
780     event Transfer(address indexed wallet, address indexed token, uint256 indexed amount, address to, bytes data);
781     event Approved(address indexed wallet, address indexed token, uint256 amount, address spender);
782     event CalledContract(address indexed wallet, address indexed to, uint256 amount, bytes data);
783 
784     // *************** Internal Functions ********************* //
785 
786     /**
787     * @dev Helper method to transfer ETH or ERC20 for a wallet.
788     * @param _wallet The target wallet.
789     * @param _token The ERC20 address.
790     * @param _to The recipient.
791     * @param _value The amount of ETH to transfer
792     * @param _data The data to *log* with the transfer.
793     */
794     function doTransfer(BaseWallet _wallet, address _token, address _to, uint256 _value, bytes memory _data) internal {
795         if(_token == ETH_TOKEN) {
796             invokeWallet(address(_wallet), _to, _value, EMPTY_BYTES);
797         }
798         else {
799             bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", _to, _value);
800             invokeWallet(address(_wallet), _token, 0, methodData);
801         }
802         emit Transfer(address(_wallet), _token, _value, _to, _data);
803     }
804 
805     /**
806     * @dev Helper method to approve spending the ERC20 of a wallet.
807     * @param _wallet The target wallet.
808     * @param _token The ERC20 address.
809     * @param _spender The spender address.
810     * @param _value The amount of token to transfer.
811     */
812     function doApproveToken(BaseWallet _wallet, address _token, address _spender, uint256 _value) internal {
813         bytes memory methodData = abi.encodeWithSignature("approve(address,uint256)", _spender, _value);
814         invokeWallet(address(_wallet), _token, 0, methodData);
815         emit Approved(address(_wallet), _token, _value, _spender);
816     }
817 
818     /**
819     * @dev Helper method to call an external contract.
820     * @param _wallet The target wallet.
821     * @param _contract The contract address.
822     * @param _value The ETH value to transfer.
823     * @param _data The method data.
824     */
825     function doCallContract(BaseWallet _wallet, address _contract, uint256 _value, bytes memory _data) internal {
826         invokeWallet(address(_wallet), _contract, _value, _data);
827         emit CalledContract(address(_wallet), _contract, _value, _data);
828     }
829 }
830 
831 
832 /* The MIT License (MIT)
833 
834 Copyright (c) 2016 Smart Contract Solutions, Inc.
835 
836 Permission is hereby granted, free of charge, to any person obtaining
837 a copy of this software and associated documentation files (the
838 "Software"), to deal in the Software without restriction, including
839 without limitation the rights to use, copy, modify, merge, publish,
840 distribute, sublicense, and/or sell copies of the Software, and to
841 permit persons to whom the Software is furnished to do so, subject to
842 the following conditions:
843 
844 The above copyright notice and this permission notice shall be included
845 in all copies or substantial portions of the Software.
846 
847 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
848 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
849 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
850 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
851 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
852 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
853 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
854 
855 /**
856  * @title SafeMath
857  * @dev Math operations with safety checks that throw on error
858  */
859 library SafeMath {
860 
861     /**
862     * @dev Multiplies two numbers, reverts on overflow.
863     */
864     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
865         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
866         // benefit is lost if 'b' is also tested.
867         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
868         if (a == 0) {
869             return 0;
870         }
871 
872         uint256 c = a * b;
873         require(c / a == b);
874 
875         return c;
876     }
877 
878     /**
879     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
880     */
881     function div(uint256 a, uint256 b) internal pure returns (uint256) {
882         require(b > 0); // Solidity only automatically asserts when dividing by 0
883         uint256 c = a / b;
884         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
885 
886         return c;
887     }
888 
889     /**
890     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
891     */
892     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
893         require(b <= a);
894         uint256 c = a - b;
895 
896         return c;
897     }
898 
899     /**
900     * @dev Adds two numbers, reverts on overflow.
901     */
902     function add(uint256 a, uint256 b) internal pure returns (uint256) {
903         uint256 c = a + b;
904         require(c >= a);
905 
906         return c;
907     }
908 
909     /**
910     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
911     * reverts when dividing by zero.
912     */
913     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
914         require(b != 0);
915         return a % b;
916     }
917 
918     /**
919     * @dev Returns ceil(a / b).
920     */
921     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
922         uint256 c = a / b;
923         if(a % b == 0) {
924             return c;
925         }
926         else {
927             return c + 1;
928         }
929     }
930 
931     // from DSMath - operations on fixed precision floats
932 
933     uint256 constant WAD = 10 ** 18;
934     uint256 constant RAY = 10 ** 27;
935 
936     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
937         z = add(mul(x, y), WAD / 2) / WAD;
938     }
939     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
940         z = add(mul(x, y), RAY / 2) / RAY;
941     }
942     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
943         z = add(mul(x, WAD), y / 2) / y;
944     }
945     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
946         z = add(mul(x, RAY), y / 2) / y;
947     }
948 }
949 
950 
951 
952 
953 /**
954  * @title LimitManager
955  * @dev Module to transfer tokens (ETH or ERC20) based on a security context (daily limit, whitelist, etc).
956  * @author Julien Niset - <julien@argent.im>
957  */
958 contract LimitManager is BaseModule {
959 
960     // large limit when the limit can be considered disabled
961     uint128 constant internal LIMIT_DISABLED = uint128(-1); // 3.40282366920938463463374607431768211455e+38
962 
963     using SafeMath for uint256;
964 
965     struct LimitManagerConfig {
966         // The global limit
967         Limit limit;
968         // whitelist
969         DailySpent dailySpent;
970     } 
971 
972     struct Limit {
973         // the current limit
974         uint128 current;
975         // the pending limit if any
976         uint128 pending;
977         // when the pending limit becomes the current limit
978         uint64 changeAfter;
979     }
980 
981     struct DailySpent {
982         // The amount already spent during the current period
983         uint128 alreadySpent;
984         // The end of the current period
985         uint64 periodEnd;
986     }
987 
988     // wallet specific storage
989     mapping (address => LimitManagerConfig) internal limits;
990     // The default limit
991     uint256 public defaultLimit;
992 
993     // *************** Events *************************** //
994 
995     event LimitChanged(address indexed wallet, uint indexed newLimit, uint64 indexed startAfter);
996 
997     // *************** Constructor ********************** //
998 
999     constructor(uint256 _defaultLimit) public {
1000         defaultLimit = _defaultLimit;
1001     }
1002 
1003     // *************** External/Public Functions ********************* //
1004 
1005     /**
1006      * @dev Inits the module for a wallet by setting the limit to the default value.
1007      * @param _wallet The target wallet.
1008      */
1009     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
1010         Limit storage limit = limits[address(_wallet)].limit;
1011         if(limit.current == 0 && limit.changeAfter == 0) {
1012             limit.current = uint128(defaultLimit);
1013         }
1014     }
1015 
1016     /**
1017      * @dev Changes the global limit. 
1018      * The limit is expressed in ETH and the change is pending for the security period.
1019      * @param _wallet The target wallet.
1020      * @param _newLimit The new limit.
1021      * @param _securityPeriod The security period.
1022      */
1023     function changeLimit(BaseWallet _wallet, uint256 _newLimit, uint256 _securityPeriod) internal {
1024         Limit storage limit = limits[address(_wallet)].limit;
1025         // solium-disable-next-line security/no-block-members
1026         uint128 currentLimit = (limit.changeAfter > 0 && limit.changeAfter < now) ? limit.pending : limit.current;
1027         limit.current = currentLimit;
1028         limit.pending = uint128(_newLimit);
1029         // solium-disable-next-line security/no-block-members
1030         limit.changeAfter = uint64(now.add(_securityPeriod));
1031         // solium-disable-next-line security/no-block-members
1032         emit LimitChanged(address(_wallet), _newLimit, uint64(now.add(_securityPeriod)));
1033     }
1034 
1035     // *************** Internal Functions ********************* //
1036 
1037     /**
1038     * @dev Gets the current global limit for a wallet.
1039     * @param _wallet The target wallet.
1040     * @return the current limit expressed in ETH.
1041     */
1042     function getCurrentLimit(BaseWallet _wallet) public view returns (uint256 _currentLimit) {
1043         Limit storage limit = limits[address(_wallet)].limit;
1044         _currentLimit = uint256(currentLimit(limit.current, limit.pending, limit.changeAfter));
1045     }
1046 
1047     /**
1048     * @dev Gets a pending limit for a wallet if any.
1049     * @param _wallet The target wallet.
1050     * @return the pending limit (in ETH) and the time at chich it will become effective.
1051     */
1052     function getPendingLimit(BaseWallet _wallet) external view returns (uint256 _pendingLimit, uint64 _changeAfter) {
1053         Limit storage limit = limits[address(_wallet)].limit;
1054         // solium-disable-next-line security/no-block-members
1055         return ((now < limit.changeAfter)? (uint256(limit.pending), limit.changeAfter) : (0,0));
1056     }
1057 
1058     /**
1059     * @dev Gets the amount of tokens that has not yet been spent during the current period.
1060     * @param _wallet The target wallet.
1061     * @return the amount of tokens (in ETH) that has not been spent yet and the end of the period.
1062     */
1063     function getDailyUnspent(BaseWallet _wallet) external view returns (uint256 _unspent, uint64 _periodEnd) {
1064         uint256 globalLimit = getCurrentLimit(_wallet);
1065         DailySpent storage expense = limits[address(_wallet)].dailySpent;
1066         // solium-disable-next-line security/no-block-members
1067         if(now > expense.periodEnd) {
1068             _unspent = globalLimit;
1069             _periodEnd = uint64(now + 24 hours);
1070         }
1071         else {
1072             _periodEnd = expense.periodEnd;
1073             if(expense.alreadySpent < globalLimit) {
1074                 _unspent = globalLimit - expense.alreadySpent;
1075             }
1076         }
1077     }
1078 
1079     /**
1080     * @dev Helper method to check if a transfer is within the limit.
1081     * If yes the daily unspent for the current period is updated.
1082     * @param _wallet The target wallet.
1083     * @param _amount The amount for the transfer
1084     */
1085     function checkAndUpdateDailySpent(BaseWallet _wallet, uint _amount) internal returns (bool) {
1086         Limit storage limit = limits[address(_wallet)].limit;
1087         uint128 current = currentLimit(limit.current, limit.pending, limit.changeAfter);
1088         if(isWithinDailyLimit(_wallet, current, _amount)) {
1089             updateDailySpent(_wallet, current, _amount);
1090             return true;
1091         }
1092         return false;
1093     }
1094 
1095     /**
1096     * @dev Helper method to update the daily spent for the current period.
1097     * @param _wallet The target wallet.
1098     * @param _limit The current limit for the wallet.
1099     * @param _amount The amount to add to the daily spent.
1100     */
1101     function updateDailySpent(BaseWallet _wallet, uint128 _limit, uint _amount) internal {
1102         if(_limit != LIMIT_DISABLED) {
1103             DailySpent storage expense = limits[address(_wallet)].dailySpent;
1104             if (expense.periodEnd < now) {
1105                 expense.periodEnd = uint64(now + 24 hours);
1106                 expense.alreadySpent = uint128(_amount);
1107             }
1108             else {
1109                 expense.alreadySpent += uint128(_amount);
1110             }
1111         }
1112     }
1113 
1114     /**
1115     * @dev Checks if a transfer amount is withing the daily limit for a wallet.
1116     * @param _wallet The target wallet.
1117     * @param _limit The current limit for the wallet.
1118     * @param _amount The transfer amount.
1119     * @return true if the transfer amount is withing the daily limit.
1120     */
1121     function isWithinDailyLimit(BaseWallet _wallet, uint _limit, uint _amount) internal view returns (bool)  {
1122         DailySpent storage expense = limits[address(_wallet)].dailySpent;
1123         if(_limit == LIMIT_DISABLED) {
1124             return true;
1125         }
1126         else if (expense.periodEnd < now) {
1127             return (_amount <= _limit);
1128         } else {
1129             return (expense.alreadySpent + _amount <= _limit && expense.alreadySpent + _amount >= expense.alreadySpent);
1130         }
1131     }
1132 
1133     /**
1134     * @dev Helper method to get the current limit from a Limit struct.
1135     * @param _current The value of the current parameter
1136     * @param _pending The value of the pending parameter
1137     * @param _changeAfter The value of the changeAfter parameter
1138     */
1139     function currentLimit(uint128 _current, uint128 _pending, uint64 _changeAfter) internal view returns (uint128) {
1140         if(_changeAfter > 0 && _changeAfter < now) {
1141             return _pending;
1142         }
1143         return _current;
1144     }
1145 
1146 }
1147 
1148 /**
1149  * @title Managed
1150  * @dev Basic contract that defines a set of managers. Only the owner can add/remove managers.
1151  * @author Julien Niset - <julien@argent.im>
1152  */
1153 contract Managed is Owned {
1154 
1155     // The managers
1156     mapping (address => bool) public managers;
1157 
1158     /**
1159      * @dev Throws if the sender is not a manager.
1160      */
1161     modifier onlyManager {
1162         require(managers[msg.sender] == true, "M: Must be manager");
1163         _;
1164     }
1165 
1166     event ManagerAdded(address indexed _manager);
1167     event ManagerRevoked(address indexed _manager);
1168 
1169     /**
1170     * @dev Adds a manager. 
1171     * @param _manager The address of the manager.
1172     */
1173     function addManager(address _manager) external onlyOwner {
1174         require(_manager != address(0), "M: Address must not be null");
1175         if(managers[_manager] == false) {
1176             managers[_manager] = true;
1177             emit ManagerAdded(_manager);
1178         }        
1179     }
1180 
1181     /**
1182     * @dev Revokes a manager.
1183     * @param _manager The address of the manager.
1184     */
1185     function revokeManager(address _manager) external onlyOwner {
1186         require(managers[_manager] == true, "M: Target must be an existing manager");
1187         delete managers[_manager];
1188         emit ManagerRevoked(_manager);
1189     }
1190 }
1191 
1192 contract KyberNetwork {
1193 
1194     function getExpectedRate(
1195         ERC20 src,
1196         ERC20 dest,
1197         uint srcQty
1198     )
1199         public
1200         view
1201         returns (uint expectedRate, uint slippageRate);
1202 
1203     function trade(
1204         ERC20 src,
1205         uint srcAmount,
1206         ERC20 dest,
1207         address payable destAddress,
1208         uint maxDestAmount,
1209         uint minConversionRate,
1210         address walletId
1211     )
1212         public
1213         payable
1214         returns(uint);
1215 }
1216 
1217 
1218 
1219 
1220 
1221 contract TokenPriceProvider is Managed {
1222 
1223     // Mock token address for ETH
1224     address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1225 
1226     using SafeMath for uint256;
1227 
1228     mapping(address => uint256) public cachedPrices;
1229 
1230     // Address of the KyberNetwork contract
1231     KyberNetwork public kyberNetwork;
1232 
1233     constructor(KyberNetwork _kyberNetwork) public {
1234         kyberNetwork = _kyberNetwork;
1235     }
1236 
1237     function setPrice(ERC20 _token, uint256 _price) public onlyManager {
1238         cachedPrices[address(_token)] = _price;
1239     }
1240 
1241     function setPriceForTokenList(ERC20[] calldata _tokens, uint256[] calldata _prices) external onlyManager {
1242         for(uint16 i = 0; i < _tokens.length; i++) {
1243             setPrice(_tokens[i], _prices[i]);
1244         }
1245     }
1246 
1247     /**
1248      * @dev Converts the value of _amount tokens in ether.
1249      * @param _amount the amount of tokens to convert (in 'token wei' twei)
1250      * @param _token the ERC20 token contract
1251      * @return the ether value (in wei) of _amount tokens with contract _token
1252      */
1253     function getEtherValue(uint256 _amount, address _token) external view returns (uint256) {
1254         uint256 decimals = ERC20(_token).decimals();
1255         uint256 price = cachedPrices[_token];
1256         return price.mul(_amount).div(10**decimals);
1257     }
1258 
1259     //
1260     // The following is added to be backward-compatible with Argent's old backend
1261     //
1262 
1263     function setKyberNetwork(KyberNetwork _kyberNetwork) external onlyManager {
1264         kyberNetwork = _kyberNetwork;
1265     }
1266 
1267     function syncPrice(ERC20 _token) external {
1268         require(address(kyberNetwork) != address(0), "Kyber sync is disabled");
1269         (uint256 expectedRate,) = kyberNetwork.getExpectedRate(_token, ERC20(ETH_TOKEN_ADDRESS), 10000);
1270         cachedPrices[address(_token)] = expectedRate;
1271     }
1272 
1273     function syncPriceForTokenList(ERC20[] calldata _tokens) external {
1274         require(address(kyberNetwork) != address(0), "Kyber sync is disabled");
1275         for(uint16 i = 0; i < _tokens.length; i++) {
1276             (uint256 expectedRate,) = kyberNetwork.getExpectedRate(_tokens[i], ERC20(ETH_TOKEN_ADDRESS), 10000);
1277             cachedPrices[address(_tokens[i])] = expectedRate;
1278         }
1279     }
1280 }
1281 
1282 /**
1283  * @title Storage
1284  * @dev Base contract for the storage of a wallet.
1285  * @author Julien Niset - <julien@argent.im>
1286  */
1287 contract Storage {
1288 
1289     /**
1290      * @dev Throws if the caller is not an authorised module.
1291      */
1292     modifier onlyModule(BaseWallet _wallet) {
1293         require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
1294         _;
1295     }
1296 }
1297 
1298 
1299 /**
1300  * @title GuardianStorage
1301  * @dev Contract storing the state of wallets related to guardians and lock.
1302  * The contract only defines basic setters and getters with no logic. Only modules authorised
1303  * for a wallet can modify its state.
1304  * @author Julien Niset - <julien@argent.im>
1305  * @author Olivier Van Den Biggelaar - <olivier@argent.im>
1306  */
1307 contract GuardianStorage is Storage {
1308 
1309     struct GuardianStorageConfig {
1310         // the list of guardians
1311         address[] guardians;
1312         // the info about guardians
1313         mapping (address => GuardianInfo) info;
1314         // the lock's release timestamp
1315         uint256 lock; 
1316         // the module that set the last lock
1317         address locker;
1318     }
1319 
1320     struct GuardianInfo {
1321         bool exists;
1322         uint128 index;
1323     }
1324 
1325     // wallet specific storage
1326     mapping (address => GuardianStorageConfig) internal configs;
1327 
1328     // *************** External Functions ********************* //
1329 
1330     /**
1331      * @dev Lets an authorised module add a guardian to a wallet.
1332      * @param _wallet The target wallet.
1333      * @param _guardian The guardian to add.
1334      */
1335     function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
1336         GuardianStorageConfig storage config = configs[address(_wallet)];
1337         config.info[_guardian].exists = true;
1338         config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
1339     }
1340 
1341     /**
1342      * @dev Lets an authorised module revoke a guardian from a wallet.
1343      * @param _wallet The target wallet.
1344      * @param _guardian The guardian to revoke.
1345      */
1346     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
1347         GuardianStorageConfig storage config = configs[address(_wallet)];
1348         address lastGuardian = config.guardians[config.guardians.length - 1];
1349         if (_guardian != lastGuardian) {
1350             uint128 targetIndex = config.info[_guardian].index;
1351             config.guardians[targetIndex] = lastGuardian;
1352             config.info[lastGuardian].index = targetIndex;
1353         }
1354         config.guardians.length--;
1355         delete config.info[_guardian];
1356     }
1357 
1358     /**
1359      * @dev Returns the number of guardians for a wallet.
1360      * @param _wallet The target wallet.
1361      * @return the number of guardians.
1362      */
1363     function guardianCount(BaseWallet _wallet) external view returns (uint256) {
1364         return configs[address(_wallet)].guardians.length;
1365     }
1366     
1367     /**
1368      * @dev Gets the list of guaridans for a wallet.
1369      * @param _wallet The target wallet.
1370      * @return the list of guardians.
1371      */
1372     function getGuardians(BaseWallet _wallet) external view returns (address[] memory) {
1373         GuardianStorageConfig storage config = configs[address(_wallet)];
1374         address[] memory guardians = new address[](config.guardians.length);
1375         for (uint256 i = 0; i < config.guardians.length; i++) {
1376             guardians[i] = config.guardians[i];
1377         }
1378         return guardians;
1379     }
1380 
1381     /**
1382      * @dev Checks if an account is a guardian for a wallet.
1383      * @param _wallet The target wallet.
1384      * @param _guardian The account.
1385      * @return true if the account is a guardian for a wallet.
1386      */
1387     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
1388         return configs[address(_wallet)].info[_guardian].exists;
1389     }
1390 
1391     /**
1392      * @dev Lets an authorised module set the lock for a wallet.
1393      * @param _wallet The target wallet.
1394      * @param _releaseAfter The epoch time at which the lock should automatically release.
1395      */
1396     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
1397         configs[address(_wallet)].lock = _releaseAfter;
1398         if(_releaseAfter != 0 && msg.sender != configs[address(_wallet)].locker) {
1399             configs[address(_wallet)].locker = msg.sender;
1400         }
1401     }
1402 
1403     /**
1404      * @dev Checks if the lock is set for a wallet.
1405      * @param _wallet The target wallet.
1406      * @return true if the lock is set for the wallet.
1407      */
1408     function isLocked(BaseWallet _wallet) external view returns (bool) {
1409         return configs[address(_wallet)].lock > now;
1410     }
1411 
1412     /**
1413      * @dev Gets the time at which the lock of a wallet will release.
1414      * @param _wallet The target wallet.
1415      * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
1416      */
1417     function getLock(BaseWallet _wallet) external view returns (uint256) {
1418         return configs[address(_wallet)].lock;
1419     }
1420 
1421     /**
1422      * @dev Gets the address of the last module that modified the lock for a wallet.
1423      * @param _wallet The target wallet.
1424      * @return the address of the last module that modified the lock for a wallet.
1425      */
1426     function getLocker(BaseWallet _wallet) external view returns (address) {
1427         return configs[address(_wallet)].locker;
1428     }
1429 }
1430 
1431 
1432 /**
1433  * @title TransferStorage
1434  * @dev Contract storing the state of wallets related to transfers (limit and whitelist).
1435  * The contract only defines basic setters and getters with no logic. Only modules authorised
1436  * for a wallet can modify its state.
1437  * @author Julien Niset - <julien@argent.im>
1438  */
1439 contract TransferStorage is Storage {
1440 
1441     // wallet specific storage
1442     mapping (address => mapping (address => uint256)) internal whitelist;
1443 
1444     // *************** External Functions ********************* //
1445 
1446     /**
1447      * @dev Lets an authorised module add or remove an account from the whitelist of a wallet.
1448      * @param _wallet The target wallet.
1449      * @param _target The account to add/remove.
1450      * @param _value True for addition, false for revokation.
1451      */
1452     function setWhitelist(BaseWallet _wallet, address _target, uint256 _value) external onlyModule(_wallet) {
1453         whitelist[address(_wallet)][_target] = _value;
1454     }
1455 
1456     /**
1457      * @dev Gets the whitelist state of an account for a wallet.
1458      * @param _wallet The target wallet.
1459      * @param _target The account.
1460      * @return the epoch time at which an account strats to be whitelisted, or zero if the account is not whitelisted.
1461      */
1462     function getWhitelist(BaseWallet _wallet, address _target) external view returns (uint256) {
1463         return whitelist[address(_wallet)][_target];
1464     }
1465 }
1466 
1467 
1468 
1469 
1470 
1471 
1472 
1473 
1474 
1475 
1476 /**
1477  * @title TransferManager
1478  * @dev Module to transfer and approve tokens (ETH or ERC20) or data (contract call) based on a security context (daily limit, whitelist, etc).
1479  * This module is the V2 of TokenTransfer.
1480  * @author Julien Niset - <julien@argent.xyz>
1481  */
1482 contract TransferManager is BaseModule, RelayerModule, OnlyOwnerModule, BaseTransfer, LimitManager {
1483 
1484     bytes32 constant NAME = "TransferManager";
1485 
1486     bytes4 private constant ERC20_TRANSFER = bytes4(keccak256("transfer(address,uint256)"));
1487     bytes4 private constant ERC20_APPROVE = bytes4(keccak256("approve(address,uint256)"));
1488     bytes4 private constant ERC721_ISVALIDSIGNATURE_BYTES = bytes4(keccak256("isValidSignature(bytes,bytes)"));
1489     bytes4 private constant ERC721_ISVALIDSIGNATURE_BYTES32 = bytes4(keccak256("isValidSignature(bytes32,bytes)"));
1490 
1491     bytes constant internal EMPTY_BYTES = "";
1492 
1493     enum ActionType { Transfer }
1494 
1495     using SafeMath for uint256;
1496 
1497     // Mock token address for ETH
1498     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1499 
1500     struct TokenManagerConfig {
1501         // Mapping between pending action hash and their timestamp
1502         mapping (bytes32 => uint256) pendingActions;
1503     }
1504 
1505     // wallet specific storage
1506     mapping (address => TokenManagerConfig) internal configs;
1507 
1508     // The security period
1509     uint256 public securityPeriod;
1510     // The execution window
1511     uint256 public securityWindow;
1512     // The Guardian storage
1513     GuardianStorage public guardianStorage;
1514     // The Token storage
1515     TransferStorage public transferStorage;
1516     // The Token price provider
1517     TokenPriceProvider public priceProvider;
1518     // The previous limit manager needed to migrate the limits
1519     LimitManager public oldLimitManager;
1520 
1521     // *************** Events *************************** //
1522 
1523     // event Transfer(address indexed wallet, address indexed token, uint256 amount, address to, bytes data);
1524     // event Approved(address indexed wallet, address indexed token, uint256 amount, address spender);
1525     // event CalledContract(address indexed wallet, address indexed to, uint256 amount, bytes data);
1526     event AddedToWhitelist(address indexed wallet, address indexed target, uint64 whitelistAfter);
1527     event RemovedFromWhitelist(address indexed wallet, address indexed target);
1528     event PendingTransferCreated(address indexed wallet, bytes32 indexed id, uint256 indexed executeAfter, address token, address to, uint256 amount, bytes data);
1529     event PendingTransferExecuted(address indexed wallet, bytes32 indexed id);
1530     event PendingTransferCanceled(address indexed wallet, bytes32 indexed id);
1531 
1532     // *************** Modifiers *************************** //
1533 
1534     /**
1535      * @dev Throws if the wallet is locked.
1536      */
1537     modifier onlyWhenUnlocked(BaseWallet _wallet) {
1538         // solium-disable-next-line security/no-block-members
1539         require(!guardianStorage.isLocked(_wallet), "TT: wallet must be unlocked");
1540         _;
1541     }
1542 
1543     // *************** Constructor ********************** //
1544 
1545     constructor(
1546         ModuleRegistry _registry,
1547         TransferStorage _transferStorage,
1548         GuardianStorage _guardianStorage,
1549         address _priceProvider,
1550         uint256 _securityPeriod,
1551         uint256 _securityWindow,
1552         uint256 _defaultLimit,
1553         LimitManager _oldLimitManager
1554     )
1555         BaseModule(_registry, NAME)
1556         LimitManager(_defaultLimit)
1557         public
1558     {
1559         transferStorage = _transferStorage;
1560         guardianStorage = _guardianStorage;
1561         priceProvider = TokenPriceProvider(_priceProvider);
1562         securityPeriod = _securityPeriod;
1563         securityWindow = _securityWindow;
1564         oldLimitManager = _oldLimitManager;
1565     }
1566 
1567     /**
1568      * @dev Inits the module for a wallet by setting up the isValidSignature (EIP 1271)
1569      * static call redirection from the wallet to the module and copying all the parameters
1570      * of the daily limit from the previous implementation of the LimitManager module.
1571      * @param _wallet The target wallet.
1572      */
1573     function init(BaseWallet _wallet) public onlyWallet(_wallet) {
1574         // setup static calls
1575         _wallet.enableStaticCall(address(this), ERC721_ISVALIDSIGNATURE_BYTES);
1576         _wallet.enableStaticCall(address(this), ERC721_ISVALIDSIGNATURE_BYTES32);
1577         
1578         // setup default limit for new deployment
1579         if(address(oldLimitManager) == address(0)) {
1580             super.init(_wallet);
1581             return;
1582         }
1583         // get limit from previous LimitManager
1584         uint256 currentLimit = oldLimitManager.getCurrentLimit(_wallet);
1585         (uint256 pendingLimit, uint64 changeAfter) = oldLimitManager.getPendingLimit(_wallet);
1586         // setup default limit for new wallets
1587         if(currentLimit == 0 && changeAfter == 0) {
1588             super.init(_wallet);
1589             return;
1590         }
1591         // migrate existing limit for existing wallets
1592         if(currentLimit == pendingLimit) {
1593             limits[address(_wallet)].limit.current = uint128(currentLimit);
1594         }
1595         else {
1596             limits[address(_wallet)].limit = Limit(uint128(currentLimit), uint128(pendingLimit), changeAfter);
1597         }
1598         // migrate daily pending if we are within a rolling period
1599         (uint256 unspent, uint64 periodEnd) = oldLimitManager.getDailyUnspent(_wallet);
1600         if(periodEnd > now) {
1601             limits[address(_wallet)].dailySpent = DailySpent(uint128(currentLimit.sub(unspent)), periodEnd);
1602         }
1603     }
1604 
1605     // *************** External/Public Functions ********************* //
1606 
1607     /**
1608     * @dev lets the owner transfer tokens (ETH or ERC20) from a wallet.
1609     * @param _wallet The target wallet.
1610     * @param _token The address of the token to transfer.
1611     * @param _to The destination address
1612     * @param _amount The amoutn of token to transfer
1613     * @param _data The data for the transaction
1614     */
1615     function transferToken(
1616         BaseWallet _wallet,
1617         address _token,
1618         address _to,
1619         uint256 _amount,
1620         bytes calldata _data
1621     )
1622         external
1623         onlyWalletOwner(_wallet)
1624         onlyWhenUnlocked(_wallet)
1625     {
1626         if(isWhitelisted(_wallet, _to)) {
1627             // transfer to whitelist
1628             doTransfer(_wallet, _token, _to, _amount, _data);
1629         }
1630         else {
1631             uint256 etherAmount = (_token == ETH_TOKEN) ? _amount : priceProvider.getEtherValue(_amount, _token);
1632             if (checkAndUpdateDailySpent(_wallet, etherAmount)) {
1633                 // transfer under the limit
1634                 doTransfer(_wallet, _token, _to, _amount, _data);
1635             }
1636             else {
1637                 // transfer above the limit
1638                 (bytes32 id, uint256 executeAfter) = addPendingAction(ActionType.Transfer, _wallet, _token, _to, _amount, _data);
1639                 emit PendingTransferCreated(address(_wallet), id, executeAfter, _token, _to, _amount, _data);
1640             }
1641         }
1642     }
1643 
1644     /**
1645     * @dev lets the owner approve an allowance of ERC20 tokens for a spender (dApp).
1646     * @param _wallet The target wallet.
1647     * @param _token The address of the token to transfer.
1648     * @param _spender The address of the spender
1649     * @param _amount The amount of tokens to approve
1650     */
1651     function approveToken(
1652         BaseWallet _wallet,
1653         address _token,
1654         address _spender,
1655         uint256 _amount
1656     )
1657         external
1658         onlyWalletOwner(_wallet)
1659         onlyWhenUnlocked(_wallet)
1660     {
1661         if(isWhitelisted(_wallet, _spender)) {
1662             // approve to whitelist
1663             doApproveToken(_wallet, _token, _spender, _amount);
1664         }
1665         else {
1666             // get current alowance
1667             uint256 currentAllowance = ERC20(_token).allowance(address(_wallet), _spender);
1668             if(_amount <= currentAllowance) {
1669                 // approve if we reduce the allowance
1670                 doApproveToken(_wallet, _token, _spender, _amount);
1671             }
1672             else {
1673                 // check if delta is under the limit
1674                 uint delta = _amount - currentAllowance;
1675                 uint256 deltaInEth = priceProvider.getEtherValue(delta, _token);
1676                 require(checkAndUpdateDailySpent(_wallet, deltaInEth), "TM: Approve above daily limit");
1677                 // approve if under the limit
1678                 doApproveToken(_wallet, _token, _spender, _amount);
1679             }
1680         }
1681     }
1682 
1683     /**
1684     * @dev lets the owner call a contract.
1685     * @param _wallet The target wallet.
1686     * @param _contract The address of the contract.
1687     * @param _value The amount of ETH to transfer as part of call
1688     * @param _data The encoded method data
1689     */
1690     function callContract(
1691         BaseWallet _wallet,
1692         address _contract,
1693         uint256 _value,
1694         bytes calldata _data
1695     )
1696         external
1697         onlyWalletOwner(_wallet)
1698         onlyWhenUnlocked(_wallet)
1699     {
1700         // Make sure we don't call a module, the wallet itself, or an ERC20 method
1701         authoriseContractCall(_wallet, _contract, _data);
1702 
1703         if(isWhitelisted(_wallet, _contract)) {
1704             // call to whitelist
1705             doCallContract(_wallet, _contract, _value, _data);
1706         }
1707         else {
1708             require(checkAndUpdateDailySpent(_wallet, _value), "TM: Call contract above daily limit");
1709             // call under the limit
1710             doCallContract(_wallet, _contract, _value, _data);
1711         }
1712     }
1713 
1714     /**
1715     * @dev lets the owner do an ERC20 approve followed by a call to a contract.
1716     * We assume that the contract will pull the tokens and does not require ETH.
1717     * @param _wallet The target wallet.
1718     * @param _token The token to approve.
1719     * @param _contract The address of the contract.
1720     * @param _amount The amount of ERC20 tokens to approve.
1721     * @param _data The encoded method data
1722     */
1723     function approveTokenAndCallContract(
1724         BaseWallet _wallet,
1725         address _token,
1726         address _contract,
1727         uint256 _amount,
1728         bytes calldata _data
1729     )
1730         external
1731         onlyWalletOwner(_wallet)
1732         onlyWhenUnlocked(_wallet)
1733     {
1734         // Make sure we don't call a module, the wallet itself, or an ERC20 method
1735         authoriseContractCall(_wallet, _contract, _data);
1736 
1737         if(isWhitelisted(_wallet, _contract)) {
1738             doApproveToken(_wallet, _token, _contract, _amount);
1739             doCallContract(_wallet, _contract, 0, _data);
1740         }
1741         else {
1742             // get current alowance
1743             uint256 currentAllowance = ERC20(_token).allowance(address(_wallet), _contract);
1744             if(_amount <= currentAllowance) {
1745                 // no need to approve more
1746                 doCallContract(_wallet, _contract, 0, _data);
1747             }
1748             else {
1749                 // check if delta is under the limit
1750                 uint delta = _amount - currentAllowance;
1751                 uint256 deltaInEth = priceProvider.getEtherValue(delta, _token);
1752                 require(checkAndUpdateDailySpent(_wallet, deltaInEth), "TM: Approve above daily limit");
1753                 // approve if under the limit
1754                 doApproveToken(_wallet, _token, _contract, _amount);
1755                 doCallContract(_wallet, _contract, 0, _data);
1756             }
1757         }
1758     }
1759 
1760     /**
1761      * @dev Adds an address to the whitelist of a wallet.
1762      * @param _wallet The target wallet.
1763      * @param _target The address to add.
1764      */
1765     function addToWhitelist(
1766         BaseWallet _wallet,
1767         address _target
1768     )
1769         external
1770         onlyWalletOwner(_wallet)
1771         onlyWhenUnlocked(_wallet)
1772     {
1773         require(!isWhitelisted(_wallet, _target), "TT: target already whitelisted");
1774         // solium-disable-next-line security/no-block-members
1775         uint256 whitelistAfter = now.add(securityPeriod);
1776         transferStorage.setWhitelist(_wallet, _target, whitelistAfter);
1777         emit AddedToWhitelist(address(_wallet), _target, uint64(whitelistAfter));
1778     }
1779 
1780     /**
1781      * @dev Removes an address from the whitelist of a wallet.
1782      * @param _wallet The target wallet.
1783      * @param _target The address to remove.
1784      */
1785     function removeFromWhitelist(
1786         BaseWallet _wallet,
1787         address _target
1788     )
1789         external
1790         onlyWalletOwner(_wallet)
1791         onlyWhenUnlocked(_wallet)
1792     {
1793         require(isWhitelisted(_wallet, _target), "TT: target not whitelisted");
1794         transferStorage.setWhitelist(_wallet, _target, 0);
1795         emit RemovedFromWhitelist(address(_wallet), _target);
1796     }
1797 
1798     /**
1799     * @dev Executes a pending transfer for a wallet.
1800     * The method can be called by anyone to enable orchestration.
1801     * @param _wallet The target wallet.
1802     * @param _token The token of the pending transfer.
1803     * @param _to The destination address of the pending transfer.
1804     * @param _amount The amount of token to transfer of the pending transfer.
1805     * @param _data The data associated to the pending transfer.
1806     * @param _block The block at which the pending transfer was created.
1807     */
1808     function executePendingTransfer(
1809         BaseWallet _wallet,
1810         address _token,
1811         address _to,
1812         uint _amount,
1813         bytes memory _data,
1814         uint _block
1815     )
1816         public
1817         onlyWhenUnlocked(_wallet)
1818     {
1819         bytes32 id = keccak256(abi.encodePacked(ActionType.Transfer, _token, _to, _amount, _data, _block));
1820         uint executeAfter = configs[address(_wallet)].pendingActions[id];
1821         require(executeAfter > 0, "TT: unknown pending transfer");
1822         uint executeBefore = executeAfter.add(securityWindow);
1823         require(executeAfter <= now && now <= executeBefore, "TT: transfer outside of the execution window");
1824         delete configs[address(_wallet)].pendingActions[id];
1825         doTransfer(_wallet, _token, _to, _amount, _data);
1826         emit PendingTransferExecuted(address(_wallet), id);
1827     }
1828 
1829     function cancelPendingTransfer(
1830         BaseWallet _wallet,
1831         bytes32 _id
1832     )
1833         public
1834         onlyWalletOwner(_wallet)
1835         onlyWhenUnlocked(_wallet)
1836     {
1837         require(configs[address(_wallet)].pendingActions[_id] > 0, "TT: unknown pending action");
1838         delete configs[address(_wallet)].pendingActions[_id];
1839         emit PendingTransferCanceled(address(_wallet), _id);
1840     }
1841 
1842     /**
1843      * @dev Lets the owner of a wallet change its global limit.
1844      * The limit is expressed in ETH. Changes to the limit take 24 hours.
1845      * @param _wallet The target wallet.
1846      * @param _newLimit The new limit.
1847      */
1848     function changeLimit(BaseWallet _wallet, uint256 _newLimit) public onlyWalletOwner(_wallet) onlyWhenUnlocked(_wallet) {
1849         changeLimit(_wallet, _newLimit, securityPeriod);
1850     }
1851 
1852     /**
1853      * @dev Convenience method to disable the limit
1854      * The limit is disabled by setting it to an arbitrary large value.
1855      * @param _wallet The target wallet.
1856      */
1857     function disableLimit(BaseWallet _wallet) external onlyWalletOwner(_wallet) onlyWhenUnlocked(_wallet) {
1858         changeLimit(_wallet, LIMIT_DISABLED, securityPeriod);
1859     }
1860 
1861     /**
1862     * @dev Checks if an address is whitelisted for a wallet.
1863     * @param _wallet The target wallet.
1864     * @param _target The address.
1865     * @return true if the address is whitelisted.
1866     */
1867     function isWhitelisted(BaseWallet _wallet, address _target) public view returns (bool _isWhitelisted) {
1868         uint whitelistAfter = transferStorage.getWhitelist(_wallet, _target);
1869         // solium-disable-next-line security/no-block-members
1870         return whitelistAfter > 0 && whitelistAfter < now;
1871     }
1872 
1873     /**
1874     * @dev Gets the info of a pending transfer for a wallet.
1875     * @param _wallet The target wallet.
1876     * @param _id The pending transfer ID.
1877     * @return the epoch time at which the pending transfer can be executed.
1878     */
1879     function getPendingTransfer(BaseWallet _wallet, bytes32 _id) external view returns (uint64 _executeAfter) {
1880         _executeAfter = uint64(configs[address(_wallet)].pendingActions[_id]);
1881     }
1882 
1883     /**
1884     * @dev Implementation of EIP 1271.
1885     * Should return whether the signature provided is valid for the provided data.
1886     * @param _data Arbitrary length data signed on the behalf of address(this)
1887     * @param _signature Signature byte array associated with _data
1888     */
1889     function isValidSignature(bytes memory _data, bytes memory _signature) public view returns (bytes4) {
1890         bytes32 msgHash = keccak256(abi.encodePacked(_data));
1891         isValidSignature(msgHash, _signature);
1892         return ERC721_ISVALIDSIGNATURE_BYTES;
1893     }
1894 
1895     /**
1896     * @dev Implementation of EIP 1271.
1897     * Should return whether the signature provided is valid for the provided data.
1898     * @param _msgHash Hash of a message signed on the behalf of address(this)
1899     * @param _signature Signature byte array associated with _msgHash
1900     */
1901     function isValidSignature(bytes32 _msgHash, bytes memory _signature) public view returns (bytes4) {
1902         require(_signature.length == 65, "TM: invalid signature length");
1903         address signer = recoverSigner(_msgHash, _signature, 0);
1904         require(isOwner(BaseWallet(msg.sender), signer), "TM: Invalid signer");
1905         return ERC721_ISVALIDSIGNATURE_BYTES32;
1906     }
1907 
1908     // *************** Internal Functions ********************* //
1909 
1910     /**
1911      * @dev Creates a new pending action for a wallet.
1912      * @param _action The target action.
1913      * @param _wallet The target wallet.
1914      * @param _token The target token for the action.
1915      * @param _to The recipient of the action.
1916      * @param _amount The amount of token associated to the action.
1917      * @param _data The data associated to the action.
1918      * @return the identifier for the new pending action and the time when the action can be executed
1919      */
1920     function addPendingAction(
1921         ActionType _action,
1922         BaseWallet _wallet,
1923         address _token,
1924         address _to,
1925         uint _amount,
1926         bytes memory _data
1927     )
1928         internal
1929         returns (bytes32 id, uint256 executeAfter)
1930     {
1931         id = keccak256(abi.encodePacked(_action, _token, _to, _amount, _data, block.number));
1932         require(configs[address(_wallet)].pendingActions[id] == 0, "TM: duplicate pending action");
1933         executeAfter = now.add(securityPeriod);
1934         configs[address(_wallet)].pendingActions[id] = executeAfter;
1935     }
1936 
1937     /**
1938     * @dev Make sure a contract call is not trying to call a module, the wallet itself, or an ERC20 method.
1939     * @param _wallet The target wallet.
1940     * @param _contract The address of the contract.
1941     * @param _data The encoded method data
1942      */
1943     function authoriseContractCall(BaseWallet _wallet, address _contract, bytes memory _data) internal view {
1944         require(!_wallet.authorised(_contract) && _contract != address(_wallet), "TM: Forbidden contract");
1945         bytes4 methodId = functionPrefix(_data);
1946         require(methodId != ERC20_TRANSFER && methodId != ERC20_APPROVE, "TM: Forbidden method");
1947     }
1948 
1949     // *************** Implementation of RelayerModule methods ********************* //
1950 
1951     // Overrides refund to add the refund in the daily limit.
1952     function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
1953         // 21000 (transaction) + 7620 (execution of refund) + 7324 (execution of updateDailySpent) + 672 to log the event + _gasUsed
1954         uint256 amount = 36616 + _gasUsed;
1955         if(_gasPrice > 0 && _signatures > 0 && amount <= _gasLimit) {
1956             if(_gasPrice > tx.gasprice) {
1957                 amount = amount * tx.gasprice;
1958             }
1959             else {
1960                 amount = amount * _gasPrice;
1961             }
1962             updateDailySpent(_wallet, uint128(getCurrentLimit(_wallet)), amount);
1963             invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
1964         }
1965     }
1966 
1967     // Overrides verifyRefund to add the refund in the daily limit.
1968     function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
1969         if(_gasPrice > 0 && _signatures > 0 && (
1970             address(_wallet).balance < _gasUsed * _gasPrice
1971             || isWithinDailyLimit(_wallet, getCurrentLimit(_wallet), _gasUsed * _gasPrice) == false
1972             || _wallet.authorised(address(_wallet)) == false
1973         ))
1974         {
1975             return false;
1976         }
1977         return true;
1978     }
1979 }