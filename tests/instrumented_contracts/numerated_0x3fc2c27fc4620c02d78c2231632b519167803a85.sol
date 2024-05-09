1 // File: localhost/internals/gasRefundable.sol
2 
3 /**
4  *  Copyright (C) 2019 The Contract Wallet Company Limited
5  *
6  *  This program is free software: you can redistribute it and/or modify
7  *  it under the terms of the GNU General Public License as published by
8  *  the Free Software Foundation, either version 3 of the License, or
9  *  (at your option) any later version.
10  *  This program is distributed in the hope that it will be useful,
11  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
12  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13  *  GNU General Public License for more details.
14  *  You should have received a copy of the GNU General Public License
15  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
16  */
17  
18 // SPDX-License-Identifier: GPLv3
19 
20 pragma solidity ^0.6.11;
21 pragma experimental ABIEncoderV2;
22 
23 interface IGasToken {
24     function freeUpTo(uint256) external returns (uint256);
25 }
26 
27 contract GasRefundable {
28     /// @notice Emits the new gas token information when it is set.
29     event SetGasToken(address _gasTokenAddress, GasTokenParameters _gasTokenParameters);
30 
31     struct GasTokenParameters {
32         uint256 freeCallGasCost;
33         uint256 gasRefundPerUnit;
34     }
35 
36     /// @dev Address of the gas token used to refund gas (default: CHI).
37     IGasToken private _gasToken = IGasToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
38     /// @dev Gas token parameters parameters used in the gas refund calcualtion (default: CHI).
39     GasTokenParameters private _gasTokenParameters = GasTokenParameters({freeCallGasCost: 14154, gasRefundPerUnit: 41130});
40 
41     /// @notice Refunds gas based on the amount of gas spent in the transaction and the gas token parameters.
42     modifier refundGas() {
43         uint256 gasStart = gasleft();
44         _;
45         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
46         _gasToken.freeUpTo((gasSpent + _gasTokenParameters.freeCallGasCost) / _gasTokenParameters.gasRefundPerUnit);
47     }
48 
49     /// @param _gasTokenAddress Address of the gas token used to refund gas.
50     /// @param _parameters Gas cost of the gas token free method call and amount of gas refunded per unit of gas token.
51     function _setGasToken(address _gasTokenAddress, GasTokenParameters memory _parameters) internal {
52         require(_gasTokenAddress != address(0), "gas token address is 0x0");
53         require(_parameters.freeCallGasCost != 0, "free call gas cost is 0");
54         require(_parameters.gasRefundPerUnit != 0, "gas refund per unit is 0");
55         _gasToken = IGasToken(_gasTokenAddress);
56         _gasTokenParameters.freeCallGasCost = _parameters.freeCallGasCost;
57         _gasTokenParameters.gasRefundPerUnit = _parameters.gasRefundPerUnit;
58         emit SetGasToken(_gasTokenAddress, _parameters);
59     }
60 
61     /// @return Address of the gas token used to refund gas.
62     function gasToken() external view returns (address) {
63         return address(_gasToken);
64     }
65 
66     /// @return Gas cost of the gas token free method call/Amount of gas refunded per unit of gas token.
67     function gasTokenParameters() external view returns (GasTokenParameters memory) {
68         return _gasTokenParameters;
69     }
70 }
71 
72 // File: localhost/interfaces/IERC20.sol
73 
74 /**
75  * @dev Interface of the ERC20 standard as defined in the EIP.
76  */
77 interface IERC20 {
78     /**
79      * @dev Returns the amount of tokens in existence.
80      */
81     function totalSupply() external view returns (uint256);
82 
83     /**
84      * @dev Returns the amount of tokens owned by `account`.
85      */
86     function balanceOf(address account) external view returns (uint256);
87 
88     /**
89      * @dev Moves `amount` tokens from the caller's account to `recipient`.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transfer(address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Returns the remaining number of tokens that `spender` will be
99      * allowed to spend on behalf of `owner` through {transferFrom}. This is
100      * zero by default.
101      *
102      * This value changes when {approve} or {transferFrom} are called.
103      */
104     function allowance(address owner, address spender) external view returns (uint256);
105 
106     /**
107      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * IMPORTANT: Beware that changing an allowance with this method brings the risk
112      * that someone may use both the old and the new allowance by unfortunate
113      * transaction ordering. One possible solution to mitigate this race
114      * condition is to first reduce the spender's allowance to 0 and set the
115      * desired value afterwards:
116      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address spender, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Moves `amount` tokens from `sender` to `recipient` using the
124      * allowance mechanism. `amount` is then deducted from the caller's
125      * allowance.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Emitted when `value` tokens are moved from one account (`from`) to
135      * another (`to`).
136      *
137      * Note that `value` may be zero.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     /**
142      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
143      * a call to {approve}. `value` is the new allowance.
144      */
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 // File: localhost/externals/SafeMath.sol
148 
149 /**
150  * @dev Wrappers over Solidity's arithmetic operations with added overflow
151  * checks.
152  *
153  * Arithmetic operations in Solidity wrap on overflow. This can easily result
154  * in bugs, because programmers usually assume that an overflow raises an
155  * error, which is the standard behavior in high level programming languages.
156  * `SafeMath` restores this intuition by reverting the transaction when an
157  * operation overflows.
158  *
159  * Using this library instead of the unchecked operations eliminates an entire
160  * class of bugs, so it's recommended to use it always.
161  */
162 library SafeMath {
163     /**
164      * @dev Returns the addition of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `+` operator.
168      *
169      * Requirements:
170      *
171      * - Addition cannot overflow.
172      */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         uint256 c = a + b;
175         require(c >= a, "SafeMath: addition overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         return sub(a, b, "SafeMath: subtraction overflow");
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      *
202      * - Subtraction cannot overflow.
203      */
204     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b <= a, errorMessage);
206         uint256 c = a - b;
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the multiplication of two unsigned integers, reverting on
213      * overflow.
214      *
215      * Counterpart to Solidity's `*` operator.
216      *
217      * Requirements:
218      *
219      * - Multiplication cannot overflow.
220      */
221     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223         // benefit is lost if 'b' is also tested.
224         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
225         if (a == 0) {
226             return 0;
227         }
228 
229         uint256 c = a * b;
230         require(c / a == b, "SafeMath: multiplication overflow");
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers. Reverts on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         return div(a, b, "SafeMath: division by zero");
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b > 0, errorMessage);
265         uint256 c = a / b;
266         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * Reverts when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
284         return mod(a, b, "SafeMath: modulo by zero");
285     }
286 
287     /**
288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289      * Reverts with custom message when dividing by zero.
290      *
291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
292      * opcode (which leaves remaining gas untouched) while Solidity uses an
293      * invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b != 0, errorMessage);
301         return a % b;
302     }
303 }
304 // File: localhost/externals/SafeERC20.sol
305 
306 
307 
308 
309 /**
310  * @title SafeERC20
311  * @dev Wrappers around ERC20 operations that throw on failure (when the token
312  * contract returns false). Tokens that return no value (and instead revert or
313  * throw on failure) are also supported, non-reverting calls are assumed to be
314  * successful.
315  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
316  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
317  */
318 library SafeERC20 {
319     using SafeMath for uint256;
320     using Address for address;
321 
322     function safeTransfer(IERC20 token, address to, uint256 value) internal {
323         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
324     }
325 
326     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
327         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
328     }
329 
330     /**
331      * @dev Deprecated. This function has issues similar to the ones found in
332      * {IERC20-approve}, and its usage is discouraged.
333      *
334      * Whenever possible, use {safeIncreaseAllowance} and
335      * {safeDecreaseAllowance} instead.
336      */
337     function safeApprove(IERC20 token, address spender, uint256 value) internal {
338         // safeApprove should only be called when setting an initial allowance,
339         // or when resetting it to zero. To increase and decrease it, use
340         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
341         // solhint-disable-next-line max-line-length
342         require((value == 0) || (token.allowance(address(this), spender) == 0),
343             "SafeERC20: approve from non-zero to non-zero allowance"
344         );
345         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
346     }
347 
348     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
349         uint256 newAllowance = token.allowance(address(this), spender).add(value);
350         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
351     }
352 
353     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
354         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
355         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
356     }
357 
358     /**
359      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
360      * on the return value: the return value is optional (but if data is returned, it must not be false).
361      * @param token The token targeted by the call.
362      * @param data The call data (encoded using abi.encode or one of its variants).
363      */
364     function _callOptionalReturn(IERC20 token, bytes memory data) internal {
365         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
366         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
367         // the target address contains contract code and also asserts for success in the low-level call.
368 
369         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
370         if (returndata.length > 0) { // Return data is optional
371             // solhint-disable-next-line max-line-length
372             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
373         }
374     }
375 }
376 // File: localhost/externals/Address.sol
377 
378 /**
379  * @dev Collection of functions related to the address type
380  */
381 library Address {
382     /**
383      * @dev Returns true if `account` is a contract.
384      *
385      * [IMPORTANT]
386      * ====
387      * It is unsafe to assume that an address for which this function returns
388      * false is an externally-owned account (EOA) and not a contract.
389      *
390      * Among others, `isContract` will return false for the following
391      * types of addresses:
392      *
393      *  - an externally-owned account
394      *  - a contract in construction
395      *  - an address where a contract will be created
396      *  - an address where a contract lived, but was destroyed
397      * ====
398      */
399     function isContract(address account) internal view returns (bool) {
400         // This method relies in extcodesize, which returns 0 for contracts in
401         // construction, since the code is only stored at the end of the
402         // constructor execution.
403 
404         uint256 size;
405         // solhint-disable-next-line no-inline-assembly
406         assembly { size := extcodesize(account) }
407         return size > 0;
408     }
409 
410     /**
411      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
412      * `recipient`, forwarding all available gas and reverting on errors.
413      *
414      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
415      * of certain opcodes, possibly making contracts go over the 2300 gas limit
416      * imposed by `transfer`, making them unable to receive funds via
417      * `transfer`. {sendValue} removes this limitation.
418      *
419      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
420      *
421      * IMPORTANT: because control is transferred to `recipient`, care must be
422      * taken to not create reentrancy vulnerabilities. Consider using
423      * {ReentrancyGuard} or the
424      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
425      */
426     function sendValue(address payable recipient, uint256 amount) internal {
427         require(address(this).balance >= amount, "Address: insufficient balance");
428 
429         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
430         (bool success, ) = recipient.call{ value: amount }("");
431         require(success, "Address: unable to send value, recipient may have reverted");
432     }
433 
434     /**
435      * @dev Performs a Solidity function call using a low level `call`. A
436      * plain`call` is an unsafe replacement for a function call: use this
437      * function instead.
438      *
439      * If `target` reverts with a revert reason, it is bubbled up by this
440      * function (like regular Solidity function calls).
441      *
442      * Returns the raw returned data. To convert to the expected return value,
443      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
444      *
445      * Requirements:
446      *
447      * - `target` must be a contract.
448      * - calling `target` with `data` must not revert.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
453       return functionCall(target, data, "Address: low-level call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
458      * `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
463         return _functionCallWithValue(target, data, 0, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but also transferring `value` wei to `target`.
469      *
470      * Requirements:
471      *
472      * - the calling contract must have an ETH balance of at least `value`.
473      * - the called Solidity function must be `payable`.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
478         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
483      * with `errorMessage` as a fallback revert reason when `target` reverts.
484      *
485      * _Available since v3.1._
486      */
487     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
488         require(address(this).balance >= value, "Address: insufficient balance for call");
489         return _functionCallWithValue(target, data, value, errorMessage);
490     }
491 
492     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
493         require(isContract(target), "Address: call to non-contract");
494 
495         // solhint-disable-next-line avoid-low-level-calls
496         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
497         if (success) {
498             return returndata;
499         } else {
500             // Look for revert reason and bubble it up if present
501             if (returndata.length > 0) {
502                 // The easiest way to bubble the revert reason is using memory via assembly
503 
504                 // solhint-disable-next-line no-inline-assembly
505                 assembly {
506                     let returndata_size := mload(returndata)
507                     revert(add(32, returndata), returndata_size)
508                 }
509             } else {
510                 revert(errorMessage);
511             }
512         }
513     }
514 }
515 // File: localhost/internals/transferrable.sol
516 
517 /**
518  *  Transferrable - The Consumer Contract Wallet
519  *  Copyright (C) 2019 The Contract Wallet Company Limited
520  *
521  *  This program is free software: you can redistribute it and/or modify
522  *  it under the terms of the GNU General Public License as published by
523  *  the Free Software Foundation, either version 3 of the License, or
524  *  (at your option) any later version.
525 
526  *  This program is distributed in the hope that it will be useful,
527  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
528  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
529  *  GNU General Public License for more details.
530 
531  *  You should have received a copy of the GNU General Public License
532  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
533  */
534 
535 
536 
537 
538 /// @title SafeTransfer, allowing contract to withdraw tokens accidentally sent to itself
539 contract Transferrable {
540     using Address for address payable;
541     using SafeERC20 for IERC20;
542 
543     /// @dev This function is used to move tokens sent accidentally to this contract method.
544     /// @dev The owner can chose the new destination address
545     /// @param _to is the recipient's address.
546     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
547     /// @param _amount is the amount to be transferred in base units.
548     function _safeTransfer(
549         address payable _to,
550         address _asset,
551         uint256 _amount
552     ) internal {
553         // address(0) is used to denote ETH
554         if (_asset == address(0)) {
555             _to.sendValue(_amount);
556         } else {
557             IERC20(_asset).safeTransfer(_to, _amount);
558         }
559     }
560 }
561 
562 // File: localhost/externals/initializable.sol
563 
564 
565 
566 /**
567  * @title Initializable
568  *
569  * @dev Helper contract to support initializer functions. To use it, replace
570  * the constructor with a function that has the `initializer` modifier.
571  * WARNING: Unlike constructors, initializer functions must be manually
572  * invoked. This applies both to deploying an Initializable contract, as well
573  * as extending an Initializable contract via inheritance.
574  * WARNING: When used with inheritance, manual care must be taken to not invoke
575  * a parent initializer twice, or ensure that all initializers are idempotent,
576  * because this is not dealt with automatically as with constructors.
577  */
578 contract Initializable {
579 
580   /**
581    * @dev Indicates that the contract has been initialized.
582    */
583   bool private initialized;
584 
585   /**
586    * @dev Indicates that the contract is in the process of being initialized.
587    */
588   bool private initializing;
589 
590   /**
591    * @dev Modifier to use in the initializer function of a contract.
592    */
593   modifier initializer() {
594     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
595 
596     bool isTopLevelCall = !initializing;
597     if (isTopLevelCall) {
598       initializing = true;
599       initialized = true;
600     }
601 
602     _;
603 
604     if (isTopLevelCall) {
605       initializing = false;
606     }
607   }
608 
609   /// @dev Returns true if and only if the function is running in the constructor
610   function isConstructor() private view returns (bool) {
611     // extcodesize checks the size of the code stored in an address, and
612     // address returns the current address. Since the code is still not
613     // deployed when running a constructor, any checks on its code size will
614     // yield zero, making it an effective way to detect if a contract is
615     // under construction or not.
616     address self = address(this);
617     uint256 cs;
618     assembly { cs := extcodesize(self) }
619     return cs == 0;
620   }
621 
622   // Reserved storage space to allow for layout changes in the future.
623   uint256[50] private ______gap;
624 }
625 
626 // File: localhost/internals/ownable.sol
627 
628 /**
629  *  Ownable - The Consumer Contract Wallet
630  *  Copyright (C) 2019 The Contract Wallet Company Limited
631  *
632  *  This program is free software: you can redistribute it and/or modify
633  *  it under the terms of the GNU General Public License as published by
634  *  the Free Software Foundation, either version 3 of the License, or
635  *  (at your option) any later version.
636 
637  *  This program is distributed in the hope that it will be useful,
638  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
639  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
640  *  GNU General Public License for more details.
641 
642  *  You should have received a copy of the GNU General Public License
643  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
644  */
645 
646 
647 
648 /// @title Ownable has an owner address and provides basic authorization control functions.
649 /// This contract is modified version of the MIT OpenZepplin Ownable contract
650 /// This contract allows for the transferOwnership operation to be made impossible
651 /// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
652 contract Ownable is Initializable {
653     event TransferredOwnership(address _from, address _to);
654     event LockedOwnership(address _locked);
655 
656     address payable private _owner;
657     bool private _isTransferable;
658 
659     /// @notice Reverts if called by any account other than the owner.
660     modifier onlyOwner() {
661         require(_isOwner(msg.sender), "sender is not an owner");
662         _;
663     }
664 
665     /// @notice Allows the current owner to transfer control of the contract to a new address.
666     /// @param _account address to transfer ownership to.
667     /// @param _transferable indicates whether to keep the ownership transferable.
668     function transferOwnership(address payable _account, bool _transferable) external onlyOwner {
669         // Require that the ownership is transferable.
670         require(_isTransferable, "ownership is not transferable");
671         // Require that the new owner is not the zero address.
672         require(_account != address(0), "owner cannot be set to zero address");
673         // Set the transferable flag to the value _transferable passed in.
674         _isTransferable = _transferable;
675         // Emit the LockedOwnership event if no longer transferable.
676         if (!_transferable) {
677             emit LockedOwnership(_account);
678         }
679         // Emit the ownership transfer event.
680         emit TransferredOwnership(_owner, _account);
681         // Set the owner to the provided address.
682         _owner = _account;
683     }
684 
685     /// @notice check if the ownership is transferable.
686     /// @return true if the ownership is transferable.
687     function isTransferable() external view returns (bool) {
688         return _isTransferable;
689     }
690 
691     /// @notice Allows the current owner to relinquish control of the contract.
692     /// @dev Renouncing to ownership will leave the contract without an owner and unusable.
693     /// @dev It will not be possible to call the functions with the `onlyOwner` modifier anymore.
694     function renounceOwnership() external onlyOwner {
695         // Require that the ownership is transferable.
696         require(_isTransferable, "ownership is not transferable");
697         // note that this could be terminal
698         _owner = address(0);
699 
700         emit TransferredOwnership(_owner, address(0));
701     }
702 
703     /// @notice Find out owner address
704     /// @return address of the owner.
705     function owner() public view returns (address payable) {
706         return _owner;
707     }
708 
709     /// @notice Sets the original owner of the contract and whether or not it is one time transferable.
710     function _initializeOwnable(address payable _account, bool _transferable) internal initializer {
711         _owner = _account;
712         _isTransferable = _transferable;
713         // Emit the LockedOwnership event if no longer transferable.
714         if (!_isTransferable) {
715             emit LockedOwnership(_account);
716         }
717         emit TransferredOwnership(address(0), _account);
718     }
719 
720     /// @notice Check if owner address
721     /// @return true if sender is the owner of the contract.
722     function _isOwner(address _address) internal view returns (bool) {
723         return _address == _owner;
724     }
725 }
726 
727 // File: localhost/interfaces/IController.sol
728 
729 
730 /// @title The IController interface provides access to the isController and isAdmin checks.
731 interface IController {
732     function isController(address) external view returns (bool);
733 
734     function isAdmin(address) external view returns (bool);
735 }
736 // File: localhost/controller.sol
737 
738 /**
739  *  Controller - The Consumer Contract Wallet
740  *  Copyright (C) 2019 The Contract Wallet Company Limited
741  *
742  *  This program is free software: you can redistribute it and/or modify
743  *  it under the terms of the GNU General Public License as published by
744  *  the Free Software Foundation, either version 3 of the License, or
745  *  (at your option) any later version.
746 
747  *  This program is distributed in the hope that it will be useful,
748  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
749  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
750  *  GNU General Public License for more details.
751 
752  *  You should have received a copy of the GNU General Public License
753  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
754  */
755 
756 
757 
758 
759 /// @title Controller stores a list of controller addresses that can be used for authentication in other contracts.
760 /// @notice The Controller implements a hierarchy of concepts, Owner, Admin, and the Controllers.
761 /// @dev Owner can change the Admins
762 /// @dev Admins and can the Controllers
763 /// @dev Controllers are used by the application.
764 contract Controller is IController, Ownable, Transferrable {
765     event AddedController(address _sender, address _controller);
766     event RemovedController(address _sender, address _controller);
767 
768     event AddedAdmin(address _sender, address _admin);
769     event RemovedAdmin(address _sender, address _admin);
770 
771     event Claimed(address _to, address _asset, uint256 _amount);
772 
773     event Stopped(address _sender);
774     event Started(address _sender);
775 
776     mapping(address => bool) private _isAdmin;
777     uint256 private _adminCount;
778 
779     mapping(address => bool) private _isController;
780     uint256 private _controllerCount;
781 
782     bool private _stopped;
783 
784     /// @notice Constructor initializes the owner with the provided address.
785     /// @param _ownerAddress_ address of the owner.
786     constructor(address payable _ownerAddress_) public {
787         _initializeOwnable(_ownerAddress_, false);
788     }
789 
790     /// @notice Checks if message sender is an admin.
791     modifier onlyAdmin() {
792         require(_isAdmin[msg.sender], "sender is not admin");
793         _;
794     }
795 
796     /// @notice Check if Owner or Admin
797     modifier onlyAdminOrOwner() {
798         require(_isOwner(msg.sender) || _isAdmin[msg.sender], "sender is not admin or owner");
799         _;
800     }
801 
802     /// @notice Check if controller is stopped
803     modifier notStopped() {
804         require(!isStopped(), "controller is stopped");
805         _;
806     }
807 
808     /// @notice Add a new admin to the list of admins.
809     /// @param _account address to add to the list of admins.
810     function addAdmin(address _account) external onlyOwner notStopped {
811         _addAdmin(_account);
812     }
813 
814     /// @notice Remove a admin from the list of admins.
815     /// @param _account address to remove from the list of admins.
816     function removeAdmin(address _account) external onlyOwner {
817         _removeAdmin(_account);
818     }
819 
820     /// @return the current number of admins.
821     function adminCount() external view returns (uint256) {
822         return _adminCount;
823     }
824 
825     /// @notice Add a new controller to the list of controllers.
826     /// @param _account address to add to the list of controllers.
827     function addController(address _account) external onlyAdminOrOwner notStopped {
828         _addController(_account);
829     }
830 
831     /// @notice Remove a controller from the list of controllers.
832     /// @param _account address to remove from the list of controllers.
833     function removeController(address _account) external onlyAdminOrOwner {
834         _removeController(_account);
835     }
836 
837     /// @notice count the Controllers
838     /// @return the current number of controllers.
839     function controllerCount() external view returns (uint256) {
840         return _controllerCount;
841     }
842 
843     /// @notice is an address an Admin?
844     /// @return true if the provided account is an admin.
845     function isAdmin(address _account) external override view notStopped returns (bool) {
846         return _isAdmin[_account];
847     }
848 
849     /// @notice is an address a Controller?
850     /// @return true if the provided account is a controller.
851     function isController(address _account) external override view notStopped returns (bool) {
852         return _isController[_account];
853     }
854 
855     /// @notice this function can be used to see if the controller has been stopped
856     /// @return true is the Controller has been stopped
857     function isStopped() public view returns (bool) {
858         return _stopped;
859     }
860 
861     /// @notice Internal-only function that adds a new admin.
862     function _addAdmin(address _account) private {
863         require(!_isAdmin[_account], "provided account is already an admin");
864         require(!_isController[_account], "provided account is already a controller");
865         require(!_isOwner(_account), "provided account is already the owner");
866         require(_account != address(0), "provided account is the zero address");
867         _isAdmin[_account] = true;
868         _adminCount++;
869         emit AddedAdmin(msg.sender, _account);
870     }
871 
872     /// @notice Internal-only function that removes an existing admin.
873     function _removeAdmin(address _account) private {
874         require(_isAdmin[_account], "provided account is not an admin");
875         _isAdmin[_account] = false;
876         _adminCount--;
877         emit RemovedAdmin(msg.sender, _account);
878     }
879 
880     /// @notice Internal-only function that adds a new controller.
881     function _addController(address _account) private {
882         require(!_isAdmin[_account], "provided account is already an admin");
883         require(!_isController[_account], "provided account is already a controller");
884         require(!_isOwner(_account), "provided account is already the owner");
885         require(_account != address(0), "provided account is the zero address");
886         _isController[_account] = true;
887         _controllerCount++;
888         emit AddedController(msg.sender, _account);
889     }
890 
891     /// @notice Internal-only function that removes an existing controller.
892     function _removeController(address _account) private {
893         require(_isController[_account], "provided account is not a controller");
894         _isController[_account] = false;
895         _controllerCount--;
896         emit RemovedController(msg.sender, _account);
897     }
898 
899     /// @notice stop our controllers and admins from being useable
900     function stop() external onlyAdminOrOwner {
901         _stopped = true;
902         emit Stopped(msg.sender);
903     }
904 
905     /// @notice start our controller again
906     function start() external onlyOwner {
907         _stopped = false;
908         emit Started(msg.sender);
909     }
910 
911     //// @notice Withdraw tokens from the smart contract to the specified account.
912     function claim(
913         address payable _to,
914         address _asset,
915         uint256 _amount
916     ) external onlyAdmin notStopped {
917         _safeTransfer(_to, _asset, _amount);
918         emit Claimed(_to, _asset, _amount);
919     }
920 }
921 
922 // File: localhost/interfaces/IPublicResolver.sol
923 
924 
925 
926 interface IPublicResolver {
927 
928     function addr(bytes32) external view returns (address);
929 
930 }
931 
932 // File: localhost/interfaces/IENS.sol
933 
934 
935 interface IENS {
936 
937     // Logged when the owner of a node assigns a new owner to a subnode.
938     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
939 
940     // Logged when the owner of a node transfers ownership to a new account.
941     event Transfer(bytes32 indexed node, address owner);
942 
943     // Logged when the resolver for a node changes.
944     event NewResolver(bytes32 indexed node, address resolver);
945 
946     // Logged when the TTL of a node changes
947     event NewTTL(bytes32 indexed node, uint64 ttl);
948 
949 
950     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
951     function setResolver(bytes32 node, address resolver) external;
952     function setOwner(bytes32 node, address owner) external;
953     function setTTL(bytes32 node, uint64 ttl) external;
954     function owner(bytes32 node) external view returns (address);
955     function resolver(bytes32 node) external view returns (address);
956     function ttl(bytes32 node) external view returns (uint64);
957 
958 }
959 
960 
961 // File: localhost/internals/ensResolvable.sol
962 
963 /**
964  *  ENSResolvable - The Consumer Contract Wallet
965  *  Copyright (C) 2019 The Contract Wallet Company Limited
966  *
967  *  This program is free software: you can redistribute it and/or modify
968  *  it under the terms of the GNU General Public License as published by
969  *  the Free Software Foundation, either version 3 of the License, or
970  *  (at your option) any later version.
971 
972  *  This program is distributed in the hope that it will be useful,
973  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
974  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
975  *  GNU General Public License for more details.
976 
977  *  You should have received a copy of the GNU General Public License
978  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
979  */
980 
981 
982 
983 
984 ///@title ENSResolvable - Ethereum Name Service Resolver
985 ///@notice contract should be used to get an address for an ENS node
986 contract ENSResolvable is Initializable {
987     /// @dev Address of the ENS registry contract set to the default ENS registry address.
988     address private _ensRegistry = address(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);
989 
990     /// @notice Checks if the contract has been initialized succesfully i.e. the ENS registry has been set.
991     modifier initialized() {
992         require(_ensRegistry != address(0), "ENSResolvable not initialized");
993         _;
994     }
995 
996     /// @return Current address of the ENS registry contract.
997     function ensRegistry() public view returns (address) {
998         return _ensRegistry;
999     }
1000 
1001     /// @notice Helper function used to get the address of a node.
1002     /// @param _node of the ENS entry that needs resolving.
1003     /// @return The address of the resolved ENS node.
1004     function _ensResolve(bytes32 _node) internal view initialized returns (address) {
1005         return IPublicResolver(IENS(_ensRegistry).resolver(_node)).addr(_node);
1006     }
1007 
1008     /// @param _ensReg is the ENS registry used.
1009     function _initializeENSResolvable(address _ensReg) internal initializer {
1010         // Set ENS registry or use default
1011         if (_ensReg != address(0)) {
1012             _ensRegistry = _ensReg;
1013         }
1014     }
1015 }
1016 
1017 // File: localhost/internals/controllable.sol
1018 
1019 /**
1020  *  Controllable - The Consumer Contract Wallet
1021  *  Copyright (C) 2019 The Contract Wallet Company Limited
1022  *
1023  *  This program is free software: you can redistribute it and/or modify
1024  *  it under the terms of the GNU General Public License as published by
1025  *  the Free Software Foundation, either version 3 of the License, or
1026  *  (at your option) any later version.
1027 
1028  *  This program is distributed in the hope that it will be useful,
1029  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
1030  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1031  *  GNU General Public License for more details.
1032 
1033  *  You should have received a copy of the GNU General Public License
1034  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
1035  */
1036 
1037 
1038 
1039 
1040 /// @title Controllable implements access control functionality of the Controller found via ENS.
1041 contract Controllable is ENSResolvable {
1042     // Default values for mainnet ENS
1043     // controller.tokencard.eth
1044     bytes32 private constant _DEFAULT_CONTROLLER_NODE = 0x7f2ce995617d2816b426c5c8698c5ec2952f7a34bb10f38326f74933d5893697;
1045 
1046     /// @dev Is the registered ENS node identifying the controller contract.
1047     bytes32 private _controllerNode = _DEFAULT_CONTROLLER_NODE;
1048 
1049     /// @notice Checks if message sender is a controller.
1050     modifier onlyController() {
1051         require(_isController(msg.sender), "sender is not a controller");
1052         _;
1053     }
1054 
1055     /// @notice Checks if message sender is an admin.
1056     modifier onlyAdmin() {
1057         require(_isAdmin(msg.sender), "sender is not an admin");
1058         _;
1059     }
1060 
1061     /// @return the controller node registered in ENS.
1062     function controllerNode() public view returns (bytes32) {
1063         return _controllerNode;
1064     }
1065 
1066     /// @notice Initializes the controller contract object.
1067     /// @param _controllerNode_ is the ENS node of the Controller.
1068     /// @dev pass in bytes32(0) to use the default, production node labels for ENS
1069     function _initializeControllable(bytes32 _controllerNode_) internal initializer {
1070         // Set controllerNode or use default
1071         if (_controllerNode_ != bytes32(0)) {
1072             _controllerNode = _controllerNode_;
1073         }
1074     }
1075 
1076     /// @return true if the provided account is a controller.
1077     function _isController(address _account) internal view returns (bool) {
1078         return IController(_ensResolve(_controllerNode)).isController(_account);
1079     }
1080 
1081     /// @return true if the provided account is an admin.
1082     function _isAdmin(address _account) internal view returns (bool) {
1083         return IController(_ensResolve(_controllerNode)).isAdmin(_account);
1084     }
1085 }
1086 
1087 // File: localhost/gasProxy.sol
1088 
1089 /**
1090  *  Copyright (C) 2019 The Contract Wallet Company Limited
1091  *
1092  *  This program is free software: you can redistribute it and/or modify
1093  *  it under the terms of the GNU General Public License as published by
1094  *  the Free Software Foundation, either version 3 of the License, or
1095  *  (at your option) any later version.
1096  *  This program is distributed in the hope that it will be useful,
1097  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
1098  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1099  *  GNU General Public License for more details.
1100  *  You should have received a copy of the GNU General Public License
1101  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
1102  */
1103 
1104 
1105 contract GasProxy is Controllable, GasRefundable {
1106     /// @notice Emits the transaction executed by the controller.
1107     event ExecutedTransaction(address _destination, uint256 _value, bytes _data, bytes _returnData);
1108 
1109     /// @param _ens_ is the address of the ENS registry.
1110     /// @param _controllerNode_ ENS node of the controller contract.
1111     constructor(address _ens_, bytes32 _controllerNode_) public {
1112         _initializeENSResolvable(_ens_);
1113         _initializeControllable(_controllerNode_);
1114     }
1115 
1116     /// @param _gasTokenAddress Address of the gas token used to refund gas.
1117     /// @param _parameters Gas cost of the gas token free method call and amount of gas refunded per unit of gas token.
1118     function setGasToken(address _gasTokenAddress, GasTokenParameters calldata _parameters) external onlyAdmin {
1119         _setGasToken(_gasTokenAddress, _parameters);
1120     }
1121 
1122     /// @notice Executes a controller operation and refunds gas using gas tokens.
1123     /// @param _destination Destination address of the executed transaction.
1124     /// @param _value Amount of ETH (wei) to be sent together with the transaction.
1125     /// @param _data Data payload of the controller transaction.
1126     function executeTransaction(
1127         address _destination,
1128         uint256 _value,
1129         bytes calldata _data
1130     ) external payable onlyController refundGas returns (bytes memory) {
1131         (bool success, bytes memory returnData) = _destination.call{value: _value}(_data);
1132         require(success, "external call failed");
1133         emit ExecutedTransaction(_destination, _value, _data, returnData);
1134         return returnData;
1135     }
1136 }