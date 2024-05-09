1 // Sources flattened with buidler v1.3.8 https://buidler.dev
2 
3 // SPDX-License-Identifier: MIT
4 
5 // File @openzeppelin/contracts/GSN/Context.sol@v3.1.0
6 
7 pragma solidity ^0.6.0;
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
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.1.0
32 
33 pragma solidity ^0.6.0;
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
47 contract Ownable is Context {
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
100 // File @animoca/ethereum-contracts-core_library/contracts/access/WhitelistedOperators.sol@v3.0.0
101 
102 pragma solidity 0.6.8;
103 
104 
105 contract WhitelistedOperators is Ownable {
106 
107     mapping(address => bool) internal _whitelistedOperators;
108 
109     event WhitelistedOperator(address operator, bool enabled);
110 
111     /// @notice Enable or disable address operator access
112     /// @param operator address that will be given/removed operator right.
113     /// @param enabled set whether the operator is enabled or disabled.
114     function whitelistOperator(address operator, bool enabled) external onlyOwner {
115         _whitelistedOperators[operator] = enabled;
116         emit WhitelistedOperator(operator, enabled);
117     }
118 
119     /// @notice check whether address `who` is given operator rights.
120     /// @param who The address to query.
121     /// @return whether the address is whitelisted operator
122     function isOperator(address who) public view returns (bool) {
123         return _whitelistedOperators[who];
124     }
125 }
126 
127 
128 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.1.0
129 
130 pragma solidity ^0.6.0;
131 
132 /**
133  * @dev Interface of the ERC165 standard, as defined in the
134  * https://eips.ethereum.org/EIPS/eip-165[EIP].
135  *
136  * Implementers can declare support of contract interfaces, which can then be
137  * queried by others ({ERC165Checker}).
138  *
139  * For an implementation, see {ERC165}.
140  */
141 interface IERC165 {
142     /**
143      * @dev Returns true if this contract implements the interface defined by
144      * `interfaceId`. See the corresponding
145      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
146      * to learn more about how these ids are created.
147      *
148      * This function call must use less than 30 000 gas.
149      */
150     function supportsInterface(bytes4 interfaceId) external view returns (bool);
151 }
152 
153 
154 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.1.0
155 
156 pragma solidity ^0.6.0;
157 
158 
159 /**
160  * @dev Implementation of the {IERC165} interface.
161  *
162  * Contracts may inherit from this and call {_registerInterface} to declare
163  * their support of an interface.
164  */
165 contract ERC165 is IERC165 {
166     /*
167      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
168      */
169     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
170 
171     /**
172      * @dev Mapping of interface ids to whether or not it's supported.
173      */
174     mapping(bytes4 => bool) private _supportedInterfaces;
175 
176     constructor () internal {
177         // Derived contracts need only register support for their own interfaces,
178         // we register support for ERC165 itself here
179         _registerInterface(_INTERFACE_ID_ERC165);
180     }
181 
182     /**
183      * @dev See {IERC165-supportsInterface}.
184      *
185      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
186      */
187     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
188         return _supportedInterfaces[interfaceId];
189     }
190 
191     /**
192      * @dev Registers the contract as an implementer of the interface defined by
193      * `interfaceId`. Support of the actual ERC165 interface is automatic and
194      * registering its interface id is not required.
195      *
196      * See {IERC165-supportsInterface}.
197      *
198      * Requirements:
199      *
200      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
201      */
202     function _registerInterface(bytes4 interfaceId) internal virtual {
203         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
204         _supportedInterfaces[interfaceId] = true;
205     }
206 }
207 
208 
209 // File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0
210 
211 pragma solidity ^0.6.0;
212 
213 /**
214  * @dev Wrappers over Solidity's arithmetic operations with added overflow
215  * checks.
216  *
217  * Arithmetic operations in Solidity wrap on overflow. This can easily result
218  * in bugs, because programmers usually assume that an overflow raises an
219  * error, which is the standard behavior in high level programming languages.
220  * `SafeMath` restores this intuition by reverting the transaction when an
221  * operation overflows.
222  *
223  * Using this library instead of the unchecked operations eliminates an entire
224  * class of bugs, so it's recommended to use it always.
225  */
226 library SafeMath {
227     /**
228      * @dev Returns the addition of two unsigned integers, reverting on
229      * overflow.
230      *
231      * Counterpart to Solidity's `+` operator.
232      *
233      * Requirements:
234      *
235      * - Addition cannot overflow.
236      */
237     function add(uint256 a, uint256 b) internal pure returns (uint256) {
238         uint256 c = a + b;
239         require(c >= a, "SafeMath: addition overflow");
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting on
246      * overflow (when the result is negative).
247      *
248      * Counterpart to Solidity's `-` operator.
249      *
250      * Requirements:
251      *
252      * - Subtraction cannot overflow.
253      */
254     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
255         return sub(a, b, "SafeMath: subtraction overflow");
256     }
257 
258     /**
259      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
260      * overflow (when the result is negative).
261      *
262      * Counterpart to Solidity's `-` operator.
263      *
264      * Requirements:
265      *
266      * - Subtraction cannot overflow.
267      */
268     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b <= a, errorMessage);
270         uint256 c = a - b;
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the multiplication of two unsigned integers, reverting on
277      * overflow.
278      *
279      * Counterpart to Solidity's `*` operator.
280      *
281      * Requirements:
282      *
283      * - Multiplication cannot overflow.
284      */
285     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
286         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
287         // benefit is lost if 'b' is also tested.
288         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
289         if (a == 0) {
290             return 0;
291         }
292 
293         uint256 c = a * b;
294         require(c / a == b, "SafeMath: multiplication overflow");
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the integer division of two unsigned integers. Reverts on
301      * division by zero. The result is rounded towards zero.
302      *
303      * Counterpart to Solidity's `/` operator. Note: this function uses a
304      * `revert` opcode (which leaves remaining gas untouched) while Solidity
305      * uses an invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function div(uint256 a, uint256 b) internal pure returns (uint256) {
312         return div(a, b, "SafeMath: division by zero");
313     }
314 
315     /**
316      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
317      * division by zero. The result is rounded towards zero.
318      *
319      * Counterpart to Solidity's `/` operator. Note: this function uses a
320      * `revert` opcode (which leaves remaining gas untouched) while Solidity
321      * uses an invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b > 0, errorMessage);
329         uint256 c = a / b;
330         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
331 
332         return c;
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
337      * Reverts when dividing by zero.
338      *
339      * Counterpart to Solidity's `%` operator. This function uses a `revert`
340      * opcode (which leaves remaining gas untouched) while Solidity uses an
341      * invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      *
345      * - The divisor cannot be zero.
346      */
347     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
348         return mod(a, b, "SafeMath: modulo by zero");
349     }
350 
351     /**
352      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
353      * Reverts with custom message when dividing by zero.
354      *
355      * Counterpart to Solidity's `%` operator. This function uses a `revert`
356      * opcode (which leaves remaining gas untouched) while Solidity uses an
357      * invalid opcode to revert (consuming all remaining gas).
358      *
359      * Requirements:
360      *
361      * - The divisor cannot be zero.
362      */
363     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
364         require(b != 0, errorMessage);
365         return a % b;
366     }
367 }
368 
369 
370 // File @openzeppelin/contracts/utils/Address.sol@v3.1.0
371 
372 pragma solidity ^0.6.2;
373 
374 /**
375  * @dev Collection of functions related to the address type
376  */
377 library Address {
378     /**
379      * @dev Returns true if `account` is a contract.
380      *
381      * [IMPORTANT]
382      * ====
383      * It is unsafe to assume that an address for which this function returns
384      * false is an externally-owned account (EOA) and not a contract.
385      *
386      * Among others, `isContract` will return false for the following
387      * types of addresses:
388      *
389      *  - an externally-owned account
390      *  - a contract in construction
391      *  - an address where a contract will be created
392      *  - an address where a contract lived, but was destroyed
393      * ====
394      */
395     function isContract(address account) internal view returns (bool) {
396         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
397         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
398         // for accounts without code, i.e. `keccak256('')`
399         bytes32 codehash;
400         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
401         // solhint-disable-next-line no-inline-assembly
402         assembly { codehash := extcodehash(account) }
403         return (codehash != accountHash && codehash != 0x0);
404     }
405 
406     /**
407      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
408      * `recipient`, forwarding all available gas and reverting on errors.
409      *
410      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
411      * of certain opcodes, possibly making contracts go over the 2300 gas limit
412      * imposed by `transfer`, making them unable to receive funds via
413      * `transfer`. {sendValue} removes this limitation.
414      *
415      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
416      *
417      * IMPORTANT: because control is transferred to `recipient`, care must be
418      * taken to not create reentrancy vulnerabilities. Consider using
419      * {ReentrancyGuard} or the
420      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
421      */
422     function sendValue(address payable recipient, uint256 amount) internal {
423         require(address(this).balance >= amount, "Address: insufficient balance");
424 
425         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
426         (bool success, ) = recipient.call{ value: amount }("");
427         require(success, "Address: unable to send value, recipient may have reverted");
428     }
429 
430     /**
431      * @dev Performs a Solidity function call using a low level `call`. A
432      * plain`call` is an unsafe replacement for a function call: use this
433      * function instead.
434      *
435      * If `target` reverts with a revert reason, it is bubbled up by this
436      * function (like regular Solidity function calls).
437      *
438      * Returns the raw returned data. To convert to the expected return value,
439      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
440      *
441      * Requirements:
442      *
443      * - `target` must be a contract.
444      * - calling `target` with `data` must not revert.
445      *
446      * _Available since v3.1._
447      */
448     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
449       return functionCall(target, data, "Address: low-level call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
454      * `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
459         return _functionCallWithValue(target, data, 0, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but also transferring `value` wei to `target`.
465      *
466      * Requirements:
467      *
468      * - the calling contract must have an ETH balance of at least `value`.
469      * - the called Solidity function must be `payable`.
470      *
471      * _Available since v3.1._
472      */
473     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
474         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
479      * with `errorMessage` as a fallback revert reason when `target` reverts.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
484         require(address(this).balance >= value, "Address: insufficient balance for call");
485         return _functionCallWithValue(target, data, value, errorMessage);
486     }
487 
488     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
489         require(isContract(target), "Address: call to non-contract");
490 
491         // solhint-disable-next-line avoid-low-level-calls
492         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
493         if (success) {
494             return returndata;
495         } else {
496             // Look for revert reason and bubble it up if present
497             if (returndata.length > 0) {
498                 // The easiest way to bubble the revert reason is using memory via assembly
499 
500                 // solhint-disable-next-line no-inline-assembly
501                 assembly {
502                     let returndata_size := mload(returndata)
503                     revert(add(32, returndata), returndata_size)
504                 }
505             } else {
506                 revert(errorMessage);
507             }
508         }
509     }
510 }
511 
512 
513 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20.sol@v3.0.0
514 
515 /*
516 https://github.com/OpenZeppelin/openzeppelin-contracts
517 
518 The MIT License (MIT)
519 
520 Copyright (c) 2016-2019 zOS Global Limited
521 
522 Permission is hereby granted, free of charge, to any person obtaining
523 a copy of this software and associated documentation files (the
524 "Software"), to deal in the Software without restriction, including
525 without limitation the rights to use, copy, modify, merge, publish,
526 distribute, sublicense, and/or sell copies of the Software, and to
527 permit persons to whom the Software is furnished to do so, subject to
528 the following conditions:
529 
530 The above copyright notice and this permission notice shall be included
531 in all copies or substantial portions of the Software.
532 
533 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
534 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
535 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
536 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
537 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
538 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
539 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
540 */
541 
542 pragma solidity 0.6.8;
543 
544 /**
545  * @dev Interface of the ERC20 standard as defined in the EIP.
546  */
547 interface IERC20 {
548 
549     /**
550      * @dev Emitted when `value` tokens are moved from one account (`from`) to
551      * another (`to`).
552      *
553      * Note that `value` may be zero.
554      */
555     event Transfer(
556         address indexed _from,
557         address indexed _to,
558         uint256 _value
559     );
560 
561     /**
562      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
563      * a call to {approve}. `value` is the new allowance.
564      */
565     event Approval(
566         address indexed _owner,
567         address indexed _spender,
568         uint256 _value
569     );
570 
571     /**
572      * @dev Returns the amount of tokens in existence.
573      */
574     function totalSupply() external view returns (uint256);
575 
576     /**
577      * @dev Returns the amount of tokens owned by `account`.
578      */
579     function balanceOf(address account) external view returns (uint256);
580 
581     /**
582      * @dev Moves `amount` tokens from the caller's account to `recipient`.
583      *
584      * Returns a boolean value indicating whether the operation succeeded.
585      *
586      * Emits a {Transfer} event.
587      */
588     function transfer(address recipient, uint256 amount) external returns (bool);
589 
590     /**
591      * @dev Returns the remaining number of tokens that `spender` will be
592      * allowed to spend on behalf of `owner` through {transferFrom}. This is
593      * zero by default.
594      *
595      * This value changes when {approve} or {transferFrom} are called.
596      */
597     function allowance(address owner, address spender) external view returns (uint256);
598 
599     /**
600      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
601      *
602      * Returns a boolean value indicating whether the operation succeeded.
603      *
604      * IMPORTANT: Beware that changing an allowance with this method brings the risk
605      * that someone may use both the old and the new allowance by unfortunate
606      * transaction ordering. One possible solution to mitigate this race
607      * condition is to first reduce the spender's allowance to 0 and set the
608      * desired value afterwards:
609      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
610      *
611      * Emits an {Approval} event.
612      */
613     function approve(address spender, uint256 amount) external returns (bool);
614 
615     /**
616      * @dev Moves `amount` tokens from `sender` to `recipient` using the
617      * allowance mechanism. `amount` is then deducted from the caller's
618      * allowance.
619      *
620      * Returns a boolean value indicating whether the operation succeeded.
621      *
622      * Emits a {Transfer} event.
623      */
624     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
625 }
626 
627 
628 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20Detailed.sol@v3.0.0
629 
630 /*
631 https://github.com/OpenZeppelin/openzeppelin-contracts
632 
633 The MIT License (MIT)
634 
635 Copyright (c) 2016-2019 zOS Global Limited
636 
637 Permission is hereby granted, free of charge, to any person obtaining
638 a copy of this software and associated documentation files (the
639 "Software"), to deal in the Software without restriction, including
640 without limitation the rights to use, copy, modify, merge, publish,
641 distribute, sublicense, and/or sell copies of the Software, and to
642 permit persons to whom the Software is furnished to do so, subject to
643 the following conditions:
644 
645 The above copyright notice and this permission notice shall be included
646 in all copies or substantial portions of the Software.
647 
648 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
649 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
650 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
651 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
652 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
653 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
654 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
655 */
656 
657 pragma solidity 0.6.8;
658 
659 /**
660  * @dev Interface for commonly used additional ERC20 interfaces
661  */
662 interface IERC20Detailed {
663 
664     /**
665      * @dev Returns the name of the token.
666      */
667     function name() external view returns (string memory);
668 
669     /**
670      * @dev Returns the symbol of the token, usually a shorter version of the
671      * name.
672      */
673     function symbol() external view returns (string memory);
674 
675     /**
676      * @dev Returns the number of decimals used to get its user representation.
677      * For example, if `decimals` equals `2`, a balance of `505` tokens should
678      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
679      *
680      * Tokens usually opt for a value of 18, imitating the relationship between
681      * Ether and Wei. This is the value {ERC20} uses.
682      *
683      * NOTE: This information is only used for _display_ purposes: it in
684      * no way affects any of the arithmetic of the contract, including
685      * {IERC20-balanceOf} and {IERC20-transfer}.
686      */
687     function decimals() external view returns (uint8);
688 }
689 
690 
691 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20Allowance.sol@v3.0.0
692 
693 pragma solidity 0.6.8;
694 
695 /**
696  * @dev Interface for additional ERC20 allowance features
697  */
698 interface IERC20Allowance {
699 
700     /**
701      * @dev Atomically increases the allowance granted to `spender` by the caller.
702      *
703      * This is an alternative to {approve} that can be used as a mitigation for
704      * problems described in {IERC20-approve}.
705      *
706      * Emits an {Approval} event indicating the updated allowance.
707      *
708      * Requirements:
709      *
710      * - `spender` cannot be the zero address.
711      */
712     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
713 
714     /**
715      * @dev Atomically decreases the allowance granted to `spender` by the caller.
716      *
717      * This is an alternative to {approve} that can be used as a mitigation for
718      * problems described in {IERC20-approve}.
719      *
720      * Emits an {Approval} event indicating the updated allowance.
721      *
722      * Requirements:
723      *
724      * - `spender` cannot be the zero address.
725      * - `spender` must have allowance for the caller of at least
726      * `subtractedValue`.
727      */
728     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
729 
730 }
731 
732 
733 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/ERC20.sol@v3.0.0
734 
735 /*
736 https://github.com/OpenZeppelin/openzeppelin-contracts
737 
738 The MIT License (MIT)
739 
740 Copyright (c) 2016-2019 zOS Global Limited
741 
742 Permission is hereby granted, free of charge, to any person obtaining
743 a copy of this software and associated documentation files (the
744 "Software"), to deal in the Software without restriction, including
745 without limitation the rights to use, copy, modify, merge, publish,
746 distribute, sublicense, and/or sell copies of the Software, and to
747 permit persons to whom the Software is furnished to do so, subject to
748 the following conditions:
749 
750 The above copyright notice and this permission notice shall be included
751 in all copies or substantial portions of the Software.
752 
753 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
754 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
755 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
756 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
757 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
758 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
759 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
760 */
761 
762 pragma solidity 0.6.8;
763 
764 
765 
766 
767 
768 
769 
770 
771 /**
772  * @dev Implementation of the {IERC20} interface.
773  *
774  * This implementation is agnostic to the way tokens are created. This means
775  * that a supply mechanism has to be added in a derived contract using {_mint}.
776  * For a generic mechanism see {ERC20MinterPauser}.
777  *
778  * TIP: For a detailed writeup see our guide
779  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
780  * to implement supply mechanisms].
781  *
782  * We have followed general OpenZeppelin guidelines: functions revert instead
783  * of returning `false` on failure. This behavior is nonetheless conventional
784  * and does not conflict with the expectations of ERC20 applications.
785  *
786  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
787  * This allows applications to reconstruct the allowance for all accounts just
788  * by listening to said events. Other implementations of the EIP may not emit
789  * these events, as it isn't required by the specification.
790  *
791  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
792  * functions have been added to mitigate the well-known issues around setting
793  * allowances. See {IERC20-approve}.
794  */
795 abstract contract ERC20 is ERC165, Context, IERC20, IERC20Detailed, IERC20Allowance {
796 
797     using SafeMath for uint256;
798     using Address for address;
799 
800     mapping (address => uint256) internal _balances;
801     mapping (address => mapping (address => uint256)) internal _allowances;
802     uint256 internal _totalSupply;
803 
804     constructor() internal {
805         _registerInterface(type(IERC20).interfaceId);
806         _registerInterface(type(IERC20Detailed).interfaceId);
807         _registerInterface(type(IERC20Allowance).interfaceId);
808 
809         // ERC20Name interfaceId: bytes4(keccak256("name()"))
810         _registerInterface(0x06fdde03);
811         // ERC20Symbol interfaceId: bytes4(keccak256("symbol()"))
812         _registerInterface(0x95d89b41);
813         // ERC20Decimals interfaceId: bytes4(keccak256("decimals()"))
814         _registerInterface(0x313ce567);
815     }
816 
817 /////////////////////////////////////////// ERC20 ///////////////////////////////////////
818 
819     /**
820      * @dev See {IERC20-totalSupply}.
821      */
822     function totalSupply() public view override returns (uint256) {
823         return _totalSupply;
824     }
825 
826     /**
827      * @dev See {IERC20-balanceOf}.
828      */
829     function balanceOf(address account) public view override returns (uint256) {
830         return _balances[account];
831     }
832 
833     /**
834      * @dev See {IERC20-transfer}.
835      *
836      * Requirements:
837      *
838      * - `recipient` cannot be the zero address.
839      * - the caller must have a balance of at least `amount`.
840      */
841     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
842         _transfer(_msgSender(), recipient, amount);
843         return true;
844     }
845 
846     /**
847      * @dev See {IERC20-allowance}.
848      */
849     function allowance(address owner, address spender) public view virtual override returns (uint256) {
850         return _allowances[owner][spender];
851     }
852 
853     /**
854      * @dev See {IERC20-approve}.
855      *
856      * Requirements:
857      *
858      * - `spender` cannot be the zero address.
859      */
860     function approve(address spender, uint256 amount) public virtual override returns (bool) {
861         _approve(_msgSender(), spender, amount);
862         return true;
863     }
864 
865     /**
866      * @dev See {IERC20-transferFrom}.
867      *
868      * Emits an {Approval} event indicating the updated allowance. This is not
869      * required by the EIP. See the note at the beginning of {ERC20};
870      *
871      * Requirements:
872      * - `sender` and `recipient` cannot be the zero address.
873      * - `sender` must have a balance of at least `amount`.
874      * - the caller must have allowance for ``sender``'s tokens of at least
875      * `amount`.
876      */
877     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
878         _transfer(sender, recipient, amount);
879         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
880         return true;
881     }
882 
883 /////////////////////////////////////////// ERC20Allowance ///////////////////////////////////////
884 
885     /**
886      * @dev See {IERC20Allowance-increaseAllowance}.
887      */
888     function increaseAllowance(
889         address spender,
890         uint256 addedValue
891     ) public virtual override returns (bool)
892     {
893         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
894         return true;
895     }
896 
897     /**
898      * @dev See {IERC20Allowance-decreaseAllowance}.
899      */
900     function decreaseAllowance(
901         address spender,
902         uint256 subtractedValue
903     ) public virtual override returns (bool)
904     {
905         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
906         return true;
907     }
908 
909 /////////////////////////////////////////// Internal Functions ///////////////////////////////////////
910 
911     /**
912      * @dev Moves tokens `amount` from `sender` to `recipient`.
913      *
914      * This is internal function is equivalent to {transfer}, and can be used to
915      * e.g. implement automatic token fees, slashing mechanisms, etc.
916      *
917      * Emits a {Transfer} event.
918      *
919      * Requirements:
920      *
921      * - `sender` cannot be the zero address.
922      * - `recipient` cannot be the zero address.
923      * - `sender` must have a balance of at least `amount`.
924      */
925     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
926         require(sender != address(0), "ERC20: transfer from the zero address");
927         require(recipient != address(0), "ERC20: transfer to the zero address");
928 
929         _beforeTokenTransfer(sender, recipient, amount);
930 
931         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
932         _balances[recipient] = _balances[recipient].add(amount);
933         emit Transfer(sender, recipient, amount);
934     }
935 
936     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
937      * the total supply.
938      *
939      * Emits a {Transfer} event with `from` set to the zero address.
940      *
941      * Requirements
942      *
943      * - `to` cannot be the zero address.
944      */
945     function _mint(address account, uint256 amount) internal virtual {
946         require(account != address(0), "ERC20: mint to the zero address");
947 
948         _beforeTokenTransfer(address(0), account, amount);
949 
950         _totalSupply = _totalSupply.add(amount);
951         _balances[account] = _balances[account].add(amount);
952         emit Transfer(address(0), account, amount);
953     }
954 
955     /**
956      * @dev Destroys `amount` tokens from `account`, reducing the
957      * total supply.
958      *
959      * Emits a {Transfer} event with `to` set to the zero address.
960      *
961      * Requirements
962      *
963      * - `account` cannot be the zero address.
964      * - `account` must have at least `amount` tokens.
965      */
966     function _burn(address account, uint256 amount) internal virtual {
967         require(account != address(0), "ERC20: burn from the zero address");
968 
969         _beforeTokenTransfer(account, address(0), amount);
970 
971         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
972         _totalSupply = _totalSupply.sub(amount);
973         emit Transfer(account, address(0), amount);
974     }
975 
976     /**
977      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
978      *
979      * This is internal function is equivalent to `approve`, and can be used to
980      * e.g. set automatic allowances for certain subsystems, etc.
981      *
982      * Emits an {Approval} event.
983      *
984      * Requirements:
985      *
986      * - `owner` cannot be the zero address.
987      * - `spender` cannot be the zero address.
988      */
989     function _approve(address owner, address spender, uint256 amount) internal virtual {
990         require(owner != address(0), "ERC20: approve from the zero address");
991         require(spender != address(0), "ERC20: approve to the zero address");
992 
993         _allowances[owner][spender] = amount;
994         emit Approval(owner, spender, amount);
995     }
996 
997 /////////////////////////////////////////// Hooks ///////////////////////////////////////
998 
999     /**
1000      * @dev Hook that is called before any transfer of tokens. This includes
1001      * minting and burning.
1002      *
1003      * Calling conditions:
1004      *
1005      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1006      * will be to transferred to `to`.
1007      * - when `from` is zero, `amount` tokens will be minted for `to`.
1008      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1009      * - `from` and `to` are never both zero.
1010      */
1011     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1012 }
1013 
1014 
1015 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/ERC20WithOperators.sol@v3.0.0
1016 
1017 pragma solidity 0.6.8;
1018 
1019 
1020 
1021 abstract contract ERC20WithOperators is ERC20, WhitelistedOperators {
1022 
1023     /**
1024      * NOTICE
1025      * This override will allow *any* whitelisted operator to be able to
1026      * transfer unresitricted amounts of ERC20WithOperators-based tokens from 'sender'
1027      * to 'recipient'. Care must be taken to ensure to integrity of the
1028      * whitelisted operator list.
1029      */
1030     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1031         address msgSender = _msgSender();
1032 
1033         // bypass the internal allowance manipulation and checks for the
1034         // whitelisted operator (i.e. _msgSender()). as a side-effect, the
1035         // 'Approval' event will not be emitted since the allowance was not
1036         // updated.
1037         if (!isOperator(msgSender)) {
1038             _approve(sender, msgSender, allowance(sender, msgSender).sub(amount));
1039         }
1040 
1041         _transfer(sender, recipient, amount);
1042         return true;
1043     }
1044 
1045     function allowance(address owner, address spender) public override view returns (uint256) {
1046         if (isOperator(spender)) {
1047             // allow the front-end to determine whether or not an approval is
1048             // necessary, given that the whitelisted operator status of the
1049             // spender is unknown. A call to WhitelistedOperators::isOperator()
1050             // is more direct, but we want to expose a mechanism by which to
1051             // check through the ERC20 interface.
1052             return type(uint256).max;
1053         } else {
1054             return super.allowance(owner, spender);
1055         }
1056     }
1057 
1058     function increaseAllowance(address spender, uint256 addedValue) public override returns (bool) {
1059         if (isOperator(spender)) {
1060             // bypass the internal allowance manipulation and checks for the
1061             // whitelisted operator (i.e. spender). as a side-effect, the
1062             // 'Approval' event will not be emitted since the allowance was not
1063             // updated.
1064             return true;
1065         } else {
1066             return super.increaseAllowance(spender, addedValue);
1067         }
1068     }
1069 
1070     function decreaseAllowance(address spender, uint256 subtractedValue) public override returns (bool) {
1071         if (isOperator(spender)) {
1072             // bypass the internal allowance manipulation and checks for the
1073             // whitelisted operator (i.e. spender). as a side-effect, the
1074             // 'Approval' event will not be emitted since the allowance was not
1075             // updated.
1076             return true;
1077         } else {
1078             return super.decreaseAllowance(spender, subtractedValue);
1079         }
1080     }
1081 
1082     function _approve(address owner, address spender, uint256 value) internal override {
1083         if (isOperator(spender)) {
1084             // bypass the internal allowance manipulation and checks for the
1085             // whitelisted operator (i.e. spender). as a side-effect, the
1086             // 'Approval' event will not be emitted since the allowance was not
1087             // updated.
1088             return;
1089         } else {
1090             super._approve(owner, spender, value);
1091         }
1092     }
1093 }
1094 
1095 
1096 // File @animoca/f1dt-ethereum-contracts/contracts/token/ERC20/REVV.sol@v0.1.0
1097 
1098 pragma solidity 0.6.8;
1099 
1100 
1101 contract REVV is ERC20WithOperators {
1102 
1103     string public override constant name = "REVV";
1104     string public override constant symbol = "REVV";
1105     uint8 public override constant decimals = 18;
1106 
1107     constructor (
1108         address[] memory holders,
1109         uint256[] memory amounts
1110     ) public ERC20WithOperators()
1111     {
1112         require(holders.length == amounts.length, "REVV: wrong arguments");
1113         for (uint256 i = 0; i < holders.length; ++i) {
1114             _mint(holders[i], amounts[i]);
1115         }
1116     }
1117 }