1 // Sources flattened with hardhat v2.0.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/GSN/Context.sol@v3.3.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.3.0
32 
33 pragma solidity >=0.6.0 <0.8.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () internal {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 
100 // File @animoca/ethereum-contracts-core_library/contracts/access/WhitelistedOperators.sol@v4.0.3
101 
102 pragma solidity 0.6.8;
103 
104 contract WhitelistedOperators is Ownable {
105     mapping(address => bool) internal _whitelistedOperators;
106 
107     event WhitelistedOperator(address operator, bool enabled);
108 
109     /// @notice Enable or disable address operator access
110     /// @param operator address that will be given/removed operator right.
111     /// @param enabled set whether the operator is enabled or disabled.
112     function whitelistOperator(address operator, bool enabled) external onlyOwner {
113         _whitelistedOperators[operator] = enabled;
114         emit WhitelistedOperator(operator, enabled);
115     }
116 
117     /// @notice check whether address `who` is given operator rights.
118     /// @param who The address to query.
119     /// @return whether the address is whitelisted operator
120     function isOperator(address who) public view returns (bool) {
121         return _whitelistedOperators[who];
122     }
123 }
124 
125 
126 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.3.0
127 
128 pragma solidity >=0.6.0 <0.8.0;
129 
130 /**
131  * @dev Interface of the ERC165 standard, as defined in the
132  * https://eips.ethereum.org/EIPS/eip-165[EIP].
133  *
134  * Implementers can declare support of contract interfaces, which can then be
135  * queried by others ({ERC165Checker}).
136  *
137  * For an implementation, see {ERC165}.
138  */
139 interface IERC165 {
140     /**
141      * @dev Returns true if this contract implements the interface defined by
142      * `interfaceId`. See the corresponding
143      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
144      * to learn more about how these ids are created.
145      *
146      * This function call must use less than 30 000 gas.
147      */
148     function supportsInterface(bytes4 interfaceId) external view returns (bool);
149 }
150 
151 
152 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.3.0
153 
154 pragma solidity >=0.6.0 <0.8.0;
155 
156 /**
157  * @dev Implementation of the {IERC165} interface.
158  *
159  * Contracts may inherit from this and call {_registerInterface} to declare
160  * their support of an interface.
161  */
162 abstract contract ERC165 is IERC165 {
163     /*
164      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
165      */
166     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
167 
168     /**
169      * @dev Mapping of interface ids to whether or not it's supported.
170      */
171     mapping(bytes4 => bool) private _supportedInterfaces;
172 
173     constructor () internal {
174         // Derived contracts need only register support for their own interfaces,
175         // we register support for ERC165 itself here
176         _registerInterface(_INTERFACE_ID_ERC165);
177     }
178 
179     /**
180      * @dev See {IERC165-supportsInterface}.
181      *
182      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
183      */
184     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
185         return _supportedInterfaces[interfaceId];
186     }
187 
188     /**
189      * @dev Registers the contract as an implementer of the interface defined by
190      * `interfaceId`. Support of the actual ERC165 interface is automatic and
191      * registering its interface id is not required.
192      *
193      * See {IERC165-supportsInterface}.
194      *
195      * Requirements:
196      *
197      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
198      */
199     function _registerInterface(bytes4 interfaceId) internal virtual {
200         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
201         _supportedInterfaces[interfaceId] = true;
202     }
203 }
204 
205 
206 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
207 
208 pragma solidity >=0.6.0 <0.8.0;
209 
210 /**
211  * @dev Wrappers over Solidity's arithmetic operations with added overflow
212  * checks.
213  *
214  * Arithmetic operations in Solidity wrap on overflow. This can easily result
215  * in bugs, because programmers usually assume that an overflow raises an
216  * error, which is the standard behavior in high level programming languages.
217  * `SafeMath` restores this intuition by reverting the transaction when an
218  * operation overflows.
219  *
220  * Using this library instead of the unchecked operations eliminates an entire
221  * class of bugs, so it's recommended to use it always.
222  */
223 library SafeMath {
224     /**
225      * @dev Returns the addition of two unsigned integers, reverting on
226      * overflow.
227      *
228      * Counterpart to Solidity's `+` operator.
229      *
230      * Requirements:
231      *
232      * - Addition cannot overflow.
233      */
234     function add(uint256 a, uint256 b) internal pure returns (uint256) {
235         uint256 c = a + b;
236         require(c >= a, "SafeMath: addition overflow");
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting on
243      * overflow (when the result is negative).
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
252         return sub(a, b, "SafeMath: subtraction overflow");
253     }
254 
255     /**
256      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
257      * overflow (when the result is negative).
258      *
259      * Counterpart to Solidity's `-` operator.
260      *
261      * Requirements:
262      *
263      * - Subtraction cannot overflow.
264      */
265     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b <= a, errorMessage);
267         uint256 c = a - b;
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the multiplication of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `*` operator.
277      *
278      * Requirements:
279      *
280      * - Multiplication cannot overflow.
281      */
282     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
284         // benefit is lost if 'b' is also tested.
285         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
286         if (a == 0) {
287             return 0;
288         }
289 
290         uint256 c = a * b;
291         require(c / a == b, "SafeMath: multiplication overflow");
292 
293         return c;
294     }
295 
296     /**
297      * @dev Returns the integer division of two unsigned integers. Reverts on
298      * division by zero. The result is rounded towards zero.
299      *
300      * Counterpart to Solidity's `/` operator. Note: this function uses a
301      * `revert` opcode (which leaves remaining gas untouched) while Solidity
302      * uses an invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function div(uint256 a, uint256 b) internal pure returns (uint256) {
309         return div(a, b, "SafeMath: division by zero");
310     }
311 
312     /**
313      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
314      * division by zero. The result is rounded towards zero.
315      *
316      * Counterpart to Solidity's `/` operator. Note: this function uses a
317      * `revert` opcode (which leaves remaining gas untouched) while Solidity
318      * uses an invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
325         require(b > 0, errorMessage);
326         uint256 c = a / b;
327         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
334      * Reverts when dividing by zero.
335      *
336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
337      * opcode (which leaves remaining gas untouched) while Solidity uses an
338      * invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      *
342      * - The divisor cannot be zero.
343      */
344     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
345         return mod(a, b, "SafeMath: modulo by zero");
346     }
347 
348     /**
349      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
350      * Reverts with custom message when dividing by zero.
351      *
352      * Counterpart to Solidity's `%` operator. This function uses a `revert`
353      * opcode (which leaves remaining gas untouched) while Solidity uses an
354      * invalid opcode to revert (consuming all remaining gas).
355      *
356      * Requirements:
357      *
358      * - The divisor cannot be zero.
359      */
360     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         require(b != 0, errorMessage);
362         return a % b;
363     }
364 }
365 
366 
367 // File @openzeppelin/contracts/utils/Address.sol@v3.3.0
368 
369 pragma solidity >=0.6.2 <0.8.0;
370 
371 /**
372  * @dev Collection of functions related to the address type
373  */
374 library Address {
375     /**
376      * @dev Returns true if `account` is a contract.
377      *
378      * [IMPORTANT]
379      * ====
380      * It is unsafe to assume that an address for which this function returns
381      * false is an externally-owned account (EOA) and not a contract.
382      *
383      * Among others, `isContract` will return false for the following
384      * types of addresses:
385      *
386      *  - an externally-owned account
387      *  - a contract in construction
388      *  - an address where a contract will be created
389      *  - an address where a contract lived, but was destroyed
390      * ====
391      */
392     function isContract(address account) internal view returns (bool) {
393         // This method relies on extcodesize, which returns 0 for contracts in
394         // construction, since the code is only stored at the end of the
395         // constructor execution.
396 
397         uint256 size;
398         // solhint-disable-next-line no-inline-assembly
399         assembly { size := extcodesize(account) }
400         return size > 0;
401     }
402 
403     /**
404      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
405      * `recipient`, forwarding all available gas and reverting on errors.
406      *
407      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
408      * of certain opcodes, possibly making contracts go over the 2300 gas limit
409      * imposed by `transfer`, making them unable to receive funds via
410      * `transfer`. {sendValue} removes this limitation.
411      *
412      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
413      *
414      * IMPORTANT: because control is transferred to `recipient`, care must be
415      * taken to not create reentrancy vulnerabilities. Consider using
416      * {ReentrancyGuard} or the
417      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
418      */
419     function sendValue(address payable recipient, uint256 amount) internal {
420         require(address(this).balance >= amount, "Address: insufficient balance");
421 
422         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
423         (bool success, ) = recipient.call{ value: amount }("");
424         require(success, "Address: unable to send value, recipient may have reverted");
425     }
426 
427     /**
428      * @dev Performs a Solidity function call using a low level `call`. A
429      * plain`call` is an unsafe replacement for a function call: use this
430      * function instead.
431      *
432      * If `target` reverts with a revert reason, it is bubbled up by this
433      * function (like regular Solidity function calls).
434      *
435      * Returns the raw returned data. To convert to the expected return value,
436      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
437      *
438      * Requirements:
439      *
440      * - `target` must be a contract.
441      * - calling `target` with `data` must not revert.
442      *
443      * _Available since v3.1._
444      */
445     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
446       return functionCall(target, data, "Address: low-level call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
451      * `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
456         return functionCallWithValue(target, data, 0, errorMessage);
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461      * but also transferring `value` wei to `target`.
462      *
463      * Requirements:
464      *
465      * - the calling contract must have an ETH balance of at least `value`.
466      * - the called Solidity function must be `payable`.
467      *
468      * _Available since v3.1._
469      */
470     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
471         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
476      * with `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
481         require(address(this).balance >= value, "Address: insufficient balance for call");
482         require(isContract(target), "Address: call to non-contract");
483 
484         // solhint-disable-next-line avoid-low-level-calls
485         (bool success, bytes memory returndata) = target.call{ value: value }(data);
486         return _verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but performing a static call.
492      *
493      * _Available since v3.3._
494      */
495     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
496         return functionStaticCall(target, data, "Address: low-level static call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
501      * but performing a static call.
502      *
503      * _Available since v3.3._
504      */
505     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
506         require(isContract(target), "Address: static call to non-contract");
507 
508         // solhint-disable-next-line avoid-low-level-calls
509         (bool success, bytes memory returndata) = target.staticcall(data);
510         return _verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
514         if (success) {
515             return returndata;
516         } else {
517             // Look for revert reason and bubble it up if present
518             if (returndata.length > 0) {
519                 // The easiest way to bubble the revert reason is using memory via assembly
520 
521                 // solhint-disable-next-line no-inline-assembly
522                 assembly {
523                     let returndata_size := mload(returndata)
524                     revert(add(32, returndata), returndata_size)
525                 }
526             } else {
527                 revert(errorMessage);
528             }
529         }
530     }
531 }
532 
533 
534 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20.sol@v3.0.0
535 
536 /*
537 https://github.com/OpenZeppelin/openzeppelin-contracts
538 
539 The MIT License (MIT)
540 
541 Copyright (c) 2016-2019 zOS Global Limited
542 
543 Permission is hereby granted, free of charge, to any person obtaining
544 a copy of this software and associated documentation files (the
545 "Software"), to deal in the Software without restriction, including
546 without limitation the rights to use, copy, modify, merge, publish,
547 distribute, sublicense, and/or sell copies of the Software, and to
548 permit persons to whom the Software is furnished to do so, subject to
549 the following conditions:
550 
551 The above copyright notice and this permission notice shall be included
552 in all copies or substantial portions of the Software.
553 
554 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
555 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
556 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
557 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
558 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
559 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
560 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
561 */
562 
563 pragma solidity 0.6.8;
564 
565 /**
566  * @dev Interface of the ERC20 standard as defined in the EIP.
567  */
568 interface IERC20 {
569 
570     /**
571      * @dev Emitted when `value` tokens are moved from one account (`from`) to
572      * another (`to`).
573      *
574      * Note that `value` may be zero.
575      */
576     event Transfer(
577         address indexed _from,
578         address indexed _to,
579         uint256 _value
580     );
581 
582     /**
583      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
584      * a call to {approve}. `value` is the new allowance.
585      */
586     event Approval(
587         address indexed _owner,
588         address indexed _spender,
589         uint256 _value
590     );
591 
592     /**
593      * @dev Returns the amount of tokens in existence.
594      */
595     function totalSupply() external view returns (uint256);
596 
597     /**
598      * @dev Returns the amount of tokens owned by `account`.
599      */
600     function balanceOf(address account) external view returns (uint256);
601 
602     /**
603      * @dev Moves `amount` tokens from the caller's account to `recipient`.
604      *
605      * Returns a boolean value indicating whether the operation succeeded.
606      *
607      * Emits a {Transfer} event.
608      */
609     function transfer(address recipient, uint256 amount) external returns (bool);
610 
611     /**
612      * @dev Returns the remaining number of tokens that `spender` will be
613      * allowed to spend on behalf of `owner` through {transferFrom}. This is
614      * zero by default.
615      *
616      * This value changes when {approve} or {transferFrom} are called.
617      */
618     function allowance(address owner, address spender) external view returns (uint256);
619 
620     /**
621      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
622      *
623      * Returns a boolean value indicating whether the operation succeeded.
624      *
625      * IMPORTANT: Beware that changing an allowance with this method brings the risk
626      * that someone may use both the old and the new allowance by unfortunate
627      * transaction ordering. One possible solution to mitigate this race
628      * condition is to first reduce the spender's allowance to 0 and set the
629      * desired value afterwards:
630      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address spender, uint256 amount) external returns (bool);
635 
636     /**
637      * @dev Moves `amount` tokens from `sender` to `recipient` using the
638      * allowance mechanism. `amount` is then deducted from the caller's
639      * allowance.
640      *
641      * Returns a boolean value indicating whether the operation succeeded.
642      *
643      * Emits a {Transfer} event.
644      */
645     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
646 }
647 
648 
649 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20Detailed.sol@v3.0.0
650 
651 /*
652 https://github.com/OpenZeppelin/openzeppelin-contracts
653 
654 The MIT License (MIT)
655 
656 Copyright (c) 2016-2019 zOS Global Limited
657 
658 Permission is hereby granted, free of charge, to any person obtaining
659 a copy of this software and associated documentation files (the
660 "Software"), to deal in the Software without restriction, including
661 without limitation the rights to use, copy, modify, merge, publish,
662 distribute, sublicense, and/or sell copies of the Software, and to
663 permit persons to whom the Software is furnished to do so, subject to
664 the following conditions:
665 
666 The above copyright notice and this permission notice shall be included
667 in all copies or substantial portions of the Software.
668 
669 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
670 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
671 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
672 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
673 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
674 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
675 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
676 */
677 
678 pragma solidity 0.6.8;
679 
680 /**
681  * @dev Interface for commonly used additional ERC20 interfaces
682  */
683 interface IERC20Detailed {
684 
685     /**
686      * @dev Returns the name of the token.
687      */
688     function name() external view returns (string memory);
689 
690     /**
691      * @dev Returns the symbol of the token, usually a shorter version of the
692      * name.
693      */
694     function symbol() external view returns (string memory);
695 
696     /**
697      * @dev Returns the number of decimals used to get its user representation.
698      * For example, if `decimals` equals `2`, a balance of `505` tokens should
699      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
700      *
701      * Tokens usually opt for a value of 18, imitating the relationship between
702      * Ether and Wei. This is the value {ERC20} uses.
703      *
704      * NOTE: This information is only used for _display_ purposes: it in
705      * no way affects any of the arithmetic of the contract, including
706      * {IERC20-balanceOf} and {IERC20-transfer}.
707      */
708     function decimals() external view returns (uint8);
709 }
710 
711 
712 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20Allowance.sol@v3.0.0
713 
714 pragma solidity 0.6.8;
715 
716 /**
717  * @dev Interface for additional ERC20 allowance features
718  */
719 interface IERC20Allowance {
720 
721     /**
722      * @dev Atomically increases the allowance granted to `spender` by the caller.
723      *
724      * This is an alternative to {approve} that can be used as a mitigation for
725      * problems described in {IERC20-approve}.
726      *
727      * Emits an {Approval} event indicating the updated allowance.
728      *
729      * Requirements:
730      *
731      * - `spender` cannot be the zero address.
732      */
733     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
734 
735     /**
736      * @dev Atomically decreases the allowance granted to `spender` by the caller.
737      *
738      * This is an alternative to {approve} that can be used as a mitigation for
739      * problems described in {IERC20-approve}.
740      *
741      * Emits an {Approval} event indicating the updated allowance.
742      *
743      * Requirements:
744      *
745      * - `spender` cannot be the zero address.
746      * - `spender` must have allowance for the caller of at least
747      * `subtractedValue`.
748      */
749     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
750 
751 }
752 
753 
754 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/ERC20.sol@v3.0.0
755 
756 /*
757 https://github.com/OpenZeppelin/openzeppelin-contracts
758 
759 The MIT License (MIT)
760 
761 Copyright (c) 2016-2019 zOS Global Limited
762 
763 Permission is hereby granted, free of charge, to any person obtaining
764 a copy of this software and associated documentation files (the
765 "Software"), to deal in the Software without restriction, including
766 without limitation the rights to use, copy, modify, merge, publish,
767 distribute, sublicense, and/or sell copies of the Software, and to
768 permit persons to whom the Software is furnished to do so, subject to
769 the following conditions:
770 
771 The above copyright notice and this permission notice shall be included
772 in all copies or substantial portions of the Software.
773 
774 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
775 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
776 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
777 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
778 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
779 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
780 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
781 */
782 
783 pragma solidity 0.6.8;
784 
785 
786 
787 
788 
789 
790 
791 /**
792  * @dev Implementation of the {IERC20} interface.
793  *
794  * This implementation is agnostic to the way tokens are created. This means
795  * that a supply mechanism has to be added in a derived contract using {_mint}.
796  * For a generic mechanism see {ERC20MinterPauser}.
797  *
798  * TIP: For a detailed writeup see our guide
799  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
800  * to implement supply mechanisms].
801  *
802  * We have followed general OpenZeppelin guidelines: functions revert instead
803  * of returning `false` on failure. This behavior is nonetheless conventional
804  * and does not conflict with the expectations of ERC20 applications.
805  *
806  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
807  * This allows applications to reconstruct the allowance for all accounts just
808  * by listening to said events. Other implementations of the EIP may not emit
809  * these events, as it isn't required by the specification.
810  *
811  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
812  * functions have been added to mitigate the well-known issues around setting
813  * allowances. See {IERC20-approve}.
814  */
815 abstract contract ERC20 is ERC165, Context, IERC20, IERC20Detailed, IERC20Allowance {
816 
817     using SafeMath for uint256;
818     using Address for address;
819 
820     mapping (address => uint256) internal _balances;
821     mapping (address => mapping (address => uint256)) internal _allowances;
822     uint256 internal _totalSupply;
823 
824     constructor() internal {
825         _registerInterface(type(IERC20).interfaceId);
826         _registerInterface(type(IERC20Detailed).interfaceId);
827         _registerInterface(type(IERC20Allowance).interfaceId);
828 
829         // ERC20Name interfaceId: bytes4(keccak256("name()"))
830         _registerInterface(0x06fdde03);
831         // ERC20Symbol interfaceId: bytes4(keccak256("symbol()"))
832         _registerInterface(0x95d89b41);
833         // ERC20Decimals interfaceId: bytes4(keccak256("decimals()"))
834         _registerInterface(0x313ce567);
835     }
836 
837 /////////////////////////////////////////// ERC20 ///////////////////////////////////////
838 
839     /**
840      * @dev See {IERC20-totalSupply}.
841      */
842     function totalSupply() public view override returns (uint256) {
843         return _totalSupply;
844     }
845 
846     /**
847      * @dev See {IERC20-balanceOf}.
848      */
849     function balanceOf(address account) public view override returns (uint256) {
850         return _balances[account];
851     }
852 
853     /**
854      * @dev See {IERC20-transfer}.
855      *
856      * Requirements:
857      *
858      * - `recipient` cannot be the zero address.
859      * - the caller must have a balance of at least `amount`.
860      */
861     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
862         _transfer(_msgSender(), recipient, amount);
863         return true;
864     }
865 
866     /**
867      * @dev See {IERC20-allowance}.
868      */
869     function allowance(address owner, address spender) public view virtual override returns (uint256) {
870         return _allowances[owner][spender];
871     }
872 
873     /**
874      * @dev See {IERC20-approve}.
875      *
876      * Requirements:
877      *
878      * - `spender` cannot be the zero address.
879      */
880     function approve(address spender, uint256 amount) public virtual override returns (bool) {
881         _approve(_msgSender(), spender, amount);
882         return true;
883     }
884 
885     /**
886      * @dev See {IERC20-transferFrom}.
887      *
888      * Emits an {Approval} event indicating the updated allowance. This is not
889      * required by the EIP. See the note at the beginning of {ERC20};
890      *
891      * Requirements:
892      * - `sender` and `recipient` cannot be the zero address.
893      * - `sender` must have a balance of at least `amount`.
894      * - the caller must have allowance for ``sender``'s tokens of at least
895      * `amount`.
896      */
897     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
898         _transfer(sender, recipient, amount);
899         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
900         return true;
901     }
902 
903 /////////////////////////////////////////// ERC20Allowance ///////////////////////////////////////
904 
905     /**
906      * @dev See {IERC20Allowance-increaseAllowance}.
907      */
908     function increaseAllowance(
909         address spender,
910         uint256 addedValue
911     ) public virtual override returns (bool)
912     {
913         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
914         return true;
915     }
916 
917     /**
918      * @dev See {IERC20Allowance-decreaseAllowance}.
919      */
920     function decreaseAllowance(
921         address spender,
922         uint256 subtractedValue
923     ) public virtual override returns (bool)
924     {
925         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
926         return true;
927     }
928 
929 /////////////////////////////////////////// Internal Functions ///////////////////////////////////////
930 
931     /**
932      * @dev Moves tokens `amount` from `sender` to `recipient`.
933      *
934      * This is internal function is equivalent to {transfer}, and can be used to
935      * e.g. implement automatic token fees, slashing mechanisms, etc.
936      *
937      * Emits a {Transfer} event.
938      *
939      * Requirements:
940      *
941      * - `sender` cannot be the zero address.
942      * - `recipient` cannot be the zero address.
943      * - `sender` must have a balance of at least `amount`.
944      */
945     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
946         require(sender != address(0), "ERC20: transfer from the zero address");
947         require(recipient != address(0), "ERC20: transfer to the zero address");
948 
949         _beforeTokenTransfer(sender, recipient, amount);
950 
951         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
952         _balances[recipient] = _balances[recipient].add(amount);
953         emit Transfer(sender, recipient, amount);
954     }
955 
956     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
957      * the total supply.
958      *
959      * Emits a {Transfer} event with `from` set to the zero address.
960      *
961      * Requirements
962      *
963      * - `to` cannot be the zero address.
964      */
965     function _mint(address account, uint256 amount) internal virtual {
966         require(account != address(0), "ERC20: mint to the zero address");
967 
968         _beforeTokenTransfer(address(0), account, amount);
969 
970         _totalSupply = _totalSupply.add(amount);
971         _balances[account] = _balances[account].add(amount);
972         emit Transfer(address(0), account, amount);
973     }
974 
975     /**
976      * @dev Destroys `amount` tokens from `account`, reducing the
977      * total supply.
978      *
979      * Emits a {Transfer} event with `to` set to the zero address.
980      *
981      * Requirements
982      *
983      * - `account` cannot be the zero address.
984      * - `account` must have at least `amount` tokens.
985      */
986     function _burn(address account, uint256 amount) internal virtual {
987         require(account != address(0), "ERC20: burn from the zero address");
988 
989         _beforeTokenTransfer(account, address(0), amount);
990 
991         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
992         _totalSupply = _totalSupply.sub(amount);
993         emit Transfer(account, address(0), amount);
994     }
995 
996     /**
997      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
998      *
999      * This is internal function is equivalent to `approve`, and can be used to
1000      * e.g. set automatic allowances for certain subsystems, etc.
1001      *
1002      * Emits an {Approval} event.
1003      *
1004      * Requirements:
1005      *
1006      * - `owner` cannot be the zero address.
1007      * - `spender` cannot be the zero address.
1008      */
1009     function _approve(address owner, address spender, uint256 amount) internal virtual {
1010         require(owner != address(0), "ERC20: approve from the zero address");
1011         require(spender != address(0), "ERC20: approve to the zero address");
1012 
1013         _allowances[owner][spender] = amount;
1014         emit Approval(owner, spender, amount);
1015     }
1016 
1017 /////////////////////////////////////////// Hooks ///////////////////////////////////////
1018 
1019     /**
1020      * @dev Hook that is called before any transfer of tokens. This includes
1021      * minting and burning.
1022      *
1023      * Calling conditions:
1024      *
1025      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1026      * will be to transferred to `to`.
1027      * - when `from` is zero, `amount` tokens will be minted for `to`.
1028      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1029      * - `from` and `to` are never both zero.
1030      */
1031     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1032 }
1033 
1034 
1035 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/ERC20WithOperators.sol@v3.0.0
1036 
1037 pragma solidity 0.6.8;
1038 
1039 
1040 abstract contract ERC20WithOperators is ERC20, WhitelistedOperators {
1041 
1042     /**
1043      * NOTICE
1044      * This override will allow *any* whitelisted operator to be able to
1045      * transfer unresitricted amounts of ERC20WithOperators-based tokens from 'sender'
1046      * to 'recipient'. Care must be taken to ensure to integrity of the
1047      * whitelisted operator list.
1048      */
1049     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1050         address msgSender = _msgSender();
1051 
1052         // bypass the internal allowance manipulation and checks for the
1053         // whitelisted operator (i.e. _msgSender()). as a side-effect, the
1054         // 'Approval' event will not be emitted since the allowance was not
1055         // updated.
1056         if (!isOperator(msgSender)) {
1057             _approve(sender, msgSender, allowance(sender, msgSender).sub(amount));
1058         }
1059 
1060         _transfer(sender, recipient, amount);
1061         return true;
1062     }
1063 
1064     function allowance(address owner, address spender) public override view returns (uint256) {
1065         if (isOperator(spender)) {
1066             // allow the front-end to determine whether or not an approval is
1067             // necessary, given that the whitelisted operator status of the
1068             // spender is unknown. A call to WhitelistedOperators::isOperator()
1069             // is more direct, but we want to expose a mechanism by which to
1070             // check through the ERC20 interface.
1071             return type(uint256).max;
1072         } else {
1073             return super.allowance(owner, spender);
1074         }
1075     }
1076 
1077     function increaseAllowance(address spender, uint256 addedValue) public override returns (bool) {
1078         if (isOperator(spender)) {
1079             // bypass the internal allowance manipulation and checks for the
1080             // whitelisted operator (i.e. spender). as a side-effect, the
1081             // 'Approval' event will not be emitted since the allowance was not
1082             // updated.
1083             return true;
1084         } else {
1085             return super.increaseAllowance(spender, addedValue);
1086         }
1087     }
1088 
1089     function decreaseAllowance(address spender, uint256 subtractedValue) public override returns (bool) {
1090         if (isOperator(spender)) {
1091             // bypass the internal allowance manipulation and checks for the
1092             // whitelisted operator (i.e. spender). as a side-effect, the
1093             // 'Approval' event will not be emitted since the allowance was not
1094             // updated.
1095             return true;
1096         } else {
1097             return super.decreaseAllowance(spender, subtractedValue);
1098         }
1099     }
1100 
1101     function _approve(address owner, address spender, uint256 value) internal override {
1102         if (isOperator(spender)) {
1103             // bypass the internal allowance manipulation and checks for the
1104             // whitelisted operator (i.e. spender). as a side-effect, the
1105             // 'Approval' event will not be emitted since the allowance was not
1106             // updated.
1107             return;
1108         } else {
1109             super._approve(owner, spender, value);
1110         }
1111     }
1112 }
1113 
1114 
1115 // File contracts/solc-0.6/token/ERC20/GAMEE.sol
1116 
1117 pragma solidity 0.6.8;
1118 
1119 /**
1120  * @title GAMEE
1121  */
1122 contract GAMEE is ERC20WithOperators {
1123     // solhint-disable-next-line const-name-snakecase
1124     string public constant override name = "GAMEE";
1125     // solhint-disable-next-line const-name-snakecase
1126     string public constant override symbol = "GMEE";
1127     // solhint-disable-next-line const-name-snakecase
1128     uint8 public constant override decimals = 18;
1129 
1130     constructor(address[] memory holders, uint256[] memory amounts) public ERC20WithOperators() {
1131         require(holders.length == amounts.length, "GAMEE: inconsistent arrays");
1132         for (uint256 i = 0; i != holders.length; ++i) {
1133             _mint(holders[i], amounts[i]);
1134         }
1135     }
1136 }