1 // File: @aragon/os/contracts/acl/IACL.sol
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
18 // File: @aragon/os/contracts/common/IVaultRecoverable.sol
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
36 // File: @aragon/os/contracts/kernel/IKernel.sol
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
61 // File: @aragon/os/contracts/kernel/KernelConstants.sol
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
93 // File: @aragon/os/contracts/kernel/KernelStorage.sol
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
104 // File: @aragon/os/contracts/acl/ACLSyntaxSugar.sol
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
211 // File: @aragon/os/contracts/common/ConversionHelpers.sol
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
244 // File: @aragon/os/contracts/common/IsContract.sol
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
272 // File: @aragon/os/contracts/common/Uint256Helpers.sol
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
288 // File: @aragon/os/contracts/common/TimeHelpers.sol
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
338 // File: @aragon/os/contracts/common/UnstructuredStorage.sol
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
381 // File: @aragon/os/contracts/common/Initializable.sol
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
442 // File: @aragon/os/contracts/common/Petrifiable.sol
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
469 // File: @aragon/os/contracts/lib/token/ERC20.sol
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
509 // File: @aragon/os/contracts/common/EtherTokenConstant.sol
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
524 // File: @aragon/os/contracts/common/SafeERC20.sol
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
682 // File: @aragon/os/contracts/common/VaultRecoverable.sol
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
739 // File: @aragon/os/contracts/apps/AppStorage.sol
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
777 // File: @aragon/os/contracts/lib/misc/ERCProxy.sol
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
794 // File: @aragon/os/contracts/common/DelegateProxy.sol
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
827 // File: @aragon/os/contracts/common/DepositableStorage.sol
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
848 // File: @aragon/os/contracts/common/DepositableDelegateProxy.sol
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
871 // File: @aragon/os/contracts/apps/AppProxyBase.sol
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
911 // File: @aragon/os/contracts/apps/AppProxyUpgradeable.sol
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
946 // File: @aragon/os/contracts/apps/AppProxyPinned.sol
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
997 // File: @aragon/os/contracts/factory/AppProxyFactory.sol
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
1053 // File: @aragon/os/contracts/kernel/Kernel.sol
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
1293 // File: @aragon/os/contracts/kernel/KernelProxy.sol
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
1335 // File: @aragon/os/contracts/common/Autopetrified.sol
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
1353 // File: @aragon/os/contracts/common/ReentrancyGuard.sol
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
1388 // File: @aragon/os/contracts/evmscript/IEVMScriptExecutor.sol
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
1402 // File: @aragon/os/contracts/evmscript/IEVMScriptRegistry.sol
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
1429 // File: @aragon/os/contracts/evmscript/EVMScriptRunner.sol
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
1539 // File: @aragon/os/contracts/apps/AragonApp.sol
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
1609 // File: @aragon/os/contracts/acl/IACLOracle.sol
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
1622 // File: @aragon/os/contracts/acl/ACL.sol
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
2091 // File: @aragon/os/contracts/evmscript/ScriptHelpers.sol
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
2142 // File: @aragon/os/contracts/evmscript/EVMScriptRegistry.sol
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
2254 // File: @aragon/os/contracts/evmscript/executors/BaseEVMScriptExecutor.sol
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
2269 // File: @aragon/os/contracts/evmscript/executors/CallsScript.sol
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
2372 // File: @aragon/os/contracts/factory/EVMScriptRegistryFactory.sol
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
2417 // File: @aragon/os/contracts/factory/DAOFactory.sol
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
2493 
2494 // File: @aragon/apps-shared-minime/contracts/ITokenController.sol
2495 
2496 pragma solidity ^0.4.24;
2497 
2498 /// @dev The token controller contract must implement these functions
2499 
2500 
2501 interface ITokenController {
2502     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
2503     /// @param _owner The address that sent the ether to create tokens
2504     /// @return True if the ether is accepted, false if it throws
2505     function proxyPayment(address _owner) external payable returns(bool);
2506 
2507     /// @notice Notifies the controller about a token transfer allowing the
2508     ///  controller to react if desired
2509     /// @param _from The origin of the transfer
2510     /// @param _to The destination of the transfer
2511     /// @param _amount The amount of the transfer
2512     /// @return False if the controller does not authorize the transfer
2513     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
2514 
2515     /// @notice Notifies the controller about an approval allowing the
2516     ///  controller to react if desired
2517     /// @param _owner The address that calls `approve()`
2518     /// @param _spender The spender in the `approve()` call
2519     /// @param _amount The amount in the `approve()` call
2520     /// @return False if the controller does not authorize the approval
2521     function onApprove(address _owner, address _spender, uint _amount) external returns(bool);
2522 }
2523 
2524 // File: @aragon/apps-shared-minime/contracts/MiniMeToken.sol
2525 
2526 pragma solidity ^0.4.24;
2527 
2528 /*
2529     Copyright 2016, Jordi Baylina
2530     This program is free software: you can redistribute it and/or modify
2531     it under the terms of the GNU General Public License as published by
2532     the Free Software Foundation, either version 3 of the License, or
2533     (at your option) any later version.
2534     This program is distributed in the hope that it will be useful,
2535     but WITHOUT ANY WARRANTY; without even the implied warranty of
2536     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2537     GNU General Public License for more details.
2538     You should have received a copy of the GNU General Public License
2539     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2540  */
2541 
2542 /// @title MiniMeToken Contract
2543 /// @author Jordi Baylina
2544 /// @dev This token contract's goal is to make it easy for anyone to clone this
2545 ///  token using the token distribution at a given block, this will allow DAO's
2546 ///  and DApps to upgrade their features in a decentralized manner without
2547 ///  affecting the original token
2548 /// @dev It is ERC20 compliant, but still needs to under go further testing.
2549 
2550 
2551 contract Controlled {
2552     /// @notice The address of the controller is the only address that can call
2553     ///  a function with this modifier
2554     modifier onlyController {
2555         require(msg.sender == controller);
2556         _;
2557     }
2558 
2559     address public controller;
2560 
2561     function Controlled()  public { controller = msg.sender;}
2562 
2563     /// @notice Changes the controller of the contract
2564     /// @param _newController The new controller of the contract
2565     function changeController(address _newController) onlyController  public {
2566         controller = _newController;
2567     }
2568 }
2569 
2570 contract ApproveAndCallFallBack {
2571     function receiveApproval(
2572         address from,
2573         uint256 _amount,
2574         address _token,
2575         bytes _data
2576     ) public;
2577 }
2578 
2579 /// @dev The actual token contract, the default controller is the msg.sender
2580 ///  that deploys the contract, so usually this token will be deployed by a
2581 ///  token controller contract, which Giveth will call a "Campaign"
2582 contract MiniMeToken is Controlled {
2583 
2584     string public name;                //The Token's name: e.g. DigixDAO Tokens
2585     uint8 public decimals;             //Number of decimals of the smallest unit
2586     string public symbol;              //An identifier: e.g. REP
2587     string public version = "MMT_0.1"; //An arbitrary versioning scheme
2588 
2589 
2590     /// @dev `Checkpoint` is the structure that attaches a block number to a
2591     ///  given value, the block number attached is the one that last changed the
2592     ///  value
2593     struct Checkpoint {
2594 
2595         // `fromBlock` is the block number that the value was generated from
2596         uint128 fromBlock;
2597 
2598         // `value` is the amount of tokens at a specific block number
2599         uint128 value;
2600     }
2601 
2602     // `parentToken` is the Token address that was cloned to produce this token;
2603     //  it will be 0x0 for a token that was not cloned
2604     MiniMeToken public parentToken;
2605 
2606     // `parentSnapShotBlock` is the block number from the Parent Token that was
2607     //  used to determine the initial distribution of the Clone Token
2608     uint public parentSnapShotBlock;
2609 
2610     // `creationBlock` is the block number that the Clone Token was created
2611     uint public creationBlock;
2612 
2613     // `balances` is the map that tracks the balance of each address, in this
2614     //  contract when the balance changes the block number that the change
2615     //  occurred is also included in the map
2616     mapping (address => Checkpoint[]) balances;
2617 
2618     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
2619     mapping (address => mapping (address => uint256)) allowed;
2620 
2621     // Tracks the history of the `totalSupply` of the token
2622     Checkpoint[] totalSupplyHistory;
2623 
2624     // Flag that determines if the token is transferable or not.
2625     bool public transfersEnabled;
2626 
2627     // The factory used to create new clone tokens
2628     MiniMeTokenFactory public tokenFactory;
2629 
2630 ////////////////
2631 // Constructor
2632 ////////////////
2633 
2634     /// @notice Constructor to create a MiniMeToken
2635     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
2636     ///  will create the Clone token contracts, the token factory needs to be
2637     ///  deployed first
2638     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
2639     ///  new token
2640     /// @param _parentSnapShotBlock Block of the parent token that will
2641     ///  determine the initial distribution of the clone token, set to 0 if it
2642     ///  is a new token
2643     /// @param _tokenName Name of the new token
2644     /// @param _decimalUnits Number of decimals of the new token
2645     /// @param _tokenSymbol Token Symbol for the new token
2646     /// @param _transfersEnabled If true, tokens will be able to be transferred
2647     function MiniMeToken(
2648         MiniMeTokenFactory _tokenFactory,
2649         MiniMeToken _parentToken,
2650         uint _parentSnapShotBlock,
2651         string _tokenName,
2652         uint8 _decimalUnits,
2653         string _tokenSymbol,
2654         bool _transfersEnabled
2655     )  public
2656     {
2657         tokenFactory = _tokenFactory;
2658         name = _tokenName;                                 // Set the name
2659         decimals = _decimalUnits;                          // Set the decimals
2660         symbol = _tokenSymbol;                             // Set the symbol
2661         parentToken = _parentToken;
2662         parentSnapShotBlock = _parentSnapShotBlock;
2663         transfersEnabled = _transfersEnabled;
2664         creationBlock = block.number;
2665     }
2666 
2667 
2668 ///////////////////
2669 // ERC20 Methods
2670 ///////////////////
2671 
2672     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
2673     /// @param _to The address of the recipient
2674     /// @param _amount The amount of tokens to be transferred
2675     /// @return Whether the transfer was successful or not
2676     function transfer(address _to, uint256 _amount) public returns (bool success) {
2677         require(transfersEnabled);
2678         return doTransfer(msg.sender, _to, _amount);
2679     }
2680 
2681     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
2682     ///  is approved by `_from`
2683     /// @param _from The address holding the tokens being transferred
2684     /// @param _to The address of the recipient
2685     /// @param _amount The amount of tokens to be transferred
2686     /// @return True if the transfer was successful
2687     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
2688 
2689         // The controller of this contract can move tokens around at will,
2690         //  this is important to recognize! Confirm that you trust the
2691         //  controller of this contract, which in most situations should be
2692         //  another open source smart contract or 0x0
2693         if (msg.sender != controller) {
2694             require(transfersEnabled);
2695 
2696             // The standard ERC 20 transferFrom functionality
2697             if (allowed[_from][msg.sender] < _amount)
2698                 return false;
2699             allowed[_from][msg.sender] -= _amount;
2700         }
2701         return doTransfer(_from, _to, _amount);
2702     }
2703 
2704     /// @dev This is the actual transfer function in the token contract, it can
2705     ///  only be called by other functions in this contract.
2706     /// @param _from The address holding the tokens being transferred
2707     /// @param _to The address of the recipient
2708     /// @param _amount The amount of tokens to be transferred
2709     /// @return True if the transfer was successful
2710     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
2711         if (_amount == 0) {
2712             return true;
2713         }
2714         require(parentSnapShotBlock < block.number);
2715         // Do not allow transfer to 0x0 or the token contract itself
2716         require((_to != 0) && (_to != address(this)));
2717         // If the amount being transfered is more than the balance of the
2718         //  account the transfer returns false
2719         var previousBalanceFrom = balanceOfAt(_from, block.number);
2720         if (previousBalanceFrom < _amount) {
2721             return false;
2722         }
2723         // Alerts the token controller of the transfer
2724         if (isContract(controller)) {
2725             // Adding the ` == true` makes the linter shut up so...
2726             require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
2727         }
2728         // First update the balance array with the new value for the address
2729         //  sending the tokens
2730         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
2731         // Then update the balance array with the new value for the address
2732         //  receiving the tokens
2733         var previousBalanceTo = balanceOfAt(_to, block.number);
2734         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
2735         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
2736         // An event to make the transfer easy to find on the blockchain
2737         Transfer(_from, _to, _amount);
2738         return true;
2739     }
2740 
2741     /// @param _owner The address that's balance is being requested
2742     /// @return The balance of `_owner` at the current block
2743     function balanceOf(address _owner) public constant returns (uint256 balance) {
2744         return balanceOfAt(_owner, block.number);
2745     }
2746 
2747     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
2748     ///  its behalf. This is a modified version of the ERC20 approve function
2749     ///  to be a little bit safer
2750     /// @param _spender The address of the account able to transfer the tokens
2751     /// @param _amount The amount of tokens to be approved for transfer
2752     /// @return True if the approval was successful
2753     function approve(address _spender, uint256 _amount) public returns (bool success) {
2754         require(transfersEnabled);
2755 
2756         // To change the approve amount you first have to reduce the addresses`
2757         //  allowance to zero by calling `approve(_spender,0)` if it is not
2758         //  already 0 to mitigate the race condition described here:
2759         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2760         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
2761 
2762         // Alerts the token controller of the approve function call
2763         if (isContract(controller)) {
2764             // Adding the ` == true` makes the linter shut up so...
2765             require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
2766         }
2767 
2768         allowed[msg.sender][_spender] = _amount;
2769         Approval(msg.sender, _spender, _amount);
2770         return true;
2771     }
2772 
2773     /// @dev This function makes it easy to read the `allowed[]` map
2774     /// @param _owner The address of the account that owns the token
2775     /// @param _spender The address of the account able to transfer the tokens
2776     /// @return Amount of remaining tokens of _owner that _spender is allowed
2777     ///  to spend
2778     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
2779         return allowed[_owner][_spender];
2780     }
2781 
2782     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
2783     ///  its behalf, and then a function is triggered in the contract that is
2784     ///  being approved, `_spender`. This allows users to use their tokens to
2785     ///  interact with contracts in one function call instead of two
2786     /// @param _spender The address of the contract able to transfer the tokens
2787     /// @param _amount The amount of tokens to be approved for transfer
2788     /// @return True if the function call was successful
2789     function approveAndCall(ApproveAndCallFallBack _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
2790         require(approve(_spender, _amount));
2791 
2792         _spender.receiveApproval(
2793             msg.sender,
2794             _amount,
2795             this,
2796             _extraData
2797         );
2798 
2799         return true;
2800     }
2801 
2802     /// @dev This function makes it easy to get the total number of tokens
2803     /// @return The total number of tokens
2804     function totalSupply() public constant returns (uint) {
2805         return totalSupplyAt(block.number);
2806     }
2807 
2808 
2809 ////////////////
2810 // Query balance and totalSupply in History
2811 ////////////////
2812 
2813     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
2814     /// @param _owner The address from which the balance will be retrieved
2815     /// @param _blockNumber The block number when the balance is queried
2816     /// @return The balance at `_blockNumber`
2817     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
2818 
2819         // These next few lines are used when the balance of the token is
2820         //  requested before a check point was ever created for this token, it
2821         //  requires that the `parentToken.balanceOfAt` be queried at the
2822         //  genesis block for that token as this contains initial balance of
2823         //  this token
2824         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
2825             if (address(parentToken) != 0) {
2826                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
2827             } else {
2828                 // Has no parent
2829                 return 0;
2830             }
2831 
2832         // This will return the expected balance during normal situations
2833         } else {
2834             return getValueAt(balances[_owner], _blockNumber);
2835         }
2836     }
2837 
2838     /// @notice Total amount of tokens at a specific `_blockNumber`.
2839     /// @param _blockNumber The block number when the totalSupply is queried
2840     /// @return The total amount of tokens at `_blockNumber`
2841     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
2842 
2843         // These next few lines are used when the totalSupply of the token is
2844         //  requested before a check point was ever created for this token, it
2845         //  requires that the `parentToken.totalSupplyAt` be queried at the
2846         //  genesis block for this token as that contains totalSupply of this
2847         //  token at this block number.
2848         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
2849             if (address(parentToken) != 0) {
2850                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
2851             } else {
2852                 return 0;
2853             }
2854 
2855         // This will return the expected totalSupply during normal situations
2856         } else {
2857             return getValueAt(totalSupplyHistory, _blockNumber);
2858         }
2859     }
2860 
2861 ////////////////
2862 // Clone Token Method
2863 ////////////////
2864 
2865     /// @notice Creates a new clone token with the initial distribution being
2866     ///  this token at `_snapshotBlock`
2867     /// @param _cloneTokenName Name of the clone token
2868     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
2869     /// @param _cloneTokenSymbol Symbol of the clone token
2870     /// @param _snapshotBlock Block when the distribution of the parent token is
2871     ///  copied to set the initial distribution of the new clone token;
2872     ///  if the block is zero than the actual block, the current block is used
2873     /// @param _transfersEnabled True if transfers are allowed in the clone
2874     /// @return The address of the new MiniMeToken Contract
2875     function createCloneToken(
2876         string _cloneTokenName,
2877         uint8 _cloneDecimalUnits,
2878         string _cloneTokenSymbol,
2879         uint _snapshotBlock,
2880         bool _transfersEnabled
2881     ) public returns(MiniMeToken)
2882     {
2883         uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
2884 
2885         MiniMeToken cloneToken = tokenFactory.createCloneToken(
2886             this,
2887             snapshot,
2888             _cloneTokenName,
2889             _cloneDecimalUnits,
2890             _cloneTokenSymbol,
2891             _transfersEnabled
2892         );
2893 
2894         cloneToken.changeController(msg.sender);
2895 
2896         // An event to make the token easy to find on the blockchain
2897         NewCloneToken(address(cloneToken), snapshot);
2898         return cloneToken;
2899     }
2900 
2901 ////////////////
2902 // Generate and destroy tokens
2903 ////////////////
2904 
2905     /// @notice Generates `_amount` tokens that are assigned to `_owner`
2906     /// @param _owner The address that will be assigned the new tokens
2907     /// @param _amount The quantity of tokens generated
2908     /// @return True if the tokens are generated correctly
2909     function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
2910         uint curTotalSupply = totalSupply();
2911         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
2912         uint previousBalanceTo = balanceOf(_owner);
2913         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
2914         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
2915         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
2916         Transfer(0, _owner, _amount);
2917         return true;
2918     }
2919 
2920 
2921     /// @notice Burns `_amount` tokens from `_owner`
2922     /// @param _owner The address that will lose the tokens
2923     /// @param _amount The quantity of tokens to burn
2924     /// @return True if the tokens are burned correctly
2925     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
2926         uint curTotalSupply = totalSupply();
2927         require(curTotalSupply >= _amount);
2928         uint previousBalanceFrom = balanceOf(_owner);
2929         require(previousBalanceFrom >= _amount);
2930         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
2931         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
2932         Transfer(_owner, 0, _amount);
2933         return true;
2934     }
2935 
2936 ////////////////
2937 // Enable tokens transfers
2938 ////////////////
2939 
2940 
2941     /// @notice Enables token holders to transfer their tokens freely if true
2942     /// @param _transfersEnabled True if transfers are allowed in the clone
2943     function enableTransfers(bool _transfersEnabled) onlyController public {
2944         transfersEnabled = _transfersEnabled;
2945     }
2946 
2947 ////////////////
2948 // Internal helper functions to query and set a value in a snapshot array
2949 ////////////////
2950 
2951     /// @dev `getValueAt` retrieves the number of tokens at a given block number
2952     /// @param checkpoints The history of values being queried
2953     /// @param _block The block number to retrieve the value at
2954     /// @return The number of tokens being queried
2955     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
2956         if (checkpoints.length == 0)
2957             return 0;
2958 
2959         // Shortcut for the actual value
2960         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
2961             return checkpoints[checkpoints.length-1].value;
2962         if (_block < checkpoints[0].fromBlock)
2963             return 0;
2964 
2965         // Binary search of the value in the array
2966         uint min = 0;
2967         uint max = checkpoints.length-1;
2968         while (max > min) {
2969             uint mid = (max + min + 1) / 2;
2970             if (checkpoints[mid].fromBlock<=_block) {
2971                 min = mid;
2972             } else {
2973                 max = mid-1;
2974             }
2975         }
2976         return checkpoints[min].value;
2977     }
2978 
2979     /// @dev `updateValueAtNow` used to update the `balances` map and the
2980     ///  `totalSupplyHistory`
2981     /// @param checkpoints The history of data being updated
2982     /// @param _value The new number of tokens
2983     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
2984         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
2985             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
2986             newCheckPoint.fromBlock = uint128(block.number);
2987             newCheckPoint.value = uint128(_value);
2988         } else {
2989             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
2990             oldCheckPoint.value = uint128(_value);
2991         }
2992     }
2993 
2994     /// @dev Internal function to determine if an address is a contract
2995     /// @param _addr The address being queried
2996     /// @return True if `_addr` is a contract
2997     function isContract(address _addr) constant internal returns(bool) {
2998         uint size;
2999         if (_addr == 0)
3000             return false;
3001 
3002         assembly {
3003             size := extcodesize(_addr)
3004         }
3005 
3006         return size>0;
3007     }
3008 
3009     /// @dev Helper function to return a min betwen the two uints
3010     function min(uint a, uint b) pure internal returns (uint) {
3011         return a < b ? a : b;
3012     }
3013 
3014     /// @notice The fallback function: If the contract's controller has not been
3015     ///  set to 0, then the `proxyPayment` method is called which relays the
3016     ///  ether and creates tokens as described in the token controller contract
3017     function () external payable {
3018         require(isContract(controller));
3019         // Adding the ` == true` makes the linter shut up so...
3020         require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
3021     }
3022 
3023 //////////
3024 // Safety Methods
3025 //////////
3026 
3027     /// @notice This method can be used by the controller to extract mistakenly
3028     ///  sent tokens to this contract.
3029     /// @param _token The address of the token contract that you want to recover
3030     ///  set to 0 in case you want to extract ether.
3031     function claimTokens(address _token) onlyController public {
3032         if (_token == 0x0) {
3033             controller.transfer(this.balance);
3034             return;
3035         }
3036 
3037         MiniMeToken token = MiniMeToken(_token);
3038         uint balance = token.balanceOf(this);
3039         token.transfer(controller, balance);
3040         ClaimedTokens(_token, controller, balance);
3041     }
3042 
3043 ////////////////
3044 // Events
3045 ////////////////
3046     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
3047     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
3048     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
3049     event Approval(
3050         address indexed _owner,
3051         address indexed _spender,
3052         uint256 _amount
3053         );
3054 
3055 }
3056 
3057 
3058 ////////////////
3059 // MiniMeTokenFactory
3060 ////////////////
3061 
3062 /// @dev This contract is used to generate clone contracts from a contract.
3063 ///  In solidity this is the way to create a contract from a contract of the
3064 ///  same class
3065 contract MiniMeTokenFactory {
3066 
3067     /// @notice Update the DApp by creating a new token with new functionalities
3068     ///  the msg.sender becomes the controller of this clone token
3069     /// @param _parentToken Address of the token being cloned
3070     /// @param _snapshotBlock Block of the parent token that will
3071     ///  determine the initial distribution of the clone token
3072     /// @param _tokenName Name of the new token
3073     /// @param _decimalUnits Number of decimals of the new token
3074     /// @param _tokenSymbol Token Symbol for the new token
3075     /// @param _transfersEnabled If true, tokens will be able to be transferred
3076     /// @return The address of the new token contract
3077     function createCloneToken(
3078         MiniMeToken _parentToken,
3079         uint _snapshotBlock,
3080         string _tokenName,
3081         uint8 _decimalUnits,
3082         string _tokenSymbol,
3083         bool _transfersEnabled
3084     ) public returns (MiniMeToken)
3085     {
3086         MiniMeToken newToken = new MiniMeToken(
3087             this,
3088             _parentToken,
3089             _snapshotBlock,
3090             _tokenName,
3091             _decimalUnits,
3092             _tokenSymbol,
3093             _transfersEnabled
3094         );
3095 
3096         newToken.changeController(msg.sender);
3097         return newToken;
3098     }
3099 }
3100 
3101 // File: @aragon/id/contracts/ens/IPublicResolver.sol
3102 
3103 pragma solidity ^0.4.0;
3104 
3105 
3106 interface IPublicResolver {
3107     function supportsInterface(bytes4 interfaceID) constant returns (bool);
3108     function addr(bytes32 node) constant returns (address ret);
3109     function setAddr(bytes32 node, address addr);
3110     function hash(bytes32 node) constant returns (bytes32 ret);
3111     function setHash(bytes32 node, bytes32 hash);
3112 }
3113 
3114 // File: @aragon/id/contracts/IFIFSResolvingRegistrar.sol
3115 
3116 pragma solidity 0.4.24;
3117 
3118 
3119 
3120 interface IFIFSResolvingRegistrar {
3121     function register(bytes32 _subnode, address _owner) external;
3122     function registerWithResolver(bytes32 _subnode, address _owner, IPublicResolver _resolver) public;
3123 }
3124 
3125 // File: @aragon/os/contracts/common/IForwarder.sol
3126 
3127 /*
3128  * SPDX-License-Identitifer:    MIT
3129  */
3130 
3131 pragma solidity ^0.4.24;
3132 
3133 
3134 interface IForwarder {
3135     function isForwarder() external pure returns (bool);
3136 
3137     // TODO: this should be external
3138     // See https://github.com/ethereum/solidity/issues/4832
3139     function canForward(address sender, bytes evmCallScript) public view returns (bool);
3140 
3141     // TODO: this should be external
3142     // See https://github.com/ethereum/solidity/issues/4832
3143     function forward(bytes evmCallScript) public;
3144 }
3145 
3146 // File: @aragon/os/contracts/lib/math/SafeMath.sol
3147 
3148 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d51e38758e1d985661534534d5c61e27bece5042/contracts/math/SafeMath.sol
3149 // Adapted to use pragma ^0.4.24 and satisfy our linter rules
3150 
3151 pragma solidity ^0.4.24;
3152 
3153 
3154 /**
3155  * @title SafeMath
3156  * @dev Math operations with safety checks that revert on error
3157  */
3158 library SafeMath {
3159     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
3160     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
3161     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
3162     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
3163 
3164     /**
3165     * @dev Multiplies two numbers, reverts on overflow.
3166     */
3167     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
3168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
3169         // benefit is lost if 'b' is also tested.
3170         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
3171         if (_a == 0) {
3172             return 0;
3173         }
3174 
3175         uint256 c = _a * _b;
3176         require(c / _a == _b, ERROR_MUL_OVERFLOW);
3177 
3178         return c;
3179     }
3180 
3181     /**
3182     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
3183     */
3184     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
3185         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
3186         uint256 c = _a / _b;
3187         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
3188 
3189         return c;
3190     }
3191 
3192     /**
3193     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
3194     */
3195     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
3196         require(_b <= _a, ERROR_SUB_UNDERFLOW);
3197         uint256 c = _a - _b;
3198 
3199         return c;
3200     }
3201 
3202     /**
3203     * @dev Adds two numbers, reverts on overflow.
3204     */
3205     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
3206         uint256 c = _a + _b;
3207         require(c >= _a, ERROR_ADD_OVERFLOW);
3208 
3209         return c;
3210     }
3211 
3212     /**
3213     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
3214     * reverts when dividing by zero.
3215     */
3216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
3217         require(b != 0, ERROR_DIV_ZERO);
3218         return a % b;
3219     }
3220 }
3221 
3222 // File: @aragon/os/contracts/lib/math/SafeMath64.sol
3223 
3224 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d51e38758e1d985661534534d5c61e27bece5042/contracts/math/SafeMath.sol
3225 // Adapted for uint64, pragma ^0.4.24, and satisfying our linter rules
3226 // Also optimized the mul() implementation, see https://github.com/aragon/aragonOS/pull/417
3227 
3228 pragma solidity ^0.4.24;
3229 
3230 
3231 /**
3232  * @title SafeMath64
3233  * @dev Math operations for uint64 with safety checks that revert on error
3234  */
3235 library SafeMath64 {
3236     string private constant ERROR_ADD_OVERFLOW = "MATH64_ADD_OVERFLOW";
3237     string private constant ERROR_SUB_UNDERFLOW = "MATH64_SUB_UNDERFLOW";
3238     string private constant ERROR_MUL_OVERFLOW = "MATH64_MUL_OVERFLOW";
3239     string private constant ERROR_DIV_ZERO = "MATH64_DIV_ZERO";
3240 
3241     /**
3242     * @dev Multiplies two numbers, reverts on overflow.
3243     */
3244     function mul(uint64 _a, uint64 _b) internal pure returns (uint64) {
3245         uint256 c = uint256(_a) * uint256(_b);
3246         require(c < 0x010000000000000000, ERROR_MUL_OVERFLOW); // 2**64 (less gas this way)
3247 
3248         return uint64(c);
3249     }
3250 
3251     /**
3252     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
3253     */
3254     function div(uint64 _a, uint64 _b) internal pure returns (uint64) {
3255         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
3256         uint64 c = _a / _b;
3257         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
3258 
3259         return c;
3260     }
3261 
3262     /**
3263     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
3264     */
3265     function sub(uint64 _a, uint64 _b) internal pure returns (uint64) {
3266         require(_b <= _a, ERROR_SUB_UNDERFLOW);
3267         uint64 c = _a - _b;
3268 
3269         return c;
3270     }
3271 
3272     /**
3273     * @dev Adds two numbers, reverts on overflow.
3274     */
3275     function add(uint64 _a, uint64 _b) internal pure returns (uint64) {
3276         uint64 c = _a + _b;
3277         require(c >= _a, ERROR_ADD_OVERFLOW);
3278 
3279         return c;
3280     }
3281 
3282     /**
3283     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
3284     * reverts when dividing by zero.
3285     */
3286     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
3287         require(b != 0, ERROR_DIV_ZERO);
3288         return a % b;
3289     }
3290 }
3291 
3292 // File: @aragon/apps-voting/contracts/Voting.sol
3293 
3294 /*
3295  * SPDX-License-Identitifer:    GPL-3.0-or-later
3296  */
3297 
3298 pragma solidity 0.4.24;
3299 
3300 
3301 
3302 
3303 
3304 
3305 
3306 contract Voting is IForwarder, AragonApp {
3307     using SafeMath for uint256;
3308     using SafeMath64 for uint64;
3309 
3310     bytes32 public constant CREATE_VOTES_ROLE = keccak256("CREATE_VOTES_ROLE");
3311     bytes32 public constant MODIFY_SUPPORT_ROLE = keccak256("MODIFY_SUPPORT_ROLE");
3312     bytes32 public constant MODIFY_QUORUM_ROLE = keccak256("MODIFY_QUORUM_ROLE");
3313 
3314     uint64 public constant PCT_BASE = 10 ** 18; // 0% = 0; 1% = 10^16; 100% = 10^18
3315 
3316     string private constant ERROR_NO_VOTE = "VOTING_NO_VOTE";
3317     string private constant ERROR_INIT_PCTS = "VOTING_INIT_PCTS";
3318     string private constant ERROR_CHANGE_SUPPORT_PCTS = "VOTING_CHANGE_SUPPORT_PCTS";
3319     string private constant ERROR_CHANGE_QUORUM_PCTS = "VOTING_CHANGE_QUORUM_PCTS";
3320     string private constant ERROR_INIT_SUPPORT_TOO_BIG = "VOTING_INIT_SUPPORT_TOO_BIG";
3321     string private constant ERROR_CHANGE_SUPPORT_TOO_BIG = "VOTING_CHANGE_SUPP_TOO_BIG";
3322     string private constant ERROR_CAN_NOT_VOTE = "VOTING_CAN_NOT_VOTE";
3323     string private constant ERROR_CAN_NOT_EXECUTE = "VOTING_CAN_NOT_EXECUTE";
3324     string private constant ERROR_CAN_NOT_FORWARD = "VOTING_CAN_NOT_FORWARD";
3325     string private constant ERROR_NO_VOTING_POWER = "VOTING_NO_VOTING_POWER";
3326 
3327     enum VoterState { Absent, Yea, Nay }
3328 
3329     struct Vote {
3330         bool executed;
3331         uint64 startDate;
3332         uint64 snapshotBlock;
3333         uint64 supportRequiredPct;
3334         uint64 minAcceptQuorumPct;
3335         uint256 yea;
3336         uint256 nay;
3337         uint256 votingPower;
3338         bytes executionScript;
3339         mapping (address => VoterState) voters;
3340     }
3341 
3342     MiniMeToken public token;
3343     uint64 public supportRequiredPct;
3344     uint64 public minAcceptQuorumPct;
3345     uint64 public voteTime;
3346 
3347     // We are mimicing an array, we use a mapping instead to make app upgrade more graceful
3348     mapping (uint256 => Vote) internal votes;
3349     uint256 public votesLength;
3350 
3351     event StartVote(uint256 indexed voteId, address indexed creator, string metadata);
3352     event CastVote(uint256 indexed voteId, address indexed voter, bool supports, uint256 stake);
3353     event ExecuteVote(uint256 indexed voteId);
3354     event ChangeSupportRequired(uint64 supportRequiredPct);
3355     event ChangeMinQuorum(uint64 minAcceptQuorumPct);
3356 
3357     modifier voteExists(uint256 _voteId) {
3358         require(_voteId < votesLength, ERROR_NO_VOTE);
3359         _;
3360     }
3361 
3362     /**
3363     * @notice Initialize Voting app with `_token.symbol(): string` for governance, minimum support of `@formatPct(_supportRequiredPct)`%, minimum acceptance quorum of `@formatPct(_minAcceptQuorumPct)`%, and a voting duration of `@transformTime(_voteTime)`
3364     * @param _token MiniMeToken Address that will be used as governance token
3365     * @param _supportRequiredPct Percentage of yeas in casted votes for a vote to succeed (expressed as a percentage of 10^18; eg. 10^16 = 1%, 10^18 = 100%)
3366     * @param _minAcceptQuorumPct Percentage of yeas in total possible votes for a vote to succeed (expressed as a percentage of 10^18; eg. 10^16 = 1%, 10^18 = 100%)
3367     * @param _voteTime Seconds that a vote will be open for token holders to vote (unless enough yeas or nays have been cast to make an early decision)
3368     */
3369     function initialize(
3370         MiniMeToken _token,
3371         uint64 _supportRequiredPct,
3372         uint64 _minAcceptQuorumPct,
3373         uint64 _voteTime
3374     )
3375         external
3376         onlyInit
3377     {
3378         initialized();
3379 
3380         require(_minAcceptQuorumPct <= _supportRequiredPct, ERROR_INIT_PCTS);
3381         require(_supportRequiredPct < PCT_BASE, ERROR_INIT_SUPPORT_TOO_BIG);
3382 
3383         token = _token;
3384         supportRequiredPct = _supportRequiredPct;
3385         minAcceptQuorumPct = _minAcceptQuorumPct;
3386         voteTime = _voteTime;
3387     }
3388 
3389     /**
3390     * @notice Change required support to `@formatPct(_supportRequiredPct)`%
3391     * @param _supportRequiredPct New required support
3392     */
3393     function changeSupportRequiredPct(uint64 _supportRequiredPct)
3394         external
3395         authP(MODIFY_SUPPORT_ROLE, arr(uint256(_supportRequiredPct), uint256(supportRequiredPct)))
3396     {
3397         require(minAcceptQuorumPct <= _supportRequiredPct, ERROR_CHANGE_SUPPORT_PCTS);
3398         require(_supportRequiredPct < PCT_BASE, ERROR_CHANGE_SUPPORT_TOO_BIG);
3399         supportRequiredPct = _supportRequiredPct;
3400 
3401         emit ChangeSupportRequired(_supportRequiredPct);
3402     }
3403 
3404     /**
3405     * @notice Change minimum acceptance quorum to `@formatPct(_minAcceptQuorumPct)`%
3406     * @param _minAcceptQuorumPct New acceptance quorum
3407     */
3408     function changeMinAcceptQuorumPct(uint64 _minAcceptQuorumPct)
3409         external
3410         authP(MODIFY_QUORUM_ROLE, arr(uint256(_minAcceptQuorumPct), uint256(minAcceptQuorumPct)))
3411     {
3412         require(_minAcceptQuorumPct <= supportRequiredPct, ERROR_CHANGE_QUORUM_PCTS);
3413         minAcceptQuorumPct = _minAcceptQuorumPct;
3414 
3415         emit ChangeMinQuorum(_minAcceptQuorumPct);
3416     }
3417 
3418     /**
3419     * @notice Create a new vote about "`_metadata`"
3420     * @param _executionScript EVM script to be executed on approval
3421     * @param _metadata Vote metadata
3422     * @return voteId Id for newly created vote
3423     */
3424     function newVote(bytes _executionScript, string _metadata) external auth(CREATE_VOTES_ROLE) returns (uint256 voteId) {
3425         return _newVote(_executionScript, _metadata, true, true);
3426     }
3427 
3428     /**
3429     * @notice Create a new vote about "`_metadata`"
3430     * @param _executionScript EVM script to be executed on approval
3431     * @param _metadata Vote metadata
3432     * @param _castVote Whether to also cast newly created vote
3433     * @param _executesIfDecided Whether to also immediately execute newly created vote if decided
3434     * @return voteId id for newly created vote
3435     */
3436     function newVote(bytes _executionScript, string _metadata, bool _castVote, bool _executesIfDecided)
3437         external
3438         auth(CREATE_VOTES_ROLE)
3439         returns (uint256 voteId)
3440     {
3441         return _newVote(_executionScript, _metadata, _castVote, _executesIfDecided);
3442     }
3443 
3444     /**
3445     * @notice Vote `_supports ? 'yes' : 'no'` in vote #`_voteId`
3446     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
3447     *      created via `newVote(),` which requires initialization
3448     * @param _voteId Id for vote
3449     * @param _supports Whether voter supports the vote
3450     * @param _executesIfDecided Whether the vote should execute its action if it becomes decided
3451     */
3452     function vote(uint256 _voteId, bool _supports, bool _executesIfDecided) external voteExists(_voteId) {
3453         require(_canVote(_voteId, msg.sender), ERROR_CAN_NOT_VOTE);
3454         _vote(_voteId, _supports, msg.sender, _executesIfDecided);
3455     }
3456 
3457     /**
3458     * @notice Execute vote #`_voteId`
3459     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
3460     *      created via `newVote(),` which requires initialization
3461     * @param _voteId Id for vote
3462     */
3463     function executeVote(uint256 _voteId) external voteExists(_voteId) {
3464         _executeVote(_voteId);
3465     }
3466 
3467     // Forwarding fns
3468 
3469     function isForwarder() external pure returns (bool) {
3470         return true;
3471     }
3472 
3473     /**
3474     * @notice Creates a vote to execute the desired action, and casts a support vote if possible
3475     * @dev IForwarder interface conformance
3476     * @param _evmScript Start vote with script
3477     */
3478     function forward(bytes _evmScript) public {
3479         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
3480         _newVote(_evmScript, "", true, true);
3481     }
3482 
3483     function canForward(address _sender, bytes) public view returns (bool) {
3484         // Note that `canPerform()` implicitly does an initialization check itself
3485         return canPerform(_sender, CREATE_VOTES_ROLE, arr());
3486     }
3487 
3488     // Getter fns
3489 
3490     /**
3491     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
3492     *      created via `newVote(),` which requires initialization
3493     */
3494     function canExecute(uint256 _voteId) public view voteExists(_voteId) returns (bool) {
3495         return _canExecute(_voteId);
3496     }
3497 
3498     /**
3499     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
3500     *      created via `newVote(),` which requires initialization
3501     */
3502     function canVote(uint256 _voteId, address _voter) public view voteExists(_voteId) returns (bool) {
3503         return _canVote(_voteId, _voter);
3504     }
3505 
3506     function getVote(uint256 _voteId)
3507         public
3508         view
3509         voteExists(_voteId)
3510         returns (
3511             bool open,
3512             bool executed,
3513             uint64 startDate,
3514             uint64 snapshotBlock,
3515             uint64 supportRequired,
3516             uint64 minAcceptQuorum,
3517             uint256 yea,
3518             uint256 nay,
3519             uint256 votingPower,
3520             bytes script
3521         )
3522     {
3523         Vote storage vote_ = votes[_voteId];
3524 
3525         open = _isVoteOpen(vote_);
3526         executed = vote_.executed;
3527         startDate = vote_.startDate;
3528         snapshotBlock = vote_.snapshotBlock;
3529         supportRequired = vote_.supportRequiredPct;
3530         minAcceptQuorum = vote_.minAcceptQuorumPct;
3531         yea = vote_.yea;
3532         nay = vote_.nay;
3533         votingPower = vote_.votingPower;
3534         script = vote_.executionScript;
3535     }
3536 
3537     function getVoterState(uint256 _voteId, address _voter) public view voteExists(_voteId) returns (VoterState) {
3538         return votes[_voteId].voters[_voter];
3539     }
3540 
3541     // Internal fns
3542 
3543     function _newVote(bytes _executionScript, string _metadata, bool _castVote, bool _executesIfDecided)
3544         internal
3545         returns (uint256 voteId)
3546     {
3547         uint64 snapshotBlock = getBlockNumber64() - 1; // avoid double voting in this very block
3548         uint256 votingPower = token.totalSupplyAt(snapshotBlock);
3549         require(votingPower > 0, ERROR_NO_VOTING_POWER);
3550 
3551         voteId = votesLength++;
3552 
3553         Vote storage vote_ = votes[voteId];
3554         vote_.startDate = getTimestamp64();
3555         vote_.snapshotBlock = snapshotBlock;
3556         vote_.supportRequiredPct = supportRequiredPct;
3557         vote_.minAcceptQuorumPct = minAcceptQuorumPct;
3558         vote_.votingPower = votingPower;
3559         vote_.executionScript = _executionScript;
3560 
3561         emit StartVote(voteId, msg.sender, _metadata);
3562 
3563         if (_castVote && _canVote(voteId, msg.sender)) {
3564             _vote(voteId, true, msg.sender, _executesIfDecided);
3565         }
3566     }
3567 
3568     function _vote(
3569         uint256 _voteId,
3570         bool _supports,
3571         address _voter,
3572         bool _executesIfDecided
3573     ) internal
3574     {
3575         Vote storage vote_ = votes[_voteId];
3576 
3577         // This could re-enter, though we can assume the governance token is not malicious
3578         uint256 voterStake = token.balanceOfAt(_voter, vote_.snapshotBlock);
3579         VoterState state = vote_.voters[_voter];
3580 
3581         // If voter had previously voted, decrease count
3582         if (state == VoterState.Yea) {
3583             vote_.yea = vote_.yea.sub(voterStake);
3584         } else if (state == VoterState.Nay) {
3585             vote_.nay = vote_.nay.sub(voterStake);
3586         }
3587 
3588         if (_supports) {
3589             vote_.yea = vote_.yea.add(voterStake);
3590         } else {
3591             vote_.nay = vote_.nay.add(voterStake);
3592         }
3593 
3594         vote_.voters[_voter] = _supports ? VoterState.Yea : VoterState.Nay;
3595 
3596         emit CastVote(_voteId, _voter, _supports, voterStake);
3597 
3598         if (_executesIfDecided && _canExecute(_voteId)) {
3599             // We've already checked if the vote can be executed with `_canExecute()`
3600             _unsafeExecuteVote(_voteId);
3601         }
3602     }
3603 
3604     function _executeVote(uint256 _voteId) internal {
3605         require(_canExecute(_voteId), ERROR_CAN_NOT_EXECUTE);
3606         _unsafeExecuteVote(_voteId);
3607     }
3608 
3609     /**
3610     * @dev Unsafe version of _executeVote that assumes you have already checked if the vote can be executed
3611     */
3612     function _unsafeExecuteVote(uint256 _voteId) internal {
3613         Vote storage vote_ = votes[_voteId];
3614 
3615         vote_.executed = true;
3616 
3617         bytes memory input = new bytes(0); // TODO: Consider input for voting scripts
3618         runScript(vote_.executionScript, input, new address[](0));
3619 
3620         emit ExecuteVote(_voteId);
3621     }
3622 
3623     function _canExecute(uint256 _voteId) internal view returns (bool) {
3624         Vote storage vote_ = votes[_voteId];
3625 
3626         if (vote_.executed) {
3627             return false;
3628         }
3629 
3630         // Voting is already decided
3631         if (_isValuePct(vote_.yea, vote_.votingPower, vote_.supportRequiredPct)) {
3632             return true;
3633         }
3634 
3635         // Vote ended?
3636         if (_isVoteOpen(vote_)) {
3637             return false;
3638         }
3639         // Has enough support?
3640         uint256 totalVotes = vote_.yea.add(vote_.nay);
3641         if (!_isValuePct(vote_.yea, totalVotes, vote_.supportRequiredPct)) {
3642             return false;
3643         }
3644         // Has min quorum?
3645         if (!_isValuePct(vote_.yea, vote_.votingPower, vote_.minAcceptQuorumPct)) {
3646             return false;
3647         }
3648 
3649         return true;
3650     }
3651 
3652     function _canVote(uint256 _voteId, address _voter) internal view returns (bool) {
3653         Vote storage vote_ = votes[_voteId];
3654 
3655         return _isVoteOpen(vote_) && token.balanceOfAt(_voter, vote_.snapshotBlock) > 0;
3656     }
3657 
3658     function _isVoteOpen(Vote storage vote_) internal view returns (bool) {
3659         return getTimestamp64() < vote_.startDate.add(voteTime) && !vote_.executed;
3660     }
3661 
3662     /**
3663     * @dev Calculates whether `_value` is more than a percentage `_pct` of `_total`
3664     */
3665     function _isValuePct(uint256 _value, uint256 _total, uint256 _pct) internal pure returns (bool) {
3666         if (_total == 0) {
3667             return false;
3668         }
3669 
3670         uint256 computedPct = _value.mul(PCT_BASE) / _total;
3671         return computedPct > _pct;
3672     }
3673 }
3674 
3675 // File: @aragon/apps-vault/contracts/Vault.sol
3676 
3677 pragma solidity 0.4.24;
3678 
3679 
3680 
3681 
3682 
3683 
3684 
3685 contract Vault is EtherTokenConstant, AragonApp, DepositableStorage {
3686     using SafeERC20 for ERC20;
3687 
3688     bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
3689 
3690     string private constant ERROR_DATA_NON_ZERO = "VAULT_DATA_NON_ZERO";
3691     string private constant ERROR_NOT_DEPOSITABLE = "VAULT_NOT_DEPOSITABLE";
3692     string private constant ERROR_DEPOSIT_VALUE_ZERO = "VAULT_DEPOSIT_VALUE_ZERO";
3693     string private constant ERROR_TRANSFER_VALUE_ZERO = "VAULT_TRANSFER_VALUE_ZERO";
3694     string private constant ERROR_SEND_REVERTED = "VAULT_SEND_REVERTED";
3695     string private constant ERROR_VALUE_MISMATCH = "VAULT_VALUE_MISMATCH";
3696     string private constant ERROR_TOKEN_TRANSFER_FROM_REVERTED = "VAULT_TOKEN_TRANSFER_FROM_REVERT";
3697     string private constant ERROR_TOKEN_TRANSFER_REVERTED = "VAULT_TOKEN_TRANSFER_REVERTED";
3698 
3699     event VaultTransfer(address indexed token, address indexed to, uint256 amount);
3700     event VaultDeposit(address indexed token, address indexed sender, uint256 amount);
3701 
3702     /**
3703     * @dev On a normal send() or transfer() this fallback is never executed as it will be
3704     *      intercepted by the Proxy (see aragonOS#281)
3705     */
3706     function () external payable isInitialized {
3707         require(msg.data.length == 0, ERROR_DATA_NON_ZERO);
3708         _deposit(ETH, msg.value);
3709     }
3710 
3711     /**
3712     * @notice Initialize Vault app
3713     * @dev As an AragonApp it needs to be initialized in order for roles (`auth` and `authP`) to work
3714     */
3715     function initialize() external onlyInit {
3716         initialized();
3717         setDepositable(true);
3718     }
3719 
3720     /**
3721     * @notice Deposit `_value` `_token` to the vault
3722     * @param _token Address of the token being transferred
3723     * @param _value Amount of tokens being transferred
3724     */
3725     function deposit(address _token, uint256 _value) external payable isInitialized {
3726         _deposit(_token, _value);
3727     }
3728 
3729     /**
3730     * @notice Transfer `_value` `_token` from the Vault to `_to`
3731     * @param _token Address of the token being transferred
3732     * @param _to Address of the recipient of tokens
3733     * @param _value Amount of tokens being transferred
3734     */
3735     /* solium-disable-next-line function-order */
3736     function transfer(address _token, address _to, uint256 _value)
3737         external
3738         authP(TRANSFER_ROLE, arr(_token, _to, _value))
3739     {
3740         require(_value > 0, ERROR_TRANSFER_VALUE_ZERO);
3741 
3742         if (_token == ETH) {
3743             require(_to.send(_value), ERROR_SEND_REVERTED);
3744         } else {
3745             require(ERC20(_token).safeTransfer(_to, _value), ERROR_TOKEN_TRANSFER_REVERTED);
3746         }
3747 
3748         emit VaultTransfer(_token, _to, _value);
3749     }
3750 
3751     function balance(address _token) public view returns (uint256) {
3752         if (_token == ETH) {
3753             return address(this).balance;
3754         } else {
3755             return ERC20(_token).staticBalanceOf(address(this));
3756         }
3757     }
3758 
3759     /**
3760     * @dev Disable recovery escape hatch, as it could be used
3761     *      maliciously to transfer funds away from the vault
3762     */
3763     function allowRecoverability(address) public view returns (bool) {
3764         return false;
3765     }
3766 
3767     function _deposit(address _token, uint256 _value) internal {
3768         require(isDepositable(), ERROR_NOT_DEPOSITABLE);
3769         require(_value > 0, ERROR_DEPOSIT_VALUE_ZERO);
3770 
3771         if (_token == ETH) {
3772             // Deposit is implicit in this case
3773             require(msg.value == _value, ERROR_VALUE_MISMATCH);
3774         } else {
3775             require(
3776                 ERC20(_token).safeTransferFrom(msg.sender, address(this), _value),
3777                 ERROR_TOKEN_TRANSFER_FROM_REVERTED
3778             );
3779         }
3780 
3781         emit VaultDeposit(_token, msg.sender, _value);
3782     }
3783 }
3784 
3785 // File: @aragon/apps-token-manager/contracts/TokenManager.sol
3786 
3787 /*
3788  * SPDX-License-Identitifer:    GPL-3.0-or-later
3789  */
3790 
3791 /* solium-disable function-order */
3792 
3793 pragma solidity 0.4.24;
3794 
3795 
3796 
3797 
3798 
3799 
3800 
3801 contract TokenManager is ITokenController, IForwarder, AragonApp {
3802     using SafeMath for uint256;
3803 
3804     bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
3805     bytes32 public constant ISSUE_ROLE = keccak256("ISSUE_ROLE");
3806     bytes32 public constant ASSIGN_ROLE = keccak256("ASSIGN_ROLE");
3807     bytes32 public constant REVOKE_VESTINGS_ROLE = keccak256("REVOKE_VESTINGS_ROLE");
3808     bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");
3809 
3810     uint256 public constant MAX_VESTINGS_PER_ADDRESS = 50;
3811 
3812     string private constant ERROR_CALLER_NOT_TOKEN = "TM_CALLER_NOT_TOKEN";
3813     string private constant ERROR_NO_VESTING = "TM_NO_VESTING";
3814     string private constant ERROR_TOKEN_CONTROLLER = "TM_TOKEN_CONTROLLER";
3815     string private constant ERROR_MINT_RECEIVER_IS_TM = "TM_MINT_RECEIVER_IS_TM";
3816     string private constant ERROR_VESTING_TO_TM = "TM_VESTING_TO_TM";
3817     string private constant ERROR_TOO_MANY_VESTINGS = "TM_TOO_MANY_VESTINGS";
3818     string private constant ERROR_WRONG_CLIFF_DATE = "TM_WRONG_CLIFF_DATE";
3819     string private constant ERROR_VESTING_NOT_REVOKABLE = "TM_VESTING_NOT_REVOKABLE";
3820     string private constant ERROR_REVOKE_TRANSFER_FROM_REVERTED = "TM_REVOKE_TRANSFER_FROM_REVERTED";
3821     string private constant ERROR_CAN_NOT_FORWARD = "TM_CAN_NOT_FORWARD";
3822     string private constant ERROR_BALANCE_INCREASE_NOT_ALLOWED = "TM_BALANCE_INC_NOT_ALLOWED";
3823     string private constant ERROR_ASSIGN_TRANSFER_FROM_REVERTED = "TM_ASSIGN_TRANSFER_FROM_REVERTED";
3824 
3825     struct TokenVesting {
3826         uint256 amount;
3827         uint64 start;
3828         uint64 cliff;
3829         uint64 vesting;
3830         bool revokable;
3831     }
3832 
3833     // Note that we COMPLETELY trust this MiniMeToken to not be malicious for proper operation of this contract
3834     MiniMeToken public token;
3835     uint256 public maxAccountTokens;
3836 
3837     // We are mimicing an array in the inner mapping, we use a mapping instead to make app upgrade more graceful
3838     mapping (address => mapping (uint256 => TokenVesting)) internal vestings;
3839     mapping (address => uint256) public vestingsLengths;
3840 
3841     // Other token specific events can be watched on the token address directly (avoids duplication)
3842     event NewVesting(address indexed receiver, uint256 vestingId, uint256 amount);
3843     event RevokeVesting(address indexed receiver, uint256 vestingId, uint256 nonVestedAmount);
3844 
3845     modifier onlyToken() {
3846         require(msg.sender == address(token), ERROR_CALLER_NOT_TOKEN);
3847         _;
3848     }
3849 
3850     modifier vestingExists(address _holder, uint256 _vestingId) {
3851         // TODO: it's not checking for gaps that may appear because of deletes in revokeVesting function
3852         require(_vestingId < vestingsLengths[_holder], ERROR_NO_VESTING);
3853         _;
3854     }
3855 
3856     /**
3857     * @notice Initialize Token Manager for `_token.symbol(): string`, whose tokens are `transferable ? 'not' : ''` transferable`_maxAccountTokens > 0 ? ' and limited to a maximum of ' + @tokenAmount(_token, _maxAccountTokens, false) + ' per account' : ''`
3858     * @param _token MiniMeToken address for the managed token (Token Manager instance must be already set as the token controller)
3859     * @param _transferable whether the token can be transferred by holders
3860     * @param _maxAccountTokens Maximum amount of tokens an account can have (0 for infinite tokens)
3861     */
3862     function initialize(
3863         MiniMeToken _token,
3864         bool _transferable,
3865         uint256 _maxAccountTokens
3866     )
3867         external
3868         onlyInit
3869     {
3870         initialized();
3871 
3872         require(_token.controller() == address(this), ERROR_TOKEN_CONTROLLER);
3873 
3874         token = _token;
3875         maxAccountTokens = _maxAccountTokens == 0 ? uint256(-1) : _maxAccountTokens;
3876 
3877         if (token.transfersEnabled() != _transferable) {
3878             token.enableTransfers(_transferable);
3879         }
3880     }
3881 
3882     /**
3883     * @notice Mint `@tokenAmount(self.token(): address, _amount, false)` tokens for `_receiver`
3884     * @param _receiver The address receiving the tokens, cannot be the Token Manager itself (use `issue()` instead)
3885     * @param _amount Number of tokens minted
3886     */
3887     function mint(address _receiver, uint256 _amount) external authP(MINT_ROLE, arr(_receiver, _amount)) {
3888         require(_receiver != address(this), ERROR_MINT_RECEIVER_IS_TM);
3889         _mint(_receiver, _amount);
3890     }
3891 
3892     /**
3893     * @notice Mint `@tokenAmount(self.token(): address, _amount, false)` tokens for the Token Manager
3894     * @param _amount Number of tokens minted
3895     */
3896     function issue(uint256 _amount) external authP(ISSUE_ROLE, arr(_amount)) {
3897         _mint(address(this), _amount);
3898     }
3899 
3900     /**
3901     * @notice Assign `@tokenAmount(self.token(): address, _amount, false)` tokens to `_receiver` from the Token Manager's holdings
3902     * @param _receiver The address receiving the tokens
3903     * @param _amount Number of tokens transferred
3904     */
3905     function assign(address _receiver, uint256 _amount) external authP(ASSIGN_ROLE, arr(_receiver, _amount)) {
3906         _assign(_receiver, _amount);
3907     }
3908 
3909     /**
3910     * @notice Burn `@tokenAmount(self.token(): address, _amount, false)` tokens from `_holder`
3911     * @param _holder Holder of tokens being burned
3912     * @param _amount Number of tokens being burned
3913     */
3914     function burn(address _holder, uint256 _amount) external authP(BURN_ROLE, arr(_holder, _amount)) {
3915         // minime.destroyTokens() never returns false, only reverts on failure
3916         token.destroyTokens(_holder, _amount);
3917     }
3918 
3919     /**
3920     * @notice Assign `@tokenAmount(self.token(): address, _amount, false)` tokens to `_receiver` from the Token Manager's holdings with a `_revokable : 'revokable' : ''` vesting starting at `@formatDate(_start)`, cliff at `@formatDate(_cliff)` (first portion of tokens transferable), and completed vesting at `@formatDate(_vested)` (all tokens transferable)
3921     * @param _receiver The address receiving the tokens, cannot be Token Manager itself
3922     * @param _amount Number of tokens vested
3923     * @param _start Date the vesting calculations start
3924     * @param _cliff Date when the initial portion of tokens are transferable
3925     * @param _vested Date when all tokens are transferable
3926     * @param _revokable Whether the vesting can be revoked by the Token Manager
3927     */
3928     function assignVested(
3929         address _receiver,
3930         uint256 _amount,
3931         uint64 _start,
3932         uint64 _cliff,
3933         uint64 _vested,
3934         bool _revokable
3935     )
3936         external
3937         authP(ASSIGN_ROLE, arr(_receiver, _amount))
3938         returns (uint256)
3939     {
3940         require(_receiver != address(this), ERROR_VESTING_TO_TM);
3941         require(vestingsLengths[_receiver] < MAX_VESTINGS_PER_ADDRESS, ERROR_TOO_MANY_VESTINGS);
3942         require(_start <= _cliff && _cliff <= _vested, ERROR_WRONG_CLIFF_DATE);
3943 
3944         uint256 vestingId = vestingsLengths[_receiver]++;
3945         vestings[_receiver][vestingId] = TokenVesting(
3946             _amount,
3947             _start,
3948             _cliff,
3949             _vested,
3950             _revokable
3951         );
3952 
3953         _assign(_receiver, _amount);
3954 
3955         emit NewVesting(_receiver, vestingId, _amount);
3956 
3957         return vestingId;
3958     }
3959 
3960     /**
3961     * @notice Revoke vesting #`_vestingId` from `_holder`, returning unvested tokens to the Token Manager
3962     * @param _holder Address whose vesting to revoke
3963     * @param _vestingId Numeric id of the vesting
3964     */
3965     function revokeVesting(address _holder, uint256 _vestingId)
3966         external
3967         authP(REVOKE_VESTINGS_ROLE, arr(_holder))
3968         vestingExists(_holder, _vestingId)
3969     {
3970         TokenVesting storage v = vestings[_holder][_vestingId];
3971         require(v.revokable, ERROR_VESTING_NOT_REVOKABLE);
3972 
3973         uint256 nonVested = _calculateNonVestedTokens(
3974             v.amount,
3975             getTimestamp(),
3976             v.start,
3977             v.cliff,
3978             v.vesting
3979         );
3980 
3981         // To make vestingIds immutable over time, we just zero out the revoked vesting
3982         // Clearing this out also allows the token transfer back to the Token Manager to succeed
3983         delete vestings[_holder][_vestingId];
3984 
3985         // transferFrom always works as controller
3986         // onTransfer hook always allows if transfering to token controller
3987         require(token.transferFrom(_holder, address(this), nonVested), ERROR_REVOKE_TRANSFER_FROM_REVERTED);
3988 
3989         emit RevokeVesting(_holder, _vestingId, nonVested);
3990     }
3991 
3992     // ITokenController fns
3993     // `onTransfer()`, `onApprove()`, and `proxyPayment()` are callbacks from the MiniMe token
3994     // contract and are only meant to be called through the managed MiniMe token that gets assigned
3995     // during initialization.
3996 
3997     /*
3998     * @dev Notifies the controller about a token transfer allowing the controller to decide whether
3999     *      to allow it or react if desired (only callable from the token).
4000     *      Initialization check is implicitly provided by `onlyToken()`.
4001     * @param _from The origin of the transfer
4002     * @param _to The destination of the transfer
4003     * @param _amount The amount of the transfer
4004     * @return False if the controller does not authorize the transfer
4005     */
4006     function onTransfer(address _from, address _to, uint256 _amount) external onlyToken returns (bool) {
4007         return _isBalanceIncreaseAllowed(_to, _amount) && _transferableBalance(_from, getTimestamp()) >= _amount;
4008     }
4009 
4010     /**
4011     * @dev Notifies the controller about an approval allowing the controller to react if desired
4012     *      Initialization check is implicitly provided by `onlyToken()`.
4013     * @return False if the controller does not authorize the approval
4014     */
4015     function onApprove(address, address, uint) external onlyToken returns (bool) {
4016         return true;
4017     }
4018 
4019     /**
4020     * @dev Called when ether is sent to the MiniMe Token contract
4021     *      Initialization check is implicitly provided by `onlyToken()`.
4022     * @return True if the ether is accepted, false for it to throw
4023     */
4024     function proxyPayment(address) external payable onlyToken returns (bool) {
4025         return false;
4026     }
4027 
4028     // Forwarding fns
4029 
4030     function isForwarder() external pure returns (bool) {
4031         return true;
4032     }
4033 
4034     /**
4035     * @notice Execute desired action as a token holder
4036     * @dev IForwarder interface conformance. Forwards any token holder action.
4037     * @param _evmScript Script being executed
4038     */
4039     function forward(bytes _evmScript) public {
4040         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
4041         bytes memory input = new bytes(0); // TODO: Consider input for this
4042 
4043         // Add the managed token to the blacklist to disallow a token holder from executing actions
4044         // on the token controller's (this contract) behalf
4045         address[] memory blacklist = new address[](1);
4046         blacklist[0] = address(token);
4047 
4048         runScript(_evmScript, input, blacklist);
4049     }
4050 
4051     function canForward(address _sender, bytes) public view returns (bool) {
4052         return hasInitialized() && token.balanceOf(_sender) > 0;
4053     }
4054 
4055     // Getter fns
4056 
4057     function getVesting(
4058         address _recipient,
4059         uint256 _vestingId
4060     )
4061         public
4062         view
4063         vestingExists(_recipient, _vestingId)
4064         returns (
4065             uint256 amount,
4066             uint64 start,
4067             uint64 cliff,
4068             uint64 vesting,
4069             bool revokable
4070         )
4071     {
4072         TokenVesting storage tokenVesting = vestings[_recipient][_vestingId];
4073         amount = tokenVesting.amount;
4074         start = tokenVesting.start;
4075         cliff = tokenVesting.cliff;
4076         vesting = tokenVesting.vesting;
4077         revokable = tokenVesting.revokable;
4078     }
4079 
4080     function spendableBalanceOf(address _holder) public view isInitialized returns (uint256) {
4081         return _transferableBalance(_holder, getTimestamp());
4082     }
4083 
4084     function transferableBalance(address _holder, uint256 _time) public view isInitialized returns (uint256) {
4085         return _transferableBalance(_holder, _time);
4086     }
4087 
4088     /**
4089     * @dev Disable recovery escape hatch for own token,
4090     *      as the it has the concept of issuing tokens without assigning them
4091     */
4092     function allowRecoverability(address _token) public view returns (bool) {
4093         return _token != address(token);
4094     }
4095 
4096     // Internal fns
4097 
4098     function _assign(address _receiver, uint256 _amount) internal {
4099         require(_isBalanceIncreaseAllowed(_receiver, _amount), ERROR_BALANCE_INCREASE_NOT_ALLOWED);
4100         // Must use transferFrom() as transfer() does not give the token controller full control
4101         require(token.transferFrom(address(this), _receiver, _amount), ERROR_ASSIGN_TRANSFER_FROM_REVERTED);
4102     }
4103 
4104     function _mint(address _receiver, uint256 _amount) internal {
4105         require(_isBalanceIncreaseAllowed(_receiver, _amount), ERROR_BALANCE_INCREASE_NOT_ALLOWED);
4106         token.generateTokens(_receiver, _amount); // minime.generateTokens() never returns false
4107     }
4108 
4109     function _isBalanceIncreaseAllowed(address _receiver, uint256 _inc) internal view returns (bool) {
4110         // Max balance doesn't apply to the token manager itself
4111         if (_receiver == address(this)) {
4112             return true;
4113         }
4114         return token.balanceOf(_receiver).add(_inc) <= maxAccountTokens;
4115     }
4116 
4117     /**
4118     * @dev Calculate amount of non-vested tokens at a specifc time
4119     * @param tokens The total amount of tokens vested
4120     * @param time The time at which to check
4121     * @param start The date vesting started
4122     * @param cliff The cliff period
4123     * @param vested The fully vested date
4124     * @return The amount of non-vested tokens of a specific grant
4125     *  transferableTokens
4126     *   |                         _/--------   vestedTokens rect
4127     *   |                       _/
4128     *   |                     _/
4129     *   |                   _/
4130     *   |                 _/
4131     *   |                /
4132     *   |              .|
4133     *   |            .  |
4134     *   |          .    |
4135     *   |        .      |
4136     *   |      .        |
4137     *   |    .          |
4138     *   +===+===========+---------+----------> time
4139     *      Start       Cliff    Vested
4140     */
4141     function _calculateNonVestedTokens(
4142         uint256 tokens,
4143         uint256 time,
4144         uint256 start,
4145         uint256 cliff,
4146         uint256 vested
4147     )
4148         private
4149         pure
4150         returns (uint256)
4151     {
4152         // Shortcuts for before cliff and after vested cases.
4153         if (time >= vested) {
4154             return 0;
4155         }
4156         if (time < cliff) {
4157             return tokens;
4158         }
4159 
4160         // Interpolate all vested tokens.
4161         // As before cliff the shortcut returns 0, we can just calculate a value
4162         // in the vesting rect (as shown in above's figure)
4163 
4164         // vestedTokens = tokens * (time - start) / (vested - start)
4165         // In assignVesting we enforce start <= cliff <= vested
4166         // Here we shortcut time >= vested and time < cliff,
4167         // so no division by 0 is possible
4168         uint256 vestedTokens = tokens.mul(time.sub(start)) / vested.sub(start);
4169 
4170         // tokens - vestedTokens
4171         return tokens.sub(vestedTokens);
4172     }
4173 
4174     function _transferableBalance(address _holder, uint256 _time) internal view returns (uint256) {
4175         uint256 transferable = token.balanceOf(_holder);
4176 
4177         // This check is not strictly necessary for the current version of this contract, as
4178         // Token Managers now cannot assign vestings to themselves.
4179         // However, this was a possibility in the past, so in case there were vestings assigned to
4180         // themselves, this will still return the correct value (entire balance, as the Token
4181         // Manager does not have a spending limit on its own balance).
4182         if (_holder != address(this)) {
4183             uint256 vestingsCount = vestingsLengths[_holder];
4184             for (uint256 i = 0; i < vestingsCount; i++) {
4185                 TokenVesting storage v = vestings[_holder][i];
4186                 uint256 nonTransferable = _calculateNonVestedTokens(
4187                     v.amount,
4188                     _time,
4189                     v.start,
4190                     v.cliff,
4191                     v.vesting
4192                 );
4193                 transferable = transferable.sub(nonTransferable);
4194             }
4195         }
4196 
4197         return transferable;
4198     }
4199 }
4200 
4201 // File: @aragon/apps-finance/contracts/Finance.sol
4202 
4203 /*
4204  * SPDX-License-Identitifer:    GPL-3.0-or-later
4205  */
4206 
4207 pragma solidity 0.4.24;
4208 
4209 
4210 
4211 
4212 
4213 
4214 
4215 
4216 
4217 
4218 contract Finance is EtherTokenConstant, IsContract, AragonApp {
4219     using SafeMath for uint256;
4220     using SafeMath64 for uint64;
4221     using SafeERC20 for ERC20;
4222 
4223     bytes32 public constant CREATE_PAYMENTS_ROLE = keccak256("CREATE_PAYMENTS_ROLE");
4224     bytes32 public constant CHANGE_PERIOD_ROLE = keccak256("CHANGE_PERIOD_ROLE");
4225     bytes32 public constant CHANGE_BUDGETS_ROLE = keccak256("CHANGE_BUDGETS_ROLE");
4226     bytes32 public constant EXECUTE_PAYMENTS_ROLE = keccak256("EXECUTE_PAYMENTS_ROLE");
4227     bytes32 public constant MANAGE_PAYMENTS_ROLE = keccak256("MANAGE_PAYMENTS_ROLE");
4228 
4229     uint256 internal constant NO_SCHEDULED_PAYMENT = 0;
4230     uint256 internal constant NO_TRANSACTION = 0;
4231     uint256 internal constant MAX_SCHEDULED_PAYMENTS_PER_TX = 20;
4232     uint256 internal constant MAX_UINT256 = uint256(-1);
4233     uint64 internal constant MAX_UINT64 = uint64(-1);
4234     uint64 internal constant MINIMUM_PERIOD = uint64(1 days);
4235 
4236     string private constant ERROR_COMPLETE_TRANSITION = "FINANCE_COMPLETE_TRANSITION";
4237     string private constant ERROR_NO_SCHEDULED_PAYMENT = "FINANCE_NO_SCHEDULED_PAYMENT";
4238     string private constant ERROR_NO_TRANSACTION = "FINANCE_NO_TRANSACTION";
4239     string private constant ERROR_NO_PERIOD = "FINANCE_NO_PERIOD";
4240     string private constant ERROR_VAULT_NOT_CONTRACT = "FINANCE_VAULT_NOT_CONTRACT";
4241     string private constant ERROR_SET_PERIOD_TOO_SHORT = "FINANCE_SET_PERIOD_TOO_SHORT";
4242     string private constant ERROR_NEW_PAYMENT_AMOUNT_ZERO = "FINANCE_NEW_PAYMENT_AMOUNT_ZERO";
4243     string private constant ERROR_NEW_PAYMENT_INTERVAL_ZERO = "FINANCE_NEW_PAYMENT_INTRVL_ZERO";
4244     string private constant ERROR_NEW_PAYMENT_EXECS_ZERO = "FINANCE_NEW_PAYMENT_EXECS_ZERO";
4245     string private constant ERROR_NEW_PAYMENT_IMMEDIATE = "FINANCE_NEW_PAYMENT_IMMEDIATE";
4246     string private constant ERROR_RECOVER_AMOUNT_ZERO = "FINANCE_RECOVER_AMOUNT_ZERO";
4247     string private constant ERROR_DEPOSIT_AMOUNT_ZERO = "FINANCE_DEPOSIT_AMOUNT_ZERO";
4248     string private constant ERROR_ETH_VALUE_MISMATCH = "FINANCE_ETH_VALUE_MISMATCH";
4249     string private constant ERROR_BUDGET = "FINANCE_BUDGET";
4250     string private constant ERROR_EXECUTE_PAYMENT_NUM = "FINANCE_EXECUTE_PAYMENT_NUM";
4251     string private constant ERROR_EXECUTE_PAYMENT_TIME = "FINANCE_EXECUTE_PAYMENT_TIME";
4252     string private constant ERROR_PAYMENT_RECEIVER = "FINANCE_PAYMENT_RECEIVER";
4253     string private constant ERROR_TOKEN_TRANSFER_FROM_REVERTED = "FINANCE_TKN_TRANSFER_FROM_REVERT";
4254     string private constant ERROR_TOKEN_APPROVE_FAILED = "FINANCE_TKN_APPROVE_FAILED";
4255     string private constant ERROR_PAYMENT_INACTIVE = "FINANCE_PAYMENT_INACTIVE";
4256     string private constant ERROR_REMAINING_BUDGET = "FINANCE_REMAINING_BUDGET";
4257 
4258     // Order optimized for storage
4259     struct ScheduledPayment {
4260         address token;
4261         address receiver;
4262         address createdBy;
4263         bool inactive;
4264         uint256 amount;
4265         uint64 initialPaymentTime;
4266         uint64 interval;
4267         uint64 maxExecutions;
4268         uint64 executions;
4269     }
4270 
4271     // Order optimized for storage
4272     struct Transaction {
4273         address token;
4274         address entity;
4275         bool isIncoming;
4276         uint256 amount;
4277         uint256 paymentId;
4278         uint64 paymentExecutionNumber;
4279         uint64 date;
4280         uint64 periodId;
4281     }
4282 
4283     struct TokenStatement {
4284         uint256 expenses;
4285         uint256 income;
4286     }
4287 
4288     struct Period {
4289         uint64 startTime;
4290         uint64 endTime;
4291         uint256 firstTransactionId;
4292         uint256 lastTransactionId;
4293         mapping (address => TokenStatement) tokenStatement;
4294     }
4295 
4296     struct Settings {
4297         uint64 periodDuration;
4298         mapping (address => uint256) budgets;
4299         mapping (address => bool) hasBudget;
4300     }
4301 
4302     Vault public vault;
4303     Settings internal settings;
4304 
4305     // We are mimicing arrays, we use mappings instead to make app upgrade more graceful
4306     mapping (uint256 => ScheduledPayment) internal scheduledPayments;
4307     // Payments start at index 1, to allow us to use scheduledPayments[0] for transactions that are not
4308     // linked to a scheduled payment
4309     uint256 public paymentsNextIndex;
4310 
4311     mapping (uint256 => Transaction) internal transactions;
4312     uint256 public transactionsNextIndex;
4313 
4314     mapping (uint64 => Period) internal periods;
4315     uint64 public periodsLength;
4316 
4317     event NewPeriod(uint64 indexed periodId, uint64 periodStarts, uint64 periodEnds);
4318     event SetBudget(address indexed token, uint256 amount, bool hasBudget);
4319     event NewPayment(uint256 indexed paymentId, address indexed recipient, uint64 maxExecutions, string reference);
4320     event NewTransaction(uint256 indexed transactionId, bool incoming, address indexed entity, uint256 amount, string reference);
4321     event ChangePaymentState(uint256 indexed paymentId, bool active);
4322     event ChangePeriodDuration(uint64 newDuration);
4323     event PaymentFailure(uint256 paymentId);
4324 
4325     // Modifier used by all methods that impact accounting to make sure accounting period
4326     // is changed before the operation if needed
4327     // NOTE: its use **MUST** be accompanied by an initialization check
4328     modifier transitionsPeriod {
4329         bool completeTransition = _tryTransitionAccountingPeriod(getMaxPeriodTransitions());
4330         require(completeTransition, ERROR_COMPLETE_TRANSITION);
4331         _;
4332     }
4333 
4334     modifier scheduledPaymentExists(uint256 _paymentId) {
4335         require(_paymentId > 0 && _paymentId < paymentsNextIndex, ERROR_NO_SCHEDULED_PAYMENT);
4336         _;
4337     }
4338 
4339     modifier transactionExists(uint256 _transactionId) {
4340         require(_transactionId > 0 && _transactionId < transactionsNextIndex, ERROR_NO_TRANSACTION);
4341         _;
4342     }
4343 
4344     modifier periodExists(uint64 _periodId) {
4345         require(_periodId < periodsLength, ERROR_NO_PERIOD);
4346         _;
4347     }
4348 
4349     /**
4350      * @notice Deposit ETH to the Vault, to avoid locking them in this Finance app forever
4351      * @dev Send ETH to Vault. Send all the available balance.
4352      */
4353     function () external payable isInitialized transitionsPeriod {
4354         require(msg.value > 0, ERROR_DEPOSIT_AMOUNT_ZERO);
4355         _deposit(
4356             ETH,
4357             msg.value,
4358             "Ether transfer to Finance app",
4359             msg.sender,
4360             true
4361         );
4362     }
4363 
4364     /**
4365     * @notice Initialize Finance app for Vault at `_vault` with period length of `@transformTime(_periodDuration)`
4366     * @param _vault Address of the vault Finance will rely on (non changeable)
4367     * @param _periodDuration Duration in seconds of each period
4368     */
4369     function initialize(Vault _vault, uint64 _periodDuration) external onlyInit {
4370         initialized();
4371 
4372         require(isContract(_vault), ERROR_VAULT_NOT_CONTRACT);
4373         vault = _vault;
4374 
4375         require(_periodDuration >= MINIMUM_PERIOD, ERROR_SET_PERIOD_TOO_SHORT);
4376         settings.periodDuration = _periodDuration;
4377 
4378         // Reserve the first scheduled payment index as an unused index for transactions not linked
4379         // to a scheduled payment
4380         scheduledPayments[0].inactive = true;
4381         paymentsNextIndex = 1;
4382 
4383         // Reserve the first transaction index as an unused index for periods with no transactions
4384         transactionsNextIndex = 1;
4385 
4386         // Start the first period
4387         _newPeriod(getTimestamp64());
4388     }
4389 
4390     /**
4391     * @notice Deposit `@tokenAmount(_token, _amount)`
4392     * @dev Deposit for approved ERC20 tokens or ETH
4393     * @param _token Address of deposited token
4394     * @param _amount Amount of tokens sent
4395     * @param _reference Reason for payment
4396     */
4397     function deposit(address _token, uint256 _amount, string _reference) external payable isInitialized transitionsPeriod {
4398         require(_amount > 0, ERROR_DEPOSIT_AMOUNT_ZERO);
4399         if (_token == ETH) {
4400             // Ensure that the ETH sent with the transaction equals the amount in the deposit
4401             require(msg.value == _amount, ERROR_ETH_VALUE_MISMATCH);
4402         }
4403 
4404         _deposit(
4405             _token,
4406             _amount,
4407             _reference,
4408             msg.sender,
4409             true
4410         );
4411     }
4412 
4413     /**
4414     * @notice Create a new payment of `@tokenAmount(_token, _amount)` to `_receiver` for '`_reference`'
4415     * @dev Note that this function is protected by the `CREATE_PAYMENTS_ROLE` but uses `MAX_UINT256`
4416     *      as its interval auth parameter (as a sentinel value for "never repeating").
4417     *      While this protects against most cases (you typically want to set a baseline requirement
4418     *      for interval time), it does mean users will have to explicitly check for this case when
4419     *      granting a permission that includes a upperbound requirement on the interval time.
4420     * @param _token Address of token for payment
4421     * @param _receiver Address that will receive payment
4422     * @param _amount Tokens that are paid every time the payment is due
4423     * @param _reference String detailing payment reason
4424     */
4425     function newImmediatePayment(address _token, address _receiver, uint256 _amount, string _reference)
4426         external
4427         // Use MAX_UINT256 as the interval parameter, as this payment will never repeat
4428         // Payment time parameter is left as the last param as it was added later
4429         authP(CREATE_PAYMENTS_ROLE, _arr(_token, _receiver, _amount, MAX_UINT256, uint256(1), getTimestamp()))
4430         transitionsPeriod
4431     {
4432         require(_amount > 0, ERROR_NEW_PAYMENT_AMOUNT_ZERO);
4433 
4434         _makePaymentTransaction(
4435             _token,
4436             _receiver,
4437             _amount,
4438             NO_SCHEDULED_PAYMENT,   // unrelated to any payment id; it isn't created
4439             0,   // also unrelated to any payment executions
4440             _reference
4441         );
4442     }
4443 
4444     /**
4445     * @notice Create a new payment of `@tokenAmount(_token, _amount)` to `_receiver` for `_reference`, executing `_maxExecutions` times at intervals of `@transformTime(_interval)`
4446     * @dev See `newImmediatePayment()` for limitations on how the interval auth parameter can be used
4447     * @param _token Address of token for payment
4448     * @param _receiver Address that will receive payment
4449     * @param _amount Tokens that are paid every time the payment is due
4450     * @param _initialPaymentTime Timestamp for when the first payment is done
4451     * @param _interval Number of seconds that need to pass between payment transactions
4452     * @param _maxExecutions Maximum instances a payment can be executed
4453     * @param _reference String detailing payment reason
4454     */
4455     function newScheduledPayment(
4456         address _token,
4457         address _receiver,
4458         uint256 _amount,
4459         uint64 _initialPaymentTime,
4460         uint64 _interval,
4461         uint64 _maxExecutions,
4462         string _reference
4463     )
4464         external
4465         // Payment time parameter is left as the last param as it was added later
4466         authP(CREATE_PAYMENTS_ROLE, _arr(_token, _receiver, _amount, uint256(_interval), uint256(_maxExecutions), uint256(_initialPaymentTime)))
4467         transitionsPeriod
4468         returns (uint256 paymentId)
4469     {
4470         require(_amount > 0, ERROR_NEW_PAYMENT_AMOUNT_ZERO);
4471         require(_interval > 0, ERROR_NEW_PAYMENT_INTERVAL_ZERO);
4472         require(_maxExecutions > 0, ERROR_NEW_PAYMENT_EXECS_ZERO);
4473 
4474         // Token budget must not be set at all or allow at least one instance of this payment each period
4475         require(!settings.hasBudget[_token] || settings.budgets[_token] >= _amount, ERROR_BUDGET);
4476 
4477         // Don't allow creating single payments that are immediately executable, use `newImmediatePayment()` instead
4478         if (_maxExecutions == 1) {
4479             require(_initialPaymentTime > getTimestamp64(), ERROR_NEW_PAYMENT_IMMEDIATE);
4480         }
4481 
4482         paymentId = paymentsNextIndex++;
4483         emit NewPayment(paymentId, _receiver, _maxExecutions, _reference);
4484 
4485         ScheduledPayment storage payment = scheduledPayments[paymentId];
4486         payment.token = _token;
4487         payment.receiver = _receiver;
4488         payment.amount = _amount;
4489         payment.initialPaymentTime = _initialPaymentTime;
4490         payment.interval = _interval;
4491         payment.maxExecutions = _maxExecutions;
4492         payment.createdBy = msg.sender;
4493 
4494         // We skip checking how many times the new payment was executed to allow creating new
4495         // scheduled payments before having enough vault balance
4496         _executePayment(paymentId);
4497     }
4498 
4499     /**
4500     * @notice Change period duration to `@transformTime(_periodDuration)`, effective for next accounting period
4501     * @param _periodDuration Duration in seconds for accounting periods
4502     */
4503     function setPeriodDuration(uint64 _periodDuration)
4504         external
4505         authP(CHANGE_PERIOD_ROLE, arr(uint256(_periodDuration), uint256(settings.periodDuration)))
4506         transitionsPeriod
4507     {
4508         require(_periodDuration >= MINIMUM_PERIOD, ERROR_SET_PERIOD_TOO_SHORT);
4509         settings.periodDuration = _periodDuration;
4510         emit ChangePeriodDuration(_periodDuration);
4511     }
4512 
4513     /**
4514     * @notice Set budget for `_token.symbol(): string` to `@tokenAmount(_token, _amount, false)`, effective immediately
4515     * @param _token Address for token
4516     * @param _amount New budget amount
4517     */
4518     function setBudget(
4519         address _token,
4520         uint256 _amount
4521     )
4522         external
4523         authP(CHANGE_BUDGETS_ROLE, arr(_token, _amount, settings.budgets[_token], uint256(settings.hasBudget[_token] ? 1 : 0)))
4524         transitionsPeriod
4525     {
4526         settings.budgets[_token] = _amount;
4527         if (!settings.hasBudget[_token]) {
4528             settings.hasBudget[_token] = true;
4529         }
4530         emit SetBudget(_token, _amount, true);
4531     }
4532 
4533     /**
4534     * @notice Remove spending limit for `_token.symbol(): string`, effective immediately
4535     * @param _token Address for token
4536     */
4537     function removeBudget(address _token)
4538         external
4539         authP(CHANGE_BUDGETS_ROLE, arr(_token, uint256(0), settings.budgets[_token], uint256(settings.hasBudget[_token] ? 1 : 0)))
4540         transitionsPeriod
4541     {
4542         settings.budgets[_token] = 0;
4543         settings.hasBudget[_token] = false;
4544         emit SetBudget(_token, 0, false);
4545     }
4546 
4547     /**
4548     * @notice Execute pending payment #`_paymentId`
4549     * @dev Executes any payment (requires role)
4550     * @param _paymentId Identifier for payment
4551     */
4552     function executePayment(uint256 _paymentId)
4553         external
4554         authP(EXECUTE_PAYMENTS_ROLE, arr(_paymentId, scheduledPayments[_paymentId].amount))
4555         scheduledPaymentExists(_paymentId)
4556         transitionsPeriod
4557     {
4558         _executePaymentAtLeastOnce(_paymentId);
4559     }
4560 
4561     /**
4562     * @notice Execute pending payment #`_paymentId`
4563     * @dev Always allow receiver of a payment to trigger execution
4564     *      Initialization check is implicitly provided by `scheduledPaymentExists()` as new
4565     *      scheduled payments can only be created via `newScheduledPayment(),` which requires initialization
4566     * @param _paymentId Identifier for payment
4567     */
4568     function receiverExecutePayment(uint256 _paymentId) external scheduledPaymentExists(_paymentId) transitionsPeriod {
4569         require(scheduledPayments[_paymentId].receiver == msg.sender, ERROR_PAYMENT_RECEIVER);
4570         _executePaymentAtLeastOnce(_paymentId);
4571     }
4572 
4573     /**
4574     * @notice `_active ? 'Activate' : 'Disable'` payment #`_paymentId`
4575     * @dev Note that we do not require this action to transition periods, as it doesn't directly
4576     *      impact any accounting periods.
4577     *      Not having to transition periods also makes disabling payments easier to prevent funds
4578     *      from being pulled out in the event of a breach.
4579     * @param _paymentId Identifier for payment
4580     * @param _active Whether it will be active or inactive
4581     */
4582     function setPaymentStatus(uint256 _paymentId, bool _active)
4583         external
4584         authP(MANAGE_PAYMENTS_ROLE, arr(_paymentId, uint256(_active ? 1 : 0)))
4585         scheduledPaymentExists(_paymentId)
4586     {
4587         scheduledPayments[_paymentId].inactive = !_active;
4588         emit ChangePaymentState(_paymentId, _active);
4589     }
4590 
4591     /**
4592      * @notice Send tokens held in this contract to the Vault
4593      * @dev Allows making a simple payment from this contract to the Vault, to avoid locked tokens.
4594      *      This contract should never receive tokens with a simple transfer call, but in case it
4595      *      happens, this function allows for their recovery.
4596      * @param _token Token whose balance is going to be transferred.
4597      */
4598     function recoverToVault(address _token) external isInitialized transitionsPeriod {
4599         uint256 amount = _token == ETH ? address(this).balance : ERC20(_token).staticBalanceOf(address(this));
4600         require(amount > 0, ERROR_RECOVER_AMOUNT_ZERO);
4601 
4602         _deposit(
4603             _token,
4604             amount,
4605             "Recover to Vault",
4606             address(this),
4607             false
4608         );
4609     }
4610 
4611     /**
4612     * @notice Transition accounting period if needed
4613     * @dev Transitions accounting periods if needed. For preventing OOG attacks, a maxTransitions
4614     *      param is provided. If more than the specified number of periods need to be transitioned,
4615     *      it will return false.
4616     * @param _maxTransitions Maximum periods that can be transitioned
4617     * @return success Boolean indicating whether the accounting period is the correct one (if false,
4618     *                 maxTransitions was surpased and another call is needed)
4619     */
4620     function tryTransitionAccountingPeriod(uint64 _maxTransitions) external isInitialized returns (bool success) {
4621         return _tryTransitionAccountingPeriod(_maxTransitions);
4622     }
4623 
4624     // Getter fns
4625 
4626     /**
4627     * @dev Disable recovery escape hatch if the app has been initialized, as it could be used
4628     *      maliciously to transfer funds in the Finance app to another Vault
4629     *      finance#recoverToVault() should be used to recover funds to the Finance's vault
4630     */
4631     function allowRecoverability(address) public view returns (bool) {
4632         return !hasInitialized();
4633     }
4634 
4635     function getPayment(uint256 _paymentId)
4636         public
4637         view
4638         scheduledPaymentExists(_paymentId)
4639         returns (
4640             address token,
4641             address receiver,
4642             uint256 amount,
4643             uint64 initialPaymentTime,
4644             uint64 interval,
4645             uint64 maxExecutions,
4646             bool inactive,
4647             uint64 executions,
4648             address createdBy
4649         )
4650     {
4651         ScheduledPayment storage payment = scheduledPayments[_paymentId];
4652 
4653         token = payment.token;
4654         receiver = payment.receiver;
4655         amount = payment.amount;
4656         initialPaymentTime = payment.initialPaymentTime;
4657         interval = payment.interval;
4658         maxExecutions = payment.maxExecutions;
4659         executions = payment.executions;
4660         inactive = payment.inactive;
4661         createdBy = payment.createdBy;
4662     }
4663 
4664     function getTransaction(uint256 _transactionId)
4665         public
4666         view
4667         transactionExists(_transactionId)
4668         returns (
4669             uint64 periodId,
4670             uint256 amount,
4671             uint256 paymentId,
4672             uint64 paymentExecutionNumber,
4673             address token,
4674             address entity,
4675             bool isIncoming,
4676             uint64 date
4677         )
4678     {
4679         Transaction storage transaction = transactions[_transactionId];
4680 
4681         token = transaction.token;
4682         entity = transaction.entity;
4683         isIncoming = transaction.isIncoming;
4684         date = transaction.date;
4685         periodId = transaction.periodId;
4686         amount = transaction.amount;
4687         paymentId = transaction.paymentId;
4688         paymentExecutionNumber = transaction.paymentExecutionNumber;
4689     }
4690 
4691     function getPeriod(uint64 _periodId)
4692         public
4693         view
4694         periodExists(_periodId)
4695         returns (
4696             bool isCurrent,
4697             uint64 startTime,
4698             uint64 endTime,
4699             uint256 firstTransactionId,
4700             uint256 lastTransactionId
4701         )
4702     {
4703         Period storage period = periods[_periodId];
4704 
4705         isCurrent = _currentPeriodId() == _periodId;
4706 
4707         startTime = period.startTime;
4708         endTime = period.endTime;
4709         firstTransactionId = period.firstTransactionId;
4710         lastTransactionId = period.lastTransactionId;
4711     }
4712 
4713     function getPeriodTokenStatement(uint64 _periodId, address _token)
4714         public
4715         view
4716         periodExists(_periodId)
4717         returns (uint256 expenses, uint256 income)
4718     {
4719         TokenStatement storage tokenStatement = periods[_periodId].tokenStatement[_token];
4720         expenses = tokenStatement.expenses;
4721         income = tokenStatement.income;
4722     }
4723 
4724     /**
4725     * @dev We have to check for initialization as periods are only valid after initializing
4726     */
4727     function currentPeriodId() public view isInitialized returns (uint64) {
4728         return _currentPeriodId();
4729     }
4730 
4731     /**
4732     * @dev We have to check for initialization as periods are only valid after initializing
4733     */
4734     function getPeriodDuration() public view isInitialized returns (uint64) {
4735         return settings.periodDuration;
4736     }
4737 
4738     /**
4739     * @dev We have to check for initialization as budgets are only valid after initializing
4740     */
4741     function getBudget(address _token) public view isInitialized returns (uint256 budget, bool hasBudget) {
4742         budget = settings.budgets[_token];
4743         hasBudget = settings.hasBudget[_token];
4744     }
4745 
4746     /**
4747     * @dev We have to check for initialization as budgets are only valid after initializing
4748     */
4749     function getRemainingBudget(address _token) public view isInitialized returns (uint256) {
4750         return _getRemainingBudget(_token);
4751     }
4752 
4753     /**
4754     * @dev We have to check for initialization as budgets are only valid after initializing
4755     */
4756     function canMakePayment(address _token, uint256 _amount) public view isInitialized returns (bool) {
4757         return _canMakePayment(_token, _amount);
4758     }
4759 
4760     /**
4761     * @dev Initialization check is implicitly provided by `scheduledPaymentExists()` as new
4762     *      scheduled payments can only be created via `newScheduledPayment(),` which requires initialization
4763     */
4764     function nextPaymentTime(uint256 _paymentId) public view scheduledPaymentExists(_paymentId) returns (uint64) {
4765         return _nextPaymentTime(_paymentId);
4766     }
4767 
4768     // Internal fns
4769 
4770     function _deposit(address _token, uint256 _amount, string _reference, address _sender, bool _isExternalDeposit) internal {
4771         _recordIncomingTransaction(
4772             _token,
4773             _sender,
4774             _amount,
4775             _reference
4776         );
4777 
4778         if (_token == ETH) {
4779             vault.deposit.value(_amount)(ETH, _amount);
4780         } else {
4781             // First, transfer the tokens to Finance if necessary
4782             // External deposit will be false when the assets were already in the Finance app
4783             // and just need to be transferred to the Vault
4784             if (_isExternalDeposit) {
4785                 // This assumes the sender has approved the tokens for Finance
4786                 require(
4787                     ERC20(_token).safeTransferFrom(msg.sender, address(this), _amount),
4788                     ERROR_TOKEN_TRANSFER_FROM_REVERTED
4789                 );
4790             }
4791             // Approve the tokens for the Vault (it does the actual transferring)
4792             require(ERC20(_token).safeApprove(vault, _amount), ERROR_TOKEN_APPROVE_FAILED);
4793             // Finally, initiate the deposit
4794             vault.deposit(_token, _amount);
4795         }
4796     }
4797 
4798     function _executePayment(uint256 _paymentId) internal returns (uint256) {
4799         ScheduledPayment storage payment = scheduledPayments[_paymentId];
4800         require(!payment.inactive, ERROR_PAYMENT_INACTIVE);
4801 
4802         uint64 paid = 0;
4803         while (_nextPaymentTime(_paymentId) <= getTimestamp64() && paid < MAX_SCHEDULED_PAYMENTS_PER_TX) {
4804             if (!_canMakePayment(payment.token, payment.amount)) {
4805                 emit PaymentFailure(_paymentId);
4806                 break;
4807             }
4808 
4809             // The while() predicate prevents these two from ever overflowing
4810             payment.executions += 1;
4811             paid += 1;
4812 
4813             // We've already checked the remaining budget with `_canMakePayment()`
4814             _unsafeMakePaymentTransaction(
4815                 payment.token,
4816                 payment.receiver,
4817                 payment.amount,
4818                 _paymentId,
4819                 payment.executions,
4820                 ""
4821             );
4822         }
4823 
4824         return paid;
4825     }
4826 
4827     function _executePaymentAtLeastOnce(uint256 _paymentId) internal {
4828         uint256 paid = _executePayment(_paymentId);
4829         if (paid == 0) {
4830             if (_nextPaymentTime(_paymentId) <= getTimestamp64()) {
4831                 revert(ERROR_EXECUTE_PAYMENT_NUM);
4832             } else {
4833                 revert(ERROR_EXECUTE_PAYMENT_TIME);
4834             }
4835         }
4836     }
4837 
4838     function _makePaymentTransaction(
4839         address _token,
4840         address _receiver,
4841         uint256 _amount,
4842         uint256 _paymentId,
4843         uint64 _paymentExecutionNumber,
4844         string _reference
4845     )
4846         internal
4847     {
4848         require(_getRemainingBudget(_token) >= _amount, ERROR_REMAINING_BUDGET);
4849         _unsafeMakePaymentTransaction(_token, _receiver, _amount, _paymentId, _paymentExecutionNumber, _reference);
4850     }
4851 
4852     /**
4853     * @dev Unsafe version of _makePaymentTransaction that assumes you have already checked the
4854     *      remaining budget
4855     */
4856     function _unsafeMakePaymentTransaction(
4857         address _token,
4858         address _receiver,
4859         uint256 _amount,
4860         uint256 _paymentId,
4861         uint64 _paymentExecutionNumber,
4862         string _reference
4863     )
4864         internal
4865     {
4866         _recordTransaction(
4867             false,
4868             _token,
4869             _receiver,
4870             _amount,
4871             _paymentId,
4872             _paymentExecutionNumber,
4873             _reference
4874         );
4875 
4876         vault.transfer(_token, _receiver, _amount);
4877     }
4878 
4879     function _newPeriod(uint64 _startTime) internal returns (Period storage) {
4880         // There should be no way for this to overflow since each period is at least one day
4881         uint64 newPeriodId = periodsLength++;
4882 
4883         Period storage period = periods[newPeriodId];
4884         period.startTime = _startTime;
4885 
4886         // Be careful here to not overflow; if startTime + periodDuration overflows, we set endTime
4887         // to MAX_UINT64 (let's assume that's the end of time for now).
4888         uint64 endTime = _startTime + settings.periodDuration - 1;
4889         if (endTime < _startTime) { // overflowed
4890             endTime = MAX_UINT64;
4891         }
4892         period.endTime = endTime;
4893 
4894         emit NewPeriod(newPeriodId, period.startTime, period.endTime);
4895 
4896         return period;
4897     }
4898 
4899     function _recordIncomingTransaction(
4900         address _token,
4901         address _sender,
4902         uint256 _amount,
4903         string _reference
4904     )
4905         internal
4906     {
4907         _recordTransaction(
4908             true, // incoming transaction
4909             _token,
4910             _sender,
4911             _amount,
4912             NO_SCHEDULED_PAYMENT, // unrelated to any existing payment
4913             0, // and no payment executions
4914             _reference
4915         );
4916     }
4917 
4918     function _recordTransaction(
4919         bool _incoming,
4920         address _token,
4921         address _entity,
4922         uint256 _amount,
4923         uint256 _paymentId,
4924         uint64 _paymentExecutionNumber,
4925         string _reference
4926     )
4927         internal
4928     {
4929         uint64 periodId = _currentPeriodId();
4930         TokenStatement storage tokenStatement = periods[periodId].tokenStatement[_token];
4931         if (_incoming) {
4932             tokenStatement.income = tokenStatement.income.add(_amount);
4933         } else {
4934             tokenStatement.expenses = tokenStatement.expenses.add(_amount);
4935         }
4936 
4937         uint256 transactionId = transactionsNextIndex++;
4938 
4939         Transaction storage transaction = transactions[transactionId];
4940         transaction.token = _token;
4941         transaction.entity = _entity;
4942         transaction.isIncoming = _incoming;
4943         transaction.amount = _amount;
4944         transaction.paymentId = _paymentId;
4945         transaction.paymentExecutionNumber = _paymentExecutionNumber;
4946         transaction.date = getTimestamp64();
4947         transaction.periodId = periodId;
4948 
4949         Period storage period = periods[periodId];
4950         if (period.firstTransactionId == NO_TRANSACTION) {
4951             period.firstTransactionId = transactionId;
4952         }
4953 
4954         emit NewTransaction(transactionId, _incoming, _entity, _amount, _reference);
4955     }
4956 
4957     function _tryTransitionAccountingPeriod(uint64 _maxTransitions) internal returns (bool success) {
4958         Period storage currentPeriod = periods[_currentPeriodId()];
4959         uint64 timestamp = getTimestamp64();
4960 
4961         // Transition periods if necessary
4962         while (timestamp > currentPeriod.endTime) {
4963             if (_maxTransitions == 0) {
4964                 // Required number of transitions is over allowed number, return false indicating
4965                 // it didn't fully transition
4966                 return false;
4967             }
4968             // We're already protected from underflowing above
4969             _maxTransitions -= 1;
4970 
4971             // If there were any transactions in period, record which was the last
4972             // In case 0 transactions occured, first and last tx id will be 0
4973             if (currentPeriod.firstTransactionId != NO_TRANSACTION) {
4974                 currentPeriod.lastTransactionId = transactionsNextIndex.sub(1);
4975             }
4976 
4977             // New period starts at end time + 1
4978             currentPeriod = _newPeriod(currentPeriod.endTime.add(1));
4979         }
4980 
4981         return true;
4982     }
4983 
4984     function _canMakePayment(address _token, uint256 _amount) internal view returns (bool) {
4985         return _getRemainingBudget(_token) >= _amount && vault.balance(_token) >= _amount;
4986     }
4987 
4988     function _currentPeriodId() internal view returns (uint64) {
4989         // There is no way for this to overflow if protected by an initialization check
4990         return periodsLength - 1;
4991     }
4992 
4993     function _getRemainingBudget(address _token) internal view returns (uint256) {
4994         if (!settings.hasBudget[_token]) {
4995             return MAX_UINT256;
4996         }
4997 
4998         uint256 budget = settings.budgets[_token];
4999         uint256 spent = periods[_currentPeriodId()].tokenStatement[_token].expenses;
5000 
5001         // A budget decrease can cause the spent amount to be greater than period budget
5002         // If so, return 0 to not allow more spending during period
5003         if (spent >= budget) {
5004             return 0;
5005         }
5006 
5007         // We're already protected from the overflow above
5008         return budget - spent;
5009     }
5010 
5011     function _nextPaymentTime(uint256 _paymentId) internal view returns (uint64) {
5012         ScheduledPayment storage payment = scheduledPayments[_paymentId];
5013 
5014         if (payment.executions >= payment.maxExecutions) {
5015             return MAX_UINT64; // re-executes in some billions of years time... should not need to worry
5016         }
5017 
5018         // Split in multiple lines to circumvent linter warning
5019         uint64 increase = payment.executions.mul(payment.interval);
5020         uint64 nextPayment = payment.initialPaymentTime.add(increase);
5021         return nextPayment;
5022     }
5023 
5024     // Syntax sugar
5025 
5026     function _arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e, uint256 _f) internal pure returns (uint256[] r) {
5027         r = new uint256[](6);
5028         r[0] = uint256(_a);
5029         r[1] = uint256(_b);
5030         r[2] = _c;
5031         r[3] = _d;
5032         r[4] = _e;
5033         r[5] = _f;
5034     }
5035 
5036     // Mocked fns (overrided during testing)
5037     // Must be view for mocking purposes
5038 
5039     function getMaxPeriodTransitions() internal view returns (uint64) { return MAX_UINT64; }
5040 }
5041 
5042 // File: @aragon/os/contracts/apm/Repo.sol
5043 
5044 pragma solidity 0.4.24;
5045 
5046 
5047 
5048 /* solium-disable function-order */
5049 // Allow public initialize() to be first
5050 contract Repo is AragonApp {
5051     /* Hardcoded constants to save gas
5052     bytes32 public constant CREATE_VERSION_ROLE = keccak256("CREATE_VERSION_ROLE");
5053     */
5054     bytes32 public constant CREATE_VERSION_ROLE = 0x1f56cfecd3595a2e6cc1a7e6cb0b20df84cdbd92eff2fee554e70e4e45a9a7d8;
5055 
5056     string private constant ERROR_INVALID_BUMP = "REPO_INVALID_BUMP";
5057     string private constant ERROR_INVALID_VERSION = "REPO_INVALID_VERSION";
5058     string private constant ERROR_INEXISTENT_VERSION = "REPO_INEXISTENT_VERSION";
5059 
5060     struct Version {
5061         uint16[3] semanticVersion;
5062         address contractAddress;
5063         bytes contentURI;
5064     }
5065 
5066     uint256 internal versionsNextIndex;
5067     mapping (uint256 => Version) internal versions;
5068     mapping (bytes32 => uint256) internal versionIdForSemantic;
5069     mapping (address => uint256) internal latestVersionIdForContract;
5070 
5071     event NewVersion(uint256 versionId, uint16[3] semanticVersion);
5072 
5073     /**
5074     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
5075     * @notice Initialize this Repo
5076     */
5077     function initialize() public onlyInit {
5078         initialized();
5079         versionsNextIndex = 1;
5080     }
5081 
5082     /**
5083     * @notice Create new version with contract `_contractAddress` and content `@fromHex(_contentURI)`
5084     * @param _newSemanticVersion Semantic version for new repo version
5085     * @param _contractAddress address for smart contract logic for version (if set to 0, it uses last versions' contractAddress)
5086     * @param _contentURI External URI for fetching new version's content
5087     */
5088     function newVersion(
5089         uint16[3] _newSemanticVersion,
5090         address _contractAddress,
5091         bytes _contentURI
5092     ) public auth(CREATE_VERSION_ROLE)
5093     {
5094         address contractAddress = _contractAddress;
5095         uint256 lastVersionIndex = versionsNextIndex - 1;
5096 
5097         uint16[3] memory lastSematicVersion;
5098 
5099         if (lastVersionIndex > 0) {
5100             Version storage lastVersion = versions[lastVersionIndex];
5101             lastSematicVersion = lastVersion.semanticVersion;
5102 
5103             if (contractAddress == address(0)) {
5104                 contractAddress = lastVersion.contractAddress;
5105             }
5106             // Only allows smart contract change on major version bumps
5107             require(
5108                 lastVersion.contractAddress == contractAddress || _newSemanticVersion[0] > lastVersion.semanticVersion[0],
5109                 ERROR_INVALID_VERSION
5110             );
5111         }
5112 
5113         require(isValidBump(lastSematicVersion, _newSemanticVersion), ERROR_INVALID_BUMP);
5114 
5115         uint256 versionId = versionsNextIndex++;
5116         versions[versionId] = Version(_newSemanticVersion, contractAddress, _contentURI);
5117         versionIdForSemantic[semanticVersionHash(_newSemanticVersion)] = versionId;
5118         latestVersionIdForContract[contractAddress] = versionId;
5119 
5120         emit NewVersion(versionId, _newSemanticVersion);
5121     }
5122 
5123     function getLatest() public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
5124         return getByVersionId(versionsNextIndex - 1);
5125     }
5126 
5127     function getLatestForContractAddress(address _contractAddress)
5128         public
5129         view
5130         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
5131     {
5132         return getByVersionId(latestVersionIdForContract[_contractAddress]);
5133     }
5134 
5135     function getBySemanticVersion(uint16[3] _semanticVersion)
5136         public
5137         view
5138         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
5139     {
5140         return getByVersionId(versionIdForSemantic[semanticVersionHash(_semanticVersion)]);
5141     }
5142 
5143     function getByVersionId(uint _versionId) public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
5144         require(_versionId > 0 && _versionId < versionsNextIndex, ERROR_INEXISTENT_VERSION);
5145         Version storage version = versions[_versionId];
5146         return (version.semanticVersion, version.contractAddress, version.contentURI);
5147     }
5148 
5149     function getVersionsCount() public view returns (uint256) {
5150         return versionsNextIndex - 1;
5151     }
5152 
5153     function isValidBump(uint16[3] _oldVersion, uint16[3] _newVersion) public pure returns (bool) {
5154         bool hasBumped;
5155         uint i = 0;
5156         while (i < 3) {
5157             if (hasBumped) {
5158                 if (_newVersion[i] != 0) {
5159                     return false;
5160                 }
5161             } else if (_newVersion[i] != _oldVersion[i]) {
5162                 if (_oldVersion[i] > _newVersion[i] || _newVersion[i] - _oldVersion[i] != 1) {
5163                     return false;
5164                 }
5165                 hasBumped = true;
5166             }
5167             i++;
5168         }
5169         return hasBumped;
5170     }
5171 
5172     function semanticVersionHash(uint16[3] version) internal pure returns (bytes32) {
5173         return keccak256(abi.encodePacked(version[0], version[1], version[2]));
5174     }
5175 }
5176 
5177 // File: @aragon/os/contracts/lib/ens/AbstractENS.sol
5178 
5179 // See https://github.com/ensdomains/ens/blob/7e377df83f/contracts/AbstractENS.sol
5180 
5181 pragma solidity ^0.4.15;
5182 
5183 
5184 interface AbstractENS {
5185     function owner(bytes32 _node) public constant returns (address);
5186     function resolver(bytes32 _node) public constant returns (address);
5187     function ttl(bytes32 _node) public constant returns (uint64);
5188     function setOwner(bytes32 _node, address _owner) public;
5189     function setSubnodeOwner(bytes32 _node, bytes32 label, address _owner) public;
5190     function setResolver(bytes32 _node, address _resolver) public;
5191     function setTTL(bytes32 _node, uint64 _ttl) public;
5192 
5193     // Logged when the owner of a node assigns a new owner to a subnode.
5194     event NewOwner(bytes32 indexed _node, bytes32 indexed _label, address _owner);
5195 
5196     // Logged when the owner of a node transfers ownership to a new account.
5197     event Transfer(bytes32 indexed _node, address _owner);
5198 
5199     // Logged when the resolver for a node changes.
5200     event NewResolver(bytes32 indexed _node, address _resolver);
5201 
5202     // Logged when the TTL of a node changes
5203     event NewTTL(bytes32 indexed _node, uint64 _ttl);
5204 }
5205 
5206 // File: @aragon/os/contracts/lib/ens/ENS.sol
5207 
5208 // See https://github.com/ensdomains/ens/blob/7e377df83f/contracts/ENS.sol
5209 
5210 pragma solidity ^0.4.0;
5211 
5212 
5213 /**
5214  * The ENS registry contract.
5215  */
5216 contract ENS is AbstractENS {
5217     struct Record {
5218         address owner;
5219         address resolver;
5220         uint64 ttl;
5221     }
5222 
5223     mapping(bytes32=>Record) records;
5224 
5225     // Permits modifications only by the owner of the specified node.
5226     modifier only_owner(bytes32 node) {
5227         if (records[node].owner != msg.sender) throw;
5228         _;
5229     }
5230 
5231     /**
5232      * Constructs a new ENS registrar.
5233      */
5234     function ENS() public {
5235         records[0].owner = msg.sender;
5236     }
5237 
5238     /**
5239      * Returns the address that owns the specified node.
5240      */
5241     function owner(bytes32 node) public constant returns (address) {
5242         return records[node].owner;
5243     }
5244 
5245     /**
5246      * Returns the address of the resolver for the specified node.
5247      */
5248     function resolver(bytes32 node) public constant returns (address) {
5249         return records[node].resolver;
5250     }
5251 
5252     /**
5253      * Returns the TTL of a node, and any records associated with it.
5254      */
5255     function ttl(bytes32 node) public constant returns (uint64) {
5256         return records[node].ttl;
5257     }
5258 
5259     /**
5260      * Transfers ownership of a node to a new address. May only be called by the current
5261      * owner of the node.
5262      * @param node The node to transfer ownership of.
5263      * @param owner The address of the new owner.
5264      */
5265     function setOwner(bytes32 node, address owner) only_owner(node) public {
5266         Transfer(node, owner);
5267         records[node].owner = owner;
5268     }
5269 
5270     /**
5271      * Transfers ownership of a subnode keccak256(node, label) to a new address. May only be
5272      * called by the owner of the parent node.
5273      * @param node The parent node.
5274      * @param label The hash of the label specifying the subnode.
5275      * @param owner The address of the new owner.
5276      */
5277     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) public {
5278         var subnode = keccak256(node, label);
5279         NewOwner(node, label, owner);
5280         records[subnode].owner = owner;
5281     }
5282 
5283     /**
5284      * Sets the resolver address for the specified node.
5285      * @param node The node to update.
5286      * @param resolver The address of the resolver.
5287      */
5288     function setResolver(bytes32 node, address resolver) only_owner(node) public {
5289         NewResolver(node, resolver);
5290         records[node].resolver = resolver;
5291     }
5292 
5293     /**
5294      * Sets the TTL for the specified node.
5295      * @param node The node to update.
5296      * @param ttl The TTL in seconds.
5297      */
5298     function setTTL(bytes32 node, uint64 ttl) only_owner(node) public {
5299         NewTTL(node, ttl);
5300         records[node].ttl = ttl;
5301     }
5302 }
5303 
5304 // File: @aragon/os/contracts/lib/ens/PublicResolver.sol
5305 
5306 // See https://github.com/ensdomains/ens/blob/7e377df83f/contracts/PublicResolver.sol
5307 
5308 pragma solidity ^0.4.0;
5309 
5310 
5311 /**
5312  * A simple resolver anyone can use; only allows the owner of a node to set its
5313  * address.
5314  */
5315 contract PublicResolver {
5316     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
5317     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
5318     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
5319     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
5320     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
5321     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
5322     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
5323 
5324     event AddrChanged(bytes32 indexed node, address a);
5325     event ContentChanged(bytes32 indexed node, bytes32 hash);
5326     event NameChanged(bytes32 indexed node, string name);
5327     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
5328     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
5329     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
5330 
5331     struct PublicKey {
5332         bytes32 x;
5333         bytes32 y;
5334     }
5335 
5336     struct Record {
5337         address addr;
5338         bytes32 content;
5339         string name;
5340         PublicKey pubkey;
5341         mapping(string=>string) text;
5342         mapping(uint256=>bytes) abis;
5343     }
5344 
5345     AbstractENS ens;
5346     mapping(bytes32=>Record) records;
5347 
5348     modifier only_owner(bytes32 node) {
5349         if (ens.owner(node) != msg.sender) throw;
5350         _;
5351     }
5352 
5353     /**
5354      * Constructor.
5355      * @param ensAddr The ENS registrar contract.
5356      */
5357     function PublicResolver(AbstractENS ensAddr) public {
5358         ens = ensAddr;
5359     }
5360 
5361     /**
5362      * Returns true if the resolver implements the interface specified by the provided hash.
5363      * @param interfaceID The ID of the interface to check for.
5364      * @return True if the contract implements the requested interface.
5365      */
5366     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
5367         return interfaceID == ADDR_INTERFACE_ID ||
5368                interfaceID == CONTENT_INTERFACE_ID ||
5369                interfaceID == NAME_INTERFACE_ID ||
5370                interfaceID == ABI_INTERFACE_ID ||
5371                interfaceID == PUBKEY_INTERFACE_ID ||
5372                interfaceID == TEXT_INTERFACE_ID ||
5373                interfaceID == INTERFACE_META_ID;
5374     }
5375 
5376     /**
5377      * Returns the address associated with an ENS node.
5378      * @param node The ENS node to query.
5379      * @return The associated address.
5380      */
5381     function addr(bytes32 node) public constant returns (address ret) {
5382         ret = records[node].addr;
5383     }
5384 
5385     /**
5386      * Sets the address associated with an ENS node.
5387      * May only be called by the owner of that node in the ENS registry.
5388      * @param node The node to update.
5389      * @param addr The address to set.
5390      */
5391     function setAddr(bytes32 node, address addr) only_owner(node) public {
5392         records[node].addr = addr;
5393         AddrChanged(node, addr);
5394     }
5395 
5396     /**
5397      * Returns the content hash associated with an ENS node.
5398      * Note that this resource type is not standardized, and will likely change
5399      * in future to a resource type based on multihash.
5400      * @param node The ENS node to query.
5401      * @return The associated content hash.
5402      */
5403     function content(bytes32 node) public constant returns (bytes32 ret) {
5404         ret = records[node].content;
5405     }
5406 
5407     /**
5408      * Sets the content hash associated with an ENS node.
5409      * May only be called by the owner of that node in the ENS registry.
5410      * Note that this resource type is not standardized, and will likely change
5411      * in future to a resource type based on multihash.
5412      * @param node The node to update.
5413      * @param hash The content hash to set
5414      */
5415     function setContent(bytes32 node, bytes32 hash) only_owner(node) public {
5416         records[node].content = hash;
5417         ContentChanged(node, hash);
5418     }
5419 
5420     /**
5421      * Returns the name associated with an ENS node, for reverse records.
5422      * Defined in EIP181.
5423      * @param node The ENS node to query.
5424      * @return The associated name.
5425      */
5426     function name(bytes32 node) public constant returns (string ret) {
5427         ret = records[node].name;
5428     }
5429 
5430     /**
5431      * Sets the name associated with an ENS node, for reverse records.
5432      * May only be called by the owner of that node in the ENS registry.
5433      * @param node The node to update.
5434      * @param name The name to set.
5435      */
5436     function setName(bytes32 node, string name) only_owner(node) public {
5437         records[node].name = name;
5438         NameChanged(node, name);
5439     }
5440 
5441     /**
5442      * Returns the ABI associated with an ENS node.
5443      * Defined in EIP205.
5444      * @param node The ENS node to query
5445      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
5446      * @return contentType The content type of the return value
5447      * @return data The ABI data
5448      */
5449     function ABI(bytes32 node, uint256 contentTypes) public constant returns (uint256 contentType, bytes data) {
5450         var record = records[node];
5451         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
5452             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
5453                 data = record.abis[contentType];
5454                 return;
5455             }
5456         }
5457         contentType = 0;
5458     }
5459 
5460     /**
5461      * Sets the ABI associated with an ENS node.
5462      * Nodes may have one ABI of each content type. To remove an ABI, set it to
5463      * the empty string.
5464      * @param node The node to update.
5465      * @param contentType The content type of the ABI
5466      * @param data The ABI data.
5467      */
5468     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) public {
5469         // Content types must be powers of 2
5470         if (((contentType - 1) & contentType) != 0) throw;
5471 
5472         records[node].abis[contentType] = data;
5473         ABIChanged(node, contentType);
5474     }
5475 
5476     /**
5477      * Returns the SECP256k1 public key associated with an ENS node.
5478      * Defined in EIP 619.
5479      * @param node The ENS node to query
5480      * @return x, y the X and Y coordinates of the curve point for the public key.
5481      */
5482     function pubkey(bytes32 node) public constant returns (bytes32 x, bytes32 y) {
5483         return (records[node].pubkey.x, records[node].pubkey.y);
5484     }
5485 
5486     /**
5487      * Sets the SECP256k1 public key associated with an ENS node.
5488      * @param node The ENS node to query
5489      * @param x the X coordinate of the curve point for the public key.
5490      * @param y the Y coordinate of the curve point for the public key.
5491      */
5492     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) public {
5493         records[node].pubkey = PublicKey(x, y);
5494         PubkeyChanged(node, x, y);
5495     }
5496 
5497     /**
5498      * Returns the text data associated with an ENS node and key.
5499      * @param node The ENS node to query.
5500      * @param key The text data key to query.
5501      * @return The associated text data.
5502      */
5503     function text(bytes32 node, string key) public constant returns (string ret) {
5504         ret = records[node].text[key];
5505     }
5506 
5507     /**
5508      * Sets the text data associated with an ENS node and key.
5509      * May only be called by the owner of that node in the ENS registry.
5510      * @param node The node to update.
5511      * @param key The key to set.
5512      * @param value The text data value to set.
5513      */
5514     function setText(bytes32 node, string key, string value) only_owner(node) public {
5515         records[node].text[key] = value;
5516         TextChanged(node, key, key);
5517     }
5518 }
5519 
5520 // File: @aragon/kits-base/contracts/KitBase.sol
5521 
5522 pragma solidity 0.4.24;
5523 
5524 
5525 
5526 
5527 
5528 
5529 
5530 contract KitBase is EVMScriptRegistryConstants {
5531     ENS public ens;
5532     DAOFactory public fac;
5533 
5534     event DeployInstance(address dao);
5535     event InstalledApp(address appProxy, bytes32 appId);
5536 
5537     constructor (DAOFactory _fac, ENS _ens) public {
5538         fac = _fac;
5539         ens = _ens;
5540     }
5541 
5542     function latestVersionAppBase(bytes32 appId) public view returns (address base) {
5543         Repo repo = Repo(PublicResolver(ens.resolver(appId)).addr(appId));
5544         (,base,) = repo.getLatest();
5545 
5546         return base;
5547     }
5548 
5549     function cleanupDAOPermissions(Kernel dao, ACL acl, address root) internal {
5550         // Kernel permission clean up
5551         cleanupPermission(acl, root, dao, dao.APP_MANAGER_ROLE());
5552 
5553         // ACL permission clean up
5554         cleanupPermission(acl, root, acl, acl.CREATE_PERMISSIONS_ROLE());
5555     }
5556 
5557     function cleanupPermission(ACL acl, address root, address app, bytes32 permission) internal {
5558         acl.grantPermission(root, app, permission);
5559         acl.revokePermission(this, app, permission);
5560         acl.setPermissionManager(root, app, permission);
5561     }
5562 }
5563 
5564 // File: @aragon/kits-beta-base/contracts/BetaKitBase.sol
5565 
5566 pragma solidity 0.4.24;
5567 
5568 
5569 
5570 
5571 
5572 
5573 
5574 
5575 
5576 
5577 
5578 
5579 
5580 contract BetaKitBase is KitBase, IsContract {
5581     MiniMeTokenFactory public minimeFac;
5582     IFIFSResolvingRegistrar public aragonID;
5583     bytes32[4] public appIds;
5584 
5585     mapping (address => address) tokenCache;
5586 
5587     // ensure alphabetic order
5588     enum Apps { Finance, TokenManager, Vault, Voting }
5589 
5590     event DeployToken(address token, address indexed cacheOwner);
5591     event DeployInstance(address dao, address indexed token);
5592 
5593     constructor(
5594         DAOFactory _fac,
5595         ENS _ens,
5596         MiniMeTokenFactory _minimeFac,
5597         IFIFSResolvingRegistrar _aragonID,
5598         bytes32[4] _appIds
5599     )
5600         KitBase(_fac, _ens)
5601         public
5602     {
5603         require(isContract(address(_fac.regFactory())));
5604 
5605         minimeFac = _minimeFac;
5606         aragonID = _aragonID;
5607         appIds = _appIds;
5608     }
5609 
5610     function createDAO(
5611         string aragonId,
5612         MiniMeToken token,
5613         address[] holders,
5614         uint256[] stakes,
5615         uint256 _maxTokens
5616     )
5617         internal
5618         returns (
5619             Kernel dao,
5620             ACL acl,
5621             Finance finance,
5622             TokenManager tokenManager,
5623             Vault vault,
5624             Voting voting
5625         )
5626     {
5627         require(holders.length == stakes.length);
5628 
5629         dao = fac.newDAO(this);
5630 
5631         acl = ACL(dao.acl());
5632 
5633         acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);
5634 
5635         voting = Voting(
5636             dao.newAppInstance(
5637                 appIds[uint8(Apps.Voting)],
5638                 latestVersionAppBase(appIds[uint8(Apps.Voting)])
5639             )
5640         );
5641         emit InstalledApp(voting, appIds[uint8(Apps.Voting)]);
5642 
5643         vault = Vault(
5644             dao.newAppInstance(
5645                 appIds[uint8(Apps.Vault)],
5646                 latestVersionAppBase(appIds[uint8(Apps.Vault)]),
5647                 new bytes(0),
5648                 true
5649             )
5650         );
5651         emit InstalledApp(vault, appIds[uint8(Apps.Vault)]);
5652 
5653         finance = Finance(
5654             dao.newAppInstance(
5655                 appIds[uint8(Apps.Finance)],
5656                 latestVersionAppBase(appIds[uint8(Apps.Finance)])
5657             )
5658         );
5659         emit InstalledApp(finance, appIds[uint8(Apps.Finance)]);
5660 
5661         tokenManager = TokenManager(
5662             dao.newAppInstance(
5663                 appIds[uint8(Apps.TokenManager)],
5664                 latestVersionAppBase(appIds[uint8(Apps.TokenManager)])
5665             )
5666         );
5667         emit InstalledApp(tokenManager, appIds[uint8(Apps.TokenManager)]);
5668 
5669         // Required for initializing the Token Manager
5670         token.changeController(tokenManager);
5671 
5672         // permissions
5673         acl.createPermission(tokenManager, voting, voting.CREATE_VOTES_ROLE(), voting);
5674         acl.createPermission(voting, voting, voting.MODIFY_QUORUM_ROLE(), voting);
5675         acl.createPermission(finance, vault, vault.TRANSFER_ROLE(), voting);
5676         acl.createPermission(voting, finance, finance.CREATE_PAYMENTS_ROLE(), voting);
5677         acl.createPermission(voting, finance, finance.EXECUTE_PAYMENTS_ROLE(), voting);
5678         acl.createPermission(voting, finance, finance.MANAGE_PAYMENTS_ROLE(), voting);
5679         acl.createPermission(voting, tokenManager, tokenManager.ASSIGN_ROLE(), voting);
5680         acl.createPermission(voting, tokenManager, tokenManager.REVOKE_VESTINGS_ROLE(), voting);
5681 
5682         // App inits
5683         vault.initialize();
5684         finance.initialize(vault, 30 days);
5685         tokenManager.initialize(token, _maxTokens > 1, _maxTokens);
5686 
5687         // Set up the token stakes
5688         acl.createPermission(this, tokenManager, tokenManager.MINT_ROLE(), this);
5689 
5690         for (uint256 i = 0; i < holders.length; i++) {
5691             tokenManager.mint(holders[i], stakes[i]);
5692         }
5693 
5694         // EVMScriptRegistry permissions
5695         EVMScriptRegistry reg = EVMScriptRegistry(acl.getEVMScriptRegistry());
5696         acl.createPermission(voting, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE(), voting);
5697         acl.createPermission(voting, reg, reg.REGISTRY_MANAGER_ROLE(), voting);
5698 
5699         // clean-up
5700         cleanupPermission(acl, voting, dao, dao.APP_MANAGER_ROLE());
5701         cleanupPermission(acl, voting, tokenManager, tokenManager.MINT_ROLE());
5702 
5703         registerAragonID(aragonId, dao);
5704         emit DeployInstance(dao, token);
5705 
5706         return (dao, acl, finance, tokenManager, vault, voting);
5707     }
5708 
5709     function cacheToken(MiniMeToken token, address owner) internal {
5710         tokenCache[owner] = token;
5711         emit DeployToken(token, owner);
5712     }
5713 
5714     function popTokenCache(address owner) internal returns (MiniMeToken) {
5715         require(tokenCache[owner] != address(0));
5716         MiniMeToken token = MiniMeToken(tokenCache[owner]);
5717         delete tokenCache[owner];
5718 
5719         return token;
5720     }
5721 
5722     function registerAragonID(string name, address owner) internal {
5723         aragonID.register(keccak256(abi.encodePacked(name)), owner);
5724     }
5725 }
5726 
5727 // File: contracts/DemocracyKit.sol
5728 
5729 pragma solidity 0.4.24;
5730 
5731 
5732 
5733 contract DemocracyKit is BetaKitBase {
5734     constructor(
5735         DAOFactory _fac,
5736         ENS _ens,
5737         MiniMeTokenFactory _minimeFac,
5738         IFIFSResolvingRegistrar _aragonID,
5739         bytes32[4] _appIds
5740     )
5741         BetaKitBase(_fac, _ens, _minimeFac, _aragonID, _appIds)
5742         public
5743     {
5744         // solium-disable-previous-line no-empty-blocks
5745     }
5746 
5747     function newTokenAndInstance(
5748         string tokenName,
5749         string tokenSymbol,
5750         string aragonId,
5751         address[] holders,
5752         uint256[] tokens,
5753         uint64 supportNeeded,
5754         uint64 minAcceptanceQuorum,
5755         uint64 voteDuration
5756     ) public
5757     {
5758         newToken(tokenName, tokenSymbol);
5759         newInstance(
5760             aragonId,
5761             holders,
5762             tokens,
5763             supportNeeded,
5764             minAcceptanceQuorum,
5765             voteDuration
5766         );
5767     }
5768 
5769     function newToken(string tokenName, string tokenSymbol) public returns (MiniMeToken token) {
5770         token = minimeFac.createCloneToken(
5771             MiniMeToken(address(0)),
5772             0,
5773             tokenName,
5774             18,
5775             tokenSymbol,
5776             true
5777         );
5778         cacheToken(token, msg.sender);
5779     }
5780 
5781     function newInstance(
5782         string aragonId,
5783         address[] holders,
5784         uint256[] tokens,
5785         uint64 supportNeeded,
5786         uint64 minAcceptanceQuorum,
5787         uint64 voteDuration
5788     )
5789         public
5790     {
5791         require(voteDuration > 0); // TODO: remove it once we add it to Voting app
5792 
5793         MiniMeToken token = popTokenCache(msg.sender);
5794         Kernel dao;
5795         ACL acl;
5796         Voting voting;
5797         (dao, acl, , , , voting) = createDAO(
5798             aragonId,
5799             token,
5800             holders,
5801             tokens,
5802             uint256(-1)
5803         );
5804 
5805         voting.initialize(
5806             token,
5807             supportNeeded,
5808             minAcceptanceQuorum,
5809             voteDuration
5810         );
5811 
5812         // burn support modification permission
5813         acl.createBurnedPermission(voting, voting.MODIFY_SUPPORT_ROLE());
5814 
5815         cleanupPermission(acl, voting, acl, acl.CREATE_PERMISSIONS_ROLE());
5816     }
5817 }