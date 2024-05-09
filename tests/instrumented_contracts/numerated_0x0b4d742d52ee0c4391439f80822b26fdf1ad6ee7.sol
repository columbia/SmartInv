1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-06
3 */
4 
5 // File: contracts/acl/IACL.sol
6 
7 /*
8  * SPDX-License-Identitifer:    MIT
9  */
10 
11 pragma solidity ^0.4.24;
12 
13 
14 interface IACL {
15     function initialize(address permissionsCreator) external;
16 
17     // TODO: this should be external
18     // See https://github.com/ethereum/solidity/issues/4832
19     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
20 }
21 
22 // File: contracts/common/IVaultRecoverable.sol
23 
24 /*
25  * SPDX-License-Identitifer:    MIT
26  */
27 
28 pragma solidity ^0.4.24;
29 
30 
31 interface IVaultRecoverable {
32     event RecoverToVault(address indexed vault, address indexed token, uint256 amount);
33 
34     function transferToVault(address token) external;
35 
36     function allowRecoverability(address token) external view returns (bool);
37     function getRecoveryVault() external view returns (address);
38 }
39 
40 // File: contracts/kernel/IKernel.sol
41 
42 /*
43  * SPDX-License-Identitifer:    MIT
44  */
45 
46 pragma solidity ^0.4.24;
47 
48 
49 
50 
51 interface IKernelEvents {
52     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
53 }
54 
55 
56 // This should be an interface, but interfaces can't inherit yet :(
57 contract IKernel is IKernelEvents, IVaultRecoverable {
58     function acl() public view returns (IACL);
59     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
60 
61     function setApp(bytes32 namespace, bytes32 appId, address app) public;
62     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
63 }
64 
65 // File: contracts/kernel/KernelConstants.sol
66 
67 /*
68  * SPDX-License-Identitifer:    MIT
69  */
70 
71 pragma solidity ^0.4.24;
72 
73 
74 contract KernelAppIds {
75     /* Hardcoded constants to save gas
76     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
77     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
78     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
79     */
80     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
81     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
82     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
83 }
84 
85 
86 contract KernelNamespaceConstants {
87     /* Hardcoded constants to save gas
88     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
89     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
90     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
91     */
92     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
93     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
94     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
95 }
96 
97 // File: contracts/kernel/KernelStorage.sol
98 
99 pragma solidity 0.4.24;
100 
101 
102 contract KernelStorage {
103     // namespace => app id => address
104     mapping (bytes32 => mapping (bytes32 => address)) public apps;
105     bytes32 public recoveryVaultAppId;
106 }
107 
108 // File: contracts/acl/ACLSyntaxSugar.sol
109 
110 /*
111  * SPDX-License-Identitifer:    MIT
112  */
113 
114 pragma solidity ^0.4.24;
115 
116 
117 contract ACLSyntaxSugar {
118     function arr() internal pure returns (uint256[]) {
119         return new uint256[](0);
120     }
121 
122     function arr(bytes32 _a) internal pure returns (uint256[] r) {
123         return arr(uint256(_a));
124     }
125 
126     function arr(bytes32 _a, bytes32 _b) internal pure returns (uint256[] r) {
127         return arr(uint256(_a), uint256(_b));
128     }
129 
130     function arr(address _a) internal pure returns (uint256[] r) {
131         return arr(uint256(_a));
132     }
133 
134     function arr(address _a, address _b) internal pure returns (uint256[] r) {
135         return arr(uint256(_a), uint256(_b));
136     }
137 
138     function arr(address _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
139         return arr(uint256(_a), _b, _c);
140     }
141 
142     function arr(address _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
143         return arr(uint256(_a), _b, _c, _d);
144     }
145 
146     function arr(address _a, uint256 _b) internal pure returns (uint256[] r) {
147         return arr(uint256(_a), uint256(_b));
148     }
149 
150     function arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
151         return arr(uint256(_a), uint256(_b), _c, _d, _e);
152     }
153 
154     function arr(address _a, address _b, address _c) internal pure returns (uint256[] r) {
155         return arr(uint256(_a), uint256(_b), uint256(_c));
156     }
157 
158     function arr(address _a, address _b, uint256 _c) internal pure returns (uint256[] r) {
159         return arr(uint256(_a), uint256(_b), uint256(_c));
160     }
161 
162     function arr(uint256 _a) internal pure returns (uint256[] r) {
163         r = new uint256[](1);
164         r[0] = _a;
165     }
166 
167     function arr(uint256 _a, uint256 _b) internal pure returns (uint256[] r) {
168         r = new uint256[](2);
169         r[0] = _a;
170         r[1] = _b;
171     }
172 
173     function arr(uint256 _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
174         r = new uint256[](3);
175         r[0] = _a;
176         r[1] = _b;
177         r[2] = _c;
178     }
179 
180     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
181         r = new uint256[](4);
182         r[0] = _a;
183         r[1] = _b;
184         r[2] = _c;
185         r[3] = _d;
186     }
187 
188     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
189         r = new uint256[](5);
190         r[0] = _a;
191         r[1] = _b;
192         r[2] = _c;
193         r[3] = _d;
194         r[4] = _e;
195     }
196 }
197 
198 
199 contract ACLHelpers {
200     function decodeParamOp(uint256 _x) internal pure returns (uint8 b) {
201         return uint8(_x >> (8 * 30));
202     }
203 
204     function decodeParamId(uint256 _x) internal pure returns (uint8 b) {
205         return uint8(_x >> (8 * 31));
206     }
207 
208     function decodeParamsList(uint256 _x) internal pure returns (uint32 a, uint32 b, uint32 c) {
209         a = uint32(_x);
210         b = uint32(_x >> (8 * 4));
211         c = uint32(_x >> (8 * 8));
212     }
213 }
214 
215 // File: contracts/common/ConversionHelpers.sol
216 
217 pragma solidity ^0.4.24;
218 
219 
220 library ConversionHelpers {
221     string private constant ERROR_IMPROPER_LENGTH = "CONVERSION_IMPROPER_LENGTH";
222 
223     function dangerouslyCastUintArrayToBytes(uint256[] memory _input) internal pure returns (bytes memory output) {
224         // Force cast the uint256[] into a bytes array, by overwriting its length
225         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
226         // with the input and a new length. The input becomes invalid from this point forward.
227         uint256 byteLength = _input.length * 32;
228         assembly {
229             output := _input
230             mstore(output, byteLength)
231         }
232     }
233 
234     function dangerouslyCastBytesToUintArray(bytes memory _input) internal pure returns (uint256[] memory output) {
235         // Force cast the bytes array into a uint256[], by overwriting its length
236         // Note that the uint256[] doesn't need to be initialized as we immediately overwrite it
237         // with the input and a new length. The input becomes invalid from this point forward.
238         uint256 intsLength = _input.length / 32;
239         require(_input.length == intsLength * 32, ERROR_IMPROPER_LENGTH);
240 
241         assembly {
242             output := _input
243             mstore(output, intsLength)
244         }
245     }
246 }
247 
248 // File: contracts/common/IsContract.sol
249 
250 /*
251  * SPDX-License-Identitifer:    MIT
252  */
253 
254 pragma solidity ^0.4.24;
255 
256 
257 contract IsContract {
258     /*
259     * NOTE: this should NEVER be used for authentication
260     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
261     *
262     * This is only intended to be used as a sanity check that an address is actually a contract,
263     * RATHER THAN an address not being a contract.
264     */
265     function isContract(address _target) internal view returns (bool) {
266         if (_target == address(0)) {
267             return false;
268         }
269 
270         uint256 size;
271         assembly { size := extcodesize(_target) }
272         return size > 0;
273     }
274 }
275 
276 // File: contracts/common/Uint256Helpers.sol
277 
278 pragma solidity ^0.4.24;
279 
280 
281 library Uint256Helpers {
282     uint256 private constant MAX_UINT64 = uint64(-1);
283 
284     string private constant ERROR_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
285 
286     function toUint64(uint256 a) internal pure returns (uint64) {
287         require(a <= MAX_UINT64, ERROR_NUMBER_TOO_BIG);
288         return uint64(a);
289     }
290 }
291 
292 // File: contracts/common/TimeHelpers.sol
293 
294 /*
295  * SPDX-License-Identitifer:    MIT
296  */
297 
298 pragma solidity ^0.4.24;
299 
300 
301 
302 contract TimeHelpers {
303     using Uint256Helpers for uint256;
304 
305     /**
306     * @dev Returns the current block number.
307     *      Using a function rather than `block.number` allows us to easily mock the block number in
308     *      tests.
309     */
310     function getBlockNumber() internal view returns (uint256) {
311         return block.number;
312     }
313 
314     /**
315     * @dev Returns the current block number, converted to uint64.
316     *      Using a function rather than `block.number` allows us to easily mock the block number in
317     *      tests.
318     */
319     function getBlockNumber64() internal view returns (uint64) {
320         return getBlockNumber().toUint64();
321     }
322 
323     /**
324     * @dev Returns the current timestamp.
325     *      Using a function rather than `block.timestamp` allows us to easily mock it in
326     *      tests.
327     */
328     function getTimestamp() internal view returns (uint256) {
329         return block.timestamp; // solium-disable-line security/no-block-members
330     }
331 
332     /**
333     * @dev Returns the current timestamp, converted to uint64.
334     *      Using a function rather than `block.timestamp` allows us to easily mock it in
335     *      tests.
336     */
337     function getTimestamp64() internal view returns (uint64) {
338         return getTimestamp().toUint64();
339     }
340 }
341 
342 // File: contracts/common/UnstructuredStorage.sol
343 
344 /*
345  * SPDX-License-Identitifer:    MIT
346  */
347 
348 pragma solidity ^0.4.24;
349 
350 
351 library UnstructuredStorage {
352     function getStorageBool(bytes32 position) internal view returns (bool data) {
353         assembly { data := sload(position) }
354     }
355 
356     function getStorageAddress(bytes32 position) internal view returns (address data) {
357         assembly { data := sload(position) }
358     }
359 
360     function getStorageBytes32(bytes32 position) internal view returns (bytes32 data) {
361         assembly { data := sload(position) }
362     }
363 
364     function getStorageUint256(bytes32 position) internal view returns (uint256 data) {
365         assembly { data := sload(position) }
366     }
367 
368     function setStorageBool(bytes32 position, bool data) internal {
369         assembly { sstore(position, data) }
370     }
371 
372     function setStorageAddress(bytes32 position, address data) internal {
373         assembly { sstore(position, data) }
374     }
375 
376     function setStorageBytes32(bytes32 position, bytes32 data) internal {
377         assembly { sstore(position, data) }
378     }
379 
380     function setStorageUint256(bytes32 position, uint256 data) internal {
381         assembly { sstore(position, data) }
382     }
383 }
384 
385 // File: contracts/common/Initializable.sol
386 
387 /*
388  * SPDX-License-Identitifer:    MIT
389  */
390 
391 pragma solidity ^0.4.24;
392 
393 
394 
395 
396 contract Initializable is TimeHelpers {
397     using UnstructuredStorage for bytes32;
398 
399     // keccak256("aragonOS.initializable.initializationBlock")
400     bytes32 internal constant INITIALIZATION_BLOCK_POSITION = 0xebb05b386a8d34882b8711d156f463690983dc47815980fb82aeeff1aa43579e;
401 
402     string private constant ERROR_ALREADY_INITIALIZED = "INIT_ALREADY_INITIALIZED";
403     string private constant ERROR_NOT_INITIALIZED = "INIT_NOT_INITIALIZED";
404 
405     modifier onlyInit {
406         require(getInitializationBlock() == 0, ERROR_ALREADY_INITIALIZED);
407         _;
408     }
409 
410     modifier isInitialized {
411         require(hasInitialized(), ERROR_NOT_INITIALIZED);
412         _;
413     }
414 
415     /**
416     * @return Block number in which the contract was initialized
417     */
418     function getInitializationBlock() public view returns (uint256) {
419         return INITIALIZATION_BLOCK_POSITION.getStorageUint256();
420     }
421 
422     /**
423     * @return Whether the contract has been initialized by the time of the current block
424     */
425     function hasInitialized() public view returns (bool) {
426         uint256 initializationBlock = getInitializationBlock();
427         return initializationBlock != 0 && getBlockNumber() >= initializationBlock;
428     }
429 
430     /**
431     * @dev Function to be called by top level contract after initialization has finished.
432     */
433     function initialized() internal onlyInit {
434         INITIALIZATION_BLOCK_POSITION.setStorageUint256(getBlockNumber());
435     }
436 
437     /**
438     * @dev Function to be called by top level contract after initialization to enable the contract
439     *      at a future block number rather than immediately.
440     */
441     function initializedAt(uint256 _blockNumber) internal onlyInit {
442         INITIALIZATION_BLOCK_POSITION.setStorageUint256(_blockNumber);
443     }
444 }
445 
446 // File: contracts/common/Petrifiable.sol
447 
448 /*
449  * SPDX-License-Identitifer:    MIT
450  */
451 
452 pragma solidity ^0.4.24;
453 
454 
455 
456 contract Petrifiable is Initializable {
457     // Use block UINT256_MAX (which should be never) as the initializable date
458     uint256 internal constant PETRIFIED_BLOCK = uint256(-1);
459 
460     function isPetrified() public view returns (bool) {
461         return getInitializationBlock() == PETRIFIED_BLOCK;
462     }
463 
464     /**
465     * @dev Function to be called by top level contract to prevent being initialized.
466     *      Useful for freezing base contracts when they're used behind proxies.
467     */
468     function petrify() internal onlyInit {
469         initializedAt(PETRIFIED_BLOCK);
470     }
471 }
472 
473 // File: contracts/lib/token/ERC20.sol
474 
475 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/a9f910d34f0ab33a1ae5e714f69f9596a02b4d91/contracts/token/ERC20/ERC20.sol
476 
477 pragma solidity ^0.4.24;
478 
479 
480 /**
481  * @title ERC20 interface
482  * @dev see https://github.com/ethereum/EIPs/issues/20
483  */
484 contract ERC20 {
485     function totalSupply() public view returns (uint256);
486 
487     function balanceOf(address _who) public view returns (uint256);
488 
489     function allowance(address _owner, address _spender)
490         public view returns (uint256);
491 
492     function transfer(address _to, uint256 _value) public returns (bool);
493 
494     function approve(address _spender, uint256 _value)
495         public returns (bool);
496 
497     function transferFrom(address _from, address _to, uint256 _value)
498         public returns (bool);
499 
500     event Transfer(
501         address indexed from,
502         address indexed to,
503         uint256 value
504     );
505 
506     event Approval(
507         address indexed owner,
508         address indexed spender,
509         uint256 value
510     );
511 }
512 
513 // File: contracts/common/EtherTokenConstant.sol
514 
515 /*
516  * SPDX-License-Identitifer:    MIT
517  */
518 
519 pragma solidity ^0.4.24;
520 
521 
522 // aragonOS and aragon-apps rely on address(0) to denote native ETH, in
523 // contracts where both tokens and ETH are accepted
524 contract EtherTokenConstant {
525     address internal constant ETH = address(0);
526 }
527 
528 // File: contracts/common/SafeERC20.sol
529 
530 // Inspired by AdEx (https://github.com/AdExNetwork/adex-protocol-eth/blob/b9df617829661a7518ee10f4cb6c4108659dd6d5/contracts/libs/SafeERC20.sol)
531 // and 0x (https://github.com/0xProject/0x-monorepo/blob/737d1dc54d72872e24abce5a1dbe1b66d35fa21a/contracts/protocol/contracts/protocol/AssetProxy/ERC20Proxy.sol#L143)
532 
533 pragma solidity ^0.4.24;
534 
535 
536 
537 library SafeERC20 {
538     // Before 0.5, solidity has a mismatch between `address.transfer()` and `token.transfer()`:
539     // https://github.com/ethereum/solidity/issues/3544
540     bytes4 private constant TRANSFER_SELECTOR = 0xa9059cbb;
541 
542     string private constant ERROR_TOKEN_BALANCE_REVERTED = "SAFE_ERC_20_BALANCE_REVERTED";
543     string private constant ERROR_TOKEN_ALLOWANCE_REVERTED = "SAFE_ERC_20_ALLOWANCE_REVERTED";
544 
545     function invokeAndCheckSuccess(address _addr, bytes memory _calldata)
546         private
547         returns (bool)
548     {
549         bool ret;
550         assembly {
551             let ptr := mload(0x40)    // free memory pointer
552 
553             let success := call(
554                 gas,                  // forward all gas
555                 _addr,                // address
556                 0,                    // no value
557                 add(_calldata, 0x20), // calldata start
558                 mload(_calldata),     // calldata length
559                 ptr,                  // write output over free memory
560                 0x20                  // uint256 return
561             )
562 
563             if gt(success, 0) {
564                 // Check number of bytes returned from last function call
565                 switch returndatasize
566 
567                 // No bytes returned: assume success
568                 case 0 {
569                     ret := 1
570                 }
571 
572                 // 32 bytes returned: check if non-zero
573                 case 0x20 {
574                     // Only return success if returned data was true
575                     // Already have output in ptr
576                     ret := eq(mload(ptr), 1)
577                 }
578 
579                 // Not sure what was returned: don't mark as success
580                 default { }
581             }
582         }
583         return ret;
584     }
585 
586     function staticInvoke(address _addr, bytes memory _calldata)
587         private
588         view
589         returns (bool, uint256)
590     {
591         bool success;
592         uint256 ret;
593         assembly {
594             let ptr := mload(0x40)    // free memory pointer
595 
596             success := staticcall(
597                 gas,                  // forward all gas
598                 _addr,                // address
599                 add(_calldata, 0x20), // calldata start
600                 mload(_calldata),     // calldata length
601                 ptr,                  // write output over free memory
602                 0x20                  // uint256 return
603             )
604 
605             if gt(success, 0) {
606                 ret := mload(ptr)
607             }
608         }
609         return (success, ret);
610     }
611 
612     /**
613     * @dev Same as a standards-compliant ERC20.transfer() that never reverts (returns false).
614     *      Note that this makes an external call to the token.
615     */
616     function safeTransfer(ERC20 _token, address _to, uint256 _amount) internal returns (bool) {
617         bytes memory transferCallData = abi.encodeWithSelector(
618             TRANSFER_SELECTOR,
619             _to,
620             _amount
621         );
622         return invokeAndCheckSuccess(_token, transferCallData);
623     }
624 
625     /**
626     * @dev Same as a standards-compliant ERC20.transferFrom() that never reverts (returns false).
627     *      Note that this makes an external call to the token.
628     */
629     function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {
630         bytes memory transferFromCallData = abi.encodeWithSelector(
631             _token.transferFrom.selector,
632             _from,
633             _to,
634             _amount
635         );
636         return invokeAndCheckSuccess(_token, transferFromCallData);
637     }
638 
639     /**
640     * @dev Same as a standards-compliant ERC20.approve() that never reverts (returns false).
641     *      Note that this makes an external call to the token.
642     */
643     function safeApprove(ERC20 _token, address _spender, uint256 _amount) internal returns (bool) {
644         bytes memory approveCallData = abi.encodeWithSelector(
645             _token.approve.selector,
646             _spender,
647             _amount
648         );
649         return invokeAndCheckSuccess(_token, approveCallData);
650     }
651 
652     /**
653     * @dev Static call into ERC20.balanceOf().
654     * Reverts if the call fails for some reason (should never fail).
655     */
656     function staticBalanceOf(ERC20 _token, address _owner) internal view returns (uint256) {
657         bytes memory balanceOfCallData = abi.encodeWithSelector(
658             _token.balanceOf.selector,
659             _owner
660         );
661 
662         (bool success, uint256 tokenBalance) = staticInvoke(_token, balanceOfCallData);
663         require(success, ERROR_TOKEN_BALANCE_REVERTED);
664 
665         return tokenBalance;
666     }
667 
668     /**
669     * @dev Static call into ERC20.allowance().
670     * Reverts if the call fails for some reason (should never fail).
671     */
672     function staticAllowance(ERC20 _token, address _owner, address _spender) internal view returns (uint256) {
673         bytes memory allowanceCallData = abi.encodeWithSelector(
674             _token.allowance.selector,
675             _owner,
676             _spender
677         );
678 
679         (bool success, uint256 allowance) = staticInvoke(_token, allowanceCallData);
680         require(success, ERROR_TOKEN_ALLOWANCE_REVERTED);
681 
682         return allowance;
683     }
684 
685     /**
686     * @dev Static call into ERC20.totalSupply().
687     * Reverts if the call fails for some reason (should never fail).
688     */
689     function staticTotalSupply(ERC20 _token) internal view returns (uint256) {
690         bytes memory totalSupplyCallData = abi.encodeWithSelector(_token.totalSupply.selector);
691 
692         (bool success, uint256 totalSupply) = staticInvoke(_token, totalSupplyCallData);
693         require(success, ERROR_TOKEN_ALLOWANCE_REVERTED);
694 
695         return totalSupply;
696     }
697 }
698 
699 // File: contracts/common/VaultRecoverable.sol
700 
701 /*
702  * SPDX-License-Identitifer:    MIT
703  */
704 
705 pragma solidity ^0.4.24;
706 
707 
708 
709 
710 
711 
712 
713 contract VaultRecoverable is IVaultRecoverable, EtherTokenConstant, IsContract {
714     using SafeERC20 for ERC20;
715 
716     string private constant ERROR_DISALLOWED = "RECOVER_DISALLOWED";
717     string private constant ERROR_VAULT_NOT_CONTRACT = "RECOVER_VAULT_NOT_CONTRACT";
718     string private constant ERROR_TOKEN_TRANSFER_FAILED = "RECOVER_TOKEN_TRANSFER_FAILED";
719 
720     /**
721      * @notice Send funds to recovery Vault. This contract should never receive funds,
722      *         but in case it does, this function allows one to recover them.
723      * @param _token Token balance to be sent to recovery vault.
724      */
725     function transferToVault(address _token) external {
726         require(allowRecoverability(_token), ERROR_DISALLOWED);
727         address vault = getRecoveryVault();
728         require(isContract(vault), ERROR_VAULT_NOT_CONTRACT);
729 
730         uint256 balance;
731         if (_token == ETH) {
732             balance = address(this).balance;
733             vault.transfer(balance);
734         } else {
735             ERC20 token = ERC20(_token);
736             balance = token.staticBalanceOf(this);
737             require(token.safeTransfer(vault, balance), ERROR_TOKEN_TRANSFER_FAILED);
738         }
739 
740         emit RecoverToVault(vault, _token, balance);
741     }
742 
743     /**
744     * @dev By default deriving from AragonApp makes it recoverable
745     * @param token Token address that would be recovered
746     * @return bool whether the app allows the recovery
747     */
748     function allowRecoverability(address token) public view returns (bool) {
749         return true;
750     }
751 
752     // Cast non-implemented interface to be public so we can use it internally
753     function getRecoveryVault() public view returns (address);
754 }
755 
756 // File: contracts/apps/AppStorage.sol
757 
758 /*
759  * SPDX-License-Identitifer:    MIT
760  */
761 
762 pragma solidity ^0.4.24;
763 
764 
765 
766 
767 contract AppStorage {
768     using UnstructuredStorage for bytes32;
769 
770     /* Hardcoded constants to save gas
771     bytes32 internal constant KERNEL_POSITION = keccak256("aragonOS.appStorage.kernel");
772     bytes32 internal constant APP_ID_POSITION = keccak256("aragonOS.appStorage.appId");
773     */
774     bytes32 internal constant KERNEL_POSITION = 0x4172f0f7d2289153072b0a6ca36959e0cbe2efc3afe50fc81636caa96338137b;
775     bytes32 internal constant APP_ID_POSITION = 0xd625496217aa6a3453eecb9c3489dc5a53e6c67b444329ea2b2cbc9ff547639b;
776 
777     function kernel() public view returns (IKernel) {
778         return IKernel(KERNEL_POSITION.getStorageAddress());
779     }
780 
781     function appId() public view returns (bytes32) {
782         return APP_ID_POSITION.getStorageBytes32();
783     }
784 
785     function setKernel(IKernel _kernel) internal {
786         KERNEL_POSITION.setStorageAddress(address(_kernel));
787     }
788 
789     function setAppId(bytes32 _appId) internal {
790         APP_ID_POSITION.setStorageBytes32(_appId);
791     }
792 }
793 
794 // File: contracts/lib/misc/ERCProxy.sol
795 
796 /*
797  * SPDX-License-Identitifer:    MIT
798  */
799 
800 pragma solidity ^0.4.24;
801 
802 
803 contract ERCProxy {
804     uint256 internal constant FORWARDING = 1;
805     uint256 internal constant UPGRADEABLE = 2;
806 
807     function proxyType() public pure returns (uint256 proxyTypeId);
808     function implementation() public view returns (address codeAddr);
809 }
810 
811 // File: contracts/common/DelegateProxy.sol
812 
813 pragma solidity 0.4.24;
814 
815 
816 
817 
818 contract DelegateProxy is ERCProxy, IsContract {
819     uint256 internal constant FWD_GAS_LIMIT = 10000;
820 
821     /**
822     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
823     * @param _dst Destination address to perform the delegatecall
824     * @param _calldata Calldata for the delegatecall
825     */
826     function delegatedFwd(address _dst, bytes _calldata) internal {
827         require(isContract(_dst));
828         uint256 fwdGasLimit = FWD_GAS_LIMIT;
829 
830         assembly {
831             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
832             let size := returndatasize
833             let ptr := mload(0x40)
834             returndatacopy(ptr, 0, size)
835 
836             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
837             // if the call returned error data, forward it
838             switch result case 0 { revert(ptr, size) }
839             default { return(ptr, size) }
840         }
841     }
842 }
843 
844 // File: contracts/common/DepositableStorage.sol
845 
846 pragma solidity 0.4.24;
847 
848 
849 
850 contract DepositableStorage {
851     using UnstructuredStorage for bytes32;
852 
853     // keccak256("aragonOS.depositableStorage.depositable")
854     bytes32 internal constant DEPOSITABLE_POSITION = 0x665fd576fbbe6f247aff98f5c94a561e3f71ec2d3c988d56f12d342396c50cea;
855 
856     function isDepositable() public view returns (bool) {
857         return DEPOSITABLE_POSITION.getStorageBool();
858     }
859 
860     function setDepositable(bool _depositable) internal {
861         DEPOSITABLE_POSITION.setStorageBool(_depositable);
862     }
863 }
864 
865 // File: contracts/common/DepositableDelegateProxy.sol
866 
867 pragma solidity 0.4.24;
868 
869 
870 
871 
872 contract DepositableDelegateProxy is DepositableStorage, DelegateProxy {
873     event ProxyDeposit(address sender, uint256 value);
874 
875     function () external payable {
876         uint256 forwardGasThreshold = FWD_GAS_LIMIT;
877         bytes32 isDepositablePosition = DEPOSITABLE_POSITION;
878 
879         // Optimized assembly implementation to prevent EIP-1884 from breaking deposits, reference code in Solidity:
880         // https://github.com/aragon/aragonOS/blob/v4.2.1/contracts/common/DepositableDelegateProxy.sol#L10-L20
881         assembly {
882             // Continue only if the gas left is lower than the threshold for forwarding to the implementation code,
883             // otherwise continue outside of the assembly block.
884             if lt(gas, forwardGasThreshold) {
885                 // Only accept the deposit and emit an event if all of the following are true:
886                 // the proxy accepts deposits (isDepositable), msg.data.length == 0, and msg.value > 0
887                 if and(and(sload(isDepositablePosition), iszero(calldatasize)), gt(callvalue, 0)) {
888                     // Equivalent Solidity code for emitting the event:
889                     // emit ProxyDeposit(msg.sender, msg.value);
890 
891                     let logData := mload(0x40) // free memory pointer
892                     mstore(logData, caller) // add 'msg.sender' to the log data (first event param)
893                     mstore(add(logData, 0x20), callvalue) // add 'msg.value' to the log data (second event param)
894 
895                     // Emit an event with one topic to identify the event: keccak256('ProxyDeposit(address,uint256)') = 0x15ee...dee1
896                     log1(logData, 0x40, 0x15eeaa57c7bd188c1388020bcadc2c436ec60d647d36ef5b9eb3c742217ddee1)
897 
898                     stop() // Stop. Exits execution context
899                 }
900 
901                 // If any of above checks failed, revert the execution (if ETH was sent, it is returned to the sender)
902                 revert(0, 0)
903             }
904         }
905 
906         address target = implementation();
907         delegatedFwd(target, msg.data);
908     }
909 }
910 
911 // File: contracts/apps/AppProxyBase.sol
912 
913 pragma solidity 0.4.24;
914 
915 
916 
917 
918 
919 
920 contract AppProxyBase is AppStorage, DepositableDelegateProxy, KernelNamespaceConstants {
921     /**
922     * @dev Initialize AppProxy
923     * @param _kernel Reference to organization kernel for the app
924     * @param _appId Identifier for app
925     * @param _initializePayload Payload for call to be made after setup to initialize
926     */
927     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public {
928         setKernel(_kernel);
929         setAppId(_appId);
930 
931         // Implicit check that kernel is actually a Kernel
932         // The EVM doesn't actually provide a way for us to make sure, but we can force a revert to
933         // occur if the kernel is set to 0x0 or a non-code address when we try to call a method on
934         // it.
935         address appCode = getAppBase(_appId);
936 
937         // If initialize payload is provided, it will be executed
938         if (_initializePayload.length > 0) {
939             require(isContract(appCode));
940             // Cannot make delegatecall as a delegateproxy.delegatedFwd as it
941             // returns ending execution context and halts contract deployment
942             require(appCode.delegatecall(_initializePayload));
943         }
944     }
945 
946     function getAppBase(bytes32 _appId) internal view returns (address) {
947         return kernel().getApp(KERNEL_APP_BASES_NAMESPACE, _appId);
948     }
949 }
950 
951 // File: contracts/apps/AppProxyUpgradeable.sol
952 
953 pragma solidity 0.4.24;
954 
955 
956 
957 contract AppProxyUpgradeable is AppProxyBase {
958     /**
959     * @dev Initialize AppProxyUpgradeable (makes it an upgradeable Aragon app)
960     * @param _kernel Reference to organization kernel for the app
961     * @param _appId Identifier for app
962     * @param _initializePayload Payload for call to be made after setup to initialize
963     */
964     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
965         AppProxyBase(_kernel, _appId, _initializePayload)
966         public // solium-disable-line visibility-first
967     {
968         // solium-disable-previous-line no-empty-blocks
969     }
970 
971     /**
972      * @dev ERC897, the address the proxy would delegate calls to
973      */
974     function implementation() public view returns (address) {
975         return getAppBase(appId());
976     }
977 
978     /**
979      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
980      */
981     function proxyType() public pure returns (uint256 proxyTypeId) {
982         return UPGRADEABLE;
983     }
984 }
985 
986 // File: contracts/apps/AppProxyPinned.sol
987 
988 pragma solidity 0.4.24;
989 
990 
991 
992 
993 
994 contract AppProxyPinned is IsContract, AppProxyBase {
995     using UnstructuredStorage for bytes32;
996 
997     // keccak256("aragonOS.appStorage.pinnedCode")
998     bytes32 internal constant PINNED_CODE_POSITION = 0xdee64df20d65e53d7f51cb6ab6d921a0a6a638a91e942e1d8d02df28e31c038e;
999 
1000     /**
1001     * @dev Initialize AppProxyPinned (makes it an un-upgradeable Aragon app)
1002     * @param _kernel Reference to organization kernel for the app
1003     * @param _appId Identifier for app
1004     * @param _initializePayload Payload for call to be made after setup to initialize
1005     */
1006     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
1007         AppProxyBase(_kernel, _appId, _initializePayload)
1008         public // solium-disable-line visibility-first
1009     {
1010         setPinnedCode(getAppBase(_appId));
1011         require(isContract(pinnedCode()));
1012     }
1013 
1014     /**
1015      * @dev ERC897, the address the proxy would delegate calls to
1016      */
1017     function implementation() public view returns (address) {
1018         return pinnedCode();
1019     }
1020 
1021     /**
1022      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
1023      */
1024     function proxyType() public pure returns (uint256 proxyTypeId) {
1025         return FORWARDING;
1026     }
1027 
1028     function setPinnedCode(address _pinnedCode) internal {
1029         PINNED_CODE_POSITION.setStorageAddress(_pinnedCode);
1030     }
1031 
1032     function pinnedCode() internal view returns (address) {
1033         return PINNED_CODE_POSITION.getStorageAddress();
1034     }
1035 }
1036 
1037 // File: contracts/factory/AppProxyFactory.sol
1038 
1039 pragma solidity 0.4.24;
1040 
1041 
1042 
1043 
1044 contract AppProxyFactory {
1045     event NewAppProxy(address proxy, bool isUpgradeable, bytes32 appId);
1046 
1047     /**
1048     * @notice Create a new upgradeable app instance on `_kernel` with identifier `_appId`
1049     * @param _kernel App's Kernel reference
1050     * @param _appId Identifier for app
1051     * @return AppProxyUpgradeable
1052     */
1053     function newAppProxy(IKernel _kernel, bytes32 _appId) public returns (AppProxyUpgradeable) {
1054         return newAppProxy(_kernel, _appId, new bytes(0));
1055     }
1056 
1057     /**
1058     * @notice Create a new upgradeable app instance on `_kernel` with identifier `_appId` and initialization payload `_initializePayload`
1059     * @param _kernel App's Kernel reference
1060     * @param _appId Identifier for app
1061     * @return AppProxyUpgradeable
1062     */
1063     function newAppProxy(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyUpgradeable) {
1064         AppProxyUpgradeable proxy = new AppProxyUpgradeable(_kernel, _appId, _initializePayload);
1065         emit NewAppProxy(address(proxy), true, _appId);
1066         return proxy;
1067     }
1068 
1069     /**
1070     * @notice Create a new pinned app instance on `_kernel` with identifier `_appId`
1071     * @param _kernel App's Kernel reference
1072     * @param _appId Identifier for app
1073     * @return AppProxyPinned
1074     */
1075     function newAppProxyPinned(IKernel _kernel, bytes32 _appId) public returns (AppProxyPinned) {
1076         return newAppProxyPinned(_kernel, _appId, new bytes(0));
1077     }
1078 
1079     /**
1080     * @notice Create a new pinned app instance on `_kernel` with identifier `_appId` and initialization payload `_initializePayload`
1081     * @param _kernel App's Kernel reference
1082     * @param _appId Identifier for app
1083     * @param _initializePayload Proxy initialization payload
1084     * @return AppProxyPinned
1085     */
1086     function newAppProxyPinned(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyPinned) {
1087         AppProxyPinned proxy = new AppProxyPinned(_kernel, _appId, _initializePayload);
1088         emit NewAppProxy(address(proxy), false, _appId);
1089         return proxy;
1090     }
1091 }
1092 
1093 // File: contracts/kernel/Kernel.sol
1094 
1095 pragma solidity 0.4.24;
1096 
1097 
1098 
1099 
1100 
1101 
1102 
1103 
1104 
1105 
1106 
1107 
1108 
1109 // solium-disable-next-line max-len
1110 contract Kernel is IKernel, KernelStorage, KernelAppIds, KernelNamespaceConstants, Petrifiable, IsContract, VaultRecoverable, AppProxyFactory, ACLSyntaxSugar {
1111     /* Hardcoded constants to save gas
1112     bytes32 public constant APP_MANAGER_ROLE = keccak256("APP_MANAGER_ROLE");
1113     */
1114     bytes32 public constant APP_MANAGER_ROLE = 0xb6d92708f3d4817afc106147d969e229ced5c46e65e0a5002a0d391287762bd0;
1115 
1116     string private constant ERROR_APP_NOT_CONTRACT = "KERNEL_APP_NOT_CONTRACT";
1117     string private constant ERROR_INVALID_APP_CHANGE = "KERNEL_INVALID_APP_CHANGE";
1118     string private constant ERROR_AUTH_FAILED = "KERNEL_AUTH_FAILED";
1119 
1120     /**
1121     * @dev Constructor that allows the deployer to choose if the base instance should be petrified immediately.
1122     * @param _shouldPetrify Immediately petrify this instance so that it can never be initialized
1123     */
1124     constructor(bool _shouldPetrify) public {
1125         if (_shouldPetrify) {
1126             petrify();
1127         }
1128     }
1129 
1130     /**
1131     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
1132     * @notice Initialize this kernel instance along with its ACL and set `_permissionsCreator` as the entity that can create other permissions
1133     * @param _baseAcl Address of base ACL app
1134     * @param _permissionsCreator Entity that will be given permission over createPermission
1135     */
1136     function initialize(IACL _baseAcl, address _permissionsCreator) public onlyInit {
1137         initialized();
1138 
1139         // Set ACL base
1140         _setApp(KERNEL_APP_BASES_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, _baseAcl);
1141 
1142         // Create ACL instance and attach it as the default ACL app
1143         IACL acl = IACL(newAppProxy(this, KERNEL_DEFAULT_ACL_APP_ID));
1144         acl.initialize(_permissionsCreator);
1145         _setApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, acl);
1146 
1147         recoveryVaultAppId = KERNEL_DEFAULT_VAULT_APP_ID;
1148     }
1149 
1150     /**
1151     * @dev Create a new instance of an app linked to this kernel
1152     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`
1153     * @param _appId Identifier for app
1154     * @param _appBase Address of the app's base implementation
1155     * @return AppProxy instance
1156     */
1157     function newAppInstance(bytes32 _appId, address _appBase)
1158         public
1159         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
1160         returns (ERCProxy appProxy)
1161     {
1162         return newAppInstance(_appId, _appBase, new bytes(0), false);
1163     }
1164 
1165     /**
1166     * @dev Create a new instance of an app linked to this kernel and set its base
1167     *      implementation if it was not already set
1168     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
1169     * @param _appId Identifier for app
1170     * @param _appBase Address of the app's base implementation
1171     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
1172     * @param _setDefault Whether the app proxy app is the default one.
1173     *        Useful when the Kernel needs to know of an instance of a particular app,
1174     *        like Vault for escape hatch mechanism.
1175     * @return AppProxy instance
1176     */
1177     function newAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
1178         public
1179         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
1180         returns (ERCProxy appProxy)
1181     {
1182         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
1183         appProxy = newAppProxy(this, _appId, _initializePayload);
1184         // By calling setApp directly and not the internal functions, we make sure the params are checked
1185         // and it will only succeed if sender has permissions to set something to the namespace.
1186         if (_setDefault) {
1187             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
1188         }
1189     }
1190 
1191     /**
1192     * @dev Create a new pinned instance of an app linked to this kernel
1193     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`.
1194     * @param _appId Identifier for app
1195     * @param _appBase Address of the app's base implementation
1196     * @return AppProxy instance
1197     */
1198     function newPinnedAppInstance(bytes32 _appId, address _appBase)
1199         public
1200         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
1201         returns (ERCProxy appProxy)
1202     {
1203         return newPinnedAppInstance(_appId, _appBase, new bytes(0), false);
1204     }
1205 
1206     /**
1207     * @dev Create a new pinned instance of an app linked to this kernel and set
1208     *      its base implementation if it was not already set
1209     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
1210     * @param _appId Identifier for app
1211     * @param _appBase Address of the app's base implementation
1212     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
1213     * @param _setDefault Whether the app proxy app is the default one.
1214     *        Useful when the Kernel needs to know of an instance of a particular app,
1215     *        like Vault for escape hatch mechanism.
1216     * @return AppProxy instance
1217     */
1218     function newPinnedAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
1219         public
1220         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
1221         returns (ERCProxy appProxy)
1222     {
1223         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
1224         appProxy = newAppProxyPinned(this, _appId, _initializePayload);
1225         // By calling setApp directly and not the internal functions, we make sure the params are checked
1226         // and it will only succeed if sender has permissions to set something to the namespace.
1227         if (_setDefault) {
1228             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
1229         }
1230     }
1231 
1232     /**
1233     * @dev Set the resolving address of an app instance or base implementation
1234     * @notice Set the resolving address of `_appId` in namespace `_namespace` to `_app`
1235     * @param _namespace App namespace to use
1236     * @param _appId Identifier for app
1237     * @param _app Address of the app instance or base implementation
1238     * @return ID of app
1239     */
1240     function setApp(bytes32 _namespace, bytes32 _appId, address _app)
1241         public
1242         auth(APP_MANAGER_ROLE, arr(_namespace, _appId))
1243     {
1244         _setApp(_namespace, _appId, _app);
1245     }
1246 
1247     /**
1248     * @dev Set the default vault id for the escape hatch mechanism
1249     * @param _recoveryVaultAppId Identifier of the recovery vault app
1250     */
1251     function setRecoveryVaultAppId(bytes32 _recoveryVaultAppId)
1252         public
1253         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_ADDR_NAMESPACE, _recoveryVaultAppId))
1254     {
1255         recoveryVaultAppId = _recoveryVaultAppId;
1256     }
1257 
1258     // External access to default app id and namespace constants to mimic default getters for constants
1259     /* solium-disable function-order, mixedcase */
1260     function CORE_NAMESPACE() external pure returns (bytes32) { return KERNEL_CORE_NAMESPACE; }
1261     function APP_BASES_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_BASES_NAMESPACE; }
1262     function APP_ADDR_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_ADDR_NAMESPACE; }
1263     function KERNEL_APP_ID() external pure returns (bytes32) { return KERNEL_CORE_APP_ID; }
1264     function DEFAULT_ACL_APP_ID() external pure returns (bytes32) { return KERNEL_DEFAULT_ACL_APP_ID; }
1265     /* solium-enable function-order, mixedcase */
1266 
1267     /**
1268     * @dev Get the address of an app instance or base implementation
1269     * @param _namespace App namespace to use
1270     * @param _appId Identifier for app
1271     * @return Address of the app
1272     */
1273     function getApp(bytes32 _namespace, bytes32 _appId) public view returns (address) {
1274         return apps[_namespace][_appId];
1275     }
1276 
1277     /**
1278     * @dev Get the address of the recovery Vault instance (to recover funds)
1279     * @return Address of the Vault
1280     */
1281     function getRecoveryVault() public view returns (address) {
1282         return apps[KERNEL_APP_ADDR_NAMESPACE][recoveryVaultAppId];
1283     }
1284 
1285     /**
1286     * @dev Get the installed ACL app
1287     * @return ACL app
1288     */
1289     function acl() public view returns (IACL) {
1290         return IACL(getApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID));
1291     }
1292 
1293     /**
1294     * @dev Function called by apps to check ACL on kernel or to check permission status
1295     * @param _who Sender of the original call
1296     * @param _where Address of the app
1297     * @param _what Identifier for a group of actions in app
1298     * @param _how Extra data for ACL auth
1299     * @return Boolean indicating whether the ACL allows the role or not.
1300     *         Always returns false if the kernel hasn't been initialized yet.
1301     */
1302     function hasPermission(address _who, address _where, bytes32 _what, bytes _how) public view returns (bool) {
1303         IACL defaultAcl = acl();
1304         return address(defaultAcl) != address(0) && // Poor man's initialization check (saves gas)
1305             defaultAcl.hasPermission(_who, _where, _what, _how);
1306     }
1307 
1308     function _setApp(bytes32 _namespace, bytes32 _appId, address _app) internal {
1309         require(isContract(_app), ERROR_APP_NOT_CONTRACT);
1310         apps[_namespace][_appId] = _app;
1311         emit SetApp(_namespace, _appId, _app);
1312     }
1313 
1314     function _setAppIfNew(bytes32 _namespace, bytes32 _appId, address _app) internal {
1315         address app = getApp(_namespace, _appId);
1316         if (app != address(0)) {
1317             // The only way to set an app is if it passes the isContract check, so no need to check it again
1318             require(app == _app, ERROR_INVALID_APP_CHANGE);
1319         } else {
1320             _setApp(_namespace, _appId, _app);
1321         }
1322     }
1323 
1324     modifier auth(bytes32 _role, uint256[] memory _params) {
1325         require(
1326             hasPermission(msg.sender, address(this), _role, ConversionHelpers.dangerouslyCastUintArrayToBytes(_params)),
1327             ERROR_AUTH_FAILED
1328         );
1329         _;
1330     }
1331 }
1332 
1333 // File: contracts/kernel/KernelProxy.sol
1334 
1335 pragma solidity 0.4.24;
1336 
1337 
1338 
1339 
1340 
1341 
1342 
1343 contract KernelProxy is IKernelEvents, KernelStorage, KernelAppIds, KernelNamespaceConstants, IsContract, DepositableDelegateProxy {
1344     /**
1345     * @dev KernelProxy is a proxy contract to a kernel implementation. The implementation
1346     *      can update the reference, which effectively upgrades the contract
1347     * @param _kernelImpl Address of the contract used as implementation for kernel
1348     */
1349     constructor(IKernel _kernelImpl) public {
1350         require(isContract(address(_kernelImpl)));
1351         apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID] = _kernelImpl;
1352 
1353         // Note that emitting this event is important for verifying that a KernelProxy instance
1354         // was never upgraded to a malicious Kernel logic contract over its lifespan.
1355         // This starts the "chain of trust", that can be followed through later SetApp() events
1356         // emitted during kernel upgrades.
1357         emit SetApp(KERNEL_CORE_NAMESPACE, KERNEL_CORE_APP_ID, _kernelImpl);
1358     }
1359 
1360     /**
1361      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
1362      */
1363     function proxyType() public pure returns (uint256 proxyTypeId) {
1364         return UPGRADEABLE;
1365     }
1366 
1367     /**
1368     * @dev ERC897, the address the proxy would delegate calls to
1369     */
1370     function implementation() public view returns (address) {
1371         return apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID];
1372     }
1373 }
1374 
1375 // File: contracts/common/Autopetrified.sol
1376 
1377 /*
1378  * SPDX-License-Identitifer:    MIT
1379  */
1380 
1381 pragma solidity ^0.4.24;
1382 
1383 
1384 
1385 contract Autopetrified is Petrifiable {
1386     constructor() public {
1387         // Immediately petrify base (non-proxy) instances of inherited contracts on deploy.
1388         // This renders them uninitializable (and unusable without a proxy).
1389         petrify();
1390     }
1391 }
1392 
1393 // File: contracts/common/ReentrancyGuard.sol
1394 
1395 /*
1396  * SPDX-License-Identitifer:    MIT
1397  */
1398 
1399 pragma solidity ^0.4.24;
1400 
1401 
1402 
1403 contract ReentrancyGuard {
1404     using UnstructuredStorage for bytes32;
1405 
1406     /* Hardcoded constants to save gas
1407     bytes32 internal constant REENTRANCY_MUTEX_POSITION = keccak256("aragonOS.reentrancyGuard.mutex");
1408     */
1409     bytes32 private constant REENTRANCY_MUTEX_POSITION = 0xe855346402235fdd185c890e68d2c4ecad599b88587635ee285bce2fda58dacb;
1410 
1411     string private constant ERROR_REENTRANT = "REENTRANCY_REENTRANT_CALL";
1412 
1413     modifier nonReentrant() {
1414         // Ensure mutex is unlocked
1415         require(!REENTRANCY_MUTEX_POSITION.getStorageBool(), ERROR_REENTRANT);
1416 
1417         // Lock mutex before function call
1418         REENTRANCY_MUTEX_POSITION.setStorageBool(true);
1419 
1420         // Perform function call
1421         _;
1422 
1423         // Unlock mutex after function call
1424         REENTRANCY_MUTEX_POSITION.setStorageBool(false);
1425     }
1426 }
1427 
1428 // File: contracts/evmscript/IEVMScriptExecutor.sol
1429 
1430 /*
1431  * SPDX-License-Identitifer:    MIT
1432  */
1433 
1434 pragma solidity ^0.4.24;
1435 
1436 
1437 interface IEVMScriptExecutor {
1438     function execScript(bytes script, bytes input, address[] blacklist) external returns (bytes);
1439     function executorType() external pure returns (bytes32);
1440 }
1441 
1442 // File: contracts/evmscript/IEVMScriptRegistry.sol
1443 
1444 /*
1445  * SPDX-License-Identitifer:    MIT
1446  */
1447 
1448 pragma solidity ^0.4.24;
1449 
1450 
1451 
1452 contract EVMScriptRegistryConstants {
1453     /* Hardcoded constants to save gas
1454     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = apmNamehash("evmreg");
1455     */
1456     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = 0xddbcfd564f642ab5627cf68b9b7d374fb4f8a36e941a75d89c87998cef03bd61;
1457 }
1458 
1459 
1460 interface IEVMScriptRegistry {
1461     function addScriptExecutor(IEVMScriptExecutor executor) external returns (uint id);
1462     function disableScriptExecutor(uint256 executorId) external;
1463 
1464     // TODO: this should be external
1465     // See https://github.com/ethereum/solidity/issues/4832
1466     function getScriptExecutor(bytes script) public view returns (IEVMScriptExecutor);
1467 }
1468 
1469 // File: contracts/evmscript/EVMScriptRunner.sol
1470 
1471 /*
1472  * SPDX-License-Identitifer:    MIT
1473  */
1474 
1475 pragma solidity ^0.4.24;
1476 
1477 
1478 
1479 
1480 
1481 
1482 
1483 contract EVMScriptRunner is AppStorage, Initializable, EVMScriptRegistryConstants, KernelNamespaceConstants {
1484     string private constant ERROR_EXECUTOR_UNAVAILABLE = "EVMRUN_EXECUTOR_UNAVAILABLE";
1485     string private constant ERROR_PROTECTED_STATE_MODIFIED = "EVMRUN_PROTECTED_STATE_MODIFIED";
1486 
1487     /* This is manually crafted in assembly
1488     string private constant ERROR_EXECUTOR_INVALID_RETURN = "EVMRUN_EXECUTOR_INVALID_RETURN";
1489     */
1490 
1491     event ScriptResult(address indexed executor, bytes script, bytes input, bytes returnData);
1492 
1493     function getEVMScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
1494         return IEVMScriptExecutor(getEVMScriptRegistry().getScriptExecutor(_script));
1495     }
1496 
1497     function getEVMScriptRegistry() public view returns (IEVMScriptRegistry) {
1498         address registryAddr = kernel().getApp(KERNEL_APP_ADDR_NAMESPACE, EVMSCRIPT_REGISTRY_APP_ID);
1499         return IEVMScriptRegistry(registryAddr);
1500     }
1501 
1502     function runScript(bytes _script, bytes _input, address[] _blacklist)
1503         internal
1504         isInitialized
1505         protectState
1506         returns (bytes)
1507     {
1508         IEVMScriptExecutor executor = getEVMScriptExecutor(_script);
1509         require(address(executor) != address(0), ERROR_EXECUTOR_UNAVAILABLE);
1510 
1511         bytes4 sig = executor.execScript.selector;
1512         bytes memory data = abi.encodeWithSelector(sig, _script, _input, _blacklist);
1513 
1514         bytes memory output;
1515         assembly {
1516             let success := delegatecall(
1517                 gas,                // forward all gas
1518                 executor,           // address
1519                 add(data, 0x20),    // calldata start
1520                 mload(data),        // calldata length
1521                 0,                  // don't write output (we'll handle this ourselves)
1522                 0                   // don't write output
1523             )
1524 
1525             output := mload(0x40) // free mem ptr get
1526 
1527             switch success
1528             case 0 {
1529                 // If the call errored, forward its full error data
1530                 returndatacopy(output, 0, returndatasize)
1531                 revert(output, returndatasize)
1532             }
1533             default {
1534                 switch gt(returndatasize, 0x3f)
1535                 case 0 {
1536                     // Need at least 0x40 bytes returned for properly ABI-encoded bytes values,
1537                     // revert with "EVMRUN_EXECUTOR_INVALID_RETURN"
1538                     // See remix: doing a `revert("EVMRUN_EXECUTOR_INVALID_RETURN")` always results in
1539                     // this memory layout
1540                     mstore(output, 0x08c379a000000000000000000000000000000000000000000000000000000000)         // error identifier
1541                     mstore(add(output, 0x04), 0x0000000000000000000000000000000000000000000000000000000000000020) // starting offset
1542                     mstore(add(output, 0x24), 0x000000000000000000000000000000000000000000000000000000000000001e) // reason length
1543                     mstore(add(output, 0x44), 0x45564d52554e5f4558454355544f525f494e56414c49445f52455455524e0000) // reason
1544 
1545                     revert(output, 100) // 100 = 4 + 3 * 32 (error identifier + 3 words for the ABI encoded error)
1546                 }
1547                 default {
1548                     // Copy result
1549                     //
1550                     // Needs to perform an ABI decode for the expected `bytes` return type of
1551                     // `executor.execScript()` as solidity will automatically ABI encode the returned bytes as:
1552                     //    [ position of the first dynamic length return value = 0x20 (32 bytes) ]
1553                     //    [ output length (32 bytes) ]
1554                     //    [ output content (N bytes) ]
1555                     //
1556                     // Perform the ABI decode by ignoring the first 32 bytes of the return data
1557                     let copysize := sub(returndatasize, 0x20)
1558                     returndatacopy(output, 0x20, copysize)
1559 
1560                     mstore(0x40, add(output, copysize)) // free mem ptr set
1561                 }
1562             }
1563         }
1564 
1565         emit ScriptResult(address(executor), _script, _input, output);
1566 
1567         return output;
1568     }
1569 
1570     modifier protectState {
1571         address preKernel = address(kernel());
1572         bytes32 preAppId = appId();
1573         _; // exec
1574         require(address(kernel()) == preKernel, ERROR_PROTECTED_STATE_MODIFIED);
1575         require(appId() == preAppId, ERROR_PROTECTED_STATE_MODIFIED);
1576     }
1577 }
1578 
1579 // File: contracts/apps/AragonApp.sol
1580 
1581 /*
1582  * SPDX-License-Identitifer:    MIT
1583  */
1584 
1585 pragma solidity ^0.4.24;
1586 
1587 
1588 
1589 
1590 
1591 
1592 
1593 
1594 
1595 // Contracts inheriting from AragonApp are, by default, immediately petrified upon deployment so
1596 // that they can never be initialized.
1597 // Unless overriden, this behaviour enforces those contracts to be usable only behind an AppProxy.
1598 // ReentrancyGuard, EVMScriptRunner, and ACLSyntaxSugar are not directly used by this contract, but
1599 // are included so that they are automatically usable by subclassing contracts
1600 contract AragonApp is AppStorage, Autopetrified, VaultRecoverable, ReentrancyGuard, EVMScriptRunner, ACLSyntaxSugar {
1601     string private constant ERROR_AUTH_FAILED = "APP_AUTH_FAILED";
1602 
1603     modifier auth(bytes32 _role) {
1604         require(canPerform(msg.sender, _role, new uint256[](0)), ERROR_AUTH_FAILED);
1605         _;
1606     }
1607 
1608     modifier authP(bytes32 _role, uint256[] _params) {
1609         require(canPerform(msg.sender, _role, _params), ERROR_AUTH_FAILED);
1610         _;
1611     }
1612 
1613     /**
1614     * @dev Check whether an action can be performed by a sender for a particular role on this app
1615     * @param _sender Sender of the call
1616     * @param _role Role on this app
1617     * @param _params Permission params for the role
1618     * @return Boolean indicating whether the sender has the permissions to perform the action.
1619     *         Always returns false if the app hasn't been initialized yet.
1620     */
1621     function canPerform(address _sender, bytes32 _role, uint256[] _params) public view returns (bool) {
1622         if (!hasInitialized()) {
1623             return false;
1624         }
1625 
1626         IKernel linkedKernel = kernel();
1627         if (address(linkedKernel) == address(0)) {
1628             return false;
1629         }
1630 
1631         return linkedKernel.hasPermission(
1632             _sender,
1633             address(this),
1634             _role,
1635             ConversionHelpers.dangerouslyCastUintArrayToBytes(_params)
1636         );
1637     }
1638 
1639     /**
1640     * @dev Get the recovery vault for the app
1641     * @return Recovery vault address for the app
1642     */
1643     function getRecoveryVault() public view returns (address) {
1644         // Funds recovery via a vault is only available when used with a kernel
1645         return kernel().getRecoveryVault(); // if kernel is not set, it will revert
1646     }
1647 }
1648 
1649 // File: contracts/acl/IACLOracle.sol
1650 
1651 /*
1652  * SPDX-License-Identitifer:    MIT
1653  */
1654 
1655 pragma solidity ^0.4.24;
1656 
1657 
1658 interface IACLOracle {
1659     function canPerform(address who, address where, bytes32 what, uint256[] how) external view returns (bool);
1660 }
1661 
1662 // File: contracts/acl/ACL.sol
1663 
1664 pragma solidity 0.4.24;
1665 
1666 
1667 
1668 
1669 
1670 
1671 
1672 
1673 /* solium-disable function-order */
1674 // Allow public initialize() to be first
1675 contract ACL is IACL, TimeHelpers, AragonApp, ACLHelpers {
1676     /* Hardcoded constants to save gas
1677     bytes32 public constant CREATE_PERMISSIONS_ROLE = keccak256("CREATE_PERMISSIONS_ROLE");
1678     */
1679     bytes32 public constant CREATE_PERMISSIONS_ROLE = 0x0b719b33c83b8e5d300c521cb8b54ae9bd933996a14bef8c2f4e0285d2d2400a;
1680 
1681     enum Op { NONE, EQ, NEQ, GT, LT, GTE, LTE, RET, NOT, AND, OR, XOR, IF_ELSE } // op types
1682 
1683     struct Param {
1684         uint8 id;
1685         uint8 op;
1686         uint240 value; // even though value is an uint240 it can store addresses
1687         // in the case of 32 byte hashes losing 2 bytes precision isn't a huge deal
1688         // op and id take less than 1 byte each so it can be kept in 1 sstore
1689     }
1690 
1691     uint8 internal constant BLOCK_NUMBER_PARAM_ID = 200;
1692     uint8 internal constant TIMESTAMP_PARAM_ID    = 201;
1693     // 202 is unused
1694     uint8 internal constant ORACLE_PARAM_ID       = 203;
1695     uint8 internal constant LOGIC_OP_PARAM_ID     = 204;
1696     uint8 internal constant PARAM_VALUE_PARAM_ID  = 205;
1697     // TODO: Add execution times param type?
1698 
1699     /* Hardcoded constant to save gas
1700     bytes32 public constant EMPTY_PARAM_HASH = keccak256(uint256(0));
1701     */
1702     bytes32 public constant EMPTY_PARAM_HASH = 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563;
1703     bytes32 public constant NO_PERMISSION = bytes32(0);
1704     address public constant ANY_ENTITY = address(-1);
1705     address public constant BURN_ENTITY = address(1); // address(0) is already used as "no permission manager"
1706 
1707     uint256 internal constant ORACLE_CHECK_GAS = 30000;
1708 
1709     string private constant ERROR_AUTH_INIT_KERNEL = "ACL_AUTH_INIT_KERNEL";
1710     string private constant ERROR_AUTH_NO_MANAGER = "ACL_AUTH_NO_MANAGER";
1711     string private constant ERROR_EXISTENT_MANAGER = "ACL_EXISTENT_MANAGER";
1712 
1713     // Whether someone has a permission
1714     mapping (bytes32 => bytes32) internal permissions; // permissions hash => params hash
1715     mapping (bytes32 => Param[]) internal permissionParams; // params hash => params
1716 
1717     // Who is the manager of a permission
1718     mapping (bytes32 => address) internal permissionManager;
1719 
1720     event SetPermission(address indexed entity, address indexed app, bytes32 indexed role, bool allowed);
1721     event SetPermissionParams(address indexed entity, address indexed app, bytes32 indexed role, bytes32 paramsHash);
1722     event ChangePermissionManager(address indexed app, bytes32 indexed role, address indexed manager);
1723 
1724     modifier onlyPermissionManager(address _app, bytes32 _role) {
1725         require(msg.sender == getPermissionManager(_app, _role), ERROR_AUTH_NO_MANAGER);
1726         _;
1727     }
1728 
1729     modifier noPermissionManager(address _app, bytes32 _role) {
1730         // only allow permission creation (or re-creation) when there is no manager
1731         require(getPermissionManager(_app, _role) == address(0), ERROR_EXISTENT_MANAGER);
1732         _;
1733     }
1734 
1735     /**
1736     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
1737     * @notice Initialize an ACL instance and set `_permissionsCreator` as the entity that can create other permissions
1738     * @param _permissionsCreator Entity that will be given permission over createPermission
1739     */
1740     function initialize(address _permissionsCreator) public onlyInit {
1741         initialized();
1742         require(msg.sender == address(kernel()), ERROR_AUTH_INIT_KERNEL);
1743 
1744         _createPermission(_permissionsCreator, this, CREATE_PERMISSIONS_ROLE, _permissionsCreator);
1745     }
1746 
1747     /**
1748     * @dev Creates a permission that wasn't previously set and managed.
1749     *      If a created permission is removed it is possible to reset it with createPermission.
1750     *      This is the **ONLY** way to create permissions and set managers to permissions that don't
1751     *      have a manager.
1752     *      In terms of the ACL being initialized, this function implicitly protects all the other
1753     *      state-changing external functions, as they all require the sender to be a manager.
1754     * @notice Create a new permission granting `_entity` the ability to perform actions requiring `_role` on `_app`, setting `_manager` as the permission's manager
1755     * @param _entity Address of the whitelisted entity that will be able to perform the role
1756     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1757     * @param _role Identifier for the group of actions in app given access to perform
1758     * @param _manager Address of the entity that will be able to grant and revoke the permission further.
1759     */
1760     function createPermission(address _entity, address _app, bytes32 _role, address _manager)
1761         external
1762         auth(CREATE_PERMISSIONS_ROLE)
1763         noPermissionManager(_app, _role)
1764     {
1765         _createPermission(_entity, _app, _role, _manager);
1766     }
1767 
1768     /**
1769     * @dev Grants permission if allowed. This requires `msg.sender` to be the permission manager
1770     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
1771     * @param _entity Address of the whitelisted entity that will be able to perform the role
1772     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1773     * @param _role Identifier for the group of actions in app given access to perform
1774     */
1775     function grantPermission(address _entity, address _app, bytes32 _role)
1776         external
1777     {
1778         grantPermissionP(_entity, _app, _role, new uint256[](0));
1779     }
1780 
1781     /**
1782     * @dev Grants a permission with parameters if allowed. This requires `msg.sender` to be the permission manager
1783     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
1784     * @param _entity Address of the whitelisted entity that will be able to perform the role
1785     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1786     * @param _role Identifier for the group of actions in app given access to perform
1787     * @param _params Permission parameters
1788     */
1789     function grantPermissionP(address _entity, address _app, bytes32 _role, uint256[] _params)
1790         public
1791         onlyPermissionManager(_app, _role)
1792     {
1793         bytes32 paramsHash = _params.length > 0 ? _saveParams(_params) : EMPTY_PARAM_HASH;
1794         _setPermission(_entity, _app, _role, paramsHash);
1795     }
1796 
1797     /**
1798     * @dev Revokes permission if allowed. This requires `msg.sender` to be the the permission manager
1799     * @notice Revoke from `_entity` the ability to perform actions requiring `_role` on `_app`
1800     * @param _entity Address of the whitelisted entity to revoke access from
1801     * @param _app Address of the app in which the role will be revoked
1802     * @param _role Identifier for the group of actions in app being revoked
1803     */
1804     function revokePermission(address _entity, address _app, bytes32 _role)
1805         external
1806         onlyPermissionManager(_app, _role)
1807     {
1808         _setPermission(_entity, _app, _role, NO_PERMISSION);
1809     }
1810 
1811     /**
1812     * @notice Set `_newManager` as the manager of `_role` in `_app`
1813     * @param _newManager Address for the new manager
1814     * @param _app Address of the app in which the permission management is being transferred
1815     * @param _role Identifier for the group of actions being transferred
1816     */
1817     function setPermissionManager(address _newManager, address _app, bytes32 _role)
1818         external
1819         onlyPermissionManager(_app, _role)
1820     {
1821         _setPermissionManager(_newManager, _app, _role);
1822     }
1823 
1824     /**
1825     * @notice Remove the manager of `_role` in `_app`
1826     * @param _app Address of the app in which the permission is being unmanaged
1827     * @param _role Identifier for the group of actions being unmanaged
1828     */
1829     function removePermissionManager(address _app, bytes32 _role)
1830         external
1831         onlyPermissionManager(_app, _role)
1832     {
1833         _setPermissionManager(address(0), _app, _role);
1834     }
1835 
1836     /**
1837     * @notice Burn non-existent `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
1838     * @param _app Address of the app in which the permission is being burned
1839     * @param _role Identifier for the group of actions being burned
1840     */
1841     function createBurnedPermission(address _app, bytes32 _role)
1842         external
1843         auth(CREATE_PERMISSIONS_ROLE)
1844         noPermissionManager(_app, _role)
1845     {
1846         _setPermissionManager(BURN_ENTITY, _app, _role);
1847     }
1848 
1849     /**
1850     * @notice Burn `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
1851     * @param _app Address of the app in which the permission is being burned
1852     * @param _role Identifier for the group of actions being burned
1853     */
1854     function burnPermissionManager(address _app, bytes32 _role)
1855         external
1856         onlyPermissionManager(_app, _role)
1857     {
1858         _setPermissionManager(BURN_ENTITY, _app, _role);
1859     }
1860 
1861     /**
1862      * @notice Get parameters for permission array length
1863      * @param _entity Address of the whitelisted entity that will be able to perform the role
1864      * @param _app Address of the app
1865      * @param _role Identifier for a group of actions in app
1866      * @return Length of the array
1867      */
1868     function getPermissionParamsLength(address _entity, address _app, bytes32 _role) external view returns (uint) {
1869         return permissionParams[permissions[permissionHash(_entity, _app, _role)]].length;
1870     }
1871 
1872     /**
1873     * @notice Get parameter for permission
1874     * @param _entity Address of the whitelisted entity that will be able to perform the role
1875     * @param _app Address of the app
1876     * @param _role Identifier for a group of actions in app
1877     * @param _index Index of parameter in the array
1878     * @return Parameter (id, op, value)
1879     */
1880     function getPermissionParam(address _entity, address _app, bytes32 _role, uint _index)
1881         external
1882         view
1883         returns (uint8, uint8, uint240)
1884     {
1885         Param storage param = permissionParams[permissions[permissionHash(_entity, _app, _role)]][_index];
1886         return (param.id, param.op, param.value);
1887     }
1888 
1889     /**
1890     * @dev Get manager for permission
1891     * @param _app Address of the app
1892     * @param _role Identifier for a group of actions in app
1893     * @return address of the manager for the permission
1894     */
1895     function getPermissionManager(address _app, bytes32 _role) public view returns (address) {
1896         return permissionManager[roleHash(_app, _role)];
1897     }
1898 
1899     /**
1900     * @dev Function called by apps to check ACL on kernel or to check permission statu
1901     * @param _who Sender of the original call
1902     * @param _where Address of the app
1903     * @param _where Identifier for a group of actions in app
1904     * @param _how Permission parameters
1905     * @return boolean indicating whether the ACL allows the role or not
1906     */
1907     function hasPermission(address _who, address _where, bytes32 _what, bytes memory _how) public view returns (bool) {
1908         return hasPermission(_who, _where, _what, ConversionHelpers.dangerouslyCastBytesToUintArray(_how));
1909     }
1910 
1911     function hasPermission(address _who, address _where, bytes32 _what, uint256[] memory _how) public view returns (bool) {
1912         bytes32 whoParams = permissions[permissionHash(_who, _where, _what)];
1913         if (whoParams != NO_PERMISSION && evalParams(whoParams, _who, _where, _what, _how)) {
1914             return true;
1915         }
1916 
1917         bytes32 anyParams = permissions[permissionHash(ANY_ENTITY, _where, _what)];
1918         if (anyParams != NO_PERMISSION && evalParams(anyParams, ANY_ENTITY, _where, _what, _how)) {
1919             return true;
1920         }
1921 
1922         return false;
1923     }
1924 
1925     function hasPermission(address _who, address _where, bytes32 _what) public view returns (bool) {
1926         uint256[] memory empty = new uint256[](0);
1927         return hasPermission(_who, _where, _what, empty);
1928     }
1929 
1930     function evalParams(
1931         bytes32 _paramsHash,
1932         address _who,
1933         address _where,
1934         bytes32 _what,
1935         uint256[] _how
1936     ) public view returns (bool)
1937     {
1938         if (_paramsHash == EMPTY_PARAM_HASH) {
1939             return true;
1940         }
1941 
1942         return _evalParam(_paramsHash, 0, _who, _where, _what, _how);
1943     }
1944 
1945     /**
1946     * @dev Internal createPermission for access inside the kernel (on instantiation)
1947     */
1948     function _createPermission(address _entity, address _app, bytes32 _role, address _manager) internal {
1949         _setPermission(_entity, _app, _role, EMPTY_PARAM_HASH);
1950         _setPermissionManager(_manager, _app, _role);
1951     }
1952 
1953     /**
1954     * @dev Internal function called to actually save the permission
1955     */
1956     function _setPermission(address _entity, address _app, bytes32 _role, bytes32 _paramsHash) internal {
1957         permissions[permissionHash(_entity, _app, _role)] = _paramsHash;
1958         bool entityHasPermission = _paramsHash != NO_PERMISSION;
1959         bool permissionHasParams = entityHasPermission && _paramsHash != EMPTY_PARAM_HASH;
1960 
1961         emit SetPermission(_entity, _app, _role, entityHasPermission);
1962         if (permissionHasParams) {
1963             emit SetPermissionParams(_entity, _app, _role, _paramsHash);
1964         }
1965     }
1966 
1967     function _saveParams(uint256[] _encodedParams) internal returns (bytes32) {
1968         bytes32 paramHash = keccak256(abi.encodePacked(_encodedParams));
1969         Param[] storage params = permissionParams[paramHash];
1970 
1971         if (params.length == 0) { // params not saved before
1972             for (uint256 i = 0; i < _encodedParams.length; i++) {
1973                 uint256 encodedParam = _encodedParams[i];
1974                 Param memory param = Param(decodeParamId(encodedParam), decodeParamOp(encodedParam), uint240(encodedParam));
1975                 params.push(param);
1976             }
1977         }
1978 
1979         return paramHash;
1980     }
1981 
1982     function _evalParam(
1983         bytes32 _paramsHash,
1984         uint32 _paramId,
1985         address _who,
1986         address _where,
1987         bytes32 _what,
1988         uint256[] _how
1989     ) internal view returns (bool)
1990     {
1991         if (_paramId >= permissionParams[_paramsHash].length) {
1992             return false; // out of bounds
1993         }
1994 
1995         Param memory param = permissionParams[_paramsHash][_paramId];
1996 
1997         if (param.id == LOGIC_OP_PARAM_ID) {
1998             return _evalLogic(param, _paramsHash, _who, _where, _what, _how);
1999         }
2000 
2001         uint256 value;
2002         uint256 comparedTo = uint256(param.value);
2003 
2004         // get value
2005         if (param.id == ORACLE_PARAM_ID) {
2006             value = checkOracle(IACLOracle(param.value), _who, _where, _what, _how) ? 1 : 0;
2007             comparedTo = 1;
2008         } else if (param.id == BLOCK_NUMBER_PARAM_ID) {
2009             value = getBlockNumber();
2010         } else if (param.id == TIMESTAMP_PARAM_ID) {
2011             value = getTimestamp();
2012         } else if (param.id == PARAM_VALUE_PARAM_ID) {
2013             value = uint256(param.value);
2014         } else {
2015             if (param.id >= _how.length) {
2016                 return false;
2017             }
2018             value = uint256(uint240(_how[param.id])); // force lost precision
2019         }
2020 
2021         if (Op(param.op) == Op.RET) {
2022             return uint256(value) > 0;
2023         }
2024 
2025         return compare(value, Op(param.op), comparedTo);
2026     }
2027 
2028     function _evalLogic(Param _param, bytes32 _paramsHash, address _who, address _where, bytes32 _what, uint256[] _how)
2029         internal
2030         view
2031         returns (bool)
2032     {
2033         if (Op(_param.op) == Op.IF_ELSE) {
2034             uint32 conditionParam;
2035             uint32 successParam;
2036             uint32 failureParam;
2037 
2038             (conditionParam, successParam, failureParam) = decodeParamsList(uint256(_param.value));
2039             bool result = _evalParam(_paramsHash, conditionParam, _who, _where, _what, _how);
2040 
2041             return _evalParam(_paramsHash, result ? successParam : failureParam, _who, _where, _what, _how);
2042         }
2043 
2044         uint32 param1;
2045         uint32 param2;
2046 
2047         (param1, param2,) = decodeParamsList(uint256(_param.value));
2048         bool r1 = _evalParam(_paramsHash, param1, _who, _where, _what, _how);
2049 
2050         if (Op(_param.op) == Op.NOT) {
2051             return !r1;
2052         }
2053 
2054         if (r1 && Op(_param.op) == Op.OR) {
2055             return true;
2056         }
2057 
2058         if (!r1 && Op(_param.op) == Op.AND) {
2059             return false;
2060         }
2061 
2062         bool r2 = _evalParam(_paramsHash, param2, _who, _where, _what, _how);
2063 
2064         if (Op(_param.op) == Op.XOR) {
2065             return r1 != r2;
2066         }
2067 
2068         return r2; // both or and and depend on result of r2 after checks
2069     }
2070 
2071     function compare(uint256 _a, Op _op, uint256 _b) internal pure returns (bool) {
2072         if (_op == Op.EQ)  return _a == _b;                              // solium-disable-line lbrace
2073         if (_op == Op.NEQ) return _a != _b;                              // solium-disable-line lbrace
2074         if (_op == Op.GT)  return _a > _b;                               // solium-disable-line lbrace
2075         if (_op == Op.LT)  return _a < _b;                               // solium-disable-line lbrace
2076         if (_op == Op.GTE) return _a >= _b;                              // solium-disable-line lbrace
2077         if (_op == Op.LTE) return _a <= _b;                              // solium-disable-line lbrace
2078         return false;
2079     }
2080 
2081     function checkOracle(IACLOracle _oracleAddr, address _who, address _where, bytes32 _what, uint256[] _how) internal view returns (bool) {
2082         bytes4 sig = _oracleAddr.canPerform.selector;
2083 
2084         // a raw call is required so we can return false if the call reverts, rather than reverting
2085         bytes memory checkCalldata = abi.encodeWithSelector(sig, _who, _where, _what, _how);
2086         uint256 oracleCheckGas = ORACLE_CHECK_GAS;
2087 
2088         bool ok;
2089         assembly {
2090             ok := staticcall(oracleCheckGas, _oracleAddr, add(checkCalldata, 0x20), mload(checkCalldata), 0, 0)
2091         }
2092 
2093         if (!ok) {
2094             return false;
2095         }
2096 
2097         uint256 size;
2098         assembly { size := returndatasize }
2099         if (size != 32) {
2100             return false;
2101         }
2102 
2103         bool result;
2104         assembly {
2105             let ptr := mload(0x40)       // get next free memory ptr
2106             returndatacopy(ptr, 0, size) // copy return from above `staticcall`
2107             result := mload(ptr)         // read data at ptr and set it to result
2108             mstore(ptr, 0)               // set pointer memory to 0 so it still is the next free ptr
2109         }
2110 
2111         return result;
2112     }
2113 
2114     /**
2115     * @dev Internal function that sets management
2116     */
2117     function _setPermissionManager(address _newManager, address _app, bytes32 _role) internal {
2118         permissionManager[roleHash(_app, _role)] = _newManager;
2119         emit ChangePermissionManager(_app, _role, _newManager);
2120     }
2121 
2122     function roleHash(address _where, bytes32 _what) internal pure returns (bytes32) {
2123         return keccak256(abi.encodePacked("ROLE", _where, _what));
2124     }
2125 
2126     function permissionHash(address _who, address _where, bytes32 _what) internal pure returns (bytes32) {
2127         return keccak256(abi.encodePacked("PERMISSION", _who, _where, _what));
2128     }
2129 }
2130 
2131 // File: contracts/evmscript/ScriptHelpers.sol
2132 
2133 /*
2134  * SPDX-License-Identitifer:    MIT
2135  */
2136 
2137 pragma solidity ^0.4.24;
2138 
2139 
2140 library ScriptHelpers {
2141     function getSpecId(bytes _script) internal pure returns (uint32) {
2142         return uint32At(_script, 0);
2143     }
2144 
2145     function uint256At(bytes _data, uint256 _location) internal pure returns (uint256 result) {
2146         assembly {
2147             result := mload(add(_data, add(0x20, _location)))
2148         }
2149     }
2150 
2151     function addressAt(bytes _data, uint256 _location) internal pure returns (address result) {
2152         uint256 word = uint256At(_data, _location);
2153 
2154         assembly {
2155             result := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
2156             0x1000000000000000000000000)
2157         }
2158     }
2159 
2160     function uint32At(bytes _data, uint256 _location) internal pure returns (uint32 result) {
2161         uint256 word = uint256At(_data, _location);
2162 
2163         assembly {
2164             result := div(and(word, 0xffffffff00000000000000000000000000000000000000000000000000000000),
2165             0x100000000000000000000000000000000000000000000000000000000)
2166         }
2167     }
2168 
2169     function locationOf(bytes _data, uint256 _location) internal pure returns (uint256 result) {
2170         assembly {
2171             result := add(_data, add(0x20, _location))
2172         }
2173     }
2174 
2175     function toBytes(bytes4 _sig) internal pure returns (bytes) {
2176         bytes memory payload = new bytes(4);
2177         assembly { mstore(add(payload, 0x20), _sig) }
2178         return payload;
2179     }
2180 }
2181 
2182 // File: contracts/evmscript/EVMScriptRegistry.sol
2183 
2184 pragma solidity 0.4.24;
2185 
2186 
2187 
2188 
2189 
2190 
2191 /* solium-disable function-order */
2192 // Allow public initialize() to be first
2193 contract EVMScriptRegistry is IEVMScriptRegistry, EVMScriptRegistryConstants, AragonApp {
2194     using ScriptHelpers for bytes;
2195 
2196     /* Hardcoded constants to save gas
2197     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = keccak256("REGISTRY_ADD_EXECUTOR_ROLE");
2198     bytes32 public constant REGISTRY_MANAGER_ROLE = keccak256("REGISTRY_MANAGER_ROLE");
2199     */
2200     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = 0xc4e90f38eea8c4212a009ca7b8947943ba4d4a58d19b683417f65291d1cd9ed2;
2201     // WARN: Manager can censor all votes and the like happening in an org
2202     bytes32 public constant REGISTRY_MANAGER_ROLE = 0xf7a450ef335e1892cb42c8ca72e7242359d7711924b75db5717410da3f614aa3;
2203 
2204     uint256 internal constant SCRIPT_START_LOCATION = 4;
2205 
2206     string private constant ERROR_INEXISTENT_EXECUTOR = "EVMREG_INEXISTENT_EXECUTOR";
2207     string private constant ERROR_EXECUTOR_ENABLED = "EVMREG_EXECUTOR_ENABLED";
2208     string private constant ERROR_EXECUTOR_DISABLED = "EVMREG_EXECUTOR_DISABLED";
2209     string private constant ERROR_SCRIPT_LENGTH_TOO_SHORT = "EVMREG_SCRIPT_LENGTH_TOO_SHORT";
2210 
2211     struct ExecutorEntry {
2212         IEVMScriptExecutor executor;
2213         bool enabled;
2214     }
2215 
2216     uint256 private executorsNextIndex;
2217     mapping (uint256 => ExecutorEntry) public executors;
2218 
2219     event EnableExecutor(uint256 indexed executorId, address indexed executorAddress);
2220     event DisableExecutor(uint256 indexed executorId, address indexed executorAddress);
2221 
2222     modifier executorExists(uint256 _executorId) {
2223         require(_executorId > 0 && _executorId < executorsNextIndex, ERROR_INEXISTENT_EXECUTOR);
2224         _;
2225     }
2226 
2227     /**
2228     * @notice Initialize the registry
2229     */
2230     function initialize() public onlyInit {
2231         initialized();
2232         // Create empty record to begin executor IDs at 1
2233         executorsNextIndex = 1;
2234     }
2235 
2236     /**
2237     * @notice Add a new script executor with address `_executor` to the registry
2238     * @param _executor Address of the IEVMScriptExecutor that will be added to the registry
2239     * @return id Identifier of the executor in the registry
2240     */
2241     function addScriptExecutor(IEVMScriptExecutor _executor) external auth(REGISTRY_ADD_EXECUTOR_ROLE) returns (uint256 id) {
2242         uint256 executorId = executorsNextIndex++;
2243         executors[executorId] = ExecutorEntry(_executor, true);
2244         emit EnableExecutor(executorId, _executor);
2245         return executorId;
2246     }
2247 
2248     /**
2249     * @notice Disable script executor with ID `_executorId`
2250     * @param _executorId Identifier of the executor in the registry
2251     */
2252     function disableScriptExecutor(uint256 _executorId)
2253         external
2254         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
2255     {
2256         // Note that we don't need to check for an executor's existence in this case, as only
2257         // existing executors can be enabled
2258         ExecutorEntry storage executorEntry = executors[_executorId];
2259         require(executorEntry.enabled, ERROR_EXECUTOR_DISABLED);
2260         executorEntry.enabled = false;
2261         emit DisableExecutor(_executorId, executorEntry.executor);
2262     }
2263 
2264     /**
2265     * @notice Enable script executor with ID `_executorId`
2266     * @param _executorId Identifier of the executor in the registry
2267     */
2268     function enableScriptExecutor(uint256 _executorId)
2269         external
2270         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
2271         executorExists(_executorId)
2272     {
2273         ExecutorEntry storage executorEntry = executors[_executorId];
2274         require(!executorEntry.enabled, ERROR_EXECUTOR_ENABLED);
2275         executorEntry.enabled = true;
2276         emit EnableExecutor(_executorId, executorEntry.executor);
2277     }
2278 
2279     /**
2280     * @dev Get the script executor that can execute a particular script based on its first 4 bytes
2281     * @param _script EVMScript being inspected
2282     */
2283     function getScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
2284         require(_script.length >= SCRIPT_START_LOCATION, ERROR_SCRIPT_LENGTH_TOO_SHORT);
2285         uint256 id = _script.getSpecId();
2286 
2287         // Note that we don't need to check for an executor's existence in this case, as only
2288         // existing executors can be enabled
2289         ExecutorEntry storage entry = executors[id];
2290         return entry.enabled ? entry.executor : IEVMScriptExecutor(0);
2291     }
2292 }
2293 
2294 // File: contracts/evmscript/executors/BaseEVMScriptExecutor.sol
2295 
2296 /*
2297  * SPDX-License-Identitifer:    MIT
2298  */
2299 
2300 pragma solidity ^0.4.24;
2301 
2302 
2303 
2304 
2305 contract BaseEVMScriptExecutor is IEVMScriptExecutor, Autopetrified {
2306     uint256 internal constant SCRIPT_START_LOCATION = 4;
2307 }
2308 
2309 // File: contracts/evmscript/executors/CallsScript.sol
2310 
2311 pragma solidity 0.4.24;
2312 
2313 // Inspired by https://github.com/reverendus/tx-manager
2314 
2315 
2316 
2317 
2318 contract CallsScript is BaseEVMScriptExecutor {
2319     using ScriptHelpers for bytes;
2320 
2321     /* Hardcoded constants to save gas
2322     bytes32 internal constant EXECUTOR_TYPE = keccak256("CALLS_SCRIPT");
2323     */
2324     bytes32 internal constant EXECUTOR_TYPE = 0x2dc858a00f3e417be1394b87c07158e989ec681ce8cc68a9093680ac1a870302;
2325 
2326     string private constant ERROR_BLACKLISTED_CALL = "EVMCALLS_BLACKLISTED_CALL";
2327     string private constant ERROR_INVALID_LENGTH = "EVMCALLS_INVALID_LENGTH";
2328 
2329     /* This is manually crafted in assembly
2330     string private constant ERROR_CALL_REVERTED = "EVMCALLS_CALL_REVERTED";
2331     */
2332 
2333     event LogScriptCall(address indexed sender, address indexed src, address indexed dst);
2334 
2335     /**
2336     * @notice Executes a number of call scripts
2337     * @param _script [ specId (uint32) ] many calls with this structure ->
2338     *    [ to (address: 20 bytes) ] [ calldataLength (uint32: 4 bytes) ] [ calldata (calldataLength bytes) ]
2339     * @param _blacklist Addresses the script cannot call to, or will revert.
2340     * @return Always returns empty byte array
2341     */
2342     function execScript(bytes _script, bytes, address[] _blacklist) external isInitialized returns (bytes) {
2343         uint256 location = SCRIPT_START_LOCATION; // first 32 bits are spec id
2344         while (location < _script.length) {
2345             // Check there's at least address + calldataLength available
2346             require(_script.length - location >= 0x18, ERROR_INVALID_LENGTH);
2347 
2348             address contractAddress = _script.addressAt(location);
2349             // Check address being called is not blacklist
2350             for (uint256 i = 0; i < _blacklist.length; i++) {
2351                 require(contractAddress != _blacklist[i], ERROR_BLACKLISTED_CALL);
2352             }
2353 
2354             // logged before execution to ensure event ordering in receipt
2355             // if failed entire execution is reverted regardless
2356             emit LogScriptCall(msg.sender, address(this), contractAddress);
2357 
2358             uint256 calldataLength = uint256(_script.uint32At(location + 0x14));
2359             uint256 startOffset = location + 0x14 + 0x04;
2360             uint256 calldataStart = _script.locationOf(startOffset);
2361 
2362             // compute end of script / next location
2363             location = startOffset + calldataLength;
2364             require(location <= _script.length, ERROR_INVALID_LENGTH);
2365 
2366             bool success;
2367             assembly {
2368                 success := call(
2369                     sub(gas, 5000),       // forward gas left - 5000
2370                     contractAddress,      // address
2371                     0,                    // no value
2372                     calldataStart,        // calldata start
2373                     calldataLength,       // calldata length
2374                     0,                    // don't write output
2375                     0                     // don't write output
2376                 )
2377 
2378                 switch success
2379                 case 0 {
2380                     let ptr := mload(0x40)
2381 
2382                     switch returndatasize
2383                     case 0 {
2384                         // No error data was returned, revert with "EVMCALLS_CALL_REVERTED"
2385                         // See remix: doing a `revert("EVMCALLS_CALL_REVERTED")` always results in
2386                         // this memory layout
2387                         mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000)         // error identifier
2388                         mstore(add(ptr, 0x04), 0x0000000000000000000000000000000000000000000000000000000000000020) // starting offset
2389                         mstore(add(ptr, 0x24), 0x0000000000000000000000000000000000000000000000000000000000000016) // reason length
2390                         mstore(add(ptr, 0x44), 0x45564d43414c4c535f43414c4c5f524556455254454400000000000000000000) // reason
2391 
2392                         revert(ptr, 100) // 100 = 4 + 3 * 32 (error identifier + 3 words for the ABI encoded error)
2393                     }
2394                     default {
2395                         // Forward the full error data
2396                         returndatacopy(ptr, 0, returndatasize)
2397                         revert(ptr, returndatasize)
2398                     }
2399                 }
2400                 default { }
2401             }
2402         }
2403         // No need to allocate empty bytes for the return as this can only be called via an delegatecall
2404         // (due to the isInitialized modifier)
2405     }
2406 
2407     function executorType() external pure returns (bytes32) {
2408         return EXECUTOR_TYPE;
2409     }
2410 }
2411 
2412 // File: contracts/factory/EVMScriptRegistryFactory.sol
2413 
2414 pragma solidity 0.4.24;
2415 
2416 
2417 
2418 
2419 
2420 
2421 
2422 contract EVMScriptRegistryFactory is EVMScriptRegistryConstants {
2423     EVMScriptRegistry public baseReg;
2424     IEVMScriptExecutor public baseCallScript;
2425 
2426     /**
2427     * @notice Create a new EVMScriptRegistryFactory.
2428     */
2429     constructor() public {
2430         baseReg = new EVMScriptRegistry();
2431         baseCallScript = IEVMScriptExecutor(new CallsScript());
2432     }
2433 
2434     /**
2435     * @notice Install a new pinned instance of EVMScriptRegistry on `_dao`.
2436     * @param _dao Kernel
2437     * @return Installed EVMScriptRegistry
2438     */
2439     function newEVMScriptRegistry(Kernel _dao) public returns (EVMScriptRegistry reg) {
2440         bytes memory initPayload = abi.encodeWithSelector(reg.initialize.selector);
2441         reg = EVMScriptRegistry(_dao.newPinnedAppInstance(EVMSCRIPT_REGISTRY_APP_ID, baseReg, initPayload, true));
2442 
2443         ACL acl = ACL(_dao.acl());
2444 
2445         acl.createPermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE(), this);
2446 
2447         reg.addScriptExecutor(baseCallScript);     // spec 1 = CallsScript
2448 
2449         // Clean up the permissions
2450         acl.revokePermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
2451         acl.removePermissionManager(reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
2452 
2453         return reg;
2454     }
2455 }
2456 
2457 // File: contracts/factory/DAOFactory.sol
2458 
2459 pragma solidity 0.4.24;
2460 
2461 
2462 
2463 
2464 
2465 
2466 
2467 
2468 contract DAOFactory {
2469     IKernel public baseKernel;
2470     IACL public baseACL;
2471     EVMScriptRegistryFactory public regFactory;
2472 
2473     event DeployDAO(address dao);
2474     event DeployEVMScriptRegistry(address reg);
2475 
2476     /**
2477     * @notice Create a new DAOFactory, creating DAOs with Kernels proxied to `_baseKernel`, ACLs proxied to `_baseACL`, and new EVMScriptRegistries created from `_regFactory`.
2478     * @param _baseKernel Base Kernel
2479     * @param _baseACL Base ACL
2480     * @param _regFactory EVMScriptRegistry factory
2481     */
2482     constructor(IKernel _baseKernel, IACL _baseACL, EVMScriptRegistryFactory _regFactory) public {
2483         // No need to init as it cannot be killed by devops199
2484         if (address(_regFactory) != address(0)) {
2485             regFactory = _regFactory;
2486         }
2487 
2488         baseKernel = _baseKernel;
2489         baseACL = _baseACL;
2490     }
2491 
2492     /**
2493     * @notice Create a new DAO with `_root` set as the initial admin
2494     * @param _root Address that will be granted control to setup DAO permissions
2495     * @return Newly created DAO
2496     */
2497     function newDAO(address _root) public returns (Kernel) {
2498         Kernel dao = Kernel(new KernelProxy(baseKernel));
2499 
2500         if (address(regFactory) == address(0)) {
2501             dao.initialize(baseACL, _root);
2502         } else {
2503             dao.initialize(baseACL, this);
2504 
2505             ACL acl = ACL(dao.acl());
2506             bytes32 permRole = acl.CREATE_PERMISSIONS_ROLE();
2507             bytes32 appManagerRole = dao.APP_MANAGER_ROLE();
2508 
2509             acl.grantPermission(regFactory, acl, permRole);
2510 
2511             acl.createPermission(regFactory, dao, appManagerRole, this);
2512 
2513             EVMScriptRegistry reg = regFactory.newEVMScriptRegistry(dao);
2514             emit DeployEVMScriptRegistry(address(reg));
2515 
2516             // Clean up permissions
2517             // First, completely reset the APP_MANAGER_ROLE
2518             acl.revokePermission(regFactory, dao, appManagerRole);
2519             acl.removePermissionManager(dao, appManagerRole);
2520 
2521             // Then, make root the only holder and manager of CREATE_PERMISSIONS_ROLE
2522             acl.revokePermission(regFactory, acl, permRole);
2523             acl.revokePermission(this, acl, permRole);
2524             acl.grantPermission(_root, acl, permRole);
2525             acl.setPermissionManager(_root, acl, permRole);
2526         }
2527 
2528         emit DeployDAO(address(dao));
2529 
2530         return dao;
2531     }
2532 }