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
227 // Dependency file: contracts/interfaces/IModule.sol
228 
229 /*
230     Copyright 2020 Set Labs Inc.
231 
232     Licensed under the Apache License, Version 2.0 (the "License");
233     you may not use this file except in compliance with the License.
234     You may obtain a copy of the License at
235 
236     http://www.apache.org/licenses/LICENSE-2.0
237 
238     Unless required by applicable law or agreed to in writing, software
239     distributed under the License is distributed on an "AS IS" BASIS,
240     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
241     See the License for the specific language governing permissions and
242     limitations under the License.
243 
244 
245 */
246 // pragma solidity 0.6.10;
247 
248 
249 /**
250  * @title IModule
251  * @author Set Protocol
252  *
253  * Interface for interacting with Modules.
254  */
255 interface IModule {
256     /**
257      * Called by a SetToken to notify that this module was removed from the Set token. Any logic can be included
258      * in case checks need to be made or state needs to be cleared.
259      */
260     function removeModule() external;
261 }
262 // Dependency file: contracts/lib/ExplicitERC20.sol
263 
264 /*
265     Copyright 2020 Set Labs Inc.
266 
267     Licensed under the Apache License, Version 2.0 (the "License");
268     you may not use this file except in compliance with the License.
269     You may obtain a copy of the License at
270 
271     http://www.apache.org/licenses/LICENSE-2.0
272 
273     Unless required by applicable law or agreed to in writing, software
274     distributed under the License is distributed on an "AS IS" BASIS,
275     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
276     See the License for the specific language governing permissions and
277     limitations under the License.
278 
279 
280 */
281 
282 // pragma solidity 0.6.10;
283 
284 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
285 // import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
286 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
287 
288 /**
289  * @title ExplicitERC20
290  * @author Set Protocol
291  *
292  * Utility functions for ERC20 transfers that require the explicit amount to be transferred.
293  */
294 library ExplicitERC20 {
295     using SafeMath for uint256;
296 
297     /**
298      * When given allowance, transfers a token from the "_from" to the "_to" of quantity "_quantity".
299      * Ensures that the recipient has received the correct quantity (ie no fees taken on transfer)
300      *
301      * @param _token           ERC20 token to approve
302      * @param _from            The account to transfer tokens from
303      * @param _to              The account to transfer tokens to
304      * @param _quantity        The quantity to transfer
305      */
306     function transferFrom(
307         IERC20 _token,
308         address _from,
309         address _to,
310         uint256 _quantity
311     )
312         internal
313     {
314         // Call specified ERC20 contract to transfer tokens (via proxy).
315         if (_quantity > 0) {
316             uint256 existingBalance = _token.balanceOf(_to);
317 
318             SafeERC20.safeTransferFrom(
319                 _token,
320                 _from,
321                 _to,
322                 _quantity
323             );
324 
325             uint256 newBalance = _token.balanceOf(_to);
326 
327             // Verify transfer quantity is reflected in balance
328             require(
329                 newBalance == existingBalance.add(_quantity),
330                 "Invalid post transfer balance"
331             );
332         }
333     }
334 }
335 
336 // Dependency file: contracts/lib/PreciseUnitMath.sol
337 
338 /*
339     Copyright 2020 Set Labs Inc.
340 
341     Licensed under the Apache License, Version 2.0 (the "License");
342     you may not use this file except in compliance with the License.
343     You may obtain a copy of the License at
344 
345     http://www.apache.org/licenses/LICENSE-2.0
346 
347     Unless required by applicable law or agreed to in writing, software
348     distributed under the License is distributed on an "AS IS" BASIS,
349     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
350     See the License for the specific language governing permissions and
351     limitations under the License.
352 
353 
354 */
355 
356 // pragma solidity 0.6.10;
357 // pragma experimental ABIEncoderV2;
358 
359 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
360 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
361 
362 
363 /**
364  * @title PreciseUnitMath
365  * @author Set Protocol
366  *
367  * Arithmetic for fixed-point numbers with 18 decimals of precision. Some functions taken from
368  * dYdX's BaseMath library.
369  */
370 library PreciseUnitMath {
371     using SafeMath for uint256;
372     using SignedSafeMath for int256;
373 
374     // The number One in precise units.
375     uint256 constant internal PRECISE_UNIT = 10 ** 18;
376     int256 constant internal PRECISE_UNIT_INT = 10 ** 18;
377 
378     // Max unsigned integer value
379     uint256 constant internal MAX_UINT_256 = type(uint256).max;
380     // Max and min signed integer value
381     int256 constant internal MAX_INT_256 = type(int256).max;
382     int256 constant internal MIN_INT_256 = type(int256).min;
383 
384     /**
385      * @dev Getter function since constants can't be read directly from libraries.
386      */
387     function preciseUnit() internal pure returns (uint256) {
388         return PRECISE_UNIT;
389     }
390 
391     /**
392      * @dev Getter function since constants can't be read directly from libraries.
393      */
394     function preciseUnitInt() internal pure returns (int256) {
395         return PRECISE_UNIT_INT;
396     }
397 
398     /**
399      * @dev Getter function since constants can't be read directly from libraries.
400      */
401     function maxUint256() internal pure returns (uint256) {
402         return MAX_UINT_256;
403     }
404 
405     /**
406      * @dev Getter function since constants can't be read directly from libraries.
407      */
408     function maxInt256() internal pure returns (int256) {
409         return MAX_INT_256;
410     }
411 
412     /**
413      * @dev Getter function since constants can't be read directly from libraries.
414      */
415     function minInt256() internal pure returns (int256) {
416         return MIN_INT_256;
417     }
418 
419     /**
420      * @dev Multiplies value a by value b (result is rounded down). It's assumed that the value b is the significand
421      * of a number with 18 decimals precision.
422      */
423     function preciseMul(uint256 a, uint256 b) internal pure returns (uint256) {
424         return a.mul(b).div(PRECISE_UNIT);
425     }
426 
427     /**
428      * @dev Multiplies value a by value b (result is rounded towards zero). It's assumed that the value b is the
429      * significand of a number with 18 decimals precision.
430      */
431     function preciseMul(int256 a, int256 b) internal pure returns (int256) {
432         return a.mul(b).div(PRECISE_UNIT_INT);
433     }
434 
435     /**
436      * @dev Multiplies value a by value b (result is rounded up). It's assumed that the value b is the significand
437      * of a number with 18 decimals precision.
438      */
439     function preciseMulCeil(uint256 a, uint256 b) internal pure returns (uint256) {
440         if (a == 0 || b == 0) {
441             return 0;
442         }
443         return a.mul(b).sub(1).div(PRECISE_UNIT).add(1);
444     }
445 
446     /**
447      * @dev Divides value a by value b (result is rounded down).
448      */
449     function preciseDiv(uint256 a, uint256 b) internal pure returns (uint256) {
450         return a.mul(PRECISE_UNIT).div(b);
451     }
452 
453 
454     /**
455      * @dev Divides value a by value b (result is rounded towards 0).
456      */
457     function preciseDiv(int256 a, int256 b) internal pure returns (int256) {
458         return a.mul(PRECISE_UNIT_INT).div(b);
459     }
460 
461     /**
462      * @dev Divides value a by value b (result is rounded up or away from 0).
463      */
464     function preciseDivCeil(uint256 a, uint256 b) internal pure returns (uint256) {
465         require(b != 0, "Cant divide by 0");
466 
467         return a > 0 ? a.mul(PRECISE_UNIT).sub(1).div(b).add(1) : 0;
468     }
469 
470     /**
471      * @dev Divides value a by value b (result is rounded down - positive numbers toward 0 and negative away from 0).
472      */
473     function divDown(int256 a, int256 b) internal pure returns (int256) {
474         require(b != 0, "Cant divide by 0");
475         require(a != MIN_INT_256 || b != -1, "Invalid input");
476 
477         int256 result = a.div(b);
478         if (a ^ b < 0 && a % b != 0) {
479             result = result.sub(1);
480         }
481 
482         return result;
483     }
484 
485     /**
486      * @dev Multiplies value a by value b where rounding is towards the lesser number. 
487      * (positive values are rounded towards zero and negative values are rounded away from 0). 
488      */
489     function conservativePreciseMul(int256 a, int256 b) internal pure returns (int256) {
490         return divDown(a.mul(b), PRECISE_UNIT_INT);
491     }
492 
493     /**
494      * @dev Divides value a by value b where rounding is towards the lesser number. 
495      * (positive values are rounded towards zero and negative values are rounded away from 0). 
496      */
497     function conservativePreciseDiv(int256 a, int256 b) internal pure returns (int256) {
498         return divDown(a.mul(PRECISE_UNIT_INT), b);
499     }
500 }
501 // Dependency file: contracts/protocol/lib/ModuleBase.sol
502 
503 /*
504     Copyright 2020 Set Labs Inc.
505 
506     Licensed under the Apache License, Version 2.0 (the "License");
507     you may not use this file except in compliance with the License.
508     You may obtain a copy of the License at
509 
510     http://www.apache.org/licenses/LICENSE-2.0
511 
512     Unless required by applicable law or agreed to in writing, software
513     distributed under the License is distributed on an "AS IS" BASIS,
514     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
515     See the License for the specific language governing permissions and
516     limitations under the License.
517 
518 
519 */
520 
521 // pragma solidity 0.6.10;
522 
523 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
524 
525 // import { ExplicitERC20 } from "../../lib/ExplicitERC20.sol";
526 // import { IController } from "../../interfaces/IController.sol";
527 // import { IModule } from "../../interfaces/IModule.sol";
528 // import { ISetToken } from "../../interfaces/ISetToken.sol";
529 
530 /**
531  * @title ModuleBase
532  * @author Set Protocol
533  *
534  * Abstract class that houses common Module-related state and functions.
535  */
536 abstract contract ModuleBase is IModule {
537 
538     /* ============ State Variables ============ */
539 
540     // Address of the controller
541     IController public controller;
542 
543     /* ============ Modifiers ============ */
544 
545     modifier onlySetManager(ISetToken _setToken, address _caller) {
546         require(isSetManager(_setToken, _caller), "Must be the SetToken manager");
547         _;
548     }
549 
550     modifier onlyValidAndInitializedSet(ISetToken _setToken) {
551         require(isSetValidAndInitialized(_setToken), "Must be a valid and initialized SetToken");
552         _;
553     }
554 
555     /**
556      * Throws if the sender is not a SetToken's module or module not enabled
557      */
558     modifier onlyModule(ISetToken _setToken) {
559         require(
560             _setToken.moduleStates(msg.sender) == ISetToken.ModuleState.INITIALIZED,
561             "Only the module can call"
562         );
563 
564         require(
565             controller.isModule(msg.sender),
566             "Module must be enabled on controller"
567         );
568         _;
569     }
570 
571     /**
572      * Utilized during module initializations to check that the module is in pending state
573      * and that the SetToken is valid
574      */
575     modifier onlyValidAndPendingSet(ISetToken _setToken) {
576         require(controller.isSet(address(_setToken)), "Must be controller-enabled SetToken");
577         require(isSetPendingInitialization(_setToken), "Must be pending initialization");        
578         _;
579     }
580 
581     /* ============ Constructor ============ */
582 
583     /**
584      * Set state variables and map asset pairs to their oracles
585      *
586      * @param _controller             Address of controller contract
587      */
588     constructor(IController _controller) public {
589         controller = _controller;
590     }
591 
592     /* ============ Internal Functions ============ */
593 
594     /**
595      * Transfers tokens from an address (that has set allowance on the module).
596      *
597      * @param  _token          The address of the ERC20 token
598      * @param  _from           The address to transfer from
599      * @param  _to             The address to transfer to
600      * @param  _quantity       The number of tokens to transfer
601      */
602     function transferFrom(IERC20 _token, address _from, address _to, uint256 _quantity) internal {
603         ExplicitERC20.transferFrom(_token, _from, _to, _quantity);
604     }
605 
606     /**
607      * Returns true if the module is in process of initialization on the SetToken
608      */
609     function isSetPendingInitialization(ISetToken _setToken) internal view returns(bool) {
610         return _setToken.isPendingModule(address(this));
611     }
612 
613     /**
614      * Returns true if the address is the SetToken's manager
615      */
616     function isSetManager(ISetToken _setToken, address _toCheck) internal view returns(bool) {
617         return _setToken.manager() == _toCheck;
618     }
619 
620     /**
621      * Returns true if SetToken must be enabled on the controller 
622      * and module is registered on the SetToken
623      */
624     function isSetValidAndInitialized(ISetToken _setToken) internal view returns(bool) {
625         return controller.isSet(address(_setToken)) &&
626             _setToken.isInitializedModule(address(this));
627     }
628 }
629 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
630 
631 
632 
633 // pragma solidity ^0.6.0;
634 
635 /**
636  * @dev Interface of the ERC20 standard as defined in the EIP.
637  */
638 interface IERC20 {
639     /**
640      * @dev Returns the amount of tokens in existence.
641      */
642     function totalSupply() external view returns (uint256);
643 
644     /**
645      * @dev Returns the amount of tokens owned by `account`.
646      */
647     function balanceOf(address account) external view returns (uint256);
648 
649     /**
650      * @dev Moves `amount` tokens from the caller's account to `recipient`.
651      *
652      * Returns a boolean value indicating whether the operation succeeded.
653      *
654      * Emits a {Transfer} event.
655      */
656     function transfer(address recipient, uint256 amount) external returns (bool);
657 
658     /**
659      * @dev Returns the remaining number of tokens that `spender` will be
660      * allowed to spend on behalf of `owner` through {transferFrom}. This is
661      * zero by default.
662      *
663      * This value changes when {approve} or {transferFrom} are called.
664      */
665     function allowance(address owner, address spender) external view returns (uint256);
666 
667     /**
668      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
669      *
670      * Returns a boolean value indicating whether the operation succeeded.
671      *
672      * // importANT: Beware that changing an allowance with this method brings the risk
673      * that someone may use both the old and the new allowance by unfortunate
674      * transaction ordering. One possible solution to mitigate this race
675      * condition is to first reduce the spender's allowance to 0 and set the
676      * desired value afterwards:
677      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
678      *
679      * Emits an {Approval} event.
680      */
681     function approve(address spender, uint256 amount) external returns (bool);
682 
683     /**
684      * @dev Moves `amount` tokens from `sender` to `recipient` using the
685      * allowance mechanism. `amount` is then deducted from the caller's
686      * allowance.
687      *
688      * Returns a boolean value indicating whether the operation succeeded.
689      *
690      * Emits a {Transfer} event.
691      */
692     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
693 
694     /**
695      * @dev Emitted when `value` tokens are moved from one account (`from`) to
696      * another (`to`).
697      *
698      * Note that `value` may be zero.
699      */
700     event Transfer(address indexed from, address indexed to, uint256 value);
701 
702     /**
703      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
704      * a call to {approve}. `value` is the new allowance.
705      */
706     event Approval(address indexed owner, address indexed spender, uint256 value);
707 }
708 // Dependency file: contracts/interfaces/ISetToken.sol
709 
710 /*
711     Copyright 2020 Set Labs Inc.
712 
713     Licensed under the Apache License, Version 2.0 (the "License");
714     you may not use this file except in compliance with the License.
715     You may obtain a copy of the License at
716 
717     http://www.apache.org/licenses/LICENSE-2.0
718 
719     Unless required by applicable law or agreed to in writing, software
720     distributed under the License is distributed on an "AS IS" BASIS,
721     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
722     See the License for the specific language governing permissions and
723     limitations under the License.
724 
725 
726 */
727 // pragma solidity 0.6.10;
728 // pragma experimental "ABIEncoderV2";
729 
730 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
731 
732 /**
733  * @title ISetToken
734  * @author Set Protocol
735  *
736  * Interface for operating with SetTokens.
737  */
738 interface ISetToken is IERC20 {
739 
740     /* ============ Enums ============ */
741 
742     enum ModuleState {
743         NONE,
744         PENDING,
745         INITIALIZED
746     }
747 
748     /* ============ Structs ============ */
749     /**
750      * The base definition of a SetToken Position
751      *
752      * @param component           Address of token in the Position
753      * @param module              If not in default state, the address of associated module
754      * @param unit                Each unit is the # of components per 10^18 of a SetToken
755      * @param positionState       Position ENUM. Default is 0; External is 1
756      * @param data                Arbitrary data
757      */
758     struct Position {
759         address component;
760         address module;
761         int256 unit;
762         uint8 positionState;
763         bytes data;
764     }
765 
766     /**
767      * A struct that stores a component's cash position details and external positions
768      * This data structure allows O(1) access to a component's cash position units and 
769      * virtual units.
770      *
771      * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
772      *                                  updating all units at once via the position multiplier. Virtual units are achieved
773      *                                  by dividing a "real" value by the "positionMultiplier"
774      * @param componentIndex            
775      * @param externalPositionModules   List of external modules attached to each external position. Each module
776      *                                  maps to an external position
777      * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
778      */
779     struct ComponentPosition {
780       int256 virtualUnit;
781       address[] externalPositionModules;
782       mapping(address => ExternalPosition) externalPositions;
783     }
784 
785     /**
786      * A struct that stores a component's external position details including virtual unit and any
787      * auxiliary data.
788      *
789      * @param virtualUnit       Virtual value of a component's EXTERNAL position.
790      * @param data              Arbitrary data
791      */
792     struct ExternalPosition {
793       int256 virtualUnit;
794       bytes data;
795     }
796 
797 
798     /* ============ Functions ============ */
799     
800     function addComponent(address _component) external;
801     function removeComponent(address _component) external;
802     function editDefaultPositionUnit(address _component, int256 _realUnit) external;
803     function addExternalPositionModule(address _component, address _positionModule) external;
804     function removeExternalPositionModule(address _component, address _positionModule) external;
805     function editExternalPositionUnit(address _component, address _positionModule, int256 _realUnit) external;
806     function editExternalPositionData(address _component, address _positionModule, bytes calldata _data) external;
807 
808     function invoke(address _target, uint256 _value, bytes calldata _data) external returns(bytes memory);
809 
810     function editPositionMultiplier(int256 _newMultiplier) external;
811 
812     function mint(address _account, uint256 _quantity) external;
813     function burn(address _account, uint256 _quantity) external;
814 
815     function lock() external;
816     function unlock() external;
817 
818     function addModule(address _module) external;
819     function removeModule(address _module) external;
820     function initializeModule() external;
821 
822     function setManager(address _manager) external;
823 
824     function manager() external view returns (address);
825     function moduleStates(address _module) external view returns (ModuleState);
826     function getModules() external view returns (address[] memory);
827     
828     function getDefaultPositionRealUnit(address _component) external view returns(int256);
829     function getExternalPositionRealUnit(address _component, address _positionModule) external view returns(int256);
830     function getComponents() external view returns(address[] memory);
831     function getExternalPositionModules(address _component) external view returns(address[] memory);
832     function getExternalPositionData(address _component, address _positionModule) external view returns(bytes memory);
833     function isExternalPositionModule(address _component, address _module) external view returns(bool);
834     function isComponent(address _component) external view returns(bool);
835     
836     function positionMultiplier() external view returns (int256);
837     function getPositions() external view returns (Position[] memory);
838     function getTotalComponentRealUnits(address _component) external view returns(int256);
839 
840     function isInitializedModule(address _module) external view returns(bool);
841     function isPendingModule(address _module) external view returns(bool);
842     function isLocked() external view returns (bool);
843 }
844 // Dependency file: contracts/interfaces/IController.sol
845 
846 /*
847     Copyright 2020 Set Labs Inc.
848 
849     Licensed under the Apache License, Version 2.0 (the "License");
850     you may not use this file except in compliance with the License.
851     You may obtain a copy of the License at
852 
853     http://www.apache.org/licenses/LICENSE-2.0
854 
855     Unless required by applicable law or agreed to in writing, software
856     distributed under the License is distributed on an "AS IS" BASIS,
857     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
858     See the License for the specific language governing permissions and
859     limitations under the License.
860 
861 
862 */
863 // pragma solidity 0.6.10;
864 
865 interface IController {
866     function addSet(address _setToken) external;
867     function getModuleFee(address _module, uint256 _feeType) external view returns(uint256);
868     function resourceId(uint256 _id) external view returns(address);
869     function feeRecipient() external view returns(address);
870     function isModule(address _module) external view returns(bool);
871     function isSet(address _setToken) external view returns(bool);
872     function isSystemContract(address _contractAddress) external view returns (bool);
873 }
874 // Dependency file: @openzeppelin/contracts/math/SignedSafeMath.sol
875 
876 
877 
878 // pragma solidity ^0.6.0;
879 
880 /**
881  * @title SignedSafeMath
882  * @dev Signed math operations with safety checks that revert on error.
883  */
884 library SignedSafeMath {
885     int256 constant private _INT256_MIN = -2**255;
886 
887         /**
888      * @dev Returns the multiplication of two signed integers, reverting on
889      * overflow.
890      *
891      * Counterpart to Solidity's `*` operator.
892      *
893      * Requirements:
894      *
895      * - Multiplication cannot overflow.
896      */
897     function mul(int256 a, int256 b) internal pure returns (int256) {
898         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
899         // benefit is lost if 'b' is also tested.
900         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
901         if (a == 0) {
902             return 0;
903         }
904 
905         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
906 
907         int256 c = a * b;
908         require(c / a == b, "SignedSafeMath: multiplication overflow");
909 
910         return c;
911     }
912 
913     /**
914      * @dev Returns the integer division of two signed integers. Reverts on
915      * division by zero. The result is rounded towards zero.
916      *
917      * Counterpart to Solidity's `/` operator. Note: this function uses a
918      * `revert` opcode (which leaves remaining gas untouched) while Solidity
919      * uses an invalid opcode to revert (consuming all remaining gas).
920      *
921      * Requirements:
922      *
923      * - The divisor cannot be zero.
924      */
925     function div(int256 a, int256 b) internal pure returns (int256) {
926         require(b != 0, "SignedSafeMath: division by zero");
927         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
928 
929         int256 c = a / b;
930 
931         return c;
932     }
933 
934     /**
935      * @dev Returns the subtraction of two signed integers, reverting on
936      * overflow.
937      *
938      * Counterpart to Solidity's `-` operator.
939      *
940      * Requirements:
941      *
942      * - Subtraction cannot overflow.
943      */
944     function sub(int256 a, int256 b) internal pure returns (int256) {
945         int256 c = a - b;
946         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
947 
948         return c;
949     }
950 
951     /**
952      * @dev Returns the addition of two signed integers, reverting on
953      * overflow.
954      *
955      * Counterpart to Solidity's `+` operator.
956      *
957      * Requirements:
958      *
959      * - Addition cannot overflow.
960      */
961     function add(int256 a, int256 b) internal pure returns (int256) {
962         int256 c = a + b;
963         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
964 
965         return c;
966     }
967 }
968 
969 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
970 
971 
972 
973 // pragma solidity ^0.6.0;
974 
975 /**
976  * @dev Wrappers over Solidity's arithmetic operations with added overflow
977  * checks.
978  *
979  * Arithmetic operations in Solidity wrap on overflow. This can easily result
980  * in bugs, because programmers usually assume that an overflow raises an
981  * error, which is the standard behavior in high level programming languages.
982  * `SafeMath` restores this intuition by reverting the transaction when an
983  * operation overflows.
984  *
985  * Using this library instead of the unchecked operations eliminates an entire
986  * class of bugs, so it's recommended to use it always.
987  */
988 library SafeMath {
989     /**
990      * @dev Returns the addition of two unsigned integers, reverting on
991      * overflow.
992      *
993      * Counterpart to Solidity's `+` operator.
994      *
995      * Requirements:
996      *
997      * - Addition cannot overflow.
998      */
999     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1000         uint256 c = a + b;
1001         require(c >= a, "SafeMath: addition overflow");
1002 
1003         return c;
1004     }
1005 
1006     /**
1007      * @dev Returns the subtraction of two unsigned integers, reverting on
1008      * overflow (when the result is negative).
1009      *
1010      * Counterpart to Solidity's `-` operator.
1011      *
1012      * Requirements:
1013      *
1014      * - Subtraction cannot overflow.
1015      */
1016     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1017         return sub(a, b, "SafeMath: subtraction overflow");
1018     }
1019 
1020     /**
1021      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1022      * overflow (when the result is negative).
1023      *
1024      * Counterpart to Solidity's `-` operator.
1025      *
1026      * Requirements:
1027      *
1028      * - Subtraction cannot overflow.
1029      */
1030     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1031         require(b <= a, errorMessage);
1032         uint256 c = a - b;
1033 
1034         return c;
1035     }
1036 
1037     /**
1038      * @dev Returns the multiplication of two unsigned integers, reverting on
1039      * overflow.
1040      *
1041      * Counterpart to Solidity's `*` operator.
1042      *
1043      * Requirements:
1044      *
1045      * - Multiplication cannot overflow.
1046      */
1047     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1048         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1049         // benefit is lost if 'b' is also tested.
1050         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1051         if (a == 0) {
1052             return 0;
1053         }
1054 
1055         uint256 c = a * b;
1056         require(c / a == b, "SafeMath: multiplication overflow");
1057 
1058         return c;
1059     }
1060 
1061     /**
1062      * @dev Returns the integer division of two unsigned integers. Reverts on
1063      * division by zero. The result is rounded towards zero.
1064      *
1065      * Counterpart to Solidity's `/` operator. Note: this function uses a
1066      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1067      * uses an invalid opcode to revert (consuming all remaining gas).
1068      *
1069      * Requirements:
1070      *
1071      * - The divisor cannot be zero.
1072      */
1073     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1074         return div(a, b, "SafeMath: division by zero");
1075     }
1076 
1077     /**
1078      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1079      * division by zero. The result is rounded towards zero.
1080      *
1081      * Counterpart to Solidity's `/` operator. Note: this function uses a
1082      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1083      * uses an invalid opcode to revert (consuming all remaining gas).
1084      *
1085      * Requirements:
1086      *
1087      * - The divisor cannot be zero.
1088      */
1089     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1090         require(b > 0, errorMessage);
1091         uint256 c = a / b;
1092         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1093 
1094         return c;
1095     }
1096 
1097     /**
1098      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1099      * Reverts when dividing by zero.
1100      *
1101      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1102      * opcode (which leaves remaining gas untouched) while Solidity uses an
1103      * invalid opcode to revert (consuming all remaining gas).
1104      *
1105      * Requirements:
1106      *
1107      * - The divisor cannot be zero.
1108      */
1109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1110         return mod(a, b, "SafeMath: modulo by zero");
1111     }
1112 
1113     /**
1114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1115      * Reverts with custom message when dividing by zero.
1116      *
1117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1118      * opcode (which leaves remaining gas untouched) while Solidity uses an
1119      * invalid opcode to revert (consuming all remaining gas).
1120      *
1121      * Requirements:
1122      *
1123      * - The divisor cannot be zero.
1124      */
1125     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1126         require(b != 0, errorMessage);
1127         return a % b;
1128     }
1129 }
1130 
1131 // Dependency file: @openzeppelin/contracts/utils/SafeCast.sol
1132 
1133 
1134 
1135 // pragma solidity ^0.6.0;
1136 
1137 
1138 /**
1139  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1140  * checks.
1141  *
1142  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1143  * easily result in undesired exploitation or bugs, since developers usually
1144  * assume that overflows raise errors. `SafeCast` restores this intuition by
1145  * reverting the transaction when such an operation overflows.
1146  *
1147  * Using this library instead of the unchecked operations eliminates an entire
1148  * class of bugs, so it's recommended to use it always.
1149  *
1150  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1151  * all math on `uint256` and `int256` and then downcasting.
1152  */
1153 library SafeCast {
1154 
1155     /**
1156      * @dev Returns the downcasted uint128 from uint256, reverting on
1157      * overflow (when the input is greater than largest uint128).
1158      *
1159      * Counterpart to Solidity's `uint128` operator.
1160      *
1161      * Requirements:
1162      *
1163      * - input must fit into 128 bits
1164      */
1165     function toUint128(uint256 value) internal pure returns (uint128) {
1166         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1167         return uint128(value);
1168     }
1169 
1170     /**
1171      * @dev Returns the downcasted uint64 from uint256, reverting on
1172      * overflow (when the input is greater than largest uint64).
1173      *
1174      * Counterpart to Solidity's `uint64` operator.
1175      *
1176      * Requirements:
1177      *
1178      * - input must fit into 64 bits
1179      */
1180     function toUint64(uint256 value) internal pure returns (uint64) {
1181         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
1182         return uint64(value);
1183     }
1184 
1185     /**
1186      * @dev Returns the downcasted uint32 from uint256, reverting on
1187      * overflow (when the input is greater than largest uint32).
1188      *
1189      * Counterpart to Solidity's `uint32` operator.
1190      *
1191      * Requirements:
1192      *
1193      * - input must fit into 32 bits
1194      */
1195     function toUint32(uint256 value) internal pure returns (uint32) {
1196         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1197         return uint32(value);
1198     }
1199 
1200     /**
1201      * @dev Returns the downcasted uint16 from uint256, reverting on
1202      * overflow (when the input is greater than largest uint16).
1203      *
1204      * Counterpart to Solidity's `uint16` operator.
1205      *
1206      * Requirements:
1207      *
1208      * - input must fit into 16 bits
1209      */
1210     function toUint16(uint256 value) internal pure returns (uint16) {
1211         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
1212         return uint16(value);
1213     }
1214 
1215     /**
1216      * @dev Returns the downcasted uint8 from uint256, reverting on
1217      * overflow (when the input is greater than largest uint8).
1218      *
1219      * Counterpart to Solidity's `uint8` operator.
1220      *
1221      * Requirements:
1222      *
1223      * - input must fit into 8 bits.
1224      */
1225     function toUint8(uint256 value) internal pure returns (uint8) {
1226         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
1227         return uint8(value);
1228     }
1229 
1230     /**
1231      * @dev Converts a signed int256 into an unsigned uint256.
1232      *
1233      * Requirements:
1234      *
1235      * - input must be greater than or equal to 0.
1236      */
1237     function toUint256(int256 value) internal pure returns (uint256) {
1238         require(value >= 0, "SafeCast: value must be positive");
1239         return uint256(value);
1240     }
1241 
1242     /**
1243      * @dev Returns the downcasted int128 from int256, reverting on
1244      * overflow (when the input is less than smallest int128 or
1245      * greater than largest int128).
1246      *
1247      * Counterpart to Solidity's `int128` operator.
1248      *
1249      * Requirements:
1250      *
1251      * - input must fit into 128 bits
1252      *
1253      * _Available since v3.1._
1254      */
1255     function toInt128(int256 value) internal pure returns (int128) {
1256         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
1257         return int128(value);
1258     }
1259 
1260     /**
1261      * @dev Returns the downcasted int64 from int256, reverting on
1262      * overflow (when the input is less than smallest int64 or
1263      * greater than largest int64).
1264      *
1265      * Counterpart to Solidity's `int64` operator.
1266      *
1267      * Requirements:
1268      *
1269      * - input must fit into 64 bits
1270      *
1271      * _Available since v3.1._
1272      */
1273     function toInt64(int256 value) internal pure returns (int64) {
1274         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
1275         return int64(value);
1276     }
1277 
1278     /**
1279      * @dev Returns the downcasted int32 from int256, reverting on
1280      * overflow (when the input is less than smallest int32 or
1281      * greater than largest int32).
1282      *
1283      * Counterpart to Solidity's `int32` operator.
1284      *
1285      * Requirements:
1286      *
1287      * - input must fit into 32 bits
1288      *
1289      * _Available since v3.1._
1290      */
1291     function toInt32(int256 value) internal pure returns (int32) {
1292         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
1293         return int32(value);
1294     }
1295 
1296     /**
1297      * @dev Returns the downcasted int16 from int256, reverting on
1298      * overflow (when the input is less than smallest int16 or
1299      * greater than largest int16).
1300      *
1301      * Counterpart to Solidity's `int16` operator.
1302      *
1303      * Requirements:
1304      *
1305      * - input must fit into 16 bits
1306      *
1307      * _Available since v3.1._
1308      */
1309     function toInt16(int256 value) internal pure returns (int16) {
1310         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
1311         return int16(value);
1312     }
1313 
1314     /**
1315      * @dev Returns the downcasted int8 from int256, reverting on
1316      * overflow (when the input is less than smallest int8 or
1317      * greater than largest int8).
1318      *
1319      * Counterpart to Solidity's `int8` operator.
1320      *
1321      * Requirements:
1322      *
1323      * - input must fit into 8 bits.
1324      *
1325      * _Available since v3.1._
1326      */
1327     function toInt8(int256 value) internal pure returns (int8) {
1328         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
1329         return int8(value);
1330     }
1331 
1332     /**
1333      * @dev Converts an unsigned uint256 into a signed int256.
1334      *
1335      * Requirements:
1336      *
1337      * - input must be less than or equal to maxInt256.
1338      */
1339     function toInt256(uint256 value) internal pure returns (int256) {
1340         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
1341         return int256(value);
1342     }
1343 }
1344 
1345 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
1346 
1347 
1348 
1349 // pragma solidity ^0.6.0;
1350 
1351 /**
1352  * @dev Contract module that helps prevent reentrant calls to a function.
1353  *
1354  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1355  * available, which can be applied to functions to make sure there are no nested
1356  * (reentrant) calls to them.
1357  *
1358  * Note that because there is a single `nonReentrant` guard, functions marked as
1359  * `nonReentrant` may not call one another. This can be worked around by making
1360  * those functions `private`, and then adding `external` `nonReentrant` entry
1361  * points to them.
1362  *
1363  * TIP: If you would like to learn more about reentrancy and alternative ways
1364  * to protect against it, check out our blog post
1365  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1366  */
1367 contract ReentrancyGuard {
1368     // Booleans are more expensive than uint256 or any type that takes up a full
1369     // word because each write operation emits an extra SLOAD to first read the
1370     // slot's contents, replace the bits taken up by the boolean, and then write
1371     // back. This is the compiler's defense against contract upgrades and
1372     // pointer aliasing, and it cannot be disabled.
1373 
1374     // The values being non-zero value makes deployment a bit more expensive,
1375     // but in exchange the refund on every call to nonReentrant will be lower in
1376     // amount. Since refunds are capped to a percentage of the total
1377     // transaction's gas, it is best to keep them low in cases like this one, to
1378     // increase the likelihood of the full refund coming into effect.
1379     uint256 private constant _NOT_ENTERED = 1;
1380     uint256 private constant _ENTERED = 2;
1381 
1382     uint256 private _status;
1383 
1384     constructor () internal {
1385         _status = _NOT_ENTERED;
1386     }
1387 
1388     /**
1389      * @dev Prevents a contract from calling itself, directly or indirectly.
1390      * Calling a `nonReentrant` function from another `nonReentrant`
1391      * function is not supported. It is possible to prevent this from happening
1392      * by making the `nonReentrant` function external, and make it call a
1393      * `private` function that does the actual work.
1394      */
1395     modifier nonReentrant() {
1396         // On the first call to nonReentrant, _notEntered will be true
1397         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1398 
1399         // Any calls to nonReentrant after this point will fail
1400         _status = _ENTERED;
1401 
1402         _;
1403 
1404         // By storing the original value once again, a refund is triggered (see
1405         // https://eips.ethereum.org/EIPS/eip-2200)
1406         _status = _NOT_ENTERED;
1407     }
1408 }
1409 
1410 /*
1411     Copyright 2020 Set Labs Inc.
1412 
1413     Licensed under the Apache License, Version 2.0 (the "License");
1414     you may not use this file except in compliance with the License.
1415     You may obtain a copy of the License at
1416 
1417     http://www.apache.org/licenses/LICENSE-2.0
1418 
1419     Unless required by applicable law or agreed to in writing, software
1420     distributed under the License is distributed on an "AS IS" BASIS,
1421     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1422     See the License for the specific language governing permissions and
1423     limitations under the License.
1424 
1425 
1426 */
1427 
1428 pragma solidity 0.6.10;
1429 pragma experimental "ABIEncoderV2";
1430 
1431 // import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
1432 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
1433 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1434 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
1435 
1436 // import { IController } from "../../interfaces/IController.sol";
1437 // import { ISetToken } from "../../interfaces/ISetToken.sol";
1438 // import { ModuleBase } from "../lib/ModuleBase.sol";
1439 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
1440 
1441 
1442 /**
1443  * @title StreamingFeeModule
1444  * @author Set Protocol
1445  *
1446  * Smart contract that accrues streaming fees for Set managers. Streaming fees are denominated as percent
1447  * per year and realized as Set inflation rewarded to the manager.
1448  */
1449 contract StreamingFeeModule is ModuleBase, ReentrancyGuard {
1450     using SafeMath for uint256;
1451     using PreciseUnitMath for uint256;
1452     using SafeCast for uint256;
1453 
1454     using SignedSafeMath for int256;
1455     using PreciseUnitMath for int256;
1456     using SafeCast for int256;
1457 
1458 
1459     /* ============ Structs ============ */
1460 
1461     struct FeeState {
1462         address feeRecipient;                   // Address to accrue fees to
1463         uint256 maxStreamingFeePercentage;      // Max streaming fee maanager commits to using (1% = 1e16, 100% = 1e18)
1464         uint256 streamingFeePercentage;         // Percent of Set accruing to manager annually (1% = 1e16, 100% = 1e18)
1465         uint256 lastStreamingFeeTimestamp;      // Timestamp last streaming fee was accrued
1466     }
1467 
1468     /* ============ Events ============ */
1469 
1470     event FeeActualized(address indexed _setToken, uint256 _managerFee, uint256 _protocolFee);
1471     event StreamingFeeUpdated(address indexed _setToken, uint256 _newStreamingFee);
1472     event FeeRecipientUpdated(address indexed _setToken, address _newFeeRecipient);
1473 
1474     /* ============ Constants ============ */
1475 
1476     uint256 private constant ONE_YEAR_IN_SECONDS = 365.25 days;
1477     uint256 private constant PROTOCOL_STREAMING_FEE_INDEX = 0;
1478 
1479     /* ============ State Variables ============ */
1480 
1481     mapping(ISetToken => FeeState) public feeStates;
1482 
1483     /* ============ Constructor ============ */
1484 
1485     constructor(IController _controller) public ModuleBase(_controller) {}
1486 
1487     /* ============ External Functions ============ */
1488 
1489     /*
1490      * Calculates total inflation percentage then mints new Sets to the fee recipient. Position units are
1491      * then adjusted down (in magnitude) in order to ensure full collateralization. Callable by anyone.
1492      *
1493      * @param _setToken       Address of SetToken
1494      */
1495     function accrueFee(ISetToken _setToken) public nonReentrant onlyValidAndInitializedSet(_setToken) {
1496         uint256 managerFee;
1497         uint256 protocolFee;
1498 
1499         if (_streamingFeePercentage(_setToken) > 0) {
1500             uint256 inflationFeePercentage = _calculateStreamingFee(_setToken);
1501 
1502             // Calculate incentiveFee inflation
1503             uint256 feeQuantity = _calculateStreamingFeeInflation(_setToken, inflationFeePercentage);
1504 
1505             // Mint new Sets to manager and protocol
1506             (
1507                 managerFee,
1508                 protocolFee
1509             ) = _mintManagerAndProtocolFee(_setToken, feeQuantity);
1510 
1511             _editPositionMultiplier(_setToken, inflationFeePercentage);
1512         }
1513 
1514         feeStates[_setToken].lastStreamingFeeTimestamp = block.timestamp;
1515 
1516         emit FeeActualized(address(_setToken), managerFee, protocolFee);
1517     }
1518 
1519     /**
1520      * SET MANAGER ONLY. Initialize module with SetToken and set the fee state for the SetToken. Passed
1521      * _settings will have lastStreamingFeeTimestamp over-written.
1522      *
1523      * @param _setToken                 Address of SetToken
1524      * @param _settings                 FeeState struct defining fee parameters
1525      */
1526     function initialize(
1527         ISetToken _setToken,
1528         FeeState memory _settings
1529     )
1530         external
1531         onlySetManager(_setToken, msg.sender)
1532         onlyValidAndPendingSet(_setToken)
1533     {
1534         require(_settings.feeRecipient != address(0), "Fee Recipient must be non-zero address.");
1535         require(_settings.maxStreamingFeePercentage < PreciseUnitMath.preciseUnit(), "Max fee must be < 100%.");
1536         require(_settings.streamingFeePercentage <= _settings.maxStreamingFeePercentage, "Fee must be <= max.");
1537 
1538         _settings.lastStreamingFeeTimestamp = block.timestamp;
1539 
1540         feeStates[_setToken] = _settings;
1541         _setToken.initializeModule();
1542     }
1543 
1544     /**
1545      * Removes this module from the SetToken, via call by the SetToken. Manager's feeState is deleted. Fees
1546      * are not accrued in case reason for removing module is related to fee accrual.
1547      */
1548     function removeModule() external override {
1549         delete feeStates[ISetToken(msg.sender)];
1550     }
1551 
1552     /*
1553      * Set new streaming fee. Fees accrue at current rate then new rate is set.
1554      * Fees are accrued to prevent the manager from unfairly accruing a larger percentage.
1555      *
1556      * @param _setToken       Address of SetToken
1557      * @param _newFee         New streaming fee 18 decimal precision
1558      */
1559     function updateStreamingFee(
1560         ISetToken _setToken,
1561         uint256 _newFee
1562     )
1563         external
1564         onlySetManager(_setToken, msg.sender)
1565         onlyValidAndInitializedSet(_setToken)
1566     {
1567         require(_newFee < _maxStreamingFeePercentage(_setToken), "Fee must be less than max");
1568         accrueFee(_setToken);
1569 
1570         feeStates[_setToken].streamingFeePercentage = _newFee;
1571 
1572         emit StreamingFeeUpdated(address(_setToken), _newFee);
1573     }
1574 
1575     /*
1576      * Set new fee recipient.
1577      *
1578      * @param _setToken             Address of SetToken
1579      * @param _newFeeRecipient      New fee recipient
1580      */
1581     function updateFeeRecipient(ISetToken _setToken, address _newFeeRecipient)
1582         external
1583         onlySetManager(_setToken, msg.sender)
1584         onlyValidAndInitializedSet(_setToken)
1585     {
1586         require(_newFeeRecipient != address(0), "Fee Recipient must be non-zero address.");
1587 
1588         feeStates[_setToken].feeRecipient = _newFeeRecipient;
1589 
1590         emit FeeRecipientUpdated(address(_setToken), _newFeeRecipient);
1591     }
1592 
1593     /*
1594      * Calculates total inflation percentage in order to accrue fees to manager.
1595      *
1596      * @param _setToken       Address of SetToken
1597      * @return  uint256       Percent inflation of supply
1598      */
1599     function getFee(ISetToken _setToken) external view returns (uint256) {
1600         return _calculateStreamingFee(_setToken);
1601     }
1602 
1603     /* ============ Internal Functions ============ */
1604 
1605     /**
1606      * Calculates streaming fee by multiplying streamingFeePercentage by the elapsed amount of time since the last fee
1607      * was collected divided by one year in seconds, since the fee is a yearly fee.
1608      *
1609      * @param  _setToken          Address of Set to have feeState updated
1610      * @return uint256            Streaming fee denominated in percentage of totalSupply
1611      */
1612     function _calculateStreamingFee(ISetToken _setToken) internal view returns(uint256) {
1613         uint256 timeSinceLastFee = block.timestamp.sub(_lastStreamingFeeTimestamp(_setToken));
1614 
1615         // Streaming fee is streaming fee times years since last fee
1616         return timeSinceLastFee.mul(_streamingFeePercentage(_setToken)).div(ONE_YEAR_IN_SECONDS);
1617     }
1618 
1619     /**
1620      * Returns the new incentive fee denominated in the number of SetTokens to mint. The calculation for the fee involves
1621      * implying mint quantity so that the feeRecipient owns the fee percentage of the entire supply of the Set.
1622      *
1623      * The formula to solve for fee is:
1624      * (feeQuantity / feeQuantity) + totalSupply = fee / scaleFactor
1625      *
1626      * The simplified formula utilized below is:
1627      * feeQuantity = fee * totalSupply / (scaleFactor - fee)
1628      *
1629      * @param   _setToken               SetToken instance
1630      * @param   _feePercentage          Fee levied to feeRecipient
1631      * @return  uint256                 New RebalancingSet issue quantity
1632      */
1633     function _calculateStreamingFeeInflation(
1634         ISetToken _setToken,
1635         uint256 _feePercentage
1636     )
1637         internal
1638         view
1639         returns (uint256)
1640     {
1641         uint256 totalSupply = _setToken.totalSupply();
1642 
1643         // fee * totalSupply
1644         uint256 a = _feePercentage.mul(totalSupply);
1645 
1646         // ScaleFactor (10e18) - fee
1647         uint256 b = PreciseUnitMath.preciseUnit().sub(_feePercentage);
1648 
1649         return a.div(b);
1650     }
1651 
1652     /**
1653      * Mints sets to both the manager and the protocol. Protocol takes a percentage fee of the total amount of Sets
1654      * minted to manager.
1655      *
1656      * @param   _setToken               SetToken instance
1657      * @param   _feeQuantity            Amount of Sets to be minted as fees
1658      * @return  uint256                 Amount of Sets accrued to manager as fee
1659      * @return  uint256                 Amount of Sets accrued to protocol as fee
1660      */
1661     function _mintManagerAndProtocolFee(ISetToken _setToken, uint256 _feeQuantity) internal returns (uint256, uint256) {
1662         address protocolFeeRecipient = controller.feeRecipient();
1663         uint256 protocolFee = controller.getModuleFee(address(this), PROTOCOL_STREAMING_FEE_INDEX);
1664 
1665         uint256 protocolFeeAmount = _feeQuantity.preciseMul(protocolFee);
1666         uint256 managerFeeAmount = _feeQuantity.sub(protocolFeeAmount);
1667 
1668         _setToken.mint(_feeRecipient(_setToken), managerFeeAmount);
1669 
1670         if (protocolFeeAmount > 0) {
1671             _setToken.mint(protocolFeeRecipient, protocolFeeAmount);
1672         }
1673 
1674         return (managerFeeAmount, protocolFeeAmount);
1675     }
1676 
1677     /**
1678      * Calculates new position multiplier according to following formula:
1679      *
1680      * newMultiplier = oldMultiplier * (1-inflationFee)
1681      *
1682      * This reduces position sizes to offset increase in supply due to fee collection.
1683      *
1684      * @param   _setToken               SetToken instance
1685      * @param   _inflationFee           Fee inflation rate
1686      */
1687     function _editPositionMultiplier(ISetToken _setToken, uint256 _inflationFee) internal {
1688         int256 currentMultipler = _setToken.positionMultiplier();
1689         int256 newMultiplier = currentMultipler.preciseMul(PreciseUnitMath.preciseUnit().sub(_inflationFee).toInt256());
1690 
1691         _setToken.editPositionMultiplier(newMultiplier);
1692     }
1693 
1694     function _feeRecipient(ISetToken _set) internal view returns (address) {
1695         return feeStates[_set].feeRecipient;
1696     }
1697 
1698     function _lastStreamingFeeTimestamp(ISetToken _set) internal view returns (uint256) {
1699         return feeStates[_set].lastStreamingFeeTimestamp;
1700     }
1701 
1702     function _maxStreamingFeePercentage(ISetToken _set) internal view returns (uint256) {
1703         return feeStates[_set].maxStreamingFeePercentage;
1704     }
1705 
1706     function _streamingFeePercentage(ISetToken _set) internal view returns (uint256) {
1707         return feeStates[_set].streamingFeePercentage;
1708     }
1709 }