1 pragma solidity 0.4.24;
2 // File: contracts/lib/ens/AbstractENS.sol
3 interface AbstractENS {
4     function owner(bytes32 _node) public constant returns (address);
5     function resolver(bytes32 _node) public constant returns (address);
6     function ttl(bytes32 _node) public constant returns (uint64);
7     function setOwner(bytes32 _node, address _owner) public;
8     function setSubnodeOwner(bytes32 _node, bytes32 label, address _owner) public;
9     function setResolver(bytes32 _node, address _resolver) public;
10     function setTTL(bytes32 _node, uint64 _ttl) public;
11 
12     // Logged when the owner of a node assigns a new owner to a subnode.
13     event NewOwner(bytes32 indexed _node, bytes32 indexed _label, address _owner);
14 
15     // Logged when the owner of a node transfers ownership to a new account.
16     event Transfer(bytes32 indexed _node, address _owner);
17 
18     // Logged when the resolver for a node changes.
19     event NewResolver(bytes32 indexed _node, address _resolver);
20 
21     // Logged when the TTL of a node changes
22     event NewTTL(bytes32 indexed _node, uint64 _ttl);
23 }
24 // File: contracts/lib/ens/PublicResolver.sol
25 /**
26  * A simple resolver anyone can use; only allows the owner of a node to set its
27  * address.
28  */
29 contract PublicResolver {
30     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
31     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
32     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
33     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
34     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
35     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
36     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
37 
38     event AddrChanged(bytes32 indexed node, address a);
39     event ContentChanged(bytes32 indexed node, bytes32 hash);
40     event NameChanged(bytes32 indexed node, string name);
41     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
42     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
43     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
44 
45     struct PublicKey {
46         bytes32 x;
47         bytes32 y;
48     }
49 
50     struct Record {
51         address addr;
52         bytes32 content;
53         string name;
54         PublicKey pubkey;
55         mapping(string=>string) text;
56         mapping(uint256=>bytes) abis;
57     }
58 
59     AbstractENS ens;
60     mapping(bytes32=>Record) records;
61 
62     modifier only_owner(bytes32 node) {
63         if (ens.owner(node) != msg.sender) throw;
64         _;
65     }
66 
67     /**
68      * Constructor.
69      * @param ensAddr The ENS registrar contract.
70      */
71     function PublicResolver(AbstractENS ensAddr) public {
72         ens = ensAddr;
73     }
74 
75     /**
76      * Returns true if the resolver implements the interface specified by the provided hash.
77      * @param interfaceID The ID of the interface to check for.
78      * @return True if the contract implements the requested interface.
79      */
80     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
81         return interfaceID == ADDR_INTERFACE_ID ||
82                interfaceID == CONTENT_INTERFACE_ID ||
83                interfaceID == NAME_INTERFACE_ID ||
84                interfaceID == ABI_INTERFACE_ID ||
85                interfaceID == PUBKEY_INTERFACE_ID ||
86                interfaceID == TEXT_INTERFACE_ID ||
87                interfaceID == INTERFACE_META_ID;
88     }
89 
90     /**
91      * Returns the address associated with an ENS node.
92      * @param node The ENS node to query.
93      * @return The associated address.
94      */
95     function addr(bytes32 node) public constant returns (address ret) {
96         ret = records[node].addr;
97     }
98 
99     /**
100      * Sets the address associated with an ENS node.
101      * May only be called by the owner of that node in the ENS registry.
102      * @param node The node to update.
103      * @param addr The address to set.
104      */
105     function setAddr(bytes32 node, address addr) only_owner(node) public {
106         records[node].addr = addr;
107         AddrChanged(node, addr);
108     }
109 
110     /**
111      * Returns the content hash associated with an ENS node.
112      * Note that this resource type is not standardized, and will likely change
113      * in future to a resource type based on multihash.
114      * @param node The ENS node to query.
115      * @return The associated content hash.
116      */
117     function content(bytes32 node) public constant returns (bytes32 ret) {
118         ret = records[node].content;
119     }
120 
121     /**
122      * Sets the content hash associated with an ENS node.
123      * May only be called by the owner of that node in the ENS registry.
124      * Note that this resource type is not standardized, and will likely change
125      * in future to a resource type based on multihash.
126      * @param node The node to update.
127      * @param hash The content hash to set
128      */
129     function setContent(bytes32 node, bytes32 hash) only_owner(node) public {
130         records[node].content = hash;
131         ContentChanged(node, hash);
132     }
133 
134     /**
135      * Returns the name associated with an ENS node, for reverse records.
136      * Defined in EIP181.
137      * @param node The ENS node to query.
138      * @return The associated name.
139      */
140     function name(bytes32 node) public constant returns (string ret) {
141         ret = records[node].name;
142     }
143 
144     /**
145      * Sets the name associated with an ENS node, for reverse records.
146      * May only be called by the owner of that node in the ENS registry.
147      * @param node The node to update.
148      * @param name The name to set.
149      */
150     function setName(bytes32 node, string name) only_owner(node) public {
151         records[node].name = name;
152         NameChanged(node, name);
153     }
154 
155     /**
156      * Returns the ABI associated with an ENS node.
157      * Defined in EIP205.
158      * @param node The ENS node to query
159      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
160      * @return contentType The content type of the return value
161      * @return data The ABI data
162      */
163     function ABI(bytes32 node, uint256 contentTypes) public constant returns (uint256 contentType, bytes data) {
164         var record = records[node];
165         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
166             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
167                 data = record.abis[contentType];
168                 return;
169             }
170         }
171         contentType = 0;
172     }
173 
174     /**
175      * Sets the ABI associated with an ENS node.
176      * Nodes may have one ABI of each content type. To remove an ABI, set it to
177      * the empty string.
178      * @param node The node to update.
179      * @param contentType The content type of the ABI
180      * @param data The ABI data.
181      */
182     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) public {
183         // Content types must be powers of 2
184         if (((contentType - 1) & contentType) != 0) throw;
185 
186         records[node].abis[contentType] = data;
187         ABIChanged(node, contentType);
188     }
189 
190     /**
191      * Returns the SECP256k1 public key associated with an ENS node.
192      * Defined in EIP 619.
193      * @param node The ENS node to query
194      * @return x, y the X and Y coordinates of the curve point for the public key.
195      */
196     function pubkey(bytes32 node) public constant returns (bytes32 x, bytes32 y) {
197         return (records[node].pubkey.x, records[node].pubkey.y);
198     }
199 
200     /**
201      * Sets the SECP256k1 public key associated with an ENS node.
202      * @param node The ENS node to query
203      * @param x the X coordinate of the curve point for the public key.
204      * @param y the Y coordinate of the curve point for the public key.
205      */
206     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) public {
207         records[node].pubkey = PublicKey(x, y);
208         PubkeyChanged(node, x, y);
209     }
210 
211     /**
212      * Returns the text data associated with an ENS node and key.
213      * @param node The ENS node to query.
214      * @param key The text data key to query.
215      * @return The associated text data.
216      */
217     function text(bytes32 node, string key) public constant returns (string ret) {
218         ret = records[node].text[key];
219     }
220 
221     /**
222      * Sets the text data associated with an ENS node and key.
223      * May only be called by the owner of that node in the ENS registry.
224      * @param node The node to update.
225      * @param key The key to set.
226      * @param value The text data value to set.
227      */
228     function setText(bytes32 node, string key, string value) only_owner(node) public {
229         records[node].text[key] = value;
230         TextChanged(node, key, key);
231     }
232 }
233 // File: contracts/ens/ENSConstants.sol
234 /*
235  * SPDX-License-Identitifer:    MIT
236  */
237 
238 pragma solidity ^0.4.24;
239 
240 
241 contract ENSConstants {
242     /* Hardcoded constants to save gas
243     bytes32 internal constant ENS_ROOT = bytes32(0);
244     bytes32 internal constant ETH_TLD_LABEL = keccak256("eth");
245     bytes32 internal constant ETH_TLD_NODE = keccak256(abi.encodePacked(ENS_ROOT, ETH_TLD_LABEL));
246     bytes32 internal constant PUBLIC_RESOLVER_LABEL = keccak256("resolver");
247     bytes32 internal constant PUBLIC_RESOLVER_NODE = keccak256(abi.encodePacked(ETH_TLD_NODE, PUBLIC_RESOLVER_LABEL));
248     */
249     bytes32 internal constant ENS_ROOT = bytes32(0);
250     bytes32 internal constant ETH_TLD_LABEL = 0x4f5b812789fc606be1b3b16908db13fc7a9adf7ca72641f84d75b47069d3d7f0;
251     bytes32 internal constant ETH_TLD_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
252     bytes32 internal constant PUBLIC_RESOLVER_LABEL = 0x329539a1d23af1810c48a07fe7fc66a3b34fbc8b37e9b3cdb97bb88ceab7e4bf;
253     bytes32 internal constant PUBLIC_RESOLVER_NODE = 0xfdd5d5de6dd63db72bbc2d487944ba13bf775b50a80805fe6fcaba9b0fba88f5;
254 }
255 // File: contracts/common/UnstructuredStorage.sol
256 /*
257  * SPDX-License-Identitifer:    MIT
258  */
259 
260 pragma solidity ^0.4.24;
261 
262 
263 library UnstructuredStorage {
264     function getStorageBool(bytes32 position) internal view returns (bool data) {
265         assembly { data := sload(position) }
266     }
267 
268     function getStorageAddress(bytes32 position) internal view returns (address data) {
269         assembly { data := sload(position) }
270     }
271 
272     function getStorageBytes32(bytes32 position) internal view returns (bytes32 data) {
273         assembly { data := sload(position) }
274     }
275 
276     function getStorageUint256(bytes32 position) internal view returns (uint256 data) {
277         assembly { data := sload(position) }
278     }
279 
280     function setStorageBool(bytes32 position, bool data) internal {
281         assembly { sstore(position, data) }
282     }
283 
284     function setStorageAddress(bytes32 position, address data) internal {
285         assembly { sstore(position, data) }
286     }
287 
288     function setStorageBytes32(bytes32 position, bytes32 data) internal {
289         assembly { sstore(position, data) }
290     }
291 
292     function setStorageUint256(bytes32 position, uint256 data) internal {
293         assembly { sstore(position, data) }
294     }
295 }
296 // File: contracts/acl/IACL.sol
297 /*
298  * SPDX-License-Identitifer:    MIT
299  */
300 
301 pragma solidity ^0.4.24;
302 
303 
304 interface IACL {
305     function initialize(address permissionsCreator) external;
306 
307     // TODO: this should be external
308     // See https://github.com/ethereum/solidity/issues/4832
309     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
310 }
311 // File: contracts/common/IVaultRecoverable.sol
312 /*
313  * SPDX-License-Identitifer:    MIT
314  */
315 
316 pragma solidity ^0.4.24;
317 
318 
319 interface IVaultRecoverable {
320     function transferToVault(address token) external;
321 
322     function allowRecoverability(address token) external view returns (bool);
323     function getRecoveryVault() external view returns (address);
324 }
325 // File: contracts/kernel/IKernel.sol
326 /*
327  * SPDX-License-Identitifer:    MIT
328  */
329 
330 pragma solidity ^0.4.24;
331 
332 
333 
334 
335 // This should be an interface, but interfaces can't inherit yet :(
336 contract IKernel is IVaultRecoverable {
337     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
338 
339     function acl() public view returns (IACL);
340     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
341 
342     function setApp(bytes32 namespace, bytes32 appId, address app) public;
343     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
344 }
345 // File: contracts/apps/AppStorage.sol
346 /*
347  * SPDX-License-Identitifer:    MIT
348  */
349 
350 pragma solidity ^0.4.24;
351 
352 
353 
354 
355 contract AppStorage {
356     using UnstructuredStorage for bytes32;
357 
358     /* Hardcoded constants to save gas
359     bytes32 internal constant KERNEL_POSITION = keccak256("aragonOS.appStorage.kernel");
360     bytes32 internal constant APP_ID_POSITION = keccak256("aragonOS.appStorage.appId");
361     */
362     bytes32 internal constant KERNEL_POSITION = 0x4172f0f7d2289153072b0a6ca36959e0cbe2efc3afe50fc81636caa96338137b;
363     bytes32 internal constant APP_ID_POSITION = 0xd625496217aa6a3453eecb9c3489dc5a53e6c67b444329ea2b2cbc9ff547639b;
364 
365     function kernel() public view returns (IKernel) {
366         return IKernel(KERNEL_POSITION.getStorageAddress());
367     }
368 
369     function appId() public view returns (bytes32) {
370         return APP_ID_POSITION.getStorageBytes32();
371     }
372 
373     function setKernel(IKernel _kernel) internal {
374         KERNEL_POSITION.setStorageAddress(address(_kernel));
375     }
376 
377     function setAppId(bytes32 _appId) internal {
378         APP_ID_POSITION.setStorageBytes32(_appId);
379     }
380 }
381 // File: contracts/common/Uint256Helpers.sol
382 library Uint256Helpers {
383     uint256 private constant MAX_UINT64 = uint64(-1);
384 
385     string private constant ERROR_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
386 
387     function toUint64(uint256 a) internal pure returns (uint64) {
388         require(a <= MAX_UINT64, ERROR_NUMBER_TOO_BIG);
389         return uint64(a);
390     }
391 }
392 // File: contracts/common/TimeHelpers.sol
393 /*
394  * SPDX-License-Identitifer:    MIT
395  */
396 
397 pragma solidity ^0.4.24;
398 
399 
400 
401 contract TimeHelpers {
402     using Uint256Helpers for uint256;
403 
404     /**
405     * @dev Returns the current block number.
406     *      Using a function rather than `block.number` allows us to easily mock the block number in
407     *      tests.
408     */
409     function getBlockNumber() internal view returns (uint256) {
410         return block.number;
411     }
412 
413     /**
414     * @dev Returns the current block number, converted to uint64.
415     *      Using a function rather than `block.number` allows us to easily mock the block number in
416     *      tests.
417     */
418     function getBlockNumber64() internal view returns (uint64) {
419         return getBlockNumber().toUint64();
420     }
421 
422     /**
423     * @dev Returns the current timestamp.
424     *      Using a function rather than `block.timestamp` allows us to easily mock it in
425     *      tests.
426     */
427     function getTimestamp() internal view returns (uint256) {
428         return block.timestamp; // solium-disable-line security/no-block-members
429     }
430 
431     /**
432     * @dev Returns the current timestamp, converted to uint64.
433     *      Using a function rather than `block.timestamp` allows us to easily mock it in
434     *      tests.
435     */
436     function getTimestamp64() internal view returns (uint64) {
437         return getTimestamp().toUint64();
438     }
439 }
440 // File: contracts/common/Initializable.sol
441 /*
442  * SPDX-License-Identitifer:    MIT
443  */
444 
445 pragma solidity ^0.4.24;
446 
447 
448 
449 
450 contract Initializable is TimeHelpers {
451     using UnstructuredStorage for bytes32;
452 
453     // keccak256("aragonOS.initializable.initializationBlock")
454     bytes32 internal constant INITIALIZATION_BLOCK_POSITION = 0xebb05b386a8d34882b8711d156f463690983dc47815980fb82aeeff1aa43579e;
455 
456     string private constant ERROR_ALREADY_INITIALIZED = "INIT_ALREADY_INITIALIZED";
457     string private constant ERROR_NOT_INITIALIZED = "INIT_NOT_INITIALIZED";
458 
459     modifier onlyInit {
460         require(getInitializationBlock() == 0, ERROR_ALREADY_INITIALIZED);
461         _;
462     }
463 
464     modifier isInitialized {
465         require(hasInitialized(), ERROR_NOT_INITIALIZED);
466         _;
467     }
468 
469     /**
470     * @return Block number in which the contract was initialized
471     */
472     function getInitializationBlock() public view returns (uint256) {
473         return INITIALIZATION_BLOCK_POSITION.getStorageUint256();
474     }
475 
476     /**
477     * @return Whether the contract has been initialized by the time of the current block
478     */
479     function hasInitialized() public view returns (bool) {
480         uint256 initializationBlock = getInitializationBlock();
481         return initializationBlock != 0 && getBlockNumber() >= initializationBlock;
482     }
483 
484     /**
485     * @dev Function to be called by top level contract after initialization has finished.
486     */
487     function initialized() internal onlyInit {
488         INITIALIZATION_BLOCK_POSITION.setStorageUint256(getBlockNumber());
489     }
490 
491     /**
492     * @dev Function to be called by top level contract after initialization to enable the contract
493     *      at a future block number rather than immediately.
494     */
495     function initializedAt(uint256 _blockNumber) internal onlyInit {
496         INITIALIZATION_BLOCK_POSITION.setStorageUint256(_blockNumber);
497     }
498 }
499 // File: contracts/common/Petrifiable.sol
500 /*
501  * SPDX-License-Identitifer:    MIT
502  */
503 
504 pragma solidity ^0.4.24;
505 
506 
507 
508 contract Petrifiable is Initializable {
509     // Use block UINT256_MAX (which should be never) as the initializable date
510     uint256 internal constant PETRIFIED_BLOCK = uint256(-1);
511 
512     function isPetrified() public view returns (bool) {
513         return getInitializationBlock() == PETRIFIED_BLOCK;
514     }
515 
516     /**
517     * @dev Function to be called by top level contract to prevent being initialized.
518     *      Useful for freezing base contracts when they're used behind proxies.
519     */
520     function petrify() internal onlyInit {
521         initializedAt(PETRIFIED_BLOCK);
522     }
523 }
524 // File: contracts/common/Autopetrified.sol
525 /*
526  * SPDX-License-Identitifer:    MIT
527  */
528 
529 pragma solidity ^0.4.24;
530 
531 
532 
533 contract Autopetrified is Petrifiable {
534     constructor() public {
535         // Immediately petrify base (non-proxy) instances of inherited contracts on deploy.
536         // This renders them uninitializable (and unusable without a proxy).
537         petrify();
538     }
539 }
540 // File: contracts/lib/token/ERC20.sol
541 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/a9f910d34f0ab33a1ae5e714f69f9596a02b4d91/contracts/token/ERC20/ERC20.sol
542 
543 pragma solidity ^0.4.24;
544 
545 
546 /**
547  * @title ERC20 interface
548  * @dev see https://github.com/ethereum/EIPs/issues/20
549  */
550 contract ERC20 {
551     function totalSupply() public view returns (uint256);
552 
553     function balanceOf(address _who) public view returns (uint256);
554 
555     function allowance(address _owner, address _spender)
556         public view returns (uint256);
557 
558     function transfer(address _to, uint256 _value) public returns (bool);
559 
560     function approve(address _spender, uint256 _value)
561         public returns (bool);
562 
563     function transferFrom(address _from, address _to, uint256 _value)
564         public returns (bool);
565 
566     event Transfer(
567         address indexed from,
568         address indexed to,
569         uint256 value
570     );
571 
572     event Approval(
573         address indexed owner,
574         address indexed spender,
575         uint256 value
576     );
577 }
578 // File: contracts/common/EtherTokenConstant.sol
579 /*
580  * SPDX-License-Identitifer:    MIT
581  */
582 
583 pragma solidity ^0.4.24;
584 
585 
586 // aragonOS and aragon-apps rely on address(0) to denote native ETH, in
587 // contracts where both tokens and ETH are accepted
588 contract EtherTokenConstant {
589     address internal constant ETH = address(0);
590 }
591 // File: contracts/common/IsContract.sol
592 /*
593  * SPDX-License-Identitifer:    MIT
594  */
595 
596 pragma solidity ^0.4.24;
597 
598 
599 contract IsContract {
600     /*
601     * NOTE: this should NEVER be used for authentication
602     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
603     *
604     * This is only intended to be used as a sanity check that an address is actually a contract,
605     * RATHER THAN an address not being a contract.
606     */
607     function isContract(address _target) internal view returns (bool) {
608         if (_target == address(0)) {
609             return false;
610         }
611 
612         uint256 size;
613         assembly { size := extcodesize(_target) }
614         return size > 0;
615     }
616 }
617 // File: contracts/common/VaultRecoverable.sol
618 /*
619  * SPDX-License-Identitifer:    MIT
620  */
621 
622 pragma solidity ^0.4.24;
623 
624 
625 
626 
627 
628 
629 contract VaultRecoverable is IVaultRecoverable, EtherTokenConstant, IsContract {
630     string private constant ERROR_DISALLOWED = "RECOVER_DISALLOWED";
631     string private constant ERROR_VAULT_NOT_CONTRACT = "RECOVER_VAULT_NOT_CONTRACT";
632 
633     /**
634      * @notice Send funds to recovery Vault. This contract should never receive funds,
635      *         but in case it does, this function allows one to recover them.
636      * @param _token Token balance to be sent to recovery vault.
637      */
638     function transferToVault(address _token) external {
639         require(allowRecoverability(_token), ERROR_DISALLOWED);
640         address vault = getRecoveryVault();
641         require(isContract(vault), ERROR_VAULT_NOT_CONTRACT);
642 
643         if (_token == ETH) {
644             vault.transfer(address(this).balance);
645         } else {
646             uint256 amount = ERC20(_token).balanceOf(this);
647             ERC20(_token).transfer(vault, amount);
648         }
649     }
650 
651     /**
652     * @dev By default deriving from AragonApp makes it recoverable
653     * @param token Token address that would be recovered
654     * @return bool whether the app allows the recovery
655     */
656     function allowRecoverability(address token) public view returns (bool) {
657         return true;
658     }
659 
660     // Cast non-implemented interface to be public so we can use it internally
661     function getRecoveryVault() public view returns (address);
662 }
663 // File: contracts/evmscript/IEVMScriptExecutor.sol
664 /*
665  * SPDX-License-Identitifer:    MIT
666  */
667 
668 pragma solidity ^0.4.24;
669 
670 
671 interface IEVMScriptExecutor {
672     function execScript(bytes script, bytes input, address[] blacklist) external returns (bytes);
673     function executorType() external pure returns (bytes32);
674 }
675 // File: contracts/evmscript/IEVMScriptRegistry.sol
676 /*
677  * SPDX-License-Identitifer:    MIT
678  */
679 
680 pragma solidity ^0.4.24;
681 
682 
683 
684 contract EVMScriptRegistryConstants {
685     /* Hardcoded constants to save gas
686     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = apmNamehash("evmreg");
687     */
688     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = 0xddbcfd564f642ab5627cf68b9b7d374fb4f8a36e941a75d89c87998cef03bd61;
689 }
690 
691 
692 interface IEVMScriptRegistry {
693     function addScriptExecutor(IEVMScriptExecutor executor) external returns (uint id);
694     function disableScriptExecutor(uint256 executorId) external;
695 
696     // TODO: this should be external
697     // See https://github.com/ethereum/solidity/issues/4832
698     function getScriptExecutor(bytes script) public view returns (IEVMScriptExecutor);
699 }
700 // File: contracts/kernel/KernelConstants.sol
701 /*
702  * SPDX-License-Identitifer:    MIT
703  */
704 
705 pragma solidity ^0.4.24;
706 
707 
708 contract KernelAppIds {
709     /* Hardcoded constants to save gas
710     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
711     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
712     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
713     */
714     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
715     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
716     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
717 }
718 
719 
720 contract KernelNamespaceConstants {
721     /* Hardcoded constants to save gas
722     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
723     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
724     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
725     */
726     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
727     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
728     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
729 }
730 // File: contracts/evmscript/EVMScriptRunner.sol
731 /*
732  * SPDX-License-Identitifer:    MIT
733  */
734 
735 pragma solidity ^0.4.24;
736 
737 
738 
739 
740 
741 
742 
743 contract EVMScriptRunner is AppStorage, Initializable, EVMScriptRegistryConstants, KernelNamespaceConstants {
744     string private constant ERROR_EXECUTOR_UNAVAILABLE = "EVMRUN_EXECUTOR_UNAVAILABLE";
745     string private constant ERROR_EXECUTION_REVERTED = "EVMRUN_EXECUTION_REVERTED";
746     string private constant ERROR_PROTECTED_STATE_MODIFIED = "EVMRUN_PROTECTED_STATE_MODIFIED";
747 
748     event ScriptResult(address indexed executor, bytes script, bytes input, bytes returnData);
749 
750     function getEVMScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
751         return IEVMScriptExecutor(getEVMScriptRegistry().getScriptExecutor(_script));
752     }
753 
754     function getEVMScriptRegistry() public view returns (IEVMScriptRegistry) {
755         address registryAddr = kernel().getApp(KERNEL_APP_ADDR_NAMESPACE, EVMSCRIPT_REGISTRY_APP_ID);
756         return IEVMScriptRegistry(registryAddr);
757     }
758 
759     function runScript(bytes _script, bytes _input, address[] _blacklist)
760         internal
761         isInitialized
762         protectState
763         returns (bytes)
764     {
765         // TODO: Too much data flying around, maybe extracting spec id here is cheaper
766         IEVMScriptExecutor executor = getEVMScriptExecutor(_script);
767         require(address(executor) != address(0), ERROR_EXECUTOR_UNAVAILABLE);
768 
769         bytes4 sig = executor.execScript.selector;
770         bytes memory data = abi.encodeWithSelector(sig, _script, _input, _blacklist);
771         require(address(executor).delegatecall(data), ERROR_EXECUTION_REVERTED);
772 
773         bytes memory output = returnedDataDecoded();
774 
775         emit ScriptResult(address(executor), _script, _input, output);
776 
777         return output;
778     }
779 
780     /**
781     * @dev copies and returns last's call data. Needs to ABI decode first
782     */
783     function returnedDataDecoded() internal pure returns (bytes ret) {
784         assembly {
785             let size := returndatasize
786             switch size
787             case 0 {}
788             default {
789                 ret := mload(0x40) // free mem ptr get
790                 mstore(0x40, add(ret, add(size, 0x20))) // free mem ptr set
791                 returndatacopy(ret, 0x20, sub(size, 0x20)) // copy return data
792             }
793         }
794         return ret;
795     }
796 
797     modifier protectState {
798         address preKernel = address(kernel());
799         bytes32 preAppId = appId();
800         _; // exec
801         require(address(kernel()) == preKernel, ERROR_PROTECTED_STATE_MODIFIED);
802         require(appId() == preAppId, ERROR_PROTECTED_STATE_MODIFIED);
803     }
804 }
805 // File: contracts/acl/ACLSyntaxSugar.sol
806 /*
807  * SPDX-License-Identitifer:    MIT
808  */
809 
810 pragma solidity ^0.4.24;
811 
812 
813 contract ACLSyntaxSugar {
814     function arr() internal pure returns (uint256[]) {}
815 
816     function arr(bytes32 _a) internal pure returns (uint256[] r) {
817         return arr(uint256(_a));
818     }
819 
820     function arr(bytes32 _a, bytes32 _b) internal pure returns (uint256[] r) {
821         return arr(uint256(_a), uint256(_b));
822     }
823 
824     function arr(address _a) internal pure returns (uint256[] r) {
825         return arr(uint256(_a));
826     }
827 
828     function arr(address _a, address _b) internal pure returns (uint256[] r) {
829         return arr(uint256(_a), uint256(_b));
830     }
831 
832     function arr(address _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
833         return arr(uint256(_a), _b, _c);
834     }
835 
836     function arr(address _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
837         return arr(uint256(_a), _b, _c, _d);
838     }
839 
840     function arr(address _a, uint256 _b) internal pure returns (uint256[] r) {
841         return arr(uint256(_a), uint256(_b));
842     }
843 
844     function arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
845         return arr(uint256(_a), uint256(_b), _c, _d, _e);
846     }
847 
848     function arr(address _a, address _b, address _c) internal pure returns (uint256[] r) {
849         return arr(uint256(_a), uint256(_b), uint256(_c));
850     }
851 
852     function arr(address _a, address _b, uint256 _c) internal pure returns (uint256[] r) {
853         return arr(uint256(_a), uint256(_b), uint256(_c));
854     }
855 
856     function arr(uint256 _a) internal pure returns (uint256[] r) {
857         r = new uint256[](1);
858         r[0] = _a;
859     }
860 
861     function arr(uint256 _a, uint256 _b) internal pure returns (uint256[] r) {
862         r = new uint256[](2);
863         r[0] = _a;
864         r[1] = _b;
865     }
866 
867     function arr(uint256 _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
868         r = new uint256[](3);
869         r[0] = _a;
870         r[1] = _b;
871         r[2] = _c;
872     }
873 
874     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
875         r = new uint256[](4);
876         r[0] = _a;
877         r[1] = _b;
878         r[2] = _c;
879         r[3] = _d;
880     }
881 
882     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
883         r = new uint256[](5);
884         r[0] = _a;
885         r[1] = _b;
886         r[2] = _c;
887         r[3] = _d;
888         r[4] = _e;
889     }
890 }
891 
892 
893 contract ACLHelpers {
894     function decodeParamOp(uint256 _x) internal pure returns (uint8 b) {
895         return uint8(_x >> (8 * 30));
896     }
897 
898     function decodeParamId(uint256 _x) internal pure returns (uint8 b) {
899         return uint8(_x >> (8 * 31));
900     }
901 
902     function decodeParamsList(uint256 _x) internal pure returns (uint32 a, uint32 b, uint32 c) {
903         a = uint32(_x);
904         b = uint32(_x >> (8 * 4));
905         c = uint32(_x >> (8 * 8));
906     }
907 }
908 // File: contracts/apps/AragonApp.sol
909 /*
910  * SPDX-License-Identitifer:    MIT
911  */
912 
913 pragma solidity ^0.4.24;
914 
915 
916 
917 
918 
919 
920 
921 // Contracts inheriting from AragonApp are, by default, immediately petrified upon deployment so
922 // that they can never be initialized.
923 // Unless overriden, this behaviour enforces those contracts to be usable only behind an AppProxy.
924 // ACLSyntaxSugar and EVMScriptRunner are not directly used by this contract, but are included so
925 // that they are automatically usable by subclassing contracts
926 contract AragonApp is AppStorage, Autopetrified, VaultRecoverable, EVMScriptRunner, ACLSyntaxSugar {
927     string private constant ERROR_AUTH_FAILED = "APP_AUTH_FAILED";
928 
929     modifier auth(bytes32 _role) {
930         require(canPerform(msg.sender, _role, new uint256[](0)), ERROR_AUTH_FAILED);
931         _;
932     }
933 
934     modifier authP(bytes32 _role, uint256[] _params) {
935         require(canPerform(msg.sender, _role, _params), ERROR_AUTH_FAILED);
936         _;
937     }
938 
939     /**
940     * @dev Check whether an action can be performed by a sender for a particular role on this app
941     * @param _sender Sender of the call
942     * @param _role Role on this app
943     * @param _params Permission params for the role
944     * @return Boolean indicating whether the sender has the permissions to perform the action.
945     *         Always returns false if the app hasn't been initialized yet.
946     */
947     function canPerform(address _sender, bytes32 _role, uint256[] _params) public view returns (bool) {
948         if (!hasInitialized()) {
949             return false;
950         }
951 
952         IKernel linkedKernel = kernel();
953         if (address(linkedKernel) == address(0)) {
954             return false;
955         }
956 
957         // Force cast the uint256[] into a bytes array, by overwriting its length
958         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
959         // with _params and a new length, and _params becomes invalid from this point forward
960         bytes memory how;
961         uint256 byteLength = _params.length * 32;
962         assembly {
963             how := _params
964             mstore(how, byteLength)
965         }
966         return linkedKernel.hasPermission(_sender, address(this), _role, how);
967     }
968 
969     /**
970     * @dev Get the recovery vault for the app
971     * @return Recovery vault address for the app
972     */
973     function getRecoveryVault() public view returns (address) {
974         // Funds recovery via a vault is only available when used with a kernel
975         return kernel().getRecoveryVault(); // if kernel is not set, it will revert
976     }
977 }
978 // File: contracts/ens/ENSSubdomainRegistrar.sol
979 /* solium-disable function-order */
980 // Allow public initialize() to be first
981 contract ENSSubdomainRegistrar is AragonApp, ENSConstants {
982     /* Hardcoded constants to save gas
983     bytes32 public constant CREATE_NAME_ROLE = keccak256("CREATE_NAME_ROLE");
984     bytes32 public constant DELETE_NAME_ROLE = keccak256("DELETE_NAME_ROLE");
985     bytes32 public constant POINT_ROOTNODE_ROLE = keccak256("POINT_ROOTNODE_ROLE");
986     */
987     bytes32 public constant CREATE_NAME_ROLE = 0xf86bc2abe0919ab91ef714b2bec7c148d94f61fdb069b91a6cfe9ecdee1799ba;
988     bytes32 public constant DELETE_NAME_ROLE = 0x03d74c8724218ad4a99859bcb2d846d39999449fd18013dd8d69096627e68622;
989     bytes32 public constant POINT_ROOTNODE_ROLE = 0x9ecd0e7bddb2e241c41b595a436c4ea4fd33c9fa0caa8056acf084fc3aa3bfbe;
990 
991     string private constant ERROR_NO_NODE_OWNERSHIP = "ENSSUB_NO_NODE_OWNERSHIP";
992     string private constant ERROR_NAME_EXISTS = "ENSSUB_NAME_EXISTS";
993     string private constant ERROR_NAME_DOESNT_EXIST = "ENSSUB_DOESNT_EXIST";
994 
995     AbstractENS public ens;
996     bytes32 public rootNode;
997 
998     event NewName(bytes32 indexed node, bytes32 indexed label);
999     event DeleteName(bytes32 indexed node, bytes32 indexed label);
1000 
1001     function initialize(AbstractENS _ens, bytes32 _rootNode) public onlyInit {
1002         initialized();
1003 
1004         // We need ownership to create subnodes
1005         require(_ens.owner(_rootNode) == address(this), ERROR_NO_NODE_OWNERSHIP);
1006 
1007         ens = _ens;
1008         rootNode = _rootNode;
1009     }
1010 
1011     function createName(bytes32 _label, address _owner) external auth(CREATE_NAME_ROLE) returns (bytes32 node) {
1012         return _createName(_label, _owner);
1013     }
1014 
1015     function createNameAndPoint(bytes32 _label, address _target) external auth(CREATE_NAME_ROLE) returns (bytes32 node) {
1016         node = _createName(_label, this);
1017         _pointToResolverAndResolve(node, _target);
1018     }
1019 
1020     function deleteName(bytes32 _label) external auth(DELETE_NAME_ROLE) {
1021         bytes32 node = getNodeForLabel(_label);
1022 
1023         address currentOwner = ens.owner(node);
1024 
1025         require(currentOwner != address(0), ERROR_NAME_DOESNT_EXIST); // fail if deleting unset name
1026 
1027         if (currentOwner != address(this)) { // needs to reclaim ownership so it can set resolver
1028             ens.setSubnodeOwner(rootNode, _label, this);
1029         }
1030 
1031         ens.setResolver(node, address(0)); // remove resolver so it ends resolving
1032         ens.setOwner(node, address(0));
1033 
1034         emit DeleteName(node, _label);
1035     }
1036 
1037     function pointRootNode(address _target) external auth(POINT_ROOTNODE_ROLE) {
1038         _pointToResolverAndResolve(rootNode, _target);
1039     }
1040 
1041     function _createName(bytes32 _label, address _owner) internal returns (bytes32 node) {
1042         node = getNodeForLabel(_label);
1043         require(ens.owner(node) == address(0), ERROR_NAME_EXISTS); // avoid name reset
1044 
1045         ens.setSubnodeOwner(rootNode, _label, _owner);
1046 
1047         emit NewName(node, _label);
1048 
1049         return node;
1050     }
1051 
1052     function _pointToResolverAndResolve(bytes32 _node, address _target) internal {
1053         address publicResolver = getAddr(PUBLIC_RESOLVER_NODE);
1054         ens.setResolver(_node, publicResolver);
1055 
1056         PublicResolver(publicResolver).setAddr(_node, _target);
1057     }
1058 
1059     function getAddr(bytes32 node) internal view returns (address) {
1060         address resolver = ens.resolver(node);
1061         return PublicResolver(resolver).addr(node);
1062     }
1063 
1064     function getNodeForLabel(bytes32 _label) internal view returns (bytes32) {
1065         return keccak256(abi.encodePacked(rootNode, _label));
1066     }
1067 }
1068 // File: contracts/lib/misc/ERCProxy.sol
1069 /*
1070  * SPDX-License-Identitifer:    MIT
1071  */
1072 
1073 pragma solidity ^0.4.24;
1074 
1075 
1076 contract ERCProxy {
1077     uint256 internal constant FORWARDING = 1;
1078     uint256 internal constant UPGRADEABLE = 2;
1079 
1080     function proxyType() public pure returns (uint256 proxyTypeId);
1081     function implementation() public view returns (address codeAddr);
1082 }
1083 // File: contracts/common/DelegateProxy.sol
1084 contract DelegateProxy is ERCProxy, IsContract {
1085     uint256 internal constant FWD_GAS_LIMIT = 10000;
1086 
1087     /**
1088     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
1089     * @param _dst Destination address to perform the delegatecall
1090     * @param _calldata Calldata for the delegatecall
1091     */
1092     function delegatedFwd(address _dst, bytes _calldata) internal {
1093         require(isContract(_dst));
1094         uint256 fwdGasLimit = FWD_GAS_LIMIT;
1095 
1096         assembly {
1097             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
1098             let size := returndatasize
1099             let ptr := mload(0x40)
1100             returndatacopy(ptr, 0, size)
1101 
1102             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
1103             // if the call returned error data, forward it
1104             switch result case 0 { revert(ptr, size) }
1105             default { return(ptr, size) }
1106         }
1107     }
1108 }
1109 // File: contracts/common/DepositableStorage.sol
1110 contract DepositableStorage {
1111     using UnstructuredStorage for bytes32;
1112 
1113     // keccak256("aragonOS.depositableStorage.depositable")
1114     bytes32 internal constant DEPOSITABLE_POSITION = 0x665fd576fbbe6f247aff98f5c94a561e3f71ec2d3c988d56f12d342396c50cea;
1115 
1116     function isDepositable() public view returns (bool) {
1117         return DEPOSITABLE_POSITION.getStorageBool();
1118     }
1119 
1120     function setDepositable(bool _depositable) internal {
1121         DEPOSITABLE_POSITION.setStorageBool(_depositable);
1122     }
1123 }
1124 // File: contracts/common/DepositableDelegateProxy.sol
1125 contract DepositableDelegateProxy is DepositableStorage, DelegateProxy {
1126     event ProxyDeposit(address sender, uint256 value);
1127 
1128     function () external payable {
1129         // send / transfer
1130         if (gasleft() < FWD_GAS_LIMIT) {
1131             require(msg.value > 0 && msg.data.length == 0);
1132             require(isDepositable());
1133             emit ProxyDeposit(msg.sender, msg.value);
1134         } else { // all calls except for send or transfer
1135             address target = implementation();
1136             delegatedFwd(target, msg.data);
1137         }
1138     }
1139 }
1140 // File: contracts/apps/AppProxyBase.sol
1141 contract AppProxyBase is AppStorage, DepositableDelegateProxy, KernelNamespaceConstants {
1142     /**
1143     * @dev Initialize AppProxy
1144     * @param _kernel Reference to organization kernel for the app
1145     * @param _appId Identifier for app
1146     * @param _initializePayload Payload for call to be made after setup to initialize
1147     */
1148     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public {
1149         setKernel(_kernel);
1150         setAppId(_appId);
1151 
1152         // Implicit check that kernel is actually a Kernel
1153         // The EVM doesn't actually provide a way for us to make sure, but we can force a revert to
1154         // occur if the kernel is set to 0x0 or a non-code address when we try to call a method on
1155         // it.
1156         address appCode = getAppBase(_appId);
1157 
1158         // If initialize payload is provided, it will be executed
1159         if (_initializePayload.length > 0) {
1160             require(isContract(appCode));
1161             // Cannot make delegatecall as a delegateproxy.delegatedFwd as it
1162             // returns ending execution context and halts contract deployment
1163             require(appCode.delegatecall(_initializePayload));
1164         }
1165     }
1166 
1167     function getAppBase(bytes32 _appId) internal view returns (address) {
1168         return kernel().getApp(KERNEL_APP_BASES_NAMESPACE, _appId);
1169     }
1170 }
1171 // File: contracts/apps/AppProxyUpgradeable.sol
1172 contract AppProxyUpgradeable is AppProxyBase {
1173     /**
1174     * @dev Initialize AppProxyUpgradeable (makes it an upgradeable Aragon app)
1175     * @param _kernel Reference to organization kernel for the app
1176     * @param _appId Identifier for app
1177     * @param _initializePayload Payload for call to be made after setup to initialize
1178     */
1179     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
1180         AppProxyBase(_kernel, _appId, _initializePayload)
1181         public // solium-disable-line visibility-first
1182     {
1183 
1184     }
1185 
1186     /**
1187      * @dev ERC897, the address the proxy would delegate calls to
1188      */
1189     function implementation() public view returns (address) {
1190         return getAppBase(appId());
1191     }
1192 
1193     /**
1194      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
1195      */
1196     function proxyType() public pure returns (uint256 proxyTypeId) {
1197         return UPGRADEABLE;
1198     }
1199 }
1200 // File: contracts/apps/AppProxyPinned.sol
1201 contract AppProxyPinned is IsContract, AppProxyBase {
1202     using UnstructuredStorage for bytes32;
1203 
1204     // keccak256("aragonOS.appStorage.pinnedCode")
1205     bytes32 internal constant PINNED_CODE_POSITION = 0xdee64df20d65e53d7f51cb6ab6d921a0a6a638a91e942e1d8d02df28e31c038e;
1206 
1207     /**
1208     * @dev Initialize AppProxyPinned (makes it an un-upgradeable Aragon app)
1209     * @param _kernel Reference to organization kernel for the app
1210     * @param _appId Identifier for app
1211     * @param _initializePayload Payload for call to be made after setup to initialize
1212     */
1213     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
1214         AppProxyBase(_kernel, _appId, _initializePayload)
1215         public // solium-disable-line visibility-first
1216     {
1217         setPinnedCode(getAppBase(_appId));
1218         require(isContract(pinnedCode()));
1219     }
1220 
1221     /**
1222      * @dev ERC897, the address the proxy would delegate calls to
1223      */
1224     function implementation() public view returns (address) {
1225         return pinnedCode();
1226     }
1227 
1228     /**
1229      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
1230      */
1231     function proxyType() public pure returns (uint256 proxyTypeId) {
1232         return FORWARDING;
1233     }
1234 
1235     function setPinnedCode(address _pinnedCode) internal {
1236         PINNED_CODE_POSITION.setStorageAddress(_pinnedCode);
1237     }
1238 
1239     function pinnedCode() internal view returns (address) {
1240         return PINNED_CODE_POSITION.getStorageAddress();
1241     }
1242 }
1243 // File: contracts/factory/AppProxyFactory.sol
1244 contract AppProxyFactory {
1245     event NewAppProxy(address proxy, bool isUpgradeable, bytes32 appId);
1246 
1247     function newAppProxy(IKernel _kernel, bytes32 _appId) public returns (AppProxyUpgradeable) {
1248         return newAppProxy(_kernel, _appId, new bytes(0));
1249     }
1250 
1251     function newAppProxy(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyUpgradeable) {
1252         AppProxyUpgradeable proxy = new AppProxyUpgradeable(_kernel, _appId, _initializePayload);
1253         emit NewAppProxy(address(proxy), true, _appId);
1254         return proxy;
1255     }
1256 
1257     function newAppProxyPinned(IKernel _kernel, bytes32 _appId) public returns (AppProxyPinned) {
1258         return newAppProxyPinned(_kernel, _appId, new bytes(0));
1259     }
1260 
1261     function newAppProxyPinned(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyPinned) {
1262         AppProxyPinned proxy = new AppProxyPinned(_kernel, _appId, _initializePayload);
1263         emit NewAppProxy(address(proxy), false, _appId);
1264         return proxy;
1265     }
1266 }
1267 // File: contracts/acl/IACLOracle.sol
1268 /*
1269  * SPDX-License-Identitifer:    MIT
1270  */
1271 
1272 pragma solidity ^0.4.24;
1273 
1274 
1275 interface IACLOracle {
1276     function canPerform(address who, address where, bytes32 what, uint256[] how) external view returns (bool);
1277 }
1278 // File: contracts/acl/ACL.sol
1279 /* solium-disable function-order */
1280 // Allow public initialize() to be first
1281 contract ACL is IACL, TimeHelpers, AragonApp, ACLHelpers {
1282     /* Hardcoded constants to save gas
1283     bytes32 public constant CREATE_PERMISSIONS_ROLE = keccak256("CREATE_PERMISSIONS_ROLE");
1284     */
1285     bytes32 public constant CREATE_PERMISSIONS_ROLE = 0x0b719b33c83b8e5d300c521cb8b54ae9bd933996a14bef8c2f4e0285d2d2400a;
1286 
1287     enum Op { NONE, EQ, NEQ, GT, LT, GTE, LTE, RET, NOT, AND, OR, XOR, IF_ELSE } // op types
1288 
1289     struct Param {
1290         uint8 id;
1291         uint8 op;
1292         uint240 value; // even though value is an uint240 it can store addresses
1293         // in the case of 32 byte hashes losing 2 bytes precision isn't a huge deal
1294         // op and id take less than 1 byte each so it can be kept in 1 sstore
1295     }
1296 
1297     uint8 internal constant BLOCK_NUMBER_PARAM_ID = 200;
1298     uint8 internal constant TIMESTAMP_PARAM_ID    = 201;
1299     // 202 is unused
1300     uint8 internal constant ORACLE_PARAM_ID       = 203;
1301     uint8 internal constant LOGIC_OP_PARAM_ID     = 204;
1302     uint8 internal constant PARAM_VALUE_PARAM_ID  = 205;
1303     // TODO: Add execution times param type?
1304 
1305     /* Hardcoded constant to save gas
1306     bytes32 public constant EMPTY_PARAM_HASH = keccak256(uint256(0));
1307     */
1308     bytes32 public constant EMPTY_PARAM_HASH = 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563;
1309     bytes32 public constant NO_PERMISSION = bytes32(0);
1310     address public constant ANY_ENTITY = address(-1);
1311     address public constant BURN_ENTITY = address(1); // address(0) is already used as "no permission manager"
1312 
1313     uint256 internal constant ORACLE_CHECK_GAS = 30000;
1314 
1315     string private constant ERROR_AUTH_INIT_KERNEL = "ACL_AUTH_INIT_KERNEL";
1316     string private constant ERROR_AUTH_NO_MANAGER = "ACL_AUTH_NO_MANAGER";
1317     string private constant ERROR_EXISTENT_MANAGER = "ACL_EXISTENT_MANAGER";
1318 
1319     // Whether someone has a permission
1320     mapping (bytes32 => bytes32) internal permissions; // permissions hash => params hash
1321     mapping (bytes32 => Param[]) internal permissionParams; // params hash => params
1322 
1323     // Who is the manager of a permission
1324     mapping (bytes32 => address) internal permissionManager;
1325 
1326     event SetPermission(address indexed entity, address indexed app, bytes32 indexed role, bool allowed);
1327     event SetPermissionParams(address indexed entity, address indexed app, bytes32 indexed role, bytes32 paramsHash);
1328     event ChangePermissionManager(address indexed app, bytes32 indexed role, address indexed manager);
1329 
1330     modifier onlyPermissionManager(address _app, bytes32 _role) {
1331         require(msg.sender == getPermissionManager(_app, _role), ERROR_AUTH_NO_MANAGER);
1332         _;
1333     }
1334 
1335     modifier noPermissionManager(address _app, bytes32 _role) {
1336         // only allow permission creation (or re-creation) when there is no manager
1337         require(getPermissionManager(_app, _role) == address(0), ERROR_EXISTENT_MANAGER);
1338         _;
1339     }
1340 
1341     /**
1342     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
1343     * @notice Initialize an ACL instance and set `_permissionsCreator` as the entity that can create other permissions
1344     * @param _permissionsCreator Entity that will be given permission over createPermission
1345     */
1346     function initialize(address _permissionsCreator) public onlyInit {
1347         initialized();
1348         require(msg.sender == address(kernel()), ERROR_AUTH_INIT_KERNEL);
1349 
1350         _createPermission(_permissionsCreator, this, CREATE_PERMISSIONS_ROLE, _permissionsCreator);
1351     }
1352 
1353     /**
1354     * @dev Creates a permission that wasn't previously set and managed.
1355     *      If a created permission is removed it is possible to reset it with createPermission.
1356     *      This is the **ONLY** way to create permissions and set managers to permissions that don't
1357     *      have a manager.
1358     *      In terms of the ACL being initialized, this function implicitly protects all the other
1359     *      state-changing external functions, as they all require the sender to be a manager.
1360     * @notice Create a new permission granting `_entity` the ability to perform actions requiring `_role` on `_app`, setting `_manager` as the permission's manager
1361     * @param _entity Address of the whitelisted entity that will be able to perform the role
1362     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1363     * @param _role Identifier for the group of actions in app given access to perform
1364     * @param _manager Address of the entity that will be able to grant and revoke the permission further.
1365     */
1366     function createPermission(address _entity, address _app, bytes32 _role, address _manager)
1367         external
1368         auth(CREATE_PERMISSIONS_ROLE)
1369         noPermissionManager(_app, _role)
1370     {
1371         _createPermission(_entity, _app, _role, _manager);
1372     }
1373 
1374     /**
1375     * @dev Grants permission if allowed. This requires `msg.sender` to be the permission manager
1376     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
1377     * @param _entity Address of the whitelisted entity that will be able to perform the role
1378     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1379     * @param _role Identifier for the group of actions in app given access to perform
1380     */
1381     function grantPermission(address _entity, address _app, bytes32 _role)
1382         external
1383     {
1384         grantPermissionP(_entity, _app, _role, new uint256[](0));
1385     }
1386 
1387     /**
1388     * @dev Grants a permission with parameters if allowed. This requires `msg.sender` to be the permission manager
1389     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
1390     * @param _entity Address of the whitelisted entity that will be able to perform the role
1391     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1392     * @param _role Identifier for the group of actions in app given access to perform
1393     * @param _params Permission parameters
1394     */
1395     function grantPermissionP(address _entity, address _app, bytes32 _role, uint256[] _params)
1396         public
1397         onlyPermissionManager(_app, _role)
1398     {
1399         bytes32 paramsHash = _params.length > 0 ? _saveParams(_params) : EMPTY_PARAM_HASH;
1400         _setPermission(_entity, _app, _role, paramsHash);
1401     }
1402 
1403     /**
1404     * @dev Revokes permission if allowed. This requires `msg.sender` to be the the permission manager
1405     * @notice Revoke from `_entity` the ability to perform actions requiring `_role` on `_app`
1406     * @param _entity Address of the whitelisted entity to revoke access from
1407     * @param _app Address of the app in which the role will be revoked
1408     * @param _role Identifier for the group of actions in app being revoked
1409     */
1410     function revokePermission(address _entity, address _app, bytes32 _role)
1411         external
1412         onlyPermissionManager(_app, _role)
1413     {
1414         _setPermission(_entity, _app, _role, NO_PERMISSION);
1415     }
1416 
1417     /**
1418     * @notice Set `_newManager` as the manager of `_role` in `_app`
1419     * @param _newManager Address for the new manager
1420     * @param _app Address of the app in which the permission management is being transferred
1421     * @param _role Identifier for the group of actions being transferred
1422     */
1423     function setPermissionManager(address _newManager, address _app, bytes32 _role)
1424         external
1425         onlyPermissionManager(_app, _role)
1426     {
1427         _setPermissionManager(_newManager, _app, _role);
1428     }
1429 
1430     /**
1431     * @notice Remove the manager of `_role` in `_app`
1432     * @param _app Address of the app in which the permission is being unmanaged
1433     * @param _role Identifier for the group of actions being unmanaged
1434     */
1435     function removePermissionManager(address _app, bytes32 _role)
1436         external
1437         onlyPermissionManager(_app, _role)
1438     {
1439         _setPermissionManager(address(0), _app, _role);
1440     }
1441 
1442     /**
1443     * @notice Burn non-existent `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
1444     * @param _app Address of the app in which the permission is being burned
1445     * @param _role Identifier for the group of actions being burned
1446     */
1447     function createBurnedPermission(address _app, bytes32 _role)
1448         external
1449         auth(CREATE_PERMISSIONS_ROLE)
1450         noPermissionManager(_app, _role)
1451     {
1452         _setPermissionManager(BURN_ENTITY, _app, _role);
1453     }
1454 
1455     /**
1456     * @notice Burn `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
1457     * @param _app Address of the app in which the permission is being burned
1458     * @param _role Identifier for the group of actions being burned
1459     */
1460     function burnPermissionManager(address _app, bytes32 _role)
1461         external
1462         onlyPermissionManager(_app, _role)
1463     {
1464         _setPermissionManager(BURN_ENTITY, _app, _role);
1465     }
1466 
1467     /**
1468      * @notice Get parameters for permission array length
1469      * @param _entity Address of the whitelisted entity that will be able to perform the role
1470      * @param _app Address of the app
1471      * @param _role Identifier for a group of actions in app
1472      * @return Length of the array
1473      */
1474     function getPermissionParamsLength(address _entity, address _app, bytes32 _role) external view returns (uint) {
1475         return permissionParams[permissions[permissionHash(_entity, _app, _role)]].length;
1476     }
1477 
1478     /**
1479     * @notice Get parameter for permission
1480     * @param _entity Address of the whitelisted entity that will be able to perform the role
1481     * @param _app Address of the app
1482     * @param _role Identifier for a group of actions in app
1483     * @param _index Index of parameter in the array
1484     * @return Parameter (id, op, value)
1485     */
1486     function getPermissionParam(address _entity, address _app, bytes32 _role, uint _index)
1487         external
1488         view
1489         returns (uint8, uint8, uint240)
1490     {
1491         Param storage param = permissionParams[permissions[permissionHash(_entity, _app, _role)]][_index];
1492         return (param.id, param.op, param.value);
1493     }
1494 
1495     /**
1496     * @dev Get manager for permission
1497     * @param _app Address of the app
1498     * @param _role Identifier for a group of actions in app
1499     * @return address of the manager for the permission
1500     */
1501     function getPermissionManager(address _app, bytes32 _role) public view returns (address) {
1502         return permissionManager[roleHash(_app, _role)];
1503     }
1504 
1505     /**
1506     * @dev Function called by apps to check ACL on kernel or to check permission statu
1507     * @param _who Sender of the original call
1508     * @param _where Address of the app
1509     * @param _where Identifier for a group of actions in app
1510     * @param _how Permission parameters
1511     * @return boolean indicating whether the ACL allows the role or not
1512     */
1513     function hasPermission(address _who, address _where, bytes32 _what, bytes memory _how) public view returns (bool) {
1514         // Force cast the bytes array into a uint256[], by overwriting its length
1515         // Note that the uint256[] doesn't need to be initialized as we immediately overwrite it
1516         // with _how and a new length, and _how becomes invalid from this point forward
1517         uint256[] memory how;
1518         uint256 intsLength = _how.length / 32;
1519         assembly {
1520             how := _how
1521             mstore(how, intsLength)
1522         }
1523 
1524         return hasPermission(_who, _where, _what, how);
1525     }
1526 
1527     function hasPermission(address _who, address _where, bytes32 _what, uint256[] memory _how) public view returns (bool) {
1528         bytes32 whoParams = permissions[permissionHash(_who, _where, _what)];
1529         if (whoParams != NO_PERMISSION && evalParams(whoParams, _who, _where, _what, _how)) {
1530             return true;
1531         }
1532 
1533         bytes32 anyParams = permissions[permissionHash(ANY_ENTITY, _where, _what)];
1534         if (anyParams != NO_PERMISSION && evalParams(anyParams, ANY_ENTITY, _where, _what, _how)) {
1535             return true;
1536         }
1537 
1538         return false;
1539     }
1540 
1541     function hasPermission(address _who, address _where, bytes32 _what) public view returns (bool) {
1542         uint256[] memory empty = new uint256[](0);
1543         return hasPermission(_who, _where, _what, empty);
1544     }
1545 
1546     function evalParams(
1547         bytes32 _paramsHash,
1548         address _who,
1549         address _where,
1550         bytes32 _what,
1551         uint256[] _how
1552     ) public view returns (bool)
1553     {
1554         if (_paramsHash == EMPTY_PARAM_HASH) {
1555             return true;
1556         }
1557 
1558         return _evalParam(_paramsHash, 0, _who, _where, _what, _how);
1559     }
1560 
1561     /**
1562     * @dev Internal createPermission for access inside the kernel (on instantiation)
1563     */
1564     function _createPermission(address _entity, address _app, bytes32 _role, address _manager) internal {
1565         _setPermission(_entity, _app, _role, EMPTY_PARAM_HASH);
1566         _setPermissionManager(_manager, _app, _role);
1567     }
1568 
1569     /**
1570     * @dev Internal function called to actually save the permission
1571     */
1572     function _setPermission(address _entity, address _app, bytes32 _role, bytes32 _paramsHash) internal {
1573         permissions[permissionHash(_entity, _app, _role)] = _paramsHash;
1574         bool entityHasPermission = _paramsHash != NO_PERMISSION;
1575         bool permissionHasParams = entityHasPermission && _paramsHash != EMPTY_PARAM_HASH;
1576 
1577         emit SetPermission(_entity, _app, _role, entityHasPermission);
1578         if (permissionHasParams) {
1579             emit SetPermissionParams(_entity, _app, _role, _paramsHash);
1580         }
1581     }
1582 
1583     function _saveParams(uint256[] _encodedParams) internal returns (bytes32) {
1584         bytes32 paramHash = keccak256(abi.encodePacked(_encodedParams));
1585         Param[] storage params = permissionParams[paramHash];
1586 
1587         if (params.length == 0) { // params not saved before
1588             for (uint256 i = 0; i < _encodedParams.length; i++) {
1589                 uint256 encodedParam = _encodedParams[i];
1590                 Param memory param = Param(decodeParamId(encodedParam), decodeParamOp(encodedParam), uint240(encodedParam));
1591                 params.push(param);
1592             }
1593         }
1594 
1595         return paramHash;
1596     }
1597 
1598     function _evalParam(
1599         bytes32 _paramsHash,
1600         uint32 _paramId,
1601         address _who,
1602         address _where,
1603         bytes32 _what,
1604         uint256[] _how
1605     ) internal view returns (bool)
1606     {
1607         if (_paramId >= permissionParams[_paramsHash].length) {
1608             return false; // out of bounds
1609         }
1610 
1611         Param memory param = permissionParams[_paramsHash][_paramId];
1612 
1613         if (param.id == LOGIC_OP_PARAM_ID) {
1614             return _evalLogic(param, _paramsHash, _who, _where, _what, _how);
1615         }
1616 
1617         uint256 value;
1618         uint256 comparedTo = uint256(param.value);
1619 
1620         // get value
1621         if (param.id == ORACLE_PARAM_ID) {
1622             value = checkOracle(IACLOracle(param.value), _who, _where, _what, _how) ? 1 : 0;
1623             comparedTo = 1;
1624         } else if (param.id == BLOCK_NUMBER_PARAM_ID) {
1625             value = getBlockNumber();
1626         } else if (param.id == TIMESTAMP_PARAM_ID) {
1627             value = getTimestamp();
1628         } else if (param.id == PARAM_VALUE_PARAM_ID) {
1629             value = uint256(param.value);
1630         } else {
1631             if (param.id >= _how.length) {
1632                 return false;
1633             }
1634             value = uint256(uint240(_how[param.id])); // force lost precision
1635         }
1636 
1637         if (Op(param.op) == Op.RET) {
1638             return uint256(value) > 0;
1639         }
1640 
1641         return compare(value, Op(param.op), comparedTo);
1642     }
1643 
1644     function _evalLogic(Param _param, bytes32 _paramsHash, address _who, address _where, bytes32 _what, uint256[] _how)
1645         internal
1646         view
1647         returns (bool)
1648     {
1649         if (Op(_param.op) == Op.IF_ELSE) {
1650             uint32 conditionParam;
1651             uint32 successParam;
1652             uint32 failureParam;
1653 
1654             (conditionParam, successParam, failureParam) = decodeParamsList(uint256(_param.value));
1655             bool result = _evalParam(_paramsHash, conditionParam, _who, _where, _what, _how);
1656 
1657             return _evalParam(_paramsHash, result ? successParam : failureParam, _who, _where, _what, _how);
1658         }
1659 
1660         uint32 param1;
1661         uint32 param2;
1662 
1663         (param1, param2,) = decodeParamsList(uint256(_param.value));
1664         bool r1 = _evalParam(_paramsHash, param1, _who, _where, _what, _how);
1665 
1666         if (Op(_param.op) == Op.NOT) {
1667             return !r1;
1668         }
1669 
1670         if (r1 && Op(_param.op) == Op.OR) {
1671             return true;
1672         }
1673 
1674         if (!r1 && Op(_param.op) == Op.AND) {
1675             return false;
1676         }
1677 
1678         bool r2 = _evalParam(_paramsHash, param2, _who, _where, _what, _how);
1679 
1680         if (Op(_param.op) == Op.XOR) {
1681             return r1 != r2;
1682         }
1683 
1684         return r2; // both or and and depend on result of r2 after checks
1685     }
1686 
1687     function compare(uint256 _a, Op _op, uint256 _b) internal pure returns (bool) {
1688         if (_op == Op.EQ)  return _a == _b;                              // solium-disable-line lbrace
1689         if (_op == Op.NEQ) return _a != _b;                              // solium-disable-line lbrace
1690         if (_op == Op.GT)  return _a > _b;                               // solium-disable-line lbrace
1691         if (_op == Op.LT)  return _a < _b;                               // solium-disable-line lbrace
1692         if (_op == Op.GTE) return _a >= _b;                              // solium-disable-line lbrace
1693         if (_op == Op.LTE) return _a <= _b;                              // solium-disable-line lbrace
1694         return false;
1695     }
1696 
1697     function checkOracle(IACLOracle _oracleAddr, address _who, address _where, bytes32 _what, uint256[] _how) internal view returns (bool) {
1698         bytes4 sig = _oracleAddr.canPerform.selector;
1699 
1700         // a raw call is required so we can return false if the call reverts, rather than reverting
1701         bytes memory checkCalldata = abi.encodeWithSelector(sig, _who, _where, _what, _how);
1702         uint256 oracleCheckGas = ORACLE_CHECK_GAS;
1703 
1704         bool ok;
1705         assembly {
1706             ok := staticcall(oracleCheckGas, _oracleAddr, add(checkCalldata, 0x20), mload(checkCalldata), 0, 0)
1707         }
1708 
1709         if (!ok) {
1710             return false;
1711         }
1712 
1713         uint256 size;
1714         assembly { size := returndatasize }
1715         if (size != 32) {
1716             return false;
1717         }
1718 
1719         bool result;
1720         assembly {
1721             let ptr := mload(0x40)       // get next free memory ptr
1722             returndatacopy(ptr, 0, size) // copy return from above `staticcall`
1723             result := mload(ptr)         // read data at ptr and set it to result
1724             mstore(ptr, 0)               // set pointer memory to 0 so it still is the next free ptr
1725         }
1726 
1727         return result;
1728     }
1729 
1730     /**
1731     * @dev Internal function that sets management
1732     */
1733     function _setPermissionManager(address _newManager, address _app, bytes32 _role) internal {
1734         permissionManager[roleHash(_app, _role)] = _newManager;
1735         emit ChangePermissionManager(_app, _role, _newManager);
1736     }
1737 
1738     function roleHash(address _where, bytes32 _what) internal pure returns (bytes32) {
1739         return keccak256(abi.encodePacked("ROLE", _where, _what));
1740     }
1741 
1742     function permissionHash(address _who, address _where, bytes32 _what) internal pure returns (bytes32) {
1743         return keccak256(abi.encodePacked("PERMISSION", _who, _where, _what));
1744     }
1745 }
1746 // File: contracts/apm/Repo.sol
1747 /* solium-disable function-order */
1748 // Allow public initialize() to be first
1749 contract Repo is AragonApp {
1750     /* Hardcoded constants to save gas
1751     bytes32 public constant CREATE_VERSION_ROLE = keccak256("CREATE_VERSION_ROLE");
1752     */
1753     bytes32 public constant CREATE_VERSION_ROLE = 0x1f56cfecd3595a2e6cc1a7e6cb0b20df84cdbd92eff2fee554e70e4e45a9a7d8;
1754 
1755     string private constant ERROR_INVALID_BUMP = "REPO_INVALID_BUMP";
1756     string private constant ERROR_INVALID_VERSION = "REPO_INVALID_VERSION";
1757     string private constant ERROR_INEXISTENT_VERSION = "REPO_INEXISTENT_VERSION";
1758 
1759     struct Version {
1760         uint16[3] semanticVersion;
1761         address contractAddress;
1762         bytes contentURI;
1763     }
1764 
1765     uint256 internal versionsNextIndex;
1766     mapping (uint256 => Version) internal versions;
1767     mapping (bytes32 => uint256) internal versionIdForSemantic;
1768     mapping (address => uint256) internal latestVersionIdForContract;
1769 
1770     event NewVersion(uint256 versionId, uint16[3] semanticVersion);
1771 
1772     /**
1773     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
1774     * @notice Initializes a Repo to be usable
1775     */
1776     function initialize() public onlyInit {
1777         initialized();
1778         versionsNextIndex = 1;
1779     }
1780 
1781     /**
1782     * @notice Create new version for repo
1783     * @param _newSemanticVersion Semantic version for new repo version
1784     * @param _contractAddress address for smart contract logic for version (if set to 0, it uses last versions' contractAddress)
1785     * @param _contentURI External URI for fetching new version's content
1786     */
1787     function newVersion(
1788         uint16[3] _newSemanticVersion,
1789         address _contractAddress,
1790         bytes _contentURI
1791     ) public auth(CREATE_VERSION_ROLE)
1792     {
1793         address contractAddress = _contractAddress;
1794         uint256 lastVersionIndex = versionsNextIndex - 1;
1795 
1796         uint16[3] memory lastSematicVersion;
1797 
1798         if (lastVersionIndex > 0) {
1799             Version storage lastVersion = versions[lastVersionIndex];
1800             lastSematicVersion = lastVersion.semanticVersion;
1801 
1802             if (contractAddress == address(0)) {
1803                 contractAddress = lastVersion.contractAddress;
1804             }
1805             // Only allows smart contract change on major version bumps
1806             require(
1807                 lastVersion.contractAddress == contractAddress || _newSemanticVersion[0] > lastVersion.semanticVersion[0],
1808                 ERROR_INVALID_VERSION
1809             );
1810         }
1811 
1812         require(isValidBump(lastSematicVersion, _newSemanticVersion), ERROR_INVALID_BUMP);
1813 
1814         uint256 versionId = versionsNextIndex++;
1815         versions[versionId] = Version(_newSemanticVersion, contractAddress, _contentURI);
1816         versionIdForSemantic[semanticVersionHash(_newSemanticVersion)] = versionId;
1817         latestVersionIdForContract[contractAddress] = versionId;
1818 
1819         emit NewVersion(versionId, _newSemanticVersion);
1820     }
1821 
1822     function getLatest() public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
1823         return getByVersionId(versionsNextIndex - 1);
1824     }
1825 
1826     function getLatestForContractAddress(address _contractAddress)
1827         public
1828         view
1829         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
1830     {
1831         return getByVersionId(latestVersionIdForContract[_contractAddress]);
1832     }
1833 
1834     function getBySemanticVersion(uint16[3] _semanticVersion)
1835         public
1836         view
1837         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
1838     {
1839         return getByVersionId(versionIdForSemantic[semanticVersionHash(_semanticVersion)]);
1840     }
1841 
1842     function getByVersionId(uint _versionId) public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
1843         require(_versionId > 0 && _versionId < versionsNextIndex, ERROR_INEXISTENT_VERSION);
1844         Version storage version = versions[_versionId];
1845         return (version.semanticVersion, version.contractAddress, version.contentURI);
1846     }
1847 
1848     function getVersionsCount() public view returns (uint256) {
1849         return versionsNextIndex - 1;
1850     }
1851 
1852     function isValidBump(uint16[3] _oldVersion, uint16[3] _newVersion) public pure returns (bool) {
1853         bool hasBumped;
1854         uint i = 0;
1855         while (i < 3) {
1856             if (hasBumped) {
1857                 if (_newVersion[i] != 0) {
1858                     return false;
1859                 }
1860             } else if (_newVersion[i] != _oldVersion[i]) {
1861                 if (_oldVersion[i] > _newVersion[i] || _newVersion[i] - _oldVersion[i] != 1) {
1862                     return false;
1863                 }
1864                 hasBumped = true;
1865             }
1866             i++;
1867         }
1868         return hasBumped;
1869     }
1870 
1871     function semanticVersionHash(uint16[3] version) internal pure returns (bytes32) {
1872         return keccak256(abi.encodePacked(version[0], version[1], version[2]));
1873     }
1874 }
1875 // File: contracts/apm/APMRegistry.sol
1876 contract APMInternalAppNames {
1877     string internal constant APM_APP_NAME = "apm-registry";
1878     string internal constant REPO_APP_NAME = "apm-repo";
1879     string internal constant ENS_SUB_APP_NAME = "apm-enssub";
1880 }
1881 
1882 
1883 contract APMRegistry is AragonApp, AppProxyFactory, APMInternalAppNames {
1884     /* Hardcoded constants to save gas
1885     bytes32 public constant CREATE_REPO_ROLE = keccak256("CREATE_REPO_ROLE");
1886     */
1887     bytes32 public constant CREATE_REPO_ROLE = 0x2a9494d64846c9fdbf0158785aa330d8bc9caf45af27fa0e8898eb4d55adcea6;
1888 
1889     string private constant ERROR_INIT_PERMISSIONS = "APMREG_INIT_PERMISSIONS";
1890     string private constant ERROR_EMPTY_NAME = "APMREG_EMPTY_NAME";
1891 
1892     AbstractENS public ens;
1893     ENSSubdomainRegistrar public registrar;
1894 
1895     event NewRepo(bytes32 id, string name, address repo);
1896 
1897     /**
1898     * NEEDS CREATE_NAME_ROLE and POINT_ROOTNODE_ROLE permissions on registrar
1899     * @param _registrar ENSSubdomainRegistrar instance that holds registry root node ownership
1900     */
1901     function initialize(ENSSubdomainRegistrar _registrar) public onlyInit {
1902         initialized();
1903 
1904         registrar = _registrar;
1905         ens = registrar.ens();
1906 
1907         registrar.pointRootNode(this);
1908 
1909         // Check APM has all permissions it needss
1910         ACL acl = ACL(kernel().acl());
1911         require(acl.hasPermission(this, registrar, registrar.CREATE_NAME_ROLE()), ERROR_INIT_PERMISSIONS);
1912         require(acl.hasPermission(this, acl, acl.CREATE_PERMISSIONS_ROLE()), ERROR_INIT_PERMISSIONS);
1913     }
1914 
1915     /**
1916     * @notice Create new repo in registry with `_name`
1917     * @param _name Repo name, must be ununsed
1918     * @param _dev Address that will be given permission to create versions
1919     */
1920     function newRepo(string _name, address _dev) public auth(CREATE_REPO_ROLE) returns (Repo) {
1921         return _newRepo(_name, _dev);
1922     }
1923 
1924     /**
1925     * @notice Create new repo in registry with `_name` and first repo version
1926     * @param _name Repo name
1927     * @param _dev Address that will be given permission to create versions
1928     * @param _initialSemanticVersion Semantic version for new repo version
1929     * @param _contractAddress address for smart contract logic for version (if set to 0, it uses last versions' contractAddress)
1930     * @param _contentURI External URI for fetching new version's content
1931     */
1932     function newRepoWithVersion(
1933         string _name,
1934         address _dev,
1935         uint16[3] _initialSemanticVersion,
1936         address _contractAddress,
1937         bytes _contentURI
1938     ) public auth(CREATE_REPO_ROLE) returns (Repo)
1939     {
1940         Repo repo = _newRepo(_name, this); // need to have permissions to create version
1941         repo.newVersion(_initialSemanticVersion, _contractAddress, _contentURI);
1942 
1943         // Give permissions to _dev
1944         ACL acl = ACL(kernel().acl());
1945         acl.revokePermission(this, repo, repo.CREATE_VERSION_ROLE());
1946         acl.grantPermission(_dev, repo, repo.CREATE_VERSION_ROLE());
1947         acl.setPermissionManager(_dev, repo, repo.CREATE_VERSION_ROLE());
1948         return repo;
1949     }
1950 
1951     function _newRepo(string _name, address _dev) internal returns (Repo) {
1952         require(bytes(_name).length > 0, ERROR_EMPTY_NAME);
1953 
1954         Repo repo = newClonedRepo();
1955 
1956         ACL(kernel().acl()).createPermission(_dev, repo, repo.CREATE_VERSION_ROLE(), _dev);
1957 
1958         // Creates [name] subdomain in the rootNode and sets registry as resolver
1959         // This will fail if repo name already exists
1960         bytes32 node = registrar.createNameAndPoint(keccak256(abi.encodePacked(_name)), repo);
1961 
1962         emit NewRepo(node, _name, repo);
1963 
1964         return repo;
1965     }
1966 
1967     function newClonedRepo() internal returns (Repo repo) {
1968         repo = Repo(newAppProxy(kernel(), repoAppId()));
1969         repo.initialize();
1970     }
1971 
1972     function repoAppId() internal view returns (bytes32) {
1973         return keccak256(abi.encodePacked(registrar.rootNode(), keccak256(abi.encodePacked(REPO_APP_NAME))));
1974     }
1975 }
1976 // File: contracts/kernel/KernelStorage.sol
1977 contract KernelStorage {
1978     // namespace => app id => address
1979     mapping (bytes32 => mapping (bytes32 => address)) public apps;
1980     bytes32 public recoveryVaultAppId;
1981 }
1982 // File: contracts/kernel/Kernel.sol
1983 // solium-disable-next-line max-len
1984 contract Kernel is IKernel, KernelStorage, KernelAppIds, KernelNamespaceConstants, Petrifiable, IsContract, VaultRecoverable, AppProxyFactory, ACLSyntaxSugar {
1985     /* Hardcoded constants to save gas
1986     bytes32 public constant APP_MANAGER_ROLE = keccak256("APP_MANAGER_ROLE");
1987     */
1988     bytes32 public constant APP_MANAGER_ROLE = 0xb6d92708f3d4817afc106147d969e229ced5c46e65e0a5002a0d391287762bd0;
1989 
1990     string private constant ERROR_APP_NOT_CONTRACT = "KERNEL_APP_NOT_CONTRACT";
1991     string private constant ERROR_INVALID_APP_CHANGE = "KERNEL_INVALID_APP_CHANGE";
1992     string private constant ERROR_AUTH_FAILED = "KERNEL_AUTH_FAILED";
1993 
1994     /**
1995     * @dev Constructor that allows the deployer to choose if the base instance should be petrified immediately.
1996     * @param _shouldPetrify Immediately petrify this instance so that it can never be initialized
1997     */
1998     constructor(bool _shouldPetrify) public {
1999         if (_shouldPetrify) {
2000             petrify();
2001         }
2002     }
2003 
2004     /**
2005     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
2006     * @notice Initializes a kernel instance along with its ACL and sets `_permissionsCreator` as the entity that can create other permissions
2007     * @param _baseAcl Address of base ACL app
2008     * @param _permissionsCreator Entity that will be given permission over createPermission
2009     */
2010     function initialize(IACL _baseAcl, address _permissionsCreator) public onlyInit {
2011         initialized();
2012 
2013         // Set ACL base
2014         _setApp(KERNEL_APP_BASES_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, _baseAcl);
2015 
2016         // Create ACL instance and attach it as the default ACL app
2017         IACL acl = IACL(newAppProxy(this, KERNEL_DEFAULT_ACL_APP_ID));
2018         acl.initialize(_permissionsCreator);
2019         _setApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, acl);
2020 
2021         recoveryVaultAppId = KERNEL_DEFAULT_VAULT_APP_ID;
2022     }
2023 
2024     /**
2025     * @dev Create a new instance of an app linked to this kernel
2026     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`
2027     * @param _appId Identifier for app
2028     * @param _appBase Address of the app's base implementation
2029     * @return AppProxy instance
2030     */
2031     function newAppInstance(bytes32 _appId, address _appBase)
2032         public
2033         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
2034         returns (ERCProxy appProxy)
2035     {
2036         return newAppInstance(_appId, _appBase, new bytes(0), false);
2037     }
2038 
2039     /**
2040     * @dev Create a new instance of an app linked to this kernel and set its base
2041     *      implementation if it was not already set
2042     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
2043     * @param _appId Identifier for app
2044     * @param _appBase Address of the app's base implementation
2045     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
2046     * @param _setDefault Whether the app proxy app is the default one.
2047     *        Useful when the Kernel needs to know of an instance of a particular app,
2048     *        like Vault for escape hatch mechanism.
2049     * @return AppProxy instance
2050     */
2051     function newAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
2052         public
2053         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
2054         returns (ERCProxy appProxy)
2055     {
2056         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
2057         appProxy = newAppProxy(this, _appId, _initializePayload);
2058         // By calling setApp directly and not the internal functions, we make sure the params are checked
2059         // and it will only succeed if sender has permissions to set something to the namespace.
2060         if (_setDefault) {
2061             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
2062         }
2063     }
2064 
2065     /**
2066     * @dev Create a new pinned instance of an app linked to this kernel
2067     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`.
2068     * @param _appId Identifier for app
2069     * @param _appBase Address of the app's base implementation
2070     * @return AppProxy instance
2071     */
2072     function newPinnedAppInstance(bytes32 _appId, address _appBase)
2073         public
2074         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
2075         returns (ERCProxy appProxy)
2076     {
2077         return newPinnedAppInstance(_appId, _appBase, new bytes(0), false);
2078     }
2079 
2080     /**
2081     * @dev Create a new pinned instance of an app linked to this kernel and set
2082     *      its base implementation if it was not already set
2083     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
2084     * @param _appId Identifier for app
2085     * @param _appBase Address of the app's base implementation
2086     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
2087     * @param _setDefault Whether the app proxy app is the default one.
2088     *        Useful when the Kernel needs to know of an instance of a particular app,
2089     *        like Vault for escape hatch mechanism.
2090     * @return AppProxy instance
2091     */
2092     function newPinnedAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
2093         public
2094         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
2095         returns (ERCProxy appProxy)
2096     {
2097         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
2098         appProxy = newAppProxyPinned(this, _appId, _initializePayload);
2099         // By calling setApp directly and not the internal functions, we make sure the params are checked
2100         // and it will only succeed if sender has permissions to set something to the namespace.
2101         if (_setDefault) {
2102             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
2103         }
2104     }
2105 
2106     /**
2107     * @dev Set the resolving address of an app instance or base implementation
2108     * @notice Set the resolving address of `_appId` in namespace `_namespace` to `_app`
2109     * @param _namespace App namespace to use
2110     * @param _appId Identifier for app
2111     * @param _app Address of the app instance or base implementation
2112     * @return ID of app
2113     */
2114     function setApp(bytes32 _namespace, bytes32 _appId, address _app)
2115         public
2116         auth(APP_MANAGER_ROLE, arr(_namespace, _appId))
2117     {
2118         _setApp(_namespace, _appId, _app);
2119     }
2120 
2121     /**
2122     * @dev Set the default vault id for the escape hatch mechanism
2123     * @param _recoveryVaultAppId Identifier of the recovery vault app
2124     */
2125     function setRecoveryVaultAppId(bytes32 _recoveryVaultAppId)
2126         public
2127         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_ADDR_NAMESPACE, _recoveryVaultAppId))
2128     {
2129         recoveryVaultAppId = _recoveryVaultAppId;
2130     }
2131 
2132     // External access to default app id and namespace constants to mimic default getters for constants
2133     /* solium-disable function-order, mixedcase */
2134     function CORE_NAMESPACE() external pure returns (bytes32) { return KERNEL_CORE_NAMESPACE; }
2135     function APP_BASES_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_BASES_NAMESPACE; }
2136     function APP_ADDR_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_ADDR_NAMESPACE; }
2137     function KERNEL_APP_ID() external pure returns (bytes32) { return KERNEL_CORE_APP_ID; }
2138     function DEFAULT_ACL_APP_ID() external pure returns (bytes32) { return KERNEL_DEFAULT_ACL_APP_ID; }
2139     /* solium-enable function-order, mixedcase */
2140 
2141     /**
2142     * @dev Get the address of an app instance or base implementation
2143     * @param _namespace App namespace to use
2144     * @param _appId Identifier for app
2145     * @return Address of the app
2146     */
2147     function getApp(bytes32 _namespace, bytes32 _appId) public view returns (address) {
2148         return apps[_namespace][_appId];
2149     }
2150 
2151     /**
2152     * @dev Get the address of the recovery Vault instance (to recover funds)
2153     * @return Address of the Vault
2154     */
2155     function getRecoveryVault() public view returns (address) {
2156         return apps[KERNEL_APP_ADDR_NAMESPACE][recoveryVaultAppId];
2157     }
2158 
2159     /**
2160     * @dev Get the installed ACL app
2161     * @return ACL app
2162     */
2163     function acl() public view returns (IACL) {
2164         return IACL(getApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID));
2165     }
2166 
2167     /**
2168     * @dev Function called by apps to check ACL on kernel or to check permission status
2169     * @param _who Sender of the original call
2170     * @param _where Address of the app
2171     * @param _what Identifier for a group of actions in app
2172     * @param _how Extra data for ACL auth
2173     * @return Boolean indicating whether the ACL allows the role or not.
2174     *         Always returns false if the kernel hasn't been initialized yet.
2175     */
2176     function hasPermission(address _who, address _where, bytes32 _what, bytes _how) public view returns (bool) {
2177         IACL defaultAcl = acl();
2178         return address(defaultAcl) != address(0) && // Poor man's initialization check (saves gas)
2179             defaultAcl.hasPermission(_who, _where, _what, _how);
2180     }
2181 
2182     function _setApp(bytes32 _namespace, bytes32 _appId, address _app) internal {
2183         require(isContract(_app), ERROR_APP_NOT_CONTRACT);
2184         apps[_namespace][_appId] = _app;
2185         emit SetApp(_namespace, _appId, _app);
2186     }
2187 
2188     function _setAppIfNew(bytes32 _namespace, bytes32 _appId, address _app) internal {
2189         address app = getApp(_namespace, _appId);
2190         if (app != address(0)) {
2191             // The only way to set an app is if it passes the isContract check, so no need to check it again
2192             require(app == _app, ERROR_INVALID_APP_CHANGE);
2193         } else {
2194             _setApp(_namespace, _appId, _app);
2195         }
2196     }
2197 
2198     modifier auth(bytes32 _role, uint256[] memory params) {
2199         // Force cast the uint256[] into a bytes array, by overwriting its length
2200         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
2201         // with params and a new length, and params becomes invalid from this point forward
2202         bytes memory how;
2203         uint256 byteLength = params.length * 32;
2204         assembly {
2205             how := params
2206             mstore(how, byteLength)
2207         }
2208 
2209         require(hasPermission(msg.sender, address(this), _role, how), ERROR_AUTH_FAILED);
2210         _;
2211     }
2212 }
2213 // File: contracts/kernel/KernelProxy.sol
2214 contract KernelProxy is KernelStorage, KernelAppIds, KernelNamespaceConstants, IsContract, DepositableDelegateProxy {
2215     /**
2216     * @dev KernelProxy is a proxy contract to a kernel implementation. The implementation
2217     *      can update the reference, which effectively upgrades the contract
2218     * @param _kernelImpl Address of the contract used as implementation for kernel
2219     */
2220     constructor(IKernel _kernelImpl) public {
2221         require(isContract(address(_kernelImpl)));
2222         apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID] = _kernelImpl;
2223     }
2224 
2225     /**
2226      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
2227      */
2228     function proxyType() public pure returns (uint256 proxyTypeId) {
2229         return UPGRADEABLE;
2230     }
2231 
2232     /**
2233     * @dev ERC897, the address the proxy would delegate calls to
2234     */
2235     function implementation() public view returns (address) {
2236         return apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID];
2237     }
2238 }
2239 // File: contracts/evmscript/ScriptHelpers.sol
2240 /*
2241  * SPDX-License-Identitifer:    MIT
2242  */
2243 
2244 pragma solidity ^0.4.24;
2245 
2246 
2247 library ScriptHelpers {
2248     function getSpecId(bytes _script) internal pure returns (uint32) {
2249         return uint32At(_script, 0);
2250     }
2251 
2252     function uint256At(bytes _data, uint256 _location) internal pure returns (uint256 result) {
2253         assembly {
2254             result := mload(add(_data, add(0x20, _location)))
2255         }
2256     }
2257 
2258     function addressAt(bytes _data, uint256 _location) internal pure returns (address result) {
2259         uint256 word = uint256At(_data, _location);
2260 
2261         assembly {
2262             result := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
2263             0x1000000000000000000000000)
2264         }
2265     }
2266 
2267     function uint32At(bytes _data, uint256 _location) internal pure returns (uint32 result) {
2268         uint256 word = uint256At(_data, _location);
2269 
2270         assembly {
2271             result := div(and(word, 0xffffffff00000000000000000000000000000000000000000000000000000000),
2272             0x100000000000000000000000000000000000000000000000000000000)
2273         }
2274     }
2275 
2276     function locationOf(bytes _data, uint256 _location) internal pure returns (uint256 result) {
2277         assembly {
2278             result := add(_data, add(0x20, _location))
2279         }
2280     }
2281 
2282     function toBytes(bytes4 _sig) internal pure returns (bytes) {
2283         bytes memory payload = new bytes(4);
2284         assembly { mstore(add(payload, 0x20), _sig) }
2285         return payload;
2286     }
2287 }
2288 // File: contracts/evmscript/EVMScriptRegistry.sol
2289 /* solium-disable function-order */
2290 // Allow public initialize() to be first
2291 contract EVMScriptRegistry is IEVMScriptRegistry, EVMScriptRegistryConstants, AragonApp {
2292     using ScriptHelpers for bytes;
2293 
2294     /* Hardcoded constants to save gas
2295     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = keccak256("REGISTRY_ADD_EXECUTOR_ROLE");
2296     bytes32 public constant REGISTRY_MANAGER_ROLE = keccak256("REGISTRY_MANAGER_ROLE");
2297     */
2298     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = 0xc4e90f38eea8c4212a009ca7b8947943ba4d4a58d19b683417f65291d1cd9ed2;
2299     // WARN: Manager can censor all votes and the like happening in an org
2300     bytes32 public constant REGISTRY_MANAGER_ROLE = 0xf7a450ef335e1892cb42c8ca72e7242359d7711924b75db5717410da3f614aa3;
2301 
2302     string private constant ERROR_INEXISTENT_EXECUTOR = "EVMREG_INEXISTENT_EXECUTOR";
2303     string private constant ERROR_EXECUTOR_ENABLED = "EVMREG_EXECUTOR_ENABLED";
2304     string private constant ERROR_EXECUTOR_DISABLED = "EVMREG_EXECUTOR_DISABLED";
2305 
2306     struct ExecutorEntry {
2307         IEVMScriptExecutor executor;
2308         bool enabled;
2309     }
2310 
2311     uint256 private executorsNextIndex;
2312     mapping (uint256 => ExecutorEntry) public executors;
2313 
2314     event EnableExecutor(uint256 indexed executorId, address indexed executorAddress);
2315     event DisableExecutor(uint256 indexed executorId, address indexed executorAddress);
2316 
2317     modifier executorExists(uint256 _executorId) {
2318         require(_executorId > 0 && _executorId < executorsNextIndex, ERROR_INEXISTENT_EXECUTOR);
2319         _;
2320     }
2321 
2322     /**
2323     * @notice Initialize the registry
2324     */
2325     function initialize() public onlyInit {
2326         initialized();
2327         // Create empty record to begin executor IDs at 1
2328         executorsNextIndex = 1;
2329     }
2330 
2331     /**
2332     * @notice Add a new script executor with address `_executor` to the registry
2333     * @param _executor Address of the IEVMScriptExecutor that will be added to the registry
2334     * @return id Identifier of the executor in the registry
2335     */
2336     function addScriptExecutor(IEVMScriptExecutor _executor) external auth(REGISTRY_ADD_EXECUTOR_ROLE) returns (uint256 id) {
2337         uint256 executorId = executorsNextIndex++;
2338         executors[executorId] = ExecutorEntry(_executor, true);
2339         emit EnableExecutor(executorId, _executor);
2340         return executorId;
2341     }
2342 
2343     /**
2344     * @notice Disable script executor with ID `_executorId`
2345     * @param _executorId Identifier of the executor in the registry
2346     */
2347     function disableScriptExecutor(uint256 _executorId)
2348         external
2349         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
2350     {
2351         // Note that we don't need to check for an executor's existence in this case, as only
2352         // existing executors can be enabled
2353         ExecutorEntry storage executorEntry = executors[_executorId];
2354         require(executorEntry.enabled, ERROR_EXECUTOR_DISABLED);
2355         executorEntry.enabled = false;
2356         emit DisableExecutor(_executorId, executorEntry.executor);
2357     }
2358 
2359     /**
2360     * @notice Enable script executor with ID `_executorId`
2361     * @param _executorId Identifier of the executor in the registry
2362     */
2363     function enableScriptExecutor(uint256 _executorId)
2364         external
2365         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
2366         executorExists(_executorId)
2367     {
2368         ExecutorEntry storage executorEntry = executors[_executorId];
2369         require(!executorEntry.enabled, ERROR_EXECUTOR_ENABLED);
2370         executorEntry.enabled = true;
2371         emit EnableExecutor(_executorId, executorEntry.executor);
2372     }
2373 
2374     /**
2375     * @dev Get the script executor that can execute a particular script based on its first 4 bytes
2376     * @param _script EVMScript being inspected
2377     */
2378     function getScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
2379         uint256 id = _script.getSpecId();
2380 
2381         // Note that we don't need to check for an executor's existence in this case, as only
2382         // existing executors can be enabled
2383         ExecutorEntry storage entry = executors[id];
2384         return entry.enabled ? entry.executor : IEVMScriptExecutor(0);
2385     }
2386 }
2387 // File: contracts/evmscript/executors/BaseEVMScriptExecutor.sol
2388 /*
2389  * SPDX-License-Identitifer:    MIT
2390  */
2391 
2392 pragma solidity ^0.4.24;
2393 
2394 
2395 
2396 
2397 contract BaseEVMScriptExecutor is IEVMScriptExecutor, Autopetrified {
2398     uint256 internal constant SCRIPT_START_LOCATION = 4;
2399 }
2400 // File: contracts/evmscript/executors/CallsScript.sol
2401 // Inspired by https://github.com/reverendus/tx-manager
2402 
2403 
2404 
2405 
2406 contract CallsScript is BaseEVMScriptExecutor {
2407     using ScriptHelpers for bytes;
2408 
2409     /* Hardcoded constants to save gas
2410     bytes32 internal constant EXECUTOR_TYPE = keccak256("CALLS_SCRIPT");
2411     */
2412     bytes32 internal constant EXECUTOR_TYPE = 0x2dc858a00f3e417be1394b87c07158e989ec681ce8cc68a9093680ac1a870302;
2413 
2414     string private constant ERROR_BLACKLISTED_CALL = "EVMCALLS_BLACKLISTED_CALL";
2415     string private constant ERROR_INVALID_LENGTH = "EVMCALLS_INVALID_LENGTH";
2416     string private constant ERROR_CALL_REVERTED = "EVMCALLS_CALL_REVERTED";
2417 
2418     event LogScriptCall(address indexed sender, address indexed src, address indexed dst);
2419 
2420     /**
2421     * @notice Executes a number of call scripts
2422     * @param _script [ specId (uint32) ] many calls with this structure ->
2423     *    [ to (address: 20 bytes) ] [ calldataLength (uint32: 4 bytes) ] [ calldata (calldataLength bytes) ]
2424     * @param _blacklist Addresses the script cannot call to, or will revert.
2425     * @return always returns empty byte array
2426     */
2427     function execScript(bytes _script, bytes, address[] _blacklist) external isInitialized returns (bytes) {
2428         uint256 location = SCRIPT_START_LOCATION; // first 32 bits are spec id
2429         while (location < _script.length) {
2430             address contractAddress = _script.addressAt(location);
2431             // Check address being called is not blacklist
2432             for (uint i = 0; i < _blacklist.length; i++) {
2433                 require(contractAddress != _blacklist[i], ERROR_BLACKLISTED_CALL);
2434             }
2435 
2436             // logged before execution to ensure event ordering in receipt
2437             // if failed entire execution is reverted regardless
2438             emit LogScriptCall(msg.sender, address(this), contractAddress);
2439 
2440             uint256 calldataLength = uint256(_script.uint32At(location + 0x14));
2441             uint256 startOffset = location + 0x14 + 0x04;
2442             uint256 calldataStart = _script.locationOf(startOffset);
2443 
2444             // compute end of script / next location
2445             location = startOffset + calldataLength;
2446             require(location <= _script.length, ERROR_INVALID_LENGTH);
2447 
2448             bool success;
2449             assembly {
2450                 success := call(sub(gas, 5000), contractAddress, 0, calldataStart, calldataLength, 0, 0)
2451             }
2452 
2453             require(success, ERROR_CALL_REVERTED);
2454         }
2455     }
2456 
2457     function executorType() external pure returns (bytes32) {
2458         return EXECUTOR_TYPE;
2459     }
2460 }
2461 // File: contracts/factory/EVMScriptRegistryFactory.sol
2462 contract EVMScriptRegistryFactory is AppProxyFactory, EVMScriptRegistryConstants {
2463     EVMScriptRegistry public baseReg;
2464     IEVMScriptExecutor public baseCallScript;
2465 
2466     constructor() public {
2467         baseReg = new EVMScriptRegistry();
2468         baseCallScript = IEVMScriptExecutor(new CallsScript());
2469     }
2470 
2471     function newEVMScriptRegistry(Kernel _dao) public returns (EVMScriptRegistry reg) {
2472         bytes memory initPayload = abi.encodeWithSelector(reg.initialize.selector);
2473         reg = EVMScriptRegistry(_dao.newPinnedAppInstance(EVMSCRIPT_REGISTRY_APP_ID, baseReg, initPayload, true));
2474 
2475         ACL acl = ACL(_dao.acl());
2476 
2477         acl.createPermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE(), this);
2478 
2479         reg.addScriptExecutor(baseCallScript);     // spec 1 = CallsScript
2480 
2481         // Clean up the permissions
2482         acl.revokePermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
2483         acl.removePermissionManager(reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
2484 
2485         return reg;
2486     }
2487 }
2488 // File: contracts/factory/DAOFactory.sol
2489 contract DAOFactory {
2490     IKernel public baseKernel;
2491     IACL public baseACL;
2492     EVMScriptRegistryFactory public regFactory;
2493 
2494     event DeployDAO(address dao);
2495     event DeployEVMScriptRegistry(address reg);
2496 
2497     constructor(IKernel _baseKernel, IACL _baseACL, EVMScriptRegistryFactory _regFactory) public {
2498         // No need to init as it cannot be killed by devops199
2499         if (address(_regFactory) != address(0)) {
2500             regFactory = _regFactory;
2501         }
2502 
2503         baseKernel = _baseKernel;
2504         baseACL = _baseACL;
2505     }
2506 
2507     /**
2508     * @param _root Address that will be granted control to setup DAO permissions
2509     */
2510     function newDAO(address _root) public returns (Kernel) {
2511         Kernel dao = Kernel(new KernelProxy(baseKernel));
2512 
2513         if (address(regFactory) == address(0)) {
2514             dao.initialize(baseACL, _root);
2515         } else {
2516             dao.initialize(baseACL, this);
2517 
2518             ACL acl = ACL(dao.acl());
2519             bytes32 permRole = acl.CREATE_PERMISSIONS_ROLE();
2520             bytes32 appManagerRole = dao.APP_MANAGER_ROLE();
2521 
2522             acl.grantPermission(regFactory, acl, permRole);
2523 
2524             acl.createPermission(regFactory, dao, appManagerRole, this);
2525 
2526             EVMScriptRegistry reg = regFactory.newEVMScriptRegistry(dao);
2527             emit DeployEVMScriptRegistry(address(reg));
2528 
2529             // Clean up permissions
2530             // First, completely reset the APP_MANAGER_ROLE
2531             acl.revokePermission(regFactory, dao, appManagerRole);
2532             acl.removePermissionManager(dao, appManagerRole);
2533 
2534             // Then, make root the only holder and manager of CREATE_PERMISSIONS_ROLE
2535             acl.revokePermission(regFactory, acl, permRole);
2536             acl.revokePermission(this, acl, permRole);
2537             acl.grantPermission(_root, acl, permRole);
2538             acl.setPermissionManager(_root, acl, permRole);
2539         }
2540 
2541         emit DeployDAO(address(dao));
2542 
2543         return dao;
2544     }
2545 }
2546 // File: contracts/lib/ens/ENS.sol
2547 /**
2548  * The ENS registry contract.
2549  */
2550 contract ENS is AbstractENS {
2551     struct Record {
2552         address owner;
2553         address resolver;
2554         uint64 ttl;
2555     }
2556 
2557     mapping(bytes32=>Record) records;
2558 
2559     // Permits modifications only by the owner of the specified node.
2560     modifier only_owner(bytes32 node) {
2561         if (records[node].owner != msg.sender) throw;
2562         _;
2563     }
2564 
2565     /**
2566      * Constructs a new ENS registrar.
2567      */
2568     function ENS() public {
2569         records[0].owner = msg.sender;
2570     }
2571 
2572     /**
2573      * Returns the address that owns the specified node.
2574      */
2575     function owner(bytes32 node) public constant returns (address) {
2576         return records[node].owner;
2577     }
2578 
2579     /**
2580      * Returns the address of the resolver for the specified node.
2581      */
2582     function resolver(bytes32 node) public constant returns (address) {
2583         return records[node].resolver;
2584     }
2585 
2586     /**
2587      * Returns the TTL of a node, and any records associated with it.
2588      */
2589     function ttl(bytes32 node) public constant returns (uint64) {
2590         return records[node].ttl;
2591     }
2592 
2593     /**
2594      * Transfers ownership of a node to a new address. May only be called by the current
2595      * owner of the node.
2596      * @param node The node to transfer ownership of.
2597      * @param owner The address of the new owner.
2598      */
2599     function setOwner(bytes32 node, address owner) only_owner(node) public {
2600         Transfer(node, owner);
2601         records[node].owner = owner;
2602     }
2603 
2604     /**
2605      * Transfers ownership of a subnode keccak256(node, label) to a new address. May only be
2606      * called by the owner of the parent node.
2607      * @param node The parent node.
2608      * @param label The hash of the label specifying the subnode.
2609      * @param owner The address of the new owner.
2610      */
2611     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) public {
2612         var subnode = keccak256(node, label);
2613         NewOwner(node, label, owner);
2614         records[subnode].owner = owner;
2615     }
2616 
2617     /**
2618      * Sets the resolver address for the specified node.
2619      * @param node The node to update.
2620      * @param resolver The address of the resolver.
2621      */
2622     function setResolver(bytes32 node, address resolver) only_owner(node) public {
2623         NewResolver(node, resolver);
2624         records[node].resolver = resolver;
2625     }
2626 
2627     /**
2628      * Sets the TTL for the specified node.
2629      * @param node The node to update.
2630      * @param ttl The TTL in seconds.
2631      */
2632     function setTTL(bytes32 node, uint64 ttl) only_owner(node) public {
2633         NewTTL(node, ttl);
2634         records[node].ttl = ttl;
2635     }
2636 }
2637 // File: contracts/factory/ENSFactory.sol
2638 // Note that this contract is NOT meant to be used in production.
2639 // Its only purpose is to easily create ENS instances for testing APM.
2640 contract ENSFactory is ENSConstants {
2641     event DeployENS(address ens);
2642 
2643     // This is an incredibly trustfull ENS deployment, only use for testing
2644     function newENS(address _owner) public returns (ENS) {
2645         ENS ens = new ENS();
2646 
2647         // Setup .eth TLD
2648         ens.setSubnodeOwner(ENS_ROOT, ETH_TLD_LABEL, this);
2649 
2650         // Setup public resolver
2651         PublicResolver resolver = new PublicResolver(ens);
2652         ens.setSubnodeOwner(ETH_TLD_NODE, PUBLIC_RESOLVER_LABEL, this);
2653         ens.setResolver(PUBLIC_RESOLVER_NODE, resolver);
2654         resolver.setAddr(PUBLIC_RESOLVER_NODE, resolver);
2655 
2656         ens.setOwner(ETH_TLD_NODE, _owner);
2657         ens.setOwner(ENS_ROOT, _owner);
2658 
2659         emit DeployENS(ens);
2660 
2661         return ens;
2662     }
2663 }
2664 // File: contracts/factory/APMRegistryFactory.sol
2665 contract APMRegistryFactory is APMInternalAppNames {
2666     DAOFactory public daoFactory;
2667     APMRegistry public registryBase;
2668     Repo public repoBase;
2669     ENSSubdomainRegistrar public ensSubdomainRegistrarBase;
2670     ENS public ens;
2671 
2672     event DeployAPM(bytes32 indexed node, address apm);
2673 
2674     // Needs either one ENS or ENSFactory
2675     constructor(
2676         DAOFactory _daoFactory,
2677         APMRegistry _registryBase,
2678         Repo _repoBase,
2679         ENSSubdomainRegistrar _ensSubBase,
2680         ENS _ens,
2681         ENSFactory _ensFactory
2682     ) public // DAO initialized without evmscript run support
2683     {
2684         daoFactory = _daoFactory;
2685         registryBase = _registryBase;
2686         repoBase = _repoBase;
2687         ensSubdomainRegistrarBase = _ensSubBase;
2688 
2689         // Either the ENS address provided is used, if any.
2690         // Or we use the ENSFactory to generate a test instance of ENS
2691         // If not the ENS address nor factory address are provided, this will revert
2692         ens = _ens != address(0) ? _ens : _ensFactory.newENS(this);
2693     }
2694 
2695     function newAPM(bytes32 _tld, bytes32 _label, address _root) public returns (APMRegistry) {
2696         bytes32 node = keccak256(abi.encodePacked(_tld, _label));
2697 
2698         // Assume it is the test ENS
2699         if (ens.owner(node) != address(this)) {
2700             // If we weren't in test ens and factory doesn't have ownership, will fail
2701             require(ens.owner(_tld) == address(this));
2702             ens.setSubnodeOwner(_tld, _label, this);
2703         }
2704 
2705         Kernel dao = daoFactory.newDAO(this);
2706         ACL acl = ACL(dao.acl());
2707 
2708         acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);
2709 
2710         // Deploy app proxies
2711         bytes memory noInit = new bytes(0);
2712         ENSSubdomainRegistrar ensSub = ENSSubdomainRegistrar(
2713             dao.newAppInstance(
2714                 keccak256(abi.encodePacked(node, keccak256(abi.encodePacked(ENS_SUB_APP_NAME)))),
2715                 ensSubdomainRegistrarBase,
2716                 noInit,
2717                 false
2718             )
2719         );
2720         APMRegistry apm = APMRegistry(
2721             dao.newAppInstance(
2722                 keccak256(abi.encodePacked(node, keccak256(abi.encodePacked(APM_APP_NAME)))),
2723                 registryBase,
2724                 noInit,
2725                 false
2726             )
2727         );
2728 
2729         // APMRegistry controls Repos
2730         bytes32 repoAppId = keccak256(abi.encodePacked(node, keccak256(abi.encodePacked(REPO_APP_NAME))));
2731         dao.setApp(dao.APP_BASES_NAMESPACE(), repoAppId, repoBase);
2732 
2733         emit DeployAPM(node, apm);
2734 
2735         // Grant permissions needed for APM on ENSSubdomainRegistrar
2736         acl.createPermission(apm, ensSub, ensSub.CREATE_NAME_ROLE(), _root);
2737         acl.createPermission(apm, ensSub, ensSub.POINT_ROOTNODE_ROLE(), _root);
2738 
2739         // allow apm to create permissions for Repos in Kernel
2740         bytes32 permRole = acl.CREATE_PERMISSIONS_ROLE();
2741 
2742         acl.grantPermission(apm, acl, permRole);
2743 
2744         // Initialize
2745         ens.setOwner(node, ensSub);
2746         ensSub.initialize(ens, node);
2747         apm.initialize(ensSub);
2748 
2749         uint16[3] memory firstVersion;
2750         firstVersion[0] = 1;
2751 
2752         acl.createPermission(this, apm, apm.CREATE_REPO_ROLE(), this);
2753 
2754         apm.newRepoWithVersion(APM_APP_NAME, _root, firstVersion, registryBase, b("ipfs:apm"));
2755         apm.newRepoWithVersion(ENS_SUB_APP_NAME, _root, firstVersion, ensSubdomainRegistrarBase, b("ipfs:enssub"));
2756         apm.newRepoWithVersion(REPO_APP_NAME, _root, firstVersion, repoBase, b("ipfs:repo"));
2757 
2758         configureAPMPermissions(acl, apm, _root);
2759 
2760         // Permission transition to _root
2761         acl.setPermissionManager(_root, dao, dao.APP_MANAGER_ROLE());
2762         acl.revokePermission(this, acl, permRole);
2763         acl.grantPermission(_root, acl, permRole);
2764         acl.setPermissionManager(_root, acl, permRole);
2765 
2766         return apm;
2767     }
2768 
2769     function b(string memory x) internal pure returns (bytes memory y) {
2770         y = bytes(x);
2771     }
2772 
2773     // Factory can be subclassed and permissions changed
2774     function configureAPMPermissions(ACL _acl, APMRegistry _apm, address _root) internal {
2775         _acl.grantPermission(_root, _apm, _apm.CREATE_REPO_ROLE());
2776         _acl.setPermissionManager(_root, _apm, _apm.CREATE_REPO_ROLE());
2777     }
2778 }