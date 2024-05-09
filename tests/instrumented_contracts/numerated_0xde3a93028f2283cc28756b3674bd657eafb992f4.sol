1 // File: @aragon/os/contracts/common/UnstructuredStorage.sol
2 
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
43 
44 // File: @aragon/os/contracts/acl/IACL.sol
45 
46 /*
47  * SPDX-License-Identitifer:    MIT
48  */
49 
50 pragma solidity ^0.4.24;
51 
52 
53 interface IACL {
54     function initialize(address permissionsCreator) external;
55 
56     // TODO: this should be external
57     // See https://github.com/ethereum/solidity/issues/4832
58     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
59 }
60 
61 // File: @aragon/os/contracts/common/IVaultRecoverable.sol
62 
63 /*
64  * SPDX-License-Identitifer:    MIT
65  */
66 
67 pragma solidity ^0.4.24;
68 
69 
70 interface IVaultRecoverable {
71     event RecoverToVault(address indexed vault, address indexed token, uint256 amount);
72 
73     function transferToVault(address token) external;
74 
75     function allowRecoverability(address token) external view returns (bool);
76     function getRecoveryVault() external view returns (address);
77 }
78 
79 // File: @aragon/os/contracts/kernel/IKernel.sol
80 
81 /*
82  * SPDX-License-Identitifer:    MIT
83  */
84 
85 pragma solidity ^0.4.24;
86 
87 
88 
89 
90 interface IKernelEvents {
91     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
92 }
93 
94 
95 // This should be an interface, but interfaces can't inherit yet :(
96 contract IKernel is IKernelEvents, IVaultRecoverable {
97     function acl() public view returns (IACL);
98     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
99 
100     function setApp(bytes32 namespace, bytes32 appId, address app) public;
101     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
102 }
103 
104 // File: @aragon/os/contracts/apps/AppStorage.sol
105 
106 /*
107  * SPDX-License-Identitifer:    MIT
108  */
109 
110 pragma solidity ^0.4.24;
111 
112 
113 
114 
115 contract AppStorage {
116     using UnstructuredStorage for bytes32;
117 
118     /* Hardcoded constants to save gas
119     bytes32 internal constant KERNEL_POSITION = keccak256("aragonOS.appStorage.kernel");
120     bytes32 internal constant APP_ID_POSITION = keccak256("aragonOS.appStorage.appId");
121     */
122     bytes32 internal constant KERNEL_POSITION = 0x4172f0f7d2289153072b0a6ca36959e0cbe2efc3afe50fc81636caa96338137b;
123     bytes32 internal constant APP_ID_POSITION = 0xd625496217aa6a3453eecb9c3489dc5a53e6c67b444329ea2b2cbc9ff547639b;
124 
125     function kernel() public view returns (IKernel) {
126         return IKernel(KERNEL_POSITION.getStorageAddress());
127     }
128 
129     function appId() public view returns (bytes32) {
130         return APP_ID_POSITION.getStorageBytes32();
131     }
132 
133     function setKernel(IKernel _kernel) internal {
134         KERNEL_POSITION.setStorageAddress(address(_kernel));
135     }
136 
137     function setAppId(bytes32 _appId) internal {
138         APP_ID_POSITION.setStorageBytes32(_appId);
139     }
140 }
141 
142 // File: @aragon/os/contracts/acl/ACLSyntaxSugar.sol
143 
144 /*
145  * SPDX-License-Identitifer:    MIT
146  */
147 
148 pragma solidity ^0.4.24;
149 
150 
151 contract ACLSyntaxSugar {
152     function arr() internal pure returns (uint256[]) {
153         return new uint256[](0);
154     }
155 
156     function arr(bytes32 _a) internal pure returns (uint256[] r) {
157         return arr(uint256(_a));
158     }
159 
160     function arr(bytes32 _a, bytes32 _b) internal pure returns (uint256[] r) {
161         return arr(uint256(_a), uint256(_b));
162     }
163 
164     function arr(address _a) internal pure returns (uint256[] r) {
165         return arr(uint256(_a));
166     }
167 
168     function arr(address _a, address _b) internal pure returns (uint256[] r) {
169         return arr(uint256(_a), uint256(_b));
170     }
171 
172     function arr(address _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
173         return arr(uint256(_a), _b, _c);
174     }
175 
176     function arr(address _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
177         return arr(uint256(_a), _b, _c, _d);
178     }
179 
180     function arr(address _a, uint256 _b) internal pure returns (uint256[] r) {
181         return arr(uint256(_a), uint256(_b));
182     }
183 
184     function arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
185         return arr(uint256(_a), uint256(_b), _c, _d, _e);
186     }
187 
188     function arr(address _a, address _b, address _c) internal pure returns (uint256[] r) {
189         return arr(uint256(_a), uint256(_b), uint256(_c));
190     }
191 
192     function arr(address _a, address _b, uint256 _c) internal pure returns (uint256[] r) {
193         return arr(uint256(_a), uint256(_b), uint256(_c));
194     }
195 
196     function arr(uint256 _a) internal pure returns (uint256[] r) {
197         r = new uint256[](1);
198         r[0] = _a;
199     }
200 
201     function arr(uint256 _a, uint256 _b) internal pure returns (uint256[] r) {
202         r = new uint256[](2);
203         r[0] = _a;
204         r[1] = _b;
205     }
206 
207     function arr(uint256 _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
208         r = new uint256[](3);
209         r[0] = _a;
210         r[1] = _b;
211         r[2] = _c;
212     }
213 
214     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
215         r = new uint256[](4);
216         r[0] = _a;
217         r[1] = _b;
218         r[2] = _c;
219         r[3] = _d;
220     }
221 
222     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
223         r = new uint256[](5);
224         r[0] = _a;
225         r[1] = _b;
226         r[2] = _c;
227         r[3] = _d;
228         r[4] = _e;
229     }
230 }
231 
232 
233 contract ACLHelpers {
234     function decodeParamOp(uint256 _x) internal pure returns (uint8 b) {
235         return uint8(_x >> (8 * 30));
236     }
237 
238     function decodeParamId(uint256 _x) internal pure returns (uint8 b) {
239         return uint8(_x >> (8 * 31));
240     }
241 
242     function decodeParamsList(uint256 _x) internal pure returns (uint32 a, uint32 b, uint32 c) {
243         a = uint32(_x);
244         b = uint32(_x >> (8 * 4));
245         c = uint32(_x >> (8 * 8));
246     }
247 }
248 
249 // File: @aragon/os/contracts/common/Uint256Helpers.sol
250 
251 pragma solidity ^0.4.24;
252 
253 
254 library Uint256Helpers {
255     uint256 private constant MAX_UINT64 = uint64(-1);
256 
257     string private constant ERROR_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
258 
259     function toUint64(uint256 a) internal pure returns (uint64) {
260         require(a <= MAX_UINT64, ERROR_NUMBER_TOO_BIG);
261         return uint64(a);
262     }
263 }
264 
265 // File: @aragon/os/contracts/common/TimeHelpers.sol
266 
267 /*
268  * SPDX-License-Identitifer:    MIT
269  */
270 
271 pragma solidity ^0.4.24;
272 
273 
274 
275 contract TimeHelpers {
276     using Uint256Helpers for uint256;
277 
278     /**
279     * @dev Returns the current block number.
280     *      Using a function rather than `block.number` allows us to easily mock the block number in
281     *      tests.
282     */
283     function getBlockNumber() internal view returns (uint256) {
284         return block.number;
285     }
286 
287     /**
288     * @dev Returns the current block number, converted to uint64.
289     *      Using a function rather than `block.number` allows us to easily mock the block number in
290     *      tests.
291     */
292     function getBlockNumber64() internal view returns (uint64) {
293         return getBlockNumber().toUint64();
294     }
295 
296     /**
297     * @dev Returns the current timestamp.
298     *      Using a function rather than `block.timestamp` allows us to easily mock it in
299     *      tests.
300     */
301     function getTimestamp() internal view returns (uint256) {
302         return block.timestamp; // solium-disable-line security/no-block-members
303     }
304 
305     /**
306     * @dev Returns the current timestamp, converted to uint64.
307     *      Using a function rather than `block.timestamp` allows us to easily mock it in
308     *      tests.
309     */
310     function getTimestamp64() internal view returns (uint64) {
311         return getTimestamp().toUint64();
312     }
313 }
314 
315 // File: @aragon/os/contracts/common/Initializable.sol
316 
317 /*
318  * SPDX-License-Identitifer:    MIT
319  */
320 
321 pragma solidity ^0.4.24;
322 
323 
324 
325 
326 contract Initializable is TimeHelpers {
327     using UnstructuredStorage for bytes32;
328 
329     // keccak256("aragonOS.initializable.initializationBlock")
330     bytes32 internal constant INITIALIZATION_BLOCK_POSITION = 0xebb05b386a8d34882b8711d156f463690983dc47815980fb82aeeff1aa43579e;
331 
332     string private constant ERROR_ALREADY_INITIALIZED = "INIT_ALREADY_INITIALIZED";
333     string private constant ERROR_NOT_INITIALIZED = "INIT_NOT_INITIALIZED";
334 
335     modifier onlyInit {
336         require(getInitializationBlock() == 0, ERROR_ALREADY_INITIALIZED);
337         _;
338     }
339 
340     modifier isInitialized {
341         require(hasInitialized(), ERROR_NOT_INITIALIZED);
342         _;
343     }
344 
345     /**
346     * @return Block number in which the contract was initialized
347     */
348     function getInitializationBlock() public view returns (uint256) {
349         return INITIALIZATION_BLOCK_POSITION.getStorageUint256();
350     }
351 
352     /**
353     * @return Whether the contract has been initialized by the time of the current block
354     */
355     function hasInitialized() public view returns (bool) {
356         uint256 initializationBlock = getInitializationBlock();
357         return initializationBlock != 0 && getBlockNumber() >= initializationBlock;
358     }
359 
360     /**
361     * @dev Function to be called by top level contract after initialization has finished.
362     */
363     function initialized() internal onlyInit {
364         INITIALIZATION_BLOCK_POSITION.setStorageUint256(getBlockNumber());
365     }
366 
367     /**
368     * @dev Function to be called by top level contract after initialization to enable the contract
369     *      at a future block number rather than immediately.
370     */
371     function initializedAt(uint256 _blockNumber) internal onlyInit {
372         INITIALIZATION_BLOCK_POSITION.setStorageUint256(_blockNumber);
373     }
374 }
375 
376 // File: @aragon/os/contracts/common/Petrifiable.sol
377 
378 /*
379  * SPDX-License-Identitifer:    MIT
380  */
381 
382 pragma solidity ^0.4.24;
383 
384 
385 
386 contract Petrifiable is Initializable {
387     // Use block UINT256_MAX (which should be never) as the initializable date
388     uint256 internal constant PETRIFIED_BLOCK = uint256(-1);
389 
390     function isPetrified() public view returns (bool) {
391         return getInitializationBlock() == PETRIFIED_BLOCK;
392     }
393 
394     /**
395     * @dev Function to be called by top level contract to prevent being initialized.
396     *      Useful for freezing base contracts when they're used behind proxies.
397     */
398     function petrify() internal onlyInit {
399         initializedAt(PETRIFIED_BLOCK);
400     }
401 }
402 
403 // File: @aragon/os/contracts/common/Autopetrified.sol
404 
405 /*
406  * SPDX-License-Identitifer:    MIT
407  */
408 
409 pragma solidity ^0.4.24;
410 
411 
412 
413 contract Autopetrified is Petrifiable {
414     constructor() public {
415         // Immediately petrify base (non-proxy) instances of inherited contracts on deploy.
416         // This renders them uninitializable (and unusable without a proxy).
417         petrify();
418     }
419 }
420 
421 // File: @aragon/os/contracts/common/ConversionHelpers.sol
422 
423 pragma solidity ^0.4.24;
424 
425 
426 library ConversionHelpers {
427     string private constant ERROR_IMPROPER_LENGTH = "CONVERSION_IMPROPER_LENGTH";
428 
429     function dangerouslyCastUintArrayToBytes(uint256[] memory _input) internal pure returns (bytes memory output) {
430         // Force cast the uint256[] into a bytes array, by overwriting its length
431         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
432         // with the input and a new length. The input becomes invalid from this point forward.
433         uint256 byteLength = _input.length * 32;
434         assembly {
435             output := _input
436             mstore(output, byteLength)
437         }
438     }
439 
440     function dangerouslyCastBytesToUintArray(bytes memory _input) internal pure returns (uint256[] memory output) {
441         // Force cast the bytes array into a uint256[], by overwriting its length
442         // Note that the uint256[] doesn't need to be initialized as we immediately overwrite it
443         // with the input and a new length. The input becomes invalid from this point forward.
444         uint256 intsLength = _input.length / 32;
445         require(_input.length == intsLength * 32, ERROR_IMPROPER_LENGTH);
446 
447         assembly {
448             output := _input
449             mstore(output, intsLength)
450         }
451     }
452 }
453 
454 // File: @aragon/os/contracts/common/ReentrancyGuard.sol
455 
456 /*
457  * SPDX-License-Identitifer:    MIT
458  */
459 
460 pragma solidity ^0.4.24;
461 
462 
463 
464 contract ReentrancyGuard {
465     using UnstructuredStorage for bytes32;
466 
467     /* Hardcoded constants to save gas
468     bytes32 internal constant REENTRANCY_MUTEX_POSITION = keccak256("aragonOS.reentrancyGuard.mutex");
469     */
470     bytes32 private constant REENTRANCY_MUTEX_POSITION = 0xe855346402235fdd185c890e68d2c4ecad599b88587635ee285bce2fda58dacb;
471 
472     string private constant ERROR_REENTRANT = "REENTRANCY_REENTRANT_CALL";
473 
474     modifier nonReentrant() {
475         // Ensure mutex is unlocked
476         require(!REENTRANCY_MUTEX_POSITION.getStorageBool(), ERROR_REENTRANT);
477 
478         // Lock mutex before function call
479         REENTRANCY_MUTEX_POSITION.setStorageBool(true);
480 
481         // Perform function call
482         _;
483 
484         // Unlock mutex after function call
485         REENTRANCY_MUTEX_POSITION.setStorageBool(false);
486     }
487 }
488 
489 // File: @aragon/os/contracts/lib/token/ERC20.sol
490 
491 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/a9f910d34f0ab33a1ae5e714f69f9596a02b4d91/contracts/token/ERC20/ERC20.sol
492 
493 pragma solidity ^0.4.24;
494 
495 
496 /**
497  * @title ERC20 interface
498  * @dev see https://github.com/ethereum/EIPs/issues/20
499  */
500 contract ERC20 {
501     function totalSupply() public view returns (uint256);
502 
503     function balanceOf(address _who) public view returns (uint256);
504 
505     function allowance(address _owner, address _spender)
506         public view returns (uint256);
507 
508     function transfer(address _to, uint256 _value) public returns (bool);
509 
510     function approve(address _spender, uint256 _value)
511         public returns (bool);
512 
513     function transferFrom(address _from, address _to, uint256 _value)
514         public returns (bool);
515 
516     event Transfer(
517         address indexed from,
518         address indexed to,
519         uint256 value
520     );
521 
522     event Approval(
523         address indexed owner,
524         address indexed spender,
525         uint256 value
526     );
527 }
528 
529 // File: @aragon/os/contracts/common/EtherTokenConstant.sol
530 
531 /*
532  * SPDX-License-Identitifer:    MIT
533  */
534 
535 pragma solidity ^0.4.24;
536 
537 
538 // aragonOS and aragon-apps rely on address(0) to denote native ETH, in
539 // contracts where both tokens and ETH are accepted
540 contract EtherTokenConstant {
541     address internal constant ETH = address(0);
542 }
543 
544 // File: @aragon/os/contracts/common/IsContract.sol
545 
546 /*
547  * SPDX-License-Identitifer:    MIT
548  */
549 
550 pragma solidity ^0.4.24;
551 
552 
553 contract IsContract {
554     /*
555     * NOTE: this should NEVER be used for authentication
556     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
557     *
558     * This is only intended to be used as a sanity check that an address is actually a contract,
559     * RATHER THAN an address not being a contract.
560     */
561     function isContract(address _target) internal view returns (bool) {
562         if (_target == address(0)) {
563             return false;
564         }
565 
566         uint256 size;
567         assembly { size := extcodesize(_target) }
568         return size > 0;
569     }
570 }
571 
572 // File: @aragon/os/contracts/common/SafeERC20.sol
573 
574 // Inspired by AdEx (https://github.com/AdExNetwork/adex-protocol-eth/blob/b9df617829661a7518ee10f4cb6c4108659dd6d5/contracts/libs/SafeERC20.sol)
575 // and 0x (https://github.com/0xProject/0x-monorepo/blob/737d1dc54d72872e24abce5a1dbe1b66d35fa21a/contracts/protocol/contracts/protocol/AssetProxy/ERC20Proxy.sol#L143)
576 
577 pragma solidity ^0.4.24;
578 
579 
580 
581 library SafeERC20 {
582     // Before 0.5, solidity has a mismatch between `address.transfer()` and `token.transfer()`:
583     // https://github.com/ethereum/solidity/issues/3544
584     bytes4 private constant TRANSFER_SELECTOR = 0xa9059cbb;
585 
586     string private constant ERROR_TOKEN_BALANCE_REVERTED = "SAFE_ERC_20_BALANCE_REVERTED";
587     string private constant ERROR_TOKEN_ALLOWANCE_REVERTED = "SAFE_ERC_20_ALLOWANCE_REVERTED";
588 
589     function invokeAndCheckSuccess(address _addr, bytes memory _calldata)
590         private
591         returns (bool)
592     {
593         bool ret;
594         assembly {
595             let ptr := mload(0x40)    // free memory pointer
596 
597             let success := call(
598                 gas,                  // forward all gas
599                 _addr,                // address
600                 0,                    // no value
601                 add(_calldata, 0x20), // calldata start
602                 mload(_calldata),     // calldata length
603                 ptr,                  // write output over free memory
604                 0x20                  // uint256 return
605             )
606 
607             if gt(success, 0) {
608                 // Check number of bytes returned from last function call
609                 switch returndatasize
610 
611                 // No bytes returned: assume success
612                 case 0 {
613                     ret := 1
614                 }
615 
616                 // 32 bytes returned: check if non-zero
617                 case 0x20 {
618                     // Only return success if returned data was true
619                     // Already have output in ptr
620                     ret := eq(mload(ptr), 1)
621                 }
622 
623                 // Not sure what was returned: don't mark as success
624                 default { }
625             }
626         }
627         return ret;
628     }
629 
630     function staticInvoke(address _addr, bytes memory _calldata)
631         private
632         view
633         returns (bool, uint256)
634     {
635         bool success;
636         uint256 ret;
637         assembly {
638             let ptr := mload(0x40)    // free memory pointer
639 
640             success := staticcall(
641                 gas,                  // forward all gas
642                 _addr,                // address
643                 add(_calldata, 0x20), // calldata start
644                 mload(_calldata),     // calldata length
645                 ptr,                  // write output over free memory
646                 0x20                  // uint256 return
647             )
648 
649             if gt(success, 0) {
650                 ret := mload(ptr)
651             }
652         }
653         return (success, ret);
654     }
655 
656     /**
657     * @dev Same as a standards-compliant ERC20.transfer() that never reverts (returns false).
658     *      Note that this makes an external call to the token.
659     */
660     function safeTransfer(ERC20 _token, address _to, uint256 _amount) internal returns (bool) {
661         bytes memory transferCallData = abi.encodeWithSelector(
662             TRANSFER_SELECTOR,
663             _to,
664             _amount
665         );
666         return invokeAndCheckSuccess(_token, transferCallData);
667     }
668 
669     /**
670     * @dev Same as a standards-compliant ERC20.transferFrom() that never reverts (returns false).
671     *      Note that this makes an external call to the token.
672     */
673     function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {
674         bytes memory transferFromCallData = abi.encodeWithSelector(
675             _token.transferFrom.selector,
676             _from,
677             _to,
678             _amount
679         );
680         return invokeAndCheckSuccess(_token, transferFromCallData);
681     }
682 
683     /**
684     * @dev Same as a standards-compliant ERC20.approve() that never reverts (returns false).
685     *      Note that this makes an external call to the token.
686     */
687     function safeApprove(ERC20 _token, address _spender, uint256 _amount) internal returns (bool) {
688         bytes memory approveCallData = abi.encodeWithSelector(
689             _token.approve.selector,
690             _spender,
691             _amount
692         );
693         return invokeAndCheckSuccess(_token, approveCallData);
694     }
695 
696     /**
697     * @dev Static call into ERC20.balanceOf().
698     * Reverts if the call fails for some reason (should never fail).
699     */
700     function staticBalanceOf(ERC20 _token, address _owner) internal view returns (uint256) {
701         bytes memory balanceOfCallData = abi.encodeWithSelector(
702             _token.balanceOf.selector,
703             _owner
704         );
705 
706         (bool success, uint256 tokenBalance) = staticInvoke(_token, balanceOfCallData);
707         require(success, ERROR_TOKEN_BALANCE_REVERTED);
708 
709         return tokenBalance;
710     }
711 
712     /**
713     * @dev Static call into ERC20.allowance().
714     * Reverts if the call fails for some reason (should never fail).
715     */
716     function staticAllowance(ERC20 _token, address _owner, address _spender) internal view returns (uint256) {
717         bytes memory allowanceCallData = abi.encodeWithSelector(
718             _token.allowance.selector,
719             _owner,
720             _spender
721         );
722 
723         (bool success, uint256 allowance) = staticInvoke(_token, allowanceCallData);
724         require(success, ERROR_TOKEN_ALLOWANCE_REVERTED);
725 
726         return allowance;
727     }
728 }
729 
730 // File: @aragon/os/contracts/common/VaultRecoverable.sol
731 
732 /*
733  * SPDX-License-Identitifer:    MIT
734  */
735 
736 pragma solidity ^0.4.24;
737 
738 
739 
740 
741 
742 
743 
744 contract VaultRecoverable is IVaultRecoverable, EtherTokenConstant, IsContract {
745     using SafeERC20 for ERC20;
746 
747     string private constant ERROR_DISALLOWED = "RECOVER_DISALLOWED";
748     string private constant ERROR_VAULT_NOT_CONTRACT = "RECOVER_VAULT_NOT_CONTRACT";
749     string private constant ERROR_TOKEN_TRANSFER_FAILED = "RECOVER_TOKEN_TRANSFER_FAILED";
750 
751     /**
752      * @notice Send funds to recovery Vault. This contract should never receive funds,
753      *         but in case it does, this function allows one to recover them.
754      * @param _token Token balance to be sent to recovery vault.
755      */
756     function transferToVault(address _token) external {
757         require(allowRecoverability(_token), ERROR_DISALLOWED);
758         address vault = getRecoveryVault();
759         require(isContract(vault), ERROR_VAULT_NOT_CONTRACT);
760 
761         uint256 balance;
762         if (_token == ETH) {
763             balance = address(this).balance;
764             vault.transfer(balance);
765         } else {
766             ERC20 token = ERC20(_token);
767             balance = token.staticBalanceOf(this);
768             require(token.safeTransfer(vault, balance), ERROR_TOKEN_TRANSFER_FAILED);
769         }
770 
771         emit RecoverToVault(vault, _token, balance);
772     }
773 
774     /**
775     * @dev By default deriving from AragonApp makes it recoverable
776     * @param token Token address that would be recovered
777     * @return bool whether the app allows the recovery
778     */
779     function allowRecoverability(address token) public view returns (bool) {
780         return true;
781     }
782 
783     // Cast non-implemented interface to be public so we can use it internally
784     function getRecoveryVault() public view returns (address);
785 }
786 
787 // File: @aragon/os/contracts/evmscript/IEVMScriptExecutor.sol
788 
789 /*
790  * SPDX-License-Identitifer:    MIT
791  */
792 
793 pragma solidity ^0.4.24;
794 
795 
796 interface IEVMScriptExecutor {
797     function execScript(bytes script, bytes input, address[] blacklist) external returns (bytes);
798     function executorType() external pure returns (bytes32);
799 }
800 
801 // File: @aragon/os/contracts/evmscript/IEVMScriptRegistry.sol
802 
803 /*
804  * SPDX-License-Identitifer:    MIT
805  */
806 
807 pragma solidity ^0.4.24;
808 
809 
810 
811 contract EVMScriptRegistryConstants {
812     /* Hardcoded constants to save gas
813     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = apmNamehash("evmreg");
814     */
815     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = 0xddbcfd564f642ab5627cf68b9b7d374fb4f8a36e941a75d89c87998cef03bd61;
816 }
817 
818 
819 interface IEVMScriptRegistry {
820     function addScriptExecutor(IEVMScriptExecutor executor) external returns (uint id);
821     function disableScriptExecutor(uint256 executorId) external;
822 
823     // TODO: this should be external
824     // See https://github.com/ethereum/solidity/issues/4832
825     function getScriptExecutor(bytes script) public view returns (IEVMScriptExecutor);
826 }
827 
828 // File: @aragon/os/contracts/kernel/KernelConstants.sol
829 
830 /*
831  * SPDX-License-Identitifer:    MIT
832  */
833 
834 pragma solidity ^0.4.24;
835 
836 
837 contract KernelAppIds {
838     /* Hardcoded constants to save gas
839     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
840     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
841     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
842     */
843     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
844     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
845     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
846 }
847 
848 
849 contract KernelNamespaceConstants {
850     /* Hardcoded constants to save gas
851     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
852     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
853     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
854     */
855     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
856     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
857     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
858 }
859 
860 // File: @aragon/os/contracts/evmscript/EVMScriptRunner.sol
861 
862 /*
863  * SPDX-License-Identitifer:    MIT
864  */
865 
866 pragma solidity ^0.4.24;
867 
868 
869 
870 
871 
872 
873 
874 contract EVMScriptRunner is AppStorage, Initializable, EVMScriptRegistryConstants, KernelNamespaceConstants {
875     string private constant ERROR_EXECUTOR_UNAVAILABLE = "EVMRUN_EXECUTOR_UNAVAILABLE";
876     string private constant ERROR_PROTECTED_STATE_MODIFIED = "EVMRUN_PROTECTED_STATE_MODIFIED";
877 
878     /* This is manually crafted in assembly
879     string private constant ERROR_EXECUTOR_INVALID_RETURN = "EVMRUN_EXECUTOR_INVALID_RETURN";
880     */
881 
882     event ScriptResult(address indexed executor, bytes script, bytes input, bytes returnData);
883 
884     function getEVMScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
885         return IEVMScriptExecutor(getEVMScriptRegistry().getScriptExecutor(_script));
886     }
887 
888     function getEVMScriptRegistry() public view returns (IEVMScriptRegistry) {
889         address registryAddr = kernel().getApp(KERNEL_APP_ADDR_NAMESPACE, EVMSCRIPT_REGISTRY_APP_ID);
890         return IEVMScriptRegistry(registryAddr);
891     }
892 
893     function runScript(bytes _script, bytes _input, address[] _blacklist)
894         internal
895         isInitialized
896         protectState
897         returns (bytes)
898     {
899         IEVMScriptExecutor executor = getEVMScriptExecutor(_script);
900         require(address(executor) != address(0), ERROR_EXECUTOR_UNAVAILABLE);
901 
902         bytes4 sig = executor.execScript.selector;
903         bytes memory data = abi.encodeWithSelector(sig, _script, _input, _blacklist);
904 
905         bytes memory output;
906         assembly {
907             let success := delegatecall(
908                 gas,                // forward all gas
909                 executor,           // address
910                 add(data, 0x20),    // calldata start
911                 mload(data),        // calldata length
912                 0,                  // don't write output (we'll handle this ourselves)
913                 0                   // don't write output
914             )
915 
916             output := mload(0x40) // free mem ptr get
917 
918             switch success
919             case 0 {
920                 // If the call errored, forward its full error data
921                 returndatacopy(output, 0, returndatasize)
922                 revert(output, returndatasize)
923             }
924             default {
925                 switch gt(returndatasize, 0x3f)
926                 case 0 {
927                     // Need at least 0x40 bytes returned for properly ABI-encoded bytes values,
928                     // revert with "EVMRUN_EXECUTOR_INVALID_RETURN"
929                     // See remix: doing a `revert("EVMRUN_EXECUTOR_INVALID_RETURN")` always results in
930                     // this memory layout
931                     mstore(output, 0x08c379a000000000000000000000000000000000000000000000000000000000)         // error identifier
932                     mstore(add(output, 0x04), 0x0000000000000000000000000000000000000000000000000000000000000020) // starting offset
933                     mstore(add(output, 0x24), 0x000000000000000000000000000000000000000000000000000000000000001e) // reason length
934                     mstore(add(output, 0x44), 0x45564d52554e5f4558454355544f525f494e56414c49445f52455455524e0000) // reason
935 
936                     revert(output, 100) // 100 = 4 + 3 * 32 (error identifier + 3 words for the ABI encoded error)
937                 }
938                 default {
939                     // Copy result
940                     //
941                     // Needs to perform an ABI decode for the expected `bytes` return type of
942                     // `executor.execScript()` as solidity will automatically ABI encode the returned bytes as:
943                     //    [ position of the first dynamic length return value = 0x20 (32 bytes) ]
944                     //    [ output length (32 bytes) ]
945                     //    [ output content (N bytes) ]
946                     //
947                     // Perform the ABI decode by ignoring the first 32 bytes of the return data
948                     let copysize := sub(returndatasize, 0x20)
949                     returndatacopy(output, 0x20, copysize)
950 
951                     mstore(0x40, add(output, copysize)) // free mem ptr set
952                 }
953             }
954         }
955 
956         emit ScriptResult(address(executor), _script, _input, output);
957 
958         return output;
959     }
960 
961     modifier protectState {
962         address preKernel = address(kernel());
963         bytes32 preAppId = appId();
964         _; // exec
965         require(address(kernel()) == preKernel, ERROR_PROTECTED_STATE_MODIFIED);
966         require(appId() == preAppId, ERROR_PROTECTED_STATE_MODIFIED);
967     }
968 }
969 
970 // File: @aragon/os/contracts/apps/AragonApp.sol
971 
972 /*
973  * SPDX-License-Identitifer:    MIT
974  */
975 
976 pragma solidity ^0.4.24;
977 
978 
979 
980 
981 
982 
983 
984 
985 
986 // Contracts inheriting from AragonApp are, by default, immediately petrified upon deployment so
987 // that they can never be initialized.
988 // Unless overriden, this behaviour enforces those contracts to be usable only behind an AppProxy.
989 // ReentrancyGuard, EVMScriptRunner, and ACLSyntaxSugar are not directly used by this contract, but
990 // are included so that they are automatically usable by subclassing contracts
991 contract AragonApp is AppStorage, Autopetrified, VaultRecoverable, ReentrancyGuard, EVMScriptRunner, ACLSyntaxSugar {
992     string private constant ERROR_AUTH_FAILED = "APP_AUTH_FAILED";
993 
994     modifier auth(bytes32 _role) {
995         require(canPerform(msg.sender, _role, new uint256[](0)), ERROR_AUTH_FAILED);
996         _;
997     }
998 
999     modifier authP(bytes32 _role, uint256[] _params) {
1000         require(canPerform(msg.sender, _role, _params), ERROR_AUTH_FAILED);
1001         _;
1002     }
1003 
1004     /**
1005     * @dev Check whether an action can be performed by a sender for a particular role on this app
1006     * @param _sender Sender of the call
1007     * @param _role Role on this app
1008     * @param _params Permission params for the role
1009     * @return Boolean indicating whether the sender has the permissions to perform the action.
1010     *         Always returns false if the app hasn't been initialized yet.
1011     */
1012     function canPerform(address _sender, bytes32 _role, uint256[] _params) public view returns (bool) {
1013         if (!hasInitialized()) {
1014             return false;
1015         }
1016 
1017         IKernel linkedKernel = kernel();
1018         if (address(linkedKernel) == address(0)) {
1019             return false;
1020         }
1021 
1022         return linkedKernel.hasPermission(
1023             _sender,
1024             address(this),
1025             _role,
1026             ConversionHelpers.dangerouslyCastUintArrayToBytes(_params)
1027         );
1028     }
1029 
1030     /**
1031     * @dev Get the recovery vault for the app
1032     * @return Recovery vault address for the app
1033     */
1034     function getRecoveryVault() public view returns (address) {
1035         // Funds recovery via a vault is only available when used with a kernel
1036         return kernel().getRecoveryVault(); // if kernel is not set, it will revert
1037     }
1038 }
1039 
1040 // File: @aragon/os/contracts/common/IForwarder.sol
1041 
1042 /*
1043  * SPDX-License-Identitifer:    MIT
1044  */
1045 
1046 pragma solidity ^0.4.24;
1047 
1048 
1049 interface IForwarder {
1050     function isForwarder() external pure returns (bool);
1051 
1052     // TODO: this should be external
1053     // See https://github.com/ethereum/solidity/issues/4832
1054     function canForward(address sender, bytes evmCallScript) public view returns (bool);
1055 
1056     // TODO: this should be external
1057     // See https://github.com/ethereum/solidity/issues/4832
1058     function forward(bytes evmCallScript) public;
1059 }
1060 
1061 // File: @aragon/os/contracts/lib/math/SafeMath.sol
1062 
1063 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d51e38758e1d985661534534d5c61e27bece5042/contracts/math/SafeMath.sol
1064 // Adapted to use pragma ^0.4.24 and satisfy our linter rules
1065 
1066 pragma solidity ^0.4.24;
1067 
1068 
1069 /**
1070  * @title SafeMath
1071  * @dev Math operations with safety checks that revert on error
1072  */
1073 library SafeMath {
1074     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
1075     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
1076     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
1077     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
1078 
1079     /**
1080     * @dev Multiplies two numbers, reverts on overflow.
1081     */
1082     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
1083         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1084         // benefit is lost if 'b' is also tested.
1085         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1086         if (_a == 0) {
1087             return 0;
1088         }
1089 
1090         uint256 c = _a * _b;
1091         require(c / _a == _b, ERROR_MUL_OVERFLOW);
1092 
1093         return c;
1094     }
1095 
1096     /**
1097     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1098     */
1099     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1100         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
1101         uint256 c = _a / _b;
1102         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1103 
1104         return c;
1105     }
1106 
1107     /**
1108     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1109     */
1110     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1111         require(_b <= _a, ERROR_SUB_UNDERFLOW);
1112         uint256 c = _a - _b;
1113 
1114         return c;
1115     }
1116 
1117     /**
1118     * @dev Adds two numbers, reverts on overflow.
1119     */
1120     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
1121         uint256 c = _a + _b;
1122         require(c >= _a, ERROR_ADD_OVERFLOW);
1123 
1124         return c;
1125     }
1126 
1127     /**
1128     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1129     * reverts when dividing by zero.
1130     */
1131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1132         require(b != 0, ERROR_DIV_ZERO);
1133         return a % b;
1134     }
1135 }
1136 
1137 // File: @aragon/apps-shared-minime/contracts/ITokenController.sol
1138 
1139 pragma solidity ^0.4.24;
1140 
1141 /// @dev The token controller contract must implement these functions
1142 
1143 
1144 interface ITokenController {
1145     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
1146     /// @param _owner The address that sent the ether to create tokens
1147     /// @return True if the ether is accepted, false if it throws
1148     function proxyPayment(address _owner) external payable returns(bool);
1149 
1150     /// @notice Notifies the controller about a token transfer allowing the
1151     ///  controller to react if desired
1152     /// @param _from The origin of the transfer
1153     /// @param _to The destination of the transfer
1154     /// @param _amount The amount of the transfer
1155     /// @return False if the controller does not authorize the transfer
1156     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
1157 
1158     /// @notice Notifies the controller about an approval allowing the
1159     ///  controller to react if desired
1160     /// @param _owner The address that calls `approve()`
1161     /// @param _spender The spender in the `approve()` call
1162     /// @param _amount The amount in the `approve()` call
1163     /// @return False if the controller does not authorize the approval
1164     function onApprove(address _owner, address _spender, uint _amount) external returns(bool);
1165 }
1166 
1167 // File: @aragon/apps-shared-minime/contracts/MiniMeToken.sol
1168 
1169 pragma solidity ^0.4.24;
1170 
1171 /*
1172     Copyright 2016, Jordi Baylina
1173     This program is free software: you can redistribute it and/or modify
1174     it under the terms of the GNU General Public License as published by
1175     the Free Software Foundation, either version 3 of the License, or
1176     (at your option) any later version.
1177     This program is distributed in the hope that it will be useful,
1178     but WITHOUT ANY WARRANTY; without even the implied warranty of
1179     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1180     GNU General Public License for more details.
1181     You should have received a copy of the GNU General Public License
1182     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1183  */
1184 
1185 /// @title MiniMeToken Contract
1186 /// @author Jordi Baylina
1187 /// @dev This token contract's goal is to make it easy for anyone to clone this
1188 ///  token using the token distribution at a given block, this will allow DAO's
1189 ///  and DApps to upgrade their features in a decentralized manner without
1190 ///  affecting the original token
1191 /// @dev It is ERC20 compliant, but still needs to under go further testing.
1192 
1193 
1194 contract Controlled {
1195     /// @notice The address of the controller is the only address that can call
1196     ///  a function with this modifier
1197     modifier onlyController {
1198         require(msg.sender == controller);
1199         _;
1200     }
1201 
1202     address public controller;
1203 
1204     function Controlled()  public { controller = msg.sender;}
1205 
1206     /// @notice Changes the controller of the contract
1207     /// @param _newController The new controller of the contract
1208     function changeController(address _newController) onlyController  public {
1209         controller = _newController;
1210     }
1211 }
1212 
1213 contract ApproveAndCallFallBack {
1214     function receiveApproval(
1215         address from,
1216         uint256 _amount,
1217         address _token,
1218         bytes _data
1219     ) public;
1220 }
1221 
1222 /// @dev The actual token contract, the default controller is the msg.sender
1223 ///  that deploys the contract, so usually this token will be deployed by a
1224 ///  token controller contract, which Giveth will call a "Campaign"
1225 contract MiniMeToken is Controlled {
1226 
1227     string public name;                //The Token's name: e.g. DigixDAO Tokens
1228     uint8 public decimals;             //Number of decimals of the smallest unit
1229     string public symbol;              //An identifier: e.g. REP
1230     string public version = "MMT_0.1"; //An arbitrary versioning scheme
1231 
1232 
1233     /// @dev `Checkpoint` is the structure that attaches a block number to a
1234     ///  given value, the block number attached is the one that last changed the
1235     ///  value
1236     struct Checkpoint {
1237 
1238         // `fromBlock` is the block number that the value was generated from
1239         uint128 fromBlock;
1240 
1241         // `value` is the amount of tokens at a specific block number
1242         uint128 value;
1243     }
1244 
1245     // `parentToken` is the Token address that was cloned to produce this token;
1246     //  it will be 0x0 for a token that was not cloned
1247     MiniMeToken public parentToken;
1248 
1249     // `parentSnapShotBlock` is the block number from the Parent Token that was
1250     //  used to determine the initial distribution of the Clone Token
1251     uint public parentSnapShotBlock;
1252 
1253     // `creationBlock` is the block number that the Clone Token was created
1254     uint public creationBlock;
1255 
1256     // `balances` is the map that tracks the balance of each address, in this
1257     //  contract when the balance changes the block number that the change
1258     //  occurred is also included in the map
1259     mapping (address => Checkpoint[]) balances;
1260 
1261     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
1262     mapping (address => mapping (address => uint256)) allowed;
1263 
1264     // Tracks the history of the `totalSupply` of the token
1265     Checkpoint[] totalSupplyHistory;
1266 
1267     // Flag that determines if the token is transferable or not.
1268     bool public transfersEnabled;
1269 
1270     // The factory used to create new clone tokens
1271     MiniMeTokenFactory public tokenFactory;
1272 
1273 ////////////////
1274 // Constructor
1275 ////////////////
1276 
1277     /// @notice Constructor to create a MiniMeToken
1278     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
1279     ///  will create the Clone token contracts, the token factory needs to be
1280     ///  deployed first
1281     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
1282     ///  new token
1283     /// @param _parentSnapShotBlock Block of the parent token that will
1284     ///  determine the initial distribution of the clone token, set to 0 if it
1285     ///  is a new token
1286     /// @param _tokenName Name of the new token
1287     /// @param _decimalUnits Number of decimals of the new token
1288     /// @param _tokenSymbol Token Symbol for the new token
1289     /// @param _transfersEnabled If true, tokens will be able to be transferred
1290     function MiniMeToken(
1291         MiniMeTokenFactory _tokenFactory,
1292         MiniMeToken _parentToken,
1293         uint _parentSnapShotBlock,
1294         string _tokenName,
1295         uint8 _decimalUnits,
1296         string _tokenSymbol,
1297         bool _transfersEnabled
1298     )  public
1299     {
1300         tokenFactory = _tokenFactory;
1301         name = _tokenName;                                 // Set the name
1302         decimals = _decimalUnits;                          // Set the decimals
1303         symbol = _tokenSymbol;                             // Set the symbol
1304         parentToken = _parentToken;
1305         parentSnapShotBlock = _parentSnapShotBlock;
1306         transfersEnabled = _transfersEnabled;
1307         creationBlock = block.number;
1308     }
1309 
1310 
1311 ///////////////////
1312 // ERC20 Methods
1313 ///////////////////
1314 
1315     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
1316     /// @param _to The address of the recipient
1317     /// @param _amount The amount of tokens to be transferred
1318     /// @return Whether the transfer was successful or not
1319     function transfer(address _to, uint256 _amount) public returns (bool success) {
1320         require(transfersEnabled);
1321         return doTransfer(msg.sender, _to, _amount);
1322     }
1323 
1324     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1325     ///  is approved by `_from`
1326     /// @param _from The address holding the tokens being transferred
1327     /// @param _to The address of the recipient
1328     /// @param _amount The amount of tokens to be transferred
1329     /// @return True if the transfer was successful
1330     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
1331 
1332         // The controller of this contract can move tokens around at will,
1333         //  this is important to recognize! Confirm that you trust the
1334         //  controller of this contract, which in most situations should be
1335         //  another open source smart contract or 0x0
1336         if (msg.sender != controller) {
1337             require(transfersEnabled);
1338 
1339             // The standard ERC 20 transferFrom functionality
1340             if (allowed[_from][msg.sender] < _amount)
1341                 return false;
1342             allowed[_from][msg.sender] -= _amount;
1343         }
1344         return doTransfer(_from, _to, _amount);
1345     }
1346 
1347     /// @dev This is the actual transfer function in the token contract, it can
1348     ///  only be called by other functions in this contract.
1349     /// @param _from The address holding the tokens being transferred
1350     /// @param _to The address of the recipient
1351     /// @param _amount The amount of tokens to be transferred
1352     /// @return True if the transfer was successful
1353     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
1354         if (_amount == 0) {
1355             return true;
1356         }
1357         require(parentSnapShotBlock < block.number);
1358         // Do not allow transfer to 0x0 or the token contract itself
1359         require((_to != 0) && (_to != address(this)));
1360         // If the amount being transfered is more than the balance of the
1361         //  account the transfer returns false
1362         var previousBalanceFrom = balanceOfAt(_from, block.number);
1363         if (previousBalanceFrom < _amount) {
1364             return false;
1365         }
1366         // Alerts the token controller of the transfer
1367         if (isContract(controller)) {
1368             // Adding the ` == true` makes the linter shut up so...
1369             require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
1370         }
1371         // First update the balance array with the new value for the address
1372         //  sending the tokens
1373         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
1374         // Then update the balance array with the new value for the address
1375         //  receiving the tokens
1376         var previousBalanceTo = balanceOfAt(_to, block.number);
1377         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
1378         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
1379         // An event to make the transfer easy to find on the blockchain
1380         Transfer(_from, _to, _amount);
1381         return true;
1382     }
1383 
1384     /// @param _owner The address that's balance is being requested
1385     /// @return The balance of `_owner` at the current block
1386     function balanceOf(address _owner) public constant returns (uint256 balance) {
1387         return balanceOfAt(_owner, block.number);
1388     }
1389 
1390     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1391     ///  its behalf. This is a modified version of the ERC20 approve function
1392     ///  to be a little bit safer
1393     /// @param _spender The address of the account able to transfer the tokens
1394     /// @param _amount The amount of tokens to be approved for transfer
1395     /// @return True if the approval was successful
1396     function approve(address _spender, uint256 _amount) public returns (bool success) {
1397         require(transfersEnabled);
1398 
1399         // To change the approve amount you first have to reduce the addresses`
1400         //  allowance to zero by calling `approve(_spender,0)` if it is not
1401         //  already 0 to mitigate the race condition described here:
1402         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1403         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
1404 
1405         // Alerts the token controller of the approve function call
1406         if (isContract(controller)) {
1407             // Adding the ` == true` makes the linter shut up so...
1408             require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
1409         }
1410 
1411         allowed[msg.sender][_spender] = _amount;
1412         Approval(msg.sender, _spender, _amount);
1413         return true;
1414     }
1415 
1416     /// @dev This function makes it easy to read the `allowed[]` map
1417     /// @param _owner The address of the account that owns the token
1418     /// @param _spender The address of the account able to transfer the tokens
1419     /// @return Amount of remaining tokens of _owner that _spender is allowed
1420     ///  to spend
1421     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
1422         return allowed[_owner][_spender];
1423     }
1424 
1425     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1426     ///  its behalf, and then a function is triggered in the contract that is
1427     ///  being approved, `_spender`. This allows users to use their tokens to
1428     ///  interact with contracts in one function call instead of two
1429     /// @param _spender The address of the contract able to transfer the tokens
1430     /// @param _amount The amount of tokens to be approved for transfer
1431     /// @return True if the function call was successful
1432     function approveAndCall(ApproveAndCallFallBack _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
1433         require(approve(_spender, _amount));
1434 
1435         _spender.receiveApproval(
1436             msg.sender,
1437             _amount,
1438             this,
1439             _extraData
1440         );
1441 
1442         return true;
1443     }
1444 
1445     /// @dev This function makes it easy to get the total number of tokens
1446     /// @return The total number of tokens
1447     function totalSupply() public constant returns (uint) {
1448         return totalSupplyAt(block.number);
1449     }
1450 
1451 
1452 ////////////////
1453 // Query balance and totalSupply in History
1454 ////////////////
1455 
1456     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
1457     /// @param _owner The address from which the balance will be retrieved
1458     /// @param _blockNumber The block number when the balance is queried
1459     /// @return The balance at `_blockNumber`
1460     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
1461 
1462         // These next few lines are used when the balance of the token is
1463         //  requested before a check point was ever created for this token, it
1464         //  requires that the `parentToken.balanceOfAt` be queried at the
1465         //  genesis block for that token as this contains initial balance of
1466         //  this token
1467         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
1468             if (address(parentToken) != 0) {
1469                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
1470             } else {
1471                 // Has no parent
1472                 return 0;
1473             }
1474 
1475         // This will return the expected balance during normal situations
1476         } else {
1477             return getValueAt(balances[_owner], _blockNumber);
1478         }
1479     }
1480 
1481     /// @notice Total amount of tokens at a specific `_blockNumber`.
1482     /// @param _blockNumber The block number when the totalSupply is queried
1483     /// @return The total amount of tokens at `_blockNumber`
1484     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
1485 
1486         // These next few lines are used when the totalSupply of the token is
1487         //  requested before a check point was ever created for this token, it
1488         //  requires that the `parentToken.totalSupplyAt` be queried at the
1489         //  genesis block for this token as that contains totalSupply of this
1490         //  token at this block number.
1491         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
1492             if (address(parentToken) != 0) {
1493                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
1494             } else {
1495                 return 0;
1496             }
1497 
1498         // This will return the expected totalSupply during normal situations
1499         } else {
1500             return getValueAt(totalSupplyHistory, _blockNumber);
1501         }
1502     }
1503 
1504 ////////////////
1505 // Clone Token Method
1506 ////////////////
1507 
1508     /// @notice Creates a new clone token with the initial distribution being
1509     ///  this token at `_snapshotBlock`
1510     /// @param _cloneTokenName Name of the clone token
1511     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
1512     /// @param _cloneTokenSymbol Symbol of the clone token
1513     /// @param _snapshotBlock Block when the distribution of the parent token is
1514     ///  copied to set the initial distribution of the new clone token;
1515     ///  if the block is zero than the actual block, the current block is used
1516     /// @param _transfersEnabled True if transfers are allowed in the clone
1517     /// @return The address of the new MiniMeToken Contract
1518     function createCloneToken(
1519         string _cloneTokenName,
1520         uint8 _cloneDecimalUnits,
1521         string _cloneTokenSymbol,
1522         uint _snapshotBlock,
1523         bool _transfersEnabled
1524     ) public returns(MiniMeToken)
1525     {
1526         uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
1527 
1528         MiniMeToken cloneToken = tokenFactory.createCloneToken(
1529             this,
1530             snapshot,
1531             _cloneTokenName,
1532             _cloneDecimalUnits,
1533             _cloneTokenSymbol,
1534             _transfersEnabled
1535         );
1536 
1537         cloneToken.changeController(msg.sender);
1538 
1539         // An event to make the token easy to find on the blockchain
1540         NewCloneToken(address(cloneToken), snapshot);
1541         return cloneToken;
1542     }
1543 
1544 ////////////////
1545 // Generate and destroy tokens
1546 ////////////////
1547 
1548     /// @notice Generates `_amount` tokens that are assigned to `_owner`
1549     /// @param _owner The address that will be assigned the new tokens
1550     /// @param _amount The quantity of tokens generated
1551     /// @return True if the tokens are generated correctly
1552     function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
1553         uint curTotalSupply = totalSupply();
1554         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
1555         uint previousBalanceTo = balanceOf(_owner);
1556         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
1557         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
1558         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
1559         Transfer(0, _owner, _amount);
1560         return true;
1561     }
1562 
1563 
1564     /// @notice Burns `_amount` tokens from `_owner`
1565     /// @param _owner The address that will lose the tokens
1566     /// @param _amount The quantity of tokens to burn
1567     /// @return True if the tokens are burned correctly
1568     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
1569         uint curTotalSupply = totalSupply();
1570         require(curTotalSupply >= _amount);
1571         uint previousBalanceFrom = balanceOf(_owner);
1572         require(previousBalanceFrom >= _amount);
1573         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
1574         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
1575         Transfer(_owner, 0, _amount);
1576         return true;
1577     }
1578 
1579 ////////////////
1580 // Enable tokens transfers
1581 ////////////////
1582 
1583 
1584     /// @notice Enables token holders to transfer their tokens freely if true
1585     /// @param _transfersEnabled True if transfers are allowed in the clone
1586     function enableTransfers(bool _transfersEnabled) onlyController public {
1587         transfersEnabled = _transfersEnabled;
1588     }
1589 
1590 ////////////////
1591 // Internal helper functions to query and set a value in a snapshot array
1592 ////////////////
1593 
1594     /// @dev `getValueAt` retrieves the number of tokens at a given block number
1595     /// @param checkpoints The history of values being queried
1596     /// @param _block The block number to retrieve the value at
1597     /// @return The number of tokens being queried
1598     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
1599         if (checkpoints.length == 0)
1600             return 0;
1601 
1602         // Shortcut for the actual value
1603         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
1604             return checkpoints[checkpoints.length-1].value;
1605         if (_block < checkpoints[0].fromBlock)
1606             return 0;
1607 
1608         // Binary search of the value in the array
1609         uint min = 0;
1610         uint max = checkpoints.length-1;
1611         while (max > min) {
1612             uint mid = (max + min + 1) / 2;
1613             if (checkpoints[mid].fromBlock<=_block) {
1614                 min = mid;
1615             } else {
1616                 max = mid-1;
1617             }
1618         }
1619         return checkpoints[min].value;
1620     }
1621 
1622     /// @dev `updateValueAtNow` used to update the `balances` map and the
1623     ///  `totalSupplyHistory`
1624     /// @param checkpoints The history of data being updated
1625     /// @param _value The new number of tokens
1626     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
1627         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
1628             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
1629             newCheckPoint.fromBlock = uint128(block.number);
1630             newCheckPoint.value = uint128(_value);
1631         } else {
1632             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
1633             oldCheckPoint.value = uint128(_value);
1634         }
1635     }
1636 
1637     /// @dev Internal function to determine if an address is a contract
1638     /// @param _addr The address being queried
1639     /// @return True if `_addr` is a contract
1640     function isContract(address _addr) constant internal returns(bool) {
1641         uint size;
1642         if (_addr == 0)
1643             return false;
1644 
1645         assembly {
1646             size := extcodesize(_addr)
1647         }
1648 
1649         return size>0;
1650     }
1651 
1652     /// @dev Helper function to return a min betwen the two uints
1653     function min(uint a, uint b) pure internal returns (uint) {
1654         return a < b ? a : b;
1655     }
1656 
1657     /// @notice The fallback function: If the contract's controller has not been
1658     ///  set to 0, then the `proxyPayment` method is called which relays the
1659     ///  ether and creates tokens as described in the token controller contract
1660     function () external payable {
1661         require(isContract(controller));
1662         // Adding the ` == true` makes the linter shut up so...
1663         require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
1664     }
1665 
1666 //////////
1667 // Safety Methods
1668 //////////
1669 
1670     /// @notice This method can be used by the controller to extract mistakenly
1671     ///  sent tokens to this contract.
1672     /// @param _token The address of the token contract that you want to recover
1673     ///  set to 0 in case you want to extract ether.
1674     function claimTokens(address _token) onlyController public {
1675         if (_token == 0x0) {
1676             controller.transfer(this.balance);
1677             return;
1678         }
1679 
1680         MiniMeToken token = MiniMeToken(_token);
1681         uint balance = token.balanceOf(this);
1682         token.transfer(controller, balance);
1683         ClaimedTokens(_token, controller, balance);
1684     }
1685 
1686 ////////////////
1687 // Events
1688 ////////////////
1689     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1690     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
1691     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
1692     event Approval(
1693         address indexed _owner,
1694         address indexed _spender,
1695         uint256 _amount
1696         );
1697 
1698 }
1699 
1700 
1701 ////////////////
1702 // MiniMeTokenFactory
1703 ////////////////
1704 
1705 /// @dev This contract is used to generate clone contracts from a contract.
1706 ///  In solidity this is the way to create a contract from a contract of the
1707 ///  same class
1708 contract MiniMeTokenFactory {
1709 
1710     /// @notice Update the DApp by creating a new token with new functionalities
1711     ///  the msg.sender becomes the controller of this clone token
1712     /// @param _parentToken Address of the token being cloned
1713     /// @param _snapshotBlock Block of the parent token that will
1714     ///  determine the initial distribution of the clone token
1715     /// @param _tokenName Name of the new token
1716     /// @param _decimalUnits Number of decimals of the new token
1717     /// @param _tokenSymbol Token Symbol for the new token
1718     /// @param _transfersEnabled If true, tokens will be able to be transferred
1719     /// @return The address of the new token contract
1720     function createCloneToken(
1721         MiniMeToken _parentToken,
1722         uint _snapshotBlock,
1723         string _tokenName,
1724         uint8 _decimalUnits,
1725         string _tokenSymbol,
1726         bool _transfersEnabled
1727     ) public returns (MiniMeToken)
1728     {
1729         MiniMeToken newToken = new MiniMeToken(
1730             this,
1731             _parentToken,
1732             _snapshotBlock,
1733             _tokenName,
1734             _decimalUnits,
1735             _tokenSymbol,
1736             _transfersEnabled
1737         );
1738 
1739         newToken.changeController(msg.sender);
1740         return newToken;
1741     }
1742 }
1743 
1744 // File: contracts/TokenManager.sol
1745 
1746 /*
1747  * SPDX-License-Identitifer:    GPL-3.0-or-later
1748  */
1749 
1750 /* solium-disable function-order */
1751 
1752 pragma solidity 0.4.24;
1753 
1754 
1755 
1756 
1757 
1758 
1759 
1760 contract TokenManager is ITokenController, IForwarder, AragonApp {
1761     using SafeMath for uint256;
1762 
1763     bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
1764     bytes32 public constant ISSUE_ROLE = keccak256("ISSUE_ROLE");
1765     bytes32 public constant ASSIGN_ROLE = keccak256("ASSIGN_ROLE");
1766     bytes32 public constant REVOKE_VESTINGS_ROLE = keccak256("REVOKE_VESTINGS_ROLE");
1767     bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");
1768 
1769     uint256 public constant MAX_VESTINGS_PER_ADDRESS = 50;
1770 
1771     string private constant ERROR_CALLER_NOT_TOKEN = "TM_CALLER_NOT_TOKEN";
1772     string private constant ERROR_NO_VESTING = "TM_NO_VESTING";
1773     string private constant ERROR_TOKEN_CONTROLLER = "TM_TOKEN_CONTROLLER";
1774     string private constant ERROR_MINT_RECEIVER_IS_TM = "TM_MINT_RECEIVER_IS_TM";
1775     string private constant ERROR_VESTING_TO_TM = "TM_VESTING_TO_TM";
1776     string private constant ERROR_TOO_MANY_VESTINGS = "TM_TOO_MANY_VESTINGS";
1777     string private constant ERROR_WRONG_CLIFF_DATE = "TM_WRONG_CLIFF_DATE";
1778     string private constant ERROR_VESTING_NOT_REVOKABLE = "TM_VESTING_NOT_REVOKABLE";
1779     string private constant ERROR_REVOKE_TRANSFER_FROM_REVERTED = "TM_REVOKE_TRANSFER_FROM_REVERTED";
1780     string private constant ERROR_CAN_NOT_FORWARD = "TM_CAN_NOT_FORWARD";
1781     string private constant ERROR_BALANCE_INCREASE_NOT_ALLOWED = "TM_BALANCE_INC_NOT_ALLOWED";
1782     string private constant ERROR_ASSIGN_TRANSFER_FROM_REVERTED = "TM_ASSIGN_TRANSFER_FROM_REVERTED";
1783 
1784     struct TokenVesting {
1785         uint256 amount;
1786         uint64 start;
1787         uint64 cliff;
1788         uint64 vesting;
1789         bool revokable;
1790     }
1791 
1792     // Note that we COMPLETELY trust this MiniMeToken to not be malicious for proper operation of this contract
1793     MiniMeToken public token;
1794     uint256 public maxAccountTokens;
1795 
1796     // We are mimicing an array in the inner mapping, we use a mapping instead to make app upgrade more graceful
1797     mapping (address => mapping (uint256 => TokenVesting)) internal vestings;
1798     mapping (address => uint256) public vestingsLengths;
1799 
1800     // Other token specific events can be watched on the token address directly (avoids duplication)
1801     event NewVesting(address indexed receiver, uint256 vestingId, uint256 amount);
1802     event RevokeVesting(address indexed receiver, uint256 vestingId, uint256 nonVestedAmount);
1803 
1804     modifier onlyToken() {
1805         require(msg.sender == address(token), ERROR_CALLER_NOT_TOKEN);
1806         _;
1807     }
1808 
1809     modifier vestingExists(address _holder, uint256 _vestingId) {
1810         // TODO: it's not checking for gaps that may appear because of deletes in revokeVesting function
1811         require(_vestingId < vestingsLengths[_holder], ERROR_NO_VESTING);
1812         _;
1813     }
1814 
1815     /**
1816     * @notice Initialize Token Manager for `_token.symbol(): string`, whose tokens are `transferable ? 'not' : ''` transferable`_maxAccountTokens > 0 ? ' and limited to a maximum of ' + @tokenAmount(_token, _maxAccountTokens, false) + ' per account' : ''`
1817     * @param _token MiniMeToken address for the managed token (Token Manager instance must be already set as the token controller)
1818     * @param _transferable whether the token can be transferred by holders
1819     * @param _maxAccountTokens Maximum amount of tokens an account can have (0 for infinite tokens)
1820     */
1821     function initialize(
1822         MiniMeToken _token,
1823         bool _transferable,
1824         uint256 _maxAccountTokens
1825     )
1826         external
1827         onlyInit
1828     {
1829         initialized();
1830 
1831         require(_token.controller() == address(this), ERROR_TOKEN_CONTROLLER);
1832 
1833         token = _token;
1834         maxAccountTokens = _maxAccountTokens == 0 ? uint256(-1) : _maxAccountTokens;
1835 
1836         if (token.transfersEnabled() != _transferable) {
1837             token.enableTransfers(_transferable);
1838         }
1839     }
1840 
1841     /**
1842     * @notice Mint `@tokenAmount(self.token(): address, _amount, false)` tokens for `_receiver`
1843     * @param _receiver The address receiving the tokens, cannot be the Token Manager itself (use `issue()` instead)
1844     * @param _amount Number of tokens minted
1845     */
1846     function mint(address _receiver, uint256 _amount) external authP(MINT_ROLE, arr(_receiver, _amount)) {
1847         require(_receiver != address(this), ERROR_MINT_RECEIVER_IS_TM);
1848         _mint(_receiver, _amount);
1849     }
1850 
1851     /**
1852     * @notice Mint `@tokenAmount(self.token(): address, _amount, false)` tokens for the Token Manager
1853     * @param _amount Number of tokens minted
1854     */
1855     function issue(uint256 _amount) external authP(ISSUE_ROLE, arr(_amount)) {
1856         _mint(address(this), _amount);
1857     }
1858 
1859     /**
1860     * @notice Assign `@tokenAmount(self.token(): address, _amount, false)` tokens to `_receiver` from the Token Manager's holdings
1861     * @param _receiver The address receiving the tokens
1862     * @param _amount Number of tokens transferred
1863     */
1864     function assign(address _receiver, uint256 _amount) external authP(ASSIGN_ROLE, arr(_receiver, _amount)) {
1865         _assign(_receiver, _amount);
1866     }
1867 
1868     /**
1869     * @notice Burn `@tokenAmount(self.token(): address, _amount, false)` tokens from `_holder`
1870     * @param _holder Holder of tokens being burned
1871     * @param _amount Number of tokens being burned
1872     */
1873     function burn(address _holder, uint256 _amount) external authP(BURN_ROLE, arr(_holder, _amount)) {
1874         // minime.destroyTokens() never returns false, only reverts on failure
1875         token.destroyTokens(_holder, _amount);
1876     }
1877 
1878     /**
1879     * @notice Assign `@tokenAmount(self.token(): address, _amount, false)` tokens to `_receiver` from the Token Manager's holdings with a `_revokable : 'revokable' : ''` vesting starting at `@formatDate(_start)`, cliff at `@formatDate(_cliff)` (first portion of tokens transferable), and completed vesting at `@formatDate(_vested)` (all tokens transferable)
1880     * @param _receiver The address receiving the tokens, cannot be Token Manager itself
1881     * @param _amount Number of tokens vested
1882     * @param _start Date the vesting calculations start
1883     * @param _cliff Date when the initial portion of tokens are transferable
1884     * @param _vested Date when all tokens are transferable
1885     * @param _revokable Whether the vesting can be revoked by the Token Manager
1886     */
1887     function assignVested(
1888         address _receiver,
1889         uint256 _amount,
1890         uint64 _start,
1891         uint64 _cliff,
1892         uint64 _vested,
1893         bool _revokable
1894     )
1895         external
1896         authP(ASSIGN_ROLE, arr(_receiver, _amount))
1897         returns (uint256)
1898     {
1899         require(_receiver != address(this), ERROR_VESTING_TO_TM);
1900         require(vestingsLengths[_receiver] < MAX_VESTINGS_PER_ADDRESS, ERROR_TOO_MANY_VESTINGS);
1901         require(_start <= _cliff && _cliff <= _vested, ERROR_WRONG_CLIFF_DATE);
1902 
1903         uint256 vestingId = vestingsLengths[_receiver]++;
1904         vestings[_receiver][vestingId] = TokenVesting(
1905             _amount,
1906             _start,
1907             _cliff,
1908             _vested,
1909             _revokable
1910         );
1911 
1912         _assign(_receiver, _amount);
1913 
1914         emit NewVesting(_receiver, vestingId, _amount);
1915 
1916         return vestingId;
1917     }
1918 
1919     /**
1920     * @notice Revoke vesting #`_vestingId` from `_holder`, returning unvested tokens to the Token Manager
1921     * @param _holder Address whose vesting to revoke
1922     * @param _vestingId Numeric id of the vesting
1923     */
1924     function revokeVesting(address _holder, uint256 _vestingId)
1925         external
1926         authP(REVOKE_VESTINGS_ROLE, arr(_holder))
1927         vestingExists(_holder, _vestingId)
1928     {
1929         TokenVesting storage v = vestings[_holder][_vestingId];
1930         require(v.revokable, ERROR_VESTING_NOT_REVOKABLE);
1931 
1932         uint256 nonVested = _calculateNonVestedTokens(
1933             v.amount,
1934             getTimestamp(),
1935             v.start,
1936             v.cliff,
1937             v.vesting
1938         );
1939 
1940         // To make vestingIds immutable over time, we just zero out the revoked vesting
1941         // Clearing this out also allows the token transfer back to the Token Manager to succeed
1942         delete vestings[_holder][_vestingId];
1943 
1944         // transferFrom always works as controller
1945         // onTransfer hook always allows if transfering to token controller
1946         require(token.transferFrom(_holder, address(this), nonVested), ERROR_REVOKE_TRANSFER_FROM_REVERTED);
1947 
1948         emit RevokeVesting(_holder, _vestingId, nonVested);
1949     }
1950 
1951     // ITokenController fns
1952     // `onTransfer()`, `onApprove()`, and `proxyPayment()` are callbacks from the MiniMe token
1953     // contract and are only meant to be called through the managed MiniMe token that gets assigned
1954     // during initialization.
1955 
1956     /*
1957     * @dev Notifies the controller about a token transfer allowing the controller to decide whether
1958     *      to allow it or react if desired (only callable from the token).
1959     *      Initialization check is implicitly provided by `onlyToken()`.
1960     * @param _from The origin of the transfer
1961     * @param _to The destination of the transfer
1962     * @param _amount The amount of the transfer
1963     * @return False if the controller does not authorize the transfer
1964     */
1965     function onTransfer(address _from, address _to, uint256 _amount) external onlyToken returns (bool) {
1966         return _isBalanceIncreaseAllowed(_to, _amount) && _transferableBalance(_from, getTimestamp()) >= _amount;
1967     }
1968 
1969     /**
1970     * @dev Notifies the controller about an approval allowing the controller to react if desired
1971     *      Initialization check is implicitly provided by `onlyToken()`.
1972     * @return False if the controller does not authorize the approval
1973     */
1974     function onApprove(address, address, uint) external onlyToken returns (bool) {
1975         return true;
1976     }
1977 
1978     /**
1979     * @dev Called when ether is sent to the MiniMe Token contract
1980     *      Initialization check is implicitly provided by `onlyToken()`.
1981     * @return True if the ether is accepted, false for it to throw
1982     */
1983     function proxyPayment(address) external payable onlyToken returns (bool) {
1984         return false;
1985     }
1986 
1987     // Forwarding fns
1988 
1989     function isForwarder() external pure returns (bool) {
1990         return true;
1991     }
1992 
1993     /**
1994     * @notice Execute desired action as a token holder
1995     * @dev IForwarder interface conformance. Forwards any token holder action.
1996     * @param _evmScript Script being executed
1997     */
1998     function forward(bytes _evmScript) public {
1999         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
2000         bytes memory input = new bytes(0); // TODO: Consider input for this
2001 
2002         // Add the managed token to the blacklist to disallow a token holder from executing actions
2003         // on the token controller's (this contract) behalf
2004         address[] memory blacklist = new address[](1);
2005         blacklist[0] = address(token);
2006 
2007         runScript(_evmScript, input, blacklist);
2008     }
2009 
2010     function canForward(address _sender, bytes) public view returns (bool) {
2011         return hasInitialized() && token.balanceOf(_sender) > 0;
2012     }
2013 
2014     // Getter fns
2015 
2016     function getVesting(
2017         address _recipient,
2018         uint256 _vestingId
2019     )
2020         public
2021         view
2022         vestingExists(_recipient, _vestingId)
2023         returns (
2024             uint256 amount,
2025             uint64 start,
2026             uint64 cliff,
2027             uint64 vesting,
2028             bool revokable
2029         )
2030     {
2031         TokenVesting storage tokenVesting = vestings[_recipient][_vestingId];
2032         amount = tokenVesting.amount;
2033         start = tokenVesting.start;
2034         cliff = tokenVesting.cliff;
2035         vesting = tokenVesting.vesting;
2036         revokable = tokenVesting.revokable;
2037     }
2038 
2039     function spendableBalanceOf(address _holder) public view isInitialized returns (uint256) {
2040         return _transferableBalance(_holder, getTimestamp());
2041     }
2042 
2043     function transferableBalance(address _holder, uint256 _time) public view isInitialized returns (uint256) {
2044         return _transferableBalance(_holder, _time);
2045     }
2046 
2047     /**
2048     * @dev Disable recovery escape hatch for own token,
2049     *      as the it has the concept of issuing tokens without assigning them
2050     */
2051     function allowRecoverability(address _token) public view returns (bool) {
2052         return _token != address(token);
2053     }
2054 
2055     // Internal fns
2056 
2057     function _assign(address _receiver, uint256 _amount) internal {
2058         require(_isBalanceIncreaseAllowed(_receiver, _amount), ERROR_BALANCE_INCREASE_NOT_ALLOWED);
2059         // Must use transferFrom() as transfer() does not give the token controller full control
2060         require(token.transferFrom(address(this), _receiver, _amount), ERROR_ASSIGN_TRANSFER_FROM_REVERTED);
2061     }
2062 
2063     function _mint(address _receiver, uint256 _amount) internal {
2064         require(_isBalanceIncreaseAllowed(_receiver, _amount), ERROR_BALANCE_INCREASE_NOT_ALLOWED);
2065         token.generateTokens(_receiver, _amount); // minime.generateTokens() never returns false
2066     }
2067 
2068     function _isBalanceIncreaseAllowed(address _receiver, uint256 _inc) internal view returns (bool) {
2069         // Max balance doesn't apply to the token manager itself
2070         if (_receiver == address(this)) {
2071             return true;
2072         }
2073         return token.balanceOf(_receiver).add(_inc) <= maxAccountTokens;
2074     }
2075 
2076     /**
2077     * @dev Calculate amount of non-vested tokens at a specifc time
2078     * @param tokens The total amount of tokens vested
2079     * @param time The time at which to check
2080     * @param start The date vesting started
2081     * @param cliff The cliff period
2082     * @param vested The fully vested date
2083     * @return The amount of non-vested tokens of a specific grant
2084     *  transferableTokens
2085     *   |                         _/--------   vestedTokens rect
2086     *   |                       _/
2087     *   |                     _/
2088     *   |                   _/
2089     *   |                 _/
2090     *   |                /
2091     *   |              .|
2092     *   |            .  |
2093     *   |          .    |
2094     *   |        .      |
2095     *   |      .        |
2096     *   |    .          |
2097     *   +===+===========+---------+----------> time
2098     *      Start       Cliff    Vested
2099     */
2100     function _calculateNonVestedTokens(
2101         uint256 tokens,
2102         uint256 time,
2103         uint256 start,
2104         uint256 cliff,
2105         uint256 vested
2106     )
2107         private
2108         pure
2109         returns (uint256)
2110     {
2111         // Shortcuts for before cliff and after vested cases.
2112         if (time >= vested) {
2113             return 0;
2114         }
2115         if (time < cliff) {
2116             return tokens;
2117         }
2118 
2119         // Interpolate all vested tokens.
2120         // As before cliff the shortcut returns 0, we can just calculate a value
2121         // in the vesting rect (as shown in above's figure)
2122 
2123         // vestedTokens = tokens * (time - start) / (vested - start)
2124         // In assignVesting we enforce start <= cliff <= vested
2125         // Here we shortcut time >= vested and time < cliff,
2126         // so no division by 0 is possible
2127         uint256 vestedTokens = tokens.mul(time.sub(start)) / vested.sub(start);
2128 
2129         // tokens - vestedTokens
2130         return tokens.sub(vestedTokens);
2131     }
2132 
2133     function _transferableBalance(address _holder, uint256 _time) internal view returns (uint256) {
2134         uint256 transferable = token.balanceOf(_holder);
2135 
2136         // This check is not strictly necessary for the current version of this contract, as
2137         // Token Managers now cannot assign vestings to themselves.
2138         // However, this was a possibility in the past, so in case there were vestings assigned to
2139         // themselves, this will still return the correct value (entire balance, as the Token
2140         // Manager does not have a spending limit on its own balance).
2141         if (_holder != address(this)) {
2142             uint256 vestingsCount = vestingsLengths[_holder];
2143             for (uint256 i = 0; i < vestingsCount; i++) {
2144                 TokenVesting storage v = vestings[_holder][i];
2145                 uint256 nonTransferable = _calculateNonVestedTokens(
2146                     v.amount,
2147                     _time,
2148                     v.start,
2149                     v.cliff,
2150                     v.vesting
2151                 );
2152                 transferable = transferable.sub(nonTransferable);
2153             }
2154         }
2155 
2156         return transferable;
2157     }
2158 }