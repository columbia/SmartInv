1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-08
3 */
4 
5 // Dependency file: @openzeppelin/contracts/utils/Address.sol
6 
7 
8 
9 // pragma solidity ^0.6.2;
10 
11 /**
12  * @dev Collection of functions related to the address type
13  */
14 library Address {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [// importANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      */
32     function isContract(address account) internal view returns (bool) {
33         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
34         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
35         // for accounts without code, i.e. `keccak256('')`
36         bytes32 codehash;
37         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
38         // solhint-disable-next-line no-inline-assembly
39         assembly { codehash := extcodehash(account) }
40         return (codehash != accountHash && codehash != 0x0);
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * // importANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
63         (bool success, ) = recipient.call{ value: amount }("");
64         require(success, "Address: unable to send value, recipient may have reverted");
65     }
66 
67     /**
68      * @dev Performs a Solidity function call using a low level `call`. A
69      * plain`call` is an unsafe replacement for a function call: use this
70      * function instead.
71      *
72      * If `target` reverts with a revert reason, it is bubbled up by this
73      * function (like regular Solidity function calls).
74      *
75      * Returns the raw returned data. To convert to the expected return value,
76      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
77      *
78      * Requirements:
79      *
80      * - `target` must be a contract.
81      * - calling `target` with `data` must not revert.
82      *
83      * _Available since v3.1._
84      */
85     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
86       return functionCall(target, data, "Address: low-level call failed");
87     }
88 
89     /**
90      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
91      * `errorMessage` as a fallback revert reason when `target` reverts.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
96         return _functionCallWithValue(target, data, 0, errorMessage);
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
101      * but also transferring `value` wei to `target`.
102      *
103      * Requirements:
104      *
105      * - the calling contract must have an ETH balance of at least `value`.
106      * - the called Solidity function must be `payable`.
107      *
108      * _Available since v3.1._
109      */
110     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
116      * with `errorMessage` as a fallback revert reason when `target` reverts.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
121         require(address(this).balance >= value, "Address: insufficient balance for call");
122         return _functionCallWithValue(target, data, value, errorMessage);
123     }
124 
125     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
126         require(isContract(target), "Address: call to non-contract");
127 
128         // solhint-disable-next-line avoid-low-level-calls
129         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
130         if (success) {
131             return returndata;
132         } else {
133             // Look for revert reason and bubble it up if present
134             if (returndata.length > 0) {
135                 // The easiest way to bubble the revert reason is using memory via assembly
136 
137                 // solhint-disable-next-line no-inline-assembly
138                 assembly {
139                     let returndata_size := mload(returndata)
140                     revert(add(32, returndata), returndata_size)
141                 }
142             } else {
143                 revert(errorMessage);
144             }
145         }
146     }
147 }
148 
149 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
150 
151 
152 
153 // pragma solidity ^0.6.0;
154 
155 // import "./IERC20.sol";
156 // import "../../math/SafeMath.sol";
157 // import "../../utils/Address.sol";
158 
159 /**
160  * @title SafeERC20
161  * @dev Wrappers around ERC20 operations that throw on failure (when the token
162  * contract returns false). Tokens that return no value (and instead revert or
163  * throw on failure) are also supported, non-reverting calls are assumed to be
164  * successful.
165  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
166  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
167  */
168 library SafeERC20 {
169     using SafeMath for uint256;
170     using Address for address;
171 
172     function safeTransfer(IERC20 token, address to, uint256 value) internal {
173         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
174     }
175 
176     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
177         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
178     }
179 
180     /**
181      * @dev Deprecated. This function has issues similar to the ones found in
182      * {IERC20-approve}, and its usage is discouraged.
183      *
184      * Whenever possible, use {safeIncreaseAllowance} and
185      * {safeDecreaseAllowance} instead.
186      */
187     function safeApprove(IERC20 token, address spender, uint256 value) internal {
188         // safeApprove should only be called when setting an initial allowance,
189         // or when resetting it to zero. To increase and decrease it, use
190         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
191         // solhint-disable-next-line max-line-length
192         require((value == 0) || (token.allowance(address(this), spender) == 0),
193             "SafeERC20: approve from non-zero to non-zero allowance"
194         );
195         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
196     }
197 
198     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
199         uint256 newAllowance = token.allowance(address(this), spender).add(value);
200         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
201     }
202 
203     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
204         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
205         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
206     }
207 
208     /**
209      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
210      * on the return value: the return value is optional (but if data is returned, it must not be false).
211      * @param token The token targeted by the call.
212      * @param data The call data (encoded using abi.encode or one of its variants).
213      */
214     function _callOptionalReturn(IERC20 token, bytes memory data) private {
215         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
216         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
217         // the target address contains contract code and also asserts for success in the low-level call.
218 
219         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
220         if (returndata.length > 0) { // Return data is optional
221             // solhint-disable-next-line max-line-length
222             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
223         }
224     }
225 }
226 
227 // Dependency file: @openzeppelin/contracts/math/SignedSafeMath.sol
228 
229 
230 
231 // pragma solidity ^0.6.0;
232 
233 /**
234  * @title SignedSafeMath
235  * @dev Signed math operations with safety checks that revert on error.
236  */
237 library SignedSafeMath {
238     int256 constant private _INT256_MIN = -2**255;
239 
240         /**
241      * @dev Returns the multiplication of two signed integers, reverting on
242      * overflow.
243      *
244      * Counterpart to Solidity's `*` operator.
245      *
246      * Requirements:
247      *
248      * - Multiplication cannot overflow.
249      */
250     function mul(int256 a, int256 b) internal pure returns (int256) {
251         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
252         // benefit is lost if 'b' is also tested.
253         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
254         if (a == 0) {
255             return 0;
256         }
257 
258         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
259 
260         int256 c = a * b;
261         require(c / a == b, "SignedSafeMath: multiplication overflow");
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the integer division of two signed integers. Reverts on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(int256 a, int256 b) internal pure returns (int256) {
279         require(b != 0, "SignedSafeMath: division by zero");
280         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
281 
282         int256 c = a / b;
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the subtraction of two signed integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `-` operator.
292      *
293      * Requirements:
294      *
295      * - Subtraction cannot overflow.
296      */
297     function sub(int256 a, int256 b) internal pure returns (int256) {
298         int256 c = a - b;
299         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
300 
301         return c;
302     }
303 
304     /**
305      * @dev Returns the addition of two signed integers, reverting on
306      * overflow.
307      *
308      * Counterpart to Solidity's `+` operator.
309      *
310      * Requirements:
311      *
312      * - Addition cannot overflow.
313      */
314     function add(int256 a, int256 b) internal pure returns (int256) {
315         int256 c = a + b;
316         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
317 
318         return c;
319     }
320 }
321 
322 // Dependency file: contracts/interfaces/IModule.sol
323 
324 /*
325     Copyright 2020 Set Labs Inc.
326 
327     Licensed under the Apache License, Version 2.0 (the "License");
328     you may not use this file except in compliance with the License.
329     You may obtain a copy of the License at
330 
331     http://www.apache.org/licenses/LICENSE-2.0
332 
333     Unless required by applicable law or agreed to in writing, software
334     distributed under the License is distributed on an "AS IS" BASIS,
335     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
336     See the License for the specific language governing permissions and
337     limitations under the License.
338 
339 
340 */
341 // pragma solidity 0.6.10;
342 
343 
344 /**
345  * @title IModule
346  * @author Set Protocol
347  *
348  * Interface for interacting with Modules.
349  */
350 interface IModule {
351     /**
352      * Called by a SetToken to notify that this module was removed from the Set token. Any logic can be included
353      * in case checks need to be made or state needs to be cleared.
354      */
355     function removeModule() external;
356 }
357 // Dependency file: contracts/lib/ExplicitERC20.sol
358 
359 /*
360     Copyright 2020 Set Labs Inc.
361 
362     Licensed under the Apache License, Version 2.0 (the "License");
363     you may not use this file except in compliance with the License.
364     You may obtain a copy of the License at
365 
366     http://www.apache.org/licenses/LICENSE-2.0
367 
368     Unless required by applicable law or agreed to in writing, software
369     distributed under the License is distributed on an "AS IS" BASIS,
370     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
371     See the License for the specific language governing permissions and
372     limitations under the License.
373 
374 
375 */
376 
377 // pragma solidity 0.6.10;
378 
379 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
380 // import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
381 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
382 
383 /**
384  * @title ExplicitERC20
385  * @author Set Protocol
386  *
387  * Utility functions for ERC20 transfers that require the explicit amount to be transferred.
388  */
389 library ExplicitERC20 {
390     using SafeMath for uint256;
391 
392     /**
393      * When given allowance, transfers a token from the "_from" to the "_to" of quantity "_quantity".
394      * Ensures that the recipient has received the correct quantity (ie no fees taken on transfer)
395      *
396      * @param _token           ERC20 token to approve
397      * @param _from            The account to transfer tokens from
398      * @param _to              The account to transfer tokens to
399      * @param _quantity        The quantity to transfer
400      */
401     function transferFrom(
402         IERC20 _token,
403         address _from,
404         address _to,
405         uint256 _quantity
406     )
407         internal
408     {
409         // Call specified ERC20 contract to transfer tokens (via proxy).
410         if (_quantity > 0) {
411             uint256 existingBalance = _token.balanceOf(_to);
412 
413             SafeERC20.safeTransferFrom(
414                 _token,
415                 _from,
416                 _to,
417                 _quantity
418             );
419 
420             uint256 newBalance = _token.balanceOf(_to);
421 
422             // Verify transfer quantity is reflected in balance
423             require(
424                 newBalance == existingBalance.add(_quantity),
425                 "Invalid post transfer balance"
426             );
427         }
428     }
429 }
430 
431 // Dependency file: contracts/lib/PreciseUnitMath.sol
432 
433 /*
434     Copyright 2020 Set Labs Inc.
435 
436     Licensed under the Apache License, Version 2.0 (the "License");
437     you may not use this file except in compliance with the License.
438     You may obtain a copy of the License at
439 
440     http://www.apache.org/licenses/LICENSE-2.0
441 
442     Unless required by applicable law or agreed to in writing, software
443     distributed under the License is distributed on an "AS IS" BASIS,
444     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
445     See the License for the specific language governing permissions and
446     limitations under the License.
447 
448 
449 */
450 
451 // pragma solidity 0.6.10;
452 // pragma experimental ABIEncoderV2;
453 
454 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
455 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
456 
457 
458 /**
459  * @title PreciseUnitMath
460  * @author Set Protocol
461  *
462  * Arithmetic for fixed-point numbers with 18 decimals of precision. Some functions taken from
463  * dYdX's BaseMath library.
464  */
465 library PreciseUnitMath {
466     using SafeMath for uint256;
467     using SignedSafeMath for int256;
468 
469     // The number One in precise units.
470     uint256 constant internal PRECISE_UNIT = 10 ** 18;
471     int256 constant internal PRECISE_UNIT_INT = 10 ** 18;
472 
473     // Max unsigned integer value
474     uint256 constant internal MAX_UINT_256 = type(uint256).max;
475     // Max and min signed integer value
476     int256 constant internal MAX_INT_256 = type(int256).max;
477     int256 constant internal MIN_INT_256 = type(int256).min;
478 
479     /**
480      * @dev Getter function since constants can't be read directly from libraries.
481      */
482     function preciseUnit() internal pure returns (uint256) {
483         return PRECISE_UNIT;
484     }
485 
486     /**
487      * @dev Getter function since constants can't be read directly from libraries.
488      */
489     function preciseUnitInt() internal pure returns (int256) {
490         return PRECISE_UNIT_INT;
491     }
492 
493     /**
494      * @dev Getter function since constants can't be read directly from libraries.
495      */
496     function maxUint256() internal pure returns (uint256) {
497         return MAX_UINT_256;
498     }
499 
500     /**
501      * @dev Getter function since constants can't be read directly from libraries.
502      */
503     function maxInt256() internal pure returns (int256) {
504         return MAX_INT_256;
505     }
506 
507     /**
508      * @dev Getter function since constants can't be read directly from libraries.
509      */
510     function minInt256() internal pure returns (int256) {
511         return MIN_INT_256;
512     }
513 
514     /**
515      * @dev Multiplies value a by value b (result is rounded down). It's assumed that the value b is the significand
516      * of a number with 18 decimals precision.
517      */
518     function preciseMul(uint256 a, uint256 b) internal pure returns (uint256) {
519         return a.mul(b).div(PRECISE_UNIT);
520     }
521 
522     /**
523      * @dev Multiplies value a by value b (result is rounded towards zero). It's assumed that the value b is the
524      * significand of a number with 18 decimals precision.
525      */
526     function preciseMul(int256 a, int256 b) internal pure returns (int256) {
527         return a.mul(b).div(PRECISE_UNIT_INT);
528     }
529 
530     /**
531      * @dev Multiplies value a by value b (result is rounded up). It's assumed that the value b is the significand
532      * of a number with 18 decimals precision.
533      */
534     function preciseMulCeil(uint256 a, uint256 b) internal pure returns (uint256) {
535         if (a == 0 || b == 0) {
536             return 0;
537         }
538         return a.mul(b).sub(1).div(PRECISE_UNIT).add(1);
539     }
540 
541     /**
542      * @dev Divides value a by value b (result is rounded down).
543      */
544     function preciseDiv(uint256 a, uint256 b) internal pure returns (uint256) {
545         return a.mul(PRECISE_UNIT).div(b);
546     }
547 
548 
549     /**
550      * @dev Divides value a by value b (result is rounded towards 0).
551      */
552     function preciseDiv(int256 a, int256 b) internal pure returns (int256) {
553         return a.mul(PRECISE_UNIT_INT).div(b);
554     }
555 
556     /**
557      * @dev Divides value a by value b (result is rounded up or away from 0).
558      */
559     function preciseDivCeil(uint256 a, uint256 b) internal pure returns (uint256) {
560         require(b != 0, "Cant divide by 0");
561 
562         return a > 0 ? a.mul(PRECISE_UNIT).sub(1).div(b).add(1) : 0;
563     }
564 
565     /**
566      * @dev Divides value a by value b (result is rounded down - positive numbers toward 0 and negative away from 0).
567      */
568     function divDown(int256 a, int256 b) internal pure returns (int256) {
569         require(b != 0, "Cant divide by 0");
570         require(a != MIN_INT_256 || b != -1, "Invalid input");
571 
572         int256 result = a.div(b);
573         if (a ^ b < 0 && a % b != 0) {
574             result = result.sub(1);
575         }
576 
577         return result;
578     }
579 
580     /**
581      * @dev Multiplies value a by value b where rounding is towards the lesser number. 
582      * (positive values are rounded towards zero and negative values are rounded away from 0). 
583      */
584     function conservativePreciseMul(int256 a, int256 b) internal pure returns (int256) {
585         return divDown(a.mul(b), PRECISE_UNIT_INT);
586     }
587 
588     /**
589      * @dev Divides value a by value b where rounding is towards the lesser number. 
590      * (positive values are rounded towards zero and negative values are rounded away from 0). 
591      */
592     function conservativePreciseDiv(int256 a, int256 b) internal pure returns (int256) {
593         return divDown(a.mul(PRECISE_UNIT_INT), b);
594     }
595 }
596 // Dependency file: contracts/protocol/lib/Position.sol
597 
598 /*
599     Copyright 2020 Set Labs Inc.
600 
601     Licensed under the Apache License, Version 2.0 (the "License");
602     you may not use this file except in compliance with the License.
603     You may obtain a copy of the License at
604 
605     http://www.apache.org/licenses/LICENSE-2.0
606 
607     Unless required by applicable law or agreed to in writing, software
608     distributed under the License is distributed on an "AS IS" BASIS,
609     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
610     See the License for the specific language governing permissions and
611     limitations under the License.
612 
613 
614 */
615 
616 // pragma solidity 0.6.10;
617 // pragma experimental "ABIEncoderV2";
618 
619 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
620 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
621 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
622 
623 // import { ISetToken } from "../../interfaces/ISetToken.sol";
624 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
625 
626 /**
627  * @title Position
628  * @author Set Protocol
629  *
630  * Collection of helper functions for handling and updating SetToken Positions
631  */
632 library Position {
633     using SafeCast for uint256;
634     using SafeMath for uint256;
635     using SafeCast for int256;
636     using SignedSafeMath for int256;
637     using PreciseUnitMath for uint256;
638 
639     /* ============ Helper ============ */
640 
641     /**
642      * Returns whether the SetToken has a default position for a given component (if the real unit is > 0)
643      */
644     function hasDefaultPosition(ISetToken _setToken, address _component) internal view returns(bool) {
645         return _setToken.getDefaultPositionRealUnit(_component) > 0;
646     }
647 
648     /**
649      * Returns whether the SetToken has an external position for a given component (if # of position modules is > 0)
650      */
651     function hasExternalPosition(ISetToken _setToken, address _component) internal view returns(bool) {
652         return _setToken.getExternalPositionModules(_component).length > 0;
653     }
654     
655     /**
656      * Returns whether the SetToken component default position real unit is greater than or equal to units passed in.
657      */
658     function hasSufficientDefaultUnits(ISetToken _setToken, address _component, uint256 _unit) internal view returns(bool) {
659         return _setToken.getDefaultPositionRealUnit(_component) >= _unit.toInt256();
660     }
661 
662     /**
663      * Returns whether the SetToken component external position is greater than or equal to the real units passed in.
664      */
665     function hasSufficientExternalUnits(
666         ISetToken _setToken,
667         address _component,
668         address _positionModule,
669         uint256 _unit
670     )
671         internal
672         view
673         returns(bool)
674     {
675        return _setToken.getExternalPositionRealUnit(_component, _positionModule) >= _unit.toInt256();    
676     }
677 
678     /**
679      * If the position does not exist, create a new Position and add to the SetToken. If it already exists,
680      * then set the position units. If the new units is 0, remove the position. Handles adding/removing of 
681      * components where needed (in light of potential external positions).
682      *
683      * @param _setToken           Address of SetToken being modified
684      * @param _component          Address of the component
685      * @param _newUnit            Quantity of Position units - must be >= 0
686      */
687     function editDefaultPosition(ISetToken _setToken, address _component, uint256 _newUnit) internal {
688         bool isPositionFound = hasDefaultPosition(_setToken, _component);
689         if (!isPositionFound && _newUnit > 0) {
690             // If there is no Default Position and no External Modules, then component does not exist
691             if (!hasExternalPosition(_setToken, _component)) {
692                 _setToken.addComponent(_component);
693             }
694         } else if (isPositionFound && _newUnit == 0) {
695             // If there is a Default Position and no external positions, remove the component
696             if (!hasExternalPosition(_setToken, _component)) {
697                 _setToken.removeComponent(_component);
698             }
699         }
700 
701         _setToken.editDefaultPositionUnit(_component, _newUnit.toInt256());
702     }
703 
704     /**
705      * Update an external position and remove and external positions or components if necessary. The logic flows as follows:
706      * 1) If component is not already added then add component and external position. 
707      * 2) If component is added but no existing external position using the passed module exists then add the external position.
708      * 3) If the existing position is being added to then just update the unit
709      * 4) If the position is being closed and no other external positions or default positions are associated with the component
710      *    then untrack the component and remove external position.
711      * 5) If the position is being closed and  other existing positions still exist for the component then just remove the
712      *    external position.
713      *
714      * @param _setToken         SetToken being updated
715      * @param _component        Component position being updated
716      * @param _module           Module external position is associated with
717      * @param _newUnit          Position units of new external position
718      * @param _data             Arbitrary data associated with the position
719      */
720     function editExternalPosition(
721         ISetToken _setToken,
722         address _component,
723         address _module,
724         int256 _newUnit,
725         bytes memory _data
726     )
727         internal
728     {
729         if (!_setToken.isComponent(_component)) {
730             _setToken.addComponent(_component);
731             addExternalPosition(_setToken, _component, _module, _newUnit, _data);
732         } else if (!_setToken.isExternalPositionModule(_component, _module)) {
733             addExternalPosition(_setToken, _component, _module, _newUnit, _data);
734         } else if (_newUnit != 0) {
735             _setToken.editExternalPositionUnit(_component, _module, _newUnit);
736         } else {
737             // If no default or external position remaining then remove component from components array
738             if (_setToken.getDefaultPositionRealUnit(_component) == 0 && _setToken.getExternalPositionModules(_component).length == 1) {
739                 _setToken.removeComponent(_component);
740             }
741             _setToken.removeExternalPositionModule(_component, _module);
742         }
743     }
744 
745     /**
746      * Add a new external position from a previously untracked module.
747      *
748      * @param _setToken         SetToken being updated
749      * @param _component        Component position being updated
750      * @param _module           Module external position is associated with
751      * @param _newUnit          Position units of new external position
752      * @param _data             Arbitrary data associated with the position
753      */
754     function addExternalPosition(
755         ISetToken _setToken,
756         address _component,
757         address _module,
758         int256 _newUnit,
759         bytes memory _data
760     )
761         internal
762     {
763         _setToken.addExternalPositionModule(_component, _module);
764         _setToken.editExternalPositionUnit(_component, _module, _newUnit);
765         _setToken.editExternalPositionData(_component, _module, _data);
766     }
767 
768     /**
769      * Get total notional amount of Default position
770      *
771      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
772      * @param _positionUnit       Quantity of Position units
773      *
774      * @return                    Total notional amount of units
775      */
776     function getDefaultTotalNotional(uint256 _setTokenSupply, uint256 _positionUnit) internal pure returns (uint256) {
777         return _setTokenSupply.preciseMul(_positionUnit);
778     }
779 
780     /**
781      * Get position unit from total notional amount
782      *
783      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
784      * @param _totalNotional      Total notional amount of component prior to
785      * @return                    Default position unit
786      */
787     function getDefaultPositionUnit(uint256 _setTokenSupply, uint256 _totalNotional) internal pure returns (uint256) {
788         return _totalNotional.preciseDiv(_setTokenSupply);
789     }
790 
791     /**
792      * Calculate the new position unit given total notional values pre and post executing an action that changes SetToken state
793      * The intention is to make updates to the units without accidentally picking up airdropped assets as well.
794      *
795      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
796      * @param _preTotalNotional   Total notional amount of component prior to executing action
797      * @param _postTotalNotional  Total notional amount of component after the executing action
798      * @param _prePositionUnit    Position unit of SetToken prior to executing action
799      * @return                    New position unit
800      */
801     function calculateDefaultEditPositionUnit(
802         uint256 _setTokenSupply,
803         uint256 _preTotalNotional,
804         uint256 _postTotalNotional,
805         uint256 _prePositionUnit
806     )
807         internal
808         pure
809         returns (uint256)
810     {
811         // If pre action total notional amount is greater then subtract post action total notional and calculate new position units
812         if (_preTotalNotional >= _postTotalNotional) {
813             uint256 unitsToSub = _preTotalNotional.sub(_postTotalNotional).preciseDivCeil(_setTokenSupply);
814             return _prePositionUnit.sub(unitsToSub);
815         } else {
816             // Else subtract post action total notional from pre action total notional and calculate new position units
817             uint256 unitsToAdd = _postTotalNotional.sub(_preTotalNotional).preciseDiv(_setTokenSupply);
818             return _prePositionUnit.add(unitsToAdd);
819         }
820     }
821 }
822 
823 // Dependency file: contracts/protocol/lib/ModuleBase.sol
824 
825 /*
826     Copyright 2020 Set Labs Inc.
827 
828     Licensed under the Apache License, Version 2.0 (the "License");
829     you may not use this file except in compliance with the License.
830     You may obtain a copy of the License at
831 
832     http://www.apache.org/licenses/LICENSE-2.0
833 
834     Unless required by applicable law or agreed to in writing, software
835     distributed under the License is distributed on an "AS IS" BASIS,
836     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
837     See the License for the specific language governing permissions and
838     limitations under the License.
839 
840 
841 */
842 
843 // pragma solidity 0.6.10;
844 
845 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
846 
847 // import { ExplicitERC20 } from "../../lib/ExplicitERC20.sol";
848 // import { IController } from "../../interfaces/IController.sol";
849 // import { IModule } from "../../interfaces/IModule.sol";
850 // import { ISetToken } from "../../interfaces/ISetToken.sol";
851 
852 /**
853  * @title ModuleBase
854  * @author Set Protocol
855  *
856  * Abstract class that houses common Module-related state and functions.
857  */
858 abstract contract ModuleBase is IModule {
859 
860     /* ============ State Variables ============ */
861 
862     // Address of the controller
863     IController public controller;
864 
865     /* ============ Modifiers ============ */
866 
867     modifier onlySetManager(ISetToken _setToken, address _caller) {
868         require(isSetManager(_setToken, _caller), "Must be the SetToken manager");
869         _;
870     }
871 
872     modifier onlyValidAndInitializedSet(ISetToken _setToken) {
873         require(isSetValidAndInitialized(_setToken), "Must be a valid and initialized SetToken");
874         _;
875     }
876 
877     /**
878      * Throws if the sender is not a SetToken's module or module not enabled
879      */
880     modifier onlyModule(ISetToken _setToken) {
881         require(
882             _setToken.moduleStates(msg.sender) == ISetToken.ModuleState.INITIALIZED,
883             "Only the module can call"
884         );
885 
886         require(
887             controller.isModule(msg.sender),
888             "Module must be enabled on controller"
889         );
890         _;
891     }
892 
893     /**
894      * Utilized during module initializations to check that the module is in pending state
895      * and that the SetToken is valid
896      */
897     modifier onlyValidAndPendingSet(ISetToken _setToken) {
898         require(controller.isSet(address(_setToken)), "Must be controller-enabled SetToken");
899         require(isSetPendingInitialization(_setToken), "Must be pending initialization");        
900         _;
901     }
902 
903     /* ============ Constructor ============ */
904 
905     /**
906      * Set state variables and map asset pairs to their oracles
907      *
908      * @param _controller             Address of controller contract
909      */
910     constructor(IController _controller) public {
911         controller = _controller;
912     }
913 
914     /* ============ Internal Functions ============ */
915 
916     /**
917      * Transfers tokens from an address (that has set allowance on the module).
918      *
919      * @param  _token          The address of the ERC20 token
920      * @param  _from           The address to transfer from
921      * @param  _to             The address to transfer to
922      * @param  _quantity       The number of tokens to transfer
923      */
924     function transferFrom(IERC20 _token, address _from, address _to, uint256 _quantity) internal {
925         ExplicitERC20.transferFrom(_token, _from, _to, _quantity);
926     }
927 
928     /**
929      * Returns true if the module is in process of initialization on the SetToken
930      */
931     function isSetPendingInitialization(ISetToken _setToken) internal view returns(bool) {
932         return _setToken.isPendingModule(address(this));
933     }
934 
935     /**
936      * Returns true if the address is the SetToken's manager
937      */
938     function isSetManager(ISetToken _setToken, address _toCheck) internal view returns(bool) {
939         return _setToken.manager() == _toCheck;
940     }
941 
942     /**
943      * Returns true if SetToken must be enabled on the controller 
944      * and module is registered on the SetToken
945      */
946     function isSetValidAndInitialized(ISetToken _setToken) internal view returns(bool) {
947         return controller.isSet(address(_setToken)) &&
948             _setToken.isInitializedModule(address(this));
949     }
950 }
951 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
952 
953 
954 
955 // pragma solidity ^0.6.0;
956 
957 /**
958  * @dev Interface of the ERC20 standard as defined in the EIP.
959  */
960 interface IERC20 {
961     /**
962      * @dev Returns the amount of tokens in existence.
963      */
964     function totalSupply() external view returns (uint256);
965 
966     /**
967      * @dev Returns the amount of tokens owned by `account`.
968      */
969     function balanceOf(address account) external view returns (uint256);
970 
971     /**
972      * @dev Moves `amount` tokens from the caller's account to `recipient`.
973      *
974      * Returns a boolean value indicating whether the operation succeeded.
975      *
976      * Emits a {Transfer} event.
977      */
978     function transfer(address recipient, uint256 amount) external returns (bool);
979 
980     /**
981      * @dev Returns the remaining number of tokens that `spender` will be
982      * allowed to spend on behalf of `owner` through {transferFrom}. This is
983      * zero by default.
984      *
985      * This value changes when {approve} or {transferFrom} are called.
986      */
987     function allowance(address owner, address spender) external view returns (uint256);
988 
989     /**
990      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
991      *
992      * Returns a boolean value indicating whether the operation succeeded.
993      *
994      * // importANT: Beware that changing an allowance with this method brings the risk
995      * that someone may use both the old and the new allowance by unfortunate
996      * transaction ordering. One possible solution to mitigate this race
997      * condition is to first reduce the spender's allowance to 0 and set the
998      * desired value afterwards:
999      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1000      *
1001      * Emits an {Approval} event.
1002      */
1003     function approve(address spender, uint256 amount) external returns (bool);
1004 
1005     /**
1006      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1007      * allowance mechanism. `amount` is then deducted from the caller's
1008      * allowance.
1009      *
1010      * Returns a boolean value indicating whether the operation succeeded.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1015 
1016     /**
1017      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1018      * another (`to`).
1019      *
1020      * Note that `value` may be zero.
1021      */
1022     event Transfer(address indexed from, address indexed to, uint256 value);
1023 
1024     /**
1025      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1026      * a call to {approve}. `value` is the new allowance.
1027      */
1028     event Approval(address indexed owner, address indexed spender, uint256 value);
1029 }
1030 
1031 // Dependency file: contracts/interfaces/ISetToken.sol
1032 
1033 /*
1034     Copyright 2020 Set Labs Inc.
1035 
1036     Licensed under the Apache License, Version 2.0 (the "License");
1037     you may not use this file except in compliance with the License.
1038     You may obtain a copy of the License at
1039 
1040     http://www.apache.org/licenses/LICENSE-2.0
1041 
1042     Unless required by applicable law or agreed to in writing, software
1043     distributed under the License is distributed on an "AS IS" BASIS,
1044     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1045     See the License for the specific language governing permissions and
1046     limitations under the License.
1047 
1048 
1049 */
1050 // pragma solidity 0.6.10;
1051 // pragma experimental "ABIEncoderV2";
1052 
1053 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1054 
1055 /**
1056  * @title ISetToken
1057  * @author Set Protocol
1058  *
1059  * Interface for operating with SetTokens.
1060  */
1061 interface ISetToken is IERC20 {
1062 
1063     /* ============ Enums ============ */
1064 
1065     enum ModuleState {
1066         NONE,
1067         PENDING,
1068         INITIALIZED
1069     }
1070 
1071     /* ============ Structs ============ */
1072     /**
1073      * The base definition of a SetToken Position
1074      *
1075      * @param component           Address of token in the Position
1076      * @param module              If not in default state, the address of associated module
1077      * @param unit                Each unit is the # of components per 10^18 of a SetToken
1078      * @param positionState       Position ENUM. Default is 0; External is 1
1079      * @param data                Arbitrary data
1080      */
1081     struct Position {
1082         address component;
1083         address module;
1084         int256 unit;
1085         uint8 positionState;
1086         bytes data;
1087     }
1088 
1089     /**
1090      * A struct that stores a component's cash position details and external positions
1091      * This data structure allows O(1) access to a component's cash position units and 
1092      * virtual units.
1093      *
1094      * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
1095      *                                  updating all units at once via the position multiplier. Virtual units are achieved
1096      *                                  by dividing a "real" value by the "positionMultiplier"
1097      * @param componentIndex            
1098      * @param externalPositionModules   List of external modules attached to each external position. Each module
1099      *                                  maps to an external position
1100      * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
1101      */
1102     struct ComponentPosition {
1103       int256 virtualUnit;
1104       address[] externalPositionModules;
1105       mapping(address => ExternalPosition) externalPositions;
1106     }
1107 
1108     /**
1109      * A struct that stores a component's external position details including virtual unit and any
1110      * auxiliary data.
1111      *
1112      * @param virtualUnit       Virtual value of a component's EXTERNAL position.
1113      * @param data              Arbitrary data
1114      */
1115     struct ExternalPosition {
1116       int256 virtualUnit;
1117       bytes data;
1118     }
1119 
1120 
1121     /* ============ Functions ============ */
1122     
1123     function addComponent(address _component) external;
1124     function removeComponent(address _component) external;
1125     function editDefaultPositionUnit(address _component, int256 _realUnit) external;
1126     function addExternalPositionModule(address _component, address _positionModule) external;
1127     function removeExternalPositionModule(address _component, address _positionModule) external;
1128     function editExternalPositionUnit(address _component, address _positionModule, int256 _realUnit) external;
1129     function editExternalPositionData(address _component, address _positionModule, bytes calldata _data) external;
1130 
1131     function invoke(address _target, uint256 _value, bytes calldata _data) external returns(bytes memory);
1132 
1133     function editPositionMultiplier(int256 _newMultiplier) external;
1134 
1135     function mint(address _account, uint256 _quantity) external;
1136     function burn(address _account, uint256 _quantity) external;
1137 
1138     function lock() external;
1139     function unlock() external;
1140 
1141     function addModule(address _module) external;
1142     function removeModule(address _module) external;
1143     function initializeModule() external;
1144 
1145     function setManager(address _manager) external;
1146 
1147     function manager() external view returns (address);
1148     function moduleStates(address _module) external view returns (ModuleState);
1149     function getModules() external view returns (address[] memory);
1150     
1151     function getDefaultPositionRealUnit(address _component) external view returns(int256);
1152     function getExternalPositionRealUnit(address _component, address _positionModule) external view returns(int256);
1153     function getComponents() external view returns(address[] memory);
1154     function getExternalPositionModules(address _component) external view returns(address[] memory);
1155     function getExternalPositionData(address _component, address _positionModule) external view returns(bytes memory);
1156     function isExternalPositionModule(address _component, address _module) external view returns(bool);
1157     function isComponent(address _component) external view returns(bool);
1158     
1159     function positionMultiplier() external view returns (int256);
1160     function getPositions() external view returns (Position[] memory);
1161     function getTotalComponentRealUnits(address _component) external view returns(int256);
1162 
1163     function isInitializedModule(address _module) external view returns(bool);
1164     function isPendingModule(address _module) external view returns(bool);
1165     function isLocked() external view returns (bool);
1166 }
1167 // Dependency file: contracts/protocol/lib/Invoke.sol
1168 
1169 /*
1170     Copyright 2020 Set Labs Inc.
1171 
1172     Licensed under the Apache License, Version 2.0 (the "License");
1173     you may not use this file except in compliance with the License.
1174     You may obtain a copy of the License at
1175 
1176     http://www.apache.org/licenses/LICENSE-2.0
1177 
1178     Unless required by applicable law or agreed to in writing, software
1179     distributed under the License is distributed on an "AS IS" BASIS,
1180     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1181     See the License for the specific language governing permissions and
1182     limitations under the License.
1183 
1184 
1185 */
1186 
1187 // pragma solidity 0.6.10;
1188 
1189 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1190 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1191 
1192 // import { ISetToken } from "../../interfaces/ISetToken.sol";
1193 
1194 
1195 /**
1196  * @title Invoke
1197  * @author Set Protocol
1198  *
1199  * A collection of common utility functions for interacting with the SetToken's invoke function
1200  */
1201 library Invoke {
1202     using SafeMath for uint256;
1203 
1204     /* ============ Internal ============ */
1205 
1206     /**
1207      * Instructs the SetToken to set approvals of the ERC20 token to a spender.
1208      *
1209      * @param _setToken        SetToken instance to invoke
1210      * @param _token           ERC20 token to approve
1211      * @param _spender         The account allowed to spend the SetToken's balance
1212      * @param _quantity        The quantity of allowance to allow
1213      */
1214     function invokeApprove(
1215         ISetToken _setToken,
1216         address _token,
1217         address _spender,
1218         uint256 _quantity
1219     )
1220         internal
1221     {
1222         bytes memory callData = abi.encodeWithSignature("approve(address,uint256)", _spender, _quantity);
1223         _setToken.invoke(_token, 0, callData);
1224     }
1225 
1226     /**
1227      * Instructs the SetToken to transfer the ERC20 token to a recipient.
1228      *
1229      * @param _setToken        SetToken instance to invoke
1230      * @param _token           ERC20 token to transfer
1231      * @param _to              The recipient account
1232      * @param _quantity        The quantity to transfer
1233      */
1234     function invokeTransfer(
1235         ISetToken _setToken,
1236         address _token,
1237         address _to,
1238         uint256 _quantity
1239     )
1240         internal
1241     {
1242         if (_quantity > 0) {
1243             bytes memory callData = abi.encodeWithSignature("transfer(address,uint256)", _to, _quantity);
1244             _setToken.invoke(_token, 0, callData);
1245         }
1246     }
1247 
1248     /**
1249      * Instructs the SetToken to transfer the ERC20 token to a recipient.
1250      * The new SetToken balance must equal the existing balance less the quantity transferred
1251      *
1252      * @param _setToken        SetToken instance to invoke
1253      * @param _token           ERC20 token to transfer
1254      * @param _to              The recipient account
1255      * @param _quantity        The quantity to transfer
1256      */
1257     function strictInvokeTransfer(
1258         ISetToken _setToken,
1259         address _token,
1260         address _to,
1261         uint256 _quantity
1262     )
1263         internal
1264     {
1265         if (_quantity > 0) {
1266             // Retrieve current balance of token for the SetToken
1267             uint256 existingBalance = IERC20(_token).balanceOf(address(_setToken));
1268 
1269             Invoke.invokeTransfer(_setToken, _token, _to, _quantity);
1270 
1271             // Get new balance of transferred token for SetToken
1272             uint256 newBalance = IERC20(_token).balanceOf(address(_setToken));
1273 
1274             // Verify only the transfer quantity is subtracted
1275             require(
1276                 newBalance == existingBalance.sub(_quantity),
1277                 "Invalid post transfer balance"
1278             );
1279         }
1280     }
1281 
1282     /**
1283      * Instructs the SetToken to unwrap the passed quantity of WETH
1284      *
1285      * @param _setToken        SetToken instance to invoke
1286      * @param _weth            WETH address
1287      * @param _quantity        The quantity to unwrap
1288      */
1289     function invokeUnwrapWETH(ISetToken _setToken, address _weth, uint256 _quantity) internal {
1290         bytes memory callData = abi.encodeWithSignature("withdraw(uint256)", _quantity);
1291         _setToken.invoke(_weth, 0, callData);
1292     }
1293 
1294     /**
1295      * Instructs the SetToken to wrap the passed quantity of ETH
1296      *
1297      * @param _setToken        SetToken instance to invoke
1298      * @param _weth            WETH address
1299      * @param _quantity        The quantity to unwrap
1300      */
1301     function invokeWrapWETH(ISetToken _setToken, address _weth, uint256 _quantity) internal {
1302         bytes memory callData = abi.encodeWithSignature("deposit()");
1303         _setToken.invoke(_weth, _quantity, callData);
1304     }
1305 }
1306 // Dependency file: contracts/interfaces/IManagerIssuanceHook.sol
1307 
1308 /*
1309     Copyright 2020 Set Labs Inc.
1310 
1311     Licensed under the Apache License, Version 2.0 (the "License");
1312     you may not use this file except in compliance with the License.
1313     You may obtain a copy of the License at
1314 
1315     http://www.apache.org/licenses/LICENSE-2.0
1316 
1317     Unless required by applicable law or agreed to in writing, software
1318     distributed under the License is distributed on an "AS IS" BASIS,
1319     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1320     See the License for the specific language governing permissions and
1321     limitations under the License.
1322 
1323 
1324 */
1325 // pragma solidity 0.6.10;
1326 
1327 // import { ISetToken } from "./ISetToken.sol";
1328 
1329 interface IManagerIssuanceHook {
1330     function invokePreIssueHook(ISetToken _setToken, uint256 _issueQuantity, address _sender, address _to) external;
1331 }
1332 // Dependency file: contracts/interfaces/IController.sol
1333 
1334 /*
1335     Copyright 2020 Set Labs Inc.
1336 
1337     Licensed under the Apache License, Version 2.0 (the "License");
1338     you may not use this file except in compliance with the License.
1339     You may obtain a copy of the License at
1340 
1341     http://www.apache.org/licenses/LICENSE-2.0
1342 
1343     Unless required by applicable law or agreed to in writing, software
1344     distributed under the License is distributed on an "AS IS" BASIS,
1345     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1346     See the License for the specific language governing permissions and
1347     limitations under the License.
1348 
1349 
1350 */
1351 // pragma solidity 0.6.10;
1352 
1353 interface IController {
1354     function addSet(address _setToken) external;
1355     function getModuleFee(address _module, uint256 _feeType) external view returns(uint256);
1356     function resourceId(uint256 _id) external view returns(address);
1357     function feeRecipient() external view returns(address);
1358     function isModule(address _module) external view returns(bool);
1359     function isSet(address _setToken) external view returns(bool);
1360     function isSystemContract(address _contractAddress) external view returns (bool);
1361 }
1362 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
1363 
1364 
1365 
1366 // pragma solidity ^0.6.0;
1367 
1368 /**
1369  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1370  * checks.
1371  *
1372  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1373  * in bugs, because programmers usually assume that an overflow raises an
1374  * error, which is the standard behavior in high level programming languages.
1375  * `SafeMath` restores this intuition by reverting the transaction when an
1376  * operation overflows.
1377  *
1378  * Using this library instead of the unchecked operations eliminates an entire
1379  * class of bugs, so it's recommended to use it always.
1380  */
1381 library SafeMath {
1382     /**
1383      * @dev Returns the addition of two unsigned integers, reverting on
1384      * overflow.
1385      *
1386      * Counterpart to Solidity's `+` operator.
1387      *
1388      * Requirements:
1389      *
1390      * - Addition cannot overflow.
1391      */
1392     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1393         uint256 c = a + b;
1394         require(c >= a, "SafeMath: addition overflow");
1395 
1396         return c;
1397     }
1398 
1399     /**
1400      * @dev Returns the subtraction of two unsigned integers, reverting on
1401      * overflow (when the result is negative).
1402      *
1403      * Counterpart to Solidity's `-` operator.
1404      *
1405      * Requirements:
1406      *
1407      * - Subtraction cannot overflow.
1408      */
1409     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1410         return sub(a, b, "SafeMath: subtraction overflow");
1411     }
1412 
1413     /**
1414      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1415      * overflow (when the result is negative).
1416      *
1417      * Counterpart to Solidity's `-` operator.
1418      *
1419      * Requirements:
1420      *
1421      * - Subtraction cannot overflow.
1422      */
1423     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1424         require(b <= a, errorMessage);
1425         uint256 c = a - b;
1426 
1427         return c;
1428     }
1429 
1430     /**
1431      * @dev Returns the multiplication of two unsigned integers, reverting on
1432      * overflow.
1433      *
1434      * Counterpart to Solidity's `*` operator.
1435      *
1436      * Requirements:
1437      *
1438      * - Multiplication cannot overflow.
1439      */
1440     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1441         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1442         // benefit is lost if 'b' is also tested.
1443         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1444         if (a == 0) {
1445             return 0;
1446         }
1447 
1448         uint256 c = a * b;
1449         require(c / a == b, "SafeMath: multiplication overflow");
1450 
1451         return c;
1452     }
1453 
1454     /**
1455      * @dev Returns the integer division of two unsigned integers. Reverts on
1456      * division by zero. The result is rounded towards zero.
1457      *
1458      * Counterpart to Solidity's `/` operator. Note: this function uses a
1459      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1460      * uses an invalid opcode to revert (consuming all remaining gas).
1461      *
1462      * Requirements:
1463      *
1464      * - The divisor cannot be zero.
1465      */
1466     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1467         return div(a, b, "SafeMath: division by zero");
1468     }
1469 
1470     /**
1471      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1472      * division by zero. The result is rounded towards zero.
1473      *
1474      * Counterpart to Solidity's `/` operator. Note: this function uses a
1475      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1476      * uses an invalid opcode to revert (consuming all remaining gas).
1477      *
1478      * Requirements:
1479      *
1480      * - The divisor cannot be zero.
1481      */
1482     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1483         require(b > 0, errorMessage);
1484         uint256 c = a / b;
1485         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1486 
1487         return c;
1488     }
1489 
1490     /**
1491      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1492      * Reverts when dividing by zero.
1493      *
1494      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1495      * opcode (which leaves remaining gas untouched) while Solidity uses an
1496      * invalid opcode to revert (consuming all remaining gas).
1497      *
1498      * Requirements:
1499      *
1500      * - The divisor cannot be zero.
1501      */
1502     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1503         return mod(a, b, "SafeMath: modulo by zero");
1504     }
1505 
1506     /**
1507      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1508      * Reverts with custom message when dividing by zero.
1509      *
1510      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1511      * opcode (which leaves remaining gas untouched) while Solidity uses an
1512      * invalid opcode to revert (consuming all remaining gas).
1513      *
1514      * Requirements:
1515      *
1516      * - The divisor cannot be zero.
1517      */
1518     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1519         require(b != 0, errorMessage);
1520         return a % b;
1521     }
1522 }
1523 
1524 // Dependency file: @openzeppelin/contracts/utils/SafeCast.sol
1525 
1526 
1527 
1528 // pragma solidity ^0.6.0;
1529 
1530 
1531 /**
1532  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1533  * checks.
1534  *
1535  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1536  * easily result in undesired exploitation or bugs, since developers usually
1537  * assume that overflows raise errors. `SafeCast` restores this intuition by
1538  * reverting the transaction when such an operation overflows.
1539  *
1540  * Using this library instead of the unchecked operations eliminates an entire
1541  * class of bugs, so it's recommended to use it always.
1542  *
1543  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1544  * all math on `uint256` and `int256` and then downcasting.
1545  */
1546 library SafeCast {
1547 
1548     /**
1549      * @dev Returns the downcasted uint128 from uint256, reverting on
1550      * overflow (when the input is greater than largest uint128).
1551      *
1552      * Counterpart to Solidity's `uint128` operator.
1553      *
1554      * Requirements:
1555      *
1556      * - input must fit into 128 bits
1557      */
1558     function toUint128(uint256 value) internal pure returns (uint128) {
1559         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1560         return uint128(value);
1561     }
1562 
1563     /**
1564      * @dev Returns the downcasted uint64 from uint256, reverting on
1565      * overflow (when the input is greater than largest uint64).
1566      *
1567      * Counterpart to Solidity's `uint64` operator.
1568      *
1569      * Requirements:
1570      *
1571      * - input must fit into 64 bits
1572      */
1573     function toUint64(uint256 value) internal pure returns (uint64) {
1574         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
1575         return uint64(value);
1576     }
1577 
1578     /**
1579      * @dev Returns the downcasted uint32 from uint256, reverting on
1580      * overflow (when the input is greater than largest uint32).
1581      *
1582      * Counterpart to Solidity's `uint32` operator.
1583      *
1584      * Requirements:
1585      *
1586      * - input must fit into 32 bits
1587      */
1588     function toUint32(uint256 value) internal pure returns (uint32) {
1589         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1590         return uint32(value);
1591     }
1592 
1593     /**
1594      * @dev Returns the downcasted uint16 from uint256, reverting on
1595      * overflow (when the input is greater than largest uint16).
1596      *
1597      * Counterpart to Solidity's `uint16` operator.
1598      *
1599      * Requirements:
1600      *
1601      * - input must fit into 16 bits
1602      */
1603     function toUint16(uint256 value) internal pure returns (uint16) {
1604         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
1605         return uint16(value);
1606     }
1607 
1608     /**
1609      * @dev Returns the downcasted uint8 from uint256, reverting on
1610      * overflow (when the input is greater than largest uint8).
1611      *
1612      * Counterpart to Solidity's `uint8` operator.
1613      *
1614      * Requirements:
1615      *
1616      * - input must fit into 8 bits.
1617      */
1618     function toUint8(uint256 value) internal pure returns (uint8) {
1619         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
1620         return uint8(value);
1621     }
1622 
1623     /**
1624      * @dev Converts a signed int256 into an unsigned uint256.
1625      *
1626      * Requirements:
1627      *
1628      * - input must be greater than or equal to 0.
1629      */
1630     function toUint256(int256 value) internal pure returns (uint256) {
1631         require(value >= 0, "SafeCast: value must be positive");
1632         return uint256(value);
1633     }
1634 
1635     /**
1636      * @dev Returns the downcasted int128 from int256, reverting on
1637      * overflow (when the input is less than smallest int128 or
1638      * greater than largest int128).
1639      *
1640      * Counterpart to Solidity's `int128` operator.
1641      *
1642      * Requirements:
1643      *
1644      * - input must fit into 128 bits
1645      *
1646      * _Available since v3.1._
1647      */
1648     function toInt128(int256 value) internal pure returns (int128) {
1649         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
1650         return int128(value);
1651     }
1652 
1653     /**
1654      * @dev Returns the downcasted int64 from int256, reverting on
1655      * overflow (when the input is less than smallest int64 or
1656      * greater than largest int64).
1657      *
1658      * Counterpart to Solidity's `int64` operator.
1659      *
1660      * Requirements:
1661      *
1662      * - input must fit into 64 bits
1663      *
1664      * _Available since v3.1._
1665      */
1666     function toInt64(int256 value) internal pure returns (int64) {
1667         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
1668         return int64(value);
1669     }
1670 
1671     /**
1672      * @dev Returns the downcasted int32 from int256, reverting on
1673      * overflow (when the input is less than smallest int32 or
1674      * greater than largest int32).
1675      *
1676      * Counterpart to Solidity's `int32` operator.
1677      *
1678      * Requirements:
1679      *
1680      * - input must fit into 32 bits
1681      *
1682      * _Available since v3.1._
1683      */
1684     function toInt32(int256 value) internal pure returns (int32) {
1685         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
1686         return int32(value);
1687     }
1688 
1689     /**
1690      * @dev Returns the downcasted int16 from int256, reverting on
1691      * overflow (when the input is less than smallest int16 or
1692      * greater than largest int16).
1693      *
1694      * Counterpart to Solidity's `int16` operator.
1695      *
1696      * Requirements:
1697      *
1698      * - input must fit into 16 bits
1699      *
1700      * _Available since v3.1._
1701      */
1702     function toInt16(int256 value) internal pure returns (int16) {
1703         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
1704         return int16(value);
1705     }
1706 
1707     /**
1708      * @dev Returns the downcasted int8 from int256, reverting on
1709      * overflow (when the input is less than smallest int8 or
1710      * greater than largest int8).
1711      *
1712      * Counterpart to Solidity's `int8` operator.
1713      *
1714      * Requirements:
1715      *
1716      * - input must fit into 8 bits.
1717      *
1718      * _Available since v3.1._
1719      */
1720     function toInt8(int256 value) internal pure returns (int8) {
1721         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
1722         return int8(value);
1723     }
1724 
1725     /**
1726      * @dev Converts an unsigned uint256 into a signed int256.
1727      *
1728      * Requirements:
1729      *
1730      * - input must be less than or equal to maxInt256.
1731      */
1732     function toInt256(uint256 value) internal pure returns (int256) {
1733         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
1734         return int256(value);
1735     }
1736 }
1737 
1738 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
1739 
1740 
1741 
1742 // pragma solidity ^0.6.0;
1743 
1744 /**
1745  * @dev Contract module that helps prevent reentrant calls to a function.
1746  *
1747  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1748  * available, which can be applied to functions to make sure there are no nested
1749  * (reentrant) calls to them.
1750  *
1751  * Note that because there is a single `nonReentrant` guard, functions marked as
1752  * `nonReentrant` may not call one another. This can be worked around by making
1753  * those functions `private`, and then adding `external` `nonReentrant` entry
1754  * points to them.
1755  *
1756  * TIP: If you would like to learn more about reentrancy and alternative ways
1757  * to protect against it, check out our blog post
1758  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1759  */
1760 contract ReentrancyGuard {
1761     // Booleans are more expensive than uint256 or any type that takes up a full
1762     // word because each write operation emits an extra SLOAD to first read the
1763     // slot's contents, replace the bits taken up by the boolean, and then write
1764     // back. This is the compiler's defense against contract upgrades and
1765     // pointer aliasing, and it cannot be disabled.
1766 
1767     // The values being non-zero value makes deployment a bit more expensive,
1768     // but in exchange the refund on every call to nonReentrant will be lower in
1769     // amount. Since refunds are capped to a percentage of the total
1770     // transaction's gas, it is best to keep them low in cases like this one, to
1771     // increase the likelihood of the full refund coming into effect.
1772     uint256 private constant _NOT_ENTERED = 1;
1773     uint256 private constant _ENTERED = 2;
1774 
1775     uint256 private _status;
1776 
1777     constructor () internal {
1778         _status = _NOT_ENTERED;
1779     }
1780 
1781     /**
1782      * @dev Prevents a contract from calling itself, directly or indirectly.
1783      * Calling a `nonReentrant` function from another `nonReentrant`
1784      * function is not supported. It is possible to prevent this from happening
1785      * by making the `nonReentrant` function external, and make it call a
1786      * `private` function that does the actual work.
1787      */
1788     modifier nonReentrant() {
1789         // On the first call to nonReentrant, _notEntered will be true
1790         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1791 
1792         // Any calls to nonReentrant after this point will fail
1793         _status = _ENTERED;
1794 
1795         _;
1796 
1797         // By storing the original value once again, a refund is triggered (see
1798         // https://eips.ethereum.org/EIPS/eip-2200)
1799         _status = _NOT_ENTERED;
1800     }
1801 }
1802 
1803 
1804 /*
1805     Copyright 2020 Set Labs Inc.
1806     Licensed under the Apache License, Version 2.0 (the "License");
1807     you may not use this file except in compliance with the License.
1808     You may obtain a copy of the License at
1809     http://www.apache.org/licenses/LICENSE-2.0
1810     Unless required by applicable law or agreed to in writing, software
1811     distributed under the License is distributed on an "AS IS" BASIS,
1812     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1813     See the License for the specific language governing permissions and
1814     limitations under the License.
1815 
1816 */
1817 
1818 pragma solidity 0.6.10;
1819 pragma experimental "ABIEncoderV2";
1820 
1821 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1822 // import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
1823 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
1824 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1825 
1826 // import { IController } from "../../interfaces/IController.sol";
1827 // import { IManagerIssuanceHook } from "../../interfaces/IManagerIssuanceHook.sol";
1828 // import { Invoke } from "../lib/Invoke.sol";
1829 // import { ISetToken } from "../../interfaces/ISetToken.sol";
1830 // import { ModuleBase } from "../lib/ModuleBase.sol";
1831 // import { Position } from "../lib/Position.sol";
1832 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
1833 
1834 /**
1835  * @title BasicIssuanceModule
1836  * @author Set Protocol
1837  *
1838  * Module that enables issuance and redemption functionality on a SetToken. This is a module that is
1839  * required to bring the totalSupply of a Set above 0.
1840  */
1841 contract BasicIssuanceModule is ModuleBase, ReentrancyGuard {
1842     using Invoke for ISetToken;
1843     using Position for ISetToken.Position;
1844     using Position for ISetToken;
1845     using PreciseUnitMath for uint256;
1846     using SafeMath for uint256;
1847     using SafeCast for int256;
1848 
1849     /* ============ Events ============ */
1850 
1851     event SetTokenIssued(
1852         address indexed _setToken,
1853         address indexed _issuer,
1854         address indexed _to,
1855         address _hookContract,
1856         uint256 _quantity
1857     );
1858     event SetTokenRedeemed(
1859         address indexed _setToken,
1860         address indexed _redeemer,
1861         address indexed _to,
1862         uint256 _quantity
1863     );
1864 
1865     /* ============ State Variables ============ */
1866 
1867     // Mapping of SetToken to Issuance hook configurations
1868     mapping(ISetToken => IManagerIssuanceHook) public managerIssuanceHook;
1869 
1870     /* ============ Constructor ============ */
1871 
1872     /**
1873      * Set state controller state variable
1874      *
1875      * @param _controller             Address of controller contract
1876      */
1877     constructor(IController _controller) public ModuleBase(_controller) {}
1878 
1879     /* ============ External Functions ============ */
1880 
1881     /**
1882      * Deposits the SetToken's position components into the SetToken and mints the SetToken of the given quantity
1883      * to the specified _to address. This function only handles Default Positions (positionState = 0).
1884      *
1885      * @param _setToken             Instance of the SetToken contract
1886      * @param _quantity             Quantity of the SetToken to mint
1887      * @param _to                   Address to mint SetToken to
1888      */
1889     function issue(
1890         ISetToken _setToken,
1891         uint256 _quantity,
1892         address _to
1893     ) 
1894         external
1895         nonReentrant
1896         onlyValidAndInitializedSet(_setToken)
1897     {
1898         require(_quantity > 0, "Issue quantity must be > 0");
1899 
1900         address hookContract = _callPreIssueHooks(_setToken, _quantity, msg.sender, _to);
1901 
1902         (
1903             address[] memory components,
1904             uint256[] memory componentQuantities
1905         ) = getRequiredComponentUnitsForIssue(_setToken, _quantity);
1906 
1907         // For each position, transfer the required underlying to the SetToken
1908         for (uint256 i = 0; i < components.length; i++) {
1909             // Transfer the component to the SetToken
1910             transferFrom(
1911                 IERC20(components[i]),
1912                 msg.sender,
1913                 address(_setToken),
1914                 componentQuantities[i]
1915             );
1916         }
1917 
1918         // Mint the SetToken
1919         _setToken.mint(_to, _quantity);
1920 
1921         emit SetTokenIssued(address(_setToken), msg.sender, _to, hookContract, _quantity);
1922     }
1923 
1924     /**
1925      * Redeems the SetToken's positions and sends the components of the given
1926      * quantity to the caller. This function only handles Default Positions (positionState = 0).
1927      *
1928      * @param _setToken             Instance of the SetToken contract
1929      * @param _quantity             Quantity of the SetToken to redeem
1930      * @param _to                   Address to send component assets to
1931      */
1932     function redeem(
1933         ISetToken _setToken,
1934         uint256 _quantity,
1935         address _to
1936     )
1937         external
1938         nonReentrant
1939         onlyValidAndInitializedSet(_setToken)
1940     {
1941         require(_quantity > 0, "Redeem quantity must be > 0");
1942 
1943         // Burn the SetToken - ERC20's internal burn already checks that the user has enough balance
1944         _setToken.burn(msg.sender, _quantity);
1945 
1946         // For each position, invoke the SetToken to transfer the tokens to the user
1947         address[] memory components = _setToken.getComponents();
1948         for (uint256 i = 0; i < components.length; i++) {
1949             address component = components[i];
1950             require(!_setToken.hasExternalPosition(component), "Only default positions are supported");
1951 
1952             uint256 unit = _setToken.getDefaultPositionRealUnit(component).toUint256();
1953 
1954             // Use preciseMul to round down to ensure overcollateration when small redeem quantities are provided
1955             uint256 componentQuantity = _quantity.preciseMul(unit);
1956 
1957             // Instruct the SetToken to transfer the component to the user
1958             _setToken.strictInvokeTransfer(
1959                 component,
1960                 _to,
1961                 componentQuantity
1962             );
1963         }
1964 
1965         emit SetTokenRedeemed(address(_setToken), msg.sender, _to, _quantity);
1966     }
1967 
1968     /**
1969      * Initializes this module to the SetToken with issuance-related hooks. Only callable by the SetToken's manager.
1970      * Hook addresses are optional. Address(0) means that no hook will be called
1971      *
1972      * @param _setToken             Instance of the SetToken to issue
1973      * @param _preIssueHook         Instance of the Manager Contract with the Pre-Issuance Hook function
1974      */
1975     function initialize(
1976         ISetToken _setToken,
1977         IManagerIssuanceHook _preIssueHook
1978     )
1979         external
1980         onlySetManager(_setToken, msg.sender)
1981         onlyValidAndPendingSet(_setToken)
1982     {
1983         managerIssuanceHook[_setToken] = _preIssueHook;
1984 
1985         _setToken.initializeModule();
1986     }
1987 
1988     /**
1989      * Reverts as this module should not be removable after added. Users should always
1990      * have a way to redeem their Sets
1991      */
1992     function removeModule() external override {
1993         revert("The BasicIssuanceModule module cannot be removed");
1994     }
1995 
1996     /* ============ External Getter Functions ============ */
1997 
1998     /**
1999      * Retrieves the addresses and units required to mint a particular quantity of SetToken.
2000      *
2001      * @param _setToken             Instance of the SetToken to issue
2002      * @param _quantity             Quantity of SetToken to issue
2003      * @return address[]            List of component addresses
2004      * @return uint256[]            List of component units required to issue the quantity of SetTokens
2005      */
2006     function getRequiredComponentUnitsForIssue(
2007         ISetToken _setToken,
2008         uint256 _quantity
2009     )
2010         public
2011         view
2012         onlyValidAndInitializedSet(_setToken)
2013         returns (address[] memory, uint256[] memory)
2014     {
2015         address[] memory components = _setToken.getComponents();
2016 
2017         uint256[] memory notionalUnits = new uint256[](components.length);
2018 
2019         for (uint256 i = 0; i < components.length; i++) {
2020             require(!_setToken.hasExternalPosition(components[i]), "Only default positions are supported");
2021 
2022             notionalUnits[i] = _setToken.getDefaultPositionRealUnit(components[i]).toUint256().preciseMulCeil(_quantity);
2023         }
2024 
2025         return (components, notionalUnits);
2026     }
2027 
2028     /* ============ Internal Functions ============ */
2029 
2030     /**
2031      * If a pre-issue hook has been configured, call the external-protocol contract. Pre-issue hook logic
2032      * can contain arbitrary logic including validations, external function calls, etc.
2033      */
2034     function _callPreIssueHooks(
2035         ISetToken _setToken,
2036         uint256 _quantity,
2037         address _caller,
2038         address _to
2039     )
2040         internal
2041         returns(address)
2042     {
2043         IManagerIssuanceHook preIssueHook = managerIssuanceHook[_setToken];
2044         if (address(preIssueHook) != address(0)) {
2045             preIssueHook.invokePreIssueHook(_setToken, _quantity, _caller, _to);
2046             return address(preIssueHook);
2047         }
2048 
2049         return address(0);
2050     }
2051 }