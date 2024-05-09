1 pragma solidity 0.4.24;
2 // File: @aragon/os/contracts/common/UnstructuredStorage.sol
3 /*
4  * SPDX-License-Identitifer:    MIT
5  */
6 
7 pragma solidity ^0.4.24;
8 
9 
10 library UnstructuredStorage {
11     function getStorageBool(bytes32 position) internal view returns (bool data) {
12         assembly { data := sload(position) }
13     }
14 
15     function getStorageAddress(bytes32 position) internal view returns (address data) {
16         assembly { data := sload(position) }
17     }
18 
19     function getStorageBytes32(bytes32 position) internal view returns (bytes32 data) {
20         assembly { data := sload(position) }
21     }
22 
23     function getStorageUint256(bytes32 position) internal view returns (uint256 data) {
24         assembly { data := sload(position) }
25     }
26 
27     function setStorageBool(bytes32 position, bool data) internal {
28         assembly { sstore(position, data) }
29     }
30 
31     function setStorageAddress(bytes32 position, address data) internal {
32         assembly { sstore(position, data) }
33     }
34 
35     function setStorageBytes32(bytes32 position, bytes32 data) internal {
36         assembly { sstore(position, data) }
37     }
38 
39     function setStorageUint256(bytes32 position, uint256 data) internal {
40         assembly { sstore(position, data) }
41     }
42 }
43 // File: @aragon/os/contracts/acl/IACL.sol
44 /*
45  * SPDX-License-Identitifer:    MIT
46  */
47 
48 pragma solidity ^0.4.24;
49 
50 
51 interface IACL {
52     function initialize(address permissionsCreator) external;
53 
54     // TODO: this should be external
55     // See https://github.com/ethereum/solidity/issues/4832
56     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
57 }
58 // File: @aragon/os/contracts/common/IVaultRecoverable.sol
59 /*
60  * SPDX-License-Identitifer:    MIT
61  */
62 
63 pragma solidity ^0.4.24;
64 
65 
66 interface IVaultRecoverable {
67     function transferToVault(address token) external;
68 
69     function allowRecoverability(address token) external view returns (bool);
70     function getRecoveryVault() external view returns (address);
71 }
72 // File: @aragon/os/contracts/kernel/IKernel.sol
73 /*
74  * SPDX-License-Identitifer:    MIT
75  */
76 
77 pragma solidity ^0.4.24;
78 
79 
80 
81 
82 // This should be an interface, but interfaces can't inherit yet :(
83 contract IKernel is IVaultRecoverable {
84     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
85 
86     function acl() public view returns (IACL);
87     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
88 
89     function setApp(bytes32 namespace, bytes32 appId, address app) public;
90     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
91 }
92 // File: @aragon/os/contracts/apps/AppStorage.sol
93 /*
94  * SPDX-License-Identitifer:    MIT
95  */
96 
97 pragma solidity ^0.4.24;
98 
99 
100 
101 
102 contract AppStorage {
103     using UnstructuredStorage for bytes32;
104 
105     /* Hardcoded constants to save gas
106     bytes32 internal constant KERNEL_POSITION = keccak256("aragonOS.appStorage.kernel");
107     bytes32 internal constant APP_ID_POSITION = keccak256("aragonOS.appStorage.appId");
108     */
109     bytes32 internal constant KERNEL_POSITION = 0x4172f0f7d2289153072b0a6ca36959e0cbe2efc3afe50fc81636caa96338137b;
110     bytes32 internal constant APP_ID_POSITION = 0xd625496217aa6a3453eecb9c3489dc5a53e6c67b444329ea2b2cbc9ff547639b;
111 
112     function kernel() public view returns (IKernel) {
113         return IKernel(KERNEL_POSITION.getStorageAddress());
114     }
115 
116     function appId() public view returns (bytes32) {
117         return APP_ID_POSITION.getStorageBytes32();
118     }
119 
120     function setKernel(IKernel _kernel) internal {
121         KERNEL_POSITION.setStorageAddress(address(_kernel));
122     }
123 
124     function setAppId(bytes32 _appId) internal {
125         APP_ID_POSITION.setStorageBytes32(_appId);
126     }
127 }
128 // File: @aragon/os/contracts/common/Uint256Helpers.sol
129 library Uint256Helpers {
130     uint256 private constant MAX_UINT64 = uint64(-1);
131 
132     string private constant ERROR_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
133 
134     function toUint64(uint256 a) internal pure returns (uint64) {
135         require(a <= MAX_UINT64, ERROR_NUMBER_TOO_BIG);
136         return uint64(a);
137     }
138 }
139 // File: @aragon/os/contracts/common/TimeHelpers.sol
140 /*
141  * SPDX-License-Identitifer:    MIT
142  */
143 
144 pragma solidity ^0.4.24;
145 
146 
147 
148 contract TimeHelpers {
149     using Uint256Helpers for uint256;
150 
151     /**
152     * @dev Returns the current block number.
153     *      Using a function rather than `block.number` allows us to easily mock the block number in
154     *      tests.
155     */
156     function getBlockNumber() internal view returns (uint256) {
157         return block.number;
158     }
159 
160     /**
161     * @dev Returns the current block number, converted to uint64.
162     *      Using a function rather than `block.number` allows us to easily mock the block number in
163     *      tests.
164     */
165     function getBlockNumber64() internal view returns (uint64) {
166         return getBlockNumber().toUint64();
167     }
168 
169     /**
170     * @dev Returns the current timestamp.
171     *      Using a function rather than `block.timestamp` allows us to easily mock it in
172     *      tests.
173     */
174     function getTimestamp() internal view returns (uint256) {
175         return block.timestamp; // solium-disable-line security/no-block-members
176     }
177 
178     /**
179     * @dev Returns the current timestamp, converted to uint64.
180     *      Using a function rather than `block.timestamp` allows us to easily mock it in
181     *      tests.
182     */
183     function getTimestamp64() internal view returns (uint64) {
184         return getTimestamp().toUint64();
185     }
186 }
187 // File: @aragon/os/contracts/common/Initializable.sol
188 /*
189  * SPDX-License-Identitifer:    MIT
190  */
191 
192 pragma solidity ^0.4.24;
193 
194 
195 
196 
197 contract Initializable is TimeHelpers {
198     using UnstructuredStorage for bytes32;
199 
200     // keccak256("aragonOS.initializable.initializationBlock")
201     bytes32 internal constant INITIALIZATION_BLOCK_POSITION = 0xebb05b386a8d34882b8711d156f463690983dc47815980fb82aeeff1aa43579e;
202 
203     string private constant ERROR_ALREADY_INITIALIZED = "INIT_ALREADY_INITIALIZED";
204     string private constant ERROR_NOT_INITIALIZED = "INIT_NOT_INITIALIZED";
205 
206     modifier onlyInit {
207         require(getInitializationBlock() == 0, ERROR_ALREADY_INITIALIZED);
208         _;
209     }
210 
211     modifier isInitialized {
212         require(hasInitialized(), ERROR_NOT_INITIALIZED);
213         _;
214     }
215 
216     /**
217     * @return Block number in which the contract was initialized
218     */
219     function getInitializationBlock() public view returns (uint256) {
220         return INITIALIZATION_BLOCK_POSITION.getStorageUint256();
221     }
222 
223     /**
224     * @return Whether the contract has been initialized by the time of the current block
225     */
226     function hasInitialized() public view returns (bool) {
227         uint256 initializationBlock = getInitializationBlock();
228         return initializationBlock != 0 && getBlockNumber() >= initializationBlock;
229     }
230 
231     /**
232     * @dev Function to be called by top level contract after initialization has finished.
233     */
234     function initialized() internal onlyInit {
235         INITIALIZATION_BLOCK_POSITION.setStorageUint256(getBlockNumber());
236     }
237 
238     /**
239     * @dev Function to be called by top level contract after initialization to enable the contract
240     *      at a future block number rather than immediately.
241     */
242     function initializedAt(uint256 _blockNumber) internal onlyInit {
243         INITIALIZATION_BLOCK_POSITION.setStorageUint256(_blockNumber);
244     }
245 }
246 // File: @aragon/os/contracts/common/Petrifiable.sol
247 /*
248  * SPDX-License-Identitifer:    MIT
249  */
250 
251 pragma solidity ^0.4.24;
252 
253 
254 
255 contract Petrifiable is Initializable {
256     // Use block UINT256_MAX (which should be never) as the initializable date
257     uint256 internal constant PETRIFIED_BLOCK = uint256(-1);
258 
259     function isPetrified() public view returns (bool) {
260         return getInitializationBlock() == PETRIFIED_BLOCK;
261     }
262 
263     /**
264     * @dev Function to be called by top level contract to prevent being initialized.
265     *      Useful for freezing base contracts when they're used behind proxies.
266     */
267     function petrify() internal onlyInit {
268         initializedAt(PETRIFIED_BLOCK);
269     }
270 }
271 // File: @aragon/os/contracts/common/Autopetrified.sol
272 /*
273  * SPDX-License-Identitifer:    MIT
274  */
275 
276 pragma solidity ^0.4.24;
277 
278 
279 
280 contract Autopetrified is Petrifiable {
281     constructor() public {
282         // Immediately petrify base (non-proxy) instances of inherited contracts on deploy.
283         // This renders them uninitializable (and unusable without a proxy).
284         petrify();
285     }
286 }
287 // File: @aragon/os/contracts/lib/token/ERC20.sol
288 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/a9f910d34f0ab33a1ae5e714f69f9596a02b4d91/contracts/token/ERC20/ERC20.sol
289 
290 pragma solidity ^0.4.24;
291 
292 
293 /**
294  * @title ERC20 interface
295  * @dev see https://github.com/ethereum/EIPs/issues/20
296  */
297 contract ERC20 {
298     function totalSupply() public view returns (uint256);
299 
300     function balanceOf(address _who) public view returns (uint256);
301 
302     function allowance(address _owner, address _spender)
303         public view returns (uint256);
304 
305     function transfer(address _to, uint256 _value) public returns (bool);
306 
307     function approve(address _spender, uint256 _value)
308         public returns (bool);
309 
310     function transferFrom(address _from, address _to, uint256 _value)
311         public returns (bool);
312 
313     event Transfer(
314         address indexed from,
315         address indexed to,
316         uint256 value
317     );
318 
319     event Approval(
320         address indexed owner,
321         address indexed spender,
322         uint256 value
323     );
324 }
325 // File: @aragon/os/contracts/common/EtherTokenConstant.sol
326 /*
327  * SPDX-License-Identitifer:    MIT
328  */
329 
330 pragma solidity ^0.4.24;
331 
332 
333 // aragonOS and aragon-apps rely on address(0) to denote native ETH, in
334 // contracts where both tokens and ETH are accepted
335 contract EtherTokenConstant {
336     address internal constant ETH = address(0);
337 }
338 // File: @aragon/os/contracts/common/IsContract.sol
339 /*
340  * SPDX-License-Identitifer:    MIT
341  */
342 
343 pragma solidity ^0.4.24;
344 
345 
346 contract IsContract {
347     /*
348     * NOTE: this should NEVER be used for authentication
349     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
350     *
351     * This is only intended to be used as a sanity check that an address is actually a contract,
352     * RATHER THAN an address not being a contract.
353     */
354     function isContract(address _target) internal view returns (bool) {
355         if (_target == address(0)) {
356             return false;
357         }
358 
359         uint256 size;
360         assembly { size := extcodesize(_target) }
361         return size > 0;
362     }
363 }
364 // File: @aragon/os/contracts/common/VaultRecoverable.sol
365 /*
366  * SPDX-License-Identitifer:    MIT
367  */
368 
369 pragma solidity ^0.4.24;
370 
371 
372 
373 
374 
375 
376 contract VaultRecoverable is IVaultRecoverable, EtherTokenConstant, IsContract {
377     string private constant ERROR_DISALLOWED = "RECOVER_DISALLOWED";
378     string private constant ERROR_VAULT_NOT_CONTRACT = "RECOVER_VAULT_NOT_CONTRACT";
379 
380     /**
381      * @notice Send funds to recovery Vault. This contract should never receive funds,
382      *         but in case it does, this function allows one to recover them.
383      * @param _token Token balance to be sent to recovery vault.
384      */
385     function transferToVault(address _token) external {
386         require(allowRecoverability(_token), ERROR_DISALLOWED);
387         address vault = getRecoveryVault();
388         require(isContract(vault), ERROR_VAULT_NOT_CONTRACT);
389 
390         if (_token == ETH) {
391             vault.transfer(address(this).balance);
392         } else {
393             uint256 amount = ERC20(_token).balanceOf(this);
394             ERC20(_token).transfer(vault, amount);
395         }
396     }
397 
398     /**
399     * @dev By default deriving from AragonApp makes it recoverable
400     * @param token Token address that would be recovered
401     * @return bool whether the app allows the recovery
402     */
403     function allowRecoverability(address token) public view returns (bool) {
404         return true;
405     }
406 
407     // Cast non-implemented interface to be public so we can use it internally
408     function getRecoveryVault() public view returns (address);
409 }
410 // File: @aragon/os/contracts/evmscript/IEVMScriptExecutor.sol
411 /*
412  * SPDX-License-Identitifer:    MIT
413  */
414 
415 pragma solidity ^0.4.24;
416 
417 
418 interface IEVMScriptExecutor {
419     function execScript(bytes script, bytes input, address[] blacklist) external returns (bytes);
420     function executorType() external pure returns (bytes32);
421 }
422 // File: @aragon/os/contracts/evmscript/IEVMScriptRegistry.sol
423 /*
424  * SPDX-License-Identitifer:    MIT
425  */
426 
427 pragma solidity ^0.4.24;
428 
429 
430 
431 contract EVMScriptRegistryConstants {
432     /* Hardcoded constants to save gas
433     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = apmNamehash("evmreg");
434     */
435     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = 0xddbcfd564f642ab5627cf68b9b7d374fb4f8a36e941a75d89c87998cef03bd61;
436 }
437 
438 
439 interface IEVMScriptRegistry {
440     function addScriptExecutor(IEVMScriptExecutor executor) external returns (uint id);
441     function disableScriptExecutor(uint256 executorId) external;
442 
443     // TODO: this should be external
444     // See https://github.com/ethereum/solidity/issues/4832
445     function getScriptExecutor(bytes script) public view returns (IEVMScriptExecutor);
446 }
447 // File: @aragon/os/contracts/kernel/KernelConstants.sol
448 /*
449  * SPDX-License-Identitifer:    MIT
450  */
451 
452 pragma solidity ^0.4.24;
453 
454 
455 contract KernelAppIds {
456     /* Hardcoded constants to save gas
457     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
458     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
459     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
460     */
461     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
462     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
463     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
464 }
465 
466 
467 contract KernelNamespaceConstants {
468     /* Hardcoded constants to save gas
469     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
470     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
471     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
472     */
473     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
474     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
475     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
476 }
477 // File: @aragon/os/contracts/evmscript/EVMScriptRunner.sol
478 /*
479  * SPDX-License-Identitifer:    MIT
480  */
481 
482 pragma solidity ^0.4.24;
483 
484 
485 
486 
487 
488 
489 
490 contract EVMScriptRunner is AppStorage, Initializable, EVMScriptRegistryConstants, KernelNamespaceConstants {
491     string private constant ERROR_EXECUTOR_UNAVAILABLE = "EVMRUN_EXECUTOR_UNAVAILABLE";
492     string private constant ERROR_EXECUTION_REVERTED = "EVMRUN_EXECUTION_REVERTED";
493     string private constant ERROR_PROTECTED_STATE_MODIFIED = "EVMRUN_PROTECTED_STATE_MODIFIED";
494 
495     event ScriptResult(address indexed executor, bytes script, bytes input, bytes returnData);
496 
497     function getEVMScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
498         return IEVMScriptExecutor(getEVMScriptRegistry().getScriptExecutor(_script));
499     }
500 
501     function getEVMScriptRegistry() public view returns (IEVMScriptRegistry) {
502         address registryAddr = kernel().getApp(KERNEL_APP_ADDR_NAMESPACE, EVMSCRIPT_REGISTRY_APP_ID);
503         return IEVMScriptRegistry(registryAddr);
504     }
505 
506     function runScript(bytes _script, bytes _input, address[] _blacklist)
507         internal
508         isInitialized
509         protectState
510         returns (bytes)
511     {
512         // TODO: Too much data flying around, maybe extracting spec id here is cheaper
513         IEVMScriptExecutor executor = getEVMScriptExecutor(_script);
514         require(address(executor) != address(0), ERROR_EXECUTOR_UNAVAILABLE);
515 
516         bytes4 sig = executor.execScript.selector;
517         bytes memory data = abi.encodeWithSelector(sig, _script, _input, _blacklist);
518         require(address(executor).delegatecall(data), ERROR_EXECUTION_REVERTED);
519 
520         bytes memory output = returnedDataDecoded();
521 
522         emit ScriptResult(address(executor), _script, _input, output);
523 
524         return output;
525     }
526 
527     /**
528     * @dev copies and returns last's call data. Needs to ABI decode first
529     */
530     function returnedDataDecoded() internal pure returns (bytes ret) {
531         assembly {
532             let size := returndatasize
533             switch size
534             case 0 {}
535             default {
536                 ret := mload(0x40) // free mem ptr get
537                 mstore(0x40, add(ret, add(size, 0x20))) // free mem ptr set
538                 returndatacopy(ret, 0x20, sub(size, 0x20)) // copy return data
539             }
540         }
541         return ret;
542     }
543 
544     modifier protectState {
545         address preKernel = address(kernel());
546         bytes32 preAppId = appId();
547         _; // exec
548         require(address(kernel()) == preKernel, ERROR_PROTECTED_STATE_MODIFIED);
549         require(appId() == preAppId, ERROR_PROTECTED_STATE_MODIFIED);
550     }
551 }
552 // File: @aragon/os/contracts/acl/ACLSyntaxSugar.sol
553 /*
554  * SPDX-License-Identitifer:    MIT
555  */
556 
557 pragma solidity ^0.4.24;
558 
559 
560 contract ACLSyntaxSugar {
561     function arr() internal pure returns (uint256[]) {}
562 
563     function arr(bytes32 _a) internal pure returns (uint256[] r) {
564         return arr(uint256(_a));
565     }
566 
567     function arr(bytes32 _a, bytes32 _b) internal pure returns (uint256[] r) {
568         return arr(uint256(_a), uint256(_b));
569     }
570 
571     function arr(address _a) internal pure returns (uint256[] r) {
572         return arr(uint256(_a));
573     }
574 
575     function arr(address _a, address _b) internal pure returns (uint256[] r) {
576         return arr(uint256(_a), uint256(_b));
577     }
578 
579     function arr(address _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
580         return arr(uint256(_a), _b, _c);
581     }
582 
583     function arr(address _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
584         return arr(uint256(_a), _b, _c, _d);
585     }
586 
587     function arr(address _a, uint256 _b) internal pure returns (uint256[] r) {
588         return arr(uint256(_a), uint256(_b));
589     }
590 
591     function arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
592         return arr(uint256(_a), uint256(_b), _c, _d, _e);
593     }
594 
595     function arr(address _a, address _b, address _c) internal pure returns (uint256[] r) {
596         return arr(uint256(_a), uint256(_b), uint256(_c));
597     }
598 
599     function arr(address _a, address _b, uint256 _c) internal pure returns (uint256[] r) {
600         return arr(uint256(_a), uint256(_b), uint256(_c));
601     }
602 
603     function arr(uint256 _a) internal pure returns (uint256[] r) {
604         r = new uint256[](1);
605         r[0] = _a;
606     }
607 
608     function arr(uint256 _a, uint256 _b) internal pure returns (uint256[] r) {
609         r = new uint256[](2);
610         r[0] = _a;
611         r[1] = _b;
612     }
613 
614     function arr(uint256 _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
615         r = new uint256[](3);
616         r[0] = _a;
617         r[1] = _b;
618         r[2] = _c;
619     }
620 
621     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
622         r = new uint256[](4);
623         r[0] = _a;
624         r[1] = _b;
625         r[2] = _c;
626         r[3] = _d;
627     }
628 
629     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
630         r = new uint256[](5);
631         r[0] = _a;
632         r[1] = _b;
633         r[2] = _c;
634         r[3] = _d;
635         r[4] = _e;
636     }
637 }
638 
639 
640 contract ACLHelpers {
641     function decodeParamOp(uint256 _x) internal pure returns (uint8 b) {
642         return uint8(_x >> (8 * 30));
643     }
644 
645     function decodeParamId(uint256 _x) internal pure returns (uint8 b) {
646         return uint8(_x >> (8 * 31));
647     }
648 
649     function decodeParamsList(uint256 _x) internal pure returns (uint32 a, uint32 b, uint32 c) {
650         a = uint32(_x);
651         b = uint32(_x >> (8 * 4));
652         c = uint32(_x >> (8 * 8));
653     }
654 }
655 // File: @aragon/os/contracts/apps/AragonApp.sol
656 /*
657  * SPDX-License-Identitifer:    MIT
658  */
659 
660 pragma solidity ^0.4.24;
661 
662 
663 
664 
665 
666 
667 
668 // Contracts inheriting from AragonApp are, by default, immediately petrified upon deployment so
669 // that they can never be initialized.
670 // Unless overriden, this behaviour enforces those contracts to be usable only behind an AppProxy.
671 // ACLSyntaxSugar and EVMScriptRunner are not directly used by this contract, but are included so
672 // that they are automatically usable by subclassing contracts
673 contract AragonApp is AppStorage, Autopetrified, VaultRecoverable, EVMScriptRunner, ACLSyntaxSugar {
674     string private constant ERROR_AUTH_FAILED = "APP_AUTH_FAILED";
675 
676     modifier auth(bytes32 _role) {
677         require(canPerform(msg.sender, _role, new uint256[](0)), ERROR_AUTH_FAILED);
678         _;
679     }
680 
681     modifier authP(bytes32 _role, uint256[] _params) {
682         require(canPerform(msg.sender, _role, _params), ERROR_AUTH_FAILED);
683         _;
684     }
685 
686     /**
687     * @dev Check whether an action can be performed by a sender for a particular role on this app
688     * @param _sender Sender of the call
689     * @param _role Role on this app
690     * @param _params Permission params for the role
691     * @return Boolean indicating whether the sender has the permissions to perform the action.
692     *         Always returns false if the app hasn't been initialized yet.
693     */
694     function canPerform(address _sender, bytes32 _role, uint256[] _params) public view returns (bool) {
695         if (!hasInitialized()) {
696             return false;
697         }
698 
699         IKernel linkedKernel = kernel();
700         if (address(linkedKernel) == address(0)) {
701             return false;
702         }
703 
704         // Force cast the uint256[] into a bytes array, by overwriting its length
705         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
706         // with _params and a new length, and _params becomes invalid from this point forward
707         bytes memory how;
708         uint256 byteLength = _params.length * 32;
709         assembly {
710             how := _params
711             mstore(how, byteLength)
712         }
713         return linkedKernel.hasPermission(_sender, address(this), _role, how);
714     }
715 
716     /**
717     * @dev Get the recovery vault for the app
718     * @return Recovery vault address for the app
719     */
720     function getRecoveryVault() public view returns (address) {
721         // Funds recovery via a vault is only available when used with a kernel
722         return kernel().getRecoveryVault(); // if kernel is not set, it will revert
723     }
724 }
725 // File: @aragon/os/contracts/lib/math/SafeMath.sol
726 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d51e38758e1d985661534534d5c61e27bece5042/contracts/math/SafeMath.sol
727 // Adapted to use pragma ^0.4.24 and satisfy our linter rules
728 
729 pragma solidity ^0.4.24;
730 
731 
732 /**
733  * @title SafeMath
734  * @dev Math operations with safety checks that revert on error
735  */
736 library SafeMath {
737     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
738     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
739     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
740     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
741 
742     /**
743     * @dev Multiplies two numbers, reverts on overflow.
744     */
745     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
746         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
747         // benefit is lost if 'b' is also tested.
748         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
749         if (_a == 0) {
750             return 0;
751         }
752 
753         uint256 c = _a * _b;
754         require(c / _a == _b, ERROR_MUL_OVERFLOW);
755 
756         return c;
757     }
758 
759     /**
760     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
761     */
762     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
763         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
764         uint256 c = _a / _b;
765         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
766 
767         return c;
768     }
769 
770     /**
771     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
772     */
773     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
774         require(_b <= _a, ERROR_SUB_UNDERFLOW);
775         uint256 c = _a - _b;
776 
777         return c;
778     }
779 
780     /**
781     * @dev Adds two numbers, reverts on overflow.
782     */
783     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
784         uint256 c = _a + _b;
785         require(c >= _a, ERROR_ADD_OVERFLOW);
786 
787         return c;
788     }
789 
790     /**
791     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
792     * reverts when dividing by zero.
793     */
794     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
795         require(b != 0, ERROR_DIV_ZERO);
796         return a % b;
797     }
798 }
799 // File: @aragon/os/contracts/lib/math/SafeMath64.sol
800 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d51e38758e1d985661534534d5c61e27bece5042/contracts/math/SafeMath.sol
801 // Adapted for uint64, pragma ^0.4.24, and satisfying our linter rules
802 // Also optimized the mul() implementation, see https://github.com/aragon/aragonOS/pull/417
803 
804 pragma solidity ^0.4.24;
805 
806 
807 /**
808  * @title SafeMath64
809  * @dev Math operations for uint64 with safety checks that revert on error
810  */
811 library SafeMath64 {
812     string private constant ERROR_ADD_OVERFLOW = "MATH64_ADD_OVERFLOW";
813     string private constant ERROR_SUB_UNDERFLOW = "MATH64_SUB_UNDERFLOW";
814     string private constant ERROR_MUL_OVERFLOW = "MATH64_MUL_OVERFLOW";
815     string private constant ERROR_DIV_ZERO = "MATH64_DIV_ZERO";
816 
817     /**
818     * @dev Multiplies two numbers, reverts on overflow.
819     */
820     function mul(uint64 _a, uint64 _b) internal pure returns (uint64) {
821         uint256 c = uint256(_a) * uint256(_b);
822         require(c < 0x010000000000000000, ERROR_MUL_OVERFLOW); // 2**64 (less gas this way)
823 
824         return uint64(c);
825     }
826 
827     /**
828     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
829     */
830     function div(uint64 _a, uint64 _b) internal pure returns (uint64) {
831         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
832         uint64 c = _a / _b;
833         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
834 
835         return c;
836     }
837 
838     /**
839     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
840     */
841     function sub(uint64 _a, uint64 _b) internal pure returns (uint64) {
842         require(_b <= _a, ERROR_SUB_UNDERFLOW);
843         uint64 c = _a - _b;
844 
845         return c;
846     }
847 
848     /**
849     * @dev Adds two numbers, reverts on overflow.
850     */
851     function add(uint64 _a, uint64 _b) internal pure returns (uint64) {
852         uint64 c = _a + _b;
853         require(c >= _a, ERROR_ADD_OVERFLOW);
854 
855         return c;
856     }
857 
858     /**
859     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
860     * reverts when dividing by zero.
861     */
862     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
863         require(b != 0, ERROR_DIV_ZERO);
864         return a % b;
865     }
866 }
867 // File: @aragon/os/contracts/common/DepositableStorage.sol
868 contract DepositableStorage {
869     using UnstructuredStorage for bytes32;
870 
871     // keccak256("aragonOS.depositableStorage.depositable")
872     bytes32 internal constant DEPOSITABLE_POSITION = 0x665fd576fbbe6f247aff98f5c94a561e3f71ec2d3c988d56f12d342396c50cea;
873 
874     function isDepositable() public view returns (bool) {
875         return DEPOSITABLE_POSITION.getStorageBool();
876     }
877 
878     function setDepositable(bool _depositable) internal {
879         DEPOSITABLE_POSITION.setStorageBool(_depositable);
880     }
881 }
882 // File: @aragon/apps-vault/contracts/Vault.sol
883 contract Vault is EtherTokenConstant, AragonApp, DepositableStorage {
884     bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
885 
886     string private constant ERROR_DATA_NON_ZERO = "VAULT_DATA_NON_ZERO";
887     string private constant ERROR_NOT_DEPOSITABLE = "VAULT_NOT_DEPOSITABLE";
888     string private constant ERROR_DEPOSIT_VALUE_ZERO = "VAULT_DEPOSIT_VALUE_ZERO";
889     string private constant ERROR_TRANSFER_VALUE_ZERO = "VAULT_TRANSFER_VALUE_ZERO";
890     string private constant ERROR_SEND_REVERTED = "VAULT_SEND_REVERTED";
891     string private constant ERROR_VALUE_MISMATCH = "VAULT_VALUE_MISMATCH";
892     string private constant ERROR_TOKEN_TRANSFER_FROM_REVERTED = "VAULT_TOKEN_TRANSFER_FROM_REVERT";
893     string private constant ERROR_TOKEN_TRANSFER_REVERTED = "VAULT_TOKEN_TRANSFER_REVERTED";
894 
895     event VaultTransfer(address indexed token, address indexed to, uint256 amount);
896     event VaultDeposit(address indexed token, address indexed sender, uint256 amount);
897 
898     /**
899     * @dev On a normal send() or transfer() this fallback is never executed as it will be
900     *      intercepted by the Proxy (see aragonOS#281)
901     */
902     function () external payable isInitialized {
903         require(msg.data.length == 0, ERROR_DATA_NON_ZERO);
904         _deposit(ETH, msg.value);
905     }
906 
907     /**
908     * @notice Initialize Vault app
909     * @dev As an AragonApp it needs to be initialized in order for roles (`auth` and `authP`) to work
910     */
911     function initialize() external onlyInit {
912         initialized();
913         setDepositable(true);
914     }
915 
916     /**
917     * @notice Deposit `_value` `_token` to the vault
918     * @param _token Address of the token being transferred
919     * @param _value Amount of tokens being transferred
920     */
921     function deposit(address _token, uint256 _value) external payable isInitialized {
922         _deposit(_token, _value);
923     }
924 
925     /**
926     * @notice Transfer `_value` `_token` from the Vault to `_to`
927     * @param _token Address of the token being transferred
928     * @param _to Address of the recipient of tokens
929     * @param _value Amount of tokens being transferred
930     */
931     /* solium-disable-next-line function-order */
932     function transfer(address _token, address _to, uint256 _value)
933         external
934         authP(TRANSFER_ROLE, arr(_token, _to, _value))
935     {
936         require(_value > 0, ERROR_TRANSFER_VALUE_ZERO);
937 
938         if (_token == ETH) {
939             require(_to.send(_value), ERROR_SEND_REVERTED);
940         } else {
941             require(ERC20(_token).transfer(_to, _value), ERROR_TOKEN_TRANSFER_REVERTED);
942         }
943 
944         emit VaultTransfer(_token, _to, _value);
945     }
946 
947     function balance(address _token) public view returns (uint256) {
948         if (_token == ETH) {
949             return address(this).balance;
950         } else {
951             return ERC20(_token).balanceOf(this);
952         }
953     }
954 
955     /**
956     * @dev Disable recovery escape hatch, as it could be used
957     *      maliciously to transfer funds away from the vault
958     */
959     function allowRecoverability(address) public view returns (bool) {
960         return false;
961     }
962 
963     function _deposit(address _token, uint256 _value) internal {
964         require(isDepositable(), ERROR_NOT_DEPOSITABLE);
965         require(_value > 0, ERROR_DEPOSIT_VALUE_ZERO);
966 
967         if (_token == ETH) {
968             // Deposit is implicit in this case
969             require(msg.value == _value, ERROR_VALUE_MISMATCH);
970         } else {
971             require(ERC20(_token).transferFrom(msg.sender, this, _value), ERROR_TOKEN_TRANSFER_FROM_REVERTED);
972         }
973 
974         emit VaultDeposit(_token, msg.sender, _value);
975     }
976 }
977 // File: @aragon/apps-finance/contracts/Finance.sol
978 /*
979  * SPDX-License-Identitifer:    GPL-3.0-or-later
980  */
981 
982 pragma solidity 0.4.24;
983 
984 
985 
986 
987 
988 
989 
990 
991 
992 contract Finance is EtherTokenConstant, IsContract, AragonApp {
993     using SafeMath for uint256;
994     using SafeMath64 for uint64;
995 
996     bytes32 public constant CREATE_PAYMENTS_ROLE = keccak256("CREATE_PAYMENTS_ROLE");
997     bytes32 public constant CHANGE_PERIOD_ROLE = keccak256("CHANGE_PERIOD_ROLE");
998     bytes32 public constant CHANGE_BUDGETS_ROLE = keccak256("CHANGE_BUDGETS_ROLE");
999     bytes32 public constant EXECUTE_PAYMENTS_ROLE = keccak256("EXECUTE_PAYMENTS_ROLE");
1000     bytes32 public constant MANAGE_PAYMENTS_ROLE = keccak256("MANAGE_PAYMENTS_ROLE");
1001 
1002     uint256 internal constant NO_PAYMENT = 0;
1003     uint256 internal constant NO_TRANSACTION = 0;
1004     uint256 internal constant MAX_PAYMENTS_PER_TX = 20;
1005     uint256 internal constant MAX_UINT = uint256(-1);
1006     uint64 internal constant MAX_UINT64 = uint64(-1);
1007 
1008     string private constant ERROR_COMPLETE_TRANSITION = "FINANCE_COMPLETE_TRANSITION";
1009     string private constant ERROR_NO_PAYMENT = "FINANCE_NO_PAYMENT";
1010     string private constant ERROR_NO_TRANSACTION = "FINANCE_NO_TRANSACTION";
1011     string private constant ERROR_NO_PERIOD = "FINANCE_NO_PERIOD";
1012     string private constant ERROR_VAULT_NOT_CONTRACT = "FINANCE_VAULT_NOT_CONTRACT";
1013     string private constant ERROR_INIT_PERIOD_TOO_SHORT = "FINANCE_INIT_PERIOD_TOO_SHORT";
1014     string private constant ERROR_SET_PERIOD_TOO_SHORT = "FINANCE_SET_PERIOD_TOO_SHORT";
1015     string private constant ERROR_NEW_PAYMENT_AMOUNT_ZERO = "FINANCE_NEW_PAYMENT_AMOUNT_ZERO";
1016     string private constant ERROR_RECOVER_AMOUNT_ZERO = "FINANCE_RECOVER_AMOUNT_ZERO";
1017     string private constant ERROR_DEPOSIT_AMOUNT_ZERO = "FINANCE_DEPOSIT_AMOUNT_ZERO";
1018     string private constant ERROR_BUDGET = "FINANCE_BUDGET";
1019     string private constant ERROR_EXECUTE_PAYMENT_TIME = "FINANCE_EXECUTE_PAYMENT_TIME";
1020     string private constant ERROR_RECEIVER_EXECUTE_PAYMENT_TIME = "FINANCE_RCVR_EXEC_PAYMENT_TIME";
1021     string private constant ERROR_PAYMENT_RECEIVER = "FINANCE_PAYMENT_RECEIVER";
1022     string private constant ERROR_TOKEN_TRANSFER_FROM_REVERTED = "FINANCE_TKN_TRANSFER_FROM_REVERT";
1023     string private constant ERROR_VALUE_MISMATCH = "FINANCE_VALUE_MISMATCH";
1024     string private constant ERROR_PAYMENT_INACTIVE = "FINANCE_PAYMENT_INACTIVE";
1025     string private constant ERROR_REMAINING_BUDGET = "FINANCE_REMAINING_BUDGET";
1026 
1027     // Order optimized for storage
1028     struct Payment {
1029         address token;
1030         address receiver;
1031         address createdBy;
1032         bool inactive;
1033         uint256 amount;
1034         uint64 initialPaymentTime;
1035         uint64 interval;
1036         uint64 maxRepeats;
1037         uint64 repeats;
1038     }
1039 
1040     // Order optimized for storage
1041     struct Transaction {
1042         address token;
1043         address entity;
1044         bool isIncoming;
1045         uint256 amount;
1046         uint256 paymentId;
1047         uint64 paymentRepeatNumber;
1048         uint64 date;
1049         uint64 periodId;
1050     }
1051 
1052     struct TokenStatement {
1053         uint256 expenses;
1054         uint256 income;
1055     }
1056 
1057     struct Period {
1058         uint64 startTime;
1059         uint64 endTime;
1060         uint256 firstTransactionId;
1061         uint256 lastTransactionId;
1062 
1063         mapping (address => TokenStatement) tokenStatement;
1064     }
1065 
1066     struct Settings {
1067         uint64 periodDuration;
1068         mapping (address => uint256) budgets;
1069         mapping (address => bool) hasBudget;
1070     }
1071 
1072     Vault public vault;
1073     Settings internal settings;
1074 
1075     // We are mimicing arrays, we use mappings instead to make app upgrade more graceful
1076     mapping (uint256 => Payment) internal payments;
1077     // Payments start at index 1, to allow us to use payments[0] for transactions that are not
1078     // linked to a recurring payment
1079     uint256 public paymentsNextIndex;
1080 
1081     mapping (uint256 => Transaction) internal transactions;
1082     uint256 public transactionsNextIndex;
1083 
1084     mapping (uint64 => Period) internal periods;
1085     uint64 public periodsLength;
1086 
1087     event NewPeriod(uint64 indexed periodId, uint64 periodStarts, uint64 periodEnds);
1088     event SetBudget(address indexed token, uint256 amount, bool hasBudget);
1089     event NewPayment(uint256 indexed paymentId, address indexed recipient, uint64 maxRepeats, string reference);
1090     event NewTransaction(uint256 indexed transactionId, bool incoming, address indexed entity, uint256 amount, string reference);
1091     event ChangePaymentState(uint256 indexed paymentId, bool inactive);
1092     event ChangePeriodDuration(uint64 newDuration);
1093     event PaymentFailure(uint256 paymentId);
1094 
1095     // Modifier used by all methods that impact accounting to make sure accounting period
1096     // is changed before the operation if needed
1097     // NOTE: its use **MUST** be accompanied by an initialization check
1098     modifier transitionsPeriod {
1099         bool completeTransition = _tryTransitionAccountingPeriod(getMaxPeriodTransitions());
1100         require(completeTransition, ERROR_COMPLETE_TRANSITION);
1101         _;
1102     }
1103 
1104     modifier paymentExists(uint256 _paymentId) {
1105         require(_paymentId > 0 && _paymentId < paymentsNextIndex, ERROR_NO_PAYMENT);
1106         _;
1107     }
1108 
1109     modifier transactionExists(uint256 _transactionId) {
1110         require(_transactionId > 0 && _transactionId < transactionsNextIndex, ERROR_NO_TRANSACTION);
1111         _;
1112     }
1113 
1114     modifier periodExists(uint64 _periodId) {
1115         require(_periodId < periodsLength, ERROR_NO_PERIOD);
1116         _;
1117     }
1118 
1119     /**
1120      * @dev Sends ETH to Vault. Sends all the available balance.
1121      * @notice Deposit ETH to the Vault, to avoid locking them in this Finance app forever
1122      */
1123     function () external payable isInitialized transitionsPeriod {
1124         _deposit(
1125             ETH,
1126             msg.value,
1127             "Ether transfer to Finance app",
1128             msg.sender,
1129             true
1130         );
1131     }
1132 
1133     /**
1134     * @notice Initialize Finance app for Vault at `_vault` with period length of `@transformTime(_periodDuration)`
1135     * @param _vault Address of the vault Finance will rely on (non changeable)
1136     * @param _periodDuration Duration in seconds of each period
1137     */
1138     function initialize(Vault _vault, uint64 _periodDuration) external onlyInit {
1139         initialized();
1140 
1141         require(isContract(_vault), ERROR_VAULT_NOT_CONTRACT);
1142         vault = _vault;
1143 
1144         require(_periodDuration >= 1 days, ERROR_INIT_PERIOD_TOO_SHORT);
1145         settings.periodDuration = _periodDuration;
1146 
1147         // Reserve the first recurring payment index as an unused index for transactions not linked to a payment
1148         payments[0].inactive = true;
1149         paymentsNextIndex = 1;
1150 
1151         // Reserve the first transaction index as an unused index for periods with no transactions
1152         transactionsNextIndex = 1;
1153 
1154         // Start the first period
1155         _newPeriod(getTimestamp64());
1156     }
1157 
1158     /**
1159     * @dev Deposit for approved ERC20 tokens or ETH
1160     * @notice Deposit `@tokenAmount(_token, _amount)`
1161     * @param _token Address of deposited token
1162     * @param _amount Amount of tokens sent
1163     * @param _reference Reason for payment
1164     */
1165     function deposit(address _token, uint256 _amount, string _reference) external payable isInitialized transitionsPeriod {
1166         _deposit(
1167             _token,
1168             _amount,
1169             _reference,
1170             msg.sender,
1171             true
1172         );
1173     }
1174 
1175     /**
1176     * @notice Create a new payment of `@tokenAmount(_token, _amount)` to `_receiver``_maxRepeats > 0 ? ', executing ' + _maxRepeats + ' times at intervals of ' + @transformTime(_interval) : ''`
1177     * @param _token Address of token for payment
1178     * @param _receiver Address that will receive payment
1179     * @param _amount Tokens that are payed every time the payment is due
1180     * @param _initialPaymentTime Timestamp for when the first payment is done
1181     * @param _interval Number of seconds that need to pass between payment transactions
1182     * @param _maxRepeats Maximum instances a payment can be executed
1183     * @param _reference String detailing payment reason
1184     */
1185     function newPayment(
1186         address _token,
1187         address _receiver,
1188         uint256 _amount,
1189         uint64 _initialPaymentTime,
1190         uint64 _interval,
1191         uint64 _maxRepeats,
1192         string _reference
1193     )
1194         external
1195         authP(CREATE_PAYMENTS_ROLE, arr(_token, _receiver, _amount, _interval, _maxRepeats))
1196         transitionsPeriod
1197         returns (uint256 paymentId)
1198     {
1199         require(_amount > 0, ERROR_NEW_PAYMENT_AMOUNT_ZERO);
1200 
1201         // Avoid saving payment data for 1 time immediate payments
1202         if (_initialPaymentTime <= getTimestamp64() && _maxRepeats == 1) {
1203             _makePaymentTransaction(
1204                 _token,
1205                 _receiver,
1206                 _amount,
1207                 NO_PAYMENT,   // unrelated to any payment id; it isn't created
1208                 0,   // also unrelated to any payment repeats
1209                 _reference
1210             );
1211             return;
1212         }
1213 
1214         // Budget must allow at least one instance of this payment each period, or not be set at all
1215         require(settings.budgets[_token] >= _amount || !settings.hasBudget[_token], ERROR_BUDGET);
1216 
1217         paymentId = paymentsNextIndex++;
1218         emit NewPayment(paymentId, _receiver, _maxRepeats, _reference);
1219 
1220         Payment storage payment = payments[paymentId];
1221         payment.token = _token;
1222         payment.receiver = _receiver;
1223         payment.amount = _amount;
1224         payment.initialPaymentTime = _initialPaymentTime;
1225         payment.interval = _interval;
1226         payment.maxRepeats = _maxRepeats;
1227         payment.createdBy = msg.sender;
1228 
1229         if (nextPaymentTime(paymentId) <= getTimestamp64()) {
1230             _executePayment(paymentId);
1231         }
1232     }
1233 
1234     /**
1235     * @notice Change period duration to `@transformTime(_periodDuration)`, effective for next accounting period
1236     * @param _periodDuration Duration in seconds for accounting periods
1237     */
1238     function setPeriodDuration(uint64 _periodDuration)
1239         external
1240         authP(CHANGE_PERIOD_ROLE, arr(uint256(_periodDuration), uint256(settings.periodDuration)))
1241         transitionsPeriod
1242     {
1243         require(_periodDuration >= 1 days, ERROR_SET_PERIOD_TOO_SHORT);
1244         settings.periodDuration = _periodDuration;
1245         emit ChangePeriodDuration(_periodDuration);
1246     }
1247 
1248     /**
1249     * @notice Set budget for `_token.symbol(): string` to `@tokenAmount(_token, _amount, false)`, effective immediately
1250     * @param _token Address for token
1251     * @param _amount New budget amount
1252     */
1253     function setBudget(
1254         address _token,
1255         uint256 _amount
1256     )
1257         external
1258         authP(CHANGE_BUDGETS_ROLE, arr(_token, _amount, settings.budgets[_token], settings.hasBudget[_token] ? 1 : 0))
1259         transitionsPeriod
1260     {
1261         settings.budgets[_token] = _amount;
1262         if (!settings.hasBudget[_token]) {
1263             settings.hasBudget[_token] = true;
1264         }
1265         emit SetBudget(_token, _amount, true);
1266     }
1267 
1268     /**
1269     * @notice Remove spending limit for `_token.symbol(): string`, effective immediately
1270     * @param _token Address for token
1271     */
1272     function removeBudget(address _token)
1273         external
1274         authP(CHANGE_BUDGETS_ROLE, arr(_token, uint256(0), settings.budgets[_token], settings.hasBudget[_token] ? 1 : 0))
1275         transitionsPeriod
1276     {
1277         settings.budgets[_token] = 0;
1278         settings.hasBudget[_token] = false;
1279         emit SetBudget(_token, 0, false);
1280     }
1281 
1282     /**
1283     * @dev Executes any payment (requires role)
1284     * @notice Execute pending payment #`_paymentId`
1285     * @param _paymentId Identifier for payment
1286     */
1287     function executePayment(uint256 _paymentId)
1288         external
1289         authP(EXECUTE_PAYMENTS_ROLE, arr(_paymentId, payments[_paymentId].amount))
1290         paymentExists(_paymentId)
1291         transitionsPeriod
1292     {
1293         require(nextPaymentTime(_paymentId) <= getTimestamp64(), ERROR_EXECUTE_PAYMENT_TIME);
1294 
1295         _executePayment(_paymentId);
1296     }
1297 
1298     /**
1299     * @dev Always allows receiver of a payment to trigger execution
1300     * @notice Execute pending payment #`_paymentId`
1301     * @param _paymentId Identifier for payment
1302     */
1303     function receiverExecutePayment(uint256 _paymentId) external isInitialized paymentExists(_paymentId) transitionsPeriod {
1304         require(nextPaymentTime(_paymentId) <= getTimestamp64(), ERROR_RECEIVER_EXECUTE_PAYMENT_TIME);
1305         require(payments[_paymentId].receiver == msg.sender, ERROR_PAYMENT_RECEIVER);
1306 
1307         _executePayment(_paymentId);
1308     }
1309 
1310     /**
1311     * @notice `_active ? 'Activate' : 'Disable'` payment #`_paymentId`
1312     * @dev Note that we do not require this action to transition periods, as it doesn't directly
1313     *      impact any accounting periods.
1314     *      Not having to transition periods also makes disabling payments easier to prevent funds
1315     *      from being pulled out in the event of a breach.
1316     * @param _paymentId Identifier for payment
1317     * @param _active Whether it will be active or inactive
1318     */
1319     function setPaymentStatus(uint256 _paymentId, bool _active)
1320         external
1321         authP(MANAGE_PAYMENTS_ROLE, arr(_paymentId, uint256(_active ? 1 : 0)))
1322         paymentExists(_paymentId)
1323     {
1324         payments[_paymentId].inactive = !_active;
1325         emit ChangePaymentState(_paymentId, _active);
1326     }
1327 
1328     /**
1329      * @dev Allows making a simple payment from this contract to the Vault, to avoid locked tokens.
1330      *      This contract should never receive tokens with a simple transfer call, but in case it
1331      *      happens, this function allows for their recovery.
1332      * @notice Send tokens held in this contract to the Vault
1333      * @param _token Token whose balance is going to be transferred.
1334      */
1335     function recoverToVault(address _token) public isInitialized transitionsPeriod {
1336         uint256 amount = _token == ETH ? address(this).balance : ERC20(_token).balanceOf(this);
1337         require(amount > 0, ERROR_RECOVER_AMOUNT_ZERO);
1338 
1339         _deposit(
1340             _token,
1341             amount,
1342             "Recover to Vault",
1343             this,
1344             false
1345         );
1346     }
1347 
1348     /**
1349     * @dev Transitions accounting periods if needed. For preventing OOG attacks, a maxTransitions
1350     *      param is provided. If more than the specified number of periods need to be transitioned,
1351     *      it will return false.
1352     * @notice Transition accounting period if needed
1353     * @param _maxTransitions Maximum periods that can be transitioned
1354     * @return success Boolean indicating whether the accounting period is the correct one (if false,
1355     *                 maxTransitions was surpased and another call is needed)
1356     */
1357     function tryTransitionAccountingPeriod(uint64 _maxTransitions) public isInitialized returns (bool success) {
1358         return _tryTransitionAccountingPeriod(_maxTransitions);
1359     }
1360 
1361     // consts
1362 
1363     /**
1364     * @dev Disable recovery escape hatch if the app has been initialized, as it could be used
1365     *      maliciously to transfer funds in the Finance app to another Vault
1366     *      finance#recoverToVault() should be used to recover funds to the Finance's vault
1367     */
1368     function allowRecoverability(address) public view returns (bool) {
1369         return !hasInitialized();
1370     }
1371 
1372     function getPayment(uint256 _paymentId)
1373         public
1374         view
1375         paymentExists(_paymentId)
1376         returns (
1377             address token,
1378             address receiver,
1379             uint256 amount,
1380             uint64 initialPaymentTime,
1381             uint64 interval,
1382             uint64 maxRepeats,
1383             bool inactive,
1384             uint64 repeats,
1385             address createdBy
1386         )
1387     {
1388         Payment storage payment = payments[_paymentId];
1389 
1390         token = payment.token;
1391         receiver = payment.receiver;
1392         amount = payment.amount;
1393         initialPaymentTime = payment.initialPaymentTime;
1394         interval = payment.interval;
1395         maxRepeats = payment.maxRepeats;
1396         repeats = payment.repeats;
1397         inactive = payment.inactive;
1398         createdBy = payment.createdBy;
1399     }
1400 
1401     function getTransaction(uint256 _transactionId)
1402         public
1403         view
1404         transactionExists(_transactionId)
1405         returns (
1406             uint64 periodId,
1407             uint256 amount,
1408             uint256 paymentId,
1409             uint64 paymentRepeatNumber,
1410             address token,
1411             address entity,
1412             bool isIncoming,
1413             uint64 date
1414         )
1415     {
1416         Transaction storage transaction = transactions[_transactionId];
1417 
1418         token = transaction.token;
1419         entity = transaction.entity;
1420         isIncoming = transaction.isIncoming;
1421         date = transaction.date;
1422         periodId = transaction.periodId;
1423         amount = transaction.amount;
1424         paymentId = transaction.paymentId;
1425         paymentRepeatNumber = transaction.paymentRepeatNumber;
1426     }
1427 
1428     function getPeriod(uint64 _periodId)
1429         public
1430         view
1431         periodExists(_periodId)
1432         returns (
1433             bool isCurrent,
1434             uint64 startTime,
1435             uint64 endTime,
1436             uint256 firstTransactionId,
1437             uint256 lastTransactionId
1438         )
1439     {
1440         Period storage period = periods[_periodId];
1441 
1442         isCurrent = _currentPeriodId() == _periodId;
1443 
1444         startTime = period.startTime;
1445         endTime = period.endTime;
1446         firstTransactionId = period.firstTransactionId;
1447         lastTransactionId = period.lastTransactionId;
1448     }
1449 
1450     function getPeriodTokenStatement(uint64 _periodId, address _token)
1451         public
1452         view
1453         periodExists(_periodId)
1454         returns (uint256 expenses, uint256 income)
1455     {
1456         TokenStatement storage tokenStatement = periods[_periodId].tokenStatement[_token];
1457         expenses = tokenStatement.expenses;
1458         income = tokenStatement.income;
1459     }
1460 
1461     function nextPaymentTime(uint256 _paymentId) public view paymentExists(_paymentId) returns (uint64) {
1462         Payment memory payment = payments[_paymentId];
1463 
1464         if (payment.repeats >= payment.maxRepeats) {
1465             return MAX_UINT64; // re-executes in some billions of years time... should not need to worry
1466         }
1467 
1468         // Split in multiple lines to circunvent linter warning
1469         uint64 increase = payment.repeats.mul(payment.interval);
1470         uint64 nextPayment = payment.initialPaymentTime.add(increase);
1471         return nextPayment;
1472     }
1473 
1474     function getPeriodDuration() public view returns (uint64) {
1475         return settings.periodDuration;
1476     }
1477 
1478     function getBudget(address _token) public view returns (uint256 budget, bool hasBudget) {
1479         budget = settings.budgets[_token];
1480         hasBudget = settings.hasBudget[_token];
1481     }
1482 
1483     /**
1484     * @dev We have to check for initialization as periods are only valid after initializing
1485     */
1486     function getRemainingBudget(address _token) public view isInitialized returns (uint256) {
1487         return _getRemainingBudget(_token);
1488     }
1489 
1490     /**
1491     * @dev We have to check for initialization as periods are only valid after initializing
1492     */
1493     function currentPeriodId() public view isInitialized returns (uint64) {
1494         return _currentPeriodId();
1495     }
1496 
1497     // internal fns
1498 
1499     function _deposit(address _token, uint256 _amount, string _reference, address _sender, bool _isExternalDeposit) internal {
1500         require(_amount > 0, ERROR_DEPOSIT_AMOUNT_ZERO);
1501         _recordIncomingTransaction(
1502             _token,
1503             _sender,
1504             _amount,
1505             _reference
1506         );
1507 
1508         // If it is an external deposit, check that the assets are actually transferred
1509         // External deposit will be false when the assets were already in the Finance app
1510         // and just need to be transferred to the vault
1511         if (_isExternalDeposit) {
1512             if (_token != ETH) {
1513                 // Get the tokens to Finance
1514                 require(ERC20(_token).transferFrom(msg.sender, this, _amount), ERROR_TOKEN_TRANSFER_FROM_REVERTED);
1515             } else {
1516                 // Ensure that the ETH sent with the transaction equals the amount in the deposit
1517                 require(msg.value == _amount, ERROR_VALUE_MISMATCH);
1518             }
1519         }
1520 
1521         if (_token == ETH) {
1522             vault.deposit.value(_amount)(ETH, _amount);
1523         } else {
1524             ERC20(_token).approve(vault, _amount);
1525             // finally we can deposit them
1526             vault.deposit(_token, _amount);
1527         }
1528     }
1529 
1530     function _newPeriod(uint64 _startTime) internal returns (Period storage) {
1531         // There should be no way for this to overflow since each period is at least one day
1532         uint64 newPeriodId = periodsLength++;
1533 
1534         Period storage period = periods[newPeriodId];
1535         period.startTime = _startTime;
1536 
1537         // Be careful here to not overflow; if startTime + periodDuration overflows, we set endTime
1538         // to MAX_UINT64 (let's assume that's the end of time for now).
1539         uint64 endTime = _startTime + settings.periodDuration - 1;
1540         if (endTime < _startTime) { // overflowed
1541             endTime = MAX_UINT64;
1542         }
1543         period.endTime = endTime;
1544 
1545         emit NewPeriod(newPeriodId, period.startTime, period.endTime);
1546 
1547         return period;
1548     }
1549 
1550     function _executePayment(uint256 _paymentId) internal {
1551         Payment storage payment = payments[_paymentId];
1552         require(!payment.inactive, ERROR_PAYMENT_INACTIVE);
1553 
1554         uint64 payed = 0;
1555         while (nextPaymentTime(_paymentId) <= getTimestamp64() && payed < MAX_PAYMENTS_PER_TX) {
1556             if (!_canMakePayment(payment.token, payment.amount)) {
1557                 emit PaymentFailure(_paymentId);
1558                 return;
1559             }
1560 
1561             // The while() predicate prevents these two from ever overflowing
1562             payment.repeats += 1;
1563             payed += 1;
1564 
1565             _makePaymentTransaction(
1566                 payment.token,
1567                 payment.receiver,
1568                 payment.amount,
1569                 _paymentId,
1570                 payment.repeats,
1571                 ""
1572             );
1573         }
1574     }
1575 
1576     function _makePaymentTransaction(
1577         address _token,
1578         address _receiver,
1579         uint256 _amount,
1580         uint256 _paymentId,
1581         uint64 _paymentRepeatNumber,
1582         string _reference
1583     )
1584         internal
1585     {
1586         require(_getRemainingBudget(_token) >= _amount, ERROR_REMAINING_BUDGET);
1587         _recordTransaction(
1588             false,
1589             _token,
1590             _receiver,
1591             _amount,
1592             _paymentId,
1593             _paymentRepeatNumber,
1594             _reference
1595         );
1596 
1597         vault.transfer(_token, _receiver, _amount);
1598     }
1599 
1600     function _recordIncomingTransaction(
1601         address _token,
1602         address _sender,
1603         uint256 _amount,
1604         string _reference
1605     )
1606         internal
1607     {
1608         _recordTransaction(
1609             true, // incoming transaction
1610             _token,
1611             _sender,
1612             _amount,
1613             NO_PAYMENT, // unrelated to any existing payment
1614             0, // and no payment repeats
1615             _reference
1616         );
1617     }
1618 
1619     function _recordTransaction(
1620         bool _incoming,
1621         address _token,
1622         address _entity,
1623         uint256 _amount,
1624         uint256 _paymentId,
1625         uint64 _paymentRepeatNumber,
1626         string _reference
1627     )
1628         internal
1629     {
1630         uint64 periodId = _currentPeriodId();
1631         TokenStatement storage tokenStatement = periods[periodId].tokenStatement[_token];
1632         if (_incoming) {
1633             tokenStatement.income = tokenStatement.income.add(_amount);
1634         } else {
1635             tokenStatement.expenses = tokenStatement.expenses.add(_amount);
1636         }
1637 
1638         uint256 transactionId = transactionsNextIndex++;
1639         Transaction storage transaction = transactions[transactionId];
1640         transaction.token = _token;
1641         transaction.entity = _entity;
1642         transaction.isIncoming = _incoming;
1643         transaction.amount = _amount;
1644         transaction.paymentId = _paymentId;
1645         transaction.paymentRepeatNumber = _paymentRepeatNumber;
1646         transaction.date = getTimestamp64();
1647         transaction.periodId = periodId;
1648 
1649         Period storage period = periods[periodId];
1650         if (period.firstTransactionId == NO_TRANSACTION) {
1651             period.firstTransactionId = transactionId;
1652         }
1653 
1654         emit NewTransaction(transactionId, _incoming, _entity, _amount, _reference);
1655     }
1656 
1657     function _tryTransitionAccountingPeriod(uint256 _maxTransitions) internal returns (bool success) {
1658         Period storage currentPeriod = periods[_currentPeriodId()];
1659         uint64 timestamp = getTimestamp64();
1660 
1661         // Transition periods if necessary
1662         while (timestamp > currentPeriod.endTime) {
1663             if (_maxTransitions == 0) {
1664                 // Required number of transitions is over allowed number, return false indicating
1665                 // it didn't fully transition
1666                 return false;
1667             }
1668             _maxTransitions = _maxTransitions.sub(1);
1669 
1670             // If there were any transactions in period, record which was the last
1671             // In case 0 transactions occured, first and last tx id will be 0
1672             if (currentPeriod.firstTransactionId != NO_TRANSACTION) {
1673                 currentPeriod.lastTransactionId = transactionsNextIndex.sub(1);
1674             }
1675 
1676             // New period starts at end time + 1
1677             currentPeriod = _newPeriod(currentPeriod.endTime.add(1));
1678         }
1679 
1680         return true;
1681     }
1682 
1683     function _canMakePayment(address _token, uint256 _amount) internal view returns (bool) {
1684         return _getRemainingBudget(_token) >= _amount && vault.balance(_token) >= _amount;
1685     }
1686 
1687     function _getRemainingBudget(address _token) internal view returns (uint256) {
1688         if (!settings.hasBudget[_token]) {
1689             return MAX_UINT;
1690         }
1691 
1692         uint256 spent = periods[_currentPeriodId()].tokenStatement[_token].expenses;
1693 
1694         // A budget decrease can cause the spent amount to be greater than period budget
1695         // If so, return 0 to not allow more spending during period
1696         if (spent >= settings.budgets[_token]) {
1697             return 0;
1698         }
1699 
1700         return settings.budgets[_token].sub(spent);
1701     }
1702 
1703     function _currentPeriodId() internal view returns (uint64) {
1704         // There is no way for this to overflow if protected by an initialization check
1705         return periodsLength - 1;
1706     }
1707 
1708     // Must be view for mocking purposes
1709     function getMaxPeriodTransitions() internal view returns (uint64) { return MAX_UINT64; }
1710 }
1711 // File: @aragon/os/contracts/common/IForwarder.sol
1712 /*
1713  * SPDX-License-Identitifer:    MIT
1714  */
1715 
1716 pragma solidity ^0.4.24;
1717 
1718 
1719 interface IForwarder {
1720     function isForwarder() external pure returns (bool);
1721 
1722     // TODO: this should be external
1723     // See https://github.com/ethereum/solidity/issues/4832
1724     function canForward(address sender, bytes evmCallScript) public view returns (bool);
1725 
1726     // TODO: this should be external
1727     // See https://github.com/ethereum/solidity/issues/4832
1728     function forward(bytes evmCallScript) public;
1729 }
1730 // File: @aragon/apps-shared-minime/contracts/ITokenController.sol
1731 /// @dev The token controller contract must implement these functions
1732 
1733 
1734 interface ITokenController {
1735     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
1736     /// @param _owner The address that sent the ether to create tokens
1737     /// @return True if the ether is accepted, false if it throws
1738     function proxyPayment(address _owner) external payable returns(bool);
1739 
1740     /// @notice Notifies the controller about a token transfer allowing the
1741     ///  controller to react if desired
1742     /// @param _from The origin of the transfer
1743     /// @param _to The destination of the transfer
1744     /// @param _amount The amount of the transfer
1745     /// @return False if the controller does not authorize the transfer
1746     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
1747 
1748     /// @notice Notifies the controller about an approval allowing the
1749     ///  controller to react if desired
1750     /// @param _owner The address that calls `approve()`
1751     /// @param _spender The spender in the `approve()` call
1752     /// @param _amount The amount in the `approve()` call
1753     /// @return False if the controller does not authorize the approval
1754     function onApprove(address _owner, address _spender, uint _amount) external returns(bool);
1755 }
1756 // File: @aragon/apps-shared-minime/contracts/MiniMeToken.sol
1757 /*
1758     Copyright 2016, Jordi Baylina
1759     This program is free software: you can redistribute it and/or modify
1760     it under the terms of the GNU General Public License as published by
1761     the Free Software Foundation, either version 3 of the License, or
1762     (at your option) any later version.
1763     This program is distributed in the hope that it will be useful,
1764     but WITHOUT ANY WARRANTY; without even the implied warranty of
1765     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1766     GNU General Public License for more details.
1767     You should have received a copy of the GNU General Public License
1768     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1769  */
1770 
1771 /// @title MiniMeToken Contract
1772 /// @author Jordi Baylina
1773 /// @dev This token contract's goal is to make it easy for anyone to clone this
1774 ///  token using the token distribution at a given block, this will allow DAO's
1775 ///  and DApps to upgrade their features in a decentralized manner without
1776 ///  affecting the original token
1777 /// @dev It is ERC20 compliant, but still needs to under go further testing.
1778 
1779 
1780 contract Controlled {
1781     /// @notice The address of the controller is the only address that can call
1782     ///  a function with this modifier
1783     modifier onlyController {
1784         require(msg.sender == controller);
1785         _;
1786     }
1787 
1788     address public controller;
1789 
1790     function Controlled()  public { controller = msg.sender;}
1791 
1792     /// @notice Changes the controller of the contract
1793     /// @param _newController The new controller of the contract
1794     function changeController(address _newController) onlyController  public {
1795         controller = _newController;
1796     }
1797 }
1798 
1799 contract ApproveAndCallFallBack {
1800     function receiveApproval(
1801         address from,
1802         uint256 _amount,
1803         address _token,
1804         bytes _data
1805     ) public;
1806 }
1807 
1808 /// @dev The actual token contract, the default controller is the msg.sender
1809 ///  that deploys the contract, so usually this token will be deployed by a
1810 ///  token controller contract, which Giveth will call a "Campaign"
1811 contract MiniMeToken is Controlled {
1812 
1813     string public name;                //The Token's name: e.g. DigixDAO Tokens
1814     uint8 public decimals;             //Number of decimals of the smallest unit
1815     string public symbol;              //An identifier: e.g. REP
1816     string public version = "MMT_0.1"; //An arbitrary versioning scheme
1817 
1818 
1819     /// @dev `Checkpoint` is the structure that attaches a block number to a
1820     ///  given value, the block number attached is the one that last changed the
1821     ///  value
1822     struct Checkpoint {
1823 
1824         // `fromBlock` is the block number that the value was generated from
1825         uint128 fromBlock;
1826 
1827         // `value` is the amount of tokens at a specific block number
1828         uint128 value;
1829     }
1830 
1831     // `parentToken` is the Token address that was cloned to produce this token;
1832     //  it will be 0x0 for a token that was not cloned
1833     MiniMeToken public parentToken;
1834 
1835     // `parentSnapShotBlock` is the block number from the Parent Token that was
1836     //  used to determine the initial distribution of the Clone Token
1837     uint public parentSnapShotBlock;
1838 
1839     // `creationBlock` is the block number that the Clone Token was created
1840     uint public creationBlock;
1841 
1842     // `balances` is the map that tracks the balance of each address, in this
1843     //  contract when the balance changes the block number that the change
1844     //  occurred is also included in the map
1845     mapping (address => Checkpoint[]) balances;
1846 
1847     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
1848     mapping (address => mapping (address => uint256)) allowed;
1849 
1850     // Tracks the history of the `totalSupply` of the token
1851     Checkpoint[] totalSupplyHistory;
1852 
1853     // Flag that determines if the token is transferable or not.
1854     bool public transfersEnabled;
1855 
1856     // The factory used to create new clone tokens
1857     MiniMeTokenFactory public tokenFactory;
1858 
1859 ////////////////
1860 // Constructor
1861 ////////////////
1862 
1863     /// @notice Constructor to create a MiniMeToken
1864     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
1865     ///  will create the Clone token contracts, the token factory needs to be
1866     ///  deployed first
1867     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
1868     ///  new token
1869     /// @param _parentSnapShotBlock Block of the parent token that will
1870     ///  determine the initial distribution of the clone token, set to 0 if it
1871     ///  is a new token
1872     /// @param _tokenName Name of the new token
1873     /// @param _decimalUnits Number of decimals of the new token
1874     /// @param _tokenSymbol Token Symbol for the new token
1875     /// @param _transfersEnabled If true, tokens will be able to be transferred
1876     function MiniMeToken(
1877         MiniMeTokenFactory _tokenFactory,
1878         MiniMeToken _parentToken,
1879         uint _parentSnapShotBlock,
1880         string _tokenName,
1881         uint8 _decimalUnits,
1882         string _tokenSymbol,
1883         bool _transfersEnabled
1884     )  public
1885     {
1886         tokenFactory = _tokenFactory;
1887         name = _tokenName;                                 // Set the name
1888         decimals = _decimalUnits;                          // Set the decimals
1889         symbol = _tokenSymbol;                             // Set the symbol
1890         parentToken = _parentToken;
1891         parentSnapShotBlock = _parentSnapShotBlock;
1892         transfersEnabled = _transfersEnabled;
1893         creationBlock = block.number;
1894     }
1895 
1896 
1897 ///////////////////
1898 // ERC20 Methods
1899 ///////////////////
1900 
1901     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
1902     /// @param _to The address of the recipient
1903     /// @param _amount The amount of tokens to be transferred
1904     /// @return Whether the transfer was successful or not
1905     function transfer(address _to, uint256 _amount) public returns (bool success) {
1906         require(transfersEnabled);
1907         return doTransfer(msg.sender, _to, _amount);
1908     }
1909 
1910     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1911     ///  is approved by `_from`
1912     /// @param _from The address holding the tokens being transferred
1913     /// @param _to The address of the recipient
1914     /// @param _amount The amount of tokens to be transferred
1915     /// @return True if the transfer was successful
1916     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
1917 
1918         // The controller of this contract can move tokens around at will,
1919         //  this is important to recognize! Confirm that you trust the
1920         //  controller of this contract, which in most situations should be
1921         //  another open source smart contract or 0x0
1922         if (msg.sender != controller) {
1923             require(transfersEnabled);
1924 
1925             // The standard ERC 20 transferFrom functionality
1926             if (allowed[_from][msg.sender] < _amount)
1927                 return false;
1928             allowed[_from][msg.sender] -= _amount;
1929         }
1930         return doTransfer(_from, _to, _amount);
1931     }
1932 
1933     /// @dev This is the actual transfer function in the token contract, it can
1934     ///  only be called by other functions in this contract.
1935     /// @param _from The address holding the tokens being transferred
1936     /// @param _to The address of the recipient
1937     /// @param _amount The amount of tokens to be transferred
1938     /// @return True if the transfer was successful
1939     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
1940         if (_amount == 0) {
1941             return true;
1942         }
1943         require(parentSnapShotBlock < block.number);
1944         // Do not allow transfer to 0x0 or the token contract itself
1945         require((_to != 0) && (_to != address(this)));
1946         // If the amount being transfered is more than the balance of the
1947         //  account the transfer returns false
1948         var previousBalanceFrom = balanceOfAt(_from, block.number);
1949         if (previousBalanceFrom < _amount) {
1950             return false;
1951         }
1952         // Alerts the token controller of the transfer
1953         if (isContract(controller)) {
1954             // Adding the ` == true` makes the linter shut up so...
1955             require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
1956         }
1957         // First update the balance array with the new value for the address
1958         //  sending the tokens
1959         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
1960         // Then update the balance array with the new value for the address
1961         //  receiving the tokens
1962         var previousBalanceTo = balanceOfAt(_to, block.number);
1963         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
1964         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
1965         // An event to make the transfer easy to find on the blockchain
1966         Transfer(_from, _to, _amount);
1967         return true;
1968     }
1969 
1970     /// @param _owner The address that's balance is being requested
1971     /// @return The balance of `_owner` at the current block
1972     function balanceOf(address _owner) public constant returns (uint256 balance) {
1973         return balanceOfAt(_owner, block.number);
1974     }
1975 
1976     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1977     ///  its behalf. This is a modified version of the ERC20 approve function
1978     ///  to be a little bit safer
1979     /// @param _spender The address of the account able to transfer the tokens
1980     /// @param _amount The amount of tokens to be approved for transfer
1981     /// @return True if the approval was successful
1982     function approve(address _spender, uint256 _amount) public returns (bool success) {
1983         require(transfersEnabled);
1984 
1985         // To change the approve amount you first have to reduce the addresses`
1986         //  allowance to zero by calling `approve(_spender,0)` if it is not
1987         //  already 0 to mitigate the race condition described here:
1988         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1989         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
1990 
1991         // Alerts the token controller of the approve function call
1992         if (isContract(controller)) {
1993             // Adding the ` == true` makes the linter shut up so...
1994             require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
1995         }
1996 
1997         allowed[msg.sender][_spender] = _amount;
1998         Approval(msg.sender, _spender, _amount);
1999         return true;
2000     }
2001 
2002     /// @dev This function makes it easy to read the `allowed[]` map
2003     /// @param _owner The address of the account that owns the token
2004     /// @param _spender The address of the account able to transfer the tokens
2005     /// @return Amount of remaining tokens of _owner that _spender is allowed
2006     ///  to spend
2007     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
2008         return allowed[_owner][_spender];
2009     }
2010 
2011     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
2012     ///  its behalf, and then a function is triggered in the contract that is
2013     ///  being approved, `_spender`. This allows users to use their tokens to
2014     ///  interact with contracts in one function call instead of two
2015     /// @param _spender The address of the contract able to transfer the tokens
2016     /// @param _amount The amount of tokens to be approved for transfer
2017     /// @return True if the function call was successful
2018     function approveAndCall(ApproveAndCallFallBack _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
2019         require(approve(_spender, _amount));
2020 
2021         _spender.receiveApproval(
2022             msg.sender,
2023             _amount,
2024             this,
2025             _extraData
2026         );
2027 
2028         return true;
2029     }
2030 
2031     /// @dev This function makes it easy to get the total number of tokens
2032     /// @return The total number of tokens
2033     function totalSupply() public constant returns (uint) {
2034         return totalSupplyAt(block.number);
2035     }
2036 
2037 
2038 ////////////////
2039 // Query balance and totalSupply in History
2040 ////////////////
2041 
2042     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
2043     /// @param _owner The address from which the balance will be retrieved
2044     /// @param _blockNumber The block number when the balance is queried
2045     /// @return The balance at `_blockNumber`
2046     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
2047 
2048         // These next few lines are used when the balance of the token is
2049         //  requested before a check point was ever created for this token, it
2050         //  requires that the `parentToken.balanceOfAt` be queried at the
2051         //  genesis block for that token as this contains initial balance of
2052         //  this token
2053         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
2054             if (address(parentToken) != 0) {
2055                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
2056             } else {
2057                 // Has no parent
2058                 return 0;
2059             }
2060 
2061         // This will return the expected balance during normal situations
2062         } else {
2063             return getValueAt(balances[_owner], _blockNumber);
2064         }
2065     }
2066 
2067     /// @notice Total amount of tokens at a specific `_blockNumber`.
2068     /// @param _blockNumber The block number when the totalSupply is queried
2069     /// @return The total amount of tokens at `_blockNumber`
2070     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
2071 
2072         // These next few lines are used when the totalSupply of the token is
2073         //  requested before a check point was ever created for this token, it
2074         //  requires that the `parentToken.totalSupplyAt` be queried at the
2075         //  genesis block for this token as that contains totalSupply of this
2076         //  token at this block number.
2077         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
2078             if (address(parentToken) != 0) {
2079                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
2080             } else {
2081                 return 0;
2082             }
2083 
2084         // This will return the expected totalSupply during normal situations
2085         } else {
2086             return getValueAt(totalSupplyHistory, _blockNumber);
2087         }
2088     }
2089 
2090 ////////////////
2091 // Clone Token Method
2092 ////////////////
2093 
2094     /// @notice Creates a new clone token with the initial distribution being
2095     ///  this token at `_snapshotBlock`
2096     /// @param _cloneTokenName Name of the clone token
2097     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
2098     /// @param _cloneTokenSymbol Symbol of the clone token
2099     /// @param _snapshotBlock Block when the distribution of the parent token is
2100     ///  copied to set the initial distribution of the new clone token;
2101     ///  if the block is zero than the actual block, the current block is used
2102     /// @param _transfersEnabled True if transfers are allowed in the clone
2103     /// @return The address of the new MiniMeToken Contract
2104     function createCloneToken(
2105         string _cloneTokenName,
2106         uint8 _cloneDecimalUnits,
2107         string _cloneTokenSymbol,
2108         uint _snapshotBlock,
2109         bool _transfersEnabled
2110     ) public returns(MiniMeToken)
2111     {
2112         uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
2113 
2114         MiniMeToken cloneToken = tokenFactory.createCloneToken(
2115             this,
2116             snapshot,
2117             _cloneTokenName,
2118             _cloneDecimalUnits,
2119             _cloneTokenSymbol,
2120             _transfersEnabled
2121         );
2122 
2123         cloneToken.changeController(msg.sender);
2124 
2125         // An event to make the token easy to find on the blockchain
2126         NewCloneToken(address(cloneToken), snapshot);
2127         return cloneToken;
2128     }
2129 
2130 ////////////////
2131 // Generate and destroy tokens
2132 ////////////////
2133 
2134     /// @notice Generates `_amount` tokens that are assigned to `_owner`
2135     /// @param _owner The address that will be assigned the new tokens
2136     /// @param _amount The quantity of tokens generated
2137     /// @return True if the tokens are generated correctly
2138     function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
2139         uint curTotalSupply = totalSupply();
2140         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
2141         uint previousBalanceTo = balanceOf(_owner);
2142         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
2143         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
2144         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
2145         Transfer(0, _owner, _amount);
2146         return true;
2147     }
2148 
2149 
2150     /// @notice Burns `_amount` tokens from `_owner`
2151     /// @param _owner The address that will lose the tokens
2152     /// @param _amount The quantity of tokens to burn
2153     /// @return True if the tokens are burned correctly
2154     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
2155         uint curTotalSupply = totalSupply();
2156         require(curTotalSupply >= _amount);
2157         uint previousBalanceFrom = balanceOf(_owner);
2158         require(previousBalanceFrom >= _amount);
2159         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
2160         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
2161         Transfer(_owner, 0, _amount);
2162         return true;
2163     }
2164 
2165 ////////////////
2166 // Enable tokens transfers
2167 ////////////////
2168 
2169 
2170     /// @notice Enables token holders to transfer their tokens freely if true
2171     /// @param _transfersEnabled True if transfers are allowed in the clone
2172     function enableTransfers(bool _transfersEnabled) onlyController public {
2173         transfersEnabled = _transfersEnabled;
2174     }
2175 
2176 ////////////////
2177 // Internal helper functions to query and set a value in a snapshot array
2178 ////////////////
2179 
2180     /// @dev `getValueAt` retrieves the number of tokens at a given block number
2181     /// @param checkpoints The history of values being queried
2182     /// @param _block The block number to retrieve the value at
2183     /// @return The number of tokens being queried
2184     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
2185         if (checkpoints.length == 0)
2186             return 0;
2187 
2188         // Shortcut for the actual value
2189         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
2190             return checkpoints[checkpoints.length-1].value;
2191         if (_block < checkpoints[0].fromBlock)
2192             return 0;
2193 
2194         // Binary search of the value in the array
2195         uint min = 0;
2196         uint max = checkpoints.length-1;
2197         while (max > min) {
2198             uint mid = (max + min + 1) / 2;
2199             if (checkpoints[mid].fromBlock<=_block) {
2200                 min = mid;
2201             } else {
2202                 max = mid-1;
2203             }
2204         }
2205         return checkpoints[min].value;
2206     }
2207 
2208     /// @dev `updateValueAtNow` used to update the `balances` map and the
2209     ///  `totalSupplyHistory`
2210     /// @param checkpoints The history of data being updated
2211     /// @param _value The new number of tokens
2212     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
2213         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
2214             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
2215             newCheckPoint.fromBlock = uint128(block.number);
2216             newCheckPoint.value = uint128(_value);
2217         } else {
2218             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
2219             oldCheckPoint.value = uint128(_value);
2220         }
2221     }
2222 
2223     /// @dev Internal function to determine if an address is a contract
2224     /// @param _addr The address being queried
2225     /// @return True if `_addr` is a contract
2226     function isContract(address _addr) constant internal returns(bool) {
2227         uint size;
2228         if (_addr == 0)
2229             return false;
2230 
2231         assembly {
2232             size := extcodesize(_addr)
2233         }
2234 
2235         return size>0;
2236     }
2237 
2238     /// @dev Helper function to return a min betwen the two uints
2239     function min(uint a, uint b) pure internal returns (uint) {
2240         return a < b ? a : b;
2241     }
2242 
2243     /// @notice The fallback function: If the contract's controller has not been
2244     ///  set to 0, then the `proxyPayment` method is called which relays the
2245     ///  ether and creates tokens as described in the token controller contract
2246     function () external payable {
2247         require(isContract(controller));
2248         // Adding the ` == true` makes the linter shut up so...
2249         require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
2250     }
2251 
2252 //////////
2253 // Safety Methods
2254 //////////
2255 
2256     /// @notice This method can be used by the controller to extract mistakenly
2257     ///  sent tokens to this contract.
2258     /// @param _token The address of the token contract that you want to recover
2259     ///  set to 0 in case you want to extract ether.
2260     function claimTokens(address _token) onlyController public {
2261         if (_token == 0x0) {
2262             controller.transfer(this.balance);
2263             return;
2264         }
2265 
2266         MiniMeToken token = MiniMeToken(_token);
2267         uint balance = token.balanceOf(this);
2268         token.transfer(controller, balance);
2269         ClaimedTokens(_token, controller, balance);
2270     }
2271 
2272 ////////////////
2273 // Events
2274 ////////////////
2275     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
2276     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
2277     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
2278     event Approval(
2279         address indexed _owner,
2280         address indexed _spender,
2281         uint256 _amount
2282         );
2283 
2284 }
2285 
2286 
2287 ////////////////
2288 // MiniMeTokenFactory
2289 ////////////////
2290 
2291 /// @dev This contract is used to generate clone contracts from a contract.
2292 ///  In solidity this is the way to create a contract from a contract of the
2293 ///  same class
2294 contract MiniMeTokenFactory {
2295 
2296     /// @notice Update the DApp by creating a new token with new functionalities
2297     ///  the msg.sender becomes the controller of this clone token
2298     /// @param _parentToken Address of the token being cloned
2299     /// @param _snapshotBlock Block of the parent token that will
2300     ///  determine the initial distribution of the clone token
2301     /// @param _tokenName Name of the new token
2302     /// @param _decimalUnits Number of decimals of the new token
2303     /// @param _tokenSymbol Token Symbol for the new token
2304     /// @param _transfersEnabled If true, tokens will be able to be transferred
2305     /// @return The address of the new token contract
2306     function createCloneToken(
2307         MiniMeToken _parentToken,
2308         uint _snapshotBlock,
2309         string _tokenName,
2310         uint8 _decimalUnits,
2311         string _tokenSymbol,
2312         bool _transfersEnabled
2313     ) public returns (MiniMeToken)
2314     {
2315         MiniMeToken newToken = new MiniMeToken(
2316             this,
2317             _parentToken,
2318             _snapshotBlock,
2319             _tokenName,
2320             _decimalUnits,
2321             _tokenSymbol,
2322             _transfersEnabled
2323         );
2324 
2325         newToken.changeController(msg.sender);
2326         return newToken;
2327     }
2328 }
2329 // File: @aragon/apps-voting/contracts/Voting.sol
2330 /*
2331  * SPDX-License-Identitifer:    GPL-3.0-or-later
2332  */
2333 
2334 pragma solidity 0.4.24;
2335 
2336 
2337 
2338 
2339 
2340 
2341 
2342 contract Voting is IForwarder, AragonApp {
2343     using SafeMath for uint256;
2344     using SafeMath64 for uint64;
2345 
2346     bytes32 public constant CREATE_VOTES_ROLE = keccak256("CREATE_VOTES_ROLE");
2347     bytes32 public constant MODIFY_SUPPORT_ROLE = keccak256("MODIFY_SUPPORT_ROLE");
2348     bytes32 public constant MODIFY_QUORUM_ROLE = keccak256("MODIFY_QUORUM_ROLE");
2349 
2350     uint64 public constant PCT_BASE = 10 ** 18; // 0% = 0; 1% = 10^16; 100% = 10^18
2351 
2352     string private constant ERROR_NO_VOTE = "VOTING_NO_VOTE";
2353     string private constant ERROR_INIT_PCTS = "VOTING_INIT_PCTS";
2354     string private constant ERROR_CHANGE_SUPPORT_PCTS = "VOTING_CHANGE_SUPPORT_PCTS";
2355     string private constant ERROR_CHANGE_QUORUM_PCTS = "VOTING_CHANGE_QUORUM_PCTS";
2356     string private constant ERROR_INIT_SUPPORT_TOO_BIG = "VOTING_INIT_SUPPORT_TOO_BIG";
2357     string private constant ERROR_CHANGE_SUPPORT_TOO_BIG = "VOTING_CHANGE_SUPP_TOO_BIG";
2358     string private constant ERROR_CAN_NOT_VOTE = "VOTING_CAN_NOT_VOTE";
2359     string private constant ERROR_CAN_NOT_EXECUTE = "VOTING_CAN_NOT_EXECUTE";
2360     string private constant ERROR_CAN_NOT_FORWARD = "VOTING_CAN_NOT_FORWARD";
2361     string private constant ERROR_NO_VOTING_POWER = "VOTING_NO_VOTING_POWER";
2362 
2363     enum VoterState { Absent, Yea, Nay }
2364 
2365     struct Vote {
2366         bool executed;
2367         uint64 startDate;
2368         uint64 snapshotBlock;
2369         uint64 supportRequiredPct;
2370         uint64 minAcceptQuorumPct;
2371         uint256 yea;
2372         uint256 nay;
2373         uint256 votingPower;
2374         bytes executionScript;
2375         mapping (address => VoterState) voters;
2376     }
2377 
2378     MiniMeToken public token;
2379     uint64 public supportRequiredPct;
2380     uint64 public minAcceptQuorumPct;
2381     uint64 public voteTime;
2382 
2383     // We are mimicing an array, we use a mapping instead to make app upgrade more graceful
2384     mapping (uint256 => Vote) internal votes;
2385     uint256 public votesLength;
2386 
2387     event StartVote(uint256 indexed voteId, address indexed creator, string metadata);
2388     event CastVote(uint256 indexed voteId, address indexed voter, bool supports, uint256 stake);
2389     event ExecuteVote(uint256 indexed voteId);
2390     event ChangeSupportRequired(uint64 supportRequiredPct);
2391     event ChangeMinQuorum(uint64 minAcceptQuorumPct);
2392 
2393     modifier voteExists(uint256 _voteId) {
2394         require(_voteId < votesLength, ERROR_NO_VOTE);
2395         _;
2396     }
2397 
2398     /**
2399     * @notice Initialize Voting app with `_token.symbol(): string` for governance, minimum support of `@formatPct(_supportRequiredPct)`%, minimum acceptance quorum of `@formatPct(_minAcceptQuorumPct)`%, and a voting duration of `@transformTime(_voteTime)`
2400     * @param _token MiniMeToken Address that will be used as governance token
2401     * @param _supportRequiredPct Percentage of yeas in casted votes for a vote to succeed (expressed as a percentage of 10^18; eg. 10^16 = 1%, 10^18 = 100%)
2402     * @param _minAcceptQuorumPct Percentage of yeas in total possible votes for a vote to succeed (expressed as a percentage of 10^18; eg. 10^16 = 1%, 10^18 = 100%)
2403     * @param _voteTime Seconds that a vote will be open for token holders to vote (unless enough yeas or nays have been cast to make an early decision)
2404     */
2405     function initialize(
2406         MiniMeToken _token,
2407         uint64 _supportRequiredPct,
2408         uint64 _minAcceptQuorumPct,
2409         uint64 _voteTime
2410     )
2411         external
2412         onlyInit
2413     {
2414         initialized();
2415 
2416         require(_minAcceptQuorumPct <= _supportRequiredPct, ERROR_INIT_PCTS);
2417         require(_supportRequiredPct < PCT_BASE, ERROR_INIT_SUPPORT_TOO_BIG);
2418 
2419         token = _token;
2420         supportRequiredPct = _supportRequiredPct;
2421         minAcceptQuorumPct = _minAcceptQuorumPct;
2422         voteTime = _voteTime;
2423     }
2424 
2425     /**
2426     * @notice Change required support to `@formatPct(_supportRequiredPct)`%
2427     * @param _supportRequiredPct New required support
2428     */
2429     function changeSupportRequiredPct(uint64 _supportRequiredPct)
2430         external
2431         authP(MODIFY_SUPPORT_ROLE, arr(uint256(_supportRequiredPct), uint256(supportRequiredPct)))
2432     {
2433         require(minAcceptQuorumPct <= _supportRequiredPct, ERROR_CHANGE_SUPPORT_PCTS);
2434         require(_supportRequiredPct < PCT_BASE, ERROR_CHANGE_SUPPORT_TOO_BIG);
2435         supportRequiredPct = _supportRequiredPct;
2436 
2437         emit ChangeSupportRequired(_supportRequiredPct);
2438     }
2439 
2440     /**
2441     * @notice Change minimum acceptance quorum to `@formatPct(_minAcceptQuorumPct)`%
2442     * @param _minAcceptQuorumPct New acceptance quorum
2443     */
2444     function changeMinAcceptQuorumPct(uint64 _minAcceptQuorumPct)
2445         external
2446         authP(MODIFY_QUORUM_ROLE, arr(uint256(_minAcceptQuorumPct), uint256(minAcceptQuorumPct)))
2447     {
2448         require(_minAcceptQuorumPct <= supportRequiredPct, ERROR_CHANGE_QUORUM_PCTS);
2449         minAcceptQuorumPct = _minAcceptQuorumPct;
2450 
2451         emit ChangeMinQuorum(_minAcceptQuorumPct);
2452     }
2453 
2454     /**
2455     * @notice Create a new vote about "`_metadata`"
2456     * @param _executionScript EVM script to be executed on approval
2457     * @param _metadata Vote metadata
2458     * @return voteId Id for newly created vote
2459     */
2460     function newVote(bytes _executionScript, string _metadata) external auth(CREATE_VOTES_ROLE) returns (uint256 voteId) {
2461         return _newVote(_executionScript, _metadata, true, true);
2462     }
2463 
2464     /**
2465     * @notice Create a new vote about "`_metadata`"
2466     * @param _executionScript EVM script to be executed on approval
2467     * @param _metadata Vote metadata
2468     * @param _castVote Whether to also cast newly created vote
2469     * @param _executesIfDecided Whether to also immediately execute newly created vote if decided
2470     * @return voteId id for newly created vote
2471     */
2472     function newVote(bytes _executionScript, string _metadata, bool _castVote, bool _executesIfDecided)
2473         external
2474         auth(CREATE_VOTES_ROLE)
2475         returns (uint256 voteId)
2476     {
2477         return _newVote(_executionScript, _metadata, _castVote, _executesIfDecided);
2478     }
2479 
2480     /**
2481     * @notice Vote `_supports ? 'yea' : 'nay'` in vote #`_voteId`
2482     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
2483     *      created via `newVote(),` which requires initialization
2484     * @param _voteId Id for vote
2485     * @param _supports Whether voter supports the vote
2486     * @param _executesIfDecided Whether the vote should execute its action if it becomes decided
2487     */
2488     function vote(uint256 _voteId, bool _supports, bool _executesIfDecided) external voteExists(_voteId) {
2489         require(canVote(_voteId, msg.sender), ERROR_CAN_NOT_VOTE);
2490         _vote(_voteId, _supports, msg.sender, _executesIfDecided);
2491     }
2492 
2493     /**
2494     * @notice Execute vote #`_voteId`
2495     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
2496     *      created via `newVote(),` which requires initialization
2497     * @param _voteId Id for vote
2498     */
2499     function executeVote(uint256 _voteId) external voteExists(_voteId) {
2500         require(canExecute(_voteId), ERROR_CAN_NOT_EXECUTE);
2501         _executeVote(_voteId);
2502     }
2503 
2504     function isForwarder() public pure returns (bool) {
2505         return true;
2506     }
2507 
2508     /**
2509     * @notice Creates a vote to execute the desired action, and casts a support vote if possible
2510     * @dev IForwarder interface conformance
2511     * @param _evmScript Start vote with script
2512     */
2513     function forward(bytes _evmScript) public {
2514         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
2515         _newVote(_evmScript, "", true, true);
2516     }
2517 
2518     function canForward(address _sender, bytes) public view returns (bool) {
2519         // Note that `canPerform()` implicitly does an initialization check itself
2520         return canPerform(_sender, CREATE_VOTES_ROLE, arr());
2521     }
2522 
2523     function canVote(uint256 _voteId, address _voter) public view voteExists(_voteId) returns (bool) {
2524         Vote storage vote_ = votes[_voteId];
2525 
2526         return _isVoteOpen(vote_) && token.balanceOfAt(_voter, vote_.snapshotBlock) > 0;
2527     }
2528 
2529     function canExecute(uint256 _voteId) public view voteExists(_voteId) returns (bool) {
2530         Vote storage vote_ = votes[_voteId];
2531 
2532         if (vote_.executed) {
2533             return false;
2534         }
2535 
2536         // Voting is already decided
2537         if (_isValuePct(vote_.yea, vote_.votingPower, vote_.supportRequiredPct)) {
2538             return true;
2539         }
2540 
2541         uint256 totalVotes = vote_.yea.add(vote_.nay);
2542 
2543         // Vote ended?
2544         if (_isVoteOpen(vote_)) {
2545             return false;
2546         }
2547         // Has enough support?
2548         if (!_isValuePct(vote_.yea, totalVotes, vote_.supportRequiredPct)) {
2549             return false;
2550         }
2551         // Has min quorum?
2552         if (!_isValuePct(vote_.yea, vote_.votingPower, vote_.minAcceptQuorumPct)) {
2553             return false;
2554         }
2555 
2556         return true;
2557     }
2558 
2559     function getVote(uint256 _voteId)
2560         public
2561         view
2562         voteExists(_voteId)
2563         returns (
2564             bool open,
2565             bool executed,
2566             uint64 startDate,
2567             uint64 snapshotBlock,
2568             uint64 supportRequired,
2569             uint64 minAcceptQuorum,
2570             uint256 yea,
2571             uint256 nay,
2572             uint256 votingPower,
2573             bytes script
2574         )
2575     {
2576         Vote storage vote_ = votes[_voteId];
2577 
2578         open = _isVoteOpen(vote_);
2579         executed = vote_.executed;
2580         startDate = vote_.startDate;
2581         snapshotBlock = vote_.snapshotBlock;
2582         supportRequired = vote_.supportRequiredPct;
2583         minAcceptQuorum = vote_.minAcceptQuorumPct;
2584         yea = vote_.yea;
2585         nay = vote_.nay;
2586         votingPower = vote_.votingPower;
2587         script = vote_.executionScript;
2588     }
2589 
2590     function getVoterState(uint256 _voteId, address _voter) public view voteExists(_voteId) returns (VoterState) {
2591         return votes[_voteId].voters[_voter];
2592     }
2593 
2594     function _newVote(bytes _executionScript, string _metadata, bool _castVote, bool _executesIfDecided)
2595         internal
2596         returns (uint256 voteId)
2597     {
2598         uint256 votingPower = token.totalSupplyAt(vote_.snapshotBlock);
2599         require(votingPower > 0, ERROR_NO_VOTING_POWER);
2600 
2601         voteId = votesLength++;
2602         Vote storage vote_ = votes[voteId];
2603         vote_.startDate = getTimestamp64();
2604         vote_.snapshotBlock = getBlockNumber64() - 1; // avoid double voting in this very block
2605         vote_.supportRequiredPct = supportRequiredPct;
2606         vote_.minAcceptQuorumPct = minAcceptQuorumPct;
2607         vote_.votingPower = votingPower;
2608         vote_.executionScript = _executionScript;
2609 
2610         emit StartVote(voteId, msg.sender, _metadata);
2611 
2612         if (_castVote && canVote(voteId, msg.sender)) {
2613             _vote(voteId, true, msg.sender, _executesIfDecided);
2614         }
2615     }
2616 
2617     function _vote(
2618         uint256 _voteId,
2619         bool _supports,
2620         address _voter,
2621         bool _executesIfDecided
2622     ) internal
2623     {
2624         Vote storage vote_ = votes[_voteId];
2625 
2626         // This could re-enter, though we can assume the governance token is not malicious
2627         uint256 voterStake = token.balanceOfAt(_voter, vote_.snapshotBlock);
2628         VoterState state = vote_.voters[_voter];
2629 
2630         // If voter had previously voted, decrease count
2631         if (state == VoterState.Yea) {
2632             vote_.yea = vote_.yea.sub(voterStake);
2633         } else if (state == VoterState.Nay) {
2634             vote_.nay = vote_.nay.sub(voterStake);
2635         }
2636 
2637         if (_supports) {
2638             vote_.yea = vote_.yea.add(voterStake);
2639         } else {
2640             vote_.nay = vote_.nay.add(voterStake);
2641         }
2642 
2643         vote_.voters[_voter] = _supports ? VoterState.Yea : VoterState.Nay;
2644 
2645         emit CastVote(_voteId, _voter, _supports, voterStake);
2646 
2647         if (_executesIfDecided && canExecute(_voteId)) {
2648             _executeVote(_voteId);
2649         }
2650     }
2651 
2652     function _executeVote(uint256 _voteId) internal {
2653         Vote storage vote_ = votes[_voteId];
2654 
2655         vote_.executed = true;
2656 
2657         bytes memory input = new bytes(0); // TODO: Consider input for voting scripts
2658         runScript(vote_.executionScript, input, new address[](0));
2659 
2660         emit ExecuteVote(_voteId);
2661     }
2662 
2663     function _isVoteOpen(Vote storage vote_) internal view returns (bool) {
2664         return getTimestamp64() < vote_.startDate.add(voteTime) && !vote_.executed;
2665     }
2666 
2667     /**
2668     * @dev Calculates whether `_value` is more than a percentage `_pct` of `_total`
2669     */
2670     function _isValuePct(uint256 _value, uint256 _total, uint256 _pct) internal pure returns (bool) {
2671         if (_total == 0) {
2672             return false;
2673         }
2674 
2675         uint256 computedPct = _value.mul(PCT_BASE) / _total;
2676         return computedPct > _pct;
2677     }
2678 }
2679 // File: @aragon/os/contracts/apm/APMNamehash.sol
2680 /*
2681  * SPDX-License-Identitifer:    MIT
2682  */
2683 
2684 pragma solidity ^0.4.24;
2685 
2686 
2687 contract APMNamehash {
2688     /* Hardcoded constants to save gas
2689     bytes32 internal constant APM_NODE = keccak256(abi.encodePacked(ETH_TLD_NODE, keccak256(abi.encodePacked("aragonpm"))));
2690     */
2691     bytes32 internal constant APM_NODE = 0x9065c3e7f7b7ef1ef4e53d2d0b8e0cef02874ab020c1ece79d5f0d3d0111c0ba;
2692 
2693     function apmNamehash(string name) internal pure returns (bytes32) {
2694         return keccak256(abi.encodePacked(APM_NODE, keccak256(bytes(name))));
2695     }
2696 }
2697 // File: @aragon/os/contracts/kernel/KernelStorage.sol
2698 contract KernelStorage {
2699     // namespace => app id => address
2700     mapping (bytes32 => mapping (bytes32 => address)) public apps;
2701     bytes32 public recoveryVaultAppId;
2702 }
2703 // File: @aragon/os/contracts/lib/misc/ERCProxy.sol
2704 /*
2705  * SPDX-License-Identitifer:    MIT
2706  */
2707 
2708 pragma solidity ^0.4.24;
2709 
2710 
2711 contract ERCProxy {
2712     uint256 internal constant FORWARDING = 1;
2713     uint256 internal constant UPGRADEABLE = 2;
2714 
2715     function proxyType() public pure returns (uint256 proxyTypeId);
2716     function implementation() public view returns (address codeAddr);
2717 }
2718 // File: @aragon/os/contracts/common/DelegateProxy.sol
2719 contract DelegateProxy is ERCProxy, IsContract {
2720     uint256 internal constant FWD_GAS_LIMIT = 10000;
2721 
2722     /**
2723     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
2724     * @param _dst Destination address to perform the delegatecall
2725     * @param _calldata Calldata for the delegatecall
2726     */
2727     function delegatedFwd(address _dst, bytes _calldata) internal {
2728         require(isContract(_dst));
2729         uint256 fwdGasLimit = FWD_GAS_LIMIT;
2730 
2731         assembly {
2732             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
2733             let size := returndatasize
2734             let ptr := mload(0x40)
2735             returndatacopy(ptr, 0, size)
2736 
2737             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
2738             // if the call returned error data, forward it
2739             switch result case 0 { revert(ptr, size) }
2740             default { return(ptr, size) }
2741         }
2742     }
2743 }
2744 // File: @aragon/os/contracts/common/DepositableDelegateProxy.sol
2745 contract DepositableDelegateProxy is DepositableStorage, DelegateProxy {
2746     event ProxyDeposit(address sender, uint256 value);
2747 
2748     function () external payable {
2749         // send / transfer
2750         if (gasleft() < FWD_GAS_LIMIT) {
2751             require(msg.value > 0 && msg.data.length == 0);
2752             require(isDepositable());
2753             emit ProxyDeposit(msg.sender, msg.value);
2754         } else { // all calls except for send or transfer
2755             address target = implementation();
2756             delegatedFwd(target, msg.data);
2757         }
2758     }
2759 }
2760 // File: @aragon/os/contracts/apps/AppProxyBase.sol
2761 contract AppProxyBase is AppStorage, DepositableDelegateProxy, KernelNamespaceConstants {
2762     /**
2763     * @dev Initialize AppProxy
2764     * @param _kernel Reference to organization kernel for the app
2765     * @param _appId Identifier for app
2766     * @param _initializePayload Payload for call to be made after setup to initialize
2767     */
2768     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public {
2769         setKernel(_kernel);
2770         setAppId(_appId);
2771 
2772         // Implicit check that kernel is actually a Kernel
2773         // The EVM doesn't actually provide a way for us to make sure, but we can force a revert to
2774         // occur if the kernel is set to 0x0 or a non-code address when we try to call a method on
2775         // it.
2776         address appCode = getAppBase(_appId);
2777 
2778         // If initialize payload is provided, it will be executed
2779         if (_initializePayload.length > 0) {
2780             require(isContract(appCode));
2781             // Cannot make delegatecall as a delegateproxy.delegatedFwd as it
2782             // returns ending execution context and halts contract deployment
2783             require(appCode.delegatecall(_initializePayload));
2784         }
2785     }
2786 
2787     function getAppBase(bytes32 _appId) internal view returns (address) {
2788         return kernel().getApp(KERNEL_APP_BASES_NAMESPACE, _appId);
2789     }
2790 }
2791 // File: @aragon/os/contracts/apps/AppProxyUpgradeable.sol
2792 contract AppProxyUpgradeable is AppProxyBase {
2793     /**
2794     * @dev Initialize AppProxyUpgradeable (makes it an upgradeable Aragon app)
2795     * @param _kernel Reference to organization kernel for the app
2796     * @param _appId Identifier for app
2797     * @param _initializePayload Payload for call to be made after setup to initialize
2798     */
2799     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
2800         AppProxyBase(_kernel, _appId, _initializePayload)
2801         public // solium-disable-line visibility-first
2802     {
2803 
2804     }
2805 
2806     /**
2807      * @dev ERC897, the address the proxy would delegate calls to
2808      */
2809     function implementation() public view returns (address) {
2810         return getAppBase(appId());
2811     }
2812 
2813     /**
2814      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
2815      */
2816     function proxyType() public pure returns (uint256 proxyTypeId) {
2817         return UPGRADEABLE;
2818     }
2819 }
2820 // File: @aragon/os/contracts/apps/AppProxyPinned.sol
2821 contract AppProxyPinned is IsContract, AppProxyBase {
2822     using UnstructuredStorage for bytes32;
2823 
2824     // keccak256("aragonOS.appStorage.pinnedCode")
2825     bytes32 internal constant PINNED_CODE_POSITION = 0xdee64df20d65e53d7f51cb6ab6d921a0a6a638a91e942e1d8d02df28e31c038e;
2826 
2827     /**
2828     * @dev Initialize AppProxyPinned (makes it an un-upgradeable Aragon app)
2829     * @param _kernel Reference to organization kernel for the app
2830     * @param _appId Identifier for app
2831     * @param _initializePayload Payload for call to be made after setup to initialize
2832     */
2833     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
2834         AppProxyBase(_kernel, _appId, _initializePayload)
2835         public // solium-disable-line visibility-first
2836     {
2837         setPinnedCode(getAppBase(_appId));
2838         require(isContract(pinnedCode()));
2839     }
2840 
2841     /**
2842      * @dev ERC897, the address the proxy would delegate calls to
2843      */
2844     function implementation() public view returns (address) {
2845         return pinnedCode();
2846     }
2847 
2848     /**
2849      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
2850      */
2851     function proxyType() public pure returns (uint256 proxyTypeId) {
2852         return FORWARDING;
2853     }
2854 
2855     function setPinnedCode(address _pinnedCode) internal {
2856         PINNED_CODE_POSITION.setStorageAddress(_pinnedCode);
2857     }
2858 
2859     function pinnedCode() internal view returns (address) {
2860         return PINNED_CODE_POSITION.getStorageAddress();
2861     }
2862 }
2863 // File: @aragon/os/contracts/factory/AppProxyFactory.sol
2864 contract AppProxyFactory {
2865     event NewAppProxy(address proxy, bool isUpgradeable, bytes32 appId);
2866 
2867     function newAppProxy(IKernel _kernel, bytes32 _appId) public returns (AppProxyUpgradeable) {
2868         return newAppProxy(_kernel, _appId, new bytes(0));
2869     }
2870 
2871     function newAppProxy(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyUpgradeable) {
2872         AppProxyUpgradeable proxy = new AppProxyUpgradeable(_kernel, _appId, _initializePayload);
2873         emit NewAppProxy(address(proxy), true, _appId);
2874         return proxy;
2875     }
2876 
2877     function newAppProxyPinned(IKernel _kernel, bytes32 _appId) public returns (AppProxyPinned) {
2878         return newAppProxyPinned(_kernel, _appId, new bytes(0));
2879     }
2880 
2881     function newAppProxyPinned(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyPinned) {
2882         AppProxyPinned proxy = new AppProxyPinned(_kernel, _appId, _initializePayload);
2883         emit NewAppProxy(address(proxy), false, _appId);
2884         return proxy;
2885     }
2886 }
2887 // File: @aragon/os/contracts/kernel/Kernel.sol
2888 // solium-disable-next-line max-len
2889 contract Kernel is IKernel, KernelStorage, KernelAppIds, KernelNamespaceConstants, Petrifiable, IsContract, VaultRecoverable, AppProxyFactory, ACLSyntaxSugar {
2890     /* Hardcoded constants to save gas
2891     bytes32 public constant APP_MANAGER_ROLE = keccak256("APP_MANAGER_ROLE");
2892     */
2893     bytes32 public constant APP_MANAGER_ROLE = 0xb6d92708f3d4817afc106147d969e229ced5c46e65e0a5002a0d391287762bd0;
2894 
2895     string private constant ERROR_APP_NOT_CONTRACT = "KERNEL_APP_NOT_CONTRACT";
2896     string private constant ERROR_INVALID_APP_CHANGE = "KERNEL_INVALID_APP_CHANGE";
2897     string private constant ERROR_AUTH_FAILED = "KERNEL_AUTH_FAILED";
2898 
2899     /**
2900     * @dev Constructor that allows the deployer to choose if the base instance should be petrified immediately.
2901     * @param _shouldPetrify Immediately petrify this instance so that it can never be initialized
2902     */
2903     constructor(bool _shouldPetrify) public {
2904         if (_shouldPetrify) {
2905             petrify();
2906         }
2907     }
2908 
2909     /**
2910     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
2911     * @notice Initializes a kernel instance along with its ACL and sets `_permissionsCreator` as the entity that can create other permissions
2912     * @param _baseAcl Address of base ACL app
2913     * @param _permissionsCreator Entity that will be given permission over createPermission
2914     */
2915     function initialize(IACL _baseAcl, address _permissionsCreator) public onlyInit {
2916         initialized();
2917 
2918         // Set ACL base
2919         _setApp(KERNEL_APP_BASES_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, _baseAcl);
2920 
2921         // Create ACL instance and attach it as the default ACL app
2922         IACL acl = IACL(newAppProxy(this, KERNEL_DEFAULT_ACL_APP_ID));
2923         acl.initialize(_permissionsCreator);
2924         _setApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, acl);
2925 
2926         recoveryVaultAppId = KERNEL_DEFAULT_VAULT_APP_ID;
2927     }
2928 
2929     /**
2930     * @dev Create a new instance of an app linked to this kernel
2931     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`
2932     * @param _appId Identifier for app
2933     * @param _appBase Address of the app's base implementation
2934     * @return AppProxy instance
2935     */
2936     function newAppInstance(bytes32 _appId, address _appBase)
2937         public
2938         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
2939         returns (ERCProxy appProxy)
2940     {
2941         return newAppInstance(_appId, _appBase, new bytes(0), false);
2942     }
2943 
2944     /**
2945     * @dev Create a new instance of an app linked to this kernel and set its base
2946     *      implementation if it was not already set
2947     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
2948     * @param _appId Identifier for app
2949     * @param _appBase Address of the app's base implementation
2950     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
2951     * @param _setDefault Whether the app proxy app is the default one.
2952     *        Useful when the Kernel needs to know of an instance of a particular app,
2953     *        like Vault for escape hatch mechanism.
2954     * @return AppProxy instance
2955     */
2956     function newAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
2957         public
2958         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
2959         returns (ERCProxy appProxy)
2960     {
2961         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
2962         appProxy = newAppProxy(this, _appId, _initializePayload);
2963         // By calling setApp directly and not the internal functions, we make sure the params are checked
2964         // and it will only succeed if sender has permissions to set something to the namespace.
2965         if (_setDefault) {
2966             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
2967         }
2968     }
2969 
2970     /**
2971     * @dev Create a new pinned instance of an app linked to this kernel
2972     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`.
2973     * @param _appId Identifier for app
2974     * @param _appBase Address of the app's base implementation
2975     * @return AppProxy instance
2976     */
2977     function newPinnedAppInstance(bytes32 _appId, address _appBase)
2978         public
2979         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
2980         returns (ERCProxy appProxy)
2981     {
2982         return newPinnedAppInstance(_appId, _appBase, new bytes(0), false);
2983     }
2984 
2985     /**
2986     * @dev Create a new pinned instance of an app linked to this kernel and set
2987     *      its base implementation if it was not already set
2988     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
2989     * @param _appId Identifier for app
2990     * @param _appBase Address of the app's base implementation
2991     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
2992     * @param _setDefault Whether the app proxy app is the default one.
2993     *        Useful when the Kernel needs to know of an instance of a particular app,
2994     *        like Vault for escape hatch mechanism.
2995     * @return AppProxy instance
2996     */
2997     function newPinnedAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
2998         public
2999         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
3000         returns (ERCProxy appProxy)
3001     {
3002         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
3003         appProxy = newAppProxyPinned(this, _appId, _initializePayload);
3004         // By calling setApp directly and not the internal functions, we make sure the params are checked
3005         // and it will only succeed if sender has permissions to set something to the namespace.
3006         if (_setDefault) {
3007             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
3008         }
3009     }
3010 
3011     /**
3012     * @dev Set the resolving address of an app instance or base implementation
3013     * @notice Set the resolving address of `_appId` in namespace `_namespace` to `_app`
3014     * @param _namespace App namespace to use
3015     * @param _appId Identifier for app
3016     * @param _app Address of the app instance or base implementation
3017     * @return ID of app
3018     */
3019     function setApp(bytes32 _namespace, bytes32 _appId, address _app)
3020         public
3021         auth(APP_MANAGER_ROLE, arr(_namespace, _appId))
3022     {
3023         _setApp(_namespace, _appId, _app);
3024     }
3025 
3026     /**
3027     * @dev Set the default vault id for the escape hatch mechanism
3028     * @param _recoveryVaultAppId Identifier of the recovery vault app
3029     */
3030     function setRecoveryVaultAppId(bytes32 _recoveryVaultAppId)
3031         public
3032         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_ADDR_NAMESPACE, _recoveryVaultAppId))
3033     {
3034         recoveryVaultAppId = _recoveryVaultAppId;
3035     }
3036 
3037     // External access to default app id and namespace constants to mimic default getters for constants
3038     /* solium-disable function-order, mixedcase */
3039     function CORE_NAMESPACE() external pure returns (bytes32) { return KERNEL_CORE_NAMESPACE; }
3040     function APP_BASES_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_BASES_NAMESPACE; }
3041     function APP_ADDR_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_ADDR_NAMESPACE; }
3042     function KERNEL_APP_ID() external pure returns (bytes32) { return KERNEL_CORE_APP_ID; }
3043     function DEFAULT_ACL_APP_ID() external pure returns (bytes32) { return KERNEL_DEFAULT_ACL_APP_ID; }
3044     /* solium-enable function-order, mixedcase */
3045 
3046     /**
3047     * @dev Get the address of an app instance or base implementation
3048     * @param _namespace App namespace to use
3049     * @param _appId Identifier for app
3050     * @return Address of the app
3051     */
3052     function getApp(bytes32 _namespace, bytes32 _appId) public view returns (address) {
3053         return apps[_namespace][_appId];
3054     }
3055 
3056     /**
3057     * @dev Get the address of the recovery Vault instance (to recover funds)
3058     * @return Address of the Vault
3059     */
3060     function getRecoveryVault() public view returns (address) {
3061         return apps[KERNEL_APP_ADDR_NAMESPACE][recoveryVaultAppId];
3062     }
3063 
3064     /**
3065     * @dev Get the installed ACL app
3066     * @return ACL app
3067     */
3068     function acl() public view returns (IACL) {
3069         return IACL(getApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID));
3070     }
3071 
3072     /**
3073     * @dev Function called by apps to check ACL on kernel or to check permission status
3074     * @param _who Sender of the original call
3075     * @param _where Address of the app
3076     * @param _what Identifier for a group of actions in app
3077     * @param _how Extra data for ACL auth
3078     * @return Boolean indicating whether the ACL allows the role or not.
3079     *         Always returns false if the kernel hasn't been initialized yet.
3080     */
3081     function hasPermission(address _who, address _where, bytes32 _what, bytes _how) public view returns (bool) {
3082         IACL defaultAcl = acl();
3083         return address(defaultAcl) != address(0) && // Poor man's initialization check (saves gas)
3084             defaultAcl.hasPermission(_who, _where, _what, _how);
3085     }
3086 
3087     function _setApp(bytes32 _namespace, bytes32 _appId, address _app) internal {
3088         require(isContract(_app), ERROR_APP_NOT_CONTRACT);
3089         apps[_namespace][_appId] = _app;
3090         emit SetApp(_namespace, _appId, _app);
3091     }
3092 
3093     function _setAppIfNew(bytes32 _namespace, bytes32 _appId, address _app) internal {
3094         address app = getApp(_namespace, _appId);
3095         if (app != address(0)) {
3096             // The only way to set an app is if it passes the isContract check, so no need to check it again
3097             require(app == _app, ERROR_INVALID_APP_CHANGE);
3098         } else {
3099             _setApp(_namespace, _appId, _app);
3100         }
3101     }
3102 
3103     modifier auth(bytes32 _role, uint256[] memory params) {
3104         // Force cast the uint256[] into a bytes array, by overwriting its length
3105         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
3106         // with params and a new length, and params becomes invalid from this point forward
3107         bytes memory how;
3108         uint256 byteLength = params.length * 32;
3109         assembly {
3110             how := params
3111             mstore(how, byteLength)
3112         }
3113 
3114         require(hasPermission(msg.sender, address(this), _role, how), ERROR_AUTH_FAILED);
3115         _;
3116     }
3117 }
3118 // File: @aragon/os/contracts/kernel/KernelProxy.sol
3119 contract KernelProxy is KernelStorage, KernelAppIds, KernelNamespaceConstants, IsContract, DepositableDelegateProxy {
3120     /**
3121     * @dev KernelProxy is a proxy contract to a kernel implementation. The implementation
3122     *      can update the reference, which effectively upgrades the contract
3123     * @param _kernelImpl Address of the contract used as implementation for kernel
3124     */
3125     constructor(IKernel _kernelImpl) public {
3126         require(isContract(address(_kernelImpl)));
3127         apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID] = _kernelImpl;
3128     }
3129 
3130     /**
3131      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
3132      */
3133     function proxyType() public pure returns (uint256 proxyTypeId) {
3134         return UPGRADEABLE;
3135     }
3136 
3137     /**
3138     * @dev ERC897, the address the proxy would delegate calls to
3139     */
3140     function implementation() public view returns (address) {
3141         return apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID];
3142     }
3143 }
3144 // File: @aragon/os/contracts/acl/IACLOracle.sol
3145 /*
3146  * SPDX-License-Identitifer:    MIT
3147  */
3148 
3149 pragma solidity ^0.4.24;
3150 
3151 
3152 interface IACLOracle {
3153     function canPerform(address who, address where, bytes32 what, uint256[] how) external view returns (bool);
3154 }
3155 // File: @aragon/os/contracts/acl/ACL.sol
3156 /* solium-disable function-order */
3157 // Allow public initialize() to be first
3158 contract ACL is IACL, TimeHelpers, AragonApp, ACLHelpers {
3159     /* Hardcoded constants to save gas
3160     bytes32 public constant CREATE_PERMISSIONS_ROLE = keccak256("CREATE_PERMISSIONS_ROLE");
3161     */
3162     bytes32 public constant CREATE_PERMISSIONS_ROLE = 0x0b719b33c83b8e5d300c521cb8b54ae9bd933996a14bef8c2f4e0285d2d2400a;
3163 
3164     enum Op { NONE, EQ, NEQ, GT, LT, GTE, LTE, RET, NOT, AND, OR, XOR, IF_ELSE } // op types
3165 
3166     struct Param {
3167         uint8 id;
3168         uint8 op;
3169         uint240 value; // even though value is an uint240 it can store addresses
3170         // in the case of 32 byte hashes losing 2 bytes precision isn't a huge deal
3171         // op and id take less than 1 byte each so it can be kept in 1 sstore
3172     }
3173 
3174     uint8 internal constant BLOCK_NUMBER_PARAM_ID = 200;
3175     uint8 internal constant TIMESTAMP_PARAM_ID    = 201;
3176     // 202 is unused
3177     uint8 internal constant ORACLE_PARAM_ID       = 203;
3178     uint8 internal constant LOGIC_OP_PARAM_ID     = 204;
3179     uint8 internal constant PARAM_VALUE_PARAM_ID  = 205;
3180     // TODO: Add execution times param type?
3181 
3182     /* Hardcoded constant to save gas
3183     bytes32 public constant EMPTY_PARAM_HASH = keccak256(uint256(0));
3184     */
3185     bytes32 public constant EMPTY_PARAM_HASH = 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563;
3186     bytes32 public constant NO_PERMISSION = bytes32(0);
3187     address public constant ANY_ENTITY = address(-1);
3188     address public constant BURN_ENTITY = address(1); // address(0) is already used as "no permission manager"
3189 
3190     uint256 internal constant ORACLE_CHECK_GAS = 30000;
3191 
3192     string private constant ERROR_AUTH_INIT_KERNEL = "ACL_AUTH_INIT_KERNEL";
3193     string private constant ERROR_AUTH_NO_MANAGER = "ACL_AUTH_NO_MANAGER";
3194     string private constant ERROR_EXISTENT_MANAGER = "ACL_EXISTENT_MANAGER";
3195 
3196     // Whether someone has a permission
3197     mapping (bytes32 => bytes32) internal permissions; // permissions hash => params hash
3198     mapping (bytes32 => Param[]) internal permissionParams; // params hash => params
3199 
3200     // Who is the manager of a permission
3201     mapping (bytes32 => address) internal permissionManager;
3202 
3203     event SetPermission(address indexed entity, address indexed app, bytes32 indexed role, bool allowed);
3204     event SetPermissionParams(address indexed entity, address indexed app, bytes32 indexed role, bytes32 paramsHash);
3205     event ChangePermissionManager(address indexed app, bytes32 indexed role, address indexed manager);
3206 
3207     modifier onlyPermissionManager(address _app, bytes32 _role) {
3208         require(msg.sender == getPermissionManager(_app, _role), ERROR_AUTH_NO_MANAGER);
3209         _;
3210     }
3211 
3212     modifier noPermissionManager(address _app, bytes32 _role) {
3213         // only allow permission creation (or re-creation) when there is no manager
3214         require(getPermissionManager(_app, _role) == address(0), ERROR_EXISTENT_MANAGER);
3215         _;
3216     }
3217 
3218     /**
3219     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
3220     * @notice Initialize an ACL instance and set `_permissionsCreator` as the entity that can create other permissions
3221     * @param _permissionsCreator Entity that will be given permission over createPermission
3222     */
3223     function initialize(address _permissionsCreator) public onlyInit {
3224         initialized();
3225         require(msg.sender == address(kernel()), ERROR_AUTH_INIT_KERNEL);
3226 
3227         _createPermission(_permissionsCreator, this, CREATE_PERMISSIONS_ROLE, _permissionsCreator);
3228     }
3229 
3230     /**
3231     * @dev Creates a permission that wasn't previously set and managed.
3232     *      If a created permission is removed it is possible to reset it with createPermission.
3233     *      This is the **ONLY** way to create permissions and set managers to permissions that don't
3234     *      have a manager.
3235     *      In terms of the ACL being initialized, this function implicitly protects all the other
3236     *      state-changing external functions, as they all require the sender to be a manager.
3237     * @notice Create a new permission granting `_entity` the ability to perform actions requiring `_role` on `_app`, setting `_manager` as the permission's manager
3238     * @param _entity Address of the whitelisted entity that will be able to perform the role
3239     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
3240     * @param _role Identifier for the group of actions in app given access to perform
3241     * @param _manager Address of the entity that will be able to grant and revoke the permission further.
3242     */
3243     function createPermission(address _entity, address _app, bytes32 _role, address _manager)
3244         external
3245         auth(CREATE_PERMISSIONS_ROLE)
3246         noPermissionManager(_app, _role)
3247     {
3248         _createPermission(_entity, _app, _role, _manager);
3249     }
3250 
3251     /**
3252     * @dev Grants permission if allowed. This requires `msg.sender` to be the permission manager
3253     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
3254     * @param _entity Address of the whitelisted entity that will be able to perform the role
3255     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
3256     * @param _role Identifier for the group of actions in app given access to perform
3257     */
3258     function grantPermission(address _entity, address _app, bytes32 _role)
3259         external
3260     {
3261         grantPermissionP(_entity, _app, _role, new uint256[](0));
3262     }
3263 
3264     /**
3265     * @dev Grants a permission with parameters if allowed. This requires `msg.sender` to be the permission manager
3266     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
3267     * @param _entity Address of the whitelisted entity that will be able to perform the role
3268     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
3269     * @param _role Identifier for the group of actions in app given access to perform
3270     * @param _params Permission parameters
3271     */
3272     function grantPermissionP(address _entity, address _app, bytes32 _role, uint256[] _params)
3273         public
3274         onlyPermissionManager(_app, _role)
3275     {
3276         bytes32 paramsHash = _params.length > 0 ? _saveParams(_params) : EMPTY_PARAM_HASH;
3277         _setPermission(_entity, _app, _role, paramsHash);
3278     }
3279 
3280     /**
3281     * @dev Revokes permission if allowed. This requires `msg.sender` to be the the permission manager
3282     * @notice Revoke from `_entity` the ability to perform actions requiring `_role` on `_app`
3283     * @param _entity Address of the whitelisted entity to revoke access from
3284     * @param _app Address of the app in which the role will be revoked
3285     * @param _role Identifier for the group of actions in app being revoked
3286     */
3287     function revokePermission(address _entity, address _app, bytes32 _role)
3288         external
3289         onlyPermissionManager(_app, _role)
3290     {
3291         _setPermission(_entity, _app, _role, NO_PERMISSION);
3292     }
3293 
3294     /**
3295     * @notice Set `_newManager` as the manager of `_role` in `_app`
3296     * @param _newManager Address for the new manager
3297     * @param _app Address of the app in which the permission management is being transferred
3298     * @param _role Identifier for the group of actions being transferred
3299     */
3300     function setPermissionManager(address _newManager, address _app, bytes32 _role)
3301         external
3302         onlyPermissionManager(_app, _role)
3303     {
3304         _setPermissionManager(_newManager, _app, _role);
3305     }
3306 
3307     /**
3308     * @notice Remove the manager of `_role` in `_app`
3309     * @param _app Address of the app in which the permission is being unmanaged
3310     * @param _role Identifier for the group of actions being unmanaged
3311     */
3312     function removePermissionManager(address _app, bytes32 _role)
3313         external
3314         onlyPermissionManager(_app, _role)
3315     {
3316         _setPermissionManager(address(0), _app, _role);
3317     }
3318 
3319     /**
3320     * @notice Burn non-existent `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
3321     * @param _app Address of the app in which the permission is being burned
3322     * @param _role Identifier for the group of actions being burned
3323     */
3324     function createBurnedPermission(address _app, bytes32 _role)
3325         external
3326         auth(CREATE_PERMISSIONS_ROLE)
3327         noPermissionManager(_app, _role)
3328     {
3329         _setPermissionManager(BURN_ENTITY, _app, _role);
3330     }
3331 
3332     /**
3333     * @notice Burn `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
3334     * @param _app Address of the app in which the permission is being burned
3335     * @param _role Identifier for the group of actions being burned
3336     */
3337     function burnPermissionManager(address _app, bytes32 _role)
3338         external
3339         onlyPermissionManager(_app, _role)
3340     {
3341         _setPermissionManager(BURN_ENTITY, _app, _role);
3342     }
3343 
3344     /**
3345      * @notice Get parameters for permission array length
3346      * @param _entity Address of the whitelisted entity that will be able to perform the role
3347      * @param _app Address of the app
3348      * @param _role Identifier for a group of actions in app
3349      * @return Length of the array
3350      */
3351     function getPermissionParamsLength(address _entity, address _app, bytes32 _role) external view returns (uint) {
3352         return permissionParams[permissions[permissionHash(_entity, _app, _role)]].length;
3353     }
3354 
3355     /**
3356     * @notice Get parameter for permission
3357     * @param _entity Address of the whitelisted entity that will be able to perform the role
3358     * @param _app Address of the app
3359     * @param _role Identifier for a group of actions in app
3360     * @param _index Index of parameter in the array
3361     * @return Parameter (id, op, value)
3362     */
3363     function getPermissionParam(address _entity, address _app, bytes32 _role, uint _index)
3364         external
3365         view
3366         returns (uint8, uint8, uint240)
3367     {
3368         Param storage param = permissionParams[permissions[permissionHash(_entity, _app, _role)]][_index];
3369         return (param.id, param.op, param.value);
3370     }
3371 
3372     /**
3373     * @dev Get manager for permission
3374     * @param _app Address of the app
3375     * @param _role Identifier for a group of actions in app
3376     * @return address of the manager for the permission
3377     */
3378     function getPermissionManager(address _app, bytes32 _role) public view returns (address) {
3379         return permissionManager[roleHash(_app, _role)];
3380     }
3381 
3382     /**
3383     * @dev Function called by apps to check ACL on kernel or to check permission statu
3384     * @param _who Sender of the original call
3385     * @param _where Address of the app
3386     * @param _where Identifier for a group of actions in app
3387     * @param _how Permission parameters
3388     * @return boolean indicating whether the ACL allows the role or not
3389     */
3390     function hasPermission(address _who, address _where, bytes32 _what, bytes memory _how) public view returns (bool) {
3391         // Force cast the bytes array into a uint256[], by overwriting its length
3392         // Note that the uint256[] doesn't need to be initialized as we immediately overwrite it
3393         // with _how and a new length, and _how becomes invalid from this point forward
3394         uint256[] memory how;
3395         uint256 intsLength = _how.length / 32;
3396         assembly {
3397             how := _how
3398             mstore(how, intsLength)
3399         }
3400 
3401         return hasPermission(_who, _where, _what, how);
3402     }
3403 
3404     function hasPermission(address _who, address _where, bytes32 _what, uint256[] memory _how) public view returns (bool) {
3405         bytes32 whoParams = permissions[permissionHash(_who, _where, _what)];
3406         if (whoParams != NO_PERMISSION && evalParams(whoParams, _who, _where, _what, _how)) {
3407             return true;
3408         }
3409 
3410         bytes32 anyParams = permissions[permissionHash(ANY_ENTITY, _where, _what)];
3411         if (anyParams != NO_PERMISSION && evalParams(anyParams, ANY_ENTITY, _where, _what, _how)) {
3412             return true;
3413         }
3414 
3415         return false;
3416     }
3417 
3418     function hasPermission(address _who, address _where, bytes32 _what) public view returns (bool) {
3419         uint256[] memory empty = new uint256[](0);
3420         return hasPermission(_who, _where, _what, empty);
3421     }
3422 
3423     function evalParams(
3424         bytes32 _paramsHash,
3425         address _who,
3426         address _where,
3427         bytes32 _what,
3428         uint256[] _how
3429     ) public view returns (bool)
3430     {
3431         if (_paramsHash == EMPTY_PARAM_HASH) {
3432             return true;
3433         }
3434 
3435         return _evalParam(_paramsHash, 0, _who, _where, _what, _how);
3436     }
3437 
3438     /**
3439     * @dev Internal createPermission for access inside the kernel (on instantiation)
3440     */
3441     function _createPermission(address _entity, address _app, bytes32 _role, address _manager) internal {
3442         _setPermission(_entity, _app, _role, EMPTY_PARAM_HASH);
3443         _setPermissionManager(_manager, _app, _role);
3444     }
3445 
3446     /**
3447     * @dev Internal function called to actually save the permission
3448     */
3449     function _setPermission(address _entity, address _app, bytes32 _role, bytes32 _paramsHash) internal {
3450         permissions[permissionHash(_entity, _app, _role)] = _paramsHash;
3451         bool entityHasPermission = _paramsHash != NO_PERMISSION;
3452         bool permissionHasParams = entityHasPermission && _paramsHash != EMPTY_PARAM_HASH;
3453 
3454         emit SetPermission(_entity, _app, _role, entityHasPermission);
3455         if (permissionHasParams) {
3456             emit SetPermissionParams(_entity, _app, _role, _paramsHash);
3457         }
3458     }
3459 
3460     function _saveParams(uint256[] _encodedParams) internal returns (bytes32) {
3461         bytes32 paramHash = keccak256(abi.encodePacked(_encodedParams));
3462         Param[] storage params = permissionParams[paramHash];
3463 
3464         if (params.length == 0) { // params not saved before
3465             for (uint256 i = 0; i < _encodedParams.length; i++) {
3466                 uint256 encodedParam = _encodedParams[i];
3467                 Param memory param = Param(decodeParamId(encodedParam), decodeParamOp(encodedParam), uint240(encodedParam));
3468                 params.push(param);
3469             }
3470         }
3471 
3472         return paramHash;
3473     }
3474 
3475     function _evalParam(
3476         bytes32 _paramsHash,
3477         uint32 _paramId,
3478         address _who,
3479         address _where,
3480         bytes32 _what,
3481         uint256[] _how
3482     ) internal view returns (bool)
3483     {
3484         if (_paramId >= permissionParams[_paramsHash].length) {
3485             return false; // out of bounds
3486         }
3487 
3488         Param memory param = permissionParams[_paramsHash][_paramId];
3489 
3490         if (param.id == LOGIC_OP_PARAM_ID) {
3491             return _evalLogic(param, _paramsHash, _who, _where, _what, _how);
3492         }
3493 
3494         uint256 value;
3495         uint256 comparedTo = uint256(param.value);
3496 
3497         // get value
3498         if (param.id == ORACLE_PARAM_ID) {
3499             value = checkOracle(IACLOracle(param.value), _who, _where, _what, _how) ? 1 : 0;
3500             comparedTo = 1;
3501         } else if (param.id == BLOCK_NUMBER_PARAM_ID) {
3502             value = getBlockNumber();
3503         } else if (param.id == TIMESTAMP_PARAM_ID) {
3504             value = getTimestamp();
3505         } else if (param.id == PARAM_VALUE_PARAM_ID) {
3506             value = uint256(param.value);
3507         } else {
3508             if (param.id >= _how.length) {
3509                 return false;
3510             }
3511             value = uint256(uint240(_how[param.id])); // force lost precision
3512         }
3513 
3514         if (Op(param.op) == Op.RET) {
3515             return uint256(value) > 0;
3516         }
3517 
3518         return compare(value, Op(param.op), comparedTo);
3519     }
3520 
3521     function _evalLogic(Param _param, bytes32 _paramsHash, address _who, address _where, bytes32 _what, uint256[] _how)
3522         internal
3523         view
3524         returns (bool)
3525     {
3526         if (Op(_param.op) == Op.IF_ELSE) {
3527             uint32 conditionParam;
3528             uint32 successParam;
3529             uint32 failureParam;
3530 
3531             (conditionParam, successParam, failureParam) = decodeParamsList(uint256(_param.value));
3532             bool result = _evalParam(_paramsHash, conditionParam, _who, _where, _what, _how);
3533 
3534             return _evalParam(_paramsHash, result ? successParam : failureParam, _who, _where, _what, _how);
3535         }
3536 
3537         uint32 param1;
3538         uint32 param2;
3539 
3540         (param1, param2,) = decodeParamsList(uint256(_param.value));
3541         bool r1 = _evalParam(_paramsHash, param1, _who, _where, _what, _how);
3542 
3543         if (Op(_param.op) == Op.NOT) {
3544             return !r1;
3545         }
3546 
3547         if (r1 && Op(_param.op) == Op.OR) {
3548             return true;
3549         }
3550 
3551         if (!r1 && Op(_param.op) == Op.AND) {
3552             return false;
3553         }
3554 
3555         bool r2 = _evalParam(_paramsHash, param2, _who, _where, _what, _how);
3556 
3557         if (Op(_param.op) == Op.XOR) {
3558             return r1 != r2;
3559         }
3560 
3561         return r2; // both or and and depend on result of r2 after checks
3562     }
3563 
3564     function compare(uint256 _a, Op _op, uint256 _b) internal pure returns (bool) {
3565         if (_op == Op.EQ)  return _a == _b;                              // solium-disable-line lbrace
3566         if (_op == Op.NEQ) return _a != _b;                              // solium-disable-line lbrace
3567         if (_op == Op.GT)  return _a > _b;                               // solium-disable-line lbrace
3568         if (_op == Op.LT)  return _a < _b;                               // solium-disable-line lbrace
3569         if (_op == Op.GTE) return _a >= _b;                              // solium-disable-line lbrace
3570         if (_op == Op.LTE) return _a <= _b;                              // solium-disable-line lbrace
3571         return false;
3572     }
3573 
3574     function checkOracle(IACLOracle _oracleAddr, address _who, address _where, bytes32 _what, uint256[] _how) internal view returns (bool) {
3575         bytes4 sig = _oracleAddr.canPerform.selector;
3576 
3577         // a raw call is required so we can return false if the call reverts, rather than reverting
3578         bytes memory checkCalldata = abi.encodeWithSelector(sig, _who, _where, _what, _how);
3579         uint256 oracleCheckGas = ORACLE_CHECK_GAS;
3580 
3581         bool ok;
3582         assembly {
3583             ok := staticcall(oracleCheckGas, _oracleAddr, add(checkCalldata, 0x20), mload(checkCalldata), 0, 0)
3584         }
3585 
3586         if (!ok) {
3587             return false;
3588         }
3589 
3590         uint256 size;
3591         assembly { size := returndatasize }
3592         if (size != 32) {
3593             return false;
3594         }
3595 
3596         bool result;
3597         assembly {
3598             let ptr := mload(0x40)       // get next free memory ptr
3599             returndatacopy(ptr, 0, size) // copy return from above `staticcall`
3600             result := mload(ptr)         // read data at ptr and set it to result
3601             mstore(ptr, 0)               // set pointer memory to 0 so it still is the next free ptr
3602         }
3603 
3604         return result;
3605     }
3606 
3607     /**
3608     * @dev Internal function that sets management
3609     */
3610     function _setPermissionManager(address _newManager, address _app, bytes32 _role) internal {
3611         permissionManager[roleHash(_app, _role)] = _newManager;
3612         emit ChangePermissionManager(_app, _role, _newManager);
3613     }
3614 
3615     function roleHash(address _where, bytes32 _what) internal pure returns (bytes32) {
3616         return keccak256(abi.encodePacked("ROLE", _where, _what));
3617     }
3618 
3619     function permissionHash(address _who, address _where, bytes32 _what) internal pure returns (bytes32) {
3620         return keccak256(abi.encodePacked("PERMISSION", _who, _where, _what));
3621     }
3622 }
3623 // File: @aragon/os/contracts/evmscript/ScriptHelpers.sol
3624 /*
3625  * SPDX-License-Identitifer:    MIT
3626  */
3627 
3628 pragma solidity ^0.4.24;
3629 
3630 
3631 library ScriptHelpers {
3632     function getSpecId(bytes _script) internal pure returns (uint32) {
3633         return uint32At(_script, 0);
3634     }
3635 
3636     function uint256At(bytes _data, uint256 _location) internal pure returns (uint256 result) {
3637         assembly {
3638             result := mload(add(_data, add(0x20, _location)))
3639         }
3640     }
3641 
3642     function addressAt(bytes _data, uint256 _location) internal pure returns (address result) {
3643         uint256 word = uint256At(_data, _location);
3644 
3645         assembly {
3646             result := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
3647             0x1000000000000000000000000)
3648         }
3649     }
3650 
3651     function uint32At(bytes _data, uint256 _location) internal pure returns (uint32 result) {
3652         uint256 word = uint256At(_data, _location);
3653 
3654         assembly {
3655             result := div(and(word, 0xffffffff00000000000000000000000000000000000000000000000000000000),
3656             0x100000000000000000000000000000000000000000000000000000000)
3657         }
3658     }
3659 
3660     function locationOf(bytes _data, uint256 _location) internal pure returns (uint256 result) {
3661         assembly {
3662             result := add(_data, add(0x20, _location))
3663         }
3664     }
3665 
3666     function toBytes(bytes4 _sig) internal pure returns (bytes) {
3667         bytes memory payload = new bytes(4);
3668         assembly { mstore(add(payload, 0x20), _sig) }
3669         return payload;
3670     }
3671 }
3672 // File: @aragon/os/contracts/evmscript/EVMScriptRegistry.sol
3673 /* solium-disable function-order */
3674 // Allow public initialize() to be first
3675 contract EVMScriptRegistry is IEVMScriptRegistry, EVMScriptRegistryConstants, AragonApp {
3676     using ScriptHelpers for bytes;
3677 
3678     /* Hardcoded constants to save gas
3679     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = keccak256("REGISTRY_ADD_EXECUTOR_ROLE");
3680     bytes32 public constant REGISTRY_MANAGER_ROLE = keccak256("REGISTRY_MANAGER_ROLE");
3681     */
3682     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = 0xc4e90f38eea8c4212a009ca7b8947943ba4d4a58d19b683417f65291d1cd9ed2;
3683     // WARN: Manager can censor all votes and the like happening in an org
3684     bytes32 public constant REGISTRY_MANAGER_ROLE = 0xf7a450ef335e1892cb42c8ca72e7242359d7711924b75db5717410da3f614aa3;
3685 
3686     string private constant ERROR_INEXISTENT_EXECUTOR = "EVMREG_INEXISTENT_EXECUTOR";
3687     string private constant ERROR_EXECUTOR_ENABLED = "EVMREG_EXECUTOR_ENABLED";
3688     string private constant ERROR_EXECUTOR_DISABLED = "EVMREG_EXECUTOR_DISABLED";
3689 
3690     struct ExecutorEntry {
3691         IEVMScriptExecutor executor;
3692         bool enabled;
3693     }
3694 
3695     uint256 private executorsNextIndex;
3696     mapping (uint256 => ExecutorEntry) public executors;
3697 
3698     event EnableExecutor(uint256 indexed executorId, address indexed executorAddress);
3699     event DisableExecutor(uint256 indexed executorId, address indexed executorAddress);
3700 
3701     modifier executorExists(uint256 _executorId) {
3702         require(_executorId > 0 && _executorId < executorsNextIndex, ERROR_INEXISTENT_EXECUTOR);
3703         _;
3704     }
3705 
3706     /**
3707     * @notice Initialize the registry
3708     */
3709     function initialize() public onlyInit {
3710         initialized();
3711         // Create empty record to begin executor IDs at 1
3712         executorsNextIndex = 1;
3713     }
3714 
3715     /**
3716     * @notice Add a new script executor with address `_executor` to the registry
3717     * @param _executor Address of the IEVMScriptExecutor that will be added to the registry
3718     * @return id Identifier of the executor in the registry
3719     */
3720     function addScriptExecutor(IEVMScriptExecutor _executor) external auth(REGISTRY_ADD_EXECUTOR_ROLE) returns (uint256 id) {
3721         uint256 executorId = executorsNextIndex++;
3722         executors[executorId] = ExecutorEntry(_executor, true);
3723         emit EnableExecutor(executorId, _executor);
3724         return executorId;
3725     }
3726 
3727     /**
3728     * @notice Disable script executor with ID `_executorId`
3729     * @param _executorId Identifier of the executor in the registry
3730     */
3731     function disableScriptExecutor(uint256 _executorId)
3732         external
3733         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
3734     {
3735         // Note that we don't need to check for an executor's existence in this case, as only
3736         // existing executors can be enabled
3737         ExecutorEntry storage executorEntry = executors[_executorId];
3738         require(executorEntry.enabled, ERROR_EXECUTOR_DISABLED);
3739         executorEntry.enabled = false;
3740         emit DisableExecutor(_executorId, executorEntry.executor);
3741     }
3742 
3743     /**
3744     * @notice Enable script executor with ID `_executorId`
3745     * @param _executorId Identifier of the executor in the registry
3746     */
3747     function enableScriptExecutor(uint256 _executorId)
3748         external
3749         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
3750         executorExists(_executorId)
3751     {
3752         ExecutorEntry storage executorEntry = executors[_executorId];
3753         require(!executorEntry.enabled, ERROR_EXECUTOR_ENABLED);
3754         executorEntry.enabled = true;
3755         emit EnableExecutor(_executorId, executorEntry.executor);
3756     }
3757 
3758     /**
3759     * @dev Get the script executor that can execute a particular script based on its first 4 bytes
3760     * @param _script EVMScript being inspected
3761     */
3762     function getScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
3763         uint256 id = _script.getSpecId();
3764 
3765         // Note that we don't need to check for an executor's existence in this case, as only
3766         // existing executors can be enabled
3767         ExecutorEntry storage entry = executors[id];
3768         return entry.enabled ? entry.executor : IEVMScriptExecutor(0);
3769     }
3770 }
3771 // File: @aragon/os/contracts/evmscript/executors/BaseEVMScriptExecutor.sol
3772 /*
3773  * SPDX-License-Identitifer:    MIT
3774  */
3775 
3776 pragma solidity ^0.4.24;
3777 
3778 
3779 
3780 
3781 contract BaseEVMScriptExecutor is IEVMScriptExecutor, Autopetrified {
3782     uint256 internal constant SCRIPT_START_LOCATION = 4;
3783 }
3784 // File: @aragon/os/contracts/evmscript/executors/CallsScript.sol
3785 // Inspired by https://github.com/reverendus/tx-manager
3786 
3787 
3788 
3789 
3790 contract CallsScript is BaseEVMScriptExecutor {
3791     using ScriptHelpers for bytes;
3792 
3793     /* Hardcoded constants to save gas
3794     bytes32 internal constant EXECUTOR_TYPE = keccak256("CALLS_SCRIPT");
3795     */
3796     bytes32 internal constant EXECUTOR_TYPE = 0x2dc858a00f3e417be1394b87c07158e989ec681ce8cc68a9093680ac1a870302;
3797 
3798     string private constant ERROR_BLACKLISTED_CALL = "EVMCALLS_BLACKLISTED_CALL";
3799     string private constant ERROR_INVALID_LENGTH = "EVMCALLS_INVALID_LENGTH";
3800     string private constant ERROR_CALL_REVERTED = "EVMCALLS_CALL_REVERTED";
3801 
3802     event LogScriptCall(address indexed sender, address indexed src, address indexed dst);
3803 
3804     /**
3805     * @notice Executes a number of call scripts
3806     * @param _script [ specId (uint32) ] many calls with this structure ->
3807     *    [ to (address: 20 bytes) ] [ calldataLength (uint32: 4 bytes) ] [ calldata (calldataLength bytes) ]
3808     * @param _blacklist Addresses the script cannot call to, or will revert.
3809     * @return always returns empty byte array
3810     */
3811     function execScript(bytes _script, bytes, address[] _blacklist) external isInitialized returns (bytes) {
3812         uint256 location = SCRIPT_START_LOCATION; // first 32 bits are spec id
3813         while (location < _script.length) {
3814             address contractAddress = _script.addressAt(location);
3815             // Check address being called is not blacklist
3816             for (uint i = 0; i < _blacklist.length; i++) {
3817                 require(contractAddress != _blacklist[i], ERROR_BLACKLISTED_CALL);
3818             }
3819 
3820             // logged before execution to ensure event ordering in receipt
3821             // if failed entire execution is reverted regardless
3822             emit LogScriptCall(msg.sender, address(this), contractAddress);
3823 
3824             uint256 calldataLength = uint256(_script.uint32At(location + 0x14));
3825             uint256 startOffset = location + 0x14 + 0x04;
3826             uint256 calldataStart = _script.locationOf(startOffset);
3827 
3828             // compute end of script / next location
3829             location = startOffset + calldataLength;
3830             require(location <= _script.length, ERROR_INVALID_LENGTH);
3831 
3832             bool success;
3833             assembly {
3834                 success := call(sub(gas, 5000), contractAddress, 0, calldataStart, calldataLength, 0, 0)
3835             }
3836 
3837             require(success, ERROR_CALL_REVERTED);
3838         }
3839     }
3840 
3841     function executorType() external pure returns (bytes32) {
3842         return EXECUTOR_TYPE;
3843     }
3844 }
3845 // File: @aragon/os/contracts/factory/EVMScriptRegistryFactory.sol
3846 contract EVMScriptRegistryFactory is EVMScriptRegistryConstants {
3847     EVMScriptRegistry public baseReg;
3848     IEVMScriptExecutor public baseCallScript;
3849 
3850     constructor() public {
3851         baseReg = new EVMScriptRegistry();
3852         baseCallScript = IEVMScriptExecutor(new CallsScript());
3853     }
3854 
3855     function newEVMScriptRegistry(Kernel _dao) public returns (EVMScriptRegistry reg) {
3856         bytes memory initPayload = abi.encodeWithSelector(reg.initialize.selector);
3857         reg = EVMScriptRegistry(_dao.newPinnedAppInstance(EVMSCRIPT_REGISTRY_APP_ID, baseReg, initPayload, true));
3858 
3859         ACL acl = ACL(_dao.acl());
3860 
3861         acl.createPermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE(), this);
3862 
3863         reg.addScriptExecutor(baseCallScript);     // spec 1 = CallsScript
3864 
3865         // Clean up the permissions
3866         acl.revokePermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
3867         acl.removePermissionManager(reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
3868 
3869         return reg;
3870     }
3871 }
3872 // File: @aragon/os/contracts/factory/DAOFactory.sol
3873 contract DAOFactory {
3874     IKernel public baseKernel;
3875     IACL public baseACL;
3876     EVMScriptRegistryFactory public regFactory;
3877 
3878     event DeployDAO(address dao);
3879     event DeployEVMScriptRegistry(address reg);
3880 
3881     constructor(IKernel _baseKernel, IACL _baseACL, EVMScriptRegistryFactory _regFactory) public {
3882         // No need to init as it cannot be killed by devops199
3883         if (address(_regFactory) != address(0)) {
3884             regFactory = _regFactory;
3885         }
3886 
3887         baseKernel = _baseKernel;
3888         baseACL = _baseACL;
3889     }
3890 
3891     /**
3892     * @param _root Address that will be granted control to setup DAO permissions
3893     */
3894     function newDAO(address _root) public returns (Kernel) {
3895         Kernel dao = Kernel(new KernelProxy(baseKernel));
3896 
3897         if (address(regFactory) == address(0)) {
3898             dao.initialize(baseACL, _root);
3899         } else {
3900             dao.initialize(baseACL, this);
3901 
3902             ACL acl = ACL(dao.acl());
3903             bytes32 permRole = acl.CREATE_PERMISSIONS_ROLE();
3904             bytes32 appManagerRole = dao.APP_MANAGER_ROLE();
3905 
3906             acl.grantPermission(regFactory, acl, permRole);
3907 
3908             acl.createPermission(regFactory, dao, appManagerRole, this);
3909 
3910             EVMScriptRegistry reg = regFactory.newEVMScriptRegistry(dao);
3911             emit DeployEVMScriptRegistry(address(reg));
3912 
3913             // Clean up permissions
3914             // First, completely reset the APP_MANAGER_ROLE
3915             acl.revokePermission(regFactory, dao, appManagerRole);
3916             acl.removePermissionManager(dao, appManagerRole);
3917 
3918             // Then, make root the only holder and manager of CREATE_PERMISSIONS_ROLE
3919             acl.revokePermission(regFactory, acl, permRole);
3920             acl.revokePermission(this, acl, permRole);
3921             acl.grantPermission(_root, acl, permRole);
3922             acl.setPermissionManager(_root, acl, permRole);
3923         }
3924 
3925         emit DeployDAO(address(dao));
3926 
3927         return dao;
3928     }
3929 }
3930 // File: @aragon/os/contracts/apm/Repo.sol
3931 /* solium-disable function-order */
3932 // Allow public initialize() to be first
3933 contract Repo is AragonApp {
3934     /* Hardcoded constants to save gas
3935     bytes32 public constant CREATE_VERSION_ROLE = keccak256("CREATE_VERSION_ROLE");
3936     */
3937     bytes32 public constant CREATE_VERSION_ROLE = 0x1f56cfecd3595a2e6cc1a7e6cb0b20df84cdbd92eff2fee554e70e4e45a9a7d8;
3938 
3939     string private constant ERROR_INVALID_BUMP = "REPO_INVALID_BUMP";
3940     string private constant ERROR_INVALID_VERSION = "REPO_INVALID_VERSION";
3941     string private constant ERROR_INEXISTENT_VERSION = "REPO_INEXISTENT_VERSION";
3942 
3943     struct Version {
3944         uint16[3] semanticVersion;
3945         address contractAddress;
3946         bytes contentURI;
3947     }
3948 
3949     uint256 internal versionsNextIndex;
3950     mapping (uint256 => Version) internal versions;
3951     mapping (bytes32 => uint256) internal versionIdForSemantic;
3952     mapping (address => uint256) internal latestVersionIdForContract;
3953 
3954     event NewVersion(uint256 versionId, uint16[3] semanticVersion);
3955 
3956     /**
3957     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
3958     * @notice Initializes a Repo to be usable
3959     */
3960     function initialize() public onlyInit {
3961         initialized();
3962         versionsNextIndex = 1;
3963     }
3964 
3965     /**
3966     * @notice Create new version for repo
3967     * @param _newSemanticVersion Semantic version for new repo version
3968     * @param _contractAddress address for smart contract logic for version (if set to 0, it uses last versions' contractAddress)
3969     * @param _contentURI External URI for fetching new version's content
3970     */
3971     function newVersion(
3972         uint16[3] _newSemanticVersion,
3973         address _contractAddress,
3974         bytes _contentURI
3975     ) public auth(CREATE_VERSION_ROLE)
3976     {
3977         address contractAddress = _contractAddress;
3978         uint256 lastVersionIndex = versionsNextIndex - 1;
3979 
3980         uint16[3] memory lastSematicVersion;
3981 
3982         if (lastVersionIndex > 0) {
3983             Version storage lastVersion = versions[lastVersionIndex];
3984             lastSematicVersion = lastVersion.semanticVersion;
3985 
3986             if (contractAddress == address(0)) {
3987                 contractAddress = lastVersion.contractAddress;
3988             }
3989             // Only allows smart contract change on major version bumps
3990             require(
3991                 lastVersion.contractAddress == contractAddress || _newSemanticVersion[0] > lastVersion.semanticVersion[0],
3992                 ERROR_INVALID_VERSION
3993             );
3994         }
3995 
3996         require(isValidBump(lastSematicVersion, _newSemanticVersion), ERROR_INVALID_BUMP);
3997 
3998         uint256 versionId = versionsNextIndex++;
3999         versions[versionId] = Version(_newSemanticVersion, contractAddress, _contentURI);
4000         versionIdForSemantic[semanticVersionHash(_newSemanticVersion)] = versionId;
4001         latestVersionIdForContract[contractAddress] = versionId;
4002 
4003         emit NewVersion(versionId, _newSemanticVersion);
4004     }
4005 
4006     function getLatest() public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
4007         return getByVersionId(versionsNextIndex - 1);
4008     }
4009 
4010     function getLatestForContractAddress(address _contractAddress)
4011         public
4012         view
4013         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
4014     {
4015         return getByVersionId(latestVersionIdForContract[_contractAddress]);
4016     }
4017 
4018     function getBySemanticVersion(uint16[3] _semanticVersion)
4019         public
4020         view
4021         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
4022     {
4023         return getByVersionId(versionIdForSemantic[semanticVersionHash(_semanticVersion)]);
4024     }
4025 
4026     function getByVersionId(uint _versionId) public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
4027         require(_versionId > 0 && _versionId < versionsNextIndex, ERROR_INEXISTENT_VERSION);
4028         Version storage version = versions[_versionId];
4029         return (version.semanticVersion, version.contractAddress, version.contentURI);
4030     }
4031 
4032     function getVersionsCount() public view returns (uint256) {
4033         return versionsNextIndex - 1;
4034     }
4035 
4036     function isValidBump(uint16[3] _oldVersion, uint16[3] _newVersion) public pure returns (bool) {
4037         bool hasBumped;
4038         uint i = 0;
4039         while (i < 3) {
4040             if (hasBumped) {
4041                 if (_newVersion[i] != 0) {
4042                     return false;
4043                 }
4044             } else if (_newVersion[i] != _oldVersion[i]) {
4045                 if (_oldVersion[i] > _newVersion[i] || _newVersion[i] - _oldVersion[i] != 1) {
4046                     return false;
4047                 }
4048                 hasBumped = true;
4049             }
4050             i++;
4051         }
4052         return hasBumped;
4053     }
4054 
4055     function semanticVersionHash(uint16[3] version) internal pure returns (bytes32) {
4056         return keccak256(abi.encodePacked(version[0], version[1], version[2]));
4057     }
4058 }
4059 // File: @aragon/os/contracts/lib/ens/AbstractENS.sol
4060 interface AbstractENS {
4061     function owner(bytes32 _node) public constant returns (address);
4062     function resolver(bytes32 _node) public constant returns (address);
4063     function ttl(bytes32 _node) public constant returns (uint64);
4064     function setOwner(bytes32 _node, address _owner) public;
4065     function setSubnodeOwner(bytes32 _node, bytes32 label, address _owner) public;
4066     function setResolver(bytes32 _node, address _resolver) public;
4067     function setTTL(bytes32 _node, uint64 _ttl) public;
4068 
4069     // Logged when the owner of a node assigns a new owner to a subnode.
4070     event NewOwner(bytes32 indexed _node, bytes32 indexed _label, address _owner);
4071 
4072     // Logged when the owner of a node transfers ownership to a new account.
4073     event Transfer(bytes32 indexed _node, address _owner);
4074 
4075     // Logged when the resolver for a node changes.
4076     event NewResolver(bytes32 indexed _node, address _resolver);
4077 
4078     // Logged when the TTL of a node changes
4079     event NewTTL(bytes32 indexed _node, uint64 _ttl);
4080 }
4081 // File: @aragon/os/contracts/lib/ens/ENS.sol
4082 /**
4083  * The ENS registry contract.
4084  */
4085 contract ENS is AbstractENS {
4086     struct Record {
4087         address owner;
4088         address resolver;
4089         uint64 ttl;
4090     }
4091 
4092     mapping(bytes32=>Record) records;
4093 
4094     // Permits modifications only by the owner of the specified node.
4095     modifier only_owner(bytes32 node) {
4096         if (records[node].owner != msg.sender) throw;
4097         _;
4098     }
4099 
4100     /**
4101      * Constructs a new ENS registrar.
4102      */
4103     function ENS() public {
4104         records[0].owner = msg.sender;
4105     }
4106 
4107     /**
4108      * Returns the address that owns the specified node.
4109      */
4110     function owner(bytes32 node) public constant returns (address) {
4111         return records[node].owner;
4112     }
4113 
4114     /**
4115      * Returns the address of the resolver for the specified node.
4116      */
4117     function resolver(bytes32 node) public constant returns (address) {
4118         return records[node].resolver;
4119     }
4120 
4121     /**
4122      * Returns the TTL of a node, and any records associated with it.
4123      */
4124     function ttl(bytes32 node) public constant returns (uint64) {
4125         return records[node].ttl;
4126     }
4127 
4128     /**
4129      * Transfers ownership of a node to a new address. May only be called by the current
4130      * owner of the node.
4131      * @param node The node to transfer ownership of.
4132      * @param owner The address of the new owner.
4133      */
4134     function setOwner(bytes32 node, address owner) only_owner(node) public {
4135         Transfer(node, owner);
4136         records[node].owner = owner;
4137     }
4138 
4139     /**
4140      * Transfers ownership of a subnode keccak256(node, label) to a new address. May only be
4141      * called by the owner of the parent node.
4142      * @param node The parent node.
4143      * @param label The hash of the label specifying the subnode.
4144      * @param owner The address of the new owner.
4145      */
4146     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) public {
4147         var subnode = keccak256(node, label);
4148         NewOwner(node, label, owner);
4149         records[subnode].owner = owner;
4150     }
4151 
4152     /**
4153      * Sets the resolver address for the specified node.
4154      * @param node The node to update.
4155      * @param resolver The address of the resolver.
4156      */
4157     function setResolver(bytes32 node, address resolver) only_owner(node) public {
4158         NewResolver(node, resolver);
4159         records[node].resolver = resolver;
4160     }
4161 
4162     /**
4163      * Sets the TTL for the specified node.
4164      * @param node The node to update.
4165      * @param ttl The TTL in seconds.
4166      */
4167     function setTTL(bytes32 node, uint64 ttl) only_owner(node) public {
4168         NewTTL(node, ttl);
4169         records[node].ttl = ttl;
4170     }
4171 }
4172 // File: @aragon/os/contracts/lib/ens/PublicResolver.sol
4173 /**
4174  * A simple resolver anyone can use; only allows the owner of a node to set its
4175  * address.
4176  */
4177 contract PublicResolver {
4178     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
4179     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
4180     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
4181     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
4182     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
4183     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
4184     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
4185 
4186     event AddrChanged(bytes32 indexed node, address a);
4187     event ContentChanged(bytes32 indexed node, bytes32 hash);
4188     event NameChanged(bytes32 indexed node, string name);
4189     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
4190     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
4191     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
4192 
4193     struct PublicKey {
4194         bytes32 x;
4195         bytes32 y;
4196     }
4197 
4198     struct Record {
4199         address addr;
4200         bytes32 content;
4201         string name;
4202         PublicKey pubkey;
4203         mapping(string=>string) text;
4204         mapping(uint256=>bytes) abis;
4205     }
4206 
4207     AbstractENS ens;
4208     mapping(bytes32=>Record) records;
4209 
4210     modifier only_owner(bytes32 node) {
4211         if (ens.owner(node) != msg.sender) throw;
4212         _;
4213     }
4214 
4215     /**
4216      * Constructor.
4217      * @param ensAddr The ENS registrar contract.
4218      */
4219     function PublicResolver(AbstractENS ensAddr) public {
4220         ens = ensAddr;
4221     }
4222 
4223     /**
4224      * Returns true if the resolver implements the interface specified by the provided hash.
4225      * @param interfaceID The ID of the interface to check for.
4226      * @return True if the contract implements the requested interface.
4227      */
4228     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
4229         return interfaceID == ADDR_INTERFACE_ID ||
4230                interfaceID == CONTENT_INTERFACE_ID ||
4231                interfaceID == NAME_INTERFACE_ID ||
4232                interfaceID == ABI_INTERFACE_ID ||
4233                interfaceID == PUBKEY_INTERFACE_ID ||
4234                interfaceID == TEXT_INTERFACE_ID ||
4235                interfaceID == INTERFACE_META_ID;
4236     }
4237 
4238     /**
4239      * Returns the address associated with an ENS node.
4240      * @param node The ENS node to query.
4241      * @return The associated address.
4242      */
4243     function addr(bytes32 node) public constant returns (address ret) {
4244         ret = records[node].addr;
4245     }
4246 
4247     /**
4248      * Sets the address associated with an ENS node.
4249      * May only be called by the owner of that node in the ENS registry.
4250      * @param node The node to update.
4251      * @param addr The address to set.
4252      */
4253     function setAddr(bytes32 node, address addr) only_owner(node) public {
4254         records[node].addr = addr;
4255         AddrChanged(node, addr);
4256     }
4257 
4258     /**
4259      * Returns the content hash associated with an ENS node.
4260      * Note that this resource type is not standardized, and will likely change
4261      * in future to a resource type based on multihash.
4262      * @param node The ENS node to query.
4263      * @return The associated content hash.
4264      */
4265     function content(bytes32 node) public constant returns (bytes32 ret) {
4266         ret = records[node].content;
4267     }
4268 
4269     /**
4270      * Sets the content hash associated with an ENS node.
4271      * May only be called by the owner of that node in the ENS registry.
4272      * Note that this resource type is not standardized, and will likely change
4273      * in future to a resource type based on multihash.
4274      * @param node The node to update.
4275      * @param hash The content hash to set
4276      */
4277     function setContent(bytes32 node, bytes32 hash) only_owner(node) public {
4278         records[node].content = hash;
4279         ContentChanged(node, hash);
4280     }
4281 
4282     /**
4283      * Returns the name associated with an ENS node, for reverse records.
4284      * Defined in EIP181.
4285      * @param node The ENS node to query.
4286      * @return The associated name.
4287      */
4288     function name(bytes32 node) public constant returns (string ret) {
4289         ret = records[node].name;
4290     }
4291 
4292     /**
4293      * Sets the name associated with an ENS node, for reverse records.
4294      * May only be called by the owner of that node in the ENS registry.
4295      * @param node The node to update.
4296      * @param name The name to set.
4297      */
4298     function setName(bytes32 node, string name) only_owner(node) public {
4299         records[node].name = name;
4300         NameChanged(node, name);
4301     }
4302 
4303     /**
4304      * Returns the ABI associated with an ENS node.
4305      * Defined in EIP205.
4306      * @param node The ENS node to query
4307      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
4308      * @return contentType The content type of the return value
4309      * @return data The ABI data
4310      */
4311     function ABI(bytes32 node, uint256 contentTypes) public constant returns (uint256 contentType, bytes data) {
4312         var record = records[node];
4313         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
4314             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
4315                 data = record.abis[contentType];
4316                 return;
4317             }
4318         }
4319         contentType = 0;
4320     }
4321 
4322     /**
4323      * Sets the ABI associated with an ENS node.
4324      * Nodes may have one ABI of each content type. To remove an ABI, set it to
4325      * the empty string.
4326      * @param node The node to update.
4327      * @param contentType The content type of the ABI
4328      * @param data The ABI data.
4329      */
4330     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) public {
4331         // Content types must be powers of 2
4332         if (((contentType - 1) & contentType) != 0) throw;
4333 
4334         records[node].abis[contentType] = data;
4335         ABIChanged(node, contentType);
4336     }
4337 
4338     /**
4339      * Returns the SECP256k1 public key associated with an ENS node.
4340      * Defined in EIP 619.
4341      * @param node The ENS node to query
4342      * @return x, y the X and Y coordinates of the curve point for the public key.
4343      */
4344     function pubkey(bytes32 node) public constant returns (bytes32 x, bytes32 y) {
4345         return (records[node].pubkey.x, records[node].pubkey.y);
4346     }
4347 
4348     /**
4349      * Sets the SECP256k1 public key associated with an ENS node.
4350      * @param node The ENS node to query
4351      * @param x the X coordinate of the curve point for the public key.
4352      * @param y the Y coordinate of the curve point for the public key.
4353      */
4354     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) public {
4355         records[node].pubkey = PublicKey(x, y);
4356         PubkeyChanged(node, x, y);
4357     }
4358 
4359     /**
4360      * Returns the text data associated with an ENS node and key.
4361      * @param node The ENS node to query.
4362      * @param key The text data key to query.
4363      * @return The associated text data.
4364      */
4365     function text(bytes32 node, string key) public constant returns (string ret) {
4366         ret = records[node].text[key];
4367     }
4368 
4369     /**
4370      * Sets the text data associated with an ENS node and key.
4371      * May only be called by the owner of that node in the ENS registry.
4372      * @param node The node to update.
4373      * @param key The key to set.
4374      * @param value The text data value to set.
4375      */
4376     function setText(bytes32 node, string key, string value) only_owner(node) public {
4377         records[node].text[key] = value;
4378         TextChanged(node, key, key);
4379     }
4380 }
4381 // File: @aragon/kits-base/contracts/KitBase.sol
4382 contract KitBase is EVMScriptRegistryConstants {
4383     ENS public ens;
4384     DAOFactory public fac;
4385 
4386     event DeployInstance(address dao);
4387     event InstalledApp(address appProxy, bytes32 appId);
4388 
4389     constructor (DAOFactory _fac, ENS _ens) public {
4390         fac = _fac;
4391         ens = _ens;
4392     }
4393 
4394     function latestVersionAppBase(bytes32 appId) public view returns (address base) {
4395         Repo repo = Repo(PublicResolver(ens.resolver(appId)).addr(appId));
4396         (,base,) = repo.getLatest();
4397 
4398         return base;
4399     }
4400 
4401     function cleanupDAOPermissions(Kernel dao, ACL acl, address root) internal {
4402         // Kernel permission clean up
4403         cleanupPermission(acl, root, dao, dao.APP_MANAGER_ROLE());
4404 
4405         // ACL permission clean up
4406         cleanupPermission(acl, root, acl, acl.CREATE_PERMISSIONS_ROLE());
4407     }
4408 
4409     function cleanupPermission(ACL acl, address root, address app, bytes32 permission) internal {
4410         acl.grantPermission(root, app, permission);
4411         acl.revokePermission(this, app, permission);
4412         acl.setPermissionManager(root, app, permission);
4413     }
4414 }
4415 // File: contracts/AGP1Kit.sol
4416 contract AGP1Kit is KitBase, APMNamehash, IsContract {
4417 
4418     uint64 constant public MAIN_VOTING_SUPPORT = 50 * 10**16; // > 50%
4419     uint64 constant public MAIN_VOTING_QUORUM = 0; // Just 1 vote is enough
4420     uint64 constant public MAIN_VOTING_VOTE_TIME = 48 hours;
4421 
4422     uint64 constant public META_TRACK_VOTING_SUPPORT = 666666666666666666; // > two thirds
4423     uint64 constant public META_TRACK_VOTING_QUORUM = 0; // Just 1 vote is enough
4424     uint64 constant public META_TRACK_VOTING_VOTE_TIME = 48 hours;
4425 
4426     uint64 constant public FINANCE_PERIOD_DURATION = 7889400; // 365.25 days / 4
4427 
4428     bytes32 constant public financeAppId = apmNamehash("finance");
4429     bytes32 constant public vaultAppId = apmNamehash("vault");
4430     bytes32 constant public votingAppId = apmNamehash("voting");
4431 
4432     constructor(DAOFactory _fac, ENS _ens) KitBase(_fac, _ens) public {
4433         require(isContract(address(_fac.regFactory())));
4434     }
4435 
4436     function newInstance(MiniMeToken _ant, address _multisig) external returns (Kernel) {
4437         Kernel dao = fac.newDAO(this);
4438         ACL acl = ACL(dao.acl());
4439 
4440         acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);
4441 
4442         Vault vault = Vault(
4443             dao.newAppInstance(
4444                 vaultAppId,
4445                 latestVersionAppBase(vaultAppId),
4446                 new bytes(0),
4447                 true
4448             )
4449         );
4450         emit InstalledApp(vault, vaultAppId);
4451 
4452         Finance finance = Finance(dao.newAppInstance(financeAppId, latestVersionAppBase(financeAppId)));
4453         emit InstalledApp(finance, financeAppId);
4454 
4455         Voting voting = Voting(dao.newAppInstance(votingAppId, latestVersionAppBase(votingAppId)));
4456         emit InstalledApp(voting, votingAppId);
4457 
4458         Voting metaTrackVoting = Voting(dao.newAppInstance(votingAppId, latestVersionAppBase(votingAppId)));
4459         emit InstalledApp(metaTrackVoting, votingAppId);
4460 
4461         // permissions
4462         acl.createPermission(_multisig, voting, voting.CREATE_VOTES_ROLE(), _multisig);
4463         acl.createPermission(metaTrackVoting, voting, voting.MODIFY_QUORUM_ROLE(), metaTrackVoting);
4464         acl.createPermission(metaTrackVoting, voting, voting.MODIFY_SUPPORT_ROLE(), metaTrackVoting);
4465 
4466         acl.createPermission(_multisig, metaTrackVoting, metaTrackVoting.CREATE_VOTES_ROLE(), _multisig);
4467         acl.createPermission(metaTrackVoting, metaTrackVoting, metaTrackVoting.MODIFY_QUORUM_ROLE(), metaTrackVoting);
4468         acl.createPermission(metaTrackVoting, metaTrackVoting, metaTrackVoting.MODIFY_SUPPORT_ROLE(), metaTrackVoting);
4469 
4470         acl.createPermission(finance, vault, vault.TRANSFER_ROLE(), metaTrackVoting);
4471         acl.createPermission(voting, finance, finance.CREATE_PAYMENTS_ROLE(), metaTrackVoting);
4472         acl.createPermission(voting, finance, finance.EXECUTE_PAYMENTS_ROLE(), metaTrackVoting);
4473         acl.createPermission(voting, finance, finance.MANAGE_PAYMENTS_ROLE(), metaTrackVoting);
4474 
4475         // App inits
4476         vault.initialize();
4477         finance.initialize(vault, FINANCE_PERIOD_DURATION);
4478         voting.initialize(_ant, MAIN_VOTING_SUPPORT, MAIN_VOTING_QUORUM, MAIN_VOTING_VOTE_TIME);
4479         metaTrackVoting.initialize(_ant, META_TRACK_VOTING_SUPPORT, META_TRACK_VOTING_QUORUM, META_TRACK_VOTING_VOTE_TIME);
4480 
4481         // cleanup
4482         cleanupDAOPermissions(dao, acl, metaTrackVoting);
4483 
4484         emit DeployInstance(dao);
4485 
4486         return dao;
4487     }
4488 }