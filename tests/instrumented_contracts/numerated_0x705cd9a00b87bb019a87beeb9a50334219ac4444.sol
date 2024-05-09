1 pragma solidity 0.4.24;
2 // File: @aragon/os/contracts/acl/IACL.sol
3 /*
4  * SPDX-License-Identitifer:    MIT
5  */
6 
7 pragma solidity ^0.4.24;
8 
9 
10 interface IACL {
11     function initialize(address permissionsCreator) external;
12 
13     // TODO: this should be external
14     // See https://github.com/ethereum/solidity/issues/4832
15     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
16 }
17 // File: @aragon/os/contracts/common/IVaultRecoverable.sol
18 /*
19  * SPDX-License-Identitifer:    MIT
20  */
21 
22 pragma solidity ^0.4.24;
23 
24 
25 interface IVaultRecoverable {
26     function transferToVault(address token) external;
27 
28     function allowRecoverability(address token) external view returns (bool);
29     function getRecoveryVault() external view returns (address);
30 }
31 // File: @aragon/os/contracts/kernel/IKernel.sol
32 /*
33  * SPDX-License-Identitifer:    MIT
34  */
35 
36 pragma solidity ^0.4.24;
37 
38 
39 
40 
41 // This should be an interface, but interfaces can't inherit yet :(
42 contract IKernel is IVaultRecoverable {
43     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
44 
45     function acl() public view returns (IACL);
46     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
47 
48     function setApp(bytes32 namespace, bytes32 appId, address app) public;
49     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
50 }
51 // File: @aragon/os/contracts/kernel/KernelConstants.sol
52 /*
53  * SPDX-License-Identitifer:    MIT
54  */
55 
56 pragma solidity ^0.4.24;
57 
58 
59 contract KernelAppIds {
60     /* Hardcoded constants to save gas
61     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
62     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
63     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
64     */
65     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
66     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
67     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
68 }
69 
70 
71 contract KernelNamespaceConstants {
72     /* Hardcoded constants to save gas
73     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
74     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
75     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
76     */
77     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
78     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
79     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
80 }
81 // File: @aragon/os/contracts/kernel/KernelStorage.sol
82 contract KernelStorage {
83     // namespace => app id => address
84     mapping (bytes32 => mapping (bytes32 => address)) public apps;
85     bytes32 public recoveryVaultAppId;
86 }
87 // File: @aragon/os/contracts/acl/ACLSyntaxSugar.sol
88 /*
89  * SPDX-License-Identitifer:    MIT
90  */
91 
92 pragma solidity ^0.4.24;
93 
94 
95 contract ACLSyntaxSugar {
96     function arr() internal pure returns (uint256[]) {}
97 
98     function arr(bytes32 _a) internal pure returns (uint256[] r) {
99         return arr(uint256(_a));
100     }
101 
102     function arr(bytes32 _a, bytes32 _b) internal pure returns (uint256[] r) {
103         return arr(uint256(_a), uint256(_b));
104     }
105 
106     function arr(address _a) internal pure returns (uint256[] r) {
107         return arr(uint256(_a));
108     }
109 
110     function arr(address _a, address _b) internal pure returns (uint256[] r) {
111         return arr(uint256(_a), uint256(_b));
112     }
113 
114     function arr(address _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
115         return arr(uint256(_a), _b, _c);
116     }
117 
118     function arr(address _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
119         return arr(uint256(_a), _b, _c, _d);
120     }
121 
122     function arr(address _a, uint256 _b) internal pure returns (uint256[] r) {
123         return arr(uint256(_a), uint256(_b));
124     }
125 
126     function arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
127         return arr(uint256(_a), uint256(_b), _c, _d, _e);
128     }
129 
130     function arr(address _a, address _b, address _c) internal pure returns (uint256[] r) {
131         return arr(uint256(_a), uint256(_b), uint256(_c));
132     }
133 
134     function arr(address _a, address _b, uint256 _c) internal pure returns (uint256[] r) {
135         return arr(uint256(_a), uint256(_b), uint256(_c));
136     }
137 
138     function arr(uint256 _a) internal pure returns (uint256[] r) {
139         r = new uint256[](1);
140         r[0] = _a;
141     }
142 
143     function arr(uint256 _a, uint256 _b) internal pure returns (uint256[] r) {
144         r = new uint256[](2);
145         r[0] = _a;
146         r[1] = _b;
147     }
148 
149     function arr(uint256 _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
150         r = new uint256[](3);
151         r[0] = _a;
152         r[1] = _b;
153         r[2] = _c;
154     }
155 
156     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
157         r = new uint256[](4);
158         r[0] = _a;
159         r[1] = _b;
160         r[2] = _c;
161         r[3] = _d;
162     }
163 
164     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
165         r = new uint256[](5);
166         r[0] = _a;
167         r[1] = _b;
168         r[2] = _c;
169         r[3] = _d;
170         r[4] = _e;
171     }
172 }
173 
174 
175 contract ACLHelpers {
176     function decodeParamOp(uint256 _x) internal pure returns (uint8 b) {
177         return uint8(_x >> (8 * 30));
178     }
179 
180     function decodeParamId(uint256 _x) internal pure returns (uint8 b) {
181         return uint8(_x >> (8 * 31));
182     }
183 
184     function decodeParamsList(uint256 _x) internal pure returns (uint32 a, uint32 b, uint32 c) {
185         a = uint32(_x);
186         b = uint32(_x >> (8 * 4));
187         c = uint32(_x >> (8 * 8));
188     }
189 }
190 // File: @aragon/os/contracts/lib/misc/ERCProxy.sol
191 /*
192  * SPDX-License-Identitifer:    MIT
193  */
194 
195 pragma solidity ^0.4.24;
196 
197 
198 contract ERCProxy {
199     uint256 internal constant FORWARDING = 1;
200     uint256 internal constant UPGRADEABLE = 2;
201 
202     function proxyType() public pure returns (uint256 proxyTypeId);
203     function implementation() public view returns (address codeAddr);
204 }
205 // File: @aragon/os/contracts/common/IsContract.sol
206 /*
207  * SPDX-License-Identitifer:    MIT
208  */
209 
210 pragma solidity ^0.4.24;
211 
212 
213 contract IsContract {
214     /*
215     * NOTE: this should NEVER be used for authentication
216     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
217     *
218     * This is only intended to be used as a sanity check that an address is actually a contract,
219     * RATHER THAN an address not being a contract.
220     */
221     function isContract(address _target) internal view returns (bool) {
222         if (_target == address(0)) {
223             return false;
224         }
225 
226         uint256 size;
227         assembly { size := extcodesize(_target) }
228         return size > 0;
229     }
230 }
231 // File: @aragon/os/contracts/common/UnstructuredStorage.sol
232 /*
233  * SPDX-License-Identitifer:    MIT
234  */
235 
236 pragma solidity ^0.4.24;
237 
238 
239 library UnstructuredStorage {
240     function getStorageBool(bytes32 position) internal view returns (bool data) {
241         assembly { data := sload(position) }
242     }
243 
244     function getStorageAddress(bytes32 position) internal view returns (address data) {
245         assembly { data := sload(position) }
246     }
247 
248     function getStorageBytes32(bytes32 position) internal view returns (bytes32 data) {
249         assembly { data := sload(position) }
250     }
251 
252     function getStorageUint256(bytes32 position) internal view returns (uint256 data) {
253         assembly { data := sload(position) }
254     }
255 
256     function setStorageBool(bytes32 position, bool data) internal {
257         assembly { sstore(position, data) }
258     }
259 
260     function setStorageAddress(bytes32 position, address data) internal {
261         assembly { sstore(position, data) }
262     }
263 
264     function setStorageBytes32(bytes32 position, bytes32 data) internal {
265         assembly { sstore(position, data) }
266     }
267 
268     function setStorageUint256(bytes32 position, uint256 data) internal {
269         assembly { sstore(position, data) }
270     }
271 }
272 // File: @aragon/os/contracts/common/Uint256Helpers.sol
273 library Uint256Helpers {
274     uint256 private constant MAX_UINT64 = uint64(-1);
275 
276     string private constant ERROR_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
277 
278     function toUint64(uint256 a) internal pure returns (uint64) {
279         require(a <= MAX_UINT64, ERROR_NUMBER_TOO_BIG);
280         return uint64(a);
281     }
282 }
283 // File: @aragon/os/contracts/common/TimeHelpers.sol
284 /*
285  * SPDX-License-Identitifer:    MIT
286  */
287 
288 pragma solidity ^0.4.24;
289 
290 
291 
292 contract TimeHelpers {
293     using Uint256Helpers for uint256;
294 
295     /**
296     * @dev Returns the current block number.
297     *      Using a function rather than `block.number` allows us to easily mock the block number in
298     *      tests.
299     */
300     function getBlockNumber() internal view returns (uint256) {
301         return block.number;
302     }
303 
304     /**
305     * @dev Returns the current block number, converted to uint64.
306     *      Using a function rather than `block.number` allows us to easily mock the block number in
307     *      tests.
308     */
309     function getBlockNumber64() internal view returns (uint64) {
310         return getBlockNumber().toUint64();
311     }
312 
313     /**
314     * @dev Returns the current timestamp.
315     *      Using a function rather than `block.timestamp` allows us to easily mock it in
316     *      tests.
317     */
318     function getTimestamp() internal view returns (uint256) {
319         return block.timestamp; // solium-disable-line security/no-block-members
320     }
321 
322     /**
323     * @dev Returns the current timestamp, converted to uint64.
324     *      Using a function rather than `block.timestamp` allows us to easily mock it in
325     *      tests.
326     */
327     function getTimestamp64() internal view returns (uint64) {
328         return getTimestamp().toUint64();
329     }
330 }
331 // File: @aragon/os/contracts/common/Initializable.sol
332 /*
333  * SPDX-License-Identitifer:    MIT
334  */
335 
336 pragma solidity ^0.4.24;
337 
338 
339 
340 
341 contract Initializable is TimeHelpers {
342     using UnstructuredStorage for bytes32;
343 
344     // keccak256("aragonOS.initializable.initializationBlock")
345     bytes32 internal constant INITIALIZATION_BLOCK_POSITION = 0xebb05b386a8d34882b8711d156f463690983dc47815980fb82aeeff1aa43579e;
346 
347     string private constant ERROR_ALREADY_INITIALIZED = "INIT_ALREADY_INITIALIZED";
348     string private constant ERROR_NOT_INITIALIZED = "INIT_NOT_INITIALIZED";
349 
350     modifier onlyInit {
351         require(getInitializationBlock() == 0, ERROR_ALREADY_INITIALIZED);
352         _;
353     }
354 
355     modifier isInitialized {
356         require(hasInitialized(), ERROR_NOT_INITIALIZED);
357         _;
358     }
359 
360     /**
361     * @return Block number in which the contract was initialized
362     */
363     function getInitializationBlock() public view returns (uint256) {
364         return INITIALIZATION_BLOCK_POSITION.getStorageUint256();
365     }
366 
367     /**
368     * @return Whether the contract has been initialized by the time of the current block
369     */
370     function hasInitialized() public view returns (bool) {
371         uint256 initializationBlock = getInitializationBlock();
372         return initializationBlock != 0 && getBlockNumber() >= initializationBlock;
373     }
374 
375     /**
376     * @dev Function to be called by top level contract after initialization has finished.
377     */
378     function initialized() internal onlyInit {
379         INITIALIZATION_BLOCK_POSITION.setStorageUint256(getBlockNumber());
380     }
381 
382     /**
383     * @dev Function to be called by top level contract after initialization to enable the contract
384     *      at a future block number rather than immediately.
385     */
386     function initializedAt(uint256 _blockNumber) internal onlyInit {
387         INITIALIZATION_BLOCK_POSITION.setStorageUint256(_blockNumber);
388     }
389 }
390 // File: @aragon/os/contracts/common/Petrifiable.sol
391 /*
392  * SPDX-License-Identitifer:    MIT
393  */
394 
395 pragma solidity ^0.4.24;
396 
397 
398 
399 contract Petrifiable is Initializable {
400     // Use block UINT256_MAX (which should be never) as the initializable date
401     uint256 internal constant PETRIFIED_BLOCK = uint256(-1);
402 
403     function isPetrified() public view returns (bool) {
404         return getInitializationBlock() == PETRIFIED_BLOCK;
405     }
406 
407     /**
408     * @dev Function to be called by top level contract to prevent being initialized.
409     *      Useful for freezing base contracts when they're used behind proxies.
410     */
411     function petrify() internal onlyInit {
412         initializedAt(PETRIFIED_BLOCK);
413     }
414 }
415 // File: @aragon/os/contracts/lib/token/ERC20.sol
416 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/a9f910d34f0ab33a1ae5e714f69f9596a02b4d91/contracts/token/ERC20/ERC20.sol
417 
418 pragma solidity ^0.4.24;
419 
420 
421 /**
422  * @title ERC20 interface
423  * @dev see https://github.com/ethereum/EIPs/issues/20
424  */
425 contract ERC20 {
426     function totalSupply() public view returns (uint256);
427 
428     function balanceOf(address _who) public view returns (uint256);
429 
430     function allowance(address _owner, address _spender)
431         public view returns (uint256);
432 
433     function transfer(address _to, uint256 _value) public returns (bool);
434 
435     function approve(address _spender, uint256 _value)
436         public returns (bool);
437 
438     function transferFrom(address _from, address _to, uint256 _value)
439         public returns (bool);
440 
441     event Transfer(
442         address indexed from,
443         address indexed to,
444         uint256 value
445     );
446 
447     event Approval(
448         address indexed owner,
449         address indexed spender,
450         uint256 value
451     );
452 }
453 // File: @aragon/os/contracts/common/EtherTokenConstant.sol
454 /*
455  * SPDX-License-Identitifer:    MIT
456  */
457 
458 pragma solidity ^0.4.24;
459 
460 
461 // aragonOS and aragon-apps rely on address(0) to denote native ETH, in
462 // contracts where both tokens and ETH are accepted
463 contract EtherTokenConstant {
464     address internal constant ETH = address(0);
465 }
466 // File: @aragon/os/contracts/common/VaultRecoverable.sol
467 /*
468  * SPDX-License-Identitifer:    MIT
469  */
470 
471 pragma solidity ^0.4.24;
472 
473 
474 
475 
476 
477 
478 contract VaultRecoverable is IVaultRecoverable, EtherTokenConstant, IsContract {
479     string private constant ERROR_DISALLOWED = "RECOVER_DISALLOWED";
480     string private constant ERROR_VAULT_NOT_CONTRACT = "RECOVER_VAULT_NOT_CONTRACT";
481 
482     /**
483      * @notice Send funds to recovery Vault. This contract should never receive funds,
484      *         but in case it does, this function allows one to recover them.
485      * @param _token Token balance to be sent to recovery vault.
486      */
487     function transferToVault(address _token) external {
488         require(allowRecoverability(_token), ERROR_DISALLOWED);
489         address vault = getRecoveryVault();
490         require(isContract(vault), ERROR_VAULT_NOT_CONTRACT);
491 
492         if (_token == ETH) {
493             vault.transfer(address(this).balance);
494         } else {
495             uint256 amount = ERC20(_token).balanceOf(this);
496             ERC20(_token).transfer(vault, amount);
497         }
498     }
499 
500     /**
501     * @dev By default deriving from AragonApp makes it recoverable
502     * @param token Token address that would be recovered
503     * @return bool whether the app allows the recovery
504     */
505     function allowRecoverability(address token) public view returns (bool) {
506         return true;
507     }
508 
509     // Cast non-implemented interface to be public so we can use it internally
510     function getRecoveryVault() public view returns (address);
511 }
512 // File: @aragon/os/contracts/apps/AppStorage.sol
513 /*
514  * SPDX-License-Identitifer:    MIT
515  */
516 
517 pragma solidity ^0.4.24;
518 
519 
520 
521 
522 contract AppStorage {
523     using UnstructuredStorage for bytes32;
524 
525     /* Hardcoded constants to save gas
526     bytes32 internal constant KERNEL_POSITION = keccak256("aragonOS.appStorage.kernel");
527     bytes32 internal constant APP_ID_POSITION = keccak256("aragonOS.appStorage.appId");
528     */
529     bytes32 internal constant KERNEL_POSITION = 0x4172f0f7d2289153072b0a6ca36959e0cbe2efc3afe50fc81636caa96338137b;
530     bytes32 internal constant APP_ID_POSITION = 0xd625496217aa6a3453eecb9c3489dc5a53e6c67b444329ea2b2cbc9ff547639b;
531 
532     function kernel() public view returns (IKernel) {
533         return IKernel(KERNEL_POSITION.getStorageAddress());
534     }
535 
536     function appId() public view returns (bytes32) {
537         return APP_ID_POSITION.getStorageBytes32();
538     }
539 
540     function setKernel(IKernel _kernel) internal {
541         KERNEL_POSITION.setStorageAddress(address(_kernel));
542     }
543 
544     function setAppId(bytes32 _appId) internal {
545         APP_ID_POSITION.setStorageBytes32(_appId);
546     }
547 }
548 // File: @aragon/os/contracts/common/DelegateProxy.sol
549 contract DelegateProxy is ERCProxy, IsContract {
550     uint256 internal constant FWD_GAS_LIMIT = 10000;
551 
552     /**
553     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
554     * @param _dst Destination address to perform the delegatecall
555     * @param _calldata Calldata for the delegatecall
556     */
557     function delegatedFwd(address _dst, bytes _calldata) internal {
558         require(isContract(_dst));
559         uint256 fwdGasLimit = FWD_GAS_LIMIT;
560 
561         assembly {
562             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
563             let size := returndatasize
564             let ptr := mload(0x40)
565             returndatacopy(ptr, 0, size)
566 
567             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
568             // if the call returned error data, forward it
569             switch result case 0 { revert(ptr, size) }
570             default { return(ptr, size) }
571         }
572     }
573 }
574 // File: @aragon/os/contracts/common/DepositableStorage.sol
575 contract DepositableStorage {
576     using UnstructuredStorage for bytes32;
577 
578     // keccak256("aragonOS.depositableStorage.depositable")
579     bytes32 internal constant DEPOSITABLE_POSITION = 0x665fd576fbbe6f247aff98f5c94a561e3f71ec2d3c988d56f12d342396c50cea;
580 
581     function isDepositable() public view returns (bool) {
582         return DEPOSITABLE_POSITION.getStorageBool();
583     }
584 
585     function setDepositable(bool _depositable) internal {
586         DEPOSITABLE_POSITION.setStorageBool(_depositable);
587     }
588 }
589 // File: @aragon/os/contracts/common/DepositableDelegateProxy.sol
590 contract DepositableDelegateProxy is DepositableStorage, DelegateProxy {
591     event ProxyDeposit(address sender, uint256 value);
592 
593     function () external payable {
594         // send / transfer
595         if (gasleft() < FWD_GAS_LIMIT) {
596             require(msg.value > 0 && msg.data.length == 0);
597             require(isDepositable());
598             emit ProxyDeposit(msg.sender, msg.value);
599         } else { // all calls except for send or transfer
600             address target = implementation();
601             delegatedFwd(target, msg.data);
602         }
603     }
604 }
605 // File: @aragon/os/contracts/apps/AppProxyBase.sol
606 contract AppProxyBase is AppStorage, DepositableDelegateProxy, KernelNamespaceConstants {
607     /**
608     * @dev Initialize AppProxy
609     * @param _kernel Reference to organization kernel for the app
610     * @param _appId Identifier for app
611     * @param _initializePayload Payload for call to be made after setup to initialize
612     */
613     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public {
614         setKernel(_kernel);
615         setAppId(_appId);
616 
617         // Implicit check that kernel is actually a Kernel
618         // The EVM doesn't actually provide a way for us to make sure, but we can force a revert to
619         // occur if the kernel is set to 0x0 or a non-code address when we try to call a method on
620         // it.
621         address appCode = getAppBase(_appId);
622 
623         // If initialize payload is provided, it will be executed
624         if (_initializePayload.length > 0) {
625             require(isContract(appCode));
626             // Cannot make delegatecall as a delegateproxy.delegatedFwd as it
627             // returns ending execution context and halts contract deployment
628             require(appCode.delegatecall(_initializePayload));
629         }
630     }
631 
632     function getAppBase(bytes32 _appId) internal view returns (address) {
633         return kernel().getApp(KERNEL_APP_BASES_NAMESPACE, _appId);
634     }
635 }
636 // File: @aragon/os/contracts/apps/AppProxyUpgradeable.sol
637 contract AppProxyUpgradeable is AppProxyBase {
638     /**
639     * @dev Initialize AppProxyUpgradeable (makes it an upgradeable Aragon app)
640     * @param _kernel Reference to organization kernel for the app
641     * @param _appId Identifier for app
642     * @param _initializePayload Payload for call to be made after setup to initialize
643     */
644     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
645         AppProxyBase(_kernel, _appId, _initializePayload)
646         public // solium-disable-line visibility-first
647     {
648 
649     }
650 
651     /**
652      * @dev ERC897, the address the proxy would delegate calls to
653      */
654     function implementation() public view returns (address) {
655         return getAppBase(appId());
656     }
657 
658     /**
659      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
660      */
661     function proxyType() public pure returns (uint256 proxyTypeId) {
662         return UPGRADEABLE;
663     }
664 }
665 // File: @aragon/os/contracts/apps/AppProxyPinned.sol
666 contract AppProxyPinned is IsContract, AppProxyBase {
667     using UnstructuredStorage for bytes32;
668 
669     // keccak256("aragonOS.appStorage.pinnedCode")
670     bytes32 internal constant PINNED_CODE_POSITION = 0xdee64df20d65e53d7f51cb6ab6d921a0a6a638a91e942e1d8d02df28e31c038e;
671 
672     /**
673     * @dev Initialize AppProxyPinned (makes it an un-upgradeable Aragon app)
674     * @param _kernel Reference to organization kernel for the app
675     * @param _appId Identifier for app
676     * @param _initializePayload Payload for call to be made after setup to initialize
677     */
678     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
679         AppProxyBase(_kernel, _appId, _initializePayload)
680         public // solium-disable-line visibility-first
681     {
682         setPinnedCode(getAppBase(_appId));
683         require(isContract(pinnedCode()));
684     }
685 
686     /**
687      * @dev ERC897, the address the proxy would delegate calls to
688      */
689     function implementation() public view returns (address) {
690         return pinnedCode();
691     }
692 
693     /**
694      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
695      */
696     function proxyType() public pure returns (uint256 proxyTypeId) {
697         return FORWARDING;
698     }
699 
700     function setPinnedCode(address _pinnedCode) internal {
701         PINNED_CODE_POSITION.setStorageAddress(_pinnedCode);
702     }
703 
704     function pinnedCode() internal view returns (address) {
705         return PINNED_CODE_POSITION.getStorageAddress();
706     }
707 }
708 // File: @aragon/os/contracts/factory/AppProxyFactory.sol
709 contract AppProxyFactory {
710     event NewAppProxy(address proxy, bool isUpgradeable, bytes32 appId);
711 
712     function newAppProxy(IKernel _kernel, bytes32 _appId) public returns (AppProxyUpgradeable) {
713         return newAppProxy(_kernel, _appId, new bytes(0));
714     }
715 
716     function newAppProxy(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyUpgradeable) {
717         AppProxyUpgradeable proxy = new AppProxyUpgradeable(_kernel, _appId, _initializePayload);
718         emit NewAppProxy(address(proxy), true, _appId);
719         return proxy;
720     }
721 
722     function newAppProxyPinned(IKernel _kernel, bytes32 _appId) public returns (AppProxyPinned) {
723         return newAppProxyPinned(_kernel, _appId, new bytes(0));
724     }
725 
726     function newAppProxyPinned(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyPinned) {
727         AppProxyPinned proxy = new AppProxyPinned(_kernel, _appId, _initializePayload);
728         emit NewAppProxy(address(proxy), false, _appId);
729         return proxy;
730     }
731 }
732 // File: @aragon/os/contracts/kernel/Kernel.sol
733 // solium-disable-next-line max-len
734 contract Kernel is IKernel, KernelStorage, KernelAppIds, KernelNamespaceConstants, Petrifiable, IsContract, VaultRecoverable, AppProxyFactory, ACLSyntaxSugar {
735     /* Hardcoded constants to save gas
736     bytes32 public constant APP_MANAGER_ROLE = keccak256("APP_MANAGER_ROLE");
737     */
738     bytes32 public constant APP_MANAGER_ROLE = 0xb6d92708f3d4817afc106147d969e229ced5c46e65e0a5002a0d391287762bd0;
739 
740     string private constant ERROR_APP_NOT_CONTRACT = "KERNEL_APP_NOT_CONTRACT";
741     string private constant ERROR_INVALID_APP_CHANGE = "KERNEL_INVALID_APP_CHANGE";
742     string private constant ERROR_AUTH_FAILED = "KERNEL_AUTH_FAILED";
743 
744     /**
745     * @dev Constructor that allows the deployer to choose if the base instance should be petrified immediately.
746     * @param _shouldPetrify Immediately petrify this instance so that it can never be initialized
747     */
748     constructor(bool _shouldPetrify) public {
749         if (_shouldPetrify) {
750             petrify();
751         }
752     }
753 
754     /**
755     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
756     * @notice Initializes a kernel instance along with its ACL and sets `_permissionsCreator` as the entity that can create other permissions
757     * @param _baseAcl Address of base ACL app
758     * @param _permissionsCreator Entity that will be given permission over createPermission
759     */
760     function initialize(IACL _baseAcl, address _permissionsCreator) public onlyInit {
761         initialized();
762 
763         // Set ACL base
764         _setApp(KERNEL_APP_BASES_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, _baseAcl);
765 
766         // Create ACL instance and attach it as the default ACL app
767         IACL acl = IACL(newAppProxy(this, KERNEL_DEFAULT_ACL_APP_ID));
768         acl.initialize(_permissionsCreator);
769         _setApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, acl);
770 
771         recoveryVaultAppId = KERNEL_DEFAULT_VAULT_APP_ID;
772     }
773 
774     /**
775     * @dev Create a new instance of an app linked to this kernel
776     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`
777     * @param _appId Identifier for app
778     * @param _appBase Address of the app's base implementation
779     * @return AppProxy instance
780     */
781     function newAppInstance(bytes32 _appId, address _appBase)
782         public
783         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
784         returns (ERCProxy appProxy)
785     {
786         return newAppInstance(_appId, _appBase, new bytes(0), false);
787     }
788 
789     /**
790     * @dev Create a new instance of an app linked to this kernel and set its base
791     *      implementation if it was not already set
792     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
793     * @param _appId Identifier for app
794     * @param _appBase Address of the app's base implementation
795     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
796     * @param _setDefault Whether the app proxy app is the default one.
797     *        Useful when the Kernel needs to know of an instance of a particular app,
798     *        like Vault for escape hatch mechanism.
799     * @return AppProxy instance
800     */
801     function newAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
802         public
803         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
804         returns (ERCProxy appProxy)
805     {
806         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
807         appProxy = newAppProxy(this, _appId, _initializePayload);
808         // By calling setApp directly and not the internal functions, we make sure the params are checked
809         // and it will only succeed if sender has permissions to set something to the namespace.
810         if (_setDefault) {
811             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
812         }
813     }
814 
815     /**
816     * @dev Create a new pinned instance of an app linked to this kernel
817     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`.
818     * @param _appId Identifier for app
819     * @param _appBase Address of the app's base implementation
820     * @return AppProxy instance
821     */
822     function newPinnedAppInstance(bytes32 _appId, address _appBase)
823         public
824         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
825         returns (ERCProxy appProxy)
826     {
827         return newPinnedAppInstance(_appId, _appBase, new bytes(0), false);
828     }
829 
830     /**
831     * @dev Create a new pinned instance of an app linked to this kernel and set
832     *      its base implementation if it was not already set
833     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
834     * @param _appId Identifier for app
835     * @param _appBase Address of the app's base implementation
836     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
837     * @param _setDefault Whether the app proxy app is the default one.
838     *        Useful when the Kernel needs to know of an instance of a particular app,
839     *        like Vault for escape hatch mechanism.
840     * @return AppProxy instance
841     */
842     function newPinnedAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
843         public
844         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
845         returns (ERCProxy appProxy)
846     {
847         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
848         appProxy = newAppProxyPinned(this, _appId, _initializePayload);
849         // By calling setApp directly and not the internal functions, we make sure the params are checked
850         // and it will only succeed if sender has permissions to set something to the namespace.
851         if (_setDefault) {
852             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
853         }
854     }
855 
856     /**
857     * @dev Set the resolving address of an app instance or base implementation
858     * @notice Set the resolving address of `_appId` in namespace `_namespace` to `_app`
859     * @param _namespace App namespace to use
860     * @param _appId Identifier for app
861     * @param _app Address of the app instance or base implementation
862     * @return ID of app
863     */
864     function setApp(bytes32 _namespace, bytes32 _appId, address _app)
865         public
866         auth(APP_MANAGER_ROLE, arr(_namespace, _appId))
867     {
868         _setApp(_namespace, _appId, _app);
869     }
870 
871     /**
872     * @dev Set the default vault id for the escape hatch mechanism
873     * @param _recoveryVaultAppId Identifier of the recovery vault app
874     */
875     function setRecoveryVaultAppId(bytes32 _recoveryVaultAppId)
876         public
877         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_ADDR_NAMESPACE, _recoveryVaultAppId))
878     {
879         recoveryVaultAppId = _recoveryVaultAppId;
880     }
881 
882     // External access to default app id and namespace constants to mimic default getters for constants
883     /* solium-disable function-order, mixedcase */
884     function CORE_NAMESPACE() external pure returns (bytes32) { return KERNEL_CORE_NAMESPACE; }
885     function APP_BASES_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_BASES_NAMESPACE; }
886     function APP_ADDR_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_ADDR_NAMESPACE; }
887     function KERNEL_APP_ID() external pure returns (bytes32) { return KERNEL_CORE_APP_ID; }
888     function DEFAULT_ACL_APP_ID() external pure returns (bytes32) { return KERNEL_DEFAULT_ACL_APP_ID; }
889     /* solium-enable function-order, mixedcase */
890 
891     /**
892     * @dev Get the address of an app instance or base implementation
893     * @param _namespace App namespace to use
894     * @param _appId Identifier for app
895     * @return Address of the app
896     */
897     function getApp(bytes32 _namespace, bytes32 _appId) public view returns (address) {
898         return apps[_namespace][_appId];
899     }
900 
901     /**
902     * @dev Get the address of the recovery Vault instance (to recover funds)
903     * @return Address of the Vault
904     */
905     function getRecoveryVault() public view returns (address) {
906         return apps[KERNEL_APP_ADDR_NAMESPACE][recoveryVaultAppId];
907     }
908 
909     /**
910     * @dev Get the installed ACL app
911     * @return ACL app
912     */
913     function acl() public view returns (IACL) {
914         return IACL(getApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID));
915     }
916 
917     /**
918     * @dev Function called by apps to check ACL on kernel or to check permission status
919     * @param _who Sender of the original call
920     * @param _where Address of the app
921     * @param _what Identifier for a group of actions in app
922     * @param _how Extra data for ACL auth
923     * @return Boolean indicating whether the ACL allows the role or not.
924     *         Always returns false if the kernel hasn't been initialized yet.
925     */
926     function hasPermission(address _who, address _where, bytes32 _what, bytes _how) public view returns (bool) {
927         IACL defaultAcl = acl();
928         return address(defaultAcl) != address(0) && // Poor man's initialization check (saves gas)
929             defaultAcl.hasPermission(_who, _where, _what, _how);
930     }
931 
932     function _setApp(bytes32 _namespace, bytes32 _appId, address _app) internal {
933         require(isContract(_app), ERROR_APP_NOT_CONTRACT);
934         apps[_namespace][_appId] = _app;
935         emit SetApp(_namespace, _appId, _app);
936     }
937 
938     function _setAppIfNew(bytes32 _namespace, bytes32 _appId, address _app) internal {
939         address app = getApp(_namespace, _appId);
940         if (app != address(0)) {
941             // The only way to set an app is if it passes the isContract check, so no need to check it again
942             require(app == _app, ERROR_INVALID_APP_CHANGE);
943         } else {
944             _setApp(_namespace, _appId, _app);
945         }
946     }
947 
948     modifier auth(bytes32 _role, uint256[] memory params) {
949         // Force cast the uint256[] into a bytes array, by overwriting its length
950         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
951         // with params and a new length, and params becomes invalid from this point forward
952         bytes memory how;
953         uint256 byteLength = params.length * 32;
954         assembly {
955             how := params
956             mstore(how, byteLength)
957         }
958 
959         require(hasPermission(msg.sender, address(this), _role, how), ERROR_AUTH_FAILED);
960         _;
961     }
962 }
963 // File: @aragon/os/contracts/kernel/KernelProxy.sol
964 contract KernelProxy is KernelStorage, KernelAppIds, KernelNamespaceConstants, IsContract, DepositableDelegateProxy {
965     /**
966     * @dev KernelProxy is a proxy contract to a kernel implementation. The implementation
967     *      can update the reference, which effectively upgrades the contract
968     * @param _kernelImpl Address of the contract used as implementation for kernel
969     */
970     constructor(IKernel _kernelImpl) public {
971         require(isContract(address(_kernelImpl)));
972         apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID] = _kernelImpl;
973     }
974 
975     /**
976      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
977      */
978     function proxyType() public pure returns (uint256 proxyTypeId) {
979         return UPGRADEABLE;
980     }
981 
982     /**
983     * @dev ERC897, the address the proxy would delegate calls to
984     */
985     function implementation() public view returns (address) {
986         return apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID];
987     }
988 }
989 // File: @aragon/os/contracts/common/Autopetrified.sol
990 /*
991  * SPDX-License-Identitifer:    MIT
992  */
993 
994 pragma solidity ^0.4.24;
995 
996 
997 
998 contract Autopetrified is Petrifiable {
999     constructor() public {
1000         // Immediately petrify base (non-proxy) instances of inherited contracts on deploy.
1001         // This renders them uninitializable (and unusable without a proxy).
1002         petrify();
1003     }
1004 }
1005 // File: @aragon/os/contracts/evmscript/IEVMScriptExecutor.sol
1006 /*
1007  * SPDX-License-Identitifer:    MIT
1008  */
1009 
1010 pragma solidity ^0.4.24;
1011 
1012 
1013 interface IEVMScriptExecutor {
1014     function execScript(bytes script, bytes input, address[] blacklist) external returns (bytes);
1015     function executorType() external pure returns (bytes32);
1016 }
1017 // File: @aragon/os/contracts/evmscript/IEVMScriptRegistry.sol
1018 /*
1019  * SPDX-License-Identitifer:    MIT
1020  */
1021 
1022 pragma solidity ^0.4.24;
1023 
1024 
1025 
1026 contract EVMScriptRegistryConstants {
1027     /* Hardcoded constants to save gas
1028     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = apmNamehash("evmreg");
1029     */
1030     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = 0xddbcfd564f642ab5627cf68b9b7d374fb4f8a36e941a75d89c87998cef03bd61;
1031 }
1032 
1033 
1034 interface IEVMScriptRegistry {
1035     function addScriptExecutor(IEVMScriptExecutor executor) external returns (uint id);
1036     function disableScriptExecutor(uint256 executorId) external;
1037 
1038     // TODO: this should be external
1039     // See https://github.com/ethereum/solidity/issues/4832
1040     function getScriptExecutor(bytes script) public view returns (IEVMScriptExecutor);
1041 }
1042 // File: @aragon/os/contracts/evmscript/EVMScriptRunner.sol
1043 /*
1044  * SPDX-License-Identitifer:    MIT
1045  */
1046 
1047 pragma solidity ^0.4.24;
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 contract EVMScriptRunner is AppStorage, Initializable, EVMScriptRegistryConstants, KernelNamespaceConstants {
1056     string private constant ERROR_EXECUTOR_UNAVAILABLE = "EVMRUN_EXECUTOR_UNAVAILABLE";
1057     string private constant ERROR_EXECUTION_REVERTED = "EVMRUN_EXECUTION_REVERTED";
1058     string private constant ERROR_PROTECTED_STATE_MODIFIED = "EVMRUN_PROTECTED_STATE_MODIFIED";
1059 
1060     event ScriptResult(address indexed executor, bytes script, bytes input, bytes returnData);
1061 
1062     function getEVMScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
1063         return IEVMScriptExecutor(getEVMScriptRegistry().getScriptExecutor(_script));
1064     }
1065 
1066     function getEVMScriptRegistry() public view returns (IEVMScriptRegistry) {
1067         address registryAddr = kernel().getApp(KERNEL_APP_ADDR_NAMESPACE, EVMSCRIPT_REGISTRY_APP_ID);
1068         return IEVMScriptRegistry(registryAddr);
1069     }
1070 
1071     function runScript(bytes _script, bytes _input, address[] _blacklist)
1072         internal
1073         isInitialized
1074         protectState
1075         returns (bytes)
1076     {
1077         // TODO: Too much data flying around, maybe extracting spec id here is cheaper
1078         IEVMScriptExecutor executor = getEVMScriptExecutor(_script);
1079         require(address(executor) != address(0), ERROR_EXECUTOR_UNAVAILABLE);
1080 
1081         bytes4 sig = executor.execScript.selector;
1082         bytes memory data = abi.encodeWithSelector(sig, _script, _input, _blacklist);
1083         require(address(executor).delegatecall(data), ERROR_EXECUTION_REVERTED);
1084 
1085         bytes memory output = returnedDataDecoded();
1086 
1087         emit ScriptResult(address(executor), _script, _input, output);
1088 
1089         return output;
1090     }
1091 
1092     /**
1093     * @dev copies and returns last's call data. Needs to ABI decode first
1094     */
1095     function returnedDataDecoded() internal pure returns (bytes ret) {
1096         assembly {
1097             let size := returndatasize
1098             switch size
1099             case 0 {}
1100             default {
1101                 ret := mload(0x40) // free mem ptr get
1102                 mstore(0x40, add(ret, add(size, 0x20))) // free mem ptr set
1103                 returndatacopy(ret, 0x20, sub(size, 0x20)) // copy return data
1104             }
1105         }
1106         return ret;
1107     }
1108 
1109     modifier protectState {
1110         address preKernel = address(kernel());
1111         bytes32 preAppId = appId();
1112         _; // exec
1113         require(address(kernel()) == preKernel, ERROR_PROTECTED_STATE_MODIFIED);
1114         require(appId() == preAppId, ERROR_PROTECTED_STATE_MODIFIED);
1115     }
1116 }
1117 // File: @aragon/os/contracts/apps/AragonApp.sol
1118 /*
1119  * SPDX-License-Identitifer:    MIT
1120  */
1121 
1122 pragma solidity ^0.4.24;
1123 
1124 
1125 
1126 
1127 
1128 
1129 
1130 // Contracts inheriting from AragonApp are, by default, immediately petrified upon deployment so
1131 // that they can never be initialized.
1132 // Unless overriden, this behaviour enforces those contracts to be usable only behind an AppProxy.
1133 // ACLSyntaxSugar and EVMScriptRunner are not directly used by this contract, but are included so
1134 // that they are automatically usable by subclassing contracts
1135 contract AragonApp is AppStorage, Autopetrified, VaultRecoverable, EVMScriptRunner, ACLSyntaxSugar {
1136     string private constant ERROR_AUTH_FAILED = "APP_AUTH_FAILED";
1137 
1138     modifier auth(bytes32 _role) {
1139         require(canPerform(msg.sender, _role, new uint256[](0)), ERROR_AUTH_FAILED);
1140         _;
1141     }
1142 
1143     modifier authP(bytes32 _role, uint256[] _params) {
1144         require(canPerform(msg.sender, _role, _params), ERROR_AUTH_FAILED);
1145         _;
1146     }
1147 
1148     /**
1149     * @dev Check whether an action can be performed by a sender for a particular role on this app
1150     * @param _sender Sender of the call
1151     * @param _role Role on this app
1152     * @param _params Permission params for the role
1153     * @return Boolean indicating whether the sender has the permissions to perform the action.
1154     *         Always returns false if the app hasn't been initialized yet.
1155     */
1156     function canPerform(address _sender, bytes32 _role, uint256[] _params) public view returns (bool) {
1157         if (!hasInitialized()) {
1158             return false;
1159         }
1160 
1161         IKernel linkedKernel = kernel();
1162         if (address(linkedKernel) == address(0)) {
1163             return false;
1164         }
1165 
1166         // Force cast the uint256[] into a bytes array, by overwriting its length
1167         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
1168         // with _params and a new length, and _params becomes invalid from this point forward
1169         bytes memory how;
1170         uint256 byteLength = _params.length * 32;
1171         assembly {
1172             how := _params
1173             mstore(how, byteLength)
1174         }
1175         return linkedKernel.hasPermission(_sender, address(this), _role, how);
1176     }
1177 
1178     /**
1179     * @dev Get the recovery vault for the app
1180     * @return Recovery vault address for the app
1181     */
1182     function getRecoveryVault() public view returns (address) {
1183         // Funds recovery via a vault is only available when used with a kernel
1184         return kernel().getRecoveryVault(); // if kernel is not set, it will revert
1185     }
1186 }
1187 // File: @aragon/os/contracts/acl/IACLOracle.sol
1188 /*
1189  * SPDX-License-Identitifer:    MIT
1190  */
1191 
1192 pragma solidity ^0.4.24;
1193 
1194 
1195 interface IACLOracle {
1196     function canPerform(address who, address where, bytes32 what, uint256[] how) external view returns (bool);
1197 }
1198 // File: @aragon/os/contracts/acl/ACL.sol
1199 /* solium-disable function-order */
1200 // Allow public initialize() to be first
1201 contract ACL is IACL, TimeHelpers, AragonApp, ACLHelpers {
1202     /* Hardcoded constants to save gas
1203     bytes32 public constant CREATE_PERMISSIONS_ROLE = keccak256("CREATE_PERMISSIONS_ROLE");
1204     */
1205     bytes32 public constant CREATE_PERMISSIONS_ROLE = 0x0b719b33c83b8e5d300c521cb8b54ae9bd933996a14bef8c2f4e0285d2d2400a;
1206 
1207     enum Op { NONE, EQ, NEQ, GT, LT, GTE, LTE, RET, NOT, AND, OR, XOR, IF_ELSE } // op types
1208 
1209     struct Param {
1210         uint8 id;
1211         uint8 op;
1212         uint240 value; // even though value is an uint240 it can store addresses
1213         // in the case of 32 byte hashes losing 2 bytes precision isn't a huge deal
1214         // op and id take less than 1 byte each so it can be kept in 1 sstore
1215     }
1216 
1217     uint8 internal constant BLOCK_NUMBER_PARAM_ID = 200;
1218     uint8 internal constant TIMESTAMP_PARAM_ID    = 201;
1219     // 202 is unused
1220     uint8 internal constant ORACLE_PARAM_ID       = 203;
1221     uint8 internal constant LOGIC_OP_PARAM_ID     = 204;
1222     uint8 internal constant PARAM_VALUE_PARAM_ID  = 205;
1223     // TODO: Add execution times param type?
1224 
1225     /* Hardcoded constant to save gas
1226     bytes32 public constant EMPTY_PARAM_HASH = keccak256(uint256(0));
1227     */
1228     bytes32 public constant EMPTY_PARAM_HASH = 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563;
1229     bytes32 public constant NO_PERMISSION = bytes32(0);
1230     address public constant ANY_ENTITY = address(-1);
1231     address public constant BURN_ENTITY = address(1); // address(0) is already used as "no permission manager"
1232 
1233     uint256 internal constant ORACLE_CHECK_GAS = 30000;
1234 
1235     string private constant ERROR_AUTH_INIT_KERNEL = "ACL_AUTH_INIT_KERNEL";
1236     string private constant ERROR_AUTH_NO_MANAGER = "ACL_AUTH_NO_MANAGER";
1237     string private constant ERROR_EXISTENT_MANAGER = "ACL_EXISTENT_MANAGER";
1238 
1239     // Whether someone has a permission
1240     mapping (bytes32 => bytes32) internal permissions; // permissions hash => params hash
1241     mapping (bytes32 => Param[]) internal permissionParams; // params hash => params
1242 
1243     // Who is the manager of a permission
1244     mapping (bytes32 => address) internal permissionManager;
1245 
1246     event SetPermission(address indexed entity, address indexed app, bytes32 indexed role, bool allowed);
1247     event SetPermissionParams(address indexed entity, address indexed app, bytes32 indexed role, bytes32 paramsHash);
1248     event ChangePermissionManager(address indexed app, bytes32 indexed role, address indexed manager);
1249 
1250     modifier onlyPermissionManager(address _app, bytes32 _role) {
1251         require(msg.sender == getPermissionManager(_app, _role), ERROR_AUTH_NO_MANAGER);
1252         _;
1253     }
1254 
1255     modifier noPermissionManager(address _app, bytes32 _role) {
1256         // only allow permission creation (or re-creation) when there is no manager
1257         require(getPermissionManager(_app, _role) == address(0), ERROR_EXISTENT_MANAGER);
1258         _;
1259     }
1260 
1261     /**
1262     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
1263     * @notice Initialize an ACL instance and set `_permissionsCreator` as the entity that can create other permissions
1264     * @param _permissionsCreator Entity that will be given permission over createPermission
1265     */
1266     function initialize(address _permissionsCreator) public onlyInit {
1267         initialized();
1268         require(msg.sender == address(kernel()), ERROR_AUTH_INIT_KERNEL);
1269 
1270         _createPermission(_permissionsCreator, this, CREATE_PERMISSIONS_ROLE, _permissionsCreator);
1271     }
1272 
1273     /**
1274     * @dev Creates a permission that wasn't previously set and managed.
1275     *      If a created permission is removed it is possible to reset it with createPermission.
1276     *      This is the **ONLY** way to create permissions and set managers to permissions that don't
1277     *      have a manager.
1278     *      In terms of the ACL being initialized, this function implicitly protects all the other
1279     *      state-changing external functions, as they all require the sender to be a manager.
1280     * @notice Create a new permission granting `_entity` the ability to perform actions requiring `_role` on `_app`, setting `_manager` as the permission's manager
1281     * @param _entity Address of the whitelisted entity that will be able to perform the role
1282     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1283     * @param _role Identifier for the group of actions in app given access to perform
1284     * @param _manager Address of the entity that will be able to grant and revoke the permission further.
1285     */
1286     function createPermission(address _entity, address _app, bytes32 _role, address _manager)
1287         external
1288         auth(CREATE_PERMISSIONS_ROLE)
1289         noPermissionManager(_app, _role)
1290     {
1291         _createPermission(_entity, _app, _role, _manager);
1292     }
1293 
1294     /**
1295     * @dev Grants permission if allowed. This requires `msg.sender` to be the permission manager
1296     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
1297     * @param _entity Address of the whitelisted entity that will be able to perform the role
1298     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1299     * @param _role Identifier for the group of actions in app given access to perform
1300     */
1301     function grantPermission(address _entity, address _app, bytes32 _role)
1302         external
1303     {
1304         grantPermissionP(_entity, _app, _role, new uint256[](0));
1305     }
1306 
1307     /**
1308     * @dev Grants a permission with parameters if allowed. This requires `msg.sender` to be the permission manager
1309     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
1310     * @param _entity Address of the whitelisted entity that will be able to perform the role
1311     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1312     * @param _role Identifier for the group of actions in app given access to perform
1313     * @param _params Permission parameters
1314     */
1315     function grantPermissionP(address _entity, address _app, bytes32 _role, uint256[] _params)
1316         public
1317         onlyPermissionManager(_app, _role)
1318     {
1319         bytes32 paramsHash = _params.length > 0 ? _saveParams(_params) : EMPTY_PARAM_HASH;
1320         _setPermission(_entity, _app, _role, paramsHash);
1321     }
1322 
1323     /**
1324     * @dev Revokes permission if allowed. This requires `msg.sender` to be the the permission manager
1325     * @notice Revoke from `_entity` the ability to perform actions requiring `_role` on `_app`
1326     * @param _entity Address of the whitelisted entity to revoke access from
1327     * @param _app Address of the app in which the role will be revoked
1328     * @param _role Identifier for the group of actions in app being revoked
1329     */
1330     function revokePermission(address _entity, address _app, bytes32 _role)
1331         external
1332         onlyPermissionManager(_app, _role)
1333     {
1334         _setPermission(_entity, _app, _role, NO_PERMISSION);
1335     }
1336 
1337     /**
1338     * @notice Set `_newManager` as the manager of `_role` in `_app`
1339     * @param _newManager Address for the new manager
1340     * @param _app Address of the app in which the permission management is being transferred
1341     * @param _role Identifier for the group of actions being transferred
1342     */
1343     function setPermissionManager(address _newManager, address _app, bytes32 _role)
1344         external
1345         onlyPermissionManager(_app, _role)
1346     {
1347         _setPermissionManager(_newManager, _app, _role);
1348     }
1349 
1350     /**
1351     * @notice Remove the manager of `_role` in `_app`
1352     * @param _app Address of the app in which the permission is being unmanaged
1353     * @param _role Identifier for the group of actions being unmanaged
1354     */
1355     function removePermissionManager(address _app, bytes32 _role)
1356         external
1357         onlyPermissionManager(_app, _role)
1358     {
1359         _setPermissionManager(address(0), _app, _role);
1360     }
1361 
1362     /**
1363     * @notice Burn non-existent `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
1364     * @param _app Address of the app in which the permission is being burned
1365     * @param _role Identifier for the group of actions being burned
1366     */
1367     function createBurnedPermission(address _app, bytes32 _role)
1368         external
1369         auth(CREATE_PERMISSIONS_ROLE)
1370         noPermissionManager(_app, _role)
1371     {
1372         _setPermissionManager(BURN_ENTITY, _app, _role);
1373     }
1374 
1375     /**
1376     * @notice Burn `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
1377     * @param _app Address of the app in which the permission is being burned
1378     * @param _role Identifier for the group of actions being burned
1379     */
1380     function burnPermissionManager(address _app, bytes32 _role)
1381         external
1382         onlyPermissionManager(_app, _role)
1383     {
1384         _setPermissionManager(BURN_ENTITY, _app, _role);
1385     }
1386 
1387     /**
1388      * @notice Get parameters for permission array length
1389      * @param _entity Address of the whitelisted entity that will be able to perform the role
1390      * @param _app Address of the app
1391      * @param _role Identifier for a group of actions in app
1392      * @return Length of the array
1393      */
1394     function getPermissionParamsLength(address _entity, address _app, bytes32 _role) external view returns (uint) {
1395         return permissionParams[permissions[permissionHash(_entity, _app, _role)]].length;
1396     }
1397 
1398     /**
1399     * @notice Get parameter for permission
1400     * @param _entity Address of the whitelisted entity that will be able to perform the role
1401     * @param _app Address of the app
1402     * @param _role Identifier for a group of actions in app
1403     * @param _index Index of parameter in the array
1404     * @return Parameter (id, op, value)
1405     */
1406     function getPermissionParam(address _entity, address _app, bytes32 _role, uint _index)
1407         external
1408         view
1409         returns (uint8, uint8, uint240)
1410     {
1411         Param storage param = permissionParams[permissions[permissionHash(_entity, _app, _role)]][_index];
1412         return (param.id, param.op, param.value);
1413     }
1414 
1415     /**
1416     * @dev Get manager for permission
1417     * @param _app Address of the app
1418     * @param _role Identifier for a group of actions in app
1419     * @return address of the manager for the permission
1420     */
1421     function getPermissionManager(address _app, bytes32 _role) public view returns (address) {
1422         return permissionManager[roleHash(_app, _role)];
1423     }
1424 
1425     /**
1426     * @dev Function called by apps to check ACL on kernel or to check permission statu
1427     * @param _who Sender of the original call
1428     * @param _where Address of the app
1429     * @param _where Identifier for a group of actions in app
1430     * @param _how Permission parameters
1431     * @return boolean indicating whether the ACL allows the role or not
1432     */
1433     function hasPermission(address _who, address _where, bytes32 _what, bytes memory _how) public view returns (bool) {
1434         // Force cast the bytes array into a uint256[], by overwriting its length
1435         // Note that the uint256[] doesn't need to be initialized as we immediately overwrite it
1436         // with _how and a new length, and _how becomes invalid from this point forward
1437         uint256[] memory how;
1438         uint256 intsLength = _how.length / 32;
1439         assembly {
1440             how := _how
1441             mstore(how, intsLength)
1442         }
1443 
1444         return hasPermission(_who, _where, _what, how);
1445     }
1446 
1447     function hasPermission(address _who, address _where, bytes32 _what, uint256[] memory _how) public view returns (bool) {
1448         bytes32 whoParams = permissions[permissionHash(_who, _where, _what)];
1449         if (whoParams != NO_PERMISSION && evalParams(whoParams, _who, _where, _what, _how)) {
1450             return true;
1451         }
1452 
1453         bytes32 anyParams = permissions[permissionHash(ANY_ENTITY, _where, _what)];
1454         if (anyParams != NO_PERMISSION && evalParams(anyParams, ANY_ENTITY, _where, _what, _how)) {
1455             return true;
1456         }
1457 
1458         return false;
1459     }
1460 
1461     function hasPermission(address _who, address _where, bytes32 _what) public view returns (bool) {
1462         uint256[] memory empty = new uint256[](0);
1463         return hasPermission(_who, _where, _what, empty);
1464     }
1465 
1466     function evalParams(
1467         bytes32 _paramsHash,
1468         address _who,
1469         address _where,
1470         bytes32 _what,
1471         uint256[] _how
1472     ) public view returns (bool)
1473     {
1474         if (_paramsHash == EMPTY_PARAM_HASH) {
1475             return true;
1476         }
1477 
1478         return _evalParam(_paramsHash, 0, _who, _where, _what, _how);
1479     }
1480 
1481     /**
1482     * @dev Internal createPermission for access inside the kernel (on instantiation)
1483     */
1484     function _createPermission(address _entity, address _app, bytes32 _role, address _manager) internal {
1485         _setPermission(_entity, _app, _role, EMPTY_PARAM_HASH);
1486         _setPermissionManager(_manager, _app, _role);
1487     }
1488 
1489     /**
1490     * @dev Internal function called to actually save the permission
1491     */
1492     function _setPermission(address _entity, address _app, bytes32 _role, bytes32 _paramsHash) internal {
1493         permissions[permissionHash(_entity, _app, _role)] = _paramsHash;
1494         bool entityHasPermission = _paramsHash != NO_PERMISSION;
1495         bool permissionHasParams = entityHasPermission && _paramsHash != EMPTY_PARAM_HASH;
1496 
1497         emit SetPermission(_entity, _app, _role, entityHasPermission);
1498         if (permissionHasParams) {
1499             emit SetPermissionParams(_entity, _app, _role, _paramsHash);
1500         }
1501     }
1502 
1503     function _saveParams(uint256[] _encodedParams) internal returns (bytes32) {
1504         bytes32 paramHash = keccak256(abi.encodePacked(_encodedParams));
1505         Param[] storage params = permissionParams[paramHash];
1506 
1507         if (params.length == 0) { // params not saved before
1508             for (uint256 i = 0; i < _encodedParams.length; i++) {
1509                 uint256 encodedParam = _encodedParams[i];
1510                 Param memory param = Param(decodeParamId(encodedParam), decodeParamOp(encodedParam), uint240(encodedParam));
1511                 params.push(param);
1512             }
1513         }
1514 
1515         return paramHash;
1516     }
1517 
1518     function _evalParam(
1519         bytes32 _paramsHash,
1520         uint32 _paramId,
1521         address _who,
1522         address _where,
1523         bytes32 _what,
1524         uint256[] _how
1525     ) internal view returns (bool)
1526     {
1527         if (_paramId >= permissionParams[_paramsHash].length) {
1528             return false; // out of bounds
1529         }
1530 
1531         Param memory param = permissionParams[_paramsHash][_paramId];
1532 
1533         if (param.id == LOGIC_OP_PARAM_ID) {
1534             return _evalLogic(param, _paramsHash, _who, _where, _what, _how);
1535         }
1536 
1537         uint256 value;
1538         uint256 comparedTo = uint256(param.value);
1539 
1540         // get value
1541         if (param.id == ORACLE_PARAM_ID) {
1542             value = checkOracle(IACLOracle(param.value), _who, _where, _what, _how) ? 1 : 0;
1543             comparedTo = 1;
1544         } else if (param.id == BLOCK_NUMBER_PARAM_ID) {
1545             value = getBlockNumber();
1546         } else if (param.id == TIMESTAMP_PARAM_ID) {
1547             value = getTimestamp();
1548         } else if (param.id == PARAM_VALUE_PARAM_ID) {
1549             value = uint256(param.value);
1550         } else {
1551             if (param.id >= _how.length) {
1552                 return false;
1553             }
1554             value = uint256(uint240(_how[param.id])); // force lost precision
1555         }
1556 
1557         if (Op(param.op) == Op.RET) {
1558             return uint256(value) > 0;
1559         }
1560 
1561         return compare(value, Op(param.op), comparedTo);
1562     }
1563 
1564     function _evalLogic(Param _param, bytes32 _paramsHash, address _who, address _where, bytes32 _what, uint256[] _how)
1565         internal
1566         view
1567         returns (bool)
1568     {
1569         if (Op(_param.op) == Op.IF_ELSE) {
1570             uint32 conditionParam;
1571             uint32 successParam;
1572             uint32 failureParam;
1573 
1574             (conditionParam, successParam, failureParam) = decodeParamsList(uint256(_param.value));
1575             bool result = _evalParam(_paramsHash, conditionParam, _who, _where, _what, _how);
1576 
1577             return _evalParam(_paramsHash, result ? successParam : failureParam, _who, _where, _what, _how);
1578         }
1579 
1580         uint32 param1;
1581         uint32 param2;
1582 
1583         (param1, param2,) = decodeParamsList(uint256(_param.value));
1584         bool r1 = _evalParam(_paramsHash, param1, _who, _where, _what, _how);
1585 
1586         if (Op(_param.op) == Op.NOT) {
1587             return !r1;
1588         }
1589 
1590         if (r1 && Op(_param.op) == Op.OR) {
1591             return true;
1592         }
1593 
1594         if (!r1 && Op(_param.op) == Op.AND) {
1595             return false;
1596         }
1597 
1598         bool r2 = _evalParam(_paramsHash, param2, _who, _where, _what, _how);
1599 
1600         if (Op(_param.op) == Op.XOR) {
1601             return r1 != r2;
1602         }
1603 
1604         return r2; // both or and and depend on result of r2 after checks
1605     }
1606 
1607     function compare(uint256 _a, Op _op, uint256 _b) internal pure returns (bool) {
1608         if (_op == Op.EQ)  return _a == _b;                              // solium-disable-line lbrace
1609         if (_op == Op.NEQ) return _a != _b;                              // solium-disable-line lbrace
1610         if (_op == Op.GT)  return _a > _b;                               // solium-disable-line lbrace
1611         if (_op == Op.LT)  return _a < _b;                               // solium-disable-line lbrace
1612         if (_op == Op.GTE) return _a >= _b;                              // solium-disable-line lbrace
1613         if (_op == Op.LTE) return _a <= _b;                              // solium-disable-line lbrace
1614         return false;
1615     }
1616 
1617     function checkOracle(IACLOracle _oracleAddr, address _who, address _where, bytes32 _what, uint256[] _how) internal view returns (bool) {
1618         bytes4 sig = _oracleAddr.canPerform.selector;
1619 
1620         // a raw call is required so we can return false if the call reverts, rather than reverting
1621         bytes memory checkCalldata = abi.encodeWithSelector(sig, _who, _where, _what, _how);
1622         uint256 oracleCheckGas = ORACLE_CHECK_GAS;
1623 
1624         bool ok;
1625         assembly {
1626             ok := staticcall(oracleCheckGas, _oracleAddr, add(checkCalldata, 0x20), mload(checkCalldata), 0, 0)
1627         }
1628 
1629         if (!ok) {
1630             return false;
1631         }
1632 
1633         uint256 size;
1634         assembly { size := returndatasize }
1635         if (size != 32) {
1636             return false;
1637         }
1638 
1639         bool result;
1640         assembly {
1641             let ptr := mload(0x40)       // get next free memory ptr
1642             returndatacopy(ptr, 0, size) // copy return from above `staticcall`
1643             result := mload(ptr)         // read data at ptr and set it to result
1644             mstore(ptr, 0)               // set pointer memory to 0 so it still is the next free ptr
1645         }
1646 
1647         return result;
1648     }
1649 
1650     /**
1651     * @dev Internal function that sets management
1652     */
1653     function _setPermissionManager(address _newManager, address _app, bytes32 _role) internal {
1654         permissionManager[roleHash(_app, _role)] = _newManager;
1655         emit ChangePermissionManager(_app, _role, _newManager);
1656     }
1657 
1658     function roleHash(address _where, bytes32 _what) internal pure returns (bytes32) {
1659         return keccak256(abi.encodePacked("ROLE", _where, _what));
1660     }
1661 
1662     function permissionHash(address _who, address _where, bytes32 _what) internal pure returns (bytes32) {
1663         return keccak256(abi.encodePacked("PERMISSION", _who, _where, _what));
1664     }
1665 }
1666 // File: @aragon/os/contracts/evmscript/ScriptHelpers.sol
1667 /*
1668  * SPDX-License-Identitifer:    MIT
1669  */
1670 
1671 pragma solidity ^0.4.24;
1672 
1673 
1674 library ScriptHelpers {
1675     function getSpecId(bytes _script) internal pure returns (uint32) {
1676         return uint32At(_script, 0);
1677     }
1678 
1679     function uint256At(bytes _data, uint256 _location) internal pure returns (uint256 result) {
1680         assembly {
1681             result := mload(add(_data, add(0x20, _location)))
1682         }
1683     }
1684 
1685     function addressAt(bytes _data, uint256 _location) internal pure returns (address result) {
1686         uint256 word = uint256At(_data, _location);
1687 
1688         assembly {
1689             result := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
1690             0x1000000000000000000000000)
1691         }
1692     }
1693 
1694     function uint32At(bytes _data, uint256 _location) internal pure returns (uint32 result) {
1695         uint256 word = uint256At(_data, _location);
1696 
1697         assembly {
1698             result := div(and(word, 0xffffffff00000000000000000000000000000000000000000000000000000000),
1699             0x100000000000000000000000000000000000000000000000000000000)
1700         }
1701     }
1702 
1703     function locationOf(bytes _data, uint256 _location) internal pure returns (uint256 result) {
1704         assembly {
1705             result := add(_data, add(0x20, _location))
1706         }
1707     }
1708 
1709     function toBytes(bytes4 _sig) internal pure returns (bytes) {
1710         bytes memory payload = new bytes(4);
1711         assembly { mstore(add(payload, 0x20), _sig) }
1712         return payload;
1713     }
1714 }
1715 // File: @aragon/os/contracts/evmscript/EVMScriptRegistry.sol
1716 /* solium-disable function-order */
1717 // Allow public initialize() to be first
1718 contract EVMScriptRegistry is IEVMScriptRegistry, EVMScriptRegistryConstants, AragonApp {
1719     using ScriptHelpers for bytes;
1720 
1721     /* Hardcoded constants to save gas
1722     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = keccak256("REGISTRY_ADD_EXECUTOR_ROLE");
1723     bytes32 public constant REGISTRY_MANAGER_ROLE = keccak256("REGISTRY_MANAGER_ROLE");
1724     */
1725     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = 0xc4e90f38eea8c4212a009ca7b8947943ba4d4a58d19b683417f65291d1cd9ed2;
1726     // WARN: Manager can censor all votes and the like happening in an org
1727     bytes32 public constant REGISTRY_MANAGER_ROLE = 0xf7a450ef335e1892cb42c8ca72e7242359d7711924b75db5717410da3f614aa3;
1728 
1729     string private constant ERROR_INEXISTENT_EXECUTOR = "EVMREG_INEXISTENT_EXECUTOR";
1730     string private constant ERROR_EXECUTOR_ENABLED = "EVMREG_EXECUTOR_ENABLED";
1731     string private constant ERROR_EXECUTOR_DISABLED = "EVMREG_EXECUTOR_DISABLED";
1732 
1733     struct ExecutorEntry {
1734         IEVMScriptExecutor executor;
1735         bool enabled;
1736     }
1737 
1738     uint256 private executorsNextIndex;
1739     mapping (uint256 => ExecutorEntry) public executors;
1740 
1741     event EnableExecutor(uint256 indexed executorId, address indexed executorAddress);
1742     event DisableExecutor(uint256 indexed executorId, address indexed executorAddress);
1743 
1744     modifier executorExists(uint256 _executorId) {
1745         require(_executorId > 0 && _executorId < executorsNextIndex, ERROR_INEXISTENT_EXECUTOR);
1746         _;
1747     }
1748 
1749     /**
1750     * @notice Initialize the registry
1751     */
1752     function initialize() public onlyInit {
1753         initialized();
1754         // Create empty record to begin executor IDs at 1
1755         executorsNextIndex = 1;
1756     }
1757 
1758     /**
1759     * @notice Add a new script executor with address `_executor` to the registry
1760     * @param _executor Address of the IEVMScriptExecutor that will be added to the registry
1761     * @return id Identifier of the executor in the registry
1762     */
1763     function addScriptExecutor(IEVMScriptExecutor _executor) external auth(REGISTRY_ADD_EXECUTOR_ROLE) returns (uint256 id) {
1764         uint256 executorId = executorsNextIndex++;
1765         executors[executorId] = ExecutorEntry(_executor, true);
1766         emit EnableExecutor(executorId, _executor);
1767         return executorId;
1768     }
1769 
1770     /**
1771     * @notice Disable script executor with ID `_executorId`
1772     * @param _executorId Identifier of the executor in the registry
1773     */
1774     function disableScriptExecutor(uint256 _executorId)
1775         external
1776         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
1777     {
1778         // Note that we don't need to check for an executor's existence in this case, as only
1779         // existing executors can be enabled
1780         ExecutorEntry storage executorEntry = executors[_executorId];
1781         require(executorEntry.enabled, ERROR_EXECUTOR_DISABLED);
1782         executorEntry.enabled = false;
1783         emit DisableExecutor(_executorId, executorEntry.executor);
1784     }
1785 
1786     /**
1787     * @notice Enable script executor with ID `_executorId`
1788     * @param _executorId Identifier of the executor in the registry
1789     */
1790     function enableScriptExecutor(uint256 _executorId)
1791         external
1792         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
1793         executorExists(_executorId)
1794     {
1795         ExecutorEntry storage executorEntry = executors[_executorId];
1796         require(!executorEntry.enabled, ERROR_EXECUTOR_ENABLED);
1797         executorEntry.enabled = true;
1798         emit EnableExecutor(_executorId, executorEntry.executor);
1799     }
1800 
1801     /**
1802     * @dev Get the script executor that can execute a particular script based on its first 4 bytes
1803     * @param _script EVMScript being inspected
1804     */
1805     function getScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
1806         uint256 id = _script.getSpecId();
1807 
1808         // Note that we don't need to check for an executor's existence in this case, as only
1809         // existing executors can be enabled
1810         ExecutorEntry storage entry = executors[id];
1811         return entry.enabled ? entry.executor : IEVMScriptExecutor(0);
1812     }
1813 }
1814 // File: @aragon/os/contracts/evmscript/executors/BaseEVMScriptExecutor.sol
1815 /*
1816  * SPDX-License-Identitifer:    MIT
1817  */
1818 
1819 pragma solidity ^0.4.24;
1820 
1821 
1822 
1823 
1824 contract BaseEVMScriptExecutor is IEVMScriptExecutor, Autopetrified {
1825     uint256 internal constant SCRIPT_START_LOCATION = 4;
1826 }
1827 // File: @aragon/os/contracts/evmscript/executors/CallsScript.sol
1828 // Inspired by https://github.com/reverendus/tx-manager
1829 
1830 
1831 
1832 
1833 contract CallsScript is BaseEVMScriptExecutor {
1834     using ScriptHelpers for bytes;
1835 
1836     /* Hardcoded constants to save gas
1837     bytes32 internal constant EXECUTOR_TYPE = keccak256("CALLS_SCRIPT");
1838     */
1839     bytes32 internal constant EXECUTOR_TYPE = 0x2dc858a00f3e417be1394b87c07158e989ec681ce8cc68a9093680ac1a870302;
1840 
1841     string private constant ERROR_BLACKLISTED_CALL = "EVMCALLS_BLACKLISTED_CALL";
1842     string private constant ERROR_INVALID_LENGTH = "EVMCALLS_INVALID_LENGTH";
1843     string private constant ERROR_CALL_REVERTED = "EVMCALLS_CALL_REVERTED";
1844 
1845     event LogScriptCall(address indexed sender, address indexed src, address indexed dst);
1846 
1847     /**
1848     * @notice Executes a number of call scripts
1849     * @param _script [ specId (uint32) ] many calls with this structure ->
1850     *    [ to (address: 20 bytes) ] [ calldataLength (uint32: 4 bytes) ] [ calldata (calldataLength bytes) ]
1851     * @param _blacklist Addresses the script cannot call to, or will revert.
1852     * @return always returns empty byte array
1853     */
1854     function execScript(bytes _script, bytes, address[] _blacklist) external isInitialized returns (bytes) {
1855         uint256 location = SCRIPT_START_LOCATION; // first 32 bits are spec id
1856         while (location < _script.length) {
1857             address contractAddress = _script.addressAt(location);
1858             // Check address being called is not blacklist
1859             for (uint i = 0; i < _blacklist.length; i++) {
1860                 require(contractAddress != _blacklist[i], ERROR_BLACKLISTED_CALL);
1861             }
1862 
1863             // logged before execution to ensure event ordering in receipt
1864             // if failed entire execution is reverted regardless
1865             emit LogScriptCall(msg.sender, address(this), contractAddress);
1866 
1867             uint256 calldataLength = uint256(_script.uint32At(location + 0x14));
1868             uint256 startOffset = location + 0x14 + 0x04;
1869             uint256 calldataStart = _script.locationOf(startOffset);
1870 
1871             // compute end of script / next location
1872             location = startOffset + calldataLength;
1873             require(location <= _script.length, ERROR_INVALID_LENGTH);
1874 
1875             bool success;
1876             assembly {
1877                 success := call(sub(gas, 5000), contractAddress, 0, calldataStart, calldataLength, 0, 0)
1878             }
1879 
1880             require(success, ERROR_CALL_REVERTED);
1881         }
1882     }
1883 
1884     function executorType() external pure returns (bytes32) {
1885         return EXECUTOR_TYPE;
1886     }
1887 }
1888 // File: @aragon/os/contracts/factory/EVMScriptRegistryFactory.sol
1889 contract EVMScriptRegistryFactory is AppProxyFactory, EVMScriptRegistryConstants {
1890     EVMScriptRegistry public baseReg;
1891     IEVMScriptExecutor public baseCallScript;
1892 
1893     constructor() public {
1894         baseReg = new EVMScriptRegistry();
1895         baseCallScript = IEVMScriptExecutor(new CallsScript());
1896     }
1897 
1898     function newEVMScriptRegistry(Kernel _dao) public returns (EVMScriptRegistry reg) {
1899         bytes memory initPayload = abi.encodeWithSelector(reg.initialize.selector);
1900         reg = EVMScriptRegistry(_dao.newPinnedAppInstance(EVMSCRIPT_REGISTRY_APP_ID, baseReg, initPayload, true));
1901 
1902         ACL acl = ACL(_dao.acl());
1903 
1904         acl.createPermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE(), this);
1905 
1906         reg.addScriptExecutor(baseCallScript);     // spec 1 = CallsScript
1907 
1908         // Clean up the permissions
1909         acl.revokePermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
1910         acl.removePermissionManager(reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
1911 
1912         return reg;
1913     }
1914 }
1915 // File: @aragon/os/contracts/factory/DAOFactory.sol
1916 contract DAOFactory {
1917     IKernel public baseKernel;
1918     IACL public baseACL;
1919     EVMScriptRegistryFactory public regFactory;
1920 
1921     event DeployDAO(address dao);
1922     event DeployEVMScriptRegistry(address reg);
1923 
1924     constructor(IKernel _baseKernel, IACL _baseACL, EVMScriptRegistryFactory _regFactory) public {
1925         // No need to init as it cannot be killed by devops199
1926         if (address(_regFactory) != address(0)) {
1927             regFactory = _regFactory;
1928         }
1929 
1930         baseKernel = _baseKernel;
1931         baseACL = _baseACL;
1932     }
1933 
1934     /**
1935     * @param _root Address that will be granted control to setup DAO permissions
1936     */
1937     function newDAO(address _root) public returns (Kernel) {
1938         Kernel dao = Kernel(new KernelProxy(baseKernel));
1939 
1940         if (address(regFactory) == address(0)) {
1941             dao.initialize(baseACL, _root);
1942         } else {
1943             dao.initialize(baseACL, this);
1944 
1945             ACL acl = ACL(dao.acl());
1946             bytes32 permRole = acl.CREATE_PERMISSIONS_ROLE();
1947             bytes32 appManagerRole = dao.APP_MANAGER_ROLE();
1948 
1949             acl.grantPermission(regFactory, acl, permRole);
1950 
1951             acl.createPermission(regFactory, dao, appManagerRole, this);
1952 
1953             EVMScriptRegistry reg = regFactory.newEVMScriptRegistry(dao);
1954             emit DeployEVMScriptRegistry(address(reg));
1955 
1956             // Clean up permissions
1957             // First, completely reset the APP_MANAGER_ROLE
1958             acl.revokePermission(regFactory, dao, appManagerRole);
1959             acl.removePermissionManager(dao, appManagerRole);
1960 
1961             // Then, make root the only holder and manager of CREATE_PERMISSIONS_ROLE
1962             acl.revokePermission(regFactory, acl, permRole);
1963             acl.revokePermission(this, acl, permRole);
1964             acl.grantPermission(_root, acl, permRole);
1965             acl.setPermissionManager(_root, acl, permRole);
1966         }
1967 
1968         emit DeployDAO(address(dao));
1969 
1970         return dao;
1971     }
1972 }
1973 // File: @aragon/apps-shared-minime/contracts/ITokenController.sol
1974 /// @dev The token controller contract must implement these functions
1975 
1976 
1977 interface ITokenController {
1978     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
1979     /// @param _owner The address that sent the ether to create tokens
1980     /// @return True if the ether is accepted, false if it throws
1981     function proxyPayment(address _owner) external payable returns(bool);
1982 
1983     /// @notice Notifies the controller about a token transfer allowing the
1984     ///  controller to react if desired
1985     /// @param _from The origin of the transfer
1986     /// @param _to The destination of the transfer
1987     /// @param _amount The amount of the transfer
1988     /// @return False if the controller does not authorize the transfer
1989     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
1990 
1991     /// @notice Notifies the controller about an approval allowing the
1992     ///  controller to react if desired
1993     /// @param _owner The address that calls `approve()`
1994     /// @param _spender The spender in the `approve()` call
1995     /// @param _amount The amount in the `approve()` call
1996     /// @return False if the controller does not authorize the approval
1997     function onApprove(address _owner, address _spender, uint _amount) external returns(bool);
1998 }
1999 // File: @aragon/apps-shared-minime/contracts/MiniMeToken.sol
2000 /*
2001     Copyright 2016, Jordi Baylina
2002     This program is free software: you can redistribute it and/or modify
2003     it under the terms of the GNU General Public License as published by
2004     the Free Software Foundation, either version 3 of the License, or
2005     (at your option) any later version.
2006     This program is distributed in the hope that it will be useful,
2007     but WITHOUT ANY WARRANTY; without even the implied warranty of
2008     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2009     GNU General Public License for more details.
2010     You should have received a copy of the GNU General Public License
2011     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2012  */
2013 
2014 /// @title MiniMeToken Contract
2015 /// @author Jordi Baylina
2016 /// @dev This token contract's goal is to make it easy for anyone to clone this
2017 ///  token using the token distribution at a given block, this will allow DAO's
2018 ///  and DApps to upgrade their features in a decentralized manner without
2019 ///  affecting the original token
2020 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2021 
2022 
2023 contract Controlled {
2024     /// @notice The address of the controller is the only address that can call
2025     ///  a function with this modifier
2026     modifier onlyController {
2027         require(msg.sender == controller);
2028         _;
2029     }
2030 
2031     address public controller;
2032 
2033     function Controlled()  public { controller = msg.sender;}
2034 
2035     /// @notice Changes the controller of the contract
2036     /// @param _newController The new controller of the contract
2037     function changeController(address _newController) onlyController  public {
2038         controller = _newController;
2039     }
2040 }
2041 
2042 contract ApproveAndCallFallBack {
2043     function receiveApproval(
2044         address from,
2045         uint256 _amount,
2046         address _token,
2047         bytes _data
2048     ) public;
2049 }
2050 
2051 /// @dev The actual token contract, the default controller is the msg.sender
2052 ///  that deploys the contract, so usually this token will be deployed by a
2053 ///  token controller contract, which Giveth will call a "Campaign"
2054 contract MiniMeToken is Controlled {
2055 
2056     string public name;                //The Token's name: e.g. DigixDAO Tokens
2057     uint8 public decimals;             //Number of decimals of the smallest unit
2058     string public symbol;              //An identifier: e.g. REP
2059     string public version = "MMT_0.1"; //An arbitrary versioning scheme
2060 
2061 
2062     /// @dev `Checkpoint` is the structure that attaches a block number to a
2063     ///  given value, the block number attached is the one that last changed the
2064     ///  value
2065     struct Checkpoint {
2066 
2067         // `fromBlock` is the block number that the value was generated from
2068         uint128 fromBlock;
2069 
2070         // `value` is the amount of tokens at a specific block number
2071         uint128 value;
2072     }
2073 
2074     // `parentToken` is the Token address that was cloned to produce this token;
2075     //  it will be 0x0 for a token that was not cloned
2076     MiniMeToken public parentToken;
2077 
2078     // `parentSnapShotBlock` is the block number from the Parent Token that was
2079     //  used to determine the initial distribution of the Clone Token
2080     uint public parentSnapShotBlock;
2081 
2082     // `creationBlock` is the block number that the Clone Token was created
2083     uint public creationBlock;
2084 
2085     // `balances` is the map that tracks the balance of each address, in this
2086     //  contract when the balance changes the block number that the change
2087     //  occurred is also included in the map
2088     mapping (address => Checkpoint[]) balances;
2089 
2090     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
2091     mapping (address => mapping (address => uint256)) allowed;
2092 
2093     // Tracks the history of the `totalSupply` of the token
2094     Checkpoint[] totalSupplyHistory;
2095 
2096     // Flag that determines if the token is transferable or not.
2097     bool public transfersEnabled;
2098 
2099     // The factory used to create new clone tokens
2100     MiniMeTokenFactory public tokenFactory;
2101 
2102 ////////////////
2103 // Constructor
2104 ////////////////
2105 
2106     /// @notice Constructor to create a MiniMeToken
2107     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
2108     ///  will create the Clone token contracts, the token factory needs to be
2109     ///  deployed first
2110     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
2111     ///  new token
2112     /// @param _parentSnapShotBlock Block of the parent token that will
2113     ///  determine the initial distribution of the clone token, set to 0 if it
2114     ///  is a new token
2115     /// @param _tokenName Name of the new token
2116     /// @param _decimalUnits Number of decimals of the new token
2117     /// @param _tokenSymbol Token Symbol for the new token
2118     /// @param _transfersEnabled If true, tokens will be able to be transferred
2119     function MiniMeToken(
2120         MiniMeTokenFactory _tokenFactory,
2121         MiniMeToken _parentToken,
2122         uint _parentSnapShotBlock,
2123         string _tokenName,
2124         uint8 _decimalUnits,
2125         string _tokenSymbol,
2126         bool _transfersEnabled
2127     )  public
2128     {
2129         tokenFactory = _tokenFactory;
2130         name = _tokenName;                                 // Set the name
2131         decimals = _decimalUnits;                          // Set the decimals
2132         symbol = _tokenSymbol;                             // Set the symbol
2133         parentToken = _parentToken;
2134         parentSnapShotBlock = _parentSnapShotBlock;
2135         transfersEnabled = _transfersEnabled;
2136         creationBlock = block.number;
2137     }
2138 
2139 
2140 ///////////////////
2141 // ERC20 Methods
2142 ///////////////////
2143 
2144     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
2145     /// @param _to The address of the recipient
2146     /// @param _amount The amount of tokens to be transferred
2147     /// @return Whether the transfer was successful or not
2148     function transfer(address _to, uint256 _amount) public returns (bool success) {
2149         require(transfersEnabled);
2150         return doTransfer(msg.sender, _to, _amount);
2151     }
2152 
2153     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
2154     ///  is approved by `_from`
2155     /// @param _from The address holding the tokens being transferred
2156     /// @param _to The address of the recipient
2157     /// @param _amount The amount of tokens to be transferred
2158     /// @return True if the transfer was successful
2159     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
2160 
2161         // The controller of this contract can move tokens around at will,
2162         //  this is important to recognize! Confirm that you trust the
2163         //  controller of this contract, which in most situations should be
2164         //  another open source smart contract or 0x0
2165         if (msg.sender != controller) {
2166             require(transfersEnabled);
2167 
2168             // The standard ERC 20 transferFrom functionality
2169             if (allowed[_from][msg.sender] < _amount)
2170                 return false;
2171             allowed[_from][msg.sender] -= _amount;
2172         }
2173         return doTransfer(_from, _to, _amount);
2174     }
2175 
2176     /// @dev This is the actual transfer function in the token contract, it can
2177     ///  only be called by other functions in this contract.
2178     /// @param _from The address holding the tokens being transferred
2179     /// @param _to The address of the recipient
2180     /// @param _amount The amount of tokens to be transferred
2181     /// @return True if the transfer was successful
2182     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
2183         if (_amount == 0) {
2184             return true;
2185         }
2186         require(parentSnapShotBlock < block.number);
2187         // Do not allow transfer to 0x0 or the token contract itself
2188         require((_to != 0) && (_to != address(this)));
2189         // If the amount being transfered is more than the balance of the
2190         //  account the transfer returns false
2191         var previousBalanceFrom = balanceOfAt(_from, block.number);
2192         if (previousBalanceFrom < _amount) {
2193             return false;
2194         }
2195         // Alerts the token controller of the transfer
2196         if (isContract(controller)) {
2197             // Adding the ` == true` makes the linter shut up so...
2198             require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
2199         }
2200         // First update the balance array with the new value for the address
2201         //  sending the tokens
2202         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
2203         // Then update the balance array with the new value for the address
2204         //  receiving the tokens
2205         var previousBalanceTo = balanceOfAt(_to, block.number);
2206         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
2207         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
2208         // An event to make the transfer easy to find on the blockchain
2209         Transfer(_from, _to, _amount);
2210         return true;
2211     }
2212 
2213     /// @param _owner The address that's balance is being requested
2214     /// @return The balance of `_owner` at the current block
2215     function balanceOf(address _owner) public constant returns (uint256 balance) {
2216         return balanceOfAt(_owner, block.number);
2217     }
2218 
2219     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
2220     ///  its behalf. This is a modified version of the ERC20 approve function
2221     ///  to be a little bit safer
2222     /// @param _spender The address of the account able to transfer the tokens
2223     /// @param _amount The amount of tokens to be approved for transfer
2224     /// @return True if the approval was successful
2225     function approve(address _spender, uint256 _amount) public returns (bool success) {
2226         require(transfersEnabled);
2227 
2228         // To change the approve amount you first have to reduce the addresses`
2229         //  allowance to zero by calling `approve(_spender,0)` if it is not
2230         //  already 0 to mitigate the race condition described here:
2231         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2232         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
2233 
2234         // Alerts the token controller of the approve function call
2235         if (isContract(controller)) {
2236             // Adding the ` == true` makes the linter shut up so...
2237             require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
2238         }
2239 
2240         allowed[msg.sender][_spender] = _amount;
2241         Approval(msg.sender, _spender, _amount);
2242         return true;
2243     }
2244 
2245     /// @dev This function makes it easy to read the `allowed[]` map
2246     /// @param _owner The address of the account that owns the token
2247     /// @param _spender The address of the account able to transfer the tokens
2248     /// @return Amount of remaining tokens of _owner that _spender is allowed
2249     ///  to spend
2250     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
2251         return allowed[_owner][_spender];
2252     }
2253 
2254     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
2255     ///  its behalf, and then a function is triggered in the contract that is
2256     ///  being approved, `_spender`. This allows users to use their tokens to
2257     ///  interact with contracts in one function call instead of two
2258     /// @param _spender The address of the contract able to transfer the tokens
2259     /// @param _amount The amount of tokens to be approved for transfer
2260     /// @return True if the function call was successful
2261     function approveAndCall(ApproveAndCallFallBack _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
2262         require(approve(_spender, _amount));
2263 
2264         _spender.receiveApproval(
2265             msg.sender,
2266             _amount,
2267             this,
2268             _extraData
2269         );
2270 
2271         return true;
2272     }
2273 
2274     /// @dev This function makes it easy to get the total number of tokens
2275     /// @return The total number of tokens
2276     function totalSupply() public constant returns (uint) {
2277         return totalSupplyAt(block.number);
2278     }
2279 
2280 
2281 ////////////////
2282 // Query balance and totalSupply in History
2283 ////////////////
2284 
2285     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
2286     /// @param _owner The address from which the balance will be retrieved
2287     /// @param _blockNumber The block number when the balance is queried
2288     /// @return The balance at `_blockNumber`
2289     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
2290 
2291         // These next few lines are used when the balance of the token is
2292         //  requested before a check point was ever created for this token, it
2293         //  requires that the `parentToken.balanceOfAt` be queried at the
2294         //  genesis block for that token as this contains initial balance of
2295         //  this token
2296         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
2297             if (address(parentToken) != 0) {
2298                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
2299             } else {
2300                 // Has no parent
2301                 return 0;
2302             }
2303 
2304         // This will return the expected balance during normal situations
2305         } else {
2306             return getValueAt(balances[_owner], _blockNumber);
2307         }
2308     }
2309 
2310     /// @notice Total amount of tokens at a specific `_blockNumber`.
2311     /// @param _blockNumber The block number when the totalSupply is queried
2312     /// @return The total amount of tokens at `_blockNumber`
2313     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
2314 
2315         // These next few lines are used when the totalSupply of the token is
2316         //  requested before a check point was ever created for this token, it
2317         //  requires that the `parentToken.totalSupplyAt` be queried at the
2318         //  genesis block for this token as that contains totalSupply of this
2319         //  token at this block number.
2320         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
2321             if (address(parentToken) != 0) {
2322                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
2323             } else {
2324                 return 0;
2325             }
2326 
2327         // This will return the expected totalSupply during normal situations
2328         } else {
2329             return getValueAt(totalSupplyHistory, _blockNumber);
2330         }
2331     }
2332 
2333 ////////////////
2334 // Clone Token Method
2335 ////////////////
2336 
2337     /// @notice Creates a new clone token with the initial distribution being
2338     ///  this token at `_snapshotBlock`
2339     /// @param _cloneTokenName Name of the clone token
2340     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
2341     /// @param _cloneTokenSymbol Symbol of the clone token
2342     /// @param _snapshotBlock Block when the distribution of the parent token is
2343     ///  copied to set the initial distribution of the new clone token;
2344     ///  if the block is zero than the actual block, the current block is used
2345     /// @param _transfersEnabled True if transfers are allowed in the clone
2346     /// @return The address of the new MiniMeToken Contract
2347     function createCloneToken(
2348         string _cloneTokenName,
2349         uint8 _cloneDecimalUnits,
2350         string _cloneTokenSymbol,
2351         uint _snapshotBlock,
2352         bool _transfersEnabled
2353     ) public returns(MiniMeToken)
2354     {
2355         uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
2356 
2357         MiniMeToken cloneToken = tokenFactory.createCloneToken(
2358             this,
2359             snapshot,
2360             _cloneTokenName,
2361             _cloneDecimalUnits,
2362             _cloneTokenSymbol,
2363             _transfersEnabled
2364         );
2365 
2366         cloneToken.changeController(msg.sender);
2367 
2368         // An event to make the token easy to find on the blockchain
2369         NewCloneToken(address(cloneToken), snapshot);
2370         return cloneToken;
2371     }
2372 
2373 ////////////////
2374 // Generate and destroy tokens
2375 ////////////////
2376 
2377     /// @notice Generates `_amount` tokens that are assigned to `_owner`
2378     /// @param _owner The address that will be assigned the new tokens
2379     /// @param _amount The quantity of tokens generated
2380     /// @return True if the tokens are generated correctly
2381     function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
2382         uint curTotalSupply = totalSupply();
2383         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
2384         uint previousBalanceTo = balanceOf(_owner);
2385         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
2386         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
2387         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
2388         Transfer(0, _owner, _amount);
2389         return true;
2390     }
2391 
2392 
2393     /// @notice Burns `_amount` tokens from `_owner`
2394     /// @param _owner The address that will lose the tokens
2395     /// @param _amount The quantity of tokens to burn
2396     /// @return True if the tokens are burned correctly
2397     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
2398         uint curTotalSupply = totalSupply();
2399         require(curTotalSupply >= _amount);
2400         uint previousBalanceFrom = balanceOf(_owner);
2401         require(previousBalanceFrom >= _amount);
2402         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
2403         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
2404         Transfer(_owner, 0, _amount);
2405         return true;
2406     }
2407 
2408 ////////////////
2409 // Enable tokens transfers
2410 ////////////////
2411 
2412 
2413     /// @notice Enables token holders to transfer their tokens freely if true
2414     /// @param _transfersEnabled True if transfers are allowed in the clone
2415     function enableTransfers(bool _transfersEnabled) onlyController public {
2416         transfersEnabled = _transfersEnabled;
2417     }
2418 
2419 ////////////////
2420 // Internal helper functions to query and set a value in a snapshot array
2421 ////////////////
2422 
2423     /// @dev `getValueAt` retrieves the number of tokens at a given block number
2424     /// @param checkpoints The history of values being queried
2425     /// @param _block The block number to retrieve the value at
2426     /// @return The number of tokens being queried
2427     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
2428         if (checkpoints.length == 0)
2429             return 0;
2430 
2431         // Shortcut for the actual value
2432         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
2433             return checkpoints[checkpoints.length-1].value;
2434         if (_block < checkpoints[0].fromBlock)
2435             return 0;
2436 
2437         // Binary search of the value in the array
2438         uint min = 0;
2439         uint max = checkpoints.length-1;
2440         while (max > min) {
2441             uint mid = (max + min + 1) / 2;
2442             if (checkpoints[mid].fromBlock<=_block) {
2443                 min = mid;
2444             } else {
2445                 max = mid-1;
2446             }
2447         }
2448         return checkpoints[min].value;
2449     }
2450 
2451     /// @dev `updateValueAtNow` used to update the `balances` map and the
2452     ///  `totalSupplyHistory`
2453     /// @param checkpoints The history of data being updated
2454     /// @param _value The new number of tokens
2455     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
2456         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
2457             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
2458             newCheckPoint.fromBlock = uint128(block.number);
2459             newCheckPoint.value = uint128(_value);
2460         } else {
2461             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
2462             oldCheckPoint.value = uint128(_value);
2463         }
2464     }
2465 
2466     /// @dev Internal function to determine if an address is a contract
2467     /// @param _addr The address being queried
2468     /// @return True if `_addr` is a contract
2469     function isContract(address _addr) constant internal returns(bool) {
2470         uint size;
2471         if (_addr == 0)
2472             return false;
2473 
2474         assembly {
2475             size := extcodesize(_addr)
2476         }
2477 
2478         return size>0;
2479     }
2480 
2481     /// @dev Helper function to return a min betwen the two uints
2482     function min(uint a, uint b) pure internal returns (uint) {
2483         return a < b ? a : b;
2484     }
2485 
2486     /// @notice The fallback function: If the contract's controller has not been
2487     ///  set to 0, then the `proxyPayment` method is called which relays the
2488     ///  ether and creates tokens as described in the token controller contract
2489     function () external payable {
2490         require(isContract(controller));
2491         // Adding the ` == true` makes the linter shut up so...
2492         require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
2493     }
2494 
2495 //////////
2496 // Safety Methods
2497 //////////
2498 
2499     /// @notice This method can be used by the controller to extract mistakenly
2500     ///  sent tokens to this contract.
2501     /// @param _token The address of the token contract that you want to recover
2502     ///  set to 0 in case you want to extract ether.
2503     function claimTokens(address _token) onlyController public {
2504         if (_token == 0x0) {
2505             controller.transfer(this.balance);
2506             return;
2507         }
2508 
2509         MiniMeToken token = MiniMeToken(_token);
2510         uint balance = token.balanceOf(this);
2511         token.transfer(controller, balance);
2512         ClaimedTokens(_token, controller, balance);
2513     }
2514 
2515 ////////////////
2516 // Events
2517 ////////////////
2518     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
2519     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
2520     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
2521     event Approval(
2522         address indexed _owner,
2523         address indexed _spender,
2524         uint256 _amount
2525         );
2526 
2527 }
2528 
2529 
2530 ////////////////
2531 // MiniMeTokenFactory
2532 ////////////////
2533 
2534 /// @dev This contract is used to generate clone contracts from a contract.
2535 ///  In solidity this is the way to create a contract from a contract of the
2536 ///  same class
2537 contract MiniMeTokenFactory {
2538 
2539     /// @notice Update the DApp by creating a new token with new functionalities
2540     ///  the msg.sender becomes the controller of this clone token
2541     /// @param _parentToken Address of the token being cloned
2542     /// @param _snapshotBlock Block of the parent token that will
2543     ///  determine the initial distribution of the clone token
2544     /// @param _tokenName Name of the new token
2545     /// @param _decimalUnits Number of decimals of the new token
2546     /// @param _tokenSymbol Token Symbol for the new token
2547     /// @param _transfersEnabled If true, tokens will be able to be transferred
2548     /// @return The address of the new token contract
2549     function createCloneToken(
2550         MiniMeToken _parentToken,
2551         uint _snapshotBlock,
2552         string _tokenName,
2553         uint8 _decimalUnits,
2554         string _tokenSymbol,
2555         bool _transfersEnabled
2556     ) public returns (MiniMeToken)
2557     {
2558         MiniMeToken newToken = new MiniMeToken(
2559             this,
2560             _parentToken,
2561             _snapshotBlock,
2562             _tokenName,
2563             _decimalUnits,
2564             _tokenSymbol,
2565             _transfersEnabled
2566         );
2567 
2568         newToken.changeController(msg.sender);
2569         return newToken;
2570     }
2571 }
2572 // File: @aragon/id/contracts/ens/IPublicResolver.sol
2573 interface IPublicResolver {
2574     function supportsInterface(bytes4 interfaceID) constant returns (bool);
2575     function addr(bytes32 node) constant returns (address ret);
2576     function setAddr(bytes32 node, address addr);
2577     function hash(bytes32 node) constant returns (bytes32 ret);
2578     function setHash(bytes32 node, bytes32 hash);
2579 }
2580 // File: @aragon/id/contracts/IFIFSResolvingRegistrar.sol
2581 interface IFIFSResolvingRegistrar {
2582     function register(bytes32 _subnode, address _owner) external;
2583     function registerWithResolver(bytes32 _subnode, address _owner, IPublicResolver _resolver) public;
2584 }
2585 // File: @aragon/os/contracts/common/IForwarder.sol
2586 /*
2587  * SPDX-License-Identitifer:    MIT
2588  */
2589 
2590 pragma solidity ^0.4.24;
2591 
2592 
2593 interface IForwarder {
2594     function isForwarder() external pure returns (bool);
2595 
2596     // TODO: this should be external
2597     // See https://github.com/ethereum/solidity/issues/4832
2598     function canForward(address sender, bytes evmCallScript) public view returns (bool);
2599 
2600     // TODO: this should be external
2601     // See https://github.com/ethereum/solidity/issues/4832
2602     function forward(bytes evmCallScript) public;
2603 }
2604 // File: @aragon/os/contracts/lib/math/SafeMath.sol
2605 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d51e38758e1d985661534534d5c61e27bece5042/contracts/math/SafeMath.sol
2606 // Adapted to use pragma ^0.4.24 and satisfy our linter rules
2607 
2608 pragma solidity ^0.4.24;
2609 
2610 
2611 /**
2612  * @title SafeMath
2613  * @dev Math operations with safety checks that revert on error
2614  */
2615 library SafeMath {
2616     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
2617     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
2618     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
2619     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
2620 
2621     /**
2622     * @dev Multiplies two numbers, reverts on overflow.
2623     */
2624     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
2625         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2626         // benefit is lost if 'b' is also tested.
2627         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
2628         if (_a == 0) {
2629             return 0;
2630         }
2631 
2632         uint256 c = _a * _b;
2633         require(c / _a == _b, ERROR_MUL_OVERFLOW);
2634 
2635         return c;
2636     }
2637 
2638     /**
2639     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
2640     */
2641     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
2642         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
2643         uint256 c = _a / _b;
2644         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
2645 
2646         return c;
2647     }
2648 
2649     /**
2650     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
2651     */
2652     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
2653         require(_b <= _a, ERROR_SUB_UNDERFLOW);
2654         uint256 c = _a - _b;
2655 
2656         return c;
2657     }
2658 
2659     /**
2660     * @dev Adds two numbers, reverts on overflow.
2661     */
2662     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
2663         uint256 c = _a + _b;
2664         require(c >= _a, ERROR_ADD_OVERFLOW);
2665 
2666         return c;
2667     }
2668 
2669     /**
2670     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
2671     * reverts when dividing by zero.
2672     */
2673     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2674         require(b != 0, ERROR_DIV_ZERO);
2675         return a % b;
2676     }
2677 }
2678 // File: @aragon/os/contracts/lib/math/SafeMath64.sol
2679 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d51e38758e1d985661534534d5c61e27bece5042/contracts/math/SafeMath.sol
2680 // Adapted for uint64, pragma ^0.4.24, and satisfying our linter rules
2681 // Also optimized the mul() implementation, see https://github.com/aragon/aragonOS/pull/417
2682 
2683 pragma solidity ^0.4.24;
2684 
2685 
2686 /**
2687  * @title SafeMath64
2688  * @dev Math operations for uint64 with safety checks that revert on error
2689  */
2690 library SafeMath64 {
2691     string private constant ERROR_ADD_OVERFLOW = "MATH64_ADD_OVERFLOW";
2692     string private constant ERROR_SUB_UNDERFLOW = "MATH64_SUB_UNDERFLOW";
2693     string private constant ERROR_MUL_OVERFLOW = "MATH64_MUL_OVERFLOW";
2694     string private constant ERROR_DIV_ZERO = "MATH64_DIV_ZERO";
2695 
2696     /**
2697     * @dev Multiplies two numbers, reverts on overflow.
2698     */
2699     function mul(uint64 _a, uint64 _b) internal pure returns (uint64) {
2700         uint256 c = uint256(_a) * uint256(_b);
2701         require(c < 0x010000000000000000, ERROR_MUL_OVERFLOW); // 2**64 (less gas this way)
2702 
2703         return uint64(c);
2704     }
2705 
2706     /**
2707     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
2708     */
2709     function div(uint64 _a, uint64 _b) internal pure returns (uint64) {
2710         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
2711         uint64 c = _a / _b;
2712         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
2713 
2714         return c;
2715     }
2716 
2717     /**
2718     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
2719     */
2720     function sub(uint64 _a, uint64 _b) internal pure returns (uint64) {
2721         require(_b <= _a, ERROR_SUB_UNDERFLOW);
2722         uint64 c = _a - _b;
2723 
2724         return c;
2725     }
2726 
2727     /**
2728     * @dev Adds two numbers, reverts on overflow.
2729     */
2730     function add(uint64 _a, uint64 _b) internal pure returns (uint64) {
2731         uint64 c = _a + _b;
2732         require(c >= _a, ERROR_ADD_OVERFLOW);
2733 
2734         return c;
2735     }
2736 
2737     /**
2738     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
2739     * reverts when dividing by zero.
2740     */
2741     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
2742         require(b != 0, ERROR_DIV_ZERO);
2743         return a % b;
2744     }
2745 }
2746 // File: @aragon/apps-voting/contracts/Voting.sol
2747 /*
2748  * SPDX-License-Identitifer:    GPL-3.0-or-later
2749  */
2750 
2751 pragma solidity 0.4.24;
2752 
2753 
2754 
2755 
2756 
2757 
2758 
2759 contract Voting is IForwarder, AragonApp {
2760     using SafeMath for uint256;
2761     using SafeMath64 for uint64;
2762 
2763     bytes32 public constant CREATE_VOTES_ROLE = keccak256("CREATE_VOTES_ROLE");
2764     bytes32 public constant MODIFY_SUPPORT_ROLE = keccak256("MODIFY_SUPPORT_ROLE");
2765     bytes32 public constant MODIFY_QUORUM_ROLE = keccak256("MODIFY_QUORUM_ROLE");
2766 
2767     uint64 public constant PCT_BASE = 10 ** 18; // 0% = 0; 1% = 10^16; 100% = 10^18
2768 
2769     string private constant ERROR_NO_VOTE = "VOTING_NO_VOTE";
2770     string private constant ERROR_INIT_PCTS = "VOTING_INIT_PCTS";
2771     string private constant ERROR_CHANGE_SUPPORT_PCTS = "VOTING_CHANGE_SUPPORT_PCTS";
2772     string private constant ERROR_CHANGE_QUORUM_PCTS = "VOTING_CHANGE_QUORUM_PCTS";
2773     string private constant ERROR_INIT_SUPPORT_TOO_BIG = "VOTING_INIT_SUPPORT_TOO_BIG";
2774     string private constant ERROR_CHANGE_SUPPORT_TOO_BIG = "VOTING_CHANGE_SUPP_TOO_BIG";
2775     string private constant ERROR_CAN_NOT_VOTE = "VOTING_CAN_NOT_VOTE";
2776     string private constant ERROR_CAN_NOT_EXECUTE = "VOTING_CAN_NOT_EXECUTE";
2777     string private constant ERROR_CAN_NOT_FORWARD = "VOTING_CAN_NOT_FORWARD";
2778     string private constant ERROR_NO_VOTING_POWER = "VOTING_NO_VOTING_POWER";
2779 
2780     enum VoterState { Absent, Yea, Nay }
2781 
2782     struct Vote {
2783         bool executed;
2784         uint64 startDate;
2785         uint64 snapshotBlock;
2786         uint64 supportRequiredPct;
2787         uint64 minAcceptQuorumPct;
2788         uint256 yea;
2789         uint256 nay;
2790         uint256 votingPower;
2791         bytes executionScript;
2792         mapping (address => VoterState) voters;
2793     }
2794 
2795     MiniMeToken public token;
2796     uint64 public supportRequiredPct;
2797     uint64 public minAcceptQuorumPct;
2798     uint64 public voteTime;
2799 
2800     // We are mimicing an array, we use a mapping instead to make app upgrade more graceful
2801     mapping (uint256 => Vote) internal votes;
2802     uint256 public votesLength;
2803 
2804     event StartVote(uint256 indexed voteId, address indexed creator, string metadata);
2805     event CastVote(uint256 indexed voteId, address indexed voter, bool supports, uint256 stake);
2806     event ExecuteVote(uint256 indexed voteId);
2807     event ChangeSupportRequired(uint64 supportRequiredPct);
2808     event ChangeMinQuorum(uint64 minAcceptQuorumPct);
2809 
2810     modifier voteExists(uint256 _voteId) {
2811         require(_voteId < votesLength, ERROR_NO_VOTE);
2812         _;
2813     }
2814 
2815     /**
2816     * @notice Initialize Voting app with `_token.symbol(): string` for governance, minimum support of `@formatPct(_supportRequiredPct)`%, minimum acceptance quorum of `@formatPct(_minAcceptQuorumPct)`%, and a voting duration of `@transformTime(_voteTime)`
2817     * @param _token MiniMeToken Address that will be used as governance token
2818     * @param _supportRequiredPct Percentage of yeas in casted votes for a vote to succeed (expressed as a percentage of 10^18; eg. 10^16 = 1%, 10^18 = 100%)
2819     * @param _minAcceptQuorumPct Percentage of yeas in total possible votes for a vote to succeed (expressed as a percentage of 10^18; eg. 10^16 = 1%, 10^18 = 100%)
2820     * @param _voteTime Seconds that a vote will be open for token holders to vote (unless enough yeas or nays have been cast to make an early decision)
2821     */
2822     function initialize(
2823         MiniMeToken _token,
2824         uint64 _supportRequiredPct,
2825         uint64 _minAcceptQuorumPct,
2826         uint64 _voteTime
2827     )
2828         external
2829         onlyInit
2830     {
2831         initialized();
2832 
2833         require(_minAcceptQuorumPct <= _supportRequiredPct, ERROR_INIT_PCTS);
2834         require(_supportRequiredPct < PCT_BASE, ERROR_INIT_SUPPORT_TOO_BIG);
2835 
2836         token = _token;
2837         supportRequiredPct = _supportRequiredPct;
2838         minAcceptQuorumPct = _minAcceptQuorumPct;
2839         voteTime = _voteTime;
2840     }
2841 
2842     /**
2843     * @notice Change required support to `@formatPct(_supportRequiredPct)`%
2844     * @param _supportRequiredPct New required support
2845     */
2846     function changeSupportRequiredPct(uint64 _supportRequiredPct)
2847         external
2848         authP(MODIFY_SUPPORT_ROLE, arr(uint256(_supportRequiredPct), uint256(supportRequiredPct)))
2849     {
2850         require(minAcceptQuorumPct <= _supportRequiredPct, ERROR_CHANGE_SUPPORT_PCTS);
2851         require(_supportRequiredPct < PCT_BASE, ERROR_CHANGE_SUPPORT_TOO_BIG);
2852         supportRequiredPct = _supportRequiredPct;
2853 
2854         emit ChangeSupportRequired(_supportRequiredPct);
2855     }
2856 
2857     /**
2858     * @notice Change minimum acceptance quorum to `@formatPct(_minAcceptQuorumPct)`%
2859     * @param _minAcceptQuorumPct New acceptance quorum
2860     */
2861     function changeMinAcceptQuorumPct(uint64 _minAcceptQuorumPct)
2862         external
2863         authP(MODIFY_QUORUM_ROLE, arr(uint256(_minAcceptQuorumPct), uint256(minAcceptQuorumPct)))
2864     {
2865         require(_minAcceptQuorumPct <= supportRequiredPct, ERROR_CHANGE_QUORUM_PCTS);
2866         minAcceptQuorumPct = _minAcceptQuorumPct;
2867 
2868         emit ChangeMinQuorum(_minAcceptQuorumPct);
2869     }
2870 
2871     /**
2872     * @notice Create a new vote about "`_metadata`"
2873     * @param _executionScript EVM script to be executed on approval
2874     * @param _metadata Vote metadata
2875     * @return voteId Id for newly created vote
2876     */
2877     function newVote(bytes _executionScript, string _metadata) external auth(CREATE_VOTES_ROLE) returns (uint256 voteId) {
2878         return _newVote(_executionScript, _metadata, true, true);
2879     }
2880 
2881     /**
2882     * @notice Create a new vote about "`_metadata`"
2883     * @param _executionScript EVM script to be executed on approval
2884     * @param _metadata Vote metadata
2885     * @param _castVote Whether to also cast newly created vote
2886     * @param _executesIfDecided Whether to also immediately execute newly created vote if decided
2887     * @return voteId id for newly created vote
2888     */
2889     function newVote(bytes _executionScript, string _metadata, bool _castVote, bool _executesIfDecided)
2890         external
2891         auth(CREATE_VOTES_ROLE)
2892         returns (uint256 voteId)
2893     {
2894         return _newVote(_executionScript, _metadata, _castVote, _executesIfDecided);
2895     }
2896 
2897     /**
2898     * @notice Vote `_supports ? 'yea' : 'nay'` in vote #`_voteId`
2899     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
2900     *      created via `newVote(),` which requires initialization
2901     * @param _voteId Id for vote
2902     * @param _supports Whether voter supports the vote
2903     * @param _executesIfDecided Whether the vote should execute its action if it becomes decided
2904     */
2905     function vote(uint256 _voteId, bool _supports, bool _executesIfDecided) external voteExists(_voteId) {
2906         require(canVote(_voteId, msg.sender), ERROR_CAN_NOT_VOTE);
2907         _vote(_voteId, _supports, msg.sender, _executesIfDecided);
2908     }
2909 
2910     /**
2911     * @notice Execute vote #`_voteId`
2912     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
2913     *      created via `newVote(),` which requires initialization
2914     * @param _voteId Id for vote
2915     */
2916     function executeVote(uint256 _voteId) external voteExists(_voteId) {
2917         require(canExecute(_voteId), ERROR_CAN_NOT_EXECUTE);
2918         _executeVote(_voteId);
2919     }
2920 
2921     function isForwarder() public pure returns (bool) {
2922         return true;
2923     }
2924 
2925     /**
2926     * @notice Creates a vote to execute the desired action, and casts a support vote if possible
2927     * @dev IForwarder interface conformance
2928     * @param _evmScript Start vote with script
2929     */
2930     function forward(bytes _evmScript) public {
2931         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
2932         _newVote(_evmScript, "", true, true);
2933     }
2934 
2935     function canForward(address _sender, bytes) public view returns (bool) {
2936         // Note that `canPerform()` implicitly does an initialization check itself
2937         return canPerform(_sender, CREATE_VOTES_ROLE, arr());
2938     }
2939 
2940     function canVote(uint256 _voteId, address _voter) public view voteExists(_voteId) returns (bool) {
2941         Vote storage vote_ = votes[_voteId];
2942 
2943         return _isVoteOpen(vote_) && token.balanceOfAt(_voter, vote_.snapshotBlock) > 0;
2944     }
2945 
2946     function canExecute(uint256 _voteId) public view voteExists(_voteId) returns (bool) {
2947         Vote storage vote_ = votes[_voteId];
2948 
2949         if (vote_.executed) {
2950             return false;
2951         }
2952 
2953         // Voting is already decided
2954         if (_isValuePct(vote_.yea, vote_.votingPower, vote_.supportRequiredPct)) {
2955             return true;
2956         }
2957 
2958         uint256 totalVotes = vote_.yea.add(vote_.nay);
2959 
2960         // Vote ended?
2961         if (_isVoteOpen(vote_)) {
2962             return false;
2963         }
2964         // Has enough support?
2965         if (!_isValuePct(vote_.yea, totalVotes, vote_.supportRequiredPct)) {
2966             return false;
2967         }
2968         // Has min quorum?
2969         if (!_isValuePct(vote_.yea, vote_.votingPower, vote_.minAcceptQuorumPct)) {
2970             return false;
2971         }
2972 
2973         return true;
2974     }
2975 
2976     function getVote(uint256 _voteId)
2977         public
2978         view
2979         voteExists(_voteId)
2980         returns (
2981             bool open,
2982             bool executed,
2983             uint64 startDate,
2984             uint64 snapshotBlock,
2985             uint64 supportRequired,
2986             uint64 minAcceptQuorum,
2987             uint256 yea,
2988             uint256 nay,
2989             uint256 votingPower,
2990             bytes script
2991         )
2992     {
2993         Vote storage vote_ = votes[_voteId];
2994 
2995         open = _isVoteOpen(vote_);
2996         executed = vote_.executed;
2997         startDate = vote_.startDate;
2998         snapshotBlock = vote_.snapshotBlock;
2999         supportRequired = vote_.supportRequiredPct;
3000         minAcceptQuorum = vote_.minAcceptQuorumPct;
3001         yea = vote_.yea;
3002         nay = vote_.nay;
3003         votingPower = vote_.votingPower;
3004         script = vote_.executionScript;
3005     }
3006 
3007     function getVoterState(uint256 _voteId, address _voter) public view voteExists(_voteId) returns (VoterState) {
3008         return votes[_voteId].voters[_voter];
3009     }
3010 
3011     function _newVote(bytes _executionScript, string _metadata, bool _castVote, bool _executesIfDecided)
3012         internal
3013         returns (uint256 voteId)
3014     {
3015         uint256 votingPower = token.totalSupplyAt(vote_.snapshotBlock);
3016         require(votingPower > 0, ERROR_NO_VOTING_POWER);
3017 
3018         voteId = votesLength++;
3019         Vote storage vote_ = votes[voteId];
3020         vote_.startDate = getTimestamp64();
3021         vote_.snapshotBlock = getBlockNumber64() - 1; // avoid double voting in this very block
3022         vote_.supportRequiredPct = supportRequiredPct;
3023         vote_.minAcceptQuorumPct = minAcceptQuorumPct;
3024         vote_.votingPower = votingPower;
3025         vote_.executionScript = _executionScript;
3026 
3027         emit StartVote(voteId, msg.sender, _metadata);
3028 
3029         if (_castVote && canVote(voteId, msg.sender)) {
3030             _vote(voteId, true, msg.sender, _executesIfDecided);
3031         }
3032     }
3033 
3034     function _vote(
3035         uint256 _voteId,
3036         bool _supports,
3037         address _voter,
3038         bool _executesIfDecided
3039     ) internal
3040     {
3041         Vote storage vote_ = votes[_voteId];
3042 
3043         // This could re-enter, though we can assume the governance token is not malicious
3044         uint256 voterStake = token.balanceOfAt(_voter, vote_.snapshotBlock);
3045         VoterState state = vote_.voters[_voter];
3046 
3047         // If voter had previously voted, decrease count
3048         if (state == VoterState.Yea) {
3049             vote_.yea = vote_.yea.sub(voterStake);
3050         } else if (state == VoterState.Nay) {
3051             vote_.nay = vote_.nay.sub(voterStake);
3052         }
3053 
3054         if (_supports) {
3055             vote_.yea = vote_.yea.add(voterStake);
3056         } else {
3057             vote_.nay = vote_.nay.add(voterStake);
3058         }
3059 
3060         vote_.voters[_voter] = _supports ? VoterState.Yea : VoterState.Nay;
3061 
3062         emit CastVote(_voteId, _voter, _supports, voterStake);
3063 
3064         if (_executesIfDecided && canExecute(_voteId)) {
3065             _executeVote(_voteId);
3066         }
3067     }
3068 
3069     function _executeVote(uint256 _voteId) internal {
3070         Vote storage vote_ = votes[_voteId];
3071 
3072         vote_.executed = true;
3073 
3074         bytes memory input = new bytes(0); // TODO: Consider input for voting scripts
3075         runScript(vote_.executionScript, input, new address[](0));
3076 
3077         emit ExecuteVote(_voteId);
3078     }
3079 
3080     function _isVoteOpen(Vote storage vote_) internal view returns (bool) {
3081         return getTimestamp64() < vote_.startDate.add(voteTime) && !vote_.executed;
3082     }
3083 
3084     /**
3085     * @dev Calculates whether `_value` is more than a percentage `_pct` of `_total`
3086     */
3087     function _isValuePct(uint256 _value, uint256 _total, uint256 _pct) internal pure returns (bool) {
3088         if (_total == 0) {
3089             return false;
3090         }
3091 
3092         uint256 computedPct = _value.mul(PCT_BASE) / _total;
3093         return computedPct > _pct;
3094     }
3095 }
3096 // File: @aragon/apps-vault/contracts/Vault.sol
3097 contract Vault is EtherTokenConstant, AragonApp, DepositableStorage {
3098     bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
3099 
3100     string private constant ERROR_DATA_NON_ZERO = "VAULT_DATA_NON_ZERO";
3101     string private constant ERROR_NOT_DEPOSITABLE = "VAULT_NOT_DEPOSITABLE";
3102     string private constant ERROR_DEPOSIT_VALUE_ZERO = "VAULT_DEPOSIT_VALUE_ZERO";
3103     string private constant ERROR_TRANSFER_VALUE_ZERO = "VAULT_TRANSFER_VALUE_ZERO";
3104     string private constant ERROR_SEND_REVERTED = "VAULT_SEND_REVERTED";
3105     string private constant ERROR_VALUE_MISMATCH = "VAULT_VALUE_MISMATCH";
3106     string private constant ERROR_TOKEN_TRANSFER_FROM_REVERTED = "VAULT_TOKEN_TRANSFER_FROM_REVERT";
3107     string private constant ERROR_TOKEN_TRANSFER_REVERTED = "VAULT_TOKEN_TRANSFER_REVERTED";
3108 
3109     event Transfer(address indexed token, address indexed to, uint256 amount);
3110     event Deposit(address indexed token, address indexed sender, uint256 amount);
3111 
3112     /**
3113     * @dev On a normal send() or transfer() this fallback is never executed as it will be
3114     *      intercepted by the Proxy (see aragonOS#281)
3115     */
3116     function () external payable isInitialized {
3117         require(msg.data.length == 0, ERROR_DATA_NON_ZERO);
3118         _deposit(ETH, msg.value);
3119     }
3120 
3121     /**
3122     * @notice Initialize Vault app
3123     * @dev As an AragonApp it needs to be initialized in order for roles (`auth` and `authP`) to work
3124     */
3125     function initialize() external onlyInit {
3126         initialized();
3127         setDepositable(true);
3128     }
3129 
3130     /**
3131     * @notice Deposit `_value` `_token` to the vault
3132     * @param _token Address of the token being transferred
3133     * @param _value Amount of tokens being transferred
3134     */
3135     function deposit(address _token, uint256 _value) external payable isInitialized {
3136         _deposit(_token, _value);
3137     }
3138 
3139     /**
3140     * @notice Transfer `_value` `_token` from the Vault to `_to`
3141     * @param _token Address of the token being transferred
3142     * @param _to Address of the recipient of tokens
3143     * @param _value Amount of tokens being transferred
3144     */
3145     /* solium-disable-next-line function-order */
3146     function transfer(address _token, address _to, uint256 _value)
3147         external
3148         authP(TRANSFER_ROLE, arr(_token, _to, _value))
3149     {
3150         require(_value > 0, ERROR_TRANSFER_VALUE_ZERO);
3151 
3152         if (_token == ETH) {
3153             require(_to.send(_value), ERROR_SEND_REVERTED);
3154         } else {
3155             require(ERC20(_token).transfer(_to, _value), ERROR_TOKEN_TRANSFER_REVERTED);
3156         }
3157 
3158         emit Transfer(_token, _to, _value);
3159     }
3160 
3161     function balance(address _token) public view returns (uint256) {
3162         if (_token == ETH) {
3163             return address(this).balance;
3164         } else {
3165             return ERC20(_token).balanceOf(this);
3166         }
3167     }
3168 
3169     /**
3170     * @dev Disable recovery escape hatch, as it could be used
3171     *      maliciously to transfer funds away from the vault
3172     */
3173     function allowRecoverability(address) public view returns (bool) {
3174         return false;
3175     }
3176 
3177     function _deposit(address _token, uint256 _value) internal {
3178         require(isDepositable(), ERROR_NOT_DEPOSITABLE);
3179         require(_value > 0, ERROR_DEPOSIT_VALUE_ZERO);
3180 
3181         if (_token == ETH) {
3182             // Deposit is implicit in this case
3183             require(msg.value == _value, ERROR_VALUE_MISMATCH);
3184         } else {
3185             require(ERC20(_token).transferFrom(msg.sender, this, _value), ERROR_TOKEN_TRANSFER_FROM_REVERTED);
3186         }
3187 
3188         emit Deposit(_token, msg.sender, _value);
3189     }
3190 }
3191 // File: @aragon/apps-token-manager/contracts/TokenManager.sol
3192 /*
3193  * SPDX-License-Identitifer:    GPL-3.0-or-later
3194  */
3195 
3196 /* solium-disable function-order */
3197 
3198 pragma solidity 0.4.24;
3199 
3200 
3201 
3202 
3203 
3204 
3205 
3206 
3207 
3208 contract TokenManager is ITokenController, IForwarder, AragonApp {
3209     using SafeMath for uint256;
3210     using Uint256Helpers for uint256;
3211 
3212     bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
3213     bytes32 public constant ISSUE_ROLE = keccak256("ISSUE_ROLE");
3214     bytes32 public constant ASSIGN_ROLE = keccak256("ASSIGN_ROLE");
3215     bytes32 public constant REVOKE_VESTINGS_ROLE = keccak256("REVOKE_VESTINGS_ROLE");
3216     bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");
3217 
3218     uint256 public constant MAX_VESTINGS_PER_ADDRESS = 50;
3219 
3220     string private constant ERROR_NO_VESTING = "TM_NO_VESTING";
3221     string private constant ERROR_TOKEN_CONTROLLER = "TM_TOKEN_CONTROLLER";
3222     string private constant ERROR_MINT_BALANCE_INCREASE_NOT_ALLOWED = "TM_MINT_BAL_INC_NOT_ALLOWED";
3223     string private constant ERROR_ASSIGN_BALANCE_INCREASE_NOT_ALLOWED = "TM_ASSIGN_BAL_INC_NOT_ALLOWED";
3224     string private constant ERROR_TOO_MANY_VESTINGS = "TM_TOO_MANY_VESTINGS";
3225     string private constant ERROR_WRONG_CLIFF_DATE = "TM_WRONG_CLIFF_DATE";
3226     string private constant ERROR_VESTING_NOT_REVOKABLE = "TM_VESTING_NOT_REVOKABLE";
3227     string private constant ERROR_REVOKE_TRANSFER_FROM_REVERTED = "TM_REVOKE_TRANSFER_FROM_REVERTED";
3228     string private constant ERROR_ASSIGN_TRANSFER_FROM_REVERTED = "TM_ASSIGN_TRANSFER_FROM_REVERTED";
3229     string private constant ERROR_CAN_NOT_FORWARD = "TM_CAN_NOT_FORWARD";
3230     string private constant ERROR_ON_TRANSFER_WRONG_SENDER = "TM_TRANSFER_WRONG_SENDER";
3231     string private constant ERROR_PROXY_PAYMENT_WRONG_SENDER = "TM_PROXY_PAYMENT_WRONG_SENDER";
3232 
3233     struct TokenVesting {
3234         uint256 amount;
3235         uint64 start;
3236         uint64 cliff;
3237         uint64 vesting;
3238         bool revokable;
3239     }
3240 
3241     MiniMeToken public token;
3242     uint256 public maxAccountTokens;
3243 
3244     // We are mimicing an array in the inner mapping, we use a mapping instead to make app upgrade more graceful
3245     mapping (address => mapping (uint256 => TokenVesting)) internal vestings;
3246     mapping (address => uint256) public vestingsLengths;
3247     mapping (address => bool) public everHeld;
3248 
3249     // Other token specific events can be watched on the token address directly (avoids duplication)
3250     event NewVesting(address indexed receiver, uint256 vestingId, uint256 amount);
3251     event RevokeVesting(address indexed receiver, uint256 vestingId, uint256 nonVestedAmount);
3252 
3253     modifier vestingExists(address _holder, uint256 _vestingId) {
3254         // TODO: it's not checking for gaps that may appear because of deletes in revokeVesting function
3255         require(_vestingId < vestingsLengths[_holder], ERROR_NO_VESTING);
3256         _;
3257     }
3258 
3259     /**
3260     * @notice Initialize Token Manager for `_token.symbol(): string`, whose tokens are `transferable ? 'not' : ''` transferable`_maxAccountTokens > 0 ? ' and limited to a maximum of ' + @tokenAmount(_token, _maxAccountTokens, false) + ' per account' : ''`
3261     * @param _token MiniMeToken address for the managed token (Token Manager instance must be already set as the token controller)
3262     * @param _transferable whether the token can be transferred by holders
3263     * @param _maxAccountTokens Maximum amount of tokens an account can have (0 for infinite tokens)
3264     */
3265     function initialize(
3266         MiniMeToken _token,
3267         bool _transferable,
3268         uint256 _maxAccountTokens
3269     )
3270         external
3271         onlyInit
3272     {
3273         initialized();
3274 
3275         require(_token.controller() == address(this), ERROR_TOKEN_CONTROLLER);
3276 
3277         token = _token;
3278         maxAccountTokens = _maxAccountTokens == 0 ? uint256(-1) : _maxAccountTokens;
3279 
3280         if (token.transfersEnabled() != _transferable) {
3281             token.enableTransfers(_transferable);
3282         }
3283     }
3284 
3285     /**
3286     * @notice Mint `@tokenAmount(self.token(): address, _amount, false)` tokens for `_receiver`
3287     * @param _receiver The address receiving the tokens
3288     * @param _amount Number of tokens minted
3289     */
3290     function mint(address _receiver, uint256 _amount) external authP(MINT_ROLE, arr(_receiver, _amount)) {
3291         require(_isBalanceIncreaseAllowed(_receiver, _amount), ERROR_MINT_BALANCE_INCREASE_NOT_ALLOWED);
3292         _mint(_receiver, _amount);
3293     }
3294 
3295     /**
3296     * @notice Mint `@tokenAmount(self.token(): address, _amount, false)` tokens for the Token Manager
3297     * @param _amount Number of tokens minted
3298     */
3299     function issue(uint256 _amount) external authP(ISSUE_ROLE, arr(_amount)) {
3300         _mint(address(this), _amount);
3301     }
3302 
3303     /**
3304     * @notice Assign `@tokenAmount(self.token(): address, _amount, false)` tokens to `_receiver` from the Token Manager's holdings
3305     * @param _receiver The address receiving the tokens
3306     * @param _amount Number of tokens transferred
3307     */
3308     function assign(address _receiver, uint256 _amount) external authP(ASSIGN_ROLE, arr(_receiver, _amount)) {
3309         _assign(_receiver, _amount);
3310     }
3311 
3312     /**
3313     * @notice Burn `@tokenAmount(self.token(): address, _amount, false)` tokens from `_holder`
3314     * @param _holder Holder of tokens being burned
3315     * @param _amount Number of tokens being burned
3316     */
3317     function burn(address _holder, uint256 _amount) external authP(BURN_ROLE, arr(_holder, _amount)) {
3318         // minime.destroyTokens() never returns false, only reverts on failure
3319         token.destroyTokens(_holder, _amount);
3320     }
3321 
3322     /**
3323     * @notice Assign `@tokenAmount(self.token(): address, _amount, false)` tokens to `_receiver` from the Token Manager's holdings with a `_revokable : 'revokable' : ''` vesting starting at `@formatDate(_start)`, cliff at `@formatDate(_cliff)` (first portion of tokens transferable), and completed vesting at `@formatDate(_vested)` (all tokens transferable)
3324     * @param _receiver The address receiving the tokens
3325     * @param _amount Number of tokens vested
3326     * @param _start Date the vesting calculations start
3327     * @param _cliff Date when the initial portion of tokens are transferable
3328     * @param _vested Date when all tokens are transferable
3329     * @param _revokable Whether the vesting can be revoked by the Token Manager
3330     */
3331     function assignVested(
3332         address _receiver,
3333         uint256 _amount,
3334         uint64 _start,
3335         uint64 _cliff,
3336         uint64 _vested,
3337         bool _revokable
3338     )
3339         external
3340         authP(ASSIGN_ROLE, arr(_receiver, _amount))
3341         returns (uint256)
3342     {
3343         require(vestingsLengths[_receiver] < MAX_VESTINGS_PER_ADDRESS, ERROR_TOO_MANY_VESTINGS);
3344 
3345         require(_start <= _cliff && _cliff <= _vested, ERROR_WRONG_CLIFF_DATE);
3346 
3347         uint256 vestingId = vestingsLengths[_receiver]++;
3348         vestings[_receiver][vestingId] = TokenVesting(
3349             _amount,
3350             _start,
3351             _cliff,
3352             _vested,
3353             _revokable
3354         );
3355 
3356         _assign(_receiver, _amount);
3357 
3358         emit NewVesting(_receiver, vestingId, _amount);
3359 
3360         return vestingId;
3361     }
3362 
3363     /**
3364     * @notice Revoke vesting #`_vestingId` from `_holder`, returning unvested tokens to the Token Manager
3365     * @param _holder Address whose vesting to revoke
3366     * @param _vestingId Numeric id of the vesting
3367     */
3368     function revokeVesting(address _holder, uint256 _vestingId)
3369         external
3370         authP(REVOKE_VESTINGS_ROLE, arr(_holder))
3371         vestingExists(_holder, _vestingId)
3372     {
3373         TokenVesting storage v = vestings[_holder][_vestingId];
3374         require(v.revokable, ERROR_VESTING_NOT_REVOKABLE);
3375 
3376         uint256 nonVested = _calculateNonVestedTokens(
3377             v.amount,
3378             getTimestamp64(),
3379             v.start,
3380             v.cliff,
3381             v.vesting
3382         );
3383 
3384         // To make vestingIds immutable over time, we just zero out the revoked vesting
3385         delete vestings[_holder][_vestingId];
3386 
3387         // transferFrom always works as controller
3388         // onTransfer hook always allows if transfering to token controller
3389         require(token.transferFrom(_holder, address(this), nonVested), ERROR_REVOKE_TRANSFER_FROM_REVERTED);
3390 
3391         emit RevokeVesting(_holder, _vestingId, nonVested);
3392     }
3393 
3394     /**
3395     * @notice Execute desired action as a token holder
3396     * @dev IForwarder interface conformance. Forwards any token holder action.
3397     * @param _evmScript Script being executed
3398     */
3399     function forward(bytes _evmScript) public {
3400         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
3401         bytes memory input = new bytes(0); // TODO: Consider input for this
3402 
3403         // Add the managed token to the blacklist to disallow a token holder from executing actions
3404         // on the token controller's (this contract) behalf
3405         address[] memory blacklist = new address[](1);
3406         blacklist[0] = address(token);
3407 
3408         runScript(_evmScript, input, blacklist);
3409     }
3410 
3411     function isForwarder() public pure returns (bool) {
3412         return true;
3413     }
3414 
3415     function canForward(address _sender, bytes) public view returns (bool) {
3416         return hasInitialized() && token.balanceOf(_sender) > 0;
3417     }
3418 
3419     function getVesting(
3420         address _recipient,
3421         uint256 _vestingId
3422     )
3423         public
3424         view
3425         vestingExists(_recipient, _vestingId)
3426         returns (
3427             uint256 amount,
3428             uint64 start,
3429             uint64 cliff,
3430             uint64 vesting,
3431             bool revokable
3432         )
3433     {
3434         TokenVesting storage tokenVesting = vestings[_recipient][_vestingId];
3435         amount = tokenVesting.amount;
3436         start = tokenVesting.start;
3437         cliff = tokenVesting.cliff;
3438         vesting = tokenVesting.vesting;
3439         revokable = tokenVesting.revokable;
3440     }
3441 
3442     /*
3443     * @dev Notifies the controller about a token transfer allowing the controller to decide whether to allow it or react if desired (only callable from the token)
3444     * @param _from The origin of the transfer
3445     * @param _to The destination of the transfer
3446     * @param _amount The amount of the transfer
3447     * @return False if the controller does not authorize the transfer
3448     */
3449     function onTransfer(address _from, address _to, uint _amount) public isInitialized returns (bool) {
3450         require(msg.sender == address(token), ERROR_ON_TRANSFER_WRONG_SENDER);
3451 
3452         bool includesTokenManager = _from == address(this) || _to == address(this);
3453 
3454         if (!includesTokenManager) {
3455             bool toCanReceive = _isBalanceIncreaseAllowed(_to, _amount);
3456             if (!toCanReceive || transferableBalance(_from, now) < _amount) {
3457                 return false;
3458             }
3459         }
3460 
3461         return true;
3462     }
3463 
3464     /**
3465     * @notice Called when ether is sent to the MiniMe Token contract
3466     * @return True if the ether is accepted, false for it to throw
3467     */
3468     function proxyPayment(address) public payable returns (bool) {
3469         // Sender check is required to avoid anyone sending ETH to the Token Manager through this method
3470         // Even though it is tested, solidity-coverage doesnt get it because
3471         // MiniMeToken is not instrumented and entire tx is reverted
3472         require(msg.sender == address(token), ERROR_PROXY_PAYMENT_WRONG_SENDER);
3473         return false;
3474     }
3475 
3476     /**
3477     * @dev Notifies the controller about an approval allowing the controller to react if desired
3478     * @return False if the controller does not authorize the approval
3479     */
3480     function onApprove(address, address, uint) public returns (bool) {
3481         return true;
3482     }
3483 
3484     function _isBalanceIncreaseAllowed(address _receiver, uint _inc) internal view returns (bool) {
3485         return token.balanceOf(_receiver).add(_inc) <= maxAccountTokens;
3486     }
3487 
3488     function spendableBalanceOf(address _holder) public view returns (uint256) {
3489         return transferableBalance(_holder, now);
3490     }
3491 
3492     function transferableBalance(address _holder, uint256 _time) public view returns (uint256) {
3493         uint256 vestingsCount = vestingsLengths[_holder];
3494         uint256 totalNonTransferable = 0;
3495 
3496         for (uint256 i = 0; i < vestingsCount; i++) {
3497             TokenVesting storage v = vestings[_holder][i];
3498             uint nonTransferable = _calculateNonVestedTokens(
3499                 v.amount,
3500                 _time.toUint64(),
3501                 v.start,
3502                 v.cliff,
3503                 v.vesting
3504             );
3505             totalNonTransferable = totalNonTransferable.add(nonTransferable);
3506         }
3507 
3508         return token.balanceOf(_holder).sub(totalNonTransferable);
3509     }
3510 
3511     /**
3512     * @dev Disable recovery escape hatch for own token,
3513     *      as the it has the concept of issuing tokens without assigning them
3514     */
3515     function allowRecoverability(address _token) public view returns (bool) {
3516         return _token != address(token);
3517     }
3518 
3519     /**
3520     * @dev Calculate amount of non-vested tokens at a specifc time
3521     * @param tokens The total amount of tokens vested
3522     * @param time The time at which to check
3523     * @param start The date vesting started
3524     * @param cliff The cliff period
3525     * @param vested The fully vested date
3526     * @return The amount of non-vested tokens of a specific grant
3527     *  transferableTokens
3528     *   |                         _/--------   vestedTokens rect
3529     *   |                       _/
3530     *   |                     _/
3531     *   |                   _/
3532     *   |                 _/
3533     *   |                /
3534     *   |              .|
3535     *   |            .  |
3536     *   |          .    |
3537     *   |        .      |
3538     *   |      .        |
3539     *   |    .          |
3540     *   +===+===========+---------+----------> time
3541     *      Start       Cliff    Vested
3542     */
3543     function _calculateNonVestedTokens(
3544         uint256 tokens,
3545         uint256 time,
3546         uint256 start,
3547         uint256 cliff,
3548         uint256 vested
3549     )
3550         private
3551         pure
3552         returns (uint256)
3553     {
3554         // Shortcuts for before cliff and after vested cases.
3555         if (time >= vested) {
3556             return 0;
3557         }
3558         if (time < cliff) {
3559             return tokens;
3560         }
3561 
3562         // Interpolate all vested tokens.
3563         // As before cliff the shortcut returns 0, we can just calculate a value
3564         // in the vesting rect (as shown in above's figure)
3565 
3566         // vestedTokens = tokens * (time - start) / (vested - start)
3567         // In assignVesting we enforce start <= cliff <= vested
3568         // Here we shortcut time >= vested and time < cliff,
3569         // so no division by 0 is possible
3570         uint256 vestedTokens = tokens.mul(time.sub(start)) / vested.sub(start);
3571 
3572         // tokens - vestedTokens
3573         return tokens.sub(vestedTokens);
3574     }
3575 
3576     function _assign(address _receiver, uint256 _amount) internal {
3577         require(_isBalanceIncreaseAllowed(_receiver, _amount), ERROR_ASSIGN_BALANCE_INCREASE_NOT_ALLOWED);
3578         // Must use transferFrom() as transfer() does not give the token controller full control
3579         require(token.transferFrom(this, _receiver, _amount), ERROR_ASSIGN_TRANSFER_FROM_REVERTED);
3580     }
3581 
3582     function _mint(address _receiver, uint256 _amount) internal {
3583         token.generateTokens(_receiver, _amount); // minime.generateTokens() never returns false
3584     }
3585 }
3586 // File: @aragon/apps-finance/contracts/Finance.sol
3587 /*
3588  * SPDX-License-Identitifer:    GPL-3.0-or-later
3589  */
3590 
3591 pragma solidity 0.4.24;
3592 
3593 
3594 
3595 
3596 
3597 
3598 
3599 
3600 
3601 contract Finance is EtherTokenConstant, IsContract, AragonApp {
3602     using SafeMath for uint256;
3603     using SafeMath64 for uint64;
3604 
3605     bytes32 public constant CREATE_PAYMENTS_ROLE = keccak256("CREATE_PAYMENTS_ROLE");
3606     bytes32 public constant CHANGE_PERIOD_ROLE = keccak256("CHANGE_PERIOD_ROLE");
3607     bytes32 public constant CHANGE_BUDGETS_ROLE = keccak256("CHANGE_BUDGETS_ROLE");
3608     bytes32 public constant EXECUTE_PAYMENTS_ROLE = keccak256("EXECUTE_PAYMENTS_ROLE");
3609     bytes32 public constant MANAGE_PAYMENTS_ROLE = keccak256("MANAGE_PAYMENTS_ROLE");
3610 
3611     uint256 internal constant NO_PAYMENT = 0;
3612     uint256 internal constant NO_TRANSACTION = 0;
3613     uint256 internal constant MAX_PAYMENTS_PER_TX = 20;
3614     uint256 internal constant MAX_UINT = uint256(-1);
3615     uint64 internal constant MAX_UINT64 = uint64(-1);
3616 
3617     string private constant ERROR_COMPLETE_TRANSITION = "FINANCE_COMPLETE_TRANSITION";
3618     string private constant ERROR_NO_PAYMENT = "FINANCE_NO_PAYMENT";
3619     string private constant ERROR_NO_TRANSACTION = "FINANCE_NO_TRANSACTION";
3620     string private constant ERROR_NO_PERIOD = "FINANCE_NO_PERIOD";
3621     string private constant ERROR_VAULT_NOT_CONTRACT = "FINANCE_VAULT_NOT_CONTRACT";
3622     string private constant ERROR_INIT_PERIOD_TOO_SHORT = "FINANCE_INIT_PERIOD_TOO_SHORT";
3623     string private constant ERROR_SET_PERIOD_TOO_SHORT = "FINANCE_SET_PERIOD_TOO_SHORT";
3624     string private constant ERROR_NEW_PAYMENT_AMOUNT_ZERO = "FINANCE_NEW_PAYMENT_AMOUNT_ZERO";
3625     string private constant ERROR_RECOVER_AMOUNT_ZERO = "FINANCE_RECOVER_AMOUNT_ZERO";
3626     string private constant ERROR_DEPOSIT_AMOUNT_ZERO = "FINANCE_DEPOSIT_AMOUNT_ZERO";
3627     string private constant ERROR_BUDGET = "FINANCE_BUDGET";
3628     string private constant ERROR_EXECUTE_PAYMENT_TIME = "FINANCE_EXECUTE_PAYMENT_TIME";
3629     string private constant ERROR_RECEIVER_EXECUTE_PAYMENT_TIME = "FINANCE_RCVR_EXEC_PAYMENT_TIME";
3630     string private constant ERROR_PAYMENT_RECEIVER = "FINANCE_PAYMENT_RECEIVER";
3631     string private constant ERROR_TOKEN_TRANSFER_FROM_REVERTED = "FINANCE_TKN_TRANSFER_FROM_REVERT";
3632     string private constant ERROR_VALUE_MISMATCH = "FINANCE_VALUE_MISMATCH";
3633     string private constant ERROR_PAYMENT_INACTIVE = "FINANCE_PAYMENT_INACTIVE";
3634     string private constant ERROR_REMAINING_BUDGET = "FINANCE_REMAINING_BUDGET";
3635 
3636     // Order optimized for storage
3637     struct Payment {
3638         address token;
3639         address receiver;
3640         address createdBy;
3641         bool inactive;
3642         uint256 amount;
3643         uint64 initialPaymentTime;
3644         uint64 interval;
3645         uint64 maxRepeats;
3646         uint64 repeats;
3647     }
3648 
3649     // Order optimized for storage
3650     struct Transaction {
3651         address token;
3652         address entity;
3653         bool isIncoming;
3654         uint256 amount;
3655         uint256 paymentId;
3656         uint64 paymentRepeatNumber;
3657         uint64 date;
3658         uint64 periodId;
3659     }
3660 
3661     struct TokenStatement {
3662         uint256 expenses;
3663         uint256 income;
3664     }
3665 
3666     struct Period {
3667         uint64 startTime;
3668         uint64 endTime;
3669         uint256 firstTransactionId;
3670         uint256 lastTransactionId;
3671 
3672         mapping (address => TokenStatement) tokenStatement;
3673     }
3674 
3675     struct Settings {
3676         uint64 periodDuration;
3677         mapping (address => uint256) budgets;
3678         mapping (address => bool) hasBudget;
3679     }
3680 
3681     Vault public vault;
3682     Settings internal settings;
3683 
3684     // We are mimicing arrays, we use mappings instead to make app upgrade more graceful
3685     mapping (uint256 => Payment) internal payments;
3686     // Payments start at index 1, to allow us to use payments[0] for transactions that are not
3687     // linked to a recurring payment
3688     uint256 public paymentsNextIndex;
3689 
3690     mapping (uint256 => Transaction) internal transactions;
3691     uint256 public transactionsNextIndex;
3692 
3693     mapping (uint64 => Period) internal periods;
3694     uint64 public periodsLength;
3695 
3696     event NewPeriod(uint64 indexed periodId, uint64 periodStarts, uint64 periodEnds);
3697     event SetBudget(address indexed token, uint256 amount, bool hasBudget);
3698     event NewPayment(uint256 indexed paymentId, address indexed recipient, uint64 maxRepeats, string reference);
3699     event NewTransaction(uint256 indexed transactionId, bool incoming, address indexed entity, uint256 amount, string reference);
3700     event ChangePaymentState(uint256 indexed paymentId, bool inactive);
3701     event ChangePeriodDuration(uint64 newDuration);
3702     event PaymentFailure(uint256 paymentId);
3703 
3704     // Modifier used by all methods that impact accounting to make sure accounting period
3705     // is changed before the operation if needed
3706     // NOTE: its use **MUST** be accompanied by an initialization check
3707     modifier transitionsPeriod {
3708         bool completeTransition = _tryTransitionAccountingPeriod(getMaxPeriodTransitions());
3709         require(completeTransition, ERROR_COMPLETE_TRANSITION);
3710         _;
3711     }
3712 
3713     modifier paymentExists(uint256 _paymentId) {
3714         require(_paymentId > 0 && _paymentId < paymentsNextIndex, ERROR_NO_PAYMENT);
3715         _;
3716     }
3717 
3718     modifier transactionExists(uint256 _transactionId) {
3719         require(_transactionId > 0 && _transactionId < transactionsNextIndex, ERROR_NO_TRANSACTION);
3720         _;
3721     }
3722 
3723     modifier periodExists(uint64 _periodId) {
3724         require(_periodId < periodsLength, ERROR_NO_PERIOD);
3725         _;
3726     }
3727 
3728     /**
3729      * @dev Sends ETH to Vault. Sends all the available balance.
3730      * @notice Deposit ETH to the Vault, to avoid locking them in this Finance app forever
3731      */
3732     function () external payable isInitialized transitionsPeriod {
3733         _deposit(
3734             ETH,
3735             msg.value,
3736             "Ether transfer to Finance app",
3737             msg.sender,
3738             true
3739         );
3740     }
3741 
3742     /**
3743     * @notice Initialize Finance app for Vault at `_vault` with period length of `@transformTime(_periodDuration)`
3744     * @param _vault Address of the vault Finance will rely on (non changeable)
3745     * @param _periodDuration Duration in seconds of each period
3746     */
3747     function initialize(Vault _vault, uint64 _periodDuration) external onlyInit {
3748         initialized();
3749 
3750         require(isContract(_vault), ERROR_VAULT_NOT_CONTRACT);
3751         vault = _vault;
3752 
3753         require(_periodDuration >= 1 days, ERROR_INIT_PERIOD_TOO_SHORT);
3754         settings.periodDuration = _periodDuration;
3755 
3756         // Reserve the first recurring payment index as an unused index for transactions not linked to a payment
3757         payments[0].inactive = true;
3758         paymentsNextIndex = 1;
3759 
3760         // Reserve the first transaction index as an unused index for periods with no transactions
3761         transactionsNextIndex = 1;
3762 
3763         // Start the first period
3764         _newPeriod(getTimestamp64());
3765     }
3766 
3767     /**
3768     * @dev Deposit for approved ERC20 tokens or ETH
3769     * @notice Deposit `@tokenAmount(_token, _amount)`
3770     * @param _token Address of deposited token
3771     * @param _amount Amount of tokens sent
3772     * @param _reference Reason for payment
3773     */
3774     function deposit(address _token, uint256 _amount, string _reference) external payable isInitialized transitionsPeriod {
3775         _deposit(
3776             _token,
3777             _amount,
3778             _reference,
3779             msg.sender,
3780             true
3781         );
3782     }
3783 
3784     /**
3785     * @notice Create a new payment of `@tokenAmount(_token, _amount)` to `_receiver``_maxRepeats > 0 ? ', executing ' + _maxRepeats + ' times at intervals of ' + @transformTime(_interval) : ''`
3786     * @param _token Address of token for payment
3787     * @param _receiver Address that will receive payment
3788     * @param _amount Tokens that are payed every time the payment is due
3789     * @param _initialPaymentTime Timestamp for when the first payment is done
3790     * @param _interval Number of seconds that need to pass between payment transactions
3791     * @param _maxRepeats Maximum instances a payment can be executed
3792     * @param _reference String detailing payment reason
3793     */
3794     function newPayment(
3795         address _token,
3796         address _receiver,
3797         uint256 _amount,
3798         uint64 _initialPaymentTime,
3799         uint64 _interval,
3800         uint64 _maxRepeats,
3801         string _reference
3802     )
3803         external
3804         authP(CREATE_PAYMENTS_ROLE, arr(_token, _receiver, _amount, _interval, _maxRepeats))
3805         transitionsPeriod
3806         returns (uint256 paymentId)
3807     {
3808         require(_amount > 0, ERROR_NEW_PAYMENT_AMOUNT_ZERO);
3809 
3810         // Avoid saving payment data for 1 time immediate payments
3811         if (_initialPaymentTime <= getTimestamp64() && _maxRepeats == 1) {
3812             _makePaymentTransaction(
3813                 _token,
3814                 _receiver,
3815                 _amount,
3816                 NO_PAYMENT,   // unrelated to any payment id; it isn't created
3817                 0,   // also unrelated to any payment repeats
3818                 _reference
3819             );
3820             return;
3821         }
3822 
3823         // Budget must allow at least one instance of this payment each period, or not be set at all
3824         require(settings.budgets[_token] >= _amount || !settings.hasBudget[_token], ERROR_BUDGET);
3825 
3826         paymentId = paymentsNextIndex++;
3827         emit NewPayment(paymentId, _receiver, _maxRepeats, _reference);
3828 
3829         Payment storage payment = payments[paymentId];
3830         payment.token = _token;
3831         payment.receiver = _receiver;
3832         payment.amount = _amount;
3833         payment.initialPaymentTime = _initialPaymentTime;
3834         payment.interval = _interval;
3835         payment.maxRepeats = _maxRepeats;
3836         payment.createdBy = msg.sender;
3837 
3838         if (nextPaymentTime(paymentId) <= getTimestamp64()) {
3839             _executePayment(paymentId);
3840         }
3841     }
3842 
3843     /**
3844     * @notice Change period duration to `@transformTime(_periodDuration)`, effective for next accounting period
3845     * @param _periodDuration Duration in seconds for accounting periods
3846     */
3847     function setPeriodDuration(uint64 _periodDuration)
3848         external
3849         authP(CHANGE_PERIOD_ROLE, arr(uint256(_periodDuration), uint256(settings.periodDuration)))
3850         transitionsPeriod
3851     {
3852         require(_periodDuration >= 1 days, ERROR_SET_PERIOD_TOO_SHORT);
3853         settings.periodDuration = _periodDuration;
3854         emit ChangePeriodDuration(_periodDuration);
3855     }
3856 
3857     /**
3858     * @notice Set budget for `_token.symbol(): string` to `@tokenAmount(_token, _amount, false)`, effective immediately
3859     * @param _token Address for token
3860     * @param _amount New budget amount
3861     */
3862     function setBudget(
3863         address _token,
3864         uint256 _amount
3865     )
3866         external
3867         authP(CHANGE_BUDGETS_ROLE, arr(_token, _amount, settings.budgets[_token], settings.hasBudget[_token] ? 1 : 0))
3868         transitionsPeriod
3869     {
3870         settings.budgets[_token] = _amount;
3871         if (!settings.hasBudget[_token]) {
3872             settings.hasBudget[_token] = true;
3873         }
3874         emit SetBudget(_token, _amount, true);
3875     }
3876 
3877     /**
3878     * @notice Remove spending limit for `_token.symbol(): string`, effective immediately
3879     * @param _token Address for token
3880     */
3881     function removeBudget(address _token)
3882         external
3883         authP(CHANGE_BUDGETS_ROLE, arr(_token, uint256(0), settings.budgets[_token], settings.hasBudget[_token] ? 1 : 0))
3884         transitionsPeriod
3885     {
3886         settings.budgets[_token] = 0;
3887         settings.hasBudget[_token] = false;
3888         emit SetBudget(_token, 0, false);
3889     }
3890 
3891     /**
3892     * @dev Executes any payment (requires role)
3893     * @notice Execute pending payment #`_paymentId`
3894     * @param _paymentId Identifier for payment
3895     */
3896     function executePayment(uint256 _paymentId)
3897         external
3898         authP(EXECUTE_PAYMENTS_ROLE, arr(_paymentId, payments[_paymentId].amount))
3899         paymentExists(_paymentId)
3900         transitionsPeriod
3901     {
3902         require(nextPaymentTime(_paymentId) <= getTimestamp64(), ERROR_EXECUTE_PAYMENT_TIME);
3903 
3904         _executePayment(_paymentId);
3905     }
3906 
3907     /**
3908     * @dev Always allows receiver of a payment to trigger execution
3909     * @notice Execute pending payment #`_paymentId`
3910     * @param _paymentId Identifier for payment
3911     */
3912     function receiverExecutePayment(uint256 _paymentId) external isInitialized paymentExists(_paymentId) transitionsPeriod {
3913         require(nextPaymentTime(_paymentId) <= getTimestamp64(), ERROR_RECEIVER_EXECUTE_PAYMENT_TIME);
3914         require(payments[_paymentId].receiver == msg.sender, ERROR_PAYMENT_RECEIVER);
3915 
3916         _executePayment(_paymentId);
3917     }
3918 
3919     /**
3920     * @notice `_active ? 'Activate' : 'Disable'` payment #`_paymentId`
3921     * @dev Note that we do not require this action to transition periods, as it doesn't directly
3922     *      impact any accounting periods.
3923     *      Not having to transition periods also makes disabling payments easier to prevent funds
3924     *      from being pulled out in the event of a breach.
3925     * @param _paymentId Identifier for payment
3926     * @param _active Whether it will be active or inactive
3927     */
3928     function setPaymentStatus(uint256 _paymentId, bool _active)
3929         external
3930         authP(MANAGE_PAYMENTS_ROLE, arr(_paymentId, uint256(_active ? 1 : 0)))
3931         paymentExists(_paymentId)
3932     {
3933         payments[_paymentId].inactive = !_active;
3934         emit ChangePaymentState(_paymentId, _active);
3935     }
3936 
3937     /**
3938      * @dev Allows making a simple payment from this contract to the Vault, to avoid locked tokens.
3939      *      This contract should never receive tokens with a simple transfer call, but in case it
3940      *      happens, this function allows for their recovery.
3941      * @notice Send tokens held in this contract to the Vault
3942      * @param _token Token whose balance is going to be transferred.
3943      */
3944     function recoverToVault(address _token) public isInitialized transitionsPeriod {
3945         uint256 amount = _token == ETH ? address(this).balance : ERC20(_token).balanceOf(this);
3946         require(amount > 0, ERROR_RECOVER_AMOUNT_ZERO);
3947 
3948         _deposit(
3949             _token,
3950             amount,
3951             "Recover to Vault",
3952             this,
3953             false
3954         );
3955     }
3956 
3957     /**
3958     * @dev Transitions accounting periods if needed. For preventing OOG attacks, a maxTransitions
3959     *      param is provided. If more than the specified number of periods need to be transitioned,
3960     *      it will return false.
3961     * @notice Transition accounting period if needed
3962     * @param _maxTransitions Maximum periods that can be transitioned
3963     * @return success Boolean indicating whether the accounting period is the correct one (if false,
3964     *                 maxTransitions was surpased and another call is needed)
3965     */
3966     function tryTransitionAccountingPeriod(uint64 _maxTransitions) public isInitialized returns (bool success) {
3967         return _tryTransitionAccountingPeriod(_maxTransitions);
3968     }
3969 
3970     // consts
3971 
3972     /**
3973     * @dev Disable recovery escape hatch if the app has been initialized, as it could be used
3974     *      maliciously to transfer funds in the Finance app to another Vault
3975     *      finance#recoverToVault() should be used to recover funds to the Finance's vault
3976     */
3977     function allowRecoverability(address) public view returns (bool) {
3978         return !hasInitialized();
3979     }
3980 
3981     function getPayment(uint256 _paymentId)
3982         public
3983         view
3984         paymentExists(_paymentId)
3985         returns (
3986             address token,
3987             address receiver,
3988             uint256 amount,
3989             uint64 initialPaymentTime,
3990             uint64 interval,
3991             uint64 maxRepeats,
3992             bool inactive,
3993             uint64 repeats,
3994             address createdBy
3995         )
3996     {
3997         Payment storage payment = payments[_paymentId];
3998 
3999         token = payment.token;
4000         receiver = payment.receiver;
4001         amount = payment.amount;
4002         initialPaymentTime = payment.initialPaymentTime;
4003         interval = payment.interval;
4004         maxRepeats = payment.maxRepeats;
4005         repeats = payment.repeats;
4006         inactive = payment.inactive;
4007         createdBy = payment.createdBy;
4008     }
4009 
4010     function getTransaction(uint256 _transactionId)
4011         public
4012         view
4013         transactionExists(_transactionId)
4014         returns (
4015             uint64 periodId,
4016             uint256 amount,
4017             uint256 paymentId,
4018             uint64 paymentRepeatNumber,
4019             address token,
4020             address entity,
4021             bool isIncoming,
4022             uint64 date
4023         )
4024     {
4025         Transaction storage transaction = transactions[_transactionId];
4026 
4027         token = transaction.token;
4028         entity = transaction.entity;
4029         isIncoming = transaction.isIncoming;
4030         date = transaction.date;
4031         periodId = transaction.periodId;
4032         amount = transaction.amount;
4033         paymentId = transaction.paymentId;
4034         paymentRepeatNumber = transaction.paymentRepeatNumber;
4035     }
4036 
4037     function getPeriod(uint64 _periodId)
4038         public
4039         view
4040         periodExists(_periodId)
4041         returns (
4042             bool isCurrent,
4043             uint64 startTime,
4044             uint64 endTime,
4045             uint256 firstTransactionId,
4046             uint256 lastTransactionId
4047         )
4048     {
4049         Period storage period = periods[_periodId];
4050 
4051         isCurrent = _currentPeriodId() == _periodId;
4052 
4053         startTime = period.startTime;
4054         endTime = period.endTime;
4055         firstTransactionId = period.firstTransactionId;
4056         lastTransactionId = period.lastTransactionId;
4057     }
4058 
4059     function getPeriodTokenStatement(uint64 _periodId, address _token)
4060         public
4061         view
4062         periodExists(_periodId)
4063         returns (uint256 expenses, uint256 income)
4064     {
4065         TokenStatement storage tokenStatement = periods[_periodId].tokenStatement[_token];
4066         expenses = tokenStatement.expenses;
4067         income = tokenStatement.income;
4068     }
4069 
4070     function nextPaymentTime(uint256 _paymentId) public view paymentExists(_paymentId) returns (uint64) {
4071         Payment memory payment = payments[_paymentId];
4072 
4073         if (payment.repeats >= payment.maxRepeats) {
4074             return MAX_UINT64; // re-executes in some billions of years time... should not need to worry
4075         }
4076 
4077         // Split in multiple lines to circunvent linter warning
4078         uint64 increase = payment.repeats.mul(payment.interval);
4079         uint64 nextPayment = payment.initialPaymentTime.add(increase);
4080         return nextPayment;
4081     }
4082 
4083     function getPeriodDuration() public view returns (uint64) {
4084         return settings.periodDuration;
4085     }
4086 
4087     function getBudget(address _token) public view returns (uint256 budget, bool hasBudget) {
4088         budget = settings.budgets[_token];
4089         hasBudget = settings.hasBudget[_token];
4090     }
4091 
4092     /**
4093     * @dev We have to check for initialization as periods are only valid after initializing
4094     */
4095     function getRemainingBudget(address _token) public view isInitialized returns (uint256) {
4096         return _getRemainingBudget(_token);
4097     }
4098 
4099     /**
4100     * @dev We have to check for initialization as periods are only valid after initializing
4101     */
4102     function currentPeriodId() public view isInitialized returns (uint64) {
4103         return _currentPeriodId();
4104     }
4105 
4106     // internal fns
4107 
4108     function _deposit(address _token, uint256 _amount, string _reference, address _sender, bool _isExternalDeposit) internal {
4109         require(_amount > 0, ERROR_DEPOSIT_AMOUNT_ZERO);
4110         _recordIncomingTransaction(
4111             _token,
4112             _sender,
4113             _amount,
4114             _reference
4115         );
4116 
4117         // If it is an external deposit, check that the assets are actually transferred
4118         // External deposit will be false when the assets were already in the Finance app
4119         // and just need to be transferred to the vault
4120         if (_isExternalDeposit) {
4121             if (_token != ETH) {
4122                 // Get the tokens to Finance
4123                 require(ERC20(_token).transferFrom(msg.sender, this, _amount), ERROR_TOKEN_TRANSFER_FROM_REVERTED);
4124             } else {
4125                 // Ensure that the ETH sent with the transaction equals the amount in the deposit
4126                 require(msg.value == _amount, ERROR_VALUE_MISMATCH);
4127             }
4128         }
4129 
4130         if (_token == ETH) {
4131             vault.deposit.value(_amount)(ETH, _amount);
4132         } else {
4133             ERC20(_token).approve(vault, _amount);
4134             // finally we can deposit them
4135             vault.deposit(_token, _amount);
4136         }
4137     }
4138 
4139     function _newPeriod(uint64 _startTime) internal returns (Period storage) {
4140         // There should be no way for this to overflow since each period is at least one day
4141         uint64 newPeriodId = periodsLength++;
4142 
4143         Period storage period = periods[newPeriodId];
4144         period.startTime = _startTime;
4145 
4146         // Be careful here to not overflow; if startTime + periodDuration overflows, we set endTime
4147         // to MAX_UINT64 (let's assume that's the end of time for now).
4148         uint64 endTime = _startTime + settings.periodDuration - 1;
4149         if (endTime < _startTime) { // overflowed
4150             endTime = MAX_UINT64;
4151         }
4152         period.endTime = endTime;
4153 
4154         emit NewPeriod(newPeriodId, period.startTime, period.endTime);
4155 
4156         return period;
4157     }
4158 
4159     function _executePayment(uint256 _paymentId) internal {
4160         Payment storage payment = payments[_paymentId];
4161         require(!payment.inactive, ERROR_PAYMENT_INACTIVE);
4162 
4163         uint64 payed = 0;
4164         while (nextPaymentTime(_paymentId) <= getTimestamp64() && payed < MAX_PAYMENTS_PER_TX) {
4165             if (!_canMakePayment(payment.token, payment.amount)) {
4166                 emit PaymentFailure(_paymentId);
4167                 return;
4168             }
4169 
4170             // The while() predicate prevents these two from ever overflowing
4171             payment.repeats += 1;
4172             payed += 1;
4173 
4174             _makePaymentTransaction(
4175                 payment.token,
4176                 payment.receiver,
4177                 payment.amount,
4178                 _paymentId,
4179                 payment.repeats,
4180                 ""
4181             );
4182         }
4183     }
4184 
4185     function _makePaymentTransaction(
4186         address _token,
4187         address _receiver,
4188         uint256 _amount,
4189         uint256 _paymentId,
4190         uint64 _paymentRepeatNumber,
4191         string _reference
4192     )
4193         internal
4194     {
4195         require(_getRemainingBudget(_token) >= _amount, ERROR_REMAINING_BUDGET);
4196         _recordTransaction(
4197             false,
4198             _token,
4199             _receiver,
4200             _amount,
4201             _paymentId,
4202             _paymentRepeatNumber,
4203             _reference
4204         );
4205 
4206         vault.transfer(_token, _receiver, _amount);
4207     }
4208 
4209     function _recordIncomingTransaction(
4210         address _token,
4211         address _sender,
4212         uint256 _amount,
4213         string _reference
4214     )
4215         internal
4216     {
4217         _recordTransaction(
4218             true, // incoming transaction
4219             _token,
4220             _sender,
4221             _amount,
4222             NO_PAYMENT, // unrelated to any existing payment
4223             0, // and no payment repeats
4224             _reference
4225         );
4226     }
4227 
4228     function _recordTransaction(
4229         bool _incoming,
4230         address _token,
4231         address _entity,
4232         uint256 _amount,
4233         uint256 _paymentId,
4234         uint64 _paymentRepeatNumber,
4235         string _reference
4236     )
4237         internal
4238     {
4239         uint64 periodId = _currentPeriodId();
4240         TokenStatement storage tokenStatement = periods[periodId].tokenStatement[_token];
4241         if (_incoming) {
4242             tokenStatement.income = tokenStatement.income.add(_amount);
4243         } else {
4244             tokenStatement.expenses = tokenStatement.expenses.add(_amount);
4245         }
4246 
4247         uint256 transactionId = transactionsNextIndex++;
4248         Transaction storage transaction = transactions[transactionId];
4249         transaction.token = _token;
4250         transaction.entity = _entity;
4251         transaction.isIncoming = _incoming;
4252         transaction.amount = _amount;
4253         transaction.paymentId = _paymentId;
4254         transaction.paymentRepeatNumber = _paymentRepeatNumber;
4255         transaction.date = getTimestamp64();
4256         transaction.periodId = periodId;
4257 
4258         Period storage period = periods[periodId];
4259         if (period.firstTransactionId == NO_TRANSACTION) {
4260             period.firstTransactionId = transactionId;
4261         }
4262 
4263         emit NewTransaction(transactionId, _incoming, _entity, _amount, _reference);
4264     }
4265 
4266     function _tryTransitionAccountingPeriod(uint256 _maxTransitions) internal returns (bool success) {
4267         Period storage currentPeriod = periods[_currentPeriodId()];
4268         uint64 timestamp = getTimestamp64();
4269 
4270         // Transition periods if necessary
4271         while (timestamp > currentPeriod.endTime) {
4272             if (_maxTransitions == 0) {
4273                 // Required number of transitions is over allowed number, return false indicating
4274                 // it didn't fully transition
4275                 return false;
4276             }
4277             _maxTransitions = _maxTransitions.sub(1);
4278 
4279             // If there were any transactions in period, record which was the last
4280             // In case 0 transactions occured, first and last tx id will be 0
4281             if (currentPeriod.firstTransactionId != NO_TRANSACTION) {
4282                 currentPeriod.lastTransactionId = transactionsNextIndex.sub(1);
4283             }
4284 
4285             // New period starts at end time + 1
4286             currentPeriod = _newPeriod(currentPeriod.endTime.add(1));
4287         }
4288 
4289         return true;
4290     }
4291 
4292     function _canMakePayment(address _token, uint256 _amount) internal view returns (bool) {
4293         return _getRemainingBudget(_token) >= _amount && vault.balance(_token) >= _amount;
4294     }
4295 
4296     function _getRemainingBudget(address _token) internal view returns (uint256) {
4297         if (!settings.hasBudget[_token]) {
4298             return MAX_UINT;
4299         }
4300 
4301         uint256 spent = periods[_currentPeriodId()].tokenStatement[_token].expenses;
4302 
4303         // A budget decrease can cause the spent amount to be greater than period budget
4304         // If so, return 0 to not allow more spending during period
4305         if (spent >= settings.budgets[_token]) {
4306             return 0;
4307         }
4308 
4309         return settings.budgets[_token].sub(spent);
4310     }
4311 
4312     function _currentPeriodId() internal view returns (uint64) {
4313         // There is no way for this to overflow if protected by an initialization check
4314         return periodsLength - 1;
4315     }
4316 
4317     // Must be view for mocking purposes
4318     function getMaxPeriodTransitions() internal view returns (uint64) { return MAX_UINT64; }
4319 }
4320 // File: @aragon/os/contracts/apm/Repo.sol
4321 /* solium-disable function-order */
4322 // Allow public initialize() to be first
4323 contract Repo is AragonApp {
4324     /* Hardcoded constants to save gas
4325     bytes32 public constant CREATE_VERSION_ROLE = keccak256("CREATE_VERSION_ROLE");
4326     */
4327     bytes32 public constant CREATE_VERSION_ROLE = 0x1f56cfecd3595a2e6cc1a7e6cb0b20df84cdbd92eff2fee554e70e4e45a9a7d8;
4328 
4329     string private constant ERROR_INVALID_BUMP = "REPO_INVALID_BUMP";
4330     string private constant ERROR_INVALID_VERSION = "REPO_INVALID_VERSION";
4331     string private constant ERROR_INEXISTENT_VERSION = "REPO_INEXISTENT_VERSION";
4332 
4333     struct Version {
4334         uint16[3] semanticVersion;
4335         address contractAddress;
4336         bytes contentURI;
4337     }
4338 
4339     uint256 internal versionsNextIndex;
4340     mapping (uint256 => Version) internal versions;
4341     mapping (bytes32 => uint256) internal versionIdForSemantic;
4342     mapping (address => uint256) internal latestVersionIdForContract;
4343 
4344     event NewVersion(uint256 versionId, uint16[3] semanticVersion);
4345 
4346     /**
4347     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
4348     * @notice Initializes a Repo to be usable
4349     */
4350     function initialize() public onlyInit {
4351         initialized();
4352         versionsNextIndex = 1;
4353     }
4354 
4355     /**
4356     * @notice Create new version for repo
4357     * @param _newSemanticVersion Semantic version for new repo version
4358     * @param _contractAddress address for smart contract logic for version (if set to 0, it uses last versions' contractAddress)
4359     * @param _contentURI External URI for fetching new version's content
4360     */
4361     function newVersion(
4362         uint16[3] _newSemanticVersion,
4363         address _contractAddress,
4364         bytes _contentURI
4365     ) public auth(CREATE_VERSION_ROLE)
4366     {
4367         address contractAddress = _contractAddress;
4368         uint256 lastVersionIndex = versionsNextIndex - 1;
4369 
4370         uint16[3] memory lastSematicVersion;
4371 
4372         if (lastVersionIndex > 0) {
4373             Version storage lastVersion = versions[lastVersionIndex];
4374             lastSematicVersion = lastVersion.semanticVersion;
4375 
4376             if (contractAddress == address(0)) {
4377                 contractAddress = lastVersion.contractAddress;
4378             }
4379             // Only allows smart contract change on major version bumps
4380             require(
4381                 lastVersion.contractAddress == contractAddress || _newSemanticVersion[0] > lastVersion.semanticVersion[0],
4382                 ERROR_INVALID_VERSION
4383             );
4384         }
4385 
4386         require(isValidBump(lastSematicVersion, _newSemanticVersion), ERROR_INVALID_BUMP);
4387 
4388         uint256 versionId = versionsNextIndex++;
4389         versions[versionId] = Version(_newSemanticVersion, contractAddress, _contentURI);
4390         versionIdForSemantic[semanticVersionHash(_newSemanticVersion)] = versionId;
4391         latestVersionIdForContract[contractAddress] = versionId;
4392 
4393         emit NewVersion(versionId, _newSemanticVersion);
4394     }
4395 
4396     function getLatest() public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
4397         return getByVersionId(versionsNextIndex - 1);
4398     }
4399 
4400     function getLatestForContractAddress(address _contractAddress)
4401         public
4402         view
4403         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
4404     {
4405         return getByVersionId(latestVersionIdForContract[_contractAddress]);
4406     }
4407 
4408     function getBySemanticVersion(uint16[3] _semanticVersion)
4409         public
4410         view
4411         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
4412     {
4413         return getByVersionId(versionIdForSemantic[semanticVersionHash(_semanticVersion)]);
4414     }
4415 
4416     function getByVersionId(uint _versionId) public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
4417         require(_versionId > 0 && _versionId < versionsNextIndex, ERROR_INEXISTENT_VERSION);
4418         Version storage version = versions[_versionId];
4419         return (version.semanticVersion, version.contractAddress, version.contentURI);
4420     }
4421 
4422     function getVersionsCount() public view returns (uint256) {
4423         return versionsNextIndex - 1;
4424     }
4425 
4426     function isValidBump(uint16[3] _oldVersion, uint16[3] _newVersion) public pure returns (bool) {
4427         bool hasBumped;
4428         uint i = 0;
4429         while (i < 3) {
4430             if (hasBumped) {
4431                 if (_newVersion[i] != 0) {
4432                     return false;
4433                 }
4434             } else if (_newVersion[i] != _oldVersion[i]) {
4435                 if (_oldVersion[i] > _newVersion[i] || _newVersion[i] - _oldVersion[i] != 1) {
4436                     return false;
4437                 }
4438                 hasBumped = true;
4439             }
4440             i++;
4441         }
4442         return hasBumped;
4443     }
4444 
4445     function semanticVersionHash(uint16[3] version) internal pure returns (bytes32) {
4446         return keccak256(abi.encodePacked(version[0], version[1], version[2]));
4447     }
4448 }
4449 // File: @aragon/os/contracts/lib/ens/AbstractENS.sol
4450 interface AbstractENS {
4451     function owner(bytes32 _node) public constant returns (address);
4452     function resolver(bytes32 _node) public constant returns (address);
4453     function ttl(bytes32 _node) public constant returns (uint64);
4454     function setOwner(bytes32 _node, address _owner) public;
4455     function setSubnodeOwner(bytes32 _node, bytes32 label, address _owner) public;
4456     function setResolver(bytes32 _node, address _resolver) public;
4457     function setTTL(bytes32 _node, uint64 _ttl) public;
4458 
4459     // Logged when the owner of a node assigns a new owner to a subnode.
4460     event NewOwner(bytes32 indexed _node, bytes32 indexed _label, address _owner);
4461 
4462     // Logged when the owner of a node transfers ownership to a new account.
4463     event Transfer(bytes32 indexed _node, address _owner);
4464 
4465     // Logged when the resolver for a node changes.
4466     event NewResolver(bytes32 indexed _node, address _resolver);
4467 
4468     // Logged when the TTL of a node changes
4469     event NewTTL(bytes32 indexed _node, uint64 _ttl);
4470 }
4471 // File: @aragon/os/contracts/lib/ens/ENS.sol
4472 /**
4473  * The ENS registry contract.
4474  */
4475 contract ENS is AbstractENS {
4476     struct Record {
4477         address owner;
4478         address resolver;
4479         uint64 ttl;
4480     }
4481 
4482     mapping(bytes32=>Record) records;
4483 
4484     // Permits modifications only by the owner of the specified node.
4485     modifier only_owner(bytes32 node) {
4486         if (records[node].owner != msg.sender) throw;
4487         _;
4488     }
4489 
4490     /**
4491      * Constructs a new ENS registrar.
4492      */
4493     function ENS() public {
4494         records[0].owner = msg.sender;
4495     }
4496 
4497     /**
4498      * Returns the address that owns the specified node.
4499      */
4500     function owner(bytes32 node) public constant returns (address) {
4501         return records[node].owner;
4502     }
4503 
4504     /**
4505      * Returns the address of the resolver for the specified node.
4506      */
4507     function resolver(bytes32 node) public constant returns (address) {
4508         return records[node].resolver;
4509     }
4510 
4511     /**
4512      * Returns the TTL of a node, and any records associated with it.
4513      */
4514     function ttl(bytes32 node) public constant returns (uint64) {
4515         return records[node].ttl;
4516     }
4517 
4518     /**
4519      * Transfers ownership of a node to a new address. May only be called by the current
4520      * owner of the node.
4521      * @param node The node to transfer ownership of.
4522      * @param owner The address of the new owner.
4523      */
4524     function setOwner(bytes32 node, address owner) only_owner(node) public {
4525         Transfer(node, owner);
4526         records[node].owner = owner;
4527     }
4528 
4529     /**
4530      * Transfers ownership of a subnode keccak256(node, label) to a new address. May only be
4531      * called by the owner of the parent node.
4532      * @param node The parent node.
4533      * @param label The hash of the label specifying the subnode.
4534      * @param owner The address of the new owner.
4535      */
4536     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) public {
4537         var subnode = keccak256(node, label);
4538         NewOwner(node, label, owner);
4539         records[subnode].owner = owner;
4540     }
4541 
4542     /**
4543      * Sets the resolver address for the specified node.
4544      * @param node The node to update.
4545      * @param resolver The address of the resolver.
4546      */
4547     function setResolver(bytes32 node, address resolver) only_owner(node) public {
4548         NewResolver(node, resolver);
4549         records[node].resolver = resolver;
4550     }
4551 
4552     /**
4553      * Sets the TTL for the specified node.
4554      * @param node The node to update.
4555      * @param ttl The TTL in seconds.
4556      */
4557     function setTTL(bytes32 node, uint64 ttl) only_owner(node) public {
4558         NewTTL(node, ttl);
4559         records[node].ttl = ttl;
4560     }
4561 }
4562 // File: @aragon/os/contracts/lib/ens/PublicResolver.sol
4563 /**
4564  * A simple resolver anyone can use; only allows the owner of a node to set its
4565  * address.
4566  */
4567 contract PublicResolver {
4568     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
4569     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
4570     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
4571     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
4572     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
4573     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
4574     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
4575 
4576     event AddrChanged(bytes32 indexed node, address a);
4577     event ContentChanged(bytes32 indexed node, bytes32 hash);
4578     event NameChanged(bytes32 indexed node, string name);
4579     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
4580     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
4581     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
4582 
4583     struct PublicKey {
4584         bytes32 x;
4585         bytes32 y;
4586     }
4587 
4588     struct Record {
4589         address addr;
4590         bytes32 content;
4591         string name;
4592         PublicKey pubkey;
4593         mapping(string=>string) text;
4594         mapping(uint256=>bytes) abis;
4595     }
4596 
4597     AbstractENS ens;
4598     mapping(bytes32=>Record) records;
4599 
4600     modifier only_owner(bytes32 node) {
4601         if (ens.owner(node) != msg.sender) throw;
4602         _;
4603     }
4604 
4605     /**
4606      * Constructor.
4607      * @param ensAddr The ENS registrar contract.
4608      */
4609     function PublicResolver(AbstractENS ensAddr) public {
4610         ens = ensAddr;
4611     }
4612 
4613     /**
4614      * Returns true if the resolver implements the interface specified by the provided hash.
4615      * @param interfaceID The ID of the interface to check for.
4616      * @return True if the contract implements the requested interface.
4617      */
4618     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
4619         return interfaceID == ADDR_INTERFACE_ID ||
4620                interfaceID == CONTENT_INTERFACE_ID ||
4621                interfaceID == NAME_INTERFACE_ID ||
4622                interfaceID == ABI_INTERFACE_ID ||
4623                interfaceID == PUBKEY_INTERFACE_ID ||
4624                interfaceID == TEXT_INTERFACE_ID ||
4625                interfaceID == INTERFACE_META_ID;
4626     }
4627 
4628     /**
4629      * Returns the address associated with an ENS node.
4630      * @param node The ENS node to query.
4631      * @return The associated address.
4632      */
4633     function addr(bytes32 node) public constant returns (address ret) {
4634         ret = records[node].addr;
4635     }
4636 
4637     /**
4638      * Sets the address associated with an ENS node.
4639      * May only be called by the owner of that node in the ENS registry.
4640      * @param node The node to update.
4641      * @param addr The address to set.
4642      */
4643     function setAddr(bytes32 node, address addr) only_owner(node) public {
4644         records[node].addr = addr;
4645         AddrChanged(node, addr);
4646     }
4647 
4648     /**
4649      * Returns the content hash associated with an ENS node.
4650      * Note that this resource type is not standardized, and will likely change
4651      * in future to a resource type based on multihash.
4652      * @param node The ENS node to query.
4653      * @return The associated content hash.
4654      */
4655     function content(bytes32 node) public constant returns (bytes32 ret) {
4656         ret = records[node].content;
4657     }
4658 
4659     /**
4660      * Sets the content hash associated with an ENS node.
4661      * May only be called by the owner of that node in the ENS registry.
4662      * Note that this resource type is not standardized, and will likely change
4663      * in future to a resource type based on multihash.
4664      * @param node The node to update.
4665      * @param hash The content hash to set
4666      */
4667     function setContent(bytes32 node, bytes32 hash) only_owner(node) public {
4668         records[node].content = hash;
4669         ContentChanged(node, hash);
4670     }
4671 
4672     /**
4673      * Returns the name associated with an ENS node, for reverse records.
4674      * Defined in EIP181.
4675      * @param node The ENS node to query.
4676      * @return The associated name.
4677      */
4678     function name(bytes32 node) public constant returns (string ret) {
4679         ret = records[node].name;
4680     }
4681 
4682     /**
4683      * Sets the name associated with an ENS node, for reverse records.
4684      * May only be called by the owner of that node in the ENS registry.
4685      * @param node The node to update.
4686      * @param name The name to set.
4687      */
4688     function setName(bytes32 node, string name) only_owner(node) public {
4689         records[node].name = name;
4690         NameChanged(node, name);
4691     }
4692 
4693     /**
4694      * Returns the ABI associated with an ENS node.
4695      * Defined in EIP205.
4696      * @param node The ENS node to query
4697      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
4698      * @return contentType The content type of the return value
4699      * @return data The ABI data
4700      */
4701     function ABI(bytes32 node, uint256 contentTypes) public constant returns (uint256 contentType, bytes data) {
4702         var record = records[node];
4703         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
4704             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
4705                 data = record.abis[contentType];
4706                 return;
4707             }
4708         }
4709         contentType = 0;
4710     }
4711 
4712     /**
4713      * Sets the ABI associated with an ENS node.
4714      * Nodes may have one ABI of each content type. To remove an ABI, set it to
4715      * the empty string.
4716      * @param node The node to update.
4717      * @param contentType The content type of the ABI
4718      * @param data The ABI data.
4719      */
4720     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) public {
4721         // Content types must be powers of 2
4722         if (((contentType - 1) & contentType) != 0) throw;
4723 
4724         records[node].abis[contentType] = data;
4725         ABIChanged(node, contentType);
4726     }
4727 
4728     /**
4729      * Returns the SECP256k1 public key associated with an ENS node.
4730      * Defined in EIP 619.
4731      * @param node The ENS node to query
4732      * @return x, y the X and Y coordinates of the curve point for the public key.
4733      */
4734     function pubkey(bytes32 node) public constant returns (bytes32 x, bytes32 y) {
4735         return (records[node].pubkey.x, records[node].pubkey.y);
4736     }
4737 
4738     /**
4739      * Sets the SECP256k1 public key associated with an ENS node.
4740      * @param node The ENS node to query
4741      * @param x the X coordinate of the curve point for the public key.
4742      * @param y the Y coordinate of the curve point for the public key.
4743      */
4744     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) public {
4745         records[node].pubkey = PublicKey(x, y);
4746         PubkeyChanged(node, x, y);
4747     }
4748 
4749     /**
4750      * Returns the text data associated with an ENS node and key.
4751      * @param node The ENS node to query.
4752      * @param key The text data key to query.
4753      * @return The associated text data.
4754      */
4755     function text(bytes32 node, string key) public constant returns (string ret) {
4756         ret = records[node].text[key];
4757     }
4758 
4759     /**
4760      * Sets the text data associated with an ENS node and key.
4761      * May only be called by the owner of that node in the ENS registry.
4762      * @param node The node to update.
4763      * @param key The key to set.
4764      * @param value The text data value to set.
4765      */
4766     function setText(bytes32 node, string key, string value) only_owner(node) public {
4767         records[node].text[key] = value;
4768         TextChanged(node, key, key);
4769     }
4770 }
4771 // File: @aragon/kits-bare/contracts/KitBase.sol
4772 contract KitBase is EVMScriptRegistryConstants {
4773     ENS public ens;
4774     DAOFactory public fac;
4775 
4776     event DeployInstance(address dao);
4777     event InstalledApp(address appProxy, bytes32 appId);
4778 
4779     constructor (DAOFactory _fac, ENS _ens) {
4780         fac = _fac;
4781         ens = _ens;
4782     }
4783 
4784     function latestVersionAppBase(bytes32 appId) public view returns (address base) {
4785         Repo repo = Repo(PublicResolver(ens.resolver(appId)).addr(appId));
4786         (,base,) = repo.getLatest();
4787 
4788         return base;
4789     }
4790 
4791     function cleanupDAOPermissions(Kernel dao, ACL acl, address root) internal {
4792         // Kernel permission clean up
4793         cleanupPermission(acl, root, dao, dao.APP_MANAGER_ROLE());
4794 
4795         // ACL permission clean up
4796         cleanupPermission(acl, root, acl, acl.CREATE_PERMISSIONS_ROLE());
4797     }
4798 
4799     function cleanupPermission(ACL acl, address root, address app, bytes32 permission) internal {
4800         acl.grantPermission(root, app, permission);
4801         acl.revokePermission(this, app, permission);
4802         acl.setPermissionManager(root, app, permission);
4803     }
4804 }
4805 // File: @aragon/kits-beta-base/contracts/BetaKitBase.sol
4806 contract BetaKitBase is KitBase, IsContract {
4807     MiniMeTokenFactory public minimeFac;
4808     IFIFSResolvingRegistrar public aragonID;
4809     bytes32[4] public appIds;
4810 
4811     mapping (address => address) tokenCache;
4812 
4813     // ensure alphabetic order
4814     enum Apps { Finance, TokenManager, Vault, Voting }
4815 
4816     event DeployToken(address token, address indexed cacheOwner);
4817     event DeployInstance(address dao, address indexed token);
4818 
4819     constructor(
4820         DAOFactory _fac,
4821         ENS _ens,
4822         MiniMeTokenFactory _minimeFac,
4823         IFIFSResolvingRegistrar _aragonID,
4824         bytes32[4] _appIds
4825     )
4826         KitBase(_fac, _ens)
4827         public
4828     {
4829         require(isContract(address(_fac.regFactory())));
4830 
4831         minimeFac = _minimeFac;
4832         aragonID = _aragonID;
4833         appIds = _appIds;
4834     }
4835 
4836     function createDAO(
4837         string name,
4838         MiniMeToken token,
4839         address[] holders,
4840         uint256[] stakes,
4841         uint256 _maxTokens
4842     )
4843         internal
4844         returns (
4845             Kernel dao,
4846             ACL acl,
4847             Finance finance,
4848             TokenManager tokenManager,
4849             Vault vault,
4850             Voting voting
4851         )
4852     {
4853         require(holders.length == stakes.length);
4854 
4855         dao = fac.newDAO(this);
4856 
4857         acl = ACL(dao.acl());
4858 
4859         acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);
4860 
4861         voting = Voting(
4862             dao.newAppInstance(
4863                 appIds[uint8(Apps.Voting)],
4864                 latestVersionAppBase(appIds[uint8(Apps.Voting)])
4865             )
4866         );
4867         emit InstalledApp(voting, appIds[uint8(Apps.Voting)]);
4868 
4869         vault = Vault(
4870             dao.newAppInstance(
4871                 appIds[uint8(Apps.Vault)],
4872                 latestVersionAppBase(appIds[uint8(Apps.Vault)]),
4873                 new bytes(0),
4874                 true
4875             )
4876         );
4877         emit InstalledApp(vault, appIds[uint8(Apps.Vault)]);
4878 
4879         finance = Finance(
4880             dao.newAppInstance(
4881                 appIds[uint8(Apps.Finance)],
4882                 latestVersionAppBase(appIds[uint8(Apps.Finance)])
4883             )
4884         );
4885         emit InstalledApp(finance, appIds[uint8(Apps.Finance)]);
4886 
4887         tokenManager = TokenManager(
4888             dao.newAppInstance(
4889                 appIds[uint8(Apps.TokenManager)],
4890                 latestVersionAppBase(appIds[uint8(Apps.TokenManager)])
4891             )
4892         );
4893         emit InstalledApp(tokenManager, appIds[uint8(Apps.TokenManager)]);
4894 
4895         // Required for initializing the Token Manager
4896         token.changeController(tokenManager);
4897 
4898         // permissions
4899         acl.createPermission(voting, voting, voting.MODIFY_QUORUM_ROLE(), voting);
4900 
4901         acl.createPermission(finance, vault, vault.TRANSFER_ROLE(), voting);
4902         acl.createPermission(voting, finance, finance.CREATE_PAYMENTS_ROLE(), voting);
4903         acl.createPermission(voting, finance, finance.EXECUTE_PAYMENTS_ROLE(), voting);
4904         acl.createPermission(voting, finance, finance.MANAGE_PAYMENTS_ROLE(), voting);
4905         acl.createPermission(voting, tokenManager, tokenManager.ASSIGN_ROLE(), voting);
4906         acl.createPermission(voting, tokenManager, tokenManager.REVOKE_VESTINGS_ROLE(), voting);
4907 
4908         // App inits
4909         vault.initialize();
4910         finance.initialize(vault, 30 days);
4911         tokenManager.initialize(token, _maxTokens > 1, _maxTokens);
4912 
4913         // Set up the token stakes
4914         acl.createPermission(this, tokenManager, tokenManager.MINT_ROLE(), this);
4915 
4916         for (uint256 i = 0; i < holders.length; i++) {
4917             tokenManager.mint(holders[i], stakes[i]);
4918         }
4919 
4920         // EVMScriptRegistry permissions
4921         EVMScriptRegistry reg = EVMScriptRegistry(acl.getEVMScriptRegistry());
4922         acl.createPermission(voting, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE(), voting);
4923         acl.createPermission(voting, reg, reg.REGISTRY_MANAGER_ROLE(), voting);
4924 
4925         // clean-up
4926         cleanupPermission(acl, voting, dao, dao.APP_MANAGER_ROLE());
4927         cleanupPermission(acl, voting, tokenManager, tokenManager.MINT_ROLE());
4928 
4929         registerAragonID(name, dao);
4930         emit DeployInstance(dao, token);
4931 
4932         return (dao, acl, finance, tokenManager, vault, voting);
4933     }
4934 
4935     function cacheToken(MiniMeToken token, address owner) internal {
4936         tokenCache[owner] = token;
4937         emit DeployToken(token, owner);
4938     }
4939 
4940     function popTokenCache(address owner) internal returns (MiniMeToken) {
4941         require(tokenCache[owner] != address(0));
4942         MiniMeToken token = MiniMeToken(tokenCache[owner]);
4943         delete tokenCache[owner];
4944 
4945         return token;
4946     }
4947 
4948     function registerAragonID(string name, address owner) internal {
4949         aragonID.register(keccak256(abi.encodePacked(name)), owner);
4950     }
4951 }
4952 // File: contracts/DemocracyKit.sol
4953 contract DemocracyKit is BetaKitBase {
4954     constructor(
4955         DAOFactory _fac,
4956         ENS _ens,
4957         MiniMeTokenFactory _minimeFac,
4958         IFIFSResolvingRegistrar _aragonID,
4959         bytes32[4] _appIds
4960     )
4961         BetaKitBase(_fac, _ens, _minimeFac, _aragonID, _appIds)
4962         public
4963     {}
4964 
4965     function newTokenAndInstance(
4966         string name,
4967         string symbol,
4968         address[] holders,
4969         uint256[] tokens,
4970         uint64 supportNeeded,
4971         uint64 minAcceptanceQuorum,
4972         uint64 voteDuration
4973     ) public
4974     {
4975         newToken(name, symbol);
4976         newInstance(
4977             name,
4978             holders,
4979             tokens,
4980             supportNeeded,
4981             minAcceptanceQuorum,
4982             voteDuration
4983         );
4984     }
4985 
4986     function newToken(string name, string symbol) public returns (MiniMeToken token) {
4987         token = minimeFac.createCloneToken(
4988             MiniMeToken(address(0)),
4989             0,
4990             name,
4991             18,
4992             symbol,
4993             true
4994         );
4995         cacheToken(token, msg.sender);
4996     }
4997 
4998     function newInstance(
4999         string name,
5000         address[] holders,
5001         uint256[] tokens,
5002         uint64 supportNeeded,
5003         uint64 minAcceptanceQuorum,
5004         uint64 voteDuration
5005     )
5006         public
5007     {
5008         MiniMeToken token = popTokenCache(msg.sender);
5009         Kernel dao;
5010         ACL acl;
5011         Voting voting;
5012         (dao, acl, , , , voting) = createDAO(
5013             name,
5014             token,
5015             holders,
5016             tokens,
5017             uint256(-1)
5018         );
5019 
5020         voting.initialize(
5021             token,
5022             supportNeeded,
5023             minAcceptanceQuorum,
5024             voteDuration
5025         );
5026 
5027         // create vote permission
5028         acl.createPermission(acl.ANY_ENTITY(), voting, voting.CREATE_VOTES_ROLE(), voting);
5029 
5030         // burn support modification permission
5031         acl.createBurnedPermission(voting, voting.MODIFY_SUPPORT_ROLE());
5032 
5033         cleanupPermission(acl, voting, acl, acl.CREATE_PERMISSIONS_ROLE());
5034     }
5035 }