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
361  * @title OnlyOwnerModule
362  * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
363  * must be called with one signature frm the owner.
364  * @author Julien Niset - <julien@argent.xyz>
365  */
366 contract OnlyOwnerModule is BaseModule, RelayerModule {
367 
368     // *************** Implementation of RelayerModule methods ********************* //
369 
370     // Overrides to use the incremental nonce and save some gas
371     function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
372         return checkAndUpdateNonce(_wallet, _nonce);
373     }
374 
375     function validateSignatures(BaseWallet _wallet, bytes _data, bytes32 _signHash, bytes _signatures) internal view returns (bool) {
376         address signer = recoverSigner(_signHash, _signatures, 0);
377         return isOwner(_wallet, signer); // "OOM: signer must be owner"
378     }
379 
380     function getRequiredSignatures(BaseWallet _wallet, bytes _data) internal view returns (uint256) {
381         return 1;
382     }
383 }
384 
385 /**
386  * ERC20 contract interface.
387  */
388 contract ERC20 {
389     function totalSupply() public view returns (uint);
390     function decimals() public view returns (uint);
391     function balanceOf(address tokenOwner) public view returns (uint balance);
392     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
393     function transfer(address to, uint tokens) public returns (bool success);
394     function approve(address spender, uint tokens) public returns (bool success);
395     function transferFrom(address from, address to, uint tokens) public returns (bool success);
396 }
397 
398 /**
399  * @title Owned
400  * @dev Basic contract to define an owner.
401  * @author Julien Niset - <julien@argent.xyz>
402  */
403 contract Owned {
404 
405     // The owner
406     address public owner;
407 
408     event OwnerChanged(address indexed _newOwner);
409 
410     /**
411      * @dev Throws if the sender is not the owner.
412      */
413     modifier onlyOwner {
414         require(msg.sender == owner, "Must be owner");
415         _;
416     }
417 
418     constructor() public {
419         owner = msg.sender;
420     }
421 
422     /**
423      * @dev Lets the owner transfer ownership of the contract to a new owner.
424      * @param _newOwner The new owner.
425      */
426     function changeOwner(address _newOwner) external onlyOwner {
427         require(_newOwner != address(0), "Address must not be null");
428         owner = _newOwner;
429         emit OwnerChanged(_newOwner);
430     }
431 }
432 
433 /**
434  * @title ModuleRegistry
435  * @dev Registry of authorised modules. 
436  * Modules must be registered before they can be authorised on a wallet.
437  * @author Julien Niset - <julien@argent.xyz>
438  */
439 contract ModuleRegistry is Owned {
440 
441     mapping (address => Info) internal modules;
442     mapping (address => Info) internal upgraders;
443 
444     event ModuleRegistered(address indexed module, bytes32 name);
445     event ModuleDeRegistered(address module);
446     event UpgraderRegistered(address indexed upgrader, bytes32 name);
447     event UpgraderDeRegistered(address upgrader);
448 
449     struct Info {
450         bool exists;
451         bytes32 name;
452     }
453 
454     /**
455      * @dev Registers a module.
456      * @param _module The module.
457      * @param _name The unique name of the module.
458      */
459     function registerModule(address _module, bytes32 _name) external onlyOwner {
460         require(!modules[_module].exists, "MR: module already exists");
461         modules[_module] = Info({exists: true, name: _name});
462         emit ModuleRegistered(_module, _name);
463     }
464 
465     /**
466      * @dev Deregisters a module.
467      * @param _module The module.
468      */
469     function deregisterModule(address _module) external onlyOwner {
470         require(modules[_module].exists, "MR: module does not exists");
471         delete modules[_module];
472         emit ModuleDeRegistered(_module);
473     }
474 
475         /**
476      * @dev Registers an upgrader.
477      * @param _upgrader The upgrader.
478      * @param _name The unique name of the upgrader.
479      */
480     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
481         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
482         upgraders[_upgrader] = Info({exists: true, name: _name});
483         emit UpgraderRegistered(_upgrader, _name);
484     }
485 
486     /**
487      * @dev Deregisters an upgrader.
488      * @param _upgrader The _upgrader.
489      */
490     function deregisterUpgrader(address _upgrader) external onlyOwner {
491         require(upgraders[_upgrader].exists, "MR: upgrader does not exists");
492         delete upgraders[_upgrader];
493         emit UpgraderDeRegistered(_upgrader);
494     }
495 
496     /**
497     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
498     * registry.
499     * @param _token The token to recover.
500     */
501     function recoverToken(address _token) external onlyOwner {
502         uint total = ERC20(_token).balanceOf(address(this));
503         ERC20(_token).transfer(msg.sender, total);
504     } 
505 
506     /**
507      * @dev Gets the name of a module from its address.
508      * @param _module The module address.
509      * @return the name.
510      */
511     function moduleInfo(address _module) external view returns (bytes32) {
512         return modules[_module].name;
513     }
514 
515     /**
516      * @dev Gets the name of an upgrader from its address.
517      * @param _upgrader The upgrader address.
518      * @return the name.
519      */
520     function upgraderInfo(address _upgrader) external view returns (bytes32) {
521         return upgraders[_upgrader].name;
522     }
523 
524     /**
525      * @dev Checks if a module is registered.
526      * @param _module The module address.
527      * @return true if the module is registered.
528      */
529     function isRegisteredModule(address _module) external view returns (bool) {
530         return modules[_module].exists;
531     }
532 
533     /**
534      * @dev Checks if a list of modules are registered.
535      * @param _modules The list of modules address.
536      * @return true if all the modules are registered.
537      */
538     function isRegisteredModule(address[] _modules) external view returns (bool) {
539         for(uint i = 0; i < _modules.length; i++) {
540             if (!modules[_modules[i]].exists) {
541                 return false;
542             }
543         }
544         return true;
545     }  
546 
547     /**
548      * @dev Checks if an upgrader is registered.
549      * @param _upgrader The upgrader address.
550      * @return true if the upgrader is registered.
551      */
552     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
553         return upgraders[_upgrader].exists;
554     } 
555 }
556 
557 /**
558  * @title BaseWallet
559  * @dev Simple modular wallet that authorises modules to call its invoke() method.
560  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
561  * @author Julien Niset - <julien@argent.xyz>
562  */
563 contract BaseWallet {
564 
565     // The implementation of the proxy
566     address public implementation;
567     // The owner 
568     address public owner;
569     // The authorised modules
570     mapping (address => bool) public authorised;
571     // The enabled static calls
572     mapping (bytes4 => address) public enabled;
573     // The number of modules
574     uint public modules;
575     
576     event AuthorisedModule(address indexed module, bool value);
577     event EnabledStaticCall(address indexed module, bytes4 indexed method);
578     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
579     event Received(uint indexed value, address indexed sender, bytes data);
580     event OwnerChanged(address owner);
581     
582     /**
583      * @dev Throws if the sender is not an authorised module.
584      */
585     modifier moduleOnly {
586         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
587         _;
588     }
589 
590     /**
591      * @dev Inits the wallet by setting the owner and authorising a list of modules.
592      * @param _owner The owner.
593      * @param _modules The modules to authorise.
594      */
595     function init(address _owner, address[] _modules) external {
596         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
597         require(_modules.length > 0, "BW: construction requires at least 1 module");
598         owner = _owner;
599         modules = _modules.length;
600         for(uint256 i = 0; i < _modules.length; i++) {
601             require(authorised[_modules[i]] == false, "BW: module is already added");
602             authorised[_modules[i]] = true;
603             Module(_modules[i]).init(this);
604             emit AuthorisedModule(_modules[i], true);
605         }
606     }
607     
608     /**
609      * @dev Enables/Disables a module.
610      * @param _module The target module.
611      * @param _value Set to true to authorise the module.
612      */
613     function authoriseModule(address _module, bool _value) external moduleOnly {
614         if (authorised[_module] != _value) {
615             if(_value == true) {
616                 modules += 1;
617                 authorised[_module] = true;
618                 Module(_module).init(this);
619             }
620             else {
621                 modules -= 1;
622                 require(modules > 0, "BW: wallet must have at least one module");
623                 delete authorised[_module];
624             }
625             emit AuthorisedModule(_module, _value);
626         }
627     }
628 
629     /**
630     * @dev Enables a static method by specifying the target module to which the call
631     * must be delegated.
632     * @param _module The target module.
633     * @param _method The static method signature.
634     */
635     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
636         require(authorised[_module], "BW: must be an authorised module for static call");
637         enabled[_method] = _module;
638         emit EnabledStaticCall(_module, _method);
639     }
640 
641     /**
642      * @dev Sets a new owner for the wallet.
643      * @param _newOwner The new owner.
644      */
645     function setOwner(address _newOwner) external moduleOnly {
646         require(_newOwner != address(0), "BW: address cannot be null");
647         owner = _newOwner;
648         emit OwnerChanged(_newOwner);
649     }
650     
651     /**
652      * @dev Performs a generic transaction.
653      * @param _target The address for the transaction.
654      * @param _value The value of the transaction.
655      * @param _data The data of the transaction.
656      */
657     function invoke(address _target, uint _value, bytes _data) external moduleOnly {
658         // solium-disable-next-line security/no-call-value
659         require(_target.call.value(_value)(_data), "BW: call to target failed");
660         emit Invoked(msg.sender, _target, _value, _data);
661     }
662 
663     /**
664      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
665      * implement specific static methods. It delegates the static call to a target contract if the data corresponds 
666      * to an enabled method, or logs the call otherwise.
667      */
668     function() public payable {
669         if(msg.data.length > 0) { 
670             address module = enabled[msg.sig];
671             if(module == address(0)) {
672                 emit Received(msg.value, msg.sender, msg.data);
673             } 
674             else {
675                 require(authorised[module], "BW: must be an authorised module for static call");
676                 // solium-disable-next-line security/no-inline-assembly
677                 assembly {
678                     calldatacopy(0, 0, calldatasize())
679                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
680                     returndatacopy(0, 0, returndatasize())
681                     switch result 
682                     case 0 {revert(0, returndatasize())} 
683                     default {return (0, returndatasize())}
684                 }
685             }
686         }
687     }
688 }
689 
690 /* The MIT License (MIT)
691 
692 Copyright (c) 2016 Smart Contract Solutions, Inc.
693 
694 Permission is hereby granted, free of charge, to any person obtaining
695 a copy of this software and associated documentation files (the
696 "Software"), to deal in the Software without restriction, including
697 without limitation the rights to use, copy, modify, merge, publish,
698 distribute, sublicense, and/or sell copies of the Software, and to
699 permit persons to whom the Software is furnished to do so, subject to
700 the following conditions:
701 
702 The above copyright notice and this permission notice shall be included
703 in all copies or substantial portions of the Software.
704 
705 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
706 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
707 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
708 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
709 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
710 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
711 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
712 /**
713  * @title SafeMath
714  * @dev Math operations with safety checks that throw on error
715  */
716 library SafeMath {
717 
718     /**
719     * @dev Multiplies two numbers, reverts on overflow.
720     */
721     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
722         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
723         // benefit is lost if 'b' is also tested.
724         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
725         if (a == 0) {
726             return 0;
727         }
728 
729         uint256 c = a * b;
730         require(c / a == b);
731 
732         return c;
733     }
734 
735     /**
736     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
737     */
738     function div(uint256 a, uint256 b) internal pure returns (uint256) {
739         require(b > 0); // Solidity only automatically asserts when dividing by 0
740         uint256 c = a / b;
741         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
742 
743         return c;
744     }
745 
746     /**
747     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
748     */
749     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
750         require(b <= a);
751         uint256 c = a - b;
752 
753         return c;
754     }
755 
756     /**
757     * @dev Adds two numbers, reverts on overflow.
758     */
759     function add(uint256 a, uint256 b) internal pure returns (uint256) {
760         uint256 c = a + b;
761         require(c >= a);
762 
763         return c;
764     }
765 
766     /**
767     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
768     * reverts when dividing by zero.
769     */
770     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
771         require(b != 0);
772         return a % b;
773     }
774 
775     /**
776     * @dev Returns ceil(a / b).
777     */
778     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
779         uint256 c = a / b;
780         if(a % b == 0) {
781             return c;
782         }
783         else {
784             return c + 1;
785         }
786     }
787 }
788 
789 contract KyberNetwork {
790 
791     function getExpectedRate(
792         ERC20 src,
793         ERC20 dest,
794         uint srcQty
795     )
796         public
797         view
798         returns (uint expectedRate, uint slippageRate);
799 
800     function trade(
801         ERC20 src,
802         uint srcAmount,
803         ERC20 dest,
804         address destAddress,
805         uint maxDestAmount,
806         uint minConversionRate,
807         address walletId
808     )
809         public
810         payable
811         returns(uint);
812 }
813 
814 /**
815  * @title Storage
816  * @dev Base contract for the storage of a wallet.
817  * @author Julien Niset - <julien@argent.xyz>
818  */
819 contract Storage {
820 
821     /**
822      * @dev Throws if the caller is not an authorised module.
823      */
824     modifier onlyModule(BaseWallet _wallet) {
825         require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
826         _;
827     }
828 }
829 
830 /**
831  * @title GuardianStorage
832  * @dev Contract storing the state of wallets related to guardians and lock.
833  * The contract only defines basic setters and getters with no logic. Only modules authorised
834  * for a wallet can modify its state.
835  * @author Julien Niset - <julien@argent.xyz>
836  * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
837  */
838 contract GuardianStorage is Storage {
839 
840     struct GuardianStorageConfig {
841         // the list of guardians
842         address[] guardians;
843         // the info about guardians
844         mapping (address => GuardianInfo) info;
845         // the lock's release timestamp
846         uint256 lock; 
847         // the module that set the last lock
848         address locker;
849     }
850 
851     struct GuardianInfo {
852         bool exists;
853         uint128 index;
854     }
855 
856     // wallet specific storage
857     mapping (address => GuardianStorageConfig) internal configs;
858 
859     // *************** External Functions ********************* //
860 
861     /**
862      * @dev Lets an authorised module add a guardian to a wallet.
863      * @param _wallet The target wallet.
864      * @param _guardian The guardian to add.
865      */
866     function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
867         GuardianStorageConfig storage config = configs[_wallet];
868         config.info[_guardian].exists = true;
869         config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
870     }
871 
872     /**
873      * @dev Lets an authorised module revoke a guardian from a wallet.
874      * @param _wallet The target wallet.
875      * @param _guardian The guardian to revoke.
876      */
877     function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
878         GuardianStorageConfig storage config = configs[_wallet];
879         address lastGuardian = config.guardians[config.guardians.length - 1];
880         if (_guardian != lastGuardian) {
881             uint128 targetIndex = config.info[_guardian].index;
882             config.guardians[targetIndex] = lastGuardian;
883             config.info[lastGuardian].index = targetIndex;
884         }
885         config.guardians.length--;
886         delete config.info[_guardian];
887     }
888 
889     /**
890      * @dev Returns the number of guardians for a wallet.
891      * @param _wallet The target wallet.
892      * @return the number of guardians.
893      */
894     function guardianCount(BaseWallet _wallet) external view returns (uint256) {
895         return configs[_wallet].guardians.length;
896     }
897     
898     /**
899      * @dev Gets the list of guaridans for a wallet.
900      * @param _wallet The target wallet.
901      * @return the list of guardians.
902      */
903     function getGuardians(BaseWallet _wallet) external view returns (address[]) {
904         GuardianStorageConfig storage config = configs[_wallet];
905         address[] memory guardians = new address[](config.guardians.length);
906         for (uint256 i = 0; i < config.guardians.length; i++) {
907             guardians[i] = config.guardians[i];
908         }
909         return guardians;
910     }
911 
912     /**
913      * @dev Checks if an account is a guardian for a wallet.
914      * @param _wallet The target wallet.
915      * @param _guardian The account.
916      * @return true if the account is a guardian for a wallet.
917      */
918     function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
919         return configs[_wallet].info[_guardian].exists;
920     }
921 
922     /**
923      * @dev Lets an authorised module set the lock for a wallet.
924      * @param _wallet The target wallet.
925      * @param _releaseAfter The epoch time at which the lock should automatically release.
926      */
927     function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
928         configs[_wallet].lock = _releaseAfter;
929         if(_releaseAfter != 0 && msg.sender != configs[_wallet].locker) {
930             configs[_wallet].locker = msg.sender;
931         }
932     }
933 
934     /**
935      * @dev Checks if the lock is set for a wallet.
936      * @param _wallet The target wallet.
937      * @return true if the lock is set for the wallet.
938      */
939     function isLocked(BaseWallet _wallet) external view returns (bool) {
940         return configs[_wallet].lock > now;
941     }
942 
943     /**
944      * @dev Gets the time at which the lock of a wallet will release.
945      * @param _wallet The target wallet.
946      * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
947      */
948     function getLock(BaseWallet _wallet) external view returns (uint256) {
949         return configs[_wallet].lock;
950     }
951 
952     /**
953      * @dev Gets the address of the last module that modified the lock for a wallet.
954      * @param _wallet The target wallet.
955      * @return the address of the last module that modified the lock for a wallet.
956      */
957     function getLocker(BaseWallet _wallet) external view returns (address) {
958         return configs[_wallet].locker;
959     }
960 }
961 
962 /**
963  * @title TokenExchanger
964  * @dev Module to trade tokens (ETH or ERC20) using KyberNetworks.
965  * @author Julien Niset - <julien@argent.xyz>
966  */
967 contract TokenExchanger is BaseModule, RelayerModule, OnlyOwnerModule {
968 
969     bytes32 constant NAME = "TokenExchanger";
970 
971     using SafeMath for uint256;
972 
973     // Mock token address for ETH
974     address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
975 
976     // The address of the KyberNetwork proxy contract
977     address public kyber;
978     // The address of the contract collecting fees for Argent.
979     address public feeCollector;
980     // The Argent fee in 1-per-10000.
981     uint256 public feeRatio;
982     // The Guardian storage 
983     GuardianStorage public guardianStorage;
984 
985     event TokenExchanged(address indexed wallet, address srcToken, uint srcAmount, address destToken, uint destAmount);
986 
987     /**
988      * @dev Throws if the wallet is locked.
989      */
990     modifier onlyWhenUnlocked(BaseWallet _wallet) {
991         // solium-disable-next-line security/no-block-members
992         require(!guardianStorage.isLocked(_wallet), "TT: wallet must be unlocked");
993         _;
994     }
995 
996     constructor(
997         ModuleRegistry _registry, 
998         GuardianStorage _guardianStorage, 
999         address _kyber, 
1000         address _feeCollector, 
1001         uint _feeRatio
1002     ) 
1003         BaseModule(_registry, NAME) 
1004         public 
1005     {
1006         kyber = _kyber;
1007         feeCollector = _feeCollector;
1008         feeRatio = _feeRatio;
1009         guardianStorage = _guardianStorage;
1010     }
1011 
1012     /**
1013      * @dev Lets the owner of the wallet execute a trade.
1014      * @param _wallet The target wallet
1015      * @param _srcToken The address of the source token.
1016      * @param _srcAmount The amoutn of source token to trade.
1017      * @param _destToken The address of the destination token.
1018      * @param _maxDestAmount The maximum amount of destination token accepted for the trade.
1019      * @param _minConversionRate The minimum accepted rate for the trade.
1020      * @return The amount of destination tokens that have been received.
1021      */
1022     function trade(
1023         BaseWallet _wallet,
1024         address _srcToken,
1025         uint256 _srcAmount,
1026         address _destToken,
1027         uint256 _maxDestAmount,
1028         uint256 _minConversionRate
1029     )
1030         external 
1031         onlyOwner(_wallet)
1032         onlyWhenUnlocked(_wallet)
1033         returns(uint256)
1034     {    
1035         bytes memory methodData;
1036         require(_srcToken == ETH_TOKEN_ADDRESS || _destToken == ETH_TOKEN_ADDRESS, "TE: source or destination must be ETH");
1037         (uint256 destAmount, uint256 fee, ) = getExpectedTrade(_srcToken, _destToken, _srcAmount);
1038         if(destAmount > _maxDestAmount) {
1039             fee = fee.mul(_maxDestAmount).div(destAmount);
1040             destAmount = _maxDestAmount;
1041         }
1042         if(_srcToken == ETH_TOKEN_ADDRESS) {
1043             uint256 srcTradable = _srcAmount.sub(fee);
1044             methodData = abi.encodeWithSignature(
1045                 "trade(address,uint256,address,address,uint256,uint256,address)", 
1046                 _srcToken, 
1047                 srcTradable,
1048                 _destToken,
1049                 address(_wallet),
1050                 _maxDestAmount,
1051                 _minConversionRate,
1052                 feeCollector
1053                 );
1054             _wallet.invoke(kyber, srcTradable, methodData);
1055         }
1056         else {
1057             // approve kyber on erc20 
1058             methodData = abi.encodeWithSignature("approve(address,uint256)", kyber, _srcAmount);
1059             _wallet.invoke(_srcToken, 0, methodData);
1060             // transfer erc20
1061             methodData = abi.encodeWithSignature(
1062                 "trade(address,uint256,address,address,uint256,uint256,address)", 
1063                 _srcToken, 
1064                 _srcAmount,
1065                 _destToken,
1066                 address(_wallet),
1067                 _maxDestAmount,
1068                 _minConversionRate,
1069                 feeCollector
1070                 );
1071             _wallet.invoke(kyber, 0, methodData);
1072         }
1073 
1074         if (fee > 0) {
1075             _wallet.invoke(feeCollector, fee, "");
1076         }
1077         emit TokenExchanged(_wallet, _srcToken, _srcAmount, _destToken, destAmount);
1078         return destAmount;
1079     }
1080 
1081     /**
1082      * @dev Gets the expected terms of a trade.
1083      * @param _srcToken The address of the source token.
1084      * @param _destToken The address of the destination token.
1085      * @param _srcAmount The amount of source token to trade.
1086      * @return the amount of destination tokens to be received and the amount of ETH paid to Argent as fee.
1087      */
1088     function getExpectedTrade(
1089         address _srcToken,
1090         address _destToken,
1091         uint256 _srcAmount
1092     )
1093         public
1094         view
1095         returns(uint256 _destAmount, uint256 _fee, uint256 _expectedRate)
1096     {
1097         if(_srcToken == ETH_TOKEN_ADDRESS) {
1098             _fee = computeFee(_srcAmount);
1099             (_expectedRate,) = KyberNetwork(kyber).getExpectedRate(ERC20(_srcToken), ERC20(_destToken), _srcAmount.sub(_fee));  
1100             uint256 destDecimals = ERC20(_destToken).decimals();
1101             // destAmount = expectedRate * (_srcAmount - fee) / ETH_PRECISION * (DEST_PRECISION / SRC_PRECISION)
1102             _destAmount = _expectedRate.mul(_srcAmount.sub(_fee)).div(10 ** (36-destDecimals));
1103         }
1104         else {
1105             (_expectedRate,) = KyberNetwork(kyber).getExpectedRate(ERC20(_srcToken), ERC20(_destToken), _srcAmount);
1106             uint256 srcDecimals = ERC20(_srcToken).decimals();
1107             // destAmount = expectedRate * _srcAmount / ETH_PRECISION * (DEST_PRECISION / SRC_PRECISION) - fee
1108             _destAmount = _expectedRate.mul(_srcAmount).div(10 ** srcDecimals);
1109             _fee = computeFee(_destAmount);
1110             _destAmount -= _fee;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Computes the Argent fee based on the amount of source tokens in ETH.
1116      * @param _srcAmount The amount of source token to trade in ETH.
1117      * @return the fee paid to Argent.
1118      */
1119     function computeFee(uint256 _srcAmount) internal view returns (uint256 fee) {
1120         fee = (_srcAmount * feeRatio) / 10000;
1121     }
1122 }