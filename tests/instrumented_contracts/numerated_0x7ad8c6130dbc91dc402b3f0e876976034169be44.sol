1 // File: @0x/contracts-utils/contracts/src/LibReentrancyGuardRichErrors.sol
2 
3 /*
4 
5   Copyright 2019 ZeroEx Intl.
6 
7   Licensed under the Apache License, Version 2.0 (the "License");
8   you may not use this file except in compliance with the License.
9   You may obtain a copy of the License at
10 
11     http://www.apache.org/licenses/LICENSE-2.0
12 
13   Unless required by applicable law or agreed to in writing, software
14   distributed under the License is distributed on an "AS IS" BASIS,
15   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
16   See the License for the specific language governing permissions and
17   limitations under the License.
18 
19 */
20 
21 pragma solidity ^0.5.9;
22 
23 
24 library LibReentrancyGuardRichErrors {
25 
26     // bytes4(keccak256("IllegalReentrancyError()"))
27     bytes internal constant ILLEGAL_REENTRANCY_ERROR_SELECTOR_BYTES =
28         hex"0c3b823f";
29 
30     // solhint-disable func-name-mixedcase
31     function IllegalReentrancyError()
32         internal
33         pure
34         returns (bytes memory)
35     {
36         return ILLEGAL_REENTRANCY_ERROR_SELECTOR_BYTES;
37     }
38 }
39 
40 // File: @0x/contracts-utils/contracts/src/LibRichErrors.sol
41 
42 /*
43 
44   Copyright 2019 ZeroEx Intl.
45 
46   Licensed under the Apache License, Version 2.0 (the "License");
47   you may not use this file except in compliance with the License.
48   You may obtain a copy of the License at
49 
50     http://www.apache.org/licenses/LICENSE-2.0
51 
52   Unless required by applicable law or agreed to in writing, software
53   distributed under the License is distributed on an "AS IS" BASIS,
54   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
55   See the License for the specific language governing permissions and
56   limitations under the License.
57 
58 */
59 
60 pragma solidity ^0.5.9;
61 
62 
63 library LibRichErrors {
64 
65     // bytes4(keccak256("Error(string)"))
66     bytes4 internal constant STANDARD_ERROR_SELECTOR =
67         0x08c379a0;
68 
69     // solhint-disable func-name-mixedcase
70     /// @dev ABI encode a standard, string revert error payload.
71     ///      This is the same payload that would be included by a `revert(string)`
72     ///      solidity statement. It has the function signature `Error(string)`.
73     /// @param message The error string.
74     /// @return The ABI encoded error.
75     function StandardError(
76         string memory message
77     )
78         internal
79         pure
80         returns (bytes memory)
81     {
82         return abi.encodeWithSelector(
83             STANDARD_ERROR_SELECTOR,
84             bytes(message)
85         );
86     }
87     // solhint-enable func-name-mixedcase
88 
89     /// @dev Reverts an encoded rich revert reason `errorData`.
90     /// @param errorData ABI encoded error data.
91     function rrevert(bytes memory errorData)
92         internal
93         pure
94     {
95         assembly {
96             revert(add(errorData, 0x20), mload(errorData))
97         }
98     }
99 }
100 
101 // File: @0x/contracts-utils/contracts/src/ReentrancyGuard.sol
102 
103 /*
104 
105   Copyright 2019 ZeroEx Intl.
106 
107   Licensed under the Apache License, Version 2.0 (the "License");
108   you may not use this file except in compliance with the License.
109   You may obtain a copy of the License at
110 
111     http://www.apache.org/licenses/LICENSE-2.0
112 
113   Unless required by applicable law or agreed to in writing, software
114   distributed under the License is distributed on an "AS IS" BASIS,
115   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
116   See the License for the specific language governing permissions and
117   limitations under the License.
118 
119 */
120 
121 pragma solidity ^0.5.9;
122 
123 
124 
125 
126 contract ReentrancyGuard {
127 
128     // Locked state of mutex.
129     bool private _locked = false;
130 
131     /// @dev Functions with this modifer cannot be reentered. The mutex will be locked
132     ///      before function execution and unlocked after.
133     modifier nonReentrant() {
134         _lockMutexOrThrowIfAlreadyLocked();
135         _;
136         _unlockMutex();
137     }
138 
139     function _lockMutexOrThrowIfAlreadyLocked()
140         internal
141     {
142         // Ensure mutex is unlocked.
143         if (_locked) {
144             LibRichErrors.rrevert(
145                 LibReentrancyGuardRichErrors.IllegalReentrancyError()
146             );
147         }
148         // Lock mutex.
149         _locked = true;
150     }
151 
152     function _unlockMutex()
153         internal
154     {
155         // Unlock mutex.
156         _locked = false;
157     }
158 }
159 
160 // File: @0x/contracts-utils/contracts/src/LibSafeMathRichErrors.sol
161 
162 pragma solidity ^0.5.9;
163 
164 
165 library LibSafeMathRichErrors {
166 
167     // bytes4(keccak256("Uint256BinOpError(uint8,uint256,uint256)"))
168     bytes4 internal constant UINT256_BINOP_ERROR_SELECTOR =
169         0xe946c1bb;
170 
171     // bytes4(keccak256("Uint256DowncastError(uint8,uint256)"))
172     bytes4 internal constant UINT256_DOWNCAST_ERROR_SELECTOR =
173         0xc996af7b;
174 
175     enum BinOpErrorCodes {
176         ADDITION_OVERFLOW,
177         MULTIPLICATION_OVERFLOW,
178         SUBTRACTION_UNDERFLOW,
179         DIVISION_BY_ZERO
180     }
181 
182     enum DowncastErrorCodes {
183         VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT32,
184         VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT64,
185         VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT96
186     }
187 
188     // solhint-disable func-name-mixedcase
189     function Uint256BinOpError(
190         BinOpErrorCodes errorCode,
191         uint256 a,
192         uint256 b
193     )
194         internal
195         pure
196         returns (bytes memory)
197     {
198         return abi.encodeWithSelector(
199             UINT256_BINOP_ERROR_SELECTOR,
200             errorCode,
201             a,
202             b
203         );
204     }
205 
206     function Uint256DowncastError(
207         DowncastErrorCodes errorCode,
208         uint256 a
209     )
210         internal
211         pure
212         returns (bytes memory)
213     {
214         return abi.encodeWithSelector(
215             UINT256_DOWNCAST_ERROR_SELECTOR,
216             errorCode,
217             a
218         );
219     }
220 }
221 
222 // File: @0x/contracts-utils/contracts/src/LibSafeMath.sol
223 
224 pragma solidity ^0.5.9;
225 
226 
227 
228 
229 library LibSafeMath {
230 
231     function safeMul(uint256 a, uint256 b)
232         internal
233         pure
234         returns (uint256)
235     {
236         if (a == 0) {
237             return 0;
238         }
239         uint256 c = a * b;
240         if (c / a != b) {
241             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
242                 LibSafeMathRichErrors.BinOpErrorCodes.MULTIPLICATION_OVERFLOW,
243                 a,
244                 b
245             ));
246         }
247         return c;
248     }
249 
250     function safeDiv(uint256 a, uint256 b)
251         internal
252         pure
253         returns (uint256)
254     {
255         if (b == 0) {
256             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
257                 LibSafeMathRichErrors.BinOpErrorCodes.DIVISION_BY_ZERO,
258                 a,
259                 b
260             ));
261         }
262         uint256 c = a / b;
263         return c;
264     }
265 
266     function safeSub(uint256 a, uint256 b)
267         internal
268         pure
269         returns (uint256)
270     {
271         if (b > a) {
272             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
273                 LibSafeMathRichErrors.BinOpErrorCodes.SUBTRACTION_UNDERFLOW,
274                 a,
275                 b
276             ));
277         }
278         return a - b;
279     }
280 
281     function safeAdd(uint256 a, uint256 b)
282         internal
283         pure
284         returns (uint256)
285     {
286         uint256 c = a + b;
287         if (c < a) {
288             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
289                 LibSafeMathRichErrors.BinOpErrorCodes.ADDITION_OVERFLOW,
290                 a,
291                 b
292             ));
293         }
294         return c;
295     }
296 
297     function max256(uint256 a, uint256 b)
298         internal
299         pure
300         returns (uint256)
301     {
302         return a >= b ? a : b;
303     }
304 
305     function min256(uint256 a, uint256 b)
306         internal
307         pure
308         returns (uint256)
309     {
310         return a < b ? a : b;
311     }
312 }
313 
314 // File: contracts/vault/Operational.sol
315 
316 /*
317 
318   Copyright 2020 Metaps Alpha Inc.
319 
320   Licensed under the Apache License, Version 2.0 (the "License");
321   you may not use this file except in compliance with the License.
322   You may obtain a copy of the License at
323 
324     http://www.apache.org/licenses/LICENSE-2.0
325 
326   Unless required by applicable law or agreed to in writing, software
327   distributed under the License is distributed on an "AS IS" BASIS,
328   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
329   See the License for the specific language governing permissions and
330   limitations under the License.
331 
332 */
333 pragma solidity 0.5.17;
334 
335 
336 contract Operational {
337     address public owner;
338     address[] public operators;
339     mapping (address => bool) public isOperator;
340 
341     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
342     event OperatorAdded(address indexed target, address indexed caller);
343     event OperatorRemoved(address indexed target, address indexed caller);
344 
345     constructor () public {
346         owner = msg.sender;
347     }
348 
349     modifier onlyOwner() {
350         require(msg.sender == owner, "ONLY_CONTRACT_OWNER");
351         _;
352     }
353 
354     modifier onlyOperator() {
355         require(isOperator[msg.sender], "SENDER_IS_NOT_OPERATOR");
356         _;
357     }
358 
359     function transferOwnership(address newOwner) public onlyOwner {
360         require(newOwner != address(0), "INVALID_OWNER");
361         emit OwnershipTransferred(owner, newOwner);
362         owner = newOwner;
363     }
364 
365     function addOperator(address target) external onlyOwner {
366         require(!isOperator[target], "TARGET_IS_ALREADY_OPERATOR");
367         isOperator[target] = true;
368         operators.push(target);
369         emit OperatorAdded(target, msg.sender);
370     }
371 
372     function removeOperator(address target) external onlyOwner {
373         require(isOperator[target], "TARGET_IS_NOT_OPERATOR");
374         delete isOperator[target];
375         for (uint256 i = 0; i < operators.length; i++) {
376             if (operators[i] == target) {
377                 operators[i] = operators[operators.length - 1];
378                 operators.length -= 1;
379                 break;
380             }
381         }
382         emit OperatorRemoved(target, msg.sender);
383     }
384 }
385 
386 // File: @openzeppelin/contracts/GSN/Context.sol
387 
388 pragma solidity ^0.5.0;
389 
390 /*
391  * @dev Provides information about the current execution context, including the
392  * sender of the transaction and its data. While these are generally available
393  * via msg.sender and msg.data, they should not be accessed in such a direct
394  * manner, since when dealing with GSN meta-transactions the account sending and
395  * paying for execution may not be the actual sender (as far as an application
396  * is concerned).
397  *
398  * This contract is only required for intermediate, library-like contracts.
399  */
400 contract Context {
401     // Empty internal constructor, to prevent people from mistakenly deploying
402     // an instance of this contract, which should be used via inheritance.
403     constructor () internal { }
404     // solhint-disable-previous-line no-empty-blocks
405 
406     function _msgSender() internal view returns (address payable) {
407         return msg.sender;
408     }
409 
410     function _msgData() internal view returns (bytes memory) {
411         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
412         return msg.data;
413     }
414 }
415 
416 // File: @openzeppelin/contracts/access/Roles.sol
417 
418 pragma solidity ^0.5.0;
419 
420 /**
421  * @title Roles
422  * @dev Library for managing addresses assigned to a Role.
423  */
424 library Roles {
425     struct Role {
426         mapping (address => bool) bearer;
427     }
428 
429     /**
430      * @dev Give an account access to this role.
431      */
432     function add(Role storage role, address account) internal {
433         require(!has(role, account), "Roles: account already has role");
434         role.bearer[account] = true;
435     }
436 
437     /**
438      * @dev Remove an account's access to this role.
439      */
440     function remove(Role storage role, address account) internal {
441         require(has(role, account), "Roles: account does not have role");
442         role.bearer[account] = false;
443     }
444 
445     /**
446      * @dev Check if an account has this role.
447      * @return bool
448      */
449     function has(Role storage role, address account) internal view returns (bool) {
450         require(account != address(0), "Roles: account is the zero address");
451         return role.bearer[account];
452     }
453 }
454 
455 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
456 
457 pragma solidity ^0.5.0;
458 
459 
460 
461 contract PauserRole is Context {
462     using Roles for Roles.Role;
463 
464     event PauserAdded(address indexed account);
465     event PauserRemoved(address indexed account);
466 
467     Roles.Role private _pausers;
468 
469     constructor () internal {
470         _addPauser(_msgSender());
471     }
472 
473     modifier onlyPauser() {
474         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
475         _;
476     }
477 
478     function isPauser(address account) public view returns (bool) {
479         return _pausers.has(account);
480     }
481 
482     function addPauser(address account) public onlyPauser {
483         _addPauser(account);
484     }
485 
486     function renouncePauser() public {
487         _removePauser(_msgSender());
488     }
489 
490     function _addPauser(address account) internal {
491         _pausers.add(account);
492         emit PauserAdded(account);
493     }
494 
495     function _removePauser(address account) internal {
496         _pausers.remove(account);
497         emit PauserRemoved(account);
498     }
499 }
500 
501 // File: contracts/vault/Pausable.sol
502 
503 pragma solidity ^0.5.16;
504 
505 
506 
507 contract Pausable is PauserRole {
508     event Paused(address account);
509     event Unpaused(address account);
510 
511     bool private _paused;
512 
513     constructor() internal {
514         _paused = false;
515     }
516 
517     function paused() public view returns (bool) {
518         return _paused;
519     }
520 
521     modifier whenNotPaused() {
522         require(!_paused, "paused");
523         _;
524     }
525 
526     modifier whenPaused() {
527         require(_paused, "not paused");
528         _;
529     }
530 
531     function pause() public onlyPauser whenNotPaused {
532         _paused = true;
533         emit Paused(_msgSender());
534     }
535 
536     function unpause() public onlyPauser whenPaused {
537         _paused = false;
538         emit Unpaused(_msgSender());
539     }
540 }
541 
542 // File: contracts/vault/Vault.sol
543 
544 /*
545 
546   Copyright 2020 Metaps Alpha Inc.
547 
548   Licensed under the Apache License, Version 2.0 (the "License");
549   you may not use this file except in compliance with the License.
550   You may obtain a copy of the License at
551 
552     http://www.apache.org/licenses/LICENSE-2.0
553 
554   Unless required by applicable law or agreed to in writing, software
555   distributed under the License is distributed on an "AS IS" BASIS,
556   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
557   See the License for the specific language governing permissions and
558   limitations under the License.
559 
560 */
561 pragma solidity 0.5.17;
562 
563 
564 
565 
566 
567 
568 contract Vault is Operational, Pausable, ReentrancyGuard {
569     using LibSafeMath for uint256;
570 
571     event Deposit(bytes32 indexed orderHash, address indexed from, address indexed to, uint256 amount, uint256 gasFee);
572     event Pay(bytes32 indexed orderHash, address indexed from, address indexed to, uint256 amount);
573     event Refund(bytes32 indexed orderHash, address indexed from, address indexed to, uint256 amount);
574 
575     struct DepositInfo {
576         address payable from;
577         address payable to;
578         uint256 gasFee;
579         bool filled;
580     }
581 
582     // orderHash -> amount -> DepositInfo
583     mapping (bytes32 => mapping (uint256 => DepositInfo)) public depositInfo;
584     uint256 public miimeRevenue;
585     uint256 public issuerRevenue;
586     uint256 public gasLimit = 300000;
587 
588     function () external payable {
589         miimeRevenue = miimeRevenue.safeAdd(msg.value);
590     }
591 
592     function deposit(bytes32 orderHash, uint256 amount, uint256 gasFee, address payable to) external payable nonReentrant whenNotPaused {
593         require(amount.safeAdd(gasFee) == msg.value, 'invalid amount and gasFee');
594         require(depositInfo[orderHash][amount].from == address(0), 'already exist deposit');
595         require(!depositInfo[orderHash][amount].filled, 'already filled');
596         depositInfo[orderHash][amount] = DepositInfo(msg.sender, to, gasFee, false);
597         emit Deposit(orderHash, msg.sender, to, amount, gasFee);
598     }
599 
600     function pay(bytes32 orderHash, uint256 amount, uint256 miimeFeeAmount, uint256 issuerFeeAmount) external nonReentrant onlyOperator {
601         require(depositInfo[orderHash][amount].from != address(0), 'not exist deposit');
602         require(!depositInfo[orderHash][amount].filled, 'already filled');
603 
604         address from = depositInfo[orderHash][amount].from;
605         address payable to = depositInfo[orderHash][amount].to;
606         uint256 gasFee = depositInfo[orderHash][amount].gasFee;
607         depositInfo[orderHash][amount].filled = true;
608         depositInfo[orderHash][amount].from = address(0); // to save gas
609         depositInfo[orderHash][amount].to = address(0); // to save gas
610         depositInfo[orderHash][amount].gasFee = 0; // to save gas
611 
612         (bool success, bytes memory _data) = to.call.gas(gasLimit).value(amount.safeSub(miimeFeeAmount).safeSub(issuerFeeAmount))('');
613         require(success, 'failed eth sending');
614 
615         miimeRevenue = miimeRevenue.safeAdd(miimeFeeAmount).safeAdd(gasFee);
616         issuerRevenue = issuerRevenue.safeAdd(issuerFeeAmount);
617 
618         emit Pay(orderHash, from, to, amount);
619     }
620 
621     function refund(bytes32 orderHash, uint256 amount) external nonReentrant onlyOperator {
622         require(depositInfo[orderHash][amount].from != address(0), 'not exist deposit');
623         require(!depositInfo[orderHash][amount].filled, 'already filled');
624 
625         address payable from = depositInfo[orderHash][amount].from;
626         address to = depositInfo[orderHash][amount].to;
627         uint256 gasFee = depositInfo[orderHash][amount].gasFee;
628         delete depositInfo[orderHash][amount];
629 
630         (bool success, bytes memory _data) = from.call.gas(gasLimit).value(amount)('');
631         require(success, 'failed eth sending');
632 
633         miimeRevenue = miimeRevenue.safeAdd(gasFee);
634 
635         emit Refund(orderHash, from, to, amount);
636     }
637 
638     function withdrawMiimeRevenue(address payable to) external nonReentrant onlyOperator {
639         (bool success, bytes memory _data) = to.call.gas(gasLimit).value(miimeRevenue)('');
640         require(success, 'failed eth sending');
641         miimeRevenue = 0;
642     }
643 
644     function withdrawIssuerRevenue(address payable to) external nonReentrant onlyOperator {
645         (bool success, bytes memory _data) = to.call.gas(gasLimit).value(issuerRevenue)('');
646         require(success, 'failed eth sending');
647         issuerRevenue = 0;
648     }
649 
650     function setGasLimit(uint256 newGasLimit) external nonReentrant onlyOperator {
651         gasLimit = newGasLimit;
652     }
653 }