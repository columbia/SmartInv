1 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
6 
7 // import "./IERC20.sol";
8 // import "../../math/SafeMath.sol";
9 // import "../../utils/Address.sol";
10 
11 /**
12  * @title SafeERC20
13  * @dev Wrappers around ERC20 operations that throw on failure (when the token
14  * contract returns false). Tokens that return no value (and instead revert or
15  * throw on failure) are also supported, non-reverting calls are assumed to be
16  * successful.
17  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
18  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
19  */
20 library SafeERC20 {
21     using SafeMath for uint256;
22     using Address for address;
23 
24     function safeTransfer(IERC20 token, address to, uint256 value) internal {
25         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
26     }
27 
28     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
29         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
30     }
31 
32     /**
33      * @dev Deprecated. This function has issues similar to the ones found in
34      * {IERC20-approve}, and its usage is discouraged.
35      *
36      * Whenever possible, use {safeIncreaseAllowance} and
37      * {safeDecreaseAllowance} instead.
38      */
39     function safeApprove(IERC20 token, address spender, uint256 value) internal {
40         // safeApprove should only be called when setting an initial allowance,
41         // or when resetting it to zero. To increase and decrease it, use
42         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
43         // solhint-disable-next-line max-line-length
44         require((value == 0) || (token.allowance(address(this), spender) == 0),
45             "SafeERC20: approve from non-zero to non-zero allowance"
46         );
47         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
48     }
49 
50     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
51         uint256 newAllowance = token.allowance(address(this), spender).add(value);
52         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
53     }
54 
55     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
56         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
57         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
58     }
59 
60     /**
61      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
62      * on the return value: the return value is optional (but if data is returned, it must not be false).
63      * @param token The token targeted by the call.
64      * @param data The call data (encoded using abi.encode or one of its variants).
65      */
66     function _callOptionalReturn(IERC20 token, bytes memory data) private {
67         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
68         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
69         // the target address contains contract code and also asserts for success in the low-level call.
70 
71         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
72         if (returndata.length > 0) { // Return data is optional
73             // solhint-disable-next-line max-line-length
74             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
75         }
76     }
77 }
78 
79 // Dependency file: contracts/interfaces/ISetValuer.sol
80 
81 /*
82     Copyright 2020 Set Labs Inc.
83 
84     Licensed under the Apache License, Version 2.0 (the "License");
85     you may not use this file except in compliance with the License.
86     You may obtain a copy of the License at
87 
88     http://www.apache.org/licenses/LICENSE-2.0
89 
90     Unless required by applicable law or agreed to in writing, software
91     distributed under the License is distributed on an "AS IS" BASIS,
92     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
93     See the License for the specific language governing permissions and
94     limitations under the License.
95 */
96 // pragma solidity 0.6.10;
97 
98 // import { ISetToken } from "../interfaces/ISetToken.sol";
99 
100 interface ISetValuer {
101     function calculateSetTokenValuation(ISetToken _setToken, address _quoteAsset) external view returns (uint256);
102 }
103 // Dependency file: contracts/interfaces/IPriceOracle.sol
104 
105 /*
106     Copyright 2020 Set Labs Inc.
107 
108     Licensed under the Apache License, Version 2.0 (the "License");
109     you may not use this file except in compliance with the License.
110     You may obtain a copy of the License at
111 
112     http://www.apache.org/licenses/LICENSE-2.0
113 
114     Unless required by applicable law or agreed to in writing, software
115     distributed under the License is distributed on an "AS IS" BASIS,
116     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
117     See the License for the specific language governing permissions and
118     limitations under the License.
119 */
120 // pragma solidity 0.6.10;
121 
122 /**
123  * @title IPriceOracle
124  * @author Set Protocol
125  *
126  * Interface for interacting with PriceOracle
127  */
128 interface IPriceOracle {
129 
130     /* ============ Functions ============ */
131 
132     function getPrice(address _assetOne, address _assetTwo) external view returns (uint256);
133     function masterQuoteAsset() external view returns (address);
134 }
135 // Dependency file: contracts/interfaces/IIntegrationRegistry.sol
136 
137 /*
138     Copyright 2020 Set Labs Inc.
139 
140     Licensed under the Apache License, Version 2.0 (the "License");
141     you may not use this file except in compliance with the License.
142     You may obtain a copy of the License at
143 
144     http://www.apache.org/licenses/LICENSE-2.0
145 
146     Unless required by applicable law or agreed to in writing, software
147     distributed under the License is distributed on an "AS IS" BASIS,
148     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
149     See the License for the specific language governing permissions and
150     limitations under the License.
151 */
152 // pragma solidity 0.6.10;
153 
154 interface IIntegrationRegistry {
155     function addIntegration(address _module, string memory _id, address _wrapper) external;
156     function getIntegrationAdapter(address _module, string memory _id) external view returns(address);
157     function getIntegrationAdapterWithHash(address _module, bytes32 _id) external view returns(address);
158     function isValidIntegration(address _module, string memory _id) external view returns(bool);
159 }
160 // Dependency file: contracts/interfaces/IModule.sol
161 
162 /*
163     Copyright 2020 Set Labs Inc.
164 
165     Licensed under the Apache License, Version 2.0 (the "License");
166     you may not use this file except in compliance with the License.
167     You may obtain a copy of the License at
168 
169     http://www.apache.org/licenses/LICENSE-2.0
170 
171     Unless required by applicable law or agreed to in writing, software
172     distributed under the License is distributed on an "AS IS" BASIS,
173     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
174     See the License for the specific language governing permissions and
175     limitations under the License.
176 */
177 // pragma solidity 0.6.10;
178 
179 
180 /**
181  * @title IModule
182  * @author Set Protocol
183  *
184  * Interface for interacting with Modules.
185  */
186 interface IModule {
187     /**
188      * Called by a SetToken to notify that this module was removed from the Set token. Any logic can be included
189      * in case checks need to be made or state needs to be cleared.
190      */
191     function removeModule() external;
192 }
193 // Dependency file: contracts/lib/ExplicitERC20.sol
194 
195 /*
196     Copyright 2020 Set Labs Inc.
197 
198     Licensed under the Apache License, Version 2.0 (the "License");
199     you may not use this file except in compliance with the License.
200     You may obtain a copy of the License at
201 
202     http://www.apache.org/licenses/LICENSE-2.0
203 
204     Unless required by applicable law or agreed to in writing, software
205     distributed under the License is distributed on an "AS IS" BASIS,
206     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
207     See the License for the specific language governing permissions and
208     limitations under the License.
209 */
210 
211 // pragma solidity 0.6.10;
212 
213 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
214 // import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
215 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
216 
217 /**
218  * @title ExplicitERC20
219  * @author Set Protocol
220  *
221  * Utility functions for ERC20 transfers that require the explicit amount to be transferred.
222  */
223 library ExplicitERC20 {
224     using SafeMath for uint256;
225 
226     /**
227      * When given allowance, transfers a token from the "_from" to the "_to" of quantity "_quantity".
228      * Ensures that the recipient has received the correct quantity (ie no fees taken on transfer)
229      *
230      * @param _token           ERC20 token to approve
231      * @param _from            The account to transfer tokens from
232      * @param _to              The account to transfer tokens to
233      * @param _quantity        The quantity to transfer
234      */
235     function transferFrom(
236         IERC20 _token,
237         address _from,
238         address _to,
239         uint256 _quantity
240     )
241         internal
242     {
243         // Call specified ERC20 contract to transfer tokens (via proxy).
244         if (_quantity > 0) {
245             uint256 existingBalance = _token.balanceOf(_to);
246 
247             SafeERC20.safeTransferFrom(
248                 _token,
249                 _from,
250                 _to,
251                 _quantity
252             );
253 
254             uint256 newBalance = _token.balanceOf(_to);
255 
256             // Verify transfer quantity is reflected in balance
257             require(
258                 newBalance == existingBalance.add(_quantity),
259                 "Invalid post transfer balance"
260             );
261         }
262     }
263 }
264 
265 // Dependency file: @openzeppelin/contracts/utils/Address.sol
266 
267 // pragma solidity ^0.6.2;
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [// importANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { codehash := extcodehash(account) }
298         return (codehash != accountHash && codehash != 0x0);
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * // importANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success, ) = recipient.call{ value: amount }("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344       return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
408 
409 // pragma solidity ^0.6.0;
410 
411 /*
412  * @dev Provides information about the current execution context, including the
413  * sender of the transaction and its data. While these are generally available
414  * via msg.sender and msg.data, they should not be accessed in such a direct
415  * manner, since when dealing with GSN meta-transactions the account sending and
416  * paying for execution may not be the actual sender (as far as an application
417  * is concerned).
418  *
419  * This contract is only required for intermediate, library-like contracts.
420  */
421 abstract contract Context {
422     function _msgSender() internal view virtual returns (address payable) {
423         return msg.sender;
424     }
425 
426     function _msgData() internal view virtual returns (bytes memory) {
427         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
428         return msg.data;
429     }
430 }
431 
432 // Dependency file: contracts/protocol/lib/ResourceIdentifier.sol
433 
434 /*
435     Copyright 2020 Set Labs Inc.
436 
437     Licensed under the Apache License, Version 2.0 (the "License");
438     you may not use this file except in compliance with the License.
439     You may obtain a copy of the License at
440 
441     http://www.apache.org/licenses/LICENSE-2.0
442 
443     Unless required by applicable law or agreed to in writing, software
444     distributed under the License is distributed on an "AS IS" BASIS,
445     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
446     See the License for the specific language governing permissions and
447     limitations under the License.
448 */
449 
450 // pragma solidity 0.6.10;
451 
452 // import { IController } from "../../interfaces/IController.sol";
453 // import { IIntegrationRegistry } from "../../interfaces/IIntegrationRegistry.sol";
454 // import { IPriceOracle } from "../../interfaces/IPriceOracle.sol";
455 // import { ISetValuer } from "../../interfaces/ISetValuer.sol";
456 
457 /**
458  * @title ResourceIdentifier
459  * @author Set Protocol
460  *
461  * A collection of utility functions to fetch information related to Resource contracts in the system
462  */
463 library ResourceIdentifier {
464 
465     // IntegrationRegistry will always be resource ID 0 in the system
466     uint256 constant internal INTEGRATION_REGISTRY_RESOURCE_ID = 0;
467     // PriceOracle will always be resource ID 1 in the system
468     uint256 constant internal PRICE_ORACLE_RESOURCE_ID = 1;
469     // SetValuer resource will always be resource ID 2 in the system
470     uint256 constant internal SET_VALUER_RESOURCE_ID = 2;
471 
472     /* ============ Internal ============ */
473 
474     /**
475      * Gets the instance of integration registry stored on Controller. Note: IntegrationRegistry is stored as index 0 on
476      * the Controller
477      */
478     function getIntegrationRegistry(IController _controller) internal view returns (IIntegrationRegistry) {
479         return IIntegrationRegistry(_controller.resourceId(INTEGRATION_REGISTRY_RESOURCE_ID));
480     }
481 
482     /**
483      * Gets instance of price oracle on Controller. Note: PriceOracle is stored as index 1 on the Controller
484      */
485     function getPriceOracle(IController _controller) internal view returns (IPriceOracle) {
486         return IPriceOracle(_controller.resourceId(PRICE_ORACLE_RESOURCE_ID));
487     }
488 
489     /**
490      * Gets the instance of Set valuer on Controller. Note: SetValuer is stored as index 2 on the Controller
491      */
492     function getSetValuer(IController _controller) internal view returns (ISetValuer) {
493         return ISetValuer(_controller.resourceId(SET_VALUER_RESOURCE_ID));
494     }
495 }
496 // Dependency file: contracts/lib/PreciseUnitMath.sol
497 
498 /*
499     Copyright 2020 Set Labs Inc.
500 
501     Licensed under the Apache License, Version 2.0 (the "License");
502     you may not use this file except in compliance with the License.
503     You may obtain a copy of the License at
504 
505     http://www.apache.org/licenses/LICENSE-2.0
506 
507     Unless required by applicable law or agreed to in writing, software
508     distributed under the License is distributed on an "AS IS" BASIS,
509     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
510     See the License for the specific language governing permissions and
511     limitations under the License.
512 */
513 
514 // pragma solidity 0.6.10;
515 // pragma experimental ABIEncoderV2;
516 
517 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
518 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
519 
520 
521 /**
522  * @title PreciseUnitMath
523  * @author Set Protocol
524  *
525  * Arithmetic for fixed-point numbers with 18 decimals of precision. Some functions taken from
526  * dYdX's BaseMath library.
527  *
528  * CHANGELOG:
529  * - 9/21/20: Added safePower function
530  */
531 library PreciseUnitMath {
532     using SafeMath for uint256;
533     using SignedSafeMath for int256;
534 
535     // The number One in precise units.
536     uint256 constant internal PRECISE_UNIT = 10 ** 18;
537     int256 constant internal PRECISE_UNIT_INT = 10 ** 18;
538 
539     // Max unsigned integer value
540     uint256 constant internal MAX_UINT_256 = type(uint256).max;
541     // Max and min signed integer value
542     int256 constant internal MAX_INT_256 = type(int256).max;
543     int256 constant internal MIN_INT_256 = type(int256).min;
544 
545     /**
546      * @dev Getter function since constants can't be read directly from libraries.
547      */
548     function preciseUnit() internal pure returns (uint256) {
549         return PRECISE_UNIT;
550     }
551 
552     /**
553      * @dev Getter function since constants can't be read directly from libraries.
554      */
555     function preciseUnitInt() internal pure returns (int256) {
556         return PRECISE_UNIT_INT;
557     }
558 
559     /**
560      * @dev Getter function since constants can't be read directly from libraries.
561      */
562     function maxUint256() internal pure returns (uint256) {
563         return MAX_UINT_256;
564     }
565 
566     /**
567      * @dev Getter function since constants can't be read directly from libraries.
568      */
569     function maxInt256() internal pure returns (int256) {
570         return MAX_INT_256;
571     }
572 
573     /**
574      * @dev Getter function since constants can't be read directly from libraries.
575      */
576     function minInt256() internal pure returns (int256) {
577         return MIN_INT_256;
578     }
579 
580     /**
581      * @dev Multiplies value a by value b (result is rounded down). It's assumed that the value b is the significand
582      * of a number with 18 decimals precision.
583      */
584     function preciseMul(uint256 a, uint256 b) internal pure returns (uint256) {
585         return a.mul(b).div(PRECISE_UNIT);
586     }
587 
588     /**
589      * @dev Multiplies value a by value b (result is rounded towards zero). It's assumed that the value b is the
590      * significand of a number with 18 decimals precision.
591      */
592     function preciseMul(int256 a, int256 b) internal pure returns (int256) {
593         return a.mul(b).div(PRECISE_UNIT_INT);
594     }
595 
596     /**
597      * @dev Multiplies value a by value b (result is rounded up). It's assumed that the value b is the significand
598      * of a number with 18 decimals precision.
599      */
600     function preciseMulCeil(uint256 a, uint256 b) internal pure returns (uint256) {
601         if (a == 0 || b == 0) {
602             return 0;
603         }
604         return a.mul(b).sub(1).div(PRECISE_UNIT).add(1);
605     }
606 
607     /**
608      * @dev Divides value a by value b (result is rounded down).
609      */
610     function preciseDiv(uint256 a, uint256 b) internal pure returns (uint256) {
611         return a.mul(PRECISE_UNIT).div(b);
612     }
613 
614 
615     /**
616      * @dev Divides value a by value b (result is rounded towards 0).
617      */
618     function preciseDiv(int256 a, int256 b) internal pure returns (int256) {
619         return a.mul(PRECISE_UNIT_INT).div(b);
620     }
621 
622     /**
623      * @dev Divides value a by value b (result is rounded up or away from 0).
624      */
625     function preciseDivCeil(uint256 a, uint256 b) internal pure returns (uint256) {
626         require(b != 0, "Cant divide by 0");
627 
628         return a > 0 ? a.mul(PRECISE_UNIT).sub(1).div(b).add(1) : 0;
629     }
630 
631     /**
632      * @dev Divides value a by value b (result is rounded down - positive numbers toward 0 and negative away from 0).
633      */
634     function divDown(int256 a, int256 b) internal pure returns (int256) {
635         require(b != 0, "Cant divide by 0");
636         require(a != MIN_INT_256 || b != -1, "Invalid input");
637 
638         int256 result = a.div(b);
639         if (a ^ b < 0 && a % b != 0) {
640             result -= 1;
641         }
642 
643         return result;
644     }
645 
646     /**
647      * @dev Multiplies value a by value b where rounding is towards the lesser number. 
648      * (positive values are rounded towards zero and negative values are rounded away from 0). 
649      */
650     function conservativePreciseMul(int256 a, int256 b) internal pure returns (int256) {
651         return divDown(a.mul(b), PRECISE_UNIT_INT);
652     }
653 
654     /**
655      * @dev Divides value a by value b where rounding is towards the lesser number. 
656      * (positive values are rounded towards zero and negative values are rounded away from 0). 
657      */
658     function conservativePreciseDiv(int256 a, int256 b) internal pure returns (int256) {
659         return divDown(a.mul(PRECISE_UNIT_INT), b);
660     }
661 
662     /**
663     * @dev Performs the power on a specified value, reverts on overflow.
664     */
665     function safePower(
666         uint256 a,
667         uint256 pow
668     )
669         internal
670         pure
671         returns (uint256)
672     {
673         require(a > 0, "Value must be positive");
674 
675         uint256 result = 1;
676         for (uint256 i = 0; i < pow; i++){
677             uint256 previousResult = result;
678 
679             // Using safemath multiplication prevents overflows
680             result = previousResult.mul(a);
681         }
682 
683         return result;
684     }
685 }
686 // Dependency file: contracts/protocol/lib/Position.sol
687 
688 /*
689     Copyright 2020 Set Labs Inc.
690 
691     Licensed under the Apache License, Version 2.0 (the "License");
692     you may not use this file except in compliance with the License.
693     You may obtain a copy of the License at
694 
695     http://www.apache.org/licenses/LICENSE-2.0
696 
697     Unless required by applicable law or agreed to in writing, software
698     distributed under the License is distributed on an "AS IS" BASIS,
699     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
700     See the License for the specific language governing permissions and
701     limitations under the License.
702 */
703 
704 // pragma solidity 0.6.10;
705 // pragma experimental "ABIEncoderV2";
706 
707 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
708 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
709 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
710 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
711 
712 // import { ISetToken } from "../../interfaces/ISetToken.sol";
713 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
714 
715 /**
716  * @title Position
717  * @author Set Protocol
718  *
719  * Collection of helper functions for handling and updating SetToken Positions
720  */
721 library Position {
722     using SafeCast for uint256;
723     using SafeMath for uint256;
724     using SafeCast for int256;
725     using SignedSafeMath for int256;
726     using PreciseUnitMath for uint256;
727 
728     /* ============ Helper ============ */
729 
730     /**
731      * Returns whether the SetToken has a default position for a given component (if the real unit is > 0)
732      */
733     function hasDefaultPosition(ISetToken _setToken, address _component) internal view returns(bool) {
734         return _setToken.getDefaultPositionRealUnit(_component) > 0;
735     }
736 
737     /**
738      * Returns whether the SetToken has an external position for a given component (if # of position modules is > 0)
739      */
740     function hasExternalPosition(ISetToken _setToken, address _component) internal view returns(bool) {
741         return _setToken.getExternalPositionModules(_component).length > 0;
742     }
743     
744     /**
745      * Returns whether the SetToken component default position real unit is greater than or equal to units passed in.
746      */
747     function hasSufficientDefaultUnits(ISetToken _setToken, address _component, uint256 _unit) internal view returns(bool) {
748         return _setToken.getDefaultPositionRealUnit(_component) >= _unit.toInt256();
749     }
750 
751     /**
752      * Returns whether the SetToken component external position is greater than or equal to the real units passed in.
753      */
754     function hasSufficientExternalUnits(
755         ISetToken _setToken,
756         address _component,
757         address _positionModule,
758         uint256 _unit
759     )
760         internal
761         view
762         returns(bool)
763     {
764        return _setToken.getExternalPositionRealUnit(_component, _positionModule) >= _unit.toInt256();    
765     }
766 
767     /**
768      * If the position does not exist, create a new Position and add to the SetToken. If it already exists,
769      * then set the position units. If the new units is 0, remove the position. Handles adding/removing of 
770      * components where needed (in light of potential external positions).
771      *
772      * @param _setToken           Address of SetToken being modified
773      * @param _component          Address of the component
774      * @param _newUnit            Quantity of Position units - must be >= 0
775      */
776     function editDefaultPosition(ISetToken _setToken, address _component, uint256 _newUnit) internal {
777         bool isPositionFound = hasDefaultPosition(_setToken, _component);
778         if (!isPositionFound && _newUnit > 0) {
779             // If there is no Default Position and no External Modules, then component does not exist
780             if (!hasExternalPosition(_setToken, _component)) {
781                 _setToken.addComponent(_component);
782             }
783         } else if (isPositionFound && _newUnit == 0) {
784             // If there is a Default Position and no external positions, remove the component
785             if (!hasExternalPosition(_setToken, _component)) {
786                 _setToken.removeComponent(_component);
787             }
788         }
789 
790         _setToken.editDefaultPositionUnit(_component, _newUnit.toInt256());
791     }
792 
793     /**
794      * Update an external position and remove and external positions or components if necessary. The logic flows as follows:
795      * 1) If component is not already added then add component and external position. 
796      * 2) If component is added but no existing external position using the passed module exists then add the external position.
797      * 3) If the existing position is being added to then just update the unit
798      * 4) If the position is being closed and no other external positions or default positions are associated with the component
799      *    then untrack the component and remove external position.
800      * 5) If the position is being closed and  other existing positions still exist for the component then just remove the
801      *    external position.
802      *
803      * @param _setToken         SetToken being updated
804      * @param _component        Component position being updated
805      * @param _module           Module external position is associated with
806      * @param _newUnit          Position units of new external position
807      * @param _data             Arbitrary data associated with the position
808      */
809     function editExternalPosition(
810         ISetToken _setToken,
811         address _component,
812         address _module,
813         int256 _newUnit,
814         bytes memory _data
815     )
816         internal
817     {
818         if (!_setToken.isComponent(_component)) {
819             _setToken.addComponent(_component);
820             addExternalPosition(_setToken, _component, _module, _newUnit, _data);
821         } else if (!_setToken.isExternalPositionModule(_component, _module)) {
822             addExternalPosition(_setToken, _component, _module, _newUnit, _data);
823         } else if (_newUnit != 0) {
824             _setToken.editExternalPositionUnit(_component, _module, _newUnit);
825         } else {
826             // If no default or external position remaining then remove component from components array
827             if (_setToken.getDefaultPositionRealUnit(_component) == 0 && _setToken.getExternalPositionModules(_component).length == 1) {
828                 _setToken.removeComponent(_component);
829             }
830             _setToken.removeExternalPositionModule(_component, _module);
831         }
832     }
833 
834     /**
835      * Add a new external position from a previously untracked module.
836      *
837      * @param _setToken         SetToken being updated
838      * @param _component        Component position being updated
839      * @param _module           Module external position is associated with
840      * @param _newUnit          Position units of new external position
841      * @param _data             Arbitrary data associated with the position
842      */
843     function addExternalPosition(
844         ISetToken _setToken,
845         address _component,
846         address _module,
847         int256 _newUnit,
848         bytes memory _data
849     )
850         internal
851     {
852         _setToken.addExternalPositionModule(_component, _module);
853         _setToken.editExternalPositionUnit(_component, _module, _newUnit);
854         _setToken.editExternalPositionData(_component, _module, _data);
855     }
856 
857     /**
858      * Get total notional amount of Default position
859      *
860      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
861      * @param _positionUnit       Quantity of Position units
862      *
863      * @return                    Total notional amount of units
864      */
865     function getDefaultTotalNotional(uint256 _setTokenSupply, uint256 _positionUnit) internal pure returns (uint256) {
866         return _setTokenSupply.preciseMul(_positionUnit);
867     }
868 
869     /**
870      * Get position unit from total notional amount
871      *
872      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
873      * @param _totalNotional      Total notional amount of component prior to
874      * @return                    Default position unit
875      */
876     function getDefaultPositionUnit(uint256 _setTokenSupply, uint256 _totalNotional) internal pure returns (uint256) {
877         return _totalNotional.preciseDiv(_setTokenSupply);
878     }
879 
880     /**
881      * Get the total tracked balance - total supply * position unit
882      *
883      * @param _setToken           Address of the SetToken
884      * @param _component          Address of the component
885      * @return                    Notional tracked balance
886      */
887     function getDefaultTrackedBalance(ISetToken _setToken, address _component) internal view returns(uint256) {
888         int256 positionUnit = _setToken.getDefaultPositionRealUnit(_component); 
889         return _setToken.totalSupply().preciseMul(positionUnit.toUint256());
890     }
891 
892     /**
893      * Calculates the new default position unit and performs the edit with the new unit
894      *
895      * @param _setToken                 Address of the SetToken
896      * @param _component                Address of the component
897      * @param _setTotalSupply           Current SetToken supply
898      * @param _componentPreviousBalance Pre-action component balance
899      * @return                          Current component balance
900      * @return                          Previous position unit
901      * @return                          New position unit
902      */
903     function calculateAndEditDefaultPosition(
904         ISetToken _setToken,
905         address _component,
906         uint256 _setTotalSupply,
907         uint256 _componentPreviousBalance
908     )
909         internal
910         returns(uint256, uint256, uint256)
911     {
912         uint256 currentBalance = IERC20(_component).balanceOf(address(_setToken));
913         uint256 positionUnit = _setToken.getDefaultPositionRealUnit(_component).toUint256();
914 
915         uint256 newTokenUnit = calculateDefaultEditPositionUnit(
916             _setTotalSupply,
917             _componentPreviousBalance,
918             currentBalance,
919             positionUnit
920         );
921 
922         editDefaultPosition(_setToken, _component, newTokenUnit);
923 
924         return (currentBalance, positionUnit, newTokenUnit);
925     }
926 
927     /**
928      * Calculate the new position unit given total notional values pre and post executing an action that changes SetToken state
929      * The intention is to make updates to the units without accidentally picking up airdropped assets as well.
930      *
931      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
932      * @param _preTotalNotional   Total notional amount of component prior to executing action
933      * @param _postTotalNotional  Total notional amount of component after the executing action
934      * @param _prePositionUnit    Position unit of SetToken prior to executing action
935      * @return                    New position unit
936      */
937     function calculateDefaultEditPositionUnit(
938         uint256 _setTokenSupply,
939         uint256 _preTotalNotional,
940         uint256 _postTotalNotional,
941         uint256 _prePositionUnit
942     )
943         internal
944         pure
945         returns (uint256)
946     {
947         // If pre action total notional amount is greater then subtract post action total notional and calculate new position units
948         if (_preTotalNotional >= _postTotalNotional) {
949             uint256 unitsToSub = _preTotalNotional.sub(_postTotalNotional).preciseDivCeil(_setTokenSupply);
950             return _prePositionUnit.sub(unitsToSub);
951         } else {
952             // Else subtract post action total notional from pre action total notional and calculate new position units
953             uint256 unitsToAdd = _postTotalNotional.sub(_preTotalNotional).preciseDiv(_setTokenSupply);
954             return _prePositionUnit.add(unitsToAdd);
955         }
956     }
957 }
958 
959 // Dependency file: contracts/protocol/lib/ModuleBase.sol
960 
961 /*
962     Copyright 2020 Set Labs Inc.
963 
964     Licensed under the Apache License, Version 2.0 (the "License");
965     you may not use this file except in compliance with the License.
966     You may obtain a copy of the License at
967 
968     http://www.apache.org/licenses/LICENSE-2.0
969 
970     Unless required by applicable law or agreed to in writing, software
971     distributed under the License is distributed on an "AS IS" BASIS,
972     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
973     See the License for the specific language governing permissions and
974     limitations under the License.
975 */
976 
977 // pragma solidity 0.6.10;
978 
979 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
980 
981 // import { ExplicitERC20 } from "../../lib/ExplicitERC20.sol";
982 // import { IController } from "../../interfaces/IController.sol";
983 // import { IModule } from "../../interfaces/IModule.sol";
984 // import { ISetToken } from "../../interfaces/ISetToken.sol";
985 // import { Invoke } from "./Invoke.sol";
986 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
987 // import { ResourceIdentifier } from "./ResourceIdentifier.sol";
988 
989 /**
990  * @title ModuleBase
991  * @author Set Protocol
992  *
993  * Abstract class that houses common Module-related state and functions.
994  */
995 abstract contract ModuleBase is IModule {
996     using PreciseUnitMath for uint256;
997     using Invoke for ISetToken;
998     using ResourceIdentifier for IController;
999 
1000     /* ============ State Variables ============ */
1001 
1002     // Address of the controller
1003     IController public controller;
1004 
1005     /* ============ Modifiers ============ */
1006 
1007     modifier onlyManagerAndValidSet(ISetToken _setToken) { 
1008         require(isSetManager(_setToken, msg.sender), "Must be the SetToken manager");
1009         require(isSetValidAndInitialized(_setToken), "Must be a valid and initialized SetToken");
1010         _;
1011     }
1012 
1013     modifier onlySetManager(ISetToken _setToken, address _caller) {
1014         require(isSetManager(_setToken, _caller), "Must be the SetToken manager");
1015         _;
1016     }
1017 
1018     modifier onlyValidAndInitializedSet(ISetToken _setToken) {
1019         require(isSetValidAndInitialized(_setToken), "Must be a valid and initialized SetToken");
1020         _;
1021     }
1022 
1023     /**
1024      * Throws if the sender is not a SetToken's module or module not enabled
1025      */
1026     modifier onlyModule(ISetToken _setToken) {
1027         require(
1028             _setToken.moduleStates(msg.sender) == ISetToken.ModuleState.INITIALIZED,
1029             "Only the module can call"
1030         );
1031 
1032         require(
1033             controller.isModule(msg.sender),
1034             "Module must be enabled on controller"
1035         );
1036         _;
1037     }
1038 
1039     /**
1040      * Utilized during module initializations to check that the module is in pending state
1041      * and that the SetToken is valid
1042      */
1043     modifier onlyValidAndPendingSet(ISetToken _setToken) {
1044         require(controller.isSet(address(_setToken)), "Must be controller-enabled SetToken");
1045         require(isSetPendingInitialization(_setToken), "Must be pending initialization");        
1046         _;
1047     }
1048 
1049     /* ============ Constructor ============ */
1050 
1051     /**
1052      * Set state variables and map asset pairs to their oracles
1053      *
1054      * @param _controller             Address of controller contract
1055      */
1056     constructor(IController _controller) public {
1057         controller = _controller;
1058     }
1059 
1060     /* ============ Internal Functions ============ */
1061 
1062     /**
1063      * Transfers tokens from an address (that has set allowance on the module).
1064      *
1065      * @param  _token          The address of the ERC20 token
1066      * @param  _from           The address to transfer from
1067      * @param  _to             The address to transfer to
1068      * @param  _quantity       The number of tokens to transfer
1069      */
1070     function transferFrom(IERC20 _token, address _from, address _to, uint256 _quantity) internal {
1071         ExplicitERC20.transferFrom(_token, _from, _to, _quantity);
1072     }
1073 
1074     /**
1075      * Gets the integration for the module with the passed in name. Validates that the address is not empty
1076      */
1077     function getAndValidateAdapter(string memory _integrationName) internal view returns(address) { 
1078         bytes32 integrationHash = getNameHash(_integrationName);
1079         return getAndValidateAdapterWithHash(integrationHash);
1080     }
1081 
1082     /**
1083      * Gets the integration for the module with the passed in hash. Validates that the address is not empty
1084      */
1085     function getAndValidateAdapterWithHash(bytes32 _integrationHash) internal view returns(address) { 
1086         address adapter = controller.getIntegrationRegistry().getIntegrationAdapterWithHash(
1087             address(this),
1088             _integrationHash
1089         );
1090 
1091         require(adapter != address(0), "Must be valid adapter"); 
1092         return adapter;
1093     }
1094 
1095     /**
1096      * Gets the total fee for this module of the passed in index (fee % * quantity)
1097      */
1098     function getModuleFee(uint256 _feeIndex, uint256 _quantity) internal view returns(uint256) {
1099         uint256 feePercentage = controller.getModuleFee(address(this), _feeIndex);
1100         return _quantity.preciseMul(feePercentage);
1101     }
1102 
1103     /**
1104      * Pays the _feeQuantity from the _setToken denominated in _token to the protocol fee recipient
1105      */
1106     function payProtocolFeeFromSetToken(ISetToken _setToken, address _token, uint256 _feeQuantity) internal {
1107         if (_feeQuantity > 0) {
1108             _setToken.strictInvokeTransfer(_token, controller.feeRecipient(), _feeQuantity); 
1109         }
1110     }
1111 
1112     /**
1113      * Returns true if the module is in process of initialization on the SetToken
1114      */
1115     function isSetPendingInitialization(ISetToken _setToken) internal view returns(bool) {
1116         return _setToken.isPendingModule(address(this));
1117     }
1118 
1119     /**
1120      * Returns true if the address is the SetToken's manager
1121      */
1122     function isSetManager(ISetToken _setToken, address _toCheck) internal view returns(bool) {
1123         return _setToken.manager() == _toCheck;
1124     }
1125 
1126     /**
1127      * Returns true if SetToken must be enabled on the controller 
1128      * and module is registered on the SetToken
1129      */
1130     function isSetValidAndInitialized(ISetToken _setToken) internal view returns(bool) {
1131         return controller.isSet(address(_setToken)) &&
1132             _setToken.isInitializedModule(address(this));
1133     }
1134 
1135     /**
1136      * Hashes the string and returns a bytes32 value
1137      */
1138     function getNameHash(string memory _name) internal pure returns(bytes32) {
1139         return keccak256(bytes(_name));
1140     }
1141 }
1142 // Dependency file: contracts/interfaces/external/IWETH.sol
1143 
1144 /*
1145     Copyright 2018 Set Labs Inc.
1146 
1147     Licensed under the Apache License, Version 2.0 (the "License");
1148     you may not use this file except in compliance with the License.
1149     You may obtain a copy of the License at
1150 
1151     http://www.apache.org/licenses/LICENSE-2.0
1152 
1153     Unless required by applicable law or agreed to in writing, software
1154     distributed under the License is distributed on an "AS IS" BASIS,
1155     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1156     See the License for the specific language governing permissions and
1157     limitations under the License.
1158 */
1159 
1160 
1161 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
1162 
1163 // pragma solidity ^0.6.0;
1164 
1165 /**
1166  * @dev Interface of the ERC20 standard as defined in the EIP.
1167  */
1168 interface IERC20 {
1169     /**
1170      * @dev Returns the amount of tokens in existence.
1171      */
1172     function totalSupply() external view returns (uint256);
1173 
1174     /**
1175      * @dev Returns the amount of tokens owned by `account`.
1176      */
1177     function balanceOf(address account) external view returns (uint256);
1178 
1179     /**
1180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1181      *
1182      * Returns a boolean value indicating whether the operation succeeded.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function transfer(address recipient, uint256 amount) external returns (bool);
1187 
1188     /**
1189      * @dev Returns the remaining number of tokens that `spender` will be
1190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1191      * zero by default.
1192      *
1193      * This value changes when {approve} or {transferFrom} are called.
1194      */
1195     function allowance(address owner, address spender) external view returns (uint256);
1196 
1197     /**
1198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1199      *
1200      * Returns a boolean value indicating whether the operation succeeded.
1201      *
1202      * // importANT: Beware that changing an allowance with this method brings the risk
1203      * that someone may use both the old and the new allowance by unfortunate
1204      * transaction ordering. One possible solution to mitigate this race
1205      * condition is to first reduce the spender's allowance to 0 and set the
1206      * desired value afterwards:
1207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1208      *
1209      * Emits an {Approval} event.
1210      */
1211     function approve(address spender, uint256 amount) external returns (bool);
1212 
1213     /**
1214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1215      * allowance mechanism. `amount` is then deducted from the caller's
1216      * allowance.
1217      *
1218      * Returns a boolean value indicating whether the operation succeeded.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1223 
1224     /**
1225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1226      * another (`to`).
1227      *
1228      * Note that `value` may be zero.
1229      */
1230     event Transfer(address indexed from, address indexed to, uint256 value);
1231 
1232     /**
1233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1234      * a call to {approve}. `value` is the new allowance.
1235      */
1236     event Approval(address indexed owner, address indexed spender, uint256 value);
1237 }
1238 
1239 // pragma solidity 0.6.10;
1240 
1241 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1242 
1243 /**
1244  * @title IWETH
1245  * @author Set Protocol
1246  *
1247  * Interface for Wrapped Ether. This interface allows for interaction for wrapped ether's deposit and withdrawal
1248  * functionality.
1249  */
1250 interface IWETH is IERC20{
1251     function deposit()
1252         external
1253         payable;
1254 
1255     function withdraw(
1256         uint256 wad
1257     )
1258         external;
1259 }
1260 // Dependency file: contracts/interfaces/ISetToken.sol
1261 
1262 /*
1263     Copyright 2020 Set Labs Inc.
1264 
1265     Licensed under the Apache License, Version 2.0 (the "License");
1266     you may not use this file except in compliance with the License.
1267     You may obtain a copy of the License at
1268 
1269     http://www.apache.org/licenses/LICENSE-2.0
1270 
1271     Unless required by applicable law or agreed to in writing, software
1272     distributed under the License is distributed on an "AS IS" BASIS,
1273     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1274     See the License for the specific language governing permissions and
1275     limitations under the License.
1276 */
1277 // pragma solidity 0.6.10;
1278 // pragma experimental "ABIEncoderV2";
1279 
1280 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1281 
1282 /**
1283  * @title ISetToken
1284  * @author Set Protocol
1285  *
1286  * Interface for operating with SetTokens.
1287  */
1288 interface ISetToken is IERC20 {
1289 
1290     /* ============ Enums ============ */
1291 
1292     enum ModuleState {
1293         NONE,
1294         PENDING,
1295         INITIALIZED
1296     }
1297 
1298     /* ============ Structs ============ */
1299     /**
1300      * The base definition of a SetToken Position
1301      *
1302      * @param component           Address of token in the Position
1303      * @param module              If not in default state, the address of associated module
1304      * @param unit                Each unit is the # of components per 10^18 of a SetToken
1305      * @param positionState       Position ENUM. Default is 0; External is 1
1306      * @param data                Arbitrary data
1307      */
1308     struct Position {
1309         address component;
1310         address module;
1311         int256 unit;
1312         uint8 positionState;
1313         bytes data;
1314     }
1315 
1316     /**
1317      * A struct that stores a component's cash position details and external positions
1318      * This data structure allows O(1) access to a component's cash position units and 
1319      * virtual units.
1320      *
1321      * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
1322      *                                  updating all units at once via the position multiplier. Virtual units are achieved
1323      *                                  by dividing a "real" value by the "positionMultiplier"
1324      * @param componentIndex            
1325      * @param externalPositionModules   List of external modules attached to each external position. Each module
1326      *                                  maps to an external position
1327      * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
1328      */
1329     struct ComponentPosition {
1330       int256 virtualUnit;
1331       address[] externalPositionModules;
1332       mapping(address => ExternalPosition) externalPositions;
1333     }
1334 
1335     /**
1336      * A struct that stores a component's external position details including virtual unit and any
1337      * auxiliary data.
1338      *
1339      * @param virtualUnit       Virtual value of a component's EXTERNAL position.
1340      * @param data              Arbitrary data
1341      */
1342     struct ExternalPosition {
1343       int256 virtualUnit;
1344       bytes data;
1345     }
1346 
1347 
1348     /* ============ Functions ============ */
1349     
1350     function addComponent(address _component) external;
1351     function removeComponent(address _component) external;
1352     function editDefaultPositionUnit(address _component, int256 _realUnit) external;
1353     function addExternalPositionModule(address _component, address _positionModule) external;
1354     function removeExternalPositionModule(address _component, address _positionModule) external;
1355     function editExternalPositionUnit(address _component, address _positionModule, int256 _realUnit) external;
1356     function editExternalPositionData(address _component, address _positionModule, bytes calldata _data) external;
1357 
1358     function invoke(address _target, uint256 _value, bytes calldata _data) external returns(bytes memory);
1359 
1360     function editPositionMultiplier(int256 _newMultiplier) external;
1361 
1362     function mint(address _account, uint256 _quantity) external;
1363     function burn(address _account, uint256 _quantity) external;
1364 
1365     function lock() external;
1366     function unlock() external;
1367 
1368     function addModule(address _module) external;
1369     function removeModule(address _module) external;
1370     function initializeModule() external;
1371 
1372     function setManager(address _manager) external;
1373 
1374     function manager() external view returns (address);
1375     function moduleStates(address _module) external view returns (ModuleState);
1376     function getModules() external view returns (address[] memory);
1377     
1378     function getDefaultPositionRealUnit(address _component) external view returns(int256);
1379     function getExternalPositionRealUnit(address _component, address _positionModule) external view returns(int256);
1380     function getComponents() external view returns(address[] memory);
1381     function getExternalPositionModules(address _component) external view returns(address[] memory);
1382     function getExternalPositionData(address _component, address _positionModule) external view returns(bytes memory);
1383     function isExternalPositionModule(address _component, address _module) external view returns(bool);
1384     function isComponent(address _component) external view returns(bool);
1385     
1386     function positionMultiplier() external view returns (int256);
1387     function getPositions() external view returns (Position[] memory);
1388     function getTotalComponentRealUnits(address _component) external view returns(int256);
1389 
1390     function isInitializedModule(address _module) external view returns(bool);
1391     function isPendingModule(address _module) external view returns(bool);
1392     function isLocked() external view returns (bool);
1393 }
1394 // Dependency file: contracts/protocol/lib/Invoke.sol
1395 
1396 /*
1397     Copyright 2020 Set Labs Inc.
1398 
1399     Licensed under the Apache License, Version 2.0 (the "License");
1400     you may not use this file except in compliance with the License.
1401     You may obtain a copy of the License at
1402 
1403     http://www.apache.org/licenses/LICENSE-2.0
1404 
1405     Unless required by applicable law or agreed to in writing, software
1406     distributed under the License is distributed on an "AS IS" BASIS,
1407     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1408     See the License for the specific language governing permissions and
1409     limitations under the License.
1410 */
1411 
1412 // pragma solidity 0.6.10;
1413 
1414 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1415 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1416 
1417 // import { ISetToken } from "../../interfaces/ISetToken.sol";
1418 
1419 
1420 /**
1421  * @title Invoke
1422  * @author Set Protocol
1423  *
1424  * A collection of common utility functions for interacting with the SetToken's invoke function
1425  */
1426 library Invoke {
1427     using SafeMath for uint256;
1428 
1429     /* ============ Internal ============ */
1430 
1431     /**
1432      * Instructs the SetToken to set approvals of the ERC20 token to a spender.
1433      *
1434      * @param _setToken        SetToken instance to invoke
1435      * @param _token           ERC20 token to approve
1436      * @param _spender         The account allowed to spend the SetToken's balance
1437      * @param _quantity        The quantity of allowance to allow
1438      */
1439     function invokeApprove(
1440         ISetToken _setToken,
1441         address _token,
1442         address _spender,
1443         uint256 _quantity
1444     )
1445         internal
1446     {
1447         bytes memory callData = abi.encodeWithSignature("approve(address,uint256)", _spender, _quantity);
1448         _setToken.invoke(_token, 0, callData);
1449     }
1450 
1451     /**
1452      * Instructs the SetToken to transfer the ERC20 token to a recipient.
1453      *
1454      * @param _setToken        SetToken instance to invoke
1455      * @param _token           ERC20 token to transfer
1456      * @param _to              The recipient account
1457      * @param _quantity        The quantity to transfer
1458      */
1459     function invokeTransfer(
1460         ISetToken _setToken,
1461         address _token,
1462         address _to,
1463         uint256 _quantity
1464     )
1465         internal
1466     {
1467         if (_quantity > 0) {
1468             bytes memory callData = abi.encodeWithSignature("transfer(address,uint256)", _to, _quantity);
1469             _setToken.invoke(_token, 0, callData);
1470         }
1471     }
1472 
1473     /**
1474      * Instructs the SetToken to transfer the ERC20 token to a recipient.
1475      * The new SetToken balance must equal the existing balance less the quantity transferred
1476      *
1477      * @param _setToken        SetToken instance to invoke
1478      * @param _token           ERC20 token to transfer
1479      * @param _to              The recipient account
1480      * @param _quantity        The quantity to transfer
1481      */
1482     function strictInvokeTransfer(
1483         ISetToken _setToken,
1484         address _token,
1485         address _to,
1486         uint256 _quantity
1487     )
1488         internal
1489     {
1490         if (_quantity > 0) {
1491             // Retrieve current balance of token for the SetToken
1492             uint256 existingBalance = IERC20(_token).balanceOf(address(_setToken));
1493 
1494             Invoke.invokeTransfer(_setToken, _token, _to, _quantity);
1495 
1496             // Get new balance of transferred token for SetToken
1497             uint256 newBalance = IERC20(_token).balanceOf(address(_setToken));
1498 
1499             // Verify only the transfer quantity is subtracted
1500             require(
1501                 newBalance == existingBalance.sub(_quantity),
1502                 "Invalid post transfer balance"
1503             );
1504         }
1505     }
1506 
1507     /**
1508      * Instructs the SetToken to unwrap the passed quantity of WETH
1509      *
1510      * @param _setToken        SetToken instance to invoke
1511      * @param _weth            WETH address
1512      * @param _quantity        The quantity to unwrap
1513      */
1514     function invokeUnwrapWETH(ISetToken _setToken, address _weth, uint256 _quantity) internal {
1515         bytes memory callData = abi.encodeWithSignature("withdraw(uint256)", _quantity);
1516         _setToken.invoke(_weth, 0, callData);
1517     }
1518 
1519     /**
1520      * Instructs the SetToken to wrap the passed quantity of ETH
1521      *
1522      * @param _setToken        SetToken instance to invoke
1523      * @param _weth            WETH address
1524      * @param _quantity        The quantity to unwrap
1525      */
1526     function invokeWrapWETH(ISetToken _setToken, address _weth, uint256 _quantity) internal {
1527         bytes memory callData = abi.encodeWithSignature("deposit()");
1528         _setToken.invoke(_weth, _quantity, callData);
1529     }
1530 }
1531 // Dependency file: contracts/interfaces/INAVIssuanceHook.sol
1532 
1533 /*
1534     Copyright 2020 Set Labs Inc.
1535 
1536     Licensed under the Apache License, Version 2.0 (the "License");
1537     you may not use this file except in compliance with the License.
1538     You may obtain a copy of the License at
1539 
1540     http://www.apache.org/licenses/LICENSE-2.0
1541 
1542     Unless required by applicable law or agreed to in writing, software
1543     distributed under the License is distributed on an "AS IS" BASIS,
1544     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1545     See the License for the specific language governing permissions and
1546     limitations under the License.
1547 */
1548 // pragma solidity 0.6.10;
1549 
1550 // import { ISetToken } from "./ISetToken.sol";
1551 
1552 interface INAVIssuanceHook {
1553     function invokePreIssueHook(
1554         ISetToken _setToken,
1555         address _reserveAsset,
1556         uint256 _reserveAssetQuantity,
1557         address _sender,
1558         address _to
1559     )
1560         external;
1561 
1562     function invokePreRedeemHook(
1563         ISetToken _setToken,
1564         uint256 _redeemQuantity,
1565         address _sender,
1566         address _to
1567     )
1568         external;
1569 }
1570 // Dependency file: contracts/interfaces/IController.sol
1571 
1572 /*
1573     Copyright 2020 Set Labs Inc.
1574 
1575     Licensed under the Apache License, Version 2.0 (the "License");
1576     you may not use this file except in compliance with the License.
1577     You may obtain a copy of the License at
1578 
1579     http://www.apache.org/licenses/LICENSE-2.0
1580 
1581     Unless required by applicable law or agreed to in writing, software
1582     distributed under the License is distributed on an "AS IS" BASIS,
1583     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1584     See the License for the specific language governing permissions and
1585     limitations under the License.
1586 */
1587 // pragma solidity 0.6.10;
1588 
1589 interface IController {
1590     function addSet(address _setToken) external;
1591     function feeRecipient() external view returns(address);
1592     function getModuleFee(address _module, uint256 _feeType) external view returns(uint256);
1593     function isModule(address _module) external view returns(bool);
1594     function isSet(address _setToken) external view returns(bool);
1595     function isSystemContract(address _contractAddress) external view returns (bool);
1596     function resourceId(uint256 _id) external view returns(address);
1597 }
1598 // Dependency file: contracts/lib/AddressArrayUtils.sol
1599 
1600 /*
1601     Copyright 2020 Set Labs Inc.
1602 
1603     Licensed under the Apache License, Version 2.0 (the "License");
1604     you may not use this file except in compliance with the License.
1605     You may obtain a copy of the License at
1606 
1607     http://www.apache.org/licenses/LICENSE-2.0
1608 
1609     Unless required by applicable law or agreed to in writing, software
1610     distributed under the License is distributed on an "AS IS" BASIS,
1611     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1612     See the License for the specific language governing permissions and
1613     limitations under the License.
1614 */
1615 
1616 // pragma solidity 0.6.10;
1617 
1618 /**
1619  * @title AddressArrayUtils
1620  * @author Set Protocol
1621  *
1622  * Utility functions to handle Address Arrays
1623  */
1624 library AddressArrayUtils {
1625 
1626     /**
1627      * Finds the index of the first occurrence of the given element.
1628      * @param A The input array to search
1629      * @param a The value to find
1630      * @return Returns (index and isIn) for the first occurrence starting from index 0
1631      */
1632     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
1633         uint256 length = A.length;
1634         for (uint256 i = 0; i < length; i++) {
1635             if (A[i] == a) {
1636                 return (i, true);
1637             }
1638         }
1639         return (uint256(-1), false);
1640     }
1641 
1642     /**
1643     * Returns true if the value is present in the list. Uses indexOf internally.
1644     * @param A The input array to search
1645     * @param a The value to find
1646     * @return Returns isIn for the first occurrence starting from index 0
1647     */
1648     function contains(address[] memory A, address a) internal pure returns (bool) {
1649         (, bool isIn) = indexOf(A, a);
1650         return isIn;
1651     }
1652 
1653     /**
1654     * Returns true if there are 2 elements that are the same in an array
1655     * @param A The input array to search
1656     * @return Returns boolean for the first occurrence of a duplicate
1657     */
1658     function hasDuplicate(address[] memory A) internal pure returns(bool) {
1659         require(A.length > 0, "A is empty");
1660 
1661         for (uint256 i = 0; i < A.length - 1; i++) {
1662             address current = A[i];
1663             for (uint256 j = i + 1; j < A.length; j++) {
1664                 if (current == A[j]) {
1665                     return true;
1666                 }
1667             }
1668         }
1669         return false;
1670     }
1671 
1672     /**
1673      * @param A The input array to search
1674      * @param a The address to remove     
1675      * @return Returns the array with the object removed.
1676      */
1677     function remove(address[] memory A, address a)
1678         internal
1679         pure
1680         returns (address[] memory)
1681     {
1682         (uint256 index, bool isIn) = indexOf(A, a);
1683         if (!isIn) {
1684             revert("Address not in array.");
1685         } else {
1686             (address[] memory _A,) = pop(A, index);
1687             return _A;
1688         }
1689     }
1690 
1691     /**
1692     * Removes specified index from array
1693     * @param A The input array to search
1694     * @param index The index to remove
1695     * @return Returns the new array and the removed entry
1696     */
1697     function pop(address[] memory A, uint256 index)
1698         internal
1699         pure
1700         returns (address[] memory, address)
1701     {
1702         uint256 length = A.length;
1703         require(index < A.length, "Index must be < A length");
1704         address[] memory newAddresses = new address[](length - 1);
1705         for (uint256 i = 0; i < index; i++) {
1706             newAddresses[i] = A[i];
1707         }
1708         for (uint256 j = index + 1; j < length; j++) {
1709             newAddresses[j - 1] = A[j];
1710         }
1711         return (newAddresses, A[index]);
1712     }
1713 }
1714 // Dependency file: @openzeppelin/contracts/math/SignedSafeMath.sol
1715 
1716 // pragma solidity ^0.6.0;
1717 
1718 /**
1719  * @title SignedSafeMath
1720  * @dev Signed math operations with safety checks that revert on error.
1721  */
1722 library SignedSafeMath {
1723     int256 constant private _INT256_MIN = -2**255;
1724 
1725         /**
1726      * @dev Returns the multiplication of two signed integers, reverting on
1727      * overflow.
1728      *
1729      * Counterpart to Solidity's `*` operator.
1730      *
1731      * Requirements:
1732      *
1733      * - Multiplication cannot overflow.
1734      */
1735     function mul(int256 a, int256 b) internal pure returns (int256) {
1736         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1737         // benefit is lost if 'b' is also tested.
1738         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1739         if (a == 0) {
1740             return 0;
1741         }
1742 
1743         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
1744 
1745         int256 c = a * b;
1746         require(c / a == b, "SignedSafeMath: multiplication overflow");
1747 
1748         return c;
1749     }
1750 
1751     /**
1752      * @dev Returns the integer division of two signed integers. Reverts on
1753      * division by zero. The result is rounded towards zero.
1754      *
1755      * Counterpart to Solidity's `/` operator. Note: this function uses a
1756      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1757      * uses an invalid opcode to revert (consuming all remaining gas).
1758      *
1759      * Requirements:
1760      *
1761      * - The divisor cannot be zero.
1762      */
1763     function div(int256 a, int256 b) internal pure returns (int256) {
1764         require(b != 0, "SignedSafeMath: division by zero");
1765         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
1766 
1767         int256 c = a / b;
1768 
1769         return c;
1770     }
1771 
1772     /**
1773      * @dev Returns the subtraction of two signed integers, reverting on
1774      * overflow.
1775      *
1776      * Counterpart to Solidity's `-` operator.
1777      *
1778      * Requirements:
1779      *
1780      * - Subtraction cannot overflow.
1781      */
1782     function sub(int256 a, int256 b) internal pure returns (int256) {
1783         int256 c = a - b;
1784         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
1785 
1786         return c;
1787     }
1788 
1789     /**
1790      * @dev Returns the addition of two signed integers, reverting on
1791      * overflow.
1792      *
1793      * Counterpart to Solidity's `+` operator.
1794      *
1795      * Requirements:
1796      *
1797      * - Addition cannot overflow.
1798      */
1799     function add(int256 a, int256 b) internal pure returns (int256) {
1800         int256 c = a + b;
1801         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
1802 
1803         return c;
1804     }
1805 }
1806 
1807 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
1808 
1809 // pragma solidity ^0.6.0;
1810 
1811 /**
1812  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1813  * checks.
1814  *
1815  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1816  * in bugs, because programmers usually assume that an overflow raises an
1817  * error, which is the standard behavior in high level programming languages.
1818  * `SafeMath` restores this intuition by reverting the transaction when an
1819  * operation overflows.
1820  *
1821  * Using this library instead of the unchecked operations eliminates an entire
1822  * class of bugs, so it's recommended to use it always.
1823  */
1824 library SafeMath {
1825     /**
1826      * @dev Returns the addition of two unsigned integers, reverting on
1827      * overflow.
1828      *
1829      * Counterpart to Solidity's `+` operator.
1830      *
1831      * Requirements:
1832      *
1833      * - Addition cannot overflow.
1834      */
1835     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1836         uint256 c = a + b;
1837         require(c >= a, "SafeMath: addition overflow");
1838 
1839         return c;
1840     }
1841 
1842     /**
1843      * @dev Returns the subtraction of two unsigned integers, reverting on
1844      * overflow (when the result is negative).
1845      *
1846      * Counterpart to Solidity's `-` operator.
1847      *
1848      * Requirements:
1849      *
1850      * - Subtraction cannot overflow.
1851      */
1852     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1853         return sub(a, b, "SafeMath: subtraction overflow");
1854     }
1855 
1856     /**
1857      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1858      * overflow (when the result is negative).
1859      *
1860      * Counterpart to Solidity's `-` operator.
1861      *
1862      * Requirements:
1863      *
1864      * - Subtraction cannot overflow.
1865      */
1866     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1867         require(b <= a, errorMessage);
1868         uint256 c = a - b;
1869 
1870         return c;
1871     }
1872 
1873     /**
1874      * @dev Returns the multiplication of two unsigned integers, reverting on
1875      * overflow.
1876      *
1877      * Counterpart to Solidity's `*` operator.
1878      *
1879      * Requirements:
1880      *
1881      * - Multiplication cannot overflow.
1882      */
1883     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1884         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1885         // benefit is lost if 'b' is also tested.
1886         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1887         if (a == 0) {
1888             return 0;
1889         }
1890 
1891         uint256 c = a * b;
1892         require(c / a == b, "SafeMath: multiplication overflow");
1893 
1894         return c;
1895     }
1896 
1897     /**
1898      * @dev Returns the integer division of two unsigned integers. Reverts on
1899      * division by zero. The result is rounded towards zero.
1900      *
1901      * Counterpart to Solidity's `/` operator. Note: this function uses a
1902      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1903      * uses an invalid opcode to revert (consuming all remaining gas).
1904      *
1905      * Requirements:
1906      *
1907      * - The divisor cannot be zero.
1908      */
1909     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1910         return div(a, b, "SafeMath: division by zero");
1911     }
1912 
1913     /**
1914      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1915      * division by zero. The result is rounded towards zero.
1916      *
1917      * Counterpart to Solidity's `/` operator. Note: this function uses a
1918      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1919      * uses an invalid opcode to revert (consuming all remaining gas).
1920      *
1921      * Requirements:
1922      *
1923      * - The divisor cannot be zero.
1924      */
1925     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1926         require(b > 0, errorMessage);
1927         uint256 c = a / b;
1928         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1929 
1930         return c;
1931     }
1932 
1933     /**
1934      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1935      * Reverts when dividing by zero.
1936      *
1937      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1938      * opcode (which leaves remaining gas untouched) while Solidity uses an
1939      * invalid opcode to revert (consuming all remaining gas).
1940      *
1941      * Requirements:
1942      *
1943      * - The divisor cannot be zero.
1944      */
1945     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1946         return mod(a, b, "SafeMath: modulo by zero");
1947     }
1948 
1949     /**
1950      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1951      * Reverts with custom message when dividing by zero.
1952      *
1953      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1954      * opcode (which leaves remaining gas untouched) while Solidity uses an
1955      * invalid opcode to revert (consuming all remaining gas).
1956      *
1957      * Requirements:
1958      *
1959      * - The divisor cannot be zero.
1960      */
1961     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1962         require(b != 0, errorMessage);
1963         return a % b;
1964     }
1965 }
1966 
1967 // Dependency file: @openzeppelin/contracts/utils/SafeCast.sol
1968 
1969 // pragma solidity ^0.6.0;
1970 
1971 
1972 /**
1973  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1974  * checks.
1975  *
1976  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1977  * easily result in undesired exploitation or bugs, since developers usually
1978  * assume that overflows raise errors. `SafeCast` restores this intuition by
1979  * reverting the transaction when such an operation overflows.
1980  *
1981  * Using this library instead of the unchecked operations eliminates an entire
1982  * class of bugs, so it's recommended to use it always.
1983  *
1984  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1985  * all math on `uint256` and `int256` and then downcasting.
1986  */
1987 library SafeCast {
1988 
1989     /**
1990      * @dev Returns the downcasted uint128 from uint256, reverting on
1991      * overflow (when the input is greater than largest uint128).
1992      *
1993      * Counterpart to Solidity's `uint128` operator.
1994      *
1995      * Requirements:
1996      *
1997      * - input must fit into 128 bits
1998      */
1999     function toUint128(uint256 value) internal pure returns (uint128) {
2000         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
2001         return uint128(value);
2002     }
2003 
2004     /**
2005      * @dev Returns the downcasted uint64 from uint256, reverting on
2006      * overflow (when the input is greater than largest uint64).
2007      *
2008      * Counterpart to Solidity's `uint64` operator.
2009      *
2010      * Requirements:
2011      *
2012      * - input must fit into 64 bits
2013      */
2014     function toUint64(uint256 value) internal pure returns (uint64) {
2015         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
2016         return uint64(value);
2017     }
2018 
2019     /**
2020      * @dev Returns the downcasted uint32 from uint256, reverting on
2021      * overflow (when the input is greater than largest uint32).
2022      *
2023      * Counterpart to Solidity's `uint32` operator.
2024      *
2025      * Requirements:
2026      *
2027      * - input must fit into 32 bits
2028      */
2029     function toUint32(uint256 value) internal pure returns (uint32) {
2030         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
2031         return uint32(value);
2032     }
2033 
2034     /**
2035      * @dev Returns the downcasted uint16 from uint256, reverting on
2036      * overflow (when the input is greater than largest uint16).
2037      *
2038      * Counterpart to Solidity's `uint16` operator.
2039      *
2040      * Requirements:
2041      *
2042      * - input must fit into 16 bits
2043      */
2044     function toUint16(uint256 value) internal pure returns (uint16) {
2045         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
2046         return uint16(value);
2047     }
2048 
2049     /**
2050      * @dev Returns the downcasted uint8 from uint256, reverting on
2051      * overflow (when the input is greater than largest uint8).
2052      *
2053      * Counterpart to Solidity's `uint8` operator.
2054      *
2055      * Requirements:
2056      *
2057      * - input must fit into 8 bits.
2058      */
2059     function toUint8(uint256 value) internal pure returns (uint8) {
2060         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
2061         return uint8(value);
2062     }
2063 
2064     /**
2065      * @dev Converts a signed int256 into an unsigned uint256.
2066      *
2067      * Requirements:
2068      *
2069      * - input must be greater than or equal to 0.
2070      */
2071     function toUint256(int256 value) internal pure returns (uint256) {
2072         require(value >= 0, "SafeCast: value must be positive");
2073         return uint256(value);
2074     }
2075 
2076     /**
2077      * @dev Returns the downcasted int128 from int256, reverting on
2078      * overflow (when the input is less than smallest int128 or
2079      * greater than largest int128).
2080      *
2081      * Counterpart to Solidity's `int128` operator.
2082      *
2083      * Requirements:
2084      *
2085      * - input must fit into 128 bits
2086      *
2087      * _Available since v3.1._
2088      */
2089     function toInt128(int256 value) internal pure returns (int128) {
2090         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
2091         return int128(value);
2092     }
2093 
2094     /**
2095      * @dev Returns the downcasted int64 from int256, reverting on
2096      * overflow (when the input is less than smallest int64 or
2097      * greater than largest int64).
2098      *
2099      * Counterpart to Solidity's `int64` operator.
2100      *
2101      * Requirements:
2102      *
2103      * - input must fit into 64 bits
2104      *
2105      * _Available since v3.1._
2106      */
2107     function toInt64(int256 value) internal pure returns (int64) {
2108         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
2109         return int64(value);
2110     }
2111 
2112     /**
2113      * @dev Returns the downcasted int32 from int256, reverting on
2114      * overflow (when the input is less than smallest int32 or
2115      * greater than largest int32).
2116      *
2117      * Counterpart to Solidity's `int32` operator.
2118      *
2119      * Requirements:
2120      *
2121      * - input must fit into 32 bits
2122      *
2123      * _Available since v3.1._
2124      */
2125     function toInt32(int256 value) internal pure returns (int32) {
2126         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
2127         return int32(value);
2128     }
2129 
2130     /**
2131      * @dev Returns the downcasted int16 from int256, reverting on
2132      * overflow (when the input is less than smallest int16 or
2133      * greater than largest int16).
2134      *
2135      * Counterpart to Solidity's `int16` operator.
2136      *
2137      * Requirements:
2138      *
2139      * - input must fit into 16 bits
2140      *
2141      * _Available since v3.1._
2142      */
2143     function toInt16(int256 value) internal pure returns (int16) {
2144         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
2145         return int16(value);
2146     }
2147 
2148     /**
2149      * @dev Returns the downcasted int8 from int256, reverting on
2150      * overflow (when the input is less than smallest int8 or
2151      * greater than largest int8).
2152      *
2153      * Counterpart to Solidity's `int8` operator.
2154      *
2155      * Requirements:
2156      *
2157      * - input must fit into 8 bits.
2158      *
2159      * _Available since v3.1._
2160      */
2161     function toInt8(int256 value) internal pure returns (int8) {
2162         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
2163         return int8(value);
2164     }
2165 
2166     /**
2167      * @dev Converts an unsigned uint256 into a signed int256.
2168      *
2169      * Requirements:
2170      *
2171      * - input must be less than or equal to maxInt256.
2172      */
2173     function toInt256(uint256 value) internal pure returns (int256) {
2174         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
2175         return int256(value);
2176     }
2177 }
2178 
2179 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
2180 
2181 // pragma solidity ^0.6.0;
2182 
2183 /**
2184  * @dev Contract module that helps prevent reentrant calls to a function.
2185  *
2186  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2187  * available, which can be applied to functions to make sure there are no nested
2188  * (reentrant) calls to them.
2189  *
2190  * Note that because there is a single `nonReentrant` guard, functions marked as
2191  * `nonReentrant` may not call one another. This can be worked around by making
2192  * those functions `private`, and then adding `external` `nonReentrant` entry
2193  * points to them.
2194  *
2195  * TIP: If you would like to learn more about reentrancy and alternative ways
2196  * to protect against it, check out our blog post
2197  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2198  */
2199 contract ReentrancyGuard {
2200     // Booleans are more expensive than uint256 or any type that takes up a full
2201     // word because each write operation emits an extra SLOAD to first read the
2202     // slot's contents, replace the bits taken up by the boolean, and then write
2203     // back. This is the compiler's defense against contract upgrades and
2204     // pointer aliasing, and it cannot be disabled.
2205 
2206     // The values being non-zero value makes deployment a bit more expensive,
2207     // but in exchange the refund on every call to nonReentrant will be lower in
2208     // amount. Since refunds are capped to a percentage of the total
2209     // transaction's gas, it is best to keep them low in cases like this one, to
2210     // increase the likelihood of the full refund coming into effect.
2211     uint256 private constant _NOT_ENTERED = 1;
2212     uint256 private constant _ENTERED = 2;
2213 
2214     uint256 private _status;
2215 
2216     constructor () internal {
2217         _status = _NOT_ENTERED;
2218     }
2219 
2220     /**
2221      * @dev Prevents a contract from calling itself, directly or indirectly.
2222      * Calling a `nonReentrant` function from another `nonReentrant`
2223      * function is not supported. It is possible to prevent this from happening
2224      * by making the `nonReentrant` function external, and make it call a
2225      * `private` function that does the actual work.
2226      */
2227     modifier nonReentrant() {
2228         // On the first call to nonReentrant, _notEntered will be true
2229         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2230 
2231         // Any calls to nonReentrant after this point will fail
2232         _status = _ENTERED;
2233 
2234         _;
2235 
2236         // By storing the original value once again, a refund is triggered (see
2237         // https://eips.ethereum.org/EIPS/eip-2200)
2238         _status = _NOT_ENTERED;
2239     }
2240 }
2241 
2242 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
2243 
2244 // pragma solidity ^0.6.0;
2245 
2246 // import "../../GSN/Context.sol";
2247 // import "./IERC20.sol";
2248 // import "../../math/SafeMath.sol";
2249 // import "../../utils/Address.sol";
2250 
2251 /**
2252  * @dev Implementation of the {IERC20} interface.
2253  *
2254  * This implementation is agnostic to the way tokens are created. This means
2255  * that a supply mechanism has to be added in a derived contract using {_mint}.
2256  * For a generic mechanism see {ERC20PresetMinterPauser}.
2257  *
2258  * TIP: For a detailed writeup see our guide
2259  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2260  * to implement supply mechanisms].
2261  *
2262  * We have followed general OpenZeppelin guidelines: functions revert instead
2263  * of returning `false` on failure. This behavior is nonetheless conventional
2264  * and does not conflict with the expectations of ERC20 applications.
2265  *
2266  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2267  * This allows applications to reconstruct the allowance for all accounts just
2268  * by listening to said events. Other implementations of the EIP may not emit
2269  * these events, as it isn't required by the specification.
2270  *
2271  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2272  * functions have been added to mitigate the well-known issues around setting
2273  * allowances. See {IERC20-approve}.
2274  */
2275 contract ERC20 is Context, IERC20 {
2276     using SafeMath for uint256;
2277     using Address for address;
2278 
2279     mapping (address => uint256) private _balances;
2280 
2281     mapping (address => mapping (address => uint256)) private _allowances;
2282 
2283     uint256 private _totalSupply;
2284 
2285     string private _name;
2286     string private _symbol;
2287     uint8 private _decimals;
2288 
2289     /**
2290      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
2291      * a default value of 18.
2292      *
2293      * To select a different value for {decimals}, use {_setupDecimals}.
2294      *
2295      * All three of these values are immutable: they can only be set once during
2296      * construction.
2297      */
2298     constructor (string memory name, string memory symbol) public {
2299         _name = name;
2300         _symbol = symbol;
2301         _decimals = 18;
2302     }
2303 
2304     /**
2305      * @dev Returns the name of the token.
2306      */
2307     function name() public view returns (string memory) {
2308         return _name;
2309     }
2310 
2311     /**
2312      * @dev Returns the symbol of the token, usually a shorter version of the
2313      * name.
2314      */
2315     function symbol() public view returns (string memory) {
2316         return _symbol;
2317     }
2318 
2319     /**
2320      * @dev Returns the number of decimals used to get its user representation.
2321      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2322      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
2323      *
2324      * Tokens usually opt for a value of 18, imitating the relationship between
2325      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
2326      * called.
2327      *
2328      * NOTE: This information is only used for _display_ purposes: it in
2329      * no way affects any of the arithmetic of the contract, including
2330      * {IERC20-balanceOf} and {IERC20-transfer}.
2331      */
2332     function decimals() public view returns (uint8) {
2333         return _decimals;
2334     }
2335 
2336     /**
2337      * @dev See {IERC20-totalSupply}.
2338      */
2339     function totalSupply() public view override returns (uint256) {
2340         return _totalSupply;
2341     }
2342 
2343     /**
2344      * @dev See {IERC20-balanceOf}.
2345      */
2346     function balanceOf(address account) public view override returns (uint256) {
2347         return _balances[account];
2348     }
2349 
2350     /**
2351      * @dev See {IERC20-transfer}.
2352      *
2353      * Requirements:
2354      *
2355      * - `recipient` cannot be the zero address.
2356      * - the caller must have a balance of at least `amount`.
2357      */
2358     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2359         _transfer(_msgSender(), recipient, amount);
2360         return true;
2361     }
2362 
2363     /**
2364      * @dev See {IERC20-allowance}.
2365      */
2366     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2367         return _allowances[owner][spender];
2368     }
2369 
2370     /**
2371      * @dev See {IERC20-approve}.
2372      *
2373      * Requirements:
2374      *
2375      * - `spender` cannot be the zero address.
2376      */
2377     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2378         _approve(_msgSender(), spender, amount);
2379         return true;
2380     }
2381 
2382     /**
2383      * @dev See {IERC20-transferFrom}.
2384      *
2385      * Emits an {Approval} event indicating the updated allowance. This is not
2386      * required by the EIP. See the note at the beginning of {ERC20};
2387      *
2388      * Requirements:
2389      * - `sender` and `recipient` cannot be the zero address.
2390      * - `sender` must have a balance of at least `amount`.
2391      * - the caller must have allowance for ``sender``'s tokens of at least
2392      * `amount`.
2393      */
2394     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
2395         _transfer(sender, recipient, amount);
2396         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
2397         return true;
2398     }
2399 
2400     /**
2401      * @dev Atomically increases the allowance granted to `spender` by the caller.
2402      *
2403      * This is an alternative to {approve} that can be used as a mitigation for
2404      * problems described in {IERC20-approve}.
2405      *
2406      * Emits an {Approval} event indicating the updated allowance.
2407      *
2408      * Requirements:
2409      *
2410      * - `spender` cannot be the zero address.
2411      */
2412     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2413         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
2414         return true;
2415     }
2416 
2417     /**
2418      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2419      *
2420      * This is an alternative to {approve} that can be used as a mitigation for
2421      * problems described in {IERC20-approve}.
2422      *
2423      * Emits an {Approval} event indicating the updated allowance.
2424      *
2425      * Requirements:
2426      *
2427      * - `spender` cannot be the zero address.
2428      * - `spender` must have allowance for the caller of at least
2429      * `subtractedValue`.
2430      */
2431     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2432         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
2433         return true;
2434     }
2435 
2436     /**
2437      * @dev Moves tokens `amount` from `sender` to `recipient`.
2438      *
2439      * This is internal function is equivalent to {transfer}, and can be used to
2440      * e.g. implement automatic token fees, slashing mechanisms, etc.
2441      *
2442      * Emits a {Transfer} event.
2443      *
2444      * Requirements:
2445      *
2446      * - `sender` cannot be the zero address.
2447      * - `recipient` cannot be the zero address.
2448      * - `sender` must have a balance of at least `amount`.
2449      */
2450     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
2451         require(sender != address(0), "ERC20: transfer from the zero address");
2452         require(recipient != address(0), "ERC20: transfer to the zero address");
2453 
2454         _beforeTokenTransfer(sender, recipient, amount);
2455 
2456         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
2457         _balances[recipient] = _balances[recipient].add(amount);
2458         emit Transfer(sender, recipient, amount);
2459     }
2460 
2461     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2462      * the total supply.
2463      *
2464      * Emits a {Transfer} event with `from` set to the zero address.
2465      *
2466      * Requirements
2467      *
2468      * - `to` cannot be the zero address.
2469      */
2470     function _mint(address account, uint256 amount) internal virtual {
2471         require(account != address(0), "ERC20: mint to the zero address");
2472 
2473         _beforeTokenTransfer(address(0), account, amount);
2474 
2475         _totalSupply = _totalSupply.add(amount);
2476         _balances[account] = _balances[account].add(amount);
2477         emit Transfer(address(0), account, amount);
2478     }
2479 
2480     /**
2481      * @dev Destroys `amount` tokens from `account`, reducing the
2482      * total supply.
2483      *
2484      * Emits a {Transfer} event with `to` set to the zero address.
2485      *
2486      * Requirements
2487      *
2488      * - `account` cannot be the zero address.
2489      * - `account` must have at least `amount` tokens.
2490      */
2491     function _burn(address account, uint256 amount) internal virtual {
2492         require(account != address(0), "ERC20: burn from the zero address");
2493 
2494         _beforeTokenTransfer(account, address(0), amount);
2495 
2496         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
2497         _totalSupply = _totalSupply.sub(amount);
2498         emit Transfer(account, address(0), amount);
2499     }
2500 
2501     /**
2502      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
2503      *
2504      * This is internal function is equivalent to `approve`, and can be used to
2505      * e.g. set automatic allowances for certain subsystems, etc.
2506      *
2507      * Emits an {Approval} event.
2508      *
2509      * Requirements:
2510      *
2511      * - `owner` cannot be the zero address.
2512      * - `spender` cannot be the zero address.
2513      */
2514     function _approve(address owner, address spender, uint256 amount) internal virtual {
2515         require(owner != address(0), "ERC20: approve from the zero address");
2516         require(spender != address(0), "ERC20: approve to the zero address");
2517 
2518         _allowances[owner][spender] = amount;
2519         emit Approval(owner, spender, amount);
2520     }
2521 
2522     /**
2523      * @dev Sets {decimals} to a value other than the default one of 18.
2524      *
2525      * WARNING: This function should only be called from the constructor. Most
2526      * applications that interact with token contracts will not expect
2527      * {decimals} to ever change, and may work incorrectly if it does.
2528      */
2529     function _setupDecimals(uint8 decimals_) internal {
2530         _decimals = decimals_;
2531     }
2532 
2533     /**
2534      * @dev Hook that is called before any transfer of tokens. This includes
2535      * minting and burning.
2536      *
2537      * Calling conditions:
2538      *
2539      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2540      * will be to transferred to `to`.
2541      * - when `from` is zero, `amount` tokens will be minted for `to`.
2542      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2543      * - `from` and `to` are never both zero.
2544      *
2545      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2546      */
2547     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
2548 }
2549 
2550 /*
2551     Copyright 2020 Set Labs Inc.
2552 
2553     Licensed under the Apache License, Version 2.0 (the "License");
2554     you may not use this file except in compliance with the License.
2555     You may obtain a copy of the License at
2556 
2557     http://www.apache.org/licenses/LICENSE-2.0
2558 
2559     Unless required by applicable law or agreed to in writing, software
2560     distributed under the License is distributed on an "AS IS" BASIS,
2561     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2562     See the License for the specific language governing permissions and
2563     limitations under the License.
2564 */
2565 
2566 pragma solidity 0.6.10;
2567 pragma experimental "ABIEncoderV2";
2568 
2569 // import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
2570 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
2571 // import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
2572 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
2573 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
2574 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
2575 
2576 // import { AddressArrayUtils } from "../../lib/AddressArrayUtils.sol";
2577 // import { IController } from "../../interfaces/IController.sol";
2578 // import { INAVIssuanceHook } from "../../interfaces/INAVIssuanceHook.sol";
2579 // import { Invoke } from "../lib/Invoke.sol";
2580 // import { ISetToken } from "../../interfaces/ISetToken.sol";
2581 // import { IWETH } from "../../interfaces/external/IWETH.sol";
2582 // import { ModuleBase } from "../lib/ModuleBase.sol";
2583 // import { Position } from "../lib/Position.sol";
2584 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
2585 // import { ResourceIdentifier } from "../lib/ResourceIdentifier.sol";
2586 
2587 
2588 /**
2589  * @title NavIssuanceModule
2590  * @author Set Protocol
2591  *
2592  * Module that enables issuance and redemption with any valid ERC20 token or ETH if allowed by the manager. Sender receives
2593  * a proportional amount of SetTokens on issuance or ERC20 token on redemption based on the calculated net asset value using
2594  * oracle prices. Manager is able to enforce a premium / discount on issuance / redemption to avoid arbitrage and front
2595  * running when relying on oracle prices. Managers can charge a fee (denominated in reserve asset).
2596  */
2597 contract NavIssuanceModule is ModuleBase, ReentrancyGuard {
2598     using AddressArrayUtils for address[];
2599     using Invoke for ISetToken;
2600     using Position for ISetToken;
2601     using PreciseUnitMath for uint256;
2602     using PreciseUnitMath for int256;
2603     using ResourceIdentifier for IController;
2604     using SafeMath for uint256;
2605     using SafeCast for int256;
2606     using SafeCast for uint256;
2607     using SignedSafeMath for int256;
2608 
2609     /* ============ Events ============ */
2610 
2611     event SetTokenNAVIssued(
2612         ISetToken indexed _setToken,
2613         address _issuer,
2614         address _to,
2615         address _reserveAsset,
2616         address _hookContract,
2617         uint256 _setTokenQuantity,
2618         uint256 _managerFee,
2619         uint256 _premium
2620     );
2621 
2622     event SetTokenNAVRedeemed(
2623         ISetToken indexed _setToken,
2624         address _redeemer,
2625         address _to,
2626         address _reserveAsset,
2627         address _hookContract,
2628         uint256 _setTokenQuantity,
2629         uint256 _managerFee,
2630         uint256 _premium
2631     );
2632 
2633     event ReserveAssetAdded(
2634         ISetToken indexed _setToken,
2635         address _newReserveAsset
2636     );
2637 
2638     event ReserveAssetRemoved(
2639         ISetToken indexed _setToken,
2640         address _removedReserveAsset
2641     );
2642 
2643     event PremiumEdited(
2644         ISetToken indexed _setToken,
2645         uint256 _newPremium
2646     );
2647 
2648     event ManagerFeeEdited(
2649         ISetToken indexed _setToken,
2650         uint256 _newManagerFee,
2651         uint256 _index
2652     );
2653 
2654     event FeeRecipientEdited(
2655         ISetToken indexed _setToken,
2656         address _feeRecipient
2657     );
2658 
2659     /* ============ Structs ============ */
2660 
2661     struct NAVIssuanceSettings {
2662         INAVIssuanceHook managerIssuanceHook;      // Issuance hook configurations
2663         INAVIssuanceHook managerRedemptionHook;    // Redemption hook configurations
2664         address[] reserveAssets;                       // Allowed reserve assets - Must have a price enabled with the price oracle
2665         address feeRecipient;                          // Manager fee recipient
2666         uint256[2] managerFees;                        // Manager fees. 0 index is issue and 1 index is redeem fee (0.01% = 1e14, 1% = 1e16)
2667         uint256 maxManagerFee;                         // Maximum fee manager is allowed to set for issue and redeem
2668         uint256 premiumPercentage;                     // Premium percentage (0.01% = 1e14, 1% = 1e16). This premium is a buffer around oracle
2669                                                        // prices paid by user to the SetToken, which prevents arbitrage and oracle front running
2670         uint256 maxPremiumPercentage;                  // Maximum premium percentage manager is allowed to set (configured by manager)
2671         uint256 minSetTokenSupply;                     // Minimum SetToken supply required for issuance and redemption 
2672                                                        // to prevent dramatic inflationary changes to the SetToken's position multiplier
2673     }
2674 
2675     struct ActionInfo {
2676         uint256 preFeeReserveQuantity;                 // Reserve value before fees; During issuance, represents raw quantity
2677                                                        // During redeem, represents post-premium value
2678         uint256 protocolFees;                          // Total protocol fees (direct + manager revenue share)
2679         uint256 managerFee;                            // Total manager fee paid in reserve asset
2680         uint256 netFlowQuantity;                       // When issuing, quantity of reserve asset sent to SetToken
2681                                                        // When redeeming, quantity of reserve asset sent to redeemer
2682         uint256 setTokenQuantity;                      // When issuing, quantity of SetTokens minted to mintee
2683                                                        // When redeeming, quantity of SetToken redeemed
2684         uint256 previousSetTokenSupply;                // SetToken supply prior to issue/redeem action
2685         uint256 newSetTokenSupply;                     // SetToken supply after issue/redeem action
2686         int256 newPositionMultiplier;                  // SetToken position multiplier after issue/redeem
2687         uint256 newReservePositionUnit;                // SetToken reserve asset position unit after issue/redeem
2688     }
2689 
2690     /* ============ State Variables ============ */
2691 
2692     // Wrapped ETH address
2693     IWETH public immutable weth;
2694 
2695     // Mapping of SetToken to NAV issuance settings struct
2696     mapping(ISetToken => NAVIssuanceSettings) public navIssuanceSettings;
2697     
2698     // Mapping to efficiently check a SetToken's reserve asset validity
2699     // SetToken => reserveAsset => isReserveAsset
2700     mapping(ISetToken => mapping(address => bool)) public isReserveAsset;
2701 
2702     /* ============ Constants ============ */
2703 
2704     // 0 index stores the manager fee in managerFees array, percentage charged on issue (denominated in reserve asset)
2705     uint256 constant internal MANAGER_ISSUE_FEE_INDEX = 0;
2706 
2707     // 1 index stores the manager fee percentage in managerFees array, charged on redeem
2708     uint256 constant internal MANAGER_REDEEM_FEE_INDEX = 1;
2709 
2710     // 0 index stores the manager revenue share protocol fee % on the controller, charged in the issuance function
2711     uint256 constant internal PROTOCOL_ISSUE_MANAGER_REVENUE_SHARE_FEE_INDEX = 0;
2712 
2713     // 1 index stores the manager revenue share protocol fee % on the controller, charged in the redeem function
2714     uint256 constant internal PROTOCOL_REDEEM_MANAGER_REVENUE_SHARE_FEE_INDEX = 1;
2715 
2716     // 2 index stores the direct protocol fee % on the controller, charged in the issuance function
2717     uint256 constant internal PROTOCOL_ISSUE_DIRECT_FEE_INDEX = 2;
2718 
2719     // 3 index stores the direct protocol fee % on the controller, charged in the redeem function
2720     uint256 constant internal PROTOCOL_REDEEM_DIRECT_FEE_INDEX = 3;
2721 
2722     /* ============ Constructor ============ */
2723 
2724     /**
2725      * @param _controller               Address of controller contract
2726      * @param _weth                     Address of wrapped eth
2727      */
2728     constructor(IController _controller, IWETH _weth) public ModuleBase(_controller) {
2729         weth = _weth;
2730     }
2731 
2732     /* ============ External Functions ============ */
2733     
2734     /**
2735      * Deposits the allowed reserve asset into the SetToken and mints the appropriate % of Net Asset Value of the SetToken
2736      * to the specified _to address.
2737      *
2738      * @param _setToken                     Instance of the SetToken contract
2739      * @param _reserveAsset                 Address of the reserve asset to issue with
2740      * @param _reserveAssetQuantity         Quantity of the reserve asset to issue with
2741      * @param _minSetTokenReceiveQuantity   Min quantity of SetToken to receive after issuance
2742      * @param _to                           Address to mint SetToken to
2743      */
2744     function issue(
2745         ISetToken _setToken,
2746         address _reserveAsset,
2747         uint256 _reserveAssetQuantity,
2748         uint256 _minSetTokenReceiveQuantity,
2749         address _to
2750     ) 
2751         external
2752         nonReentrant
2753         onlyValidAndInitializedSet(_setToken)
2754     {
2755         _validateCommon(_setToken, _reserveAsset, _reserveAssetQuantity);
2756         
2757         _callPreIssueHooks(_setToken, _reserveAsset, _reserveAssetQuantity, msg.sender, _to);
2758 
2759         ActionInfo memory issueInfo = _createIssuanceInfo(_setToken, _reserveAsset, _reserveAssetQuantity);
2760 
2761         _validateIssuanceInfo(_setToken, _minSetTokenReceiveQuantity, issueInfo);
2762 
2763         _transferCollateralAndHandleFees(_setToken, IERC20(_reserveAsset), issueInfo);
2764 
2765         _handleIssueStateUpdates(_setToken, _reserveAsset, _to, issueInfo);
2766     }
2767 
2768     /**
2769      * Wraps ETH and deposits WETH if allowed into the SetToken and mints the appropriate % of Net Asset Value of the SetToken
2770      * to the specified _to address.
2771      *
2772      * @param _setToken                     Instance of the SetToken contract
2773      * @param _minSetTokenReceiveQuantity   Min quantity of SetToken to receive after issuance
2774      * @param _to                           Address to mint SetToken to
2775      */
2776     function issueWithEther(
2777         ISetToken _setToken,
2778         uint256 _minSetTokenReceiveQuantity,
2779         address _to
2780     ) 
2781         external
2782         payable
2783         nonReentrant
2784         onlyValidAndInitializedSet(_setToken)
2785     {
2786         weth.deposit{ value: msg.value }();
2787 
2788         _validateCommon(_setToken, address(weth), msg.value);
2789         
2790         _callPreIssueHooks(_setToken, address(weth), msg.value, msg.sender, _to);
2791 
2792         ActionInfo memory issueInfo = _createIssuanceInfo(_setToken, address(weth), msg.value);
2793 
2794         _validateIssuanceInfo(_setToken, _minSetTokenReceiveQuantity, issueInfo);
2795 
2796         _transferWETHAndHandleFees(_setToken, issueInfo);
2797 
2798         _handleIssueStateUpdates(_setToken, address(weth), _to, issueInfo);
2799     }
2800 
2801     /**
2802      * Redeems a SetToken into a valid reserve asset representing the appropriate % of Net Asset Value of the SetToken
2803      * to the specified _to address. Only valid if there are available reserve units on the SetToken.
2804      *
2805      * @param _setToken                     Instance of the SetToken contract
2806      * @param _reserveAsset                 Address of the reserve asset to redeem with
2807      * @param _setTokenQuantity             Quantity of SetTokens to redeem
2808      * @param _minReserveReceiveQuantity    Min quantity of reserve asset to receive
2809      * @param _to                           Address to redeem reserve asset to
2810      */
2811     function redeem(
2812         ISetToken _setToken,
2813         address _reserveAsset,
2814         uint256 _setTokenQuantity,
2815         uint256 _minReserveReceiveQuantity,
2816         address _to
2817     ) 
2818         external
2819         nonReentrant
2820         onlyValidAndInitializedSet(_setToken)
2821     {
2822         _validateCommon(_setToken, _reserveAsset, _setTokenQuantity);
2823 
2824         _callPreRedeemHooks(_setToken, _setTokenQuantity, msg.sender, _to);
2825 
2826         ActionInfo memory redeemInfo = _createRedemptionInfo(_setToken, _reserveAsset, _setTokenQuantity);
2827 
2828         _validateRedemptionInfo(_setToken, _minReserveReceiveQuantity, _setTokenQuantity, redeemInfo);
2829 
2830         _setToken.burn(msg.sender, _setTokenQuantity);
2831 
2832         // Instruct the SetToken to transfer the reserve asset back to the user
2833         _setToken.strictInvokeTransfer(
2834             _reserveAsset,
2835             _to,
2836             redeemInfo.netFlowQuantity
2837         );
2838 
2839         _handleRedemptionFees(_setToken, _reserveAsset, redeemInfo);
2840 
2841         _handleRedeemStateUpdates(_setToken, _reserveAsset, _to, redeemInfo);
2842     }
2843 
2844     /**
2845      * Redeems a SetToken into Ether (if WETH is valid) representing the appropriate % of Net Asset Value of the SetToken
2846      * to the specified _to address. Only valid if there are available WETH units on the SetToken.
2847      *
2848      * @param _setToken                     Instance of the SetToken contract
2849      * @param _setTokenQuantity             Quantity of SetTokens to redeem
2850      * @param _minReserveReceiveQuantity    Min quantity of reserve asset to receive
2851      * @param _to                           Address to redeem reserve asset to
2852      */
2853     function redeemIntoEther(
2854         ISetToken _setToken,
2855         uint256 _setTokenQuantity,
2856         uint256 _minReserveReceiveQuantity,
2857         address payable _to
2858     ) 
2859         external
2860         nonReentrant
2861         onlyValidAndInitializedSet(_setToken)
2862     {
2863         _validateCommon(_setToken, address(weth), _setTokenQuantity);
2864 
2865         _callPreRedeemHooks(_setToken, _setTokenQuantity, msg.sender, _to);
2866 
2867         ActionInfo memory redeemInfo = _createRedemptionInfo(_setToken, address(weth), _setTokenQuantity);
2868 
2869         _validateRedemptionInfo(_setToken, _minReserveReceiveQuantity, _setTokenQuantity, redeemInfo);
2870 
2871         _setToken.burn(msg.sender, _setTokenQuantity);
2872 
2873         // Instruct the SetToken to transfer WETH from SetToken to module
2874         _setToken.strictInvokeTransfer(
2875             address(weth),
2876             address(this),
2877             redeemInfo.netFlowQuantity
2878         );
2879 
2880         weth.withdraw(redeemInfo.netFlowQuantity);
2881         
2882         _to.transfer(redeemInfo.netFlowQuantity);
2883 
2884         _handleRedemptionFees(_setToken, address(weth), redeemInfo);
2885 
2886         _handleRedeemStateUpdates(_setToken, address(weth), _to, redeemInfo);
2887     }
2888 
2889     /**
2890      * SET MANAGER ONLY. Add an allowed reserve asset
2891      *
2892      * @param _setToken                     Instance of the SetToken
2893      * @param _reserveAsset                 Address of the reserve asset to add
2894      */
2895     function addReserveAsset(ISetToken _setToken, address _reserveAsset) external onlyManagerAndValidSet(_setToken) {
2896         require(!isReserveAsset[_setToken][_reserveAsset], "Reserve asset already exists");
2897         
2898         navIssuanceSettings[_setToken].reserveAssets.push(_reserveAsset);
2899         isReserveAsset[_setToken][_reserveAsset] = true;
2900 
2901         emit ReserveAssetAdded(_setToken, _reserveAsset);
2902     }
2903 
2904     /**
2905      * SET MANAGER ONLY. Remove a reserve asset
2906      *
2907      * @param _setToken                     Instance of the SetToken
2908      * @param _reserveAsset                 Address of the reserve asset to remove
2909      */
2910     function removeReserveAsset(ISetToken _setToken, address _reserveAsset) external onlyManagerAndValidSet(_setToken) {
2911         require(isReserveAsset[_setToken][_reserveAsset], "Reserve asset does not exist");
2912 
2913         navIssuanceSettings[_setToken].reserveAssets = navIssuanceSettings[_setToken].reserveAssets.remove(_reserveAsset);
2914         delete isReserveAsset[_setToken][_reserveAsset];
2915 
2916         emit ReserveAssetRemoved(_setToken, _reserveAsset);
2917     }
2918 
2919     /**
2920      * SET MANAGER ONLY. Edit the premium percentage
2921      *
2922      * @param _setToken                     Instance of the SetToken
2923      * @param _premiumPercentage            Premium percentage in 10e16 (e.g. 10e16 = 1%)
2924      */
2925     function editPremium(ISetToken _setToken, uint256 _premiumPercentage) external onlyManagerAndValidSet(_setToken) {
2926         require(_premiumPercentage <= navIssuanceSettings[_setToken].maxPremiumPercentage, "Premium must be less than maximum allowed");
2927         
2928         navIssuanceSettings[_setToken].premiumPercentage = _premiumPercentage;
2929 
2930         emit PremiumEdited(_setToken, _premiumPercentage);
2931     }
2932 
2933     /**
2934      * SET MANAGER ONLY. Edit manager fee
2935      *
2936      * @param _setToken                     Instance of the SetToken
2937      * @param _managerFeePercentage         Manager fee percentage in 10e16 (e.g. 10e16 = 1%)
2938      * @param _managerFeeIndex              Manager fee index. 0 index is issue fee, 1 index is redeem fee
2939      */
2940     function editManagerFee(
2941         ISetToken _setToken,
2942         uint256 _managerFeePercentage,
2943         uint256 _managerFeeIndex
2944     )
2945         external
2946         onlyManagerAndValidSet(_setToken)
2947     {
2948         require(_managerFeePercentage <= navIssuanceSettings[_setToken].maxManagerFee, "Manager fee must be less than maximum allowed");
2949         
2950         navIssuanceSettings[_setToken].managerFees[_managerFeeIndex] = _managerFeePercentage;
2951 
2952         emit ManagerFeeEdited(_setToken, _managerFeePercentage, _managerFeeIndex);
2953     }
2954 
2955     /**
2956      * SET MANAGER ONLY. Edit the manager fee recipient
2957      *
2958      * @param _setToken                     Instance of the SetToken
2959      * @param _managerFeeRecipient          Manager fee recipient
2960      */
2961     function editFeeRecipient(ISetToken _setToken, address _managerFeeRecipient) external onlyManagerAndValidSet(_setToken) {
2962         require(_managerFeeRecipient != address(0), "Fee recipient must not be 0 address");
2963         
2964         navIssuanceSettings[_setToken].feeRecipient = _managerFeeRecipient;
2965 
2966         emit FeeRecipientEdited(_setToken, _managerFeeRecipient);
2967     }
2968 
2969     /**
2970      * SET MANAGER ONLY. Initializes this module to the SetToken with hooks, allowed reserve assets,
2971      * fees and issuance premium. Only callable by the SetToken's manager. Hook addresses are optional.
2972      * Address(0) means that no hook will be called.
2973      *
2974      * @param _setToken                     Instance of the SetToken to issue
2975      * @param _navIssuanceSettings          NAVIssuanceSettings struct defining parameters
2976      */
2977     function initialize(
2978         ISetToken _setToken,
2979         NAVIssuanceSettings memory _navIssuanceSettings
2980     )
2981         external
2982         onlySetManager(_setToken, msg.sender)
2983         onlyValidAndPendingSet(_setToken)
2984     {
2985         require(_navIssuanceSettings.reserveAssets.length > 0, "Reserve assets must be greater than 0");
2986         require(_navIssuanceSettings.maxManagerFee < PreciseUnitMath.preciseUnit(), "Max manager fee must be less than 100%");
2987         require(_navIssuanceSettings.maxPremiumPercentage < PreciseUnitMath.preciseUnit(), "Max premium percentage must be less than 100%");
2988         require(_navIssuanceSettings.managerFees[0] <= _navIssuanceSettings.maxManagerFee, "Manager issue fee must be less than max");
2989         require(_navIssuanceSettings.managerFees[1] <= _navIssuanceSettings.maxManagerFee, "Manager redeem fee must be less than max");
2990         require(_navIssuanceSettings.premiumPercentage <= _navIssuanceSettings.maxPremiumPercentage, "Premium must be less than max");
2991         require(_navIssuanceSettings.feeRecipient != address(0), "Fee Recipient must be non-zero address.");
2992         // Initial mint of Set cannot use NAVIssuance since minSetTokenSupply must be > 0
2993         require(_navIssuanceSettings.minSetTokenSupply > 0, "Min SetToken supply must be greater than 0");
2994 
2995         for (uint256 i = 0; i < _navIssuanceSettings.reserveAssets.length; i++) {
2996             require(!isReserveAsset[_setToken][_navIssuanceSettings.reserveAssets[i]], "Reserve assets must be unique");
2997             isReserveAsset[_setToken][_navIssuanceSettings.reserveAssets[i]] = true;
2998         }
2999 
3000         navIssuanceSettings[_setToken] = _navIssuanceSettings;
3001 
3002         _setToken.initializeModule();
3003     }
3004 
3005     /**
3006      * Removes this module from the SetToken, via call by the SetToken. Issuance settings and
3007      * reserve asset states are deleted.
3008      */
3009     function removeModule() external override {
3010         ISetToken setToken = ISetToken(msg.sender);
3011         for (uint256 i = 0; i < navIssuanceSettings[setToken].reserveAssets.length; i++) {
3012             delete isReserveAsset[setToken][navIssuanceSettings[setToken].reserveAssets[i]];
3013         }
3014         
3015         delete navIssuanceSettings[setToken];
3016     }
3017 
3018     receive() external payable {}
3019 
3020     /* ============ External Getter Functions ============ */
3021 
3022     function getReserveAssets(ISetToken _setToken) external view returns (address[] memory) {
3023         return navIssuanceSettings[_setToken].reserveAssets;
3024     }
3025 
3026     function getIssuePremium(
3027         ISetToken _setToken,
3028         address _reserveAsset,
3029         uint256 _reserveAssetQuantity
3030     )
3031         external
3032         view
3033         returns (uint256)
3034     {
3035         return _getIssuePremium(_setToken, _reserveAsset, _reserveAssetQuantity);
3036     }
3037 
3038     function getRedeemPremium(
3039         ISetToken _setToken,
3040         address _reserveAsset,
3041         uint256 _setTokenQuantity
3042     )
3043         external
3044         view
3045         returns (uint256)
3046     {
3047         return _getRedeemPremium(_setToken, _reserveAsset, _setTokenQuantity);
3048     }
3049 
3050     function getManagerFee(ISetToken _setToken, uint256 _managerFeeIndex) external view returns (uint256) {
3051         return navIssuanceSettings[_setToken].managerFees[_managerFeeIndex];
3052     }
3053 
3054     /**
3055      * Get the expected SetTokens minted to recipient on issuance
3056      *
3057      * @param _setToken                     Instance of the SetToken
3058      * @param _reserveAsset                 Address of the reserve asset
3059      * @param _reserveAssetQuantity         Quantity of the reserve asset to issue with
3060      *
3061      * @return  uint256                     Expected SetTokens to be minted to recipient
3062      */
3063     function getExpectedSetTokenIssueQuantity(
3064         ISetToken _setToken,
3065         address _reserveAsset,
3066         uint256 _reserveAssetQuantity
3067     )
3068         external
3069         view
3070         returns (uint256)
3071     {
3072         (,, uint256 netReserveFlow) = _getFees(
3073             _setToken,
3074             _reserveAssetQuantity,
3075             PROTOCOL_ISSUE_MANAGER_REVENUE_SHARE_FEE_INDEX,
3076             PROTOCOL_ISSUE_DIRECT_FEE_INDEX,
3077             MANAGER_ISSUE_FEE_INDEX
3078         );
3079 
3080         uint256 setTotalSupply = _setToken.totalSupply();
3081 
3082         return _getSetTokenMintQuantity(
3083             _setToken,
3084             _reserveAsset,
3085             netReserveFlow,
3086             setTotalSupply
3087         );
3088     }
3089 
3090     /**
3091      * Get the expected reserve asset to be redeemed
3092      *
3093      * @param _setToken                     Instance of the SetToken
3094      * @param _reserveAsset                 Address of the reserve asset
3095      * @param _setTokenQuantity             Quantity of SetTokens to redeem
3096      *
3097      * @return  uint256                     Expected reserve asset quantity redeemed
3098      */
3099     function getExpectedReserveRedeemQuantity(
3100         ISetToken _setToken,
3101         address _reserveAsset,
3102         uint256 _setTokenQuantity
3103     )
3104         external
3105         view
3106         returns (uint256)
3107     {
3108         uint256 preFeeReserveQuantity = _getRedeemReserveQuantity(_setToken, _reserveAsset, _setTokenQuantity);
3109 
3110         (,, uint256 netReserveFlows) = _getFees(
3111             _setToken,
3112             preFeeReserveQuantity,
3113             PROTOCOL_REDEEM_MANAGER_REVENUE_SHARE_FEE_INDEX,
3114             PROTOCOL_REDEEM_DIRECT_FEE_INDEX,
3115             MANAGER_REDEEM_FEE_INDEX
3116         );
3117 
3118         return netReserveFlows;
3119     }
3120 
3121     /**
3122      * Checks if issue is valid
3123      *
3124      * @param _setToken                     Instance of the SetToken
3125      * @param _reserveAsset                 Address of the reserve asset
3126      * @param _reserveAssetQuantity         Quantity of the reserve asset to issue with
3127      *
3128      * @return  bool                        Returns true if issue is valid
3129      */
3130     function isIssueValid(
3131         ISetToken _setToken,
3132         address _reserveAsset,
3133         uint256 _reserveAssetQuantity
3134     )
3135         external
3136         view
3137         returns (bool)
3138     {
3139         uint256 setTotalSupply = _setToken.totalSupply();
3140 
3141     return _reserveAssetQuantity != 0
3142             && isReserveAsset[_setToken][_reserveAsset]
3143             && setTotalSupply >= navIssuanceSettings[_setToken].minSetTokenSupply;
3144     }
3145 
3146     /**
3147      * Checks if redeem is valid
3148      *
3149      * @param _setToken                     Instance of the SetToken
3150      * @param _reserveAsset                 Address of the reserve asset
3151      * @param _setTokenQuantity             Quantity of SetTokens to redeem
3152      *
3153      * @return  bool                        Returns true if redeem is valid
3154      */
3155     function isRedeemValid(
3156         ISetToken _setToken,
3157         address _reserveAsset,
3158         uint256 _setTokenQuantity
3159     )
3160         external
3161         view
3162         returns (bool)
3163     {
3164         uint256 setTotalSupply = _setToken.totalSupply();
3165 
3166         if (
3167             _setTokenQuantity == 0
3168             || !isReserveAsset[_setToken][_reserveAsset]
3169             || setTotalSupply < navIssuanceSettings[_setToken].minSetTokenSupply.add(_setTokenQuantity)
3170         ) {
3171             return false;
3172         } else {
3173             uint256 totalRedeemValue =_getRedeemReserveQuantity(_setToken, _reserveAsset, _setTokenQuantity);
3174 
3175             (,, uint256 expectedRedeemQuantity) = _getFees(
3176                 _setToken,
3177                 totalRedeemValue,
3178                 PROTOCOL_REDEEM_MANAGER_REVENUE_SHARE_FEE_INDEX,
3179                 PROTOCOL_REDEEM_DIRECT_FEE_INDEX,
3180                 MANAGER_REDEEM_FEE_INDEX
3181             );
3182 
3183             uint256 existingUnit = _setToken.getDefaultPositionRealUnit(_reserveAsset).toUint256();
3184 
3185             return existingUnit.preciseMul(setTotalSupply) >= expectedRedeemQuantity;
3186         }
3187     }
3188 
3189     /* ============ Internal Functions ============ */
3190 
3191     function _validateCommon(ISetToken _setToken, address _reserveAsset, uint256 _quantity) internal view {
3192         require(_quantity > 0, "Quantity must be > 0");
3193         require(isReserveAsset[_setToken][_reserveAsset], "Must be valid reserve asset");
3194     }
3195 
3196     function _validateIssuanceInfo(ISetToken _setToken, uint256 _minSetTokenReceiveQuantity, ActionInfo memory _issueInfo) internal view {
3197         // Check that total supply is greater than min supply needed for issuance
3198         // Note: A min supply amount is needed to avoid division by 0 when SetToken supply is 0
3199         require(
3200             _issueInfo.previousSetTokenSupply >= navIssuanceSettings[_setToken].minSetTokenSupply,
3201             "Supply must be greater than minimum to enable issuance"
3202         );
3203 
3204         require(_issueInfo.setTokenQuantity >= _minSetTokenReceiveQuantity, "Must be greater than min SetToken");
3205     }
3206 
3207     function _validateRedemptionInfo(
3208         ISetToken _setToken,
3209         uint256 _minReserveReceiveQuantity,
3210         uint256 _setTokenQuantity,
3211         ActionInfo memory _redeemInfo
3212     )
3213         internal
3214         view
3215     {
3216         // Check that new supply is more than min supply needed for redemption
3217         // Note: A min supply amount is needed to avoid division by 0 when redeeming SetToken to 0
3218         require(
3219             _redeemInfo.newSetTokenSupply >= navIssuanceSettings[_setToken].minSetTokenSupply,
3220             "Supply must be greater than minimum to enable redemption"
3221         );
3222 
3223         require(_redeemInfo.netFlowQuantity >= _minReserveReceiveQuantity, "Must be greater than min receive reserve quantity");
3224     }
3225 
3226     function _createIssuanceInfo(
3227         ISetToken _setToken,
3228         address _reserveAsset,
3229         uint256 _reserveAssetQuantity
3230     )
3231         internal
3232         view
3233         returns (ActionInfo memory)
3234     {
3235         ActionInfo memory issueInfo;
3236 
3237         issueInfo.previousSetTokenSupply = _setToken.totalSupply();
3238 
3239         issueInfo.preFeeReserveQuantity = _reserveAssetQuantity;
3240 
3241         (issueInfo.protocolFees, issueInfo.managerFee, issueInfo.netFlowQuantity) = _getFees(
3242             _setToken,
3243             issueInfo.preFeeReserveQuantity,
3244             PROTOCOL_ISSUE_MANAGER_REVENUE_SHARE_FEE_INDEX,
3245             PROTOCOL_ISSUE_DIRECT_FEE_INDEX,
3246             MANAGER_ISSUE_FEE_INDEX
3247         );
3248 
3249         issueInfo.setTokenQuantity = _getSetTokenMintQuantity(
3250             _setToken,
3251             _reserveAsset,
3252             issueInfo.netFlowQuantity,
3253             issueInfo.previousSetTokenSupply
3254         );
3255 
3256         (issueInfo.newSetTokenSupply, issueInfo.newPositionMultiplier) = _getIssuePositionMultiplier(_setToken, issueInfo);
3257 
3258         issueInfo.newReservePositionUnit = _getIssuePositionUnit(_setToken, _reserveAsset, issueInfo);
3259 
3260         return issueInfo;
3261     }
3262 
3263     function _createRedemptionInfo(
3264         ISetToken _setToken,
3265         address _reserveAsset,
3266         uint256 _setTokenQuantity
3267     )
3268         internal
3269         view
3270         returns (ActionInfo memory)
3271     {
3272         ActionInfo memory redeemInfo;
3273 
3274         redeemInfo.setTokenQuantity = _setTokenQuantity;
3275 
3276         redeemInfo.preFeeReserveQuantity =_getRedeemReserveQuantity(_setToken, _reserveAsset, _setTokenQuantity);
3277 
3278         (redeemInfo.protocolFees, redeemInfo.managerFee, redeemInfo.netFlowQuantity) = _getFees(
3279             _setToken,
3280             redeemInfo.preFeeReserveQuantity,
3281             PROTOCOL_REDEEM_MANAGER_REVENUE_SHARE_FEE_INDEX,
3282             PROTOCOL_REDEEM_DIRECT_FEE_INDEX,
3283             MANAGER_REDEEM_FEE_INDEX
3284         );
3285 
3286         redeemInfo.previousSetTokenSupply = _setToken.totalSupply();
3287 
3288         (redeemInfo.newSetTokenSupply, redeemInfo.newPositionMultiplier) = _getRedeemPositionMultiplier(_setToken, _setTokenQuantity, redeemInfo);
3289 
3290         redeemInfo.newReservePositionUnit = _getRedeemPositionUnit(_setToken, _reserveAsset, redeemInfo);
3291 
3292         return redeemInfo;
3293     }
3294 
3295     /**
3296      * Transfer reserve asset from user to SetToken and fees from user to appropriate fee recipients
3297      */
3298     function _transferCollateralAndHandleFees(ISetToken _setToken, IERC20 _reserveAsset, ActionInfo memory _issueInfo) internal {
3299         transferFrom(_reserveAsset, msg.sender, address(_setToken), _issueInfo.netFlowQuantity);
3300 
3301         if (_issueInfo.protocolFees > 0) {
3302             transferFrom(_reserveAsset, msg.sender, controller.feeRecipient(), _issueInfo.protocolFees);
3303         }
3304 
3305         if (_issueInfo.managerFee > 0) {
3306             transferFrom(_reserveAsset, msg.sender, navIssuanceSettings[_setToken].feeRecipient, _issueInfo.managerFee);
3307         }
3308     }
3309 
3310 
3311     /**
3312       * Transfer WETH from module to SetToken and fees from module to appropriate fee recipients
3313      */
3314     function _transferWETHAndHandleFees(ISetToken _setToken, ActionInfo memory _issueInfo) internal {
3315         weth.transfer(address(_setToken), _issueInfo.netFlowQuantity);
3316 
3317         if (_issueInfo.protocolFees > 0) {
3318             weth.transfer(controller.feeRecipient(), _issueInfo.protocolFees);
3319         }
3320 
3321         if (_issueInfo.managerFee > 0) {
3322             weth.transfer(navIssuanceSettings[_setToken].feeRecipient, _issueInfo.managerFee);
3323         }
3324     }
3325 
3326     function _handleIssueStateUpdates(
3327         ISetToken _setToken,
3328         address _reserveAsset,
3329         address _to,
3330         ActionInfo memory _issueInfo
3331     ) 
3332         internal
3333     {
3334         _setToken.editPositionMultiplier(_issueInfo.newPositionMultiplier);
3335 
3336         _setToken.editDefaultPosition(_reserveAsset, _issueInfo.newReservePositionUnit);
3337 
3338         _setToken.mint(_to, _issueInfo.setTokenQuantity);
3339 
3340         emit SetTokenNAVIssued(
3341             _setToken,
3342             msg.sender,
3343             _to,
3344             _reserveAsset,
3345             address(navIssuanceSettings[_setToken].managerIssuanceHook),
3346             _issueInfo.setTokenQuantity,
3347             _issueInfo.managerFee,
3348             _issueInfo.protocolFees
3349         );        
3350     }
3351 
3352     function _handleRedeemStateUpdates(
3353         ISetToken _setToken,
3354         address _reserveAsset,
3355         address _to,
3356         ActionInfo memory _redeemInfo
3357     ) 
3358         internal
3359     {
3360         _setToken.editPositionMultiplier(_redeemInfo.newPositionMultiplier);
3361 
3362         _setToken.editDefaultPosition(_reserveAsset, _redeemInfo.newReservePositionUnit);
3363 
3364         emit SetTokenNAVRedeemed(
3365             _setToken,
3366             msg.sender,
3367             _to,
3368             _reserveAsset,
3369             address(navIssuanceSettings[_setToken].managerRedemptionHook),
3370             _redeemInfo.setTokenQuantity,
3371             _redeemInfo.managerFee,
3372             _redeemInfo.protocolFees
3373         );      
3374     }
3375 
3376     function _handleRedemptionFees(ISetToken _setToken, address _reserveAsset, ActionInfo memory _redeemInfo) internal {
3377         // Instruct the SetToken to transfer protocol fee to fee recipient if there is a fee
3378         payProtocolFeeFromSetToken(_setToken, _reserveAsset, _redeemInfo.protocolFees);
3379 
3380         // Instruct the SetToken to transfer manager fee to manager fee recipient if there is a fee
3381         if (_redeemInfo.managerFee > 0) {
3382             _setToken.strictInvokeTransfer(
3383                 _reserveAsset,
3384                 navIssuanceSettings[_setToken].feeRecipient,
3385                 _redeemInfo.managerFee
3386             );
3387         }
3388     }
3389 
3390     /**
3391      * Returns the issue premium percentage. Virtual function that can be overridden in future versions of the module
3392      * and can contain arbitrary logic to calculate the issuance premium.
3393      */
3394     function _getIssuePremium(
3395         ISetToken _setToken,
3396         address /* _reserveAsset */,
3397         uint256 /* _reserveAssetQuantity */
3398     )
3399         virtual
3400         internal
3401         view
3402         returns (uint256)
3403     {
3404         return navIssuanceSettings[_setToken].premiumPercentage;
3405     }
3406 
3407     /**
3408      * Returns the redeem premium percentage. Virtual function that can be overridden in future versions of the module
3409      * and can contain arbitrary logic to calculate the redemption premium.
3410      */
3411     function _getRedeemPremium(
3412         ISetToken _setToken,
3413         address /* _reserveAsset */,
3414         uint256 /* _setTokenQuantity */
3415     )
3416         virtual
3417         internal
3418         view
3419         returns (uint256)
3420     {
3421         return navIssuanceSettings[_setToken].premiumPercentage;
3422     }
3423 
3424     /**
3425      * Returns the fees attributed to the manager and the protocol. The fees are calculated as follows:
3426      *
3427      * ManagerFee = (manager fee % - % to protocol) * reserveAssetQuantity
3428      * Protocol Fee = (% manager fee share + direct fee %) * reserveAssetQuantity
3429      *
3430      * @param _setToken                     Instance of the SetToken
3431      * @param _reserveAssetQuantity         Quantity of reserve asset to calculate fees from
3432      * @param _protocolManagerFeeIndex      Index to pull rev share NAV Issuance fee from the Controller
3433      * @param _protocolDirectFeeIndex       Index to pull direct NAV issuance fee from the Controller
3434      * @param _managerFeeIndex              Index from NAVIssuanceSettings (0 = issue fee, 1 = redeem fee)
3435      *
3436      * @return  uint256                     Fees paid to the protocol in reserve asset
3437      * @return  uint256                     Fees paid to the manager in reserve asset
3438      * @return  uint256                     Net reserve to user net of fees
3439      */
3440     function _getFees(
3441         ISetToken _setToken,
3442         uint256 _reserveAssetQuantity,
3443         uint256 _protocolManagerFeeIndex,
3444         uint256 _protocolDirectFeeIndex,
3445         uint256 _managerFeeIndex
3446     )
3447         internal
3448         view
3449         returns (uint256, uint256, uint256)
3450     {
3451         (uint256 protocolFeePercentage, uint256 managerFeePercentage) = _getProtocolAndManagerFeePercentages(
3452             _setToken,
3453             _protocolManagerFeeIndex,
3454             _protocolDirectFeeIndex,
3455             _managerFeeIndex
3456         );
3457 
3458         // Calculate total notional fees
3459         uint256 protocolFees = protocolFeePercentage.preciseMul(_reserveAssetQuantity);
3460         uint256 managerFee = managerFeePercentage.preciseMul(_reserveAssetQuantity);
3461 
3462         uint256 netReserveFlow = _reserveAssetQuantity.sub(protocolFees).sub(managerFee);
3463 
3464         return (protocolFees, managerFee, netReserveFlow);
3465     }
3466 
3467     function _getProtocolAndManagerFeePercentages(
3468         ISetToken _setToken,
3469         uint256 _protocolManagerFeeIndex,
3470         uint256 _protocolDirectFeeIndex,
3471         uint256 _managerFeeIndex
3472     )
3473         internal
3474         view
3475         returns(uint256, uint256)
3476     {
3477         // Get protocol fee percentages
3478         uint256 protocolDirectFeePercent = controller.getModuleFee(address(this), _protocolDirectFeeIndex);
3479         uint256 protocolManagerShareFeePercent = controller.getModuleFee(address(this), _protocolManagerFeeIndex);
3480         uint256 managerFeePercent = navIssuanceSettings[_setToken].managerFees[_managerFeeIndex];
3481         
3482         // Calculate revenue share split percentage
3483         uint256 protocolRevenueSharePercentage = protocolManagerShareFeePercent.preciseMul(managerFeePercent);
3484         uint256 managerRevenueSharePercentage = managerFeePercent.sub(protocolRevenueSharePercentage);
3485         uint256 totalProtocolFeePercentage = protocolRevenueSharePercentage.add(protocolDirectFeePercent);
3486 
3487         return (managerRevenueSharePercentage, totalProtocolFeePercentage);
3488     }
3489 
3490     function _getSetTokenMintQuantity(
3491         ISetToken _setToken,
3492         address _reserveAsset,
3493         uint256 _netReserveFlows,            // Value of reserve asset net of fees
3494         uint256 _setTotalSupply
3495     )
3496         internal
3497         view
3498         returns (uint256)
3499     {
3500         uint256 premiumPercentage = _getIssuePremium(_setToken, _reserveAsset, _netReserveFlows);
3501         uint256 premiumValue = _netReserveFlows.preciseMul(premiumPercentage);
3502 
3503         // Get valuation of the SetToken with the quote asset as the reserve asset. Returns value in precise units (1e18)
3504         // Reverts if price is not found
3505         uint256 setTokenValuation = controller.getSetValuer().calculateSetTokenValuation(_setToken, _reserveAsset);
3506 
3507         // Get reserve asset decimals
3508         uint256 reserveAssetDecimals = ERC20(_reserveAsset).decimals();
3509         uint256 normalizedTotalReserveQuantityNetFees = _netReserveFlows.preciseDiv(10 ** reserveAssetDecimals);
3510         uint256 normalizedTotalReserveQuantityNetFeesAndPremium = _netReserveFlows.sub(premiumValue).preciseDiv(10 ** reserveAssetDecimals);
3511 
3512         // Calculate SetTokens to mint to issuer
3513         uint256 denominator = _setTotalSupply.preciseMul(setTokenValuation).add(normalizedTotalReserveQuantityNetFees).sub(normalizedTotalReserveQuantityNetFeesAndPremium);
3514         return normalizedTotalReserveQuantityNetFeesAndPremium.preciseMul(_setTotalSupply).preciseDiv(denominator);
3515     }
3516 
3517     function _getRedeemReserveQuantity(
3518         ISetToken _setToken,
3519         address _reserveAsset,
3520         uint256 _setTokenQuantity
3521     )
3522         internal
3523         view
3524         returns (uint256)
3525     {
3526         // Get valuation of the SetToken with the quote asset as the reserve asset. Returns value in precise units (10e18)
3527         // Reverts if price is not found
3528         uint256 setTokenValuation = controller.getSetValuer().calculateSetTokenValuation(_setToken, _reserveAsset);
3529 
3530         uint256 totalRedeemValueInPreciseUnits = _setTokenQuantity.preciseMul(setTokenValuation);
3531         // Get reserve asset decimals
3532         uint256 reserveAssetDecimals = ERC20(_reserveAsset).decimals();
3533         uint256 prePremiumReserveQuantity = totalRedeemValueInPreciseUnits.preciseMul(10 ** reserveAssetDecimals);
3534 
3535         uint256 premiumPercentage = _getRedeemPremium(_setToken, _reserveAsset, _setTokenQuantity);
3536         uint256 premiumQuantity = prePremiumReserveQuantity.preciseMulCeil(premiumPercentage);
3537 
3538         return prePremiumReserveQuantity.sub(premiumQuantity);
3539     }
3540 
3541     /**
3542      * The new position multiplier is calculated as follows:
3543      * inflationPercentage = (newSupply - oldSupply) / newSupply
3544      * newMultiplier = (1 - inflationPercentage) * positionMultiplier
3545      */    
3546     function _getIssuePositionMultiplier(
3547         ISetToken _setToken,
3548         ActionInfo memory _issueInfo
3549     )
3550         internal
3551         view
3552         returns (uint256, int256)
3553     {
3554         // Calculate inflation and new position multiplier. Note: Round inflation up in order to round position multiplier down
3555         uint256 newTotalSupply = _issueInfo.setTokenQuantity.add(_issueInfo.previousSetTokenSupply);
3556         int256 newPositionMultiplier = _setToken.positionMultiplier()
3557             .mul(_issueInfo.previousSetTokenSupply.toInt256())
3558             .div(newTotalSupply.toInt256());
3559 
3560         return (newTotalSupply, newPositionMultiplier);
3561     }
3562 
3563     /**
3564      * Calculate deflation and new position multiplier. Note: Round deflation down in order to round position multiplier down
3565      * 
3566      * The new position multiplier is calculated as follows:
3567      * deflationPercentage = (oldSupply - newSupply) / newSupply
3568      * newMultiplier = (1 + deflationPercentage) * positionMultiplier
3569      */ 
3570     function _getRedeemPositionMultiplier(
3571         ISetToken _setToken,
3572         uint256 _setTokenQuantity,
3573         ActionInfo memory _redeemInfo
3574     )
3575         internal
3576         view
3577         returns (uint256, int256)
3578     {
3579         uint256 newTotalSupply = _redeemInfo.previousSetTokenSupply.sub(_setTokenQuantity);
3580         int256 newPositionMultiplier = _setToken.positionMultiplier()
3581             .mul(_redeemInfo.previousSetTokenSupply.toInt256())
3582             .div(newTotalSupply.toInt256());
3583 
3584         return (newTotalSupply, newPositionMultiplier);
3585     }
3586 
3587     /**
3588      * The new position reserve asset unit is calculated as follows:
3589      * totalReserve = (oldUnit * oldSetTokenSupply) + reserveQuantity
3590      * newUnit = totalReserve / newSetTokenSupply
3591      */ 
3592     function _getIssuePositionUnit(
3593         ISetToken _setToken,
3594         address _reserveAsset,
3595         ActionInfo memory _issueInfo
3596     )
3597         internal
3598         view
3599         returns (uint256)
3600     {
3601         uint256 existingUnit = _setToken.getDefaultPositionRealUnit(_reserveAsset).toUint256();
3602         uint256 totalReserve = existingUnit
3603             .preciseMul(_issueInfo.previousSetTokenSupply)
3604             .add(_issueInfo.netFlowQuantity);
3605 
3606         return totalReserve.preciseDiv(_issueInfo.newSetTokenSupply);
3607     }
3608 
3609     /**
3610      * The new position reserve asset unit is calculated as follows:
3611      * totalReserve = (oldUnit * oldSetTokenSupply) - reserveQuantityToSendOut
3612      * newUnit = totalReserve / newSetTokenSupply
3613      */ 
3614     function _getRedeemPositionUnit(
3615         ISetToken _setToken,
3616         address _reserveAsset,
3617         ActionInfo memory _redeemInfo
3618     )
3619         internal
3620         view
3621         returns (uint256)
3622     {
3623         uint256 existingUnit = _setToken.getDefaultPositionRealUnit(_reserveAsset).toUint256();
3624         uint256 totalExistingUnits = existingUnit.preciseMul(_redeemInfo.previousSetTokenSupply);
3625 
3626         uint256 outflow = _redeemInfo.netFlowQuantity.add(_redeemInfo.protocolFees).add(_redeemInfo.managerFee);
3627 
3628         // Require withdrawable quantity is greater than existing collateral
3629         require(totalExistingUnits >= outflow, "Must be greater than total available collateral");
3630 
3631         return totalExistingUnits.sub(outflow).preciseDiv(_redeemInfo.newSetTokenSupply);
3632     }
3633 
3634     /**
3635      * If a pre-issue hook has been configured, call the external-protocol contract. Pre-issue hook logic
3636      * can contain arbitrary logic including validations, external function calls, etc.
3637      */
3638     function _callPreIssueHooks(
3639         ISetToken _setToken,
3640         address _reserveAsset,
3641         uint256 _reserveAssetQuantity,
3642         address _caller,
3643         address _to
3644     )
3645         internal
3646     {
3647         INAVIssuanceHook preIssueHook = navIssuanceSettings[_setToken].managerIssuanceHook;
3648         if (address(preIssueHook) != address(0)) {
3649             preIssueHook.invokePreIssueHook(_setToken, _reserveAsset, _reserveAssetQuantity, _caller, _to);
3650         }
3651     }
3652 
3653     /**
3654      * If a pre-redeem hook has been configured, call the external-protocol contract.
3655      */
3656     function _callPreRedeemHooks(ISetToken _setToken, uint256 _setQuantity, address _caller, address _to) internal {
3657         INAVIssuanceHook preRedeemHook = navIssuanceSettings[_setToken].managerRedemptionHook;
3658         if (address(preRedeemHook) != address(0)) {
3659             preRedeemHook.invokePreRedeemHook(_setToken, _setQuantity, _caller, _to);
3660         }
3661     }
3662 }