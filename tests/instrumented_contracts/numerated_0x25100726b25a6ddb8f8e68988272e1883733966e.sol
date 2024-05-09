1 // Dependency file: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 
5 // pragma solidity ^0.6.2;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [// importANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
30         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
31         // for accounts without code, i.e. `keccak256('')`
32         bytes32 codehash;
33         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { codehash := extcodehash(account) }
36         return (codehash != accountHash && codehash != 0x0);
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * // importANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return _functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         return _functionCallWithValue(target, data, value, errorMessage);
119     }
120 
121     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
122         require(isContract(target), "Address: call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
126         if (success) {
127             return returndata;
128         } else {
129             // Look for revert reason and bubble it up if present
130             if (returndata.length > 0) {
131                 // The easiest way to bubble the revert reason is using memory via assembly
132 
133                 // solhint-disable-next-line no-inline-assembly
134                 assembly {
135                     let returndata_size := mload(returndata)
136                     revert(add(32, returndata), returndata_size)
137                 }
138             } else {
139                 revert(errorMessage);
140             }
141         }
142     }
143 }
144 
145 // Dependency file: contracts/interfaces/ISetValuer.sol
146 
147 /*
148     Copyright 2020 Set Labs Inc.
149 
150     Licensed under the Apache License, Version 2.0 (the "License");
151     you may not use this file except in compliance with the License.
152     You may obtain a copy of the License at
153 
154     http://www.apache.org/licenses/LICENSE-2.0
155 
156     Unless required by applicable law or agreed to in writing, software
157     distributed under the License is distributed on an "AS IS" BASIS,
158     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
159     See the License for the specific language governing permissions and
160     limitations under the License.
161 
162 
163 */
164 // pragma solidity 0.6.10;
165 
166 // import { ISetToken } from "../interfaces/ISetToken.sol";
167 
168 interface ISetValuer {
169     function calculateSetTokenValuation(ISetToken _setToken, address _quoteAsset) external view returns (uint256);
170 }
171 // Dependency file: contracts/interfaces/IPriceOracle.sol
172 
173 /*
174     Copyright 2020 Set Labs Inc.
175 
176     Licensed under the Apache License, Version 2.0 (the "License");
177     you may not use this file except in compliance with the License.
178     You may obtain a copy of the License at
179 
180     http://www.apache.org/licenses/LICENSE-2.0
181 
182     Unless required by applicable law or agreed to in writing, software
183     distributed under the License is distributed on an "AS IS" BASIS,
184     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
185     See the License for the specific language governing permissions and
186     limitations under the License.
187 
188 
189 */
190 // pragma solidity 0.6.10;
191 
192 /**
193  * @title IPriceOracle
194  * @author Set Protocol
195  *
196  * Interface for interacting with PriceOracle
197  */
198 interface IPriceOracle {
199 
200     /* ============ Functions ============ */
201 
202     function getPrice(address _assetOne, address _assetTwo) external view returns (uint256);
203     function masterQuoteAsset() external view returns (address);
204 }
205 // Dependency file: contracts/interfaces/IIntegrationRegistry.sol
206 
207 /*
208     Copyright 2020 Set Labs Inc.
209 
210     Licensed under the Apache License, Version 2.0 (the "License");
211     you may not use this file except in compliance with the License.
212     You may obtain a copy of the License at
213 
214     http://www.apache.org/licenses/LICENSE-2.0
215 
216     Unless required by applicable law or agreed to in writing, software
217     distributed under the License is distributed on an "AS IS" BASIS,
218     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
219     See the License for the specific language governing permissions and
220     limitations under the License.
221 
222 
223 */
224 // pragma solidity 0.6.10;
225 
226 interface IIntegrationRegistry {
227     function addIntegration(address _module, string memory _id, address _wrapper) external;
228     function getIntegrationAdapter(address _module, string memory _id) external view returns(address);
229     function getIntegrationAdapterWithHash(address _module, bytes32 _id) external view returns(address);
230     function isValidIntegration(address _module, string memory _id) external view returns(bool);
231 }
232 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
233 
234 
235 
236 // pragma solidity ^0.6.0;
237 
238 // import "./IERC20.sol";
239 // import "../../math/SafeMath.sol";
240 // import "../../utils/Address.sol";
241 
242 /**
243  * @title SafeERC20
244  * @dev Wrappers around ERC20 operations that throw on failure (when the token
245  * contract returns false). Tokens that return no value (and instead revert or
246  * throw on failure) are also supported, non-reverting calls are assumed to be
247  * successful.
248  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
249  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
250  */
251 library SafeERC20 {
252     using SafeMath for uint256;
253     using Address for address;
254 
255     function safeTransfer(IERC20 token, address to, uint256 value) internal {
256         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
257     }
258 
259     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
260         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
261     }
262 
263     /**
264      * @dev Deprecated. This function has issues similar to the ones found in
265      * {IERC20-approve}, and its usage is discouraged.
266      *
267      * Whenever possible, use {safeIncreaseAllowance} and
268      * {safeDecreaseAllowance} instead.
269      */
270     function safeApprove(IERC20 token, address spender, uint256 value) internal {
271         // safeApprove should only be called when setting an initial allowance,
272         // or when resetting it to zero. To increase and decrease it, use
273         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
274         // solhint-disable-next-line max-line-length
275         require((value == 0) || (token.allowance(address(this), spender) == 0),
276             "SafeERC20: approve from non-zero to non-zero allowance"
277         );
278         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
279     }
280 
281     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
282         uint256 newAllowance = token.allowance(address(this), spender).add(value);
283         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
284     }
285 
286     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
287         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
288         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
289     }
290 
291     /**
292      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
293      * on the return value: the return value is optional (but if data is returned, it must not be false).
294      * @param token The token targeted by the call.
295      * @param data The call data (encoded using abi.encode or one of its variants).
296      */
297     function _callOptionalReturn(IERC20 token, bytes memory data) private {
298         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
299         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
300         // the target address contains contract code and also asserts for success in the low-level call.
301 
302         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
303         if (returndata.length > 0) { // Return data is optional
304             // solhint-disable-next-line max-line-length
305             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
306         }
307     }
308 }
309 
310 // Dependency file: @openzeppelin/contracts/math/SignedSafeMath.sol
311 
312 
313 
314 // pragma solidity ^0.6.0;
315 
316 /**
317  * @title SignedSafeMath
318  * @dev Signed math operations with safety checks that revert on error.
319  */
320 library SignedSafeMath {
321     int256 constant private _INT256_MIN = -2**255;
322 
323         /**
324      * @dev Returns the multiplication of two signed integers, reverting on
325      * overflow.
326      *
327      * Counterpart to Solidity's `*` operator.
328      *
329      * Requirements:
330      *
331      * - Multiplication cannot overflow.
332      */
333     function mul(int256 a, int256 b) internal pure returns (int256) {
334         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
335         // benefit is lost if 'b' is also tested.
336         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
337         if (a == 0) {
338             return 0;
339         }
340 
341         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
342 
343         int256 c = a * b;
344         require(c / a == b, "SignedSafeMath: multiplication overflow");
345 
346         return c;
347     }
348 
349     /**
350      * @dev Returns the integer division of two signed integers. Reverts on
351      * division by zero. The result is rounded towards zero.
352      *
353      * Counterpart to Solidity's `/` operator. Note: this function uses a
354      * `revert` opcode (which leaves remaining gas untouched) while Solidity
355      * uses an invalid opcode to revert (consuming all remaining gas).
356      *
357      * Requirements:
358      *
359      * - The divisor cannot be zero.
360      */
361     function div(int256 a, int256 b) internal pure returns (int256) {
362         require(b != 0, "SignedSafeMath: division by zero");
363         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
364 
365         int256 c = a / b;
366 
367         return c;
368     }
369 
370     /**
371      * @dev Returns the subtraction of two signed integers, reverting on
372      * overflow.
373      *
374      * Counterpart to Solidity's `-` operator.
375      *
376      * Requirements:
377      *
378      * - Subtraction cannot overflow.
379      */
380     function sub(int256 a, int256 b) internal pure returns (int256) {
381         int256 c = a - b;
382         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
383 
384         return c;
385     }
386 
387     /**
388      * @dev Returns the addition of two signed integers, reverting on
389      * overflow.
390      *
391      * Counterpart to Solidity's `+` operator.
392      *
393      * Requirements:
394      *
395      * - Addition cannot overflow.
396      */
397     function add(int256 a, int256 b) internal pure returns (int256) {
398         int256 c = a + b;
399         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
400 
401         return c;
402     }
403 }
404 
405 // Dependency file: contracts/protocol/lib/ResourceIdentifier.sol
406 
407 /*
408     Copyright 2020 Set Labs Inc.
409 
410     Licensed under the Apache License, Version 2.0 (the "License");
411     you may not use this file except in compliance with the License.
412     You may obtain a copy of the License at
413 
414     http://www.apache.org/licenses/LICENSE-2.0
415 
416     Unless required by applicable law or agreed to in writing, software
417     distributed under the License is distributed on an "AS IS" BASIS,
418     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
419     See the License for the specific language governing permissions and
420     limitations under the License.
421 
422 
423 */
424 
425 // pragma solidity 0.6.10;
426 
427 // import { IController } from "../../interfaces/IController.sol";
428 // import { IIntegrationRegistry } from "../../interfaces/IIntegrationRegistry.sol";
429 // import { IPriceOracle } from "../../interfaces/IPriceOracle.sol";
430 // import { ISetValuer } from "../../interfaces/ISetValuer.sol";
431 
432 /**
433  * @title ResourceIdentifier
434  * @author Set Protocol
435  *
436  * A collection of utility functions to fetch information related to Resource contracts in the system
437  */
438 library ResourceIdentifier {
439 
440     // IntegrationRegistry will always be resource ID 0 in the system
441     uint256 constant internal INTEGRATION_REGISTRY_RESOURCE_ID = 0;
442     // PriceOracle will always be resource ID 1 in the system
443     uint256 constant internal PRICE_ORACLE_RESOURCE_ID = 1;
444     // SetValuer resource will always be resource ID 2 in the system
445     uint256 constant internal SET_VALUER_RESOURCE_ID = 2;
446 
447     /* ============ Internal ============ */
448 
449     /**
450      * Gets the instance of integration registry stored on Controller. Note: IntegrationRegistry is stored as index 0 on
451      * the Controller
452      */
453     function getIntegrationRegistry(IController _controller) internal view returns (IIntegrationRegistry) {
454         return IIntegrationRegistry(_controller.resourceId(INTEGRATION_REGISTRY_RESOURCE_ID));
455     }
456 
457     /**
458      * Gets instance of price oracle on Controller. Note: PriceOracle is stored as index 1 on the Controller
459      */
460     function getPriceOracle(IController _controller) internal view returns (IPriceOracle) {
461         return IPriceOracle(_controller.resourceId(PRICE_ORACLE_RESOURCE_ID));
462     }
463 
464     /**
465      * Gets the instance of Set valuer on Controller. Note: SetValuer is stored as index 2 on the Controller
466      */
467     function getSetValuer(IController _controller) internal view returns (ISetValuer) {
468         return ISetValuer(_controller.resourceId(SET_VALUER_RESOURCE_ID));
469     }
470 }
471 // Dependency file: contracts/interfaces/IModule.sol
472 
473 /*
474     Copyright 2020 Set Labs Inc.
475 
476     Licensed under the Apache License, Version 2.0 (the "License");
477     you may not use this file except in compliance with the License.
478     You may obtain a copy of the License at
479 
480     http://www.apache.org/licenses/LICENSE-2.0
481 
482     Unless required by applicable law or agreed to in writing, software
483     distributed under the License is distributed on an "AS IS" BASIS,
484     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
485     See the License for the specific language governing permissions and
486     limitations under the License.
487 
488 
489 */
490 // pragma solidity 0.6.10;
491 
492 
493 /**
494  * @title IModule
495  * @author Set Protocol
496  *
497  * Interface for interacting with Modules.
498  */
499 interface IModule {
500     /**
501      * Called by a SetToken to notify that this module was removed from the Set token. Any logic can be included
502      * in case checks need to be made or state needs to be cleared.
503      */
504     function removeModule() external;
505 }
506 // Dependency file: contracts/lib/ExplicitERC20.sol
507 
508 /*
509     Copyright 2020 Set Labs Inc.
510 
511     Licensed under the Apache License, Version 2.0 (the "License");
512     you may not use this file except in compliance with the License.
513     You may obtain a copy of the License at
514 
515     http://www.apache.org/licenses/LICENSE-2.0
516 
517     Unless required by applicable law or agreed to in writing, software
518     distributed under the License is distributed on an "AS IS" BASIS,
519     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
520     See the License for the specific language governing permissions and
521     limitations under the License.
522 
523 
524 */
525 
526 // pragma solidity 0.6.10;
527 
528 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
529 // import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
530 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
531 
532 /**
533  * @title ExplicitERC20
534  * @author Set Protocol
535  *
536  * Utility functions for ERC20 transfers that require the explicit amount to be transferred.
537  */
538 library ExplicitERC20 {
539     using SafeMath for uint256;
540 
541     /**
542      * When given allowance, transfers a token from the "_from" to the "_to" of quantity "_quantity".
543      * Ensures that the recipient has received the correct quantity (ie no fees taken on transfer)
544      *
545      * @param _token           ERC20 token to approve
546      * @param _from            The account to transfer tokens from
547      * @param _to              The account to transfer tokens to
548      * @param _quantity        The quantity to transfer
549      */
550     function transferFrom(
551         IERC20 _token,
552         address _from,
553         address _to,
554         uint256 _quantity
555     )
556         internal
557     {
558         // Call specified ERC20 contract to transfer tokens (via proxy).
559         if (_quantity > 0) {
560             uint256 existingBalance = _token.balanceOf(_to);
561 
562             SafeERC20.safeTransferFrom(
563                 _token,
564                 _from,
565                 _to,
566                 _quantity
567             );
568 
569             uint256 newBalance = _token.balanceOf(_to);
570 
571             // Verify transfer quantity is reflected in balance
572             require(
573                 newBalance == existingBalance.add(_quantity),
574                 "Invalid post transfer balance"
575             );
576         }
577     }
578 }
579 
580 // Dependency file: contracts/lib/Uint256ArrayUtils.sol
581 
582 /*
583     Copyright 2020 Set Labs Inc.
584 
585     Licensed under the Apache License, Version 2.0 (the "License");
586     you may not use this file except in compliance with the License.
587     You may obtain a copy of the License at
588 
589     http://www.apache.org/licenses/LICENSE-2.0
590 
591     Unless required by applicable law or agreed to in writing, software
592     distributed under the License is distributed on an "AS IS" BASIS,
593     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
594     See the License for the specific language governing permissions and
595     limitations under the License.
596 
597 
598 */
599 
600 // pragma solidity 0.6.10;
601 
602 /**
603  * @title Uint256ArrayUtils
604  * @author Set Protocol
605  *
606  * Utility functions to handle Uint256 Arrays
607  */
608 library Uint256ArrayUtils {
609 
610     /**
611      * Returns the combination of the two arrays
612      * @param A The first array
613      * @param B The second array
614      * @return Returns A extended by B
615      */
616     function extend(uint256[] memory A, uint256[] memory B) internal pure returns (uint256[] memory) {
617         uint256 aLength = A.length;
618         uint256 bLength = B.length;
619         uint256[] memory newUints = new uint256[](aLength + bLength);
620         for (uint256 i = 0; i < aLength; i++) {
621             newUints[i] = A[i];
622         }
623         for (uint256 j = 0; j < bLength; j++) {
624             newUints[aLength + j] = B[j];
625         }
626         return newUints;
627     }
628 }
629 // Dependency file: contracts/lib/PreciseUnitMath.sol
630 
631 /*
632     Copyright 2020 Set Labs Inc.
633 
634     Licensed under the Apache License, Version 2.0 (the "License");
635     you may not use this file except in compliance with the License.
636     You may obtain a copy of the License at
637 
638     http://www.apache.org/licenses/LICENSE-2.0
639 
640     Unless required by applicable law or agreed to in writing, software
641     distributed under the License is distributed on an "AS IS" BASIS,
642     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
643     See the License for the specific language governing permissions and
644     limitations under the License.
645 
646 
647 */
648 
649 // pragma solidity 0.6.10;
650 // pragma experimental ABIEncoderV2;
651 
652 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
653 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
654 
655 
656 /**
657  * @title PreciseUnitMath
658  * @author Set Protocol
659  *
660  * Arithmetic for fixed-point numbers with 18 decimals of precision. Some functions taken from
661  * dYdX's BaseMath library.
662  *
663  * CHANGELOG:
664  * - 9/21/20: Added safePower function
665  */
666 library PreciseUnitMath {
667     using SafeMath for uint256;
668     using SignedSafeMath for int256;
669 
670     // The number One in precise units.
671     uint256 constant internal PRECISE_UNIT = 10 ** 18;
672     int256 constant internal PRECISE_UNIT_INT = 10 ** 18;
673 
674     // Max unsigned integer value
675     uint256 constant internal MAX_UINT_256 = type(uint256).max;
676     // Max and min signed integer value
677     int256 constant internal MAX_INT_256 = type(int256).max;
678     int256 constant internal MIN_INT_256 = type(int256).min;
679 
680     /**
681      * @dev Getter function since constants can't be read directly from libraries.
682      */
683     function preciseUnit() internal pure returns (uint256) {
684         return PRECISE_UNIT;
685     }
686 
687     /**
688      * @dev Getter function since constants can't be read directly from libraries.
689      */
690     function preciseUnitInt() internal pure returns (int256) {
691         return PRECISE_UNIT_INT;
692     }
693 
694     /**
695      * @dev Getter function since constants can't be read directly from libraries.
696      */
697     function maxUint256() internal pure returns (uint256) {
698         return MAX_UINT_256;
699     }
700 
701     /**
702      * @dev Getter function since constants can't be read directly from libraries.
703      */
704     function maxInt256() internal pure returns (int256) {
705         return MAX_INT_256;
706     }
707 
708     /**
709      * @dev Getter function since constants can't be read directly from libraries.
710      */
711     function minInt256() internal pure returns (int256) {
712         return MIN_INT_256;
713     }
714 
715     /**
716      * @dev Multiplies value a by value b (result is rounded down). It's assumed that the value b is the significand
717      * of a number with 18 decimals precision.
718      */
719     function preciseMul(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a.mul(b).div(PRECISE_UNIT);
721     }
722 
723     /**
724      * @dev Multiplies value a by value b (result is rounded towards zero). It's assumed that the value b is the
725      * significand of a number with 18 decimals precision.
726      */
727     function preciseMul(int256 a, int256 b) internal pure returns (int256) {
728         return a.mul(b).div(PRECISE_UNIT_INT);
729     }
730 
731     /**
732      * @dev Multiplies value a by value b (result is rounded up). It's assumed that the value b is the significand
733      * of a number with 18 decimals precision.
734      */
735     function preciseMulCeil(uint256 a, uint256 b) internal pure returns (uint256) {
736         if (a == 0 || b == 0) {
737             return 0;
738         }
739         return a.mul(b).sub(1).div(PRECISE_UNIT).add(1);
740     }
741 
742     /**
743      * @dev Divides value a by value b (result is rounded down).
744      */
745     function preciseDiv(uint256 a, uint256 b) internal pure returns (uint256) {
746         return a.mul(PRECISE_UNIT).div(b);
747     }
748 
749 
750     /**
751      * @dev Divides value a by value b (result is rounded towards 0).
752      */
753     function preciseDiv(int256 a, int256 b) internal pure returns (int256) {
754         return a.mul(PRECISE_UNIT_INT).div(b);
755     }
756 
757     /**
758      * @dev Divides value a by value b (result is rounded up or away from 0).
759      */
760     function preciseDivCeil(uint256 a, uint256 b) internal pure returns (uint256) {
761         require(b != 0, "Cant divide by 0");
762 
763         return a > 0 ? a.mul(PRECISE_UNIT).sub(1).div(b).add(1) : 0;
764     }
765 
766     /**
767      * @dev Divides value a by value b (result is rounded down - positive numbers toward 0 and negative away from 0).
768      */
769     function divDown(int256 a, int256 b) internal pure returns (int256) {
770         require(b != 0, "Cant divide by 0");
771         require(a != MIN_INT_256 || b != -1, "Invalid input");
772 
773         int256 result = a.div(b);
774         if (a ^ b < 0 && a % b != 0) {
775             result -= 1;
776         }
777 
778         return result;
779     }
780 
781     /**
782      * @dev Multiplies value a by value b where rounding is towards the lesser number. 
783      * (positive values are rounded towards zero and negative values are rounded away from 0). 
784      */
785     function conservativePreciseMul(int256 a, int256 b) internal pure returns (int256) {
786         return divDown(a.mul(b), PRECISE_UNIT_INT);
787     }
788 
789     /**
790      * @dev Divides value a by value b where rounding is towards the lesser number. 
791      * (positive values are rounded towards zero and negative values are rounded away from 0). 
792      */
793     function conservativePreciseDiv(int256 a, int256 b) internal pure returns (int256) {
794         return divDown(a.mul(PRECISE_UNIT_INT), b);
795     }
796 
797     /**
798     * @dev Performs the power on a specified value, reverts on overflow.
799     */
800     function safePower(
801         uint256 a,
802         uint256 pow
803     )
804         internal
805         pure
806         returns (uint256)
807     {
808         require(a > 0, "Value must be positive");
809 
810         uint256 result = 1;
811         for (uint256 i = 0; i < pow; i++){
812             uint256 previousResult = result;
813 
814             // Using safemath multiplication prevents overflows
815             result = previousResult.mul(a);
816         }
817 
818         return result;
819     }
820 }
821 // Dependency file: contracts/protocol/lib/Position.sol
822 
823 /*
824     Copyright 2020 Set Labs Inc.
825 
826     Licensed under the Apache License, Version 2.0 (the "License");
827     you may not use this file except in compliance with the License.
828     You may obtain a copy of the License at
829 
830     http://www.apache.org/licenses/LICENSE-2.0
831 
832     Unless required by applicable law or agreed to in writing, software
833     distributed under the License is distributed on an "AS IS" BASIS,
834     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
835     See the License for the specific language governing permissions and
836     limitations under the License.
837 
838 
839 */
840 
841 // pragma solidity 0.6.10;
842 // pragma experimental "ABIEncoderV2";
843 
844 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
845 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
846 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
847 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
848 
849 // import { ISetToken } from "../../interfaces/ISetToken.sol";
850 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
851 
852 
853 /**
854  * @title Position
855  * @author Set Protocol
856  *
857  * Collection of helper functions for handling and updating SetToken Positions
858  *
859  * CHANGELOG:
860  *  - Updated editExternalPosition to work when no external position is associated with module
861  */
862 library Position {
863     using SafeCast for uint256;
864     using SafeMath for uint256;
865     using SafeCast for int256;
866     using SignedSafeMath for int256;
867     using PreciseUnitMath for uint256;
868 
869     /* ============ Helper ============ */
870 
871     /**
872      * Returns whether the SetToken has a default position for a given component (if the real unit is > 0)
873      */
874     function hasDefaultPosition(ISetToken _setToken, address _component) internal view returns(bool) {
875         return _setToken.getDefaultPositionRealUnit(_component) > 0;
876     }
877 
878     /**
879      * Returns whether the SetToken has an external position for a given component (if # of position modules is > 0)
880      */
881     function hasExternalPosition(ISetToken _setToken, address _component) internal view returns(bool) {
882         return _setToken.getExternalPositionModules(_component).length > 0;
883     }
884     
885     /**
886      * Returns whether the SetToken component default position real unit is greater than or equal to units passed in.
887      */
888     function hasSufficientDefaultUnits(ISetToken _setToken, address _component, uint256 _unit) internal view returns(bool) {
889         return _setToken.getDefaultPositionRealUnit(_component) >= _unit.toInt256();
890     }
891 
892     /**
893      * Returns whether the SetToken component external position is greater than or equal to the real units passed in.
894      */
895     function hasSufficientExternalUnits(
896         ISetToken _setToken,
897         address _component,
898         address _positionModule,
899         uint256 _unit
900     )
901         internal
902         view
903         returns(bool)
904     {
905        return _setToken.getExternalPositionRealUnit(_component, _positionModule) >= _unit.toInt256();    
906     }
907 
908     /**
909      * If the position does not exist, create a new Position and add to the SetToken. If it already exists,
910      * then set the position units. If the new units is 0, remove the position. Handles adding/removing of 
911      * components where needed (in light of potential external positions).
912      *
913      * @param _setToken           Address of SetToken being modified
914      * @param _component          Address of the component
915      * @param _newUnit            Quantity of Position units - must be >= 0
916      */
917     function editDefaultPosition(ISetToken _setToken, address _component, uint256 _newUnit) internal {
918         bool isPositionFound = hasDefaultPosition(_setToken, _component);
919         if (!isPositionFound && _newUnit > 0) {
920             // If there is no Default Position and no External Modules, then component does not exist
921             if (!hasExternalPosition(_setToken, _component)) {
922                 _setToken.addComponent(_component);
923             }
924         } else if (isPositionFound && _newUnit == 0) {
925             // If there is a Default Position and no external positions, remove the component
926             if (!hasExternalPosition(_setToken, _component)) {
927                 _setToken.removeComponent(_component);
928             }
929         }
930 
931         _setToken.editDefaultPositionUnit(_component, _newUnit.toInt256());
932     }
933 
934     /**
935      * Update an external position and remove and external positions or components if necessary. The logic flows as follows:
936      * 1) If component is not already added then add component and external position. 
937      * 2) If component is added but no existing external position using the passed module exists then add the external position.
938      * 3) If the existing position is being added to then just update the unit and data
939      * 4) If the position is being closed and no other external positions or default positions are associated with the component
940      *    then untrack the component and remove external position.
941      * 5) If the position is being closed and other existing positions still exist for the component then just remove the
942      *    external position.
943      *
944      * @param _setToken         SetToken being updated
945      * @param _component        Component position being updated
946      * @param _module           Module external position is associated with
947      * @param _newUnit          Position units of new external position
948      * @param _data             Arbitrary data associated with the position
949      */
950     function editExternalPosition(
951         ISetToken _setToken,
952         address _component,
953         address _module,
954         int256 _newUnit,
955         bytes memory _data
956     )
957         internal
958     {
959         if (_newUnit != 0) {
960             if (!_setToken.isComponent(_component)) {
961                 _setToken.addComponent(_component);
962                 _setToken.addExternalPositionModule(_component, _module);
963             } else if (!_setToken.isExternalPositionModule(_component, _module)) {
964                 _setToken.addExternalPositionModule(_component, _module);
965             }
966             _setToken.editExternalPositionUnit(_component, _module, _newUnit);
967             _setToken.editExternalPositionData(_component, _module, _data);
968         } else {
969             require(_data.length == 0, "Passed data must be null");
970             // If no default or external position remaining then remove component from components array
971             if (_setToken.getExternalPositionRealUnit(_component, _module) != 0) {
972                 address[] memory positionModules = _setToken.getExternalPositionModules(_component);
973                 if (_setToken.getDefaultPositionRealUnit(_component) == 0 && positionModules.length == 1) {
974                     require(positionModules[0] == _module, "External positions must be 0 to remove component");
975                     _setToken.removeComponent(_component);
976                 }
977                 _setToken.removeExternalPositionModule(_component, _module);
978             }
979         }
980     }
981 
982     /**
983      * Get total notional amount of Default position
984      *
985      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
986      * @param _positionUnit       Quantity of Position units
987      *
988      * @return                    Total notional amount of units
989      */
990     function getDefaultTotalNotional(uint256 _setTokenSupply, uint256 _positionUnit) internal pure returns (uint256) {
991         return _setTokenSupply.preciseMul(_positionUnit);
992     }
993 
994     /**
995      * Get position unit from total notional amount
996      *
997      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
998      * @param _totalNotional      Total notional amount of component prior to
999      * @return                    Default position unit
1000      */
1001     function getDefaultPositionUnit(uint256 _setTokenSupply, uint256 _totalNotional) internal pure returns (uint256) {
1002         return _totalNotional.preciseDiv(_setTokenSupply);
1003     }
1004 
1005     /**
1006      * Get the total tracked balance - total supply * position unit
1007      *
1008      * @param _setToken           Address of the SetToken
1009      * @param _component          Address of the component
1010      * @return                    Notional tracked balance
1011      */
1012     function getDefaultTrackedBalance(ISetToken _setToken, address _component) internal view returns(uint256) {
1013         int256 positionUnit = _setToken.getDefaultPositionRealUnit(_component); 
1014         return _setToken.totalSupply().preciseMul(positionUnit.toUint256());
1015     }
1016 
1017     /**
1018      * Calculates the new default position unit and performs the edit with the new unit
1019      *
1020      * @param _setToken                 Address of the SetToken
1021      * @param _component                Address of the component
1022      * @param _setTotalSupply           Current SetToken supply
1023      * @param _componentPreviousBalance Pre-action component balance
1024      * @return                          Current component balance
1025      * @return                          Previous position unit
1026      * @return                          New position unit
1027      */
1028     function calculateAndEditDefaultPosition(
1029         ISetToken _setToken,
1030         address _component,
1031         uint256 _setTotalSupply,
1032         uint256 _componentPreviousBalance
1033     )
1034         internal
1035         returns(uint256, uint256, uint256)
1036     {
1037         uint256 currentBalance = IERC20(_component).balanceOf(address(_setToken));
1038         uint256 positionUnit = _setToken.getDefaultPositionRealUnit(_component).toUint256();
1039 
1040         uint256 newTokenUnit;
1041         if (currentBalance > 0) {
1042             newTokenUnit = calculateDefaultEditPositionUnit(
1043                 _setTotalSupply,
1044                 _componentPreviousBalance,
1045                 currentBalance,
1046                 positionUnit
1047             );
1048         } else {
1049             newTokenUnit = 0;
1050         }
1051 
1052         editDefaultPosition(_setToken, _component, newTokenUnit);
1053 
1054         return (currentBalance, positionUnit, newTokenUnit);
1055     }
1056 
1057     /**
1058      * Calculate the new position unit given total notional values pre and post executing an action that changes SetToken state
1059      * The intention is to make updates to the units without accidentally picking up airdropped assets as well.
1060      *
1061      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
1062      * @param _preTotalNotional   Total notional amount of component prior to executing action
1063      * @param _postTotalNotional  Total notional amount of component after the executing action
1064      * @param _prePositionUnit    Position unit of SetToken prior to executing action
1065      * @return                    New position unit
1066      */
1067     function calculateDefaultEditPositionUnit(
1068         uint256 _setTokenSupply,
1069         uint256 _preTotalNotional,
1070         uint256 _postTotalNotional,
1071         uint256 _prePositionUnit
1072     )
1073         internal
1074         pure
1075         returns (uint256)
1076     {
1077         // If pre action total notional amount is greater then subtract post action total notional and calculate new position units
1078         uint256 airdroppedAmount = _preTotalNotional.sub(_prePositionUnit.preciseMul(_setTokenSupply));
1079         return _postTotalNotional.sub(airdroppedAmount).preciseDiv(_setTokenSupply);
1080     }
1081 }
1082 
1083 // Dependency file: contracts/protocol/lib/ModuleBase.sol
1084 
1085 /*
1086     Copyright 2020 Set Labs Inc.
1087 
1088     Licensed under the Apache License, Version 2.0 (the "License");
1089     you may not use this file except in compliance with the License.
1090     You may obtain a copy of the License at
1091 
1092     http://www.apache.org/licenses/LICENSE-2.0
1093 
1094     Unless required by applicable law or agreed to in writing, software
1095     distributed under the License is distributed on an "AS IS" BASIS,
1096     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1097     See the License for the specific language governing permissions and
1098     limitations under the License.
1099 
1100 
1101 */
1102 
1103 // pragma solidity 0.6.10;
1104 
1105 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1106 
1107 // import { ExplicitERC20 } from "../../lib/ExplicitERC20.sol";
1108 // import { IController } from "../../interfaces/IController.sol";
1109 // import { IModule } from "../../interfaces/IModule.sol";
1110 // import { ISetToken } from "../../interfaces/ISetToken.sol";
1111 // import { Invoke } from "./Invoke.sol";
1112 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
1113 // import { ResourceIdentifier } from "./ResourceIdentifier.sol";
1114 
1115 /**
1116  * @title ModuleBase
1117  * @author Set Protocol
1118  *
1119  * Abstract class that houses common Module-related state and functions.
1120  */
1121 abstract contract ModuleBase is IModule {
1122     using PreciseUnitMath for uint256;
1123     using Invoke for ISetToken;
1124     using ResourceIdentifier for IController;
1125 
1126     /* ============ State Variables ============ */
1127 
1128     // Address of the controller
1129     IController public controller;
1130 
1131     /* ============ Modifiers ============ */
1132 
1133     modifier onlyManagerAndValidSet(ISetToken _setToken) { 
1134         require(isSetManager(_setToken, msg.sender), "Must be the SetToken manager");
1135         require(isSetValidAndInitialized(_setToken), "Must be a valid and initialized SetToken");
1136         _;
1137     }
1138 
1139     modifier onlySetManager(ISetToken _setToken, address _caller) {
1140         require(isSetManager(_setToken, _caller), "Must be the SetToken manager");
1141         _;
1142     }
1143 
1144     modifier onlyValidAndInitializedSet(ISetToken _setToken) {
1145         require(isSetValidAndInitialized(_setToken), "Must be a valid and initialized SetToken");
1146         _;
1147     }
1148 
1149     /**
1150      * Throws if the sender is not a SetToken's module or module not enabled
1151      */
1152     modifier onlyModule(ISetToken _setToken) {
1153         require(
1154             _setToken.moduleStates(msg.sender) == ISetToken.ModuleState.INITIALIZED,
1155             "Only the module can call"
1156         );
1157 
1158         require(
1159             controller.isModule(msg.sender),
1160             "Module must be enabled on controller"
1161         );
1162         _;
1163     }
1164 
1165     /**
1166      * Utilized during module initializations to check that the module is in pending state
1167      * and that the SetToken is valid
1168      */
1169     modifier onlyValidAndPendingSet(ISetToken _setToken) {
1170         require(controller.isSet(address(_setToken)), "Must be controller-enabled SetToken");
1171         require(isSetPendingInitialization(_setToken), "Must be pending initialization");        
1172         _;
1173     }
1174 
1175     /* ============ Constructor ============ */
1176 
1177     /**
1178      * Set state variables and map asset pairs to their oracles
1179      *
1180      * @param _controller             Address of controller contract
1181      */
1182     constructor(IController _controller) public {
1183         controller = _controller;
1184     }
1185 
1186     /* ============ Internal Functions ============ */
1187 
1188     /**
1189      * Transfers tokens from an address (that has set allowance on the module).
1190      *
1191      * @param  _token          The address of the ERC20 token
1192      * @param  _from           The address to transfer from
1193      * @param  _to             The address to transfer to
1194      * @param  _quantity       The number of tokens to transfer
1195      */
1196     function transferFrom(IERC20 _token, address _from, address _to, uint256 _quantity) internal {
1197         ExplicitERC20.transferFrom(_token, _from, _to, _quantity);
1198     }
1199 
1200     /**
1201      * Gets the integration for the module with the passed in name. Validates that the address is not empty
1202      */
1203     function getAndValidateAdapter(string memory _integrationName) internal view returns(address) { 
1204         bytes32 integrationHash = getNameHash(_integrationName);
1205         return getAndValidateAdapterWithHash(integrationHash);
1206     }
1207 
1208     /**
1209      * Gets the integration for the module with the passed in hash. Validates that the address is not empty
1210      */
1211     function getAndValidateAdapterWithHash(bytes32 _integrationHash) internal view returns(address) { 
1212         address adapter = controller.getIntegrationRegistry().getIntegrationAdapterWithHash(
1213             address(this),
1214             _integrationHash
1215         );
1216 
1217         require(adapter != address(0), "Must be valid adapter"); 
1218         return adapter;
1219     }
1220 
1221     /**
1222      * Gets the total fee for this module of the passed in index (fee % * quantity)
1223      */
1224     function getModuleFee(uint256 _feeIndex, uint256 _quantity) internal view returns(uint256) {
1225         uint256 feePercentage = controller.getModuleFee(address(this), _feeIndex);
1226         return _quantity.preciseMul(feePercentage);
1227     }
1228 
1229     /**
1230      * Pays the _feeQuantity from the _setToken denominated in _token to the protocol fee recipient
1231      */
1232     function payProtocolFeeFromSetToken(ISetToken _setToken, address _token, uint256 _feeQuantity) internal {
1233         if (_feeQuantity > 0) {
1234             _setToken.strictInvokeTransfer(_token, controller.feeRecipient(), _feeQuantity); 
1235         }
1236     }
1237 
1238     /**
1239      * Returns true if the module is in process of initialization on the SetToken
1240      */
1241     function isSetPendingInitialization(ISetToken _setToken) internal view returns(bool) {
1242         return _setToken.isPendingModule(address(this));
1243     }
1244 
1245     /**
1246      * Returns true if the address is the SetToken's manager
1247      */
1248     function isSetManager(ISetToken _setToken, address _toCheck) internal view returns(bool) {
1249         return _setToken.manager() == _toCheck;
1250     }
1251 
1252     /**
1253      * Returns true if SetToken must be enabled on the controller 
1254      * and module is registered on the SetToken
1255      */
1256     function isSetValidAndInitialized(ISetToken _setToken) internal view returns(bool) {
1257         return controller.isSet(address(_setToken)) &&
1258             _setToken.isInitializedModule(address(this));
1259     }
1260 
1261     /**
1262      * Hashes the string and returns a bytes32 value
1263      */
1264     function getNameHash(string memory _name) internal pure returns(bytes32) {
1265         return keccak256(bytes(_name));
1266     }
1267 }
1268 
1269 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
1270 
1271 
1272 
1273 // pragma solidity ^0.6.0;
1274 
1275 /**
1276  * @dev Interface of the ERC20 standard as defined in the EIP.
1277  */
1278 interface IERC20 {
1279     /**
1280      * @dev Returns the amount of tokens in existence.
1281      */
1282     function totalSupply() external view returns (uint256);
1283 
1284     /**
1285      * @dev Returns the amount of tokens owned by `account`.
1286      */
1287     function balanceOf(address account) external view returns (uint256);
1288 
1289     /**
1290      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1291      *
1292      * Returns a boolean value indicating whether the operation succeeded.
1293      *
1294      * Emits a {Transfer} event.
1295      */
1296     function transfer(address recipient, uint256 amount) external returns (bool);
1297 
1298     /**
1299      * @dev Returns the remaining number of tokens that `spender` will be
1300      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1301      * zero by default.
1302      *
1303      * This value changes when {approve} or {transferFrom} are called.
1304      */
1305     function allowance(address owner, address spender) external view returns (uint256);
1306 
1307     /**
1308      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1309      *
1310      * Returns a boolean value indicating whether the operation succeeded.
1311      *
1312      * // importANT: Beware that changing an allowance with this method brings the risk
1313      * that someone may use both the old and the new allowance by unfortunate
1314      * transaction ordering. One possible solution to mitigate this race
1315      * condition is to first reduce the spender's allowance to 0 and set the
1316      * desired value afterwards:
1317      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1318      *
1319      * Emits an {Approval} event.
1320      */
1321     function approve(address spender, uint256 amount) external returns (bool);
1322 
1323     /**
1324      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1325      * allowance mechanism. `amount` is then deducted from the caller's
1326      * allowance.
1327      *
1328      * Returns a boolean value indicating whether the operation succeeded.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1333 
1334     /**
1335      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1336      * another (`to`).
1337      *
1338      * Note that `value` may be zero.
1339      */
1340     event Transfer(address indexed from, address indexed to, uint256 value);
1341 
1342     /**
1343      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1344      * a call to {approve}. `value` is the new allowance.
1345      */
1346     event Approval(address indexed owner, address indexed spender, uint256 value);
1347 }
1348 
1349 // Dependency file: contracts/interfaces/external/IWETH.sol
1350 
1351 /*
1352     Copyright 2018 Set Labs Inc.
1353 
1354     Licensed under the Apache License, Version 2.0 (the "License");
1355     you may not use this file except in compliance with the License.
1356     You may obtain a copy of the License at
1357 
1358     http://www.apache.org/licenses/LICENSE-2.0
1359 
1360     Unless required by applicable law or agreed to in writing, software
1361     distributed under the License is distributed on an "AS IS" BASIS,
1362     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1363     See the License for the specific language governing permissions and
1364     limitations under the License.
1365 */
1366 
1367 // pragma solidity 0.6.10;
1368 
1369 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1370 
1371 /**
1372  * @title IWETH
1373  * @author Set Protocol
1374  *
1375  * Interface for Wrapped Ether. This interface allows for interaction for wrapped ether's deposit and withdrawal
1376  * functionality.
1377  */
1378 interface IWETH is IERC20{
1379     function deposit()
1380         external
1381         payable;
1382 
1383     function withdraw(
1384         uint256 wad
1385     )
1386         external;
1387 }
1388 // Dependency file: contracts/interfaces/ISetToken.sol
1389 
1390 /*
1391     Copyright 2020 Set Labs Inc.
1392 
1393     Licensed under the Apache License, Version 2.0 (the "License");
1394     you may not use this file except in compliance with the License.
1395     You may obtain a copy of the License at
1396 
1397     http://www.apache.org/licenses/LICENSE-2.0
1398 
1399     Unless required by applicable law or agreed to in writing, software
1400     distributed under the License is distributed on an "AS IS" BASIS,
1401     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1402     See the License for the specific language governing permissions and
1403     limitations under the License.
1404 
1405 
1406 */
1407 // pragma solidity 0.6.10;
1408 // pragma experimental "ABIEncoderV2";
1409 
1410 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1411 
1412 /**
1413  * @title ISetToken
1414  * @author Set Protocol
1415  *
1416  * Interface for operating with SetTokens.
1417  */
1418 interface ISetToken is IERC20 {
1419 
1420     /* ============ Enums ============ */
1421 
1422     enum ModuleState {
1423         NONE,
1424         PENDING,
1425         INITIALIZED
1426     }
1427 
1428     /* ============ Structs ============ */
1429     /**
1430      * The base definition of a SetToken Position
1431      *
1432      * @param component           Address of token in the Position
1433      * @param module              If not in default state, the address of associated module
1434      * @param unit                Each unit is the # of components per 10^18 of a SetToken
1435      * @param positionState       Position ENUM. Default is 0; External is 1
1436      * @param data                Arbitrary data
1437      */
1438     struct Position {
1439         address component;
1440         address module;
1441         int256 unit;
1442         uint8 positionState;
1443         bytes data;
1444     }
1445 
1446     /**
1447      * A struct that stores a component's cash position details and external positions
1448      * This data structure allows O(1) access to a component's cash position units and 
1449      * virtual units.
1450      *
1451      * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
1452      *                                  updating all units at once via the position multiplier. Virtual units are achieved
1453      *                                  by dividing a "real" value by the "positionMultiplier"
1454      * @param componentIndex            
1455      * @param externalPositionModules   List of external modules attached to each external position. Each module
1456      *                                  maps to an external position
1457      * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
1458      */
1459     struct ComponentPosition {
1460       int256 virtualUnit;
1461       address[] externalPositionModules;
1462       mapping(address => ExternalPosition) externalPositions;
1463     }
1464 
1465     /**
1466      * A struct that stores a component's external position details including virtual unit and any
1467      * auxiliary data.
1468      *
1469      * @param virtualUnit       Virtual value of a component's EXTERNAL position.
1470      * @param data              Arbitrary data
1471      */
1472     struct ExternalPosition {
1473       int256 virtualUnit;
1474       bytes data;
1475     }
1476 
1477 
1478     /* ============ Functions ============ */
1479     
1480     function addComponent(address _component) external;
1481     function removeComponent(address _component) external;
1482     function editDefaultPositionUnit(address _component, int256 _realUnit) external;
1483     function addExternalPositionModule(address _component, address _positionModule) external;
1484     function removeExternalPositionModule(address _component, address _positionModule) external;
1485     function editExternalPositionUnit(address _component, address _positionModule, int256 _realUnit) external;
1486     function editExternalPositionData(address _component, address _positionModule, bytes calldata _data) external;
1487 
1488     function invoke(address _target, uint256 _value, bytes calldata _data) external returns(bytes memory);
1489 
1490     function editPositionMultiplier(int256 _newMultiplier) external;
1491 
1492     function mint(address _account, uint256 _quantity) external;
1493     function burn(address _account, uint256 _quantity) external;
1494 
1495     function lock() external;
1496     function unlock() external;
1497 
1498     function addModule(address _module) external;
1499     function removeModule(address _module) external;
1500     function initializeModule() external;
1501 
1502     function setManager(address _manager) external;
1503 
1504     function manager() external view returns (address);
1505     function moduleStates(address _module) external view returns (ModuleState);
1506     function getModules() external view returns (address[] memory);
1507     
1508     function getDefaultPositionRealUnit(address _component) external view returns(int256);
1509     function getExternalPositionRealUnit(address _component, address _positionModule) external view returns(int256);
1510     function getComponents() external view returns(address[] memory);
1511     function getExternalPositionModules(address _component) external view returns(address[] memory);
1512     function getExternalPositionData(address _component, address _positionModule) external view returns(bytes memory);
1513     function isExternalPositionModule(address _component, address _module) external view returns(bool);
1514     function isComponent(address _component) external view returns(bool);
1515     
1516     function positionMultiplier() external view returns (int256);
1517     function getPositions() external view returns (Position[] memory);
1518     function getTotalComponentRealUnits(address _component) external view returns(int256);
1519 
1520     function isInitializedModule(address _module) external view returns(bool);
1521     function isPendingModule(address _module) external view returns(bool);
1522     function isLocked() external view returns (bool);
1523 }
1524 // Dependency file: contracts/protocol/lib/Invoke.sol
1525 
1526 /*
1527     Copyright 2020 Set Labs Inc.
1528 
1529     Licensed under the Apache License, Version 2.0 (the "License");
1530     you may not use this file except in compliance with the License.
1531     You may obtain a copy of the License at
1532 
1533     http://www.apache.org/licenses/LICENSE-2.0
1534 
1535     Unless required by applicable law or agreed to in writing, software
1536     distributed under the License is distributed on an "AS IS" BASIS,
1537     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1538     See the License for the specific language governing permissions and
1539     limitations under the License.
1540 
1541 
1542 */
1543 
1544 // pragma solidity 0.6.10;
1545 
1546 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1547 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1548 
1549 // import { ISetToken } from "../../interfaces/ISetToken.sol";
1550 
1551 
1552 /**
1553  * @title Invoke
1554  * @author Set Protocol
1555  *
1556  * A collection of common utility functions for interacting with the SetToken's invoke function
1557  */
1558 library Invoke {
1559     using SafeMath for uint256;
1560 
1561     /* ============ Internal ============ */
1562 
1563     /**
1564      * Instructs the SetToken to set approvals of the ERC20 token to a spender.
1565      *
1566      * @param _setToken        SetToken instance to invoke
1567      * @param _token           ERC20 token to approve
1568      * @param _spender         The account allowed to spend the SetToken's balance
1569      * @param _quantity        The quantity of allowance to allow
1570      */
1571     function invokeApprove(
1572         ISetToken _setToken,
1573         address _token,
1574         address _spender,
1575         uint256 _quantity
1576     )
1577         internal
1578     {
1579         bytes memory callData = abi.encodeWithSignature("approve(address,uint256)", _spender, _quantity);
1580         _setToken.invoke(_token, 0, callData);
1581     }
1582 
1583     /**
1584      * Instructs the SetToken to transfer the ERC20 token to a recipient.
1585      *
1586      * @param _setToken        SetToken instance to invoke
1587      * @param _token           ERC20 token to transfer
1588      * @param _to              The recipient account
1589      * @param _quantity        The quantity to transfer
1590      */
1591     function invokeTransfer(
1592         ISetToken _setToken,
1593         address _token,
1594         address _to,
1595         uint256 _quantity
1596     )
1597         internal
1598     {
1599         if (_quantity > 0) {
1600             bytes memory callData = abi.encodeWithSignature("transfer(address,uint256)", _to, _quantity);
1601             _setToken.invoke(_token, 0, callData);
1602         }
1603     }
1604 
1605     /**
1606      * Instructs the SetToken to transfer the ERC20 token to a recipient.
1607      * The new SetToken balance must equal the existing balance less the quantity transferred
1608      *
1609      * @param _setToken        SetToken instance to invoke
1610      * @param _token           ERC20 token to transfer
1611      * @param _to              The recipient account
1612      * @param _quantity        The quantity to transfer
1613      */
1614     function strictInvokeTransfer(
1615         ISetToken _setToken,
1616         address _token,
1617         address _to,
1618         uint256 _quantity
1619     )
1620         internal
1621     {
1622         if (_quantity > 0) {
1623             // Retrieve current balance of token for the SetToken
1624             uint256 existingBalance = IERC20(_token).balanceOf(address(_setToken));
1625 
1626             Invoke.invokeTransfer(_setToken, _token, _to, _quantity);
1627 
1628             // Get new balance of transferred token for SetToken
1629             uint256 newBalance = IERC20(_token).balanceOf(address(_setToken));
1630 
1631             // Verify only the transfer quantity is subtracted
1632             require(
1633                 newBalance == existingBalance.sub(_quantity),
1634                 "Invalid post transfer balance"
1635             );
1636         }
1637     }
1638 
1639     /**
1640      * Instructs the SetToken to unwrap the passed quantity of WETH
1641      *
1642      * @param _setToken        SetToken instance to invoke
1643      * @param _weth            WETH address
1644      * @param _quantity        The quantity to unwrap
1645      */
1646     function invokeUnwrapWETH(ISetToken _setToken, address _weth, uint256 _quantity) internal {
1647         bytes memory callData = abi.encodeWithSignature("withdraw(uint256)", _quantity);
1648         _setToken.invoke(_weth, 0, callData);
1649     }
1650 
1651     /**
1652      * Instructs the SetToken to wrap the passed quantity of ETH
1653      *
1654      * @param _setToken        SetToken instance to invoke
1655      * @param _weth            WETH address
1656      * @param _quantity        The quantity to unwrap
1657      */
1658     function invokeWrapWETH(ISetToken _setToken, address _weth, uint256 _quantity) internal {
1659         bytes memory callData = abi.encodeWithSignature("deposit()");
1660         _setToken.invoke(_weth, _quantity, callData);
1661     }
1662 }
1663 // Dependency file: contracts/interfaces/IController.sol
1664 
1665 /*
1666     Copyright 2020 Set Labs Inc.
1667 
1668     Licensed under the Apache License, Version 2.0 (the "License");
1669     you may not use this file except in compliance with the License.
1670     You may obtain a copy of the License at
1671 
1672     http://www.apache.org/licenses/LICENSE-2.0
1673 
1674     Unless required by applicable law or agreed to in writing, software
1675     distributed under the License is distributed on an "AS IS" BASIS,
1676     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1677     See the License for the specific language governing permissions and
1678     limitations under the License.
1679 
1680 
1681 */
1682 // pragma solidity 0.6.10;
1683 
1684 interface IController {
1685     function addSet(address _setToken) external;
1686     function feeRecipient() external view returns(address);
1687     function getModuleFee(address _module, uint256 _feeType) external view returns(uint256);
1688     function isModule(address _module) external view returns(bool);
1689     function isSet(address _setToken) external view returns(bool);
1690     function isSystemContract(address _contractAddress) external view returns (bool);
1691     function resourceId(uint256 _id) external view returns(address);
1692 }
1693 // Dependency file: contracts/lib/AddressArrayUtils.sol
1694 
1695 /*
1696     Copyright 2020 Set Labs Inc.
1697 
1698     Licensed under the Apache License, Version 2.0 (the "License");
1699     you may not use this file except in compliance with the License.
1700     You may obtain a copy of the License at
1701 
1702     http://www.apache.org/licenses/LICENSE-2.0
1703 
1704     Unless required by applicable law or agreed to in writing, software
1705     distributed under the License is distributed on an "AS IS" BASIS,
1706     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1707     See the License for the specific language governing permissions and
1708     limitations under the License.
1709 
1710 
1711 */
1712 
1713 // pragma solidity 0.6.10;
1714 
1715 /**
1716  * @title AddressArrayUtils
1717  * @author Set Protocol
1718  *
1719  * Utility functions to handle Address Arrays
1720  */
1721 library AddressArrayUtils {
1722 
1723     /**
1724      * Finds the index of the first occurrence of the given element.
1725      * @param A The input array to search
1726      * @param a The value to find
1727      * @return Returns (index and isIn) for the first occurrence starting from index 0
1728      */
1729     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
1730         uint256 length = A.length;
1731         for (uint256 i = 0; i < length; i++) {
1732             if (A[i] == a) {
1733                 return (i, true);
1734             }
1735         }
1736         return (uint256(-1), false);
1737     }
1738 
1739     /**
1740     * Returns true if the value is present in the list. Uses indexOf internally.
1741     * @param A The input array to search
1742     * @param a The value to find
1743     * @return Returns isIn for the first occurrence starting from index 0
1744     */
1745     function contains(address[] memory A, address a) internal pure returns (bool) {
1746         (, bool isIn) = indexOf(A, a);
1747         return isIn;
1748     }
1749 
1750     /**
1751     * Returns true if there are 2 elements that are the same in an array
1752     * @param A The input array to search
1753     * @return Returns boolean for the first occurrence of a duplicate
1754     */
1755     function hasDuplicate(address[] memory A) internal pure returns(bool) {
1756         require(A.length > 0, "A is empty");
1757 
1758         for (uint256 i = 0; i < A.length - 1; i++) {
1759             address current = A[i];
1760             for (uint256 j = i + 1; j < A.length; j++) {
1761                 if (current == A[j]) {
1762                     return true;
1763                 }
1764             }
1765         }
1766         return false;
1767     }
1768 
1769     /**
1770      * @param A The input array to search
1771      * @param a The address to remove     
1772      * @return Returns the array with the object removed.
1773      */
1774     function remove(address[] memory A, address a)
1775         internal
1776         pure
1777         returns (address[] memory)
1778     {
1779         (uint256 index, bool isIn) = indexOf(A, a);
1780         if (!isIn) {
1781             revert("Address not in array.");
1782         } else {
1783             (address[] memory _A,) = pop(A, index);
1784             return _A;
1785         }
1786     }
1787 
1788     /**
1789     * Removes specified index from array
1790     * @param A The input array to search
1791     * @param index The index to remove
1792     * @return Returns the new array and the removed entry
1793     */
1794     function pop(address[] memory A, uint256 index)
1795         internal
1796         pure
1797         returns (address[] memory, address)
1798     {
1799         uint256 length = A.length;
1800         require(index < A.length, "Index must be < A length");
1801         address[] memory newAddresses = new address[](length - 1);
1802         for (uint256 i = 0; i < index; i++) {
1803             newAddresses[i] = A[i];
1804         }
1805         for (uint256 j = index + 1; j < length; j++) {
1806             newAddresses[j - 1] = A[j];
1807         }
1808         return (newAddresses, A[index]);
1809     }
1810 
1811     /**
1812      * Returns the combination of the two arrays
1813      * @param A The first array
1814      * @param B The second array
1815      * @return Returns A extended by B
1816      */
1817     function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1818         uint256 aLength = A.length;
1819         uint256 bLength = B.length;
1820         address[] memory newAddresses = new address[](aLength + bLength);
1821         for (uint256 i = 0; i < aLength; i++) {
1822             newAddresses[i] = A[i];
1823         }
1824         for (uint256 j = 0; j < bLength; j++) {
1825             newAddresses[aLength + j] = B[j];
1826         }
1827         return newAddresses;
1828     }
1829 }
1830 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
1831 
1832 
1833 
1834 // pragma solidity ^0.6.0;
1835 
1836 /**
1837  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1838  * checks.
1839  *
1840  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1841  * in bugs, because programmers usually assume that an overflow raises an
1842  * error, which is the standard behavior in high level programming languages.
1843  * `SafeMath` restores this intuition by reverting the transaction when an
1844  * operation overflows.
1845  *
1846  * Using this library instead of the unchecked operations eliminates an entire
1847  * class of bugs, so it's recommended to use it always.
1848  */
1849 library SafeMath {
1850     /**
1851      * @dev Returns the addition of two unsigned integers, reverting on
1852      * overflow.
1853      *
1854      * Counterpart to Solidity's `+` operator.
1855      *
1856      * Requirements:
1857      *
1858      * - Addition cannot overflow.
1859      */
1860     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1861         uint256 c = a + b;
1862         require(c >= a, "SafeMath: addition overflow");
1863 
1864         return c;
1865     }
1866 
1867     /**
1868      * @dev Returns the subtraction of two unsigned integers, reverting on
1869      * overflow (when the result is negative).
1870      *
1871      * Counterpart to Solidity's `-` operator.
1872      *
1873      * Requirements:
1874      *
1875      * - Subtraction cannot overflow.
1876      */
1877     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1878         return sub(a, b, "SafeMath: subtraction overflow");
1879     }
1880 
1881     /**
1882      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1883      * overflow (when the result is negative).
1884      *
1885      * Counterpart to Solidity's `-` operator.
1886      *
1887      * Requirements:
1888      *
1889      * - Subtraction cannot overflow.
1890      */
1891     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1892         require(b <= a, errorMessage);
1893         uint256 c = a - b;
1894 
1895         return c;
1896     }
1897 
1898     /**
1899      * @dev Returns the multiplication of two unsigned integers, reverting on
1900      * overflow.
1901      *
1902      * Counterpart to Solidity's `*` operator.
1903      *
1904      * Requirements:
1905      *
1906      * - Multiplication cannot overflow.
1907      */
1908     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1909         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1910         // benefit is lost if 'b' is also tested.
1911         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1912         if (a == 0) {
1913             return 0;
1914         }
1915 
1916         uint256 c = a * b;
1917         require(c / a == b, "SafeMath: multiplication overflow");
1918 
1919         return c;
1920     }
1921 
1922     /**
1923      * @dev Returns the integer division of two unsigned integers. Reverts on
1924      * division by zero. The result is rounded towards zero.
1925      *
1926      * Counterpart to Solidity's `/` operator. Note: this function uses a
1927      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1928      * uses an invalid opcode to revert (consuming all remaining gas).
1929      *
1930      * Requirements:
1931      *
1932      * - The divisor cannot be zero.
1933      */
1934     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1935         return div(a, b, "SafeMath: division by zero");
1936     }
1937 
1938     /**
1939      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1940      * division by zero. The result is rounded towards zero.
1941      *
1942      * Counterpart to Solidity's `/` operator. Note: this function uses a
1943      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1944      * uses an invalid opcode to revert (consuming all remaining gas).
1945      *
1946      * Requirements:
1947      *
1948      * - The divisor cannot be zero.
1949      */
1950     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1951         require(b > 0, errorMessage);
1952         uint256 c = a / b;
1953         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1954 
1955         return c;
1956     }
1957 
1958     /**
1959      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1960      * Reverts when dividing by zero.
1961      *
1962      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1963      * opcode (which leaves remaining gas untouched) while Solidity uses an
1964      * invalid opcode to revert (consuming all remaining gas).
1965      *
1966      * Requirements:
1967      *
1968      * - The divisor cannot be zero.
1969      */
1970     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1971         return mod(a, b, "SafeMath: modulo by zero");
1972     }
1973 
1974     /**
1975      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1976      * Reverts with custom message when dividing by zero.
1977      *
1978      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1979      * opcode (which leaves remaining gas untouched) while Solidity uses an
1980      * invalid opcode to revert (consuming all remaining gas).
1981      *
1982      * Requirements:
1983      *
1984      * - The divisor cannot be zero.
1985      */
1986     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1987         require(b != 0, errorMessage);
1988         return a % b;
1989     }
1990 }
1991 
1992 // Dependency file: @openzeppelin/contracts/utils/SafeCast.sol
1993 
1994 
1995 
1996 // pragma solidity ^0.6.0;
1997 
1998 
1999 /**
2000  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
2001  * checks.
2002  *
2003  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
2004  * easily result in undesired exploitation or bugs, since developers usually
2005  * assume that overflows raise errors. `SafeCast` restores this intuition by
2006  * reverting the transaction when such an operation overflows.
2007  *
2008  * Using this library instead of the unchecked operations eliminates an entire
2009  * class of bugs, so it's recommended to use it always.
2010  *
2011  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
2012  * all math on `uint256` and `int256` and then downcasting.
2013  */
2014 library SafeCast {
2015 
2016     /**
2017      * @dev Returns the downcasted uint128 from uint256, reverting on
2018      * overflow (when the input is greater than largest uint128).
2019      *
2020      * Counterpart to Solidity's `uint128` operator.
2021      *
2022      * Requirements:
2023      *
2024      * - input must fit into 128 bits
2025      */
2026     function toUint128(uint256 value) internal pure returns (uint128) {
2027         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
2028         return uint128(value);
2029     }
2030 
2031     /**
2032      * @dev Returns the downcasted uint64 from uint256, reverting on
2033      * overflow (when the input is greater than largest uint64).
2034      *
2035      * Counterpart to Solidity's `uint64` operator.
2036      *
2037      * Requirements:
2038      *
2039      * - input must fit into 64 bits
2040      */
2041     function toUint64(uint256 value) internal pure returns (uint64) {
2042         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
2043         return uint64(value);
2044     }
2045 
2046     /**
2047      * @dev Returns the downcasted uint32 from uint256, reverting on
2048      * overflow (when the input is greater than largest uint32).
2049      *
2050      * Counterpart to Solidity's `uint32` operator.
2051      *
2052      * Requirements:
2053      *
2054      * - input must fit into 32 bits
2055      */
2056     function toUint32(uint256 value) internal pure returns (uint32) {
2057         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
2058         return uint32(value);
2059     }
2060 
2061     /**
2062      * @dev Returns the downcasted uint16 from uint256, reverting on
2063      * overflow (when the input is greater than largest uint16).
2064      *
2065      * Counterpart to Solidity's `uint16` operator.
2066      *
2067      * Requirements:
2068      *
2069      * - input must fit into 16 bits
2070      */
2071     function toUint16(uint256 value) internal pure returns (uint16) {
2072         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
2073         return uint16(value);
2074     }
2075 
2076     /**
2077      * @dev Returns the downcasted uint8 from uint256, reverting on
2078      * overflow (when the input is greater than largest uint8).
2079      *
2080      * Counterpart to Solidity's `uint8` operator.
2081      *
2082      * Requirements:
2083      *
2084      * - input must fit into 8 bits.
2085      */
2086     function toUint8(uint256 value) internal pure returns (uint8) {
2087         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
2088         return uint8(value);
2089     }
2090 
2091     /**
2092      * @dev Converts a signed int256 into an unsigned uint256.
2093      *
2094      * Requirements:
2095      *
2096      * - input must be greater than or equal to 0.
2097      */
2098     function toUint256(int256 value) internal pure returns (uint256) {
2099         require(value >= 0, "SafeCast: value must be positive");
2100         return uint256(value);
2101     }
2102 
2103     /**
2104      * @dev Returns the downcasted int128 from int256, reverting on
2105      * overflow (when the input is less than smallest int128 or
2106      * greater than largest int128).
2107      *
2108      * Counterpart to Solidity's `int128` operator.
2109      *
2110      * Requirements:
2111      *
2112      * - input must fit into 128 bits
2113      *
2114      * _Available since v3.1._
2115      */
2116     function toInt128(int256 value) internal pure returns (int128) {
2117         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
2118         return int128(value);
2119     }
2120 
2121     /**
2122      * @dev Returns the downcasted int64 from int256, reverting on
2123      * overflow (when the input is less than smallest int64 or
2124      * greater than largest int64).
2125      *
2126      * Counterpart to Solidity's `int64` operator.
2127      *
2128      * Requirements:
2129      *
2130      * - input must fit into 64 bits
2131      *
2132      * _Available since v3.1._
2133      */
2134     function toInt64(int256 value) internal pure returns (int64) {
2135         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
2136         return int64(value);
2137     }
2138 
2139     /**
2140      * @dev Returns the downcasted int32 from int256, reverting on
2141      * overflow (when the input is less than smallest int32 or
2142      * greater than largest int32).
2143      *
2144      * Counterpart to Solidity's `int32` operator.
2145      *
2146      * Requirements:
2147      *
2148      * - input must fit into 32 bits
2149      *
2150      * _Available since v3.1._
2151      */
2152     function toInt32(int256 value) internal pure returns (int32) {
2153         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
2154         return int32(value);
2155     }
2156 
2157     /**
2158      * @dev Returns the downcasted int16 from int256, reverting on
2159      * overflow (when the input is less than smallest int16 or
2160      * greater than largest int16).
2161      *
2162      * Counterpart to Solidity's `int16` operator.
2163      *
2164      * Requirements:
2165      *
2166      * - input must fit into 16 bits
2167      *
2168      * _Available since v3.1._
2169      */
2170     function toInt16(int256 value) internal pure returns (int16) {
2171         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
2172         return int16(value);
2173     }
2174 
2175     /**
2176      * @dev Returns the downcasted int8 from int256, reverting on
2177      * overflow (when the input is less than smallest int8 or
2178      * greater than largest int8).
2179      *
2180      * Counterpart to Solidity's `int8` operator.
2181      *
2182      * Requirements:
2183      *
2184      * - input must fit into 8 bits.
2185      *
2186      * _Available since v3.1._
2187      */
2188     function toInt8(int256 value) internal pure returns (int8) {
2189         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
2190         return int8(value);
2191     }
2192 
2193     /**
2194      * @dev Converts an unsigned uint256 into a signed int256.
2195      *
2196      * Requirements:
2197      *
2198      * - input must be less than or equal to maxInt256.
2199      */
2200     function toInt256(uint256 value) internal pure returns (int256) {
2201         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
2202         return int256(value);
2203     }
2204 }
2205 
2206 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
2207 
2208 
2209 
2210 // pragma solidity ^0.6.0;
2211 
2212 /**
2213  * @dev Contract module that helps prevent reentrant calls to a function.
2214  *
2215  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2216  * available, which can be applied to functions to make sure there are no nested
2217  * (reentrant) calls to them.
2218  *
2219  * Note that because there is a single `nonReentrant` guard, functions marked as
2220  * `nonReentrant` may not call one another. This can be worked around by making
2221  * those functions `private`, and then adding `external` `nonReentrant` entry
2222  * points to them.
2223  *
2224  * TIP: If you would like to learn more about reentrancy and alternative ways
2225  * to protect against it, check out our blog post
2226  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2227  */
2228 contract ReentrancyGuard {
2229     // Booleans are more expensive than uint256 or any type that takes up a full
2230     // word because each write operation emits an extra SLOAD to first read the
2231     // slot's contents, replace the bits taken up by the boolean, and then write
2232     // back. This is the compiler's defense against contract upgrades and
2233     // pointer aliasing, and it cannot be disabled.
2234 
2235     // The values being non-zero value makes deployment a bit more expensive,
2236     // but in exchange the refund on every call to nonReentrant will be lower in
2237     // amount. Since refunds are capped to a percentage of the total
2238     // transaction's gas, it is best to keep them low in cases like this one, to
2239     // increase the likelihood of the full refund coming into effect.
2240     uint256 private constant _NOT_ENTERED = 1;
2241     uint256 private constant _ENTERED = 2;
2242 
2243     uint256 private _status;
2244 
2245     constructor () internal {
2246         _status = _NOT_ENTERED;
2247     }
2248 
2249     /**
2250      * @dev Prevents a contract from calling itself, directly or indirectly.
2251      * Calling a `nonReentrant` function from another `nonReentrant`
2252      * function is not supported. It is possible to prevent this from happening
2253      * by making the `nonReentrant` function external, and make it call a
2254      * `private` function that does the actual work.
2255      */
2256     modifier nonReentrant() {
2257         // On the first call to nonReentrant, _notEntered will be true
2258         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2259 
2260         // Any calls to nonReentrant after this point will fail
2261         _status = _ENTERED;
2262 
2263         _;
2264 
2265         // By storing the original value once again, a refund is triggered (see
2266         // https://eips.ethereum.org/EIPS/eip-2200)
2267         _status = _NOT_ENTERED;
2268     }
2269 }
2270 
2271 // Dependency file: @openzeppelin/contracts/math/Math.sol
2272 
2273 
2274 
2275 // pragma solidity ^0.6.0;
2276 
2277 /**
2278  * @dev Standard math utilities missing in the Solidity language.
2279  */
2280 library Math {
2281     /**
2282      * @dev Returns the largest of two numbers.
2283      */
2284     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2285         return a >= b ? a : b;
2286     }
2287 
2288     /**
2289      * @dev Returns the smallest of two numbers.
2290      */
2291     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2292         return a < b ? a : b;
2293     }
2294 
2295     /**
2296      * @dev Returns the average of two numbers. The result is rounded towards
2297      * zero.
2298      */
2299     function average(uint256 a, uint256 b) internal pure returns (uint256) {
2300         // (a + b) / 2 can overflow, so we distribute
2301         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
2302     }
2303 }
2304 
2305 /*
2306     Copyright 2020 Set Labs Inc.
2307 
2308     Licensed under the Apache License, Version 2.0 (the "License");
2309     you may not use this file except in compliance with the License.
2310     You may obtain a copy of the License at
2311 
2312     http://www.apache.org/licenses/LICENSE-2.0
2313 
2314     Unless required by applicable law or agreed to in writing, software
2315     distributed under the License is distributed on an "AS IS" BASIS,
2316     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2317     See the License for the specific language governing permissions and
2318     limitations under the License.
2319 
2320 
2321 */
2322 
2323 pragma solidity 0.6.10;
2324 pragma experimental "ABIEncoderV2";
2325 
2326 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
2327 // import { Math } from "@openzeppelin/contracts/math/Math.sol";
2328 // import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
2329 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
2330 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
2331 
2332 // import { AddressArrayUtils } from "../../lib/AddressArrayUtils.sol";
2333 // import { IController } from "../../interfaces/IController.sol";
2334 // import { Invoke } from "../lib/Invoke.sol";
2335 // import { ISetToken } from "../../interfaces/ISetToken.sol";
2336 // import { IWETH } from "../../interfaces/external/IWETH.sol";
2337 // import { ModuleBase } from "../lib/ModuleBase.sol";
2338 // import { Position } from "../lib/Position.sol";
2339 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
2340 // import { Uint256ArrayUtils } from "../../lib/Uint256ArrayUtils.sol";
2341 
2342 
2343 /**
2344  * @title SingleIndexModule
2345  * @author Set Protocol
2346  *
2347  * Smart contract that facilitates rebalances for indices. Manager can set target unit amounts, max trade sizes, the
2348  * exchange to trade on, and the cool down period between trades (on a per asset basis). As currently constructed
2349  * the module only works for one Set at a time.
2350  *
2351  * SECURITY ASSUMPTION:
2352  *  - Works with following modules: StreamingFeeModule, BasicIssuanceModule (any other module additions to Sets using
2353       this module need to be examined separately)
2354  */
2355 contract SingleIndexModule is ModuleBase, ReentrancyGuard {
2356     using SafeCast for int256;
2357     using SafeCast for uint256;
2358     using SafeMath for uint256;
2359     using Position for uint256;
2360     using Math for uint256;
2361     using Position for ISetToken;
2362     using Invoke for ISetToken;
2363     using AddressArrayUtils for address[];
2364     using Uint256ArrayUtils for uint256[];
2365 
2366     /* ============ Structs ============ */
2367 
2368     struct AssetTradeInfo {
2369         uint256 targetUnit;              // Target unit for the asset during current rebalance period
2370         uint256 maxSize;                 // Max trade size in precise units
2371         uint256 coolOffPeriod;           // Required time between trades for the asset
2372         uint256 lastTradeTimestamp;      // Timestamp of last trade
2373         uint256 exchange;                // Integer representing ID of exchange to use
2374     }
2375 
2376     /* ============ Enums ============ */
2377 
2378     // Enum of exchange Ids
2379     enum ExchangeId {
2380         None,
2381         Uniswap,
2382         Sushiswap,
2383         Balancer,
2384         Last
2385     }
2386 
2387     /* ============ Events ============ */
2388 
2389     event TargetUnitsUpdated(address indexed _component, uint256 _newUnit, uint256 _positionMultiplier);
2390     event TradeMaximumUpdated(address indexed _component, uint256 _newMaximum);
2391     event AssetExchangeUpdated(address indexed _component, uint256 _newExchange);
2392     event CoolOffPeriodUpdated(address indexed _component, uint256 _newCoolOffPeriod);
2393     event TraderStatusUpdated(address indexed _trader, bool _status);
2394     event AnyoneTradeUpdated(bool indexed _status);
2395     event TradeExecuted(
2396         address indexed _executor,
2397         address indexed _sellComponent,
2398         address indexed _buyComponent,
2399         uint256 _amountSold,
2400         uint256 _amountBought
2401     );
2402 
2403     /* ============ Constants ============ */
2404 
2405     uint256 private constant TARGET_RAISE_DIVISOR = 1.0025e18;       // Raise targets 25 bps
2406     uint256 private constant BALANCER_POOL_LIMIT = 3;                // Amount of pools examined when fetching quote
2407 
2408     string private constant UNISWAP_OUT = "swapTokensForExactTokens(uint256,uint256,address[],address,uint256)";
2409     string private constant UNISWAP_IN = "swapExactTokensForTokens(uint256,uint256,address[],address,uint256)";
2410     string private constant BALANCER_OUT = "smartSwapExactOut(address,address,uint256,uint256,uint256)";
2411     string private constant BALANCER_IN = "smartSwapExactIn(address,address,uint256,uint256,uint256)";
2412 
2413     /* ============ State Variables ============ */
2414 
2415     mapping(address => AssetTradeInfo) public assetInfo;    // Mapping of component to component restrictions
2416     address[] public rebalanceComponents;                   // Components having units updated during current rebalance
2417     uint256 public positionMultiplier;                      // Position multiplier when current rebalance units were devised
2418     mapping(address => bool) public tradeAllowList;         // Mapping of addresses allowed to call trade()
2419     bool public anyoneTrade;                                // Toggles on or off skipping the tradeAllowList
2420     ISetToken public index;                                 // Index being managed with contract
2421     IWETH public weth;                                      // Weth contract address
2422     address public uniswapRouter;                           // Uniswap router address
2423     address public sushiswapRouter;                         // Sushiswap router address
2424     address public balancerProxy;                           // Balancer exchange proxy address
2425 
2426     /* ============ Modifiers ============ */
2427 
2428     modifier onlyAllowedTrader(address _caller) {
2429         require(_isAllowedTrader(_caller), "Address not permitted to trade");
2430         _;
2431     }
2432 
2433     modifier onlyEOA() {
2434         require(msg.sender == tx.origin, "Caller must be EOA Address");
2435         _;
2436     }
2437 
2438     /* ============ Constructor ============ */
2439 
2440     constructor(
2441         IController _controller,
2442         IWETH _weth,
2443         address _uniswapRouter,
2444         address _sushiswapRouter,
2445         address _balancerProxy
2446     )
2447         public
2448         ModuleBase(_controller)
2449     {
2450         weth = _weth;
2451         uniswapRouter = _uniswapRouter;
2452         sushiswapRouter = _sushiswapRouter;
2453         balancerProxy = _balancerProxy;
2454     }
2455 
2456     /**
2457      * MANAGER ONLY: Set new target units, zeroing out any units for components being removed from index. Log position multiplier to
2458      * adjust target units in case fees are accrued. Validate that weth is not a part of the new allocation and that all components
2459      * in current allocation are in _components array.
2460      *
2461      * @param _newComponents                    Array of new components to add to allocation
2462      * @param _newComponentsTargetUnits         Array of target units at end of rebalance for new components, maps to same index of component
2463      * @param _oldComponentsTargetUnits         Array of target units at end of rebalance for old component, maps to same index of component,
2464      *                                               if component being removed set to 0.
2465      * @param _positionMultiplier               Position multiplier when target units were calculated, needed in order to adjust target units
2466      *                                               if fees accrued
2467      */
2468     function startRebalance(
2469         address[] calldata _newComponents,
2470         uint256[] calldata _newComponentsTargetUnits,
2471         uint256[] calldata _oldComponentsTargetUnits,
2472         uint256 _positionMultiplier
2473     )
2474         external
2475         onlyManagerAndValidSet(index)
2476     {   
2477         // Don't use validate arrays because empty arrays are valid
2478         require(_newComponents.length == _newComponentsTargetUnits.length, "Array length mismatch");
2479 
2480         address[] memory currentComponents = index.getComponents();
2481         require(currentComponents.length == _oldComponentsTargetUnits.length, "New allocation must have target for all old components");
2482 
2483         address[] memory aggregateComponents = currentComponents.extend(_newComponents);
2484         uint256[] memory aggregateTargetUnits = _oldComponentsTargetUnits.extend(_newComponentsTargetUnits);
2485 
2486         require(!aggregateComponents.hasDuplicate(), "Cannot duplicate components");
2487 
2488         for (uint256 i = 0; i < aggregateComponents.length; i++) {
2489             address component = aggregateComponents[i];
2490             uint256 targetUnit = aggregateTargetUnits[i];
2491 
2492             require(address(component) != address(weth), "WETH cannot be an index component");
2493             assetInfo[component].targetUnit = targetUnit;
2494 
2495             emit TargetUnitsUpdated(component, targetUnit, _positionMultiplier);
2496         }
2497 
2498         rebalanceComponents = aggregateComponents;
2499         positionMultiplier = _positionMultiplier;
2500     }
2501 
2502     /**
2503      * ACCESS LIMITED: Only approved addresses can call if anyoneTrade is false. Determines trade size
2504      * and direction and swaps into or out of WETH on exchange specified by manager.
2505      *
2506      * @param _component            Component to trade
2507      */
2508     function trade(address _component) external nonReentrant onlyAllowedTrader(msg.sender) onlyEOA() virtual {
2509 
2510         _validateTradeParameters(_component);
2511 
2512         (
2513             bool isBuy,
2514             uint256 tradeAmount
2515         ) = _calculateTradeSizeAndDirection(_component);
2516 
2517         if (isBuy) {
2518             _buyUnderweight(_component, tradeAmount);
2519         } else {
2520             _sellOverweight(_component, tradeAmount);
2521         }
2522 
2523         assetInfo[_component].lastTradeTimestamp = block.timestamp;
2524     }
2525 
2526     /**
2527      * ACCESS LIMITED: Only approved addresses can call if anyoneTrade is false. Only callable when 1) there are no
2528      * more components to be sold and, 2) entire remaining WETH amount can be traded such that resulting inflows won't
2529      * exceed components maxTradeSize nor overshoot the target unit. To be used near the end of rebalances when a
2530      * component's calculated trade size is greater in value than remaining WETH.
2531      *
2532      * @param _component            Component to trade
2533      */
2534     function tradeRemainingWETH(address _component) external nonReentrant onlyAllowedTrader(msg.sender) onlyEOA() virtual {
2535         require(_noTokensToSell(), "Must sell all sellable tokens before can be called");
2536 
2537         _validateTradeParameters(_component);
2538 
2539         (, uint256 tradeLimit) = _calculateTradeSizeAndDirection(_component);
2540 
2541         uint256 preTradeComponentAmount = IERC20(_component).balanceOf(address(index));
2542         uint256 preTradeWethAmount = weth.balanceOf(address(index));
2543 
2544         _executeTrade(address(weth), _component, true, preTradeWethAmount, assetInfo[_component].exchange);
2545 
2546         (,
2547             uint256 componentTradeSize
2548         ) = _updatePositionState(address(weth), _component, preTradeWethAmount, preTradeComponentAmount);
2549 
2550         require(componentTradeSize < tradeLimit, "Trade size exceeds trade size limit");
2551 
2552         assetInfo[_component].lastTradeTimestamp = block.timestamp;
2553     }
2554 
2555     /**
2556      * ACCESS LIMITED: For situation where all target units met and remaining WETH, uniformly raise targets by same
2557      * percentage in order to allow further trading. Can be called multiple times if necessary, increase should be
2558      * small in order to reduce tracking error.
2559      */
2560     function raiseAssetTargets() external nonReentrant onlyAllowedTrader(msg.sender) virtual {
2561         require(
2562             _allTargetsMet() && index.getDefaultPositionRealUnit(address(weth)) > 0,
2563             "Targets must be met and ETH remaining in order to raise target"
2564         );
2565 
2566         positionMultiplier = positionMultiplier.preciseDiv(TARGET_RAISE_DIVISOR);
2567     }
2568 
2569     /**
2570      * MANAGER ONLY: Set trade maximums for passed components
2571      *
2572      * @param _components            Array of components
2573      * @param _tradeMaximums         Array of trade maximums mapping to correct component
2574      */
2575     function setTradeMaximums(
2576         address[] calldata _components,
2577         uint256[] calldata _tradeMaximums
2578     )
2579         external
2580         onlyManagerAndValidSet(index)
2581     {
2582         _validateArrays(_components, _tradeMaximums);
2583 
2584         for (uint256 i = 0; i < _components.length; i++) {
2585             assetInfo[_components[i]].maxSize = _tradeMaximums[i];
2586             emit TradeMaximumUpdated(_components[i], _tradeMaximums[i]);
2587         }
2588     }
2589 
2590     /**
2591      * MANAGER ONLY: Set exchange for passed components
2592      *
2593      * @param _components        Array of components
2594      * @param _exchanges         Array of exchanges mapping to correct component, uint256 used to signify exchange
2595      */
2596     function setExchanges(
2597         address[] calldata _components,
2598         uint256[] calldata _exchanges
2599     )
2600         external
2601         onlyManagerAndValidSet(index)
2602     {
2603         _validateArrays(_components, _exchanges);
2604 
2605         for (uint256 i = 0; i < _components.length; i++) {
2606             uint256 exchange = _exchanges[i];
2607             require(exchange < uint256(ExchangeId.Last), "Unrecognized exchange identifier");
2608             assetInfo[_components[i]].exchange = _exchanges[i];
2609 
2610             emit AssetExchangeUpdated(_components[i], exchange);
2611         }
2612     }
2613 
2614     /**
2615      * MANAGER ONLY: Set exchange for passed components
2616      *
2617      * @param _components           Array of components
2618      * @param _coolOffPeriods       Array of cool off periods to correct component
2619      */
2620     function setCoolOffPeriods(
2621         address[] calldata _components,
2622         uint256[] calldata _coolOffPeriods
2623     )
2624         external
2625         onlyManagerAndValidSet(index)
2626     {
2627         _validateArrays(_components, _coolOffPeriods);
2628 
2629         for (uint256 i = 0; i < _components.length; i++) {
2630             assetInfo[_components[i]].coolOffPeriod = _coolOffPeriods[i];
2631             emit CoolOffPeriodUpdated(_components[i], _coolOffPeriods[i]);
2632         }
2633     }
2634 
2635     /**
2636      * MANAGER ONLY: Toggle ability for passed addresses to trade from current state 
2637      *
2638      * @param _traders           Array trader addresses to toggle status
2639      * @param _statuses          Booleans indicating if matching trader can trade
2640      */
2641     function updateTraderStatus(address[] calldata _traders, bool[] calldata _statuses) external onlyManagerAndValidSet(index) {
2642         require(_traders.length == _statuses.length, "Array length mismatch");
2643         require(_traders.length > 0, "Array length must be > 0");
2644         require(!_traders.hasDuplicate(), "Cannot duplicate traders");
2645 
2646         for (uint256 i = 0; i < _traders.length; i++) {
2647             address trader = _traders[i];
2648             bool status = _statuses[i];
2649             tradeAllowList[trader] = status;
2650             emit TraderStatusUpdated(trader, status);
2651         }
2652     }
2653 
2654     /**
2655      * MANAGER ONLY: Toggle whether anyone can trade, bypassing the traderAllowList
2656      *
2657      * @param _status           Boolean indicating if anyone can trade
2658      */
2659     function updateAnyoneTrade(bool _status) external onlyManagerAndValidSet(index) {
2660         anyoneTrade = _status;
2661         emit AnyoneTradeUpdated(_status);
2662     }
2663 
2664     /**
2665      * MANAGER ONLY: Set target units to current units and last trade to zero. Initialize module.
2666      *
2667      * @param _index            Address of index being used for this Set
2668      */
2669     function initialize(ISetToken _index)
2670         external
2671         onlySetManager(_index, msg.sender)
2672         onlyValidAndPendingSet(_index)
2673     {
2674         require(address(index) == address(0), "Module already in use");
2675 
2676         ISetToken.Position[] memory positions = _index.getPositions();
2677 
2678         for (uint256 i = 0; i < positions.length; i++) {
2679             ISetToken.Position memory position = positions[i];
2680             assetInfo[position.component].targetUnit = position.unit.toUint256();
2681             assetInfo[position.component].lastTradeTimestamp = 0;
2682         }
2683 
2684         index = _index;
2685         _index.initializeModule();
2686     }
2687 
2688     function removeModule() external override {}
2689 
2690     /* ============ Getter Functions ============ */
2691 
2692     /**
2693      * Get target units for passed components, normalized to current positionMultiplier.
2694      *
2695      * @param _components           Array of components to get target units for
2696      * @return                      Array of targetUnits mapping to passed components
2697      */
2698     function getTargetUnits(address[] calldata _components) external view returns(uint256[] memory) {
2699         uint256 currentPositionMultiplier = index.positionMultiplier().toUint256();
2700         
2701         uint256[] memory targetUnits = new uint256[](_components.length);
2702         for (uint256 i = 0; i < _components.length; i++) {
2703             targetUnits[i] = _normalizeTargetUnit(_components[i], currentPositionMultiplier);
2704         }
2705 
2706         return targetUnits;
2707     }
2708 
2709     function getRebalanceComponents() external view returns(address[] memory) {
2710         return rebalanceComponents;
2711     }
2712 
2713     /* ============ Internal Functions ============ */
2714 
2715     /**
2716      * Validate that enough time has elapsed since component's last trade and component isn't WETH.
2717      */
2718     function _validateTradeParameters(address _component) internal view virtual {
2719         require(rebalanceComponents.contains(_component), "Passed component not included in rebalance");
2720 
2721         AssetTradeInfo memory componentInfo = assetInfo[_component];
2722         require(componentInfo.exchange != uint256(ExchangeId.None), "Exchange must be specified");
2723         require(
2724             componentInfo.lastTradeTimestamp.add(componentInfo.coolOffPeriod) <= block.timestamp,
2725             "Cool off period has not elapsed."
2726         );
2727     }
2728 
2729     /**
2730      * Calculate trade size and whether trade is buy. Trade size is the minimum of the max size and components left to trade.
2731      * Reverts if target quantity is already met. Target unit is adjusted based on ratio of position multiplier when target was defined
2732      * and the current positionMultiplier.
2733      */
2734     function _calculateTradeSizeAndDirection(address _component) internal view returns (bool isBuy, uint256) {
2735         uint256 totalSupply = index.totalSupply();
2736 
2737         uint256 componentMaxSize = assetInfo[_component].maxSize;
2738         uint256 currentPositionMultiplier = index.positionMultiplier().toUint256();
2739 
2740         uint256 currentUnit = index.getDefaultPositionRealUnit(_component).toUint256();
2741         uint256 targetUnit = _normalizeTargetUnit(_component, currentPositionMultiplier);
2742 
2743         require(currentUnit != targetUnit, "Target already met");
2744 
2745         uint256 currentNotional = totalSupply.getDefaultTotalNotional(currentUnit);
2746         uint256 targetNotional = totalSupply.preciseMulCeil(targetUnit);
2747 
2748         return targetNotional > currentNotional ? (true, componentMaxSize.min(targetNotional.sub(currentNotional))) :
2749             (false, componentMaxSize.min(currentNotional.sub(targetNotional)));
2750     }
2751 
2752     /**
2753      * Buy an underweight asset by selling an unfixed amount of WETH for a fixed amount of the component.
2754      */
2755     function _buyUnderweight(address _component, uint256 _amount) internal {
2756         uint256 preTradeBuyComponentAmount = IERC20(_component).balanceOf(address(index));
2757         uint256 preTradeSellComponentAmount = weth.balanceOf(address(index));
2758 
2759         _executeTrade(address(weth), _component, false, _amount, assetInfo[_component].exchange);
2760 
2761         _updatePositionState(address(weth), _component, preTradeSellComponentAmount, preTradeBuyComponentAmount);
2762     }
2763 
2764     /**
2765      * Sell an overweight asset by selling a fixed amount of component for an unfixed amount of WETH.
2766      */
2767     function _sellOverweight(address _component, uint256 _amount) internal {
2768         uint256 preTradeBuyComponentAmount = weth.balanceOf(address(index));
2769         uint256 preTradeSellComponentAmount = IERC20(_component).balanceOf(address(index));
2770 
2771         _executeTrade(_component, address(weth), true, _amount, assetInfo[_component].exchange);
2772 
2773         _updatePositionState(_component, address(weth), preTradeSellComponentAmount, preTradeBuyComponentAmount);
2774     }
2775 
2776     /**
2777      * Determine parameters for trade and invoke trade on index using correct exchange.
2778      */
2779     function _executeTrade(
2780         address _sellComponent,
2781         address _buyComponent,
2782         bool _fixIn,
2783         uint256 _amount,
2784         uint256 _exchange
2785     )
2786         internal
2787         virtual
2788     {
2789         uint256 wethBalance = weth.balanceOf(address(index));
2790         
2791         (
2792             address exchangeAddress,
2793             bytes memory tradeCallData
2794         ) = _exchange == uint256(ExchangeId.Balancer) ? _getBalancerTradeData(_sellComponent, _buyComponent, _fixIn, _amount, wethBalance) :
2795             _getUniswapLikeTradeData(_sellComponent, _buyComponent, _fixIn, _amount, _exchange);
2796 
2797         uint256 approveAmount = _sellComponent == address(weth) ? wethBalance : _amount;
2798         index.invokeApprove(_sellComponent, exchangeAddress, approveAmount);
2799         index.invoke(exchangeAddress, 0, tradeCallData);
2800     }
2801 
2802     /**
2803      * Update position units on index. Emit event.
2804      */
2805     function _updatePositionState(
2806         address _sellComponent,
2807         address _buyComponent,
2808         uint256 _preTradeSellComponentAmount,
2809         uint256 _preTradeBuyComponentAmount
2810     )
2811         internal
2812         returns (uint256 sellAmount, uint256 buyAmount)
2813     {
2814         uint256 totalSupply = index.totalSupply();
2815 
2816         (uint256 postTradeSellComponentAmount,,) = index.calculateAndEditDefaultPosition(
2817             _sellComponent,
2818             totalSupply,
2819             _preTradeSellComponentAmount
2820         );
2821         (uint256 postTradeBuyComponentAmount,,) = index.calculateAndEditDefaultPosition(
2822             _buyComponent,
2823             totalSupply,
2824             _preTradeBuyComponentAmount
2825         );
2826 
2827         sellAmount = _preTradeSellComponentAmount.sub(postTradeSellComponentAmount);
2828         buyAmount = postTradeBuyComponentAmount.sub(_preTradeBuyComponentAmount);
2829 
2830         emit TradeExecuted(
2831             msg.sender,
2832             _sellComponent,
2833             _buyComponent,
2834             sellAmount,
2835             buyAmount
2836         );
2837     }
2838 
2839     /**
2840      * Create Balancer trade call data
2841      */
2842     function _getBalancerTradeData(
2843         address _sellComponent,
2844         address _buyComponent,
2845         bool _fixIn,
2846         uint256 _amount,
2847         uint256 _maxOut
2848     )
2849         internal
2850         view
2851         returns(address, bytes memory)
2852     {
2853         address exchangeAddress = balancerProxy;
2854         (
2855             string memory functionSignature,
2856             uint256 limit
2857         ) = _fixIn ? (BALANCER_IN, 1) : (BALANCER_OUT, _maxOut);
2858 
2859         bytes memory tradeCallData = abi.encodeWithSignature(
2860             functionSignature,
2861             _sellComponent,
2862             _buyComponent,
2863             _amount,
2864             limit,
2865             BALANCER_POOL_LIMIT
2866         );
2867 
2868         return (exchangeAddress, tradeCallData);       
2869     }
2870 
2871     /**
2872      * Determine whether exchange to call is Uniswap or Sushiswap and generate necessary call data.
2873      */
2874     function _getUniswapLikeTradeData(
2875         address _sellComponent,
2876         address _buyComponent,
2877         bool _fixIn,
2878         uint256 _amount,
2879         uint256 _exchange
2880     )
2881         internal
2882         view
2883         returns(address, bytes memory)
2884     {
2885         address exchangeAddress = _exchange == uint256(ExchangeId.Uniswap) ? uniswapRouter : sushiswapRouter;
2886         
2887         string memory functionSignature;
2888         address[] memory path = new address[](2);
2889         uint256 limit;
2890         if (_fixIn) {
2891             functionSignature = UNISWAP_IN;
2892             limit = 1;
2893         } else {
2894             functionSignature = UNISWAP_OUT;
2895             limit = PreciseUnitMath.maxUint256();
2896         }
2897         path[0] = _sellComponent;
2898         path[1] = _buyComponent;
2899         
2900         bytes memory tradeCallData = abi.encodeWithSignature(
2901             functionSignature,
2902             _amount,
2903             limit,
2904             path,
2905             address(index),
2906             now.add(180)
2907         );
2908 
2909         return (exchangeAddress, tradeCallData);
2910     }
2911 
2912     /**
2913      * Check if there are any more tokens to sell.
2914      */
2915     function _noTokensToSell() internal view returns (bool) {
2916         uint256 currentPositionMultiplier = index.positionMultiplier().toUint256();
2917         for (uint256 i = 0; i < rebalanceComponents.length; i++) {
2918             address component = rebalanceComponents[i];
2919             bool canSell = _normalizeTargetUnit(component, currentPositionMultiplier) < index.getDefaultPositionRealUnit(
2920                 component
2921             ).toUint256();
2922             if (canSell) { return false; }
2923         }
2924         return true;
2925     }
2926 
2927     /**
2928      * Check if all targets are met
2929      */
2930     function _allTargetsMet() internal view returns (bool) {
2931         uint256 currentPositionMultiplier = index.positionMultiplier().toUint256();
2932         for (uint256 i = 0; i < rebalanceComponents.length; i++) {
2933             address component = rebalanceComponents[i];
2934             bool targetUnmet = _normalizeTargetUnit(component, currentPositionMultiplier) != index.getDefaultPositionRealUnit(
2935                 component
2936             ).toUint256();
2937             if (targetUnmet) { return false; }
2938         }
2939         return true;
2940     }
2941 
2942     /**
2943      * Normalize target unit to current position multiplier in case fees have been accrued.
2944      */
2945     function _normalizeTargetUnit(address _component, uint256 _currentPositionMultiplier) internal view returns(uint256) {
2946         return assetInfo[_component].targetUnit.mul(_currentPositionMultiplier).div(positionMultiplier);
2947     }
2948 
2949     /**
2950      * Determine if passed address is allowed to call trade. If anyoneTrade set to true anyone can call otherwise needs to be approved.
2951      */
2952     function _isAllowedTrader(address _caller) internal view virtual returns (bool) {
2953         return anyoneTrade || tradeAllowList[_caller];
2954     }
2955 
2956     /**
2957      * Validate arrays are of equal length and not empty.
2958      */
2959     function _validateArrays(address[] calldata _components, uint256[] calldata _data) internal pure {
2960         require(_components.length == _data.length, "Array length mismatch");
2961         require(_components.length > 0, "Array length must be > 0");
2962         require(!_components.hasDuplicate(), "Cannot duplicate components");
2963     }
2964 }