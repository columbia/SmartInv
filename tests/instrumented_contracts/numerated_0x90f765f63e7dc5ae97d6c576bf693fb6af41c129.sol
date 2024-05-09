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
205 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
206 
207 
208 
209 // pragma solidity ^0.6.0;
210 
211 // import "./IERC20.sol";
212 // import "../../math/SafeMath.sol";
213 // import "../../utils/Address.sol";
214 
215 /**
216  * @title SafeERC20
217  * @dev Wrappers around ERC20 operations that throw on failure (when the token
218  * contract returns false). Tokens that return no value (and instead revert or
219  * throw on failure) are also supported, non-reverting calls are assumed to be
220  * successful.
221  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
222  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
223  */
224 library SafeERC20 {
225     using SafeMath for uint256;
226     using Address for address;
227 
228     function safeTransfer(IERC20 token, address to, uint256 value) internal {
229         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
230     }
231 
232     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
233         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
234     }
235 
236     /**
237      * @dev Deprecated. This function has issues similar to the ones found in
238      * {IERC20-approve}, and its usage is discouraged.
239      *
240      * Whenever possible, use {safeIncreaseAllowance} and
241      * {safeDecreaseAllowance} instead.
242      */
243     function safeApprove(IERC20 token, address spender, uint256 value) internal {
244         // safeApprove should only be called when setting an initial allowance,
245         // or when resetting it to zero. To increase and decrease it, use
246         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
247         // solhint-disable-next-line max-line-length
248         require((value == 0) || (token.allowance(address(this), spender) == 0),
249             "SafeERC20: approve from non-zero to non-zero allowance"
250         );
251         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
252     }
253 
254     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
255         uint256 newAllowance = token.allowance(address(this), spender).add(value);
256         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
257     }
258 
259     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
260         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
261         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
262     }
263 
264     /**
265      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
266      * on the return value: the return value is optional (but if data is returned, it must not be false).
267      * @param token The token targeted by the call.
268      * @param data The call data (encoded using abi.encode or one of its variants).
269      */
270     function _callOptionalReturn(IERC20 token, bytes memory data) private {
271         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
272         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
273         // the target address contains contract code and also asserts for success in the low-level call.
274 
275         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
276         if (returndata.length > 0) { // Return data is optional
277             // solhint-disable-next-line max-line-length
278             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
279         }
280     }
281 }
282 
283 // Dependency file: @openzeppelin/contracts/math/SignedSafeMath.sol
284 
285 
286 
287 // pragma solidity ^0.6.0;
288 
289 /**
290  * @title SignedSafeMath
291  * @dev Signed math operations with safety checks that revert on error.
292  */
293 library SignedSafeMath {
294     int256 constant private _INT256_MIN = -2**255;
295 
296         /**
297      * @dev Returns the multiplication of two signed integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `*` operator.
301      *
302      * Requirements:
303      *
304      * - Multiplication cannot overflow.
305      */
306     function mul(int256 a, int256 b) internal pure returns (int256) {
307         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
308         // benefit is lost if 'b' is also tested.
309         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
310         if (a == 0) {
311             return 0;
312         }
313 
314         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
315 
316         int256 c = a * b;
317         require(c / a == b, "SignedSafeMath: multiplication overflow");
318 
319         return c;
320     }
321 
322     /**
323      * @dev Returns the integer division of two signed integers. Reverts on
324      * division by zero. The result is rounded towards zero.
325      *
326      * Counterpart to Solidity's `/` operator. Note: this function uses a
327      * `revert` opcode (which leaves remaining gas untouched) while Solidity
328      * uses an invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function div(int256 a, int256 b) internal pure returns (int256) {
335         require(b != 0, "SignedSafeMath: division by zero");
336         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
337 
338         int256 c = a / b;
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the subtraction of two signed integers, reverting on
345      * overflow.
346      *
347      * Counterpart to Solidity's `-` operator.
348      *
349      * Requirements:
350      *
351      * - Subtraction cannot overflow.
352      */
353     function sub(int256 a, int256 b) internal pure returns (int256) {
354         int256 c = a - b;
355         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
356 
357         return c;
358     }
359 
360     /**
361      * @dev Returns the addition of two signed integers, reverting on
362      * overflow.
363      *
364      * Counterpart to Solidity's `+` operator.
365      *
366      * Requirements:
367      *
368      * - Addition cannot overflow.
369      */
370     function add(int256 a, int256 b) internal pure returns (int256) {
371         int256 c = a + b;
372         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
373 
374         return c;
375     }
376 }
377 
378 // Dependency file: contracts/protocol/lib/ResourceIdentifier.sol
379 
380 /*
381     Copyright 2020 Set Labs Inc.
382 
383     Licensed under the Apache License, Version 2.0 (the "License");
384     you may not use this file except in compliance with the License.
385     You may obtain a copy of the License at
386 
387     http://www.apache.org/licenses/LICENSE-2.0
388 
389     Unless required by applicable law or agreed to in writing, software
390     distributed under the License is distributed on an "AS IS" BASIS,
391     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
392     See the License for the specific language governing permissions and
393     limitations under the License.
394 
395 
396 */
397 
398 // pragma solidity 0.6.10;
399 
400 // import { IController } from "../../interfaces/IController.sol";
401 // import { IIntegrationRegistry } from "../../interfaces/IIntegrationRegistry.sol";
402 // import { IPriceOracle } from "../../interfaces/IPriceOracle.sol";
403 // import { ISetValuer } from "../../interfaces/ISetValuer.sol";
404 
405 /**
406  * @title ResourceIdentifier
407  * @author Set Protocol
408  *
409  * A collection of utility functions to fetch information related to Resource contracts in the system
410  */
411 library ResourceIdentifier {
412 
413     // IntegrationRegistry will always be resource ID 0 in the system
414     uint256 constant internal INTEGRATION_REGISTRY_RESOURCE_ID = 0;
415     // PriceOracle will always be resource ID 1 in the system
416     uint256 constant internal PRICE_ORACLE_RESOURCE_ID = 1;
417     // SetValuer resource will always be resource ID 2 in the system
418     uint256 constant internal SET_VALUER_RESOURCE_ID = 2;
419 
420     /* ============ Internal ============ */
421 
422     /**
423      * Gets the instance of integration registry stored on Controller. Note: IntegrationRegistry is stored as index 0 on
424      * the Controller
425      */
426     function getIntegrationRegistry(IController _controller) internal view returns (IIntegrationRegistry) {
427         return IIntegrationRegistry(_controller.resourceId(INTEGRATION_REGISTRY_RESOURCE_ID));
428     }
429 
430     /**
431      * Gets instance of price oracle on Controller. Note: PriceOracle is stored as index 1 on the Controller
432      */
433     function getPriceOracle(IController _controller) internal view returns (IPriceOracle) {
434         return IPriceOracle(_controller.resourceId(PRICE_ORACLE_RESOURCE_ID));
435     }
436 
437     /**
438      * Gets the instance of Set valuer on Controller. Note: SetValuer is stored as index 2 on the Controller
439      */
440     function getSetValuer(IController _controller) internal view returns (ISetValuer) {
441         return ISetValuer(_controller.resourceId(SET_VALUER_RESOURCE_ID));
442     }
443 }
444 // Dependency file: contracts/interfaces/IModule.sol
445 
446 /*
447     Copyright 2020 Set Labs Inc.
448 
449     Licensed under the Apache License, Version 2.0 (the "License");
450     you may not use this file except in compliance with the License.
451     You may obtain a copy of the License at
452 
453     http://www.apache.org/licenses/LICENSE-2.0
454 
455     Unless required by applicable law or agreed to in writing, software
456     distributed under the License is distributed on an "AS IS" BASIS,
457     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
458     See the License for the specific language governing permissions and
459     limitations under the License.
460 
461 
462 */
463 // pragma solidity 0.6.10;
464 
465 
466 /**
467  * @title IModule
468  * @author Set Protocol
469  *
470  * Interface for interacting with Modules.
471  */
472 interface IModule {
473     /**
474      * Called by a SetToken to notify that this module was removed from the Set token. Any logic can be included
475      * in case checks need to be made or state needs to be cleared.
476      */
477     function removeModule() external;
478 }
479 // Dependency file: contracts/lib/ExplicitERC20.sol
480 
481 /*
482     Copyright 2020 Set Labs Inc.
483 
484     Licensed under the Apache License, Version 2.0 (the "License");
485     you may not use this file except in compliance with the License.
486     You may obtain a copy of the License at
487 
488     http://www.apache.org/licenses/LICENSE-2.0
489 
490     Unless required by applicable law or agreed to in writing, software
491     distributed under the License is distributed on an "AS IS" BASIS,
492     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
493     See the License for the specific language governing permissions and
494     limitations under the License.
495 
496 
497 */
498 
499 // pragma solidity 0.6.10;
500 
501 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
502 // import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
503 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
504 
505 /**
506  * @title ExplicitERC20
507  * @author Set Protocol
508  *
509  * Utility functions for ERC20 transfers that require the explicit amount to be transferred.
510  */
511 library ExplicitERC20 {
512     using SafeMath for uint256;
513 
514     /**
515      * When given allowance, transfers a token from the "_from" to the "_to" of quantity "_quantity".
516      * Ensures that the recipient has received the correct quantity (ie no fees taken on transfer)
517      *
518      * @param _token           ERC20 token to approve
519      * @param _from            The account to transfer tokens from
520      * @param _to              The account to transfer tokens to
521      * @param _quantity        The quantity to transfer
522      */
523     function transferFrom(
524         IERC20 _token,
525         address _from,
526         address _to,
527         uint256 _quantity
528     )
529         internal
530     {
531         // Call specified ERC20 contract to transfer tokens (via proxy).
532         if (_quantity > 0) {
533             uint256 existingBalance = _token.balanceOf(_to);
534 
535             SafeERC20.safeTransferFrom(
536                 _token,
537                 _from,
538                 _to,
539                 _quantity
540             );
541 
542             uint256 newBalance = _token.balanceOf(_to);
543 
544             // Verify transfer quantity is reflected in balance
545             require(
546                 newBalance == existingBalance.add(_quantity),
547                 "Invalid post transfer balance"
548             );
549         }
550     }
551 }
552 
553 // Dependency file: contracts/lib/PreciseUnitMath.sol
554 
555 /*
556     Copyright 2020 Set Labs Inc.
557 
558     Licensed under the Apache License, Version 2.0 (the "License");
559     you may not use this file except in compliance with the License.
560     You may obtain a copy of the License at
561 
562     http://www.apache.org/licenses/LICENSE-2.0
563 
564     Unless required by applicable law or agreed to in writing, software
565     distributed under the License is distributed on an "AS IS" BASIS,
566     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
567     See the License for the specific language governing permissions and
568     limitations under the License.
569 
570 
571 */
572 
573 // pragma solidity 0.6.10;
574 // pragma experimental ABIEncoderV2;
575 
576 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
577 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
578 
579 
580 /**
581  * @title PreciseUnitMath
582  * @author Set Protocol
583  *
584  * Arithmetic for fixed-point numbers with 18 decimals of precision. Some functions taken from
585  * dYdX's BaseMath library.
586  *
587  * CHANGELOG:
588  * - 9/21/20: Added safePower function
589  */
590 library PreciseUnitMath {
591     using SafeMath for uint256;
592     using SignedSafeMath for int256;
593 
594     // The number One in precise units.
595     uint256 constant internal PRECISE_UNIT = 10 ** 18;
596     int256 constant internal PRECISE_UNIT_INT = 10 ** 18;
597 
598     // Max unsigned integer value
599     uint256 constant internal MAX_UINT_256 = type(uint256).max;
600     // Max and min signed integer value
601     int256 constant internal MAX_INT_256 = type(int256).max;
602     int256 constant internal MIN_INT_256 = type(int256).min;
603 
604     /**
605      * @dev Getter function since constants can't be read directly from libraries.
606      */
607     function preciseUnit() internal pure returns (uint256) {
608         return PRECISE_UNIT;
609     }
610 
611     /**
612      * @dev Getter function since constants can't be read directly from libraries.
613      */
614     function preciseUnitInt() internal pure returns (int256) {
615         return PRECISE_UNIT_INT;
616     }
617 
618     /**
619      * @dev Getter function since constants can't be read directly from libraries.
620      */
621     function maxUint256() internal pure returns (uint256) {
622         return MAX_UINT_256;
623     }
624 
625     /**
626      * @dev Getter function since constants can't be read directly from libraries.
627      */
628     function maxInt256() internal pure returns (int256) {
629         return MAX_INT_256;
630     }
631 
632     /**
633      * @dev Getter function since constants can't be read directly from libraries.
634      */
635     function minInt256() internal pure returns (int256) {
636         return MIN_INT_256;
637     }
638 
639     /**
640      * @dev Multiplies value a by value b (result is rounded down). It's assumed that the value b is the significand
641      * of a number with 18 decimals precision.
642      */
643     function preciseMul(uint256 a, uint256 b) internal pure returns (uint256) {
644         return a.mul(b).div(PRECISE_UNIT);
645     }
646 
647     /**
648      * @dev Multiplies value a by value b (result is rounded towards zero). It's assumed that the value b is the
649      * significand of a number with 18 decimals precision.
650      */
651     function preciseMul(int256 a, int256 b) internal pure returns (int256) {
652         return a.mul(b).div(PRECISE_UNIT_INT);
653     }
654 
655     /**
656      * @dev Multiplies value a by value b (result is rounded up). It's assumed that the value b is the significand
657      * of a number with 18 decimals precision.
658      */
659     function preciseMulCeil(uint256 a, uint256 b) internal pure returns (uint256) {
660         if (a == 0 || b == 0) {
661             return 0;
662         }
663         return a.mul(b).sub(1).div(PRECISE_UNIT).add(1);
664     }
665 
666     /**
667      * @dev Divides value a by value b (result is rounded down).
668      */
669     function preciseDiv(uint256 a, uint256 b) internal pure returns (uint256) {
670         return a.mul(PRECISE_UNIT).div(b);
671     }
672 
673 
674     /**
675      * @dev Divides value a by value b (result is rounded towards 0).
676      */
677     function preciseDiv(int256 a, int256 b) internal pure returns (int256) {
678         return a.mul(PRECISE_UNIT_INT).div(b);
679     }
680 
681     /**
682      * @dev Divides value a by value b (result is rounded up or away from 0).
683      */
684     function preciseDivCeil(uint256 a, uint256 b) internal pure returns (uint256) {
685         require(b != 0, "Cant divide by 0");
686 
687         return a > 0 ? a.mul(PRECISE_UNIT).sub(1).div(b).add(1) : 0;
688     }
689 
690     /**
691      * @dev Divides value a by value b (result is rounded down - positive numbers toward 0 and negative away from 0).
692      */
693     function divDown(int256 a, int256 b) internal pure returns (int256) {
694         require(b != 0, "Cant divide by 0");
695         require(a != MIN_INT_256 || b != -1, "Invalid input");
696 
697         int256 result = a.div(b);
698         if (a ^ b < 0 && a % b != 0) {
699             result -= 1;
700         }
701 
702         return result;
703     }
704 
705     /**
706      * @dev Multiplies value a by value b where rounding is towards the lesser number. 
707      * (positive values are rounded towards zero and negative values are rounded away from 0). 
708      */
709     function conservativePreciseMul(int256 a, int256 b) internal pure returns (int256) {
710         return divDown(a.mul(b), PRECISE_UNIT_INT);
711     }
712 
713     /**
714      * @dev Divides value a by value b where rounding is towards the lesser number. 
715      * (positive values are rounded towards zero and negative values are rounded away from 0). 
716      */
717     function conservativePreciseDiv(int256 a, int256 b) internal pure returns (int256) {
718         return divDown(a.mul(PRECISE_UNIT_INT), b);
719     }
720 
721     /**
722     * @dev Performs the power on a specified value, reverts on overflow.
723     */
724     function safePower(
725         uint256 a,
726         uint256 pow
727     )
728         internal
729         pure
730         returns (uint256)
731     {
732         require(a > 0, "Value must be positive");
733 
734         uint256 result = 1;
735         for (uint256 i = 0; i < pow; i++){
736             uint256 previousResult = result;
737 
738             // Using safemath multiplication prevents overflows
739             result = previousResult.mul(a);
740         }
741 
742         return result;
743     }
744 }
745 // Dependency file: contracts/protocol/lib/Position.sol
746 
747 /*
748     Copyright 2020 Set Labs Inc.
749 
750     Licensed under the Apache License, Version 2.0 (the "License");
751     you may not use this file except in compliance with the License.
752     You may obtain a copy of the License at
753 
754     http://www.apache.org/licenses/LICENSE-2.0
755 
756     Unless required by applicable law or agreed to in writing, software
757     distributed under the License is distributed on an "AS IS" BASIS,
758     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
759     See the License for the specific language governing permissions and
760     limitations under the License.
761 
762 
763 */
764 
765 // pragma solidity 0.6.10;
766 // pragma experimental "ABIEncoderV2";
767 
768 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
769 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
770 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
771 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
772 
773 // import { ISetToken } from "../../interfaces/ISetToken.sol";
774 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
775 
776 
777 /**
778  * @title Position
779  * @author Set Protocol
780  *
781  * Collection of helper functions for handling and updating SetToken Positions
782  */
783 library Position {
784     using SafeCast for uint256;
785     using SafeMath for uint256;
786     using SafeCast for int256;
787     using SignedSafeMath for int256;
788     using PreciseUnitMath for uint256;
789 
790     /* ============ Helper ============ */
791 
792     /**
793      * Returns whether the SetToken has a default position for a given component (if the real unit is > 0)
794      */
795     function hasDefaultPosition(ISetToken _setToken, address _component) internal view returns(bool) {
796         return _setToken.getDefaultPositionRealUnit(_component) > 0;
797     }
798 
799     /**
800      * Returns whether the SetToken has an external position for a given component (if # of position modules is > 0)
801      */
802     function hasExternalPosition(ISetToken _setToken, address _component) internal view returns(bool) {
803         return _setToken.getExternalPositionModules(_component).length > 0;
804     }
805     
806     /**
807      * Returns whether the SetToken component default position real unit is greater than or equal to units passed in.
808      */
809     function hasSufficientDefaultUnits(ISetToken _setToken, address _component, uint256 _unit) internal view returns(bool) {
810         return _setToken.getDefaultPositionRealUnit(_component) >= _unit.toInt256();
811     }
812 
813     /**
814      * Returns whether the SetToken component external position is greater than or equal to the real units passed in.
815      */
816     function hasSufficientExternalUnits(
817         ISetToken _setToken,
818         address _component,
819         address _positionModule,
820         uint256 _unit
821     )
822         internal
823         view
824         returns(bool)
825     {
826        return _setToken.getExternalPositionRealUnit(_component, _positionModule) >= _unit.toInt256();    
827     }
828 
829     /**
830      * If the position does not exist, create a new Position and add to the SetToken. If it already exists,
831      * then set the position units. If the new units is 0, remove the position. Handles adding/removing of 
832      * components where needed (in light of potential external positions).
833      *
834      * @param _setToken           Address of SetToken being modified
835      * @param _component          Address of the component
836      * @param _newUnit            Quantity of Position units - must be >= 0
837      */
838     function editDefaultPosition(ISetToken _setToken, address _component, uint256 _newUnit) internal {
839         bool isPositionFound = hasDefaultPosition(_setToken, _component);
840         if (!isPositionFound && _newUnit > 0) {
841             // If there is no Default Position and no External Modules, then component does not exist
842             if (!hasExternalPosition(_setToken, _component)) {
843                 _setToken.addComponent(_component);
844             }
845         } else if (isPositionFound && _newUnit == 0) {
846             // If there is a Default Position and no external positions, remove the component
847             if (!hasExternalPosition(_setToken, _component)) {
848                 _setToken.removeComponent(_component);
849             }
850         }
851 
852         _setToken.editDefaultPositionUnit(_component, _newUnit.toInt256());
853     }
854 
855     /**
856      * Update an external position and remove and external positions or components if necessary. The logic flows as follows:
857      * 1) If component is not already added then add component and external position. 
858      * 2) If component is added but no existing external position using the passed module exists then add the external position.
859      * 3) If the existing position is being added to then just update the unit and data
860      * 4) If the position is being closed and no other external positions or default positions are associated with the component
861      *    then untrack the component and remove external position.
862      * 5) If the position is being closed and other existing positions still exist for the component then just remove the
863      *    external position.
864      *
865      * @param _setToken         SetToken being updated
866      * @param _component        Component position being updated
867      * @param _module           Module external position is associated with
868      * @param _newUnit          Position units of new external position
869      * @param _data             Arbitrary data associated with the position
870      */
871     function editExternalPosition(
872         ISetToken _setToken,
873         address _component,
874         address _module,
875         int256 _newUnit,
876         bytes memory _data
877     )
878         internal
879     {
880         if (_newUnit != 0) {
881             if (!_setToken.isComponent(_component)) {
882                 _setToken.addComponent(_component);
883                 _setToken.addExternalPositionModule(_component, _module);
884             } else if (!_setToken.isExternalPositionModule(_component, _module)) {
885                 _setToken.addExternalPositionModule(_component, _module);
886             }
887             _setToken.editExternalPositionUnit(_component, _module, _newUnit);
888             _setToken.editExternalPositionData(_component, _module, _data);
889         } else {
890             require(_data.length == 0, "Passed data must be null");
891             // If no default or external position remaining then remove component from components array
892             address[] memory positionModules = _setToken.getExternalPositionModules(_component);
893             if (_setToken.getDefaultPositionRealUnit(_component) == 0 && positionModules.length == 1) {
894                 require(positionModules[0] == _module, "External positions must be 0 to remove component");
895                 _setToken.removeComponent(_component);
896             }
897             _setToken.removeExternalPositionModule(_component, _module);
898         }
899     }
900 
901     /**
902      * Get total notional amount of Default position
903      *
904      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
905      * @param _positionUnit       Quantity of Position units
906      *
907      * @return                    Total notional amount of units
908      */
909     function getDefaultTotalNotional(uint256 _setTokenSupply, uint256 _positionUnit) internal pure returns (uint256) {
910         return _setTokenSupply.preciseMul(_positionUnit);
911     }
912 
913     /**
914      * Get position unit from total notional amount
915      *
916      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
917      * @param _totalNotional      Total notional amount of component prior to
918      * @return                    Default position unit
919      */
920     function getDefaultPositionUnit(uint256 _setTokenSupply, uint256 _totalNotional) internal pure returns (uint256) {
921         return _totalNotional.preciseDiv(_setTokenSupply);
922     }
923 
924     /**
925      * Get the total tracked balance - total supply * position unit
926      *
927      * @param _setToken           Address of the SetToken
928      * @param _component          Address of the component
929      * @return                    Notional tracked balance
930      */
931     function getDefaultTrackedBalance(ISetToken _setToken, address _component) internal view returns(uint256) {
932         int256 positionUnit = _setToken.getDefaultPositionRealUnit(_component); 
933         return _setToken.totalSupply().preciseMul(positionUnit.toUint256());
934     }
935 
936     /**
937      * Calculates the new default position unit and performs the edit with the new unit
938      *
939      * @param _setToken                 Address of the SetToken
940      * @param _component                Address of the component
941      * @param _setTotalSupply           Current SetToken supply
942      * @param _componentPreviousBalance Pre-action component balance
943      * @return                          Current component balance
944      * @return                          Previous position unit
945      * @return                          New position unit
946      */
947     function calculateAndEditDefaultPosition(
948         ISetToken _setToken,
949         address _component,
950         uint256 _setTotalSupply,
951         uint256 _componentPreviousBalance
952     )
953         internal
954         returns(uint256, uint256, uint256)
955     {
956         uint256 currentBalance = IERC20(_component).balanceOf(address(_setToken));
957         uint256 positionUnit = _setToken.getDefaultPositionRealUnit(_component).toUint256();
958 
959         uint256 newTokenUnit = calculateDefaultEditPositionUnit(
960             _setTotalSupply,
961             _componentPreviousBalance,
962             currentBalance,
963             positionUnit
964         );
965 
966         editDefaultPosition(_setToken, _component, newTokenUnit);
967 
968         return (currentBalance, positionUnit, newTokenUnit);
969     }
970 
971     /**
972      * Calculate the new position unit given total notional values pre and post executing an action that changes SetToken state
973      * The intention is to make updates to the units without accidentally picking up airdropped assets as well.
974      *
975      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
976      * @param _preTotalNotional   Total notional amount of component prior to executing action
977      * @param _postTotalNotional  Total notional amount of component after the executing action
978      * @param _prePositionUnit    Position unit of SetToken prior to executing action
979      * @return                    New position unit
980      */
981     function calculateDefaultEditPositionUnit(
982         uint256 _setTokenSupply,
983         uint256 _preTotalNotional,
984         uint256 _postTotalNotional,
985         uint256 _prePositionUnit
986     )
987         internal
988         pure
989         returns (uint256)
990     {
991         // If pre action total notional amount is greater then subtract post action total notional and calculate new position units
992         uint256 airdroppedAmount = _preTotalNotional.sub(_prePositionUnit.preciseMul(_setTokenSupply));
993         return _postTotalNotional.sub(airdroppedAmount).preciseDiv(_setTokenSupply);
994     }
995 }
996 
997 // Dependency file: contracts/protocol/lib/ModuleBase.sol
998 
999 /*
1000     Copyright 2020 Set Labs Inc.
1001 
1002     Licensed under the Apache License, Version 2.0 (the "License");
1003     you may not use this file except in compliance with the License.
1004     You may obtain a copy of the License at
1005 
1006     http://www.apache.org/licenses/LICENSE-2.0
1007 
1008     Unless required by applicable law or agreed to in writing, software
1009     distributed under the License is distributed on an "AS IS" BASIS,
1010     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1011     See the License for the specific language governing permissions and
1012     limitations under the License.
1013 
1014 
1015 */
1016 
1017 // pragma solidity 0.6.10;
1018 
1019 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1020 
1021 // import { ExplicitERC20 } from "../../lib/ExplicitERC20.sol";
1022 // import { IController } from "../../interfaces/IController.sol";
1023 // import { IModule } from "../../interfaces/IModule.sol";
1024 // import { ISetToken } from "../../interfaces/ISetToken.sol";
1025 // import { Invoke } from "./Invoke.sol";
1026 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
1027 // import { ResourceIdentifier } from "./ResourceIdentifier.sol";
1028 
1029 /**
1030  * @title ModuleBase
1031  * @author Set Protocol
1032  *
1033  * Abstract class that houses common Module-related state and functions.
1034  */
1035 abstract contract ModuleBase is IModule {
1036     using PreciseUnitMath for uint256;
1037     using Invoke for ISetToken;
1038     using ResourceIdentifier for IController;
1039 
1040     /* ============ State Variables ============ */
1041 
1042     // Address of the controller
1043     IController public controller;
1044 
1045     /* ============ Modifiers ============ */
1046 
1047     modifier onlyManagerAndValidSet(ISetToken _setToken) { 
1048         require(isSetManager(_setToken, msg.sender), "Must be the SetToken manager");
1049         require(isSetValidAndInitialized(_setToken), "Must be a valid and initialized SetToken");
1050         _;
1051     }
1052 
1053     modifier onlySetManager(ISetToken _setToken, address _caller) {
1054         require(isSetManager(_setToken, _caller), "Must be the SetToken manager");
1055         _;
1056     }
1057 
1058     modifier onlyValidAndInitializedSet(ISetToken _setToken) {
1059         require(isSetValidAndInitialized(_setToken), "Must be a valid and initialized SetToken");
1060         _;
1061     }
1062 
1063     /**
1064      * Throws if the sender is not a SetToken's module or module not enabled
1065      */
1066     modifier onlyModule(ISetToken _setToken) {
1067         require(
1068             _setToken.moduleStates(msg.sender) == ISetToken.ModuleState.INITIALIZED,
1069             "Only the module can call"
1070         );
1071 
1072         require(
1073             controller.isModule(msg.sender),
1074             "Module must be enabled on controller"
1075         );
1076         _;
1077     }
1078 
1079     /**
1080      * Utilized during module initializations to check that the module is in pending state
1081      * and that the SetToken is valid
1082      */
1083     modifier onlyValidAndPendingSet(ISetToken _setToken) {
1084         require(controller.isSet(address(_setToken)), "Must be controller-enabled SetToken");
1085         require(isSetPendingInitialization(_setToken), "Must be pending initialization");        
1086         _;
1087     }
1088 
1089     /* ============ Constructor ============ */
1090 
1091     /**
1092      * Set state variables and map asset pairs to their oracles
1093      *
1094      * @param _controller             Address of controller contract
1095      */
1096     constructor(IController _controller) public {
1097         controller = _controller;
1098     }
1099 
1100     /* ============ Internal Functions ============ */
1101 
1102     /**
1103      * Transfers tokens from an address (that has set allowance on the module).
1104      *
1105      * @param  _token          The address of the ERC20 token
1106      * @param  _from           The address to transfer from
1107      * @param  _to             The address to transfer to
1108      * @param  _quantity       The number of tokens to transfer
1109      */
1110     function transferFrom(IERC20 _token, address _from, address _to, uint256 _quantity) internal {
1111         ExplicitERC20.transferFrom(_token, _from, _to, _quantity);
1112     }
1113 
1114     /**
1115      * Gets the integration for the module with the passed in name. Validates that the address is not empty
1116      */
1117     function getAndValidateAdapter(string memory _integrationName) internal view returns(address) { 
1118         bytes32 integrationHash = getNameHash(_integrationName);
1119         return getAndValidateAdapterWithHash(integrationHash);
1120     }
1121 
1122     /**
1123      * Gets the integration for the module with the passed in hash. Validates that the address is not empty
1124      */
1125     function getAndValidateAdapterWithHash(bytes32 _integrationHash) internal view returns(address) { 
1126         address adapter = controller.getIntegrationRegistry().getIntegrationAdapterWithHash(
1127             address(this),
1128             _integrationHash
1129         );
1130 
1131         require(adapter != address(0), "Must be valid adapter"); 
1132         return adapter;
1133     }
1134 
1135     /**
1136      * Gets the total fee for this module of the passed in index (fee % * quantity)
1137      */
1138     function getModuleFee(uint256 _feeIndex, uint256 _quantity) internal view returns(uint256) {
1139         uint256 feePercentage = controller.getModuleFee(address(this), _feeIndex);
1140         return _quantity.preciseMul(feePercentage);
1141     }
1142 
1143     /**
1144      * Pays the _feeQuantity from the _setToken denominated in _token to the protocol fee recipient
1145      */
1146     function payProtocolFeeFromSetToken(ISetToken _setToken, address _token, uint256 _feeQuantity) internal {
1147         if (_feeQuantity > 0) {
1148             _setToken.strictInvokeTransfer(_token, controller.feeRecipient(), _feeQuantity); 
1149         }
1150     }
1151 
1152     /**
1153      * Returns true if the module is in process of initialization on the SetToken
1154      */
1155     function isSetPendingInitialization(ISetToken _setToken) internal view returns(bool) {
1156         return _setToken.isPendingModule(address(this));
1157     }
1158 
1159     /**
1160      * Returns true if the address is the SetToken's manager
1161      */
1162     function isSetManager(ISetToken _setToken, address _toCheck) internal view returns(bool) {
1163         return _setToken.manager() == _toCheck;
1164     }
1165 
1166     /**
1167      * Returns true if SetToken must be enabled on the controller 
1168      * and module is registered on the SetToken
1169      */
1170     function isSetValidAndInitialized(ISetToken _setToken) internal view returns(bool) {
1171         return controller.isSet(address(_setToken)) &&
1172             _setToken.isInitializedModule(address(this));
1173     }
1174 
1175     /**
1176      * Hashes the string and returns a bytes32 value
1177      */
1178     function getNameHash(string memory _name) internal pure returns(bytes32) {
1179         return keccak256(bytes(_name));
1180     }
1181 }
1182 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
1183 
1184 
1185 
1186 // pragma solidity ^0.6.0;
1187 
1188 /**
1189  * @dev Interface of the ERC20 standard as defined in the EIP.
1190  */
1191 interface IERC20 {
1192     /**
1193      * @dev Returns the amount of tokens in existence.
1194      */
1195     function totalSupply() external view returns (uint256);
1196 
1197     /**
1198      * @dev Returns the amount of tokens owned by `account`.
1199      */
1200     function balanceOf(address account) external view returns (uint256);
1201 
1202     /**
1203      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1204      *
1205      * Returns a boolean value indicating whether the operation succeeded.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function transfer(address recipient, uint256 amount) external returns (bool);
1210 
1211     /**
1212      * @dev Returns the remaining number of tokens that `spender` will be
1213      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1214      * zero by default.
1215      *
1216      * This value changes when {approve} or {transferFrom} are called.
1217      */
1218     function allowance(address owner, address spender) external view returns (uint256);
1219 
1220     /**
1221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1222      *
1223      * Returns a boolean value indicating whether the operation succeeded.
1224      *
1225      * // importANT: Beware that changing an allowance with this method brings the risk
1226      * that someone may use both the old and the new allowance by unfortunate
1227      * transaction ordering. One possible solution to mitigate this race
1228      * condition is to first reduce the spender's allowance to 0 and set the
1229      * desired value afterwards:
1230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1231      *
1232      * Emits an {Approval} event.
1233      */
1234     function approve(address spender, uint256 amount) external returns (bool);
1235 
1236     /**
1237      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1238      * allowance mechanism. `amount` is then deducted from the caller's
1239      * allowance.
1240      *
1241      * Returns a boolean value indicating whether the operation succeeded.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1246 
1247     /**
1248      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1249      * another (`to`).
1250      *
1251      * Note that `value` may be zero.
1252      */
1253     event Transfer(address indexed from, address indexed to, uint256 value);
1254 
1255     /**
1256      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1257      * a call to {approve}. `value` is the new allowance.
1258      */
1259     event Approval(address indexed owner, address indexed spender, uint256 value);
1260 }
1261 
1262 // Dependency file: contracts/interfaces/ISetToken.sol
1263 
1264 /*
1265     Copyright 2020 Set Labs Inc.
1266 
1267     Licensed under the Apache License, Version 2.0 (the "License");
1268     you may not use this file except in compliance with the License.
1269     You may obtain a copy of the License at
1270 
1271     http://www.apache.org/licenses/LICENSE-2.0
1272 
1273     Unless required by applicable law or agreed to in writing, software
1274     distributed under the License is distributed on an "AS IS" BASIS,
1275     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1276     See the License for the specific language governing permissions and
1277     limitations under the License.
1278 
1279 
1280 */
1281 // pragma solidity 0.6.10;
1282 // pragma experimental "ABIEncoderV2";
1283 
1284 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1285 
1286 /**
1287  * @title ISetToken
1288  * @author Set Protocol
1289  *
1290  * Interface for operating with SetTokens.
1291  */
1292 interface ISetToken is IERC20 {
1293 
1294     /* ============ Enums ============ */
1295 
1296     enum ModuleState {
1297         NONE,
1298         PENDING,
1299         INITIALIZED
1300     }
1301 
1302     /* ============ Structs ============ */
1303     /**
1304      * The base definition of a SetToken Position
1305      *
1306      * @param component           Address of token in the Position
1307      * @param module              If not in default state, the address of associated module
1308      * @param unit                Each unit is the # of components per 10^18 of a SetToken
1309      * @param positionState       Position ENUM. Default is 0; External is 1
1310      * @param data                Arbitrary data
1311      */
1312     struct Position {
1313         address component;
1314         address module;
1315         int256 unit;
1316         uint8 positionState;
1317         bytes data;
1318     }
1319 
1320     /**
1321      * A struct that stores a component's cash position details and external positions
1322      * This data structure allows O(1) access to a component's cash position units and 
1323      * virtual units.
1324      *
1325      * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
1326      *                                  updating all units at once via the position multiplier. Virtual units are achieved
1327      *                                  by dividing a "real" value by the "positionMultiplier"
1328      * @param componentIndex            
1329      * @param externalPositionModules   List of external modules attached to each external position. Each module
1330      *                                  maps to an external position
1331      * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
1332      */
1333     struct ComponentPosition {
1334       int256 virtualUnit;
1335       address[] externalPositionModules;
1336       mapping(address => ExternalPosition) externalPositions;
1337     }
1338 
1339     /**
1340      * A struct that stores a component's external position details including virtual unit and any
1341      * auxiliary data.
1342      *
1343      * @param virtualUnit       Virtual value of a component's EXTERNAL position.
1344      * @param data              Arbitrary data
1345      */
1346     struct ExternalPosition {
1347       int256 virtualUnit;
1348       bytes data;
1349     }
1350 
1351 
1352     /* ============ Functions ============ */
1353     
1354     function addComponent(address _component) external;
1355     function removeComponent(address _component) external;
1356     function editDefaultPositionUnit(address _component, int256 _realUnit) external;
1357     function addExternalPositionModule(address _component, address _positionModule) external;
1358     function removeExternalPositionModule(address _component, address _positionModule) external;
1359     function editExternalPositionUnit(address _component, address _positionModule, int256 _realUnit) external;
1360     function editExternalPositionData(address _component, address _positionModule, bytes calldata _data) external;
1361 
1362     function invoke(address _target, uint256 _value, bytes calldata _data) external returns(bytes memory);
1363 
1364     function editPositionMultiplier(int256 _newMultiplier) external;
1365 
1366     function mint(address _account, uint256 _quantity) external;
1367     function burn(address _account, uint256 _quantity) external;
1368 
1369     function lock() external;
1370     function unlock() external;
1371 
1372     function addModule(address _module) external;
1373     function removeModule(address _module) external;
1374     function initializeModule() external;
1375 
1376     function setManager(address _manager) external;
1377 
1378     function manager() external view returns (address);
1379     function moduleStates(address _module) external view returns (ModuleState);
1380     function getModules() external view returns (address[] memory);
1381     
1382     function getDefaultPositionRealUnit(address _component) external view returns(int256);
1383     function getExternalPositionRealUnit(address _component, address _positionModule) external view returns(int256);
1384     function getComponents() external view returns(address[] memory);
1385     function getExternalPositionModules(address _component) external view returns(address[] memory);
1386     function getExternalPositionData(address _component, address _positionModule) external view returns(bytes memory);
1387     function isExternalPositionModule(address _component, address _module) external view returns(bool);
1388     function isComponent(address _component) external view returns(bool);
1389     
1390     function positionMultiplier() external view returns (int256);
1391     function getPositions() external view returns (Position[] memory);
1392     function getTotalComponentRealUnits(address _component) external view returns(int256);
1393 
1394     function isInitializedModule(address _module) external view returns(bool);
1395     function isPendingModule(address _module) external view returns(bool);
1396     function isLocked() external view returns (bool);
1397 }
1398 // Dependency file: contracts/protocol/lib/Invoke.sol
1399 
1400 /*
1401     Copyright 2020 Set Labs Inc.
1402 
1403     Licensed under the Apache License, Version 2.0 (the "License");
1404     you may not use this file except in compliance with the License.
1405     You may obtain a copy of the License at
1406 
1407     http://www.apache.org/licenses/LICENSE-2.0
1408 
1409     Unless required by applicable law or agreed to in writing, software
1410     distributed under the License is distributed on an "AS IS" BASIS,
1411     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1412     See the License for the specific language governing permissions and
1413     limitations under the License.
1414 
1415 
1416 */
1417 
1418 // pragma solidity 0.6.10;
1419 
1420 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1421 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1422 
1423 // import { ISetToken } from "../../interfaces/ISetToken.sol";
1424 
1425 
1426 /**
1427  * @title Invoke
1428  * @author Set Protocol
1429  *
1430  * A collection of common utility functions for interacting with the SetToken's invoke function
1431  */
1432 library Invoke {
1433     using SafeMath for uint256;
1434 
1435     /* ============ Internal ============ */
1436 
1437     /**
1438      * Instructs the SetToken to set approvals of the ERC20 token to a spender.
1439      *
1440      * @param _setToken        SetToken instance to invoke
1441      * @param _token           ERC20 token to approve
1442      * @param _spender         The account allowed to spend the SetToken's balance
1443      * @param _quantity        The quantity of allowance to allow
1444      */
1445     function invokeApprove(
1446         ISetToken _setToken,
1447         address _token,
1448         address _spender,
1449         uint256 _quantity
1450     )
1451         internal
1452     {
1453         bytes memory callData = abi.encodeWithSignature("approve(address,uint256)", _spender, _quantity);
1454         _setToken.invoke(_token, 0, callData);
1455     }
1456 
1457     /**
1458      * Instructs the SetToken to transfer the ERC20 token to a recipient.
1459      *
1460      * @param _setToken        SetToken instance to invoke
1461      * @param _token           ERC20 token to transfer
1462      * @param _to              The recipient account
1463      * @param _quantity        The quantity to transfer
1464      */
1465     function invokeTransfer(
1466         ISetToken _setToken,
1467         address _token,
1468         address _to,
1469         uint256 _quantity
1470     )
1471         internal
1472     {
1473         if (_quantity > 0) {
1474             bytes memory callData = abi.encodeWithSignature("transfer(address,uint256)", _to, _quantity);
1475             _setToken.invoke(_token, 0, callData);
1476         }
1477     }
1478 
1479     /**
1480      * Instructs the SetToken to transfer the ERC20 token to a recipient.
1481      * The new SetToken balance must equal the existing balance less the quantity transferred
1482      *
1483      * @param _setToken        SetToken instance to invoke
1484      * @param _token           ERC20 token to transfer
1485      * @param _to              The recipient account
1486      * @param _quantity        The quantity to transfer
1487      */
1488     function strictInvokeTransfer(
1489         ISetToken _setToken,
1490         address _token,
1491         address _to,
1492         uint256 _quantity
1493     )
1494         internal
1495     {
1496         if (_quantity > 0) {
1497             // Retrieve current balance of token for the SetToken
1498             uint256 existingBalance = IERC20(_token).balanceOf(address(_setToken));
1499 
1500             Invoke.invokeTransfer(_setToken, _token, _to, _quantity);
1501 
1502             // Get new balance of transferred token for SetToken
1503             uint256 newBalance = IERC20(_token).balanceOf(address(_setToken));
1504 
1505             // Verify only the transfer quantity is subtracted
1506             require(
1507                 newBalance == existingBalance.sub(_quantity),
1508                 "Invalid post transfer balance"
1509             );
1510         }
1511     }
1512 
1513     /**
1514      * Instructs the SetToken to unwrap the passed quantity of WETH
1515      *
1516      * @param _setToken        SetToken instance to invoke
1517      * @param _weth            WETH address
1518      * @param _quantity        The quantity to unwrap
1519      */
1520     function invokeUnwrapWETH(ISetToken _setToken, address _weth, uint256 _quantity) internal {
1521         bytes memory callData = abi.encodeWithSignature("withdraw(uint256)", _quantity);
1522         _setToken.invoke(_weth, 0, callData);
1523     }
1524 
1525     /**
1526      * Instructs the SetToken to wrap the passed quantity of ETH
1527      *
1528      * @param _setToken        SetToken instance to invoke
1529      * @param _weth            WETH address
1530      * @param _quantity        The quantity to unwrap
1531      */
1532     function invokeWrapWETH(ISetToken _setToken, address _weth, uint256 _quantity) internal {
1533         bytes memory callData = abi.encodeWithSignature("deposit()");
1534         _setToken.invoke(_weth, _quantity, callData);
1535     }
1536 }
1537 // Dependency file: contracts/interfaces/IIntegrationRegistry.sol
1538 
1539 /*
1540     Copyright 2020 Set Labs Inc.
1541 
1542     Licensed under the Apache License, Version 2.0 (the "License");
1543     you may not use this file except in compliance with the License.
1544     You may obtain a copy of the License at
1545 
1546     http://www.apache.org/licenses/LICENSE-2.0
1547 
1548     Unless required by applicable law or agreed to in writing, software
1549     distributed under the License is distributed on an "AS IS" BASIS,
1550     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1551     See the License for the specific language governing permissions and
1552     limitations under the License.
1553 
1554 
1555 */
1556 // pragma solidity 0.6.10;
1557 
1558 interface IIntegrationRegistry {
1559     function addIntegration(address _module, string memory _id, address _wrapper) external;
1560     function getIntegrationAdapter(address _module, string memory _id) external view returns(address);
1561     function getIntegrationAdapterWithHash(address _module, bytes32 _id) external view returns(address);
1562     function isValidIntegration(address _module, string memory _id) external view returns(bool);
1563 }
1564 // Dependency file: contracts/interfaces/IExchangeAdapter.sol
1565 
1566 /*
1567     Copyright 2020 Set Labs Inc.
1568 
1569     Licensed under the Apache License, Version 2.0 (the "License");
1570     you may not use this file except in compliance with the License.
1571     You may obtain a copy of the License at
1572 
1573     http://www.apache.org/licenses/LICENSE-2.0
1574 
1575     Unless required by applicable law or agreed to in writing, software
1576     distributed under the License is distributed on an "AS IS" BASIS,
1577     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1578     See the License for the specific language governing permissions and
1579     limitations under the License.
1580 
1581 
1582 */
1583 // pragma solidity 0.6.10;
1584 
1585 interface IExchangeAdapter {
1586     function getSpender() external view returns(address);
1587     function getTradeCalldata(
1588         address _fromToken,
1589         address _toToken,
1590         address _toAddress,
1591         uint256 _fromQuantity,
1592         uint256 _minToQuantity,
1593         bytes memory _data
1594     )
1595         external
1596         view
1597         returns (address, uint256, bytes memory);
1598 }
1599 
1600 // Dependency file: contracts/interfaces/IController.sol
1601 
1602 /*
1603     Copyright 2020 Set Labs Inc.
1604 
1605     Licensed under the Apache License, Version 2.0 (the "License");
1606     you may not use this file except in compliance with the License.
1607     You may obtain a copy of the License at
1608 
1609     http://www.apache.org/licenses/LICENSE-2.0
1610 
1611     Unless required by applicable law or agreed to in writing, software
1612     distributed under the License is distributed on an "AS IS" BASIS,
1613     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1614     See the License for the specific language governing permissions and
1615     limitations under the License.
1616 
1617 
1618 */
1619 // pragma solidity 0.6.10;
1620 
1621 interface IController {
1622     function addSet(address _setToken) external;
1623     function feeRecipient() external view returns(address);
1624     function getModuleFee(address _module, uint256 _feeType) external view returns(uint256);
1625     function isModule(address _module) external view returns(bool);
1626     function isSet(address _setToken) external view returns(bool);
1627     function isSystemContract(address _contractAddress) external view returns (bool);
1628     function resourceId(uint256 _id) external view returns(address);
1629 }
1630 // Dependency file: @openzeppelin/contracts/utils/SafeCast.sol
1631 
1632 
1633 
1634 // pragma solidity ^0.6.0;
1635 
1636 
1637 /**
1638  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1639  * checks.
1640  *
1641  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1642  * easily result in undesired exploitation or bugs, since developers usually
1643  * assume that overflows raise errors. `SafeCast` restores this intuition by
1644  * reverting the transaction when such an operation overflows.
1645  *
1646  * Using this library instead of the unchecked operations eliminates an entire
1647  * class of bugs, so it's recommended to use it always.
1648  *
1649  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1650  * all math on `uint256` and `int256` and then downcasting.
1651  */
1652 library SafeCast {
1653 
1654     /**
1655      * @dev Returns the downcasted uint128 from uint256, reverting on
1656      * overflow (when the input is greater than largest uint128).
1657      *
1658      * Counterpart to Solidity's `uint128` operator.
1659      *
1660      * Requirements:
1661      *
1662      * - input must fit into 128 bits
1663      */
1664     function toUint128(uint256 value) internal pure returns (uint128) {
1665         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1666         return uint128(value);
1667     }
1668 
1669     /**
1670      * @dev Returns the downcasted uint64 from uint256, reverting on
1671      * overflow (when the input is greater than largest uint64).
1672      *
1673      * Counterpart to Solidity's `uint64` operator.
1674      *
1675      * Requirements:
1676      *
1677      * - input must fit into 64 bits
1678      */
1679     function toUint64(uint256 value) internal pure returns (uint64) {
1680         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
1681         return uint64(value);
1682     }
1683 
1684     /**
1685      * @dev Returns the downcasted uint32 from uint256, reverting on
1686      * overflow (when the input is greater than largest uint32).
1687      *
1688      * Counterpart to Solidity's `uint32` operator.
1689      *
1690      * Requirements:
1691      *
1692      * - input must fit into 32 bits
1693      */
1694     function toUint32(uint256 value) internal pure returns (uint32) {
1695         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1696         return uint32(value);
1697     }
1698 
1699     /**
1700      * @dev Returns the downcasted uint16 from uint256, reverting on
1701      * overflow (when the input is greater than largest uint16).
1702      *
1703      * Counterpart to Solidity's `uint16` operator.
1704      *
1705      * Requirements:
1706      *
1707      * - input must fit into 16 bits
1708      */
1709     function toUint16(uint256 value) internal pure returns (uint16) {
1710         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
1711         return uint16(value);
1712     }
1713 
1714     /**
1715      * @dev Returns the downcasted uint8 from uint256, reverting on
1716      * overflow (when the input is greater than largest uint8).
1717      *
1718      * Counterpart to Solidity's `uint8` operator.
1719      *
1720      * Requirements:
1721      *
1722      * - input must fit into 8 bits.
1723      */
1724     function toUint8(uint256 value) internal pure returns (uint8) {
1725         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
1726         return uint8(value);
1727     }
1728 
1729     /**
1730      * @dev Converts a signed int256 into an unsigned uint256.
1731      *
1732      * Requirements:
1733      *
1734      * - input must be greater than or equal to 0.
1735      */
1736     function toUint256(int256 value) internal pure returns (uint256) {
1737         require(value >= 0, "SafeCast: value must be positive");
1738         return uint256(value);
1739     }
1740 
1741     /**
1742      * @dev Returns the downcasted int128 from int256, reverting on
1743      * overflow (when the input is less than smallest int128 or
1744      * greater than largest int128).
1745      *
1746      * Counterpart to Solidity's `int128` operator.
1747      *
1748      * Requirements:
1749      *
1750      * - input must fit into 128 bits
1751      *
1752      * _Available since v3.1._
1753      */
1754     function toInt128(int256 value) internal pure returns (int128) {
1755         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
1756         return int128(value);
1757     }
1758 
1759     /**
1760      * @dev Returns the downcasted int64 from int256, reverting on
1761      * overflow (when the input is less than smallest int64 or
1762      * greater than largest int64).
1763      *
1764      * Counterpart to Solidity's `int64` operator.
1765      *
1766      * Requirements:
1767      *
1768      * - input must fit into 64 bits
1769      *
1770      * _Available since v3.1._
1771      */
1772     function toInt64(int256 value) internal pure returns (int64) {
1773         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
1774         return int64(value);
1775     }
1776 
1777     /**
1778      * @dev Returns the downcasted int32 from int256, reverting on
1779      * overflow (when the input is less than smallest int32 or
1780      * greater than largest int32).
1781      *
1782      * Counterpart to Solidity's `int32` operator.
1783      *
1784      * Requirements:
1785      *
1786      * - input must fit into 32 bits
1787      *
1788      * _Available since v3.1._
1789      */
1790     function toInt32(int256 value) internal pure returns (int32) {
1791         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
1792         return int32(value);
1793     }
1794 
1795     /**
1796      * @dev Returns the downcasted int16 from int256, reverting on
1797      * overflow (when the input is less than smallest int16 or
1798      * greater than largest int16).
1799      *
1800      * Counterpart to Solidity's `int16` operator.
1801      *
1802      * Requirements:
1803      *
1804      * - input must fit into 16 bits
1805      *
1806      * _Available since v3.1._
1807      */
1808     function toInt16(int256 value) internal pure returns (int16) {
1809         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
1810         return int16(value);
1811     }
1812 
1813     /**
1814      * @dev Returns the downcasted int8 from int256, reverting on
1815      * overflow (when the input is less than smallest int8 or
1816      * greater than largest int8).
1817      *
1818      * Counterpart to Solidity's `int8` operator.
1819      *
1820      * Requirements:
1821      *
1822      * - input must fit into 8 bits.
1823      *
1824      * _Available since v3.1._
1825      */
1826     function toInt8(int256 value) internal pure returns (int8) {
1827         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
1828         return int8(value);
1829     }
1830 
1831     /**
1832      * @dev Converts an unsigned uint256 into a signed int256.
1833      *
1834      * Requirements:
1835      *
1836      * - input must be less than or equal to maxInt256.
1837      */
1838     function toInt256(uint256 value) internal pure returns (int256) {
1839         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
1840         return int256(value);
1841     }
1842 }
1843 
1844 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
1845 
1846 
1847 
1848 // pragma solidity ^0.6.0;
1849 
1850 /**
1851  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1852  * checks.
1853  *
1854  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1855  * in bugs, because programmers usually assume that an overflow raises an
1856  * error, which is the standard behavior in high level programming languages.
1857  * `SafeMath` restores this intuition by reverting the transaction when an
1858  * operation overflows.
1859  *
1860  * Using this library instead of the unchecked operations eliminates an entire
1861  * class of bugs, so it's recommended to use it always.
1862  */
1863 library SafeMath {
1864     /**
1865      * @dev Returns the addition of two unsigned integers, reverting on
1866      * overflow.
1867      *
1868      * Counterpart to Solidity's `+` operator.
1869      *
1870      * Requirements:
1871      *
1872      * - Addition cannot overflow.
1873      */
1874     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1875         uint256 c = a + b;
1876         require(c >= a, "SafeMath: addition overflow");
1877 
1878         return c;
1879     }
1880 
1881     /**
1882      * @dev Returns the subtraction of two unsigned integers, reverting on
1883      * overflow (when the result is negative).
1884      *
1885      * Counterpart to Solidity's `-` operator.
1886      *
1887      * Requirements:
1888      *
1889      * - Subtraction cannot overflow.
1890      */
1891     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1892         return sub(a, b, "SafeMath: subtraction overflow");
1893     }
1894 
1895     /**
1896      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1897      * overflow (when the result is negative).
1898      *
1899      * Counterpart to Solidity's `-` operator.
1900      *
1901      * Requirements:
1902      *
1903      * - Subtraction cannot overflow.
1904      */
1905     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1906         require(b <= a, errorMessage);
1907         uint256 c = a - b;
1908 
1909         return c;
1910     }
1911 
1912     /**
1913      * @dev Returns the multiplication of two unsigned integers, reverting on
1914      * overflow.
1915      *
1916      * Counterpart to Solidity's `*` operator.
1917      *
1918      * Requirements:
1919      *
1920      * - Multiplication cannot overflow.
1921      */
1922     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1923         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1924         // benefit is lost if 'b' is also tested.
1925         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1926         if (a == 0) {
1927             return 0;
1928         }
1929 
1930         uint256 c = a * b;
1931         require(c / a == b, "SafeMath: multiplication overflow");
1932 
1933         return c;
1934     }
1935 
1936     /**
1937      * @dev Returns the integer division of two unsigned integers. Reverts on
1938      * division by zero. The result is rounded towards zero.
1939      *
1940      * Counterpart to Solidity's `/` operator. Note: this function uses a
1941      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1942      * uses an invalid opcode to revert (consuming all remaining gas).
1943      *
1944      * Requirements:
1945      *
1946      * - The divisor cannot be zero.
1947      */
1948     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1949         return div(a, b, "SafeMath: division by zero");
1950     }
1951 
1952     /**
1953      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1954      * division by zero. The result is rounded towards zero.
1955      *
1956      * Counterpart to Solidity's `/` operator. Note: this function uses a
1957      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1958      * uses an invalid opcode to revert (consuming all remaining gas).
1959      *
1960      * Requirements:
1961      *
1962      * - The divisor cannot be zero.
1963      */
1964     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1965         require(b > 0, errorMessage);
1966         uint256 c = a / b;
1967         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1968 
1969         return c;
1970     }
1971 
1972     /**
1973      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1974      * Reverts when dividing by zero.
1975      *
1976      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1977      * opcode (which leaves remaining gas untouched) while Solidity uses an
1978      * invalid opcode to revert (consuming all remaining gas).
1979      *
1980      * Requirements:
1981      *
1982      * - The divisor cannot be zero.
1983      */
1984     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1985         return mod(a, b, "SafeMath: modulo by zero");
1986     }
1987 
1988     /**
1989      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1990      * Reverts with custom message when dividing by zero.
1991      *
1992      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1993      * opcode (which leaves remaining gas untouched) while Solidity uses an
1994      * invalid opcode to revert (consuming all remaining gas).
1995      *
1996      * Requirements:
1997      *
1998      * - The divisor cannot be zero.
1999      */
2000     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
2001         require(b != 0, errorMessage);
2002         return a % b;
2003     }
2004 }
2005 
2006 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
2007 
2008 
2009 
2010 // pragma solidity ^0.6.0;
2011 
2012 /**
2013  * @dev Contract module that helps prevent reentrant calls to a function.
2014  *
2015  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2016  * available, which can be applied to functions to make sure there are no nested
2017  * (reentrant) calls to them.
2018  *
2019  * Note that because there is a single `nonReentrant` guard, functions marked as
2020  * `nonReentrant` may not call one another. This can be worked around by making
2021  * those functions `private`, and then adding `external` `nonReentrant` entry
2022  * points to them.
2023  *
2024  * TIP: If you would like to learn more about reentrancy and alternative ways
2025  * to protect against it, check out our blog post
2026  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2027  */
2028 contract ReentrancyGuard {
2029     // Booleans are more expensive than uint256 or any type that takes up a full
2030     // word because each write operation emits an extra SLOAD to first read the
2031     // slot's contents, replace the bits taken up by the boolean, and then write
2032     // back. This is the compiler's defense against contract upgrades and
2033     // pointer aliasing, and it cannot be disabled.
2034 
2035     // The values being non-zero value makes deployment a bit more expensive,
2036     // but in exchange the refund on every call to nonReentrant will be lower in
2037     // amount. Since refunds are capped to a percentage of the total
2038     // transaction's gas, it is best to keep them low in cases like this one, to
2039     // increase the likelihood of the full refund coming into effect.
2040     uint256 private constant _NOT_ENTERED = 1;
2041     uint256 private constant _ENTERED = 2;
2042 
2043     uint256 private _status;
2044 
2045     constructor () internal {
2046         _status = _NOT_ENTERED;
2047     }
2048 
2049     /**
2050      * @dev Prevents a contract from calling itself, directly or indirectly.
2051      * Calling a `nonReentrant` function from another `nonReentrant`
2052      * function is not supported. It is possible to prevent this from happening
2053      * by making the `nonReentrant` function external, and make it call a
2054      * `private` function that does the actual work.
2055      */
2056     modifier nonReentrant() {
2057         // On the first call to nonReentrant, _notEntered will be true
2058         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2059 
2060         // Any calls to nonReentrant after this point will fail
2061         _status = _ENTERED;
2062 
2063         _;
2064 
2065         // By storing the original value once again, a refund is triggered (see
2066         // https://eips.ethereum.org/EIPS/eip-2200)
2067         _status = _NOT_ENTERED;
2068     }
2069 }
2070 
2071 /*
2072     Copyright 2020 Set Labs Inc.
2073 
2074     Licensed under the Apache License, Version 2.0 (the "License");
2075     you may not use this file except in compliance with the License.
2076     You may obtain a copy of the License at
2077 
2078     http://www.apache.org/licenses/LICENSE-2.0
2079 
2080     Unless required by applicable law or agreed to in writing, software
2081     distributed under the License is distributed on an "AS IS" BASIS,
2082     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2083     See the License for the specific language governing permissions and
2084     limitations under the License.
2085 
2086 
2087 */
2088 
2089 pragma solidity ^0.6.10;
2090 pragma experimental "ABIEncoderV2";
2091 
2092 // import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
2093 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
2094 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
2095 
2096 // import { IController } from "../../interfaces/IController.sol";
2097 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
2098 // import { IExchangeAdapter } from "../../interfaces/IExchangeAdapter.sol";
2099 // import { IIntegrationRegistry } from "../../interfaces/IIntegrationRegistry.sol";
2100 // import { Invoke } from "../lib/Invoke.sol";
2101 // import { ISetToken } from "../../interfaces/ISetToken.sol";
2102 // import { ModuleBase } from "../lib/ModuleBase.sol";
2103 // import { Position } from "../lib/Position.sol";
2104 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
2105 
2106 /**
2107  * @title TradeModule
2108  * @author Set Protocol
2109  *
2110  * Module that enables SetTokens to perform atomic trades using Decentralized Exchanges
2111  * such as 1inch or Kyber. Integrations mappings are stored on the IntegrationRegistry contract.
2112  */
2113 contract TradeModule is ModuleBase, ReentrancyGuard {
2114     using SafeCast for int256;
2115     using SafeMath for uint256;
2116 
2117     using Invoke for ISetToken;
2118     using Position for ISetToken;
2119     using PreciseUnitMath for uint256;
2120 
2121     /* ============ Struct ============ */
2122 
2123     struct TradeInfo {
2124         ISetToken setToken;                             // Instance of SetToken
2125         IExchangeAdapter exchangeAdapter;               // Instance of exchange adapter contract
2126         address sendToken;                              // Address of token being sold
2127         address receiveToken;                           // Address of token being bought
2128         uint256 setTotalSupply;                         // Total supply of SetToken in Precise Units (10^18)
2129         uint256 totalSendQuantity;                      // Total quantity of sold token (position unit x total supply)
2130         uint256 totalMinReceiveQuantity;                // Total minimum quantity of token to receive back
2131         uint256 preTradeSendTokenBalance;               // Total initial balance of token being sold
2132         uint256 preTradeReceiveTokenBalance;            // Total initial balance of token being bought
2133     }
2134 
2135     /* ============ Events ============ */
2136 
2137     event ComponentExchanged(
2138         ISetToken indexed _setToken,
2139         address indexed _sendToken,
2140         address indexed _receiveToken,
2141         IExchangeAdapter _exchangeAdapter,
2142         uint256 _totalSendAmount,
2143         uint256 _totalReceiveAmount,
2144         uint256 _protocolFee
2145     );
2146 
2147     /* ============ Constants ============ */
2148 
2149     // 0 index stores the fee % charged in the trade function
2150     uint256 constant internal TRADE_MODULE_PROTOCOL_FEE_INDEX = 0;
2151 
2152     /* ============ Constructor ============ */
2153 
2154     constructor(IController _controller) public ModuleBase(_controller) {}
2155 
2156     /* ============ External Functions ============ */
2157 
2158     /**
2159      * Initializes this module to the SetToken. Only callable by the SetToken's manager.
2160      *
2161      * @param _setToken                 Instance of the SetToken to initialize
2162      */
2163     function initialize(
2164         ISetToken _setToken
2165     )
2166         external
2167         onlyValidAndPendingSet(_setToken)
2168         onlySetManager(_setToken, msg.sender)
2169     {
2170         _setToken.initializeModule();
2171     }
2172 
2173     /**
2174      * Executes a trade on a supported DEX. Only callable by the SetToken's manager.
2175      * @dev Although the SetToken units are passed in for the send and receive quantities, the total quantity
2176      * sent and received is the quantity of SetToken units multiplied by the SetToken totalSupply.
2177      *
2178      * @param _setToken             Instance of the SetToken to trade
2179      * @param _exchangeName         Human readable name of the exchange in the integrations registry
2180      * @param _sendToken            Address of the token to be sent to the exchange
2181      * @param _sendQuantity         Units of token in SetToken sent to the exchange
2182      * @param _receiveToken         Address of the token that will be received from the exchange
2183      * @param _minReceiveQuantity   Min units of token in SetToken to be received from the exchange
2184      * @param _data                 Arbitrary bytes to be used to construct trade call data
2185      */
2186     function trade(
2187         ISetToken _setToken,
2188         string memory _exchangeName,
2189         address _sendToken,
2190         uint256 _sendQuantity,
2191         address _receiveToken,
2192         uint256 _minReceiveQuantity,
2193         bytes memory _data
2194     )
2195         external
2196         nonReentrant
2197         onlyManagerAndValidSet(_setToken)
2198     {
2199         TradeInfo memory tradeInfo = _createTradeInfo(
2200             _setToken,
2201             _exchangeName,
2202             _sendToken,
2203             _receiveToken,
2204             _sendQuantity,
2205             _minReceiveQuantity
2206         );
2207 
2208         _validatePreTradeData(tradeInfo, _sendQuantity);
2209 
2210         _executeTrade(tradeInfo, _data);
2211 
2212         uint256 exchangedQuantity = _validatePostTrade(tradeInfo);
2213 
2214         uint256 protocolFee = _accrueProtocolFee(tradeInfo, exchangedQuantity);
2215 
2216         (
2217             uint256 netSendAmount,
2218             uint256 netReceiveAmount
2219         ) = _updateSetTokenPositions(tradeInfo);
2220 
2221         emit ComponentExchanged(
2222             _setToken,
2223             _sendToken,
2224             _receiveToken,
2225             tradeInfo.exchangeAdapter,
2226             netSendAmount,
2227             netReceiveAmount,
2228             protocolFee
2229         );
2230     }
2231 
2232     /**
2233      * Removes this module from the SetToken, via call by the SetToken. Left with empty logic
2234      * here because there are no check needed to verify removal.
2235      */
2236     function removeModule() external override {}
2237 
2238     /* ============ Internal Functions ============ */
2239 
2240     /**
2241      * Create and return TradeInfo struct
2242      *
2243      * @param _setToken             Instance of the SetToken to trade
2244      * @param _exchangeName         Human readable name of the exchange in the integrations registry
2245      * @param _sendToken            Address of the token to be sent to the exchange
2246      * @param _receiveToken         Address of the token that will be received from the exchange
2247      * @param _sendQuantity         Units of token in SetToken sent to the exchange
2248      * @param _minReceiveQuantity   Min units of token in SetToken to be received from the exchange
2249      *
2250      * return TradeInfo             Struct containing data for trade
2251      */
2252     function _createTradeInfo(
2253         ISetToken _setToken,
2254         string memory _exchangeName,
2255         address _sendToken,
2256         address _receiveToken,
2257         uint256 _sendQuantity,
2258         uint256 _minReceiveQuantity
2259     )
2260         internal
2261         view
2262         returns (TradeInfo memory)
2263     {
2264         TradeInfo memory tradeInfo;
2265 
2266         tradeInfo.setToken = _setToken;
2267 
2268         tradeInfo.exchangeAdapter = IExchangeAdapter(getAndValidateAdapter(_exchangeName));
2269 
2270         tradeInfo.sendToken = _sendToken;
2271         tradeInfo.receiveToken = _receiveToken;
2272 
2273         tradeInfo.setTotalSupply = _setToken.totalSupply();
2274 
2275         tradeInfo.totalSendQuantity = Position.getDefaultTotalNotional(tradeInfo.setTotalSupply, _sendQuantity);
2276 
2277         tradeInfo.totalMinReceiveQuantity = Position.getDefaultTotalNotional(tradeInfo.setTotalSupply, _minReceiveQuantity);
2278 
2279         tradeInfo.preTradeSendTokenBalance = IERC20(_sendToken).balanceOf(address(_setToken));
2280         tradeInfo.preTradeReceiveTokenBalance = IERC20(_receiveToken).balanceOf(address(_setToken));
2281 
2282         return tradeInfo;
2283     }
2284 
2285     /**
2286      * Validate pre trade data. Check exchange is valid, token quantity is valid.
2287      *
2288      * @param _tradeInfo            Struct containing trade information used in internal functions
2289      * @param _sendQuantity         Units of token in SetToken sent to the exchange
2290      */
2291     function _validatePreTradeData(TradeInfo memory _tradeInfo, uint256 _sendQuantity) internal view {
2292         require(_tradeInfo.totalSendQuantity > 0, "Token to sell must be nonzero");
2293 
2294         require(
2295             _tradeInfo.setToken.hasSufficientDefaultUnits(_tradeInfo.sendToken, _sendQuantity),
2296             "Unit cant be greater than existing"
2297         );
2298     }
2299 
2300     /**
2301      * Invoke approve for send token, get method data and invoke trade in the context of the SetToken.
2302      *
2303      * @param _tradeInfo            Struct containing trade information used in internal functions
2304      * @param _data                 Arbitrary bytes to be used to construct trade call data
2305      */
2306     function _executeTrade(
2307         TradeInfo memory _tradeInfo,
2308         bytes memory _data
2309     )
2310         internal
2311     {
2312         // Get spender address from exchange adapter and invoke approve for exact amount on SetToken
2313         _tradeInfo.setToken.invokeApprove(
2314             _tradeInfo.sendToken,
2315             _tradeInfo.exchangeAdapter.getSpender(),
2316             _tradeInfo.totalSendQuantity
2317         );
2318 
2319         (
2320             address targetExchange,
2321             uint256 callValue,
2322             bytes memory methodData
2323         ) = _tradeInfo.exchangeAdapter.getTradeCalldata(
2324             _tradeInfo.sendToken,
2325             _tradeInfo.receiveToken,
2326             address(_tradeInfo.setToken),
2327             _tradeInfo.totalSendQuantity,
2328             _tradeInfo.totalMinReceiveQuantity,
2329             _data
2330         );
2331 
2332         _tradeInfo.setToken.invoke(targetExchange, callValue, methodData);
2333     }
2334 
2335     /**
2336      * Validate post trade data.
2337      *
2338      * @param _tradeInfo                Struct containing trade information used in internal functions
2339      * @return uint256                  Total quantity of receive token that was exchanged
2340      */
2341     function _validatePostTrade(TradeInfo memory _tradeInfo) internal view returns (uint256) {
2342         uint256 exchangedQuantity = IERC20(_tradeInfo.receiveToken)
2343             .balanceOf(address(_tradeInfo.setToken))
2344             .sub(_tradeInfo.preTradeReceiveTokenBalance);
2345 
2346         require(
2347             exchangedQuantity >= _tradeInfo.totalMinReceiveQuantity,
2348             "Slippage greater than allowed"
2349         );
2350 
2351         return exchangedQuantity;
2352     }
2353 
2354     /**
2355      * Retrieve fee from controller and calculate total protocol fee and send from SetToken to protocol recipient
2356      *
2357      * @param _tradeInfo                Struct containing trade information used in internal functions
2358      * @return uint256                  Amount of receive token taken as protocol fee
2359      */
2360     function _accrueProtocolFee(TradeInfo memory _tradeInfo, uint256 _exchangedQuantity) internal returns (uint256) {
2361         uint256 protocolFeeTotal = getModuleFee(TRADE_MODULE_PROTOCOL_FEE_INDEX, _exchangedQuantity);
2362         
2363         payProtocolFeeFromSetToken(_tradeInfo.setToken, _tradeInfo.receiveToken, protocolFeeTotal);
2364         
2365         return protocolFeeTotal;
2366     }
2367 
2368     /**
2369      * Update SetToken positions
2370      *
2371      * @param _tradeInfo                Struct containing trade information used in internal functions
2372      * @return uint256                  Amount of sendTokens used in the trade
2373      * @return uint256                  Amount of receiveTokens received in the trade (net of fees)
2374      */
2375     function _updateSetTokenPositions(TradeInfo memory _tradeInfo) internal returns (uint256, uint256) {
2376         (uint256 currentSendTokenBalance,,) = _tradeInfo.setToken.calculateAndEditDefaultPosition(
2377             _tradeInfo.sendToken,
2378             _tradeInfo.setTotalSupply,
2379             _tradeInfo.preTradeSendTokenBalance
2380         );
2381 
2382         (uint256 currentReceiveTokenBalance,,) = _tradeInfo.setToken.calculateAndEditDefaultPosition(
2383             _tradeInfo.receiveToken,
2384             _tradeInfo.setTotalSupply,
2385             _tradeInfo.preTradeReceiveTokenBalance
2386         );
2387 
2388         return (
2389             _tradeInfo.preTradeSendTokenBalance.sub(currentSendTokenBalance),
2390             currentReceiveTokenBalance.sub(_tradeInfo.preTradeReceiveTokenBalance)
2391         );
2392     }
2393 }