1 // File: contracts/acl/IACL.sol
2 
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
17 
18 // File: contracts/common/IVaultRecoverable.sol
19 
20 /*
21  * SPDX-License-Identitifer:    MIT
22  */
23 
24 pragma solidity ^0.4.24;
25 
26 
27 interface IVaultRecoverable {
28     event RecoverToVault(address indexed vault, address indexed token, uint256 amount);
29 
30     function transferToVault(address token) external;
31 
32     function allowRecoverability(address token) external view returns (bool);
33     function getRecoveryVault() external view returns (address);
34 }
35 
36 // File: contracts/kernel/IKernel.sol
37 
38 /*
39  * SPDX-License-Identitifer:    MIT
40  */
41 
42 pragma solidity ^0.4.24;
43 
44 
45 
46 
47 interface IKernelEvents {
48     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
49 }
50 
51 
52 // This should be an interface, but interfaces can't inherit yet :(
53 contract IKernel is IKernelEvents, IVaultRecoverable {
54     function acl() public view returns (IACL);
55     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
56 
57     function setApp(bytes32 namespace, bytes32 appId, address app) public;
58     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
59 }
60 
61 // File: contracts/kernel/KernelConstants.sol
62 
63 /*
64  * SPDX-License-Identitifer:    MIT
65  */
66 
67 pragma solidity ^0.4.24;
68 
69 
70 contract KernelAppIds {
71     /* Hardcoded constants to save gas
72     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
73     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
74     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
75     */
76     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
77     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
78     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
79 }
80 
81 
82 contract KernelNamespaceConstants {
83     /* Hardcoded constants to save gas
84     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
85     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
86     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
87     */
88     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
89     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
90     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
91 }
92 
93 // File: contracts/kernel/KernelStorage.sol
94 
95 pragma solidity 0.4.24;
96 
97 
98 contract KernelStorage {
99     // namespace => app id => address
100     mapping (bytes32 => mapping (bytes32 => address)) public apps;
101     bytes32 public recoveryVaultAppId;
102 }
103 
104 // File: contracts/acl/ACLSyntaxSugar.sol
105 
106 /*
107  * SPDX-License-Identitifer:    MIT
108  */
109 
110 pragma solidity ^0.4.24;
111 
112 
113 contract ACLSyntaxSugar {
114     function arr() internal pure returns (uint256[]) {
115         return new uint256[](0);
116     }
117 
118     function arr(bytes32 _a) internal pure returns (uint256[] r) {
119         return arr(uint256(_a));
120     }
121 
122     function arr(bytes32 _a, bytes32 _b) internal pure returns (uint256[] r) {
123         return arr(uint256(_a), uint256(_b));
124     }
125 
126     function arr(address _a) internal pure returns (uint256[] r) {
127         return arr(uint256(_a));
128     }
129 
130     function arr(address _a, address _b) internal pure returns (uint256[] r) {
131         return arr(uint256(_a), uint256(_b));
132     }
133 
134     function arr(address _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
135         return arr(uint256(_a), _b, _c);
136     }
137 
138     function arr(address _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
139         return arr(uint256(_a), _b, _c, _d);
140     }
141 
142     function arr(address _a, uint256 _b) internal pure returns (uint256[] r) {
143         return arr(uint256(_a), uint256(_b));
144     }
145 
146     function arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
147         return arr(uint256(_a), uint256(_b), _c, _d, _e);
148     }
149 
150     function arr(address _a, address _b, address _c) internal pure returns (uint256[] r) {
151         return arr(uint256(_a), uint256(_b), uint256(_c));
152     }
153 
154     function arr(address _a, address _b, uint256 _c) internal pure returns (uint256[] r) {
155         return arr(uint256(_a), uint256(_b), uint256(_c));
156     }
157 
158     function arr(uint256 _a) internal pure returns (uint256[] r) {
159         r = new uint256[](1);
160         r[0] = _a;
161     }
162 
163     function arr(uint256 _a, uint256 _b) internal pure returns (uint256[] r) {
164         r = new uint256[](2);
165         r[0] = _a;
166         r[1] = _b;
167     }
168 
169     function arr(uint256 _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
170         r = new uint256[](3);
171         r[0] = _a;
172         r[1] = _b;
173         r[2] = _c;
174     }
175 
176     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
177         r = new uint256[](4);
178         r[0] = _a;
179         r[1] = _b;
180         r[2] = _c;
181         r[3] = _d;
182     }
183 
184     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
185         r = new uint256[](5);
186         r[0] = _a;
187         r[1] = _b;
188         r[2] = _c;
189         r[3] = _d;
190         r[4] = _e;
191     }
192 }
193 
194 
195 contract ACLHelpers {
196     function decodeParamOp(uint256 _x) internal pure returns (uint8 b) {
197         return uint8(_x >> (8 * 30));
198     }
199 
200     function decodeParamId(uint256 _x) internal pure returns (uint8 b) {
201         return uint8(_x >> (8 * 31));
202     }
203 
204     function decodeParamsList(uint256 _x) internal pure returns (uint32 a, uint32 b, uint32 c) {
205         a = uint32(_x);
206         b = uint32(_x >> (8 * 4));
207         c = uint32(_x >> (8 * 8));
208     }
209 }
210 
211 // File: contracts/common/ConversionHelpers.sol
212 
213 pragma solidity ^0.4.24;
214 
215 
216 library ConversionHelpers {
217     string private constant ERROR_IMPROPER_LENGTH = "CONVERSION_IMPROPER_LENGTH";
218 
219     function dangerouslyCastUintArrayToBytes(uint256[] memory _input) internal pure returns (bytes memory output) {
220         // Force cast the uint256[] into a bytes array, by overwriting its length
221         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
222         // with the input and a new length. The input becomes invalid from this point forward.
223         uint256 byteLength = _input.length * 32;
224         assembly {
225             output := _input
226             mstore(output, byteLength)
227         }
228     }
229 
230     function dangerouslyCastBytesToUintArray(bytes memory _input) internal pure returns (uint256[] memory output) {
231         // Force cast the bytes array into a uint256[], by overwriting its length
232         // Note that the uint256[] doesn't need to be initialized as we immediately overwrite it
233         // with the input and a new length. The input becomes invalid from this point forward.
234         uint256 intsLength = _input.length / 32;
235         require(_input.length == intsLength * 32, ERROR_IMPROPER_LENGTH);
236 
237         assembly {
238             output := _input
239             mstore(output, intsLength)
240         }
241     }
242 }
243 
244 // File: contracts/common/IsContract.sol
245 
246 /*
247  * SPDX-License-Identitifer:    MIT
248  */
249 
250 pragma solidity ^0.4.24;
251 
252 
253 contract IsContract {
254     /*
255     * NOTE: this should NEVER be used for authentication
256     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
257     *
258     * This is only intended to be used as a sanity check that an address is actually a contract,
259     * RATHER THAN an address not being a contract.
260     */
261     function isContract(address _target) internal view returns (bool) {
262         if (_target == address(0)) {
263             return false;
264         }
265 
266         uint256 size;
267         assembly { size := extcodesize(_target) }
268         return size > 0;
269     }
270 }
271 
272 // File: contracts/common/Uint256Helpers.sol
273 
274 pragma solidity ^0.4.24;
275 
276 
277 library Uint256Helpers {
278     uint256 private constant MAX_UINT64 = uint64(-1);
279 
280     string private constant ERROR_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
281 
282     function toUint64(uint256 a) internal pure returns (uint64) {
283         require(a <= MAX_UINT64, ERROR_NUMBER_TOO_BIG);
284         return uint64(a);
285     }
286 }
287 
288 // File: contracts/common/TimeHelpers.sol
289 
290 /*
291  * SPDX-License-Identitifer:    MIT
292  */
293 
294 pragma solidity ^0.4.24;
295 
296 
297 
298 contract TimeHelpers {
299     using Uint256Helpers for uint256;
300 
301     /**
302     * @dev Returns the current block number.
303     *      Using a function rather than `block.number` allows us to easily mock the block number in
304     *      tests.
305     */
306     function getBlockNumber() internal view returns (uint256) {
307         return block.number;
308     }
309 
310     /**
311     * @dev Returns the current block number, converted to uint64.
312     *      Using a function rather than `block.number` allows us to easily mock the block number in
313     *      tests.
314     */
315     function getBlockNumber64() internal view returns (uint64) {
316         return getBlockNumber().toUint64();
317     }
318 
319     /**
320     * @dev Returns the current timestamp.
321     *      Using a function rather than `block.timestamp` allows us to easily mock it in
322     *      tests.
323     */
324     function getTimestamp() internal view returns (uint256) {
325         return block.timestamp; // solium-disable-line security/no-block-members
326     }
327 
328     /**
329     * @dev Returns the current timestamp, converted to uint64.
330     *      Using a function rather than `block.timestamp` allows us to easily mock it in
331     *      tests.
332     */
333     function getTimestamp64() internal view returns (uint64) {
334         return getTimestamp().toUint64();
335     }
336 }
337 
338 // File: contracts/common/UnstructuredStorage.sol
339 
340 /*
341  * SPDX-License-Identitifer:    MIT
342  */
343 
344 pragma solidity ^0.4.24;
345 
346 
347 library UnstructuredStorage {
348     function getStorageBool(bytes32 position) internal view returns (bool data) {
349         assembly { data := sload(position) }
350     }
351 
352     function getStorageAddress(bytes32 position) internal view returns (address data) {
353         assembly { data := sload(position) }
354     }
355 
356     function getStorageBytes32(bytes32 position) internal view returns (bytes32 data) {
357         assembly { data := sload(position) }
358     }
359 
360     function getStorageUint256(bytes32 position) internal view returns (uint256 data) {
361         assembly { data := sload(position) }
362     }
363 
364     function setStorageBool(bytes32 position, bool data) internal {
365         assembly { sstore(position, data) }
366     }
367 
368     function setStorageAddress(bytes32 position, address data) internal {
369         assembly { sstore(position, data) }
370     }
371 
372     function setStorageBytes32(bytes32 position, bytes32 data) internal {
373         assembly { sstore(position, data) }
374     }
375 
376     function setStorageUint256(bytes32 position, uint256 data) internal {
377         assembly { sstore(position, data) }
378     }
379 }
380 
381 // File: contracts/common/Initializable.sol
382 
383 /*
384  * SPDX-License-Identitifer:    MIT
385  */
386 
387 pragma solidity ^0.4.24;
388 
389 
390 
391 
392 contract Initializable is TimeHelpers {
393     using UnstructuredStorage for bytes32;
394 
395     // keccak256("aragonOS.initializable.initializationBlock")
396     bytes32 internal constant INITIALIZATION_BLOCK_POSITION = 0xebb05b386a8d34882b8711d156f463690983dc47815980fb82aeeff1aa43579e;
397 
398     string private constant ERROR_ALREADY_INITIALIZED = "INIT_ALREADY_INITIALIZED";
399     string private constant ERROR_NOT_INITIALIZED = "INIT_NOT_INITIALIZED";
400 
401     modifier onlyInit {
402         require(getInitializationBlock() == 0, ERROR_ALREADY_INITIALIZED);
403         _;
404     }
405 
406     modifier isInitialized {
407         require(hasInitialized(), ERROR_NOT_INITIALIZED);
408         _;
409     }
410 
411     /**
412     * @return Block number in which the contract was initialized
413     */
414     function getInitializationBlock() public view returns (uint256) {
415         return INITIALIZATION_BLOCK_POSITION.getStorageUint256();
416     }
417 
418     /**
419     * @return Whether the contract has been initialized by the time of the current block
420     */
421     function hasInitialized() public view returns (bool) {
422         uint256 initializationBlock = getInitializationBlock();
423         return initializationBlock != 0 && getBlockNumber() >= initializationBlock;
424     }
425 
426     /**
427     * @dev Function to be called by top level contract after initialization has finished.
428     */
429     function initialized() internal onlyInit {
430         INITIALIZATION_BLOCK_POSITION.setStorageUint256(getBlockNumber());
431     }
432 
433     /**
434     * @dev Function to be called by top level contract after initialization to enable the contract
435     *      at a future block number rather than immediately.
436     */
437     function initializedAt(uint256 _blockNumber) internal onlyInit {
438         INITIALIZATION_BLOCK_POSITION.setStorageUint256(_blockNumber);
439     }
440 }
441 
442 // File: contracts/common/Petrifiable.sol
443 
444 /*
445  * SPDX-License-Identitifer:    MIT
446  */
447 
448 pragma solidity ^0.4.24;
449 
450 
451 
452 contract Petrifiable is Initializable {
453     // Use block UINT256_MAX (which should be never) as the initializable date
454     uint256 internal constant PETRIFIED_BLOCK = uint256(-1);
455 
456     function isPetrified() public view returns (bool) {
457         return getInitializationBlock() == PETRIFIED_BLOCK;
458     }
459 
460     /**
461     * @dev Function to be called by top level contract to prevent being initialized.
462     *      Useful for freezing base contracts when they're used behind proxies.
463     */
464     function petrify() internal onlyInit {
465         initializedAt(PETRIFIED_BLOCK);
466     }
467 }
468 
469 // File: contracts/lib/token/ERC20.sol
470 
471 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/a9f910d34f0ab33a1ae5e714f69f9596a02b4d91/contracts/token/ERC20/ERC20.sol
472 
473 pragma solidity ^0.4.24;
474 
475 
476 /**
477  * @title ERC20 interface
478  * @dev see https://github.com/ethereum/EIPs/issues/20
479  */
480 contract ERC20 {
481     function totalSupply() public view returns (uint256);
482 
483     function balanceOf(address _who) public view returns (uint256);
484 
485     function allowance(address _owner, address _spender)
486         public view returns (uint256);
487 
488     function transfer(address _to, uint256 _value) public returns (bool);
489 
490     function approve(address _spender, uint256 _value)
491         public returns (bool);
492 
493     function transferFrom(address _from, address _to, uint256 _value)
494         public returns (bool);
495 
496     event Transfer(
497         address indexed from,
498         address indexed to,
499         uint256 value
500     );
501 
502     event Approval(
503         address indexed owner,
504         address indexed spender,
505         uint256 value
506     );
507 }
508 
509 // File: contracts/common/EtherTokenConstant.sol
510 
511 /*
512  * SPDX-License-Identitifer:    MIT
513  */
514 
515 pragma solidity ^0.4.24;
516 
517 
518 // aragonOS and aragon-apps rely on address(0) to denote native ETH, in
519 // contracts where both tokens and ETH are accepted
520 contract EtherTokenConstant {
521     address internal constant ETH = address(0);
522 }
523 
524 // File: contracts/common/SafeERC20.sol
525 
526 // Inspired by AdEx (https://github.com/AdExNetwork/adex-protocol-eth/blob/b9df617829661a7518ee10f4cb6c4108659dd6d5/contracts/libs/SafeERC20.sol)
527 // and 0x (https://github.com/0xProject/0x-monorepo/blob/737d1dc54d72872e24abce5a1dbe1b66d35fa21a/contracts/protocol/contracts/protocol/AssetProxy/ERC20Proxy.sol#L143)
528 
529 pragma solidity ^0.4.24;
530 
531 
532 
533 library SafeERC20 {
534     // Before 0.5, solidity has a mismatch between `address.transfer()` and `token.transfer()`:
535     // https://github.com/ethereum/solidity/issues/3544
536     bytes4 private constant TRANSFER_SELECTOR = 0xa9059cbb;
537 
538     string private constant ERROR_TOKEN_BALANCE_REVERTED = "SAFE_ERC_20_BALANCE_REVERTED";
539     string private constant ERROR_TOKEN_ALLOWANCE_REVERTED = "SAFE_ERC_20_ALLOWANCE_REVERTED";
540 
541     function invokeAndCheckSuccess(address _addr, bytes memory _calldata)
542         private
543         returns (bool)
544     {
545         bool ret;
546         assembly {
547             let ptr := mload(0x40)    // free memory pointer
548 
549             let success := call(
550                 gas,                  // forward all gas
551                 _addr,                // address
552                 0,                    // no value
553                 add(_calldata, 0x20), // calldata start
554                 mload(_calldata),     // calldata length
555                 ptr,                  // write output over free memory
556                 0x20                  // uint256 return
557             )
558 
559             if gt(success, 0) {
560                 // Check number of bytes returned from last function call
561                 switch returndatasize
562 
563                 // No bytes returned: assume success
564                 case 0 {
565                     ret := 1
566                 }
567 
568                 // 32 bytes returned: check if non-zero
569                 case 0x20 {
570                     // Only return success if returned data was true
571                     // Already have output in ptr
572                     ret := eq(mload(ptr), 1)
573                 }
574 
575                 // Not sure what was returned: don't mark as success
576                 default { }
577             }
578         }
579         return ret;
580     }
581 
582     function staticInvoke(address _addr, bytes memory _calldata)
583         private
584         view
585         returns (bool, uint256)
586     {
587         bool success;
588         uint256 ret;
589         assembly {
590             let ptr := mload(0x40)    // free memory pointer
591 
592             success := staticcall(
593                 gas,                  // forward all gas
594                 _addr,                // address
595                 add(_calldata, 0x20), // calldata start
596                 mload(_calldata),     // calldata length
597                 ptr,                  // write output over free memory
598                 0x20                  // uint256 return
599             )
600 
601             if gt(success, 0) {
602                 ret := mload(ptr)
603             }
604         }
605         return (success, ret);
606     }
607 
608     /**
609     * @dev Same as a standards-compliant ERC20.transfer() that never reverts (returns false).
610     *      Note that this makes an external call to the token.
611     */
612     function safeTransfer(ERC20 _token, address _to, uint256 _amount) internal returns (bool) {
613         bytes memory transferCallData = abi.encodeWithSelector(
614             TRANSFER_SELECTOR,
615             _to,
616             _amount
617         );
618         return invokeAndCheckSuccess(_token, transferCallData);
619     }
620 
621     /**
622     * @dev Same as a standards-compliant ERC20.transferFrom() that never reverts (returns false).
623     *      Note that this makes an external call to the token.
624     */
625     function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {
626         bytes memory transferFromCallData = abi.encodeWithSelector(
627             _token.transferFrom.selector,
628             _from,
629             _to,
630             _amount
631         );
632         return invokeAndCheckSuccess(_token, transferFromCallData);
633     }
634 
635     /**
636     * @dev Same as a standards-compliant ERC20.approve() that never reverts (returns false).
637     *      Note that this makes an external call to the token.
638     */
639     function safeApprove(ERC20 _token, address _spender, uint256 _amount) internal returns (bool) {
640         bytes memory approveCallData = abi.encodeWithSelector(
641             _token.approve.selector,
642             _spender,
643             _amount
644         );
645         return invokeAndCheckSuccess(_token, approveCallData);
646     }
647 
648     /**
649     * @dev Static call into ERC20.balanceOf().
650     * Reverts if the call fails for some reason (should never fail).
651     */
652     function staticBalanceOf(ERC20 _token, address _owner) internal view returns (uint256) {
653         bytes memory balanceOfCallData = abi.encodeWithSelector(
654             _token.balanceOf.selector,
655             _owner
656         );
657 
658         (bool success, uint256 tokenBalance) = staticInvoke(_token, balanceOfCallData);
659         require(success, ERROR_TOKEN_BALANCE_REVERTED);
660 
661         return tokenBalance;
662     }
663 
664     /**
665     * @dev Static call into ERC20.allowance().
666     * Reverts if the call fails for some reason (should never fail).
667     */
668     function staticAllowance(ERC20 _token, address _owner, address _spender) internal view returns (uint256) {
669         bytes memory allowanceCallData = abi.encodeWithSelector(
670             _token.allowance.selector,
671             _owner,
672             _spender
673         );
674 
675         (bool success, uint256 allowance) = staticInvoke(_token, allowanceCallData);
676         require(success, ERROR_TOKEN_ALLOWANCE_REVERTED);
677 
678         return allowance;
679     }
680 }
681 
682 // File: contracts/common/VaultRecoverable.sol
683 
684 /*
685  * SPDX-License-Identitifer:    MIT
686  */
687 
688 pragma solidity ^0.4.24;
689 
690 
691 
692 
693 
694 
695 
696 contract VaultRecoverable is IVaultRecoverable, EtherTokenConstant, IsContract {
697     using SafeERC20 for ERC20;
698 
699     string private constant ERROR_DISALLOWED = "RECOVER_DISALLOWED";
700     string private constant ERROR_VAULT_NOT_CONTRACT = "RECOVER_VAULT_NOT_CONTRACT";
701     string private constant ERROR_TOKEN_TRANSFER_FAILED = "RECOVER_TOKEN_TRANSFER_FAILED";
702 
703     /**
704      * @notice Send funds to recovery Vault. This contract should never receive funds,
705      *         but in case it does, this function allows one to recover them.
706      * @param _token Token balance to be sent to recovery vault.
707      */
708     function transferToVault(address _token) external {
709         require(allowRecoverability(_token), ERROR_DISALLOWED);
710         address vault = getRecoveryVault();
711         require(isContract(vault), ERROR_VAULT_NOT_CONTRACT);
712 
713         uint256 balance;
714         if (_token == ETH) {
715             balance = address(this).balance;
716             vault.transfer(balance);
717         } else {
718             ERC20 token = ERC20(_token);
719             balance = token.staticBalanceOf(this);
720             require(token.safeTransfer(vault, balance), ERROR_TOKEN_TRANSFER_FAILED);
721         }
722 
723         emit RecoverToVault(vault, _token, balance);
724     }
725 
726     /**
727     * @dev By default deriving from AragonApp makes it recoverable
728     * @param token Token address that would be recovered
729     * @return bool whether the app allows the recovery
730     */
731     function allowRecoverability(address token) public view returns (bool) {
732         return true;
733     }
734 
735     // Cast non-implemented interface to be public so we can use it internally
736     function getRecoveryVault() public view returns (address);
737 }
738 
739 // File: contracts/apps/AppStorage.sol
740 
741 /*
742  * SPDX-License-Identitifer:    MIT
743  */
744 
745 pragma solidity ^0.4.24;
746 
747 
748 
749 
750 contract AppStorage {
751     using UnstructuredStorage for bytes32;
752 
753     /* Hardcoded constants to save gas
754     bytes32 internal constant KERNEL_POSITION = keccak256("aragonOS.appStorage.kernel");
755     bytes32 internal constant APP_ID_POSITION = keccak256("aragonOS.appStorage.appId");
756     */
757     bytes32 internal constant KERNEL_POSITION = 0x4172f0f7d2289153072b0a6ca36959e0cbe2efc3afe50fc81636caa96338137b;
758     bytes32 internal constant APP_ID_POSITION = 0xd625496217aa6a3453eecb9c3489dc5a53e6c67b444329ea2b2cbc9ff547639b;
759 
760     function kernel() public view returns (IKernel) {
761         return IKernel(KERNEL_POSITION.getStorageAddress());
762     }
763 
764     function appId() public view returns (bytes32) {
765         return APP_ID_POSITION.getStorageBytes32();
766     }
767 
768     function setKernel(IKernel _kernel) internal {
769         KERNEL_POSITION.setStorageAddress(address(_kernel));
770     }
771 
772     function setAppId(bytes32 _appId) internal {
773         APP_ID_POSITION.setStorageBytes32(_appId);
774     }
775 }
776 
777 // File: contracts/lib/misc/ERCProxy.sol
778 
779 /*
780  * SPDX-License-Identitifer:    MIT
781  */
782 
783 pragma solidity ^0.4.24;
784 
785 
786 contract ERCProxy {
787     uint256 internal constant FORWARDING = 1;
788     uint256 internal constant UPGRADEABLE = 2;
789 
790     function proxyType() public pure returns (uint256 proxyTypeId);
791     function implementation() public view returns (address codeAddr);
792 }
793 
794 // File: contracts/common/DelegateProxy.sol
795 
796 pragma solidity 0.4.24;
797 
798 
799 
800 
801 contract DelegateProxy is ERCProxy, IsContract {
802     uint256 internal constant FWD_GAS_LIMIT = 10000;
803 
804     /**
805     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
806     * @param _dst Destination address to perform the delegatecall
807     * @param _calldata Calldata for the delegatecall
808     */
809     function delegatedFwd(address _dst, bytes _calldata) internal {
810         require(isContract(_dst));
811         uint256 fwdGasLimit = FWD_GAS_LIMIT;
812 
813         assembly {
814             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
815             let size := returndatasize
816             let ptr := mload(0x40)
817             returndatacopy(ptr, 0, size)
818 
819             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
820             // if the call returned error data, forward it
821             switch result case 0 { revert(ptr, size) }
822             default { return(ptr, size) }
823         }
824     }
825 }
826 
827 // File: contracts/common/DepositableStorage.sol
828 
829 pragma solidity 0.4.24;
830 
831 
832 
833 contract DepositableStorage {
834     using UnstructuredStorage for bytes32;
835 
836     // keccak256("aragonOS.depositableStorage.depositable")
837     bytes32 internal constant DEPOSITABLE_POSITION = 0x665fd576fbbe6f247aff98f5c94a561e3f71ec2d3c988d56f12d342396c50cea;
838 
839     function isDepositable() public view returns (bool) {
840         return DEPOSITABLE_POSITION.getStorageBool();
841     }
842 
843     function setDepositable(bool _depositable) internal {
844         DEPOSITABLE_POSITION.setStorageBool(_depositable);
845     }
846 }
847 
848 // File: contracts/common/DepositableDelegateProxy.sol
849 
850 pragma solidity 0.4.24;
851 
852 
853 
854 
855 contract DepositableDelegateProxy is DepositableStorage, DelegateProxy {
856     event ProxyDeposit(address sender, uint256 value);
857 
858     function () external payable {
859         // send / transfer
860         if (gasleft() < FWD_GAS_LIMIT) {
861             require(msg.value > 0 && msg.data.length == 0);
862             require(isDepositable());
863             emit ProxyDeposit(msg.sender, msg.value);
864         } else { // all calls except for send or transfer
865             address target = implementation();
866             delegatedFwd(target, msg.data);
867         }
868     }
869 }
870 
871 // File: contracts/apps/AppProxyBase.sol
872 
873 pragma solidity 0.4.24;
874 
875 
876 
877 
878 
879 
880 contract AppProxyBase is AppStorage, DepositableDelegateProxy, KernelNamespaceConstants {
881     /**
882     * @dev Initialize AppProxy
883     * @param _kernel Reference to organization kernel for the app
884     * @param _appId Identifier for app
885     * @param _initializePayload Payload for call to be made after setup to initialize
886     */
887     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public {
888         setKernel(_kernel);
889         setAppId(_appId);
890 
891         // Implicit check that kernel is actually a Kernel
892         // The EVM doesn't actually provide a way for us to make sure, but we can force a revert to
893         // occur if the kernel is set to 0x0 or a non-code address when we try to call a method on
894         // it.
895         address appCode = getAppBase(_appId);
896 
897         // If initialize payload is provided, it will be executed
898         if (_initializePayload.length > 0) {
899             require(isContract(appCode));
900             // Cannot make delegatecall as a delegateproxy.delegatedFwd as it
901             // returns ending execution context and halts contract deployment
902             require(appCode.delegatecall(_initializePayload));
903         }
904     }
905 
906     function getAppBase(bytes32 _appId) internal view returns (address) {
907         return kernel().getApp(KERNEL_APP_BASES_NAMESPACE, _appId);
908     }
909 }
910 
911 // File: contracts/apps/AppProxyUpgradeable.sol
912 
913 pragma solidity 0.4.24;
914 
915 
916 
917 contract AppProxyUpgradeable is AppProxyBase {
918     /**
919     * @dev Initialize AppProxyUpgradeable (makes it an upgradeable Aragon app)
920     * @param _kernel Reference to organization kernel for the app
921     * @param _appId Identifier for app
922     * @param _initializePayload Payload for call to be made after setup to initialize
923     */
924     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
925         AppProxyBase(_kernel, _appId, _initializePayload)
926         public // solium-disable-line visibility-first
927     {
928         // solium-disable-previous-line no-empty-blocks
929     }
930 
931     /**
932      * @dev ERC897, the address the proxy would delegate calls to
933      */
934     function implementation() public view returns (address) {
935         return getAppBase(appId());
936     }
937 
938     /**
939      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
940      */
941     function proxyType() public pure returns (uint256 proxyTypeId) {
942         return UPGRADEABLE;
943     }
944 }
945 
946 // File: contracts/apps/AppProxyPinned.sol
947 
948 pragma solidity 0.4.24;
949 
950 
951 
952 
953 
954 contract AppProxyPinned is IsContract, AppProxyBase {
955     using UnstructuredStorage for bytes32;
956 
957     // keccak256("aragonOS.appStorage.pinnedCode")
958     bytes32 internal constant PINNED_CODE_POSITION = 0xdee64df20d65e53d7f51cb6ab6d921a0a6a638a91e942e1d8d02df28e31c038e;
959 
960     /**
961     * @dev Initialize AppProxyPinned (makes it an un-upgradeable Aragon app)
962     * @param _kernel Reference to organization kernel for the app
963     * @param _appId Identifier for app
964     * @param _initializePayload Payload for call to be made after setup to initialize
965     */
966     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
967         AppProxyBase(_kernel, _appId, _initializePayload)
968         public // solium-disable-line visibility-first
969     {
970         setPinnedCode(getAppBase(_appId));
971         require(isContract(pinnedCode()));
972     }
973 
974     /**
975      * @dev ERC897, the address the proxy would delegate calls to
976      */
977     function implementation() public view returns (address) {
978         return pinnedCode();
979     }
980 
981     /**
982      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
983      */
984     function proxyType() public pure returns (uint256 proxyTypeId) {
985         return FORWARDING;
986     }
987 
988     function setPinnedCode(address _pinnedCode) internal {
989         PINNED_CODE_POSITION.setStorageAddress(_pinnedCode);
990     }
991 
992     function pinnedCode() internal view returns (address) {
993         return PINNED_CODE_POSITION.getStorageAddress();
994     }
995 }
996 
997 // File: contracts/factory/AppProxyFactory.sol
998 
999 pragma solidity 0.4.24;
1000 
1001 
1002 
1003 
1004 contract AppProxyFactory {
1005     event NewAppProxy(address proxy, bool isUpgradeable, bytes32 appId);
1006 
1007     /**
1008     * @notice Create a new upgradeable app instance on `_kernel` with identifier `_appId`
1009     * @param _kernel App's Kernel reference
1010     * @param _appId Identifier for app
1011     * @return AppProxyUpgradeable
1012     */
1013     function newAppProxy(IKernel _kernel, bytes32 _appId) public returns (AppProxyUpgradeable) {
1014         return newAppProxy(_kernel, _appId, new bytes(0));
1015     }
1016 
1017     /**
1018     * @notice Create a new upgradeable app instance on `_kernel` with identifier `_appId` and initialization payload `_initializePayload`
1019     * @param _kernel App's Kernel reference
1020     * @param _appId Identifier for app
1021     * @return AppProxyUpgradeable
1022     */
1023     function newAppProxy(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyUpgradeable) {
1024         AppProxyUpgradeable proxy = new AppProxyUpgradeable(_kernel, _appId, _initializePayload);
1025         emit NewAppProxy(address(proxy), true, _appId);
1026         return proxy;
1027     }
1028 
1029     /**
1030     * @notice Create a new pinned app instance on `_kernel` with identifier `_appId`
1031     * @param _kernel App's Kernel reference
1032     * @param _appId Identifier for app
1033     * @return AppProxyPinned
1034     */
1035     function newAppProxyPinned(IKernel _kernel, bytes32 _appId) public returns (AppProxyPinned) {
1036         return newAppProxyPinned(_kernel, _appId, new bytes(0));
1037     }
1038 
1039     /**
1040     * @notice Create a new pinned app instance on `_kernel` with identifier `_appId` and initialization payload `_initializePayload`
1041     * @param _kernel App's Kernel reference
1042     * @param _appId Identifier for app
1043     * @param _initializePayload Proxy initialization payload
1044     * @return AppProxyPinned
1045     */
1046     function newAppProxyPinned(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyPinned) {
1047         AppProxyPinned proxy = new AppProxyPinned(_kernel, _appId, _initializePayload);
1048         emit NewAppProxy(address(proxy), false, _appId);
1049         return proxy;
1050     }
1051 }
1052 
1053 // File: contracts/kernel/Kernel.sol
1054 
1055 pragma solidity 0.4.24;
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 
1065 
1066 
1067 
1068 
1069 // solium-disable-next-line max-len
1070 contract Kernel is IKernel, KernelStorage, KernelAppIds, KernelNamespaceConstants, Petrifiable, IsContract, VaultRecoverable, AppProxyFactory, ACLSyntaxSugar {
1071     /* Hardcoded constants to save gas
1072     bytes32 public constant APP_MANAGER_ROLE = keccak256("APP_MANAGER_ROLE");
1073     */
1074     bytes32 public constant APP_MANAGER_ROLE = 0xb6d92708f3d4817afc106147d969e229ced5c46e65e0a5002a0d391287762bd0;
1075 
1076     string private constant ERROR_APP_NOT_CONTRACT = "KERNEL_APP_NOT_CONTRACT";
1077     string private constant ERROR_INVALID_APP_CHANGE = "KERNEL_INVALID_APP_CHANGE";
1078     string private constant ERROR_AUTH_FAILED = "KERNEL_AUTH_FAILED";
1079 
1080     /**
1081     * @dev Constructor that allows the deployer to choose if the base instance should be petrified immediately.
1082     * @param _shouldPetrify Immediately petrify this instance so that it can never be initialized
1083     */
1084     constructor(bool _shouldPetrify) public {
1085         if (_shouldPetrify) {
1086             petrify();
1087         }
1088     }
1089 
1090     /**
1091     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
1092     * @notice Initialize this kernel instance along with its ACL and set `_permissionsCreator` as the entity that can create other permissions
1093     * @param _baseAcl Address of base ACL app
1094     * @param _permissionsCreator Entity that will be given permission over createPermission
1095     */
1096     function initialize(IACL _baseAcl, address _permissionsCreator) public onlyInit {
1097         initialized();
1098 
1099         // Set ACL base
1100         _setApp(KERNEL_APP_BASES_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, _baseAcl);
1101 
1102         // Create ACL instance and attach it as the default ACL app
1103         IACL acl = IACL(newAppProxy(this, KERNEL_DEFAULT_ACL_APP_ID));
1104         acl.initialize(_permissionsCreator);
1105         _setApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, acl);
1106 
1107         recoveryVaultAppId = KERNEL_DEFAULT_VAULT_APP_ID;
1108     }
1109 
1110     /**
1111     * @dev Create a new instance of an app linked to this kernel
1112     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`
1113     * @param _appId Identifier for app
1114     * @param _appBase Address of the app's base implementation
1115     * @return AppProxy instance
1116     */
1117     function newAppInstance(bytes32 _appId, address _appBase)
1118         public
1119         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
1120         returns (ERCProxy appProxy)
1121     {
1122         return newAppInstance(_appId, _appBase, new bytes(0), false);
1123     }
1124 
1125     /**
1126     * @dev Create a new instance of an app linked to this kernel and set its base
1127     *      implementation if it was not already set
1128     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
1129     * @param _appId Identifier for app
1130     * @param _appBase Address of the app's base implementation
1131     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
1132     * @param _setDefault Whether the app proxy app is the default one.
1133     *        Useful when the Kernel needs to know of an instance of a particular app,
1134     *        like Vault for escape hatch mechanism.
1135     * @return AppProxy instance
1136     */
1137     function newAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
1138         public
1139         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
1140         returns (ERCProxy appProxy)
1141     {
1142         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
1143         appProxy = newAppProxy(this, _appId, _initializePayload);
1144         // By calling setApp directly and not the internal functions, we make sure the params are checked
1145         // and it will only succeed if sender has permissions to set something to the namespace.
1146         if (_setDefault) {
1147             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
1148         }
1149     }
1150 
1151     /**
1152     * @dev Create a new pinned instance of an app linked to this kernel
1153     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`.
1154     * @param _appId Identifier for app
1155     * @param _appBase Address of the app's base implementation
1156     * @return AppProxy instance
1157     */
1158     function newPinnedAppInstance(bytes32 _appId, address _appBase)
1159         public
1160         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
1161         returns (ERCProxy appProxy)
1162     {
1163         return newPinnedAppInstance(_appId, _appBase, new bytes(0), false);
1164     }
1165 
1166     /**
1167     * @dev Create a new pinned instance of an app linked to this kernel and set
1168     *      its base implementation if it was not already set
1169     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
1170     * @param _appId Identifier for app
1171     * @param _appBase Address of the app's base implementation
1172     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
1173     * @param _setDefault Whether the app proxy app is the default one.
1174     *        Useful when the Kernel needs to know of an instance of a particular app,
1175     *        like Vault for escape hatch mechanism.
1176     * @return AppProxy instance
1177     */
1178     function newPinnedAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
1179         public
1180         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
1181         returns (ERCProxy appProxy)
1182     {
1183         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
1184         appProxy = newAppProxyPinned(this, _appId, _initializePayload);
1185         // By calling setApp directly and not the internal functions, we make sure the params are checked
1186         // and it will only succeed if sender has permissions to set something to the namespace.
1187         if (_setDefault) {
1188             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
1189         }
1190     }
1191 
1192     /**
1193     * @dev Set the resolving address of an app instance or base implementation
1194     * @notice Set the resolving address of `_appId` in namespace `_namespace` to `_app`
1195     * @param _namespace App namespace to use
1196     * @param _appId Identifier for app
1197     * @param _app Address of the app instance or base implementation
1198     * @return ID of app
1199     */
1200     function setApp(bytes32 _namespace, bytes32 _appId, address _app)
1201         public
1202         auth(APP_MANAGER_ROLE, arr(_namespace, _appId))
1203     {
1204         _setApp(_namespace, _appId, _app);
1205     }
1206 
1207     /**
1208     * @dev Set the default vault id for the escape hatch mechanism
1209     * @param _recoveryVaultAppId Identifier of the recovery vault app
1210     */
1211     function setRecoveryVaultAppId(bytes32 _recoveryVaultAppId)
1212         public
1213         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_ADDR_NAMESPACE, _recoveryVaultAppId))
1214     {
1215         recoveryVaultAppId = _recoveryVaultAppId;
1216     }
1217 
1218     // External access to default app id and namespace constants to mimic default getters for constants
1219     /* solium-disable function-order, mixedcase */
1220     function CORE_NAMESPACE() external pure returns (bytes32) { return KERNEL_CORE_NAMESPACE; }
1221     function APP_BASES_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_BASES_NAMESPACE; }
1222     function APP_ADDR_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_ADDR_NAMESPACE; }
1223     function KERNEL_APP_ID() external pure returns (bytes32) { return KERNEL_CORE_APP_ID; }
1224     function DEFAULT_ACL_APP_ID() external pure returns (bytes32) { return KERNEL_DEFAULT_ACL_APP_ID; }
1225     /* solium-enable function-order, mixedcase */
1226 
1227     /**
1228     * @dev Get the address of an app instance or base implementation
1229     * @param _namespace App namespace to use
1230     * @param _appId Identifier for app
1231     * @return Address of the app
1232     */
1233     function getApp(bytes32 _namespace, bytes32 _appId) public view returns (address) {
1234         return apps[_namespace][_appId];
1235     }
1236 
1237     /**
1238     * @dev Get the address of the recovery Vault instance (to recover funds)
1239     * @return Address of the Vault
1240     */
1241     function getRecoveryVault() public view returns (address) {
1242         return apps[KERNEL_APP_ADDR_NAMESPACE][recoveryVaultAppId];
1243     }
1244 
1245     /**
1246     * @dev Get the installed ACL app
1247     * @return ACL app
1248     */
1249     function acl() public view returns (IACL) {
1250         return IACL(getApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID));
1251     }
1252 
1253     /**
1254     * @dev Function called by apps to check ACL on kernel or to check permission status
1255     * @param _who Sender of the original call
1256     * @param _where Address of the app
1257     * @param _what Identifier for a group of actions in app
1258     * @param _how Extra data for ACL auth
1259     * @return Boolean indicating whether the ACL allows the role or not.
1260     *         Always returns false if the kernel hasn't been initialized yet.
1261     */
1262     function hasPermission(address _who, address _where, bytes32 _what, bytes _how) public view returns (bool) {
1263         IACL defaultAcl = acl();
1264         return address(defaultAcl) != address(0) && // Poor man's initialization check (saves gas)
1265             defaultAcl.hasPermission(_who, _where, _what, _how);
1266     }
1267 
1268     function _setApp(bytes32 _namespace, bytes32 _appId, address _app) internal {
1269         require(isContract(_app), ERROR_APP_NOT_CONTRACT);
1270         apps[_namespace][_appId] = _app;
1271         emit SetApp(_namespace, _appId, _app);
1272     }
1273 
1274     function _setAppIfNew(bytes32 _namespace, bytes32 _appId, address _app) internal {
1275         address app = getApp(_namespace, _appId);
1276         if (app != address(0)) {
1277             // The only way to set an app is if it passes the isContract check, so no need to check it again
1278             require(app == _app, ERROR_INVALID_APP_CHANGE);
1279         } else {
1280             _setApp(_namespace, _appId, _app);
1281         }
1282     }
1283 
1284     modifier auth(bytes32 _role, uint256[] memory _params) {
1285         require(
1286             hasPermission(msg.sender, address(this), _role, ConversionHelpers.dangerouslyCastUintArrayToBytes(_params)),
1287             ERROR_AUTH_FAILED
1288         );
1289         _;
1290     }
1291 }
1292 
1293 // File: contracts/kernel/KernelProxy.sol
1294 
1295 pragma solidity 0.4.24;
1296 
1297 
1298 
1299 
1300 
1301 
1302 
1303 contract KernelProxy is IKernelEvents, KernelStorage, KernelAppIds, KernelNamespaceConstants, IsContract, DepositableDelegateProxy {
1304     /**
1305     * @dev KernelProxy is a proxy contract to a kernel implementation. The implementation
1306     *      can update the reference, which effectively upgrades the contract
1307     * @param _kernelImpl Address of the contract used as implementation for kernel
1308     */
1309     constructor(IKernel _kernelImpl) public {
1310         require(isContract(address(_kernelImpl)));
1311         apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID] = _kernelImpl;
1312 
1313         // Note that emitting this event is important for verifying that a KernelProxy instance
1314         // was never upgraded to a malicious Kernel logic contract over its lifespan.
1315         // This starts the "chain of trust", that can be followed through later SetApp() events
1316         // emitted during kernel upgrades.
1317         emit SetApp(KERNEL_CORE_NAMESPACE, KERNEL_CORE_APP_ID, _kernelImpl);
1318     }
1319 
1320     /**
1321      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
1322      */
1323     function proxyType() public pure returns (uint256 proxyTypeId) {
1324         return UPGRADEABLE;
1325     }
1326 
1327     /**
1328     * @dev ERC897, the address the proxy would delegate calls to
1329     */
1330     function implementation() public view returns (address) {
1331         return apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID];
1332     }
1333 }
1334 
1335 // File: contracts/common/Autopetrified.sol
1336 
1337 /*
1338  * SPDX-License-Identitifer:    MIT
1339  */
1340 
1341 pragma solidity ^0.4.24;
1342 
1343 
1344 
1345 contract Autopetrified is Petrifiable {
1346     constructor() public {
1347         // Immediately petrify base (non-proxy) instances of inherited contracts on deploy.
1348         // This renders them uninitializable (and unusable without a proxy).
1349         petrify();
1350     }
1351 }
1352 
1353 // File: contracts/common/ReentrancyGuard.sol
1354 
1355 /*
1356  * SPDX-License-Identitifer:    MIT
1357  */
1358 
1359 pragma solidity ^0.4.24;
1360 
1361 
1362 
1363 contract ReentrancyGuard {
1364     using UnstructuredStorage for bytes32;
1365 
1366     /* Hardcoded constants to save gas
1367     bytes32 internal constant REENTRANCY_MUTEX_POSITION = keccak256("aragonOS.reentrancyGuard.mutex");
1368     */
1369     bytes32 private constant REENTRANCY_MUTEX_POSITION = 0xe855346402235fdd185c890e68d2c4ecad599b88587635ee285bce2fda58dacb;
1370 
1371     string private constant ERROR_REENTRANT = "REENTRANCY_REENTRANT_CALL";
1372 
1373     modifier nonReentrant() {
1374         // Ensure mutex is unlocked
1375         require(!REENTRANCY_MUTEX_POSITION.getStorageBool(), ERROR_REENTRANT);
1376 
1377         // Lock mutex before function call
1378         REENTRANCY_MUTEX_POSITION.setStorageBool(true);
1379 
1380         // Perform function call
1381         _;
1382 
1383         // Unlock mutex after function call
1384         REENTRANCY_MUTEX_POSITION.setStorageBool(false);
1385     }
1386 }
1387 
1388 // File: contracts/evmscript/IEVMScriptExecutor.sol
1389 
1390 /*
1391  * SPDX-License-Identitifer:    MIT
1392  */
1393 
1394 pragma solidity ^0.4.24;
1395 
1396 
1397 interface IEVMScriptExecutor {
1398     function execScript(bytes script, bytes input, address[] blacklist) external returns (bytes);
1399     function executorType() external pure returns (bytes32);
1400 }
1401 
1402 // File: contracts/evmscript/IEVMScriptRegistry.sol
1403 
1404 /*
1405  * SPDX-License-Identitifer:    MIT
1406  */
1407 
1408 pragma solidity ^0.4.24;
1409 
1410 
1411 
1412 contract EVMScriptRegistryConstants {
1413     /* Hardcoded constants to save gas
1414     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = apmNamehash("evmreg");
1415     */
1416     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = 0xddbcfd564f642ab5627cf68b9b7d374fb4f8a36e941a75d89c87998cef03bd61;
1417 }
1418 
1419 
1420 interface IEVMScriptRegistry {
1421     function addScriptExecutor(IEVMScriptExecutor executor) external returns (uint id);
1422     function disableScriptExecutor(uint256 executorId) external;
1423 
1424     // TODO: this should be external
1425     // See https://github.com/ethereum/solidity/issues/4832
1426     function getScriptExecutor(bytes script) public view returns (IEVMScriptExecutor);
1427 }
1428 
1429 // File: contracts/evmscript/EVMScriptRunner.sol
1430 
1431 /*
1432  * SPDX-License-Identitifer:    MIT
1433  */
1434 
1435 pragma solidity ^0.4.24;
1436 
1437 
1438 
1439 
1440 
1441 
1442 
1443 contract EVMScriptRunner is AppStorage, Initializable, EVMScriptRegistryConstants, KernelNamespaceConstants {
1444     string private constant ERROR_EXECUTOR_UNAVAILABLE = "EVMRUN_EXECUTOR_UNAVAILABLE";
1445     string private constant ERROR_PROTECTED_STATE_MODIFIED = "EVMRUN_PROTECTED_STATE_MODIFIED";
1446 
1447     /* This is manually crafted in assembly
1448     string private constant ERROR_EXECUTOR_INVALID_RETURN = "EVMRUN_EXECUTOR_INVALID_RETURN";
1449     */
1450 
1451     event ScriptResult(address indexed executor, bytes script, bytes input, bytes returnData);
1452 
1453     function getEVMScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
1454         return IEVMScriptExecutor(getEVMScriptRegistry().getScriptExecutor(_script));
1455     }
1456 
1457     function getEVMScriptRegistry() public view returns (IEVMScriptRegistry) {
1458         address registryAddr = kernel().getApp(KERNEL_APP_ADDR_NAMESPACE, EVMSCRIPT_REGISTRY_APP_ID);
1459         return IEVMScriptRegistry(registryAddr);
1460     }
1461 
1462     function runScript(bytes _script, bytes _input, address[] _blacklist)
1463         internal
1464         isInitialized
1465         protectState
1466         returns (bytes)
1467     {
1468         IEVMScriptExecutor executor = getEVMScriptExecutor(_script);
1469         require(address(executor) != address(0), ERROR_EXECUTOR_UNAVAILABLE);
1470 
1471         bytes4 sig = executor.execScript.selector;
1472         bytes memory data = abi.encodeWithSelector(sig, _script, _input, _blacklist);
1473 
1474         bytes memory output;
1475         assembly {
1476             let success := delegatecall(
1477                 gas,                // forward all gas
1478                 executor,           // address
1479                 add(data, 0x20),    // calldata start
1480                 mload(data),        // calldata length
1481                 0,                  // don't write output (we'll handle this ourselves)
1482                 0                   // don't write output
1483             )
1484 
1485             output := mload(0x40) // free mem ptr get
1486 
1487             switch success
1488             case 0 {
1489                 // If the call errored, forward its full error data
1490                 returndatacopy(output, 0, returndatasize)
1491                 revert(output, returndatasize)
1492             }
1493             default {
1494                 switch gt(returndatasize, 0x3f)
1495                 case 0 {
1496                     // Need at least 0x40 bytes returned for properly ABI-encoded bytes values,
1497                     // revert with "EVMRUN_EXECUTOR_INVALID_RETURN"
1498                     // See remix: doing a `revert("EVMRUN_EXECUTOR_INVALID_RETURN")` always results in
1499                     // this memory layout
1500                     mstore(output, 0x08c379a000000000000000000000000000000000000000000000000000000000)         // error identifier
1501                     mstore(add(output, 0x04), 0x0000000000000000000000000000000000000000000000000000000000000020) // starting offset
1502                     mstore(add(output, 0x24), 0x000000000000000000000000000000000000000000000000000000000000001e) // reason length
1503                     mstore(add(output, 0x44), 0x45564d52554e5f4558454355544f525f494e56414c49445f52455455524e0000) // reason
1504 
1505                     revert(output, 100) // 100 = 4 + 3 * 32 (error identifier + 3 words for the ABI encoded error)
1506                 }
1507                 default {
1508                     // Copy result
1509                     //
1510                     // Needs to perform an ABI decode for the expected `bytes` return type of
1511                     // `executor.execScript()` as solidity will automatically ABI encode the returned bytes as:
1512                     //    [ position of the first dynamic length return value = 0x20 (32 bytes) ]
1513                     //    [ output length (32 bytes) ]
1514                     //    [ output content (N bytes) ]
1515                     //
1516                     // Perform the ABI decode by ignoring the first 32 bytes of the return data
1517                     let copysize := sub(returndatasize, 0x20)
1518                     returndatacopy(output, 0x20, copysize)
1519 
1520                     mstore(0x40, add(output, copysize)) // free mem ptr set
1521                 }
1522             }
1523         }
1524 
1525         emit ScriptResult(address(executor), _script, _input, output);
1526 
1527         return output;
1528     }
1529 
1530     modifier protectState {
1531         address preKernel = address(kernel());
1532         bytes32 preAppId = appId();
1533         _; // exec
1534         require(address(kernel()) == preKernel, ERROR_PROTECTED_STATE_MODIFIED);
1535         require(appId() == preAppId, ERROR_PROTECTED_STATE_MODIFIED);
1536     }
1537 }
1538 
1539 // File: contracts/apps/AragonApp.sol
1540 
1541 /*
1542  * SPDX-License-Identitifer:    MIT
1543  */
1544 
1545 pragma solidity ^0.4.24;
1546 
1547 
1548 
1549 
1550 
1551 
1552 
1553 
1554 
1555 // Contracts inheriting from AragonApp are, by default, immediately petrified upon deployment so
1556 // that they can never be initialized.
1557 // Unless overriden, this behaviour enforces those contracts to be usable only behind an AppProxy.
1558 // ReentrancyGuard, EVMScriptRunner, and ACLSyntaxSugar are not directly used by this contract, but
1559 // are included so that they are automatically usable by subclassing contracts
1560 contract AragonApp is AppStorage, Autopetrified, VaultRecoverable, ReentrancyGuard, EVMScriptRunner, ACLSyntaxSugar {
1561     string private constant ERROR_AUTH_FAILED = "APP_AUTH_FAILED";
1562 
1563     modifier auth(bytes32 _role) {
1564         require(canPerform(msg.sender, _role, new uint256[](0)), ERROR_AUTH_FAILED);
1565         _;
1566     }
1567 
1568     modifier authP(bytes32 _role, uint256[] _params) {
1569         require(canPerform(msg.sender, _role, _params), ERROR_AUTH_FAILED);
1570         _;
1571     }
1572 
1573     /**
1574     * @dev Check whether an action can be performed by a sender for a particular role on this app
1575     * @param _sender Sender of the call
1576     * @param _role Role on this app
1577     * @param _params Permission params for the role
1578     * @return Boolean indicating whether the sender has the permissions to perform the action.
1579     *         Always returns false if the app hasn't been initialized yet.
1580     */
1581     function canPerform(address _sender, bytes32 _role, uint256[] _params) public view returns (bool) {
1582         if (!hasInitialized()) {
1583             return false;
1584         }
1585 
1586         IKernel linkedKernel = kernel();
1587         if (address(linkedKernel) == address(0)) {
1588             return false;
1589         }
1590 
1591         return linkedKernel.hasPermission(
1592             _sender,
1593             address(this),
1594             _role,
1595             ConversionHelpers.dangerouslyCastUintArrayToBytes(_params)
1596         );
1597     }
1598 
1599     /**
1600     * @dev Get the recovery vault for the app
1601     * @return Recovery vault address for the app
1602     */
1603     function getRecoveryVault() public view returns (address) {
1604         // Funds recovery via a vault is only available when used with a kernel
1605         return kernel().getRecoveryVault(); // if kernel is not set, it will revert
1606     }
1607 }
1608 
1609 // File: contracts/acl/IACLOracle.sol
1610 
1611 /*
1612  * SPDX-License-Identitifer:    MIT
1613  */
1614 
1615 pragma solidity ^0.4.24;
1616 
1617 
1618 interface IACLOracle {
1619     function canPerform(address who, address where, bytes32 what, uint256[] how) external view returns (bool);
1620 }
1621 
1622 // File: contracts/acl/ACL.sol
1623 
1624 pragma solidity 0.4.24;
1625 
1626 
1627 
1628 
1629 
1630 
1631 
1632 
1633 /* solium-disable function-order */
1634 // Allow public initialize() to be first
1635 contract ACL is IACL, TimeHelpers, AragonApp, ACLHelpers {
1636     /* Hardcoded constants to save gas
1637     bytes32 public constant CREATE_PERMISSIONS_ROLE = keccak256("CREATE_PERMISSIONS_ROLE");
1638     */
1639     bytes32 public constant CREATE_PERMISSIONS_ROLE = 0x0b719b33c83b8e5d300c521cb8b54ae9bd933996a14bef8c2f4e0285d2d2400a;
1640 
1641     enum Op { NONE, EQ, NEQ, GT, LT, GTE, LTE, RET, NOT, AND, OR, XOR, IF_ELSE } // op types
1642 
1643     struct Param {
1644         uint8 id;
1645         uint8 op;
1646         uint240 value; // even though value is an uint240 it can store addresses
1647         // in the case of 32 byte hashes losing 2 bytes precision isn't a huge deal
1648         // op and id take less than 1 byte each so it can be kept in 1 sstore
1649     }
1650 
1651     uint8 internal constant BLOCK_NUMBER_PARAM_ID = 200;
1652     uint8 internal constant TIMESTAMP_PARAM_ID    = 201;
1653     // 202 is unused
1654     uint8 internal constant ORACLE_PARAM_ID       = 203;
1655     uint8 internal constant LOGIC_OP_PARAM_ID     = 204;
1656     uint8 internal constant PARAM_VALUE_PARAM_ID  = 205;
1657     // TODO: Add execution times param type?
1658 
1659     /* Hardcoded constant to save gas
1660     bytes32 public constant EMPTY_PARAM_HASH = keccak256(uint256(0));
1661     */
1662     bytes32 public constant EMPTY_PARAM_HASH = 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563;
1663     bytes32 public constant NO_PERMISSION = bytes32(0);
1664     address public constant ANY_ENTITY = address(-1);
1665     address public constant BURN_ENTITY = address(1); // address(0) is already used as "no permission manager"
1666 
1667     uint256 internal constant ORACLE_CHECK_GAS = 30000;
1668 
1669     string private constant ERROR_AUTH_INIT_KERNEL = "ACL_AUTH_INIT_KERNEL";
1670     string private constant ERROR_AUTH_NO_MANAGER = "ACL_AUTH_NO_MANAGER";
1671     string private constant ERROR_EXISTENT_MANAGER = "ACL_EXISTENT_MANAGER";
1672 
1673     // Whether someone has a permission
1674     mapping (bytes32 => bytes32) internal permissions; // permissions hash => params hash
1675     mapping (bytes32 => Param[]) internal permissionParams; // params hash => params
1676 
1677     // Who is the manager of a permission
1678     mapping (bytes32 => address) internal permissionManager;
1679 
1680     event SetPermission(address indexed entity, address indexed app, bytes32 indexed role, bool allowed);
1681     event SetPermissionParams(address indexed entity, address indexed app, bytes32 indexed role, bytes32 paramsHash);
1682     event ChangePermissionManager(address indexed app, bytes32 indexed role, address indexed manager);
1683 
1684     modifier onlyPermissionManager(address _app, bytes32 _role) {
1685         require(msg.sender == getPermissionManager(_app, _role), ERROR_AUTH_NO_MANAGER);
1686         _;
1687     }
1688 
1689     modifier noPermissionManager(address _app, bytes32 _role) {
1690         // only allow permission creation (or re-creation) when there is no manager
1691         require(getPermissionManager(_app, _role) == address(0), ERROR_EXISTENT_MANAGER);
1692         _;
1693     }
1694 
1695     /**
1696     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
1697     * @notice Initialize an ACL instance and set `_permissionsCreator` as the entity that can create other permissions
1698     * @param _permissionsCreator Entity that will be given permission over createPermission
1699     */
1700     function initialize(address _permissionsCreator) public onlyInit {
1701         initialized();
1702         require(msg.sender == address(kernel()), ERROR_AUTH_INIT_KERNEL);
1703 
1704         _createPermission(_permissionsCreator, this, CREATE_PERMISSIONS_ROLE, _permissionsCreator);
1705     }
1706 
1707     /**
1708     * @dev Creates a permission that wasn't previously set and managed.
1709     *      If a created permission is removed it is possible to reset it with createPermission.
1710     *      This is the **ONLY** way to create permissions and set managers to permissions that don't
1711     *      have a manager.
1712     *      In terms of the ACL being initialized, this function implicitly protects all the other
1713     *      state-changing external functions, as they all require the sender to be a manager.
1714     * @notice Create a new permission granting `_entity` the ability to perform actions requiring `_role` on `_app`, setting `_manager` as the permission's manager
1715     * @param _entity Address of the whitelisted entity that will be able to perform the role
1716     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1717     * @param _role Identifier for the group of actions in app given access to perform
1718     * @param _manager Address of the entity that will be able to grant and revoke the permission further.
1719     */
1720     function createPermission(address _entity, address _app, bytes32 _role, address _manager)
1721         external
1722         auth(CREATE_PERMISSIONS_ROLE)
1723         noPermissionManager(_app, _role)
1724     {
1725         _createPermission(_entity, _app, _role, _manager);
1726     }
1727 
1728     /**
1729     * @dev Grants permission if allowed. This requires `msg.sender` to be the permission manager
1730     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
1731     * @param _entity Address of the whitelisted entity that will be able to perform the role
1732     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1733     * @param _role Identifier for the group of actions in app given access to perform
1734     */
1735     function grantPermission(address _entity, address _app, bytes32 _role)
1736         external
1737     {
1738         grantPermissionP(_entity, _app, _role, new uint256[](0));
1739     }
1740 
1741     /**
1742     * @dev Grants a permission with parameters if allowed. This requires `msg.sender` to be the permission manager
1743     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
1744     * @param _entity Address of the whitelisted entity that will be able to perform the role
1745     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
1746     * @param _role Identifier for the group of actions in app given access to perform
1747     * @param _params Permission parameters
1748     */
1749     function grantPermissionP(address _entity, address _app, bytes32 _role, uint256[] _params)
1750         public
1751         onlyPermissionManager(_app, _role)
1752     {
1753         bytes32 paramsHash = _params.length > 0 ? _saveParams(_params) : EMPTY_PARAM_HASH;
1754         _setPermission(_entity, _app, _role, paramsHash);
1755     }
1756 
1757     /**
1758     * @dev Revokes permission if allowed. This requires `msg.sender` to be the the permission manager
1759     * @notice Revoke from `_entity` the ability to perform actions requiring `_role` on `_app`
1760     * @param _entity Address of the whitelisted entity to revoke access from
1761     * @param _app Address of the app in which the role will be revoked
1762     * @param _role Identifier for the group of actions in app being revoked
1763     */
1764     function revokePermission(address _entity, address _app, bytes32 _role)
1765         external
1766         onlyPermissionManager(_app, _role)
1767     {
1768         _setPermission(_entity, _app, _role, NO_PERMISSION);
1769     }
1770 
1771     /**
1772     * @notice Set `_newManager` as the manager of `_role` in `_app`
1773     * @param _newManager Address for the new manager
1774     * @param _app Address of the app in which the permission management is being transferred
1775     * @param _role Identifier for the group of actions being transferred
1776     */
1777     function setPermissionManager(address _newManager, address _app, bytes32 _role)
1778         external
1779         onlyPermissionManager(_app, _role)
1780     {
1781         _setPermissionManager(_newManager, _app, _role);
1782     }
1783 
1784     /**
1785     * @notice Remove the manager of `_role` in `_app`
1786     * @param _app Address of the app in which the permission is being unmanaged
1787     * @param _role Identifier for the group of actions being unmanaged
1788     */
1789     function removePermissionManager(address _app, bytes32 _role)
1790         external
1791         onlyPermissionManager(_app, _role)
1792     {
1793         _setPermissionManager(address(0), _app, _role);
1794     }
1795 
1796     /**
1797     * @notice Burn non-existent `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
1798     * @param _app Address of the app in which the permission is being burned
1799     * @param _role Identifier for the group of actions being burned
1800     */
1801     function createBurnedPermission(address _app, bytes32 _role)
1802         external
1803         auth(CREATE_PERMISSIONS_ROLE)
1804         noPermissionManager(_app, _role)
1805     {
1806         _setPermissionManager(BURN_ENTITY, _app, _role);
1807     }
1808 
1809     /**
1810     * @notice Burn `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
1811     * @param _app Address of the app in which the permission is being burned
1812     * @param _role Identifier for the group of actions being burned
1813     */
1814     function burnPermissionManager(address _app, bytes32 _role)
1815         external
1816         onlyPermissionManager(_app, _role)
1817     {
1818         _setPermissionManager(BURN_ENTITY, _app, _role);
1819     }
1820 
1821     /**
1822      * @notice Get parameters for permission array length
1823      * @param _entity Address of the whitelisted entity that will be able to perform the role
1824      * @param _app Address of the app
1825      * @param _role Identifier for a group of actions in app
1826      * @return Length of the array
1827      */
1828     function getPermissionParamsLength(address _entity, address _app, bytes32 _role) external view returns (uint) {
1829         return permissionParams[permissions[permissionHash(_entity, _app, _role)]].length;
1830     }
1831 
1832     /**
1833     * @notice Get parameter for permission
1834     * @param _entity Address of the whitelisted entity that will be able to perform the role
1835     * @param _app Address of the app
1836     * @param _role Identifier for a group of actions in app
1837     * @param _index Index of parameter in the array
1838     * @return Parameter (id, op, value)
1839     */
1840     function getPermissionParam(address _entity, address _app, bytes32 _role, uint _index)
1841         external
1842         view
1843         returns (uint8, uint8, uint240)
1844     {
1845         Param storage param = permissionParams[permissions[permissionHash(_entity, _app, _role)]][_index];
1846         return (param.id, param.op, param.value);
1847     }
1848 
1849     /**
1850     * @dev Get manager for permission
1851     * @param _app Address of the app
1852     * @param _role Identifier for a group of actions in app
1853     * @return address of the manager for the permission
1854     */
1855     function getPermissionManager(address _app, bytes32 _role) public view returns (address) {
1856         return permissionManager[roleHash(_app, _role)];
1857     }
1858 
1859     /**
1860     * @dev Function called by apps to check ACL on kernel or to check permission statu
1861     * @param _who Sender of the original call
1862     * @param _where Address of the app
1863     * @param _where Identifier for a group of actions in app
1864     * @param _how Permission parameters
1865     * @return boolean indicating whether the ACL allows the role or not
1866     */
1867     function hasPermission(address _who, address _where, bytes32 _what, bytes memory _how) public view returns (bool) {
1868         return hasPermission(_who, _where, _what, ConversionHelpers.dangerouslyCastBytesToUintArray(_how));
1869     }
1870 
1871     function hasPermission(address _who, address _where, bytes32 _what, uint256[] memory _how) public view returns (bool) {
1872         bytes32 whoParams = permissions[permissionHash(_who, _where, _what)];
1873         if (whoParams != NO_PERMISSION && evalParams(whoParams, _who, _where, _what, _how)) {
1874             return true;
1875         }
1876 
1877         bytes32 anyParams = permissions[permissionHash(ANY_ENTITY, _where, _what)];
1878         if (anyParams != NO_PERMISSION && evalParams(anyParams, ANY_ENTITY, _where, _what, _how)) {
1879             return true;
1880         }
1881 
1882         return false;
1883     }
1884 
1885     function hasPermission(address _who, address _where, bytes32 _what) public view returns (bool) {
1886         uint256[] memory empty = new uint256[](0);
1887         return hasPermission(_who, _where, _what, empty);
1888     }
1889 
1890     function evalParams(
1891         bytes32 _paramsHash,
1892         address _who,
1893         address _where,
1894         bytes32 _what,
1895         uint256[] _how
1896     ) public view returns (bool)
1897     {
1898         if (_paramsHash == EMPTY_PARAM_HASH) {
1899             return true;
1900         }
1901 
1902         return _evalParam(_paramsHash, 0, _who, _where, _what, _how);
1903     }
1904 
1905     /**
1906     * @dev Internal createPermission for access inside the kernel (on instantiation)
1907     */
1908     function _createPermission(address _entity, address _app, bytes32 _role, address _manager) internal {
1909         _setPermission(_entity, _app, _role, EMPTY_PARAM_HASH);
1910         _setPermissionManager(_manager, _app, _role);
1911     }
1912 
1913     /**
1914     * @dev Internal function called to actually save the permission
1915     */
1916     function _setPermission(address _entity, address _app, bytes32 _role, bytes32 _paramsHash) internal {
1917         permissions[permissionHash(_entity, _app, _role)] = _paramsHash;
1918         bool entityHasPermission = _paramsHash != NO_PERMISSION;
1919         bool permissionHasParams = entityHasPermission && _paramsHash != EMPTY_PARAM_HASH;
1920 
1921         emit SetPermission(_entity, _app, _role, entityHasPermission);
1922         if (permissionHasParams) {
1923             emit SetPermissionParams(_entity, _app, _role, _paramsHash);
1924         }
1925     }
1926 
1927     function _saveParams(uint256[] _encodedParams) internal returns (bytes32) {
1928         bytes32 paramHash = keccak256(abi.encodePacked(_encodedParams));
1929         Param[] storage params = permissionParams[paramHash];
1930 
1931         if (params.length == 0) { // params not saved before
1932             for (uint256 i = 0; i < _encodedParams.length; i++) {
1933                 uint256 encodedParam = _encodedParams[i];
1934                 Param memory param = Param(decodeParamId(encodedParam), decodeParamOp(encodedParam), uint240(encodedParam));
1935                 params.push(param);
1936             }
1937         }
1938 
1939         return paramHash;
1940     }
1941 
1942     function _evalParam(
1943         bytes32 _paramsHash,
1944         uint32 _paramId,
1945         address _who,
1946         address _where,
1947         bytes32 _what,
1948         uint256[] _how
1949     ) internal view returns (bool)
1950     {
1951         if (_paramId >= permissionParams[_paramsHash].length) {
1952             return false; // out of bounds
1953         }
1954 
1955         Param memory param = permissionParams[_paramsHash][_paramId];
1956 
1957         if (param.id == LOGIC_OP_PARAM_ID) {
1958             return _evalLogic(param, _paramsHash, _who, _where, _what, _how);
1959         }
1960 
1961         uint256 value;
1962         uint256 comparedTo = uint256(param.value);
1963 
1964         // get value
1965         if (param.id == ORACLE_PARAM_ID) {
1966             value = checkOracle(IACLOracle(param.value), _who, _where, _what, _how) ? 1 : 0;
1967             comparedTo = 1;
1968         } else if (param.id == BLOCK_NUMBER_PARAM_ID) {
1969             value = getBlockNumber();
1970         } else if (param.id == TIMESTAMP_PARAM_ID) {
1971             value = getTimestamp();
1972         } else if (param.id == PARAM_VALUE_PARAM_ID) {
1973             value = uint256(param.value);
1974         } else {
1975             if (param.id >= _how.length) {
1976                 return false;
1977             }
1978             value = uint256(uint240(_how[param.id])); // force lost precision
1979         }
1980 
1981         if (Op(param.op) == Op.RET) {
1982             return uint256(value) > 0;
1983         }
1984 
1985         return compare(value, Op(param.op), comparedTo);
1986     }
1987 
1988     function _evalLogic(Param _param, bytes32 _paramsHash, address _who, address _where, bytes32 _what, uint256[] _how)
1989         internal
1990         view
1991         returns (bool)
1992     {
1993         if (Op(_param.op) == Op.IF_ELSE) {
1994             uint32 conditionParam;
1995             uint32 successParam;
1996             uint32 failureParam;
1997 
1998             (conditionParam, successParam, failureParam) = decodeParamsList(uint256(_param.value));
1999             bool result = _evalParam(_paramsHash, conditionParam, _who, _where, _what, _how);
2000 
2001             return _evalParam(_paramsHash, result ? successParam : failureParam, _who, _where, _what, _how);
2002         }
2003 
2004         uint32 param1;
2005         uint32 param2;
2006 
2007         (param1, param2,) = decodeParamsList(uint256(_param.value));
2008         bool r1 = _evalParam(_paramsHash, param1, _who, _where, _what, _how);
2009 
2010         if (Op(_param.op) == Op.NOT) {
2011             return !r1;
2012         }
2013 
2014         if (r1 && Op(_param.op) == Op.OR) {
2015             return true;
2016         }
2017 
2018         if (!r1 && Op(_param.op) == Op.AND) {
2019             return false;
2020         }
2021 
2022         bool r2 = _evalParam(_paramsHash, param2, _who, _where, _what, _how);
2023 
2024         if (Op(_param.op) == Op.XOR) {
2025             return r1 != r2;
2026         }
2027 
2028         return r2; // both or and and depend on result of r2 after checks
2029     }
2030 
2031     function compare(uint256 _a, Op _op, uint256 _b) internal pure returns (bool) {
2032         if (_op == Op.EQ)  return _a == _b;                              // solium-disable-line lbrace
2033         if (_op == Op.NEQ) return _a != _b;                              // solium-disable-line lbrace
2034         if (_op == Op.GT)  return _a > _b;                               // solium-disable-line lbrace
2035         if (_op == Op.LT)  return _a < _b;                               // solium-disable-line lbrace
2036         if (_op == Op.GTE) return _a >= _b;                              // solium-disable-line lbrace
2037         if (_op == Op.LTE) return _a <= _b;                              // solium-disable-line lbrace
2038         return false;
2039     }
2040 
2041     function checkOracle(IACLOracle _oracleAddr, address _who, address _where, bytes32 _what, uint256[] _how) internal view returns (bool) {
2042         bytes4 sig = _oracleAddr.canPerform.selector;
2043 
2044         // a raw call is required so we can return false if the call reverts, rather than reverting
2045         bytes memory checkCalldata = abi.encodeWithSelector(sig, _who, _where, _what, _how);
2046         uint256 oracleCheckGas = ORACLE_CHECK_GAS;
2047 
2048         bool ok;
2049         assembly {
2050             ok := staticcall(oracleCheckGas, _oracleAddr, add(checkCalldata, 0x20), mload(checkCalldata), 0, 0)
2051         }
2052 
2053         if (!ok) {
2054             return false;
2055         }
2056 
2057         uint256 size;
2058         assembly { size := returndatasize }
2059         if (size != 32) {
2060             return false;
2061         }
2062 
2063         bool result;
2064         assembly {
2065             let ptr := mload(0x40)       // get next free memory ptr
2066             returndatacopy(ptr, 0, size) // copy return from above `staticcall`
2067             result := mload(ptr)         // read data at ptr and set it to result
2068             mstore(ptr, 0)               // set pointer memory to 0 so it still is the next free ptr
2069         }
2070 
2071         return result;
2072     }
2073 
2074     /**
2075     * @dev Internal function that sets management
2076     */
2077     function _setPermissionManager(address _newManager, address _app, bytes32 _role) internal {
2078         permissionManager[roleHash(_app, _role)] = _newManager;
2079         emit ChangePermissionManager(_app, _role, _newManager);
2080     }
2081 
2082     function roleHash(address _where, bytes32 _what) internal pure returns (bytes32) {
2083         return keccak256(abi.encodePacked("ROLE", _where, _what));
2084     }
2085 
2086     function permissionHash(address _who, address _where, bytes32 _what) internal pure returns (bytes32) {
2087         return keccak256(abi.encodePacked("PERMISSION", _who, _where, _what));
2088     }
2089 }
2090 
2091 // File: contracts/evmscript/ScriptHelpers.sol
2092 
2093 /*
2094  * SPDX-License-Identitifer:    MIT
2095  */
2096 
2097 pragma solidity ^0.4.24;
2098 
2099 
2100 library ScriptHelpers {
2101     function getSpecId(bytes _script) internal pure returns (uint32) {
2102         return uint32At(_script, 0);
2103     }
2104 
2105     function uint256At(bytes _data, uint256 _location) internal pure returns (uint256 result) {
2106         assembly {
2107             result := mload(add(_data, add(0x20, _location)))
2108         }
2109     }
2110 
2111     function addressAt(bytes _data, uint256 _location) internal pure returns (address result) {
2112         uint256 word = uint256At(_data, _location);
2113 
2114         assembly {
2115             result := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
2116             0x1000000000000000000000000)
2117         }
2118     }
2119 
2120     function uint32At(bytes _data, uint256 _location) internal pure returns (uint32 result) {
2121         uint256 word = uint256At(_data, _location);
2122 
2123         assembly {
2124             result := div(and(word, 0xffffffff00000000000000000000000000000000000000000000000000000000),
2125             0x100000000000000000000000000000000000000000000000000000000)
2126         }
2127     }
2128 
2129     function locationOf(bytes _data, uint256 _location) internal pure returns (uint256 result) {
2130         assembly {
2131             result := add(_data, add(0x20, _location))
2132         }
2133     }
2134 
2135     function toBytes(bytes4 _sig) internal pure returns (bytes) {
2136         bytes memory payload = new bytes(4);
2137         assembly { mstore(add(payload, 0x20), _sig) }
2138         return payload;
2139     }
2140 }
2141 
2142 // File: contracts/evmscript/EVMScriptRegistry.sol
2143 
2144 pragma solidity 0.4.24;
2145 
2146 
2147 
2148 
2149 
2150 
2151 /* solium-disable function-order */
2152 // Allow public initialize() to be first
2153 contract EVMScriptRegistry is IEVMScriptRegistry, EVMScriptRegistryConstants, AragonApp {
2154     using ScriptHelpers for bytes;
2155 
2156     /* Hardcoded constants to save gas
2157     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = keccak256("REGISTRY_ADD_EXECUTOR_ROLE");
2158     bytes32 public constant REGISTRY_MANAGER_ROLE = keccak256("REGISTRY_MANAGER_ROLE");
2159     */
2160     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = 0xc4e90f38eea8c4212a009ca7b8947943ba4d4a58d19b683417f65291d1cd9ed2;
2161     // WARN: Manager can censor all votes and the like happening in an org
2162     bytes32 public constant REGISTRY_MANAGER_ROLE = 0xf7a450ef335e1892cb42c8ca72e7242359d7711924b75db5717410da3f614aa3;
2163 
2164     uint256 internal constant SCRIPT_START_LOCATION = 4;
2165 
2166     string private constant ERROR_INEXISTENT_EXECUTOR = "EVMREG_INEXISTENT_EXECUTOR";
2167     string private constant ERROR_EXECUTOR_ENABLED = "EVMREG_EXECUTOR_ENABLED";
2168     string private constant ERROR_EXECUTOR_DISABLED = "EVMREG_EXECUTOR_DISABLED";
2169     string private constant ERROR_SCRIPT_LENGTH_TOO_SHORT = "EVMREG_SCRIPT_LENGTH_TOO_SHORT";
2170 
2171     struct ExecutorEntry {
2172         IEVMScriptExecutor executor;
2173         bool enabled;
2174     }
2175 
2176     uint256 private executorsNextIndex;
2177     mapping (uint256 => ExecutorEntry) public executors;
2178 
2179     event EnableExecutor(uint256 indexed executorId, address indexed executorAddress);
2180     event DisableExecutor(uint256 indexed executorId, address indexed executorAddress);
2181 
2182     modifier executorExists(uint256 _executorId) {
2183         require(_executorId > 0 && _executorId < executorsNextIndex, ERROR_INEXISTENT_EXECUTOR);
2184         _;
2185     }
2186 
2187     /**
2188     * @notice Initialize the registry
2189     */
2190     function initialize() public onlyInit {
2191         initialized();
2192         // Create empty record to begin executor IDs at 1
2193         executorsNextIndex = 1;
2194     }
2195 
2196     /**
2197     * @notice Add a new script executor with address `_executor` to the registry
2198     * @param _executor Address of the IEVMScriptExecutor that will be added to the registry
2199     * @return id Identifier of the executor in the registry
2200     */
2201     function addScriptExecutor(IEVMScriptExecutor _executor) external auth(REGISTRY_ADD_EXECUTOR_ROLE) returns (uint256 id) {
2202         uint256 executorId = executorsNextIndex++;
2203         executors[executorId] = ExecutorEntry(_executor, true);
2204         emit EnableExecutor(executorId, _executor);
2205         return executorId;
2206     }
2207 
2208     /**
2209     * @notice Disable script executor with ID `_executorId`
2210     * @param _executorId Identifier of the executor in the registry
2211     */
2212     function disableScriptExecutor(uint256 _executorId)
2213         external
2214         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
2215     {
2216         // Note that we don't need to check for an executor's existence in this case, as only
2217         // existing executors can be enabled
2218         ExecutorEntry storage executorEntry = executors[_executorId];
2219         require(executorEntry.enabled, ERROR_EXECUTOR_DISABLED);
2220         executorEntry.enabled = false;
2221         emit DisableExecutor(_executorId, executorEntry.executor);
2222     }
2223 
2224     /**
2225     * @notice Enable script executor with ID `_executorId`
2226     * @param _executorId Identifier of the executor in the registry
2227     */
2228     function enableScriptExecutor(uint256 _executorId)
2229         external
2230         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
2231         executorExists(_executorId)
2232     {
2233         ExecutorEntry storage executorEntry = executors[_executorId];
2234         require(!executorEntry.enabled, ERROR_EXECUTOR_ENABLED);
2235         executorEntry.enabled = true;
2236         emit EnableExecutor(_executorId, executorEntry.executor);
2237     }
2238 
2239     /**
2240     * @dev Get the script executor that can execute a particular script based on its first 4 bytes
2241     * @param _script EVMScript being inspected
2242     */
2243     function getScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
2244         require(_script.length >= SCRIPT_START_LOCATION, ERROR_SCRIPT_LENGTH_TOO_SHORT);
2245         uint256 id = _script.getSpecId();
2246 
2247         // Note that we don't need to check for an executor's existence in this case, as only
2248         // existing executors can be enabled
2249         ExecutorEntry storage entry = executors[id];
2250         return entry.enabled ? entry.executor : IEVMScriptExecutor(0);
2251     }
2252 }
2253 
2254 // File: contracts/evmscript/executors/BaseEVMScriptExecutor.sol
2255 
2256 /*
2257  * SPDX-License-Identitifer:    MIT
2258  */
2259 
2260 pragma solidity ^0.4.24;
2261 
2262 
2263 
2264 
2265 contract BaseEVMScriptExecutor is IEVMScriptExecutor, Autopetrified {
2266     uint256 internal constant SCRIPT_START_LOCATION = 4;
2267 }
2268 
2269 // File: contracts/evmscript/executors/CallsScript.sol
2270 
2271 pragma solidity 0.4.24;
2272 
2273 // Inspired by https://github.com/reverendus/tx-manager
2274 
2275 
2276 
2277 
2278 contract CallsScript is BaseEVMScriptExecutor {
2279     using ScriptHelpers for bytes;
2280 
2281     /* Hardcoded constants to save gas
2282     bytes32 internal constant EXECUTOR_TYPE = keccak256("CALLS_SCRIPT");
2283     */
2284     bytes32 internal constant EXECUTOR_TYPE = 0x2dc858a00f3e417be1394b87c07158e989ec681ce8cc68a9093680ac1a870302;
2285 
2286     string private constant ERROR_BLACKLISTED_CALL = "EVMCALLS_BLACKLISTED_CALL";
2287     string private constant ERROR_INVALID_LENGTH = "EVMCALLS_INVALID_LENGTH";
2288 
2289     /* This is manually crafted in assembly
2290     string private constant ERROR_CALL_REVERTED = "EVMCALLS_CALL_REVERTED";
2291     */
2292 
2293     event LogScriptCall(address indexed sender, address indexed src, address indexed dst);
2294 
2295     /**
2296     * @notice Executes a number of call scripts
2297     * @param _script [ specId (uint32) ] many calls with this structure ->
2298     *    [ to (address: 20 bytes) ] [ calldataLength (uint32: 4 bytes) ] [ calldata (calldataLength bytes) ]
2299     * @param _blacklist Addresses the script cannot call to, or will revert.
2300     * @return Always returns empty byte array
2301     */
2302     function execScript(bytes _script, bytes, address[] _blacklist) external isInitialized returns (bytes) {
2303         uint256 location = SCRIPT_START_LOCATION; // first 32 bits are spec id
2304         while (location < _script.length) {
2305             // Check there's at least address + calldataLength available
2306             require(_script.length - location >= 0x18, ERROR_INVALID_LENGTH);
2307 
2308             address contractAddress = _script.addressAt(location);
2309             // Check address being called is not blacklist
2310             for (uint256 i = 0; i < _blacklist.length; i++) {
2311                 require(contractAddress != _blacklist[i], ERROR_BLACKLISTED_CALL);
2312             }
2313 
2314             // logged before execution to ensure event ordering in receipt
2315             // if failed entire execution is reverted regardless
2316             emit LogScriptCall(msg.sender, address(this), contractAddress);
2317 
2318             uint256 calldataLength = uint256(_script.uint32At(location + 0x14));
2319             uint256 startOffset = location + 0x14 + 0x04;
2320             uint256 calldataStart = _script.locationOf(startOffset);
2321 
2322             // compute end of script / next location
2323             location = startOffset + calldataLength;
2324             require(location <= _script.length, ERROR_INVALID_LENGTH);
2325 
2326             bool success;
2327             assembly {
2328                 success := call(
2329                     sub(gas, 5000),       // forward gas left - 5000
2330                     contractAddress,      // address
2331                     0,                    // no value
2332                     calldataStart,        // calldata start
2333                     calldataLength,       // calldata length
2334                     0,                    // don't write output
2335                     0                     // don't write output
2336                 )
2337 
2338                 switch success
2339                 case 0 {
2340                     let ptr := mload(0x40)
2341 
2342                     switch returndatasize
2343                     case 0 {
2344                         // No error data was returned, revert with "EVMCALLS_CALL_REVERTED"
2345                         // See remix: doing a `revert("EVMCALLS_CALL_REVERTED")` always results in
2346                         // this memory layout
2347                         mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000)         // error identifier
2348                         mstore(add(ptr, 0x04), 0x0000000000000000000000000000000000000000000000000000000000000020) // starting offset
2349                         mstore(add(ptr, 0x24), 0x0000000000000000000000000000000000000000000000000000000000000016) // reason length
2350                         mstore(add(ptr, 0x44), 0x45564d43414c4c535f43414c4c5f524556455254454400000000000000000000) // reason
2351 
2352                         revert(ptr, 100) // 100 = 4 + 3 * 32 (error identifier + 3 words for the ABI encoded error)
2353                     }
2354                     default {
2355                         // Forward the full error data
2356                         returndatacopy(ptr, 0, returndatasize)
2357                         revert(ptr, returndatasize)
2358                     }
2359                 }
2360                 default { }
2361             }
2362         }
2363         // No need to allocate empty bytes for the return as this can only be called via an delegatecall
2364         // (due to the isInitialized modifier)
2365     }
2366 
2367     function executorType() external pure returns (bytes32) {
2368         return EXECUTOR_TYPE;
2369     }
2370 }
2371 
2372 // File: contracts/factory/EVMScriptRegistryFactory.sol
2373 
2374 pragma solidity 0.4.24;
2375 
2376 
2377 
2378 
2379 
2380 
2381 
2382 contract EVMScriptRegistryFactory is EVMScriptRegistryConstants {
2383     EVMScriptRegistry public baseReg;
2384     IEVMScriptExecutor public baseCallScript;
2385 
2386     /**
2387     * @notice Create a new EVMScriptRegistryFactory.
2388     */
2389     constructor() public {
2390         baseReg = new EVMScriptRegistry();
2391         baseCallScript = IEVMScriptExecutor(new CallsScript());
2392     }
2393 
2394     /**
2395     * @notice Install a new pinned instance of EVMScriptRegistry on `_dao`.
2396     * @param _dao Kernel
2397     * @return Installed EVMScriptRegistry
2398     */
2399     function newEVMScriptRegistry(Kernel _dao) public returns (EVMScriptRegistry reg) {
2400         bytes memory initPayload = abi.encodeWithSelector(reg.initialize.selector);
2401         reg = EVMScriptRegistry(_dao.newPinnedAppInstance(EVMSCRIPT_REGISTRY_APP_ID, baseReg, initPayload, true));
2402 
2403         ACL acl = ACL(_dao.acl());
2404 
2405         acl.createPermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE(), this);
2406 
2407         reg.addScriptExecutor(baseCallScript);     // spec 1 = CallsScript
2408 
2409         // Clean up the permissions
2410         acl.revokePermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
2411         acl.removePermissionManager(reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
2412 
2413         return reg;
2414     }
2415 }
2416 
2417 // File: contracts/factory/DAOFactory.sol
2418 
2419 pragma solidity 0.4.24;
2420 
2421 
2422 
2423 
2424 
2425 
2426 
2427 
2428 contract DAOFactory {
2429     IKernel public baseKernel;
2430     IACL public baseACL;
2431     EVMScriptRegistryFactory public regFactory;
2432 
2433     event DeployDAO(address dao);
2434     event DeployEVMScriptRegistry(address reg);
2435 
2436     /**
2437     * @notice Create a new DAOFactory, creating DAOs with Kernels proxied to `_baseKernel`, ACLs proxied to `_baseACL`, and new EVMScriptRegistries created from `_regFactory`.
2438     * @param _baseKernel Base Kernel
2439     * @param _baseACL Base ACL
2440     * @param _regFactory EVMScriptRegistry factory
2441     */
2442     constructor(IKernel _baseKernel, IACL _baseACL, EVMScriptRegistryFactory _regFactory) public {
2443         // No need to init as it cannot be killed by devops199
2444         if (address(_regFactory) != address(0)) {
2445             regFactory = _regFactory;
2446         }
2447 
2448         baseKernel = _baseKernel;
2449         baseACL = _baseACL;
2450     }
2451 
2452     /**
2453     * @notice Create a new DAO with `_root` set as the initial admin
2454     * @param _root Address that will be granted control to setup DAO permissions
2455     * @return Newly created DAO
2456     */
2457     function newDAO(address _root) public returns (Kernel) {
2458         Kernel dao = Kernel(new KernelProxy(baseKernel));
2459 
2460         if (address(regFactory) == address(0)) {
2461             dao.initialize(baseACL, _root);
2462         } else {
2463             dao.initialize(baseACL, this);
2464 
2465             ACL acl = ACL(dao.acl());
2466             bytes32 permRole = acl.CREATE_PERMISSIONS_ROLE();
2467             bytes32 appManagerRole = dao.APP_MANAGER_ROLE();
2468 
2469             acl.grantPermission(regFactory, acl, permRole);
2470 
2471             acl.createPermission(regFactory, dao, appManagerRole, this);
2472 
2473             EVMScriptRegistry reg = regFactory.newEVMScriptRegistry(dao);
2474             emit DeployEVMScriptRegistry(address(reg));
2475 
2476             // Clean up permissions
2477             // First, completely reset the APP_MANAGER_ROLE
2478             acl.revokePermission(regFactory, dao, appManagerRole);
2479             acl.removePermissionManager(dao, appManagerRole);
2480 
2481             // Then, make root the only holder and manager of CREATE_PERMISSIONS_ROLE
2482             acl.revokePermission(regFactory, acl, permRole);
2483             acl.revokePermission(this, acl, permRole);
2484             acl.grantPermission(_root, acl, permRole);
2485             acl.setPermissionManager(_root, acl, permRole);
2486         }
2487 
2488         emit DeployDAO(address(dao));
2489 
2490         return dao;
2491     }
2492 }